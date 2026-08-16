-- =========================================================
-- `attempts.session_id` — contrat de schéma de la colonne additive.
--
-- La tentative doit retenir la session qui l'a produite, pour que le détail
-- question par question (`question_attempts`, indexé par session) se relie à elle
-- par une CLÉ et non par proximité temporelle. Ce fichier assied le contrat de la
-- colonne ; le comportement de l'écrivain (`submit_exercise_attempt` la renseigne)
-- arrive avec la PR qui rouvre la RPC — la colonne part seule, sans écrivain
-- (DoD §7).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(7);

SELECT has_column('public', 'attempts', 'session_id',
  'attempts porte une colonne session_id');

SELECT col_type_is('public', 'attempts', 'session_id', 'uuid',
  'attempts.session_id est un uuid');

-- Nullable par construction : les lignes antérieures à la colonne, et celles que
-- le backfill ne saura pas trancher, restent sans session.
SELECT col_is_null('public', 'attempts', 'session_id',
  'attempts.session_id est nullable — une tentative sans session reste une tentative');

SELECT is(
  (SELECT c.confrelid::regclass::text
     FROM pg_constraint c
     JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = c.conkey[1]
    WHERE c.conrelid = 'public.attempts'::regclass
      AND c.contype = 'f'
      AND a.attname = 'session_id'),
  'exercise_sessions',
  'attempts.session_id référence exercise_sessions'
);

-- L'action de suppression est le cœur du choix : une session est de
-- l'échafaudage, la tentative est le fait pédagogique. CASCADE effacerait le
-- score, l'XP et l'historique lu par le parent.
SELECT is(
  (SELECT c.confdeltype
     FROM pg_constraint c
     JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = c.conkey[1]
    WHERE c.conrelid = 'public.attempts'::regclass
      AND c.contype = 'f'
      AND a.attname = 'session_id'),
  'n'::"char",
  'supprimer une session met la référence à NULL, elle n''efface pas la tentative'
);

SELECT has_index('public', 'attempts', 'idx_attempts_session',
  'un index sert la clé étrangère (sans lui, chaque suppression de session balaye attempts)');

SELECT ok(
  has_column_privilege('authenticated', 'public.attempts', 'session_id', 'SELECT'),
  'la colonne hérite du GRANT SELECT de table : aucun grant nouveau à poser'
);

SELECT * FROM finish();
ROLLBACK;
