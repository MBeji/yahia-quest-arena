import { usePlacementT } from "@/lib/i18n/placement";
import { isRtlText } from "@/shared/lib/utils";

import { selectableThroughChapters, type ScopeChapter } from "../placement-scope";

/**
 * « OÙ EN ES-TU DANS LE PROGRAMME ? » (étude 39 R-22) — le chapitre atteint par la classe.
 *
 * Présentationnel : la route charge les chapitres testables (`listPlacementChapters`), calcule la
 * proposition du calendrier (`suggestThroughChapterId`) et tient la valeur. Une liste native :
 * une matière peut porter trente chapitres, et la liste du téléphone les fait défiler mieux que
 * trente boutons. `null` = tout le programme de l'année.
 *
 * Rien n'est rendu tant qu'il n'y a pas au moins un chapitre proposable : une matière d'un seul
 * chapitre n'a pas d'« avant » — le test porte sur tout, sans question inutile.
 */

const WHOLE_YEAR = "";

export function PlacementScopeSelect({
  chapters,
  value,
  onChange,
  align = "start",
}: {
  chapters: ScopeChapter[];
  value: string | null;
  onChange: (throughChapterId: string | null) => void;
  align?: "start" | "center";
}) {
  const t = usePlacementT();
  const options = selectableThroughChapters(chapters);
  if (options.length === 0) return null;
  // Une valeur que la liste ne porte plus (corpus republié) se lit « tout le programme ».
  const current = options.some((c) => c.chapterId === value) ? (value as string) : WHOLE_YEAR;

  return (
    <section
      aria-labelledby="placement-scope"
      className={align === "center" ? "text-center" : undefined}
      data-testid="placement-scope"
    >
      <h2 id="placement-scope" className="font-display text-lg font-bold">
        {t.placement.entry.scopeTitle}
      </h2>
      <select
        aria-labelledby="placement-scope"
        value={current}
        onChange={(e) => onChange(e.target.value === WHOLE_YEAR ? null : e.target.value)}
        className="mt-3 min-h-11 w-full rounded-xl border border-border bg-card px-4 py-2 text-sm font-medium"
        data-testid="placement-scope-select"
      >
        {options.map((c) => (
          <option
            key={c.chapterId}
            value={c.chapterId}
            dir={isRtlText(c.title) ? "rtl" : undefined}
          >
            {t.placement.entry.scopeThrough.replace("{chapter}", c.title)}
          </option>
        ))}
        <option value={WHOLE_YEAR}>{t.placement.entry.scopeWholeYear}</option>
      </select>
      <p className="mt-2 text-sm text-muted-foreground">{t.placement.entry.scopeHint}</p>
    </section>
  );
}
