-- =========================================================
-- Update French chapter titles and descriptions to be more
-- descriptive and attractive in French
-- =========================================================

-- Chapter 1: Grammaire
UPDATE public.chapters 
SET title = 'La Grammaire française',
    description = 'Résumé : Types et formes de phrases, propositions subordonnées (relatives, complétives, circonstancielles), voix active/passive, discours rapporté'
WHERE id = 'c2000000-0000-0000-0000-000000000001';

-- Chapter 2: Conjugaison
UPDATE public.chapters 
SET title = 'La Conjugaison',
    description = 'Résumé : Tous les temps de l''indicatif, le subjonctif présent, le conditionnel présent et passé, l''impératif, l''accord du participe passé'
WHERE id = 'c2000000-0000-0000-0000-000000000002';

-- Chapter 3: Vocabulaire
UPDATE public.chapters 
SET title = 'Le Vocabulaire',
    description = 'Résumé : Champs lexicaux, synonymes et antonymes, familles de mots, registres de langue, figures de style (métaphore, comparaison, hyperbole...)'
WHERE id = 'c2000000-0000-0000-0000-000000000003';

-- Chapter 4: Compréhension
UPDATE public.chapters 
SET title = 'La Compréhension de texte',
    description = 'Résumé : Analyse du texte narratif (schéma narratif), texte argumentatif (thèse, arguments), texte descriptif, tonalités littéraires'
WHERE id = 'c2000000-0000-0000-0000-000000000004';

-- Chapter 5: Production écrite
UPDATE public.chapters 
SET title = 'La Production écrite',
    description = 'Résumé : Rédaction d''un paragraphe argumentatif, essai structuré, lettre formelle, texte narratif/descriptif, connecteurs logiques'
WHERE id = 'c2000000-0000-0000-0000-000000000005';
