import { useEffect, useRef, useState } from "react";
import { Link } from "@tanstack/react-router";
import { ChevronRight, LogOut, Settings } from "lucide-react";

import { useT } from "@/lib/i18n";
import { ThemeChoice, LocaleChoice, SoundToggles } from "@/components/ui/settings-controls";

/**
 * Le point d'entrée UNIQUE des réglages — un engrenage, là où le header portait
 * trois pop-over distincts (langue, thème, son) plus un bouton de déconnexion,
 * soit cinq contrôles permanents dans la zone la plus étroite de l'écran.
 *
 * Il ne redouble pas la page `/parametrage` : il n'expose que les quatre bascules
 * instantanées, celles dont le coût d'une navigation serait absurde (couper le
 * son, passer en arabe au milieu d'une lecture) — et ce sont les MÊMES contrôles,
 * pas des copies : ils viennent de `settings-controls`. Tout le reste — compte,
 * parcours, notifications, aide — vit dans la page, atteinte par « Tous les
 * paramètres ».
 *
 * `onSignOut` est ce qui distingue les deux coquilles : la coquille connectée le
 * passe et reçoit le bloc compte (page + déconnexion) ; la coquille publique ne
 * le passe pas et n'obtient que les réglages rapides. Les trois providers
 * (thème, langue, son) vivant à la racine, un visiteur anonyme peut désormais
 * couper la musique — ce que l'ancien header public ne permettait pas.
 */
export function SettingsMenu({
  className = "",
  onSignOut,
}: {
  className?: string;
  onSignOut?: () => void;
}) {
  const t = useT();
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    function onPointerDown(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    }
    // Échap ferme : le menu porte des interrupteurs, on ne piège pas le clavier
    // derrière un pop-over qui ne se refermerait qu'à la souris.
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("mousedown", onPointerDown);
    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.removeEventListener("mousedown", onPointerDown);
      document.removeEventListener("keydown", onKeyDown);
    };
  }, [open]);

  return (
    <div ref={ref} className={`relative ${className}`}>
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className="flex min-h-11 min-w-11 items-center justify-center rounded-md border border-border/50 bg-background/50 px-2 py-1.5 text-muted-foreground backdrop-blur-md transition hover:border-[color:var(--gold)]/50 hover:text-foreground"
        aria-label={t.settings.menuAria}
        aria-haspopup="menu"
        aria-expanded={open}
        data-testid="settings-trigger"
      >
        <Settings className="h-4 w-4" />
      </button>

      {open && (
        <div
          role="menu"
          data-testid="settings-menu"
          className="absolute end-0 top-full z-50 mt-1.5 max-h-[70vh] w-64 overflow-y-auto rounded-xl border border-border/60 bg-popover/95 p-2 shadow-lg backdrop-blur-xl"
        >
          <div className="px-2 pb-1 text-2xs uppercase tracking-[0.2em] text-muted-foreground">
            {t.settings.quickTitle}
          </div>

          <div className="px-2">
            <ThemeChoice />
            <LocaleChoice />
          </div>
          <SoundToggles />

          {onSignOut && (
            <>
              <div className="my-1 border-t border-border/60" />
              <Link
                to="/parametrage"
                onClick={() => setOpen(false)}
                className="flex min-h-11 items-center justify-between gap-2 rounded-lg px-2 py-2 text-sm text-foreground transition hover:bg-accent"
              >
                <span className="flex items-center gap-2.5">
                  <Settings className="h-4 w-4 shrink-0" />
                  {t.settings.allSettings}
                </span>
                <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground rtl:-scale-x-100" />
              </Link>
              <button
                type="button"
                onClick={() => {
                  setOpen(false);
                  onSignOut();
                }}
                className="flex min-h-11 w-full items-center gap-2.5 rounded-lg px-2 py-2 text-sm text-muted-foreground transition hover:bg-accent hover:text-foreground"
              >
                <LogOut className="h-4 w-4 shrink-0" />
                {t.layout.signOut}
              </button>
            </>
          )}
        </div>
      )}
    </div>
  );
}
