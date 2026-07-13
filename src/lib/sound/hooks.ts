import { useContext } from "react";
import { SoundContext } from "./context";

/** Access the sound preference + `play` dispatcher from the SoundProvider. */
export function useSound() {
  return useContext(SoundContext);
}
