-- `attempts.session_id` — la tentative retient enfin la session qui l'a produite.
--
-- LE MANQUE. `submit_exercise_attempt` valide une `exercise_sessions` (verrou,
-- appartenance, exercice attendu, pas déjà terminée), écrit la tentative, puis clôt
-- la session — le tout dans UNE transaction. La ligne `attempts` ne garde pourtant
-- aucune trace de l'identifiant qu'elle vient de valider. La télémétrie par question
-- (`question_attempts`, étude 04 A0), elle, est bien porteuse de `session_id`. Pour
-- relier une tentative à SES réponses il faut donc aujourd'hui recoller les deux
-- bouts par PROXIMITÉ TEMPORELLE : la session terminée du même couple (élève,
-- exercice) dont `completed_at` est la plus proche. C'est exact en pratique — même
-- transaction, quelques millisecondes d'écart — mais faux dès que deux onglets
-- jouent le même exercice en parallèle : le détail question par question montré au
-- parent peut alors appartenir à l'autre onglet.
--
-- CE LOT — la COLONNE seule : additive, nullable, sans écrivain. Le
-- `CREATE OR REPLACE` de `submit_exercise_attempt` qui la renseigne et le backfill
-- des lignes existantes partent dans une PR séparée (DoD §7 : le code qui dépend
-- d'une colonne ne voyage jamais dans la même livraison qu'elle). Entre les deux, la
-- colonne reste NULL partout et rien ne la lit — l'application déployée ne voit
-- aucune différence.
--
-- D-1 — ON DELETE SET NULL, jamais CASCADE. Une session est de l'échafaudage ; la
-- tentative est le FAIT pédagogique (score, XP, historique lu par le parent).
-- Perdre l'échafaudage ne doit pas effacer le fait. Les deux tables cascadent déjà
-- depuis `auth.users`, donc une suppression de compte reste complète.
--
-- D-2 — INDEX PARTIEL, pour la contrainte avant les lectures. Aucune requête ne
-- remonte encore de la session vers la tentative. L'index sert d'abord la clé
-- étrangère : sans index sur la colonne référençante, chaque suppression d'une
-- `exercise_sessions` (cascade d'une suppression de compte) impose un parcours
-- séquentiel d'`attempts` pour y poser le NULL. `WHERE session_id IS NOT NULL` le
-- garde étroit tant que les lignes d'avant le backfill sont nulles — et un NULL ne
-- sert ni la contrainte, ni aucune lecture.
--
-- D-3 — PAS D'UNICITÉ, malgré l'invariant « une session ne se soumet qu'une fois »
-- (la RPC refuse une session dont `completed_at` est déjà posé). Le backfill de la
-- PR suivante travaille sur des données de production qu'on ne peut pas mesurer
-- d'ici : un UNIQUE ferait ÉCHOUER la migration sur la première ambiguïté héritée,
-- et une chaîne de migrations bloquée coûte plus cher que le doublon qu'elle
-- éviterait. L'invariant est tenu par la RPC, pas par l'index.
--
-- Aucun grant nouveau : `attempts` porte déjà un GRANT SELECT au niveau TABLE
-- (20260612221000_baseline_table_grants.sql), qui couvre toute colonne ajoutée, et
-- les écritures directes y sont révoquées depuis 20260610160000 — seule la RPC
-- SECURITY DEFINER écrit. La policy RLS « own rows » est inchangée.

ALTER TABLE public.attempts
  ADD COLUMN IF NOT EXISTS session_id UUID
  REFERENCES public.exercise_sessions(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_attempts_session
  ON public.attempts (session_id)
  WHERE session_id IS NOT NULL;

COMMENT ON COLUMN public.attempts.session_id IS
  'Session de jeu dont cette tentative est le résultat (exercise_sessions.id). NULL sur les lignes antérieures à la colonne, et sur celles que le backfill n''a pas su trancher : la résolution par proximité temporelle reste alors le repli.';
