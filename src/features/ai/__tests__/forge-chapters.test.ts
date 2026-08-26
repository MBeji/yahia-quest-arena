// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * LA PORTE DU TABLEAU DE BORD — ce que la Forge propose quand on arrive SANS
 * chapitre.
 *
 * L'entrée du dashboard n'en passe aucun (é29 §2.1) : sans cette liste, l'écran
 * n'affichait ni sélecteur ni réglages, et un élève dont la famille venait de
 * brancher sa clé tombait sur une page qui ne fait rien. Ces tests fixent les
 * trois décisions qui rendent la liste utile plutôt que juste non vide :
 * le cadrage par le parcours ACTIF, l'exclusion des chapitres sans cours, et le
 * silence assumé quand il n'y a rien à proposer.
 */

vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { rpc: vi.fn() },
}));
vi.mock("@tanstack/react-start", () => ({
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: (fn: unknown) => fn,
    };
    return chain;
  },
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
}));

import { listForgeableChapters } from "../forge.server";

const STUDENT = "22222222-2222-4222-8222-222222222222";
const PARCOURS = "44444444-4444-4444-8444-444444444444";

type Row = Record<string, unknown>;
type Filter = { op: string; column: string; value: unknown };

/** Les filtres reçus par table, pour vérifier le CADRAGE et pas seulement la sortie. */
const seen: Record<string, Filter[]> = {};

let profileRow: Row | null = null;
let parcoursRow: Row | null = null;
let subjectRows: Row[] = [];
let chapterRows: Row[] = [];
let chapterError: { message: string } | null = null;

/**
 * Un faux client Supabase réduit à ce que la fonction appelle. Chaque filtre est
 * enregistré ET appliqué : un test qui n'applique pas ses filtres mesurerait la
 * forme des appels sans jamais voir ce qu'ils excluent.
 */
function fakeClient() {
  function builder(table: string, rows: Row[], error: { message: string } | null = null) {
    const filters: Filter[] = (seen[table] ??= []);
    const state = { rows };
    const self = {
      select: () => self,
      eq(column: string, value: unknown) {
        filters.push({ op: "eq", column, value });
        state.rows = state.rows.filter((r) => r[column] === value);
        return self;
      },
      is(column: string, value: unknown) {
        filters.push({ op: "is", column, value });
        state.rows = state.rows.filter((r) => (r[column] ?? null) === value);
        return self;
      },
      in(column: string, values: unknown[]) {
        filters.push({ op: "in", column, value: values });
        state.rows = state.rows.filter((r) => values.includes(r[column]));
        return self;
      },
      not(column: string, _op: string, value: unknown) {
        filters.push({ op: "not", column, value });
        state.rows = state.rows.filter((r) => (r[column] ?? null) !== value);
        return self;
      },
      order: () => self,
      limit: () => self,
      maybeSingle: () => Promise.resolve({ data: state.rows[0] ?? null, error }),
      then: (resolve: (v: { data: Row[]; error: unknown }) => unknown) =>
        Promise.resolve({ data: state.rows, error }).then(resolve),
    };
    return self;
  }

  return {
    from(table: string) {
      if (table === "profiles") return builder(table, profileRow ? [profileRow] : []);
      if (table === "parcours") return builder(table, parcoursRow ? [parcoursRow] : []);
      if (table === "subjects") return builder(table, subjectRows);
      return builder(table, chapterRows, chapterError);
    },
  };
}

type HandlerFn = (args: {
  context: { userId: string; supabase: unknown };
}) => Promise<{ id: string; title: string; subjectName: string }[]>;

const run = () =>
  (listForgeableChapters as unknown as HandlerFn)({
    context: { userId: STUDENT, supabase: fakeClient() },
  });

beforeEach(() => {
  for (const key of Object.keys(seen)) delete seen[key];
  profileRow = { id: STUDENT, current_parcours_id: PARCOURS };
  parcoursRow = { id: PARCOURS, theme_id: "ecole-tn", grade_id: "9eme" };
  subjectRows = [
    { id: "math-9", name_fr: "Mathématiques", theme_id: "ecole-tn", grade_id: "9eme" },
  ];
  chapterError = null;
  chapterRows = [
    { id: "ch-1", title: "Les fractions", subject_id: "math-9", lesson_content: "Un cours." },
  ];
});

describe("listForgeableChapters", () => {
  it("rend les chapitres du parcours actif, nommés par leur matière", async () => {
    await expect(run()).resolves.toEqual([
      { id: "ch-1", title: "Les fractions", subjectName: "Mathématiques" },
    ]);
  });

  it("cadre les matières sur le thème ET le niveau du parcours", async () => {
    await run();
    expect(seen.subjects).toEqual([
      { op: "eq", column: "theme_id", value: "ecole-tn" },
      { op: "eq", column: "grade_id", value: "9eme" },
    ]);
  });

  it("un parcours sans niveau vise les matières hors niveau, pas toutes", async () => {
    // `grade_id` nul se lit « les matières hors niveau scolaire » (culture
    // générale, langues…). Sans le `.is()`, un élève de culture G se verrait
    // proposer les chapitres des treize niveaux scolaires.
    parcoursRow = { id: PARCOURS, theme_id: "culture-generale", grade_id: null };
    subjectRows = [
      { id: "cg", name_fr: "Culture générale", theme_id: "culture-generale", grade_id: null },
    ];
    chapterRows = [{ id: "ch-cg", title: "Les capitales", subject_id: "cg", lesson_content: "x" }];

    await expect(run()).resolves.toEqual([
      { id: "ch-cg", title: "Les capitales", subjectName: "Culture générale" },
    ]);
    expect(seen.subjects).toContainEqual({ op: "is", column: "grade_id", value: null });
  });

  it("écarte les chapitres SANS cours", async () => {
    // `get_forge_context` accepte un chapitre sans leçon et rend un extrait
    // vide : la Forge générerait à partir de rien, aux frais de la famille.
    chapterRows = [
      { id: "ch-1", title: "Les fractions", subject_id: "math-9", lesson_content: "Un cours." },
      { id: "ch-2", title: "Chapitre à venir", subject_id: "math-9", lesson_content: null },
    ];
    const rows = await run();
    expect(rows.map((r) => r.id)).toEqual(["ch-1"]);
    expect(seen.chapters).toContainEqual({ op: "not", column: "lesson_content", value: null });
  });

  it("ne demande JAMAIS le contenu du cours — seulement sa présence", async () => {
    // Le cours ne traverse pas le réseau pour remplir une liste déroulante.
    await run();
    const selected = seen.chapters?.filter((f) => f.op === "not") ?? [];
    expect(selected).toHaveLength(1);
  });

  it("rend une liste vide sans parcours actif, au lieu du catalogue entier", async () => {
    profileRow = { id: STUDENT, current_parcours_id: null };
    await expect(run()).resolves.toEqual([]);
    // L'écran dira lui-même quoi faire ; proposer des chapitres non étudiés
    // serait pire que de n'en proposer aucun.
    expect(seen.parcours).toBeUndefined();
  });

  it("rend une liste vide quand le parcours n'a aucune matière", async () => {
    subjectRows = [];
    await expect(run()).resolves.toEqual([]);
    expect(seen.chapters).toBeUndefined();
  });
});
