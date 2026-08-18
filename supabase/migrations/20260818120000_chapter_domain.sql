-- `chapters.domain` — le domaine (la « section ») d'une matière auquel un chapitre appartient.
--
-- LE MANQUE. Le catalogue s'arrête à `subjects → chapters` : sous une matière, les
-- chapitres forment une LISTE PLATE, ordonnée par `display_order`. Or un programme
-- officiel n'est pas plat — il est structuré par domaines. En mathématiques, les
-- chapitres alternent activités numériques et activités géométriques ; en arabe et
-- dans les langues, grammaire, conjugaison et compréhension sont des blocs distincts.
-- L'élève qui veut « réviser la géométrie » lit aujourd'hui douze titres à la suite et
-- doit reconstituer lui-même le découpage que son manuel lui donne en une page.
--
-- CE LOT — la COLONNE, portée par le contenu. Le domaine est une donnée d'auteur
-- (`chapter.json → domain`), compilée dans `sql/content/*.sql` comme le titre et la
-- description : ce n'est ni une préférence d'élève, ni un calcul.
--
-- D-1 — UN LIBELLÉ, pas une clé étrangère vers une table de domaines. Le corpus est
-- MONOLINGUE par matière (`subjects.content_language`) : `chapters.title` et
-- `chapters.description` ne sont pas traduits, ils sont écrits dans la langue de la
-- matière. Le domaine suit exactement la même règle — « الهندسة » sous une matière
-- arabe, « Géométrie » sous une matière française. Une table de référence n'aurait
-- donc rien à porter de plus que ce texte, et coûterait une jointure sur le chemin le
-- plus chaud du catalogue. La protection contre les libellés jumeaux (« Géométrie » /
-- « geometrie ») est posée là où l'auteur écrit — QA du moteur de contenu — pas ici.
--
-- D-2 — AUCUNE COLONNE D'ORDRE. L'ordre des domaines se LIT dans les chapitres :
-- c'est celui de leur première apparition dans `display_order`. Un programme qui
-- entrelace les domaines garde ainsi sa propre progression, et il n'existe pas de
-- second ordre susceptible de diverger du premier.
--
-- D-3 — CHECK sur l'invariant, pas sur le style. Une chaîne vide ou des espaces de
-- bord créeraient un groupe fantôme, ou deux groupes pour un même domaine : c'est
-- FAUX, donc la base le refuse. La longueur maximale, elle, est une question de
-- lisibilité d'en-tête : elle est tenue par le schéma Zod d'écriture, où l'auteur voit
-- l'erreur — la refuser ici ferait échouer l'application d'un corpus déjà mergé pour
-- un motif cosmétique.
--
-- D-4 — PAS D'INDEX. Le domaine ne filtre rien : le hub d'une matière lit tous ses
-- chapitres par `subject_id` puis groupe en mémoire. Un index ne servirait aucune
-- requête et alourdirait chaque application de contenu.
--
-- Colonne additive et nullable : un chapitre sans domaine reste un chapitre. Tant que
-- le corpus n'en déclare aucun — c'est l'état au moment de cette migration — la liste
-- reste celle d'aujourd'hui, à plat. Aucun grant nouveau : `chapters` porte un
-- GRANT SELECT au niveau TABLE (20260612221000_baseline_table_grants.sql), qui couvre
-- toute colonne ajoutée, et sa policy RLS est un `USING (true)` de lecture publique.

ALTER TABLE public.chapters
  ADD COLUMN IF NOT EXISTS domain TEXT;

-- Garde idempotente en NOT EXISTS, et non en DROP/ré-ADD : la contrainte est
-- NEUVE, il n'y a aucune version antérieure à remplacer. Un DROP ici ne servirait
-- qu'à faire passer cette migration pour destructive — auprès du hook de commit
-- comme auprès du relecteur.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
     WHERE conrelid = 'public.chapters'::regclass
       AND conname = 'chapters_domain_trimmed'
  ) THEN
    ALTER TABLE public.chapters
      ADD CONSTRAINT chapters_domain_trimmed
      CHECK (domain IS NULL OR (domain = btrim(domain) AND domain <> ''));
  END IF;
END $$;

COMMENT ON COLUMN public.chapters.domain IS
  'Domaine du programme auquel ce chapitre appartient (« Géométrie », « قواعد اللغة »…), dans la langue de la matière. NULL = chapitre non rattaché : le hub le range alors sous « autres chapitres ». L''ordre des domaines se lit dans display_order (première apparition), il n''est stocké nulle part.';
