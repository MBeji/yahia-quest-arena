import { useEffect, useState } from "react";
import { motion } from "motion/react";
import { Skull, Heart } from "lucide-react";
import { Timer } from "lucide-react";
import { BOSS_PAR_SECONDS_PER_QUESTION } from "@/shared/constants/gamification";
import { formatChrono } from "@/features/quest/boss-speed";
import { useSound } from "@/lib/sound";

/**
 * Chronomètre OUVERT du mode boss, par question. Il compte à l'endroit, sans
 * plafond, et n'a aucun rappel de fin : il ne valide rien, n'avance rien, ne
 * coupe personne. Ce qu'il fait, c'est afficher le temps qui décide des dégâts
 * (`boss-speed.ts`) — sous le temps de référence, le coup est critique ; au-delà
 * il s'atténue, jamais jusqu'à zéro.
 *
 * Il garde son propre état à 1 Hz pour que le tic-tac ne re-rende que cette
 * pastille, et pas l'arbre (large) de la page de quête. La MESURE qui note
 * réellement la réponse vit chez le parent (un `Date.now()` pris à la
 * validation) : même événement de départ — le changement de question — donc
 * aucune dérive qui compte aux paliers de 20 s et 40 s.
 */
export function BossChrono({ active, questionIndex }: { active: boolean; questionIndex: number }) {
  const [seconds, setSeconds] = useState(0);
  const { play } = useSound();
  const withinPar = seconds < BOSS_PAR_SECONDS_PER_QUESTION;

  // Un seul repère sonore par question, à l'instant où la fenêtre du coup
  // critique se referme. Ce n'est pas un compte à rebours : rien ne se passe
  // après, l'élève garde la main aussi longtemps qu'il le faut.
  useEffect(() => {
    if (active && seconds === BOSS_PAR_SECONDS_PER_QUESTION) play("tick");
  }, [active, seconds, play]);

  useEffect(() => {
    if (!active) return;
    setSeconds(0);
    const id = setInterval(() => setSeconds((s) => s + 1), 1000);
    return () => clearInterval(id);
  }, [active, questionIndex]);

  return (
    <div
      className="flex items-center gap-2 rounded-full bg-surface-3 px-3 py-1.5 text-sm font-bold"
      data-testid="boss-chrono"
    >
      <Timer className="h-4 w-4 text-[color:var(--gold)]" />
      <span className={withinPar ? "text-[color:var(--gold)]" : "text-muted-foreground"}>
        {formatChrono(seconds)}
      </span>
    </div>
  );
}

/**
 * Boss chrome: the skull header, the HP bar and the chrono, as one block.
 * Lives beside the chrono it hosts — extracted from the play loop to keep
 * that file under the max-lines cap, exactly as <QuestResultScreen> was.
 */
export function BossBanner({
  title,
  hp,
  questionIndex,
  chronoActive,
  entrance,
  reduced,
  labels,
}: {
  title: string;
  hp: number;
  questionIndex: number;
  chronoActive: boolean;
  entrance: Record<string, unknown>;
  reduced: boolean;
  labels: { fight: string; hp: string };
}) {
  return (
    <motion.div
      {...entrance}
      className="mb-6 rounded-2xl border border-destructive/40 bg-destructive/10 p-4 backdrop-blur-md"
    >
      <div className="flex items-center justify-between gap-3">
        <div className="flex min-w-0 items-center gap-3">
          <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-linear-to-br from-destructive to-gold shadow-lg animate-pulse">
            <Skull className="h-5 w-5 text-primary-foreground" />
          </div>
          <div className="min-w-0">
            <div className="text-xs uppercase tracking-[0.3em] text-destructive font-bold">
              {labels.fight}
            </div>
            <div className="truncate font-display text-lg font-bold">{title}</div>
          </div>
        </div>
        <BossChrono active={chronoActive} questionIndex={questionIndex} />
      </div>
      <div className="mt-4">
        <div className="mb-1 flex items-center justify-between text-xs">
          <span className="flex items-center gap-1 font-bold text-destructive">
            <Heart className="h-3 w-3" /> {labels.hp}
          </span>
          <span className="text-muted-foreground">{hp}%</span>
        </div>
        <div className="h-3 overflow-hidden rounded-full bg-secondary/80">
          <motion.div
            className="h-full rounded-full bg-linear-to-r from-destructive to-gold"
            initial={reduced ? false : { width: "100%" }}
            animate={{ width: `${hp}%` }}
            transition={{ duration: reduced ? 0 : 0.5 }}
          />
        </div>
      </div>
    </motion.div>
  );
}
