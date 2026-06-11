interface QuestData {
  id: string;
  title: string;
  description: string;
  difficulty: "easy" | "medium" | "hard" | "legendary";
  category: "physical" | "social" | "creative" | "stealth";
  tags: string[];
  points: number;
  durationSeconds: number;
}

const difficultyDefaults: Record<string, { points: number; durationSeconds: number }> = {
  easy: { points: 10, durationSeconds: 120 },
  medium: { points: 25, durationSeconds: 180 },
  hard: { points: 50, durationSeconds: 300 },
  legendary: { points: 100, durationSeconds: 480 },
};

export const questBank: QuestData[] = [
  // Easy / Physical
  {
    id: "e-phy-01",
    title: "Do 10 jumping jacks in a public space",
    description: "Get someone to count for you — they must be visible in the photo.",
    difficulty: "easy",
    category: "physical",
    tags: ["public", "exercise"],
    ...difficultyDefaults.easy,
  },
  {
    id: "e-phy-02",
    title: "Balance a book on your head for 30 seconds",
    description: "Take a photo mid-balance with both hands clearly away.",
    difficulty: "easy",
    category: "physical",
    tags: ["balance", "silly"],
    ...difficultyDefaults.easy,
  },
  // Easy / Social
  {
    id: "e-soc-01",
    title: "Compliment a stranger's outfit",
    description: "They must pose for the photo afterwards. Show both of you smiling.",
    difficulty: "easy",
    category: "social",
    tags: ["stranger", "compliment"],
    ...difficultyDefaults.easy,
  },
  {
    id: "e-soc-02",
    title: "Get a high-five from a passerby",
    description: "The hand-slap must be caught mid-air in the photo.",
    difficulty: "easy",
    category: "social",
    tags: ["stranger", "high-five"],
    ...difficultyDefaults.easy,
  },
  // Easy / Creative
  {
    id: "e-cre-01",
    title: "Draw a smiley face on a napkin and give it away",
    description: "Photograph the napkin in someone else's hand.",
    difficulty: "easy",
    category: "creative",
    tags: ["drawing", "gift"],
    ...difficultyDefaults.easy,
  },
  {
    id: "e-cre-02",
    title: "Make an origami paper crane in under 2 minutes",
    description: "Show the finished crane on your palm.",
    difficulty: "easy",
    category: "creative",
    tags: ["origami", "craft"],
    ...difficultyDefaults.easy,
  },
  // Easy / Stealth
  {
    id: "e-stl-01",
    title: "Hide behind a public notice board for 10 seconds",
    description: "Take a selfie peeking out from behind it.",
    difficulty: "easy",
    category: "stealth",
    tags: ["hide", "public"],
    ...difficultyDefaults.easy,
  },
  {
    id: "e-stl-02",
    title: "Walk past the same store window 3 times without stopping",
    description: "A reflection photo proving all three passes.",
    difficulty: "easy",
    category: "stealth",
    tags: ["recon", "public"],
    ...difficultyDefaults.easy,
  },

  // Medium / Physical
  {
    id: "m-phy-01",
    title: "Hold a plank for 45 seconds in a park",
    description: "Someone must be counting down for you in the frame.",
    difficulty: "medium",
    category: "physical",
    tags: ["exercise", "public"],
    ...difficultyDefaults.medium,
  },
  {
    id: "m-phy-02",
    title: "Skip rope 15 times without tripping",
    description: "Catch the rope mid-swing in the photo.",
    difficulty: "medium",
    category: "physical",
    tags: ["exercise", "skill"],
    ...difficultyDefaults.medium,
  },
  // Medium / Social
  {
    id: "m-soc-01",
    title: "Get a stranger to teach you a local dance move",
    description: "Photo of you both doing the move together.",
    difficulty: "medium",
    category: "social",
    tags: ["stranger", "dance"],
    ...difficultyDefaults.medium,
  },
  {
    id: "m-soc-02",
    title: "Convince a stranger to high-five you",
    description: "They must be smiling in the photo.",
    difficulty: "medium",
    category: "social",
    tags: ["stranger", "high-five"],
    ...difficultyDefaults.medium,
  },
  // Medium / Creative
  {
    id: "m-cre-01",
    title: "Write a 4-line poem about a stranger and read it to them",
    description: "Capture them holding the poem.",
    difficulty: "medium",
    category: "creative",
    tags: ["poem", "stranger"],
    ...difficultyDefaults.medium,
  },
  {
    id: "m-cre-02",
    title: "Chalk-art a hopscotch grid on the pavement",
    description: "Photo of the completed grid with your foot on the last square.",
    difficulty: "medium",
    category: "creative",
    tags: ["art", "public"],
    ...difficultyDefaults.medium,
  },
  // Medium / Stealth
  {
    id: "m-stl-01",
    title: "Mirror a stranger's pose without them noticing",
    description: "Take a photo where you are in the background mimicking their pose.",
    difficulty: "medium",
    category: "stealth",
    tags: ["mimic", "public"],
    ...difficultyDefaults.medium,
  },
  {
    id: "m-stl-02",
    title: "Eavesdrop on a conversation and report the topic",
    description: "Write it down and photograph the note with the people in the background.",
    difficulty: "medium",
    category: "stealth",
    tags: ["eavesdrop", "public"],
    ...difficultyDefaults.medium,
  },

  // Hard / Physical
  {
    id: "h-phy-01",
    title: "Do 20 push-ups in a busy plaza",
    description: "Someone must be visibly counting in the background.",
    difficulty: "hard",
    category: "physical",
    tags: ["exercise", "public", "endurance"],
    ...difficultyDefaults.hard,
  },
  {
    id: "h-phy-02",
    title: "Find something red and balance it on your head",
    description: "Walk 10 steps with it balanced — photo mid-walk.",
    difficulty: "hard",
    category: "physical",
    tags: ["balance", "public"],
    ...difficultyDefaults.hard,
  },
  // Hard / Social
  {
    id: "h-soc-01",
    title: "Trade something you're wearing for something a stranger is wearing",
    description: "Photo wearing the swapped item with the stranger.",
    difficulty: "hard",
    category: "social",
    tags: ["stranger", "trade"],
    ...difficultyDefaults.hard,
  },
  {
    id: "h-soc-02",
    title: "Get 3 strangers to pose for a group photo",
    description: "All 4 of you must be doing a silly face.",
    difficulty: "hard",
    category: "social",
    tags: ["stranger", "group"],
    ...difficultyDefaults.hard,
  },
  // Hard / Creative
  {
    id: "h-cre-01",
    title: "Build a tower using only items from your bag",
    description: "Minimum 5 items tall — photo with a ruler for scale.",
    difficulty: "hard",
    category: "creative",
    tags: ["build", "improvisation"],
    ...difficultyDefaults.hard,
  },
  {
    id: "h-cre-02",
    title: "Perform a 30-second improvisation skit with a stranger",
    description: "Have someone film the finale and send you a screenshot.",
    difficulty: "hard",
    category: "creative",
    tags: ["improv", "stranger"],
    ...difficultyDefaults.hard,
  },
  // Hard / Stealth
  {
    id: "h-stl-01",
    title: "Rearranged a store display without being caught",
    description: "Photo of the altered display before you walk away.",
    difficulty: "hard",
    category: "stealth",
    tags: ["mischief", "store"],
    ...difficultyDefaults.hard,
  },
  {
    id: "h-stl-02",
    title: "Follow a stranger for exactly 1 minute without being noticed",
    description: "Photo of them from a distance at the 1-minute mark.",
    difficulty: "hard",
    category: "stealth",
    tags: ["follow", "public"],
    ...difficultyDefaults.hard,
  },

  // Legendary / Physical
  {
    id: "l-phy-01",
    title: "Do a cartwheel in a formal setting",
    description: "Library, bank, or government building — photo mid-cartwheel.",
    difficulty: "legendary",
    category: "physical",
    tags: ["daring", "public"],
    ...difficultyDefaults.legendary,
  },
  {
    id: "l-phy-02",
    title: "Get a stranger to give you a piggyback ride",
    description: "Both of you must be visible and smiling.",
    difficulty: "legendary",
    category: "physical",
    tags: ["stranger", "daring"],
    ...difficultyDefaults.legendary,
  },
  // Legendary / Social
  {
    id: "l-soc-01",
    title: "Convince 3 strangers to form a human pyramid",
    description: "You must be the top of the pyramid. Photo proof.",
    difficulty: "legendary",
    category: "social",
    tags: ["stranger", "group", "daring"],
    ...difficultyDefaults.legendary,
  },
  {
    id: "l-soc-02",
    title: "Get a stranger's phone number — legitimately",
    description: "Show the contact card on their phone (face and number blurred).",
    difficulty: "legendary",
    category: "social",
    tags: ["stranger", "charm"],
    ...difficultyDefaults.legendary,
  },
  // Legendary / Creative
  {
    id: "l-cre-01",
    title: "Paint a mini-mural on a public wall with permission",
    description: "Photo of you beside the mural holding the paintbrush.",
    difficulty: "legendary",
    category: "creative",
    tags: ["art", "public", "permission"],
    ...difficultyDefaults.legendary,
  },
  {
    id: "l-cre-02",
    title: "Compose and perform a 30-second song about a stranger",
    description: "Have them record the finale — screenshot as proof.",
    difficulty: "legendary",
    category: "creative",
    tags: ["music", "stranger", "improv"],
    ...difficultyDefaults.legendary,
  },
  // Legendary / Stealth
  {
    id: "l-stl-01",
    title: "Photobomb a stranger's selfie without them noticing",
    description: "You must show them the photobomb afterward and catch their reaction.",
    difficulty: "legendary",
    category: "stealth",
    tags: ["photobomb", "public"],
    ...difficultyDefaults.legendary,
  },
  {
    id: "l-stl-02",
    title: "Sit at a stranger's table before they notice",
    description: "Photo of you sitting with them looking surprised.",
    difficulty: "legendary",
    category: "stealth",
    tags: ["daring", "public"],
    ...difficultyDefaults.legendary,
  },
];
