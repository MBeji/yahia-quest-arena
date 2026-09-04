// LE TRAVAIL EST ÉCRIT AVANT D'ÊTRE ENVOYÉ — jamais l'inverse.
//
// LA PANNE QU'IL FERME. Les réponses d'une mission ne vivaient que dans l'état
// React (`exercise-player.tsx`), et ne le quittaient qu'à la soumission finale.
// Tout ce qui empêchait cette soumission d'aboutir — jeton refusé, réseau coupé,
// onglet fermé — emportait donc la partie entière avec lui. `router.tsx` le dit
// mot pour mot depuis #914 : « ses réponses, qui ne vivent que dans l'état
// React, partent avec ». Ce module inverse l'ordre : on ÉCRIT, puis on tente.
//
// CE QU'IL N'EST PAS. Ce n'est pas un remède au jeton refusé — `auth-attacher`
// s'en charge, et bien. C'est le filet EN DESSOUS : quand le rattrapage échoue à
// son tour, le travail est toujours là, et repartira au prochain déclencheur.
//
// POURQUOI localStorage ET PAS IndexedDB. Le seul payload qui transite ici est
// borné par le zod de `submitAttempt` : au plus 100 réponses, chacune un UUID
// (36) plus un choix plafonné à MAX_CHOICE_LENGTH (512). Soit ~58 ko dans le
// pire cas absolu, deux ordres de grandeur sous le seuil de 2 Mo qui justifierait
// une bascule. Câbler IndexedDB — asynchrone, donc incompatible avec l'écriture
// SYNCHRONE qu'exige `pagehide` — coûterait de la complexité pour un cas que le
// schéma rend impossible. Le jour où un payload volumineux entre ici, c'est ce
// commentaire qu'il faudra venir contredire, chiffres à l'appui.
import { isSessionRefusalError } from "@/shared/integrations/supabase/auth-rejection";
import { ensureFreshSession } from "@/shared/integrations/supabase/session-freshness";
import { reportClientError } from "./client-log";
import { logger } from "./logger";

const STORAGE_KEY = "nn:outbox:v1";

/**
 * Au-delà, on cesse de réessayer et on abandonne l'item.
 *
 * POURQUOI UNE LIMITE DU TOUT. Un item qu'aucun essai ne fera jamais passer
 * (l'exercice a été supprimé, la session n'existe plus côté serveur) resterait
 * sinon en file pour toujours, et chaque flush le rejouerait — un bruit
 * permanent qui finirait par masquer les vrais échecs.
 */
const MAX_ATTEMPTS = 8;

/**
 * Au-delà, l'item est trop vieux pour valoir quoi que ce soit. Une soumission
 * de mission vieille de 24 h désigne une session que le serveur a de toute façon
 * cessé de considérer comme ouverte.
 */
const MAX_AGE_MS = 24 * 60 * 60 * 1000;

/** Cadence du flush périodique, une fois les déclencheurs installés. */
export const OUTBOX_FLUSH_INTERVAL_MS = 30_000;

export type OutboxItem = {
  /** Identifiant stable, fourni par l'appelant. C'est la clé d'unicité. */
  readonly clientId: string;
  /** Quel expéditeur sait envoyer cet item. */
  readonly kind: string;
  readonly payload: unknown;
  readonly createdAt: number;
  readonly attempts: number;
};

/** Envoie un item. Lever = échec ; le classement décide de la suite. */
export type OutboxSender = (payload: unknown) => Promise<unknown>;

const senders = new Map<string, OutboxSender>();

/** Déclare qui sait envoyer les items d'un genre donné. */
export function registerSender(kind: string, sender: OutboxSender): void {
  senders.set(kind, sender);
}

// --- Stockage ---------------------------------------------------------------
// Toutes les lectures/écritures sont défensives : `localStorage` n'existe pas au
// SSR, lève en navigation privée sur certains navigateurs, et peut être plein.
// Un outbox qui casse la page qu'il protège n'aurait aucun sens.

function read(): OutboxItem[] {
  if (typeof window === "undefined") return [];
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    const parsed: unknown = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed.filter(isOutboxItem);
  } catch {
    return [];
  }
}

function write(items: readonly OutboxItem[]): void {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  } catch (error) {
    // Quota dépassé, ou stockage refusé. On ne peut pas garantir la reprise,
    // mais on le DIT plutôt que de laisser croire que c'est enregistré.
    logger.warn("outbox.write-failed", { error: String(error), count: items.length });
  }
}

function isOutboxItem(value: unknown): value is OutboxItem {
  if (!value || typeof value !== "object") return false;
  const item = value as Partial<OutboxItem>;
  return (
    typeof item.clientId === "string" &&
    typeof item.kind === "string" &&
    typeof item.createdAt === "number" &&
    typeof item.attempts === "number"
  );
}

// --- File -------------------------------------------------------------------

/**
 * Met le travail en file. À appeler AVANT toute tentative réseau — c'est tout
 * l'intérêt du module.
 *
 * Ré-appeler avec le même `clientId` REMPLACE l'item au lieu d'en ajouter un
 * second : c'est ce qui rend un `enqueue` répété (autosave qui retape, page
 * rechargée) incapable de créer deux envois pour un même travail.
 */
export function enqueue(entry: { clientId: string; kind: string; payload: unknown }): void {
  const items = read();
  const existing = items.find((i) => i.clientId === entry.clientId);
  const next: OutboxItem = {
    clientId: entry.clientId,
    kind: entry.kind,
    payload: entry.payload,
    // Un remplacement garde l'âge d'origine : sinon un autosave qui retape
    // toutes les 20 s rajeunirait l'item sans fin et `MAX_AGE_MS` ne tomberait
    // jamais.
    createdAt: existing?.createdAt ?? Date.now(),
    attempts: existing?.attempts ?? 0,
  };
  write([...items.filter((i) => i.clientId !== entry.clientId), next]);
  notify();
}

/** Retire un item de la file (envoyé, ou abandonné). */
export function remove(clientId: string): void {
  write(read().filter((i) => i.clientId !== clientId));
  notify();
}

/** Les items en attente, du plus ancien au plus récent. */
export function pending(): OutboxItem[] {
  return read().sort((a, b) => a.createdAt - b.createdAt);
}

/** Combien d'items attendent. C'est ce que l'indicateur d'UI regarde. */
export function pendingCount(): number {
  return read().length;
}

/** Vide la file — réservé aux tests. */
export function clearOutboxForTests(): void {
  if (typeof window !== "undefined") {
    try {
      window.localStorage.removeItem(STORAGE_KEY);
    } catch {
      // rien à faire
    }
  }
  senders.clear();
  inFlight = null;
  listeners.clear();
}

// --- Abonnés ----------------------------------------------------------------

const listeners = new Set<() => void>();

/** S'abonne aux changements de la file. Rend la fonction de désabonnement. */
export function subscribe(listener: () => void): () => void {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

function notify(): void {
  for (const listener of listeners) {
    try {
      listener();
    } catch {
      // Un abonné qui lève ne doit pas empêcher les autres d'être prévenus.
    }
  }
}

// --- Envoi ------------------------------------------------------------------

/** Ce qu'on décide d'un échec. */
type Disposition = "drop" | "keep";

/**
 * Un échec est-il DÉFINITIF (abandon) ou passager (conservation) ?
 *
 * ⚠️ CE QU'ON NE PEUT PAS LIRE. Une server fn TanStack ne rend pas de statut
 * HTTP au client : `failWithClientError` lève une `Error` dont seul le message
 * survit (`safe-error.ts`). « 4xx métier vs 5xx » n'est donc PAS observable ici,
 * et prétendre le classer par statut serait une fiction. On classe sur ce qu'on
 * voit vraiment, et on choisit le défaut sûr : dans le doute, on CONSERVE —
 * quitte à réessayer pour rien, plutôt que jeter du travail. `MAX_ATTEMPTS` et
 * `MAX_AGE_MS` bornent ce doute.
 */
function disposeOf(error: unknown, item: OutboxItem): Disposition {
  if (item.attempts + 1 >= MAX_ATTEMPTS) return "drop";
  if (Date.now() - item.createdAt > MAX_AGE_MS) return "drop";
  return isTerminal(error) ? "drop" : "keep";
}

/**
 * Les refus dont on sait qu'aucun rejeu ne les guérira. Reconnus au message,
 * comme `isSessionRefusalError` et pour la même raison : c'est la seule chose qui
 * traverse la frontière server fn. Ne pas y ranger un refus d'authentification :
 * il est traité en amont par `send()`, qui force un jeton neuf AVANT d'abandonner
 * — c'est précisément ce qu'un flush partant sans jeton (`NO_HEADER`) ne recevait
 * pas avant le 2026-08-31, son travail restant en file sans que rien ne le
 * débloque.
 *
 * « Session déjà terminée » mérite un mot : depuis la migration de rejeu, la RPC
 * REND le résultat d'origine au lieu de lever, donc ce cas ne devrait plus se
 * produire. Il reste listé pour les sessions ouvertes avant cette migration —
 * et parce qu'un abandon y est le bon geste : le travail EST enregistré.
 */
const TERMINAL_MESSAGES = [
  "already completed",
  "Invalid quest session",
  "Exercise not found",
  "out of bounds",
  "must be an array",
];

function isTerminal(error: unknown): boolean {
  const message = error instanceof Error ? error.message : String(error);
  return TERMINAL_MESSAGES.some((needle) => message.includes(needle));
}

export type FlushReport = {
  sent: number;
  dropped: number;
  kept: number;
};

/**
 * La passe en cours, s'il y en a une. Deux flushs concurrents enverraient le
 * même item deux fois — l'intervalle et le retour de focus tombent volontiers
 * ensemble, ce n'est pas un cas tordu.
 */
let inFlight: Promise<FlushReport> | null = null;

/**
 * Envoie ce qui attend. Un appel pendant qu'une passe tourne REJOINT cette
 * passe au lieu d'en ouvrir une seconde.
 */
export function flush(): Promise<FlushReport> {
  if (inFlight) return inFlight;
  const run = runFlush().finally(() => {
    if (inFlight === run) inFlight = null;
  });
  inFlight = run;
  return run;
}

async function runFlush(): Promise<FlushReport> {
  const report: FlushReport = { sent: 0, dropped: 0, kept: 0 };
  if (typeof navigator !== "undefined" && navigator.onLine === false) {
    report.kept = pendingCount();
    return report;
  }

  for (const item of pending()) {
    const sender = senders.get(item.kind);
    if (!sender) {
      // Personne ne sait envoyer ça. Conserver : l'expéditeur s'enregistre au
      // montage de l'app, et un flush peut le précéder.
      report.kept += 1;
      continue;
    }

    const outcome = await send(sender, item);
    if (outcome === "sent") {
      remove(item.clientId);
      report.sent += 1;
    } else if (outcome === "drop") {
      logger.warn("outbox.dropped", { kind: item.kind, attempts: item.attempts + 1 });
      remove(item.clientId);
      report.dropped += 1;
    } else {
      bumpAttempts(item.clientId);
      report.kept += 1;
    }
  }

  return report;
}

/**
 * Une tentative, et UNE SEULE reprise si le jeton est refusé.
 *
 * ⚠️ POURQUOI L'OUTBOX REJOUE ALORS QUE `router.tsx` REJOUE DÉJÀ. Les deux ne
 * s'empilent pas, parce qu'ils ne sont pas sur le même chemin : la politique
 * `mutations.retry` de TanStack Query ne s'applique qu'aux appels passés PAR une
 * mutation. Le flush, lui, appelle l'expéditeur directement — c'est une reprise
 * de fond, pas un geste d'élève. Chacun des deux chemins a donc exactement une
 * reprise. Faire passer le flush par `useMutation` en donnerait deux, et le
 * second partirait sur un jeton que personne n'a re-forcé.
 *
 * Une seule, et pas une boucle : après un refus, `ensureFreshSession(true)` a
 * fait émettre un jeton neuf par le serveur — seule autorité sur l'heure et la
 * signature. Si celui-là est refusé aussi, la session est morte, et insister ne
 * ferait que masquer ce fait. L'item reste en file pour un prochain flush, quand
 * l'élève se sera reconnecté.
 */
async function send(sender: OutboxSender, item: OutboxItem): Promise<"sent" | Disposition> {
  try {
    await sender(item.payload);
    return "sent";
  } catch (error) {
    if (!isSessionRefusalError(error)) {
      // ⚠️ CETTE BRANCHE SORTAIT EN SILENCE, et c'est ce qui a coûté la journée
      // du 2026-09-03 : un rejeu refusé pour toute raison AUTRE qu'un jeton
      // — la RPC qui lève, la server fn qui tombe, le format d'une réponse
      // rejeté — ne produisait pas une ligne. La garde a répondu « 0 refus dans
      // la fenêtre » ce soir-là, et elle disait vrai : elle ne voyait que la
      // moitié auth. Un travail d'élève qui n'arrive pas se raconte maintenant
      // ici aussi, avec sa DISPOSITION — « conservé » se rattrapera au prochain
      // déclencheur, « abandonné » ne reviendra jamais.
      const disposition = disposeOf(error, item);
      reportClientError({
        stage: "outbox-send",
        clientId: item.clientId,
        errMessage: error instanceof Error ? error.message : String(error),
        payload: { kind: item.kind, attempts: item.attempts, disposition },
      });
      return disposition;
    }

    // La boîte noire, prise AVANT le rafraîchissement forcé : après lui, le TTL
    // observé serait celui du jeton NEUF, et la mesure ne dirait plus rien de la
    // panne qu'on cherche à comprendre.
    reportClientError({
      stage: "outbox-flush",
      clientId: item.clientId,
      errMessage: error instanceof Error ? error.message : String(error),
      payload: { kind: item.kind, attempts: item.attempts },
    });

    try {
      await ensureFreshSession(true);
      await sender(item.payload);
      return "sent";
    } catch (retryError) {
      // Le rejeu a été refusé LUI AUSSI, avec un jeton pourtant tout neuf. C'est
      // le cas le plus intéressant de tous : il disqualifie l'horloge locale et
      // désigne le serveur ou la session elle-même.
      const disposition = disposeOf(retryError, item);
      reportClientError({
        stage: "outbox-replay",
        clientId: item.clientId,
        errMessage: retryError instanceof Error ? retryError.message : String(retryError),
        payload: { kind: item.kind, attempts: item.attempts, disposition },
      });
      return disposition;
    }
  }
}

function bumpAttempts(clientId: string): void {
  const items = read();
  const item = items.find((i) => i.clientId === clientId);
  if (!item) return;
  write(items.map((i) => (i.clientId === clientId ? { ...i, attempts: i.attempts + 1 } : i)));
}

// --- Déclencheurs -----------------------------------------------------------

/**
 * Installe les déclencheurs de flush et lance une première passe. À appeler une
 * fois, au montage de l'app. Rend la fonction de démontage.
 *
 * Les quatre déclencheurs ne font pas doublon : l'intervalle couvre la session
 * qui dure, `visibilitychange` le retour d'un onglet en veille (le cas mobile,
 * où l'intervalle a été gelé par le navigateur), `online` la reconnexion, et le
 * montage la reprise d'un travail laissé par une session PRÉCÉDENTE — c'est
 * celui-là qui fait qu'un rechargement de page resynchronise tout seul.
 */
export function startOutbox(): () => void {
  if (typeof window === "undefined") return () => {};

  const tick = () => void flush().catch(() => {});
  const onVisible = () => {
    if (document.visibilityState === "visible") tick();
  };

  const interval = setInterval(tick, OUTBOX_FLUSH_INTERVAL_MS);
  document.addEventListener("visibilitychange", onVisible);
  window.addEventListener("online", tick);
  tick();

  return () => {
    clearInterval(interval);
    document.removeEventListener("visibilitychange", onVisible);
    window.removeEventListener("online", tick);
  };
}
