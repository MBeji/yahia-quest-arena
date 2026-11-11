/**
 * ESLint rule: un seul client Supabase de NAVIGATEUR dans tout le produit.
 *
 * LA PANNE QU'ELLE REND IMPOSSIBLE
 * ---------------------------------------------------------------------------
 * Chaque client Supabase créé côté navigateur embarque son propre GoTrue, donc
 * son propre minuteur de rafraîchissement. Or un rafraîchissement fait TOURNER
 * le refresh token : le précédent devient invalide. Deux instances vivantes dans
 * le même onglet, et la seconde à se réveiller reçoit
 * `Invalid Refresh Token: Already Used` — un refus aléatoire, qui ne se
 * reproduit pas, et qui tombe pile au moment où l'élève enregistre son travail.
 *
 * Le produit n'a jamais eu qu'un seul client browser
 * (`src/shared/integrations/supabase/client.ts`, singleton derrière un Proxy à
 * init paresseuse). Cette règle n'est donc pas un correctif : c'est un cliquet.
 * Elle empêche que le jour où quelqu'un écrit un `createClient` « juste pour ce
 * composant », personne ne s'en aperçoive avant la production.
 *
 * CE QU'ELLE LAISSE PASSER, ET POURQUOI
 * ---------------------------------------------------------------------------
 * Quatre fichiers créent légitimement un client, et un seul est celui du
 * navigateur :
 *   - `client.ts`         — LE client browser (anon, RLS, session en localStorage) ;
 *   - `client.server.ts`  — service role, serveur uniquement ;
 *   - `auth-request.ts`   — un client PAR REQUÊTE portant le Bearer de l'appelant,
 *                           délibérément non hissé (ce serait la session d'un
 *                           élève dans la requête d'un autre) ;
 *   - `public-client.ts`  — lectures publiques anonymes, serveur.
 * Aucun d'eux ne tourne dans le navigateur avec une session persistée, sauf le
 * premier. Les `__tests__` sont hors périmètre : ils simulent la factory, ils ne
 * l'appellent pas en production.
 *
 * `e2e/` l'est aussi, pour la même raison poussée d'un cran : le harnais
 * Playwright tourne dans NODE, pas dans le navigateur du produit, et son
 * `createAdminDb()` monte un client SERVICE ROLE avec `persistSession: false` —
 * donc aucun refresh token n'y est stocké, et il n'y a rien à faire tourner. La
 * panne que cette règle rend impossible ne peut pas s'y produire.
 *
 * ⚠️ Cette exemption a coûté une nuit avant d'être écrite. La règle est née avec
 * #918 et `npm run verify` ne lint QUE `src` : `e2e/helpers/db.ts` n'a donc été
 * vu par personne jusqu'au nightly du 2026-09-01, où l'étape « Lint e2e » a fait
 * tomber la suite E2E publique — sur une ligne parfaitement légitime, et sans
 * qu'aucun test n'ait échoué.
 *
 * `createBrowserClient` (l'API de `@supabase/ssr`) est refusée PARTOUT, sans
 * exception : le paquet n'est pas une dépendance du projet, donc son apparition
 * signale toujours un second client — ou une migration d'architecture qui doit
 * se discuter, pas se glisser dans un composant.
 */

/** Les seuls fichiers autorisés à créer un client Supabase. */
const ALLOWED_FACTORIES = [
  "src/shared/integrations/supabase/client.ts",
  "src/shared/integrations/supabase/client.server.ts",
  "src/shared/integrations/supabase/auth-request.ts",
  "src/shared/integrations/supabase/public-client.ts",
];

/** Chemin normalisé en slashes, relatif à la racine du dépôt. */
function repoPath(filename) {
  const normalized = String(filename).replace(/\\/g, "/");
  // `e2e/` compte au même titre que `src/` et `scripts/` : sans lui, un fichier
  // du harnais ne se réduit jamais à un chemin de dépôt et l'exemption ci-dessous
  // ne peut pas le reconnaître.
  for (const marker of ["/src/", "/scripts/", "/e2e/"]) {
    const at = normalized.lastIndexOf(marker);
    if (at !== -1) return normalized.slice(at + 1);
  }
  return normalized;
}

function isExempt(filename) {
  const path = repoPath(filename);
  if (path.includes("__tests__/")) return true;
  // Harnais Playwright : Node, service role, `persistSession: false` — voir l'en-tête.
  if (path.startsWith("e2e/")) return true;
  return ALLOWED_FACTORIES.some((allowed) => path.endsWith(allowed));
}

/** @type {import('eslint').Rule.RuleModule} */
export const singleBrowserSupabaseClient = {
  meta: {
    type: "problem",
    docs: {
      description:
        "Interdit la création d'un client Supabase hors des quatre factories dédiées — plusieurs instances GoTrue dans un navigateur invalident mutuellement leur refresh token.",
    },
    schema: [],
    messages: {
      extraClient:
        'Client Supabase créé hors des factories dédiées. Un second client de navigateur lance son propre rafraîchissement, et la rotation du refresh token invalide celui de l\'autre (« Invalid Refresh Token: Already Used »). Importer le singleton : `import { supabase } from "@/shared/integrations/supabase/client"`.',
      browserClient:
        '`createBrowserClient` (@supabase/ssr) n\'est pas utilisé par ce projet et créerait un second client de navigateur. Importer le singleton : `import { supabase } from "@/shared/integrations/supabase/client"`.',
    },
  },

  create(context) {
    const filename = context.filename ?? context.getFilename();
    const exempt = isExempt(filename);

    /** Les identifiants importés depuis un paquet Supabase, et leur nom d'origine. */
    const imported = new Map();

    return {
      ImportDeclaration(node) {
        const source = node.source.value;
        if (typeof source !== "string" || !source.startsWith("@supabase/")) return;
        for (const spec of node.specifiers) {
          if (spec.type !== "ImportSpecifier") continue;
          const original = spec.imported.name;
          if (original === "createClient" || original === "createBrowserClient") {
            imported.set(spec.local.name, original);
          }
        }
      },

      CallExpression(node) {
        if (node.callee.type !== "Identifier") return;
        const original = imported.get(node.callee.name);
        if (!original) return;

        if (original === "createBrowserClient") {
          // Refusée partout, y compris dans les factories : le projet ne
          // dépend pas de `@supabase/ssr`.
          context.report({ node, messageId: "browserClient" });
          return;
        }

        if (!exempt) context.report({ node, messageId: "extraClient" });
      },
    };
  },
};
