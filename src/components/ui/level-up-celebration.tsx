import { motion, AnimatePresence } from "motion/react";
import { useMemo } from "react";
import { Crown, Zap } from "lucide-react";
import { useT } from "@/lib/i18n";

interface LevelUpCelebrationProps {
  show: boolean;
  newLevel: number;
  xpGained: number;
  onComplete?: () => void;
}

function CelebrationParticles() {
  const particles = useMemo(
    () =>
      Array.from({ length: 60 }, (_, i) => ({
        id: i,
        x: Math.random() * 100,
        delay: Math.random() * 0.6,
        duration: 2 + Math.random() * 1.5,
        color: ["#a855f7", "#06b6d4", "#f59e0b", "#ec4899", "#10b981", "#6366f1"][
          Math.floor(Math.random() * 6)
        ],
        size: 4 + Math.random() * 10,
        rotation: Math.random() * 720,
      })),
    [],
  );

  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden">
      {particles.map((p) => (
        <motion.div
          key={p.id}
          className="absolute rounded-sm"
          style={{
            left: `${p.x}%`,
            top: -10,
            width: p.size,
            height: p.size,
            backgroundColor: p.color,
          }}
          initial={{ y: 0, opacity: 1, rotate: 0, scale: 1 }}
          animate={{
            y: "120vh",
            opacity: [1, 1, 0],
            rotate: p.rotation,
            scale: [1, 1.2, 0.8],
          }}
          transition={{ duration: p.duration, delay: p.delay, ease: "easeIn" }}
        />
      ))}
    </div>
  );
}

export function LevelUpCelebration({
  show,
  newLevel,
  xpGained,
  onComplete,
}: LevelUpCelebrationProps) {
  const t = useT();
  return (
    <AnimatePresence>
      {show && (
        <motion.div
          className="fixed inset-0 z-[100] flex items-center justify-center bg-[#0a0a0a]/70 backdrop-blur-sm"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.3 }}
          onClick={onComplete}
        >
          <CelebrationParticles />

          <motion.div
            className="relative z-10 flex flex-col items-center gap-4 rounded-3xl border border-[color:var(--neon-gold)]/50 bg-card/90 px-12 py-10 shadow-2xl backdrop-blur-xl"
            initial={{ scale: 0.5, opacity: 0, y: 30 }}
            animate={{ scale: 1, opacity: 1, y: 0 }}
            exit={{ scale: 0.8, opacity: 0, y: -20 }}
            transition={{ type: "spring", damping: 15, stiffness: 200, delay: 0.2 }}
          >
            <motion.div
              className="grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)] shadow-gold"
              animate={{ rotate: [0, -10, 10, -5, 5, 0], scale: [1, 1.1, 1] }}
              transition={{ duration: 0.8, delay: 0.5 }}
            >
              <Crown className="h-10 w-10 text-black" />
            </motion.div>

            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 }}
              className="text-center"
            >
              <div className="text-xs uppercase tracking-[0.3em] text-[color:var(--neon-gold)]">
                {t.levelUp.title}
              </div>
              <div className="mt-2 font-display text-5xl font-black text-gradient-gold">
                Lvl {newLevel}
              </div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.6 }}
              className="flex items-center gap-2 rounded-full bg-[color:var(--gold)]/20 px-4 py-2"
            >
              <Zap className="h-4 w-4 text-[color:var(--neon-gold)]" />
              <span className="font-display text-lg font-bold text-[color:var(--neon-gold)]">
                +{xpGained} XP
              </span>
            </motion.div>

            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.8 }}
              className="text-sm text-muted-foreground"
            >
              {t.levelUp.tapContinue}
            </motion.p>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}

interface XpFloatProps {
  amount: number;
  show: boolean;
}

export function XpFloat({ amount, show }: XpFloatProps) {
  return (
    <AnimatePresence>
      {show && (
        <motion.div
          className="pointer-events-none absolute -top-2 right-0 z-50 flex items-center gap-1 font-display text-lg font-bold text-[color:var(--neon-gold)]"
          initial={{ opacity: 1, y: 0, scale: 0.8 }}
          animate={{ opacity: 0, y: -40, scale: 1.2 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 1.5, ease: "easeOut" }}
        >
          <Zap className="h-4 w-4" />+{amount}
        </motion.div>
      )}
    </AnimatePresence>
  );
}
