import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import { parcoursDuGrade, readOuvertures } from "../parcours-ouverture.ts";

/**
 * Les fixtures reproduisent les TROIS formes de seed réellement en usage dans
 * `supabase/migrations` (VALUES avec sous-select, id concaténé sur une liste de
 * slugs, id littéral pour un grade) plus les deux formes de bascule
 * (`id = '…'`, `id IN (…)`). Un test de bout en bout sur les vraies migrations
 * ferme la boucle plus bas.
 */
const SEED_VALUES = `
-- Deux parcours concours, grade via sous-select.
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
VALUES
  ('concours-9eme', 'Préparation Concours 9ème', 'concours', 'ecole-tn',
     (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'),
     true, 'difficulty_1', 1, 'GraduationCap', 'subject-math', 'available'),
  ('concours-6eme', 'Préparation Concours 6ème', 'concours', 'ecole-tn',
     (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '6eme-base'),
     true, 'difficulty_1', 2, 'GraduationCap', 'subject-math', 'coming_soon')
ON CONFLICT (id) DO NOTHING;
`;

const SEED_CONCAT = `
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
SELECT 'ecole-' || g.slug, g.name_fr, 'scolaire', 'ecole-tn', g.id,
       false, 'full', g.display_order, 'GraduationCap', 'subject-math', 'coming_soon'
FROM public.grades g
WHERE g.theme_id = 'ecole-tn'
  AND g.slug IN ('1ere-base', '2eme-base', '1ere-sec')
ON CONFLICT (id) DO NOTHING;
`;

const SEED_LITERAL = `
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
SELECT 'concours-bac', 'Préparation Concours Bac', 'concours', 'ecole-tn', g.id,
       true, 'difficulty_1', g.display_order, 'GraduationCap', 'subject-math', 'coming_soon'
FROM public.grades g
WHERE g.theme_id = 'ecole-tn' AND g.slug = 'bac'
ON CONFLICT (id) DO NOTHING;
`;

describe("readOuvertures — rejeu statique de l'ouverture des parcours", () => {
  it("lit les trois formes de seed et leur statut initial", () => {
    const lu = readOuvertures([
      { name: "20260101000000_seed_values.sql", sql: SEED_VALUES },
      { name: "20260102000000_seed_concat.sql", sql: SEED_CONCAT },
      { name: "20260103000000_seed_literal.sql", sql: SEED_LITERAL },
    ]);

    expect(lu.parcours).toEqual([
      {
        id: "concours-6eme",
        grade: "6eme-base",
        statut: "coming_soon",
        migration: "20260101000000_seed_values.sql",
      },
      {
        id: "concours-9eme",
        grade: "9eme-base",
        statut: "available",
        migration: "20260101000000_seed_values.sql",
      },
      {
        id: "concours-bac",
        grade: "bac",
        statut: "coming_soon",
        migration: "20260103000000_seed_literal.sql",
      },
      {
        id: "ecole-1ere-base",
        grade: "1ere-base",
        statut: "coming_soon",
        migration: "20260102000000_seed_concat.sql",
      },
      {
        id: "ecole-1ere-sec",
        grade: "1ere-sec",
        statut: "coming_soon",
        migration: "20260102000000_seed_concat.sql",
      },
      {
        id: "ecole-2eme-base",
        grade: "2eme-base",
        statut: "coming_soon",
        migration: "20260102000000_seed_concat.sql",
      },
    ]);
    expect(lu.ouvertsSansSeed).toEqual([]);
  });

  it("applique les bascules dans l'ordre des versions, dernier statut gagnant", () => {
    const lu = readOuvertures([
      { name: "20260102000000_seed_concat.sql", sql: SEED_CONCAT },
      {
        name: "20260201000000_open_1ere_sec.sql",
        sql: "UPDATE public.parcours\nSET status = 'available'\nWHERE id = 'ecole-1ere-sec';",
      },
      {
        name: "20260202000000_open_base.sql",
        sql: "UPDATE public.parcours SET status = 'available'\nWHERE id IN (\n  'ecole-1ere-base',\n  'ecole-2eme-base'\n);",
      },
      {
        name: "20260203000000_close_2eme.sql",
        sql: "UPDATE public.parcours SET status = 'coming_soon' WHERE id = 'ecole-2eme-base';",
      },
    ]);

    const statuts = new Map(lu.parcours.map((p) => [p.id, p.statut]));
    expect(statuts.get("ecole-1ere-sec")).toBe("available");
    expect(statuts.get("ecole-1ere-base")).toBe("available");
    // Refermé par une migration postérieure : l'ordre des versions décide.
    expect(statuts.get("ecole-2eme-base")).toBe("coming_soon");
    // La bascule est tracée, pas le seed.
    expect(lu.parcours.find((p) => p.id === "ecole-1ere-sec")?.migration).toBe(
      "20260201000000_open_1ere_sec.sql",
    );
    // Le grade reste celui du seed, la bascule ne le porte pas.
    expect(lu.parcours.find((p) => p.id === "ecole-1ere-sec")?.grade).toBe("1ere-sec");
  });

  it("signale un parcours ouvert qu'aucun seed ne rattache, au lieu de l'inventer", () => {
    const lu = readOuvertures([
      {
        name: "20260301000000_open_inconnu.sql",
        sql: "UPDATE public.parcours SET status = 'available' WHERE id = 'ecole-nouveau-cycle';",
      },
    ]);
    expect(lu.ouvertsSansSeed).toEqual(["ecole-nouveau-cycle"]);
    expect(lu.parcours[0]).toMatchObject({ grade: null, statut: "available" });
  });

  it("ignore ce qui n'est pas un statut littéral de parcours", () => {
    const lu = readOuvertures([
      {
        name: "20260401000000_rpc.sql",
        sql: [
          "CREATE OR REPLACE FUNCTION public.f() RETURNS VOID LANGUAGE plpgsql AS $$",
          "BEGIN",
          "  UPDATE public.parcours SET status = v_status WHERE id = p_id;",
          "  UPDATE public.duels SET status = 'available' WHERE id = p_duel;",
          "END;",
          "$$;",
        ].join("\n"),
      },
      {
        name: "20260402000000_entitlements.sql",
        sql: "INSERT INTO public.parcours_entitlements (user_id, parcours_id) VALUES ('u', 'ecole-1ere-sec');",
      },
    ]);
    expect(lu.parcours).toEqual([]);
  });

  it("rejoue les vraies migrations du dépôt : 1ère sec et bac lettres ouverts, 2ème sec éco-services non", () => {
    const dir = join(process.cwd(), "supabase/migrations");
    const files = readdirSync(dir)
      .filter((name) => name.endsWith(".sql"))
      .map((name) => ({ name, sql: readFileSync(join(dir, name), "utf8") }));
    const lu = readOuvertures(files);

    // Ouverte par 20260713180000_open_ecole_1ere_sec_parcours.sql (étude 16, vague A).
    expect(parcoursDuGrade(lu, "1ere-sec")).toEqual([
      expect.objectContaining({ id: "ecole-1ere-sec", statut: "available" }),
    ]);
    // Ouverte par 20260813120000_open_lycee_3eme_sec_bac_parcours.sql, qui
    // bascule onze parcours d'un coup : ce cas couvre donc AUSSI la forme
    // `WHERE id IN (…)`, que la première vague d'ouvertures (un `WHERE id = …`
    // par migration) n'exerçait jamais.
    expect(parcoursDuGrade(lu, "bac-lettres")).toEqual([
      expect.objectContaining({ id: "concours-bac-lettres", statut: "available" }),
    ]);
    // Le cas négatif se déplace, il ne disparaît pas : cette section-là est
    // seedée coming_soon et n'a jamais été basculée — un test qui n'aurait plus
    // que des parcours ouverts ne distinguerait plus un parseur juste d'un
    // parseur qui répondrait « available » à tout.
    expect(parcoursDuGrade(lu, "2eme-sec-eco-services")).toEqual([
      expect.objectContaining({ id: "ecole-2eme-sec-eco-services", statut: "coming_soon" }),
    ]);
    // Le rattachement grade → parcours couvre tout ce que la chaîne ouvre.
    expect(lu.ouvertsSansSeed).toEqual([]);
  });
});
