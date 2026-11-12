import type { Locale } from "./types";

/**
 * Méta du document (title/description/OG) pour les trois locales — la SEULE partie
 * d'un catalogue dont le shell SSR a besoin pour chaque visiteur (`head()` de
 * `__root.tsx`). Elle vit ICI et non dans les catalogues, parce que `__root` devait
 * sinon importer fr/en/ar en entier (192 KB) pour en lire quatre chaînes par locale.
 *
 * ⚠️ Importé par `__root.tsx` seul, jamais par un catalogue : un module partagé par
 * fr/en/ar est fondu par rolldown dans le premier chunk de locale rencontré (ar) et
 * ramène ce chunk dans le graphe statique (mesuré le 2026-10-31). Épinglé par
 * manualChunks au chunk `i18n-fr`, toujours chargé, pour ne pas peser sur le budget
 * d'index ; en/ar restent paresseux.
 */
export type DocumentMeta = {
  title: string;
  description: string;
  ogTitle: string;
  ogDescription: string;
};

export const metaByLocale: Record<Locale, DocumentMeta> = {
  fr: {
    title: "Na9ra Nal3ab — tous les cours de l’école tunisienne, gratuitement",
    description:
      "Cours, résumés et exercices corrigés de toute l’école tunisienne, de la 1re année au Baccalauréat. Accès libre, gratuit, sans inscription — pour toute la famille.",
    ogTitle: "Na9ra Nal3ab — l’école tunisienne, gratuite et en accès libre",
    ogDescription:
      "Tout le programme officiel, du Primaire au Bac : cours, résumés et exercices corrigés, gratuitement.",
  },
  en: {
    title: "Na9ra Nal3ab — all of Tunisia's school curriculum, for free",
    description:
      "Courses, summaries and corrected exercises for the whole Tunisian school curriculum, from 1st grade to the Baccalauréat. Free and open access, no sign-up — for the whole family.",
    ogTitle: "Na9ra Nal3ab — the Tunisian school curriculum, free and open",
    ogDescription:
      "The full official programme, from primary school to the Bac: courses, summaries and corrected exercises, for free.",
  },
  ar: {
    title: "نقرا نلعب — كامل دروس المدرسة التونسية، مجّانًا",
    description:
      "دروس وملخّصات وتمارين مصحّحة لكامل برنامج المدرسة التونسية، من السنة الأولى إلى البكالوريا. وصول حرّ ومجّاني دون تسجيل — لكلّ العائلة.",
    ogTitle: "نقرا نلعب — المدرسة التونسية، مجّانية وفي متناول الجميع",
    ogDescription:
      "كامل البرنامج الرسمي، من الابتدائي إلى البكالوريا: دروس وملخّصات وتمارين مصحّحة، مجّانًا.",
  },
};
