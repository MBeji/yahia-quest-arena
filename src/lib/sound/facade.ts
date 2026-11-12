import type { SoundName } from "./engine";
import { LATE_SOUND_MAX_MS, withAudio } from "./lazy";

/**
 * Jouer un effet hors du `SoundProvider` (l'aperçu du réglage « effets sonores »).
 * Passe par le chargement différé : importer le moteur ici le ramènerait dans le chunk
 * de quiconque importe `@/lib/sound`.
 */
export function playSound(name: SoundName): void {
  withAudio((audio) => audio.playSound(name), LATE_SOUND_MAX_MS);
}
