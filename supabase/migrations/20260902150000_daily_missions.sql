-- Étude 31 — lot 3 : LE JOUR (US-1, US-2, R-6, R-9 → R-12).
--
-- TROIS CONSTATS, UNE SEULE JOURNÉE À RÉPARER.
--
--   3. « Les missions sont figées depuis le premier jour » : UNE quotidienne
--      (`3_exercises`) et une hebdo, identiques pour tous, pour toujours. Les
--      types `10_min`, `complete_chapter`, `maintain_streak_5` sont documentés
--      dans le schéma et ne sont JAMAIS instanciés (é22 R-29 le disait déjà).
--   2. « L'anneau du jour affiche un chiffre faux » : sa progression est la somme
--      des `xp_reward` des objectifs COMPLÉTÉS, sur 100 en dur. Il vaut donc 0 %
--      ou 50 %, jamais l'XP réellement gagné.
--   6. Rien ne marque la FIN d'une session : l'objectif atteint ne se fête pas.
--
-- CE QUE CE LOT POSE
--
-- * **R-9/R-10 — trois missions par jour, tirées d'un pool typé de huit,
--   FILTRÉES par éligibilité réelle.** Proposer « 5 étages de donjon » à un élève
--   sans parcours, ou « une révision » à qui n'en a aucune due, c'est fabriquer
--   de l'échec (RISK-6). Le socle (`exercises_n`) est toujours en tête : il est
--   faisable par tout le monde, y compris le premier jour.
-- * **D-4 — le tirage est DÉTERMINISTE** : `md5(user ‖ date ‖ type)` ordonne le
--   pool. Mêmes (élève, jour) ⇒ mêmes missions, au rechargement comme au test.
--   Un aléa serveur n'apporterait rien qu'une rotation quotidienne n'apporte
--   déjà, et il rendrait la chose intestable.
-- * **R-11 — l'enveloppe du jour NE BOUGE PAS** : 50 XP / 10 pièces, comme
--   aujourd'hui. 15/3 par mission (×3) + 5/1 de bonus de complétion. Toute autre
--   valeur relève de é09 (§3.9), pas d'ici.
-- * **R-12 — l'anneau montre l'XP RÉELLEMENT gagné aujourd'hui**, sur un objectif
--   que l'élève choisit (50/100/200).
-- * **R-6 — la fin de session est une FIN** : le bonus de complétion est une
--   ligne à part, ce qui donne à l'écran un fait à fêter (« à demain ! ») au lieu
--   d'un enchaînement.
--
-- ⚠️ ÉCART ASSUMÉ AU §3.1 : deux colonnes de plus que la liste de l'étude,
-- `daily_xp_day` / `daily_xp_base`, tenues DANS `award_xp`. R-12 exige l'XP réel
-- du jour, or aucune source ne le donne : `attempts` ignore l'XP du donjon, des
-- duels et des objectifs (tous crédités par `award_xp` sans ligne de tentative).
-- Reconstituer la somme ailleurs, ce serait recopier quatre barèmes et les faire
-- diverger. Le compteur vit donc dans la MONNAIE elle-même : une remise à zéro au
-- premier crédit du jour, et l'XP du jour vaut `xp - daily_xp_base`. Exact pour
-- toutes les sources, aujourd'hui et demain.
--
-- Les fonctions réémises le sont par SUBSTITUTION depuis leur révision vivante
-- (mêmes ancres, corps copié ligne pour ligne) — la règle posée par
-- 20260831130000 et reprise au lot 2.

-- ===========================================================================
-- 1. Le profil : l'objectif choisi, et le compteur d'XP du jour.
-- ===========================================================================
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS daily_xp_goal INTEGER NOT NULL DEFAULT 100;

DO $$ BEGIN
  ALTER TABLE public.profiles
    ADD CONSTRAINT profiles_daily_xp_goal_check CHECK (daily_xp_goal IN (50, 100, 200));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- R-12 : « modifiable une fois par jour ». La date du dernier changement suffit —
-- pas de compteur, pas d'historique : on ne veut pas savoir combien de fois un
-- enfant a hésité, seulement empêcher le yo-yo qui viderait l'objectif de sens.
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS daily_xp_goal_set_on DATE;

-- Le compteur d'XP du jour (écart assumé ci-dessus). `daily_xp_base` est l'XP
-- TOTAL au premier crédit de la journée ; l'XP du jour en est la différence.
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS daily_xp_day DATE,
  ADD COLUMN IF NOT EXISTS daily_xp_base INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN public.profiles.daily_xp_base IS
  'XP total au premier crédit du jour (é31 R-12). XP du jour = xp - daily_xp_base quand daily_xp_day = jour UTC courant. Tenu par award_xp, l''unique frappe.';

-- ===========================================================================
-- 2. Choisir son objectif du jour (US-2). Une fois par jour, et c'est tout.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.set_daily_xp_goal(p_goal INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_today DATE := (clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_row public.profiles;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF p_goal NOT IN (50, 100, 200) THEN
    RAISE EXCEPTION 'Invalid daily goal';
  END IF;

  SELECT * INTO v_row FROM public.profiles WHERE id = v_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- Re-choisir la MÊME valeur n'est pas un changement : sinon un double clic
  -- consommerait le droit du jour, et l'élève croirait le réglage cassé.
  IF v_row.daily_xp_goal = p_goal THEN
    RETURN v_row;
  END IF;

  IF v_row.daily_xp_goal_set_on = v_today THEN
    RAISE EXCEPTION 'DAILY_GOAL_ALREADY_SET_TODAY';
  END IF;

  UPDATE public.profiles
     SET daily_xp_goal = p_goal, daily_xp_goal_set_on = v_today
   WHERE id = v_user
  RETURNING * INTO v_row;

  RETURN v_row;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_daily_xp_goal(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_daily_xp_goal(INT) TO authenticated;

-- ===========================================================================
-- 3. LE POOL DE MISSIONS (R-9/R-10) — huit types, filtrés par éligibilité RÉELLE.
--
--    Chaque ligne dit pourquoi elle peut être absente. Une mission impossible
--    n'est pas un défi, c'est une punition (RISK-6) — et l'élève ne peut pas
--    savoir qu'elle était impossible.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.app_daily_mission_pool(p_user UUID)
RETURNS TABLE (mission_type TEXT, target_value INT)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_theme TEXT;
  v_grade UUID;
  v_has_parcours BOOLEAN := false;
BEGIN
  SELECT pa.theme_id, pa.grade_id
    INTO v_theme, v_grade
    FROM public.profiles pr
    JOIN public.parcours pa ON pa.id = pr.current_parcours_id
   WHERE pr.id = p_user;
  v_has_parcours := v_theme IS NOT NULL;

  -- Le SOCLE. Toujours présent, toujours en tête : faisable le premier jour,
  -- sans parcours, sans historique.
  mission_type := 'exercises_n'; target_value := 3; RETURN NEXT;

  -- Réussir un exercice à 90 % ou plus : ne demande rien d'autre qu'un exercice.
  mission_type := 'score_90'; target_value := 1; RETURN NEXT;

  -- Une révision DUE. Sans révision due, la mission serait un mur.
  IF EXISTS (
    SELECT 1 FROM public.spaced_repetition_schedule s
     WHERE s.user_id = p_user AND s.status = 'pending' AND s.scheduled_for <= now()
  ) THEN
    mission_type := 'review_due'; target_value := 1; RETURN NEXT;
  END IF;

  -- Deux exercices dans les matières du parcours. Sans parcours actif, il n'y a
  -- pas de « ton parcours » à désigner.
  IF v_has_parcours THEN
    mission_type := 'subject_focus'; target_value := 2; RETURN NEXT;
    -- Le donjon puise dans le parcours : sans parcours, pas de pool.
    mission_type := 'dungeon_floors'; target_value := 5; RETURN NEXT;
    -- Un duel s'apparie sur le parcours (match_duel).
    mission_type := 'duel_play'; target_value := 1; RETURN NEXT;
  END IF;

  -- Un rappel actif : il faut un exercice DÉJÀ débloqué en rappel (classique à
  -- 100 % sans précipitation, et au moins 3 questions éligibles). C'est la règle
  -- exacte de `start_exercise_session`, pas une approximation.
  IF EXISTS (
    SELECT 1
      FROM public.attempts a
      JOIN public.exercises e ON e.id = a.exercise_id
     WHERE a.user_id = p_user
       AND a.variant = 'classic'
       AND a.score_pct = 100
       AND a.duration_seconds >= a.total_count * 4
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
       AND (
         SELECT COUNT(*) FROM public.questions q
          WHERE q.exercise_id = e.id AND public.is_question_recall_eligible(q)
       ) >= 3
  ) THEN
    mission_type := 'recall_one'; target_value := 1; RETURN NEXT;
  END IF;

  -- Avancer le chapitre en cours : il faut qu'il reste une mission admin non
  -- réussie dans les matières du parcours.
  IF v_has_parcours AND EXISTS (
    SELECT 1
      FROM public.exercises e
      JOIN public.subjects s ON s.id = e.subject_id
     WHERE s.theme_id = v_theme
       AND (v_grade IS NULL OR s.grade_id = v_grade)
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
       AND NOT EXISTS (
         SELECT 1 FROM public.attempts a
          WHERE a.user_id = p_user AND a.exercise_id = e.id
            AND a.variant = 'classic' AND a.score_pct >= 60
       )
  ) THEN
    mission_type := 'chapter_step'; target_value := 1; RETURN NEXT;
  END IF;

  RETURN;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.app_daily_mission_pool(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.app_daily_mission_pool(UUID) TO authenticated;

-- ===========================================================================
-- 4. L'INCRÉMENT D'UNE MISSION, en un seul endroit.
--
--    Sept appelants (soumission, donjon, duel) et autant d'UPDATE recopiés, ce
--    sont sept endroits où la condition de complétion peut diverger. Le trigger
--    `credit_goal_reward` (é09/GAP-012) reste intact : il se déclenche sur le
--    passage à `completed`, quel que soit l'écrivain.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.bump_daily_mission(
  p_user UUID,
  p_type TEXT,
  p_day  DATE,
  p_by   INT DEFAULT 1
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF p_by <= 0 THEN
    RETURN;
  END IF;

  UPDATE public.daily_objectives
     SET current_value = LEAST(target_value, current_value + p_by),
         status = CASE
           WHEN current_value + p_by >= target_value THEN 'completed' ELSE 'active'
         END,
         completed_at = CASE
           WHEN current_value + p_by >= target_value AND completed_at IS NULL
             THEN clock_timestamp()
           ELSE completed_at
         END
   WHERE user_id = p_user
     AND objective_type = p_type
     AND objective_date = p_day
     AND status <> 'completed';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.bump_daily_mission(UUID, TEXT, DATE, INT) FROM PUBLIC, anon, authenticated;

-- ===========================================================================
-- 5. LE BONUS DE COMPLÉTION (R-11, R-6) — une ligne à part.
--
--    Elle porte les 5 XP / 1 pièce qui restent de l'enveloppe, et surtout elle
--    donne à l'écran un FAIT à fêter : « les trois sont finies ». Sans elle, la
--    fin de session ne serait qu'une troisième barre pleine parmi d'autres.
--    Son incrément passe par un trigger, pas par les appelants : ceux-ci n'ont
--    pas à savoir qu'un bonus existe.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.bump_daily_completion_bonus()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- La ligne de bonus ne s'incrémente pas elle-même (récursion), et seule une
  -- mission du MÊME jour compte.
  IF NEW.objective_type = 'daily_complete' THEN
    RETURN NEW;
  END IF;

  UPDATE public.daily_objectives
     SET current_value = LEAST(target_value, current_value + 1),
         status = CASE
           WHEN current_value + 1 >= target_value THEN 'completed' ELSE 'active'
         END,
         completed_at = CASE
           WHEN current_value + 1 >= target_value AND completed_at IS NULL
             THEN clock_timestamp()
           ELSE completed_at
         END
   WHERE user_id = NEW.user_id
     AND objective_type = 'daily_complete'
     AND objective_date = NEW.objective_date
     AND status <> 'completed';

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_daily_completion_bonus ON public.daily_objectives;
CREATE TRIGGER trg_daily_completion_bonus
  AFTER UPDATE ON public.daily_objectives
  FOR EACH ROW
  WHEN (NEW.status = 'completed' AND OLD.status IS DISTINCT FROM 'completed')
  EXECUTE FUNCTION public.bump_daily_completion_bonus();

-- ===========================================================================
-- 6. `ensure_daily_weekly_goals` — trois missions, tirées et filtrées.
--
--    ⚠️ L'HEBDO NE BOUGE PAS (stop-point du lot) : même type, mêmes valeurs.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.ensure_daily_weekly_goals(p_user uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_today      DATE := (clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_week_start DATE := date_trunc('week', clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_seed       TEXT;
  v_count      INT;
BEGIN
  -- Only ever create goals for the authenticated caller.
  IF p_user IS NULL OR p_user <> auth.uid() THEN
    RETURN;
  END IF;

  -- Idempotence : si le jour est déjà servi, on ne re-tire pas. Sans ce garde,
  -- un pool qui change en cours de journée (une révision devient due) changerait
  -- les missions sous les pieds de l'élève — le contraire de D-4.
  SELECT COUNT(*) INTO v_count
    FROM public.daily_objectives
   WHERE user_id = p_user AND objective_date = v_today;

  IF v_count = 0 THEN
    v_seed := p_user::text || v_today::text;

    -- Le socle d'abord (toujours faisable), puis DEUX du reste, ordonnés par un
    -- hachage stable : mêmes (élève, jour) ⇒ mêmes missions, au rechargement
    -- comme au test (D-4).
    INSERT INTO public.daily_objectives
      (user_id, objective_type, target_value, objective_date, xp_reward, coin_reward)
    SELECT p_user, m.mission_type, m.target_value, v_today, 15, 3
      FROM (
        SELECT pool.mission_type, pool.target_value,
               CASE WHEN pool.mission_type = 'exercises_n' THEN '' ELSE md5(v_seed || pool.mission_type) END AS ord
          FROM public.app_daily_mission_pool(p_user) pool
      ) m
     ORDER BY m.ord
     LIMIT 3
    ON CONFLICT (user_id, objective_type, objective_date) DO NOTHING;

    -- Le bonus de complétion : sa cible est le NOMBRE de missions réellement
    -- créées (un pool étroit peut n'en donner que deux), sinon il resterait
    -- inatteignable pour l'élève qui a le moins de choix.
    SELECT COUNT(*) INTO v_count
      FROM public.daily_objectives
     WHERE user_id = p_user AND objective_date = v_today;

    IF v_count > 0 THEN
      INSERT INTO public.daily_objectives
        (user_id, objective_type, target_value, objective_date, xp_reward, coin_reward)
      VALUES (p_user, 'daily_complete', v_count, v_today, 5, 1)
      ON CONFLICT (user_id, objective_type, objective_date) DO NOTHING;
    END IF;
  END IF;

  INSERT INTO public.weekly_quests
    (user_id, quest_type, target_value, week_start_date, xp_reward, coin_reward)
  VALUES (p_user, 'beat_2_bosses', 2, v_week_start, 100, 25)
  ON CONFLICT (user_id, quest_type, week_start_date) DO NOTHING;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.ensure_daily_weekly_goals(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.ensure_daily_weekly_goals(uuid) TO authenticated;

-- ===========================================================================
-- 7. Les missions d'hier ne changent pas de nom sous les pieds de l'élève —
--    mais celles d'AUJOURD'HUI doivent continuer d'être incrémentées par la
--    soumission, qui ne connaîtra plus `3_exercises`.
-- ===========================================================================
UPDATE public.daily_objectives
   SET objective_type = 'exercises_n'
 WHERE objective_type = '3_exercises'
   AND objective_date >= (clock_timestamp() AT TIME ZONE 'UTC')::date;


-- ===========================================================================
-- 8. `award_xp` — le compteur d'XP du jour. Substituée depuis 20260606130000
--    (deux ancres : la déclaration et l'UPDATE final), corps identique par
--    ailleurs. Les branches de série, le bouclier et la courbe de niveau ne
--    bougent pas d'une ligne.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.award_xp(p_user UUID, p_xp INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  today DATE := CURRENT_DATE;
  -- é31 lot 3 (R-12) — le compteur d'XP du jour, tenu dans la frappe elle-même.
  v_daily_base INT;
  new_streak INT;
  new_level INT;
  new_class TEXT;
  new_tier INT;
  caller_role TEXT := current_setting('request.jwt.claim.role', true);
  v_streak_shield_id uuid;
BEGIN
  IF p_xp IS NULL OR p_xp < 0 THEN
    RAISE EXCEPTION 'Invalid xp value';
  END IF;

  -- Allow service role jobs, otherwise enforce self-only updates.
  IF caller_role IS DISTINCT FROM 'service_role' AND auth.uid() IS DISTINCT FROM p_user THEN
    RAISE EXCEPTION 'Not allowed to award XP for another user';
  END IF;

  SELECT * INTO rec FROM public.profiles WHERE id = p_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- Streak logic
  IF rec.last_active_date IS NULL THEN
    new_streak := 1;
  ELSIF rec.last_active_date = today THEN
    new_streak := rec.current_streak;
  ELSIF rec.last_active_date = today - INTERVAL '1 day' THEN
    new_streak := rec.current_streak + 1;
  ELSIF rec.last_active_date = today - INTERVAL '2 days' THEN
    -- Exactly one missed day: a single armed streak shield can save the streak.
    -- Defensive lookup (LIMIT 1, locked) so a missing shield never breaks award_xp.
    SELECT inv.id
      INTO v_streak_shield_id
      FROM public.inventory_items inv
      JOIN public.shop_items si ON si.id = inv.shop_item_id
      WHERE inv.student_user_id = p_user
        AND inv.is_active = true
        AND inv.quantity >= 1
        AND si.item_type = 'shield'
        AND (si.effect_payload ? 'streakShield')
      ORDER BY inv.acquired_at ASC
      LIMIT 1
      FOR UPDATE OF inv;

    IF v_streak_shield_id IS NOT NULL THEN
      -- Preserve the streak (today still counts) and consume the shield.
      new_streak := rec.current_streak + 1;
      UPDATE public.inventory_items
        SET quantity = quantity - 1,
            is_active = false
        WHERE id = v_streak_shield_id;
      DELETE FROM public.inventory_items
        WHERE id = v_streak_shield_id AND quantity <= 0;
    ELSE
      new_streak := 1;
    END IF;
  ELSE
    -- Gap of >= 2 missed days: one shield can't save it → reset, do NOT consume.
    new_streak := 1;
  END IF;

  -- é31 lot 3 — L'XP DU JOUR, exact pour TOUTES les sources. `attempts` ignore
  -- le donjon, les duels et les objectifs : eux aussi passent par ici, et
  -- seulement par ici. Au premier crédit du jour, la base est l'XP d'AVANT ce
  -- crédit ; l'anneau lit ensuite `xp - daily_xp_base`.
  IF rec.daily_xp_day IS DISTINCT FROM today THEN
    v_daily_base := rec.xp;
  ELSE
    v_daily_base := rec.daily_xp_base;
  END IF;

  -- Level curve: each level = 200 xp
  new_level := GREATEST(1, ((rec.xp + p_xp) / 200) + 1);

  -- Hero class progression
  new_class := CASE
    WHEN new_level >= 50 THEN 'S-Rank Legend'
    WHEN new_level >= 31 THEN 'Elite du Concours'
    WHEN new_level >= 21 THEN 'Maitre des Langues'
    WHEN new_level >= 11 THEN 'Guerrier des Equations'
    WHEN new_level >= 6 THEN 'Aspirant Academicien'
    ELSE 'Candidat Civil'
  END;

  new_tier := LEAST(6, GREATEST(1, (new_level / 8) + 1));

  UPDATE public.profiles
  SET
    xp = xp + p_xp,
    level = new_level,
    hero_class = new_class,
    avatar_tier = new_tier,
    current_streak = new_streak,
    longest_streak = GREATEST(longest_streak, new_streak),
    last_active_date = today,
    daily_xp_day = today,
    daily_xp_base = v_daily_base
  WHERE id = p_user
  RETURNING * INTO rec;

  RETURN rec;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_xp(uuid, int) FROM authenticated, anon, public;

-- ===========================================================================
-- 9. `submit_exercise_attempt` — la soumission nourrit les missions du jour.
--    Substituée depuis 20260902140000 (lot 2), une seule ancre : l'ancien UPDATE
--    du type `3_exercises`. Le reste, badges compris, est identique.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.submit_exercise_attempt(
  p_session_id UUID,
  p_exercise_id UUID,
  p_answers JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_session public.exercise_sessions;
  v_exercise RECORD;
  v_attempt_id UUID;
  -- La tentative DÉJÀ enregistrée pour cette session, relue en cas de rejeu.
  v_replay public.attempts;
  v_profile public.profiles;
  v_unlocked_badges JSONB := '[]'::jsonb;
  v_badge JSONB;
  v_today DATE := (clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_week_start DATE := date_trunc('week', clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_correct_count INT := 0;
  v_total_count INT := 0;
  v_duration_seconds INT := 0;
  v_xp_earned INT := 0;
  v_coins_earned INT := 0;
  v_score_pct NUMERIC := 0;
  -- Prime de rapidité du mode BOSS uniquement (>= 1, jamais un malus).
  v_boss_speed_factor NUMERIC := 1;
  v_boss_par_seconds INT := 0;
  v_prev_best NUMERIC := -1;
  v_too_fast BOOLEAN := false;
  v_eligible BOOLEAN := false;
  -- Recall variant (étude 17) — read from the session, never a client argument.
  v_variant TEXT := 'classic';
  v_per_question JSONB := NULL;
  -- Potion (armed consumable) state.
  v_potion RECORD;
  v_xp_multiplier INT := 1;
  v_coin_multiplier INT := 1;
  v_potion_applied JSONB := NULL;
  -- Retry-shield (armed consumable) state.
  v_retry_shield RECORD;
  v_retry_shield_used BOOLEAN := false;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_session_id IS NULL OR p_exercise_id IS NULL THEN
    RAISE EXCEPTION 'Session and exercise are required';
  END IF;

  IF jsonb_typeof(p_answers) IS DISTINCT FROM 'array' THEN
    RAISE EXCEPTION 'Answers must be an array';
  END IF;

  IF jsonb_array_length(p_answers) < 1 OR jsonb_array_length(p_answers) > 100 THEN
    RAISE EXCEPTION 'Answers payload is out of bounds';
  END IF;

  SELECT *
  INTO v_session
  FROM public.exercise_sessions
  WHERE id = p_session_id
    AND user_id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid quest session.';
  END IF;

  IF v_session.exercise_id <> p_exercise_id THEN
    RAISE EXCEPTION 'Invalid quest session.';
  END IF;

  -- ===========================================================================
  -- REJEU D'UNE SESSION DÉJÀ RENDUE — lecture pure, aucune écriture.
  --
  -- CE QUI SE PASSAIT AVANT. Cette branche levait, et c'était la bonne garde
  -- anti-triche : sans elle, rejouer une soumission re-créditait XP, pièces et
  -- badges. Mais elle punissait aussi le cas HONNÊTE, et c'est celui-là qui se
  -- voyait en production : la soumission ABOUTIT, sa réponse se perd en route
  -- (réseau coupé au retour, onglet fermé, jeton refusé sur le trajet retour),
  -- et le rejeu — celui de 'outbox.ts', ou l'élève qui reclique — se voyait
  -- répondre « déjà terminée ». Son travail était enregistré ; il ne le savait
  -- pas, et n'avait plus aucun moyen de voir son score.
  --
  -- CE QUI CHANGE. On rend la tentative DÉJÀ écrite, au lieu de lever. La
  -- propriété anti-triche est intacte, et par construction plutôt que par
  -- promesse : cette branche sort AVANT le moindre INSERT/UPDATE, ne touche ni
  -- award_xp, ni award_coins, ni award_badge_if_new. Rejouer dix fois produit
  -- toujours exactement une ligne dans 'attempts'.
  --
  -- LES CHAMPS DE RÉCOMPENSE SONT NEUTRALISÉS, PAS RELUS. Pièces, badges,
  -- potion, bouclier et prime de rapidité ne sont pas stockés sur la tentative,
  -- et surtout ils ont déjà été crédités : le profil rendu ci-dessous en porte
  -- l'effet. Les ré-annoncer ferait rejouer les animations d'un gain qui n'a pas
  -- lieu deux fois. Le drapeau 'replayed' le dit au client, qui s'en sert pour
  -- ne pas refêter un score déjà fêté.
  -- ===========================================================================
  IF v_session.completed_at IS NOT NULL THEN
    SELECT *
      INTO v_replay
      FROM public.attempts
     WHERE session_id = p_session_id
       AND user_id = v_user_id
     ORDER BY completed_at DESC
     LIMIT 1;

    -- Session close SANS tentative rattachée : elle est antérieure à la colonne
    -- 'attempts.session_id' (20260816170000) et à son backfill. On ne sait pas
    -- quoi rendre, donc l'ancien refus reste le seul énoncé vrai.
    IF NOT FOUND THEN
      RAISE EXCEPTION 'This quest session is already completed.';
    END IF;

    SELECT *
      INTO v_profile
      FROM public.profiles
     WHERE id = v_user_id;

    RETURN jsonb_build_object(
      'correct', v_replay.correct_count,
      'total', v_replay.total_count,
      'scorePct', v_replay.score_pct,
      'xpEarned', v_replay.xp_earned,
      'durationSeconds', v_replay.duration_seconds,
      'variant', COALESCE(v_replay.variant, 'classic'),
      'profile', to_jsonb(v_profile),
      'coinsEarned', 0,
      'unlockedBadges', '[]'::jsonb,
      'potionApplied', NULL,
      'retryShieldUsed', false,
      'speedBonus', 1,
      'tooFast', false,
      'improved', false,
      'perQuestion', NULL,
      'replayed', true
    );
  END IF;

  -- The scoring/reward mode is an attribute of the SESSION (D-1) — an attacker
  -- cannot request a variant via the answers payload.
  v_variant := COALESCE(v_session.variant, 'classic');

  SELECT id, chapter_id, subject_id, xp_reward, reward_coins, mode
  INTO v_exercise
  FROM public.exercises
  WHERE id = p_exercise_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Exercise not found';
  END IF;

  -- Scoring. In 'recall' the play set is RESTRICTED to eligible questions and the
  -- typed free-text answer is scored by score_recall_answer (normalized, all-or-nothing);
  -- in 'classic' the whole set is scored by score_answer (unchanged, D-3).
  WITH normalized_answers AS (
    SELECT DISTINCT ON (a.question_id)
      a.question_id,
      a.choice
    FROM (
      SELECT
        NULLIF(elem->>'questionId', '')::UUID AS question_id,
        elem->>'choice' AS choice
      FROM jsonb_array_elements(p_answers) AS elem
    ) a
    WHERE a.question_id IS NOT NULL
    ORDER BY a.question_id
  )
  SELECT
    COUNT(*)::INT,
    COALESCE(SUM(
      CASE
        WHEN (CASE WHEN v_variant = 'recall'
                   THEN public.score_recall_answer(q, a.choice)
                   ELSE public.score_answer(q, a.choice) END)
        THEN 1 ELSE 0 END
    ), 0)::INT
  INTO v_total_count, v_correct_count
  FROM public.questions q
  LEFT JOIN normalized_answers a ON a.question_id = q.id
  WHERE q.exercise_id = p_exercise_id
    AND (v_variant = 'classic' OR public.is_question_recall_eligible(q));

  IF v_total_count <= 0 THEN
    RAISE EXCEPTION 'Exercise has no questions';
  END IF;

  -- Telemetry (étude 04 A0.2, D-2/R-1): one append-only question_attempts row
  -- per ANSWERED question, in this same transaction. The misconception tag is
  -- resolved server-side by `resolve_misconception_tag` (étude 20 lot 7) : la
  -- règle des trois variantes — option choisie (classique), texte tapé apparié
  -- à un distracteur (Rappel), texte tapé apparié à une erreur attendue
  -- (short_answer) — vit désormais dans UNE fonction, plus dupliquée entre les
  -- deux RPCs. Unanswered questions produce no row. Rewards/gates UNTOUCHED.
  INSERT INTO public.question_attempts
    (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source)
  SELECT
    v_user_id,
    q.id,
    v_exercise.chapter_id,
    p_session_id,
    a.choice,
    CASE WHEN v_variant = 'recall'
         THEN public.score_recall_answer(q, a.choice)
         ELSE public.score_answer(q, a.choice) END,
    public.resolve_misconception_tag(q, a.choice, v_variant),
    CASE WHEN v_exercise.mode = 'quiz' THEN 'quiz' ELSE 'exercise' END
  FROM (
    SELECT DISTINCT ON (x.question_id)
      x.question_id,
      x.choice
    FROM (
      SELECT
        NULLIF(elem->>'questionId', '')::UUID AS question_id,
        elem->>'choice' AS choice
      FROM jsonb_array_elements(p_answers) AS elem
    ) x
    WHERE x.question_id IS NOT NULL
    ORDER BY x.question_id
  ) a
  JOIN public.questions q ON q.id = a.question_id
  WHERE q.exercise_id = p_exercise_id
    AND a.choice IS NOT NULL
    AND (v_variant = 'classic' OR public.is_question_recall_eligible(q));

  -- Recall review payload (D-4): the RPC that SCORED returns the per-question
  -- verdicts so the TS never re-implements normalization. Eligible questions only,
  -- in display order; an unanswered eligible question scores false.
  IF v_variant = 'recall' THEN
    SELECT COALESCE(jsonb_agg(
             jsonb_build_object(
               'questionId', q.id,
               'isCorrect', public.score_recall_answer(q, a.choice)
             ) ORDER BY q.display_order
           ), '[]'::jsonb)
      INTO v_per_question
      FROM public.questions q
      LEFT JOIN (
        SELECT DISTINCT ON (x.question_id)
          x.question_id,
          x.choice
        FROM (
          SELECT
            NULLIF(elem->>'questionId', '')::UUID AS question_id,
            elem->>'choice' AS choice
          FROM jsonb_array_elements(p_answers) AS elem
        ) x
        WHERE x.question_id IS NOT NULL
        ORDER BY x.question_id
      ) a ON a.question_id = q.id
     WHERE q.exercise_id = p_exercise_id
       AND public.is_question_recall_eligible(q);
  END IF;

  v_score_pct := (v_correct_count::NUMERIC / v_total_count::NUMERIC) * 100;
  v_duration_seconds := GREATEST(
    1,
    ROUND(EXTRACT(EPOCH FROM (clock_timestamp() - v_session.started_at)))::INT
  );
  -- Anti-effortless-XP hardening (unchanged): XP/coins only when all three effort
  -- gates pass — not too fast (>= 4s/question), not random (>= 60%), and an
  -- improvement over the user's previous best ON THIS VARIANT (R-6: recall and
  -- classic keep separate bests, so a 100% classic never starves the first recall
  -- session of its XP, and vice-versa).
  SELECT COALESCE(MAX(score_pct), -1)
  INTO v_prev_best
  FROM public.attempts
  WHERE user_id = v_user_id
    AND exercise_id = p_exercise_id
    AND variant = v_variant;

  v_too_fast := v_duration_seconds < (v_total_count * 4);
  v_eligible := (NOT v_too_fast) AND (v_score_pct >= 60) AND (v_score_pct > v_prev_best);

  IF v_eligible THEN
    -- Prime de rapidité, mode BOSS SEULEMENT. Le chronomètre du combat est
    -- ouvert (il n'interrompt plus personne, cf. PR #742) : il note. Ici il
    -- note aussi les XP, mais uniquement là où la vitesse EST le sujet.
    --
    -- Ce n'est PAS le facteur de vitesse global purgé le 2026-06-04
    -- (20260604220000_harden_scoring_anti_rush.sql) : celui-là s'appliquait à
    -- TOUS les modes et descendait jusqu'à 0.5, donc punissait la lenteur et
    -- récompensait le bâclage. Celui-ci est borné à [1, 1.5] — jamais un
    -- malus — et n'est atteint qu'APRÈS les trois portes d'effort (pas trop
    -- vite : >= 4 s/question, >= 60 %, meilleur que le précédent record), qui
    -- restent la vraie digue anti-bâclage.
    --
    -- Le temps de référence budgète la lecture des corrections en plus de la
    -- réflexion (BOSS_XP_PAR_SECONDS_PER_QUESTION côté client) : la durée
    -- mesurée ici court de bout en bout de la session, écrans de correction
    -- compris. Prime pleine sous le temps de référence, décroissance linéaire,
    -- nulle à partir du double.
    IF v_exercise.mode = 'boss' THEN
      v_boss_par_seconds := GREATEST(1, v_total_count * 35);
      v_boss_speed_factor := LEAST(1.5, GREATEST(1.0,
        1 + 0.5 * (((2 * v_boss_par_seconds) - v_duration_seconds)::NUMERIC
                     / v_boss_par_seconds::NUMERIC)
      ));
    END IF;

    -- Recall is harder, so it pays RECALL_XP_MULTIPLIER (1.5) more (R-5); coins are
    -- unchanged. Multiply before rounding (xp_reward × score/100 × mult).
    v_xp_earned := ROUND(
      COALESCE(v_exercise.xp_reward, 0) * (v_score_pct / 100)
        * (CASE WHEN v_variant = 'recall' THEN 1.5 ELSE 1 END)
        * v_boss_speed_factor
    );
    v_coins_earned := COALESCE(v_exercise.reward_coins, 0);

    -- Potion step (anti-cheat: only on an already-eligible, reward-earning attempt).
    -- Look up the user's armed consumable potion. With one-armed-at-a-time there
    -- is at most one, but we resolve xp/coin multipliers independently in case a
    -- future iteration allows a combined potion.
    SELECT inv.id, si.code, si.name, si.effect_payload
      INTO v_potion
      FROM public.inventory_items inv
      JOIN public.shop_items si ON si.id = inv.shop_item_id
      WHERE inv.student_user_id = v_user_id
        AND inv.is_active = true
        AND inv.quantity >= 1
        AND si.item_type = 'potion'
        AND (si.effect_payload ? 'xpMultiplier' OR si.effect_payload ? 'coinMultiplier')
      ORDER BY inv.acquired_at ASC
      LIMIT 1
      -- Lock ONLY the inventory row (never the shared shop_items catalog) so two
      -- concurrent submissions can't both read+apply the same armed potion: the
      -- second submit blocks here, then re-checks and finds the potion gone.
      FOR UPDATE OF inv;

    IF FOUND THEN
      v_xp_multiplier := GREATEST(1, COALESCE((v_potion.effect_payload ->> 'xpMultiplier')::INT, 1));
      v_coin_multiplier := GREATEST(1, COALESCE((v_potion.effect_payload ->> 'coinMultiplier')::INT, 1));

      v_xp_earned := v_xp_earned * v_xp_multiplier;
      v_coins_earned := v_coins_earned * v_coin_multiplier;

      -- Consume the potion: -1 quantity, delete at 0, clear armed flag.
      UPDATE public.inventory_items
        SET quantity = quantity - 1,
            is_active = false
        WHERE id = v_potion.id;
      DELETE FROM public.inventory_items
        WHERE id = v_potion.id AND quantity <= 0;

      v_potion_applied := jsonb_build_object(
        'itemCode', v_potion.code,
        'itemName', v_potion.name,
        'xpMultiplier', v_xp_multiplier,
        'coinMultiplier', v_coin_multiplier
      );
    END IF;
  ELSE
    v_xp_earned := 0;
    v_coins_earned := 0;
  END IF;

  -- LA SEULE MODIFICATION DE CETTE FONCTION : la tentative retient la session
  -- qu'on vient de valider (verrou pris plus haut, appartenance et exercice
  -- vérifiés). Sans elle, relier une tentative à ses réponses question par
  -- question exigeait de deviner la session par proximité temporelle.
  INSERT INTO public.attempts (
    user_id,
    exercise_id,
    subject_id,
    correct_count,
    total_count,
    score_pct,
    duration_seconds,
    xp_earned,
    variant,
    session_id
  )
  VALUES (
    v_user_id,
    p_exercise_id,
    v_exercise.subject_id,
    v_correct_count,
    v_total_count,
    v_score_pct,
    v_duration_seconds,
    v_xp_earned,
    v_variant,
    p_session_id
  )
  RETURNING id INTO v_attempt_id;

  UPDATE public.exercise_sessions
  SET completed_at = clock_timestamp()
  WHERE id = p_session_id;

  PERFORM public.award_xp(v_user_id, v_xp_earned);

  IF v_coins_earned > 0 THEN
    PERFORM public.award_coins(v_user_id, v_coins_earned);
  END IF;

  SELECT *
  INTO v_profile
  FROM public.profiles
  WHERE id = v_user_id;

  -- First-quest badge: this is the user's first attempt iff no OTHER attempt
  -- exists. EXISTS short-circuits at the first row (served by
  -- idx_attempts_user_exercise / idx_attempts_user) instead of COUNT-ing the
  -- user's entire lifetime history on every submit. (perf audit H3)
  IF NOT EXISTS (
    SELECT 1 FROM public.attempts
    WHERE user_id = v_user_id AND id <> v_attempt_id
  ) THEN
    v_badge := public.award_badge_if_new(v_user_id, 'first_quest', 'First quest completed');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF v_score_pct = 100 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'perfect_score', 'Perfect score: 100%');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF v_duration_seconds < 60 AND v_score_pct >= 60 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'speed_demon', 'Quest completed in under 60s');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF COALESCE(v_profile.current_streak, 0) >= 7 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'streak_7', '7 consecutive days of studying');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  -- é31 lot 2 — LES CINQ CONDITIONS QUI MANQUAIENT ICI. `v_profile` vient d'être
  -- relu APRÈS `award_xp` : la série et le niveau sont ceux d'après cette
  -- tentative, donc le badge tombe le jour où il est mérité, pas le lendemain.
  IF COALESCE(v_profile.current_streak, 0) >= 30 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'streak_30', '30 consecutive days of studying');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF COALESCE(v_profile.level, 1) >= 10 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'level_10', 'Reached level 10');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF public.badge_is_math_subject(v_exercise.subject_id) THEN
    -- `math_blitz` porte déjà son seuil dans son rule_key (`math_95`).
    IF v_score_pct >= 95 THEN
      v_badge := public.award_badge_if_new(v_user_id, 'math_blitz', 'Scored 95%+ on a maths exercise');
      IF v_badge IS NOT NULL THEN
        v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
      END IF;
    END IF;

    -- Dix exercices DISTINCTS : rejouer dix fois le même n'est pas de la maîtrise.
    IF (
      SELECT COUNT(DISTINCT a.exercise_id)
      FROM public.attempts a
      WHERE a.user_id = v_user_id
        AND a.score_pct >= 80
        AND public.badge_is_math_subject(a.subject_id)
    ) >= 10 THEN
      v_badge := public.award_badge_if_new(v_user_id, 'math_master', '10 maths exercises passed at 80%+');
      IF v_badge IS NOT NULL THEN
        v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
      END IF;
    END IF;
  END IF;

  -- Polyglotte : trois LANGUES DE CONTENU différentes réussies. `content_language`
  -- porte une contrainte CHECK (ar/fr/en), donc la règle ne dépend d'aucune
  -- convention d'auteur — contrairement à « trois matières de langues », qui
  -- demanderait de deviner ce qu'est une matière de langue.
  IF (
    SELECT COUNT(DISTINCT s.content_language)
    FROM public.attempts a
    JOIN public.subjects s ON s.id = a.subject_id
    WHERE a.user_id = v_user_id
      AND a.score_pct >= 60
  ) >= 3 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'polyglot', 'Passed an exercise in three content languages');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF v_score_pct < 60 THEN
    -- Retry-shield step (anti-waste: only on an actual failure that would otherwise
    -- incur a penalty). If the user has an armed retry shield, SUPPRESS the
    -- spaced-repetition penalty and CONSUME the shield. "Best of two" falls out of
    -- the existing best-score eligibility gate when they replay.
    SELECT inv.id, si.code, si.name
      INTO v_retry_shield
      FROM public.inventory_items inv
      JOIN public.shop_items si ON si.id = inv.shop_item_id
      WHERE inv.student_user_id = v_user_id
        AND inv.is_active = true
        AND inv.quantity >= 1
        AND si.item_type = 'shield'
        AND (si.effect_payload ? 'retries')
      ORDER BY inv.acquired_at ASC
      LIMIT 1
      -- Lock ONLY the inventory row (never the shared shop_items catalog) — same
      -- concurrency reasoning as the potion step above.
      FOR UPDATE OF inv;

    IF FOUND THEN
      -- Consume the shield: -1 quantity, delete at 0, clear armed flag.
      UPDATE public.inventory_items
        SET quantity = quantity - 1,
            is_active = false
        WHERE id = v_retry_shield.id;
      DELETE FROM public.inventory_items
        WHERE id = v_retry_shield.id AND quantity <= 0;

      v_retry_shield_used := true;
      -- Penalty suppressed: skip the spaced-repetition scheduling entirely.
    ELSIF NOT EXISTS (
      SELECT 1
      FROM public.spaced_repetition_schedule s
      WHERE s.user_id = v_user_id
        AND s.exercise_id = p_exercise_id
        AND s.status = 'pending'
    ) THEN
      INSERT INTO public.spaced_repetition_schedule (
        user_id,
        exercise_id,
        subject_id,
        failed_attempt_id,
        retry_level,
        scheduled_for,
        status
      )
      VALUES
        (v_user_id, p_exercise_id, v_exercise.subject_id, v_attempt_id, 1, clock_timestamp() + INTERVAL '1 day', 'pending'),
        (v_user_id, p_exercise_id, v_exercise.subject_id, v_attempt_id, 2, clock_timestamp() + INTERVAL '3 days', 'pending'),
        (v_user_id, p_exercise_id, v_exercise.subject_id, v_attempt_id, 3, clock_timestamp() + INTERVAL '7 days', 'pending');
    END IF;

  ELSIF NOT v_too_fast THEN
    -- R-19 (etude 22) — LA BOUCLE SM-2 SE REFERME.
    --
    -- Jusqu'ici rien ne cloturait jamais une revision : les trois echeances etaient inserees
    -- a l'echec, puis restaient 'pending' pour toujours. Un eleve qui refaisait l'exercice et
    -- le reussissait continuait de voir la revision « due » sur son tableau de bord, sans
    -- aucun moyen de la faire disparaitre. La boucle etait ecrite, jamais fermee.
    --
    -- Condition : reussite (>= 60 %) ET non precipitee (>= 4 s/question). On n'exige
    -- deliberement PAS v_eligible : celui-ci ajoute « strictement meilleur que le precedent
    -- record », ce qui est un critere anti-farm pour l'XP, pas une definition de la reussite.
    -- Un eleve deja monte a 90 % qui repasse a 70 % a bel et bien reussi sa revision.
    --
    -- Aucun filtre sur la variante, par symetrie exacte avec l'insertion ci-dessus, qui n'en
    -- pose pas non plus : un Rappel reussi ferme donc aussi le cycle qu'un Rappel rate a ouvert.
    -- Un echec ulterieur rouvre normalement un cycle — la garde « aucune ligne pending » de
    -- l'insertion le permet, puisque les lignes cloturees ne sont plus 'pending'.
    UPDATE public.spaced_repetition_schedule
       SET status = 'completed',
           completed_at = clock_timestamp(),
           retry_score_pct = ROUND(v_score_pct)::INT,
           updated_at = clock_timestamp()
     WHERE user_id = v_user_id
       AND exercise_id = p_exercise_id
       AND status = 'pending';
  END IF;

  -- é31 lot 3 — LES MISSIONS DU JOUR. Une tentative peut en nourrir plusieurs :
  -- chacune est réclamée par le FAIT qui vient de se produire, jamais par le
  -- type de la mission — c'est ce qui rend le pool extensible sans toucher ici.
  PERFORM public.bump_daily_mission(v_user_id, 'exercises_n', v_today);

  IF v_score_pct >= 90 THEN
    PERFORM public.bump_daily_mission(v_user_id, 'score_90', v_today);
  END IF;

  IF v_variant = 'recall' THEN
    PERFORM public.bump_daily_mission(v_user_id, 'recall_one', v_today);
  END IF;

  -- Une révision due VIENT d'être close par cette tentative (le bloc SM-2
  -- ci-dessus l'a passée à `completed`) : la mission de révision la suit.
  IF EXISTS (
    SELECT 1 FROM public.spaced_repetition_schedule s
     WHERE s.user_id = v_user_id AND s.exercise_id = p_exercise_id
       AND s.status = 'completed' AND s.completed_at >= clock_timestamp() - INTERVAL '5 seconds'
  ) THEN
    PERFORM public.bump_daily_mission(v_user_id, 'review_due', v_today);
  END IF;

  -- « Dans ton parcours » : la matière de l'exercice appartient au parcours actif.
  IF EXISTS (
    SELECT 1
      FROM public.profiles pr
      JOIN public.parcours pa ON pa.id = pr.current_parcours_id
      JOIN public.subjects s ON s.theme_id = pa.theme_id
       AND (pa.grade_id IS NULL OR s.grade_id = pa.grade_id)
     WHERE pr.id = v_user_id AND s.id = v_exercise.subject_id
  ) THEN
    PERFORM public.bump_daily_mission(v_user_id, 'subject_focus', v_today);

    -- « Avancer le chapitre » : une PREMIÈRE réussite sur cet exercice. Un rejeu
    -- d'un exercice déjà réussi n'avance rien — `v_prev_best` porte le meilleur
    -- score d'avant cette tentative.
    IF v_score_pct >= 60 AND v_prev_best < 60 THEN
      PERFORM public.bump_daily_mission(v_user_id, 'chapter_step', v_today);
    END IF;
  END IF;

  IF v_score_pct >= 60 AND v_exercise.mode = 'boss' THEN
    UPDATE public.weekly_quests
    SET current_value = current_value + 1,
        status = CASE WHEN current_value + 1 >= target_value THEN 'completed' ELSE 'active' END,
        completed_at = CASE
          WHEN current_value + 1 >= target_value AND completed_at IS NULL THEN clock_timestamp()
          ELSE completed_at
        END
    WHERE user_id = v_user_id
      AND quest_type = 'beat_2_bosses'
      AND week_start_date = v_week_start;
  END IF;

  SELECT *
  INTO v_profile
  FROM public.profiles
  WHERE id = v_user_id;

  RETURN jsonb_build_object(
    'correct', v_correct_count,
    'total', v_total_count,
    'scorePct', v_score_pct,
    'xpEarned', v_xp_earned,
    'coinsEarned', v_coins_earned,
    'durationSeconds', v_duration_seconds,
    -- Prime de rapidité effectivement appliquée (1 = aucune, hors mode boss).
    'speedBonus', v_boss_speed_factor,
    'tooFast', v_too_fast,
    'improved', (v_score_pct > v_prev_best),
    'profile', to_jsonb(v_profile),
    'unlockedBadges', v_unlocked_badges,
    'potionApplied', v_potion_applied,
    'retryShieldUsed', v_retry_shield_used,
    'variant', v_variant,
    -- Per-question verdicts for the recall review (D-4); NULL in classic.
    'perQuestion', v_per_question
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) TO authenticated;

-- ===========================================================================
-- 10. `finalize_dungeon_run` — la mission « étages ». Substituée depuis le lot 2.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.finalize_dungeon_run(
  p_run_id UUID,
  p_duration_seconds INT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_run public.dungeon_runs;
  v_xp_earned INT;
  v_coins_earned INT;
  v_final_status TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_run_id IS NULL THEN
    RAISE EXCEPTION 'Run id is required';
  END IF;

  IF p_duration_seconds IS NULL OR p_duration_seconds < 0 OR p_duration_seconds > 86400 THEN
    RAISE EXCEPTION 'Invalid run duration';
  END IF;

  SELECT *
  INTO v_run
  FROM public.dungeon_runs
  WHERE id = p_run_id
    AND user_id = v_user
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid dungeon run.';
  END IF;

  v_xp_earned := v_run.floors_cleared * 15;
  v_coins_earned := (v_run.floors_cleared / 5) * 5;

  IF v_run.rewarded_at IS NULL THEN
    IF v_xp_earned > 0 THEN
      PERFORM public.award_xp(v_user, v_xp_earned);
    END IF;

    IF v_coins_earned > 0 THEN
      PERFORM public.award_coins(v_user, v_coins_earned);
    END IF;

    v_final_status := CASE WHEN v_run.status = 'active' THEN 'completed' ELSE v_run.status END;

    UPDATE public.dungeon_runs
    SET status = v_final_status,
        ended_at = COALESCE(v_run.ended_at, clock_timestamp()),
        duration_seconds = p_duration_seconds,
        rewarded_at = clock_timestamp()
    WHERE id = p_run_id;
  ELSE
    v_final_status := v_run.status;
  END IF;

  -- é31 lot 3 — la mission « 5 étages ». Les étages de CETTE course comptent,
  -- une seule fois : `rewarded_at` garde la course déjà soldée d'un second
  -- crédit, et la mission suit le même chemin.
  IF v_run.rewarded_at IS NULL AND v_run.floors_cleared > 0 THEN
    PERFORM public.bump_daily_mission(
      v_user, 'dungeon_floors', (clock_timestamp() AT TIME ZONE 'UTC')::date, v_run.floors_cleared
    );
  END IF;

  -- é31 lot 2 — `boss_slayer`. Le donjon est le seul endroit qui compte des
  -- étages ; le total CUMULÉ (toutes courses confondues) est le fait, pas le
  -- score d'une course — un élève qui tombe au 3ᵉ étage trois soirs de suite a
  -- affronté autant de boss que celui qui en enchaîne dix d'un coup.
  IF (
    SELECT COALESCE(SUM(r.floors_cleared), 0)
    FROM public.dungeon_runs r
    WHERE r.user_id = v_user
  ) >= 10 THEN
    PERFORM public.award_badge_if_new(v_user, 'boss_slayer', '10 dungeon floors cleared');
  END IF;

  RETURN jsonb_build_object(
    'floorsCleared', v_run.floors_cleared,
    'totalCorrect', v_run.total_correct,
    'totalAnswered', v_run.total_answered,
    'xpEarned', v_xp_earned,
    'coinsEarned', v_coins_earned,
    'durationSeconds', p_duration_seconds,
    'status', v_final_status
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.finalize_dungeon_run(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.finalize_dungeon_run(uuid, int) TO authenticated;

-- ===========================================================================
-- 11. `finalize_duel` — la mission « duel ». Substituée depuis 20260706170000,
--     une seule ancre (l'UPDATE de statut, en fin de corps).
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.finalize_duel(p_duel UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_duel public.duels;
  v_new_status TEXT;
  p RECORD;
  v_rewarded_today INT;
  v_xp INT;
  v_coins INT;
  v_win_xp CONSTANT INT := 60;  v_win_coins CONSTANT INT := 12;   -- DUEL_REWARDS.win
  v_draw_xp CONSTANT INT := 40; v_draw_coins CONSTANT INT := 8;   -- DUEL_REWARDS.draw
  v_loss_xp CONSTANT INT := 20; v_loss_coins CONSTANT INT := 4;   -- DUEL_REWARDS.loss
  v_all_finished BOOLEAN;
  v_top_score INT;
BEGIN
  SELECT * INTO v_duel FROM public.duels WHERE id = p_duel FOR UPDATE;
  IF NOT FOUND OR v_duel.status <> 'active' THEN
    RETURN;  -- unknown or already finalized (idempotent)
  END IF;

  -- Determine the new status: both finished → finished; else, if past expiry →
  -- expired; otherwise not ready (defensive no-op).
  SELECT bool_and(finished_at IS NOT NULL) INTO v_all_finished
    FROM public.duel_participants WHERE duel_id = p_duel;
  IF v_all_finished THEN
    v_new_status := 'finished';
  ELSIF now() >= v_duel.expires_at THEN
    v_new_status := 'expired';
  ELSE
    RETURN;
  END IF;

  -- The winning score = the max among players who FINISHED (an unfinished player
  -- in an expired duel cannot win). A unique finished top score wins; a tie among
  -- finishers is a draw; a lone finisher wins by forfait.
  SELECT max(score) INTO v_top_score
    FROM public.duel_participants
    WHERE duel_id = p_duel AND finished_at IS NOT NULL;

  FOR p IN
    SELECT * FROM public.duel_participants WHERE duel_id = p_duel
  LOOP
    -- Outcome → reward tier.
    IF p.finished_at IS NULL THEN
      v_xp := 0; v_coins := 0;                       -- did not finish (expired): nothing
    ELSIF p.score = v_top_score AND (
            SELECT count(*) FROM public.duel_participants
            WHERE duel_id = p_duel AND finished_at IS NOT NULL AND score = v_top_score
          ) = 1 THEN
      v_xp := v_win_xp; v_coins := v_win_coins;       -- unique top finisher: win/forfait
    ELSIF p.score = v_top_score THEN
      v_xp := v_draw_xp; v_coins := v_draw_coins;     -- tied top finishers: draw
    ELSE
      v_xp := v_loss_xp; v_coins := v_loss_coins;     -- finished but lower: participation
    END IF;

    -- Daily cap (R-7): count this player's already-rewarded duels today.
    IF v_xp > 0 THEN
      SELECT count(*) INTO v_rewarded_today
        FROM public.duel_participants
        WHERE user_id = p.user_id
          AND rewarded_at >= date_trunc('day', now());
      IF v_rewarded_today < 5 THEN  -- DUEL_MAX_REWARDED_PER_DAY
        PERFORM public.award_duel_rewards(p.user_id, v_xp, v_coins);
        UPDATE public.duel_participants
          SET rewarded_at = now()
          WHERE duel_id = p_duel AND user_id = p.user_id;
      END IF;
    END IF;
  END LOOP;

  -- é31 lot 3 — la mission « jouer un duel ». Elle compte la PARTICIPATION, pas
  -- la victoire (R-5 : pas d'humiliation) ; et seulement pour qui a réellement
  -- joué — un duel expiré sans réponse ne vaut pas une mission.
  FOR p IN
    SELECT * FROM public.duel_participants
     WHERE duel_id = p_duel AND finished_at IS NOT NULL
  LOOP
    PERFORM public.bump_daily_mission(
      p.user_id, 'duel_play', (clock_timestamp() AT TIME ZONE 'UTC')::date
    );
  END LOOP;

  UPDATE public.duels SET status = v_new_status WHERE id = p_duel;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.finalize_duel(UUID) FROM PUBLIC, anon, authenticated;
