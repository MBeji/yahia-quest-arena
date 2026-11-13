import { useState } from "react";
import { useKeepT } from "@/lib/i18n/keep";
import { trackProductEvent } from "@/shared/lib/product-events";
import { chapterShareUrl, fillShareTemplate, shareText } from "@/shared/lib/share-text";
import { cn } from "@/shared/lib/utils";

/**
 * « GARDER CE CHAPITRE » — étude 40, lot 4 (R-15 à R-17 ; US-7, US-8).
 *
 * Le visiteur sans compte ne peut pas être relancé : ni compte, ni notification. Il a WhatsApp.
 * Cette rangée lui donne deux gestes, au plus :
 *
 *   - « M'envoyer la suite » (ou « M'envoyer ce cours » en bas d'un cours) — toujours ;
 *   - « Partager ma réussite » — sur une RÉUSSITE seulement (`success`). Un échec ne se partage pas.
 *
 * Le lien est celui du CHAPITRE. Le destinataire est choisi par la personne, dans la feuille de
 * partage ou dans WhatsApp : aucun champ de saisie ici, et rien n'atteint nos serveurs.
 *
 * LA MESURE : `content_shared{intent, surface, method}` — trois étiquettes fermées. Ni le titre du
 * chapitre ni le score n'y entrent (R-4 — des mineurs) ; ils ne vivent que dans le texte que la
 * personne envoie elle-même.
 */
export type KeepSurface = "practice" | "reader";

export function KeepRow({
  chapterId,
  chapterTitle,
  subjectName,
  surface,
  success = null,
  className,
}: {
  chapterId: string;
  chapterTitle: string;
  subjectName: string | null;
  surface: KeepSurface;
  /** Le score d'une réussite, ou `null` : pas de réussite, pas de second geste (R-17). */
  success?: { correct: number; total: number } | null;
  className?: string;
}) {
  const { copy, dir } = useKeepT();
  const [copied, setCopied] = useState(false);

  async function send(intent: "resume" | "success") {
    const text =
      intent === "success" && success
        ? fillShareTemplate(copy.successText, {
            chapter: chapterTitle,
            correct: success.correct,
            total: success.total,
            url: chapterShareUrl(chapterId, "share"),
          })
        : fillShareTemplate(copy.resumeText, {
            chapter: chapterTitle,
            subject: subjectName,
            url: chapterShareUrl(chapterId, "resume_link"),
          });
    const method = await shareText(text);
    // Feuille fermée, ou appareil qui ne sait rien faire : rien n'est parti, rien n'est compté.
    if (method === "none") return;
    trackProductEvent("content_shared", { intent, surface, method });
    setCopied(method === "copy");
  }

  const button =
    "inline-flex min-h-11 items-center rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60";

  return (
    <section
      data-testid="keep-row"
      // Le sens de l'INTERFACE, pas celui du contenu (même raison que la carte d'installation).
      dir={dir}
      aria-label={copy.title}
      className={cn(
        "rounded-2xl border border-border bg-card p-4 text-center print:hidden",
        className,
      )}
    >
      <p className="text-sm font-bold">{copy.title}</p>
      <div className="mt-3 flex flex-wrap justify-center gap-3">
        <button
          type="button"
          data-testid="keep-send"
          onClick={() => void send("resume")}
          className={button}
        >
          {surface === "reader" ? copy.sendLesson : copy.sendNext}
        </button>
        {success && (
          <button
            type="button"
            data-testid="keep-share-success"
            onClick={() => void send("success")}
            className={button}
          >
            {copy.shareSuccess}
          </button>
        )}
      </div>
      {/* Toujours dans l'arbre : un lecteur d'écran n'annonce que ce qui CHANGE dans une zone vivante. */}
      <p
        role="status"
        data-testid="keep-copied"
        className="mt-2 min-h-5 text-xs text-muted-foreground"
      >
        {copied ? copy.copied : ""}
      </p>
    </section>
  );
}
