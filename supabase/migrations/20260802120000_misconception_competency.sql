-- Étude 04 — amendement A1.2 : le geste « m'entraîner » (arbitrage A12, 2026-08-02).
--
-- A1.2b nomme l'erreur et ouvre le cours. Il manquait le troisième geste de US-4 :
-- **s'entraîner** sur ce qui vient de manquer.
--
-- R-A1.2-6 impose de RÉUTILISER le chemin d'é07 lot 4 (`get_exercises_for_competency`)
-- plutôt que d'en créer un second. Or ce chemin résout une COMPÉTENCE en exercices,
-- et une misconception n'en est pas une : il manquait une traduction entre les deux
-- vocabulaires. L'arbitrage A12 la pose là où elle appartient — **dans le registre**,
-- déclarée par l'auteur qui écrit l'erreur, plutôt que devinée par du code.
--
-- La colonne est NULLABLE, et ce n'est pas de la prudence : une misconception peut
-- légitimement n'avoir aucune compétence propre (une confusion de vocabulaire, une
-- erreur de lecture d'énoncé). Sans elle, le bloc de correction nomme l'erreur et
-- ouvre le cours sans proposer d'exercice — la dégradation de R-A1.2-3, encore.
--
-- Pas de clé étrangère vers `competencies` : le vocabulaire des erreurs et le graphe
-- de compétences sont deux registres appliqués par le MÊME canal mais dans un ordre
-- que rien ne garantit. Une FK ferait échouer l'application d'un registre parce que
-- l'autre n'est pas encore passé — un couplage d'ordonnancement pour une intégrité
-- que `content:qa` vérifie déjà à la source, sur les deux registres à la fois.

ALTER TABLE public.misconceptions
  ADD COLUMN IF NOT EXISTS competency TEXT;

COMMENT ON COLUMN public.misconceptions.competency IS
  'Compétence mise en défaut par cette erreur (étude 04 A12) — alimente le geste « m''entraîner » via get_exercises_for_competency. NULL = pas de compétence propre, le bloc se dégrade sans exercice.';
