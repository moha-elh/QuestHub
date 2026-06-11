/**
 * QuestHub Cloud Function — quest assignment on game start.
 *
 * Triggers on room document update. When status transitions from "waiting"
 * to "in_progress", picks N unique quests (N = player count) from the bank
 * and writes each player's assignment to rooms/{roomId}/quests/{userId}.
 *
 * Not deployed yet: requires a Firebase project on the Blaze plan.
 * Deploy with: cd functions && npm install && npm run deploy
 */
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";

import { questBank } from "./quest_bank";

const db = getFirestore();

/**
 * Fisher-Yates (Knuth) shuffle — returns a new shuffled array.
 */
function shuffle<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

export const assignQuestsOnStart = onDocumentUpdated(
  "rooms/{roomId}",
  async (event) => {
    const before = event.data?.before;
    const after = event.data?.after;
    if (!before?.exists || !after?.exists) return;

    const beforeData = before.data();
    const afterData = after.data();

    // Only trigger on status change from waiting → in_progress.
    if (
      beforeData.status !== "waiting" ||
      afterData.status !== "in_progress"
    ) {
      return;
    }

    const playerIds = Object.keys(afterData.players ?? {});
    if (playerIds.length === 0) {
      logger.warn(
        `Room ${event.params.roomId} has no players — skipping quest assignment`
      );
      return;
    }

    if (playerIds.length > questBank.length) {
      logger.warn(
        `Room ${event.params.roomId} has ${playerIds.length} players but only ${questBank.length} quests — reusing quests` // not expected with maxPlayers=8 and 32 quests
      );
    }

    // Shuffle and pick N quests.
    const shuffled = shuffle(questBank);
    const assignments = playerIds.map((uid, index) => ({
      uid,
      quest: shuffled[index % shuffled.length],
    }));

    // Batch-write assignments.
    const batch = db.batch();
    const roomRef = db.collection("rooms").doc(event.params.roomId);
    const questsCol = roomRef.collection("quests");

    for (const { uid, quest } of assignments) {
      batch.set(questsCol.doc(uid), {
        questId: quest.id,
        title: quest.title,
        description: quest.description,
        difficulty: quest.difficulty,
        points: quest.points,
        durationSeconds: quest.durationSeconds,
        category: quest.category,
        assignedAt: FieldValue.serverTimestamp(),
        status: "active",
      });
    }

    await batch.commit();

    logger.info(
      `Room ${event.params.roomId}: assigned ${assignments.length} quest(s) to ${playerIds.length} player(s)`
    );
  }
);
