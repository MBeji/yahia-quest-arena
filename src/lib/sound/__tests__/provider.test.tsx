import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { render, screen, fireEvent, act } from "@testing-library/react";
import { SoundProvider } from "../provider";
import { useSound } from "../hooks";
import {
  SOUND_STORAGE_KEY,
  MUSIC_STORAGE_KEY,
  soundEnabledFromStored,
  musicEnabledFromStored,
  DEFAULT_SOUND_ENABLED,
  DEFAULT_MUSIC_ENABLED,
} from "../context";
import { playSound, playCombo, unlockAudio } from "../engine";
import { vibrateFor } from "../haptics";
import { startMusic, stopMusic } from "../music";

vi.mock("../engine", () => ({
  playSound: vi.fn(),
  playCombo: vi.fn(),
  unlockAudio: vi.fn(),
}));
vi.mock("../haptics", () => ({ vibrateFor: vi.fn() }));
vi.mock("../music", () => ({
  startMusic: vi.fn(),
  stopMusic: vi.fn(),
  setMusicMood: vi.fn(),
}));

function Consumer() {
  const { enabled, musicEnabled, setEnabled, setMusicEnabled, play, combo } = useSound();
  return (
    <div>
      <span data-testid="enabled">{enabled ? "on" : "off"}</span>
      <span data-testid="music">{musicEnabled ? "on" : "off"}</span>
      <button onClick={() => play("victory")}>play</button>
      <button onClick={() => combo(5)}>combo</button>
      <button onClick={() => setEnabled(false)}>fx-off</button>
      <button onClick={() => setEnabled(true)}>fx-on</button>
      <button onClick={() => setMusicEnabled(true)}>music-on</button>
      <button onClick={() => setMusicEnabled(false)}>music-off</button>
    </div>
  );
}

function renderProvider() {
  return render(
    <SoundProvider>
      <Consumer />
    </SoundProvider>,
  );
}

beforeEach(() => {
  localStorage.clear();
  vi.mocked(playSound).mockClear();
  vi.mocked(playCombo).mockClear();
  vi.mocked(unlockAudio).mockClear();
  vi.mocked(vibrateFor).mockClear();
  vi.mocked(startMusic).mockClear();
  vi.mocked(stopMusic).mockClear();
});

afterEach(() => localStorage.clear());

describe("preference parsers", () => {
  it("parse SFX preference with an on-by-default fallback", () => {
    expect(soundEnabledFromStored("on")).toBe(true);
    expect(soundEnabledFromStored("off")).toBe(false);
    expect(soundEnabledFromStored(null)).toBe(DEFAULT_SOUND_ENABLED);
  });

  it("parse music preference with an off-by-default fallback", () => {
    expect(musicEnabledFromStored("on")).toBe(true);
    expect(musicEnabledFromStored("off")).toBe(false);
    expect(musicEnabledFromStored(null)).toBe(DEFAULT_MUSIC_ENABLED);
    expect(musicEnabledFromStored("garbage")).toBe(DEFAULT_MUSIC_ENABLED);
  });
});

describe("SoundProvider", () => {
  it("defaults: effects on, music off", () => {
    renderProvider();
    expect(screen.getByTestId("enabled")).toHaveTextContent("on");
    expect(screen.getByTestId("music")).toHaveTextContent("off");
  });

  it("applies persisted preferences on mount", () => {
    localStorage.setItem(SOUND_STORAGE_KEY, "off");
    localStorage.setItem(MUSIC_STORAGE_KEY, "on");
    renderProvider();
    expect(screen.getByTestId("enabled")).toHaveTextContent("off");
    expect(screen.getByTestId("music")).toHaveTextContent("on");
  });

  it("plays effects AND fires haptics when enabled", () => {
    renderProvider();
    fireEvent.click(screen.getByText("play"));
    expect(playSound).toHaveBeenCalledWith("victory");
    expect(vibrateFor).toHaveBeenCalledWith("victory");
  });

  it("plays escalating combos when enabled", () => {
    renderProvider();
    fireEvent.click(screen.getByText("combo"));
    expect(playCombo).toHaveBeenCalledWith(5);
  });

  it("does not play effects or combos when disabled", () => {
    renderProvider();
    act(() => fireEvent.click(screen.getByText("fx-off")));
    vi.mocked(playSound).mockClear();
    vi.mocked(playCombo).mockClear();
    fireEvent.click(screen.getByText("play"));
    fireEvent.click(screen.getByText("combo"));
    expect(playSound).not.toHaveBeenCalled();
    expect(playCombo).not.toHaveBeenCalled();
  });

  it("persists both preferences to localStorage", () => {
    renderProvider();
    act(() => fireEvent.click(screen.getByText("fx-off")));
    expect(localStorage.getItem(SOUND_STORAGE_KEY)).toBe("off");
    act(() => fireEvent.click(screen.getByText("music-on")));
    expect(localStorage.getItem(MUSIC_STORAGE_KEY)).toBe("on");
  });

  it("starts the ambient loop when music is enabled and stops it when disabled", () => {
    renderProvider();
    act(() => fireEvent.click(screen.getByText("music-on")));
    expect(startMusic).toHaveBeenCalled();
    act(() => fireEvent.click(screen.getByText("music-off")));
    expect(stopMusic).toHaveBeenCalled();
  });
});
