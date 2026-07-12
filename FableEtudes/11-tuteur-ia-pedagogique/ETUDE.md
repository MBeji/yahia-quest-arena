# Étude 11 — Tuteur IA pédagogique (« Prof Yahia »)

> **Statut** : **gelée** (2026-07-11 — dépend de l'étude 01, elle-même gelée par le pivot gratuité : le coût marginal par usage du tuteur se finançait par les revenus premium. À dégeler si un financement alternatif est décidé)
> **Priorité** : 11 (après 01 qui le finance, nourri par 04/07) · **Valeur** : le rêve produit — « Pourquoi j'ai faux ? / Explique autrement / Donne-moi un exercice similaire », adapté au niveau réel de l'élève · **Complexité** : haute (coût récurrent, sécurité mineurs, anti-triche)
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : étude 01 (revenus — le tuteur a un coût marginal par usage), étude 04 A0 (tag de misconception choisi = le diagnostic qui rend la réponse pertinente), étude 07 (exercice similaire via compétences ; maîtrise pour calibrer le registre de langue) · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md (consommables/hints, premium gate, logging), docs/environment-variables.md, skill `claude-api` (référence modèles/coûts au moment de l'implémentation)

## 1. Contexte & objectif produit

Aujourd'hui, après une erreur, l'élève lit une explication statique (bonne, mais unique) ; le
système d'indices (`consume_hint`) révèle cette même explication. Un élève qui « ne comprend
toujours pas » est au bout du produit. Objectif : un tuteur conversationnel **borné** qui
ré-explique autrement, en s'appuyant sur ce que la plateforme sait déjà : la question, la bonne
réponse, **l'erreur précise exécutée** (tag de misconception du distracteur choisi — étude 04),
le cours du chapitre, et le niveau de l'élève. KPI : taux de résolution (« j'ai compris » /
réussite à la question similaire), usage/quota, coût par élève actif, NPS parents.
Non-objectif : chat libre généraliste, devoirs faits à la place de l'élève, voix (v2), tuteur
pendant une épreuve notée.

## 2. Spécification fonctionnelle

- **US-1** : depuis l'écran de **review** (après soumission), sur une question ratée : bouton
  « Demander au Prof » → panneau tuteur avec la question en contexte ; première réponse =
  explication personnalisée qui **nomme mon erreur** (« tu as additionné les dénominateurs… »).
- **US-2** : je peux enchaîner via des **intentions fermées** (boutons) : « Explique autrement »
  (registre plus simple/analogie), « Étape par étape », « Donne-moi un exercice similaire »
  (→ une question existante de la même compétence, jouable en practice), « J'ai compris ✅ ».
  Champ libre optionnel mais **cadré** (R-4).
- **US-3** : mes échanges tuteur sont visibles dans mon historique de la question ; le parent
  lié peut voir qu'il y a eu recours au tuteur (compteur, pas le transcript — Q-2).
- **R-1 — Anti-triche (non négociable)** : le tuteur n'est accessible **qu'en post-review**
  d'une tentative soumise (jamais pendant une session active, jamais sur une question non
  tentée, jamais en mode examen/duel/dungeon actif). Vérifié server-side (l'état de session fait
  foi), pas seulement masqué en UI.
- **R-2 — Ancrage** : chaque réponse est générée avec un contexte fermé : question + options +
  clé + explication + tag de misconception choisi + extrait du `cours.md` du chapitre + maîtrise
  de la compétence (étude 07 si dispo). Le système refuse les sujets hors de ce contexte
  (« Demande-moi plutôt sur cette question ! », ton RPG).
- **R-3 — Quotas & économie** : intégré à l'économie des indices existante : N interactions
  gratuites/jour (constante), au-delà consommation d'un item `hints` de l'inventaire ; les
  entitled concours ont un quota supérieur. Plafond dur serveur par jour/élève (coût).
- **R-4 — Sécurité mineurs** : prompt système strict (rôle professeur, ton bienveillant RPG,
  aucune collecte d'info personnelle, refus des sujets hors scolaire), sortie en **langue du
  sujet** (ar RTL/fr/en — notation standard), longueur bornée ; le champ libre est filtré (taille,
  pas d'URL) et le modèle reçoit l'instruction de ne jamais suivre une consigne de l'élève qui
  contredit le prompt système (l'entrée élève est du **contenu non fiable**).
- **R-5** : streaming de la réponse ; échec API = message propre + aucun quota décompté.
- **R-6** : journalisation server-side (question, intention, tokens, latence, modèle — PAS le
  texte complet en logs applicatifs ; transcript en table dédiée, RLS owner/admin).
- **i18n** : UI FR/EN/AR ; la réponse suit `subjects.content_language`.
- **Hors périmètre (v1)** : voix/audio, génération d'exercices inédits (le « similaire » est
  **sélectionné**, pas généré — cohérent avec la ligne rouge de l'étude 12), tuteur proactif,
  mémoire conversationnelle inter-sessions (chaque question = un fil court).

## 3. Architecture technique (décisions fermées)

- **D-1 — Génération server-side uniquement** : server fn streaming (`createServerFn` +
  `requireSupabaseAuth`) → API Anthropic ; `ANTHROPIC_API_KEY` serveur (jamais côté client),
  ajoutée à docs/environment-variables.md. Rejeté : appel client (clé exposée, quotas
  contournables).
- **D-2 — Paliers de modèles pilotés par une constante serveur** : intention simple
  (« pourquoi faux », « étape par étape ») → modèle rapide/économique (tier Haiku) ;
  « explique autrement » après 2 échecs de compréhension → escalade un cran (tier Sonnet).
  Ids de modèles dans une constante serveur unique (`TUTOR_MODEL_TIERS`) — consulter le skill
  `claude-api` au moment de l'implémentation pour les ids/prix courants ; jamais d'id en dur
  dispersé.
- **D-3 — Le diagnostic est déterministe, pas LLM** : le tag de misconception vient de la
  télémétrie (étude 04), l'exercice similaire vient du graphe (étude 07,
  `get_exercises_for_competency` — repli : même chapitre, difficulté ±1). Le LLM **rédige**,
  il ne décide pas. C'est ce qui rend le tuteur fiable ET bon marché (contexte court, réponse
  bornée).
- **D-4 — Table transcript dédiée** `tutor_threads` (id, user_id, question_id, attempt_ref,
  intent, messages jsonb append-only, tokens_in/out, model, created_at ; RLS owner
  SELECT/admin ; INSERT server-only ; grants explicites ; purge 6 mois par le cron). Compteur
  quotas : `tutor_daily_usage` (user_id, day, count) entretenu dans la même transaction (R-3).
- **D-5 — Gating d'accès en SQL** : fonction `can_use_tutor(question, user)` SECURITY DEFINER
  qui vérifie R-1 (tentative soumise existante, pas de session active exam/duel) + R-3 (quota) —
  appelée en tête de la server fn ; pgTAP dessus. L'UI ne fait qu'afficher.

**Client** : nouvelle feature `src/features/tutor/` (barrel, `tutor.server.ts`,
`components/TutorPanel` — monté depuis l'écran de review de quest via le barrel public ; quest
n'importe pas tutor : le panneau est rendu par la **route** de review, qui compose les deux
features — respect des frontières). États : streaming, quota atteint (« reviens demain ou
utilise un indice »), hors-ligne.

**Observabilité** : logs structurés par requête (R-6) + compteur de coût journalier agrégé
(admin) ; alerte log si le coût/jour dépasse un seuil constant.

## 4. Plan d'exécution en lots

| lot | contenu                                                                                    | tests exigés                                                                               | dépend de                         |
| --- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ | --------------------------------- |
| 1   | Migration : `tutor_threads` + `tutor_daily_usage` + `can_use_tutor` (RLS/grants)           | pgTAP (R-1 matrice d'états, quotas R-3, RLS)                                               | étude 04 A0 en prod               |
| 2   | Server fn streaming + adaptateur Anthropic + prompt système + D-2/D-3 (sans « similaire ») | Vitest (adaptateur mocké : ancrage R-2, refus hors-sujet, quota décompté/non décompté R-5) | 1                                 |
| 3   | UI `TutorPanel` (streaming, intentions, états) + i18n/RTL + branchement review             | Vitest composants ; smoke:shell                                                            | 2                                 |
| 4   | « Exercice similaire » (D-3 via étude 07 ; repli chapitre) + « j'ai compris » (KPI)        | Vitest ; e2e authed (fil complet sur TEST, API mockée)                                     | 3 (+07 lot 4 pour la voie graphe) |
| 5   | Quotas premium différenciés + compteur parent (US-3) + tableau de coût admin               | Vitest ; pgTAP quotas différenciés                                                         | 3                                 |

- [ ] Lot 1 — schéma + gating (merge seul — DoD §7)
- [ ] Lot 2 — moteur serveur
- [ ] Lot 3 — panneau élève
- [ ] Lot 4 — similaire + boucle de compréhension
- [ ] Lot 5 — quotas premium + parent + coût

**Stop-points** : R-1 n'est jamais assoupli (aucun mode « tuteur pendant l'épreuve », même en
practice chronométrée) ; aucun id de modèle en dur hors `TUTOR_MODEL_TIERS` ; le prompt système
n'est modifiable que via revue architecte ; pas de génération de contenu pédagogique inédit
(ligne rouge partagée avec l'étude 12).

## 5. Stratégie de test

pgTAP = gating (R-1 : chaque état de session × chaque mode) + quotas. Vitest = adaptateur
Anthropic entièrement mocké (aucun appel réseau en CI) : construction du contexte R-2,
troncatures, refus, escalade D-2, erreurs R-5. E2E authed avec API mockée par variable d'env
(fil : rater une question → demander → « similaire » → jouer). `smoke:shell` au lot 3 (review =
code prod-gated). Un test de non-régression : `consume_hint` existant inchangé.

## 6. Risques & mitigations

- **RISK-1** Dérive de coût (probable/majeur) → R-3 plafond dur serveur + D-2 paliers + contexte
  court D-3 + tableau de coût lot 5 + alerte seuil. Le tuteur est **désactivable par flag**
  serveur (kill switch constant).
- **RISK-2** Réponse fausse du tuteur (possible/majeur — confiance parents) → D-3 : la clé et
  l'explication canonique sont TOUJOURS dans le contexte ; instruction de ne jamais contredire
  la clé ; bouton « signaler » branché sur `content_reports` existant (triage humain).
- **RISK-3** Contournement anti-triche (possible/majeur) → R-1 en SQL (D-5), testé état par
  état ; les épreuves notées (exam/duel) vérifient déjà côté serveur.
- **RISK-4** Injection via le champ libre (probable/moyen) → R-4 : entrée traitée comme non
  fiable, intentions fermées par défaut, champ libre court et optionnel (désactivable par flag).
- **RISK-5** Dépendance fournisseur (rare/moyen) → adaptateur isolé (comme le PSP de l'étude 01) ; le contrat interne ne mentionne pas Anthropic.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : quotas exacts — proposition : 5 interactions/jour gratuit, 20/jour entitled, au-delà
  1 hint par tranche de 5 ; plafond dur 40/jour.
- **Q-2** : le parent voit-il le transcript (transparence) ou seulement le compteur (confiance
  élève) ? Proposition : compteur v1.
- **Q-3** : budget de coût mensuel acceptable par élève actif (calibre D-2 et les quotas).
- **Q-4** : ton du personnage (« Prof Yahia » ? mascotte existante ?) — assets/branding.

## 8. Journal d'exécution

_(vide — rempli par l'exécuteur, lot par lot)_
