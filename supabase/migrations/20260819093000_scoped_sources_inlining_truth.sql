-- Suivi parental — les deux sources scopées ne sont PAS inlinées, et ça coûte
-- 45 buffers. Le dire là où on le lira.
--
-- CE QUI ÉTAIT ÉCRIT, ET QUI EST FAUX
-- ---------------------------------------------------------------------------
-- L'en-tête de `20260817120000_parent_report_class_scope.sql` annonce, au-dessus
-- de `_scoped_attempts` / `_scoped_pulses` : « LANGUAGE sql STABLE : Postgres
-- sait les inliner, le plan reste celui d'un accès direct aux index ». C'est
-- l'inverse de la vérité. Les deux fonctions sont `SECURITY DEFINER` **et**
-- portent un `SET search_path` ; chacune de ces deux propriétés suffit à elle
-- seule à faire refuser l'inlining d'une fonction SQL à retour ensembliste
-- (`inline_set_returning_function`, prosecdef / proconfig) — exactement ce que
-- #769 avait établi pour `student_parcours_progress`. Les prédicats de date
-- restent donc en `Filter:` AU-DESSUS du `Function Scan`, jamais poussés dedans,
-- et les index `idx_attempts_user_completed_at` / `idx_learning_pulses_user_recent`
-- ne travaillent pas.
--
-- CE QUE ÇA COÛTE VRAIMENT — mesuré sur la PROD le 2026-08-19
-- ---------------------------------------------------------------------------
-- Le diagnostic est juste ; c'est son ORDRE DE GRANDEUR qui ne l'était pas. Sur
-- l'élève le plus chargé (163 tentatives, 43 pouls), en EXPLAIN (ANALYZE,
-- BUFFERS), les 10 lectures scopées du corps de `_student_daily_report_json`
-- rejouées en une seule requête :
--
--   telles qu'écrites (10 Function Scan) ......... 731 buffers · 4,9 ms
--   historique matérialisé une fois (2 scans) .... 686 buffers · 3,0 ms
--   accès direct aux tables (plancher) ........... 334 buffers · 3,0 ms
--
-- La réécriture en CTE partagée achète donc **45 buffers**, sur un rapport
-- complet qui en consomme **4 780** (30 jours, périmètre « tout ») : 0,9 %.
-- Elle ne vaut pas une migration. Détail : le PREMIER `Function Scan` coûte
-- 217 buffers (94 pour les pouls) et chaque appel SUPPLÉMENTAIRE seulement 9
-- (3 pour les pouls) — le surcoût est un coût de mise en place par instruction,
-- pas un coût par appel. `attempts` fait 8 pages, `learning_pulses` 2 : il n'y a
-- rien qu'un index puisse économiser aujourd'hui.
--
-- Et le poste dominant est ailleurs : la couverture du programme
-- (`student_parcours_progress` dans le LATERAL de `rows_subjects`) pèse
-- 1 818 buffers à `loops=5` sur 30 jours, 3 346 à `loops=10` sur 92 jours —
-- ~350 par matière travaillée. #769 a mesuré qu'il ne faut PAS y appliquer sa
-- propre réécriture tant qu'on est sous ~23 appels. On y est.
--
-- QUAND CE SERA VRAI, ET CE QU'IL FAUDRA FAIRE ALORS
-- ---------------------------------------------------------------------------
-- Le surcoût suit l'HISTORIQUE de l'élève : un appel relit toutes ses lignes,
-- soit ~N/34 pages (`attempts` : 270 lignes sur 8 pages). Le rapport en fait 22
-- (10 dans le corps, 6 par appel de `student_activity_totals`, appelée deux
-- fois). QUATRE ont réellement besoin de tout l'historique — `measuredSince`, la
-- numérotation des tentatives, et `first_pass` qui compte double. Les 18 autres
-- sont bornés à la fenêtre et relisent pourtant tout : ~18·N/34 buffers jetés,
-- négligeable à N=163 (~90), ~1 060 vers N≈2 000, et à parité avec la couverture
-- vers N≈7 000 tentatives.
--
-- Le remède à appliquer ce jour-là n'est PAS la CTE (elle matérialise encore
-- tout l'historique deux fois) mais des BORNES DE DATE sur les deux fonctions —
-- `p_from`/`p_to` avec sentinelles `-infinity`/`infinity` plutôt que NULL, pour
-- rester sargable. `attempts.completed_at` et `learning_pulses.occurred_at` sont
-- `NOT NULL` : les sentinelles sont alors strictement équivalentes à l'absence
-- de prédicat. Les 18 appels bornés redeviennent des `Index Cond` ; les 4 autres
-- restent des parcours complets, et c'est inhérent. Plancher mesuré pour cette
-- voie : 334 buffers contre 731, soit −54 % — quand la CTE ne rend que −6 %.
--
-- Migration SANS effet de bord : elle ne pose que des commentaires. Aucune
-- fonction n'est redéfinie, aucun plan ne change.

COMMENT ON FUNCTION public._scoped_attempts(UUID, TEXT[]) IS
$c$Tentatives d'un élève, restreintes à un périmètre de matières (NULL = aucun filtre).

SECURITY DEFINER + SET search_path : Postgres NE PEUT PAS l'inliner (prosecdef et
proconfig interdisent chacun `inline_set_returning_function`). Les prédicats de
date de l'appelant restent donc en Filter au-dessus du Function Scan, et la
fonction rend TOUT l'historique de l'élève à chaque appel. Mesuré en prod le
2026-08-19 : premier appel 217 buffers, chaque appel supplémentaire 9. Voir
docs/performance-audit.md § « Suivi parental — sources scopées ».$c$;

COMMENT ON FUNCTION public._scoped_pulses(UUID, TEXT[]) IS
$c$Pouls d'apprentissage d'un élève, restreints à un périmètre de matières
(NULL = aucun filtre). Un pouls sans matière — donjon, duel, navigation —
n'appartient à aucun niveau et sort du périmètre dès qu'un filtre est demandé :
c'est ce que `excludedMinutes` rapporte au parent.

Même limite d'inlining que _scoped_attempts (SECURITY DEFINER + SET search_path).
Mesuré en prod le 2026-08-19 : premier appel 94 buffers, chaque appel
supplémentaire 3.$c$;
