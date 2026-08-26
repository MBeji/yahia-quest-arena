// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  APPLICABLE_STATUSES,
  isMature,
  parseRecommendations,
  planApplications,
  renderTrailers,
  renderIssueComments,
  resolveReportId,
} from "../apply-recommendations.mjs";

// Le vrai tableau de l'issue #673, réduit aux colonnes qui comptent — c'est
// LUI qu'il faut savoir lire, ids tronqués compris.
const ISSUE_673 = `
## Phase 5 — Tableau de clôture

| Report id | Canal | Verdict sécurité | Classification | Action | Statut recommandé | Motif |
|---|---|---|---|---|---|---|
| \`f6aed6b2\` | bug | ⚠️ SUSPECT | bruit / test | aucune | **dismissed** | Message "Tedy test" |
| \`f4492168\` | bug | ✅ LÉGITIME | bug technique | PR #647 mergée ✅ | **resolved** | CTA d'inscription |
| \`e91489f6\` | bug | ✅ LÉGITIME | non reproduit | aucune | **dismissed** | pas d'exercise_id |
`;

describe("parseRecommendations", () => {
  it("lit le tableau de clôture réel de #673, ids tronqués compris", () => {
    expect(parseRecommendations(ISSUE_673)).toEqual([
      { id: "f6aed6b2", channel: "bug", status: "dismissed" },
      { id: "f4492168", channel: "bug", status: "resolved" },
      { id: "e91489f6", channel: "bug", status: "dismissed" },
    ]);
  });

  it("ignore une ligne sans statut applicable plutôt que d'en deviner un", () => {
    const body = "| `aaaaaaaa` | bug | ✅ | à revoir | aucune | **en attente** | motif |";
    expect(parseRecommendations(body)).toEqual([]);
  });

  it("ignore une ligne sans canal reconnaissable", () => {
    const body = "| `aaaaaaaa` | ??? | ✅ | x | y | **dismissed** | motif |";
    expect(parseRecommendations(body)).toEqual([]);
  });

  it("distingue le canal content du canal bug", () => {
    const body = "| `bbbbbbbb` | content | ✅ | x | y | **resolved** | motif |";
    expect(parseRecommendations(body)).toEqual([
      { id: "bbbbbbbb", channel: "content", status: "resolved" },
    ]);
  });

  it("ne compte qu'une fois un id répété dans le même canal", () => {
    const dup = `${ISSUE_673}\n| \`f6aed6b2\` | bug | ⚠️ | x | y | **dismissed** | encore |`;
    expect(parseRecommendations(dup).filter((r) => r.id === "f6aed6b2")).toHaveLength(1);
  });

  it("ignore la prose autour du tableau", () => {
    expect(parseRecommendations("Rien à voir ici. dismissed resolved.")).toEqual([]);
  });

  it("n'accepte que les deux statuts de la liste blanche", () => {
    expect(APPLICABLE_STATUSES).toEqual(["dismissed", "resolved"]);
  });
});

describe("resolveReportId — le pont entre l'id tronqué et l'UUID canonique", () => {
  const open = [
    { id: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2" },
    { id: "f4492168-1111-2222-3333-444455556666" },
  ];

  it("résout un préfixe unique vers l'UUID complet", () => {
    expect(resolveReportId("f6aed6b2", open)).toEqual({
      resolved: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2",
      reason: "prefix",
    });
  });

  it("accepte un UUID déjà complet", () => {
    expect(resolveReportId("f4492168-1111-2222-3333-444455556666", open).reason).toBe("exact");
  });

  it("REFUSE un préfixe ambigu au lieu de tirer au sort", () => {
    // Clore le mauvais signalement est une écriture en prod qu'aucun revert ne rattrape.
    const collide = [
      { id: "abcd1234-aaaa-1111-2222-333344445555" },
      { id: "abcd1234-bbbb-1111-2222-333344445555" },
    ];
    expect(resolveReportId("abcd1234", collide)).toEqual({ resolved: null, reason: "ambigu" });
  });

  it("rend `absent` quand le signalement n'est plus ouvert — rien à faire", () => {
    expect(resolveReportId("deadbeef", open)).toEqual({ resolved: null, reason: "absent" });
  });

  it("rend `absent` pour un UUID complet qui n'est plus dans la file", () => {
    expect(resolveReportId("00000000-0000-0000-0000-000000000000", open).reason).toBe("absent");
  });
});

describe("isMature — le délai d'objection", () => {
  it("refuse une issue plus jeune que le délai", () => {
    expect(isMature("2026-08-20T00:00:00Z", "2026-08-24T00:00:00Z", 7)).toBe(false);
  });

  it("accepte une issue qui a dépassé le délai", () => {
    expect(isMature("2026-07-29T00:00:00Z", "2026-08-24T00:00:00Z", 7)).toBe(true);
  });

  it("accepte pile au seuil", () => {
    expect(isMature("2026-08-17T00:00:00Z", "2026-08-24T00:00:00Z", 7)).toBe(true);
  });

  it("refuse une date illisible plutôt que de la traiter comme ancienne", () => {
    expect(isMature("pas une date", "2026-08-24T00:00:00Z", 7)).toBe(false);
  });
});

describe("planApplications", () => {
  const open = {
    bugReports: [
      { id: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2" },
      { id: "e91489f6-9999-8888-7777-666655554444" },
    ],
    contentReports: [],
  };

  it("planifie ce qui est mûr et encore ouvert, et rien d'autre", () => {
    const { apply, skipped } = planApplications({
      issues: [{ number: 673, createdAt: "2026-07-29T10:00:00Z", body: ISSUE_673 }],
      open,
      now: "2026-08-24T10:00:00Z",
      minAgeDays: 7,
    });
    expect(apply).toEqual([
      {
        id: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2",
        channel: "bug",
        status: "dismissed",
        issue: 673,
      },
      {
        id: "e91489f6-9999-8888-7777-666655554444",
        channel: "bug",
        status: "dismissed",
        issue: 673,
      },
    ]);
    // f4492168 a déjà été clos entre-temps : rapporté, pas appliqué.
    expect(skipped).toEqual([
      {
        id: "f4492168",
        channel: "bug",
        issue: 673,
        why: "déjà clos ou introuvable parmi les signalements ouverts",
      },
    ]);
  });

  it("n'applique RIEN d'une issue trop récente — le délai d'objection prime", () => {
    const { apply, skipped } = planApplications({
      issues: [{ number: 900, createdAt: "2026-08-23T10:00:00Z", body: ISSUE_673 }],
      open,
      now: "2026-08-24T10:00:00Z",
      minAgeDays: 7,
    });
    expect(apply).toEqual([]);
    expect(skipped).toHaveLength(1);
    expect(skipped[0].why).toMatch(/trop récente/);
  });

  it("ne rend rien quand aucune issue n'est ouverte", () => {
    expect(
      planApplications({ issues: [], open, now: "2026-08-24T10:00:00Z", minAgeDays: 7 }),
    ).toEqual({ apply: [], skipped: [] });
  });
});

describe("renderTrailers", () => {
  const planned = [
    { id: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2", channel: "bug", status: "dismissed" },
    { id: "aaaaaaaa-1111-2222-3333-444455556666", channel: "content", status: "resolved" },
  ];

  it("rend le format EXACT que resolve-reports.mjs sait relire", () => {
    expect(renderTrailers(planned, "dismissed")).toBe(
      "Report-Id: f6aed6b2-24fc-47b2-9ace-e219b1fd2da2 (bug)",
    );
  });

  it("sépare les statuts — un appel du writer par statut", () => {
    expect(renderTrailers(planned, "resolved")).toBe(
      "Report-Id: aaaaaaaa-1111-2222-3333-444455556666 (content)",
    );
  });

  it("rend une chaîne vide quand rien n'est planifié pour ce statut", () => {
    expect(renderTrailers([], "dismissed")).toBe("");
  });
});

describe("renderIssueComments", () => {
  const plan = {
    apply: [
      {
        id: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2",
        channel: "bug",
        status: "dismissed",
        issue: 673,
      },
    ],
    skipped: [{ id: "abcd1234", channel: "bug", issue: 673, why: "préfixe ambigu" }],
  };

  it("dit ce qui a été appliqué ET ce qui a été écarté", () => {
    const [c] = renderIssueComments(plan, false);
    expect(c.issue).toBe(673);
    expect(c.body).toContain("f6aed6b2-24fc-47b2-9ace-e219b1fd2da2");
    expect(c.body).toContain("**dismissed**");
    // La liste des écartés est la plus importante : sans elle, un signalement
    // resterait ouvert pour toujours sans que personne ne sache pourquoi.
    expect(c.body).toContain("Écartés");
    expect(c.body).toContain("préfixe ambigu");
  });

  it("annonce clairement une simulation", () => {
    expect(renderIssueComments(plan, true)[0].body).toContain("Simulation");
    expect(renderIssueComments(plan, false)[0].body).not.toContain("Simulation");
  });

  it("dit que l'issue reste ouverte — une issue de triage fermée se re-duplique", () => {
    expect(renderIssueComments(plan, false)[0].body).toContain("reste OUVERTE");
  });

  it("ne poste rien quand il n'y a ni application ni écart", () => {
    expect(renderIssueComments({ apply: [], skipped: [] }, false)).toEqual([]);
  });

  it("regroupe par issue", () => {
    const multi = {
      apply: [
        { id: "a", channel: "bug", status: "dismissed", issue: 1 },
        { id: "b", channel: "bug", status: "resolved", issue: 2 },
      ],
      skipped: [],
    };
    expect(renderIssueComments(multi, false).map((c) => c.issue)).toEqual([1, 2]);
  });
});
