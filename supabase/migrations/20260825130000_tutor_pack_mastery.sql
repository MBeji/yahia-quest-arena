-- Tuteur déterministe — étude 30 lot 3bis : le pack du tuteur apprend la maîtrise
-- (FableEtudes/30-tuteur-deterministe, dépôt privé — §3.13d, amendement D).
--
-- POURQUOI CE LOT EXISTE, ET POURQUOI ICI. L'amendement D est né documentaire : à la rédaction
-- de é30, é11 n'avait pas une ligne de code. À l'arbitrage, une session exécutait é11 et la
-- règle était « le lot 3 n'édite aucun fichier de é11 — l'amendement se porte par la session
-- propriétaire ». Depuis le 2026-08-24, é11 est LIVRÉE ET CLOSE : la session propriétaire
-- n'existe plus, et un amendement sans porteur est un amendement qui ne se fera pas. Le
-- protocole du dépôt (un lot, une PR, un jeu de fichiers) désigne alors l'étude vivante.
--
-- CE QU'IL AJOUTE, ET RIEN D'AUTRE. Le pack de é11 sait déjà ce que l'élève RATE (les erreurs
-- actives de é04). Il ne sait pas ce qu'il SAIT. Un tuteur qui ignore ce que son élève maîtrise
-- ré-explique ce qui est acquis et attaque ce qui ne l'est pas — c'est le défaut que é30 vient
-- fermer, et le pack est l'endroit où la croyance rejoint la parole.
--
--   ⚠️ JAMAIS `p_known`. Le pack part vers un modèle qui peut le répéter à l'élève, et D-1 dit
--   que la probabilité ne s'affiche que dans la console d'admin. Le bloc ne porte donc que des
--   ÉTATS et des LIBELLÉS. Le pgTAP le vérifie par recherche de motif dans le JSON rendu, pas
--   seulement par absence de clé — parce qu'une valeur peut fuir sous un autre nom.
--
--   ⚠️ R-6 s'applique au pack comme aux écrans : matière non taggée ou aucune croyance ⇒ la clé
--   `mastery` est ABSENTE, et le prompt de é11 rend exactement ce qu'il rend aujourd'hui. Le
--   `||` d'un objet vide est bit pour bit l'objet de départ — la neutralité est structurelle,
--   pas conditionnelle.
--
-- PÉRIMÈTRE : celui de la COUTURE, pas de l'étude. Cette migration est la troisième
-- redéfinition de `get_tutor_learner_context` (é11 lot 1, puis `20260823100000`) — le patron
-- existe. Rien d'autre de é11 n'est touché : ni le chat, ni le mini-check, ni les digests, ni
-- l'énergie, et l'ordre des clés existantes ne bouge pas.

CREATE OR REPLACE FUNCTION public.get_tutor_learner_context()
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_p       RECORD;
  v_base    JSONB;
  v_mastery JSONB;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  SELECT p.level, p.current_streak, p.current_grade_id, g.slug AS grade_slug,
         COALESCE(g.is_concours_national, false) AS is_concours
    INTO v_p
    FROM public.profiles p
    LEFT JOIN public.grades g ON g.id = p.current_grade_id
   WHERE p.id = v_user;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'NO_PROFILE';
  END IF;

  -- ---------------------------------------------------------------------------
  -- Le pack de é11, VERBATIM. Aucune clé retirée, aucune réordonnée, aucune
  -- redéfinie : le bloc ci-dessous est la copie conforme de `20260823100000`.
  -- ---------------------------------------------------------------------------
  v_base := jsonb_build_object(
    'grade_slug', v_p.grade_slug,
    'age_band',   public.tutor_age_band(v_p.current_grade_id),
    'goal',       CASE WHEN v_p.is_concours THEN 'concours' ELSE 'scolaire' END,
    -- Le niveau de jeu en bucket : « 12 » n'apprend rien au modèle que
    -- « débutant / confirmé » n'apprenne mieux, et il change tous les jours.
    'level_band', CASE WHEN v_p.level <= 5 THEN 'debutant'
                       WHEN v_p.level <= 15 THEN 'confirme'
                       ELSE 'avance' END,
    'streak_band', CASE WHEN v_p.current_streak = 0 THEN 'aucune'
                        WHEN v_p.current_streak < 7 THEN 'courte'
                        ELSE 'longue' END,
    -- Les erreurs ACTIVES, au sens de é04 R-2 : ≥ 3 occurrences sur ≥ 2
    -- sessions dans les 30 jours. Top 3, avec leurs libellés élève.
    'active_misconceptions', COALESCE((
      SELECT jsonb_agg(x ORDER BY x->>'occurrences' DESC)
        FROM (
          SELECT jsonb_build_object(
                   'tag', um.tag,
                   'occurrences', um.occurrences,
                   'label_fr', m.label_fr,
                   'label_en', m.label_en,
                   'label_ar', m.label_ar
                 ) AS x
            FROM public.active_misconceptions(v_user) um
            LEFT JOIN public.misconceptions m ON m.tag = um.tag
           ORDER BY um.occurrences DESC
           LIMIT 3
        ) t
    ), '[]'::jsonb),
    -- Les préférences, si l'élève en a posé. Absentes = défauts, jamais une
    -- erreur : un tuteur doit savoir parler à quelqu'un qui n'a rien réglé.
    'interests', COALESCE((SELECT tp.interests FROM public.tutor_prefs tp WHERE tp.user_id = v_user), '{}'),
    'verbosity', COALESCE((SELECT tp.verbosity FROM public.tutor_prefs tp WHERE tp.user_id = v_user), 'normale')
  );

  -- ---------------------------------------------------------------------------
  -- L'AJOUT DE é30 : ce que l'élève sait, ce qu'il peut attaquer, ce qui le bloque.
  -- ---------------------------------------------------------------------------
  -- ⚠️ LA PORTE R-6, ET POURQUOI ELLE NE VA PAS DE SOI. On pourrait croire qu'un élève sans
  -- aucune croyance produit trois listes vides, donc un bloc vide, donc l'absence recherchée.
  -- C'est faux, et le pgTAP l'a montré : la FRONTIÈRE d'un élève neuf n'est pas vide — toute
  -- compétence sans prérequis (ou dont les prérequis seraient acquis) est « prête à
  -- apprendre » par définition, même jamais rencontrée. Le pack d'un élève qui n'a rien joué
  -- se serait donc rempli d'un inventaire de compétences `inconnue`, ce qui n'est pas
  -- « exactement ce que le produit rend aujourd'hui », et ce qui aurait mangé le budget de
  -- é11 pour ne rien dire.
  --
  -- La porte est donc explicite et se pose sur la PREUVE, pas sur le résultat : sans une seule
  -- ligne de croyance, il n'y a rien à raconter au tuteur, et le pack est celui d'hier.
  IF NOT EXISTS (
    SELECT 1 FROM public.user_competency_mastery m WHERE m.user_id = v_user
  ) THEN
    RETURN v_base;
  END IF;

  -- Trois listes plafonnées (3 + 3 + 2), qui répondent aux trois phrases du §1.4 dans l'ordre
  -- où un tuteur en a besoin : ne pas ré-expliquer l'acquis, savoir où pousser, savoir par où
  -- reprendre. Les états sont ceux de `competency_state` — la même définition que la carte,
  -- jamais recopiée. Les libellés voyagent dans les trois langues, comme ceux des
  -- misconceptions juste au-dessus : le pack est au niveau ÉLÈVE et ne connaît pas la langue
  -- de la matière, qui est une propriété de la QUESTION. C'est donc le TS qui choisit, au même
  -- endroit et de la même façon qu'aujourd'hui.
  WITH state AS (
    SELECT c.id, c.slug, c.label_fr, c.label_en, c.label_ar,
           m.last_evidence_at,
           public.competency_state(
             m.p_known, m.evidence_count, m.sessions_seen,
             array_length(m.forms_seen, 1), m.last_evidence_at
           ) AS state
      FROM public.competencies c
      LEFT JOIN public.user_competency_mastery m
        ON m.competency_id = c.id AND m.user_id = v_user
  ),
  mastered AS (
    SELECT jsonb_agg(x ORDER BY ord) AS list FROM (
      SELECT jsonb_build_object('slug', s.slug, 'state', s.state,
                                'label_fr', s.label_fr, 'label_en', s.label_en,
                                'label_ar', s.label_ar) AS x,
             row_number() OVER (ORDER BY s.last_evidence_at DESC NULLS LAST, s.slug) AS ord
        FROM state s
       WHERE s.state = 'maitrisee'
       -- « les plus récentes » : ce que l'élève vient de prouver est ce dont il se souvient,
       -- donc ce sur quoi un tuteur peut s'appuyer sans le lui réapprendre.
       ORDER BY s.last_evidence_at DESC NULLS LAST, s.slug
       LIMIT 3
    ) t
  ),
  frontier AS (
    SELECT jsonb_agg(x ORDER BY ord) AS list FROM (
      SELECT jsonb_build_object('slug', s.slug, 'state', s.state,
                                'label_fr', s.label_fr, 'label_en', s.label_en,
                                'label_ar', s.label_ar) AS x,
             row_number() OVER (ORDER BY unlocks DESC, s.slug) AS ord
        FROM state s
        CROSS JOIN LATERAL (
          SELECT count(*)::INT AS unlocks
            FROM public.competency_prereqs pr WHERE pr.prereq_id = s.id
        ) fan
       WHERE s.state <> 'maitrisee'
         -- La frontière : tous les prérequis directs maîtrisés (§3.4). Même `NOT EXISTS` que
         -- `get_learning_state` — on cherche un contre-exemple, pas une statistique.
         AND NOT EXISTS (
           SELECT 1 FROM public.competency_prereqs pr
            JOIN state ps ON ps.id = pr.prereq_id
            WHERE pr.competency_id = s.id AND ps.state <> 'maitrisee'
         )
       ORDER BY fan.unlocks DESC, s.slug
       LIMIT 3
    ) t
  ),
  blockers AS (
    SELECT jsonb_agg(x ORDER BY ord) AS list FROM (
      SELECT jsonb_build_object('slug', s.slug, 'state', s.state,
                                'label_fr', s.label_fr, 'label_en', s.label_en,
                                'label_ar', s.label_ar) AS x,
             row_number() OVER (ORDER BY blocked DESC, s.slug) AS ord
        FROM state s
        CROSS JOIN LATERAL (
          -- Combien de compétences CETTE compétence met hors de portée. Deux suffisent :
          -- au-delà, on ne donne plus une cause au tuteur, on lui donne une liste.
          SELECT count(*)::INT AS blocked
            FROM public.competency_prereqs pr WHERE pr.prereq_id = s.id
        ) fan
       -- ⚠️ « Bloquant » n'est PAS « pas encore maîtrisé ». Sans ce filtre d'état, toute
       -- compétence de la frontière qui a une suite se retrouverait ici, et les deux listes
       -- diraient la même chose deux fois — au prix du budget du pack, et en noyant la cause
       -- dans l'inventaire. Un blocage se constate sur une FAIBLESSE prouvée (R-5 : lacune,
       -- ou fragile à défaut), pas sur une absence de travail. Une compétence simplement
       -- jamais vue n'a bloqué personne : elle attend.
       WHERE s.state IN ('lacune', 'fragile')
         AND fan.blocked > 0
       ORDER BY fan.blocked DESC, s.slug
       LIMIT 2
    ) t
  )
  SELECT jsonb_strip_nulls(jsonb_build_object(
           'mastered', mastered.list,
           'frontier', frontier.list,
           'blockers', blockers.list
         ))
    INTO v_mastery
    FROM mastered, frontier, blockers;

  -- R-6, structurel : sans aucune croyance les trois listes sont NULL, `jsonb_strip_nulls` rend
  -- `{}`, et `v_base || '{}'` EST `v_base` — octet pour octet. Aucune clé `mastery` n'apparaît,
  -- et le prompt de é11 est celui d'hier.
  IF v_mastery IS NULL OR v_mastery = '{}'::jsonb THEN
    RETURN v_base;
  END IF;

  RETURN v_base || jsonb_build_object('mastery', v_mastery);
END;
$$;

COMMENT ON FUNCTION public.get_tutor_learner_context() IS
  'é11 lot 1 + amendement D de é30 (lot 3bis) : le pack élève, augmenté d''un bloc `mastery` (états seulement, jamais p_known). Absent sans croyance.';
