// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  RED_CONCLUSIONS,
  formatIssueBody,
  groupByWorkflow,
  parseArgs,
  runsFromFile,
  selectRelevant,
} from "../guard-watch.mjs";

/**
 * Fixtures calquées sur des runs RÉELS du dépôt de corpus, relevés le 2026-09-04 : les trois
 * `pull_request` mort-nés de la PR #343 (zéro job) et le vrai rouge de `Roadmap sync` que la
 * garde a correctement retenu le même jour. C'est ce couple qui donne son sens au module :
 * distinguer un rouge qui dit quelque chose d'un rouge qui n'a rien évalué.
 */
const run = (over = {}) => ({
  databaseId: Math.floor(Math.random() * 1e9),
  workflowName: "Content CI",
  conclusion: "failure",
  createdAt: "2026-09-04T11:26:13Z",
  event: "schedule",
  url: "https://github.com/o/r/actions/runs/1",
  ...over,
});

describe("selectRelevant", () => {
  it("retient `failure` et `timed_out`, et rien d'autre", () => {
    expect([...RED_CONCLUSIONS].sort()).toEqual(["failure", "timed_out"]);
    const runs = [
      run({ conclusion: "failure" }),
      run({ conclusion: "timed_out" }),
      run({ conclusion: "success" }),
      // Un `cancelled` n'est pas un rouge : quelqu'un a voulu l'annuler.
      run({ conclusion: "cancelled" }),
    ];
    expect(selectRelevant(runs)).toHaveLength(2);
  });

  it("écarte les échecs de `pull_request` au moteur — ils ont déjà un propriétaire", () => {
    const runs = [run({ event: "pull_request" }), run({ event: "schedule" })];
    expect(selectRelevant(runs)).toHaveLength(1);
  });

  it("les GARDE au corpus, où aucun check requis ne bloque une PR rouge", () => {
    const runs = [run({ event: "pull_request" }), run({ event: "schedule" })];
    expect(selectRelevant(runs, { includePullRequest: true })).toHaveLength(2);
  });

  it("écarte les runs que l'appelant a constatés à zéro job", () => {
    // Le cœur de privé#293 : 37 de ces runs comptés comme des « gardes en échec ».
    const runs = [run({ databaseId: 1 }), run({ databaseId: 2 })];
    expect(selectRelevant(runs, { dropIds: ["1"] })).toHaveLength(1);
  });

  it("compare les ids comme des chaînes — l'API rend un nombre, le shell une chaîne", () => {
    expect(
      selectRelevant([run({ databaseId: 33871495928 })], { dropIds: ["33871495928"] }),
    ).toEqual([]);
  });

  it("accepte `id` comme `databaseId` — les deux formes de l'API GitHub", () => {
    expect(selectRelevant([{ id: 7, conclusion: "failure" }], { dropIds: ["7"] })).toEqual([]);
  });

  it("alarme ENTIÈRE quand la liste d'écartés est vide ou absente", () => {
    // L'invariant de polarité : une garde se trompe en criant, jamais en se taisant. Si le
    // calcul des zéro-job échoue en amont, `dropIds` reste vide et rien n'est filtré.
    const runs = [run(), run()];
    expect(selectRelevant(runs, { dropIds: [] })).toHaveLength(2);
    expect(selectRelevant(runs, { dropIds: undefined })).toHaveLength(2);
    expect(selectRelevant(runs, {})).toHaveLength(2);
  });

  it("ne casse pas sur une entrée absurde", () => {
    expect(selectRelevant(null)).toEqual([]);
    expect(selectRelevant([null, undefined, "x"])).toEqual([]);
  });
});

describe("groupByWorkflow", () => {
  it("compte par workflow et garde le run le plus RÉCENT de chaque groupe", () => {
    const groups = groupByWorkflow([
      run({ workflowName: "Content CI", createdAt: "2026-09-04T10:00:00Z" }),
      run({ workflowName: "Content CI", createdAt: "2026-09-04T12:00:00Z", url: "recent" }),
      run({ workflowName: "Roadmap sync", createdAt: "2026-09-04T11:00:00Z" }),
    ]);
    expect(groups[0]).toMatchObject({ name: "Content CI", count: 2 });
    expect(groups[0].latest.url).toBe("recent");
    expect(groups[1]).toMatchObject({ name: "Roadmap sync", count: 1 });
  });

  it("classe les plus bruyants d'abord, puis par nom — un même état rend le même tableau", () => {
    // Sans ordre stable, chaque passage réécrirait l'issue pour rien, à état identique.
    const groups = groupByWorkflow([
      run({ workflowName: "Zèbre" }),
      run({ workflowName: "Alpha" }),
      run({ workflowName: "Bruyant" }),
      run({ workflowName: "Bruyant" }),
    ]);
    expect(groups.map((g) => g.name)).toEqual(["Bruyant", "Alpha", "Zèbre"]);
  });

  it("nomme un workflow sans nom plutôt que de rendre `undefined` au lecteur", () => {
    expect(groupByWorkflow([{ conclusion: "failure" }])[0].name).toBe("(workflow sans nom)");
  });
});

describe("formatIssueBody", () => {
  const groups = groupByWorkflow([
    run({
      workflowName: "Roadmap sync",
      createdAt: "2026-09-04T11:26:13Z",
      url: "u",
      event: "pull_request",
    }),
  ]);

  it("rend la fenêtre, le tableau et la phrase de fermeture automatique", () => {
    const body = formatIssueBody(groups, { windowHours: 8, since: "2026-09-04T03:26:13Z" });
    expect(body).toContain("les **8 dernières heures**");
    expect(body).toContain("2026-09-04T03:26:13Z");
    expect(body).toContain("| Roadmap sync | 1 | [2026-09-04T11:26](u) | `pull_request` |");
    expect(body).toContain("se referme toute seule");
  });

  it("n'annonce l'exclusion des `pull_request` que là où elle est vraie", () => {
    // L'écrire au corpus, qui les inclut, ferait mentir l'issue sur son propre périmètre.
    expect(formatIssueBody(groups, {})).toContain("volontairement exclus");
    expect(formatIssueBody(groups, { includePullRequest: true })).not.toContain(
      "volontairement exclus",
    );
  });

  it("oriente vers la cause hors dépôt, la leçon des 26 jours de report-triage", () => {
    expect(formatIssueBody(groups, {})).toContain("supprimer le besoin");
  });
});

describe("parseArgs", () => {
  it("lit les options du workflow", () => {
    expect(
      parseArgs([
        "--runs",
        "runs.json",
        "--out",
        "corps.md",
        "--window-hours",
        "12",
        "--since",
        "2026-09-04T00:00:00Z",
        "--include-pull-request",
      ]),
    ).toMatchObject({
      runs: "runs.json",
      out: "corps.md",
      windowHours: 12,
      since: "2026-09-04T00:00:00Z",
      includePullRequest: true,
    });
  });

  it("découpe les ids écartés sur espaces ET sauts de ligne — ce qu'une boucle shell produit", () => {
    expect(parseArgs(["--drop-ids", "1 2\n3\n"]).dropIds).toEqual(["1", "2", "3"]);
    expect(parseArgs(["--drop-ids", ""]).dropIds).toEqual([]);
    expect(parseArgs([]).dropIds).toEqual([]);
  });

  it("retombe sur 8 h si la valeur est absurde — jamais sur zéro, qui rendrait la garde aveugle", () => {
    expect(parseArgs(["--window-hours", "zéro"]).windowHours).toBe(8);
    expect(parseArgs(["--window-hours", "0"]).windowHours).toBe(8);
  });
});

describe("runsFromFile", () => {
  it("rend une liste vide plutôt que d'exploser sur un fichier absent", () => {
    expect(runsFromFile("/nexiste/pas.json")).toEqual([]);
  });
});
