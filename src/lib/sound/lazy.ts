/**
 * Le moteur audio se charge AU PREMIER USAGE, pas au premier rendu (2026-11-12).
 *
 * Il vivait dans le chunk d'entrée — 6,2 KB que tout visiteur téléchargeait et analysait
 * avant de voir la page, alors qu'aucun son ne peut partir avant un geste (les navigateurs
 * gardent l'`AudioContext` suspendu jusque-là) et que la musique est éteinte par défaut.
 * `SoundProvider` reste dans l'entrée (il porte les préférences) ; la synthèse, elle,
 * arrive par `import()` au premier geste de l'élève.
 */
type AudioEngine = typeof import("./audio");

let engine: AudioEngine | null = null;
let loading: Promise<AudioEngine> | null = null;

/**
 * Un effet demandé avant l'arrivée du moteur n'est joué que s'il arrive dans ce délai :
 * un « bonne réponse » qui sonne une seconde après le geste est pire que pas de son.
 */
export const LATE_SOUND_MAX_MS = 400;

/** Le moteur s'il est déjà là — pour ce qui doit s'exécuter DANS le geste, sans attendre. */
export function audioIfLoaded(): AudioEngine | null {
  return engine;
}

/** Charge le moteur (une seule fois) ; un échec réseau n'est pas mémorisé, on réessaiera. */
export function loadAudio(): Promise<AudioEngine> {
  loading ??= import("./audio").then(
    (loaded) => {
      engine = loaded;
      return loaded;
    },
    (error: unknown) => {
      loading = null;
      throw error;
    },
  );
  return loading;
}

/**
 * Exécute `run` avec le moteur : tout de suite s'il est chargé, à son arrivée sinon.
 * `maxDelayMs` abandonne l'appel si le moteur met plus longtemps à venir. Ne lève jamais :
 * le son est un agrément, son absence ne doit rien casser.
 */
export function withAudio(run: (audio: AudioEngine) => void, maxDelayMs?: number): void {
  if (engine) {
    run(engine);
    return;
  }
  const askedAt = Date.now();
  loadAudio().then(
    (audio) => {
      if (maxDelayMs === undefined || Date.now() - askedAt <= maxDelayMs) run(audio);
    },
    () => {},
  );
}

/** Test-only : repart d'un moteur non chargé. */
export function __resetLazyAudioForTests(): void {
  engine = null;
  loading = null;
}
