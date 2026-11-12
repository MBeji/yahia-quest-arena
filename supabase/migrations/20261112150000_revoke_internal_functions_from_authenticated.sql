-- =========================================================
-- Quatre fonctions INTERNES restaient exécutables par tout compte connecté
-- ---------------------------------------------------------
-- Constat (revue de sécurité du 2026-11-12). Sur un projet Supabase, une fonction créée dans
-- `public` naît exécutable par `anon`, `authenticated` et `service_role` (privilèges par
-- défaut du rôle `postgres`), en plus de PUBLIC. Ces quatre-là n'ont été révoquées que de
-- `PUBLIC, anon` : un compte connecté peut donc les appeler par PostgREST, avec SES arguments.
--
--   · award_badge_if_new(p_user, p_badge_code, p_reason) — SECURITY DEFINER, aucun contrôle
--     de l'appelant : n'importe quel élève s'attribue (ou attribue à un autre) n'importe quel
--     badge. C'est la plus grave : elle écrit.
--   · resolve_ai_access(p_student, p_feature) — rend, pour l'élève de son choix, qui paie son
--     mode IA (uuid du parent), le fournisseur, l'URL de base et l'énergie restante.
--   · app_daily_mission_pool(p_user) — le tirage de missions d'un autre élève.
--   · cleanup_rate_limit_events(p_retention_hours) — purge du compteur de limites.
--
-- Aucune n'est appelée par le client : leurs appelants sont des fonctions SECURITY DEFINER
-- (qui s'exécutent en propriétaire) et, pour `resolve_ai_access`, le serveur avec la clé
-- service. Le REVOKE ne retire donc rien à un chemin existant.
-- DESTRUCTIVE au sens de la DoD §7 (REVOKE) : seule dans sa PR, sans code applicatif.
-- =========================================================

REVOKE EXECUTE ON FUNCTION public.award_badge_if_new(UUID, TEXT, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.resolve_ai_access(UUID, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.app_daily_mission_pool(UUID) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.cleanup_rate_limit_events(INT) FROM PUBLIC, anon, authenticated;

-- Le serveur (clé service) garde ce qu'il utilise ; idempotent.
GRANT EXECUTE ON FUNCTION public.award_badge_if_new(UUID, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.resolve_ai_access(UUID, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.app_daily_mission_pool(UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.cleanup_rate_limit_events(INT) TO service_role;
