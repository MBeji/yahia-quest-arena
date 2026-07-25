-- « Révision du jour » compétence-aware — étude 07, lot 5 (US-3).
--
-- CE QUE CE LOT BRANCHE. `get_daily_plan` (étude 04, A1.1) ordonne les révisions par retard
-- SM-2, arbitré par les misconceptions du CHAPITRE. Depuis l'étude 07 lot 2, le dépôt sait
-- quelque chose de plus fin : la maîtrise par COMPÉTENCE (`user_competency_mastery`, EWMA +
-- oubli). Elle alimentait la carte du lot 4 et rien d'autre — le sélecteur, lui, l'ignorait.
-- US-3 la lui donne : « prioriser par compétence faible plutôt que par chapitre ».
--
-- LE SCORE, TROISIÈME TERME (D-3 de l'étude 04 — une fonction SQL lisible, pas du ML) :
--
--     score = retard SM-2 normalisé          (0 → 1, saturé à 30 jours)
--           + 0,5 × poids misconceptions     (0 → 0,5, saturé à 3 tags actifs du chapitre)
--           + 0,5 × faiblesse de compétence  (0 → 0,5, nouveau)   ← ce lot
--
--   * le retard DOMINE toujours : un arriéré de 30 jours (1,0) reste devant une compétence
--     à zéro sur une révision due du jour (0,5). Les deux termes d'arbitrage cumulés (1,0) ne
--     renversent pas non plus un retard maximal — ils le départagent. C'est la même doctrine
--     que le terme misconceptions, et le même facteur 0,5, choisi pour cette raison.
--   * la faiblesse se mesure sur le MAILLON FAIBLE de l'exercice : parmi les 1 à 3 compétences
--     que portent ses questions (R-2), la plus basse. Un exercice qui mobilise une compétence
--     effondrée est urgent même si les deux autres sont acquises — c'est précisément elle qui
--     fera rater l'élève.
--   * l'échelle part du SEUIL D'ÉCHEC de l'étude (m < 50, R-5) : au-dessus de 50 le terme est
--     nul, à 0 il vaut 1 (donc 0,5 après pondération). Une compétence saine ne « pousse » pas
--     une révision, elle ne fait que ne pas la freiner.
--   * la maîtrise est lue à travers `competency_mastery_with_decay` — jamais la colonne brute.
--     L'oubli (R-4, −1 pt/semaine, plancher 30) fait donc remonter une compétence laissée en
--     jachère, exactement comme sur la carte du lot 4 : une seule définition de « la maîtrise
--     aujourd'hui », partagée par l'affichage et par le sélecteur.
--
-- NEUTRALITÉ DU NON-TAGGÉ (R-2, non négociable). Le tagging du corpus est une campagne en
-- cours (lot 3) : aujourd'hui la quasi-totalité des questions ne porte aucune compétence, et
-- une compétence jamais travaillée n'a aucune ligne de maîtrise. Dans les deux cas le terme
-- vaut ZÉRO — jamais une pénalité, jamais un bonus. Conséquence voulue : sur un corpus non
-- taggé, cette fonction rend **exactement** le plan d'avant (le pgTAP 40 le prouve), et la
-- priorisation s'allume d'elle-même, chapitre par chapitre, au fur et à mesure du tagging.
-- C'est aussi pourquoi le 50 par défaut d'une maîtrise fraîche ne fait rien : à 50 le terme
-- est nul (RISK-2 — ne jamais traiter le 50 initial comme un diagnostic).
--
-- CE QUI NE CHANGE PAS. La signature et les colonnes rendues sont identiques (donc un simple
-- CREATE OR REPLACE, aucun DROP, aucun changement côté client) ; le plafond dur de trois
-- (R-4) ; la porte d'accès `resolve_exercise_access` comme unique arbitre et son repli d1–2
-- du même chapitre (R-3) ; SECURITY INVOKER. Ce lot ne touche ni aux récompenses, ni à
-- l'anti-farm : c'est toujours un ordonnanceur d'exercices existants.
--
-- SECURITY INVOKER, tenu (et c'est ce qui borne la lecture). Les deux tables ajoutées sont
-- lisibles par `authenticated` sans privilège emprunté : `question_competencies` porte sa
-- policy « Authenticated read question competencies » + son GRANT SELECT (lot 1), et
-- `user_competency_mastery` est self-scopée par RLS (lot 2) — doublée ici du filtre
-- `auth.uid()` explicite, comme les autres CTE. La jointure sur `questions` n'utilise que
-- `id` et `exercise_id`, deux colonnes de la whitelist de `20260610170000_hide_answer_key` :
-- la clé de correction reste hors de portée, ici comme partout (R-6 — et aucun agrégat d'un
-- autre élève ne peut entrer, faute de ligne visible).

CREATE OR REPLACE FUNCTION public.get_daily_plan(p_limit INT DEFAULT 3)
RETURNS TABLE (
  exercise_id    UUID,
  chapter_id     UUID,
  subject_id     TEXT,
  exercise_title TEXT,
  chapter_title  TEXT,
  days_overdue   INT,
  weak_tags      INT,
  is_fallback    BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  -- Les révisions ÉCHUES, une ligne par exercice : un même exercice peut porter plusieurs
  -- échéances ouvertes (le cycle 1j/3j/7j en pose trois d'un coup), et c'est la plus ancienne
  -- qui dit depuis quand la mémoire décroche.
  WITH due AS (
    SELECT s.exercise_id AS ex_id,
           max(EXTRACT(EPOCH FROM (now() - s.scheduled_for)) / 86400.0) AS overdue_days
      FROM public.spaced_repetition_schedule s
     WHERE s.user_id = (SELECT auth.uid())
       AND s.status = 'pending'
       AND s.scheduled_for <= now()
     GROUP BY s.exercise_id
  ),
  -- Seuil R-2 : une misconception n'est « active » qu'installée (>= 3 fois), reproduite
  -- (>= 2 sessions) et RÉCENTE (30 jours). L'agrégat `user_misconceptions` est entretenu par le
  -- trigger d'A0.1, donc ce filtre ne balaie jamais la télémétrie brute.
  active_tags AS (
    SELECT um.tag
      FROM public.user_misconceptions um
     WHERE um.user_id = (SELECT auth.uid())
       AND um.occurrences >= 3
       AND um.sessions_seen >= 2
       AND um.last_seen_at >= now() - INTERVAL '30 days'
  ),
  -- Où ces erreurs ont-elles été commises ? `question_attempts.chapter_id` est dénormalisé
  -- exactement pour cette agrégation (A0.1).
  weak AS (
    SELECT qa.chapter_id AS chap_id,
           count(DISTINCT qa.misconception_tag)::int AS tags
      FROM public.question_attempts qa
      JOIN active_tags t ON t.tag = qa.misconception_tag
     WHERE qa.user_id = (SELECT auth.uid())
       AND qa.created_at >= now() - INTERVAL '30 days'
     GROUP BY qa.chapter_id
  ),
  -- Étude 07 lot 5 (US-3) : le maillon faible de chaque exercice dû. Borné aux exercices de
  -- `due` — on ne balaie jamais tout le catalogue taggé pour classer trois révisions. Un
  -- exercice sans question taggée, ou dont aucune compétence n'a encore de maîtrise, n'a
  -- simplement pas de ligne ici : le LEFT JOIN plus bas le laisse neutre.
  competency_floor AS (
    SELECT q.exercise_id AS ex_id,
           min(public.competency_mastery_with_decay(m.mastery, m.last_attempt_at)) AS weakest
      FROM public.questions q
      JOIN public.question_competencies qc ON qc.question_id = q.id
      JOIN public.user_competency_mastery m ON m.competency_id = qc.competency_id
     WHERE m.user_id = (SELECT auth.uid())
       AND q.exercise_id IN (SELECT d.ex_id FROM due d)
     GROUP BY q.exercise_id
  ),
  scored AS (
    SELECT e.id AS ex_id,
           e.chapter_id AS chap_id,
           e.subject_id AS subj_id,
           e.title AS ex_title,
           c.title AS chap_title,
           floor(d.overdue_days)::int AS overdue_int,
           COALESCE(w.tags, 0) AS tag_count,
           LEAST(d.overdue_days, 30) / 30.0
             + 0.5 * LEAST(COALESCE(w.tags, 0), 3) / 3.0
             -- Faiblesse de compétence : nulle au-dessus du seuil d'échec (50), maximale à 0.
             -- `GREATEST(0, …)` fait le clip par le haut, `COALESCE(…, 50)` le neutre du
             -- non-taggé — les deux dans la même expression, pour que le terme se lise d'un
             -- trait avec les deux autres.
             + 0.5 * GREATEST(0, 50 - COALESCE(cf.weakest, 50)) / 50.0 AS score
      FROM due d
      JOIN public.exercises e ON e.id = d.ex_id
      JOIN public.chapters c ON c.id = e.chapter_id
      LEFT JOIN weak w ON w.chap_id = e.chapter_id
      LEFT JOIN competency_floor cf ON cf.ex_id = d.ex_id
     ORDER BY score DESC, d.overdue_days DESC, e.id
     -- Quatre fois le plafond : de quoi absorber les verrous et les doublons de repli sans
     -- soumettre TOUT l'arriéré d'un élève à la porte d'accès.
     LIMIT GREATEST(LEAST(COALESCE(p_limit, 3), 3), 0) * 4
  ),
  gated AS (
    SELECT s.*, acc.allowed
      FROM scored s
      CROSS JOIN LATERAL public.resolve_exercise_access(s.ex_id) acc
  ),
  resolved AS (
    SELECT g.chap_id, g.subj_id, g.chap_title, g.overdue_int, g.tag_count, g.score,
           COALESCE(CASE WHEN g.allowed THEN g.ex_id END, fb.id) AS final_id,
           COALESCE(CASE WHEN g.allowed THEN g.ex_title END, fb.title) AS final_title,
           NOT g.allowed AS fallback_used
      FROM gated g
      LEFT JOIN LATERAL (
        SELECT x.id, x.title
          FROM public.exercises x
         WHERE NOT g.allowed
           AND x.chapter_id = g.chap_id
           AND x.id <> g.ex_id
           AND x.source = 'admin'
           -- Le quiz de compréhension est la PORTE du chapitre, pas une révision : il reste
           -- hors du repli même si l'aperçu gratuit l'ouvre.
           AND x.mode IS DISTINCT FROM 'quiz'
           AND x.difficulty <= 2
           AND (SELECT a.allowed FROM public.resolve_exercise_access(x.id) a)
         ORDER BY x.difficulty, x.display_order, x.id
         LIMIT 1
      ) fb ON true
  ),
  -- Deux exercices verrouillés du même chapitre retombent sur le même repli : sans ce
  -- DISTINCT, le plan proposerait deux fois la même mission.
  picked AS (
    SELECT DISTINCT ON (r.final_id) r.*
      FROM resolved r
     WHERE r.final_id IS NOT NULL
     ORDER BY r.final_id, r.score DESC
  )
  SELECT p.final_id, p.chap_id, p.subj_id, p.final_title, p.chap_title,
         p.overdue_int, p.tag_count, p.fallback_used
    FROM picked p
   -- R-4 : trois, jamais plus, quoi que demande l'appelant.
   ORDER BY p.score DESC, p.overdue_int DESC, p.final_id
   LIMIT GREATEST(LEAST(COALESCE(p_limit, 3), 3), 0);
$$;

COMMENT ON FUNCTION public.get_daily_plan(INT) IS
  'Étude 04 A1.1 + étude 07 lot 5 (US-3): révisions dues, ordonnées par retard SM-2 puis '
  'arbitrées par les misconceptions du chapitre ET la compétence la plus faible de l''exercice '
  '(oubli compris). Sélecteur d''exercices existants, plafonné à 3.';

-- Les droits n'ont pas changé (CREATE OR REPLACE les conserve) ; ré-affirmés pour qu'une base
-- reconstruite depuis cette chaîne seule n'ait pas à dépendre de la migration précédente.
REVOKE ALL ON FUNCTION public.get_daily_plan(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_daily_plan(INT) TO authenticated;
