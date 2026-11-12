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
import type { SoundName } from "./engine";
import { vibrateFor } from "./haptics";
import { LATE_SOUND_MAX_MS, audioIfLoaded, withAudio } from "./lazy";
import type { MusicMood } from "./music";

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
  //
  // Le moteur n'est pas dans le bundle d'entrée (`lazy.ts`) : le PREMIER geste le fait
  // venir et le déverrouille à son arrivée — Chromium et Firefox l'acceptent tant que
  // l'activation du geste court encore. Safari exige que `resume()` parte DANS le
  // geste : l'écouteur reste donc posé jusqu'au premier geste où le moteur est déjà
  // là, et c'est celui-là qui le retire.
  useEffect(() => {
    if (!enabled && !musicEnabled) return;
    const stop = () => {
      window.removeEventListener("pointerdown", unlock);
      window.removeEventListener("keydown", unlock);
    };
    function unlock() {
      const audio = audioIfLoaded();
      if (!audio) {
        withAudio((loaded) => loaded.unlockAudio());
        return;
      }
      audio.unlockAudio();
      stop();
    }
    window.addEventListener("pointerdown", unlock);
    window.addEventListener("keydown", unlock);
    return stop;
  }, [enabled, musicEnabled]);

  // Start/stop the ambient loop as the music preference changes. Stopped on unmount.
  // Musique éteinte (le défaut) : rien à arrêter tant que le moteur n'est pas chargé.
  useEffect(() => {
    if (!musicEnabled) {
      audioIfLoaded()?.stopMusic();
      return;
    }
    let cancelled = false;
    withAudio((audio) => {
      if (!cancelled) audio.startMusic();
    });
    return () => {
      cancelled = true;
      audioIfLoaded()?.stopMusic();
    };
  }, [musicEnabled]);

  const setEnabled = useCallback((next: boolean) => {
    setEnabledState(next);
    try {
      localStorage.setItem(SOUND_STORAGE_KEY, next ? "on" : "off");
    } catch {
      // Private-mode / disabled storage: keep the in-memory preference.
    }
    if (next) withAudio((audio) => audio.unlockAudio());
  }, []);

  const setMusicEnabled = useCallback((next: boolean) => {
    setMusicEnabledState(next);
    try {
      localStorage.setItem(MUSIC_STORAGE_KEY, next ? "on" : "off");
    } catch {
      // Private-mode / disabled storage.
    }
    if (next) withAudio((audio) => audio.unlockAudio());
  }, []);

  const play = useCallback(
    (name: SoundName) => {
      if (!enabled) return;
      withAudio((audio) => audio.playSound(name), LATE_SOUND_MAX_MS);
      vibrateFor(name);
    },
    [enabled],
  );

  const combo = useCallback(
    (step: number) => {
      if (!enabled) return;
      withAudio((audio) => audio.playCombo(step), LATE_SOUND_MAX_MS);
    },
    [enabled],
  );

  const setMusicMood = useCallback(
    (mood: MusicMood) => {
      if (musicEnabled) withAudio((audio) => audio.setMusicMood(mood));
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
