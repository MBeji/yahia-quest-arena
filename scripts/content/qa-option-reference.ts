import type { Flag, QAQuestion } from "./qa-checks.ts";

/* --------------------------------------------------------------------------
 * Une explication ne peut pas désigner une option par sa LETTRE ni par son RANG.
 *
 * `shuffleOptions` (`src/shared/lib/question-utils.ts`) mélange l'ordre des options
 * à l'affichage, dans les TROIS surfaces qui rendent un QCM — `exercise-player`
 * (quêtes), `duel-arena` et le donjon. « La réponse b se trompe de signe » ou
 * « la dernière réponse intervertit la somme et le produit » désignent donc une
 * position que l'élève ne voit jamais : au mieux l'explication est inutile, au pire
 * elle accuse une option au hasard. Le bon patron cite la VALEUR ou l'EXPRESSION —
 * « la réponse −25 vient d'une erreur de signe ».
 *
 * Découvert le 2026-07-30 par l'audit indépendant de `math-2eme-sec-sciences` :
 * trois agents-auteurs indépendants avaient produit le défaut spontanément, ce qui
 * en fait exactement le genre de règle qui doit vivre dans le gate et pas dans un
 * prompt.
 * ------------------------------------------------------------------------ */

/**
 * Sévérité de la règle « option désignée par lettre/rang ».
 *
 * WARN pour l'instant : au 2026-07-30 l'état des lieux comptait 6 144 occurrences sur
 * 2 261 questions, 715 fichiers et 48 matières, donc passer en `error` ferait rougir
 * la Content CI d'un coup. La bascule en `"error"` se fait quand la campagne de
 * réécriture est terminée — quand `content:qa` ne remonte plus aucune occurrence.
 */
export const OPTION_REFERENCE_LEVEL: Flag["level"] = "warn";

// Noms qui désignent une option, en français / anglais / arabe.
const OPTION_NOUN_LATIN = "(?:options?|propositions?|choix|r[ée]ponses?|answers?|choices?)";
const OPTION_NOUN_AR = "(?:الإجابة|الاجابة|الجواب|الخيار|الاختيار|البديل|الاقتراح|إجابة|جواب|خيار)";
// Ordinaux écrits en toutes lettres seulement : les abréviations chiffrées («2e»)
// collisionnent avec la notation mathématique (`proposition 2e^(±iπ/6)`).
const RANK_FR =
  "(?:premi[eè]res?|deuxi[eè]mes?|secondes?|troisi[eè]mes?|quatri[eè]mes?|cinqui[eè]mes?|derni[eè]res?)";
const RANK_EN = "(?:first|second|third|fourth|fifth|last)";
const RANK_AR =
  "(?:الأول[ىة]?|الاول[ىة]?|الثاني[ةه]?|الثالث[ةه]?|الرابع[ةه]?|الخامس[ةه]?|الأخير[ةه]?|الاخير[ةه]?)";

// Après la lettre : ni lettre/chiffre (« la réponse de Marie », « la réponse d'un
// élève »), ni signe de relation — `La réponse « b = −5 et c = 0 »` cite la VALEUR
// de l'option, c'est le bon patron. `a été` écarte l'auxiliaire avoir.
const NOT_AN_OPTION_LETTER = `(?![\\p{L}\\p{N}’'.\\-])(?!\\s*[=≠≤≥<>+×÷^])(?!\\s+(?:été|eu))`;

// Avant le nom : `answers a` est le seul couple nom+lettre qui, en anglais ordinaire, ne
// parle pas d'options. `answers` y est bien plus souvent un VERBE qu'un nom pluriel, et `a`
// l'article indéfini : « An opposite answers a meaning » n'accuse aucune option. L'article
// OUVRE toujours un groupe nominal — il est suivi d'un mot (ou d'une citation ouvrante).
// La lettre d'une option, elle, est ÉTIQUETÉE : déterminant devant le nom (« the answers a
// and c »), lettre délimitée (« answers (a) », « answers "a" »), ou coordination qui la
// laisse fermer le groupe (« answers a and c »). Le SINGULIER n'est pas touché — « the
// answer b », « Answer a is wrong » restent des défauts, la lettre y désigne bien la place
// que l'élève ne verra jamais. Ce qui échappe alors au filet : un pluriel nu suivi d'un
// verbe (« Answers a repeat the stem »), tournure que le corpus n'a jamais produite.
// Constaté le 2026-08-31 en rejouant `content:qa --strict` sur tout le corpus : la garde ne
// retire QUE des `answers a` — 25 avertissements sur 10 questions, toutes fausses, dont les
// 18 d'`english-bac`, qui tombe à zéro. Aucune autre tournure ne bouge, et `option a`
// (109 occurrences) comme `options a` (23) sont, eux, tous réels. D'où la garde sur ce
// couple-là et lui seul.
const ENGLISH_ANSWERS_AS_VERB = `(?<!\\b(?:the|these|those|both|all|two|three|four|your)\\s)answers\\s+a\\s+(?!(?:and|or)\\b)["“'\\p{L}]`;

// 1) « l'option b », « réponse (c) », « option « d » » — un nom d'option + une lettre.
const OPTION_BY_LETTER = new RegExp(
  `\\b(?!${ENGLISH_ANSWERS_AS_VERB})${OPTION_NOUN_LATIN}\\s*[«"'(\\[]?\\s*[a-dA-D]\\s*[»"')\\]]?${NOT_AN_OPTION_LETTER}`,
  "giu",
);
// 2) Lettre entre parenthèses toute seule — « (b) swaps the cities », « و(c) عكسُ ».
//    Le lookbehind écarte l'application de fonction (`f(a)`) et le radicande d'un
//    radical (`√(a) + √(b) ≠ √(a+b)`), où la lettre est une variable. Règle FAIBLE :
//    elle ne compte que corroborée — voir `optionReferences`.
const OPTION_BY_BARE_PAREN = /(?<![\p{L}\p{N}_’'√∛∜])\(\s*[a-dA-D]\s*\)(?![\p{L}\p{N}=])/gu;
// 3) « la dernière option », « réponse n° 2 » — le rang, dans les deux ordres.
const OPTION_BY_RANK_FR = new RegExp(
  `\\b(?:${RANK_FR}\\s+${OPTION_NOUN_LATIN}|${OPTION_NOUN_LATIN}\\s+${RANK_FR}|${OPTION_NOUN_LATIN}\\s*n[°o]\\s*\\d)\\b`,
  "giu",
);
const OPTION_BY_RANK_EN = new RegExp(
  `\\b${RANK_EN}\\s+(?:answer|option|choice|distractor)s?\\b`,
  "giu",
);
// 4) Arabe : « الخيار (b) », « الخيار الأخير ».
const OPTION_BY_LETTER_AR = new RegExp(
  `${OPTION_NOUN_AR}\\s*[(\\[]?\\s*[أبجدa-dA-D]\\s*[)\\]]?(?![\\p{L}\\p{N}])`,
  "gu",
);
const OPTION_BY_RANK_AR = new RegExp(`${OPTION_NOUN_AR}\\s+${RANK_AR}`, "gu");

// Les règles « fortes » nomment explicitement une option : un faux positif y est
// improbable. La parenthèse nue, elle, est ambiguë hors contexte — `(A)` est aussi
// l'ampère, `(d)` une droite, `(B)` la brique du schéma — donc elle ne compte que
// CORROBORÉE : soit l'explication cite déjà une option en toutes lettres, soit elle
// aligne au moins DEUX lettres parenthésées différentes (personne n'écrit deux unités
// à la file pour parler d'autre chose que des options).
const OPTION_REFERENCE_RULES_STRONG = [
  OPTION_BY_LETTER,
  OPTION_BY_RANK_FR,
  OPTION_BY_RANK_EN,
  OPTION_BY_LETTER_AR,
  OPTION_BY_RANK_AR,
];

const bareLetter = (hit: string) => hit.replace(/[^a-dA-D]/g, "").toLowerCase();

/**
 * Toutes les tournures de `text` qui désignent une option par sa lettre ou son rang,
 * dédoublonnées et dans l'ordre d'apparition. `prompt` sert de garde-fou : un énoncé
 * qui étiquette lui-même ses cas « (A) … (B) … » donne un sens LOCAL à ces lettres,
 * et l'explication qui les reprend parle de l'énoncé, pas des options.
 */
export function optionReferences(text: string, prompt = ""): string[] {
  const spans: Array<{ start: number; end: number; hit: string }> = [];
  for (const re of OPTION_REFERENCE_RULES_STRONG) {
    re.lastIndex = 0;
    for (const m of text.matchAll(re)) {
      spans.push({
        start: m.index,
        end: m.index + m[0].length,
        hit: m[0].trim().replace(/\s+/g, " "),
      });
    }
  }
  OPTION_BY_BARE_PAREN.lastIndex = 0;
  const labelled = new Set([...prompt.matchAll(OPTION_BY_BARE_PAREN)].map((m) => bareLetter(m[0])));
  OPTION_BY_BARE_PAREN.lastIndex = 0;
  const bare = [...text.matchAll(OPTION_BY_BARE_PAREN)].filter(
    (m) => !labelled.has(bareLetter(m[0])),
  );
  const distinctLetters = new Set(bare.map((m) => bareLetter(m[0])));
  if (bare.length > 0 && (spans.length > 0 || distinctLetters.size >= 2)) {
    for (const m of bare) {
      spans.push({ start: m.index, end: m.index + m[0].length, hit: m[0].replace(/\s+/g, "") });
    }
  }
  // Deux règles peuvent voir la même tournure — « l'option (c) » est aussi un « (c) »
  // nu. On garde la plus englobante, puis on dédoublonne à l'identique.
  const seen = new Set<string>();
  return spans
    .filter(
      (s) =>
        !spans.some(
          (o) =>
            o !== s && o.start <= s.start && o.end >= s.end && o.end - o.start > s.end - s.start,
        ),
    )
    .sort((a, b) => a.start - b.start)
    .filter((s) => {
      const key = s.hit.toLocaleLowerCase();
      if (seen.has(key)) return false;
      seen.add(key);
      return true;
    })
    .map((s) => s.hit);
}

/**
 * Une explication qui pointe une option par sa lettre ou son rang. Réservé aux
 * questions à options MÉLANGÉES (mcq) : sur une `numeric` ou une `short_answer`
 * il n'y a pas d'options, donc « la réponse b » y désigne une variable, et sur une
 * `ordering` le rang est justement la réponse.
 */
export function auditOptionReference(
  q: Pick<QAQuestion, "prompt" | "explanation">,
  where: string,
): Flag[] {
  const hits = optionReferences(q.explanation, q.prompt);
  if (hits.length === 0) return [];
  const shown = hits.slice(0, 4);
  return [
    {
      level: OPTION_REFERENCE_LEVEL,
      where,
      msg: `explanation designates an option by letter/rank (${shown.map((h) => `"${h}"`).join(", ")}${hits.length > shown.length ? ", …" : ""}); options are shuffled at render — cite the option's VALUE instead`,
    },
  ];
}
