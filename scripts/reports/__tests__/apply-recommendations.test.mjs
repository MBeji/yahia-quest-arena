// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  APPLICABLE_STATUSES,
  citedReportIds,
  isMature,
  parseRecommendations,
  planApplications,
  planClosures,
  renderClosureComment,
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
        reason: "absent",
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
    expect(skipped[0].reason).toBe("immature");
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
    skipped: [
      { id: "abcd1234", channel: "bug", issue: 673, reason: "ambigu", why: "préfixe ambigu" },
    ],
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

  it("dit que l'issue reste ouverte quand elle n'est pas fermable — un id cité est encore ouvert", () => {
    // Le cas où ce commentaire est posé : #673 cite des signalements ENCORE ouverts,
    // et la fermer les ferait re-trier puis re-dupliquer (#651/#658).
    const stillOpen = {
      bugReports: [{ id: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2" }],
      contentReports: [],
    };
    expect(
      planClosures({
        issues: [{ number: 673, createdAt: "2026-07-29T10:00:00Z", body: ISSUE_673 }],
        open: stillOpen,
        now: "2026-08-24T10:00:00Z",
        minAgeDays: 7,
      }),
    ).toEqual([]);
    expect(renderIssueComments(plan, false)[0].body).toContain("reste OUVERTE");
  });

  it("ne rend RIEN quand tous les écarts sont `absent` — #1162 en a reçu treize", () => {
    const noise = {
      apply: [],
      skipped: [
        {
          id: "10b2008e-f2ec-4fae-888c-d09ff79ceb4d",
          channel: "bug",
          issue: 1162,
          reason: "absent",
          why: "déjà clos ou introuvable parmi les signalements ouverts",
        },
      ],
    };
    expect(renderIssueComments(noise, false)).toEqual([]);
  });

  it("dit toujours un écart ambigu, même sans application", () => {
    const ambiguous = {
      apply: [],
      skipped: [
        { id: "x", channel: "bug", issue: 7, reason: "absent", why: "déjà clos" },
        { id: "abcd1234", channel: "bug", issue: 7, reason: "ambigu", why: "préfixe ambigu" },
      ],
    };
    const [c] = renderIssueComments(ambiguous, false);
    expect(c.issue).toBe(7);
    expect(c.body).toContain("préfixe ambigu");
  });

  it("dit toujours qu'une issue est trop récente", () => {
    const young = {
      apply: [],
      skipped: [{ id: "*", channel: "*", issue: 9, reason: "immature", why: "trop récente" }],
    };
    expect(renderIssueComments(young, false).map((c) => c.issue)).toEqual([9]);
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

// Le vrai tableau de l'issue #1162 : C1 porte un statut hors liste blanche
// (`open (fix en PR #1161)`, résolu depuis par report-close), C2 a été passé en
// `dismissed` par report-apply. Ni l'un ni l'autre n'est plus ouvert.
const ISSUE_1162 = `
## Phase 5 — Tableau de clôture

| Report id | Canal | Verdict sécurité | Classification | Sévérité | Action | Statut recommandé | Motif |
|-----------|-------|-----------------|----------------|----------|--------|-------------------|-------|
| \`04d460bf-2f35-4e77-bb8c-b41caf727cba\` | bug | ✅ LÉGITIME | bug technique | majeur | PR #1161 | \`open (fix en PR #1161)\` | navigation bloquée |
| \`10b2008e-f2ec-4fae-888c-d09ff79ceb4d\` | bug | ✅ LÉGITIME | question/support | mineur | aucune PR | \`dismissed\` | question |

### C1 — \`04d460bf\` — \`/parent-report\`

### C2 — \`10b2008e\` — \`/parametrage\`
`;

const C1 = "04d460bf-2f35-4e77-bb8c-b41caf727cba";
const C2 = "10b2008e-f2ec-4fae-888c-d09ff79ceb4d";

describe("citedReportIds", () => {
  it("cite aussi la ligne au statut non applicable, sans doubler les préfixes", () => {
    expect(citedReportIds(ISSUE_1162).sort()).toEqual([C1, C2].sort());
  });

  it("garde un préfixe tronqué du tableau quand aucun UUID complet ne le couvre", () => {
    expect(citedReportIds(ISSUE_673)).toEqual(["f6aed6b2", "f4492168", "e91489f6"]);
  });

  it("ne cite rien d'un corps sans id", () => {
    expect(citedReportIds("Rien à trier aujourd'hui.")).toEqual([]);
  });
});

describe("planClosures — solder une issue qui ne protège plus rien", () => {
  const now = "2026-10-30T06:37:00Z";
  const issue1162 = { number: 1162, createdAt: "2026-10-09T21:25:12Z", body: ISSUE_1162 };
  const empty = { bugReports: [], contentReports: [] };
  const other = { id: "99999999-0000-0000-0000-000000000000" };

  it("ferme le cas réel de #1162 : aucun des deux UUID cités n'est encore ouvert", () => {
    expect(
      planClosures({
        issues: [issue1162],
        open: { bugReports: [other], contentReports: [] },
        now,
        minAgeDays: 7,
      }),
    ).toEqual([1162]);
  });

  it("ne ferme PAS si l'id d'une ligne non applicable est encore ouvert (canal bug)", () => {
    expect(
      planClosures({
        issues: [issue1162],
        open: { bugReports: [{ id: C1 }], contentReports: [] },
        now,
        minAgeDays: 7,
      }),
    ).toEqual([]);
  });

  it("ne ferme PAS si un id cité est ouvert dans l'AUTRE canal", () => {
    expect(
      planClosures({
        issues: [issue1162],
        open: { bugReports: [], contentReports: [{ id: C2 }] },
        now,
        minAgeDays: 7,
      }),
    ).toEqual([]);
  });

  it("ne ferme PAS si un préfixe tronqué désigne encore un signalement ouvert", () => {
    const issue = { number: 673, createdAt: "2026-07-29T10:00:00Z", body: ISSUE_673 };
    expect(
      planClosures({
        issues: [issue],
        open: { bugReports: [{ id: "e91489f6-9999-8888-7777-666655554444" }], contentReports: [] },
        now,
        minAgeDays: 7,
      }),
    ).toEqual([]);
  });

  it("ne ferme pas une issue de moins de 7 jours — le délai d'objection prime", () => {
    expect(
      planClosures({
        issues: [{ ...issue1162, createdAt: "2026-10-25T00:00:00Z" }],
        open: empty,
        now,
        minAgeDays: 7,
      }),
    ).toEqual([]);
  });

  it("ne ferme pas une issue qui ne cite aucun id — on ne devine rien", () => {
    expect(
      planClosures({
        issues: [{ number: 5, createdAt: "2026-09-01T00:00:00Z", body: "Triage : file vide." }],
        open: empty,
        now,
        minAgeDays: 7,
      }),
    ).toEqual([]);
  });

  it("ne ferme rien quand l'export ne prouve pas l'état des deux canaux", () => {
    expect(
      planClosures({ issues: [issue1162], open: { bugReports: [] }, now, minAgeDays: 7 }),
    ).toEqual([]);
  });

  it("ne ferme que les issues soldées parmi plusieurs", () => {
    const busy = { number: 673, createdAt: "2026-07-29T10:00:00Z", body: ISSUE_673 };
    expect(
      planClosures({
        issues: [busy, issue1162],
        open: { bugReports: [{ id: "f6aed6b2-24fc-47b2-9ace-e219b1fd2da2" }], contentReports: [] },
        now,
        minAgeDays: 7,
      }),
    ).toEqual([1162]);
  });
});

describe("renderClosureComment", () => {
  it("dit pourquoi l'issue se ferme, ids cités compris, et pourquoi le pré-vol n'en dépend plus", () => {
    const body = renderClosureComment({ number: 1162, body: ISSUE_1162 });
    expect(body).toContain(C1);
    expect(body).toContain(C2);
    expect(body).toMatch(/n'est encore ouvert/);
    expect(body).toContain("report-triage-pregate.mjs");
    expect(body).toMatch(/closes comprises/);
  });
});
