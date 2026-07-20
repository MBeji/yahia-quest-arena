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

  // R-11 — LA régression que ce lot répare : la carte verrouillait chaque matière tant que la
  // précédente n'avait pas été commencée, alors que le serveur laissait tout jouer.
  it("never locks a subject behind another (R-11)", () => {
    const nodes = buildSubjectNodes(subjects, {});
    expect(nodes.map((n) => n.state)).not.toContain("locked");
    // Une seule matière est « recommandée » : la première du chemin.
    expect(nodes.map((n) => n.state)).toEqual(["next", "open", "open", "open"]);
  });

  it("marks done from R-16 progression, not from the score average", () => {
    const nodes = buildSubjectNodes(subjects, { math: { count: 5, avg: 95 } }, new Set(), {
      progressBySubject: {
        // Moyenne excellente mais un seul chapitre sur quatre terminé : ce n'est PAS « done ».
        math: { total: 4, completed: 1 },
        french: { total: 2, completed: 2 },
      },
    });
    expect(nodes[0].state).not.toBe("done");
    expect(nodes[0].progressionPct).toBe(25);
    expect(nodes[1].state).toBe("done");
    expect(nodes[1].progressionPct).toBe(100);
  });

  it("never reports 100% for a subject with no published chapter", () => {
    const nodes = buildSubjectNodes(subjects, {}, new Set(), {
      progressBySubject: { math: { total: 0, completed: 0 } },
    });
    // 0/0 ne doit surtout pas valoir 100 % — sinon une matière vide s'affiche « terminée ».
    expect(nodes[0].progressionPct).toBeNull();
    expect(nodes[0].state).not.toBe("done");
  });

  it("gives `current` to the most recently worked subject", () => {
    const nodes = buildSubjectNodes(
      subjects,
      { math: { count: 5, avg: 70 }, french: { count: 2, avg: 80 } },
      new Set(),
      { lastActivitySubjectId: "french" },
    );
    expect(nodes.find((n) => n.id === "french")?.state).toBe("current");
    expect(nodes.find((n) => n.id === "math")?.state).toBe("open");
    // `next` reste la première matière encore jamais tentée.
    expect(nodes.find((n) => n.id === "arabic")?.state).toBe("next");
  });

  it("prefers done over current when a finished subject is also the latest one", () => {
    const nodes = buildSubjectNodes(subjects, { math: { count: 9, avg: 88 } }, new Set(), {
      progressBySubject: { math: { total: 3, completed: 3 } },
      lastActivitySubjectId: "math",
    });
    expect(nodes[0].state).toBe("done");
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
    // …and not locked when the set is empty (entitled / free) — it becomes the recommended one.
    expect(buildSubjectNodes(subj, stats, new Set())[1].state).toBe("next");
  });
});
