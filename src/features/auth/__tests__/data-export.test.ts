import { describe, it, expect } from "vitest";

import { countExportedRows, userDataExportFileName } from "../data-export";

/**
 * La part PURE de la portabilité (GAP-024).
 *
 * Ce qui est testé ici n'est PAS ce que l'export contient — cette question se
 * décide dans `pg_constraint` et se vérifie en pgTAP
 * (`supabase/tests/85_export_user_data.test.sql`). Ce sont les deux seules
 * décisions que TypeScript prend dans toute la chaîne : comment s'appelle le
 * fichier qu'on tend à la personne, et ce qu'on lui dit de ce qu'elle vient de
 * télécharger.
 */
describe("userDataExportFileName", () => {
  it("nomme le fichier par sa date, pour qu'il se reconnaisse six mois plus tard", () => {
    expect(userDataExportFileName("2026-09-02T14:31:07Z")).toBe(
      "na9ra-nal3ab-mes-donnees-2026-09-02.json",
    );
  });

  it("ne garde que le JOUR — un `:` d'horodatage rendrait le nom illégal sous Windows", () => {
    const name = userDataExportFileName("2026-09-02T14:31:07Z");
    expect(name).not.toContain(":");
    expect(/[\\/:*?"<>|]/.test(name)).toBe(false);
  });

  it("ne porte NI adresse NI pseudo — le nom d'un fichier voyage plus loin que lui", () => {
    // La signature ne prend qu'un horodatage : il n'y a rien d'autre à divulguer.
    // Ce test fige l'intention, pour qu'ajouter l'adresse « pour aider » se voie.
    expect(userDataExportFileName("2026-01-05T00:00:00.000Z")).toBe(
      "na9ra-nal3ab-mes-donnees-2026-01-05.json",
    );
  });

  it("retombe sur un nom valide si l'horodatage est illisible plutôt que de produire `undefined`", () => {
    expect(userDataExportFileName("")).toBe("na9ra-nal3ab-mes-donnees-export.json");
    expect(userDataExportFileName("pas une date")).toBe("na9ra-nal3ab-mes-donnees-export.json");
  });
});

describe("countExportedRows", () => {
  it("additionne les lignes de toutes les tables", () => {
    expect(
      countExportedRows({
        tables: {
          profiles: [{ id: "u1" }],
          attempts: [{ id: 1 }, { id: 2 }, { id: 3 }],
          duels: [],
        },
      }),
    ).toBe(4);
  });

  it("rend 0 pour un compte tout neuf — un export vide est un cas RÉEL, pas une panne", () => {
    expect(countExportedRows({ tables: { profiles: [], attempts: [] } })).toBe(0);
    expect(countExportedRows({ tables: {} })).toBe(0);
  });

  it("tolère un document malformé : ce compteur sert un libellé, il ne casse pas un téléchargement réussi", () => {
    // Le document a déjà été écrit sur le disque de la personne quand ce compteur
    // s'exécute. Jeter ici transformerait un succès en message d'erreur.
    expect(countExportedRows({ tables: undefined as never })).toBe(0);
    expect(countExportedRows(undefined as never)).toBe(0);
    expect(countExportedRows({ tables: { attempts: "pas un tableau" as never } })).toBe(0);
  });
});
