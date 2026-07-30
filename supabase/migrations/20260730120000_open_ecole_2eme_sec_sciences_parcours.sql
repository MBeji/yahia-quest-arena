-- Ouvrir le parcours 2ème année secondaire — section Sciences :
-- « coming_soon » → « available ».
--
-- Seuil R-8 (règle d'ouverture du 2026-07-19) : une PREMIÈRE TRANCHE complète
-- ouvre la classe — on n'attend pas la matière complète, les chapitres suivants
-- s'ajoutent en continu sous un parcours déjà ouvert. La tranche qui la
-- déclenche ici : les 3 premiers chapitres de `math-2eme-sec-sciences` (calcul
-- dans ℝ, problèmes du 1er/2nd degré, notion de polynômes), compilés et
-- appliqués par le canal contenu avant cette migration.
--
-- Ces 3 chapitres sont générés sous la lecture AU CHAPITRE de R-5 (décision du
-- 2026-07-29) : la fiche maths de ce niveau est transcrite 12/19 chapitres à
-- profondeur de génération, et seuls ces 12 sont générables — les 7 derniers
-- attendent la transcription du tome 2 p.48–200. La classe s'ouvre donc sur du
-- contenu entièrement adossé à la source, pas sur une fiche trouée.
--
-- Le parcours a été seedé `coming_soon` par 20260704235000_lycee_section_grades_seed.sql
-- avant tout contenu : la classe affichait le teaser « En construction » et
-- `resolve_exercise_access` refusait l'entrée (PARCOURS_COMING_SOON).
--
-- Parcours `scolaire` GRATUIT (is_premium = false, preview_policy = 'full') :
-- passer à 'available' l'ouvre entièrement, sans entitlement.
--
-- Idempotent : re-jouer est un no-op une fois le statut déjà 'available'.
-- Miroir de 20260713180000_open_ecole_1ere_sec_parcours.sql.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'ecole-2eme-sec-sciences';
