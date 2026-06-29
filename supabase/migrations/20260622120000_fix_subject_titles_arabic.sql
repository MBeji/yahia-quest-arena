-- Fix subject display titles that shipped in FRENCH for Arabic-medium subjects.
-- `subjects.name_fr` is the single display name and must be written in the subject's
-- own content language (ar). These 8 ecole-tn subjects slipped through with a French
-- scaffold name; their chapter titles were already Arabic.
--
-- Delivered as a tiny idempotent UPDATE (not a content rebuild) on purpose: a parallel
-- session has uncommitted cours.md WIP for several of these subjects, and regenerating
-- their content migrations from main would re-emit (and could clobber) those lesson
-- edits. This touches only `name_fr`. The matching `content/<id>/subject.json` files are
-- corrected in the same PR, so every future rebuild stays consistent.
-- Re-running is a no-op once the names are already Arabic.
UPDATE public.subjects
SET name_fr = 'الرياضيات'
WHERE id IN ('math-3eme', 'math-4eme', 'math-5eme')
  AND name_fr <> 'الرياضيات';

UPDATE public.subjects
SET name_fr = 'الإيقاظ العلمي'
WHERE id IN (
  'eveil-scientifique-1ere', 'eveil-scientifique-2eme', 'eveil-scientifique-3eme',
  'eveil-scientifique-4eme', 'eveil-scientifique-5eme'
)
  AND name_fr <> 'الإيقاظ العلمي';
