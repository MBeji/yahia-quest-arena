import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it, vi } from "vitest";
import {
  consumeEntrySource,
  entrySurfaceFromPath,
  isStandaloneDisplay,
  readEntrySource,
  stripEntrySource,
  type EntryWindow,
} from "@/shared/lib/entry-source";

/**
 * Étude 40 lot 0 — LA SOURCE D'ENTRÉE (R-3). Critère du lot : `/?src=pwa` ⇒ `entry: "pwa"` et
 * l'adresse affichée redevient `/`.
 */

function fakeWindow(pathname: string, search = "", hash = ""): EntryWindow & { url: string } {
  const win = {
    url: `${pathname}${search}${hash}`,
    location: { pathname, search, hash },
    history: {
      state: { __TSR_index: 3, key: "abc" },
      replaceState: vi.fn((_state: unknown, _title: string, url?: string | URL | null) => {
        win.url = String(url);
      }),
    },
  };
  return win;
}

describe("R-3 — `entry`, lu dans `?src=`", () => {
  it("⭐ reconnaît les quatre sources de la liste fermée", () => {
    expect(readEntrySource("?src=pwa")).toBe("pwa");
    expect(readEntrySource("?src=push")).toBe("push");
    expect(readEntrySource("?src=resume_link")).toBe("resume_link");
    expect(readEntrySource("?a=1&src=share")).toBe("share");
  });

  it("⭐ absent, vide ou inconnu ⇒ `direct` — une valeur libre ne devient jamais une étiquette", () => {
    expect(readEntrySource("")).toBe("direct");
    expect(readEntrySource("?src=")).toBe("direct");
    expect(readEntrySource("?src=PWA")).toBe("direct");
    expect(readEntrySource("?src=jean.dupont%40mail.tn")).toBe("direct");
  });

  it("⭐ `/?src=pwa` ⇒ `pwa`, et l'adresse affichée redevient `/`", () => {
    const win = fakeWindow("/", "?src=pwa");
    expect(consumeEntrySource(win)).toBe("pwa");
    expect(win.url).toBe("/");
  });

  it("⭐ le routeur garde son état d'historique : `replaceState` reçoit l'état courant", () => {
    const win = fakeWindow("/", "?src=pwa");
    consumeEntrySource(win);
    expect(win.history.replaceState).toHaveBeenCalledWith(win.history.state, "", "/");
  });

  it("ne retire QUE `src` : les autres paramètres et l'ancre restent", () => {
    expect(
      stripEntrySource({ pathname: "/chapitre/c1", search: "?lang=ar&src=share&x=1", hash: "#q2" }),
    ).toBe("/chapitre/c1?lang=ar&x=1#q2");
  });

  it("sans `src` connu, l'adresse n'est pas touchée", () => {
    for (const search of ["", "?lang=ar", "?src=ailleurs"]) {
      const win = fakeWindow("/programme", search);
      expect(consumeEntrySource(win)).toBe("direct");
      expect(win.history.replaceState).not.toHaveBeenCalled();
    }
  });

  it("historique verrouillé ⇒ la source est rendue quand même, sans lever", () => {
    const win = fakeWindow("/", "?src=push");
    vi.mocked(win.history.replaceState).mockImplementation(() => {
      throw new Error("SecurityError");
    });
    expect(consumeEntrySource(win)).toBe("push");
  });

  it("⭐ dans le navigateur, retirer `?src=` n'est PAS une navigation : le `replaceState` du routeur n'est pas appelé", () => {
    // Le routeur remplace `window.history.replaceState` par le sien, qui re-résout la page :
    // passer par lui émettait une seconde page vue (mesuré sur le bundle de production).
    window.history.replaceState({ key: "k1" }, "", "/programme?src=pwa&x=1#a");
    const routerPatch = vi.fn();
    const native = window.history.replaceState;
    window.history.replaceState = routerPatch;
    try {
      expect(consumeEntrySource()).toBe("pwa");
      expect(routerPatch).not.toHaveBeenCalled();
      expect(`${window.location.pathname}${window.location.search}${window.location.hash}`).toBe(
        "/programme?x=1#a",
      );
      // L'état d'historique du routeur est repassé tel quel.
      expect(window.history.state).toEqual({ key: "k1" });
    } finally {
      window.history.replaceState = native;
      window.history.replaceState(null, "", "/");
    }
  });

  it("dans le navigateur, sans `?src=` ⇒ `direct`, et l'adresse ne bouge pas", () => {
    window.history.replaceState(null, "", "/suivi?lang=ar");
    expect(consumeEntrySource()).toBe("direct");
    expect(window.location.search).toBe("?lang=ar");
    window.history.replaceState(null, "", "/");
  });
});

describe("R-3 — `entry_surface`, déduit du chemin, jamais l'adresse", () => {
  it("⭐ chaque genre de page a son étiquette, routes publiques et connectées", () => {
    const cases: Array<[string, string]> = [
      ["/", "accueil"],
      ["", "accueil"],
      ["/chapitre/9f0c-uuid", "chapitre"],
      ["/lesson/9f0c-uuid", "chapitre"],
      ["/exercice/e-1", "exercice"],
      ["/quest/e-1", "exercice"],
      ["/matiere/math-9eme", "matiere"],
      ["/subject/math-9eme", "matiere"],
      ["/niveau/scolaire-9eme", "niveau"],
      ["/programme", "niveau"],
      ["/programme/lycee/2", "niveau"],
      ["/test-de-niveau", "test"],
      ["/test-de-niveau/s-1", "test"],
      ["/suivi", "suivi"],
      ["/parent-report", "suivi"],
      ["/auth", "compte"],
      ["/login", "compte"],
      ["/signup", "compte"],
      ["/dashboard", "autre"],
      ["/conditions", "autre"],
    ];
    for (const [path, surface] of cases) expect(entrySurfaceFromPath(path), path).toBe(surface);
  });

  it("⭐ l'identifiant du chapitre ne ressort jamais", () => {
    expect(entrySurfaceFromPath("/chapitre/secret-chapter-id")).not.toContain("secret");
  });
});

describe("`standalone` — installée, ou dans un onglet", () => {
  it("lit la media query, et `navigator.standalone` pour Safari iOS", () => {
    expect(isStandaloneDisplay({ matchMedia: () => ({ matches: true }) })).toBe(true);
    expect(isStandaloneDisplay({ matchMedia: () => ({ matches: false }) })).toBe(false);
    expect(isStandaloneDisplay({ navigator: { standalone: true } })).toBe(true);
    expect(isStandaloneDisplay(undefined)).toBe(false);
  });

  it("une media query qui lève ne casse rien", () => {
    expect(
      isStandaloneDisplay({
        matchMedia: () => {
          throw new Error("boom");
        },
      }),
    ).toBe(false);
  });
});

describe("le module est pur", () => {
  it("n'importe rien", () => {
    const source = readFileSync(join(process.cwd(), "src/shared/lib/entry-source.ts"), "utf8");
    expect(source).not.toMatch(/^import /m);
  });
});
