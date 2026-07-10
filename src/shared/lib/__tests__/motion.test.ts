import { describe, it, expect, vi, beforeEach } from "vitest";
import { renderHook } from "@testing-library/react";
import { useReducedMotion } from "motion/react";
import { useEntrance, MOTION_PRESETS } from "@/shared/lib/motion";

vi.mock("motion/react", () => ({ useReducedMotion: vi.fn() }));
const mockedReduced = vi.mocked(useReducedMotion);

describe("useEntrance", () => {
  beforeEach(() => mockedReduced.mockReset());

  it("returns the rise preset by default with an easeOut transition", () => {
    mockedReduced.mockReturnValue(false);
    const { result } = renderHook(() => useEntrance());
    expect(result.current).toEqual({
      initial: MOTION_PRESETS.rise.initial,
      animate: MOTION_PRESETS.rise.animate,
      transition: { duration: 0.35, ease: "easeOut", delay: 0 },
    });
  });

  it("threads the preset and delay through", () => {
    mockedReduced.mockReturnValue(false);
    const { result } = renderHook(() => useEntrance("scale", 0.2));
    expect(result.current).toMatchObject({
      initial: MOTION_PRESETS.scale.initial,
      transition: { delay: 0.2 },
    });
  });

  it("neutralizes the entrance under prefers-reduced-motion", () => {
    mockedReduced.mockReturnValue(true);
    const { result } = renderHook(() => useEntrance("fade", 0.5));
    // `initial: false` renders the element directly in its final state.
    expect(result.current).toEqual({ initial: false });
  });
});
