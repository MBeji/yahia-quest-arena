import React from "react";
import { motion } from "motion/react";

/**
 * Winding "drawn path" container: a central glowing line with rows stacked in a
 * zigzag (each TrackRow positions its node left/right). Pure layout.
 */
export function JourneyTrack({ children }: { children: React.ReactNode }) {
  return (
    <div className="relative mx-auto mt-8 max-w-2xl">
      <div
        aria-hidden
        className="absolute inset-y-0 left-1/2 w-1 -translate-x-1/2 rounded-full bg-[linear-gradient(to_bottom,transparent,var(--gold),transparent)] opacity-40"
      />
      <div className="relative space-y-10 py-2">{children}</div>
    </div>
  );
}

/** One row of the zigzag: reveals on mount and pushes its node to one side. */
export function TrackRow({
  side,
  index,
  children,
}: {
  side: "left" | "right";
  index: number;
  children: React.ReactNode;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: Math.min(index * 0.06, 0.6) }}
      className={`flex px-3 sm:px-0 ${side === "left" ? "justify-start sm:pl-6" : "justify-end sm:pr-6"}`}
    >
      {children}
    </motion.div>
  );
}
