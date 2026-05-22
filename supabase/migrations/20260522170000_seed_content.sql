-- =========================================================
-- Seed data: subjects, chapters, exercises, questions,
-- badges, and shop items for Tunisian 9th-year curriculum
-- =========================================================

-- -------------------------------------------------------------------
-- SUBJECTS (5 matières du concours 9ème année)
-- -------------------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order) VALUES
  ('math',    'Mathématiques',       'Algèbre, géométrie, fonctions et problèmes',          'Force',       'subject-math',    'Calculator',    1),
  ('french',  'Français',            'Grammaire, conjugaison, rédaction et compréhension',   'Sagesse',     'subject-french',  'BookOpen',      2),
  ('arabic',  'العربية',              'النحو والصرف والبلاغة والإنشاء',                       'Esprit',      'subject-arabic',  'Languages',     3),
  ('svt',     'Sciences de la Vie',  'Biologie, géologie et environnement',                  'Observation', 'subject-svt',     'Microscope',    4),
  ('english', 'Anglais',             'Grammar, vocabulary, reading & writing',               'Agilite',     'subject-english', 'Globe',         5)
ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------------
-- CHAPTERS
-- -------------------------------------------------------------------

-- MATH chapters
INSERT INTO public.chapters (id, subject_id, title, description, display_order) VALUES
  ('c1000000-0000-0000-0000-000000000001', 'math', 'Calcul numérique',         'Puissances, racines carrées, fractions', 1),
  ('c1000000-0000-0000-0000-000000000002', 'math', 'Calcul littéral',          'Développer, factoriser, identités remarquables', 2),
  ('c1000000-0000-0000-0000-000000000003', 'math', 'Équations et inéquations', 'Résolution d''équations du 1er degré', 3),
  ('c1000000-0000-0000-0000-000000000004', 'math', 'Géométrie dans le plan',   'Triangles, cercles, Thalès, Pythagore', 4),
  ('c1000000-0000-0000-0000-000000000005', 'math', 'Fonctions linéaires',      'Proportionnalité et fonctions linéaires/affines', 5),
  ('c1000000-0000-0000-0000-000000000006', 'math', 'Statistiques',             'Moyenne, médiane, fréquence, diagrammes', 6);

-- FRENCH chapters
INSERT INTO public.chapters (id, subject_id, title, description, display_order) VALUES
  ('c2000000-0000-0000-0000-000000000001', 'french', 'Grammaire',         'Types de phrases, propositions, voix active/passive', 1),
  ('c2000000-0000-0000-0000-000000000002', 'french', 'Conjugaison',       'Temps de l''indicatif, subjonctif, conditionnel', 2),
  ('c2000000-0000-0000-0000-000000000003', 'french', 'Vocabulaire',       'Champs lexicaux, synonymes, antonymes', 3),
  ('c2000000-0000-0000-0000-000000000004', 'french', 'Compréhension',     'Lecture et analyse de textes narratifs et argumentatifs', 4),
  ('c2000000-0000-0000-0000-000000000005', 'french', 'Production écrite', 'Rédaction, argumentation, description', 5);

-- ARABIC chapters
INSERT INTO public.chapters (id, subject_id, title, description, display_order) VALUES
  ('c3000000-0000-0000-0000-000000000001', 'arabic', 'النحو',     'الإعراب والبناء، المبتدأ والخبر، الحال والتمييز', 1),
  ('c3000000-0000-0000-0000-000000000002', 'arabic', 'الصرف',     'الأفعال المجردة والمزيدة، المشتقات', 2),
  ('c3000000-0000-0000-0000-000000000003', 'arabic', 'البلاغة',   'التشبيه والاستعارة والكناية', 3),
  ('c3000000-0000-0000-0000-000000000004', 'arabic', 'الإنشاء',   'المقال والرسالة والوصف', 4),
  ('c3000000-0000-0000-0000-000000000005', 'arabic', 'فهم النص',  'تحليل النصوص الأدبية والحجاجية', 5);

-- SVT chapters
INSERT INTO public.chapters (id, subject_id, title, description, display_order) VALUES
  ('c4000000-0000-0000-0000-000000000001', 'svt', 'Nutrition chez l''Homme',     'Digestion, absorption, alimentation équilibrée', 1),
  ('c4000000-0000-0000-0000-000000000002', 'svt', 'Respiration',                 'Échanges gazeux, appareil respiratoire', 2),
  ('c4000000-0000-0000-0000-000000000003', 'svt', 'Circulation sanguine',        'Cœur, vaisseaux, sang, groupes sanguins', 3),
  ('c4000000-0000-0000-0000-000000000004', 'svt', 'Excrétion',                   'Reins, filtration, urine', 4),
  ('c4000000-0000-0000-0000-000000000005', 'svt', 'Reproduction humaine',        'Puberté, cycles, fécondation', 5),
  ('c4000000-0000-0000-0000-000000000006', 'svt', 'Géologie',                    'Roches, fossiles, tectonique des plaques', 6);

-- ENGLISH chapters
INSERT INTO public.chapters (id, subject_id, title, description, display_order) VALUES
  ('c5000000-0000-0000-0000-000000000001', 'english', 'Grammar Basics',      'Tenses, articles, prepositions', 1),
  ('c5000000-0000-0000-0000-000000000002', 'english', 'Vocabulary Builder',  'Word families, synonyms, collocations', 2),
  ('c5000000-0000-0000-0000-000000000003', 'english', 'Reading Comprehension', 'Understanding texts, identifying main ideas', 3),
  ('c5000000-0000-0000-0000-000000000004', 'english', 'Writing Skills',      'Paragraphs, letters, short essays', 4),
  ('c5000000-0000-0000-0000-000000000005', 'english', 'Communication',       'Dialogues, functions, everyday English', 5);

-- -------------------------------------------------------------------
-- EXERCISES (2-3 per chapter, mix of difficulties)
-- -------------------------------------------------------------------

-- MATH: Calcul numérique
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 'math', 'Puissances et notation scientifique', 1, 50, 10, 'practice', 1),
  ('e1000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000001', 'math', 'Racines carrées - Simplification', 2, 75, 15, 'practice', 2),
  ('e1000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000001', 'math', 'Boss: Calcul numérique avancé', 3, 120, 30, 'boss', 3);

-- MATH: Calcul littéral
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e1000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000002', 'math', 'Développement et réduction', 1, 50, 10, 'practice', 1),
  ('e1000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000002', 'math', 'Factorisation', 2, 75, 15, 'practice', 2),
  ('e1000000-0000-0000-0000-000000000006', 'c1000000-0000-0000-0000-000000000002', 'math', 'Identités remarquables', 2, 80, 20, 'practice', 3);

-- MATH: Equations
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e1000000-0000-0000-0000-000000000007', 'c1000000-0000-0000-0000-000000000003', 'math', 'Équations du 1er degré', 1, 50, 10, 'practice', 1),
  ('e1000000-0000-0000-0000-000000000008', 'c1000000-0000-0000-0000-000000000003', 'math', 'Problèmes traduits en équations', 2, 80, 20, 'practice', 2),
  ('e1000000-0000-0000-0000-000000000009', 'c1000000-0000-0000-0000-000000000003', 'math', 'Boss: Systèmes d''équations', 3, 130, 35, 'boss', 3);

-- MATH: Géométrie
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e1000000-0000-0000-0000-000000000010', 'c1000000-0000-0000-0000-000000000004', 'math', 'Théorème de Pythagore', 1, 50, 10, 'practice', 1),
  ('e1000000-0000-0000-0000-000000000011', 'c1000000-0000-0000-0000-000000000004', 'math', 'Théorème de Thalès', 2, 75, 15, 'practice', 2),
  ('e1000000-0000-0000-0000-000000000012', 'c1000000-0000-0000-0000-000000000004', 'math', 'Boss: Géométrie combinée', 3, 130, 35, 'boss', 3);

-- MATH: Fonctions
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e1000000-0000-0000-0000-000000000013', 'c1000000-0000-0000-0000-000000000005', 'math', 'Fonctions linéaires', 1, 50, 10, 'practice', 1),
  ('e1000000-0000-0000-0000-000000000014', 'c1000000-0000-0000-0000-000000000005', 'math', 'Fonctions affines et graphiques', 2, 75, 15, 'practice', 2);

-- MATH: Statistiques
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e1000000-0000-0000-0000-000000000015', 'c1000000-0000-0000-0000-000000000006', 'math', 'Moyenne et médiane', 1, 50, 10, 'practice', 1),
  ('e1000000-0000-0000-0000-000000000016', 'c1000000-0000-0000-0000-000000000006', 'math', 'Fréquences et diagrammes', 2, 70, 15, 'practice', 2);

-- FRENCH: Grammaire
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e2000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000001', 'french', 'Types et formes de phrases', 1, 50, 10, 'practice', 1),
  ('e2000000-0000-0000-0000-000000000002', 'c2000000-0000-0000-0000-000000000001', 'french', 'Propositions subordonnées', 2, 75, 15, 'practice', 2),
  ('e2000000-0000-0000-0000-000000000003', 'c2000000-0000-0000-0000-000000000001', 'french', 'Voix active et passive', 2, 70, 15, 'practice', 3);

-- FRENCH: Conjugaison
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e2000000-0000-0000-0000-000000000004', 'c2000000-0000-0000-0000-000000000002', 'french', 'Indicatif: temps simples', 1, 50, 10, 'practice', 1),
  ('e2000000-0000-0000-0000-000000000005', 'c2000000-0000-0000-0000-000000000002', 'french', 'Subjonctif et conditionnel', 2, 80, 20, 'practice', 2),
  ('e2000000-0000-0000-0000-000000000006', 'c2000000-0000-0000-0000-000000000002', 'french', 'Boss: Conjugaison mixte', 3, 120, 30, 'boss', 3);

-- FRENCH: Vocabulaire
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e2000000-0000-0000-0000-000000000007', 'c2000000-0000-0000-0000-000000000003', 'french', 'Champs lexicaux', 1, 50, 10, 'practice', 1),
  ('e2000000-0000-0000-0000-000000000008', 'c2000000-0000-0000-0000-000000000003', 'french', 'Synonymes et antonymes', 1, 50, 10, 'practice', 2);

-- FRENCH: Compréhension
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e2000000-0000-0000-0000-000000000009', 'c2000000-0000-0000-0000-000000000004', 'french', 'Texte narratif - Analyse', 2, 75, 15, 'practice', 1),
  ('e2000000-0000-0000-0000-000000000010', 'c2000000-0000-0000-0000-000000000004', 'french', 'Texte argumentatif - Analyse', 2, 80, 20, 'practice', 2);

-- FRENCH: Production écrite
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e2000000-0000-0000-0000-000000000011', 'c2000000-0000-0000-0000-000000000005', 'french', 'Rédiger un paragraphe argumentatif', 2, 80, 20, 'practice', 1);

-- ARABIC exercises
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e3000000-0000-0000-0000-000000000001', 'c3000000-0000-0000-0000-000000000001', 'arabic', 'الإعراب: المبتدأ والخبر', 1, 50, 10, 'practice', 1),
  ('e3000000-0000-0000-0000-000000000002', 'c3000000-0000-0000-0000-000000000001', 'arabic', 'الحال والتمييز', 2, 75, 15, 'practice', 2),
  ('e3000000-0000-0000-0000-000000000003', 'c3000000-0000-0000-0000-000000000001', 'arabic', 'Boss: النحو الشامل', 3, 120, 30, 'boss', 3),
  ('e3000000-0000-0000-0000-000000000004', 'c3000000-0000-0000-0000-000000000002', 'arabic', 'الأفعال المزيدة', 1, 50, 10, 'practice', 1),
  ('e3000000-0000-0000-0000-000000000005', 'c3000000-0000-0000-0000-000000000002', 'arabic', 'المشتقات', 2, 75, 15, 'practice', 2),
  ('e3000000-0000-0000-0000-000000000006', 'c3000000-0000-0000-0000-000000000003', 'arabic', 'التشبيه والاستعارة', 2, 70, 15, 'practice', 1),
  ('e3000000-0000-0000-0000-000000000007', 'c3000000-0000-0000-0000-000000000003', 'arabic', 'الكناية والمجاز', 2, 75, 15, 'practice', 2),
  ('e3000000-0000-0000-0000-000000000008', 'c3000000-0000-0000-0000-000000000005', 'arabic', 'تحليل نص أدبي', 2, 80, 20, 'practice', 1);

-- SVT exercises
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e4000000-0000-0000-0000-000000000001', 'c4000000-0000-0000-0000-000000000001', 'svt', 'La digestion mécanique et chimique', 1, 50, 10, 'practice', 1),
  ('e4000000-0000-0000-0000-000000000002', 'c4000000-0000-0000-0000-000000000001', 'svt', 'Absorption intestinale', 2, 75, 15, 'practice', 2),
  ('e4000000-0000-0000-0000-000000000003', 'c4000000-0000-0000-0000-000000000001', 'svt', 'Boss: Nutrition complète', 3, 120, 30, 'boss', 3),
  ('e4000000-0000-0000-0000-000000000004', 'c4000000-0000-0000-0000-000000000002', 'svt', 'Échanges gazeux respiratoires', 1, 50, 10, 'practice', 1),
  ('e4000000-0000-0000-0000-000000000005', 'c4000000-0000-0000-0000-000000000002', 'svt', 'Maladies respiratoires', 2, 70, 15, 'practice', 2),
  ('e4000000-0000-0000-0000-000000000006', 'c4000000-0000-0000-0000-000000000003', 'svt', 'Le cœur et la circulation', 1, 50, 10, 'practice', 1),
  ('e4000000-0000-0000-0000-000000000007', 'c4000000-0000-0000-0000-000000000003', 'svt', 'Groupes sanguins et transfusion', 2, 80, 20, 'practice', 2),
  ('e4000000-0000-0000-0000-000000000008', 'c4000000-0000-0000-0000-000000000004', 'svt', 'Filtration rénale', 2, 75, 15, 'practice', 1),
  ('e4000000-0000-0000-0000-000000000009', 'c4000000-0000-0000-0000-000000000005', 'svt', 'Puberté et caractères sexuels', 1, 50, 10, 'practice', 1),
  ('e4000000-0000-0000-0000-000000000010', 'c4000000-0000-0000-0000-000000000005', 'svt', 'Cycle menstruel et fécondation', 2, 80, 20, 'practice', 2),
  ('e4000000-0000-0000-0000-000000000011', 'c4000000-0000-0000-0000-000000000006', 'svt', 'Types de roches', 1, 50, 10, 'practice', 1),
  ('e4000000-0000-0000-0000-000000000012', 'c4000000-0000-0000-0000-000000000006', 'svt', 'Boss: Géologie complète', 3, 130, 35, 'boss', 2);

-- ENGLISH exercises
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e5000000-0000-0000-0000-000000000001', 'c5000000-0000-0000-0000-000000000001', 'english', 'Present Simple vs Continuous', 1, 50, 10, 'practice', 1),
  ('e5000000-0000-0000-0000-000000000002', 'c5000000-0000-0000-0000-000000000001', 'english', 'Past Tenses', 1, 50, 10, 'practice', 2),
  ('e5000000-0000-0000-0000-000000000003', 'c5000000-0000-0000-0000-000000000001', 'english', 'Conditionals & If clauses', 2, 75, 15, 'practice', 3),
  ('e5000000-0000-0000-0000-000000000004', 'c5000000-0000-0000-0000-000000000001', 'english', 'Boss: Mixed Grammar', 3, 120, 30, 'boss', 4),
  ('e5000000-0000-0000-0000-000000000005', 'c5000000-0000-0000-0000-000000000002', 'english', 'Word Families', 1, 50, 10, 'practice', 1),
  ('e5000000-0000-0000-0000-000000000006', 'c5000000-0000-0000-0000-000000000002', 'english', 'Phrasal Verbs', 2, 70, 15, 'practice', 2),
  ('e5000000-0000-0000-0000-000000000007', 'c5000000-0000-0000-0000-000000000003', 'english', 'Reading: Main Idea', 1, 50, 10, 'practice', 1),
  ('e5000000-0000-0000-0000-000000000008', 'c5000000-0000-0000-0000-000000000003', 'english', 'Reading: Inference', 2, 75, 15, 'practice', 2),
  ('e5000000-0000-0000-0000-000000000009', 'c5000000-0000-0000-0000-000000000004', 'english', 'Writing: Email & Letter', 2, 80, 20, 'practice', 1),
  ('e5000000-0000-0000-0000-000000000010', 'c5000000-0000-0000-0000-000000000005', 'english', 'Everyday Dialogues', 1, 50, 10, 'practice', 1);

-- -------------------------------------------------------------------
-- QUESTIONS (5 questions per exercise, real Tunisian 9th-year content)
-- -------------------------------------------------------------------

-- ===== MATH: Puissances et notation scientifique =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e1000000-0000-0000-0000-000000000001', 'Que vaut 2³ × 2⁴ ?', '[{"id":"a","text":"2⁷ = 128"},{"id":"b","text":"2¹² = 4096"},{"id":"c","text":"4⁷"},{"id":"d","text":"2⁷ = 64"}]', 'a', 'Quand on multiplie des puissances de même base, on additionne les exposants: 2³ × 2⁴ = 2^(3+4) = 2⁷ = 128.', 1),
('e1000000-0000-0000-0000-000000000001', 'Écrire 0,00045 en notation scientifique :', '[{"id":"a","text":"4,5 × 10⁻⁴"},{"id":"b","text":"45 × 10⁻⁵"},{"id":"c","text":"4,5 × 10⁴"},{"id":"d","text":"0,45 × 10⁻³"}]', 'a', 'On déplace la virgule de 4 rangs vers la droite: 0,00045 = 4,5 × 10⁻⁴.', 2),
('e1000000-0000-0000-0000-000000000001', 'Simplifier (3²)³ :', '[{"id":"a","text":"3⁶ = 729"},{"id":"b","text":"3⁵ = 243"},{"id":"c","text":"9³ = 729"},{"id":"d","text":"3⁶ = 729 et 9³ = 729, les deux sont corrects"}]', 'a', '(3²)³ = 3^(2×3) = 3⁶ = 729. Attention: 9³ donne aussi 729, mais la forme demandée est en puissance de 3.', 3),
('e1000000-0000-0000-0000-000000000001', 'Que vaut 10⁵ ÷ 10² ?', '[{"id":"a","text":"10³ = 1000"},{"id":"b","text":"10⁷"},{"id":"c","text":"10²·⁵"},{"id":"d","text":"100"}]', 'a', 'Division de puissances de même base: on soustrait les exposants. 10⁵ ÷ 10² = 10^(5-2) = 10³ = 1000.', 4),
('e1000000-0000-0000-0000-000000000001', 'Lequel est en notation scientifique correcte ?', '[{"id":"a","text":"3,14 × 10²"},{"id":"b","text":"31,4 × 10¹"},{"id":"c","text":"0,314 × 10³"},{"id":"d","text":"314 × 10⁰"}]', 'a', 'La notation scientifique exige un nombre a tel que 1 ≤ a < 10, multiplié par une puissance de 10.', 5);

-- ===== MATH: Racines carrées =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e1000000-0000-0000-0000-000000000002', 'Simplifier √72 :', '[{"id":"a","text":"6√2"},{"id":"b","text":"4√3"},{"id":"c","text":"3√8"},{"id":"d","text":"2√18"}]', 'a', '√72 = √(36 × 2) = 6√2.', 1),
('e1000000-0000-0000-0000-000000000002', 'Calculer √3 × √12 :', '[{"id":"a","text":"6"},{"id":"b","text":"√36"},{"id":"c","text":"4√3"},{"id":"d","text":"6 (a et b sont identiques)"}]', 'a', '√3 × √12 = √(3 × 12) = √36 = 6.', 2),
('e1000000-0000-0000-0000-000000000002', 'Rationaliser 1/√5 :', '[{"id":"a","text":"√5/5"},{"id":"b","text":"5/√5"},{"id":"c","text":"√5/25"},{"id":"d","text":"1/5"}]', 'a', 'On multiplie par √5/√5: 1/√5 = √5/5.', 3),
('e1000000-0000-0000-0000-000000000002', 'Simplifier √50 + √18 :', '[{"id":"a","text":"8√2"},{"id":"b","text":"√68"},{"id":"c","text":"5√2 + 3√2 = 8√2"},{"id":"d","text":"6√3"}]', 'a', '√50 = 5√2 et √18 = 3√2. Donc √50 + √18 = 8√2.', 4),
('e1000000-0000-0000-0000-000000000002', 'Que vaut (√7)² ?', '[{"id":"a","text":"7"},{"id":"b","text":"√14"},{"id":"c","text":"49"},{"id":"d","text":"√49"}]', 'a', 'Par définition, (√a)² = a. Donc (√7)² = 7.', 5);

-- ===== MATH: Développement et réduction =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e1000000-0000-0000-0000-000000000004', 'Développer 3(2x - 5) :', '[{"id":"a","text":"6x - 15"},{"id":"b","text":"6x - 5"},{"id":"c","text":"5x - 15"},{"id":"d","text":"6x + 15"}]', 'a', '3 × 2x = 6x et 3 × (-5) = -15.', 1),
('e1000000-0000-0000-0000-000000000004', 'Développer (x + 3)(x - 2) :', '[{"id":"a","text":"x² + x - 6"},{"id":"b","text":"x² - x - 6"},{"id":"c","text":"x² + 5x - 6"},{"id":"d","text":"x² - 6"}]', 'a', '(x+3)(x-2) = x² - 2x + 3x - 6 = x² + x - 6.', 2),
('e1000000-0000-0000-0000-000000000004', 'Réduire 5x - 3 + 2x + 7 :', '[{"id":"a","text":"7x + 4"},{"id":"b","text":"7x - 4"},{"id":"c","text":"3x + 4"},{"id":"d","text":"7x + 10"}]', 'a', '5x + 2x = 7x et -3 + 7 = 4. Résultat: 7x + 4.', 3),
('e1000000-0000-0000-0000-000000000004', 'Développer -2(x - 4) :', '[{"id":"a","text":"-2x + 8"},{"id":"b","text":"-2x - 8"},{"id":"c","text":"2x - 8"},{"id":"d","text":"-2x - 4"}]', 'a', '-2 × x = -2x et -2 × (-4) = +8.', 4),
('e1000000-0000-0000-0000-000000000004', 'Développer (2x + 1)(3x - 4) :', '[{"id":"a","text":"6x² - 5x - 4"},{"id":"b","text":"6x² + 5x - 4"},{"id":"c","text":"6x² - 8x + 3x - 4"},{"id":"d","text":"5x² - 3x - 4"}]', 'a', '2x×3x + 2x×(-4) + 1×3x + 1×(-4) = 6x² - 8x + 3x - 4 = 6x² - 5x - 4.', 5);

-- ===== MATH: Factorisation =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e1000000-0000-0000-0000-000000000005', 'Factoriser 6x + 9 :', '[{"id":"a","text":"3(2x + 3)"},{"id":"b","text":"6(x + 9)"},{"id":"c","text":"3(2x + 9)"},{"id":"d","text":"9(x + 1)"}]', 'a', 'PGCD(6,9) = 3. On factorise: 3(2x + 3).', 1),
('e1000000-0000-0000-0000-000000000005', 'Factoriser x² - 9 :', '[{"id":"a","text":"(x-3)(x+3)"},{"id":"b","text":"(x-9)(x+1)"},{"id":"c","text":"(x-3)²"},{"id":"d","text":"x(x-9)"}]', 'a', 'C''est une différence de carrés: a² - b² = (a-b)(a+b). Ici x² - 3² = (x-3)(x+3).', 2),
('e1000000-0000-0000-0000-000000000005', 'Factoriser x² + 6x + 9 :', '[{"id":"a","text":"(x + 3)²"},{"id":"b","text":"(x + 9)(x + 1)"},{"id":"c","text":"(x + 3)(x - 3)"},{"id":"d","text":"(x + 6)(x + 3)"}]', 'a', 'C''est un carré parfait: x² + 2(3)(x) + 3² = (x + 3)².', 3),
('e1000000-0000-0000-0000-000000000005', 'Factoriser 4x² - 25 :', '[{"id":"a","text":"(2x-5)(2x+5)"},{"id":"b","text":"(4x-5)(x+5)"},{"id":"c","text":"(2x-5)²"},{"id":"d","text":"4(x²-25)"}]', 'a', '4x² - 25 = (2x)² - 5² = (2x-5)(2x+5).', 4),
('e1000000-0000-0000-0000-000000000005', 'Factoriser 2x² + 8x :', '[{"id":"a","text":"2x(x + 4)"},{"id":"b","text":"x(2x + 8)"},{"id":"c","text":"2(x² + 4x)"},{"id":"d","text":"2x(x + 4) — forme complètement factorisée"}]', 'a', 'On met 2x en facteur: 2x² + 8x = 2x(x + 4).', 5);

-- ===== MATH: Equations du 1er degré =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e1000000-0000-0000-0000-000000000007', 'Résoudre 3x + 7 = 22 :', '[{"id":"a","text":"x = 5"},{"id":"b","text":"x = 7"},{"id":"c","text":"x = 3"},{"id":"d","text":"x = 10"}]', 'a', '3x = 22 - 7 = 15, donc x = 15/3 = 5.', 1),
('e1000000-0000-0000-0000-000000000007', 'Résoudre 2(x - 3) = 10 :', '[{"id":"a","text":"x = 8"},{"id":"b","text":"x = 5"},{"id":"c","text":"x = 6,5"},{"id":"d","text":"x = 4"}]', 'a', '2x - 6 = 10, 2x = 16, x = 8.', 2),
('e1000000-0000-0000-0000-000000000007', 'Résoudre 5x - 3 = 2x + 9 :', '[{"id":"a","text":"x = 4"},{"id":"b","text":"x = 3"},{"id":"c","text":"x = 6"},{"id":"d","text":"x = 2"}]', 'a', '5x - 2x = 9 + 3, 3x = 12, x = 4.', 3),
('e1000000-0000-0000-0000-000000000007', 'Résoudre x/4 = 3 :', '[{"id":"a","text":"x = 12"},{"id":"b","text":"x = 0,75"},{"id":"c","text":"x = 7"},{"id":"d","text":"x = 4/3"}]', 'a', 'x = 3 × 4 = 12.', 4),
('e1000000-0000-0000-0000-000000000007', 'Résoudre -2x + 5 = -3 :', '[{"id":"a","text":"x = 4"},{"id":"b","text":"x = -4"},{"id":"c","text":"x = 1"},{"id":"d","text":"x = -1"}]', 'a', '-2x = -3 - 5 = -8, x = -8/(-2) = 4.', 5);

-- ===== MATH: Pythagore =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e1000000-0000-0000-0000-000000000010', 'Dans un triangle rectangle d''hypoténuse c, avec a=3 et b=4, que vaut c ?', '[{"id":"a","text":"5"},{"id":"b","text":"7"},{"id":"c","text":"√7"},{"id":"d","text":"25"}]', 'a', 'c² = a² + b² = 9 + 16 = 25, donc c = 5.', 1),
('e1000000-0000-0000-0000-000000000010', 'Un triangle a des côtés 5, 12 et 13. Est-il rectangle ?', '[{"id":"a","text":"Oui, car 5² + 12² = 13²"},{"id":"b","text":"Non"},{"id":"c","text":"On ne peut pas savoir"},{"id":"d","text":"Oui, car 5 + 12 = 17 > 13"}]', 'a', '5² + 12² = 25 + 144 = 169 = 13². La réciproque de Pythagore confirme qu''il est rectangle.', 2),
('e1000000-0000-0000-0000-000000000010', 'Calculer la diagonale d''un carré de côté 6 :', '[{"id":"a","text":"6√2"},{"id":"b","text":"12"},{"id":"c","text":"√6"},{"id":"d","text":"36"}]', 'a', 'd² = 6² + 6² = 72, d = √72 = 6√2.', 3),
('e1000000-0000-0000-0000-000000000010', 'Dans un triangle rectangle, l''hypoténuse vaut 10 et un côté vaut 6. L''autre côté vaut :', '[{"id":"a","text":"8"},{"id":"b","text":"√64 = 8"},{"id":"c","text":"4"},{"id":"d","text":"a et b sont la même réponse: 8"}]', 'a', 'b² = 10² - 6² = 100 - 36 = 64, b = 8.', 4),
('e1000000-0000-0000-0000-000000000010', 'Le théorème de Pythagore s''applique uniquement aux triangles :', '[{"id":"a","text":"rectangles"},{"id":"b","text":"isocèles"},{"id":"c","text":"équilatéraux"},{"id":"d","text":"quelconques"}]', 'a', 'Le théorème de Pythagore ne s''applique qu''aux triangles rectangles.', 5);

-- ===== FRENCH: Types et formes de phrases =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000001', '"Quelle belle journée !" est une phrase :', '[{"id":"a","text":"exclamative"},{"id":"b","text":"interrogative"},{"id":"c","text":"déclarative"},{"id":"d","text":"impérative"}]', 'a', 'La présence du point d''exclamation et l''expression d''un sentiment indiquent une phrase exclamative.', 1),
('e2000000-0000-0000-0000-000000000001', '"Ne touche pas à ce vase." est une phrase :', '[{"id":"a","text":"impérative et négative"},{"id":"b","text":"déclarative et négative"},{"id":"c","text":"impérative et affirmative"},{"id":"d","text":"interrogative"}]', 'a', 'Elle exprime un ordre (impérative) avec une négation (ne...pas).', 2),
('e2000000-0000-0000-0000-000000000001', 'Quelle est la forme passive de "Le chat mange la souris" ?', '[{"id":"a","text":"La souris est mangée par le chat"},{"id":"b","text":"La souris mange le chat"},{"id":"c","text":"Le chat est mangé par la souris"},{"id":"d","text":"La souris a été mangée"}]', 'a', 'Le COD (la souris) devient sujet, le verbe passe à la voix passive, et le sujet initial devient complément d''agent.', 3),
('e2000000-0000-0000-0000-000000000001', 'Identifier le type: "Viens-tu demain ?"', '[{"id":"a","text":"interrogative"},{"id":"b","text":"exclamative"},{"id":"c","text":"déclarative"},{"id":"d","text":"impérative"}]', 'a', 'La phrase pose une question et se termine par un point d''interrogation.', 4),
('e2000000-0000-0000-0000-000000000001', 'La forme emphatique de "Pierre a réussi" est :', '[{"id":"a","text":"C''est Pierre qui a réussi"},{"id":"b","text":"Pierre n''a pas réussi"},{"id":"c","text":"Pierre a-t-il réussi ?"},{"id":"d","text":"Pierre, il a réussi"}]', 'a', 'La forme emphatique met en relief un élément avec "c''est... qui/que".', 5);

-- ===== FRENCH: Indicatif temps simples =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000004', 'Conjuguer "finir" au présent avec "nous" :', '[{"id":"a","text":"nous finissons"},{"id":"b","text":"nous finisons"},{"id":"c","text":"nous finirons"},{"id":"d","text":"nous finîmes"}]', 'a', 'Les verbes du 2ème groupe ont -issons à la 1ère personne du pluriel au présent.', 1),
('e2000000-0000-0000-0000-000000000004', 'Quel temps: "Il pleuvait quand je suis sorti" (pleuvait) ?', '[{"id":"a","text":"imparfait"},{"id":"b","text":"passé simple"},{"id":"c","text":"passé composé"},{"id":"d","text":"plus-que-parfait"}]', 'a', 'L''imparfait décrit une action en cours dans le passé (arrière-plan).', 2),
('e2000000-0000-0000-0000-000000000004', 'Conjuguer "aller" au futur simple avec "ils" :', '[{"id":"a","text":"ils iront"},{"id":"b","text":"ils alleront"},{"id":"c","text":"ils vont"},{"id":"d","text":"ils allèrent"}]', 'a', '"Aller" est irrégulier au futur: j''irai, tu iras... ils iront.', 3),
('e2000000-0000-0000-0000-000000000004', '"Elle chanta toute la nuit." Le verbe est au :', '[{"id":"a","text":"passé simple"},{"id":"b","text":"imparfait"},{"id":"c","text":"présent"},{"id":"d","text":"conditionnel"}]', 'a', 'La terminaison -a (1er groupe) au passé simple indique une action ponctuelle révolue.', 4),
('e2000000-0000-0000-0000-000000000004', 'Conjuguer "prendre" à l''imparfait avec "tu" :', '[{"id":"a","text":"tu prenais"},{"id":"b","text":"tu prendais"},{"id":"c","text":"tu prenis"},{"id":"d","text":"tu pris"}]', 'a', 'Radical "pren-" + terminaisons de l''imparfait: -ais, -ais, -ait...', 5);

-- ===== SVT: Digestion =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e4000000-0000-0000-0000-000000000001', 'Quel organe produit la bile ?', '[{"id":"a","text":"Le foie"},{"id":"b","text":"L''estomac"},{"id":"c","text":"Le pancréas"},{"id":"d","text":"L''intestin grêle"}]', 'a', 'La bile est produite par le foie et stockée dans la vésicule biliaire.', 1),
('e4000000-0000-0000-0000-000000000001', 'La digestion mécanique dans l''estomac consiste en :', '[{"id":"a","text":"Des contractions qui brassent les aliments"},{"id":"b","text":"L''action des enzymes"},{"id":"c","text":"L''absorption des nutriments"},{"id":"d","text":"La sécrétion de bile"}]', 'a', 'Les contractions musculaires de l''estomac (péristaltisme) assurent le brassage mécanique.', 2),
('e4000000-0000-0000-0000-000000000001', 'L''enzyme principale de l''estomac est :', '[{"id":"a","text":"La pepsine"},{"id":"b","text":"L''amylase"},{"id":"c","text":"La lipase"},{"id":"d","text":"La trypsine"}]', 'a', 'La pepsine dégrade les protéines en milieu acide (HCl) dans l''estomac.', 3),
('e4000000-0000-0000-0000-000000000001', 'L''absorption intestinale se fait principalement au niveau :', '[{"id":"a","text":"Des villosités de l''intestin grêle"},{"id":"b","text":"De l''estomac"},{"id":"c","text":"Du côlon"},{"id":"d","text":"De l''œsophage"}]', 'a', 'Les villosités intestinales augmentent la surface d''absorption dans l''intestin grêle.', 4),
('e4000000-0000-0000-0000-000000000001', 'Les nutriments issus de la digestion des glucides sont :', '[{"id":"a","text":"Le glucose"},{"id":"b","text":"Les acides aminés"},{"id":"c","text":"Les acides gras"},{"id":"d","text":"Le glycérol"}]', 'a', 'Les glucides (amidon, sucres) sont dégradés en glucose, le nutriment assimilable.', 5);

-- ===== SVT: Circulation sanguine =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e4000000-0000-0000-0000-000000000006', 'Combien de cavités possède le cœur humain ?', '[{"id":"a","text":"4 (2 oreillettes + 2 ventricules)"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"6"}]', 'a', 'Le cœur possède 4 cavités: oreillette droite, ventricule droit, oreillette gauche, ventricule gauche.', 1),
('e4000000-0000-0000-0000-000000000006', 'Les artères transportent le sang :', '[{"id":"a","text":"Du cœur vers les organes"},{"id":"b","text":"Des organes vers le cœur"},{"id":"c","text":"Uniquement du sang oxygéné"},{"id":"d","text":"Uniquement du sang désoxygéné"}]', 'a', 'Les artères transportent le sang DU cœur vers les organes, qu''il soit oxygéné ou non.', 2),
('e4000000-0000-0000-0000-000000000006', 'La petite circulation relie :', '[{"id":"a","text":"Le cœur aux poumons"},{"id":"b","text":"Le cœur aux organes"},{"id":"c","text":"Les veines aux artères"},{"id":"d","text":"L''intestin au foie"}]', 'a', 'La petite circulation (pulmonaire) assure les échanges gazeux entre le cœur et les poumons.', 3),
('e4000000-0000-0000-0000-000000000006', 'Quel vaisseau apporte le sang riche en O₂ au cœur ?', '[{"id":"a","text":"Les veines pulmonaires"},{"id":"b","text":"L''artère pulmonaire"},{"id":"c","text":"La veine cave"},{"id":"d","text":"L''aorte"}]', 'a', 'Les veines pulmonaires ramènent le sang oxygéné des poumons vers l''oreillette gauche.', 4),
('e4000000-0000-0000-0000-000000000006', 'Le rôle des valvules cardiaques est :', '[{"id":"a","text":"Empêcher le reflux du sang"},{"id":"b","text":"Pomper le sang"},{"id":"c","text":"Oxygéner le sang"},{"id":"d","text":"Filtrer le sang"}]', 'a', 'Les valvules s''ouvrent dans un seul sens pour empêcher le retour du sang.', 5);

-- ===== ENGLISH: Present Simple vs Continuous =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e5000000-0000-0000-0000-000000000001', 'Choose the correct form: "She ___ to school every day."', '[{"id":"a","text":"goes"},{"id":"b","text":"is going"},{"id":"c","text":"go"},{"id":"d","text":"going"}]', 'a', 'We use Present Simple for routines/habits. "Every day" signals a routine. She goes (3rd person -s).', 1),
('e5000000-0000-0000-0000-000000000001', '"Look! The baby ___." (walk)', '[{"id":"a","text":"is walking"},{"id":"b","text":"walks"},{"id":"c","text":"walked"},{"id":"d","text":"walk"}]', 'a', '"Look!" indicates something happening right now → Present Continuous (is + verb-ing).', 2),
('e5000000-0000-0000-0000-000000000001', 'Which sentence is correct?', '[{"id":"a","text":"Water boils at 100°C."},{"id":"b","text":"Water is boiling at 100°C."},{"id":"c","text":"Water boil at 100°C."},{"id":"d","text":"Water has boiled at 100°C."}]', 'a', 'Scientific facts use Present Simple. "Water boils at 100°C" is a general truth.', 3),
('e5000000-0000-0000-0000-000000000001', '"I ___ my homework right now."', '[{"id":"a","text":"am doing"},{"id":"b","text":"do"},{"id":"c","text":"does"},{"id":"d","text":"did"}]', 'a', '"Right now" means the action is in progress → Present Continuous.', 4),
('e5000000-0000-0000-0000-000000000001', '"He never ___ coffee."', '[{"id":"a","text":"drinks"},{"id":"b","text":"is drinking"},{"id":"c","text":"drink"},{"id":"d","text":"drinking"}]', 'a', '"Never" signals a habit/routine → Present Simple. Third person singular adds -s.', 5);

-- ===== ENGLISH: Past Tenses =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e5000000-0000-0000-0000-000000000002', '"Yesterday, I ___ to the market." (go)', '[{"id":"a","text":"went"},{"id":"b","text":"goed"},{"id":"c","text":"was going"},{"id":"d","text":"have gone"}]', 'a', '"Yesterday" = completed past action → Past Simple. "Go" is irregular: go → went.', 1),
('e5000000-0000-0000-0000-000000000002', '"While I ___, the phone rang." (study)', '[{"id":"a","text":"was studying"},{"id":"b","text":"studied"},{"id":"c","text":"am studying"},{"id":"d","text":"study"}]', 'a', '"While" + interrupted action = Past Continuous. The longer action uses was/were + -ing.', 2),
('e5000000-0000-0000-0000-000000000002', 'Choose the correct past form of "write":', '[{"id":"a","text":"wrote"},{"id":"b","text":"writed"},{"id":"c","text":"wroten"},{"id":"d","text":"writing"}]', 'a', '"Write" is irregular: write → wrote → written.', 3),
('e5000000-0000-0000-0000-000000000002', '"They ___ football when it started to rain."', '[{"id":"a","text":"were playing"},{"id":"b","text":"played"},{"id":"c","text":"play"},{"id":"d","text":"are playing"}]', 'a', 'Action in progress interrupted by another event → Past Continuous (were playing) + Past Simple (started).', 4),
('e5000000-0000-0000-0000-000000000002', '"She ___ her keys last night."', '[{"id":"a","text":"lost"},{"id":"b","text":"losed"},{"id":"c","text":"was losing"},{"id":"d","text":"has lost"}]', 'a', '"Last night" = specific time in the past → Past Simple. "Lose" is irregular: lose → lost.', 5);

-- ===== ARABIC: المبتدأ والخبر =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e3000000-0000-0000-0000-000000000001', 'ما إعراب كلمة "العلمُ" في: "العلمُ نورٌ"؟', '[{"id":"a","text":"مبتدأ مرفوع بالضمة"},{"id":"b","text":"خبر مرفوع"},{"id":"c","text":"فاعل"},{"id":"d","text":"مفعول به"}]', 'a', '"العلمُ" هو المبتدأ لأنه الاسم الذي بُدئت به الجملة الاسمية، وهو مرفوع بالضمة الظاهرة.', 1),
('e3000000-0000-0000-0000-000000000001', 'ما نوع الخبر في: "الطالبُ في الفصلِ"؟', '[{"id":"a","text":"خبر شبه جملة (جار ومجرور)"},{"id":"b","text":"خبر مفرد"},{"id":"c","text":"خبر جملة فعلية"},{"id":"d","text":"خبر جملة اسمية"}]', 'a', '"في الفصلِ" جار ومجرور في محل رفع خبر المبتدأ.', 2),
('e3000000-0000-0000-0000-000000000001', 'أعرب "جميلةٌ" في: "الحديقةُ جميلةٌ":', '[{"id":"a","text":"خبر مرفوع بالضمة"},{"id":"b","text":"نعت"},{"id":"c","text":"حال"},{"id":"d","text":"مبتدأ"}]', 'a', '"جميلةٌ" هو خبر المبتدأ "الحديقةُ"، مرفوع بالضمة الظاهرة.', 3),
('e3000000-0000-0000-0000-000000000001', 'ما نوع الخبر في: "المعلمُ يشرحُ الدرسَ"؟', '[{"id":"a","text":"خبر جملة فعلية"},{"id":"b","text":"خبر مفرد"},{"id":"c","text":"خبر شبه جملة"},{"id":"d","text":"خبر جملة اسمية"}]', 'a', '"يشرحُ الدرسَ" جملة فعلية في محل رفع خبر المبتدأ "المعلمُ".', 4),
('e3000000-0000-0000-0000-000000000001', 'في الجملة "إنَّ العلمَ مفيدٌ"، كلمة "العلمَ" هي:', '[{"id":"a","text":"اسم إنَّ منصوب بالفتحة"},{"id":"b","text":"مبتدأ مرفوع"},{"id":"c","text":"خبر إنَّ"},{"id":"d","text":"مفعول به"}]', 'a', '"إنَّ" من الحروف الناسخة تنصب المبتدأ ويصبح اسمها. "العلمَ" اسم إنَّ منصوب بالفتحة.', 5);

-- ===== ARABIC: التشبيه والاستعارة =====
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e3000000-0000-0000-0000-000000000006', 'في "الجنديُّ كالأسدِ في الشجاعةِ"، ما نوع التشبيه؟', '[{"id":"a","text":"تشبيه تام الأركان"},{"id":"b","text":"تشبيه بليغ"},{"id":"c","text":"استعارة مكنية"},{"id":"d","text":"استعارة تصريحية"}]', 'a', 'التشبيه التام يحتوي على الأركان الأربعة: المشبّه (الجندي)، أداة التشبيه (الكاف)، المشبّه به (الأسد)، ووجه الشبه (الشجاعة).', 1),
('e3000000-0000-0000-0000-000000000006', '"العلمُ نورٌ" هو:', '[{"id":"a","text":"تشبيه بليغ"},{"id":"b","text":"تشبيه تام"},{"id":"c","text":"استعارة"},{"id":"d","text":"كناية"}]', 'a', 'التشبيه البليغ هو ما حُذفت منه أداة التشبيه ووجه الشبه، ولم يبقَ إلا المشبّه والمشبّه به.', 2),
('e3000000-0000-0000-0000-000000000006', 'في "نطق الكتابُ بالحقيقة"، الصورة البيانية هي:', '[{"id":"a","text":"استعارة مكنية"},{"id":"b","text":"تشبيه"},{"id":"c","text":"استعارة تصريحية"},{"id":"d","text":"مجاز مرسل"}]', 'a', 'شُبِّه الكتاب بإنسان (المشبه به محذوف) ورُمز له بصفة من صفاته (النطق). هذه استعارة مكنية.', 3),
('e3000000-0000-0000-0000-000000000006', '"رأيتُ بحرًا يُلقي محاضرةً" (يقصد عالِمًا):', '[{"id":"a","text":"استعارة تصريحية"},{"id":"b","text":"استعارة مكنية"},{"id":"c","text":"تشبيه بليغ"},{"id":"d","text":"كناية"}]', 'a', 'ذُكر المشبّه به (بحر) وحُذف المشبّه (العالِم). هذه استعارة تصريحية.', 4),
('e3000000-0000-0000-0000-000000000006', '"فلانٌ كثيرُ الرمادِ" كناية عن:', '[{"id":"a","text":"الكرم"},{"id":"b","text":"الفقر"},{"id":"c","text":"الطبخ"},{"id":"d","text":"النظافة"}]', 'a', 'كثرة الرماد تدل على كثرة الطبخ، وكثرة الطبخ تدل على كثرة الضيوف، وهذا دليل الكرم.', 5);

-- -------------------------------------------------------------------
-- BADGES
-- -------------------------------------------------------------------
INSERT INTO public.badges (id, code, name, description, rarity, icon_name, rule_key) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'first_quest',     'Première Quête',          'Terminer son premier exercice',               'common',    'Sword',       'first_quest'),
  ('b0000000-0000-0000-0000-000000000002', 'streak_7',        'Flamme de 7 Jours',       '7 jours consécutifs de révision',             'rare',      'Flame',       'streak_7'),
  ('b0000000-0000-0000-0000-000000000003', 'streak_30',       'Flamme Légendaire',       '30 jours consécutifs de révision',            'legendary', 'Zap',         'streak_30'),
  ('b0000000-0000-0000-0000-000000000004', 'perfect_score',   'Score Parfait',           'Obtenir 100% sur un exercice',                'rare',      'Star',        'perfect_score'),
  ('b0000000-0000-0000-0000-000000000005', 'speed_demon',     'Démon de Vitesse',        'Terminer un exercice en moins de 60 secondes','rare',      'Timer',       'speed_demon'),
  ('b0000000-0000-0000-0000-000000000006', 'math_master',     'Maître des Maths',        'Compléter tous les exercices de maths',       'epic',      'Calculator',  'math_master'),
  ('b0000000-0000-0000-0000-000000000007', 'polyglot',        'Polyglotte',              'Réussir un exercice dans chaque matière',     'epic',      'Languages',   'polyglot'),
  ('b0000000-0000-0000-0000-000000000008', 'boss_slayer',     'Tueur de Boss',           'Vaincre son premier Boss',                    'rare',      'Shield',      'boss_slayer'),
  ('b0000000-0000-0000-0000-000000000009', 'level_10',        'Rang 10',                 'Atteindre le niveau 10',                      'common',    'TrendingUp',  'level_10'),
  ('b0000000-0000-0000-0000-000000000010', 'collector',       'Collectionneur',          'Posséder 5 objets différents',                'rare',      'Package',     'collector'),
  ('b0000000-0000-0000-0000-000000000011', 'rich_kid',        'Riche Héritier',          'Accumuler 500 YahiaCoins',                    'epic',      'Coins',       'rich_kid'),
  ('b0000000-0000-0000-0000-000000000012', 'night_owl',       'Hibou Nocturne',          'Réviser après 22h',                           'common',    'Moon',        'night_owl')
ON CONFLICT (code) DO NOTHING;

-- -------------------------------------------------------------------
-- SHOP ITEMS
-- -------------------------------------------------------------------
INSERT INTO public.shop_items (id, code, name, item_type, description, price_coins, effect_payload, is_active) VALUES
  ('f0000000-0000-0000-0000-000000000001', 'skin_samurai',     'Armure Samouraï',      'skin',    'Avatar guerrier japonais',                              100, '{"avatarSlug":"samurai"}',       true),
  ('f0000000-0000-0000-0000-000000000002', 'skin_ninja',       'Tenue Ninja',          'skin',    'Silencieux et mortel',                                  80,  '{"avatarSlug":"ninja"}',         true),
  ('f0000000-0000-0000-0000-000000000003', 'skin_mage',        'Robe de Mage',         'skin',    'Maître des arcanes',                                    120, '{"avatarSlug":"mage"}',          true),
  ('f0000000-0000-0000-0000-000000000004', 'skin_dragon',      'Écailles de Dragon',   'skin',    'Forme draconique légendaire',                           250, '{"avatarSlug":"dragon"}',        true),
  ('f0000000-0000-0000-0000-000000000005', 'potion_xp_boost',  'Potion XP x2',         'potion',  'Double les XP gagnés pendant 1 quête',                  50,  '{"xpMultiplier":2,"uses":1}',    true),
  ('f0000000-0000-0000-0000-000000000006', 'potion_xp_mega',   'Méga Potion XP x3',    'potion',  'Triple les XP gagnés pendant 1 quête',                  120, '{"xpMultiplier":3,"uses":1}',    true),
  ('f0000000-0000-0000-0000-000000000007', 'shield_retry',     'Bouclier de Réessai',  'shield',  'Permet de recommencer un exercice raté sans pénalité',  60,  '{"retries":1}',                  true),
  ('f0000000-0000-0000-0000-000000000008', 'booster_hint',     'Indice Mystique',      'booster', 'Révèle un indice sur une question difficile',           30,  '{"hints":3}',                    true),
  ('f0000000-0000-0000-0000-000000000009', 'skin_pharaoh',     'Masque du Pharaon',    'skin',    'Puissance des anciens rois',                            200, '{"avatarSlug":"pharaoh"}',       true),
  ('f0000000-0000-0000-0000-000000000010', 'potion_coins',     'Pierre Philosophale',  'potion',  'Transforme 1 quête en double coins',                    40,  '{"coinMultiplier":2,"uses":1}',  true)
ON CONFLICT (code) DO NOTHING;
