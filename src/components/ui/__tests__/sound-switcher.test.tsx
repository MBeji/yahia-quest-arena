import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { render, screen, fireEvent, act } from "@testing-library/react";
import { SoundSwitcher } from "@/components/ui/sound-switcher";
import { SoundProvider } from "@/lib/sound";
import { playSound } from "@/lib/sound/engine";

vi.mock("@/lib/sound/engine", () => ({
  playSound: vi.fn(),
  unlockAudio: vi.fn(),
}));

function renderSwitcher() {
  return render(
    <SoundProvider>
      <SoundSwitcher />
    </SoundProvider>,
  );
}

beforeEach(() => {
  localStorage.clear();
  vi.mocked(playSound).mockClear();
});

afterEach(() => {
  localStorage.clear();
});

describe("SoundSwitcher", () => {
  it("reflects the enabled state via aria-pressed and label", () => {
    renderSwitcher();
    const button = screen.getByRole("button");
    expect(button).toHaveAttribute("aria-pressed", "true");
    // Default (fr) label to mute when currently enabled.
    expect(button).toHaveAttribute("aria-label", "Couper les sons");
  });

  it("toggles the preference and plays a confirmation cue when turning on", () => {
    renderSwitcher();
    const button = screen.getByRole("button");

    // Turn off.
    act(() => fireEvent.click(button));
    expect(button).toHaveAttribute("aria-pressed", "false");
    expect(button).toHaveAttribute("aria-label", "Activer les sons");

    // Turn back on -> plays the coin confirmation.
    act(() => fireEvent.click(button));
    expect(button).toHaveAttribute("aria-pressed", "true");
    expect(playSound).toHaveBeenCalledWith("coin");
  });

  it("does not play a cue when turning sound off", () => {
    renderSwitcher();
    act(() => fireEvent.click(screen.getByRole("button")));
    expect(playSound).not.toHaveBeenCalled();
  });
});
