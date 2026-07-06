// Public API barrel for gameplay sound effects — import from "@/lib/sound"
export { SoundProvider } from "./provider";
export { useSound } from "./hooks";
export {
  DEFAULT_SOUND_ENABLED,
  SOUND_STORAGE_KEY,
  soundEnabledFromStored,
  type SoundContextValue,
} from "./context";
export { playSound, unlockAudio, type SoundName } from "./engine";
