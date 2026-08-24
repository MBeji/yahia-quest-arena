/**
 * Applique les statuts que le triage a DÉJÀ recommandés, sans geste humain.
 *
 * POURQUOI CE FICHIER EXISTE — le 2026-08-24, `STATUS.md` portait encore une
 * ligne « en attente d'un humain » intitulée « le geste opérateur de triage » :
 * deux signalements restaient `open` en production alors que leur sort était
 * décidé, écrit, et réaffirmé TROIS fois (#651, #658, #673). Le pré-vol du
 * triage le disait à chaque passage :
 *
 *     [triage-pregate] open=2 fresh=0 clusters=2 → stale-handled,
 *     last reminded 25 days ago (>14)
 *
 * Appliquer une recommandation déjà écrite n'est pas une décision, c'est de
 * l'exécution — et l'exécution ne remonte pas au propriétaire
 * (docs/agents/zero-intervention.md). La ligne n'existait que faute de
 * mécanisme : `report-close.yml` ne sait clôturer qu'au merge d'une PR portant
 * des trailers `Report-Id:`, jamais rétroactivement. Ce script est ce mécanisme.
 *
 * CE QU'IL NE FAIT PAS, ET C'EST L'ESSENTIEL — il ne JUGE rien. Il ne relit pas
 * un signalement, ne décide pas d'un statut, n'invente aucune recommandation.
 * Il lit celles que l'agent de triage a écrites dans son issue de suivi, et les
 * exécute. Toute la sécurité tient là : la décision est ailleurs, antérieure,
 * signée et relisible par un humain à tout moment dans l'issue.
 *
 * LES QUATRE GARDES, et le raisonnement de chacune :
 *
 *   1. MATURATION — une recommandation ne s'applique qu'après `--min-age-days`
 *      (7 par défaut), compté sur la CRÉATION de l'issue. C'est ce qui distingue
 *      « supprimer le besoin d'un geste humain » de « supprimer la possibilité
 *      d'un avis humain » : personne n'est OBLIGÉ d'agir, tout le monde reste
 *      LIBRE d'objecter pendant une semaine. On compte sur `created_at` et non
 *      `updated_at` à dessein — le triage commente ses propres rappels, ce qui
 *      remettrait le compteur à zéro à chaque passage et n'appliquerait jamais
 *      rien.
 *
 *   2. IDS TRONQUÉS — l'issue #673 écrit ses ids sur 8 caractères (`f6aed6b2`)
 *      alors que `resolve-reports.mjs` exige l'UUID canonique complet. Le pont
 *      est un préfixe résolu contre les signalements RÉELLEMENT ouverts, et il
 *      exige une correspondance UNIQUE : zéro ou deux candidats ⇒ on saute et on
 *      le dit. Deviner ici, ce serait clore le mauvais signalement — le genre
 *      d'erreur qu'aucun revert ne rattrape, puisque l'écriture part en prod.
 *
 *   3. STATUTS FERMÉS — `dismissed` et `resolved`, rien d'autre. La même liste
 *      blanche que le writer, répétée ici pour que la lecture ne puisse pas
 *      produire ce que l'écriture refuserait.
 *
 *   4. IDEMPOTENCE — le writer ne touche que les lignes encore `open`. Rejouer
 *      ce script est donc sans effet, ce qui autorise un cron sans état.
 *
 * Le script n'écrit RIEN lui-même : il produit des trailers `Report-Id:` que
 * `resolve-reports.mjs` consomme. Un seul chemin d'écriture dans tout le
 * pipeline, déjà éprouvé — on ne s'en fabrique pas un second.
 */

/** Les deux seuls statuts applicables. Même liste blanche que le writer. */
export const APPLICABLE_STATUSES = ["dismissed", "resolved"];

/** Un id est-il déjà l'UUID canonique complet ? */
const FULL_UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;

/**
 * Extrait les recommandations du tableau de clôture d'une issue de triage.
 *
 * Le tableau a cette forme (Phase 5 du skill `report-triage`) :
 *
 *   | Report id | Canal | Verdict sécurité | … | Statut recommandé | Motif |
 *   | `f6aed6b2` | bug | ⚠️ SUSPECT | … | **dismissed** | … |
 *
 * On est strict sur la forme et permissif sur l'ordre des colonnes : l'id est
 * cherché dans la 1ʳᵉ cellule, le canal dans la 2ᵉ, et le statut est le premier
 * mot de la liste blanche trouvé dans le reste de la ligne. Une ligne qui ne
 * donne pas les trois est ignorée, jamais devinée.
 *
 * @param {string} body corps markdown de l'issue de suivi
 * @returns {{ id: string, channel: "bug"|"content", status: string }[]}
 */
export function parseRecommendations(body) {
  const out = [];
  const seen = new Set();
  for (const line of String(body ?? "").split(/\r?\n/)) {
    if (!line.trimStart().startsWith("|")) continue;
    const cells = line.split("|").map((c) => c.trim());
    // cells[0] est vide (la ligne commence par « | »).
    const idCell = cells[1] ?? "";
    const channelCell = (cells[2] ?? "").toLowerCase();

    const idMatch = idCell.match(/`([0-9a-f][0-9a-f-]{5,})`/i);
    if (!idMatch) continue;
    const channel = channelCell.includes("content")
      ? "content"
      : channelCell.includes("bug")
        ? "bug"
        : null;
    if (!channel) continue;

    const rest = cells.slice(3).join(" ").toLowerCase();
    const status = APPLICABLE_STATUSES.find((s) => rest.includes(s));
    if (!status) continue;

    const id = idMatch[1].toLowerCase();
    const key = `${channel}:${id}`;
    if (seen.has(key)) continue;
    seen.add(key);
    out.push({ id, channel, status });
  }
  return out;
}

/**
 * Résout un id — complet ou tronqué — contre les signalements ouverts.
 *
 * Exige une correspondance UNIQUE. Retourne `null` quand il y en a zéro (le
 * signalement a été clos entre-temps : rien à faire) ou plusieurs (ambiguïté :
 * on refuse plutôt que de tirer au sort).
 *
 * @param {string} id id canonique ou préfixe
 * @param {readonly {id: string}[]} openReports signalements encore ouverts du canal
 * @returns {{ resolved: string|null, reason: "exact"|"prefix"|"absent"|"ambigu" }}
 */
export function resolveReportId(id, openReports) {
  const ids = (openReports ?? []).map((r) => String(r.id).toLowerCase());
  if (FULL_UUID.test(id)) {
    return ids.includes(id)
      ? { resolved: id, reason: "exact" }
      : { resolved: null, reason: "absent" };
  }
  const matches = ids.filter((full) => full.startsWith(id));
  if (matches.length === 1) return { resolved: matches[0], reason: "prefix" };
  return { resolved: null, reason: matches.length === 0 ? "absent" : "ambigu" };
}

/**
 * Une issue est-elle assez mûre pour que ses recommandations s'appliquent ?
 *
 * @param {string} createdAt date ISO de création de l'issue
 * @param {string} now date ISO de référence
 * @param {number} minAgeDays délai de maturation
 */
export function isMature(createdAt, now, minAgeDays) {
  const ageMs = Date.parse(now) - Date.parse(createdAt);
  if (!Number.isFinite(ageMs)) return false;
  return ageMs >= minAgeDays * 24 * 60 * 60 * 1000;
}

/**
 * Décide, sans rien écrire, ce qui doit être appliqué.
 *
 * @param {object} input
 * @param {readonly {number: number, createdAt: string, body: string}[]} input.issues
 * @param {{bugReports: readonly {id: string}[], contentReports: readonly {id: string}[]}} input.open
 * @param {string} input.now
 * @param {number} input.minAgeDays
 * @returns {{ apply: {id: string, channel: string, status: string, issue: number}[],
 *             skipped: {id: string, channel: string, issue: number, why: string}[] }}
 */
export function planApplications({ issues, open, now, minAgeDays }) {
  const apply = [];
  const skipped = [];
  for (const issue of issues ?? []) {
    if (!isMature(issue.createdAt, now, minAgeDays)) {
      skipped.push({
        id: "*",
        channel: "*",
        issue: issue.number,
        why: `issue trop récente (< ${minAgeDays} j) — délai d'objection en cours`,
      });
      continue;
    }
    for (const rec of parseRecommendations(issue.body)) {
      const pool = rec.channel === "bug" ? open.bugReports : open.contentReports;
      const { resolved, reason } = resolveReportId(rec.id, pool);
      if (resolved) {
        apply.push({ id: resolved, channel: rec.channel, status: rec.status, issue: issue.number });
      } else {
        skipped.push({
          id: rec.id,
          channel: rec.channel,
          issue: issue.number,
          why:
            reason === "absent"
              ? "déjà clos ou introuvable parmi les signalements ouverts"
              : "préfixe ambigu — plusieurs signalements ouverts correspondent",
        });
      }
    }
  }
  return { apply, skipped };
}

/**
 * Rend les trailers `Report-Id:` d'un statut donné, au format exact attendu par
 * `resolve-reports.mjs`. Un appel du writer par statut.
 *
 * @param {readonly {id: string, channel: string, status: string}[]} planned
 * @param {string} status
 */
export function renderTrailers(planned, status) {
  return (planned ?? [])
    .filter((p) => p.status === status)
    .map((p) => `Report-Id: ${p.id} (${p.channel})`)
    .join("\n");
}

/**
 * Rend un commentaire par issue : ce qui a été appliqué, et ce qui a été ÉCARTÉ.
 *
 * La seconde liste compte plus que la première. Un mécanisme qui applique en
 * silence et tait ce qu'il n'a pas su faire est exactement la panne muette que
 * tout ce pipeline cherche à éviter : un préfixe ambigu écarté sans le dire
 * laisserait un signalement ouvert pour toujours, et personne ne saurait
 * pourquoi.
 *
 * Vit ici et non dans le YAML pour être testable — la leçon du 2026-08-24, où
 * du shell non éprouvé glissé dans un workflow a cassé auto-pr pour tout le
 * dépôt.
 *
 * @param {{ apply: readonly object[], skipped: readonly object[] }} plan
 * @param {boolean} dryRun
 * @returns {{ issue: number, body: string }[]}
 */
export function renderIssueComments(plan, dryRun) {
  /** @type {Map<number, {apply: object[], skipped: object[]}>} */
  const byIssue = new Map();
  const bucket = (n) => {
    if (!byIssue.has(n)) byIssue.set(n, { apply: [], skipped: [] });
    return byIssue.get(n);
  };
  for (const a of plan?.apply ?? []) bucket(a.issue).apply.push(a);
  for (const s of plan?.skipped ?? []) if (s.issue != null) bucket(s.issue).skipped.push(s);

  const out = [];
  for (const [issue, { apply, skipped }] of byIssue) {
    if (apply.length === 0 && skipped.length === 0) continue;
    let body = dryRun
      ? "### 🧪 Simulation — aucune écriture\n\n"
      : "### 🤖 Recommandations appliquées\n\n";
    if (apply.length > 0) {
      body += "| Signalement | Canal | Statut appliqué |\n| --- | --- | --- |\n";
      for (const a of apply) body += `| \`${a.id}\` | ${a.channel} | **${a.status}** |\n`;
    } else {
      body += "_Aucune recommandation applicable à ce passage._\n";
    }
    if (skipped.length > 0) {
      body += "\n**Écartés, et pourquoi** — cette liste compte plus que la précédente :\n\n";
      for (const s of skipped) body += `- \`${s.id}\` (${s.channel}) — ${s.why}\n`;
    }
    body +=
      "\n_Posé par `report-apply.yml`. Le statut vient du tableau de clôture ci-dessus, écrit par le triage :" +
      " ce workflow ne juge rien, il exécute. L'issue reste OUVERTE pour relecture._\n";
    out.push({ issue, body });
  }
  return out;
}
