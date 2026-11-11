import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import {
  bossDamageFor,
  bossHpForDamage,
  bossRankForDamage,
  type BossSpeedTier,
} from "@/features/quest/boss-speed";

/**
 * Le chronomètre du combat de boss, sorti de `exercise-player.tsx` (2026-11-03) :
 * le lecteur était à 740 lignes de code pour un plafond de 750, et ce bloc ne
 * partage avec le reste que quatre valeurs — son interface tient en quatre champs.
 *
 * Il ne coupe rien : la seule chose qu'il décide, ce sont les dégâts de la
 * question qu'on vient de répondre. La mesure est prise à la validation
 * (`commitBossTiming`) — pas dans la pastille qui l'affiche, et pas après l'écran
 * de correction, qui n'est plus du temps de réflexion.
 */
export function useBossTiming({
  bossMode,
  sessionId,
  idx,
  totalRef,
}: {
  bossMode: boolean;
  sessionId: string | null;
  idx: number;
  /** Le total de questions, lu en ref : l'identité de `commitBossTiming` ne doit pas bouger avec lui. */
  totalRef: { readonly current: number };
}) {
  const questionStartedAtRef = useRef<number>(0);
  const bossTimedQuestionRef = useRef<string | null>(null);
  const [bossDamage, setBossDamage] = useState(0);

  useEffect(() => {
    if (!bossMode || !sessionId) return;
    questionStartedAtRef.current = Date.now();
    bossTimedQuestionRef.current = null;
  }, [bossMode, sessionId, idx]);

  const commitBossTiming = useCallback(
    (questionId: string) => {
      if (!bossMode || bossTimedQuestionRef.current === questionId) return;
      bossTimedQuestionRef.current = questionId;
      const elapsed = (Date.now() - questionStartedAtRef.current) / 1000;
      setBossDamage((d) => d + bossDamageFor(elapsed, totalRef.current));
    },
    [bossMode, totalRef],
  );

  // La barre de HP EST le score du chronomètre : elle ne suit plus l'avancement
  // (« question 3 sur 5 », qui ne disait rien), elle suit les dégâts cumulés.
  const bossHp = useMemo(
    () => (bossMode ? bossHpForDamage(bossDamage) : 100),
    [bossMode, bossDamage],
  );
  const bossSummary = useMemo<{ hp: number; rank: BossSpeedTier } | null>(
    () => (bossMode ? { hp: bossHp, rank: bossRankForDamage(bossDamage) } : null),
    [bossMode, bossHp, bossDamage],
  );

  // Identité STABLE (aucune dépendance) : `resetRun` en dépend, et un `resetRun`
  // neuf à chaque rendu relancerait l'effet `[exerciseId, resetRun]` en boucle.
  const resetBossTiming = useCallback(() => {
    bossTimedQuestionRef.current = null;
    setBossDamage(0);
  }, []);

  return { bossHp, bossSummary, commitBossTiming, resetBossTiming };
}
