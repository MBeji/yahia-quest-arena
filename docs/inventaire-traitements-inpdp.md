# Inventaire des traitements & projet de registre (INPDP) — GAP-003

> **Ce que ce document est** : l'inventaire des données personnelles que
> l'application traite **réellement**, dérivé du code, des migrations et des types
> générés depuis la base de production — pas d'un modèle générique. Chaque ligne
> est vérifiable dans le dépôt, et la méthode est écrite pour être **rejouée**.
>
> **Ce qu'il n'est pas** : un avis juridique. Il n'affirme que ce que le code
> prouve. Il ne qualifie aucune base légale, ne fixe aucune durée de conservation
> et ne prétend pas qu'une déclaration a été faite. Ces trois choses relèvent de
> la décision, pas du constat — elles sont rassemblées au §7.
>
> **Arbitrage du 2026-08-24** : le dossier est monté en interne, sans conseil
> externe (journal des décisions). La contrepartie a été écrite ce jour-là et
> reste vraie : personne n'aura validé l'interprétation, sur le seul sujet du
> projet où une erreur ne se corrige pas par un revert.
>
> **Établi le 2026-08-24.** Un inventaire est périssable — voir §8.

---

## 1. Les trois constats qui commandent le reste

**a) La politique de confidentialité a pris du retard sur le code.** Son en-tête
pose la règle : « toute nouvelle destination de données doit être ajoutée ici DANS
LA MÊME PR que le code qui l'introduit, sinon cette page devient un mensonge ».
Son inventaire date du **2026-07-31**, révisé le **2026-08-19**. Or **16 tables**
ont été créées entre le 2026-08-22 et le 2026-08-24, dont
`tutor_threads`, `tutor_explanations` et `tutor_digests` — c'est-à-dire des
**conversations d'un enfant avec une IA** — et `ai_credentials`, qui héberge la
clé d'API d'une famille.

⚠️ **Atténuation, et elle est réelle** : l'étage IA est **éteint**. Aucune clé de
fournisseur n'a jamais été branchée, `AI_KEY_ENC_KEY` n'est pas posée, et sans
elle aucune identification de fournisseur ne peut être déchiffrée. Ces tables sont
donc **vides par construction**, et l'arbitrage du 2026-08-24 les y maintient. La
page n'est pas fausse **aujourd'hui** ; elle le deviendrait le jour de la première
clé. Le §7 en fait un point bloquant du pilote, pas du lancement.

**b) L'application ne sait pas qu'un utilisateur est mineur.** L'inscription
demande **quatre choses** : adresse e-mail, mot de passe, pseudonyme
(`display_name`) et rôle (élève ou parent). Ni date de naissance, ni âge, ni nom
réel — vérifié dans `src/routes/auth.tsx` (`supabase.auth.signUp`) et dans la table
`profiles`, qui ne porte **aucune** de ces colonnes. Le public visé est pourtant
entièrement composé d'enfants. C'est le point le plus important du dossier : la
conformité « mineurs » porte sur une population que le système **ne distingue pas
techniquement**.

**c) L'audience est enfantine et l'analytique n'attend aucun consentement.**
`Google Analytics 4` (gtag.js) est chargé en **build de production** et émet un
`page_view` au premier chargement puis à chaque navigation. Aucune bannière de
consentement n'existe dans le code : le seul cookie posé par l'application est
celui de la **langue**.

---

## 2. Méthode — pour que l'inventaire se rejoue au lieu de se croire

| Question                                     | Source de vérité interrogée                                                                                                                           |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Quelles tables existent vraiment ?           | `types.ts` (généré depuis la base) **croisé avec** les `CREATE TABLE` des migrations — voir l'avertissement sous ce tableau                           |
| Quelles colonnes portent de l'identité ?     | Bloc `Row:` de chaque table, lu colonne par colonne                                                                                                   |
| Qu'est-ce qui est collecté à l'inscription ? | L'appel `supabase.auth.signUp` de `src/routes/auth.tsx`                                                                                               |
| Où partent les données ?                     | `analytics.ts`, `product-analytics.ts`, `monitoring.ts`, `video-embed.tsx`, `csp.ts` — la CSP est le juge : un hôte non listé ne peut pas être appelé |
| Qu'efface une suppression de compte ?        | `supabase/migrations/20260819170000_account_deletion_fk.sql` et `deleteAccount` (`auth.server.ts`)                                                    |
| Quelles tables sont neuves ?                 | `ls supabase/migrations/` filtré par horodatage, croisé avec les `CREATE TABLE`                                                                       |

> ⚠️ **Les types générés retardent, et l'inventaire s'en serait trouvé faux.**
> Au 2026-08-24, `types.ts` décrit **57 tables** et n'en connaît **aucune** des
> **16** tables `ai_*` / `tutor_*` créées par migration entre le 2026-08-22 et le
> 2026-08-24 — soit **73 tables** en réalité. Le fichier n'a pas été régénéré
> depuis, et il ne peut l'être que depuis une base réelle. Interroger les seuls
> types aurait donc produit un inventaire qui **omet précisément** les
> traitements les plus sensibles du dossier : les conversations d'un enfant avec
> une IA. Croiser avec les migrations n'est pas une précaution de style.

---

## 3. Ce qui est collecté, par finalité

### 3.1 Compte et identité

| Donnée                                | Où elle vit                      | Remarque                                     |
| ------------------------------------- | -------------------------------- | -------------------------------------------- |
| Adresse e-mail                        | `auth.users` (schéma Supabase)   | **Pas** dans les tables applicatives         |
| Mot de passe                          | `auth.users`, haché par Supabase | Jamais lu par l'application                  |
| Pseudonyme (`display_name`)           | `profiles`                       | Choisi par l'élève, modifiable               |
| Rôle (élève / parent / admin)         | `profiles.role`                  | Décide de ce que l'utilisateur voit          |
| Identité Google (si connexion Google) | `auth.users`                     | OAuth ; l'application ne stocke rien de plus |

> **`profiles` ne contient ni nom réel, ni âge, ni adresse, ni téléphone.** C'est
> une donnée de conception, pas un oubli : l'application fonctionne sur un
> pseudonyme.

### 3.2 Activité d'apprentissage — le gros du volume

`attempts`, `question_attempts`, `exercise_sessions`, `daily_objectives`,
`weekly_quests`, `spaced_repetition_schedule`, `difficulty_adaptation`,
`user_misconceptions`, `user_competency_mastery`, `learning_pulses`,
`mock_exam_sessions`, `dungeon_runs`, `dungeon_run_questions`, `duels`,
`duel_participants`, `duel_queue`, `duel_league_awards`, `student_badges`,
`inventory_items`, `exercise_assignments`, `parcours_interest`.

Toutes rattachées à un `user_id`. Elles décrivent **ce qu'un enfant a répondu,
quand, en combien de temps, et ce qu'il ne comprend pas** (`user_misconceptions`,
`user_competency_mastery`). C'est de la donnée de comportement scolaire, plus
sensible en pratique que l'e-mail.

### 3.3 Lien parental

`parent_student_links` (`parent_user_id`, `student_user_id`, `relation_label`) et
`parent_weekly_goals`. Un parent lié voit le suivi de l'enfant.

### 3.4 Texte libre écrit par un enfant

`bug_reports.message` et `content_reports.message`. **Champ libre** : il peut
contenir n'importe quoi, y compris des données que l'application ne demande pas.
Le pipeline de triage traite ce texte comme **non fiable** et le fait passer par
un écran de sécurité avant toute lecture — c'est une protection contre l'injection,
pas contre la divulgation.

### 3.5 Technique

| Table                  | Contenu                                    | Remarque                                                                                                                                                                                                                                                 |
| ---------------------- | ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `push_subscriptions`   | `endpoint`, `auth`, `p256dh`, `user_agent` | Identifiants de notification + agent du navigateur                                                                                                                                                                                                       |
| `rate_limit_events`    | Horodatages par utilisateur                | Anti-abus                                                                                                                                                                                                                                                |
| `beta_access_requests` | **`email` + `name` en clair**              | ⚠️ La **seule** table applicative portant de l'état civil. Héritée de la phase bêta ; le code existe encore (`src/features/subscription/beta-access.server.ts`) alors que l'application est publique et gratuite depuis le 2026-06-21 — à vérifier au §7 |

### 3.6 Étage IA — **dormant**, tables créées, aucune donnée

`ai_credentials` (clé d'API d'une famille, chiffrée AES-256-GCM à clé maîtresse
hors base), `ai_usage_events`, `ai_spend_ledger`, `ai_energy_ledger`,
`ai_platform_ledger`, `ai_budget_alerts`, `ai_student_access`, `ai_admin_state`,
`ai_owner_suspensions`, `ai_forged_quizzes`, `ai_feedback`, `tutor_threads`,
`tutor_explanations`, `tutor_digests`, `tutor_feedback`, `tutor_prefs`.

**Rien n'y transite tant que l'étage est éteint** (§1a). Le jour où il s'allume,
deux choses changent d'un coup : une **conversation d'enfant** devient une donnée
conservée, et un **fournisseur d'IA** devient un sous-traitant.

---

## 4. Sous-traitants et destinataires

Établis par la CSP et le code, pas par déclaration.

| Tiers                             | Rôle                               | Ce qui part                                                                                          |
| --------------------------------- | ---------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Supabase**                      | Base de données + authentification | Tout le compte et toute l'activité                                                                   |
| **Vercel**                        | Hébergement et rendu serveur       | Trafic HTTP, journaux                                                                                |
| **Google Analytics 4**            | Mesure de fréquentation            | `page_view` — **sans consentement préalable** (§1c)                                                  |
| **Sentry**                        | Rapports d'erreur techniques       | Traces d'erreur                                                                                      |
| **YouTube (Google)**              | Vidéos explicatives                | ⚠️ Rien **avant** le clic : l'aperçu est servi localement, l'appel à Google n'a lieu qu'à la lecture |
| **Service de push du navigateur** | Notifications                      | `endpoint` de l'abonnement                                                                           |
| _(à venir)_ **Fournisseur d'IA**  | Tuteur, Forge                      | **Néant aujourd'hui** — voir §1a                                                                     |

---

## 5. Conservation

**Constat : aucune donnée n'est purgée à l'ancienneté.** Aucun mécanisme de
rétention par âge n'existe dans les migrations. Les données vivent tant que le
compte vit.

**La suppression de compte, elle, existe et elle est nette** (livrée le
2026-08-19) : effacement **dur et immédiat** — `auth.admin.deleteUser` sur
`auth.users`, et **32 clés étrangères `ON DELETE CASCADE`** emportent le reste en
une transaction (profil, tentatives, séries, révisions, badges, duels, liens
parentaux, abonnements push).

Deux exceptions, délibérées et documentées dans la migration :

- **Les colonnes « qui a classé ce signalement »** (`resolved_by`, `reviewed_by`,
  `granted_by`) passent à `NULL` — l'identité d'un administrateur parti ne doit
  pas empêcher un départ ;
- **un signalement survit à son auteur** : une clé de réponse fausse reste fausse
  quand le témoin s'en va. Le lien vers l'auteur est rompu.

---

## 6. Qui accède à quoi

- **L'élève** : ses propres données, par RLS.
- **Le parent lié** : le suivi de l'enfant auquel `parent_student_links` le relie.
- **L'administrateur** : consoles de signalements, gardé par `is_admin()`.
- **La clé `service_role`** : contourne RLS. Elle vit **uniquement** dans les
  secrets GitHub Actions des workflows de signalements, et le seul chemin
  d'écriture du pipeline est `resolve-reports.mjs`. Aucune session locale ne la
  détient — c'est un filet, pas un oubli.
- **La clé de réponse** (`correct_option`, `distractor_tags`) n'est **jamais**
  envoyée au client, phase gratuite ou non.

---

## 7. Ce que le registre exige et que le dépôt ne peut pas fournir

Ces points ne se constatent pas dans le code. Ils se décident.

1. **Identité de l'éditeur** — raison sociale, adresse, responsable du traitement.
   Manque aussi aux mentions légales, qui le disent explicitement.
2. **Base légale de chaque traitement**, et la question qui la commande : **comment
   le consentement d'un enfant est-il recueilli, et celui d'un titulaire de
   l'autorité parentale ?** Rappel du §1b : le système ne connaît pas l'âge.
3. **Durées de conservation** — aucune n'existe aujourd'hui (§5). Le registre en
   demande ; les choisir est une décision.
4. **Google Analytics sans consentement** (§1c) : conserver, conditionner à un
   consentement, ou retirer.
5. **`beta_access_requests`** : la seule table portant e-mail et nom en clair, sur
   une fonctionnalité héritée d'une phase révolue. Si elle ne sert plus, la
   supprimer retire un traitement entier du registre — **c'est du code, donc à
   moi**, mais la décision de fermer la fonctionnalité est à toi.
6. **Avant la première clé d'IA** : la politique de confidentialité devra nommer
   le fournisseur, et le registre devra porter la conservation des conversations.
   Le pilote Q-9 ne peut pas démarrer sans ces deux lignes.

---

## 8. Règle de fraîcheur

Cet inventaire vaut pour l'état du **2026-08-24**. Il s'est périmé **cinq jours**
après le précédent — c'est le §1a. Deux gestes le maintiennent vrai :

- **la règle qui existe déjà** — toute nouvelle destination de données est ajoutée
  à la politique de confidentialité dans la **même PR** que le code ;
- **re-dériver le §3** avant tout dépôt ou toute mise à jour de déclaration, par la
  méthode du §2. Compter les tables est le contrôle le moins cher, à condition de
  compter aux DEUX endroits : **73 tables** au 2026-08-24 — 57 vues par les types
  générés, plus 16 que seules les migrations connaissent.
