import { useCallback, useEffect, useState } from "react";
import {
  DEFAULT_MUSIC_ENABLED,
  DEFAULT_SOUND_ENABLED,
  MUSIC_STORAGE_KEY,
  SOUND_STORAGE_KEY,
  SoundContext,
  musicEnabledFromStored,
  soundEnabledFromStored,
} from "./context";
import { playCombo, playSound, unlockAudio, type SoundName } from "./engine";
import { vibrateFor } from "./haptics";
import { setMusicMood as engineSetMusicMood, startMusic, stopMusic, type MusicMood } from "./music";

function readPref(key: string, parse: (v: string | null) => boolean, fallback: boolean): boolean {
  if (typeof window === "undefined") return fallback;
  try {
    return parse(localStorage.getItem(key));
  } catch {
    return fallback;
  }
}

export function SoundProvider({ children }: { children: React.ReactNode }) {
  // Start at the defaults so the first client render matches SSR; the persisted
  // preferences are applied post-mount (audio is client-only — nothing to flash).
  const [enabled, setEnabledState] = useState<boolean>(DEFAULT_SOUND_ENABLED);
  const [musicEnabled, setMusicEnabledState] = useState<boolean>(DEFAULT_MUSIC_ENABLED);

  useEffect(() => {
    setEnabledState(readPref(SOUND_STORAGE_KEY, soundEnabledFromStored, DEFAULT_SOUND_ENABLED));
    setMusicEnabledState(
      readPref(MUSIC_STORAGE_KEY, musicEnabledFromStored, DEFAULT_MUSIC_ENABLED),
    );
  }, []);

  // Browsers start the AudioContext suspended until a user gesture. Prime it on
  // the first interaction so the earliest in-game effect is actually audible.
  useEffect(() => {
    if (!enabled && !musicEnabled) return;
    const unlock = () => unlockAudio();
    window.addEventListener("pointerdown", unlock, { once: true });
    window.addEventListener("keydown", unlock, { once: true });
    return () => {
      window.removeEventListener("pointerdown", unlock);
      window.removeEventListener("keydown", unlock);
    };
  }, [enabled, musicEnabled]);

  // Start/stop the ambient loop as the music preference changes. Stopped on unmount.
  useEffect(() => {
    if (musicEnabled) startMusic();
    else stopMusic();
    return () => stopMusic();
  }, [musicEnabled]);

  const setEnabled = useCallback((next: boolean) => {
    setEnabledState(next);
    try {
      localStorage.setItem(SOUND_STORAGE_KEY, next ? "on" : "off");
    } catch {
      // Private-mode / disabled storage: keep the in-memory preference.
    }
    if (next) unlockAudio();
  }, []);

  const setMusicEnabled = useCallback((next: boolean) => {
    setMusicEnabledState(next);
    try {
      localStorage.setItem(MUSIC_STORAGE_KEY, next ? "on" : "off");
    } catch {
      // Private-mode / disabled storage.
    }
    if (next) unlockAudio();
  }, []);

  const play = useCallback(
    (name: SoundName) => {
      if (!enabled) return;
      playSound(name);
      vibrateFor(name);
    },
    [enabled],
  );

  const combo = useCallback(
    (step: number) => {
      if (!enabled) return;
      playCombo(step);
    },
    [enabled],
  );

  const setMusicMood = useCallback(
    (mood: MusicMood) => {
      if (musicEnabled) engineSetMusicMood(mood);
    },
    [musicEnabled],
  );

  return (
    <SoundContext.Provider
      value={{ enabled, setEnabled, musicEnabled, setMusicEnabled, play, combo, setMusicMood }}
    >
      {children}
    </SoundContext.Provider>
  );
}
