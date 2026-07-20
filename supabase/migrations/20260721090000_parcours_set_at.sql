-- Étude 22, lot 3 (R-4) — horodater le choix de parcours, pour que la bannière de rentrée
-- sache à qui elle s'adresse.
--
-- La promotion de rentrée est PROPOSÉE, jamais imposée (D-6) : il n'y a pas de job de septembre
-- qui fait monter tout le monde d'une classe. Les redoublants, les sections de lycée et les
-- comptes dormants rendraient un tel batch faux par construction. Une bannière suffit — encore
-- faut-il savoir à qui la montrer.
--
-- D'où cette colonne, et elle seule : la bannière ne s'affiche que si le dernier choix de
-- parcours est ANTÉRIEUR au 1er septembre de l'année scolaire courante. Un élève qui vient de
-- choisir sa classe en septembre ne se fait donc pas proposer d'en changer le lendemain.
--
-- Pas de colonne « bannière rejetée » : le « Je reste en X » se persiste côté client, par
-- saison (R-4). Un refus d'une année ne doit pas peser sur la suivante, et cela ne justifie pas
-- une écriture serveur.
--
-- NULL = jamais choisi depuis cette migration. Traité comme antérieur : les comptes existants
-- verront donc la bannière à la première rentrée, ce qui est le comportement voulu — ils ont
-- effectivement choisi leur classe avant.

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS current_parcours_set_at TIMESTAMPTZ;

COMMENT ON COLUMN public.profiles.current_parcours_set_at IS
  'Dernier set_current_parcours (R-4, étude 22) : la bannière de rentrée ne s''affiche que si ce choix précède le 1er septembre de l''année scolaire courante. NULL = jamais choisi depuis la migration (traité comme antérieur).';

-- ---------------------------------------------------------
-- `set_current_parcours` — recopie VERBATIM de sa définition active
-- (20260608120000_parcours_entity.sql, seule définition à ce jour), avec pour unique
-- changement l'horodatage du choix. Signature inchangée, donc aucun grant à refaire.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_current_parcours(p_parcours TEXT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  v_uid UUID := auth.uid();
  v_grade UUID;
  v_exists BOOLEAN;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  SELECT grade_id, true INTO v_grade, v_exists
  FROM public.parcours WHERE id = p_parcours;

  IF NOT COALESCE(v_exists, false) THEN
    RAISE EXCEPTION 'UNKNOWN_PARCOURS:%', p_parcours;
  END IF;

  -- v_grade is NULL for 'libre' parcours -> clears the school grade.
  UPDATE public.profiles
  SET current_parcours_id = p_parcours,
      current_grade_id = v_grade,
      -- R-4 : c'est CE choix que la bannière de rentrée interroge. Il est horodaté à chaque
      -- passage, y compris quand l'élève reprend le même parcours — se re-confirmer dans sa
      -- classe compte comme un choix de l'année.
      current_parcours_set_at = now()
  WHERE id = v_uid
  RETURNING * INTO rec;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'USER_NOT_FOUND';
  END IF;

  RETURN rec;
END;
$$;

REVOKE ALL ON FUNCTION public.set_current_parcours(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_current_parcours(TEXT) TO authenticated;
