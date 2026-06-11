/**
 * QuestHub Cloud Functions — lobby edge cases & quest assignment.
 *
 * Not deployed yet: requires a Firebase project on the Blaze plan.
 * Deploy with: cd functions && npm install && npm run deploy
 */
import { initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/v2";

initializeApp();
const db = getFirestore();

export { assignQuestsOnStart } from "./assign_quests";

interface RoomPlayer {
  displayName: string;
  joinedAt: string; // ISO-8601, written by the app
  lastSeenAt: string;
  isReady: boolean;
  score: number;
}

/**
 * Backup for the client-side host handoff: if a room update leaves the
 * `hostId` pointing at a player who is no longer in the `players` map
 * (host crashed / lost connection and was evicted), promote the earliest
 * joiner. Deletes the room when nobody is left.
 */
export const reassignHostOnLeave = onDocumentUpdated(
  "rooms/{roomId}",
  async (event) => {
    const after = event.data?.after;
    if (!after?.exists) return;

    const room = after.data() as {
      hostId: string;
      players: Record<string, RoomPlayer>;
    };
    const playerIds = Object.keys(room.players ?? {});

    if (playerIds.length === 0) {
      logger.info(`Room ${event.params.roomId} empty — deleting`);
      await after.ref.delete();
      return;
    }
    if (playerIds.includes(room.hostId)) return; // host still present

    const nextHost = playerIds.sort((a, b) =>
      room.players[a].joinedAt.localeCompare(room.players[b].joinedAt)
    )[0];
    logger.info(`Room ${event.params.roomId}: promoting ${nextHost} to host`);
    await after.ref.update({ hostId: nextHost });
  }
);

/**
 * Evicts players from waiting lobbies when their heartbeat goes stale.
 *
 * The app bumps `players.{uid}.lastSeenAt` every 10s while the lobby is
 * open. NOTE: the spec asks for removal after 10s of disconnection; a
 * scheduled function can only achieve ~minute granularity. True 10s presence
 * requires Realtime Database `onDisconnect` mirroring — TODO when realtime
 * infra lands. Until then: stale = no heartbeat for 30s, checked every minute.
 */
export const cleanupStalePlayers = onSchedule("every 1 minutes", async () => {
  const staleBefore = new Date(Date.now() - 30_000).toISOString();
  const waitingRooms = await db
    .collection("rooms")
    .where("status", "==", "waiting")
    .get();

  for (const doc of waitingRooms.docs) {
    const room = doc.data() as { players: Record<string, RoomPlayer> };
    const stale = Object.entries(room.players ?? {}).filter(
      ([, p]) => p.lastSeenAt < staleBefore
    );
    if (stale.length === 0) continue;

    const updates: Record<string, unknown> = {};
    for (const [uid] of stale) {
      updates[`players.${uid}`] = FieldValue.delete();
    }
    logger.info(`Room ${doc.id}: evicting ${stale.length} stale player(s)`);
    await doc.ref.update(updates);
    // reassignHostOnLeave picks up host promotion / empty-room deletion.
  }
});
