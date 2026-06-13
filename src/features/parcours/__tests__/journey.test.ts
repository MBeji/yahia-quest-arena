import { describe, it, expect } from "vitest";
import { buildSubjectNodes, xpProgress, nodeSide } from "../journey";

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
    const nodes = buildSubjectNodes(subjects, {
      math: { count: 5, avg: 90 },
      french: { count: 3, avg: 50 },
    });
    expect(nodes.map((n) => n.state)).toEqual(["done", "current", "open", "locked"]);
  });

  it("flags premium-locked subjects from the locked-id set", () => {
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
    // Locked when its id is in the set (premium parcours without entitlement)…
    expect(buildSubjectNodes(subj, stats, new Set(["frm"]))[1].state).toBe("premium-locked");
    // …and not locked when the set is empty (entitled / free).
    expect(buildSubjectNodes(subj, stats, new Set())[1].state).toBe("open");
  });
});
