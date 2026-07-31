-- Étude 04 — amendement A1.2, lot A1.2b : le vocabulaire des erreurs atteint l'élève.
--
-- A1.2a a livré le tag : `get_attempt_review` sait dire QUELLE erreur l'élève a
-- commise, sous forme d'id (`math.frac.add-denominators`). Il manquait la phrase.
--
-- La décision D-A1.2-3 prévoyait de l'embarquer au build depuis
-- `content/misconceptions.json`, en la disant « déjà compilée côté client pour
-- d'autres surfaces ». **Cette surface n'existe pas** : le registre n'est lu que
-- par `scripts/content/build.ts` et `qa.ts`, pour valider les tags. Et depuis la
-- scission (étude 24), `content/` n'est plus dans le dépôt public au moment où le
-- build tourne — la voie du build est donc fermée, pas seulement inutilisée.
--
-- Le codebase a déjà tranché ce problème ailleurs, et dans l'autre sens : les
-- libellés de COMPÉTENCES voyagent par la base (`competencies.label_fr/en/ar`,
-- 20260712130000), compilés depuis leur registre par le pipeline de contenu et
-- rendus au client par les RPC de l'étude 07. Cette table est le même canal, pour
-- le même besoin — on ne crée pas un second mécanisme là où il en existe un qui
-- marche.
--
-- L'INTENTION de D-A1.2-3 est préservée, et c'est ce qui compte : la fonction SQL
-- continue de rendre un ID, jamais un libellé ; le registre versionné reste la
-- source unique ; et une misconception mal formulée se corrige toujours **dans le
-- registre**, sans migration ni retouche de données — l'emit est idempotent et
-- rejouable (`apply-content.yml`), exactement comme pour les compétences.
--
-- Pourquoi le tag est la clé primaire (et pas un UUIDv5 comme les compétences) :
-- une compétence est référencée par une FK (`question_competencies`), donc elle a
-- besoin d'un id opaque stable. Une misconception est référencée par une VALEUR
-- dans le JSON `questions.distractor_tags` — le tag EST déjà l'identité, et la
-- doubler d'un UUID n'ajouterait qu'un niveau d'indirection à maintenir.
--
-- Lecture seule pour le client, rien pour anon (la correction vit derrière l'auth),
-- écriture réservée au propriétaire — le SQL compilé. CLAUDE.md : une table neuve
-- porte ses propres GRANT explicites, sinon la suite pgTAP casse sur une base vierge.

CREATE TABLE IF NOT EXISTS public.misconceptions (
  tag      TEXT PRIMARY KEY,   -- 'math.frac.add-denominators' — l'id porté par distractor_tags
  subject  TEXT NOT NULL,      -- 'math' — la famille qui déclare le tag
  label_fr TEXT NOT NULL,
  label_en TEXT NOT NULL,
  label_ar TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_misconceptions_subject
  ON public.misconceptions (subject);

-- ---------------------------------------------------------------------------
-- RLS : l'élève connecté lit le vocabulaire, personne ne l'écrit hors du
-- propriétaire (migrations et SQL de contenu). Aucune politique d'écriture,
-- volontairement — comme pour `competencies`.
-- ---------------------------------------------------------------------------
ALTER TABLE public.misconceptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated read misconceptions" ON public.misconceptions
  FOR SELECT TO authenticated USING (true);

-- Droits d'arrivée explicites sur toutes les piles (les privilèges par défaut du
-- cloud diffèrent de la pile locale neuve) : SELECT pour le client, rien pour anon.
REVOKE ALL ON public.misconceptions FROM anon, authenticated;
GRANT SELECT ON public.misconceptions TO authenticated;
GRANT ALL ON public.misconceptions TO service_role;
