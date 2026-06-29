import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { BookMarked, ChevronLeft, ChevronRight } from "lucide-react";
import { getManuelPageUrls } from "../quest.server";
import { useT } from "@/lib/i18n";
import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";

/**
 * « Pages du manuel » — the official student-textbook (manuel élève) pages that
 * cover this chapter, shown under the course as a thumbnail gallery that opens
 * into a lightbox. Login-gated: it only queries when the reader is signed in
 * (the images live in a private bucket, served as short-lived signed URLs), and
 * it renders nothing for anonymous readers or chapters without a manuel link —
 * so it can sit unconditionally inside the (anon-capable) course reader.
 */
export function ManuelPagesSection({
  chapterId,
  isAuthenticated,
}: {
  chapterId: string;
  isAuthenticated: boolean;
}) {
  const t = useT();
  const fetchPages = useServerFn(getManuelPageUrls);
  const { data } = useQuery({
    queryKey: ["manuel-pages", chapterId],
    queryFn: () => fetchPages({ data: { chapterId } }),
    enabled: isAuthenticated,
    // Signed URLs are valid ~1h; don't refetch within that window.
    staleTime: 50 * 60 * 1000,
  });

  const pages = data?.pages ?? [];
  const [openIdx, setOpenIdx] = useState<number | null>(null);

  if (pages.length === 0) return null;

  const current = openIdx !== null ? pages[openIdx] : null;
  const move = (delta: number) =>
    setOpenIdx((i) => (i === null ? i : Math.min(pages.length - 1, Math.max(0, i + delta))));

  return (
    <section className="mt-10 print:hidden" data-testid="manuel-pages">
      <h2 className="flex items-center gap-2 font-display text-lg font-bold text-foreground">
        <BookMarked className="h-5 w-5 shrink-0 text-primary" />
        {t.public.reader.manuelTitle}
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">{t.public.reader.manuelHint}</p>

      <div className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4">
        {pages.map((page, i) => (
          <button
            key={page.page}
            type="button"
            onClick={() => setOpenIdx(i)}
            aria-label={`${t.public.reader.manuelOpen} ${page.page}`}
            data-testid="manuel-thumb"
            className="group relative overflow-hidden rounded-lg border border-border bg-card transition hover:border-primary/50 focus:outline-none focus-visible:ring-2 focus-visible:ring-ring"
          >
            <img
              src={page.url}
              alt={`${t.public.reader.manuelPage} ${page.page}`}
              loading="lazy"
              className="aspect-[3/4] w-full object-cover"
            />
            <span className="absolute bottom-1 end-1 rounded bg-background/85 px-1.5 py-0.5 text-xs font-medium text-foreground">
              {t.public.reader.manuelPage} {page.page}
            </span>
          </button>
        ))}
      </div>

      <Dialog open={current !== null} onOpenChange={(open) => !open && setOpenIdx(null)}>
        {current && (
          <DialogContent className="max-w-3xl" aria-describedby={undefined}>
            <DialogTitle className="text-base">
              {t.public.reader.manuelPage} {current.page}
            </DialogTitle>
            <img
              src={current.url}
              alt={`${t.public.reader.manuelPage} ${current.page}`}
              className="mx-auto max-h-[78vh] w-auto rounded-md"
            />
            <div className="flex items-center justify-between gap-3">
              <button
                type="button"
                onClick={() => move(-1)}
                disabled={openIdx === 0}
                className="inline-flex items-center gap-1 rounded-lg border border-border px-3 py-1.5 text-sm font-medium text-muted-foreground transition hover:text-primary disabled:opacity-40"
              >
                <ChevronLeft className="h-4 w-4 rtl:-scale-x-100" />
                {t.public.reader.manuelPrev}
              </button>
              <span className="text-sm tabular-nums text-muted-foreground">
                {(openIdx ?? 0) + 1} / {pages.length}
              </span>
              <button
                type="button"
                onClick={() => move(1)}
                disabled={openIdx === pages.length - 1}
                className="inline-flex items-center gap-1 rounded-lg border border-border px-3 py-1.5 text-sm font-medium text-muted-foreground transition hover:text-primary disabled:opacity-40"
              >
                {t.public.reader.manuelNext}
                <ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
              </button>
            </div>
          </DialogContent>
        )}
      </Dialog>
    </section>
  );
}
