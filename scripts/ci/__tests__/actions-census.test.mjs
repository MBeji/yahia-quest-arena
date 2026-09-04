// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  billedMinutes,
  dedupe,
  formatReport,
  parseArgs,
  runsFromDump,
  summarise,
} from "../actions-census.mjs";

/**
 * Fixtures calquées sur de VRAIS runs relevés le 2026-09-03 (étude 32 §2.2 et annexe A) :
 * un fantôme de `pull_request` à zéro job, le Pin check dispatché de 10 s qui coûte quand
 * même une minute, et un Content CI de 33 s. Le rapport ne vaut que ce qu'il reconnaît de
 * la forme réelle de l'API.
 */
const run = (over = {}) => ({
  id: Math.floor(Math.random() * 1e9),
  name: "Content CI",
  event: "pull_request",
  conclusion: "success",
  status: "completed",
  head_branch: "claude/une-branche",
  created_at: "2026-09-03T21:12:03Z",
  run_started_at: "2026-09-03T21:12:06Z",
  updated_at: "2026-09-03T21:12:39Z",
  ...over,
});

describe("billedMinutes", () => {
  it("facture une minute entamée pour un job de neuf secondes", () => {
    // Automerge, run 33806678119 : 21:12:40 → 21:12:49. Neuf secondes, une minute payée.
    // C'est tout le sujet du constat C-3 : ce sont les jobs COURTS qui coûtent.
    expect(
      billedMinutes(
        run({ run_started_at: "2026-09-03T21:12:40Z", updated_at: "2026-09-03T21:12:49Z" }),
      ),
    ).toBe(1);
  });

  it("arrondit vers le haut, jamais vers le bas", () => {
    expect(
      billedMinutes(
        run({ run_started_at: "2026-09-03T21:00:00Z", updated_at: "2026-09-03T21:04:10Z" }),
      ),
    ).toBe(5);
  });

  it("rend une minute quand les horodatages manquent ou sont incohérents", () => {
    expect(billedMinutes({})).toBe(1);
    expect(
      billedMinutes(
        run({ run_started_at: "2026-09-03T21:10:00Z", updated_at: "2026-09-03T21:00:00Z" }),
      ),
    ).toBe(1);
  });
});

describe("dedupe", () => {
  it("garde un seul exemplaire d'un run vu sur deux pages", () => {
    // Les pages se recouvrent dès qu'un run naît pendant la lecture : sans ce filtre, le
    // relevé de l'étude aurait compté 1 600 runs au lieu de 800.
    const a = run({ id: 1 });
    expect(dedupe([a, run({ id: 2 }), { ...a }])).toHaveLength(2);
  });

  it("ignore les entrées vides sans exploser", () => {
    expect(dedupe([null, undefined, run({ id: 3 })])).toHaveLength(1);
    expect(dedupe(undefined)).toEqual([]);
  });
});

describe("summarise", () => {
  const window = (h) => `2026-09-03T${String(h).padStart(2, "0")}:00:00Z`;

  it("rend une fenêtre, une cadence et un classement par workflow", () => {
    const runs = [
      run({ id: 1, created_at: window(0), run_started_at: window(0), updated_at: window(0) }),
      run({ id: 2, name: "Pin check", created_at: window(12) }),
      run({ id: 3, name: "Pin check", created_at: window(23) }),
    ];
    const s = summarise(runs);
    expect(s.total).toBe(3);
    expect(s.from).toBe(window(0));
    expect(s.days).toBeCloseTo(23 / 24, 2);
    expect(s.workflows[0]).toMatchObject({ name: "Pin check", runs: 2 });
  });

  it("ne facture PAS un fantôme, et le sort des conclusions rouges", () => {
    // Le cœur du constat C-1 : ces runs sortent `failure` et n'ont rien évalué. Les
    // compter comme des échecs, c'est l'erreur qui a coûté #280, #291 et #293 ; les
    // facturer serait une seconde erreur, ils ne consomment aucun runner.
    const runs = [run({ id: 1, conclusion: "failure" }), run({ id: 2, conclusion: "success" })];
    const s = summarise(runs, { phantomIds: new Set([1]) });
    expect(s.phantoms).toBe(1);
    expect(s.minutes).toBe(1);
    expect(s.workflows[0].conclusions).toEqual({ "fantôme (0 job)": 1, success: 1 });
  });

  it("compte les branches hors défaut et les runs par branche", () => {
    const runs = [
      run({ id: 1, head_branch: "main" }),
      run({ id: 2, head_branch: "claude/a" }),
      run({ id: 3, head_branch: "claude/a" }),
      run({ id: 4, head_branch: "claude/b" }),
    ];
    const s = summarise(runs);
    expect(s.branches).toBe(2);
    expect(s.runsPerBranch).toBe(1.5);
  });

  it("plancher d'une heure : une fenêtre de deux minutes ne rend pas une cadence absurde", () => {
    const runs = [
      run({ id: 1, created_at: "2026-09-03T21:00:00Z" }),
      run({ id: 2, created_at: "2026-09-03T21:02:00Z" }),
    ];
    expect(summarise(runs).days).toBeCloseTo(1 / 24, 4);
  });

  it("rend un résumé vide plutôt que d'échouer sur zéro run", () => {
    expect(summarise([])).toMatchObject({ total: 0, workflows: [], phantoms: 0 });
  });
});

describe("formatReport", () => {
  it("annonce la part de fantômes", () => {
    const runs = [run({ id: 1, conclusion: "failure" }), run({ id: 2 })];
    const text = formatReport(summarise(runs, { phantomIds: new Set([1]) }), { repo: "o/r" });
    expect(text).toContain("fantômes  1 (50 %)");
  });

  it("dit que la colonne n'est PAS une mesure quand la sonde est coupée", () => {
    // Un zéro non sondé ressemble trait pour trait à un zéro mesuré : c'est exactement la
    // confusion que ce script existe pour tuer.
    const text = formatReport(summarise([run({ id: 1 })]), { repo: "o/r", probed: false });
    expect(text).toContain("non sondés");
    expect(text).not.toContain("(0 %)");
  });

  it("ne casse pas sur un relevé vide", () => {
    expect(formatReport(summarise([]), { repo: "o/r" })).toContain("aucun run lu");
  });
});

describe("runsFromDump", () => {
  it("lit la réponse brute de l'API comme un tableau nu", () => {
    expect(runsFromDump(JSON.stringify({ workflow_runs: [run({ id: 1 })] }))).toHaveLength(1);
    expect(runsFromDump(JSON.stringify([run({ id: 1 }), run({ id: 2 })]))).toHaveLength(2);
  });

  it("rend une liste vide plutôt que d'exploser sur un fichier illisible", () => {
    expect(runsFromDump("pas du json")).toEqual([]);
    expect(runsFromDump(JSON.stringify({ message: "Not Found" }))).toEqual([]);
  });
});

describe("parseArgs", () => {
  it("lit le dépôt et les options", () => {
    expect(parseArgs(["--repo", "o/r", "--pages", "3", "--json", "--no-probe"])).toEqual({
      repo: "o/r",
      pages: 3,
      perPage: 100,
      json: true,
      probe: false,
      from: [],
    });
  });

  it("ramène une pagination absurde aux valeurs par défaut", () => {
    expect(parseArgs(["--pages", "0", "--per-page", "500"])).toMatchObject({
      pages: 8,
      perPage: 100,
    });
  });

  it("coupe la sonde dès qu'on rejoue un dump — elle n'aurait rien à interroger", () => {
    const args = parseArgs(["--from", "a.json", "--from", "b.json"]);
    expect(args.from).toEqual(["a.json", "b.json"]);
    expect(args.probe).toBe(false);
  });
});
