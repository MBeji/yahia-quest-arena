import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { SealMark } from "@/components/game/seal-mark";
import type { StarTier } from "@/shared/lib/progress-stars";

/**
 * LE SCEAU D'UNE MATIÈRE, célébré (étude 34, R-12 · US-3).
 *
 * Jumeau de `level-up-celebration`, avec trois différences assumées :
 *
 *  1. **Il respecte `prefers-reduced-motion`.** Son aîné ne le fait pas — 60
 *     particules tombent quoi qu'il arrive. Ici, le mouvement réduit garde la
 *     modale et son cachet, et supprime les particules : ce qui compte est
 *     l'attestation, pas l'animation, et un élève qui a demandé moins de
 *     mouvement ne doit pas payer sa reconnaissance en vertige.
 *  2. **Elle n'enchaîne RIEN** (é31 R-6). Un tap ferme, et rend la main à
 *     l'écran de résultat. Une modale qui propose « continuer » transforme un
 *     sommet en tapis roulant.
 *  3. **Une seule par résultat** (R-12). Une matière maîtrisée d'un coup inscrit
 *     les quatre sceaux dans la même transaction ; `sealToCelebrate` n'en garde
 *     que le plus haut, et c'est lui seul qui arrive ici.
 *
 * Aucune XP, aucune pièce (R-11, D-10) : la modale atteste, elle ne paie pas.
 * Le son est joué par l'appelant, comme pour le level-up.
 */
export function SealCelebration({
  show,
  star,
  subjectName,
  title,
  body,
  hint,
  onComplete,
}: {
  show: boolean;
  star: StarTier;
  subjectName: string;
  /** « Sceau ⭐⭐⭐ » — déjà composé par l'appelant, qui tient le catalogue i18n. */
  title: string;
  body: string;
  hint: string;
  onComplete?: () => void;
}) {
  const reduced = useReducedMotion();

  return (
    <AnimatePresence>
      {show && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.3 }}
          className="fixed inset-0 z-[100] grid place-items-center bg-[#0a0a0a]/70 p-6 backdrop-blur-sm"
          role="dialog"
          aria-modal="true"
          aria-label={title}
          data-testid="seal-celebration"
          onClick={onComplete}
        >
          {!reduced && <SealSparks />}
          <motion.div
            initial={reduced ? { opacity: 0 } : { scale: 0.7, opacity: 0 }}
            animate={reduced ? { opacity: 1 } : { scale: 1, opacity: 1 }}
            transition={
              reduced
                ? { duration: 0.2 }
                : { type: "spring", damping: 15, stiffness: 200, delay: 0.2 }
            }
            className="relative max-w-sm rounded-2xl border border-(--gold)/50 bg-card p-6 text-center shadow-2xl"
          >
            <div className="flex justify-center">
              <SealMark star={star} earned size="md" label={title} />
            </div>
            <h2 className="mt-3 font-display text-xl font-bold text-(--gold)">{title}</h2>
            <p
              className="mt-1 font-display text-base font-bold"
              data-testid="seal-celebration-subject"
            >
              {subjectName}
            </p>
            <p className="mt-2 text-sm text-muted-foreground">{body}</p>
            <p className="mt-4 text-xs text-muted-foreground/90">{hint}</p>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}

/**
 * Quelques étincelles dorées, et pas une pluie : un sceau n'est pas un niveau, et
 * la retenue visuelle est ce qui le distingue. Jamais rendues en mouvement réduit.
 */
function SealSparks() {
  const sparks = Array.from({ length: 18 }, (_, i) => ({
    id: i,
    x: (i * 37) % 100,
    delay: (i % 6) * 0.12,
    size: 4 + (i % 3) * 2,
  }));
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden" aria-hidden>
      {sparks.map((s) => (
        <motion.span
          key={s.id}
          initial={{ opacity: 0, y: "60vh", x: `${s.x}vw` }}
          animate={{ opacity: [0, 1, 0], y: "20vh" }}
          transition={{ duration: 1.6, delay: s.delay, ease: "easeOut" }}
          className="absolute rounded-full bg-(--gold)"
          style={{ width: s.size, height: s.size }}
        />
      ))}
    </div>
  );
}
