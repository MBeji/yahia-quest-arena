-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: sciences-physiques-7eme (العلوم الفيزيائية)
-- Regenerate with: npm run content:build
-- Source of truth: content/sciences-physiques-7eme/
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
  ('sciences-physiques-7eme', 'العلوم الفيزيائية', 'المادة والماء والمزائج والهواء والدارة الكهربائية وفق برنامج السنة السابعة من التعليم الأساسي', 'Observation', 'subject-svt', 'Atom', 4, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '7eme-base'))
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
      AND e.subject_id = 'sciences-physiques-7eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('82b7df52-1245-54ca-bcd5-bf52b5155411', '60f03e17-5782-5aa7-97b3-bd4e1823608f', '0bc8a57d-0d32-5d39-8fa5-a0a2c4f59ae1', 'c75d1d3d-fa3e-50f1-9509-85bb645e7f0a', 'd9a446fa-0386-5031-8a07-c10479842f2a', '7d749e40-b404-5cde-9c95-9fbaa75de700', '98c34492-bd01-53ad-91e6-504ae6570965', '33cdf4b2-bb86-595c-9647-ba27d8741350', '796f552c-cacb-5b2a-8985-69420ddc9ad5', 'b13d0d45-47d1-5936-9017-172f1d71a932', '67409778-b9fe-54c5-806e-0b6ffaa35065', '7481f802-4215-5af8-9cb9-ed5071d327d1', '405f3247-2231-55e5-a894-5c143d7bf0f7', '298599fe-93d7-5a9f-b34f-73a5ec9e0608', '2b3be3b8-7ff0-5210-8f08-36c243d84962', '6b4e1d17-d431-5ba2-83ea-937423614f37', 'd07ab397-eb75-5f71-927c-9293dd65030a', '6008464f-aaed-50a4-b4cc-4e2372ce129d', 'e9a922d8-b494-575d-b36c-b3c716c3e8f3', '76f5132d-be87-5d88-8bcf-f68653560d2f', '3205c4c2-3119-5318-8940-ec870ab7d09a', 'bbb50eeb-56c9-5b13-9a59-e8987104fef8', '2b4f8eed-274f-5202-9b10-3b0d3af7e65e', '669c7ba8-33af-5258-b230-1c5cf112e1f4', 'b49ed5e3-85ae-55cb-96e3-dd00924378e4', '0b659695-448c-5a99-a213-b1ffbd795889', 'e2ef1aab-9d08-5654-a35c-e76015c3a03e', 'eedcda4a-0f04-5bb7-bab5-6a73821b3065', 'd6bbf62d-08bd-5ac0-80db-8681ec4a6cd3', 'ad585e38-d99e-5a20-a59e-d96d7b73445a', '533ecb22-6ab8-50c6-8d42-57650f9a6e4b', '9c27a001-510d-5dd1-8d97-103746a26879', '474563d6-55ba-5b2f-8825-fc7c80d86a9f', 'c064a4e5-d150-5ebc-8b8d-c0ffc5c5392b', '60dd8a7c-d5c6-5fa1-a5ba-0e5ae71ccc1f', '69d1aa5d-e183-571d-917c-4ddd20901572', 'ebb0638f-994b-5a1d-93e3-239a884dd18a', '2225be3e-23e5-586d-81ee-1eef8df2a889', '0823939e-89fe-5850-817d-b266c3182623', '9ec01da9-5d16-5e28-b314-6d3636665369', 'f7d0e24c-b136-5338-958d-ddf42845463d', 'ecea9b6a-53ef-5a7b-abdf-452093e0f3a8', '22a0d754-42ac-5cc0-aa5e-0d22662b8fda', '5e10ee26-e748-5abd-8bfb-1c7c04fb0f65', 'f3173d1d-e5d4-5ec0-adb1-c93ba26576e5', '974d16e7-bf74-536a-ae47-d049cb1cc838', '4dc6c291-40a4-5a30-96b7-14b5478da87d', '925db6f1-5a8a-5b9a-8688-383740672c9f', 'd17f3f6a-1e5d-56cd-a33b-9df021d98b18', 'b86bc9f8-63c7-57de-92ef-d8c6c021e70e', 'defd10c3-963d-5ffd-90a2-82ee0ab5254e', '844b3ba2-3331-5552-b055-3255bfdc8e44', 'f842969c-f85f-5472-a913-56852f33420f', '1dcf3c02-0b22-5ba3-8658-a6f8b1c7fb72', '4186b6ca-f45a-5d6c-bad8-92e3369383ec', '815cc6ce-25e9-55d6-8e34-66504551bbbe', '23259b60-f2cf-56c4-a903-c1480f16bf36', '57f6636e-4a97-58cd-9d72-444d405936bf', 'cb5a82d3-a121-5f3a-8b10-780db7b8c06b', 'fc6ab36d-3eeb-55bb-a35a-1ef91aa8a162', '46d5f00b-6e7d-549b-810a-601fb002d6fe', '9ef8e270-c634-5eba-a318-a5b689e7df9a', '9a9396fd-2410-57f3-b569-613ae181478d', '9062b7f0-13d6-5b16-beea-c9262cc5795f', '4c6c373b-d442-50b9-b679-071f9e56e49e', '01a1e740-4bef-5d32-b06c-bcbc20a6cfa0', 'cd50daac-83e8-53ac-9011-62f3f059d4d8', 'df9e1edc-8b27-5cda-93fc-6d57785afd1f', 'a4f4f840-e61c-51d1-80e4-0f90873afc33', '122bf5d3-a0f4-54d2-a906-3fb9251871eb', 'bf8c428e-be06-5cf6-8360-fd00367b72ee', '8167e9a3-1930-5cb2-b3cd-939d5d7989e8', 'a315daa6-fc16-5a0e-b5db-6d6a008be0ed', '6badfdc6-9f66-56bc-aecd-5037ad7d7ab7', '2cb8a402-6b4a-527e-b678-d919f7d2e0e9', '09ecb2a5-8932-5c15-a693-e2a954419b52', '85ae1b2c-3898-5280-8ddc-157e7bfa2682', 'b83d1bb5-f2cc-5b9f-9dbb-4835502484a2', 'e5bc97df-3cd5-5545-be6f-7c55a7e41bfa', 'ffe23998-3133-5e37-a809-a97a6993e6cd', '4caf26d3-f664-5659-a4ba-f4af0f648f92', 'f2b74846-80c5-5a34-be33-14d9f265c0b8', '2369f0fe-e368-5a19-b41b-ded487837b7a', '03c1d873-afa8-53c5-aba6-c28ad92e6ef0', '6e2cfc67-c5d7-514f-b976-5b45ac16642d', 'bbd7ef37-972c-53d1-bd9c-fd87f177ae3d', '6cbb34f6-cc20-576b-9f28-e93609c34471', '67e73fe3-4e0b-5e21-8f13-f6f73fbe46cc', 'c444ed4d-14e6-5978-b7d9-78597306c22c', '54b59a0a-a7ca-5f05-85d9-ecb769d74c12', '55026300-a1af-514b-aa51-559a6f5505ea', 'e4cc086f-bb3a-5000-aba7-2a4f0bbad3fd', 'ad27127b-8780-5782-9960-6fe2a6f05b8d', 'dcbab84c-c753-5659-96a5-082e9a9264c0', 'f240d1f4-dfc3-5929-8b4d-a9ace963e51d', '25260bc3-452b-5671-891a-584628adfa7a', '67000247-5888-5088-a511-4735b195eac4', '9bc1e3a1-cd05-5895-8bf2-713c6653ca92', '7531b393-1b2f-5d71-b3d7-9feca47f18bd', '2179f3d9-856b-5471-aae4-7b71df3a4e22', 'abb64175-3aa2-5c99-a950-f0c2317a3b58', '513b7323-1c09-5739-a48b-1443021e1918', '963c100b-72f3-5e40-9de5-4f5bdd927162', 'f9ead32d-64f9-5d40-bb1c-2eb3419579f5', '0a99d0d8-0e25-57fe-bc82-544480134c6f', '239d06ca-5e6f-556f-821d-95608cdfdb2f', '074fcd3c-d410-528e-81ef-3631248cf8f4', '86929362-93eb-5de6-89f3-4f77a33ea5c6', '6c7aab3b-6374-50f7-8139-38738c22973d', '17571ce9-b248-5834-94e7-a7cb91f85f8d', '3309f98b-d3e6-5bff-9835-1b1027f1eab0', 'ca119b79-766a-5b6a-8734-46505c011a81', 'a6a26794-72e9-5714-8cd7-d07a8ce02bcc', '32b5b63b-2845-5907-91a4-09eaca6a4453', 'cb28e965-297e-5019-a71a-5553a723d607', 'e75d4143-5af7-5b38-b98b-114602346d04', '7081d8b2-d46b-538c-86ff-26061952c470', '5395abad-43a2-523e-aec0-e574f3cd2cf1', '42f8eb4d-9b46-535e-abe4-906819676337', 'fc863b54-e518-5aeb-b344-cbb1ffcccf51', 'f8eefa7d-1b64-59f8-b14f-b7f093f388b8', 'a6916b79-311e-5e47-8e25-d25c02b96252', '1bd022d3-5a95-5cb0-9f3a-6cb397a24e01', 'e84af202-879a-5dba-9878-bfec67588ff7', '10a4b814-1b0a-5c74-80a7-b39652443726', '0df5716e-4ee0-5489-b0b1-5f64f174e845', '4589783d-01e3-5a2a-87f9-8083ca1d3756', 'f716718e-4332-507d-8e60-f5094dcd0286', 'da845378-3281-504d-bd19-982e3a1a1e76', '7071a6a1-e36d-5351-bfad-7d4c84890853', '764dc957-372f-5b11-a52a-f2d1a40d0060', '965783e0-4c50-5c51-9b8a-aa7aed77d53e', 'd292f93f-e642-5502-97b3-530bae391339', '3bcc87a6-8c8e-5f29-a8cb-bbc5cb503760', '77ae493e-288c-5185-ba93-e0b8c8299d3e', 'cdca1bec-3a7a-5f04-b823-cdb522949089', 'bae9f5d0-05fa-5cb4-af59-5bbc252da60e', '0e573e90-016b-526f-8d60-221510ac592e', '7cefe44d-e21d-558a-9c02-a829d053150b', '171acff5-f5ec-5a19-91c7-ec375e4c5e8c', '875fcb04-6c65-5c5e-84a6-f08efa922043', '4565a6d0-57fb-55e0-983b-2d19ee1ebd71', 'adda0393-0d0f-5e0f-99a7-a150b4cbae05', 'cdc90f4e-6f8d-5020-8b65-fc5308e33c87', '28828828-e727-5ea4-a0df-98591105773a', '354627b4-4b60-5958-948d-f870f30ae9c5', '1fdaf8dd-6a91-5888-85c5-9c5582f46d00', 'c0c9b423-b23c-5149-a506-e655a6dc9dd0', '91437c9a-44f6-5568-86ef-b81735e2e87f', '32df9a13-3242-5e26-b3a6-1b8cb5171fec', '07c06b8b-8a69-54ed-8dd3-5282ae623644', '71720a68-6c94-573f-9a7b-9a59094f79c7', '4b4a9bf8-e61f-5e12-a6b5-898d05c589f5', '9f144491-734d-5e14-ac0b-62eabaf23bf7', '42318272-57b9-5532-99ea-16260f92f84d', '64f019df-b76d-58e6-adf5-0e5dbc5a601e', 'f0bc2eb7-5bac-5de0-b548-906e3313f1ef', '05861724-7b4f-5951-b113-3fa4bad3e5c2', '0510a07c-bcc5-59e2-91a7-88664c6cce3c', '2dad25f6-afe9-5231-b361-81e656c05f46', 'b6252f04-7cb0-5d99-a5b0-a6d494e7d198', 'a30b12af-4f88-58d1-b22d-606ed1ae2fc2', '6a2344fb-35a2-55ec-bf54-567ee7f6f227', 'c91ac873-e0c2-549b-be10-1a207dc29cc1', '956e726a-ea4f-5467-96b9-785470fced9f', '5f23d204-b313-5dcb-97ed-a75dde041ac8', '7b796e16-be4d-5646-ba95-4eb01601debb', '6ef53671-2e1b-58d0-a7c8-1e6f20f7f40b', 'b540dacf-4370-57d9-ba22-e7613dcdf899', '6c0db2e4-d2d6-5e9d-ac82-6b2ac1890010', 'd672380f-4f0b-51aa-af47-cd74a8700e03', '4cd7b31a-fc4f-507f-90f4-3ea83bf90235', '271b7d2c-d37b-5262-a68c-6cea55ad7671', '12660ac5-b86f-5196-9612-2402577ad96e', '1f2622fb-106a-5fe4-9d6d-6ae507cb9a82', 'b14b7217-1422-5752-8b30-9c7b951e1ae3', 'fa00aada-a44c-50f8-aba2-ab299f6d65ba', '7b11ece8-b3ad-5e32-bd9c-61fddd36b30f', 'a7e605e5-35eb-5c42-b3e1-7bffad4a06d1', 'a16ec459-0454-50e9-ab1e-20237c1088e5', 'ce20ac22-6e69-5a2b-b0c8-5900b405f0f6', 'cf50bc59-c4a8-5238-86bf-c2f0c694c599', '1098811d-5e00-5b05-8c16-648587078de1', '5bd39b4e-c941-589d-a3ae-510c13e2eb11', '95a510c5-8c26-5a29-82a0-1f4fca091c34', '8f3977da-d137-5b38-9607-b564838e6857', '66be15c4-beeb-5486-b39d-2e4fd9b21ce9', '09bcd59b-378b-57af-aaf3-13fd39d8d958', '858ccb9c-73d7-545c-aebe-733465f63e46', 'dbccf281-04d4-5376-a7c9-5382bcaccf76', 'b375567d-725a-52d3-a60d-f5535517674c', '75ae9ce3-a0df-56ad-9246-fd1ae63c7830', '3bc80f53-bb3f-5692-8b23-9cc4a3f4fbb8', '4a3ee406-b99a-5be2-97c6-2e2cdb05dddd', '618b5c53-f7ff-5f21-9106-64be58a644a0', 'f2130e2e-626c-55f0-9089-a2fa041a78e2', '974e462f-601d-5e13-b239-ee4e22a55d55', 'e669020d-952b-5ce4-aeee-0bca0d4dbb4d', '51b26e5b-2c20-524f-9cf2-cd905acacf18', 'ce7eee8b-133e-5c25-b7d0-2e9431e76d05', 'b416d753-2367-54c0-9dd8-76101e6e7e38', '4471f9fb-6f23-54f0-981d-546cd85d0dc7', '3ab83461-8eca-578f-a51a-e224850aea72', '49a133ab-9f17-52b4-a209-8336ff43d2e9', '07bcc75f-b56f-58ec-82b5-5e27d7b77f7a', '7b3cfba2-608f-5e23-b55a-b23ef89500f2', '119d83d0-aa23-50cf-807a-f19cb49898b6', '90ae290f-bed3-5d7a-8de2-aeeaad3cb027', '2b715d28-5a33-5ac7-979b-5fedd2c77930', '39e32a36-d634-50cb-8b5e-ebfed0d02b9a', 'd33f620c-5521-5c50-aae4-dd0f73786793', 'f4b2714f-bd80-54db-971a-dbb39a452024', '2397a29e-c519-5964-bbf1-1d6af32c8ef0', '1177ce34-f4ca-532f-a92a-d72716458abd', '33282348-9ed5-51bc-8bf5-3c66a222d8e7', 'ccc78b94-a4cc-56b2-aa4c-a699f800eb13', 'ebc2a59a-5ac1-54f9-9de2-8b8f74d43c3b', '8b4c9ab1-728f-58cd-977f-bb599932f6ce', 'a0986f2d-3665-5a02-85a8-b27c64dd0af5', '7a8e5afd-a40d-5d46-8ae9-44fa6128c402', 'd998c74b-afc3-59f0-9988-b6858cdb98b0', 'd58d8964-35ac-5916-b6cc-f04b52fdf516', '773e32ac-7c4b-5481-9bb0-7b4b51ad3464', 'b6b15e36-da8d-5d12-849c-1a894140f83c', '904faa07-8c13-5b2c-8a96-694aeee0ba61', '78ea2f81-97be-5048-a481-4c1ee6f0cde1', '2d3637d9-7397-5def-90de-26fb48f5427b', 'f18ed663-8a3a-5c50-bed8-db71ba2e85cc', '3d0f0bd8-3055-5e47-93b3-c11e413f476f', '3456d453-dce4-5374-b7bf-175ff57ba743', 'c0b8b5bb-aab6-56fe-ba62-2673bbc9d8bf', 'c735e5bc-bd34-5f34-965b-dbc185e5b3fd', '363d9449-679f-5735-96a2-4cee634cc71c', '2acdcfd7-e887-5f26-863c-3ea32dc2caa2', '86c949e7-f8a9-520f-a423-a78c5a93e048', 'ef8c2814-754e-5de4-bc5f-3954dcf44f23', '35fa78d3-0b45-5036-84fc-60dbadd1ab8b', '706374ef-2793-5270-9a01-f922c7704b56', '15cc4921-6a46-5925-98de-9ee6750c61b3', '547adae2-1ab5-510a-86ce-c570bf920421', '55fbf97f-0b3a-53e6-a104-12a058c581ee', '8dcdccce-3807-5920-a9fa-0dc6caa1795a', '3778a2ff-88ae-5e46-884e-dce729fbf7e1', 'b7858f79-043d-5035-a771-5949d2f16426', 'c32a0dd1-f480-5e21-8e32-76723343f651', '7c2b9e5b-b0fa-5565-ab6a-bfe197e8089c');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'sciences-physiques-7eme' AND source = 'admin' AND id NOT IN ('bb5012b6-9312-5af9-89d2-24660bc58d99', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'f2d94e62-d50e-5af0-a767-27d67154a62c', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'b16b88dd-509d-507a-b730-b55d6443a7b8', '2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', '1f88fd80-ae9f-5b42-808f-b20b8953802b', '3d5f0675-fab5-51af-8933-d7ed2b846285', '15517a02-3806-522c-ace7-706da85e38be', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', '34b5e23f-bea4-5859-a644-d9df05e6297d', '5096e461-4102-5977-87e9-4009b3d08c56', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', '197975c5-6a17-5a55-aadc-2c868c02cd08', '9f8636de-815f-57d2-81fa-dd82eb5241a6', '3d4dcb4a-79c0-5946-b216-1f7a41844291', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'fa103e1a-5e49-5859-9419-389b9f560220', '555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'af4faee6-30b8-5638-962a-332ab27bfd59', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', '5d19273b-0c71-5441-9b46-346b6af3205b', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'e019d713-8a78-5740-8edd-59233662959a', '1b3f79ca-085b-58b7-a651-d2364307d25b', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', '410b4124-9099-5e10-9e44-d7323b1d5d2f', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e');
DELETE FROM public.questions WHERE exercise_id IN ('bb5012b6-9312-5af9-89d2-24660bc58d99', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'f2d94e62-d50e-5af0-a767-27d67154a62c', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'b16b88dd-509d-507a-b730-b55d6443a7b8', '2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', '1f88fd80-ae9f-5b42-808f-b20b8953802b', '3d5f0675-fab5-51af-8933-d7ed2b846285', '15517a02-3806-522c-ace7-706da85e38be', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', '34b5e23f-bea4-5859-a644-d9df05e6297d', '5096e461-4102-5977-87e9-4009b3d08c56', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', '197975c5-6a17-5a55-aadc-2c868c02cd08', '9f8636de-815f-57d2-81fa-dd82eb5241a6', '3d4dcb4a-79c0-5946-b216-1f7a41844291', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'fa103e1a-5e49-5859-9419-389b9f560220', '555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'af4faee6-30b8-5638-962a-332ab27bfd59', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', '5d19273b-0c71-5441-9b46-346b6af3205b', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'e019d713-8a78-5740-8edd-59233662959a', '1b3f79ca-085b-58b7-a651-d2364307d25b', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', '410b4124-9099-5e10-9e44-d7323b1d5d2f', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e') AND id NOT IN ('82b7df52-1245-54ca-bcd5-bf52b5155411', '60f03e17-5782-5aa7-97b3-bd4e1823608f', '0bc8a57d-0d32-5d39-8fa5-a0a2c4f59ae1', 'c75d1d3d-fa3e-50f1-9509-85bb645e7f0a', 'd9a446fa-0386-5031-8a07-c10479842f2a', '7d749e40-b404-5cde-9c95-9fbaa75de700', '98c34492-bd01-53ad-91e6-504ae6570965', '33cdf4b2-bb86-595c-9647-ba27d8741350', '796f552c-cacb-5b2a-8985-69420ddc9ad5', 'b13d0d45-47d1-5936-9017-172f1d71a932', '67409778-b9fe-54c5-806e-0b6ffaa35065', '7481f802-4215-5af8-9cb9-ed5071d327d1', '405f3247-2231-55e5-a894-5c143d7bf0f7', '298599fe-93d7-5a9f-b34f-73a5ec9e0608', '2b3be3b8-7ff0-5210-8f08-36c243d84962', '6b4e1d17-d431-5ba2-83ea-937423614f37', 'd07ab397-eb75-5f71-927c-9293dd65030a', '6008464f-aaed-50a4-b4cc-4e2372ce129d', 'e9a922d8-b494-575d-b36c-b3c716c3e8f3', '76f5132d-be87-5d88-8bcf-f68653560d2f', '3205c4c2-3119-5318-8940-ec870ab7d09a', 'bbb50eeb-56c9-5b13-9a59-e8987104fef8', '2b4f8eed-274f-5202-9b10-3b0d3af7e65e', '669c7ba8-33af-5258-b230-1c5cf112e1f4', 'b49ed5e3-85ae-55cb-96e3-dd00924378e4', '0b659695-448c-5a99-a213-b1ffbd795889', 'e2ef1aab-9d08-5654-a35c-e76015c3a03e', 'eedcda4a-0f04-5bb7-bab5-6a73821b3065', 'd6bbf62d-08bd-5ac0-80db-8681ec4a6cd3', 'ad585e38-d99e-5a20-a59e-d96d7b73445a', '533ecb22-6ab8-50c6-8d42-57650f9a6e4b', '9c27a001-510d-5dd1-8d97-103746a26879', '474563d6-55ba-5b2f-8825-fc7c80d86a9f', 'c064a4e5-d150-5ebc-8b8d-c0ffc5c5392b', '60dd8a7c-d5c6-5fa1-a5ba-0e5ae71ccc1f', '69d1aa5d-e183-571d-917c-4ddd20901572', 'ebb0638f-994b-5a1d-93e3-239a884dd18a', '2225be3e-23e5-586d-81ee-1eef8df2a889', '0823939e-89fe-5850-817d-b266c3182623', '9ec01da9-5d16-5e28-b314-6d3636665369', 'f7d0e24c-b136-5338-958d-ddf42845463d', 'ecea9b6a-53ef-5a7b-abdf-452093e0f3a8', '22a0d754-42ac-5cc0-aa5e-0d22662b8fda', '5e10ee26-e748-5abd-8bfb-1c7c04fb0f65', 'f3173d1d-e5d4-5ec0-adb1-c93ba26576e5', '974d16e7-bf74-536a-ae47-d049cb1cc838', '4dc6c291-40a4-5a30-96b7-14b5478da87d', '925db6f1-5a8a-5b9a-8688-383740672c9f', 'd17f3f6a-1e5d-56cd-a33b-9df021d98b18', 'b86bc9f8-63c7-57de-92ef-d8c6c021e70e', 'defd10c3-963d-5ffd-90a2-82ee0ab5254e', '844b3ba2-3331-5552-b055-3255bfdc8e44', 'f842969c-f85f-5472-a913-56852f33420f', '1dcf3c02-0b22-5ba3-8658-a6f8b1c7fb72', '4186b6ca-f45a-5d6c-bad8-92e3369383ec', '815cc6ce-25e9-55d6-8e34-66504551bbbe', '23259b60-f2cf-56c4-a903-c1480f16bf36', '57f6636e-4a97-58cd-9d72-444d405936bf', 'cb5a82d3-a121-5f3a-8b10-780db7b8c06b', 'fc6ab36d-3eeb-55bb-a35a-1ef91aa8a162', '46d5f00b-6e7d-549b-810a-601fb002d6fe', '9ef8e270-c634-5eba-a318-a5b689e7df9a', '9a9396fd-2410-57f3-b569-613ae181478d', '9062b7f0-13d6-5b16-beea-c9262cc5795f', '4c6c373b-d442-50b9-b679-071f9e56e49e', '01a1e740-4bef-5d32-b06c-bcbc20a6cfa0', 'cd50daac-83e8-53ac-9011-62f3f059d4d8', 'df9e1edc-8b27-5cda-93fc-6d57785afd1f', 'a4f4f840-e61c-51d1-80e4-0f90873afc33', '122bf5d3-a0f4-54d2-a906-3fb9251871eb', 'bf8c428e-be06-5cf6-8360-fd00367b72ee', '8167e9a3-1930-5cb2-b3cd-939d5d7989e8', 'a315daa6-fc16-5a0e-b5db-6d6a008be0ed', '6badfdc6-9f66-56bc-aecd-5037ad7d7ab7', '2cb8a402-6b4a-527e-b678-d919f7d2e0e9', '09ecb2a5-8932-5c15-a693-e2a954419b52', '85ae1b2c-3898-5280-8ddc-157e7bfa2682', 'b83d1bb5-f2cc-5b9f-9dbb-4835502484a2', 'e5bc97df-3cd5-5545-be6f-7c55a7e41bfa', 'ffe23998-3133-5e37-a809-a97a6993e6cd', '4caf26d3-f664-5659-a4ba-f4af0f648f92', 'f2b74846-80c5-5a34-be33-14d9f265c0b8', '2369f0fe-e368-5a19-b41b-ded487837b7a', '03c1d873-afa8-53c5-aba6-c28ad92e6ef0', '6e2cfc67-c5d7-514f-b976-5b45ac16642d', 'bbd7ef37-972c-53d1-bd9c-fd87f177ae3d', '6cbb34f6-cc20-576b-9f28-e93609c34471', '67e73fe3-4e0b-5e21-8f13-f6f73fbe46cc', 'c444ed4d-14e6-5978-b7d9-78597306c22c', '54b59a0a-a7ca-5f05-85d9-ecb769d74c12', '55026300-a1af-514b-aa51-559a6f5505ea', 'e4cc086f-bb3a-5000-aba7-2a4f0bbad3fd', 'ad27127b-8780-5782-9960-6fe2a6f05b8d', 'dcbab84c-c753-5659-96a5-082e9a9264c0', 'f240d1f4-dfc3-5929-8b4d-a9ace963e51d', '25260bc3-452b-5671-891a-584628adfa7a', '67000247-5888-5088-a511-4735b195eac4', '9bc1e3a1-cd05-5895-8bf2-713c6653ca92', '7531b393-1b2f-5d71-b3d7-9feca47f18bd', '2179f3d9-856b-5471-aae4-7b71df3a4e22', 'abb64175-3aa2-5c99-a950-f0c2317a3b58', '513b7323-1c09-5739-a48b-1443021e1918', '963c100b-72f3-5e40-9de5-4f5bdd927162', 'f9ead32d-64f9-5d40-bb1c-2eb3419579f5', '0a99d0d8-0e25-57fe-bc82-544480134c6f', '239d06ca-5e6f-556f-821d-95608cdfdb2f', '074fcd3c-d410-528e-81ef-3631248cf8f4', '86929362-93eb-5de6-89f3-4f77a33ea5c6', '6c7aab3b-6374-50f7-8139-38738c22973d', '17571ce9-b248-5834-94e7-a7cb91f85f8d', '3309f98b-d3e6-5bff-9835-1b1027f1eab0', 'ca119b79-766a-5b6a-8734-46505c011a81', 'a6a26794-72e9-5714-8cd7-d07a8ce02bcc', '32b5b63b-2845-5907-91a4-09eaca6a4453', 'cb28e965-297e-5019-a71a-5553a723d607', 'e75d4143-5af7-5b38-b98b-114602346d04', '7081d8b2-d46b-538c-86ff-26061952c470', '5395abad-43a2-523e-aec0-e574f3cd2cf1', '42f8eb4d-9b46-535e-abe4-906819676337', 'fc863b54-e518-5aeb-b344-cbb1ffcccf51', 'f8eefa7d-1b64-59f8-b14f-b7f093f388b8', 'a6916b79-311e-5e47-8e25-d25c02b96252', '1bd022d3-5a95-5cb0-9f3a-6cb397a24e01', 'e84af202-879a-5dba-9878-bfec67588ff7', '10a4b814-1b0a-5c74-80a7-b39652443726', '0df5716e-4ee0-5489-b0b1-5f64f174e845', '4589783d-01e3-5a2a-87f9-8083ca1d3756', 'f716718e-4332-507d-8e60-f5094dcd0286', 'da845378-3281-504d-bd19-982e3a1a1e76', '7071a6a1-e36d-5351-bfad-7d4c84890853', '764dc957-372f-5b11-a52a-f2d1a40d0060', '965783e0-4c50-5c51-9b8a-aa7aed77d53e', 'd292f93f-e642-5502-97b3-530bae391339', '3bcc87a6-8c8e-5f29-a8cb-bbc5cb503760', '77ae493e-288c-5185-ba93-e0b8c8299d3e', 'cdca1bec-3a7a-5f04-b823-cdb522949089', 'bae9f5d0-05fa-5cb4-af59-5bbc252da60e', '0e573e90-016b-526f-8d60-221510ac592e', '7cefe44d-e21d-558a-9c02-a829d053150b', '171acff5-f5ec-5a19-91c7-ec375e4c5e8c', '875fcb04-6c65-5c5e-84a6-f08efa922043', '4565a6d0-57fb-55e0-983b-2d19ee1ebd71', 'adda0393-0d0f-5e0f-99a7-a150b4cbae05', 'cdc90f4e-6f8d-5020-8b65-fc5308e33c87', '28828828-e727-5ea4-a0df-98591105773a', '354627b4-4b60-5958-948d-f870f30ae9c5', '1fdaf8dd-6a91-5888-85c5-9c5582f46d00', 'c0c9b423-b23c-5149-a506-e655a6dc9dd0', '91437c9a-44f6-5568-86ef-b81735e2e87f', '32df9a13-3242-5e26-b3a6-1b8cb5171fec', '07c06b8b-8a69-54ed-8dd3-5282ae623644', '71720a68-6c94-573f-9a7b-9a59094f79c7', '4b4a9bf8-e61f-5e12-a6b5-898d05c589f5', '9f144491-734d-5e14-ac0b-62eabaf23bf7', '42318272-57b9-5532-99ea-16260f92f84d', '64f019df-b76d-58e6-adf5-0e5dbc5a601e', 'f0bc2eb7-5bac-5de0-b548-906e3313f1ef', '05861724-7b4f-5951-b113-3fa4bad3e5c2', '0510a07c-bcc5-59e2-91a7-88664c6cce3c', '2dad25f6-afe9-5231-b361-81e656c05f46', 'b6252f04-7cb0-5d99-a5b0-a6d494e7d198', 'a30b12af-4f88-58d1-b22d-606ed1ae2fc2', '6a2344fb-35a2-55ec-bf54-567ee7f6f227', 'c91ac873-e0c2-549b-be10-1a207dc29cc1', '956e726a-ea4f-5467-96b9-785470fced9f', '5f23d204-b313-5dcb-97ed-a75dde041ac8', '7b796e16-be4d-5646-ba95-4eb01601debb', '6ef53671-2e1b-58d0-a7c8-1e6f20f7f40b', 'b540dacf-4370-57d9-ba22-e7613dcdf899', '6c0db2e4-d2d6-5e9d-ac82-6b2ac1890010', 'd672380f-4f0b-51aa-af47-cd74a8700e03', '4cd7b31a-fc4f-507f-90f4-3ea83bf90235', '271b7d2c-d37b-5262-a68c-6cea55ad7671', '12660ac5-b86f-5196-9612-2402577ad96e', '1f2622fb-106a-5fe4-9d6d-6ae507cb9a82', 'b14b7217-1422-5752-8b30-9c7b951e1ae3', 'fa00aada-a44c-50f8-aba2-ab299f6d65ba', '7b11ece8-b3ad-5e32-bd9c-61fddd36b30f', 'a7e605e5-35eb-5c42-b3e1-7bffad4a06d1', 'a16ec459-0454-50e9-ab1e-20237c1088e5', 'ce20ac22-6e69-5a2b-b0c8-5900b405f0f6', 'cf50bc59-c4a8-5238-86bf-c2f0c694c599', '1098811d-5e00-5b05-8c16-648587078de1', '5bd39b4e-c941-589d-a3ae-510c13e2eb11', '95a510c5-8c26-5a29-82a0-1f4fca091c34', '8f3977da-d137-5b38-9607-b564838e6857', '66be15c4-beeb-5486-b39d-2e4fd9b21ce9', '09bcd59b-378b-57af-aaf3-13fd39d8d958', '858ccb9c-73d7-545c-aebe-733465f63e46', 'dbccf281-04d4-5376-a7c9-5382bcaccf76', 'b375567d-725a-52d3-a60d-f5535517674c', '75ae9ce3-a0df-56ad-9246-fd1ae63c7830', '3bc80f53-bb3f-5692-8b23-9cc4a3f4fbb8', '4a3ee406-b99a-5be2-97c6-2e2cdb05dddd', '618b5c53-f7ff-5f21-9106-64be58a644a0', 'f2130e2e-626c-55f0-9089-a2fa041a78e2', '974e462f-601d-5e13-b239-ee4e22a55d55', 'e669020d-952b-5ce4-aeee-0bca0d4dbb4d', '51b26e5b-2c20-524f-9cf2-cd905acacf18', 'ce7eee8b-133e-5c25-b7d0-2e9431e76d05', 'b416d753-2367-54c0-9dd8-76101e6e7e38', '4471f9fb-6f23-54f0-981d-546cd85d0dc7', '3ab83461-8eca-578f-a51a-e224850aea72', '49a133ab-9f17-52b4-a209-8336ff43d2e9', '07bcc75f-b56f-58ec-82b5-5e27d7b77f7a', '7b3cfba2-608f-5e23-b55a-b23ef89500f2', '119d83d0-aa23-50cf-807a-f19cb49898b6', '90ae290f-bed3-5d7a-8de2-aeeaad3cb027', '2b715d28-5a33-5ac7-979b-5fedd2c77930', '39e32a36-d634-50cb-8b5e-ebfed0d02b9a', 'd33f620c-5521-5c50-aae4-dd0f73786793', 'f4b2714f-bd80-54db-971a-dbb39a452024', '2397a29e-c519-5964-bbf1-1d6af32c8ef0', '1177ce34-f4ca-532f-a92a-d72716458abd', '33282348-9ed5-51bc-8bf5-3c66a222d8e7', 'ccc78b94-a4cc-56b2-aa4c-a699f800eb13', 'ebc2a59a-5ac1-54f9-9de2-8b8f74d43c3b', '8b4c9ab1-728f-58cd-977f-bb599932f6ce', 'a0986f2d-3665-5a02-85a8-b27c64dd0af5', '7a8e5afd-a40d-5d46-8ae9-44fa6128c402', 'd998c74b-afc3-59f0-9988-b6858cdb98b0', 'd58d8964-35ac-5916-b6cc-f04b52fdf516', '773e32ac-7c4b-5481-9bb0-7b4b51ad3464', 'b6b15e36-da8d-5d12-849c-1a894140f83c', '904faa07-8c13-5b2c-8a96-694aeee0ba61', '78ea2f81-97be-5048-a481-4c1ee6f0cde1', '2d3637d9-7397-5def-90de-26fb48f5427b', 'f18ed663-8a3a-5c50-bed8-db71ba2e85cc', '3d0f0bd8-3055-5e47-93b3-c11e413f476f', '3456d453-dce4-5374-b7bf-175ff57ba743', 'c0b8b5bb-aab6-56fe-ba62-2673bbc9d8bf', 'c735e5bc-bd34-5f34-965b-dbc185e5b3fd', '363d9449-679f-5735-96a2-4cee634cc71c', '2acdcfd7-e887-5f26-863c-3ea32dc2caa2', '86c949e7-f8a9-520f-a423-a78c5a93e048', 'ef8c2814-754e-5de4-bc5f-3954dcf44f23', '35fa78d3-0b45-5036-84fc-60dbadd1ab8b', '706374ef-2793-5270-9a01-f922c7704b56', '15cc4921-6a46-5925-98de-9ee6750c61b3', '547adae2-1ab5-510a-86ce-c570bf920421', '55fbf97f-0b3a-53e6-a104-12a058c581ee', '8dcdccce-3807-5920-a9fa-0dc6caa1795a', '3778a2ff-88ae-5e46-884e-dce729fbf7e1', 'b7858f79-043d-5035-a771-5949d2f16426', 'c32a0dd1-f480-5e21-8e32-76723343f651', '7c2b9e5b-b0fa-5565-ab6a-bfe197e8089c');
DELETE FROM public.chapters c WHERE c.subject_id = 'sciences-physiques-7eme' AND c.id NOT IN ('38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'de42be60-e632-501f-a76c-74b321251372', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', '81a07868-592a-5c15-ba96-c2d8c8b37054', '7ed76543-049d-56e3-bae8-f36691312c1d') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', 'المادّة وحالاتها الفيزيائية', 'مفهوم المادّة والجسم، الحالات الفيزيائية الثلاث (صلبة، سائلة، غازية)، خصائص كلّ حالة من حيث الشكل والحجم، والنموذج الوصفي للجسيمات', '# ⚔️ المادّة وحالاتها الفيزيائية — رحلة داخل عالم الأشياء

> 💡 «كلّ ما حولك، من كرسيّ وماء وهواء، هو مادّة تلبس أشكالًا مختلفة. تعرّف على حالاتها الثلاث لتفهم عالمك من حولك.»

## 🏰 المادّة والجسم

- **المادّة**: كلّ ما يشغل حيّزًا من الفضاء ونحسّه أو نراه أو نلمسه، كالخشب والماء والهواء.
- **الجسم**: قطعة محدّدة من المادّة، لها حدود واضحة نميّزها عمّا حولها. فالكرسي جسمٌ صلب مصنوع من مادّة الخشب، وقطرة الزيت جسمٌ سائل، وفقّاعة الهواء داخل بالون جسمٌ غازي.

> 🗡️ كلّ جسم مصنوع من مادّة، لكنّ المادّة الواحدة (كالماء) يمكن أن تتّخذ أكثر من حالة فيزيائية: ماءً سائلًا، أو جليدًا صلبًا، أو بخارًا غازيًّا.

## ⚡ الحالات الفيزيائية الثلاث للمادّة

تتواجد المادّة في الطبيعة في ثلاث حالات فيزيائية رئيسية:

| الحالة الفيزيائية  | مثال يومي                       |
| ------------------ | ------------------------------- |
| **الحالة الصلبة**  | الطاولة، الحجر، قطعة الجليد     |
| **الحالة السائلة** | الماء، الزيت، الحليب            |
| **الحالة الغازية** | الهواء، بخار الماء، غاز البوتان |

## 🛡️ خصائص الحالة الصلبة

- **شكل خاصّ وثابت**: الجسم الصلب يحافظ على شكله الخاصّ به مهما غيّرنا وضعه أو الإناء الذي نضعه فيه.
- **حجم ثابت**: حجم الجسم الصلب لا يتغيّر.

> ⚠️ لا تخلط: تغيير وضعية الجسم الصلب (قلبه، تحريكه) لا يغيّر شكله؛ أمّا كسره إلى قطع فيغيّر عددها لا طبيعة كلّ قطعة، إذ تبقى كلّ قطعة صلبة بشكلها وحجمها الخاصّين.

## 🔮 خصائص الحالة السائلة

- **لا شكل خاصّ لها**: السائل يأخذ شكل الإناء الذي يُسكب فيه؛ فالماء في الكأس يأخذ شكل الكأس، وفي القارورة يأخذ شكل القارورة.
- **حجم ثابت**: مهما تغيّر شكل الإناء، تبقى كمّية السائل (حجمه) كما هي.

## 🌬️ خصائص الحالة الغازية

- **لا شكل خاصّ ولا حجم ثابت**: الغاز يملأ كامل الحيّز المتوفّر له وينتشر فيه بالكامل، فيأخذ شكل وحجم الإناء الذي يُحبَس فيه.
- مثال: رائحة عطر رُشّت في ركن غرفة تنتشر بعد قليل في كامل الغرفة، لا في ركن منها فقط.

## 🧩 نموذج الجسيمات: كيف نتخيّل المادّة من الداخل؟

لفهم سبب اختلاف الحالات الثلاث، نتخيّل أنّ كلّ مادّة مكوّنة من عدد هائل من **جسيمات** دقيقة جدًّا لا تُرى بالعين المجرّدة:

| الحالة    | ترتيب الجسيمات                     | حركة الجسيمات                        |
| --------- | ---------------------------------- | ------------------------------------ |
| **صلبة**  | مرتّبة ومتلاصقة (متراصّة)          | تهتزّ في مكانها فقط                  |
| **سائلة** | متقاربة لكن غير مرتّبة             | تتحرّك وتتزحلق فوق بعضها             |
| **غازية** | متباعدة جدًّا (فراغات كبيرة بينها) | تتحرّك بسرعة كبيرة في كلّ الاتّجاهات |

<svg viewBox="0 0 300 150">
<title>نموذج الجسيمات في الحالات الثلاث</title>
<rect x="8" y="16" width="85" height="96" rx="6" fill="none" stroke="#0f172a" stroke-width="2"/><rect x="105" y="16" width="85" height="96" rx="6" fill="none" stroke="#0f172a" stroke-width="2"/><rect x="202" y="16" width="85" height="96" rx="6" fill="none" stroke="#0f172a" stroke-width="2"/><circle cx="24" cy="38" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="24" cy="56" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="24" cy="74" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="24" cy="92" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="42" cy="38" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="42" cy="56" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="42" cy="74" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="42" cy="92" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="60" cy="38" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="60" cy="56" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="60" cy="74" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="60" cy="92" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="78" cy="38" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="78" cy="56" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="78" cy="74" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="78" cy="92" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="122" cy="40" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="140" cy="36" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="158" cy="44" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="176" cy="40" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="116" cy="58" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="134" cy="54" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="151" cy="62" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="170" cy="56" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="186" cy="60" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="126" cy="74" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="145" cy="78" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="163" cy="72" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="181" cy="78" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="133" cy="94" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="155" cy="92" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="174" cy="96" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="222" cy="34" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="262" cy="46" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="238" cy="62" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="274" cy="78" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="220" cy="84" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><circle cx="252" cy="96" r="6.5" fill="#93c5fd" stroke="#0f172a" stroke-width="1.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="50" y="128" text-anchor="middle" fill="#0f172a" font-size="13">صلبة</text><text x="50" y="143" text-anchor="middle" fill="#64748b" font-size="10">مرتّبة متلاصقة</text><text x="147" y="128" text-anchor="middle" fill="#0f172a" font-size="13">سائلة</text><text x="147" y="143" text-anchor="middle" fill="#64748b" font-size="10">متقاربة مبعثرة</text><text x="244" y="128" text-anchor="middle" fill="#0f172a" font-size="13">غازية</text><text x="244" y="143" text-anchor="middle" fill="#64748b" font-size="10">متباعدة جدًّا</text></g>
</svg>

- في الصلب، تلاصق الجسيمات وترتيبها يمنعها من التحرّك بحرّية، فيحافظ الجسم على شكله وحجمه معًا.
- في السائل، تبقى الجسيمات متقاربة (فيثبت الحجم) لكنّها تتزحلق بعضها فوق بعض (فيتغيّر الشكل حسب الإناء).
- في الغاز، تبتعد الجسيمات كثيرًا وتتحرّك بحرّية تامّة، فتنتشر وتملأ كلّ حيّز متاح لها.

> 🗡️ تذكّر الترتيب: صلبة (مرتّبة متلاصقة تهتزّ فقط) ← سائلة (متقاربة متزحلقة) ← غازية (متباعدة جدًّا وسريعة الحركة).

## 🔍 كيف نتعرّف على حالة جسم مألوف؟

نطرح على أنفسنا سؤالين بسيطين لتحديد حالة أيّ جسم:

1. هل يحافظ على شكله الخاصّ به مهما حرّكناه أو غيّرنا إناءه؟ إذا كان الجواب نعم، فهو **صلب**.
2. إذا كان الجواب لا، فهل يبقى حجمه ثابتًا رغم أنّه يأخذ شكل إنائه؟ إذا كان الجواب نعم، فهو **سائل**. وإذا انتشر وامتلأ به كامل الإناء مهما كبُر، فهو **غازي**.

> 🏆 أصبحتَ الآن قادرًا على تصنيف أيّ جسم من حولك إلى صلب أو سائل أو غازي، وفهمتَ لماذا يتصرّف كلٌّ منها بطريقته الخاصّة. في فصل قادم، سنكتشف كيف تتحوّل المادّة من حالة إلى أخرى!', '# 📜 ملخّص: المادّة وحالاتها الفيزيائية

- **المادّة والجسم**: المادّة تشغل حيّزًا من الفضاء؛ الجسم قطعة محدّدة منها لها حدود واضحة (كرسي صلب، ماء سائل، هواء غازي).
- **الحالات الثلاث**: صلبة (الحجر)، سائلة (الماء)، غازية (الهواء) — أشكال مختلفة قد تتّخذها المادّة نفسها.
- **الحالة الصلبة**: شكل خاصّ ثابت + حجم ثابت.
- **الحالة السائلة**: لا شكل خاصّ (تأخذ شكل الإناء) + حجم ثابت.
- **الحالة الغازية**: لا شكل خاصّ ولا حجم ثابت — تملأ كامل الحيّز المتاح.
- **نموذج الجسيمات**: صلبة = جسيمات مرتّبة متلاصقة تهتزّ في مكانها؛ سائلة = جسيمات متقاربة متزحلقة؛ غازية = جسيمات متباعدة جدًّا سريعة الحركة.
- **التعرّف على الحالة**: هل يحافظ على شكله؟ (صلب) — إن لا، هل يحافظ على حجمه فقط؟ (سائل) — أم ينتشر ويملأ الإناء بالكامل؟ (غازي)', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', 'الماء: أهمّيته ومصادره والكشف عنه', 'أهمّية الماء في حياة الإنسان والحيوان والنبات، مصادره الطبيعية في الطبيعة (أمطار، أنهار، عيون، آبار، بحار) والسدود التي يبنيها الإنسان، الفرق بين المياه السطحية والجوفية، طريقة الكشف عن الماء باختبار كبريتات النحاس اللامائية، ومقدّمة إلى كون الماء في الطبيعة غير نقيّ', '# ⚔️ الماء: أهمّيته ومصادره والكشف عنه — سرّ الحياة على الأرض

> 💡 «لا حياة على الأرض بلا ماء: هو سرّ نموّ النبتة، وريّ العطش، وحياة كلّ كائن حيّ. تعرّف على مصادره الطبيعية وتعلّم كيف تكشف عن وجوده.»

## 🏰 لماذا الماء ضروري لكلّ كائن حيّ؟

- **للإنسان**: يشرب الماء ليعيش، ويستعمله للطهي والنظافة؛ فبدونه لا يستطيع جسم الإنسان الاستمرار سوى أيّام قليلة.
- **للنبات**: يمتصّ النبات الماء من التربة عبر جذوره، وهو ضروري لنموّه وصنع غذائه.
- **للحيوان**: يحتاج كلّ حيوان بريّ أو بحريّ إلى الماء ليعيش، سواء بالشرب المباشر أو بالعيش داخله.
- **للفلاحة والصناعة**: يُستعمل الماء لريّ المزروعات في الحقول والواحات، وكذلك في العديد من الصناعات.

> 🗡️ لهذا يُقال إنّ الماء «سرّ الحياة»: فكلّ الكائنات الحيّة، من أصغر نبتة إلى الإنسان، لا يمكنها الاستغناء عنه.

## 💧 المسطّحات المائية في الطبيعة

تغطّي المياه جزءًا كبيرًا من سطح الكرة الأرضية، وتتوزّع بين عدّة مسطّحات:

| المسطّح المائي       | طبيعة الماء                   |
| -------------------- | ----------------------------- |
| **البحار والمحيطات** | ماء مالح، وهو الأكبر امتدادًا |
| **الأنهار والأودية** | ماء عذب يجري على سطح الأرض    |
| **البحيرات والسدود** | ماء عذب يتجمّع في حوض         |
| **المياه الجوفية**   | ماء عذب محبوس تحت سطح الأرض   |

## ☔ من أين يأتي الماء؟ المصادر الطبيعية

الأمطار هي **الأصل الأوّل** لمعظم المياه العذبة على اليابسة: بعد سقوطها، إمّا تتسرّب في التربة فتغذّي المياه الجوفية، أو تجري على السطح فتغذّي الأنهار والسدود، أو تتبخّر من جديد لتكوّن السحب.

انطلاقًا من هذا الأصل، نميّز عدّة مصادر طبيعية للماء:

- **الأنهار والأودية**: مجاري مائية عذبة تجري على سطح الأرض، كوادي مجردة أطول أنهار تونس.
- **العيون**: أماكن يخرج فيها الماء الجوفي طبيعيًّا إلى السطح دون أن يحفر أحد حفرة، كعيون قربص المعروفة في تونس.
- **الآبار**: حُفَر يحفرها الإنسان للوصول إلى المياه الجوفية المحبوسة تحت الأرض، وهي أساسية في الواحات كتوزر وقفصة لريّ النخيل.
- **البحار**: مسطّحات مائية مالحة واسعة، تُطلّ عليها تونس على البحر الأبيض المتوسط، لكنّ ماءها المالح غير صالح للشرب مباشرة.

> ⚠️ لا تخلط بين **العين** (خروج طبيعي للماء الجوفي دون حفر) و**البئر** (حفرة يحفرها الإنسان للوصول إلى الماء الجوفي): كلاهما مصدره الماء الجوفي، لكنّ طريقة الوصول إليه مختلفة.

## 🏞️ السدود: خزّانات يبنيها الإنسان

لا تكتفي تونس بالمصادر الطبيعية وحدها: تُبنى **السدود** على الأودية لتجميع مياه الأمطار وجريان الأودية في بحيرة اصطناعية، كسدّ سيدي سالم على وادي مجردة، أكبر سدود تونس. يُستعمل ماء السدود لريّ الفلاحة وتزويد المدن بالماء بعد معالجته.

## 🌍 مياه سطحية ومياه جوفية

نميّز بين نوعين رئيسيين من حيث موقع الماء:

| النوع          | أين يوجد                                      | أمثلة                             |
| -------------- | --------------------------------------------- | --------------------------------- |
| **مياه سطحية** | تجري أو تتجمّع فوق سطح الأرض                  | الأنهار، البحيرات، السدود، البحار |
| **مياه جوفية** | محبوسة تحت سطح الأرض بين طبقات الصخور والتربة | العيون، الآبار                    |

<svg viewBox="0 0 300 194">
<title>مياه سطحية ومياه جوفية</title>
<rect x="0" y="0" width="300" height="78" fill="#e0f2fe" stroke="none" stroke-width="2"/><polygon points="0,78 55,78 90,55 125,70 300,80 300,134 0,134" fill="#e7d3b0" stroke="#64748b" stroke-width="1.5"/><rect x="0" y="134" width="300" height="34" fill="#bfdbfe" stroke="none" stroke-width="2"/><line x1="0" y1="134" x2="300" y2="134" stroke="#2563eb" stroke-width="2"/><rect x="0" y="168" width="300" height="26" fill="#94a3b8" stroke="none" stroke-width="2"/><path d="M6 168 L-2 176 M22 168 L14 176 M38 168 L30 176 M54 168 L46 176 M70 168 L62 176 M86 168 L78 176 M102 168 L94 176 M118 168 L110 176 M134 168 L126 176 M150 168 L142 176 M166 168 L158 176 M182 168 L174 176 M198 168 L190 176 M214 168 L206 176 M230 168 L222 176 M246 168 L238 176 M262 168 L254 176 M278 168 L270 176 M294 168 L286 176" stroke="#475569" stroke-width="1.2"/><ellipse cx="225" cy="80" rx="52" ry="9" fill="#2563eb" stroke="#2563eb" stroke-width="1.5"/><rect x="103" y="46" width="16" height="104" fill="#f8fafc" stroke="#0f172a" stroke-width="2"/><rect x="105" y="138" width="12" height="12" fill="#2563eb" stroke="none" stroke-width="2"/><rect x="99" y="42" width="24" height="6" fill="#a16207" stroke="#0f172a" stroke-width="1.5"/><polyline points="70,66 78,74 70,82 80,90" fill="none" stroke="#2563eb" stroke-width="2.5"/><circle cx="70" cy="66" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="18" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="52" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="86" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="120" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="154" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="188" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="222" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="256" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="290" cy="151" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="225" y="66" text-anchor="middle" fill="#2563eb" font-size="12">مياه سطحية</text><text x="235" y="84" text-anchor="middle" fill="#0f172a" font-size="10">(نهر / بحيرة)</text><text x="150" y="155" text-anchor="middle" fill="#1e3a8a" font-size="13">مياه جوفية</text><text x="111" y="36" text-anchor="middle" fill="#0f172a" font-size="12">بئر</text><text x="46" y="60" text-anchor="middle" fill="#2563eb" font-size="12">عين</text><text x="150" y="184" text-anchor="middle" fill="#0f172a" font-size="11">طبقة صخرية</text></g>
</svg>

## 🧪 كيف نكشف عن وجود الماء؟

قد يبدو سائل ما شفّافًا وعديم اللون، فلا نستطيع الجزم بعين مجرّدة أنّه يحتوي على ماء. للتأكّد، نستعمل اختبارًا كيميائيًّا بسيطًا:

- **كبريتات النحاس اللامائية** مسحوق **أبيض** اللون.
- عند ملامسته لأدنى كمّية من الماء، **يتحوّل لونه من الأبيض إلى الأزرق**.

هذا التحوّل من الأبيض إلى الأزرق هو **الدليل القاطع** على وجود الماء في السائل أو الجسم المختبَر؛ فإذا بقي المسحوق أبيض، فهذا يعني غياب الماء.

> 🗡️ رتّب الاتّجاه جيّدًا: أبيض (بدون ماء) ← أزرق (بوجود الماء). الاتّجاه المعاكس غير صحيح إطلاقًا.

## 🔎 هل الماء الطبيعي نقيّ حقًّا؟

قد نظنّ أنّ ماء النهر أو العين أو البئر «نقيّ» تمامًا لأنّه شفّاف. لكنّ الحقيقة أنّ **الماء في الطبيعة ليس نقيًّا أبدًا**: فهو يحتوي دائمًا على موادّ أخرى مذابة فيه لا نراها بالعين المجرّدة (كأملاح معدنية وغازات)، اكتسبها أثناء مروره بالتربة والصخور.

> ⚠️ الشفافية ليست دليلًا على النقاوة: سائل شفّاف تمامًا قد يحتوي على موادّ مذابة كثيرة. لهذا يحتاج بعض ماء الشرب إلى معالجة قبل استهلاكه.

> 🏆 أصبحت الآن تعرف لماذا الماء ضروري لكلّ كائن حيّ، ومن أين يأتي في الطبيعة، وكيف تكشف عن وجوده بكبريتات النحاس اللامائية. في فصل قادم، سنكتشف المزيد من أسرار المادّة من حولنا!', '# 📜 ملخّص: الماء: أهمّيته ومصادره والكشف عنه

- **أهمّية الماء**: ضروري للإنسان (الشرب) والنبات (النموّ) والحيوان (البقاء) والفلاحة والصناعة — سرّ الحياة على الأرض.
- **المسطّحات المائية**: بحار ومحيطات (مالحة، الأكبر)، أنهار وأودية وبحيرات وسدود (عذبة)، مياه جوفية (عذبة محبوسة تحت الأرض).
- **المصادر الطبيعية**: الأمطار أصل معظم المياه العذبة؛ تغذّي الأنهار، وتتسرّب لتكوّن العيون والآبار؛ والبحار مالحة وغير صالحة للشرب مباشرة.
- **السدود**: خزّانات اصطناعية يبنيها الإنسان على الأودية لتجميع مياه الأمطار والجريان (سدّ سيدي سالم مثال).
- **مياه سطحية وجوفية**: السطحية فوق الأرض (أنهار، سدود، بحار)؛ الجوفية تحتها (عيون، آبار).
- **الكشف عن الماء**: مسحوق كبريتات النحاس اللامائية أبيض اللون، يتحوّل إلى الأزرق عند ملامسته للماء — الدليل القاطع على وجوده.
- **نقاوة الماء**: الماء الطبيعي ليس نقيًّا أبدًا، يحتوي على موادّ مذابة رغم شفافيته الظاهرية.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', 'تغيّرات حالة الماء (التّحوّلات الفيزيائية)', 'الانصهار والتصلّب، التبخّر والغليان والتكاثف، درجة الحرارة θ بالدرجة السلسيوس °C ومقياس الحرارة، ثبات درجة الحرارة أثناء تغيّر الحالة، الدورة الطبيعية للماء، وحفظ الكتلة أثناء تغيّر الحالة', '# ⚔️ تغيّرات حالة الماء (التّحوّلات الفيزيائية) — رحلة بين الجليد والماء والبخار

> 💡 «الماء نفسه يتنقّل بين ثلاثة أشكال دون أن يتغيّر: جليد صلب، ماء سائل، وبخار غازي. اكتشف أسماء هذه التحوّلات، ولماذا تتوقّف درجة الحرارة عن الارتفاع في منتصف الطريق!»

## 🏰 التحوّلات الستّة بين الحالات الثلاث

في الفصل الأوّل تعرّفت على الحالات الثلاث للمادّة. الماء نفسه يمكن أن ينتقل من حالة إلى أخرى دون أن يتغيّر: يبقى ماءً دائمًا، سواء كان صلبًا أم سائلًا أم غازيًّا. لكلّ انتقال بين حالتين اسم خاصّ:

| من الحالة    | إلى الحالة   | اسم التحوّل                |
| ------------ | ------------ | -------------------------- |
| صلبة (جليد)  | سائلة (ماء)  | **الانصهار**               |
| سائلة (ماء)  | صلبة (جليد)  | **التصلّب**                |
| سائلة (ماء)  | غازية (بخار) | **التبخّر** أو **الغليان** |
| غازية (بخار) | سائلة (ماء)  | **التكاثف**                |

<svg viewBox="0 0 300 145">
<title>تحوّلات حالة الماء</title>
<rect x="12" y="62" width="70" height="46" rx="8" fill="#f1f5f9" stroke="#0f172a" stroke-width="2"/><rect x="115" y="62" width="70" height="46" rx="8" fill="#f1f5f9" stroke="#0f172a" stroke-width="2"/><rect x="218" y="62" width="70" height="46" rx="8" fill="#f1f5f9" stroke="#0f172a" stroke-width="2"/><line x1="84" y1="78" x2="113" y2="78" stroke="#0f6e56" stroke-width="2.5"/>
<polygon points="113,78 105,82 105,74" fill="#0f6e56"/><line x1="113" y1="96" x2="84" y2="96" stroke="#2563eb" stroke-width="2.5"/>
<polygon points="84,96 92,92 92,100" fill="#2563eb"/><line x1="187" y1="78" x2="216" y2="78" stroke="#ef4444" stroke-width="2.5"/>
<polygon points="216,78 208,82 208,74" fill="#ef4444"/><line x1="216" y1="96" x2="187" y2="96" stroke="#7c3aed" stroke-width="2.5"/>
<polygon points="187,96 195,92 195,100" fill="#7c3aed"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="47" y="90" text-anchor="middle" fill="#0f172a" font-size="14">صلب</text><text x="150" y="90" text-anchor="middle" fill="#0f172a" font-size="14">سائل</text><text x="253" y="90" text-anchor="middle" fill="#0f172a" font-size="14">غاز</text><text x="98" y="52" text-anchor="middle" fill="#0f6e56" font-size="12">انصهار</text><text x="98" y="124" text-anchor="middle" fill="#2563eb" font-size="12">تصلّب</text><text x="201" y="52" text-anchor="middle" fill="#ef4444" font-size="11">تبخّر / غليان</text><text x="201" y="124" text-anchor="middle" fill="#7c3aed" font-size="12">تكاثف</text></g>
</svg>

> 🗡️ كلّ هذه التحوّلات **فيزيائية**: يتغيّر شكل الماء الخارجي (حالته) فقط، وتبقى طبيعته الكيميائية كماءٍ دون أيّ تغيير.

## 🧊 الانصهار والتصلّب

- **الانصهار**: تحوّل الماء من الحالة الصلبة إلى الحالة السائلة، ويحدث عند **التسخين**. مثال: قطعة ثلج تُترك خارج الثلاجة تنصهر تدريجيًّا وتتحوّل إلى ماء سائل.
- **التصلّب**: تحوّل الماء من الحالة السائلة إلى الحالة الصلبة، ويحدث عند **التبريد**. مثال: ماء يوضع في قوالب داخل المجمّد يتصلّب مكوّنًا مكعّبات ثلج.

> ⚠️ لا تخلط بين الاتّجاهين: الانصهار يذهب من الصلب إلى السائل (تسخين)، والتصلّب يذهب من السائل إلى الصلب (تبريد) — اتّجاهان متعاكسان تمامًا.

## 💨 التبخّر والغليان: تحوّلان من السائل إلى الغاز

كلّ من التبخّر والغليان ينقلان الماء من الحالة السائلة إلى الحالة الغازية، لكنّهما يختلفان في ثلاث خصائص:

| الخاصّية         | التبخّر                | الغليان                                                   |
| ---------------- | ---------------------- | --------------------------------------------------------- |
| **مكان الحدوث**  | على سطح السائل فقط     | داخل كامل كتلة السائل (فقّاعات)                           |
| **السرعة**       | بطيء وهادئ             | سريع وقويّ                                                |
| **درجة الحرارة** | يحدث في أيّ درجة حرارة | يحدث عند درجة حرارة ثابتة (نحو 100°C عند مستوى سطح البحر) |

مثال على التبخّر: بركة ماء صغيرة تختفي تدريجيًّا في يوم مشمس دون أن تغلي؛ ملابس مبلّلة تجفّ في الهواء الطلق. مثال على الغليان: ماء في قدر على النار يبدأ بتكوين فقّاعات كثيرة في كامل حجمه عند بلوغه درجة معيّنة.

## ☁️ التكاثف: من البخار إلى الماء السائل

**التكاثف** هو تحوّل الماء من الحالة الغازية (بخار) إلى الحالة السائلة، ويحدث عند **تبريد** البخار. مثال: بخار الماء الموجود في الهواء يلامس سطح كأس بارد مملوء بالماء المثلّج، فيتكاثف مكوّنًا قطرات ماء على السطح الخارجي للكأس.

> ⚠️ لا تخلط بين التبخّر (سائل ← غاز) والتكاثف (غاز ← سائل): التكاثف هو التحوّل العكسي للتبخّر والغليان معًا.

## 🌡️ قياس درجة الحرارة: مقياس الحرارة والدرجة السلسيوس

نقيس سخونة أو برودة الماء بمقدار يسمّى **درجة الحرارة**، ونرمز لها غالبًا بالحرف **θ**. نقيسها بجهاز خاصّ يُسمّى **مقياس الحرارة** (أو الترمومتر)، ووحدته المستعملة هي **الدرجة السلسيوس**، ورمزها **°C**.

هاتان قيمتان معلمتان مهمّتان لماء نقيّ عند مستوى سطح البحر:

- الماء يتصلّب (يتجمّد) عند θ = 0°C.
- الماء يغلي عند θ = 100°C.

## ⏸️ ثبات درجة الحرارة أثناء التغيّر

أثناء تغيّر حالة الماء (كالانصهار أو الغليان)، **تبقى درجة حرارته ثابتة طوال مدّة التحوّل**، حتّى لو استمررنا في تسخينه. مثلًا: إذا سخّنّا قدر ماء يغلي، تبقى درجة حرارته عند 100°C طيلة مدّة الغليان، ولا ترتفع أكثر ما دام هناك ماء سائل يتحوّل إلى بخار.

> 🗡️ الحرارة المُضافة أثناء التغيّر لا ترفع درجة الحرارة، بل «تُستهلك» في تغيير حالة الماء نفسه؛ لهذا يبقى مقياس الحرارة عند نفس القراءة طوال التحوّل.

## 🌍 الدورة الطبيعية للماء وحفظ الكتلة

تجمع الدورة الطبيعية للماء (التي بدأت رؤيتها في الفصل السابق مع الأمطار والأنهار) بين هذه التحوّلات كلّها: تسخّن الشمس مياه البحار والمحيطات فتتبخّر، يصعد البخار إلى الأعلى حيث يبرد فيتكاثف مكوّنًا الغيوم، ثمّ تسقط الأمطار من جديد لتغذّي الأنهار والسدود والمياه الجوفية، وتعود المياه إلى البحار لتبدأ الدورة من جديد.

مهما تغيّرت حالة كمّية من الماء (انصهار، تصلّب، تبخّر، تكاثف)، **تبقى كتلتها محفوظة**: إذا انصهرت قطعة جليد كتلتها 100غ بالكامل داخل وعاء مغلق، نحصل على 100غ بالضبط من الماء السائل، لأنّ التحوّل فيزيائي يغيّر الشكل الخارجي فقط دون أن يفقد الماء أو يكتسب أيّ كتلة إضافية.

> 🏆 أصبحت الآن تعرف أسماء تحوّلات الماء الستّة، وتفهم لماذا تثبت درجة حرارته أثناء التغيّر، وكيف تدور دورة الماء الطبيعية محافظةً على كتلته. في فصل قادم، سنكتشف المزيد من أسرار المادّة من حولنا!', '# 📜 ملخّص: تغيّرات حالة الماء (التّحوّلات الفيزيائية)

- **التحوّلات الستّة**: للماء ثلاث حالات (صلبة، سائلة، غازية)، ولكلّ انتقال بينها اسم خاصّ: الانصهار، التصلّب، التبخّر/الغليان، التكاثف.
- **الانصهار والتصلّب**: الانصهار (صلب ← سائل) عند التسخين؛ التصلّب (سائل ← صلب) عند التبريد — اتّجاهان متعاكسان.
- **التبخّر والغليان**: كلاهما سائل ← غاز؛ التبخّر بطيء وعلى السطح فقط في أيّ درجة حرارة، والغليان سريع وفي كامل السائل عند درجة حرارة ثابتة (نحو 100°C).
- **التكاثف**: تحوّل غاز ← سائل عند التبريد، وهو عكس التبخّر والغليان معًا.
- **درجة الحرارة**: تُقاس بـ θ بوحدة الدرجة السلسيوس °C باستعمال مقياس الحرارة؛ الماء يتصلّب عند 0°C ويغلي عند 100°C عند مستوى سطح البحر.
- **ثبات درجة الحرارة أثناء التغيّر**: تبقى ثابتة طوال مدّة التحوّل (كالغليان عند 100°C) حتّى مع استمرار التسخين، لأنّ الحرارة تُستهلك في التحوّل لا في رفع الدرجة.
- **الدورة الطبيعية للماء وحفظ الكتلة**: تبخّر ← تكاثف ← أمطار في دورة مستمرّة تربط البحار بالأنهار والمياه الجوفية؛ وكتلة الماء تبقى محفوظة عبر كلّ تغيّر حالة.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', 'المزائج وفصل مكوّناتها ومعالجة المياه', 'المزيج المتجانس والمزيج غير المتجانس، تقنيات فصل مكوّنات مزيج (الترسيب، الترشيح، التقطير) ومبدأ كلّ تقنية، خطوات معالجة الماء الطبيعي المبسّطة ليصبح صالحًا للشرب، وتلوّث الماء وطرق المحافظة عليه', '# ⚔️ المزائج وفصل مكوّناتها ومعالجة المياه — من الماء الطبيعي إلى كأس الشرب

> 💡 «ماء الوادي عكر مملوء بالطين، فكيف يصل إلى صنبورك صافيًا وصالحًا للشرب؟ اكتشف أسرار فصل المزائج والرحلة التي يقطعها الماء الطبيعي قبل أن يصل إلى بيتك.»

## 🏰 المزيج المتجانس والمزيج غير المتجانس

عندما نمزج جسمين أو أكثر معًا، نحصل على **مزيج**. نميّز نوعين من المزائج بحسب إمكانية تمييز مكوّناته بالعين المجرّدة:

| نوع المزيج          | تعريفه                                                                       | أمثلة                                |
| ------------------- | ---------------------------------------------------------------------------- | ------------------------------------ |
| **مزيج متجانس**     | لا نستطيع تمييز مكوّناته بالعين المجرّدة، فيبدو موحّد المظهر في كلّ نقطة منه | ماء + سكّر مذاب، ماء + ملح مذاب      |
| **مزيج غير متجانس** | نستطيع تمييز مكوّنَين على الأقلّ منه بالعين المجرّدة                         | ماء + رمل، ماء + زيت، ماء عكر بالطين |

> 🗡️ اختبار بسيط: إذا تركت المزيج بضع دقائق ولاحظت طبقات أو رواسب أو حبيبات ظاهرة، فهو **غير متجانس**؛ أمّا إذا بقي موحّد المظهر تمامًا، فهو **متجانس**.

## 💧 الترسيب: فصل جسم صلب ثقيل عن سائل

**الترسيب** طريقة تعتمد على ترك مزيج غير متجانس (كالماء العكر) ساكنًا لبعض الوقت، فتسقط الحبيبات الصلبة الثقيلة نحو قاع الإناء بفعل ثقلها، ويتكوّن فوقها ماء أصفى.

- الجسم الصلب الذي يستقرّ في القاع يُسمّى **الراسب**.
- الترسيب لا يحتاج إلى أيّة أداة خاصّة: يكفي الانتظار.

> ⚠️ الترسيب لا يزيل كلّ الحبيبات: بعض الجسيمات الدقيقة جدًّا تبقى عالقة في الماء الأصفى فوق الراسب، فتحتاج إلى طريقة أخرى لإزالتها.

## 🧪 الترشيح: فصل جسم صلب عن سائل بورقة الترشيح

**الترشيح** طريقة تعتمد على سكب المزيج غير المتجانس على **ورقة ترشيح** موضوعة داخل قمع: يمرّ السائل عبر مسامّ الورقة الدقيقة ويتساقط صافيًا في إناء أسفل القمع، بينما تبقى الحبيبات الصلبة عالقة فوق الورقة.

- السائل الصافي الذي يمرّ عبر الورقة يُسمّى **الراشح**.
- الترشيح يفصل حبيبات أدقّ ممّا يفصله الترسيب وحده، ولا يحتاج إلى أيّ تسخين.

<svg viewBox="0 0 300 224">
<title>الترشيح</title>
<polygon points="104,52 196,52 156,112 156,138 144,138 144,112" fill="#f8fafc" stroke="#0f172a" stroke-width="2.5"/><polygon points="112,57 188,57 150,108" fill="#fef9c3" stroke="#d97706" stroke-width="2"/><polygon points="120,61 180,61 150,95" fill="#a8b8a0" stroke="none" stroke-width="2"/><circle cx="150" cy="148" r="3" fill="#2563eb" stroke="none" stroke-width="2"/><circle cx="150" cy="158" r="2.5" fill="#2563eb" stroke="none" stroke-width="2"/><polyline points="122,162 122,200 178,200 178,162" fill="none" stroke="#0f172a" stroke-width="2.5"/><rect x="124" y="178" width="52" height="21" fill="#bfdbfe" stroke="none" stroke-width="2"/><line x1="124" y1="178" x2="176" y2="178" stroke="#2563eb" stroke-width="1.5"/><line x1="196" y1="60" x2="224" y2="52" stroke="#64748b" stroke-width="1.2"/><line x1="180" y1="82" x2="214" y2="92" stroke="#64748b" stroke-width="1.2"/><line x1="164" y1="90" x2="214" y2="118" stroke="#64748b" stroke-width="1.2"/><circle cx="138" cy="88" r="2.6" fill="#4d3b1f" stroke="none" stroke-width="2"/><circle cx="150" cy="92" r="2.6" fill="#4d3b1f" stroke="none" stroke-width="2"/><circle cx="160" cy="87" r="2.6" fill="#4d3b1f" stroke="none" stroke-width="2"/><circle cx="145" cy="96" r="2.6" fill="#4d3b1f" stroke="none" stroke-width="2"/><circle cx="156" cy="96" r="2.6" fill="#4d3b1f" stroke="none" stroke-width="2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="30" text-anchor="middle" fill="#0f172a" font-size="12">سكب المزيج العكر</text><text x="246" y="52" text-anchor="middle" fill="#0f172a" font-size="12">قمع</text><text x="244" y="96" text-anchor="middle" fill="#d97706" font-size="11">ورقة الترشيح</text><text x="244" y="122" text-anchor="middle" fill="#4d3b1f" font-size="11">حبيبات صلبة</text><text x="150" y="216" text-anchor="middle" fill="#1e3a8a" font-size="12">الراشح (سائل صافٍ)</text></g>
</svg>

> ⚠️ لا تخلط بين الترشيح والتقطير: الترشيح يفصل **جسمًا صلبًا** عن سائل بتمريره عبر ورقة في درجة حرارة عادية، بينما التقطير (الآتي) يفصل مكوّنات **مزيج متجانس** بالتسخين والتبخّر.

## 🔥 التقطير: فصل مكوّنات مزيج متجانس بالتسخين

عندما يكون المزيج **متجانسًا** (كملح مذاب تمامًا في الماء)، لا يفيد الترسيب ولا الترشيح لأنّ الملح مذاب ولا توجد حبيبات صلبة ظاهرة يمكن حجزها. نستعمل حينئذ **التقطير**:

1. نسخّن المزيج المتجانس حتّى يبلغ الغليان، فيتبخّر الماء تاركًا الجسم المذاب (كالملح) في الإناء.
2. يمرّ البخار عبر **مبرّد**، فيبرد ويتكاثف من جديد إلى ماء سائل.
3. يتساقط هذا الماء المتكاثف، النقيّ جدًّا، في إناء آخر.

> 🗡️ التقطير هو الطريقة الوحيدة من بين الثلاث القادرة على فصل مكوّنات مزيج **متجانس**؛ الترسيب والترشيح يفصلان فقط جسمًا صلبًا غير مذاب عن سائل.

## 🚰 كيف يصبح الماء الطبيعي صالحًا للشرب؟

ماء الأودية والسدود، كماء سدّ سيدي سالم على وادي مجردة، غالبًا عكر وغير صالح للشرب مباشرة. تُعالجه محطّات معالجة الماء عبر خطوات مبسّطة مرتّبة كالتالي:

| الترتيب | الخطوة      | الهدف                                                            |
| ------- | ----------- | ---------------------------------------------------------------- |
| 1       | **الترسيب** | تستقرّ حبيبات الطين والأوحال الكبيرة في أحواض خاصّة              |
| 2       | **الترشيح** | تُزال الحبيبات الدقيقة المتبقّية بتمرير الماء عبر طبقات من الرمل |
| 3       | **التعقيم** | تُضاف كمّية صغيرة من الكلور للقضاء على الجراثيم                  |

بعد هذه الخطوات الثلاث، يصبح الماء صالحًا للشرب فيوزَّع عبر شبكة الأنابيب إلى المنازل.

> ⚠️ لا تُقلب هذه الخطوات: البدء بالترشيح قبل الترسيب يُسدّ ورقة الترشيح بسرعة بكمّية الطين الكبيرة، والبدء بالتعقيم قبل الترسيب والترشيح يجعل الكلور يتفاعل مع الطين بدل التركيز على الجراثيم فيضعف مفعوله.

## 🌍 تلوّث الماء والمحافظة عليه

يتلوّث الماء عندما تصله موادّ ضارّة تجعله غير صالح للاستعمال، مثل:

- **مياه الصرف** الصناعية والمنزلية التي تُصرَف دون معالجة في الأودية أو البحر.
- **المبيدات والأسمدة** الفلاحية التي تتسرّب إلى المياه الجوفية.
- **النفايات** التي تُرمى في الأنهار والسدود.

للمحافظة على سلامة الماء، يجب: عدم رمي النفايات أو الموادّ الكيميائية في الأودية والسدود، ترشيد استهلاك الماء، وإلزام المصانع بمعالجة مياه صرفها قبل تصريفها.

> 🏆 أصبحت الآن تعرف الفرق بين المزيج المتجانس وغير المتجانس، وكيف تُفصل مكوّنات كلّ مزيج بالترسيب أو الترشيح أو التقطير، وكيف يتحوّل الماء الطبيعي العكر إلى ماء صالح للشرب. في فصل قادم، ستكتشف أسرارًا جديدة عن عالم المادّة!', '# 📜 ملخّص: المزائج وفصل مكوّناتها ومعالجة المياه

- **المزيج المتجانس وغير المتجانس**: متجانس = لا نميّز مكوّناته بالعين المجرّدة (ماء + سكّر مذاب)؛ غير متجانس = نميّز مكوّنَين على الأقلّ (ماء + رمل، ماء + زيت).
- **الترسيب**: ترك مزيج غير متجانس ساكنًا حتّى تستقرّ الحبيبات الثقيلة في القاع (الراسب)؛ لا يزيل الحبيبات الدقيقة جدًّا.
- **الترشيح**: تمرير المزيج على ورقة ترشيح داخل قمع، فتحجز الحبيبات الصلبة ويمرّ السائل الصافي (الراشح)؛ بلا تسخين.
- **التقطير**: تسخين مزيج متجانس حتّى الغليان ثمّ تبريد بخاره ليتكاثف؛ الطريقة الوحيدة لفصل مكوّنات مزيج متجانس (كملح مذاب).
- **معالجة الماء الطبيعي**: ثلاث خطوات مرتّبة وجوبًا — الترسيب ← الترشيح ← التعقيم بالكلور — لتصبح صالحة للشرب.
- **تلوّث الماء والمحافظة عليه**: مياه الصرف الصناعية والمنزلية والمبيدات والنفايات تلوّث الماء؛ المحافظة عليه تتطلّب عدم رمي النفايات فيه ومعالجة مياه الصرف قبل تصريفها.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', 'الهواء والضّغط الجوّيّ', 'الهواء بوصفه مادّة لها كتلة وتشغل حيّزًا، خصائصه (اللون، الرائحة، الشفافية، الشكل، قابلية الانضغاط)، وجود الضغط الجوّي وآثاره في الحياة اليومية، مبدأ قياسه بجهاز البارومتر، وتلوّث الهواء وطرق الحدّ منه', '# ⚔️ الهواء والضّغط الجوّيّ — القوّة الخفيّة التي تحيط بك من كلّ جانب

> 💡 «لا تراه عيناك، ولا تشمّ له رائحة، لكنّه يضغط على جسمك الآن من كلّ الاتّجاهات دون أن تشعر. اكتشف كيف يكون الهواء مادّة حقيقية، وكيف يحمي الضغط الجوّي حياتنا كلّ يوم.»

## 🏰 الهواء مادّة كباقي الموادّ من حولنا

قد يظنّ البعض أنّ الهواء "لا شيء" لأنّنا لا نراه، لكنّ الهواء **مادّة** حقيقية، وله خاصّيّتان تُثبتان ذلك:

- **له كتلة**: إذا وضعنا بالونين فارغَين على طرفَي عصا متوازنة فوق محور، تبقى العصا متّزنة؛ فإذا نفخنا أحد البالونَين بالهواء دون الآخر، يميل الطرف المنفوخ نحو الأسفل. هذا يثبت أنّ الهواء المضاف له كتلة فعلية.
- **يشغل حيّزًا**: إذا قلبنا كأسًا فارغًا رأسًا على عقب وغرسناه مستقيمًا داخل حوض ماء، يبقى منديل ورقي موضوع في قاعه **جافًّا**؛ فالهواء المحبوس داخل الكأس يشغل مكانًا ويمنع الماء من الدخول إليه.

> ⚠️ لا تخلط بين انعدام الرؤية وانعدام الكتلة: الهواء غير مرئي، لكنّه ليس عديم الكتلة؛ فكلّ مادّة، مرئية أو غير مرئية، تشغل حيّزًا ولها كتلة.

## 💨 خصائص الهواء

يتميّز الهواء بمجموعة من الخصائص التي نستنتجها من الملاحظة والتجربة:

| الخاصّية            | الوصف                                                      |
| ------------------- | ---------------------------------------------------------- |
| **اللون**           | عديم اللون (لا لون له)                                     |
| **الرائحة**         | عديم الرائحة في حالته النقيّة                              |
| **الشفافية**        | شفّاف، نرى الأجسام من خلاله بوضوح                          |
| **الشكل**           | ليس له شكل ثابت، يأخذ شكل الإناء الذي يشغله ويملأه بالكامل |
| **قابلية الانضغاط** | يمكن ضغطه فيصغر حجمه، بخلاف الماء الذي يقاوم الانضغاط      |

تجربة توضيحية: نسدّ فتحة محقنة (مِحقن) مملوءة بالهواء بإصبعنا، ثمّ ندفع المِكبس. يتحرّك المِكبس مسافة قصيرة ويصعب دفعه أكثر، ثمّ يعود إلى موضعه فور تحرير اليد. هذا يثبت أنّ الهواء **قابل للانضغاط** لكنّه يقاوم الضغط الزائد ويستعيد حجمه.

> 🗡️ ميّز جيّدًا: قابلية الانضغاط تعني أنّ حجم كمّية معيّنة من الهواء يمكن أن يصغر إذا حصرناها في حيّز أضيق؛ وهذا لا ينطبق على السوائل كالماء التي يبقى حجمها شبه ثابت مهما ضغطنا عليها.

## 🌬️ وجود الضّغط الجوّي: تجربة بسيطة

يحيط بالأرض غلاف من الهواء يُسمّى **الغلاف الجوّي**، وهذا الهواء، رغم خفّته، يضغط باستمرار على كلّ شيء حوله في **جميع الاتّجاهات**؛ وهذا ما نسمّيه **الضغط الجوّي**.

تجربة توضيحية بسيطة: نملأ كأسًا بالماء حتّى حافّته تمامًا، ثمّ نغطّيه ببطاقة مقوّاة رقيقة ونضغط عليها براحة اليد، ثمّ نقلب الكأس رأسًا على عقب فوق حوض بسرعة ونترك البطاقة. نلاحظ أنّ **الماء لا يسقط والبطاقة تبقى ملتصقة بالكأس**.

التفسير: الضغط الجوّي يدفع البطاقة من الأسفل نحو الأعلى بقوّة أكبر من وزن الماء الذي يدفعها نحو الأسفل، فتبقى البطاقة ملتصقة والماء محبوسًا داخل الكأس.

<svg viewBox="0 0 300 214">
<title>الضغط الجوّي يدفع في كلّ الاتّجاهات</title>
<line x1="120" y1="58" x2="180" y2="58" stroke="#0f172a" stroke-width="2.5"/><line x1="120" y1="58" x2="126" y2="150" stroke="#0f172a" stroke-width="2.5"/><line x1="180" y1="58" x2="174" y2="150" stroke="#0f172a" stroke-width="2.5"/><polygon points="121,60 179,60 174,149 126,149" fill="#bfdbfe" stroke="none" stroke-width="2"/><rect x="116" y="150" width="68" height="6" rx="1" fill="#f59e0b" stroke="#0f172a" stroke-width="2"/><line x1="150" y1="196" x2="150" y2="160" stroke="#ef4444" stroke-width="3"/>
<polygon points="150,160 155.5,171 144.5,171" fill="#ef4444"/><line x1="88" y1="104" x2="116" y2="104" stroke="#ef4444" stroke-width="2.5"/>
<polygon points="116,104 107,108.5 107,99.5" fill="#ef4444"/><line x1="212" y1="104" x2="184" y2="104" stroke="#ef4444" stroke-width="2.5"/>
<polygon points="184,104 193,99.5 193,108.5" fill="#ef4444"/><line x1="120" y1="40" x2="132" y2="55" stroke="#ef4444" stroke-width="2.2"/>
<polygon points="132,55 123.88,51.25 130.13,46.25" fill="#ef4444"/><line x1="180" y1="40" x2="168" y2="55" stroke="#ef4444" stroke-width="2.2"/>
<polygon points="168,55 169.87,46.25 176.12,51.25" fill="#ef4444"/><line x1="150" y1="90" x2="150" y2="120" stroke="#0f172a" stroke-width="2"/>
<polygon points="150,120 146,112 154,112" fill="#0f172a"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="205" text-anchor="middle" fill="#ef4444" font-size="12">ضغط جوّي</text><text x="70" y="104" text-anchor="middle" fill="#ef4444" font-size="11">ضغط</text><text x="232" y="104" text-anchor="middle" fill="#ef4444" font-size="11">ضغط</text><text x="150" y="108" text-anchor="middle" fill="#0f172a" font-size="10">وزن الماء</text><text x="150" y="174" text-anchor="middle" fill="#0f172a" font-size="11">بطاقة</text></g>
</svg>

> ⚠️ خطأ شائع: يتخيّل بعض التلاميذ أنّ الضغط الجوّي يؤثّر من الأعلى إلى الأسفل فقط (كأنّه "وزن" يسقط علينا)؛ في الحقيقة يضغط الهواء في **كلّ الاتّجاهات** في الآن نفسه، وهذا بالضبط ما يفسّر بقاء البطاقة ملتصقة من الأسفل في التجربة السابقة.

## ⚡ آثار الضّغط الجوّي في حياتنا اليومية

للضغط الجوّي آثار محسوسة نلاحظها كلّ يوم دون أن ننتبه إليها غالبًا:

- **المصّاصة (القشّة)**: عندما نمصّ الهواء من أعلى المصّاصة، ينخفض الضغط داخلها، فيدفع الضغط الجوّي الخارجي السائل إلى أعلى ليملأ الفراغ.
- **الممصّة (الفنطاسة اللاصقة)**: عند إلصاقها بحائط أملس بعد طرد الهواء من تحتها، يضغط الهواء الخارجي عليها فيثبّتها بقوّة.
- **انسداد الأذنَين**: عند صعود جبل عالٍ أو أثناء إقلاع طائرة أو هبوطها، نشعر بانسداد في أذنَينا بسبب تغيّر الضغط الجوّي المحيط بنا بسرعة.

> ⚠️ لا تخلط بين الضغط الجوّي ودرجة الحرارة: انسداد الأذنَين في الطائرة أو الجبل سببه **تغيّر الضغط الجوّي** مع الارتفاع، لا تغيّر درجة الحرارة.

## 📏 قياس الضّغط الجوّي: البارومتر

الضغط الجوّي ليس ثابتًا: فهو **يتغيّر** بتغيّر الارتفاع عن سطح البحر (يقلّ كلّما ارتفعنا) وبتغيّر حالة الطقس. لقياس هذا الضغط، يستعمل العلماء جهازًا يُسمّى **البارومتر**.

يستعمل خبراء الأرصاد الجوّية البارومتر لمتابعة تغيّرات الضغط الجوّي والمساعدة على التنبّؤ بالطقس: ارتفاع الضغط يبشّر غالبًا بطقس صحو مستقرّ، بينما انخفاضه ينذر غالبًا باقتراب طقس مضطرب أو ممطر. كما يفسّر انخفاض الضغط الجوّي مع الارتفاع صعوبة التنفّس التي يشعر بها متسلّقو الجبال الشاهقة.

> 🗡️ البارومتر للضغط الجوّي، كما أنّ الميزان الحراري (الترمومتر) لدرجة الحرارة: لكلّ ظاهرة جهاز قياسها الخاصّ.

## 🏭 تلوّث الهواء

يتلوّث الهواء عندما تختلط به موادّ ضارّة تُغيّر تركيبته الطبيعية، ومن أبرز مصادر هذا التلوّث:

- **عوادم السيّارات** التي تنفث غازات ضارّة نتيجة احتراق الوقود.
- **دخان المصانع** المنبعث من مداخنها دون تصفية كافية.
- **حرق النفايات** في الهواء الطلق.

يؤدّي تلوّث الهواء إلى أضرار خطيرة: أمراض الجهاز التنفسي عند الإنسان، الإضرار بالنباتات والحيوانات، وتفاقم ظاهرة الاحتباس الحراري. وللحدّ من هذا التلوّث، يجب اعتماد وسائل نقل أنظف (كالدراجة والنقل العمومي)، تصفية انبعاثات المصانع قبل إطلاقها، والإكثار من التشجير الذي ينقّي الهواء.

> 🏆 أصبحت الآن تعرف أنّ الهواء مادّة حقيقية لها كتلة وتشغل حيّزًا، واكتشفت خصائصه، ووجود الضغط الجوّي وآثاره في حياتك اليومية، وكيف يُقاس بالبارومتر، وكيف نحافظ على نقاء الهواء من التلوّث. في فصل قادم، ستكتشف أسرارًا جديدة عن عالم المادّة!', '# 📜 ملخّص: الهواء والضّغط الجوّيّ

- **الهواء مادّة**: له كتلة (تجربة العصا المتوازنة والبالونَين) ويشغل حيّزًا (تجربة الكأس المقلوب في الماء مع منديل يبقى جافًّا).
- **خصائص الهواء**: عديم اللون، عديم الرائحة، شفّاف، بلا شكل ثابت (يأخذ شكل إنائه)، قابل للانضغاط بخلاف الماء.
- **وجود الضغط الجوّي**: الغلاف الجوّي يضغط في جميع الاتّجاهات؛ تجربة الكأس المملوء بالماء والمغطّى ببطاقة مقلوبة تثبت ذلك (البطاقة لا تسقط).
- **آثار الضغط الجوّي**: يفسّر عمل المصّاصة والممصّة اللاصقة وانسداد الأذنَين عند تغيّر الارتفاع بسرعة (طائرة، جبل).
- **قياس الضغط الجوّي**: البارومتر جهاز قياسه؛ الضغط يقلّ مع الارتفاع ويساعد رصد تغيّراته على التنبّؤ بالطقس.
- **تلوّث الهواء**: مصادره عوادم السيّارات ودخان المصانع وحرق النفايات؛ يضرّ بالصحّة والبيئة؛ يُحدّ منه بوسائل نقل نظيفة وتصفية الانبعاثات والتشجير.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', 'الدّارة الكهربائية والموصلات والعوازل', 'مكوّنات دارة كهربائية بسيطة (مولّد، مصباح أو محرّك، قاطع، أسلاك) ورموزها الاصطلاحية، الفرق بين الدارة المفتوحة والدارة المغلقة ودور القاطع، الموادّ الناقلة للتيّار الكهربائي والموادّ العازلة، ومبادئ الأمان الكهربائي مع مقدّمة إلى الدارة القصيرة', '# ⚔️ الدّارة الكهربائية والموصلات والعوازل — كيف يضيء المصباح؟

> 💡 «تضغط على القاطع فيضيء المصباح فورًا. ما الذي يحدث بالضبط داخل الأسلاك؟ اكتشف مكوّنات أبسط دارة كهربائية، ولماذا تنقل بعض الموادّ الكهرباء بينما ترفضها موادّ أخرى تمامًا.»

## 🏰 مكوّنات الدارة الكهربائية البسيطة

**الدارة الكهربائية** حلقة مغلقة من عناصر متّصلة فيما بينها تسمح بمرور **التيّار الكهربائي**. الدارة الكهربائية **البسيطة** التي ندرسها هنا تحتوي على أربعة عناصر أساسية فقط، متّصلة على التوالي في حلقة واحدة:

| العنصر                        | دوره في الدارة                                                            |
| ----------------------------- | ------------------------------------------------------------------------- |
| **المولّد** (عمود أو بطّارية) | يزوّد الدارة بالطاقة اللازمة لجريان التيّار؛ له قطبان: موجب (+) وسالب (−) |
| **المستقبل** (مصباح أو محرّك) | يستقبل الطاقة الكهربائية ويحوّلها: المصباح إلى ضوء، والمحرّك إلى حركة     |
| **القاطع** (المفتاح)          | يتحكّم في فتح الدارة أو غلقها عن قصد                                      |
| **أسلاك التوصيل**             | تربط جميع العناصر ببعضها لتكوّن حلقة واحدة متّصلة                         |

> 🗡️ في هذا الفصل، تحتوي دارتنا دائمًا على **مستقبل واحد فقط** (مصباح أو محرّك) موصول في حلقة واحدة مع المولّد والقاطع. ترتيب عدّة مستقبلات في نفس الدارة موضوع ستكتشفه في سنة قادمة.

## ⚡ الرموز الاصطلاحية للدارة الكهربائية

لرسم دارة كهربائية بسرعة ووضوح دون رسم كلّ عنصر بشكله الحقيقي، يتّفق العلماء على **رموز اصطلاحية** موحّدة يعرفها الجميع:

| العنصر             | وصف رمزه الاصطلاحي                                                                                           |
| ------------------ | ------------------------------------------------------------------------------------------------------------ |
| **المولّد**        | خطّان متوازيان غير متساويين الطول: الخطّ الطويل يمثّل القطب الموجب (+)، والخطّ القصير يمثّل القطب السالب (−) |
| **المصباح**        | دائرة صغيرة بداخلها علامة تقاطع (×)                                                                          |
| **المحرّك**        | دائرة صغيرة بداخلها الحرف M                                                                                  |
| **القاطع المفتوح** | خطّ مستقيم منقطع في نقطة، تاركًا فجوة بين طرفَيه                                                             |
| **القاطع المغلق**  | خطّ مستقيم متّصل بلا أيّ انقطاع                                                                              |
| **أسلاك التوصيل**  | خطوط مستقيمة تربط بين رموز العناصر                                                                           |

> ⚠️ لا تخلط بين رمز المصباح (دائرة بداخلها ×) ورمز المحرّك (دائرة بداخلها M): كلاهما مستقبل، لكن أحدهما يضيء والآخر يدور.

## 🔌 الدارة المفتوحة والدارة المغلقة: دور القاطع

- **الدارة المغلقة**: حلقة متّصلة بالكامل من المولّد إلى المستقبل وعودةً إلى المولّد دون أيّ انقطاع، فيجري فيها التيّار الكهربائي ويعمل المستقبل (يضيء المصباح أو يدور المحرّك).
- **الدارة المفتوحة**: توجد فجوة أو انقطاع في مكان واحد على الأقلّ من الحلقة (سلك مقطوع، أو قاطع مفتوح)، فلا يجري التيّار الكهربائي ويتوقّف المستقبل عن العمل تمامًا.

**دور القاطع** هو التحكّم عن قصد في هذا الانقطاع: عندما نغلق القاطع، نصل طرفَيه فتُغلَق الدارة كاملةً ويضيء المصباح؛ وعندما نفتح القاطع، نفصل طرفَيه فتُفتَح الدارة ويُطفَأ المصباح فورًا.

<svg viewBox="0 0 205 168">
<title>دارة مغلقة: التيّار يجري والمصباح يضيء</title>
<line x1="40" y1="28" x2="40" y2="62" stroke="#0f172a" stroke-width="2.5"/><line x1="25" y1="62" x2="55" y2="62" stroke="#0f172a" stroke-width="2.5"/><line x1="34" y1="74" x2="46" y2="74" stroke="#0f172a" stroke-width="4"/><line x1="40" y1="74" x2="40" y2="112" stroke="#0f172a" stroke-width="2.5"/><line x1="40" y1="28" x2="88" y2="28" stroke="#0f172a" stroke-width="2.5"/><circle cx="100" cy="28" r="11" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="92.3" y1="20.3" x2="107.7" y2="35.7" stroke="#0f172a" stroke-width="2"/><line x1="92.3" y1="35.7" x2="107.7" y2="20.3" stroke="#0f172a" stroke-width="2"/><line x1="114" y1="28" x2="120" y2="28" stroke="#d97706" stroke-width="2"/><line x1="109.9" y1="37.9" x2="114.14" y2="42.14" stroke="#d97706" stroke-width="2"/><line x1="100" y1="42" x2="100" y2="48" stroke="#d97706" stroke-width="2"/><line x1="90.1" y1="37.9" x2="85.86" y2="42.14" stroke="#d97706" stroke-width="2"/><line x1="86" y1="28" x2="80" y2="28" stroke="#d97706" stroke-width="2"/><line x1="90.1" y1="18.1" x2="85.86" y2="13.86" stroke="#d97706" stroke-width="2"/><line x1="100" y1="14" x2="100" y2="8" stroke="#d97706" stroke-width="2"/><line x1="109.9" y1="18.1" x2="114.14" y2="13.86" stroke="#d97706" stroke-width="2"/><line x1="112" y1="28" x2="165" y2="28" stroke="#0f172a" stroke-width="2.5"/><line x1="165" y1="28" x2="165" y2="112" stroke="#0f172a" stroke-width="2.5"/><line x1="165" y1="112" x2="118" y2="112" stroke="#0f172a" stroke-width="2.5"/><line x1="82" y1="112" x2="40" y2="112" stroke="#0f172a" stroke-width="2.5"/><circle cx="118" cy="112" r="3" fill="#0f172a" stroke="none" stroke-width="2"/><circle cx="82" cy="112" r="3" fill="#0f172a" stroke="none" stroke-width="2"/><line x1="118" y1="112" x2="82" y2="112" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="64" y="60" text-anchor="start" fill="#0f172a" font-size="13">+</text><text x="64" y="80" text-anchor="start" fill="#0f172a" font-size="13">−</text><text x="100" y="58" text-anchor="middle" fill="#0f172a" font-size="11">مصباح</text><text x="100" y="128" text-anchor="middle" fill="#0f172a" font-size="11">قاطع</text><text x="22" y="70" text-anchor="middle" fill="#0f172a" font-size="11">مولّد</text></g><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="103" y="156" text-anchor="middle" fill="#0f6e56" font-size="13">دارة مغلقة</text></g>
</svg>

<svg viewBox="0 0 205 168">
<title>دارة مفتوحة: لا تيّار والمصباح مطفأ</title>
<line x1="40" y1="28" x2="40" y2="62" stroke="#0f172a" stroke-width="2.5"/><line x1="25" y1="62" x2="55" y2="62" stroke="#0f172a" stroke-width="2.5"/><line x1="34" y1="74" x2="46" y2="74" stroke="#0f172a" stroke-width="4"/><line x1="40" y1="74" x2="40" y2="112" stroke="#0f172a" stroke-width="2.5"/><line x1="40" y1="28" x2="88" y2="28" stroke="#0f172a" stroke-width="2.5"/><circle cx="100" cy="28" r="11" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="92.3" y1="20.3" x2="107.7" y2="35.7" stroke="#0f172a" stroke-width="2"/><line x1="92.3" y1="35.7" x2="107.7" y2="20.3" stroke="#0f172a" stroke-width="2"/><line x1="112" y1="28" x2="165" y2="28" stroke="#0f172a" stroke-width="2.5"/><line x1="165" y1="28" x2="165" y2="112" stroke="#0f172a" stroke-width="2.5"/><line x1="165" y1="112" x2="118" y2="112" stroke="#0f172a" stroke-width="2.5"/><line x1="82" y1="112" x2="40" y2="112" stroke="#0f172a" stroke-width="2.5"/><circle cx="118" cy="112" r="3" fill="#0f172a" stroke="none" stroke-width="2"/><circle cx="82" cy="112" r="3" fill="#0f172a" stroke="none" stroke-width="2"/><line x1="118" y1="112" x2="90" y2="92" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="64" y="60" text-anchor="start" fill="#0f172a" font-size="13">+</text><text x="64" y="80" text-anchor="start" fill="#0f172a" font-size="13">−</text><text x="100" y="58" text-anchor="middle" fill="#0f172a" font-size="11">مصباح</text><text x="100" y="128" text-anchor="middle" fill="#0f172a" font-size="11">قاطع</text><text x="22" y="70" text-anchor="middle" fill="#0f172a" font-size="11">مولّد</text></g><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="103" y="156" text-anchor="middle" fill="#ef4444" font-size="13">دارة مفتوحة</text></g>
</svg>

> 🗡️ تذكّر القاعدة الذهبية: **دارة مغلقة = تيّار يجري = مستقبل يعمل**. **دارة مفتوحة، ولو في نقطة واحدة فقط = لا تيّار إطلاقًا = مستقبل متوقّف بالكامل**، حتّى لو كانت بقية الحلقة متّصلة بإحكام.

## 🛡️ الموادّ الناقلة والموادّ العازلة للتيّار الكهربائي

لا تسمح كلّ الموادّ بمرور التيّار الكهربائي بالطريقة نفسها؛ نميّز صنفَين:

| الصنف                    | التعريف                                        | أمثلة                                                                                                            |
| ------------------------ | ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **موادّ ناقلة (موصّلة)** | تسمح بمرور التيّار الكهربائي عبرها بسهولة      | النحاس (لبّ الأسلاك)، الألمنيوم، الحديد ومعظم المعادن، الماء الذي يحوي أملاحًا مذابة (كماء الصنبور)، جسم الإنسان |
| **موادّ عازلة**          | تمنع مرور التيّار الكهربائي عبرها منعًا تامًّا | البلاستيك (غلاف الأسلاك)، المطّاط، الخشب الجافّ، الزجاج، الهواء الجافّ، الورق والقماش الجافّان                   |

> ⚠️ الخطأ الشائع: الاعتقاد بأنّ سلك التوصيل مصنوع كلّه من مادّة واحدة. في الحقيقة، لبّ السلك المعدني (النحاس مثلًا) **ناقل** ينقل التيّار، بينما غلافه البلاستيكي **عازل** يمنع التيّار من الانتقال إلى يد من يمسك السلك — وهذا هو سبب استعمال البلاستيك لتغليف الأسلاك أصلًا.

> 🗡️ قاعدة عملية: أغلب **المعادن** موادّ ناقلة، بينما أغلب موادّ **البلاستيك والمطّاط والخشب الجافّ والزجاج** عازلة. الماء العادي (غير النقيّ) ناقل بسبب الأملاح المذابة فيه، وهذا ما يجعل الاقتراب من الكهرباء بيدين مبلّلتين خطيرًا جدًّا.

## ⚠️ الأمان الكهربائي والدارة القصيرة

التيّار الكهربائي مفيد جدًّا لكنّه قد يكون خطيرًا إن لم نحترم قواعد السلامة:

- لا تلمس أبدًا سلكًا كهربائيًّا عاريًا أو مقبسًا (بريز) بيدين مبلّلتين، لأنّ الماء ناقل يزيد من خطر الصعقة الكهربائية.
- لا تُدخل أيّ جسم معدني (مفتاح، مسمار) في مقبس كهربائي.
- افصل التيّار دائمًا قبل محاولة إصلاح أيّ عطل كهربائي في المنزل.

**الدارة القصيرة** تحدث عندما يلتقي القطبان الموجب والسالب للمولّد مباشرة بسلك ناقل واحد، **دون المرور عبر أيّ مستقبل** (مصباح أو محرّك). في هذه الحالة يندفع تيّار كهربائي قويّ جدًّا وفجائي في السلك، فيسخن بشدّة وقد يسبّب حريقًا أو يتلف المولّد نفسه.

> ⚠️ لا تخلط بين الدارة المفتوحة والدارة القصيرة: الدارة المفتوحة توقف التيّار تمامًا (لا خطر فيها)، بينما الدارة القصيرة تسمح بمرور تيّار قويّ وخطير جدًّا لأنّها تصل القطبين مباشرة دون أيّ مستقبل يستهلك هذه الطاقة.

## 🎓 خلاصة السنة: رحلتك في العلوم الفيزيائية

هذا الفصل هو محطّتك الأخيرة هذه السنة في العلوم الفيزيائية! لقد اكتشفت خلالها:

- **حالات المادّة الثلاث** (صلبة، سائلة، غازية) ونموذج الجسيمات الذي يفسّرها.
- **أهمّية الماء ومصادره** الطبيعية والكشف عنه بكبريتات النحاس اللامائية.
- **تغيّرات حالة الماء** (الانصهار، التصلّب، التبخّر، الغليان، التكاثف) ودورة الماء في الطبيعة.
- **فصل مكوّنات المزائج** (الترسيب، الترشيح، التقطير) ومعالجة الماء الطبيعي ليصبح صالحًا للشرب.
- **الهواء والضغط الجوّي** وخصائص الهواء بوصفه مادّة لها كتلة.
- وأخيرًا، **الدارة الكهربائية البسيطة** ومكوّناتها، والموادّ الناقلة والعازلة، ومبادئ الأمان الكهربائي.

> 🏆 أصبحت الآن تعرف كيف تُبنى دارة كهربائية بسيطة، وكيف تفرّق بين الدارة المفتوحة والمغلقة، وأيّ الموادّ تنقل الكهرباء وأيّها تعزلها، وكيف تتعامل معها بأمان. لقد أتممت رحلة العلوم الفيزيائية لهذه السنة بنجاح — أنت جاهز لتحدّيات السنة القادمة!', '# 📜 ملخّص: الدارة الكهربائية والموصلات والعوازل

- **مكوّنات الدارة البسيطة**: المولّد (يزوّد بالطاقة، له قطبان + و−)، المستقبل (مصباح أو محرّك، واحد فقط في هذا الفصل)، القاطع (يتحكّم في فتح/غلق الدارة)، وأسلاك التوصيل (تربط كلّ شيء في حلقة واحدة).
- **الرموز الاصطلاحية**: خطّان متفاوتا الطول للمولّد، دائرة بها × للمصباح، دائرة بها M للمحرّك، خطّ منقطع للقاطع المفتوح وخطّ متّصل للقاطع المغلق.
- **الدارة المغلقة والمفتوحة**: دارة مغلقة (حلقة متّصلة بالكامل) = تيّار يجري = المستقبل يعمل؛ دارة مفتوحة (انقطاع في نقطة واحدة على الأقلّ) = لا تيّار = المستقبل متوقّف.
- **الموادّ الناقلة**: تسمح بمرور التيّار بسهولة — معظم المعادن (نحاس، ألمنيوم، حديد) والماء الذي يحوي أملاحًا مذابة وجسم الإنسان.
- **الموادّ العازلة**: تمنع مرور التيّار تمامًا — البلاستيك، المطّاط، الخشب الجافّ، الزجاج، الهواء الجافّ.
- **الأمان الكهربائي**: لا تلمس الأسلاك أو المقابس بيدين مبلّلتين، ولا تُدخل أجسامًا معدنية في المقابس، وافصل التيّار قبل أيّ إصلاح.
- **الدارة القصيرة**: التقاء القطبين مباشرة بسلك ناقل واحد دون المرور عبر مستقبل، فيندفع تيّار قويّ فجائي قد يسبّب حريقًا أو يتلف المولّد.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bb5012b6-9312-5af9-89d2-24660bc58d99', '38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('82b7df52-1245-54ca-bcd5-bf52b5155411', 'bb5012b6-9312-5af9-89d2-24660bc58d99', 'ما المقصود بـ''الجسم'' في دراسة المادّة؟', '[{"id":"a","text":"كلّ ما يشغل حيّزًا من الفضاء وله كتلة"},{"id":"b","text":"قطعة محدّدة من المادّة لها حدود واضحة"},{"id":"c","text":"الحالة الوحيدة التي تتّخذها المادّة"},{"id":"d","text":"أداة تُستعمل لقياس حجم السوائل"}]'::jsonb, 'b', 'الجسم قطعة محدّدة من المادّة لها حدود واضحة تميّزها عمّا حولها، كالكرسي أو قطرة الماء؛ أمّا الخيار الأول فهو وصف عامّ للمادّة نفسها لا للجسم تحديدًا.', 1, 'mcq', NULL, NULL)
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
  ('60f03e17-5782-5aa7-97b3-bd4e1823608f', 'bb5012b6-9312-5af9-89d2-24660bc58d99', 'أيّ الأجسام التالية في حالة صلبة؟', '[{"id":"a","text":"الحليب"},{"id":"b","text":"الزيت"},{"id":"c","text":"الحجر"},{"id":"d","text":"بخار الماء"}]'::jsonb, 'c', 'الحجر جسم صلب يحافظ على شكله وحجمه الخاصّين، أمّا الحليب والزيت فسائلان وبخار الماء غاز.', 2, 'mcq', NULL, NULL)
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
  ('0bc8a57d-0d32-5d39-8fa5-a0a2c4f59ae1', 'bb5012b6-9312-5af9-89d2-24660bc58d99', 'ما الذي يميّز الحالة السائلة عن الحالة الصلبة؟', '[{"id":"a","text":"السائل يأخذ شكل إنائه والصلب يحافظ على شكله الخاصّ"},{"id":"b","text":"السائل ليس له حجم مطلقًا"},{"id":"c","text":"الصلب يتغيّر شكله من تلقاء نفسه"},{"id":"d","text":"لا فرق بينهما"}]'::jsonb, 'a', 'السائل لا شكل خاصّ ثابت له فيتبع شكل إنائه، بينما الجسم الصلب يحافظ على شكله الخاصّ مهما نُقل.', 3, 'mcq', NULL, NULL)
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
  ('c75d1d3d-fa3e-50f1-9509-85bb645e7f0a', 'bb5012b6-9312-5af9-89d2-24660bc58d99', 'لماذا يملأ الهواء المحبوس داخل بالون منتفخ كامل حجم البالون؟', '[{"id":"a","text":"لأنّ جسيماته مرتّبة ومتلاصقة"},{"id":"b","text":"لأنّ حجمه صفر أصلًا"},{"id":"c","text":"لأنّ شكله الخاصّ ثابت دائمًا"},{"id":"d","text":"لأنّ جسيماته متباعدة وتتحرّك بحرّية في كلّ الاتّجاهات"}]'::jsonb, 'd', 'في الحالة الغازية تكون الجسيمات متباعدة جدًّا وتتحرّك بحرّية تامّة في كلّ الاتّجاهات، فتنتشر لتملأ كامل الحيّز المتاح لها.', 4, 'mcq', NULL, NULL)
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
  ('d9a446fa-0386-5031-8a07-c10479842f2a', 'bb5012b6-9312-5af9-89d2-24660bc58d99', 'جسمٌ يحافظ على حجمه الثابت، لكنّه يأخذ شكل الإناء الذي يُسكب فيه في كلّ مرّة. ما حالته الفيزيائية؟', '[{"id":"a","text":"صلبة"},{"id":"b","text":"سائلة"},{"id":"c","text":"غازية"},{"id":"d","text":"لا يمكن تحديد حالته من هذه المعطيات"}]'::jsonb, 'b', 'الحفاظ على حجم ثابت مع تغيّر الشكل حسب الإناء هما خاصّيّتا الحالة السائلة تحديدًا.', 5, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', '38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', '⭐ تمرين: المادّة وحالاتها الفيزيائية', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7d749e40-b404-5cde-9c95-9fbaa75de700', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'الطاولة قطعة محدّدة من مادّة الخشب لها حدود واضحة. ماذا نسمّي الطاولة في هذه الحالة؟', '[{"id":"a","text":"جسم"},{"id":"b","text":"مادّة"},{"id":"c","text":"حالة فيزيائية"},{"id":"d","text":"حيّز"}]'::jsonb, 'a', 'نسمّي أيّ قطعة محدّدة من المادّة لها حدود واضحة ''جسمًا''؛ والخشب هو المادّة التي صُنعت منها الطاولة.', 1, 'mcq', NULL, NULL)
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
  ('98c34492-bd01-53ad-91e6-504ae6570965', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'أيّ الأمثلة التالية جسم في الحالة الغازية؟', '[{"id":"a","text":"الجليد"},{"id":"b","text":"العسل"},{"id":"c","text":"الهواء داخل بالون منتفخ"},{"id":"d","text":"الحجر"}]'::jsonb, 'c', 'هواء البالون غاز لأنّه لا شكل خاصّ ولا حجم ثابت له، ويأخذ شكل وحجم البالون الذي يُحبَس فيه.', 2, 'mcq', NULL, NULL)
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
  ('33cdf4b2-bb86-595c-9647-ba27d8741350', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'عند نقل قطعة حجر من مكان إلى آخر، ماذا يحدث لشكلها؟', '[{"id":"a","text":"يتغيّر باستمرار"},{"id":"b","text":"يبقى كما هو دون تغيّر"},{"id":"c","text":"يصبح مستديرًا دائمًا"},{"id":"d","text":"يختفي شكلها"}]'::jsonb, 'b', 'الجسم الصلب كالحجر يحافظ على شكله الخاصّ مهما غُيّر مكانه أو وضعه.', 3, 'mcq', NULL, NULL)
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
  ('796f552c-cacb-5b2a-8985-69420ddc9ad5', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'عندما نسكب كمّية من الزيت من كأس إلى قارورة، ماذا يتغيّر فيها وماذا يبقى ثابتًا؟', '[{"id":"a","text":"يتغيّر حجمها ويبقى شكلها ثابتًا"},{"id":"b","text":"يتغيّر كلّ من شكلها وحجمها"},{"id":"c","text":"لا يتغيّر أيّ منهما"},{"id":"d","text":"يتغيّر شكلها ويبقى حجمها ثابتًا"}]'::jsonb, 'd', 'السائل يأخذ في كلّ مرّة شكل الإناء الذي يُسكب فيه، لكنّ كمّيته (حجمه) تبقى ثابتة دون تغيّر.', 4, 'mcq', NULL, NULL)
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
  ('b13d0d45-47d1-5936-9017-172f1d71a932', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'لماذا ينتشر عطرٌ رُشّ في ركن غرفة ليصل بعد قليل إلى كلّ أرجائها؟', '[{"id":"a","text":"لأنّ العطر جسم صلب ينزلق على الأرض"},{"id":"b","text":"لأنّ العطر غاز تتحرّك جسيماته بحرّية فتملأ كامل حيّز الغرفة"},{"id":"c","text":"لأنّ العطر سائل يسيل على الجدران"},{"id":"d","text":"لأنّ نوافذ الغرفة مفتوحة دائمًا"}]'::jsonb, 'b', 'بخار العطر غاز، وجسيماته متباعدة ومتحرّكة بحرّية في كلّ الاتّجاهات، فينتشر ليملأ كامل حيّز الغرفة، لا جزءًا منها فقط.', 5, 'mcq', NULL, NULL)
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
  ('67409778-b9fe-54c5-806e-0b6ffaa35065', '4a675a51-ac33-55b2-b2e1-cddad1a3eaa2', 'الماء السائل، وقطعة الجليد، وبخار الماء المتصاعد من كأس ساخن: الثلاثة مكوّنة من نفس مادّة الماء، لكنّها تختلف في:', '[{"id":"a","text":"نوع المادّة نفسها"},{"id":"b","text":"كونها أجسامًا لا موادّ"},{"id":"c","text":"حالتها الفيزيائية فقط"},{"id":"d","text":"عدم إمكانية تصنيفها ضمن الحالات الثلاث"}]'::jsonb, 'c', 'الماء والجليد وبخار الماء مادّة واحدة (الماء) لكنّها تظهر هنا في ثلاث حالات فيزيائية مختلفة: سائلة وصلبة وغازية.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', '38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: خصائص الحالات الثلاث ونموذج الجسيمات', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7481f802-4215-5af8-9cb9-ed5071d327d1', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', 'كيف تترتّب الجسيمات وتتحرّك في الحالة الصلبة؟', '[{"id":"a","text":"مرتّبة ومتلاصقة، تهتزّ في مكانها فقط"},{"id":"b","text":"متباعدة جدًّا، تتحرّك بسرعة كبيرة"},{"id":"c","text":"متقاربة، تتزحلق فوق بعضها بحرّية"},{"id":"d","text":"لا نظام لها، تتحرّك عشوائيًّا بسرعة"}]'::jsonb, 'a', 'في الحالة الصلبة، الجسيمات مرتّبة ترتيبًا منتظمًا ومتلاصقة بشدّة، ولا تتحرّك إلّا اهتزازًا خفيفًا في مكانها، وهذا ما يجعل الجسم الصلب يحافظ على شكله وحجمه معًا.', 1, 'mcq', NULL, NULL)
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
  ('405f3247-2231-55e5-a894-5c143d7bf0f7', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', 'ما الذي يفسّر أنّ السائل يحافظ على حجمه الثابت رغم أنّه يغيّر شكله بتغيّر إنائه؟', '[{"id":"a","text":"جسيماته متباعدة جدًّا فتنتشر بحرّية"},{"id":"b","text":"جسيماته متقاربة فتحافظ على نفس الكمّية، لكنّها تتزحلق فوق بعضها"},{"id":"c","text":"جسيماته مرتّبة ومتلاصقة تمامًا كالصلب"},{"id":"d","text":"ليس للسائل جسيمات أصلًا"}]'::jsonb, 'b', 'جسيمات السائل متقاربة من بعضها (لا فراغات كبيرة بينها)، وهو ما يحافظ على حجمها الثابت، لكنّها قادرة على التزحلق والحركة النسبية فوق بعضها، وهو ما يُغيّر شكل السائل حسب إنائه.', 2, 'mcq', NULL, NULL)
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
  ('298599fe-93d7-5a9f-b34f-73a5ec9e0608', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', 'جسمٌ جسيماته متباعدة جدًّا وتتحرّك بسرعة كبيرة في كلّ الاتّجاهات، فينتشر ليملأ أيّ حيّز يوضع فيه. ما حالته؟', '[{"id":"a","text":"صلبة"},{"id":"b","text":"سائلة"},{"id":"c","text":"غازية"},{"id":"d","text":"لا يمكن تحديدها بهذا الوصف"}]'::jsonb, 'c', 'تباعد الجسيمات الكبير وحركتها الحرّة السريعة في كلّ الاتّجاهات هما بالضبط ما يميّز نموذج الجسيمات في الحالة الغازية.', 3, 'mcq', NULL, NULL)
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
  ('2b3be3b8-7ff0-5210-8f08-36c243d84962', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', 'وُضع جسم مجهول في كأس فأخذ شكل الكأس، ثمّ نُقل إلى صحن مسطّح فانتشر عليه حتّى غطّى كامل سطحه دون توقّف عند حدّ معيّن، فتبيّن أنّ حجمه لا يبقى ثابتًا. ما حالته الفيزيائية؟', '[{"id":"a","text":"صلبة، لأنّه أخذ شكل الكأس"},{"id":"b","text":"سائلة، لأنّ حجمه ثابت"},{"id":"c","text":"غازية، لأنّه لا شكل خاصّ له ولا حجم ثابت"},{"id":"d","text":"لا يمكن أن تكون هذه الملاحظات صحيحة معًا"}]'::jsonb, 'c', 'غياب الشكل الخاصّ معًا مع عدم ثبات الحجم (الانتشار الكامل دون حدّ) هما الدليل القاطع على الحالة الغازية؛ لو كان سائلًا لبقي حجمه ثابتًا رغم انتشاره على السطح.', 4, 'mcq', NULL, NULL)
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
  ('6b4e1d17-d431-5ba2-83ea-937423614f37', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', 'أيّ العبارات التالية **خاطئة**؟', '[{"id":"a","text":"الغاز يحافظ على شكله لكن لا يحافظ على حجمه"},{"id":"b","text":"الجسم الصلب يحافظ على شكله وحجمه معًا"},{"id":"c","text":"السائل يحافظ على حجمه لكن لا يحافظ على شكله"},{"id":"d","text":"الغاز لا يحافظ لا على شكله ولا على حجمه"}]'::jsonb, 'a', 'العبارة الصحيحة أنّ الغاز لا شكل خاصّ ثابت له إطلاقًا، لا أنّه ''يحافظ على شكله''؛ فالعبارة الأولى معكوسة وتصف الغاز خطأً وكأنّ له شكلًا ثابتًا، بينما الصحيح أنّه لا شكل ثابت له ولا حجم ثابت (كما في العبارة الرابعة).', 5, 'mcq', NULL, NULL)
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
  ('d07ab397-eb75-5f71-927c-9293dd65030a', 'd5bedad5-e857-5c51-a5c2-30f5fa2f1b4e', 'بالمقارنة بين الحالة الصلبة والحالة الغازية من حيث ترتيب الجسيمات وحركتها، ما الصحيح؟', '[{"id":"a","text":"الجسيمات في الحالتين متلاصقة ومرتّبة بنفس الطريقة"},{"id":"b","text":"في الصلبة الجسيمات متلاصقة ومرتّبة تهتزّ فقط، وفي الغازية متباعدة جدًّا وتتحرّك بحرّية"},{"id":"c","text":"في الصلبة الجسيمات متباعدة، وفي الغازية متلاصقة"},{"id":"d","text":"لا فرق بين الحالتين من حيث الجسيمات"}]'::jsonb, 'b', 'الفرق جوهري: في الصلب تلاصق وترتيب صارم مع اهتزاز مكاني فقط، وفي الغاز تباعد كبير جدًّا مع حركة حرّة سريعة في كلّ الاتّجاهات، وهذا الاختلاف هو ما يفسّر تناقض ثبات شكل وحجم الصلب مع انعدامهما في الغاز.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1478fd2d-2c8a-5512-964b-736fb49c6a0d', '38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): المادّة وحالاتها', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6008464f-aaed-50a4-b4cc-4e2372ce129d', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'الملعقة المعدنية جسم له حدود واضحة وشكل محدّد، وهي مصنوعة من مادّة المعدن. ما الذي يجعلها ''جسمًا'' بالتحديد؟', '[{"id":"a","text":"كونها قطعة محدّدة من المادّة لها حدود واضحة"},{"id":"b","text":"كونها لامعة"},{"id":"c","text":"كونها ذات وزن كبير"},{"id":"d","text":"كونها تُستعمل لتناول الطعام"}]'::jsonb, 'a', 'يُسمّى ''جسمًا'' كلّ قطعة محدّدة من المادّة لها حدود واضحة تميّزها عمّا حولها، بصرف النظر عن لمعانها أو استعمالها.', 1, 'mcq', NULL, NULL)
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
  ('e9a922d8-b494-575d-b36c-b3c716c3e8f3', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'العسل يسيل ببطء ويأخذ شكل الإناء الذي يوضع فيه مع محافظته على كمّيته (حجمه). في أيّ حالة فيزيائية يُصنَّف؟', '[{"id":"a","text":"صلبة"},{"id":"b","text":"سائلة"},{"id":"c","text":"غازية"},{"id":"d","text":"لا يمكن تصنيفه لأنّه لزج"}]'::jsonb, 'b', 'رغم لزوجة العسل، فإنّه يأخذ شكل إنائه ويحافظ على حجمه الثابت، وهما خاصّيّتا الحالة السائلة، بصرف النظر عن سرعة سيلانه.', 2, 'mcq', NULL, NULL)
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
  ('76f5132d-be87-5d88-8bcf-f68653560d2f', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'الدخان المتصاعد من مدخنة ينتشر تدريجيًّا في الهواء المحيط دون أن يحافظ على شكل أو حجم معيّن. في أيّ حالة فيزيائية هو؟', '[{"id":"a","text":"صلبة"},{"id":"b","text":"سائلة"},{"id":"c","text":"غازية"},{"id":"d","text":"خليط لا حالة له"}]'::jsonb, 'c', 'انعدام الشكل الخاصّ والحجم الثابت معًا، مع الانتشار في الهواء المحيط، دليل على أنّ الدخان في الحالة الغازية.', 3, 'mcq', NULL, NULL)
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
  ('3205c4c2-3119-5318-8940-ec870ab7d09a', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'أيّ الأزواج التالية (الحالة – الحجم) صحيح؟', '[{"id":"a","text":"صلبة – حجم متغيّر"},{"id":"b","text":"سائلة – حجم غير ثابت"},{"id":"c","text":"غازية – حجم ثابت دائمًا"},{"id":"d","text":"صلبة – حجم ثابت"}]'::jsonb, 'd', 'الحالتان الصلبة والسائلة كلتاهما لهما حجم ثابت، أمّا الغازية فحجمها متغيّر يملأ إناءه؛ من الأزواج المذكورة، فقط ''صلبة – حجم ثابت'' صحيح.', 4, 'mcq', NULL, NULL)
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
  ('bbb50eeb-56c9-5b13-9a59-e8987104fef8', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'أيّ الحالتين ليس لهما شكل خاصّ ثابت؟', '[{"id":"a","text":"الصلبة والسائلة"},{"id":"b","text":"السائلة والغازية"},{"id":"c","text":"الصلبة والغازية"},{"id":"d","text":"لا توجد حالة بدون شكل خاصّ"}]'::jsonb, 'b', 'الحالة السائلة والحالة الغازية كلتاهما ليس لهما شكل خاصّ ثابت، فكلتاهما تأخذان شكل الإناء الذي توضعان فيه؛ أمّا الصلبة فلها شكل خاصّ ثابت.', 5, 'mcq', NULL, NULL)
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
  ('2b4f8eed-274f-5202-9b10-3b0d3af7e65e', '1478fd2d-2c8a-5512-964b-736fb49c6a0d', 'الماء السائل والجليد الصلب: نفس المادّة (الماء) لكنّ ترتيب وحركة جسيماتها يختلف. أيّ وصف صحيح؟', '[{"id":"a","text":"الجسيمات في الحالتين متماثلة تمامًا لأنّها نفس المادّة"},{"id":"b","text":"في الماء السائل الجسيمات متباعدة جدًّا وسريعة الحركة، وفي الجليد مرتّبة تمامًا"},{"id":"c","text":"في الماء السائل جسيمات مرتّبة، وفي الجليد جسيمات متباعدة"},{"id":"d","text":"في الماء السائل الجسيمات متقاربة وتتزحلق فوق بعضها، وفي الجليد مرتّبة ومتلاصقة تهتزّ فقط"}]'::jsonb, 'd', 'رغم أنّ الماء والجليد مادّة واحدة، يختلف ترتيب وحركة جسيماتها باختلاف الحالة: في السائل تبقى متقاربة لكنّها متحرّكة ومتزحلقة، وفي الصلب (الجليد) تكون مرتّبة ومتلاصقة تمامًا ولا تتحرّك إلّا اهتزازًا في مكانها.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f2d94e62-d50e-5af0-a767-27d67154a62c', '38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: تمييز حالات المادّة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('669c7ba8-33af-5258-b230-1c5cf112e1f4', 'f2d94e62-d50e-5af0-a767-27d67154a62c', 'يمكن سكب الرمل الناعم من كيس إلى إناء فيبدو الأمر شبيهًا بسكب سائل. ما الحالة الفيزيائية الصحيحة للرمل؟', '[{"id":"a","text":"سائلة، لأنّه يُسكب بسهولة"},{"id":"b","text":"غازية، لأنّه ينتشر عند سكبه"},{"id":"c","text":"صلبة، فكلّ حبّة رمل تحافظ على شكلها وحجمها"},{"id":"d","text":"لا يمكن تصنيف الرمل ضمن أيّ من الحالات الثلاث"}]'::jsonb, 'c', 'الخطأ الشائع هو الحكم من مجرّد قابلية السكب فقط. لكنّ كلّ حبّة رمل منفردة جسمٌ صلب يحافظ على شكله وحجمه الخاصّين، والتراصّ الظاهري لمجموع الحبيبات هو ما يعطي انطباعًا خادعًا بالسيولة، بينما المادّة الحقيقية (كلّ حبّة) صلبة.', 1, 'mcq', NULL, NULL)
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
  ('b49ed5e3-85ae-55cb-96e3-dd00924378e4', 'f2d94e62-d50e-5af0-a767-27d67154a62c', 'إذا عرفنا أنّ جسيمات جسم ما متقاربة من بعضها (فيثبت حجم الجسم)، لكنّها قادرة على التزحلق والحركة فوق بعضها (فيتغيّر شكل الجسم)، فما حالته الفيزيائية؟', '[{"id":"a","text":"صلبة"},{"id":"b","text":"غازية"},{"id":"c","text":"سائلة"},{"id":"d","text":"لا يمكن التحديد"}]'::jsonb, 'c', 'تقارب الجسيمات (حجم ثابت) مع قدرتها على التزحلق والحركة النسبية (شكل متغيّر حسب الإناء) هما بالضبط الوصف الجسيمي للحالة السائلة.', 2, 'mcq', NULL, NULL)
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
  ('0b659695-448c-5a99-a213-b1ffbd795889', 'f2d94e62-d50e-5af0-a767-27d67154a62c', 'قطعة من عجين الصلصال يمكن تشكيلها بأصابعنا إلى أيّ شكل نريده، لكنّها لا تتغيّر من تلقاء نفسها إذا تُركت دون لمس. ما حالتها الفيزيائية؟', '[{"id":"a","text":"صلبة، لأنّ شكلها لا يتغيّر من تلقاء نفسه"},{"id":"b","text":"سائلة، لأنّ شكلها يتغيّر بسهولة"},{"id":"c","text":"غازية، لأنّها طريّة وقابلة للتشكّل"},{"id":"d","text":"لا يمكن تصنيفها ضمن أيّ من الحالات الثلاث"}]'::jsonb, 'a', 'الخطأ الشائع هو الظنّ بأنّ قابلية التشكّل باليد تعني السيولة. لكنّ شكل الصلصال لا يتغيّر من تلقاء نفسه، بل يحتاج قوّة خارجية (ضغط أصابعنا) ليتغيّر، خلافًا للسائل الذي يسيل ويأخذ شكل إنائه من تلقاء نفسه بفعل الجاذبية وحدها. فالصلصال يبقى جسمًا صلبًا.', 3, 'mcq', NULL, NULL)
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
  ('e2ef1aab-9d08-5654-a35c-e76015c3a03e', 'f2d94e62-d50e-5af0-a767-27d67154a62c', 'أيّ العبارات التالية **خاطئة** بخصوص الحالات الثلاث للمادّة؟', '[{"id":"a","text":"الصلب له شكل خاصّ وحجم ثابت"},{"id":"b","text":"السائل ليس له شكل خاصّ لكن حجمه ثابت"},{"id":"c","text":"الغاز ليس له شكل خاصّ ولا حجم ثابت"},{"id":"d","text":"لكلّ الحالات الثلاث نفس ترتيب وحركة الجسيمات"}]'::jsonb, 'd', 'العبارات الأولى والثانية والثالثة صحيحة، أمّا الرابعة فخاطئة: ترتيب وحركة الجسيمات يختلف تمامًا بين الحالات الثلاث (مرتّبة شبه ساكنة في الصلب، متقاربة متزحلقة في السائل، متباعدة سريعة الحركة في الغاز)، وهذا الاختلاف هو بالضبط ما يفسّر اختلاف خصائص الشكل والحجم بينها.', 4, 'mcq', NULL, NULL)
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
  ('eedcda4a-0f04-5bb7-bab5-6a73821b3065', 'f2d94e62-d50e-5af0-a767-27d67154a62c', 'لاحظ تلميذ جسمًا مجهولًا: حافظ على شكله الخاصّ عند نقله من مكان لآخر، ولم يتغيّر حجمه عند وضعه في أوعية مختلفة، وعندما حاول ضغطه بيده لم يتشكّل بسهولة. ماذا نستنتج عن ترتيب وحركة جسيمات هذا الجسم؟', '[{"id":"a","text":"جسيمات متباعدة جدًّا تتحرّك بحرّية تامّة في كلّ الاتّجاهات"},{"id":"b","text":"جسيمات مرتّبة ومتلاصقة بشدّة، تهتزّ في مكانها فقط"},{"id":"c","text":"جسيمات متقاربة لكنّها تتزحلق بسهولة فوق بعضها"},{"id":"d","text":"لا يمكن للجسيمات أن تفسّر هذه الملاحظات"}]'::jsonb, 'b', 'ثلاث ملاحظات مجتمعة (شكل ثابت + حجم ثابت + مقاومة التشكّل بالضغط) تدلّ كلّها على أنّ جسيمات هذا الجسم مرتّبة ترتيبًا صارمًا ومتلاصقة بشدّة، فلا تتحرّك إلّا اهتزازًا خفيفًا في مكانها؛ وهذا هو نموذج الحالة الصلبة.', 5, 'mcq', NULL, NULL)
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
  ('d6bbf62d-08bd-5ac0-80db-8681ec4a6cd3', 'f2d94e62-d50e-5af0-a767-27d67154a62c', 'جسمان: الجسم (أ) يحافظ على شكله وحجمه معًا مهما غُيّر مكانه. الجسم (ب) يحافظ على حجمه لكنّه يأخذ في كلّ مرّة شكل الإناء الذي يوضع فيه. أيّ وصف صحيح لترتيب جسيمات كلّ منهما؟', '[{"id":"a","text":"كلاهما لهما نفس ترتيب الجسيمات لأنّ حجمهما ثابت في الحالتين"},{"id":"b","text":"الجسم (أ) جسيماته متباعدة، والجسم (ب) جسيماته مرتّبة تمامًا"},{"id":"c","text":"لا علاقة بين ثبات الحجم وترتيب الجسيمات"},{"id":"d","text":"الجسم (أ) جسيماته مرتّبة ومتلاصقة تهتزّ فقط، والجسم (ب) جسيماته متقاربة لكنّها متحرّكة ومتزحلقة"}]'::jsonb, 'd', 'الجسم (أ) صلب (شكل وحجم ثابتان معًا) فجسيماته مرتّبة ومتلاصقة تهتزّ في مكانها فقط، أمّا الجسم (ب) سائل (حجم ثابت لكن شكل متغيّر) فجسيماته متقاربة لكنّها قادرة على التزحلق والحركة النسبية فوق بعضها.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('097b407f-dccb-50cb-8fcb-c05f97acb277', '38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للمادّة وحالاتها', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ad585e38-d99e-5a20-a59e-d96d7b73445a', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'قطعة معدنية (كالمفتاح) جسم في أيّ حالة فيزيائية؟', '[{"id":"a","text":"صلبة"},{"id":"b","text":"سائلة"},{"id":"c","text":"غازية"},{"id":"d","text":"لا يمكن تصنيفها"}]'::jsonb, 'a', 'المفتاح المعدني جسم صلب يحافظ على شكله وحجمه الخاصّين مهما نُقل أو غُيّر إناؤه.', 1, 'mcq', NULL, NULL)
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
  ('533ecb22-6ab8-50c6-8d42-57650f9a6e4b', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'غاز البوتان المحبوس داخل قنّينة أسطوانية، لو نُقل (نظريًّا) إلى بالون كروي، فماذا سيحدث لشكله؟', '[{"id":"a","text":"يبقى أسطوانيًّا كما كان"},{"id":"b","text":"يختفي شكله نهائيًّا"},{"id":"c","text":"يتحوّل إلى شكل مكعّب دائمًا"},{"id":"d","text":"يتحوّل إلى شكل البالون الكروي"}]'::jsonb, 'd', 'الغاز ليس له شكل خاصّ ثابت، فهو يأخذ في كلّ مرّة شكل الإناء الذي يُحبَس فيه وينتشر ليملأه بالكامل، سواء كان أسطوانيًّا أو كرويًّا.', 2, 'mcq', NULL, NULL)
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
  ('9c27a001-510d-5dd1-8d97-103746a26879', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'لماذا تحافظ قطعة الجليد (حالة صلبة) على شكلها وحجمها معًا؟', '[{"id":"a","text":"لأنّ جسيماتها متباعدة جدًّا ومتحرّكة"},{"id":"b","text":"لأنّ جسيماتها مرتّبة ومتلاصقة، تهتزّ في مكانها فقط"},{"id":"c","text":"لأنّ جسيماتها متقاربة لكنّها تتزحلق بسهولة"},{"id":"d","text":"لأنّ ليس لها جسيمات إطلاقًا"}]'::jsonb, 'b', 'ترتيب جسيمات الجليد المنتظم وتلاصقها الشديد، مع اقتصار حركتها على اهتزاز خفيف في مكانها، هو ما يفسّر محافظة الجليد (كجسم صلب) على شكله وحجمه معًا.', 3, 'mcq', NULL, NULL)
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
  ('474563d6-55ba-5b2f-8825-fc7c80d86a9f', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'إذا انسكب القليل من الزيت (سائل) على طاولة، فإنّه ينتشر فوق سطحها لمسافة محدودة ثمّ يتوقّف. أمّا رائحة عطر انسكب قربه، فتنتشر لتملأ الغرفة كلّها. ما تفسير هذا الفرق؟', '[{"id":"a","text":"الزيت جسيماته متباعدة جدًّا مثل الغاز فيتوقّف انتشاره"},{"id":"b","text":"لا فرق حقيقيًّا بين انتشار الاثنين"},{"id":"c","text":"الزيت سائل حجمه ثابت فينتشر بمقدار محدود، أمّا العطر المتبخّر غاز فينتشر ليملأ كامل الغرفة"},{"id":"d","text":"العطر سائل أيضًا مثل الزيت تمامًا"}]'::jsonb, 'c', 'الزيت سائل: جسيماته متقاربة فحجمه ثابت، لذا ينتشر بمقدار محدود على السطح فقط. أمّا بخار العطر غاز: جسيماته متباعدة ومتحرّكة بحرّية، فينتشر بلا حدّ ليملأ كامل حيّز الغرفة.', 4, 'mcq', NULL, NULL)
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
  ('c064a4e5-d150-5ebc-8b8d-c0ffc5c5392b', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'وُضع سائل مجهول في إناء أسطواني فأخذ شكله، ثمّ نُقل السائل نفسه إلى إناء مخروطي فأخذ شكله أيضًا، لكن قِيسَت كمّيته في كلّ مرّة فوُجدت متساوية تمامًا. ما الاستنتاج الصحيح؟', '[{"id":"a","text":"الجسم سائل، لأنّه غيّر شكله بتغيّر الإناء بينما بقي حجمه ثابتًا"},{"id":"b","text":"الجسم صلب، لأنّه احتفظ بكمّية ثابتة"},{"id":"c","text":"الجسم غازي، لأنّه غيّر شكله"},{"id":"d","text":"لا يمكن تصنيف الجسم من هذه المعطيات"}]'::jsonb, 'a', 'تغيّر الشكل حسب الإناء مع ثبات الكمّية (الحجم) في كلّ مرّة هما بالضبط خاصّيّتا الحالة السائلة.', 5, 'mcq', NULL, NULL)
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
  ('60dd8a7c-d5c6-5fa1-a5ba-0e5ae71ccc1f', '097b407f-dccb-50cb-8fcb-c05f97acb277', 'أيّ العبارات التالية **خاطئة**؟', '[{"id":"a","text":"لكلّ جسم صلب شكل خاصّ به يحافظ عليه"},{"id":"b","text":"يأخذ السائل شكل الإناء الذي يوضع فيه"},{"id":"c","text":"لكلّ سائل شكل خاصّ به يحافظ عليه مهما كان إناؤه"},{"id":"d","text":"لا شكل خاصّ وثابت للغاز"}]'::jsonb, 'c', 'العبارة الثالثة خاطئة لأنّ السائل ليس له شكل خاصّ ثابت، بل يأخذ في كلّ مرّة شكل الإناء الذي يوضع فيه (كما تقول العبارة الثانية الصحيحة). الخطأ الشائع هو الظنّ بأنّ للسائل ''شكلًا طبيعيًّا'' يعود إليه، بينما الحقيقة أنّه دومًا يتبع شكل وعائه.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b16b88dd-509d-507a-b730-b55d6443a7b8', '38ef3095-76a9-5bdc-b8f0-a556af4679c4', 'sciences-physiques-7eme', '👑 قمّة التحدّي ⭐⭐⭐⭐: إتقان حالات المادّة', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('69d1aa5d-e183-571d-917c-4ddd20901572', 'b16b88dd-509d-507a-b730-b55d6443a7b8', 'سجّل تلميذ ملاحظتين عن جسم مجهول: (1) لا يحافظ على شكل خاصّ به. (2) لا يحافظ على حجم ثابت، بل يملأ أيّ إناء يوضع فيه بالكامل مهما كبُر. بالاعتماد على هاتين الملاحظتين فقط، ما حالة هذا الجسم؟', '[{"id":"a","text":"صلبة"},{"id":"b","text":"سائلة"},{"id":"c","text":"غازية"},{"id":"d","text":"لا يمكن الجزم بأيّ حالة من ملاحظتين فقط"}]'::jsonb, 'c', 'الملاحظتان معًا (لا شكل خاصّ + لا حجم ثابت مع امتلاء كامل الحيّز) هما بالضبط الخاصّيّتان المميّزتان للحالة الغازية دون سواها، فهما كافيتان للجزم.', 1, 'mcq', NULL, NULL)
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
  ('ebb0638f-994b-5a1d-93e3-239a884dd18a', 'b16b88dd-509d-507a-b730-b55d6443a7b8', 'جسيمات جسم ما مرتّبة بانتظام تامّ ومتلاصقة بشدّة، وتقتصر حركتها على اهتزاز خفيف في مكانها دون أيّ انتقال. بالاعتماد على هذا الوصف الجسيمي فقط، أيّ الخاصّيّتين العيانيّتين تتوقّعهما لهذا الجسم؟', '[{"id":"a","text":"لا شكل خاصّ وحجم متغيّر"},{"id":"b","text":"شكل خاصّ ثابت وحجم ثابت"},{"id":"c","text":"لا شكل خاصّ ولا حجم ثابت"},{"id":"d","text":"شكل يتغيّر من تلقاء نفسه مع حجم ثابت"}]'::jsonb, 'b', 'الترتيب المنتظم والتلاصق الشديد مع اقتصار الحركة على الاهتزاز في المكان هي خصائص جسيمات الحالة الصلبة، وهذا يفسّر أنّ للجسم شكلًا خاصًّا ثابتًا وحجمًا ثابتًا معًا.', 2, 'mcq', NULL, NULL)
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
  ('2225be3e-23e5-586d-81ee-1eef8df2a889', 'b16b88dd-509d-507a-b730-b55d6443a7b8', 'وضع تلميذ ثلاثة أجسام مجهولة (أ، ب، ج) كلّ واحد في إناء مخروطي ثمّ إناء أسطواني: الجسم (أ) احتفظ بشكله الخاصّ في الحالتين. الجسم (ب) تغيّر شكله ليطابق شكل الإناء لكن حجمه بقي ثابتًا. الجسم (ج) تغيّر شكله وانتشر ليملأ كامل الإناء في كلّ مرّة مهما كان حجمه. رتّب الأجسام الثلاثة حسب حالتها الفيزيائية:', '[{"id":"a","text":"أ صلب، ب سائل، ج غازي"},{"id":"b","text":"أ غازي، ب صلب، ج سائل"},{"id":"c","text":"أ سائل، ب غازي، ج صلب"},{"id":"d","text":"الثلاثة في نفس الحالة"}]'::jsonb, 'a', 'الجسم (أ) يحافظ على شكله دومًا فهو صلب. الجسم (ب) يغيّر شكله لكن يحافظ على حجمه فهو سائل. الجسم (ج) يغيّر شكله وحجمه معًا وينتشر ليملأ كامل الإناء فهو غازي.', 3, 'mcq', NULL, NULL)
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
  ('0823939e-89fe-5850-817d-b266c3182623', 'b16b88dd-509d-507a-b730-b55d6443a7b8', 'يقول أحد التلاميذ: ''كلّ الأجسام التي يمكن سكبها من إناء إلى آخر هي أجسام سائلة''. هل هذا التعميم صحيح دائمًا؟', '[{"id":"a","text":"نعم، لأنّ السكب خاصّية تخصّ السائل وحده"},{"id":"b","text":"نعم، لأنّ كلّ ما يُسكب يفقد شكله الخاصّ نهائيًّا"},{"id":"c","text":"لا، فالغاز أيضًا يمكن أن يُسكب لكنّه لا يحافظ على حجم ثابت خلافًا للسائل"},{"id":"d","text":"لا، لأنّ لا شيء يمكن سكبه أبدًا سوى الماء"}]'::jsonb, 'c', 'التعميم خاطئ: الغاز أيضًا ينتقل من إناء إلى آخر شبيهًا بالسكب، لكنّه لا يحافظ على حجم ثابت خلافًا للسائل الذي يحافظ دومًا على حجمه رغم تغيّر شكله؛ فمجرّد ''قابلية الانتقال بين الأوعية'' لا يكفي وحده لإثبات السيولة.', 4, 'mcq', NULL, NULL)
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
  ('9ec01da9-5d16-5e28-b314-6d3636665369', 'b16b88dd-509d-507a-b730-b55d6443a7b8', 'جسم مجهول لا يحافظ على شكله الخاصّ عند تغيير إنائه، لكنّه يحافظ على كمّيته (حجمه) ثابتة في كلّ مرّة. صف بدقّة ترتيب جسيماته وحركتها بالاعتماد على هاتين الملاحظتين معًا:', '[{"id":"a","text":"جسيمات متباعدة جدًّا مع حركة عشوائية سريعة في كلّ الاتّجاهات"},{"id":"b","text":"جسيمات متقاربة (يفسّر ثبات الحجم) لكنّها قادرة على التزحلق فوق بعضها (يفسّر تغيّر الشكل)"},{"id":"c","text":"جسيمات مرتّبة ترتيبًا صارمًا وثابتة تمامًا دون أيّ حركة"},{"id":"d","text":"لا يمكن ربط هاتين الملاحظتين بترتيب الجسيمات"}]'::jsonb, 'b', 'ثبات الحجم يدلّ على أنّ الجسيمات متقاربة من بعضها (لا فراغات كبيرة)، وتغيّر الشكل حسب الإناء يدلّ على قدرتها على التزحلق والحركة النسبية فوق بعضها؛ وهذا هو بالضبط نموذج الحالة السائلة.', 5, 'mcq', NULL, NULL)
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
  ('f7d0e24c-b136-5338-958d-ddf42845463d', 'b16b88dd-509d-507a-b730-b55d6443a7b8', 'لتحديد الحالة الفيزيائية لجسم مجهول بدقّة، يقترح تلميذ ما يلي: أوّلًا يفحص هل يحافظ الجسم على شكله عند نقله (فإن نعم، فهو صلب)؛ فإن لا، يفحص هل يحافظ على حجمه الثابت رغم تغيّر شكله (فإن نعم فهو سائل، وإن لا وانتشر ليملأ كامل الإناء فهو غازي). هل هذه الطريقة كافية لتصنيف أيّ جسم مألوف ضمن الحالات الثلاث؟', '[{"id":"a","text":"لا، لأنّها تتجاهل لون الجسم بالكامل"},{"id":"b","text":"لا، لأنّها تصلح فقط للأجسام الصلبة"},{"id":"c","text":"لا، لأنّ كلّ جسم يمكن أن يكون في الحالات الثلاث في آنٍ واحد"},{"id":"d","text":"نعم، لأنّ هذين الاختبارين المتتاليين يغطّيان بالضبط الخاصّيّتين المميّزتين للحالات الثلاث"}]'::jsonb, 'd', 'اختبار ثبات الشكل ثمّ اختبار ثبات الحجم يغطّيان معًا بالضبط المعيارين اللذين تُبنى عليهما تفرقة الحالات الثلاث (الشكل والحجم)، فيكفيان لتصنيف أيّ جسم مألوف بينها دون الحاجة لمعطى إضافي.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ecea9b6a-53ef-5a7b-abdf-452093e0f3a8', '2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'لماذا يُعتبر الماء ضروريًّا لكلّ الكائنات الحيّة؟', '[{"id":"a","text":"لأنّ الإنسان والحيوان والنبات لا يستطيعون العيش بدونه"},{"id":"b","text":"لأنّه يُستعمل فقط في صنع الزجاج"},{"id":"c","text":"لأنّه المصدر الوحيد للطاقة الكهربائية"},{"id":"d","text":"لا علاقة له بحياة النبات أو الحيوان"}]'::jsonb, 'a', 'الماء ضروري لبقاء الإنسان والحيوان على قيد الحياة ولنموّ النبات، فلا يمكن لأيّ كائن حيّ الاستغناء عنه.', 1, 'mcq', NULL, NULL)
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
  ('22a0d754-42ac-5cc0-aa5e-0d22662b8fda', '2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'أيّ ممّا يلي مصدر ماء عذب (غير مالح) في الطبيعة؟', '[{"id":"a","text":"البحر الأبيض المتوسط"},{"id":"b","text":"عين ماء جوفية"},{"id":"c","text":"المحيط الأطلسي"},{"id":"d","text":"بحيرة مالحة"}]'::jsonb, 'b', 'العين مصدر ماء جوفي عذب يخرج طبيعيًّا إلى السطح، بينما البحار والمحيطات والبحيرات المالحة مصادر مياه مالحة غير صالحة للشرب مباشرة.', 2, 'mcq', NULL, NULL)
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
  ('5e10ee26-e748-5abd-8bfb-1c7c04fb0f65', '2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'ما لون مسحوق كبريتات النحاس اللامائية قبل أن يلامس الماء؟', '[{"id":"a","text":"أزرق"},{"id":"b","text":"أسود"},{"id":"c","text":"أبيض"},{"id":"d","text":"أحمر"}]'::jsonb, 'c', 'مسحوق كبريتات النحاس اللامائية أبيض اللون قبل ملامسته للماء، ويتحوّل إلى الأزرق عند وجود الماء.', 3, 'mcq', NULL, NULL)
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
  ('f3173d1d-e5d4-5ec0-adb1-c93ba26576e5', '2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'ماذا يحدث للون كبريتات النحاس اللامائية عند وجود الماء؟', '[{"id":"a","text":"يبقى أبيض دون أيّ تغيّر"},{"id":"b","text":"يتحوّل من الأزرق إلى الأبيض"},{"id":"c","text":"يختفي اللون كليًّا"},{"id":"d","text":"يتحوّل من الأبيض إلى الأزرق"}]'::jsonb, 'd', 'عند ملامسة كبريتات النحاس اللامائية للماء، يتحوّل لونها من الأبيض إلى الأزرق، وهذا هو الدليل القاطع على وجود الماء.', 4, 'mcq', NULL, NULL)
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
  ('974d16e7-bf74-536a-ae47-d049cb1cc838', '2d1b314c-c3a2-52ee-8d8e-e941c80d16f2', 'لماذا لا يُعتبر ماء النهر نقيًّا تمامًا رغم أنّه يبدو شفّافًا؟', '[{"id":"a","text":"لأنّه يحتوي دائمًا على موادّ مذابة لا نراها بالعين المجرّدة"},{"id":"b","text":"لأنّ لونه أزرق قاتم دائمًا"},{"id":"c","text":"لأنّه أثقل من الزيت دائمًا"},{"id":"d","text":"لأنّ درجة حرارته منخفضة جدًّا دائمًا"}]'::jsonb, 'a', 'الماء في الطبيعة، حتّى إذا بدا شفّافًا، يحتوي دائمًا على موادّ مذابة (كأملاح معدنية) اكتسبها من التربة والصخور، فلا يكون نقيًّا تمامًا.', 5, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a811c46e-203e-54c2-b529-bfdaf3b5817b', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', '⭐ تمرين: الماء أهمّيته ومصادره', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4dc6c291-40a4-5a30-96b7-14b5478da87d', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', 'لماذا يحتاج الفلاح إلى الماء في حقله؟', '[{"id":"a","text":"لتبريد الآلات فقط"},{"id":"b","text":"لريّ المزروعات وتأمين نموّها"},{"id":"c","text":"لتلوين التربة"},{"id":"d","text":"لا حاجة له إلى الماء"}]'::jsonb, 'b', 'يستعمل الفلاح الماء لريّ المزروعات وتأمين نموّها في الحقول والواحات، فبدونه لا يمكن للنباتات أن تنمو.', 1, 'mcq', NULL, NULL)
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
  ('925db6f1-5a8a-5b9a-8688-383740672c9f', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', 'ما اسم المجرى المائي العذب الذي يجري على سطح الأرض، كوادي مجردة؟', '[{"id":"a","text":"بئر"},{"id":"b","text":"عين"},{"id":"c","text":"نهر (واد)"},{"id":"d","text":"بحر"}]'::jsonb, 'c', 'النهر (الوادي) مجرى مائي عذب يجري على سطح الأرض، كوادي مجردة أطول أنهار تونس؛ أمّا البئر والعين فمصدرهما الماء الجوفي، والبحر ماء مالح.', 2, 'mcq', NULL, NULL)
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
  ('d17f3f6a-1e5d-56cd-a33b-9df021d98b18', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', 'كيف يصل الإنسان إلى الماء الجوفي في الواحات كتوزر؟', '[{"id":"a","text":"بحفر الآبار"},{"id":"b","text":"ببناء السدود على الجبال"},{"id":"c","text":"بتجميع مياه الأمطار في قوارير"},{"id":"d","text":"لا يمكن الوصول إلى الماء الجوفي"}]'::jsonb, 'a', 'يحفر الإنسان الآبار للوصول إلى الماء الجوفي المحبوس تحت الأرض، وهي أساسية في الواحات كتوزر وقفصة لريّ النخيل.', 3, 'mcq', NULL, NULL)
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
  ('b86bc9f8-63c7-57de-92ef-d8c6c021e70e', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', 'لماذا لا يُشرب ماء البحر مباشرة؟', '[{"id":"a","text":"لأنّه بارد جدًّا"},{"id":"b","text":"لأنّه مالح"},{"id":"c","text":"لأنّه عديم اللون"},{"id":"d","text":"لأنّه يتجمّد بسرعة"}]'::jsonb, 'b', 'ماء البحر مالح، لذلك لا يصلح للشرب مباشرة رغم أنّه مصدر مائي واسع تُطلّ عليه تونس على البحر الأبيض المتوسط.', 4, 'mcq', NULL, NULL)
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
  ('defd10c3-963d-5ffd-90a2-82ee0ab5254e', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', 'مسحوق أبيض تحوّل لونه إلى الأزرق بعد إضافة بضع قطرات من سائل مجهول إليه. ما الذي يدلّ عليه هذا التحوّل؟', '[{"id":"a","text":"وجود الملح فقط"},{"id":"b","text":"ارتفاع درجة حرارة السائل"},{"id":"c","text":"وجود الماء في السائل"},{"id":"d","text":"أنّ السائل غاز"}]'::jsonb, 'c', 'تحوّل كبريتات النحاس اللامائية من الأبيض إلى الأزرق هو الدليل القاطع على وجود الماء في السائل المختبَر.', 5, 'mcq', NULL, NULL)
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
  ('844b3ba2-3331-5552-b055-3255bfdc8e44', 'a811c46e-203e-54c2-b529-bfdaf3b5817b', 'العين والبئر يشتركان في كون مصدر مائهما:', '[{"id":"a","text":"مياه سطحية"},{"id":"b","text":"مياه مالحة دائمًا"},{"id":"c","text":"مياه مصنّعة كيميائيًّا"},{"id":"d","text":"مياه جوفية"}]'::jsonb, 'd', 'العين خروج طبيعي للماء الجوفي، والبئر حفرة يصل بها الإنسان إلى الماء الجوفي؛ فكلاهما مصدره المياه الجوفية المحبوسة تحت سطح الأرض.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1f88fd80-ae9f-5b42-808f-b20b8953802b', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: مصادر الماء والكشف عنه', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f842969c-f85f-5472-a913-56852f33420f', '1f88fd80-ae9f-5b42-808f-b20b8953802b', 'ما الفرق الأساسي بين العين والبئر؟', '[{"id":"a","text":"العين خروج طبيعي للماء الجوفي، والبئر حفرة يحفرها الإنسان للوصول إليه"},{"id":"b","text":"العين ماء مالح والبئر ماء عذب"},{"id":"c","text":"لا فرق بينهما إطلاقًا"},{"id":"d","text":"مصدر العين المطر مباشرة فقط، ومصدر البئر البحر مباشرة"}]'::jsonb, 'a', 'العين مكان يخرج فيه الماء الجوفي طبيعيًّا إلى السطح دون حفر، أمّا البئر فحفرة يحفرها الإنسان بنفسه للوصول إلى الماء الجوفي؛ كلاهما مصدره الماء الجوفي لكن طريقة الوصول إليه تختلف.', 1, 'mcq', NULL, NULL)
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
  ('1dcf3c02-0b22-5ba3-8658-a6f8b1c7fb72', '1f88fd80-ae9f-5b42-808f-b20b8953802b', 'ما وظيفة سدّ سيدي سالم المبني على وادي مجردة؟', '[{"id":"a","text":"استخراج الملح من مياه البحر"},{"id":"b","text":"تجميع مياه الأمطار وجريان الوادي لريّ الفلاحة وتزويد المدن بالماء"},{"id":"c","text":"تحويل الماء مباشرة إلى بخار"},{"id":"d","text":"منع سقوط الأمطار على المنطقة"}]'::jsonb, 'b', 'السدّ خزّان اصطناعي يبنيه الإنسان على واد لتجميع مياه الأمطار وجريان الوادي في بحيرة، ثمّ يُستعمل ماؤه لريّ الفلاحة وتزويد المدن بالماء بعد معالجته.', 2, 'mcq', NULL, NULL)
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
  ('4186b6ca-f45a-5d6c-bad8-92e3369383ec', '1f88fd80-ae9f-5b42-808f-b20b8953802b', 'لماذا يحتاج بعض ماء الشرب إلى معالجة قبل استهلاكه رغم أنّه يبدو صافيًا؟', '[{"id":"a","text":"لأنّ لونه أزرق غامق دائمًا"},{"id":"b","text":"لأنّه أثقل من الزيت دائمًا"},{"id":"c","text":"لأنّه يحتوي على موادّ مذابة لا نراها بالعين المجرّدة رغم صفائه"},{"id":"d","text":"لأنّه لا يحتوي على أيّ موادّ أخرى مطلقًا"}]'::jsonb, 'c', 'الماء الطبيعي، حتّى إن بدا صافيًا وشفّافًا، يحتوي دائمًا على موادّ مذابة (كأملاح معدنية) اكتسبها من التربة والصخور، وهو ما قد يستدعي معالجته قبل الشرب.', 3, 'mcq', NULL, NULL)
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
  ('815cc6ce-25e9-55d6-8e34-66504551bbbe', '1f88fd80-ae9f-5b42-808f-b20b8953802b', 'لاحظ تلميذ أنّ ماء عين طبيعية يخرج من باطن الأرض دون أن يحفر أحد حفرة، بينما احتاج جيرانه لحفر بئر عميق للوصول إلى الماء في أرضهم. ما تفسير هذا الاختلاف؟', '[{"id":"a","text":"العين تخرج تلقائيًّا لأنّ الماء الجوفي يصل عندها إلى السطح طبيعيًّا، أمّا عند الجيران فمستوى الماء الجوفي أعمق فاحتاجوا إلى الحفر"},{"id":"b","text":"العين مصدرها البحر مباشرة ولا علاقة لها بالماء الجوفي"},{"id":"c","text":"كلاهما ماء سطحي وليس جوفيًّا"},{"id":"d","text":"لا يمكن أن يخرج الماء من الأرض دون حفر إطلاقًا"}]'::jsonb, 'a', 'كلّ من العين والبئر مصدرهما الماء الجوفي، لكنّ العين تظهر حيث يبلغ منسوب الماء الجوفي السطح طبيعيًّا، بينما تحتاج الأراضي التي يكون فيها منسوب الماء الجوفي أعمق إلى حفر بئر للوصول إليه.', 4, 'mcq', NULL, NULL)
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
  ('23259b60-f2cf-56c4-a903-c1480f16bf36', '1f88fd80-ae9f-5b42-808f-b20b8953802b', 'أيّ العبارات التالية **خاطئة**؟', '[{"id":"a","text":"كبريتات النحاس اللامائية بيضاء اللون قبل ملامسة الماء"},{"id":"b","text":"يدلّ تحوّل اللون إلى الأزرق على وجود الماء"},{"id":"c","text":"ماء البحر مالح وغير صالح للشرب مباشرة"},{"id":"d","text":"يتحوّل لون كبريتات النحاس اللامائية من الأزرق إلى الأبيض عند وجود الماء"}]'::jsonb, 'd', 'العبارة الرابعة خاطئة: الاتّجاه الصحيح هو تحوّل اللون من الأبيض إلى الأزرق عند وجود الماء، لا العكس؛ العبارات الثلاث الأخرى صحيحة.', 5, 'mcq', NULL, NULL)
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
  ('57f6636e-4a97-58cd-9d72-444d405936bf', '1f88fd80-ae9f-5b42-808f-b20b8953802b', 'بئر ماء وسدّ مائي كلاهما مصدر مياه يستعملها الإنسان. ما الفرق الأساسي بينهما من حيث موقع الماء؟', '[{"id":"a","text":"كلاهما مياه سطحية فوق الأرض"},{"id":"b","text":"البئر مصدره ماء جوفي محبوس تحت الأرض، والسدّ يجمع مياه سطحية (أمطار وأودية) فوق الأرض"},{"id":"c","text":"كلاهما مياه جوفية تحت الأرض"},{"id":"d","text":"لا علاقة لأيّ منهما بمصدر الماء الطبيعي"}]'::jsonb, 'b', 'البئر يصل إلى الماء الجوفي المحبوس تحت سطح الأرض، بينما السدّ خزّان اصطناعي يجمع مياهًا سطحية (أمطارًا وجريان أودية) فوق سطح الأرض؛ فرغم أنّ كليهما مصدر ماء عذب، يختلف موقع مائهما الأصلي.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3d5f0675-fab5-51af-8933-d7ed2b846285', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الماء ومصادره', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cb5a82d3-a121-5f3a-8b10-780db7b8c06b', '3d5f0675-fab5-51af-8933-d7ed2b846285', 'امتلأت بحيرة اصطناعية بمياه الأمطار التي جمعها الإنسان خلف حاجز مبني على واد. ما اسم هذا التجهيز؟', '[{"id":"a","text":"سدّ"},{"id":"b","text":"عين"},{"id":"c","text":"بئر"},{"id":"d","text":"بحر"}]'::jsonb, 'a', 'السدّ خزّان اصطناعي يبنيه الإنسان على واد لتجميع مياه الأمطار وجريان الوادي، كسدّ سيدي سالم على وادي مجردة.', 1, 'mcq', NULL, NULL)
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
  ('fc6ab36d-3eeb-55bb-a35a-1ef91aa8a162', '3d5f0675-fab5-51af-8933-d7ed2b846285', 'أيّ العبارات التالية صحيحة بخصوص ماء النهر؟', '[{"id":"a","text":"نقيّ تمامًا ولا يحتوي على أيّ موادّ أخرى"},{"id":"b","text":"يحتوي دائمًا على موادّ مذابة رغم شفافيته"},{"id":"c","text":"لونه أزرق قاتم دائمًا"},{"id":"d","text":"لا يمكن أبدًا معالجته"}]'::jsonb, 'b', 'ماء النهر، وإن بدا شفّافًا، يحتوي دائمًا على موادّ مذابة (كأملاح معدنية) اكتسبها من التربة والصخور، فلا يكون نقيًّا تمامًا.', 2, 'mcq', NULL, NULL)
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
  ('46d5f00b-6e7d-549b-810a-601fb002d6fe', '3d5f0675-fab5-51af-8933-d7ed2b846285', 'أيّ الكائنات التالية يحتاج إلى الماء ليعيش؟', '[{"id":"a","text":"الإنسان فقط"},{"id":"b","text":"النبات فقط"},{"id":"c","text":"الإنسان والحيوان والنبات معًا"},{"id":"d","text":"لا كائن يحتاج إلى الماء"}]'::jsonb, 'c', 'الماء ضروري لبقاء كلّ الكائنات الحيّة: الإنسان يشربه، والحيوان يحتاجه ليعيش، والنبات يمتصّه لينمو ويصنع غذاءه.', 3, 'mcq', NULL, NULL)
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
  ('9ef8e270-c634-5eba-a318-a5b689e7df9a', '3d5f0675-fab5-51af-8933-d7ed2b846285', 'بعد سقوط الأمطار، أين تذهب هذه المياه غالبًا؟', '[{"id":"a","text":"تتبخّر فقط ولا تذهب لأيّ مكان آخر"},{"id":"b","text":"تبقى معلّقة في الهواء دائمًا"},{"id":"c","text":"تتحوّل مباشرة إلى ماء البحر فقط"},{"id":"d","text":"تتسرّب في التربة فتغذّي المياه الجوفية أو تجري على السطح فتغذّي الأنهار والسدود"}]'::jsonb, 'd', 'الأمطار هي الأصل الأوّل لمعظم المياه العذبة: بعد سقوطها إمّا تتسرّب في التربة فتغذّي المياه الجوفية (عيون وآبار)، أو تجري على السطح فتغذّي الأنهار والسدود.', 4, 'mcq', NULL, NULL)
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
  ('9a9396fd-2410-57f3-b569-613ae181478d', '3d5f0675-fab5-51af-8933-d7ed2b846285', 'شكّ تلميذ في وجود ماء داخل قطعة قماش مبلّلة بسائل شفّاف، فوضع عليها القليل من مسحوق كبريتات النحاس اللامائية الأبيض. أيّ ملاحظة تؤكّد له وجود الماء؟', '[{"id":"a","text":"بقاء المسحوق أبيض كما هو"},{"id":"b","text":"اختفاء المسحوق كليًّا"},{"id":"c","text":"تحوّل المسحوق إلى اللون الأزرق"},{"id":"d","text":"تصاعد رائحة من المسحوق"}]'::jsonb, 'c', 'تحوّل كبريتات النحاس اللامائية من الأبيض إلى الأزرق هو الدليل القاطع على وجود الماء في السائل الذي بلّل القماش.', 5, 'mcq', NULL, NULL)
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
  ('9062b7f0-13d6-5b16-beea-c9262cc5795f', '3d5f0675-fab5-51af-8933-d7ed2b846285', 'أيّ ممّا يلي يُصنَّف ضمن المياه السطحية؟', '[{"id":"a","text":"ماء العين"},{"id":"b","text":"ماء السدّ"},{"id":"c","text":"ماء البئر"},{"id":"d","text":"الماء المحبوس بين طبقات الصخور"}]'::jsonb, 'b', 'ماء السدّ يتجمّع فوق سطح الأرض فهو مياه سطحية، خلافًا للعين والبئر والماء المحبوس بين طبقات الصخور، وهي مصادر مياه جوفية.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('15517a02-3806-522c-ace7-706da85e38be', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: مصادر الماء ونقاوته', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4c6c373b-d442-50b9-b679-071f9e56e49e', '15517a02-3806-522c-ace7-706da85e38be', 'امتدّ مسطّح مائي واسع إلى الأفق، وكان ماؤه شديد الملوحة بحيث لا يصلح للشرب مباشرة. ما هذا المسطّح على الأرجح؟', '[{"id":"a","text":"عين ماء جوفية"},{"id":"b","text":"نهر عذب"},{"id":"c","text":"بحر"},{"id":"d","text":"بئر ماء عذب"}]'::jsonb, 'c', 'المسطّح المائي الواسع الممتدّ إلى الأفق والشديد الملوحة هو بحر؛ فالبحار والمحيطات هي المسطّحات المائية المالحة الكبرى، خلافًا للعين والنهر والبئر التي مياهها عذبة.', 1, 'mcq', NULL, NULL)
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
  ('01a1e740-4bef-5d32-b06c-bcbc20a6cfa0', '15517a02-3806-522c-ace7-706da85e38be', 'سقطت أمطار غزيرة على منطقة جبلية: تسرّب جزء من الماء في التربة، وجرى الجزء الآخر على سطح الأرض مكوّنًا مجرى مائيًّا واضحًا. بأيّ مصير يُعرف كلّ جزء على التوالي؟', '[{"id":"a","text":"الجزء المتسرّب يُغذّي المياه الجوفية (كالعيون والآبار)، والجزء الجاري يكوّن نهرًا (واديًا)"},{"id":"b","text":"الجزء المتسرّب يتحوّل إلى بحر، والجزء الجاري يتبخّر فورًا"},{"id":"c","text":"كلا الجزأين يتحوّلان إلى ماء البحر مباشرة"},{"id":"d","text":"لا يتغيّر مصير أيّ من الجزأين بعد سقوط المطر"}]'::jsonb, 'a', 'الأمطار هي أصل معظم المياه العذبة: ما يتسرّب منها في التربة يغذّي المياه الجوفية التي تظهر كعيون أو تُستخرج من الآبار، وما يجري منها على السطح يكوّن الأنهار والأودية.', 2, 'mcq', NULL, NULL)
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
  ('cd50daac-83e8-53ac-9011-62f3f059d4d8', '15517a02-3806-522c-ace7-706da85e38be', 'قال تلميذ: «كلّ ماء شفّاف تمامًا هو ماء نقيّ لا يحتوي على أيّ موادّ أخرى». هل هذا الادّعاء صحيح؟', '[{"id":"a","text":"نعم، لأنّ الشفافية دليل قاطع على النقاوة الكاملة"},{"id":"b","text":"لا، فالماء الطبيعي يحتوي دائمًا على موادّ مذابة رغم شفافيته"},{"id":"c","text":"نعم، لكن فقط بالنسبة لماء الآبار"},{"id":"d","text":"لا يمكن الجزم بذلك إطلاقًا مهما كانت المعطيات"}]'::jsonb, 'b', 'الادّعاء خاطئ: الشفافية لا تعني النقاوة؛ فالماء في الطبيعة (نهر أو عين أو بئر) يحتوي دائمًا على موادّ مذابة لا نراها بالعين المجرّدة، حتّى لو بدا شفّافًا تمامًا.', 3, 'mcq', NULL, NULL)
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
  ('df9e1edc-8b27-5cda-93fc-6d57785afd1f', '15517a02-3806-522c-ace7-706da85e38be', 'وضع تلميذ قطرات من سائل مجهول على مسحوق كبريتات النحاس اللامائية الأبيض، فبقي المسحوق أبيضًا دون أيّ تغيّر في لونه. ما الاستنتاج الصحيح؟', '[{"id":"a","text":"السائل يحتوي على كمّية كبيرة جدًّا من الماء"},{"id":"b","text":"لا يمكن استعمال هذا الاختبار على السوائل الشفّافة"},{"id":"c","text":"لون المسحوق يتغيّر دائمًا بعد مرور بعض الوقت"},{"id":"d","text":"السائل على الأرجح لا يحتوي على ماء"}]'::jsonb, 'd', 'بقاء كبريتات النحاس اللامائية أبيضة اللون دون تغيّر بعد ملامسة السائل يدلّ على غياب الماء فيه؛ فتحوّلها إلى الأزرق هو وحده الدليل على وجود الماء.', 4, 'mcq', NULL, NULL)
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
  ('a4f4f840-e61c-51d1-80e4-0f90873afc33', '15517a02-3806-522c-ace7-706da85e38be', 'رتّب المصادر التالية بحسب موقع مائها: النهر، البئر، السدّ. أيّ تصنيف صحيح؟', '[{"id":"a","text":"النهر والسدّ مياه سطحية، والبئر مياه جوفية"},{"id":"b","text":"الثلاثة مياه جوفية"},{"id":"c","text":"النهر مياه جوفية، والبئر والسدّ مياه سطحية"},{"id":"d","text":"لا يمكن تصنيف أيّ منها"}]'::jsonb, 'a', 'النهر والسدّ يجري ويتجمّع ماؤهما فوق سطح الأرض فهما مياه سطحية، أمّا البئر فيصل إلى الماء الجوفي المحبوس تحت سطح الأرض.', 5, 'mcq', NULL, NULL)
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
  ('122bf5d3-a0f4-54d2-a906-3fb9251871eb', '15517a02-3806-522c-ace7-706da85e38be', 'زار تلميذ منطقة فلاحية فلاحظ ثلاثة مصادر مائية: الأوّل ماء يخرج تلقائيًّا من سفح جبل دون أن يحفر أحد أيّ حفرة، الثاني حفرة عميقة حفرها الفلّاحون للوصول إلى الماء تحت أرضهم، الثالث بحيرة اصطناعية تجمّعت خلف حاجز بُني على واد قريب بعد الأمطار. ما التعريف الصحيح لكلّ مصدر على التوالي؟', '[{"id":"a","text":"الأوّل سدّ، الثاني عين، الثالث بئر"},{"id":"b","text":"الأوّل عين، الثاني بئر، الثالث سدّ"},{"id":"c","text":"الأوّل بئر، الثاني سدّ، الثالث عين"},{"id":"d","text":"الثلاثة عيون مختلفة فقط"}]'::jsonb, 'b', 'الماء الخارج تلقائيًّا دون حفر عين، والحفرة التي يحفرها الفلّاحون للوصول إلى الماء الجوفي بئر، والبحيرة الاصطناعية خلف حاجز على واد سدّ.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('43c8fce0-1550-57a8-9b8c-aa5fc293a18f', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للماء وأهمّيته ومصادره', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bf8c428e-be06-5cf6-8360-fd00367b72ee', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', 'لماذا يُعدّ الماء من أهمّ حاجيات الكائنات الحيّة والفلاحة معًا؟', '[{"id":"a","text":"لأنّه ضروري لشرب الإنسان والحيوان ونموّ النبات وريّ المزروعات"},{"id":"b","text":"لأنّه يُستعمل فقط لتلوين المنتجات"},{"id":"c","text":"لأنّه المصدر الوحيد للطاقة الكهربائية"},{"id":"d","text":"لا علاقة له بالفلاحة إطلاقًا"}]'::jsonb, 'a', 'الماء ضروري لشرب الإنسان والحيوان، ولنموّ النبات وصنعه غذاءه، ولريّ المزروعات في الفلاحة؛ لهذا يُعتبر سرّ الحياة على الأرض.', 1, 'mcq', NULL, NULL)
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
  ('8167e9a3-1930-5cb2-b3cd-939d5d7989e8', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', 'ما الفرق الأساسي بين ماء السدّ وماء البحر؟', '[{"id":"a","text":"كلاهما مالح تمامًا"},{"id":"b","text":"ماء السدّ عذب يجمعه الإنسان من الأمطار والأودية، وماء البحر مالح طبيعيًّا واسع الامتداد"},{"id":"c","text":"كلاهما مصدره الأمطار مباشرة فقط"},{"id":"d","text":"لا فرق بينهما إطلاقًا"}]'::jsonb, 'b', 'ماء السدّ عذب، يجمعه الإنسان اصطناعيًّا من الأمطار وجريان الأودية، بينما ماء البحر مالح طبيعيًّا ويمتدّ على مساحات واسعة جدًّا.', 2, 'mcq', NULL, NULL)
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
  ('a315daa6-fc16-5a0e-b5db-6d6a008be0ed', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', 'كيف يمكن التأكّد كيميائيًّا من وجود الماء في مادّة تبدو جافّة كليًّا؟', '[{"id":"a","text":"بتذوّقها مباشرة"},{"id":"b","text":"بوزنها فقط"},{"id":"c","text":"بوضع القليل من كبريتات النحاس اللامائية عليها ومراقبة تحوّل لونها إلى الأزرق"},{"id":"d","text":"بتسخينها حتّى تشتعل"}]'::jsonb, 'c', 'اختبار كبريتات النحاس اللامائية هو الطريقة العلمية للكشف عن الماء: إذا تحوّل لونها الأبيض إلى الأزرق، فهذا يؤكّد وجود الماء ولو بكمّية ضئيلة.', 3, 'mcq', NULL, NULL)
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
  ('6badfdc6-9f66-56bc-aecd-5037ad7d7ab7', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', 'صنّف المصادر التالية إلى سطحية أو جوفية: البحر، السدّ، العين، البئر.', '[{"id":"a","text":"الأربعة سطحية"},{"id":"b","text":"الأربعة جوفية"},{"id":"c","text":"البحر والعين سطحية، والسدّ والبئر جوفية"},{"id":"d","text":"البحر والسدّ سطحية، والعين والبئر جوفية"}]'::jsonb, 'd', 'البحر والسدّ ماؤهما فوق سطح الأرض فهما مياه سطحية، بينما العين والبئر مصدرهما الماء الجوفي المحبوس تحت سطح الأرض.', 4, 'mcq', NULL, NULL)
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
  ('2cb8a402-6b4a-527e-b678-d919f7d2e0e9', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', 'أيّ العبارات التالية **خاطئة** بخصوص الماء؟', '[{"id":"a","text":"ماء البحر صالح للشرب مباشرة دون أيّ معالجة"},{"id":"b","text":"الماء ضروري لنموّ النبات"},{"id":"c","text":"الأمطار أصل معظم المياه العذبة"},{"id":"d","text":"كبريتات النحاس اللامائية تتحوّل إلى الأزرق بوجود الماء"}]'::jsonb, 'a', 'العبارة الأولى خاطئة: ماء البحر مالح وغير صالح للشرب مباشرة؛ أمّا العبارات الثلاث الأخرى فصحيحة.', 5, 'mcq', NULL, NULL)
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
  ('09ecb2a5-8932-5c15-a693-e2a954419b52', '43c8fce0-1550-57a8-9b8c-aa5fc293a18f', 'لاحظ فلّاح أنّ ماء بئره في الواحة شفّاف تمامًا، فاختبره بكبريتات النحاس اللامائية البيضاء فتحوّل لونها إلى الأزرق فورًا، رغم أنّه يعلم أنّ هذا الماء الجوفي يحتوي على أملاح معدنية مذابة. ما الاستنتاجان الصحيحان معًا؟', '[{"id":"a","text":"الماء لا يحتوي على أيّ ماء لأنّ لونه تغيّر"},{"id":"b","text":"الماء يحتوي على ماء (أكّده تحوّل اللون)، وهو مع ذلك غير نقيّ تمامًا بسبب الأملاح المذابة فيه"},{"id":"c","text":"الماء نقيّ تمامًا لأنّه شفّاف"},{"id":"d","text":"اختبار كبريتات النحاس لا يصلح لماء الآبار"}]'::jsonb, 'b', 'تحوّل اللون إلى الأزرق يؤكّد وجود الماء، لكنّ هذا لا يعني نقاوته الكاملة: فهو يحتوي أيضًا على أملاح معدنية مذابة اكتسبها من التربة والصخور، فلا يكون نقيًّا تمامًا رغم شفافيته.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('34b5e23f-bea4-5859-a644-d9df05e6297d', 'ea084cf4-4fa3-5ab4-919a-dc170ec21cfe', 'sciences-physiques-7eme', '👑 قمّة التحدّي ⭐⭐⭐⭐: إتقان الماء ومصادره والكشف عنه', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('85ae1b2c-3898-5280-8ddc-157e7bfa2682', '34b5e23f-bea4-5859-a644-d9df05e6297d', 'أراد فلّاح ريّ حقله في واحة بمياه عذبة متوفّرة باستمرار دون الاعتماد على مياه الأمطار المتقطّعة. أيّ مصدر مائي يناسب حاجته أكثر؟', '[{"id":"a","text":"بئر أو عين تستمدّ من الماء الجوفي"},{"id":"b","text":"بحيرة موسمية تجفّ صيفًا"},{"id":"c","text":"ماء البحر المالح"},{"id":"d","text":"بخار الماء المتصاعد من الهواء"}]'::jsonb, 'a', 'البئر أو العين تستمدّان ماءً جوفيًّا متوفّرًا باستمرار طوال السنة، خلافًا لبحيرة موسمية تجفّ أو ماء البحر المالح غير الصالح للريّ مباشرة؛ وهذا يفسّر اعتماد الواحات كتوزر وقفصة على الآبار والعيون.', 1, 'mcq', NULL, NULL)
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
  ('b83d1bb5-f2cc-5b9f-9dbb-4835502484a2', '34b5e23f-bea4-5859-a644-d9df05e6297d', 'زارت مجموعة تلاميذ ثلاثة مواقع: الأوّل نبع ماء طبيعي في الجبل، الثاني بحيرة اصطناعية خلف حاجز على واد، الثالث امتداد مائي مالح واسع عند الساحل. صنّفوا الموقع الثالث ثمّ حدّدوا العلاقة الصحيحة بين المواقع الثلاثة من حيث ملوحة الماء.', '[{"id":"a","text":"الموقع الثالث بحر، وهو وحده المالح بينما الأوّل والثاني ماؤهما عذب"},{"id":"b","text":"المواقع الثلاثة مالحة بنفس الدرجة"},{"id":"c","text":"الموقع الثاني هو الأكثر ملوحة لأنّه اصطناعي"},{"id":"d","text":"الموقع الأوّل بحر أيضًا لأنّه طبيعي"}]'::jsonb, 'a', 'الموقع الثالث بحر لأنّه امتداد مائي مالح واسع عند الساحل؛ أمّا النبع (عين) والبحيرة الاصطناعية (سدّ) فماؤهما عذب، فالبحر وحده هو المالح بين المواقع الثلاثة.', 2, 'mcq', NULL, NULL)
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
  ('e5bc97df-3cd5-5545-be6f-7c55a7e41bfa', '34b5e23f-bea4-5859-a644-d9df05e6297d', 'لاحظ تلميذ أنّ مستوى ماء بئر قريته انخفض بشكل ملحوظ بعد موسم شحّت فيه الأمطار. ما العلاقة بين الأمطار ومنسوب ماء البئر؟', '[{"id":"a","text":"لا علاقة بينهما إطلاقًا"},{"id":"b","text":"الأمطار تتسرّب في التربة وتغذّي المياه الجوفية التي يستمدّ منها البئر ماءه، فتراجعها يخفّض منسوب البئر"},{"id":"c","text":"البئر يستمدّ ماءه من البحر مباشرة وليس من الأمطار"},{"id":"d","text":"شحّ الأمطار يزيد منسوب البئر دائمًا"}]'::jsonb, 'b', 'الأمطار هي الأصل الأوّل للمياه الجوفية: تتسرّب في التربة فتغذّيها، فإذا شحّت الأمطار، تراجعت كمّية الماء الجوفي وانخفض منسوب الآبار التي تستمدّ منه.', 3, 'mcq', NULL, NULL)
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
  ('ffe23998-3133-5e37-a809-a97a6993e6cd', '34b5e23f-bea4-5859-a644-d9df05e6297d', 'قال تلميذ: «بما أنّ ماء العين يخرج من باطن الأرض تلقائيًّا، فهو دائمًا نقيّ تمامًا ولا يحتاج أبدًا لأيّ معالجة». ناقش صحّة هذا القول.', '[{"id":"a","text":"القول صحيح لأنّ كلّ ماء جوفي نقيّ تلقائيًّا"},{"id":"b","text":"القول صحيح، لكن فقط لعيون الجبال"},{"id":"c","text":"القول خاطئ، فالماء الجوفي أيضًا يحتوي على موادّ مذابة اكتسبها من التربة والصخور، وقد يحتاج للمعالجة"},{"id":"d","text":"لا يمكن الحكم على نقاوة أيّ ماء إطلاقًا"}]'::jsonb, 'c', 'الخطأ الشائع هو الظنّ بأنّ خروج الماء تلقائيًّا من الأرض يعني نقاوته المطلقة. لكنّ الماء الجوفي، مثله مثل ماء النهر، يكتسب موادّ مذابة أثناء مروره بالتربة والصخور، فليس نقيًّا تمامًا رغم صفائه.', 4, 'mcq', NULL, NULL)
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
  ('4caf26d3-f664-5659-a4ba-f4af0f648f92', '34b5e23f-bea4-5859-a644-d9df05e6297d', 'أراد تلميذ التأكّد من وجود ماء في عيّنة سائلة، فاتّبع الخطوات التالية: (1) أخذ مسحوق كبريتات نحاس لامائية أزرق اللون. (2) وضع عليه قطرات من العيّنة. (3) لاحظ بقاء اللون أزرق فاستنتج وجود الماء. أين يكمن الخطأ في تفكيره؟', '[{"id":"a","text":"لا يوجد أيّ خطأ، تفكيره صحيح تمامًا"},{"id":"b","text":"الخطأ في الخطوة الثانية فقط"},{"id":"c","text":"الخطأ أنّه استعمل قطرات قليلة جدًّا"},{"id":"d","text":"الخطأ في الخطوة الأولى: كبريتات النحاس اللامائية بيضاء اللون في البداية لا زرقاء، والدليل الصحيح على وجود الماء هو تحوّلها من الأبيض إلى الأزرق"}]'::jsonb, 'd', 'الخطأ الشائع هو الانطلاق من مسحوق أزرق أصلًا: كبريتات النحاس اللامائية بيضاء اللون قبل ملامسة الماء، والدليل القاطع على وجود الماء هو تحوّلها من الأبيض إلى الأزرق، وليس بقاء لون أزرق كما افترض التلميذ خطأً.', 5, 'mcq', NULL, NULL)
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
  ('f2b74846-80c5-5a34-be33-14d9f265c0b8', '34b5e23f-bea4-5859-a644-d9df05e6297d', 'بعد اختبار عيّنتين مختلفتين بكبريتات النحاس اللامائية، تحوّل لون المسحوق إلى الأزرق في العيّنة الأولى وبقي أبيض في الثانية. عُلم أيضًا أنّ العيّنة الأولى مأخوذة من عين ماء جوفية طبيعية. ماذا نستنتج بدقّة عن العيّنتين معًا؟', '[{"id":"a","text":"العيّنتان تحتويان على ماء بنفس الدرجة"},{"id":"b","text":"العيّنة الأولى تحتوي على ماء (وهي بالتأكيد غير نقيّة تمامًا لاحتوائها على موادّ مذابة كماء جوفي طبيعي)، والعيّنة الثانية لا تحتوي على ماء على الأرجح"},{"id":"c","text":"العيّنة الأولى لا تحتوي على ماء لأنّ العين مصدر جوفي فقط"},{"id":"d","text":"لا يمكن استنتاج أيّ شيء من هاتين الملاحظتين"}]'::jsonb, 'b', 'تحوّل اللون إلى الأزرق في العيّنة الأولى يؤكّد وجود الماء فيها، وكونها من عين طبيعية يعني أنّها تحتوي أيضًا على موادّ مذابة اكتسبتها من التربة والصخور فليست نقيّة تمامًا؛ أمّا بقاء اللون أبيض في العيّنة الثانية فيدلّ على غياب الماء فيها على الأرجح.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5096e461-4102-5977-87e9-4009b3d08c56', 'de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2369f0fe-e368-5a19-b41b-ded487837b7a', '5096e461-4102-5977-87e9-4009b3d08c56', 'ما اسم التحوّل الذي ينتقل فيه الماء من الحالة الصلبة إلى الحالة السائلة؟', '[{"id":"a","text":"التصلّب"},{"id":"b","text":"التبخّر"},{"id":"c","text":"الانصهار"},{"id":"d","text":"التكاثف"}]'::jsonb, 'c', 'انتقال الماء من الحالة الصلبة (جليد) إلى الحالة السائلة يسمّى الانصهار، ويحدث عند تسخين الجليد.', 1, 'mcq', NULL, NULL)
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
  ('03c1d873-afa8-53c5-aba6-c28ad92e6ef0', '5096e461-4102-5977-87e9-4009b3d08c56', 'بأيّ وحدة نقيس عادة درجة حرارة الماء؟', '[{"id":"a","text":"الغرام (g)"},{"id":"b","text":"اللتر (L)"},{"id":"c","text":"المتر (m)"},{"id":"d","text":"الدرجة السلسيوس (°C)"}]'::jsonb, 'd', 'تقاس درجة حرارة الماء بوحدة الدرجة السلسيوس °C باستعمال مقياس الحرارة، بينما الغرام واللتر والمتر وحدات للكتلة والحجم والطول.', 2, 'mcq', NULL, NULL)
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
  ('6e2cfc67-c5d7-514f-b976-5b45ac16642d', '5096e461-4102-5977-87e9-4009b3d08c56', 'أيّ ممّا يلي مثال على التكاثف؟', '[{"id":"a","text":"قطرات ماء تتكوّن على السطح الخارجي لكأس بارد"},{"id":"b","text":"قطعة ثلج تذوب على الطاولة"},{"id":"c","text":"ماء يغلي في قدر على النار"},{"id":"d","text":"بركة ماء تختفي تدريجيًّا في يوم مشمس"}]'::jsonb, 'a', 'تكوّن قطرات الماء على سطح كأس بارد ناتج عن تكاثف بخار الماء الموجود في الهواء عند ملامسته لسطح بارد؛ أمّا الخيارات الأخرى فأمثلة على الانصهار والغليان والتبخّر.', 3, 'mcq', NULL, NULL)
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
  ('bbd7ef37-972c-53d1-bd9c-fd87f177ae3d', '5096e461-4102-5977-87e9-4009b3d08c56', 'ما الفرق الأساسي بين التبخّر والغليان؟', '[{"id":"a","text":"لا فرق بينهما إطلاقًا"},{"id":"b","text":"الغليان يحدث ببطء على سطح السائل فقط، والتبخّر سريع وفي كامل السائل"},{"id":"c","text":"التبخّر يحدث ببطء على سطح السائل في أيّ درجة حرارة، والغليان سريع وفي كامل السائل عند درجة حرارة ثابتة"},{"id":"d","text":"كلاهما يحدث فقط عند 0°C"}]'::jsonb, 'c', 'التبخّر تحوّل بطيء يحدث على سطح السائل فقط وفي أيّ درجة حرارة، بينما الغليان تحوّل سريع يحدث في كامل كتلة السائل عند درجة حرارة ثابتة (نحو 100°C عند مستوى سطح البحر).', 4, 'mcq', NULL, NULL)
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
  ('6cbb34f6-cc20-576b-9f28-e93609c34471', '5096e461-4102-5977-87e9-4009b3d08c56', 'ماذا يحدث لدرجة حرارة الماء أثناء غليانه، حتّى لو استمررنا في تسخينه؟', '[{"id":"a","text":"ترتفع باستمرار دون توقّف"},{"id":"b","text":"تبقى ثابتة طوال مدّة الغليان"},{"id":"c","text":"تنخفض تدريجيًّا"},{"id":"d","text":"تتذبذب بشكل عشوائي"}]'::jsonb, 'b', 'أثناء الغليان، تبقى درجة حرارة الماء ثابتة (نحو 100°C) طوال مدّة التحوّل، حتّى لو استمرّ التسخين، لأنّ الحرارة المضافة تُستهلك في تغيير حالة الماء لا في رفع درجة حرارته.', 5, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e96054ac-27e8-55e1-8da2-1d9168c52bdb', 'de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', '⭐ تمرين: تغيّرات حالة الماء', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('67e73fe3-4e0b-5e21-8f13-f6f73fbe46cc', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', 'ترك تلميذ مكعّب ثلج خارج المجمّد فوق طاولة المطبخ، فلاحظ بعد قليل أنّه تحوّل إلى ماء سائل. ما اسم هذا التحوّل؟', '[{"id":"a","text":"التصلّب"},{"id":"b","text":"الانصهار"},{"id":"c","text":"التكاثف"},{"id":"d","text":"الغليان"}]'::jsonb, 'b', 'تحوّل الثلج (حالة صلبة) إلى ماء سائل عند التسخين هو الانصهار.', 1, 'mcq', NULL, NULL)
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
  ('c444ed4d-14e6-5978-b7d9-78597306c22c', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', 'وضعت ربّة منزل قوارير ماء في المجمّد، فتحوّل الماء بعد ساعات إلى مكعّبات ثلج صلبة. ما اسم هذا التحوّل؟', '[{"id":"a","text":"الانصهار"},{"id":"b","text":"التبخّر"},{"id":"c","text":"التصلّب"},{"id":"d","text":"التكاثف"}]'::jsonb, 'c', 'تحوّل الماء السائل إلى ثلج صلب عند التبريد يسمّى التصلّب.', 2, 'mcq', NULL, NULL)
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
  ('54b59a0a-a7ca-5f05-85d9-ecb769d74c12', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', 'علّقت ربّة منزل ملابس مبلّلة في الهواء الطلق، فجفّت تدريجيًّا بعد ساعات دون أن تغلي. ما اسم هذا التحوّل؟', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"الغليان"},{"id":"c","text":"الانصهار"},{"id":"d","text":"التصلّب"}]'::jsonb, 'a', 'جفاف الملابس المبلّلة ببطء في الهواء الطلق دون غليان هو مثال على التبخّر، وهو تحوّل بطيء يحدث على سطح السائل.', 3, 'mcq', NULL, NULL)
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
  ('55026300-a1af-514b-aa51-559a6f5505ea', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', 'وضعت أمّ قدر ماء على النار، فبدأت فقّاعات كثيرة تتكوّن في كامل حجم الماء بسرعة. ما اسم هذا التحوّل؟', '[{"id":"a","text":"التكاثف"},{"id":"b","text":"التصلّب"},{"id":"c","text":"الانصهار"},{"id":"d","text":"الغليان"}]'::jsonb, 'd', 'تكوّن الفقّاعات بسرعة في كامل حجم الماء هو علامة الغليان، وهو تحوّل سريع يحدث في كامل كتلة السائل.', 4, 'mcq', NULL, NULL)
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
  ('e4cc086f-bb3a-5000-aba7-2a4f0bbad3fd', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', 'بأيّ جهاز نقيس درجة حرارة الماء؟', '[{"id":"a","text":"مقياس الحرارة"},{"id":"b","text":"الميزان"},{"id":"c","text":"المسطرة"},{"id":"d","text":"الكأس المدرّج"}]'::jsonb, 'a', 'نقيس درجة حرارة الماء بجهاز يسمّى مقياس الحرارة (الترمومتر)، بوحدة الدرجة السلسيوس °C.', 5, 'mcq', NULL, NULL)
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
  ('ad27127b-8780-5782-9960-6fe2a6f05b8d', 'e96054ac-27e8-55e1-8da2-1d9168c52bdb', 'عند أيّ درجة حرارة يتصلّب (يتجمّد) الماء النقيّ عند مستوى سطح البحر؟', '[{"id":"a","text":"100°C"},{"id":"b","text":"50°C"},{"id":"c","text":"0°C"},{"id":"d","text":"−10°C"}]'::jsonb, 'c', 'يتصلّب (يتجمّد) الماء النقيّ عند θ = 0°C عند مستوى سطح البحر.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('197975c5-6a17-5a55-aadc-2c868c02cd08', 'de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: تغيّرات حالة الماء', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dcbab84c-c753-5659-96a5-082e9a9264c0', '197975c5-6a17-5a55-aadc-2c868c02cd08', 'ما اسم التحوّل الذي يصف تحوّل بخار الماء الموجود في الهواء إلى قطرات ماء على سطح بارد؟', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"التكاثف"},{"id":"c","text":"الانصهار"},{"id":"d","text":"التصلّب"}]'::jsonb, 'b', 'تحوّل بخار الماء (غاز) إلى ماء سائل عند تبريده هو التكاثف، كما يحدث على سطح كأس بارد.', 1, 'mcq', NULL, NULL)
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
  ('f240d1f4-dfc3-5929-8b4d-a9ace963e51d', '197975c5-6a17-5a55-aadc-2c868c02cd08', 'خرج تلميذان لملاحظة الطبيعة: الأوّل شاهد بركة ماء صغيرة تنكمش تدريجيًّا على مدى أيّام تحت الشمس دون أن تغلي، والثاني شاهد ماء يغلي بقوّة في قدر على النار خلال دقائق. أيّ العبارتين صحيحة؟', '[{"id":"a","text":"شاهد الأوّل تبخّرًا بطيئًا، والثاني غليانًا سريعًا"},{"id":"b","text":"شاهد الأوّل غليانًا، والثاني تبخّرًا"},{"id":"c","text":"شاهد كلاهما نفس التحوّل بالضبط"},{"id":"d","text":"لم يشاهد أيّ منهما أيّ تحوّل فيزيائي"}]'::jsonb, 'a', 'انكماش البركة تدريجيًّا دون فقّاعات على مدى أيّام هو تبخّر بطيء يحدث على السطح، بينما تكوّن الفقّاعات بقوّة خلال دقائق في قدر على النار هو غليان سريع في كامل السائل.', 2, 'mcq', NULL, NULL)
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
  ('25260bc3-452b-5671-891a-584628adfa7a', '197975c5-6a17-5a55-aadc-2c868c02cd08', 'أيّ العبارات التالية **خاطئة** بخصوص تحوّلات حالة الماء؟', '[{"id":"a","text":"الانصهار تحوّل من الحالة الصلبة إلى السائلة"},{"id":"b","text":"التكاثف تحوّل من الحالة الغازية إلى السائلة"},{"id":"c","text":"الغليان يحدث على سطح السائل فقط"},{"id":"d","text":"التصلّب تحوّل من الحالة السائلة إلى الصلبة"}]'::jsonb, 'c', 'العبارة الثالثة خاطئة: الغليان يحدث في كامل كتلة السائل لا على سطحه فقط (خلافًا للتبخّر)؛ العبارات الثلاث الأخرى صحيحة.', 3, 'mcq', NULL, NULL)
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
  ('67000247-5888-5088-a511-4735b195eac4', '197975c5-6a17-5a55-aadc-2c868c02cd08', 'لماذا لا ترتفع درجة حرارة الماء فوق 100°C طالما أنّه ما يزال يغلي في القدر عند مستوى سطح البحر، حتّى مع استمرار التسخين؟', '[{"id":"a","text":"لأنّ النار تنطفئ تلقائيًّا عند هذه الدرجة"},{"id":"b","text":"لأنّ الحرارة المضافة تُستهلك في تحويل الماء السائل إلى بخار لا في رفع درجة حرارته"},{"id":"c","text":"لأنّ القدر يعزل الحرارة بالكامل"},{"id":"d","text":"لأنّ درجة حرارة الماء تنخفض تلقائيًّا عند الغليان"}]'::jsonb, 'b', 'أثناء الغليان، تُستهلك الحرارة المضافة في تحويل الماء من الحالة السائلة إلى الحالة الغازية (تغيير الحالة)، لا في رفع درجة الحرارة؛ لهذا تبقى ثابتة عند 100°C طالما بقي ماء سائل يتحوّل إلى بخار.', 4, 'mcq', NULL, NULL)
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
  ('9bc1e3a1-cd05-5895-8bf2-713c6653ca92', '197975c5-6a17-5a55-aadc-2c868c02cd08', 'سخّن تلميذ قطعة جليد كتلتها 20غ من درجة حرارة منخفضة حتّى تحوّلت بالكامل إلى ماء سائل، ثمّ استمرّ بتسخين الماء الناتج. رتّب مراحل ما لاحظه بالترتيب الصحيح.', '[{"id":"a","text":"ثبات عند 100°C طوال التسخين دون أيّ تغيّر آخر"},{"id":"b","text":"انخفاض تدريجي لدرجة الحرارة طوال التسخين"},{"id":"c","text":"ارتفاع تدريجي لدرجة الحرارة ← ثبات عند 0°C مع انصهار الجليد ← ارتفاع تدريجي لدرجة حرارة الماء السائل"},{"id":"d","text":"ارتفاع تدريجي فقط دون أيّ ثبات في أيّ مرحلة"}]'::jsonb, 'c', 'أثناء تسخين الجليد، ترتفع درجة حرارته تدريجيًّا حتّى يبلغ 0°C، حيث تثبت درجة الحرارة طوال مدّة الانصهار (تحوّل الحالة)، ثمّ بعد اكتمال الانصهار تعاود درجة حرارة الماء السائل الارتفاع تدريجيًّا بالتسخين.', 5, 'mcq', NULL, NULL)
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
  ('7531b393-1b2f-5d71-b3d7-9feca47f18bd', '197975c5-6a17-5a55-aadc-2c868c02cd08', 'قارن تلميذ بين تحوّلين: تحوّل A حيث تتكوّن قطرات ماء صغيرة على عشب الحديقة في الصباح الباكر دون أن يكون قد أمطر، وتحوّل B حيث يختفي بريق النَّدى عن العشب تدريجيًّا بعد شروق الشمس. سمِّ كلّ تحوّل بدقّة.', '[{"id":"a","text":"A تبخّر، وB تكاثف"},{"id":"b","text":"كلاهما انصهار"},{"id":"c","text":"كلاهما غليان"},{"id":"d","text":"A تكاثف (لبخار الماء الجوّي البارد)، وB تبخّر"}]'::jsonb, 'd', 'تكوّن قطرات النَّدى على العشب صباحًا هو تكاثف بخار الماء الموجود في الهواء عند تبريده ليلًا، بينما اختفاء النَّدى تدريجيًّا بعد شروق الشمس هو تبخّر الماء السائل بفعل الحرارة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9f8636de-815f-57d2-81fa-dd82eb5241a6', 'de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): تغيّرات حالة الماء', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2179f3d9-856b-5471-aae4-7b71df3a4e22', '9f8636de-815f-57d2-81fa-dd82eb5241a6', 'عند أيّ درجة حرارة يغلي الماء النقيّ عند مستوى سطح البحر؟', '[{"id":"a","text":"0°C"},{"id":"b","text":"50°C"},{"id":"c","text":"100°C"},{"id":"d","text":"200°C"}]'::jsonb, 'c', 'يغلي الماء النقيّ عند θ = 100°C عند مستوى سطح البحر.', 1, 'mcq', NULL, NULL)
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
  ('abb64175-3aa2-5c99-a950-f0c2317a3b58', '9f8636de-815f-57d2-81fa-dd82eb5241a6', 'أيّ الأزواج التالية يمثّل تحوّلين متعاكسين تمامًا (كلّ واحد عكس الآخر)؟', '[{"id":"a","text":"الانصهار والتصلّب"},{"id":"b","text":"الانصهار والغليان"},{"id":"c","text":"التبخّر والانصهار"},{"id":"d","text":"التصلّب والتكاثف"}]'::jsonb, 'a', 'الانصهار (صلب ← سائل) والتصلّب (سائل ← صلب) تحوّلان متعاكسان تمامًا؛ أمّا الأزواج الأخرى فتجمع بين تحوّلين غير متعاكسين لبعضهما.', 2, 'mcq', NULL, NULL)
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
  ('513b7323-1c09-5739-a48b-1443021e1918', '9f8636de-815f-57d2-81fa-dd82eb5241a6', 'دخل تلميذ الحمّام بعد استحمام بماء ساخن، فلاحظ أنّ مرآة الحمّام أصبحت مغطّاة بطبقة من قطرات الماء الصغيرة. فسّر السبب العلمي لتكوّن هذه القطرات.', '[{"id":"a","text":"الماء يتسرّب مباشرة من الجدار إلى المرآة"},{"id":"b","text":"بخار الماء الساخن الصاعد من الاستحمام يلامس سطح المرآة الأبرد فيتكاثف مكوّنًا القطرات"},{"id":"c","text":"المرآة تصنع الماء بنفسها عند التسخين"},{"id":"d","text":"بخار الماء ينصهر على سطح المرآة الباردة"}]'::jsonb, 'b', 'بخار الماء الساخن الناتج عن الاستحمام يرتفع في الهواء ويلامس سطح المرآة الأبرد نسبيًّا، فيتكاثف (يتحوّل من غاز إلى سائل) مكوّنًا طبقة من القطرات الصغيرة عليها.', 3, 'mcq', NULL, NULL)
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
  ('963c100b-72f3-5e40-9de5-4f5bdd927162', '9f8636de-815f-57d2-81fa-dd82eb5241a6', 'ما الخطأ في قول تلميذ: «التصلّب هو تحوّل الماء من الحالة الصلبة إلى الحالة السائلة»؟', '[{"id":"a","text":"لا خطأ في هذا القول"},{"id":"b","text":"التصلّب لا علاقة له بالماء إطلاقًا"},{"id":"c","text":"التصلّب هو تحوّل الماء من الحالة السائلة إلى الحالة الصلبة لا العكس"},{"id":"d","text":"التصلّب يحدث فقط عند 100°C"}]'::jsonb, 'c', 'القول معكوس: التصلّب هو تحوّل الماء من الحالة السائلة إلى الحالة الصلبة عند التبريد؛ أمّا الانصهار فهو من الصلبة إلى السائلة.', 4, 'mcq', NULL, NULL)
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
  ('f9ead32d-64f9-5d40-bb1c-2eb3419579f5', '9f8636de-815f-57d2-81fa-dd82eb5241a6', 'بعد تسخين الشمس لمياه البحر، صعد بخار الماء إلى الأعلى حيث برد الهواء فتكوّنت الغيوم، ثمّ سقطت الأمطار من جديد. رتّب هذه المراحل مع تسمية كلّ تحوّل فيزيائي بالترتيب الصحيح.', '[{"id":"a","text":"تكاثف (بحر ← بخار) ثمّ تبخّر (بخار ← غيوم) ثمّ سقوط أمطار"},{"id":"b","text":"تبخّر (بحر ← بخار) ثمّ تكاثف (بخار ← غيوم) ثمّ سقوط أمطار"},{"id":"c","text":"انصهار (بحر ← بخار) ثمّ تصلّب (بخار ← غيوم) ثمّ سقوط أمطار"},{"id":"d","text":"لا يتضمّن هذا المسار أيّ تحوّل فيزيائي"}]'::jsonb, 'b', 'الدورة الطبيعية للماء تبدأ بتبخّر ماء البحر (سائل ← غاز) بفعل حرارة الشمس، ثمّ يتكاثف البخار عند صعوده وبرودته (غاز ← سائل) مكوّنًا الغيوم، ثمّ تسقط الأمطار من جديد.', 5, 'mcq', NULL, NULL)
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
  ('0a99d0d8-0e25-57fe-bc82-544480134c6f', '9f8636de-815f-57d2-81fa-dd82eb5241a6', 'وزن تلميذ قطعة جليد كتلتها 50غ، ثمّ تركها تنصهر بالكامل داخل كأس مغلق ووزن الماء الناتج. ما الكتلة المتوقّعة للماء السائل الناتج؟', '[{"id":"a","text":"أقلّ من 50غ لأنّ جزءًا من الكتلة يضيع"},{"id":"b","text":"أكثر من 50غ لأنّ الماء يكتسب كتلة أثناء الانصهار"},{"id":"c","text":"لا يمكن التنبّؤ بكتلة الماء الناتج إطلاقًا"},{"id":"d","text":"50غ بالضبط، لأنّ كتلة الماء محفوظة أثناء تغيّر حالته"}]'::jsonb, 'd', 'تغيّر حالة الماء (كالانصهار) تحوّل فيزيائي يغيّر الشكل الخارجي فقط، فتبقى كتلة الماء محفوظة: قطعة جليد كتلتها 50غ تعطي 50غ بالضبط من الماء السائل.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3d4dcb4a-79c0-5946-b216-1f7a41844291', 'de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: تغيّرات حالة الماء وحفظ الكتلة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('239d06ca-5e6f-556f-821d-95608cdfdb2f', '3d4dcb4a-79c0-5946-b216-1f7a41844291', 'ما اسم التحوّل الذي يفسّر تكوّن الغيوم في السماء انطلاقًا من بخار الماء الصاعد من البحار؟', '[{"id":"a","text":"الانصهار"},{"id":"b","text":"التصلّب"},{"id":"c","text":"التكاثف"},{"id":"d","text":"الغليان"}]'::jsonb, 'c', 'بخار الماء الصاعد من البحار يبرد كلّما ارتفع، فيتكاثف مكوّنًا قطرات ماء صغيرة تتجمّع لتشكّل الغيوم.', 1, 'mcq', NULL, NULL)
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
  ('074fcd3c-d410-528e-81ef-3631248cf8f4', '3d4dcb4a-79c0-5946-b216-1f7a41844291', 'لاحظ مزارع أنّ منسوب ماء بحيرة اصطناعية قرب مزرعته ينخفض تدريجيًّا في فصل الصيف الحارّ دون أن تنقص كمّية الأمطار الساقطة عليها كثيرًا. ما التفسير الأرجح لهذا الانخفاض؟', '[{"id":"a","text":"تسرّب الماء بالكامل إلى الفضاء الخارجي"},{"id":"b","text":"تصلّب الماء وتحوّله إلى جليد يطفو على السطح"},{"id":"c","text":"تبخّر جزء من ماء البحيرة بفعل الحرارة الصيفية المرتفعة"},{"id":"d","text":"لا يوجد أيّ تفسير علمي ممكن"}]'::jsonb, 'c', 'الحرارة المرتفعة في الصيف تزيد من تبخّر ماء البحيرة من سطحها، وهذا يفسّر انخفاض منسوبها حتّى دون تغيّر كبير في كمّية الأمطار.', 2, 'mcq', NULL, NULL)
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
  ('86929362-93eb-5de6-89f3-4f77a33ea5c6', '3d4dcb4a-79c0-5946-b216-1f7a41844291', 'أيّ العبارات التالية بخصوص حفظ الكتلة أثناء تغيّر حالة الماء هي الصحيحة؟', '[{"id":"a","text":"عند انصهار قطعة جليد بالكامل داخل وعاء مغلق، تبقى كتلة الماء الناتج مساوية لكتلة الجليد الأصلي"},{"id":"b","text":"تفقد قطعة الجليد جزءًا من كتلتها بمجرّد أن تبدأ بالانصهار"},{"id":"c","text":"يكتسب الماء كتلة إضافية عندما يتحوّل من سائل إلى بخار"},{"id":"d","text":"كتلة الماء تتضاعف عند كلّ تغيّر حالة"}]'::jsonb, 'a', 'تغيّر حالة الماء تحوّل فيزيائي يغيّر شكله الخارجي فقط دون أن يفقد أو يكتسب أيّ كتلة إضافية؛ لذا كتلة الماء الناتج عن انصهار جليد داخل وعاء مغلق تبقى مساوية تمامًا لكتلة الجليد الأصلي.', 3, 'mcq', NULL, NULL)
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
  ('6c7aab3b-6374-50f7-8139-38738c22973d', '3d4dcb4a-79c0-5946-b216-1f7a41844291', 'يغلي ماء في قدر مفتوح على النار لمدّة طويلة، فيلاحظ تلميذ أنّ كمّية الماء السائل المتبقّية في القدر تنقص تدريجيًّا. هل يتناقض هذا مع مبدأ حفظ الكتلة أثناء تغيّر الحالة؟', '[{"id":"a","text":"نعم يتناقض، لأنّ الكتلة يجب أن تبقى ثابتة داخل القدر مهما حدث"},{"id":"b","text":"لا يتناقض؛ فالماء لا يفقد أيّ كتلة، بل يتحوّل جزء منه إلى بخار يتصاعد ويغادر القدر المفتوح، وكتلة الماء الكلّية (سائل + بخار المتصاعد) تبقى محفوظة"},{"id":"c","text":"نعم يتناقض، لأنّ الغليان يدمّر جزءًا من مادّة الماء نهائيًّا"},{"id":"d","text":"لا علاقة بين نقصان الماء في القدر وظاهرة الغليان إطلاقًا"}]'::jsonb, 'b', 'لا يوجد أيّ تناقض: كتلة الماء السائل المتبقّي في القدر تنقص لأنّ جزءًا منه يتحوّل إلى بخار يغادر القدر المفتوح إلى الهواء المحيط، لكنّ الكتلة الكلّية للماء (السائل المتبقّي زائد البخار المتصاعد) تبقى محفوظة؛ فمبدأ حفظ الكتلة يخصّ مجموع المادّة لا الجزء المرئي وحده.', 4, 'mcq', NULL, NULL)
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
  ('17571ce9-b248-5834-94e7-a7cb91f85f8d', '3d4dcb4a-79c0-5946-b216-1f7a41844291', 'سجّل تلميذ درجة حرارة كأس ماء يُسخَّن تدريجيًّا كلّ دقيقة، فلاحظ أنّ الدرجة ارتفعت باستمرار من البداية، لكنّها توقّفت عن الارتفاع عند 100°C واستقرّت عندها لعدّة دقائق قبل أن ينتهي كلّ الماء السائل من القدر. ما تفسير هذا الاستقرار المؤقّت في القراءات؟', '[{"id":"a","text":"خطأ في مقياس الحرارة يجب إصلاحه"},{"id":"b","text":"النار انطفأت تلقائيًّا خلال تلك الدقائق"},{"id":"c","text":"درجة حرارة الغرفة انخفضت في تلك اللحظة بالضبط"},{"id":"d","text":"الماء بدأ الغليان عند 100°C، وتُستهلك الحرارة المضافة في تحويله إلى بخار لا في رفع درجة حرارته طالما بقي ماء سائل"}]'::jsonb, 'd', 'استقرار درجة الحرارة عند 100°C يدلّ على بداية الغليان: طالما بقي ماء سائل يتحوّل إلى بخار، تُستهلك الحرارة المضافة في هذا التحوّل لا في رفع درجة الحرارة، فتبقى القراءة ثابتة حتّى نفاد الماء السائل بالكامل.', 5, 'mcq', NULL, NULL)
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
  ('3309f98b-d3e6-5bff-9835-1b1027f1eab0', '3d4dcb4a-79c0-5946-b216-1f7a41844291', 'لاحظ عالم أنّ درجة حرارة عيّنة ماء تساوي 0°C بالضبط، وأنّ العيّنة تحتوي في نفس اللحظة على جليد وماء سائل معًا في حالة توازن. ماذا يمكن استنتاجه بثقة من هذه المعطيات وحدها؟', '[{"id":"a","text":"العيّنة بصدد الانصهار أو التصلّب (تغيّر حالة) عند هذه الدرجة المعلمة، لا يمكن الجزم بالاتّجاه من هذه المعطيات وحدها"},{"id":"b","text":"العيّنة بالتأكيد بصدد الغليان"},{"id":"c","text":"العيّنة لا تحتوي على أيّ ماء في هذه الحالة"},{"id":"d","text":"درجة الحرارة 0°C تعني بالضرورة أنّ كلّ الماء صلب بالكامل"}]'::jsonb, 'a', 'وجود جليد وماء سائل معًا عند 0°C بالضبط هو العلامة المميّزة لتغيّر الحالة (انصهار أو تصلّب) عند هذه الدرجة المعلمة؛ لا يمكن معرفة اتّجاه التحوّل من درجة الحرارة وحدها، بل يلزم معرفة إن كنّا نُسخّن أو نُبرّد العيّنة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('49fb92aa-01be-5a83-a53f-790259d36bb4', 'de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة لتغيّرات حالة الماء', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ca119b79-766a-5b6a-8734-46505c011a81', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'ما اسم التحوّل العكسي للانصهار؟', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"التكاثف"},{"id":"c","text":"التصلّب"},{"id":"d","text":"الغليان"}]'::jsonb, 'c', 'التحوّل العكسي للانصهار (صلب إلى سائل) هو التصلّب (سائل إلى صلب).', 1, 'mcq', NULL, NULL)
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
  ('a6a26794-72e9-5714-8cd7-d07a8ce02bcc', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'لماذا يُعتبر الغليان أسرع من التبخّر عمومًا؟', '[{"id":"a","text":"لأنّه يحدث فقط في الليل"},{"id":"b","text":"لأنّه لا يحتاج إلى أيّ حرارة"},{"id":"c","text":"لأنّه يحدث فقط في الأواني الزجاجية"},{"id":"d","text":"لأنّه يحدث في كامل كتلة السائل وليس على سطحه فقط"}]'::jsonb, 'd', 'الغليان يحدث في كامل كتلة السائل دفعة واحدة (بتكوّن فقّاعات في كلّ الاتّجاهات)، بينما يقتصر التبخّر على سطح السائل فقط، لذا يكون الغليان أسرع بكثير.', 2, 'mcq', NULL, NULL)
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
  ('32b5b63b-2845-5907-91a4-09eaca6a4453', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'تتبخّر كمّيات هائلة من مياه البحار يوميًّا بفعل حرارة الشمس، ومع ذلك لا تنضب مياه البحار عبر ملايين السنين. ما التفسير الأنسب لهذا الثبات؟', '[{"id":"a","text":"الماء المتبخّر يعود في النهاية عبر تكاثفه وسقوطه أمطارًا وجريانه في الأنهار نحو البحار من جديد، ضمن دورة مستمرّة"},{"id":"b","text":"الشمس تتوقّف عن التسخين بانتظام لتعويض الماء"},{"id":"c","text":"البحار تولّد ماءً جديدًا من تلقاء نفسها"},{"id":"d","text":"كمّية الماء المتبخّرة ضئيلة جدًّا لدرجة أنّها لا تُذكر"}]'::jsonb, 'a', 'رغم تبخّر كمّيات كبيرة من ماء البحار يوميًّا، فإنّ هذا الماء لا يضيع: يتكاثف لاحقًا مكوّنًا الغيوم، ثمّ يسقط أمطارًا تغذّي الأنهار والمياه الجوفية، وتعود في النهاية إلى البحار عبر الأنهار، ضمن دورة طبيعية مستمرّة تحافظ على الكمّية الإجمالية للماء.', 3, 'mcq', NULL, NULL)
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
  ('cb28e965-297e-5019-a71a-5553a723d607', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'لماذا لا يصحّ القول إنّ درجة الحرارة ترتفع دائمًا كلّما أضفنا حرارة إلى الماء؟', '[{"id":"a","text":"لأنّ إضافة الحرارة لا ترفع درجة الحرارة إطلاقًا في أيّ حالة"},{"id":"b","text":"لأنّ درجة حرارة الماء تنخفض دائمًا عند التسخين"},{"id":"c","text":"لأنّه أثناء تغيّر الحالة (كالغليان أو الانصهار)، تُستهلك الحرارة المضافة في التحوّل لا في رفع درجة الحرارة، فتبقى ثابتة مؤقّتًا"},{"id":"d","text":"لأنّ هذا القول صحيح دائمًا دون أيّ استثناء"}]'::jsonb, 'c', 'خلال تغيّر الحالة (كالغليان عند 100°C أو الانصهار عند 0°C)، تبقى درجة الحرارة ثابتة رغم استمرار التسخين، لأنّ الحرارة المضافة تُستهلك في تحويل حالة الماء لا في رفع درجته.', 4, 'mcq', NULL, NULL)
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
  ('e75d4143-5af7-5b38-b98b-114602346d04', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'قارن ثلاثة أوعية ماء: الأوّل بُرِّد حتّى تحوّل بالكامل إلى جليد، الثاني سُخِّن حتّى بدأت الفقّاعات تتصاعد بقوّة في كامل حجمه، الثالث تُرك مكشوفًا في الهواء الطلق أسبوعًا فنقص منسوبه دون أن يغلي أبدًا. سمِّ التحوّل الذي حدث في كلّ وعاء بالترتيب.', '[{"id":"a","text":"الأوّل غليان، الثاني تصلّب، الثالث تكاثف"},{"id":"b","text":"الأوّل تصلّب، الثاني غليان، الثالث تبخّر"},{"id":"c","text":"الأوّل انصهار، الثاني تبخّر، الثالث غليان"},{"id":"d","text":"الثلاثة خضعت لنفس التحوّل بالضبط"}]'::jsonb, 'b', 'الوعاء الأوّل خضع للتصلّب (تحوّل كامل إلى جليد بالتبريد)، والثاني للغليان (فقّاعات قوية في كامل الحجم)، والثالث للتبخّر (نقصان بطيء دون غليان في الهواء الطلق).', 5, 'mcq', NULL, NULL)
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
  ('7081d8b2-d46b-538c-86ff-26061952c470', '49fb92aa-01be-5a83-a53f-790259d36bb4', 'زُوِّد وعاء بكمّية معلومة من الجليد، فوُزنت كتلته قبل تركه ينصهر بالكامل داخل وعاء مغلق، ثمّ وُزن الماء السائل الناتج فوُجدت كتلته مساوية تمامًا لكتلة الجليد الأصلي. أيّ مبدأ فيزيائي يفسّر هذه النتيجة؟', '[{"id":"a","text":"مصادفة عددية لا قاعدة عامّة وراءها"},{"id":"b","text":"خطأ في قراءة الميزان يجب تصحيحه"},{"id":"c","text":"الجليد يكتسب دائمًا كتلة إضافية عند الانصهار"},{"id":"d","text":"مبدأ حفظ الكتلة أثناء تغيّر الحالة: التحوّل الفيزيائي يغيّر الشكل الخارجي فقط دون أن يفقد الماء أو يكتسب أيّ كتلة"}]'::jsonb, 'd', 'تساوي كتلة الماء الناتج مع كتلة الجليد الأصلي داخل وعاء مغلق يوضّح مبدأ حفظ الكتلة أثناء تغيّر الحالة: التحوّل الفيزيائي (كالانصهار) يغيّر شكل الماء الخارجي فقط، دون أن يفقد أو يكتسب أيّ كتلة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fa103e1a-5e49-5859-9419-389b9f560220', 'de42be60-e632-501f-a76c-74b321251372', 'sciences-physiques-7eme', '👑 قمّة التحدّي ⭐⭐⭐⭐: إتقان تغيّرات حالة الماء وحفظ الكتلة', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5395abad-43a2-523e-aec0-e574f3cd2cf1', 'fa103e1a-5e49-5859-9419-389b9f560220', 'ما اسم التحوّل الذي يفسّر جفاف بركة ماء صغيرة تدريجيًّا في يوم بارد وغائم دون أن تسخن الشمس الماء كثيرًا؟', '[{"id":"a","text":"الغليان، لأنّه الوحيد الذي يفسّر جفاف الماء"},{"id":"b","text":"التبخّر، لأنّه يحدث في أيّ درجة حرارة ولو منخفضة نسبيًّا، بخلاف الغليان الذي يتطلّب درجة حرارة ثابتة ومرتفعة"},{"id":"c","text":"التكاثف، لأنّه يحدث دائمًا في الطقس البارد"},{"id":"d","text":"التصلّب، لأنّ الطقس بارد وغائم"}]'::jsonb, 'b', 'التبخّر يحدث في أيّ درجة حرارة، حتّى المنخفضة نسبيًّا، لأنّه لا يتطلّب بلوغ درجة حرارة ثابتة معيّنة كالغليان؛ لهذا يمكن لبركة ماء أن تجفّ تدريجيًّا حتّى في طقس بارد نسبيًّا.', 1, 'mcq', NULL, NULL)
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
  ('42f8eb4d-9b46-535e-abe4-906819676337', 'fa103e1a-5e49-5859-9419-389b9f560220', 'كتب تلميذ في تقريره: «سخّنتُ الماء في القدر، وعند بلوغه 100°C بدأت درجة حرارته ترتفع بسرعة أكبر بسبب الفقّاعات الكثيرة التي تحرّر حرارة إضافية». أين يكمن الخطأ في هذا التقرير؟', '[{"id":"a","text":"لا خطأ في هذا التقرير، وصفه دقيق تمامًا"},{"id":"b","text":"الخطأ أنّه ذكر درجة 100°C وهي غير صحيحة أصلًا"},{"id":"c","text":"الخطأ أنّ درجة حرارة الماء تثبت عند 100°C أثناء الغليان ولا ترتفع أسرع، فالفقّاعات لا تحرّر حرارة إضافية بل هي علامة تحوّل الماء إلى بخار"},{"id":"d","text":"الخطأ أنّ الفقّاعات تدلّ على انخفاض درجة الحرارة لا ثباتها"}]'::jsonb, 'c', 'الخطأ الشائع في هذا التقرير هو الظنّ بأنّ الفقّاعات تسرّع ارتفاع درجة الحرارة؛ في الحقيقة، درجة حرارة الماء تثبت عند 100°C طوال الغليان، والفقّاعات هي فقط علامة تحوّل الماء السائل إلى بخار، لا مصدر حرارة إضافية.', 2, 'mcq', NULL, NULL)
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
  ('fc863b54-e518-5aeb-b344-cbb1ffcccf51', 'fa103e1a-5e49-5859-9419-389b9f560220', 'يلاحظ راصد جوّي أنّ درجة حرارة الهواء في قمّة جبل مرتفع أدنى بكثير من درجتها عند سفحه، وأنّ الغيوم غالبًا ما تتكوّن قرب القمم الباردة لا في الأودية الحارّة. ما العلاقة الفيزيائية بين برودة القمّة وتكوّن الغيوم هناك؟', '[{"id":"a","text":"لا علاقة بين برودة الهواء وتكوّن الغيوم إطلاقًا"},{"id":"b","text":"برودة الهواء عند القمّة تُسرّع تكاثف بخار الماء الصاعد من الأسفل، فتتكوّن الغيوم هناك؛ الهواء الحارّ في الأودية يُبقي الماء بخارًا دون تكاثف"},{"id":"c","text":"الغيوم تتكوّن فقط بسبب ارتفاع الجبل نفسه بغضّ النظر عن درجة الحرارة"},{"id":"d","text":"برودة القمّة تمنع أيّ تحوّل فيزيائي للماء هناك"}]'::jsonb, 'b', 'التكاثف (تحوّل بخار الماء إلى قطرات سائلة تكوّن الغيوم) يحدث عند تبريد بخار الماء؛ فبرودة الهواء قرب قمم الجبال تُسهّل هذا التبريد وتُسرّع التكاثف، بينما يبقى بخار الماء غير متكاثف في الهواء الحارّ بالأودية.', 3, 'mcq', NULL, NULL)
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
  ('f8eefa7d-1b64-59f8-b14f-b7f093f388b8', 'fa103e1a-5e49-5859-9419-389b9f560220', 'أيّ العبارات التالية بخصوص تغيّرات حالة الماء هي الصحيحة؟', '[{"id":"a","text":"الانصهار والغليان كلاهما يحدثان عند تسخين الماء، لكنّ الأوّل ينقل الماء من صلب إلى سائل والثاني من سائل إلى غاز"},{"id":"b","text":"التصلّب والتبخّر كلاهما يحدثان عند تبريد الماء"},{"id":"c","text":"التكاثف والانصهار كلاهما تحوّلان من الحالة الغازية"},{"id":"d","text":"الغليان يحدث دائمًا عند درجة حرارة أدنى من درجة الانصهار"}]'::jsonb, 'a', 'العبارة الأولى صحيحة: الانصهار (صلب إلى سائل) والغليان (سائل إلى غاز) يحدثان كلاهما عند التسخين، لكن ينقلان الماء بين حالتين مختلفتين؛ العبارات الأخرى خاطئة (التبخّر يحدث عند التسخين لا التبريد، والانصهار ليس من الحالة الغازية، والغليان عند 100°C أعلى من درجة الانصهار 0°C).', 4, 'mcq', NULL, NULL)
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
  ('a6916b79-311e-5e47-8e25-d25c02b96252', 'fa103e1a-5e49-5859-9419-389b9f560220', 'وضع تلميذ 200غ من الماء في قدر مغلق بإحكام (بحيث لا يخرج منه أيّ بخار)، وسخّنه حتّى بدأ الماء يغلي وتحوّل جزء منه إلى بخار محبوس داخل القدر المغلق. ما كتلة المادّة الكلّية (ماء سائل + بخار) داخل القدر المغلق عند تلك اللحظة؟', '[{"id":"a","text":"أقلّ من 200غ لأنّ البخار خفيف الوزن"},{"id":"b","text":"أكثر من 200غ لأنّ الحرارة تضيف كتلة"},{"id":"c","text":"200غ بالضبط، لأنّ القدر مغلق ولم تُفقد أو تُكتسب أيّ مادّة، فالغليان غيّر توزيع الماء بين الحالتين لا كتلته الكلّية"},{"id":"d","text":"لا يمكن تحديد الكتلة الكلّية إطلاقًا"}]'::jsonb, 'c', 'بما أنّ القدر مغلق بإحكام، لا يغادر أيّ بخار الوعاء ولا تدخله أيّ مادّة إضافية؛ فكتلة الماء الكلّية (السائل المتبقّي زائد البخار المحبوس) تبقى 200غ بالضبط، إذ إنّ الغليان تحوّل فيزيائي يوزّع كتلة الماء بين حالتين دون أن يغيّر مجموعها.', 5, 'mcq', NULL, NULL)
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
  ('1bd022d3-5a95-5cb0-9f3a-6cb397a24e01', 'fa103e1a-5e49-5859-9419-389b9f560220', 'لاحظ تلميذان تجربتين منفصلتين: التجربة الأولى، بلغت درجة حرارة عيّنة ماء 0°C بالضبط بينما كانت تُسخَّن تدريجيًّا من حالة صلبة ابتداءً. التجربة الثانية، بلغت عيّنة ماء أخرى 0°C بالضبط بينما كانت تُبرَّد تدريجيًّا من حالة سائلة ابتداءً. ما التحوّل الذي يحدث في كلّ تجربة على التوالي؟', '[{"id":"a","text":"الأولى انصهار (الجليد يبدأ بالتحوّل إلى سائل)، والثانية تصلّب (الماء السائل يبدأ بالتحوّل إلى جليد)"},{"id":"b","text":"كلاهما انصهار لأنّ الدرجة نفسها 0°C"},{"id":"c","text":"كلاهما تصلّب لأنّ الدرجة نفسها 0°C"},{"id":"d","text":"الأولى تصلّب، والثانية انصهار"}]'::jsonb, 'a', 'رغم أنّ الدرجة 0°C واحدة في التجربتين، فإنّ اتّجاه التسخين أو التبريد هو ما يحدّد التحوّل: في التجربة الأولى (تسخين من حالة صلبة) يحدث الانصهار، وفي الثانية (تبريد من حالة سائلة) يحدث التصلّب — نفس الدرجة المعلمة، لكن باتّجاهين متعاكسين.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e84af202-879a-5dba-9878-bfec67588ff7', '555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', 'ما تعريف المزيج المتجانس؟', '[{"id":"a","text":"مزيج لا نستطيع تمييز مكوّناته بالعين المجرّدة"},{"id":"b","text":"مزيج نميّز فيه مكوّنَين على الأقلّ بالعين المجرّدة"},{"id":"c","text":"مزيج يحتوي على الماء فقط دون أيّ مادّة أخرى"},{"id":"d","text":"مزيج ناتج عن الترسيب حصرًا"}]'::jsonb, 'a', 'المزيج المتجانس هو مزيج لا نستطيع تمييز مكوّناته بالعين المجرّدة، كماء وسكّر مذاب تمامًا.', 1, 'mcq', NULL, NULL)
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
  ('10a4b814-1b0a-5c74-80a7-b39652443726', '555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', 'أيّ ممّا يلي مثال على مزيج غير متجانس؟', '[{"id":"a","text":"ماء وملح مذاب تمامًا"},{"id":"b","text":"ماء وسكّر مذاب تمامًا"},{"id":"c","text":"ماء وخلّ ممتزج تمامًا"},{"id":"d","text":"ماء ورمل عالق"}]'::jsonb, 'd', 'الماء والرمل مزيج غير متجانس، إذ تبقى حبيبات الرمل ظاهرة للعين المجرّدة، خلافًا للملح والسكّر والخلّ التي تذوب أو تمتزج تمامًا في الماء.', 2, 'mcq', NULL, NULL)
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
  ('0df5716e-4ee0-5489-b0b1-5f64f174e845', '555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', 'ما اسم الطريقة التي تعتمد على ترك المزيج ساكنًا حتّى تستقرّ الحبيبات الثقيلة في قاع الإناء؟', '[{"id":"a","text":"الترشيح"},{"id":"b","text":"التقطير"},{"id":"c","text":"الترسيب"},{"id":"d","text":"التعقيم"}]'::jsonb, 'c', 'الترسيب هو ترك المزيج غير المتجانس ساكنًا فترة من الزمن حتّى تسقط الحبيبات الصلبة الثقيلة نحو قاع الإناء.', 3, 'mcq', NULL, NULL)
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
  ('4589783d-01e3-5a2a-87f9-8083ca1d3756', '555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', 'ما الطريقة المناسبة لفصل ملح مذاب تمامًا عن الماء؟', '[{"id":"a","text":"الترسيب"},{"id":"b","text":"التقطير"},{"id":"c","text":"الترشيح"},{"id":"d","text":"لا توجد طريقة ممكنة"}]'::jsonb, 'b', 'التقطير هو الطريقة المناسبة لفصل ملح مذاب تمامًا في الماء، إذ يتبخّر الماء بالتسخين ويبقى الملح، ثمّ يتكاثف البخار من جديد بعد تبريده.', 4, 'mcq', NULL, NULL)
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
  ('f716718e-4332-507d-8e60-f5094dcd0286', '555fbfc2-1a09-5a1a-8dfc-e8113b9c4160', 'ما أوّل خطوة عادة في معالجة الماء الطبيعي العكر ليصبح صالحًا للشرب؟', '[{"id":"a","text":"الترسيب"},{"id":"b","text":"التعقيم"},{"id":"c","text":"التوزيع مباشرة للمنازل"},{"id":"d","text":"الترشيح قبل أيّ خطوة أخرى"}]'::jsonb, 'a', 'تبدأ معالجة الماء الطبيعي العكر بالترسيب لإزالة معظم حبيبات الطين الثقيلة، قبل الانتقال إلى الترشيح ثمّ التعقيم.', 5, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', '⭐ تمرين: المزائج والترسيب والترشيح', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('da845378-3281-504d-bd19-982e3a1a1e76', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'ماء مذاب فيه سكّر تمامًا حتّى اختفى عن العين المجرّدة. كيف نصنّف هذا المزيج؟', '[{"id":"a","text":"مزيج متجانس"},{"id":"b","text":"مزيج غير متجانس"},{"id":"c","text":"ليس مزيجًا"},{"id":"d","text":"جسم نقيّ فقط"}]'::jsonb, 'a', 'عندما تختفي مكوّنات المزيج بحيث لا نستطيع تمييزها بالعين المجرّدة، كماء وسكّر مذاب تمامًا، يكون المزيج متجانسًا.', 1, 'mcq', NULL, NULL)
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
  ('7071a6a1-e36d-5351-bfad-7d4c84890853', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'أيّ ممّا يلي مثال على مزيج غير متجانس؟', '[{"id":"a","text":"ماء وملح مذاب تمامًا"},{"id":"b","text":"ماء وزيت"},{"id":"c","text":"ماء وسكّر مذاب تمامًا"},{"id":"d","text":"ماء وخلّ ممتزج تمامًا"}]'::jsonb, 'b', 'الماء والزيت لا يمتزجان، فتبقى قطيرات الزيت ظاهرة للعين المجرّدة فوق الماء، لذلك يكون المزيج غير متجانس؛ أمّا الملح والسكّر والخلّ فتذوب أو تمتزج تمامًا في الماء.', 2, 'mcq', NULL, NULL)
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
  ('764dc957-372f-5b11-a52a-f2d1a40d0060', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'ما اسم الطريقة التي تعتمد على ترك مزيج غير متجانس ساكنًا حتّى تستقرّ الحبيبات الثقيلة في القاع؟', '[{"id":"a","text":"الترشيح"},{"id":"b","text":"التقطير"},{"id":"c","text":"الترسيب"},{"id":"d","text":"التبخير"}]'::jsonb, 'c', 'الترسيب هو ترك المزيج ساكنًا فترة من الزمن حتّى تسقط الحبيبات الصلبة الثقيلة نحو قاع الإناء بفعل ثقلها.', 3, 'mcq', NULL, NULL)
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
  ('965783e0-4c50-5c51-9b8a-aa7aed77d53e', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'ماذا نسمّي الجسم الصلب الذي يستقرّ في قاع الإناء بعد عملية الترسيب؟', '[{"id":"a","text":"الراشح"},{"id":"b","text":"البخار"},{"id":"c","text":"المحلول"},{"id":"d","text":"الراسب"}]'::jsonb, 'd', 'الجسم الصلب الذي يستقرّ في قاع الإناء بعد الترسيب يُسمّى الراسب.', 4, 'mcq', NULL, NULL)
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
  ('d292f93f-e642-5502-97b3-530bae391339', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'بماذا تُسمّى الورقة التي نضعها داخل القمع عند الترشيح؟', '[{"id":"a","text":"ورقة الترشيح"},{"id":"b","text":"ورقة التقطير"},{"id":"c","text":"الراسب"},{"id":"d","text":"المبرّد"}]'::jsonb, 'a', 'نضع ورقة الترشيح داخل القمع عند الترشيح، فتحجز الحبيبات الصلبة وتترك السائل الصافي يمرّ عبرها.', 5, 'mcq', NULL, NULL)
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
  ('3bcc87a6-8c8e-5f29-a8cb-bbc5cb503760', '8fc8478a-71cd-5fcf-90af-52df65e4c5c8', 'ماذا نسمّي السائل الصافي الذي يمرّ عبر ورقة الترشيح ويتساقط في الإناء؟', '[{"id":"a","text":"الراسب"},{"id":"b","text":"الراشح"},{"id":"c","text":"البخار المتكاثف"},{"id":"d","text":"الملح الجاف"}]'::jsonb, 'b', 'السائل الصافي الذي يعبر ورقة الترشيح ويتساقط في الإناء يُسمّى الراشح.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('af4faee6-30b8-5638-962a-332ab27bfd59', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: فصل المزائج', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77ae493e-288c-5185-ba93-e0b8c8299d3e', 'af4faee6-30b8-5638-962a-332ab27bfd59', 'ما الفرق الأساسي بين الترسيب والترشيح؟', '[{"id":"a","text":"الترسيب يعتمد على الانتظار فقط دون أدوات، بينما الترشيح يستعمل ورقة ترشيح وقمعًا"},{"id":"b","text":"لا فرق بينهما إطلاقًا"},{"id":"c","text":"الترسيب يحتاج إلى تسخين، والترشيح لا يحتاج إلى تسخين"},{"id":"d","text":"الترشيح يفصل مزيجًا متجانسًا فقط"}]'::jsonb, 'a', 'الترسيب يعتمد فقط على ترك المزيج ساكنًا حتّى تستقرّ الحبيبات بثقلها، بينما الترشيح يستعمل أداة إضافية هي ورقة الترشيح والقمع لتمرير السائل وحجز الحبيبات الصلبة.', 1, 'mcq', NULL, NULL)
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
  ('cdca1bec-3a7a-5f04-b823-cdb522949089', 'af4faee6-30b8-5638-962a-332ab27bfd59', 'لماذا لا تستطيع الترشيح فصل الملح المذاب تمامًا عن الماء؟', '[{"id":"a","text":"لأنّ ورقة الترشيح تذوب في الماء"},{"id":"b","text":"لأنّ الملح ذاب في الماء فلم يعد جسمًا صلبًا منفصلًا يمكن حجزه بالورقة"},{"id":"c","text":"لأنّ الترشيح يحتاج إلى مبرّد خاصّ"},{"id":"d","text":"لأنّ الملح أثقل من الماء دائمًا"}]'::jsonb, 'b', 'بعد ذوبان الملح تمامًا في الماء، يصبح المزيج متجانسًا ولا توجد حبيبات صلبة منفصلة تحجزها ورقة الترشيح؛ فمسامّ الورقة تدع الماء المالح كلّه يمرّ معًا.', 2, 'mcq', NULL, NULL)
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
  ('bae9f5d0-05fa-5cb4-af59-5bbc252da60e', 'af4faee6-30b8-5638-962a-332ab27bfd59', 'كيف يفصل التقطير مكوّنات مزيج متجانس؟', '[{"id":"a","text":"بتمرير المزيج عبر ورقة ترشيح فقط"},{"id":"b","text":"بترك المزيج ساكنًا حتّى يستقرّ"},{"id":"c","text":"بتسخين المزيج حتّى الغليان ثمّ تبريد البخار الناتج ليتكاثف من جديد"},{"id":"d","text":"بإضافة الملح إلى المزيج"}]'::jsonb, 'c', 'التقطير يسخّن المزيج المتجانس حتّى الغليان فيتبخّر الماء، ثمّ يمرّ البخار عبر مبرّد فيتكاثف من جديد إلى ماء سائل نقيّ يُجمع في إناء آخر.', 3, 'mcq', NULL, NULL)
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
  ('0e573e90-016b-526f-8d60-221510ac592e', 'af4faee6-30b8-5638-962a-332ab27bfd59', 'جلب فلاّح ماءً عكرًا من واد قريب. ما أوّل خطوة منطقية لبدء تنقيته قبل الترشيح؟', '[{"id":"a","text":"تعقيمه بالكلور مباشرة"},{"id":"b","text":"تقطيره مباشرة دون أيّ خطوة أخرى"},{"id":"c","text":"شربه كما هو"},{"id":"d","text":"تركه ساكنًا مدّة ليترسّب الطين الثقيل أوّلًا"}]'::jsonb, 'd', 'الخطوة الأولى المنطقية هي الترسيب: ترك الماء العكر ساكنًا ليستقرّ الطين الثقيل في القاع، ممّا يخفّف العبء عن ورقة الترشيح في الخطوة التالية.', 4, 'mcq', NULL, NULL)
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
  ('7cefe44d-e21d-558a-9c02-a829d053150b', 'af4faee6-30b8-5638-962a-332ab27bfd59', 'أيّ العبارات التالية **خاطئة** بخصوص تقنيات فصل المزائج؟', '[{"id":"a","text":"التقطير يصلح لفصل حبيبات الرمل عن الماء فقط دون أيّ تسخين"},{"id":"b","text":"الترسيب يعتمد على ثقل الحبيبات الصلبة"},{"id":"c","text":"الترشيح يستعمل ورقة ترشيح وقمعًا"},{"id":"d","text":"التقطير يفصل مكوّنات مزيج متجانس بالتسخين والتبريد"}]'::jsonb, 'a', 'العبارة الأولى خاطئة: فصل حبيبات الرمل (جسم صلب غير مذاب) عن الماء يتمّ بالترسيب أو الترشيح دون تسخين، أمّا التقطير فيحتاج إلى تسخين ويستعمل لفصل مزيج متجانس كملح مذاب في الماء، لا لحبيبات رمل ظاهرة.', 5, 'mcq', NULL, NULL)
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
  ('171acff5-f5ec-5a19-91c7-ec375e4c5e8c', 'af4faee6-30b8-5638-962a-332ab27bfd59', 'امتزج الملح تمامًا بالماء فاختفى عن العين المجرّدة. أراد تلميذ استرجاع الملح الجافّ من هذا المزيج. أيّ طريقة تحقّق هدفه؟', '[{"id":"a","text":"الترسيب فقط"},{"id":"b","text":"الترشيح فقط"},{"id":"c","text":"التقطير، إذ يتبخّر الماء ويبقى الملح في الإناء"},{"id":"d","text":"لا توجد طريقة تحقّق ذلك"}]'::jsonb, 'c', 'بتسخين المزيج المتجانس حتّى الغليان، يتبخّر الماء (المادّة الأكثر تطايرًا) ويبقى الملح في الإناء الأصلي، فيسترجعه التلميذ جافًّا؛ الترسيب والترشيح لا يفيدان هنا لأنّ الملح مذاب لا صلب ظاهر.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8062b6dc-baa0-501d-9567-adc4df833cd6', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): المزائج ومعالجة الماء', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('875fcb04-6c65-5c5e-84a6-f08efa922043', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'ماء البحر يحتوي على ملح مذاب تمامًا فيه. كيف نصنّف ماء البحر من حيث التجانس؟', '[{"id":"a","text":"مزيج غير متجانس"},{"id":"b","text":"مزيج متجانس"},{"id":"c","text":"ليس مزيجًا لأنّه ماء طبيعي"},{"id":"d","text":"جسم صلب فقط"}]'::jsonb, 'b', 'رغم أنّ ماء البحر يحتوي على ملح، فإنّ هذا الملح مذاب تمامًا ولا نميّزه بالعين المجرّدة، فيُصنَّف ماء البحر مزيجًا متجانسًا.', 1, 'mcq', NULL, NULL)
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
  ('4565a6d0-57fb-55e0-983b-2d19ee1ebd71', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'ما الخطوة التي تلي الترسيب مباشرة في معالجة الماء الطبيعي؟', '[{"id":"a","text":"الترشيح"},{"id":"b","text":"التعقيم مباشرة قبل الترشيح"},{"id":"c","text":"التوزيع مباشرة للمنازل"},{"id":"d","text":"إعادة الترسيب من جديد"}]'::jsonb, 'a', 'بعد الترسيب الذي يزيل الطين الثقيل، تأتي مرحلة الترشيح لإزالة الحبيبات الدقيقة المتبقّية، قبل التعقيم الأخير بالكلور.', 2, 'mcq', NULL, NULL)
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
  ('adda0393-0d0f-5e0f-99a7-a150b4cbae05', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'لماذا تُضاف مادّة الكلور في مرحلة التعقيم أثناء معالجة الماء؟', '[{"id":"a","text":"لتغيير لون الماء"},{"id":"b","text":"لتبريد الماء"},{"id":"c","text":"للقضاء على الجراثيم الضارّة الموجودة فيه"},{"id":"d","text":"لتذويب حبيبات الطين"}]'::jsonb, 'c', 'تُضاف كمّية صغيرة من الكلور في مرحلة التعقيم للقضاء على الجراثيم المتبقّية في الماء، فيصبح آمنًا للشرب.', 3, 'mcq', NULL, NULL)
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
  ('cdc90f4e-6f8d-5020-8b65-fc5308e33c87', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'أيّ زوج من المصطلحات يرتبط بالترشيح تحديدًا؟', '[{"id":"a","text":"الغليان والتكاثف"},{"id":"b","text":"الاستقرار والراسب فقط"},{"id":"c","text":"المبرّد والبخار"},{"id":"d","text":"القمع وورقة الترشيح"}]'::jsonb, 'd', 'القمع وورقة الترشيح هما الأداتان المستعملتان في الترشيح لحجز الحبيبات الصلبة وتمرير السائل الصافي؛ الغليان والتكاثف والمبرّد يرتبطان بالتقطير.', 4, 'mcq', NULL, NULL)
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
  ('28828828-e727-5ea4-a0df-98591105773a', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'أيّ ممّا يلي مصدر من مصادر تلوّث الماء؟', '[{"id":"a","text":"الترسيب الطبيعي للطين في السدود"},{"id":"b","text":"صرف مياه المصانع دون معالجة في الوادي"},{"id":"c","text":"بناء سدّ لتجميع مياه الأمطار"},{"id":"d","text":"ترشيح الماء عبر طبقة رمل"}]'::jsonb, 'b', 'صرف مياه المصانع الملوّثة دون معالجة في الأودية أو البحر يُعدّ من أهمّ مصادر تلوّث الماء؛ أمّا الترسيب والترشيح وبناء السدود فعمليات طبيعية أو تقنية لا تلوّث الماء.', 5, 'mcq', NULL, NULL)
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
  ('354627b4-4b60-5958-948d-f870f30ae9c5', '8062b6dc-baa0-501d-9567-adc4df833cd6', 'أيّ سلوك يساهم في المحافظة على سلامة الماء؟', '[{"id":"a","text":"عدم رمي النفايات والموادّ الكيميائية في الأودية والسدود"},{"id":"b","text":"رمي المبيدات الفلاحية الزائدة في الوادي القريب"},{"id":"c","text":"ترك صنبور الماء مفتوحًا دون استعمال"},{"id":"d","text":"صرف مياه الصرف الصحّي مباشرة في البحر دون معالجة"}]'::jsonb, 'a', 'عدم رمي النفايات والموادّ الكيميائية في مصادر الماء يحافظ على سلامتها؛ أمّا رمي المبيدات أو النفايات أو تبذير الماء أو صرف المياه القذرة دون معالجة فسلوكيات تضرّ بالماء.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e705c775-f366-5999-b49d-c4d9c5264b49', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: فصل المزائج ومعالجة الماء', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1fdaf8dd-6a91-5888-85c5-9c5582f46d00', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'امتزج الخلّ تمامًا بالماء فكوّنا مزيجًا واحد المظهر. أراد تلميذ فصل الخلّ عن الماء لاحقًا. أيّ تقنية من التقنيات الثلاث تصلح لهذا الهدف؟', '[{"id":"a","text":"الترسيب فقط"},{"id":"b","text":"الترشيح فقط"},{"id":"c","text":"التقطير، لأنّ المزيج متجانس ولا يحتوي على جسم صلب ظاهر"},{"id":"d","text":"لا توجد أيّ تقنية تصلح"}]'::jsonb, 'c', 'الخلّ والماء يمتزجان امتزاجًا تامًا مكوّنَين مزيجًا متجانسًا؛ فصل مكوّناته يتطلّب التقطير الذي يستغلّ التسخين والتبريد، لا الترسيب ولا الترشيح المخصّصَين لفصل جسم صلب عن سائل.', 1, 'mcq', NULL, NULL)
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
  ('c0c9b423-b23c-5149-a506-e655a6dc9dd0', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'اتّبع تلميذ الخطوات التالية لتنقية ماء عكر: (1) رشّح الماء مباشرة عبر ورقة ترشيح. (2) عقّمه بالكلور. (3) تركه يستقرّ أخيرًا ليترسّب الطين المتبقّي. أين يكمن الخطأ الأساسي في ترتيبه؟', '[{"id":"a","text":"لا يوجد أيّ خطأ في هذا الترتيب"},{"id":"b","text":"الخطأ أنّه استعمل الكلور بدل الرمل"},{"id":"c","text":"الخطأ أنّه لم يستعمل التقطير إطلاقًا"},{"id":"d","text":"الخطأ أنّه بدأ بالترشيح بدل الترسيب، ممّا يُسدّ ورقة الترشيح بسرعة بكمّية الطين الكبيرة، والأصحّ الترسيب أوّلًا ثمّ الترشيح ثمّ التعقيم أخيرًا"}]'::jsonb, 'd', 'الخطأ الشائع هو قلب ترتيب الخطوات: يجب الترسيب أوّلًا لإزالة معظم الطين الثقيل، ثمّ الترشيح لإزالة الحبيبات الدقيقة المتبقّية، ثمّ التعقيم أخيرًا بالكلور للقضاء على الجراثيم؛ البدء بالترشيح مباشرة يُتلف ورقة الترشيح بسرعة.', 2, 'mcq', NULL, NULL)
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
  ('91437c9a-44f6-5568-86ef-b81735e2e87f', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'أيّ العبارات التالية عن المزائج **صحيحة**؟', '[{"id":"a","text":"مزيج ماء وزيت غير متجانس لأنّ قطيرات الزيت تبقى ظاهرة فوق الماء"},{"id":"b","text":"كلّ مزيج يحتوي على أكثر من مكوّن هو بالضرورة مزيج متجانس"},{"id":"c","text":"الترسيب يفصل مكوّنات أيّ مزيج متجانس بسهولة"},{"id":"d","text":"التقطير لا يحتاج إلى أيّ تسخين إطلاقًا"}]'::jsonb, 'a', 'مزيج الماء والزيت غير متجانس فعلًا لأنّ قطيرات الزيت تبقى مرئية بالعين المجرّدة فوق الماء؛ العبارات الأخرى خاطئة: وجود أكثر من مكوّن لا يعني بالضرورة تجانسًا، والترسيب لا يفيد في فصل مزيج متجانس، والتقطير يحتاج تسخينًا وتبريدًا لا محالة.', 3, 'mcq', NULL, NULL)
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
  ('32df9a13-3242-5e26-b3a6-1b8cb5171fec', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'احتوى إناء على ماء ورمل، فترك التلميذ المزيج ساكنًا فاستقرّ معظم الرمل في القاع، لكن بقيت حبيبات دقيقة جدًّا عالقة في الماء فوق الرمل المترسّب. ما الخطوة الإضافية المناسبة لإزالة هذه الحبيبات الدقيقة؟
<svg viewBox="0 0 200 235">
<title>الإناء بعد الترسيب</title>
<rect x="60" y="78" width="80" height="127" fill="#bfdbfe" stroke="none" stroke-width="2"/><polygon points="60,205 140,205 140,180 130,176 115,181 100,175 85,180 70,176 60,180" fill="#b45309" stroke="none" stroke-width="2"/><circle cx="80" cy="100" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="100" cy="112" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="120" cy="98" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="92" cy="130" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="112" cy="140" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="76" cy="120" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="128" cy="125" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="104" cy="155" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="88" cy="150" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><circle cx="120" cy="160" r="1.8" fill="#78350f" stroke="none" stroke-width="2"/><line x1="60" y1="78" x2="140" y2="78" stroke="#1d4ed8" stroke-width="2"/><polyline points="58,47 60,57 60,205 140,205 140,57 142,47" fill="none" stroke="#0f172a" stroke-width="3"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="100" y="45" text-anchor="middle" fill="#1d4ed8" font-size="13">ماء عكِر</text><text x="100" y="168" text-anchor="middle" fill="#7c2d12" font-size="12">رمل مترسّب</text></g>
</svg>', '[{"id":"a","text":"الاكتفاء بالترسيب فهو يكفي دائمًا"},{"id":"b","text":"ترشيح الماء العالي فوق الرمل المترسّب عبر ورقة ترشيح"},{"id":"c","text":"تقطير الرمل المترسّب مباشرة"},{"id":"d","text":"إضافة مزيد من الرمل إلى الإناء"}]'::jsonb, 'b', 'الترسيب لا يزيل الحبيبات الدقيقة جدًّا؛ فترشيح الماء الأصفى فوق الرمل المترسّب عبر ورقة ترشيح يحجز هذه الحبيبات الدقيقة المتبقّية ويكمل ما بدأه الترسيب.', 4, 'mcq', NULL, NULL)
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
  ('07c06b8b-8a69-54ed-8dd3-5282ae623644', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'لاحظ سكّان قرية أنّ ماء الوادي القريب أصبح ذا رائحة كريهة بعد أن بدأ مصنع قريب بصرف مياهه الملوّثة فيه دون معالجة. ما الإجراء الأنسب لحماية الوادي من هذا التلوّث مستقبلًا؟', '[{"id":"a","text":"الاكتفاء بترشيح ماء الوادي فقط دون أيّ إجراء آخر"},{"id":"b","text":"زيادة كمّية المياه المصروفة لتخفيف التلوّث"},{"id":"c","text":"إلزام المصنع بمعالجة مياهه قبل صرفها في الوادي"},{"id":"d","text":"نقل السكّان بعيدًا عن الوادي دون أيّ حلّ للمصنع"}]'::jsonb, 'c', 'الحلّ الجذري لحماية الوادي هو إلزام المصنع بمعالجة مياه صرفه قبل تصريفها فيه، فالترشيح لماء الوادي وحده لا يمنع استمرار التلوّث عند المصدر، وزيادة كمّية الصرف تزيد المشكلة لا تحلّها.', 5, 'mcq', NULL, NULL)
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
  ('71720a68-6c94-573f-9a7b-9a59094f79c7', 'e705c775-f366-5999-b49d-c4d9c5264b49', 'أراد باحث التمييز بين عيّنتين: الأولى ماء وسكّر ممزوجان تمامًا، والثانية ماء ورمل عالق. أيّ ملاحظة بالعين المجرّدة وحدها تكفي للتمييز بينهما دون أيّ اختبار إضافي؟', '[{"id":"a","text":"قياس درجة حرارة كلّ عيّنة"},{"id":"b","text":"تذوّق كلّ عيّنة"},{"id":"c","text":"وزن كلّ عيّنة"},{"id":"d","text":"ملاحظة ظهور حبيبات صلبة عالقة في العيّنة الثانية وغيابها في الأولى"}]'::jsonb, 'd', 'العيّنة الثانية (ماء ورمل) غير متجانسة فتظهر فيها حبيبات الرمل بالعين المجرّدة، بينما العيّنة الأولى (ماء وسكّر مذاب) متجانسة المظهر تمامًا دون أيّ حبيبات ظاهرة؛ هذه الملاحظة البصرية وحدها تكفي للتمييز دون حاجة لتذوّق أو وزن أو قياس حرارة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للمزائج ومعالجة الماء', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4b4a9bf8-e61f-5e12-a6b5-898d05c589f5', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', 'ما تعريف المزيج غير المتجانس؟', '[{"id":"a","text":"مزيج نستطيع تمييز مكوّنَين على الأقلّ منه بالعين المجرّدة"},{"id":"b","text":"مزيج لا نستطيع تمييز أيّ مكوّن منه إطلاقًا"},{"id":"c","text":"مزيج يحتوي على الماء فقط"},{"id":"d","text":"مزيج ناتج عن التقطير حصرًا"}]'::jsonb, 'a', 'المزيج غير المتجانس هو مزيج نستطيع أن نميّز فيه مكوّنَين على الأقلّ بالعين المجرّدة، كالماء والرمل أو الماء والزيت.', 1, 'mcq', NULL, NULL)
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
  ('9f144491-734d-5e14-ac0b-62eabaf23bf7', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', 'لماذا لا يكفي الترسيب وحده لتنقية ماء عكر تمامًا؟', '[{"id":"a","text":"لأنّ الترسيب يحتاج إلى تسخين لا يتوفّر دائمًا"},{"id":"b","text":"لأنّ الترسيب يزيل الملح المذاب فقط"},{"id":"c","text":"لأنّه لا يزيل الحبيبات الدقيقة جدًّا التي تبقى عالقة في الماء فوق الراسب"},{"id":"d","text":"لأنّ الترسيب يُتلف ورقة الترشيح"}]'::jsonb, 'c', 'الترسيب يزيل الحبيبات الثقيلة فقط التي تستقرّ في القاع، لكنّ حبيبات أدقّ تبقى عالقة في الماء الأصفى فوقه، فيحتاج الأمر إلى الترشيح لإزالتها.', 2, 'mcq', NULL, NULL)
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
  ('42318272-57b9-5532-99ea-16260f92f84d', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', 'ما الذي يميّز التقطير عن الترشيح بشكل أساسي؟', '[{"id":"a","text":"التقطير يستعمل ورقة ترشيح أيضًا"},{"id":"b","text":"التقطير يحتاج إلى تسخين وتبريد، بينما الترشيح لا يحتاج إلى أيّ تسخين"},{"id":"c","text":"لا فرق بينهما"},{"id":"d","text":"الترشيح يفصل مزيجًا متجانسًا فقط"}]'::jsonb, 'b', 'التقطير يعتمد على تسخين المزيج حتّى الغليان ثمّ تبريد بخاره ليتكاثف، بينما الترشيح يمرّر السائل عبر ورقة ترشيح في درجة حرارة عادية دون أيّ تسخين.', 3, 'mcq', NULL, NULL)
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
  ('64f019df-b76d-58e6-adf5-0e5dbc5a601e', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', 'رتّب خطوات معالجة الماء الطبيعي العكر ليصبح صالحًا للشرب بالترتيب الصحيح.', '[{"id":"a","text":"التعقيم ← الترشيح ← الترسيب"},{"id":"b","text":"الترشيح ← الترسيب ← التعقيم"},{"id":"c","text":"الترسيب ← التعقيم ← الترشيح"},{"id":"d","text":"الترسيب ← الترشيح ← التعقيم"}]'::jsonb, 'd', 'الترتيب الصحيح لمعالجة الماء الطبيعي هو الترسيب أوّلًا لإزالة الطين الثقيل، ثمّ الترشيح لإزالة الحبيبات الدقيقة المتبقّية، ثمّ التعقيم أخيرًا بالكلور للقضاء على الجراثيم.', 4, 'mcq', NULL, NULL)
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
  ('f0bc2eb7-5bac-5de0-b548-906e3313f1ef', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', 'أيّ العبارات التالية **خاطئة** بخصوص معالجة الماء وتلوّثه؟', '[{"id":"a","text":"صرف مياه المصانع الملوّثة في الوادي دون معالجة لا يضرّ بجودة الماء"},{"id":"b","text":"الترسيب يستقرّ فيه الطين الثقيل في القاع"},{"id":"c","text":"التعقيم بالكلور يقضي على الجراثيم الضارّة"},{"id":"d","text":"الترشيح يحجز الحبيبات الدقيقة المتبقّية بعد الترسيب"}]'::jsonb, 'a', 'العبارة الأولى خاطئة: صرف مياه المصانع الملوّثة دون معالجة يضرّ بجودة الماء ويلوّثه فعلًا؛ العبارات الثلاث الأخرى صحيحة وتصف مراحل معالجة الماء بدقّة.', 5, 'mcq', NULL, NULL)
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
  ('05861724-7b4f-5951-b113-3fa4bad3e5c2', 'aa3a4b3e-9b95-53b7-87d2-14cf033bd53f', 'لاحظ تلميذ أنّ ماء عين طبيعية صافٍ تمامًا بالعين المجرّدة، لكنّه يعلم أنّه يحتوي على أملاح معدنية مذابة فيه. أيّ استنتاج صحيح حول تصنيف هذا الماء وطريقة فصل أملاحه لو أراد ذلك؟', '[{"id":"a","text":"الماء غير متجانس لاحتوائه على أملاح، ويكفي ترشيحه لفصلها"},{"id":"b","text":"الماء متجانس، لكن لا يمكن فصل أملاحه بأيّ طريقة إطلاقًا"},{"id":"c","text":"الماء متجانس لأنّ الأملاح مذابة ولا تُرى بالعين المجرّدة، ويحتاج فصلها إلى التقطير"},{"id":"d","text":"الماء غير متجانس، ويكفي تركه يترسّب لفصل أملاحه"}]'::jsonb, 'c', 'رغم احتواء الماء على أملاح، فإنّها مذابة تمامًا ولا تُرى بالعين المجرّدة، فيُصنَّف الماء مزيجًا متجانسًا؛ ولفصل هذه الأملاح المذابة، الطريقة المناسبة الوحيدة من بين الثلاث هي التقطير، لا الترسيب ولا الترشيح.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('651b06b2-f6d4-5e63-be16-626ebca82db2', 'f26dd9da-8d0f-537a-b83d-1ab94a2dfa5c', 'sciences-physiques-7eme', '👑 قمّة التحدّي ⭐⭐⭐⭐: إتقان فصل المزائج ومعالجة الماء', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0510a07c-bcc5-59e2-91a7-88664c6cce3c', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'احتوى كأس على مزيج ماء وسكّر ذاب تمامًا، وكأس آخر على مزيج ماء ورمل عالق ظاهر للعين. أراد تلميذ استرجاع كلّ من السكّر والرمل جافّين من كأسيهما. أيّ توليفة من التقنيات تحقّق هدفه لكلّ كأس على التوالي؟', '[{"id":"a","text":"الترسيب للكأس الأوّل، والترشيح للكأس الثاني"},{"id":"b","text":"التقطير للكأسين معًا فقط"},{"id":"c","text":"الترشيح للكأس الأوّل، والتقطير للكأس الثاني"},{"id":"d","text":"التقطير لاسترجاع السكّر من الكأس الأوّل (مزيج متجانس)، والترشيح لاسترجاع الرمل من الكأس الثاني (مزيج غير متجانس)"}]'::jsonb, 'd', 'الكأس الأوّل مزيج متجانس (سكّر مذاب) فيحتاج التقطير لاسترجاع السكّر جافًّا بعد تبخّر الماء، أمّا الكأس الثاني مزيج غير متجانس (رمل عالق ظاهر) فيكفي الترشيح لحجز الرمل على ورقة الترشيح.', 1, 'mcq', NULL, NULL)
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
  ('2dad25f6-afe9-5231-b361-81e656c05f46', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'اتّبعت مصلحة معالجة الماء الخطوات التالية على ماء واد عكر: (1) عقّمته بالكلور فورًا دون أيّ خطوة سابقة. (2) رشّحته. (3) تركته يترسّب أخيرًا. لاحظ المهندسون أنّ الماء ظلّ غير صالح للشرب رغم إضافة الكلور. ما تفسير هذا الفشل؟', '[{"id":"a","text":"الكلور المستعمل كان كمّيته كبيرة جدًّا"},{"id":"b","text":"البدء بالتعقيم قبل الترسيب والترشيح جعل الطين الكثيف يعيق فعالية الكلور، والصحيح اتّباع الترتيب: ترسيب ثمّ ترشيح ثمّ تعقيم"},{"id":"c","text":"الماء الطبيعي لا يمكن تنقيته بأيّ ترتيب من الخطوات"},{"id":"d","text":"الترتيب لا علاقة له إطلاقًا بفعالية المعالجة"}]'::jsonb, 'b', 'الخطأ الشائع هو قلب الترتيب: تعقيم ماء لا يزال عكرًا بالطين يجعل الكلور يتفاعل مع الطين والموادّ العالقة بدل التركيز على الجراثيم، فتضعف فعاليته؛ الترتيب الصحيح هو الترسيب ثمّ الترشيح لتصفية الماء أوّلًا، ثمّ التعقيم أخيرًا ليكون فعّالًا بالكامل.', 2, 'mcq', NULL, NULL)
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
  ('b6252f04-7cb0-5d99-a5b0-a6d494e7d198', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'أيّ العبارات الأربع التالية عن المزائج وتقنيات الفصل هي **الصحيحة الوحيدة**؟', '[{"id":"a","text":"كلّ مزيج يحتوي على سائلَين اثنين هو بالضرورة مزيج متجانس"},{"id":"b","text":"الترسيب يفصل الأملاح المذابة تمامًا في الماء"},{"id":"c","text":"التقطير هو الطريقة الوحيدة القادرة على فصل مكوّنات مزيج متجانس كملح مذاب في الماء"},{"id":"d","text":"الترشيح يحتاج إلى تسخين المزيج حتّى الغليان"}]'::jsonb, 'c', 'التقطير هو التقنية الوحيدة من بين الثلاث القادرة على فصل مكوّنات مزيج متجانس (كملح مذاب في الماء)؛ العبارات الأخرى خاطئة: سائلان قد يمتزجان أو لا (ماء وزيت مثال مضاد)، والترسيب لا يفصل الأملاح المذابة، والترشيح لا يحتاج إلى أيّ تسخين.', 3, 'mcq', NULL, NULL)
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
  ('a30b12af-4f88-58d1-b22d-606ed1ae2fc2', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'لاحظت مهندسة أنّ عيّنة ماء أصبحت صافية تمامًا بالعين المجرّدة بعد تركها ساكنة يومًا كاملًا، لكنّها لمّا رشّحتها عبر ورقة ترشيح، وجدت بقايا حبيبات دقيقة محجوزة على الورقة. ماذا يدلّ هذا على قدرة الترسيب مقارنة بالترشيح؟', '[{"id":"a","text":"الترسيب لا يزيل كلّ الحبيبات الدقيقة رغم أنّه يجعل الماء يبدو صافيًا للعين المجرّدة، والترشيح يكمل إزالتها"},{"id":"b","text":"الترسيب أكفأ من الترشيح في كلّ الحالات"},{"id":"c","text":"الترشيح لا يفيد إطلاقًا بعد الترسيب"},{"id":"d","text":"وجود الحبيبات على الورقة يعني أنّ الترسيب لم يحدث أصلًا"}]'::jsonb, 'a', 'رغم أنّ الماء بدا صافيًا بالعين المجرّدة بعد الترسيب، تبقى حبيبات دقيقة جدًّا عالقة لا تُرى، فيكشفها الترشيح ويحجزها على الورقة؛ هذا يبيّن أنّ الترسيب مرحلة أولى ضرورية لكن غير كافية وحدها، والترشيح يكملها.', 4, 'mcq', NULL, NULL)
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
  ('6a2344fb-35a2-55ec-bf54-567ee7f6f227', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'قرّرت بلدية بناء محطّة معالجة لماء واد قريب لتزويد السكّان بماء شرب آمن، مع العلم أنّ مصنعًا يصرف مياهه دون معالجة في الوادي نفسه. أيّ إجراءَين معًا ضروريّان لضمان نجاح المشروع على المدى الطويل؟', '[{"id":"a","text":"الاكتفاء ببناء محطّة الترسيب والترشيح دون التعقيم"},{"id":"b","text":"الاكتفاء بإلزام المصنع بمعالجة مياهه دون بناء أيّ محطّة"},{"id":"c","text":"تجاهل صرف المصنع لأنّه لا يؤثّر على الماء"},{"id":"d","text":"بناء محطّة معالجة كاملة (ترسيب ثمّ ترشيح ثمّ تعقيم) مع إلزام المصنع بمعالجة مياهه قبل صرفها في الوادي"}]'::jsonb, 'd', 'نجاح المشروع يتطلّب إجراءَين معًا: محطّة معالجة كاملة بخطواتها الثلاث لتنقية الماء المأخوذ من الوادي، وإلزام المصنع بمعالجة مياهه قبل صرفها فيه لوقف تلوّثه من المصدر؛ الاكتفاء بأحدهما لا يضمن ماءً آمنًا على المدى الطويل.', 5, 'mcq', NULL, NULL)
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
  ('c91ac873-e0c2-549b-be10-1a207dc29cc1', '651b06b2-f6d4-5e63-be16-626ebca82db2', 'أراد باحث مقارنة أربع عيّنات ماء لتحديد أيّها يمكن أن تصبح صالحة للشرب بمعالجة بسيطة فقط (ترسيب وترشيح، دون تقطير ولا تعقيم كيميائي): الأولى ماء بحر مالح، الثانية ماء واد عكر بالطين فقط، الثالثة ماء موحل ملوّث بمياه صرف صناعي، الرابعة ماء نبع صافٍ. أيّ عيّنة يمكن أن تصبح صالحة للشرب فعليًّا بهذه المعالجة البسيطة وحدها؟', '[{"id":"a","text":"ماء البحر المالح، لأنّ الترشيح يزيل الملح"},{"id":"b","text":"ماء الواد العكر بالطين فقط، لأنّ الترسيب والترشيح يزيلان حبيبات الطين الصلبة العالقة"},{"id":"c","text":"ماء الصرف الصناعي الملوّث، لأنّ الترسيب يزيل كلّ الموادّ الكيميائية الضارّة"},{"id":"d","text":"لا يمكن لأيّ عيّنة أن تصبح صالحة بمعالجة بسيطة إطلاقًا"}]'::jsonb, 'b', 'ماء الواد العكر بالطين فقط يحتوي على حبيبات صلبة عالقة يزيلها الترسيب والترشيح فعليًّا؛ أمّا ملح ماء البحر مذاب فلا يزيله الترشيح (يحتاج التقطير)، والموادّ الكيميائية الملوِّثة في ماء الصرف الصناعي لا يزيلها الترسيب البسيط، فتحتاج معالجة أعقد بكثير.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', '81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('956e726a-ea4f-5467-96b9-785470fced9f', 'ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', 'لماذا يُعدّ الهواء مادّة رغم أنّنا لا نراه؟', '[{"id":"a","text":"لأنّ له كتلة ويشغل حيّزًا"},{"id":"b","text":"لأنّه بارد دائمًا"},{"id":"c","text":"لأنّه يتحرّك بسرعة"},{"id":"d","text":"لأنّه ضروري للتنفّس فقط"}]'::jsonb, 'a', 'الهواء مادّة لأنّ له خاصّيّتَي كلّ مادّة: كتلة فعلية (تجربة البالونَين) ويشغل حيّزًا من الفضاء (تجربة الكأس المقلوب في الماء).', 1, 'mcq', NULL, NULL)
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
  ('5f23d204-b313-5dcb-97ed-a75dde041ac8', 'ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', 'أيّ خاصّية من الخصائص التالية **لا** تنطبق على الهواء؟', '[{"id":"a","text":"عديم اللون"},{"id":"b","text":"شفّاف"},{"id":"c","text":"قابل للانضغاط"},{"id":"d","text":"له لون أزرق فاتح دائمًا"}]'::jsonb, 'd', 'الهواء عديم اللون تمامًا، فليس له لون أزرق أو أيّ لون آخر؛ أمّا كونه عديم اللون وشفّافًا وقابلًا للانضغاط فخصائص صحيحة تنطبق عليه فعلًا.', 2, 'mcq', NULL, NULL)
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
  ('7b796e16-be4d-5646-ba95-4eb01601debb', 'ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', 'في تجربة الكأس المملوء بالماء والمغطّى ببطاقة مقوّاة ثمّ المقلوب رأسًا على عقب، لماذا لا يسقط الماء؟
<svg viewBox="0 0 240 250">
<title>تجربة الكأس المقلوب المغطّى ببطاقة</title>
<polygon points="95,55 145,55 162,195 78,195" fill="#bfdbfe" stroke="#0f172a" stroke-width="3"/><rect x="70" y="197" width="100" height="11" rx="2" fill="#f5deb3" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="120" y="130" text-anchor="middle" fill="#1d4ed8" font-size="15">ماء</text><text x="120" y="225" text-anchor="middle" fill="#0f172a" font-size="13">بطاقة مقوّاة</text></g>
</svg>', '[{"id":"a","text":"لأنّ البطاقة لاصقة بالكأس بمادّة غراء"},{"id":"b","text":"لأنّ الضغط الجوّي يدفع البطاقة من الأسفل إلى الأعلى بقوّة أكبر من وزن الماء"},{"id":"c","text":"لأنّ الماء يتجمّد فورًا عند القلب"},{"id":"d","text":"لأنّ الكأس فارغ من الهواء تمامًا"}]'::jsonb, 'b', 'الضغط الجوّي يضغط على البطاقة من الأسفل نحو الأعلى بقوّة أكبر من وزن الماء الذي يدفعها نحو الأسفل، فتبقى البطاقة ملتصقة والماء محبوسًا داخل الكأس.', 3, 'mcq', NULL, NULL)
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
  ('6ef53671-2e1b-58d0-a7c8-1e6f20f7f40b', 'ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', 'ما اسم الجهاز الذي يقيس الضغط الجوّي؟', '[{"id":"a","text":"الترمومتر"},{"id":"b","text":"الميزان"},{"id":"c","text":"البارومتر"},{"id":"d","text":"الساعة"}]'::jsonb, 'c', 'البارومتر هو الجهاز الذي يقيس الضغط الجوّي، ويستعمله خبراء الأرصاد الجوّية لمتابعة تغيّراته والمساعدة على التنبّؤ بالطقس.', 4, 'mcq', NULL, NULL)
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
  ('b540dacf-4370-57d9-ba22-e7613dcdf899', 'ccfb9bd4-ab3e-5cb2-b160-1d9bdf5a7749', 'أيّ ممّا يلي مصدر من مصادر تلوّث الهواء؟', '[{"id":"a","text":"دخان المصانع دون تصفية"},{"id":"b","text":"التشجير في المدن"},{"id":"c","text":"استعمال الدرّاجة بدل السيّارة"},{"id":"d","text":"قياس الضغط الجوّي بالبارومتر"}]'::jsonb, 'a', 'دخان المصانع المنبعث دون تصفية كافية يُعدّ من أهمّ مصادر تلوّث الهواء؛ أمّا التشجير واستعمال الدرّاجة فيساهمان في الحدّ من التلوّث، وقياس الضغط الجوّي لا علاقة له بالتلوّث.', 5, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('446982dc-36b0-57df-be46-1ec522a7e4e1', '81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', '⭐ تمرين: الهواء وخصائصه', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6c0db2e4-d2d6-5e9d-ac82-6b2ac1890010', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'بالون منفوخ بالهواء أثقل من بالون فارغ من الهواء (بنفس الحجم تقريبًا) عند وزنهما بميزان حسّاس. ماذا يثبت هذا؟
<svg viewBox="0 0 300 210">
<title>وزن بالونين بميزان حسّاس</title>
<rect x="95" y="140" width="110" height="10" rx="2" fill="#94a3b8" stroke="#0f172a" stroke-width="2"/><polygon points="150,70 128,140 172,140" fill="#cbd5e1" stroke="#0f172a" stroke-width="2"/><line x1="55" y1="95" x2="245" y2="45" stroke="#0f172a" stroke-width="5"/><circle cx="150" cy="70" r="5" fill="#0f172a" stroke="none" stroke-width="2"/><line x1="55" y1="95" x2="55" y2="123" stroke="#64748b" stroke-width="2"/><line x1="31" y1="123" x2="79" y2="123" stroke="#0f172a" stroke-width="3"/><line x1="245" y1="45" x2="245" y2="73" stroke="#64748b" stroke-width="2"/><line x1="221" y1="73" x2="269" y2="73" stroke="#0f172a" stroke-width="3"/><ellipse cx="55" cy="93" rx="26" ry="30" fill="#fca5a5" stroke="#0f172a" stroke-width="2.5"/><polygon points="51,121 59,121 55,129" fill="#fca5a5" stroke="#0f172a" stroke-width="1.5"/><ellipse cx="245" cy="53" rx="11" ry="13" fill="#fecaca" stroke="#0f172a" stroke-width="2"/><polyline points="245,65 250,72 242,76" fill="none" stroke="#0f172a" stroke-width="1.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="55" y="147" text-anchor="middle" fill="#0f172a" font-size="12">بالون منفوخ</text><text x="245" y="97" text-anchor="middle" fill="#0f172a" font-size="12">بالون فارغ</text></g>
</svg>', '[{"id":"a","text":"أنّ الهواء مادّة لها كتلة فعلية"},{"id":"b","text":"أنّ الهواء ليس له أيّ كتلة"},{"id":"c","text":"أنّ الهواء سائل لا غاز"},{"id":"d","text":"أنّ البالون المنفوخ أخفّ من الفارغ"}]'::jsonb, 'a', 'زيادة كتلة البالون بعد نفخه بالهواء تثبت أنّ الهواء المضاف له كتلة فعلية، فالهواء مادّة حقيقية كباقي الموادّ.', 1, 'mcq', NULL, NULL)
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
  ('d672380f-4f0b-51aa-af47-cd74a8700e03', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'غُرس كأس فارغ رأسًا على عقب داخل حوض ماء بشكل مستقيم، فبقي منديل ورقي موضوع في قاعه جافًّا تمامًا. ما السبب؟', '[{"id":"a","text":"الكأس مصنوع من مادّة تصدّ الماء"},{"id":"b","text":"الهواء المحبوس داخل الكأس يشغل حيّزًا فيمنع الماء من الدخول إليه"},{"id":"c","text":"الماء لا يستطيع أبدًا دخول أيّ كأس مقلوب"},{"id":"d","text":"المنديل مقاوم للماء بطبيعته"}]'::jsonb, 'b', 'الهواء المحبوس داخل الكأس المقلوب يشغل حيّزًا من الفضاء، فيمنع الماء من ملء هذا الحيّز، ولذلك يبقى المنديل الموضوع في القاع جافًّا.', 2, 'mcq', NULL, NULL)
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
  ('4cd7b31a-fc4f-507f-90f4-3ea83bf90235', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'أيّ ممّا يلي خاصّية صحيحة من خصائص الهواء؟', '[{"id":"a","text":"له لون أزرق فاتح دائمًا"},{"id":"b","text":"له رائحة مميّزة دائمًا"},{"id":"c","text":"شفّاف، نرى الأجسام من خلاله"},{"id":"d","text":"له شكل ثابت مهما تغيّر إناؤه"}]'::jsonb, 'c', 'الهواء شفّاف فعلًا، نرى الأجسام من خلاله بوضوح؛ أمّا اللون والرائحة فمنعدمان في الهواء النقيّ، وشكله يتغيّر بتغيّر الإناء الذي يشغله.', 3, 'mcq', NULL, NULL)
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
  ('271b7d2c-d37b-5262-a68c-6cea55ad7671', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'لماذا يمكن ضغط كمّية من الهواء داخل محقنة (مِحقن) لتصغير حجمها، بينما يصعب فعل الشيء نفسه بالماء؟', '[{"id":"a","text":"لأنّ الماء أخفّ من الهواء"},{"id":"b","text":"لأنّ الهواء سائل والماء غاز"},{"id":"c","text":"لأنّ المحقنة مصمّمة للهواء فقط"},{"id":"d","text":"لأنّ الهواء قابل للانضغاط بخلاف الماء الذي يقاوم الانضغاط"}]'::jsonb, 'd', 'الهواء قابل للانضغاط فيصغر حجمه عند دفع المِكبس، بينما يقاوم الماء الانضغاط ويحافظ على حجمه تقريبًا مهما ضغطنا عليه.', 4, 'mcq', NULL, NULL)
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
  ('12660ac5-b86f-5196-9612-2402577ad96e', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'ما اسم القوّة التي يضغط بها الغلاف الجوّي المحيط بالأرض على كلّ ما حوله في جميع الاتّجاهات؟', '[{"id":"a","text":"الضغط الجوّي"},{"id":"b","text":"القوّة المغناطيسية"},{"id":"c","text":"الرطوبة الجوّية"},{"id":"d","text":"درجة الحرارة الجوّية"}]'::jsonb, 'a', 'الضغط الجوّي هو القوّة التي يضغط بها الغلاف الجوّي المحيط بالأرض على كلّ شيء حوله، في جميع الاتّجاهات وباستمرار.', 5, 'mcq', NULL, NULL)
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
  ('1f2622fb-106a-5fe4-9d6d-6ae507cb9a82', '446982dc-36b0-57df-be46-1ec522a7e4e1', 'ما اسم الجهاز المستعمل لقياس الضغط الجوّي؟', '[{"id":"a","text":"الترمومتر"},{"id":"b","text":"البارومتر"},{"id":"c","text":"الساعة الشمسية"},{"id":"d","text":"المطياف"}]'::jsonb, 'b', 'البارومتر هو الجهاز المستعمل لقياس الضغط الجوّي؛ يختلف عن الترمومتر الذي يقيس درجة الحرارة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a302d03f-62ec-5f1a-b08c-4de595ef059c', '81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: الهواء والضغط الجوّي', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b14b7217-1422-5752-8b30-9c7b951e1ae3', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', 'أراد تلميذ إثبات أنّ للهواء كتلة، وإثبات أنّه يشغل حيّزًا، في تجربتَين منفصلتَين. أيّ زوج من التجربتَين يحقّق ذلك على التوالي؟', '[{"id":"a","text":"تسخين الماء لإثبات الكتلة، وتبريده لإثبات الحيّز"},{"id":"b","text":"قلب كأس في الماء لإثبات الكتلة، ووزن بالون لإثبات الحيّز"},{"id":"c","text":"وزن بالون منفوخ مقارنة بفارغ لإثبات الكتلة، وقلب كأس فارغ في الماء (منديل يبقى جافًّا) لإثبات الحيّز"},{"id":"d","text":"نفخ بالون حتّى الانفجار لإثبات الكتلة والحيّز معًا"}]'::jsonb, 'c', 'مقارنة كتلة بالون منفوخ بفارغ تثبت أنّ للهواء كتلة، بينما قلب كأس فارغ في الماء وبقاء منديل في قاعه جافًّا يثبت أنّ الهواء المحبوس فيه يشغل حيّزًا.', 1, 'mcq', NULL, NULL)
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
  ('fa00aada-a44c-50f8-aba2-ab299f6d65ba', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', 'يستطيع لاعب كرة القدم ضخّ مزيد من الهواء داخل الكرة رغم أنّها مملوءة أصلًا، فيتصلّب سطحها أكثر. ما الخاصّية التي تفسّر ذلك؟', '[{"id":"a","text":"الهواء عديم اللون"},{"id":"b","text":"الهواء شفّاف"},{"id":"c","text":"الهواء غير قابل للانضغاط مثل الماء"},{"id":"d","text":"الهواء قابل للانضغاط، فيمكن حشر كمّية أكبر منه في الحيّز نفسه"}]'::jsonb, 'd', 'قابلية الهواء للانضغاط تسمح بحشر كمّية إضافية منه داخل الكرة رغم امتلائها أصلًا، فيرتفع الضغط الداخلي ويتصلّب سطحها أكثر.', 2, 'mcq', NULL, NULL)
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
  ('7b11ece8-b3ad-5e32-bd9c-61fddd36b30f', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', 'يعتقد بعض التلاميذ أنّ الضغط الجوّي يؤثّر من الأعلى إلى الأسفل فقط، كأنّه وزن يسقط علينا. أيّ ملاحظة من تجربة الكأس المغطّى ببطاقة والمقلوب رأسًا على عقب تُفنّد هذا الاعتقاد؟', '[{"id":"a","text":"بقاء البطاقة ملتصقة من الأسفل يثبت أنّ الضغط الجوّي يدفع من الأسفل إلى الأعلى أيضًا، أي في جميع الاتّجاهات"},{"id":"b","text":"سقوط الماء بعد قلب الكأس يؤكّد أنّ الضغط من الأعلى فقط"},{"id":"c","text":"التجربة لا علاقة لها بمسألة اتّجاه الضغط الجوّي"},{"id":"d","text":"بقاء البطاقة يعني أنّ الهواء توقّف عن الضغط تمامًا"}]'::jsonb, 'a', 'لو كان الضغط الجوّي يؤثّر من الأعلى إلى الأسفل فقط، لسقطت البطاقة فورًا بعد القلب؛ لكن بقاءها ملتصقة يثبت أنّ الضغط الجوّي يدفعها أيضًا من الأسفل نحو الأعلى، أي أنّه يضغط في جميع الاتّجاهات في الآن نفسه.', 3, 'mcq', NULL, NULL)
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
  ('a7e605e5-35eb-5c42-b3e1-7bffad4a06d1', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', 'شعر مسافر بانسداد في أذنَيه أثناء إقلاع الطائرة، فظنّ أنّ السبب ارتفاع درجة الحرارة داخل الطائرة. ما التصحيح الصحيح لهذا الاعتقاد؟', '[{"id":"a","text":"الاعتقاد صحيح، فارتفاع الحرارة هو السبب الوحيد"},{"id":"b","text":"السبب الحقيقي هو التغيّر السريع في الضغط الجوّي مع الارتفاع، لا تغيّر درجة الحرارة"},{"id":"c","text":"السبب هو انخفاض الرطوبة داخل الطائرة"},{"id":"d","text":"لا يوجد أيّ تفسير علمي لهذه الظاهرة"}]'::jsonb, 'b', 'انسداد الأذنَين عند الإقلاع أو الهبوط سببه التغيّر السريع في الضغط الجوّي المحيط مع تغيّر الارتفاع، وليس تغيّر درجة الحرارة؛ يجب عدم الخلط بين الظاهرتَين.', 4, 'mcq', NULL, NULL)
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
  ('a16ec459-0454-50e9-ab1e-20237c1088e5', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', 'أيّ العبارات التالية **خاطئة** بخصوص الهواء والضغط الجوّي؟', '[{"id":"a","text":"الهواء مادّة له كتلة ويشغل حيّزًا"},{"id":"b","text":"الضغط الجوّي يضغط في جميع الاتّجاهات"},{"id":"c","text":"الضغط الجوّي ثابت لا يتغيّر مهما ارتفعنا عن سطح البحر"},{"id":"d","text":"البارومتر جهاز يقيس الضغط الجوّي"}]'::jsonb, 'c', 'العبارة الثالثة خاطئة: الضغط الجوّي يتغيّر فعلًا، إذ يقلّ كلّما ارتفعنا عن سطح البحر؛ أمّا العبارات الأخرى فصحيحة وتصف خصائص الهواء والضغط الجوّي بدقّة.', 5, 'mcq', NULL, NULL)
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
  ('ce20ac22-6e69-5a2b-b0c8-5900b405f0f6', 'a302d03f-62ec-5f1a-b08c-4de595ef059c', 'لاحظ سكّان حيّ سكني أنّ الهواء المحيط بهم أصبح ملوّثًا بسبب ازدحام السيّارات ودخان مصنع قريب. اقترح أحدهم الاكتفاء بإغلاق نوافذ المنازل فقط لحلّ المشكلة. ما الرأي الأصحّ في هذا الاقتراح؟', '[{"id":"a","text":"الاقتراح كافٍ تمامًا ويحلّ المشكلة نهائيًّا"},{"id":"b","text":"لا داعي لأيّ إجراء لأنّ الهواء يتنقّى من تلقاء نفسه دائمًا"},{"id":"c","text":"يكفي إلزام سائقي السيّارات فقط دون التطرّق للمصنع"},{"id":"d","text":"الاقتراح غير كافٍ؛ فالحلّ الجذري يتطلّب تقليل عوادم السيّارات وتصفية انبعاثات المصنع معًا، لا مجرّد إغلاق النوافذ"}]'::jsonb, 'd', 'إغلاق النوافذ لا يعالج مصدر التلوّث؛ الحلّ الجذري يتطلّب معالجة المشكلة عند منبعها: تقليل عوادم السيّارات بتشجيع النقل النظيف، وإلزام المصنع بتصفية انبعاثاته.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('83897fbd-8a2a-53c2-ae47-61a49a68bc32', '81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الهواء والضغط الجوّي', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cf50bc59-c4a8-5238-86bf-c2f0c694c599', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', 'وُزن بالون فارغ من الهواء فسجّل كتلة معيّنة، ثمّ نُفخ بالهواء ووُزن من جديد بنفس الميزان الحسّاس. ماذا نتوقّع؟', '[{"id":"a","text":"تصبح الكتلة أكبر لأنّ الهواء المضاف له كتلة فعلية"},{"id":"b","text":"تبقى الكتلة نفسها تمامًا دون أيّ تغيير"},{"id":"c","text":"تصبح الكتلة أصغر بعد النفخ"},{"id":"d","text":"يستحيل قياس كتلة بالون منفوخ بأيّ ميزان"}]'::jsonb, 'a', 'الهواء المضاف داخل البالون له كتلة فعلية، فتصبح كتلة البالون المنفوخ أكبر من كتلته وهو فارغ.', 1, 'mcq', NULL, NULL)
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
  ('1098811d-5e00-5b05-8c16-648587078de1', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', 'أيّ تجربة من التالية تثبت أنّ الهواء يشغل حيّزًا من الفضاء؟', '[{"id":"a","text":"نفخ بالون حتّى الانفجار"},{"id":"b","text":"قلب كأس فارغ رأسًا على عقب في حوض ماء، فيبقى منديل في قاعه جافًّا"},{"id":"c","text":"تسخين الماء حتّى الغليان"},{"id":"d","text":"خلط الملح بالماء حتّى الذوبان"}]'::jsonb, 'b', 'في هذه التجربة، الهواء المحبوس داخل الكأس المقلوب يشغل حيّزًا يمنع الماء من دخوله بالكامل، ولذلك يبقى المنديل الموضوع في قاعه جافًّا.', 2, 'mcq', NULL, NULL)
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
  ('5bd39b4e-c941-589d-a3ae-510c13e2eb11', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', 'كيف يرتفع السائل داخل المصّاصة (القشّة) نحو الفم عند المصّ؟', '[{"id":"a","text":"بفعل قوّة جذب مغناطيسي من الفم"},{"id":"b","text":"لأنّ السائل يتبخّر داخل المصّاصة فجأة"},{"id":"c","text":"مصّ الهواء يخفّض الضغط داخل المصّاصة، فيدفع الضغط الجوّي الخارجي السائل إلى أعلى"},{"id":"d","text":"لأنّ المصّاصة ترفع درجة حرارة السائل"}]'::jsonb, 'c', 'مصّ الهواء من أعلى المصّاصة يخفّض الضغط داخلها، فيصبح الضغط الجوّي الخارجي أكبر، فيدفع السائل نحو الأعلى ليملأ الفراغ.', 3, 'mcq', NULL, NULL)
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
  ('95a510c5-8c26-5a29-82a0-1f4fca091c34', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', 'لماذا تلتصق الممصّة (الفنطاسة اللاصقة) بجدار أملس بقوّة بعد طرد الهواء من تحتها؟', '[{"id":"a","text":"لأنّ الجدار يفرز مادّة لاصقة خاصّة"},{"id":"b","text":"لأنّ درجة حرارة الجدار ترتفع فجأة عند الإلصاق"},{"id":"c","text":"لأنّ الفراغ يجذب جزيئات الجدار نحوه"},{"id":"d","text":"لأنّ الضغط الجوّي الخارجي يضغط عليها بقوّة فيثبّتها على الجدار"}]'::jsonb, 'd', 'بعد طرد الهواء من تحت الممصّة، يضغط الضغط الجوّي الخارجي عليها من كلّ الجهات فيثبّتها بقوّة على الجدار الأملس.', 4, 'mcq', NULL, NULL)
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
  ('8f3977da-d137-5b38-9607-b564838e6857', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', 'أيّ ممّا يلي مصدر فعلي من مصادر تلوّث الهواء؟', '[{"id":"a","text":"دخان مصنع ينفث غازات دون أيّ تصفية"},{"id":"b","text":"التشجير حول المصانع"},{"id":"c","text":"استعمال وسائل نقل عمومي بدل السيّارات الفردية"},{"id":"d","text":"قياس الضغط الجوّي يوميًّا بالبارومتر"}]'::jsonb, 'a', 'دخان المصنع المنفوث دون تصفية مصدر فعلي لتلوّث الهواء؛ أمّا التشجير واستعمال النقل العمومي فيساهمان في تقليل التلوّث، وقياس الضغط الجوّي لا علاقة له بالتلوّث.', 5, 'mcq', NULL, NULL)
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
  ('66be15c4-beeb-5486-b39d-2e4fd9b21ce9', '83897fbd-8a2a-53c2-ae47-61a49a68bc32', 'أيّ سلوك يساهم فعليًّا في الحدّ من تلوّث الهواء؟', '[{"id":"a","text":"حرق النفايات في الهواء الطلق بانتظام"},{"id":"b","text":"استعمال الدرّاجة أو وسائل النقل العمومي بدل السيّارة الفردية"},{"id":"c","text":"إطلاق دخان المصانع دون أيّ تصفية"},{"id":"d","text":"زيادة عدد السيّارات الفردية في المدينة"}]'::jsonb, 'b', 'استعمال الدرّاجة أو النقل العمومي يقلّل عدد السيّارات وعوادمها، فيساهم فعليًّا في الحدّ من تلوّث الهواء؛ أمّا حرق النفايات وإطلاق دخان المصانع وزيادة السيّارات فسلوكيات تزيد التلوّث.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5d19273b-0c71-5441-9b46-346b6af3205b', '81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: الهواء والضغط الجوّي', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('09bcd59b-378b-57af-aaf3-13fd39d8d958', '5d19273b-0c71-5441-9b46-346b6af3205b', 'أثناء تسلّق فريق جبلًا شاهقًا، لاحظوا أنّ قراءة البارومتر الذي يحملونه معهم تنخفض تدريجيًّا كلّما ارتفعوا، وشعروا في الوقت نفسه بانسداد في آذانهم وصعوبة متزايدة في التنفّس. ما العلاقة الصحيحة بين هذه الملاحظات الثلاث؟', '[{"id":"a","text":"ارتفاعهم فوق الجبل يرفع درجة الحرارة المحيطة بهم، وهذا الارتفاع في الحرارة وحده يفسّر الظواهر الثلاث معًا"},{"id":"b","text":"لا توجد أيّ علاقة سببية بين انخفاض قراءة البارومتر وبين انسداد آذانهم وصعوبة تنفّسهم أثناء الصعود"},{"id":"c","text":"انخفاض الضغط الجوّي مع ارتفاعهم هو السبب المشترك وراء هبوط قراءة البارومتر وانسداد آذانهم وصعوبة تنفّسهم"},{"id":"d","text":"البارومتر الذي يحملونه جهاز معطّل بطبيعته، ولا علاقة البتّة بين قراءته وبين الضغط الجوّي المحيط"}]'::jsonb, 'c', 'انخفاض الضغط الجوّي مع الارتفاع هو السبب المشترك: فهو ما يجعل قراءة البارومتر تهبط، وهو نفسه ما يسبّب انسداد الآذان وصعوبة التنفّس عند المتسلّقين؛ فالظواهر الثلاث أثر واحد لسبب واحد، لا علاقة لها بدرجة الحرارة.', 1, 'mcq', NULL, NULL)
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
  ('858ccb9c-73d7-545c-aebe-733465f63e46', '5d19273b-0c71-5441-9b46-346b6af3205b', 'أعلنت محطّة أرصاد جوّية أنّ قراءة البارومتر لديها سجّلت انخفاضًا حادًّا وسريعًا خلال يوم واحد فقط. بناءً على دور البارومتر في التنبّؤ بالطقس، أيّ توقّع تالٍ هو الأنسب؟', '[{"id":"a","text":"طقس صحو ومستقرّ تمامًا، لأنّ انخفاض قراءة البارومتر يبشّر دائمًا بالصحو والاستقرار"},{"id":"b","text":"طقس مضطرب أو ممطر على الأرجح، لأنّ انخفاض الضغط الجوّي ينذر غالبًا باقتراب هذا النوع من الطقس"},{"id":"c","text":"لا يمكن ربط أيّ نوع من توقّعات الطقس القادم بقراءة البارومتر مهما تغيّرت هذه القراءة"},{"id":"d","text":"يتوقّف البارومتر عن العمل والقياس بمجرّد أن تنخفض قراءته بشكل حادّ وسريع كهذا"}]'::jsonb, 'b', 'انخفاض قراءة البارومتر بشكل حادّ وسريع ينذر غالبًا باقتراب طقس مضطرب أو ممطر، بينما ارتفاعها يبشّر بطقس صحو مستقرّ؛ لهذا يعتمد خبراء الأرصاد على متابعة هذه القراءة يوميًّا للتنبّؤ بالطقس.', 2, 'mcq', NULL, NULL)
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
  ('dbccf281-04d4-5376-a7c9-5382bcaccf76', '5d19273b-0c71-5441-9b46-346b6af3205b', 'فسّر تلميذ سبب التصاق الممصّة (الفنطاسة اللاصقة) بالجدار كالتالي: «عند طرد الهواء من تحت الممصّة، يتكوّن فراغ يجذب الممصّة نحو الجدار بقوّة جذب خاصّة به». أين يكمن الخطأ العلمي في هذا التفسير؟', '[{"id":"a","text":"الخطأ أنّ الفراغ لا \"يجذب\"؛ الضغط الجوّي الخارجي هو الذي يدفع الممصّة نحو الجدار بعد زوال هواء الداخل"},{"id":"b","text":"لا يوجد أيّ خطأ في هذا التفسير، فالفراغ فعلًا هو الذي يجذب الممصّة بقوّة جذب خاصّة به"},{"id":"c","text":"الخطأ أنّ الممصّة لا يمكن أن تلتصق فعليًّا بأيّ جدار مهما كانت درجة نعومته أو ملاسته"},{"id":"d","text":"الخطأ أنّ طرد الهواء من تحت الممصّة لا علاقة له إطلاقًا بالتصاقها اللاحق بالجدار الأملس"}]'::jsonb, 'a', 'الخطأ الشائع في هذا التفسير هو تخيّل أنّ الفراغ يملك قوّة "جذب" خاصّة به يسحب بها الممصّة؛ في الحقيقة لا قوّة للفراغ إطلاقًا، بل الضغط الجوّي الخارجي هو الذي يدفع الممصّة بقوّة نحو الجدار بعد زوال مقاومة الهواء من الداخل.', 3, 'mcq', NULL, NULL)
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
  ('b375567d-725a-52d3-a60d-f5535517674c', '5d19273b-0c71-5441-9b46-346b6af3205b', 'ثقب تلميذ مصّاصة (قشّة) بثقب صغير إضافي في منتصفها قبل استعمالها لشرب عصير، فلاحظ أنّ العصير لم يرتفع نحو فمه إطلاقًا رغم مصّه بأقصى قوّة. ما التفسير العلمي الأصحّ لهذا الفشل؟', '[{"id":"a","text":"الثقب الإضافي في المنتصف يزيد فعالية المصّ، فيسرّع صعود العصير نحو الفم أكثر من المعتاد"},{"id":"b","text":"العصير نفسه أصبح كثيفًا جدًّا بحيث يستحيل شربه بأيّ مصّاصة مهما كانت سليمة"},{"id":"c","text":"الثقب الإضافي في المنتصف يقطع تأثير الجاذبية الأرضية عن العصير الموجود داخل الكأس تمامًا"},{"id":"d","text":"الثقب يسمح بدخول هواء خارجي يعادل الضغط داخل المصّاصة مع المحيط، فلا يبقى فرق ضغط يدفع العصير للأعلى"}]'::jsonb, 'd', 'الثقب الإضافي يسمح لهواء خارجي بالدخول إلى داخل المصّاصة، فيتساوى الضغط داخلها مع الضغط الجوّي المحيط بها؛ ولمّا كان صعود السائل يتطلّب فرق ضغط (ضغط خارجي أكبر من الداخلي)، فإنّ تساوي الضغطَين يمنع أيّ صعود للعصير مهما بلغت قوّة المصّ.', 4, 'mcq', NULL, NULL)
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
  ('75ae9ce3-a0df-56ad-9246-fd1ae63c7830', '5d19273b-0c71-5441-9b46-346b6af3205b', 'أيّ ثنائي (مصدر تلوّث ← أثره) من التالية مرتبط ارتباطًا سببيًّا صحيحًا؟', '[{"id":"a","text":"دخان مصنع ينفث غازاته دون أيّ تصفية ← ازدياد أمراض الجهاز التنفّسي عند السكّان المجاورين"},{"id":"b","text":"التشجير الكثيف في الحدائق العامّة ← زيادة ملحوظة في نسبة تلوّث الهواء بالمدينة"},{"id":"c","text":"استعمال الدرّاجة الهوائية بدل السيّارة الفردية ← ازدياد نسبة تلوّث الهواء في الحيّ"},{"id":"d","text":"قياس الضغط الجوّي يوميًّا بجهاز البارومتر ← تراجع ملحوظ في نسبة تلوّث الهواء"}]'::jsonb, 'a', 'دخان المصنع غير المصفّى يحمل غازات وجسيمات ضارّة يستنشقها السكّان المجاورون بشكل متكرّر، فتضرّ بأجهزتهم التنفّسية فعليًّا؛ أمّا التشجير واستعمال الدرّاجة فيقلّلان التلوّث لا يزيدانه، وقياس الضغط الجوّي لا علاقة له بالتلوّث إطلاقًا.', 5, 'mcq', NULL, NULL)
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
  ('3bc80f53-bb3f-5692-8b23-9cc4a3f4fbb8', '5d19273b-0c71-5441-9b46-346b6af3205b', 'أيّ العبارات الأربع التالية عن الهواء والضغط الجوّي هي **الصحيحة الوحيدة**؟', '[{"id":"a","text":"الهواء عديم الكتلة تمامًا رغم كونه مادّة حقيقية تشغل حيّزًا من الفضاء"},{"id":"b","text":"البارومتر جهاز يقيس درجة الحرارة المحيطة بنا، لا الضغط الجوّي إطلاقًا"},{"id":"c","text":"الضغط الجوّي يتغيّر فعلًا بتغيّر الارتفاع عن سطح البحر، إذ يقلّ كلّما ارتفعنا أكثر"},{"id":"d","text":"تصفية انبعاثات المصانع إجراء عديم الفائدة تمامًا في الحدّ من تلوّث الهواء"}]'::jsonb, 'c', 'العبارة الصحيحة الوحيدة هي أنّ الضغط الجوّي يتغيّر فعلًا بتغيّر الارتفاع، إذ يقلّ كلّما ارتفعنا عن سطح البحر؛ أمّا العبارات الأخرى فخاطئة: الهواء له كتلة فعلية وليس عديمها، والبارومتر يقيس الضغط الجوّي لا الحرارة، وتصفية انبعاثات المصانع إجراء فعّال في الحدّ من التلوّث.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9a56b9cb-0b83-5319-862e-a8dd0602387d', '81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للهواء والضغط الجوّي', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4a3ee406-b99a-5be2-97c6-2e2cdb05dddd', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'يُسكب الهواء داخل بالون كروي فيمتلئ بشكل كروي، وداخل أنبوب طويل فيمتلئ بشكل أسطواني رفيع، وداخل صندوق فيمتلئ بشكل الصندوق تمامًا. أيّ خاصّية من خصائص الهواء تفسّر هذا التغيّر الدائم في شكله؟', '[{"id":"a","text":"الهواء عديم اللون"},{"id":"b","text":"الهواء قابل للانضغاط"},{"id":"c","text":"الهواء ليس له شكل ثابت، فهو يأخذ دائمًا شكل الإناء الذي يشغله"},{"id":"d","text":"الهواء شفّاف"}]'::jsonb, 'c', 'الهواء ليس له شكل ثابت خاصّ به، بل يأخذ دائمًا شكل الإناء الذي يشغله ويملأه بالكامل، سواء كان بالونًا كرويًّا أو أنبوبًا رفيعًا أو صندوقًا.', 1, 'mcq', NULL, NULL)
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
  ('618b5c53-f7ff-5f21-9106-64be58a644a0', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'حاول تلميذ نفخ بالون داخل زجاجة بلاستيكية فارغة ومغلقة تمامًا (لا فتحة فيها سوى عنق ضيّق يمرّ منه البالون)، فلاحظ أنّه يعجز عن نفخه مهما حاول. لكن عندما ثقب صديقه الزجاجة بثقب صغير إضافي في جدارها، نجح نفخ البالون بسهولة تامّة. ما السبب العلمي لهذا الفرق؟
<svg viewBox="0 0 230 250">
<title>نفخ بالون داخل قارورة مغلقة</title>
<polyline points="70,80 70,225 150,225 150,80" fill="none" stroke="#0f172a" stroke-width="3"/><line x1="70" y1="225" x2="150" y2="225" stroke="#0f172a" stroke-width="3"/><polyline points="70,80 90,52 90,32 130,32 130,52 150,80" fill="none" stroke="#0f172a" stroke-width="3"/><rect x="88" y="22" width="44" height="12" rx="2" fill="#cbd5e1" stroke="#0f172a" stroke-width="2"/><line x1="110" y1="60" x2="110" y2="94" stroke="#64748b" stroke-width="2"/><polygon points="106,52 114,52 110,60" fill="#fca5a5" stroke="#0f172a" stroke-width="1.5"/><ellipse cx="110" cy="120" rx="20" ry="26" fill="#fca5a5" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="110" y="205" text-anchor="middle" fill="#0f172a" font-size="13">قارورة مغلقة</text><text x="152" y="120" text-anchor="start" fill="#0f172a" font-size="12">بالون</text></g>
</svg>', '[{"id":"a","text":"الهواء المحبوس داخل الزجاجة المغلقة يشغل حيّزًا يمنع دخول هواء إضافي (البالون) ما لم يخرج عبر الثقب الإضافي"},{"id":"b","text":"الزجاجة المثقوبة أصبحت أخفّ وزنًا بعد الثقب، وهذا ما سهّل نفخ البالون داخلها"},{"id":"c","text":"البالون الثاني كان مصنوعًا من مطّاط أرقّ من الأوّل فسهل نفخه أكثر"},{"id":"d","text":"ثقب الزجاجة يرفع درجة حرارة الهواء بداخلها، وهذا الارتفاع هو الذي يسهّل نفخ البالون"}]'::jsonb, 'a', 'الهواء المحبوس أصلًا داخل الزجاجة المغلقة يشغل حيّزًا من الفضاء، فلا يترك مكانًا لهواء إضافي (نفخة البالون) ما لم يخرج جزء منه؛ الثقب الإضافي يفتح مخرجًا لهذا الهواء المحبوس فيسمح بنفخ البالون بسهولة.', 2, 'mcq', NULL, NULL)
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
  ('f2130e2e-626c-55f0-9089-a2fa041a78e2', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'يضغط الغلاف الجوّي المحيط بالأرض على كلّ الأجسام في جميع الاتّجاهات في الآن نفسه (من الأعلى والأسفل والجوانب معًا)، لا من جهة واحدة فقط. ما السبب الأساسي لهذه الخاصّية؟', '[{"id":"a","text":"لأنّ الرياح تهبّ باستمرار من جميع الاتّجاهات في وقت واحد"},{"id":"b","text":"لأنّ الغلاف الجوّي يحيط بالأرض والأجسام من كلّ جهة، فيضغط عليها من كلّ الجهات التي يلامسها"},{"id":"c","text":"لأنّ الجاذبية الأرضية تدفع الهواء من كلّ الجهات نحو مركز الأرض"},{"id":"d","text":"لأنّ درجة حرارة الهواء تتغيّر باستمرار في كلّ الاتّجاهات"}]'::jsonb, 'b', 'الغلاف الجوّي يحيط بالأرض وبكلّ الأجسام من كلّ جهة دون استثناء، فهو يلامسها من الأعلى والأسفل والجوانب معًا، ولذلك يضغط عليها في جميع هذه الاتّجاهات في الآن نفسه.', 3, 'mcq', NULL, NULL)
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
  ('974e462f-601d-5e13-b239-ee4e22a55d55', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'يملك خبير أرصاد جوّية جهازَين في مكتبه: الأوّل يقيس درجة الحرارة المحيطة، والثاني يقيس الضغط الجوّي ليساعده على التنبّؤ بالطقس القادم. ما اسم الجهاز الثاني؟', '[{"id":"a","text":"الترمومتر (الميزان الحراري)"},{"id":"b","text":"الساعة الشمسية"},{"id":"c","text":"مقياس الرطوبة"},{"id":"d","text":"البارومتر"}]'::jsonb, 'd', 'البارومتر هو الجهاز الذي يقيس الضغط الجوّي ويساعد على التنبّؤ بالطقس، بينما الترمومتر (الميزان الحراري) يقيس درجة الحرارة؛ لكلّ ظاهرة جهاز قياسها الخاصّ.', 4, 'mcq', NULL, NULL)
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
  ('e669020d-952b-5ce4-aeee-0bca0d4dbb4d', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'تلتصق ممصّة (فنطاسة لاصقة) بسهولة تامّة عند إلصاقها بجدار زجاجي أملس بعد طرد الهواء من تحتها، لكنّها تفشل تمامًا في الالتصاق بجدار إسمنتي خشن مليء بمسامّ صغيرة. ما التفسير العلمي لهذا الفشل؟', '[{"id":"a","text":"الجدار الخشن يسمح بدخول هواء عبر مسامّه الصغيرة فيعادل الضغط داخل الممصّة مع خارجها، فلا يبقى فرق ضغط يثبّتها"},{"id":"b","text":"الجدار الخشن أثقل وزنًا من الزجاج فتعجز الممصّة عن حمل هذا الوزن الإضافي"},{"id":"c","text":"لون الجدار الإسمنتي يمنع الممصّة من الالتصاق به مهما كانت درجة نعومته"},{"id":"d","text":"الجدار الخشن يرفع درجة حرارة الممصّة فتفقد قدرتها على الالتصاق"}]'::jsonb, 'a', 'المسامّ الصغيرة في الجدار الخشن تسمح بدخول هواء خارجي إلى ما تحت الممصّة، فيتساوى الضغط داخلها مع الضغط الجوّي خارجها؛ وبما أنّ التصاقها يتطلّب فرق ضغط يدفعها نحو الجدار، فإنّ زوال هذا الفرق يمنع التصاقها، بخلاف الجدار الأملس الذي يمنع أيّ تسرّب للهواء.', 5, 'mcq', NULL, NULL)
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
  ('51b26e5b-2c20-524f-9cf2-cd905acacf18', '9a56b9cb-0b83-5319-862e-a8dd0602387d', 'لاحظ طبيب ازديادًا ملحوظًا في حالات أمراض الجهاز التنفّسي عند سكّان حيّ يقع بجوار مصنع ينفث دخانًا كثيفًا يوميًّا دون أيّ تصفية لانبعاثاته. ما العلاقة السببية الأصحّ التي تفسّر هذا الازدياد؟', '[{"id":"a","text":"قرب السكّان من البحر هو السبب الحقيقي وراء ازدياد أمراضهم التنفّسية"},{"id":"b","text":"ارتفاع درجات الحرارة الصيفية وحده هو المسؤول عن هذا الازدياد الملحوظ"},{"id":"c","text":"استنشاق السكّان المتكرّر للدخان الملوّث الصادر عن المصنع يضرّ بأجهزتهم التنفّسية تدريجيًّا"},{"id":"d","text":"تناول السكّان لطعام غير صحّي هو السبب الوحيد وراء أمراضهم التنفّسية"}]'::jsonb, 'c', 'استنشاق السكّان المتكرّر لدخان المصنع الملوّث دون تصفية يُضعف أجهزتهم التنفّسية تدريجيًّا ويزيد فرص إصابتهم بأمراضها؛ هذه علاقة سببية مباشرة، بخلاف قرب البحر أو الحرارة الصيفية أو التغذية التي لا علاقة مباشرة لها بهذا الازدياد المحدّد.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e019d713-8a78-5740-8edd-59233662959a', '81a07868-592a-5c15-ba96-c2d8c8b37054', 'sciences-physiques-7eme', '👑 قمّة التحدّي ⭐⭐⭐⭐: إتقان الهواء والضغط الجوّي', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ce7eee8b-133e-5c25-b7d0-2e9431e76d05', 'e019d713-8a78-5740-8edd-59233662959a', 'امتلأت أسطوانة غوّاص بالهواء المضغوط حتّى أصبحت أثقل بكثير ممّا كانت عليه قبل الملء، رغم أنّ حجمها الخارجي لم يتغيّر إطلاقًا طوال عملية الملء. أيّ خاصّيّتَين للهواء تفسّران معًا هذه الملاحظة؟', '[{"id":"a","text":"الهواء له كتلة فعلية، وهو قابل للانضغاط فيمكن حشر كمّية أكبر منه في الحجم الخارجي نفسه"},{"id":"b","text":"الهواء ليس له شكل ثابت، ولونه يتغيّر بشكل ملحوظ تحت الضغط العالي"},{"id":"c","text":"الهواء عديم اللون تمامًا، وهو أيضًا شفّاف بحيث نرى الأجسام من خلاله بوضوح"},{"id":"d","text":"الهواء عديم الرائحة، ودرجة حرارته ترتفع دائمًا فور الضغط عليه"}]'::jsonb, 'a', 'زيادة كتلة الأسطوانة تثبت أنّ الهواء المضغوط بداخلها له كتلة فعلية، وثبات حجمها الخارجي رغم زيادة كمّية الهواء يثبت أنّ الهواء قابل للانضغاط، فيمكن حشر كمّية أكبر منه في الحجم نفسه؛ الخاصّيّتان معًا تفسّران الملاحظة.', 1, 'mcq', NULL, NULL)
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
  ('b416d753-2367-54c0-9dd8-76101e6e7e38', 'e019d713-8a78-5740-8edd-59233662959a', 'سجّل متسلّقان قراءتَي البارومتر اللذَين يحملانهما: الأولى عند سفح الجبل، والثانية عند قمّته الشاهقة بعد ساعات من الصعود. أيّ ملاحظتَين متوقّعتَين معًا بخصوص القراءة والتنفّس عند القمّة مقارنة بالسفح؟', '[{"id":"a","text":"قراءة البارومتر عند القمّة أعلى من قراءتها عند السفح، والتنفّس عند القمّة أسهل بكثير من السفح"},{"id":"b","text":"قراءة البارومتر عند القمّة أقلّ من قراءتها عند السفح، والتنفّس عند القمّة أصعب بسبب انخفاض الضغط الجوّي المحيط"},{"id":"c","text":"قراءة البارومتر تبقى متطابقة تمامًا عند السفح والقمّة، والتنفّس لا يتغيّر إطلاقًا بين الموقعَين"},{"id":"d","text":"قراءة البارومتر عند القمّة أقلّ من قراءتها عند السفح، لكنّ التنفّس يصبح أسهل بكثير عند القمّة"}]'::jsonb, 'b', 'كلّما ارتفعنا عن سطح البحر يقلّ الضغط الجوّي المحيط، فتنخفض قراءة البارومتر عند القمّة مقارنة بالسفح؛ وانخفاض الضغط الجوّي هذا هو نفسه ما يجعل التنفّس أصعب عند القمّة لا أسهل؛ الخطأ الشائع هو الظنّ بأنّ التنفّس يتحسّن مع الارتفاع لمجرّد الابتعاد عن سطح الأرض.', 2, 'mcq', NULL, NULL)
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
  ('4471f9fb-6f23-54f0-981d-546cd85d0dc7', 'e019d713-8a78-5740-8edd-59233662959a', 'زعم تلميذ ما يلي: «الهواء ليس مادّة لأنّه بلا كتلة إطلاقًا، والدليل أنّ بالونًا فارغًا وبالونًا آخر منفوخًا بالهواء يزنان الكتلة نفسها تمامًا عند وزنهما بميزان حسّاس». أين يكمن الخطأ في هذا الزعم؟', '[{"id":"a","text":"الزعم صحيح تمامًا، فالبالونان يزنان الكتلة نفسها فعلًا مهما اختلف امتلاؤهما بالهواء"},{"id":"b","text":"الخطأ في نوع الميزان المستعمل فقط، والصحيح استعمال ميزان غير حسّاس لإظهار الفرق"},{"id":"c","text":"الخطأ أنّ البالونَين لا يمكن وزنهما بأيّ ميزان مهما كان نوعه"},{"id":"d","text":"الخطأ في الادّعاء بتساوي الكتلتَين؛ فالبالون المنفوخ فعليًّا أثقل من الفارغ لأنّ الهواء المضاف له كتلة حقيقية"}]'::jsonb, 'd', 'الخطأ الشائع في هذا الزعم هو الادّعاء بتساوي كتلتَي البالونَين؛ في الحقيقة البالون المنفوخ أثقل فعليًّا من الفارغ عند وزنهما بميزان حسّاس، لأنّ الهواء المضاف له كتلة حقيقية، وهذا بالضبط ما يثبت أنّ الهواء مادّة.', 3, 'mcq', NULL, NULL)
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
  ('3ab83461-8eca-578f-a51a-e224850aea72', 'e019d713-8a78-5740-8edd-59233662959a', 'لصقت ممصّة (فنطاسة لاصقة) على سقف غرفة مغلقة الأبواب والنوافذ إحكامًا بعد طرد الهواء من تحتها تمامًا. عندما فتح شخص فجأة بابًا موصولًا بفتحة صغيرة إلى الغرفة المجاورة، سقطت الممصّة من السقف فورًا. ما السبب العلمي لهذا السقوط المفاجئ؟', '[{"id":"a","text":"فتح الباب رفع درجة حرارة السقف فجأة، فأذاب المادّة اللاصقة في الممصّة"},{"id":"b","text":"فتح الباب لا علاقة له إطلاقًا بسقوط الممصّة، فهي سقطت بمحض الصدفة في تلك اللحظة"},{"id":"c","text":"فتح الباب أدّى إلى دخول تيّار هواء عبر الفتحة الصغيرة، فعادل الضغط داخل الممصّة مع الضغط خارجها، فسقطت"},{"id":"d","text":"فتح الباب زاد وزن الممصّة نفسها، فلم يعد بإمكان السقف حملها"}]'::jsonb, 'c', 'طرد الهواء من تحت الممصّة يخلق فرق ضغط يثبّتها على السقف؛ فتح الباب المجاور سمح بدخول تيّار هواء عبر الفتحة الصغيرة، فتسرّب هذا الهواء تحت الممصّة وعادل الضغط داخلها مع خارجها، فزال فرق الضغط الذي كان يثبّتها فسقطت.', 4, 'mcq', NULL, NULL)
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
  ('49a133ab-9f17-52b4-a209-8336ff43d2e9', 'e019d713-8a78-5740-8edd-59233662959a', 'أيّ العبارات الأربع التالية عن الهواء والضغط الجوّي هي **الصحيحة الوحيدة**؟', '[{"id":"a","text":"شكل الهواء ثابت لا يتغيّر مهما اختلف الإناء الذي يوضع فيه"},{"id":"b","text":"دخان المصانع دون تصفية وعوادم السيّارات كلاهما مصدران فعليّان لتلوّث الهواء"},{"id":"c","text":"الضغط الجوّي يضغط من الأعلى إلى الأسفل فقط، لا من بقيّة الاتّجاهات"},{"id":"d","text":"البارومتر والترمومتر جهازان يقيسان الظاهرة نفسها بالضبط"}]'::jsonb, 'b', 'العبارة الصحيحة الوحيدة هي أنّ دخان المصانع دون تصفية وعوادم السيّارات مصدران فعليّان لتلوّث الهواء؛ أمّا العبارات الأخرى فخاطئة: شكل الهواء يتغيّر بتغيّر إنائه، والضغط الجوّي يضغط في جميع الاتّجاهات لا من الأعلى فقط، والبارومتر يقيس الضغط بينما الترمومتر يقيس الحرارة، وهما جهازان مختلفان تمامًا.', 5, 'mcq', NULL, NULL)
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
  ('07bcc75f-b56f-58ec-82b5-5e27d7b77f7a', 'e019d713-8a78-5740-8edd-59233662959a', 'اقترح مجلس بلدي أربعة إجراءات لمعالجة تلوّث هواء مدينة صناعية: (1) إلزام المصانع بتصفية انبعاثاتها، (2) تشجيع النقل العمومي والدرّاجات الهوائية، (3) الاكتفاء بمطالبة السكّان بإغلاق نوافذ منازلهم، (4) الإكثار من التشجير في الحدائق العامّة. أيّ مجموعة من هذه الإجراءات تعالج مشكلة التلوّث عند مصدرها فعليًّا؟', '[{"id":"a","text":"الإجراء (3) وحده، فهو يكفي لحماية السكّان من التلوّث نهائيًّا"},{"id":"b","text":"الإجراء (2) وحده يكفي لحلّ مشكلة التلوّث في المدينة الصناعية بالكامل"},{"id":"c","text":"لا فائدة من أيّ إجراء من هذه الإجراءات الأربعة لأنّ التلوّث الصناعي لا حلّ له إطلاقًا"},{"id":"d","text":"الإجراءات (1) و(2) و(4) معًا، لأنّها تعالج مصادر التلوّث مباشرة، بخلاف الإجراء (3) الذي لا يعالج المصدر بل يتجنّبه فقط داخل المنازل"}]'::jsonb, 'd', 'معالجة تلوّث الهواء عند مصدره تتطلّب تصفية انبعاثات المصانع (1)، وتقليل عوادم السيّارات بتشجيع النقل العمومي والدرّاجات (2)، والتشجير الذي ينقّي الهواء (4)؛ أمّا الاكتفاء بإغلاق النوافذ (3) فهو مجرّد تجنّب فردي للمشكلة لا يعالج مصدرها، ولا يكفي وحده أبدًا.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1b3f79ca-085b-58b7-a651-d2364307d25b', '7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7b3cfba2-608f-5e23-b55a-b23ef89500f2', '1b3f79ca-085b-58b7-a651-d2364307d25b', 'ما اسم العنصر الذي يزوّد الدارة الكهربائية بالطاقة اللازمة لجريان التيّار؟', '[{"id":"a","text":"المستقبل"},{"id":"b","text":"المولّد"},{"id":"c","text":"القاطع"},{"id":"d","text":"سلك التوصيل"}]'::jsonb, 'b', 'المولّد (كالعمود أو البطّارية) هو العنصر الذي يزوّد الدارة الكهربائية بالطاقة اللازمة لجريان التيّار، وله قطبان: موجب وسالب.', 1, 'mcq', NULL, NULL)
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
  ('119d83d0-aa23-50cf-807a-f19cb49898b6', '1b3f79ca-085b-58b7-a651-d2364307d25b', 'ما دور القاطع في الدارة الكهربائية؟', '[{"id":"a","text":"تحويل الطاقة الكهربائية إلى ضوء"},{"id":"b","text":"تزويد الدارة بالطاقة اللازمة"},{"id":"c","text":"التحكّم في فتح الدارة أو غلقها عن قصد"},{"id":"d","text":"ربط عنصرين فقط دون البقية"}]'::jsonb, 'c', 'القاطع (المفتاح) يتحكّم في فتح الدارة أو غلقها عن قصد: يغلقها فيجري التيّار، أو يفتحها فيتوقّف.', 2, 'mcq', NULL, NULL)
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
  ('90ae290f-bed3-5d7a-8de2-aeeaad3cb027', '1b3f79ca-085b-58b7-a651-d2364307d25b', 'دارة كهربائية بسيطة متّصلة بالكامل من المولّد إلى المصباح وعودةً إلى المولّد دون أيّ انقطاع. ماذا يحدث للمصباح؟
<svg viewBox="0 0 260 185">
<title>دارة كهربائية بسيطة</title>
<line x1="50" y1="45" x2="210" y2="45" stroke="#0f172a" stroke-width="2"/><line x1="210" y1="45" x2="210" y2="150" stroke="#0f172a" stroke-width="2"/><line x1="210" y1="150" x2="50" y2="150" stroke="#0f172a" stroke-width="2"/><line x1="50" y1="150" x2="50" y2="45" stroke="#0f172a" stroke-width="2"/><line x1="33" y1="92.5" x2="67" y2="92.5" stroke="#0f172a" stroke-width="2.5"/><line x1="42" y1="101.5" x2="58" y2="101.5" stroke="#0f172a" stroke-width="5.5"/><circle cx="130" cy="45" r="15" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="119.39" y1="34.39" x2="140.61" y2="55.61" stroke="#0f172a" stroke-width="2.5"/><line x1="119.39" y1="55.61" x2="140.61" y2="34.39" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="130" y="25" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="92" y="100" text-anchor="end" fill="#0f172a" font-size="12">مولّد</text></g>
</svg>', '[{"id":"a","text":"يبقى مطفأً رغم اتّصال الدارة"},{"id":"b","text":"ينفصل عن الدارة تلقائيًا"},{"id":"c","text":"يتحوّل إلى محرّك كهربائي"},{"id":"d","text":"يضيء، لأنّ التيّار يجري في الدارة المغلقة"}]'::jsonb, 'd', 'عندما تكون الدارة مغلقة بالكامل دون أيّ انقطاع، يجري التيّار الكهربائي في الحلقة فيضيء المصباح.', 3, 'mcq', NULL, NULL)
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
  ('2b715d28-5a33-5ac7-979b-5fedd2c77930', '1b3f79ca-085b-58b7-a651-d2364307d25b', 'أيّ من الموادّ التالية مادّة ناقلة للتيّار الكهربائي؟', '[{"id":"a","text":"النحاس"},{"id":"b","text":"الخشب الجافّ"},{"id":"c","text":"المطّاط"},{"id":"d","text":"الزجاج"}]'::jsonb, 'a', 'النحاس معدن، وأغلب المعادن موادّ ناقلة تسمح بمرور التيّار الكهربائي بسهولة؛ الخشب الجافّ والمطّاط والزجاج موادّ عازلة.', 4, 'mcq', NULL, NULL)
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
  ('39e32a36-d634-50cb-8b5e-ebfed0d02b9a', '1b3f79ca-085b-58b7-a651-d2364307d25b', 'انقطع سلك واحد فقط في دارة كهربائية بسيطة تحتوي على مصباح واحد. ماذا يحدث للمصباح؟
<svg viewBox="0 0 260 185">
<title>دارة كهربائية بسيطة</title>
<line x1="50" y1="45" x2="210" y2="45" stroke="#0f172a" stroke-width="2"/><line x1="210" y1="45" x2="210" y2="150" stroke="#0f172a" stroke-width="2"/><line x1="210" y1="150" x2="150" y2="150" stroke="#0f172a" stroke-width="2"/><line x1="105" y1="150" x2="50" y2="150" stroke="#0f172a" stroke-width="2"/><line x1="50" y1="150" x2="50" y2="45" stroke="#0f172a" stroke-width="2"/><circle cx="150" cy="150" r="2.6" fill="#0f172a" stroke="none" stroke-width="2"/><circle cx="105" cy="150" r="2.6" fill="#0f172a" stroke="none" stroke-width="2"/><line x1="33" y1="92.5" x2="67" y2="92.5" stroke="#0f172a" stroke-width="2.5"/><line x1="42" y1="101.5" x2="58" y2="101.5" stroke="#0f172a" stroke-width="5.5"/><circle cx="130" cy="45" r="15" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="119.39" y1="34.39" x2="140.61" y2="55.61" stroke="#0f172a" stroke-width="2.5"/><line x1="119.39" y1="55.61" x2="140.61" y2="34.39" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="130" y="25" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="92" y="100" text-anchor="end" fill="#0f172a" font-size="12">مولّد</text></g>
</svg>', '[{"id":"a","text":"ينطفئ تمامًا، لأنّ الدارة أصبحت مفتوحة"},{"id":"b","text":"يضيء بشكل طبيعي رغم الانقطاع"},{"id":"c","text":"يضيء بشكل أضعف فقط"},{"id":"d","text":"يتغيّر لونه"}]'::jsonb, 'a', 'انقطاع سلك واحد فقط يكفي لجعل الدارة مفتوحة، فيتوقّف التيّار الكهربائي عن الجريان تمامًا وينطفئ المصباح بالكامل.', 5, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4656dd90-64ce-56e3-9eab-dd4e0ab89d94', '7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', '⭐ تمرين: مكوّنات الدارة الكهربائية البسيطة', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d33f620c-5521-5c50-aae4-dd0f73786793', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', 'ما اسم العنصر الذي يستقبل الطاقة الكهربائية ويحوّلها إلى ضوء أو حركة؟', '[{"id":"a","text":"القاطع"},{"id":"b","text":"الأسلاك"},{"id":"c","text":"المستقبل"},{"id":"d","text":"المولّد"}]'::jsonb, 'c', 'المستقبل (كالمصباح أو المحرّك) هو العنصر الذي يستقبل الطاقة الكهربائية ويحوّلها: المصباح إلى ضوء، والمحرّك إلى حركة.', 1, 'mcq', NULL, NULL)
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
  ('f4b2714f-bd80-54db-971a-dbb39a452024', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', 'بأيّ رمز اصطلاحي يُمثَّل المصباح في رسم الدارة الكهربائية؟', '[{"id":"a","text":"دائرة بداخلها علامة تقاطع (×)"},{"id":"b","text":"خطّ مستقيم منقطع في نقطة"},{"id":"c","text":"دائرة بداخلها الحرف M"},{"id":"d","text":"خطّان متوازيان مختلفا الطول"}]'::jsonb, 'a', 'المصباح يُمثَّل برمز دائرة صغيرة بداخلها علامة تقاطع (×)؛ رمز المحرّك دائرة بداخلها M، ورمز المولّد خطّان متوازيان مختلفا الطول.', 2, 'mcq', NULL, NULL)
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
  ('2397a29e-c519-5964-bbf1-1d6af32c8ef0', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', 'ما دور أسلاك التوصيل في الدارة الكهربائية؟', '[{"id":"a","text":"تزويد الدارة بالطاقة اللازمة"},{"id":"b","text":"التحكّم في فتح الدارة أو غلقها"},{"id":"c","text":"تحويل الطاقة الكهربائية إلى ضوء"},{"id":"d","text":"ربط جميع عناصر الدارة في حلقة واحدة متّصلة"}]'::jsonb, 'd', 'أسلاك التوصيل تربط جميع عناصر الدارة (المولّد والمستقبل والقاطع) ببعضها لتكوّن حلقة واحدة متّصلة يجري فيها التيّار.', 3, 'mcq', NULL, NULL)
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
  ('1177ce34-f4ca-532f-a92a-d72716458abd', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', 'ماذا نسمّي الدارة التي توجد فيها فجوة أو انقطاع في نقطة واحدة على الأقلّ، فلا يجري فيها التيّار؟', '[{"id":"a","text":"دارة مغلقة"},{"id":"b","text":"دارة مفتوحة"},{"id":"c","text":"دارة قصيرة"},{"id":"d","text":"دارة سليمة"}]'::jsonb, 'b', 'الدارة المفتوحة هي دارة توجد فيها فجوة أو انقطاع في نقطة واحدة على الأقلّ (سلك مقطوع أو قاطع مفتوح)، فلا يجري فيها التيّار الكهربائي.', 4, 'mcq', NULL, NULL)
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
  ('33282348-9ed5-51bc-8bf5-3c66a222d8e7', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', 'أيّ مادّة من التالية عازلة لا تسمح بمرور التيّار الكهربائي؟', '[{"id":"a","text":"الحديد"},{"id":"b","text":"الألمنيوم"},{"id":"c","text":"الماء الذي يحوي أملاحًا مذابة"},{"id":"d","text":"البلاستيك"}]'::jsonb, 'd', 'البلاستيك مادّة عازلة تمنع مرور التيّار الكهربائي تمامًا؛ أمّا الحديد والألمنيوم والماء الذي يحوي أملاحًا فموادّ ناقلة.', 5, 'mcq', NULL, NULL)
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
  ('ccc78b94-a4cc-56b2-aa4c-a699f800eb13', '4656dd90-64ce-56e3-9eab-dd4e0ab89d94', 'لماذا يُغلَّف السلك المعدني الناقل عادةً بطبقة من البلاستيك؟', '[{"id":"a","text":"لزيادة قوّة التيّار الكهربائي"},{"id":"b","text":"لعزل السلك ومنع التيّار من الوصول إلى يد من يمسكه"},{"id":"c","text":"لأنّ البلاستيك ناقل أفضل من المعدن"},{"id":"d","text":"لتزيين السلك فقط دون فائدة أخرى"}]'::jsonb, 'b', 'يُغلَّف لبّ السلك المعدني الناقل بطبقة من البلاستيك العازل لمنع التيّار الكهربائي من الوصول إلى يد من يمسك السلك، فتُضمَن السلامة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', '7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: الدارة الكهربائية والموصلات', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ebc2a59a-5ac1-54f9-9de2-8b8f74d43c3b', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', 'رسم تلميذ دارة كهربائية بسيطة: بدأ بخطّين متوازيَين غير متساويَي الطول، تبعهما سلك يصل بدائرة صغيرة بداخلها علامة تقاطع (×). ما اسم مكوّنَي هذه الدارة بالترتيب؟', '[{"id":"a","text":"مولّد ثمّ مصباح"},{"id":"b","text":"مصباح ثمّ مولّد"},{"id":"c","text":"قاطع ثمّ محرّك"},{"id":"d","text":"مصباح ثمّ محرّك"}]'::jsonb, 'a', 'الخطّان المتوازيان غير المتساويَي الطول يمثّلان المولّد، والدائرة بداخلها علامة تقاطع (×) تمثّل المصباح، فتكون الدارة مولّدًا موصولًا بمصباح.', 1, 'mcq', NULL, NULL)
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
  ('8b4c9ab1-728f-58cd-977f-bb599932f6ce', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', 'أغلق تلميذ قاطع دارته، فلاحظ أنّ المصباح لم يضئ رغم أنّ جميع الأسلاك تبدو متّصلة ظاهريًّا. ما التفسير الأرجح؟', '[{"id":"a","text":"الدارة مغلقة تمامًا ولا مشكلة فيها"},{"id":"b","text":"المصباح يعمل بدون أيّ تيّار كهربائي"},{"id":"c","text":"القاطع وحده يضيء المصباح بغضّ النظر عن باقي الدارة"},{"id":"d","text":"أحد الأسلاك مقطوع من الداخل رغم اتّصاله ظاهريًّا، فتبقى الدارة مفتوحة فعليًّا"}]'::jsonb, 'd', 'مظهر السلك المتّصل خارجيًّا لا يضمن اتّصاله من الداخل؛ سلك مقطوع داخليًّا يجعل الدارة مفتوحة فعليًّا رغم أنّها تبدو متّصلة، فلا يجري التيّار ولا يضيء المصباح.', 2, 'mcq', NULL, NULL)
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
  ('a0986f2d-3665-5a02-85a8-b27c64dd0af5', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', 'استبدل تلميذ سلك التوصيل النحاسي في دارته بخيط من الصوف. ماذا يحدث للمصباح؟', '[{"id":"a","text":"لا يضيء المصباح، لأنّ الصوف مادّة عازلة لا تنقل التيّار"},{"id":"b","text":"يضيء المصباح بنفس الشدّة تمامًا"},{"id":"c","text":"يضيء المصباح بقوّة أكبر من قبل"},{"id":"d","text":"يتحوّل المصباح إلى محرّك كهربائي"}]'::jsonb, 'a', 'خيط الصوف مادّة عازلة، خلافًا للنحاس الناقل، فلا يسمح بمرور التيّار الكهربائي عبره، فتبقى الدارة مفتوحة فعليًّا ولا يضيء المصباح.', 3, 'mcq', NULL, NULL)
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
  ('7a8e5afd-a40d-5d46-8ae9-44fa6128c402', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', 'انطفأ مصباح دارة فجأة. فحص تلميذ الدارة فوجد السلك سليمًا والقاطع مغلقًا، لكنّه اكتشف أنّ سلكًا نحاسيًّا واحدًا يصل قطبَي المولّد مباشرة دون المرور عبر المصباح، وأنّ المولّد أصبح ساخنًا جدًّا. ما اسم هذه الحالة الخطيرة؟', '[{"id":"a","text":"دارة مفتوحة عادية"},{"id":"b","text":"عزل كهربائي جيّد"},{"id":"c","text":"دارة قصيرة"},{"id":"d","text":"نقص في عدد الأسلاك"}]'::jsonb, 'c', 'التقاء قطبَي المولّد مباشرة بسلك ناقل واحد دون المرور عبر أيّ مستقبل هو تعريف الدارة القصيرة، وهي التي تفسّر اندفاع تيّار قويّ فجائي وسخونة المولّد الشديدة.', 4, 'mcq', NULL, NULL)
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
  ('d998c74b-afc3-59f0-9988-b6858cdb98b0', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', 'أيّ العبارات التالية عن الموصلات والعوازل **خاطئة**؟', '[{"id":"a","text":"أغلب المعادن موادّ ناقلة للتيّار الكهربائي"},{"id":"b","text":"الزجاج موادّ ناقلة ممتازة للتيّار الكهربائي"},{"id":"c","text":"البلاستيك والمطّاط موادّ عازلة عادةً"},{"id":"d","text":"الماء الذي يحوي أملاحًا مذابة موصل جيّد للتيّار"}]'::jsonb, 'b', 'العبارة الخاطئة هي أنّ الزجاج ناقل ممتاز: الزجاج مادّة عازلة تمنع مرور التيّار الكهربائي؛ العبارات الأخرى صحيحة وتصف خصائص المعادن والبلاستيك والمطّاط والماء المالح بدقّة.', 5, 'mcq', NULL, NULL)
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
  ('d58d8964-35ac-5916-b6cc-f04b52fdf516', '8fa4eeac-8e36-5d6b-8f00-b3deb0d1c157', 'لاحظت أمّ ابنها يحاول لمس مقبس كهربائي (بريز) بيد مبلّلة بالماء بعد الاستحمام مباشرة، فنهته عن ذلك بشدّة. ما التفسير العلمي لتحذيرها؟', '[{"id":"a","text":"لأنّ الماء عازل تمامًا ولا يشكّل أيّ خطر"},{"id":"b","text":"لأنّ يده المبلّلة ستطفئ الكهرباء في المنزل كلّه"},{"id":"c","text":"لأنّ المقبس يعمل فقط عندما تكون اليد جافّة تمامًا دون أيّ سبب علمي"},{"id":"d","text":"لأنّ الماء الذي يحوي أملاحًا موصل للتيّار الكهربائي، فيزداد خطر الصعقة عبر يده المبلّلة"}]'::jsonb, 'd', 'الماء الذي يحوي أملاحًا مذابة (كماء الجسم أو ماء الاستحمام) مادّة ناقلة، فيزداد خطر الصعقة الكهربائية بشدّة عند ملامسة مقبس أو سلك عارٍ بيد مبلّلة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('97ee2cff-e18b-5331-a20a-b9f42e405ee8', '7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الدارة الكهربائية والموصلات', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('773e32ac-7c4b-5481-9bb0-7b4b51ad3464', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', 'ما اسم قطبَي المولّد الكهربائي؟', '[{"id":"a","text":"شماليّ وجنوبيّ"},{"id":"b","text":"داخليّ وخارجيّ"},{"id":"c","text":"علويّ وسفليّ"},{"id":"d","text":"موجب وسالب"}]'::jsonb, 'd', 'للمولّد الكهربائي قطبان: قطب موجب (+) وقطب سالب (−).', 1, 'mcq', NULL, NULL)
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
  ('b6b15e36-da8d-5d12-849c-1a894140f83c', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', 'بأيّ رمز اصطلاحي يُمثَّل القاطع المغلق في رسم الدارة الكهربائية؟', '[{"id":"a","text":"خطّ مستقيم متّصل بلا أيّ انقطاع"},{"id":"b","text":"خطّ مستقيم منقطع في نقطة"},{"id":"c","text":"دائرة بداخلها علامة تقاطع (×)"},{"id":"d","text":"دائرة بداخلها الحرف M"}]'::jsonb, 'a', 'القاطع المغلق يُمثَّل بخطّ مستقيم متّصل بلا أيّ انقطاع؛ أمّا القاطع المفتوح فيُمثَّل بخطّ منقطع في نقطة.', 2, 'mcq', NULL, NULL)
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
  ('904faa07-8c13-5b2c-8a96-694aeee0ba61', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', 'ما اسم العنصر الذي يحوّل الطاقة الكهربائية إلى حركة؟', '[{"id":"a","text":"المولّد"},{"id":"b","text":"المصباح"},{"id":"c","text":"المحرّك"},{"id":"d","text":"القاطع"}]'::jsonb, 'c', 'المحرّك الكهربائي هو المستقبل الذي يحوّل الطاقة الكهربائية إلى حركة، خلافًا للمصباح الذي يحوّلها إلى ضوء.', 3, 'mcq', NULL, NULL)
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
  ('78ea2f81-97be-5048-a481-4c1ee6f0cde1', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', 'أيّ ممّا يلي مثال على مادّة عازلة؟', '[{"id":"a","text":"الألمنيوم"},{"id":"b","text":"الخشب الجافّ"},{"id":"c","text":"الحديد"},{"id":"d","text":"الماء الذي يحوي أملاحًا"}]'::jsonb, 'b', 'الخشب الجافّ مادّة عازلة تمنع مرور التيّار الكهربائي؛ أمّا الألمنيوم والحديد والماء الذي يحوي أملاحًا فموادّ ناقلة.', 4, 'mcq', NULL, NULL)
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
  ('2d3637d9-7397-5def-90de-26fb48f5427b', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', 'ماذا يحدث عندما يفتح تلميذ القاطع في دارة كهربائية بسيطة كانت مغلقة؟', '[{"id":"a","text":"يستمرّ التيّار بالجريان بشكل طبيعي"},{"id":"b","text":"يزداد ضوء المصباح شدّةً"},{"id":"c","text":"تصبح الدارة مفتوحة ويتوقّف المستقبل عن العمل"},{"id":"d","text":"يتحوّل المستقبل إلى مولّد"}]'::jsonb, 'c', 'فتح القاطع يقطع الحلقة عند نقطة واحدة، فتصبح الدارة مفتوحة ويتوقّف التيّار عن الجريان، فيتوقّف المستقبل (المصباح أو المحرّك) عن العمل تمامًا.', 5, 'mcq', NULL, NULL)
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
  ('f18ed663-8a3a-5c50-bed8-db71ba2e85cc', '97ee2cff-e18b-5331-a20a-b9f42e405ee8', 'لماذا يُعدّ جسم الإنسان مادّة ناقلة نسبيًّا للتيّار الكهربائي؟', '[{"id":"a","text":"لاحتوائه على ماء وأملاح مذابة فيه"},{"id":"b","text":"لأنّه جافّ تمامًا دائمًا"},{"id":"c","text":"لأنّه مصنوع من البلاستيك"},{"id":"d","text":"لأنّه لا يتأثّر بالكهرباء إطلاقًا"}]'::jsonb, 'a', 'يحتوي جسم الإنسان على ماء وأملاح مذابة فيه، ما يجعله مادّة ناقلة نسبيًّا للتيّار الكهربائي، وهذا سبب خطورة ملامسة الأسلاك العارية.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('410b4124-9099-5e10-9e44-d7323b1d5d2f', '7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: إتقان الدارة الكهربائية والموصلات', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3d0f0bd8-3055-5e47-93b3-c11e413f476f', '410b4124-9099-5e10-9e44-d7323b1d5d2f', 'وصل تلميذ مصباحًا بمولّد عبر سلك نحاسي وقاطع، لكنّه استعمل قطعة من الزجاج بدل جزء من السلك النحاسي في منتصف المسار. ماذا يحدث للمصباح عند غلق القاطع؟', '[{"id":"a","text":"لا يضيء إطلاقًا، لأنّ الزجاج مادّة عازلة تقطع مسار التيّار"},{"id":"b","text":"يضيء بشكل طبيعي، لأنّ الزجاج شفّاف"},{"id":"c","text":"يضيء بشكل أضعف فقط"},{"id":"d","text":"يتحوّل المصباح إلى محرّك"}]'::jsonb, 'a', 'الزجاج مادّة عازلة رغم شفافيته؛ استبدال جزء من السلك الناقل بقطعة زجاج يقطع مسار التيّار في الحلقة، فتصبح الدارة مفتوحة فعليًّا ولا يضيء المصباح إطلاقًا.', 1, 'mcq', NULL, NULL)
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
  ('3456d453-dce4-5374-b7bf-175ff57ba743', '410b4124-9099-5e10-9e44-d7323b1d5d2f', 'لاحظ تلميذ أنّ مصباح دارته يضيء بشكل طبيعي عند غلق القاطع، ثمّ ينطفئ فورًا عند فتحه، ثمّ يضيء مجدّدًا بشكل طبيعي عند إعادة غلقه. ماذا يستنتج بخصوص حالة بقيّة عناصر الدارة (الأسلاك والمولّد)؟', '[{"id":"a","text":"أنّ أحد الأسلاك مقطوع بشكل دائم"},{"id":"b","text":"أنّ المولّد تالف تمامًا"},{"id":"c","text":"أنّه توجد دارة قصيرة داخل المولّد"},{"id":"d","text":"أنّ الأسلاك والمولّد سليمان، وأنّ القاطع هو المتحكّم الوحيد الطبيعي في حالة الدارة"}]'::jsonb, 'd', 'استجابة المصباح الطبيعية والفورية لكلّ فتح وغلق للقاطع، دون أيّ خلل آخر، تدلّ على أنّ الأسلاك والمولّد سليمان تمامًا، وأنّ القاطع هو الذي يتحكّم وحده بشكل طبيعي في حالة الدارة (مفتوحة أو مغلقة).', 2, 'mcq', NULL, NULL)
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
  ('c0b8b5bb-aab6-56fe-ba62-2673bbc9d8bf', '410b4124-9099-5e10-9e44-d7323b1d5d2f', 'أراد فنّي كهربائي إصلاح دارة معطّلة فاتّبع الخطوات التالية: (1) فحص أنّ القاطع مغلق. (2) لمس السلكين العاريين بيدين مبلّلتين بالماء للتأكّد من مرور التيّار. (3) فتح القاطع قبل استبدال المصباح التالف. أين يكمن الخطأ الخطير في هذه الخطوات؟', '[{"id":"a","text":"الخطوة (1)، لأنّ فحص حالة القاطع أوّلًا غير ضروري إطلاقًا"},{"id":"b","text":"الخطوة (2)، لأنّ لمس أسلاك عارية بيدين مبلّلتين بالماء الناقل خطر كهربائي كبير"},{"id":"c","text":"الخطوة (3)، لأنّ فتح القاطع قبل استبدال المصباح خطأ"},{"id":"d","text":"لا يوجد أيّ خطأ في هذه الخطوات الثلاث"}]'::jsonb, 'b', 'الخطأ الخطير في الخطوة (2): لمس أسلاك عارية بيدين مبلّلتين بالماء (وهو مادّة ناقلة بسبب الأملاح المذابة فيه) يعرّض الفنّي لخطر صعقة كهربائية كبير؛ أمّا فحص القاطع وفتحه قبل الاستبدال فخطوتان سليمتان من قواعد السلامة.', 3, 'mcq', NULL, NULL)
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
  ('c735e5bc-bd34-5f34-965b-dbc185e5b3fd', '410b4124-9099-5e10-9e44-d7323b1d5d2f', 'أيّ العبارات الأربع التالية عن الدارة الكهربائية هي **الصحيحة الوحيدة**؟', '[{"id":"a","text":"يمكن أن تضيء دارة بها انقطاع في سلك واحد فقط إذا كان المصباح جيّدًا"},{"id":"b","text":"الدارة القصيرة أكثر أمانًا من الدارة المفتوحة لأنّ التيّار فيها أقوى"},{"id":"c","text":"كلّ مادّة شفّافة كالزجاج هي بالضرورة موادّ ناقلة للتيّار"},{"id":"d","text":"القاطع المفتوح يقطع الدارة عند نقطة واحدة فيوقف التيّار كليًّا مهما كانت بقيّة الدارة سليمة"}]'::jsonb, 'd', 'العبارة الصحيحة الوحيدة هي (د): فتح القاطع في نقطة واحدة يكفي لإيقاف التيّار كليًّا. العبارات الأخرى خاطئة: انقطاع سلك واحد يمنع الإضاءة مهما كانت جودة المصباح، والدارة القصيرة خطيرة جدًّا لا أكثر أمانًا، والشفافية لا تعني الناقلية (الزجاج عازل).', 4, 'mcq', NULL, NULL)
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
  ('363d9449-679f-5735-96a2-4cee634cc71c', '410b4124-9099-5e10-9e44-d7323b1d5d2f', 'اختبر تلميذ توصيل التيّار عبر أربع موادّ مختلفة بوضع كلّ واحدة ضمن دارة تحتوي على مصباح واحد، وسجّل ملاحظاته: النحاس (أضاء المصباح)، البلاستيك (لم يضئ)، ماء الصنبور العادي (أضاء المصباح)، المطّاط (لم يضئ). أيّ استنتاج يتوافق مع هذه الملاحظات الأربع؟', '[{"id":"a","text":"النحاس وماء الصنبور موادّ ناقلة، بينما البلاستيك والمطّاط موادّ عازلة"},{"id":"b","text":"الموادّ الأربع كلّها ناقلة بنفس القدر"},{"id":"c","text":"البلاستيك والمطّاط أفضل ناقلين من النحاس"},{"id":"d","text":"لا يمكن استخلاص أيّ استنتاج من هذه الملاحظات"}]'::jsonb, 'a', 'النحاس وماء الصنبور (الذي يحوي أملاحًا مذابة) أضاءا المصباح فهما ناقلان، بينما البلاستيك والمطّاط لم يضيئاه فهما عازلان؛ هذه الملاحظات الأربع متّسقة تمامًا مع تصنيف الموادّ إلى ناقلة وعازلة.', 5, 'mcq', NULL, NULL)
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
  ('2acdcfd7-e887-5f26-863c-3ea32dc2caa2', '410b4124-9099-5e10-9e44-d7323b1d5d2f', 'أراد باحث تصميم دارة أمان بسيطة تضيء مصباح تحذير فقط عندما يُغلَق قاطع مخصّص لذلك، وتنطفئ فورًا عند فتحه، دون أيّ احتمال لحدوث دارة قصيرة عرضية. أيّ من التصاميم التالية يحقّق هذا الهدف بأمان؟', '[{"id":"a","text":"توصيل قطبَي المولّد مباشرة بسلك نحاسي واحد فقط دون أيّ مستقبل ولا قاطع"},{"id":"b","text":"توصيل المولّد بقطعة قماش عازلة بدل الأسلاك النحاسية"},{"id":"c","text":"توصيل المولّد بمصباح واحد عبر أسلاك نحاسية سليمة وقاطع، بحيث يمرّ التيّار عبر المصباح دائمًا ولا يلتقي القطبان مباشرة بسلك وحيد"},{"id":"d","text":"ترك الدارة بلا أيّ قاطع إطلاقًا"}]'::jsonb, 'c', 'التصميم الآمن يمرّر التيّار دائمًا عبر مستقبل (المصباح) فلا يلتقي القطبان مباشرة بسلك وحيد (فلا دارة قصيرة)، ويستعمل قاطعًا للتحكّم الطبيعي في الإضاءة؛ التوصيل المباشر بين القطبين ينتج دارة قصيرة خطيرة، والقماش العازل يمنع مرور التيّار كليًّا، وغياب القاطع يفقد التحكّم في الدارة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('041fad4f-cbc1-5132-9de5-f7f15efdd090', '7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للدارة الكهربائية والموصلات', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('86c949e7-f8a9-520f-a423-a78c5a93e048', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'ما تعريف الدارة الكهربائية المغلقة؟', '[{"id":"a","text":"حلقة تحتوي على مولّد فقط دون أيّ عنصر آخر"},{"id":"b","text":"حلقة بها قاطع مفتوح دائمًا"},{"id":"c","text":"حلقة بلا أسلاك توصيل إطلاقًا"},{"id":"d","text":"حلقة متّصلة بالكامل دون أيّ انقطاع، يجري فيها التيّار الكهربائي"}]'::jsonb, 'd', 'الدارة المغلقة هي حلقة متّصلة بالكامل من المولّد إلى المستقبل وعودةً إليه دون أيّ انقطاع، فيجري فيها التيّار الكهربائي ويعمل المستقبل.', 1, 'mcq', NULL, NULL)
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
  ('ef8c2814-754e-5de4-bc5f-3954dcf44f23', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'لماذا لا يضيء المصباح عندما تكون الدارة مفتوحة؟', '[{"id":"a","text":"لأنّ التيّار الكهربائي لا يستطيع الجريان بسبب الانقطاع في الحلقة"},{"id":"b","text":"لأنّ المصباح تالف دائمًا في هذه الحالة"},{"id":"c","text":"لأنّ المولّد يتوقّف عن العمل نهائيًّا"},{"id":"d","text":"لأنّ القاطع يتحوّل إلى مادّة عازلة"}]'::jsonb, 'a', 'الانقطاع في نقطة واحدة على الأقلّ من الحلقة يمنع التيّار الكهربائي من الجريان في الدارة كلّها، فيتوقّف المصباح عن الإضاءة تمامًا.', 2, 'mcq', NULL, NULL)
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
  ('35fa78d3-0b45-5036-84fc-60dbadd1ab8b', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'ما الفرق الأساسي بين المادّة الناقلة والمادّة العازلة؟', '[{"id":"a","text":"الناقلة دائمًا سائلة، والعازلة دائمًا صلبة"},{"id":"b","text":"لا فرق بينهما إطلاقًا"},{"id":"c","text":"الناقلة تسمح بمرور التيّار الكهربائي، والعازلة تمنع مروره"},{"id":"d","text":"الناقلة أثقل من العازلة دائمًا"}]'::jsonb, 'c', 'المادّة الناقلة تسمح بمرور التيّار الكهربائي عبرها بسهولة، بينما المادّة العازلة تمنع مروره منعًا تامًّا.', 3, 'mcq', NULL, NULL)
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
  ('706374ef-2793-5270-9a01-f922c7704b56', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'أيّ زوج من الموادّ التالية كلاهما من الموصلات؟', '[{"id":"a","text":"النحاس والألمنيوم"},{"id":"b","text":"المطّاط والزجاج"},{"id":"c","text":"البلاستيك والخشب الجافّ"},{"id":"d","text":"الهواء الجافّ والورق"}]'::jsonb, 'a', 'النحاس والألمنيوم معدنان ناقلان للتيّار الكهربائي؛ أمّا الأزواج الأخرى فكلّها موادّ عازلة (المطّاط والزجاج، البلاستيك والخشب الجافّ، الهواء الجافّ والورق).', 4, 'mcq', NULL, NULL)
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
  ('15cc4921-6a46-5925-98de-9ee6750c61b3', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'ركّب تلميذ دارة بمولّد ومصباح وقاطع وأسلاك نحاسية، فلاحظ أنّ المصباح ينطفئ كلّما حرّك أحد الأسلاك عند نقطة معيّنة، ويضيء مجدّدًا عندما يمسكه بثبات في وضعية أخرى. ما التفسير الأرجح لهذه الملاحظة؟', '[{"id":"a","text":"أنّ الدارة قصيرة عند تلك النقطة"},{"id":"b","text":"أنّ المصباح تالف بشكل دائم"},{"id":"c","text":"أنّ القاطع هو سبب المشكلة دون أيّ علاقة بالسلك"},{"id":"d","text":"أنّ السلك مقطوع جزئيًّا عند تلك النقطة، فيتّصل أحيانًا وينقطع أحيانًا أخرى"}]'::jsonb, 'd', 'تذبذب إضاءة المصباح حسب وضعية السلك يدلّ على أنّ السلك مقطوع جزئيًّا داخليًّا عند تلك النقطة: يتّصل الجزءان المتبقّيان أحيانًا (فيضيء) وينفصلان أحيانًا أخرى (فينطفئ)، دون أن يكون ذلك دارة قصيرة أو عطلًا في المصباح أو القاطع.', 5, 'mcq', NULL, NULL)
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
  ('547adae2-1ab5-510a-86ce-c570bf920421', '041fad4f-cbc1-5132-9de5-f7f15efdd090', 'لخّص تلميذ ما تعلّمه عن الأمان الكهربائي في أربع جمل. أيّها **خاطئة**؟', '[{"id":"a","text":"يجب فصل التيّار قبل إصلاح أيّ عطل كهربائي في المنزل"},{"id":"b","text":"لمس الأسلاك العارية بيدين مبلّلتين آمن تمامًا لأنّ الماء يبرّد اليد"},{"id":"c","text":"الدارة القصيرة قد تسبّب حريقًا بسبب اندفاع تيّار قويّ فجائي"},{"id":"d","text":"لا يجب إدخال أيّ جسم معدني في المقابس الكهربائية"}]'::jsonb, 'b', 'الجملة الخاطئة هي (ب): لمس الأسلاك العارية بيدين مبلّلتين خطير جدًّا وليس آمنًا، لأنّ الماء مادّة ناقلة تزيد من خطر الصعقة الكهربائية؛ الجمل الثلاث الأخرى صحيحة وتصف قواعد الأمان الكهربائي بدقّة.', 6, 'mcq', NULL, NULL)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cf98e2b2-dc6a-5691-aa4d-4996896ced3e', '7ed76543-049d-56e3-bae8-f36691312c1d', 'sciences-physiques-7eme', '👑 قمّة التحدّي ⭐⭐⭐⭐: إتقان الدارة الكهربائية والموصلات والعوازل', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('55fbf97f-0b3a-53e6-a104-12a058c581ee', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e', 'صمّمت مهندسة دارة إنذار بسيطة: مولّد ومصباح وقاطع موصولون بأسلاك نحاسية مغلّفة بطبقة من البلاستيك. أرادت التأكّد من سلامة لمس الغلاف البلاستيكي مباشرة أثناء مرور التيّار في الدارة المغلقة. هل هذا آمن، ولماذا؟', '[{"id":"a","text":"آمن، لأنّ الغلاف البلاستيكي مادّة عازلة تمنع وصول التيّار إلى اليد، خلافًا للّبّ النحاسي العاري بداخله"},{"id":"b","text":"غير آمن أبدًا، لأنّ البلاستيك يوصّل التيّار مباشرة إلى اليد"},{"id":"c","text":"آمن فقط إذا كانت اليد مبلّلة بالماء"},{"id":"d","text":"غير آمن، لأنّ المصباح سينفجر عند لمس الغلاف"}]'::jsonb, 'a', 'الغلاف البلاستيكي مادّة عازلة تمنع التيّار الكهربائي من الوصول إلى اليد، بينما اللبّ النحاسي بداخله وحده هو الناقل؛ لمس الغلاف السليم إذن آمن، خلافًا للّبّ العاري.', 1, 'mcq', NULL, NULL)
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
  ('8dcdccce-3807-5920-a9fa-0dc6caa1795a', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e', 'ترك تلميذ قاطع دارته مفتوحًا عمدًا، لكنّه لامس طرفَي هذا القاطع المفتوحَين بقطعة معدنية من الألمنيوم بيده. ماذا يحدث للمصباح، ولماذا؟', '[{"id":"a","text":"يبقى مطفأً، لأنّ القاطع لا يزال مفتوحًا رسميًّا"},{"id":"b","text":"يضيء بشكل أضعف فقط بسبب وجود الألمنيوم"},{"id":"c","text":"يضيء، لأنّ قطعة الألمنيوم الناقلة أعادت وصل طرفَي القاطع فأغلقت الدارة عمليًّا رغم بقاء المفتاح مفتوحًا"},{"id":"d","text":"ينفجر المصباح فورًا بسبب الألمنيوم"}]'::jsonb, 'c', 'الألمنيوم مادّة ناقلة؛ ملامسته لطرفَي القاطع المفتوحَين يخلق مسارًا ناقلًا بديلًا يعيد وصل الحلقة عمليًّا، فيضيء المصباح رغم أنّ المفتاح نفسه بقي مفتوحًا رسميًّا — الدارة تُغلَق بأيّ مسار ناقل متّصل، لا بحالة المفتاح وحدها.', 2, 'mcq', NULL, NULL)
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
  ('3778a2ff-88ae-5e46-884e-dce729fbf7e1', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e', 'زعم تلميذ خلال عرض تقديمي: «المولّد يستهلك الطاقة الكهربائية، والمصباح ينتجها ويرسلها إلى بقيّة الدارة، ولا علاقة للقاطع بحالة الدارة». أين يكمن الخطأ الأساسي في هذا الزعم؟', '[{"id":"a","text":"لا خطأ في هذا الزعم إطلاقًا"},{"id":"b","text":"الخطأ أنّ القاطع لا علاقة له فقط، أمّا دور المولّد والمصباح فصحيح كما ذكر"},{"id":"c","text":"الخطأ أنّ المصباح يجب أن يكون محرّكًا في هذا السياق"},{"id":"d","text":"الخطأ في عكس الأدوار: المولّد هو الذي يزوّد الدارة بالطاقة، والمصباح هو الذي يستهلكها ويحوّلها إلى ضوء، والقاطع يتحكّم فعليًّا في حالة الدارة"}]'::jsonb, 'd', 'الزعم يعكس الأدوار الثلاثة كلّها: المولّد يزوّد الدارة بالطاقة (لا يستهلكها)، والمصباح يستقبل هذه الطاقة ويحوّلها إلى ضوء (لا ينتجها)، والقاطع هو بالضبط ما يتحكّم في فتح الدارة أو غلقها.', 3, 'mcq', NULL, NULL)
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
  ('b7858f79-043d-5035-a771-5949d2f16426', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e', 'أيّ العبارات الأربع التالية هي **الوحيدة الصحيحة** بخصوص الدارة الكهربائية البسيطة؟', '[{"id":"a","text":"دارة قصيرة تحدث فقط عندما يكون القاطع مغلقًا ويمرّ التيّار عبر مصباح سليم"},{"id":"b","text":"وجود مادّة عازلة واحدة في أيّ نقطة من مسار الحلقة يكفي لمنع مرور التيّار كليًّا، حتّى لو كانت بقيّة الأسلاك ناقلة وسليمة"},{"id":"c","text":"الزجاج والخشب الجافّ كلاهما موادّ ناقلة جيّدة للتيّار الكهربائي"},{"id":"d","text":"القاطع المفتوح والدارة القصيرة يؤدّيان دائمًا إلى النتيجة نفسها بالضبط بالنسبة للمصباح والمولّد"}]'::jsonb, 'b', 'العبارة الصحيحة الوحيدة هي (ب): مادّة عازلة واحدة في أيّ نقطة تكفي لقطع مسار التيّار كليًّا. العبارات الأخرى خاطئة: الدارة القصيرة تحدث بتجاوز المستقبل لا بالمرور عبره، والزجاج والخشب الجافّ عازلان لا ناقلان، والقاطع المفتوح (لا تيّار، لا خطر) يختلف تمامًا عن الدارة القصيرة (تيّار قويّ خطير).', 4, 'mcq', NULL, NULL)
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
  ('c32a0dd1-f480-5e21-8e32-76723343f651', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e', 'فحصت فنّية كهربائية دارة معطّلة (مولّد، مصباح، قاطع، أسلاك نحاسية مغلّفة بالبلاستيك)، فوجدت أنّ غلاف أحد الأسلاك تمزّق في نقطة واحدة، فلامس فيها اللبّ النحاسي العاري لبّ سلك آخر مجاور مباشرة، محدثًا مسارًا يصل قطبَي المولّد ببعضهما دون المرور عبر المصباح. ما الحالة الخطيرة التي نشأت، وما الإجراء الفوري الصحيح؟', '[{"id":"a","text":"دارة قصيرة خطيرة نتيجة التقاء اللبّين الناقلين مباشرة دون مستقبل، ويجب فصل المولّد فورًا وإصلاح العزل قبل إعادة التشغيل"},{"id":"b","text":"دارة مفتوحة عادية، ويكفي إعادة توصيل السلك الممزّق"},{"id":"c","text":"وضع طبيعي لا خطر فيه لأنّ الأسلاك من نفس المادّة"},{"id":"d","text":"يجب زيادة عدد المصابيح في الدارة لحلّ المشكلة"}]'::jsonb, 'a', 'التقاء لبّين نحاسيين ناقلين مباشرة عند نقطة تمزّق العزل يصل قطبَي المولّد ببعضهما دون المرور عبر أيّ مستقبل، وهذا تعريف الدارة القصيرة بالضبط؛ الإجراء الصحيح الفوري هو فصل المولّد لوقف اندفاع التيّار القويّ، ثمّ إصلاح العزل الممزّق قبل أيّ إعادة تشغيل.', 5, 'mcq', NULL, NULL)
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
  ('7c2b9e5b-b0fa-5565-ab6a-bfe197e8089c', 'cf98e2b2-dc6a-5691-aa4d-4996896ced3e', 'قارنت مهندسة أربع دارات متطابقة (مولّد سليم، مصباح سليم، قاطع مغلق، أسلاك نحاسية)، باستثناء عنصر واحد مختلف في كلّ دارة: الأولى فيها طول إضافي من السلك النحاسي فقط، الثانية فيها عقدة محكمة في السلك النحاسي نفسه دون قطعه، الثالثة فيها فجوة هوائية صغيرة غير متّصلة بين طرفَي السلك، الرابعة فيها قطعة قماش عازلة أُدخلت في مسار السلك. في أيّ دارتَين يضيء المصباح؟', '[{"id":"a","text":"الثالثة والرابعة فقط"},{"id":"b","text":"الأولى والثانية فقط، لأنّ السلك يبقى ناقلًا متّصلًا في كلتيهما رغم الطول الإضافي أو العقدة"},{"id":"c","text":"الأولى والثالثة فقط"},{"id":"d","text":"الدارات الأربع تضيء بنفس الشدّة"}]'::jsonb, 'b', 'الأولى (طول إضافي) والثانية (عقدة محكمة) يبقى فيهما السلك النحاسي الناقل متّصلًا بالكامل دون أيّ فجوة أو مادّة عازلة، فتبقى الدارة مغلقة ويضيء المصباح؛ أمّا الثالثة (فجوة هوائية غير متّصلة) والرابعة (قماش عازل) فتقطعان مسار التيّار فعليًّا فلا يضيء المصباح فيهما.', 6, 'mcq', NULL, NULL)
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
      AND e.subject_id = 'sciences-physiques-7eme'
      AND e.source = 'admin';
  END IF;
END $$;

