import { createContext } from "react";
import type { SoundName } from "./engine";

/**
 * Sound-effects preference — a single client-side toggle (motivating gameplay SFX
 * on/off), persisted to localStorage. Unlike the theme/locale, sound is a purely
 * client concern (audio only plays after a user gesture), so there is no cookie and
 * no SSR involvement.
 */
export const SOUND_STORAGE_KEY = "xp-scholars-sound";
export const DEFAULT_SOUND_ENABLED = true;

/** Parse the persisted preference. Unknown/absent values fall back to the default. */
export function soundEnabledFromStored(value: string | null | undefined): boolean {
  if (value === "on") return true;
  if (value === "off") return false;
  return DEFAULT_SOUND_ENABLED;
}

export type SoundContextValue = {
  enabled: boolean;
  setEnabled: (enabled: boolean) => void;
  /** Play a named effect — a no-op when sound is disabled or unavailable. */
  play: (name: SoundName) => void;
};

export const SoundContext = createContext<SoundContextValue>({
  enabled: DEFAULT_SOUND_ENABLED,
  setEnabled: () => {},
  play: () => {},
});
