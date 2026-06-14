import { render, screen, act } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach, afterEach } from "vitest";
import React from "react";
import { BossCountdown } from "@/features/quest/components/boss-countdown";

vi.mock("@/shared/constants/gamification", () => ({
  BOSS_TIME_PER_QUESTION_S: 10,
}));

// lucide-react icons are not needed for logic tests
vi.mock("lucide-react", () => ({
  Timer: () => React.createElement("span", { "data-testid": "timer-icon" }),
}));

describe("BossCountdown", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("shows the initial countdown value when active", () => {
    const onTimeout = vi.fn();
    render(React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout }));
    expect(screen.getByText("10s")).toBeInTheDocument();
  });

  it("does not start the timer when inactive", () => {
    const onTimeout = vi.fn();
    render(React.createElement(BossCountdown, { active: false, questionIndex: 0, onTimeout }));
    act(() => {
      vi.advanceTimersByTime(5000);
    });
    // still shows initial value — timer never started
    expect(screen.getByText("10s")).toBeInTheDocument();
    expect(onTimeout).not.toHaveBeenCalled();
  });

  it("counts down once per second when active", () => {
    const onTimeout = vi.fn();
    render(React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout }));
    act(() => {
      vi.advanceTimersByTime(3000);
    });
    expect(screen.getByText("7s")).toBeInTheDocument();
    expect(onTimeout).not.toHaveBeenCalled();
  });

  it("fires onTimeout and resets when the counter reaches zero", () => {
    const onTimeout = vi.fn();
    render(React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout }));
    act(() => {
      vi.advanceTimersByTime(10000); // 10 ticks → fires at tick 10 (s goes 10→9→…→1, fires)
    });
    expect(onTimeout).toHaveBeenCalledTimes(1);
    // resets back to 10 after firing
    expect(screen.getByText("10s")).toBeInTheDocument();
  });

  it("applies warning style when 5 or fewer seconds remain", () => {
    const onTimeout = vi.fn();
    render(React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout }));
    act(() => {
      vi.advanceTimersByTime(5000); // 10 → 5
    });
    const span = screen.getByText("5s");
    expect(span.className).toContain("text-destructive");
    expect(span.className).toContain("animate-pulse");
  });

  it("uses normal (gold) style above 5 seconds", () => {
    const onTimeout = vi.fn();
    render(React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout }));
    act(() => {
      vi.advanceTimersByTime(3000); // 10 → 7
    });
    const span = screen.getByText("7s");
    expect(span.className).not.toContain("text-destructive");
    expect(span.className).toContain("--gold");
  });

  it("resets and restarts when questionIndex changes", () => {
    const onTimeout = vi.fn();
    const { rerender } = render(
      React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout }),
    );
    act(() => {
      vi.advanceTimersByTime(6000); // 10 → 4
    });
    expect(screen.getByText("4s")).toBeInTheDocument();

    // Advance to next question — countdown should reset to 10
    rerender(React.createElement(BossCountdown, { active: true, questionIndex: 1, onTimeout }));
    expect(screen.getByText("10s")).toBeInTheDocument();

    act(() => {
      vi.advanceTimersByTime(2000);
    });
    expect(screen.getByText("8s")).toBeInTheDocument();
  });

  it("stops the timer when active transitions to false", () => {
    const onTimeout = vi.fn();
    const { rerender } = render(
      React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout }),
    );
    act(() => {
      vi.advanceTimersByTime(3000); // 10 → 7
    });

    rerender(React.createElement(BossCountdown, { active: false, questionIndex: 0, onTimeout }));
    act(() => {
      vi.advanceTimersByTime(5000); // timer stopped — value should not change
    });
    expect(screen.getByText("7s")).toBeInTheDocument();
    expect(onTimeout).not.toHaveBeenCalled();
  });

  it("uses the latest onTimeout callback without restarting the interval", () => {
    const first = vi.fn();
    const second = vi.fn();
    const { rerender } = render(
      React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout: first }),
    );
    act(() => {
      vi.advanceTimersByTime(5000); // 10 → 5 — no timeout yet
    });

    // Swap callback mid-countdown — should NOT restart the interval
    rerender(
      React.createElement(BossCountdown, { active: true, questionIndex: 0, onTimeout: second }),
    );
    act(() => {
      vi.advanceTimersByTime(5000); // 5 → fires timeout
    });
    expect(first).not.toHaveBeenCalled();
    expect(second).toHaveBeenCalledTimes(1);
  });
});
