/**
 * Ouverture des parcours, rejouée depuis les migrations (pure, aucune I/O).
 *
 * Le problème qu'il résout : une classe dont le contenu est généré, mergé et
 * appliqué reste **invisible aux élèves** tant que son parcours est
 * `coming_soon` — la bascule est une migration `UPDATE public.parcours SET
 * status = 'available'` (seuil R-8, étude 16), donc un geste séparé du contenu.
 * Rien ne le signalait : ni les gates de contenu (qui ne connaissent pas la
 * base), ni `programme:etat` (qui ne lisait que fiche × programme × contenu).
 *
 * Pourquoi un rejeu STATIQUE et pas une lecture de la base : il n'y a
 * délibérément aucun accès prod en local ni en CI (AGENTS.md). La vérité
 * reconstructible, elle, est dans le dépôt — même principe que
 * `db:check-chain`. On rejoue donc les migrations dans l'ordre des versions et
 * on garde le DERNIER statut affecté à chaque parcours.
 *
 * Ce qu'il ne fait jamais : deviner. Un parcours dont le statut n'est pas
 * lisible ressort `statut: null` (« inconnu »), jamais « coming_soon » par
 * défaut — un faux « pas ouvert » enverrait quelqu'un écrire une migration
 * inutile, et un faux « ouvert » laisserait la classe invisible.
 */

/** Un parcours tel que les migrations le décrivent. */
export interface ParcoursOuverture {
  id: string;
  /** Slug du grade porteur (`1ere-sec`) ; null pour un parcours sans grade (thème libre). */
  grade: string | null;
  /** Dernier statut affecté par la chaîne ; null = illisible, donc inconnu. */
  statut: "available" | "coming_soon" | null;
  /** Migration qui a posé ce statut (seed ou bascule). */
  migration: string;
}

/** Une migration à rejouer : nom de fichier (pour l'ordre et la trace) + SQL. */
export interface MigrationFile {
  name: string;
  sql: string;
}

export interface OuvertureLue {
  parcours: ParcoursOuverture[];
  /**
   * Ids basculés par une migration alors qu'aucun seed lu ne les crée. On les
   * rapporte au lieu de les taire : c'est le symptôme d'une forme de seed que ce
   * lecteur ne connaît pas encore. À ne pas confondre avec un parcours
   * légitimement sans grade (thème libre : `ib`, `grade_id NULL`), qui est
   * seedé et donc connu.
   */
  ouvertsSansSeed: string[];
}

const STATUT_RE = /'(available|coming_soon)'/g;

/** `-- …` en fin de ligne. Aucun littéral de ces migrations ne contient `--`. */
function stripComments(sql: string): string {
  return sql.replace(/--[^\n]*/g, "");
}

/** Découpe en instructions, en ignorant les `;` internes aux corps `$$ … $$`. */
function statements(sql: string): string[] {
  const out: string[] = [];
  let rest = stripComments(sql);
  // Les fonctions PL/pgSQL portent des `;` qui ne terminent rien : on retire
  // leur corps avant de découper. Aucune n'insère de parcours.
  rest = rest.replace(/\$\$[\s\S]*?\$\$/g, " ");
  for (const raw of rest.split(";")) {
    const trimmed = raw.trim();
    if (trimmed.length > 0) out.push(trimmed);
  }
  return out;
}

/** Dernier statut cité par l'instruction (l'ordre des colonnes le met en fin). */
function lastStatut(fragment: string): ParcoursOuverture["statut"] {
  const found = [...fragment.matchAll(STATUT_RE)].at(-1);
  return found ? (found[1] as "available" | "coming_soon") : null;
}

function quotedList(fragment: string): string[] {
  return [...fragment.matchAll(/'([^']+)'/g)].map((m) => m[1]);
}

/**
 * Les trois formes de seed en usage, chacune reconnue explicitement — une forme
 * inconnue ne produit rien plutôt qu'un rattachement inventé.
 */
function readInsert(stmt: string, migration: string): ParcoursOuverture[] {
  // Forme 3 — VALUES : un tuple par parcours, grade via un sous-select. Le
  // `SELECT` imbriqué du tuple interdit de discriminer sur sa seule présence.
  const values = /\bVALUES\s*\(/i.test(stmt) ? stmt.match(/\bVALUES\b([\s\S]*)$/i) : null;
  if (values) {
    const out: ParcoursOuverture[] = [];
    // Un tuple = `( … )` de premier niveau. Les sous-selects en contiennent
    // d'autres : on découpe en suivant la profondeur de parenthèses.
    let depth = 0;
    let current = "";
    for (const ch of values[1]) {
      if (ch === "(") {
        depth += 1;
        if (depth === 1) {
          current = "";
          continue;
        }
      }
      if (ch === ")") {
        depth -= 1;
        if (depth === 0) {
          const id = quotedList(current)[0];
          const slug = current.match(/slug\s*=\s*'([^']+)'/i)?.[1] ?? null;
          if (id) out.push({ id, grade: slug, statut: lastStatut(current), migration });
          continue;
        }
      }
      if (depth >= 1) current += ch;
    }
    return out;
  }

  const select = stmt.match(/\bSELECT\b([\s\S]*)$/i);
  if (!select) return [];
  const body = select[1];
  const statut = lastStatut(body);
  const slugIn = body.match(/g\.slug\s+IN\s*\(([^)]*)\)/i);
  const slugEq = body.match(/g\.slug\s*=\s*'([^']+)'/i);
  const slugs = slugIn ? quotedList(slugIn[1]) : slugEq ? [slugEq[1]] : [];

  // Forme 1 — id concaténé : `SELECT 'ecole-' || g.slug, …` sur une liste de slugs.
  const concat = body.match(/^\s*'([^']*)'\s*\|\|\s*g\.slug/i);
  if (concat) {
    return slugs.map((slug) => ({
      id: `${concat[1]}${slug}`,
      grade: slug,
      statut,
      migration,
    }));
  }

  // Forme 2 — id littéral pour UN grade : `SELECT 'concours-bac', … g.slug = 'bac'`.
  const literal = body.match(/^\s*'([^']+)'\s*,/);
  if (literal && slugs.length === 1) {
    return [{ id: literal[1], grade: slugs[0], statut, migration }];
  }
  return [];
}

/** `UPDATE public.parcours SET status = 'x' WHERE id = 'a'` / `id IN ('a','b')`. */
function readUpdate(stmt: string): { ids: string[]; statut: ParcoursOuverture["statut"] } | null {
  if (!/^UPDATE\s+public\.parcours\b/i.test(stmt)) return null;
  const statut = stmt.match(/SET\s+status\s*=\s*'(available|coming_soon)'/i)?.[1];
  if (!statut) return null; // `SET status = v_x` (RPC) : rien à rejouer.
  const idIn = stmt.match(/\bid\s+IN\s*\(([^)]*)\)/i);
  const idEq = stmt.match(/\bid\s*=\s*'([^']+)'/i);
  const ids = idIn ? quotedList(idIn[1]) : idEq ? [idEq[1]] : [];
  if (ids.length === 0) return null; // filtre non littéral : on ne devine pas.
  return { ids, statut: statut as "available" | "coming_soon" };
}

/**
 * Rejoue la chaîne et rend l'état d'ouverture de chaque parcours connu.
 *
 * Les fichiers sont triés par nom (= par version, invariant du dépôt) : le
 * dernier statut posé gagne, comme en base. Une bascule sur un parcours
 * qu'aucun seed lu ne rattache à un grade est appliquée quand même — l'id est
 * réel — mais listée dans `sansGrade`.
 */
export function readOuvertures(files: MigrationFile[]): OuvertureLue {
  const byId = new Map<string, ParcoursOuverture>();
  const seeded = new Set<string>();
  const basculesSansSeed = new Set<string>();
  const ordered = [...files].sort((a, b) => a.name.localeCompare(b.name));

  for (const { name, sql } of ordered) {
    if (!sql.includes("public.parcours")) continue;
    for (const stmt of statements(sql)) {
      if (/^INSERT\s+INTO\s+public\.parcours\b/i.test(stmt)) {
        for (const parcours of readInsert(stmt, name)) {
          seeded.add(parcours.id);
          // `ON CONFLICT DO NOTHING` : le premier seed gagne, pas le dernier.
          if (!byId.has(parcours.id)) byId.set(parcours.id, parcours);
        }
        continue;
      }
      const update = readUpdate(stmt);
      if (!update) continue;
      for (const id of update.ids) {
        const known = byId.get(id);
        byId.set(id, {
          id,
          grade: known?.grade ?? null,
          statut: update.statut,
          migration: name,
        });
        if (!seeded.has(id)) basculesSansSeed.add(id);
      }
    }
  }

  return {
    parcours: [...byId.values()].sort((a, b) => a.id.localeCompare(b.id)),
    ouvertsSansSeed: [...basculesSansSeed].sort(),
  };
}

/** Les parcours d'un grade, dans l'ordre des ids (jamais un classement). */
export function parcoursDuGrade(lu: OuvertureLue, grade: string): ParcoursOuverture[] {
  return lu.parcours.filter((p) => p.grade === grade);
}
