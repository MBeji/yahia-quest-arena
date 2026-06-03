-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: english (Anglais)
-- Regenerate with: npm run content:build
-- Source of truth: content/english/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language) VALUES
  ('english', 'Anglais', 'Grammar, tenses, modals, vocabulary, reading & writing — Tunisian 9th-grade syllabus', 'Agilite', 'subject-english', 'Globe', 5, 'en')
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr,
  description = EXCLUDED.description,
  attribute = EXCLUDED.attribute,
  color_token = EXCLUDED.color_token,
  icon = EXCLUDED.icon,
  display_order = EXCLUDED.display_order,
  content_language = EXCLUDED.content_language;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'english'
      AND e.source = 'admin'
      AND q.id NOT IN ('080d7783-083d-5532-a30c-825175ef6d09', '5c8be484-cc52-575b-ac02-d7dd39f06af1', '138d5e16-6d8d-5dde-8107-11d41bfa48e9', 'd819986f-cfe2-53f8-bd3e-f76c9aa3e3a5', '4e4014e1-cd1d-5dcc-aac5-f44926ed20ed', '7241ee79-462b-5b3a-984c-eea640002fb0', '7a63341f-b75c-5f33-9964-f0a5e371d967', '43bd124a-3273-5b3d-babe-7c21c893d954', 'c4629643-cb37-5769-8cef-57760b3611f9', '499dffeb-77ba-571a-a272-ef6b68e30622', 'a5481854-86d1-56f3-8ac1-c1496af746ac', 'd8b38f06-1764-5f19-ba99-8f0fd06fd79b', '620f8003-045f-50cd-a9f5-2e24398d3bc5', '535f555e-00ec-541c-9430-c8c68f6f8bb0', '71117f1e-36c4-5a8e-b723-9dbc88418bf1', 'bc94054e-1446-5d04-8e8c-221f38cdcb9d', '90a789f4-e6c1-56be-86ef-0e8dd1a6eace', '86f3a7c0-5851-570f-9244-5836c0bd3430', '496b9bfb-62c9-5779-bfb6-c7155592c344', '40ef29e0-5fdd-59eb-bfc4-e34d75b19024', '21b7cf2a-d994-5d60-ae47-b0557b541a1a', '43209281-e502-55a8-af03-57de11357db3', '4c7fcb80-216b-51a9-aea0-1a7b93d56db9', 'b5fe6ca3-0ae0-5d0a-becc-64b5e9be71c2', '0bb52641-d98c-5fc5-a598-beb8dbb6ef71', 'def1e0d2-88c6-5665-b598-fcbea95f96eb', '0cb5ed33-22c7-5edc-901c-0c090a8ffbf8', 'f36a39c7-17e1-500d-a663-25676e3f151d', 'bc3de6df-27c5-564f-a509-4feb9efb0100', '14609924-058c-5c85-b515-6e83bfa1c218', '13f53f19-669d-5bae-bb4e-fee06ce7d631', '63809236-3326-5a22-bf77-ca09b2f1cd0c', '6259cdd8-58d3-5794-8789-ae21fa623ed6', 'c43f3d30-8f67-5e14-a3e2-445602f8671d', 'a79183ff-96f8-5044-a92c-581978d8d1c9', '937bbd74-4c72-52a9-a129-ef162fceeeb5', '67cf5732-4004-59fe-b4a5-bbc42565a024', '75c9c3aa-c5c6-57b3-a6ae-72b8b7d071e4', 'dafd7523-eee4-517a-9606-6b8f9a72155f', '37470435-85a2-505c-91ca-b117d0515933', 'fe75d1d4-1b37-5ee0-bbb4-a75f8fe2fc53', 'cedab619-4c56-5ca3-ab85-a95e25b97113', '4dd4df16-b2ea-5580-ae08-b16f11a0a65b', '42b58ca1-24dc-5af1-a693-9b4143086c60', 'e1a7eb87-ac87-505d-a32e-4d0f771fc4a9', 'c5e159b5-bd31-599c-86e1-07e774c6fcbd', '7b983cd9-c2c0-5a9c-a73c-ac98bf9d0808', 'd65ae3ef-84c2-5f87-b631-5f91de5eef1f', '1ceda0cf-76cc-5320-b521-1dbaaf81ff83', 'd607352b-8809-5647-8ea5-22f2ffea5f51', '8b0082a8-9de5-5939-9428-c20ddaf4909d', '12f16b47-6a4c-5487-99e2-f1f5e592d512', '4ba459b0-dc9e-57f9-9175-81ba6c0d490d', 'bc58c470-1c5f-570b-b347-e040a8aaabbf', 'ea5d79b1-f11c-501e-b3aa-b94d4fb6c94f', 'f82a2c0b-e513-5770-8b2a-024116d6b3a1', '389a214c-d24f-5aff-b8e6-447a45ed35ed', 'dbf15f17-58e6-5ab5-b012-27b2368c4ca5', 'b8ad51f2-0d2f-5a46-ba24-3e956beb4367', 'e7a6d78a-35e1-5568-a53b-3be72295890c', 'fc5f7dad-9d09-5117-ba74-0cdae2c753c4', 'b3748c61-938a-5781-a6e3-e94630c69381', '723d0846-dcc9-57dc-a8d5-3f9a581abd90', '20e1e342-c46f-5418-9778-f7583673ec41', 'dd27901a-06cb-5aa5-b6ff-932cc32ad2bd', 'cd4a4ebb-6763-5e29-a105-05d6d3c4f871', '4416d439-5708-525c-ab80-c0cf44fcea23', '169e3347-7224-50c0-8f7d-5e3e2e95772a', '6b5844a2-8c40-5cb9-a0a5-f526268f5281', 'd1c87325-095a-555e-95d3-138f47124355', '18298070-040f-5ac3-b119-9cb6fb720fa2', '9fee0d9a-a27d-5059-b62b-3e5c40b1b7ed', 'a682336a-8cac-55fe-98ed-d13e41b90c21', '10cdbbe6-7c81-509f-9107-c3f8ea0bc615', 'a14eb5d9-6d29-5415-8ec9-f1557b3e5161', 'a039206b-03d4-5fc9-86ad-75e0019c4a70', '3e22eee7-36b9-5f3a-8e0f-5333d3b76fdf', '1e66eafa-708f-5de1-a6cc-2921d6e02ffc', '01ffd3bb-6105-5323-92a1-3cc14b8348db', 'd4455f0a-1f51-5dad-ad63-3e592ebb5d36', '59194e7b-1eac-57ca-935a-de51f43964ea', 'f2b8ba0d-7631-5805-8846-a5fa20b419c6', '3e6e3345-a167-528b-86c9-8f8012c051f7', '68c353c4-5d65-5e6c-a162-99ffe1dfcef8', '101b87bc-3422-5b24-b2e4-1cd2a0ca63ab', 'ed4adc8e-de97-5a8f-a68f-5601a89daaa2', '3f3f291b-0ed5-5034-8ea2-007904302b91', 'eba3fdd7-1b65-5e0b-a7d7-298e72c9e03a', 'ecf5bd5c-0f9d-5239-a6b2-06167c953a96', 'bb70b1c9-47f1-5f87-af54-9173dbe7ab3e', '8aeba267-0d13-5fa7-91bb-0e9a7697967e', '3a452b60-51b7-5ddc-874e-12e6700c8005', '390d080b-349c-538c-9250-acd59fd6c1c3', '462d9345-5c31-5111-8ce8-314de8fd5caa', 'da303622-b350-5b8b-9b6d-370d9728bb8e', '902f8a7c-6687-5818-814b-a17e2eef1444', '32d6d026-1f7e-5d8d-9fea-2141ee659a6a', '013e8407-3e0a-5ecc-af47-acfb7edf86d9', '57545cb8-cc45-5e9a-acc6-42102f111e27', 'ee916acc-ccc1-509c-934c-be74d6578dc8', 'c3be55d8-8928-58bb-bd27-181af4a0d5e3', '9f28f12e-250e-5f6c-9fe4-d5c4de564764', '402518e0-c2ac-5c9c-86c9-8db84a66c20a', 'fc64ccc6-a874-5048-aa2b-ec4bf7fedd1b', '349da296-708e-512c-98a5-f79c0d32d5fd', 'dd9dffa7-3d7a-5ecc-a39f-486149eb142f', '6d753d89-3393-5d46-80cb-7105df4178f0', '279267c3-6b7e-528e-a57e-a4ab75cfd473', 'a4ec5fc8-06d7-59b4-bdeb-31ef723ff6fb', '1eec2a52-2bf6-5ef9-ad37-838cf0aa6bdb', '9552a62c-6941-5408-b0ca-cb7b41978a9b', '4a556f41-88ff-55ab-b724-0ab31deddf69', '78208151-f432-5986-89c6-95d2261fe015', '277e4e6e-27b9-5fde-97cd-c6f8f1586ce2', '75194e7f-9c18-5bb3-b70d-cac4a264bee3', '79afc241-0f21-57eb-b2de-d9c503d9d75c', '3248e070-6326-5ec2-9a5c-9a6562bf3d43', 'a0d0bbc9-7f9c-56c2-a957-6fda2126ca6b', 'c5b5be7e-f4ab-55b6-a38e-181570ee31d9', 'b71e28ea-6533-5302-b2c9-9ddad3b2c439', 'cf42ec20-80b2-537e-a00e-3c58063c62ff', '0b38e0c4-8ce6-5c7a-a51b-cd1d96b9c7b9', '1886b0c7-fccb-565d-92ff-f84e3a6993f4', 'e072540f-1856-5eac-9a8e-db19cec747e6', 'a9e2968b-a92d-5746-9362-164238da0854', '7989200f-316a-50cf-a23b-c990be75e64e', '43b02806-bc22-570c-b797-0b37b895db64', '8fdfff8c-ddbd-5448-85e5-83a9f52730c9', 'c961b0e5-2864-5565-abe0-a6579f21445f', '86e69d95-8ade-5dc8-bc07-e6ac553e4be0', '02029c31-8bc4-5e35-8816-cce63c913e55', '01868ac1-1c85-531f-b957-c922c262d7c3', '5c58a0e6-f68f-5902-ad5a-dfaf00b004c1', 'b3509320-48b2-5d64-b94a-277dd38e4efd', '741a817a-a456-5c11-aca4-40c0f9dd6d99', '850a7fac-2254-5cb0-ab2a-3bb1860c3d95', '35a20b5f-927d-587c-a45a-0c20fcc5c2a7', '659c49ec-4a06-519d-aba8-8a72e9ad1b81', 'd5b41c1a-0a53-5c06-915c-102435d5c6c0', 'c4d34b52-281d-57e3-8460-aafe4175f0f5', '145aa30d-c72c-5e4d-9190-f15b093dd84f', '26cb3024-d046-5eee-baa5-4d6eac88fbb0', 'b165d39a-8b1a-559a-bc93-6ef918be4194', '94522885-b8e2-5f36-becc-435d20c867e2', '719aef66-3c4a-5ad6-9af9-50fd99dcfbce', 'a209293d-9928-57f6-8315-b45fbd4f39e3', '0c4cb780-1da9-5b34-bd95-073216e9116a', 'f4aafc66-106d-5f85-918e-89cb6ca105d1', '1ddeacd6-9014-5387-85ab-5ebca4c59ff1', '71e33276-0916-5dbf-9e87-3633f36b26be', '6f165226-6514-5ab3-8be5-8e7b31368205', 'c8e56ca4-49e2-5025-8b40-72839f6dcbf5', '97062025-2da0-52e1-b0a4-2dd3e6625115', 'ffba2614-6e95-5898-af20-4f54e0cfbf82', 'cd11e9b8-d66b-5df5-9042-1f71a4c1c943', 'ce27e8ce-4c97-5c83-921e-c4c8b0fa87b7', '7819a5fe-fbe0-59b2-8d6c-056fc1f5b214', '11d6470e-14ec-5d4c-a173-f08aa8b53c8f', '98ae61e1-b215-5802-96f7-52e519f394d4', '63217691-5552-58cf-91f9-4fb34905a0ef', 'a6eb3cd1-773c-5f0e-80a8-cdc14a156d80', 'd9e00dc9-ff59-55d0-9648-d429ed81295c', 'c76b8b99-9da2-5728-9cb2-f075223db346', '4935e3cb-7a61-50a1-b744-1f0b34d7815f', '1da5ec88-b844-5781-97cc-219745da8727', '3286e813-6caa-57ff-a8e3-c3606cb69310', '4ae0793a-71f0-59d6-9e51-a31b37912048', 'f68a2c08-9617-5c02-a318-9e30a4619989', 'a387198b-d83b-52a6-9faf-fd4740453fb6', '53788e4f-8c7e-5bbf-86e1-f3ffc3ebb034', '44355f34-9f8c-53a1-aadb-81d5245d24b4', '72cf3144-6f03-53f3-a57f-d413730520ed', '684457b0-f151-5355-b7de-b1cc7331c8e0', '78a7a0fe-8fa8-50d9-8c2f-f514647fb4fc', '118a1f96-6010-503b-a5bf-8d5a7fd05817', '2b2d3600-2cf9-5aa0-af06-ba7393c39024', '74caaa9d-d014-5673-8f8b-9c0121dc06c6', '481b204d-67d0-5c6e-b6f3-01c13e92b87e', 'da568abe-ed24-5c8b-87a8-366cf878cc44', '5dfbba67-23ca-5232-bd3a-a66957add243', '30ac2283-9c21-5f32-b50c-f55d02072c39', '509c6467-c2af-55d2-a464-d762a3a5f71a', 'c1b432f1-1cbc-574c-9660-5b7227a13d3a', '843870fc-8656-51d5-9c26-be88398192c7');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'english' AND source = 'admin' AND id NOT IN ('c4f248a7-393a-5c6d-b4af-90311f1ae35d', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', '5a7783a2-f424-5be0-b07f-8bed19499adb', '285d360a-8465-518f-990c-916004f4f3b5', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', '870d7346-31c1-546f-8e25-ad1a12362ea7', '46cd64a1-c660-59b3-9588-78efe0da7594', '216cae02-7987-5531-b3fa-6af92e75e33d', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'efb66754-8009-5a3d-995a-6b71e9cf5537', '86c16cd5-392b-5ab2-af1c-2952deb88e38', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', '5e9f70de-f505-5482-a231-2c5e52d2bb68', '1ce03879-94cc-59c1-9b29-387f46b3cb17', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'aa6477e9-c60c-5771-9828-15c32bace66c', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', '50566438-5c32-582c-9b59-43a0b96cc9a4', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'e6171568-ac34-5461-a926-00b1198d046e');
DELETE FROM public.questions WHERE exercise_id IN ('c4f248a7-393a-5c6d-b4af-90311f1ae35d', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', '5a7783a2-f424-5be0-b07f-8bed19499adb', '285d360a-8465-518f-990c-916004f4f3b5', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', '870d7346-31c1-546f-8e25-ad1a12362ea7', '46cd64a1-c660-59b3-9588-78efe0da7594', '216cae02-7987-5531-b3fa-6af92e75e33d', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'efb66754-8009-5a3d-995a-6b71e9cf5537', '86c16cd5-392b-5ab2-af1c-2952deb88e38', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', '5e9f70de-f505-5482-a231-2c5e52d2bb68', '1ce03879-94cc-59c1-9b29-387f46b3cb17', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'aa6477e9-c60c-5771-9828-15c32bace66c', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', '50566438-5c32-582c-9b59-43a0b96cc9a4', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'e6171568-ac34-5461-a926-00b1198d046e') AND id NOT IN ('080d7783-083d-5532-a30c-825175ef6d09', '5c8be484-cc52-575b-ac02-d7dd39f06af1', '138d5e16-6d8d-5dde-8107-11d41bfa48e9', 'd819986f-cfe2-53f8-bd3e-f76c9aa3e3a5', '4e4014e1-cd1d-5dcc-aac5-f44926ed20ed', '7241ee79-462b-5b3a-984c-eea640002fb0', '7a63341f-b75c-5f33-9964-f0a5e371d967', '43bd124a-3273-5b3d-babe-7c21c893d954', 'c4629643-cb37-5769-8cef-57760b3611f9', '499dffeb-77ba-571a-a272-ef6b68e30622', 'a5481854-86d1-56f3-8ac1-c1496af746ac', 'd8b38f06-1764-5f19-ba99-8f0fd06fd79b', '620f8003-045f-50cd-a9f5-2e24398d3bc5', '535f555e-00ec-541c-9430-c8c68f6f8bb0', '71117f1e-36c4-5a8e-b723-9dbc88418bf1', 'bc94054e-1446-5d04-8e8c-221f38cdcb9d', '90a789f4-e6c1-56be-86ef-0e8dd1a6eace', '86f3a7c0-5851-570f-9244-5836c0bd3430', '496b9bfb-62c9-5779-bfb6-c7155592c344', '40ef29e0-5fdd-59eb-bfc4-e34d75b19024', '21b7cf2a-d994-5d60-ae47-b0557b541a1a', '43209281-e502-55a8-af03-57de11357db3', '4c7fcb80-216b-51a9-aea0-1a7b93d56db9', 'b5fe6ca3-0ae0-5d0a-becc-64b5e9be71c2', '0bb52641-d98c-5fc5-a598-beb8dbb6ef71', 'def1e0d2-88c6-5665-b598-fcbea95f96eb', '0cb5ed33-22c7-5edc-901c-0c090a8ffbf8', 'f36a39c7-17e1-500d-a663-25676e3f151d', 'bc3de6df-27c5-564f-a509-4feb9efb0100', '14609924-058c-5c85-b515-6e83bfa1c218', '13f53f19-669d-5bae-bb4e-fee06ce7d631', '63809236-3326-5a22-bf77-ca09b2f1cd0c', '6259cdd8-58d3-5794-8789-ae21fa623ed6', 'c43f3d30-8f67-5e14-a3e2-445602f8671d', 'a79183ff-96f8-5044-a92c-581978d8d1c9', '937bbd74-4c72-52a9-a129-ef162fceeeb5', '67cf5732-4004-59fe-b4a5-bbc42565a024', '75c9c3aa-c5c6-57b3-a6ae-72b8b7d071e4', 'dafd7523-eee4-517a-9606-6b8f9a72155f', '37470435-85a2-505c-91ca-b117d0515933', 'fe75d1d4-1b37-5ee0-bbb4-a75f8fe2fc53', 'cedab619-4c56-5ca3-ab85-a95e25b97113', '4dd4df16-b2ea-5580-ae08-b16f11a0a65b', '42b58ca1-24dc-5af1-a693-9b4143086c60', 'e1a7eb87-ac87-505d-a32e-4d0f771fc4a9', 'c5e159b5-bd31-599c-86e1-07e774c6fcbd', '7b983cd9-c2c0-5a9c-a73c-ac98bf9d0808', 'd65ae3ef-84c2-5f87-b631-5f91de5eef1f', '1ceda0cf-76cc-5320-b521-1dbaaf81ff83', 'd607352b-8809-5647-8ea5-22f2ffea5f51', '8b0082a8-9de5-5939-9428-c20ddaf4909d', '12f16b47-6a4c-5487-99e2-f1f5e592d512', '4ba459b0-dc9e-57f9-9175-81ba6c0d490d', 'bc58c470-1c5f-570b-b347-e040a8aaabbf', 'ea5d79b1-f11c-501e-b3aa-b94d4fb6c94f', 'f82a2c0b-e513-5770-8b2a-024116d6b3a1', '389a214c-d24f-5aff-b8e6-447a45ed35ed', 'dbf15f17-58e6-5ab5-b012-27b2368c4ca5', 'b8ad51f2-0d2f-5a46-ba24-3e956beb4367', 'e7a6d78a-35e1-5568-a53b-3be72295890c', 'fc5f7dad-9d09-5117-ba74-0cdae2c753c4', 'b3748c61-938a-5781-a6e3-e94630c69381', '723d0846-dcc9-57dc-a8d5-3f9a581abd90', '20e1e342-c46f-5418-9778-f7583673ec41', 'dd27901a-06cb-5aa5-b6ff-932cc32ad2bd', 'cd4a4ebb-6763-5e29-a105-05d6d3c4f871', '4416d439-5708-525c-ab80-c0cf44fcea23', '169e3347-7224-50c0-8f7d-5e3e2e95772a', '6b5844a2-8c40-5cb9-a0a5-f526268f5281', 'd1c87325-095a-555e-95d3-138f47124355', '18298070-040f-5ac3-b119-9cb6fb720fa2', '9fee0d9a-a27d-5059-b62b-3e5c40b1b7ed', 'a682336a-8cac-55fe-98ed-d13e41b90c21', '10cdbbe6-7c81-509f-9107-c3f8ea0bc615', 'a14eb5d9-6d29-5415-8ec9-f1557b3e5161', 'a039206b-03d4-5fc9-86ad-75e0019c4a70', '3e22eee7-36b9-5f3a-8e0f-5333d3b76fdf', '1e66eafa-708f-5de1-a6cc-2921d6e02ffc', '01ffd3bb-6105-5323-92a1-3cc14b8348db', 'd4455f0a-1f51-5dad-ad63-3e592ebb5d36', '59194e7b-1eac-57ca-935a-de51f43964ea', 'f2b8ba0d-7631-5805-8846-a5fa20b419c6', '3e6e3345-a167-528b-86c9-8f8012c051f7', '68c353c4-5d65-5e6c-a162-99ffe1dfcef8', '101b87bc-3422-5b24-b2e4-1cd2a0ca63ab', 'ed4adc8e-de97-5a8f-a68f-5601a89daaa2', '3f3f291b-0ed5-5034-8ea2-007904302b91', 'eba3fdd7-1b65-5e0b-a7d7-298e72c9e03a', 'ecf5bd5c-0f9d-5239-a6b2-06167c953a96', 'bb70b1c9-47f1-5f87-af54-9173dbe7ab3e', '8aeba267-0d13-5fa7-91bb-0e9a7697967e', '3a452b60-51b7-5ddc-874e-12e6700c8005', '390d080b-349c-538c-9250-acd59fd6c1c3', '462d9345-5c31-5111-8ce8-314de8fd5caa', 'da303622-b350-5b8b-9b6d-370d9728bb8e', '902f8a7c-6687-5818-814b-a17e2eef1444', '32d6d026-1f7e-5d8d-9fea-2141ee659a6a', '013e8407-3e0a-5ecc-af47-acfb7edf86d9', '57545cb8-cc45-5e9a-acc6-42102f111e27', 'ee916acc-ccc1-509c-934c-be74d6578dc8', 'c3be55d8-8928-58bb-bd27-181af4a0d5e3', '9f28f12e-250e-5f6c-9fe4-d5c4de564764', '402518e0-c2ac-5c9c-86c9-8db84a66c20a', 'fc64ccc6-a874-5048-aa2b-ec4bf7fedd1b', '349da296-708e-512c-98a5-f79c0d32d5fd', 'dd9dffa7-3d7a-5ecc-a39f-486149eb142f', '6d753d89-3393-5d46-80cb-7105df4178f0', '279267c3-6b7e-528e-a57e-a4ab75cfd473', 'a4ec5fc8-06d7-59b4-bdeb-31ef723ff6fb', '1eec2a52-2bf6-5ef9-ad37-838cf0aa6bdb', '9552a62c-6941-5408-b0ca-cb7b41978a9b', '4a556f41-88ff-55ab-b724-0ab31deddf69', '78208151-f432-5986-89c6-95d2261fe015', '277e4e6e-27b9-5fde-97cd-c6f8f1586ce2', '75194e7f-9c18-5bb3-b70d-cac4a264bee3', '79afc241-0f21-57eb-b2de-d9c503d9d75c', '3248e070-6326-5ec2-9a5c-9a6562bf3d43', 'a0d0bbc9-7f9c-56c2-a957-6fda2126ca6b', 'c5b5be7e-f4ab-55b6-a38e-181570ee31d9', 'b71e28ea-6533-5302-b2c9-9ddad3b2c439', 'cf42ec20-80b2-537e-a00e-3c58063c62ff', '0b38e0c4-8ce6-5c7a-a51b-cd1d96b9c7b9', '1886b0c7-fccb-565d-92ff-f84e3a6993f4', 'e072540f-1856-5eac-9a8e-db19cec747e6', 'a9e2968b-a92d-5746-9362-164238da0854', '7989200f-316a-50cf-a23b-c990be75e64e', '43b02806-bc22-570c-b797-0b37b895db64', '8fdfff8c-ddbd-5448-85e5-83a9f52730c9', 'c961b0e5-2864-5565-abe0-a6579f21445f', '86e69d95-8ade-5dc8-bc07-e6ac553e4be0', '02029c31-8bc4-5e35-8816-cce63c913e55', '01868ac1-1c85-531f-b957-c922c262d7c3', '5c58a0e6-f68f-5902-ad5a-dfaf00b004c1', 'b3509320-48b2-5d64-b94a-277dd38e4efd', '741a817a-a456-5c11-aca4-40c0f9dd6d99', '850a7fac-2254-5cb0-ab2a-3bb1860c3d95', '35a20b5f-927d-587c-a45a-0c20fcc5c2a7', '659c49ec-4a06-519d-aba8-8a72e9ad1b81', 'd5b41c1a-0a53-5c06-915c-102435d5c6c0', 'c4d34b52-281d-57e3-8460-aafe4175f0f5', '145aa30d-c72c-5e4d-9190-f15b093dd84f', '26cb3024-d046-5eee-baa5-4d6eac88fbb0', 'b165d39a-8b1a-559a-bc93-6ef918be4194', '94522885-b8e2-5f36-becc-435d20c867e2', '719aef66-3c4a-5ad6-9af9-50fd99dcfbce', 'a209293d-9928-57f6-8315-b45fbd4f39e3', '0c4cb780-1da9-5b34-bd95-073216e9116a', 'f4aafc66-106d-5f85-918e-89cb6ca105d1', '1ddeacd6-9014-5387-85ab-5ebca4c59ff1', '71e33276-0916-5dbf-9e87-3633f36b26be', '6f165226-6514-5ab3-8be5-8e7b31368205', 'c8e56ca4-49e2-5025-8b40-72839f6dcbf5', '97062025-2da0-52e1-b0a4-2dd3e6625115', 'ffba2614-6e95-5898-af20-4f54e0cfbf82', 'cd11e9b8-d66b-5df5-9042-1f71a4c1c943', 'ce27e8ce-4c97-5c83-921e-c4c8b0fa87b7', '7819a5fe-fbe0-59b2-8d6c-056fc1f5b214', '11d6470e-14ec-5d4c-a173-f08aa8b53c8f', '98ae61e1-b215-5802-96f7-52e519f394d4', '63217691-5552-58cf-91f9-4fb34905a0ef', 'a6eb3cd1-773c-5f0e-80a8-cdc14a156d80', 'd9e00dc9-ff59-55d0-9648-d429ed81295c', 'c76b8b99-9da2-5728-9cb2-f075223db346', '4935e3cb-7a61-50a1-b744-1f0b34d7815f', '1da5ec88-b844-5781-97cc-219745da8727', '3286e813-6caa-57ff-a8e3-c3606cb69310', '4ae0793a-71f0-59d6-9e51-a31b37912048', 'f68a2c08-9617-5c02-a318-9e30a4619989', 'a387198b-d83b-52a6-9faf-fd4740453fb6', '53788e4f-8c7e-5bbf-86e1-f3ffc3ebb034', '44355f34-9f8c-53a1-aadb-81d5245d24b4', '72cf3144-6f03-53f3-a57f-d413730520ed', '684457b0-f151-5355-b7de-b1cc7331c8e0', '78a7a0fe-8fa8-50d9-8c2f-f514647fb4fc', '118a1f96-6010-503b-a5bf-8d5a7fd05817', '2b2d3600-2cf9-5aa0-af06-ba7393c39024', '74caaa9d-d014-5673-8f8b-9c0121dc06c6', '481b204d-67d0-5c6e-b6f3-01c13e92b87e', 'da568abe-ed24-5c8b-87a8-366cf878cc44', '5dfbba67-23ca-5232-bd3a-a66957add243', '30ac2283-9c21-5f32-b50c-f55d02072c39', '509c6467-c2af-55d2-a464-d762a3a5f71a', 'c1b432f1-1cbc-574c-9660-5b7227a13d3a', '843870fc-8656-51d5-9c26-be88398192c7');
DELETE FROM public.chapters c WHERE c.subject_id = 'english' AND c.id NOT IN ('6c5876d5-c564-5362-9ec4-db66068dd428', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'ff2b7070-d893-5229-bd8c-2b042dee6081', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', '2bd52d30-882a-5849-a561-66dad79c756d', '9b958e8f-0a4d-5299-aedc-ca62d7866435', '0bc67bcc-bd66-52fb-b968-3dc60375eba1') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6c5876d5-c564-5362-9ec4-db66068dd428', 'english', 'Present Tenses', 'Present simple vs present continuous: form, uses, time markers and stative verbs', '# ⚔️ Present Tenses — Your First Weapon

> 💡 "Choose your tense like a weapon: the **simple** for what is always true, the **continuous** for what is happening right now."

## 🏰 The Present Simple

We use the present simple for **habits, routines, facts and general truths**.

- **Form**: subject + base verb (add **-s / -es** for he / she / it).
  - _I / you / we / they **play**._
  - _He / she / it **plays**._
- **Negative**: don''t / doesn''t + base verb. _She **doesn''t play**._
- **Question**: Do / Does + subject + base verb? _**Does** she **play**?_

> 🗡️ Spelling of the third person: _go → goes_, _study → studies_, _watch → watches_.

## ⚡ Time markers of the Present Simple

These words signal a habit or routine:

- **Adverbs of frequency**: always, usually, often, sometimes, rarely, never.
- **Expressions**: every day, every week, on Mondays, twice a week.

_He **usually** gets up at six. We play football **every** Saturday._

## 🛡️ The Present Continuous

We use the present continuous for **actions happening now** or **around now**.

- **Form**: am / is / are + verb**-ing**.
  - _I **am working**. She **is working**. They **are working**._
- **Negative**: am/is/are + **not** + -ing. _He **isn''t sleeping**._
- **Question**: Am/Is/Are + subject + -ing? _**Are** you **listening**?_

## 📐 Time markers of the Present Continuous

- now, right now, at the moment, at present
- **Look! / Listen!**, today, these days

_**Look!** The baby **is crying**. I **am reading** an interesting book **these days**._

## 🔮 Simple vs Continuous

| Present Simple              | Present Continuous               |
| --------------------------- | -------------------------------- |
| habit / routine             | action happening now             |
| general truth               | temporary action                 |
| _Water **boils** at 100°C._ | _The kettle **is boiling** now._ |

## 🧪 Stative verbs

Some verbs describe **states**, not actions, and are **not** normally used in the continuous:
_like, love, hate, want, need, know, understand, believe, seem, **be**, have (= possess)_.

> ⚠️ Say _I **know** the answer_ (not "I am knowing"). Say _This cake **tastes** good_ (not "is tasting").

> 🏆 You now control the present. Next, we travel to the **past tenses**.', '# 📜 Summary: Present Tenses

- **Present simple** = habits, routines, facts, general truths. Add **-s/-es** for he/she/it. Negative/question with **do/does**.
- Time markers: always, usually, often, sometimes, never; every day, on Mondays.
- **Present continuous** = am/is/are + **verb-ing**, for actions happening **now** or around now.
- Time markers: now, right now, at the moment, Look!, Listen!, these days.
- **Simple vs continuous**: _Water boils at 100°C_ (truth) vs _The kettle is boiling_ (now).
- **Stative verbs** (like, know, want, understand, be, have=possess) are **not** used in the continuous.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', 'Past Tenses', 'Past simple, past continuous, and present perfect: form, uses, time markers and how to choose between them', '# ⚔️ Past Tenses — Journey Through Time

> 💡 "The past is your archive: **simple** for completed events, **continuous** for the scene behind the action, **perfect** for experiences that still matter now."

## 🏰 The Past Simple

We use the past simple for **completed actions at a specific time in the past**.

- **Regular verbs**: add **-ed** (or just **-d** if the verb ends in -e).
  - _walk → walked_, _study → studied_, _stop → stopped_ (double the consonant)
- **Irregular verbs**: must be memorised — there is no rule!
  - _go → went_, _see → saw_, _take → took_, _buy → bought_, _write → wrote_, _have → had_, _make → made_, _come → came_, _give → gave_, _tell → told_
- **Negative**: **did not (didn''t)** + base verb. _She **didn''t go** to school yesterday._
- **Question**: **Did** + subject + base verb? _**Did** you **see** the match?_

> 🗡️ Never add **-ed** after **did**: say _Did she **go**?_ NOT ~~Did she went?~~

## ⚡ Time Markers of the Past Simple

These words indicate a completed past event:

- yesterday, last night / last week / last year
- ago (two days **ago**, a month **ago**)
- in + year: in 2022, in the 19th century
- when + past: _When I was young, I **played** in the street._

## 🛡️ The Past Continuous

We use the past continuous for **an action that was in progress at a specific moment in the past**.

- **Form**: **was / were** + verb**-ing**
  - _I / he / she / it **was sleeping**. We / you / they **were sleeping**._
- **Negative**: was/were + **not** + -ing. _They **weren''t listening**._
- **Question**: Was/Were + subject + -ing? _**Were** you **studying** at 8 p.m.?_

## 🔮 Past Simple vs Past Continuous (when / while)

The most common pattern: the **continuous** gives the background, the **simple** interrupts it.

| Connector | Structure                                       | Example                                                  |
| --------- | ----------------------------------------------- | -------------------------------------------------------- |
| **when**  | past simple interrupts past continuous          | _I was cooking **when** the phone **rang**._             |
| **while** | two continuous actions at the same time         | _**While** I was reading, she was listening to music._   |
| **while** | continuous = background + simple = interruption | _**While** he was walking home, it **started** to rain._ |

> ⚠️ **When** the phone rang (= at the moment it rang) signals a short completed event → past simple. **While** I was cooking (= during the cooking) → past continuous.

## 🧪 The Present Perfect

We use the present perfect for:

1. **Life experiences** (at an unspecified time): _Have you ever **visited** Carthage?_
2. **Recent past with a connection to now**: _She has just **finished** her homework._
3. **Completed action with a result**: _I''ve **lost** my keys._ (I can''t find them now!)

- **Form**: **have / has** + **past participle**
  - _I / you / we / they **have seen** it. He / she / it **has seen** it._
- **Negative**: have/has + **not** (haven''t / hasn''t). _He **hasn''t arrived** yet._
- **Question**: Have/Has + subject + past participle? _**Have** you **eaten** breakfast?_

## 🌟 Key Adverbs of the Present Perfect

| Adverb      | Position                                        | Example                                               |
| ----------- | ----------------------------------------------- | ----------------------------------------------------- |
| **ever**    | between subject and past participle (questions) | _Have you **ever** tried sushi?_                      |
| **never**   | between have/has and past participle            | _I have **never** flown in a plane._                  |
| **just**    | between have/has and past participle            | _She has **just** left the room._                     |
| **already** | between have/has and past participle            | _They have **already** finished._                     |
| **yet**     | end of negative or question                     | _Has he arrived **yet**? / He hasn''t called **yet**._ |

## ⚔️ Present Perfect vs Past Simple

The key question: do you know **when** it happened?

| Present Perfect                            | Past Simple                                    |
| ------------------------------------------ | ---------------------------------------------- |
| Time is **unspecified** or **unimportant** | Specific time is **mentioned**                 |
| _I **have seen** that film._               | _I **saw** that film **last Sunday**._         |
| _She **has lived** in Sfax._               | _She **lived** in Sfax **from 2010 to 2015**._ |
| Uses: ever, never, just, already, yet      | Uses: yesterday, ago, last…, in + year         |

> 🏆 You now command the past! Next chapter: the **future tenses**.', '# 📜 Summary: Past Tenses

- **Past simple** = completed action at a specific time. Regular verbs: add **-ed**. Irregular verbs must be memorised (_go→went, see→saw, take→took_). Negative/question with **did**.
- Time markers: yesterday, last week, ago, in + year, when.
- **Past continuous** = **was/were + verb-ing**, for an action in progress at a past moment. Negative/question with was/were.
- **when/while pattern**: past continuous (background) + past simple (interruption). _I was cooking **when** the phone **rang**._
- **Present perfect** = **have/has + past participle**, for experiences (ever/never), recent events (just), and completed actions with present results.
- Key adverbs: **ever** (questions), **never**, **just**, **already** (after have/has); **yet** (end of negative/question).
- **Present perfect vs past simple**: no specific time → perfect; specific time mentioned → past simple.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', 'The Future', 'will, be going to, and present continuous for the future: uses, time markers, and time clauses', '# 🔮 The Future — Unlock Tomorrow

> 💡 "Choose your future weapon carefully: **will** for the unexpected decision, **going to** for your battle plan, the **present continuous** for the appointment already in the calendar."

## 🏰 "Will" — Predictions, Decisions and Promises

Use **will** in three key situations:

1. **Prediction** (based on opinion or belief, no visible evidence): _I think it **will rain** tomorrow._
2. **Decision made at the moment of speaking** (spontaneous): _The phone is ringing — I**''ll get** it!_
3. **Promises and offers**: _I **will help** you with your homework. / **Will** you **carry** this for me?_

- **Form**: subject + **will** + base verb (same for all persons)
  - _I / you / he / she / we / they **will go**._
- **Negative**: **will not (won''t)** + base verb. _She **won''t tell** anyone._
- **Question**: **Will** + subject + base verb? _**Will** you **come** to the party?_
- **Short form**: I''ll, you''ll, he''ll, she''ll, we''ll, they''ll.

> 🗡️ Never add **-s**, **-ed**, or **-ing** to the base verb after **will**: _He **will go**_, NOT ~~He will goes~~.

## ⚡ "Be Going To" — Intentions and Evidence-Based Predictions

Use **be going to** in two key situations:

1. **Intention or plan already decided**: _We **are going to visit** Carthage next weekend._ (we planned it)
2. **Prediction based on present evidence**: _Look at those clouds — it **is going to rain**!_

- **Form**: **am / is / are** + **going to** + base verb
  - _I **am going to study**. He **is going to study**. They **are going to study**._
- **Negative**: am/is/are + **not** + going to + base verb. _I**''m not going to** miss the bus._
- **Question**: Am/Is/Are + subject + going to + base verb? _**Is** she **going to** take the exam?_

## 🛡️ Will vs Be Going To

|            | **will**                               | **be going to**                                    |
| ---------- | -------------------------------------- | -------------------------------------------------- |
| Decision   | Made NOW while speaking                | Already decided BEFORE speaking                    |
| Prediction | Opinion / belief                       | Based on visible evidence                          |
| Example    | _"I''ll have the soup."_ (just decided) | _"He''s going to fall!"_ (you can see it happening) |

> ⚠️ Both can express future predictions, but the source of evidence makes the difference.

## 🔮 Present Continuous for Fixed Future Arrangements

When a future event is **already arranged** (time, place, other people involved), use the **present continuous**:

- _I **am meeting** Dr Ben Ali at 9 a.m. tomorrow._ (appointment in the diary)
- _They **are flying** to London next Monday._ (tickets booked)

> This is very similar to "be going to" for plans, but present continuous stresses that the arrangement is **fixed and confirmed** with others.

## 🌟 Future Time Markers

These words signal the future:

- **tomorrow**, the day after tomorrow
- **next** + period: next week, next month, next year, next Monday
- **soon**, in a moment, in + future time: in two days, in 2030
- **tonight**, this afternoon, this evening

_She **will finish** her project **tomorrow**. We**''re going to** travel **next summer**._

## ⚔️ Time Clauses: when / as soon as + Present

> 🔑 Rule: after **when**, **as soon as**, **before**, **after**, **until** in a **future** sentence, use the **present simple** — NOT will!

| ✅ Correct                                     | ❌ Wrong                          |
| ---------------------------------------------- | --------------------------------- |
| _Call me **when** you **arrive**._             | ~~Call me when you will arrive.~~ |
| _**As soon as** he **finishes**, we will eat._ | ~~As soon as he will finish...~~  |
| _She will call you **before** she **leaves**._ | ~~before she will leave~~         |

> 🏆 Future tenses mastered! Next: **modal verbs** — the power-ups of English grammar.', '# 📜 Summary: The Future

- **will** = prediction (opinion/belief), spontaneous decision made while speaking, promise or offer. Form: **will + base verb** (no -s/-ed/-ing). Negative: **won''t**.
- **be going to** = intention already decided before speaking, or prediction based on visible evidence. Form: **am/is/are + going to + base verb**.
- **will vs going to**: _"I''ll have the soup"_ (decided now) vs _"We''re going to visit Carthage"_ (plan already made) vs _"It''s going to rain"_ (dark clouds visible).
- **Present continuous** = fixed future arrangement (time/place/people confirmed). _I am meeting her at 9 a.m. tomorrow._
- Time markers: tomorrow, next week/month/year, soon, tonight, in + future time.
- **Time clauses** (when, as soon as, before, after, until): use **present simple** after them in a future sentence — NEVER will. _Call me when you **arrive**._', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', 'Modal Verbs', 'can/could, must/have to, should/ought to, may/might: ability, obligation, advice, possibility and key form rules', '# 🧙 Modal Verbs — The Power-Ups of English

> 💡 "Modals are power-ups: they change the meaning of the main verb without changing its form. Master them and you control ability, permission, obligation, and possibility."

## 🏰 Key Form Rules

Before exploring each modal, learn these universal rules — they apply to **all** modals:

- Modal + **base verb** (no -s, no -ed, no -ing, no to).
  - _She **can swim**._ (NOT ~~She can swims~~)
  - _He **must leave**._ (NOT ~~He must to leave~~)
- **Negative**: modal + **not** + base verb (contractions: can''t, couldn''t, won''t, mustn''t, shouldn''t, mightn''t).
- **Question**: modal + subject + base verb (no do/does/did).
  - _**Can** you help me?_ (NOT ~~Do you can help?~~)
- **Exceptions**: **have to** and **ought to** include "to"; they follow different question patterns.

> 🗡️ Never write ~~She cans play~~ or ~~He musts go~~. Modals never take -s.

## ⚡ Can / Could — Ability, Possibility, Permission, Requests

| Use                   | Modal         | Example                                        |
| --------------------- | ------------- | ---------------------------------------------- |
| Ability (present)     | **can**       | _I **can** speak three languages._             |
| Ability (past)        | **could**     | _When I was five, I **could** read._           |
| Possibility           | **can/could** | _Smoking **can** damage your health._          |
| Permission (informal) | **can**       | _**Can** I use your pen, please?_              |
| Request (polite)      | **could**     | _**Could** you open the window?_ (more polite) |

> ⚠️ **Could** is also the past of **can**: _Last year she **couldn''t** swim; now she **can**._

## 🛡️ Must / Have To — Obligation

Both express obligation, but there is an important difference:

| Modal       | Source of obligation                       | Example                                |
| ----------- | ------------------------------------------ | -------------------------------------- |
| **must**    | Personal feeling / the speaker''s authority | _I **must** call my mother tonight._   |
| **have to** | External rule or authority                 | _Students **have to** wear a uniform._ |

- **Negative contrast** — this is crucial:
  - **mustn''t** = prohibition (you are NOT allowed to do it). _You **mustn''t** smoke here._
  - **don''t have to** = no obligation (you are free to choose). _You **don''t have to** come if you''re tired._

> 🔑 _You **mustn''t** tell anyone_ ≠ _You **don''t have to** tell anyone_. The first forbids it; the second merely says it isn''t required.

## 🔮 Should / Ought To — Advice

Use **should** or **ought to** to give advice or express what is the right or expected thing to do:

- _You **should** study more if you want to pass._ (advice)
- _He **ought to** apologise._ (moral expectation)
- **Negative**: **shouldn''t** (you shouldn''t stay up late) / **ought not to**.
- **Question with should**: _**Should** I bring anything to the party?_

> 💡 **Should** and **ought to** have the same meaning. **Should** is far more common in everyday English.

## 🌟 May / Might — Possibility and Permission

| Use                        | Modal       | Example                                           |
| -------------------------- | ----------- | ------------------------------------------------- |
| Possibility (quite likely) | **may**     | _It **may** be cold tonight — take a jacket._     |
| Possibility (less certain) | **might**   | _I **might** go to the party — I''m not sure yet._ |
| Permission (formal)        | **may**     | _**May** I leave the room, please?_               |
| Permission (negative)      | **may not** | _You **may not** use your phone during the exam._ |

> ⚠️ **Might** suggests even less certainty than **may**. In practice, students can use them interchangeably for possibility.

## ⚔️ Modals at a Glance

| Modal        | Main uses                        | Negative form             |
| ------------ | -------------------------------- | ------------------------- |
| **can**      | ability, permission, possibility | **can''t / cannot**        |
| **could**    | past ability, polite request     | **couldn''t**              |
| **must**     | strong obligation (personal)     | **mustn''t** (prohibition) |
| **have to**  | obligation (external rule)       | **don''t/doesn''t have to** |
| **should**   | advice, recommendation           | **shouldn''t**             |
| **ought to** | advice, moral duty               | **ought not to**          |
| **may**      | possibility, formal permission   | **may not**               |
| **might**    | weak possibility                 | **might not**             |

> 🏆 You have unlocked the modal power-ups! Next: **Conditionals** — the if-then power combos of English.', '# 📜 Summary: Modal Verbs

- **Universal form rules**: modal + **base verb** (no -s, no -ed, no -ing). Negative: modal + not. Question: modal + subject + base verb (no do/does). Exceptions: **have to** and **ought to** include "to".
- **can** = present ability, informal permission, possibility. **could** = past ability, polite request/permission.
- **must** = strong personal obligation. **have to** = external obligation (rules/authority).
- **mustn''t** (prohibition — NOT allowed) vs **don''t have to** (no obligation — free to choose). These are opposite in meaning!
- **should / ought to** = advice or recommendation. Negative: **shouldn''t**. Use should in questions: _Should I bring anything?_
- **may** = possibility (fairly likely) or formal permission. **might** = weaker possibility. Neither takes -s or -ed.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', 'Conditionals', 'Zero, first, and second conditionals: form, uses, if-clause position, comma rules, and unless', '# ⚡ Conditionals — The If-Then Power Combos

> 💡 "Every conditional is a deal: the if-clause sets the condition, the main clause delivers the consequence. Get the tenses right, and you unlock the full power of possibility."

## 🏰 Zero Conditional — General Truths

Use the zero conditional for **facts, scientific truths, and things that always happen** when a condition is met.

- **Form**: **If + present simple, present simple**
  - _If you heat water to 100°C, it **boils**._
  - _If it **rains**, the ground **gets** wet._
  - _Plants **die** if they **don''t** get water._

> 🗡️ Both clauses use the **present simple** because the result is always, certainly true — it is not a prediction or a hypothesis.

## ⚡ First Conditional — Real Future Situations

Use the first conditional for **real or likely situations in the future**.

- **Form**: **If + present simple, will + base verb**
  - _If you **study** hard, you **will pass** the exam._
  - _If it **rains** tomorrow, we **won''t go** to the beach._
  - _She **will be** angry if you **are** late._

> 🗡️ The if-clause uses the **present simple** — NEVER will in the if-clause! The main clause uses **will** (or won''t).

## 🛡️ Second Conditional — Unreal / Hypothetical Situations

Use the second conditional for **imaginary, hypothetical, or unlikely situations in the present or future**.

- **Form**: **If + past simple, would + base verb**
  - _If I **had** a million dinars, I **would buy** a house._
  - _If she **lived** in Tunis, she **would visit** us more often._
  - _What **would** you do if you **won** the lottery?_

> ⚠️ With the verb **be** in the if-clause, use **were** for all persons in formal/standard English:
> _If I **were** you, I would apologise._ (NOT ~~If I was you~~)

> 🔑 The second conditional describes something **not real now** — the speaker does not have a million dinars, she does not live in Tunis.

## 🔮 First vs Second Conditional

|             | First Conditional        | Second Conditional                          |
| ----------- | ------------------------ | ------------------------------------------- |
| Situation   | **Real / likely** future | **Unreal / hypothetical** present or future |
| If-clause   | present simple           | past simple                                 |
| Main clause | **will** + base verb     | **would** + base verb                       |
| Example     | _If I study, I''ll pass._ | _If I studied all night, I would pass._     |

> 💡 Compare: _If it **rains** tomorrow, I **will** stay home._ (realistic possibility) vs _If it **rained** every day, this city **would** be a jungle._ (imaginary).

## 🌟 Position of the If-Clause and the Comma

The if-clause can come **first or second** in the sentence:

- **If-clause first**: use a **comma** after it.
  - _**If you practise every day**, your English will improve._
- **If-clause second** (after the main clause): **no comma**.
  - _Your English will improve **if you practise every day**._

> 🗡️ Comma rule: **comma only when the if-clause comes first**.

## ⚔️ "Unless" — The Negative Condition

**Unless** means **if … not**. It introduces a negative condition:

- _**Unless** you hurry, you **will** miss the train._ = _If you **don''t** hurry, you **will** miss the train._
- _I **won''t** go **unless** you come with me._ = _I **won''t** go if you **don''t** come._
- _**Unless** it **rains**, we play outside._ (zero conditional with unless)

> ⚠️ Do NOT use **unless** with a negative verb in the same clause — that creates a double negative: ~~Unless you don''t hurry~~ is wrong.

## 🧪 Summary Table

| Conditional | If-clause      | Main clause       | Use                   |
| ----------- | -------------- | ----------------- | --------------------- |
| **Zero**    | present simple | present simple    | General truths, facts |
| **First**   | present simple | will + base verb  | Real / likely future  |
| **Second**  | past simple    | would + base verb | Unreal / hypothetical |

> 🏆 Conditionals conquered! You can now express truths, plans, and dreams in English. Next: **the passive voice**.', '# 📜 Summary: Conditionals

- **Zero conditional** = If + present simple, present simple. General truths and facts that always happen. _If you heat ice, it melts._
- **First conditional** = If + present simple, will + base verb. Real or likely future situations. _If it rains, we will stay inside._
- **Second conditional** = If + past simple, would + base verb. Unreal or hypothetical situations (present/future). _If I had more time, I would learn guitar._
- **"were" rule**: In the second conditional, use **were** for all persons with "be": _If I were you, I would apologise._
- **If-clause position**: if-clause first → **comma** after it; if-clause second → **no comma**.
- **Unless** = if … not. _Unless you hurry, you will miss the bus._ Never combine unless with a negative verb in the same clause.
- Key contrast: First conditional = realistic (_If I study, I''ll pass._) vs Second conditional = hypothetical (_If I studied for 20 hours, I would pass._).', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('2bd52d30-882a-5849-a561-66dad79c756d', 'english', 'The Passive Voice', 'Form (be + past participle), present and past simple passive, turning active into passive, and when/why to use it', '# 🛡️ The Passive Voice — Shield Your Subject

> 💡 "In active voice the subject attacks; in **passive voice** the subject is attacked. Choose your stance wisely."

## 🏰 What is the Passive Voice?

In an **active** sentence, the subject performs the action.
In a **passive** sentence, the subject **receives** the action.

- Active: _The chef **cooks** the meal._ (subject = the chef, doing the action)
- Passive: _The meal **is cooked** by the chef._ (subject = the meal, receiving the action)

The passive shifts the focus from **who** does something to **what** is done to something.

## ⚔️ Form: be + Past Participle

The core formula is always the same regardless of tense:

> **Subject + correct form of BE + past participle (+ by + agent)**

The **past participle** is the third form of a verb (e.g. _cook → cooked_, _write → written_, _build → built_).

| Verb  | Past Participle |
| ----- | --------------- |
| cook  | cooked          |
| write | written         |
| build | built           |
| make  | made            |
| find  | found           |

## ⚡ Present Simple Passive

Replace the active present simple with **is / are + past participle**.

- Active: _Workers **build** the bridge._ → Passive: _The bridge **is built** by workers._
- Active: _They **speak** French here._ → Passive: _French **is spoken** here._
- Active: _She **cleans** the room._ → Passive: _The room **is cleaned** by her._

> 🗡️ Use **is** for singular subjects and **are** for plural subjects.

## 🛡️ Past Simple Passive

Replace the active past simple with **was / were + past participle**.

- Active: _Someone **stole** my bike._ → Passive: _My bike **was stolen**._
- Active: _They **built** the castle in 1400._ → Passive: _The castle **was built** in 1400._
- Active: _The teachers **tested** the students._ → Passive: _The students **were tested** by the teachers._

> 🗡️ Use **was** for singular subjects and **were** for plural subjects.

## 🔮 Turning Active into Passive — Step by Step

Follow these three steps every time:

1. Move the **object** of the active sentence to the **subject** position.
2. Put the verb **be** in the correct tense (is/are or was/were).
3. Add the **past participle** of the main verb.
4. (Optional) Add **by + the original subject** as the agent.

**Example:**

- Active: _Amina **wrote** the report._
- Step 1: _The report …_ (object → subject)
- Step 2: _The report **was** …_ (past simple passive)
- Step 3: _The report **was written** …_ (past participle of write)
- Step 4: _The report **was written by Amina**._ (add agent)

## 🧪 When / Why We Use the Passive

We prefer the passive when:

- The **agent is unknown**: _My wallet was stolen._
- The **agent is unimportant** or obvious: _Oil was discovered in the desert._
- We want to **focus on the result** or the object: _The Eiffel Tower was built in 1889._
- In **formal or scientific writing**: _The mixture was heated to 80°C._

> ⚠️ The **by + agent** phrase is often **omitted** when the agent is unknown, unimportant, or already obvious from context.

## 📐 Summary Table

| Tense          | Active                           | Passive                             |
| -------------- | -------------------------------- | ----------------------------------- |
| Present simple | _They grow rice here._           | _Rice **is grown** here._           |
| Past simple    | _They built the school in 1990._ | _The school **was built** in 1990._ |

> 🏆 You have mastered the passive shield! Next quest: **Reported Speech** — learn to pass messages like a ninja.', '# 📜 Summary: The Passive Voice

- **Passive form** = subject + **be** (correct tense) + **past participle** (+ by + agent).
- **Present simple passive**: is / are + past participle. _Rice **is grown** here._
- **Past simple passive**: was / were + past participle. _The castle **was built** in 1400._
- **Turning active → passive**: object becomes subject; keep the same tense with be; add past participle; "by + agent" is optional.
- **Use the passive** when the agent is unknown, unimportant, or when focus is on the result/object.
- **"by + agent"** is often omitted: _My bike was stolen._ (we don''t know who)
- Singular subject → **is / was**; plural subject → **are / were**.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', 'Reported Speech', 'Direct vs reported speech, reporting verbs, tense backshift, pronoun changes, time/place word changes, reported questions and commands', '# 🗣️ Reported Speech — The Messenger Ninja

> 💡 "A ninja never repeats words exactly — they adapt the message to its new context. That is reported speech."

## 🏰 Direct vs Reported Speech

**Direct speech** quotes the exact words, written inside quotation marks.
**Reported speech** (also called _indirect speech_) reports what someone said without quotation marks, usually introduced by a reporting verb.

- Direct: _She said, **"I am tired."**_
- Reported: _She said **that she was tired**._

Notice: the verb **am** changes to **was**, and the pronoun **I** changes to **she**.

## ⚔️ Reporting Verbs: say, tell, ask

The three most important reporting verbs are:

| Verb     | Pattern                                     | Example                                   |
| -------- | ------------------------------------------- | ----------------------------------------- |
| **say**  | say (that) + clause                         | _He **said** that he was hungry._         |
| **tell** | tell + person + (that) + clause             | _She **told** me that the test was easy._ |
| **ask**  | ask + (person) + if/whether / question word | _He **asked** if she was ready._          |

> ⚠️ **tell** always needs a person (tell _me_, tell _him_, tell _the class_). **say** never takes a direct object person (_say me_ is wrong).

## ⚡ Tense Backshift

When the reporting verb is in the **past** (said, told, asked), the tense of the reported clause shifts **one step back** into the past.

| Direct tense       | Reported tense  |
| ------------------ | --------------- |
| present simple     | past simple     |
| present continuous | past continuous |
| past simple        | past perfect    |
| present perfect    | past perfect    |
| will               | would           |
| can                | could           |
| may                | might           |

**Examples:**

- "I **live** in Tunis." → He said he **lived** in Tunis.
- "She **is sleeping**." → He said she **was sleeping**.
- "They **have arrived**." → She said they **had arrived**.
- "I **will help** you." → He said he **would help** me.
- "I **can swim**." → She said she **could swim**.

## 🛡️ Changes of Pronouns

Pronouns change to match the new speaker''s perspective.

- "**I** am happy." → She said **she** was happy.
- "**We** are leaving." → They said **they** were leaving.
- "Can **you** help **me**?" → She asked if **I** could help **her**.

> 🗡️ Always think: who is speaking and who is listening _now_, then adjust the pronouns.

## 🔮 Changes of Time and Place Words

Time and place expressions also shift when the context changes.

| Direct speech | Reported speech                     |
| ------------- | ----------------------------------- |
| now           | then                                |
| today         | that day                            |
| yesterday     | the day before / the previous day   |
| tomorrow      | the next day / the following day    |
| last week     | the week before / the previous week |
| next year     | the following year                  |
| here          | there                               |
| this          | that                                |
| these         | those                               |

- "I will call you **tomorrow**." → She said she would call me **the next day**.
- "We met **here** **today**." → He said they had met **there** **that day**.

## 🧪 Reported Questions

To report a question, remove the question marks and quotation marks, and **reverse the word order** back to normal (subject before verb).

**Wh-questions** use the question word:

- Direct: "**Where** does he live?" → Reported: _She asked **where he lived**._
- Direct: "**What** did you do?" → Reported: _He asked **what I had done**._

**Yes/No questions** use **if** or **whether**:

- Direct: "**Are** you ready?" → Reported: _She asked **if I was ready**._
- Direct: "**Do** you like music?" → Reported: _He asked **whether I liked** music._

> ⚠️ No auxiliary verb inversion in reported questions: _she asked where **he lived**_ (NOT _where did he live_).

## 📐 Reported Commands

Commands (imperatives) are reported with **tell / ask + person + to + infinitive** (affirmative) or **not to + infinitive** (negative).

- "**Open** the window!" → She **told** him **to open** the window.
- "**Don''t run** in the corridor!" → The teacher **told** the students **not to run** in the corridor.
- "**Please sit down.**" → She **asked** us **to sit down**.

> 🏆 You are now a Reported Speech master! One final quest remains: **Relative Clauses & Comparatives**.', '# 📜 Summary: Reported Speech

- **Direct speech** = exact words in quotes. **Reported speech** = no quotes, introduced by say/tell/ask + that/if/whether.
- **say (that)** — no person object. **tell + person (that)** — always needs a person. **ask + (person) + if/whether/wh-word**.
- **Tense backshift** (reporting verb in past): present simple → past simple; will → would; can → could; present perfect / past simple → past perfect.
- **Pronouns** change to match the new speaker''s perspective: "I" → he/she, "we" → they, etc.
- **Time/place words**: now → then; today → that day; tomorrow → the next day; yesterday → the day before; here → there.
- **Reported wh-questions**: ask + question word + subject + verb (normal order, no inversion, no "?").
- **Reported yes/no questions**: ask + if / whether + subject + verb.
- **Reported commands**: tell/ask + person + **to** + infinitive; negative → **not to** + infinitive.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', 'Relative Clauses & Comparatives', 'Defining relative clauses (who/which/that/whose/where), comparatives and superlatives of adjectives, as...as, and writing connectors', '# 🏆 Relative Clauses & Comparatives — The Final Combo

> 💡 "A great warrior uses every weapon in their arsenal. Relative clauses add precision; comparatives add power. Master both and your writing becomes unstoppable."

## 🏰 What is a Relative Clause?

A **defining relative clause** gives essential information about the noun it follows. Without it, the sentence would be unclear or incomplete. It is introduced by a **relative pronoun**.

- _The boy **who won the prize** is my brother._ (defines which boy)
- _The book **that she lent me** was fantastic._ (defines which book)

> ⚠️ A defining relative clause is NOT separated from the noun by a comma.

## ⚔️ Relative Pronouns: who, which, that, whose, where

| Pronoun   | Refers to           | Example                                              |
| --------- | ------------------- | ---------------------------------------------------- |
| **who**   | people              | _The teacher **who** inspired me retired last year._ |
| **which** | things / animals    | _The film **which** we watched was thrilling._       |
| **that**  | people or things    | _The city **that** I love most is Tunis._            |
| **whose** | possession (people) | _The girl **whose** bag was lost found it later._    |
| **where** | places              | _The school **where** I study has a great library._  |

> 🗡️ **whose** replaces a possessive: _The student whose phone rang …_ = the student''s phone rang.

## ⚡ Comparatives of Adjectives

We use comparatives to compare **two** things. The form depends on the adjective''s length:

**Short adjectives (one syllable, or two syllables ending in -y):**
Add **-er** (and **than** to introduce the second item).

| Adjective | Comparative  |
| --------- | ------------ |
| tall      | taller than  |
| fast      | faster than  |
| happy     | happier than |
| big       | bigger than  |

> 🗡️ Spelling rules: double the final consonant if the pattern is consonant–vowel–consonant (_big → bigger_); change -y to -ier (_happy → happier_).

**Long adjectives (two or more syllables, not ending in -y):**
Use **more … than**.

- _interesting → **more interesting than**_
- _beautiful → **more beautiful than**_
- _important → **more important than**_

## 🛡️ Superlatives of Adjectives

We use superlatives to compare **three or more** things and pick the top one. Use **the** before the superlative.

| Adjective   | Comparative      | Superlative          |
| ----------- | ---------------- | -------------------- |
| tall        | taller than      | the tallest          |
| fast        | faster than      | the fastest          |
| happy       | happier than     | the happiest         |
| big         | bigger than      | the biggest          |
| interesting | more interesting | the most interesting |
| beautiful   | more beautiful   | the most beautiful   |

_Tunis is **the largest** city in Tunisia._
_This is **the most difficult** question in the exam._

## 🔮 Irregular Comparatives and Superlatives

Some adjectives are completely irregular. You must memorise these:

| Adjective | Comparative            | Superlative             |
| --------- | ---------------------- | ----------------------- |
| good      | better than            | the best                |
| bad       | worse than             | the worst               |
| far       | farther / further than | the farthest / furthest |

_Her score is **better than** mine. His idea is **the best** of all._
_Traffic today is **worse than** yesterday. That was **the worst** film I have ever seen._

## 🧪 As … As (Equality)

To say two things are **equal**, use **as + adjective + as**:

- _Sami is **as tall as** his brother._ (they are the same height)
- _This exercise is **as difficult as** the last one._

For **inequality** (not equal), use **not as … as**:

- _This city is **not as big as** Tunis._

> ⚠️ The structure is always **as + adjective (base form) + as** — never use the comparative form inside this structure.

## 📐 Useful Writing Connectors

Good writing links ideas smoothly. Here are essential connectors you should use:

| Function           | Connectors                                             |
| ------------------ | ------------------------------------------------------ |
| Adding information | and, also, in addition, furthermore, moreover          |
| Contrasting        | but, however, although, even though, on the other hand |
| Giving a reason    | because, since, as                                     |
| Showing result     | so, therefore, as a result, consequently               |
| Giving an example  | for example, for instance, such as                     |
| Concluding         | in conclusion, to sum up, finally                      |

_He studied very hard; **therefore**, he passed the exam._
_**Although** the film was long, I enjoyed it._
_**In addition**, the school has a sports hall._

> 🏆 Congratulations, hero! You have completed the English grammar quest. Armed with tenses, passive, reported speech, relative clauses, comparatives, and connectors, you are ready for the national exam!', '# 📜 Summary: Relative Clauses & Comparatives

- **Defining relative clauses** give essential information about a noun. No comma before them.
  - **who** = people; **which** = things/animals; **that** = people or things; **whose** = possession; **where** = places.
- **Comparatives** compare two things: short adjectives add **-er than**; long adjectives use **more … than**.
  - Spelling: double consonant (_big → bigger_); -y → -ier (_happy → happier_).
- **Superlatives** pick the top from three or more: short adjectives add **-est**; long adjectives use **the most …**. Always use **the**.
- **Irregulars**: good → better → the best; bad → worse → the worst.
- **as … as** = equality (_as tall as_); **not as … as** = inequality. Always use the base adjective form inside.
- **Writing connectors**: adding (_also, furthermore_), contrasting (_however, although_), reason (_because, since_), result (_therefore, as a result_), example (_for example_), conclusion (_in conclusion_).', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c4f248a7-393a-5c6d-b4af-90311f1ae35d', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('080d7783-083d-5532-a30c-825175ef6d09', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Which sentence uses the present simple correctly to express a habit?', '[{"id":"a","text":"She is going to school every day."},{"id":"b","text":"She goes to school every day."},{"id":"c","text":"She go to school every day."},{"id":"d","text":"She has gone to school every day."}]'::jsonb, 'b', 'Habits use the present simple. With a third-person singular subject, add -s to the base verb: she goes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c8be484-cc52-575b-ac02-d7dd39f06af1', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Which time marker signals that the present continuous should be used?', '[{"id":"a","text":"every Monday"},{"id":"b","text":"usually"},{"id":"c","text":"at the moment"},{"id":"d","text":"twice a week"}]'::jsonb, 'c', '"At the moment" signals an action happening right now, which requires the present continuous (am/is/are + -ing).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('138d5e16-6d8d-5dde-8107-11d41bfa48e9', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Complete the sentence correctly: "Look! The children ___ in the garden."', '[{"id":"a","text":"play"},{"id":"b","text":"plays"},{"id":"c","text":"have played"},{"id":"d","text":"are playing"}]'::jsonb, 'd', '"Look!" is a key signal for the present continuous because it draws attention to an action happening right now. The correct form is are playing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d819986f-cfe2-53f8-bd3e-f76c9aa3e3a5', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Why is "I am knowing the answer" incorrect?', '[{"id":"a","text":"\"Know\" must take -s in the present."},{"id":"b","text":"\"Know\" is a stative verb and is not normally used in the continuous form."},{"id":"c","text":"The subject \"I\" requires \"is\" instead of \"am\"."},{"id":"d","text":"The continuous form requires \"was\" for the verb \"know\"."}]'::jsonb, 'b', 'Stative verbs like know, like, love, and want describe mental states, not actions. They are not used in the continuous form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e4014e1-cd1d-5dcc-aac5-f44926ed20ed', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'What is the correct negative form of "She plays tennis" in the present simple?', '[{"id":"a","text":"She isn''t playing tennis."},{"id":"b","text":"She doesn''t plays tennis."},{"id":"c","text":"She doesn''t play tennis."},{"id":"d","text":"She don''t play tennis."}]'::jsonb, 'c', 'The present simple negative uses doesn''t (does not) + the base verb for he/she/it. The main verb keeps its base form: doesn''t play.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b8bbba1-76cd-5943-aa66-9d9da0f72492', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', 'Practice: simple or continuous?', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7241ee79-462b-5b3a-984c-eea640002fb0', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Choose the correct form: "She ___ to school every day."', '[{"id":"a","text":"is going"},{"id":"b","text":"go"},{"id":"c","text":"goes"},{"id":"d","text":"going"}]'::jsonb, 'c', '"every day" signals a habit, so we use the present simple with -es: she goes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a63341f-b75c-5f33-9964-f0a5e371d967', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Complete: "Look! The baby ___."', '[{"id":"a","text":"cries"},{"id":"b","text":"cry"},{"id":"c","text":"is crying"},{"id":"d","text":"cried"}]'::jsonb, 'c', '"Look!" signals an action happening now, so we use the present continuous: is crying.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43bd124a-3273-5b3d-babe-7c21c893d954', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Which word signals the present simple?', '[{"id":"a","text":"usually"},{"id":"b","text":"now"},{"id":"c","text":"at the moment"},{"id":"d","text":"Look!"}]'::jsonb, 'a', 'Adverbs of frequency such as "usually" signal a habit (present simple).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4629643-cb37-5769-8cef-57760b3611f9', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Complete: "He ___ football on Sundays."', '[{"id":"a","text":"play"},{"id":"b","text":"plays"},{"id":"c","text":"is play"},{"id":"d","text":"playing"}]'::jsonb, 'b', 'Third person singular in the present simple takes -s: he plays.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('499dffeb-77ba-571a-a272-ef6b68e30622', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Complete: "They ___ TV at the moment."', '[{"id":"a","text":"watch"},{"id":"b","text":"are watching"},{"id":"c","text":"watches"},{"id":"d","text":"is watching"}]'::jsonb, 'b', '"at the moment" signals now, so we use the present continuous with the plural subject they: are watching.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5481854-86d1-56f3-8ac1-c1496af746ac', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Choose the correct sentence:', '[{"id":"a","text":"I know the answer."},{"id":"b","text":"I am knowing the answer."},{"id":"c","text":"I knows the answer."},{"id":"d","text":"I am know the answer."}]'::jsonb, 'a', '"know" is a stative verb, so it is not used in the continuous: I know the answer.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('458c297a-6ea2-522c-9a6c-6dc0c6c7267b', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', '⚔️ Boss: master the present', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d8b38f06-1764-5f19-ba99-8f0fd06fd79b', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Complete: "I can''t talk now, I ___ dinner."', '[{"id":"a","text":"cook"},{"id":"b","text":"cooks"},{"id":"c","text":"am cooking"},{"id":"d","text":"cooked"}]'::jsonb, 'c', '"now" signals an action in progress, so we use the present continuous: I am cooking dinner.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('620f8003-045f-50cd-a9f5-2e24398d3bc5', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Choose the correct form: "Water ___ at 100 degrees."', '[{"id":"a","text":"boils"},{"id":"b","text":"is boiling"},{"id":"c","text":"boil"},{"id":"d","text":"are boiling"}]'::jsonb, 'a', 'This is a general truth, so we use the present simple: water boils at 100 degrees.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('535f555e-00ec-541c-9430-c8c68f6f8bb0', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Choose the correct negative: "She ___ coffee."', '[{"id":"a","text":"don''t drink"},{"id":"b","text":"isn''t drink"},{"id":"c","text":"not drinks"},{"id":"d","text":"doesn''t drink"}]'::jsonb, 'd', 'Present simple negative for he/she/it uses doesn''t + base verb: she doesn''t drink coffee.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71117f1e-36c4-5a8e-b723-9dbc88418bf1', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Complete the question: "___ they live in Tunis?"', '[{"id":"a","text":"Does"},{"id":"b","text":"Do"},{"id":"c","text":"Are"},{"id":"d","text":"Is"}]'::jsonb, 'b', 'Present simple questions with "they" use Do + subject + base verb: Do they live...?', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc94054e-1446-5d04-8e8c-221f38cdcb9d', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Complete: "Be quiet! The students ___ a test right now."', '[{"id":"a","text":"take"},{"id":"b","text":"takes"},{"id":"c","text":"is taking"},{"id":"d","text":"are taking"}]'::jsonb, 'd', '"right now" signals an action in progress; with the plural subject students we use are + taking.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90a789f4-e6c1-56be-86ef-0e8dd1a6eace', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Choose the correct sentence:', '[{"id":"a","text":"This cake tastes delicious."},{"id":"b","text":"This cake is tasting delicious."},{"id":"c","text":"This cake taste delicious."},{"id":"d","text":"This cake are tasting delicious."}]'::jsonb, 'a', '"taste" (= have a flavour) is stative here, so we use the present simple: the cake tastes delicious.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5a7783a2-f424-5be0-b07f-8bed19499adb', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', '👑 Elite Challenge: Precision Tenses', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('86f3a7c0-5851-570f-9244-5836c0bd3430', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'Which sentence is grammatically correct?', '[{"id":"a","text":"She has been waiting for two hours."},{"id":"b","text":"She is waiting since two hours."},{"id":"c","text":"She waits for two hours already."},{"id":"d","text":"She has waited since two hours."}]'::jsonb, 'a', 'Use the present perfect continuous (have/has been + -ing) for an action that started in the past and is still ongoing. ''For'' introduces a period of time (two hours), and ''since'' introduces a point in time (since 8 a.m.) — mixing ''since'' with a period (options b, d) is a classic error. Option c uses the wrong tense entirely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('496b9bfb-62c9-5779-bfb6-c7155592c344', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'The chef ___ the soup to check the salt, and it ___ wonderful. Choose the correct pair.', '[{"id":"a","text":"is tasting / tastes"},{"id":"b","text":"tastes / is tasting"},{"id":"c","text":"is tasting / is tasting"},{"id":"d","text":"tastes / tastes"}]'::jsonb, 'a', 'The verb ''taste'' has two uses: as a dynamic verb meaning ''to sample'' (an action the chef performs deliberately — present continuous is correct), and as a stative verb meaning ''to have a flavour'' (a state — present simple is correct). ''Is tasting / tastes'' captures both uses precisely.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40ef29e0-5fdd-59eb-bfc4-e34d75b19024', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'He ___ three novels this year, and his publisher is very pleased. Choose the correct form.', '[{"id":"a","text":"has been writing"},{"id":"b","text":"has written"},{"id":"c","text":"is writing"},{"id":"d","text":"writes"}]'::jsonb, 'b', 'When the focus is on a completed, countable result (three finished novels), use the present perfect simple (has written). The present perfect continuous (has been writing) emphasises duration and effort but does not confirm the novels are finished — it would be odd with a specific count of completed works.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21b7cf2a-d994-5d60-ae47-b0557b541a1a', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'You look completely exhausted. What ___ all morning?', '[{"id":"a","text":"have you done"},{"id":"b","text":"have you been doing"},{"id":"c","text":"are you doing"},{"id":"d","text":"do you do"}]'::jsonb, 'b', 'The present perfect continuous (have you been doing) is used when a recent, extended activity has a visible result in the present — here, the exhaustion. The present perfect simple (have you done) would focus on a completed achievement rather than the tiring process that caused the current state.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43209281-e502-55a8-af03-57de11357db3', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'Which sentence uses the verb ''think'' correctly?', '[{"id":"a","text":"I''m thinking you are absolutely right."},{"id":"b","text":"I am thinking that this is unfair."},{"id":"c","text":"I am thinking about your proposal right now."},{"id":"d","text":"She is thinking the answer is obvious."}]'::jsonb, 'c', '''Think'' is stative when it expresses an opinion (= believe), so options a, b, and d are wrong — you cannot say ''I am thinking (that)…'' to express a belief. However, ''think about'' describes an active mental process (= consider, reflect on), so the present continuous is correct in option c: ''I am thinking about your proposal right now.''', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c7fcb80-216b-51a9-aea0-1a7b93d56db9', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'They ___ on the project for six months, and they still have not finished it. Choose the correct form.', '[{"id":"a","text":"worked"},{"id":"b","text":"are working"},{"id":"c","text":"have worked"},{"id":"d","text":"have been working"}]'::jsonb, 'd', 'The present perfect continuous (have been working) is the right choice: it expresses a continuous activity that started six months ago and is still unfinished now — confirmed by ''still have not finished''. ''Have worked'' (present perfect simple) would suggest the work is complete, contradicting the sentence. ''Worked'' is past simple (no link to the present), and ''are working'' ignores the six-month duration.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('285d360a-8465-518f-990c-916004f4f3b5', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b5fe6ca3-0ae0-5d0a-becc-64b5e9be71c2', '285d360a-8465-518f-990c-916004f4f3b5', 'Which sentence uses the past simple correctly with an irregular verb?', '[{"id":"a","text":"She goed to the market yesterday."},{"id":"b","text":"She went to the market yesterday."},{"id":"c","text":"She has went to the market yesterday."},{"id":"d","text":"She was go to the market yesterday."}]'::jsonb, 'b', '"Go" is an irregular verb whose past simple form is "went". Time markers like "yesterday" confirm the past simple is needed.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bb52641-d98c-5fc5-a598-beb8dbb6ef71', '285d360a-8465-518f-990c-916004f4f3b5', 'What is the correct form for a past simple question with a regular verb?', '[{"id":"a","text":"Did she walked to school?"},{"id":"b","text":"Was she walk to school?"},{"id":"c","text":"Did she walk to school?"},{"id":"d","text":"Does she walked to school?"}]'::jsonb, 'c', 'Past simple questions use Did + subject + base verb. After Did, the main verb stays in its base form (no -ed).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('def1e0d2-88c6-5665-b598-fcbea95f96eb', '285d360a-8465-518f-990c-916004f4f3b5', 'Which structure correctly describes a background action interrupted by a shorter event in the past?', '[{"id":"a","text":"I cooked when the phone was ringing."},{"id":"b","text":"I was cooking when the phone rang."},{"id":"c","text":"I was cooking when the phone was ringing."},{"id":"d","text":"I cooked when the phone had rung."}]'::jsonb, 'b', 'The past continuous (was cooking) provides the background action; the past simple (rang) describes the shorter event that interrupted it.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cb5ed33-22c7-5edc-901c-0c090a8ffbf8', '285d360a-8465-518f-990c-916004f4f3b5', 'Which adverb is associated with the present perfect, NOT the past simple?', '[{"id":"a","text":"yesterday"},{"id":"b","text":"last year"},{"id":"c","text":"in 2020"},{"id":"d","text":"already"}]'::jsonb, 'd', '"Already" is a key adverb of the present perfect (have/has + past participle). "Yesterday", "last year", and "in 2020" all indicate a specific past time, so they go with the past simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f36a39c7-17e1-500d-a663-25676e3f151d', '285d360a-8465-518f-990c-916004f4f3b5', 'Which sentence correctly uses the present perfect?', '[{"id":"a","text":"She has visited Rome last summer."},{"id":"b","text":"She visited Rome yet."},{"id":"c","text":"She has never visited Rome."},{"id":"d","text":"She have visited Rome."}]'::jsonb, 'c', 'The present perfect (has + past participle) is used with "never" for a life experience at an unspecified time. A specific time like "last summer" would require the past simple instead.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', 'Practice: past tenses', 2, 60, 12, 'practice', 'admin', 1)
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
  ('bc3de6df-27c5-564f-a509-4feb9efb0100', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "She ___ to the market yesterday."', '[{"id":"a","text":"go"},{"id":"b","text":"went"},{"id":"c","text":"goed"},{"id":"d","text":"goes"}]'::jsonb, 'b', '"yesterday" signals the past simple. "go" is an irregular verb: go → went.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14609924-058c-5c85-b515-6e83bfa1c218', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "Have you ___ eaten couscous?"', '[{"id":"a","text":"yet"},{"id":"b","text":"ago"},{"id":"c","text":"ever"},{"id":"d","text":"yesterday"}]'::jsonb, 'c', '"ever" is used in present perfect questions to ask about life experience: Have you ever eaten...?', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13f53f19-669d-5bae-bb4e-fee06ce7d631', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "We ___ football when it started to rain."', '[{"id":"a","text":"played"},{"id":"b","text":"play"},{"id":"c","text":"have played"},{"id":"d","text":"were playing"}]'::jsonb, 'd', 'The football game was already in progress (background action) when the rain interrupted. Use past continuous: were playing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63809236-3326-5a22-bf77-ca09b2f1cd0c', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Choose the correct negative: "He ___ the test last Monday."', '[{"id":"a","text":"didn''t passed"},{"id":"b","text":"didn''t pass"},{"id":"c","text":"wasn''t pass"},{"id":"d","text":"hasn''t passed"}]'::jsonb, 'b', 'Past simple negative: didn''t + base verb. "last Monday" confirms past simple, not perfect.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6259cdd8-58d3-5794-8789-ae21fa623ed6', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "I ___ my homework. I can play now."', '[{"id":"a","text":"finished"},{"id":"b","text":"have just finished"},{"id":"c","text":"was finishing"},{"id":"d","text":"finish"}]'::jsonb, 'b', 'The action is very recent and its result matters now (I can play). Use present perfect with "just": have just finished.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c43f3d30-8f67-5e14-a3e2-445602f8671d', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Choose the correct sentence:', '[{"id":"a","text":"Did they go to Djerba last summer?"},{"id":"b","text":"Did they went to Djerba last summer?"},{"id":"c","text":"Have they gone to Djerba last summer?"},{"id":"d","text":"Were they go to Djerba last summer?"}]'::jsonb, 'a', '"last summer" is a specific past time, so use past simple. Questions: Did + subject + base verb. Never add -ed/-en after did.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('870d7346-31c1-546f-8e25-ad1a12362ea7', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', '⚔️ Boss: conquer the past', 3, 120, 30, 'boss', 'admin', 2)
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
  ('a79183ff-96f8-5044-a92c-581978d8d1c9', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "While my sister ___, I washed the dishes."', '[{"id":"a","text":"slept"},{"id":"b","text":"sleeps"},{"id":"c","text":"was sleeping"},{"id":"d","text":"has slept"}]'::jsonb, 'c', '"While" + past continuous gives the background action. "I washed" (past simple) is the completed action during that time: while she was sleeping.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('937bbd74-4c72-52a9-a129-ef162fceeeb5', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Which sentence is correct?', '[{"id":"a","text":"She visited Paris two years ago."},{"id":"b","text":"She has visited Paris two years ago."},{"id":"c","text":"She have visited Paris two years ago."},{"id":"d","text":"She was visited Paris two years ago."}]'::jsonb, 'a', '"two years ago" is a specific past time marker. Use past simple, not present perfect: she visited Paris two years ago.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67cf5732-4004-59fe-b4a5-bbc42565a024', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "___ the film started when you arrived?"', '[{"id":"a","text":"Did"},{"id":"b","text":"Has"},{"id":"c","text":"Was"},{"id":"d","text":"Were"}]'::jsonb, 'a', 'This asks about a completed event at a specific past moment. Past simple question: Did + subject + base verb. "Did the film start...?"', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75c9c3aa-c5c6-57b3-a6ae-72b8b7d071e4', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "I ___ never ___ sushi before. I tried it last night."', '[{"id":"a","text":"have ... eaten"},{"id":"b","text":"did ... eat"},{"id":"c","text":"had ... eaten"},{"id":"d","text":"was ... eating"}]'::jsonb, 'a', '"never" with present perfect describes a life experience up to now: I have never eaten sushi. The sentence then adds a specific past event (last night → past simple), showing the contrast.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dafd7523-eee4-517a-9606-6b8f9a72155f', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "Look — Salma ___ already ___ the report!"', '[{"id":"a","text":"did ... write"},{"id":"b","text":"has ... written"},{"id":"c","text":"was ... writing"},{"id":"d","text":"had ... written"}]'::jsonb, 'b', '"already" between have/has and the past participle signals the present perfect: has already written. The result is visible now (Look!).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37470435-85a2-505c-91ca-b117d0515933', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Choose the correct pair: "They ___ TV when the lights ___ out."', '[{"id":"a","text":"watched ... were going"},{"id":"b","text":"were watching ... went"},{"id":"c","text":"have watched ... went"},{"id":"d","text":"were watching ... were going"}]'::jsonb, 'b', 'Past continuous (were watching) = background in progress; past simple (went) = the sudden interrupting event. This is the classic when-pattern.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('46cd64a1-c660-59b3-9588-78efe0da7594', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', '👑 Elite Challenge: Mastering Time Sequences', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('fe75d1d4-1b37-5ee0-bbb4-a75f8fe2fc53', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "By the time the guests arrived, Yasmine ___ all the food."', '[{"id":"a","text":"prepared"},{"id":"b","text":"was preparing"},{"id":"c","text":"had prepared"},{"id":"d","text":"has prepared"}]'::jsonb, 'c', '"By the time" signals that one past action was completed before another past event. The past perfect (had prepared) is required: Yasmine finished the food first, then the guests arrived. Past simple (prepared) ignores the sequence; past continuous (was preparing) implies it was unfinished; present perfect (has prepared) is impossible in a past context.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cedab619-4c56-5ca3-ab85-a95e25b97113', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Which sentence contains a grammatical error?', '[{"id":"a","text":"He used to walk to school every day."},{"id":"b","text":"She used to be afraid of spiders."},{"id":"c","text":"They used to played football on Fridays."},{"id":"d","text":"We used to live near the sea."}]'::jsonb, 'c', '"Used to" is always followed by the base form (infinitive without to is already included in the structure: used to + base verb). "Played" is a past form — writing "used to played" double-marks the past. The correct form is "used to play". Options a, b, and d all correctly use "used to" + base verb.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4dd4df16-b2ea-5580-ae08-b16f11a0a65b', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "When I ___ to the station, the train already ___ ."', '[{"id":"a","text":"got / had left"},{"id":"b","text":"had got / left"},{"id":"c","text":"was getting / left"},{"id":"d","text":"got / has left"}]'::jsonb, 'a', 'Two past events in sequence: arriving at the station (past simple: got) is the reference point; the train leaving happened before that (past perfect: had left). "Already" reinforces the earlier completion. Option b reverses the logic — the arrival cannot precede itself with past perfect here. Option c is wrong because "getting" implies the journey was still in progress when the train left. Option d mixes past simple with present perfect, which is grammatically impossible.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42b58ca1-24dc-5af1-a693-9b4143086c60', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "He ___ the report three times before he ___ it to his teacher."', '[{"id":"a","text":"checked / submitted"},{"id":"b","text":"had checked / submitted"},{"id":"c","text":"was checking / had submitted"},{"id":"d","text":"has checked / submitted"}]'::jsonb, 'b', 'The checking happened before the submitting — both are past events, but checking is the earlier one. The past perfect (had checked) marks it as prior; the past simple (submitted) marks the later reference event. Option a (both past simple) is grammatically possible in informal speech but loses the precise sequence signal required at exam level. Option c wrongly uses past perfect for the later action. Option d wrongly uses present perfect in a fully past context.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1a7eb87-ac87-505d-a32e-4d0f771fc4a9', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Identify the ONE correct sentence.', '[{"id":"a","text":"While the phone rang, I was cooking dinner."},{"id":"b","text":"When I was having a bath, the doorbell rang."},{"id":"c","text":"While I arrived, she was leaving the room."},{"id":"d","text":"When she was writing, she was finishing the letter."}]'::jsonb, 'b', 'Option b is correct: "was having" (past continuous) provides the ongoing background; "rang" (past simple) is the short interrupting event — the classic when-pattern. Option a is wrong because "rang" is a short punctual verb and cannot be the background of a "while" clause; it should be "when the phone rang, I was cooking". Option c is wrong because "arrive" is punctual and cannot be a "while" background. Option d is wrong because "finish" describes a completed result and cannot be past continuous alongside another continuous action.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5e159b5-bd31-599c-86e1-07e774c6fcbd', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "The police discovered that the thief ___ through the back window and ___ the safe before anyone ___ the alarm."', '[{"id":"a","text":"climbed / emptied / raised"},{"id":"b","text":"had climbed / had emptied / raised"},{"id":"c","text":"was climbing / emptied / had raised"},{"id":"d","text":"had climbed / was emptying / raised"}]'::jsonb, 'b', 'The thief''s actions (climbing in, emptying the safe) both occurred before the alarm was raised — the reference past event. Past perfect (had climbed, had emptied) correctly places these two earlier actions; past simple (raised) marks the later reference point. Option a loses the sequence entirely. Option c wrongly puts "had raised" on the alarm, reversing the logic — the alarm came last, not first. Option d uses past continuous for "emptying", implying it was still in progress when the alarm went off, which contradicts the "before" clause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('216cae02-7987-5531-b3fa-6af92e75e33d', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7b983cd9-c2c0-5a9c-a73c-ac98bf9d0808', '216cae02-7987-5531-b3fa-6af92e75e33d', 'The phone is ringing and you decide to answer it right now. Which sentence is correct?', '[{"id":"a","text":"I am going to answer it."},{"id":"b","text":"I will answer it."},{"id":"c","text":"I am answering it tomorrow."},{"id":"d","text":"I answer it."}]'::jsonb, 'b', '"Will" is used for a spontaneous decision made at the moment of speaking. You have just decided to answer the phone right now.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d65ae3ef-84c2-5f87-b631-5f91de5eef1f', '216cae02-7987-5531-b3fa-6af92e75e33d', 'You can see dark clouds gathering overhead. Which sentence correctly expresses an evidence-based prediction?', '[{"id":"a","text":"I think it will rain."},{"id":"b","text":"It rains soon."},{"id":"c","text":"It is going to rain."},{"id":"d","text":"It will have rained."}]'::jsonb, 'c', '"Be going to" is used for predictions based on visible present evidence. The dark clouds you can see right now are the evidence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ceda0cf-76cc-5320-b521-1dbaaf81ff83', '216cae02-7987-5531-b3fa-6af92e75e33d', 'What is the correct negative form of "will" in a sentence?', '[{"id":"a","text":"She willn''t come."},{"id":"b","text":"She won''t come."},{"id":"c","text":"She doesn''t will come."},{"id":"d","text":"She isn''t will come."}]'::jsonb, 'b', 'The negative of will is will not, contracted to won''t. No auxiliary verb like do or be is added alongside will.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d607352b-8809-5647-8ea5-22f2ffea5f51', '216cae02-7987-5531-b3fa-6af92e75e33d', 'Which sentence correctly uses a time clause with a future meaning?', '[{"id":"a","text":"Call me when you will arrive."},{"id":"b","text":"Call me when you arrive."},{"id":"c","text":"Call me when you are arriving."},{"id":"d","text":"Call me when you arrived."}]'::jsonb, 'b', 'After time conjunctions such as when, as soon as, before, after, and until in a future sentence, use the present simple, not will.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b0082a8-9de5-5939-9428-c20ddaf4909d', '216cae02-7987-5531-b3fa-6af92e75e33d', 'Which form expresses a fixed, confirmed arrangement already in your diary?', '[{"id":"a","text":"I will meet the doctor at 9 a.m. tomorrow."},{"id":"b","text":"I meet the doctor at 9 a.m. tomorrow."},{"id":"c","text":"I am meeting the doctor at 9 a.m. tomorrow."},{"id":"d","text":"I was meeting the doctor at 9 a.m. tomorrow."}]'::jsonb, 'c', 'The present continuous is used for future events that are already arranged and confirmed with others, such as a diary appointment.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0ac40b31-da66-5e9a-b82f-2414438a00c5', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', 'Practice: will, going to, or present continuous?', 2, 60, 12, 'practice', 'admin', 1)
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
  ('12f16b47-6a4c-5487-99e2-f1f5e592d512', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'The phone is ringing. Complete: "Don''t worry — I ___ it!"', '[{"id":"a","text":"am going to answer"},{"id":"b","text":"answer"},{"id":"c","text":"will answer"},{"id":"d","text":"am answering"}]'::jsonb, 'c', 'The decision is made at the moment of speaking (spontaneous). Use will: I''ll answer it!', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ba459b0-dc9e-57f9-9175-81ba6c0d490d', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Look at those black clouds! Complete: "It ___ rain."', '[{"id":"a","text":"will"},{"id":"b","text":"is"},{"id":"c","text":"rains"},{"id":"d","text":"is going to"}]'::jsonb, 'd', 'The visible evidence (black clouds) calls for "be going to": it is going to rain.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc58c470-1c5f-570b-b347-e040a8aaabbf', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Which time marker does NOT typically go with future tenses?', '[{"id":"a","text":"next week"},{"id":"b","text":"tomorrow"},{"id":"c","text":"yesterday"},{"id":"d","text":"soon"}]'::jsonb, 'c', '"Yesterday" refers to the past, not the future. "Next week", "tomorrow", and "soon" are future time markers.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea5d79b1-f11c-501e-b3aa-b94d4fb6c94f', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Complete the time clause: "I will call you when I ___ home."', '[{"id":"a","text":"get"},{"id":"b","text":"will get"},{"id":"c","text":"am getting"},{"id":"d","text":"got"}]'::jsonb, 'a', 'After time conjunctions (when, as soon as, before, after, until) in a future sentence, use the present simple — not will: when I get home.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f82a2c0b-e513-5770-8b2a-024116d6b3a1', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Choose the correct sentence about a plan already decided:', '[{"id":"a","text":"We will visit Djerba next summer."},{"id":"b","text":"We visit Djerba next summer."},{"id":"c","text":"We visited Djerba next summer."},{"id":"d","text":"We are going to visit Djerba next summer."}]'::jsonb, 'd', 'A plan decided before speaking uses "be going to": we are going to visit Djerba next summer.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('389a214c-d24f-5aff-b8e6-447a45ed35ed', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Complete: "I ___ the dentist at 3 p.m. tomorrow." (appointment confirmed)', '[{"id":"a","text":"will see"},{"id":"b","text":"am seeing"},{"id":"c","text":"see"},{"id":"d","text":"am going to see"}]'::jsonb, 'b', 'A confirmed arrangement with a specific time uses the present continuous: I am seeing the dentist at 3 p.m. tomorrow.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('efb66754-8009-5a3d-995a-6b71e9cf5537', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', '⚔️ Boss: command the future', 3, 120, 30, 'boss', 'admin', 2)
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
  ('dbf15f17-58e6-5ab5-b012-27b2368c4ca5', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'A friend is cold. You spontaneously decide to help. Choose the best sentence:', '[{"id":"a","text":"I am going to close the window."},{"id":"b","text":"I close the window."},{"id":"c","text":"I''ll close the window."},{"id":"d","text":"I am closing the window."}]'::jsonb, 'c', 'A spontaneous decision (offer made in the moment) uses will (I''ll). "Going to" would be used if you had planned it beforehand.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8ad51f2-0d2f-5a46-ba24-3e956beb4367', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Complete: "As soon as she ___, we will start eating."', '[{"id":"a","text":"arrives"},{"id":"b","text":"will arrive"},{"id":"c","text":"is arriving"},{"id":"d","text":"arrived"}]'::jsonb, 'a', 'After "as soon as" in a future sentence, use the present simple (not will): as soon as she arrives.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7a6d78a-35e1-5568-a53b-3be72295890c', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Choose the correct form: "Look at that cyclist — he ___ fall!"', '[{"id":"a","text":"will"},{"id":"b","text":"is going to"},{"id":"c","text":"would"},{"id":"d","text":"falls"}]'::jsonb, 'b', 'The cyclist is visibly about to fall (present evidence), so use "be going to": he is going to fall.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc5f7dad-9d09-5117-ba74-0cdae2c753c4', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Complete: "I think robots ___ do most jobs in the future."', '[{"id":"a","text":"will"},{"id":"b","text":"are going to"},{"id":"c","text":"are"},{"id":"d","text":"would"}]'::jsonb, 'a', '"I think" signals a personal opinion about the future (no visible evidence). Use will: robots will do most jobs.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3748c61-938a-5781-a6e3-e94630c69381', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Which sentence correctly uses the present continuous for a future arrangement?', '[{"id":"a","text":"They will flying to Paris next Friday."},{"id":"b","text":"They are flying to Paris next Friday. (tickets booked)"},{"id":"c","text":"They fly to Paris next Friday."},{"id":"d","text":"They going to fly to Paris next Friday."}]'::jsonb, 'b', 'A confirmed, fixed arrangement uses the present continuous: they are flying to Paris next Friday. Option b is ungrammatical (will + -ing), c is present simple with a future marker (possible but less natural for a fixed plan), d is missing the auxiliary "are".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('723d0846-dcc9-57dc-a8d5-3f9a581abd90', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Complete both blanks: "She ___ not work tomorrow because she ___ to see a doctor." (arrangement already made)', '[{"id":"a","text":"is ... will go"},{"id":"b","text":"won''t ... will"},{"id":"c","text":"would ... goes"},{"id":"d","text":"will ... is going"}]'::jsonb, 'd', '"will not work" (won''t work) is a prediction/decision; "is going to see" reflects a pre-made plan. "will ... is going" correctly uses will for the first blank and be going to for the second.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('86c16cd5-392b-5ab2-af1c-2952deb88e38', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', '👑 Elite Challenge: Master of Future Forms', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('20e1e342-c46f-5418-9778-f7583673ec41', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Read the timetable notice carefully: "The school bus ___ at 7:15 every morning next term — students must be at the stop two minutes early." Which form is best?', '[{"id":"a","text":"will leave"},{"id":"b","text":"leaves"},{"id":"c","text":"is going to leave"},{"id":"d","text":"is leaving"}]'::jsonb, 'b', 'A fixed, recurring timetable event (official schedule for a vehicle or institution) uses the present simple for the future. "Leaves" is correct. "Will leave" expresses a spontaneous decision or prediction. "Is going to leave" expresses a pre-made personal intention, not a published schedule. "Is leaving" is for a personal confirmed arrangement, not an impersonal timetable.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd27901a-06cb-5aa5-b6ff-932cc32ad2bd', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Sami calls his mother from the kitchen: the tap has just burst and water is flooding the floor. He shouts: "Mum! The kitchen ___ flood — there''s water everywhere!" Which form is best?', '[{"id":"a","text":"will"},{"id":"b","text":"would"},{"id":"c","text":"is going to"},{"id":"d","text":"is"}]'::jsonb, 'c', 'Water is already spreading — this is a prediction based on immediate visible evidence, which requires "be going to": the kitchen is going to flood. "Will" signals an opinion-based prediction with no direct evidence in front of the speaker. "Would" is conditional or past. "Is" alone describes a present state, not an imminent future event.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd4a4ebb-6763-5e29-a105-05d6d3c4f871', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Leila has already booked the hall, sent invitations, and confirmed the caterer. She tells a friend: "I ___ organise a surprise party for my brother on Saturday." Which form is best?', '[{"id":"a","text":"will organise"},{"id":"b","text":"am going to organise"},{"id":"c","text":"organise"},{"id":"d","text":"am organising"}]'::jsonb, 'd', 'The event is fully arranged with other people (hall booked, invitations sent, caterer confirmed) — this is a fixed future arrangement, which calls for the present continuous: I am organising a surprise party. "Going to" expresses a pre-made intention but lacks the emphasis on a confirmed, multi-party arrangement. "Will organise" would suggest she is deciding at this very moment. The present simple "organise" does not suit a personal one-off future event.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4416d439-5708-525c-ab80-c0cf44fcea23', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Complete the first conditional: "If the government invests more in education, students ___ better results in national exams."', '[{"id":"a","text":"achieve"},{"id":"b","text":"are going to achieve"},{"id":"c","text":"will achieve"},{"id":"d","text":"are achieving"}]'::jsonb, 'c', 'In a first conditional sentence (real possibility in the future), the if-clause uses the present simple and the main clause uses "will + base verb": students will achieve. "Are going to achieve" is not standard in the result clause of a first conditional — it signals a pre-made intention, not a future consequence of a condition. "Achieve" (present simple) would make this a zero conditional (always-true fact). "Are achieving" is present continuous and does not express a future result.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('169e3347-7224-50c0-8f7d-5e3e2e95772a', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Choose the correct words for BOTH blanks: "She ___ not come to school tomorrow; she has an appointment because she ___ see the doctor at 10 a.m."', '[{"id":"a","text":"is ... will"},{"id":"b","text":"will ... is going to"},{"id":"c","text":"would ... is going to"},{"id":"d","text":"will ... will"}]'::jsonb, 'b', '"Will not come" (won''t come) expresses the consequence/decision about tomorrow, so "will" fits the first blank. "Is going to see" reflects a pre-arranged appointment (already booked), so "is going to" fits the second blank. Option a puts "is" in the first blank, making a present-continuous form that implies she is not currently at school — wrong in context. Option c uses conditional "would" in the first blank — unwarranted here. Option d uses "will" for both, treating the appointment as a spontaneous decision rather than an existing arrangement.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b5844a2-8c40-5cb9-a0a5-f526268f5281', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Spot the one grammatically AND contextually correct sentence about a personal future plan:', '[{"id":"a","text":"When I will finish the concours, I will take a long holiday."},{"id":"b","text":"I am going to take a long holiday as soon as I will finish the concours."},{"id":"c","text":"I am going to take a long holiday as soon as I finish the concours."},{"id":"d","text":"I will taking a long holiday when I finish the concours."}]'::jsonb, 'c', 'After future time conjunctions (when, as soon as, before, after, until), English requires the present simple — never will. The main clause correctly uses "am going to take" to express a pre-made personal intention. Option a wrongly uses "will finish" after "when". Option b uses "am going to take" correctly but then breaks the rule with "will finish" after "as soon as". Option d is ungrammatical: "will taking" is not a valid verb form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d1c87325-095a-555e-95d3-138f47124355', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'Which sentence contains a correctly formed modal verb?', '[{"id":"a","text":"She cans swim very well."},{"id":"b","text":"He musts leave now."},{"id":"c","text":"They should to study harder."},{"id":"d","text":"You must wear a seatbelt."}]'::jsonb, 'd', 'Modal verbs are followed directly by the base verb with no -s, no -ed, and no "to". "You must wear" is the only correctly formed option.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18298070-040f-5ac3-b119-9cb6fb720fa2', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'Which sentence correctly uses "should" to give advice?', '[{"id":"a","text":"You should to eat more vegetables."},{"id":"b","text":"You should eating more vegetables."},{"id":"c","text":"You should eat more vegetables."},{"id":"d","text":"You shoulds eat more vegetables."}]'::jsonb, 'c', '"Should" is followed by the base verb with no "to" and no -ing. The correct form is "should eat".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fee0d9a-a27d-5059-b62b-3e5c40b1b7ed', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'Which modal expresses a polite request, more formal than "can"?', '[{"id":"a","text":"must"},{"id":"b","text":"should"},{"id":"c","text":"could"},{"id":"d","text":"may not"}]'::jsonb, 'c', '"Could" is used for polite requests and is considered more polite than "can". For example: "Could you open the window?"', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a682336a-8cac-55fe-98ed-d13e41b90c21', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'What is the difference between "may" and "might" when expressing possibility?', '[{"id":"a","text":"\"May\" refers to the past; \"might\" refers to the future."},{"id":"b","text":"\"May\" is more certain than \"might\"; \"might\" suggests less certainty."},{"id":"c","text":"\"Might\" is more certain than \"may\"."},{"id":"d","text":"They cannot be used interchangeably for possibility."}]'::jsonb, 'b', 'Both "may" and "might" express possibility, but "might" suggests even less certainty than "may". In practice they can often be used interchangeably.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10cdbbe6-7c81-509f-9107-c3f8ea0bc615', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'What is the key difference between "mustn''t" and "don''t have to"?', '[{"id":"a","text":"They mean the same thing: neither action is required."},{"id":"b","text":"\"Mustn''t\" means prohibition; \"don''t have to\" means there is no obligation."},{"id":"c","text":"\"Mustn''t\" is polite; \"don''t have to\" is rude."},{"id":"d","text":"\"Don''t have to\" means it is forbidden; \"mustn''t\" means it is optional."}]'::jsonb, 'b', '"Mustn''t" forbids an action (you are not allowed). "Don''t have to" means the action is not required but you are free to choose.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d33dfa7f-2d01-5e1c-aac3-8c969ee05d93', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', 'Practice: modal verbs', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a14eb5d9-6d29-5415-8ec9-f1557b3e5161', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Choose the correct form: "She ___ play the piano very well."', '[{"id":"a","text":"can"},{"id":"b","text":"cans"},{"id":"c","text":"can to"},{"id":"d","text":"is can"}]'::jsonb, 'a', 'Modals never take -s or -to before the base verb: she can play. "Cans" and "can to" are both wrong.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a039206b-03d4-5fc9-86ad-75e0019c4a70', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Choose the best advice: "You look tired. You ___ go to bed early."', '[{"id":"a","text":"should"},{"id":"b","text":"must not"},{"id":"c","text":"could not"},{"id":"d","text":"may not"}]'::jsonb, 'a', '"Should" expresses advice: you should go to bed early. "Must not" and "may not" express prohibition — not advice.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e22eee7-36b9-5f3a-8e0f-5333d3b76fdf', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Complete: "Students ___ wear a uniform at school. It is the rule."', '[{"id":"a","text":"have to"},{"id":"b","text":"should"},{"id":"c","text":"might"},{"id":"d","text":"could"}]'::jsonb, 'a', '"Have to" expresses external obligation (a rule set by authority): students have to wear a uniform.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e66eafa-708f-5de1-a6cc-2921d6e02ffc', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Complete: "___ I use your dictionary, please?" (informal permission)', '[{"id":"a","text":"Should"},{"id":"b","text":"Can"},{"id":"c","text":"Must"},{"id":"d","text":"Might"}]'::jsonb, 'b', '"Can" is used for informal permission requests: Can I use your dictionary? "Could" would be more polite; "May" more formal.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01ffd3bb-6105-5323-92a1-3cc14b8348db', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Which sentence means you are NOT allowed to do something?', '[{"id":"a","text":"You mustn''t smoke here."},{"id":"b","text":"You don''t have to come."},{"id":"c","text":"You should rest."},{"id":"d","text":"You might stay."}]'::jsonb, 'a', '"Mustn''t" expresses prohibition — you are not allowed to smoke here. "Don''t have to" simply means it is not necessary.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4455f0a-1f51-5dad-ad63-3e592ebb5d36', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Complete: "I''m not sure, but she ___ be at the library."', '[{"id":"a","text":"must"},{"id":"b","text":"should"},{"id":"c","text":"can''t"},{"id":"d","text":"might"}]'::jsonb, 'd', '"Might" expresses weak or uncertain possibility: she might be at the library. "Must" would be near certainty; "might" fits "I''m not sure".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5e9f70de-f505-5482-a231-2c5e52d2bb68', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', '⚔️ Boss: master the modals', 3, 120, 30, 'boss', 'admin', 2)
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
  ('59194e7b-1eac-57ca-935a-de51f43964ea', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Choose the grammatically correct sentence:', '[{"id":"a","text":"He musts leave now."},{"id":"b","text":"He must leave now."},{"id":"c","text":"He must to leave now."},{"id":"d","text":"He must leaves now."}]'::jsonb, 'b', 'Modals do not take -s, and "must" is not followed by "to". The correct form is modal + base verb: he must leave now.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2b8ba0d-7631-5805-8846-a5fa20b419c6', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Choose the most polite request:', '[{"id":"a","text":"Could you pass the salt, please?"},{"id":"b","text":"Can you pass the salt?"},{"id":"c","text":"Pass the salt."},{"id":"d","text":"You should pass the salt."}]'::jsonb, 'a', '"Could you... please?" is the most polite form for a request. "Can" is acceptable but less formal; "could" is more polite.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e6e3345-a167-528b-86c9-8f8012c051f7', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Complete: "When she was a child, she ___ speak French fluently."', '[{"id":"a","text":"can"},{"id":"b","text":"may"},{"id":"c","text":"could"},{"id":"d","text":"should"}]'::jsonb, 'c', '"Could" is the past form of "can" and expresses past ability: she could speak French fluently when she was a child.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68c353c4-5d65-5e6c-a162-99ffe1dfcef8', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Choose the correct sentence about formal permission:', '[{"id":"a","text":"Can I go to the toilet?"},{"id":"b","text":"May I leave the room, please?"},{"id":"c","text":"Must I go to the toilet?"},{"id":"d","text":"Should I leave the room?"}]'::jsonb, 'b', '"May I...?" is the formal way to ask for permission. "Can" is informal; "must" is for obligation; "should" is for advice.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('101b87bc-3422-5b24-b2e4-1cd2a0ca63ab', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'What is the difference between these two sentences? (1) "You mustn''t tell her." (2) "You don''t have to tell her."', '[{"id":"a","text":"They mean the same thing: it is not necessary."},{"id":"b","text":"(1) means it is forbidden; (2) means it is not necessary."},{"id":"c","text":"(1) means it is not necessary; (2) means it is forbidden."},{"id":"d","text":"Both mean you are not allowed."}]'::jsonb, 'b', '"Mustn''t" = prohibition (you are NOT allowed to tell her). "Don''t have to" = no obligation (you are free not to, but it''s your choice). These are opposite in meaning.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed4adc8e-de97-5a8f-a68f-5601a89daaa2', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Complete: "It''s getting dark. We ___ hurry, or we''ll miss the bus."', '[{"id":"a","text":"might not"},{"id":"b","text":"should"},{"id":"c","text":"don''t have to"},{"id":"d","text":"couldn''t"}]'::jsonb, 'b', '"Should" expresses a strong recommendation or advice — the right thing to do in the situation: we should hurry. "Might not" and "don''t have to" would weaken the urgency incorrectly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1ce03879-94cc-59c1-9b29-387f46b3cb17', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', '👑 Elite Challenge: Modal Mastery Under Pressure', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('3f3f291b-0ed5-5034-8ea2-007904302b91', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'Look at the context carefully. "There is thick smoke rising from the neighbour''s kitchen window." Which sentence expresses a logical deduction based on the evidence?', '[{"id":"a","text":"The food must be burning."},{"id":"b","text":"The food should be burning."},{"id":"c","text":"The food may burn."},{"id":"d","text":"The food can burn."}]'::jsonb, 'a', '"Must" is used for a strong logical deduction from evidence — the smoke is direct proof that something is burning. "Should" expresses expectation or advice, not deduction. "May burn" is a future possibility with no evidence base. "Can burn" states general ability, not a deduction about what is happening right now.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eba3fdd7-1b65-5e0b-a7d7-298e72c9e03a', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'Leila told her teacher she was in Tunis all day yesterday, but her classmate saw her in Sfax at exactly the same time. What is the only logical conclusion?', '[{"id":"a","text":"Leila might not have been telling the truth."},{"id":"b","text":"Leila can''t have been telling the truth."},{"id":"c","text":"Leila mustn''t have been telling the truth."},{"id":"d","text":"Leila shouldn''t have been telling the truth."}]'::jsonb, 'b', '"Can''t have" expresses a logical impossibility about the past — a person cannot be in two cities at once, so it is impossible that she was telling the truth. "Might not have" only suggests doubt, not certainty. "Mustn''t have" is not used for past deduction; "mustn''t" is a prohibition modal. "Shouldn''t have" expresses past criticism, not logical deduction.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ecf5bd5c-0f9d-5239-a6b2-06167c953a96', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'Your friend arrives at your door without warning. You say: "You ___ me you were coming! I would have cooked something."', '[{"id":"a","text":"must have told"},{"id":"b","text":"could tell"},{"id":"c","text":"should have told"},{"id":"d","text":"might have told"}]'::jsonb, 'c', '"Should have told" expresses past criticism or regret — the action did not happen, but it was the right thing to do. "Must have told" would mean you are deducing that the person did tell you (which contradicts the context). "Could tell" is present ability, not past. "Might have told" suggests only a weak past possibility, not the implied criticism in the speaker''s tone.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb70b1c9-47f1-5f87-af54-9173dbe7ab3e', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'The national exam results have not been published yet. Ali studied hard but the exam was very difficult. Which sentence is the most appropriate?', '[{"id":"a","text":"Ali must pass the exam."},{"id":"b","text":"Ali can''t pass the exam."},{"id":"c","text":"Ali should pass the exam."},{"id":"d","text":"Ali might pass the exam."}]'::jsonb, 'd', '"Might" expresses weak possibility — results are unknown and the outcome is uncertain (he studied hard but the exam was difficult). "Must" is used for strong logical deduction from clear evidence, which does not apply when the outcome is genuinely unknown. "Can''t" would mean it is logically impossible for him to pass, which contradicts his hard work. "Should" implies an expected or predictable outcome based on an established norm, but the added difficulty creates real uncertainty that "might" captures best.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8aeba267-0d13-5fa7-91bb-0e9a7697967e', '1ce03879-94cc-59c1-9b29-387f46b3cb17', '"The school regulations state that all pupils ___ arrive before 8:00 a.m. Latecomers will be sent to the headmaster." Which modal fits the context correctly?', '[{"id":"a","text":"have to"},{"id":"b","text":"must"},{"id":"c","text":"should"},{"id":"d","text":"may"}]'::jsonb, 'a', '"Have to" expresses external obligation — the rule comes from school regulations, an outside authority, not the speaker''s personal feeling. "Must" is used when the obligation comes from the speaker''s own will or authority (internal obligation). "Should" is advice or recommendation, not a binding rule. "May" expresses permission or possibility, not obligation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a452b60-51b7-5ddc-874e-12e6700c8005', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'She noticed the earlier train was still at the platform and chose to wait for her friend instead. She missed the award ceremony as a result. The best analysis of her situation is:', '[{"id":"a","text":"She could have taken the earlier train, but she chose not to."},{"id":"b","text":"She must have taken the earlier train to arrive on time."},{"id":"c","text":"She can''t have taken the earlier train."},{"id":"d","text":"She may take the earlier train if she hurries."}]'::jsonb, 'a', '"Could have" expresses a past possibility or option that existed but was not used — the train was there, the ability and opportunity were present, yet she chose not to act on them. "Must have taken" is a deduction that she did board the train, which contradicts the context. "Can''t have taken" implies it was impossible, also contradicted by the facts. "May take" is present or future possibility, not relevant to a past situation that has already concluded.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('390d080b-349c-538c-9250-acd59fd6c1c3', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'Which conditional form is used for general truths and scientific facts?', '[{"id":"a","text":"First conditional: if + present simple, will + base verb"},{"id":"b","text":"Zero conditional: if + present simple, present simple"},{"id":"c","text":"Second conditional: if + past simple, would + base verb"},{"id":"d","text":"Zero conditional: if + past simple, present simple"}]'::jsonb, 'b', 'The zero conditional (if + present simple, present simple) expresses facts and general truths where the result always follows the condition.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('462d9345-5c31-5111-8ce8-314de8fd5caa', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'What does the second conditional express?', '[{"id":"a","text":"A real and likely future situation"},{"id":"b","text":"A general scientific truth"},{"id":"c","text":"An imaginary or hypothetical situation in the present or future"},{"id":"d","text":"A completed past action"}]'::jsonb, 'c', 'The second conditional (if + past simple, would + base verb) describes situations that are unreal, imaginary, or unlikely right now.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da303622-b350-5b8b-9b6d-370d9728bb8e', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'Which sentence is a correctly formed first conditional?', '[{"id":"a","text":"If you will study hard, you will pass."},{"id":"b","text":"If you studied hard, you will pass."},{"id":"c","text":"If you study hard, you will pass."},{"id":"d","text":"If you study hard, you would pass."}]'::jsonb, 'c', 'The first conditional uses the present simple in the if-clause (never "will") and will + base verb in the main clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('902f8a7c-6687-5818-814b-a17e2eef1444', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'In formal/standard English, which form of "be" is used in the if-clause of a second conditional?', '[{"id":"a","text":"\"was\" for all persons"},{"id":"b","text":"\"is\" for all persons"},{"id":"c","text":"\"were\" for all persons"},{"id":"d","text":"\"are\" for all persons"}]'::jsonb, 'c', 'In formal and standard English, the second conditional uses "were" for all persons in the if-clause: "If I were you, I would apologise."', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32d6d026-1f7e-5d8d-9fea-2141ee659a6a', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'What does "unless" mean in a conditional sentence?', '[{"id":"a","text":"if"},{"id":"b","text":"although"},{"id":"c","text":"if ... not"},{"id":"d","text":"even if"}]'::jsonb, 'c', '"Unless" means "if ... not". For example, "Unless you hurry, you will miss the train" means "If you don''t hurry, you will miss the train."', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('97d5948a-d69a-595c-a33a-175dd7c3b34e', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', 'Practice: zero, first and second conditionals', 2, 75, 15, 'practice', 'admin', 1)
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
  ('013e8407-3e0a-5ecc-af47-acfb7edf86d9', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Complete the zero conditional: "If you mix red and blue, you ___ purple."', '[{"id":"a","text":"will get"},{"id":"b","text":"would get"},{"id":"c","text":"got"},{"id":"d","text":"get"}]'::jsonb, 'd', 'The zero conditional uses present simple in both clauses for general truths: if you mix red and blue, you get purple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57545cb8-cc45-5e9a-acc6-42102f111e27', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Complete the first conditional: "If she ___ harder, she will pass the baccalaureate."', '[{"id":"a","text":"studied"},{"id":"b","text":"will study"},{"id":"c","text":"studies"},{"id":"d","text":"would study"}]'::jsonb, 'c', 'The first conditional uses present simple in the if-clause (not will): if she studies harder, she will pass.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee916acc-ccc1-509c-934c-be74d6578dc8', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Complete the second conditional: "If I ___ a superhero, I would fly to school."', '[{"id":"a","text":"am"},{"id":"b","text":"will be"},{"id":"c","text":"were"},{"id":"d","text":"would be"}]'::jsonb, 'c', 'The second conditional uses past simple (or "were" for be) in the if-clause: if I were a superhero. This is an imaginary situation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3be55d8-8928-58bb-bd27-181af4a0d5e3', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Which sentence correctly uses a comma?', '[{"id":"a","text":"I will help you, if you ask me."},{"id":"b","text":"If you ask me I will help you."},{"id":"c","text":"If, you ask me I will help you."},{"id":"d","text":"If you ask me, I will help you."}]'::jsonb, 'd', 'When the if-clause comes first, place a comma after it: "If you ask me, I will help you." No comma is used when the main clause comes first.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f28f12e-250e-5f6c-9fe4-d5c4de564764', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Identify the conditional type: "If animals could talk, the world would be very different."', '[{"id":"a","text":"Zero conditional"},{"id":"b","text":"First conditional"},{"id":"c","text":"No conditional"},{"id":"d","text":"Second conditional"}]'::jsonb, 'd', 'If + past simple (could talk) + would + base verb (would be) = second conditional. Animals cannot really talk — it is a hypothetical, unreal situation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('402518e0-c2ac-5c9c-86c9-8db84a66c20a', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Rewrite using "unless": "If you don''t eat breakfast, you will feel weak." Choose the correct version:', '[{"id":"a","text":"Unless you don''t eat breakfast, you will feel weak."},{"id":"b","text":"Unless you ate breakfast, you would feel weak."},{"id":"c","text":"Unless you eat breakfast, you would feel weak."},{"id":"d","text":"Unless you eat breakfast, you will feel weak."}]'::jsonb, 'd', '"Unless" already means "if ... not", so the verb stays positive: unless you eat breakfast, you will feel weak. Using "don''t" after "unless" creates a double negative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aa6477e9-c60c-5771-9828-15c32bace66c', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', '⚔️ Boss: master the conditionals', 3, 120, 30, 'boss', 'admin', 2)
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
  ('fc64ccc6-a874-5048-aa2b-ec4bf7fedd1b', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Choose the correct main clause: "If you press this button, the machine ___,"', '[{"id":"a","text":"started"},{"id":"b","text":"starts"},{"id":"c","text":"would start"},{"id":"d","text":"will starting"}]'::jsonb, 'b', 'This is a zero conditional (general/factual truth about a machine): If you press this button, the machine starts. Both clauses use the present simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('349da296-708e-512c-98a5-f79c0d32d5fd', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Complete: "If I ___ you, I would talk to the teacher about this problem."', '[{"id":"a","text":"am"},{"id":"b","text":"was"},{"id":"c","text":"were"},{"id":"d","text":"would be"}]'::jsonb, 'c', 'In the second conditional, "be" takes "were" for all persons in standard/formal English: If I were you... It is an imaginary situation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd9dffa7-3d7a-5ecc-a39f-486149eb142f', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Which sentence is a correct first conditional?', '[{"id":"a","text":"If it will rain, we stay inside."},{"id":"b","text":"If it rained, we will stay inside."},{"id":"c","text":"If it rains, we would stay inside."},{"id":"d","text":"If it rains, we will stay inside."}]'::jsonb, 'd', 'First conditional: if + present simple (rains) + will + base verb (will stay). Option a wrongly puts will in the if-clause; c mixes past simple with will; d is second conditional form.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d753d89-3393-5d46-80cb-7105df4178f0', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Choose the sentence where the comma is used correctly:', '[{"id":"a","text":"We will cancel the trip, if it snows."},{"id":"b","text":"If it snows we will cancel the trip."},{"id":"c","text":"We will cancel, the trip if it snows."},{"id":"d","text":"If it snows, we will cancel the trip."}]'::jsonb, 'd', 'The comma is placed after the if-clause when it comes first in the sentence: "If it snows, we will cancel the trip." No comma is needed when the main clause comes first (option a has an unnecessary comma).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('279267c3-6b7e-528e-a57e-a4ab75cfd473', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Complete: "___ you finish early, you can leave." (use unless or if)', '[{"id":"a","text":"Unless"},{"id":"b","text":"Although"},{"id":"c","text":"If"},{"id":"d","text":"Because"}]'::jsonb, 'c', 'The sentence means: finishing early is the condition for being allowed to leave. This is a positive condition, so use "if": if you finish early, you can leave. "Unless" would mean the opposite.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4ec5fc8-06d7-59b4-bdeb-31ef723ff6fb', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Complete both blanks: "If she ___ the exam, her parents ___ very proud."', '[{"id":"a","text":"will pass ... are"},{"id":"b","text":"passes ... will be"},{"id":"c","text":"passed ... will be"},{"id":"d","text":"passes ... would be"}]'::jsonb, 'b', 'First conditional: if + present simple (passes) + will + base verb (will be). The situation is realistic — she may well pass. Option c mixes past simple with will (second conditional main clause with first conditional if-clause), which is incorrect.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', '👑 Elite Challenge: Conditionals Mastery', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('1eec2a52-2bf6-5ef9-ad37-838cf0aa6bdb', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Complete both blanks: "If the students ___ more carefully, they ___ that mistake."', '[{"id":"a","text":"had read ... would not have made"},{"id":"b","text":"have read ... would not make"},{"id":"c","text":"read ... would not have made"},{"id":"d","text":"had read ... would not make"}]'::jsonb, 'a', 'This is a third conditional: the reading happened (or did not happen) in the past and the mistake is a past consequence. Form: if + past perfect (had read) + would have + past participle (would not have made). Option d mixes past perfect with a second-conditional main clause, creating an incorrect hybrid.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9552a62c-6941-5408-b0ca-cb7b41978a9b', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Identify the conditional type: "If she had taken the earlier bus, she would be home by now."', '[{"id":"a","text":"First conditional — real future situation"},{"id":"b","text":"Second conditional — unreal present situation"},{"id":"c","text":"Third conditional — unreal past situation"},{"id":"d","text":"Mixed conditional — past condition, present result"}]'::jsonb, 'd', 'The if-clause uses past perfect (had taken), referring to a past event that did not happen. The main clause uses would + base verb (would be), describing an unreal present result. This is a mixed conditional: the condition is in the past, but the consequence is felt now. A pure third conditional would have ''would have been'' in the main clause.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a556f41-88ff-55ab-b724-0ab31deddf69', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Choose the option that correctly rewrites this sentence using "unless": "You will not pass the test if you do not revise your notes."', '[{"id":"a","text":"You will not pass the test unless you don''t revise your notes."},{"id":"b","text":"You will not pass the test unless you revise your notes."},{"id":"c","text":"Unless you will revise your notes, you will not pass the test."},{"id":"d","text":"You will not pass the test unless you revised your notes."}]'::jsonb, 'b', '"Unless" already contains the negative meaning of "if ... not", so the clause after it must be positive. "Unless you revise" = "if you do not revise" — this is correct. Option a adds a double negative (unless + don''t), which is wrong. Option c wrongly uses "will" in the unless-clause. Option d uses past simple, which changes the conditional type incorrectly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78208151-f432-5986-89c6-95d2261fe015', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Which sentence correctly uses "could" in a second conditional?', '[{"id":"a","text":"If I have more free time, I could travel the world."},{"id":"b","text":"If I had more free time, I could travel the world."},{"id":"c","text":"If I had more free time, I could have travelled the world."},{"id":"d","text":"If I had had more free time, I could travel the world."}]'::jsonb, 'b', 'In the second conditional, the if-clause uses the past simple (had) for an unreal present or future situation. The main clause can use "would", "could", or "might" + base verb. "Could travel" expresses possibility in an unreal situation, making option b correct. Option a uses present simple in the if-clause (first conditional form). Option c uses "could have travelled" (third conditional main clause). Option d uses past perfect in the if-clause (third conditional form).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('277e4e6e-27b9-5fde-97cd-c6f8f1586ce2', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Four students wrote sentences about a past exam. Which sentence contains a grammatical error?', '[{"id":"a","text":"If Omar had studied the vocabulary, he would have scored higher."},{"id":"b","text":"If Nour had been more careful, she wouldn''t have misread the question."},{"id":"c","text":"If Tarek had revised, he would pass the exam easily."},{"id":"d","text":"If Sana had arrived earlier, she would have had more time."}]'::jsonb, 'c', 'Option c is incorrect because it mixes the third conditional if-clause (had revised — past perfect, referring to the past) with a second conditional main clause (would pass — present result). For a pure third conditional, it should be "would have passed". For a mixed conditional with a present result, the sentence would need a context change. As written, the inconsistency makes it grammatically wrong.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75194e7f-9c18-5bb3-b70d-cac4a264bee3', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Complete: "___ the weather forecast ___ good tomorrow, we ___ have cancelled the school trip already."', '[{"id":"a","text":"If ... is ... will"},{"id":"b","text":"Unless ... were ... would"},{"id":"c","text":"If ... had been ... would have"},{"id":"d","text":"Unless ... had been ... would"}]'::jsonb, 'c', 'The adverb "already" signals a completed past action (the cancellation is being discussed as something that would have happened in the past). The correct structure is a third conditional: if + past perfect (had been) + would have + past participle (would have cancelled). "Already" confirms the result belongs to the past, ruling out second conditional forms. Unless does not fit the logic of this sentence, which states a positive past condition.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6c069575-64c8-5d0f-bd94-5fda4d4c80a3', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('79afc241-0f21-57eb-b2de-d9c503d9d75c', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'What is the core formula for forming the passive voice?', '[{"id":"a","text":"subject + have + past participle"},{"id":"b","text":"subject + be + past participle"},{"id":"c","text":"subject + be + present participle (-ing)"},{"id":"d","text":"subject + do + base verb"}]'::jsonb, 'b', 'The passive is always formed with the correct form of "be" + the past participle of the main verb, regardless of tense.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3248e070-6326-5ec2-9a5c-9a6562bf3d43', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'Which sentence correctly transforms "They speak French here" into the present simple passive?', '[{"id":"a","text":"French was spoken here."},{"id":"b","text":"French has been spoken here."},{"id":"c","text":"French is spoken here."},{"id":"d","text":"French are spoken here."}]'::jsonb, 'c', 'The present simple passive uses is/are + past participle. "French" is a singular noun, so the correct form is "is spoken".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0d0bbc9-7f9c-56c2-a957-6fda2126ca6b', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'What is the first step when converting an active sentence to a passive one?', '[{"id":"a","text":"Add \"by\" and the original subject at the end."},{"id":"b","text":"Move the object of the active sentence to the subject position."},{"id":"c","text":"Change the main verb to its present participle."},{"id":"d","text":"Remove the subject of the active sentence entirely."}]'::jsonb, 'b', 'The first step is to move the object of the active sentence into the subject position. Then choose the correct form of "be" and add the past participle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5b5be7e-f4ab-55b6-a38e-181570ee31d9', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'Which sentence correctly uses the past simple passive?', '[{"id":"a","text":"The bridge is built in 1990."},{"id":"b","text":"The bridge was build in 1990."},{"id":"c","text":"The bridge were built in 1990."},{"id":"d","text":"The bridge was built in 1990."}]'::jsonb, 'd', 'The past simple passive uses was/were + past participle. "Bridge" is singular, so "was" is correct, and "built" is the past participle of "build".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b71e28ea-6533-5302-b2c9-9ddad3b2c439', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'When is the "by + agent" phrase typically omitted in a passive sentence?', '[{"id":"a","text":"When the sentence is in the present tense"},{"id":"b","text":"When the subject is plural"},{"id":"c","text":"When the agent is unknown, unimportant, or obvious from context"},{"id":"d","text":"When the verb is irregular"}]'::jsonb, 'c', 'The "by + agent" phrase is often left out when the agent is unknown ("My wallet was stolen"), unimportant, or already obvious from context.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('69ebe656-2d06-5124-80fc-9f898ee0a2b8', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', 'Practice: active or passive?', 2, 60, 12, 'practice', 'admin', 1)
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
  ('cf42ec20-80b2-537e-a00e-3c58063c62ff', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Choose the correct passive form: "The windows ___ every week." (present simple passive)', '[{"id":"a","text":"clean"},{"id":"b","text":"are cleaned"},{"id":"c","text":"is cleaned"},{"id":"d","text":"were cleaned"}]'::jsonb, 'b', '"The windows" is plural, so the present simple passive uses ARE + past participle: are cleaned.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b38e0c4-8ce6-5c7a-a51b-cd1d96b9c7b9', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Complete: "Arabic ___ in Tunisia." (present simple passive of ''speak'')', '[{"id":"a","text":"speaks"},{"id":"b","text":"is spoken"},{"id":"c","text":"are spoken"},{"id":"d","text":"was spoken"}]'::jsonb, 'b', '"Arabic" is singular. The present simple passive of "speak" is IS + spoken: Arabic is spoken in Tunisia.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1886b0c7-fccb-565d-92ff-f84e3a6993f4', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Turn this active sentence into passive: "Someone broke the vase." The correct passive is:', '[{"id":"a","text":"The vase is broken."},{"id":"b","text":"The vase was broken."},{"id":"c","text":"The vase were broken."},{"id":"d","text":"The vase was break."}]'::jsonb, 'b', 'The active verb is past simple (broke), so the passive uses WAS + past participle (broken): The vase was broken.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e072540f-1856-5eac-9a8e-db19cec747e6', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Which sentence is correct?', '[{"id":"a","text":"The letters were written by the students."},{"id":"b","text":"The letters were write by the students."},{"id":"c","text":"The letters was written by the students."},{"id":"d","text":"The letters are written by the students yesterday."}]'::jsonb, 'a', '"The letters" is plural and the action is past, so we need WERE + past participle (written): The letters were written by the students.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9e2968b-a92d-5746-9362-164238da0854', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Complete: "The exam ___ yesterday by all the students." (past simple passive of ''take'')', '[{"id":"a","text":"is taken"},{"id":"b","text":"are taken"},{"id":"c","text":"was taken"},{"id":"d","text":"took"}]'::jsonb, 'c', '"The exam" is singular and "yesterday" signals past tense. The past simple passive is WAS + taken: The exam was taken yesterday.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7989200f-316a-50cf-a23b-c990be75e64e', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Why is the passive preferred in: "Oil was discovered in the desert"?', '[{"id":"a","text":"Because the subject is performing the action."},{"id":"b","text":"Because the action is happening right now."},{"id":"c","text":"Because the agent is unimportant; the focus is on the discovery."},{"id":"d","text":"Because \"discover\" is a stative verb."}]'::jsonb, 'c', 'We use the passive here because the agent (who discovered it) is unimportant or unknown — the focus is on the result: oil being discovered.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('50566438-5c32-582c-9b59-43a0b96cc9a4', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', '⚔️ Boss: passive voice mastery', 3, 120, 30, 'boss', 'admin', 2)
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
  ('43b02806-bc22-570c-b797-0b37b895db64', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Transform to passive: "They make these shoes in Italy." The correct passive is:', '[{"id":"a","text":"These shoes are made in Italy."},{"id":"b","text":"These shoes were made in Italy."},{"id":"c","text":"These shoes is made in Italy."},{"id":"d","text":"These shoes are make in Italy."}]'::jsonb, 'a', 'Active: present simple. "These shoes" is plural → ARE + past participle of make (made): These shoes are made in Italy.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fdfff8c-ddbd-5448-85e5-83a9f52730c9', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Transform to passive: "The teacher corrected our homework." The correct passive is:', '[{"id":"a","text":"Our homework is corrected by the teacher."},{"id":"b","text":"Our homework were corrected by the teacher."},{"id":"c","text":"Our homework was correct by the teacher."},{"id":"d","text":"Our homework was corrected by the teacher."}]'::jsonb, 'd', 'Active verb is past simple (corrected). "Our homework" is singular → WAS + past participle (corrected): Our homework was corrected by the teacher.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c961b0e5-2864-5565-abe0-a6579f21445f', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Choose the sentence where the passive is used correctly:', '[{"id":"a","text":"The pyramids were build thousands of years ago."},{"id":"b","text":"The pyramids were built thousands of years ago."},{"id":"c","text":"The pyramids was built thousands of years ago."},{"id":"d","text":"The pyramids are built thousands of years ago."}]'::jsonb, 'b', '"The pyramids" is plural + past time → WERE + past participle of build (built): The pyramids were built thousands of years ago.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86e69d95-8ade-5dc8-bc07-e6ac553e4be0', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Active: "A student finds a wallet." → Passive:', '[{"id":"a","text":"A wallet is found by a student."},{"id":"b","text":"A wallet found by a student."},{"id":"c","text":"A wallet were found by a student."},{"id":"d","text":"A wallet was found by a student."}]'::jsonb, 'a', 'Active verb is present simple (finds). "A wallet" is singular → IS + past participle of find (found): A wallet is found by a student.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02029c31-8bc4-5e35-8816-cce63c913e55', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Choose the sentence that correctly OMITS the by-agent because it is obvious:', '[{"id":"a","text":"The patient was examined by a doctor."},{"id":"b","text":"The patient is examining."},{"id":"c","text":"The patient was examined."},{"id":"d","text":"The patient examines."}]'::jsonb, 'c', 'When it is obvious that a doctor performs the examination, "by a doctor" adds no information and is correctly omitted: The patient was examined.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01868ac1-1c85-531f-b957-c922c262d7c3', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Complete the sentence with the correct passive: "The new library ___ last year." (open)', '[{"id":"a","text":"is opened"},{"id":"b","text":"was opened"},{"id":"c","text":"opened"},{"id":"d","text":"were opened"}]'::jsonb, 'b', '"The new library" is singular and "last year" signals past tense → WAS + past participle (opened): The new library was opened last year.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4b1a1f73-c67e-5e29-92d8-9b3a4b074943', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', '👑 Elite Challenge: Passive Voice Across Tenses & Modals', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('5c58a0e6-f68f-5902-ad5a-dfaf00b004c1', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Transform to passive (future simple): "The government will announce the results tomorrow."
Which option is correct?', '[{"id":"a","text":"The results will announced by the government tomorrow."},{"id":"b","text":"The results are announced by the government tomorrow."},{"id":"c","text":"The results will be announced by the government tomorrow."},{"id":"d","text":"The results were announced by the government tomorrow."}]'::jsonb, 'c', 'Future simple passive = will + be + past participle. "Announce" → past participle "announced". The object "the results" becomes the subject: The results WILL BE ANNOUNCED by the government tomorrow. Option a omits "be"; b uses present passive (wrong tense); d uses past passive (wrong tense).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3509320-48b2-5d64-b94a-277dd38e4efd', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Transform to passive (present perfect): "Someone has stolen the exam papers."
Which option is correct?', '[{"id":"a","text":"The exam papers have been stolen."},{"id":"b","text":"The exam papers has been stolen."},{"id":"c","text":"The exam papers were stolen."},{"id":"d","text":"The exam papers had been stolen."}]'::jsonb, 'a', 'Present perfect passive = have / has + been + past participle. "The exam papers" is plural → HAVE (not has). By-agent is omitted because the agent (someone) is unknown. Option b incorrectly uses "has" with a plural subject; c is past simple (loses the present-perfect meaning); d is past perfect (wrong tense).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('741a817a-a456-5c11-aca4-40c0f9dd6d99', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Transform to passive (modal — must): "You must submit all assignments before Friday."
Which option is correct?', '[{"id":"a","text":"All assignments must been submitted before Friday."},{"id":"b","text":"All assignments must be submitted before Friday."},{"id":"c","text":"All assignments must being submitted before Friday."},{"id":"d","text":"All assignments must submitted before Friday."}]'::jsonb, 'b', 'Passive with a modal = modal + be + past participle. "Must" is already a base-form modal, so: must + BE + submitted. Option a uses "been" without "be" (wrong); c uses "being" (continuous form, wrong here); d omits "be" entirely.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('850a7fac-2254-5cb0-ab2a-3bb1860c3d95', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Turn the active question into a passive question (present simple): "Do they teach Arabic in this school?"
Which passive question is correct?', '[{"id":"a","text":"Are Arabic taught in this school?"},{"id":"b","text":"Does Arabic taught in this school?"},{"id":"c","text":"Was Arabic taught in this school?"},{"id":"d","text":"Is Arabic taught in this school?"}]'::jsonb, 'd', 'Present simple passive question = Is / Are + subject + past participle? "Arabic" is an uncountable/singular noun → IS (not are). Past participle of teach = taught. Option a wrongly uses "Are" with the singular noun "Arabic"; b keeps the active auxiliary "Does" (wrong); c uses "Was" — past tense, not present.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35a20b5f-927d-587c-a45a-0c20fcc5c2a7', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Active: "Doctors should check patients regularly."
Which passive sentence is correct AND uses the most natural style (agent omitted when obvious)?', '[{"id":"a","text":"Patients should be check regularly."},{"id":"b","text":"Patients should been checked regularly."},{"id":"c","text":"Patients should be checked regularly."},{"id":"d","text":"Patients should being checked regularly."}]'::jsonb, 'c', 'Modal passive = should + be + past participle (checked). The agent "by doctors" is omitted because it is obvious from context. Option a uses the base form "check" instead of the past participle; b omits "be" and has "been" in the wrong position; d uses "being" (a progressive form that does not follow a bare modal).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('659c49ec-4a06-519d-aba8-8a72e9ad1b81', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Active: "The jury awarded the winner a gold medal."
Which passive sentence is correct?', '[{"id":"a","text":"The winner were awarded a gold medal by the jury."},{"id":"b","text":"The winner was awarded a gold medal by the jury."},{"id":"c","text":"A gold medal is awarded to the winner by the jury."},{"id":"d","text":"The winner was awarded to a gold medal by the jury."}]'::jsonb, 'b', 'With two-object verbs like "award", the indirect object (the winner) can become the subject: The winner WAS awarded a gold medal by the jury. "The winner" is singular + past tense → WAS (not were). Option a wrongly uses "were" with a singular subject; c uses present tense (wrong) and misplaces "to"; d incorrectly inserts "to" between "awarded" and "a gold medal", which is ungrammatical in this pattern.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d5b41c1a-0a53-5c06-915c-102435d5c6c0', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Direct speech: "I am tired." She said ___.', '[{"id":"a","text":"she said that she is tired."},{"id":"b","text":"she said that she was tired."},{"id":"c","text":"she said that I was tired."},{"id":"d","text":"she said that she were tired."}]'::jsonb, 'b', 'When the reporting verb is in the past (said), the present simple "am" shifts back to the past simple "was". The pronoun "I" also changes to "she" to match the speaker.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4d34b52-281d-57e3-8460-aafe4175f0f5', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Which reporting verb always requires a person as its object?', '[{"id":"a","text":"say"},{"id":"b","text":"ask"},{"id":"c","text":"tell"},{"id":"d","text":"report"}]'::jsonb, 'c', '"Tell" always needs a person object: tell me, tell him, tell the class. "Say" never takes a direct person object ("say me" is wrong).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('145aa30d-c72c-5e4d-9190-f15b093dd84f', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'In reported speech, what does "tomorrow" in direct speech change to?', '[{"id":"a","text":"today"},{"id":"b","text":"the day before"},{"id":"c","text":"the next day"},{"id":"d","text":"that day"}]'::jsonb, 'c', '"Tomorrow" in direct speech shifts to "the next day" (or "the following day") in reported speech, because the time reference has changed.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26cb3024-d046-5eee-baa5-4d6eac88fbb0', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Direct speech: "Are you ready?" She asked ___.', '[{"id":"a","text":"if I was ready."},{"id":"b","text":"if was I ready."},{"id":"c","text":"if I am ready."},{"id":"d","text":"if I were ready."}]'::jsonb, 'a', 'Yes/no questions in reported speech use "if" or "whether", with normal word order (subject before verb): "she asked if I was ready". "Are" backshifts to "was".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b165d39a-8b1a-559a-bc93-6ef918be4194', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Direct speech: "Don''t run in the corridor!" The teacher told the students ___.', '[{"id":"a","text":"to not run in the corridor."},{"id":"b","text":"don''t run in the corridor."},{"id":"c","text":"not to run in the corridor."},{"id":"d","text":"that they didn''t run in the corridor."}]'::jsonb, 'c', 'Negative commands in reported speech use tell/ask + person + not to + infinitive. The correct form is "told the students not to run".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', 'Practice: reported speech basics', 2, 60, 12, 'practice', 'admin', 1)
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
  ('94522885-b8e2-5f36-becc-435d20c867e2', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "I am tired," she said. Choose the correct reported form:', '[{"id":"a","text":"She said that she is tired."},{"id":"b","text":"She told that she was tired."},{"id":"c","text":"She said that I was tired."},{"id":"d","text":"She said that she was tired."}]'::jsonb, 'd', 'The reporting verb is past (said), so the present simple ''am'' backshifts to past simple ''was''. The pronoun ''I'' changes to ''she''. We use ''say that'', not ''told that''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('719aef66-3c4a-5ad6-9af9-50fd99dcfbce', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Which sentence uses ''tell'' correctly?', '[{"id":"a","text":"She told that she was ready."},{"id":"b","text":"She said me that she was ready."},{"id":"c","text":"She told me that she was ready."},{"id":"d","text":"She told that the test was easy."}]'::jsonb, 'c', '''tell'' always requires a personal object: tell + person + (that) + clause. ''She told me that she was ready'' is the only correct pattern.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a209293d-9928-57f6-8315-b45fbd4f39e3', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "I will help you," he said. Choose the correct reported form:', '[{"id":"a","text":"He said that he will help you."},{"id":"b","text":"He told that he would help me."},{"id":"c","text":"He said that he would help me."},{"id":"d","text":"He said that he would help you."}]'::jsonb, 'c', '''will'' backshifts to ''would''. The pronoun ''you'' changes to ''me'' (the listener becomes the reporter). We use ''say that'', not ''told that''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c4cb780-1da9-5b34-bd95-073216e9116a', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "Are you ready?" she asked me. Choose the correct reported question:', '[{"id":"a","text":"She asked me if I was ready."},{"id":"b","text":"She asked me if was I ready."},{"id":"c","text":"She asked me if I am ready."},{"id":"d","text":"She asked if was I ready."}]'::jsonb, 'a', 'Yes/no questions use ''if/whether''. Word order becomes normal (subject before verb): ''if I was ready''. The tense backshifts: ''are'' → ''was''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4aafc66-106d-5f85-918e-89cb6ca105d1', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "Don''t run in the corridor!" the teacher said. Choose the correct reported command:', '[{"id":"a","text":"The teacher said not to run in the corridor."},{"id":"b","text":"The teacher told the students don''t run in the corridor."},{"id":"c","text":"The teacher told the students not to run in the corridor."},{"id":"d","text":"The teacher asked don''t run in the corridor."}]'::jsonb, 'c', 'Negative commands are reported with ''tell + person + not to + infinitive''. ''The teacher told the students not to run in the corridor'' is correct.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ddeacd6-9014-5387-85ab-5ebca4c59ff1', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "I can swim," she said. The time word ''now'' in her speech would become:', '[{"id":"a","text":"then"},{"id":"b","text":"today"},{"id":"c","text":"here"},{"id":"d","text":"tomorrow"}]'::jsonb, 'a', 'When time and place words shift to reported speech, ''now'' becomes ''then''. Other shifts: today → that day, tomorrow → the next day, here → there.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('038be31c-9625-5dc2-8227-4a7402dbfe43', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', '⚔️ Boss: reported speech mastery', 3, 120, 30, 'boss', 'admin', 2)
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
  ('71e33276-0916-5dbf-9e87-3633f36b26be', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "We have already finished the project," they said. Choose the correct reported form:', '[{"id":"a","text":"They said they had already finished the project."},{"id":"b","text":"They said they have already finished the project."},{"id":"c","text":"They told they had already finished the project."},{"id":"d","text":"They said they finished already the project."}]'::jsonb, 'a', 'Present perfect (''have finished'') backshifts to past perfect (''had finished''). ''We'' changes to ''they''. We use ''say (that)'', not ''told (that)''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f165226-6514-5ab3-8be5-8e7b31368205', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "Where does she live?" he asked. Choose the correct reported question:', '[{"id":"a","text":"He asked where does she live."},{"id":"b","text":"He asked where she lives."},{"id":"c","text":"He asked where did she live."},{"id":"d","text":"He asked where she lived."}]'::jsonb, 'd', 'Reported wh-questions use normal word order (no inversion, no auxiliary) and apply backshift: ''does she live'' → ''she lived''. No question mark in reported speech.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8e56ca4-49e2-5025-8b40-72839f6dcbf5', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "Can you open the window?" she asked him. Choose the correct reported form:', '[{"id":"a","text":"She asked him if he can open the window."},{"id":"b","text":"She told him if he could open the window."},{"id":"c","text":"She asked him if he could open the window."},{"id":"d","text":"She asked him could he open the window."}]'::jsonb, 'c', 'A yes/no question is reported with ''if/whether''. ''can'' backshifts to ''could''. Normal word order: ''he could open''. The pronoun ''you'' changes to ''he''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97062025-2da0-52e1-b0a4-2dd3e6625115', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "I studied here yesterday," she told me. Identify all the changes in the reported form: ''She told me she had studied there the day before.''', '[{"id":"a","text":"Only the tense changed."},{"id":"b","text":"Only the pronoun and time word changed."},{"id":"c","text":"The pronoun, tense, place word, and time word all changed."},{"id":"d","text":"The tense, place word, and time word all changed."}]'::jsonb, 'c', '''I'' → ''she'' (pronoun); past simple ''studied'' → past perfect ''had studied'' (tense backshift); ''here'' → ''there'' (place word); ''yesterday'' → ''the day before'' (time word). All four elements changed.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffba2614-6e95-5898-af20-4f54e0cfbf82', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "Come back tomorrow!" he told her. Choose the correct reported command:', '[{"id":"a","text":"He told her to come back the next day."},{"id":"b","text":"He told her to come back tomorrow."},{"id":"c","text":"He said her to come back the next day."},{"id":"d","text":"He told to come back the next day."}]'::jsonb, 'a', 'Commands use ''tell + person + to + infinitive''. The time word ''tomorrow'' shifts to ''the next day'' in reported speech. ''said her'' is wrong — ''say'' never takes a direct person object.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd11e9b8-d66b-5df5-9042-1f71a4c1c943', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Which sentence applies the WRONG backshift?', '[{"id":"a","text":"He said he would call me. (will → would)"},{"id":"b","text":"They said they can finish. (can → no change)"},{"id":"c","text":"She said she had left early. (past simple → past perfect)"},{"id":"d","text":"He said he was studying. (present continuous → past continuous)"}]'::jsonb, 'b', 'When the reporting verb is in the past, ''can'' must backshift to ''could''. Saying ''they can finish'' is incorrect — it should be ''they could finish''.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f87026b5-e3f7-55ce-93f9-9d473c37a345', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', '👑 Elite Challenge: Mastering Reported Speech', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('ce27e8ce-4c97-5c83-921e-c4c8b0fa87b7', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "I lost my keys yesterday," Tom told Sarah. Which reported form is FULLY correct (tense, pronoun, and time word all shifted)?', '[{"id":"a","text":"Tom told Sarah that he had lost his keys the day before."},{"id":"b","text":"Tom told Sarah that he lost his keys yesterday."},{"id":"c","text":"Tom told Sarah that he had lost his keys yesterday."},{"id":"d","text":"Tom told Sarah that he has lost his keys the day before."}]'::jsonb, 'a', 'Three shifts are required: (1) ''I'' → ''he'' (pronoun); (2) past simple ''lost'' → past perfect ''had lost'' (backshift); (3) ''yesterday'' → ''the day before'' (time-word shift). Option B misses all three. Option C backshifts the tense correctly but leaves ''yesterday'' unchanged. Option D uses present perfect ''has lost'' instead of past perfect ''had lost''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7819a5fe-fbe0-59b2-8d6c-056fc1f5b214', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "What did you buy at the market?" she asked him. Choose the correctly reported question:', '[{"id":"a","text":"She asked him what did he buy at the market."},{"id":"b","text":"She asked him what he bought at the market."},{"id":"c","text":"She asked him what he had bought at the market."},{"id":"d","text":"She asked him what had he bought at the market."}]'::jsonb, 'c', 'In a reported wh-question: (1) normal subject-before-verb order replaces the inverted question form (''what he…'', not ''what did he…''); (2) past simple ''did buy'' backshifts to past perfect ''had bought''; (3) ''you'' → ''he''. Option A keeps the auxiliary ''did'' (wrong order). Option B uses past simple ''bought'' with no backshift. Option D retains inversion (''had he'') — incorrect in reported speech.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11d6470e-14ec-5d4c-a173-f08aa8b53c8f', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "Don''t tell anyone about this!" she told him. Which reported command is correct?', '[{"id":"a","text":"She told him don''t tell anyone about that."},{"id":"b","text":"She asked him not telling anyone about that."},{"id":"c","text":"She said him not to tell anyone about this."},{"id":"d","text":"She told him not to tell anyone about that."}]'::jsonb, 'd', 'Negative commands are reported with ''tell + person + not to + infinitive''. Option A wrongly keeps the imperative ''don''t tell''. Option B incorrectly uses a gerund (''not telling'') instead of ''not to + infinitive''. Option C uses ''said him'' — ''say'' never takes a direct personal object — and fails to shift ''this'' to ''that''. Option D is fully correct: ''told him not to tell… about that''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98ae61e1-b215-5802-96f7-52e519f394d4', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "She may already know the answer," he said. Which sentence applies the correct modal backshift?', '[{"id":"a","text":"He said she may already know the answer."},{"id":"b","text":"He told she might already know the answer."},{"id":"c","text":"He said she might already know the answer."},{"id":"d","text":"He said she could already know the answer."}]'::jsonb, 'c', '''May'' backshifts to ''might'' when the reporting verb is in the past. Option A keeps ''may'' with no backshift. Option B uses ''told'' without a personal object — ''tell'' always requires one (e.g. ''told us''). Option D substitutes ''could'', which is the backshift of ''can'', not ''may''. Option C correctly applies the ''may → might'' backshift with ''said (that)''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63217691-5552-58cf-91f9-4fb34905a0ef', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "Have you ever been to Carthage?" the teacher asked the students. Choose the correct reported question:', '[{"id":"a","text":"The teacher asked the students if they have ever been to Carthage."},{"id":"b","text":"The teacher asked the students whether had they ever been to Carthage."},{"id":"c","text":"The teacher asked the students whether they had ever been to Carthage."},{"id":"d","text":"The teacher asked the students if they were ever to Carthage."}]'::jsonb, 'c', 'A yes/no question is reported with ''if'' or ''whether''. Present perfect ''have been'' backshifts to past perfect ''had been''. Normal word order (subject before verb) replaces inversion. Option A keeps present perfect ''have been'' with no backshift. Option B retains auxiliary inversion (''had they'') — wrong in reported speech. Option D wrongly replaces ''have been to'' with ''were to'', distorting the meaning entirely.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6eb3cd1-773c-5f0e-80a8-cdc14a156d80', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "I will visit my grandmother next week," Ahmed said. Which is the ONLY fully correct reported sentence?', '[{"id":"a","text":"Ahmed said he will visit his grandmother next week."},{"id":"b","text":"Ahmed told he would visit his grandmother the following week."},{"id":"c","text":"Ahmed said he would visit his grandmother next week."},{"id":"d","text":"Ahmed said he would visit his grandmother the following week."}]'::jsonb, 'd', 'Two shifts are required: (1) ''will'' → ''would'' (modal backshift); (2) ''next week'' → ''the following week'' (time-word shift). Option A applies neither shift. Option B correctly backshifts ''will → would'' and shifts the time word, but uses ''told'' without a personal object — always wrong. Option C backshifts ''will → would'' correctly but leaves ''next week'' unchanged. Only Option D applies both the modal backshift and the time-word shift correctly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f34bbeba-a514-5828-9e27-2a8b3711fb93', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d9e00dc9-ff59-55d0-9648-d429ed81295c', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which relative pronoun is used to refer to people in a defining relative clause?', '[{"id":"a","text":"which"},{"id":"b","text":"where"},{"id":"c","text":"whose"},{"id":"d","text":"who"}]'::jsonb, 'd', '"Who" refers to people in a relative clause: "The teacher who inspired me retired last year." "Which" refers to things or animals.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c76b8b99-9da2-5728-9cb2-f075223db346', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'What is the comparative form of the adjective "happy"?', '[{"id":"a","text":"more happy than"},{"id":"b","text":"happier than"},{"id":"c","text":"happyer than"},{"id":"d","text":"the happiest"}]'::jsonb, 'b', 'Short adjectives ending in -y drop the y and add -ier: happy → happier than. "More happy" is not the standard form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4935e3cb-7a61-50a1-b744-1f0b34d7815f', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which sentence correctly uses the superlative form?', '[{"id":"a","text":"This is more difficult question in the exam."},{"id":"b","text":"This is most difficult question in the exam."},{"id":"c","text":"This is the most difficult question in the exam."},{"id":"d","text":"This is difficultest question in the exam."}]'::jsonb, 'c', 'Superlatives always require the definite article "the" before them: the most difficult. Long adjectives use "the most + adjective".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1da5ec88-b844-5781-97cc-219745da8727', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which relative pronoun shows possession?', '[{"id":"a","text":"that"},{"id":"b","text":"which"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'd', '"Whose" replaces a possessive: "The girl whose bag was lost" means the girl''s bag was lost. It refers to people.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3286e813-6caa-57ff-a8e3-c3606cb69310', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which sentence correctly expresses equality using "as ... as"?', '[{"id":"a","text":"Sami is as taller as his brother."},{"id":"b","text":"Sami is as tall as his brother."},{"id":"c","text":"Sami is more tall as his brother."},{"id":"d","text":"Sami is tallest as his brother."}]'::jsonb, 'b', 'The structure for equality is "as + adjective (base form) + as". Never use the comparative form inside this structure: "as tall as", not "as taller as".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f9d67f42-c6fd-52d1-b4d8-658c24c4069e', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', 'Practice: relative clauses & comparatives', 2, 75, 15, 'practice', 'admin', 1)
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
  ('4ae0793a-71f0-59d6-9e51-a31b37912048', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Choose the correct relative pronoun: "The student ___ won the prize is in my class."', '[{"id":"a","text":"which"},{"id":"b","text":"whose"},{"id":"c","text":"where"},{"id":"d","text":"who"}]'::jsonb, 'd', 'We use ''who'' for people. ''The student who won the prize'' — ''who'' refers to ''the student'' (a person).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f68a2c08-9617-5c02-a318-9e30a4619989', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Complete: "This is the book ___ changed my life."', '[{"id":"a","text":"who"},{"id":"b","text":"that"},{"id":"c","text":"whose"},{"id":"d","text":"where"}]'::jsonb, 'b', 'We use ''which'' or ''that'' for things. ''The book that changed my life'' — ''that'' refers to ''the book'' (a thing). Both ''which'' and ''that'' are correct for things, but only ''that'' is offered.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a387198b-d83b-52a6-9faf-fd4740453fb6', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Choose the correct comparative: "A cheetah is ___ a lion."', '[{"id":"a","text":"more fast than"},{"id":"b","text":"fastest than"},{"id":"c","text":"as fast than"},{"id":"d","text":"faster than"}]'::jsonb, 'd', '''fast'' is a short (one-syllable) adjective, so the comparative is ''faster than''. We never use ''more fast'' with short adjectives.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53788e4f-8c7e-5bbf-86e1-f3ffc3ebb034', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Complete: "Mount Everest is ___ mountain in the world."', '[{"id":"a","text":"more high"},{"id":"b","text":"the most high"},{"id":"c","text":"higher"},{"id":"d","text":"the highest"}]'::jsonb, 'd', '''high'' is a short adjective. The superlative adds ''-est'' and requires ''the'': ''the highest''. We never say ''the most high'' with short adjectives.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44355f34-9f8c-53a1-aadb-81d5245d24b4', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Which sentence uses ''as … as'' correctly?', '[{"id":"a","text":"She is as taller as her sister."},{"id":"b","text":"She is as more tall as her sister."},{"id":"c","text":"She is tall as her sister."},{"id":"d","text":"She is as tall as her sister."}]'::jsonb, 'd', 'The structure is ''as + base adjective + as''. Never use the comparative form inside ''as … as''. ''She is as tall as her sister'' is correct.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72cf3144-6f03-53f3-a57f-d413730520ed', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Choose the correct relative pronoun: "The house ___ she grew up was demolished."', '[{"id":"a","text":"who"},{"id":"b","text":"where"},{"id":"c","text":"which"},{"id":"d","text":"whose"}]'::jsonb, 'b', 'We use ''where'' for places. ''The house where she grew up'' — ''where'' refers to ''the house'' as a location.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2cbeb6e5-2960-512e-9f42-e5cbe625a305', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', '⚔️ Boss: relative clauses & comparatives mastery', 3, 120, 30, 'boss', 'admin', 2)
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
  ('684457b0-f151-5355-b7de-b1cc7331c8e0', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Choose the correct relative pronoun: "The scientist ___ research won the Nobel Prize gave a lecture."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"whose"},{"id":"d","text":"that"}]'::jsonb, 'c', 'We need ''whose'' because it refers to the scientist''s research (possession). ''The scientist whose research won the Nobel Prize'' — ''whose'' replaces ''the scientist''s''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78a7a0fe-8fa8-50d9-8c2f-f514647fb4fc', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Complete with the correct comparative: "This exam is ___ the one we did last month." (difficult)', '[{"id":"a","text":"difficulter than"},{"id":"b","text":"the most difficult than"},{"id":"c","text":"more difficult as"},{"id":"d","text":"more difficult than"}]'::jsonb, 'd', '''difficult'' is a long adjective (three syllables), so the comparative is ''more difficult than''. We never add ''-er'' to long adjectives, and the second element is introduced by ''than'', not ''as''.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('118a1f96-6010-503b-a5bf-8d5a7fd05817', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Choose the correct sentence:', '[{"id":"a","text":"Her results are better than mine."},{"id":"b","text":"Her results are gooder than mine."},{"id":"c","text":"Her results are more good than mine."},{"id":"d","text":"Her results are best than mine."}]'::jsonb, 'a', '''good'' is irregular. Its comparative is ''better than'' — not ''gooder'', ''more good'', or ''best''. The superlative would be ''the best''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b2d3600-2cf9-5aa0-af06-ba7393c39024', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Complete: "Rania is not ___ her brother at maths." (good)', '[{"id":"a","text":"as better as"},{"id":"b","text":"so good than"},{"id":"c","text":"as good as"},{"id":"d","text":"as well as"}]'::jsonb, 'c', 'For equality/inequality, use ''as + base adjective + as''. ''not as good as'' is correct. ''as better as'' wrongly uses the comparative inside the structure; ''so good than'' is not a real pattern; ''as well as'' is an adverb phrase, not an adjective comparison.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74caaa9d-d014-5673-8f8b-9c0121dc06c6', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Which sentence correctly uses a writing connector to show contrast?', '[{"id":"a","text":"He studied hard; therefore, he failed the exam."},{"id":"b","text":"He studied hard; furthermore, he failed the exam."},{"id":"c","text":"He studied hard; for example, he failed the exam."},{"id":"d","text":"He studied hard; however, he failed the exam."}]'::jsonb, 'd', '''however'' signals contrast between two opposing ideas. ''therefore'' = result, ''furthermore'' = addition, ''for example'' = illustration. Only ''however'' correctly contrasts studying hard with failing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('481b204d-67d0-5c6e-b6f3-01c13e92b87e', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Choose the sentence with the correct superlative form:', '[{"id":"a","text":"Yesterday was the most bad day of my life."},{"id":"b","text":"Yesterday was the baddest day of my life."},{"id":"c","text":"Yesterday was the worse day of my life."},{"id":"d","text":"Yesterday was the worst day of my life."}]'::jsonb, 'd', '''bad'' is irregular: bad → worse → the worst. ''The worst day'' is the only correct superlative. ''Baddest'', ''the most bad'', and ''the worse'' are all incorrect forms.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e6171568-ac34-5461-a926-00b1198d046e', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', '👑 Elite Challenge: Relative Clauses & Comparatives Under Pressure', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('da568abe-ed24-5c8b-87a8-366cf878cc44', 'e6171568-ac34-5461-a926-00b1198d046e', 'A student writes: "The museum, that we visited last summer, was built in 1890." What is wrong with this sentence?', '[{"id":"a","text":"Nothing is wrong; ''that'' is always interchangeable with ''which''."},{"id":"b","text":"''that'' cannot be used in a non-defining relative clause; it must be replaced with ''which''."},{"id":"c","text":"The commas are wrong; remove them and the sentence is correct."},{"id":"d","text":"''that'' should be replaced with ''who'' because museums are important places."}]'::jsonb, 'b', 'Non-defining relative clauses (set off by commas) add extra, non-essential information. They require ''which'' for things — never ''that''. ''That'' is only used in defining relative clauses, where no comma is used. Removing the commas (option C) would make it defining, which changes the meaning entirely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5dfbba67-23ca-5232-bd3a-a66957add243', 'e6171568-ac34-5461-a926-00b1198d046e', 'Combine these two sentences into ONE using the correct relative pronoun: "We read a report. Its conclusions surprised the entire committee."', '[{"id":"a","text":"We read a report which conclusions surprised the entire committee."},{"id":"b","text":"We read a report that its conclusions surprised the entire committee."},{"id":"c","text":"We read a report whose conclusions surprised the entire committee."},{"id":"d","text":"We read a report where its conclusions surprised the entire committee."}]'::jsonb, 'c', '''Whose'' replaces a possessive (''its conclusions'' = ''the report''s conclusions''). It can refer to both people AND things in formal English. ''Which conclusions'' is ungrammatical without a preposition; ''that its'' repeats the pronoun and is incorrect; ''where'' is for places, not possessive relationships.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30ac2283-9c21-5f32-b50c-f55d02072c39', 'e6171568-ac34-5461-a926-00b1198d046e', 'Choose the sentence in which the relative pronoun CAN be omitted without making the sentence ungrammatical:', '[{"id":"a","text":"The teacher whose class I attended retired last week."},{"id":"b","text":"The city where I was born is far from here."},{"id":"c","text":"The novel that she recommended to me was excellent."},{"id":"d","text":"The student who answered first won the prize."}]'::jsonb, 'c', 'A relative pronoun can be omitted only when it is the OBJECT of the relative clause. In option C, ''that'' is the object (''she recommended [it] to me''), so it can be dropped: ''The novel she recommended to me was excellent.'' In option D, ''who'' is the SUBJECT (''who answered first''), so it cannot be omitted. ''Whose'' and ''where'' can never be omitted.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('509c6467-c2af-55d2-a464-d762a3a5f71a', 'e6171568-ac34-5461-a926-00b1198d046e', 'Which sentence correctly uses the ''the … the …'' double comparative structure?', '[{"id":"a","text":"The more you practice, the more better your English becomes."},{"id":"b","text":"The harder you study, the best results you will get."},{"id":"c","text":"The harder you study, the better your results will be."},{"id":"d","text":"More harder you study, better your results will be."}]'::jsonb, 'c', 'The ''the + comparative … the + comparative'' structure requires a comparative form (not a superlative) in BOTH clauses. ''The harder … the better'' is correct. Option A wrongly doubles ''more'' and ''better''; option B uses the superlative ''best'' in the second clause; option D omits the definite article ''the'' and adds a redundant ''more'' before ''harder''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1b432f1-1cbc-574c-9660-5b7227a13d3a', 'e6171568-ac34-5461-a926-00b1198d046e', 'Complete the sentence with the correct form: "Among all the students in the school, Yasmine scored ___ marks on the national mock exam." (few)', '[{"id":"a","text":"the fewer"},{"id":"b","text":"the fewest"},{"id":"c","text":"the least few"},{"id":"d","text":"fewer than"}]'::jsonb, 'b', 'When comparing three or more (here: all students in the school), we use the superlative. ''Few'' forms its superlative as ''the fewest'' (regular short-adjective pattern: add -est). ''The fewer'' is the comparative, used only for two items. ''The least few'' is not a real form. ''Fewer than'' is a comparative requiring a second element to compare with.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('843870fc-8656-51d5-9c26-be88398192c7', 'e6171568-ac34-5461-a926-00b1198d046e', 'A student writes: "My handwriting is not as worse as my brother''s." Identify the error and choose the corrected version.', '[{"id":"a","text":"My handwriting is not as bad as my brother''s."},{"id":"b","text":"My handwriting is not as worst as my brother''s."},{"id":"c","text":"My handwriting is not more bad than my brother''s."},{"id":"d","text":"My handwriting is not as badly as my brother''s."}]'::jsonb, 'a', 'The ''as … as'' structure always requires the BASE (positive) form of the adjective — never the comparative or superlative. The base form of ''worse'' is ''bad'', so the correct sentence is ''not as bad as''. Using ''worse'' inside ''as…as'' is the most common trap with irregular adjectives. ''Badly'' is an adverb and cannot describe handwriting as a noun adjunct here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

