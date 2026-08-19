import { BookMarked, ExternalLink } from "lucide-react";
import { cnpManuelUrl } from "@/shared/content/manuel-cnp";
import { useT } from "@/lib/i18n";
import { parseChapterManuelRef, parseManuelRefs } from "../manuel-refs";

/**
 * « Manuel officiel » under the course — a LINK to the official student
 * textbook where it is already published, instead of a copy of it.
 *
 * The sibling surfaces (the subject page's PDF card, this chapter's « Pages du
 * manuel » gallery) serve files we host in private buckets: an upload per
 * volume, signed URLs, and a login gate. This one hosts nothing. The link is
 * rebuilt from the book `code` the content already declares
 * (`@/shared/content/manuel-cnp`), so there is no file to upload, no bucket to
 * keep in sync, and no reason to gate a document that is public at the source.
 *
 * Two levels of precision, best first:
 *   - the chapter declares `manuel` → ONE link, anchored on the chapter's own
 *     first page (`#page=`), labelled with its page range;
 *   - otherwise the subject declares `manuels` → one link per volume, opening
 *     at the cover.
 * Neither → renders nothing.
 *
 * The destination is never written out: the reader sees « Ouvrir le manuel ·
 * p. 18-30 », not an address.
 */
export function ManuelCnpCard({
  manuelRef,
  subjectManuelRefs,
}: {
  /** `chapters.manuel_ref` JSONB — the chapter's own page range, when authored. */
  manuelRef: unknown;
  /** `subjects.manuel_refs` JSONB — the subject's volume list, used as fallback. */
  subjectManuelRefs: unknown;
}) {
  const t = useT();

  const chapterRef = parseChapterManuelRef(manuelRef);
  // A volume list to render: the chapter's book anchored on its pages, or every
  // volume of the subject at its cover.
  const volumes = chapterRef
    ? [
        {
          key: chapterRef.code,
          href: cnpManuelUrl(chapterRef.code, chapterRef.pageNumbers[0]),
          label: t.public.reader.manuelBookOpen,
          pages: chapterRef.pages,
        },
      ]
    : parseManuelRefs(subjectManuelRefs).map((m, i, all) => ({
        key: m.code,
        href: cnpManuelUrl(m.code),
        label:
          all.length === 1
            ? t.public.reader.manuelBookOpen
            : (m.label ?? t.public.reader.manuelBookTome.replace("{n}", String(i + 1))),
        pages: null,
      }));

  // `cnpManuelUrl` refuses a code it cannot turn into a file name — drop those
  // rather than render a link that goes nowhere.
  const links = volumes.flatMap((v) => (v.href ? [{ ...v, href: v.href }] : []));
  if (links.length === 0) return null;

  return (
    <section className="mt-10 print:hidden" data-testid="manuel-cnp">
      <h2 className="flex items-center gap-2 font-display text-lg font-bold text-foreground">
        <BookMarked className="h-5 w-5 shrink-0 text-primary" />
        {t.public.reader.manuelBookTitle}
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">{t.public.reader.manuelBookHint}</p>

      <div className="mt-3 flex flex-wrap gap-2">
        {links.map((link) => (
          <a
            key={link.key}
            href={link.href}
            target="_blank"
            rel="noopener noreferrer"
            data-testid="manuel-cnp-link"
            className="inline-flex items-center gap-1.5 rounded-lg border border-primary/35 bg-primary/5 px-3 py-2 text-sm font-bold text-primary transition hover:border-primary/60 [@media(pointer:coarse)]:min-h-11"
          >
            <ExternalLink className="h-4 w-4 shrink-0" />
            {link.label}
            {link.pages && (
              // The page range reads left-to-right even in an Arabic course:
              // "18-30" is a number range, not prose.
              <span className="font-semibold text-primary/70" dir="ltr">
                · {t.public.reader.manuelBookPages.replace("{pages}", link.pages)}
              </span>
            )}
          </a>
        ))}
      </div>
    </section>
  );
}
