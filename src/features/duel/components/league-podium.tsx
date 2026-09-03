import { useEffect, useState } from "react";
import { Trophy, X } from "lucide-react";

import { Confetti } from "@/features/quest/components/confetti";
import { useSound } from "@/lib/sound";
import { useT } from "@/lib/i18n";
import { trackProductEvent } from "@/shared/lib/product-events";
import { tierLabel } from "../duel-tiers";
import type { DuelLastAward } from "../duel.server";

/**
 * LE PODIUM DE LIGUE (étude 31 lot 5 — US-6).
 *
 * Constat n° 6 de l'étude : « la ligue se termine dans le SILENCE ». Le gain
 * tombait le lundi à 02:30 par cron, et l'élève ne l'apprenait qu'en revenant de
 * lui-même — s'il revenait. Le lot 4 a posé la notification ; celle-ci est ce
 * qu'il trouve en arrivant : un rang, un palier, un gain, un son et des confettis.
 *
 * **Vu une fois, pas à chaque visite.** La semaine déjà célébrée est retenue dans
 * le navigateur (`localStorage`) : c'est une commodité par appareil, pas un état
 * de jeu — la revoir sur un second appareil ne coûte rien, la revoir dix fois sur
 * le même serait une fête qui ne veut plus rien dire. Rien de tout cela ne
 * justifie une table.
 *
 * ⚠️ Aucun bouton « rejouer » ici : c'est une fin de cycle, pas un rebond (R-6).
 */
const SEEN_KEY = "na9ra.league_podium_seen";

/** Lecture défensive : un `localStorage` indisponible ne doit pas casser l'écran. */
function readSeen(): string | null {
  try {
    return window.localStorage.getItem(SEEN_KEY);
  } catch {
    return null;
  }
}

function markSeen(weekStart: string): void {
  try {
    window.localStorage.setItem(SEEN_KEY, weekStart);
  } catch {
    // Mode privé, quota, navigateur verrouillé : on célèbre quand même, une fois
    // de plus au pire. Ne jamais faire échouer un écran pour une commodité.
  }
}

export function LeaguePodium({ award }: { award: DuelLastAward }) {
  const t = useT();
  const { play } = useSound();
  const [open, setOpen] = useState(false);

  useEffect(() => {
    if (!award) return;
    if (readSeen() === award.weekStart) return;
    setOpen(true);
    markSeen(award.weekStart);
    play("victory");
    // é31 lot 1 — le funnel apprend enfin que la ligue a été DÉCOUVERTE, pas
    // seulement versée : le virement de 02:30 n'a jamais rien mesuré.
    trackProductEvent("league_awarded", { tier: award.tier, rank: award.rank });
  }, [award, play]);

  if (!award || !open) return null;

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-label={t.dashboard.podiumTitle}
      data-testid="league-podium"
      className="fixed inset-0 z-50 grid place-items-center bg-black-deep/80 p-6 backdrop-blur-sm"
    >
      <Confetti />
      <div className="relative w-full max-w-sm rounded-2xl border border-[color:var(--gold)]/40 bg-surface-2 p-6 text-center">
        <button
          type="button"
          onClick={() => setOpen(false)}
          aria-label={t.dashboard.podiumClose}
          className="absolute end-3 top-3 text-muted-foreground hover:text-foreground"
        >
          <X className="h-4 w-4" />
        </button>

        <Trophy className="mx-auto h-12 w-12 text-[color:var(--gold)]" aria-hidden="true" />
        <h2 className="mt-3 font-display text-xl font-bold">{t.dashboard.podiumTitle}</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          {t.dashboard.podiumRank
            .replace("{rank}", String(award.rank))
            .replace("{tier}", tierLabel(award.tier, t.duel))}
        </p>
        <p className="mt-1 font-display text-lg font-bold text-[color:var(--gold)]">
          {t.dashboard.podiumCoins.replace("{coins}", String(award.coins))}
        </p>

        <button
          type="button"
          onClick={() => setOpen(false)}
          className="mt-5 min-h-11 w-full rounded-lg bg-[color:var(--gold)]/15 px-4 py-2 font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/25"
        >
          {t.dashboard.podiumClose}
        </button>
      </div>
    </div>
  );
}
