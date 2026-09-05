import { cnpManuelFileName } from "../../src/shared/content/manuel-cnp.ts";
import { parseManuelPages } from "../../src/shared/content/schema.ts";
import type { ExerciseManuel } from "../../src/shared/content/schema.ts";
import type { Flag } from "./qa-checks.ts";

/**
 * Manuel élève refs (`subject.manuels[].code`, `chapter.manuel.code`) — every
 * code must name a document the CNP actually publishes.
 *
 * Structural validation only proves a code is *shaped* like a code. Since the
 * reader turns it into a link to the CNP's own copy, a typo no longer means «
 * a card that stays empty » (the PDF was simply not uploaded) but « a link that
 * 404s in a student's face ». The corpus registry is the only place that knows
 * which files exist, so it is the only place that can tell the two apart.
 *
 * `corpusFiles` = the `<code><tome>.pdf` names of `suivi/corpus-cnp.json`, or
 * `null` when the corpus tree is not linked in (public engine) — the check then
 * stands down instead of failing on data it cannot see.
 */
export function auditManuelRefs(
  codes: readonly string[],
  corpusFiles: ReadonlySet<string> | null,
  where: string,
): Flag[] {
  if (!corpusFiles) return [];
  const flags: Flag[] = [];
  for (const code of codes) {
    const file = cnpManuelFileName(code);
    if (!file) {
      flags.push({
        level: "error",
        where,
        msg: `manuel code "${code}" is not a usable book code (no link can be built from it)`,
      });
      continue;
    }
    if (!corpusFiles.has(file)) {
      flags.push({
        level: "error",
        where,
        msg: `manuel code "${code}" resolves to "${file}", absent from the CNP corpus (suivi/corpus-cnp.json) — the « Manuel officiel » link would 404`,
      });
    }
  }
  return flags;
}

/**
 * Cohérence des pages d'une reprise (étude 21 §3.5) — **jamais bloquant**.
 *
 * Quand une mission déclare des pages ET que son chapitre en déclare aussi,
 * pour le MÊME livre, des pages hors de la plage du chapitre sont bien plus
 * probablement une typo (« 86 » pour « 68 ») qu'un fait. Bien plus probablement,
 * pas certainement : les exercices de synthèse d'un manuel vivent parfois en
 * fin de tome, loin du chapitre qu'ils révisent. D'où un `warn` et rien d'autre
 * — un `error` refuserait un contenu légitime pour attraper une faute de
 * frappe, ce qui est le mauvais côté du compromis.
 *
 * Se tait dès qu'un élément manque : pas de pages sur la mission, pas de pages
 * sur le chapitre, ou deux livres différents (un tome 2 n'a aucune raison de
 * tomber dans la plage du tome 1).
 */
export function auditExerciseManuelPages(
  exercise: ExerciseManuel | undefined,
  chapterManuel: { code: string; pages: string } | undefined,
  where: string,
): Flag[] {
  if (!exercise?.pages || !chapterManuel) return [];
  if (exercise.code !== chapterManuel.code) return [];
  let exPages: number[];
  let chPages: number[];
  try {
    exPages = parseManuelPages(exercise.pages);
    chPages = parseManuelPages(chapterManuel.pages);
  } catch {
    // Une plage illisible est déjà refusée par le schéma ; ici on se tait.
    return [];
  }
  const within = new Set(chPages);
  const outside = exPages.filter((p) => !within.has(p));
  if (outside.length === 0) return [];
  return [
    {
      level: "warn",
      where,
      msg:
        `manuel pages ${outside.join(", ")} fall outside the chapter's declared range ` +
        `"${chapterManuel.pages}" (same book ${chapterManuel.code}) — probable typo, unless these ` +
        `are end-of-volume synthesis exercises`,
    },
  ];
}
