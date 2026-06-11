import '../../features/quest/domain/quest.dart';

final List<Quest> questBank = [
  // ── Easy / Physical ──
  Quest(
    id: 'e-phy-01',
    title: 'Do 10 jumping jacks in a public space',
    description:
        'Get someone to count for you — they must be visible in the photo.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.physical,
    tags: ['public', 'exercise'],
  ),
  Quest(
    id: 'e-phy-02',
    title: 'Balance a book on your head for 30 seconds',
    description:
        'Take a photo mid-balance with both hands clearly away.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.physical,
    tags: ['balance', 'silly'],
  ),
  // ── Easy / Social ──
  Quest(
    id: 'e-soc-01',
    title: "Compliment a stranger's outfit",
    description:
        'They must pose for the photo afterwards. Show both of you smiling.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.social,
    tags: ['stranger', 'compliment'],
  ),
  Quest(
    id: 'e-soc-02',
    title: 'Get a high-five from a passerby',
    description:
        'The hand-slap must be caught mid-air in the photo.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.social,
    tags: ['stranger', 'high-five'],
  ),
  // ── Easy / Creative ──
  Quest(
    id: 'e-cre-01',
    title: 'Draw a smiley face on a napkin and give it away',
    description:
        'Photograph the napkin in someone else\'s hand.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.creative,
    tags: ['drawing', 'gift'],
  ),
  Quest(
    id: 'e-cre-02',
    title: 'Make an origami paper crane in under 2 minutes',
    description:
        'Show the finished crane on your palm.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.creative,
    tags: ['origami', 'craft'],
  ),
  // ── Easy / Stealth ──
  Quest(
    id: 'e-stl-01',
    title: 'Hide behind a public notice board for 10 seconds',
    description:
        'Take a selfie peeking out from behind it.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.stealth,
    tags: ['hide', 'public'],
  ),
  Quest(
    id: 'e-stl-02',
    title: 'Walk past the same store window 3 times without stopping',
    description:
        'A reflection photo proving all three passes.',
    difficulty: QuestDifficulty.easy,
    category: QuestCategory.stealth,
    tags: ['recon', 'public'],
  ),

  // ── Medium / Physical ──
  Quest(
    id: 'm-phy-01',
    title: 'Hold a plank for 45 seconds in a park',
    description:
        'Someone must be counting down for you in the frame.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.physical,
    tags: ['exercise', 'public'],
  ),
  Quest(
    id: 'm-phy-02',
    title: 'Skip rope 15 times without tripping',
    description:
        'Catch the rope mid-swing in the photo.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.physical,
    tags: ['exercise', 'skill'],
  ),
  // ── Medium / Social ──
  Quest(
    id: 'm-soc-01',
    title: 'Get a stranger to teach you a local dance move',
    description:
        'Photo of you both doing the move together.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.social,
    tags: ['stranger', 'dance'],
  ),
  Quest(
    id: 'm-soc-02',
    title: 'Convince a stranger to high-five you',
    description:
        'They must be smiling in the photo.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.social,
    tags: ['stranger', 'high-five'],
  ),
  // ── Medium / Creative ──
  Quest(
    id: 'm-cre-01',
    title: 'Write a 4-line poem about a stranger and read it to them',
    description:
        'Capture them holding the poem.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.creative,
    tags: ['poem', 'stranger'],
  ),
  Quest(
    id: 'm-cre-02',
    title: 'Chalk-art a hopscotch grid on the pavement',
    description:
        'Photo of the completed grid with your foot on the last square.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.creative,
    tags: ['art', 'public'],
  ),
  // ── Medium / Stealth ──
  Quest(
    id: 'm-stl-01',
    title: "Mirror a stranger's pose without them noticing",
    description:
        'Take a photo where you are in the background mimicking their pose.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.stealth,
    tags: ['mimic', 'public'],
  ),
  Quest(
    id: 'm-stl-02',
    title: 'Eavesdrop on a conversation and report the topic',
    description:
        'Write it down and photograph the note with the people in the background.',
    difficulty: QuestDifficulty.medium,
    category: QuestCategory.stealth,
    tags: ['eavesdrop', 'public'],
  ),

  // ── Hard / Physical ──
  Quest(
    id: 'h-phy-01',
    title: 'Do 20 push-ups in a busy plaza',
    description:
        'Someone must be visibly counting in the background.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.physical,
    tags: ['exercise', 'public', 'endurance'],
  ),
  Quest(
    id: 'h-phy-02',
    title: 'Find something red and balance it on your head',
    description:
        'Walk 10 steps with it balanced — photo mid-walk.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.physical,
    tags: ['balance', 'public'],
  ),
  // ── Hard / Social ──
  Quest(
    id: 'h-soc-01',
    title: "Trade something you're wearing for something a stranger is wearing",
    description:
        'Photo wearing the swapped item with the stranger.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.social,
    tags: ['stranger', 'trade'],
  ),
  Quest(
    id: 'h-soc-02',
    title: 'Get 3 strangers to pose for a group photo',
    description:
        'All 4 of you must be doing a silly face.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.social,
    tags: ['stranger', 'group'],
  ),
  // ── Hard / Creative ──
  Quest(
    id: 'h-cre-01',
    title: 'Build a tower using only items from your bag',
    description:
        'Minimum 5 items tall — photo with a ruler for scale.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.creative,
    tags: ['build', 'improvisation'],
  ),
  Quest(
    id: 'h-cre-02',
    title: 'Perform a 30-second improvisation skit with a stranger',
    description:
        'Have someone film the finale and send you a screenshot.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.creative,
    tags: ['improv', 'stranger'],
  ),
  // ── Hard / Stealth ──
  Quest(
    id: 'h-stl-01',
    title: 'Rearranged a store display without being caught',
    description:
        'Photo of the altered display before you walk away.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.stealth,
    tags: ['mischief', 'store'],
  ),
  Quest(
    id: 'h-stl-02',
    title: 'Follow a stranger for exactly 1 minute without being noticed',
    description:
        'Photo of them from a distance at the 1-minute mark.',
    difficulty: QuestDifficulty.hard,
    category: QuestCategory.stealth,
    tags: ['follow', 'public'],
  ),

  // ── Legendary / Physical ──
  Quest(
    id: 'l-phy-01',
    title: 'Do a cartwheel in a formal setting',
    description:
        'Library, bank, or government building — photo mid-cartwheel.',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.physical,
    tags: ['daring', 'public'],
  ),
  Quest(
    id: 'l-phy-02',
    title: 'Get a stranger to give you a piggyback ride',
    description:
        'Both of you must be visible and smiling.',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.physical,
    tags: ['stranger', 'daring'],
  ),
  // ── Legendary / Social ──
  Quest(
    id: 'l-soc-01',
    title: 'Convince 3 strangers to form a human pyramid',
    description:
        'You must be the top of the pyramid. Photo proof.',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.social,
    tags: ['stranger', 'group', 'daring'],
  ),
  Quest(
    id: 'l-soc-02',
    title: "Get a stranger's phone number — legitimately",
    description:
        'Show the contact card on their phone (face and number blurred).',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.social,
    tags: ['stranger', 'charm'],
  ),
  // ── Legendary / Creative ──
  Quest(
    id: 'l-cre-01',
    title: 'Paint a mini-mural on a public wall with permission',
    description:
        'Photo of you beside the mural holding the paintbrush.',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.creative,
    tags: ['art', 'public', 'permission'],
  ),
  Quest(
    id: 'l-cre-02',
    title: 'Compose and perform a 30-second song about a stranger',
    description:
        'Have them record the finale — screenshot as proof.',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.creative,
    tags: ['music', 'stranger', 'improv'],
  ),
  // ── Legendary / Stealth ──
  Quest(
    id: 'l-stl-01',
    title: "Photobomb a stranger's selfie without them noticing",
    description:
        'You must show them the photobomb afterward and catch their reaction.',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.stealth,
    tags: ['photobomb', 'public'],
  ),
  Quest(
    id: 'l-stl-02',
    title: "Sit at a stranger's table before they notice",
    description:
        'Photo of you sitting with them looking surprised.',
    difficulty: QuestDifficulty.legendary,
    category: QuestCategory.stealth,
    tags: ['daring', 'public'],
  ),
];
