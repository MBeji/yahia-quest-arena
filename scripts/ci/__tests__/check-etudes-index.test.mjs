// @vitest-environment node
import { mkdtempSync, mkdirSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

import {
  canonicalStatus,
  deadLinks,
  findContradictions,
  headerStatusLine,
  normalize,
  parseIndexRows,
  statusClaims,
} from "../check-etudes-index.mjs";

// Verbatim from the two repos on 2026-09-12 — a gate is worth exactly what it
// reads correctly on the real files, and every one of these strings is a cell or
// a header the first draft of this gate got wrong at least once.
const REAL = {
  header21: "**LIVRÉE le 2026-09-06** — 5 lots sur 6 (le lot 3 est **abandonné**, pas en",
  header16: "en exécution (validée le 2026-07-11, arbitrages Q-1…Q-5 ; lots 0–3 livrés",
  header11: "**EN EXÉCUTION — 6 lots sur 8 livrés**, constatés sur `main` le 2026-08-24.",
  header24: "**scission faite** — lots 1, 2, 3a, 3b et 4 livrés et clos, opération prod",
  header31: "**LIVRÉE EN PRODUCTION le 2026-09-03**",
  cell26: "**lot 1 livré** (1/2)",
  cell11: "**en exécution** (6/8)",
  rowLivrees: "**Livrées** — dossier dans `EtudeRealisé/`",
};

describe("canonicalStatus", () => {
  it("reads a status through bold, case and accents", () => {
    expect(canonicalStatus(REAL.header21)).toBe("livrée");
    expect(canonicalStatus(REAL.header31)).toBe("livrée");
    expect(canonicalStatus("**livrée**")).toBe("livrée");
    expect(canonicalStatus("livree")).toBe("livrée");
  });

  it("reads the plural the STATUS.md §4 row labels use", () => {
    // §4 groups études by state, so its labels are plural. Matching the singular
    // only would make the whole T check silently vacuous — it would find no row
    // to compare and report a clean topo whatever it said.
    expect(canonicalStatus(REAL.rowLivrees)).toBe("livrée");
    expect(canonicalStatus("**Gelées**")).toBe("gelée");
    expect(canonicalStatus("**Validées**")).toBe("validée");
    expect(canonicalStatus("**Brouillons**")).toBe("brouillon");
  });

  it("takes the status the text OPENS with, not any it mentions later", () => {
    // é16 mentions `validée` in a parenthesis about its own validation date, and
    // é11 mentions `livrés` about its lots. Searching anywhere would file é16 as
    // validated and é11 as delivered — both wrong, and the second one is exactly
    // the mistake the topo made.
    expect(canonicalStatus(REAL.header16)).toBe("en exécution");
    expect(canonicalStatus(REAL.header11)).toBe("en exécution");
    expect(canonicalStatus(REAL.header24)).toBe("scission faite");
  });

  it("refuses a progress note — it is not a status", () => {
    // The real é26 index cell. Reading `livré` out of it would file an étude with
    // one lot of two as delivered.
    expect(canonicalStatus(REAL.cell26)).toBeNull();
    expect(canonicalStatus("")).toBeNull();
    expect(canonicalStatus("2/6 lots")).toBeNull();
  });

  it("does not mistake a longer word for a status", () => {
    expect(canonicalStatus("validation humaine attendue")).toBeNull();
    expect(canonicalStatus("livraison prévue en octobre")).toBeNull();
  });

  it("keeps `normalize` free of accents and emphasis", () => {
    expect(normalize("**EN EXÉCUTION** (6/8)")).toBe("en execution (6/8)");
  });
});

describe("parseIndexRows", () => {
  const INDEX = [
    "| #   | étude | valeur | complexité | statut | dépend de |",
    "| --- | ----- | ------ | ---------- | ------ | --------- |",
    "| 01  | [Paiement](01-paiement-en-ligne/ETUDE.md) | 💰 | moyenne+ | **gelée** | — |",
    "| 26  | [Doctrine](26-doctrine-verticale/ETUDE.md) | 🎯 | faible+ | **lot 1 livré** (1/2) | rien |",
    "| 32  | [Harness](EtudeRealisé/32-harness-optimisation/ETUDE.md) | 🔧 | faible | **livrée** | — |",
  ].join("\n");

  it("reads number, link and status of every étude row", () => {
    const rows = parseIndexRows(INDEX);
    expect(rows.map((r) => r.num)).toEqual(["01", "26", "32"]);
    expect(rows[2].link).toBe("EtudeRealisé/32-harness-optimisation/ETUDE.md");
    expect(canonicalStatus(rows[0].status)).toBe("gelée");
  });

  it("finds the `statut` column by its LABEL, never by position", () => {
    // The table has gained a column twice since the split. A hardcoded index
    // would read `complexité` and compare a cost to a status — green forever.
    const moved = INDEX.split("\n")
      .map((line) =>
        line.replace(
          /\| (statut|complexité) \|/,
          (_, c) => `| ${c === "statut" ? "complexité" : "statut"} |`,
        ),
      )
      .join("\n");
    const rows = parseIndexRows(
      moved.replace("| 🔧 | faible | **livrée** |", "| 🔧 | **livrée** | faible |"),
    );
    expect(rows.find((r) => r.num === "32")?.status).toContain("livrée");
  });

  it("returns nothing when the table has no `statut` column", () => {
    expect(parseIndexRows("| # | étude |\n| - | - |\n| 01 | x |")).toEqual([]);
  });
});

describe("headerStatusLine", () => {
  it("reads the quoted `**Statut** :` line of an ETUDE.md", () => {
    const md = `# Étude 21 — Valorisation\n\n> **Statut** : ${REAL.header21}\n> **Priorité** : haute\n`;
    expect(headerStatusLine(md)).toBe(REAL.header21);
  });

  it("ignores a later mention of the word `statut`", () => {
    const md = "# Étude 25\n\n> **Statut** : validée (2026-07-19)\n\n- les statuts d'études.\n";
    expect(headerStatusLine(md)).toBe("validée (2026-07-19)");
  });

  it("returns null when the header carries no status at all", () => {
    expect(headerStatusLine("# Étude 99\n\n> **Priorité** : basse\n")).toBeNull();
  });
});

describe("statusClaims", () => {
  const TOPO = [
    "## 3. État réel",
    "| **Livrées** | **31** l'envie de revenir |",
    "",
    "## 4. Études (FableEtudes) — instantané",
    "",
    "| État | Études |",
    "| ---- | ------ |",
    "| **Livrées** — dossier dans `EtudeRealisé/` | **11** tuteur IA · **31** l'envie de revenir |",
    "| **En exécution** | **25** harness AI-native · **31** l'envie de revenir (**8** lots) |",
    "| **Gelées** | **06** PWA offline, **10** anti-fraude |",
    "",
    "## 5. Programme go-live",
    "| **Validées** | **21** valorisation |",
  ].join("\n");
  const KNOWN = new Set(["06", "10", "11", "21", "25", "31"]);

  it("reads §4 only — a bolded number elsewhere is not a status claim", () => {
    const claims = statusClaims(TOPO, KNOWN);
    expect(claims.get("21")).toBeUndefined();
    expect(claims.get("11")?.map((c) => c.state)).toEqual(["livrée"]);
  });

  it("records the same étude filed under two states", () => {
    // é31 was in both rows on 2026-09-12 — a contradiction that needs no second
    // file to prove.
    expect(
      statusClaims(TOPO, KNOWN)
        .get("31")
        ?.map((c) => c.state),
    ).toEqual(["livrée", "en exécution"]);
  });

  it("ignores a bolded number that is not a known étude", () => {
    // `(**8** lots)` sits in the é31 cell. Counting it as étude 08 would file a
    // brouillon as in execution, from a lot count.
    expect(statusClaims(TOPO, KNOWN).get("08")).toBeUndefined();
  });

  it("reads every étude of a multi-étude cell", () => {
    const claims = statusClaims(TOPO, KNOWN);
    expect(claims.get("06")?.[0].state).toBe("gelée");
    expect(claims.get("10")?.[0].state).toBe("gelée");
  });
});

describe("findContradictions", () => {
  const base = {
    rows: [{ num: "21", link: "21-x/ETUDE.md", status: "**LIVRÉE** (5/6)" }],
    headers: new Map([["21", REAL.header21]]),
    paths: new Map([["21", "21-x"]]),
    claims: new Map(),
  };

  it("is silent when the three places agree", () => {
    expect(
      findContradictions({
        ...base,
        paths: new Map([["21", "EtudeRealisé/21-x"]]),
      }),
    ).toEqual([]);
  });

  it("reports a `livrée` étude still filed outside EtudeRealisé/", () => {
    const found = findContradictions(base);
    expect(found).toHaveLength(1);
    expect(found[0]).toMatchObject({ code: "R", num: "21" });
  });

  it("reports an index cell that contradicts the ETUDE.md header", () => {
    const found = findContradictions({
      rows: [{ num: "25", link: "25-x/ETUDE.md", status: "**en exécution**" }],
      headers: new Map([["25", "validée (2026-07-19)"]]),
      paths: new Map([["25", "25-x"]]),
      claims: new Map(),
    });
    expect(found).toEqual([
      {
        code: "S",
        num: "25",
        detail: "l'index dit « en exécution », son ETUDE.md dit « validée »",
      },
    ]);
  });

  it("reports a folder in EtudeRealisé/ whose étude is not delivered", () => {
    const found = findContradictions({
      rows: [{ num: "09", link: "EtudeRealisé/09-x/ETUDE.md", status: "**en exécution**" }],
      headers: new Map([["09", "en exécution"]]),
      paths: new Map([["09", "EtudeRealisé/09-x"]]),
      claims: new Map(),
    });
    expect(found[0]).toMatchObject({ code: "R", num: "09" });
  });

  it("reports STATUS.md contradicting the étude, and the double filing", () => {
    const found = findContradictions({
      rows: [{ num: "31", link: "EtudeRealisé/31-x/ETUDE.md", status: "**livrée**" }],
      headers: new Map([["31", REAL.header31]]),
      paths: new Map([["31", "EtudeRealisé/31-x"]]),
      claims: new Map([
        [
          "31",
          [
            { state: "livrée", label: "Livrées" },
            { state: "en exécution", label: "En exécution" },
          ],
        ],
      ]),
    });
    expect(found.map((p) => p.code)).toEqual(["T", "T"]);
    expect(found[0].detail).toContain("En exécution");
    expect(found[1].detail).toContain("DEUX fois");
  });

  it("reports an unreadable status cell instead of guessing one", () => {
    const found = findContradictions({
      rows: [{ num: "26", link: "26-x/ETUDE.md", status: REAL.cell26 }],
      headers: new Map([["26", "validée — Q-1…Q-5 arbitrées"]]),
      paths: new Map([["26", "26-x"]]),
      claims: new Map(),
    });
    expect(found).toHaveLength(1);
    expect(found[0].detail).toContain("n'est pas un statut du cycle de vie");
  });

  it("says nothing about an étude no document contradicts", () => {
    // The boundary of the gate (#994 § « Ce que ça ne doit pas devenir ») : a doc
    // that stays SILENT about an étude is fine. Only a false assertion costs.
    expect(
      findContradictions({
        rows: [{ num: "13", link: "EtudeRealisé/13-x/ETUDE.md", status: "livrée" }],
        headers: new Map([["13", "livrée"]]),
        paths: new Map([["13", "EtudeRealisé/13-x"]]),
        claims: new Map(),
      }),
    ).toEqual([]);
  });
});

describe("deadLinks", () => {
  const dir = mkdtempSync(join(tmpdir(), "etudes-"));
  mkdirSync(join(dir, "EtudeRealisé", "32-h"), { recursive: true });
  writeFileSync(join(dir, "EtudeRealisé", "32-h", "ETUDE.md"), "# ok\n");
  const file = join(dir, "README.md");

  it("reports a link whose target does not exist", () => {
    // privé#354, verbatim: é32 marked `livrée` while pointing at the path it had
    // just left. The link went green.
    writeFileSync(file, "[é32](32-harness-optimisation/ETUDE.md)\n");
    expect(deadLinks("[é32](32-harness-optimisation/ETUDE.md)", file)).toEqual([
      "32-harness-optimisation/ETUDE.md",
    ]);
  });

  it("resolves a percent-escaped path — the folder is accented", () => {
    const md = "[é32](EtudeRealis%C3%A9/32-h/ETUDE.md)\n";
    expect(deadLinks(md, file)).toEqual([]);
  });

  it("keeps an anchor out of the filesystem", () => {
    expect(deadLinks("[lot 4](EtudeRealisé/32-h/ETUDE.md#lot-4)\n", file)).toEqual([]);
    expect(deadLinks("[§4](#backlog--reste-à-faire)\n", file)).toEqual([]);
  });

  it("ignores what is not a file link", () => {
    const md = "[repo](https://github.com/MBeji/x) [mail](mailto:a@b.c)\n";
    expect(deadLinks(md, file)).toEqual([]);
  });
});
