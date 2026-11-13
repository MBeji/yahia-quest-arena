import { createPublicSupabaseClient } from "@/shared/integrations/supabase/public-client";
import { logger } from "@/shared/lib/logger";

/**
 * Canonical public origin for every `<loc>`. Defined in `shared/constants/site`
 * (a dependency-free module, so the public shell can render its
 * `<link rel="canonical">` without pulling this file's Supabase client into the
 * client bundle) and re-exported here, where sitemap consumers expect it.
 */
export { SITE_URL } from "@/shared/constants/site";
import { SITE_URL } from "@/shared/constants/site";

type SitemapClient = ReturnType<typeof createPublicSupabaseClient>;

/** Static public pages, always present and independent of catalogue data. */
const STATIC_PATHS = [
  "/",
  "/programme",
  // Les trois années du lycée qui se déclinent en sections : c'est par ces pages
  // seules que le catalogue mène aux niveaux du secondaire. Liste fermée, la même
  // que `YEARS` dans la route (`programme_.lycee.$annee.tsx`).
  "/programme/lycee/2eme",
  "/programme/lycee/3eme",
  "/programme/lycee/bac",
  "/extras",
  // Pages légales : URL stables et indexables — la déclaration « child-directed »
  // auprès de Google exige une politique de confidentialité atteignable (é23 Q-3).
  "/confidentialite",
  "/conditions",
  // Le test de niveau (étude 39) : la porte d'entrée partageable, indexable comme le catalogue.
  "/test-de-niveau",
] as const;

function escapeXml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&apos;");
}

/**
 * PostgREST caps every response at `max_rows` (1 000 on Supabase by default) and
 * truncates SILENTLY: the sitemap of 2026-11-11 listed exactly 1 000 chapters out
 * of 1 171 and 858 exercises out of 6 648. Every table is therefore read page by
 * page, in a stable order, until a short page says there is nothing left.
 */
export const SITEMAP_PAGE_SIZE = 1000;

type Page<Row> = { data: Row[] | null; error: { message: string } | null };
type PageQuery = (
  from: number,
  to: number,
) => PromiseLike<{ data: unknown[] | null; error: { message: string } | null }>;

async function fetchAllRows<Row>(query: PageQuery): Promise<Page<Row>> {
  const rows: Row[] = [];
  for (let from = 0; ; from += SITEMAP_PAGE_SIZE) {
    const { data, error } = await query(from, from + SITEMAP_PAGE_SIZE - 1);
    if (error) return { data: null, error };
    const page = (data ?? []) as Row[];
    rows.push(...page);
    if (page.length < SITEMAP_PAGE_SIZE) return { data: rows, error: null };
  }
}

/** La paire qui rattache une matière à son niveau — `grade_id` nul pour un parcours libre. */
type LevelKey = { theme_id: string | null; grade_id: string | null };

function levelKey(row: LevelKey): string {
  return `${row.theme_id ?? ""}::${row.grade_id ?? ""}`;
}

/**
 * Collect every public, indexable path from the anon-visible catalogue. RLS
 * already restricts the anon client to public content; on top of that we drop
 * pages that have no real indexable content:
 *  - levels (`parcours`) that are not yet `available` (they render "bientôt"),
 *  - levels that hold NO subject — an empty page (constat du 2026-11-12 :
 *    `/niveau/arabe`, « available », zéro matière, retiré exprès du menu des
 *    extras, mais listé ici). Si la lecture des matières échoue on ne sait pas
 *    lesquels sont vides : tous les niveaux disponibles restent listés.
 *  - chapters with no `lesson_content` (the reader shows a coming-soon state),
 *  - any non-`admin` exercise (the public practice page only renders an account
 *    upsell for those),
 *  - an exercise a NEW visitor finds LOCKED (décision du propriétaire, 2026-11-13,
 *    option B) : dans une matière SCOLAIRE, les missions d'un chapitre qui a un quiz
 *    de compréhension restent fermées tant que ce quiz n'est pas réussi (cours →
 *    quiz → missions). Un robot, comme un visiteur neuf, n'y voyait que l'écran
 *    « exercice verrouillé » : 4 657 des 5 477 pages d'exercice du sitemap le
 *    2026-11-12. Elles en sortent (et leur page porte `noindex`), et les QUIZ, ouverts
 *    à tous, y entrent à leur place — c'est la porte réelle de chaque chapitre.
 *    Si la lecture des matières échoue, on ne sait pas lesquelles sont scolaires :
 *    toute mission d'un chapitre à quiz est alors tenue pour verrouillée.
 *
 * A failing table query is logged and skipped so a partial sitemap still ships
 * rather than failing the whole document.
 */
export async function collectSitemapPaths(supabase: SitemapClient): Promise<string[]> {
  const paths: string[] = [...STATIC_PATHS];

  const [parcours, subjects, chapters, exercises] = await Promise.all([
    fetchAllRows<{ id: string; status: string } & LevelKey>((from, to) =>
      supabase.from("parcours").select("id,status,theme_id,grade_id").order("id").range(from, to),
    ),
    fetchAllRows<{ id: string } & LevelKey>((from, to) =>
      supabase.from("subjects").select("id,theme_id,grade_id").order("id").range(from, to),
    ),
    // Le filtre « a une leçon » se fait EN BASE et seul l'id voyage. Lire
    // `lesson_content` pour le tester ici (~30 Ko par leçon, 1 000 par page, triées)
    // dépassait le statement timeout (57014, constaté en prod le 2026-11-11) : la
    // table entière tombait du sitemap. Même sémantique que les voisins du lecteur
    // (`quest.lesson.server.ts`) : NULL et chaîne vide = pas de leçon.
    fetchAllRows<{ id: string }>((from, to) =>
      supabase
        .from("chapters")
        .select("id")
        .not("lesson_content", "is", null)
        .neq("lesson_content", "")
        .order("id")
        .range(from, to),
    ),
    fetchAllRows<{
      id: string;
      mode: string;
      source: string;
      chapter_id: string | null;
      subject_id: string | null;
    }>((from, to) =>
      supabase
        .from("exercises")
        .select("id,mode,source,chapter_id,subject_id")
        .order("id")
        .range(from, to),
    ),
  ]);

  // Un niveau « tient » des matières quand elles partagent sa paire (thème, classe).
  // `null` = la lecture des matières a échoué : on ne retire alors aucun niveau.
  const populatedLevels = subjects.error
    ? null
    : new Set((subjects.data ?? []).map((s) => levelKey(s)));

  if (parcours.error) {
    logger.warn("sitemap: parcours query failed", { error: parcours.error.message });
  } else {
    for (const p of parcours.data ?? []) {
      if (p.status !== "available") continue;
      if (populatedLevels && !populatedLevels.has(levelKey(p))) continue;
      paths.push(`/niveau/${p.id}`);
    }
  }

  if (subjects.error) {
    logger.warn("sitemap: subjects query failed", { error: subjects.error.message });
  } else {
    for (const s of subjects.data ?? []) {
      paths.push(`/matiere/${s.id}`);
    }
  }

  if (chapters.error) {
    logger.warn("sitemap: chapters query failed", { error: chapters.error.message });
  } else {
    for (const c of chapters.data ?? []) {
      paths.push(`/chapitre/${c.id}`);
    }
  }

  if (exercises.error) {
    logger.warn("sitemap: exercises query failed", { error: exercises.error.message });
  } else {
    const publicExercises = (exercises.data ?? []).filter((e) => e.source === "admin");
    // Les chapitres qui ont un quiz de compréhension : leurs missions en dépendent.
    const quizChapters = new Set(
      publicExercises.filter((e) => e.mode === "quiz").map((e) => e.chapter_id),
    );
    // `null` = lecture des matières en échec : on ne sait pas lesquelles sont scolaires.
    const schoolSubjects = subjects.error
      ? null
      : new Set((subjects.data ?? []).filter((s) => s.grade_id !== null).map((s) => s.id));
    for (const e of publicExercises) {
      const lockedForNewVisitor =
        e.mode !== "quiz" &&
        quizChapters.has(e.chapter_id) &&
        (schoolSubjects === null || schoolSubjects.has(e.subject_id ?? ""));
      if (!lockedForNewVisitor) paths.push(`/exercice/${e.id}`);
    }
  }

  return paths;
}

/** Render a sitemap XML document from a list of site-relative paths. */
export function renderSitemap(paths: string[]): string {
  const entries = paths
    .map((path) => `  <url>\n    <loc>${escapeXml(SITE_URL + path)}</loc>\n  </url>`)
    .join("\n");
  return `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${entries}\n</urlset>\n`;
}

/**
 * Build the full sitemap document for the public catalogue. Called by the
 * `/sitemap.xml` handler in `src/server.ts`, which runs outside a server-fn
 * middleware context — so this creates its own anon Supabase client.
 *
 * UN SEUL DOCUMENT, PAS D'INDEX — décision du 2026-11-12, mesurée : 6 815 URL
 * (14 % du plafond de 50 000 par fichier), 0,7 Mo (plafond 50 Mo), généré en 0,8 s.
 * Un index de sitemaps n'apporterait rien à l'exploration ; son seul intérêt serait
 * de lire l'indexation PAR TYPE de page dans la Search Console. À rouvrir si le
 * catalogue approche 40 000 URL — découper alors par type (niveaux et matières,
 * cours, exercices).
 *
 * PAS DE `<lastmod>` — même date, même raison : aucune date de MODIFICATION fiable
 * n'existe en base. `chapters` et `exercises` n'ont que `created_at` (999 des 1 171
 * chapitres portent le 2026-05-22, jour de la reprise du corpus, alors que leurs
 * leçons ont été réécrites depuis — le pipeline de contenu met à jour en place) ;
 * `subjects` et `parcours` n'ont aucune date. Une date fausse est pire qu'une date
 * absente : Google apprend à ignorer le `lastmod` d'un site qui se trompe. Pour en
 * émettre un, il faut une colonne `updated_at` tenue par un trigger (migration).
 */
async function buildSitemap(): Promise<string> {
  const supabase = createPublicSupabaseClient();
  const paths = await collectSitemapPaths(supabase);
  return renderSitemap(paths);
}

/** Durée pendant laquelle une instance ressert le document qu'elle vient de construire. */
export const SITEMAP_TTL_MS = 10 * 60_000;

/**
 * Mémoire d'un document coûteux : une construction par fenêtre, et UNE SEULE à la fois.
 *
 * Constat du 2026-11-12 (revue de sécurité) : `/sitemap.xml` est servi AVANT le garde
 * anti-robots (un moteur doit toujours l'obtenir) et ne tenait que par le cache du CDN, dont
 * la clé inclut la chaîne de requête. `/sitemap.xml?x=<aléatoire>` forçait donc, à chaque
 * appel et sans aucune limite, sept lectures paginées du catalogue. Avec cette mémoire, la
 * chaîne de requête ne change plus rien : une instance interroge la base au plus une fois
 * par fenêtre, quel que soit le nombre d'appels.
 *
 *  - des appels simultanés partagent la construction en cours (pas de ruée) ;
 *  - un échec n'est pas retenu : l'appel suivant réessaie.
 */
export function createDocumentCache(
  build: () => Promise<string>,
  ttlMs: number,
  now: () => number = Date.now,
): () => Promise<string> {
  let cached: { value: string; expiresAt: number } | null = null;
  let inFlight: Promise<string> | null = null;
  return () => {
    if (cached && now() < cached.expiresAt) return Promise.resolve(cached.value);
    inFlight ??= build()
      .then((value) => {
        cached = { value, expiresAt: now() + ttlMs };
        return value;
      })
      .finally(() => {
        inFlight = null;
      });
    return inFlight;
  };
}

export const generateSitemap = createDocumentCache(buildSitemap, SITEMAP_TTL_MS);
