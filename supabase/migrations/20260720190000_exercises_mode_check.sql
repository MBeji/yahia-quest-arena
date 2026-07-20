-- Étude 24 — lot 3b : repose `exercises_mode_check` côté schéma public.
--
-- Pourquoi cette migration existe
-- -------------------------------
-- Jusqu'ici, la contrainte n'était portée par AUCUNE migration de schéma : chaque
-- migration de contenu *générée* embarquait un garde idempotent qui la déposait puis
-- la reposait. Le lot 3b retire ces migrations générées du repo public (le corpus part
-- au repo privé `yahia-quest-content`), donc le garde part avec elles.
--
-- Sans cette migration, une base *fraîche* reconstruite depuis le seul repo public ne
-- porterait plus la contrainte — or le pgTAP nightly rejoue tout sur base vierge. Le
-- repo public doit rester auto-suffisant pour reconstruire le schéma (arbitrage du
-- 2026-07-20, branche (a), §4.3 de l'étude).
--
-- Effet sur la prod : NO-OP. La prod porte déjà la contrainte (posée par le dernier
-- garde de contenu appliqué). Le DROP/ADD idempotent la repose à l'identique.
--
-- Le garde resté côté canal contenu (repo privé) devient redondant mais reste
-- inoffensif : l'arbitrage ne demande pas son retrait.

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;
