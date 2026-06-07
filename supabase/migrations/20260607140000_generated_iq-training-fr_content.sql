-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: iq-training-fr (Muscle ton cerveau — Entraînement QI (FR))
-- Regenerate with: npm run content:build
-- Source of truth: content/iq-training-fr/
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
  ('iq-training-fr', 'Muscle ton cerveau — Entraînement QI (FR)', 'Des défis visuels de logique pure : observe la figure, déduis la règle cachée, choisis la bonne réponse — aucune mémoire, que du raisonnement.', 'Logique', 'subject-math', 'Brain', 60, 'fr', false, 'muscle-cerveau', NULL)
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
      AND e.subject_id = 'iq-training-fr'
      AND e.source = 'admin'
      AND q.id NOT IN ('7c0f6897-cf03-5f3b-80d9-00b91d12ecfa', '3645e716-151b-50bc-90aa-b455b3a67223', '4b0df262-0227-57e1-9400-b70cf27ed456', '30fc5820-fd1e-58af-b3cb-aa757695d61a', '65892922-f253-5ed5-9453-42a2c33a46af', '9e806a6e-8b3a-5e21-a782-e3a09756a4fb', 'cca97f2b-3298-5382-bf90-5c01fd3e98ff', 'ae43cb5a-4fe5-5f90-8213-3d4cc965f1a4', '415526d1-a445-5ef0-802a-b0cb09981760', 'e3f134c5-32a2-587a-9bd9-c910b766d4d6', '5ac76dd6-8638-58e8-abed-7975f79148b8', 'dfe40371-697e-5362-ad9b-33e76e0e793e', 'ef36fab6-25d4-5bec-929b-1a0c462de1a6', '17e4190f-2881-5efb-a79b-493caaf9b138', '09bd6e27-5972-57ef-996f-fa22ae19e457', '2eef23b9-2e2c-56e6-81b7-06a91cd1d9ba', '2fb8d33b-2b59-53a7-8f38-0ea70444a478', 'f9d02d75-3bc5-59a9-b0c2-834508fa5b3b', 'e7346b4c-f88c-5b6f-a0e4-17be32d59f0a', '90184c02-c321-5695-ae42-a12e3e05e540', '99daffa1-aa81-5112-bf53-f536ff68e009', '68ebeba9-6eb3-53cc-8fd0-bba593a01979', 'bda2e0b3-73b0-529f-a96f-ff37f515e2a1', '167eea1b-106a-54f0-89e9-7bd50fd9ccb9', '4be4d245-124c-578e-a186-7845898dbf53', '3ecd844e-817c-5a13-a9ba-317d648757d3', '44221bb8-2fb6-5e53-9cf4-38e20d4f5c1a', 'e651af51-6f6b-56ac-93a9-88186c1f0a8e', 'eadcbfc2-a7c2-51b4-bec9-ab0ad89c91a9', '26333b4d-b996-59cc-90e4-d09244078f6a', '295cf8cf-9c59-5c69-b963-ba08939948a1', 'af39e44c-5a78-5a00-a01b-0d7e8caab43c', '3ea0743c-691c-579b-a0e3-419d53ce0849', 'd86f6b5d-08da-52b6-8380-2a1e6d66ff78', 'd3ebf59f-a116-5e60-ae40-751a4f4a7c04', '313198d4-0495-5661-b6b7-c4b9fe4f9123', 'd5567646-bf84-5fc3-a045-e967c8bd31c4', 'f79315b0-9793-51d3-aa3f-24a7a58ff9f1', '4af51270-87fd-59a5-a710-4eddbcfcd975', '22155d15-225c-5081-aa17-782ead97dab9', '657c69ef-4ba6-559e-9e5b-e2285ff582ad', '7902f306-b287-5839-87e9-67a8901fdcb5', '99730de5-011e-5f75-8a59-b4d65beccd1a', 'ab4b6fff-0814-5f1d-81cd-80557d4beced', '043902bf-b9aa-5cad-8bf6-e278a273c58b', 'fe829609-faa9-5adb-ae3e-497f02729bc6', '7993dcf0-ee53-5a70-8617-80d0f652e55a', 'a7564907-4195-568d-8109-180d6434e301', '4853e531-d552-5d89-a498-336cccc12073', '380f0a56-8095-56e5-9c5e-d0330c039537', 'f617af81-4aee-5d87-a805-6575765b7c44', '23120c0e-5c7a-511a-85b0-991a33677e94', '467e0928-6d9f-53d6-8913-7e0c2d661227', '0a25410c-08e8-55ba-b6b0-68e8c5972e0f', 'b36fed3a-f152-5f5d-992c-b8315d5682ce', '678b2e8e-3067-567d-8ea5-59225149a61c', '0d0d1817-1f5c-5ae4-b254-0403edd778e9', '28b01fba-96ed-5da4-a6d3-712e727dc50c', '4edad7b0-a689-5b8d-a4dd-d18646cd992a', 'cc865933-f6e1-556b-bac1-ad75588a664a', 'ce043bcf-5989-5214-afd2-1be4b11e3b80', '63c5b8e8-e91b-568c-a030-a76290d21de3', 'edd5de32-13d7-581d-b6bb-06b5dfaa10fb', '47d16129-624d-5da7-9952-dc05ac03ae3f', '90b16a6f-d7f4-56dc-9a2c-7518fc4990b0', '8ea3b8fd-a647-5dfe-a4ba-a9b8de4751d6', 'de9e5a75-3a74-51be-9d6a-2ed372f831cc', '76a307bc-fc5c-5468-b3a4-022b792a886f', '8d0447f5-b484-5b0f-ab27-d47e7b732feb', '577dcb42-ac1b-5f40-8b46-7436f2ed3571', '63982587-c466-5bbb-9a4b-6472f1e18b24', '503a5408-6df3-540b-8e67-0c729c65dfd5', '80d55130-afaa-5306-a5c2-f7258298a3d0', '54fb5dd4-d2cf-5d27-a89a-fab5cddda06d', '73ac3f9f-0e94-598d-a41e-237fd572d4c6', 'a3bd2ab2-3bb7-5afa-bf88-bf6f2ef50eef', 'accec347-6f44-51a5-b811-b421ea923459', 'd87aa8c9-5805-57c1-b668-f3f19bce6a6f', 'a51a425a-81f9-5009-8b94-2794e3b6351b', '73e278eb-cdac-5ff5-9d84-db8dab7425b1', 'a40e2322-ca96-5cab-812a-d472ffe61fa7', '1489c0f7-468e-5ae2-bc5a-75f68b8b7d72', '55a7d051-dd25-56c3-befa-820b8f0aa543', '3286fa8a-0fd5-51a7-97dc-530af4ddac68', '8c6a9ccd-15d1-5a2a-992a-c5d73b86f360', 'e106f3c3-d6cb-54ab-9160-ab9099ed164c', '8caba15f-b375-5cc2-bd60-755c34fe0471', 'db5a21f3-d2e4-588f-a529-5727593faf97', '5fa052ec-bfbb-5d80-81c6-1fb7b67e9e0c', 'ff4cd437-9ac7-576d-8772-b04b2ae481ca', 'efd36aa2-247e-5570-8408-0da5aa5e24f7', 'ee2fecfc-1f60-5ec0-bdfd-79714f694155', '303425b5-f9b6-5865-95d5-94be0091fba0', 'ef98f881-32ef-5385-8fe4-0df625779b21', '3a21ff23-a882-5380-b5de-a293249a3c2d', 'e61a5e49-f5f6-5599-a8c9-484e503f531d', 'd49f6ce7-08f7-5961-b3b3-259c8c70219a', 'fee1e4b3-8704-5eaf-a8fa-46a47674091b', '608597ec-4264-53a3-8d89-52250bed5a59', '5297849f-048a-5a12-ac0c-ff0973ad05f2', '565900ab-031a-5f4e-b059-0b678eb4e23f', '7ddf595d-ac66-5b18-a31f-54ada726cf40', 'a4f74323-13b3-5d9d-b6c1-2c0d01ec94ad', '83470144-da33-53e8-bd39-6e8a61fb1c9f', '274920e6-a512-52cc-aeaf-e659b931388d', 'e11c6bde-bb88-5069-8fa9-1d1fb87f98b1', 'f3b10f5f-184c-544b-9921-5c83880be1d9', '87363596-5cff-584d-b3c0-01d1ec6e8027', '7b32563f-37c4-53ed-85a3-28354bd693ee', '64593c62-8e39-5df5-902f-903f13591b80', '53b6fd10-5c43-5ef2-9bdb-62f66a485484', '55329ae2-d749-5fdf-a7b5-6bf17906bf3e', '191c14f4-52a1-5f51-b6e0-32bb782f157b', 'fa6b2b81-2957-5975-b5f3-ad586ddf9103', '4485726a-f925-57de-bdba-5de9dac1af8b');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'iq-training-fr' AND source = 'admin' AND id NOT IN ('02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'b0b641df-a429-576c-a050-3ef46d05aa72', '0f3b76c5-0078-590d-abb8-090763eb1855', '4629386d-31c9-52f2-8a06-04546c5f0e21', '7353dff8-126f-564c-83a1-71056f661151', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'cf079e5c-1cf6-55cc-aef1-919b93d43d5d', 'a7fedd7a-7974-515c-a470-64ba8a81322b', 'c6835a31-5b79-564f-891c-f593f917ed11', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'd2649cb0-599d-5e1e-97fe-91ae3eb018d5', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', '938bdf2c-a518-584c-aa35-6b56d7aca108', '19179235-1700-5a99-8988-83e6be67c669', 'f353be52-bb36-5e16-a506-f7170093ee3d', '23ea3466-d842-56f5-b1ae-a4405e60a901', '48101a8d-21de-5112-ac69-7be864c6022f', '699e982a-3b41-56cd-9627-831411a911e4');
DELETE FROM public.questions WHERE exercise_id IN ('02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'b0b641df-a429-576c-a050-3ef46d05aa72', '0f3b76c5-0078-590d-abb8-090763eb1855', '4629386d-31c9-52f2-8a06-04546c5f0e21', '7353dff8-126f-564c-83a1-71056f661151', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'cf079e5c-1cf6-55cc-aef1-919b93d43d5d', 'a7fedd7a-7974-515c-a470-64ba8a81322b', 'c6835a31-5b79-564f-891c-f593f917ed11', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'd2649cb0-599d-5e1e-97fe-91ae3eb018d5', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', '938bdf2c-a518-584c-aa35-6b56d7aca108', '19179235-1700-5a99-8988-83e6be67c669', 'f353be52-bb36-5e16-a506-f7170093ee3d', '23ea3466-d842-56f5-b1ae-a4405e60a901', '48101a8d-21de-5112-ac69-7be864c6022f', '699e982a-3b41-56cd-9627-831411a911e4') AND id NOT IN ('7c0f6897-cf03-5f3b-80d9-00b91d12ecfa', '3645e716-151b-50bc-90aa-b455b3a67223', '4b0df262-0227-57e1-9400-b70cf27ed456', '30fc5820-fd1e-58af-b3cb-aa757695d61a', '65892922-f253-5ed5-9453-42a2c33a46af', '9e806a6e-8b3a-5e21-a782-e3a09756a4fb', 'cca97f2b-3298-5382-bf90-5c01fd3e98ff', 'ae43cb5a-4fe5-5f90-8213-3d4cc965f1a4', '415526d1-a445-5ef0-802a-b0cb09981760', 'e3f134c5-32a2-587a-9bd9-c910b766d4d6', '5ac76dd6-8638-58e8-abed-7975f79148b8', 'dfe40371-697e-5362-ad9b-33e76e0e793e', 'ef36fab6-25d4-5bec-929b-1a0c462de1a6', '17e4190f-2881-5efb-a79b-493caaf9b138', '09bd6e27-5972-57ef-996f-fa22ae19e457', '2eef23b9-2e2c-56e6-81b7-06a91cd1d9ba', '2fb8d33b-2b59-53a7-8f38-0ea70444a478', 'f9d02d75-3bc5-59a9-b0c2-834508fa5b3b', 'e7346b4c-f88c-5b6f-a0e4-17be32d59f0a', '90184c02-c321-5695-ae42-a12e3e05e540', '99daffa1-aa81-5112-bf53-f536ff68e009', '68ebeba9-6eb3-53cc-8fd0-bba593a01979', 'bda2e0b3-73b0-529f-a96f-ff37f515e2a1', '167eea1b-106a-54f0-89e9-7bd50fd9ccb9', '4be4d245-124c-578e-a186-7845898dbf53', '3ecd844e-817c-5a13-a9ba-317d648757d3', '44221bb8-2fb6-5e53-9cf4-38e20d4f5c1a', 'e651af51-6f6b-56ac-93a9-88186c1f0a8e', 'eadcbfc2-a7c2-51b4-bec9-ab0ad89c91a9', '26333b4d-b996-59cc-90e4-d09244078f6a', '295cf8cf-9c59-5c69-b963-ba08939948a1', 'af39e44c-5a78-5a00-a01b-0d7e8caab43c', '3ea0743c-691c-579b-a0e3-419d53ce0849', 'd86f6b5d-08da-52b6-8380-2a1e6d66ff78', 'd3ebf59f-a116-5e60-ae40-751a4f4a7c04', '313198d4-0495-5661-b6b7-c4b9fe4f9123', 'd5567646-bf84-5fc3-a045-e967c8bd31c4', 'f79315b0-9793-51d3-aa3f-24a7a58ff9f1', '4af51270-87fd-59a5-a710-4eddbcfcd975', '22155d15-225c-5081-aa17-782ead97dab9', '657c69ef-4ba6-559e-9e5b-e2285ff582ad', '7902f306-b287-5839-87e9-67a8901fdcb5', '99730de5-011e-5f75-8a59-b4d65beccd1a', 'ab4b6fff-0814-5f1d-81cd-80557d4beced', '043902bf-b9aa-5cad-8bf6-e278a273c58b', 'fe829609-faa9-5adb-ae3e-497f02729bc6', '7993dcf0-ee53-5a70-8617-80d0f652e55a', 'a7564907-4195-568d-8109-180d6434e301', '4853e531-d552-5d89-a498-336cccc12073', '380f0a56-8095-56e5-9c5e-d0330c039537', 'f617af81-4aee-5d87-a805-6575765b7c44', '23120c0e-5c7a-511a-85b0-991a33677e94', '467e0928-6d9f-53d6-8913-7e0c2d661227', '0a25410c-08e8-55ba-b6b0-68e8c5972e0f', 'b36fed3a-f152-5f5d-992c-b8315d5682ce', '678b2e8e-3067-567d-8ea5-59225149a61c', '0d0d1817-1f5c-5ae4-b254-0403edd778e9', '28b01fba-96ed-5da4-a6d3-712e727dc50c', '4edad7b0-a689-5b8d-a4dd-d18646cd992a', 'cc865933-f6e1-556b-bac1-ad75588a664a', 'ce043bcf-5989-5214-afd2-1be4b11e3b80', '63c5b8e8-e91b-568c-a030-a76290d21de3', 'edd5de32-13d7-581d-b6bb-06b5dfaa10fb', '47d16129-624d-5da7-9952-dc05ac03ae3f', '90b16a6f-d7f4-56dc-9a2c-7518fc4990b0', '8ea3b8fd-a647-5dfe-a4ba-a9b8de4751d6', 'de9e5a75-3a74-51be-9d6a-2ed372f831cc', '76a307bc-fc5c-5468-b3a4-022b792a886f', '8d0447f5-b484-5b0f-ab27-d47e7b732feb', '577dcb42-ac1b-5f40-8b46-7436f2ed3571', '63982587-c466-5bbb-9a4b-6472f1e18b24', '503a5408-6df3-540b-8e67-0c729c65dfd5', '80d55130-afaa-5306-a5c2-f7258298a3d0', '54fb5dd4-d2cf-5d27-a89a-fab5cddda06d', '73ac3f9f-0e94-598d-a41e-237fd572d4c6', 'a3bd2ab2-3bb7-5afa-bf88-bf6f2ef50eef', 'accec347-6f44-51a5-b811-b421ea923459', 'd87aa8c9-5805-57c1-b668-f3f19bce6a6f', 'a51a425a-81f9-5009-8b94-2794e3b6351b', '73e278eb-cdac-5ff5-9d84-db8dab7425b1', 'a40e2322-ca96-5cab-812a-d472ffe61fa7', '1489c0f7-468e-5ae2-bc5a-75f68b8b7d72', '55a7d051-dd25-56c3-befa-820b8f0aa543', '3286fa8a-0fd5-51a7-97dc-530af4ddac68', '8c6a9ccd-15d1-5a2a-992a-c5d73b86f360', 'e106f3c3-d6cb-54ab-9160-ab9099ed164c', '8caba15f-b375-5cc2-bd60-755c34fe0471', 'db5a21f3-d2e4-588f-a529-5727593faf97', '5fa052ec-bfbb-5d80-81c6-1fb7b67e9e0c', 'ff4cd437-9ac7-576d-8772-b04b2ae481ca', 'efd36aa2-247e-5570-8408-0da5aa5e24f7', 'ee2fecfc-1f60-5ec0-bdfd-79714f694155', '303425b5-f9b6-5865-95d5-94be0091fba0', 'ef98f881-32ef-5385-8fe4-0df625779b21', '3a21ff23-a882-5380-b5de-a293249a3c2d', 'e61a5e49-f5f6-5599-a8c9-484e503f531d', 'd49f6ce7-08f7-5961-b3b3-259c8c70219a', 'fee1e4b3-8704-5eaf-a8fa-46a47674091b', '608597ec-4264-53a3-8d89-52250bed5a59', '5297849f-048a-5a12-ac0c-ff0973ad05f2', '565900ab-031a-5f4e-b059-0b678eb4e23f', '7ddf595d-ac66-5b18-a31f-54ada726cf40', 'a4f74323-13b3-5d9d-b6c1-2c0d01ec94ad', '83470144-da33-53e8-bd39-6e8a61fb1c9f', '274920e6-a512-52cc-aeaf-e659b931388d', 'e11c6bde-bb88-5069-8fa9-1d1fb87f98b1', 'f3b10f5f-184c-544b-9921-5c83880be1d9', '87363596-5cff-584d-b3c0-01d1ec6e8027', '7b32563f-37c4-53ed-85a3-28354bd693ee', '64593c62-8e39-5df5-902f-903f13591b80', '53b6fd10-5c43-5ef2-9bdb-62f66a485484', '55329ae2-d749-5fdf-a7b5-6bf17906bf3e', '191c14f4-52a1-5f51-b6e0-32bb782f157b', 'fa6b2b81-2957-5975-b5f3-ad586ddf9103', '4485726a-f925-57de-bdba-5de9dac1af8b');
DELETE FROM public.chapters c WHERE c.subject_id = 'iq-training-fr' AND c.id NOT IN ('b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'e0a5cf06-c63d-5b31-9fd0-996f73fe5bff', '811683b3-ae70-59f4-a578-75baf45ce360', '6f12a148-645f-53f2-bc45-c87223c6a146', 'adb933d9-88f0-53a4-b29a-327fc08f258f') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', 'Raisonnement visuel', 'Matrices, suites de formes, rotations, symétries et intrus : trouve la règle cachée dans chaque figure et applique-la.', '# 🧠 Entraînement — aucune leçon. Observe chaque figure, déduis la règle, applique-la.

Ici on ne révise rien : chaque mission est une énigme à résoudre par pure déduction. Fais confiance à ton œil et à ta logique. 💪', '📜 Résous par déduction, jamais par mémoire.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e0a5cf06-c63d-5b31-9fd0-996f73fe5bff', 'iq-training-fr', 'Logique', 'Suites, analogies, syllogismes et déductions conditionnelles : repère la règle cachée et applique-la sans rien mémoriser.', '# 🧠 Logique — aucune leçon. Observe, déduis la règle, applique-la.', '📜 Une seule règle gouverne chaque énigme : trouve-la, puis applique-la.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('811683b3-ae70-59f4-a578-75baf45ce360', 'iq-training-fr', 'Maths-raisonnement', 'Suites de nombres, analogies numériques, grilles arithmétiques et proportions : trouve la règle cachée par déduction, jamais par formule apprise.', '# 🧠 Maths-raisonnement — aucune leçon. Observe les nombres, déduis la règle, applique-la.', '📜 La règle est dans les nombres : déduis-la, ne la récite pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6f12a148-645f-53f2-bc45-c87223c6a146', 'iq-training-fr', 'Intelligence fluide', 'Problèmes inédits sans méthode apprise : induis le motif, découvre la règle de transformation et applique-la — pure capacité à raisonner.', '# 🧠 Intelligence fluide — aucune leçon. Observe, déduis la règle, applique-la.', '📜 Face à l''inédit : induis le motif, trouve la règle, applique-la — jamais de mémoire.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('adb933d9-88f0-53a4-b29a-327fc08f258f', 'iq-training-fr', 'Géométrie & spatial', 'Rotations, symétries, comptage de cubes cachés et patrons à plier : visualise la figure dans l''espace et déduis la transformation.', '# 🧠 Géométrie & spatial — aucune leçon. Observe la figure, déduis la règle, applique-la.', '📐 Fais tourner la figure dans ta tête : déduis la transformation, ne la mémorise pas.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', 'Échauffement visuel ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7c0f6897-cf03-5f3b-80d9-00b91d12ecfa', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Observe la suite de cercles. Quel cercle continue la série ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="6" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="38" cy="50" r="11" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="68" cy="50" r="16" fill="none" stroke="#1d4ed8" stroke-width="2"/><text x="92" y="56" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"#1d4ed8\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : le rayon grandit de 5 à chaque étape (6, 11, 16…). ✓ Le suivant vaut donc 21, soit l''option a. L''option b (16) répète le dernier cercle au lieu d''augmenter. L''option c (6) revient au tout premier. L''option d a la bonne taille mais devient pleine : la couleur n''a jamais changé dans la série, on ne doit pas inventer une nouvelle règle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3645e716-151b-50bc-90aa-b455b3a67223', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Trois figures suivent la même règle, une seule est l''intrus. Laquelle ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="32" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="80" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">1</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">2</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">3</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">4</text></svg>"}]'::jsonb, 'c', 'La règle commune : tous les carrés sont pleins. ✓ Le carré n°3 est le seul vide (juste un contour), c''est donc l''intrus, l''option c. Les options a, b et d montrent des carrés pleins, identiques aux autres : ils respectent la règle et ne peuvent pas être l''intrus.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b0df262-0227-57e1-9400-b70cf27ed456', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'À gauche, une flèche modèle. Choisis son image dans un miroir vertical (gauche-droite). <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="50" x2="70" y2="50" stroke="#0f766e" stroke-width="4"/><polyline points="56,38 70,50 56,62" fill="none" stroke="#0f766e" stroke-width="4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"56,38 70,50 56,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"44,38 30,50 44,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,56 50,70 62,56\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"70\" x2=\"50\" y2=\"30\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,44 50,30 62,44\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'b', 'Un miroir vertical échange la gauche et la droite : une flèche qui pointe à droite pointe alors à gauche. ✓ C''est l''option b. L''option a est identique au modèle (aucune réflexion). Les options c et d pointent vers le bas et vers le haut : ce serait une rotation, pas un miroir gauche-droite.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30fc5820-fd1e-58af-b3cb-aa757695d61a', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Une seule flèche tourne d''un quart de tour dans le sens des aiguilles d''une montre à chaque étape. Que vient ensuite ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g><line x1="12" y1="58" x2="12" y2="30" stroke="#b45309" stroke-width="4"/><polyline points="5,38 12,30 19,38" fill="none" stroke="#b45309" stroke-width="4"/></g><g><line x1="40" y1="44" x2="68" y2="44" stroke="#b45309" stroke-width="4"/><polyline points="60,37 68,44 60,51" fill="none" stroke="#b45309" stroke-width="4"/></g><text x="88" y="50" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"32\" x2=\"50\" y2=\"68\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,60 50,68 58,60\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"68\" y1=\"50\" x2=\"32\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"40,42 32,50 40,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"32\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,40 50,32 58,40\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"60,42 68,50 60,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'a', 'La flèche pointe d''abord vers le haut, puis vers la droite : c''est un quart de tour horaire. ✓ Le pas suivant donne une flèche vers le bas, soit l''option a. L''option d (vers la droite) répète l''étape précédente. L''option b (vers la gauche) tourne dans le mauvais sens. L''option c (vers le haut) revient au point de départ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65892922-f253-5ed5-9453-42a2c33a46af', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Observe le nombre de côtés des polygones. Quelle figure complète la suite ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,58 8,42 28,42" fill="none" stroke="#be123c" stroke-width="2"/><rect x="40" y="40" width="18" height="18" fill="none" stroke="#be123c" stroke-width="2"/><polygon points="78,38 88,46 84,58 72,58 68,46" fill="none" stroke="#be123c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 64,42 59,58 41,58 36,42\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 62,39 62,53 50,60 38,53 38,39\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,33 58,58 38,42 62,42 42,58\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'La règle : le nombre de côtés augmente de 1 à chaque pas — triangle (3), carré (4), pentagone (5). ✓ Le suivant doit avoir 6 côtés, donc l''hexagone de l''option b. L''option a est un pentagone (5 côtés), elle répète la figure précédente. L''option c est un carré (4 côtés), déjà passé. L''option d est une étoile à 5 branches : on a compté les pointes au lieu des côtés du polygone.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b0b641df-a429-576c-a050-3ef46d05aa72', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', '⭐ Échauffement', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9e806a6e-8b3a-5e21-a782-e3a09756a4fb', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Observe la suite : le nombre de points augmente de 1 à chaque étape. Quelle figure vient ensuite ? <svg viewBox="0 0 100 100"><rect x="2" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="13" cy="50" r="4" fill="#222"/><rect x="27" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="33" cy="50" r="4" fill="#222"/><circle cx="43" cy="50" r="4" fill="#222"/><rect x="52" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="57" cy="50" r="4" fill="#222"/><circle cx="63" cy="50" r="4" fill="#222"/><circle cx="69" cy="50" r="4" fill="#222"/><rect x="77" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2" stroke-dasharray="3 3"/><text x="88" y="55" font-size="16" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"34\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"45\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"56\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"67\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"42\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"58\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"}]'::jsonb, 'a', 'La règle est : +1 point à chaque case (1, puis 2, puis 3). La case suivante doit donc contenir 4 points → l''option a ✓. Le piège : b répète 3 points (on a oublié d''ajouter), d revient à 2 points (on lit la suite à l''envers) et c en met 5 (on a sauté une étape). On ajoute UN seul point par étape, donc 3 + 1 = 4.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cca97f2b-3298-5382-bf90-5c01fd3e98ff', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'La flèche tourne d''un quart de tour (90°) dans le sens des aiguilles d''une montre à chaque étape : haut, droite, bas… Quelle est l''étape suivante ? <svg viewBox="0 0 100 100"><g stroke="#222" stroke-width="3" fill="#222"><line x1="15" y1="62" x2="15" y2="38"/><polygon points="15,30 10,40 20,40"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="38" y1="50" x2="62" y2="50"/><polygon points="70,50 60,45 60,55"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="85" y1="38" x2="85" y2="62"/><polygon points="85,70 80,60 90,60"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"62\" x2=\"50\" y2=\"38\"/><polygon points=\"50,30 44,40 56,40\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\"/><polygon points=\"70,50 60,44 60,56\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"62\" y1=\"50\" x2=\"38\" y2=\"50\"/><polygon points=\"30,50 40,44 40,56\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\"/><polygon points=\"50,70 44,60 56,60\"/></g></svg>"}]'::jsonb, 'c', 'À chaque pas la flèche tourne de 90° dans le sens horaire : haut → droite → bas → gauche. Après « bas » vient donc « gauche » → l''option c ✓. Le piège : a (haut) et b (droite) reviennent en arrière dans la suite, et d (bas) répète l''étape précédente. Il faut continuer la rotation, pas la stopper ni l''inverser.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae43cb5a-4fe5-5f90-8213-3d4cc965f1a4', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Trois de ces figures suivent la même règle, une seule est différente. Quel est l''intrus ? <svg viewBox="0 0 100 100"><text x="50" y="55" font-size="12" text-anchor="middle" fill="#222">3 triangles + 1 carré</text><polygon points="50,15 40,30 60,30" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,25 30,70 70,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"25,70 50,25 75,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,30 70,40 45,72\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'La règle est : chaque figure est un triangle (3 côtés). L''intrus est l''option c ✓, qui est un carré (4 côtés). On compte les côtés : a, b et d en ont 3, seul c en a 4. Le piège est de regarder la taille ou l''orientation au lieu du nombre de côtés ; ici c''est bien le carré qui rompt la règle « 3 côtés ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('415526d1-a445-5ef0-802a-b0cb09981760', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Le petit carré noir se déplace d''un coin à chaque étape, dans le sens des aiguilles d''une montre. Où sera-t-il ensuite ? <svg viewBox="0 0 100 100"><rect x="4" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="6" y="40" width="7" height="7" fill="#222"/><rect x="38" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="53" y="40" width="7" height="7" fill="#222"/><rect x="72" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="87" y="53" width="7" height="7" fill="#222"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"}]'::jsonb, 'd', 'Le carré noir tourne dans le sens horaire : haut-gauche → haut-droite → bas-droite → bas-gauche. Après le coin bas-droite vient donc le coin bas-gauche → l''option d ✓. Le piège : c répète le bas-droite (étape précédente), b (haut-droite) et a (haut-gauche) reviennent en arrière. On poursuit la rotation jusqu''au coin suivant.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3f134c5-32a2-587a-9bd9-c910b766d4d6', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Trois ronds suivent la même règle, un seul est différent. Quel est l''intrus ? <svg viewBox="0 0 100 100"><text x="50" y="45" font-size="11" text-anchor="middle" fill="#222">3 ronds pleins</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#222">+ 1 rond vide</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"48\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"52\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'La règle est : chaque rond est plein (rempli de noir). L''intrus est l''option b ✓, le seul rond vide (juste un contour). a, c et d sont identiques et pleins ; b rompt la règle du remplissage. Le piège est de chercher une différence de taille ou de position : ici toutes les tailles sont égales, c''est le remplissage qui distingue b.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ac76dd6-8638-58e8-abed-7975f79148b8', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Observe la suite des polygones : le nombre de côtés augmente de 1 à chaque étape (3, puis 4, puis 5…). Quelle figure vient ensuite ? <svg viewBox="0 0 100 100"><polygon points="15,68 5,82 25,82" fill="none" stroke="#222" stroke-width="2"/><polygon points="33,30 51,30 51,48 33,48" fill="none" stroke="#222" stroke-width="2"/><polygon points="70,28 82,37 78,51 62,51 58,37" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="92" font-size="10" text-anchor="middle" fill="#888">3 côtés, 4 côtés, 5 côtés, ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"32,32 68,32 68,68 32,68\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 73,33 73,60 50,73 27,60 27,33\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 71,37 63,62 37,62 29,37\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 70,30 75,52 62,70 38,70 25,52 30,30\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'La règle est : +1 côté à chaque étape (triangle 3, carré 4, pentagone 5…). Le polygone suivant doit avoir 6 côtés → l''hexagone, option b ✓. Le piège : c est un pentagone (5 côtés, on a oublié d''ajouter), a un carré (4, retour en arrière) et d un heptagone (7, on a sauté de deux). On ajoute UN seul côté, donc 5 + 1 = 6.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0f3b76c5-0078-590d-abb8-090763eb1855', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', '⚔️ Défi logique ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('dfe40371-697e-5362-ad9b-33e76e0e793e', '0f3b76c5-0078-590d-abb8-090763eb1855', 'La flèche tourne d''un quart de tour (90°) dans le sens des aiguilles d''une montre à chaque étape. Quelle flèche vient ensuite ? <svg viewBox="0 0 100 100"><line x1="15" y1="75" x2="15" y2="30" stroke="#1f2937" stroke-width="4"/><polygon points="8,38 22,38 15,24" fill="#1f2937"/><line x1="40" y1="50" x2="85" y2="50" stroke="#1f2937" stroke-width="4"/><polygon points="77,43 77,57 91,50" fill="#1f2937"/><line x1="60" y1="25" x2="60" y2="70" stroke="#1f2937" stroke-width="4"/><polygon points="53,62 67,62 60,76" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"38,42 38,58 22,50\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"62,42 62,58 78,50\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"75\" x2=\"50\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,38 58,38 50,22\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,62 58,62 50,78\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : +90° dans le sens horaire à chaque étape. Haut → droite → bas → gauche. ✓ L''option a pointe vers la gauche : c''est la suite correcte. L''option d (vers le bas) répète l''étape précédente sans tourner. L''option c (vers le haut) revient en arrière (rotation inverse). L''option b (vers la droite) saute une étape. Astuce : suis toujours le même sens de rotation, sans sauter ni revenir.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef36fab6-25d4-5bec-929b-1a0c462de1a6', '0f3b76c5-0078-590d-abb8-090763eb1855', 'A est à B ce que C est à ? — observe la transformation entre les deux premières figures, puis applique-la. <svg viewBox="0 0 100 100"><rect x="8" y="38" width="16" height="16" fill="none" stroke="#1f2937" stroke-width="3"/><text x="32" y="52" font-size="12" fill="#1f2937">:</text><rect x="40" y="26" width="40" height="40" fill="none" stroke="#1f2937" stroke-width="3"/><text x="86" y="52" font-size="12" fill="#1f2937">::</text><circle cx="96" cy="46" r="3" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"8\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'La règle cachée : la figure grandit fortement, la forme et le contour restant identiques (un petit carré vide devient un grand carré vide). On applique le même agrandissement au petit cercle vide. ✓ L''option c est un grand cercle vide : c''est la bonne analogie. L''option b garde la petite taille (aucune transformation). L''option a change la forme (carré au lieu de cercle). L''option d change l''attribut couleur (cercle plein), ce que la transformation A→B ne faisait pas. Garde une seule transformation : la taille.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17e4190f-2881-5efb-a79b-493caaf9b138', '0f3b76c5-0078-590d-abb8-090763eb1855', 'La suite de points grandit selon une règle simple. Combien de points doit contenir la figure suivante ? <svg viewBox="0 0 100 100"><rect x="4" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="13" cy="49" r="3" fill="#1f2937"/><rect x="30" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="37" cy="49" r="3" fill="#1f2937"/><circle cx="44" cy="49" r="3" fill="#1f2937"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="61" cy="49" r="3" fill="#1f2937"/><circle cx="68" cy="49" r="3" fill="#1f2937"/><circle cx="65" cy="43" r="3" fill="#1f2937"/><rect x="82" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="88" y="54" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"35\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"35\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'La règle cachée : on ajoute un point à chaque étape (1, puis 2, puis 3…), l''écart constant étant +1. La figure suivante doit donc contenir 4 points. ✓ L''option b affiche exactement 4 points : c''est la bonne. L''option a (3 points) répète l''étape précédente sans avancer. L''option c (5 points) ajoute deux points d''un coup (mauvais écart). L''option d (6 points) double le saut. Compte précisément : il faut passer de 3 à 4, soit +1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09bd6e27-5972-57ef-996f-fa22ae19e457', '0f3b76c5-0078-590d-abb8-090763eb1855', 'A est à B ce que C est à ? — la transformation est une symétrie (effet miroir) gauche-droite. Quelle figure complète l''analogie ? <svg viewBox="0 0 100 100"><polygon points="6,30 6,66 26,48" fill="#1f2937"/><text x="30" y="52" font-size="11" fill="#1f2937">:</text><polygon points="58,30 58,66 38,48" fill="#1f2937"/><text x="62" y="52" font-size="11" fill="#1f2937">::</text><polyline points="78,30 96,40 78,50" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,30 62,50 38,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,38 50,62 70,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,62 50,38 70,62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,30 38,50 62,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'd', 'La règle cachée : symétrie miroir gauche-droite (la figure est retournée horizontalement, comme dans un miroir vertical). Un chevron pointant à droite ( > ) devient un chevron pointant à gauche ( < ). ✓ L''option d est le miroir horizontal exact : c''est la bonne. L''option a est identique à C (aucune transformation appliquée). Les options b et c appliquent une rotation de 90° (chevron vers le bas ou vers le haut) au lieu d''un miroir gauche-droite. Distingue bien miroir et rotation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2eef23b9-2e2c-56e6-81b7-06a91cd1d9ba', '0f3b76c5-0078-590d-abb8-090763eb1855', 'Matrice 3×3 : dans chaque ligne, le nombre de points augmente de 1 en allant vers la droite (1, 2, 3). Quelle figure remplit la case manquante (en bas à droite) ? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="19" cy="19" r="3" fill="#1f2937"/><circle cx="45" cy="19" r="3" fill="#1f2937"/><circle cx="55" cy="19" r="3" fill="#1f2937"/><circle cx="78" cy="19" r="3" fill="#1f2937"/><circle cx="84" cy="19" r="3" fill="#1f2937"/><circle cx="81" cy="13" r="3" fill="#1f2937"/><circle cx="19" cy="51" r="3" fill="#1f2937"/><circle cx="45" cy="51" r="3" fill="#1f2937"/><circle cx="55" cy="51" r="3" fill="#1f2937"/><circle cx="78" cy="51" r="3" fill="#1f2937"/><circle cx="84" cy="51" r="3" fill="#1f2937"/><circle cx="81" cy="45" r="3" fill="#1f2937"/><circle cx="19" cy="83" r="3" fill="#1f2937"/><circle cx="45" cy="83" r="3" fill="#1f2937"/><circle cx="55" cy="83" r="3" fill="#1f2937"/><text x="77" y="88" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"36\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"70\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"40\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'c', 'La règle cachée : sur chaque ligne, la 1re case a 1 point, la 2e en a 2, la 3e en a 3. La case manquante est la 3e de la dernière ligne : elle doit donc contenir 3 points. ✓ L''option c montre 3 points : c''est la bonne. L''option b (2 points) répète la colonne du milieu. L''option a (1 point) répète la première colonne. L''option d (4 points) dépasse la règle (+1 de trop). Lis la matrice ligne par ligne pour fixer l''écart constant : +1 par colonne.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fb8d33b-2b59-53a7-8f38-0ea70444a478', '0f3b76c5-0078-590d-abb8-090763eb1855', 'L''aiguille tourne toujours de 45° dans le sens des aiguilles d''une montre, autour de son point central. Quelle figure poursuit la suite ? <svg viewBox="0 0 100 100"><circle cx="17" cy="50" r="2.5" fill="#1f2937"/><line x1="17" y1="50" x2="17" y2="28" stroke="#1f2937" stroke-width="3"/><polygon points="17,24 12,33 22,33" fill="#1f2937"/><circle cx="50" cy="50" r="2.5" fill="#1f2937"/><line x1="50" y1="50" x2="66" y2="34" stroke="#1f2937" stroke-width="3"/><polygon points="69,31 58,34 65,41" fill="#1f2937"/><circle cx="83" cy="50" r="2.5" fill="#1f2937"/><line x1="83" y1="50" x2="95" y2="50" stroke="#1f2937" stroke-width="3"/><polygon points="99,50 90,45 90,55" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,75 62,72 72,62\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"75\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"50,80 44,68 56,68\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,25 62,28 72,38\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"25,75 28,62 38,72\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : +45° dans le sens horaire à chaque étape. L''aiguille pointe vers le haut (90°), puis vers le haut-droite (45°), puis vers la droite (0°)… l''étape suivante doit pointer vers le bas-droite. ✓ L''option a pointe vers le bas-droite : c''est la bonne suite. L''option c (haut-droite) revient en arrière d''un cran (rotation inverse). L''option b (vers le bas) saute un cran de 45°. L''option d (bas-gauche) part dans le mauvais sens (sens anti-horaire). Garde un pas constant de 45°, toujours dans le même sens horaire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4629386d-31c9-52f2-8a06-04546c5f0e21', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', '👑 Élite QI ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('f9d02d75-3bc5-59a9-b0c2-834508fa5b3b', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Voici une figure et l''axe vertical en pointillés à sa droite. Quelle option est son image par RÉFLEXION dans ce miroir vertical (gauche-droite) ? <svg viewBox="0 0 100 100"><polyline points="30,20 30,80 70,80" fill="none" stroke="#1e293b" stroke-width="6"/><circle cx="30" cy="20" r="7" fill="#ef4444" stroke="#1e293b" stroke-width="2"/><line x1="88" y1="10" x2="88" y2="90" stroke="#64748b" stroke-width="2" stroke-dasharray="4 4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,20 30,80 70,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,20 70,80 30,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,80 30,20 70,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,80 70,20 30,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'Règle cachée : une réflexion verticale (miroir gauche-droite) inverse l''axe horizontal et garde l''axe vertical. La figure en L a son angle en bas à gauche et la boule rouge en haut à gauche ; après le miroir, l''angle passe en bas à droite et la boule reste EN HAUT, à droite. ✓ option b. Piège a : c''est la figure de départ inchangée (aucun miroir). Piège c : c''est un retournement haut-bas, pas gauche-droite (la boule descendrait). Piège d : c''est une rotation de 180°, qui inverse les DEUX axes à la fois.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7346b4c-f88c-5b6f-a0e4-17be32d59f0a', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Cet escalier est construit avec des cubes identiques. En comptant aussi les cubes cachés derrière, combien de cubes au total le composent ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="#cbd5e1"><rect x="20" y="70" width="18" height="18"/><rect x="38" y="70" width="18" height="18"/><rect x="56" y="70" width="18" height="18"/><rect x="20" y="52" width="18" height="18"/><rect x="38" y="52" width="18" height="18"/><rect x="20" y="34" width="18" height="18"/></g><text x="50" y="24" font-size="10" text-anchor="middle" fill="#1e293b">profondeur 1</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"9"},{"id":"c","text":"6"},{"id":"d","text":"10"}]'::jsonb, 'c', 'Règle : on additionne les cubes colonne par colonne, profondeur 1 (rien de caché derrière, comme indiqué). Colonne de gauche = 3 cubes empilés, colonne du milieu = 2, colonne de droite = 1. Total = 3 + 2 + 1 = 6. ✓ option c. Piège a (5) : on a oublié un cube d''une colonne. Piège b (9) : on a supposé un carré 3×3 plein alors que c''est un escalier. Piège d (10) : on a ajouté une couche cachée derrière, mais la profondeur est de 1.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90184c02-c321-5695-ae42-a12e3e05e540', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Un seul de ces patrons (dépliés) peut se replier en un CUBE fermé, sans face manquante ni face qui se superpose. Lequel ? <svg viewBox="0 0 100 100"><text x="50" y="50" font-size="11" text-anchor="middle" fill="#1e293b">6 carrés = patron du cube</text><text x="50" y="66" font-size="11" text-anchor="middle" fill="#1e293b">Lequel se replie ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"40\" y=\"10\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"30\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"70\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"15\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"55\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"75\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"15\" y=\"60\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/></g></svg>"}]'::jsonb, 'a', 'Règle : un patron du cube valide a 6 carrés disposés de façon qu''aucun ne se chevauche au pliage ; le grand classique est la croix (un carré central avec un carré sur chaque côté + un en prolongement). Option a est cette croix en T allongé : colonne de 4 carrés avec deux carrés sur les côtés du 3ᵉ — elle se replie parfaitement. ✓ option a. Piège b : il forme un bloc 2×2 plus deux carrés en escalier ; au pliage deux faces se superposent et une manque. Piège d : c''est un rectangle 3×2 plein, qui se replie en boîte ouverte (deux faces se chevauchent, pas de cube fermé). Piège c : configuration 4+2 où les deux carrés du bas sont mal placés, deux faces tombent au même endroit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99daffa1-aa81-5112-bf53-f536ff68e009', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'On superpose EXACTEMENT les deux figures de gauche (même centre), traits noirs par-dessus traits noirs. Quelle option montre le résultat de cette superposition ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="4"><rect x="12" y="30" width="34" height="34"/></g><text x="55" y="50" font-size="16" text-anchor="middle" fill="#1e293b">+</text><g fill="none" stroke="#1e293b" stroke-width="4"><line x1="66" y1="30" x2="94" y2="58"/><line x1="94" y1="30" x2="66" y2="58"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"34\" y1=\"34\" x2=\"66\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"66\" y1=\"34\" x2=\"34\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'd', 'Règle : la superposition garde TOUS les traits des deux figures, sans rien ajouter ni enlever. On a un carré ET une croix en X (deux diagonales) ; le résultat est donc le carré traversé par ses deux diagonales formant un X. ✓ option d. Piège a : c''est le carré seul, on a oublié la croix. Piège c : une seule diagonale, on a perdu la moitié du X. Piège b : on a remplacé le carré par un cercle, alors que la superposition ne transforme jamais une forme en une autre.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68ebeba9-6eb3-53cc-8fd0-bba593a01979', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Transformation A → B, applique la MÊME à C pour trouver le résultat. A→B : la flèche tourne de 90° dans le sens horaire ET un point noir apparaît. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="10" y1="50" x2="34" y2="50"/><polyline points="28,44 34,50 28,56"/></g><text x="42" y="54" font-size="12" fill="#1e293b">→</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="58" y1="34" x2="58" y2="58"/><polyline points="52,52 58,58 64,52"/></g><circle cx="78" cy="40" r="4" fill="#1e293b"/><text x="50" y="82" font-size="11" text-anchor="middle" fill="#1e293b">C : flèche vers le bas, sans point</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"38,42 30,50 38,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\"/><polyline points=\"42,38 50,30 58,38\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'b', 'Règle : rotation de 90° dans le sens horaire + ajout d''un point. C pointe vers le BAS ; après un quart de tour horaire, le bas va vers la GAUCHE, donc la flèche pointe à gauche, et on ajoute le point. ✓ option b (flèche vers la gauche + point). Piège c : on a oublié de tourner (flèche encore verticale) tout en ajoutant le point. Piège d : rotation horaire mais flèche vers la DROITE — c''est l''erreur de sens (le bas qui tourne dans le sens horaire ne va pas à droite). Piège a : flèche vers la droite ET point oublié, deux erreurs cumulées.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bda2e0b3-73b0-529f-a96f-ff37f515e2a1', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Le motif tourne d''un quart de tour (90°) à chaque case, toujours dans le même sens. En observant la progression, quelle figure occupe la case avec le « ? » ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3" fill="none"><rect x="4" y="35" width="28" height="28"/><line x1="18" y1="49" x2="30" y2="49"/><rect x="36" y="35" width="28" height="28"/><line x1="50" y1="49" x2="50" y2="61"/><rect x="68" y="35" width="28" height="28"/><line x1="82" y1="49" x2="70" y2="49"/></g><text x="82" y="82" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"30\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'c', 'Règle : l''aiguille partant du centre tourne de 90° dans le sens horaire à chaque case. Case 1 : aiguille vers la DROITE. Case 2 : un quart de tour horaire → vers le BAS. Case 3 : encore un quart → vers la GAUCHE. Case 4 (le ?) : un dernier quart → vers le HAUT. ✓ option c (aiguille vers le haut). Piège a : retour vers la droite, comme si on revenait au départ au lieu de continuer. Piège d : aiguille vers le bas, on a sauté une étape de rotation. Piège b : aiguille vers la gauche, on a répété la case 3 sans tourner.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7353dff8-126f-564c-83a1-71056f661151', 'e0a5cf06-c63d-5b31-9fd0-996f73fe5bff', 'iq-training-fr', 'Échauffement Logique ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('167eea1b-106a-54f0-89e9-7bd50fd9ccb9', '7353dff8-126f-564c-83a1-71056f661151', 'Matrice 3×3 : sur chaque ligne, le nombre de points augmente de 1 en allant vers la droite. Quelle figure remplace le « ? » ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="35" y1="4" x2="35" y2="96" stroke="#94a3b8" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#94a3b8" stroke-width="1"/><line x1="4" y1="35" x2="96" y2="35" stroke="#94a3b8" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#94a3b8" stroke-width="1"/><circle cx="19" cy="19" r="3" fill="#1d4ed8"/><circle cx="44" cy="19" r="3" fill="#1d4ed8"/><circle cx="56" cy="19" r="3" fill="#1d4ed8"/><circle cx="75" cy="19" r="3" fill="#1d4ed8"/><circle cx="81" cy="19" r="3" fill="#1d4ed8"/><circle cx="87" cy="19" r="3" fill="#1d4ed8"/><circle cx="19" cy="50" r="3" fill="#1d4ed8"/><circle cx="44" cy="50" r="3" fill="#1d4ed8"/><circle cx="56" cy="50" r="3" fill="#1d4ed8"/><circle cx="75" cy="50" r="3" fill="#1d4ed8"/><circle cx="81" cy="50" r="3" fill="#1d4ed8"/><circle cx="87" cy="50" r="3" fill="#1d4ed8"/><circle cx="19" cy="81" r="3" fill="#1d4ed8"/><circle cx="44" cy="81" r="3" fill="#1d4ed8"/><circle cx="56" cy="81" r="3" fill="#1d4ed8"/><text x="81" y="86" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"32\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"68\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"41\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"59\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"26\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"42\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"58\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"74\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : sur chaque ligne le nombre de points va 1, puis 2, puis 3 (colonne gauche = 1, colonne du milieu = 2, colonne droite = 3). ✓ La case manquante est en bas à droite, elle doit donc contenir 3 points : c''est l''option a. L''option b (2 points) recopie la colonne du milieu. L''option c (1 point) recopie la colonne de gauche. L''option d (4 points) prolonge la suite d''un cran de trop : la ligne s''arrête à 3.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4be4d245-124c-578e-a186-7845898dbf53', '7353dff8-126f-564c-83a1-71056f661151', 'Observe la suite de carrés : leur taille change selon une règle régulière. Quel carré vient ensuite ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="44" width="12" height="12" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="30" y="40" width="20" height="20" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="58" y="36" width="28" height="28" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="94" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"36\" y=\"36\" width=\"28\" height=\"28\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"44\" y=\"44\" width=\"12\" height=\"12\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'La règle : le côté du carré grandit de 8 à chaque étape (12, 20, 28…). ✓ Le carré suivant mesure donc 36 de côté, vide comme les autres : c''est l''option a. L''option b (28) recopie le dernier carré au lieu de l''agrandir. L''option c (12) revient au tout premier. L''option d a la bonne taille mais devient pleine : la couleur n''a jamais changé dans la suite, il ne faut pas inventer une règle nouvelle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ecd844e-817c-5a13-a9ba-317d648757d3', '7353dff8-126f-564c-83a1-71056f661151', 'Analogie : le rond est au triangle ce que le carré est à … ? À gauche le modèle (rond → triangle) : on remplace la figure par celle qui a un côté de plus. Applique la même transformation au carré. <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="16" cy="30" r="10" fill="none" stroke="#0f766e" stroke-width="2"/><text x="34" y="35" font-size="12" fill="#64748b" text-anchor="middle">→</text><polygon points="52,22 44,38 60,38" fill="none" stroke="#0f766e" stroke-width="2"/><rect x="8" y="66" width="18" height="18" fill="none" stroke="#0f766e" stroke-width="2"/><text x="40" y="79" font-size="12" fill="#64748b" text-anchor="middle">→</text><text x="66" y="80" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 64,40 58,58 42,58 36,40\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,30 60,42 50,54 40,42\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,30 42,46 58,46\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 60,34 60,46 50,52 40,46 40,34\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'La transformation du modèle : on passe d''une figure à celle qui a un côté de plus. Le rond (vu comme 0 côté droit) devient un triangle (3 côtés)… mais la vraie règle lisible est « +1 côté » appliquée au carré. Le carré a 4 côtés, il doit donc devenir un pentagone, 5 côtés. ✓ C''est l''option a. L''option b est un losange (4 côtés) : même nombre de côtés que le carré, aucune transformation. L''option c est un triangle (3 côtés) : un côté de moins. L''option d est un hexagone (6 côtés) : deux côtés de plus, on a ajouté 2 au lieu de 1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44221bb8-2fb6-5e53-9cf4-38e20d4f5c1a', '7353dff8-126f-564c-83a1-71056f661151', 'Trois figures partagent la même règle, une seule est l''intrus. Laquelle ? (Indice : compte le nombre de côtés.) <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,58 8,42 28,42" fill="none" stroke="#be123c" stroke-width="2"/><rect x="40" y="40" width="18" height="18" fill="none" stroke="#be123c" stroke-width="2"/><polygon points="78,40 88,48 84,60 72,60 68,48" fill="none" stroke="#be123c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 42,44 58,44\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">1</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"40\" y=\"30\" width=\"20\" height=\"20\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">2</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"40\" r=\"11\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">3</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 60,36 56,48 44,48 40,36\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">4</text></svg>"}]'::jsonb, 'c', 'La règle commune : toutes ces figures sont des polygones, c''est-à-dire faites de côtés droits (triangle, carré, pentagone). ✓ Le cercle de l''option c n''a aucun côté droit : c''est le seul à ne pas être un polygone, donc l''intrus. L''option a (triangle, 3 côtés), l''option b (carré, 4 côtés) et l''option d (pentagone, 5 côtés) respectent toutes la règle « tracé de côtés droits » et ne peuvent pas être l''intrus.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e651af51-6f6b-56ac-93a9-88186c1f0a8e', '7353dff8-126f-564c-83a1-71056f661151', 'Déduction : RÈGLE — toutes les figures bleues sont des cercles. Sur la carte tu vois une figure bleue, mais sa forme est cachée par un voile gris. Laquelle de ces propositions est forcément vraie ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="4" y="4" width="92" height="92" rx="6" fill="none" stroke="#94a3b8" stroke-width="2"/><rect x="32" y="32" width="36" height="36" rx="4" fill="#9ca3af" stroke="#6b7280" stroke-width="2"/><text x="50" y="55" font-size="22" fill="#374151" text-anchor="middle">?</text><text x="50" y="88" font-size="10" fill="#2563eb" text-anchor="middle">figure bleue</text></svg>', '[{"id":"a","text":"C''est forcément un cercle."},{"id":"b","text":"C''est forcément un carré."},{"id":"c","text":"Ce peut être n''importe quelle forme, on ne peut rien dire."},{"id":"d","text":"C''est forcément un triangle."}]'::jsonb, 'a', 'La règle dit : « toute figure bleue est un cercle. » La figure cachée est bleue, donc elle entre dans la règle : elle est forcément un cercle. ✓ C''est l''option a. L''option c oublie qu''on connaît déjà sa couleur : la règle s''applique et permet de conclure. L''option b et l''option d inventent une forme que la règle interdit pour une figure bleue. Astuce : « si bleu alors cercle » + « c''est bleu » ⇒ « c''est un cercle » (déduction directe).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f4549597-d9ab-5f0a-a973-b7ec0c361a4c', 'e0a5cf06-c63d-5b31-9fd0-996f73fe5bff', 'iq-training-fr', '⭐ Échauffement', 1, 50, 10, 'practice', 'admin', 1)
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
  ('eadcbfc2-a7c2-51b4-bec9-ab0ad89c91a9', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', 'Dans cette grille 3×3, le nombre de points dans chaque case est égal au numéro de sa ligne (ligne 1 = 1 point, ligne 2 = 2 points, ligne 3 = 3 points). Quelle figure complète la case marquée « ? » ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="1.5"><rect x="6" y="6" width="88" height="88"/><line x1="35" y1="6" x2="35" y2="94"/><line x1="65" y1="6" x2="65" y2="94"/><line x1="6" y1="35" x2="94" y2="35"/><line x1="6" y1="65" x2="94" y2="65"/></g><g fill="#222"><circle cx="20" cy="20" r="3.5"/><circle cx="50" cy="20" r="3.5"/><circle cx="80" cy="20" r="3.5"/><circle cx="15" cy="50" r="3.5"/><circle cx="25" cy="50" r="3.5"/><circle cx="45" cy="50" r="3.5"/><circle cx="55" cy="50" r="3.5"/><circle cx="75" cy="50" r="3.5"/><circle cx="85" cy="50" r="3.5"/><circle cx="14" cy="80" r="3.5"/><circle cx="20" cy="80" r="3.5"/><circle cx="26" cy="80" r="3.5"/><circle cx="44" cy="80" r="3.5"/><circle cx="50" cy="80" r="3.5"/><circle cx="56" cy="80" r="3.5"/></g><text x="80" y="85" font-size="16" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"68\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"28\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"43\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"58\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"73\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"}]'::jsonb, 'c', 'La règle de la grille est : nombre de points = numéro de la ligne. La case « ? » est sur la 3e ligne (où il y a déjà des cases à 3 points), elle doit donc contenir 3 points → l''option c ✓. Le piège : b en met 2 (on lit le numéro de la colonne au lieu de la ligne), a en met 1 (on confond avec la 1re ligne) et d en met 4 (on a ajouté un point en trop). On applique la règle de la LIGNE : 3e ligne = 3 points.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26333b4d-b996-59cc-90e4-d09244078f6a', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', 'Observe la suite de nombres : 2, 5, 8, 11, ? — chaque terme augmente toujours du même pas. Quel nombre vient ensuite ?', '[{"id":"a","text":"12"},{"id":"b","text":"13"},{"id":"c","text":"14"},{"id":"d","text":"15"}]'::jsonb, 'c', 'La règle est : on ajoute 3 à chaque étape (2 → 5 → 8 → 11). Après 11 vient donc 11 + 3 = 14 → l''option c ✓. Le piège : 12 ajoute seulement 1 (on a oublié le pas réel), 13 ajoute 2 (mauvais pas) et 15 ajoute 4 (un pas de trop). On mesure l''écart entre deux termes voisins (toujours +3) et on le reproduit : 11 + 3 = 14.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('295cf8cf-9c59-5c69-b963-ba08939948a1', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', 'Analogie : la figure de gauche se transforme en celle de droite par un demi-tour (rotation de 180°). Applique la MÊME transformation à la 3e figure pour trouver la réponse. <svg viewBox="0 0 100 100"><polygon points="15,15 15,40 35,27" fill="#222"/><text x="45" y="30" font-size="12" fill="#222">→</text><polygon points="85,15 85,40 65,27" fill="#222"/><text x="30" y="72" font-size="12" fill="#222">L''Éclair monte ↑, puis ?</text><polygon points="50,55 70,55 60,40" fill="#c33"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,45 60,45 50,60\" fill=\"#c33\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,60 60,60 50,45\" fill=\"#c33\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,40 55,50 40,60\" fill=\"#c33\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,40 60,60 40,50\" fill=\"#c33\"/></svg>"}]'::jsonb, 'a', 'La transformation est un demi-tour (180°) : la flèche pleine pointée vers la droite devient une flèche pointée vers la gauche. Le triangle rouge pointe vers le HAUT ; après un demi-tour il doit pointer vers le BAS → l''option a ✓. Le piège : b pointe encore vers le haut (aucune rotation), c pointe à droite et d à gauche (rotation de 90° au lieu de 180°). Un demi-tour inverse complètement la direction : haut → bas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af39e44c-5a78-5a00-a01b-0d7e8caab43c', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', 'Trois de ces flèches pointent dans la même direction, une seule est différente. Quel est l''intrus ? <svg viewBox="0 0 100 100"><text x="50" y="45" font-size="11" text-anchor="middle" fill="#222">Même direction</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#222">pour 3 flèches sur 4</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"70\" x2=\"50\" y2=\"38\"/><polygon points=\"50,28 42,42 58,42\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"62\"/><polygon points=\"50,72 42,58 58,58\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"72\" x2=\"50\" y2=\"40\"/><polygon points=\"50,30 42,44 58,44\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"36\"/><polygon points=\"50,26 42,40 58,40\"/></g></svg>"}]'::jsonb, 'b', 'La règle est : chaque flèche pointe vers le HAUT. L''intrus est l''option b ✓, la seule qui pointe vers le bas (sa pointe est en bas). On regarde uniquement où se trouve la pointe : a, c et d ont leur pointe en haut, seul b l''a en bas. Le piège est de comparer la longueur ou la position des traits ; ici seule la DIRECTION de la pointe compte.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ea0743c-691c-579b-a0e3-419d53ce0849', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', 'Déduction : « Tous les Zogs portent un chapeau. » On observe une créature qui ne porte PAS de chapeau. Que peut-on conclure avec certitude ?', '[{"id":"a","text":"Cette créature est un Zog."},{"id":"b","text":"Cette créature n''est pas un Zog."},{"id":"c","text":"Tous les porteurs de chapeau sont des Zogs."},{"id":"d","text":"Aucune créature ne porte de chapeau."}]'::jsonb, 'b', 'La règle dit que TOUT Zog porte un chapeau. Donc une créature sans chapeau ne peut pas être un Zog (sinon elle en porterait un) → l''option b ✓. Le piège : a contredit directement l''observation ; c inverse la règle (« tout Zog a un chapeau » ne veut pas dire « tout chapeau appartient à un Zog ») ; d invente une affirmation qui n''a aucun rapport. On applique la règle par contraposée : pas de chapeau ⇒ pas un Zog.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d86f6b5d-08da-52b6-8380-2a1e6d66ff78', 'f4549597-d9ab-5f0a-a973-b7ec0c361a4c', 'Analogie : la figure de gauche se transforme en celle de droite en se REMPLISSANT de noir. Applique la même règle à la 3e figure. <svg viewBox="0 0 100 100"><circle cx="22" cy="28" r="14" fill="none" stroke="#222" stroke-width="3"/><text x="42" y="32" font-size="12" fill="#222">→</text><circle cx="78" cy="28" r="14" fill="#222" stroke="#222" stroke-width="2"/><rect x="36" y="60" width="28" height="28" fill="none" stroke="#222" stroke-width="3"/><text x="50" y="98" font-size="9" text-anchor="middle" fill="#888">carré vide → ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'La transformation ne change PAS la forme : elle remplit seulement l''intérieur en noir (le cercle vide devient un cercle plein). Le carré vide doit donc devenir un carré plein → l''option c ✓. Le piège : a garde le carré vide (on a oublié de remplir), d le réduit (on a changé la taille, pas le remplissage) et b change la forme en cercle (la règle agit sur le remplissage, pas sur la forme). On applique uniquement « remplir de noir » en gardant le carré.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', 'e0a5cf06-c63d-5b31-9fd0-996f73fe5bff', 'iq-training-fr', '⚔️ Défi Logique ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d3ebf59f-a116-5e60-ae40-751a4f4a7c04', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', 'Suite de nombres : chaque terme s''obtient en ajoutant toujours le même écart au précédent. Quel nombre remplace le ? <svg viewBox="0 0 100 100"><line x1="4" y1="60" x2="96" y2="60" stroke="#9ca3af" stroke-width="1.5"/><circle cx="14" cy="60" r="2" fill="#1f2937"/><circle cx="34" cy="60" r="2" fill="#1f2937"/><circle cx="54" cy="60" r="2" fill="#1f2937"/><circle cx="74" cy="60" r="2" fill="#1f2937"/><circle cx="90" cy="60" r="2" fill="#1f2937"/><text x="11" y="50" font-size="11" fill="#1f2937">2</text><text x="31" y="50" font-size="11" fill="#1f2937">5</text><text x="51" y="50" font-size="11" fill="#1f2937">8</text><text x="69" y="50" font-size="11" fill="#1f2937">11</text><text x="87" y="50" font-size="13" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"13"},{"id":"b","text":"14"},{"id":"c","text":"15"},{"id":"d","text":"16"}]'::jsonb, 'b', 'La règle cachée : l''écart est constant, +3 à chaque pas (2 → 5 → 8 → 11). Après 11, on ajoute encore 3 : 11 + 3 = 14. ✓ L''option b (14) respecte l''écart +3 : c''est la bonne. L''option a (13) n''ajoute que +2 (mauvais écart). L''option c (15) ajoute +4 (un de trop). L''option d (16) saute deux pas (+5). Repère d''abord l''écart entre deux termes voisins, puis applique-le tel quel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('313198d4-0495-5661-b6b7-c4b9fe4f9123', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', 'Trois de ces figures partagent une même propriété, une seule la brise : laquelle est l''intruse ? Observe si le contour est fermé ou ouvert. <svg viewBox="0 0 100 100"><text x="6" y="80" font-size="9" fill="#6b7280">Contour : fermé = boucle complète ; ouvert = ligne brisée non refermée.</text><line x1="6" y1="30" x2="94" y2="30" stroke="#9ca3af" stroke-width="1"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,72 50,30 70,72\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,30 30,70 70,70 70,30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'c', 'La règle cachée : le contour est-il fermé (la ligne revient à son point de départ) ou ouvert ? Le triangle (a), le carré (b) et le cercle (d) sont des contours fermés : la boucle est complète. L''option c trace trois côtés d''un carré mais laisse le haut ouvert : la ligne ne se referme pas. ✓ L''intrus est c : c''est la seule figure au contour ouvert. Le piège : confondre c avec un carré comme b — ils se ressemblent, mais b est fermé alors que c a une ouverture en haut. Suis le tracé du doigt : s''il revient au départ, le contour est fermé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5567646-bf84-5fc3-a045-e967c8bd31c4', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', 'A est à B ce que C est à ? — observe la transformation entre les deux premières figures (une rotation), puis applique-la à C. <svg viewBox="0 0 100 100"><polygon points="6,30 6,60 24,45" fill="#1f2937"/><text x="28" y="50" font-size="11" fill="#1f2937">:</text><polygon points="38,30 68,30 53,48" fill="#1f2937"/><text x="72" y="50" font-size="11" fill="#1f2937">::</text><polyline points="82,32 96,40 82,48" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,30 62,50 38,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,38 50,62 70,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,62 50,38 70,62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,30 38,50 62,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'b', 'La règle cachée : rotation de 90° dans le sens horaire. Le triangle plein pointant vers la droite (A) devient un triangle pointant vers le bas (B) : c''est bien un quart de tour horaire. On applique le même quart de tour horaire au chevron de C, qui pointe vers la droite ( > ) : il doit pointer vers le bas ( v ). ✓ L''option b est le chevron pointant vers le bas : c''est la bonne. L''option d pointe vers la gauche (rotation de 180°, deux crans). L''option c pointe vers le haut (rotation anti-horaire, mauvais sens). L''option a est identique à C (aucune rotation). Vérifie le sens ET l''amplitude : un seul quart de tour horaire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f79315b0-9793-51d3-aa3f-24a7a58ff9f1', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', 'Déduction logique. On sait : « Tous les Gloms sont des Vrouks » et « Aucun Vrouk n''est bleu ». Sachant que Pim est un Glom, que peut-on conclure avec certitude ? <svg viewBox="0 0 100 100"><circle cx="50" cy="52" r="40" fill="none" stroke="#9ca3af" stroke-width="2"/><text x="36" y="22" font-size="9" fill="#6b7280">Vrouks</text><circle cx="50" cy="58" r="20" fill="none" stroke="#1f2937" stroke-width="2"/><text x="38" y="50" font-size="9" fill="#1f2937">Gloms</text><circle cx="50" cy="60" r="3" fill="#1f2937"/><text x="54" y="63" font-size="9" fill="#1f2937">Pim</text></svg>', '[{"id":"a","text":"Pim n''est pas bleu."},{"id":"b","text":"Pim est bleu."},{"id":"c","text":"Pim n''est pas un Vrouk."},{"id":"d","text":"Tous les Vrouks sont des Gloms."}]'::jsonb, 'a', 'La règle cachée : on enchaîne les inclusions. Pim est un Glom, et tous les Gloms sont des Vrouks : donc Pim est un Vrouk. Or aucun Vrouk n''est bleu : donc Pim n''est pas bleu. ✓ L''option a est la seule conclusion certaine. L''option b (« Pim est bleu ») affirme l''exact contraire de la règle. L''option c (« Pim n''est pas un Vrouk ») contredit la chaîne Glom → Vrouk. L''option d inverse l''inclusion : « tous les Gloms sont des Vrouks » ne dit rien sur l''inverse (il peut exister des Vrouks qui ne sont pas des Gloms). Suis les flèches d''inclusion dans le bon sens, sans les retourner.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4af51270-87fd-59a5-a710-4eddbcfcd975', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', 'Matrice 3×3 : sur chaque ligne, la forme reste la même et le nombre de points à l''intérieur augmente de 1 vers la droite (1, 2, 3). Quelle figure remplit la case manquante (en bas à droite) ? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="19" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="19" r="2.5" fill="#1f2937"/><circle cx="50" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="19" r="2.5" fill="#1f2937"/><circle cx="55" cy="19" r="2.5" fill="#1f2937"/><circle cx="82" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="77" cy="19" r="2.5" fill="#1f2937"/><circle cx="82" cy="19" r="2.5" fill="#1f2937"/><circle cx="87" cy="19" r="2.5" fill="#1f2937"/><rect x="9" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="50" r="2.5" fill="#1f2937"/><rect x="40" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="50" r="2.5" fill="#1f2937"/><circle cx="55" cy="50" r="2.5" fill="#1f2937"/><rect x="72" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="77" cy="50" r="2.5" fill="#1f2937"/><circle cx="82" cy="50" r="2.5" fill="#1f2937"/><circle cx="87" cy="50" r="2.5" fill="#1f2937"/><polygon points="19,74 28,90 10,90" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="85" r="2.5" fill="#1f2937"/><polygon points="50,74 59,90 41,90" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="85" r="2.5" fill="#1f2937"/><circle cx="55" cy="85" r="2.5" fill="#1f2937"/><text x="78" y="90" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"60\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"40\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"46\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"24\" y=\"30\" width=\"52\" height=\"46\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"38\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"40\" cy=\"66\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"66\" r=\"5\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'La règle cachée a deux composantes : (1) la forme est fixe par ligne — la dernière ligne est faite de triangles ; (2) le nombre de points augmente de 1 vers la droite, donc la 3e colonne en contient 3. La case manquante doit être un triangle contenant 3 points. ✓ L''option b est un triangle avec 3 points : c''est la bonne. L''option d est un triangle mais avec seulement 2 points (répète la colonne du milieu). L''option c a bien 3 points mais change la forme (carré au lieu de triangle, mauvaise ligne). L''option a est un triangle avec 1 seul point (répète la première colonne). Vérifie les deux règles à la fois : la bonne forme ET le bon compte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22155d15-225c-5081-aa17-782ead97dab9', '892129bd-ee9e-5ac8-b3dd-4c9071cd25f9', 'Matrice 3×3 : sur chaque ligne, la troisième case est la SUPERPOSITION (les deux figures dessinées ensemble) des deux premières. Quelle figure complète la case manquante (en bas à droite) ? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><line x1="19" y1="10" x2="19" y2="28" stroke="#1f2937" stroke-width="2"/><line x1="42" y1="19" x2="58" y2="19" stroke="#1f2937" stroke-width="2"/><line x1="73" y1="10" x2="73" y2="28" stroke="#1f2937" stroke-width="2"/><line x1="73" y1="19" x2="89" y2="19" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="42" y1="50" x2="58" y2="50" stroke="#1f2937" stroke-width="2"/><circle cx="82" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="74" y1="50" x2="90" y2="50" stroke="#1f2937" stroke-width="2"/><rect x="11" y="75" width="16" height="16" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="50" cy="83" r="8" fill="none" stroke="#1f2937" stroke-width="2"/><text x="78" y="88" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,26 74,72 26,72\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"56\" r=\"16\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : sur chaque ligne, la 3e case montre les deux premières figures superposées. Ligne 1 : trait vertical + trait horizontal = une croix. Ligne 2 : cercle + trait horizontal = cercle barré. Ligne 3 : un carré (case 1) et un cercle (case 2), donc la case manquante doit montrer le carré ET le cercle superposés. ✓ L''option a réunit le carré et le cercle : c''est la bonne. L''option b ne garde que le carré (oublie la 2e figure). L''option c ne garde que le cercle (oublie la 1re figure). L''option d ajoute un triangle qui n''apparaît nulle part sur la ligne (figure inventée). La superposition additionne exactement les deux figures données, sans en retirer ni en inventer.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'e0a5cf06-c63d-5b31-9fd0-996f73fe5bff', 'iq-training-fr', '👑 Élite Logique ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('657c69ef-4ba6-559e-9e5b-e2285ff582ad', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'Matrice 3×3 : observe le nombre de points noirs dans chaque case. Quelle figure complète la case marquée « ? » (en bas à droite) ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="none"><rect x="4" y="4" width="92" height="92"/><line x1="34.7" y1="4" x2="34.7" y2="96"/><line x1="65.3" y1="4" x2="65.3" y2="96"/><line x1="4" y1="34.7" x2="96" y2="34.7"/><line x1="4" y1="65.3" x2="96" y2="65.3"/></g><g fill="#1e293b"><circle cx="19" cy="19" r="3.5"/><circle cx="45" cy="15" r="3.5"/><circle cx="55" cy="23" r="3.5"/><circle cx="73" cy="14" r="3.5"/><circle cx="81" cy="19" r="3.5"/><circle cx="88" cy="24" r="3.5"/><circle cx="19" cy="50" r="3.5"/><circle cx="45" cy="46" r="3.5"/><circle cx="55" cy="54" r="3.5"/><circle cx="73" cy="45" r="3.5"/><circle cx="81" cy="50" r="3.5"/><circle cx="88" cy="55" r="3.5"/><circle cx="19" cy="81" r="3.5"/><circle cx="45" cy="77" r="3.5"/><circle cx="55" cy="85" r="3.5"/></g><text x="81" y="86" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"38\" cy=\"50\" r=\"6\"/><circle cx=\"62\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"30\" cy=\"50\" r=\"6\"/><circle cx=\"50\" cy=\"50\" r=\"6\"/><circle cx=\"70\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"25\" cy=\"50\" r=\"6\"/><circle cx=\"42\" cy=\"50\" r=\"6\"/><circle cx=\"58\" cy=\"50\" r=\"6\"/><circle cx=\"75\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"50\" cy=\"50\" r=\"6\"/></g></svg>"}]'::jsonb, 'b', 'Règle cachée : le nombre de points dépend UNIQUEMENT de la colonne — colonne 1 = 1 point, colonne 2 = 2 points, colonne 3 = 3 points, identique sur chaque ligne. La case « ? » est en colonne 3, il faut donc 3 points. ✓ option b. Piège a (2 points) : on a recopié la colonne du milieu. Piège c (4 points) : on a continué à +1 au lieu de s''arrêter à la colonne 3. Piège d (1 point) : on a confondu avec la colonne de gauche.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7902f306-b287-5839-87e9-67a8901fdcb5', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'Suite de figures : observe comment chaque forme change pour passer à la suivante. Quelle figure remplace le « ? » ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="3"><polygon points="15,38 25,22 35,38"/><polygon points="42,22 58,22 58,38 42,38"/><polygon points="75,21 84,28 80,38 70,38 66,28"/></g><text x="25" y="52" font-size="9" text-anchor="middle" fill="#64748b">3 côtés</text><text x="50" y="52" font-size="9" text-anchor="middle" fill="#64748b">4 côtés</text><text x="75" y="52" font-size="9" text-anchor="middle" fill="#64748b">5 côtés</text><text x="50" y="78" font-size="14" text-anchor="middle" fill="#ef4444">? = forme suivante</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"35,30 65,30 65,60 35,60\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 70,38 66,60 34,60 30,38\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,28 60,28 72,45 60,62 40,62 28,45\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,26 62,34 68,48 62,62 50,70 38,62 32,48 38,34\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'Règle : à chaque étape la forme gagne exactement UN côté — triangle (3), carré (4), pentagone (5). La figure suivante doit donc avoir 6 côtés : un hexagone. ✓ option c. Piège b (pentagone, 5 côtés) : on a recopié la dernière forme sans ajouter de côté. Piège d (octogone, 8 côtés) : on a sauté au-delà de 6. Piège a (carré, 4 côtés) : on a reculé dans la suite au lieu d''avancer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99730de5-011e-5f75-8a59-b4d65beccd1a', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'Analogie : A est à B ce que C est à ? — découvre la transformation qui mène de A à B, puis applique-la à C. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="12" y1="42" x2="12" y2="18"/><polyline points="7,25 12,18 17,25"/></g><text x="24" y="34" font-size="12" fill="#1e293b">→</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="34" y1="30" x2="58" y2="30"/><polyline points="51,25 58,30 51,35"/></g><text x="68" y="34" font-size="11" fill="#64748b">::</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="86" y1="30" x2="62" y2="30"/><polyline points="69,25 62,30 69,35"/></g><text x="50" y="78" font-size="13" text-anchor="middle" fill="#ef4444">C → ?</text><text x="50" y="92" font-size="9" text-anchor="middle" fill="#64748b">A: vers le haut, B: vers la droite, C: vers la gauche</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"32\"/><polyline points=\"42,42 50,32 58,42\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"32\" x2=\"50\" y2=\"68\"/><polyline points=\"42,58 50,68 58,58\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\"/><polyline points=\"58,42 68,50 58,58\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"68\" y1=\"50\" x2=\"32\" y2=\"50\"/><polyline points=\"42,42 32,50 42,58\"/></g></svg>"}]'::jsonb, 'a', 'Règle : de A à B la flèche tourne d''un quart de tour (90°) dans le sens horaire — le haut devient la droite. On applique la même rotation horaire à C, qui pointe vers la GAUCHE : la gauche tournée d''un quart horaire devient le HAUT. ✓ option a (flèche vers le haut). Piège b (vers le bas) : c''est une rotation antihoraire, mauvais sens. Piège d (vers la gauche) : on a recopié C sans le faire tourner. Piège c (vers la droite) : c''est une rotation de 180°, soit deux quarts de tour au lieu d''un.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab4b6fff-0814-5f1d-81cd-80557d4beced', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'Intrus : trois de ces figures obéissent à une même règle, une seule la brise. Laquelle est l''intrus ? <svg viewBox="0 0 100 100"><text x="50" y="44" font-size="11" text-anchor="middle" fill="#1e293b">Un point et un contour par figure.</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#1e293b">Trouve celle qui sort du lot.</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"26\" y=\"26\" width=\"48\" height=\"48\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 76,68 24,68\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"54\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"44\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"82\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'd', 'Règle : dans chaque figure le point noir doit se trouver À L''INTÉRIEUR du contour. Cercle+point dedans (a), carré+point dedans (b), triangle+point dedans (c) respectent la règle. Dans (d) le point est posé À L''EXTÉRIEUR du cercle : c''est l''intrus. ✓ option d. Piège a, b, c : ce sont des formes différentes (cercle, carré, triangle), mais la forme du contour n''est pas la règle — seul compte que le point soit dedans, ce qui les rend toutes conformes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('043902bf-b9aa-5cad-8bf6-e278a273c58b', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'Déduction logique. On sait que : (1) Tous les Glips sont des Bromes. (2) Aucun Brome n''est un Zarn. (3) Milo est un Glip. Quelle conclusion est NÉCESSAIREMENT vraie ?', '[{"id":"a","text":"Milo est un Zarn."},{"id":"b","text":"Milo n''est pas un Zarn."},{"id":"c","text":"Certains Bromes sont des Zarns."},{"id":"d","text":"Milo n''est pas un Brome."}]'::jsonb, 'b', 'Règle : on enchaîne les implications. Milo est un Glip (3), or tous les Glips sont des Bromes (1), donc Milo est un Brome. Et aucun Brome n''est un Zarn (2), donc Milo n''est PAS un Zarn. ✓ option b. Piège a : conclusion inverse, elle contredit (2). Piège d : faux, on vient de déduire que Milo EST un Brome via (1). Piège c : contredit directement (2) qui dit qu''AUCUN Brome n''est un Zarn.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe829609-faa9-5adb-ae3e-497f02729bc6', '984e0b3c-1259-58e6-95b3-5a387a7d0bba', 'Suite de nombres : 2, 6, 12, 20, 30, ? — trouve la règle cachée qui relie chaque terme au suivant, puis donne le nombre manquant.', '[{"id":"a","text":"40"},{"id":"b","text":"42"},{"id":"c","text":"36"},{"id":"d","text":"56"}]'::jsonb, 'b', 'Règle : les écarts entre termes augmentent de 2 à chaque fois — +4, +6, +8, +10, donc le prochain écart est +12. 30 + 12 = 42. ✓ (autre lecture : chaque terme vaut n×(n+1) : 1×2, 2×3, 3×4, 4×5, 5×6, puis 6×7 = 42). Piège a (40) : on a réutilisé le dernier écart +10 au lieu de +12. Piège c (36) : on a pris un écart de +6, en répétant un ancien saut. Piège d (56) : c''est 7×8, on a sauté un terme de la suite.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cf079e5c-1cf6-55cc-aef1-919b93d43d5d', '811683b3-ae70-59f4-a578-75baf45ce360', 'iq-training-fr', 'Échauffement Maths-raisonnement ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7993dcf0-ee53-5a70-8617-80d0f652e55a', 'cf079e5c-1cf6-55cc-aef1-919b93d43d5d', 'Observe la suite de nombres et trouve la règle cachée : 3, 6, 9, 12, ? — quel nombre vient ensuite ?', '[{"id":"a","text":"15"},{"id":"b","text":"13"},{"id":"c","text":"16"},{"id":"d","text":"24"}]'::jsonb, 'a', 'La règle cachée : on ajoute 3 à chaque pas (3, 6, 9, 12…). ✓ Le terme suivant est donc 12 + 3 = 15, soit l''option a. L''option b (13) ajoute seulement 1, comme si on comptait à la suite. L''option c (16) ajoute 4 : c''est le bon type d''opération mais le mauvais pas. L''option d (24) double le dernier terme au lieu de poursuivre l''addition régulière.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7564907-4195-568d-8109-180d6434e301', 'cf079e5c-1cf6-55cc-aef1-919b93d43d5d', 'Complète l''analogie en gardant la même relation : 3 est à 6 ce que 5 est à ? (Indice : par combien faut-il multiplier 3 pour obtenir 6 ?)', '[{"id":"a","text":"11"},{"id":"b","text":"15"},{"id":"c","text":"10"},{"id":"d","text":"25"}]'::jsonb, 'c', 'La relation cachée : on multiplie par 2 (3 × 2 = 6). ✓ On applique la même règle à 5 : 5 × 2 = 10, soit l''option c. L''option a (11) additionne 5 + 6, c''est-à-dire ajoute le résultat de la première paire au lieu de réutiliser sa règle. L''option b (15) multiplie par 3 (5 × 3), en prenant le premier nombre du modèle comme facteur au lieu du « ×2 ». L''option d (25) met 5 au carré : on change d''opération en cours de route.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4853e531-d552-5d89-a498-336cccc12073', 'cf079e5c-1cf6-55cc-aef1-919b93d43d5d', 'Dans cette grille, les deux lignes ont la même somme. Quel nombre manque à la place du « ? » ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="15" y="15" width="70" height="70" fill="none" stroke="#1d4ed8" stroke-width="2"/><line x1="38" y1="15" x2="38" y2="85" stroke="#1d4ed8" stroke-width="1.5"/><line x1="62" y1="15" x2="62" y2="85" stroke="#1d4ed8" stroke-width="1.5"/><line x1="15" y1="50" x2="85" y2="50" stroke="#1d4ed8" stroke-width="1.5"/><text x="26" y="37" font-size="13" fill="#0f172a" text-anchor="middle">2</text><text x="50" y="37" font-size="13" fill="#0f172a" text-anchor="middle">4</text><text x="74" y="37" font-size="13" fill="#0f172a" text-anchor="middle">3</text><text x="26" y="73" font-size="13" fill="#0f172a" text-anchor="middle">5</text><text x="50" y="73" font-size="13" fill="#0f172a" text-anchor="middle">?</text><text x="74" y="73" font-size="13" fill="#be123c" text-anchor="middle">2</text></svg>', '[{"id":"a","text":"4"},{"id":"b","text":"2"},{"id":"c","text":"9"},{"id":"d","text":"5"}]'::jsonb, 'b', 'La règle : les deux lignes ont la même somme. La ligne du haut fait 2 + 4 + 3 = 9. ✓ La ligne du bas doit aussi faire 9 : 5 + ? + 2 = 9, donc ? = 9 − 7 = 2, soit l''option b. L''option a (4) recopie un voisin sans calculer. L''option c (9) donne la somme totale d''une ligne au lieu de la case manquante. L''option d (5) répète le premier nombre de la ligne au lieu de compléter la somme.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('380f0a56-8095-56e5-9c5e-d0330c039537', 'cf079e5c-1cf6-55cc-aef1-919b93d43d5d', 'Une recette utilise 2 œufs pour 6 crêpes. En gardant la même proportion, combien d''œufs faut-il pour 12 crêpes ?', '[{"id":"a","text":"8"},{"id":"b","text":"6"},{"id":"c","text":"4"},{"id":"d","text":"3"}]'::jsonb, 'c', 'La règle : le nombre de crêpes double (6 → 12), donc tout double à proportion égale. ✓ Il faut 2 × 2 = 4 œufs, soit l''option c. L''option a (8) ajoute 6 aux œufs comme on a ajouté 6 aux crêpes : on additionne au lieu de respecter le rapport. L''option b (6) recopie le nombre de crêpes de départ. L''option d (3) ajoute seulement 1, sans tenir compte du doublement.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f617af81-4aee-5d87-a805-6575765b7c44', 'cf079e5c-1cf6-55cc-aef1-919b93d43d5d', 'Chaque forme contient un nombre. La règle est la même d''une forme à l''autre. Quel nombre doit remplacer le « ? » dans la dernière forme ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="15" y="55" font-size="13" fill="#0f172a" text-anchor="middle">1</text><circle cx="39" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="39" y="55" font-size="13" fill="#0f172a" text-anchor="middle">2</text><circle cx="63" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="63" y="55" font-size="13" fill="#0f172a" text-anchor="middle">4</text><circle cx="87" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="87" y="55" font-size="13" fill="#be123c" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"6"},{"id":"c","text":"8"},{"id":"d","text":"16"}]'::jsonb, 'c', 'La règle cachée : chaque nombre est le double du précédent (1, puis 2, puis 4…). ✓ Le suivant vaut 4 × 2 = 8, soit l''option c. Avec trois termes donnés (1, 2, 4), seule la règle « ×2 » convient : l''addition est exclue car l''écart change (de 1 à 2, puis de 2 à 4). L''option a (5) ajoute 1 au dernier terme. L''option b (6) ajoute le dernier écart (4 + 2) au lieu de doubler. L''option d (16) double deux fois (saute une étape).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a7fedd7a-7974-515c-a470-64ba8a81322b', '811683b3-ae70-59f4-a578-75baf45ce360', 'iq-training-fr', '⭐ Échauffement', 1, 50, 10, 'practice', 'admin', 1)
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
  ('23120c0e-5c7a-511a-85b0-991a33677e94', 'a7fedd7a-7974-515c-a470-64ba8a81322b', 'Observe la suite et trouve la règle cachée : 4, 7, 10, 13, ? Quel nombre vient ensuite ?', '[{"id":"a","text":"16"},{"id":"b","text":"15"},{"id":"c","text":"17"},{"id":"d","text":"26"}]'::jsonb, 'a', 'La règle est : +3 à chaque étape (7−4 = 3, 10−7 = 3, 13−10 = 3). Le nombre suivant est donc 13 + 3 = 16 → l''option a ✓. Le piège : b (15) ajoute seulement 2, c (17) ajoute 4, et d (26) double le dernier nombre. L''écart entre deux termes reste constant et vaut 3.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('467e0928-6d9f-53d6-8913-7e0c2d661227', 'a7fedd7a-7974-515c-a470-64ba8a81322b', 'Trouve la règle commune aux deux exemples, puis applique-la : 2 → 4, 3 → 6, alors 5 → ?', '[{"id":"a","text":"8"},{"id":"b","text":"10"},{"id":"c","text":"9"},{"id":"d","text":"11"}]'::jsonb, 'b', 'Avec deux exemples, une seule règle marche pour les DEUX : on multiplie par 2. Vérifie : 2 × 2 = 4 et 3 × 2 = 6 ✓. On applique à 5 : 5 × 2 = 10 → l''option b ✓. Le piège : a (8) suppose « ajouter 3 » (3 + 3 = 6), mais cette règle échoue sur le premier exemple (2 + 3 = 5 ≠ 4), donc elle est éliminée ; c (9) fait 5 + 4 et d (11) fait 5 + 6, qui ne collent à aucun des deux exemples. Seule la multiplication par 2 reproduit 4 et 6, donc 5 donne 10.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a25410c-08e8-55ba-b6b0-68e8c5972e0f', 'a7fedd7a-7974-515c-a470-64ba8a81322b', 'Dans cette grille, chaque ligne suit la même règle : les deux premières cases s''additionnent pour donner la troisième. Quel nombre remplace le « ? » ? <svg viewBox="0 0 100 100"><rect x="10" y="15" width="80" height="70" fill="none" stroke="#222" stroke-width="2"/><line x1="36" y1="15" x2="36" y2="85" stroke="#222" stroke-width="2"/><line x1="63" y1="15" x2="63" y2="85" stroke="#222" stroke-width="2"/><line x1="10" y1="38" x2="90" y2="38" stroke="#222" stroke-width="2"/><line x1="10" y1="61" x2="90" y2="61" stroke="#222" stroke-width="2"/><text x="23" y="31" font-size="13" text-anchor="middle" fill="#222">2</text><text x="49" y="31" font-size="13" text-anchor="middle" fill="#222">3</text><text x="76" y="31" font-size="13" text-anchor="middle" fill="#222">5</text><text x="23" y="54" font-size="13" text-anchor="middle" fill="#222">4</text><text x="49" y="54" font-size="13" text-anchor="middle" fill="#222">1</text><text x="76" y="54" font-size="13" text-anchor="middle" fill="#222">5</text><text x="23" y="77" font-size="13" text-anchor="middle" fill="#222">3</text><text x="49" y="77" font-size="13" text-anchor="middle" fill="#222">4</text><text x="76" y="77" font-size="15" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"12"},{"id":"c","text":"7"},{"id":"d","text":"1"}]'::jsonb, 'c', 'La règle, lisible sur les deux premières lignes : case3 = case1 + case2 (2 + 3 = 5, puis 4 + 1 = 5). Pour la dernière ligne : 3 + 4 = 7 → l''option c ✓. Le piège : a (5) recopie le résultat des autres lignes au lieu de calculer, b (12) multiplie 3 × 4, et d (1) soustrait 4 − 3. La bonne opération est l''addition des deux premières cases.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b36fed3a-f152-5f5d-992c-b8315d5682ce', 'a7fedd7a-7974-515c-a470-64ba8a81322b', 'Observe la suite et trouve la règle cachée : 2, 4, 6, 8, ? Quel nombre vient ensuite ?', '[{"id":"a","text":"9"},{"id":"b","text":"16"},{"id":"c","text":"12"},{"id":"d","text":"10"}]'::jsonb, 'd', 'La règle est : +2 à chaque étape, ce sont les nombres pairs (2, 4, 6, 8…). Le suivant est 8 + 2 = 10 → l''option d ✓. Le piège : a (9) ajoute 1 et donne un nombre impair, b (16) double le dernier terme, et c (12) saute une étape (+4). On avance régulièrement de 2 en 2, donc après 8 vient 10.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('678b2e8e-3067-567d-8ea5-59225149a61c', 'a7fedd7a-7974-515c-a470-64ba8a81322b', '2 billes identiques coûtent 6 pièces d''or. Au même prix par bille, combien coûtent 5 billes ?', '[{"id":"a","text":"9"},{"id":"b","text":"15"},{"id":"c","text":"12"},{"id":"d","text":"30"}]'::jsonb, 'b', 'On cherche d''abord le prix d''une bille : 6 ÷ 2 = 3 pièces. Pour 5 billes : 5 × 3 = 15 → l''option b ✓. Le piège : a (9) ajoute juste 3 à 6 (comme si on passait de 2 à 3 billes), c (12) double le prix de 2 billes, et d (30) multiplie 6 par 5 sans ramener au prix unitaire. Il faut trouver le prix d''UNE bille, puis multiplier par 5.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d0d1817-1f5c-5ae4-b254-0403edd778e9', 'a7fedd7a-7974-515c-a470-64ba8a81322b', 'Dans cette pyramide, chaque nombre est la somme des deux nombres juste en dessous de lui. Quel nombre va tout en haut ? <svg viewBox="0 0 100 100"><rect x="38" y="10" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="26" font-size="15" text-anchor="middle" fill="#888">?</text><rect x="24" y="39" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="36" y="55" font-size="13" text-anchor="middle" fill="#222">5</text><rect x="52" y="39" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="64" y="55" font-size="13" text-anchor="middle" fill="#222">8</text><rect x="10" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="22" y="84" font-size="13" text-anchor="middle" fill="#222">2</text><rect x="38" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="84" font-size="13" text-anchor="middle" fill="#222">3</text><rect x="66" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="78" y="84" font-size="13" text-anchor="middle" fill="#222">5</text></svg>', '[{"id":"a","text":"10"},{"id":"b","text":"23"},{"id":"c","text":"13"},{"id":"d","text":"15"}]'::jsonb, 'c', 'La règle se vérifie sur la base : 2 + 3 = 5 et 3 + 5 = 8, ce sont bien les deux cases du milieu. Le sommet vaut donc 5 + 8 = 13 → l''option c ✓. Le piège : a (10) additionne les extrêmes de la base (2 + 3 + 5 = 10), b (23) additionne tous les nombres affichés, et d (15) ajoute 2 au sommet. Le sommet est la somme des DEUX cases juste en dessous, soit 5 + 8 = 13.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6835a31-5b79-564f-891c-f593f917ed11', '811683b3-ae70-59f4-a578-75baf45ce360', 'iq-training-fr', '⚔️ Défi Maths-raisonnement ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('28b01fba-96ed-5da4-a6d3-712e727dc50c', 'c6835a31-5b79-564f-891c-f593f917ed11', 'Observe la suite et trouve la règle cachée. Quel nombre vient ensuite ? 2, 5, 4, 7, 6, ?', '[{"id":"a","text":"9"},{"id":"b","text":"8"},{"id":"c","text":"5"},{"id":"d","text":"10"}]'::jsonb, 'a', 'La règle cachée alterne deux opérations : +3 puis −1, et ainsi de suite. 2 (+3)→5 (−1)→4 (+3)→7 (−1)→6 (+3)→9. ✓ Après le dernier 6, c''est un tour de +3, donc 9. L''option b (8) applique +2 comme si l''écart était constant. L''option c (5) applique −1 alors que c''est au tour du +3. L''option d (10) applique +4 (un cran de trop). Astuce : quand une suite monte puis redescend, cherche deux opérations qui alternent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4edad7b0-a689-5b8d-a4dd-d18646cd992a', 'c6835a31-5b79-564f-891c-f593f917ed11', 'Trouve la relation cachée entre le premier nombre et le second, puis applique-la. 2 → 4, 3 → 9, donc 5 → ?', '[{"id":"a","text":"15"},{"id":"b","text":"10"},{"id":"c","text":"25"},{"id":"d","text":"11"}]'::jsonb, 'c', 'La règle cachée : on élève le nombre au carré (n × n). 2 → 2×2 = 4 ✓ et 3 → 3×3 = 9 ✓, donc 5 → 5×5 = 25. ✓ La bonne réponse est 25. Les deux exemples écartent les fausses pistes : l''option a (15) suppose ×3, mais ×3 donnerait 2→6 (≠4), donc cette règle ne tient pas. L''option b (10) applique ×2, qui donnerait 3→6 (≠9). L''option d (11) ajoute 6, qui donnerait 2→8 (≠4). Seule la mise au carré marche pour les DEUX paires de départ. Vérifie toujours qu''une seule et même règle marche pour TOUTES les paires connues avant de l''appliquer à la nouvelle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc865933-f6e1-556b-bac1-ad75588a664a', 'c6835a31-5b79-564f-891c-f593f917ed11', 'Dans cette grille, chaque ligne suit la même règle de calcul reliant ses trois nombres. Quel nombre remplace le « ? » ? <svg viewBox="0 0 100 100"><line x1="4" y1="36" x2="96" y2="36" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="64" x2="96" y2="64" stroke="#9ca3af" stroke-width="1"/><line x1="35" y1="6" x2="35" y2="94" stroke="#9ca3af" stroke-width="1"/><line x1="65" y1="6" x2="65" y2="94" stroke="#9ca3af" stroke-width="1"/><text x="15" y="26" font-size="13" fill="#1f2937">4</text><text x="45" y="26" font-size="13" fill="#1f2937">3</text><text x="75" y="26" font-size="13" fill="#1f2937">7</text><text x="15" y="55" font-size="13" fill="#1f2937">6</text><text x="45" y="55" font-size="13" fill="#1f2937">2</text><text x="75" y="55" font-size="13" fill="#1f2937">8</text><text x="15" y="84" font-size="13" fill="#1f2937">5</text><text x="45" y="84" font-size="13" fill="#1f2937">3</text><text x="74" y="84" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"2"},{"id":"b","text":"8"},{"id":"c","text":"15"},{"id":"d","text":"7"}]'::jsonb, 'b', 'La règle cachée : sur chaque ligne, la 3e colonne est la somme des deux premières. Ligne 1 : 4+3 = 7 ✓. Ligne 2 : 6+2 = 8 ✓. Ligne 3 : 5+3 = 8, donc « ? » = 8. ✓ La bonne réponse est 8. L''option a (2) fait la différence (5−3) au lieu de la somme. L''option c (15) multiplie (5×3). L''option d (7) recopie le résultat de la 1re ligne sans recalculer. Teste ta règle sur TOUTES les lignes connues avant de l''appliquer à la ligne inconnue.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce043bcf-5989-5214-afd2-1be4b11e3b80', 'c6835a31-5b79-564f-891c-f593f917ed11', 'Une recette garde toujours le même rapport : 2 mesures de farine donnent 6 galettes. En respectant ce rapport, combien de galettes donnent 5 mesures ? <svg viewBox="0 0 100 100"><rect x="6" y="30" width="40" height="40" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="14" y="45" font-size="9" fill="#1f2937">2 mes.</text><text x="13" y="62" font-size="9" fill="#1f2937">6 gal.</text><text x="50" y="54" font-size="14" fill="#1f2937">→</text><rect x="60" y="30" width="40" height="40" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="68" y="45" font-size="9" fill="#1f2937">5 mes.</text><text x="73" y="63" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"9"},{"id":"b","text":"12"},{"id":"c","text":"30"},{"id":"d","text":"15"}]'::jsonb, 'd', 'La règle cachée : le rapport galettes/mesure est constant. 6 galettes pour 2 mesures = 3 galettes par mesure. Donc 5 mesures → 5 × 3 = 15 galettes. ✓ La bonne réponse est 15. L''option a (9) ajoute 3 (6+3) au lieu de respecter la proportion. L''option b (12) double simplement le 6 sans tenir compte du passage de 2 à 5 mesures. L''option c (30) multiplie 6 par 5 en oubliant que 6 correspond à 2 mesures, pas à 1. En proportion, ramène d''abord à une seule unité (ici 1 mesure).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63c5b8e8-e91b-568c-a030-a76290d21de3', 'c6835a31-5b79-564f-891c-f593f917ed11', 'Carré magique : chaque ligne, chaque colonne et chaque diagonale ont la MÊME somme. Quel nombre doit occuper la case marquée « ? » ? <svg viewBox="0 0 100 100"><rect x="6" y="6" width="88" height="88" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="35" y1="6" x2="35" y2="94" stroke="#1f2937" stroke-width="1"/><line x1="65" y1="6" x2="65" y2="94" stroke="#1f2937" stroke-width="1"/><line x1="6" y1="35" x2="94" y2="35" stroke="#1f2937" stroke-width="1"/><line x1="6" y1="65" x2="94" y2="65" stroke="#1f2937" stroke-width="1"/><text x="16" y="26" font-size="13" fill="#1f2937">8</text><text x="46" y="26" font-size="13" fill="#1f2937">1</text><text x="76" y="26" font-size="13" fill="#1f2937">6</text><text x="16" y="55" font-size="13" fill="#1f2937">3</text><text x="46" y="55" font-size="13" fill="#1f2937">5</text><text x="75" y="55" font-size="14" fill="#1f2937">?</text><text x="16" y="85" font-size="13" fill="#1f2937">4</text><text x="46" y="85" font-size="13" fill="#1f2937">9</text><text x="76" y="85" font-size="13" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"7"},{"id":"b","text":"6"},{"id":"c","text":"8"},{"id":"d","text":"5"}]'::jsonb, 'a', 'La règle cachée : toutes les lignes, colonnes et diagonales ont la même somme. La 1re ligne donne 8+1+6 = 15 : la somme magique est 15. La ligne du milieu est 3+5+?, donc ? = 15−3−5 = 7. ✓ Vérification par la colonne de droite : 6+7+2 = 15. La bonne réponse est 7. L''option b (6) répète la valeur du coin haut-droit. L''option d (5) recopie le centre. L''option c (8) donnerait 3+5+8 = 16, qui dépasse 15. Trouve d''abord la somme magique sur une ligne complète, puis déduis la case manquante par soustraction.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edd5de32-13d7-581d-b6bb-06b5dfaa10fb', 'c6835a31-5b79-564f-891c-f593f917ed11', 'Cette suite cache une règle sur les écarts entre les nombres. Quel nombre la complète ? 2, 6, 12, 20, 30, ?', '[{"id":"a","text":"40"},{"id":"b","text":"44"},{"id":"c","text":"42"},{"id":"d","text":"36"}]'::jsonb, 'c', 'La règle cachée se lit sur les écarts : 6−2=4, 12−6=6, 20−12=8, 30−20=10. Les écarts montent de 2 en 2 (4, 6, 8, 10), donc le prochain écart est 12 : 30+12 = 42. ✓ La bonne réponse est 42. L''option a (40) garde un écart de +10 comme s''il était constant. L''option b (44) saute à un écart de +14 (deux crans de trop). L''option d (36) prend un écart de +6, en arrière. Quand l''écart n''est pas constant, regarde l''écart des écarts : ici il augmente régulièrement de 2.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8de590dd-b427-5876-b1ec-d528d4062ce8', '811683b3-ae70-59f4-a578-75baf45ce360', 'iq-training-fr', '👑 Élite Maths-raisonnement ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('47d16129-624d-5da7-9952-dc05ac03ae3f', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'Observe la suite et trouve le nombre qui remplace le « ? » : 2, 6, 12, 20, 30, ?', '[{"id":"a","text":"42"},{"id":"b","text":"40"},{"id":"c","text":"36"},{"id":"d","text":"38"}]'::jsonb, 'a', 'Règle cachée : l''écart entre deux termes augmente régulièrement de 2. Les différences sont 4, 6, 8, 10 (6−2=4, 12−6=6, 20−12=8, 30−20=10), donc la suivante vaut 12. 30 + 12 = 42. ✓ option a. (Autre vue : chaque terme est n×(n+1) : 1×2, 2×3, 3×4, 4×5, 5×6, puis 6×7 = 42.) Piège b (40) : on a gardé le dernier écart 10 au lieu de l''augmenter à 12. Piège d (38) : on a ajouté 8 au lieu de 12, en répétant un écart trop ancien. Piège c (36) : on a supposé un écart constant de 6, ce que la suite contredit dès le départ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90b16a6f-d7f4-56dc-9a2c-7518fc4990b0', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'Une même règle relie le nombre de gauche à celui de droite. 3 → 10 et 5 → 16. Donc 7 → ?', '[{"id":"a","text":"24"},{"id":"b","text":"21"},{"id":"c","text":"22"},{"id":"d","text":"20"}]'::jsonb, 'c', 'Règle cachée : on multiplie par 3 puis on ajoute 1. Vérification avec les DEUX paires données : 3×3+1 = 10 ✓ et 5×3+1 = 16 ✓. Une seule règle affine colle aux deux exemples, donc 7×3+1 = 22. ✓ option c. Piège b (21) : on a multiplié par 3 mais oublié le « +1 » (7×3 = 21). Piège d (20) : on a vu « +7 » (3+7=10) et appliqué +13, ou additionné au hasard ; cette règle ne marche pas sur 5 → 16. Piège a (24) : on a fait ×3+3, qui donnerait 12 pour 3, donc faux.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ea3b8fd-a647-5dfe-a4ba-a9b8de4751d6', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'Dans ce carré magique, chaque ligne, chaque colonne et chaque diagonale a la MÊME somme. Quel nombre va dans la case « ? » ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="2" fill="none"><rect x="5" y="5" width="30" height="30"/><rect x="35" y="5" width="30" height="30"/><rect x="65" y="5" width="30" height="30"/><rect x="5" y="35" width="30" height="30"/><rect x="35" y="35" width="30" height="30"/><rect x="65" y="35" width="30" height="30"/><rect x="5" y="65" width="30" height="30"/><rect x="35" y="65" width="30" height="30"/><rect x="65" y="65" width="30" height="30"/></g><g font-size="15" text-anchor="middle" fill="#1e293b"><text x="20" y="25">8</text><text x="50" y="25">1</text><text x="80" y="25">6</text><text x="20" y="55">3</text><text x="50" y="55" fill="#ef4444">?</text><text x="80" y="55">7</text><text x="20" y="85">4</text><text x="50" y="85">9</text><text x="80" y="85">2</text></g></svg>', '[{"id":"a","text":"6"},{"id":"b","text":"5"},{"id":"c","text":"4"},{"id":"d","text":"7"}]'::jsonb, 'b', 'Règle : toutes les lignes/colonnes/diagonales partagent la même somme. Une ligne complète la donne : 8 + 1 + 6 = 15, donc la somme commune est 15. La case « ? » est au centre ; sa ligne 3 + ? + 7 = 15 impose ? = 5. ✓ option b. On peut vérifier : la colonne 1 + ? + 9 = 15 donne aussi 5, et la diagonale 8 + ? + 2 = 15 aussi. Trois contrôles concordent. Piège a (6) : on a pris la somme 16 au lieu de 15, en se trompant sur une ligne de référence. Piège c (4) : on a additionné seulement 3 + 7 + 1 sans fixer la bonne somme cible. Piège d (7) : on a recopié une valeur voisine de la grille au lieu de calculer.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de9e5a75-3a74-51be-9d6a-2ed372f831cc', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'Une même règle relie les deux nombres du haut au nombre du bas dans chaque triangle. Trouve le nombre du bas du dernier triangle (le « ? »). <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5"><line x1="10" y1="22" x2="18" y2="55"/><line x1="26" y1="22" x2="18" y2="55"/><line x1="42" y1="22" x2="50" y2="55"/><line x1="58" y1="22" x2="50" y2="55"/><line x1="74" y1="22" x2="82" y2="55"/><line x1="90" y1="22" x2="82" y2="55"/></g><g stroke="#1e293b" stroke-width="1.5" fill="#e2e8f0"><circle cx="10" cy="22" r="9"/><circle cx="26" cy="22" r="9"/><circle cx="18" cy="60" r="9"/><circle cx="42" cy="22" r="9"/><circle cx="58" cy="22" r="9"/><circle cx="50" cy="60" r="9"/><circle cx="74" cy="22" r="9"/><circle cx="90" cy="22" r="9"/><circle cx="82" cy="60" r="9" fill="#fee2e2"/></g><g font-size="11" text-anchor="middle" fill="#1e293b"><text x="10" y="26">3</text><text x="26" y="26">4</text><text x="18" y="64">11</text><text x="42" y="26">2</text><text x="58" y="26">5</text><text x="50" y="64">9</text><text x="74" y="26">4</text><text x="90" y="26">6</text><text x="82" y="64" fill="#ef4444">?</text></g></svg>', '[{"id":"a","text":"22"},{"id":"b","text":"24"},{"id":"c","text":"10"},{"id":"d","text":"23"}]'::jsonb, 'd', 'Règle : nombre du bas = (produit des deux du haut) − 1. On la déduit des deux triangles complets : 3×4 − 1 = 11 ✓ et 2×5 − 1 = 9 ✓. C''est la seule règle qui marche pour les deux. On l''applique : 4×6 − 1 = 24 − 1 = 23. ✓ option d. Piège b (24) : on a fait le produit 4×6 mais oublié de retirer 1. Piège c (10) : on a additionné 4 + 6 puis ajusté, en confondant somme et produit. Piège a (22) : on a retiré 2 au lieu de 1, en se trompant de constante.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76a307bc-fc5c-5468-b3a4-022b792a886f', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'Pour préparer un sirop au même goût, il faut 12 verres d''eau pour 3 verres de concentré. Combien de verres d''eau pour 5 verres de concentré ? <svg viewBox="0 0 100 100"><g font-size="9" fill="#1e293b"><text x="4" y="20">3 concentré</text><text x="4" y="58">5 concentré</text></g><g stroke="#1e293b" stroke-width="1"><rect x="4" y="24" width="12" height="10" fill="#fca5a5"/><rect x="16" y="24" width="12" height="10" fill="#fca5a5"/><rect x="28" y="24" width="12" height="10" fill="#fca5a5"/><rect x="4" y="62" width="12" height="10" fill="#fca5a5"/><rect x="16" y="62" width="12" height="10" fill="#fca5a5"/><rect x="28" y="62" width="12" height="10" fill="#fca5a5"/><rect x="40" y="62" width="12" height="10" fill="#fca5a5"/><rect x="52" y="62" width="12" height="10" fill="#fca5a5"/></g><g font-size="9" fill="#1e293b"><text x="50" y="32">+ 12 eau</text><text x="70" y="70" fill="#ef4444">+ ? eau</text></g></svg>', '[{"id":"a","text":"20"},{"id":"b","text":"14"},{"id":"c","text":"60"},{"id":"d","text":"36"}]'::jsonb, 'a', 'Règle : pour garder le même goût, le rapport eau/concentré reste constant. Ici 12 ÷ 3 = 4, donc il faut 4 verres d''eau par verre de concentré. Pour 5 concentrés : 5 × 4 = 20 verres d''eau. ✓ option a. Piège b (14) : raisonnement additif — on a ajouté la différence de concentré (5−3 = 2) à 12 au lieu d''utiliser le rapport. Piège c (60) : on a multiplié 12 par 5 (le nombre total de concentrés) au lieu de multiplier par le rapport. Piège d (36) : on a multiplié 12 par 3, en réutilisant l''ancien nombre de concentrés. La proportion se conserve par multiplication du rapport, pas par addition.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d0447f5-b484-5b0f-ab27-d47e7b732feb', '8de590dd-b427-5876-b1ec-d528d4062ce8', 'Observe la suite et trouve le nombre qui remplace le « ? » : 1, 2, 6, 24, 120, ?', '[{"id":"a","text":"600"},{"id":"b","text":"720"},{"id":"c","text":"144"},{"id":"d","text":"840"}]'::jsonb, 'b', 'Règle cachée : on multiplie par un facteur qui grandit de 1 à chaque étape. 1×2 = 2, 2×3 = 6, 6×4 = 24, 24×5 = 120, donc l''étape suivante est ×6 : 120 × 6 = 720. ✓ option b. Piège a (600) : on a gardé le même facteur (×5) au lieu de l''augmenter à ×6. Piège c (144) : on a additionné les deux derniers termes (120 + 24), un réflexe de type Fibonacci qui ne colle pas à la suite. Piège d (840) : on a sauté un facteur en multipliant par 7 au lieu de 6. Le facteur augmente d''exactement 1 à chaque pas.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d2649cb0-599d-5e1e-97fe-91ae3eb018d5', '6f12a148-645f-53f2-bc45-c87223c6a146', 'iq-training-fr', 'Échauffement Intelligence fluide ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('577dcb42-ac1b-5f40-8b46-7436f2ed3571', 'd2649cb0-599d-5e1e-97fe-91ae3eb018d5', 'Chaque case ajoute un point par rapport à la précédente. Combien de points dans la case manquante ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="16" cy="50" r="3" fill="#1d4ed8"/><rect x="30" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="37" cy="50" r="3" fill="#1d4ed8"/><circle cx="45" cy="50" r="3" fill="#1d4ed8"/><rect x="54" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="60" cy="50" r="3" fill="#1d4ed8"/><circle cx="68" cy="50" r="3" fill="#1d4ed8"/><circle cx="64" cy="43" r="3" fill="#1d4ed8"/><rect x="78" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><text x="88" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"46\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"46\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'c', 'La règle cachée : le nombre de points augmente de 1 à chaque case — 1, 2, 3… ✓ La case manquante doit donc en contenir 4, soit l''option c. L''option b (3 points) répète la case précédente au lieu d''augmenter. L''option a (2 points) recule d''un cran. L''option d (1 point) revient au tout début de la suite.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63982587-c466-5bbb-9a4b-6472f1e18b24', 'd2649cb0-599d-5e1e-97fe-91ae3eb018d5', 'Une seule règle agit sur le triangle à chaque étape. Quelle figure vient ensuite ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,60 6,40 30,40" fill="none" stroke="#7c3aed" stroke-width="2"/><polygon points="45,60 33,40 57,40" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><polygon points="72,60 60,40 84,40" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="94" y="54" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,62 36,40 64,40\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,62 36,40 64,40\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,40 36,62 64,62\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : le remplissage alterne — vide, plein, vide… ✓ Après le triangle vide, le suivant doit être plein, soit l''option a. L''option b est vide : elle répète l''étape précédente au lieu d''alterner. L''option c est bien pleine mais retournée vers le bas : la forme et l''orientation n''ont jamais changé dans la suite. L''option d remplace le triangle par un carré : on ne change que la couleur, jamais la forme.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('503a5408-6df3-540b-8e67-0c729c65dfd5', 'd2649cb0-599d-5e1e-97fe-91ae3eb018d5', 'Dans chaque case, le point se déplace toujours d''un coin vers la droite (sens horaire). Où sera-t-il dans la case manquante ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="11" cy="43" r="3.5" fill="#0f766e"/><rect x="32" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="49" cy="43" r="3.5" fill="#0f766e"/><rect x="58" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="75" cy="55" r="3.5" fill="#0f766e"/><rect x="84" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><text x="95" y="55" font-size="15" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"56\" cy=\"44\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"44\" cy=\"56\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"56\" cy=\"56\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"44\" cy=\"44\" r=\"3.5\" fill=\"#0f766e\"/></svg>"}]'::jsonb, 'b', 'La règle cachée : le point avance d''un coin dans le sens horaire à chaque case — haut-gauche, haut-droite, bas-droite… ✓ Le coin suivant dans le sens horaire est bas-gauche, soit l''option b. L''option c (bas-droite) répète la case précédente. L''option a (haut-droite) recule d''un cran. L''option d (haut-gauche) revient au point de départ, comme si le tour était déjà bouclé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80d55130-afaa-5306-a5c2-f7258298a3d0', 'd2649cb0-599d-5e1e-97fe-91ae3eb018d5', 'On superpose la case de gauche et celle du milieu : un coin n''est colorié dans le résultat que s''il l''est dans une seule des deux cases (jamais dans les deux). Quel est le résultat ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="35" width="26" height="26" fill="none" stroke="#be123c" stroke-width="2"/><line x1="19" y1="35" x2="19" y2="61" stroke="#be123c" stroke-width="1"/><line x1="6" y1="48" x2="32" y2="48" stroke="#be123c" stroke-width="1"/><rect x="6" y="35" width="13" height="13" fill="#be123c"/><rect x="19" y="48" width="13" height="13" fill="#be123c"/><text x="42" y="52" font-size="16" fill="#64748b" text-anchor="middle">+</text><rect x="52" y="35" width="26" height="26" fill="none" stroke="#be123c" stroke-width="2"/><line x1="65" y1="35" x2="65" y2="61" stroke="#be123c" stroke-width="1"/><line x1="52" y1="48" x2="78" y2="48" stroke="#be123c" stroke-width="1"/><rect x="52" y="35" width="13" height="13" fill="#be123c"/><rect x="65" y="35" width="13" height="13" fill="#be123c"/><text x="88" y="52" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"37\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"37\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"37\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"37\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : un coin est colorié seulement s''il l''est dans une seule des deux cases. À gauche sont coloriés haut-gauche et bas-droite ; au milieu haut-gauche et haut-droite. Le haut-gauche est colorié dans les deux : il s''éteint. ✓ Restent haut-droite et bas-droite, soit l''option a. L''option d additionne tous les coins coloriés sans en éteindre aucun. L''option c garde le haut-gauche commun, qui aurait dû disparaître. L''option b ne garde qu''un seul coin et en oublie un.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54fb5dd4-d2cf-5d27-a89a-fab5cddda06d', 'd2649cb0-599d-5e1e-97fe-91ae3eb018d5', 'Une seule règle relie les trois premières cases. Quelle figure complète la dernière case ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="5" fill="none" stroke="#b45309" stroke-width="2"/><g stroke="#b45309" stroke-width="2" fill="none"><circle cx="38" cy="50" r="5"/><circle cx="38" cy="50" r="9"/></g><g stroke="#b45309" stroke-width="2" fill="none"><circle cx="63" cy="50" r="5"/><circle cx="63" cy="50" r="9"/><circle cx="63" cy="50" r="13"/></g><text x="88" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/><circle cx=\"50\" cy=\"50\" r=\"13\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/><circle cx=\"50\" cy=\"50\" r=\"13\"/><circle cx=\"50\" cy=\"50\" r=\"17\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'La règle cachée : le nombre de cercles concentriques augmente de 1 à chaque case — 1, 2, 3… ✓ La dernière case doit en contenir 4, soit l''option b. L''option a (3 cercles) répète la case précédente au lieu d''ajouter un cercle. L''option c (2 cercles) recule d''un cran. L''option d (1 cercle) revient à la toute première case.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('128336b9-c1c5-56f0-9575-ae8b6a787c6b', '6f12a148-645f-53f2-bc45-c87223c6a146', 'iq-training-fr', '⭐ Échauffement', 1, 50, 10, 'practice', 'admin', 1)
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
  ('73ac3f9f-0e94-598d-a41e-237fd572d4c6', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', 'Une règle cachée transforme la figure à chaque étape : on ajoute UN trait horizontal de plus dans le carré (0, puis 1, puis 2…). Quelle est l''étape suivante ? <svg viewBox="0 0 100 100"><rect x="3" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><rect x="30" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><line x1="33" y1="50" x2="51" y2="50" stroke="#222" stroke-width="2"/><rect x="57" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><line x1="60" y1="45" x2="78" y2="45" stroke="#222" stroke-width="2"/><line x1="60" y1="55" x2="78" y2="55" stroke="#222" stroke-width="2"/><rect x="84" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2" stroke-dasharray="3 3"/><text x="96" y="54" font-size="14" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"42\" x2=\"65\" y2=\"42\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"50\" x2=\"65\" y2=\"50\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"58\" x2=\"65\" y2=\"58\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"45\" x2=\"65\" y2=\"45\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"55\" x2=\"65\" y2=\"55\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"50\" y1=\"35\" x2=\"50\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"40\" y1=\"35\" x2=\"40\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"60\" y1=\"35\" x2=\"60\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"50\" x2=\"65\" y2=\"50\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'La règle cachée est : +1 trait horizontal à chaque étape (0, 1, 2, donc ensuite 3). La case suivante doit contenir 3 traits horizontaux → l''option a ✓. Le piège : b répète 2 traits (on a oublié d''ajouter), d revient à 1 trait (on lit la suite à l''envers) et c met bien 3 traits mais VERTICAUX (mauvaise direction). On induit la règle puis on l''applique : 2 + 1 = 3 traits horizontaux.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3bd2ab2-3bb7-5afa-bf88-bf6f2ef50eef', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', 'Règle du groupe : une figure entre dans la boîte seulement si elle est PLEINE (remplie de noir) ET porte une croix blanche au centre. Quelle figure respecte les DEUX conditions ? <svg viewBox="0 0 100 100"><circle cx="30" cy="32" r="14" fill="#222"/><line x1="24" y1="32" x2="36" y2="32" stroke="#fff" stroke-width="3"/><line x1="30" y1="26" x2="30" y2="38" stroke="#fff" stroke-width="3"/><rect x="58" y="18" width="28" height="28" fill="#222"/><line x1="64" y1="32" x2="80" y2="32" stroke="#fff" stroke-width="3"/><line x1="72" y1="24" x2="72" y2="40" stroke="#fff" stroke-width="3"/><text x="50" y="72" font-size="10" text-anchor="middle" fill="#222">PLEIN + croix = dans la boîte</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#fff\" stroke-width=\"4\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#fff\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"24\" y=\"24\" width=\"52\" height=\"52\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'Il faut réunir DEUX conditions à la fois : figure pleine ET croix blanche au centre. Seule l''option b est noire remplie AVEC une croix blanche → b ✓. Le piège : c est pleine mais sans croix (une condition manque), a et d portent une croix mais sont vides (pas remplies). Quand une règle a deux conditions, les deux doivent être vraies — une seule ne suffit pas.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('accec347-6f44-51a5-b811-b421ea923459', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', 'Une règle cachée gouverne la taille : le rond change de taille en alternant grand, petit, grand, petit… Quel rond vient ensuite ? <svg viewBox="0 0 100 100"><circle cx="16" cy="50" r="13" fill="none" stroke="#222" stroke-width="2"/><circle cx="42" cy="50" r="6" fill="none" stroke="#222" stroke-width="2"/><circle cx="68" cy="50" r="13" fill="none" stroke="#222" stroke-width="2"/><circle cx="90" cy="50" r="9" fill="none" stroke="#888" stroke-width="2" stroke-dasharray="3 3"/><text x="90" y="54" font-size="11" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"10\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'La règle cachée alterne la taille : grand, petit, grand, donc ensuite PETIT. Le rond suivant est petit → l''option d ✓. Le piège : b reprend un grand rond (on a oublié l''alternance), c est grand ET plein (on change le remplissage en plus de la taille) et a est un carré (on change la forme). Une seule chose varie ici : la taille, qui alterne.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d87aa8c9-5805-57c1-b668-f3f19bce6a6f', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', 'Chaîne de transformations : observe comment le triangle se transforme dans l''exemple du haut, puis applique EXACTEMENT la même transformation au triangle du bas. Que devient-il ? <svg viewBox="0 0 100 100"><polygon points="18,8 8,26 28,26" fill="#222"/><text x="36" y="22" font-size="14" fill="#222">→</text><polygon points="68,8 50,18 68,28" fill="#222"/><text x="50" y="45" font-size="9" text-anchor="middle" fill="#888">exemple : pointe en haut devient pointe à gauche</text><polygon points="50,58 40,76 60,76" fill="#222"/><text x="68" y="71" font-size="14" fill="#222">→</text><text x="88" y="71" font-size="16" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"38,30 38,70 62,50\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"62,30 62,70 38,50\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,40 70,40 50,68\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,38 70,38 50,18\" fill=\"#222\"/></svg>"}]'::jsonb, 'b', 'Dans l''exemple, le triangle qui pointe vers le HAUT se transforme en triangle qui pointe vers la GAUCHE (un quart de tour). Le triangle du bas pointe lui aussi vers le haut, donc il doit pointer vers la gauche → l''option b ✓. Le piège : a pointe à droite (on a tourné dans le mauvais sens), c pointe en bas (demi-tour, deux quarts de tour au lieu d''un) et d pointe en haut (on n''a rien transformé). On reproduit exactement la transformation montrée : haut → gauche.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a51a425a-81f9-5009-8b94-2794e3b6351b', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', 'Analogie visuelle : la figure de gauche se transforme en celle de droite par une règle. Applique LA MÊME règle à la nouvelle figure. Le carré clair est à « carré foncé DE MÊME TAILLE » ce que le rond clair est à… ? <svg viewBox="0 0 100 100"><rect x="6" y="30" width="20" height="20" fill="none" stroke="#222" stroke-width="2"/><text x="33" y="45" font-size="13" fill="#222">→</text><rect x="46" y="30" width="20" height="20" fill="#222"/><text x="78" y="45" font-size="13" fill="#222">| ?</text><circle cx="22" cy="78" r="20" fill="none" stroke="#222" stroke-width="2"/><text x="54" y="82" font-size="13" fill="#222">→</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"8\" fill=\"#222\"/></svg>"}]'::jsonb, 'a', 'La règle qui transforme la première paire est : « garder la forme ET la taille, mais remplir de noir » (le carré vide devient un carré plein de même côté ; ni la forme ni la taille ne changent). Appliquée au rond vide (rayon 20), elle donne un rond plein du MÊME rayon 20 → l''option a ✓. Le piège : b garde la bonne taille mais reste vide (on n''a pas appliqué le remplissage), c est rempli mais change la forme en carré (on copie la forme du modèle au lieu de la règle) et d est bien rempli mais rétréci (rayon 8 au lieu de 20 : on a ajouté un changement de taille qui n''existe pas dans la règle). Seul a est un rond plein de la même taille que le modèle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73e278eb-cdac-5ff5-9d84-db8dab7425b1', '128336b9-c1c5-56f0-9575-ae8b6a787c6b', 'Découvre la relation cachée : dans chaque figure-exemple, le nombre de points à l''intérieur est ÉGAL au nombre de côtés du polygone. Le triangle (3 côtés) contient 3 points, le carré (4 côtés) contient 4 points. Combien de points doit contenir le pentagone (5 côtés) ? <svg viewBox="0 0 100 100"><polygon points="18,18 6,42 30,42" fill="none" stroke="#222" stroke-width="2"/><circle cx="18" cy="28" r="2" fill="#222"/><circle cx="14" cy="36" r="2" fill="#222"/><circle cx="22" cy="36" r="2" fill="#222"/><rect x="55" y="16" width="28" height="28" fill="none" stroke="#222" stroke-width="2"/><circle cx="63" cy="24" r="2" fill="#222"/><circle cx="75" cy="24" r="2" fill="#222"/><circle cx="63" cy="36" r="2" fill="#222"/><circle cx="75" cy="36" r="2" fill="#222"/><polygon points="50,58 68,71 61,90 39,90 32,71" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="80" font-size="11" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"3 points"},{"id":"b","text":"4 points"},{"id":"c","text":"5 points"},{"id":"d","text":"6 points"}]'::jsonb, 'c', 'La relation cachée est : nombre de points = nombre de côtés. Le triangle (3 côtés) a 3 points, le carré (4 côtés) a 4 points ; le pentagone a 5 côtés, donc 5 points → l''option c ✓. Le piège : b (4) recopie le total du carré sans recompter les côtés, a (3) recopie celui du triangle, et d (6) ajoute un point de trop (confusion avec l''hexagone). On déduit la règle puis on compte les côtés du pentagone : 5.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('938bdf2c-a518-584c-aa35-6b56d7aca108', '6f12a148-645f-53f2-bc45-c87223c6a146', 'iq-training-fr', '⚔️ Défi Intelligence fluide ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('a40e2322-ca96-5cab-812a-d472ffe61fa7', '938bdf2c-a518-584c-aa35-6b56d7aca108', 'Règle inédite : on superpose les deux premières grilles. Un point ne reste dans le résultat que s''il apparaît dans UNE seule des deux grilles (jamais dans les deux). Quelle grille est le résultat ? <svg viewBox="0 0 100 100"><rect x="4" y="34" width="28" height="28" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="18" y1="34" x2="18" y2="62" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="48" x2="32" y2="48" stroke="#9ca3af" stroke-width="1"/><circle cx="11" cy="41" r="3" fill="#1f2937"/><circle cx="25" cy="55" r="3" fill="#1f2937"/><text x="36" y="53" font-size="14" fill="#1f2937">+</text><rect x="48" y="34" width="28" height="28" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="62" y1="34" x2="62" y2="62" stroke="#9ca3af" stroke-width="1"/><line x1="48" y1="48" x2="76" y2="48" stroke="#9ca3af" stroke-width="1"/><circle cx="55" cy="41" r="3" fill="#1f2937"/><circle cx="69" cy="41" r="3" fill="#1f2937"/><text x="80" y="53" font-size="14" fill="#1f2937">=</text><text x="90" y="53" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"37\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'La règle cachée est un OU exclusif : on garde une case noircie seulement si elle est marquée dans exactement une des deux grilles. Grille 1 = haut-gauche + bas-droite ; grille 2 = haut-gauche + haut-droite. La case haut-gauche est dans les deux → elle s''annule. Restent haut-droite (grille 2 seule) et bas-droite (grille 1 seule). ✓ L''option a montre exactement ces deux points (haut-droite et bas-droite). L''option b est l''union (elle garde le point commun haut-gauche, c''est l''erreur classique du « tout additionner »). L''option d est aussi l''union, encore plus chargée. L''option c ne garde que le point commun, soit l''inverse exact de la règle (intersection). Marque un point uniquement quand il apparaît dans une seule grille.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1489c0f7-468e-5ae2-bc5a-75f68b8b7d72', '938bdf2c-a518-584c-aa35-6b56d7aca108', 'Chaîne de transformation : observe comment le nombre de côtés du polygone évolue d''une figure à la suivante, puis prolonge la suite. Quelle figure vient ensuite ? <svg viewBox="0 0 100 100"><polygon points="14,62 6,46 22,46" fill="none" stroke="#1f2937" stroke-width="2"/><rect x="30" y="42" width="18" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><polygon points="64,40 73,47 70,58 58,58 55,47" fill="none" stroke="#1f2937" stroke-width="2"/><text x="84" y="56" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 68,34 74,54 62,72 38,72 26,54 32,34\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 70,38 62,62 38,62 30,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 72,35 72,61 50,74 28,61 28,35\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'La règle cachée : le nombre de côtés augmente de 1 à chaque étape. Triangle (3) → carré (4) → pentagone (5) → ?. La figure suivante doit donc avoir 6 côtés : un hexagone. ✓ L''option d est un hexagone (6 côtés) : c''est la bonne. L''option b est un pentagone (5 côtés) et répète l''étape précédente sans avancer. L''option c est un carré (4 côtés), elle revient deux crans en arrière. L''option a est un heptagone (7 côtés), elle saute un cran (+2 au lieu de +1). Compte les côtés et garde l''écart constant de +1.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55a7d051-dd25-56c3-befa-820b8f0aa543', '938bdf2c-a518-584c-aa35-6b56d7aca108', 'Deux attributs varient indépendamment le long de la suite : la FORME (cercle / carré, en alternance) et le REMPLISSAGE (vide / plein, en alternance). Quelle figure occupe la case « ? » ? <svg viewBox="0 0 100 100"><circle cx="14" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><rect x="30" y="41" width="18" height="18" fill="#1f2937" stroke="#1f2937" stroke-width="2"/><circle cx="66" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><text x="84" y="56" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'La règle cachée : deux cycles indépendants à suivre séparément. La forme alterne cercle, carré, cercle, … donc la 4e case est un CARRÉ. Le remplissage alterne vide, plein, vide, … donc la 4e case est PLEINE. La réponse combine les deux : un carré plein. ✓ L''option b (carré plein) respecte forme = carré ET remplissage = plein. L''option a (carré vide) a la bonne forme mais inverse le remplissage. L''option d (cercle plein) a le bon remplissage mais garde la forme précédente (oubli de l''alternance de forme). L''option c (cercle vide) se trompe sur les deux attributs à la fois. Le piège courant : ne suivre qu''un seul attribut ; ici il faut faire avancer la forme ET le remplissage chacun dans son cycle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3286fa8a-0fd5-51a7-97dc-530af4ddac68', '938bdf2c-a518-584c-aa35-6b56d7aca108', 'Chaîne de transformation à DEUX effets combinés à chaque pas : la flèche tourne de 90° dans le sens horaire ET un point supplémentaire apparaît (1, puis 2, puis 3…). Quelle figure poursuit la suite ? <svg viewBox="0 0 100 100"><line x1="14" y1="62" x2="14" y2="40" stroke="#1f2937" stroke-width="3"/><polygon points="14,34 9,44 19,44" fill="#1f2937"/><circle cx="14" cy="72" r="2.5" fill="#1f2937"/><line x1="40" y1="50" x2="62" y2="50" stroke="#1f2937" stroke-width="3"/><polygon points="68,50 58,45 58,55" fill="#1f2937"/><circle cx="46" cy="68" r="2.5" fill="#1f2937"/><circle cx="56" cy="68" r="2.5" fill="#1f2937"/><line x1="86" y1="40" x2="86" y2="62" stroke="#1f2937" stroke-width="3"/><polygon points="86,68 81,58 91,58" fill="#1f2937"/><circle cx="78" cy="34" r="2.5" fill="#1f2937"/><circle cx="86" cy="34" r="2.5" fill="#1f2937"/><circle cx="94" cy="34" r="2.5" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"60\" y1=\"40\" x2=\"38\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"32,40 42,34 42,46\" fill=\"#1f2937\"/><circle cx=\"38\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"40\" y1=\"40\" x2=\"62\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"68,40 58,34 58,46\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"60\" y1=\"40\" x2=\"38\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"32,40 42,34 42,46\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"60\" x2=\"50\" y2=\"38\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"50,32 44,42 56,42\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'c', 'La règle cachée combine deux effets simultanés. Direction : haut → droite → bas → ?, soit +90° horaire à chaque pas, donc la suite pointe vers la GAUCHE. Points : 1, 2, 3, … donc l''étape suivante en a 4. ✓ L''option c réunit les deux : flèche vers la gauche ET 4 points. L''option b a bien 4 points mais la flèche pointe à droite (mauvaise rotation, retour en arrière). L''option a a la bonne direction (gauche) mais seulement 3 points (oubli du +1). L''option d garde 4 points mais une flèche vers le haut (saut d''un quart de tour). Applique TOUJOURS les deux transformations ensemble, jamais une seule.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c6a9ccd-15d1-5a2a-992a-c5d73b86f360', '938bdf2c-a518-584c-aa35-6b56d7aca108', 'Matrice 3×3, règle inédite par ligne : la 3e case s''obtient en RETIRANT de la 1re case les positions qui sont aussi occupées dans la 2e case (case 1 moins case 2). Quelle figure remplit la case manquante (en bas à droite) ? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="12" cy="12" r="3" fill="#1f2937"/><circle cx="24" cy="12" r="3" fill="#1f2937"/><circle cx="12" cy="24" r="3" fill="#1f2937"/><circle cx="44" cy="12" r="3" fill="#1f2937"/><circle cx="56" cy="24" r="3" fill="#1f2937"/><circle cx="88" cy="12" r="3" fill="#1f2937"/><circle cx="76" cy="24" r="3" fill="#1f2937"/><circle cx="12" cy="44" r="3" fill="#1f2937"/><circle cx="24" cy="44" r="3" fill="#1f2937"/><circle cx="24" cy="56" r="3" fill="#1f2937"/><circle cx="56" cy="44" r="3" fill="#1f2937"/><circle cx="76" cy="44" r="3" fill="#1f2937"/><circle cx="88" cy="56" r="3" fill="#1f2937"/><circle cx="12" cy="76" r="3" fill="#1f2937"/><circle cx="24" cy="76" r="3" fill="#1f2937"/><circle cx="12" cy="88" r="3" fill="#1f2937"/><circle cx="24" cy="88" r="3" fill="#1f2937"/><circle cx="56" cy="76" r="3" fill="#1f2937"/><circle cx="44" cy="88" r="3" fill="#1f2937"/><circle cx="56" cy="88" r="3" fill="#1f2937"/><text x="76" y="86" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"40\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'La règle cachée : case 3 = case 1, dont on retire toute position déjà occupée dans la case 2. Vérifie sur la 1re ligne : case 1 occupe haut-gauche, haut-droite, bas-gauche ; case 2 occupe haut-gauche et bas-droite ; on enlève la position commune (haut-gauche) → il reste haut-droite et bas-gauche, soit 2 points, exactement la case 3. La 2e ligne confirme : {haut-gauche, haut-droite, bas-droite} moins {haut-droite} = {haut-gauche, bas-droite}, 2 points. Dernière ligne : case 1 est pleine (haut-gauche, haut-droite, bas-gauche, bas-droite), case 2 occupe haut-droite, bas-gauche, bas-droite ; on enlève ces trois → il reste UNIQUEMENT le haut-gauche. ✓ L''option b est un seul point en haut-gauche : c''est la bonne. L''option a garde 2 points (elle n''a retiré qu''une partie des positions communes). L''option d garde 3 points (elle additionne ou oublie la soustraction). L''option c met bien 1 point mais en bas-gauche, justement une position annulée par la case 2. Soustrais position par position : ne conserve que ce que la case 2 ne touche pas.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e106f3c3-d6cb-54ab-9160-ab9099ed164c', '938bdf2c-a518-584c-aa35-6b56d7aca108', 'Règle inédite à découvrir : un jeton noir tourne autour des coins d''un carré dans le sens horaire ; à chaque pas, le côté du carré qui PORTE le jeton s''épaissit (devient un trait gras). Quelle figure poursuit la suite ? <svg viewBox="0 0 100 100"><rect x="6" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="6" y1="38" x2="28" y2="38" stroke="#1f2937" stroke-width="4"/><circle cx="6" cy="38" r="3.5" fill="#1f2937"/><rect x="40" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="62" y1="38" x2="62" y2="60" stroke="#1f2937" stroke-width="4"/><circle cx="62" cy="38" r="3.5" fill="#1f2937"/><rect x="74" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="74" y1="60" x2="96" y2="60" stroke="#1f2937" stroke-width="4"/><circle cx="96" cy="60" r="3.5" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"30\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"70\" x2=\"70\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'La règle cachée combine deux mouvements liés. Le jeton occupe les coins dans le sens horaire : coin haut-gauche → coin haut-droite → coin bas-droite → ensuite coin bas-GAUCHE. Et le côté épaissi est toujours celui qui suit le jeton dans ce sens : haut, puis droite, puis bas, donc ensuite le côté GAUCHE. ✓ L''option a place le jeton en bas-gauche ET épaissit le côté gauche : les deux mouvements concordent. L''option b épaissit bien le côté gauche mais remet le jeton en haut-gauche (retour en arrière). L''option c laisse le jeton en bas-gauche mais épaissit le bas (le côté précédent, pas le suivant). L''option d mélange : jeton en bas-gauche mais côté haut épaissi (deux crans d''écart). Fais avancer le jeton ET le côté gras ensemble, d''un cran horaire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('19179235-1700-5a99-8988-83e6be67c669', '6f12a148-645f-53f2-bc45-c87223c6a146', 'iq-training-fr', '👑 Élite Intelligence fluide ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('8caba15f-b375-5cc2-bd60-755c34fe0471', '19179235-1700-5a99-8988-83e6be67c669', 'Découvre la règle de cette suite : à CHAQUE case, la forme change (carré → cercle → triangle → carré…) ET son remplissage s''inverse (vide ↔ plein). Quelle figure occupe la case « ? » ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3"><rect x="6" y="42" width="16" height="16" fill="#1e293b"/><circle cx="36" cy="50" r="8" fill="none"/><polygon points="58,42 66,58 50,58" fill="#1e293b"/></g><rect x="76" y="40" width="20" height="20" fill="none" stroke="#cbd5e1" stroke-width="2"/><text x="86" y="56" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"18\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"34\" y=\"34\" width=\"32\" height=\"32\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,32 68,68 32,68\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"34\" y=\"34\" width=\"32\" height=\"32\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'd', 'Règle cachée : deux choses changent ensemble à chaque pas — la FORME suit le cycle carré → cercle → triangle → carré, et le REMPLISSAGE alterne vide/plein. Case 1 carré PLEIN, case 2 cercle VIDE, case 3 triangle PLEIN. La case 4 reprend donc la forme carré (le cycle reboucle) et inverse le plein en VIDE : un carré vide. ✓ option d. Piège b : bon carré mais on a gardé le plein au lieu de l''inverser. Piège c : triangle vide — on a oublié que la forme reboucle sur le carré. Piège a : cercle plein — mauvaise forme ET mauvais remplissage.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db5a21f3-d2e4-588f-a529-5727593faf97', '19179235-1700-5a99-8988-83e6be67c669', 'Trois cercles se chevauchent. Règle observée : le symbole placé dans une zone dépend du NOMBRE de cercles qui s''y recouvrent — 1 cercle → trait, 2 cercles → croix, 3 cercles → étoile. Quel symbole doit occuper la zone centrale marquée « ? », commune aux TROIS cercles ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="2"><circle cx="40" cy="42" r="26"/><circle cx="60" cy="42" r="26"/><circle cx="50" cy="60" r="26"/></g><line x1="22" y1="30" x2="30" y2="30" stroke="#1e293b" stroke-width="3"/><g stroke="#1e293b" stroke-width="2"><line x1="67" y1="26" x2="73" y2="32"/><line x1="73" y1="26" x2="67" y2="32"/></g><text x="50" y="50" font-size="12" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"38\" y1=\"38\" x2=\"62\" y2=\"62\" stroke=\"#1e293b\" stroke-width=\"5\"/><line x1=\"62\" y1=\"38\" x2=\"38\" y2=\"62\" stroke=\"#1e293b\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 56,44 72,44 59,54 64,70 50,60 36,70 41,54 28,44 44,44\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"1\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'c', 'Règle cachée : le symbole code le nombre de cercles superposés à cet endroit. La légende le confirme — une zone à 1 cercle porte un trait, une zone à 2 cercles porte une croix. La zone centrale appartient aux TROIS cercles à la fois, donc elle porte l''étoile. ✓ option c (l''étoile). Piège a : le trait vaut pour 1 cercle seulement. Piège b : la croix vaut pour 2 cercles, pas 3. Piège d : le point n''est pas dans le code de la règle (symbole inventé).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5fa052ec-bfbb-5d80-81c6-1fb7b67e9e0c', '19179235-1700-5a99-8988-83e6be67c669', 'Règle inédite à induire : on superpose la grille de gauche et celle du milieu, mais une pastille ne SURVIT que si elle apparaît dans UNE SEULE des deux grilles (si elle est dans les deux, elles s''annulent ; si dans aucune, la case reste vide). Quelle grille est le résultat ? <svg viewBox="0 0 100 100"><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="4" y="36" width="30" height="30"/><line x1="14" y1="36" x2="14" y2="66"/><line x1="24" y1="36" x2="24" y2="66"/><line x1="4" y1="46" x2="34" y2="46"/><line x1="4" y1="56" x2="34" y2="56"/></g><circle cx="9" cy="41" r="3" fill="#1e293b"/><circle cx="29" cy="41" r="3" fill="#1e293b"/><circle cx="19" cy="61" r="3" fill="#1e293b"/><text x="42" y="55" font-size="12" fill="#1e293b">+</text><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="52" y="36" width="30" height="30"/><line x1="62" y1="36" x2="62" y2="66"/><line x1="72" y1="36" x2="72" y2="66"/><line x1="52" y1="46" x2="82" y2="46"/><line x1="52" y1="56" x2="82" y2="56"/></g><circle cx="57" cy="41" r="3" fill="#1e293b"/><circle cx="77" cy="61" r="3" fill="#1e293b"/><circle cx="67" cy="61" r="3" fill="#1e293b"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"67\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"33\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"33\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"50\" cy=\"50\" r=\"4\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'a', 'Règle cachée : c''est un « ou exclusif » (XOR). Une case survit seulement si elle a une pastille dans exactement UNE des deux grilles. Grille 1 = coin haut-gauche, coin haut-droit, centre-bas. Grille 2 = coin haut-gauche, centre-bas, coin bas-droit. Le coin haut-gauche est dans les DEUX → s''annule. Le centre-bas est dans les DEUX → s''annule. Restent : le coin haut-droit (grille 1 seule) et le coin bas-droit (grille 2 seule). Résultat = exactement deux pastilles : haut-droit et bas-droit, et rien d''autre. ✓ option a (haut-droit + bas-droit). Piège b : on a gardé l''INTERSECTION (haut-gauche + centre-bas), c''est-à-dire l''inverse de la règle — on a conservé les cases communes au lieu de les annuler. Piège c : on a fait l''UNION des deux grilles (haut-gauche, haut-droit, centre-bas, bas-droit), sans rien annuler. Piège d : une seule pastille au centre, position inventée hors des deux grilles.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff4cd437-9ac7-576d-8772-b04b2ae481ca', '19179235-1700-5a99-8988-83e6be67c669', 'Suite numérique cachée dans les figures : chaque carré contient un certain nombre de points. Trouve la règle qui lie un terme au suivant, puis donne le nombre de points de la figure « ? ». Les comptes sont 2, 3, 5, 8, puis ?. <svg viewBox="0 0 100 100"><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="3" y="40" width="15" height="15"/><rect x="22" y="40" width="15" height="15"/><rect x="41" y="40" width="15" height="15"/><rect x="60" y="40" width="15" height="15"/><rect x="79" y="40" width="15" height="15"/></g><g fill="#1e293b"><circle cx="8" cy="45" r="2"/><circle cx="13" cy="50" r="2"/><circle cx="27" cy="44" r="2"/><circle cx="32" cy="44" r="2"/><circle cx="29" cy="51" r="2"/><circle cx="45" cy="44" r="2"/><circle cx="51" cy="44" r="2"/><circle cx="45" cy="51" r="2"/><circle cx="51" cy="51" r="2"/><circle cx="48" cy="47" r="2"/><circle cx="63" cy="43" r="2"/><circle cx="68" cy="43" r="2"/><circle cx="72" cy="43" r="2"/><circle cx="63" cy="48" r="2"/><circle cx="68" cy="48" r="2"/><circle cx="72" cy="48" r="2"/><circle cx="65" cy="52" r="2"/><circle cx="70" cy="52" r="2"/></g><text x="86" y="52" font-size="12" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"11"},{"id":"b","text":"13"},{"id":"c","text":"16"},{"id":"d","text":"10"}]'::jsonb, 'b', 'Règle cachée : chaque terme est la SOMME des deux précédents (suite de type Fibonacci), pas un écart constant. 2 ; 3 ; 2+3=5 ; 3+5=8 ; donc le suivant = 5+8 = 13. ✓ option b (13). Piège a (11) : on a additionné un écart constant de +3 (8+3), en confondant avec une suite arithmétique. Piège d (10) : on a fait 8+2 (mauvais couple de termes). Piège c (16) : on a doublé le dernier terme (8×2), règle inventée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efd36aa2-247e-5570-8408-0da5aa5e24f7', '19179235-1700-5a99-8988-83e6be67c669', 'Analogie matricielle : « A est à B ce que C est à ? ». De A à B, DEUX choses se produisent en même temps — la barre tourne d''un quart de tour horaire ET le nombre de points est divisé par deux. Applique exactement la même double transformation à C. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3"><line x1="6" y1="30" x2="30" y2="30"/></g><g fill="#1e293b"><circle cx="10" cy="40" r="2.5"/><circle cx="17" cy="40" r="2.5"/><circle cx="24" cy="40" r="2.5"/><circle cx="13" cy="46" r="2.5"/></g><text x="36" y="40" font-size="10" fill="#1e293b">:</text><g stroke="#1e293b" stroke-width="3"><line x1="48" y1="26" x2="48" y2="50"/></g><g fill="#1e293b"><circle cx="56" cy="34" r="2.5"/><circle cx="56" cy="42" r="2.5"/></g><text x="66" y="40" font-size="10" fill="#1e293b">::</text><g stroke="#1e293b" stroke-width="3"><line x1="74" y1="70" x2="98" y2="70"/></g><g fill="#1e293b"><circle cx="78" cy="80" r="2.5"/><circle cx="84" cy="80" r="2.5"/><circle cx="90" cy="80" r="2.5"/><circle cx="96" cy="80" r="2.5"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"26\" x2=\"50\" y2=\"54\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"62\" cy=\"34\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"46\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"40\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"52\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"26\" x2=\"50\" y2=\"54\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"62\" cy=\"32\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"42\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"44\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'a', 'Règle cachée : deux transformations simultanées. (1) Rotation : la barre tourne d''un quart de tour horaire. (2) Quantité : le nombre de points est divisé par deux. Pour C, la barre est HORIZONTALE ; un quart de tour horaire la rend VERTICALE. Les points passent de 4 à 4÷2 = 2. ✓ option a : barre verticale + 2 points. Piège b : on a oublié de tourner la barre (encore horizontale) tout en divisant bien les points. Piège d : barre non tournée ET on a trop réduit (1 point au lieu de 2). Piège c : barre bien tournée mais on a gardé 4 points (oubli de la division).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee2fecfc-1f60-5ec0-bdfd-79714f694155', '19179235-1700-5a99-8988-83e6be67c669', 'Règle inédite à découvrir : dans chaque figure, le nombre de CÔTÉS de la forme extérieure est toujours égal au nombre de petits points qu''elle contient PLUS un. Une seule option respecte cette règle cachée. Laquelle ? <svg viewBox="0 0 100 100"><polygon points="20,80 50,20 80,80" fill="none" stroke="#1e293b" stroke-width="3"/><circle cx="42" cy="62" r="3" fill="#1e293b"/><circle cx="58" cy="62" r="3" fill="#1e293b"/><text x="50" y="96" font-size="9" text-anchor="middle" fill="#64748b">exemple : 3 côtés, 2 points</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 72,40 64,68 36,68 28,40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"56\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 72,40 64,68 36,68 28,40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"42\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"58\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"42\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"58\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'd', 'Règle cachée : côtés = points + 1 (l''exemple le montre : un triangle a 3 côtés et contient 2 points, et 3 = 2 + 1). On teste chaque option. Option d : carré = 4 côtés, 3 points → 4 = 3 + 1 ✓. Option d respecte la règle. Piège b : carré (4 côtés) avec 2 points → il faudrait 3 points (4 = 2+1 est faux). Piège c : pentagone (5 côtés) avec 3 points → il faudrait 4 points. Piège a : pentagone (5 côtés) avec 1 point → il faudrait 4 points. La clé est de relier deux attributs (côtés et points) par une seule formule, pas de les juger séparément.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f353be52-bb36-5e16-a506-f7170093ee3d', 'adb933d9-88f0-53a4-b29a-327fc08f258f', 'iq-training-fr', 'Échauffement Géométrie & spatial ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('303425b5-f9b6-5865-95d5-94be0091fba0', 'f353be52-bb36-5e16-a506-f7170093ee3d', 'La figure modèle tourne d''un quart de tour (90°) dans le sens des aiguilles d''une montre. Quel dessin obtient-on ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="25" x2="30" y2="70" stroke="#1d4ed8" stroke-width="5"/><line x1="30" y1="70" x2="65" y2="70" stroke="#1d4ed8" stroke-width="5"/><circle cx="30" cy="25" r="6" fill="#1d4ed8"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"75\" y1=\"30\" x2=\"30\" y2=\"30\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"65\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"75\" cy=\"30\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"25\" x2=\"30\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"30\" y1=\"70\" x2=\"65\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"25\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"25\" y1=\"70\" x2=\"70\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"70\" y1=\"70\" x2=\"70\" y2=\"30\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"25\" cy=\"70\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"25\" x2=\"70\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"70\" y1=\"70\" x2=\"35\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"25\" r=\"6\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'a', 'On suit le point repère. Dans le modèle il est en haut, à l''extrémité de la barre verticale. Un quart de tour horaire amène le haut vers la droite : le point part donc en haut à droite et la barre devient horizontale, le coude descend ensuite. ✓ C''est l''option a. L''option b est identique au modèle (aucune rotation). L''option c a tourné dans le sens inverse (anti-horaire). L''option d a la bonne forme mais le point repère est mal placé : la figure a été retournée comme dans un miroir au lieu d''être tournée.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef98f881-32ef-5385-8fe4-0df625779b21', 'f353be52-bb36-5e16-a506-f7170093ee3d', 'Voici un drapeau modèle. Choisis son reflet dans un miroir vertical (gauche-droite). <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="20" x2="30" y2="80" stroke="#0f766e" stroke-width="4"/><polygon points="30,22 62,34 30,46" fill="#0f766e" stroke="#0f766e" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"20\" x2=\"30\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"30,22 62,34 30,46\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"20\" x2=\"70\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"70,22 38,34 70,46\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"20\" x2=\"30\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"30,54 62,66 30,78\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"20\" y1=\"30\" x2=\"80\" y2=\"30\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"22,30 34,62 46,30\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'Un miroir vertical échange la gauche et la droite : le mât reste vertical mais passe à droite, et le fanion qui pointait à droite pointe maintenant à gauche. ✓ C''est l''option b. L''option a est identique au modèle (aucune réflexion). L''option c a glissé le fanion vers le bas du mât : un miroir gauche-droite ne change pas la hauteur. L''option d a fait pivoter tout le drapeau d''un quart de tour : c''est une rotation, pas un reflet.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a21ff23-a882-5380-b5de-a293249a3c2d', 'f353be52-bb36-5e16-a506-f7170093ee3d', 'Cet empilement est fait de cubes identiques (aucun cube caché derrière, l''arrière est plein là où c''est nécessaire pour tenir). Combien de cubes compte-t-il en tout ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g fill="#fde68a" stroke="#b45309" stroke-width="2"><rect x="20" y="66" width="20" height="20"/><rect x="40" y="66" width="20" height="20"/><rect x="60" y="66" width="20" height="20"/><rect x="20" y="46" width="20" height="20"/><rect x="40" y="46" width="20" height="20"/><rect x="20" y="26" width="20" height="20"/></g></svg>', '[{"id":"a","text":"5 cubes"},{"id":"b","text":"7 cubes"},{"id":"c","text":"6 cubes"},{"id":"d","text":"9 cubes"}]'::jsonb, 'c', 'On compte étage par étage. En bas : 3 cubes. Au milieu : 2 cubes. En haut : 1 cube. Total 3 + 2 + 1 = 6 cubes. ✓ C''est l''option c. L''option a (5) oublie un cube, souvent celui du sommet. L''option b (7) en ajoute un de trop. L''option d (9) suppose que chaque étage est complet (3 × 3) alors que la figure montre une pyramide en escalier.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e61a5e49-f5f6-5599-a8c9-484e503f531d', 'f353be52-bb36-5e16-a506-f7170093ee3d', 'Un seul de ces patrons (dessins dépliés) peut se replier pour former un cube fermé à 6 faces. Lequel ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g fill="#ddd6fe" stroke="#6d28d9" stroke-width="2"><rect x="42" y="10" width="16" height="16"/><rect x="42" y="26" width="16" height="16"/><rect x="26" y="42" width="16" height="16"/><rect x="42" y="42" width="16" height="16"/><rect x="58" y="42" width="16" height="16"/><rect x="42" y="58" width="16" height="16"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"18\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"66\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"58\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"26\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"58\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"26\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"42\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"42\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"76\" width=\"16\" height=\"16\"/></g></svg>"}]'::jsonb, 'a', 'Pour faire un cube il faut 6 carrés qui se replient sans qu''aucun ne se superpose. L''option a est la croix classique : une ligne de quatre carrés (les côtés) avec un carré au-dessus et un en-dessous (le dessus et le dessous) — elle se referme parfaitement. ✓ L''option c est un rectangle plein 3 × 2 : en le pliant, des faces se chevauchent et il manque le couvercle. L''option b et l''option d forment, une fois pliées, deux carrés qui tombent au même endroit : le cube reste troué d''un côté et doublé de l''autre.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d49f6ce7-08f7-5961-b3b3-259c8c70219a', 'f353be52-bb36-5e16-a506-f7170093ee3d', 'On veut assembler deux pièces, bord plat contre bord plat, pour reconstituer un rectangle complet. La première pièce est ci-dessous. Quelle pièce la complète exactement ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="25,30 75,30 25,70" fill="#fca5a5" stroke="#b91c1c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"25,30 75,30 75,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"25,40 75,40 50,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"30\" y=\"35\" width=\"40\" height=\"30\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"75,30 75,70 25,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'd', 'La pièce de départ est la moitié haut-gauche d''un rectangle : son hypoténuse (le bord en biais) va du coin haut-droit au coin bas-gauche. Pour reformer le rectangle, il faut le triangle manquant, la moitié bas-droite, dont l''hypoténuse a exactement la même pente et se colle contre elle. ✓ C''est l''option d. L''option a est un triangle dont le biais part dans l''autre sens : posé contre le modèle, il laisse un trou et déborde. L''option b est un triangle isocèle (pointe en bas), sa forme ne complète pas le rectangle. L''option c est déjà un rectangle plein : ajouté, il dépasserait largement du rectangle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23ea3466-d842-56f5-b1ae-a4405e60a901', 'adb933d9-88f0-53a4-b29a-327fc08f258f', 'iq-training-fr', '⭐ Échauffement', 1, 50, 10, 'practice', 'admin', 1)
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
  ('fee1e4b3-8704-5eaf-a8fa-46a47674091b', '23ea3466-d842-56f5-b1ae-a4405e60a901', 'Voici une figure : un drapeau attaché en haut d''un mât, pointant vers la DROITE. Laquelle des options est son image dans un miroir vertical (gauche-droite inversées) ? <svg viewBox="0 0 100 100"><line x1="35" y1="15" x2="35" y2="85" stroke="#222" stroke-width="3"/><polygon points="35,18 70,30 35,42" fill="#222" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"35,58 70,70 35,82\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"35,18 70,30 35,42\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"65\" y1=\"15\" x2=\"65\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"65,18 30,30 65,42\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"65\" y1=\"15\" x2=\"65\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"65,58 30,70 65,82\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'c', 'Un miroir vertical échange la gauche et la droite mais garde le haut en haut. Le mât passe donc à droite et le drapeau, qui pointait à droite, doit pointer à GAUCHE → l''option c ✓. Le piège : b est la figure d''origine inchangée (aucun reflet), a laisse le mât à gauche et descend juste le drapeau (on a confondu miroir vertical et miroir horizontal), et d retourne la figure de haut en bas en plus du côté (double transformation, ce n''est pas un simple miroir gauche-droite).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('608597ec-4264-53a3-8d89-52250bed5a59', '23ea3466-d842-56f5-b1ae-a4405e60a901', 'La même pièce en « L » (4 carrés) tourne d''un quart de tour (90°) dans le sens des aiguilles d''une montre à chaque étape. Voici les orientations 1, 2 et 3. Quelle figure est l''orientation 4 ? <svg viewBox="0 0 100 100"><g fill="#222" stroke="#fff" stroke-width="1"><rect x="8" y="24" width="9" height="9"/><rect x="8" y="33" width="9" height="9"/><rect x="8" y="42" width="9" height="9"/><rect x="17" y="42" width="9" height="9"/><rect x="40" y="33" width="9" height="9"/><rect x="40" y="42" width="9" height="9"/><rect x="49" y="33" width="9" height="9"/><rect x="58" y="33" width="9" height="9"/><rect x="76" y="24" width="9" height="9"/><rect x="85" y="24" width="9" height="9"/><rect x="85" y="33" width="9" height="9"/><rect x="85" y="42" width="9" height="9"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"32\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"32\" y=\"23\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"23\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"41\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"59\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"50\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"50\" width=\"18\" height=\"18\"/></g></svg>"}]'::jsonb, 'd', 'La pièce est toujours le même « L » de 4 carrés ; on la fait tourner d''un quart de tour horaire. L''orientation 3 a la barre verticale à droite avec la patte en haut à gauche ; un quart de tour horaire de plus amène la barre à l''horizontale en bas avec la patte qui remonte à droite → l''option d ✓. Le piège : a est l''orientation 2 (un quart de tour en arrière), b répète l''orientation 3 (on a oublié de tourner), et c est le « L » retourné comme dans un miroir (mauvais sens / pièce inversée), ce qui n''arrive jamais par simple rotation. On garde les 4 carrés et on tourne d''un seul quart de tour horaire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5297849f-048a-5a12-ac0c-ff0973ad05f2', '23ea3466-d842-56f5-b1ae-a4405e60a901', 'Cet empilement de cubes identiques est posé en escalier. Combien de cubes compte-t-il en tout (aucun cube caché derrière) ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="2"><rect x="20" y="60" width="20" height="20"/><rect x="40" y="60" width="20" height="20"/><rect x="60" y="60" width="20" height="20"/><rect x="40" y="40" width="20" height="20"/><rect x="60" y="40" width="20" height="20"/><rect x="60" y="20" width="20" height="20"/></g></svg>', '[{"id":"a","text":"5 cubes"},{"id":"b","text":"6 cubes"},{"id":"c","text":"7 cubes"},{"id":"d","text":"9 cubes"}]'::jsonb, 'b', 'On compte les carrés visibles, qui sont tous des cubes (rien n''est caché) : la rangée du bas en a 3, celle du milieu 2 et celle du haut 1, soit 3 + 2 + 1 = 6 cubes → l''option b ✓. Le piège : a (5) oublie un cube d''une rangée, c (7) en compte un de trop, et d (9) suppose un carré complet 3×3 alors que l''escalier laisse des trous. On additionne seulement les cubes réellement dessinés.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('565900ab-031a-5f4e-b059-0b678eb4e23f', '23ea3466-d842-56f5-b1ae-a4405e60a901', 'On plie ce patron de cube (croix latine, 6 carrés) pour former un cube. Le patron porte un disque NOIR sur le bras de GAUCHE et un disque BLANC (vide) sur le bras de DROITE. Quelle paire de motifs se retrouve sur deux faces OPPOSÉES du cube une fois plié ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="2"><rect x="40" y="10" width="20" height="20"/><rect x="20" y="30" width="20" height="20"/><rect x="40" y="30" width="20" height="20"/><rect x="60" y="30" width="20" height="20"/><rect x="40" y="50" width="20" height="20"/><rect x="40" y="70" width="20" height="20"/></g><circle cx="30" cy="40" r="6" fill="#222"/><circle cx="70" cy="40" r="6" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'Dans une croix latine, les deux bras latéraux (gauche et droite) sont les deux rabats opposés : une fois pliés, ils deviennent deux faces OPPOSÉES du cube. Le disque noir (bras gauche) se retrouve donc opposé au disque blanc (bras droit) → l''option a ✓. Le piège : b montre deux disques noirs et c deux disques blancs (or les deux motifs sont différents : un plein et un vide), et d remplace le disque blanc par un carré, motif qui n''existe nulle part sur le patron. Les deux bras opposés d''une croix tombent toujours sur des faces opposées.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ddf595d-ac66-5b18-a31f-54ada726cf40', '23ea3466-d842-56f5-b1ae-a4405e60a901', 'On superpose ces deux formes transparentes en gardant leur position exacte (un grand triangle et un petit carré). Quelle figure obtient-on en les empilant l''une sur l''autre ? <svg viewBox="0 0 100 100"><polygon points="20,20 45,20 32,42" fill="none" stroke="#222" stroke-width="2"/><rect x="60" y="60" width="22" height="22" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"71\" cy=\"71\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"60\" y=\"60\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,60 85,60 72,82\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"20\" y=\"20\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'c', 'Superposer en gardant la position exacte signifie que chaque forme reste là où elle était : le triangle reste en haut à gauche et le carré reste en bas à droite, et les deux apparaissent ensemble → l''option c ✓. Le piège : b transforme le carré en cercle (on n''a pas le droit de changer une forme), a fait disparaître le carré (on a oublié une forme), et d échange les positions des deux formes (or la superposition garde les emplacements). On garde les deux formes, à leur place.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4f74323-13b3-5d9d-b6c1-2c0d01ec94ad', '23ea3466-d842-56f5-b1ae-a4405e60a901', 'La lettre majuscule « F » est placée à l''endroit. Laquelle des options est son reflet dans un miroir vertical (gauche-droite inversées) ? <svg viewBox="0 0 100 100"><polygon points="40,15 70,15 70,25 50,25 50,45 65,45 65,55 50,55 50,85 40,85" fill="#222"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,15 70,15 70,25 50,25 50,45 65,45 65,55 30,55 30,85 40,85 40,55 30,55\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,15 70,15 70,25 50,25 50,45 65,45 65,55 50,55 50,85 40,85\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,85 70,85 70,75 50,75 50,55 65,55 65,45 50,45 50,15 40,15\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,15 30,15 30,25 50,25 50,45 35,45 35,55 50,55 50,85 60,85\" fill=\"#222\"/></svg>"}]'::jsonb, 'd', 'Un miroir vertical inverse la gauche et la droite sans toucher au haut/bas : la barre verticale du « F » passe à droite et ses deux branches partent désormais vers la gauche → l''option d ✓. Le piège : b est le « F » d''origine inchangé (aucun reflet), c retourne la lettre de haut en bas (les branches partent du bas, c''est un miroir horizontal et non vertical), et a est une forme déformée qui n''est pas un « F » miroir. Dans un miroir vertical, seule la gauche et la droite s''échangent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('48101a8d-21de-5112-ac69-7be864c6022f', 'adb933d9-88f0-53a4-b29a-327fc08f258f', 'iq-training-fr', '⚔️ Défi Géométrie & spatial ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('83470144-da33-53e8-bd39-6e8a61fb1c9f', '48101a8d-21de-5112-ac69-7be864c6022f', 'Cette équerre porte un petit point repère noir au bout de sa branche horizontale. La figure tourne d''un quart de tour (90°) dans le sens des aiguilles d''une montre. Quel dessin obtient-on ? <svg viewBox="0 0 100 100"><polyline points="30,30 30,70 70,70" fill="none" stroke="#1f2937" stroke-width="5"/><circle cx="70" cy="70" r="6" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,30 30,30 30,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,30 30,70 70,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,30 30,30 30,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"30\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,70 70,70 70,30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'Règle : +90° dans le sens horaire. On suit le point repère, placé au bout de la branche horizontale, en bas à droite. Un quart de tour horaire envoie le bas vers la gauche : le point passe donc en bas à gauche, l''angle droit monte en haut à gauche et la branche se redresse vers le haut → l''option a ✓. Le piège : b est le modèle inchangé (aucune rotation), c a la bonne forme d''équerre mais place le point en haut à droite — c''est un reflet miroir, pas une rotation —, et d a tourné dans le sens inverse (anti-horaire). Tourne d''un seul quart de tour dans le bon sens et suis le repère.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('274920e6-a512-52cc-aeaf-e659b931388d', '48101a8d-21de-5112-ac69-7be864c6022f', 'La lettre majuscule « R » est à l''endroit. Laquelle des options est son reflet dans un miroir vertical (gauche et droite inversées, le haut reste en haut) ? <svg viewBox="0 0 100 100"><polyline points="38,15 38,85" fill="none" stroke="#1f2937" stroke-width="5"/><path d="M38,15 H62 Q72,15 72,30 Q72,45 62,45 H38" fill="none" stroke="#1f2937" stroke-width="5"/><polyline points="50,45 70,85" fill="none" stroke="#1f2937" stroke-width="5"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,15 62,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M62,15 H38 Q28,15 28,30 Q28,45 38,45 H62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,45 30,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,15 38,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M38,15 H62 Q72,15 72,30 Q72,45 62,45 H38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,45 70,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,15 38,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M38,85 H62 Q72,85 72,70 Q72,55 62,55 H38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,55 70,15\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,15 62,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M62,85 H38 Q28,85 28,70 Q28,55 38,55 H62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,55 30,15\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'a', 'Un miroir vertical échange la gauche et la droite sans toucher au haut/bas. La barre verticale du « R » passe à droite, la boucle s''ouvre vers la gauche et la jambe oblique part vers le bas à gauche → l''option a ✓. Le piège : b est le « R » d''origine inchangé (aucun reflet), c retourne la lettre de haut en bas (boucle en bas, jambe vers le haut : c''est un miroir horizontal, pas vertical), et d combine les deux retournements (gauche-droite ET haut-bas), ce qui revient à une rotation de 180° et non à un simple miroir vertical. Seules la gauche et la droite s''échangent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e11c6bde-bb88-5069-8fa9-1d1fb87f98b1', '48101a8d-21de-5112-ac69-7be864c6022f', 'Cet empilement est fait de cubes identiques. Chaque cube visible repose sur un sol ou sur un autre cube, et rien n''est caché derrière la pile. Combien de cubes compte-t-il en tout ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1f2937" stroke-width="2"><rect x="15" y="65" width="18" height="18"/><rect x="33" y="65" width="18" height="18"/><rect x="51" y="65" width="18" height="18"/><rect x="69" y="65" width="18" height="18"/><rect x="15" y="47" width="18" height="18"/><rect x="33" y="47" width="18" height="18"/><rect x="51" y="47" width="18" height="18"/><rect x="15" y="29" width="18" height="18"/><rect x="33" y="29" width="18" height="18"/><rect x="15" y="11" width="18" height="18"/></g></svg>', '[{"id":"a","text":"9 cubes"},{"id":"b","text":"10 cubes"},{"id":"c","text":"12 cubes"},{"id":"d","text":"16 cubes"}]'::jsonb, 'b', 'On additionne les cubes étage par étage, en ne comptant que ceux qui sont dessinés. En bas : 4 cubes. Au-dessus : 3. Puis : 2. Au sommet : 1. Total 4 + 3 + 2 + 1 = 10 cubes → l''option b ✓. Le piège : a (9) oublie un cube d''un étage, c (12) compte 4 + 4 + 2 + 2 en supposant des étages plus pleins qu''ils ne sont, et d (16) suppose un carré complet 4×4 alors que la figure est un escalier troué. On compte exactement les carrés présents.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3b10f5f-184c-544b-9921-5c83880be1d9', '48101a8d-21de-5112-ac69-7be864c6022f', 'Une seule de ces quatre figures possède un axe de symétrie VERTICAL : on pourrait la plier le long d''une ligne verticale et les deux moitiés se superposeraient exactement. Laquelle ?', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,15 20,80 80,80\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"50\" y1=\"15\" x2=\"50\" y2=\"80\" stroke=\"#1f2937\" stroke-width=\"2\" stroke-dasharray=\"3 3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"25,20 75,20 60,80 40,80\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><polygon points=\"55,30 75,45 60,60\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"22\" y=\"35\" width=\"56\" height=\"30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"38\" cy=\"50\" r=\"8\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,25 55,25 70,50 55,75 30,75 45,50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'Un axe vertical de symétrie veut dire que la moitié gauche est l''image miroir exacte de la moitié droite. Le triangle isocèle de a a sa pointe pile au-dessus du milieu de sa base : la verticale qui passe par le sommet partage la figure en deux moitiés identiques → l''option a ✓. Le piège : b est presque symétrique mais la petite flèche pleine n''est dessinée qu''à droite, ce qui casse l''équilibre gauche-droite ; c a son disque décalé vers la gauche, donc la moitié droite est vide ; d se replierait correctement sur une ligne HORIZONTALE (haut = bas) mais pas sur une verticale (les pointes sont à gauche et à droite de façon décalée). Vérifie toujours que c''est bien l''axe demandé.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87363596-5cff-584d-b3c0-01d1ec6e8027', '48101a8d-21de-5112-ac69-7be864c6022f', 'Un seul de ces patrons dépliés (6 carrés) peut se replier pour former un cube fermé à 6 faces, sans qu''aucun carré ne se chevauche ni qu''une face manque. Lequel ?', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"42\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"60\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"26\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"44\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"34\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"76\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"42\" y=\"4\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"20\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"36\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"52\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"68\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"84\" width=\"16\" height=\"16\"/></g></svg>"}]'::jsonb, 'a', 'Il faut 6 carrés qui, repliés, donnent les 6 faces sans recouvrement. L''option a est la croix classique : une colonne de quatre carrés (les quatre côtés) avec un carré ajouté à gauche et un à droite du deuxième carré (le dessus et le dessous) ; elle se referme parfaitement → l''option a ✓. Le piège : b est un bloc plein 3×2 — en le pliant, des carrés se superposent et il manque une face ; c forme, après pliage, deux carrés qui retombent sur la même face, laissant le cube troué ; d est une colonne de six carrés (1×6) : enroulée, elle fait un anneau de faces et il manque le dessus et le dessous. Seule une disposition « croix/T » sans empilement marche.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b32563f-37c4-53ed-85a3-28354bd693ee', '48101a8d-21de-5112-ac69-7be864c6022f', 'On superpose ces deux calques transparents en gardant leurs positions exactes : à gauche un calque avec UNIQUEMENT la diagonale « \ » d''un même carré, à droite un calque avec UNIQUEMENT la diagonale « / » du même carré. Quelle figure obtient-on en empilant les deux calques ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1f2937" stroke-width="2"><rect x="8" y="35" width="30" height="30"/><line x1="8" y1="35" x2="38" y2="65"/><rect x="58" y="35" width="30" height="30"/><line x1="88" y1="35" x2="58" y2="65"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\"/><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/></g></svg>"}]'::jsonb, 'a', 'Superposer conserve tout ce que porte chaque calque et n''ajoute rien d''autre. On garde donc le contour du carré, plus les deux diagonales « \ » et « / », qui se croisent au centre et forment un X → l''option a ✓. Le piège : b n''a gardé qu''une seule diagonale (on a oublié un calque), c a remplacé les diagonales par une croix droite horizontale + verticale (mauvaises lignes : la superposition ne fait pas pivoter les traits), et d ajoute une ligne horizontale qui n''existe sur aucun des deux calques (on n''invente jamais de trait en superposant). On réunit exactement les traits des deux calques, rien de plus.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('699e982a-3b41-56cd-9627-831411a911e4', 'adb933d9-88f0-53a4-b29a-327fc08f258f', 'iq-training-fr', '👑 Élite Géométrie & spatial ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('64593c62-8e39-5df5-902f-903f13591b80', '699e982a-3b41-56cd-9627-831411a911e4', 'La figure modèle (un « L » avec une boule rouge au bout de la barre verticale) tourne d''un quart de tour (90°) dans le sens INVERSE des aiguilles d''une montre (anti-horaire). Quelle option montre le résultat ? <svg viewBox="0 0 100 100"><polyline points="30,20 30,75 75,75" fill="none" stroke="#1e293b" stroke-width="6"/><circle cx="30" cy="20" r="7" fill="#ef4444" stroke="#1e293b" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"20,70 75,70 75,25\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"20\" cy=\"70\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"80,30 25,30 25,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"80\" cy=\"30\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,20 30,75 75,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"20,30 75,30 75,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"20\" cy=\"30\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'Règle cachée : un quart de tour anti-horaire (sens inverse des aiguilles) envoie le HAUT vers la GAUCHE et le BAS vers la droite. Dans le modèle, la boule est tout en haut et l''angle du « L » est en bas à gauche ; après rotation anti-horaire, la boule descend vers la GAUCHE (en bas à gauche, au bout d''une barre horizontale) et l''angle remonte à droite. ✓ option a (boule à gauche en bas, barre horizontale vers un coin à droite, puis montée). Piège b : c''est la rotation HORAIRE (sens des aiguilles) — la boule est partie vers la DROITE (en haut à droite), donc le mauvais sens. Piège c : c''est la figure de départ, aucune rotation. Piège d : la forme est bien tournée mais la boule est du mauvais côté — c''est un reflet miroir, pas une rotation.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53b6fd10-5c43-5ef2-9bdb-62f66a485484', '699e982a-3b41-56cd-9627-831411a911e4', 'Voici un drapeau modèle : un mât à gauche, avec un fanion qui pointe vers la droite dans la moitié SUPÉRIEURE du mât. Quelle option est son image par RÉFLEXION dans un miroir HORIZONTAL (axe horizontal, le haut et le bas s''échangent) ? <svg viewBox="0 0 100 100"><line x1="25" y1="15" x2="25" y2="85" stroke="#0f766e" stroke-width="4"/><polygon points="25,20 60,30 25,40" fill="#0f766e" stroke="#0f766e" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"15\" x2=\"25\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"25,60 60,70 25,80\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"15\" x2=\"25\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"25,20 60,30 25,40\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"15\" x2=\"75\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"75,60 40,70 75,80\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"15\" x2=\"75\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"75,20 40,30 75,40\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'Règle cachée : un miroir horizontal échange le HAUT et le BAS mais laisse la gauche et la droite inchangées. Le mât reste donc à gauche, et le fanion qui était en haut descend dans la moitié INFÉRIEURE tout en continuant de pointer vers la droite. ✓ option a. Piège b : c''est le modèle inchangé (aucune réflexion). Piège d : le mât est passé à droite et le fanion pointe à gauche — c''est un miroir VERTICAL (gauche-droite), pas horizontal. Piège c : on a appliqué les DEUX miroirs à la fois (équivalent à une rotation de 180°), le mât à droite ET le fanion en bas.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55329ae2-d749-5fdf-a7b5-6bf17906bf3e', '699e982a-3b41-56cd-9627-831411a911e4', 'Cet escalier est entièrement dessiné : tous les cubes identiques sont visibles, aucun n''est caché. Combien de cubes y a-t-il en tout ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="#cbd5e1"><rect x="20" y="66" width="18" height="18"/><rect x="38" y="66" width="18" height="18"/><rect x="56" y="66" width="18" height="18"/><rect x="20" y="48" width="18" height="18"/><rect x="38" y="48" width="18" height="18"/><rect x="20" y="30" width="18" height="18"/></g></svg>', '[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"7"}]'::jsonb, 'c', 'Règle : tous les cubes sont visibles, il suffit de les compter rangée par rangée, sans rien supposer de caché. Rangée du bas : 3 cubes. Rangée du milieu : 2 cubes. Sommet : 1 cube. 3 + 2 + 1 = 6. ✓ option c. Piège a (4) : on a oublié une rangée entière. Piège b (5) : on a compté une rangée du milieu d''un seul cube au lieu de deux. Piège d (7) : on a ajouté un cube caché, alors que l''énoncé précise qu''aucun cube n''est caché.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('191c14f4-52a1-5f51-b6e0-32bb782f157b', '699e982a-3b41-56cd-9627-831411a911e4', 'Un seul de ces patrons (dépliés) se replie en un CUBE fermé, sans face manquante ni face qui se superpose. Lequel ? <svg viewBox="0 0 100 100"><text x="50" y="46" font-size="11" text-anchor="middle" fill="#1e293b">6 carrés = patron du cube.</text><text x="50" y="62" font-size="11" text-anchor="middle" fill="#1e293b">Lequel se replie sans faute ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"20\" y=\"20\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"20\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"38\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"38\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"56\" width=\"18\" height=\"18\"/><rect x=\"74\" y=\"56\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"20\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"74\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"20\" y=\"28\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"28\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"32\" y=\"24\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"24\" width=\"18\" height=\"18\"/><rect x=\"32\" y=\"42\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"42\" width=\"18\" height=\"18\"/><rect x=\"32\" y=\"60\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"60\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"24\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"42\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"24\" y=\"52\" width=\"18\" height=\"18\"/><rect x=\"42\" y=\"52\" width=\"18\" height=\"18\"/><rect x=\"60\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"78\" y=\"34\" width=\"18\" height=\"18\"/></g></svg>"}]'::jsonb, 'a', 'Règle : un patron du cube valide a 6 carrés tels qu''au pliage aucun ne se superpose et chaque face est unique. L''option a est l''escalier classique en « zigzag » (forme en marches d''escalier 2-2-2 décalées) : c''est l''un des onze patrons valides du cube, il se referme parfaitement. ✓ option a. Piège b : c''est une ligne de QUATRE carrés avec deux carrés ajoutés du MÊME côté (au-dessus des deux premiers) ; au pliage ces deux-là retombent sur la même face et une face reste manquante. Piège c : c''est un rectangle plein 2×3 ; replié, deux faces se chevauchent et il manque un couvercle. Piège d : c''est un bloc carré 2×2 prolongé d''un bras de deux carrés ; le bloc 2×2 fait déjà se rencontrer plusieurs faces au même endroit, les carrés se superposent.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa6b2b81-2957-5975-b5f3-ad586ddf9103', '699e982a-3b41-56cd-9627-831411a911e4', 'On superpose EXACTEMENT les deux figures de gauche (même centre), tous les traits sont conservés. Quelle option montre le résultat ? À gauche : un triangle pointe en haut ; à droite : un triangle pointe en bas (de même taille). <svg viewBox="0 0 100 100"><polygon points="22,58 46,58 34,30" fill="none" stroke="#1e293b" stroke-width="4"/><text x="55" y="50" font-size="16" text-anchor="middle" fill="#1e293b">+</text><polygon points="66,30 90,30 78,58" fill="none" stroke="#1e293b" stroke-width="4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><polygon points=\"28,38 72,38 50,76\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"34\" width=\"40\" height=\"36\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><polygon points=\"36,52 64,52 50,72\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'a', 'Règle : la superposition garde TOUS les traits des deux figures, sans rien transformer ni effacer. Un triangle vers le haut empilé sur un triangle vers le bas de même taille et même centre donne l''étoile à six branches (le symbole « étoile de David »), où les deux triangles se croisent. ✓ option a. Piège b : c''est le triangle vers le haut seul, on a perdu le second. Piège c : on a remplacé les deux triangles par un carré — la superposition ne crée jamais une forme nouvelle. Piège d : le second triangle est trop petit et niché à l''intérieur ; or les deux triangles ont la MÊME taille et doivent se chevaucher en étoile.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4485726a-f925-57de-bdba-5de9dac1af8b', '699e982a-3b41-56cd-9627-831411a911e4', 'Combien d''AXES de symétrie possède cette figure ? (Un axe de symétrie est une droite telle que la figure se superpose à elle-même par pliage le long de cette droite.) <svg viewBox="0 0 100 100"><rect x="28" y="28" width="44" height="44" fill="none" stroke="#1e293b" stroke-width="4"/></svg>', '[{"id":"a","text":"1 axe"},{"id":"b","text":"2 axes"},{"id":"c","text":"4 axes"},{"id":"d","text":"Une infinité d''axes"}]'::jsonb, 'c', 'Règle : on cherche toutes les droites de pliage qui laissent la figure inchangée. Le carré en a exactement 4 : l''axe vertical (milieu des côtés gauche/droite), l''axe horizontal (milieu des côtés haut/bas) et les 2 diagonales. ✓ option c (4 axes). Piège a (1) : c''est le nombre d''axes d''une figure presque symétrique comme un cœur ou un trapèze isocèle, pas un carré. Piège b (2) : c''est le cas d''un rectangle non carré (seulement les médianes, pas les diagonales) — on a oublié que dans un carré les diagonales aussi sont des axes. Piège d (infinité) : c''est la propriété du CERCLE, où toute droite passant par le centre est un axe ; un carré, lui, n''en a que 4.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

