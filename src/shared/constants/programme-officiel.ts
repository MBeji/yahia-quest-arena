/**
 * Le programme officiel tunisien, **matière par matière et niveau par niveau**.
 *
 * POURQUOI. Le catalogue ne connaît que les matières déjà écrites : une classe dont
 * trois matières sur onze sont publiées affiche trois cartes, et rien ne dit à l'élève
 * (ni à ses parents) que le reste du programme est prévu. Cette table déclare la liste
 * **complète** des matières de chaque niveau ; la page niveau affiche celles qui manquent
 * au catalogue en « bientôt », non cliquables. C'est une table de RÉFÉRENCE, pas du
 * contenu : aucun cours, aucun chapitre, aucune question — seulement des intitulés.
 *
 * SOURCES (par ordre d'autorité, toutes relues au moment de l'écriture) :
 *   1. le catalogue officiel CNP (`cnp-officiel/catalogue.csv`, 342 manuels) — un manuel
 *      nomme sa شعبة dans son titre, ce qui donne mécaniquement la matrice section × matière
 *      du lycée (relevé repris dans `docs/lycee-architecture.md` §3.1) ;
 *   2. `docs/lycee-architecture.md` §1–§4 — sections, convention d'id, politique de langue ;
 *   3. la grille de planification interne du repo privé
 *      (`curriculum-architect/references/programme-map.md`), qui nomme explicitement le
 *      « gap set » des matières officielles absentes du catalogue.
 *
 * TROIS ARBITRAGES, à relire si un jour la table se discute — le catalogue CNP est un fonds
 * de manuels TÉLÉCHARGÉS, donc muet là où il manque un manuel :
 *   • l'**informatique** est déclarée à tous les niveaux du lycée (elle y est enseignée),
 *     alors qu'aucun manuel du fonds ne la porte hors section « sciences de l'informatique » ;
 *   • l'**éducation civique** est fondue dans « المواد الاجتماعية » au primaire et au collège
 *     (le manuel unique couvre histoire + géographie + civique) et n'est une matière à part
 *     qu'au lycée, où le CNP la publie séparément ;
 *   • l'**anglais** commence en 4ème année de base (réforme 2019-2020, qui l'a fait descendre
 *     de la 6ème) — le fonds CNP, plus ancien, ne contient que le guide de 6ème.
 *
 * HORS PÉRIMÈTRE, volontairement (décision produit) : éducation physique et sportive,
 * éducation musicale, éducation plastique / dessin, éducation technique du primaire, la
 * section « sport » du lycée et les langues optionnelles du secondaire (allemand, italien,
 * espagnol, russe, chinois). Elles existent au programme et au catalogue CNP ; elles ne se
 * prêtent pas au format de l'académie (QCM, cours écrit) et n'ont pas à peupler le menu.
 *
 * IDS. Un id vaut identité (UUIDv5, cf. `docs/content-generation-pipeline.md`) : celui
 * déclaré ici est celui que la matière PORTE déjà au catalogue, ou portera à sa création
 * — sinon la matière apparaîtrait deux fois le jour de son ouverture (une carte réelle +
 * une carte « bientôt » fantôme). Convention : `<matière>-<suffixe de niveau>`, avec les
 * héritages figés listés dans `LEGACY_IDS`.
 *
 * Pur, sans I/O, sans dépendance : testé dans `__tests__/programme-officiel.test.ts`.
 */

export type ProgrammeLanguage = "ar" | "fr" | "en";

/** Une matière officielle d'un niveau, telle qu'elle s'affiche au menu. */
export type OfficialSubject = {
  /** Id catalogue (`subjects.id`) — réel s'il existe, sinon celui de sa future création. */
  id: string;
  /** Intitulé dans la langue d'enseignement, comme `subjects.name_fr` le fait déjà. */
  name: string;
  /** Langue d'enseignement officielle à ce niveau (bascule ar → fr au lycée). */
  contentLanguage: ProgrammeLanguage;
};

type Matiere = { base: string; name: string; lang: ProgrammeLanguage };

// ---------------------------------------------------------------------------
// Les trois registres de matières (l'intitulé et la langue changent avec le cycle :
// « الرياضيات » en arabe jusqu'à la 9ème, « Mathématiques » en français au lycée).
// ---------------------------------------------------------------------------

/** Primaire (1ère–6ème année de base) : arabe partout, sauf français et anglais. */
const PRIMAIRE = {
  arabe: { base: "arabic", name: "اللغة العربية", lang: "ar" },
  math: { base: "math", name: "الرياضيات", lang: "ar" },
  eveil: { base: "eveil-scientifique", name: "الإيقاظ العلمي", lang: "ar" },
  islamique: { base: "education-islamique", name: "التربية الإسلامية", lang: "ar" },
  francais: { base: "french", name: "Français", lang: "fr" },
  anglais: { base: "english", name: "English", lang: "en" },
  sociales: { base: "histoire-geo", name: "التاريخ والجغرافيا", lang: "ar" },
} as const satisfies Record<string, Matiere>;

/** Collège (7ème–9ème) : le tronc des six matières écrites + le reste du programme. */
const COLLEGE = {
  arabe: { base: "arabic", name: "اللغة العربية", lang: "ar" },
  francais: { base: "french", name: "Français", lang: "fr" },
  anglais: { base: "english", name: "English", lang: "en" },
  math: { base: "math", name: "الرياضيات", lang: "ar" },
  physique: { base: "sciences-physiques", name: "العلوم الفيزيائية", lang: "ar" },
  svt: { base: "sciences-vie-terre", name: "علوم الحياة والأرض", lang: "ar" },
  islamique: { base: "education-islamique", name: "التربية الإسلامية", lang: "ar" },
  // Un seul manuel CNP « المواد الاجتماعية » couvre histoire + géographie + éducation
  // civique au collège : une matière, pas trois (au lycée, le CNP les sépare).
  sociales: { base: "histoire-geo", name: "المواد الاجتماعية", lang: "ar" },
  informatique: { base: "informatique", name: "الإعلامية", lang: "ar" },
  technologie: { base: "technologie", name: "التربية التكنولوجية", lang: "ar" },
} as const satisfies Record<string, Matiere>;

/**
 * Lycée (1ère sec → bac). Bascule de langue (`docs/lycee-architecture.md` §1.2 et §4) :
 * mathématiques, physique, chimie, SVT, informatique et technologie passent en français ;
 * arabe, philosophie, histoire-géo, pensée islamique, éducation civique, économie et
 * gestion restent en arabe.
 */
const LYCEE = {
  arabe: { base: "arabic", name: "العربية", lang: "ar" },
  francais: { base: "french", name: "Français", lang: "fr" },
  anglais: { base: "english", name: "English", lang: "en" },
  math: { base: "math", name: "Mathématiques", lang: "fr" },
  physique: { base: "physique", name: "Sciences physiques", lang: "fr" },
  chimie: { base: "chimie", name: "Chimie", lang: "fr" },
  svt: { base: "svt", name: "Sciences de la Vie et de la Terre", lang: "fr" },
  informatique: { base: "informatique", name: "Informatique", lang: "fr" },
  technologie: { base: "technologie", name: "Technologie", lang: "fr" },
  philosophie: { base: "philosophie", name: "الفلسفة", lang: "ar" },
  histoireGeo: { base: "histoire-geo", name: "التاريخ والجغرافيا", lang: "ar" },
  civique: { base: "education-civique", name: "التربية المدنية", lang: "ar" },
  islamique: { base: "pensee-islamique", name: "التفكير الإسلامي", lang: "ar" },
  economie: { base: "economie", name: "الاقتصاد", lang: "ar" },
  gestion: { base: "gestion", name: "التصرف", lang: "ar" },
} as const satisfies Record<string, Matiere>;

/**
 * Ids figés, jamais reconstruits par la convention.
 *
 * • La **9ème** possède les ids nus, antérieurs au suffixe de niveau — dont l'anomalie
 *   documentée (`programme-map.md` § Anomalies) : `svt` EST la matière « sciences
 *   physiques », et la vraie SVT s'appelle `sciences-vie-terre`. Renommer = supprimer et
 *   recréer, donc perdre la progression des élèves : on ne renomme pas.
 * • L'arabe de **1ère secondaire** est déclaré `arabe-1ere-sec` par le manifeste de
 *   programme du repo privé — c'est cet id que l'usine à contenu créera.
 */
const LEGACY_IDS: Record<string, string> = {
  "arabe@9eme-base": "arabic",
  "math@9eme-base": "math",
  "francais@9eme-base": "french",
  "anglais@9eme-base": "english",
  "physique@9eme-base": "svt",
  "svt@9eme-base": "sciences-vie-terre",
  "arabe@1ere-sec": "arabe-1ere-sec",
};

/**
 * Suffixe d'id d'un niveau. Le primaire et le collège l'abrègent (`1ere-base` → `1ere`,
 * `9eme-base` → `9eme`) ; les niveaux du lycée gardent leur slug entier, section comprise
 * (`math-bac-math`, `svt-bac-sciences-exp` — `docs/lycee-architecture.md` §2).
 */
function idSuffix(gradeSlug: string): string {
  return gradeSlug.endsWith("-base") ? gradeSlug.slice(0, -"-base".length) : gradeSlug;
}

function build<R extends Record<string, Matiere>>(
  registry: R,
  gradeSlug: string,
  keys: readonly (keyof R & string)[],
): readonly OfficialSubject[] {
  return keys.map((key) => {
    const m = registry[key];
    return {
      id: LEGACY_IDS[`${key}@${gradeSlug}`] ?? `${m.base}-${idSuffix(gradeSlug)}`,
      name: m.name,
      contentLanguage: m.lang,
    };
  });
}

const primaire = (grade: string, keys: readonly (keyof typeof PRIMAIRE)[]) =>
  build(PRIMAIRE, grade, keys);
const college = (grade: string, keys: readonly (keyof typeof COLLEGE)[]) =>
  build(COLLEGE, grade, keys);
const lycee = (grade: string, keys: readonly (keyof typeof LYCEE)[]) => build(LYCEE, grade, keys);

/** Le tronc commun des six sections de 3ème secondaire et du bac (hors histoire-géo). */
const TRONC_3EME = ["arabe", "francais", "anglais", "philosophie", "islamique", "math"] as const;
const TRONC_BAC = ["arabe", "francais", "anglais", "philosophie", "math"] as const;

/**
 * Le programme officiel par niveau (`grades.slug` du thème `ecole-tn`), dans l'ordre
 * d'affichage. Les trois nœuds plats hérités (`2eme-sec`, `3eme-sec`, `bac`) sont
 * non-sélectionnables depuis l'étude 16 et ne portent aucun parcours : ils n'ont pas
 * d'entrée ici.
 */
export const OFFICIAL_PROGRAMME: Record<string, readonly OfficialSubject[]> = {
  // ---- Primaire ---------------------------------------------------------
  // Français dès la 3ème, anglais dès la 4ème (réforme 2019-2020 : l'anglais, jusque-là
  // enseigné en 6ème, descend en 4ème année), matières sociales en 5ème et 6ème.
  "1ere-base": primaire("1ere-base", ["arabe", "math", "eveil", "islamique"]),
  "2eme-base": primaire("2eme-base", ["arabe", "math", "eveil", "islamique"]),
  "3eme-base": primaire("3eme-base", ["arabe", "francais", "math", "eveil", "islamique"]),
  "4eme-base": primaire("4eme-base", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "eveil",
    "islamique",
  ]),
  "5eme-base": primaire("5eme-base", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "eveil",
    "sociales",
    "islamique",
  ]),
  "6eme-base": primaire("6eme-base", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "eveil",
    "sociales",
    "islamique",
  ]),

  // ---- Collège ----------------------------------------------------------
  // Même grille aux trois années : le tronc des six matières déjà écrites, plus
  // éducation islamique, matières sociales, informatique et technologie.
  "7eme-base": college("7eme-base", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "physique",
    "svt",
    "sociales",
    "islamique",
    "informatique",
    "technologie",
  ]),
  "8eme-base": college("8eme-base", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "physique",
    "svt",
    "sociales",
    "islamique",
    "informatique",
    "technologie",
  ]),
  "9eme-base": college("9eme-base", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "physique",
    "svt",
    "sociales",
    "islamique",
    "informatique",
    "technologie",
  ]),

  // ---- Lycée : 1ère secondaire (tronc commun, pas de section) -----------
  "1ere-sec": lycee("1ere-sec", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "physique",
    "chimie",
    "svt",
    "histoireGeo",
    "civique",
    "islamique",
    "informatique",
    "technologie",
  ]),

  // ---- Lycée : 2ème secondaire (4 orientations) -------------------------
  // Physique, chimie et technologie ne sont au programme que des sections Sciences et
  // Technologies de l'informatique (relevé CNP : leurs manuels nomment ces deux شعبتين).
  "2eme-sec-sciences": lycee("2eme-sec-sciences", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "physique",
    "chimie",
    "svt",
    "histoireGeo",
    "civique",
    "islamique",
    "informatique",
    "technologie",
  ]),
  "2eme-sec-info": lycee("2eme-sec-info", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "physique",
    "chimie",
    "svt",
    "histoireGeo",
    "civique",
    "islamique",
    "informatique",
    "technologie",
  ]),
  "2eme-sec-lettres": lycee("2eme-sec-lettres", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "svt",
    "histoireGeo",
    "civique",
    "islamique",
    "informatique",
  ]),
  "2eme-sec-eco-services": lycee("2eme-sec-eco-services", [
    "arabe",
    "francais",
    "anglais",
    "math",
    "economie",
    "gestion",
    "histoireGeo",
    "civique",
    "islamique",
    "informatique",
  ]),

  // ---- Lycée : 3ème secondaire (6 sections) -----------------------------
  // La philosophie entre au programme ; l'éducation civique ne subsiste qu'en Lettres
  // (seul manuel « التربية المدنية (شعبة الآداب) » du catalogue).
  "3eme-sec-math": lycee("3eme-sec-math", [
    ...TRONC_3EME,
    "physique",
    "chimie",
    "svt",
    "histoireGeo",
    "informatique",
  ]),
  "3eme-sec-sciences-exp": lycee("3eme-sec-sciences-exp", [
    ...TRONC_3EME,
    "physique",
    "chimie",
    "svt",
    "histoireGeo",
    "informatique",
  ]),
  "3eme-sec-lettres": lycee("3eme-sec-lettres", [
    ...TRONC_3EME,
    "svt",
    "histoireGeo",
    "civique",
    "informatique",
  ]),
  "3eme-sec-eco-gestion": lycee("3eme-sec-eco-gestion", [
    ...TRONC_3EME,
    "economie",
    "gestion",
    "histoireGeo",
    "informatique",
  ]),
  "3eme-sec-techniques": lycee("3eme-sec-techniques", [
    ...TRONC_3EME,
    "physique",
    "chimie",
    "technologie",
    "histoireGeo",
    "informatique",
  ]),
  "3eme-sec-info": lycee("3eme-sec-info", [
    ...TRONC_3EME,
    "physique",
    "chimie",
    "histoireGeo",
    "informatique",
  ]),

  // ---- Baccalauréat (6 sections) ----------------------------------------
  // Au bac, histoire-géo et pensée islamique quittent les sections scientifiques :
  // le CNP ne publie plus que « التاريخ — شعبة الآداب والاقتصاد والتصرف » et un
  // « تفكير اسلامي — شعبة الآداب ».
  "bac-math": lycee("bac-math", [...TRONC_BAC, "physique", "chimie", "svt", "informatique"]),
  "bac-sciences-exp": lycee("bac-sciences-exp", [
    ...TRONC_BAC,
    "physique",
    "chimie",
    "svt",
    "informatique",
  ]),
  "bac-lettres": lycee("bac-lettres", [
    ...TRONC_BAC,
    "svt",
    "histoireGeo",
    "islamique",
    "informatique",
  ]),
  "bac-eco-gestion": lycee("bac-eco-gestion", [
    ...TRONC_BAC,
    "economie",
    "gestion",
    "histoireGeo",
    "informatique",
  ]),
  "bac-techniques": lycee("bac-techniques", [
    ...TRONC_BAC,
    "physique",
    "chimie",
    "technologie",
    "informatique",
  ]),
  "bac-info": lycee("bac-info", [...TRONC_BAC, "physique", "chimie", "informatique"]),
};

/** Les matières officielles d'un niveau, dans l'ordre du programme (vide si inconnu). */
export function officialSubjects(gradeSlug: string | null | undefined): readonly OfficialSubject[] {
  return (gradeSlug && OFFICIAL_PROGRAMME[gradeSlug]) || [];
}

/**
 * Les matières du programme que le catalogue ne sert pas encore — celles à afficher en
 * « bientôt ». Une matière déjà publiée (son id est dans `presentIds`) n'y figure jamais,
 * et un niveau hors programme scolaire (les parcours `libre`, sans grade) rend une liste
 * vide : les extras n'ont pas de programme officiel.
 */
export function comingSoonSubjects(
  gradeSlug: string | null | undefined,
  presentIds: Iterable<string>,
): OfficialSubject[] {
  const present = new Set(presentIds);
  return officialSubjects(gradeSlug).filter((s) => !present.has(s.id));
}
