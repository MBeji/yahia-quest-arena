-- Étude 08 — lot 2 : LE DIGEST HEBDO ENRICHI, opt-in (US-7, R-7, D-6).
--
-- CE QUI EXISTAIT. Chaque dimanche soir, tout parent lié reçoit le même push :
-- « le bilan famille de la semaine est prêt ». C'est une invitation sans contenu.
--
-- CE QUE CE LOT POSE. Le parent qui l'a DEMANDÉ reçoit à la place le résumé
-- chiffré de la semaine de son enfant : temps d'apprentissage, missions, série,
-- un chapitre à revoir. Une raison concrète de rouvrir l'application en famille.
--
-- * **Opt-in, désactivé par défaut** (Q-1, recommandation de l'étude) : un push
--   enrichi non demandé est le meilleur moyen de faire couper les notifications.
--   Le réglage est une ligne de `parent_digest_prefs` ; pas de ligne = générique.
-- * **Aucun nouveau cron** (D-6) : même planning, même `CRON_SECRET`. Le
--   dispatcher lit les préférences et appelle `get_parent_digest_summary` en
--   service-role — la fonction est REVOKE de tout rôle client, parce qu'elle
--   prend le parent en PARAMÈTRE.
-- * **Un parent ne lit que ses enfants liés** : le résumé part de
--   `parent_student_links` (lien ACTIF) et n'accepte aucun identifiant d'élève.
-- * **La mesure** (étude §1, KPI-4) : `first_enriched_sent_at` est estampillé au
--   premier envoi réel. « Opt-in » = `enriched_digest` ; « coupé après le premier
--   envoi » = `enriched_digest = false` avec un envoi déjà daté. Les deux se
--   lisent dans `admin_parent_digest_overview()`. Zéro donnée personnelle.
--
-- Migration ADDITIVE : une table neuve, trois fonctions neuves, rien de modifié.

-- ===========================================================================
-- 1. La préférence — une ligne par parent, écrite par RPC seulement.
-- ===========================================================================
CREATE TABLE IF NOT EXISTS public.parent_digest_prefs (
  parent_user_id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  enriched_digest        BOOLEAN NOT NULL DEFAULT false,
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  -- Écrit par le cron (service-role) au premier envoi enrichi réellement parti.
  first_enriched_sent_at TIMESTAMPTZ
);

COMMENT ON TABLE public.parent_digest_prefs IS
  'Étude 08 lot 2 (R-7) : opt-in du parent au digest hebdo ENRICHI. Pas de ligne = digest générique. Lecture owner-only ; écriture par set_parent_digest_pref ; lue et estampillée par le cron en service-role.';

ALTER TABLE public.parent_digest_prefs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Parents read own digest pref" ON public.parent_digest_prefs;
CREATE POLICY "Parents read own digest pref"
  ON public.parent_digest_prefs
  FOR SELECT
  TO authenticated
  USING ((SELECT auth.uid()) = parent_user_id);

-- GRANT explicites (gotcha AGENTS.md) : le client LIT sa ligne, n'écrit jamais —
-- sans quoi il pourrait dater lui-même `first_enriched_sent_at` et fausser la mesure.
REVOKE ALL ON public.parent_digest_prefs FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.parent_digest_prefs TO authenticated;
GRANT ALL ON public.parent_digest_prefs TO service_role;

-- ===========================================================================
-- 2. L'interrupteur — self-scopé : on ne règle que SA préférence.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.set_parent_digest_pref(p_enabled BOOLEAN)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF p_enabled IS NULL THEN
    RAISE EXCEPTION 'Invalid preference';
  END IF;

  INSERT INTO public.parent_digest_prefs (parent_user_id, enriched_digest, updated_at)
  VALUES (v_user, p_enabled, now())
  ON CONFLICT (parent_user_id)
  DO UPDATE SET enriched_digest = EXCLUDED.enriched_digest, updated_at = now();

  RETURN jsonb_build_object('enriched', p_enabled);
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_parent_digest_pref(BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_parent_digest_pref(BOOLEAN) TO authenticated;

-- ===========================================================================
-- 3. Le résumé de la semaine, par enfant LIÉ — pour le cron, en service-role.
--
--    La fenêtre est les 7 derniers jours civils de Tunis, aujourd'hui compris :
--    le cron part le dimanche soir, donc du lundi au dimanche. Les chiffres
--    viennent de `student_activity_totals`, la fonction qui alimente déjà le
--    tableau de bord parent : le push et l'écran ne peuvent pas se contredire.
--
--    Rien d'identifiant ne sort : ni uuid d'élève, ni e-mail. Le prénom
--    d'affichage est celui que le parent voit déjà dans son rapport.
--
--    « Un point faible » = LE chapitre travaillé cette semaine dont le score
--    moyen est sous le seuil de réussite (60 %, celui du rapport). Un titre de
--    chapitre se lit comme une chose à revoir, pas comme un reproche ; l'erreur
--    nommée (é04) reste à l'écran, où elle a la place d'être expliquée.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_parent_digest_summary(p_parent UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  c_tz CONSTANT TEXT := 'Africa/Tunis';
  c_pass_pct CONSTANT INT := 60;
  -- Six enfants : au-delà, le message ne tient plus dans une notification.
  c_max_children CONSTANT INT := 6;
  v_today DATE := (now() AT TIME ZONE c_tz)::DATE;
  v_from TIMESTAMPTZ := ((v_today - 6)::TIMESTAMP AT TIME ZONE c_tz);
  v_to TIMESTAMPTZ := ((v_today + 1)::TIMESTAMP AT TIME ZONE c_tz);
  v_kid RECORD;
  v_totals JSONB;
  v_weak TEXT;
  v_out JSONB := '[]'::JSONB;
BEGIN
  IF p_parent IS NULL THEN
    RETURN v_out;
  END IF;

  FOR v_kid IN
    SELECT pr.id, pr.display_name, pr.current_streak, pr.last_active_date
      FROM public.parent_student_links l
      JOIN public.profiles pr ON pr.id = l.student_user_id
     WHERE l.parent_user_id = p_parent
       AND l.is_active = true
       AND pr.role = 'student'
     ORDER BY l.created_at, pr.id
     LIMIT c_max_children
  LOOP
    v_totals := public.student_activity_totals(
      v_kid.id, v_from, v_to, c_tz, INTERVAL '30 minutes', c_pass_pct, 120, 60, NULL
    );

    SELECT c.title INTO v_weak
      FROM public.attempts a
      JOIN public.exercises e ON e.id = a.exercise_id
      JOIN public.chapters c ON c.id = e.chapter_id
     WHERE a.user_id = v_kid.id
       AND a.completed_at >= v_from
       AND a.completed_at < v_to
     GROUP BY c.id, c.title
    HAVING AVG(a.score_pct) < c_pass_pct
     ORDER BY AVG(a.score_pct) ASC, COUNT(*) DESC, c.title
     LIMIT 1;

    v_out := v_out || jsonb_build_object(
      'displayName', v_kid.display_name,
      'learningMinutes', COALESCE((v_totals ->> 'learningMinutes')::INT, 0),
      'missions', COALESCE((v_totals ->> 'exercises')::INT, 0),
      'activeDays', COALESCE((v_totals ->> 'activeDays')::INT, 0),
      -- Une série n'est remise à zéro qu'à l'activité SUIVANTE : sans cette
      -- borne, un enfant absent depuis dix jours afficherait encore sa série.
      'streak', CASE WHEN v_kid.last_active_date >= v_today - 1
                     THEN COALESCE(v_kid.current_streak, 0) ELSE 0 END,
      'weakChapter', v_weak
    );
    v_weak := NULL;
  END LOOP;

  RETURN v_out;
END;
$$;

COMMENT ON FUNCTION public.get_parent_digest_summary(UUID) IS
  'Étude 08 lot 2 (US-7) : résumé hebdo compact par enfant lié (lien actif), pour le push du dimanche. Prend le parent en PARAMÈTRE : REVOKE de tout rôle client, appelée par le cron en service-role.';

REVOKE EXECUTE ON FUNCTION public.get_parent_digest_summary(UUID) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_parent_digest_summary(UUID) TO service_role;

-- ===========================================================================
-- 4. LA MESURE (étude §1, KPI-4) — des comptes, jamais une personne.
--
--    optInRate    = optedIn / linkedParents
--    cutRate      = cutAfterFirstSend / everSent — « un digest qu'on coupe est
--                   un digest raté ».
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.admin_parent_digest_overview()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN jsonb_build_object(
    'linkedParents', (
      SELECT COUNT(DISTINCT parent_user_id)::INT
        FROM public.parent_student_links WHERE is_active = true
    ),
    'optedIn', (
      SELECT COUNT(*)::INT FROM public.parent_digest_prefs WHERE enriched_digest = true
    ),
    'everSent', (
      SELECT COUNT(*)::INT FROM public.parent_digest_prefs
       WHERE first_enriched_sent_at IS NOT NULL
    ),
    'cutAfterFirstSend', (
      SELECT COUNT(*)::INT FROM public.parent_digest_prefs
       WHERE first_enriched_sent_at IS NOT NULL AND enriched_digest = false
    )
  );
END;
$$;

COMMENT ON FUNCTION public.admin_parent_digest_overview() IS
  'Étude 08 KPI-4 : taux d''opt-in au digest enrichi et taux de coupure après le premier envoi. Admin seulement ; des comptes, aucune donnée personnelle.';

REVOKE EXECUTE ON FUNCTION public.admin_parent_digest_overview() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_parent_digest_overview() TO authenticated;
