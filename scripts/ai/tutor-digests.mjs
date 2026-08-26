/**
 * Le déclencheur du batch des bilans hebdomadaires — étude 11 lot 6.
 *
 * CE QUE CE SCRIPT NE FAIT PAS, ET POURQUOI IL NE PEUT PAS LE FAIRE
 * ---------------------------------------------------------------------------
 * Il n'écrit rien en base, et il ne parle à aucun fournisseur de modèle. Il ne
 * le peut pas : produire un bilan passe obligatoirement par `callAi()`, la porte
 * unique qui résout l'accès, réserve la dépense, comptabilise et rembourse — du
 * code `.server`, avec des alias Vite (`@/`), qu'un `.mjs` de `scripts/` ne sait
 * pas charger. La voie « le workflow parle à Postgres en service_role » (motif
 * report-close.yml) permettrait de poser des lignes, jamais de les rédiger.
 *
 * Ce script est donc un CLIENT. Il frappe `POST /api/cron/digest` — la route
 * gardée par `CRON_SECRET`, sur le motif exact de `/api/cron/notify` — et c'est
 * le serveur qui fait le travail.
 *
 * POURQUOI IL BOUCLE
 * ---------------------------------------------------------------------------
 * La fonction SSR est configurée à `maxDuration: 300` secondes
 * (`scripts/build-vercel.mjs`, plan Hobby). Un appel de modèle se compte en
 * secondes, un élève lié à un parent en coûte deux : trois élèves tiennent dans
 * l'enveloppe, cent n'y tiennent pas. La route traite donc une TRANCHE bornée et
 * rend un curseur ; ce script rappelle la route jusqu'à épuisement.
 *
 * Le curseur est le dernier élève VU. Une tranche entière tombée en « semaine
 * vide » avance donc quand même — c'est la seule façon de garantir la fin de la
 * boucle.
 *
 * LA RÉPÉTITION EST LE DÉFAUT
 * ---------------------------------------------------------------------------
 * Sans `--apply`, rien n'est produit : la route compte ce qu'elle écrirait. Une
 * exécution manuelle qui se trompe de bouton ne déclenche pas une facture ;
 * l'intention de dépenser s'écrit, en toutes lettres, dans la ligne de commande.
 *
 * SANS SECRET, IL SORT VERT
 * ---------------------------------------------------------------------------
 * `CRON_SECRET` absent ⇒ code 0 et un message. Un batch qui rougit faute de
 * configuration apprend à toute l'équipe à ignorer ses rouges — et le jour où
 * il rougit pour une vraie raison, personne ne regarde. Même posture que
 * report-close.yml, qui saute proprement tant que ses secrets ne sont pas posés.
 *
 * Usage :
 *   CRON_SECRET=… node scripts/ai/tutor-digests.mjs            # répétition
 *   CRON_SECRET=… node scripts/ai/tutor-digests.mjs --apply    # production réelle
 *   … --limit 3 --rounds 120 --base-url https://…              # réglages
 */
import { pathToFileURL } from "node:url";

import { PROD_APP_HOSTS } from "../shared/prod-targets.mjs";

/** Élèves RÉDIGÉS au plus par requête, aligné sur `TUTOR_DIGEST_DEFAULT_LIMIT`. */
const DEFAULT_LIMIT = 3;
/**
 * Tranches au plus. Le serveur parcourt jusqu'à quarante profils par tranche
 * (les élèves sans activité ne coûtent qu'une requête SQL), donc ce plafond
 * couvre largement la base actuelle tout en garantissant que le run se termine.
 */
const DEFAULT_ROUNDS = 120;
/**
 * Un poil au-dessus du `maxDuration: 300` de la fonction SSR
 * (`scripts/build-vercel.mjs`) : on veut SA réponse, pas la nôtre.
 *
 * La valeur a dit 35 s pendant que le serveur passait à 300 : on abandonnait donc
 * une tranche que le serveur avait parfaitement le droit de finir. Le contrat du
 * serveur n'est pas « un élève » mais `ROUND_BUDGET_MS` (20 s) testé EN TÊTE de
 * boucle, PLUS l'élève en cours — deux élèves ordinaires suffisaient à dépasser
 * 35 s sans qu'aucun modèle ne soit lent, et le batch s'arrêtait après un ou deux.
 * Le seul plafond que le serveur ne peut pas franchir est celui de la plateforme :
 * c'est lui qu'on suit, pas un budget réinventé ici. Le run reste borné par le
 * `timeout-minutes` du workflow, et le curseur reprend au passage suivant.
 */
const REQUEST_TIMEOUT_MS = 310_000;

/**
 * L'hôte de production, résolu depuis le DÉPÔT et non depuis un secret.
 *
 * C'est la leçon de #614 et des 25 jours de triage perdus : un secret pasté sans
 * son schéma ne peut être réparé par aucune PR, parce que la valeur cassée vit
 * hors du dépôt. `PROD_APP_HOSTS` est versionné, donc réparable.
 *
 * On vise le CANONIQUE (`www.`) et non l'alias Vercel, et ce n'est pas une
 * préférence esthétique : l'alias répond 301, et un 301 convertit un POST en
 * GET. Le batch partirait alors sur la route en GET, recevrait la page SSR, et
 * signalerait un succès sans avoir rien produit. L'apex, lui, répond 308 (qui
 * préserve la méthode) — mais on ne fait pas dépendre une facture d'un détail de
 * code de redirection.
 */
export function defaultBaseUrl() {
  const host = PROD_APP_HOSTS.find((h) => h.startsWith("www.")) ?? PROD_APP_HOSTS[0];
  return `https://${host}`;
}

/** Lecture d'argv. Volontairement bête : aucune dépendance, aucun alias court. */
export function parseArgs(argv) {
  const value = (flag, fallback) => {
    const i = argv.indexOf(flag);
    return i !== -1 && argv[i + 1] !== undefined ? argv[i + 1] : fallback;
  };
  const positive = (raw, fallback) => {
    const n = Number.parseInt(raw, 10);
    return Number.isFinite(n) && n > 0 ? n : fallback;
  };
  return {
    apply: argv.includes("--apply"),
    limit: positive(value("--limit", ""), DEFAULT_LIMIT),
    rounds: positive(value("--rounds", ""), DEFAULT_ROUNDS),
    baseUrl: value("--base-url", defaultBaseUrl()),
  };
}

/**
 * Une tranche. Rend le corps JSON, ou lève.
 *
 * Le secret voyage en en-tête `Authorization`, jamais dans l'URL : une URL finit
 * dans un journal d'accès, un en-tête non.
 */
async function runRound({ baseUrl, secret, dryRun, limit, after }) {
  const response = await fetch(`${baseUrl}/api/cron/digest`, {
    method: "POST",
    headers: {
      authorization: `Bearer ${secret}`,
      "content-type": "application/json",
    },
    body: JSON.stringify({ dryRun, limit, after }),
    signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new Error(`HTTP ${response.status} ${detail.slice(0, 200)}`);
  }
  return response.json();
}

async function main() {
  const args = parseArgs(process.argv.slice(2));

  const secret = process.env.CRON_SECRET;
  if (!secret) {
    console.log("[digests] CRON_SECRET absent — rien à déclencher, sortie propre.");
    return;
  }

  if (!args.baseUrl.startsWith("https://")) {
    // Le secret part dans cet en-tête : il ne quitte le poste qu'en TLS.
    console.error(`[digests] --base-url doit être en https (reçu « ${args.baseUrl} »).`);
    process.exit(1);
  }

  const dryRun = !args.apply;
  console.log(
    `[digests] ${dryRun ? "RÉPÉTITION" : "PRODUCTION"} — ${args.baseUrl}, ` +
      `${args.limit} bilan(s) d'élève par tranche, ${args.rounds} tranches au plus.`,
  );

  const total = { examined: 0, written: 0, skippedEmpty: 0, skippedDone: 0, degraded: 0 };
  let after = null;
  let weekStart = null;
  let round = 0;

  for (; round < args.rounds; round += 1) {
    let summary;
    try {
      summary = await runRound({ baseUrl: args.baseUrl, secret, dryRun, limit: args.limit, after });
    } catch (err) {
      // UN seul réessai, sur le MÊME curseur. Une tranche interrompue en cours
      // d'écriture est rejouable telle quelle : le serveur saute les audiences
      // déjà stockées AVANT toute dépense, donc rien n'est payé deux fois.
      console.warn(
        `[digests] tranche ${round + 1} en échec (${err?.message ?? err}) — un réessai.`,
      );
      summary = await runRound({ baseUrl: args.baseUrl, secret, dryRun, limit: args.limit, after });
    }

    weekStart = summary.weekStart ?? weekStart;
    total.examined += summary.examined ?? 0;
    total.written += summary.written ?? 0;
    total.skippedEmpty += summary.skippedEmpty ?? 0;
    total.skippedDone += summary.skippedDone ?? 0;
    total.degraded += summary.degraded ?? 0;

    // UNE seule condition d'arrêt, et c'est la bonne : plus d'élève après le
    // curseur. On ne s'arrête surtout PAS sur « peu de bilans écrits dans cette
    // tranche » — le serveur parcourt les élèves par ordre d'id, et une page
    // entière peut légitimement n'en produire aucun (semaines vides, bilans déjà
    // écrits) alors que les suivants attendent. C'est le mode d'échec qui prive
    // silencieusement de bilan tout le bas de l'alphabet.
    if (!summary.lastStudentId) break;
    after = summary.lastStudentId;
  }

  const exhausted = round >= args.rounds;
  console.log(
    `[digests] semaine ${weekStart ?? "?"} — ${total.examined} élève(s) examinés, ` +
      `${total.written} bilan(s) ${dryRun ? "à écrire" : "écrits"}, ` +
      `${total.skippedEmpty} semaine(s) vide(s), ${total.skippedDone} déjà écrit(s), ` +
      `${total.degraded} dégradé(s).`,
  );

  if (exhausted) {
    // Ce n'est PAS un échec : les bilans produits sont bons, et le reste sera
    // pris au prochain déclenchement. Mais ça se dit, sinon la base grossit et
    // les derniers élèves de l'alphabet n'ont plus jamais de bilan.
    console.warn(
      `[digests] plafond de ${args.rounds} tranches atteint — relancer, ou relever --rounds.`,
    );
  }
  if (total.degraded > 0) {
    // R-15 : un bilan dégradé est un état, pas une panne. L'écran sait le dire,
    // le workflow reste vert, et le compte se lit dans ce journal.
    console.warn(`[digests] ${total.degraded} bilan(s) non produits (refus ou sortie rejetée).`);
  }
}

// CLI seulement — les aides pures restent importables.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main().catch((err) => {
    console.error(`[digests] Échec : ${err?.message ?? err}`);
    process.exit(1);
  });
}
