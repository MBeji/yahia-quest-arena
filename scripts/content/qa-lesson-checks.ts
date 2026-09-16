/**
 * Le volet LEÇON du gate de contenu : les directives de é18, et le patron de notion de é35.
 *
 * Extrait de `qa-checks.ts` au lot 5 de é35 : la règle ESLint `max-lines` a refusé un fichier
 * de 928 lignes de code pour un budget de 750, et elle avait raison. La couture suit la
 * matière, pas la taille : `qa-checks.ts` garde ce qui juge les QUESTIONS (énoncés, clés,
 * figures, notation), ce fichier prend tout ce qui juge les TEXTES (`cours.md`, `resume.md`).
 *
 * Tout ce qui est ici vérifie la FORME et rien d'autre (é35 D-7) : on compte des blocs et des
 * lignes, on ne renifle jamais la prose. Le fond est l'affaire de `content-audit` et de la
 * re-résolution à l'aveugle.
 */

import { auditRenderedFields, FIGURE_REFERENCE, type Flag } from "./qa-checks.ts";

/** Un bloc `<svg>` complet — une figure, quel que soit le nombre de lignes qu'elle occupe. */
const SVG_BLOCK = /<svg[\s\S]*?<\/svg>/i;

/** Les blocs qui ÉNONCENT un savoir : c'est eux qui appellent un exemple (é35, C-1). */
const KNOWLEDGE_DIRECTIVES = new Set(["definition", "propriete", "methode"]);

/** Le séparateur question / réponse d'un `::: verifie` — miroir de `CHECK_SPLIT` du renderer. */
const CHECK_SPLIT = /^---[ \t]*$/;

/**
 * Le patron de notion (étude 35) : les sept temps dont l'ORDRE est fermé. Ces contrôles
 * vérifient la FORME et rien d'autre (D-7) — C-2 compte des lignes, il ne juge pas qu'elles
 * sont « concrètes ». Le fond est l'affaire de `content-audit` (grille §2.4 de l'étude) et de
 * la re-résolution à l'aveugle ; aucun reniflage de prose ici, é18 D-1 tient toujours.
 *
 * Deux régimes, et c'est ce qui rend l'adoption possible matière par matière (D-9) :
 *  - matière SANS `coursePattern` → `warn` : le constat existe, il ne bloque pas. C'est le
 *    backlog de la campagne de fond, pas son gate ;
 *  - matière AVEC `coursePattern: "notion"` → `error` : elle a fini sa campagne, elle s'y tient.
 */
export type PatternLevel = "error" | "warn";

/** Une section `##` d'une leçon, avec ses lignes — l'unité du patron : une section, une notion. */
type LessonSection = { title: string; start: number; lines: string[] };

export function lessonSections(lines: string[]): LessonSection[] {
  const out: LessonSection[] = [];
  let current: LessonSection | null = null;
  for (let i = 0; i < lines.length; i++) {
    const heading = /^##[ \t]+(.+)$/.exec(lines[i]);
    if (heading) {
      if (current) out.push(current);
      current = { title: heading[1].trim(), start: i + 1, lines: [] };
      continue;
    }
    if (current) current.lines.push(lines[i]);
  }
  if (current) out.push(current);
  return out;
}

/**
 * Les lignes d'une section qui portent réellement du contenu — la mesure de C-6.
 *
 * Compter les lignes PHYSIQUES mesure la mise en forme, pas la matière, et C-6 s'est trompé
 * sur les sept sections de maths 9ᵉ qu'il dénonçait (étude 35, lot 5) :
 *
 * - une **ligne vide** ne porte aucune notion, et la convention qui protège les clôtures de
 *   directive de Prettier (une ligne vide avant un `:::` qui suit une liste) en ajoute une par
 *   bloc — cinq sections ont franchi le seuil sans gagner un mot ;
 * - un **`<svg>`** est UNE figure, quel que soit le nombre de lignes qu'il occupe. La section
 *   « شبه المنحرف » de `18-quadrilateres` était signalée à 72 lignes : elle en porte **19**,
 *   le reste étant le corps d'une figure.
 *
 * C'est la même erreur de mesure que R-13 corrigeait un étage plus haut — compter le fichier
 * au lieu de compter la matière. Le seuil de 60 ne bouge pas ; c'est la règle de comptage qui
 * devient honnête.
 */
export function contentLineCount(lines: string[]): number {
  let count = 0;
  let inSvg = false;
  for (const line of lines) {
    if (inSvg) {
      if (/<\/svg>/i.test(line)) inSvg = false;
      continue;
    }
    if (/<svg\b/i.test(line)) {
      count += 1; // la figure compte pour une ligne, fermée sur la même ou plus bas
      if (!/<\/svg>/i.test(line)) inSvg = true;
      continue;
    }
    if (line.trim()) count += 1;
  }
  return count;
}

/** Les types de directives ouverts dans ces lignes, dans l'ordre du document. */
export function directiveSequence(lines: string[]): string[] {
  const out: string[] = [];
  for (const line of lines) {
    const opener = DIRECTIVE_OPEN.exec(line);
    if (opener) out.push(opener[1]);
  }
  return out;
}

/**
 * Les contrôles de PATRON d'une leçon (étude 35, C-1…C-3 et C-6).
 *
 * C-1 « une règle, un exemple » — une section qui pose un savoir montre comment on l'applique.
 * C-2 « le concret d'abord » — un savoir ne peut pas ouvrir sa section : quelque chose doit
 *     l'amener (deux lignes de prose au moins, ou une figure). La règle générale vient APRÈS
 *     l'exemple, jamais avant (le manuel fait déjà ainsi : نشاط → encadré).
 * C-3 « vérifie sur place » — une section qui montre un exemple donne de quoi l'essayer.
 * C-6 « segmenter » — au-delà de 60 lignes DE CONTENU (lignes vides et corps de `<svg>` exclus,
 *     cf. `contentLineCount`), une section porte deux notions : elle se scinde.
 */
export function auditCoursePattern(lines: string[], where: string, level: PatternLevel): Flag[] {
  const flags: Flag[] = [];
  const sections = lessonSections(lines);

  // Une matière qui s'est mise sous patron doit s'en SERVIR. Sans ce contrôle, `coursePattern`
  // serait décoratif : tous les autres ne se déclenchent qu'en présence d'un bloc de savoir,
  // donc un cours qui n'en pose aucun les traverse tous en silence — et c'est exactement
  // l'état du corpus d'aujourd'hui (maths 9ᵉ : 54 `figure`, 1 `methode`, zéro `definition`).
  // Le contrôle ne vaut QUE dans le régime « error » : ailleurs, l'absence est le backlog.
  if (level === "error" && sections.length > 0) {
    const all = directiveSequence(lines);
    if (!all.some((t) => KNOWLEDGE_DIRECTIVES.has(t)) && !all.includes("exemple")) {
      flags.push({
        level,
        where,
        msg: 'subject declares `coursePattern: "notion"` but this course carries no knowledge block and no worked example — the pattern is a way of writing, not a flag (é35 C-1)',
      });
    }
  }

  for (const section of sections) {
    const seq = directiveSequence(section.lines);
    const at = `${where} § ${section.title} (l.${section.start})`;

    const knowledgeIdx = seq.findIndex((t) => KNOWLEDGE_DIRECTIVES.has(t));
    if (knowledgeIdx > -1 && !seq.includes("exemple")) {
      flags.push({
        level,
        where: at,
        msg: "section poses a rule (definition/propriete/methode) with no `::: exemple` — a rule without a worked example is not taught (é35 C-1)",
      });
    }

    if (knowledgeIdx > -1) {
      // Ce qui précède la PREMIÈRE directive de savoir : de la prose, ou une figure ?
      const firstKnowledge = section.lines.findIndex((l) => {
        const o = DIRECTIVE_OPEN.exec(l);
        return o !== null && KNOWLEDGE_DIRECTIVES.has(o[1]);
      });
      const before = section.lines.slice(0, firstKnowledge);
      // De la prose : les lignes non vides qui ne sont ni une directive, ni un `:::` de
      // fermeture, ni un `<svg>` — c'est ce qui AMÈNE la règle.
      const prose = before.filter(
        (l) =>
          l.trim() &&
          !DIRECTIVE_OPEN.test(l) &&
          !DIRECTIVE_CLOSE.test(l) &&
          !SVG_BLOCK.test(l) &&
          !l.trim().startsWith("</svg"),
      ).length;
      // Une figure d'ancrage vaut l'amorce : montrer la situation est une façon de la poser.
      const figure = before.some((l) => {
        const o = DIRECTIVE_OPEN.exec(l);
        return (o !== null && o[1] === "figure") || SVG_BLOCK.test(l);
      });
      if (prose < 2 && !figure) {
        flags.push({
          level,
          where: at,
          msg: "section opens straight on its rule — anchor it first in a concrete situation and the question it raises (é35 C-2)",
        });
      }
    }

    if (seq.includes("exemple") && !seq.includes("verifie")) {
      flags.push({
        level,
        where: at,
        msg: "section shows a worked example but never lets the student try one — add a `::: verifie` (é35 C-3)",
      });
    }

    const measured = contentLineCount(section.lines);
    if (measured > 60) {
      flags.push({
        level: "warn",
        where: at,
        msg: `section runs ${measured} content lines — over 60 it carries two notions; split it (é35 C-6)`,
      });
    }
  }

  return flags;
}

/** C-4 — la forme d'un `::: verifie` : un séparateur, deux côtés non vides (é35 R-16/R-17). */
export function auditCheckBlock(block: { line: number; body: string[] }, where: string): Flag[] {
  const split = block.body.findIndex((l) => CHECK_SPLIT.test(l));
  if (split === -1) {
    return [
      {
        level: "error",
        where,
        msg: `\`::: verifie\` (l.${block.line}) has no \`---\` separator — question above, answer below, or the answer shows unfolded (é35 C-4)`,
      },
    ];
  }
  const question = block.body.slice(0, split).some((l) => l.trim());
  const answer = block.body.slice(split + 1).some((l) => l.trim());
  if (!question || !answer) {
    return [
      {
        level: "error",
        where,
        msg: `\`::: verifie\` (l.${block.line}) has an empty ${question ? "answer" : "question"} — both sides of the \`---\` carry text (é35 C-4)`,
      },
    ];
  }
  return [];
}

/**
 * C-5 (suite) — les erreurs typiques DÉCLARÉES par le chapitre (étude 35, R-5/D-5).
 *
 * `chapter.json` → `coursePitfalls` nomme, avec le vocabulaire du registre, les erreurs que
 * le cours montre et corrige. Deux contrôles, et le second est celui qui compte : un tag
 * inconnu du registre est une faute de frappe, mais un tag qu'AUCUN distracteur du chapitre
 * n'encode est une boucle qui ne se referme pas — le cours enseignerait contre une erreur que
 * les exercices ne mesurent jamais. La déclaration devient alors un fait vérifiable, pas une
 * intention.
 *
 * Et dans l'autre sens : une matière qui s'est mise sous patron déclare ses erreurs, sinon
 * rien ne distingue « ce chapitre n'en a pas » de « personne n'y a pensé ».
 */
export function auditCoursePitfalls(
  declared: string[] | undefined,
  chapterTags: Set<string>,
  knownTags: Set<string>,
  where: string,
  level: PatternLevel,
): Flag[] {
  const flags: Flag[] = [];

  for (const tag of declared ?? []) {
    if (!knownTags.has(tag)) {
      flags.push({
        level: "error",
        where,
        msg: `coursePitfalls: unknown misconception tag \`${tag}\` — declare it in content/misconceptions.json first`,
      });
      continue;
    }
    if (!chapterTags.has(tag)) {
      flags.push({
        level: "error",
        where,
        msg: `coursePitfalls: \`${tag}\` is taught against but no distractor of this chapter encodes it — the course would fight an error the exercises never measure (é35 C-5)`,
      });
    }
  }

  if (level === "error" && (declared ?? []).length === 0) {
    flags.push({
      level,
      where,
      msg: "chapter under the notion pattern declares no coursePitfalls — name at least the one classic mistake its course corrects (é35 C-5)",
    });
  }

  return flags;
}

/* ============================================================================
   Leçons (`cours.md` / `resume.md`) — étude 18, lot 4.

   Jusqu'ici, `content:qa` ne lisait QUE les questions : les 541 leçons étaient
   hors de tout gate déterministe, et c'est précisément pour cela que la dérive
   « aucune figure en géométrie » a pu durer sans qu'aucune CI ne bronche.
   ========================================================================== */

/**
 * Miroir de `DIRECTIVE_TYPES` dans `src/shared/lib/lesson-blocks.ts` — garder en phase.
 * Un test de synchronisation échoue si les deux listes divergent (`qa-lesson.test.ts`) :
 * un type que le renderer connaît et que le gate ignore laisserait passer une faute, et
 * l'inverse ferait rougir un contenu parfaitement rendu.
 */
const LESSON_DIRECTIVES = new Set([
  "definition",
  "propriete",
  "exemple",
  "methode",
  "figure",
  "piege",
  "astuce",
  "retenir",
  "verifie",
]);

const DIRECTIVE_OPEN = /^:::[ \t]+([a-z]+)(?:[ \t]+(.*))?$/;
const DIRECTIVE_CLOSE = /^:::[ \t]*$/;

/**
 * Chapitres dont les notions sont intrinsèquement SPATIALES : y énoncer une règle sur des
 * formes sans la dessiner est une non-conformité (axe 5 « Illustration »). Testé sur le SLUG
 * du chapitre. Liste normative : `content-engine/references/course-figures.md` — garder les
 * deux en phase.
 */
const SPATIAL_CHAPTER =
  // Formes & espace. `ligne`/`reperage`/`forme` ajoutés le 2026-07-14 : le chapitre
  // «التموقع في الفضاء» (`07-reperage-espace`) et «الخطوط» (`10-lignes`, `07-formes-lignes`)
  // du primaire — les plus visuels qui soient pour un enfant de 6  ans — passaient inaperçus.
  /thales|thal[eè]s|pythagore|triangle|g[ée]om[ée]tri|forme|cercle|angle|vecteur|rep[eè]re|espace|solide|sym[ée]trie|translation|rotation|quart.?tour|homoth[ée]tie|section|perim[eè]tre|p[ée]rim[eè]tre|quadrilat[eè]re|polygone|trigo|prisme|pyramide|c[oô]ne|cylindre|sph[eè]re|droites|ligne/i;

/**
 * Deuxième famille — les notions qui se LISENT sur un graphique. Une leçon sur les fonctions
 * linéaires sans sa droite, ou sur les statistiques sans son diagramme, souffre exactement du
 * même défaut qu'une géométrie sans triangle : elle décrit ce qu'il fallait montrer.
 * Ajoutée le 2026-07-14 en illustrant math-1ere-sec — la première version de la liste ne
 * couvrait que les formes, et laissait passer `12-fonctions-lineaires` et
 * `16-exploitation-information` sans le moindre dessin.
 */
const GRAPHICAL_CHAPTER =
  /fonction|graphique|diagramme|statistiq|donn[ée]es|exploitation.?information|frise|chronolog/i;

/**
 * Audit d'une leçon. Contrôles :
 *  - directives `:::` : type inconnu, non fermée, `:::` orphelin, `::: figure` sans légende ;
 *  - la leçon DÉSIGNE une figure (« ci-dessous », « الشكل المجاور »…) mais n'en porte aucune ;
 *  - chapitre spatial sans la moindre figure ;
 *  - notation (viewBox, bidi, virgule arabe, LaTeX, chiffres arabo-indiens) — via
 *    `auditRenderedFields`, dont c'est le tout premier passage sur des leçons.
 */
export function auditLesson(
  md: string,
  where: string,
  opts: { spatial?: boolean; pattern?: PatternLevel; summary?: boolean } = {},
): Flag[] {
  const flags: Flag[] = [];
  // `\r?\n` et non `\n` : un checkout Windows matérialise le corpus en CRLF, et
  // un `split("\n")` laisse alors un `\r` en fin de chaque ligne. Les directives
  // sont reconnues par des regex ancrées sur `$` (`::: figure …`, `:::`), qui
  // cessent toutes de matcher — l'ouverture n'est plus vue, et la fermeture est
  // rapportée « stray `:::` closes nothing ». Le gate inventait donc deux
  // erreurs par chapitre à figure, en local seulement : la CI (Linux, checkout
  // LF) restait verte, ce qui rendait l'écart incompréhensible côté auteur.
  const lines = md.split(/\r?\n/);

  let open: { type: string; line: number; body: string[] } | null = null;
  for (let i = 0; i < lines.length; i++) {
    const opener = DIRECTIVE_OPEN.exec(lines[i]);
    if (opener) {
      const [, type, caption] = opener;
      if (open) {
        flags.push({
          level: "error",
          where,
          msg: `directive \`::: ${open.type}\` (l.${open.line}) is never closed — \`::: ${type}\` opens at l.${i + 1}`,
        });
      }
      if (!LESSON_DIRECTIVES.has(type)) {
        flags.push({
          level: "error",
          where,
          msg: `unknown block directive \`::: ${type}\` (l.${i + 1}) — allowed: ${[...LESSON_DIRECTIVES].join(", ")}`,
        });
      }
      if (type === "figure" && !(caption ?? "").trim()) {
        flags.push({
          level: "error",
          where,
          msg: `\`::: figure\` (l.${i + 1}) carries no caption — every course figure is captioned and numbered`,
        });
      }
      if (type === "verifie" && opts.summary) {
        // R-21 : le résumé ne pose pas de question, il sert la révision. Et son renderer
        // n'a pas de grammaire de blocs : un `::: verifie` y afficherait sa réponse en clair.
        flags.push({
          level: "error",
          where,
          msg: `\`::: verifie\` (l.${i + 1}) has no place in a summary — the revision cards answer, they do not ask (é35 R-21)`,
        });
      }
      open = { type, line: i + 1, body: [] };
      continue;
    }
    if (DIRECTIVE_CLOSE.test(lines[i])) {
      if (!open) {
        flags.push({ level: "error", where, msg: `stray \`:::\` (l.${i + 1}) closes nothing` });
      }
      // C-4 « la réponse est repliée » : un `::: verifie` a un séparateur et DEUX côtés
      // non vides. Sans cela le renderer dégrade en bloc neutre — la réponse s'affiche donc
      // sous la question, et le contrôle ne contrôle plus rien.
      if (open?.type === "verifie") flags.push(...auditCheckBlock(open, where));
      open = null;
      continue;
    }
    if (open) open.body.push(lines[i]);
  }
  if (open) {
    flags.push({
      level: "error",
      where,
      msg: `directive \`::: ${open.type}\` (l.${open.line}) is never closed`,
    });
  }

  const hasFigure = SVG_BLOCK.test(md);

  // Le contrôle le plus discriminant : la leçon parle d'une image absente.
  if (!hasFigure && FIGURE_REFERENCE.test(md)) {
    flags.push({
      level: "error",
      where,
      msg: "the lesson points at a figure («ci-dessous», «الشكل المجاور»…) but carries none — the student is sent to an image that does not exist",
    });
  }

  // C-5a « l'erreur est nommée » : un cours qui ne montre AUCUNE erreur typique laisse
  // l'élève la découvrir au quiz. Le piège s'écrit en directive (`::: piege`) ou en callout
  // promu (`> ⚠️`) — les deux comptent, et le corpus emploie massivement le second.
  //
  // Le contrôle ne vaut que pour un vrai COURS, reconnu à ses sections : un fragment sans un
  // seul `##` n'est pas une leçon à laquelle réclamer un piège. Même raison que pour les
  // contrôles de patron, qui itèrent sur les sections et n'ont rien à dire sans elles.
  if (!opts.summary && lessonSections(lines).length > 0) {
    const hasPitfall =
      lines.some((l) => {
        const o = DIRECTIVE_OPEN.exec(l);
        return o !== null && o[1] === "piege";
      }) || /^>[ \t]?⚠/m.test(md);
    if (!hasPitfall) {
      flags.push({
        level: opts.pattern ?? "warn",
        where,
        msg: "course shows no classic mistake at all — name the error where the confusion is born, and correct it (é35 C-5)",
      });
    }
  }

  // Axe 5 « Illustration » : un chapitre de formes enseigné sans un seul dessin.
  if (opts.spatial && !hasFigure) {
    flags.push({
      level: "warn",
      where,
      msg: "spatial chapter with no figure at all — a rule about shapes taught without a drawing (course-quality.md, axis 5)",
    });
  }

  // `markdown: true` : une leçon EST du Markdown (`src/shared/lib/markdown.ts` la
  // parse), donc `**gras**` et `## Titre` y sont la notation attendue — la garde
  // « piège n°6 » ne vaut que pour les champs rendus en texte brut.
  flags.push(...auditRenderedFields([["lesson", md]], where, { markdown: true }));

  // Le patron de notion (étude 35) — sur le COURS seulement : un résumé est une compression,
  // il n'explique pas, et lui demander un exemple par règle serait lui demander d'être le cours.
  if (!opts.summary) flags.push(...auditCoursePattern(lines, where, opts.pattern ?? "warn"));

  return flags;
}

/** Le chapitre relève-t-il d'une famille où la figure est exigible ? (axe 5) */
export function isSpatialChapter(slug: string): boolean {
  return SPATIAL_CHAPTER.test(slug) || GRAPHICAL_CHAPTER.test(slug);
}
