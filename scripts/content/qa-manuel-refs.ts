import { cnpManuelFileName } from "../../src/shared/content/manuel-cnp.ts";
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
