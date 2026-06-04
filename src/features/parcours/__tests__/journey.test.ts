import { describe, it, expect } from "vitest";
import { buildSubjectNodes, buildChapterNodes, xpProgress, nodeSide } from "../journey";

describe("xpProgress", () => {
  it("computes progress within the 200 XP/level curve", () => {
    const p = xpProgress(250, 2);
    expect(p.intoLevel).toBe(50);
    expect(p.toNext).toBe(150);
    expect(p.pct).toBe(25);
    expect(p.isMax).toBe(false);
  });
  it("caps at max level", () => {
    const p = xpProgress(99999, 50);
    expect(p.isMax).toBe(true);
    expect(p.pct).toBe(100);
    expect(p.toNext).toBe(0);
  });
  it("handles zero/negative xp safely", () => {
    expect(xpProgress(0, 1).intoLevel).toBe(0);
    expect(xpProgress(-10, 1).intoLevel).toBe(0);
  });
});

describe("nodeSide", () => {
  it("alternates left/right", () => {
    expect(nodeSide(0)).toBe("left");
    expect(nodeSide(1)).toBe("right");
    expect(nodeSide(2)).toBe("left");
  });
});

describe("buildSubjectNodes", () => {
  const subjects = [
    { id: "math", name_fr: "Maths", color_token: "subject-math", icon: "Calculator" },
    { id: "french", name_fr: "Français", color_token: "subject-french", icon: "BookOpen" },
    { id: "arabic", name_fr: "Arabe", color_token: "subject-arabic", icon: "Languages" },
    { id: "svt", name_fr: "SVT", color_token: "subject-svt", icon: "Leaf" },
  ];

  it("marks mastery as done, started as current, gates the rest", () => {
    const nodes = buildSubjectNodes(
      subjects,
      { math: { count: 5, avg: 90 }, french: { count: 3, avg: 50 } },
      true,
    );
    expect(nodes.map((n) => n.state)).toEqual(["done", "current", "open", "locked"]);
  });

  it("gates premium subjects on the subscription", () => {
    const subj = [
      { id: "math", name_fr: "Maths", color_token: "subject-math", icon: "Calculator" },
      {
        id: "frm",
        name_fr: "Maîtrise",
        color_token: "subject-french",
        icon: "BookOpen",
        is_premium: true,
      },
    ];
    const stats = { math: { count: 1, avg: 60 } };
    expect(buildSubjectNodes(subj, stats, false)[1].state).toBe("premium-locked");
    expect(buildSubjectNodes(subj, stats, true)[1].state).toBe("open");
  });
});

describe("buildChapterNodes", () => {
  const chapters = [
    { id: "c1", title: "Ch1" },
    { id: "c2", title: "Ch2" },
    { id: "c3", title: "Ch3" },
  ];
  const exercises = [
    { id: "e1", chapter_id: "c1", mode: "practice", difficulty: 1, xp_reward: 50 },
    { id: "e2", chapter_id: "c1", mode: "boss", difficulty: 3, xp_reward: 120 },
    { id: "e3", chapter_id: "c2", mode: "practice", difficulty: 2, xp_reward: 50 },
    { id: "q1", chapter_id: "c1", mode: "quiz", difficulty: 1, xp_reward: 20 },
  ];

  it("done → current → locked across the chapter gate", () => {
    const nodes = buildChapterNodes(
      chapters,
      exercises,
      { c1: true, c2: false, c3: true },
      { e1: 100, e2: 100, e3: 0 },
    );
    expect(nodes.map((n) => n.state)).toEqual(["done", "current", "locked"]);
  });

  it("computes xpReward (excluding the quiz) and flags premium content", () => {
    const nodes = buildChapterNodes(chapters, exercises, {}, {});
    expect(nodes[0].xpReward).toBe(170); // 50 + 120 (quiz's 20 excluded)
    expect(nodes[0].total).toBe(2);
    expect(nodes[0].hasPremium).toBe(true); // has a difficulty-3 boss
    expect(nodes[1].hasPremium).toBe(false);
  });
});
