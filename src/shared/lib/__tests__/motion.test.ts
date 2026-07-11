import { describe, it, expect, vi, beforeEach } from "vitest";
import { renderHook } from "@testing-library/react";
import { useReducedMotion } from "motion/react";
import { entrance, questionSlide, useEntrance, MOTION_PRESETS } from "@/shared/lib/motion";

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

  it("entrance (non-hook, staggered lists) mirrors the hook behaviour", () => {
    expect(entrance(false, "rise", 0.1)).toEqual({
      initial: MOTION_PRESETS.rise.initial,
      animate: MOTION_PRESETS.rise.animate,
      transition: { duration: 0.35, ease: "easeOut", delay: 0.1 },
    });
    expect(entrance(true, "rise", 0.1)).toEqual({ initial: false });
  });

  it("neutralizes the entrance under prefers-reduced-motion", () => {
    mockedReduced.mockReturnValue(true);
    const { result } = renderHook(() => useEntrance("fade", 0.5));
    // `initial: false` renders the element directly in its final state.
    expect(result.current).toEqual({ initial: false });
  });
});

describe("questionSlide", () => {
  it("slides the incoming question in and the outgoing one out", () => {
    expect(questionSlide(false)).toEqual({
      initial: { opacity: 0, x: 30 },
      animate: { opacity: 1, x: 0 },
      exit: { opacity: 0, x: -30 },
      transition: { duration: 0.3 },
    });
  });

  it("renders in place (no exit prop) under prefers-reduced-motion", () => {
    expect(questionSlide(true)).toEqual({ initial: false });
  });
});
