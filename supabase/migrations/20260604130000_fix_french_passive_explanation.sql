-- QA fix (idempotent): french / 03-voix-active-et-passive / 02-boss · Q6.
-- The explanation wrongly named "l'option d" as having the agreement error;
-- the error is in option b (the correct answer to "which sentence is wrong?").
-- Corrigé (correctOption='b') was already right — only the explanation text is fixed.
-- Safe to run multiple times; targets the one deterministic question id.

UPDATE public.questions
SET explanation = 'Le sujet passif est « la pièce » (féminin singulier) : le participe passé doit s''accorder → « applaudie ». C''est donc l''option b qui comporte l''erreur d''accord (« applaudi » au lieu de « applaudie ») ; les options a, c et d sont correctes.'
WHERE id = 'f22c973f-b551-5ada-b930-ce0801010307';
