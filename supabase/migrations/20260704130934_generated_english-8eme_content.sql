-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: english-8eme (English)
-- Regenerate with: npm run content:build
-- Source of truth: content/english-8eme/
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
  ('english-8eme', 'English', 'Third year of English (8th year basic education, A2+): simple past, past continuous, be going to, comparatives and superlatives, first present perfect — across five modules', 'Agilite', 'subject-english', 'Globe', 5, 'en', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '8eme-base'))
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
      AND e.subject_id = 'english-8eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('6e896da6-f926-5249-8755-10b7be27c504', 'd293d22f-a8bd-57bf-b82b-18ae4783cbf2', '485dab6f-fe97-5426-aa71-fc92b6b32441', '850ff181-37f1-5f0c-b38a-b9dc61133bec', '1a6d4f1e-90d1-5f5b-a781-7ba68aeef654', '03754263-11df-5dc8-adc1-985f3d37433e', '7e9abeda-8ec3-5ecb-b20f-2267f6d48aeb', 'edb1a39c-85c4-5b14-ade3-844f8b0641f8', 'f39c9111-57cf-510d-909c-ee635288cb18', '3b1712fe-92aa-5c7a-86c8-3e2c84b422fd', 'da70ee56-4bc3-513c-990e-138574796f23', 'bff8883f-a315-5952-a28a-d72ce32c31de', '0df0b3e4-5c65-5638-843e-61553d560286', '8c60bb82-d3c5-5780-897b-349a26ab630b', '2ad4bfe5-cd4e-5345-b38d-9699cb4cdf44', '2a5d373c-e0f4-53c7-9cad-b8a9138aa9e1', 'ac543095-0c46-5663-bd5f-1d326b07625f', '121959fc-4208-573e-a3ea-ea5be2746802', '2e2a6828-f042-5b92-abcc-8ecb91d287bc', '41585982-fc57-57db-a51a-ee06d591bdd2', 'a91db15f-0f09-59a5-8389-abf17e5880cc', '0a4c0d98-1e0c-522b-a789-332ad6827430', 'c95b352f-ec73-5879-9e67-293f81951cfa', '87bec0d7-f176-5695-8b31-0f17bee5e31c', '50fc83db-51dc-56f6-924b-03cb1e6743c0', '6ba598f1-064d-5e08-b272-324649d965a2', '17c58751-f0b2-5fab-8a1e-a31bcedb8e68', '5454b35d-0ef0-55c9-8763-219b586b4268', '8896e144-b0c1-5b87-bb2f-374bbd8de6a9', '69f69cb9-d702-51be-823e-3621c04cb592', 'd3fa76fb-8f95-583c-b76c-542dbc68902b', '2f4dc41b-3cce-5656-a505-08987f51de08', '79ac71fd-31cc-5e73-92f0-430c5b9ceb9c', 'bc8463d9-3384-5401-857f-34651855d288', '827e71ba-8543-5bbc-bf40-1167eae5591c', '154d7ffc-ec62-5959-a10f-253f25f16dab', 'c7443018-df54-57b9-9d01-acc899b10b04', 'ad173e3c-c795-5f77-90d3-fd57c62701ab', '839ebb6f-c84e-5f6c-a615-6e8e997b04cc', '946dc4ff-21e2-5f8f-9a36-da9af6bf2f24', 'e7725d77-666b-5708-9b2c-9a7fd8673113', '6cfc47a2-e4d8-55d8-894e-c4d7b053ac89', '0dfa526f-8bec-59d5-ae8e-5607d52ab01d', 'af1d15e9-51a2-5a64-aaf8-beb30e6a251c', 'bf241c2f-9f6f-50d3-8a51-dcc9fafa7f91', '1db6b111-6777-588f-9965-f956a316372b', '92093aa7-a151-5bf9-a6e0-a5ec6e04fb76', '9f6c95e7-81ee-5c82-9bb1-cc0a444a8947', '135fb698-b491-58be-b3c8-5b60b571d73d', '3147faab-0056-5eab-a47d-76ed49b01ca2', '451eab83-214e-5c2a-8056-08f3a9a62032', 'e8a3a298-592e-58c1-bd70-05bb4972af56', '6c3233f8-d40a-59ca-86ca-112766ae9f86', 'a77ab1f4-46e6-5bce-bca8-1fd5148e924a', '102e97ae-c67d-5ba2-8a12-a69982229810', '8229a6c4-972a-5679-8a95-128a701d2b2a', '0941873b-9128-544c-8066-1bb3f16c1604', 'bc62effd-94ae-58bd-be3f-a2df3ae85dc1', '4c82e9e8-a7f5-5a04-a6ee-21ac2603d8cd', 'a5e2a159-0065-5a2a-bbcd-6f548dfbf073', 'ce2be746-d340-5fe9-8ead-0c820180131f', '816d5f64-5769-5434-8349-2d9e6949be1b', 'fe931afd-730d-5ba2-b1b6-d387345ad8e2', '1cdb05dd-7509-59f0-9293-dc72738ebbf5', '385b1d86-8847-5158-8744-70941570fb8c', 'cf9a8e2f-953f-533e-8fa2-52bc1080b0e1', 'dcc38b7f-cfb2-530b-be47-5761f0b15c78', '0b224cfb-09a9-549a-913c-a3ffbe9c6152', 'e0cbb4ec-376a-5fa2-9ab3-04bd7b5e4149', '5eec0ea5-844a-545e-bf99-04caf246e2b4', 'be2e6964-1e1e-5eed-a42e-b8b400c2f5f3', '7ee3843d-9c60-5857-b170-29762813b7cf', '32867a48-f1ca-5e71-a975-da294a6d762b', '8c1f56a4-a400-50f7-bcd5-6005e7042221', '03302a73-375d-58cb-9f85-eab91d003909', 'b49906c3-0120-59e7-a8da-8b9f84b2d9d5', '35780050-f4f9-50e1-9b9b-bfda780a352d', '9cebafab-a9c8-5299-86ca-a2b0c36d7621', 'e452a63a-ff6a-53df-bf82-7addc7382504', 'f4d5730f-347d-5949-a95e-91f4becae80c', 'b4d5e193-0550-57ed-9ddb-e0f49e3a6e11', 'afd0e208-dfc7-5014-82da-e8613c4151ec', '5d45447c-86fe-55d8-94a0-c1d2e8251626', '6a40ef5e-3297-5157-9d9e-10538f996f04', '126fbcdd-4b0b-5141-9e90-bc8e9e8d66ad', '9220be93-37d0-5cce-bd2d-aec0d1c8de13', '9eea069c-962b-5400-a9b0-718290460af2', '3b359af3-b95f-571d-a43e-181700632f76', 'cd5cb1a4-0f20-569c-921f-41d5b1708361', '46b2b5d1-39c0-5f1d-a737-14d408a34afd', 'd385ed0d-c2c2-5426-8c86-25fe3b347627', '1f44d2f8-eba0-52d6-ab1e-d5120996734c', 'c8ae438c-e8ae-5cb1-b967-d883295ae41b', '9244384c-b971-5fa4-91ed-c4ce946ed419', '024636e0-2c65-51ac-a9d4-e5d8e0aec546', '8408e232-4eb7-51a1-96c7-d7638f5cf304', '216f2b82-3853-5a19-8a18-2766091c07b2', '79ff7f03-ecd6-50c1-82ec-287f62cb68be', '6b0e10ac-3194-550c-b69e-3a57604c0800', '1739e207-19ce-58fb-8e70-e07f20a4ba1d', '00c0b5ab-ec9c-55aa-91dc-c017ccb3b18b', 'e161ff64-f172-512b-bf9f-39581b60c852', 'c53ffef4-4035-562c-aee3-08eab1dd985a', '416a83a3-64c7-5b7f-a108-5d787d5f29ff', 'ee55402f-2379-5d67-a68e-71aa5a2da723', 'bb57037d-e2c1-5186-9d5a-4b53f962b6c4', '1c0adfec-2884-5954-bd04-b06dab930149', 'b71aa2ec-31c3-5149-9790-3abe419abf8e', '204d5964-0e2c-523b-ae60-21b78b22824b', '6ecba4d4-1956-5362-8c97-e025aed63827', 'ceb8340e-c7e4-500c-9fcd-23c5575215b1', '3721bff2-3aea-5038-890e-d0f8579a46da', 'd533cfd1-ced5-52cc-8637-c38c322d0584', 'faeb92fb-52a3-5463-a003-8df2338740f4', '599c8e23-5b03-5c9b-a37a-42de3bc4dac1', '23f6c03d-4124-5b71-8486-8523c1757e57', '9603466f-25ba-506a-8218-f1dc4748b1d6', '5dc45c96-f8ad-5c15-945e-7e2dde6fcbed', '481f952b-6d37-58f2-b0cf-271a36882db9', '366b537d-eeb3-5c9d-8db6-e87ba33ace9c', '4c5021a3-b5f9-5747-8630-48a3e83c75d4', 'f6a4efe4-bd9c-523d-8b29-7e04758f06d9', '6a4f1a84-cf91-5264-8e22-28aef127c41f', 'dbb17bac-7c4d-5edd-96c9-076fe2f081e8', '9abe414e-c8a8-5b56-87b6-c867dc141a65', '61029271-fc9f-5f55-9680-64e32a597a66', '7e859f4c-2451-5095-beee-9870aabade96', '424535a1-54ab-5591-bd2b-daeb9b860fed', 'cf91fae8-e83b-5211-9974-c2615944cb87', 'f760ae53-b4ab-50ff-bedb-59e32cbfa370', 'aec8f4b3-7396-563f-87dd-b0257a65e4a5', 'fa8e9592-6117-5cab-9423-9fbec17b4688', 'f746c7ba-f17b-539b-b9e5-4c303acc644c', '0924afaa-5494-532f-9384-817a574161d1', 'a66b5dcc-6258-5797-a558-c76ba83840d3', 'c57edd91-01de-514f-8c44-6f852d2da469', 'ec9904a3-f69e-56e6-a03a-ee9540993b62', '161e5fcd-f671-531e-a6ab-5e3e1445aae7', 'e7b8a7f7-db33-5fd8-ab5d-32c5e298a387', '908c9945-1e76-5d23-acd5-6002d84d556f', '24b8097a-2614-5e50-aa73-d6c1c2bfdac0', '37df6fcc-3d75-5a95-9861-047e3dc11d9b', '0bc5042c-e622-5de9-bcce-93cbd2dafcba', '4af7c18a-172b-5472-ba37-e6a9a0874a98', '1d209772-ac27-5c18-a44f-059d60fb9306', 'bba198ff-7946-5612-a1ac-7f25450c5b34', 'f5267583-61a6-59b7-a628-e8331414e425', 'e30ebe7f-f653-50e4-b909-61a92169314d', 'b97a4a9a-73dc-51f9-a236-16997ea82112', 'c993d4b4-e7e7-55f1-95f3-f7fbf517d4fc', '3969ebfb-47e8-5ea3-9a6c-186af19c574e', '2cff6df7-36aa-5ba0-9425-5aabb0b7cdc4', 'dd54c768-add2-504f-9a9f-2c14320cad16', 'cf49986f-b2a5-506f-b593-26401a63f4fd', 'de601140-8b50-5228-9db4-04cf6eee6792', '85f2b6bf-3387-55cb-ac95-f224aa5f4559', 'a6e314d9-413a-5f52-8dd2-1857b447cefe', 'eec44695-6467-5b5e-8ddc-9efcddaff6e6', '97f0699d-dd1e-5e47-8acd-8c1bebfc5720', 'fc619b43-2703-5e7e-8ebd-11960c43fa8e', 'ff2f1322-e973-52ce-8641-df29c564693c', '94822db1-eb2c-5f50-bf81-f89c829fcb6a', 'bedf01a5-b530-5bc2-805c-5d1df36a5b20', '3e864177-7202-5001-8c59-b67952f9335d', 'ec4213db-7c62-5075-8f96-973ff111c541', 'ed7b3d1b-bf6f-5681-b1cc-f75359de3a9d', '5d58d29e-9ce3-5bb8-a6b4-91e9f08bcd83', 'c1d4de86-58ad-5d20-96d9-5138d8281e25', 'cf64af5b-d3a5-5202-9bec-5c7d780ebdd2', '3f708ebd-041b-582d-8269-affbfc01113a', '1741ce06-8d24-570b-a293-963917fb64c0', 'd66da828-b124-52b6-a085-3307b4ec5e17', 'd1700411-d219-53ff-8953-94231799ccb3', 'f993fe29-2390-5e93-83e4-fea06bab227c', 'e8a43e87-b3df-5df2-96d9-feb447cb7bbe', 'e2cab4cb-cd52-538d-a3be-d9a698adf115', '22d30e46-759c-5090-b757-6ee74772d0fd', 'ba9b2902-7f87-5adb-b6b7-55dc1e9fcba8', '33f62bf7-c10e-5fef-82ba-36da19638f98', '9167874b-e7dd-5b34-8486-c039555f9c21', '13b237d4-729d-55a3-b400-52736fffd4de', '75d8c09e-9f3a-595a-a888-e0a06862daa0', '59347358-9eed-513b-ae04-aef5ba1f7587', '81f366ec-e62f-5158-ab61-56926432edcd', '54cbe72a-5608-5104-9bcd-adcb94bf525a', '86b17051-a453-5156-a263-99635c483441', '8f28b9c8-02f9-54b4-8520-ad80b9794705', '63aabdc8-a11e-5dde-8943-387ff4625e11', 'd8051cff-8c14-5b31-87cf-1a02b801f0a4', '2de63065-bc2d-5152-b8ed-640020531faf', '8b5e0cf0-1a94-5174-9eb3-be7e52e935ec', '5e8feb18-1412-5ed3-b449-2b42611a409a', 'abe68686-69f6-5043-8c97-ad138d118fc2', '691b4306-e065-5971-84e6-c043bf294f7f', '799528f4-2c0c-5db9-aa19-1a571b4f271a', '511089a5-d69a-504b-ba27-ee9645304724', '813b35b2-771a-5168-a14f-4ef5546c6ca0', 'b68f9c02-7d67-5331-8d2b-6daed66d59b6', '042c44d6-3f0e-5eef-9312-fec5d3afc182', '32f0018f-28f5-5f29-88a9-acb18e72335f', '3f27a0cd-d4c3-5071-82c4-72f4a981f322', 'f00abe22-0a41-55ea-8ebb-7d2c2d28375a', '12c8f241-c89b-53cb-adac-0a4fcecf9ed3', '79549b3c-4206-56dd-8d22-cfd02a3297ef', '5123dfd2-4c91-5555-ac82-7df1abafef2c');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'english-8eme' AND source = 'admin' AND id NOT IN ('7a69559d-e11b-5994-98f3-d18aaa04840d', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', '989c4d1a-3c92-5e58-8d26-d64179caa517', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', '07b0652b-5604-5af6-a7e2-4be679888361', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'd64d3f1f-2643-5210-8781-e9d3672554a9', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'a03ad743-f697-5a7e-b97b-c11806eaf053', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', '6f570d6b-a70a-5202-918b-936631115254', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', '5ac21398-24b0-5f94-8b53-c954575c76c4', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', '388898c0-624b-55f6-a638-20e03d2dcb9e', '0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'b9cb3691-2338-550a-bc25-854171086d3f', '59f74f23-1064-5585-99f1-0d7f2b5c542b', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', '250dd9f0-7a15-501a-9591-45278ef7ad8e', '117f6371-2731-55ce-a449-362c86c1a14d', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'a3f91341-c437-59b9-9ada-ba333fe921c8');
DELETE FROM public.questions WHERE exercise_id IN ('7a69559d-e11b-5994-98f3-d18aaa04840d', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', '989c4d1a-3c92-5e58-8d26-d64179caa517', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', '07b0652b-5604-5af6-a7e2-4be679888361', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'd64d3f1f-2643-5210-8781-e9d3672554a9', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'a03ad743-f697-5a7e-b97b-c11806eaf053', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', '6f570d6b-a70a-5202-918b-936631115254', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', '5ac21398-24b0-5f94-8b53-c954575c76c4', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', '388898c0-624b-55f6-a638-20e03d2dcb9e', '0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'b9cb3691-2338-550a-bc25-854171086d3f', '59f74f23-1064-5585-99f1-0d7f2b5c542b', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', '250dd9f0-7a15-501a-9591-45278ef7ad8e', '117f6371-2731-55ce-a449-362c86c1a14d', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'a3f91341-c437-59b9-9ada-ba333fe921c8') AND id NOT IN ('6e896da6-f926-5249-8755-10b7be27c504', 'd293d22f-a8bd-57bf-b82b-18ae4783cbf2', '485dab6f-fe97-5426-aa71-fc92b6b32441', '850ff181-37f1-5f0c-b38a-b9dc61133bec', '1a6d4f1e-90d1-5f5b-a781-7ba68aeef654', '03754263-11df-5dc8-adc1-985f3d37433e', '7e9abeda-8ec3-5ecb-b20f-2267f6d48aeb', 'edb1a39c-85c4-5b14-ade3-844f8b0641f8', 'f39c9111-57cf-510d-909c-ee635288cb18', '3b1712fe-92aa-5c7a-86c8-3e2c84b422fd', 'da70ee56-4bc3-513c-990e-138574796f23', 'bff8883f-a315-5952-a28a-d72ce32c31de', '0df0b3e4-5c65-5638-843e-61553d560286', '8c60bb82-d3c5-5780-897b-349a26ab630b', '2ad4bfe5-cd4e-5345-b38d-9699cb4cdf44', '2a5d373c-e0f4-53c7-9cad-b8a9138aa9e1', 'ac543095-0c46-5663-bd5f-1d326b07625f', '121959fc-4208-573e-a3ea-ea5be2746802', '2e2a6828-f042-5b92-abcc-8ecb91d287bc', '41585982-fc57-57db-a51a-ee06d591bdd2', 'a91db15f-0f09-59a5-8389-abf17e5880cc', '0a4c0d98-1e0c-522b-a789-332ad6827430', 'c95b352f-ec73-5879-9e67-293f81951cfa', '87bec0d7-f176-5695-8b31-0f17bee5e31c', '50fc83db-51dc-56f6-924b-03cb1e6743c0', '6ba598f1-064d-5e08-b272-324649d965a2', '17c58751-f0b2-5fab-8a1e-a31bcedb8e68', '5454b35d-0ef0-55c9-8763-219b586b4268', '8896e144-b0c1-5b87-bb2f-374bbd8de6a9', '69f69cb9-d702-51be-823e-3621c04cb592', 'd3fa76fb-8f95-583c-b76c-542dbc68902b', '2f4dc41b-3cce-5656-a505-08987f51de08', '79ac71fd-31cc-5e73-92f0-430c5b9ceb9c', 'bc8463d9-3384-5401-857f-34651855d288', '827e71ba-8543-5bbc-bf40-1167eae5591c', '154d7ffc-ec62-5959-a10f-253f25f16dab', 'c7443018-df54-57b9-9d01-acc899b10b04', 'ad173e3c-c795-5f77-90d3-fd57c62701ab', '839ebb6f-c84e-5f6c-a615-6e8e997b04cc', '946dc4ff-21e2-5f8f-9a36-da9af6bf2f24', 'e7725d77-666b-5708-9b2c-9a7fd8673113', '6cfc47a2-e4d8-55d8-894e-c4d7b053ac89', '0dfa526f-8bec-59d5-ae8e-5607d52ab01d', 'af1d15e9-51a2-5a64-aaf8-beb30e6a251c', 'bf241c2f-9f6f-50d3-8a51-dcc9fafa7f91', '1db6b111-6777-588f-9965-f956a316372b', '92093aa7-a151-5bf9-a6e0-a5ec6e04fb76', '9f6c95e7-81ee-5c82-9bb1-cc0a444a8947', '135fb698-b491-58be-b3c8-5b60b571d73d', '3147faab-0056-5eab-a47d-76ed49b01ca2', '451eab83-214e-5c2a-8056-08f3a9a62032', 'e8a3a298-592e-58c1-bd70-05bb4972af56', '6c3233f8-d40a-59ca-86ca-112766ae9f86', 'a77ab1f4-46e6-5bce-bca8-1fd5148e924a', '102e97ae-c67d-5ba2-8a12-a69982229810', '8229a6c4-972a-5679-8a95-128a701d2b2a', '0941873b-9128-544c-8066-1bb3f16c1604', 'bc62effd-94ae-58bd-be3f-a2df3ae85dc1', '4c82e9e8-a7f5-5a04-a6ee-21ac2603d8cd', 'a5e2a159-0065-5a2a-bbcd-6f548dfbf073', 'ce2be746-d340-5fe9-8ead-0c820180131f', '816d5f64-5769-5434-8349-2d9e6949be1b', 'fe931afd-730d-5ba2-b1b6-d387345ad8e2', '1cdb05dd-7509-59f0-9293-dc72738ebbf5', '385b1d86-8847-5158-8744-70941570fb8c', 'cf9a8e2f-953f-533e-8fa2-52bc1080b0e1', 'dcc38b7f-cfb2-530b-be47-5761f0b15c78', '0b224cfb-09a9-549a-913c-a3ffbe9c6152', 'e0cbb4ec-376a-5fa2-9ab3-04bd7b5e4149', '5eec0ea5-844a-545e-bf99-04caf246e2b4', 'be2e6964-1e1e-5eed-a42e-b8b400c2f5f3', '7ee3843d-9c60-5857-b170-29762813b7cf', '32867a48-f1ca-5e71-a975-da294a6d762b', '8c1f56a4-a400-50f7-bcd5-6005e7042221', '03302a73-375d-58cb-9f85-eab91d003909', 'b49906c3-0120-59e7-a8da-8b9f84b2d9d5', '35780050-f4f9-50e1-9b9b-bfda780a352d', '9cebafab-a9c8-5299-86ca-a2b0c36d7621', 'e452a63a-ff6a-53df-bf82-7addc7382504', 'f4d5730f-347d-5949-a95e-91f4becae80c', 'b4d5e193-0550-57ed-9ddb-e0f49e3a6e11', 'afd0e208-dfc7-5014-82da-e8613c4151ec', '5d45447c-86fe-55d8-94a0-c1d2e8251626', '6a40ef5e-3297-5157-9d9e-10538f996f04', '126fbcdd-4b0b-5141-9e90-bc8e9e8d66ad', '9220be93-37d0-5cce-bd2d-aec0d1c8de13', '9eea069c-962b-5400-a9b0-718290460af2', '3b359af3-b95f-571d-a43e-181700632f76', 'cd5cb1a4-0f20-569c-921f-41d5b1708361', '46b2b5d1-39c0-5f1d-a737-14d408a34afd', 'd385ed0d-c2c2-5426-8c86-25fe3b347627', '1f44d2f8-eba0-52d6-ab1e-d5120996734c', 'c8ae438c-e8ae-5cb1-b967-d883295ae41b', '9244384c-b971-5fa4-91ed-c4ce946ed419', '024636e0-2c65-51ac-a9d4-e5d8e0aec546', '8408e232-4eb7-51a1-96c7-d7638f5cf304', '216f2b82-3853-5a19-8a18-2766091c07b2', '79ff7f03-ecd6-50c1-82ec-287f62cb68be', '6b0e10ac-3194-550c-b69e-3a57604c0800', '1739e207-19ce-58fb-8e70-e07f20a4ba1d', '00c0b5ab-ec9c-55aa-91dc-c017ccb3b18b', 'e161ff64-f172-512b-bf9f-39581b60c852', 'c53ffef4-4035-562c-aee3-08eab1dd985a', '416a83a3-64c7-5b7f-a108-5d787d5f29ff', 'ee55402f-2379-5d67-a68e-71aa5a2da723', 'bb57037d-e2c1-5186-9d5a-4b53f962b6c4', '1c0adfec-2884-5954-bd04-b06dab930149', 'b71aa2ec-31c3-5149-9790-3abe419abf8e', '204d5964-0e2c-523b-ae60-21b78b22824b', '6ecba4d4-1956-5362-8c97-e025aed63827', 'ceb8340e-c7e4-500c-9fcd-23c5575215b1', '3721bff2-3aea-5038-890e-d0f8579a46da', 'd533cfd1-ced5-52cc-8637-c38c322d0584', 'faeb92fb-52a3-5463-a003-8df2338740f4', '599c8e23-5b03-5c9b-a37a-42de3bc4dac1', '23f6c03d-4124-5b71-8486-8523c1757e57', '9603466f-25ba-506a-8218-f1dc4748b1d6', '5dc45c96-f8ad-5c15-945e-7e2dde6fcbed', '481f952b-6d37-58f2-b0cf-271a36882db9', '366b537d-eeb3-5c9d-8db6-e87ba33ace9c', '4c5021a3-b5f9-5747-8630-48a3e83c75d4', 'f6a4efe4-bd9c-523d-8b29-7e04758f06d9', '6a4f1a84-cf91-5264-8e22-28aef127c41f', 'dbb17bac-7c4d-5edd-96c9-076fe2f081e8', '9abe414e-c8a8-5b56-87b6-c867dc141a65', '61029271-fc9f-5f55-9680-64e32a597a66', '7e859f4c-2451-5095-beee-9870aabade96', '424535a1-54ab-5591-bd2b-daeb9b860fed', 'cf91fae8-e83b-5211-9974-c2615944cb87', 'f760ae53-b4ab-50ff-bedb-59e32cbfa370', 'aec8f4b3-7396-563f-87dd-b0257a65e4a5', 'fa8e9592-6117-5cab-9423-9fbec17b4688', 'f746c7ba-f17b-539b-b9e5-4c303acc644c', '0924afaa-5494-532f-9384-817a574161d1', 'a66b5dcc-6258-5797-a558-c76ba83840d3', 'c57edd91-01de-514f-8c44-6f852d2da469', 'ec9904a3-f69e-56e6-a03a-ee9540993b62', '161e5fcd-f671-531e-a6ab-5e3e1445aae7', 'e7b8a7f7-db33-5fd8-ab5d-32c5e298a387', '908c9945-1e76-5d23-acd5-6002d84d556f', '24b8097a-2614-5e50-aa73-d6c1c2bfdac0', '37df6fcc-3d75-5a95-9861-047e3dc11d9b', '0bc5042c-e622-5de9-bcce-93cbd2dafcba', '4af7c18a-172b-5472-ba37-e6a9a0874a98', '1d209772-ac27-5c18-a44f-059d60fb9306', 'bba198ff-7946-5612-a1ac-7f25450c5b34', 'f5267583-61a6-59b7-a628-e8331414e425', 'e30ebe7f-f653-50e4-b909-61a92169314d', 'b97a4a9a-73dc-51f9-a236-16997ea82112', 'c993d4b4-e7e7-55f1-95f3-f7fbf517d4fc', '3969ebfb-47e8-5ea3-9a6c-186af19c574e', '2cff6df7-36aa-5ba0-9425-5aabb0b7cdc4', 'dd54c768-add2-504f-9a9f-2c14320cad16', 'cf49986f-b2a5-506f-b593-26401a63f4fd', 'de601140-8b50-5228-9db4-04cf6eee6792', '85f2b6bf-3387-55cb-ac95-f224aa5f4559', 'a6e314d9-413a-5f52-8dd2-1857b447cefe', 'eec44695-6467-5b5e-8ddc-9efcddaff6e6', '97f0699d-dd1e-5e47-8acd-8c1bebfc5720', 'fc619b43-2703-5e7e-8ebd-11960c43fa8e', 'ff2f1322-e973-52ce-8641-df29c564693c', '94822db1-eb2c-5f50-bf81-f89c829fcb6a', 'bedf01a5-b530-5bc2-805c-5d1df36a5b20', '3e864177-7202-5001-8c59-b67952f9335d', 'ec4213db-7c62-5075-8f96-973ff111c541', 'ed7b3d1b-bf6f-5681-b1cc-f75359de3a9d', '5d58d29e-9ce3-5bb8-a6b4-91e9f08bcd83', 'c1d4de86-58ad-5d20-96d9-5138d8281e25', 'cf64af5b-d3a5-5202-9bec-5c7d780ebdd2', '3f708ebd-041b-582d-8269-affbfc01113a', '1741ce06-8d24-570b-a293-963917fb64c0', 'd66da828-b124-52b6-a085-3307b4ec5e17', 'd1700411-d219-53ff-8953-94231799ccb3', 'f993fe29-2390-5e93-83e4-fea06bab227c', 'e8a43e87-b3df-5df2-96d9-feb447cb7bbe', 'e2cab4cb-cd52-538d-a3be-d9a698adf115', '22d30e46-759c-5090-b757-6ee74772d0fd', 'ba9b2902-7f87-5adb-b6b7-55dc1e9fcba8', '33f62bf7-c10e-5fef-82ba-36da19638f98', '9167874b-e7dd-5b34-8486-c039555f9c21', '13b237d4-729d-55a3-b400-52736fffd4de', '75d8c09e-9f3a-595a-a888-e0a06862daa0', '59347358-9eed-513b-ae04-aef5ba1f7587', '81f366ec-e62f-5158-ab61-56926432edcd', '54cbe72a-5608-5104-9bcd-adcb94bf525a', '86b17051-a453-5156-a263-99635c483441', '8f28b9c8-02f9-54b4-8520-ad80b9794705', '63aabdc8-a11e-5dde-8943-387ff4625e11', 'd8051cff-8c14-5b31-87cf-1a02b801f0a4', '2de63065-bc2d-5152-b8ed-640020531faf', '8b5e0cf0-1a94-5174-9eb3-be7e52e935ec', '5e8feb18-1412-5ed3-b449-2b42611a409a', 'abe68686-69f6-5043-8c97-ad138d118fc2', '691b4306-e065-5971-84e6-c043bf294f7f', '799528f4-2c0c-5db9-aa19-1a571b4f271a', '511089a5-d69a-504b-ba27-ee9645304724', '813b35b2-771a-5168-a14f-4ef5546c6ca0', 'b68f9c02-7d67-5331-8d2b-6daed66d59b6', '042c44d6-3f0e-5eef-9312-fec5d3afc182', '32f0018f-28f5-5f29-88a9-acb18e72335f', '3f27a0cd-d4c3-5071-82c4-72f4a981f322', 'f00abe22-0a41-55ea-8ebb-7d2c2d28375a', '12c8f241-c89b-53cb-adac-0a4fcecf9ed3', '79549b3c-4206-56dd-8d22-cfd02a3297ef', '5123dfd2-4c91-5555-ac82-7df1abafef2c');
DELETE FROM public.chapters c WHERE c.subject_id = 'english-8eme' AND c.id NOT IN ('c3b638b8-612d-5268-b5e7-9abe716fcc31', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', '6e15a491-165d-5946-8e81-a0e4a0f75e74', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', 'The College Years', 'Module 1 — Self and school: reviewing the simple present and adverbs of frequency, then mastering the simple past of regular and irregular verbs (affirmative, negative and questions) and asking for information with WH-questions', '# ⚔️ The College Years — Every Hero Remembers Their First Battles

> 💡 "You cannot tell the story of your adventure until you master the tense of the past."

Welcome back, hero. You already know how to talk about **who you are** and **what you do every day** from your first years of English. This module gives you a new weapon: the power to tell what **happened** — yesterday, last week, or years ago. First, a quick warm-up on the present.

## 🏰 Warm-up: the simple present (your everyday power)

Use the **simple present** for **habits, routines and facts** — things that are true again and again.

| Form        | Rule                                  | Example                                      |
| ----------- | ------------------------------------- | -------------------------------------------- |
| Affirmative | base verb; **-s / -es** for he/she/it | _Skander **plays** football every Saturday._ |
| Negative    | **don''t / doesn''t** + base verb       | _Nour **doesn''t like** tea._                 |
| Question    | **Do / Does** + subject + base verb   | _**Does** Yassine **walk** to school?_       |

Spelling of the third person: _study → **studies**_, _go → **goes**_, _watch → **watches**_, _do → **does**_.

> ⚠️ After **doesn''t** the verb drops its **-s**: _she **doesn''t play**_ ✓ — never "doesn''t plays".

## ⏰ Adverbs of frequency — how often?

These words say **how often** something happens:

| Adverb        | How often?           |
| ------------- | -------------------- |
| **always**    | every time (100%)    |
| **usually**   | most times (≈ 80%)   |
| **often**     | many times (≈ 60%)   |
| **sometimes** | now and then (≈ 40%) |
| **rarely**    | almost never (≈ 10%) |
| **never**     | not one time (0%)    |

**Position rule**: the adverb goes **before a main verb**, but **after the verb "to be"**:

- _Rania **always reads** before bed._ (before "reads") — _Yassine **is never** late._ (after "is")

This rule works in the past too: _My grandfather **was never** late for prayer._

> ⚠️ Never say "she reads always" or "he never is late" — learn the two positions by heart.

## ⚡ The simple past — regular verbs (add **-ed**)

Use the **simple past** for a **finished action at a definite past time** (yesterday, last week, in 2019, two years ago). For **regular** verbs, add **-ed**:

| Verb ends in…                   | Rule           | Example                                      |
| ------------------------------- | -------------- | -------------------------------------------- |
| most verbs                      | + **ed**       | _play → **played**_, _watch → **watched**_   |
| a silent **-e**                 | + **d**        | _like → **liked**_, _arrive → **arrived**_   |
| consonant + **y**               | **y → ied**    | _study → **studied**_, _carry → **carried**_ |
| one short vowel + one consonant | double it + ed | _stop → **stopped**_, _plan → **planned**_   |

**Pronunciation of -ed** — three sounds: **/t/** (_worked, watched_), **/d/** (_played, cleaned_), and **/ɪd/** — an **extra syllable** — only after **t** or **d** (_visited, wanted, needed_).

## 🗡️ The simple past — irregular verbs (learn by heart)

Many common verbs are **irregular**: they do **not** take -ed. There is no rule — you memorise them.

| Base | Past     | Base  | Past  | Base  | Past   |
| ---- | -------- | ----- | ----- | ----- | ------ |
| be   | was/were | go    | went  | have  | had    |
| do   | did      | see   | saw   | eat   | ate    |
| take | took     | write | wrote | buy   | bought |
| tell | told     | win   | won   | find  | found  |
| read | read     | come  | came  | break | broke  |

> 🗡️ **read → read**: the spelling never changes, but the past is said /red/. And after _did_, even irregular verbs go back to the base: _Did she **read** it?_ ✓

> ⚠️ Classic trap: adding -ed to an irregular verb — "**goed**", "**buyed**", "**telled**" are all wrong. It is _went_, _bought_, _told_ ✓.

## 🛡️ The simple past — negative and questions

For the negative and questions, use the helper **did** — and the main verb goes **back to its base form** (no -ed, no irregular):

- **Negative**: subject + **didn''t** + base — _We **didn''t see** the film._ (never "didn''t saw")
- **Question**: **Did** + subject + base — _**Did** you **finish** your homework?_
- **Short answers**: _**Yes, I did.** / **No, I didn''t.**_

> ⚠️ Never keep the past form after **did / didn''t**: _"Did she **read**?"_ ✓ — "Did she read**ed**?" ✗ · _"I **didn''t go**"_ ✓ — "I didn''t **went**" ✗. And never use a **double negative**: _I **never did** it._ ✓ — "I never did it **not**." ✗

## 🔮 WH-questions — asking for information

To ask for information, start with a **WH-word**: **Who** (person), **What** (thing), **Where** (place), **When** (time), **Why** (reason), **How** (manner), **What time**, **How many** (number), **How often** (frequency).

The word order is **WH-word + auxiliary (do/does/did) + subject + base verb**:

- _**Where did** you **go** last summer?_ — _**What time does** the match **start**?_ — _**How often do** you **go** swimming?_

**Special case — subject questions.** When **who** or **what** is the **subject** (the doer), there is **no** do/does/did, and the verb keeps its tense:

- _**Who broke** the window?_ ✓ (not "Who did break…") — because _Firas_ (the subject) broke it.
- But when we ask about the **object**, we still need the helper: _**Who did** they **meet**?_ ✓

## 🧭 Present or past? Read the signal words

The little time words tell you which tense to use:

- **Present** → _every day, usually, now, on Mondays_ → _Usually I **take** the bus._
- **Past** → _yesterday, last week, in 2019, two years ago_ → _but yesterday I **took** a taxi._

> 🏆 Gate one cleared, hero! You can now tell the story of your day, your weekend and your childhood in English. Next stop: **Module 2** — a Tunisian teenager is invited to London, and you''ll learn to describe people and compare them.', '# 📜 Summary: The College Years

- **Simple present** — habits and facts; add **-s/-es** for he/she/it; negatives and questions with **do/does** + base verb (_doesn''t play_, never "doesn''t plays").
- **Adverbs of frequency** — always, usually, often, sometimes, rarely, never; go **before a main verb** but **after "to be"** (_she always reads_ / _he is never late_) — same rule in the past.
- **Simple past — regular verbs** — finished past actions take **-ed**; spelling: _liked_, _studied_, _stopped_; the -ed is said /t/, /d/, or /ɪd/ (extra syllable after t/d: _visited_).
- **Simple past — irregular verbs** — no rule, learn them: _go→went, see→saw, eat→ate, take→took, write→wrote, buy→bought, tell→told, win→won, read→read_; never add -ed ("goed", "buyed" are wrong).
- **Past negative & questions** — **didn''t** + base and **Did** + subject + base; the verb returns to its base (_didn''t see_, _Did you go?_); no double negative.
- **WH-questions** — Who/What/Where/When/Why/How/What time/How many/How often + auxiliary + subject + base verb; but a **subject question** (Who broke…?) takes no do/did.
- **Signal words** — _every day, usually, now_ → present; _yesterday, last week, ago, in 2019_ → past.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', 'Invited to London', 'Module Two — Daily life and describing: telling a trip in the simple past (regular and irregular verbs, negatives, questions), the past continuous for actions in progress (was/were + verb-ing) with when and while, describing people (physical and personality adjectives) and places, and comparing two things with the comparative (-er than, more … than, irregular better/worse)', '# ⚔️ Invited to London — A Tunisian Hero in a Big City

> 💡 "Tell your adventure, paint the scene, describe the people — and you turn a trip into a story worth listening to."

Anis, a 13-year-old boy from **Bizerte**, spent last July in London. His English pen-friend, **Oliver** (14), and Oliver''s family, the **Bakers**, invited him. In this gate you learn to tell that trip, describe what he saw, and compare his two worlds.

## 🏰 The simple past — telling what happened

You met the simple past in Module One. We use it for **finished actions at a definite past time**.

- **Regular verbs**: add **-ed**. _land → **landed**_, _visit → **visited**_, _travel → **travelled**_ (double the last consonant), _study → **studied**_ (change -y to -ied).
- **Irregular verbs**: no rule — you memorise them.

| Base | Past | Base  | Past   |
| ---- | ---- | ----- | ------ |
| go   | went | take  | took   |
| fly  | flew | buy   | bought |
| meet | met  | speak | spoke  |
| see  | saw  | have  | had    |
| eat  | ate  | come  | came   |

- **Negative**: **did not (didn''t)** + the **base** verb. _Anis **didn''t get** lost._
- **Question**: **Did** + subject + **base** verb? _**Did** you **visit** the museum?_
- **Signal words**: yesterday, last week, last July, two days **ago**, in 2023.

> ⚠️ After **did / didn''t**, the verb goes back to its base form. Say _Did she **go**?_ / _He **didn''t go**._ — never _~~Did she went~~_ or _~~didn''t went~~_.

## ⚡ The past continuous — the scene behind the action

We use the past continuous for an action **that was in progress at a moment in the past**. Form: **was / were + verb-ing**.

| Subject           | Example                            |
| ----------------- | ---------------------------------- |
| I / he / she / it | I **was watching** the parade.     |
| you / we / they   | They **were walking** in the park. |

- **Negative**: was/were + **not** + -ing. _The birds **weren''t singing**._
- **Question**: Was/Were + subject + -ing? _**Were** you **sleeping** at 8 p.m.?_

> ⚠️ You need **two** parts: the verb **be** (was/were) **and** the **-ing**. Say _He **was going**_ — never _~~He was go~~_ or _~~He were walk~~_.

## 🔮 When and while — background meets interruption

The past continuous sets the scene; a short past-simple action **cuts into** it.

- **when** + past simple interrupts a past continuous: _Anis **was taking** a photo **when** the bus **passed** by._
- **while** + past continuous for the ongoing action: _**While** the children **were eating**, the doorbell **rang**._

> 🗡️ Long background action → **past continuous** (was/were + -ing). Short event that interrupts → **past simple**.

## 🛡️ Describing people — body and character

To describe someone, use adjectives **before a noun** or after **be**.

- **Physical (the body)**: **tall**, **short**, **slim**, and hair can be **curly** or straight — _Emma is **slim** and has **curly** hair._
- **Personality (the character)**: **kind**, **generous** (loves sharing), **cheerful** (always happy), **funny**, **friendly**, **shy** (does not talk much to new people), **rude** (not polite) — _Mrs Baker is very **kind** and **generous**._

> ⚠️ Don''t mix the two: **slim** and **tall** describe the body; **kind** and **cheerful** describe the character.

## 🗺️ Describing places — the city and the village

London gave Anis many new words for places:

- **big** and **huge** (very big), **crowded** (full of people), **noisy** (full of sound), **modern** (new), **famous** (everybody knows it) — _Oxford Street was **crowded** and **noisy**._
- The old part had **narrow** (not wide) streets, **quiet** (calm) corners and **ancient** (very, very old) houses; some places felt **empty**.

## 🧮 Comparatives — comparing two things

To compare **exactly two** things, use the **comparative** with **than**.

- **Short adjectives** (one syllable, or two ending in -y): add **-er**.

| Adjective | Comparative  | Spelling note             |
| --------- | ------------ | ------------------------- |
| tall      | taller than  | just add -er              |
| old       | older than   | just add -er              |
| big       | bigger than  | double the last consonant |
| hot       | hotter than  | double the last consonant |
| busy      | busier than  | change -y to -ier         |
| happy     | happier than | change -y to -ier         |

- **Long adjectives** (two or more syllables): use **more … than** — _more **expensive** than_, _more **crowded** than_, _more **difficult** than_, _more **beautiful** than_.
- **Irregular**: **good → better than**, **bad → worse than**.

_London is **bigger than** Bizerte, but the tea was **worse than** Tunisian tea!_

> ⚠️ Three classic traps: never _~~more big~~_ (short adjective → **bigger**), never _~~gooder~~_ or _~~badder~~_ (→ **better / worse**), and never double it as _~~more taller~~_ (choose **-er** OR **more**, not both).

> 🗡️ To compare **exactly two** things we use the comparative + **than**. The **-est / most** form (the tallest, the most crowded) is for three or more — you meet it in the next module, not here.

> 🏆 Gate two cleared, hero! You can now tell a whole trip, freeze the scene with the past continuous, describe people and places, and compare your two worlds. Next stop: Module Three — plans for the future and the wonders of the city!', '# 📜 Summary: Invited to London

- **Simple past** = finished past actions: regular **-ed** (landed, studied, travelled), irregular memorised (go→went, fly→flew, meet→met, take→took, buy→bought, speak→spoke) · negative **didn''t + base** · question **Did + subject + base** · signals: yesterday, last July, two days ago. Never "didn''t went".
- **Past continuous** = action in progress in the past: **was/were + verb-ing** · negative weren''t + -ing · question Was/Were + subject + -ing. You need BOTH be **and** -ing — never "was go".
- **When / while**: past continuous = the background (was/were + -ing), past simple = the short action that interrupts it. _I was taking a photo **when** the bus passed._
- **Describing people**: physical — tall, short, slim, curly hair · personality — kind, generous, cheerful, funny, friendly, shy, rude. Body ≠ character.
- **Describing places**: big/huge, crowded, noisy, modern, famous · narrow, quiet, ancient, empty.
- **Comparatives** (compare TWO, with **than**): short adj + **-er** (taller, bigger — double consonant, busier — -y→-ier) · long adj **more … than** (more expensive, more crowded) · irregular **better / worse**. Traps: not "more big", not "gooder/badder", not "more taller". The -est/most form is for three or more (next module).', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', 'Discoveries and Plans', 'Module Three — Discoveries & Plans: talking about future plans and intentions with be going to (affirmative, negative and questions, plus predictions from present evidence), comparing places and things with comparatives and superlatives (short -er/-est, long more/the most, irregular good/bad/far and their spelling rules), and giving directions and making suggestions (Let''s, Why don''t we, Shall we, How about + -ing, We could).', '# ⚔️ Discoveries and Plans — Map Your Journey in English

> 💡 "A true explorer plans the road ahead and knows what is **bigger**, **older** and **the best**."

## 🗺️ Be going to — your plans and intentions

When you have **decided** to do something before you speak, use **be going to** + the base verb.

**be (am / is / are) + going to + base verb**

| Subject         | Form                                                |
| --------------- | --------------------------------------------------- |
| I               | I **am going to** visit the museum.                 |
| he / she / it   | Skander **is going to** buy a souvenir.             |
| you / we / they | We **are going to** take the Tube to Oxford Street. |

Choose **am / is / are** by looking at the subject, then add **going to** and the plain verb. _Yosra **is going to** send a postcard to her family in Tunis._

> ⚠️ The most common trap is adding an ending or dropping a word: it is **is going to visit** — NOT "is going to _visits_", NOT "is going _visit_" (you must keep **to**), NOT "she _going to_ visit" (you must keep **is**).

## ❓ Be going to — negatives and questions

- **Negative**: put **not** after am / is / are → _We **aren''t going to** take our umbrellas._
- **Question**: put am / is / are **before** the subject → _**Are** you **going to** visit the Tower of London?_

| Type     | Example                                          |
| -------- | ------------------------------------------------ |
| Negative | He **isn''t going to** walk; it is too far.       |
| Question | **Is** Skander **going to** buy the red T-shirt? |

We also use **be going to** for a **prediction we can see coming** — evidence in front of us: _Look at those dark clouds! It **is going to** rain._

> 🗡️ In a question, **are/is** never disappears and never becomes "do": say **Are** you going to…?, NOT "**Do** you going to…?".

## 📏 Comparatives — comparing two things (…-er / more … than)

To compare **two** things, use a comparative + **than**.

| Adjective type               | Rule                | Example                                 |
| ---------------------------- | ------------------- | --------------------------------------- |
| **short** (1 syllable)       | add **-er + than**  | tall → **taller than**, cheap → cheaper |
| short ending consonant+e     | add **-r**          | nice → **nicer**, wide → wider          |
| short: 1 vowel + 1 consonant | **double** it + -er | big → **bigger**, hot → hotter          |
| ending in **-y**             | **y → -ier**        | happy → **happier**, busy → busier      |
| **long** (2+ syllables)      | **more … than**     | expensive → **more expensive than**     |

_London is **bigger than** Tunis._ — _The museum is **more interesting than** the shopping street._

> ⚠️ Never mark the comparative **twice**. It is **taller**, not "more taller"; and it is **more modern**, not "moderner". Use **-er** OR **more**, never both, and never "more" on a short adjective.

## 🏆 Superlatives — the top of the group (the …-est / the most …)

To say something is **number one** in a group of three or more, use a superlative — and never forget **the**.

| Adjective type          | Rule               | Example                                   |
| ----------------------- | ------------------ | ----------------------------------------- |
| **short** (1 syllable)  | **the …-est**      | tall → **the tallest**                    |
| short: double / -e / -y | same spelling rule | big → **the biggest**, busy → the busiest |
| **long** (2+ syllables) | **the most …**     | famous → **the most famous**              |

_The Shard is **the tallest** building in London._ — _It was **the most exciting** day of the trip._

> ⚠️ Do not mix the two, and do not drop **the**: say **the tallest** (not "the most tallest", not "tallest" alone) and **the most expensive** (not "the more expensive").

## 💥 Irregular comparatives and superlatives

A few very common adjectives do not follow any rule — learn them by heart:

| Adjective | Comparative        | Superlative      |
| --------- | ------------------ | ---------------- |
| **good**  | **better** (than)  | **the best**     |
| **bad**   | **worse** (than)   | **the worst**    |
| **far**   | **farther** (than) | **the farthest** |

_The weather is **better** in summer._ — _That was **the best** meal of the trip._

> ⚠️ There is no "gooder", "more good", "the goodest" or "the most best" — use **better / the best** and **worse / the worst**.

## 🧭 Finding your way — directions and suggestions

To **give directions**, use the base verb (an order): **go straight on**, **turn** left / right, **take** the first / second **turning**, **go past** the bank, **cross** the road. Say where it is with **on your left / right**, **opposite** the park, **next to** the café, **at the corner**, near the **traffic lights**.

_**Go** straight on, then **turn** right; the station is **opposite** the market._

To **make a suggestion**, use one of these patterns:

| Pattern          | Followed by     | Example                           |
| ---------------- | --------------- | --------------------------------- |
| **Let''s**        | base verb       | **Let''s** take the bus.           |
| **Why don''t we** | base verb       | **Why don''t we** take a taxi?     |
| **Shall we**     | base verb       | **Shall we** meet at noon?        |
| **We could**     | base verb       | **We could** visit the market.    |
| **How about**    | verb **+ -ing** | **How about** visiting Hyde Park? |

> ⚠️ After **How about**, the verb takes **-ing** (_How about **visiting**_, NOT "How about visit"). After **Let''s / Shall we / Why don''t we / We could**, use the **plain** verb, never "to" (_Let''s **go**_, NOT "Let''s _to go_").

> 🏆 Gate three cleared, explorer! You can now plan your future with **be going to**, judge what is **bigger** and **the best**, and guide anyone through the city. Next you sail to **Edinburgh**, where you''ll tell what you **have** already **done** with the present perfect.', '# 📜 Summary: Discoveries and Plans

- **Be going to (plans)**: am / is / are + **going to** + base verb → _I am going to visit_, _she is going to buy_, _we are going to take_. Keep both **be** and **to**: never "going visit", never "is going to visits".
- **Be going to (negative & question)**: negative = am/is/are + **not** + going to (_we aren''t going to walk_); question = am/is/are **before** the subject (_Are you going to visit…?_). Also for a **prediction from evidence**: _dark clouds → it is going to rain_.
- **Comparatives (two things, + than)**: short adjective **-er** (taller, cheaper), double the consonant (big → bigger), -y → -ier (happy → happier); long adjective **more … than** (more expensive). Never both: not "more taller", not "moderner".
- **Superlatives (top of a group, keep "the")**: short **the …-est** (the tallest, the biggest, the busiest); long **the most …** (the most famous). Not "the most tallest", not "the more expensive".
- **Irregular**: good → **better / the best**; bad → **worse / the worst**; far → **farther / the farthest**. Never "gooder", "the most best".
- **Directions**: base verb — go straight on, turn left/right, take the first/second turning, go past, cross the road; on your left/right, opposite, next to, at the corner, traffic lights.
- **Suggestions**: **Let''s / Why don''t we / Shall we / We could** + base verb; **How about** + verb **-ing**. Not "Let''s to go", not "How about visit".', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', 'An English Family in Edinburgh', 'Module Four — a family spends the Easter holidays in Edinburgh, Scotland: first exposure to the present perfect (have / has + past participle) to talk about experiences up to now, have vs has agreement, regular and irregular past participles, ever / never / just, travel and holidays vocabulary (airport, flight, luggage, passport, hotel, tourist, souvenirs), and asking for and giving information (Excuse me…, Could you tell me…?, go straight ahead, turn left).', '# ⚔️ An English Family in Edinburgh — Your First Present Perfect

> 💡 "A traveller who has crossed the sea can tell a thousand stories: unlock the tense that links your past to your **now**."

## 🏰 The present perfect — a bridge from the past to now

You already know the **simple past** (_We **visited** the castle yesterday_). Now meet a new tense that talks about your life **up to now**, without saying exactly when: the **present perfect**.

Build it with two pieces:

$$ have / has + past participle $$

- _I **have visited** Edinburgh._ (some time in my life — the door to a new tense is open)
- _Sarra **has packed** her suitcase._ (it is packed now)

You use it to talk about an **experience** or a result that still matters **now** — the time is not important, the fact is. _We **have arrived** in Scotland!_ means: we are here now.

> 🗡️ First rule to remember: after **have / has** you never put the base verb alone. Say _I **have visited**_, never "I have **visit**".

## ⚡ Have or has? — the golden agreement

The first piece changes with the subject. This is the trap most students fall into.

| Subject                    | Auxiliary | Example                             |
| -------------------------- | --------- | ----------------------------------- |
| I · you · we · they        | **have**  | _They **have** booked a hotel._     |
| he · she · it (one person) | **has**   | _My father **has** booked a hotel._ |

So it is _She **has** travelled_, never "She **have** travelled". Plural or "I/you/we/they" → **have**; one other person or thing → **has**.

> ⚠️ Classic trap: mixing the auxiliary. _My parents **have** arrived_ (they → have) but _My mother **has** arrived_ (she → has).

## 🔮 Past participles — regular and irregular

The **past participle** is the second piece. For **regular verbs**, it is simply the verb **+ -ed** — the same as the simple past:

_visit → **visited** · pack → **packed** · arrive → **arrived** · stay → **stayed** · travel → **travelled**_

Many common travel verbs are **irregular** — you must learn these by heart:

| Verb  | Past participle      | Verb  | Past participle |
| ----- | -------------------- | ----- | --------------- |
| be    | **been**             | eat   | **eaten**       |
| go    | **gone**             | see   | **seen**        |
| take  | **taken**            | write | **written**     |
| do    | **done**             | buy   | **bought**      |
| meet  | **met**              | fly   | **flown**       |
| leave | **left**             | ride  | **ridden**      |
| read  | **read** (say "red") |       |                 |

_We have **seen** the castle. · She has **taken** many photos. · They have **flown** to Scotland._

> ⚠️ Do not use the **simple past** as the participle: it is "has **eaten**" (not "has **ate**"), "have **seen**" (not "have **saw**"), "has **gone**" (not "has **went**"). And never invent a regular ending for an irregular verb: "goed", "flied", "buyed", "readed" do not exist.

## 🛡️ Ever, never and just — talking about experiences

Two little words turn the present perfect into a question or a life-experience:

- **ever** = "at any time in your life", used in **questions**: _**Have** you **ever** eaten haggis?_
- **never** = "not at any time", a negative experience: _I have **never** seen snow._

Put **ever / never** **between** the auxiliary and the participle: _Has she **ever** visited a castle?_ · _We have **never** flown before._

Use **just** the same way for something that happened a moment ago: _The plane has **just** landed._

> 🗡️ Word order matters: it is _has **just** landed_ and _have **never** been_ — the little word sits **after have/has** and **before** the participle.

## 🧳 Travel and holidays — the vocabulary of the journey

A trip to Edinburgh needs the right words:

- At the **airport**: you **check in** your **luggage** (your bags / **suitcases**), show your **passport** at passport control, wait at the **boarding gate**, then take your **flight**.
- On **holiday**: you stay in a **hotel**, visit a **castle**, a **museum** or the **old town**, buy **souvenirs** and postcards, read a **guidebook**, and you are a **tourist**.

_Our family has booked a **hotel** near the **castle**, and Amine has bought **souvenirs** for his friends in Tunis._

## 🗺️ Asking for and giving information

When you are lost in a new city, be polite. Start a question with **Excuse me**, and ask for information with **Could you tell me…?**:

- _**Excuse me**, how do I get to the museum?_
- _**Could you tell me** where the castle is, please?_

Notice **tell** (tell **me** something) is not **say**: we say _Could you **tell** me…_, not "Could you say me".

To **give** directions, use: _**go straight ahead**, then **turn left / turn right** at the bank, and it is **on your left**._

> 🏆 Gate four cleared, traveller! You have opened your first present perfect, packed your luggage and found your way through Edinburgh. In Module Five you will explore **relationships** — friends, family and the world around you.', '# 📜 Summary: An English Family in Edinburgh

- **Present perfect** = **have / has + past participle**, to talk about an experience or a result up to now, without saying exactly when (_I have visited Edinburgh_). Never the base verb after have/has ("have visit" is wrong).
- **Have or has?**: **have** with I, you, we, they (and plural nouns); **has** with he, she, it (one person/thing). _She **has** travelled_, not "she have".
- **Past participles**: regular = verb **+ -ed** (visited, packed, arrived, stayed); irregular learned by heart — **been, gone, seen, taken, done, met, left, read, eaten, written, bought, flown, ridden**. Never the simple past as participle ("has ate / has went / have saw") and never "goed/buyed/readed".
- **Ever / never / just**: **ever** in questions (_Have you **ever** eaten haggis?_), **never** for "not once" (_I have **never** seen snow_), **just** for a moment ago (_The plane has **just** landed_) — always **between** have/has and the participle.
- **Travel & holidays lexis**: airport, check in, luggage / suitcase, passport, boarding gate, flight, hotel, castle, museum, old town, tourist, guidebook, souvenirs, postcards.
- **Asking for / giving information**: start with **Excuse me**; ask with **Could you tell me…?** (tell me, not "say me"); give directions with **go straight ahead, turn left / right, it is on your left**.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', 'Relationships', 'Module 5 — the people and living things around us: giving advice with should / shouldn''t, strong rules with must / mustn''t, expressing your opinion and your feelings, talking about relationships (parents, friends, pets, the environment), and describing how we act with adverbs of manner (-ly)', '# ⚔️ Relationships — The Bonds That Make a Hero

> 💡 "A true hero is measured by the way they treat others: their parents, their friends, their pets and the very planet they live on."

Welcome to the final gate of your 8th-year journey, hero! You already know how to talk about the past and make plans for the future. Now you will learn to **give advice**, **state the rules**, **share your opinion and feelings**, and **describe how people act** — the language of **relationships**.

## 🛡️ Giving advice — should / shouldn''t

When you want to tell someone what is **a good idea** — friendly advice, a recommendation — use the modal **should** (and **shouldn''t** = _should not_ for a bad idea). The pattern is simple:

$$ subject + should / shouldn''t + base verb $$

- _Sami is tired. He **should rest** for an hour._
- _You **shouldn''t tell** lies to your best friend._
- _We **should help** our parents at home._

> ⚠️ After **should**, the verb NEVER takes "to": _You **should see** a doctor_ ✓ — "You should **to** see a doctor" ✗. And there is no -s with he/she: _She **should call** her grandmother_ ✓ — not "she should**s**".

## ⚡ Strong rules — must / mustn''t

**Should** is only advice. When something is **necessary** or an **obligation** — a rule, a law, a duty — use the stronger modal **must**. Its negative **mustn''t** (= _must not_) means something is **forbidden**, not allowed:

- _At the traffic light, you **must stop** your car._ (it is the law)
- _You **mustn''t drop** litter in the park._ (it is forbidden)
- _Nour **must finish** her homework before she plays._ (a duty)

| Modal         | Meaning           | Example                             |
| ------------- | ----------------- | ----------------------------------- |
| **should**    | it is a good idea | _You should drink water._           |
| **shouldn''t** | it is a bad idea  | _You shouldn''t eat too much sugar._ |
| **must**      | it is necessary   | _You must wear a helmet on a bike._ |
| **mustn''t**   | it is forbidden   | _You mustn''t smoke here._           |

> 🗡️ **mustn''t** is one word for "must not" — both are correct, but never say "you must**n''t** to go" (no "to" after a modal!) and don''t confuse **shouldn''t** (just a bad idea) with **mustn''t** (strictly forbidden).

## 🔮 Expressing your opinion

To share what you **believe**, English gives you a set of ready-made openers:

- _**I think (that)** friendship is very important._
- _**In my opinion**, pollution is our biggest problem._
- _**I believe** every child should have a pet._

To react to someone else''s idea, **agree** or **disagree**:

- Agree: _**I agree with you.** / You''re right._
- Disagree: _**I disagree.** / I don''t think so._

> ⚠️ After **I think** and **In my opinion** you give your own idea — don''t answer a question with them. And it is _I **agree with** you_ (never "I am agree").

## 🧡 Talking about feelings

To say how you **feel**, use **feel + adjective** (an adjective, never an adverb):

$$ I feel + adjective $$

- _I **feel happy** when my team wins._ ✓ — not "I feel happil**y**".
- _Rami **feels nervous** before the exam._

Learn the family of feeling adjectives: **happy · sad · angry · afraid (scared) · proud · worried · excited · nervous · lonely · jealous · bored**. Ask about feelings with _**How do you feel?**_

## 🏡 Relationships — parents, friends, pets and the environment

Module Five is about the **bonds** around you. Build your vocabulary:

- **Family**: _get on well with_ your parents, _respect_ and _help_ them, _share_ with your brothers and sisters, and try not to _argue_ (quarrel).
- **Friends**: a _best friend_, _make friends_, _trust_ and _support each other_ — good friends never _let you down_.
- **Pets**: you must _look after_ (take care of) your pet — _feed_ it, give it water and love.
- **The environment**: _protect the environment_, _recycle_, _save water_, _plant trees_ and _don''t drop litter_.

> 🗡️ _look after_ and _take care of_ mean the same thing: _Leila **looks after** her cat every day_ = _she **takes care of** it_.

## 🎯 Adverbs of manner — the -ly family

To describe **HOW** someone does something, turn an adjective into an **adverb of manner** by adding **-ly**:

| Rule                  | Adjective → Adverb               | Example                         |
| --------------------- | -------------------------------- | ------------------------------- |
| most: **+ ly**        | quick → **quickly**              | _He runs **quickly**._          |
| ends in **-y → -ily** | happy → **happily**              | _She sang **happily**._         |
| ends in **-le → -ly** | gentle → **gently**              | _Hold the kitten **gently**._   |
| **irregular**         | good → **well**                  | _Aziz plays football **well**._ |
| same form (irregular) | fast → **fast**, hard → **hard** | _They work **hard**._           |

> ⚠️ The classic trap: **good** is an adjective, **well** is its adverb. Say _He speaks English **well**_ ✓ — never "he speaks English **good**". And an adverb describes a verb (_run quickly_); an adjective describes a noun (_a quick runner_).

> 🏆 Module Five cleared — the last gate of 8th year is behind you, hero! You can now advise, set the rules, speak your mind, name your feelings, describe how people act and talk about every bond in your life. You are ready for 9th year — see you at the next arena!', '# 📜 Summary: Relationships

- **Advice — should / shouldn''t**: _subject + should + base verb_ = a good idea (_You should rest_); _shouldn''t_ = a bad idea (_You shouldn''t lie_). No "to" after should, no -s with he/she.
- **Rules — must / mustn''t**: **must** = necessary / obligation (_You must stop at a red light_); **mustn''t** = forbidden (_You mustn''t drop litter_). Stronger than should; still no "to" after the modal.
- **should vs must**: should = a good idea (advice); must = it is necessary (a rule/law). shouldn''t = bad idea; mustn''t = strictly not allowed.
- **Opinion**: _I think (that)…_, _In my opinion…_, _I believe…_ · react with _I agree with you_ / _I disagree_ (never "I am agree").
- **Feelings**: _feel + adjective_ (_I feel happy_, never "feel happily") · happy, sad, angry, afraid, proud, worried, nervous, excited, lonely, jealous · ask _How do you feel?_
- **Relationships**: family — _get on well with_, respect, share, don''t argue · friends — _best friend_, make friends, trust, support each other · pets — _look after_ / _take care of_, feed · environment — protect, recycle, save water, plant trees, don''t drop litter.
- **Adverbs of manner (-ly)**: adjective → adverb tells HOW: _quick → quickly_ · **-y → -ily** (_happy → happily_) · **-le → -ly** (_gentle → gently_) · irregular _good → **well**_ (never "speaks good"), _fast → fast_, _hard → hard_.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7a69559d-e11b-5994-98f3-d18aaa04840d', 'c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6e896da6-f926-5249-8755-10b7be27c504', '7a69559d-e11b-5994-98f3-d18aaa04840d', 'Complete: "Skander ___ football every Saturday afternoon."', '[{"id":"a","text":"played"},{"id":"b","text":"plays"},{"id":"c","text":"play"},{"id":"d","text":"is playing"}]'::jsonb, 'b', '"Every Saturday" shows a habit, so we use the simple present. Skander = he, so the verb takes -s: he plays. "Play" forgets the -s, "played" is the past, and "is playing" describes right now, not a habit.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d293d22f-a8bd-57bf-b82b-18ae4783cbf2', '7a69559d-e11b-5994-98f3-d18aaa04840d', 'Complete: "Yesterday evening, we ___ a good film at home."', '[{"id":"a","text":"watch"},{"id":"b","text":"watches"},{"id":"c","text":"watched"},{"id":"d","text":"watching"}]'::jsonb, 'c', '"Yesterday evening" is a finished past time, so we use the simple past. "Watch" is a regular verb, so we add -ed: watched. "Watch" and "watches" are present forms, and "watching" cannot stand alone.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('485dab6f-fe97-5426-aa71-fc92b6b32441', '7a69559d-e11b-5994-98f3-d18aaa04840d', 'Complete: "Last summer, my family ___ to Djerba for a week."', '[{"id":"a","text":"go"},{"id":"b","text":"goed"},{"id":"c","text":"gone"},{"id":"d","text":"went"}]'::jsonb, 'd', '"Last summer" is a finished past time, so we need the simple past of "go", which is irregular: went. "Goed" adds -ed to an irregular verb (wrong), "go" is the present, and "gone" is the past participle, not the simple past.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('850ff181-37f1-5f0c-b38a-b9dc61133bec', '7a69559d-e11b-5994-98f3-d18aaa04840d', 'Complete: "Nour ___ come to school yesterday because she was ill."', '[{"id":"a","text":"didn''t"},{"id":"b","text":"doesn''t"},{"id":"c","text":"wasn''t"},{"id":"d","text":"don''t"}]'::jsonb, 'a', 'The sentence is about the past ("yesterday") and is negative, so we use "didn''t" + the base verb: didn''t come. "Doesn''t" and "don''t" are present, and "wasn''t come" mixes the verb "to be" with another verb.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a6d4f1e-90d1-5f5b-a781-7ba68aeef654', '7a69559d-e11b-5994-98f3-d18aaa04840d', 'Choose the correct question for the answer: "My grandparents. I visited them on Sunday."', '[{"id":"a","text":"When did you visit?"},{"id":"b","text":"Who did you visit?"},{"id":"c","text":"Where did you visit?"},{"id":"d","text":"Why did you visit?"}]'::jsonb, 'b', 'The answer names people (my grandparents), so the question asks about a person with "Who": Who did you visit? "When" asks about time, "Where" about a place, and "Why" about a reason.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d2500c42-a0eb-5d7f-946e-771642a82fd9', 'c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', '⭐ Practice: back to college', 1, 50, 10, 'practice', 'admin', 1)
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
  ('03754263-11df-5dc8-adc1-985f3d37433e', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', 'Complete: "Every morning, Yassine ___ up at six o''clock."', '[{"id":"a","text":"gets"},{"id":"b","text":"get"},{"id":"c","text":"got"},{"id":"d","text":"getting"}]'::jsonb, 'a', '"Every morning" describes a daily routine, so we use the simple present. Yassine = he, so the verb takes -s: he gets up. "Get" forgets the -s, "got" is the past, and "getting" cannot stand alone.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e9abeda-8ec3-5ecb-b20f-2267f6d48aeb', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', 'Which adverb of frequency means 0% (not one time)? "Mariem is a vegetarian, so she ___ eats meat."', '[{"id":"a","text":"always"},{"id":"b","text":"usually"},{"id":"c","text":"sometimes"},{"id":"d","text":"never"}]'::jsonb, 'd', 'A vegetarian does not eat meat at all, so the adverb is "never" (0%). "Always" means every time, "usually" means most times, and "sometimes" means now and then.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edb1a39c-85c4-5b14-ade3-844f8b0641f8', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', 'Complete: "Last night, I ___ my English lesson for two hours."', '[{"id":"a","text":"study"},{"id":"b","text":"studies"},{"id":"c","text":"studied"},{"id":"d","text":"studyed"}]'::jsonb, 'c', '"Last night" is a finished past time, so we use the simple past. "Study" ends in consonant + y, so the y changes to i before -ed: studied. "Studyed" keeps the y (wrong spelling), and "study/studies" are present forms.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f39c9111-57cf-510d-909c-ee635288cb18', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', 'Complete: "We ___ a great football match on TV yesterday."', '[{"id":"a","text":"see"},{"id":"b","text":"saw"},{"id":"c","text":"seen"},{"id":"d","text":"seed"}]'::jsonb, 'b', '"Yesterday" is a finished past time. "See" is irregular, and its simple past is "saw": we saw a match. "Seen" is the past participle (used with have), and "see/seed" are not correct past forms.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b1712fe-92aa-5c7a-86c8-3e2c84b422fd', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', 'Complete the question: "___ you finish your homework last night?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Did"},{"id":"c","text":"Does"},{"id":"d","text":"Were"}]'::jsonb, 'b', '"Last night" shows a finished past time, so a past question uses "Did" + subject + base verb: Did you finish? "Do/Does" are present, and "Were" is the verb "to be", which does not fit before "finish".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da70ee56-4bc3-513c-990e-138574796f23', 'd2500c42-a0eb-5d7f-946e-771642a82fd9', 'Complete: "My father ___ to Tunis every Monday for work."', '[{"id":"a","text":"travels"},{"id":"b","text":"travelled"},{"id":"c","text":"is travel"},{"id":"d","text":"travel"}]'::jsonb, 'a', '"Every Monday" shows a habit, so we use the simple present. My father = he, so the verb takes -s: travels. "Travelled" is the past, "travel" forgets the -s, and "is travel" is not a correct form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('989c4d1a-3c92-5e58-8d26-d64179caa517', 'c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', '⚔️ Chapter boss ⭐⭐⭐: the tense of the past', 3, 120, 30, 'boss', 'admin', 2)
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
  ('bff8883f-a315-5952-a28a-d72ce32c31de', '989c4d1a-3c92-5e58-8d26-d64179caa517', 'Complete: "Firas ___ his keys, so he waited outside for an hour."', '[{"id":"a","text":"didn''t found"},{"id":"b","text":"didn''t find"},{"id":"c","text":"don''t find"},{"id":"d","text":"not found"}]'::jsonb, 'b', 'In the past negative, we use "didn''t" and the verb goes back to its base form: didn''t find. The common trap is "didn''t found", which keeps the past form after "did" — but "did" already carries the past, so the main verb must be the base "find".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0df0b3e4-5c65-5638-843e-61553d560286', '989c4d1a-3c92-5e58-8d26-d64179caa517', 'Choose the correctly spelled past form: "The bus ___ at the station and we got on."', '[{"id":"a","text":"stopped"},{"id":"b","text":"stoped"},{"id":"c","text":"stopd"},{"id":"d","text":"stopize"}]'::jsonb, 'a', '"Stop" ends in one short vowel + one consonant, so we double the last consonant before -ed: stopped. "Stoped" forgets to double the p, and "stopd" and "stopize" are not real spellings.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c60bb82-d3c5-5780-897b-349a26ab630b', '989c4d1a-3c92-5e58-8d26-d64179caa517', 'Choose the correct question about a place: (you went somewhere last summer)', '[{"id":"a","text":"Where you did go last summer?"},{"id":"b","text":"Where did you went last summer?"},{"id":"c","text":"Where you went last summer?"},{"id":"d","text":"Where did you go last summer?"}]'::jsonb, 'd', 'A WH-question in the past follows the order WH + did + subject + base verb: Where did you go? The common trap is "Where did you went", which keeps the past form after "did"; "Where you did go" and "Where you went" have the wrong word order.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ad4bfe5-cd4e-5345-b38d-9699cb4cdf44', '989c4d1a-3c92-5e58-8d26-d64179caa517', 'Which sentence puts "always" in the correct place?', '[{"id":"a","text":"When she was young, she read always before bed."},{"id":"b","text":"When she was young, she read before bed always."},{"id":"c","text":"When she was young, she always read before bed."},{"id":"d","text":"When she was young, always she read before bed."}]'::jsonb, 'c', 'An adverb of frequency goes before the main verb: she always read before bed ✓ (this rule works in the past too). The common trap is putting it after the verb ("read always") or at the end ("before bed always"); "always she read" is not natural English.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a5d373c-e0f4-53c7-9cad-b8a9138aa9e1', '989c4d1a-3c92-5e58-8d26-d64179caa517', 'Read the text: "(1) Yesterday was a busy day. (2) I woke up early. (3) I eat a big breakfast. (4) Then I went to school." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'This item asks you to find the faulty sentence. The whole text is about "yesterday", so every verb must be past. Sentence 3 uses the present "eat" — it should be the past "ate": I ate a big breakfast ✓. Sentences 1, 2 and 4 correctly use "was", "woke" and "went".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac543095-0c46-5663-bd5f-1d326b07625f', '989c4d1a-3c92-5e58-8d26-d64179caa517', 'Complete: "How many books ___ she ___ last year?"', '[{"id":"a","text":"did ... read"},{"id":"b","text":"did ... reads"},{"id":"c","text":"did ... readed"},{"id":"d","text":"does ... read"}]'::jsonb, 'a', '"Last year" is a finished past time, so the question uses "did" + subject + base verb: did she read? The base of "read" is "read" (unchanged). The common trap is "did she readed" or "did she reads" — after "did", the verb is always the plain base; "does" would be present.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8678b7fb-5609-5fcf-8e96-4199037cf6ce', 'c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', '⭐⭐ Revision (exam type): present and past', 2, 70, 15, 'practice', 'admin', 3)
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
  ('121959fc-4208-573e-a3ea-ea5be2746802', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', 'Complete: "My sister ___ her homework straight after dinner."', '[{"id":"a","text":"do"},{"id":"b","text":"does"},{"id":"c","text":"dos"},{"id":"d","text":"doies"}]'::jsonb, 'b', 'This is a habit, so we use the simple present. My sister = she, and the third person of "do" is "does": she does her homework. "Do" forgets the ending, and "dos" and "doies" are not correct spellings.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e2a6828-f042-5b92-abcc-8ecb91d287bc', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', 'Complete: "We ___ pizza at the new restaurant last Friday."', '[{"id":"a","text":"eat"},{"id":"b","text":"eated"},{"id":"c","text":"ate"},{"id":"d","text":"eaten"}]'::jsonb, 'c', '"Last Friday" is a finished past time. "Eat" is irregular, and its simple past is "ate": we ate pizza. "Eated" wrongly adds -ed to an irregular verb, "eat" is the present, and "eaten" is the past participle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41585982-fc57-57db-a51a-ee06d591bdd2', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', 'Complete with the right adverb: "Rania is a very serious student, so she ___ forgets her books."', '[{"id":"a","text":"always"},{"id":"b","text":"usually"},{"id":"c","text":"often"},{"id":"d","text":"rarely"}]'::jsonb, 'd', 'A serious student almost never forgets her books, so the adverb is "rarely" (≈ 10%). "Always", "usually" and "often" all mean it happens most or many times, which would make her a forgetful student — the opposite of serious.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a91db15f-0f09-59a5-8389-abf17e5880cc', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', 'Choose the correct question for the answer: "At four o''clock. That''s when the match started."', '[{"id":"a","text":"Where did the match start?"},{"id":"b","text":"What time did the match start?"},{"id":"c","text":"Who did the match start?"},{"id":"d","text":"Why did the match start?"}]'::jsonb, 'b', 'The answer gives a clock time (four o''clock), so the question asks "What time": What time did the match start? "Where" asks about a place, "Who" about a person, and "Why" about a reason.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a4c0d98-1e0c-522b-a789-332ad6827430', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', 'Complete: "Nour was very tired, so she ___ to the party."', '[{"id":"a","text":"didn''t go"},{"id":"b","text":"didn''t went"},{"id":"c","text":"don''t go"},{"id":"d","text":"wasn''t go"}]'::jsonb, 'a', 'The sentence is past and negative, so we use "didn''t" + the base verb: didn''t go. "Didn''t went" keeps the past form after "did" (wrong), "don''t go" is present, and "wasn''t go" mixes "to be" with another verb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c95b352f-ec73-5879-9e67-293f81951cfa', '8678b7fb-5609-5fcf-8e96-4199037cf6ce', 'Read the signal word and complete: "Two years ago, my family ___ from Gafsa to Sfax."', '[{"id":"a","text":"move"},{"id":"b","text":"moves"},{"id":"c","text":"moved"},{"id":"d","text":"moving"}]'::jsonb, 'c', '"Ago" always points to a finished past time, so we use the simple past. "Move" is regular, so we add -d (it already ends in e): moved. "Move/moves" are present, and "moving" cannot stand alone.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('07b0652b-5604-5af6-a7e2-4be679888361', 'c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: the master of tenses', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('87bec0d7-f176-5695-8b31-0f17bee5e31c', '07b0652b-5604-5af6-a7e2-4be679888361', 'Complete: "Last week, Ines ___ a beautiful poem for the school magazine."', '[{"id":"a","text":"writed"},{"id":"b","text":"written"},{"id":"c","text":"wrote"},{"id":"d","text":"writ"}]'::jsonb, 'c', '"Last week" is a finished past time. "Write" is irregular, and its simple past is "wrote": she wrote a poem ✓. "Writed" wrongly adds -ed to an irregular verb, "written" is the past participle (used with have), and "writ" is not modern English.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50fc83db-51dc-56f6-924b-03cb1e6743c0', '07b0652b-5604-5af6-a7e2-4be679888361', 'Choose the correct question for the answer: "Firas broke the window." (Firas is the person who did it.)', '[{"id":"a","text":"Who did break the window?"},{"id":"b","text":"Who broke the window?"},{"id":"c","text":"Who did broke the window?"},{"id":"d","text":"Who the window broke?"}]'::jsonb, 'b', 'Here "who" is the subject (the doer), so we do NOT use "did" — the verb simply keeps its past tense: Who broke the window? ✓ The common trap is "Who did break…": subject questions with who/what never take do/did. "Who did broke" doubles the past, and "Who the window broke" has the wrong order.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ba598f1-064d-5e08-b272-324649d965a2', '07b0652b-5604-5af6-a7e2-4be679888361', 'Complete: "___ your team ___ the match yesterday?"', '[{"id":"a","text":"Did ... win"},{"id":"b","text":"Did ... won"},{"id":"c","text":"Does ... win"},{"id":"d","text":"Was ... win"}]'::jsonb, 'a', '"Yesterday" needs a past question: Did + subject + base verb. The base of "win" is "win": Did your team win? ✓ The trap "Did … won" keeps the past form after "did"; "Does" is present, and "Was … win" mixes "to be" with another verb.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17c58751-f0b2-5fab-8a1e-a31bcedb8e68', '07b0652b-5604-5af6-a7e2-4be679888361', 'Which sentence is correct?', '[{"id":"a","text":"My grandfather never was late for prayer."},{"id":"b","text":"My grandfather was never late for prayer."},{"id":"c","text":"My grandfather was late never for prayer."},{"id":"d","text":"My grandfather didn''t never be late for prayer."}]'::jsonb, 'b', 'With the verb "to be", the adverb of frequency goes AFTER the verb: was never late ✓. The trap "never was" applies the other rule (before an ordinary verb) to "to be"; "was late never" puts it at the end; and "didn''t never" is a double negative, which is always wrong in English.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5454b35d-0ef0-55c9-8763-219b586b4268', '07b0652b-5604-5af6-a7e2-4be679888361', 'Read the text: "(1) When I was ten, I lived in Gabes. (2) Every day, I walked to school. (3) My teacher always gave us homework. (4) I never did it not." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'd', 'This item asks you to find the faulty sentence. Sentence 4 has a double negative: "never" and "not" together. English uses only one negative, so it must be "I never did it" ✓. Sentences 1, 2 and 3 correctly use the past forms "was/lived", "walked" and "gave" with "always" before the verb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8896e144-b0c1-5b87-bb2f-374bbd8de6a9', '07b0652b-5604-5af6-a7e2-4be679888361', 'Make a question about the underlined words: "They watched __a documentary__ on Sunday."', '[{"id":"a","text":"What did they watch on Sunday?"},{"id":"b","text":"What they watched on Sunday?"},{"id":"c","text":"What did they watched on Sunday?"},{"id":"d","text":"Did they watch a documentary on Sunday?"}]'::jsonb, 'a', '"A documentary" is a thing and the object of the sentence, so we ask with "What" + did + subject + base verb: What did they watch? ✓ "What they watched" has no auxiliary, "What did they watched" doubles the past, and option d is a yes/no question, not a WH-question about the object.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', '📝 Training ⭐⭐⭐: global review of Module 1', 3, 120, 30, 'boss', 'admin', 5)
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
  ('69f69cb9-d702-51be-823e-3621c04cb592', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'Complete: "Usually I take the bus, but yesterday I ___ a taxi."', '[{"id":"a","text":"take"},{"id":"b","text":"took"},{"id":"c","text":"taked"},{"id":"d","text":"taken"}]'::jsonb, 'b', '"Usually" points to a present habit (take), but "yesterday" points to a finished past action. "Take" is irregular, and its past is "took": yesterday I took a taxi ✓. "Taked" wrongly adds -ed, and "taken" is the past participle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3fa76fb-8f95-583c-b76c-542dbc68902b', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'Choose the sentence with the correct word order:', '[{"id":"a","text":"My friends play often football after school."},{"id":"b","text":"My friends football often play after school."},{"id":"c","text":"My friends often play football after school."},{"id":"d","text":"My friends play football often after school."}]'::jsonb, 'c', 'An adverb of frequency goes before the main verb: my friends often play football ✓. "Play often football" and "play football often" put the adverb after the verb or its object, and "football often play" breaks the basic subject-verb-object order.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f4dc41b-3cce-5656-a505-08987f51de08', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'Which is the correct past form of "buy"?', '[{"id":"a","text":"buyed"},{"id":"b","text":"buied"},{"id":"c","text":"boughted"},{"id":"d","text":"bought"}]'::jsonb, 'd', '"Buy" is irregular, and its simple past is "bought". "Buyed" and "buied" wrongly try to add -ed, and "boughted" adds -ed on top of the irregular form — the past is simply "bought" ✓.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79ac71fd-31cc-5e73-92f0-430c5b9ceb9c', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'Choose the correct question for the answer: "I go swimming twice a week."', '[{"id":"a","text":"How often do you go swimming?"},{"id":"b","text":"How many do you go swimming?"},{"id":"c","text":"How long do you go swimming?"},{"id":"d","text":"When do you go swimming?"}]'::jsonb, 'a', '"Twice a week" tells us how frequently, so the question asks "How often": How often do you go swimming? "How many" needs a noun (how many times), "How long" asks about duration, and "When" asks for a specific time, not a frequency.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc8463d9-3384-5401-857f-34651855d288', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'Complete: "We ___ the beginning of the film because we arrived late."', '[{"id":"a","text":"didn''t saw"},{"id":"b","text":"didn''t see"},{"id":"c","text":"didn''t seen"},{"id":"d","text":"don''t see"}]'::jsonb, 'b', 'The sentence is past and negative, so we use "didn''t" + the base verb: didn''t see ✓. The trap "didn''t saw" keeps the past form after "did"; "didn''t seen" uses the past participle; and "don''t see" is present, which clashes with "arrived late".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('827e71ba-8543-5bbc-bf40-1167eae5591c', '25e5fd44-bef5-55f1-bfbe-908c1b0e43b5', 'Read the text: "(1) My name is Skander. (2) I am thirteen years old. (3) Last year, I win the school chess tournament. (4) Now I play every weekend." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'This item asks you to find the faulty sentence. Sentence 3 says "Last year", a finished past time, but uses the present "win" — it must be the past "won": Last year, I won the tournament ✓. Sentences 1, 2 and 4 correctly use the present for facts and habits ("is", "am", "play every weekend").', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'c3b638b8-612d-5268-b5e7-9abe716fcc31', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: the final gate of Module 1', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('154d7ffc-ec62-5959-a10f-253f25f16dab', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'In which verb is the -ed ending pronounced as an extra syllable /ɪd/, like in "wanted"?', '[{"id":"a","text":"played"},{"id":"b","text":"watched"},{"id":"c","text":"visited"},{"id":"d","text":"cleaned"}]'::jsonb, 'c', 'The -ed is pronounced as an extra syllable /ɪd/ only when the verb ends in the sound t or d — so "visited" (ends in t) gets the extra syllable, exactly like "wanted" ✓. "Played" and "cleaned" end in /d/, and "watched" ends in /t/ (no extra syllable).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7443018-df54-57b9-9d01-acc899b10b04', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'Complete: "During the trip, the guide ___ us an interesting story about Carthage."', '[{"id":"a","text":"telled"},{"id":"b","text":"told"},{"id":"c","text":"tolded"},{"id":"d","text":"tell"}]'::jsonb, 'b', '"Tell" is irregular, and its simple past is "told": the guide told us a story ✓. "Telled" wrongly adds -ed to an irregular verb, "tolded" adds -ed on top of the past form, and "tell" is the present base, which does not fit a finished past action.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad173e3c-c795-5f77-90d3-fd57c62701ab', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'Choose the correct question for the answer: "They met __Mr Rahal__ at the airport." (Mr Rahal is the person they met.)', '[{"id":"a","text":"Who did they meet at the airport?"},{"id":"b","text":"Who they met at the airport?"},{"id":"c","text":"Who did they met at the airport?"},{"id":"d","text":"Who met they at the airport?"}]'::jsonb, 'a', 'Here "who" asks about the object (the person they met), so we DO need the auxiliary: Who did they meet? ✓ The verb goes back to the base "meet". The trap "Who did they met" doubles the past; "Who they met" has no auxiliary; and "Who met they" is a subject-question order, which does not fit here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('839ebb6f-c84e-5f6c-a615-6e8e997b04cc', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'Complete: "These days Ines ___ in Sousse, but two years ago she ___ in Bizerte."', '[{"id":"a","text":"lives ... lived"},{"id":"b","text":"lived ... lives"},{"id":"c","text":"lives ... lives"},{"id":"d","text":"lived ... lived"}]'::jsonb, 'a', '"These days" points to the present (lives), while "two years ago" points to a finished past (lived): she lives in Sousse now, but she lived in Bizerte before ✓. Every other pair puts at least one verb in the wrong tense for its signal word.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('946dc4ff-21e2-5f8f-9a36-da9af6bf2f24', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'Which question is correctly formed?', '[{"id":"a","text":"How often does your brother visits your grandmother?"},{"id":"b","text":"How often does your brother visit your grandmother?"},{"id":"c","text":"How often your brother visits your grandmother?"},{"id":"d","text":"How often do your brother visit your grandmother?"}]'::jsonb, 'b', 'After the auxiliary "does", the main verb goes back to its base with no -s: How often does your brother visit? ✓ Option a keeps the -s on "visits" (double marking), option c has no auxiliary at all, and option d uses "do" with the singular "your brother" instead of "does".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7725d77-666b-5708-9b2c-9a7fd8673113', 'dc6f2943-7b13-5ecf-86ea-ac10f4ccfa35', 'Read the text: "(1) Last weekend, my cousins came to visit us. (2) We had a big lunch together. (3) After lunch, we played cards and watched a film. (4) My little brother didn''t wanted to sleep." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'd', 'This item asks you to find the faulty sentence. Sentence 4 uses "didn''t wanted": after "didn''t", the verb must return to its base, so it should be "didn''t want" ✓. Sentences 1, 2 and 3 correctly use the past forms "came", "had", "played" and "watched".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d64d3f1f-2643-5210-8781-e9d3672554a9', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6cfc47a2-e4d8-55d8-894e-c4d7b053ac89', 'd64d3f1f-2643-5210-8781-e9d3672554a9', 'Complete: "Last July, Anis ___ to London by plane."', '[{"id":"a","text":"fly"},{"id":"b","text":"flew"},{"id":"c","text":"flied"},{"id":"d","text":"was fly"}]'::jsonb, 'b', '"Last July" is a finished past time, so we use the simple past of "fly", which is the irregular form "flew". "Flied" adds -ed to an irregular verb, and "was fly" mixes two forms.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0dfa526f-8bec-59d5-ae8e-5607d52ab01d', 'd64d3f1f-2643-5210-8781-e9d3672554a9', 'Complete: "At nine o''clock, the Bakers ___ breakfast in the kitchen."', '[{"id":"a","text":"having"},{"id":"b","text":"was having"},{"id":"c","text":"were having"},{"id":"d","text":"were have"}]'::jsonb, 'c', 'An action in progress at a past moment uses the past continuous: was/were + verb-ing. "The Bakers" is plural, so we use "were having". "Was having" is singular, and "were have" forgets the -ing.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af1d15e9-51a2-5a64-aaf8-beb30e6a251c', 'd64d3f1f-2643-5210-8781-e9d3672554a9', 'Complete: "Anis is not tall; he is quite ___."', '[{"id":"a","text":"short"},{"id":"b","text":"kind"},{"id":"c","text":"noisy"},{"id":"d","text":"crowded"}]'::jsonb, 'a', '"Short" is the opposite of "tall" and describes the body. "Kind" describes character, while "noisy" and "crowded" describe places, not a person''s height.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf241c2f-9f6f-50d3-8a51-dcc9fafa7f91', 'd64d3f1f-2643-5210-8781-e9d3672554a9', 'Complete: "London is much ___ than Bizerte."', '[{"id":"a","text":"big"},{"id":"b","text":"more big"},{"id":"c","text":"bigger"},{"id":"d","text":"biggest"}]'::jsonb, 'c', '"Big" is a short adjective, so its comparative adds -er and doubles the consonant: "bigger than". "More big" is wrong for a short adjective, and "biggest" is the form for three or more things, not for comparing two.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1db6b111-6777-588f-9965-f956a316372b', 'd64d3f1f-2643-5210-8781-e9d3672554a9', 'Complete: "Anis ___ get lost, because Oliver drew him a clear map."', '[{"id":"a","text":"not"},{"id":"b","text":"doesn''t"},{"id":"c","text":"wasn''t"},{"id":"d","text":"didn''t"}]'::jsonb, 'd', 'The simple past negative is "didn''t" + the base verb: "didn''t get". "Doesn''t" is present, "wasn''t" needs no main verb after it, and "not" alone cannot form a past negative.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b9c967e3-f032-5a94-9b40-fdb84445739f', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', '⭐ Practice: Anis lands in London', 1, 50, 10, 'practice', 'admin', 1)
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
  ('92093aa7-a151-5bf9-a6e0-a5ec6e04fb76', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'Complete: "Yesterday, Anis ___ his pen-friend Oliver at the airport."', '[{"id":"a","text":"met"},{"id":"b","text":"meets"},{"id":"c","text":"meeted"},{"id":"d","text":"was meet"}]'::jsonb, 'a', '"Yesterday" needs the simple past. "Meet" is irregular: its past is "met". "Meets" is present, "meeted" adds -ed to an irregular verb, and "was meet" mixes two forms.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f6c95e7-81ee-5c82-9bb1-cc0a444a8947', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'Complete: "The plane ___ at the airport at noon."', '[{"id":"a","text":"land"},{"id":"b","text":"landed"},{"id":"c","text":"landing"},{"id":"d","text":"was land"}]'::jsonb, 'b', '"Land" is a regular verb, so its simple past adds -ed: "landed". "Land" alone has no past marker, "landing" is the -ing form, and "was land" is not a correct past form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('135fb698-b491-58be-b3c8-5b60b571d73d', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'Complete: "Look at the photo: Anis ___ in front of the palace."', '[{"id":"a","text":"standing"},{"id":"b","text":"was stand"},{"id":"c","text":"was standing"},{"id":"d","text":"were standing"}]'::jsonb, 'c', 'The past continuous describes the scene in the photo: was/were + verb-ing. "Anis" is singular, so "was standing". "Was stand" forgets the -ing, "standing" forgets the verb be, and "were" is for plural subjects.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3147faab-0056-5eab-a47d-76ed49b01ca2', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'Complete: "Mrs Baker helped Anis with everything. She is very ___."', '[{"id":"a","text":"tall"},{"id":"b","text":"crowded"},{"id":"c","text":"ancient"},{"id":"d","text":"kind"}]'::jsonb, 'd', 'Someone who helps a lot is "kind" — a personality adjective. "Tall" describes the body, while "crowded" and "ancient" describe places, not a person''s character.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('451eab83-214e-5c2a-8056-08f3a9a62032', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'Complete: "There were cars and people everywhere. Oxford Street was very ___."', '[{"id":"a","text":"crowded"},{"id":"b","text":"quiet"},{"id":"c","text":"empty"},{"id":"d","text":"slim"}]'::jsonb, 'a', 'A place full of cars and people is "crowded". "Quiet" and "empty" mean the opposite, and "slim" describes a person''s body, not a street.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8a3a298-592e-58c1-bd70-05bb4972af56', 'b9c967e3-f032-5a94-9b40-fdb84445739f', 'Complete: "The London Eye is ___ than the buildings around it."', '[{"id":"a","text":"tall"},{"id":"b","text":"taller"},{"id":"c","text":"more tall"},{"id":"d","text":"tallest"}]'::jsonb, 'b', '"Tall" is a short adjective, so the comparative adds -er: "taller than". "More tall" is wrong for a short adjective, "tall" has no comparison mark, and "tallest" is for three or more things.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cec5741d-38fe-5bb6-8cac-cbc1269ffa28', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', '⚔️ Chapter boss ⭐⭐⭐: a day in the city', 3, 120, 30, 'boss', 'admin', 2)
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
  ('6c3233f8-d40a-59ca-86ca-112766ae9f86', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'Complete: "___ Anis enjoy the London bus tour?" — "Yes, he did."', '[{"id":"a","text":"Did"},{"id":"b","text":"Was"},{"id":"c","text":"Does"},{"id":"d","text":"Were"}]'::jsonb, 'a', 'The short answer "Yes, he did" tells us the question is a simple-past question: Did + subject + base verb → "Did Anis enjoy…?". "Was/Were" would need an -ing or an adjective, and "Does" is present.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a77ab1f4-46e6-5bce-bca8-1fd5148e924a', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'Complete: "When the rain started, Anis and Oliver ___ across Hyde Park."', '[{"id":"a","text":"was walking"},{"id":"b","text":"were walking"},{"id":"c","text":"were walk"},{"id":"d","text":"walked"}]'::jsonb, 'b', 'The walk was already in progress when the rain started, so it takes the past continuous: was/were + verb-ing. "Anis and Oliver" is plural → "were walking". "Was walking" is singular, "were walk" forgets the -ing, and "walked" loses the idea of an action in progress.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('102e97ae-c67d-5ba2-8a12-a69982229810', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'Complete: "The weather in London was ___ than in Bizerte: grey and rainy."', '[{"id":"a","text":"badder"},{"id":"b","text":"worst"},{"id":"c","text":"more bad"},{"id":"d","text":"worse"}]'::jsonb, 'd', '"Bad" is irregular: its comparative is "worse than" ✓. The common trap is "badder" or "more bad" — "bad" never follows the -er or the more… rule. "Worst" is the form for three or more things.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8229a6c4-972a-5679-8a95-128a701d2b2a', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'Complete: "Anis ___ his breakfast when the taxi ___."', '[{"id":"a","text":"ate … arrived"},{"id":"b","text":"was eating … was arriving"},{"id":"c","text":"was eating … arrived"},{"id":"d","text":"ate … was arriving"}]'::jsonb, 'c', 'The long background action (eating breakfast) takes the past continuous, and the short action that cuts into it (the taxi) takes the past simple: "was eating … arrived" ✓. The common trap is putting both verbs in the same tense — but here one action interrupts the other, so the tenses must differ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0941873b-9128-544c-8066-1bb3f16c1604', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'Complete: "The Underground was ___ than the bus, but it was much faster."', '[{"id":"a","text":"more expensive"},{"id":"b","text":"expensiver"},{"id":"c","text":"most expensive"},{"id":"d","text":"more expensiver"}]'::jsonb, 'a', '"Expensive" is a long adjective (three syllables), so its comparative is "more expensive than" ✓. The common trap is "expensiver" — you never add -er to a long adjective. "Most expensive" is for three or more, and "more expensiver" doubles the comparison.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc62effd-94ae-58bd-be3f-a2df3ae85dc1', 'cec5741d-38fe-5bb6-8cac-cbc1269ffa28', 'Which sentence is **NOT** correct?', '[{"id":"a","text":"Anis was tired after the long flight."},{"id":"b","text":"The old streets were narrow and quiet."},{"id":"c","text":"Oliver was more taller than Anis."},{"id":"d","text":"The museum was huge and modern."}]'::jsonb, 'c', 'This asks for the incorrect sentence. "More taller" doubles the comparison: with a short adjective you use ONLY -er, so it must be "Oliver was taller than Anis" ✓. The other three sentences use adjectives and the past of "be" correctly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', '⭐⭐ Revision (exam type): the trip so far', 2, 70, 15, 'practice', 'admin', 3)
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
  ('4c82e9e8-a7f5-5a04-a6ee-21ac2603d8cd', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'Complete: "Anis ___ English with the Bakers every day."', '[{"id":"a","text":"speak"},{"id":"b","text":"spoke"},{"id":"c","text":"speaked"},{"id":"d","text":"spoked"}]'::jsonb, 'b', 'The story is in the past, and "speak" is irregular: its simple past is "spoke". "Speaked" and "spoked" wrongly add -ed to an irregular verb, and "speak" is the base form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5e2a159-0065-5a2a-bbcd-6f548dfbf073', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'Complete: "Yesterday at noon, Anis and Oliver ___ lunch in a park."', '[{"id":"a","text":"were eating"},{"id":"b","text":"was eating"},{"id":"c","text":"were eat"},{"id":"d","text":"are eating"}]'::jsonb, 'a', 'An action in progress at a past moment (noon yesterday) takes the past continuous. The subject is plural, so "were eating". "Was eating" is singular, "were eat" forgets the -ing, and "are eating" is present.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce2be746-d340-5fe9-8ead-0c820180131f', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'Complete: "Big Ben is a very ___ monument; millions of tourists know it."', '[{"id":"a","text":"famous"},{"id":"b","text":"crowded"},{"id":"c","text":"noisy"},{"id":"d","text":"modern"}]'::jsonb, 'a', 'Something everybody knows is "famous". "Crowded" means full of people, "noisy" means full of sound, and "modern" means new — but Big Ben is famous and old, not new.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('816d5f64-5769-5434-8349-2d9e6949be1b', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'Complete: "Oliver never gets angry and always smiles. He is very ___."', '[{"id":"a","text":"shy"},{"id":"b","text":"rude"},{"id":"c","text":"cheerful"},{"id":"d","text":"short"}]'::jsonb, 'c', 'A person who always smiles and is happy is "cheerful". "Shy" means afraid to talk, "rude" means not polite, and "short" describes the body, not the character.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe931afd-730d-5ba2-b1b6-d387345ad8e2', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'Complete: "July in Bizerte is ___ than in London."', '[{"id":"a","text":"hoter"},{"id":"b","text":"more hot"},{"id":"c","text":"hottest"},{"id":"d","text":"hotter"}]'::jsonb, 'd', '"Hot" is a short adjective ending in consonant-vowel-consonant, so we double the t and add -er: "hotter than" ✓. "Hoter" forgets the double t, "more hot" is wrong for a short adjective, and "hottest" is for three or more.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cdb05dd-7509-59f0-9293-dc72738ebbf5', 'fb3c7d48-d48a-561a-b54a-c0ce1c6d0bd8', 'Complete: "The streets of London are ___ than the streets of Bizerte."', '[{"id":"a","text":"busyer"},{"id":"b","text":"busier"},{"id":"c","text":"more busy"},{"id":"d","text":"busiest"}]'::jsonb, 'b', '"Busy" ends in -y, so the comparative changes -y to -ier: "busier than" ✓. "Busyer" keeps the y wrongly, "more busy" is wrong for a short -y adjective, and "busiest" is for three or more.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a03ad743-f697-5a7e-b97b-c11806eaf053', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: two worlds compared', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('385b1d86-8847-5158-8744-70941570fb8c', 'a03ad743-f697-5a7e-b97b-c11806eaf053', 'Which question matches the answer "She bought some souvenirs."?', '[{"id":"a","text":"What did she buy?"},{"id":"b","text":"What did she bought?"},{"id":"c","text":"What she buy?"},{"id":"d","text":"What does she buy?"}]'::jsonb, 'a', 'The answer is in the simple past ("bought"), so the question uses "did + base verb": "What did she buy?" ✓. "What did she bought?" wrongly keeps the past after "did", "What she buy?" has no auxiliary, and "does" is present.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf9a8e2f-953f-533e-8fa2-52bc1080b0e1', 'a03ad743-f697-5a7e-b97b-c11806eaf053', 'Which adjective describes a person''s **character**, not their body?', '[{"id":"a","text":"tall"},{"id":"b","text":"generous"},{"id":"c","text":"slim"},{"id":"d","text":"curly"}]'::jsonb, 'b', '"Generous" (loving to share) describes character ✓. "Tall" and "slim" describe the body, and "curly" describes hair — all three are physical, not personality.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcc38b7f-cfb2-530b-be47-5761f0b15c78', 'a03ad743-f697-5a7e-b97b-c11806eaf053', 'Complete: "In the picture, Anis ___ a huge ice-cream while Oliver ___ a photo."', '[{"id":"a","text":"ate … took"},{"id":"b","text":"was eating … took"},{"id":"c","text":"was eating … was taking"},{"id":"d","text":"ate … was taking"}]'::jsonb, 'c', '"While" links two actions in progress at the same moment, so both take the past continuous: "was eating … was taking" ✓. The common trap is switching one verb to the simple past — but neither action interrupts the other here; they happen together.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b224cfb-09a9-549a-913c-a3ffbe9c6152', 'a03ad743-f697-5a7e-b97b-c11806eaf053', 'Complete: "London is much ___ and ___ than Bizerte."', '[{"id":"a","text":"biggest … most crowded"},{"id":"b","text":"bigger … more crowded"},{"id":"c","text":"more big … crowdeder"},{"id":"d","text":"bigger … crowdeder"}]'::jsonb, 'b', 'Two comparisons of two things: "big" is short → "bigger", and "crowded" is long → "more crowded", both with "than" ✓. "Biggest/most crowded" are for three or more, "more big" and "crowdeder" break the short/long rule.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0cbb4ec-376a-5fa2-9ab3-04bd7b5e4149', 'a03ad743-f697-5a7e-b97b-c11806eaf053', 'One sentence has a mistake. Which one?', '[{"id":"a","text":"Anis didn''t visit the Tower on Monday."},{"id":"b","text":"Did the Bakers meet him at the airport?"},{"id":"c","text":"Oliver didn''t went to school that week."},{"id":"d","text":"They saw the London Eye at night."}]'::jsonb, 'c', 'After "didn''t" the verb must be the base form: it should be "Oliver didn''t go to school" ✓. The others are correct: "didn''t visit", "Did … meet?" and the irregular past "saw" all follow the rule.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5eec0ea5-844a-545e-bf99-04caf246e2b4', 'a03ad743-f697-5a7e-b97b-c11806eaf053', 'Complete: "Anis thought the food at home was ___ than English food, but the parks in London were ___ than the ones back home."', '[{"id":"a","text":"better … more beautiful"},{"id":"b","text":"gooder … beautifuler"},{"id":"c","text":"best … more beautiful"},{"id":"d","text":"better … beautifuller"}]'::jsonb, 'a', '"Good" is irregular → "better than", and "beautiful" is long → "more beautiful than" ✓. The common trap is "gooder" — "good" never takes -er. "Beautifuler/beautifuller" break the long-adjective rule, and "best" is for three or more.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7dc12bba-6d03-5e2a-9a00-81c2883bb213', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', '📝 Training ⭐⭐⭐ (global review)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('be2e6964-1e1e-5eed-a42e-b8b400c2f5f3', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'Complete: "During his stay, Anis ___ hundreds of photos with his phone."', '[{"id":"a","text":"take"},{"id":"b","text":"took"},{"id":"c","text":"taked"},{"id":"d","text":"tooked"}]'::jsonb, 'b', '"Take" is irregular, and the sentence is about a finished stay, so we use the simple past "took". "Take" is the base form, and "taked"/"tooked" wrongly add -ed to an irregular verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ee3843d-9c60-5857-b170-29762813b7cf', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'Complete: "___ the children playing in the garden when it started to rain?" — "Yes, they were."', '[{"id":"a","text":"Were"},{"id":"b","text":"Was"},{"id":"c","text":"Did"},{"id":"d","text":"Are"}]'::jsonb, 'a', 'The short answer "Yes, they were" shows a past-continuous question: Was/Were + subject + -ing. "The children" is plural → "Were". "Was" is singular, "Did" needs a base verb (not -ing), and "Are" is present.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32867a48-f1ca-5e71-a975-da294a6d762b', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'Complete: "The city centre was noisy, but the small village they visited was ___."', '[{"id":"a","text":"crowded"},{"id":"b","text":"huge"},{"id":"c","text":"quiet"},{"id":"d","text":"modern"}]'::jsonb, 'c', '"But" signals a contrast with "noisy", so we need its opposite: "quiet" (calm) ✓. "Crowded" and "huge" do not oppose "noisy", and "modern" (new) is unrelated to sound.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c1f56a4-a400-50f7-bcd5-6005e7042221', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'Complete: "For Anis, the Underground map was ___ than the bus map."', '[{"id":"a","text":"more difficult"},{"id":"b","text":"difficulter"},{"id":"c","text":"most difficult"},{"id":"d","text":"more difficulter"}]'::jsonb, 'a', '"Difficult" is a long adjective (three syllables), so its comparative is "more difficult than" ✓. "Difficulter" wrongly adds -er, "most difficult" is for three or more, and "more difficulter" doubles the comparison.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03302a73-375d-58cb-9f85-eab91d003909', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'Complete: "Anis ___ a photo when a red double-decker bus ___ by."', '[{"id":"a","text":"took … passed"},{"id":"b","text":"took … was passing"},{"id":"c","text":"was taking … was passing"},{"id":"d","text":"was taking … passed"}]'::jsonb, 'd', 'Taking the photo was the ongoing action → past continuous "was taking", and the short event that cut into it → past simple "passed": "was taking … passed" ✓. The trap is matching the two tenses, but an interruption always splits them.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b49906c3-0120-59e7-a8da-8b9f84b2d9d5', '7dc12bba-6d03-5e2a-9a00-81c2883bb213', 'Complete: "Oliver is 14 and Anis is 13, so Oliver is ___ than Anis."', '[{"id":"a","text":"old"},{"id":"b","text":"older"},{"id":"c","text":"more old"},{"id":"d","text":"oldest"}]'::jsonb, 'b', 'We compare two people, and "old" is a short adjective, so it takes -er: "older than" ✓. "Old" has no comparison mark, "more old" is wrong for a short adjective, and "oldest" is for three or more.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6da2dd4-d08e-5711-ac11-d3c485ec319a', '96fbec07-db1a-5fd8-af84-a325a5bd3cb1', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: the London chronicle', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('35780050-f4f9-50e1-9b9b-bfda780a352d', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', 'Which sentence is correct?', '[{"id":"a","text":"London is more bigger than Sfax."},{"id":"b","text":"Anis is taller than his cousin."},{"id":"c","text":"The tea was gooder than the coffee."},{"id":"d","text":"Bizerte is more small than London."}]'::jsonb, 'b', '"Taller than" correctly forms the comparative of a short adjective ✓. "More bigger" doubles the comparison, "gooder" ignores the irregular "better", and "more small" should be "smaller" (short adjective → -er).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cebafab-a9c8-5299-86ca-a2b0c36d7621', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', 'Which sentence about the picnic is correct?', '[{"id":"a","text":"While they were eating, a dog stole the sandwich."},{"id":"b","text":"While they ate, a dog was stealing the sandwich."},{"id":"c","text":"While they were eating, a dog was stole the sandwich."},{"id":"d","text":"While they eating, a dog stole the sandwich."}]'::jsonb, 'a', 'The background action after "while" is past continuous ("were eating"), and the short event that cuts in is past simple ("stole"): sentence a ✓. Sentence b swaps the tenses, c writes "was stole" (never be + past simple), and d forgets "were" before "eating".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e452a63a-ff6a-53df-bf82-7addc7382504', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', 'Anis wrote: "Bizerte is smaller than London." This means…', '[{"id":"a","text":"Bizerte is bigger than London."},{"id":"b","text":"London is bigger than Bizerte."},{"id":"c","text":"London is smaller than Bizerte."},{"id":"d","text":"Bizerte and London are the same size."}]'::jsonb, 'b', '"Bizerte is smaller than London" means London is the bigger of the two, so "London is bigger than Bizerte" ✓. Options a and c reverse the relationship, and d denies the difference the sentence states.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4d5730f-347d-5949-a95e-91f4becae80c', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', 'One sentence has a wrong verb form. Which one?', '[{"id":"a","text":"The Bakers were watching TV at 9 p.m."},{"id":"b","text":"Anis was writing a postcard to his mother."},{"id":"c","text":"The birds was singing in the garden."},{"id":"d","text":"We were waiting for the bus."}]'::jsonb, 'c', '"The birds" is plural, so it needs "were", not "was": it should be "The birds were singing" ✓. The other three correctly match was (singular) or were (plural) with the -ing form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4d5e193-0550-57ed-9ddb-e0f49e3a6e11', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', 'Anis wrote: "The old part of London has narrow streets and ancient houses." Which word means "very, very old"?', '[{"id":"a","text":"narrow"},{"id":"b","text":"modern"},{"id":"c","text":"ancient"},{"id":"d","text":"crowded"}]'::jsonb, 'c', '"Ancient" means very, very old, from long ago ✓. "Narrow" means not wide, "modern" means new (the opposite), and "crowded" means full of people.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afd0e208-dfc7-5014-82da-e8613c4151ec', 'c6da2dd4-d08e-5711-ac11-d3c485ec319a', 'Complete: "Anis ___ tired at the end of the day, but he thought London was far ___ than he expected."', '[{"id":"a","text":"wasn''t … more beautiful"},{"id":"b","text":"didn''t … more beautiful"},{"id":"c","text":"wasn''t … beautifuller"},{"id":"d","text":"weren''t … more beautiful"}]'::jsonb, 'a', 'The past negative of "be" with a single subject is "wasn''t" ("Anis wasn''t tired"), and "beautiful" is a long adjective → "more beautiful than": option a ✓. "Didn''t" would need a main verb, "weren''t" is plural, and "beautifuller" breaks the long-adjective rule.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6f570d6b-a70a-5202-918b-936631115254', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5d45447c-86fe-55d8-94a0-c1d2e8251626', '6f570d6b-a70a-5202-918b-936631115254', 'Complete: "Next week Skander ___ visit the British Museum with his friends."', '[{"id":"a","text":"are going to"},{"id":"b","text":"is going to"},{"id":"c","text":"going to"},{"id":"d","text":"is go to"}]'::jsonb, 'b', '"Skander" is one person (he), so we use "is going to" + the base verb: is going to visit. "Are going to" is for you/we/they, "going to" forgets the verb be, and "is go to" is not a correct form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a40ef5e-3297-5157-9d9e-10538f996f04', '6f570d6b-a70a-5202-918b-936631115254', 'Complete: "The London Eye is ___ than the little wheel in the town fair."', '[{"id":"a","text":"taller"},{"id":"b","text":"more tall"},{"id":"c","text":"tallest"},{"id":"d","text":"more taller"}]'::jsonb, 'a', '"Tall" is a short adjective, so its comparative adds -er: taller than. "More tall" and "more taller" mark the comparative twice, and "tallest" is the superlative (the top of a group), not a comparison of two things.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('126fbcdd-4b0b-5141-9e90-bc8e9e8d66ad', '6f570d6b-a70a-5202-918b-936631115254', 'Complete: "The Shard is ___ building in London."', '[{"id":"a","text":"the most tall"},{"id":"b","text":"the taller"},{"id":"c","text":"the tallest"},{"id":"d","text":"tallest"}]'::jsonb, 'c', 'To say something is number one in a group, we use the superlative: for a short adjective, the …-est → the tallest. "The most tall" is wrong for a short adjective, "the taller" is a comparative, and "tallest" forgets "the".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9220be93-37d0-5cce-bd2d-aec0d1c8de13', '6f570d6b-a70a-5202-918b-936631115254', 'You are giving directions. Complete: "To reach the station, ___ left at the traffic lights."', '[{"id":"a","text":"to turn"},{"id":"b","text":"turning"},{"id":"c","text":"turns"},{"id":"d","text":"turn"}]'::jsonb, 'd', 'Directions use the base verb, like an order: turn left. "To turn", "turning" and "turns" are not used to give a direction — you tell the person simply to "turn".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9eea069c-962b-5400-a9b0-718290460af2', '6f570d6b-a70a-5202-918b-936631115254', 'Complete this suggestion: "___ visiting Hyde Park this afternoon?"', '[{"id":"a","text":"Shall we"},{"id":"b","text":"Let''s"},{"id":"c","text":"How about"},{"id":"d","text":"Why don''t we"}]'::jsonb, 'c', 'Only "How about" is followed by a verb + -ing: How about visiting…? "Shall we", "Let''s" and "Why don''t we" are all followed by the base verb (Shall we visit…?), not by "visiting".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('815e6837-2ba6-5dba-b520-1826fb773cf7', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', '⭐ Practice: my London plans', 1, 50, 10, 'practice', 'admin', 1)
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
  ('3b359af3-b95f-571d-a43e-181700632f76', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'Complete: "This weekend Yosra ___ buy a souvenir at Camden Market."', '[{"id":"a","text":"are going to"},{"id":"b","text":"going to"},{"id":"c","text":"is going"},{"id":"d","text":"is going to"}]'::jsonb, 'd', 'Yosra is one person (she), so the plan is "is going to" + the base verb: is going to buy. "Are going to" is for we/you/they, "going to" drops the verb be, and "is going" forgets the word "to".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd5cb1a4-0f20-569c-921f-41d5b1708361', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'Complete: "Skander and his cousins ___ take the Tube to Oxford Street."', '[{"id":"a","text":"are going to"},{"id":"b","text":"am going to"},{"id":"c","text":"is going to"},{"id":"d","text":"going to"}]'::jsonb, 'a', '"Skander and his cousins" are several people (they), so we use "are going to" + base verb: are going to take. "Am going to" is only for I, "is going to" is for one person, and "going to" is missing the verb be.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46b2b5d1-39c0-5f1d-a737-14d408a34afd', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'Complete: "The River Thames is ___ than the small stream near our house."', '[{"id":"a","text":"wide"},{"id":"b","text":"wider"},{"id":"c","text":"more wide"},{"id":"d","text":"widest"}]'::jsonb, 'b', '"Wide" is a short adjective, so its comparative adds -r: wider than. "Wide" alone is not a comparison, "more wide" marks it twice, and "widest" is the superlative, not a comparison of two things.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d385ed0d-c2c2-5426-8c86-25fe3b347627', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'Complete: "In my opinion, the British Museum is ___ than a shopping street."', '[{"id":"a","text":"interesting"},{"id":"b","text":"interestinger"},{"id":"c","text":"more interesting"},{"id":"d","text":"most interesting"}]'::jsonb, 'c', '"Interesting" is a long adjective (more than two syllables), so its comparative is "more interesting than". "Interestinger" does not exist, "interesting" alone is not a comparison, and "most interesting" is a superlative.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f44d2f8-eba0-52d6-ab1e-d5120996734c', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'Complete: "Skander thinks the London Eye is ___ wheel in the whole city."', '[{"id":"a","text":"the biggest"},{"id":"b","text":"the bigger"},{"id":"c","text":"the most big"},{"id":"d","text":"biggest"}]'::jsonb, 'a', 'One wheel above all the others in the city is a superlative: the biggest (short adjective, double the -g and add -est). "The bigger" is a comparative, "the most big" is wrong for a short adjective, and "biggest" forgets "the".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8ae438c-e8ae-5cb1-b967-d883295ae41b', '815e6837-2ba6-5dba-b520-1826fb773cf7', 'Complete this suggestion: "___ go to Hyde Park by bus — it is cheaper than a taxi."', '[{"id":"a","text":"How about"},{"id":"b","text":"Let''s"},{"id":"c","text":"Let''s to"},{"id":"d","text":"Why don''t"}]'::jsonb, 'b', '"Let''s" + the base verb makes a suggestion: Let''s go. "How about" needs -ing (How about going), "Let''s to" adds an extra "to", and "Why don''t" needs a subject (Why don''t we go).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', '⚔️ Chapter boss ⭐⭐⭐: planning the day in London', 3, 120, 30, 'boss', 'admin', 2)
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
  ('9244384c-b971-5fa4-91ed-c4ce946ed419', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', 'The sky is clear and sunny. Complete: "We ___ take our umbrellas to the park today."', '[{"id":"a","text":"don''t going to"},{"id":"b","text":"aren''t going to"},{"id":"c","text":"not going to"},{"id":"d","text":"aren''t go to"}]'::jsonb, 'b', 'The negative of "be going to" puts "not" after are: aren''t going to take. "Don''t going to" uses the wrong auxiliary, "not going to" forgets the verb be, and "aren''t go to" drops the -ing of going.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('024636e0-2c65-51ac-a9d4-e5d8e0aec546', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', 'Complete: "The guide says the weather in London is ___ in summer than in winter."', '[{"id":"a","text":"gooder"},{"id":"b","text":"better"},{"id":"c","text":"more good"},{"id":"d","text":"more better"}]'::jsonb, 'b', '"Good" is irregular: its comparative is "better" (than), not a form with -er or more. "Gooder", "more good" and "more better" are all impossible — you must learn good → better by heart.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8408e232-4eb7-51a1-96c7-d7638f5cf304', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', 'Complete: "Skander says the fish and chips by the river was ___ meal of the whole trip."', '[{"id":"a","text":"the goodest"},{"id":"b","text":"the most good"},{"id":"c","text":"the better"},{"id":"d","text":"the best"}]'::jsonb, 'd', '"Good" is irregular, so its superlative is "the best" ✓. "The goodest" and "the most good" do not exist, and "the better" is a comparative, not the top of the group. The common trap is trying to build a regular form from "good".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('216f2b82-3853-5a19-8a18-2766091c07b2', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', 'Complete the question: "___ you going to visit the Tower of London tomorrow?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Is"},{"id":"c","text":"Are"},{"id":"d","text":"Does"}]'::jsonb, 'c', 'A "be going to" question begins with am/is/are before the subject: Are you going to visit…? ✓ "Do" and "Does" belong to the present simple, and "Is" does not agree with "you". The trap is using "do" as if it were an ordinary verb question.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79ff7f03-ecd6-50c1-82ec-287f62cb68be', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', 'Complete: "Oxford Street is ___ than Camden Market, but Camden is more fun."', '[{"id":"a","text":"more crowded"},{"id":"b","text":"crowdeder"},{"id":"c","text":"more crowdeder"},{"id":"d","text":"most crowded"}]'::jsonb, 'a', '"Crowded" has two syllables and does not end in -y, so its comparative is "more crowded than" ✓. "Crowdeder" and "more crowdeder" are impossible, and "most crowded" is a superlative, not a comparison of two places.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b0e10ac-3194-550c-b69e-3a57604c0800', 'f441c60a-c859-5ccf-a7ca-f1c5e99ec6aa', 'You are tired after walking. Which suggestion is written correctly?', '[{"id":"a","text":"Why don''t we to take a taxi?"},{"id":"b","text":"Why we don''t take a taxi?"},{"id":"c","text":"Why don''t we taking a taxi?"},{"id":"d","text":"Why don''t we take a taxi?"}]'::jsonb, 'd', '"Why don''t we" is followed by the base verb: Why don''t we take a taxi? ✓ Option a adds an extra "to", option b puts the words in the wrong order, and option c uses -ing instead of the base verb. The trap is treating it like "How about", which alone takes -ing.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5ac21398-24b0-5f94-8b53-c954575c76c4', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', '⭐⭐ Revision (exam style): plans, comparisons and the way there', 2, 70, 15, 'practice', 'admin', 3)
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
  ('1739e207-19ce-58fb-8e70-e07f20a4ba1d', '5ac21398-24b0-5f94-8b53-c954575c76c4', 'Complete: "Skander ___ leave the hotel at nine o''clock to catch the early train."', '[{"id":"a","text":"are going to"},{"id":"b","text":"is going to"},{"id":"c","text":"going to"},{"id":"d","text":"is go to"}]'::jsonb, 'b', 'This is a fixed plan for one person (he), so we use "is going to" + base verb: is going to leave. "Are going to" does not agree with Skander, "going to" drops the verb be, and "is go to" is not correct.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00c0b5ab-ec9c-55aa-91dc-c017ccb3b18b', '5ac21398-24b0-5f94-8b53-c954575c76c4', 'Complete: "London is ___ than Tunis: it has millions of people."', '[{"id":"a","text":"big"},{"id":"b","text":"more big"},{"id":"c","text":"bigger"},{"id":"d","text":"biggest"}]'::jsonb, 'c', '"Big" is short (one vowel + one consonant), so we double the -g and add -er: bigger than. "Big" alone is not a comparison, "more big" marks it twice, and "biggest" is the superlative.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e161ff64-f172-512b-bf9f-39581b60c852', '5ac21398-24b0-5f94-8b53-c954575c76c4', 'Complete: "For Yosra, the Natural History Museum is ___ place in London."', '[{"id":"a","text":"the beautifulest"},{"id":"b","text":"the more beautiful"},{"id":"c","text":"most beautiful"},{"id":"d","text":"the most beautiful"}]'::jsonb, 'd', '"Beautiful" is a long adjective, so its superlative is "the most beautiful" ✓. "The beautifulest" does not exist, "the more beautiful" is a comparative form, and "most beautiful" forgets the word "the".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c53ffef4-4035-562c-aee3-08eab1dd985a', '5ac21398-24b0-5f94-8b53-c954575c76c4', 'Someone asks the way. Complete: "How do I get to the station? — ___ straight on, then turn right."', '[{"id":"a","text":"Go"},{"id":"b","text":"Going"},{"id":"c","text":"To go"},{"id":"d","text":"Goes"}]'::jsonb, 'a', 'Directions use the base verb like an instruction: Go straight on. "Going", "to go" and "goes" are not used to tell someone the way — you simply say "go".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('416a83a3-64c7-5b7f-a108-5d787d5f29ff', '5ac21398-24b0-5f94-8b53-c954575c76c4', 'Complete this suggestion: "___ we meet in front of Big Ben at noon?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Shall"},{"id":"c","text":"Are"},{"id":"d","text":"Let''s"}]'::jsonb, 'b', '"Shall we" + base verb is a natural way to suggest something: Shall we meet…? "Do we" and "Are we" ask ordinary questions, not a friendly suggestion, and "Let''s" is not followed by "we" (it already means "let us").', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee55402f-2379-5d67-a68e-71aa5a2da723', '5ac21398-24b0-5f94-8b53-c954575c76c4', 'Complete: "___ Skander going to buy the red T-shirt or the blue one?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Does"},{"id":"c","text":"Is"},{"id":"d","text":"Are"}]'::jsonb, 'c', 'A "be going to" question about one person starts with "Is": Is Skander going to buy…? "Do" and "Does" belong to the present simple, and "Are" does not agree with one person.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('554cc664-6084-50ad-9481-0e45c24cf9cb', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: master explorer of London', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('bb57037d-e2c1-5186-9d5a-4b53f962b6c4', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'Complete: "Skander says, ''The Tube is faster, so I ___ take it instead of the bus.''"', '[{"id":"a","text":"am going to"},{"id":"b","text":"is going to"},{"id":"c","text":"going to"},{"id":"d","text":"am go to"}]'::jsonb, 'a', 'The speaker is "I", so the plan is "am going to" + base verb: I am going to take. "Is going to" is for he/she/it, "going to" drops the verb be, and "am go to" removes the -ing of going.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c0adfec-2884-5954-bd04-b06dab930149', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'Complete: "Of all the streets here, Oxford Street is ___, so let''s start there."', '[{"id":"a","text":"the busyest"},{"id":"b","text":"busiest"},{"id":"c","text":"the busiest"},{"id":"d","text":"the most busy"}]'::jsonb, 'c', '"Busy" ends in -y, so the superlative changes y → i and adds -est, with "the": the busiest ✓. "The busyest" keeps the y wrongly, "busiest" forgets "the", and "the most busy" is wrong for a short -y adjective. The trap is not applying the y → i spelling.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b71aa2ec-31c3-5149-9790-3abe419abf8e', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'One sentence has a mistake. Which one? (1) London is bigger than Tunis. (2) The Shard is the tallest building. (3) This bus is more slower than the Tube. (4) We are going to visit the park.', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'Sentence 3 marks the comparative twice: "more slower" ✓ is the error — it should be "slower than" (or "more slow" is also wrong; slow is short, so "slower"). Sentences 1, 2 and 4 correctly use "bigger than", "the tallest" and "are going to". The common trap is adding "more" to an adjective that already has -er.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('204d5964-0e2c-523b-ae60-21b78b22824b', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'Turn this into a suggestion with -ing: "Let''s visit the museum." → "___ the museum?"', '[{"id":"a","text":"How about visit"},{"id":"b","text":"How about to visit"},{"id":"c","text":"How about visits"},{"id":"d","text":"How about visiting"}]'::jsonb, 'd', 'After "How about", the verb takes -ing: How about visiting the museum? ✓ "How about visit / to visit / visits" all use the wrong verb form. The common trap is keeping the base verb the way you would after "Let''s".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ecba4d4-1956-5362-8c97-e025aed63827', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'Complete: "The traffic today is ___ than yesterday, so we are going to walk."', '[{"id":"a","text":"worst"},{"id":"b","text":"worse"},{"id":"c","text":"badder"},{"id":"d","text":"more bad"}]'::jsonb, 'b', '"Bad" is irregular: its comparative is "worse" (than) ✓. "Worst" is the superlative (the top of a group), while "badder" and "more bad" do not exist. The common trap is using the superlative "worst" where a comparison of two days needs "worse".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ceb8340e-c7e4-500c-9fcd-23c5575215b1', '554cc664-6084-50ad-9481-0e45c24cf9cb', 'Complete: "For visitors, the British Museum is ___ museum in this part of London."', '[{"id":"a","text":"the famousest"},{"id":"b","text":"most famous"},{"id":"c","text":"the more famous"},{"id":"d","text":"the most famous"}]'::jsonb, 'd', '"Famous" is a longer adjective, so the superlative is "the most famous" ✓. "The famousest" does not exist, "most famous" forgets "the", and "the more famous" is a comparative, not a superlative. The trap is dropping "the" or choosing the comparative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', '📝 Training ⭐⭐⭐: whole-chapter drill (global revision)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('3721bff2-3aea-5038-890e-d0f8579a46da', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', 'Look at those dark clouds! Complete: "It ___ rain this afternoon."', '[{"id":"a","text":"are going to"},{"id":"b","text":"going to"},{"id":"c","text":"is going to"},{"id":"d","text":"goes to"}]'::jsonb, 'c', 'When we see evidence now (dark clouds), we predict with "be going to": it is going to rain ✓. "Are going to" does not agree with "it", "going to" drops the verb be, and "goes to" is the present simple, not a prediction.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d533cfd1-ced5-52cc-8637-c38c322d0584', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', 'Complete: "A taxi is ___ than the Underground in London."', '[{"id":"a","text":"expensiver"},{"id":"b","text":"most expensive"},{"id":"c","text":"more expensiver"},{"id":"d","text":"more expensive"}]'::jsonb, 'd', '"Expensive" is a long adjective, so its comparative is "more expensive than" ✓. "Expensiver" and "more expensiver" are impossible forms, and "most expensive" is the superlative, not a comparison of two things.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('faeb92fb-52a3-5463-a003-8df2338740f4', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', 'Complete: "That was ___ day of the whole trip — everyone laughed a lot."', '[{"id":"a","text":"the happyest"},{"id":"b","text":"the happiest"},{"id":"c","text":"the most happy"},{"id":"d","text":"happiest"}]'::jsonb, 'b', '"Happy" ends in -y, so the superlative changes y → i and adds -est, with "the": the happiest ✓. "The happyest" keeps the y wrongly, "the most happy" is wrong for a short -y adjective, and "happiest" forgets "the".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('599c8e23-5b03-5c9b-a37a-42de3bc4dac1', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', 'Complete these directions: "Go past the bank, ___ the second turning on your left, and the café is opposite the park."', '[{"id":"a","text":"take"},{"id":"b","text":"taking"},{"id":"c","text":"to take"},{"id":"d","text":"takes"}]'::jsonb, 'a', 'Directions use the base verb: take the second turning ✓. "Taking", "to take" and "takes" are not used to give an instruction — you simply tell the person to "take" the turning.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23f6c03d-4124-5b71-8486-8523c1757e57', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', 'Complete the question: "___ they going to see a play at the theatre tonight?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Is"},{"id":"c","text":"Does"},{"id":"d","text":"Are"}]'::jsonb, 'd', 'A "be going to" question with "they" begins with "Are": Are they going to see…? ✓ "Do" and "Does" belong to the present simple, and "Is" does not agree with the plural "they".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9603466f-25ba-506a-8218-f1dc4748b1d6', 'cb6e1b0b-8f36-5f83-aec3-e622592cb8a3', 'It is raining. Which suggestion is written correctly?', '[{"id":"a","text":"We could to visit an indoor market instead."},{"id":"b","text":"We could visit an indoor market instead."},{"id":"c","text":"We coulding visit an indoor market instead."},{"id":"d","text":"We could visiting an indoor market instead."}]'::jsonb, 'b', '"We could" is followed by the base verb: We could visit ✓. "We could to visit" adds an extra "to", "we coulding" invents an impossible form, and "we could visiting" uses -ing where the base verb is needed.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('388898c0-624b-55f6-a638-20e03d2dcb9e', '8185a1c0-ff3c-53c3-91bd-5b201f52fa24', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: the top explorer''s final test', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('5dc45c96-f8ad-5c15-945e-7e2dde6fcbed', '388898c0-624b-55f6-a638-20e03d2dcb9e', 'Complete: "Our guide says we ___ visit the oldest part of the city first."', '[{"id":"a","text":"are going to"},{"id":"b","text":"is going to"},{"id":"c","text":"going to"},{"id":"d","text":"are go to"}]'::jsonb, 'a', '"We" takes "are going to" + base verb: we are going to visit ✓. "Is going to" is for one person, "going to" drops the verb be, and "are go to" removes the -ing of going.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('481f952b-6d37-58f2-b0cf-271a36882db9', '388898c0-624b-55f6-a638-20e03d2dcb9e', 'Complete: "The stadium is ___ from the hotel than the museum, so let''s go there last."', '[{"id":"a","text":"more far"},{"id":"b","text":"farer"},{"id":"c","text":"farther"},{"id":"d","text":"farthest"}]'::jsonb, 'c', '"Far" is irregular: its comparative is "farther" (than) ✓. "More far" and "farer" are not correct forms, and "farthest" is the superlative, not a comparison of two distances. The common trap is building a regular comparative from "far".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('366b537d-eeb3-5c9d-8db6-e87ba33ace9c', '388898c0-624b-55f6-a638-20e03d2dcb9e', 'One sentence has a mistake. Which one? (1) This is the most expensive shop. (2) Camden is the most cheapest market. (3) The Tube is faster than the bus. (4) We are going to walk to the park.', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'b', 'Sentence 2 marks the superlative twice: "the most cheapest" ✓ is the error — "cheap" is short, so it should be "the cheapest". Sentences 1, 3 and 4 correctly use "the most expensive", "faster than" and "are going to". The trap is adding "most" to an adjective that already has -est.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c5021a3-b5f9-5747-8630-48a3e83c75d4', '388898c0-624b-55f6-a638-20e03d2dcb9e', 'Which suggestion to take the river boat to Tower Bridge is written correctly?', '[{"id":"a","text":"Shall we to take the river boat?"},{"id":"b","text":"Shall we taking the river boat?"},{"id":"c","text":"Do we shall take the river boat?"},{"id":"d","text":"Shall we take the river boat?"}]'::jsonb, 'd', '"Shall we" is followed by the base verb: Shall we take the river boat? ✓ Option a adds an extra "to", option b uses -ing, and option c puts "do" before "shall", which is impossible. The trap is treating "shall" like an ordinary verb that needs "do".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6a4efe4-bd9c-523d-8b29-7e04758f06d9', '388898c0-624b-55f6-a638-20e03d2dcb9e', 'Complete: "London''s new buildings are ___ than the very old ones in the medina at home."', '[{"id":"a","text":"moderner"},{"id":"b","text":"more moderner"},{"id":"c","text":"more modern"},{"id":"d","text":"most modern"}]'::jsonb, 'c', '"Modern" has two syllables and does not end in -y, so its comparative is "more modern than" ✓. "Moderner" and "more moderner" are impossible, and "most modern" is the superlative, not a comparison of two sets of buildings.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a4f1a84-cf91-5264-8e22-28aef127c41f', '388898c0-624b-55f6-a638-20e03d2dcb9e', 'Which sentence is completely correct?', '[{"id":"a","text":"We going to climb the highest tower in London."},{"id":"b","text":"We are going to climb the highest tower in London."},{"id":"c","text":"We are going to climb the most high tower in London."},{"id":"d","text":"We are going to climbing the highest tower in London."}]'::jsonb, 'b', 'Option b is correct: "are going to" + base verb (climb), and the superlative of the short adjective "high" is "the highest" ✓. Option a forgets "are", option c uses "the most high" (wrong for a short adjective), and option d puts -ing on "climb" after "to". This item combines be going to with a superlative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', '6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('dbb17bac-7c4d-5edd-96c9-076fe2f081e8', '0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', 'Complete: "I ___ visited Edinburgh Castle with my family."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"am"},{"id":"d","text":"is"}]'::jsonb, 'a', 'The present perfect is have/has + past participle. With "I" the auxiliary is "have": I have visited. "Has" is only for he/she/it, and "am/is" are forms of the verb be, not the present perfect auxiliary.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9abe414e-c8a8-5b56-87b6-c867dc141a65', '0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', 'Complete: "My sister ___ travelled to Scotland this spring."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"is"},{"id":"d","text":"have been"}]'::jsonb, 'b', '"My sister" is one person (she), so the auxiliary is "has": my sister has travelled. "Have" goes with I/you/we/they, and "is / have been" do not fit this sentence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61029271-fc9f-5f55-9680-64e32a597a66', '0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', 'Complete: "We have ___ the old town of Edinburgh."', '[{"id":"a","text":"see"},{"id":"b","text":"saw"},{"id":"c","text":"seen"},{"id":"d","text":"seed"}]'::jsonb, 'c', 'After have/has you need the past participle. The past participle of "see" is the irregular "seen": we have seen. "See" is the base form, "saw" is the simple past (not a participle), and "seed" does not exist.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e859f4c-2451-5095-beee-9870aabade96', '0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', 'Complete the question: "___ she ever seen a real castle?"', '[{"id":"a","text":"Have"},{"id":"b","text":"Has"},{"id":"c","text":"Is"},{"id":"d","text":"Does"}]'::jsonb, 'b', 'In a present perfect question with "ever", the auxiliary comes first and agrees with the subject. "She" takes "has": Has she ever seen…? "Have" is for I/you/we/they, and "is/does" are not present perfect auxiliaries.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('424535a1-54ab-5591-bd2b-daeb9b860fed', '0be2e0ab-1dd6-5a5f-b73d-1bfb623f4924', 'Which sentence is correct?', '[{"id":"a","text":"He has go to the airport."},{"id":"b","text":"He have gone to the airport."},{"id":"c","text":"He has went to the airport."},{"id":"d","text":"He has gone to the airport."}]'::jsonb, 'd', '"He" needs "has", and the past participle of "go" is "gone": He has gone. "Has go" uses the base form, "have gone" uses the wrong auxiliary for he, and "has went" uses the simple past instead of the participle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bd03fff4-0ea3-52d1-bce6-a5a29a349c02', '6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', '⭐ Practice: our first trip to Edinburgh', 1, 50, 10, 'practice', 'admin', 1)
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
  ('cf91fae8-e83b-5211-9974-c2615944cb87', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', 'Complete: "We ___ arrived in Edinburgh."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"is"},{"id":"d","text":"are"}]'::jsonb, 'a', '"We" takes the auxiliary "have": we have arrived. "Has" is only for he/she/it, and "is/are" are forms of the verb be, not the present perfect auxiliary.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f760ae53-b4ab-50ff-bedb-59e32cbfa370', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', 'Complete: "My father ___ booked a hotel near the castle."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"is"},{"id":"d","text":"are"}]'::jsonb, 'b', '"My father" is one person (he), so the auxiliary is "has": my father has booked. "Have" goes with I/you/we/they, and "is/are" are not present perfect auxiliaries.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aec8f4b3-7396-563f-87dd-b0257a65e4a5', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', 'Complete: "They have ___ their bags for the trip."', '[{"id":"a","text":"pack"},{"id":"b","text":"packs"},{"id":"c","text":"packing"},{"id":"d","text":"packed"}]'::jsonb, 'd', 'After "have" you need the past participle. "Pack" is a regular verb, so its participle is "packed": they have packed. "Pack" is the base form, "packs" is the present simple, and "packing" is the -ing form.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa8e9592-6117-5cab-9423-9fbec17b4688', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', 'Complete: "I have ___ to the museum twice."', '[{"id":"a","text":"was"},{"id":"b","text":"be"},{"id":"c","text":"been"},{"id":"d","text":"being"}]'::jsonb, 'c', 'The past participle of "be" is the irregular "been": I have been to the museum. "Was" is the simple past, "be" is the base form, and "being" is the -ing form — none of these can follow "have" here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f746c7ba-f17b-539b-b9e5-4c303acc644c', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', 'Complete: "At the airport, we check in our ___ before the flight."', '[{"id":"a","text":"luggage"},{"id":"b","text":"kitchen"},{"id":"c","text":"homework"},{"id":"d","text":"blackboard"}]'::jsonb, 'a', '"Luggage" means the bags and suitcases you travel with, and you check it in at the airport. A kitchen, homework and a blackboard have nothing to do with travelling by plane.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0924afaa-5494-532f-9384-817a574161d1', 'bd03fff4-0ea3-52d1-bce6-a5a29a349c02', 'Complete: "This is my first visit to Scotland — I have ___ been here before."', '[{"id":"a","text":"ever"},{"id":"b","text":"never"},{"id":"c","text":"already"},{"id":"d","text":"yet"}]'::jsonb, 'b', 'It is the first visit, so the experience did not happen before: we use "never" (not at any time): I have never been here. "Ever" is for questions, and "already/yet" would mean the opposite here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('06669ebb-9f7d-5d77-9001-208f6e67c2c8', '6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', '⚔️ Chapter boss ⭐⭐⭐: the Edinburgh challenge', 3, 120, 30, 'boss', 'admin', 2)
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
  ('a66b5dcc-6258-5797-a558-c76ba83840d3', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', 'Complete: "My parents ___ many countries." (verb: visit)', '[{"id":"a","text":"have visited"},{"id":"b","text":"has visited"},{"id":"c","text":"have visit"},{"id":"d","text":"has visit"}]'::jsonb, 'a', '"My parents" is plural (they), so the auxiliary is "have", and the regular participle of visit is "visited": have visited. "Has" is wrong for a plural subject, and "visit" without -ed is the base form, not a participle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c57edd91-01de-514f-8c44-6f852d2da469', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', 'Complete: "Rania ___ lots of photos of the castle." (verb: take)', '[{"id":"a","text":"has took"},{"id":"b","text":"has taken"},{"id":"c","text":"have taken"},{"id":"d","text":"has take"}]'::jsonb, 'b', 'Rania is one person (she) → "has", and the irregular participle of take is "taken": has taken. "Took" is the simple past (not a participle), "have" is the wrong auxiliary for she, and "take" is the base form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec9904a3-f69e-56e6-a03a-ee9540993b62', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', 'Complete: "The plane ___ landed; we are collecting our bags now."', '[{"id":"a","text":"just has landed"},{"id":"b","text":"have just landed"},{"id":"c","text":"has just landed"},{"id":"d","text":"has landed just"}]'::jsonb, 'c', '"Just" sits between the auxiliary and the participle, and the plane (it) takes "has": has just landed ✓. "Just has" and "landed just" put the word in the wrong place, and "have" does not agree with "the plane".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('161e5fcd-f671-531e-a6ab-5e3e1445aae7', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', 'Only ONE sentence is correct. Which one?', '[{"id":"a","text":"I have never eat haggis."},{"id":"b","text":"I has never eaten haggis."},{"id":"c","text":"I have never ate haggis."},{"id":"d","text":"I have never eaten haggis."}]'::jsonb, 'd', '"I" takes "have", "never" goes before the participle, and the participle of eat is "eaten": I have never eaten ✓. "Eat" is the base form, "has" is wrong with I, and "ate" is the simple past, not the participle.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7b8a7f7-db33-5fd8-ab5d-32c5e298a387', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', 'Complete: "We ___ souvenirs for our family in Tunis." (verb: buy)', '[{"id":"a","text":"have bought"},{"id":"b","text":"has bought"},{"id":"c","text":"have buyed"},{"id":"d","text":"have buy"}]'::jsonb, 'a', '"We" → "have", and the irregular participle of buy is "bought": have bought ✓. "Has" is wrong for we, "buyed" invents a regular ending for an irregular verb, and "buy" is the base form.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('908c9945-1e76-5d23-acd5-6002d84d556f', '06669ebb-9f7d-5d77-9001-208f6e67c2c8', 'Complete: "''Could you ___ me what time breakfast starts?'' asked the tourist."', '[{"id":"a","text":"say"},{"id":"b","text":"talk"},{"id":"c","text":"tell"},{"id":"d","text":"speak"}]'::jsonb, 'c', 'To ask for information politely we say "Could you tell me…?" — "tell" takes a person (tell me). "Say" is not used with a person like this ("say me" is wrong), and "talk/speak" do not fit the pattern "___ me what time…".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3d0b4ef1-98fe-5c10-a611-07bf01a519b2', '6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', '⭐⭐ Review (exam style): a holiday in Scotland', 2, 70, 15, 'practice', 'admin', 3)
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
  ('24b8097a-2614-5e50-aa73-d6c1c2bfdac0', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', 'Complete: "My sister ___ taken lots of photos of the parade."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"is"},{"id":"d","text":"are"}]'::jsonb, 'b', '"My sister" is one person (she), so the auxiliary is "has": my sister has taken. "Have" is for I/you/we/they, and "is/are" are not present perfect auxiliaries.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37df6fcc-3d75-5a95-9861-047e3dc11d9b', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', 'Complete: "We have ___ postcards to our friends in Tunis." (verb: write)', '[{"id":"a","text":"write"},{"id":"b","text":"wrote"},{"id":"c","text":"writed"},{"id":"d","text":"written"}]'::jsonb, 'd', 'The irregular participle of write is "written": we have written ✓. "Write" is the base form, "wrote" is the simple past (not a participle), and "writed" does not exist.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bc5042c-e622-5de9-bcce-93cbd2dafcba', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', 'Complete the question: "___ you ever eaten haggis in Scotland?"', '[{"id":"a","text":"Have"},{"id":"b","text":"Has"},{"id":"c","text":"Are"},{"id":"d","text":"Did"}]'::jsonb, 'a', '"You" takes "have", and the participle "eaten" completes the present perfect question: Have you ever eaten…? "Has" is for he/she/it, and "are/did" are not present perfect auxiliaries.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4af7c18a-172b-5472-ba37-e6a9a0874a98', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', 'Complete: "___ me, how do I get to the castle, please?"', '[{"id":"a","text":"Excuse"},{"id":"b","text":"Sorry for"},{"id":"c","text":"Please to"},{"id":"d","text":"Give"}]'::jsonb, 'a', 'To ask a stranger for information politely, you start with "Excuse me": Excuse me, how do I get to the castle? "Sorry for", "Please to" and "Give" are not the correct polite opening for asking directions.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d209772-ac27-5c18-a44f-059d60fb9306', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', 'Complete: "During our holiday, we stayed in a small ___ near the sea."', '[{"id":"a","text":"passport"},{"id":"b","text":"hotel"},{"id":"c","text":"suitcase"},{"id":"d","text":"flight"}]'::jsonb, 'b', 'A "hotel" is the building where travellers sleep during a holiday. A passport is a travel document, a suitcase carries your clothes, and a flight is a plane journey — none of them is a place to stay.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bba198ff-7946-5612-a1ac-7f25450c5b34', '3d0b4ef1-98fe-5c10-a611-07bf01a519b2', 'Which sentence is correct?', '[{"id":"a","text":"She has saw the parade."},{"id":"b","text":"She have seen the parade."},{"id":"c","text":"She has seen the parade."},{"id":"d","text":"She has see the parade."}]'::jsonb, 'c', '"She" takes "has", and the participle of see is "seen": She has seen ✓. "Saw" is the simple past, "have" is the wrong auxiliary for she, and "see" is the base form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('24ccdf30-c6af-502b-9965-a3f68f1a5f79', '6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: master of the Edinburgh journey', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('f5267583-61a6-59b7-a628-e8331414e425', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', 'Complete: "My brother ___ packed his bag, but my sisters ___ not finished yet."', '[{"id":"a","text":"have … has"},{"id":"b","text":"has … have"},{"id":"c","text":"has … has"},{"id":"d","text":"have … have"}]'::jsonb, 'b', '"My brother" is one person (he) → "has packed"; "my sisters" is plural (they) → "have not finished". So: has … have ✓. The trap is using the same auxiliary for both — each subject decides its own.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e30ebe7f-f653-50e4-b909-61a92169314d', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', 'Complete: "We ___ from Tunis to Edinburgh in about four hours." (verb: fly)', '[{"id":"a","text":"have flew"},{"id":"b","text":"has flown"},{"id":"c","text":"have flied"},{"id":"d","text":"have flown"}]'::jsonb, 'd', '"We" takes "have", and the irregular participle of fly is "flown": have flown ✓. "Flew" is the simple past, "flied" invents a regular ending, and "has" does not agree with we.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b97a4a9a-73dc-51f9-a236-16997ea82112', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', 'Only ONE sentence is correct. Which one?', '[{"id":"a","text":"Have you ever visited Scotland?"},{"id":"b","text":"Has you ever visited Scotland?"},{"id":"c","text":"Have you ever visit Scotland?"},{"id":"d","text":"Did you ever visited Scotland?"}]'::jsonb, 'a', '"You" takes "have", and the participle "visited" completes the question: Have you ever visited…? ✓. "Has" is wrong with you, "visit" is the base form, and "Did … visited" mixes the simple past auxiliary with a participle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c993d4b4-e7e7-55f1-95f3-f7fbf517d4fc', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', 'Which statement about the present perfect is TRUE?', '[{"id":"a","text":"It is formed with ''have'' or ''has'' + the base form of the verb."},{"id":"b","text":"''Has'' is used with I, you, we and they."},{"id":"c","text":"It is formed with ''have'' or ''has'' + the past participle."},{"id":"d","text":"The past participle of ''go'' is ''goed''."}]'::jsonb, 'c', 'The present perfect = have/has + past participle ✓. Option a is wrong (it uses the participle, not the base form), b is wrong ("has" is for he/she/it, not I/you/we/they), and d is wrong (the participle of go is "gone", not "goed").', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3969ebfb-47e8-5ea3-9a6c-186af19c574e', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', 'Complete: "''___ you ever ___ in a Scottish castle?'' the guide asked the ___."', '[{"id":"a","text":"Has … stayed … tourists"},{"id":"b","text":"Have … stay … tourists"},{"id":"c","text":"Have … staid … tourist"},{"id":"d","text":"Have … stayed … tourists"}]'::jsonb, 'd', '"You" takes "have", the regular participle of stay is "stayed", and the guide speaks to more than one visitor → "tourists": Have you ever stayed … tourists ✓. "Has" is wrong with you, "stay" is the base form, and "staid" is a wrong spelling of the participle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2cff6df7-36aa-5ba0-9425-5aabb0b7cdc4', '24ccdf30-c6af-502b-9965-a3f68f1a5f79', 'Complete: "''I have ___ my boarding pass!'' ''Don''t worry, you can print it at the ___.''" (verb: lose)', '[{"id":"a","text":"lose … check-in machine"},{"id":"b","text":"lost … check-in machine"},{"id":"c","text":"losed … check-in machine"},{"id":"d","text":"lost … swimming pool"}]'::jsonb, 'b', 'The irregular participle of lose is "lost": I have lost ✓, and you print a boarding pass at the "check-in machine" at the airport. "Lose" is the base form, "losed" invents a regular ending, and a swimming pool is not where you print a boarding pass.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', '6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', '📝 Training ⭐⭐⭐: full review of Module Four', 3, 120, 30, 'boss', 'admin', 5)
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
  ('dd54c768-add2-504f-9a9f-2c14320cad16', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'Complete: "The tourists ___ arrived at the airport in Edinburgh."', '[{"id":"a","text":"has arrived"},{"id":"b","text":"have arrived"},{"id":"c","text":"have arrive"},{"id":"d","text":"has arrive"}]'::jsonb, 'b', '"The tourists" is plural (they), so the auxiliary is "have", and the regular participle is "arrived": have arrived ✓. "Has" is wrong for a plural subject, and "arrive" without -ed is the base form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf49986f-b2a5-506f-b593-26401a63f4fd', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'Complete: "I have ___ all my packing for the trip." (verb: do)', '[{"id":"a","text":"do"},{"id":"b","text":"did"},{"id":"c","text":"done"},{"id":"d","text":"doed"}]'::jsonb, 'c', 'The irregular participle of do is "done": I have done ✓. "Do" is the base form, "did" is the simple past (not a participle), and "doed" does not exist.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de601140-8b50-5228-9db4-04cf6eee6792', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'Complete the question: "___ you ever ridden a double-decker bus?"', '[{"id":"a","text":"Have"},{"id":"b","text":"Has"},{"id":"c","text":"Are"},{"id":"d","text":"Did"}]'::jsonb, 'a', '"You" takes "have", and "ridden" is the participle of ride: Have you ever ridden…? ✓. "Has" is for he/she/it, and "are/did" are not present perfect auxiliaries.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85f2b6bf-3387-55cb-ac95-f224aa5f4559', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'Complete: "Before boarding the plane, passengers wait at the ___."', '[{"id":"a","text":"hotel lobby"},{"id":"b","text":"bus stop"},{"id":"c","text":"baggage claim"},{"id":"d","text":"boarding gate"}]'::jsonb, 'd', 'At the airport, passengers wait at the "boarding gate" before they get on the plane. A hotel lobby and a bus stop are not in the airport, and the "baggage claim" is where you collect bags AFTER the flight, not before boarding.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6e314d9-413a-5f52-8dd2-1857b447cefe', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'Which sentence is WRONG?', '[{"id":"a","text":"We have seen the castle."},{"id":"b","text":"He has eaten lunch."},{"id":"c","text":"They have went home."},{"id":"d","text":"She has read the map."}]'::jsonb, 'c', '"They have went" is wrong: after "have" you need the participle "gone", not the simple past "went" — it should be "They have gone home". Sentences a, b and d correctly use the participles seen, eaten and read.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eec44695-6467-5b5e-8ddc-9efcddaff6e6', '327b7ed3-5b77-55e3-afe0-4fc80ebf6cb4', 'Complete the directions: "Go straight ___, then turn left at the bank."', '[{"id":"a","text":"ahead"},{"id":"b","text":"ahead of"},{"id":"c","text":"front"},{"id":"d","text":"forward to"}]'::jsonb, 'a', 'To give directions we say "go straight ahead" (keep going forward). "Ahead of" needs an object (ahead of you), "front" needs "in front of", and "forward to" is not used for directions here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b9cb3691-2338-550a-bc25-854171086d3f', '6e15a491-165d-5946-8e81-a0e4a0f75e74', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: the final gate of Module Four', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('97f0699d-dd1e-5e47-8acd-8c1bebfc5720', 'b9cb3691-2338-550a-bc25-854171086d3f', 'Complete: "Sarra ___ many kind people during her holiday in Edinburgh." (verb: meet)', '[{"id":"a","text":"have met"},{"id":"b","text":"has meet"},{"id":"c","text":"has met"},{"id":"d","text":"has meeted"}]'::jsonb, 'c', 'Sarra is one person (she) → "has", and the irregular participle of meet is "met": has met ✓. "Have" is wrong for she, "meet" is the base form, and "meeted" invents a regular ending for an irregular verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc619b43-2703-5e7e-8ebd-11960c43fa8e', 'b9cb3691-2338-550a-bc25-854171086d3f', 'Complete: "We have ___ the guidebook about Edinburgh''s history." (verb: read)', '[{"id":"a","text":"readed"},{"id":"b","text":"red"},{"id":"c","text":"reads"},{"id":"d","text":"read"}]'::jsonb, 'd', 'The participle of read is spelled the same as the base form — "read" (but pronounced "red"): we have read ✓. "Readed" does not exist, "red" is a colour, and "reads" is the present simple.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff2f1322-e973-52ce-8641-df29c564693c', 'b9cb3691-2338-550a-bc25-854171086d3f', 'Which sentence has NO mistake?', '[{"id":"a","text":"They has visited the old town."},{"id":"b","text":"They have visited the old town."},{"id":"c","text":"They have visit the old town."},{"id":"d","text":"They having visited the old town."}]'::jsonb, 'b', '"They" takes "have", and the regular participle is "visited": They have visited ✓. "Has" is wrong for they, "visit" is the base form, and "having" is the -ing form, which cannot replace the auxiliary here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94822db1-eb2c-5f50-bf81-f89c829fcb6a', 'b9cb3691-2338-550a-bc25-854171086d3f', 'Complete: "We missed the bus — it ___ just ___." (verb: leave)', '[{"id":"a","text":"has just left"},{"id":"b","text":"has just leaved"},{"id":"c","text":"have just left"},{"id":"d","text":"has just leave"}]'::jsonb, 'a', 'The bus (it) takes "has", "just" sits before the participle, and the participle of leave is "left": has just left ✓. "Leaved" invents a regular ending, "have" is wrong for it, and "leave" is the base form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bedf01a5-b530-5bc2-805c-5d1df36a5b20', 'b9cb3691-2338-550a-bc25-854171086d3f', 'Which sentence correctly talks about a life experience with the present perfect?', '[{"id":"a","text":"I have never went abroad."},{"id":"b","text":"I have never being abroad."},{"id":"c","text":"I has never been abroad."},{"id":"d","text":"I have never been abroad."}]'::jsonb, 'd', '"I" takes "have", "never" goes before the participle, and the participle of be is "been": I have never been abroad ✓. "Went" is the simple past, "being" is the -ing form, and "has" is wrong with I.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e864177-7202-5001-8c59-b67952f9335d', 'b9cb3691-2338-550a-bc25-854171086d3f', 'Complete the polite exchange: "''Excuse me, ___ you tell me where the castle is?'' ''Yes, ___ straight on.''"', '[{"id":"a","text":"can''t … go"},{"id":"b","text":"could … go"},{"id":"c","text":"could … goes"},{"id":"d","text":"could … going"}]'::jsonb, 'b', 'To ask for information politely we use "Could you tell me…?", and to give the direction we use the base form "go": Could you … go straight on ✓. "Can''t" is a negative (wrong here), and "goes/going" are not the right form for a direction.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('59f74f23-1064-5585-99f1-0d7f2b5c542b', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ec4213db-7c62-5075-8f96-973ff111c541', '59f74f23-1064-5585-99f1-0d7f2b5c542b', 'Your friend Sami has a bad toothache. What is the best friendly advice? "You ___ see a dentist."', '[{"id":"a","text":"should"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"mustn''t"},{"id":"d","text":"aren''t"}]'::jsonb, 'a', 'To give friendly advice we use "should" + base verb: You should see a dentist. "Shouldn''t" and "mustn''t" would advise against it, and "aren''t" is not a modal of advice.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed7b3d1b-bf6f-5681-b1cc-f75359de3a9d', '59f74f23-1064-5585-99f1-0d7f2b5c542b', 'It is the law: at a red traffic light every driver ___ stop the car.', '[{"id":"a","text":"can"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"wants"},{"id":"d","text":"must"}]'::jsonb, 'd', 'A law is a strong obligation, so we use "must": every driver must stop. "Can" is about ability, "wants" is about desire, and "shouldn''t" would mean it is a bad idea to stop.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d58d29e-9ce3-5bb8-a6b4-91e9f08bcd83', '59f74f23-1064-5585-99f1-0d7f2b5c542b', 'Choose the correct sentence.', '[{"id":"a","text":"You should to drink more water."},{"id":"b","text":"You should drink more water."},{"id":"c","text":"You shoulds drink more water."},{"id":"d","text":"You should drinking more water."}]'::jsonb, 'b', 'After a modal like "should" we use the base verb with no "to": You should drink water. "Should to drink" adds a wrong "to", "shoulds" adds a wrong -s, and "should drinking" uses the -ing form.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1d4de86-58ad-5d20-96d9-5138d8281e25', '59f74f23-1064-5585-99f1-0d7f2b5c542b', 'Nour is very careful. Complete: "She crosses the street ___."', '[{"id":"a","text":"careful"},{"id":"b","text":"carefuly"},{"id":"c","text":"carefully"},{"id":"d","text":"more careful"}]'::jsonb, 'c', 'To say HOW she crosses, we need the adverb of manner: careful + -ly = carefully. "Careful" is the adjective, "carefuly" is misspelled (keep the double l), and "more careful" is a comparative, not an adverb.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf64af5b-d3a5-5202-9bec-5c7d780ebdd2', '59f74f23-1064-5585-99f1-0d7f2b5c542b', '"How do you feel before an important exam?" — "I feel ___."', '[{"id":"a","text":"worried"},{"id":"b","text":"worry"},{"id":"c","text":"worriedly"},{"id":"d","text":"worries"}]'::jsonb, 'a', 'After "feel" we use an adjective, not an adverb: I feel worried. "Worry" and "worries" are the verb/noun, and "worriedly" is an adverb, which cannot follow "feel".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c22639f0-31c4-5ea1-b072-b93f0cfe9c54', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', '⭐ Practice: advice, rules and feelings', 1, 50, 10, 'practice', 'admin', 1)
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
  ('3f708ebd-041b-582d-8269-affbfc01113a', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', 'Your friend is very tired after football. Give advice: "You ___ rest for a while."', '[{"id":"a","text":"should"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"aren''t"},{"id":"d","text":"mustn''t"}]'::jsonb, 'a', 'Resting when you are tired is a good idea, so we advise with "should": You should rest. The other options would advise against resting or are not modals of advice.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1741ce06-8d24-570b-a293-963917fb64c0', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', 'Give healthy advice: "You ___ eat too much sugar; it is bad for your teeth."', '[{"id":"a","text":"should"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"must"},{"id":"d","text":"can"}]'::jsonb, 'b', 'Too much sugar is a bad idea, so we advise against it with "shouldn''t": You shouldn''t eat too much sugar. "Should" and "must" would tell you to do it, and "can" is about ability.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d66da828-b124-52b6-a085-3307b4ec5e17', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', 'There is a clear rule in the library. Complete: "You ___ be quiet in here."', '[{"id":"a","text":"want"},{"id":"b","text":"mustn''t"},{"id":"c","text":"must"},{"id":"d","text":"like"}]'::jsonb, 'c', 'Being quiet is a rule of the library, an obligation, so we use "must": You must be quiet. "Mustn''t" would forbid being quiet, and "want"/"like" are not modals of obligation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1700411-d219-53ff-8953-94231799ccb3', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', 'It is dangerous. Complete: "You ___ play with matches!"', '[{"id":"a","text":"should"},{"id":"b","text":"must"},{"id":"c","text":"can"},{"id":"d","text":"mustn''t"}]'::jsonb, 'd', 'Playing with matches is forbidden because it is dangerous, so we use "mustn''t": You mustn''t play with matches. "Should"/"must"/"can" would allow or even order it.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f993fe29-2390-5e93-83e4-fea06bab227c', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', 'Turn the adjective into an adverb of manner: "The old man walks very ___." (slow)', '[{"id":"a","text":"slow"},{"id":"b","text":"slowly"},{"id":"c","text":"slowy"},{"id":"d","text":"slower"}]'::jsonb, 'b', 'To describe HOW he walks, add -ly to the adjective: slow → slowly. "Slow" is the adjective, "slowy" is misspelled, and "slower" is a comparative, not an adverb of manner.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8a43e87-b3df-5df2-96d9-feb447cb7bbe', 'c22639f0-31c4-5ea1-b072-b93f0cfe9c54', 'Complete with a feeling: "I feel ___ when my team wins the match."', '[{"id":"a","text":"happy"},{"id":"b","text":"happily"},{"id":"c","text":"happiness"},{"id":"d","text":"happier"}]'::jsonb, 'a', 'After "feel" we use an adjective: I feel happy. "Happily" is an adverb, "happiness" is a noun, and "happier" is a comparative — none of them can follow "feel" here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', '⚔️ Chapter boss ⭐⭐⭐: advice, obligation and opinion', 3, 120, 30, 'boss', 'admin', 2)
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
  ('e2cab4cb-cd52-538d-a3be-d9a698adf115', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', 'Choose the correct sentence.', '[{"id":"a","text":"You should to help your parents at home."},{"id":"b","text":"You should help your parents at home."},{"id":"c","text":"You should helping your parents at home."},{"id":"d","text":"You shoulds help your parents at home."}]'::jsonb, 'b', 'The pattern is "should + base verb" with no "to" and no -s: You should help ✓. The common trap is "should to help", which adds a wrong "to". "Should helping" uses -ing, and "shoulds" wrongly adds -s to the modal.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22d30e46-759c-5090-b757-6ee74772d0fd', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', 'Rami wants to keep his new puppy healthy. Complete: "He ___ feed it every day — a pet needs food to live."', '[{"id":"a","text":"must"},{"id":"b","text":"mustn''t"},{"id":"c","text":"shouldn''t"},{"id":"d","text":"can''t"}]'::jsonb, 'a', 'Feeding a pet is a necessity, not just a good idea, so we use "must": He must feed it every day ✓. "Mustn''t" and "shouldn''t" would forbid or discourage feeding, and "can''t" is about ability.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba9b2902-7f87-5adb-b6b7-55dc1e9fcba8', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', 'Give your opinion about pollution. Complete: "___ , factories should protect the rivers."', '[{"id":"a","text":"In my opinion"},{"id":"b","text":"I am agree"},{"id":"c","text":"I feel opinion"},{"id":"d","text":"I think so"}]'::jsonb, 'a', 'To introduce your own idea we say "In my opinion, …": In my opinion, factories should protect the rivers ✓. "I am agree" is wrong English (say "I agree"), "I feel opinion" is meaningless, and "I think so" only reacts to someone else''s idea.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33f62bf7-c10e-5fef-82ba-36da19638f98', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', 'Leila is a very happy girl. Complete: "She always greets her friends ___." (happy)', '[{"id":"a","text":"happy"},{"id":"b","text":"happyly"},{"id":"c","text":"happily"},{"id":"d","text":"more happy"}]'::jsonb, 'c', 'An adjective ending in -y changes the y to i and adds -ly: happy → happily ✓. The common trap is "happyly", keeping the y. "Happy" is the adjective, and "more happy" is a comparative, not an adverb.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9167874b-e7dd-5b34-8486-c039555f9c21', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', 'Aziz is very good at football. Which sentence is correct?', '[{"id":"a","text":"Aziz plays football good."},{"id":"b","text":"Aziz plays football well."},{"id":"c","text":"Aziz plays football goodly."},{"id":"d","text":"Aziz plays football best."}]'::jsonb, 'b', 'To describe HOW he plays we need the adverb of "good", which is the irregular "well": Aziz plays well ✓. The common trap is "plays good" (good is an adjective, not an adverb). "Goodly" does not exist, and "best" is a superlative.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13b237d4-729d-55a3-b400-52736fffd4de', '0b13af5f-6e5a-5f9d-b77c-e9fe5b717189', 'Read: "(1) You should respect your parents. (2) You mustn''t drop litter in the park. (3) I think that friendship is important. (4) You must to look after your pet." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'd', 'Sentence 4 has the mistake: this question asks you to find the faulty one. "You must to look after" is wrong — after a modal like "must" the verb takes no "to": it must be "You must look after your pet" ✓. Sentences 1, 2 and 3 correctly use "should respect", "mustn''t drop" and "I think that".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('250dd9f0-7a15-501a-9591-45278ef7ad8e', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', '⭐⭐ Revision (exam style): relationships and manner', 2, 70, 15, 'practice', 'admin', 3)
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
  ('75d8c09e-9f3a-595a-a888-e0a06862daa0', '250dd9f0-7a15-501a-9591-45278ef7ad8e', 'When his parents are out, Youssef takes care of his little sister. We can also say: "He ___ his little sister."', '[{"id":"a","text":"looks after"},{"id":"b","text":"looks at"},{"id":"c","text":"looks for"},{"id":"d","text":"looks like"}]'::jsonb, 'a', '"Take care of" someone means "look after" them: he looks after his sister. "Look at" means to watch, "look for" means to search, and "look like" means to resemble — different meanings.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59347358-9eed-513b-ae04-aef5ba1f7587', '250dd9f0-7a15-501a-9591-45278ef7ad8e', 'Complete the advice: "Good friends ___ trust each other and share their secrets."', '[{"id":"a","text":"must"},{"id":"b","text":"mustn''t"},{"id":"c","text":"aren''t"},{"id":"d","text":"don''t"}]'::jsonb, 'a', 'Trusting each other is what good friends need to do, an obligation of friendship, so we use "must": friends must trust each other. "Mustn''t", "aren''t" and "don''t" would all turn the sentence negative.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81f366ec-e62f-5158-ab61-56926432edcd', '250dd9f0-7a15-501a-9591-45278ef7ad8e', 'Your friend says: "Reading books is boring." You think reading is great. How do you answer politely?', '[{"id":"a","text":"I agree with you."},{"id":"b","text":"I disagree."},{"id":"c","text":"You''re right."},{"id":"d","text":"Me too."}]'::jsonb, 'b', 'You have the opposite idea, so you disagree: "I disagree." The other three answers ("I agree with you", "You''re right", "Me too") all mean you have the SAME opinion as your friend.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54cbe72a-5608-5104-9bcd-adcb94bf525a', '250dd9f0-7a15-501a-9591-45278ef7ad8e', 'Complete with a feeling adjective: "Salma lost her cat this morning. She feels very ___."', '[{"id":"a","text":"sadly"},{"id":"b","text":"sadness"},{"id":"c","text":"sad"},{"id":"d","text":"sads"}]'::jsonb, 'c', 'After "feel" we use an adjective: she feels sad. "Sadly" is an adverb, "sadness" is a noun, and "sads" is not a word — none of them can follow "feel".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86b17051-a453-5156-a263-99635c483441', '250dd9f0-7a15-501a-9591-45278ef7ad8e', 'Advise against a bad habit: "You ___ shout at your little brother when you are angry."', '[{"id":"a","text":"should"},{"id":"b","text":"must"},{"id":"c","text":"can"},{"id":"d","text":"shouldn''t"}]'::jsonb, 'd', 'Shouting at your brother is a bad idea, so we advise against it with "shouldn''t": You shouldn''t shout at him. "Should", "must" and "can" would all encourage or allow the shouting.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f28b9c8-02f9-54b4-8520-ad80b9794705', '250dd9f0-7a15-501a-9591-45278ef7ad8e', 'Turn the adjective into an adverb: "The teacher explained the lesson ___." (clear)', '[{"id":"a","text":"clear"},{"id":"b","text":"clearly"},{"id":"c","text":"clearily"},{"id":"d","text":"cleared"}]'::jsonb, 'b', 'To say HOW she explained, add -ly to the adjective: clear → clearly. "Clear" is the adjective, "clearily" is misspelled (clear does not end in -y), and "cleared" is a past verb.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('117f6371-2731-55ce-a449-362c86c1a14d', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: the language of relationships', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('63aabdc8-a11e-5dde-8943-387ff4625e11', '117f6371-2731-55ce-a449-362c86c1a14d', 'Ines wants to protect the environment. Which piece of advice is expressed correctly?', '[{"id":"a","text":"You should to recycle your bottles."},{"id":"b","text":"You should recycle your bottles."},{"id":"c","text":"You should recycling your bottles."},{"id":"d","text":"You should recycles your bottles."}]'::jsonb, 'b', '"Should" is followed by the base verb only: You should recycle ✓. The common trap is "should to recycle", adding a wrong "to". "Recycling" uses -ing and "recycles" adds -s — modals never change the verb form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8051cff-8c14-5b31-87cf-1a02b801f0a4', '117f6371-2731-55ce-a449-362c86c1a14d', 'Distinguish a rule from advice. In a museum there is a sign: "Do not touch the paintings." Which sentence matches the sign?', '[{"id":"a","text":"You shouldn''t touch the paintings."},{"id":"b","text":"You should touch the paintings."},{"id":"c","text":"You mustn''t touch the paintings."},{"id":"d","text":"You must touch the paintings."}]'::jsonb, 'c', 'A sign that forbids something is a strict rule, not just advice, so we use "mustn''t": You mustn''t touch the paintings ✓. The common trap is "shouldn''t", which only means it is a bad idea, not that it is forbidden. "Should"/"must" would tell you to touch them.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2de63065-bc2d-5152-b8ed-640020531faf', '117f6371-2731-55ce-a449-362c86c1a14d', 'Complete with the right adverb: "The two brothers were angry, so they argued ___." (angry)', '[{"id":"a","text":"angry"},{"id":"b","text":"angryly"},{"id":"c","text":"angerly"},{"id":"d","text":"angrily"}]'::jsonb, 'd', 'The adjective ends in -y, so the y becomes i before -ly: angry → angrily ✓. The common trap is "angryly" (keeping the y). "Angry" is the adjective, and "angerly" mixes in the noun "anger".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b5e0cf0-1a94-5174-9eb3-be7e52e935ec', '117f6371-2731-55ce-a449-362c86c1a14d', 'Which sentence about a pet is completely correct?', '[{"id":"a","text":"You must take care of your dog gently."},{"id":"b","text":"You must to take care of your dog gently."},{"id":"c","text":"You must take care of your dog gentle."},{"id":"d","text":"You must taking care of your dog gently."}]'::jsonb, 'a', 'Two rules meet here: after "must" the base verb "take" (no "to", no -ing), and the adverb of manner "gently" (gentle → gently) to say HOW. "You must take care of your dog gently" ✓. Option b adds a wrong "to", c uses the adjective "gentle", and d uses "taking".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e8feb18-1412-5ed3-b449-2b42611a409a', '117f6371-2731-55ce-a449-362c86c1a14d', 'Read: "(1) In my opinion, we must protect nature. (2) I feel proudly when I plant a tree. (3) You shouldn''t waste water. (4) I disagree with your idea." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'b', 'Sentence 2 has the mistake: this question asks you to spot the faulty one. After "feel" we use an adjective, not an adverb, so it must be "I feel proud when I plant a tree" ✓, not "proudly". Sentences 1, 3 and 4 correctly use "In my opinion", "shouldn''t waste" and "I disagree".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abe68686-69f6-5043-8c97-ad138d118fc2', '117f6371-2731-55ce-a449-362c86c1a14d', 'Only ONE of these sentences is completely correct. Which one?', '[{"id":"a","text":"You should respect your parents and listen to them carefully."},{"id":"b","text":"You must to help your friends when they are sad."},{"id":"c","text":"I am agree that we shouldn''t drop litter."},{"id":"d","text":"Salma speaks English very good."}]'::jsonb, 'a', 'Sentence a is correct: "should + respect" (base verb) and the adverb "carefully" to say how you listen ✓. "Must to help" (b) adds a wrong "to" after the modal, "I am agree" (c) should be "I agree", and "speaks very good" (d) needs the adverb "well".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', '📝 Training ⭐⭐⭐: global review of Module Five', 3, 120, 30, 'boss', 'admin', 5)
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
  ('691b4306-e065-5971-84e6-c043bf294f7f', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'Selim broke his classmate''s ruler by accident. What should he do? "He ___ say sorry and buy a new one."', '[{"id":"a","text":"should"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"mustn''t"},{"id":"d","text":"isn''t"}]'::jsonb, 'a', 'Saying sorry and replacing the ruler is the right thing to do, so we advise it with "should": He should say sorry ✓. "Shouldn''t" and "mustn''t" advise against it, and "isn''t" is not a modal.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('799528f4-2c0c-5db9-aa19-1a571b4f271a', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'There is a firm rule at the swimming pool. Complete: "You ___ run near the water; it is slippery and dangerous."', '[{"id":"a","text":"must"},{"id":"b","text":"should"},{"id":"c","text":"mustn''t"},{"id":"d","text":"want to"}]'::jsonb, 'c', 'Running near the water is forbidden for safety, so we use "mustn''t": You mustn''t run near the water ✓. "Must" and "want to" would order you to run, and "should" is only mild advice, not a firm rule.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('511089a5-d69a-504b-ba27-ee9645304724', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'Complete the opinion correctly: "___ every family should have a pet; it teaches children to be kind."', '[{"id":"a","text":"I think that"},{"id":"b","text":"I am think"},{"id":"c","text":"I think to"},{"id":"d","text":"I thinking"}]'::jsonb, 'a', 'To give an opinion we say "I think (that) + a sentence": I think that every family should have a pet ✓. "I am think" and "I thinking" misuse the verb, and "I think to" is not the correct structure.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('813b35b2-771a-5168-a14f-4ef5546c6ca0', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'Give the adverb of manner: "The nurse spoke to the child ___." (gentle)', '[{"id":"a","text":"gentle"},{"id":"b","text":"gentley"},{"id":"c","text":"gently"},{"id":"d","text":"gentlely"}]'::jsonb, 'c', 'When an adjective ends in -le, we drop the e and add -y: gentle → gently ✓. The common trap is "gentley" or "gentlely". "Gentle" alone is the adjective, not the adverb.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b68f9c02-7d67-5331-8d2b-6daed66d59b6', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'Amine finished the race first. Which sentence is correct?', '[{"id":"a","text":"Amine ran very fastly."},{"id":"b","text":"Amine ran very fast."},{"id":"c","text":"Amine ran very fastly and good."},{"id":"d","text":"Amine ran very faster."}]'::jsonb, 'b', '"Fast" is an irregular adverb: it stays the same, with no -ly. Amine ran very fast ✓. The common trap is "fastly", which does not exist. "Faster" is a comparative, and "good" is an adjective, not an adverb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('042c44d6-3f0e-5eef-9312-fec5d3afc182', '4bba7276-8ffe-5545-a8ef-12a7d05d9f0a', 'Read: "(1) You should take care of your pet. (2) In my opinion, we mustn''t cut trees. (3) I feel excited about the trip. (4) My best friend helps me always careful." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'd', 'Sentence 4 has the mistake: this question asks you to find the faulty one. To say HOW the friend helps, we need the adverb "carefully", so it must be "My best friend always helps me carefully" ✓, not the adjective "careful". Sentences 1, 2 and 3 correctly use "should take", "mustn''t cut" and "I feel excited".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a3f91341-c437-59b9-9ada-ba333fe921c8', '4f0f87b7-b671-57f7-849f-3fcbcdfc5693', 'english-8eme', '👑 Elite challenge ⭐⭐⭐⭐: the final gate of 8th year', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('32f0018f-28f5-5f29-88a9-acb18e72335f', 'a3f91341-c437-59b9-9ada-ba333fe921c8', 'Your cousin rides his bike on a busy road with no helmet. Choose the strongest correct way to tell him a helmet is not optional.', '[{"id":"a","text":"You must wear a helmet."},{"id":"b","text":"You should wear a helmet."},{"id":"c","text":"You mustn''t wear a helmet."},{"id":"d","text":"You must to wear a helmet."}]'::jsonb, 'a', 'Wearing a helmet on a busy road is a safety necessity, not just advice, so the strongest form is the obligation "must" + base verb: You must wear a helmet ✓. "Should" (b) is only advice; "mustn''t" (c) would forbid the helmet; and "must to wear" (d) wrongly adds "to" after the modal.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f27a0cd-d4c3-5071-82c4-72f4a981f322', 'a3f91341-c437-59b9-9ada-ba333fe921c8', 'Wassim is polite AND quick. Which sentence describes HOW he answered, with both adverbs correct?', '[{"id":"a","text":"He answered polite and quick."},{"id":"b","text":"He answered politely and quickly."},{"id":"c","text":"He answered politly and quicky."},{"id":"d","text":"He answered politely and quick."}]'::jsonb, 'b', 'Both words describe HOW he answered, so both must be adverbs of manner: polite → politely, quick → quickly ✓. Option a uses two adjectives, c misspells both (politly / quicky), and d leaves "quick" as an adjective.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f00abe22-0a41-55ea-8ebb-7d2c2d28375a', 'a3f91341-c437-59b9-9ada-ba333fe921c8', 'Which sentence combines an opinion and a feeling correctly?', '[{"id":"a","text":"In my opinion, we should protect animals, and I feel proud when I help them."},{"id":"b","text":"In my opinion, we should to protect animals, and I feel proud when I help them."},{"id":"c","text":"I am agree we should protect animals, and I feel proudly when I help them."},{"id":"d","text":"In my opinion, we should protect animals, and I feel proudly when I help them."}]'::jsonb, 'a', 'Everything must be correct: "should protect" (no "to"), "In my opinion" (not "I am agree"), and "feel proud" (an adjective, not "proudly") ✓. Option b adds "to" after should, c uses "I am agree" and "proudly", and d uses the adverb "proudly" after "feel".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12c8f241-c89b-53cb-adac-0a4fcecf9ed3', 'a3f91341-c437-59b9-9ada-ba333fe921c8', 'The adjectives are "good", "fast" and "careful". Which line gives ALL three adverbs of manner correctly?', '[{"id":"a","text":"goodly — fastly — carefuly"},{"id":"b","text":"good — fast — careful"},{"id":"c","text":"well — fastly — carefully"},{"id":"d","text":"well — fast — carefully"}]'::jsonb, 'd', 'Two are irregular and one is regular: good → well, fast → fast (same form), careful → carefully ✓. Option a invents "goodly"/"fastly", c keeps the wrong "fastly", and b just repeats the three adjectives.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79549b3c-4206-56dd-8d22-cfd02a3297ef', 'a3f91341-c437-59b9-9ada-ba333fe921c8', 'Read: "(1) You mustn''t drop litter in the sea. (2) I think that friends must help each other. (3) You should to save water at home. (4) Nour looks after her grandmother kindly." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'Sentence 3 has the mistake: this question asks you to spot the faulty one. After the modal "should" the verb takes no "to", so it must be "You should save water at home" ✓, not "should to save". Sentences 1, 2 and 4 correctly use "mustn''t drop", "must help" and the adverb "kindly".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5123dfd2-4c91-5555-ac82-7df1abafef2c', 'a3f91341-c437-59b9-9ada-ba333fe921c8', 'Only ONE of these sentences is completely correct. Which one?', '[{"id":"a","text":"You shouldn''t to argue with your friends, you must forgive them quickly."},{"id":"b","text":"You shouldn''t argue with your friends; you should forgive them quickly."},{"id":"c","text":"You shouldn''t argue with your friends; you should forgive them quick."},{"id":"d","text":"You shouldn''t argue with your friends; you should to forgive them quickly."}]'::jsonb, 'b', 'Sentence b is correct on every point: "shouldn''t argue" and "should forgive" (base verbs, no "to") plus the adverb "quickly" to say how you forgive ✓. Option a adds "to" after "shouldn''t", c leaves "quick" as an adjective, and d adds "to" after "should".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

