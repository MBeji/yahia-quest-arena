-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-dungeon-fr (Culture générale — Donjon multi-thèmes (FR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-dungeon-fr/
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
  ('culture-generale-dungeon-fr', 'Culture générale — Donjon multi-thèmes (FR)', 'Donjon de culture générale où chaque question vient d''un domaine différent (histoire, géographie, politique, économie, sciences, arts) : un gantelet de connaissances variées en français.', 'Polyvalence', 'subject-math', 'Swords', 22, 'fr', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-dungeon-fr'
      AND e.source = 'admin'
      AND q.id NOT IN ('11681a72-b8e7-5781-a4ce-cce31f365c64', 'ae642d4a-b261-58e5-a3d7-7120e7ef350f', 'da9327a9-ec55-51cc-af68-edc5d387f04c', 'ab1aa4b4-2e82-55a1-8c12-e8c0068fef1d', 'c71e48c0-ac6c-508b-8859-9f00279bc479', 'fdd0fd50-54d9-50b3-9fe3-c9c756fa87ca', 'e9db137b-13dc-53ac-bcc7-984ad64bc9ee', '0fb9f3cd-5f9f-5846-97d6-9525ab5fc281', 'a5a906c9-5300-59fc-af25-c3756d7282e2', '3432ccce-c85b-5513-9566-b27855c59572', '0d832656-777f-5125-8f6f-81b0e68dce8d', 'b90a9b64-4aaf-5521-9471-21608c840b7f', 'd22d6ada-5210-55f4-938f-d3869299f531', '79ddfeec-bbde-5481-8263-506b7254e190', 'd3065ffd-2d52-5a5e-bce9-721cad59939d', '8c63902e-82cc-581b-b05f-e160ced33013', '906155e6-90df-5b8a-8b70-f5d595cd83ca');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-dungeon-fr' AND source = 'admin' AND id NOT IN ('2dc329fa-e48c-5123-999e-52f52e3bbdeb', '66008c28-87eb-5b27-a171-98d7681c47d7', '12929993-dfd5-59bf-880e-41b172b37cd5');
DELETE FROM public.questions WHERE exercise_id IN ('2dc329fa-e48c-5123-999e-52f52e3bbdeb', '66008c28-87eb-5b27-a171-98d7681c47d7', '12929993-dfd5-59bf-880e-41b172b37cd5') AND id NOT IN ('11681a72-b8e7-5781-a4ce-cce31f365c64', 'ae642d4a-b261-58e5-a3d7-7120e7ef350f', 'da9327a9-ec55-51cc-af68-edc5d387f04c', 'ab1aa4b4-2e82-55a1-8c12-e8c0068fef1d', 'c71e48c0-ac6c-508b-8859-9f00279bc479', 'fdd0fd50-54d9-50b3-9fe3-c9c756fa87ca', 'e9db137b-13dc-53ac-bcc7-984ad64bc9ee', '0fb9f3cd-5f9f-5846-97d6-9525ab5fc281', 'a5a906c9-5300-59fc-af25-c3756d7282e2', '3432ccce-c85b-5513-9566-b27855c59572', '0d832656-777f-5125-8f6f-81b0e68dce8d', 'b90a9b64-4aaf-5521-9471-21608c840b7f', 'd22d6ada-5210-55f4-938f-d3869299f531', '79ddfeec-bbde-5481-8263-506b7254e190', 'd3065ffd-2d52-5a5e-bce9-721cad59939d', '8c63902e-82cc-581b-b05f-e160ced33013', '906155e6-90df-5b8a-8b70-f5d595cd83ca');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-dungeon-fr' AND c.id NOT IN ('32742fd3-4c6a-52da-8bc7-65a79971bf6b') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('32742fd3-4c6a-52da-8bc7-65a79971bf6b', 'culture-generale-dungeon-fr', 'Donjon multi-thèmes', 'Un gantelet de culture générale : chaque question surgit d''un domaine différent — histoire, géographie, politique, économie, sciences, arts. Échauffe-toi, affronte le Boss, puis défie l''Élite.', '# ⚔️ Le Donjon Multi-Thèmes — un gantelet de culture générale

> 💡 « Le héros le plus dangereux n''est pas celui qui frappe le plus fort, mais celui qui sait un peu de tout. »

Bienvenue, aventurier. Ici, pas de chapitre tranquille sur un seul sujet : ce donjon est un **gantelet de connaissances variées**. À chaque salle, une porte différente s''ouvre — **histoire**, **géographie**, **politique**, **économie**, **sciences** ou **arts** — et tu ne sais jamais laquelle. Ta seule arme : une culture générale large et solide.

## 🏰 La règle du donjon

Chaque combat enchaîne des questions venues de **domaines différents**. Tu peux passer d''une date de révolution à une capitale, d''un symbole chimique à un tableau célèbre, sans transition. C''est exactement ce qui fait la valeur d''une vraie culture générale : être **polyvalent**, prêt à tout.

## ⚡ Les six portes (les domaines)

| Porte | Domaine | Exemple de défi |
|---|---|---|
| 🛡️ | Histoire | dates, événements, personnages |
| 🗺️ | Géographie | capitales, fleuves, sommets |
| 🏛️ | Politique | institutions, organisations, régimes |
| 💰 | Économie | PIB, inflation, accords majeurs |
| 🔬 | Sciences | physique, chimie, astronomie |
| 🎨 | Arts | peinture, musique, littérature |

## 🔮 Le parcours de l''aventurier

1. **Échauffement** ⭐ — un quiz de 5 questions faciles pour ouvrir le donjon (il faut **≥ 80 %** pour débloquer la suite).
2. **Boss** ⭐⭐⭐ — 6 questions, **une par domaine**, difficulté croissante (1 → 3).
3. **Élite** ⭐⭐⭐⭐ — 6 questions ardues, mélangées, pour les vrais maîtres.

> 🗡️ **Astuce de héros** : devant un piège, élimine d''abord les options absurdes, puis traque le **faux-ami** — le pays voisin, l''année décalée d''un cran, le chiffre presque juste.

> ⚠️ **Piège classique** : confondre une grande ville célèbre avec une capitale (Sydney n''est *pas* la capitale de l''Australie). La notoriété n''est pas l''autorité.

## 🧪 Pourquoi t''entraîner ici

Chaque correction est une **mini-leçon** : tu repars toujours avec la bonne réponse, le *pourquoi*, et un ou deux faits bonus pour grandir. Même une erreur te rend plus cultivé qu''avant ton entrée dans la salle.

## 📜 L''état d''esprit

- Reste **calme** : un domaine inconnu se devine souvent par logique.
- Reste **curieux** : note ce que tu rates, c''est ton butin de la prochaine run.
- Reste **rapide mais sûr** : le donjon récompense la précision, pas la précipitation.

> 🏆 Tu connais désormais les règles du donjon. Franchis l''échauffement, terrasse le Boss, puis ose le défi de l''Élite — et prouve que ta culture générale n''a pas de point faible.', '# 📜 Résumé : Donjon multi-thèmes

- **But** : un gantelet de culture générale où chaque question vient d''un domaine différent.
- **Six domaines** : histoire, géographie, politique, économie, sciences, arts.
- **Parcours** : Échauffement (quiz ⭐, ≥ 80 % pour débloquer) → Boss ⭐⭐⭐ (1 question par domaine) → Élite ⭐⭐⭐⭐ (6 questions ardues mélangées).
- **Méthode** : éliminer les options absurdes, puis repérer le faux-ami (pays voisin, année décalée, chiffre presque juste).
- **Piège fréquent** : confondre une ville célèbre avec une capitale (ex. Sydney ≠ capitale de l''Australie).
- **Esprit** : calme, curieux, précis — chaque correction est une mini-leçon qui te rend plus cultivé.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2dc329fa-e48c-5123-999e-52f52e3bbdeb', '32742fd3-4c6a-52da-8bc7-65a79971bf6b', 'culture-generale-dungeon-fr', 'Échauffement du donjon ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('11681a72-b8e7-5781-a4ce-cce31f365c64', '2dc329fa-e48c-5123-999e-52f52e3bbdeb', 'En quelle année a eu lieu la prise de la Bastille, événement fondateur de la Révolution française ?', '[{"id":"a","text":"1789"},{"id":"b","text":"1799"},{"id":"c","text":"1769"},{"id":"d","text":"1815"}]'::jsonb, 'a', 'La prise de la Bastille a eu lieu le 14 juillet 1789, marquant le début symbolique de la Révolution française. À savoir : le 14 juillet n''est devenu fête nationale qu''en 1880. L''année 1799 est celle du coup d''État de Bonaparte (fin de la Révolution), pas de son début.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae642d4a-b261-58e5-a3d7-7120e7ef350f', '2dc329fa-e48c-5123-999e-52f52e3bbdeb', 'Quel est le symbole chimique de l''or dans le tableau périodique ?', '[{"id":"a","text":"Ag"},{"id":"b","text":"Au"},{"id":"c","text":"Or"},{"id":"d","text":"Go"}]'::jsonb, 'b', 'Le symbole de l''or est Au, des deux premières lettres de son nom latin « aurum » ; son numéro atomique est 79. Le piège « Ag » est le symbole de l''argent (du latin « argentum ») : l''or et l''argent appartiennent au même groupe 11.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da9327a9-ec55-51cc-af68-edc5d387f04c', '2dc329fa-e48c-5123-999e-52f52e3bbdeb', 'Quelle est la capitale de l''Australie ?', '[{"id":"a","text":"Sydney"},{"id":"b","text":"Melbourne"},{"id":"c","text":"Canberra"},{"id":"d","text":"Perth"}]'::jsonb, 'c', 'La capitale de l''Australie est Canberra, choisie en 1908 comme compromis entre les rivales Sydney et Melbourne et bâtie de toutes pièces. Sydney et Melbourne sont les plus grandes villes, mais aucune n''est la capitale : la notoriété d''une ville ne fait pas d''elle un siège du gouvernement.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab1aa4b4-2e82-55a1-8c12-e8c0068fef1d', '2dc329fa-e48c-5123-999e-52f52e3bbdeb', 'Qui a peint La Joconde, exposée au musée du Louvre ?', '[{"id":"a","text":"Michel-Ange"},{"id":"b","text":"Raphaël"},{"id":"c","text":"Léonard de Vinci"},{"id":"d","text":"Botticelli"}]'::jsonb, 'c', 'La Joconde a été peinte par Léonard de Vinci au début du XVIe siècle, avec la célèbre technique du sfumato (contours fondus). Michel-Ange, contemporain et rival, était surtout sculpteur et fresquiste (plafond de la chapelle Sixtine) : il n''a pas peint ce portrait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c71e48c0-ac6c-508b-8859-9f00279bc479', '2dc329fa-e48c-5123-999e-52f52e3bbdeb', 'Que mesure le PIB (produit intérieur brut) d''un pays ?', '[{"id":"a","text":"La richesse produite sur le territoire pendant une période donnée"},{"id":"b","text":"Le nombre total d''habitants du pays"},{"id":"c","text":"La somme d''argent détenue par l''État"},{"id":"d","text":"La superficie totale du pays"}]'::jsonb, 'a', 'Le PIB mesure la valeur de tous les biens et services produits sur un territoire pendant une période (souvent un an) ; sa variation indique la croissance économique. Il ne compte ni la population ni le territoire : un grand pays peu productif peut avoir un PIB plus faible qu''un petit pays très productif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('66008c28-87eb-5b27-a171-98d7681c47d7', '32742fd3-4c6a-52da-8bc7-65a79971bf6b', 'culture-generale-dungeon-fr', '⚔️ Donjon — Boss ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 1)
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
  ('fdd0fd50-54d9-50b3-9fe3-c9c756fa87ca', '66008c28-87eb-5b27-a171-98d7681c47d7', 'Histoire — En quelle année est tombé le mur de Berlin, marquant la fin de la division de l''Allemagne ?', '[{"id":"a","text":"1989"},{"id":"b","text":"1991"},{"id":"c","text":"1985"},{"id":"d","text":"1961"}]'::jsonb, 'a', 'Le mur de Berlin est tombé dans la nuit du 9 novembre 1989, après 28 ans de séparation. À savoir : il avait été érigé en 1961 (le piège « 1961 » est sa construction, pas sa chute). 1991 est l''année de la dissolution de l''URSS, un événement distinct et postérieur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9db137b-13dc-53ac-bcc7-984ad64bc9ee', '66008c28-87eb-5b27-a171-98d7681c47d7', 'Géographie — Sur quel continent se trouve le désert du Sahara, le plus grand désert chaud du monde ?', '[{"id":"a","text":"Asie"},{"id":"b","text":"Afrique"},{"id":"c","text":"Amérique du Sud"},{"id":"d","text":"Océanie"}]'::jsonb, 'b', 'Le Sahara couvre une large bande du nord de l''Afrique, sur une dizaine de pays. C''est le plus grand désert chaud du monde (environ 9 millions de km²). Le piège « Asie » correspond au désert de Gobi : vaste lui aussi, mais c''est un désert froid, distinct du Sahara.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fb9f3cd-5f9f-5846-97d6-9525ab5fc281', '66008c28-87eb-5b27-a171-98d7681c47d7', 'Politique — Quel organe de l''ONU a la responsabilité principale du maintien de la paix et de la sécurité internationales ?', '[{"id":"a","text":"L''Assemblée générale"},{"id":"b","text":"La Cour internationale de justice"},{"id":"c","text":"Le Conseil de sécurité"},{"id":"d","text":"Le Secrétariat"}]'::jsonb, 'c', 'Le Conseil de sécurité est chargé du maintien de la paix ; ses cinq membres permanents (États-Unis, Russie, Chine, France, Royaume-Uni) disposent du droit de veto. L''Assemblée générale réunit les 193 États membres mais ses résolutions n''ont pas force contraignante : elle débat, le Conseil décide et peut imposer des sanctions.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5a906c9-5300-59fc-af25-c3756d7282e2', '66008c28-87eb-5b27-a171-98d7681c47d7', 'Économie — Que désigne le terme « inflation » en économie ?', '[{"id":"a","text":"Une hausse générale et durable des prix"},{"id":"b","text":"Une baisse générale des prix"},{"id":"c","text":"Une hausse du chômage"},{"id":"d","text":"Une augmentation des exportations"}]'::jsonb, 'a', 'L''inflation est la hausse générale et durable des prix, qui réduit le pouvoir d''achat de la monnaie. La Banque centrale européenne vise environ 2 % par an. Le piège « baisse des prix » a un nom propre : la déflation, phénomène inverse souvent jugé dangereux car il peut paralyser l''activité.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3432ccce-c85b-5513-9566-b27855c59572', '66008c28-87eb-5b27-a171-98d7681c47d7', 'Sciences — Quelle est, en ordre de grandeur, la vitesse de la lumière dans le vide ?', '[{"id":"a","text":"Environ 300 000 km/s"},{"id":"b","text":"Environ 300 000 km/h"},{"id":"c","text":"Environ 3 000 km/s"},{"id":"d","text":"Environ 30 000 000 km/s"}]'::jsonb, 'a', 'La lumière voyage à 299 792 458 m/s dans le vide, soit environ 300 000 km/s — une constante fondamentale qui sert même à définir le mètre depuis 1983. Le piège « km/h » se trompe d''unité : 300 000 km/h serait des centaines de milliers de fois trop lent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d832656-777f-5125-8f6f-81b0e68dce8d', '66008c28-87eb-5b27-a171-98d7681c47d7', 'Arts — De quel pays Wolfgang Amadeus Mozart, compositeur de « La Flûte enchantée », était-il originaire ?', '[{"id":"a","text":"Allemagne"},{"id":"b","text":"Italie"},{"id":"c","text":"Autriche"},{"id":"d","text":"France"}]'::jsonb, 'c', 'Mozart est né à Salzbourg en 1756, alors dans le Saint-Empire mais ville aujourd''hui autrichienne ; il est l''une des grandes figures de la musique classique viennoise. Le piège « Allemagne » vient de la langue allemande qu''il parlait : mais Salzbourg et Vienne, où il a fait carrière, sont en Autriche, pas en Allemagne.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('12929993-dfd5-59bf-880e-41b172b37cd5', '32742fd3-4c6a-52da-8bc7-65a79971bf6b', 'culture-generale-dungeon-fr', '👑 Donjon — Élite ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 2)
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
  ('b90a9b64-4aaf-5521-9471-21608c840b7f', '12929993-dfd5-59bf-880e-41b172b37cd5', 'Histoire — En 1215, les barons anglais imposent au roi Jean sans Terre un texte limitant son pouvoir, considéré comme une étape majeure vers l''État de droit. Quel est ce texte ?', '[{"id":"a","text":"La Magna Carta (Grande Charte)"},{"id":"b","text":"La Déclaration des droits de l''homme"},{"id":"c","text":"Le Bill of Rights anglais"},{"id":"d","text":"L''Habeas Corpus"}]'::jsonb, 'a', 'La Magna Carta, signée en 1215 à Runnymede, soumet le roi à la loi et garantit aux hommes libres un jugement régulier ; elle préfigure les libertés constitutionnelles. Les pièges sont plus tardifs : l''Habeas Corpus date de 1679 et le Bill of Rights anglais de 1689, tous deux postérieurs de plusieurs siècles.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d22d6ada-5210-55f4-938f-d3869299f531', '12929993-dfd5-59bf-880e-41b172b37cd5', 'Géographie — Quelle est l''altitude approximative du mont Everest, point culminant de la Terre par rapport au niveau de la mer ?', '[{"id":"a","text":"Environ 6 500 m"},{"id":"b","text":"Environ 7 200 m"},{"id":"c","text":"Environ 8 849 m"},{"id":"d","text":"Environ 9 600 m"}]'::jsonb, 'c', 'L''Everest, dans l''Himalaya, culmine à environ 8 849 m au-dessus du niveau de la mer (mesure sino-népalaise de 2020). À savoir : mesuré de sa base sous-marine, le Mauna Kea d''Hawaï serait plus « haut », mais le critère officiel reste l''altitude par rapport à la mer, ce qui consacre l''Everest.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79ddfeec-bbde-5481-8263-506b7254e190', '12929993-dfd5-59bf-880e-41b172b37cd5', 'Économie — Les accords de Bretton Woods, signés en 1944, ont donné naissance à deux grandes institutions économiques internationales. Lesquelles ?', '[{"id":"a","text":"L''OMC et l''OCDE"},{"id":"b","text":"Le FMI et la Banque mondiale"},{"id":"c","text":"La BCE et la Réserve fédérale"},{"id":"d","text":"L''OPEP et le G7"}]'::jsonb, 'b', 'Bretton Woods (1944) a créé le Fonds monétaire international (FMI) et la Banque mondiale, pour stabiliser les monnaies et financer la reconstruction d''après-guerre. Le piège « OMC » est plus récent (1995, issue du GATT) et ne traite pas de la monnaie mais du commerce : un autre rôle, une autre époque.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3065ffd-2d52-5a5e-bce9-721cad59939d', '12929993-dfd5-59bf-880e-41b172b37cd5', 'Sciences — Quelle est la planète la plus proche du Soleil dans le système solaire ?', '[{"id":"a","text":"Vénus"},{"id":"b","text":"Mars"},{"id":"c","text":"Mercure"},{"id":"d","text":"La Terre"}]'::jsonb, 'c', 'Mercure est la planète la plus proche du Soleil et la plus petite du système solaire. Curiosité : ce n''est pas la plus chaude — c''est Vénus, dont l''épaisse atmosphère de CO₂ piège la chaleur (effet de serre). Le piège « Vénus » confond la deuxième planète (la plus chaude) avec la première (la plus proche).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c63902e-82cc-581b-b05f-e160ced33013', '12929993-dfd5-59bf-880e-41b172b37cd5', 'Arts — Le tableau « Guernica », puissante œuvre contre la guerre inspirée d''un bombardement de 1937, est l''œuvre de quel peintre ?', '[{"id":"a","text":"Salvador Dalí"},{"id":"b","text":"Pablo Picasso"},{"id":"c","text":"Joan Miró"},{"id":"d","text":"Francisco Goya"}]'::jsonb, 'b', '« Guernica » a été peint par Pablo Picasso en 1937, en réaction au bombardement de la ville basque de Guernica pendant la guerre civile espagnole ; c''est une icône en gris et noir de l''art anti-guerre, exposée à Madrid. Le piège « Goya » est cohérent (autre Espagnol célèbre pour des scènes de guerre) mais il vivait au tournant du XIXe siècle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('906155e6-90df-5b8a-8b70-f5d595cd83ca', '12929993-dfd5-59bf-880e-41b172b37cd5', 'Politique — En quelle année l''Organisation des Nations unies (ONU) a-t-elle officiellement été créée ?', '[{"id":"a","text":"1919"},{"id":"b","text":"1948"},{"id":"c","text":"1945"},{"id":"d","text":"1950"}]'::jsonb, 'c', 'L''ONU a été créée le 24 octobre 1945, après la ratification de sa Charte par les 51 États fondateurs ; elle compte aujourd''hui 193 membres et siège à New York. Le piège « 1919 » est la Société des Nations (SDN), l''organisation qui a précédé l''ONU et qu''elle a remplacée après l''échec de cette dernière à empêcher la Seconde Guerre mondiale.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

