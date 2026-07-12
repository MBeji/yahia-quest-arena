// Public API barrel for gameplay sound effects — import from "@/lib/sound"
export { SoundProvider } from "./provider";
export { useSound } from "./hooks";
export {
  DEFAULT_SOUND_ENABLED,
  DEFAULT_MUSIC_ENABLED,
  SOUND_STORAGE_KEY,
  MUSIC_STORAGE_KEY,
  soundEnabledFromStored,
  musicEnabledFromStored,
  type SoundContextValue,
} from "./context";
export { playSound, playCombo, unlockAudio, getAudioContext, type SoundName } from "./engine";
export { vibrate, vibrateFor } from "./haptics";
export { encouragementFor, type Encouragement, type EncouragementTier } from "./encouragement";
export { startMusic, stopMusic, setMusicMood, isMusicPlaying, type MusicMood } from "./music";
