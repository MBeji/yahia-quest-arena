import { useCallback, useEffect, useState } from "react";
import {
  DEFAULT_SOUND_ENABLED,
  SOUND_STORAGE_KEY,
  SoundContext,
  soundEnabledFromStored,
} from "./context";
import { playSound, unlockAudio, type SoundName } from "./engine";

function getInitialEnabled(): boolean {
  if (typeof window === "undefined") return DEFAULT_SOUND_ENABLED;
  try {
    return soundEnabledFromStored(localStorage.getItem(SOUND_STORAGE_KEY));
  } catch {
    return DEFAULT_SOUND_ENABLED;
  }
}

export function SoundProvider({ children }: { children: React.ReactNode }) {
  // Start at the default so the first client render matches SSR; the persisted
  // preference is applied post-mount (this only gates client-only audio, so there
  // is nothing visual to flash).
  const [enabled, setEnabledState] = useState<boolean>(DEFAULT_SOUND_ENABLED);

  useEffect(() => {
    setEnabledState(getInitialEnabled());
  }, []);

  // Browsers start the AudioContext suspended until a user gesture. Prime it on
  // the first interaction so the earliest in-game effect is actually audible.
  useEffect(() => {
    if (!enabled) return;
    const unlock = () => unlockAudio();
    window.addEventListener("pointerdown", unlock, { once: true });
    window.addEventListener("keydown", unlock, { once: true });
    return () => {
      window.removeEventListener("pointerdown", unlock);
      window.removeEventListener("keydown", unlock);
    };
  }, [enabled]);

  const setEnabled = useCallback((next: boolean) => {
    setEnabledState(next);
    try {
      localStorage.setItem(SOUND_STORAGE_KEY, next ? "on" : "off");
    } catch {
      // Private-mode / disabled storage: keep the in-memory preference.
    }
    if (next) unlockAudio();
  }, []);

  const play = useCallback(
    (name: SoundName) => {
      if (!enabled) return;
      playSound(name);
    },
    [enabled],
  );

  return (
    <SoundContext.Provider value={{ enabled, setEnabled, play }}>{children}</SoundContext.Provider>
  );
}
