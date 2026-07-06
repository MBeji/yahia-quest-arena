import { createContext } from "react";
import type { SoundName } from "./engine";
import type { MusicMood } from "./music";

/**
 * Sound preferences — two independent, client-side toggles persisted to
 * localStorage: gameplay **sound effects** (motivating SFX, on by default) and
 * ambient **background music** (generative, off by default). Audio is a purely
 * client concern (it only plays after a user gesture), so there is no cookie and
 * no SSR involvement.
 */
export const SOUND_STORAGE_KEY = "xp-scholars-sound";
export const MUSIC_STORAGE_KEY = "xp-scholars-music";
export const DEFAULT_SOUND_ENABLED = true;
export const DEFAULT_MUSIC_ENABLED = false;

/** Parse the persisted SFX preference. Unknown/absent values fall back to on. */
export function soundEnabledFromStored(value: string | null | undefined): boolean {
  if (value === "on") return true;
  if (value === "off") return false;
  return DEFAULT_SOUND_ENABLED;
}

/** Parse the persisted music preference. Unknown/absent values fall back to off. */
export function musicEnabledFromStored(value: string | null | undefined): boolean {
  if (value === "on") return true;
  if (value === "off") return false;
  return DEFAULT_MUSIC_ENABLED;
}

export type SoundContextValue = {
  enabled: boolean;
  setEnabled: (enabled: boolean) => void;
  musicEnabled: boolean;
  setMusicEnabled: (enabled: boolean) => void;
  /** Play a named effect — a no-op when sound is disabled or unavailable. */
  play: (name: SoundName) => void;
  /** Play an escalating combo hit (pitch rises with the streak step). */
  combo: (step: number) => void;
  /** Set the mood of the ambient loop (applies only when music is enabled). */
  setMusicMood: (mood: MusicMood) => void;
};

export const SoundContext = createContext<SoundContextValue>({
  enabled: DEFAULT_SOUND_ENABLED,
  setEnabled: () => {},
  musicEnabled: DEFAULT_MUSIC_ENABLED,
  setMusicEnabled: () => {},
  play: () => {},
  combo: () => {},
  setMusicMood: () => {},
});
