// LE RÉCIT D'UN REFUS D'AUTHENTIFICATION, envoyé pendant qu'il se produit.
//
// CE QU'IL SERT À TRANCHER. Le correctif de #914 repose sur un diagnostic —
// l'horloge de l'appareil ment de plus de 90 s, donc auth-js rend un jeton
// périmé sans le savoir — que rien n'a encore MESURÉ. Trois grandeurs suffisent
// à départager cette hypothèse de ses rivales, et ce module ne collecte
// qu'elles :
//
//   * le TTL restant du jeton au moment du refus. Négatif ⇒ expiration
//     ordinaire. Largement positif ⇒ l'appareil se croyait dans les temps et le
//     serveur a dit non : c'est la dérive d'horloge.
//   * le temps passé onglet caché — total, et durée de la dernière veille. Le
//     cas mobile, où le navigateur gèle les minuteries et donc le ticker
//     d'`autoRefreshToken`.
//   * le message d'erreur EXACT, celui qu'aucun rapport n'a jamais rapporté.
//
// AUCUNE DONNÉE PERSONNELLE. Ni identifiant d'élève, ni adresse, ni contenu de
// réponse : `clientId` désigne une soumission, pas une personne. Même politique
// que `monitoring.ts` (INPDP / mineurs).
import {
  lastKnownExpiry,
  secondsUntilExpiry,
} from "@/shared/integrations/supabase/session-freshness";
import type { ClientErrorStage } from "@/shared/lib/client-error-stages";

const ENDPOINT = "/api/client-log";

// --- Le temps passé caché ---------------------------------------------------
// Compté ici plutôt que déduit côté serveur : seul le navigateur sait quand
// l'onglet a disparu, et c'est justement ce que les rapports d'élèves ne
// racontent jamais (« j'ai laissé le téléphone et je suis revenu »).

let hiddenTotalMs = 0;
let lastHiddenMs = 0;
let hiddenSince: number | null = null;

function onVisibilityChange(): void {
  if (document.visibilityState === "hidden") {
    hiddenSince = Date.now();
    return;
  }
  if (hiddenSince !== null) {
    lastHiddenMs = Date.now() - hiddenSince;
    hiddenTotalMs += lastHiddenMs;
    hiddenSince = null;
  }
}

/**
 * Démarre le suivi de visibilité. À appeler une fois, au montage de l'app ;
 * rend la fonction de démontage.
 */
export function initHiddenTimeTracking(): () => void {
  if (typeof document === "undefined") return () => {};
  document.addEventListener("visibilitychange", onVisibilityChange);
  return () => document.removeEventListener("visibilitychange", onVisibilityChange);
}

/**
 * Le temps caché à cet instant. Si l'onglet est caché EN CE MOMENT, la veille en
 * cours est comptée : sans ça, un envoi déclenché juste après un retour de veille
 * rapporterait zéro pour le cas même qu'on cherche.
 */
export function hiddenTime(): { hiddenTotalMs: number; lastHiddenMs: number } {
  const ongoing = hiddenSince !== null ? Date.now() - hiddenSince : 0;
  return {
    hiddenTotalMs: hiddenTotalMs + ongoing,
    lastHiddenMs: ongoing > 0 ? ongoing : lastHiddenMs,
  };
}

/** Remet les compteurs à zéro — réservé aux tests. */
export function resetHiddenTimeForTests(): void {
  hiddenTotalMs = 0;
  lastHiddenMs = 0;
  hiddenSince = null;
}

// --- L'envoi ----------------------------------------------------------------

export type ClientErrorReport = {
  /**
   * Où l'échec s'est produit. Le jeu est CLOS (`client-error-stages.ts`) : la
   * garde qui relève la table agrège et seuille sur cette valeur, donc une
   * chaîne libre écrite ici sortirait d'un seuil sans que rien ne le dise.
   */
  stage: ClientErrorStage;
  clientId?: string | null;
  httpStatus?: number | null;
  errMessage?: string | null;
  payload?: Record<string, unknown> | null;
};

/**
 * Raconte un refus. Sans attente, sans jamais lever.
 *
 * ⚠️ `sendBeacon` D'ABORD, ET CE N'EST PAS UN DÉTAIL. Le refus arrive souvent au
 * pire moment — l'élève ferme l'onglet, ou le système mobile le tue. Un `fetch`
 * ordinaire serait annulé avec le document ; `sendBeacon` est justement conçu
 * pour survivre à la fermeture, le navigateur prenant la requête en charge.
 * `keepalive: true` est le repli quand `sendBeacon` n'existe pas ou refuse (il
 * rend `false` au-delà de son propre quota) — il offre la même garantie de
 * survie, avec une limite de taille voisine des 8 ko que le serveur accepte.
 */
export function reportClientError(report: ClientErrorReport): void {
  try {
    if (typeof window === "undefined") return;

    const hidden = hiddenTime();
    const body = JSON.stringify({
      stage: report.stage,
      clientId: report.clientId ?? null,
      httpStatus: report.httpStatus ?? null,
      errMessage: report.errMessage ?? null,
      // `lastKnownExpiry()` est lu SYNCHRONEMENT : interroger la session ici
      // réveillerait un rafraîchissement sur une session déjà abîmée.
      ttlS: secondsUntilExpiry(lastKnownExpiry()),
      hiddenTotalMs: hidden.hiddenTotalMs,
      lastHiddenMs: hidden.lastHiddenMs,
      payload: report.payload ?? null,
    });

    if (typeof navigator !== "undefined" && typeof navigator.sendBeacon === "function") {
      const blob = new Blob([body], { type: "application/json" });
      if (navigator.sendBeacon(ENDPOINT, blob)) return;
    }

    void fetch(ENDPOINT, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body,
      keepalive: true,
    }).catch(() => {});
  } catch {
    // La télémétrie ne casse jamais rien — surtout pas le chemin d'une panne.
  }
}
