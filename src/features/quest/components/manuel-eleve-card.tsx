import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Link } from "@tanstack/react-router";
import { BookMarked, ExternalLink, Lock } from "lucide-react";
import { getSubjectManuels } from "../manuel.server";
import { parseManuelRefs, type ManuelRef } from "../manuel-refs";
import { useT } from "@/lib/i18n";

/**
 * « Manuel officiel » — the complete official student textbook (manuel élève)
 * of the subject, as PDF volume(s), shown as a card on the public subject page.
 *
 * The volume LIST is public metadata (`subjects.manuel_refs`, already part of
 * the `getSubject` payload), so the card is discoverable by everyone; the FILES
 * are login-gated (private bucket + signed URLs):
 *   - signed-in → one link per volume, opening the signed PDF in a new tab;
 *   - anonymous → the same card, locked, inviting to sign in (the decision of
 *     2026-07-16: discoverable teaser rather than a hidden section);
 *   - no manuel (or PDFs not uploaded yet) → renders nothing / links vanish.
 *
 * Split in two so the no-manuel case renders `null` WITHOUT mounting any hook —
 * SubjectHub can stay renderable outside a QueryClientProvider as long as the
 * subject has no manuel (the pre-existing tests' setup).
 */
export function ManuelEleveCard({
  manuelRefs,
  isAuthenticated,
}: {
  manuelRefs: unknown;
  isAuthenticated: boolean;
}) {
  const manuels = parseManuelRefs(manuelRefs);
  if (manuels.length === 0) return null;
  return <ManuelEleveCardInner manuels={manuels} isAuthenticated={isAuthenticated} />;
}

function ManuelEleveCardInner({
  manuels,
  isAuthenticated,
}: {
  manuels: ManuelRef[];
  isAuthenticated: boolean;
}) {
  const t = useT();
  const fetchManuels = useServerFn(getSubjectManuels);
  const { data } = useQuery({
    queryKey: ["manuel-eleve", manuels.map((m) => m.code).join("+")],
    queryFn: () => fetchManuels({ data: { manuels } }),
    enabled: isAuthenticated,
    // Signed URLs are valid ~1h; don't refetch within that window.
    staleTime: 50 * 60 * 1000,
  });
  const urlByCode = new Map((data?.manuels ?? []).map((m) => [m.code, m.url]));

  const volumeLabel = (m: ManuelRef, i: number) =>
    manuels.length === 1
      ? t.public.subject.manuelOpen
      : (m.label ?? t.public.subject.manuelTome.replace("{n}", String(i + 1)));

  return (
    <section
      data-testid="manuel-eleve"
      className="mb-6 rounded-xl border border-border bg-card p-3"
    >
      <div className="flex items-center gap-2">
        <BookMarked className="h-5 w-5 shrink-0 text-primary" />
        <h2 className="font-display text-base font-bold text-foreground">
          {t.public.subject.manuelTitle}
        </h2>
      </div>
      <p className="mt-1 text-sm text-muted-foreground">{t.public.subject.manuelHint}</p>

      {isAuthenticated ? (
        <div className="mt-3 flex flex-wrap gap-2">
          {manuels.map((m, i) => {
            const url = urlByCode.get(m.code);
            return url ? (
              <a
                key={m.code}
                href={url}
                target="_blank"
                rel="noopener noreferrer"
                data-testid="manuel-eleve-tome"
                className="inline-flex items-center gap-1.5 rounded-lg border border-primary/35 bg-primary/5 px-3 py-2 text-sm font-bold text-primary transition hover:border-primary/60 [@media(pointer:coarse)]:min-h-11"
              >
                <ExternalLink className="h-4 w-4" /> {volumeLabel(m, i)}
              </a>
            ) : (
              // Signed URL not available (still loading, or PDF not uploaded
              // yet) — show the volume as inert so the card never dead-links.
              <span
                key={m.code}
                data-testid="manuel-eleve-tome-pending"
                className="inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-2 text-sm font-semibold text-muted-foreground/60"
              >
                <BookMarked className="h-4 w-4" /> {volumeLabel(m, i)}
              </span>
            );
          })}
        </div>
      ) : (
        <div className="mt-3 flex flex-wrap items-center gap-3">
          <span
            data-testid="manuel-eleve-locked"
            className="inline-flex items-center gap-1.5 text-sm text-muted-foreground"
          >
            <Lock className="h-4 w-4 shrink-0" /> {t.public.subject.manuelLockedHint}
          </span>
          <Link
            to="/auth"
            data-testid="manuel-eleve-login"
            className="inline-flex items-center rounded-lg border border-primary/35 bg-primary/5 px-3 py-1.5 text-sm font-bold text-primary transition hover:border-primary/60 [@media(pointer:coarse)]:min-h-11"
          >
            {t.public.subject.manuelLoginCta}
          </Link>
        </div>
      )}
    </section>
  );
}
