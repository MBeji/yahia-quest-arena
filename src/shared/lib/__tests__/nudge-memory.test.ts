// @vitest-environment node
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import {
  NUDGE_KEY,
  NUDGE_ORDER,
  canShow,
  chooseNudge,
  isNudgeDue,
  markDismissed,
  markSettled,
  markShown,
  parseNudgeMemory,
  type NudgeStorage,
} from "@/shared/lib/nudge-memory";

/**
 * Étude 40 lot 3 — LA MÉMOIRE COMMUNE DES INVITATIONS (R-12). Chaque clause de la règle a son
 * test nommé : pas deux fois en 14 jours (7 pour `push`), deux refus ⇒ plus jamais, une seule
 * invitation par écran dans l'ordre rappel → installation → parent, stockage indisponible ⇒ rien.
 */

function memoryStorage(initial?: string): NudgeStorage & { value: string | null; writes: number } {
  const store = {
    value: initial ?? null,
    writes: 0,
    getItem: (key: string) => (key === NUDGE_KEY ? store.value : null),
    setItem: (key: string, value: string) => {
      if (key !== NUDGE_KEY) throw new Error(`clé inattendue : ${key}`);
      store.value = value;
      store.writes += 1;
    },
  };
  return store;
}

const throwing: NudgeStorage = {
  getItem: () => {
    throw new Error("SecurityError");
  },
  setItem: () => {
    throw new Error("QuotaExceededError");
  },
};

describe("R-12 — la forme de la mémoire", () => {
  it("⭐ écrit { [kind]: { shown, dismissed } } sous `na9ra.nudge`, et rien d'autre", () => {
    const storage = memoryStorage();
    expect(markShown("install", "2026-11-13", storage)).toBe(true);
    expect(NUDGE_KEY).toBe("na9ra.nudge");
    expect(JSON.parse(storage.value ?? "")).toEqual({
      install: { shown: "2026-11-13", dismissed: 0 },
    });
  });

  it("une invitation n'efface pas la mémoire d'une autre", () => {
    const storage = memoryStorage();
    markDismissed("push", "2026-11-01", storage);
    markShown("install", "2026-11-13", storage);
    expect(JSON.parse(storage.value ?? "")).toEqual({
      push: { shown: "2026-11-01", dismissed: 1 },
      install: { shown: "2026-11-13", dismissed: 0 },
    });
  });

  it("⭐ elle n'est jamais envoyée : le module n'importe RIEN", () => {
    const source = readFileSync(join(process.cwd(), "src/shared/lib/nudge-memory.ts"), "utf8");
    expect(source).not.toMatch(/^import /m);
    expect(source).not.toMatch(/fetch\(|sendBeacon|XMLHttpRequest/);
  });

  it("une mémoire abîmée est lue comme vide, genre par genre — elle ne fait pas taire pour toujours", () => {
    expect(parseNudgeMemory("{pas du json")).toEqual({});
    expect(parseNudgeMemory('"texte"')).toEqual({});
    expect(
      parseNudgeMemory(
        JSON.stringify({
          install: { shown: "2026-02-31", dismissed: 0 },
          push: { shown: "2026-11-01", dismissed: -1 },
          parent: { shown: "2026-11-02", dismissed: 1 },
          autre: { shown: "2026-11-02", dismissed: 0 },
        }),
      ),
    ).toEqual({ parent: { shown: "2026-11-02", dismissed: 1 } });
    expect(canShow("install", "2026-11-13", memoryStorage("{pas du json"))).toBe(true);
  });
});

describe("R-12 — pas deux fois en 14 jours (7 pour le rappel)", () => {
  it("⭐ jamais montrée ⇒ proposable", () => {
    expect(canShow("install", "2026-11-13", memoryStorage())).toBe(true);
  });

  it("⭐ montrée aujourd'hui ⇒ plus proposable, ni le jour même ni au 13ᵉ jour ; au 14ᵉ, oui", () => {
    const storage = memoryStorage();
    markShown("install", "2026-11-13", storage);
    expect(canShow("install", "2026-11-13", storage)).toBe(false);
    expect(canShow("install", "2026-11-26", storage)).toBe(false);
    expect(canShow("install", "2026-11-27", storage)).toBe(true);
  });

  it("⭐ `parent` suit le même délai de 14 jours", () => {
    const storage = memoryStorage();
    markShown("parent", "2026-11-13", storage);
    expect(canShow("parent", "2026-11-26", storage)).toBe(false);
    expect(canShow("parent", "2026-11-27", storage)).toBe(true);
  });

  it("⭐ `push` revient au bout de 7 jours", () => {
    const storage = memoryStorage();
    markShown("push", "2026-11-13", storage);
    expect(canShow("push", "2026-11-19", storage)).toBe(false);
    expect(canShow("push", "2026-11-20", storage)).toBe(true);
  });

  it("le délai enjambe un changement de mois et d'année", () => {
    const storage = memoryStorage();
    markShown("install", "2026-12-25", storage);
    expect(canShow("install", "2027-01-07", storage)).toBe(false);
    expect(canShow("install", "2027-01-08", storage)).toBe(true);
  });

  it("horloge reculée (`shown` dans le futur) ⇒ rien", () => {
    const storage = memoryStorage();
    markShown("install", "2026-11-13", storage);
    expect(canShow("install", "2026-11-01", storage)).toBe(false);
  });

  it("un « jour » qui n'en est pas un ⇒ rien, et rien n'est écrit", () => {
    const storage = memoryStorage();
    for (const today of ["", "13/11/2026", "2026-11-13T10:00:00Z", "2026-13-01"]) {
      expect(canShow("install", today, storage), today).toBe(false);
      expect(markShown("install", today, storage), today).toBe(false);
      expect(markDismissed("install", today, storage), today).toBe(false);
    }
    expect(storage.writes).toBe(0);
  });
});

describe("R-12 — deux refus ⇒ plus jamais", () => {
  it("⭐ un refus : pas avant 14 jours, puis de nouveau proposable", () => {
    const storage = memoryStorage();
    markShown("install", "2026-11-13", storage);
    markDismissed("install", "2026-11-13", storage);
    expect(JSON.parse(storage.value ?? "").install).toEqual({ shown: "2026-11-13", dismissed: 1 });
    expect(canShow("install", "2026-11-26", storage)).toBe(false);
    expect(canShow("install", "2026-11-27", storage)).toBe(true);
  });

  it("⭐ deux refus : plus jamais, même un an plus tard", () => {
    const storage = memoryStorage();
    markDismissed("install", "2026-11-13", storage);
    markDismissed("install", "2026-11-27", storage);
    expect(canShow("install", "2026-12-11", storage)).toBe(false);
    expect(canShow("install", "2027-11-27", storage)).toBe(false);
  });

  it("montrer de nouveau ne remet pas le compteur de refus à zéro", () => {
    const storage = memoryStorage();
    markDismissed("install", "2026-11-13", storage);
    markShown("install", "2026-11-27", storage);
    expect(JSON.parse(storage.value ?? "").install).toEqual({ shown: "2026-11-27", dismissed: 1 });
  });

  it("⭐ acceptée (`markSettled`) : elle disparaît pour toujours, sans changer la forme de la mémoire", () => {
    const storage = memoryStorage();
    markShown("install", "2026-11-13", storage);
    expect(markSettled("install", "2026-11-13", storage)).toBe(true);
    expect(JSON.parse(storage.value ?? "").install).toEqual({ shown: "2026-11-13", dismissed: 2 });
    expect(canShow("install", "2027-11-13", storage)).toBe(false);
  });
});

describe("R-12 — une seule invitation par écran, dans l'ordre rappel → installation → parent", () => {
  it("⭐ l'ordre est fermé", () => {
    expect(NUDGE_ORDER).toEqual(["push", "install", "parent"]);
  });

  it("⭐ le rappel passe devant l'installation, quel que soit l'ordre où l'écran les déclare", () => {
    expect(chooseNudge(["parent", "install", "push"], "2026-11-13", memoryStorage())).toBe("push");
  });

  it("⭐ l'installation ne paraît que si le rappel ne paraît pas", () => {
    const storage = memoryStorage();
    markShown("push", "2026-11-13", storage);
    expect(chooseNudge(["push", "install", "parent"], "2026-11-13", storage)).toBe("install");
    markShown("install", "2026-11-13", storage);
    expect(chooseNudge(["push", "install", "parent"], "2026-11-13", storage)).toBe("parent");
    markShown("parent", "2026-11-13", storage);
    expect(chooseNudge(["push", "install", "parent"], "2026-11-13", storage)).toBeNull();
  });

  it("un écran qui ne sait rien proposer ne propose rien", () => {
    expect(chooseNudge([], "2026-11-13", memoryStorage())).toBeNull();
  });
});

describe("R-12 — stockage indisponible ⇒ aucune invitation", () => {
  it("⭐ pas de stockage (rendu serveur, navigation privée) ⇒ rien, et rien ne lève", () => {
    expect(canShow("install", "2026-11-13", null)).toBe(false);
    expect(markShown("install", "2026-11-13", null)).toBe(false);
    expect(markDismissed("install", "2026-11-13", null)).toBe(false);
    expect(markSettled("install", "2026-11-13", null)).toBe(false);
    expect(chooseNudge(["install"], "2026-11-13", null)).toBeNull();
  });

  it("⭐ sans `window` (rendu serveur), le stockage par défaut est absent ⇒ rien", () => {
    expect(canShow("install", "2026-11-13")).toBe(false);
    expect(markShown("install", "2026-11-13")).toBe(false);
  });

  it("⭐ un stockage qui lève (accès refusé, quota plein) ⇒ rien, et `markShown` dit que l'écriture n'a pas tenu", () => {
    expect(canShow("install", "2026-11-13", throwing)).toBe(false);
    expect(markShown("install", "2026-11-13", throwing)).toBe(false);
    const readOnly: NudgeStorage = { getItem: () => null, setItem: throwing.setItem };
    expect(canShow("install", "2026-11-13", readOnly)).toBe(true);
    expect(markShown("install", "2026-11-13", readOnly)).toBe(false);
  });

  it("`isNudgeDue` est pur : il ne lit que la mémoire qu'on lui passe", () => {
    expect(isNudgeDue({}, "install", "2026-11-13")).toBe(true);
    expect(
      isNudgeDue({ install: { shown: "2026-11-13", dismissed: 0 } }, "install", "2026-11-13"),
    ).toBe(false);
  });
});
