import { useEffect, useRef, type ReactNode } from "react";
import { useInstallT } from "@/lib/i18n/install";
import type { NudgeControls } from "@/components/public/nudge-slot";
import { promptInstall, type InstallMode } from "@/shared/lib/install-prompt";
import { trackProductEvent } from "@/shared/lib/product-events";
import { cn } from "@/shared/lib/utils";

/**
 * L'INVITATION À INSTALLER — étude 40, lot 3 (R-11, R-13 ; US-5, US-6, US-10).
 *
 * Le visiteur sans compte, l'audience principale, n'a aucun fil de retour ; sur iPhone il n'en
 * existe aucun hors application installée. Cette carte propose de mettre Na9ra Nal3ab sur l'écran
 * d'accueil, au seul moment où cela a un sens : après une réussite, ou devant un bilan affiché.
 *
 *   - `native` (Chromium) : un bouton, qui ouvre la fenêtre du navigateur ;
 *   - `ios` (Safari iPhone / iPad) : les deux gestes à faire, montrés — aucun bouton d'action,
 *     Safari n'offrant rien à déclencher.
 *
 * LA MESURE (KPI-5 = acceptées / montrées) : `install_invite{action, platform, audience}`, trois
 * étiquettes fermées. Rien sur la personne, rien sur la page (R-4 — des mineurs).
 */

export type InstallAudience = "student" | "parent";
export type InstallPlatform = Exclude<InstallMode, "none">;

/**
 * Un pictogramme du menu de Safari (« Partager », « Sur l'écran d'accueil »), tracé ici : deux
 * icônes de plus dans `vendor-icons` l'auraient laissé à 0,26 Ko de son plafond, pour une carte
 * que seul Safari iOS affiche.
 */
function SafariGlyph({ children }: { children: ReactNode }) {
  return (
    <span className="grid h-8 w-8 shrink-0 place-items-center rounded-lg bg-secondary text-primary">
      <svg
        viewBox="0 0 24 24"
        className="h-4 w-4"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        aria-hidden="true"
      >
        {children}
      </svg>
    </span>
  );
}

export function InstallInvite({
  platform,
  audience,
  controls,
  className,
}: {
  platform: InstallPlatform;
  audience: InstallAudience;
  controls: NudgeControls;
  className?: string;
}) {
  const { copy, dir } = useInstallT();

  // Une carte montrée = un événement, quel que soit le nombre de rendus.
  const counted = useRef(false);
  useEffect(() => {
    if (counted.current) return;
    counted.current = true;
    trackProductEvent("install_invite", { action: "shown", platform, audience });
  }, [platform, audience]);

  function later() {
    trackProductEvent("install_invite", { action: "dismissed", platform, audience });
    controls.dismiss();
  }

  async function install() {
    const outcome = await promptInstall();
    if (outcome === "accepted") {
      trackProductEvent("install_invite", { action: "accepted", platform, audience });
      controls.settle();
    } else if (outcome === "dismissed") {
      later();
    }
    // `unavailable` : la fenêtre n'a pas pu s'ouvrir — ni acceptation ni refus, rien n'est compté.
  }

  return (
    <section
      data-testid="install-invite"
      data-platform={platform}
      // Le sens de l'INTERFACE, pas celui du contenu : l'écran de résultat d'un exercice en arabe
      // est posé en `rtl`, et une carte en français y verrait sa ponctuation passer à gauche.
      dir={dir}
      aria-label={audience === "parent" ? copy.parentTitle : copy.studentTitle}
      className={cn(
        "rounded-2xl border border-border bg-card p-4 text-start print:hidden",
        className,
      )}
    >
      <p className="text-sm font-bold">
        {audience === "parent" ? copy.parentTitle : copy.studentTitle}
      </p>
      <p className="mt-1 text-sm text-muted-foreground">
        {audience === "parent" ? copy.parentBody : copy.studentBody}
      </p>
      {platform === "ios" && (
        <>
          <p className="mt-3 text-xs font-semibold text-muted-foreground">{copy.iosHint}</p>
          {/* Les deux pictogrammes sont ceux de Safari, pas des flèches de direction : ils ne se
              retournent pas en arabe. La liste, elle, suit le sens de lecture. */}
          <ol data-testid="install-invite-steps" className="mt-2 space-y-2 text-sm font-semibold">
            <li className="flex items-center gap-2">
              <SafariGlyph>
                <path d="M12 2v13" />
                <path d="m16 6-4-4-4 4" />
                <path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8" />
              </SafariGlyph>
              {copy.iosShare}
            </li>
            <li className="flex items-center gap-2">
              <SafariGlyph>
                <rect width="18" height="18" x="3" y="3" rx="2" />
                <path d="M8 12h8" />
                <path d="M12 8v8" />
              </SafariGlyph>
              {copy.iosAdd}
            </li>
          </ol>
        </>
      )}
      <div className="mt-3 flex flex-wrap items-center gap-2">
        {platform === "native" && (
          <button
            type="button"
            data-testid="install-invite-cta"
            onClick={() => void install()}
            className="inline-flex min-h-11 items-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
          >
            {copy.cta}
          </button>
        )}
        <button
          type="button"
          data-testid="install-invite-later"
          onClick={later}
          className="inline-flex min-h-11 items-center rounded-lg px-3 py-2.5 text-sm font-semibold text-muted-foreground transition hover:text-foreground"
        >
          {copy.later}
        </button>
      </div>
    </section>
  );
}
