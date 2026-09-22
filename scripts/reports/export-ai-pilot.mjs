/**
 * LE PILOTE DE L'ÉTAGE IA, ENFIN MESURÉ — é29 §1.4, é11 Q-9.
 *
 * ── POURQUOI CE SCRIPT EXISTE ──────────────────────────────────────────────
 *
 * `STATUS.md` §8 rang 0 portait, depuis le 2026-09-01 : « Le pilote tourne ;
 * **verdict attendu vers le 2026-09-15**. » Constaté le 2026-09-22 en
 * rafraîchissant le topo : cette date était passée depuis une semaine et AUCUN
 * verdict n'était écrit nulle part. Le pilote a donc tourné trois semaines sans
 * que sa mesure soit relevée — et la ligne disait déjà, en toutes lettres, « ce
 * qui reste à faire est la MESURE, pas le geste ».
 *
 * Rien ne manquait qu'un rapport : é29 §1.4 pose ses KPI et précise « tous
 * calculables depuis les tables de cette étude — aucun tracker tiers ». Ils
 * l'étaient. Personne ne les avait calculés.
 *
 * ⚠️ Une divergence à connaître, et elle va dans le sens INVERSE de l'habituel :
 * les `ETUDE.md` de é11 et é29 écrivent encore « le pilote de deux semaines n'a
 * pas eu lieu, aucune clé réelle n'a été branchée ». C'était vrai à leur
 * livraison (2026-08-22) et faux depuis le 2026-09-01. `etudes:check` garde le
 * STATUT d'une étude, pas le corps de sa section « ce qui reste ouvert » — c'est
 * `STATUS.md` qui fait foi sur l'ÉTAT, et é11 le dit lui-même.
 *
 * ── CE QU'IL MESURE, ET CE QU'IL REFUSE DE MESURER ─────────────────────────
 *
 * Les quatre familles de KPI de é29 §1.4, moins ce qui n'est plus mesurable :
 *
 * • ADOPTION — familles à clé `active`, élèves dont le mode est allumé sur les
 *   élèves liés, et la MÉDIANE des interactions par élève et par semaine. Une
 *   moyenne mentirait : un élève curieux un soir porterait la mesure de tous.
 *
 * • FACTURE — dépense mensuelle médiane par famille (cible ≤ 3 $) et part des
 *   familles ayant touché un plafond (cible < 10 % : au-delà, c'est le plafond
 *   par défaut qui est mal calibré, pas la famille).
 *
 *   ⚠️ Le KPI « dépassements NON stoppés : 0, strictement » **n'est plus
 *   mesurable**, et ce script ne fabrique pas un zéro rassurant. Décision
 *   produit du 2026-08-22 (arena#811) : les plafonds ne COUPENT plus par défaut,
 *   `limits_enforced` vaut `false` à la création. é29 l'écrit : « plus rien ne
 *   stoppe ». Ce qui est rendu à la place est le fait brut — combien de familles
 *   tournent sans coupure — parce qu'un indicateur devenu faux doit disparaître
 *   en le disant, pas se taire.
 *
 * • QUALITÉ — taux de rebut de la Forge (cible < 20 %) et ratio 👍/👎 par
 *   modèle. é29 appelait ce tableau « la donnée que personne n'a aujourd'hui » :
 *   c'est lui qui dira si un modèle bon marché tient la barre.
 *
 * • SÉCURITÉ — hors de ce rapport, à dessein. « 0 fuite de clé » se mesure par
 *   les tests pgTAP d'absence de privilège et la garde de log, pas par un
 *   comptage : un rapport qui rendrait « 0 fuite » ne mesurerait que son propre
 *   silence.
 *
 * ── CE QU'IL NE FAIT PAS ───────────────────────────────────────────────────
 *
 * Il ne rend AUCUN verdict. Les cibles sont confrontées aux mesures et l'écart
 * est nommé, mais « le pilote est-il concluant » est un arbitrage du porteur du
 * produit — et un arbitrage qu'un script ne prend pas. Il ne lit rien d'autre
 * que les tables de é29, ne déchiffre aucune clé (`secret_enc` n'est jamais
 * sélectionné) et n'écrit rien.
 */

import { existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

/** Cibles de é29 §1.4, recopiées telles quelles — jamais recalées sur la mesure du jour. */
export const CIBLES = {
  /** Dépense mensuelle médiane par famille, en dollars. */
  depenseMensuelleMedianeUsd: 3,
  /** Part des familles ayant touché un plafond. Au-delà, c'est le plafond qui est mal réglé. */
  partFamillesAuPlafond: 0.1,
  /** Taux de rebut de la Forge. Au-delà de 50 % sur une famille : conseil de modèle (R-19). */
  tauxRebutForge: 0.2,
};

/**
 * Médiane d'une série numérique. `null` sur une série vide — pas `0`, qui se
 * lirait « mesuré à zéro » au lieu de « rien à mesurer ». C'est la distinction
 * que #1071 a dû rétablir ailleurs après qu'un `0` de repli eut été pris pour
 * une mesure.
 */
export function mediane(valeurs) {
  const tri = valeurs.filter((n) => Number.isFinite(n)).sort((a, b) => a - b);
  if (tri.length === 0) return null;
  const mid = Math.floor(tri.length / 2);
  return tri.length % 2 === 1 ? tri[mid] : (tri[mid - 1] + tri[mid]) / 2;
}

/** Lundi (UTC) de la semaine d'un horodatage ISO — la semaine d'é31, pas celle du runner. */
export function lundiDe(iso) {
  const d = new Date(iso);
  const jour = (d.getUTCDay() + 6) % 7; // lundi = 0
  const lundi = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate() - jour));
  return lundi.toISOString().slice(0, 10);
}

/**
 * ADOPTION. `elevesLies` vient d'un compte distinct côté appelant : un élève lié
 * à deux parents ne compte qu'une fois, sinon le dénominateur enfle et le taux
 * baisse sans qu'aucun élève n'ait rien changé.
 */
export function resumeAdoption({ credentials, acces, usages, elevesLies }) {
  const famillesActives = credentials.filter((c) => c.status === "active").length;
  const elevesActives = acces.filter((a) => a.enabled === true).length;

  // Interactions par (élève × semaine), puis médiane. Les lignes sans `user_id`
  // sont des appels non rattachés à un élève (vérification de clé, tâches de
  // plateforme) : elles ne mesurent pas l'usage d'un élève et sortent du calcul.
  const parEleveSemaine = new Map();
  for (const u of usages) {
    if (!u.user_id) continue;
    const cle = `${u.user_id}|${lundiDe(u.created_at)}`;
    parEleveSemaine.set(cle, (parEleveSemaine.get(cle) ?? 0) + 1);
  }

  return {
    famillesAvecCle: credentials.length,
    famillesActives,
    elevesLies,
    elevesActives,
    partElevesActives: elevesLies > 0 ? elevesActives / elevesLies : null,
    interactionsMedianeParEleveSemaine: mediane([...parEleveSemaine.values()]),
    semainesObservees: new Set([...parEleveSemaine.keys()].map((k) => k.split("|")[1])).size,
  };
}

/**
 * FACTURE. Le grand livre porte des micro-dollars par (propriétaire × jour) ;
 * on agrège au mois, puis on prend la médiane des couples (famille × mois).
 */
export function resumeFacture({ credentials, spend }) {
  const parFamilleMois = new Map();
  for (const l of spend) {
    const cle = `${l.owner_user_id}|${String(l.day).slice(0, 7)}`;
    parFamilleMois.set(cle, (parFamilleMois.get(cle) ?? 0) + Number(l.spent_micros ?? 0));
  }
  const usdParFamilleMois = [...parFamilleMois.values()].map((m) => m / 1_000_000);

  // « Avoir touché son plafond » se lit contre le plafond de CETTE famille, pas
  // contre une valeur moyenne : chacune peut avoir réglé le sien.
  const plafondMensuel = new Map(
    credentials.map((c) => [c.owner_user_id, Number(c.monthly_budget_usd ?? 0)]),
  );
  const famillesAuPlafond = new Set();
  for (const [cle, micros] of parFamilleMois) {
    const owner = cle.split("|")[0];
    const plafond = plafondMensuel.get(owner);
    if (plafond && micros / 1_000_000 >= plafond) famillesAuPlafond.add(owner);
  }
  const famillesAvecDepense = new Set([...parFamilleMois.keys()].map((k) => k.split("|")[0]));

  return {
    depenseMensuelleMedianeUsd: mediane(usdParFamilleMois),
    depenseTotaleUsd: usdParFamilleMois.reduce((a, b) => a + b, 0),
    famillesAvecDepense: famillesAvecDepense.size,
    famillesAuPlafond: famillesAuPlafond.size,
    partFamillesAuPlafond:
      famillesAvecDepense.size > 0 ? famillesAuPlafond.size / famillesAvecDepense.size : null,
    /**
     * Le remplaçant HONNÊTE du KPI « dépassements non stoppés : 0 », devenu
     * immesurable le 2026-08-22 — plus rien ne stoppe tant que le porteur n'a pas
     * armé `limits_enforced`. On rend le fait, pas un zéro rassurant.
     */
    famillesSansCoupure: credentials.filter((c) => c.limits_enforced === false).length,
    kpiDepassementsNonStoppes: "immesurable depuis le 2026-08-22 (arena#811) — voir l'en-tête",
  };
}

/** QUALITÉ. Rebut de la Forge, et le tableau 👍/👎 par modèle que personne n'avait. */
export function resumeQualite({ forges, feedback }) {
  const demandes = forges.reduce((a, f) => a + Number(f.requested ?? 0), 0);
  const rebutes = forges.reduce((a, f) => a + Number(f.discarded ?? 0), 0);

  const parModele = new Map();
  for (const f of feedback) {
    const e = parModele.get(f.model) ?? { model: f.model, up: 0, down: 0 };
    if (f.verdict === "up") e.up += 1;
    else if (f.verdict === "down") e.down += 1;
    parModele.set(f.model, e);
  }

  return {
    forgesDemandees: demandes,
    forgesRebutees: rebutes,
    tauxRebutForge: demandes > 0 ? rebutes / demandes : null,
    /** Trié par volume : le modèle le plus jugé passe en tête, c'est celui qui décide. */
    parModele: [...parModele.values()]
      .map((e) => ({
        ...e,
        total: e.up + e.down,
        ratio: e.up + e.down > 0 ? e.up / (e.up + e.down) : null,
      }))
      .sort((a, b) => b.total - a.total),
  };
}

/**
 * Confronte les mesures aux cibles de é29 §1.4. Rend des CONSTATS, jamais un
 * verdict : « le pilote est-il concluant » est un arbitrage du porteur.
 * Une mesure absente rend `inconnu` — elle ne compte ni pour ni contre.
 */
export function confronterAuxCibles({ adoption, facture, qualite }) {
  const ligne = (nom, mesure, cible, atteinte) => ({
    nom,
    mesure,
    cible,
    etat: mesure === null ? "inconnu" : atteinte ? "atteinte" : "écart",
  });

  return [
    ligne(
      "dépense mensuelle médiane par famille",
      facture.depenseMensuelleMedianeUsd,
      `≤ ${CIBLES.depenseMensuelleMedianeUsd} $`,
      facture.depenseMensuelleMedianeUsd !== null &&
        facture.depenseMensuelleMedianeUsd <= CIBLES.depenseMensuelleMedianeUsd,
    ),
    ligne(
      "part des familles ayant touché un plafond",
      facture.partFamillesAuPlafond,
      `< ${CIBLES.partFamillesAuPlafond * 100} %`,
      facture.partFamillesAuPlafond !== null &&
        facture.partFamillesAuPlafond < CIBLES.partFamillesAuPlafond,
    ),
    ligne(
      "taux de rebut de la Forge",
      qualite.tauxRebutForge,
      `< ${CIBLES.tauxRebutForge * 100} %`,
      qualite.tauxRebutForge !== null && qualite.tauxRebutForge < CIBLES.tauxRebutForge,
    ),
    {
      nom: "interactions médianes par élève et par semaine",
      mesure: adoption.interactionsMedianeParEleveSemaine,
      cible: "aucune — é29 §1.4 la demande sans la chiffrer",
      etat: adoption.interactionsMedianeParEleveSemaine === null ? "inconnu" : "relevé",
    },
  ];
}

const pct = (x) => (x === null || x === undefined ? "—" : `${(x * 100).toFixed(1)} %`);
const usd = (x) => (x === null || x === undefined ? "—" : `${x.toFixed(2)} $`);
const num = (x) => (x === null || x === undefined ? "—" : String(x));

/**
 * Le rapport en Markdown, pour le corps d'issue.
 *
 * ⚠️ Un tiret cadratin partout où la mesure est ABSENTE, jamais un zéro. Une
 * issue qui afficherait « 0,00 $ » sur une base vide ferait conclure « le pilote
 * ne coûte rien » au lieu de « le pilote n'a rien produit » — et c'est la
 * deuxième lecture qui compte pour un verdict.
 */
export function formatMarkdown(r) {
  const l = [];
  l.push(`### 🤖 Pilote de l'étage IA — relevé sur ${r.fenetre.jours} jours`);
  l.push("");
  l.push("Les KPI de **é29 §1.4**, « tous calculables depuis les tables de cette étude — aucun");
  l.push("tracker tiers ». Ce relevé **ne rend aucun verdict** : il mesure, et l'écart aux");
  l.push("cibles est nommé. « Le pilote est-il concluant » reste un arbitrage du porteur.");
  l.push("");
  l.push("#### Adoption");
  l.push("");
  l.push("| mesure | valeur |");
  l.push("| --- | ---: |");
  l.push(`| familles ayant saisi une clé | ${num(r.adoption.famillesAvecCle)} |`);
  l.push(`| dont clé **active** | ${num(r.adoption.famillesActives)} |`);
  l.push(`| élèves liés | ${num(r.adoption.elevesLies)} |`);
  l.push(
    `| élèves dont le mode est allumé | ${num(r.adoption.elevesActives)} (${pct(r.adoption.partElevesActives)}) |`,
  );
  l.push(
    `| interactions **médianes** par élève et par semaine | ${num(r.adoption.interactionsMedianeParEleveSemaine)} |`,
  );
  l.push(`| semaines observées | ${num(r.adoption.semainesObservees)} |`);
  l.push("");
  l.push("#### Tenue de la facture");
  l.push("");
  l.push("| mesure | valeur | cible |");
  l.push("| --- | ---: | ---: |");
  l.push(
    `| dépense mensuelle **médiane** par famille | ${usd(r.facture.depenseMensuelleMedianeUsd)} | ≤ ${r.cibles.depenseMensuelleMedianeUsd} $ |`,
  );
  l.push(`| dépense totale sur la fenêtre | ${usd(r.facture.depenseTotaleUsd)} | — |`);
  l.push(
    `| familles ayant touché un plafond | ${num(r.facture.famillesAuPlafond)} (${pct(r.facture.partFamillesAuPlafond)}) | < ${r.cibles.partFamillesAuPlafond * 100} % |`,
  );
  l.push("");
  l.push(`⚠️ **Le KPI « dépassements non stoppés : 0, strictement » n'est plus mesurable.**`);
  l.push("Décision produit du 2026-08-22 (#811) : les plafonds ne **coupent** plus par défaut.");
  l.push(
    `À la place, le fait brut — **${num(r.facture.famillesSansCoupure)}** famille(s) tournent sans coupure armée.`,
  );
  l.push("Un indicateur devenu faux se retire en le disant ; il ne se remplace pas par un zéro.");
  l.push("");
  l.push("#### Qualité sous modèle libre");
  l.push("");
  l.push(
    `Rebut de la Forge : **${pct(r.qualite.tauxRebutForge)}** (cible < ${r.cibles.tauxRebutForge * 100} %) — ${num(r.qualite.forgesRebutees)} rebutées sur ${num(r.qualite.forgesDemandees)} demandées.`,
  );
  l.push("");
  if (r.qualite.parModele.length === 0) {
    l.push("_Aucun 👍/👎 sur la fenêtre — le tableau que é29 appelait « la donnée que personne");
    l.push("n'a aujourd'hui » reste vide. C'est une absence de mesure, pas un verdict neutre._");
  } else {
    l.push("| modèle | 👍 | 👎 | ratio |");
    l.push("| --- | ---: | ---: | ---: |");
    for (const m of r.qualite.parModele) {
      l.push(`| \`${m.model}\` | ${m.up} | ${m.down} | ${pct(m.ratio)} |`);
    }
  }
  l.push("");
  l.push("#### Écart aux cibles");
  l.push("");
  l.push("| KPI | mesure | cible | état |");
  l.push("| --- | ---: | ---: | --- |");
  for (const c of r.confrontation) {
    const icone = { atteinte: "✅", écart: "⚠️", inconnu: "❓", relevé: "📊" }[c.etat] ?? "";
    l.push(`| ${c.nom} | ${num(c.mesure)} | ${c.cible} | ${icone} ${c.etat} |`);
  }
  l.push("");
  l.push(
    `_Relevé le ${r.generatedAt.slice(0, 10)}, fenêtre de ${r.fenetre.jours} jours depuis ${r.fenetre.depuis.slice(0, 10)}._`,
  );
  return l.join("\n");
}

/** `--days N`, ou 30. Une valeur non numérique est une erreur, pas un défaut. */
export function readDays(argv) {
  const i = argv.indexOf("--days");
  if (i === -1) return 30;
  const n = Number(argv[i + 1]);
  if (!Number.isFinite(n) || n <= 0) {
    throw new Error(`[ai-pilot] --days attend un nombre > 0, reçu « ${argv[i + 1]} ».`);
  }
  return n;
}

async function main() {
  const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..", "..");
  const envPath = resolve(repoRoot, ".env");
  if (existsSync(envPath)) {
    const { default: dotenv } = await import("dotenv");
    dotenv.config({ path: envPath, override: false });
  }

  const url = process.env.SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceKey) {
    console.error(
      "[ai-pilot] SUPABASE_URL et/ou SUPABASE_SERVICE_ROLE_KEY manquants. " +
        "Les tables de é29 sont en RLS et leurs privilèges REVOKE : seule la service-role key y lit.",
    );
    process.exit(1);
  }

  let days;
  try {
    days = readDays(process.argv);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
  const since = new Date(Date.now() - days * 86_400_000).toISOString();

  const { createClient } = await import("@supabase/supabase-js");
  const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

  // ⚠️ `secret_enc` n'est JAMAIS sélectionné. Un rapport n'a aucune raison de
  // faire transiter une clé chiffrée, et la seule façon sûre de ne pas la
  // journaliser par accident est de ne pas la lire.
  const lectures = {
    credentials: supabase
      .from("ai_credentials")
      .select(
        "owner_user_id, status, provider, monthly_budget_usd, daily_budget_usd, limits_enforced, created_at",
      ),
    acces: supabase.from("ai_student_access").select("student_user_id, owner_user_id, enabled"),
    usages: supabase
      .from("ai_usage_events")
      .select("user_id, created_at, model, status, feature")
      .gte("created_at", since),
    spend: supabase
      .from("ai_spend_ledger")
      .select("owner_user_id, day, spent_micros")
      .gte("day", since.slice(0, 10)),
    feedback: supabase
      .from("ai_feedback")
      .select("model, verdict, created_at")
      .gte("created_at", since),
    forges: supabase
      .from("ai_forged_quizzes")
      .select("model, requested, discarded, created_at")
      .gte("created_at", since),
    liens: supabase.from("parent_student_links").select("student_user_id").eq("is_active", true),
  };

  const rows = {};
  for (const [nom, q] of Object.entries(lectures)) {
    const { data, error } = await q;
    if (error) {
      console.error(`[ai-pilot] lecture de ${nom} : ${error.message}`);
      process.exit(1);
    }
    rows[nom] = data ?? [];
  }

  const elevesLies = new Set(rows.liens.map((l) => l.student_user_id)).size;
  const adoption = resumeAdoption({
    credentials: rows.credentials,
    acces: rows.acces,
    usages: rows.usages,
    elevesLies,
  });
  const facture = resumeFacture({ credentials: rows.credentials, spend: rows.spend });
  const qualite = resumeQualite({ forges: rows.forges, feedback: rows.feedback });

  const rapport = {
    generatedAt: new Date().toISOString(),
    fenetre: { jours: days, depuis: since },
    adoption,
    facture,
    qualite,
    confrontation: confronterAuxCibles({ adoption, facture, qualite }),
    cibles: CIBLES,
    source: "é29 §1.4 — aucun tracker tiers",
  };

  if (process.argv.includes("--markdown")) {
    process.stdout.write(`${formatMarkdown(rapport)}\n`);
    return;
  }

  const outIdx = process.argv.indexOf("--out");
  if (outIdx !== -1 && process.argv[outIdx + 1]) {
    const { writeFileSync } = await import("node:fs");
    writeFileSync(process.argv[outIdx + 1], `${JSON.stringify(rapport, null, 2)}\n`, "utf8");
    console.error(`[ai-pilot] rapport écrit dans ${process.argv[outIdx + 1]}`);
  } else {
    process.stdout.write(`${JSON.stringify(rapport, null, 2)}\n`);
  }
}

if (process.argv[1] && fileURLToPath(import.meta.url) === resolve(process.argv[1])) {
  await main();
}
