// Garde l'erreur d'origine hors bande, pour que server.ts retrouve sa pile quand
// le framework a déjà transformé le throw en réponse 500 générique.
//
// Deux sources, parce qu'aucune ne couvre les deux runtimes :
//   • `captureError()`, appelée par le middleware de requête (src/start.ts) au
//     moment où il laisse remonter une erreur. C'est la SEULE voie qui marche sous
//     Node (Vercel) : TanStack Start attrape le throw lui-même, donc ni
//     `uncaughtException` ni `unhandledRejection` ne se déclenchent — mesuré le
//     2026-11-12 sur Node 24.22 (zéro événement `process` pour un throw avalé), et
//     `globalThis.addEventListener` n'y existe pas ;
//   • l'écouteur global ci-dessous, pour le navigateur et un runtime Worker.
//
// S'abonner à `process.on("uncaughtException")` n'apporterait donc rien ici, et
// coûterait cher : la seule présence de cet écouteur empêche Node de terminer le
// processus sur une exception non rattrapée.

let lastCapturedError: { error: unknown; at: number } | undefined;
const TTL_MS = 5_000;

function record(error: unknown) {
  lastCapturedError = { error, at: Date.now() };
}

/** À appeler là où une erreur est vue AVANT que le framework ne l'avale. */
export function captureError(error: unknown): void {
  record(error);
}

if (typeof globalThis.addEventListener === "function") {
  globalThis.addEventListener("error", (event) => record((event as ErrorEvent).error ?? event));
  globalThis.addEventListener("unhandledrejection", (event) =>
    record((event as PromiseRejectionEvent).reason),
  );
}

export function consumeLastCapturedError(): unknown {
  if (!lastCapturedError) return undefined;
  if (Date.now() - lastCapturedError.at > TTL_MS) {
    lastCapturedError = undefined;
    return undefined;
  }
  const { error } = lastCapturedError;
  lastCapturedError = undefined;
  return error;
}
