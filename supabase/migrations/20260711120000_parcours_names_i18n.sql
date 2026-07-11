-- =========================================================
-- Noms de parcours localisés (étude 15, lot 3 — R-6 / audit §C-3, §D-1, §G)
-- ---------------------------------------------------------
-- Les colonnes name_en / name_ar existaient mais n'étaient NI peuplées NI
-- sélectionnées : tout le catalogue (programme, extras, onboarding, /niveau)
-- affichait `name_fr` dans les trois langues. Cette migration peuple les 35
-- parcours seedés ; le client sélectionne désormais les trois colonnes et
-- retombe sur name_fr si une traduction manque (helper parcoursName).
--
-- Registre AR : وضوح إداري تونسي (السنة … أساسي/ثانوي، مناظرة، باكالوريا) —
-- relu par l'humain avant merge (RISK-5 de l'étude).
-- Idempotente : UPDATE déterministe par id (données de seed, jamais éditées
-- par des utilisateurs).
-- =========================================================

UPDATE public.parcours AS p
SET name_en = v.name_en,
    name_ar = v.name_ar
FROM (VALUES
  -- ---- École de base (1re → 8e) ----
  ('ecole-1ere-base', '1st year of basic education', 'السنة الأولى أساسي'),
  ('ecole-2eme-base', '2nd year of basic education', 'السنة الثانية أساسي'),
  ('ecole-3eme-base', '3rd year of basic education', 'السنة الثالثة أساسي'),
  ('ecole-4eme-base', '4th year of basic education', 'السنة الرابعة أساسي'),
  ('ecole-5eme-base', '5th year of basic education', 'السنة الخامسة أساسي'),
  ('ecole-7eme-base', '7th year of basic education', 'السنة السابعة أساسي'),
  ('ecole-8eme-base', '8th year of basic education', 'السنة الثامنة أساسي'),
  -- ---- Concours nationaux ----
  ('concours-6eme', '6th-grade national exam prep', 'الإعداد لمناظرة السادسة أساسي'),
  ('concours-9eme', '9th-grade national exam prep', 'الإعداد لمناظرة التاسعة أساسي'),
  -- ---- Secondaire (années + sections) ----
  ('ecole-1ere-sec', '1st year of secondary school', 'السنة الأولى ثانوي'),
  ('ecole-2eme-sec', '2nd year of secondary school', 'السنة الثانية ثانوي'),
  ('ecole-3eme-sec', '3rd year of secondary school', 'السنة الثالثة ثانوي'),
  ('ecole-2eme-sec-sciences', '2nd year — Sciences', 'الثانية علوم'),
  ('ecole-2eme-sec-lettres', '2nd year — Literature', 'الثانية آداب'),
  ('ecole-2eme-sec-eco-services', '2nd year — Economics & Services', 'الثانية اقتصاد وخدمات'),
  ('ecole-2eme-sec-info', '2nd year — Information Technology', 'الثانية تكنولوجيات الإعلامية'),
  ('ecole-3eme-sec-math', '3rd year — Mathematics', 'الثالثة رياضيات'),
  ('ecole-3eme-sec-sciences-exp', '3rd year — Experimental Sciences', 'الثالثة علوم تجريبية'),
  ('ecole-3eme-sec-lettres', '3rd year — Literature', 'الثالثة آداب'),
  ('ecole-3eme-sec-eco-gestion', '3rd year — Economics & Management', 'الثالثة اقتصاد وتصرف'),
  ('ecole-3eme-sec-techniques', '3rd year — Technical Sciences', 'الثالثة علوم تقنية'),
  ('ecole-3eme-sec-info', '3rd year — Computer Science', 'الثالثة علوم الإعلامية'),
  -- ---- Baccalauréat ----
  ('concours-bac', 'Bac exam prep', 'الإعداد للباكالوريا'),
  ('concours-bac-math', 'Bac prep — Mathematics', 'الإعداد لباكالوريا الرياضيات'),
  ('concours-bac-sciences-exp', 'Bac prep — Experimental Sciences', 'الإعداد لباكالوريا العلوم التجريبية'),
  ('concours-bac-lettres', 'Bac prep — Literature', 'الإعداد لباكالوريا الآداب'),
  ('concours-bac-eco-gestion', 'Bac prep — Economics & Management', 'الإعداد لباكالوريا الاقتصاد والتصرف'),
  ('concours-bac-techniques', 'Bac prep — Technical Sciences', 'الإعداد لباكالوريا العلوم التقنية'),
  ('concours-bac-info', 'Bac prep — Computer Science', 'الإعداد لباكالوريا علوم الإعلامية'),
  -- ---- Parcours libres ----
  ('culture-generale', 'General knowledge', 'الثقافة العامة'),
  ('muscle-cerveau', 'Brain training', 'قوِّ عقلك'),
  ('anglais', 'Improve your English', 'حسّن إنجليزيتك'),
  ('francais', 'Improve your French', 'حسّن فرنسيتك'),
  ('arabe', 'Improve your Arabic', 'حسّن عربيتك'),
  ('ib', 'IB — International Baccalaureate', 'البكالوريا الدولية IB')
) AS v(id, name_en, name_ar)
WHERE p.id = v.id;
