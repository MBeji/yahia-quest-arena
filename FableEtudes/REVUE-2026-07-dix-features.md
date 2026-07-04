# Revue d'architecte — les 10 features proposées (juillet 2026)

Verdicts de l'architecte sur la liste de 10 features, **confrontés à l'existant** (moteur QCM
server-side, pipeline de contenu déterministe à skills, entitlements par parcours, gamification
centralisée, modèle trilingue par conception). Chaque feature reçoit un **statut fonctionnel** ;
les statuts `approuvée` ont leur étude dans ce répertoire. Ce document est l'index de rattachement.

| #   | feature proposée                      | verdict                                                                                         | où                                                            |
| --- | ------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| 1   | Adaptive Learning Engine (IRT/BKT/ML) | 🔧 **approuvée re-scopée** — heuristique d'abord, modèles ensuite                               | études 04 (v1) + 07 (maîtrise) ; IRT/ML = phase gelée dans 07 |
| 2   | Génération IA de contenu (PDF→tout)   | 🔧 **approuvée re-scopée** — ingestion outillée DANS le pipeline à gates, jamais direct-en-base | étude 12                                                      |
| 3   | Knowledge Graph                       | ✅ **approuvée** — fusionnée avec la #4                                                         | étude 07                                                      |
| 4   | Profil de compétences par élève       | ✅ **approuvée** — c'est la vue du graphe                                                       | étude 07                                                      |
| 5   | Analytics enseignants/parents         | 🔧 **approuvée re-scopée** — descriptif v1, prédiction gelée                                    | étude 08                                                      |
| 6   | Game Economy                          | 🔧 **approuvée re-scopée** — instrumentation & garde-fous, pas de rebalance                     | étude 09                                                      |
| 7   | Pipeline IA de traduction             | ❌ **rejetée** — contraire à un choix de conception délibéré                                    | ci-dessous                                                    |
| 8   | Architecture multi-thèmes             | ⏸ **déjà satisfaite** — rien à construire                                                       | ci-dessous                                                    |
| 9   | Sécurité & anti-fraude                | ✅ **approuvée** (phasée après examens/duels)                                                   | étude 10                                                      |
| 10  | Agent IA pédagogique                  | ✅ **approuvée** (garde-fous stricts)                                                           | étude 11                                                      |

## Critiques détaillées (ce qui a changé entre la proposition et le statut approuvé)

**1. Adaptive Engine.** La proposition (IRT + BKT + ML d'emblée) souffre d'un problème de
démarrage à froid : l'IRT exige des milliers de réponses par item pour calibrer, et le catalogue
évolue en continu (UUIDs stables mais contenu enrichi chaque semaine). Décision : **échelle de
sophistication explicite** — (a) heuristique transparente (étude 04 : SM-2 dû + misconceptions
actives), (b) **maîtrise par compétence** type BKT-allégé/EWMA (étude 07 : explicable, robuste au
froid), (c) IRT/ML **gelés derrière un gate de volume** (étude 07 §Hors périmètre — on y va quand
les données le permettent, pas avant). « Quand déclencher un boss » reste au ladder (règle
produit), le moteur _recommande_, il ne réordonne pas le ladder.

**2. Génération IA.** La prémisse « le contenu est créé manuellement » est fausse : la
génération est déjà industrialisée (couches de skills, gates `content:check`/`qa:strict`,
migrations UUIDv5, audit planifié) — c'est précisément ce qui garantit la fidélité au programme
et la qualité des corrigés. Le vrai manque est **l'ingestion de sources arbitraires (PDF
enseignant)**. Ligne rouge maintenue : rien ne va « automatiquement » en base ; tout passe par
les fichiers `content/`, les gates et la revue. L'étude 12 outille l'entonnoir PDF→fichiers, pas
un bypass. (Contrainte technique assumée : Vercel serverless ≠ jobs longs — l'ingestion est un
workflow opéré, pas un bouton magique v1.)

**3+4. Knowledge Graph + profils.** Fusionnées : le profil de compétences EST la lecture du
graphe par la télémétrie. Décision structurante : pas de base graphe dédiée — un **registre de
compétences versionné dans le pipeline de contenu** (comme le registre de misconceptions de
l'étude 04), compilé en tables relationnelles (`competencies`, arêtes prérequis, mapping
question↔compétences), la maîtrise étant un agrégat entretenu. « Pourquoi échoue-t-il en
géométrie ? » = requête de chaîne de prérequis faibles, pas un score.

**5. Analytics.** « Comparaison avec la moyenne nationale » est rejetée telle quelle (données
inexistantes → mensonge produit) : v1 dit « moyenne de la plateforme », seuillée (N≥30).
« Prédiction du score au concours » : gelée jusqu'à un historique d'examens blancs suffisant
(étude 02 doit tourner d'abord). Le reste (temps d'étude, progression, faiblesses, percentile)
est approuvé en descriptif, sur la feature `parent-report` existante.

**6. Game Economy.** Le design existe déjà et il est centralisé (constantes + table canonique +
anti-farm). Le manque est la **boucle de mesure** : instrumentation, simulateur de personas
exécutant les vraies constantes, garde-fous chiffrés, et un processus (« pas de changement de
constante sans simulation avant/après »). Rebalance à l'aveugle : refusé.

**7. Traduction.** ❌ Rejetée : le modèle linguistique du produit est **par conception sans
traduction** — thèmes non scolaires = trois sujets frères **rédigés nativement** par langue
(idiomatiques, culturellement justes), scolaire = **monolingue dans la langue officielle
d'instruction** (l'élève passe le concours dans cette langue ; une traduction serait
pédagogiquement nuisible). Un « pipeline de traduction » réintroduirait la divergence qu'on a
éliminée. Ce qui est retenu du besoin réel : (a) le **pont ar→fr du lycée** (déjà spécifié,
`docs/lycee-architecture.md` §4) ; (b) un contrôle de **cohérence inter-frères** (même périmètre/
échelle de difficulté entre siblings fr/en/ar) à ajouter au skill `content-audit` — item de
backlog contenu, pas une étude logicielle.

**8. Multi-thèmes.** ⏸ Déjà satisfaite : la hiérarchie est en place, seuls les thèmes ont des
migrations de seed, tout le gameplay est theme-agnostic, et « médecine » ou « programmation » =
1 ligne `themes` + du contenu + (si payant) un parcours — zéro code. Le garde-fou existe
(`curriculum-architect` : ne jamais inventer un thème sans seed). Rien à construire ; si un
nouveau thème arrive, c'est un backlog `curriculum-architect`, pas une feature.

**9. Anti-fraude.** Approuvée, **phasée après** l'arrivée des enjeux (examens blancs, duels,
ligues) : aujourd'hui les surfaces compétitives sont faibles et l'anti-farm couvre l'essentiel.
Lignes rouges ajoutées : public mineur → détection server-side uniquement, revue humaine, pas de
sanction automatique, pas de fingerprinting invasif ; période d'observation à blanc pour
calibrer les faux positifs avant toute exclusion de classement.

**10. Tuteur IA.** Approuvée — c'est le rêve produit ET un champ de mines : coût par requête,
sécurité mineurs, et triche (un tuteur qui répond PENDANT une mission notée détruit le moteur).
Garde-fous fixés dans l'étude 11 : post-tentative uniquement, intentions fermées (pas de chat
libre), ancré sur le contenu maison (cours + explication + tag de misconception — le tuteur
_sait_ quelle erreur l'élève a exécutée), quotas intégrés à l'économie des indices existante,
modèle par paliers pour le coût.

## Ordre d'exécution recommandé (mis à jour, remplace la ligne du README)

`01 paiement` → `02 examen blanc` → `03-B1 numeric` → `04-A0/A1 télémétrie+révision` →
`07 compétences` (dès que A0 tourne) → `08 analytics` → `11 tuteur` (financé par 01, nourri par
04/07) → `09 économie` (en parallèle, indépendant) → `10 anti-fraude` (après 02/05) →
`05 duels` → `12 ingestion` → `06 PWA`.
