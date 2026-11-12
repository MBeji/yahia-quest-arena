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
import { __resetLazyAudioForTests, audioIfLoaded, loadAudio } from "../lazy";

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
  __resetLazyAudioForTests();
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

  it("ne charge pas le moteur audio au montage : aucun son ne peut partir avant un geste", async () => {
    renderProvider();
    await Promise.resolve();
    expect(audioIfLoaded()).toBeNull();
  });

  it("plays effects AND fires haptics when enabled", async () => {
    renderProvider();
    fireEvent.click(screen.getByText("play"));
    // Le retour haptique ne dépend pas du moteur : il part dans le geste.
    expect(vibrateFor).toHaveBeenCalledWith("victory");
    await vi.waitFor(() => expect(playSound).toHaveBeenCalledWith("victory"));
  });

  it("plays escalating combos when enabled", async () => {
    renderProvider();
    fireEvent.click(screen.getByText("combo"));
    await vi.waitFor(() => expect(playCombo).toHaveBeenCalledWith(5));
  });

  it("joue dans le geste, sans attendre, une fois le moteur chargé", async () => {
    renderProvider();
    await loadAudio();
    fireEvent.click(screen.getByText("play"));
    expect(playSound).toHaveBeenCalledWith("victory");
  });

  it("does not play effects or combos when disabled", async () => {
    renderProvider();
    act(() => fireEvent.click(screen.getByText("fx-off")));
    fireEvent.click(screen.getByText("play"));
    fireEvent.click(screen.getByText("combo"));
    await loadAudio();
    expect(playSound).not.toHaveBeenCalled();
    expect(playCombo).not.toHaveBeenCalled();
    expect(vibrateFor).not.toHaveBeenCalled();
  });

  it("le premier geste fait venir le moteur et le déverrouille ; le suivant déverrouille DANS le geste puis se retire", async () => {
    renderProvider();
    fireEvent.pointerDown(window);
    expect(unlockAudio).not.toHaveBeenCalled();
    await vi.waitFor(() => expect(unlockAudio).toHaveBeenCalledTimes(1));

    fireEvent.pointerDown(window);
    expect(unlockAudio).toHaveBeenCalledTimes(2);

    fireEvent.pointerDown(window);
    fireEvent.keyDown(window);
    expect(unlockAudio).toHaveBeenCalledTimes(2);
  });

  it("persists both preferences to localStorage", () => {
    renderProvider();
    act(() => fireEvent.click(screen.getByText("fx-off")));
    expect(localStorage.getItem(SOUND_STORAGE_KEY)).toBe("off");
    act(() => fireEvent.click(screen.getByText("music-on")));
    expect(localStorage.getItem(MUSIC_STORAGE_KEY)).toBe("on");
  });

  it("starts the ambient loop when music is enabled and stops it when disabled", async () => {
    renderProvider();
    act(() => fireEvent.click(screen.getByText("music-on")));
    await vi.waitFor(() => expect(startMusic).toHaveBeenCalled());
    act(() => fireEvent.click(screen.getByText("music-off")));
    expect(stopMusic).toHaveBeenCalled();
  });

  it("ne démarre pas la musique si elle a été coupée avant l'arrivée du moteur", async () => {
    renderProvider();
    act(() => fireEvent.click(screen.getByText("music-on")));
    act(() => fireEvent.click(screen.getByText("music-off")));
    await loadAudio();
    expect(startMusic).not.toHaveBeenCalled();
  });
});
