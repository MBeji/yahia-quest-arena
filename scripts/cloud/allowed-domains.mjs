/**
 * La liste blanche réseau d'une session cloud — l'unique endroit du dépôt où elle est écrite
 * (étude cloud-first, lots 0 et 1 — docs/agents/etude-cloud-first.md §7).
 *
 * Le réglage lui-même vit HORS dépôt : le dialogue d'environnement de claude.ai/code,
 * « Network access : Custom ». Aucune PR ne le pose, aucun gate ne le voit dériver. Ce module
 * fait tout ce que le dépôt PEUT faire : il NOMME la liste, avec la raison de chaque ligne, et
 * le hook `.claude/hooks/session-start.mjs` la SONDE à chaque démarrage pour dire en clair ce
 * qui manque — au lieu de laisser une campagne échouer en silence sur un 403.
 *
 *   node scripts/cloud/allowed-domains.mjs     # imprime la liste à coller dans claude.ai
 *
 * Les hôtes se dérivent des constantes partagées (scripts/shared/prod-targets.mjs) : une cible
 * qui change là-bas change ici. Le ref TEST est le même que `TEST_REF` de
 * scripts/db/push-prod.mjs — un test l'affirme, plutôt que d'importer au démarrage de chaque
 * session le script qui écrit le schéma de prod. Même chose pour l'hôte du CNP, égal à celui de
 * `CNP_MANUEL_BASE_URL` (src/shared/content/manuel-cnp.ts) : le hook tourne sous le Node de la
 * VM, pas sous vitest, donc il ne dépend d'aucun import TypeScript.
 */
import { pathToFileURL } from "node:url";
import { PROD_APP_HOSTS, PROD_SUPABASE_REF } from "../shared/prod-targets.mjs";

/** Hôte du magasin PDF du CNP (= hôte de `CNP_MANUEL_BASE_URL`, affirmé par un test). */
export const CNP_HOST = "www.cnp.com.tn";
/** Le projet Supabase TEST/e2e (= `TEST_REF` de scripts/db/push-prod.mjs, affirmé par un test). */
export const TEST_SUPABASE_REF = "pqegdnwdtbjtplcthxyp";
/** L'hôte canonique de la prod — le seul qui répond 200 (STATUS.md §1). */
export const PROD_APP_HOST = PROD_APP_HOSTS.find((h) => h.startsWith("www.")) ?? PROD_APP_HOSTS[0];

/**
 * Une ligne par domaine : l'hôte à coller, l'URL que la sonde interroge (un HEAD suffit — on
 * cherche un code HTTP, n'importe lequel, pas un contenu), la raison d'être de la ligne, et ce
 * qui devient impossible quand elle manque — c'est cette dernière phrase que la session lit.
 */
export const ALLOWED_DOMAINS = [
  {
    host: CNP_HOST,
    probe: `https://${CNP_HOST}/arabic/PDF/102905P00.pdf`,
    why: "les manuels officiels, lus par code depuis le magasin PDF du CNP (classe A de l'étude)",
    ifBlocked: "aucune campagne ne peut lire un manuel",
  },
  {
    host: PROD_APP_HOST,
    probe: `https://${PROD_APP_HOST}/api/health`,
    why: "la prod, en lecture : /api/health, contrôle post-déploiement, vérification de rollback",
    ifBlocked: "aucune sonde de prod possible",
  },
  {
    host: `${PROD_SUPABASE_REF}.supabase.co`,
    probe: `https://${PROD_SUPABASE_REF}.supabase.co/rest/v1/`,
    why: "le REST anonyme de la prod : comptages du playbook campagnes, clés publiques seulement",
    ifBlocked: "aucun comptage REST en prod",
  },
  {
    host: `${TEST_SUPABASE_REF}.supabase.co`,
    probe: `https://${TEST_SUPABASE_REF}.supabase.co/rest/v1/`,
    why: "le projet TEST : content:manuel:check, e2e:doctor",
    ifBlocked: "le projet TEST est injoignable (e2e:doctor, content:manuel:check)",
  },
];

/** La liste telle qu'elle se colle dans « Allowed domains » : un hôte par ligne. */
export function renderAllowlist(domains = ALLOWED_DOMAINS) {
  return `${domains.map((d) => d.host).join("\n")}\n`;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.stdout.write(renderAllowlist());
}
