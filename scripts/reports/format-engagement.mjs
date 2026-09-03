import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/**
 * LE RELEVÉ D'ENGAGEMENT, MIS EN FORME — é31, suite du 2026-09-03.
 *
 * POURQUOI CE FICHIER EXISTE
 * ---------------------------------------------------------------------------
 * `admin_engagement_overview()` a été livrée le 2026-09-02 et la scorecard
 * STATUS §1bis attendait, ligne 2, « un CHIFFRE DATÉ, pas un instrument ». Ce
 * chiffre ne pouvait venir que d'un humain ouvrant `/admin/engagement` et le
 * recopiant à la main — un geste qui ne se fait pas, et dont l'absence a laissé
 * la ligne à « jamais publiée » pendant six semaines.
 *
 * C'est le barreau « SUPPRIMER LE BESOIN » de `docs/agents/zero-intervention.md` :
 * plutôt que de rappeler à quelqu'un de relever la mesure, on fait en sorte que
 * la mesure se relève.
 *
 * CE QU'IL FAIT, ET SURTOUT CE QU'IL NE FAIT PAS
 * ---------------------------------------------------------------------------
 * Une fonction PURE : le JSON de la RPC entre, du Markdown sort. Aucun appel
 * réseau, aucune connexion, aucun secret — c'est le workflow qui lit la base, et
 * lui seul. Cette séparation n'est pas cosmétique : elle rend la mise en forme
 * TESTABLE sans base, et c'est là que vivent les décisions de lecture qui
 * peuvent mentir.
 *
 * ⚠️ LES DEUX REFUS QUE CE MODULE HÉRITE DE LA RPC, ET QU'IL NE DOIT PAS DÉFAIRE
 * ---------------------------------------------------------------------------
 *   1. Une semaine sans actif rend `null`, JAMAIS `0 %`. « Personne n'est
 *      revenu » et « il n'y avait personne » sont deux faits différents, et les
 *      confondre ferait mentir la courbe dans le sens qui arrange. Un `null`
 *      s'affiche donc « — », il ne se remplace pas par un zéro.
 *   2. La dernière semaine PUBLIABLE est la dernière dont la CURR est calculable
 *      — pas la dernière ligne du tableau. La RPC exclut déjà la semaine en cours
 *      et la précédente (leur suite n'est pas finie) ; on ne va pas la deviner.
 *
 * ⚠️ ET CELUI QU'IL AJOUTE : `n` EST PUBLIÉ À CÔTÉ DU POURCENTAGE, TOUJOURS.
 * Le relevé du 2026-09-03 valait « 60 % » sur CINQ élèves, dont trois revenus.
 * Un « 60 % » qui voyage seul se fait citer comme un taux de rétention produit ;
 * « 60 % (3/5) » ne le peut pas. C'est la même raison qui fait que la cellule de
 * STATUS porte sa réserve dans son texte, pas dans une note de bas de page.
 */

/**
 * Un nombre à la française, ou « — » quand la RPC a refusé d'en inventer un.
 *
 * La virgule décimale n'est pas de la coquetterie : le relevé est lu en français,
 * et le premier run publié a rendu « 1.4 chapitres » à côté de « 73,38 % » —
 * deux séparateurs dans le même tableau.
 */
export function num(value) {
  return value === null || value === undefined ? "—" : String(value).replace(".", ",");
}

/** Un pourcentage, ou « — » quand la RPC a refusé d'en inventer un. */
export function pct(value) {
  return value === null || value === undefined ? "—" : `${num(value)} %`;
}

/** `2026-08-17` → `17/08`. Les semaines se lisent, elles ne se calculent pas. */
export function shortDay(iso) {
  const [, m, d] = String(iso).split("-");
  return `${d}/${m}`;
}

/**
 * La dernière semaine dont la CURR est CALCULABLE — même règle que la console.
 * Rend `null` si aucune ne l'est : c'est un état, pas une erreur.
 */
export function latestMeasurable(curr) {
  return [...curr].reverse().find((w) => w.curr_pct !== null && w.curr_pct !== undefined) ?? null;
}

/**
 * Le cumul sur toute la fenêtre, en PERSONNES-SEMAINES.
 *
 * ⚠️ Ce n'est PAS un taux de rétention par personne : un même élève actif six
 * semaines compte six fois. C'est assumé, et le libellé le dit — sur des `n` à un
 * chiffre, une semaine isolée ne vaut rien (à 1 actif, la CURR ne peut valoir que
 * 0 % ou 100 %), alors que le cumul donne au moins un ordre de grandeur. Le
 * nommer « rétention » serait le mensonge ; le nommer personnes-semaines, non.
 */
export function pooled(curr) {
  const rows = curr.filter((w) => w.curr_pct !== null && w.curr_pct !== undefined);
  const active = rows.reduce((n, w) => n + (w.active ?? 0), 0);
  const returned = rows.reduce((n, w) => n + (w.returned ?? 0), 0);
  return { active, returned, pct: active > 0 ? Math.round((1000 * returned) / active) / 10 : null };
}

/**
 * Le `n` le plus grand de la fenêtre — la grandeur qui dit si le chiffre veut
 * dire quelque chose. Publiée à côté du taux, jamais en dessous.
 */
export function maxActive(curr) {
  return curr.reduce((max, w) => Math.max(max, w.active ?? 0), 0);
}

/** Le relevé complet, en Markdown. `today` est injectable pour les tests. */
export function formatEngagementReport(overview, today = new Date()) {
  const curr = overview?.curr ?? [];
  const stamp = today.toISOString().slice(0, 10);
  const latest = latestMeasurable(curr);
  const cumul = pooled(curr);
  const n = maxActive(curr);
  const lines = [];

  lines.push(`### 📈 Relevé d'engagement — ${stamp}`);
  lines.push("");

  if (latest === null) {
    lines.push(
      "**Aucune semaine mesurable.** Aucun élève actif sur la fenêtre : la CURR n'a rien à",
      "mesurer. C'est un ÉTAT, pas une panne — et c'est celui qu'on attend tant que la ligne 1",
      "de la scorecard (« zéro canal d'acquisition ») tient.",
    );
  } else {
    lines.push(
      `**CURR = ${pct(latest.curr_pct)}** sur la semaine du **${shortDay(latest.week_start)}** ` +
        `— ${latest.returned} élèves revenus sur ${latest.active}.`,
      "",
      `Toutes semaines confondues : **${cumul.returned} retours sur ${cumul.active} ` +
        `personnes-semaines** (${pct(cumul.pct)}).`,
    );
  }

  lines.push("");
  lines.push("| Semaine | Actifs | Revenus | CURR |");
  lines.push("| --- | ---: | ---: | ---: |");
  for (const w of curr) {
    lines.push(
      `| ${shortDay(w.week_start)} | ${w.active ?? 0} | ${w.returned ?? 0} | ${pct(w.curr_pct)} |`,
    );
  }

  const learning = overview?.learning ?? {};
  lines.push("");
  lines.push(
    "**Métrique de garde (R-1)** — l'engagement n'a le droit d'être lu qu'à côté d'elle :",
  );
  lines.push("");
  lines.push("| précision moyenne | précision médiane | chapitres / actif | tentatives (30 j) |");
  lines.push("| ---: | ---: | ---: | ---: |");
  lines.push(
    `| ${pct(learning.accuracy_avg_pct ?? null)} | ${pct(learning.accuracy_p50_pct ?? null)} | ` +
      `${num(learning.chapters_per_active ?? null)} | ${num(learning.attempts_30d ?? null)} |`,
  );

  lines.push("");
  if (n > 0 && n < 30) {
    lines.push(
      `⚠️ **\`n\` culmine à ${n}.** Sur une semaine à 1 actif, la CURR ne peut valoir que 0 % ou`,
      "100 % : ce n'est pas une courbe, c'est du bruit avec une unité. Le taux se lit comme la",
      "preuve que la MESURE fonctionne, pas comme un signal produit — il en redeviendra un le",
      "jour où la ligne 1 de la scorecard amènera un `n` qui supporte une lecture.",
    );
  }
  lines.push("");
  lines.push("_Relevé automatique, lecture seule. La console humaine reste `/admin/engagement`._");
  return lines.join("\n");
}

// ---------------------------------------------------------------------------
// CLI — `npm run reports:engagement -- <fichier.json>`
//
// Séparé de la mise en forme par le garde ci-dessous : importer ce module dans
// un test ne doit rien exécuter. Le fichier vient du workflow (sortie de psql) ;
// aucun accès réseau, aucun secret n'entre ici.
// ---------------------------------------------------------------------------
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const file = process.argv[2];
  if (!file) {
    console.error("usage: node scripts/reports/format-engagement.mjs <overview.json>");
    process.exit(2);
  }
  process.stdout.write(formatEngagementReport(JSON.parse(readFileSync(file, "utf8"))) + "\n");
}
