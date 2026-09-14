-- ÉTOILES DE CHAPITRE & SCEAUX DE MATIÈRE — LE GRAND LIVRE (étude 34, lot 1/5).
--
-- LE DÉFAUT, MESURÉ AVANT D'ÉCRIRE UNE LIGNE
-- ---------------------------------------------------------------------------
-- La complétion d'un chapitre (é22 R-15/R-16) est RECALCULÉE À CHAQUE LECTURE
-- sur la table `exercises` vivante — `student_parcours_progress`, son miroir
-- client `chapter-completion.ts`, `student_chapter_gaps`, la métrique de garde
-- de `admin_engagement_overview`. Aucune donnée ne fige un état atteint, et
-- AUCUNE COLONNE NE DATE UNE MISSION. Quatre conséquences, toutes vérifiables :
--
--   1. ajouter une mission à un chapitre complété le DÉ-complète pour tous les
--      élèves qui l'avaient fini — le hub repasse de « Terminé ✓ » à « 5/6 »,
--      le nœud de /parcours perd son état `done`, la colonne « Programme » du
--      parent baisse, `chapters_per_active` de la console recule ;
--   2. ajouter un chapitre fait chuter le pourcentage de ceux qui étaient à
--      100 % ;
--   3. ajouter un quiz à un chapitre scolaire qui n'en avait pas referme la
--      porte RÉTROACTIVEMENT ;
--   4. un élagage de contenu (le pipeline supprime puis réinsère `source='admin'`)
--      emporte les tentatives en cascade : ce que l'élève avait réussi
--      n'existe plus nulle part.
--
-- Or le contenu EST FAIT POUR GRANDIR : c'est la doctrine (é26 §6), les
-- campagnes tournent chaque semaine, et trois autres sources sont déjà là ou
-- annoncées (missions de la famille, Forge IA, et demain l'élève). Un système
-- de progression qui PUNIT l'ajout de contenu est en contradiction avec le
-- produit. Et rien, aujourd'hui, ne permet de distinguer « il a régressé » de
-- « on a ajouté » : `exercises` n'a pas de date, `content_releases` est à la
-- maille MATIÈRE et en RLS privée.
--
-- CE QUE CE LOT POSE, ET RIEN D'AUTRE
-- ---------------------------------------------------------------------------
--   * `created_at` sur `exercises` et `chapters` — la seule donnée qui sépare
--     la régression de l'ajout (é34 D-6) ;
--   * DEUX TABLES INSERT-ONLY, le « grand livre » : `user_chapter_stars` et
--     `user_subject_seals`. Un acquis y entre et n'en sort JAMAIS (R-6) ;
--   * la RÈGLE, écrite une fois : `mission_is_counted`, `chapter_progress_ref`,
--     `chapter_star_rungs`, `chapter_star_live` ;
--   * L'INSCRIPTION : un trigger `AFTER INSERT ON attempts` (D-4) ;
--   * le REJEU INITIAL : personne ne perd ce qu'il avait (R-15).
--
-- Les LECTURES (`student_subject_stars`, `get_subject_progress`,
-- `get_attempt_progress`, les deux fonctions du suivi parental) sont dans la
-- migration jumelle `20260914130000`, qui suit immédiatement. Aucune UI, aucun
-- badge, aucune récompense : lot 2 et lot 4.
--
-- ⚠️ POURQUOI UN TRIGGER, ET PAS UNE GREFFE DANS `submit_exercise_attempt`
-- ---------------------------------------------------------------------------
-- Cette RPC fait ~570 lignes et trois études l'ont ré-émise en trois semaines
-- (é31 lots 2-3, é33 lot 1). Chaque greffe est une occasion de rejouer la
-- leçon L-3 (« une fonction SQL vivante se SUBSTITUE, elle ne se retape pas »).
-- Le fait « une tentative existe » est possédé par la TABLE : le trigger est
-- son finalizer légitime — exactement le patron de `record_competency_mastery`
-- (20260721100000). Le delta à célébrer se lit ensuite par
-- `get_attempt_progress(attempt_id)`, un aller-retour, zéro substitution.
--
-- ⚠️ CE QUE LE TRIGGER NE FAIT PAS : décerner un badge. Les trois badges de
-- l'étude (`first_seal`, `subject_elite`, `parcours_covered`) sont le lot 4 ;
-- leur point d'accroche est marqué ci-dessous, en toutes lettres.

-- ---------------------------------------------------------------------------
-- 1. DATER LE CONTENU (D-6).
--
--    `DEFAULT now()` date les lignes FUTURES à l'instant de leur application
--    (`apply-content.yml`). L'existant reçoit l'ÉPOQUE DU CATALOGUE — la date
--    de la première migration de contenu — pour ne jamais passer pour une
--    nouveauté aux yeux d'un élève qui joue depuis des mois.
--
--    ⭐ Le moteur de contenu n'a RIEN à changer : `sql-builder` upserte avec
--    une liste de colonnes EXPLICITE et un `DO UPDATE SET` tout aussi
--    explicite. `created_at` n'y figure pas, donc une ré-application conserve
--    la date d'origine, et une insertion neuve la pose. Vérifié dans
--    `src/shared/content/sql-builder.ts` avant d'écrire cette ligne.
-- ---------------------------------------------------------------------------
ALTER TABLE public.exercises ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE public.chapters  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();

-- Époque du catalogue : `20260522134120`, la première migration qui a créé ces
-- tables. Le `WHERE` borne le backfill aux lignes plus récentes que l'époque,
-- ce qui rend l'instruction idempotente ET inoffensive si la colonne existait
-- déjà avec des dates vraies.
UPDATE public.exercises SET created_at = TIMESTAMPTZ '2026-05-22 00:00:00+00'
 WHERE created_at > TIMESTAMPTZ '2026-05-22 00:00:00+00';
UPDATE public.chapters  SET created_at = TIMESTAMPTZ '2026-05-22 00:00:00+00'
 WHERE created_at > TIMESTAMPTZ '2026-05-22 00:00:00+00';

COMMENT ON COLUMN public.exercises.created_at IS
  'Étude 34 D-6 : date d''entrée de la mission au catalogue. Posée par le DEFAULT à l''application du contenu, jamais réécrite par un upsert (sql-builder liste ses colonnes). Sert la NOUVEAUTÉ ✨ (R-7) — sans elle, « l''élève a régressé » et « on a ajouté du contenu » sont indistinguables.';
COMMENT ON COLUMN public.chapters.created_at IS
  'Étude 34 D-6 : date d''entrée du chapitre au catalogue. Même contrat que exercises.created_at.';

-- ---------------------------------------------------------------------------
-- 2. LE GRAND LIVRE — deux tables, insert-only.
--
--    C'est l'amendement de é22 D-4 (« la complétion se calcule, ne se stocke
--    pas ») : D-4 était juste tant que le contenu était stable, il est LA CAUSE
--    de la régression dès qu'il grandit. Désormais : les ACQUIS se stockent, le
--    RESTE-À-FAIRE se calcule.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_chapter_stars (
  user_id           UUID        NOT NULL REFERENCES auth.users(id)      ON DELETE CASCADE,
  chapter_id        UUID        NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  star              SMALLINT    NOT NULL CHECK (star BETWEEN 1 AND 4),
  reached_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  -- ⚠️ SET NULL, JAMAIS CASCADE, et c'est tout l'objet de la table : quand le
  -- pipeline élague une mission, ses tentatives partent en cascade — la ligne
  -- du grand livre, elle, RESTE, et perd seulement son justificatif.
  -- NULL vaut aussi « inscrite par le rejeu initial » (R-15).
  attempt_id        UUID        REFERENCES public.attempts(id) ON DELETE SET NULL,
  -- Combien de missions de catalogue portait le chapitre à cet instant. Sert
  -- l'audit (« l'étoile a-t-elle été gagnée sur 2 missions ou sur 9 ? ») et le
  -- compteur « étoiles préservées » de la console (lot 3).
  missions_at_reach INT         NOT NULL,
  PRIMARY KEY (user_id, chapter_id, star)
);

CREATE INDEX IF NOT EXISTS idx_user_chapter_stars_user_reached
  ON public.user_chapter_stars (user_id, reached_at DESC);

CREATE TABLE IF NOT EXISTS public.user_subject_seals (
  user_id           UUID        NOT NULL REFERENCES auth.users(id)      ON DELETE CASCADE,
  subject_id        TEXT        NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  star              SMALLINT    NOT NULL CHECK (star BETWEEN 1 AND 4),
  reached_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  attempt_id        UUID        REFERENCES public.attempts(id) ON DELETE SET NULL,
  chapters_at_reach INT         NOT NULL,
  PRIMARY KEY (user_id, subject_id, star)
);

CREATE INDEX IF NOT EXISTS idx_user_subject_seals_user_reached
  ON public.user_subject_seals (user_id, reached_at DESC);

COMMENT ON TABLE public.user_chapter_stars IS
  'Étude 34 R-6 — le grand livre des étoiles de chapitre. INSERT-ONLY : une étoile atteinte n''en sort jamais, ni par un ajout de contenu, ni par un élagage, ni par un changement de règle. Tout statut AFFICHÉ se lit ici ; le calcul vivant ne sert qu''à monter et à décrire le reste-à-faire.';
COMMENT ON TABLE public.user_subject_seals IS
  'Étude 34 R-9 — le grand livre des sceaux de matière. Un sceau r est inscrit quand TOUS les chapitres publiés de la matière portent l''étoile r AU GRAND LIVRE (D-5). Insert-only, comme les étoiles. Il survit à la suppression d''un chapitre.';

ALTER TABLE public.user_chapter_stars ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_subject_seals ENABLE ROW LEVEL SECURITY;

-- Patron `user_competency_mastery` (20260721100000) : le propriétaire, l'admin,
-- et un parent lié ACTIF. Jamais les données d'un autre élève. `auth.uid()` est
-- enveloppé dans un sous-select scalaire pour que le planificateur le hisse une
-- fois (posture de 20260630150000 sur les tables par utilisateur).
DROP POLICY IF EXISTS "Chapter stars readable by owner, admin or linked parent" ON public.user_chapter_stars;
CREATE POLICY "Chapter stars readable by owner, admin or linked parent"
  ON public.user_chapter_stars
  FOR SELECT
  USING (
    user_id = (SELECT auth.uid())
    OR public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.parent_student_links l
      WHERE l.parent_user_id = (SELECT auth.uid())
        AND l.student_user_id = user_chapter_stars.user_id
        AND l.is_active
    )
  );

DROP POLICY IF EXISTS "Subject seals readable by owner, admin or linked parent" ON public.user_subject_seals;
CREATE POLICY "Subject seals readable by owner, admin or linked parent"
  ON public.user_subject_seals
  FOR SELECT
  USING (
    user_id = (SELECT auth.uid())
    OR public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.parent_student_links l
      WHERE l.parent_user_id = (SELECT auth.uid())
        AND l.student_user_id = user_subject_seals.user_id
        AND l.is_active
    )
  );

-- Aucune politique d'écriture, à dessein : le SEUL écrivain est le trigger
-- ci-dessous, qui tourne en SECURITY DEFINER dans la transaction de la
-- soumission et contourne donc RLS en tant que propriétaire de la table.
-- Les rôles clients n'ont que SELECT. (Piège connu des tables neuves : les
-- GRANT ne sont JAMAIS implicites sur une stack CI fraîche.)
REVOKE ALL ON public.user_chapter_stars FROM anon, authenticated;
REVOKE ALL ON public.user_subject_seals FROM anon, authenticated;
GRANT SELECT ON public.user_chapter_stars TO authenticated;
GRANT SELECT ON public.user_subject_seals TO authenticated;
GRANT ALL    ON public.user_chapter_stars TO service_role;
GRANT ALL    ON public.user_subject_seals TO service_role;

-- ---------------------------------------------------------------------------
-- 3. LA RÈGLE — écrite UNE fois (leçon L-4 : un seuil dupliqué n'est plus
--    ajustable, il est juste faux à plusieurs endroits).
--
--    3a) Une mission COMPTE (R-3).
--
--    ⚠️ CE PRÉDICAT EST PLUS STRICT QUE é22 R-14, d'un cran et d'un seul : la
--    tentative doit aussi être NON PRÉCIPITÉE (≥ 4 s/question), exactement
--    comme l'exigent déjà l'XP (`v_too_fast` de `submit_exercise_attempt`) et
--    la porte du quiz. Une étoile est une PREUVE : la définition d'« acquis »
--    rejoint celle du moteur. Sans ce durcissement, une ferme d'étoiles au
--    hasard était ouverte (≈ 4 % de réussite par essai expédié sur 6 questions,
--    illimité). Le rejeu initial (§5) grand-père tout ce qui existait avant,
--    pour que ce durcissement ne reprenne rien à personne.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.mission_is_counted(p_user UUID, p_exercise UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT EXISTS (
    SELECT 1
      FROM public.attempts a
     WHERE a.user_id = p_user
       AND a.exercise_id = p_exercise
       AND a.variant = 'classic'
       AND a.score_pct >= 60
       AND a.duration_seconds >= a.total_count * 4
  );
$fn$;

COMMENT ON FUNCTION public.mission_is_counted(UUID, UUID) IS
  'Étude 34 R-3 : une mission compte pour une étoile quand une tentative CLASSIQUE l''a réussie (>= 60 %) SANS précipitation (>= 4 s/question). Une reprise en Rappel ne compte jamais.';

-- ---------------------------------------------------------------------------
--    3b) La RÉFÉRENCE d'un chapitre (R-7) : depuis quand l'élève « connaît » ce
--        chapitre. Tout ce qui est arrivé après est une NOUVEAUTÉ ✨.
--
--        GREATEST ignore les NULL en SQL : un élève sans étoile mais avec des
--        tentatives a bien la date de sa dernière tentative. Les DEUX NULL
--        (chapitre jamais touché) rendent NULL — et R-7 dit qu'alors rien n'est
--        ✨ : on ne signale pas comme « nouveau » un contenu à quelqu'un qui
--        n'a jamais vu l'ancien.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.chapter_progress_ref(p_user UUID, p_chapter UUID)
RETURNS TIMESTAMPTZ
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT GREATEST(
    (SELECT MAX(s.reached_at)
       FROM public.user_chapter_stars s
      WHERE s.user_id = p_user AND s.chapter_id = p_chapter),
    (SELECT MAX(a.completed_at)
       FROM public.attempts a
       JOIN public.exercises e ON e.id = a.exercise_id
      WHERE a.user_id = p_user AND e.chapter_id = p_chapter)
  );
$fn$;

COMMENT ON FUNCTION public.chapter_progress_ref(UUID, UUID) IS
  'Étude 34 R-7 : la référence de nouveauté d''un chapitre = max(dernière étoile inscrite, dernière tentative). NULL si le chapitre n''a jamais été touché — et alors rien n''y est signalé ✨.';

-- ---------------------------------------------------------------------------
--    3c) Les CRANS de la jauge (R-8) : une ligne par niveau de difficulté
--        RÉELLEMENT PRÉSENT dans le chapitre — jamais quatre par principe.
--
--        Mesuré sur le corpus le 2026-09-14 : 57 chapitres sur 773 n'ont aucune
--        mission ⭐ et 35 aucune ⭐⭐. Une jauge à quatre crans fixes y
--        afficherait des paliers qu'aucun contenu ne permet d'atteindre —
--        l'inverse exact de é22 R-30 (« tout verrou affiché énonce sa condition
--        et son action »).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.chapter_star_rungs(p_user UUID, p_chapter UUID)
RETURNS TABLE (
  difficulty       SMALLINT,
  missions_total   INT,
  missions_counted INT,
  missions_new     INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH ref AS (
    SELECT public.chapter_progress_ref(p_user, p_chapter) AS at
  ),
  missions AS (
    SELECT
      -- `exercises.difficulty` n'a aucune contrainte CHECK en base : on borne
      -- ici plutôt que de faire confiance à la donnée.
      LEAST(GREATEST(e.difficulty, 1), 4)::SMALLINT AS d,
      public.mission_is_counted(p_user, e.id) AS counted,
      (
        r.at IS NOT NULL
        AND e.created_at > r.at
        AND NOT EXISTS (
          SELECT 1 FROM public.attempts a
           WHERE a.user_id = p_user AND a.exercise_id = e.id
        )
      ) AS is_new
      FROM public.exercises e
      CROSS JOIN ref r
     WHERE e.chapter_id = p_chapter
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
  )
  SELECT
    m.d,
    count(*)::INT,
    count(*) FILTER (WHERE m.counted)::INT,
    count(*) FILTER (WHERE m.is_new)::INT
    FROM missions m
   GROUP BY m.d
   ORDER BY m.d;
$fn$;

COMMENT ON FUNCTION public.chapter_star_rungs(UUID, UUID) IS
  'Étude 34 R-8 : les crans de la jauge d''un chapitre — un par niveau de difficulté PRÉSENT, avec son total, ce qui compte, et ce qui est arrivé après la référence de l''élève (✨).';

-- ---------------------------------------------------------------------------
--    3d) L'ÉTOILE VIVANTE (R-4) — 0 à 4, calculée sur le contenu d'aujourd'hui.
--
--        Étoile r ⇔ toutes les missions de catalogue de difficulté ≤ r sont
--        comptées. Donc : l'étoile vivante vaut 4 si tout est compté, sinon
--        (le plus petit cran non franchi) − 1.
--
--        TROIS GARDES, chacune pour une raison nommée :
--          * un chapitre NON PUBLIÉ (aucune mission de catalogue) vaut 0 —
--            sinon il serait « maîtrisé par vacuité » ;
--          * le QUIZ de compréhension doit être franchi (é22 R-7, porte
--            inchangée, appelée et jamais recopiée — leçon L-4) ;
--          * au moins UNE mission comptée. Sans elle, un chapitre dont toutes
--            les missions sont ⭐⭐⭐/⭐⭐⭐⭐ donnerait DEUX étoiles pour zéro
--            travail (les crans 1 et 2, absents, étant franchis par vacuité).
--            C'est le seul endroit où la vacuité de D-3 devait être bornée.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.chapter_star_live(p_user UUID, p_chapter UUID)
RETURNS SMALLINT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH rungs AS (
    SELECT r.difficulty, r.missions_total, r.missions_counted
      FROM public.chapter_star_rungs(p_user, p_chapter) r
  )
  SELECT (
    CASE
      WHEN NOT EXISTS (SELECT 1 FROM rungs) THEN 0
      WHEN NOT public.chapter_quiz_cleared(p_user, p_chapter) THEN 0
      WHEN NOT EXISTS (SELECT 1 FROM rungs WHERE missions_counted > 0) THEN 0
      ELSE COALESCE(
        (SELECT MIN(difficulty) FROM rungs WHERE missions_counted < missions_total) - 1,
        4
      )
    END
  )::SMALLINT;
$fn$;

COMMENT ON FUNCTION public.chapter_star_live(UUID, UUID) IS
  'Étude 34 R-4 : l''étoile qu''un chapitre vaut SUR LE CONTENU D''AUJOURD''HUI (0-4). Elle ne sert qu''à faire MONTER le grand livre ; ce qui est affiché se lit dans user_chapter_stars.';

-- Ces trois-là lisent les tentatives d'un élève ARBITRAIRE : elles restent
-- fermées aux clients, comme `chapter_quiz_cleared`. Les lectures autorisées
-- sont les deux RPC self-scopées de la migration jumelle.
REVOKE ALL ON FUNCTION public.mission_is_counted(UUID, UUID)    FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.chapter_progress_ref(UUID, UUID)  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.chapter_star_rungs(UUID, UUID)    FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.chapter_star_live(UUID, UUID)     FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. L'INSCRIPTION — le trigger, seul écrivain du grand livre.
--
--    Il est délibérément COURT et BORNÉ : il sort tout de suite sur une
--    variante non classique ou un exercice hors chapitre, calcule une étoile
--    sur ≤ 9 missions (médiane du corpus : 5) via l'index
--    idx_attempts_user_exercise_variant, et ne regarde les sceaux QUE si une
--    étoile vient réellement de tomber.
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

  -- ⭐ POINT D'ACCROCHE DU LOT 4 — et rien d'autre n'ira ici. Les trois badges
  -- de l'étude (`first_seal`, `subject_elite`, `parcours_covered`) se décernent
  -- à cet endroit, par `award_badge_if_new(NEW.user_id, <code>, 'stars:' || NEW.id)`.
  -- La raison porte l'id de tentative : c'est ce qui permettra à
  -- `get_attempt_progress` de retrouver les badges de CETTE soumission.

  RETURN NULL;
END;
$fn$;

COMMENT ON FUNCTION public.record_progress_stars() IS
  'Étude 34 D-4 : le finalizer des étoiles et des sceaux. Il vit sur `attempts` — la table qui possède le fait — et non dans submit_exercise_attempt, que trois études ont déjà ré-émise.';

DROP TRIGGER IF EXISTS trg_record_progress_stars ON public.attempts;
CREATE TRIGGER trg_record_progress_stars
  AFTER INSERT ON public.attempts
  FOR EACH ROW
  EXECUTE FUNCTION public.record_progress_stars();

-- ---------------------------------------------------------------------------
-- 5. LE REJEU INITIAL (R-15) — on ne reprend rien à personne.
--
--    Deux passes, dans cet ordre :
--      a) la règle d'AUJOURD'HUI sur le contenu d'aujourd'hui, datée de la
--         dernière tentative du chapitre (`attempt_id` NULL = rejoué) ;
--      b) le GRAND-PÈRE : tout chapitre qui était complet au sens de é22 R-15
--         — l'ancienne règle, qui ignorait la précipitation — reçoit l'étoile 4,
--         même si R-3 la lui refuserait aujourd'hui. Le durcissement vaut pour
--         la suite, jamais rétroactivement.
--    puis les sceaux qui en découlent.
--
--    Sur une base neuve (CI, pgTAP) il ne fait rien : il n'y a pas de tentative.
--    En production, les compteurs sont journalisés — un nombre de grand-pères
--    élevé serait le signal que R-3 coûte plus cher que prévu.
--
--    ⭐ IL EST UNE FONCTION, PAS UN BLOC ANONYME, et pour une seule raison : un
--    `DO $$…$$` n'est rejouable par aucun test. Le pgTAP 102 le lance sur un
--    décor où le trigger a été désactivé, et vérifie qu'il produit EXACTEMENT
--    ce que le trigger aurait produit. Une migration qui écrit dans une table
--    sans que personne puisse rejouer son écriture est une promesse sur
--    parole.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.replay_progress_stars()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_stars       INT := 0;
  v_grandfather INT := 0;
  v_seals       INT := 0;
BEGIN
  -- (a) la règle d'aujourd'hui, sur le contenu d'aujourd'hui
  WITH touched AS (
    SELECT
      a.user_id,
      e.chapter_id,
      MAX(a.completed_at) AS last_at,
      (SELECT count(*)::INT FROM public.exercises x
        WHERE x.chapter_id = e.chapter_id
          AND x.source = 'admin'
          AND x.mode IS DISTINCT FROM 'quiz') AS missions
      FROM public.attempts a
      JOIN public.exercises e ON e.id = a.exercise_id
     WHERE a.variant = 'classic'
       AND e.chapter_id IS NOT NULL
     GROUP BY a.user_id, e.chapter_id
  ),
  scored AS (
    SELECT t.*, public.chapter_star_live(t.user_id, t.chapter_id) AS star FROM touched t
  ),
  ins AS (
    INSERT INTO public.user_chapter_stars
      (user_id, chapter_id, star, reached_at, attempt_id, missions_at_reach)
    SELECT s.user_id, s.chapter_id, g.star::SMALLINT, s.last_at, NULL, s.missions
      FROM scored s, generate_series(1, s.star) AS g(star)
    ON CONFLICT (user_id, chapter_id, star) DO NOTHING
    RETURNING 1
  )
  SELECT count(*)::INT INTO v_stars FROM ins;

  -- (b) le GRAND-PÈRE : l'ANCIENNE définition (é22 R-15), précipitation comprise.
  --     Le durcissement R-3 vaut pour la suite, jamais rétroactivement.
  WITH old_complete AS (
    SELECT
      a.user_id,
      e.chapter_id,
      MAX(a.completed_at) AS last_at,
      (SELECT count(*)::INT FROM public.exercises x
        WHERE x.chapter_id = e.chapter_id
          AND x.source = 'admin'
          AND x.mode IS DISTINCT FROM 'quiz') AS missions
      FROM public.attempts a
      JOIN public.exercises e ON e.id = a.exercise_id
     WHERE a.variant = 'classic'
       AND e.chapter_id IS NOT NULL
     GROUP BY a.user_id, e.chapter_id
    HAVING public.chapter_quiz_cleared(a.user_id, e.chapter_id)
       AND EXISTS (
             SELECT 1 FROM public.exercises x
              WHERE x.chapter_id = e.chapter_id
                AND x.source = 'admin'
                AND x.mode IS DISTINCT FROM 'quiz'
           )
       AND NOT EXISTS (
             SELECT 1 FROM public.exercises x
              WHERE x.chapter_id = e.chapter_id
                AND x.source = 'admin'
                AND x.mode IS DISTINCT FROM 'quiz'
                AND NOT EXISTS (
                      SELECT 1 FROM public.attempts a2
                       WHERE a2.user_id = a.user_id
                         AND a2.exercise_id = x.id
                         AND a2.variant = 'classic'
                         AND a2.score_pct >= 60
                    )
           )
  ),
  ins AS (
    INSERT INTO public.user_chapter_stars
      (user_id, chapter_id, star, reached_at, attempt_id, missions_at_reach)
    SELECT o.user_id, o.chapter_id, g.star::SMALLINT, o.last_at, NULL, o.missions
      FROM old_complete o, generate_series(1, 4) AS g(star)
    ON CONFLICT (user_id, chapter_id, star) DO NOTHING
    RETURNING 1
  )
  SELECT count(*)::INT INTO v_grandfather FROM ins;

  -- (c) les sceaux qui découlent du grand livre ainsi rempli
  WITH published AS (
    SELECT c.id AS chapter_id, c.subject_id
      FROM public.chapters c
     WHERE EXISTS (SELECT 1 FROM public.exercises e
                    WHERE e.chapter_id = c.id
                      AND e.source = 'admin'
                      AND e.mode IS DISTINCT FROM 'quiz')
  ),
  candidates AS (
    SELECT DISTINCT s.user_id, p.subject_id
      FROM public.user_chapter_stars s
      JOIN published p ON p.chapter_id = s.chapter_id
  ),
  earned AS (
    SELECT
      c.user_id,
      c.subject_id,
      g.star,
      (SELECT count(*)::INT FROM published p2 WHERE p2.subject_id = c.subject_id) AS chapters,
      (SELECT MAX(s2.reached_at)
         FROM public.user_chapter_stars s2
         JOIN published p3 ON p3.chapter_id = s2.chapter_id
        WHERE s2.user_id = c.user_id
          AND p3.subject_id = c.subject_id
          AND s2.star = g.star) AS reached_at
      FROM candidates c, generate_series(1, 4) AS g(star)
     WHERE NOT EXISTS (
       SELECT 1 FROM published p
        WHERE p.subject_id = c.subject_id
          AND NOT EXISTS (
                SELECT 1 FROM public.user_chapter_stars s
                 WHERE s.user_id = c.user_id
                   AND s.chapter_id = p.chapter_id
                   AND s.star >= g.star
              )
     )
  ),
  ins AS (
    INSERT INTO public.user_subject_seals
      (user_id, subject_id, star, reached_at, attempt_id, chapters_at_reach)
    SELECT e.user_id, e.subject_id, e.star::SMALLINT, COALESCE(e.reached_at, now()), NULL, e.chapters
      FROM earned e
    ON CONFLICT (user_id, subject_id, star) DO NOTHING
    RETURNING 1
  )
  SELECT count(*)::INT INTO v_seals FROM ins;

  RETURN jsonb_build_object(
    'stars', v_stars + v_grandfather,
    'grandfather', v_grandfather,
    'seals', v_seals
  );
END;
$fn$;

COMMENT ON FUNCTION public.replay_progress_stars() IS
  'Étude 34 R-15 : inscrit au grand livre ce que les tentatives DÉJÀ EN BASE valent, grand-père compris (ancienne règle é22 R-15, précipitation tolérée). Idempotente. Interne — lancée par la migration, rejouable par le pgTAP 102.';

REVOKE ALL ON FUNCTION public.replay_progress_stars() FROM PUBLIC, anon, authenticated;

DO $replay$
DECLARE
  v JSONB;
BEGIN
  v := public.replay_progress_stars();
  RAISE NOTICE 'étude 34 — rejeu initial : % étoile(s) inscrite(s), dont % par grand-père (ancienne règle é22 R-15), et % sceau(x).',
    v ->> 'stars', v ->> 'grandfather', v ->> 'seals';
END;
$replay$;
