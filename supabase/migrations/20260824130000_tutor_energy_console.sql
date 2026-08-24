-- ÉTUDE 11 LOT 7 — LA CONSOLE DU TUTEUR : les deux mesures que personne n'a.
--
-- CE FICHIER NE RECRÉE RIEN. C'EST SA PREMIÈRE PROPRIÉTÉ.
-- ---------------------------------------------------------------------------
-- Le lot 7 s'appelle « énergie et console », et la moitié « énergie » est déjà
-- en base depuis le 2026-08-23 : `get_tutor_energy()` rend {used, bonus, max,
-- left, canRecharge}, `recharge_tutor_energy()` échange une charge d'indice
-- contre +3, et `tutor_daily_energy()` / `tutor_hard_daily_cap()` miroitent les
-- deux seuils (20260823110000_tutor_platform_budget_and_energy.sql). Les 27
-- assertions de `supabase/tests/68_tutor_platform_energy.test.sql` les gardent.
-- Ce lot livre l'ÉCRAN de cette mécanique, pas la mécanique : aucune de ces
-- fonctions n'est retouchée ici, et la seule chose que cette migration ajoute
-- est ce qui MANQUAIT vraiment — de quoi mesurer.
--
-- LES DEUX CHIFFRES, ET POURQUOI ILS N'EXISTAIENT PAS
-- ---------------------------------------------------------------------------
-- §1.4 de l'étude annonce une cible chiffrée : « hit-rate du cache applicatif,
-- cible supérieure à 60 % à S+4 ». Une cible sans instrument est un vœu.
-- `get_ai_admin_overview()` (é29 lot 5) rend l'adoption, les fournisseurs, les
-- modèles et le ratio 👍/👎 — mais ni le hit-rate du cache, ni le rebut de la
-- Forge à l'échelle du PARC. Le rebut existe bien (`get_ai_console`), scopé sur
-- `auth.uid()` : il répond « ce modèle-ci sert-il bien CETTE famille ». Il ne
-- répond pas « le pot commun tient-il ». Ce sont deux questions, et la seconde
-- n'avait aucune porte.
--
-- POURQUOI UNE FONCTION NEUVE PLUTÔT QU'UNE COLONNE DE PLUS
-- ---------------------------------------------------------------------------
-- Étendre `get_ai_admin_overview()` imposerait de la DÉPOSER puis de la
-- recréer — PostgreSQL refuse de changer le type de retour d'un RETURNS TABLE —
-- donc de retaper un corps qui ne nous appartient pas, avec le risque connu de
-- la « révision vivante » : perdre au passage un correctif venu d'ailleurs. Et
-- un DROP emporte les GRANT. Une fonction séparée coûte un aller-retour de plus
-- à l'écran d'admin et zéro risque sur l'existant ; le choix est vite fait.
--
-- ⭐ L'ARBITRAGE DU LOT : LA COHORTE, PAS LA FENÊTRE GLISSANTE
-- ---------------------------------------------------------------------------
-- `tutor_explanations.serve_count` est CUMULATIF et NON DATÉ, et un MISS ne
-- laisse aucune trace : `find_tutor_explanation` rend NULL, puis
-- `store_tutor_explanation` insère une ligne à `serve_count = 0`. Il n'existe
-- donc, en l'état du schéma, aucun moyen de dire « combien de hits ENTRE le 1er
-- et le 30 ». Trois issues étaient possibles :
--
--   (a) un hit-rate À VIE, sans fenêtre — honnête mais inerte : il ne bougerait
--       plus assez vite pour qu'on voie l'effet d'un changement de modèle ;
--   (b) dater les hits — une colonne ou une table d'événements de cache, donc
--       une révision vivante de `find_tutor_explanation`, sur le chemin CHAUD
--       de toute correction, pour un chiffre d'observabilité. Trop cher, et
--       trop risqué, pour ce que ça rapporte ;
--   (c) ⭐ raisonner par COHORTE — celle retenue ici.
--
-- La cohorte, c'est l'ensemble des explications CRÉÉES dans la fenêtre. Pour
-- ces lignes-là, la mesure est EXACTE sans aucune colonne neuve : une
-- explication ne peut pas avoir été servie avant d'exister, donc la totalité de
-- leur `serve_count` s'est produite à l'intérieur de la fenêtre. On lit alors
-- « pour tout ce que le tuteur a produit ces N derniers jours, quelle part des
-- livraisons n'a rien coûté ».
--
-- DEUX BIAIS, NOMMÉS PLUTÔT QUE TUS — un ratio dont on ignore le sens de
-- l'erreur est un chiffre qu'on ne peut pas contredire :
--
--   1. La cohorte IGNORE les hits, survenus dans la fenêtre, sur des
--      explications plus anciennes qu'elle. Or ce sont justement les mieux
--      amorties. Le chiffre SOUS-ESTIME donc le hit-rate instantané, et
--      d'autant plus que le corpus vieillit. Conséquence pratique : au-dessus
--      de 60 % la cible de §1.4 est ATTEINTE, sûrement ; en dessous, elle n'est
--      pas réfutée pour autant.
--   2. Le dénominateur compte les LIVRAISONS, pas les recherches de cache : une
--      génération refusée par le validateur ou tombée en panne fournisseur
--      n'écrit aucune ligne — et n'a rien livré non plus. C'est le bon
--      dénominateur pour « quelle part de ce qu'a reçu l'élève était gratuite »,
--      ce n'est PAS « quelle part des recherches a abouti ». Les deux nombres
--      diffèrent, et c'est le premier qui décide si le pot commun paie.
--
-- R-14 — ce que cette fonction ne rend pas : aucun `user_id`, aucun
-- `owner_user_id`, aucun `body`, aucun `question_id`. Que des sommes. La console
-- admin de l'étude 29 avait posé la règle (« aucun transcript, aucune clé,
-- aucun montant nominatif au-delà de l'agrégat », §3.9) ; on ne l'entame pas
-- pour un taux de cache.

-- ---------------------------------------------------------------------------
-- get_tutor_cache_stats — mutualisation du cache + rebut de la Forge, PARC ENTIER.
-- ---------------------------------------------------------------------------
-- SECURITY DEFINER PAR NÉCESSITÉ. `tutor_explanations` et `ai_forged_quizzes`
-- sont toutes deux `REVOKE ALL FROM anon, authenticated` et n'ont AUCUNE policy
-- de SELECT — volontairement : leurs corps portent la correction (R-1/R-16).
-- Une fonction INVOKER ne lèverait pas, elle rendrait ZÉRO ligne en silence, et
-- l'écran afficherait « 0 % de hit-rate » pour toujours sans que rien ne
-- signale la panne. La non-fuite ne vient donc pas des droits mais du RETOUR :
-- il n'y a que des agrégats dans le jsonb, jamais une ligne.
CREATE OR REPLACE FUNCTION public.get_tutor_cache_stats(p_days INT DEFAULT 30)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_days      INT;
  v_since     TIMESTAMPTZ;
  -- Le cache, sur la cohorte : générations, services, et la coupe partagé/privé.
  v_generated BIGINT;
  v_served    BIGINT;
  v_sh_rows   BIGINT;
  v_sh_served BIGINT;
  -- La Forge : NUMERIC dès la source, pour que la division n'ait pas à caster.
  v_discarded NUMERIC;
  v_kept      NUMERIC;
BEGIN
  -- Comme `get_ai_admin_overview` : c'est la seule surface du lot qui voit
  -- au-delà d'une famille, donc la seule qui mérite une garde de rôle
  -- explicite. Elle LÈVE ; R-15 (dégradé gracieux) se tient côté serveur Node,
  -- qui traduit ce refus en un état d'écran — jamais l'inverse, car une
  -- fonction qui rendrait « {} » à un non-admin serait indistinguable d'un parc
  -- vide, et le jour où la garde casserait personne ne le verrait.
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- La fenêtre est BORNÉE en base, pas dans l'écran. Deux raisons : un
  -- `p_days` nul ou négatif rendrait `now() - interval` supérieur à `now()` et
  -- la fenêtre serait VIDE au lieu d'être invalide (un zéro silencieux, le pire
  -- des cas) ; et 365 est la borne haute utile, puisque R-14 purge la
  -- comptabilité à 12 mois — au-delà, on balaierait pour rien.
  v_days  := GREATEST(LEAST(COALESCE(p_days, 30), 365), 1);
  v_since := now() - make_interval(days => v_days);

  -- ⚠️ `serve_count` n'est PAS filtré par date : il ne le peut pas, et il n'en
  -- a pas besoin. Le filtre porte sur `created_at`, donc sur la cohorte ; tous
  -- les services d'une ligne de la cohorte lui sont postérieurs par
  -- construction. C'est tout l'argument de l'arbitrage (c) ci-dessus.
  SELECT COUNT(*),
         COALESCE(SUM(e.serve_count), 0),
         COUNT(*) FILTER (WHERE e.shared),
         COALESCE(SUM(e.serve_count) FILTER (WHERE e.shared), 0)
    INTO v_generated, v_served, v_sh_rows, v_sh_served
    FROM public.tutor_explanations e
   WHERE e.created_at >= v_since;

  -- LA FORMULE DU REBUT EST CELLE DE `get_ai_console`, DÉLIBÉRÉMENT À
  -- L'IDENTIQUE (20260822210000, CTE `forge`, révisée en 20260822220000) :
  -- `discarded / (discarded + kept)` où `kept` compte les items retenus dans
  -- `payload->'items'`, arrondi à 3 décimales. Deux écrans qui décrivent le
  -- MÊME phénomène avec deux formules différentes sont pires que pas d'écran du
  -- tout — on ne saurait plus lequel croire. Seules deux choses changent : le
  -- filtre `owner_user_id` disparaît (c'est le parc, pas une famille), et la
  -- fenêtre devient paramétrable.
  --
  -- Le `jsonb_typeof(...) = 'array'` est le seul écart, et il est délibéré :
  -- `jsonb_array_length` LÈVE sur un jsonb qui n'est pas un tableau. La version
  -- famille pouvait se le permettre — une charge malformée n'y casse que la
  -- console de son propre payeur. Ici, une seule ligne malformée n'importe où
  -- dans le parc éteindrait la console de TOUT LE MONDE. Le garde ne change
  -- aucune valeur sur une ligne bien formée (clé absente ⇒ 0 des deux côtés).
  SELECT COALESCE(SUM(q.discarded), 0)::NUMERIC,
         COALESCE(SUM(CASE WHEN jsonb_typeof(q.payload->'items') = 'array'
                           THEN jsonb_array_length(q.payload->'items')
                           ELSE 0 END), 0)::NUMERIC
    INTO v_discarded, v_kept
    FROM public.ai_forged_quizzes q
   WHERE q.created_at >= v_since;

  -- ⚠️ CHAQUE division est gardée par son dénominateur. Une console d'admin sur
  -- un parc VIDE — le jour 1 de la mise en service, exactement le moment où on
  -- la regarde le plus — doit afficher des zéros, jamais une erreur. Un
  -- `division_by_zero` ici remonterait jusqu'à l'écran sous forme de « accès
  -- refusé », et on chercherait la panne du mauvais côté.
  --
  -- ⚠️⚠️ CES NOMS DE CLÉS SONT UN CONTRAT, PAS UN GOÛT.
  -- `cacheStatsSchema` dans `src/features/tutor/tutor.energy.server.ts` les
  -- valide, et ses deux TAUX y sont volontairement SANS `.catch()` : renommer
  -- `hitRate` ou `discardRate` ici ne casse rien de visible — le zod échoue, la
  -- server fn rend `null`, et le panneau affiche « mesure indisponible ». Ce
  -- silence est délibéré côté client (« un aveu se corrige, un zéro silencieux
  -- se croit »), mais il n'aide personne si le renommage vient d'ici sans
  -- passer par là. Les deux fichiers se modifient ENSEMBLE.
  --
  -- `days` voyage avec les chiffres : un ratio dont on ignore la fenêtre est un
  -- chiffre qu'on ne peut pas contredire. L'écran doit pouvoir écrire « sur
  -- 30 j » sans le supposer — surtout après le bornage ci-dessus, qui a pu ne
  -- pas retenir ce que l'appelant demandait.
  --
  -- `lifetimeHitRate` répond à une question que le client a le droit de poser :
  -- « ce taux est-il fenêtré, ou depuis toujours ? ». La réponse est FALSE, et
  -- elle est explicite plutôt qu'absente : l'arbitrage (c) a retenu la cohorte,
  -- donc une vraie fenêtre. Le jour où quelqu'un rebasculerait sur le cumul à
  -- vie (arbitrage (a)), il lui suffirait de passer `true` et l'écran changerait
  -- son libellé tout seul, au lieu de mentir sur « 30 j ».
  RETURN jsonb_build_object(
    'days',            v_days,
    'lifetimeHitRate', false,
    -- Un « hit » est un service tiré du cache ; un « miss » est une génération.
    -- Le second nom est celui du client, et il mérite sa nuance : un miss suivi
    -- d'une génération REFUSÉE par le validateur, ou tombée en panne
    -- fournisseur, n'écrit aucune ligne — il n'a rien livré non plus. On compte
    -- donc des LIVRAISONS, pas des recherches de cache (biais n°2 de l'en-tête).
    'hits',            v_served,
    'misses',          v_generated,
    'delivered',       v_generated + v_served,
    'hitRate',         CASE WHEN v_generated + v_served > 0
                            THEN ROUND(v_served::NUMERIC / (v_generated + v_served), 3)
                            ELSE 0 END,
    -- R-15.2 / D-9 : la coupe partagé/privé dit si le POT COMMUN porte
    -- réellement la charge, ou si le parc s'est fragmenté en réserves privées.
    -- Un hit-rate haut porté par du privé ne mutualise rien : chaque famille
    -- repaie sa propre explication. Les deux chiffres se lisent ENSEMBLE.
    'sharedRows',      v_sh_rows,
    'privateRows',     v_generated - v_sh_rows,
    'sharedHits',      v_sh_served,
    'privateHits',     v_served - v_sh_served,
    'sharedRate',      CASE WHEN v_generated > 0
                            THEN ROUND(v_sh_rows::NUMERIC / v_generated, 3)
                            ELSE 0 END,
    'discarded',       v_discarded,
    'kept',            v_kept,
    'discardRate',     CASE WHEN v_discarded + v_kept > 0
                            THEN ROUND(v_discarded / (v_discarded + v_kept), 3)
                            ELSE 0 END
  );
END;
$$;

COMMENT ON FUNCTION public.get_tutor_cache_stats(INT) IS
  'Étude 11 lot 7 : hit-rate du cache mutualisé d''explications (cible §1.4 > 60 % à S+4) et taux de rebut de la Forge, à l''échelle du PARC — les deux mesures que get_ai_admin_overview ne rend pas. Mesure par COHORTE (explications créées dans la fenêtre), faute de hit daté : elle SOUS-ESTIME le hit-rate instantané. Rebut = la formule de get_ai_console, sans le filtre owner. Réservée à is_admin(), agrégats seuls (R-14).';

-- Le motif de toutes les RPC du dépôt : PUBLIC et anon perdent l'EXECUTE que
-- PostgreSQL accorde par défaut — sans ce REVOKE, une fonction SECURITY DEFINER
-- serait appelable sans session, et la garde `is_admin()` deviendrait le SEUL
-- rempart au lieu d'être le second.
REVOKE EXECUTE ON FUNCTION public.get_tutor_cache_stats(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_cache_stats(INT) TO authenticated;
