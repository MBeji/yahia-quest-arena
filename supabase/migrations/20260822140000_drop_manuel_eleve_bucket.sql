-- =========================================================
-- DESTRUCTIVE (DoD §7) — retire le bucket `manuel-eleve` et sa politique.
--
-- Livrée SÉPARÉMENT et APRÈS que l'ancien chemin de code a disparu : depuis
-- #778, la carte « Manuel officiel » ouvre le manuel CHEZ SON ÉDITEUR (le CNP),
-- l'adresse étant rebâtie par gabarit depuis le `code` du contenu
-- (src/shared/content/manuel-cnp.ts). `getSubjectManuels` et le verrou de
-- connexion ont été retirés dans ce même lot : plus AUCUN code ne lit ce
-- bucket, ni côté serveur ni côté client.
--
-- Ce qui a été vérifié avant d'écrire ce fichier :
--   • aucune lecture runtime — `getSubjectManuels` absent de `main` ;
--   • aucun test pgTAP n'affirme l'existence de ce bucket (sa seule mention
--     dans supabase/tests concerne son FRÈRE `manuel-pages`) ;
--   • le seul écrivain était scripts/manuel/upload-pdf.mjs, outillage
--     hors-bande devenu orphelin — supprimé dans ce même lot ;
--   • rien n'est perdu : les PDF téléversés ici n'étaient que des COPIES de
--     documents que le CNP publie lui-même. Les 82 codes déclarés par le
--     corpus ont été sondés le 2026-08-19 (un HEAD chacun, aucun
--     téléchargement) : tous répondent 200 et leur taille distante est
--     identique À L'OCTET PRÈS au PDF du corpus de référence.
--
-- ⚠️ NE PAS CONFONDRE avec `manuel-pages` — bucket FRÈRE, toujours en service :
-- il porte les images page-par-page de la galerie « Pages du manuel » sous le
-- cours, que NOUS hébergeons et qui reste derrière connexion. Il n'est pas
-- touché ici, et il a ses propres migration et test pgTAP.
-- =========================================================

-- 1. La politique de lecture d'abord — plus rien ne doit pouvoir lire le bucket
--    pendant qu'on le vide. `IF EXISTS` : la migration reste rejouable.
DROP POLICY IF EXISTS "Manuel eleve PDFs readable by authenticated users" ON storage.objects;

-- 2. Les objets ensuite : `storage.objects.bucket_id` référence
--    `storage.buckets.id`, donc un bucket non vide refuse de disparaître.
--    Filtre explicite sur le seul bucket visé — jamais de DELETE non qualifié
--    sur storage.objects, qui emporterait `manuel-pages` avec lui.
DELETE FROM storage.objects WHERE bucket_id = 'manuel-eleve';

-- 3. Le bucket enfin.
DELETE FROM storage.buckets WHERE id = 'manuel-eleve';

-- 4. Le commentaire de `subjects.manuel_refs` décrivait encore le monde d'avant
--    (« login-gated », « files live in the private manuel-eleve bucket ») —
--    deux affirmations devenues fausses. La colonne, elle, RESTE : c'est elle
--    qui porte les codes d'où le lien est rebâti.
COMMENT ON COLUMN public.subjects.manuel_refs IS
  'Optional [{code, label}]: the official CNP manuel élève volume(s) for this subject. Set by content:build; rendered as a « Manuel officiel » card on the subject page that links to the CNP''s own copy (public, no login, nothing hosted by us — the URL is rebuilt from `code` by src/shared/content/manuel-cnp.ts).';
