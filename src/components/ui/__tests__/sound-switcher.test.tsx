import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { render, screen, fireEvent, act } from "@testing-library/react";
import { SoundSwitcher } from "@/components/ui/sound-switcher";
import { SoundProvider } from "@/lib/sound";
import { playSound } from "@/lib/sound/engine";

vi.mock("@/lib/sound/engine", () => ({
  playSound: vi.fn(),
  playCombo: vi.fn(),
  unlockAudio: vi.fn(),
  getAudioContext: () => null,
}));
vi.mock("@/lib/sound/haptics", () => ({ vibrateFor: vi.fn(), vibrate: vi.fn() }));
vi.mock("@/lib/sound/music", () => ({
  startMusic: vi.fn(),
  stopMusic: vi.fn(),
  setMusicMood: vi.fn(),
  isMusicPlaying: () => false,
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
afterEach(() => localStorage.clear());

describe("SoundSwitcher", () => {
  it("opens the menu with two toggles", () => {
    renderSwitcher();
    fireEvent.click(screen.getByRole("button", { name: "Sons" }));
    // Default (fr) labels for the two switches.
    expect(screen.getByRole("switch", { name: "Effets sonores" })).toBeInTheDocument();
    expect(screen.getByRole("switch", { name: "Musique d'ambiance" })).toBeInTheDocument();
  });

  it("reflects state: effects on, music off by default", () => {
    renderSwitcher();
    fireEvent.click(screen.getByRole("button", { name: "Sons" }));
    expect(screen.getByRole("switch", { name: "Effets sonores" })).toBeChecked();
    expect(screen.getByRole("switch", { name: "Musique d'ambiance" })).not.toBeChecked();
  });

  it("toggles effects off then on, playing a cue on re-enable", () => {
    renderSwitcher();
    fireEvent.click(screen.getByRole("button", { name: "Sons" }));
    const fx = screen.getByRole("switch", { name: "Effets sonores" });

    act(() => fireEvent.click(fx));
    expect(fx).not.toBeChecked();
    expect(playSound).not.toHaveBeenCalled();

    act(() => fireEvent.click(fx));
    expect(fx).toBeChecked();
    expect(playSound).toHaveBeenCalledWith("coin");
  });

  it("enables ambient music via its switch", () => {
    renderSwitcher();
    fireEvent.click(screen.getByRole("button", { name: "Sons" }));
    const music = screen.getByRole("switch", { name: "Musique d'ambiance" });
    act(() => fireEvent.click(music));
    expect(music).toBeChecked();
    expect(localStorage.getItem("xp-scholars-music")).toBe("on");
  });
});
