import React from "react";
import { motion } from "motion/react";
import { useEntrance } from "@/shared/lib/motion";

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
  // One TrackRow = one component instance, so the hook carries the stagger delay.
  const riseIn = useEntrance("rise", Math.min(index * 0.06, 0.6));
  return (
    <motion.div
      {...riseIn}
      className={`flex px-3 sm:px-0 ${side === "left" ? "justify-start sm:ps-6" : "justify-end sm:pe-6"}`}
    >
      {children}
    </motion.div>
  );
}
