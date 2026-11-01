import { Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { ClipboardCheck } from "lucide-react";

import { useI18n } from "@/lib/i18n";
import { usePlacementT } from "@/lib/i18n/placement";
import { isRtlText } from "@/shared/lib/utils";

import { getMyPlacementOverview } from "../placement.server";
import { bandCopy, formatScoreOn20 } from "../placement-bilan";

/**
 * « TON BILAN DE DÉPART » (étude 39 US-6, R-17) — la carte du Hall.
 *
 * Chargée en `lazy()` par le tableau de bord : sa lecture (`getMyPlacementOverview`), son
 * catalogue (`i18n-placement`) et son code restent hors du chunk eager. Sans bilan : une
 * invitation (dix questions, sept minutes), jamais un reproche. Avec : le dernier bilan non
 * bâclé par matière, les chapitres à revoir, « voir » et « refaire ».
 */
export function PlacementHallCard() {
  const t = usePlacementT();
  const { locale } = useI18n();
  const fetchOverview = useServerFn(getMyPlacementOverview);
  const { data, isLoading, isError } = useQuery({
    queryKey: ["placement-overview"],
    queryFn: () => fetchOverview(),
    staleTime: 60_000,
  });

  // Une lecture en panne ne doit pas poser une carte vide qui invite à tort : rien du tout.
  if (isLoading || isError) return null;
  const entries = data ?? [];

  return (
    <section
      data-testid="placement-hall-card"
      className="rounded-2xl border border-border/50 bg-surface-2 p-5 backdrop-blur-md"
    >
      <h2 className="flex items-center gap-2 font-display text-lg font-bold">
        <ClipboardCheck className="h-5 w-5 text-[color:var(--gold)]" aria-hidden="true" />
        {t.placement.hall.title}
      </h2>

      {entries.length === 0 ? (
        <>
          <p className="mt-2 text-sm text-muted-foreground">{t.placement.hall.emptyBody}</p>
          <Link
            to="/test-de-niveau"
            className="mt-4 inline-flex min-h-11 items-center rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition hover:opacity-90"
            data-testid="placement-hall-empty-cta"
          >
            {t.placement.hall.emptyCta}
          </Link>
        </>
      ) : (
        <ul className="mt-4 space-y-3">
          {entries.slice(0, 3).map((e) => {
            const names = e.chaptersToReview.slice(0, 3).map((c) => c.title);
            return (
              <li
                key={e.sessionId}
                className="rounded-xl bg-surface-1 p-4"
                data-testid="placement-hall-entry"
              >
                <div className="flex flex-wrap items-baseline justify-between gap-2">
                  <span
                    className="font-semibold"
                    dir={
                      e.contentLanguage === "ar" || isRtlText(e.subjectNameFr) ? "rtl" : undefined
                    }
                  >
                    {e.subjectNameFr}
                  </span>
                  <span className="text-sm tabular-nums text-[color:var(--gold)]">
                    {t.placement.hall.scoreLine
                      .replace("{score}", formatScoreOn20(e.scoreOn20, locale))
                      .replace("{band}", bandCopy(e.band, t.placement.summary).name)}
                  </span>
                </div>
                <p className="mt-1 text-sm text-muted-foreground">
                  {names.length === 0
                    ? t.placement.hall.allHeld
                    : t.placement.hall.toReviewLine.replace(
                        "{chapters}",
                        names.join(" · ") + (e.chaptersToReview.length > 3 ? " …" : ""),
                      )}
                </p>
                <div className="mt-3 flex flex-wrap gap-2">
                  <Link
                    to="/test-de-niveau/$sessionId"
                    params={{ sessionId: e.sessionId }}
                    className="inline-flex min-h-10 items-center rounded-lg border border-[color:var(--gold)]/40 px-3 py-1.5 text-xs font-bold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10"
                  >
                    {t.placement.hall.open}
                  </Link>
                  <Link
                    to="/test-de-niveau"
                    search={{ matiere: e.subjectId }}
                    className="inline-flex min-h-10 items-center rounded-lg px-3 py-1.5 text-xs font-semibold text-muted-foreground transition hover:text-foreground"
                  >
                    {t.placement.hall.retake}
                  </Link>
                </div>
              </li>
            );
          })}
          <li>
            <Link
              to="/test-de-niveau"
              className="inline-flex min-h-10 items-center text-xs font-semibold text-muted-foreground transition hover:text-foreground"
            >
              {t.placement.hall.emptyCta}
            </Link>
          </li>
        </ul>
      )}
    </section>
  );
}
