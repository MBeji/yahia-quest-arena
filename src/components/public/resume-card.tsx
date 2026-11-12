import { Link } from "@tanstack/react-router";
import { ArrowRight, BookOpen } from "lucide-react";
import { useT } from "@/lib/i18n";
import { useResumeChapter } from "@/components/public/use-resume-chapter";
import { daysSince, forgetAnonContinuity, type ResumeChapter } from "@/shared/lib/anon-continuity";
import { trackProductEvent } from "@/shared/lib/product-events";
import { cn } from "@/shared/lib/utils";

/**
 * LA CARTE « REPRENDRE » (étude 38, lot 5) — l'appareil d'un visiteur sans compte se souvient du
 * dernier chapitre qu'il a lu, trente jours, et le lui propose à son retour.
 *
 * ELLE NE S'ADRESSE QU'AU VISITEUR SANS SESSION (Q-1). Un élève connecté a mieux : son hall, sa
 * progression enregistrée. Tant que la session n'est pas lue, rien n'est rendu — la carte ne
 * clignote pas sous les yeux d'un connecté.
 * C'est `useResumeChapter` qui décide s'il y a quoi montrer, et à qui.
 */

export type ResumeSurface = "landing" | "programme";

/**
 * La carte seule, pour qui sait déjà quoi reprendre (l'accueil lit `useResumeChapter` lui-même :
 * il doit aussi resserrer son en-tête pour que la carte ne pousse rien).
 *
 * HAUTEUR FIXE (`h-16`), titre sur UNE ligne tronquée : c'est ce qui permet à l'accueil de lui
 * réserver une place exacte, quelle que soit la longueur du titre ou la langue.
 */
export function ResumeCardView({
  chapter,
  surface,
  className,
}: {
  chapter: ResumeChapter;
  surface: ResumeSurface;
  className?: string;
}) {
  const t = useT();
  return (
    <div
      data-testid="resume-card"
      className={cn(
        "mx-auto flex h-16 w-full max-w-md items-stretch overflow-hidden rounded-2xl border border-primary/30 bg-card text-start",
        className,
      )}
    >
      <Link
        to="/chapitre/$chapterId"
        params={{ chapterId: chapter.id }}
        data-testid="resume-card-link"
        onClick={() =>
          // Zéro donnée personnelle, et pas même le chapitre : d'où l'on clique, et depuis combien
          // de jours on n'était pas revenu — c'est ce nombre qui dit « la carte a ramené quelqu'un ».
          trackProductEvent("resume_card_clicked", {
            surface,
            days_since: daysSince(chapter.at),
          })
        }
        className="group flex min-w-0 flex-1 items-center gap-3 px-4 transition hover:bg-primary/[0.04]"
      >
        <span className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-secondary text-primary">
          <BookOpen className="h-5 w-5" aria-hidden="true" />
        </span>
        <span className="min-w-0 flex-1">
          <span className="block text-xs font-semibold uppercase tracking-wider text-primary">
            {t.public.resume.kicker}
          </span>
          {/* Le titre est celui qui a été LU : il reste dans la langue du contenu même si
              l'interface a changé de langue depuis. `bdi` + `dir="auto"` l'isolent — un titre
              arabe dans une interface française, ou l'inverse, garde son sens de lecture. */}
          <bdi
            dir="auto"
            lang={chapter.lang ?? undefined}
            data-testid="resume-card-title"
            className="block truncate text-sm font-bold"
          >
            {chapter.title}
          </bdi>
        </span>
        <ArrowRight
          className="h-4 w-4 shrink-0 text-primary transition group-hover:translate-x-0.5 rtl:-scale-x-100"
          aria-hidden="true"
        />
      </Link>
      <button
        type="button"
        data-testid="resume-card-forget"
        aria-label={t.public.resume.forgetLabel}
        onClick={forgetAnonContinuity}
        className="min-w-11 shrink-0 border-s border-border px-3 text-xs font-semibold text-muted-foreground transition hover:bg-secondary hover:text-foreground"
      >
        {t.public.resume.forget}
      </button>
    </div>
  );
}

/**
 * La carte autonome, pour une page qui ne peut pas lui réserver de place dans son flux
 * (`/programme` : rendu côté serveur, et son en-tête appartient à une feature). Elle rend `null`
 * tant qu'il n'y a rien à reprendre pour ce lecteur.
 *
 * FLOTTANTE, EN BAS D'ÉCRAN : arrivant après l'hydratation sur une page déjà peinte, une carte
 * insérée en tête pousserait tout le catalogue (CLS ≈ 0,1 sur téléphone). Posée par-dessus, elle ne
 * déplace rien. La cale qui la suit garde le pied de page lisible en fin de défilement ; elle est
 * sous le catalogue, hors de la première vue.
 */
export function ResumeCard({ surface }: { surface: ResumeSurface }) {
  const chapter = useResumeChapter();
  if (!chapter) return null;
  return (
    <>
      <div aria-hidden="true" className="h-24 print:hidden" />
      <div className="pointer-events-none fixed inset-x-0 bottom-0 z-20 px-4 pb-[max(1rem,env(safe-area-inset-bottom))] print:hidden">
        <ResumeCardView
          chapter={chapter}
          surface={surface}
          className="pointer-events-auto shadow-lg"
        />
      </div>
    </>
  );
}
