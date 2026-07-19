# Guide fonctionnel — Rappel actif (étude 17)

> **Public** : produit, ops/support, développeurs.
> **Statut** : livré (5 lots — PRs #412 / #414 / #416 / #427 + ce lot). Machinerie DB + server
> fns + UI + i18n×3 + e2e.
> Ce guide explique **comment ça marche pour l'élève et comment l'exploiter**. Le contrat
> d'architecture (RPC, RLS, invariants R-x, normalisation R-4) reste la source de vérité :
> [`FableEtudes/17-rappel-actif/ETUDE.md`](../FableEtudes/17-rappel-actif/ETUDE.md).
> En cas de contradiction, AGENTS.md et l'ETUDE.md priment.

## Ce que c'est

Le **Rappel** (active recall) est une **seconde forme** d'une mission QCM déjà maîtrisée :
mêmes questions, **aucune option affichée**, l'élève **tape** sa réponse au clavier, et le
serveur la compare — normalisée — à la bonne réponse déjà en base. C'est un **mode
d'affichage et de scoring** d'un exercice existant, pas un nouveau contenu : aucune question
générée, aucune donnée dupliquée, **zéro coût de génération IA**. Réviser en produisant la
réponse (au lieu de la reconnaître parmi 4) consolide bien mieux la mémoire — c'est la valeur
pédagogique du mode. Il est **plus difficile** et **mieux récompensé** (**XP ×1,5**).

C'est une feature de **rétention / profondeur** : elle « double » ~2 000 missions du catalogue
sans écrire une ligne de contenu.

## Le parcours élève

### Débloquer une mission Rappel

Le Rappel n'est pas un dead-end ni une promesse creuse : il **n'apparaît que là où il est
jouable**. Une mission expose sa variante Rappel quand **les deux** conditions sont réunies :

1. **Éligibilité du contenu** : la mission compte **au moins 3 questions éligibles**
   (`RECALL_MIN_QUESTIONS`). Une question est éligible (règle déterministe R-2, calculée en
   base par `is_question_recall_eligible`) si c'est un vrai QCM à ≥ 3 options dont la bonne
   réponse est **une chaîne courte tapable** (1 à 60 caractères) et dont l'énoncé est
   **auto-suffisant** (il ne renvoie pas aux options, pas de figure). ~2 000 missions du
   catalogue qualifient.
2. **Maîtrise** : l'élève a **terminé la mission à 100 %** (`RECALL_UNLOCK_SCORE_PCT`) en
   mode classique, **sans précipitation** (temps ≥ 4 s/question — le même plancher anti-farm
   que le scoring normal). Un 100 % « rushé » ne débloque pas.

Sur le **hub de la matière** (`/matiere/$subjectId`), chaque mission éligible porte alors un
**chip « 🧠 Rappel »** (visible **connecté uniquement** — R-9, jamais pour un visiteur anonyme) :

- **verrouillé** (`recall-chip-locked`) : mission éligible mais pas encore maîtrisée → un
  cadenas + la phrase « Termine d'abord la mission à 100 % ». Pas de lien.
- **débloqué** (`recall-chip-unlocked`) : mission maîtrisée → un lien doré vers la session
  Rappel, avec le **meilleur score Rappel** obtenu s'il existe.
- **absent** : anonyme, ligne de quiz, ou moins de 3 questions éligibles (aucun bruit).

### Jouer une session Rappel

Le chip débloqué mène à `/quest/$exerciseId?variant=recall` (le mode voyage comme **search
param** ; toute mission se joue en classique par défaut, sans param). En session Rappel :

- un **bandeau** rappelle qu'on est en mode Rappel (saisie libre, XP boostée) ;
- chaque question affiche son énoncé **sans aucune option** ; l'élève tape sa réponse dans un
  **champ texte** (jusqu'à 120 caractères, `RECALL_MAX_ANSWER_LENGTH`) ;
- une **barre de caractères** (« char bar ») propose les symboles spéciaux utiles de la
  **langue du contenu** (ex. lettres accentuées, caractères arabes) pour éviter les galères de
  clavier. Elle est **statique** — fixée par la langue du contenu, **jamais dérivée de la
  réponse** (anti-fuite R-12) ; elle est vide pour l'anglais ;
- **aucun indice** n'est disponible (hints = 0) — le mode teste la production, pas la
  reconnaissance ;
- à la validation, le serveur **normalise** la saisie et la bonne réponse (R-4 :
  minuscules, espaces réduits, ponctuation et diacritiques ignorés, chiffres unifiés, …)
  puis les compare pour une **égalité déterministe** — pas de correcteur flou, pas de crédit
  partiel, pas de Levenshtein.

L'écran de résultat est le même que le mode classique (score en %, révision question par
question), avec un **badge « Rappel »** et, à la première fois, une **célébration de
déblocage**.

### Récompenses & télémétrie

- **XP ×1,5** (`RECALL_XP_MULTIPLIER`) sur une session Rappel réussie — plus dur, mieux payé.
- Le **meilleur score est scindé par variante** : le meilleur score Rappel est suivi
  **séparément** du meilleur score classique (R-5/R-6) ; jouer en Rappel n'écrase pas le score
  QCM et vice-versa.
- **Enrichissement du moteur adaptatif** : une réponse tapée qui égale (une fois normalisée)
  un **distracteur** connu résout le **même `misconception_tag`** qu'un clic sur ce distracteur
  en QCM (R-7). Le Rappel **nourrit** la télémétrie des points faibles au lieu de l'appauvrir.
- Les **garde-fous anti-farm** classiques s'appliquent (plancher de temps par question, pas
  de re-farm d'une session déjà maîtrisée) : le ×1,5 ne contourne aucun garde-fou.

## Ce que le Rappel ne touche pas

Le quiz de compréhension (le seul verrou de l'app en phase gratuite), le Donjon et les duels
restent **inchangés** en v1. Le Rappel ne crée **pas** de nouveau `question_type` en base, pas
de crédit partiel, pas de correcteur subjectif. Les missions non éligibles (réponses longues,
énoncés dépendants des options, figures) n'exposent simplement pas la variante.

## Notes d'exploitation

- **Sécurité (pas d'oracle client)** : les fonctions de normalisation, d'éligibilité et de
  scoring Rappel sont **`REVOKE`d** de `anon`/`authenticated` (R-1) — la clé de réponse
  n'atteint jamais le client avant soumission, exactement comme `correct_option`. Un audit qui
  cherche une fuite doit vérifier que `getExercise` **ne renvoie pas** d'options en mode Rappel.
- **Qualité de normalisation** : le KPI cible est **< 1 %** de signalements « réponse juste
  refusée ». Le canal est le bouton **« Signaler une erreur »** de l'écran de résultat
  (feature `content-report`) → triage admin `/admin/content-reports`. Un pic sur ce motif = un
  trou dans la règle R-4 à corriger (jamais un contournement côté client).
- **Éligibilité = donnée dérivée** : elle se recalcule à chaque `content:build` (les colonnes
  et fonctions sont en base, appliquées via migration). Ajouter/retirer des questions à une
  mission peut faire (dis)paraître son chip Rappel.
- **e2e** : la couverture bout-en-bout vit dans `e2e/authed/recall-mode.spec.ts` (maîtriser →
  chip débloqué → jouer en saisie libre → XP créditée). Elle **skip proprement** si le
  catalogue TEST n'a aucune mission éligible. Le multiplicateur ×1,5 **exact** est épinglé par
  pgTAP (lot 2, R-5), pas par l'e2e (XP monotone sous utilisateur de test partagé).

## Constantes (source unique)

`src/shared/constants/gamification.ts` :

| constante                  | valeur | rôle                                                    |
| -------------------------- | ------ | ------------------------------------------------------- |
| `RECALL_XP_MULTIPLIER`     | 1.5    | multiplicateur d'XP d'une session Rappel réussie        |
| `RECALL_MIN_QUESTIONS`     | 3      | minimum de questions éligibles pour exposer la variante |
| `RECALL_UNLOCK_SCORE_PCT`  | 100    | score classique requis pour débloquer (non rushé)       |
| `RECALL_MAX_ANSWER_LENGTH` | 120    | longueur max du champ de saisie libre                   |

Changer une règle de jeu se fait **là**, jamais en dur dans un composant.
