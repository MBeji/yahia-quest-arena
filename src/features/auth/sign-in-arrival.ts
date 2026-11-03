import { isFromContent } from "@/shared/lib/funnel-origin";
import { peekReturnReason, peekReturnTo } from "@/shared/lib/return-to";

// Ce que la page de connexion lit de l'ARRIVÉE — une session fraîche venue de Google, et la mémoire
// de retour —, sorti de `routes/auth.tsx` (2026-11-03). Texte déplacé à l'identique.

/** Ce que `isFreshGoogleSignIn` lit d'une session — le type de Supabase s'y range tel quel. */
export type SignInProbe = {
  user: {
    app_metadata?: { provider?: string };
    identities?: { provider: string; last_sign_in_at?: string }[] | null;
    last_sign_in_at?: string;
  };
};

/** En deçà, la session est celle d'une connexion qui vient d'avoir lieu, pas d'une session retrouvée. */
const FRESH_SIGN_IN_MS = 60_000;

/**
 * La session qui vient de s'ouvrir est-elle un retour de Google ?
 *
 * ⚠️ Ni `?code=` ni le fragment : le client Supabase du projet n'a pas de `flowType`, donc c'est le
 * flux IMPLICITE (le défaut de la librairie), où le retour arrive dans `#access_token=…` et jamais
 * dans `?code=`. Chercher un `code` dans l'URL aurait laissé cet événement muet en production, sans
 * qu'aucun test le dise. La session, elle, dit les deux choses qu'il faut : QUELLE identité vient
 * de servir (la plus récemment connectée — un compte peut en porter plusieurs) et QUAND. Le délai
 * écarte l'onglet qu'on retrouve : l'événement SIGNED_IN y repart aussi, avec une session ancienne.
 * Un retour de lien de confirmation e-mail, lui, porte l'identité « email » : ce n'est pas Google.
 */
export function isFreshGoogleSignIn(session: SignInProbe, now: number): boolean {
  const latest = (session.user.identities ?? []).reduce<{ provider: string; at: number } | null>(
    (best, identity) => {
      const at = Date.parse(identity.last_sign_in_at ?? "");
      return Number.isFinite(at) && (!best || at > best.at)
        ? { provider: identity.provider, at }
        : best;
    },
    null,
  );
  const provider = latest?.provider ?? session.user.app_metadata?.provider;
  const at = latest?.at ?? Date.parse(session.user.last_sign_in_at ?? "");
  return provider === "google" && Number.isFinite(at) && now - at < FRESH_SIGN_IN_MS;
}

/**
 * Ce que la mémoire de retour dit du moment : a-t-on de quoi ramener la personne, vient-elle d'un
 * contenu, et POURQUOI elle revient — `expired` quand sa session est morte (é38 lot 3, R-7), `fresh`
 * sinon. `signup` n'en reprend que les deux premiers champs.
 */
export type ReturnContext = {
  return_to_kept: boolean;
  from_content: boolean;
  reason: "fresh" | "expired";
};

/**
 * À lire AVANT tout appel qui ouvre une session : `leave()` consomme la mémoire, et `signUp` comme
 * `signInWithPassword` notifient `SIGNED_IN` AVANT de rendre la main — l'écouteur de la page a donc déjà
 * navigué et vidé la mémoire quand le formulaire reprend la parole. Lue après, la mesure disait
 * « pas de retour gardé » pour la plupart des connexions qui en avaient un.
 */
export function readReturnContext(): ReturnContext {
  const origin = peekReturnTo();
  return {
    return_to_kept: origin !== null,
    from_content: isFromContent(origin),
    reason: peekReturnReason() ?? "fresh",
  };
}
