-- Étude 31 — lot 8 : LE CALENDRIER SCOLAIRE (US-12, R-21).
--
-- CONSTAT N° 9 : « aucun événement, aucune saison » hors la semaine ISO de la
-- ligue. Rien ne rythme l'année scolaire tunisienne — ni la rentrée, ni les
-- devoirs de synthèse, ni les révisions de mai, ni le Ramadan. La seule chose
-- datée du produit est une suggestion de changement de classe.
--
-- CE QUE POSE CE LOT
--
-- * Une table `app_events` — un CODE, une fenêtre, un objectif mesurable, un
--   badge saisonnier, et les trois langues. Pilotée par MIGRATION (v1 : pas
--   d'admin UI, stop-point du lot).
-- * ⚠️ R-2 EN TÊTE — **aucun contenu pédagogique n'expire jamais**. La fenêtre
--   borne le DÉFI et son badge, rien d'autre : chaque chapitre, chaque exercice
--   reste jouable avant, pendant et après. C'est la ligne rouge qui sépare un
--   événement d'un mur.
-- * D-3 — **pas de table de progression** : elle se calcule à la volée sur
--   `attempts` dans la fenêtre. Les volumes sont minuscules, et une table de
--   plus serait une table de plus à sécuriser.
-- * R-21 — **un seul actif à la fois**, tenu par une contrainte d'exclusion :
--   deux défis concurrents, c'est deux façons de se sentir en retard.
--
-- Q-2 (arbitrée le 2026-09-01) — le calendrier 2026-2027 : Rentrée (septembre) ·
-- Devoirs de synthèse (fin novembre) · Révisions de mai · Défi Ramadan (objectif
-- réduit, ton calme). Le lot n'en SÈME qu'un — le pilote, celui qui est le plus
-- proche de la date d'exécution.

CREATE TABLE IF NOT EXISTS public.app_events (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code        TEXT UNIQUE NOT NULL,
  starts_at   TIMESTAMPTZ NOT NULL,
  ends_at     TIMESTAMPTZ NOT NULL CHECK (ends_at > starts_at),
  goal_type   TEXT NOT NULL CHECK (goal_type IN ('exercises_n', 'score_90_n')),
  goal_target INTEGER NOT NULL CHECK (goal_target BETWEEN 1 AND 100),
  badge_code  TEXT REFERENCES public.badges(code),
  name        JSONB NOT NULL,   -- {fr,en,ar}
  description JSONB NOT NULL    -- {fr,en,ar}
);

COMMENT ON TABLE public.app_events IS
  'é31 R-21 : les événements du calendrier scolaire. Fenêtres courtes, un seul actif à la fois, écrits par MIGRATION. Ils bornent un DÉFI et son badge — jamais un contenu (R-2).';

-- ⭐ R-21, « au plus un actif à la fois » — par CONTRAINTE, pas par discipline.
-- Deux défis concurrents, c'est deux façons de se sentir en retard ; et une règle
-- tenue à la main est une règle qu'un seed pressé enfreindra.
CREATE EXTENSION IF NOT EXISTS btree_gist;
DO $$ BEGIN
  ALTER TABLE public.app_events
    ADD CONSTRAINT app_events_no_overlap
    EXCLUDE USING gist (tstzrange(starts_at, ends_at) WITH &&);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

ALTER TABLE public.app_events ENABLE ROW LEVEL SECURITY;

-- Lecture publique : un événement est une affiche, pas un secret. L'écriture
-- n'a AUCUNE policy — elle passe par migration, et par elle seule.
DROP POLICY IF EXISTS "Events are readable by everyone" ON public.app_events;
CREATE POLICY "Events are readable by everyone" ON public.app_events FOR SELECT USING (true);

-- ⚠️ Grants EXPLICITES (piège CLAUDE.md : une table neuve n'hérite de rien sur
-- une base vierge, et la suite pgTAP tourne sur une base vierge).
REVOKE ALL ON public.app_events FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.app_events TO anon, authenticated;
GRANT ALL ON public.app_events TO service_role;

-- ===========================================================================
-- Le badge saisonnier du pilote. Famille `saison` (R-13) — et il est
-- DÉCERNABLE, sinon il n'aurait pas le droit d'exister dans la table.
-- ===========================================================================
INSERT INTO public.badges (code, name, description, rarity, icon_name, rule_key, family)
VALUES ('event_rentree', 'Rentrée 2026', 'Relever le défi de la rentrée pendant sa fenêtre',
        'rare', 'Sparkles', 'event_rentree', 'saison')
ON CONFLICT (code) DO UPDATE SET family = EXCLUDED.family;

-- ===========================================================================
-- L'ÉVÉNEMENT PILOTE — la rentrée. Fenêtre courte (R-21 : 7 à 15 jours), objectif
-- modeste : un défi de rentrée qui demande dix exercices n'est pas une fête,
-- c'est un devoir de plus.
-- ===========================================================================
INSERT INTO public.app_events (code, starts_at, ends_at, goal_type, goal_target, badge_code, name, description)
VALUES (
  'rentree-2026',
  '2026-09-15 00:00:00+01',
  '2026-09-30 00:00:00+01',
  'exercises_n', 5, 'event_rentree',
  '{"fr":"Défi de la rentrée","en":"Back-to-school challenge","ar":"تحدّي العودة المدرسيّة"}'::jsonb,
  '{"fr":"Cinq missions pendant la quinzaine de la rentrée, et le badge est à toi.","en":"Five missions during the back-to-school fortnight, and the badge is yours.","ar":"خمس مهامّ خلال أسبوعَي العودة المدرسيّة، وتكون الشارة لك."}'::jsonb
)
ON CONFLICT (code) DO NOTHING;

-- ===========================================================================
-- `get_active_event()` — l'événement du moment ET la progression de l'appelant.
--
--    Une seule lecture : la bannière a besoin des deux, et deux allers-retours
--    pour une affiche, c'est un écran qui clignote.
--    D-3 : la progression se compte à la volée sur `attempts` dans la fenêtre.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_active_event()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user  UUID := auth.uid();
  v_event public.app_events;
  v_done  INT := 0;
BEGIN
  SELECT * INTO v_event
    FROM public.app_events e
   WHERE now() >= e.starts_at AND now() < e.ends_at
   ORDER BY e.starts_at
   LIMIT 1;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  IF v_user IS NOT NULL THEN
    SELECT COUNT(*)::int INTO v_done
      FROM public.attempts a
     WHERE a.user_id = v_user
       AND a.completed_at >= v_event.starts_at
       AND a.completed_at <  v_event.ends_at
       AND (v_event.goal_type <> 'score_90_n' OR a.score_pct >= 90);
  END IF;

  RETURN jsonb_build_object(
    'code', v_event.code,
    'name', v_event.name,
    'description', v_event.description,
    'endsAt', v_event.ends_at,
    'goalType', v_event.goal_type,
    'goalTarget', v_event.goal_target,
    'progress', LEAST(v_done, v_event.goal_target),
    'badgeCode', v_event.badge_code
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_active_event() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_active_event() TO anon, authenticated;

-- ===========================================================================
-- `claim_event_badge()` — le badge saisonnier, PENDANT la fenêtre seulement.
--
--    « décerné à la complétion pendant la fenêtre, JAMAIS après, jamais retiré »
--    (R-21). La borne haute est la moitié qui compte : sans elle, un élève
--    rattraperait un défi de rentrée en juin, et le badge ne dirait plus rien.
--    Le décernement passe par `award_badge_if_new` — idempotent, comme les autres.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.claim_event_badge()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user  UUID := auth.uid();
  v_event JSONB := public.get_active_event();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF v_event IS NULL OR v_event->>'badgeCode' IS NULL THEN
    RETURN jsonb_build_object('granted', false);
  END IF;
  IF (v_event->>'progress')::int < (v_event->>'goalTarget')::int THEN
    RETURN jsonb_build_object('granted', false);
  END IF;

  RETURN jsonb_build_object(
    'granted', public.award_badge_if_new(
      v_user, v_event->>'badgeCode', 'Event challenge: ' || (v_event->>'code')
    ) IS NOT NULL,
    'badgeCode', v_event->>'badgeCode'
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.claim_event_badge() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claim_event_badge() TO authenticated;
