import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {
  LATE_SOUND_MAX_MS,
  __resetLazyAudioForTests,
  audioIfLoaded,
  loadAudio,
  withAudio,
} from "../lazy";
import { playSound as facadePlaySound } from "../facade";
import { playSound } from "../engine";

vi.mock("../engine", () => ({
  playSound: vi.fn(),
  playCombo: vi.fn(),
  unlockAudio: vi.fn(),
}));
vi.mock("../music", () => ({
  startMusic: vi.fn(),
  stopMusic: vi.fn(),
  setMusicMood: vi.fn(),
}));

beforeEach(() => {
  __resetLazyAudioForTests();
  vi.mocked(playSound).mockClear();
});

afterEach(() => vi.restoreAllMocks());

describe("chargement différé du moteur audio", () => {
  it("n'est pas chargé tant que personne ne le demande", () => {
    expect(audioIfLoaded()).toBeNull();
  });

  it("se charge une seule fois, et reste disponible ensuite", async () => {
    const first = loadAudio();
    expect(loadAudio()).toBe(first);
    const audio = await first;
    expect(audioIfLoaded()).toBe(audio);
  });

  it("exécute à l'arrivée du moteur, puis de façon synchrone", async () => {
    const run = vi.fn();
    withAudio(run);
    expect(run).not.toHaveBeenCalled();
    await loadAudio();
    await Promise.resolve();
    expect(run).toHaveBeenCalledTimes(1);

    withAudio(run);
    expect(run).toHaveBeenCalledTimes(2);
  });

  it("abandonne un effet si le moteur arrive trop tard pour le geste", async () => {
    const now = vi.spyOn(Date, "now").mockReturnValue(1_000);
    const late = vi.fn();
    const unbounded = vi.fn();
    withAudio(late, LATE_SOUND_MAX_MS);
    withAudio(unbounded);
    now.mockReturnValue(1_000 + LATE_SOUND_MAX_MS + 1);
    await loadAudio();
    await Promise.resolve();
    expect(late).not.toHaveBeenCalled();
    expect(unbounded).toHaveBeenCalledTimes(1);
  });

  it("la façade `playSound` du barrel passe par le chargement différé", async () => {
    facadePlaySound("coin");
    expect(playSound).not.toHaveBeenCalled();
    await vi.waitFor(() => expect(playSound).toHaveBeenCalledWith("coin"));
  });
});
