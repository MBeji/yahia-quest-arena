-- « Révision du jour » — étude 04, lot A1.1 (US-1, D-3, R-3, R-4).
--
-- CE QUE CETTE RPC RÉPARE. `spaced_repetition_schedule` existe depuis le sprint 2 et
-- n'alimentait aucune expérience : l'élève ne voyait jamais ce que sa mémoire est en train
-- d'oublier. Depuis l'étude 22 lot 2 (`20260720170000_sm2_close_reviews_on_pass`), la boucle se
-- referme — une révision réussie passe à `completed` — donc la table est enfin une source
-- FIABLE de « ce qui reste à revoir ». `get_daily_plan` est le sélecteur qui la lit.
--
-- CE QUE CE N'EST PAS (R-4) : ni un nouveau mode de session, ni une nouvelle économie. Elle
-- renvoie des exercices EXISTANTS, joués par le chemin existant, avec les récompenses et les
-- gardes anti-farm existantes. C'est un ordonnanceur, pas un moteur de jeu.
--
-- SCORE DE PRIORITÉ (D-3 — une fonction SQL lisible, pas du ML) :
--
--     score = retard SM-2 normalisé          (0 → 1, saturé à 30 jours)
--           + 0,5 × poids misconceptions     (0 → 0,5, saturé à 3 tags actifs du chapitre)
--
--   * le retard domine : ce qui est dû depuis 30 jours passe devant ce qui l'est depuis 1 jour ;
--   * les misconceptions ARBITRENT : à retard comparable, le chapitre où l'élève exécute des
--     erreurs nommées (télémétrie A0) remonte. Le facteur 0,5 est délibéré — une faiblesse
--     diagnostiquée pèse la moitié d'un retard maximal, elle ne la renverse pas.
--   * « actif » applique le seuil R-2 tel quel : >= 3 occurrences du même tag, sur >= 2
--     sessions, vues dans les 30 derniers jours. Les trois constantes sont ici, en un seul
--     endroit, pour pouvoir être ajustées sans relire l'algorithme.
--
-- ÉCART ASSUMÉ AU §3 DE L'ÉTUDE : le troisième terme du score, le malus « déjà recommandé
-- hier », n'est PAS implémenté. Il exige de mémoriser les plans servis, or le modèle de
-- données de l'étude ne prévoit aucune table de journal, et l'écrire depuis une RPC de lecture
-- appelée à chaque chargement du tableau de bord ferait d'un GET un écrivain. Le manque est
-- borné : dès que l'élève RÉUSSIT une révision, le lot 2 de l'étude 22 la ferme et elle quitte
-- d'elle-même le plan ; ce qui reste proposé est ce qui reste réellement dû. Le journal des
-- plans servis est la même brique manquante que le compteur « plan-servi / plan-joué » de
-- l'observabilité (§3) : les deux arriveront ensemble, ou pas du tout.
--
-- ACCÈS (R-3) : `resolve_exercise_access` reste l'UNIQUE arbitre — la règle n'est pas recopiée
-- ici. Un exercice dû mais verrouillé n'est pas retiré du plan : on lui substitue une mission
-- d1–2 du MÊME chapitre, elle-même passée à la même porte (repli explicite de R-3). La raison
-- affichée reste vraie, elle porte sur le chapitre. En phase gratuite, tous les parcours sont
-- `is_premium = false` : ce chemin ne se déclenche pas — il existe pour le jour où la
-- machinerie premium se réveillera (étude 01), et le pgTAP le prouve dès maintenant.
--
-- SECURITY INVOKER, à rebours de la plupart des RPC du dépôt, et c'est délibéré : chaque table
-- lue porte déjà une policy self-scopée (planning SM-2, `question_attempts`,
-- `user_misconceptions`), et le catalogue est public. Aucun privilège à élever, donc aucun à
-- prendre — et la RLS reste un second filet sous le filtre `auth.uid()` explicite. Sans session
-- (`auth.uid()` NULL), la première CTE ne rend aucune ligne et la fonction renvoie vide au lieu
-- de lever.

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
  scored AS (
    SELECT e.id AS ex_id,
           e.chapter_id AS chap_id,
           e.subject_id AS subj_id,
           e.title AS ex_title,
           c.title AS chap_title,
           floor(d.overdue_days)::int AS overdue_int,
           COALESCE(w.tags, 0) AS tag_count,
           LEAST(d.overdue_days, 30) / 30.0
             + 0.5 * LEAST(COALESCE(w.tags, 0), 3) / 3.0 AS score
      FROM due d
      JOIN public.exercises e ON e.id = d.ex_id
      JOIN public.chapters c ON c.id = e.chapter_id
      LEFT JOIN weak w ON w.chap_id = e.chapter_id
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

REVOKE ALL ON FUNCTION public.get_daily_plan(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_daily_plan(INT) TO authenticated;
