-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-histoire-fr (Culture générale — Histoire (FR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-histoire-fr/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium, theme_id, grade_id) VALUES
  ('culture-generale-histoire-fr', 'Culture générale — Histoire (FR)', 'Les grandes dates et figures de l''histoire mondiale et tunisienne, de l''Antiquité à nos jours, pour bâtir une solide culture historique.', 'Mémoire', 'subject-svt', 'Landmark', 10, 'fr', false, 'culture-generale', NULL)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr,
  description = EXCLUDED.description,
  attribute = EXCLUDED.attribute,
  color_token = EXCLUDED.color_token,
  icon = EXCLUDED.icon,
  display_order = EXCLUDED.display_order,
  content_language = EXCLUDED.content_language,
  is_premium = EXCLUDED.is_premium,
  theme_id = EXCLUDED.theme_id,
  grade_id = EXCLUDED.grade_id;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'culture-generale-histoire-fr'
      AND e.source = 'admin'
      AND q.id NOT IN ('82794f6d-627c-5654-8ccb-8dc771b4294e', '38a0c33e-a18a-595d-a509-d1ccb94df29f', '58bdb6bb-10aa-5846-a27d-b8cf4b48b945', '38189285-fb89-5c9f-9c8d-b0e286a42340', 'da2a9a90-7d57-5560-8076-74d17209986e', 'f4215d5d-75c9-53e1-b793-62e671c118e3', '44140f34-bb84-5e72-b22b-282fb51862c1', 'e0ac0428-a87b-5e57-b73f-4bad6ad8dbfa', 'd9ba5972-0206-58cf-9073-416aac0b7e6b', 'f4f91762-89ce-5895-b5f7-28e382218875', '4cca85a6-7dce-5944-b9e9-eda532f7f278', '82bbf15e-9d4e-5d8f-ba0a-b64f3ee3ba3d', 'afbb4cd9-3ff5-5fc2-888b-f144f6950456', 'eca06e7f-53c5-53b6-978a-19a97d31289f', '348b6eb4-65d5-55d1-bc35-e996e85df3a7', 'd3d0d2af-72bf-5dd4-804a-96098c25da93', '3bbd837b-9412-5b86-9750-49fb0cafdd5d', '390eec7c-574b-57a2-897c-e92594613a6a', 'cbf265ed-4dec-5149-b1b0-b0578009e9f8', '4869b07b-c732-53ad-a9ef-42e0d62ebb0e', 'db5bd79b-64b3-5112-b36d-92aca5180f3e', 'f5a6401a-47a1-5ad2-aaab-084b3f561c2f', 'd2586c39-f86d-5c20-9470-6bfb08067d4b', '80b74c04-108b-5402-b149-7fe7187d56d3', '5e109e85-d35f-5319-a0d2-1599926ac54a', 'f758851b-31b2-5465-9887-ebfd4ac65cca', 'a9a77033-7de8-54fe-9f7b-f873f57e0bc4', 'c9341589-c15f-5da3-9e8d-84a3a5e5edae', 'db57349e-8585-521c-865e-66ffa044b02e');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-histoire-fr' AND source = 'admin' AND id NOT IN ('8168c46e-54c6-56f6-8196-3c7e78f67255', '842d0b7d-9808-571c-bb22-020522a5411c', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632');
DELETE FROM public.questions WHERE exercise_id IN ('8168c46e-54c6-56f6-8196-3c7e78f67255', '842d0b7d-9808-571c-bb22-020522a5411c', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632') AND id NOT IN ('82794f6d-627c-5654-8ccb-8dc771b4294e', '38a0c33e-a18a-595d-a509-d1ccb94df29f', '58bdb6bb-10aa-5846-a27d-b8cf4b48b945', '38189285-fb89-5c9f-9c8d-b0e286a42340', 'da2a9a90-7d57-5560-8076-74d17209986e', 'f4215d5d-75c9-53e1-b793-62e671c118e3', '44140f34-bb84-5e72-b22b-282fb51862c1', 'e0ac0428-a87b-5e57-b73f-4bad6ad8dbfa', 'd9ba5972-0206-58cf-9073-416aac0b7e6b', 'f4f91762-89ce-5895-b5f7-28e382218875', '4cca85a6-7dce-5944-b9e9-eda532f7f278', '82bbf15e-9d4e-5d8f-ba0a-b64f3ee3ba3d', 'afbb4cd9-3ff5-5fc2-888b-f144f6950456', 'eca06e7f-53c5-53b6-978a-19a97d31289f', '348b6eb4-65d5-55d1-bc35-e996e85df3a7', 'd3d0d2af-72bf-5dd4-804a-96098c25da93', '3bbd837b-9412-5b86-9750-49fb0cafdd5d', '390eec7c-574b-57a2-897c-e92594613a6a', 'cbf265ed-4dec-5149-b1b0-b0578009e9f8', '4869b07b-c732-53ad-a9ef-42e0d62ebb0e', 'db5bd79b-64b3-5112-b36d-92aca5180f3e', 'f5a6401a-47a1-5ad2-aaab-084b3f561c2f', 'd2586c39-f86d-5c20-9470-6bfb08067d4b', '80b74c04-108b-5402-b149-7fe7187d56d3', '5e109e85-d35f-5319-a0d2-1599926ac54a', 'f758851b-31b2-5465-9887-ebfd4ac65cca', 'a9a77033-7de8-54fe-9f7b-f873f57e0bc4', 'c9341589-c15f-5da3-9e8d-84a3a5e5edae', 'db57349e-8585-521c-865e-66ffa044b02e');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-histoire-fr' AND c.id NOT IN ('5a94893c-cdbd-5e43-a0b0-e603b299d966') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5a94893c-cdbd-5e43-a0b0-e603b299d966', 'culture-generale-histoire-fr', 'Les grandes dates de l''Histoire', 'Un voyage à travers les tournants majeurs de l''histoire mondiale et tunisienne : chute de Rome, 1492, Révolution française, guerres mondiales, indépendance de la Tunisie, conquête de la Lune et chute du mur de Berlin.', '# ⚔️ Les grandes dates de l''Histoire — la frise des héros et des empires

> 💡 « Un peuple qui ignore son passé avance les yeux bandés. Connaître les dates, c''est tenir la carte du temps. »

Bienvenue, apprenti chrono-mage. Cette première porte t''ouvre la grande frise de l''humanité : les batailles décisives, les révolutions qui ont renversé des rois, les découvertes qui ont changé le monde. Chaque date est une clé. Mémorise-les, et le temps n''aura plus de secret pour toi.

## 🏛️ L''Antiquité s''éteint (476)

Pendant des siècles, **Rome** domine le monde méditerranéen. Mais l''Empire s''affaiblit, divisé entre **Occident** et **Orient**.

- En **476**, le chef germanique **Odoacre** dépose le jeune empereur **Romulus Augustule** : c''est la fin conventionnelle de l''**Empire romain d''Occident**.
- Cette date marque traditionnellement la **fin de l''Antiquité** et le début du **Moyen Âge**.
- L''Empire romain d''**Orient** (Byzance), lui, survivra encore près de mille ans, jusqu''en **1453**.

> 🗡️ Astuce de mémorisation : 476 = la chute de Rome ; 1453 = la chute de Constantinople. Deux « fins » qui encadrent tout le Moyen Âge.

## 🌍 Le monde s''agrandit (1492)

- En **1492**, **Christophe Colomb**, financé par l''Espagne, atteint une île des **Bahamas** en cherchant la route des Indes par l''ouest.
- Il croit avoir trouvé l''Asie : il ne saura jamais qu''il a abordé un **Nouveau Monde**.
- Cette date ouvre l''ère des **Grandes Découvertes** et marque souvent le début des **Temps modernes**.

> ⚠️ Piège classique : Colomb n''a **pas** « découvert » l''Amérique pour l''humanité — des **Vikings** y avaient abordé vers l''an 1000, et des peuples y vivaient depuis des millénaires. Sa traversée a surtout relié durablement les deux mondes.

## 🔥 La Révolution française (1789)

L''événement fondateur de la France moderne et un symbole universel de liberté.

- Le **14 juillet 1789**, le peuple parisien prend la **Bastille**, prison-forteresse royale : début symbolique de la **Révolution française**.
- Le **26 août 1789**, l''Assemblée adopte la **Déclaration des droits de l''homme et du citoyen**.
- Le **14 juillet** deviendra la **fête nationale** française en **1880**.

## 📅 La frise des tournants majeurs

| Date | Événement | Ce qu''elle change |
|---|---|---|
| **476** | Chute de Rome (Occident) | Fin de l''Antiquité |
| **1492** | Colomb atteint l''Amérique | Début des Temps modernes |
| **1789** | Prise de la Bastille | Naissance de la France moderne |
| **1914-1918** | Première Guerre mondiale | Effondrement des empires |
| **1939-1945** | Seconde Guerre mondiale | Naissance de l''ONU |
| **1969** | Premiers pas sur la Lune | L''humanité quitte la Terre |
| **1989** | Chute du mur de Berlin | Fin de la guerre froide |

## 🌐 Les deux guerres mondiales (1914-1945)

- La **Première Guerre mondiale** (1914-1918) se termine par l''**armistice du 11 novembre 1918**, signé à Rethondes.
- La **Seconde Guerre mondiale** (1939-1945) s''achève en Europe le **8 mai 1945** (capitulation allemande) et dans le monde le **2 septembre 1945** (capitulation du Japon).
- De ses ruines naît l''**Organisation des Nations unies (ONU)** en **1945**, pour préserver la paix.

## 🇹🇳 L''indépendance de la Tunisie (1956)

Un tournant capital de notre histoire nationale.

- Le **20 mars 1956**, la France reconnaît l''**indépendance** de la Tunisie et abroge le **traité du Bardo** de 1881 qui avait instauré le protectorat.
- L''artisan principal en est **Habib Bourguiba**, leader du **Néo-Destour**, qui deviendra le premier président de la République tunisienne en **1957**.
- Le **20 mars** est aujourd''hui la **fête nationale** tunisienne.

## 🚀 L''humanité conquiert l''espace (1969)

- Le **21 juillet 1969** (heure française), **Neil Armstrong** devient le premier homme à marcher sur la **Lune**, lors de la mission **Apollo 11**.
- Sa phrase reste célèbre : « *Un petit pas pour l''homme, un bond de géant pour l''humanité.* »
- L''exploit, suivi par environ **600 millions** de téléspectateurs, marque l''apogée de la **course à l''espace** entre États-Unis et URSS.

> 🏆 Première porte franchie, chrono-mage ! Tu tiens désormais les dates-clés de l''histoire mondiale et tunisienne. Au prochain niveau t''attendent les grandes figures et les civilisations — affûte ta mémoire, le combat continue.', '# 📜 Résumé : Les grandes dates de l''Histoire

- **476** : le chef germanique Odoacre dépose Romulus Augustule → chute de l''**Empire romain d''Occident** et fin de l''Antiquité.
- **1492** : **Christophe Colomb** atteint l''Amérique (Bahamas) → début des Grandes Découvertes et des Temps modernes.
- **14 juillet 1789** : **prise de la Bastille** → début de la **Révolution française** ; la Déclaration des droits de l''homme suit le 26 août.
- **1914-1918** : **Première Guerre mondiale**, terminée par l''**armistice du 11 novembre 1918** à Rethondes.
- **1939-1945** : **Seconde Guerre mondiale** ; capitulation allemande le **8 mai 1945**, japonaise le **2 septembre 1945** ; création de l''**ONU** en 1945.
- **20 mars 1956** : **indépendance de la Tunisie**, obtenue grâce à **Habib Bourguiba** et au Néo-Destour ; fête nationale tunisienne.
- **21 juillet 1969** : **Neil Armstrong** (Apollo 11) est le premier homme sur la **Lune**.
- **9 novembre 1989** : **chute du mur de Berlin** → symbole de la fin de la **guerre froide** et de la division Est-Ouest.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8168c46e-54c6-56f6-8196-3c7e78f67255', '5a94893c-cdbd-5e43-a0b0-e603b299d966', 'culture-generale-histoire-fr', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82794f6d-627c-5654-8ccb-8dc771b4294e', '8168c46e-54c6-56f6-8196-3c7e78f67255', 'Quel événement, survenu le 14 juillet 1789, marque le début symbolique de la Révolution française ?', '[{"id":"a","text":"Le sacre de Napoléon Ier"},{"id":"b","text":"La prise de la Bastille"},{"id":"c","text":"La bataille de Waterloo"},{"id":"d","text":"La proclamation de la République"}]'::jsonb, 'b', 'Le 14 juillet 1789, le peuple parisien prend d''assaut la Bastille, une prison-forteresse symbole de l''absolutisme royal : c''est le début symbolique de la Révolution française. Cette date est devenue la fête nationale française en 1880. Le sacre de Napoléon (a) date de 1804 et Waterloo (c) de 1815 ; la Ire République (d) ne sera proclamée qu''en 1792.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38a0c33e-a18a-595d-a509-d1ccb94df29f', '8168c46e-54c6-56f6-8196-3c7e78f67255', 'En quelle année Christophe Colomb a-t-il atteint le continent américain ?', '[{"id":"a","text":"1452"},{"id":"b","text":"1789"},{"id":"c","text":"1492"},{"id":"d","text":"1519"}]'::jsonb, 'c', 'Le 12 octobre 1492, Christophe Colomb aborde une île des Bahamas en cherchant la route des Indes par l''ouest, ouvrant l''ère des Grandes Découvertes. Il croira jusqu''à sa mort avoir atteint l''Asie. L''année 1519 (d) est celle du début de l''expédition de Magellan ; 1452 (a) est plutôt la date de naissance de Léonard de Vinci.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58bdb6bb-10aa-5846-a27d-b8cf4b48b945', '8168c46e-54c6-56f6-8196-3c7e78f67255', 'La chute de quel mur, le 9 novembre 1989, symbolise la fin de la guerre froide ?', '[{"id":"a","text":"Le mur d''Hadrien"},{"id":"b","text":"La Grande Muraille de Chine"},{"id":"c","text":"Le mur de Berlin"},{"id":"d","text":"Le mur des Lamentations"}]'::jsonb, 'c', 'Le 9 novembre 1989, le mur de Berlin, qui séparait depuis 1961 l''Allemagne de l''Est communiste de l''Ouest, est ouvert : c''est le symbole de la fin de la guerre froide et de la division Est-Ouest. Le mur d''Hadrien (a) est une fortification romaine en Bretagne, la Grande Muraille (b) protégeait la Chine, et le mur des Lamentations (d) est un lieu sacré à Jérusalem.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38189285-fb89-5c9f-9c8d-b0e286a42340', '8168c46e-54c6-56f6-8196-3c7e78f67255', 'Quel pays a accédé à son indépendance le 20 mars 1956, date devenue sa fête nationale ?', '[{"id":"a","text":"Le Maroc"},{"id":"b","text":"L''Algérie"},{"id":"c","text":"La Libye"},{"id":"d","text":"La Tunisie"}]'::jsonb, 'd', 'Le 20 mars 1956, la France reconnaît l''indépendance de la Tunisie et abroge le traité du Bardo de 1881. Habib Bourguiba, leader du Néo-Destour, en est l''artisan principal. Le Maroc (a) est devenu indépendant quelques semaines plus tôt en 1956, l''Algérie (b) en 1962, et la Libye (c) dès 1951.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da2a9a90-7d57-5560-8076-74d17209986e', '8168c46e-54c6-56f6-8196-3c7e78f67255', 'Qui fut le premier être humain à marcher sur la Lune, en 1969 ?', '[{"id":"a","text":"Neil Armstrong"},{"id":"b","text":"Iouri Gagarine"},{"id":"c","text":"Buzz Aldrin"},{"id":"d","text":"Michael Collins"}]'::jsonb, 'a', 'Le 21 juillet 1969 (heure française), Neil Armstrong, commandant d''Apollo 11, devient le premier homme à poser le pied sur la Lune. Buzz Aldrin (c) l''a rejoint quelques minutes plus tard ; Michael Collins (d) restait en orbite dans le module de commande. Iouri Gagarine (b), lui, fut le premier homme dans l''espace en 1961, mais il n''est jamais allé sur la Lune.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('842d0b7d-9808-571c-bb22-020522a5411c', '5a94893c-cdbd-5e43-a0b0-e603b299d966', 'culture-generale-histoire-fr', '⭐ Quiz : Histoire', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4215d5d-75c9-53e1-b793-62e671c118e3', '842d0b7d-9808-571c-bb22-020522a5411c', 'En quelle année a eu lieu la prise de la Bastille ?', '[{"id":"a","text":"1789"},{"id":"b","text":"1799"},{"id":"c","text":"1689"},{"id":"d","text":"1804"}]'::jsonb, 'a', 'La prise de la Bastille a eu lieu le 14 juillet 1789, point de départ symbolique de la Révolution française. À retenir : ce jour est devenu la fête nationale française. 1799 (b) est l''année du coup d''État de Napoléon, et 1804 (d) celle de son sacre comme empereur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44140f34-bb84-5e72-b22b-282fb51862c1', '842d0b7d-9808-571c-bb22-020522a5411c', 'Quel navigateur, parti pour l''Espagne, a atteint l''Amérique en 1492 ?', '[{"id":"a","text":"Vasco de Gama"},{"id":"b","text":"Fernand de Magellan"},{"id":"c","text":"Christophe Colomb"},{"id":"d","text":"Marco Polo"}]'::jsonb, 'c', 'Christophe Colomb, au service de l''Espagne, atteint l''Amérique en 1492 en cherchant la route des Indes par l''ouest. Vasco de Gama (a) a contourné l''Afrique pour atteindre l''Inde en 1498 ; Magellan (b) a lancé le premier tour du monde en 1519 ; Marco Polo (d) était un voyageur du XIIIe siècle vers la Chine.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0ac0428-a87b-5e57-b73f-4bad6ad8dbfa', '842d0b7d-9808-571c-bb22-020522a5411c', 'À quel pays correspond la fête de l''indépendance du 20 mars 1956 ?', '[{"id":"a","text":"L''Égypte"},{"id":"b","text":"La Tunisie"},{"id":"c","text":"Le Sénégal"},{"id":"d","text":"La Libye"}]'::jsonb, 'b', 'La Tunisie a obtenu son indépendance de la France le 20 mars 1956, date de sa fête nationale. C''est Habib Bourguiba qui en fut la figure de proue. La Libye (d) était indépendante depuis 1951, le Sénégal (c) le deviendra en 1960, et l''Égypte (a) avait un statut distinct dès la première moitié du XXe siècle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9ba5972-0206-58cf-9073-416aac0b7e6b', '842d0b7d-9808-571c-bb22-020522a5411c', 'Quelle mission spatiale a permis aux premiers hommes de marcher sur la Lune en 1969 ?', '[{"id":"a","text":"Spoutnik 1"},{"id":"b","text":"Vostok 1"},{"id":"c","text":"Apollo 11"},{"id":"d","text":"Apollo 13"}]'::jsonb, 'c', 'C''est la mission américaine Apollo 11 qui a posé les premiers hommes sur la Lune en juillet 1969, avec Neil Armstrong et Buzz Aldrin. Spoutnik 1 (a) fut le premier satellite (1957) et Vostok 1 (b) le premier vol habité (Gagarine, 1961). Apollo 13 (d) est la mission de 1970 qui faillit tourner au drame.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4f91762-89ce-5895-b5f7-28e382218875', '842d0b7d-9808-571c-bb22-020522a5411c', 'La chute du mur de Berlin en 1989 marque la fin de quelle période de tensions ?', '[{"id":"a","text":"La guerre froide"},{"id":"b","text":"La Première Guerre mondiale"},{"id":"c","text":"La guerre de Cent Ans"},{"id":"d","text":"Les guerres napoléoniennes"}]'::jsonb, 'a', 'La chute du mur de Berlin (1989) symbolise la fin de la guerre froide, l''affrontement idéologique entre le bloc occidental et le bloc soviétique après 1945. La Première Guerre mondiale (b) s''est achevée en 1918, la guerre de Cent Ans (c) au XVe siècle, et les guerres napoléoniennes (d) en 1815.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4cca85a6-7dce-5944-b9e9-eda532f7f278', '842d0b7d-9808-571c-bb22-020522a5411c', 'En quelle année s''est terminée la Seconde Guerre mondiale ?', '[{"id":"a","text":"1918"},{"id":"b","text":"1939"},{"id":"c","text":"1950"},{"id":"d","text":"1945"}]'::jsonb, 'd', 'La Seconde Guerre mondiale s''est terminée en 1945 : capitulation allemande le 8 mai, puis japonaise le 2 septembre. À retenir : l''ONU est créée la même année pour préserver la paix. 1918 (a) est la fin de la Première Guerre mondiale, et 1939 (b) le début de la Seconde.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ef80bd13-7862-50f7-a0e8-76a72f104e3c', '5a94893c-cdbd-5e43-a0b0-e603b299d966', 'culture-generale-histoire-fr', '⚔️ Boss ⭐⭐⭐ : Histoire', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82bbf15e-9d4e-5d8f-ba0a-b64f3ee3ba3d', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', 'Quelle date marque conventionnellement le début de la Première Guerre mondiale ?', '[{"id":"a","text":"1914"},{"id":"b","text":"1918"},{"id":"c","text":"1939"},{"id":"d","text":"1871"}]'::jsonb, 'a', 'La Première Guerre mondiale débute en 1914 et s''achève en 1918. Elle est déclenchée après l''assassinat de l''archiduc François-Ferdinand à Sarajevo. 1918 (b) en est la fin, 1939 (c) le début de la Seconde Guerre mondiale, et 1871 (d) l''année de l''unification allemande.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afbb4cd9-3ff5-5fc2-888b-f144f6950456', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', 'Quel chef du Néo-Destour a négocié l''indépendance de la Tunisie et est devenu son premier président ?', '[{"id":"a","text":"Gamal Abdel Nasser"},{"id":"b","text":"Tahar Ben Ammar"},{"id":"c","text":"Farhat Hached"},{"id":"d","text":"Habib Bourguiba"}]'::jsonb, 'd', 'Habib Bourguiba, fondateur du Néo-Destour, mena le combat pour l''indépendance obtenue le 20 mars 1956 et devint le premier président de la République tunisienne en 1957. Tahar Ben Ammar (b) était le chef du gouvernement signataire, mais pas le leader du mouvement. Farhat Hached (c) était un syndicaliste assassiné en 1952. Nasser (a) dirigeait l''Égypte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eca06e7f-53c5-53b6-978a-19a97d31289f', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', 'Quel chef germanique dépose le dernier empereur romain d''Occident en 476 ?', '[{"id":"a","text":"Attila"},{"id":"b","text":"Clovis"},{"id":"c","text":"Odoacre"},{"id":"d","text":"Charlemagne"}]'::jsonb, 'c', 'En 476, le chef germanique Odoacre dépose Romulus Augustule, marquant la fin de l''Empire romain d''Occident et de l''Antiquité. Attila (a), roi des Huns, était mort dès 453. Clovis (b), roi des Francs, et Charlemagne (d), couronné empereur en l''an 800, sont des figures postérieures du Moyen Âge.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('348b6eb4-65d5-55d1-bc35-e996e85df3a7', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', 'Dans quel lieu fut signé l''armistice du 11 novembre 1918, mettant fin aux combats de la Première Guerre mondiale ?', '[{"id":"a","text":"Dans la galerie des Glaces à Versailles"},{"id":"b","text":"Dans un wagon, à Rethondes (forêt de Compiègne)"},{"id":"c","text":"Au palais de Yalta"},{"id":"d","text":"À Reims, dans une école"}]'::jsonb, 'b', 'L''armistice du 11 novembre 1918 est signé dans un wagon-restaurant, dans la clairière de Rethondes (forêt de Compiègne). Le traité de Versailles (a), lui, sera signé en 1919. Yalta (c) est la conférence de 1945 entre Alliés, et Reims (d) est le lieu de la première capitulation allemande de 1945 — un piège chronologique courant.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3d0d2af-72bf-5dd4-804a-96098c25da93', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', 'Quel texte fondamental, adopté le 26 août 1789, proclame que « les hommes naissent et demeurent libres et égaux en droits » ?', '[{"id":"a","text":"Le Code civil"},{"id":"b","text":"La Déclaration des droits de l''homme et du citoyen"},{"id":"c","text":"La Charte des Nations unies"},{"id":"d","text":"L''édit de Nantes"}]'::jsonb, 'b', 'La Déclaration des droits de l''homme et du citoyen, adoptée le 26 août 1789, énonce ce principe fondateur ; elle reste un texte de référence des droits humains. Le Code civil (a) date de 1804 (Napoléon), la Charte des Nations unies (c) de 1945, et l''édit de Nantes (d) de 1598 (tolérance religieuse) — autant de textes d''époques différentes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3bbd837b-9412-5b86-9750-49fb0cafdd5d', 'ef80bd13-7862-50f7-a0e8-76a72f104e3c', 'La Seconde Guerre mondiale s''achève à des dates différentes en Europe et en Asie. Quelle correspondance est exacte ?', '[{"id":"a","text":"Europe : 2 septembre 1945 ; Japon : 8 mai 1945"},{"id":"b","text":"Europe : 8 mai 1945 ; Japon : 2 septembre 1945"},{"id":"c","text":"Europe : 11 novembre 1945 ; Japon : 8 mai 1945"},{"id":"d","text":"Europe : 8 mai 1939 ; Japon : 2 septembre 1939"}]'::jsonb, 'b', 'La capitulation allemande est signée le 8 mai 1945 (fin de la guerre en Europe), tandis que la capitulation japonaise, après Hiroshima et Nagasaki, intervient le 2 septembre 1945 (fin mondiale du conflit). Le piège courant (a) consiste à inverser les deux dates. Le 11 novembre (c) renvoie à 1918, et 1939 (d) est l''année du déclenchement, non de la fin.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('371ff1e1-2d2a-5bd8-a1e5-95b460709670', '5a94893c-cdbd-5e43-a0b0-e603b299d966', 'culture-generale-histoire-fr', '⭐⭐ Révision : Histoire', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('390eec7c-574b-57a2-897c-e92594613a6a', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'La chute de l''Empire romain d''Occident en 476 marque traditionnellement la fin de quelle période historique ?', '[{"id":"a","text":"La Préhistoire"},{"id":"b","text":"L''Antiquité"},{"id":"c","text":"Les Temps modernes"},{"id":"d","text":"La Renaissance"}]'::jsonb, 'b', 'La chute de Rome en 476 marque la fin de l''Antiquité et le début du Moyen Âge. À retenir : les historiens découpent traditionnellement l''histoire en Préhistoire, Antiquité, Moyen Âge, Temps modernes puis époque contemporaine. La Renaissance (d) et les Temps modernes (c) ne commencent qu''au XVe-XVIe siècle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbf265ed-4dec-5149-b1b0-b0578009e9f8', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'Quel événement de 1492 est souvent retenu comme le début des Temps modernes ?', '[{"id":"a","text":"La prise de la Bastille"},{"id":"b","text":"La chute de Constantinople"},{"id":"c","text":"L''arrivée de Christophe Colomb en Amérique"},{"id":"d","text":"Le couronnement de Charlemagne"}]'::jsonb, 'c', 'L''arrivée de Colomb en Amérique en 1492 ouvre l''ère des Grandes Découvertes et sert souvent de borne au début des Temps modernes. La chute de Constantinople (b) date de 1453 (autre borne possible), la prise de la Bastille (a) de 1789, et le couronnement de Charlemagne (d) de l''an 800.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4869b07b-c732-53ad-a9ef-42e0d62ebb0e', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'Quel traité de 1881 avait instauré le protectorat français sur la Tunisie, aboli lors de l''indépendance de 1956 ?', '[{"id":"a","text":"Le traité de Versailles"},{"id":"b","text":"Le traité du Bardo"},{"id":"c","text":"Le traité de Tordesillas"},{"id":"d","text":"Le traité de Rome"}]'::jsonb, 'b', 'Le traité du Bardo, signé en 1881, avait instauré le protectorat français sur la Tunisie ; il fut abrogé lors de l''indépendance du 20 mars 1956. Le traité de Versailles (a) clôt la Première Guerre mondiale (1919), Tordesillas (c) partageait le Nouveau Monde entre Espagne et Portugal (1494), et le traité de Rome (d) fonde la CEE (1957).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db5bd79b-64b3-5112-b36d-92aca5180f3e', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'Quelle phrase célèbre Neil Armstrong a-t-il prononcée en posant le pied sur la Lune ?', '[{"id":"a","text":"« Houston, nous avons un problème. »"},{"id":"b","text":"« Un petit pas pour l''homme, un bond de géant pour l''humanité. »"},{"id":"c","text":"« La Terre est bleue. »"},{"id":"d","text":"« Veni, vidi, vici. »"}]'::jsonb, 'b', 'En 1969, Armstrong prononce « Un petit pas pour l''homme, un bond de géant pour l''humanité ». La phrase (a) est associée à la mission Apollo 13 (1970) ; « La Terre est bleue » (c) est attribuée à Gagarine en 1961 ; « Veni, vidi, vici » (d) est une formule de Jules César, sans rapport avec l''espace.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5a6401a-47a1-5ad2-aaab-084b3f561c2f', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'Le mur de Berlin séparait deux entités politiques. Lesquelles ?', '[{"id":"a","text":"L''Allemagne et la France"},{"id":"b","text":"La Pologne et l''Allemagne"},{"id":"c","text":"L''Allemagne de l''Est et l''Allemagne de l''Ouest"},{"id":"d","text":"L''URSS et les États-Unis"}]'::jsonb, 'c', 'Construit en 1961, le mur de Berlin séparait l''Allemagne de l''Est communiste (RDA) de l''Allemagne de l''Ouest (RFA), au cœur de la guerre froide. Sa chute en 1989 ouvrira la voie à la réunification allemande de 1990. Il ne marquait pas une frontière entre pays distincts comme la France (a) ou la Pologne (b).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2586c39-f86d-5c20-9470-6bfb08067d4b', '371ff1e1-2d2a-5bd8-a1e5-95b460709670', 'Quelle organisation internationale est fondée en 1945 pour préserver la paix après la Seconde Guerre mondiale ?', '[{"id":"a","text":"L''Organisation des Nations unies (ONU)"},{"id":"b","text":"La Société des Nations (SDN)"},{"id":"c","text":"L''Union européenne"},{"id":"d","text":"L''OTAN"}]'::jsonb, 'a', 'L''ONU est créée en 1945, au lendemain de la Seconde Guerre mondiale, pour maintenir la paix et la sécurité internationales. La SDN (b) l''avait précédée après 1918 mais échoua à empêcher la guerre. L''OTAN (d) est une alliance militaire fondée en 1949, et l''Union européenne (c) sous sa forme actuelle date de 1992.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ea29cfd1-6b66-5e74-98e7-ef18284f6632', '5a94893c-cdbd-5e43-a0b0-e603b299d966', 'culture-generale-histoire-fr', '👑 Défi élite ⭐⭐⭐⭐ : Histoire', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80b74c04-108b-5402-b149-7fe7187d56d3', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632', 'En quelle année la prise de Constantinople par les Ottomans met-elle fin à l''Empire byzantin (romain d''Orient) ?', '[{"id":"a","text":"476"},{"id":"b","text":"1453"},{"id":"c","text":"1492"},{"id":"d","text":"1204"}]'::jsonb, 'b', 'Constantinople tombe le 29 mai 1453 face au sultan Mehmed II, mettant fin à l''Empire byzantin, héritier de Rome en Orient pendant près de mille ans. Le piège courant est de confondre avec 476 (a), qui concerne l''Empire d''Occident. 1204 (d) est le sac de la ville par les croisés (occupation temporaire), et 1492 (c) l''arrivée de Colomb en Amérique.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e109e85-d35f-5319-a0d2-1599926ac54a', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632', 'Quel syndicaliste tunisien, fondateur de l''UGTT et figure de la lutte indépendantiste, fut assassiné le 5 décembre 1952 ?', '[{"id":"a","text":"Tahar Ben Ammar"},{"id":"b","text":"Salah Ben Youssef"},{"id":"c","text":"Farhat Hached"},{"id":"d","text":"Mongi Slim"}]'::jsonb, 'c', 'Farhat Hached, fondateur de l''UGTT en 1946 et compagnon de lutte du Néo-Destour, fut assassiné le 5 décembre 1952, devenant un martyr de l''indépendance. Salah Ben Youssef (b) fut un rival de Bourguiba ; Tahar Ben Ammar (a) signa l''accord d''indépendance comme chef du gouvernement ; Mongi Slim (d) fut un diplomate destourien.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f758851b-31b2-5465-9887-ebfd4ac65cca', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632', 'Le 14 juillet 1789 a été choisi comme fête nationale française. Mais en quelle année cette décision a-t-elle été officiellement prise ?', '[{"id":"a","text":"1789"},{"id":"b","text":"1804"},{"id":"c","text":"1880"},{"id":"d","text":"1918"}]'::jsonb, 'c', 'C''est en 1880, sous la IIIe République, que le 14 juillet est institué fête nationale française, en référence à la prise de la Bastille de 1789. Le piège est de répondre 1789 (a), l''année de l''événement lui-même, et non celle de son institution comme fête. 1804 (b) est le sacre de Napoléon et 1918 (d) la fin de la Première Guerre mondiale.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9a77033-7de8-54fe-9f7b-f873f57e0bc4', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632', 'La première capitulation allemande de la Seconde Guerre mondiale, le 7 mai 1945, est suivie d''une seconde signature à la demande de Staline. Dans quelle ville eut lieu cette première signature ?', '[{"id":"a","text":"Berlin"},{"id":"b","text":"Reims"},{"id":"c","text":"Yalta"},{"id":"d","text":"Potsdam"}]'::jsonb, 'b', 'La capitulation allemande est d''abord signée à Reims le 7 mai 1945, au quartier général d''Eisenhower ; Staline exige une seconde signature à Berlin (Karlshorst) dans la nuit du 8 au 9 mai, d''où la célébration du 8 mai. Yalta (c) et Potsdam (d) sont des conférences interalliées de 1945, non des lieux de capitulation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9341589-c15f-5da3-9e8d-84a3a5e5edae', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632', 'Quel astronaute d''Apollo 11 n''a PAS marché sur la Lune, étant resté en orbite dans le module de commande ?', '[{"id":"a","text":"Neil Armstrong"},{"id":"b","text":"Iouri Gagarine"},{"id":"c","text":"Buzz Aldrin"},{"id":"d","text":"Michael Collins"}]'::jsonb, 'd', 'Michael Collins est resté seul en orbite lunaire à bord du module de commande Columbia pendant qu''Armstrong et Aldrin descendaient sur la Lune en 1969. Le piège est de citer Gagarine (b), qui n''a jamais participé à Apollo 11 : il fut le premier homme dans l''espace (URSS, 1961). Armstrong (a) et Aldrin (c), eux, ont bien foulé le sol lunaire.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db57349e-8585-521c-865e-66ffa044b02e', 'ea29cfd1-6b66-5e74-98e7-ef18284f6632', 'Classez ces quatre événements du plus ancien au plus récent : chute de Rome, chute de Constantinople, prise de la Bastille, chute du mur de Berlin.', '[{"id":"a","text":"Chute de Rome, chute de Constantinople, prise de la Bastille, chute du mur de Berlin"},{"id":"b","text":"Chute de Constantinople, chute de Rome, prise de la Bastille, chute du mur de Berlin"},{"id":"c","text":"Chute de Rome, prise de la Bastille, chute de Constantinople, chute du mur de Berlin"},{"id":"d","text":"Prise de la Bastille, chute de Rome, chute de Constantinople, chute du mur de Berlin"}]'::jsonb, 'a', 'L''ordre chronologique est : chute de Rome (476), chute de Constantinople (1453), prise de la Bastille (1789), chute du mur de Berlin (1989). Le piège courant est d''inverser les deux chutes d''empire (b) : Rome d''Occident tombe presque mille ans avant Constantinople. Les options (c) et (d) déplacent la Bastille hors de sa place chronologique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

