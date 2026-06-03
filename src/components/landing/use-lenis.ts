import { useEffect } from "react";
import Lenis from "lenis";

/**
 * Smooth inertial scrolling (Lenis) for the landing page. Disabled when
 * `enabled` is false (reduced motion / mobile) so accessibility and touch
 * scrolling are preserved. Anchor links (#features…) still work — Lenis hijacks
 * the wheel/scroll, native anchor jumps remain functional.
 */
export function useLenis(enabled: boolean) {
  useEffect(() => {
    if (!enabled || typeof window === "undefined") return;

    const lenis = new Lenis({
      duration: 1.1,
      smoothWheel: true,
      wheelMultiplier: 1,
      touchMultiplier: 1.5,
    });
    let raf = 0;
    const loop = (time: number) => {
      lenis.raf(time);
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);

    return () => {
      cancelAnimationFrame(raf);
      lenis.destroy();
    };
  }, [enabled]);
}
