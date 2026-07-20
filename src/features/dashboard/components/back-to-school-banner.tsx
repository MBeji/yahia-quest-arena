import { Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { GraduationCap, X } from "lucide-react";

import { useT } from "@/lib/i18n";
import { schoolYearKey } from "@/shared/lib/back-to-school";

export type PromotionSuggestion = {
  /** Nom lisible de la classe visée — la copie l'interpelle. */
  gradeName: string;
  /** Promotion directe : le parcours à rejoindre en un clic. */
  parcoursId: string | null;
  /**
   * Choix de section : la clé d'année de `/programme/lycee/$annee`. Exclusif de `parcoursId`
   * — depuis l'ouverture du lycée, 2ème, 3ème et bac se déclinent en sections, et la bannière
   * n'a pas à choisir laquelle à la place de l'élève.
   */
  drilldownYear: string | null;
};

/**
 * Bannière de rentrée — étude 22, R-4.
 *
 * La promotion est **proposée, jamais imposée** (D-6) : il n'existe aucun job de septembre qui
 * fait monter les élèves d'une classe, parce que les redoublants, les sections de lycée et les
 * comptes dormants rendraient un tel batch faux par construction.
 *
 * Deux actions, toutes deux explicites : monter d'une classe, ou rester. « Je reste » ferme la
 * bannière **pour la saison** — la clé de rejet porte l'année scolaire (`2026-2027`), de sorte
 * qu'un refus cette année ne muselle pas la rentrée suivante. Rien n'est écrit côté serveur :
 * un refus d'affichage ne mérite pas une colonne.
 *
 * Le rejet est lu APRÈS le montage : le rendu serveur et le premier rendu client doivent
 * s'accorder (même discipline que le lecteur de cours et la porte de quiz anonyme).
 */
export function BackToSchoolBanner({
  suggestion,
  currentClassName,
}: {
  suggestion: PromotionSuggestion;
  currentClassName: string;
}) {
  const t = useT();
  const [dismissed, setDismissed] = useState(true);
  const storageKey = `na9ra.backToSchoolDismissed.${schoolYearKey()}`;

  useEffect(() => {
    try {
      setDismissed(localStorage.getItem(storageKey) === "1");
    } catch {
      // Stockage indisponible (navigation privée stricte) : on montre la bannière plutôt que
      // de la masquer par erreur — elle reste refusable, simplement pas mémorisable.
      setDismissed(false);
    }
  }, [storageKey]);

  if (dismissed) return null;

  const fill = (s: string) =>
    s.replace(/\{current\}/g, currentClassName).replace(/\{next\}/g, suggestion.gradeName);

  function stay() {
    try {
      localStorage.setItem(storageKey, "1");
    } catch {
      // Sans stockage, le refus ne vaut que pour cette visite — acceptable et silencieux.
    }
    setDismissed(true);
  }

  const ctaClass =
    "inline-flex min-h-11 items-center rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2 text-sm font-bold text-primary-foreground shadow-gold transition hover:opacity-90";

  return (
    <div
      data-testid="back-to-school-banner"
      className="mt-6 rounded-2xl border border-[color:var(--gold)]/40 bg-black/60 p-5 backdrop-blur-xl"
    >
      <div className="flex items-start gap-4">
        <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/15 text-[color:var(--gold)]">
          <GraduationCap className="h-5 w-5" />
        </span>
        <div className="min-w-0 flex-1">
          <div className="font-display text-lg font-bold">{t.dashboard.backToSchool.title}</div>
          <p className="mt-1 text-sm text-muted-foreground">
            {fill(t.dashboard.backToSchool.body)}
          </p>
          <div className="mt-4 flex flex-wrap items-center gap-2">
            {suggestion.drilldownYear ? (
              <Link
                to="/programme/lycee/$annee"
                params={{ annee: suggestion.drilldownYear }}
                data-testid="back-to-school-cta"
                className={ctaClass}
              >
                {fill(t.dashboard.backToSchool.ctaSection)}
              </Link>
            ) : suggestion.parcoursId ? (
              <Link
                to="/niveau/$parcoursId"
                params={{ parcoursId: suggestion.parcoursId }}
                data-testid="back-to-school-cta"
                className={ctaClass}
              >
                {fill(t.dashboard.backToSchool.cta)}
              </Link>
            ) : null}
            <button
              type="button"
              onClick={stay}
              data-testid="back-to-school-stay"
              className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-border/60 px-4 py-2 text-sm font-semibold text-muted-foreground transition hover:text-foreground"
            >
              <X className="h-3.5 w-3.5" />
              {fill(t.dashboard.backToSchool.stay)}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
