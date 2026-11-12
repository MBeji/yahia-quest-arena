/**
 * Le moteur audio, en UN module : synthèse des effets (`engine`) et boucle d'ambiance
 * (`music`). C'est la cible de l'`import()` de `lazy.ts` — personne d'autre ne l'importe,
 * sinon le moteur revient dans le chunk de l'importeur et le chargement différé ne
 * diffère plus rien.
 */
export { playSound, playCombo, unlockAudio } from "./engine";
export { startMusic, stopMusic, setMusicMood } from "./music";
