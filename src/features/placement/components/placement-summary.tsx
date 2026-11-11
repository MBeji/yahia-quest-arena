import { useState } from "react";
import { Link } from "@tanstack/react-router";
import { BookOpen, Check, Copy, Share2, Sparkles, Trophy, X } from "lucide-react";

import { Button } from "@/components/ui/button";
import { OptionContent, RichField } from "@/components/ui/svg-figure";
import { useI18n } from "@/lib/i18n";
import { usePlacementT } from "@/lib/i18n/placement";
import { PLACEMENT_MIN_CANDIDATES } from "@/shared/constants/placement";
import { cn, isRtlText } from "@/shared/lib/utils";

import type { PlacementBilan, PlacementReviewItem } from "../placement.server";
import {
  bandCopy,
  buildShareText,
  formatScoreOn20,
  sharePlacementText,
  splitChapters,
} from "../placement-bilan";

/**
 * LE BILAN (étude 39 US-2, US-3, R-5 à R-12) — la note, la bande, ce qui tient PUIS ce qui est à
 * revoir (R-7), par où commencer (R-8), le partage, ce que le compte ouvre (D-5), la correction.
 *
 * Rien ici ne juge : tout vient du serveur, figé (R-13). Ce composant met en mots et en liens.
 * Auth-aware par PROPS (`isAuthenticated`, `authLoading`) — la route lit `useAuth`, la feature
 * n'importe pas `auth` (D-11). Tant que la session n'est pas lue, AUCUNE invitation n'est rendue
 * (é38 R-6) : « crée ton compte » serait faux pour un connecté.
 */
export function PlacementSummary({
  bilan,
  isAuthenticated,
  authLoading,
  onShared,
  onInviteClick,
}: {
  bilan: PlacementBilan;
  isAuthenticated: boolean;
  authLoading: boolean;
  /** Mesure : ce qui a été fait (`share` | `copy`). */
  onShared: (method: "share" | "copy") => void;
  /** Mesure + mémoire de retour, posées par la route. */
  onInviteClick: () => void;
}) {
  const t = usePlacementT();
  const { locale } = useI18n();
  const s = t.placement.summary;
  const [copied, setCopied] = useState(false);

  const { held, toReview } = splitChapters(bilan.chapters);
  const band = bandCopy(bilan.band, s);
  const score = formatScoreOn20(bilan.scoreOn20, locale);
  const subjectName = bilan.subject.nameFr;
  const gradeName = bilan.subject.gradeNameFr;
  const rtlSubject = bilan.subject.contentLanguage === "ar";
  const percentile =
    bilan.percentile.candidates >= PLACEMENT_MIN_CANDIDATES ? bilan.percentile.percentile : null;

  async function share() {
    const text = buildShareText(
      {
        scoreOn20: bilan.scoreOn20,
        subjectName,
        gradeName,
        subjectId: bilan.subject.id,
        percentile,
      },
      s,
      locale,
    );
    const method = await sharePlacementText(text);
    if (method === "none") return;
    if (method === "copy") {
      setCopied(true);
      setTimeout(() => setCopied(false), 2500);
    }
    onShared(method);
  }

  const misconceptionLabel = (m: NonNullable<PlacementReviewItem["misconception"]>) =>
    locale === "ar" ? m.labelAr : locale === "en" ? m.labelEn : m.labelFr;

  return (
    <div className="space-y-8" data-testid="placement-summary">
      {/* --- La note et la bande (R-5, R-6) --- */}
      <section className="rounded-2xl border border-border bg-card p-6 text-center">
        <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
          {s.title} ·{" "}
          <span dir={rtlSubject || isRtlText(subjectName) ? "rtl" : undefined}>{subjectName}</span>
          {gradeName ? ` · ${gradeName}` : ""}
        </p>
        <p className="mt-3 text-sm text-muted-foreground">{s.scoreLabel}</p>
        <p
          className="font-display text-6xl font-bold tabular-nums text-primary"
          data-testid="placement-score"
        >
          {score}
          <span className="text-2xl text-muted-foreground">/20</span>
        </p>
        <p className="mt-1 text-sm text-muted-foreground tabular-nums">
          {s.correctOf
            .replace("{correct}", String(bilan.correct))
            .replace("{total}", String(bilan.total))}
        </p>
        <p
          className="mt-4 inline-flex items-center gap-2 rounded-full bg-primary/10 px-4 py-1.5 font-display text-base font-bold text-primary"
          data-testid="placement-band"
        >
          <Trophy className="h-4 w-4" aria-hidden /> {band.name}
        </p>
        <p className="mx-auto mt-3 max-w-md text-sm">{band.line}</p>
        {bilan.tooFast && (
          <p
            className="mx-auto mt-3 max-w-md rounded-xl border border-border bg-background/60 p-3 text-sm text-muted-foreground"
            data-testid="placement-too-fast"
          >
            {s.tooFast}
          </p>
        )}
        <p
          className="mt-3 text-sm tabular-nums text-muted-foreground"
          data-testid="placement-percentile"
        >
          {percentile === null
            ? s.percentilePending.replace("{n}", String(bilan.percentile.minCandidates))
            : s.percentile.replace("{pct}", String(percentile))}
        </p>
      </section>

      {/* --- Ce qui tient d'abord, puis à revoir (R-7) --- */}
      <section className="grid gap-4 sm:grid-cols-2">
        <div className="rounded-2xl border border-border bg-card p-5">
          <h2 className="flex items-center gap-2 font-display text-lg font-bold">
            <Check className="h-5 w-5 text-success" aria-hidden /> {s.heldTitle}
          </h2>
          {held.length === 0 ? (
            <p className="mt-2 text-sm text-muted-foreground">—</p>
          ) : (
            <ul className="mt-3 space-y-2">
              {held.map((c) => (
                <li key={c.chapterId} className="flex items-start justify-between gap-3 text-sm">
                  <span dir={isRtlText(c.title) ? "rtl" : undefined}>{c.title}</span>
                  <span className="shrink-0 text-xs font-semibold text-success">{s.held}</span>
                </li>
              ))}
            </ul>
          )}
        </div>
        <div className="rounded-2xl border border-border bg-card p-5">
          <h2 className="flex items-center gap-2 font-display text-lg font-bold">
            <BookOpen className="h-5 w-5 text-primary" aria-hidden /> {s.reviewTitle}
          </h2>
          {toReview.length === 0 ? (
            <p className="mt-2 text-sm text-muted-foreground">{s.allHeld}</p>
          ) : (
            <ul className="mt-3 space-y-2">
              {toReview.map((c) => (
                <li key={c.chapterId} className="flex items-start justify-between gap-3 text-sm">
                  {c.hasLesson ? (
                    <Link
                      to="/chapitre/$chapterId"
                      params={{ chapterId: c.chapterId }}
                      className="font-medium text-primary hover:underline"
                      dir={isRtlText(c.title) ? "rtl" : undefined}
                    >
                      {c.title}
                    </Link>
                  ) : (
                    <span dir={isRtlText(c.title) ? "rtl" : undefined}>{c.title}</span>
                  )}
                  <span className="shrink-0 text-xs font-semibold text-primary">{s.toReview}</span>
                </li>
              ))}
            </ul>
          )}
        </div>
      </section>

      {/* --- Par où commencer (R-8) --- */}
      <section className="rounded-2xl border border-primary/30 bg-primary/[0.04] p-5">
        <h2 className="font-display text-lg font-bold">{s.startWithTitle}</h2>
        <div className="mt-3 flex flex-wrap gap-3">
          {bilan.firstToReview ? (
            <Link
              to="/chapitre/$chapterId"
              params={{ chapterId: bilan.firstToReview.chapterId }}
              className="inline-flex min-h-11 items-center gap-2 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
              data-testid="placement-start-with"
            >
              <BookOpen className="h-4 w-4" aria-hidden />
              <span dir={isRtlText(bilan.firstToReview.title) ? "rtl" : undefined}>
                {s.startWithLesson.replace("{chapter}", bilan.firstToReview.title)}
              </span>
            </Link>
          ) : null}
          <Link
            to="/matiere/$subjectId"
            params={{ subjectId: bilan.subject.id }}
            className="inline-flex min-h-11 items-center gap-2 rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
          >
            {s.startWithSubject}
          </Link>
        </div>
      </section>

      {/* --- Partager (US-3) --- */}
      <section className="rounded-2xl border border-border bg-card p-5">
        <h2 className="font-display text-lg font-bold">{s.shareTitle}</h2>
        <p className="mt-1 text-sm text-muted-foreground">{s.shareBody}</p>
        <div className="mt-3 flex flex-wrap gap-3">
          <Button
            type="button"
            className="min-h-11 gap-2"
            onClick={share}
            data-testid="placement-share"
          >
            <Share2 className="h-4 w-4" aria-hidden /> {s.share}
          </Button>
          <Button
            type="button"
            variant="outline"
            className="min-h-11 gap-2"
            onClick={share}
            data-testid="placement-copy"
          >
            <Copy className="h-4 w-4" aria-hidden /> {copied ? s.copied : s.copy}
          </Button>
        </div>
      </section>

      {/* --- Ce que le compte ouvre (D-5) — jamais rendu tant que la session n'est pas lue (é38 R-6) --- */}
      {!authLoading &&
        (isAuthenticated ? (
          <Link
            to="/dashboard"
            className="flex items-center justify-center gap-2 rounded-2xl border border-primary/30 bg-primary/[0.04] p-4 text-sm font-semibold text-primary transition hover:bg-primary/10"
            data-testid="placement-see-hall"
          >
            <Sparkles className="h-4 w-4" aria-hidden /> {s.seeInHall}
          </Link>
        ) : bilan.audience === "parent" ? (
          <section
            className="rounded-2xl border border-primary/30 bg-primary/[0.04] p-5 text-center"
            data-testid="placement-invite-parent"
          >
            <Sparkles className="mx-auto h-6 w-6 text-primary" aria-hidden />
            <h2 className="mt-2 font-display text-lg font-bold">{s.parentTitle}</h2>
            <p className="mx-auto mt-1 max-w-md text-sm text-muted-foreground">{s.parentBody}</p>
            <div className="mt-4 flex flex-wrap justify-center gap-3">
              <Link
                to="/signup"
                onClick={onInviteClick}
                className="inline-flex min-h-11 items-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
              >
                {s.parentCreate}
              </Link>
              <Link
                to="/suivi"
                className="inline-flex min-h-11 items-center rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
              >
                {s.parentTracking}
              </Link>
            </div>
          </section>
        ) : (
          <section
            className="rounded-2xl border border-primary/30 bg-primary/[0.04] p-5 text-center"
            data-testid="placement-invite"
          >
            <Sparkles className="mx-auto h-6 w-6 text-primary" aria-hidden />
            <h2 className="mt-2 font-display text-lg font-bold">{s.lockedTitle}</h2>
            <p className="mx-auto mt-1 max-w-md text-sm text-muted-foreground">{s.lockedBody}</p>
            <Link
              to="/signup"
              onClick={onInviteClick}
              className="mt-4 inline-flex min-h-11 items-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
            >
              {s.lockedCta}
            </Link>
          </section>
        ))}

      {/* --- La correction (R-11, R-12) --- */}
      <section className="space-y-3">
        <h2 className="font-display text-lg font-bold">{s.correctionTitle}</h2>
        {bilan.review.map((q) => {
          const chosen = q.options.find((o) => o.id === q.selectedChoice);
          const expected = q.options.find((o) => o.id === q.correctChoice);
          return (
            <article
              key={q.questionId}
              className="rounded-xl border border-border bg-card p-4"
              dir={rtlSubject ? "rtl" : undefined}
              data-testid="placement-review-item"
            >
              <div className="flex items-start gap-2">
                {q.isCorrect ? (
                  <Check className="mt-1 h-4 w-4 shrink-0 text-success" aria-hidden />
                ) : (
                  <X className="mt-1 h-4 w-4 shrink-0 text-destructive" aria-hidden />
                )}
                <RichField raw={q.prompt} className="font-medium" />
              </div>
              <dl className="mt-2 flex flex-col gap-1 text-sm">
                <div className="flex flex-wrap items-baseline gap-2">
                  <dt className="text-muted-foreground">{s.yourAnswer}</dt>
                  <dd className={cn(q.isCorrect ? "text-success" : "text-destructive")}>
                    {q.selectedChoice === null ? (
                      s.noAnswer
                    ) : chosen ? (
                      <OptionContent raw={chosen.text} />
                    ) : (
                      q.selectedChoice
                    )}
                  </dd>
                </div>
                {!q.isCorrect && q.correctChoice !== null && (
                  <div className="flex flex-wrap items-baseline gap-2">
                    <dt className="text-muted-foreground">{s.correctAnswer}</dt>
                    <dd className="text-success">
                      {expected ? <OptionContent raw={expected.text} /> : q.correctChoice}
                    </dd>
                  </div>
                )}
                {q.misconception && (
                  <div
                    className="flex flex-wrap items-baseline gap-2"
                    data-testid="placement-misconception"
                  >
                    <dt className="text-muted-foreground">{s.misconceptionLabel}</dt>
                    <dd className="font-medium">{misconceptionLabel(q.misconception)}</dd>
                  </div>
                )}
                {q.explanation && (
                  <div className="mt-1" data-testid="placement-explanation">
                    <dt className="text-muted-foreground">{s.explanationLabel}</dt>
                    <dd>
                      <RichField raw={q.explanation} className="text-sm" />
                    </dd>
                  </div>
                )}
              </dl>
            </article>
          );
        })}
      </section>
    </div>
  );
}
