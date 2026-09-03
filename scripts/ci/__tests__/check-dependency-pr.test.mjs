import { describe, it, expect } from "vitest";

import {
  PRERELEASE_ESCAPE,
  changedManifestDeps,
  findMismatches,
  isPrerelease,
  lockVersions,
  majorOf,
  manifestRanges,
  newPrereleases,
  parseDependencyTitle,
  semverCore,
} from "../check-dependency-pr.mjs";

/**
 * La garde de diff de dépendance (A17, seconde moitié).
 *
 * Le test qui compte est le dernier : **rejouer #716**. Une garde écrite après un
 * incident et jamais confrontée à cet incident n'est qu'une intention — c'est la
 * même exigence que le canari npm 10, qui a été éprouvé dans les deux sens sur une
 * copie du lock avant d'être livré.
 */

describe("semverCore / majorOf — ce que la garde sait lire, et ce qu'elle refuse de deviner", () => {
  it("lit une plage ordinaire", () => {
    expect(semverCore("^1.40.2")).toBe("1.40.2");
    expect(semverCore("~5.2.0")).toBe("5.2.0");
    expect(semverCore(">=2.0.0-rc.1")).toBe("2.0.0-rc.1");
    expect(majorOf("^1.40.2")).toBe(1);
  });

  it("se TAIT sur ce qui n'est pas une version littérale — jamais de faux positif par devinette", () => {
    // Chacune de ces formes décrit autre chose qu'une version unique. Les
    // interpréter reviendrait à bloquer la file sur une lecture approximative.
    expect(semverCore("workspace:*")).toBeNull();
    expect(semverCore("npm:@scope/alias@^1.0.0")).toBeNull();
    expect(semverCore("^1.0.0 || ^2.0.0")).toBeNull();
    expect(semverCore("github:user/repo")).toBeNull();
    expect(semverCore("*")).toBeNull();
    expect(majorOf("workspace:*")).toBeNull();
  });
});

describe("isPrerelease", () => {
  it("reconnaît une préversion", () => {
    expect(isPrerelease("2.0.0-rc.1")).toBe(true);
    expect(isPrerelease("5.20260801.1-alpha")).toBe(true);
  });

  it("ne prend pas un numéro daté pour une préversion", () => {
    // `5.20260801.1` est la forme réelle des versions Cloudflare : le piège est
    // qu'elle RESSEMBLE à quelque chose de spécial sans l'être.
    expect(isPrerelease("5.20260801.1")).toBe(false);
    expect(isPrerelease("4.0.0")).toBe(false);
  });
});

describe("manifestRanges / changedManifestDeps", () => {
  it("rassemble les quatre champs de dépendance", () => {
    const ranges = manifestRanges(
      JSON.stringify({
        dependencies: { react: "^19.0.0" },
        devDependencies: { vitest: "^4.0.0" },
        peerDependencies: { typescript: "^6.0.0" },
        optionalDependencies: { fsevents: "^2.3.0" },
        // Ignoré : ce n'est pas une déclaration de dépendance.
        scripts: { build: "vite build" },
      }),
    );
    expect(ranges).toEqual({
      react: "^19.0.0",
      vitest: "^4.0.0",
      typescript: "^6.0.0",
      fsevents: "^2.3.0",
    });
  });

  it("rend null sur un JSON invalide plutôt que de supposer un manifeste vide", () => {
    // Un manifeste vide se lirait « rien n'a bougé » : la pire réponse possible.
    expect(manifestRanges("{ pas du json")).toBeNull();
  });

  it("voit un déplacement, un ajout et un retrait", () => {
    const moved = changedManifestDeps(
      { react: "^19.0.0", vieux: "^1.0.0" },
      { react: "^19.1.0", neuf: "^2.0.0" },
    );
    expect(moved).toEqual([
      { name: "neuf", from: null, to: "^2.0.0" },
      { name: "react", from: "^19.0.0", to: "^19.1.0" },
      { name: "vieux", from: "^1.0.0", to: null },
    ]);
  });

  it("ne signale rien quand rien ne bouge", () => {
    expect(changedManifestDeps({ react: "^19.0.0" }, { react: "^19.0.0" })).toEqual([]);
  });
});

describe("lockVersions / newPrereleases", () => {
  const lock = (packages) => JSON.stringify({ lockfileVersion: 3, packages });

  it("relève les versions du bloc `packages`", () => {
    expect(lockVersions(lock({ "": {}, "node_modules/react": { version: "19.0.0" } }))).toEqual({
      "node_modules/react": "19.0.0",
    });
  });

  it("rend null sur une forme sans `packages` — pour que l'appelant CRIE au lieu de passer", () => {
    // Une garde qui passe en silence sur ce qu'elle ne comprend pas est une garde
    // qu'on cesse de lire (leçon L-2 de la roadmap).
    expect(lockVersions(JSON.stringify({ lockfileVersion: 1, dependencies: {} }))).toBeNull();
  });

  it("signale la préversion qui ENTRE, pas celle qui était déjà là", () => {
    const base = { "node_modules/deja": "1.0.0-beta.1" };
    const head = {
      "node_modules/deja": "1.0.0-beta.1",
      "node_modules/miniflare": "5.20260801.1-alpha",
    };
    expect(newPrereleases(base, head)).toEqual([
      { version: "5.20260801.1-alpha", path: "node_modules/miniflare" },
    ]);
  });

  it("ne crie pas sur une préversion déjà connue rangée ailleurs", () => {
    // Même version, autre chemin : elle n'entre pas, elle se déplace.
    expect(
      newPrereleases({ "node_modules/x": "1.0.0-rc.1" }, { "node_modules/y/x": "1.0.0-rc.1" }),
    ).toEqual([]);
  });
});

describe("parseDependencyTitle", () => {
  it("lit un titre Dependabot", () => {
    expect(parseDependencyTitle("chore(deps): bump undici from 6.0.0 to 6.1.0")).toMatchObject({
      package: "undici",
      allowsPrerelease: false,
    });
  });

  it("lit un paquet scopé", () => {
    expect(
      parseDependencyTitle("bump @cloudflare/vite-plugin from 1.40.2 to 1.51.1"),
    ).toMatchObject({ package: "@cloudflare/vite-plugin" });
  });

  it("reconnaît les trois ampleurs annonçables", () => {
    expect(parseDependencyTitle("bump x from 1 to 2 · dependency-type: indirect").scope).toBe(
      "indirect",
    );
    expect(parseDependencyTitle("bump x · semver-major").scope).toBe("major");
    expect(parseDependencyTitle("bump x · semver-minor").scope).toBe("small");
  });

  it("ne promet rien sur un titre humain — les règles B se taisent alors", () => {
    // Exiger un format de titre bloquerait toutes les PR non-Dependabot.
    expect(parseDependencyTitle("fix(build): réparer le lockfile")).toEqual({
      package: null,
      scope: null,
      allowsPrerelease: false,
    });
  });

  it("voit l'échappatoire assumée", () => {
    expect(
      parseDependencyTitle(`chore(deps): passer à la RC ${PRERELEASE_ESCAPE}`).allowsPrerelease,
    ).toBe(true);
  });
});

describe("findMismatches", () => {
  it("laisse passer une bump indirecte honnête : le lock bouge, le manifeste non", () => {
    expect(
      findMismatches({
        title: "chore(deps): bump undici from 6.0.0 to 6.1.0 · dependency-type: indirect",
        movedDeps: [],
        prereleases: [],
      }),
    ).toEqual([]);
  });

  it("laisse passer une majeure ANNONCÉE comme telle", () => {
    expect(
      findMismatches({
        title: "chore(deps): bump vite from 7.0.0 to 8.0.0 · semver-major",
        movedDeps: [{ name: "vite", from: "^7.0.0", to: "^8.0.0" }],
        prereleases: [],
      }),
    ).toEqual([]);
  });

  it("A1 — refuse une préversion entrante, quel que soit le titre", () => {
    const findings = findMismatches({
      title: "fix(build): re-synchroniser le lockfile",
      movedDeps: [],
      prereleases: [{ version: "5.20260801.1-alpha", path: "node_modules/miniflare" }],
    });
    expect(findings).toHaveLength(1);
    expect(findings[0].rule).toBe("A1");
    expect(findings[0].message).toContain("5.20260801.1-alpha");
  });

  it("A1 — mais l'assume quand le titre l'assume", () => {
    expect(
      findMismatches({
        title: `chore(deps): miniflare 5 RC ${PRERELEASE_ESCAPE}`,
        movedDeps: [],
        prereleases: [{ version: "5.0.0-alpha", path: "node_modules/miniflare" }],
      }),
    ).toEqual([]);
  });

  it("B1 — « indirect » ne peut pas bouger le manifeste", () => {
    const findings = findMismatches({
      title: "chore(deps): bump undici · dependency-type: indirect",
      movedDeps: [{ name: "undici", from: "^6.0.0", to: "^7.0.0" }],
      prereleases: [],
    });
    expect(findings.map((f) => f.rule)).toContain("B1");
  });

  it("B2 — une majeure sous un titre patch/minor", () => {
    const findings = findMismatches({
      title: "chore(deps): bump vite from 7.9.0 to 7.9.1 · semver-patch",
      movedDeps: [{ name: "vite", from: "^7.0.0", to: "^8.0.0" }],
      prereleases: [],
    });
    expect(findings.map((f) => f.rule)).toContain("B2");
  });

  it("B2 — se tait quand une des deux plages est illisible", () => {
    // `workspace:*` → pas de majeur comparable → aucune conclusion.
    expect(
      findMismatches({
        title: "chore(deps): bump x · semver-patch",
        movedDeps: [{ name: "x", from: "workspace:*", to: "^2.0.0" }],
        prereleases: [],
      }),
    ).toEqual([]);
  });

  it("B3 — le titre nomme un paquet, le diff en bouge un autre", () => {
    const findings = findMismatches({
      title: "chore(deps): bump undici from 6.0.0 to 6.1.0",
      movedDeps: [{ name: "@cloudflare/vite-plugin", from: "^1.40.2", to: "^1.51.1" }],
      prereleases: [],
    });
    expect(findings.map((f) => f.rule)).toContain("B3");
  });

  it("REJOUE #716 — le titre disait « bump undici · indirect », le diff faisait tout autre chose", () => {
    // Les faits exacts de l'incident (docs/dependency-maintenance.md) : une PR
    // intitulée bump indirect d'undici qui montait @cloudflare/vite-plugin de
    // ^1.40.2 à ^1.51.1 et entraînait miniflare 4 → 5.…-alpha.
    // 33 h de Content CI privée rouge, main comprise, gate d'ici vert.
    const findings = findMismatches({
      title: "chore(deps): bump undici from 6.21.1 to 6.21.2 · dependency-type: indirect",
      movedDeps: [{ name: "@cloudflare/vite-plugin", from: "^1.40.2", to: "^1.51.1" }],
      prereleases: [{ version: "5.20260801.1-alpha", path: "node_modules/miniflare" }],
    });

    const rules = findings.map((f) => f.rule);
    // Trois règles indépendantes l'attrapent : l'alpha, le manifeste qui bouge
    // sous un titre « indirect », et le paquet qui n'est pas celui annoncé.
    expect(rules).toContain("A1");
    expect(rules).toContain("B1");
    expect(rules).toContain("B3");
  });
});
