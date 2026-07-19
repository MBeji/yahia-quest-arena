-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-bac-math (Mathématiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-bac-math/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium, theme_id, grade_id, manuel_refs) VALUES
  ('math-bac-math', 'Mathématiques', 'Analyse, algèbre, géométrie et probabilités selon le programme officiel de la 4ème année secondaire — section Mathématiques (préparation au baccalauréat)', 'Force', 'subject-math', 'Calculator', 1, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = 'bac-math'), NULL)
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
  grade_id = EXCLUDED.grade_id,
  manuel_refs = EXCLUDED.manuel_refs;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'math-bac-math'
      AND e.source = 'admin'
      AND q.id NOT IN ('3af27c08-8da6-5667-ac15-1b0d4b924c04', '2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b74234c6-97b1-57c7-b21a-9698d89bddf7', '0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'd868bf9d-4d39-5d05-8c23-91e3dd50cbd4', '2bc732c3-ef84-593e-8141-28d56a59f5f7', 'aec4ec41-216a-51a3-b0a8-6a5820082cef', '1744bf0b-0591-5555-90c5-5a33930403c2', '4beea811-5dad-5080-a722-62a3185fc237', 'b9253cb3-c7fd-597d-9e5b-efdd4610721a', '0c9af287-fc69-5495-b1d8-05872e8f8300', 'a1682039-0438-5589-810c-7ce83d3f1190', '2adf3630-8ece-5043-a698-baa40822db13', 'cd689749-cc37-5719-9e5c-779dce1c6d54', '88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '45a47019-5722-586c-8211-35c6609f5eac', '95d862fa-6176-53ff-bd36-3a089be93947', '4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '0c567130-c4c9-5bbf-98af-48ac3fe35478', '55ae6f27-b3d2-53a0-95ac-3c1522b812bc', 'bc67fce0-14b0-512d-96fb-b200ad35fa3f', 'a85f9f3a-57c8-5528-b925-41cadd3ea008', 'e5f35d28-19b0-5807-adc2-cc42ca5e625e', 'bef7b52e-7113-5e25-b4c9-7943c27a365d', '0784b9f3-963c-5021-9ab6-bb87604c9d71', '5082a155-94a8-5525-b00f-b86ccd1cab10', '3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '28b2f193-675b-52ec-8354-09cf1e8a4a6b', '5f1d4834-8d38-5bfd-83f4-1428cc4074e4', 'a9ec4bb2-971b-548b-b872-47feb78de533', '746b0135-365a-5001-8259-05b772e9e1ea', 'ffdad216-1ab6-55cf-9736-9792be0fdf75', '1480bf16-37ba-5bcb-967d-c9869d882e43', '31a27502-0123-5cab-91c3-12dcc369cdf7', 'c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '2a65b201-ef6d-5532-b334-bef78c2e24f4', '34fd0348-7102-5b8a-8302-1b9577ab01e2', '7a149b92-97dd-545c-a583-5bf272b2eb7f', 'f010664a-2322-5b74-ab99-04ea17013ccc', '0d9998e1-142f-58b9-9112-2bf36321029f', '2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '269d83d5-c846-5358-a11b-055acb721037', '418ecd91-02f2-5e60-949a-4b77903ff934', '9808b350-e59e-5b03-8df4-156a48f6313b', '1782f429-e18c-5e6f-8bf9-0fc7f054cb33', '128b72a3-9efc-5a82-9e82-7eba9bc9714a', '99763050-35a1-58e9-bdcf-b2e5cd3f3758', '10aa7bb5-c507-5da1-9666-b91adb8659c0', 'ea4c5212-7b67-5a58-9a7f-71b75e69db95', '8546da9c-0e6b-5950-9526-0b12cce6ac68', '97623e2b-f10b-5039-b5ac-a86172bd88e0', 'd25630b2-2402-5128-a103-43c95667785d', 'ef6ec993-83ac-5801-879a-82ab207290a0', 'cf41176c-39cd-5a86-acc5-7e0ad7c94df0', '6bcb0d93-7ac2-5ec9-9a41-063c0e69c5b9', '46760fd6-24bc-52fe-9bdf-aa5717455bf0', '5ed925cd-39cb-5459-94a4-36938c17804a', '17562b38-3c5e-50c1-bc2e-00bd9a6bb458', '9bf02dbd-ada9-5b8d-a340-e03f6902f29f', 'f6bc57a6-7dc3-56b6-9e2d-ed9e80524af6', '435bbae0-33c6-5fd1-912d-f534ae3cea9b', '5dbc94fb-5eb4-59b3-94bd-ba9651935a15', '96f959d1-6966-5feb-9781-7f0471d9e541', '941385bd-aaa6-5762-9b93-53ac52b6fe07', '1eb40098-505d-5a4e-bec9-c66b09fa0cfc', '099aeffc-3a34-58bd-9d23-a60c91b03d3a', 'e727abd1-8cd9-512b-8e73-c3eefd006811', '0e27f1f0-dc12-5606-a172-09fdfd4a462b', '4d5e07ba-525b-5a10-82b0-9c6166bfc9a9', '74c3ec40-e067-5a72-9026-cf0d7f66cc0f', '99cfcded-1744-5715-871e-d75394677221', '302a50af-7846-5420-8aed-6603a00c9947', '1cd33640-ea7c-56b7-a64d-01dd5204857f', '6dfce643-a6d1-57de-98c0-85635b3743f0', '1eda069f-24cd-5685-9690-1b38f2fd0f12', '720e16da-50e8-5924-95e9-0636c87133a0', '94b62195-57c3-5211-bf2b-b3bd11ae1f72', '195d5ed9-6a31-5671-ad04-0d97cd1afeeb', '1e026ae9-bdf1-5c4e-9d0b-fa1275855b50', '672c8134-6a3c-506e-8054-7ec223e2c413', '429ab459-4f9e-5394-b422-d4e06eb0e7b1', '6287b25e-b3cb-52da-843f-f278bae9c79b', '8c47226b-aeec-59cb-9f93-2013b4e5614a', 'e4714c37-5a40-5ef0-8600-5c210fc50fba', '81d3364c-364e-539b-a857-246766040737', '7a6359a9-222e-5478-8313-2da6e2acba02', '1fdec408-994f-5be9-9d8c-523291f93f4d', 'a4affb62-f8b3-5a74-a0bb-2c0d327c1c0b', 'cfe93286-3639-57dc-9443-96656daf7242', 'bcb3fc62-67d2-511e-9f06-0ba9e7701963', 'a9f8cfef-df27-5bb0-8738-47e1f9f6f60e', '42198a34-97ee-5628-86f9-ebf61a3528eb', 'daff01b4-f5b1-508c-976d-418e201cd962', '980e0a9d-ef04-5450-9ea1-93fa3f59ccd4', '2af4e931-05f4-5dc8-a27f-1afe0a52a2f0', 'ff61ace5-cbb3-571c-986a-11ae60e9b3a2', 'fafed2cc-a992-515a-89b3-60de01ce8ba8', '91c9abe2-75cd-5c7b-af3b-99c3e329064a');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-bac-math' AND source = 'admin' AND id NOT IN ('b76771c5-32e7-5632-9794-9ec8095fa035', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', '75fc9ae9-900f-5c98-8207-baa94bff86af', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', '6f055244-7690-5d90-b279-8c0785ee7e44', '35d2cb52-661a-50a0-94d8-24590f6525d8', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'edb002de-0e7f-5b7c-8d12-039559657254', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', '658de6da-fd2c-57d3-9453-4648d9475e11', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'aed57cb5-b2b5-5152-9856-b44db7a10804', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9');
DELETE FROM public.questions WHERE exercise_id IN ('b76771c5-32e7-5632-9794-9ec8095fa035', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', '75fc9ae9-900f-5c98-8207-baa94bff86af', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', '6f055244-7690-5d90-b279-8c0785ee7e44', '35d2cb52-661a-50a0-94d8-24590f6525d8', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'edb002de-0e7f-5b7c-8d12-039559657254', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', '658de6da-fd2c-57d3-9453-4648d9475e11', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'aed57cb5-b2b5-5152-9856-b44db7a10804', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9') AND id NOT IN ('3af27c08-8da6-5667-ac15-1b0d4b924c04', '2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b74234c6-97b1-57c7-b21a-9698d89bddf7', '0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'd868bf9d-4d39-5d05-8c23-91e3dd50cbd4', '2bc732c3-ef84-593e-8141-28d56a59f5f7', 'aec4ec41-216a-51a3-b0a8-6a5820082cef', '1744bf0b-0591-5555-90c5-5a33930403c2', '4beea811-5dad-5080-a722-62a3185fc237', 'b9253cb3-c7fd-597d-9e5b-efdd4610721a', '0c9af287-fc69-5495-b1d8-05872e8f8300', 'a1682039-0438-5589-810c-7ce83d3f1190', '2adf3630-8ece-5043-a698-baa40822db13', 'cd689749-cc37-5719-9e5c-779dce1c6d54', '88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '45a47019-5722-586c-8211-35c6609f5eac', '95d862fa-6176-53ff-bd36-3a089be93947', '4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '0c567130-c4c9-5bbf-98af-48ac3fe35478', '55ae6f27-b3d2-53a0-95ac-3c1522b812bc', 'bc67fce0-14b0-512d-96fb-b200ad35fa3f', 'a85f9f3a-57c8-5528-b925-41cadd3ea008', 'e5f35d28-19b0-5807-adc2-cc42ca5e625e', 'bef7b52e-7113-5e25-b4c9-7943c27a365d', '0784b9f3-963c-5021-9ab6-bb87604c9d71', '5082a155-94a8-5525-b00f-b86ccd1cab10', '3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '28b2f193-675b-52ec-8354-09cf1e8a4a6b', '5f1d4834-8d38-5bfd-83f4-1428cc4074e4', 'a9ec4bb2-971b-548b-b872-47feb78de533', '746b0135-365a-5001-8259-05b772e9e1ea', 'ffdad216-1ab6-55cf-9736-9792be0fdf75', '1480bf16-37ba-5bcb-967d-c9869d882e43', '31a27502-0123-5cab-91c3-12dcc369cdf7', 'c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '2a65b201-ef6d-5532-b334-bef78c2e24f4', '34fd0348-7102-5b8a-8302-1b9577ab01e2', '7a149b92-97dd-545c-a583-5bf272b2eb7f', 'f010664a-2322-5b74-ab99-04ea17013ccc', '0d9998e1-142f-58b9-9112-2bf36321029f', '2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '269d83d5-c846-5358-a11b-055acb721037', '418ecd91-02f2-5e60-949a-4b77903ff934', '9808b350-e59e-5b03-8df4-156a48f6313b', '1782f429-e18c-5e6f-8bf9-0fc7f054cb33', '128b72a3-9efc-5a82-9e82-7eba9bc9714a', '99763050-35a1-58e9-bdcf-b2e5cd3f3758', '10aa7bb5-c507-5da1-9666-b91adb8659c0', 'ea4c5212-7b67-5a58-9a7f-71b75e69db95', '8546da9c-0e6b-5950-9526-0b12cce6ac68', '97623e2b-f10b-5039-b5ac-a86172bd88e0', 'd25630b2-2402-5128-a103-43c95667785d', 'ef6ec993-83ac-5801-879a-82ab207290a0', 'cf41176c-39cd-5a86-acc5-7e0ad7c94df0', '6bcb0d93-7ac2-5ec9-9a41-063c0e69c5b9', '46760fd6-24bc-52fe-9bdf-aa5717455bf0', '5ed925cd-39cb-5459-94a4-36938c17804a', '17562b38-3c5e-50c1-bc2e-00bd9a6bb458', '9bf02dbd-ada9-5b8d-a340-e03f6902f29f', 'f6bc57a6-7dc3-56b6-9e2d-ed9e80524af6', '435bbae0-33c6-5fd1-912d-f534ae3cea9b', '5dbc94fb-5eb4-59b3-94bd-ba9651935a15', '96f959d1-6966-5feb-9781-7f0471d9e541', '941385bd-aaa6-5762-9b93-53ac52b6fe07', '1eb40098-505d-5a4e-bec9-c66b09fa0cfc', '099aeffc-3a34-58bd-9d23-a60c91b03d3a', 'e727abd1-8cd9-512b-8e73-c3eefd006811', '0e27f1f0-dc12-5606-a172-09fdfd4a462b', '4d5e07ba-525b-5a10-82b0-9c6166bfc9a9', '74c3ec40-e067-5a72-9026-cf0d7f66cc0f', '99cfcded-1744-5715-871e-d75394677221', '302a50af-7846-5420-8aed-6603a00c9947', '1cd33640-ea7c-56b7-a64d-01dd5204857f', '6dfce643-a6d1-57de-98c0-85635b3743f0', '1eda069f-24cd-5685-9690-1b38f2fd0f12', '720e16da-50e8-5924-95e9-0636c87133a0', '94b62195-57c3-5211-bf2b-b3bd11ae1f72', '195d5ed9-6a31-5671-ad04-0d97cd1afeeb', '1e026ae9-bdf1-5c4e-9d0b-fa1275855b50', '672c8134-6a3c-506e-8054-7ec223e2c413', '429ab459-4f9e-5394-b422-d4e06eb0e7b1', '6287b25e-b3cb-52da-843f-f278bae9c79b', '8c47226b-aeec-59cb-9f93-2013b4e5614a', 'e4714c37-5a40-5ef0-8600-5c210fc50fba', '81d3364c-364e-539b-a857-246766040737', '7a6359a9-222e-5478-8313-2da6e2acba02', '1fdec408-994f-5be9-9d8c-523291f93f4d', 'a4affb62-f8b3-5a74-a0bb-2c0d327c1c0b', 'cfe93286-3639-57dc-9443-96656daf7242', 'bcb3fc62-67d2-511e-9f06-0ba9e7701963', 'a9f8cfef-df27-5bb0-8738-47e1f9f6f60e', '42198a34-97ee-5628-86f9-ebf61a3528eb', 'daff01b4-f5b1-508c-976d-418e201cd962', '980e0a9d-ef04-5450-9ea1-93fa3f59ccd4', '2af4e931-05f4-5dc8-a27f-1afe0a52a2f0', 'ff61ace5-cbb3-571c-986a-11ae60e9b3a2', 'fafed2cc-a992-515a-89b3-60de01ce8ba8', '91c9abe2-75cd-5c7b-af3b-99c3e329064a');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-bac-math' AND c.id NOT IN ('ce10c015-98c9-52df-8043-6cb82a6a402b', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref, videos) VALUES
  ('ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', 'Continuité et limites — la porte de l''Analyse', 'Continuité en un point et sur un intervalle, opérations et composées, calcul de limites et formes indéterminées, théorèmes de comparaison et d''encadrement, asymptotes verticales et horizontales, image d''un intervalle, théorème des valeurs intermédiaires et son corollaire, prolongement par continuité et dichotomie', '# ⚔️ Continuité et limites — la porte de l''Analyse

> 💡 «Celui qui maîtrise les limites aperçoit l''infini ; celui qui maîtrise la continuité le traverse sans jamais tomber.»

Bienvenue dans l''année du concours, héros de la section Mathématiques. Ce chapitre ouvre le domaine de l''Analyse : dérivation, fonctions réciproques et calcul intégral s''appuieront sur les armes forgées ici. Tu consolides d''abord tes acquis de 3ème (limites usuelles, opérations), puis tu les dépasses : encadrements, composées, théorème des valeurs intermédiaires.

## 🏰 Continuité en un point et sur un intervalle

Soit f une fonction définie sur un intervalle ouvert contenant a. On dit que **f est continue en a** lorsque sa limite en a existe et vaut f(a) :

::: figure À gauche f est continue en a (courbe d''un seul trait) ; à droite un saut : la limite à gauche et à droite diffèrent
<svg viewBox="0 0 380 210"><path d="M18.0 149.2 H178.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M98.0 18.0 V182.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M178.0 149.2 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M98.0 18.0 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M18.0 166.6 L18.7 166.4 L19.3 166.1 L20.0 165.9 L20.7 165.6 L21.3 165.3 L22.0 165.1 L22.7 164.8 L23.3 164.5 L24.0 164.2 L24.7 163.8 L25.3 163.5 L26.0 163.2 L26.7 162.8 L27.3 162.5 L28.0 162.1 L28.7 161.7 L29.3 161.3 L30.0 161.0 L30.7 160.5 L31.3 160.1 L32.0 159.7 L32.7 159.3 L33.3 158.9 L34.0 158.4 L34.7 158.0 L35.3 157.5 L36.0 157.0 L36.7 156.6 L37.3 156.1 L38.0 155.6 L38.7 155.1 L39.3 154.6 L40.0 154.1 L40.7 153.6 L41.3 153.0 L42.0 152.5 L42.7 151.9 L43.3 151.4 L44.0 150.8 L44.7 150.3 L45.3 149.7 L46.0 149.1 L46.7 148.5 L47.3 147.9 L48.0 147.3 L48.7 146.7 L49.3 146.1 L50.0 145.5 L50.7 144.9 L51.3 144.3 L52.0 143.6 L52.7 143.0 L53.3 142.3 L54.0 141.7 L54.7 141.0 L55.3 140.4 L56.0 139.7 L56.7 139.0 L57.3 138.3 L58.0 137.7 L58.7 137.0 L59.3 136.3 L60.0 135.6 L60.7 134.9 L61.3 134.2 L62.0 133.5 L62.7 132.8 L63.3 132.1 L64.0 131.3 L64.7 130.6 L65.3 129.9 L66.0 129.2 L66.7 128.4 L67.3 127.7 L68.0 127.0 L68.7 126.2 L69.3 125.5 L70.0 124.7 L70.7 124.0 L71.3 123.2 L72.0 122.5 L72.7 121.7 L73.3 121.0 L74.0 120.2 L74.7 119.5 L75.3 118.7 L76.0 117.9 L76.7 117.2 L77.3 116.4 L78.0 115.7 L78.7 114.9 L79.3 114.1 L80.0 113.4 L80.7 112.6 L81.3 111.8 L82.0 111.1 L82.7 110.3 L83.3 109.6 L84.0 108.8 L84.7 108.0 L85.3 107.3 L86.0 106.5 L86.7 105.8 L87.3 105.0 L88.0 104.3 L88.7 103.5 L89.3 102.8 L90.0 102.0 L90.7 101.3 L91.3 100.5 L92.0 99.8 L92.7 99.0 L93.3 98.3 L94.0 97.6 L94.7 96.8 L95.3 96.1 L96.0 95.4 L96.7 94.7 L97.3 93.9 L98.0 93.2 L98.7 92.5 L99.3 91.8 L100.0 91.1 L100.7 90.4 L101.3 89.7 L102.0 89.0 L102.7 88.3 L103.3 87.7 L104.0 87.0 L104.7 86.3 L105.3 85.7 L106.0 85.0 L106.7 84.3 L107.3 83.7 L108.0 83.0 L108.7 82.4 L109.3 81.8 L110.0 81.1 L110.7 80.5 L111.3 79.9 L112.0 79.3 L112.7 78.7 L113.3 78.1 L114.0 77.5 L114.7 76.9 L115.3 76.4 L116.0 75.8 L116.7 75.2 L117.3 74.7 L118.0 74.1 L118.7 73.6 L119.3 73.0 L120.0 72.5 L120.7 72.0 L121.3 71.5 L122.0 71.0 L122.7 70.5 L123.3 70.0 L124.0 69.5 L124.7 69.0 L125.3 68.6 L126.0 68.1 L126.7 67.7 L127.3 67.2 L128.0 66.8 L128.7 66.4 L129.3 66.0 L130.0 65.6 L130.7 65.2 L131.3 64.8 L132.0 64.4 L132.7 64.0 L133.3 63.7 L134.0 63.3 L134.7 63.0 L135.3 62.6 L136.0 62.3 L136.7 62.0 L137.3 61.7 L138.0 61.4 L138.7 61.1 L139.3 60.8 L140.0 60.5 L140.7 60.3 L141.3 60.0 L142.0 59.8 L142.7 59.5 L143.3 59.3 L144.0 59.1 L144.7 58.9 L145.3 58.7 L146.0 58.5 L146.7 58.3 L147.3 58.2 L148.0 58.0 L148.7 57.9 L149.3 57.7 L150.0 57.6 L150.7 57.5 L151.3 57.4 L152.0 57.3 L152.7 57.2 L153.3 57.1 L154.0 57.0 L154.7 57.0 L155.3 56.9 L156.0 56.9 L156.7 56.8 L157.3 56.8 L158.0 56.8 L158.7 56.8 L159.3 56.8 L160.0 56.8 L160.7 56.9 L161.3 56.9 L162.0 56.9 L162.7 57.0 L163.3 57.0 L164.0 57.1 L164.7 57.2 L165.3 57.3 L166.0 57.4 L166.7 57.5 L167.3 57.6 L168.0 57.7 L168.7 57.9 L169.3 58.0 L170.0 58.1 L170.7 58.3 L171.3 58.5 L172.0 58.6 L172.7 58.8 L173.3 59.0 L174.0 59.2 L174.7 59.4 L175.3 59.7 L176.0 59.9 L176.7 60.1 L177.3 60.4 L178.0 60.6" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><circle cx="111.3" cy="79.9" r="4" fill="#0f6e56"/><line x1="111.3" y1="79.9" x2="111.3" y2="182.0" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 3"/><text x="111.33333333333334" y="198.0" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">a</text><text x="95" y="22" text-anchor="middle" font-size="13" font-weight="700" fill="#0f6e56" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">f continue en a</text><path d="M208.0 149.2 H368.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M288.0 18.0 V182.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M368.0 149.2 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M288.0 18.0 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M208.0 142.6 L208.4 142.4 L208.8 142.2 L209.2 141.9 L209.6 141.7 L209.9 141.4 L210.3 141.2 L210.7 141.0 L211.1 140.7 L211.5 140.5 L211.9 140.2 L212.3 140.0 L212.7 139.8 L213.1 139.5 L213.4 139.3 L213.8 139.1 L214.2 138.8 L214.6 138.6 L215.0 138.3 L215.4 138.1 L215.8 137.9 L216.2 137.6 L216.6 137.4 L216.9 137.1 L217.3 136.9 L217.7 136.7 L218.1 136.4 L218.5 136.2 L218.9 135.9 L219.3 135.7 L219.7 135.5 L220.1 135.2 L220.4 135.0 L220.8 134.7 L221.2 134.5 L221.6 134.3 L222.0 134.0 L222.4 133.8 L222.8 133.6 L223.2 133.3 L223.6 133.1 L223.9 132.8 L224.3 132.6 L224.7 132.4 L225.1 132.1 L225.5 131.9 L225.9 131.6 L226.3 131.4 L226.7 131.2 L227.1 130.9 L227.4 130.7 L227.8 130.4 L228.2 130.2 L228.6 130.0 L229.0 129.7 L229.4 129.5 L229.8 129.2 L230.2 129.0 L230.6 128.8 L230.9 128.5 L231.3 128.3 L231.7 128.1 L232.1 127.8 L232.5 127.6 L232.9 127.3 L233.3 127.1 L233.7 126.9 L234.1 126.6 L234.4 126.4 L234.8 126.1 L235.2 125.9 L235.6 125.7 L236.0 125.4 L236.4 125.2 L236.8 124.9 L237.2 124.7 L237.6 124.5 L237.9 124.2 L238.3 124.0 L238.7 123.7 L239.1 123.5 L239.5 123.3 L239.9 123.0 L240.3 122.8 L240.7 122.6 L241.1 122.3 L241.4 122.1 L241.8 121.8 L242.2 121.6 L242.6 121.4 L243.0 121.1 L243.4 120.9 L243.8 120.6 L244.2 120.4 L244.6 120.2 L244.9 119.9 L245.3 119.7 L245.7 119.4 L246.1 119.2 L246.5 119.0 L246.9 118.7 L247.3 118.5 L247.7 118.2 L248.1 118.0 L248.4 117.8 L248.8 117.5 L249.2 117.3 L249.6 117.0 L250.0 116.8 L250.4 116.6 L250.8 116.3 L251.2 116.1 L251.6 115.9 L251.9 115.6 L252.3 115.4 L252.7 115.1 L253.1 114.9 L253.5 114.7 L253.9 114.4 L254.3 114.2 L254.7 113.9 L255.1 113.7 L255.4 113.5 L255.8 113.2 L256.2 113.0 L256.6 112.7 L257.0 112.5 L257.4 112.3 L257.8 112.0 L258.2 111.8 L258.6 111.5 L258.9 111.3 L259.3 111.1 L259.7 110.8 L260.1 110.6 L260.5 110.4 L260.9 110.1 L261.3 109.9 L261.7 109.6 L262.1 109.4 L262.4 109.2 L262.8 108.9 L263.2 108.7 L263.6 108.4 L264.0 108.2 L264.4 108.0 L264.8 107.7 L265.2 107.5 L265.6 107.2 L265.9 107.0 L266.3 106.8 L266.7 106.5 L267.1 106.3 L267.5 106.0 L267.9 105.8 L268.3 105.6 L268.7 105.3 L269.1 105.1 L269.4 104.9 L269.8 104.6 L270.2 104.4 L270.6 104.1 L271.0 103.9 L271.4 103.7 L271.8 103.4 L272.2 103.2 L272.6 102.9 L272.9 102.7 L273.3 102.5 L273.7 102.2 L274.1 102.0 L274.5 101.7 L274.9 101.5 L275.3 101.3 L275.7 101.0 L276.1 100.8 L276.4 100.5 L276.8 100.3 L277.2 100.1 L277.6 99.8 L278.0 99.6 L278.4 99.4 L278.8 99.1 L279.2 98.9 L279.6 98.6 L279.9 98.4 L280.3 98.2 L280.7 97.9 L281.1 97.7 L281.5 97.4 L281.9 97.2 L282.3 97.0 L282.7 96.7 L283.1 96.5 L283.4 96.2 L283.8 96.0 L284.2 95.8 L284.6 95.5 L285.0 95.3 L285.4 95.0 L285.8 94.8 L286.2 94.6 L286.6 94.3 L286.9 94.1 L287.3 93.9 L287.7 93.6 L288.1 93.4 L288.5 93.1 L288.9 92.9 L289.3 92.7 L289.7 92.4 L290.1 92.2 L290.4 91.9 L290.8 91.7 L291.2 91.5 L291.6 91.2 L292.0 91.0 L292.4 90.7 L292.8 90.5 L293.2 90.3 L293.6 90.0 L293.9 89.8 L294.3 89.5 L294.7 89.3 L295.1 89.1 L295.5 88.8 L295.9 88.6 L296.3 88.3 L296.7 88.1 L297.1 87.9 L297.4 87.6 L297.8 87.4 L298.2 87.2 L298.6 86.9 L299.0 86.7 L299.4 86.4 L299.8 86.2 L300.2 86.0 L300.6 85.7 L300.9 85.5 L301.3 85.2" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><path d="M301.3 54.1 L301.6 54.0 L301.9 53.8 L302.2 53.7 L302.4 53.6 L302.7 53.5 L303.0 53.4 L303.3 53.2 L303.6 53.1 L303.8 53.0 L304.1 52.9 L304.4 52.8 L304.7 52.6 L304.9 52.5 L305.2 52.4 L305.5 52.3 L305.8 52.2 L306.1 52.0 L306.3 51.9 L306.6 51.8 L306.9 51.7 L307.2 51.6 L307.4 51.4 L307.7 51.3 L308.0 51.2 L308.3 51.1 L308.6 51.0 L308.8 50.9 L309.1 50.7 L309.4 50.6 L309.7 50.5 L309.9 50.4 L310.2 50.3 L310.5 50.1 L310.8 50.0 L311.1 49.9 L311.3 49.8 L311.6 49.7 L311.9 49.5 L312.2 49.4 L312.4 49.3 L312.7 49.2 L313.0 49.1 L313.3 48.9 L313.6 48.8 L313.8 48.7 L314.1 48.6 L314.4 48.5 L314.7 48.3 L314.9 48.2 L315.2 48.1 L315.5 48.0 L315.8 47.9 L316.1 47.7 L316.3 47.6 L316.6 47.5 L316.9 47.4 L317.2 47.3 L317.4 47.1 L317.7 47.0 L318.0 46.9 L318.3 46.8 L318.6 46.7 L318.8 46.5 L319.1 46.4 L319.4 46.3 L319.7 46.2 L319.9 46.1 L320.2 45.9 L320.5 45.8 L320.8 45.7 L321.1 45.6 L321.3 45.5 L321.6 45.4 L321.9 45.2 L322.2 45.1 L322.4 45.0 L322.7 44.9 L323.0 44.8 L323.3 44.6 L323.6 44.5 L323.8 44.4 L324.1 44.3 L324.4 44.2 L324.7 44.0 L324.9 43.9 L325.2 43.8 L325.5 43.7 L325.8 43.6 L326.1 43.4 L326.3 43.3 L326.6 43.2 L326.9 43.1 L327.2 43.0 L327.4 42.8 L327.7 42.7 L328.0 42.6 L328.3 42.5 L328.6 42.4 L328.8 42.2 L329.1 42.1 L329.4 42.0 L329.7 41.9 L329.9 41.8 L330.2 41.6 L330.5 41.5 L330.8 41.4 L331.1 41.3 L331.3 41.2 L331.6 41.0 L331.9 40.9 L332.2 40.8 L332.4 40.7 L332.7 40.6 L333.0 40.4 L333.3 40.3 L333.6 40.2 L333.8 40.1 L334.1 40.0 L334.4 39.8 L334.7 39.7 L334.9 39.6 L335.2 39.5 L335.5 39.4 L335.8 39.3 L336.1 39.1 L336.3 39.0 L336.6 38.9 L336.9 38.8 L337.2 38.7 L337.4 38.5 L337.7 38.4 L338.0 38.3 L338.3 38.2 L338.6 38.1 L338.8 37.9 L339.1 37.8 L339.4 37.7 L339.7 37.6 L339.9 37.5 L340.2 37.3 L340.5 37.2 L340.8 37.1 L341.1 37.0 L341.3 36.9 L341.6 36.7 L341.9 36.6 L342.2 36.5 L342.4 36.4 L342.7 36.3 L343.0 36.1 L343.3 36.0 L343.6 35.9 L343.8 35.8 L344.1 35.7 L344.4 35.5 L344.7 35.4 L344.9 35.3 L345.2 35.2 L345.5 35.1 L345.8 34.9 L346.1 34.8 L346.3 34.7 L346.6 34.6 L346.9 34.5 L347.2 34.3 L347.4 34.2 L347.7 34.1 L348.0 34.0 L348.3 33.9 L348.6 33.8 L348.8 33.6 L349.1 33.5 L349.4 33.4 L349.7 33.3 L349.9 33.2 L350.2 33.0 L350.5 32.9 L350.8 32.8 L351.1 32.7 L351.3 32.6 L351.6 32.4 L351.9 32.3 L352.2 32.2 L352.4 32.1 L352.7 32.0 L353.0 31.8 L353.3 31.7 L353.6 31.6 L353.8 31.5 L354.1 31.4 L354.4 31.2 L354.7 31.1 L354.9 31.0 L355.2 30.9 L355.5 30.8 L355.8 30.6 L356.1 30.5 L356.3 30.4 L356.6 30.3 L356.9 30.2 L357.2 30.0 L357.4 29.9 L357.7 29.8 L358.0 29.7 L358.3 29.6 L358.6 29.4 L358.8 29.3 L359.1 29.2 L359.4 29.1 L359.7 29.0 L359.9 28.8 L360.2 28.7 L360.5 28.6 L360.8 28.5 L361.1 28.4 L361.3 28.2 L361.6 28.1 L361.9 28.0 L362.2 27.9 L362.4 27.8 L362.7 27.7 L363.0 27.5 L363.3 27.4 L363.6 27.3 L363.8 27.2 L364.1 27.1 L364.4 26.9 L364.7 26.8 L364.9 26.7 L365.2 26.6 L365.5 26.5 L365.8 26.3 L366.1 26.2 L366.3 26.1 L366.6 26.0 L366.9 25.9 L367.2 25.7 L367.4 25.6 L367.7 25.5 L368.0 25.4" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><circle cx="301.3" cy="85.2" r="4" fill="#ffffff" stroke="#0f6e56" stroke-width="2.5"/><circle cx="301.3" cy="54.1" r="4" fill="#0f6e56"/><line x1="301.3" y1="18.0" x2="301.3" y2="182.0" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 3"/><text x="301.33333333333337" y="198.0" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">a</text><text x="285" y="22" text-anchor="middle" font-size="13" font-weight="700" fill="#b45309" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">saut en a</text><text x="285" y="38" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">lim⁻ ≠ lim⁺</text></svg>
:::

$$ lim x→a f(x) = f(a) $$

- **Continuité à droite** en a : lim x→a⁺ f(x) = f(a) ; **continuité à gauche** : lim x→a⁻ f(x) = f(a). f est continue en a si et seulement si elle est continue à droite **et** à gauche en a.
- f est **continue sur un intervalle I** lorsqu''elle est continue en tout point de I.
- **Fonctions usuelles** : les polynômes, les fonctions rationnelles (sur tout intervalle de leur ensemble de définition), x ↦ √x, x ↦ |x|, sin et cos sont continues là où elles sont définies.

## ⚡ Opérations et composées

Si f et g sont continues en a, alors **f + g**, **f × g** et, si g(a) ≠ 0, **f/g** sont continues en a.

> 🗡️ **Composée** : si v est continue en a et si u est continue en v(a), alors **u ∘ v est continue en a**. _Exemple_ : x ↦ √(x² + 1) est continue sur ℝ, car v : x ↦ x² + 1 est continue à valeurs dans [1 ; +∞[ et u = √ est continue sur [0 ; +∞[.

## 🔮 Limites et formes indéterminées

Les théorèmes d''opérations (somme, produit, quotient) concluent directement… sauf face aux **quatre formes indéterminées** : **∞ − ∞**, **0 × ∞**, **∞/∞** et **0/0**. Il faut alors transformer l''expression avant de conclure. Trois techniques majeures :

- **Terme de plus haut degré** (polynômes et fonctions rationnelles en ±∞) :

$$ lim x→+∞ (3x² − x + 1) = lim x→+∞ 3x² = +∞ $$

$$ lim x→+∞ (5x + 2)/(x − 4) = lim x→+∞ 5x/x = 5 $$

- **Factorisation** (forme 0/0 en un point) :

$$ lim x→2 (x² − 4)/(x − 2) = lim x→2 (x + 2) = 4 $$

- **Expression conjuguée** (radicaux) :

$$ lim x→+∞ (√(x² + 4x) − x) = lim x→+∞ 4x/(√(x² + 4x) + x) = 4/2 = 2 $$

- **Limite infinie en un point** : on étudie le **signe du dénominateur** de part et d''autre. _Exemple_ : lim x→2⁺ 1/(x − 2) = +∞ et lim x→2⁻ 1/(x − 2) = −∞.

> ⚠️ Le piège mortel : remplacer un morceau d''une forme indéterminée par sa limite («√(x² + 4x) se comporte comme x, donc la différence tend vers 0») est une opération **illégale**. On transforme l''expression entière, puis seulement on conclut.

## 🛡️ Comparaison, encadrement et limite d''une composée

- **Comparaison** : si f(x) ≥ u(x) au voisinage de +∞ et si lim x→+∞ u(x) = +∞, alors lim x→+∞ f(x) = +∞ (énoncé analogue vers −∞ avec une majoration).
- **Théorème des gendarmes** : si u(x) ≤ f(x) ≤ v(x) au voisinage de +∞ et si lim u = lim v = ℓ, alors lim x→+∞ f(x) = ℓ. _Exemple_ : pour x > 0, −1/x ≤ (sin x)/x ≤ 1/x, donc lim x→+∞ (sin x)/x = 0. (Rappel de 3ème, toujours admis : lim x→0 (sin x)/x = 1.)

::: figure Les deux « gendarmes » u = −1/x et v = 1/x encadrent (sin x)/x et l''écrasent vers ℓ = 0
<svg viewBox="0 0 360 230"><path d="M32.0 142.5 H342.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M32.0 18.0 V202.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M342.0 142.5 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M32.0 18.0 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M39.5 22.2 L40.8 28.6 L42.0 34.3 L43.3 39.5 L44.5 44.2 L45.8 48.5 L47.1 52.5 L48.3 56.1 L49.6 59.4 L50.8 62.5 L52.1 65.4 L53.4 68.1 L54.6 70.6 L55.9 72.9 L57.1 75.1 L58.4 77.1 L59.7 79.1 L60.9 80.9 L62.2 82.6 L63.4 84.2 L64.7 85.8 L66.0 87.2 L67.2 88.6 L68.5 89.9 L69.8 91.2 L71.0 92.4 L72.3 93.5 L73.5 94.6 L74.8 95.6 L76.1 96.6 L77.3 97.6 L78.6 98.5 L79.8 99.4 L81.1 100.3 L82.4 101.1 L83.6 101.9 L84.9 102.6 L86.1 103.3 L87.4 104.0 L88.7 104.7 L89.9 105.4 L91.2 106.0 L92.4 106.6 L93.7 107.2 L95.0 107.8 L96.2 108.3 L97.5 108.8 L98.7 109.4 L100.0 109.9 L101.3 110.4 L102.5 110.8 L103.8 111.3 L105.0 111.7 L106.3 112.2 L107.6 112.6 L108.8 113.0 L110.1 113.4 L111.3 113.8 L112.6 114.2 L113.9 114.5 L115.1 114.9 L116.4 115.2 L117.6 115.6 L118.9 115.9 L120.2 116.2 L121.4 116.6 L122.7 116.9 L123.9 117.2 L125.2 117.5 L126.5 117.8 L127.7 118.0 L129.0 118.3 L130.2 118.6 L131.5 118.8 L132.8 119.1 L134.0 119.3 L135.3 119.6 L136.6 119.8 L137.8 120.1 L139.1 120.3 L140.3 120.5 L141.6 120.8 L142.9 121.0 L144.1 121.2 L145.4 121.4 L146.6 121.6 L147.9 121.8 L149.2 122.0 L150.4 122.2 L151.7 122.4 L152.9 122.6 L154.2 122.7 L155.5 122.9 L156.7 123.1 L158.0 123.3 L159.2 123.4 L160.5 123.6 L161.8 123.8 L163.0 123.9 L164.3 124.1 L165.5 124.3 L166.8 124.4 L168.1 124.6 L169.3 124.7 L170.6 124.9 L171.8 125.0 L173.1 125.1 L174.4 125.3 L175.6 125.4 L176.9 125.5 L178.1 125.7 L179.4 125.8 L180.7 125.9 L181.9 126.1 L183.2 126.2 L184.4 126.3 L185.7 126.4 L187.0 126.6 L188.2 126.7 L189.5 126.8 L190.8 126.9 L192.0 127.0 L193.3 127.1 L194.5 127.2 L195.8 127.3 L197.1 127.4 L198.3 127.5 L199.6 127.6 L200.8 127.8 L202.1 127.9 L203.4 128.0 L204.6 128.0 L205.9 128.1 L207.1 128.2 L208.4 128.3 L209.7 128.4 L210.9 128.5 L212.2 128.6 L213.4 128.7 L214.7 128.8 L216.0 128.9 L217.2 129.0 L218.5 129.0 L219.7 129.1 L221.0 129.2 L222.3 129.3 L223.5 129.4 L224.8 129.4 L226.0 129.5 L227.3 129.6 L228.6 129.7 L229.8 129.8 L231.1 129.8 L232.3 129.9 L233.6 130.0 L234.9 130.1 L236.1 130.1 L237.4 130.2 L238.6 130.3 L239.9 130.3 L241.2 130.4 L242.4 130.5 L243.7 130.5 L244.9 130.6 L246.2 130.7 L247.5 130.7 L248.7 130.8 L250.0 130.9 L251.3 130.9 L252.5 131.0 L253.8 131.0 L255.0 131.1 L256.3 131.2 L257.6 131.2 L258.8 131.3 L260.1 131.3 L261.3 131.4 L262.6 131.5 L263.9 131.5 L265.1 131.6 L266.4 131.6 L267.6 131.7 L268.9 131.7 L270.2 131.8 L271.4 131.8 L272.7 131.9 L273.9 131.9 L275.2 132.0 L276.5 132.0 L277.7 132.1 L279.0 132.1 L280.2 132.2 L281.5 132.2 L282.8 132.3 L284.0 132.3 L285.3 132.4 L286.5 132.4 L287.8 132.5 L289.1 132.5 L290.3 132.6 L291.6 132.6 L292.8 132.7 L294.1 132.7 L295.4 132.7 L296.6 132.8 L297.9 132.8 L299.1 132.9 L300.4 132.9 L301.7 133.0 L302.9 133.0 L304.2 133.0 L305.4 133.1 L306.7 133.1 L308.0 133.2 L309.2 133.2 L310.5 133.3 L311.8 133.3 L313.0 133.3 L314.3 133.4 L315.5 133.4 L316.8 133.4 L318.1 133.5 L319.3 133.5 L320.6 133.6 L321.8 133.6 L323.1 133.6 L324.4 133.7 L325.6 133.7 L326.9 133.7 L328.1 133.8 L329.4 133.8 L330.7 133.8 L331.9 133.9 L333.2 133.9 L334.4 133.9 L335.7 134.0 L337.0 134.0 L338.2 134.0 L339.5 134.1 L340.7 134.1 L342.0 134.1" fill="none" stroke="#7c3aed" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" stroke-dasharray="5 3"/><path d="M42.0 250.6 L43.3 245.4 L44.5 240.7 L45.8 236.4 L47.1 232.5 L48.3 228.9 L49.6 225.5 L50.8 222.4 L52.1 219.6 L53.4 216.9 L54.6 214.4 L55.9 212.1 L57.1 209.9 L58.4 207.8 L59.7 205.9 L60.9 204.1 L62.2 202.4 L63.4 200.7 L64.7 199.2 L66.0 197.7 L67.2 196.3 L68.5 195.0 L69.8 193.8 L71.0 192.6 L72.3 191.4 L73.5 190.3 L74.8 189.3 L76.1 188.3 L77.3 187.3 L78.6 186.4 L79.8 185.5 L81.1 184.7 L82.4 183.9 L83.6 183.1 L84.9 182.3 L86.1 181.6 L87.4 180.9 L88.7 180.2 L89.9 179.6 L91.2 178.9 L92.4 178.3 L93.7 177.8 L95.0 177.2 L96.2 176.6 L97.5 176.1 L98.7 175.6 L100.0 175.1 L101.3 174.6 L102.5 174.1 L103.8 173.7 L105.0 173.2 L106.3 172.8 L107.6 172.3 L108.8 171.9 L110.1 171.5 L111.3 171.2 L112.6 170.8 L113.9 170.4 L115.1 170.0 L116.4 169.7 L117.6 169.4 L118.9 169.0 L120.2 168.7 L121.4 168.4 L122.7 168.1 L123.9 167.8 L125.2 167.5 L126.5 167.2 L127.7 166.9 L129.0 166.6 L130.2 166.4 L131.5 166.1 L132.8 165.8 L134.0 165.6 L135.3 165.3 L136.6 165.1 L137.8 164.9 L139.1 164.6 L140.3 164.4 L141.6 164.2 L142.9 164.0 L144.1 163.8 L145.4 163.5 L146.6 163.3 L147.9 163.1 L149.2 162.9 L150.4 162.8 L151.7 162.6 L152.9 162.4 L154.2 162.2 L155.5 162.0 L156.7 161.8 L158.0 161.7 L159.2 161.5 L160.5 161.3 L161.8 161.2 L163.0 161.0 L164.3 160.8 L165.5 160.7 L166.8 160.5 L168.1 160.4 L169.3 160.2 L170.6 160.1 L171.8 159.9 L173.1 159.8 L174.4 159.7 L175.6 159.5 L176.9 159.4 L178.1 159.3 L179.4 159.1 L180.7 159.0 L181.9 158.9 L183.2 158.8 L184.4 158.6 L185.7 158.5 L187.0 158.4 L188.2 158.3 L189.5 158.2 L190.8 158.0 L192.0 157.9 L193.3 157.8 L194.5 157.7 L195.8 157.6 L197.1 157.5 L198.3 157.4 L199.6 157.3 L200.8 157.2 L202.1 157.1 L203.4 157.0 L204.6 156.9 L205.9 156.8 L207.1 156.7 L208.4 156.6 L209.7 156.5 L210.9 156.4 L212.2 156.3 L213.4 156.2 L214.7 156.2 L216.0 156.1 L217.2 156.0 L218.5 155.9 L219.7 155.8 L221.0 155.7 L222.3 155.7 L223.5 155.6 L224.8 155.5 L226.0 155.4 L227.3 155.3 L228.6 155.3 L229.8 155.2 L231.1 155.1 L232.3 155.0 L233.6 155.0 L234.9 154.9 L236.1 154.8 L237.4 154.7 L238.6 154.7 L239.9 154.6 L241.2 154.5 L242.4 154.5 L243.7 154.4 L244.9 154.3 L246.2 154.3 L247.5 154.2 L248.7 154.1 L250.0 154.1 L251.3 154.0 L252.5 154.0 L253.8 153.9 L255.0 153.8 L256.3 153.8 L257.6 153.7 L258.8 153.7 L260.1 153.6 L261.3 153.5 L262.6 153.5 L263.9 153.4 L265.1 153.4 L266.4 153.3 L267.6 153.3 L268.9 153.2 L270.2 153.2 L271.4 153.1 L272.7 153.1 L273.9 153.0 L275.2 153.0 L276.5 152.9 L277.7 152.8 L279.0 152.8 L280.2 152.7 L281.5 152.7 L282.8 152.7 L284.0 152.6 L285.3 152.6 L286.5 152.5 L287.8 152.5 L289.1 152.4 L290.3 152.4 L291.6 152.3 L292.8 152.3 L294.1 152.2 L295.4 152.2 L296.6 152.1 L297.9 152.1 L299.1 152.1 L300.4 152.0 L301.7 152.0 L302.9 151.9 L304.2 151.9 L305.4 151.9 L306.7 151.8 L308.0 151.8 L309.2 151.7 L310.5 151.7 L311.8 151.7 L313.0 151.6 L314.3 151.6 L315.5 151.5 L316.8 151.5 L318.1 151.5 L319.3 151.4 L320.6 151.4 L321.8 151.3 L323.1 151.3 L324.4 151.3 L325.6 151.2 L326.9 151.2 L328.1 151.2 L329.4 151.1 L330.7 151.1 L331.9 151.1 L333.2 151.0 L334.4 151.0 L335.7 151.0 L337.0 150.9 L338.2 150.9 L339.5 150.9 L340.7 150.8 L342.0 150.8" fill="none" stroke="#b45309" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" stroke-dasharray="5 3"/><path d="M32.0 40.6 L33.3 41.7 L34.6 42.9 L35.9 44.2 L37.2 45.6 L38.5 47.0 L39.8 48.6 L41.0 50.2 L42.3 51.8 L43.6 53.6 L44.9 55.4 L46.2 57.2 L47.5 59.2 L48.8 61.1 L50.1 63.2 L51.4 65.3 L52.7 67.4 L54.0 69.6 L55.2 71.8 L56.5 74.0 L57.8 76.3 L59.1 78.7 L60.4 81.0 L61.7 83.4 L63.0 85.8 L64.3 88.2 L65.6 90.6 L66.9 93.0 L68.2 95.5 L69.5 97.9 L70.8 100.3 L72.0 102.8 L73.3 105.2 L74.6 107.6 L75.9 110.0 L77.2 112.4 L78.5 114.8 L79.8 117.1 L81.1 119.4 L82.4 121.7 L83.7 123.9 L85.0 126.1 L86.2 128.3 L87.5 130.4 L88.8 132.5 L90.1 134.5 L91.4 136.5 L92.7 138.4 L94.0 140.3 L95.3 142.1 L96.6 143.9 L97.9 145.6 L99.2 147.2 L100.5 148.8 L101.8 150.3 L103.0 151.8 L104.3 153.1 L105.6 154.5 L106.9 155.7 L108.2 156.9 L109.5 158.0 L110.8 159.0 L112.1 160.0 L113.4 160.8 L114.7 161.7 L116.0 162.4 L117.2 163.1 L118.5 163.7 L119.8 164.2 L121.1 164.7 L122.4 165.0 L123.7 165.4 L125.0 165.6 L126.3 165.8 L127.6 165.9 L128.9 166.0 L130.2 166.0 L131.5 165.9 L132.8 165.8 L134.0 165.6 L135.3 165.3 L136.6 165.0 L137.9 164.7 L139.2 164.3 L140.5 163.8 L141.8 163.3 L143.1 162.8 L144.4 162.2 L145.7 161.5 L147.0 160.9 L148.2 160.2 L149.5 159.4 L150.8 158.7 L152.1 157.9 L153.4 157.1 L154.7 156.2 L156.0 155.4 L157.3 154.5 L158.6 153.6 L159.9 152.7 L161.2 151.7 L162.5 150.8 L163.7 149.9 L165.0 148.9 L166.3 148.0 L167.6 147.1 L168.9 146.1 L170.2 145.2 L171.5 144.3 L172.8 143.4 L174.1 142.5 L175.4 141.6 L176.7 140.7 L178.0 139.9 L179.2 139.0 L180.5 138.2 L181.8 137.5 L183.1 136.7 L184.4 136.0 L185.7 135.3 L187.0 134.6 L188.3 134.0 L189.6 133.4 L190.9 132.8 L192.2 132.2 L193.5 131.7 L194.8 131.3 L196.0 130.8 L197.3 130.4 L198.6 130.1 L199.9 129.8 L201.2 129.5 L202.5 129.2 L203.8 129.0 L205.1 128.9 L206.4 128.7 L207.7 128.6 L209.0 128.6 L210.2 128.6 L211.5 128.6 L212.8 128.7 L214.1 128.8 L215.4 128.9 L216.7 129.0 L218.0 129.2 L219.3 129.5 L220.6 129.7 L221.9 130.0 L223.2 130.3 L224.5 130.7 L225.8 131.1 L227.0 131.5 L228.3 131.9 L229.6 132.3 L230.9 132.8 L232.2 133.3 L233.5 133.8 L234.8 134.3 L236.1 134.9 L237.4 135.4 L238.7 136.0 L240.0 136.6 L241.2 137.2 L242.5 137.8 L243.8 138.4 L245.1 139.0 L246.4 139.6 L247.7 140.2 L249.0 140.8 L250.3 141.4 L251.6 142.0 L252.9 142.6 L254.2 143.2 L255.5 143.8 L256.8 144.3 L258.0 144.9 L259.3 145.4 L260.6 146.0 L261.9 146.5 L263.2 147.0 L264.5 147.5 L265.8 147.9 L267.1 148.4 L268.4 148.8 L269.7 149.2 L271.0 149.6 L272.2 150.0 L273.5 150.3 L274.8 150.6 L276.1 150.9 L277.4 151.2 L278.7 151.4 L280.0 151.6 L281.3 151.8 L282.6 152.0 L283.9 152.1 L285.2 152.2 L286.5 152.3 L287.8 152.3 L289.0 152.4 L290.3 152.4 L291.6 152.3 L292.9 152.3 L294.2 152.2 L295.5 152.1 L296.8 152.0 L298.1 151.8 L299.4 151.6 L300.7 151.4 L302.0 151.2 L303.2 151.0 L304.5 150.7 L305.8 150.4 L307.1 150.1 L308.4 149.8 L309.7 149.5 L311.0 149.1 L312.3 148.7 L313.6 148.4 L314.9 148.0 L316.2 147.6 L317.5 147.2 L318.8 146.7 L320.0 146.3 L321.3 145.9 L322.6 145.4 L323.9 145.0 L325.2 144.5 L326.5 144.1 L327.8 143.6 L329.1 143.2 L330.4 142.7 L331.7 142.3 L333.0 141.9 L334.2 141.4 L335.5 141.0 L336.8 140.6 L338.1 140.2 L339.4 139.7 L340.7 139.4 L342.0 139.0" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><text x="122.0" y="110.70028011204481" text-anchor="middle" font-size="12" font-weight="700" fill="#7c3aed" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">v = 1/x</text><text x="132.0" y="180.0" text-anchor="middle" font-size="12" font-weight="700" fill="#b45309" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">u = −1/x</text><text x="246.99999999999997" y="131.8483539517618" text-anchor="middle" font-size="12" font-weight="700" fill="#0f6e56" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">(sin x)/x</text><text x="327.0" y="136.47058823529412" text-anchor="end" font-size="12" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">ℓ = 0</text></svg>
:::

- **Limite d''une composée** : si lim x→a v(x) = b et si lim y→b u(y) = ℓ, alors lim x→a u(v(x)) = ℓ. _Exemple_ : lim x→+∞ √(4 + 1/x) = √4 = 2, car 4 + 1/x → 4 et √ est continue en 4.

## 📐 Asymptotes verticales et horizontales

- Si lim x→a f(x) = +∞ ou −∞ (même seulement à droite ou à gauche de a), la droite d''équation **x = a** est une **asymptote verticale** de la courbe.
- Si lim x→+∞ f(x) = ℓ (ou en −∞), la droite d''équation **y = ℓ** est une **asymptote horizontale**.
- _Exemple_ : pour f(x) = (2x + 1)/(x − 3), la courbe admet l''asymptote verticale x = 3 (le dénominateur s''annule en 3) et l''asymptote horizontale y = 2 (termes dominants 2x/x).

::: figure f(x) = (2x+1)/(x−3) : asymptote verticale x = 3 (limite infinie) et horizontale y = 2 (limite finie à l''infini)
<svg viewBox="0 0 340 260"><line x1="177.0" y1="18.0" x2="177.0" y2="232.0" stroke="#94a3b8" stroke-width="1.6" stroke-dasharray="6 4"/><line x1="32.0" y1="125.0" x2="322.0" y2="125.0" stroke="#94a3b8" stroke-width="1.6" stroke-dasharray="6 4"/><path d="M32.0 155.6 H322.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M104.5 18.0 V232.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M322.0 155.6 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M104.5 18.0 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M32.0 142.8 L32.6 142.9 L33.2 143.0 L33.7 143.0 L34.3 143.1 L34.9 143.2 L35.5 143.3 L36.1 143.3 L36.6 143.4 L37.2 143.5 L37.8 143.6 L38.4 143.7 L38.9 143.7 L39.5 143.8 L40.1 143.9 L40.7 144.0 L41.3 144.1 L41.8 144.1 L42.4 144.2 L43.0 144.3 L43.6 144.4 L44.2 144.5 L44.7 144.6 L45.3 144.6 L45.9 144.7 L46.5 144.8 L47.1 144.9 L47.6 145.0 L48.2 145.1 L48.8 145.2 L49.4 145.3 L49.9 145.4 L50.5 145.4 L51.1 145.5 L51.7 145.6 L52.3 145.7 L52.8 145.8 L53.4 145.9 L54.0 146.0 L54.6 146.1 L55.2 146.2 L55.7 146.3 L56.3 146.4 L56.9 146.5 L57.5 146.6 L58.1 146.7 L58.6 146.8 L59.2 147.0 L59.8 147.1 L60.4 147.2 L60.9 147.3 L61.5 147.4 L62.1 147.5 L62.7 147.6 L63.3 147.7 L63.8 147.9 L64.4 148.0 L65.0 148.1 L65.6 148.2 L66.2 148.3 L66.7 148.5 L67.3 148.6 L67.9 148.7 L68.5 148.8 L69.1 149.0 L69.6 149.1 L70.2 149.2 L70.8 149.3 L71.4 149.5 L72.0 149.6 L72.5 149.8 L73.1 149.9 L73.7 150.0 L74.3 150.2 L74.8 150.3 L75.4 150.5 L76.0 150.6 L76.6 150.8 L77.2 150.9 L77.7 151.1 L78.3 151.2 L78.9 151.4 L79.5 151.5 L80.1 151.7 L80.6 151.8 L81.2 152.0 L81.8 152.2 L82.4 152.3 L83.0 152.5 L83.5 152.7 L84.1 152.8 L84.7 153.0 L85.3 153.2 L85.8 153.4 L86.4 153.5 L87.0 153.7 L87.6 153.9 L88.2 154.1 L88.7 154.3 L89.3 154.5 L89.9 154.7 L90.5 154.9 L91.1 155.1 L91.6 155.3 L92.2 155.5 L92.8 155.7 L93.4 155.9 L94.0 156.1 L94.5 156.4 L95.1 156.6 L95.7 156.8 L96.3 157.0 L96.8 157.3 L97.4 157.5 L98.0 157.7 L98.6 158.0 L99.2 158.2 L99.7 158.5 L100.3 158.7 L100.9 159.0 L101.5 159.2 L102.1 159.5 L102.6 159.8 L103.2 160.0 L103.8 160.3 L104.4 160.6 L105.0 160.9 L105.5 161.2 L106.1 161.5 L106.7 161.8 L107.3 162.1 L107.8 162.4 L108.4 162.7 L109.0 163.0 L109.6 163.4 L110.2 163.7 L110.7 164.0 L111.3 164.4 L111.9 164.7 L112.5 165.1 L113.1 165.4 L113.6 165.8 L114.2 166.2 L114.8 166.6 L115.4 167.0 L116.0 167.4 L116.5 167.8 L117.1 168.2 L117.7 168.6 L118.3 169.0 L118.8 169.5 L119.4 169.9 L120.0 170.4 L120.6 170.8 L121.2 171.3 L121.7 171.8 L122.3 172.3 L122.9 172.8 L123.5 173.3 L124.1 173.8 L124.6 174.4 L125.2 174.9 L125.8 175.5 L126.4 176.1 L127.0 176.7 L127.5 177.3 L128.1 177.9 L128.7 178.5 L129.3 179.2 L129.8 179.8 L130.4 180.5 L131.0 181.2 L131.6 181.9 L132.2 182.7 L132.7 183.4 L133.3 184.2 L133.9 185.0 L134.5 185.8 L135.1 186.7 L135.6 187.5 L136.2 188.4 L136.8 189.3 L137.4 190.3 L138.0 191.2 L138.5 192.2 L139.1 193.3 L139.7 194.3 L140.3 195.4 L140.9 196.5 L141.4 197.7 L142.0 198.9 L142.6 200.1 L143.2 201.4 L143.7 202.8 L144.3 204.1 L144.9 205.6 L145.5 207.0 L146.1 208.6 L146.6 210.2 L147.2 211.8 L147.8 213.6 L148.4 215.3 L149.0 217.2 L149.5 219.2 L150.1 221.2 L150.7 223.3 L151.3 225.5 L151.9 227.8 L152.4 230.2 L153.0 232.8 L153.6 235.5 L154.2 238.3" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><path d="M199.8 11.7 L200.4 14.5 L201.0 17.2 L201.6 19.8 L202.1 22.2 L202.7 24.5 L203.3 26.7 L203.9 28.8 L204.5 30.8 L205.0 32.8 L205.6 34.7 L206.2 36.4 L206.8 38.2 L207.4 39.8 L207.9 41.4 L208.5 43.0 L209.1 44.4 L209.7 45.9 L210.3 47.2 L210.8 48.6 L211.4 49.9 L212.0 51.1 L212.6 52.3 L213.1 53.5 L213.7 54.6 L214.3 55.7 L214.9 56.7 L215.5 57.8 L216.0 58.8 L216.6 59.7 L217.2 60.7 L217.8 61.6 L218.4 62.5 L218.9 63.3 L219.5 64.2 L220.1 65.0 L220.7 65.8 L221.3 66.6 L221.8 67.3 L222.4 68.1 L223.0 68.8 L223.6 69.5 L224.2 70.2 L224.7 70.8 L225.3 71.5 L225.9 72.1 L226.5 72.7 L227.0 73.3 L227.6 73.9 L228.2 74.5 L228.8 75.1 L229.4 75.6 L229.9 76.2 L230.5 76.7 L231.1 77.2 L231.7 77.7 L232.3 78.2 L232.8 78.7 L233.4 79.2 L234.0 79.6 L234.6 80.1 L235.2 80.5 L235.7 81.0 L236.3 81.4 L236.9 81.8 L237.5 82.2 L238.0 82.6 L238.6 83.0 L239.2 83.4 L239.8 83.8 L240.4 84.2 L240.9 84.6 L241.5 84.9 L242.1 85.3 L242.7 85.6 L243.3 86.0 L243.8 86.3 L244.4 86.6 L245.0 87.0 L245.6 87.3 L246.2 87.6 L246.7 87.9 L247.3 88.2 L247.9 88.5 L248.5 88.8 L249.0 89.1 L249.6 89.4 L250.2 89.7 L250.8 90.0 L251.4 90.2 L251.9 90.5 L252.5 90.8 L253.1 91.0 L253.7 91.3 L254.3 91.5 L254.8 91.8 L255.4 92.0 L256.0 92.3 L256.6 92.5 L257.2 92.7 L257.7 93.0 L258.3 93.2 L258.9 93.4 L259.5 93.6 L260.0 93.9 L260.6 94.1 L261.2 94.3 L261.8 94.5 L262.4 94.7 L262.9 94.9 L263.5 95.1 L264.1 95.3 L264.7 95.5 L265.3 95.7 L265.8 95.9 L266.4 96.1 L267.0 96.3 L267.6 96.5 L268.2 96.6 L268.7 96.8 L269.3 97.0 L269.9 97.2 L270.5 97.3 L271.0 97.5 L271.6 97.7 L272.2 97.8 L272.8 98.0 L273.4 98.2 L273.9 98.3 L274.5 98.5 L275.1 98.6 L275.7 98.8 L276.3 98.9 L276.8 99.1 L277.4 99.2 L278.0 99.4 L278.6 99.5 L279.2 99.7 L279.7 99.8 L280.3 100.0 L280.9 100.1 L281.5 100.2 L282.0 100.4 L282.6 100.5 L283.2 100.7 L283.8 100.8 L284.4 100.9 L284.9 101.0 L285.5 101.2 L286.1 101.3 L286.7 101.4 L287.3 101.5 L287.8 101.7 L288.4 101.8 L289.0 101.9 L289.6 102.0 L290.2 102.1 L290.7 102.3 L291.3 102.4 L291.9 102.5 L292.5 102.6 L293.1 102.7 L293.6 102.8 L294.2 102.9 L294.8 103.0 L295.4 103.2 L295.9 103.3 L296.5 103.4 L297.1 103.5 L297.7 103.6 L298.3 103.7 L298.8 103.8 L299.4 103.9 L300.0 104.0 L300.6 104.1 L301.2 104.2 L301.7 104.3 L302.3 104.4 L302.9 104.5 L303.5 104.6 L304.1 104.6 L304.6 104.7 L305.2 104.8 L305.8 104.9 L306.4 105.0 L306.9 105.1 L307.5 105.2 L308.1 105.3 L308.7 105.4 L309.3 105.4 L309.8 105.5 L310.4 105.6 L311.0 105.7 L311.6 105.8 L312.2 105.9 L312.7 105.9 L313.3 106.0 L313.9 106.1 L314.5 106.2 L315.1 106.3 L315.6 106.3 L316.2 106.4 L316.8 106.5 L317.4 106.6 L317.9 106.7 L318.5 106.7 L319.1 106.8 L319.7 106.9 L320.3 107.0 L320.8 107.0 L321.4 107.1 L322.0 107.2" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><text x="175.0" y="248.0" text-anchor="end" font-size="12" font-weight="700" fill="#94a3b8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">x = 3</text><text x="318.0" y="117.0" text-anchor="end" font-size="12" font-weight="700" fill="#94a3b8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">y = 2</text></svg>
:::

> ⚠️ Ne confonds jamais les deux : une asymptote **verticale** a une équation en **x = …** (limite infinie en un point), une **horizontale** a une équation en **y = …** (limite finie à l''infini). L''asymptote oblique et l''étude complète des branches infinies appartiennent au chapitre «étude de fonctions» — plus tard dans ta quête.

## 🧮 Image d''un intervalle et théorème des valeurs intermédiaires

- L''**image d''un intervalle par une fonction continue est un intervalle** ; l''image du segment [a ; b] est le segment **[m ; M]**, où m est le minimum et M le maximum de f sur [a ; b] — et **pas forcément [f(a) ; f(b)]**.
- **Théorème des valeurs intermédiaires (TVI)** : si f est continue sur [a ; b], alors pour tout réel k compris entre f(a) et f(b), l''équation f(x) = k admet **au moins une** solution dans [a ; b].

::: figure f(x) = x³ + x − 3 sur [1 ; 2] : continue avec f(1) < 0 < f(2), donc elle s''annule en un α de ]1 ; 2[
<svg viewBox="0 0 340 260"><line x1="32.0" y1="181.0" x2="322.0" y2="181.0" stroke="#94a3b8" stroke-width="1.4" stroke-dasharray="5 3"/><path d="M32.0 181.0 H322.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M32.0 18.0 V232.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M322.0 181.0 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M32.0 18.0 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M32.0 220.9 L33.2 220.6 L34.4 220.3 L35.6 220.0 L36.8 219.7 L38.0 219.4 L39.1 219.1 L40.3 218.8 L41.5 218.4 L42.7 218.1 L43.9 217.8 L45.1 217.4 L46.3 217.1 L47.5 216.8 L48.7 216.4 L49.9 216.1 L51.1 215.7 L52.3 215.4 L53.4 215.0 L54.6 214.7 L55.8 214.3 L57.0 213.9 L58.2 213.6 L59.4 213.2 L60.6 212.8 L61.8 212.4 L63.0 212.0 L64.2 211.6 L65.4 211.2 L66.6 210.9 L67.8 210.5 L68.9 210.0 L70.1 209.6 L71.3 209.2 L72.5 208.8 L73.7 208.4 L74.9 208.0 L76.1 207.5 L77.3 207.1 L78.5 206.7 L79.7 206.2 L80.9 205.8 L82.0 205.3 L83.2 204.9 L84.4 204.4 L85.6 204.0 L86.8 203.5 L88.0 203.0 L89.2 202.6 L90.4 202.1 L91.6 201.6 L92.8 201.1 L94.0 200.6 L95.2 200.1 L96.3 199.6 L97.5 199.1 L98.7 198.6 L99.9 198.1 L101.1 197.6 L102.3 197.1 L103.5 196.5 L104.7 196.0 L105.9 195.5 L107.1 194.9 L108.3 194.4 L109.5 193.8 L110.6 193.3 L111.8 192.7 L113.0 192.2 L114.2 191.6 L115.4 191.0 L116.6 190.4 L117.8 189.9 L119.0 189.3 L120.2 188.7 L121.4 188.1 L122.6 187.5 L123.8 186.9 L125.0 186.2 L126.1 185.6 L127.3 185.0 L128.5 184.4 L129.7 183.7 L130.9 183.1 L132.1 182.5 L133.3 181.8 L134.5 181.2 L135.7 180.5 L136.9 179.8 L138.1 179.2 L139.3 178.5 L140.4 177.8 L141.6 177.1 L142.8 176.4 L144.0 175.7 L145.2 175.0 L146.4 174.3 L147.6 173.6 L148.8 172.9 L150.0 172.2 L151.2 171.4 L152.4 170.7 L153.6 170.0 L154.7 169.2 L155.9 168.5 L157.1 167.7 L158.3 166.9 L159.5 166.2 L160.7 165.4 L161.9 164.6 L163.1 163.8 L164.3 163.0 L165.5 162.2 L166.7 161.4 L167.8 160.6 L169.0 159.8 L170.2 159.0 L171.4 158.1 L172.6 157.3 L173.8 156.5 L175.0 155.6 L176.2 154.8 L177.4 153.9 L178.6 153.0 L179.8 152.2 L181.0 151.3 L182.1 150.4 L183.3 149.5 L184.5 148.6 L185.7 147.7 L186.9 146.8 L188.1 145.9 L189.3 144.9 L190.5 144.0 L191.7 143.1 L192.9 142.1 L194.1 141.2 L195.3 140.2 L196.5 139.3 L197.6 138.3 L198.8 137.3 L200.0 136.3 L201.2 135.4 L202.4 134.4 L203.6 133.4 L204.8 132.4 L206.0 131.3 L207.2 130.3 L208.4 129.3 L209.6 128.2 L210.8 127.2 L211.9 126.2 L213.1 125.1 L214.3 124.0 L215.5 123.0 L216.7 121.9 L217.9 120.8 L219.1 119.7 L220.3 118.6 L221.5 117.5 L222.7 116.4 L223.9 115.3 L225.0 114.1 L226.2 113.0 L227.4 111.9 L228.6 110.7 L229.8 109.6 L231.0 108.4 L232.2 107.2 L233.4 106.0 L234.6 104.8 L235.8 103.7 L237.0 102.5 L238.2 101.2 L239.4 100.0 L240.5 98.8 L241.7 97.6 L242.9 96.3 L244.1 95.1 L245.3 93.8 L246.5 92.6 L247.7 91.3 L248.9 90.0 L250.1 88.7 L251.3 87.4 L252.5 86.1 L253.6 84.8 L254.8 83.5 L256.0 82.2 L257.2 80.9 L258.4 79.5 L259.6 78.2 L260.8 76.8 L262.0 75.5 L263.2 74.1 L264.4 72.7 L265.6 71.3 L266.8 69.9 L267.9 68.5 L269.1 67.1 L270.3 65.7 L271.5 64.2 L272.7 62.8 L273.9 61.4 L275.1 59.9 L276.3 58.4 L277.5 57.0 L278.7 55.5 L279.9 54.0 L281.1 52.5 L282.2 51.0 L283.4 49.5 L284.6 48.0 L285.8 46.4 L287.0 44.9 L288.2 43.4 L289.4 41.8 L290.6 40.2 L291.8 38.7 L293.0 37.1 L294.2 35.5 L295.4 33.9 L296.5 32.3 L297.7 30.7 L298.9 29.0 L300.1 27.4 L301.3 25.8 L302.5 24.1 L303.7 22.5 L304.9 20.8 L306.1 19.1 L307.3 17.4 L308.5 15.7 L309.7 14.0 L310.8 12.3 L312.0 10.6 L313.2 8.8" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><circle cx="92.0" cy="201.4" r="4" fill="#0f172a"/><circle cx="292.0" cy="38.4" r="4" fill="#0f172a"/><circle cx="134.7" cy="181.0" r="4.5" fill="#0f6e56"/><text x="84.0" y="203.42857142857144" text-anchor="end" font-size="12" font-weight="700" fill="#b45309" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">f(1)<0</text><text x="286.0" y="40.38095238095238" text-anchor="end" font-size="12" font-weight="700" fill="#0f6e56" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">f(2)>0</text><text x="134.68233255244598" y="199.04761904761904" text-anchor="middle" font-size="14" font-weight="700" fill="#0f6e56" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">α</text><text x="92.0" y="248.0" text-anchor="middle" font-size="11" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><text x="292.0" y="248.0" text-anchor="middle" font-size="11" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text></svg>
:::

- Cas clé : si f est continue sur [a ; b] et f(a) · f(b) < 0, alors f **s''annule au moins une fois** sur [a ; b].
- **Corollaire (bijection)** : si f est continue **et strictement monotone** sur [a ; b], alors pour tout k compris entre f(a) et f(b), l''équation f(x) = k admet une **unique** solution dans [a ; b].

> 🗡️ Sans la dérivée à ton arc (elle arrive dans deux chapitres), la stricte monotonie se justifie par les fonctions usuelles et les opérations : une somme de fonctions strictement croissantes est strictement croissante.

_Exemple_ : f(x) = x³ + x − 3 est continue et strictement croissante sur [1 ; 2] (somme de x ↦ x³ et de x ↦ x − 3, toutes deux strictement croissantes) ; f(1) = −1 < 0 < f(2) = 7, donc l''équation f(x) = 0 admet une **unique** solution α dans [1 ; 2].

## 🧪 Prolongement par continuité et dichotomie

- **Prolongement par continuité** : si f n''est pas définie en a mais si lim x→a f(x) = ℓ avec ℓ **fini**, la fonction g définie par g(x) = f(x) pour x ≠ a et g(a) = ℓ est continue en a : c''est le prolongement par continuité de f en a. _Exemple_ : f(x) = (√(x + 1) − 1)/x n''est pas définie en 0 ; l''expression conjuguée donne f(x) = 1/(√(x + 1) + 1), donc lim x→0 f(x) = 1/2 : f se prolonge par continuité en 0 en posant g(0) = 1/2.
- **Dichotomie (balayage)** : pour encadrer la solution α de f(x) = 0 sur [a ; b], on calcule f au milieu c = (a + b)/2 et on garde la moitié où f change de signe. Chaque étape divise la longueur de l''intervalle par 2 ; on poursuit jusqu''à obtenir une **valeur approchée à 10⁻ⁿ près**. _Exemple_ : pour f(x) = x³ + x − 3, on a f(1) = −1 < 0 et f(1,5) = 1,875 > 0, donc α ∈ ]1 ; 1,5[.

> 🏆 Première porte franchie, héros : tu sais dompter l''infini, lever les indéterminations et capturer les solutions à la précision voulue. Les suites réelles t''attendent au prochain chapitre — l''Analyse ne fait que commencer.', '# 📜 Résumé : Continuité et limites

<svg viewBox="0 0 340 260"><line x1="177.0" y1="18.0" x2="177.0" y2="232.0" stroke="#94a3b8" stroke-width="1.6" stroke-dasharray="6 4"/><line x1="32.0" y1="125.0" x2="322.0" y2="125.0" stroke="#94a3b8" stroke-width="1.6" stroke-dasharray="6 4"/><path d="M32.0 155.6 H322.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M104.5 18.0 V232.0" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M322.0 155.6 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M104.5 18.0 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M32.0 142.8 L32.6 142.9 L33.2 143.0 L33.7 143.0 L34.3 143.1 L34.9 143.2 L35.5 143.3 L36.1 143.3 L36.6 143.4 L37.2 143.5 L37.8 143.6 L38.4 143.7 L38.9 143.7 L39.5 143.8 L40.1 143.9 L40.7 144.0 L41.3 144.1 L41.8 144.1 L42.4 144.2 L43.0 144.3 L43.6 144.4 L44.2 144.5 L44.7 144.6 L45.3 144.6 L45.9 144.7 L46.5 144.8 L47.1 144.9 L47.6 145.0 L48.2 145.1 L48.8 145.2 L49.4 145.3 L49.9 145.4 L50.5 145.4 L51.1 145.5 L51.7 145.6 L52.3 145.7 L52.8 145.8 L53.4 145.9 L54.0 146.0 L54.6 146.1 L55.2 146.2 L55.7 146.3 L56.3 146.4 L56.9 146.5 L57.5 146.6 L58.1 146.7 L58.6 146.8 L59.2 147.0 L59.8 147.1 L60.4 147.2 L60.9 147.3 L61.5 147.4 L62.1 147.5 L62.7 147.6 L63.3 147.7 L63.8 147.9 L64.4 148.0 L65.0 148.1 L65.6 148.2 L66.2 148.3 L66.7 148.5 L67.3 148.6 L67.9 148.7 L68.5 148.8 L69.1 149.0 L69.6 149.1 L70.2 149.2 L70.8 149.3 L71.4 149.5 L72.0 149.6 L72.5 149.8 L73.1 149.9 L73.7 150.0 L74.3 150.2 L74.8 150.3 L75.4 150.5 L76.0 150.6 L76.6 150.8 L77.2 150.9 L77.7 151.1 L78.3 151.2 L78.9 151.4 L79.5 151.5 L80.1 151.7 L80.6 151.8 L81.2 152.0 L81.8 152.2 L82.4 152.3 L83.0 152.5 L83.5 152.7 L84.1 152.8 L84.7 153.0 L85.3 153.2 L85.8 153.4 L86.4 153.5 L87.0 153.7 L87.6 153.9 L88.2 154.1 L88.7 154.3 L89.3 154.5 L89.9 154.7 L90.5 154.9 L91.1 155.1 L91.6 155.3 L92.2 155.5 L92.8 155.7 L93.4 155.9 L94.0 156.1 L94.5 156.4 L95.1 156.6 L95.7 156.8 L96.3 157.0 L96.8 157.3 L97.4 157.5 L98.0 157.7 L98.6 158.0 L99.2 158.2 L99.7 158.5 L100.3 158.7 L100.9 159.0 L101.5 159.2 L102.1 159.5 L102.6 159.8 L103.2 160.0 L103.8 160.3 L104.4 160.6 L105.0 160.9 L105.5 161.2 L106.1 161.5 L106.7 161.8 L107.3 162.1 L107.8 162.4 L108.4 162.7 L109.0 163.0 L109.6 163.4 L110.2 163.7 L110.7 164.0 L111.3 164.4 L111.9 164.7 L112.5 165.1 L113.1 165.4 L113.6 165.8 L114.2 166.2 L114.8 166.6 L115.4 167.0 L116.0 167.4 L116.5 167.8 L117.1 168.2 L117.7 168.6 L118.3 169.0 L118.8 169.5 L119.4 169.9 L120.0 170.4 L120.6 170.8 L121.2 171.3 L121.7 171.8 L122.3 172.3 L122.9 172.8 L123.5 173.3 L124.1 173.8 L124.6 174.4 L125.2 174.9 L125.8 175.5 L126.4 176.1 L127.0 176.7 L127.5 177.3 L128.1 177.9 L128.7 178.5 L129.3 179.2 L129.8 179.8 L130.4 180.5 L131.0 181.2 L131.6 181.9 L132.2 182.7 L132.7 183.4 L133.3 184.2 L133.9 185.0 L134.5 185.8 L135.1 186.7 L135.6 187.5 L136.2 188.4 L136.8 189.3 L137.4 190.3 L138.0 191.2 L138.5 192.2 L139.1 193.3 L139.7 194.3 L140.3 195.4 L140.9 196.5 L141.4 197.7 L142.0 198.9 L142.6 200.1 L143.2 201.4 L143.7 202.8 L144.3 204.1 L144.9 205.6 L145.5 207.0 L146.1 208.6 L146.6 210.2 L147.2 211.8 L147.8 213.6 L148.4 215.3 L149.0 217.2 L149.5 219.2 L150.1 221.2 L150.7 223.3 L151.3 225.5 L151.9 227.8 L152.4 230.2 L153.0 232.8 L153.6 235.5 L154.2 238.3" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><path d="M199.8 11.7 L200.4 14.5 L201.0 17.2 L201.6 19.8 L202.1 22.2 L202.7 24.5 L203.3 26.7 L203.9 28.8 L204.5 30.8 L205.0 32.8 L205.6 34.7 L206.2 36.4 L206.8 38.2 L207.4 39.8 L207.9 41.4 L208.5 43.0 L209.1 44.4 L209.7 45.9 L210.3 47.2 L210.8 48.6 L211.4 49.9 L212.0 51.1 L212.6 52.3 L213.1 53.5 L213.7 54.6 L214.3 55.7 L214.9 56.7 L215.5 57.8 L216.0 58.8 L216.6 59.7 L217.2 60.7 L217.8 61.6 L218.4 62.5 L218.9 63.3 L219.5 64.2 L220.1 65.0 L220.7 65.8 L221.3 66.6 L221.8 67.3 L222.4 68.1 L223.0 68.8 L223.6 69.5 L224.2 70.2 L224.7 70.8 L225.3 71.5 L225.9 72.1 L226.5 72.7 L227.0 73.3 L227.6 73.9 L228.2 74.5 L228.8 75.1 L229.4 75.6 L229.9 76.2 L230.5 76.7 L231.1 77.2 L231.7 77.7 L232.3 78.2 L232.8 78.7 L233.4 79.2 L234.0 79.6 L234.6 80.1 L235.2 80.5 L235.7 81.0 L236.3 81.4 L236.9 81.8 L237.5 82.2 L238.0 82.6 L238.6 83.0 L239.2 83.4 L239.8 83.8 L240.4 84.2 L240.9 84.6 L241.5 84.9 L242.1 85.3 L242.7 85.6 L243.3 86.0 L243.8 86.3 L244.4 86.6 L245.0 87.0 L245.6 87.3 L246.2 87.6 L246.7 87.9 L247.3 88.2 L247.9 88.5 L248.5 88.8 L249.0 89.1 L249.6 89.4 L250.2 89.7 L250.8 90.0 L251.4 90.2 L251.9 90.5 L252.5 90.8 L253.1 91.0 L253.7 91.3 L254.3 91.5 L254.8 91.8 L255.4 92.0 L256.0 92.3 L256.6 92.5 L257.2 92.7 L257.7 93.0 L258.3 93.2 L258.9 93.4 L259.5 93.6 L260.0 93.9 L260.6 94.1 L261.2 94.3 L261.8 94.5 L262.4 94.7 L262.9 94.9 L263.5 95.1 L264.1 95.3 L264.7 95.5 L265.3 95.7 L265.8 95.9 L266.4 96.1 L267.0 96.3 L267.6 96.5 L268.2 96.6 L268.7 96.8 L269.3 97.0 L269.9 97.2 L270.5 97.3 L271.0 97.5 L271.6 97.7 L272.2 97.8 L272.8 98.0 L273.4 98.2 L273.9 98.3 L274.5 98.5 L275.1 98.6 L275.7 98.8 L276.3 98.9 L276.8 99.1 L277.4 99.2 L278.0 99.4 L278.6 99.5 L279.2 99.7 L279.7 99.8 L280.3 100.0 L280.9 100.1 L281.5 100.2 L282.0 100.4 L282.6 100.5 L283.2 100.7 L283.8 100.8 L284.4 100.9 L284.9 101.0 L285.5 101.2 L286.1 101.3 L286.7 101.4 L287.3 101.5 L287.8 101.7 L288.4 101.8 L289.0 101.9 L289.6 102.0 L290.2 102.1 L290.7 102.3 L291.3 102.4 L291.9 102.5 L292.5 102.6 L293.1 102.7 L293.6 102.8 L294.2 102.9 L294.8 103.0 L295.4 103.2 L295.9 103.3 L296.5 103.4 L297.1 103.5 L297.7 103.6 L298.3 103.7 L298.8 103.8 L299.4 103.9 L300.0 104.0 L300.6 104.1 L301.2 104.2 L301.7 104.3 L302.3 104.4 L302.9 104.5 L303.5 104.6 L304.1 104.6 L304.6 104.7 L305.2 104.8 L305.8 104.9 L306.4 105.0 L306.9 105.1 L307.5 105.2 L308.1 105.3 L308.7 105.4 L309.3 105.4 L309.8 105.5 L310.4 105.6 L311.0 105.7 L311.6 105.8 L312.2 105.9 L312.7 105.9 L313.3 106.0 L313.9 106.1 L314.5 106.2 L315.1 106.3 L315.6 106.3 L316.2 106.4 L316.8 106.5 L317.4 106.6 L317.9 106.7 L318.5 106.7 L319.1 106.8 L319.7 106.9 L320.3 107.0 L320.8 107.0 L321.4 107.1 L322.0 107.2" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><text x="175.0" y="248.0" text-anchor="end" font-size="12" font-weight="700" fill="#94a3b8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">x = 3</text><text x="318.0" y="117.0" text-anchor="end" font-size="12" font-weight="700" fill="#94a3b8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">y = 2</text></svg>

- **Continuité en a** : lim x→a f(x) = f(a) ; continuité à droite et à gauche ; f continue sur I = continue en tout point de I ; polynômes, fonctions rationnelles, √, |x|, sin et cos sont continues sur leur domaine.
- **Opérations** : somme, produit, quotient (dénominateur non nul) et composée u ∘ v de fonctions continues sont continues.
- **Formes indéterminées** : ∞ − ∞, 0 × ∞, ∞/∞, 0/0 → transformer avant de conclure : terme de plus haut degré, factorisation, expression conjuguée ; limite infinie en un point : étudier le signe du dénominateur de part et d''autre.
- **Gendarmes** : u ≤ f ≤ v et lim u = lim v = ℓ ⇒ lim f = ℓ ; théorèmes de comparaison pour les limites infinies ; **composée** : lim x→a v(x) = b et lim y→b u(y) = ℓ ⇒ lim x→a u(v(x)) = ℓ.
- **Asymptotes** : limite infinie en un point a ⇒ verticale x = a ; limite finie ℓ en ±∞ ⇒ horizontale y = ℓ (l''asymptote oblique relève du chapitre étude de fonctions).
- **Image d''un intervalle** : l''image de [a ; b] par f continue est [m ; M] (minimum ; maximum), pas forcément [f(a) ; f(b)].
- **TVI** : f continue sur [a ; b] et k compris entre f(a) et f(b) ⇒ f(x) = k admet au moins une solution ; f(a) · f(b) < 0 ⇒ f s''annule au moins une fois.
- **Corollaire de la bijection** : f continue **et strictement monotone** ⇒ solution unique (l''unicité exige la stricte monotonie, jamais le TVI seul).
- **Prolongement par continuité** : lim x→a f(x) = ℓ fini ⇒ g égale à f hors de a avec g(a) = ℓ est continue en a.
- **Dichotomie** : couper [a ; b] au milieu, garder la moitié où f change de signe → valeur approchée de α à 10⁻ⁿ près.', 1, NULL, '[]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref,
  videos = EXCLUDED.videos;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref, videos) VALUES
  ('9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', 'Suites réelles — apprivoiser l''infini pas à pas', 'Rappels sur les suites arithmétiques et géométriques, raisonnement par récurrence, suites majorées, minorées et bornées, limite d''une suite et sous-suites paire/impaire, opérations sur les limites, limites des suites géométriques, suites du type Vₙ = f(Uₙ), théorèmes de comparaison, des gendarmes et de la valeur absolue, convergence des suites monotones, suites récurrentes Uₙ₊₁ = f(Uₙ) et point fixe, suites adjacentes', '# ⚔️ Suites réelles — apprivoiser l''infini pas à pas

> 💡 «Une suite, c''est une armée de nombres qui avance vers l''infini : apprends à lire sa destination et tu domineras tout le combat.»

Tu as franchi la porte de l''Analyse avec les fonctions ; voici son second grand domaine, celui qui reviendra à coup sûr le jour du concours. Une **suite réelle** (Uₙ) est une fonction qui à chaque entier n associe un réel Uₙ. Ici, une seule question compte vraiment : **vers quoi tend (Uₙ) quand n grandit sans fin ?** Tu vas forger les outils pour répondre — récurrence, encadrements, monotonie, point fixe, suites adjacentes — et t''en servir jusqu''au dernier chapitre de l''année.

## 🏰 Le raisonnement par récurrence

C''est ton arme de base : elle prouve qu''une propriété P(n) est vraie pour **tous** les entiers n ≥ n₀, sans les tester un par un. Trois étapes obligatoires :

- **Initialisation** : on vérifie que P(n₀) est vraie (souvent n₀ = 0 ou 1).
- **Hérédité** : on suppose P(n) vraie pour un entier n ≥ n₀ quelconque (l''**hypothèse de récurrence**), et on démontre que P(n + 1) l''est aussi.
- **Conclusion** : P(n) est alors vraie pour tout entier n ≥ n₀.

_Exemple détaillé_ — montrons que pour tout n ≥ 1, 1 + 2 + 3 + … + n = n(n + 1)/2.

**Initialisation** : pour n = 1, le membre de gauche vaut 1 et n(n + 1)/2 = 1 × 2/2 = 1. ✓

**Hérédité** : supposons 1 + 2 + … + n = n(n + 1)/2. On ajoute (n + 1) aux deux membres :

$$ 1 + 2 + … + n + (n + 1) = n(n + 1)/2 + (n + 1) = (n + 1)(n + 2)/2 $$

C''est exactement la formule au rang n + 1 : la propriété se transmet, elle est donc vraie pour tout n ≥ 1.

> ⚠️ Sans l''**initialisation**, l''hérédité seule ne prouve rien : une propriété peut « s''hériter » tout en étant fausse partout si aucun premier cas ne la déclenche.

## 🗡️ Rappels : suites arithmétiques et géométriques

Tu les connais depuis la 3ème ; elles sont le socle de tout le chapitre.

| Type                        | Relation      | Terme général | Somme des termes                             |
| --------------------------- | ------------- | ------------- | -------------------------------------------- |
| **Arithmétique** (raison r) | Uₙ₊₁ = Uₙ + r | Uₙ = U₀ + nr  | (nombre de termes) × (premier + dernier) / 2 |
| **Géométrique** (raison q)  | Uₙ₊₁ = q × Uₙ | Uₙ = U₀ × qⁿ  | U₀ × (1 − q^(n+1))/(1 − q), pour q ≠ 1       |

En particulier, la somme géométrique de référence (q ≠ 1) :

$$ 1 + q + q² + … + qⁿ = (1 − q^(n+1))/(1 − q) $$

_Exemple_ : 1 + 5/3 + (5/3)² + … + (5/3)ⁿ = (1 − (5/3)^(n+1))/(1 − 5/3) = (3/2)((5/3)^(n+1) − 1).

**Notation Σ.** Pour écrire une longue somme sans pointillés, on utilise le symbole **sigma** :

$$ Σ (k = 1 → n) aₖ = a₁ + a₂ + … + aₙ $$

_Exemple_ : Σ (k = 1 → n) k = 1 + 2 + … + n = n(n + 1)/2.

## ⚡ Suites majorées, minorées, bornées et monotonie

Avant de parler de limite, on décrit la « forme » de la suite.

- (Uₙ) est **majorée** s''il existe un réel M tel que Uₙ ≤ M pour tout n ; **minorée** s''il existe m tel que Uₙ ≥ m pour tout n.
- (Uₙ) est **bornée** si elle est à la fois majorée et minorée : il existe m et M tels que m ≤ Uₙ ≤ M pour tout n. De façon équivalente, il existe un réel K > 0 tel que |Uₙ| ≤ K.
- (Uₙ) est **croissante** si Uₙ₊₁ ≥ Uₙ pour tout n ; **décroissante** si Uₙ₊₁ ≤ Uₙ pour tout n ; **monotone** si elle est croissante ou décroissante.

_Exemple_ : pour Uₙ = (−1)ⁿ, on a −1 ≤ Uₙ ≤ 1 : la suite est **bornée**. Elle n''est ni croissante ni décroissante (elle alterne).

> 🗡️ Pour étudier la monotonie, calcule le **signe de Uₙ₊₁ − Uₙ**. Si les termes sont strictement positifs, tu peux aussi comparer le **quotient Uₙ₊₁/Uₙ à 1**.

## 🔮 Limite d''une suite : convergence et divergence

Dire que **lim Uₙ = a** (a fini) signifie que Uₙ devient aussi proche de a qu''on veut dès que n est assez grand : la suite est alors **convergente**. Si Uₙ dépasse tout seuil (respectivement descend sous tout seuil), on écrit **lim Uₙ = +∞** (respectivement −∞) : la suite **diverge** vers l''infini. Une suite qui n''a aucune limite (finie ou infinie) est aussi dite divergente.

> **Encadré** — « La limite d''une suite (Uₙ) ne dépend que des grandes valeurs de n. »

Autrement dit, modifier les premiers termes ne change jamais la limite. Un outil décisif en découle : on **découpe** la suite selon les indices pairs et impairs.

> **Théorème (sous-suites paire et impaire)** — « Soit (Uₙ) une suite réelle et a fini ou infini. lim Uₙ = a si et seulement si lim U₂ₙ = a et lim U₂ₙ₊₁ = a. »

_Exemple_ : pour Uₙ = (−1)ⁿ, on a U₂ₙ = 1 → 1 et U₂ₙ₊₁ = −1 → −1. Les deux limites diffèrent : **(Uₙ) n''a pas de limite**.

Deux propriétés fondamentales encadrent toute suite convergente :

> **Théorème** — « Toute suite convergente est bornée. »

> **Théorème (signe de la limite)** — « Soit (Uₙ) convergente vers un réel a. S''il existe N₀ tel que Uₙ ≥ 0 pour tout n ≥ N₀, alors a ≥ 0. S''il existe N₀ tel que Uₙ ≤ 0 pour tout n ≥ N₀, alors a ≤ 0. »

> **Conséquence (passage à la limite dans un encadrement)** — si m ≤ Uₙ ≤ M à partir d''un certain rang et si (Uₙ) converge vers a, alors **m ≤ a ≤ M**.

> ⚠️ Les inégalités **strictes** ne se conservent pas à la limite : Uₙ = 1/n vérifie Uₙ > 0 pour tout n, pourtant sa limite est 0, pas strictement positive. À la limite, `<` devient `≤`.

## 🧮 Opérations sur les limites

On combine les limites connues comme pour les fonctions. En notant a, b des réels :

| Opération                 | Résultats (hors formes indéterminées)                                       |
| ------------------------- | --------------------------------------------------------------------------- |
| **Somme** lim(Uₙ + Vₙ)    | a + b ; (+∞) + b = +∞ ; (−∞) + b = −∞ ; (+∞) + (+∞) = +∞ ; (−∞) + (−∞) = −∞ |
| **Produit** lim(Uₙ × Vₙ)  | ab ; ∞ × (b ≠ 0) = ∞ (règle des signes) ; ∞ × ∞ = ∞ (règle des signes)      |
| **Quotient** lim(Uₙ / Vₙ) | a/b (b ≠ 0) ; ∞/(b ≠ 0) = ∞ ; a/(±∞) = 0 ; (a ≠ 0)/0 = ∞ (règle des signes) |

Les **formes indéterminées** sont les mêmes que pour les fonctions : **∞ − ∞**, **0 × ∞**, **∞/∞**, **0/0**. Face à elles, on transforme l''expression (terme dominant, factorisation, quantité conjuguée) avant de conclure.

_Exemple_ : Uₙ = (n² − 3n)/(2n² + 1). On divise par le terme dominant : Uₙ = (1 − 3/n)/(2 + 1/n²) → (1 − 0)/(2 + 0) = 1/2.

## 📐 La limite de référence : suites géométriques qⁿ

Une seule limite à mémoriser gouverne quasiment toutes les suites du chapitre.

> **Théorème** — « Soit Uₙ = qⁿ, n ≥ 0, q réel non nul. Si q > 1, alors lim qⁿ = +∞. Si |q| < 1, alors lim qⁿ = 0. Si q ≤ −1, alors (qⁿ) n''a pas de limite. Si q = 1, alors (qⁿ) est constante égale à 1. »

_Exemple_ : (1/5)ⁿ → 0 car |1/5| < 1 ; (√π)ⁿ → +∞ car √π > 1 ; ((−√5)/2)ⁿ n''a pas de limite car |−√5/2| = √5/2 > 1 et la base est négative (l''amplitude grandit et le signe alterne).

> ⚠️ Ne confonds pas |q| < 1 et q < 1 : pour q = −3, on a q < 1 mais |q| = 3 > 1, donc (qⁿ) **ne tend pas** vers 0 — elle diverge en alternant de signe.

## 🔮 Suites du type Vₙ = f(Uₙ) : continuité et composition

Beaucoup de suites s''écrivent Vₙ = f(Uₙ). On calcule leur limite en « faisant passer » la limite à travers f, à condition de contrôler f près de la limite de (Uₙ).

> **Théorème (continuité)** — « Soit f continue sur un intervalle ouvert I et (Uₙ) une suite d''éléments de I. Si (Uₙ) tend vers un réel a de I, alors (f(Uₙ)) tend vers f(a). »

> **Théorème (composition limite ∘ suite)** — « Soit f définie sur I et (Uₙ) d''éléments de I. Si lim Uₙ = ℓ (fini ou infini) et si lim (x → ℓ) f(x) = L (fini ou infini), alors lim f(Uₙ) = L. »

_Exemple_ : Uₙ = n × sin(π/(2n)). Posons xₙ = π/(2n) → 0. Alors Uₙ = (π/2) × sin(xₙ)/xₙ. Comme sin(x)/x → 1 quand x → 0 (rappel de 3ème), on obtient lim Uₙ = π/2.

## 🛡️ Limites et ordre : comparaison, gendarmes, valeur absolue

Quand une limite résiste au calcul direct, on **encadre** la suite entre deux suites plus simples.

> **Théorème (comparaison des limites finies)** — « Soit (Uₙ) et (Vₙ) convergeant vers a et b. S''il existe N₀ tel que Uₙ ≤ Vₙ pour tout n ≥ N₀, alors a ≤ b. »

> **Théorème des gendarmes (encadrement)** — « Soit (Uₙ), (Vₙ), (Wₙ) et a un réel. S''il existe N₀ tel que Vₙ ≤ Uₙ ≤ Wₙ pour tout n ≥ N₀, et si lim Vₙ = lim Wₙ = a, alors lim Uₙ = a. »

> **Corollaire (valeur absolue)** — « Si 0 ≤ |Uₙ| ≤ Vₙ à partir d''un certain rang et si lim Vₙ = 0, alors lim Uₙ = 0. »

> **Théorème (comparaison vers l''infini)** — « Si Uₙ ≤ Vₙ à partir d''un rang et si lim Uₙ = +∞, alors lim Vₙ = +∞. Si Uₙ ≤ Vₙ à partir d''un rang et si lim Vₙ = −∞, alors lim Uₙ = −∞. »

_Exemple (gendarmes)_ : Uₙ = 1/(n + cos n). Comme −1 ≤ cos n ≤ 1, on a n − 1 ≤ n + cos n, donc pour n ≥ 2, 0 ≤ Uₙ ≤ 1/(n − 1). Les deux bornes tendent vers 0, donc **lim Uₙ = 0**.

_Exemple (valeur absolue)_ : Vₙ = (cos(5n) + sin(2n))/(5n² + 1). Alors 0 ≤ |Vₙ| ≤ 2/(5n² + 1) → 0, donc **lim Vₙ = 0**.

## 🧗 Convergence des suites monotones

Voici le théorème qui « fabrique » des limites sans les calculer — l''outil clé des suites récurrentes.

> **Théorème (admis)** — « Si (Uₙ) est croissante et majorée, alors elle converge vers un réel a, et Uₙ ≤ a pour tout n. Si (Uₙ) est décroissante et minorée, alors elle converge vers un réel b, et Uₙ ≥ b pour tout n. »

> **Théorème** — « Toute suite croissante et non majorée tend vers +∞. Toute suite décroissante et non minorée tend vers −∞. »

_Exemple_ : la suite Uₙ = 1 + 1/2 + 1/3 + … + 1/n est croissante (on ajoute 1/(n + 1) > 0). On montre qu''elle **n''est pas majorée** ; par le second théorème, **lim Uₙ = +∞**.

> ⚠️ « Croissante et majorée » garantit la convergence, mais **pas** que la limite vaut le majorant : Uₙ = 1 − 1/n est majorée par 100, et pourtant sa limite est 1. Le théorème donne l''**existence** d''une limite, pas sa valeur.

## 🌀 Suites récurrentes Uₙ₊₁ = f(Uₙ) et point fixe

Une suite **récurrente** est définie par un premier terme et une relation Uₙ₊₁ = f(Uₙ). La stratégie type est en trois temps : montrer par récurrence que (Uₙ) reste dans un intervalle, prouver qu''elle est monotone et bornée (donc convergente), puis trouver la limite grâce au théorème du **point fixe**.

> **Théorème (point fixe)** — « Soit (Uₙ) vérifiant Uₙ₊₁ = f(Uₙ), n ≥ 0, où f est une fonction. Si (Uₙ) converge vers un réel a et si f est continue en a, alors a = f(a). »

La limite est donc à chercher parmi les **solutions de l''équation f(x) = x**.

::: figure L''escalier grimpe entre la courbe y = f(x) et la droite y = x : les termes U₀, U₁, U₂ montent vers le point fixe ℓ, où les deux courbes se croisent
<svg viewBox="0 0 330 250"><path d="M45 210 H310" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M45 210 V25" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M310 210 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M45 25 l-3.5 7 l7 0 z" fill="#0f172a"/><line x1="45" y1="210" x2="230" y2="40" stroke="#94a3b8" stroke-width="1.6" stroke-dasharray="6 4"/><text x="236" y="42" font-size="12" font-weight="700" fill="#94a3b8">y = x</text><path d="M45 150 Q 120 78 200 62 T 300 50" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linecap="round"/><text x="120" y="72" font-size="12" font-weight="700" fill="#0f6e56">y = f(x)</text><polyline points="75,210 75,130 130,130 130,102 158,102 158,88 172,88 172,79" fill="none" stroke="#b45309" stroke-width="2" stroke-linejoin="round"/><circle cx="185" cy="70" r="4" fill="#0f172a"/><line x1="185" y1="70" x2="185" y2="210" stroke="#94a3b8" stroke-width="1.1" stroke-dasharray="3 3"/><text x="185" y="226" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">ℓ</text><text x="75" y="226" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">U₀</text><text x="130" y="226" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">U₁</text><text x="160" y="226" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">U₂</text></svg>
:::

_Exemple_ : U₀ = 1 et Uₙ₊₁ = √(Uₙ + 1). On montre par récurrence que 1 ≤ Uₙ ≤ 2, que (Uₙ) est croissante, donc croissante et majorée : elle **converge** vers un réel ℓ. Comme f : x ↦ √(x + 1) est continue, ℓ vérifie ℓ = √(ℓ + 1), soit ℓ² − ℓ − 1 = 0 avec ℓ ≥ 0 : **ℓ = (1 + √5)/2**.

> ⚠️ Trouver le point fixe ne prouve **jamais** à lui seul que la suite converge. L''équation a = f(a) ne donne la limite **qu''après** avoir établi que (Uₙ) converge (via monotone + bornée). Sauter cette étape est l''erreur la plus sanctionnée du chapitre.

## 🎯 Suites adjacentes

Deux suites qui se rapprochent l''une de l''autre en « pinçant » un réel finissent par le capturer ensemble — c''est l''idée des suites adjacentes, l''outil des valeurs approchées (approximation de e, de √a…).

> **Définition et théorème** — « Deux suites (Uₙ) et (Vₙ) sont **adjacentes** lorsque : pour tout n, Uₙ ≤ Vₙ ; (Uₙ) est croissante et (Vₙ) est décroissante ; (Vₙ − Uₙ) converge vers 0. Dans ce cas, (Uₙ) et (Vₙ) convergent vers la **même limite**. »

::: figure (Uₙ) monte par la gauche, (Vₙ) descend par la droite ; l''écart Vₙ − Uₙ s''annule et les deux suites enferment la même limite α
<svg viewBox="0 0 340 130"><path d="M25 70 H325" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M325 70 l-7 -3.5 l0 7 z" fill="#0f172a"/><line x1="180" y1="42" x2="180" y2="70" stroke="#0f172a" stroke-width="1.6"/><text x="180" y="34" text-anchor="middle" font-size="13" font-weight="700" fill="#0f172a">α</text><circle cx="55" cy="70" r="3.5" fill="#0f6e56"/><circle cx="98" cy="70" r="3.5" fill="#0f6e56"/><circle cx="132" cy="70" r="3.5" fill="#0f6e56"/><circle cx="158" cy="70" r="3.5" fill="#0f6e56"/><text x="55" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#0f6e56">U₀</text><text x="98" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#0f6e56">U₁</text><text x="132" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#0f6e56">U₂</text><path d="M60 62 H150" fill="none" stroke="#0f6e56" stroke-width="1.4"/><path d="M150 62 l-7 -3 l0 6 z" fill="#0f6e56"/><circle cx="305" cy="70" r="3.5" fill="#b45309"/><circle cx="262" cy="70" r="3.5" fill="#b45309"/><circle cx="228" cy="70" r="3.5" fill="#b45309"/><circle cx="202" cy="70" r="3.5" fill="#b45309"/><text x="305" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">V₀</text><text x="262" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">V₁</text><text x="228" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">V₂</text><path d="M300 62 H210" fill="none" stroke="#b45309" stroke-width="1.4"/><path d="M210 62 l7 -3 l0 6 z" fill="#b45309"/></svg>
:::

_Exemple_ : Uₙ = 1 + 1/1! + 1/2! + … + 1/n! et Vₙ = Uₙ + 1/(n × n!). Alors (Uₙ) croît, (Vₙ) décroît, et Vₙ − Uₙ = 1/(n × n!) → 0 : les deux suites sont adjacentes et convergent vers un même réel, le célèbre nombre **e**.

> 🏆 Deuxième porte franchie, héros : tu sais lire la destination d''une suite, l''encadrer, prouver sa convergence par la monotonie et capturer sa limite par le point fixe ou l''adjacence. Ces armes serviront à la dérivation et à l''intégration — l''Analyse continue de te forger.', '# 📜 Résumé : Suites réelles

- **Récurrence** : pour prouver P(n) pour tout n ≥ n₀, vérifier l''initialisation P(n₀), puis l''hérédité P(n) ⟹ P(n + 1) ; sans initialisation, l''hérédité ne prouve rien.
- **Rappels arith./géo.** : arithmétique Uₙ = U₀ + nr ; géométrique Uₙ = U₀ × qⁿ ; somme géométrique 1 + q + … + qⁿ = (1 − q^(n+1))/(1 − q) pour q ≠ 1 ; notation Σ (k = 1 → n) aₖ = a₁ + … + aₙ.
- **Majorée / minorée / bornée / monotone** : bornée = majorée et minorée ⟺ |Uₙ| ≤ K ; monotonie par le signe de Uₙ₊₁ − Uₙ (ou le quotient Uₙ₊₁/Uₙ comparé à 1 si termes positifs).
- **Limite et sous-suites** : lim Uₙ = a ⟺ lim U₂ₙ = a et lim U₂ₙ₊₁ = a ; toute suite convergente est bornée ; passage à la limite : m ≤ Uₙ ≤ M ⟹ m ≤ a ≤ M (les inégalités strictes deviennent larges).
- **Opérations sur les limites** : somme, produit, quotient comme pour les fonctions ; formes indéterminées ∞ − ∞, 0 × ∞, ∞/∞, 0/0 → transformer (terme dominant, factorisation, conjugué).
- **Suites géométriques qⁿ** : q > 1 → +∞ ; |q| < 1 → 0 ; q ≤ −1 → pas de limite ; q = 1 → constante. Attention : |q| < 1, pas q < 1.
- **Vₙ = f(Uₙ)** : f continue et Uₙ → a ⟹ f(Uₙ) → f(a) ; plus généralement Uₙ → ℓ et f(x) → L en ℓ ⟹ f(Uₙ) → L.
- **Comparaison, gendarmes, valeur absolue** : Vₙ ≤ Uₙ ≤ Wₙ avec lim Vₙ = lim Wₙ = a ⟹ lim Uₙ = a ; 0 ≤ |Uₙ| ≤ Vₙ → 0 ⟹ Uₙ → 0 ; minoration/majoration pour les limites ±∞.
- **Suites monotones (admis)** : croissante + majorée ⟹ converge (limite ≠ majorant en général) ; décroissante + minorée ⟹ converge ; croissante non majorée → +∞ ; décroissante non minorée → −∞.
- **Récurrentes Uₙ₊₁ = f(Uₙ)** : prouver d''abord la convergence (encadrement + monotonie), puis la limite parmi les points fixes f(x) = x (si f continue en la limite) ; le point fixe seul ne prouve jamais la convergence.
- **Suites adjacentes** : Uₙ ≤ Vₙ, (Uₙ) croissante, (Vₙ) décroissante, Vₙ − Uₙ → 0 ⟹ même limite (approximation de e, de √a…).', 2, NULL, '[]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref,
  videos = EXCLUDED.videos;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('b76771c5-32e7-5632-9794-9ec8095fa035', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', 'Test de compréhension ⭐ : Continuité et limites', 1, 20, 5, 'quiz', 'admin', 0, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3af27c08-8da6-5667-ac15-1b0d4b924c04', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'Soit f une fonction définie sur un intervalle ouvert contenant a. Par définition, f est continue en a lorsque :', '[{"id":"a","text":"lim x→a f(x) = f(a)"},{"id":"b","text":"f(a) existe"},{"id":"c","text":"lim x→a f(x) existe"},{"id":"d","text":"f est définie au voisinage de a"}]'::jsonb, 'a', 'Par définition, f est continue en a lorsque la limite de f en a existe et est égale à f(a) : lim x→a f(x) = f(a). L''existence de f(a) seule, ou d''une limite seule, ne suffit pas — il faut l''égalité entre les deux.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'Au cours d''un calcul de limites, laquelle de ces situations est une forme indéterminée ?', '[{"id":"a","text":"La somme de deux limites égales à +∞"},{"id":"b","text":"La différence de deux limites égales à +∞"},{"id":"c","text":"Le produit d''une limite nulle par une limite finie"},{"id":"d","text":"Le quotient d''une limite finie par une limite infinie"}]'::jsonb, 'b', 'La différence de deux limites infinies de même signe est la forme indéterminée ∞ − ∞ : on ne peut pas conclure sans transformer l''expression. En revanche, ∞ + ∞ donne +∞, un produit 0 × ℓ (ℓ fini) donne 0 et un quotient fini/infini donne 0.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b74234c6-97b1-57c7-b21a-9698d89bddf7', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'Une fonction f vérifie lim x→3 f(x) = +∞. Que peut-on en déduire pour la courbe de f ? <svg viewBox="0 0 240 190"><path d="M24.0 154.4 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 154.4 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M49.2 14.0 V170.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M49.2 14.0 l-3 6 l6 0 z" fill="#0f172a"/><line x1="125.0" y1="14.0" x2="125.0" y2="170.0" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 3"/><path d="M24.0 146.2 L24.5 146.2 L24.9 146.2 L25.4 146.2 L25.9 146.1 L26.4 146.1 L26.8 146.1 L27.3 146.1 L27.8 146.1 L28.3 146.0 L28.7 146.0 L29.2 146.0 L29.7 146.0 L30.2 145.9 L30.6 145.9 L31.1 145.9 L31.6 145.9 L32.0 145.9 L32.5 145.8 L33.0 145.8 L33.5 145.8 L33.9 145.8 L34.4 145.7 L34.9 145.7 L35.4 145.7 L35.8 145.7 L36.3 145.6 L36.8 145.6 L37.3 145.6 L37.7 145.5 L38.2 145.5 L38.7 145.5 L39.1 145.5 L39.6 145.4 L40.1 145.4 L40.6 145.4 L41.0 145.3 L41.5 145.3 L42.0 145.3 L42.5 145.2 L42.9 145.2 L43.4 145.2 L43.9 145.1 L44.4 145.1 L44.8 145.1 L45.3 145.0 L45.8 145.0 L46.3 145.0 L46.7 144.9 L47.2 144.9 L47.7 144.8 L48.1 144.8 L48.6 144.8 L49.1 144.7 L49.6 144.7 L50.0 144.6 L50.5 144.6 L51.0 144.5 L51.5 144.5 L51.9 144.4 L52.4 144.4 L52.9 144.3 L53.4 144.3 L53.8 144.2 L54.3 144.2 L54.8 144.1 L55.2 144.1 L55.7 144.0 L56.2 144.0 L56.7 143.9 L57.1 143.8 L57.6 143.8 L58.1 143.7 L58.6 143.7 L59.0 143.6 L59.5 143.5 L60.0 143.5 L60.5 143.4 L60.9 143.3 L61.4 143.2 L61.9 143.2 L62.3 143.1 L62.8 143.0 L63.3 142.9 L63.8 142.9 L64.2 142.8 L64.7 142.7 L65.2 142.6 L65.7 142.5 L66.1 142.4 L66.6 142.3 L67.1 142.2 L67.6 142.1 L68.0 142.0 L68.5 141.9 L69.0 141.8 L69.5 141.7 L69.9 141.6 L70.4 141.5 L70.9 141.4 L71.3 141.3 L71.8 141.1 L72.3 141.0 L72.8 140.9 L73.2 140.7 L73.7 140.6 L74.2 140.5 L74.7 140.3 L75.1 140.2 L75.6 140.0 L76.1 139.8 L76.6 139.7 L77.0 139.5 L77.5 139.3 L78.0 139.2 L78.4 139.0 L78.9 138.8 L79.4 138.6 L79.9 138.4 L80.3 138.2 L80.8 138.0 L81.3 137.8 L81.8 137.5 L82.2 137.3 L82.7 137.0 L83.2 136.8 L83.7 136.5 L84.1 136.3 L84.6 136.0 L85.1 135.7 L85.5 135.4 L86.0 135.1 L86.5 134.7 L87.0 134.4 L87.4 134.1 L87.9 133.7 L88.4 133.3 L88.9 132.9 L89.3 132.5 L89.8 132.1 L90.3 131.7 L90.8 131.2 L91.2 130.7 L91.7 130.2 L92.2 129.7 L92.6 129.2 L93.1 128.6 L93.6 128.0 L94.1 127.4 L94.5 126.7 L95.0 126.0 L95.5 125.3 L96.0 124.6 L96.4 123.8 L96.9 123.0 L97.4 122.1 L97.9 121.2 L98.3 120.2 L98.8 119.2 L99.3 118.1 L99.8 117.0 L100.2 115.8 L100.7 114.5 L101.2 113.1 L101.6 111.7 L102.1 110.2 L102.6 108.5 L103.1 106.8 L103.5 105.0 L104.0 103.0 L104.5 100.9 L105.0 98.6 L105.4 96.2 L105.9 93.6 L106.4 90.8 L106.9 87.8 L107.3 84.5 L107.8 80.9 L108.3 77.1 L108.7 72.9 L109.2 68.3 L109.7 63.3 L110.2 57.8 L110.6 51.7 L111.1 45.0 L111.6 37.6 L112.1 29.4 L112.5 20.2 L113.0 9.9" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M137.0 9.9 L137.5 20.2 L137.9 29.4 L138.4 37.6 L138.9 45.0 L139.4 51.7 L139.8 57.8 L140.3 63.3 L140.8 68.3 L141.3 72.9 L141.7 77.1 L142.2 80.9 L142.7 84.5 L143.1 87.8 L143.6 90.8 L144.1 93.6 L144.6 96.2 L145.0 98.6 L145.5 100.9 L146.0 103.0 L146.5 105.0 L146.9 106.8 L147.4 108.5 L147.9 110.2 L148.4 111.7 L148.8 113.1 L149.3 114.5 L149.8 115.8 L150.2 117.0 L150.7 118.1 L151.2 119.2 L151.7 120.2 L152.1 121.2 L152.6 122.1 L153.1 123.0 L153.6 123.8 L154.0 124.6 L154.5 125.3 L155.0 126.0 L155.5 126.7 L155.9 127.4 L156.4 128.0 L156.9 128.6 L157.4 129.2 L157.8 129.7 L158.3 130.2 L158.8 130.7 L159.2 131.2 L159.7 131.7 L160.2 132.1 L160.7 132.5 L161.1 132.9 L161.6 133.3 L162.1 133.7 L162.6 134.1 L163.0 134.4 L163.5 134.7 L164.0 135.1 L164.5 135.4 L164.9 135.7 L165.4 136.0 L165.9 136.3 L166.3 136.5 L166.8 136.8 L167.3 137.0 L167.8 137.3 L168.2 137.5 L168.7 137.8 L169.2 138.0 L169.7 138.2 L170.1 138.4 L170.6 138.6 L171.1 138.8 L171.6 139.0 L172.0 139.2 L172.5 139.3 L173.0 139.5 L173.4 139.7 L173.9 139.8 L174.4 140.0 L174.9 140.2 L175.3 140.3 L175.8 140.5 L176.3 140.6 L176.8 140.7 L177.2 140.9 L177.7 141.0 L178.2 141.1 L178.7 141.3 L179.1 141.4 L179.6 141.5 L180.1 141.6 L180.6 141.7 L181.0 141.8 L181.5 141.9 L182.0 142.0 L182.4 142.1 L182.9 142.2 L183.4 142.3 L183.9 142.4 L184.3 142.5 L184.8 142.6 L185.3 142.7 L185.8 142.8 L186.2 142.9 L186.7 142.9 L187.2 143.0 L187.7 143.1 L188.1 143.2 L188.6 143.2 L189.1 143.3 L189.5 143.4 L190.0 143.5 L190.5 143.5 L191.0 143.6 L191.4 143.7 L191.9 143.7 L192.4 143.8 L192.9 143.8 L193.3 143.9 L193.8 144.0 L194.3 144.0 L194.8 144.1 L195.2 144.1 L195.7 144.2 L196.2 144.2 L196.6 144.3 L197.1 144.3 L197.6 144.4 L198.1 144.4 L198.5 144.5 L199.0 144.5 L199.5 144.6 L200.0 144.6 L200.4 144.7 L200.9 144.7 L201.4 144.8 L201.9 144.8 L202.3 144.8 L202.8 144.9 L203.3 144.9 L203.7 145.0 L204.2 145.0 L204.7 145.0 L205.2 145.1 L205.6 145.1 L206.1 145.1 L206.6 145.2 L207.1 145.2 L207.5 145.2 L208.0 145.3 L208.5 145.3 L209.0 145.3 L209.4 145.4 L209.9 145.4 L210.4 145.4 L210.9 145.5 L211.3 145.5 L211.8 145.5 L212.3 145.5 L212.7 145.6 L213.2 145.6 L213.7 145.6 L214.2 145.7 L214.6 145.7 L215.1 145.7 L215.6 145.7 L216.1 145.8 L216.5 145.8 L217.0 145.8 L217.5 145.8 L218.0 145.9 L218.4 145.9 L218.9 145.9 L219.4 145.9 L219.8 145.9 L220.3 146.0 L220.8 146.0 L221.3 146.0 L221.7 146.0 L222.2 146.1 L222.7 146.1 L223.2 146.1 L223.6 146.1 L224.1 146.1 L224.6 146.2 L225.1 146.2 L225.5 146.2 L226.0 146.2" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><text x="125.0" y="184.0" text-anchor="middle" font-size="11" font-weight="700" fill="#94a3b8" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">x = 3</text></svg>', '[{"id":"a","text":"La droite d''équation y = 3 est une asymptote horizontale"},{"id":"b","text":"La droite d''équation y = 0 est une asymptote horizontale"},{"id":"c","text":"La droite d''équation x = 3 est une asymptote horizontale"},{"id":"d","text":"La droite d''équation x = 3 est une asymptote verticale"}]'::jsonb, 'd', 'Une limite infinie en un point a se traduit par une asymptote verticale d''équation x = a : ici, lim x→3 f(x) = +∞ donne l''asymptote verticale x = 3. Une asymptote horizontale correspondrait à une limite finie en +∞ ou en −∞, ce qui n''est pas la situation décrite.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'f est une fonction continue sur le segment [a ; b]. Quelle est l''image de [a ; b] par f ? <svg viewBox="0 0 250 195"><path d="M30.0 119.9 H236.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M236.0 119.9 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M30.0 14.0 V175.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M30.0 14.0 l-3 6 l6 0 z" fill="#0f172a"/><path d="M55.8 94.5 C61.3 105.8 72.9 173.6 89.2 162.3 C105.5 151.0 133.4 41.5 153.6 26.7 C173.8 11.9 200.8 65.5 210.2 73.3" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><line x1="30.0" y1="162.3" x2="236.0" y2="162.3" stroke="#b45309" stroke-width="1" stroke-dasharray="4 3" opacity="0.8"/><text x="24.0" y="166.3" text-anchor="end" font-size="11" font-weight="700" fill="#b45309" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">m</text><line x1="30.0" y1="26.7" x2="236.0" y2="26.7" stroke="#0f6e56" stroke-width="1" stroke-dasharray="4 3" opacity="0.8"/><text x="24.0" y="30.7" text-anchor="end" font-size="11" font-weight="700" fill="#0f6e56" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">M</text><circle cx="55.8" cy="94.5" r="3.5" fill="#0f172a"/><circle cx="210.2" cy="73.3" r="3.5" fill="#0f172a"/><circle cx="89.2" cy="162.3" r="3.5" fill="#b45309"/><circle cx="153.6" cy="26.7" r="3.5" fill="#0f6e56"/><text x="55.8" y="189.0" text-anchor="middle" font-size="11" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">a</text><text x="210.2" y="189.0" text-anchor="middle" font-size="11" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">b</text></svg>', '[{"id":"a","text":"Le segment [f(a) ; f(b)], où f(a) et f(b) sont les valeurs aux bornes"},{"id":"b","text":"Un intervalle ouvert contenant f(a) et f(b)"},{"id":"c","text":"Le segment [m ; M], où m et M sont le minimum et le maximum de f"},{"id":"d","text":"L''ensemble ℝ tout entier, dès que f n''est pas constante"}]'::jsonb, 'c', 'L''image du segment [a ; b] par une fonction continue est le segment [m ; M], où m et M sont le minimum et le maximum de f sur [a ; b]. Ce n''est pas forcément [f(a) ; f(b)] : le maximum ou le minimum peut être atteint à l''intérieur de l''intervalle, pas aux bornes.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d868bf9d-4d39-5d05-8c23-91e3dd50cbd4', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'La fonction f définie par f(x) = (√(x + 1) − 1)/x n''est pas définie en 0. Quelle valeur donner à g(0) pour prolonger f par continuité en 0 ?', '[{"id":"a","text":"0"},{"id":"b","text":"1/2"},{"id":"c","text":"1"},{"id":"d","text":"2"}]'::jsonb, 'b', 'Avec l''expression conjuguée, (√(x + 1) − 1)/x = 1/(√(x + 1) + 1), qui tend vers 1/2 quand x tend vers 0. On pose donc g(0) = 1/2 : c''est le prolongement par continuité de f en 0, exactement comme dans le cours.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⭐ Exercice : Premières armes — limites et continuité', 1, 50, 10, 'practice', 'admin', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2bc732c3-ef84-593e-8141-28d56a59f5f7', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→2 (3x² − 5).', '[{"id":"a","text":"1"},{"id":"b","text":"7"},{"id":"c","text":"12"},{"id":"d","text":"17"}]'::jsonb, 'b', 'Un polynôme est continu sur ℝ : la limite s''obtient en remplaçant x par 2. lim x→2 (3x² − 5) = 3 × 2² − 5 = 12 − 5 = 7 ✓. Répondre 12 revient à oublier le − 5, 1 provient du calcul 3 × 2 − 5 où le carré a été oublié, et 17 d''une erreur de signe (12 + 5).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aec4ec41-216a-51a3-b0a8-6a5820082cef', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→+∞ (−2x³ + 5x² − 7).', '[{"id":"a","text":"−∞"},{"id":"b","text":"−2"},{"id":"c","text":"0"},{"id":"d","text":"+∞"}]'::jsonb, 'a', 'Le comportement d''un polynôme en ±∞ est dicté par son terme de plus haut degré : lim x→+∞ (−2x³ + 5x² − 7) = lim x→+∞ (−2x³) = −∞, car le coefficient dominant −2 est négatif. Répondre +∞ revient à ignorer ce signe (ou à regarder 5x²), et −2 confond la limite avec le coefficient dominant.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1744bf0b-0591-5555-90c5-5a33930403c2', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→+∞ (3x + 1)/(x + 2).', '[{"id":"a","text":"0"},{"id":"b","text":"1/2"},{"id":"c","text":"3"},{"id":"d","text":"+∞"}]'::jsonb, 'c', 'Pour une fonction rationnelle en +∞, on garde les termes de plus haut degré : (3x + 1)/(x + 2) se comporte comme 3x/x = 3, donc la limite vaut 3 ✓. Répondre 1/2 revient à prendre le rapport des constantes, et +∞ à laisser la forme ∞/∞ sans la lever.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4beea811-5dad-5080-a722-62a3185fc237', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Soit f la fonction définie par f(x) = (x² − 9)/(x − 3) si x ≠ 3, et f(3) = m. Pour quelle valeur de m la fonction f est-elle continue en 3 ?', '[{"id":"a","text":"m = 0"},{"id":"b","text":"m = 6"},{"id":"c","text":"m = 9"},{"id":"d","text":"Aucune valeur de m ne convient"}]'::jsonb, 'b', 'Pour x ≠ 3, (x² − 9)/(x − 3) = ((x − 3)(x + 3))/(x − 3) = x + 3, donc lim x→3 f(x) = 6 : f est continue en 3 si et seulement si m = 6 ✓. Répondre 9 revient à ne calculer que x² en 3, 0 provient de la simplification fautive en x − 3, et la forme 0/0 n''est pas une impasse : elle se lève par factorisation.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b9253cb3-c7fd-597d-9e5b-efdd4610721a', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Soit f(x) = (3x − 1)/(x + 2). La courbe de f admet une asymptote verticale : laquelle ? <svg viewBox="0 0 240 190"><line x1="125.0" y1="14.0" x2="125.0" y2="170.0" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 3"/><path d="M24.0 107.6 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 107.6 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M165.4 14.0 V170.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M165.4 14.0 l-3 6 l6 0 z" fill="#0f172a"/><path d="M24.0 61.8 L24.5 61.8 L25.0 61.7 L25.4 61.6 L25.9 61.6 L26.4 61.5 L26.9 61.4 L27.4 61.3 L27.8 61.3 L28.3 61.2 L28.8 61.1 L29.3 61.0 L29.8 61.0 L30.2 60.9 L30.7 60.8 L31.2 60.7 L31.7 60.6 L32.2 60.6 L32.6 60.5 L33.1 60.4 L33.6 60.3 L34.1 60.2 L34.6 60.1 L35.0 60.1 L35.5 60.0 L36.0 59.9 L36.5 59.8 L37.0 59.7 L37.4 59.6 L37.9 59.5 L38.4 59.4 L38.9 59.3 L39.4 59.2 L39.8 59.1 L40.3 59.0 L40.8 58.9 L41.3 58.8 L41.8 58.7 L42.2 58.6 L42.7 58.5 L43.2 58.4 L43.7 58.3 L44.1 58.2 L44.6 58.1 L45.1 58.0 L45.6 57.9 L46.1 57.8 L46.5 57.7 L47.0 57.5 L47.5 57.4 L48.0 57.3 L48.5 57.2 L48.9 57.1 L49.4 56.9 L49.9 56.8 L50.4 56.7 L50.9 56.6 L51.3 56.4 L51.8 56.3 L52.3 56.2 L52.8 56.0 L53.3 55.9 L53.7 55.8 L54.2 55.6 L54.7 55.5 L55.2 55.3 L55.7 55.2 L56.1 55.0 L56.6 54.9 L57.1 54.7 L57.6 54.6 L58.1 54.4 L58.5 54.3 L59.0 54.1 L59.5 53.9 L60.0 53.8 L60.5 53.6 L60.9 53.4 L61.4 53.3 L61.9 53.1 L62.4 52.9 L62.9 52.7 L63.3 52.6 L63.8 52.4 L64.3 52.2 L64.8 52.0 L65.3 51.8 L65.7 51.6 L66.2 51.4 L66.7 51.2 L67.2 51.0 L67.7 50.8 L68.1 50.5 L68.6 50.3 L69.1 50.1 L69.6 49.9 L70.1 49.6 L70.5 49.4 L71.0 49.2 L71.5 48.9 L72.0 48.7 L72.5 48.4 L72.9 48.2 L73.4 47.9 L73.9 47.6 L74.4 47.4 L74.9 47.1 L75.3 46.8 L75.8 46.5 L76.3 46.2 L76.8 45.9 L77.3 45.6 L77.7 45.3 L78.2 45.0 L78.7 44.6 L79.2 44.3 L79.7 44.0 L80.1 43.6 L80.6 43.3 L81.1 42.9 L81.6 42.5 L82.0 42.2 L82.5 41.8 L83.0 41.4 L83.5 41.0 L84.0 40.6 L84.4 40.1 L84.9 39.7 L85.4 39.3 L85.9 38.8 L86.4 38.3 L86.8 37.9 L87.3 37.4 L87.8 36.9 L88.3 36.3 L88.8 35.8 L89.2 35.3 L89.7 34.7 L90.2 34.1 L90.7 33.5 L91.2 32.9 L91.6 32.3 L92.1 31.7 L92.6 31.0 L93.1 30.3 L93.6 29.6 L94.0 28.9 L94.5 28.1 L95.0 27.4 L95.5 26.6 L96.0 25.8 L96.4 24.9 L96.9 24.0 L97.4 23.1 L97.9 22.2 L98.4 21.2 L98.8 20.2 L99.3 19.1 L99.8 18.0 L100.3 16.9 L100.8 15.7 L101.2 14.5 L101.7 13.2 L102.2 11.9 L102.7 10.5 L103.2 9.1" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M140.1 173.6 L140.6 170.6 L141.1 167.8 L141.6 165.2 L142.0 162.7 L142.5 160.3 L143.0 158.1 L143.5 156.0 L144.0 153.9 L144.4 152.0 L144.9 150.2 L145.4 148.5 L145.9 146.8 L146.4 145.2 L146.8 143.7 L147.3 142.3 L147.8 140.9 L148.3 139.6 L148.8 138.3 L149.2 137.1 L149.7 135.9 L150.2 134.8 L150.7 133.7 L151.2 132.6 L151.6 131.6 L152.1 130.6 L152.6 129.7 L153.1 128.8 L153.6 127.9 L154.0 127.0 L154.5 126.2 L155.0 125.4 L155.5 124.7 L156.0 123.9 L156.4 123.2 L156.9 122.5 L157.4 121.8 L157.9 121.1 L158.4 120.5 L158.8 119.9 L159.3 119.3 L159.8 118.7 L160.3 118.1 L160.8 117.5 L161.2 117.0 L161.7 116.5 L162.2 115.9 L162.7 115.4 L163.2 114.9 L163.6 114.5 L164.1 114.0 L164.6 113.5 L165.1 113.1 L165.6 112.7 L166.0 112.2 L166.5 111.8 L167.0 111.4 L167.5 111.0 L168.0 110.6 L168.4 110.3 L168.9 109.9 L169.4 109.5 L169.9 109.2 L170.3 108.8 L170.8 108.5 L171.3 108.2 L171.8 107.8 L172.3 107.5 L172.7 107.2 L173.2 106.9 L173.7 106.6 L174.2 106.3 L174.7 106.0 L175.1 105.7 L175.6 105.4 L176.1 105.2 L176.6 104.9 L177.1 104.6 L177.5 104.4 L178.0 104.1 L178.5 103.9 L179.0 103.6 L179.5 103.4 L179.9 103.2 L180.4 102.9 L180.9 102.7 L181.4 102.5 L181.9 102.3 L182.3 102.0 L182.8 101.8 L183.3 101.6 L183.8 101.4 L184.3 101.2 L184.7 101.0 L185.2 100.8 L185.7 100.6 L186.2 100.4 L186.7 100.2 L187.1 100.1 L187.6 99.9 L188.1 99.7 L188.6 99.5 L189.1 99.4 L189.5 99.2 L190.0 99.0 L190.5 98.9 L191.0 98.7 L191.5 98.5 L191.9 98.4 L192.4 98.2 L192.9 98.1 L193.4 97.9 L193.9 97.8 L194.3 97.6 L194.8 97.5 L195.3 97.3 L195.8 97.2 L196.3 97.0 L196.7 96.9 L197.2 96.8 L197.7 96.6 L198.2 96.5 L198.7 96.4 L199.1 96.2 L199.6 96.1 L200.1 96.0 L200.6 95.9 L201.1 95.7 L201.5 95.6 L202.0 95.5 L202.5 95.4 L203.0 95.3 L203.5 95.1 L203.9 95.0 L204.4 94.9 L204.9 94.8 L205.4 94.7 L205.9 94.6 L206.3 94.5 L206.8 94.4 L207.3 94.3 L207.8 94.2 L208.2 94.1 L208.7 94.0 L209.2 93.9 L209.7 93.8 L210.2 93.7 L210.6 93.6 L211.1 93.5 L211.6 93.4 L212.1 93.3 L212.6 93.2 L213.0 93.1 L213.5 93.0 L214.0 92.9 L214.5 92.8 L215.0 92.7 L215.4 92.7 L215.9 92.6 L216.4 92.5 L216.9 92.4 L217.4 92.3 L217.8 92.2 L218.3 92.2 L218.8 92.1 L219.3 92.0 L219.8 91.9 L220.2 91.8 L220.7 91.8 L221.2 91.7 L221.7 91.6 L222.2 91.5 L222.6 91.5 L223.1 91.4 L223.6 91.3 L224.1 91.2 L224.6 91.2 L225.0 91.1 L225.5 91.0 L226.0 91.0" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><text x="125.0" y="184.0" text-anchor="middle" font-size="11" font-weight="700" fill="#94a3b8" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">x = −2</text></svg>', '[{"id":"a","text":"La droite d''équation x = −2"},{"id":"b","text":"La droite d''équation x = 2"},{"id":"c","text":"La droite d''équation x = 3"},{"id":"d","text":"La droite d''équation y = 3"}]'::jsonb, 'a', 'Le dénominateur x + 2 s''annule en x = −2 (et le numérateur y vaut −7 ≠ 0), donc les limites de f en −2 sont infinies : la droite d''équation x = −2 est l''asymptote verticale ✓. Répondre x = 2 est une erreur de signe en résolvant x + 2 = 0, x = 3 lit le coefficient du numérateur, et y = 3 est l''asymptote horizontale — une limite finie à l''infini, pas une limite infinie en un point.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0c9af287-fc69-5495-b1d8-05872e8f8300', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→3⁺ 1/(x − 3).', '[{"id":"a","text":"−∞"},{"id":"b","text":"0"},{"id":"c","text":"3"},{"id":"d","text":"+∞"}]'::jsonb, 'd', 'Quand x → 3⁺, le dénominateur x − 3 tend vers 0 en restant strictement positif, donc 1/(x − 3) → +∞ ✓. Une erreur d''étude de signe donnerait −∞ (qui est en réalité la limite à gauche), 0 confond avec la limite en +∞, et 3 confond la valeur vers laquelle tend x avec la limite de f.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('75fc9ae9-900f-5c98-8207-baa94bff86af', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⚔️ Boss du chapitre ⭐⭐⭐ : Le gardien du seuil', 3, 120, 30, 'boss', 'admin', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a1682039-0438-5589-810c-7ce83d3f1190', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Soit f la fonction définie pour x ≠ 1 par f(x) = (√(x + 3) − 2)/(x − 1). Peut-on prolonger f par continuité en 1 ?', '[{"id":"a","text":"Oui, en posant f(1) = 0"},{"id":"b","text":"Oui, en posant f(1) = 1/4"},{"id":"c","text":"Oui, en posant f(1) = 1/2"},{"id":"d","text":"Non, f n''est pas prolongeable en 1"}]'::jsonb, 'b', 'En 1, numérateur et dénominateur s''annulent (√4 − 2 = 0) : forme 0/0. Expression conjuguée : (√(x + 3) − 2)(√(x + 3) + 2) = x + 3 − 4 = x − 1, donc f(x) = (x − 1)/((x − 1)(√(x + 3) + 2)) = 1/(√(x + 3) + 2), qui tend vers 1/(2 + 2) = 1/4 quand x → 1 ✓. La limite étant finie, f se prolonge avec f(1) = 1/4. Le piège courant : oublier le terme + 2 du conjugué au dénominateur donne 1/2 ; traiter 0/0 comme nul donne 0 ; et une forme 0/0 n''interdit pas le prolongement.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2adf3630-8ece-5043-a698-baa40822db13', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Une fonction f vérifie, pour tout x > 0 : (2x − 1)/x ≤ f(x) ≤ (2x + 3)/x. Déterminer lim x→+∞ f(x).', '[{"id":"a","text":"−1"},{"id":"b","text":"0"},{"id":"c","text":"2"},{"id":"d","text":"3"}]'::jsonb, 'c', '(2x − 1)/x = 2 − 1/x tend vers 2, et (2x + 3)/x = 2 + 3/x tend vers 2. Les deux gendarmes ayant la même limite, le théorème des gendarmes donne lim x→+∞ f(x) = 2 ✓. Le piège courant : répondre −1 ou 3 en lisant les constantes des numérateurs, ou 0 en croyant que les termes en 1/x dictent la limite — ils tendent vers 0, mais s''ajoutent à 2.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cd689749-cc37-5719-9e5c-779dce1c6d54', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Déterminer lim x→+∞ (3x + sin x)/x.', '[{"id":"a","text":"3"},{"id":"b","text":"4"},{"id":"c","text":"+∞"},{"id":"d","text":"Cette limite n''existe pas, car sin x n''a pas de limite en +∞"}]'::jsonb, 'a', 'Pour x > 0, −1 ≤ sin x ≤ 1 donne l''encadrement (3x − 1)/x ≤ (3x + sin x)/x ≤ (3x + 1)/x. Les deux bornes tendent vers 3, donc la limite vaut 3 ✓ (théorème des gendarmes, avec sin x/x → 0). Le piège courant : conclure que la limite n''existe pas parce que sin x oscille — l''encadrement neutralise l''oscillation. Répondre 4 fige sin x à sa valeur maximale 1, et +∞ oublie la division par x.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Pour calculer lim x→+∞ (√(4x² + x) − 2x), un élève rédige :
① √(4x² + x) → +∞ et 2x → +∞ : forme indéterminée du type ∞ − ∞.
② Pour x > 0, √(4x² + x) = x√(4 + 1/x).
③ Comme √(4 + 1/x) → 2, l''expression devient x × 2 − 2x = 0.
④ Conclusion : la limite vaut 0.
Dans quelle étape se cache l''erreur ?', '[{"id":"a","text":"L''étape ①"},{"id":"b","text":"L''étape ②"},{"id":"c","text":"L''étape ③"},{"id":"d","text":"L''étape ④"}]'::jsonb, 'c', 'L''erreur se cache à l''étape ③ : dans une forme indéterminée, on n''a pas le droit de remplacer un morceau de l''expression (√(4 + 1/x)) par sa limite avant de conclure — c''est une levée illégale de l''indétermination. Les étapes ① et ② sont exactes, et ④ ne fait que suivre ③. Calcul correct par le conjugué : √(4x² + x) − 2x = (4x² + x − 4x²)/(√(4x² + x) + 2x) = x/(√(4x² + x) + 2x) = 1/(√(4 + 1/x) + 2), qui tend vers 1/4 ✓. La conclusion 0 de l''élève est donc fausse : c''est bien sa démarche qu''il fallait invalider.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('45a47019-5722-586c-8211-35c6609f5eac', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'On considère l''affirmation : « Si f est continue sur [a ; b] et f(a) · f(b) < 0, alors l''équation f(x) = 0 admet une unique solution dans [a ; b]. » Cette affirmation est-elle vraie ou fausse ? <svg viewBox="0 0 240 185"><path d="M26.0 97.9 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 97.9 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M26.0 14.0 V165.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M26.0 14.0 l-3 6 l6 0 z" fill="#0f172a"/><path d="M66.0 139.8 C71.3 127.2 88.0 67.5 98.0 64.3 C108.0 61.2 116.7 119.9 126.0 121.0 C135.3 122.0 144.0 85.0 154.0 70.6 C164.0 56.3 180.7 40.9 186.0 35.0" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="66.0" cy="139.8" r="3.5" fill="#0f172a"/><text x="66.0" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">1</text><circle cx="186.0" cy="35.0" r="3.5" fill="#0f172a"/><text x="186.0" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">4</text></svg>', '[{"id":"a","text":"Vraie : le théorème des valeurs intermédiaires garantit à la fois l''existence et l''unicité de la solution"},{"id":"b","text":"Vraie : f(a) et f(b) étant de signes contraires, la courbe ne peut couper l''axe des abscisses qu''une seule fois"},{"id":"c","text":"Fausse : le théorème des valeurs intermédiaires exige f(a) · f(b) > 0"},{"id":"d","text":"Fausse : sans stricte monotonie, f peut s''annuler plusieurs fois sur [a ; b]"}]'::jsonb, 'd', 'L''affirmation est fausse ✓ : la continuité et le changement de signe garantissent au moins une annulation (TVI), mais jamais l''unicité — une fonction qui oscille peut couper l''axe des abscisses trois fois entre a et b. L''unicité exige en plus la stricte monotonie (corollaire de la bijection). Le piège courant : croire que le TVI livre existence et unicité d''un coup ; et le TVI demande bien des signes contraires, pas f(a) · f(b) > 0.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('95d862fa-6176-53ff-bd36-3a089be93947', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Soit f(x) = x³ + x − 5. f est continue et strictement croissante sur [1 ; 2] (somme de fonctions strictement croissantes), avec f(1) = −3 et f(2) = 5 : l''équation f(x) = 0 admet donc une unique solution α dans [1 ; 2]. On calcule f(1,5) = −0,125. Dans quel intervalle se trouve α ?', '[{"id":"a","text":"]1 ; 1,5["},{"id":"b","text":"]1,5 ; 2["},{"id":"c","text":"α est exactement égal à 1,5"},{"id":"d","text":"On ne peut pas conclure avec ces informations"}]'::jsonb, 'b', 'f(1,5) = 1,5³ + 1,5 − 5 = 3,375 + 1,5 − 5 = −0,125 < 0, et f(2) = 5 > 0 : le changement de signe se produit entre 1,5 et 2, donc α ∈ ]1,5 ; 2[ ✓ (la stricte croissance garantit l''unicité). Le piège courant : une erreur de signe sur f(1,5) envoie vers ]1 ; 1,5[ ; le milieu 1,5 n''est pas la solution puisque f(1,5) ≠ 0 ; et un seul pas de dichotomie suffit bel et bien à conclure.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⭐⭐ Révision (type examen) : Lever les indéterminations', 2, 75, 15, 'practice', 'admin', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→+∞ (x² − x).', '[{"id":"a","text":"−∞"},{"id":"b","text":"0"},{"id":"c","text":"1"},{"id":"d","text":"+∞"}]'::jsonb, 'd', 'Face à la forme indéterminée ∞ − ∞, on factorise le terme dominant : x² − x = x²(1 − 1/x). Comme x² → +∞ et 1 − 1/x → 1, la limite vaut +∞ ✓. Répondre 0 revient à lever illégalement la forme ∞ − ∞ en « annulant » les deux infinis, 1 s''arrête à la limite de la parenthèse, et −∞ prend le signe du terme −x.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0c567130-c4c9-5bbf-98af-48ac3fe35478', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→2 (x² − 4)/(x² − 3x + 2).', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"4/3"},{"id":"d","text":"4"}]'::jsonb, 'd', 'Forme 0/0 en 2 : on factorise. x² − 4 = (x − 2)(x + 2) et x² − 3x + 2 = (x − 2)(x − 1), donc le quotient vaut (x + 2)/(x − 1) pour x ≠ 2, qui tend vers 4/1 = 4 ✓. Répondre 1 revient à croire que 0/0 vaut toujours 1, 4/3 provient d''une factorisation fautive du dénominateur en (x − 2)(x + 1), et 0 traite 0/0 comme nul.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('55ae6f27-b3d2-53a0-95ac-3c1522b812bc', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→+∞ (√(x² + 6x) − x).', '[{"id":"a","text":"0"},{"id":"b","text":"3"},{"id":"c","text":"6"},{"id":"d","text":"+∞"}]'::jsonb, 'b', 'Forme ∞ − ∞ : on multiplie par l''expression conjuguée. √(x² + 6x) − x = (x² + 6x − x²)/(√(x² + 6x) + x) = 6x/(√(x² + 6x) + x) = 6/(√(1 + 6/x) + 1), qui tend vers 6/2 = 3 ✓. Répondre 6 oublie que le dénominateur tend vers 2, 0 lève illégalement la forme ∞ − ∞, et +∞ compare mal les deux termes.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bc67fce0-14b0-512d-96fb-b200ad35fa3f', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→+∞ √((4x² + 1)/(x² + 1)).', '[{"id":"a","text":"2"},{"id":"b","text":"4"},{"id":"c","text":"16"},{"id":"d","text":"+∞"}]'::jsonb, 'a', 'Limite d''une composée : la fonction intérieure (4x² + 1)/(x² + 1) tend vers 4 (termes de plus haut degré), et √ est continue en 4, donc la limite vaut √4 = 2 ✓. Répondre 4 oublie d''appliquer la racine (composée incomplète), 16 élève au carré au lieu de prendre la racine, et +∞ laisse la forme ∞/∞ non levée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a85f9f3a-57c8-5528-b925-41cadd3ea008', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'La fonction f définie par f(x) = (x² − 25)/(x − 5) n''est pas définie en 5. Est-elle prolongeable par continuité en 5 ?', '[{"id":"a","text":"Oui, en posant f(5) = 0"},{"id":"b","text":"Oui, en posant f(5) = 5"},{"id":"c","text":"Oui, en posant f(5) = 10"},{"id":"d","text":"Non, f n''est pas prolongeable en 5"}]'::jsonb, 'c', 'Pour x ≠ 5, (x² − 25)/(x − 5) = ((x − 5)(x + 5))/(x − 5) = x + 5, qui tend vers 10 quand x → 5. La limite est finie : f se prolonge par continuité en 5 en posant f(5) = 10 ✓. Répondre 5 confond la valeur du prolongement avec le point, 0 traite 0/0 comme nul, et la forme 0/0 n''empêche pas le prolongement — elle se lève par factorisation.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e5f35d28-19b0-5807-adc2-cc42ca5e625e', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'f est une fonction continue sur [1 ; 2] avec f(1) = −2 et f(2) = 1. Que peut-on affirmer, d''après le théorème des valeurs intermédiaires, pour l''équation f(x) = 0 ? <svg viewBox="0 0 240 185"><path d="M26.0 74.4 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 74.4 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M26.0 14.0 V165.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M26.0 14.0 l-3 6 l6 0 z" fill="#0f172a"/><path d="M70.4 134.8 C89.0 119.7 163.0 59.3 181.6 44.2" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="70.4" cy="134.8" r="3.5" fill="#0f172a"/><text x="70.4" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">1</text><circle cx="181.6" cy="44.2" r="3.5" fill="#0f172a"/><text x="181.6" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">2</text></svg>', '[{"id":"a","text":"Elle admet au moins une solution dans [1 ; 2]"},{"id":"b","text":"Elle admet exactement une solution dans [1 ; 2]"},{"id":"c","text":"Elle n''admet aucune solution dans [1 ; 2]"},{"id":"d","text":"Sa solution est exactement x = 1,5"}]'::jsonb, 'a', 'f est continue sur [1 ; 2] et 0 est compris entre f(1) = −2 et f(2) = 1 : le TVI garantit au moins une solution dans [1 ; 2] ✓. Il ne garantit jamais l''unicité : il faudrait en plus la stricte monotonie (corollaire de la bijection), qui n''est pas donnée ici. Quant à 1,5, ce n''est que le milieu de l''intervalle, pas une solution certifiée.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('6f055244-7690-5d90-b279-8c0785ee7e44', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '👑 Défi élite ⭐⭐⭐⭐ : L''épreuve du bachelier', 4, 300, 60, 'challenge', 'admin', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bef7b52e-7113-5e25-b4c9-7943c27a365d', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Soit a un réel et f la fonction définie pour x ≠ 2 par f(x) = (x² + ax − 6)/(x − 2). Déterminer la valeur de a pour laquelle f est prolongeable par continuité en 2, puis la valeur f(2) de ce prolongement.', '[{"id":"a","text":"a = −1 et f(2) = 5"},{"id":"b","text":"a = 1 et f(2) = 2"},{"id":"c","text":"a = 1 et f(2) = 5"},{"id":"d","text":"a = 2 et f(2) = 6"}]'::jsonb, 'c', 'Pour que la limite en 2 soit finie, le numérateur doit s''annuler en 2 : 2² + 2a − 6 = 0, soit 2a = 2, donc a = 1 ✓. Alors x² + x − 6 = (x − 2)(x + 3), donc f(x) = x + 3 pour x ≠ 2, et f(2) = lim x→2 f(x) = 5 ✓. Vérification : 2² + 2 − 6 = 0 ✓. L''erreur classique : une faute de signe dans le terme 2a donne a = −1 (le numérateur ne s''annule alors plus en 2, la limite est infinie) ; lire ax comme a donne a = 2 ; et f(2) = 2 confond la valeur du prolongement avec le point x = 2.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0784b9f3-963c-5021-9ab6-bb87604c9d71', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Une fonction g est continue sur [0 ; 4], avec g(0) = 3 et g(4) = −1. Aucune autre information n''est donnée. Laquelle de ces affirmations est justifiée ? <svg viewBox="0 0 240 185"><path d="M26.0 111.4 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 111.4 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M42.0 14.0 V165.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M42.0 14.0 l-3 6 l6 0 z" fill="#0f172a"/><path d="M42.0 38.4 C68.7 54.6 175.3 119.5 202.0 135.8" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="42.0" cy="38.4" r="3.5" fill="#0f172a"/><text x="42.0" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">0</text><circle cx="202.0" cy="135.8" r="3.5" fill="#0f172a"/><text x="202.0" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">4</text></svg>', '[{"id":"a","text":"L''équation g(x) = 0 admet au moins une solution dans [0 ; 4]"},{"id":"b","text":"L''équation g(x) = 0 admet exactement une solution dans [0 ; 4]"},{"id":"c","text":"L''équation g(x) = 4 admet au moins une solution dans [0 ; 4]"},{"id":"d","text":"g est strictement décroissante sur [0 ; 4]"}]'::jsonb, 'a', '0 est compris entre g(4) = −1 et g(0) = 3 : le théorème des valeurs intermédiaires garantit au moins une solution de g(x) = 0 dans [0 ; 4] ✓. L''erreur classique : conclure à une solution unique — l''unicité exigerait la stricte monotonie (corollaire de la bijection), non fournie ici ; de même, g(0) > g(4) n''implique pas que g décroît sur tout l''intervalle. Enfin, 4 n''est pas compris entre −1 et 3 : le TVI ne dit rien de l''équation g(x) = 4 (piège de l''encadrement de k oublié).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5082a155-94a8-5525-b00f-b86ccd1cab10', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Une fonction h vérifie, pour tout x ≥ 1 : 2 − 1/x ≤ h(x) ≤ 2 + 1/x². Déterminer lim x→+∞ √(h(x) + 7).', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"9"},{"id":"d","text":"On ne peut pas déterminer cette limite avec ces informations"}]'::jsonb, 'b', 'Étape 1 : 2 − 1/x → 2 et 2 + 1/x² → 2, donc lim x→+∞ h(x) = 2 par le théorème des gendarmes ✓. Étape 2 : h(x) + 7 → 9. Étape 3 : √ est continue en 9, donc lim x→+∞ √(h(x) + 7) = √9 = 3 ✓. L''erreur classique : oublier la fonction extérieure et s''arrêter à 9 (voire à la limite 2 de h) ; et croire que les gendarmes ne s''appliquent pas quand les deux bornes sont des expressions différentes — seule compte l''égalité de leurs limites.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '6f055244-7690-5d90-b279-8c0785ee7e44', 'L''affirmation suivante est fausse : « Toute fonction f définie sur [−1 ; 1] telle que f(−1) · f(1) < 0 s''annule au moins une fois sur [−1 ; 1]. » Quelle fonction en fournit un contre-exemple ?', '[{"id":"a","text":"f(x) = x pour tout x de [−1 ; 1]"},{"id":"b","text":"f(x) = x² + 1 pour tout x de [−1 ; 1]"},{"id":"c","text":"f(x) = |x| pour x ≠ 0, et f(0) = −1"},{"id":"d","text":"f(x) = 1/x pour x ≠ 0, et f(0) = 1"}]'::jsonb, 'd', 'Pour f(x) = 1/x avec f(0) = 1 : f(−1) · f(1) = (−1) × 1 = −1 < 0, et pourtant f ne s''annule jamais (1/x ≠ 0 pour x ≠ 0, et f(0) = 1) — l''hypothèse est vérifiée mais la conclusion échoue : contre-exemple valide ✓. C''est la discontinuité en 0 qui rend le TVI inapplicable. L''erreur classique : proposer une fonction qui ne vérifie pas l''hypothèse — pour x² + 1 on a f(−1) · f(1) = 2 × 2 = 4 > 0, et pour la fonction en |x| on a 1 × 1 = 1 > 0 — ou une fonction comme f(x) = x, qui s''annule et confirme l''affirmation au lieu de la contredire.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('28b2f193-675b-52ec-8354-09cf1e8a4a6b', '6f055244-7690-5d90-b279-8c0785ee7e44', 'f est continue et strictement croissante sur [−2 ; 3], avec f(−2) = −4 et f(3) = 6. Pour quelles valeurs du réel k l''équation f(x) = k admet-elle exactement une solution dans [−2 ; 3] ? <svg viewBox="0 0 240 185"><path d="M26.0 101.1 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 101.1 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M109.9 14.0 V165.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M109.9 14.0 l-3 6 l6 0 z" fill="#0f172a"/><line x1="26.0" y1="77.9" x2="226.0" y2="77.9" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="5 3"/><text x="224.0" y="72.9" text-anchor="end" font-size="10" font-weight="700" fill="#94a3b8" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">y = 2</text><path d="M45.4 147.6 C58.8 137.9 99.1 108.9 126.0 89.5 C152.9 70.1 193.2 41.1 206.6 31.4" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="45.4" cy="147.6" r="3.5" fill="#0f172a"/><text x="45.4" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">-2</text><circle cx="206.6" cy="31.4" r="3.5" fill="#0f172a"/><text x="206.6" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">3</text></svg>', '[{"id":"a","text":"k ∈ [−2 ; 3]"},{"id":"b","text":"k ∈ ]−4 ; 6["},{"id":"c","text":"k ∈ [−4 ; 6]"},{"id":"d","text":"k ∈ ℝ"}]'::jsonb, 'c', 'f étant continue et strictement croissante sur [−2 ; 3], elle réalise une bijection de [−2 ; 3] sur [f(−2) ; f(3)] = [−4 ; 6] : chaque k de [−4 ; 6] est atteint exactement une fois ✓ (corollaire du TVI). Les bornes sont incluses : k = −4 donne la solution x = −2 et k = 6 donne x = 3. L''erreur classique : exclure les bornes en répondant ]−4 ; 6[, confondre l''intervalle de départ [−2 ; 3] avec l''image, ou croire qu''une fonction strictement croissante atteint tout réel k.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5f1d4834-8d38-5bfd-83f4-1428cc4074e4', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Soit f la fonction définie pour x ≠ 1 par f(x) = (√(x² + 3) − 2)/(x − 1). Déterminer la valeur du prolongement par continuité de f en 1, puis l''asymptote horizontale de la courbe de f en +∞.', '[{"id":"a","text":"f(1) = 0 et asymptote y = 1"},{"id":"b","text":"f(1) = 1/4 et asymptote y = 1"},{"id":"c","text":"f(1) = 1/2 et asymptote y = 0"},{"id":"d","text":"f(1) = 1/2 et asymptote y = 1"}]'::jsonb, 'd', 'En 1 : √(1 + 3) − 2 = 0, forme 0/0. Expression conjuguée : (x² + 3 − 4)/((x − 1)(√(x² + 3) + 2)) = (x² − 1)/((x − 1)(√(x² + 3) + 2)) = (x + 1)/(√(x² + 3) + 2), qui tend vers 2/4 = 1/2 quand x → 1 ✓, donc f(1) = 1/2. En +∞ : en divisant numérateur et dénominateur par x, f(x) = (√(1 + 3/x²) − 2/x)/(1 − 1/x), qui tend vers 1/1 = 1, d''où l''asymptote horizontale y = 1 ✓. L''erreur classique : après simplification par (x − 1), oublier le facteur (x + 1) au numérateur donne 1/4 ; traiter 0/0 comme nul donne 0 ; et croire que tout quotient tend vers 0 en +∞ fabrique l''asymptote fantôme y = 0.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('35d2cb52-661a-50a0-94d8-24590f6525d8', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🧩 Mission interactive ⭐ : L''atelier de l''apprenti analyste', 1, 50, 10, 'practice', 'admin', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a9ec4bb2-971b-548b-b872-47feb78de533', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Texte à trous — complète l''énoncé du théorème des gendarmes vu en cours :
« Si u(x) ≤ f(x) ≤ v(x) au voisinage de +∞ et si ____, alors lim x→+∞ f(x) = ℓ. »', '[{"id":"a","text":"lim x→+∞ u(x) = ℓ"},{"id":"b","text":"lim x→+∞ u(x) = lim x→+∞ v(x) = ℓ"},{"id":"c","text":"lim x→+∞ u(x) = +∞"},{"id":"d","text":"u et v sont continues sur ℝ"}]'::jsonb, 'b', 'Le théorème des gendarmes exige que les deux encadrants tendent vers la même limite finie : lim x→+∞ u(x) = lim x→+∞ v(x) = ℓ ✓. Avec la seule condition lim u = ℓ, f pourrait s''échapper vers le haut, rien ne la retient. La condition lim u = +∞ relève du théorème de comparaison, qui conclut à une limite infinie, pas à ℓ. Quant à la continuité de u et v, elle ne figure nulle part dans les hypothèses du théorème.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('746b0135-365a-5001-8259-05b772e9e1ea', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Appariement — associe chaque forme indéterminée (①②③) à la technique de levée adaptée (a, b, c, d) :
① lim x→+∞ (√(x² + x) − x), forme ∞ − ∞ avec un radical
② lim x→5 (x² − 4x − 5)/(x − 5), forme 0/0 en un point
③ lim x→−∞ (7x³ + x)/(2x³ − 1), forme ∞/∞ d''une fonction rationnelle
a. multiplier par l''expression conjuguée
b. factoriser puis simplifier par (x − 5)
c. comparer les termes de plus haut degré
d. remplacer chaque morceau par sa limite
Quel appariement est entièrement correct ?', '[{"id":"a","text":"①-a · ②-b · ③-c"},{"id":"b","text":"①-a · ②-c · ③-b"},{"id":"c","text":"①-b · ②-a · ③-c"},{"id":"d","text":"①-d · ②-b · ③-c"}]'::jsonb, 'a', 'Le bon triptyque est ①-a · ②-b · ③-c ✓ : un radical dans une forme ∞ − ∞ appelle l''expression conjuguée, une forme 0/0 en un point se lève en factorisant le facteur commun (x − 5), et une fonction rationnelle en ±∞ se traite par les termes de plus haut degré. Échanger conjuguée et factorisation (①-b · ②-a) confond les deux transformations ; appliquer les termes dominants en un point fini (②-c) n''a pas de sens, cette technique ne vaut qu''en ±∞ ; et la technique d, remplacer chaque morceau par sa limite, est précisément l''opération illégale interdite face à une forme indéterminée.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ffdad216-1ab6-55cf-9736-9792be0fdf75', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Remise en ordre — pour calculer lim x→3 (x² − 2x − 3)/(x − 3), un élève dispose de quatre étapes, données dans le désordre :
① Simplifier la fraction par le facteur (x − 3) obtenu : pour x ≠ 3, le quotient vaut x + 1.
② Constater que le numérateur et le dénominateur s''annulent tous deux en 3 : le théorème du quotient ne s''applique pas (forme 0/0), il faut transformer l''expression.
③ Conclure : lim x→3 (x² − 2x − 3)/(x − 3) = 3 + 1 = 4.
④ Factoriser le numérateur pour lever cette indétermination : x² − 2x − 3 = (x − 3)(x + 1).
Quel est l''ordre correct des étapes ?', '[{"id":"a","text":"② → ① → ④ → ③"},{"id":"b","text":"② → ④ → ③ → ①"},{"id":"c","text":"④ → ② → ① → ③"},{"id":"d","text":"② → ④ → ① → ③"}]'::jsonb, 'd', 'L''ordre correct est ② → ④ → ① → ③ ✓ : on diagnostique d''abord la forme 0/0 (②), ce qui motive la factorisation (④), qui fournit le facteur (x − 3) que l''on simplifie (①), et l''on conclut alors lim = 4 (③). L''ordre ② → ① → ④ → ③ simplifie par un facteur qu''on n''a pas encore obtenu ; ② → ④ → ③ → ① conclut avant d''avoir simplifié la fraction ; et ④ → ② → ① → ③ transforme l''expression avant d''avoir constaté l''indétermination qui justifie cette transformation.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1480bf16-37ba-5bcb-967d-c9869d882e43', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Lecture de document — une fonction f est continue sur [0 ; 4]. Un tableau de valeurs donne :
x : 0 · 1 · 2 · 3 · 4
f(x) : 2 · −1 · −3 · 1 · 5
D''après ce tableau, combien de solutions au moins l''équation f(x) = 0 admet-elle sur [0 ; 4] ? <svg viewBox="0 0 240 185"><path d="M26.0 104.6 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 104.6 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M39.0 14.0 V165.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M39.0 14.0 l-3 6 l6 0 z" fill="#0f172a"/><path d="M39.0 74.4 C46.3 82.0 68.0 107.1 82.5 119.7 C97.0 132.3 111.5 154.9 126.0 149.9 C140.5 144.9 155.0 109.6 169.5 89.5 C184.0 69.4 205.7 39.2 213.0 29.1" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="39.0" cy="74.4" r="3.5" fill="#0f172a"/><text x="39.0" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">0</text><circle cx="82.5" cy="119.7" r="3.5" fill="#0f172a"/><text x="82.5" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">1</text><circle cx="126.0" cy="149.9" r="3.5" fill="#0f172a"/><text x="126.0" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">2</text><circle cx="169.5" cy="89.5" r="3.5" fill="#0f172a"/><text x="169.5" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">3</text><circle cx="213.0" cy="29.1" r="3.5" fill="#0f172a"/><text x="213.0" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">4</text></svg>', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"2"},{"id":"d","text":"4"}]'::jsonb, 'c', 'Le tableau montre deux changements de signe : de f(0) = 2 à f(1) = −1, puis de f(2) = −3 à f(3) = 1. Sur chacun des intervalles [0 ; 1] et [2 ; 3], f est continue et change de signe : le théorème des valeurs intermédiaires garantit au moins une solution dans chacun, donc au moins 2 solutions en tout ✓. Répondre 1 revient à s''arrêter au premier changement de signe ; 4 suppose une solution dans chaque colonne du tableau, alors qu''entre 3 et 4, f reste positive (aucun changement de signe) ; et 0 exige de lire la valeur 0 dans le tableau, ce que le TVI ne demande pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('31a27502-0123-5cab-91c3-12dcc369cdf7', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Chasse à l''erreur — pour calculer lim x→−∞ (2x² + 3x)/(x² − 5), un élève rédige :
① En −∞, la limite d''une fonction rationnelle est celle du quotient de ses termes de plus haut degré.
② Les termes de plus haut degré sont 2x² au numérateur et x² au dénominateur.
③ Le quotient de ces termes vaut 2x²/x² = 2x.
④ Conclusion : lim x→−∞ (2x² + 3x)/(x² − 5) = −∞, car 2x → −∞ quand x → −∞.
Une seule étape contient une erreur : laquelle ?', '[{"id":"a","text":"L''étape ①"},{"id":"b","text":"L''étape ②"},{"id":"c","text":"L''étape ③"},{"id":"d","text":"L''étape ④"}]'::jsonb, 'c', 'L''erreur se cache à l''étape ③ : la simplification est fautive, car 2x²/x² = 2 et non 2x — les deux facteurs x² se simplifient entièrement. Étape corrigée : le quotient des termes dominants vaut 2, donc lim x→−∞ (2x² + 3x)/(x² − 5) = 2 ✓, et la conclusion −∞ de l''élève est fausse. Les étapes ① et ② sont exactes, et ④ ne fait que dérouler l''erreur commise en ③. Le piège courant : mal soustraire les exposants en simplifiant des puissances (x²/x² = 1, et non x).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Vrai ou faux ? On considère l''affirmation : « Si une fonction f n''est pas définie en a mais admet en a une limite finie ℓ, alors f est prolongeable par continuité en a. » Choisis le verdict accompagné de la justification correcte.', '[{"id":"a","text":"Vrai, car en posant g(a) = ℓ et g(x) = f(x) pour x ≠ a, on obtient une fonction continue en a"},{"id":"b","text":"Vrai, car une forme indéterminée 0/0 donne toujours une limite finie"},{"id":"c","text":"Faux, car une fonction non définie en a ne peut jamais être rendue continue en a"},{"id":"d","text":"Faux, car le prolongement n''existe que lorsque la limite ℓ est nulle"}]'::jsonb, 'a', 'L''affirmation est vraie, et la bonne raison est la définition même du prolongement : g(x) = f(x) pour x ≠ a et g(a) = ℓ vérifie lim x→a g(x) = ℓ = g(a), donc g est continue en a ✓. Attention au verdict juste mal justifié : une forme 0/0 ne donne pas toujours une limite finie (x/x³ = 1/x² tend vers +∞ en 0), ce n''est donc pas un argument. Dire que c''est impossible contredit l''exemple du cours (√(x + 1) − 1)/x, prolongée en 0 par 1/2 ; et aucune règle n''exige ℓ = 0 : il faut seulement que ℓ soit fini.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🌉 Histoire ⭐⭐⭐ : Le pont de la continuité', 3, 120, 30, 'boss', 'admin', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2a65b201-ef6d-5532-b334-bef78c2e24f4', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 1 — Le pont d''Analysia enjambe le Ravin des Indéterminées, et toi, héros de la section Mathématiques, tu dois le réparer arche par arche. La première arche a pour profil la fonction f définie par f(x) = 2x² + m si x ≤ 1 et f(x) = 5x − 1 si x > 1, où m est un réel. Pour quelle valeur de m les deux tronçons se raccordent-ils, c''est-à-dire f continue en 1 ?', '[{"id":"a","text":"m = −2"},{"id":"b","text":"m = 2"},{"id":"c","text":"m = 4"},{"id":"d","text":"m = 6"}]'::jsonb, 'b', 'La continuité en 1 exige l''égalité des deux limites latérales avec f(1). À gauche : 2 × 1² + m = 2 + m ; à droite : 5 × 1 − 1 = 4. D''où 2 + m = 4, soit m = 2 ✓. Vérification : f(1) = 2 + 2 = 4, valeur commune aux deux tronçons ✓. Répondre m = 4 revient à oublier que le terme 2x² vaut 2 en x = 1 ; m = 6 ajoute 2 au lieu de le retrancher (4 + 2) ; et m = −2 résout 2 + m = 0, comme si un raccord continu exigeait f(1) = 0.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('34fd0348-7102-5b8a-8302-1b9577ab01e2', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 2 — L''arche centrale du pont d''Analysia est fissurée au point x = 4 : son profil g(x) = (√(x + 5) − 3)/(x − 4) n''y est pas défini. Pour colmater la fissure, tu dois prolonger g par continuité en 4. Quelle valeur donner à g(4) ?', '[{"id":"a","text":"1/6"},{"id":"b","text":"1/3"},{"id":"c","text":"1/2"},{"id":"d","text":"6"}]'::jsonb, 'a', 'En 4, √9 − 3 = 0 et x − 4 = 0 : forme 0/0. Expression conjuguée : (√(x + 5) − 3)(√(x + 5) + 3) = x + 5 − 9 = x − 4, donc g(x) = (x − 4)/((x − 4)(√(x + 5) + 3)) = 1/(√(x + 5) + 3), qui tend vers 1/(3 + 3) = 1/6 quand x → 4 ✓. La limite étant finie, on pose g(4) = 1/6 et la fissure est colmatée. Le piège courant : oublier le terme + 3 du conjugué au dénominateur donne 1/√9 = 1/3 ; recopier le résultat 1/2 de l''exemple du cours sans refaire le calcul ; et 6 est le dénominateur √9 + 3 sans prendre l''inverse.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7a149b92-97dd-545c-a583-5bf272b2eb7f', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 3 — Pour hisser la poutre maîtresse au sommet du pont, le treuil du chantier enroule un câble dont la tension vérifie T(x) ≥ x² − 5 pour tout x ≥ 0, où x est la longueur de câble enroulée. Aucune autre information n''est donnée sur T. Que peut-on affirmer pour lim x→+∞ T(x) ?', '[{"id":"a","text":"Elle vaut −5, la constante qui apparaît dans la minoration"},{"id":"b","text":"Elle est finie, car une fonction minorée admet une limite finie"},{"id":"c","text":"Elle vaut +∞, d''après le théorème de comparaison"},{"id":"d","text":"On ne peut rien conclure : une minoration seule ne donne jamais de limite"}]'::jsonb, 'c', 'C''est exactement le théorème de comparaison : T(x) ≥ x² − 5 au voisinage de +∞ et lim x→+∞ (x² − 5) = +∞, donc lim x→+∞ T(x) = +∞ ✓ — la tension explose, il faudra un câble de légende. Le piège courant : croire qu''il faut toujours deux gendarmes — pour une limite infinie, une seule minoration qui tend vers +∞ suffit ; l''encadrement complet ne sert que pour une limite finie. Répondre −5 lit la constante de la minoration, et « minorée donc limite finie » confond minoration et convergence : x² − 5 est minorée et tend pourtant vers +∞.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f010664a-2322-5b74-ab99-04ea17013ccc', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 4 — Le pilier sud du pont doit toucher le fond du ravin. La profondeur de sa pointe suit h(x) = x³ + 3x − 3, fonction continue et strictement croissante sur [0 ; 1] (somme de fonctions strictement croissantes), avec h(0) = −3 et h(1) = 1. Que peut-on affirmer pour l''équation h(x) = 0 sur [0 ; 1], le point exact où le pilier touche le fond ?', '[{"id":"a","text":"Elle n''admet aucune solution, car ni h(0) ni h(1) n''est égal à 0"},{"id":"b","text":"Elle admet au moins une solution, mais rien ne permet d''en garantir l''unicité"},{"id":"c","text":"Elle admet exactement une solution, car h(0) · h(1) < 0 garantit à lui seul l''existence et l''unicité"},{"id":"d","text":"Elle admet exactement une solution, car h est continue, strictement croissante, et 0 est compris entre h(0) et h(1)"}]'::jsonb, 'd', 'Toutes les hypothèses du corollaire du TVI sont réunies : h continue sur [0 ; 1], strictement croissante, et 0 compris entre h(0) = −3 et h(1) = 1 — l''équation h(x) = 0 admet donc une unique solution α dans [0 ; 1] ✓ : le pilier touche le fond en un point exactement. Le changement de signe seul (h(0) · h(1) < 0) ne garantit que l''existence, jamais l''unicité : ce verdict-là est juste mais sa justification est fausse. Ignorer la stricte croissance pourtant donnée prive à tort de l''unicité ; et exiger h(0) = 0 ou h(1) = 0 confond « s''annuler aux bornes » et « s''annuler dans l''intervalle ».', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0d9998e1-142f-58b9-9112-2bf36321029f', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 5 — Pour ancrer le pilier sud, il te faut localiser le point d''ancrage α, l''unique solution de h(x) = 0 sur [0 ; 1], où h(x) = x³ + 3x − 3 est continue et strictement croissante avec h(0) = −3 et h(1) = 1. Par dichotomie, tu calcules h(0,5) = −1,375 puis h(0,75) ≈ −0,33. Dans quel intervalle d''amplitude 0,25 se trouve α ?', '[{"id":"a","text":"]0 ; 0,5["},{"id":"b","text":"]0,5 ; 0,75["},{"id":"c","text":"]0,75 ; 1["},{"id":"d","text":"Nulle part : h(0,5) et h(0,75) étant tous deux négatifs, α n''existe pas"}]'::jsonb, 'c', 'Premier pas : h(0,5) = −1,375 < 0 et h(1) = 1 > 0, le changement de signe est dans ]0,5 ; 1[. Deuxième pas : h(0,75) ≈ −0,33 < 0 et h(1) = 1 > 0, donc α ∈ ]0,75 ; 1[ ✓, un intervalle d''amplitude 0,25 — l''ancrage est localisé. Répondre ]0 ; 0,5[ est une erreur de signe sur h(0,5) ; ]0,5 ; 0,75[ oublie que h(0,75) est encore négatif : le fond n''est pas atteint avant 0,75 ; et deux valeurs négatives ne condamnent pas α — c''est h(1) = 1 > 0 qui maintient le changement de signe, donc l''existence.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 6 — Dernière épreuve avant l''autre rive : la corde de traversée vibre, et son amplitude au point x est v(x) = x sin(1/x) pour x > 0. Le pont ne sera déclaré stable que si cette amplitude se stabilise au loin. Détermine lim x→+∞ x sin(1/x). (Rappel admis depuis la 3ème : lim t→0 (sin t)/t = 1.)', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"+∞"},{"id":"d","text":"Cette limite n''existe pas, car le sinus oscille sans se stabiliser"}]'::jsonb, 'b', 'Forme indéterminée du type +∞ × 0 : on pose t = 1/x. Quand x → +∞, t → 0⁺ et x sin(1/x) = sin(t)/t. Par la limite usuelle admise, sin(t)/t → 1, donc lim x→+∞ x sin(1/x) = 1 ✓ (limite d''une composée après changement d''écriture) : l''amplitude se stabilise, le pont de la continuité est réparé. Le piège courant : conclure 0 parce que sin(1/x) → 0, c''est remplacer un morceau d''un produit indéterminé par sa limite — l''opération illégale du chapitre ; +∞ ignore le facteur sin(1/x) qui tend vers 0 ; et sin(1/x) n''oscille pas en +∞ : son argument 1/x tend vers 0, donc il tend vers sin(0) = 0.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('edb002de-0e7f-5b7c-8d12-039559657254', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🏛️ Annales Bac ⭐⭐⭐⭐ : Session principale — Continuité et limites', 4, 300, 60, 'challenge', 'admin', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('269d83d5-c846-5358-a11b-055acb721037', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Soit a et b deux réels et f la fonction définie pour x ≠ 2 par f(x) = (x² + ax + b)/(x − 2). Déterminer les valeurs de a et b pour lesquelles f est prolongeable par continuité en 2, avec un prolongement vérifiant f(2) = 7.', '[{"id":"a","text":"a = −9 et b = 14"},{"id":"b","text":"a = −3 et b = −10"},{"id":"c","text":"a = 3 et b = −10"},{"id":"d","text":"a = 3 et b = 10"}]'::jsonb, 'c', 'Pour une limite finie en 2, le numérateur doit s''annuler en 2 : 4 + 2a + b = 0. On factorise alors x² + ax + b = (x − 2)(x − r), d''où f(x) = x − r pour x ≠ 2, et f(2) = 2 − r = 7 donne r = −5. Le numérateur vaut (x − 2)(x + 5) = x² + 3x − 10 : a = 3 et b = −10 ✓. Vérification par une seconde route : 4 + 2(3) + (−10) = 0 ✓ et, en posant x = 2 + h, (x² + 3x − 10)/(x − 2) = (7h + h²)/h = 7 + h → 7 quand h → 0 ✓. L''erreur classique : prendre la racine r = 7 au lieu de la valeur du prolongement 2 − r = 7 donne x² − 9x + 14, dont la limite en 2 vaut −5 ; une faute de signe en développant (x − 2)(x + 5) fabrique a = −3, et isoler b avec le mauvais signe donne b = 10 — dans ces deux cas le numérateur ne s''annule même plus en 2 (4 − 6 − 10 = −12 et 4 + 6 + 10 = 20), la limite est infinie et f n''est pas prolongeable.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('418ecd91-02f2-5e60-949a-4b77903ff934', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Calculer lim x→−∞ (√(x² + 2x) + x).', '[{"id":"a","text":"−∞"},{"id":"b","text":"−1"},{"id":"c","text":"0"},{"id":"d","text":"1"}]'::jsonb, 'b', 'Forme indéterminée ∞ − ∞ (√(x² + 2x) → +∞ et x → −∞). Expression conjuguée : √(x² + 2x) + x = (x² + 2x − x²)/(√(x² + 2x) − x) = 2x/(√(x² + 2x) − x). Pour x < 0, √x² = |x| = −x, donc √(x² + 2x) = −x√(1 + 2/x) et le dénominateur vaut −x(√(1 + 2/x) + 1) : l''expression se simplifie en −2/(√(1 + 2/x) + 1), qui tend vers −2/2 = −1 ✓. Contrôle numérique : pour x = −100, √9800 − 100 ≈ 98,995 − 100 = −1,005 ✓. L''erreur classique : écrire √(x² + 2x) ≈ x en −∞ (le signe |x| = −x est perdu) transforme la somme en 2x et conduit à −∞ ; lever ∞ − ∞ en « 0 » est une opération illégale ; et répondre 1 recopie le résultat du cas x → +∞, où le signe de x change tout.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9808b350-e59e-5b03-8df4-156a48f6313b', 'edb002de-0e7f-5b7c-8d12-039559657254', 'f est une fonction continue sur [0 ; 5] telle que f(0) = 2, f(2) = −1 et f(5) = 2. Aucune autre information n''est donnée. Laquelle de ces affirmations est justifiée par ces seules hypothèses ? <svg viewBox="0 0 240 185"><path d="M26.0 102.1 H226.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M226.0 102.1 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M39.8 14.0 V165.0" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M39.8 14.0 l-3 6 l6 0 z" fill="#0f172a"/><path d="M39.8 51.8 C51.3 64.3 80.0 127.2 108.8 127.2 C137.5 127.2 195.0 64.3 212.2 51.8" fill="none" stroke="#0f6e56" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="39.8" cy="51.8" r="3.5" fill="#0f172a"/><text x="39.8" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">0</text><circle cx="108.8" cy="127.2" r="3.5" fill="#0f172a"/><text x="108.8" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">2</text><circle cx="212.2" cy="51.8" r="3.5" fill="#0f172a"/><text x="212.2" y="178.0" text-anchor="middle" font-size="10" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">5</text></svg>', '[{"id":"a","text":"L''équation f(x) = 0 admet au moins deux solutions dans [0 ; 5]"},{"id":"b","text":"L''équation f(x) = 0 admet exactement deux solutions dans [0 ; 5]"},{"id":"c","text":"L''équation f(x) = 3 admet au moins une solution dans [0 ; 5]"},{"id":"d","text":"Le maximum de f sur [0 ; 5] est égal à 2"}]'::jsonb, 'a', 'Sur [0 ; 2] : f est continue et 0 est compris entre f(0) = 2 et f(2) = −1, donc le TVI fournit une solution α ∈ ]0 ; 2[ de f(x) = 0. Sur [2 ; 5] : 0 est compris entre f(2) = −1 et f(5) = 2, d''où une solution β ∈ ]2 ; 5[. Comme f(2) = −1 ≠ 0, on a bien α < 2 < β : au moins deux solutions ✓. L''erreur classique : annoncer « exactement deux » — sans stricte monotonie sur chaque morceau, f peut très bien s''annuler quatre fois ; invoquer le TVI pour f(x) = 3 alors que 3 n''est compris entre aucune des valeurs données (une fonction affine par morceaux passant par ces trois points ne dépasse jamais 2 ✓) ; et affirmer que le maximum vaut 2, alors que l''image d''un segment est [m ; M] où le maximum M peut être atteint à l''intérieur de l''intervalle et dépasser les valeurs connues aux trois points.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1782f429-e18c-5e6f-8bf9-0fc7f054cb33', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Pour montrer que l''équation x³ + 2x = 5 admet une unique solution α dans [1 ; 2] et l''encadrer, un candidat rédige :
① On pose f(x) = x³ + 2x − 5 ; f est continue sur [1 ; 2] comme fonction polynôme.
② f(1) = −2 < 0 et f(2) = 7 > 0.
③ D''après le théorème des valeurs intermédiaires, l''équation f(x) = 0 admet donc une unique solution α dans [1 ; 2].
④ f(1,5) = 1,375 > 0, donc α ∈ ]1 ; 1,5[.
Quelle étape rend cette rédaction irrecevable ?', '[{"id":"a","text":"L''étape ①"},{"id":"b","text":"L''étape ②"},{"id":"c","text":"L''étape ③"},{"id":"d","text":"L''étape ④"}]'::jsonb, 'c', 'L''erreur se cache à l''étape ③ : le théorème des valeurs intermédiaires garantit au moins une solution, jamais l''unicité. La rédaction correcte ajoute la stricte croissance de f — somme des fonctions strictement croissantes x ↦ x³ et x ↦ 2x − 5 — puis cite le corollaire (fonction continue et strictement monotone). Les étapes ① et ② sont exactes (f(1) = 1 + 2 − 5 = −2 ✓ et f(2) = 8 + 4 − 5 = 7 ✓), et l''étape ④ aussi : f(1,5) = 3,375 + 3 − 5 = 1,375 > 0 ✓, et avec f(1) < 0 le changement de signe place bien α dans ]1 ; 1,5[. L''erreur classique du candidat : conclure « unique » en ne citant que le TVI — la conclusion est vraie ici, mais la justification est invalide et coûte les points d''unicité ; c''est la démarche qu''il fallait invalider, pas le calcul de l''étape ④.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('128b72a3-9efc-5a82-9e82-7eba9bc9714a', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Soit f la fonction définie pour x ≠ 1 par f(x) = (x² − 1)/|x − 1|. Peut-on prolonger f par continuité en 1 ?', '[{"id":"a","text":"Oui, en posant f(1) = 0"},{"id":"b","text":"Oui, en posant f(1) = 2"},{"id":"c","text":"Oui, en posant f(1) = −2"},{"id":"d","text":"Non : f n''admet pas de limite en 1"}]'::jsonb, 'd', 'Pour x > 1, |x − 1| = x − 1 et f(x) = ((x − 1)(x + 1))/(x − 1) = x + 1, qui tend vers 2 ; pour x < 1, |x − 1| = −(x − 1) et f(x) = −(x + 1), qui tend vers −2. Les limites à droite (2) et à gauche (−2) sont différentes : f n''admet pas de limite en 1, donc aucun prolongement par continuité n''est possible ✓. Contrôle numérique : f(1,01) = 0,0201/0,01 = 2,01 et f(0,99) = −0,0199/0,01 = −1,99 ✓. L''erreur classique : simplifier |x − 1| comme s''il valait toujours x − 1 (le facteur « valeur absolue » est perdu dans la simplification) donne 2, qui n''est que la limite à droite ; ne garder que le côté gauche donne −2 ; et traiter la forme 0/0 comme nulle donne 0 — un prolongement exige une limite unique et finie, identique des deux côtés.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99763050-35a1-58e9-bdcf-b2e5cd3f3758', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Une seule des affirmations suivantes est vraie. Laquelle ?', '[{"id":"a","text":"Si lim x→+∞ f(x) = +∞ et lim x→+∞ g(x) = −∞, alors f + g n''admet pas de limite en +∞"},{"id":"b","text":"Si le dénominateur d''une fonction rationnelle s''annule en a, alors la droite d''équation x = a est une asymptote verticale de sa courbe"},{"id":"c","text":"Si lim x→a v(x) = b et lim y→b u(y) = ℓ, alors lim x→a v(u(x)) = ℓ"},{"id":"d","text":"Si lim x→a v(x) = b et lim y→b u(y) = ℓ, alors lim x→a u(v(x)) = ℓ"}]'::jsonb, 'd', 'Seule la dernière affirmation est vraie : c''est le théorème de la limite d''une composée, appliqué dans le bon sens — v agit d''abord, u ensuite, donc lim x→a u(v(x)) = ℓ ✓. Sa jumelle en v(u(x)) est fausse : avec a = 0, v(x) = x + 2 (donc b = 2) et u(y) = 3y (donc ℓ = 6), on obtient v(u(x)) = 3x + 2 → 2 ≠ 6 ✓ — c''est la composée dans le mauvais sens. « f + g n''a pas de limite » est fausse : ∞ − ∞ est une forme indéterminée, pas une absence de limite — f(x) = x + 5 et g(x) = −x donnent f(x) + g(x) = 5 → 5 ✓. Enfin, un dénominateur nul ne fabrique pas toujours une asymptote verticale : (x² − 4)/(x − 2) tend vers 4 en 2 (forme 0/0 levée par factorisation), la courbe n''y a aucune asymptote ✓. L''erreur classique : mémoriser ces énoncés sans leurs hypothèses ni leur sens d''application — au bac, chaque affirmation proche cache une condition précise qui la valide ou la ruine.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('14c81b3e-d34d-5f53-8b46-e0eb567ec09e', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', 'Test de compréhension ⭐ : Suites réelles', 1, 20, 5, 'quiz', 'admin', 0, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('10aa7bb5-c507-5da1-9666-b91adb8659c0', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Pour démontrer par récurrence qu''une propriété P(n) est vraie pour tout entier n ≥ n₀, après avoir vérifié l''initialisation, en quoi consiste l''étape d''hérédité ?', '[{"id":"a","text":"Supposer P(n) vraie pour un entier n ≥ n₀, puis démontrer P(n + 1)"},{"id":"b","text":"Vérifier que P(n₀) est vraie"},{"id":"c","text":"Supposer P(n) vraie pour tout entier n, puis conclure"},{"id":"d","text":"Vérifier P(n) pour n = n₀ et pour n = n₀ + 1"}]'::jsonb, 'a', 'L''hérédité consiste à supposer P(n) vraie pour un entier n ≥ n₀ quelconque (l''hypothèse de récurrence) et à en déduire P(n + 1). Vérifier P(n₀) est l''initialisation, pas l''hérédité ; supposer P(n) vraie « pour tout n » revient à supposer déjà ce qu''on veut prouver ; tester deux cas particuliers ne démontre rien pour tous les entiers.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ea4c5212-7b67-5a58-9a7f-71b75e69db95', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Par définition, une suite (Uₙ) est bornée lorsque :', '[{"id":"a","text":"il existe un réel M tel que Uₙ ≤ M pour tout n"},{"id":"b","text":"il existe deux réels m et M tels que m ≤ Uₙ ≤ M pour tout n"},{"id":"c","text":"elle est croissante"},{"id":"d","text":"elle est convergente"}]'::jsonb, 'b', '(Uₙ) est bornée si elle est à la fois majorée et minorée : il existe m et M tels que m ≤ Uₙ ≤ M pour tout n. L''option a ne décrit qu''une suite majorée. La croissance n''a aucun rapport avec le fait d''être bornée. Toute suite convergente est bornée, mais la réciproque est fausse (Uₙ = (−1)ⁿ est bornée sans converger), donc « convergente » n''est pas la définition.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8546da9c-0e6b-5950-9526-0b12cce6ac68', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Que peut-on dire de la suite de terme général Uₙ = (−3/2)ⁿ ?', '[{"id":"a","text":"Elle converge vers 0"},{"id":"b","text":"Elle tend vers +∞"},{"id":"c","text":"Elle tend vers −∞"},{"id":"d","text":"Elle n''a pas de limite"}]'::jsonb, 'd', 'Ici q = −3/2 vérifie |q| = 3/2 > 1 et q ≤ −1 : d''après le théorème sur (qⁿ), la suite n''a pas de limite, car ses termes changent de signe tout en grandissant en valeur absolue. Répondre 0 confond q < 1 avec |q| < 1 (le piège classique) ; +∞ ou −∞ oublie que la base négative fait alterner le signe, ce qui interdit toute limite.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('97623e2b-f10b-5039-b5ac-a86172bd88e0', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Parmi ces situations rencontrées dans un calcul de limite de suites, laquelle est une forme indéterminée ?', '[{"id":"a","text":"(+∞) + (+∞)"},{"id":"b","text":"(+∞) × 2"},{"id":"c","text":"(+∞) − (+∞)"},{"id":"d","text":"2 / (+∞)"}]'::jsonb, 'c', 'La différence de deux limites infinies de même signe est la forme indéterminée ∞ − ∞ : on ne peut pas conclure sans transformer l''expression. En revanche (+∞) + (+∞) = +∞, (+∞) × 2 = +∞ et 2/(+∞) = 0 sont des résultats déterminés par les règles d''opérations.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d25630b2-2402-5128-a103-43c95667785d', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Une suite (Uₙ) vérifie −1/n ≤ Uₙ ≤ 1/n pour tout n ≥ 1. Que peut-on conclure ?', '[{"id":"a","text":"(Uₙ) est croissante"},{"id":"b","text":"lim Uₙ = 0"},{"id":"c","text":"lim Uₙ = 1"},{"id":"d","text":"On ne peut rien conclure sur la limite"}]'::jsonb, 'b', 'Les deux suites qui encadrent (Uₙ) sont −1/n et 1/n : elles tendent toutes deux vers 0. D''après le théorème des gendarmes, lim Uₙ = 0. L''encadrement ne renseigne pas sur la monotonie (a est infondé). La valeur 1 est la limite de n × (1/n), pas de Uₙ. Enfin, l''encadrement suffit précisément à conclure : d ignore le théorème des gendarmes.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ef6ec993-83ac-5801-879a-82ab207290a0', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Que peut-on affirmer d''une suite (Uₙ) croissante et majorée ?', '[{"id":"a","text":"Elle tend vers +∞"},{"id":"b","text":"Elle converge vers son majorant"},{"id":"c","text":"Elle converge vers un réel"},{"id":"d","text":"Elle est constante"}]'::jsonb, 'c', 'Le théorème de la convergence des suites monotones affirme qu''une suite croissante et majorée converge vers un réel. Elle ne tend pas vers +∞ (c''est le cas d''une suite croissante NON majorée). Elle ne converge pas forcément vers son majorant : Uₙ = 1 − 1/n est majorée par 100 mais converge vers 1 — le théorème donne l''existence de la limite, pas sa valeur. Une suite croissante n''a aucune raison d''être constante.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cf41176c-39cd-5a86-acc5-7e0ad7c94df0', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Une suite (Uₙ) est définie par Uₙ₊₁ = f(Uₙ), où f est une fonction continue. On sait que (Uₙ) converge vers un réel ℓ. Quelle égalité vérifie ℓ ?', '[{"id":"a","text":"ℓ = 0"},{"id":"b","text":"ℓ = f(ℓ)"},{"id":"c","text":"f(ℓ) = 0"},{"id":"d","text":"ℓ = f(ℓ + 1)"}]'::jsonb, 'b', 'D''après le théorème du point fixe, si (Uₙ) converge vers ℓ et si f est continue en ℓ, alors ℓ = f(ℓ) : la limite est un point fixe de f. Les autres égalités sont inventées : rien n''impose ℓ = 0 ni f(ℓ) = 0, et ℓ = f(ℓ + 1) n''a pas de sens (on passe à la limite dans Uₙ₊₁ = f(Uₙ), les deux membres tendent vers ℓ et f(ℓ)).', 7, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6bcb0d93-7ac2-5ec9-9a41-063c0e69c5b9', '14c81b3e-d34d-5f53-8b46-e0eb567ec09e', 'Deux suites (Uₙ) et (Vₙ) sont adjacentes. Que peut-on en déduire ?', '[{"id":"a","text":"Elles convergent vers une même limite"},{"id":"b","text":"Elles convergent vers deux limites différentes"},{"id":"c","text":"L''une converge et l''autre diverge"},{"id":"d","text":"Elles sont toutes deux constantes"}]'::jsonb, 'a', 'Par définition, deux suites adjacentes vérifient Uₙ ≤ Vₙ, (Uₙ) croissante, (Vₙ) décroissante et Vₙ − Uₙ → 0 ; le théorème garantit alors qu''elles convergent vers une même limite. Elles ne peuvent donc pas avoir deux limites distinctes, ni l''une converger sans l''autre. Le caractère strictement croissant/décroissant interdit justement qu''elles soient constantes.', 8, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('84a587a1-39ac-5341-88d1-9a7442c13a14', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', '⭐ Exercice : Premiers pas avec les suites', 1, 50, 10, 'practice', 'admin', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('46760fd6-24bc-52fe-9bdf-aa5717455bf0', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'Calculer la limite de la suite de terme général Uₙ = 3 + 1/n (n ≥ 1).', '[{"id":"a","text":"0"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"+∞"}]'::jsonb, 'b', 'Comme 1/n → 0, la somme 3 + 1/n tend vers 3 + 0 = 3 ✓. Répondre 0 ne garde que la limite de 1/n en oubliant le terme 3 ; 4 correspond à la valeur du premier terme U₁ = 3 + 1 = 4, pas à la limite ; +∞ suppose à tort que la suite grandit sans fin.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5ed925cd-39cb-5459-94a4-36938c17804a', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'Soit la suite définie par Uₙ = 2n − 5 (n ≥ 0). Quel est son sens de variation ?', '[{"id":"a","text":"Croissante"},{"id":"b","text":"Décroissante"},{"id":"c","text":"Constante"},{"id":"d","text":"Ni croissante ni décroissante"}]'::jsonb, 'a', 'On étudie le signe de Uₙ₊₁ − Uₙ = (2(n + 1) − 5) − (2n − 5) = 2 > 0, donc la suite est croissante ✓. La croissance vient du coefficient 2 > 0 (c''est une suite arithmétique de raison 2). La conclure décroissante inverse le signe ; « constante » supposerait une raison nulle ; « ni l''un ni l''autre » ignore que la différence a un signe constant.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('17562b38-3c5e-50c1-bc2e-00bd9a6bb458', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'Calculer la limite de la suite de terme général Uₙ = (2/3)ⁿ (n ≥ 0).', '[{"id":"a","text":"0"},{"id":"b","text":"2/3"},{"id":"c","text":"1"},{"id":"d","text":"+∞"}]'::jsonb, 'a', 'C''est une suite géométrique de raison q = 2/3 avec |q| < 1, donc lim (2/3)ⁿ = 0 ✓. Répondre 2/3 confond la limite avec la raison ; 1 est la valeur du premier terme (2/3)⁰ = 1, pas la limite ; +∞ correspondrait à une raison q > 1.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9bf02dbd-ada9-5b8d-a340-e03f6902f29f', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'Calculer la limite de la suite de terme général Uₙ = 4ⁿ (n ≥ 0).', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"4"},{"id":"d","text":"+∞"}]'::jsonb, 'd', 'C''est une suite géométrique de raison q = 4 avec q > 1, donc lim 4ⁿ = +∞ ✓. Répondre 0 confond avec le cas |q| < 1 ; 1 est la valeur de 4⁰ ; 4 confond la limite avec la raison de la suite.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f6bc57a6-7dc3-56b6-9e2d-ed9e80524af6', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'Soit la suite de terme général Uₙ = (−1)ⁿ. Laquelle de ces affirmations est vraie ?', '[{"id":"a","text":"Elle est convergente"},{"id":"b","text":"Elle est non majorée"},{"id":"c","text":"Elle est bornée"},{"id":"d","text":"Elle est croissante"}]'::jsonb, 'c', 'Pour tout n, Uₙ vaut 1 ou −1, donc −1 ≤ Uₙ ≤ 1 : la suite est bornée ✓. Elle n''est pas convergente, car elle prend indéfiniment les valeurs 1 et −1 sans se rapprocher d''un unique réel. Étant bornée, elle est en particulier majorée (b est faux). Elle alterne, donc elle n''est ni croissante ni décroissante.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('435bbae0-33c6-5fd1-912d-f534ae3cea9b', '84a587a1-39ac-5341-88d1-9a7442c13a14', 'Calculer la limite de la suite de terme général Uₙ = (2n + 3)/n (n ≥ 1).', '[{"id":"a","text":"0"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"+∞"}]'::jsonb, 'b', 'On sépare : Uₙ = (2n + 3)/n = 2 + 3/n. Comme 3/n → 0, la limite vaut 2 + 0 = 2 ✓. Répondre 3 ne garde que le numérateur constant ; +∞ laisse la forme ∞/∞ sans la lever ; 0 confond avec la limite de 3/n seul.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('a07a3a68-7c35-592e-b8ce-f6ac30e459ac', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', '⚔️ Boss du chapitre ⭐⭐⭐ : Le dompteur de l''infini', 3, 120, 30, 'boss', 'admin', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5dbc94fb-5eb4-59b3-94bd-ba9651935a15', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', 'Soit (Uₙ) définie par U₀ = 3 et Uₙ₊₁ = 2Uₙ − 1. On pose Vₙ = Uₙ − 1. Déterminer la nature de (Vₙ), puis l''expression de Uₙ en fonction de n.', '[{"id":"a","text":"Uₙ = 3 × 2ⁿ"},{"id":"b","text":"Uₙ = 2ⁿ⁺¹ + 1"},{"id":"c","text":"Uₙ = 2ⁿ + 1"},{"id":"d","text":"Uₙ = 2ⁿ⁺¹ − 1"}]'::jsonb, 'b', 'V₀ = U₀ − 1 = 2, et Vₙ₊₁ = Uₙ₊₁ − 1 = 2Uₙ − 2 = 2(Uₙ − 1) = 2Vₙ : (Vₙ) est géométrique de raison 2 et de premier terme 2, donc Vₙ = 2 × 2ⁿ = 2ⁿ⁺¹. Ainsi Uₙ = Vₙ + 1 = 2ⁿ⁺¹ + 1 ✓ (contrôle : U₀ = 2 + 1 = 3 ✓, U₁ = 2 × 3 − 1 = 5 = 2² + 1 ✓). Le piège courant : oublier que V₀ = 2 et écrire Vₙ = 2ⁿ donne 2ⁿ + 1 ; traiter (Uₙ) elle-même comme géométrique de raison 2 (la constante −1 ignorée) donne 3 × 2ⁿ ; et reconstruire Uₙ = Vₙ − 1 au lieu de Vₙ + 1 fabrique 2ⁿ⁺¹ − 1.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('96f959d1-6966-5feb-9781-7f0471d9e541', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', 'On considère la suite définie pour n ≥ 0 par Uₙ = (2n − 1)/(n + 1). Étudier sa monotonie.', '[{"id":"a","text":"Strictement décroissante"},{"id":"b","text":"Constante, égale à 2"},{"id":"c","text":"Croissante puis décroissante"},{"id":"d","text":"Strictement croissante"}]'::jsonb, 'd', 'On calcule Uₙ₊₁ − Uₙ = (2n + 1)/(n + 2) − (2n − 1)/(n + 1). Au même dénominateur (n + 1)(n + 2), le numérateur vaut (2n + 1)(n + 1) − (2n − 1)(n + 2) = (2n² + 3n + 1) − (2n² + 3n − 2) = 3. Donc Uₙ₊₁ − Uₙ = 3/((n + 1)(n + 2)) > 0 : (Uₙ) est strictement croissante ✓ (contrôle : U₀ = −1, U₁ = 1/2, U₂ = 1, ça monte ✓). Le piège courant : une faute de signe dans la soustraction (calculer Uₙ − Uₙ₊₁) donne −3 et conclut à tort « décroissante » ; confondre la limite 2 (ou le majorant 2) avec une valeur constante donne « constante égale à 2 », alors qu''aucun terme ne vaut 2.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('941385bd-aaa6-5762-9b93-53ac52b6fe07', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', 'Déterminer la limite de la suite définie pour n ≥ 0 par Uₙ = (3n + (−1)ⁿ)/(n + 1).', '[{"id":"a","text":"3"},{"id":"b","text":"La limite n''existe pas, car (−1)ⁿ n''a pas de limite"},{"id":"c","text":"+∞"},{"id":"d","text":"0"}]'::jsonb, 'a', 'Pour tout n, −1 ≤ (−1)ⁿ ≤ 1, donc (3n − 1)/(n + 1) ≤ Uₙ ≤ (3n + 1)/(n + 1). Les deux bornes tendent vers 3 (quotient de deux polynômes de même degré, rapport des coefficients dominants 3/1). Par le théorème des gendarmes, lim Uₙ = 3 ✓. Le piège courant : croire que l''oscillation de (−1)ⁿ empêche toute limite — l''encadrement la neutralise complètement ; répondre +∞ oublie de diviser par le degré du dénominateur (le 3n est compensé par le n du bas) ; et 0 ne retient que le terme (−1)ⁿ/(n + 1) → 0 en négligeant le 3n.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1eb40098-505d-5a4e-bec9-c66b09fa0cfc', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', 'Soit (Uₙ) définie par U₀ = 0 et Uₙ₊₁ = √(Uₙ + 2). Un élève rédige :
① La fonction f : x ↦ √(x + 2) est continue sur [0 ; +∞[.
② Si (Uₙ) converge vers ℓ ≥ 0, alors ℓ = √(ℓ + 2), soit ℓ² − ℓ − 2 = 0, d''où ℓ = 2.
③ Conclusion : lim Uₙ = 2.
Que penser de ce raisonnement ?', '[{"id":"a","text":"Il est complet et correct"},{"id":"b","text":"L''erreur est à l''étape ② : l''équation admet aussi la solution ℓ = −1, donc la limite est −1"},{"id":"c","text":"L''erreur est à l''étape ③ : on affirme que (Uₙ) converge sans l''avoir démontré ; le point fixe ne donne la limite qu''après avoir prouvé la convergence (suite croissante et majorée)"},{"id":"d","text":"L''erreur est à l''étape ① : f n''est pas continue en 2"}]'::jsonb, 'c', 'L''étape ③ est irrecevable ✓ : l''étape ② n''établit la valeur de la limite que SI (Uₙ) converge. Or la convergence n''a jamais été prouvée — il faut d''abord montrer que (Uₙ) est croissante et majorée (par 2) pour garantir qu''elle converge, puis seulement identifier ℓ = 2 par le point fixe. Sauter cette étape est l''erreur la plus sanctionnée du chapitre : trouver le point fixe ne prouve jamais à lui seul la convergence. Les étapes ① et ② sont exactes (ℓ = −1 est bien racine de ℓ² − ℓ − 2 = 0, mais rejetée car Uₙ ≥ 0, donc la valeur retenue 2 est correcte ; et f est continue sur tout [0 ; +∞[). C''est donc la démarche, pas le résultat final, qu''il fallait invalider.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('099aeffc-3a34-58bd-9d23-a60c91b03d3a', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', 'Soit (Uₙ) définie par U₀ = 4 et Uₙ₊₁ = √(3Uₙ). On admet que (Uₙ) est décroissante et minorée par 3. Vers quelle limite converge-t-elle ?', '[{"id":"a","text":"√3"},{"id":"b","text":"3"},{"id":"c","text":"0"},{"id":"d","text":"(Uₙ) diverge : une suite décroissante finit toujours par tendre vers −∞"}]'::jsonb, 'b', '(Uₙ) étant décroissante et minorée par 3, le théorème de convergence des suites monotones garantit qu''elle converge vers un réel ℓ ≥ 3. La fonction f : x ↦ √(3x) étant continue, le point fixe donne ℓ = √(3ℓ), soit ℓ² = 3ℓ, d''où ℓ(ℓ − 3) = 0 : ℓ = 0 ou ℓ = 3. Comme ℓ ≥ 3, on retient ℓ = 3 ✓. Le piège courant : garder la racine parasite ℓ = 0, incompatible avec la minoration Uₙ ≥ 3 ; résoudre ℓ = √(3ℓ) comme ℓ² = 3 (au lieu de 3ℓ) fabrique √3 ; et croire qu''une suite décroissante tend nécessairement vers −∞ ignore l''hypothèse « minorée », qui interdit précisément cela.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e727abd1-8cd9-512b-8e73-c3eefd006811', 'a07a3a68-7c35-592e-b8ce-f6ac30e459ac', 'Une seule des affirmations suivantes est vraie. Laquelle ?', '[{"id":"a","text":"Toute suite bornée est convergente"},{"id":"b","text":"Si (Uₙ) est croissante et majorée, alors elle converge et sa limite est égale à son majorant"},{"id":"c","text":"Si ℓ est un point fixe de f (ℓ = f(ℓ)), alors toute suite définie par Uₙ₊₁ = f(Uₙ) converge vers ℓ"},{"id":"d","text":"Si (Uₙ) converge vers ℓ et vérifie Uₙ₊₁ = f(Uₙ) avec f continue en ℓ, alors ℓ = f(ℓ)"}]'::jsonb, 'd', 'Seule d est vraie ✓ : c''est le théorème du point fixe (si la suite converge et f est continue en la limite, alors la limite vérifie ℓ = f(ℓ)). a est fausse : Uₙ = (−1)ⁿ est bornée (−1 ≤ Uₙ ≤ 1) mais ne converge pas (U₂ₙ → 1, U₂ₙ₊₁ → −1). b est fausse : « croissante et majorée » garantit l''existence d''une limite, jamais qu''elle vaille le majorant — Uₙ = 1 − 1/n est majorée par 100 et converge vers 1. c est fausse : c''est la réciproque illusoire du point fixe — l''existence d''un point fixe ne force aucune convergence (il faut prouver monotonie + bornée). Le piège courant : mémoriser le point fixe « dans les deux sens », alors qu''il ne fonctionne que de la convergence vers l''équation ℓ = f(ℓ).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('658de6da-fd2c-57d3-9453-4648d9475e11', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', '⭐⭐ Révision (type examen) : Limites de suites', 2, 75, 15, 'practice', 'admin', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0e27f1f0-dc12-5606-a172-09fdfd4a462b', '658de6da-fd2c-57d3-9453-4648d9475e11', 'Calculer la limite de la suite de terme général Uₙ = (4n + 3)/(2n − 1) (n ≥ 1).', '[{"id":"a","text":"0"},{"id":"b","text":"2"},{"id":"c","text":"4"},{"id":"d","text":"+∞"}]'::jsonb, 'b', 'On divise numérateur et dénominateur par n : Uₙ = (4 + 3/n)/(2 − 1/n) → (4 + 0)/(2 − 0) = 2 ✓. Répondre 4 ne garde que le coefficient du numérateur ; 0 confond avec la limite des restes 3/n et 1/n ; +∞ laisse la forme ∞/∞ sans la lever.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4d5e07ba-525b-5a10-82b0-9c6166bfc9a9', '658de6da-fd2c-57d3-9453-4648d9475e11', 'Calculer la limite de la suite de terme général Uₙ = n² − n (n ≥ 0).', '[{"id":"a","text":"−∞"},{"id":"b","text":"0"},{"id":"c","text":"1"},{"id":"d","text":"+∞"}]'::jsonb, 'd', 'Face à la forme indéterminée ∞ − ∞, on factorise le terme dominant : n² − n = n²(1 − 1/n). Comme n² → +∞ et 1 − 1/n → 1, le produit tend vers +∞ ✓. Répondre 0 « annule » illégalement les deux infinis ; 1 s''arrête à la limite de la parenthèse ; −∞ prend le signe du terme −n en oubliant que n² domine.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('74c3ec40-e067-5a72-9026-cf0d7f66cc0f', '658de6da-fd2c-57d3-9453-4648d9475e11', 'Calculer la limite de la suite de terme général Uₙ = 2ⁿ/(2ⁿ + 1) (n ≥ 0).', '[{"id":"a","text":"0"},{"id":"b","text":"1/2"},{"id":"c","text":"1"},{"id":"d","text":"+∞"}]'::jsonb, 'c', 'On divise haut et bas par 2ⁿ : Uₙ = 1/(1 + (1/2)ⁿ). Comme (1/2)ⁿ → 0, la limite vaut 1/(1 + 0) = 1 ✓. Répondre 0 suppose à tort que le numérateur devient négligeable ; 1/2 vient du rapport des coefficients ; +∞ laisse la forme ∞/∞ non levée.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99cfcded-1744-5715-871e-d75394677221', '658de6da-fd2c-57d3-9453-4648d9475e11', 'Calculer la limite de la suite de terme général Uₙ = sin(n)/n (n ≥ 1).', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"−1"},{"id":"d","text":"Pas de limite"}]'::jsonb, 'a', 'Comme −1 ≤ sin(n) ≤ 1, on a |Uₙ| = |sin(n)|/n ≤ 1/n. Or 1/n → 0, donc par le corollaire de la valeur absolue lim Uₙ = 0 ✓. Répondre « pas de limite » retient l''oscillation de sin(n) en oubliant le facteur 1/n qui l''écrase ; 1 et −1 confondent la limite avec les bornes de sin(n).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('302a50af-7846-5420-8aed-6603a00c9947', '658de6da-fd2c-57d3-9453-4648d9475e11', 'Soit la suite définie par U₀ = 1 et Uₙ₊₁ = √(Uₙ + 1). On admet que (Uₙ) converge vers un réel ℓ ≥ 0. Que vaut ℓ ?', '[{"id":"a","text":"1"},{"id":"b","text":"(1 + √5)/2"},{"id":"c","text":"(1 − √5)/2"},{"id":"d","text":"2"}]'::jsonb, 'b', 'La fonction f : x ↦ √(x + 1) est continue, donc le point fixe donne ℓ = √(ℓ + 1), soit ℓ² = ℓ + 1, c''est-à-dire ℓ² − ℓ − 1 = 0. Les racines sont (1 + √5)/2 et (1 − √5)/2 ; comme ℓ ≥ 0, on garde ℓ = (1 + √5)/2 ✓. La racine (1 − √5)/2 est négative, donc rejetée. Les valeurs 1 et 2 ne vérifient pas ℓ² = ℓ + 1.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1cd33640-ea7c-56b7-a64d-01dd5204857f', '658de6da-fd2c-57d3-9453-4648d9475e11', 'Calculer la limite de la suite de terme général Uₙ = √(n + 1) − √n (n ≥ 0).', '[{"id":"a","text":"0"},{"id":"b","text":"1/2"},{"id":"c","text":"1"},{"id":"d","text":"+∞"}]'::jsonb, 'a', 'Forme indéterminée ∞ − ∞ : on multiplie par la quantité conjuguée. √(n + 1) − √n = ((n + 1) − n)/(√(n + 1) + √n) = 1/(√(n + 1) + √n). Le dénominateur tend vers +∞, donc la limite vaut 0 ✓. Répondre +∞ compare mal deux termes qui se rapprochent ; 1 oublie le dénominateur ; 1/2 confond avec un autre encadrement.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('1e85e857-5080-5bf7-ab03-242b64aa7507', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', '👑 Défi élite ⭐⭐⭐⭐ : L''étau des suites adjacentes', 4, 300, 60, 'challenge', 'admin', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6dfce643-a6d1-57de-98c0-85635b3743f0', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'Soit Uₙ = 2 − 1/n et Vₙ = 2 + 1/n² pour n ≥ 1. Que peut-on affirmer sur ces deux suites ?', '[{"id":"a","text":"Elles ne sont pas adjacentes, car (Vₙ) est croissante"},{"id":"b","text":"Elles sont adjacentes, mais convergent vers deux limites différentes"},{"id":"c","text":"Elles sont adjacentes et convergent toutes deux vers 2"},{"id":"d","text":"Elles ne sont pas adjacentes, car on n''a jamais Uₙ = Vₙ"}]'::jsonb, 'c', 'Vérifions les trois conditions : (i) Uₙ ≤ Vₙ car 2 − 1/n ≤ 2 + 1/n² ✓ ; (ii) (Uₙ) est croissante (Uₙ₊₁ − Uₙ = 1/n − 1/(n + 1) > 0) et (Vₙ) est décroissante (1/n² décroît) ✓ ; (iii) Vₙ − Uₙ = 1/n² + 1/n → 0 ✓. Les suites sont donc adjacentes, et par définition elles convergent vers la MÊME limite ; comme Uₙ → 2, cette limite commune est 2 ✓. Le piège courant : croire que deux suites adjacentes peuvent avoir des limites différentes — la définition impose exactement l''inverse ; exiger Uₙ = Vₙ confond « adjacentes » avec « égales » ; et lire (Vₙ) comme croissante inverse le signe de Vₙ₊₁ − Vₙ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1eda069f-24cd-5685-9690-1b38f2fd0f12', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'Deux suites adjacentes (Uₙ) et (Vₙ) vérifient Vₙ − Uₙ = 1/2ⁿ. À partir de quel rang n est-on certain que leur limite commune est encadrée à moins de 10⁻³ près, c''est-à-dire Vₙ − Uₙ ≤ 10⁻³ ?', '[{"id":"a","text":"n ≥ 10"},{"id":"b","text":"n ≥ 9"},{"id":"c","text":"n ≥ 3"},{"id":"d","text":"n ≥ 1000"}]'::jsonb, 'a', 'On cherche le plus petit n tel que 1/2ⁿ ≤ 10⁻³, soit 2ⁿ ≥ 1000. Or 2⁹ = 512 < 1000 et 2¹⁰ = 1024 ≥ 1000 : la condition est vérifiée dès n ≥ 10 ✓. Comme (Uₙ) croît vers la limite ℓ et (Vₙ) décroît vers ℓ, on a Uₙ ≤ ℓ ≤ Vₙ, donc Vₙ − Uₙ ≤ 10⁻³ garantit bien un encadrement de ℓ à 10⁻³ près. Le piège courant : s''arrêter à n ≥ 9 sans vérifier que 2⁹ = 512 est insuffisant (erreur classique du « à un rang près ») ; lire l''exposant 3 de 10⁻³ comme le rang cherché donne n ≥ 3 ; et n ≥ 1000 confond la valeur seuil 1000 = 2ⁿ avec n lui-même.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('720e16da-50e8-5924-95e9-0636c87133a0', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'Pour n ≥ 1, on pose Wₙ = 1/(1 × 2) + 1/(2 × 3) + … + 1/(n(n + 1)). Sachant que 1/(k(k + 1)) = 1/k − 1/(k + 1), déterminer lim Wₙ.', '[{"id":"a","text":"0"},{"id":"b","text":"+∞"},{"id":"c","text":"2"},{"id":"d","text":"1"}]'::jsonb, 'd', 'La somme est télescopique : Wₙ = (1 − 1/2) + (1/2 − 1/3) + … + (1/n − 1/(n + 1)) = 1 − 1/(n + 1), tous les termes intermédiaires se simplifient deux à deux. Comme 1/(n + 1) → 0, on obtient lim Wₙ = 1 ✓ (contrôle : W₁ = 1/2 = 1 − 1/2 ✓, W₂ = 1/2 + 1/6 = 2/3 = 1 − 1/3 ✓). Le piège courant : croire qu''une somme dont les termes tendent vers 0 tend elle-même vers 0 (faux : le nombre de termes croît) ; croire qu''une somme infinie de termes positifs vaut toujours +∞ (faux ici, elle est majorée par 1) ; et une erreur de signe dans le télescopage (sommer 1/k + 1/(k + 1)) laisse deux termes de bord et conduit à la valeur erronée 2.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('94b62195-57c3-5211-bf2b-b3bd11ae1f72', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'Pour n ≥ 1, on pose Vₙ = n/(n² + 1) + n/(n² + 2) + … + n/(n² + n) (somme de n termes). Déterminer lim Vₙ.', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"+∞"},{"id":"d","text":"La limite n''existe pas"}]'::jsonb, 'b', 'Chacun des n termes est compris entre le plus petit, n/(n² + n), et le plus grand, n/(n² + 1). En sommant les n termes : n × n/(n² + n) ≤ Vₙ ≤ n × n/(n² + 1), soit n²/(n² + n) ≤ Vₙ ≤ n²/(n² + 1). Les deux bornes tendent vers 1 (polynômes de même degré), donc par le théorème des gendarmes lim Vₙ = 1 ✓. Le piège courant : croire que Vₙ → 0 parce que chaque terme tend vers 0 — c''est faux, car le nombre de termes augmente en même temps (indétermination 0 × ∞ cachée) ; répondre +∞ surestime la somme ; et « pas de limite » ignore l''encadrement qui la fixe précisément.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('195d5ed9-6a31-5671-ad04-0d97cd1afeeb', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'Les suites Uₙ = 1 + 1/1! + 1/2! + … + 1/n! et Vₙ = Uₙ + 1/(n × n!) sont adjacentes, de limite commune e. On donne U₃ = 8/3 et V₃ = 49/18. Quel encadrement de e en découle ?', '[{"id":"a","text":"8/3 ≤ e ≤ 49/18"},{"id":"b","text":"49/18 ≤ e ≤ 8/3"},{"id":"c","text":"e ≤ 8/3"},{"id":"d","text":"e ≥ 49/18"}]'::jsonb, 'a', '(Uₙ) est croissante et converge vers e, donc Uₙ ≤ e pour tout n : en particulier 8/3 ≤ e. (Vₙ) est décroissante et converge vers e, donc e ≤ Vₙ : en particulier e ≤ 49/18. D''où 8/3 ≤ e ≤ 49/18 ✓ (soit 2,667 ≤ e ≤ 2,722, cohérent avec e ≈ 2,718 ✓). Le piège courant : inverser les rôles en écrivant 49/18 ≤ e ≤ 8/3 — cela revient à croire que la suite croissante majore e et la décroissante le minore, exactement l''inverse ; ne garder qu''une seule des deux inégalités (c ou d) perd la moitié de l''encadrement.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1e026ae9-bdf1-5c4e-9d0b-fa1275855b50', '1e85e857-5080-5bf7-ab03-242b64aa7507', 'Soit (Uₙ) et (Vₙ) définies par U₀ = 1, V₀ = 2 et, pour n ≥ 0, Uₙ₊₁ = (2Uₙ + Vₙ)/3 et Vₙ₊₁ = (Uₙ + 2Vₙ)/3. On admet qu''elles sont adjacentes. En remarquant que la suite (Uₙ + Vₙ) est constante, déterminer leur limite commune α.', '[{"id":"a","text":"3"},{"id":"b","text":"1"},{"id":"c","text":"3/2"},{"id":"d","text":"2"}]'::jsonb, 'c', 'Calculons Uₙ₊₁ + Vₙ₊₁ = (2Uₙ + Vₙ)/3 + (Uₙ + 2Vₙ)/3 = (3Uₙ + 3Vₙ)/3 = Uₙ + Vₙ : la suite (Uₙ + Vₙ) est constante, égale à U₀ + V₀ = 3. Les deux suites étant adjacentes, elles convergent vers la même limite α ; en passant à la limite dans Uₙ + Vₙ = 3, on obtient α + α = 3, soit 2α = 3, d''où α = 3/2 ✓. Le piège courant : confondre la constante Uₙ + Vₙ = 3 avec la limite elle-même (oubli du facteur 2) ; prendre α = U₀ = 1 ou α = V₀ = 2, comme si la limite était l''une des valeurs initiales — or les termes convergent l''un vers l''autre, strictement entre 1 et 2.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('a59a80d6-7c0f-5d58-a2d0-4373893ea87a', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', '🧩 Mission interactive ⭐⭐ : L''atelier des suites', 2, 75, 15, 'practice', 'admin', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('672c8134-6a3c-506e-8054-7ec223e2c413', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'Chasse à l''erreur — la suite est définie par U₀ = 2 et Uₙ₊₁ = 2Uₙ − 1. Un élève démontre par récurrence que Uₙ = 2ⁿ + 1 pour tout n ≥ 0 :
① Initialisation : U₀ = 2 et 2⁰ + 1 = 1 + 1 = 2, la propriété est vraie au rang 0.
② Hérédité : on suppose Uₙ = 2ⁿ + 1 pour un entier n ≥ 0.
③ Alors Uₙ₊₁ = 2Uₙ − 1 = 2(2ⁿ + 1) − 1 = 2ⁿ⁺¹ + 1 − 1 = 2ⁿ⁺¹.
④ Conclusion : la propriété est héréditaire, donc vraie pour tout n ≥ 0.
Une seule étape contient une erreur : laquelle ?', '[{"id":"a","text":"L''étape ①"},{"id":"b","text":"L''étape ②"},{"id":"c","text":"L''étape ③"},{"id":"d","text":"L''étape ④"}]'::jsonb, 'c', 'L''erreur est à l''étape ③ : dans 2(2ⁿ + 1), le facteur 2 doit multiplier AUSSI le terme 1, donc 2(2ⁿ + 1) = 2ⁿ⁺¹ + 2 (et non 2ⁿ⁺¹ + 1). Étape corrigée : 2(2ⁿ + 1) − 1 = 2ⁿ⁺¹ + 2 − 1 = 2ⁿ⁺¹ + 1 ✓, ce qui est exactement 2ⁿ⁺¹ + 1, la formule au rang n + 1 : l''hérédité est en réalité vérifiée. L''initialisation ① est exacte (U₀ = 2), l''hypothèse ② est correctement posée, et ④ ne fait que dérouler la conclusion : le seul défaut est la distributivité mal appliquée en ③ (2 × 1 = 2, pas 1).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('429ab459-4f9e-5394-b422-d4e06eb0e7b1', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'Remise en ordre — on veut prouver que la suite U₀ = 1, Uₙ₊₁ = √(Uₙ + 1) converge, puis trouver sa limite. Quatre étapes sont données dans le désordre :
① Par le théorème des suites monotones, (Uₙ) est croissante et majorée par 2 : elle converge vers un réel ℓ.
② Montrer par récurrence que 1 ≤ Uₙ ≤ 2 pour tout n.
③ Comme f : x ↦ √(x + 1) est continue, ℓ vérifie ℓ = √(ℓ + 1), soit ℓ² − ℓ − 1 = 0 ; avec ℓ ≥ 0, ℓ = (1 + √5)/2.
④ En utilisant l''encadrement 1 ≤ Uₙ ≤ 2, montrer que Uₙ₊₁ − Uₙ ≥ 0 : (Uₙ) est croissante.
Quel est l''ordre correct des étapes ?', '[{"id":"a","text":"② → ④ → ① → ③"},{"id":"b","text":"③ → ② → ④ → ①"},{"id":"c","text":"② → ① → ④ → ③"},{"id":"d","text":"② → ④ → ③ → ①"}]'::jsonb, 'a', 'L''ordre correct est ② → ④ → ① → ③ ✓ : on établit d''abord l''encadrement 1 ≤ Uₙ ≤ 2 par récurrence (②), qui SERT ensuite à prouver la monotonie (④) ; croissante et majorée, la suite converge vers ℓ (①), et seulement alors le point fixe donne sa valeur (③). L''ordre ③ → … place la recherche du point fixe en tête : c''est l''erreur la plus sanctionnée du chapitre — trouver ℓ ne prouve jamais que (Uₙ) converge. L''ordre ② → ① → ④ → ③ conclut à la convergence (①) avant d''avoir montré la monotonie (④). Et ② → ④ → ③ → ① calcule la limite (③) avant même d''avoir conclu la convergence (①).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6287b25e-b3cb-52da-843f-f278bae9c79b', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'Appariement — associe chaque suite (①②③) à sa limite (a, b, c, d) :
① Uₙ = (1/3)ⁿ
② Uₙ = (2n² − n)/(n² + 3)
③ Uₙ = (−1)ⁿ
a. 0
b. 2
c. n''a pas de limite
d. +∞
Quel appariement est entièrement correct ?', '[{"id":"a","text":"①-a · ②-b · ③-c"},{"id":"b","text":"①-b · ②-a · ③-c"},{"id":"c","text":"①-a · ②-d · ③-c"},{"id":"d","text":"①-a · ②-b · ③-d"}]'::jsonb, 'a', 'Le bon appariement est ①-a · ②-b · ③-c ✓ : (1/3)ⁿ → 0 car |1/3| < 1 ; pour (2n² − n)/(n² + 3), on divise par le terme dominant n² → (2 − 1/n)/(1 + 3/n²) → 2 ; et (−1)ⁿ alterne entre 1 et −1, donc n''a pas de limite (U₂ₙ → 1 mais U₂ₙ₊₁ → −1). Échanger les deux limites finies (①-b · ②-a) confond une géométrique de raison 1/3 et une fraction rationnelle. Envoyer ② vers +∞ (②-d) traite un ∞/∞ à degrés ÉGAUX comme s''il divergeait, alors que les termes dominants se simplifient en 2. Et envoyer (−1)ⁿ vers +∞ (③-d) confond « bornée qui alterne » et « qui grandit ». La limite d proposée (+∞) n''est atteinte par aucune de ces trois suites.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8c47226b-aeec-59cb-9f93-2013b4e5614a', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'Texte à trous — on démontre par récurrence que 1 + 3 + 5 + … + (2n − 1) = n² pour tout n ≥ 1. À l''hérédité, on suppose l''égalité vraie au rang n et l''on ajoute aux deux membres le terme suivant de la somme, qui est (2n + 1). Le membre de droite devient alors ____, ce qui doit être égal à (n + 1)².', '[{"id":"a","text":"n² + (2n + 1)"},{"id":"b","text":"n² + (2n − 1)"},{"id":"c","text":"(n + 1)² + (2n + 1)"},{"id":"d","text":"n² × (2n + 1)"}]'::jsonb, 'a', 'On ajoute le terme suivant (2n + 1) au membre de droite n², ce qui donne n² + (2n + 1) = n² + 2n + 1 = (n + 1)² ✓ : l''hérédité est établie. Le terme (2n − 1) est le DERNIER terme au rang n, pas le suivant — le rang n + 1 ajoute le nombre impair 2(n + 1) − 1 = 2n + 1. Partir de (n + 1)² revient à ajouter le terme à la cible que l''on cherche justement à atteindre. Et multiplier (n² × (2n + 1)) confond la somme des termes avec un produit : à l''hérédité, on AJOUTE le terme suivant aux deux membres, on ne multiplie pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e4714c37-5a40-5ef0-8600-5c210fc50fba', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'Vrai ou faux ? On considère l''affirmation : « Soit (Uₙ) définie par Uₙ₊₁ = f(Uₙ) avec f continue. Si l''équation f(x) = x admet une unique solution ℓ, alors (Uₙ) converge vers ℓ. » Choisis le verdict accompagné de la justification correcte.', '[{"id":"a","text":"Faux : l''existence d''un point fixe ne prouve jamais la convergence ; il faut d''abord établir que (Uₙ) converge (monotone + bornée) avant d''identifier sa limite"},{"id":"b","text":"Vrai : le théorème du point fixe garantit que Uₙ tend vers l''unique solution de f(x) = x"},{"id":"c","text":"Vrai : une équation f(x) = x à solution unique force la suite à s''accumuler en ℓ"},{"id":"d","text":"Faux : il faudrait que f(x) = x possède au moins deux solutions pour pouvoir conclure"}]'::jsonb, 'a', 'L''affirmation est FAUSSE, et la bonne raison est celle du cours : le théorème du point fixe dit « SI (Uₙ) converge vers ℓ et si f est continue en ℓ, ALORS ℓ = f(ℓ) » — il donne la valeur de la limite une fois la convergence acquise, il ne la crée pas. On peut avoir un unique point fixe sans que la suite converge (elle peut diverger ou osciller). Les verdicts « Vrai » inversent le sens de l''implication du théorème. Et exiger deux solutions (verdict d) n''a aucun fondement : le nombre de points fixes ne décide pas de la convergence, qui s''établit par monotonie + bornée.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('81d3364c-364e-539b-a857-246766040737', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'QCM visuel — le graphique porte les premiers termes d''une suite (Uₙ) : ils croissent tout en restant sous la droite d''équation y = 3. Que peut-on affirmer ? <svg viewBox="0 0 280 200"><path d="M40 170 H258" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M258 170 l-6 -3 l0 6 z" fill="#0f172a"/><path d="M40 170 V22" fill="none" stroke="#0f172a" stroke-width="1.4"/><path d="M40 22 l-3 6 l6 0 z" fill="#0f172a"/><line x1="40" y1="55" x2="250" y2="55" stroke="#b45309" stroke-width="1.4" stroke-dasharray="6 4"/><text x="246" y="49" text-anchor="end" font-size="12" font-weight="700" fill="#b45309">y = 3</text><text x="250" y="186" text-anchor="middle" font-size="11" font-weight="700" fill="#0f172a">n</text><circle cx="58" cy="150" r="3" fill="#0f172a"/><circle cx="88" cy="118" r="3" fill="#0f172a"/><circle cx="118" cy="96" r="3" fill="#0f172a"/><circle cx="148" cy="82" r="3" fill="#0f172a"/><circle cx="178" cy="73" r="3" fill="#0f172a"/><circle cx="208" cy="67" r="3" fill="#0f172a"/><circle cx="238" cy="63" r="3" fill="#0f172a"/></svg>', '[{"id":"a","text":"(Uₙ) est croissante et majorée : elle converge vers un réel ℓ, avec ℓ ≤ 3"},{"id":"b","text":"(Uₙ) converge vers 3, car 3 est le majorant lu sur le graphique"},{"id":"c","text":"(Uₙ) tend vers +∞, puisqu''elle est croissante"},{"id":"d","text":"On ne peut rien conclure sans l''expression de Uₙ"}]'::jsonb, 'a', 'Le graphique montre une suite croissante (les points montent) et majorée (ils restent sous y = 3). Le théorème des suites monotones garantit alors qu''elle converge vers un réel ℓ, et le passage à la limite dans Uₙ ≤ 3 donne ℓ ≤ 3 ✓. Attention au piège du cours : « croissante et majorée » assure l''EXISTENCE de la limite, pas que celle-ci vaille le majorant — ℓ peut être strictement inférieur à 3, donc « converge vers 3 » (b) est faux. Une suite croissante ne tend vers +∞ que si elle n''est PAS majorée (c faux). Et le théorème conclut précisément sans avoir besoin de l''expression de Uₙ (d faux) : c''est tout son intérêt.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7a6359a9-222e-5478-8313-2da6e2acba02', 'a59a80d6-7c0f-5d58-a2d0-4373893ea87a', 'Lecture de document — une suite (Uₙ) vérifie Uₙ₊₁ = f(Uₙ). On dresse le tableau de ses premières valeurs :
n : 0 · 1 · 2 · 3 · 4
Uₙ : 1 · 1,5 · 1,75 · 1,875 · 1,9375
On sait de plus que Uₙ < 2 pour tout n. Quelle conclusion est correcte ?', '[{"id":"a","text":"La suite paraît croissante et est majorée par 2 : ces observations suggèrent qu''elle converge vers un réel ℓ ≤ 2"},{"id":"b","text":"La suite converge vers 1,9375, sa dernière valeur calculée"},{"id":"c","text":"La suite est décroissante, car les écarts entre termes successifs diminuent"},{"id":"d","text":"La suite diverge vers +∞, car ses termes ne cessent de croître"}]'::jsonb, 'a', 'Les termes augmentent (1 < 1,5 < 1,75 < 1,875 < 1,9375) et l''énoncé garantit Uₙ < 2 pour tout n : la suite est croissante et majorée par 2, donc elle converge vers un réel ℓ ≤ 2 ✓ (ici on reconnaît d''ailleurs Uₙ = 2 − (1/2)ⁿ, de limite 2). Une valeur calculée du tableau n''est jamais la limite (b) : la limite ne dépend que des grandes valeurs de n. Des écarts qui diminuent ne rendent pas la suite décroissante (c) : les termes montent toujours, seule leur progression ralentit. Et « croissante » n''implique « +∞ » (d) que sans majorant — or ici Uₙ < 2 borne la suite.', 7, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('aed57cb5-b2b5-5152-9856-b44db7a10804', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', '🗼 Histoire ⭐⭐⭐ : L''ascension de la Tour Convergence', 3, 120, 30, 'boss', 'admin', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1fdec408-994f-5be9-9d8c-523291f93f4d', 'aed57cb5-b2b5-5152-9856-b44db7a10804', 'Épisode 1 — Au pied de la Tour Convergence, héros de la section Mathématiques, tu montes dans l''ascenseur enchanté. Ta hauteur (en étages) suit la règle U₀ = 0 et Uₙ₊₁ = Uₙ/2 + 3 : à chaque palier, l''ascenseur monte de la moitié de ta hauteur actuelle plus trois. Calcule tes deux premières hauteurs U₁ et U₂.', '[{"id":"a","text":"U₁ = 3 et U₂ = 4,5"},{"id":"b","text":"U₁ = 3 et U₂ = 6"},{"id":"c","text":"U₁ = 1,5 et U₂ = 2,25"},{"id":"d","text":"U₁ = 6 et U₂ = 12"}]'::jsonb, 'a', 'On applique Uₙ₊₁ = Uₙ/2 + 3. U₁ = U₀/2 + 3 = 0/2 + 3 = 3 ; puis U₂ = U₁/2 + 3 = 3/2 + 3 = 1,5 + 3 = 4,5 ✓. Répondre U₂ = 6 (b) oublie de diviser U₁ par 2 (on calcule 3 + 3). Trouver 1,5 puis 2,25 (c) applique la moyenne (Uₙ + 3)/2 au lieu de Uₙ/2 + 3. Et 6 puis 12 (d) DOUBLE la hauteur au lieu de la diviser (on lit ×2 pour /2).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a4affb62-f8b3-5a74-a0bb-2c0d327c1c0b', 'aed57cb5-b2b5-5152-9856-b44db7a10804', 'Épisode 2 — Le gardien de la Tour te barre le passage : « Prouve que ton ascenseur ne quittera jamais la cage, c''est-à-dire que 0 ≤ Uₙ ≤ 6 pour tout n. » Rappel : U₀ = 0 et Uₙ₊₁ = Uₙ/2 + 3. Tu supposes 0 ≤ Uₙ ≤ 6 (hypothèse de récurrence). Quel enchaînement d''inégalités établit correctement l''hérédité 0 ≤ Uₙ₊₁ ≤ 6 ?', '[{"id":"a","text":"0 ≤ Uₙ ≤ 6 donne 0 ≤ Uₙ/2 ≤ 3, puis 3 ≤ Uₙ/2 + 3 ≤ 6"},{"id":"b","text":"0 ≤ Uₙ ≤ 6 donne 0 ≤ Uₙ/2 ≤ 3, puis 0 ≤ Uₙ/2 + 3 ≤ 9"},{"id":"c","text":"0 ≤ Uₙ ≤ 6 donne 0 ≤ 2Uₙ ≤ 12, puis 3 ≤ 2Uₙ + 3 ≤ 15"},{"id":"d","text":"0 ≤ Uₙ ≤ 6 donne directement 0 ≤ Uₙ₊₁ ≤ 6, sans transformation"}]'::jsonb, 'a', 'On part de 0 ≤ Uₙ ≤ 6, on divise par 2 : 0 ≤ Uₙ/2 ≤ 3, puis on ajoute 3 aux TROIS membres : 3 ≤ Uₙ/2 + 3 ≤ 6, c''est-à-dire 3 ≤ Uₙ₊₁ ≤ 6 ✓, qui est bien inclus dans [0 ; 6] : l''hérédité est prouvée. La borne 9 (b) n''ajoute 3 qu''à la borne supérieure (6 + 3) en laissant la borne inférieure à 0 : on doit ajouter 3 des deux côtés. Multiplier par 2 (c) au lieu de diviser inverse l''opération de la relation. Et affirmer le résultat sans transformation (d) n''est pas une démonstration : il faut faire agir la relation Uₙ₊₁ = Uₙ/2 + 3 sur l''encadrement.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cfe93286-3639-57dc-9443-96656daf7242', 'aed57cb5-b2b5-5152-9856-b44db7a10804', 'Épisode 3 — Deuxième énigme du gardien : « Ton ascenseur monte-t-il toujours, ou peut-il redescendre ? » Sachant U₀ = 0, Uₙ₊₁ = Uₙ/2 + 3 et l''encadrement déjà prouvé 0 ≤ Uₙ ≤ 6, détermine le sens de variation de (Uₙ).', '[{"id":"a","text":"Uₙ₊₁ − Uₙ = (6 − Uₙ)/2 ≥ 0 car Uₙ ≤ 6 : (Uₙ) est croissante"},{"id":"b","text":"Uₙ₊₁ − Uₙ = (Uₙ − 6)/2 ≤ 0 : (Uₙ) est décroissante"},{"id":"c","text":"Uₙ₊₁ − Uₙ = 3 − Uₙ/2, et sans information sur Uₙ le signe reste indéterminé"},{"id":"d","text":"Uₙ₊₁ − Uₙ = Uₙ/2 + 3 > 0 : (Uₙ) est croissante"}]'::jsonb, 'a', 'Uₙ₊₁ − Uₙ = (Uₙ/2 + 3) − Uₙ = 3 − Uₙ/2 = (6 − Uₙ)/2. Comme 0 ≤ Uₙ ≤ 6, on a 6 − Uₙ ≥ 0, donc Uₙ₊₁ − Uₙ ≥ 0 : la suite est croissante ✓ — l''ascenseur ne fait que monter. L''écriture (Uₙ − 6)/2 (b) est une erreur de signe qui renverse la conclusion. La réponse c a la bonne différence mais oublie d''utiliser l''encadrement Uₙ ≤ 6 pourtant déjà établi : c''est lui qui fixe le signe. Et (d) oublie de soustraire Uₙ : on ne calcule pas Uₙ₊₁, mais bien Uₙ₊₁ − Uₙ.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bcb3fc62-67d2-511e-9f06-0ba9e7701963', 'aed57cb5-b2b5-5152-9856-b44db7a10804', 'Épisode 4 — Le gardien s''écarte : ton ascenseur (U₀ = 0, Uₙ₊₁ = Uₙ/2 + 3) est croissant (Épisode 3) et majoré par 6 (Épisode 2). Une porte de lumière apparaît. Que peux-tu affirmer sur la suite (Uₙ) ?', '[{"id":"a","text":"Par le théorème des suites monotones, (Uₙ) converge vers un réel ℓ, avec ℓ ≤ 6"},{"id":"b","text":"(Uₙ) converge vers 6, car toute suite majorée par 6 tend vers 6"},{"id":"c","text":"(Uₙ) tend vers +∞, puisqu''elle est croissante"},{"id":"d","text":"On ne peut rien affirmer tant qu''on n''a pas l''expression explicite de Uₙ"}]'::jsonb, 'a', 'Croissante ET majorée : le théorème (admis) des suites monotones garantit que (Uₙ) converge vers un réel ℓ, et le passage à la limite dans Uₙ ≤ 6 donne ℓ ≤ 6 ✓. Le théorème donne l''EXISTENCE de la limite, pas sa valeur : « majorée par 6 donc tend vers 6 » (b) est le piège du cours — le majorant n''est pas la limite (ici ℓ vaudra 6, mais ce n''est pas parce que 6 majore). Une suite croissante ne diverge vers +∞ (c) que si elle n''est PAS majorée. Et tout l''intérêt du théorème est justement de conclure SANS expression explicite (d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a9f8cfef-df27-5bb0-8738-47e1f9f6f60e', 'aed57cb5-b2b5-5152-9856-b44db7a10804', 'Épisode 5 — À l''étage de lumière, une inscription : « La hauteur d''arrêt ℓ est un point fixe de la montée. » Ton ascenseur (Uₙ₊₁ = Uₙ/2 + 3) converge vers ℓ (Épisode 4) et f : x ↦ x/2 + 3 est continue, donc ℓ = f(ℓ). Quel est l''étage d''arrêt ℓ ?', '[{"id":"a","text":"ℓ = 6"},{"id":"b","text":"ℓ = 3"},{"id":"c","text":"ℓ = 2"},{"id":"d","text":"ℓ = 0"}]'::jsonb, 'a', 'Le théorème du point fixe donne ℓ = f(ℓ), soit ℓ = ℓ/2 + 3. On regroupe : ℓ − ℓ/2 = 3, donc ℓ/2 = 3, d''où ℓ = 6 ✓ — l''ascenseur s''arrête au 6ème étage. Répondre 3 (b) s''arrête à ℓ/2 = 3 sans multiplier par 2. La valeur 2 (c) vient d''une erreur de signe en regroupant (ℓ + ℓ/2 = 3 → (3/2)ℓ = 3 → ℓ = 2, au lieu de ℓ − ℓ/2). Et 0 (d) recopie la hauteur initiale U₀, qui n''est pas la limite.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('42198a34-97ee-5628-86f9-ebf61a3528eb', 'aed57cb5-b2b5-5152-9856-b44db7a10804', 'Épisode 6 — Au sommet, deux nacelles dorées encadrent le grand pont : aₙ = 6 − (1/2)ⁿ, qui monte, et bₙ = 6 + (1/2)ⁿ, qui descend. Le pont ne se matérialise que si les deux nacelles se rejoignent au même étage. Que peux-tu affirmer ?', '[{"id":"a","text":"(aₙ) croît, (bₙ) décroît, aₙ ≤ bₙ et bₙ − aₙ → 0 : les suites sont adjacentes et convergent vers la même limite 6"},{"id":"b","text":"Elles convergent vers deux limites différentes, car l''une monte et l''autre descend"},{"id":"c","text":"Elles sont adjacentes, mais leur limite commune est 0, la limite de (1/2)ⁿ"},{"id":"d","text":"On ne peut rien conclure, car bₙ − aₙ = 2 × (1/2)ⁿ ne tend pas vers 0"}]'::jsonb, 'a', 'Vérifions les trois conditions des suites adjacentes : (aₙ) croît (−(1/2)ⁿ augmente vers 0), (bₙ) décroît (+(1/2)ⁿ diminue vers 0), aₙ ≤ bₙ car (1/2)ⁿ > 0, et bₙ − aₙ = 2 × (1/2)ⁿ → 0 puisque |1/2| < 1. Les suites sont donc adjacentes et convergent vers une MÊME limite : comme aₙ = 6 − (1/2)ⁿ → 6, la limite commune est 6 ✓ — le pont apparaît. Elles ne peuvent converger vers deux limites différentes (b) : c''est précisément ce que le théorème des suites adjacentes interdit. La valeur 0 (c) est la limite de l''écart (1/2)ⁿ, pas celle des nacelles. Et bₙ − aₙ = 2 × (1/2)ⁿ tend bien vers 0 (d faux), car (1/2)ⁿ → 0.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES
  ('9dff9cce-2923-51fa-875a-e7b6a5b54cf9', '9fa29e00-b2fc-5030-9c1a-4fb3409810bd', 'math-bac-math', '🏛️ Annales Bac ⭐⭐⭐⭐ : Session principale — Suites réelles', 4, 300, 60, 'challenge', 'admin', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order,
  correction_video = EXCLUDED.correction_video;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('daff01b4-f5b1-508c-976d-418e201cd962', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9', 'Soit (Uₙ) définie par U₀ = 0 et, pour n ≥ 0, Uₙ₊₁ = √(2Uₙ + 3). On démontre par récurrence que, pour tout n, 0 ≤ Uₙ < 3. Dans l''hérédité, on suppose 0 ≤ Uₙ < 3 ; quel encadrement de Uₙ₊₁ permet de conclure ?', '[{"id":"a","text":"3 ≤ Uₙ₊₁ < 9"},{"id":"b","text":"0 ≤ Uₙ₊₁ < √3"},{"id":"c","text":"0 ≤ Uₙ₊₁ ≤ 3, l''égalité à 3 étant atteinte"},{"id":"d","text":"√3 ≤ Uₙ₊₁ < 3, donc 0 ≤ Uₙ₊₁ < 3"}]'::jsonb, 'd', 'De 0 ≤ Uₙ < 3 on tire 3 ≤ 2Uₙ + 3 < 9 (on multiplie par 2 puis on ajoute 3). La fonction racine étant croissante, √3 ≤ √(2Uₙ + 3) < √9 = 3, c''est-à-dire √3 ≤ Uₙ₊₁ < 3. Comme √3 ≥ 0, on a bien 0 ≤ Uₙ₊₁ < 3 : la propriété se transmet au rang n + 1 ✓. Le piège courant : s''arrêter à 3 ≤ 2Uₙ + 3 < 9 en oubliant d''appliquer la racine carrée (on garde l''encadrement de 2Uₙ + 3, pas celui de Uₙ₊₁) ; oublier la croissance de la racine et écrire 0 ≤ Uₙ₊₁ < √3 ; ou transformer l''inégalité stricte < 3 en ≤ 3 avec égalité, ce qui casserait l''hérédité stricte.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('980e0a9d-ef04-5450-9ea1-93fa3f59ccd4', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9', 'Pour la suite définie par U₀ = 0 et Uₙ₊₁ = √(2Uₙ + 3) (avec 0 ≤ Uₙ < 3), étudier la monotonie en examinant le signe de Uₙ₊₁ − Uₙ = √(2Uₙ + 3) − Uₙ.', '[{"id":"a","text":"Décroissante : √(2Uₙ + 3) − Uₙ < 0 sur [0 ; 3["},{"id":"b","text":"Croissante : √(2Uₙ + 3) − Uₙ > 0 sur [0 ; 3["},{"id":"c","text":"Constante : √(2Uₙ + 3) − Uₙ = 0"},{"id":"d","text":"Non monotone : le signe change sur [0 ; 3["}]'::jsonb, 'b', 'Pour x ∈ [0 ; 3[, comparons √(2x + 3) et x. Les deux membres étant positifs, √(2x + 3) > x ⟺ 2x + 3 > x² ⟺ x² − 2x − 3 < 0 ⟺ (x − 3)(x + 1) < 0 ⟺ −1 < x < 3. C''est vrai pour tout x de [0 ; 3[, donc √(2Uₙ + 3) − Uₙ > 0 : (Uₙ) est strictement croissante ✓ (contrôle : U₀ = 0, U₁ = √3 ≈ 1,73, U₂ = √(2√3 + 3) ≈ 2,54, ça monte ✓). Le piège courant : inverser le sens de l''inégalité (lire x² − 2x − 3 < 0 comme > 0) conclut à tort « décroissante » ; croire le signe variable oublie que tout l''intervalle [0 ; 3[ est inclus dans ]−1 ; 3[ ; et l''égalité (constante) n''a lieu qu''au point fixe x = 3, hors de l''intervalle.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2af4e931-05f4-5dc8-a27f-1afe0a52a2f0', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9', 'Déduire des deux questions précédentes que (Uₙ) converge, puis déterminer sa limite.', '[{"id":"a","text":"(Uₙ) converge vers 3"},{"id":"b","text":"(Uₙ) converge vers −1"},{"id":"c","text":"(Uₙ) diverge vers +∞"},{"id":"d","text":"(Uₙ) converge vers √3"}]'::jsonb, 'a', '(Uₙ) est croissante (question précédente) et majorée par 3 (récurrence) : par le théorème de convergence des suites monotones, elle converge vers un réel ℓ, avec ℓ ≤ 3. La fonction f : x ↦ √(2x + 3) étant continue, le point fixe donne ℓ = √(2ℓ + 3), soit ℓ² − 2ℓ − 3 = 0, d''où (ℓ − 3)(ℓ + 1) = 0 : ℓ = 3 ou ℓ = −1. Comme ℓ ≥ U₀ = 0, on retient ℓ = 3 ✓. Le piège courant : garder la racine parasite ℓ = −1, incompatible avec Uₙ ≥ 0 ; conclure « diverge vers +∞ » parce que (Uₙ) est croissante, en oubliant qu''elle est majorée (une suite croissante ET majorée converge) ; et √3 n''est que la valeur de U₁, pas la limite.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ff61ace5-cbb3-571c-986a-11ae60e9b3a2', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9', 'On établit que, pour tout n, 0 ≤ 3 − Uₙ ≤ 3/2ⁿ. À partir de quel rang est-on certain que Uₙ approche sa limite 3 à moins de 10⁻² près (c''est-à-dire 3 − Uₙ ≤ 10⁻²) ?', '[{"id":"a","text":"n ≥ 2"},{"id":"b","text":"n ≥ 8"},{"id":"c","text":"n ≥ 9"},{"id":"d","text":"n ≥ 300"}]'::jsonb, 'c', 'Il suffit que la majoration 3/2ⁿ soit ≤ 10⁻², soit 2ⁿ ≥ 300. Or 2⁸ = 256 < 300 et 2⁹ = 512 ≥ 300 : la condition est garantie dès n ≥ 9 ✓ (contrôle : 3/2⁹ = 3/512 ≈ 0,0059 ≤ 0,01 ✓). Le piège courant : s''arrêter à n ≥ 8 sans vérifier que 2⁸ = 256 est insuffisant (erreur du « à un rang près ») ; confondre le seuil 300 = 2ⁿ avec le rang n en répondant n ≥ 300 ; et lire l''exposant 2 de 10⁻² comme le rang cherché donne n ≥ 2.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fafed2cc-a992-515a-89b3-60de01ce8ba8', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9', 'Déterminer la limite de la suite définie pour n ≥ 1 par Uₙ = n × sin(π/(2n)).', '[{"id":"a","text":"0"},{"id":"b","text":"π/2"},{"id":"c","text":"+∞"},{"id":"d","text":"1"}]'::jsonb, 'b', 'Posons xₙ = π/(2n) → 0. Alors Uₙ = n × sin(xₙ) = (π/2) × sin(xₙ)/xₙ (car n = π/(2xₙ)). Or sin(x)/x → 1 quand x → 0, donc Uₙ → (π/2) × 1 = π/2 ✓ (contrôle : pour n = 1000, sin(π/2000) ≈ π/2000, donc Uₙ ≈ 1000 × π/2000 = π/2 ✓). Le piège courant : lever l''indétermination 0 × ∞ en « 0 » parce que sin(π/(2n)) → 0, ou en « +∞ » parce que n → +∞ — les deux ignorent la compensation exacte ; et répondre 1 retient sin(x)/x → 1 mais oublie le facteur π/2 mis en évidence.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('91c9abe2-75cd-5c7b-af3b-99c3e329064a', '9dff9cce-2923-51fa-875a-e7b6a5b54cf9', 'Une seule des affirmations suivantes est vraie. Laquelle ?', '[{"id":"a","text":"Si (U₂ₙ) et (U₂ₙ₊₁) sont convergentes, alors (Uₙ) est convergente"},{"id":"b","text":"Si (Uₙ + Vₙ) est convergente, alors (Uₙ) et (Vₙ) sont convergentes"},{"id":"c","text":"Si (Uₙ²) converge vers L, alors (Uₙ) converge vers √L"},{"id":"d","text":"Si (Uₙ) converge vers ℓ, alors la suite (Uₙ₊₁ − Uₙ) converge vers 0"}]'::jsonb, 'd', 'Seule d est vraie ✓ : si Uₙ → ℓ, alors Uₙ₊₁ → ℓ aussi (même limite pour une suite décalée d''un rang), donc Uₙ₊₁ − Uₙ → ℓ − ℓ = 0. a est fausse : (U₂ₙ) et (U₂ₙ₊₁) doivent converger vers la MÊME limite pour que (Uₙ) converge — pour Uₙ = (−1)ⁿ, U₂ₙ → 1 et U₂ₙ₊₁ → −1, chacune converge mais (Uₙ) diverge. b est fausse : Uₙ = n et Vₙ = −n donnent Uₙ + Vₙ = 0 convergente, alors que ni (Uₙ) ni (Vₙ) ne converge. c est fausse : Uₙ = (−1)ⁿ donne Uₙ² = 1 → 1, pourtant (Uₙ) ne converge pas (et rien n''impose le signe + de √L). Le piège courant : retenir ces énoncés sans leurs conditions (même limite des sous-suites, indétermination ∞ − ∞, perte du signe au carré).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

-- Converge question → competency mappings for this subject (étude 07 D-2).
DO $$
BEGIN
  IF to_regclass('public.question_competencies') IS NOT NULL THEN
    DELETE FROM public.question_competencies qc
    USING public.questions q, public.exercises e
    WHERE qc.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'math-bac-math'
      AND e.source = 'admin';
  END IF;
END $$;

