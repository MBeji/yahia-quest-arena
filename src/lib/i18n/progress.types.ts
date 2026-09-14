/**
 * ÉTOILES DE CHAPITRE & SCEAUX DE MATIÈRE — le namespace de la progression
 * (étude 34, R-1/R-17). Sorti de `TranslationKeys` avec ses valeurs
 * (`progress/{fr,en,ar}.ts`).
 *
 * ⚠️ Même statut que `badge.types.ts` et `parent.types.ts`, et pour la même
 * raison : cette microcopy ne sert que des surfaces atteintes par des routes
 * chargées dynamiquement (le hub matière aujourd'hui, le QG et le suivi parental
 * au lot 3). La laisser dans le catalogue app-wide la ferait descendre chez tout
 * le monde, et `i18n-` réclamerait son dix-huitième relèvement — celui que
 * `scripts/check-bundle-budget.mjs` refuse depuis le 2026-08-26. Elle prend donc
 * son catalogue et son budget (`i18n-progress-`, 16 KB).
 *
 * VOCABULAIRE NORMATIF (R-1, arbitré le 2026-09-14) — ne pas improviser :
 *   - **étoile de chapitre** (1 à 4) · EN *chapter star* · AR **نجمة الفصل** ;
 *   - **sceau de matière** (⭐ à ⭐⭐⭐⭐) · EN *subject seal* · AR **ختم المادة** ;
 *   - **nouveauté ✨** · EN *new* · AR **جديد** ;
 *   - **maîtrisé** — le SEUL mot de verdict, pour un chapitre à l'étoile 4
 *     (Q-2, rendue contre la recommandation) · EN *mastered* · AR **متقَن**.
 * Interdits : « niveau » pour une étoile (é22 R-27), « palier » (réservé à
 * l'avatar), « rang » (classement), « or / platine / diamant » (ligue é31 R-14),
 * et toute formule de perte (« tu as perdu », « régression », « en retard »).
 *
 * Les quatre crans portent les noms de l'échelle du CONTENU — socle, pratique,
 * boss, élite — parce que ce sont ceux que les titres de missions affichent déjà.
 *
 * Ce fichier ne porte QUE les clés que le lot 2 rend à l'écran. Les lots 3
 * (parent, QG) et 4 (célébrations, badges) ajoutent les leurs avec leur surface :
 * une chaîne qu'aucun composant ne lit est du code mort, DoD §3.
 */
export type ProgressTranslations = {
  progress: {
    chapterStars: {
      /** Nom des quatre crans — l'échelle du contenu, pas une échelle de plus. */
      tier1: string;
      tier2: string;
      tier3: string;
      tier4: string;
      /** `aria-label` de la jauge — `{star}` acquises sur `{total}` crans présents. */
      gaugeLabel: string;
      /** Verdict, lu AU GRAND LIVRE : étoile 4 (R-5). */
      mastered: string;
      /** Verdict + ce qui a grandi depuis (R-8) — `{n}` nouveautés. */
      masteredWithNew: string;
      /** Compteur d'un cran non acquis — `{done}/{total}`. */
      rungCount: string;
      /** Légende d'un cran — `{star}` (le rang) et `{tier}` (son nom). */
      legend: string;
      /** Ce que « comptée » veut dire, en une phrase d'élève (R-3). */
      countedRule: string;
      /** Aucun cran acquis — l'état de départ, jamais une formule de perte. */
      none: string;
    };
    /** Missions arrivées après la dernière étoile, jamais tentées — `{n}`. */
    newMissions: string;
    /** Ce chapitre est arrivé après la dernière étoile de la matière. */
    newChapter: string;
    /** Les missions créées par un parent — `{done}/{total}` (R-2, US-6). */
    familyMissions: string;
    /** Pourquoi elles ne donnent pas d'étoile, en une ligne. */
    familyMissionsHint: string;
    seal: {
      /** Titre du bloc. */
      heading: string;
      /** Sceau acquis — `{stars}` (⭐ à ⭐⭐⭐⭐). */
      title: string;
      /** Aucun sceau encore. */
      none: string;
      /** Date d'obtention — `{date}`. */
      earnedOn: string;
      /** Le prochain — `{stars}`, `{ready}` chapitres prêts sur `{total}`. */
      next: string;
      /** Idem, quand `{n}` chapitres sont arrivés depuis. */
      nextWithNew: string;
      /** Ce qu'un sceau demande, en une ligne. */
      rule: string;
    };
    effort: {
      /** Titre du bloc — ce que l'élève A FAIT, jamais un pourcentage (R-10). */
      heading: string;
      /** `{n}` missions réussies. */
      missions: string;
      /** `{n}` XP gagnés. */
      xp: string;
      /** `{started}` chapitres commencés. */
      chaptersStarted: string;
      /** `{mastered}` chapitres maîtrisés. */
      chaptersMastered: string;
    };
    /** La promesse faite à l'anonyme (R-16) — jamais un verrou de plus. */
    anonPromise: string;
  };
};
