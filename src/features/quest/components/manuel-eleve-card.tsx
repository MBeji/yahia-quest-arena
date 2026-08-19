import { BookMarked, ExternalLink } from "lucide-react";
import { cnpManuelUrl } from "@/shared/content/manuel-cnp";
import { useT } from "@/lib/i18n";
import { parseManuelRefs } from "../manuel-refs";

/**
 * « Manuel officiel » — the subject's official student textbook, linked where
 * it is already published rather than copied into our own storage.
 *
 * The book belongs to the SUBJECT, not to a chapter: one work covers the whole
 * year's programme, so it is named once, on the subject page, instead of being
 * repeated under each of its twenty courses (arbitrage du 2026-08-19).
 *
 * This card used to serve a PDF we hosted ourselves: an upload per volume into
 * a private bucket, a signed-URL server fn, and a login gate on a document that
 * is public at the source. All of that is gone. The address is rebuilt from the
 * book `code` the content already declares (`@/shared/content/manuel-cnp`), so
 * there is nothing to upload, nothing to keep in sync, and no reason to ask a
 * reader to sign in. The destination is never written out — the reader sees
 * « Ouvrir le manuel », not an address.
 *
 * No manuel declared (or a code no link can be built from) → renders nothing.
 */
export function ManuelEleveCard({ manuelRefs }: { manuelRefs: unknown }) {
  const t = useT();
  const manuels = parseManuelRefs(manuelRefs);

  // `cnpManuelUrl` refuses a code it cannot turn into a file name — drop those
  // rather than render a link that goes nowhere.
  const volumes = manuels.flatMap((m, i) => {
    const href = cnpManuelUrl(m.code);
    if (!href) return [];
    const label =
      manuels.length === 1
        ? t.public.subject.manuelOpen
        : (m.label ?? t.public.subject.manuelTome.replace("{n}", String(i + 1)));
    return [{ code: m.code, href, label }];
  });
  if (volumes.length === 0) return null;

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

      <div className="mt-3 flex flex-wrap gap-2">
        {volumes.map((v) => (
          <a
            key={v.code}
            href={v.href}
            target="_blank"
            rel="noopener noreferrer"
            data-testid="manuel-eleve-tome"
            className="inline-flex items-center gap-1.5 rounded-lg border border-primary/35 bg-primary/5 px-3 py-2 text-sm font-bold text-primary transition hover:border-primary/60 [@media(pointer:coarse)]:min-h-11"
          >
            <ExternalLink className="h-4 w-4 shrink-0" /> {v.label}
          </a>
        ))}
      </div>
    </section>
  );
}
