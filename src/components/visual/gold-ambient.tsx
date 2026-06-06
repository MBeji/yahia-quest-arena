/**
 * Lightweight CSS gold ambient backdrop for the authenticated shell. Pure CSS
 * (no WebGL) so it costs nothing during timed quests / dungeon runs and stays
 * 60fps everywhere. Sits behind all content, non-interactive.
 */
export function GoldAmbient() {
  return (
    <div aria-hidden className="pointer-events-none fixed inset-0 z-0 overflow-hidden">
      <div className="absolute inset-0 bg-gold-grid opacity-50" />
      <div className="animate-float absolute -left-32 top-[-10%] h-[34rem] w-[34rem] rounded-full bg-[radial-gradient(circle,oklch(0.83_0.15_86/0.12),transparent_65%)] blur-3xl" />
      <div className="animate-float absolute -right-40 top-1/3 h-[30rem] w-[30rem] rounded-full bg-[radial-gradient(circle,oklch(0.92_0.12_96/0.10),transparent_65%)] blur-3xl [animation-delay:-3s]" />
      <div className="absolute bottom-[-15%] left-1/2 h-[28rem] w-[28rem] -translate-x-1/2 rounded-full bg-[radial-gradient(circle,oklch(0.66_0.13_70/0.10),transparent_70%)] blur-3xl" />
    </div>
  );
}
