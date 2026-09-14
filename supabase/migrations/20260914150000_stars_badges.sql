-- =========================================================================
-- ÉTUDE 34 — LOT 4 : célébrer et collectionner (la part serveur).
-- -------------------------------------------------------------------------
-- Trois badges, et pas un de plus. C'est la décision D-7, et elle se chiffre :
-- 94 matières × 4 sceaux et 773 chapitres × 4 étoiles ne rentrent ni dans le
-- patron `Record<BadgeCode, …>` — la garantie `tsc` qui fait échouer la
-- compilation sur un badge sans son libellé, dans les trois langues — ni dans
-- le budget de 12 KB du chunk `i18n-badges`. Étoiles et sceaux vivent donc dans
-- leurs deux tables, et le système de badges ne reçoit que trois MÉTA-badges :
--
--   · `first_seal`       — le premier sceau, toute matière confondue ;
--   · `subject_elite`    — un sceau ⭐⭐⭐⭐, donc une matière entière maîtrisée ;
--   · `parcours_covered` — toutes les matières de sa classe portent le sceau ⭐.
--
-- ⚠️ AUCUNE XP, AUCUNE PIÈCE (R-11, D-10). La reconnaissance — célébrer, dater,
-- collectionner — suffit à la compétence perçue, et l'étude 09 garde seule la
-- main sur toute valeur. Q-3 a été posée et tranchée dans ce sens le 2026-09-14.
--
-- ⚠️ Le corps du trigger est repris par SCRIPT sur sa révision vivante
-- (`20260914120000`), avec deux substitutions ciblées — jamais retapé. Le point
-- d'accroche que le lot 1 avait laissé en commentaire est désormais rempli, et
-- le commentaire disparaît avec lui.
--
-- Migration ADDITIVE : trois lignes de `badges`, un `CREATE OR REPLACE` de
-- fonction. Aucun DROP, aucun REVOKE.
-- Preuves : `supabase/tests/104_badges_maitrise.test.sql`.
-- =========================================================================

-- ---------------------------------------------------------------------------
-- 1. LES TROIS BADGES. Famille `maitrise` — celle de la compétence prouvée, où
--    vivent déjà « Maître des Maths » et « Score Parfait ».
--
--    `rule_key` porte le code lui-même : ces badges ne sont décernés par aucune
--    règle générique, mais par le trigger des étoiles, qui les nomme en clair.
--    `ON CONFLICT DO UPDATE` sur famille et glyphe : même prudence que les
--    badges de saison, pour qu'un rejeu de la chaîne converge.
-- ---------------------------------------------------------------------------
INSERT INTO public.badges (code, name, description, rarity, icon_name, rule_key, family)
VALUES
  ('first_seal',       'Premier sceau',    'Obtenir son premier sceau de matière',
   'rare', 'Stamp', 'first_seal', 'maitrise'),
  ('subject_elite',    'Matière d''élite', 'Obtenir le sceau ⭐⭐⭐⭐ d''une matière — tous ses chapitres maîtrisés',
   'legendary', 'Gem', 'subject_elite', 'maitrise'),
  ('parcours_covered', 'Classe couverte',  'Obtenir le sceau ⭐ de toutes les matières de sa classe',
   'epic', 'Map', 'parcours_covered', 'maitrise')
ON CONFLICT (code) DO UPDATE
  SET family = EXCLUDED.family, icon_name = EXCLUDED.icon_name, rarity = EXCLUDED.rarity;

-- ---------------------------------------------------------------------------
-- 2. LE DÉCERNEMENT, à l'endroit prévu par le lot 1.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.record_progress_stars()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_chapter   UUID;
  v_subject   TEXT;
  -- Étude 34 lot 4 : le sceau le plus haut que CETTE tentative fait tomber, et le
  -- nombre de matières de la classe qui restent sans sceau. Deux variables, trois
  -- badges — et pas un de plus (D-7 : 94 matières × 4 sceaux ne rentrent ni dans
  -- `Record<BadgeCode, …>` ni dans le budget `i18n-badges`).
  v_seal_rows INT;
  v_uncovered INT;
  v_star      SMALLINT;
  v_missions  INT;
  v_inserted  INT := 0;
BEGIN
  -- Une reprise en Rappel n'a jamais complété un chapitre (é22) et ne gagne
  -- aucune étoile : même règle, même endroit.
  IF NEW.variant IS DISTINCT FROM 'classic' THEN
    RETURN NULL;
  END IF;

  SELECT e.chapter_id, e.subject_id
    INTO v_chapter, v_subject
    FROM public.exercises e
   WHERE e.id = NEW.exercise_id;

  IF v_chapter IS NULL THEN
    RETURN NULL;
  END IF;

  v_star := public.chapter_star_live(NEW.user_id, v_chapter);
  IF v_star < 1 THEN
    RETURN NULL;
  END IF;

  SELECT count(*)::INT INTO v_missions
    FROM public.exercises e
   WHERE e.chapter_id = v_chapter
     AND e.source = 'admin'
     AND e.mode IS DISTINCT FROM 'quiz';

  -- Les étoiles se gagnent DANS L'ORDRE : on inscrit 1..v_star, et
  -- `ON CONFLICT DO NOTHING` rend l'opération idempotente — une étoile déjà
  -- acquise garde sa date et son justificatif d'origine.
  INSERT INTO public.user_chapter_stars
    (user_id, chapter_id, star, reached_at, attempt_id, missions_at_reach)
  SELECT NEW.user_id, v_chapter, g.star::SMALLINT, NEW.completed_at, NEW.id, v_missions
    FROM generate_series(1, v_star) AS g(star)
  ON CONFLICT (user_id, chapter_id, star) DO NOTHING;

  GET DIAGNOSTICS v_inserted = ROW_COUNT;
  IF v_inserted = 0 THEN
    RETURN NULL;
  END IF;

  -- ---- Les sceaux (R-9, D-5) : sur le GRAND LIVRE, jamais sur le vivant. ----
  -- Un sceau r tombe quand plus aucun chapitre publié de la matière ne manque
  -- l'étoile r. Le calcul sur le grand livre est ce qui rend la promesse
  -- cohérente d'un étage à l'autre : sur le vivant, « 19/20 prêts »
  -- retomberait à 18/20 après une campagne — la régression qu'on vient de
  -- supprimer, un étage plus haut.
  INSERT INTO public.user_subject_seals
    (user_id, subject_id, star, reached_at, attempt_id, chapters_at_reach)
  SELECT
    NEW.user_id,
    v_subject,
    g.star::SMALLINT,
    NEW.completed_at,
    NEW.id,
    (SELECT count(*)::INT FROM public.chapters c
      WHERE c.subject_id = v_subject
        AND EXISTS (SELECT 1 FROM public.exercises e
                     WHERE e.chapter_id = c.id
                       AND e.source = 'admin'
                       AND e.mode IS DISTINCT FROM 'quiz'))
    FROM generate_series(1, v_star) AS g(star)
   WHERE EXISTS (
           -- au moins un chapitre publié : une matière vide ne se scelle pas
           SELECT 1 FROM public.chapters c
            WHERE c.subject_id = v_subject
              AND EXISTS (SELECT 1 FROM public.exercises e
                           WHERE e.chapter_id = c.id
                             AND e.source = 'admin'
                             AND e.mode IS DISTINCT FROM 'quiz')
         )
     AND NOT EXISTS (
           -- … et aucun qui manque l'étoile g.star au grand livre
           SELECT 1 FROM public.chapters c
            WHERE c.subject_id = v_subject
              AND EXISTS (SELECT 1 FROM public.exercises e
                           WHERE e.chapter_id = c.id
                             AND e.source = 'admin'
                             AND e.mode IS DISTINCT FROM 'quiz')
              AND NOT EXISTS (
                    SELECT 1 FROM public.user_chapter_stars s
                     WHERE s.user_id = NEW.user_id
                       AND s.chapter_id = c.id
                       AND s.star >= g.star
                  )
         )
  ON CONFLICT (user_id, subject_id, star) DO NOTHING;

  -- ⚠️ `GET DIAGNOSTICS`, PAS `RETURNING … INTO`. L'insertion ci-dessus pose
  -- 1..v_star lignes d'un coup (`generate_series`), et un `INTO` de plpgsql exige
  -- EXACTEMENT une ligne : il lève « query returned more than one row » dès qu'un
  -- élève gagne deux sceaux à la fois. Vécu à l'écriture de ce lot — la suite
  -- pgTAP entière est tombée, y compris des tests qui ne parlent pas d'étoiles,
  -- parce que le trigger s'exécute sur CHAQUE insertion dans `attempts`.
  GET DIAGNOSTICS v_seal_rows = ROW_COUNT;

  -- ---- Les trois badges (R-11, D-7) ----------------------------------------
  -- Décernés ICI, à l'endroit prévu par le lot 1, et seulement quand un sceau
  -- vient RÉELLEMENT de tomber : sans cette garde, chaque tentative d'un élève
  -- déjà scellé re-tenterait trois `award_badge_if_new` pour rien.
  --
  -- ⚠️ La raison porte l'id de tentative (`stars:<uuid>`) et c'est fonctionnel,
  -- pas décoratif : `get_attempt_progress` retrouve par là les badges de CETTE
  -- soumission, donc ce que l'écran de résultat a le droit de célébrer.
  --
  -- ⚠️ Un `INSERT ... ON CONFLICT DO NOTHING` ne compte que les lignes RÉELLEMENT
  -- posées : un sceau déjà acquis laisse le compte à zéro, et c'est exactement la
  -- garde d'idempotence qu'on veut.
  IF v_seal_rows > 0 THEN
    -- 1. Le PREMIER sceau, toute matière confondue.
    PERFORM public.award_badge_if_new(NEW.user_id, 'first_seal', 'stars:' || NEW.id);

    -- 2. L'ÉLITE : un sceau ⭐⭐⭐⭐, donc une matière entière maîtrisée.
    IF EXISTS (
      SELECT 1 FROM public.user_subject_seals sl
       WHERE sl.user_id = NEW.user_id AND sl.star = 4
    ) THEN
      PERFORM public.award_badge_if_new(NEW.user_id, 'subject_elite', 'stars:' || NEW.id);
    END IF;

    -- 3. LA CLASSE COUVERTE : toutes les matières de sa classe portent le sceau ⭐.
    --    Bornée aux matières qui ont au moins un chapitre PUBLIÉ : une matière
    --    vide ne peut pas se sceller, et sans cette borne le badge serait
    --    inatteignable pour toujours dès qu'une matière du programme est en
    --    attente de contenu. Un élève sans classe (`current_grade_id` NULL) n'a
    --    pas de périmètre : le helper rend NULL, et la garde `> 0` le laisse sortir.
    SELECT count(*)::INT INTO v_uncovered
      FROM public.subjects s
     WHERE s.id = ANY (COALESCE(public._student_class_subject_ids(NEW.user_id), ARRAY[]::TEXT[]))
       AND EXISTS (
         SELECT 1 FROM public.chapters c
          WHERE c.subject_id = s.id
            AND EXISTS (SELECT 1 FROM public.exercises e
                         WHERE e.chapter_id = c.id
                           AND e.source = 'admin'
                           AND e.mode IS DISTINCT FROM 'quiz')
       )
       AND NOT EXISTS (
         SELECT 1 FROM public.user_subject_seals sl
          WHERE sl.user_id = NEW.user_id AND sl.subject_id = s.id
       );

    IF v_uncovered = 0 AND EXISTS (
      SELECT 1 FROM public.user_subject_seals sl
       WHERE sl.user_id = NEW.user_id
         AND sl.subject_id = ANY (
               COALESCE(public._student_class_subject_ids(NEW.user_id), ARRAY[]::TEXT[]))
    ) THEN
      PERFORM public.award_badge_if_new(NEW.user_id, 'parcours_covered', 'stars:' || NEW.id);
    END IF;
  END IF;

  RETURN NULL;
END;
$fn$;

COMMENT ON FUNCTION public.record_progress_stars() IS
  'Étude 34 : le SEUL écrivain du grand livre des étoiles et des sceaux, sur AFTER INSERT ON attempts. Depuis le lot 4, il décerne aussi les trois badges de la famille maitrise — sans aucune XP ni pièce (R-11).';

-- ---------------------------------------------------------------------------
-- 3. LE DELTA D'UNE SOUMISSION porte enfin ses badges.
--
--    Ré-émise par script depuis sa révision vivante (`20260914130000`), avec une
--    seule substitution : le point d'accroche que le lot 1 avait laissé en
--    commentaire devient la clé `newBadges`.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_attempt_progress(p_attempt_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_chapter UUID;
  v_out     JSONB;
BEGIN
  -- Le propriétaire de la tentative, et personne d'autre.
  SELECT e.chapter_id INTO v_chapter
    FROM public.attempts a
    JOIN public.exercises e ON e.id = a.exercise_id
   WHERE a.id = p_attempt_id
     AND a.user_id = v_user;

  IF v_chapter IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT jsonb_build_object(
    'chapterId', v_chapter,
    'starBefore', COALESCE((
      SELECT MAX(s.star) FROM public.user_chapter_stars s
       WHERE s.user_id = v_user AND s.chapter_id = v_chapter
         AND s.attempt_id IS DISTINCT FROM p_attempt_id
    ), 0),
    'starAfter', COALESCE((
      SELECT MAX(s.star) FROM public.user_chapter_stars s
       WHERE s.user_id = v_user AND s.chapter_id = v_chapter
    ), 0),
    'newStars', COALESCE((
      SELECT jsonb_agg(s.star ORDER BY s.star) FROM public.user_chapter_stars s
       WHERE s.user_id = v_user AND s.chapter_id = v_chapter AND s.attempt_id = p_attempt_id
    ), '[]'::jsonb),
    'newSeals', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('subjectId', sl.subject_id, 'star', sl.star) ORDER BY sl.star)
        FROM public.user_subject_seals sl
       WHERE sl.user_id = v_user AND sl.attempt_id = p_attempt_id
    ), '[]'::jsonb),
    'rungs', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
               'difficulty', r.difficulty,
               'total',      r.missions_total,
               'counted',    r.missions_counted,
               'new',        r.missions_new
             ) ORDER BY r.difficulty)
        FROM public.chapter_star_rungs(v_user, v_chapter) r
    ), '[]'::jsonb),
    -- ⭐ LES BADGES DE CETTE SOUMISSION (lot 4). `awarded_reason` porte l'id de la
    -- tentative, posé par le trigger : c'est ce qui distingue « le badge que tu
    -- viens de gagner » de « les badges que tu as ». Sans cette clé, l'écran de
    -- résultat célébrerait à chaque fois toute la collection.
    'newBadges', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
               'code',     b.code,
               'name',     b.name,
               'rarity',   b.rarity,
               'iconName', b.icon_name
             ) ORDER BY b.code)
        FROM public.student_badges sb
        JOIN public.badges b ON b.id = sb.badge_id
       WHERE sb.student_user_id = v_user
         AND sb.awarded_reason = 'stars:' || p_attempt_id::text
    ), '[]'::jsonb)
  ) INTO v_out;

  RETURN v_out;
END;
$fn$;

REVOKE ALL ON FUNCTION public.get_attempt_progress(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_attempt_progress(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. L'ENVELOPPE « MA DERNIÈRE TENTATIVE SUR CET EXERCICE ».
--
--    ⚠️ Pourquoi elle existe, et pourquoi ce n'est PAS un contournement.
--    `submit_exercise_attempt` ne rend pas l'id de la tentative qu'elle crée, et
--    l'étude 34 a décidé (D-4) de NE PAS la toucher : elle fait ~570 lignes et
--    trois études l'ont déjà ré-émise en trois semaines. Ajouter une clé à son
--    objet de retour demanderait de la ré-émettre une quatrième fois, pour une
--    donnée que le client peut obtenir sans elle.
--
--    L'écran de résultat sait quel EXERCICE il vient de rendre. La dernière
--    tentative de cet élève sur cet exercice est donc exactement celle qu'il
--    vient de soumettre — et si une autre arrivait entre-temps, ce serait la
--    bonne aussi : on célèbre ce que la dernière soumission a fait tomber.
--
--    Elle ne recopie AUCUNE règle : elle résout un id et délègue.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_last_attempt_progress(p_exercise_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_attempt UUID;
BEGIN
  SELECT a.id INTO v_attempt
    FROM public.attempts a
   WHERE a.user_id = (SELECT auth.uid())
     AND a.exercise_id = p_exercise_id
   ORDER BY a.completed_at DESC, a.id DESC
   LIMIT 1;

  IF v_attempt IS NULL THEN
    RETURN NULL;
  END IF;

  RETURN public.get_attempt_progress(v_attempt);
END;
$fn$;

COMMENT ON FUNCTION public.get_last_attempt_progress(UUID) IS
  'Étude 34 lot 4 : le delta de la DERNIÈRE tentative de l''élève sur un exercice — étoiles gagnées, sceaux, badges. Enveloppe self-scopée de get_attempt_progress ; submit_exercise_attempt n''est pas touchée (D-4).';

REVOKE ALL ON FUNCTION public.get_last_attempt_progress(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_last_attempt_progress(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. « TA SEMAINE » compte les étoiles et les sceaux de la semaine.
--
--    Ré-émise par script depuis sa révision vivante (`20260902170000`), avec une
--    seule substitution : deux clés de plus, aucune retirée.
--
--    ⚠️ Sans récompense (é31 R-18). La carte raconte la semaine, elle ne la paie
--    pas — et comme le grand livre est DATÉ, ces deux comptes sont des faits de
--    la semaine écoulée, pas un état qui changerait au prochain ajout de contenu.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_weekly_recap()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user  UUID := auth.uid();
  v_week  DATE := public.app_current_week_start();
  v_this  RECORD;
  v_prev  RECORD;
  v_badges JSONB;
  v_league JSONB;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT
    COALESCE(SUM(a.xp_earned), 0)::int                       AS xp,
    COUNT(*)::int                                            AS missions,
    ROUND(COALESCE(AVG(a.score_pct), 0))::int                AS avg_score,
    COUNT(DISTINCT (a.completed_at AT TIME ZONE 'Africa/Tunis')::date)::int AS days_active
    INTO v_this
    FROM public.attempts a
   WHERE a.user_id = v_user
     AND a.completed_at >= (v_week::timestamp AT TIME ZONE 'Africa/Tunis')
     AND a.completed_at <  ((v_week + 7)::timestamp AT TIME ZONE 'Africa/Tunis');

  SELECT
    COALESCE(SUM(a.xp_earned), 0)::int                       AS xp,
    COUNT(*)::int                                            AS missions,
    ROUND(COALESCE(AVG(a.score_pct), 0))::int                AS avg_score,
    COUNT(DISTINCT (a.completed_at AT TIME ZONE 'Africa/Tunis')::date)::int AS days_active
    INTO v_prev
    FROM public.attempts a
   WHERE a.user_id = v_user
     AND a.completed_at >= ((v_week - 7)::timestamp AT TIME ZONE 'Africa/Tunis')
     AND a.completed_at <  (v_week::timestamp AT TIME ZONE 'Africa/Tunis');

  SELECT COALESCE(jsonb_agg(b.code ORDER BY sb.awarded_at), '[]'::jsonb)
    INTO v_badges
    FROM public.student_badges sb
    JOIN public.badges b ON b.id = sb.badge_id
   WHERE sb.student_user_id = v_user
     AND sb.awarded_at >= (v_week::timestamp AT TIME ZONE 'Africa/Tunis');

  -- Le rang de ligue de la semaine CLOSE : c'est le seul qui soit définitif, et
  -- c'est celui que le podium célèbre.
  SELECT to_jsonb(x) INTO v_league
    FROM (
      SELECT a.tier, a.rank, a.coins_awarded AS coins, a.week_start
        FROM public.duel_league_awards a
       WHERE a.user_id = v_user AND a.week_start = v_week - 7
    ) x;

  RETURN jsonb_build_object(
    'weekStart', to_char(v_week::timestamp, 'YYYY-MM-DD'),
    -- Une semaine sans une seule mission n'a pas de bilan à montrer : l'écran a
    -- un état pour ça, et il ne dit pas « tu n'as rien fait » (R-8).
    'hasActivity', (v_this.missions > 0),
    'thisWeek', jsonb_build_object(
      'xp', v_this.xp, 'missions', v_this.missions,
      'avgScore', v_this.avg_score, 'daysActive', v_this.days_active
    ),
    'lastWeek', jsonb_build_object(
      'xp', v_prev.xp, 'missions', v_prev.missions,
      'avgScore', v_prev.avg_score, 'daysActive', v_prev.days_active
    ),
    'delta', jsonb_build_object(
      'xp', v_this.xp - v_prev.xp,
      'missions', v_this.missions - v_prev.missions,
      -- ⚠️ Un écart de moyenne n'a de sens que si les DEUX semaines ont eu des
      -- missions : sinon une reprise après vacances afficherait « +67 points de
      -- progression », un compliment mécanique et faux. NULL = pas comparable.
      'avgScore', CASE WHEN v_this.missions > 0 AND v_prev.missions > 0
                        THEN v_this.avg_score - v_prev.avg_score END,
      'daysActive', v_this.days_active - v_prev.days_active
    ),
    'streak', (SELECT current_streak FROM public.profiles WHERE id = v_user),
    'badges', v_badges,
    'league', v_league,
    -- ⭐ ÉTUDE 34 lot 4 — ce que la semaine a fait tomber, lu au GRAND LIVRE.
    -- Sans récompense (é31 R-18) : la carte « Ta semaine » raconte, elle ne paie
    -- pas. Et parce que le grand livre est daté, ce compte est un FAIT de la
    -- semaine — pas un état recalculé qui changerait au prochain ajout de contenu.
    'stars', (
      SELECT count(*)::INT FROM public.user_chapter_stars s
       WHERE s.user_id = v_user AND s.reached_at >= v_week
    ),
    'seals', (
      SELECT count(*)::INT FROM public.user_subject_seals sl
       WHERE sl.user_id = v_user AND sl.reached_at >= v_week
    )
  );
END;
$$;
