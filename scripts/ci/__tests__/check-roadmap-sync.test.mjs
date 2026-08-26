// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  citedPullRequests,
  declaredBaseline,
  findUncitedLots,
  isLotDelivery,
  pullRequestNumber,
} from "../check-roadmap-sync.mjs";

// Verbatim subjects from `main` — the gate is only worth what it recognizes.
const REAL = {
  competences5: "feat(competences): lot 5 étude 07 — « Révision du jour » compétence-aware (#616)",
  quest20: "feat(quest): étude 20 lot 1 — socle du scoring ensembliste (#583)",
  harnessL4:
    "feat(ci): script the patch/minor lot, agent only for majors (étude IA→déterministe, L4) (#613)",
  fableRef:
    "feat(competences): lot 4 étude 07 — carte de compétences (FableEtudes/07-knowledge-graph-competences#lot-4) (#588)",
  unaccented: "feat(quest): recall mode e2e + docs (etude 17 lot 5) (#430)",
  wip: "[wip] feat(dashboard): étude 22 lot 3 — la rentrée (R-2, R-4, R-17) (#573)",
};

describe("isLotDelivery", () => {
  it("recognizes an accented `étude NN lot M` subject", () => {
    // The regression that matters: JS `\b` is ASCII-only, so /\bétude\b/ can
    // never match. Writing the pattern that way dropped 84 % of real commits
    // and the gate reported a clean roadmap while 14 lots were missing.
    expect(isLotDelivery(REAL.quest20)).toBe(true);
    expect(isLotDelivery(REAL.competences5)).toBe(true);
  });

  it("recognizes the `L<n>` lot style of the harness étude", () => {
    expect(isLotDelivery(REAL.harnessL4)).toBe(true);
  });

  it("recognizes a subject carrying a FableEtudes anchor", () => {
    expect(isLotDelivery(REAL.fableRef)).toBe(true);
  });

  it("still recognizes the unaccented spelling", () => {
    expect(isLotDelivery(REAL.unaccented)).toBe(true);
  });

  it("recognizes a savepoint-prefixed subject", () => {
    expect(isLotDelivery(REAL.wip)).toBe(true);
  });

  it("ignores commits that deliver no lot", () => {
    for (const subject of [
      "fix(competences): GRANT EXECUTE du helper d'oubli — répare le plan quotidien (#617)",
      "chore(deps): patch & minor upgrades 2026-07-21 (#592)",
      "docs(status): topo à jour après l'exécution V1 (#605)",
      "ci(db): fait tourner la suite pgTAP sur les PR (#563)",
    ]) {
      expect(isLotDelivery(subject)).toBe(false);
    }
  });

  it("does not fire on the word étude alone", () => {
    expect(isLotDelivery("docs(etudes): étude 22 validée — Q-1…Q-5 arbitrées (#471)")).toBe(false);
  });
});

describe("pullRequestNumber", () => {
  it("reads the trailing squash marker", () => {
    expect(pullRequestNumber(REAL.quest20)).toBe("583");
  });

  it("is not fooled by an issue reference mid-subject", () => {
    expect(pullRequestNumber("fix(content): remove raw LaTeX (fixes #338) (#610)")).toBe("610");
  });

  it("returns null when the subject carries no PR", () => {
    expect(pullRequestNumber("feat(quest): étude 20 lot 1 — socle")).toBeNull();
  });
});

describe("citedPullRequests", () => {
  it("collects every reference, whatever the surrounding prose", () => {
    const cited = citedPullRequests("livré #547, puis #565/#567 — voir aussi (#581).");
    expect([...cited].sort()).toEqual(["547", "565", "567", "581"]);
  });

  it("ignores requirement ids and short numbers", () => {
    expect([...citedPullRequests("R-25/R-30, section #7, lot #4")]).toEqual([]);
  });
});

describe("declaredBaseline", () => {
  it("reads the marker the roadmap carries", () => {
    expect(declaredBaseline("bla\n<!-- roadmap-sync: since-pr=536 -->\nbla")).toBe(536);
  });

  it("returns null when the roadmap declares nothing", () => {
    expect(declaredBaseline("# ROADMAP\n\n- [ ] faire des choses")).toBeNull();
  });
});

describe("findUncitedLots", () => {
  const subjects = [REAL.competences5, REAL.quest20, REAL.harnessL4, REAL.unaccented];

  it("flags a delivered lot the roadmap never mentions", () => {
    const found = findUncitedLots(subjects, new Set(["583", "613"]), 536);
    expect(found.map((f) => f.pr)).toEqual(["616"]);
  });

  it("stays silent once every lot is cited", () => {
    expect(findUncitedLots(subjects, new Set(["616", "583", "613"]), 536)).toEqual([]);
  });

  it("ignores everything at or below the baseline", () => {
    // #430 predates the roadmap; it is history, not drift.
    expect(findUncitedLots(subjects, new Set(["616", "583", "613"]), 536)).toEqual([]);
    expect(findUncitedLots([REAL.unaccented], new Set(), 536)).toEqual([]);
  });

  it("treats the baseline itself as already accounted for", () => {
    expect(
      findUncitedLots(["feat: étude 22 lot 1 — la carte honnête (#538)"], new Set(), 538),
    ).toEqual([]);
  });
});
