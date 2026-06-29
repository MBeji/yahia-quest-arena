-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-c1 (Anglais — Autonome (C1))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-c1/
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
  ('anglais-c1', 'Anglais — Autonome (C1)', 'Reach C1 mastery with five advanced structures: inversion for emphasis, cleft sentences, modals of deduction, participle clauses, and discourse markers for cohesion — CEFR C1, building on A1–B2 with nuance, register, and complex syntax.', 'Agilité', 'subject-english', 'Globe', 5, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-c1'
      AND e.source = 'admin'
      AND q.id NOT IN ('044cb6c3-242e-5bdd-83d9-b20e6271e3a4', '870aaac1-1734-5e81-aefb-d75a607ba88a', '07fa4c18-5af5-56da-8a90-1e933fb3b6c0', 'efdd6b3e-653f-5ce9-b633-88eb5af1b271', '068ba80d-1aa3-5e32-9bb1-d9ae98cfd879', 'a22150c5-7a75-51e7-81a1-b9937c10ffc6', '71fb4065-2198-54ce-ae85-ad4da30e05f2', '2dd149fa-5b76-5593-9c76-a0abee8b777d', 'fae4710b-f77e-517c-b79f-700914a27980', '764d2682-3ad2-50bb-9a71-2a1bbc883137', '7fad89af-be70-5acf-9a40-a6e3b582d9f4', 'a28e0fb0-2f39-5610-b78d-f734640989f0', '026635ab-bc0e-5d8b-84fe-2ddc13741ab9', 'fa36fd77-5427-5582-902e-f6855028a878', '405c4c00-7023-5b5e-8dc3-8a72902ffe34', '05c92b59-90de-5e36-9ab9-fae11d2bc641', 'c903f9be-9ea5-59e6-8069-19cc9cef97eb', '7e3c0972-765a-5493-a462-d85307c20f5c', 'f548f310-e279-5010-bbef-7a3e73276990', '529c9bcf-ee1b-5be8-a96e-b3ee8e1c2ab1', 'b93035a5-1d5b-5353-b7f0-e6754fb24bcb', 'b5e309c7-3924-5982-b50a-44eb2628d89a', 'b097cb2f-7384-5b7f-96e4-0f6a9818150c', '4136627f-7336-57a4-ac2b-becb377832cb', '71fa085a-1fe6-556b-9e24-560043ac6c61', '9bc680fe-9015-55fd-b33a-b154b90d474b', '41da8824-50e4-5a0e-bac1-20e361136411', '2097582f-eeac-50be-8999-3a96cd3a45bf', '052706f2-6f5d-5332-9b28-b271d98d5ff2', '210257f6-e1e2-5f60-9993-c7150173769a', '5e0772e3-6cf2-57ef-aded-197712ac49fb', '980c7340-b58b-5b66-b391-314cd5d59511', '65ea6d16-101c-5147-aef1-f3e4759139ba', 'ac1bea63-d5a9-5632-83ff-da6e54048024', '2568532d-ed0d-5c07-9cae-6d210a152aea', '25540a51-8bb2-550e-8c65-f5bf74fcbead', '7b21ed79-5af2-5a61-b5f6-928631dd41f6', '40fcc502-f829-5938-b3b2-513ac83ff0b1', '9840a4c8-c0a7-589c-901a-eecaaa3f26dd', '1ae681ed-dee1-5283-a409-b02ee67a3301', 'e9a6424d-1edb-5770-a83a-47ee5acdf3de', 'b8060405-9c85-511d-9e22-71373d18c151', '3228ac04-7d76-5f4d-a1c5-cdebd7a6ce01', '64e432b3-af1d-5152-bc47-7b9dbd99c6da', '3a5fe107-1d5c-5210-b758-55fca927434c', 'b90ea57a-bb8e-503f-b140-c733f1fd0972', '9bcf9b7b-e354-54d8-8ab5-a990c2bb1a29', 'c0f98206-fec7-5bf2-86f5-f4676d7d0ffa', '2bc0b31a-ec85-50a3-8a74-c00342b84155', '0d2d55d7-7820-5434-af61-97663c2dec2a', 'f2e0b2e4-068e-514c-ac33-fce835a4b1f6', '4255b09d-571f-58ca-974b-3292a157dd29', '36739adf-b343-57fd-9c2f-1603bf20603a', '501dffb9-eb3a-5a61-ae75-9f3691319c4a', '7a3279da-57dd-5715-899d-09ca92a0d6d3', '2553f8f9-b62d-5ede-b830-e08eb7fab599', '85a5c605-7b4c-52ca-9c4c-5c599a814a92', 'b46a545d-646a-554d-b4ef-5e492ce6ea6f', '4779a573-46a9-54e3-ad5d-f78a94440987', 'e9009021-888e-5a74-a548-0b4bcb986718', '63004ed7-abb3-591e-91e7-601a32108f66', '85bacf56-d285-5a38-a3ae-6921d0a1710d', '8255cdfb-222d-5920-97b8-81d6415863db', '2069bfcd-a3f7-5aad-8325-4174a455e476', '26a12c9f-caf7-5d61-a5b5-46efeb6bf5c9', '0b223ffa-d71a-5255-b91e-0b2894389d48', '33b8a495-6afe-548b-a99f-d8e429a6fdc7', 'd0a8e205-a4bf-5c16-9df1-7281188de79d', '0eba14a6-3066-59cd-88c6-efdd40f08ce1', '9617be9a-4891-5074-b186-e31c51732f26', '49120c6c-82a6-5b8d-849e-ac76677f178e', '3b4d9ae6-cd60-5ba7-8702-01bb84098c81', '62491496-539b-54c5-aaf5-e8d5f6e67c48', 'd7041584-d2a2-52fe-b637-2cb53255fce2', 'da4d03a8-413c-5490-85ec-e2f35543ab4b', 'df7e9e40-c0f5-5514-8602-76881e88b123', 'ed1f67de-8e59-5dad-a084-cbc8306aa4b4', '82fa57ff-e6dd-5251-9d0c-09768721f10e', 'deb84189-9048-5b5f-85a6-df3696aff75b', 'f5c4328d-ad85-575f-9a1b-c3900c169a1a', '5f2f107d-7c03-557d-8f01-d3bafe9f9356', 'f7ccc7eb-a6ed-553b-90b1-f5f308d7775b', '165db028-2d99-5d3e-a6ca-286ee7b1290f', 'cfc98005-57ac-5996-bb46-9246e63419bf', 'a1d6c022-0bfd-5cec-b81d-d0fcdd812cc4', '38283e2f-e797-50d1-8daf-0efe64839b58', 'e64db75d-d94f-5044-b2a1-f21a6bb339e0', 'e5c1ffe0-98aa-585a-8638-6c0295aeb676', '18beb660-4372-5107-86f1-d4625f496f84', 'aac62bee-8bed-5063-aa68-42d2350d8c2e', '5e833c10-6333-531a-908b-297c7b16265d', '9e72ea47-4ff1-5808-b834-50eb5da3253e', 'e28cb80f-0969-5fd8-9b4d-e1703123493d', '755ee148-3ebc-583f-95c1-c3e4bcdfef19', 'af4c1860-50ef-5d18-aa71-16846fe8b8a7', '5ebdc88e-e934-5837-99b0-8cc1809cb399', '40f2af05-353d-56da-a2db-cb77c26236e6', 'bbd73d51-5536-5ca7-8810-b89395e30a34', 'ae35481b-bb12-5f2f-b4e5-c1f86e8fb6c6', 'a5440951-9d87-505b-a8bf-232e834aaf76', 'ed2e9092-141a-521a-991a-c8f3eb705e30', '7ff5498b-325e-5450-b1b2-887d3718af5b', 'caed52bc-b3dc-54eb-b49c-d7079f325dc1', 'b9cb7b9e-89f5-510b-b996-c5375aacfdbf', 'b6f08d42-22f3-5fab-9fff-78b0b2075de5', '14c021af-6800-55a3-8eb6-2bbac1c71fd1', '705720fa-e2fb-5e46-83c4-daa54c623c7d', '0af78207-30fc-58b3-b2f7-047299bde1f8', '5e03b215-e24c-583d-af37-a4bca9dc3424', 'a5af01d9-e392-551c-a7c7-9bbadd5ae4c6', 'd7ab78df-1532-56ab-9048-c396d4f529ac', 'fb00aa41-6026-597e-974a-2f2619d83d0d', 'a49559d1-1327-5bdc-b718-d2cc60e7a11c', 'ef857088-ad1a-5d39-844d-fc7bc72efe7e', 'd83858c6-288b-542a-80ea-c50a84b06caa', '49416109-f7b1-5386-ac1c-8492bb81fdc9', 'a178c709-2d87-5051-a3ec-994f10b877ea', '7d6fa561-44ef-5058-bd74-ae7c311cf6b8', 'b323f6e4-353a-5127-9879-dacbfeab9b18', '27686367-74b1-56fb-be0e-4f42e0029d02', 'f5cac790-8140-5e70-8afc-7cf028aad25a', 'd7494b5a-e798-591e-b2a6-93351670462b', 'bd4fa524-f8cb-5e8d-9bd7-fa9a2c9ee19b', '402de86d-1e2d-5f08-be27-2fab460eaf56', '9b1b1e51-da5e-5148-8bd7-794954619d0f', '80584e53-436d-51be-b7e2-d2d540b124ac', 'fb4eb2b5-a6fc-59b3-a0eb-f22e329fba11', '2f3f1ebe-fcdb-51b2-842c-d4da92fbb9fc', '1a6db2a0-a49c-5f30-8c9b-1ef3b02955c6', 'f1336e70-a9d6-5ca6-a3fe-239beaf949f3', '27a37b34-6b13-52da-90e1-7122cba0c830', 'ebbed417-ee0a-58e9-b51b-4174da2862a4', 'a6c6b3c9-0b52-5dd1-add6-148b05a1c1ed', 'cd2954a8-0831-5c61-868a-569c9374e1a4', '0724c45e-9d66-59ed-b53b-aa33dd073cba', '96f8c4f1-1fa2-525a-ab8d-0c4a43bbbfc2', '9198bb38-6009-53f5-a105-9cd58d689517', '27e6b97c-6c00-5aca-9192-24484d99647d', '410758df-5fc9-56f8-90ee-49651783aa12', '4cc19af3-bd17-570b-98f3-c6a9a4885069', 'e3002b81-5d85-56ac-a88e-d7dff814e178', '1ab50510-b547-5530-97e2-05a19df02222', 'fb7c77b5-9748-5ca9-bb70-8d43df0729bb', 'd6cf3f44-5237-5bd3-9b1b-c1de686726f2', '546c52bd-85e8-5f83-bab4-f899a194a5d4');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-c1' AND source = 'admin' AND id NOT IN ('f6838b0c-79ea-50b3-aed4-713f61d408cb', '5d7b56b8-d4ab-5042-aaba-4455c4264548', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'af86b120-dc2e-5689-b635-8764e7370667', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'b300ade6-5707-5502-a755-012849136ee3', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', '26824ef0-9177-58d5-b124-3189a65d92d8', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', '376db3ce-b07c-50e0-8a09-652026bc9d25', '21d5af2a-0996-51bc-b863-c68f475eff88', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', '9c67eb14-3080-544a-94cd-76cf83e94501', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', '6ebce533-7796-5c53-ad0b-518a229f4c24', '0120a12f-d163-58cd-ad65-a901ca2b432a');
DELETE FROM public.questions WHERE exercise_id IN ('f6838b0c-79ea-50b3-aed4-713f61d408cb', '5d7b56b8-d4ab-5042-aaba-4455c4264548', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'af86b120-dc2e-5689-b635-8764e7370667', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'b300ade6-5707-5502-a755-012849136ee3', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', '26824ef0-9177-58d5-b124-3189a65d92d8', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', '376db3ce-b07c-50e0-8a09-652026bc9d25', '21d5af2a-0996-51bc-b863-c68f475eff88', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', '9c67eb14-3080-544a-94cd-76cf83e94501', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', '6ebce533-7796-5c53-ad0b-518a229f4c24', '0120a12f-d163-58cd-ad65-a901ca2b432a') AND id NOT IN ('044cb6c3-242e-5bdd-83d9-b20e6271e3a4', '870aaac1-1734-5e81-aefb-d75a607ba88a', '07fa4c18-5af5-56da-8a90-1e933fb3b6c0', 'efdd6b3e-653f-5ce9-b633-88eb5af1b271', '068ba80d-1aa3-5e32-9bb1-d9ae98cfd879', 'a22150c5-7a75-51e7-81a1-b9937c10ffc6', '71fb4065-2198-54ce-ae85-ad4da30e05f2', '2dd149fa-5b76-5593-9c76-a0abee8b777d', 'fae4710b-f77e-517c-b79f-700914a27980', '764d2682-3ad2-50bb-9a71-2a1bbc883137', '7fad89af-be70-5acf-9a40-a6e3b582d9f4', 'a28e0fb0-2f39-5610-b78d-f734640989f0', '026635ab-bc0e-5d8b-84fe-2ddc13741ab9', 'fa36fd77-5427-5582-902e-f6855028a878', '405c4c00-7023-5b5e-8dc3-8a72902ffe34', '05c92b59-90de-5e36-9ab9-fae11d2bc641', 'c903f9be-9ea5-59e6-8069-19cc9cef97eb', '7e3c0972-765a-5493-a462-d85307c20f5c', 'f548f310-e279-5010-bbef-7a3e73276990', '529c9bcf-ee1b-5be8-a96e-b3ee8e1c2ab1', 'b93035a5-1d5b-5353-b7f0-e6754fb24bcb', 'b5e309c7-3924-5982-b50a-44eb2628d89a', 'b097cb2f-7384-5b7f-96e4-0f6a9818150c', '4136627f-7336-57a4-ac2b-becb377832cb', '71fa085a-1fe6-556b-9e24-560043ac6c61', '9bc680fe-9015-55fd-b33a-b154b90d474b', '41da8824-50e4-5a0e-bac1-20e361136411', '2097582f-eeac-50be-8999-3a96cd3a45bf', '052706f2-6f5d-5332-9b28-b271d98d5ff2', '210257f6-e1e2-5f60-9993-c7150173769a', '5e0772e3-6cf2-57ef-aded-197712ac49fb', '980c7340-b58b-5b66-b391-314cd5d59511', '65ea6d16-101c-5147-aef1-f3e4759139ba', 'ac1bea63-d5a9-5632-83ff-da6e54048024', '2568532d-ed0d-5c07-9cae-6d210a152aea', '25540a51-8bb2-550e-8c65-f5bf74fcbead', '7b21ed79-5af2-5a61-b5f6-928631dd41f6', '40fcc502-f829-5938-b3b2-513ac83ff0b1', '9840a4c8-c0a7-589c-901a-eecaaa3f26dd', '1ae681ed-dee1-5283-a409-b02ee67a3301', 'e9a6424d-1edb-5770-a83a-47ee5acdf3de', 'b8060405-9c85-511d-9e22-71373d18c151', '3228ac04-7d76-5f4d-a1c5-cdebd7a6ce01', '64e432b3-af1d-5152-bc47-7b9dbd99c6da', '3a5fe107-1d5c-5210-b758-55fca927434c', 'b90ea57a-bb8e-503f-b140-c733f1fd0972', '9bcf9b7b-e354-54d8-8ab5-a990c2bb1a29', 'c0f98206-fec7-5bf2-86f5-f4676d7d0ffa', '2bc0b31a-ec85-50a3-8a74-c00342b84155', '0d2d55d7-7820-5434-af61-97663c2dec2a', 'f2e0b2e4-068e-514c-ac33-fce835a4b1f6', '4255b09d-571f-58ca-974b-3292a157dd29', '36739adf-b343-57fd-9c2f-1603bf20603a', '501dffb9-eb3a-5a61-ae75-9f3691319c4a', '7a3279da-57dd-5715-899d-09ca92a0d6d3', '2553f8f9-b62d-5ede-b830-e08eb7fab599', '85a5c605-7b4c-52ca-9c4c-5c599a814a92', 'b46a545d-646a-554d-b4ef-5e492ce6ea6f', '4779a573-46a9-54e3-ad5d-f78a94440987', 'e9009021-888e-5a74-a548-0b4bcb986718', '63004ed7-abb3-591e-91e7-601a32108f66', '85bacf56-d285-5a38-a3ae-6921d0a1710d', '8255cdfb-222d-5920-97b8-81d6415863db', '2069bfcd-a3f7-5aad-8325-4174a455e476', '26a12c9f-caf7-5d61-a5b5-46efeb6bf5c9', '0b223ffa-d71a-5255-b91e-0b2894389d48', '33b8a495-6afe-548b-a99f-d8e429a6fdc7', 'd0a8e205-a4bf-5c16-9df1-7281188de79d', '0eba14a6-3066-59cd-88c6-efdd40f08ce1', '9617be9a-4891-5074-b186-e31c51732f26', '49120c6c-82a6-5b8d-849e-ac76677f178e', '3b4d9ae6-cd60-5ba7-8702-01bb84098c81', '62491496-539b-54c5-aaf5-e8d5f6e67c48', 'd7041584-d2a2-52fe-b637-2cb53255fce2', 'da4d03a8-413c-5490-85ec-e2f35543ab4b', 'df7e9e40-c0f5-5514-8602-76881e88b123', 'ed1f67de-8e59-5dad-a084-cbc8306aa4b4', '82fa57ff-e6dd-5251-9d0c-09768721f10e', 'deb84189-9048-5b5f-85a6-df3696aff75b', 'f5c4328d-ad85-575f-9a1b-c3900c169a1a', '5f2f107d-7c03-557d-8f01-d3bafe9f9356', 'f7ccc7eb-a6ed-553b-90b1-f5f308d7775b', '165db028-2d99-5d3e-a6ca-286ee7b1290f', 'cfc98005-57ac-5996-bb46-9246e63419bf', 'a1d6c022-0bfd-5cec-b81d-d0fcdd812cc4', '38283e2f-e797-50d1-8daf-0efe64839b58', 'e64db75d-d94f-5044-b2a1-f21a6bb339e0', 'e5c1ffe0-98aa-585a-8638-6c0295aeb676', '18beb660-4372-5107-86f1-d4625f496f84', 'aac62bee-8bed-5063-aa68-42d2350d8c2e', '5e833c10-6333-531a-908b-297c7b16265d', '9e72ea47-4ff1-5808-b834-50eb5da3253e', 'e28cb80f-0969-5fd8-9b4d-e1703123493d', '755ee148-3ebc-583f-95c1-c3e4bcdfef19', 'af4c1860-50ef-5d18-aa71-16846fe8b8a7', '5ebdc88e-e934-5837-99b0-8cc1809cb399', '40f2af05-353d-56da-a2db-cb77c26236e6', 'bbd73d51-5536-5ca7-8810-b89395e30a34', 'ae35481b-bb12-5f2f-b4e5-c1f86e8fb6c6', 'a5440951-9d87-505b-a8bf-232e834aaf76', 'ed2e9092-141a-521a-991a-c8f3eb705e30', '7ff5498b-325e-5450-b1b2-887d3718af5b', 'caed52bc-b3dc-54eb-b49c-d7079f325dc1', 'b9cb7b9e-89f5-510b-b996-c5375aacfdbf', 'b6f08d42-22f3-5fab-9fff-78b0b2075de5', '14c021af-6800-55a3-8eb6-2bbac1c71fd1', '705720fa-e2fb-5e46-83c4-daa54c623c7d', '0af78207-30fc-58b3-b2f7-047299bde1f8', '5e03b215-e24c-583d-af37-a4bca9dc3424', 'a5af01d9-e392-551c-a7c7-9bbadd5ae4c6', 'd7ab78df-1532-56ab-9048-c396d4f529ac', 'fb00aa41-6026-597e-974a-2f2619d83d0d', 'a49559d1-1327-5bdc-b718-d2cc60e7a11c', 'ef857088-ad1a-5d39-844d-fc7bc72efe7e', 'd83858c6-288b-542a-80ea-c50a84b06caa', '49416109-f7b1-5386-ac1c-8492bb81fdc9', 'a178c709-2d87-5051-a3ec-994f10b877ea', '7d6fa561-44ef-5058-bd74-ae7c311cf6b8', 'b323f6e4-353a-5127-9879-dacbfeab9b18', '27686367-74b1-56fb-be0e-4f42e0029d02', 'f5cac790-8140-5e70-8afc-7cf028aad25a', 'd7494b5a-e798-591e-b2a6-93351670462b', 'bd4fa524-f8cb-5e8d-9bd7-fa9a2c9ee19b', '402de86d-1e2d-5f08-be27-2fab460eaf56', '9b1b1e51-da5e-5148-8bd7-794954619d0f', '80584e53-436d-51be-b7e2-d2d540b124ac', 'fb4eb2b5-a6fc-59b3-a0eb-f22e329fba11', '2f3f1ebe-fcdb-51b2-842c-d4da92fbb9fc', '1a6db2a0-a49c-5f30-8c9b-1ef3b02955c6', 'f1336e70-a9d6-5ca6-a3fe-239beaf949f3', '27a37b34-6b13-52da-90e1-7122cba0c830', 'ebbed417-ee0a-58e9-b51b-4174da2862a4', 'a6c6b3c9-0b52-5dd1-add6-148b05a1c1ed', 'cd2954a8-0831-5c61-868a-569c9374e1a4', '0724c45e-9d66-59ed-b53b-aa33dd073cba', '96f8c4f1-1fa2-525a-ab8d-0c4a43bbbfc2', '9198bb38-6009-53f5-a105-9cd58d689517', '27e6b97c-6c00-5aca-9192-24484d99647d', '410758df-5fc9-56f8-90ee-49651783aa12', '4cc19af3-bd17-570b-98f3-c6a9a4885069', 'e3002b81-5d85-56ac-a88e-d7dff814e178', '1ab50510-b547-5530-97e2-05a19df02222', 'fb7c77b5-9748-5ca9-bb70-8d43df0729bb', 'd6cf3f44-5237-5bd3-9b1b-c1de686726f2', '546c52bd-85e8-5f83-bab4-f899a194a5d4');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-c1' AND c.id NOT IN ('36944d0b-25df-5542-a207-9cc4eeea8f80', '109d0c1b-7491-540a-8c61-771d4801dc19', 'c6fee95d-7870-566a-842f-bbc5b2d0b46c', '205e7d4e-3de0-5dc9-be5e-e542f8f6c73e', '6d77d1ef-a1fa-5f50-98d6-c50dcb5685a1') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('36944d0b-25df-5542-a207-9cc4eeea8f80', 'anglais-c1', 'Inversion for Emphasis', 'Front negative or restrictive adverbials — Never have I…, Not only… but also…, Hardly… when, No sooner… than — and master auxiliary inversion to add dramatic emphasis in formal writing and speech.', '# ⚔️ Inversion for Emphasis — Flip the Sentence, Amplify the Power

> 💡 «In ordinary speech we follow the rules. In great writing, we break the order — and break the reader''s expectations. Welcome to inversion.»

## 🏰 What is inversion?

**Inversion** means placing an **auxiliary verb before the subject** to create emphasis. It is the grammar of drama: formal writing, speeches, literary prose, and advanced academic argument all rely on it.

Normal order → _I have never seen such courage._
Inverted order → _**Never have I seen** such courage._

The sentence means the same thing — but the inverted version hits harder.

## ⚡ How inversion works: the rule

When a **negative or restrictive adverbial** is moved to the **front** of the clause, the auxiliary verb and subject **swap** (just like in a question):

| Normal word order                 | Inverted (emphatic) form              |
| --------------------------------- | ------------------------------------- |
| _I have never felt so alive._     | _**Never have I** felt so alive._     |
| _She had rarely seen such chaos._ | _**Rarely had she** seen such chaos._ |
| _We have seldom been surprised._  | _**Seldom have we** been surprised._  |
| _I had hardly sat down when…_     | _**Hardly had I** sat down when…_     |
| _He had no sooner arrived than…_  | _**No sooner had he** arrived than…_  |

> 🗡️ Tip: The inversion follows the **negative adverbial** — the auxiliary jumps in front, exactly as in a yes/no question. If there is no auxiliary in the base sentence, use _do/does/did_.

## 🛡️ The key negative adverbials

| Expression                 | Meaning / register                       | Companion word |
| -------------------------- | ---------------------------------------- | -------------- |
| **Never**                  | not at any time                          | —              |
| **Rarely / Seldom**        | not often (formal)                       | —              |
| **Hardly / Scarcely**      | almost not                               | **when**       |
| **No sooner**              | immediately after                        | **than**       |
| **Not only**               | in addition (implies something stronger) | **but also**   |
| **Not until / Not till**   | only after a specific time               | —              |
| **Under no circumstances** | in no situation whatsoever               | —              |
| **Only then / Only later** | at/after that specific time              | —              |

## 🔮 Critical pairs: Hardly…when & No sooner…than

These two always come in pairs:

_**Hardly had I** opened the door **when** the alarm went off._
_**No sooner had she** spoken **than** the crowd fell silent._

> ⚠️ Trap: Do NOT use "than" after "Hardly" or "when" after "No sooner." It is always **Hardly…when** and **No sooner…than**.

## 🧭 Not only…but also

_**Not only did he** win the race, **but** he **also** broke the world record._
_**Not only is she** talented, **but** she **is also** remarkably humble._

> 🗡️ Tip: After _Not only_, use **auxiliary + subject** (question order). The second clause uses normal word order with _but (also)_.

## 🧱 Under no circumstances & Only + time phrase

_**Under no circumstances should you** reveal the password._
_**Only then did** the team realise the scale of the problem._
_**Not until midnight did** the negotiations finally conclude._

These are common in formal notices, academic essays, and legal language.

## ✨ Inversion with "so" and "such"

_So powerful was the speech that the audience fell silent._
_Such was the impact of the film that critics were stunned._

Here, the **adjective/noun phrase** is fronted, and the linking verb _was_ inverts.

> ⚠️ Trap: Inversion is **formal**. Never use it in casual conversation — it would sound comical. Save it for essays, speeches, and literary prose.

> 🏆 Gate cleared! You can now flip any sentence for dramatic effect. Next: **Cleft Sentences** — another weapon of emphasis, built from _It was…that_ and _What I need is…_', '# 📜 Résumé: Inversion for Emphasis

- **Rule** — front a negative adverbial → auxiliary and subject swap (question order): _Never have I seen…, Rarely does she…, Not only did he…_
- **Negative adverbials** — Never, Rarely, Seldom, Hardly, Scarcely, No sooner, Not only, Not until, Under no circumstances, Only then/later.
- **Hardly / Scarcely … when** — _Hardly had I sat down **when** the phone rang._ (companion = **when**)
- **No sooner … than** — _No sooner had she left **than** it started raining._ (companion = **than**)
- **Not only … but also** — inversion in the first clause, normal order in the second: _Not only did he fail, but he also lied._
- **So / Such inversion** — _So great was the noise that…; Such was his fury that…_
- **Under no circumstances / Only then** — _Under no circumstances should you share your password._
- ⚠️ Do NOT mix up: **Hardly…when** (never "than") and **No sooner…than** (never "when").
- ⚠️ Inversion is **formal/literary** only — avoid in casual speech.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('109d0c1b-7491-540a-8c61-771d4801dc19', 'anglais-c1', 'Cleft Sentences', 'Use It-clefts (It was Maria that solved it), Wh-clefts / pseudo-clefts (What I need is a break) and All-clefts (All I want is peace) to focus attention on one element — a powerful tool for contrast, correction, and emphasis in formal English.', '# ⚔️ Cleft Sentences — The Art of Spotlight Grammar

> 💡 «A sentence can tell the truth. A cleft sentence can tell the truth AND tell you exactly which part matters most. Point the spotlight where you need it.»

## 🏰 What is a cleft sentence?

A **cleft sentence** takes a simple statement and **splits it in two** to spotlight one element. The word "cleft" literally means _split_. English uses clefts to answer implicit questions like _Who? What? Why? When?_ — without asking them.

_Simple:_ **Maria solved the problem.** (neutral — no emphasis)
_Cleft:_ **It was Maria that solved the problem.** (focus: WHO solved it)
_Cleft:_ **It was the problem that Maria solved.** (focus: WHAT she solved)

## ⚡ Type 1: It-cleft

**Structure:** **It + be + [focused element] + that/who + rest of clause**

| Focused element | It-cleft example                                               |
| --------------- | -------------------------------------------------------------- |
| Person          | _It was **Leila** who discovered the error._                   |
| Thing/idea      | _It was **the final paragraph** that convinced the committee._ |
| Time            | _It was **in 2003** that the company first turned a profit._   |
| Reason          | _It was **because of the rain** that the event was cancelled._ |

> 🗡️ Tip: Use **who** when the focused element is a person; use **that** for things, times, and reasons. In informal English, _that_ can replace _who_ for persons too.

## 🛡️ Type 2: Wh-cleft (pseudo-cleft)

**Structure:** **Wh- clause + be + [focused element]**

_What I need is **a long holiday**._
_What surprised me most was **his calmness**._
_Where she went wrong was **in the second chapter**._

The **Wh-clause acts as the subject**; the focused element comes at the end after **is/was**.

> 🗡️ Tip: Wh-clefts are excellent for **explaining or clarifying** — the reader processes the context first (What I need…) and then receives the key information at the end (is a holiday).

## 🔮 Type 3: All-cleft (limiting cleft)

**Structure:** **All + subject + verb + is/was + [focused element]**

_All I ask is **your patience**._
_All she wanted was **to be left alone**._
_All he did was **complain**._

> ⚠️ Trap: "All I did was complain" does NOT need _to_ before the verb — the base form (bare infinitive) follows _was_ directly when the focused element is a verb action: \*All he did was **argue\***, not ~~argue~~.

## 🧭 Reverse Wh-cleft (end-focus)

You can also **reverse** the Wh-cleft by placing the focused element at the START:

_A long holiday is **what I need**._
_His calmness is **what surprised me most**._

This works for **contrast or dramatic announcement** — you state the topic first, then identify it precisely.

## 🧱 Agreement in It-clefts

The verb **be** in the cleft agrees with the **focused element**, not with "it":

_It is **your words** that wound me._ (plural subject after that → wound)
_It was **the judges** who decided._ (plural focused element)

But in practice, native speakers often use _It is/was_ regardless: _It is the judges that decides_ is common in speech (though prescriptively incorrect).

## ✨ Register note

It-clefts and Wh-clefts are used in **both formal and informal English**. All-clefts with **bare infinitive** (_All he did was argue_) are slightly informal. In academic writing, It-clefts are preferred for **correcting misconceptions**:

_It was not the price but the quality that drove the decision._ (contrasting two elements)

> ⚠️ Trap: Do not confuse an It-cleft with an _anticipatory it_ sentence. Compare: _It is important to recycle_ (anticipatory it — no cleft, no focus) vs _It is recycling that is important_ (cleft — focus on recycling).

> 🏆 Gate cleared! You can now split and spotlight any sentence. Next: **Modals of Deduction** — must have, can''t have, might have — reasoning about the past with precision.', '# 📜 Résumé: Cleft Sentences

- **Purpose** — split a sentence to spotlight one element (person, thing, time, reason, action).
- **It-cleft** — _It + be + [focus] + that/who + rest_: _It was Maria **who** found it; It was in 2003 **that** profits rose._
  - Use **who** for persons, **that** for things/times/reasons.
- **Wh-cleft (pseudo-cleft)** — _Wh- clause + be + [focus]_: _What I need is a break; Where she failed was in the conclusion._
  - Context first → key info last.
- **Reverse Wh-cleft** — _[focus] + is/was + Wh- clause_: _A break is what I need._
- **All-cleft** — _All + subject + verb + is/was + [focus]_: _All I ask is patience; All he did was argue._
  - After _was_, use **bare infinitive** (not _to_-infinitive) for actions.
- **Agreement** — verb be agrees with the focused noun: _It is the results that matter_ (matter, not matters).
- ⚠️ Do NOT confuse It-cleft (_It is recycling that matters_ — focuses) with anticipatory it (_It is important to recycle_ — no focus element after that).
- ⚠️ All-cleft with verb action: \*All she did was **cry\***, NOT _to cry_.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c6fee95d-7870-566a-842f-bbc5b2d0b46c', 'anglais-c1', 'Modals of Deduction', 'Reason about certainty and possibility in the present and past — must/can''t for near-certainty, might/could/may for possibility — using modal + have + past participle for past deductions: must have been, can''t have seen, might have left.', '# ⚔️ Modals of Deduction — Reasoning Like a Detective

> 💡 «You don''t always have proof. But evidence + logic + the right modal verb = a conclusion that feels airtight. Think like Sherlock — speak like a C1 scholar.»

## 🏰 What are modals of deduction?

**Modals of deduction** (also called _modals of speculation_ or _epistemic modals_) express **how certain you are** about something, based on evidence and logic — not facts.

They work in **two time frames**:

- **Present/general** → modal + base verb
- **Past** → modal + **have** + past participle

## ⚡ The certainty scale

| Certainty            | Present deduction                    | Past deduction                        |
| -------------------- | ------------------------------------ | ------------------------------------- |
| **Near-certain YES** | _She **must be** exhausted._         | _She **must have been** exhausted._   |
| **Near-certain NO**  | _He **can''t be** serious._           | _He **can''t have been** serious._     |
| **Possible**         | _They **might/may/could be** there._ | _They **might/may/could have gone**._ |
| **Less likely YES**  | _It **might be** true._              | _It **might have happened**._         |
| **Impossible YES**   | _It **couldn''t be** right._          | _It **couldn''t have worked**._        |

## 🛡️ PRESENT deductions

**must** (near-certain positive): _The lights are on — someone **must be** home._
**can''t / cannot** (near-certain negative): _She just arrived — she **can''t be** tired already._
**might / may / could** (possible): _He isn''t answering — he **might be** busy._

> 🗡️ Tip: **must** for deduction is **not** the same as **must** for obligation. Context tells you which is which: _You must leave_ (obligation) vs _You must be joking_ (deduction).

## 🔮 PAST deductions — the critical C1 structure

**Structure:** **modal + have + past participle**

| Modal             | Example                                  | Meaning                             |
| ----------------- | ---------------------------------------- | ----------------------------------- |
| **must have**     | _She must have left early._              | almost certainly happened           |
| **can''t have**    | _He can''t have seen that film._          | almost certainly didn''t happen      |
| **couldn''t have** | _They couldn''t have known._              | it was impossible for them to know  |
| **might have**    | _It might have been an accident._        | possibly happened                   |
| **may have**      | _She may have forgotten._                | possibly happened (slightly formal) |
| **could have**    | _He could have taken a different route._ | was possible (but we don''t know)    |

> ⚠️ Trap: **could have** in deduction is DIFFERENT from **could have** in lost opportunity (conditional): _You could have told me!_ (opportunity missed, reproach) vs _He could have taken another route_ (deduction — maybe he did).

## 🧭 Negative past deductions

**can''t have + past participle** = near certainty that something did NOT happen:
_She can''t have missed the bus — I saw her get on it._

**couldn''t have + past participle** = it was **impossible**:
_He couldn''t have written that letter — he was in hospital._

> 🗡️ Tip: **mustn''t have** is NOT used for past deduction in standard English. To express near-certain negative in the past, say **can''t have** or **couldn''t have** — NEVER ~~must not have~~ for deduction.

## 🧱 Degrees of certainty — choosing the right modal

| Evidence strength                  | Modal choice              |
| ---------------------------------- | ------------------------- |
| Strong evidence → near-certain     | **must (have)**           |
| Evidence rules it out → impossible | **can''t/couldn''t (have)** |
| Some evidence, uncertain           | **might/may (have)**      |
| Logically possible, unknown        | **could (have)**          |

_The footprints are fresh — someone **must have** been here recently._
_The car is cold — they **can''t have** left just now._
_The window is open — someone **might have** climbed in._
_She **could have** taken the back stairs — we don''t know._

## ✨ Register note

**May have** is slightly more formal than **might have** — both are correct. In academic writing and formal reports, **may have** is preferred; in conversation, **might have** is more natural.

> ⚠️ Trap: Do NOT use **must have** for obligation in the past — that role belongs to **had to**: _She had to stay late_ (obligation). _She must have stayed late_ (deduction from evidence).

> 🏆 Gate cleared! You now reason about the past with precision. Next: **Participle Clauses** — compressing whole time, reason, and result clauses into elegant reduced forms.', '# 📜 Résumé: Modals of Deduction

- **Present deductions** — modal + base verb: _She must be tired; He can''t be serious; They might be home._
- **Past deductions** — modal + have + past participle: _She must have left; He can''t have seen it; They might have gone._
- **must (have)** — near-certain positive deduction from evidence: _The door is unlocked — she must have come back._
- **can''t / couldn''t (have)** — near-certain or impossible negative: _He can''t have finished — it''s too soon. He couldn''t have known — the info wasn''t available._
- **might / may / could (have)** — possible: _She might have missed the train; He may have forgotten; It could have been anyone._
- **Degrees** — must > might/may/could > can''t/couldn''t (strongest → weakest certainty for positive; can''t/couldn''t = strongest negative).
- ⚠️ **mustn''t have** is NOT used for past deduction. Use **can''t have** / **couldn''t have** instead.
- ⚠️ **must have** = deduction (evidence-based); **had to** = past obligation. Do not confuse.
- ⚠️ **could have** in deduction (maybe it happened) ≠ **could have** for missed opportunity (reproach): _He could have called_ (missed opportunity / reproach) vs _He could have taken another road_ (deduction).
- **Register** — _may have_ (formal/written) vs _might have_ (neutral/spoken): both correct.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('205e7d4e-3de0-5dc9-be5e-e542f8f6c73e', 'anglais-c1', 'Participle Clauses', 'Compress full adverbial and relative clauses into elegant reduced forms — present participles for simultaneous/causal action, past participles for passive reduced relatives, perfect participles for earlier past action — achieving concision in formal and literary writing.', '# ⚔️ Participle Clauses — The Grammar of Compression

> 💡 «A novice says everything. A master cuts everything unnecessary. Participle clauses are the scalpel that turns three sentences into one — without losing a single idea.»

## 🏰 What are participle clauses?

A **participle clause** is a reduced clause — a subordinate clause that uses a participle form (present, past, or perfect) **instead of a full subject + finite verb**. They compress time, reason, condition, and result into a tighter structure, prized in formal writing, journalism, and literature.

## ⚡ Three types at a glance

| Type        | Form                                  | Typical meaning                     |
| ----------- | ------------------------------------- | ----------------------------------- |
| **Present** | _Verb + -ing_                         | simultaneous action / reason        |
| **Past**    | _Past participle (done/written/seen)_ | passive meaning / reduced relative  |
| **Perfect** | _Having + past participle_            | action completed before main clause |

## 🛡️ Type 1: Present Participle Clause (-ing)

**Simultaneous action (subject is the SAME in both clauses):**
_She sat at her desk, **reading the report**._ (= while she was reading)
**\*Walking through the market**, he noticed an unusual aroma.\* (= as he was walking)

**Reason:**
**\*Feeling unwell**, she decided to leave early.\* (= because she felt unwell)

**Result (consequence follows logically):**
_The storm intensified, **knocking out the power lines**._ (= and knocked out…)

> ⚠️ Trap — Dangling Participle: The -ing clause MUST share its subject with the main clause. _~~Walking through the market, the aroma struck him~~_ is wrong — the aroma cannot walk! The correct version: **Walking through the market, he noticed an aroma.**

## 🔮 Type 2: Past Participle Clause

**Reduced relative clause (passive meaning):**
Full: _The documents **which were found** at the scene were crucial evidence._
Reduced: _The documents **found** at the scene were crucial evidence._

_The car **stolen last night** was recovered this morning._ (= that was stolen)
**\*Built in the 19th century**, the bridge still stands.\* (= which was built / although it was built)

**Adverbial condition or concession:**
**\*Asked to comment**, the minister declined.\* (= when/if asked)
**\*Left alone**, children may become anxious.\* (= if left alone)

> 🗡️ Tip: When the past participle comes at the START of the sentence, it often expresses condition, concession, or time — and sounds very formal.

## 🧭 Type 3: Perfect Participle Clause (Having + past participle)

Use **having + past participle** when the participle clause action happened **BEFORE** the main clause:

**\*Having submitted** the application, she felt a wave of relief.\*
(= After she had submitted… / Because she had submitted…)

**\*Having lived** in Paris for a decade, he spoke French effortlessly.\*
(= Because he had lived…)

| Wrong (implies simultaneous)                     | Right (implies earlier)                                 |
| ------------------------------------------------ | ------------------------------------------------------- |
| _Finishing the report, he sent it._ (same time?) | _Having finished the report, he sent it._ (first… then) |

> 🗡️ Tip: If the sequence of events matters — action A happened, THEN action B happened — use **having + past participle** for action A.

## 🧱 Reduced relative clauses in detail

Relative clauses can be shortened using participles:

**Active → -ing:** _The man **who is standing** at the door is my uncle._ → _The man **standing** at the door is my uncle._

**Passive → past participle:** _The letter **which was written** in 1812 is priceless._ → _The letter **written** in 1812 is priceless._

**With perfect aspect:** _The scientist **who had discovered** the compound was awarded a prize._ → _The scientist **having discovered** the compound was awarded a prize._ (formal/literary)

## ✨ Register and frequency

Participle clauses are **formal and literary** — common in academic essays, official reports, and quality journalism. They are rare in everyday speech. Overusing them in casual writing sounds stiff.

> ⚠️ Trap: A participle clause with a DIFFERENT subject from the main clause is always wrong (dangling participle): _~~Having reviewed the evidence, the verdict seemed clear~~_ — WHO reviewed it? The verdict? Correct: **Having reviewed the evidence, the jury found the verdict clear.**

> 🏆 Gate cleared! You can now compress and tighten any sentence like a pro. Final chapter: **Discourse Markers and Cohesion** — the glue that holds advanced writing together.', '# 📜 Résumé: Participle Clauses

- **Purpose** — reduce a full clause to a participle form for concision in formal/literary writing.
- **Present participle (-ing)** — same subject; expresses simultaneous action, reason, or result: _Walking to work, she noticed a poster. Feeling tired, he left early. The storm hit, flooding the streets._
- **Past participle** — passive reduced relative or adverbial (condition/time/concession): _The letter **written** in 1812 is priceless. **Asked to comment**, the minister refused. **Built on sand**, the structure collapsed._
- **Perfect participle (having + pp)** — action completed BEFORE the main clause: _Having submitted the form, she relaxed. Having lived abroad, he understood the culture._
- **Reduced relative clauses** — active: _the man **standing** there (= who is standing)_; passive: _the car **stolen** last night (= that was stolen)_.
- ⚠️ **Dangling participle** — the participle clause subject MUST match the main clause subject: NOT _~~Walking past the café, the smell of coffee was wonderful~~_ → correct: _Walking past the café, **I** noticed the wonderful smell of coffee._
- ⚠️ Use **having + pp** (not -ing alone) when the participle action came FIRST in time: _Having eaten, she worked_ (ate first, then worked) ≠ _Eating, she worked_ (simultaneous — she ate while she worked).
- **Register** — formal/literary; avoid in casual conversation.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6d77d1ef-a1fa-5f50-98d6-c50dcb5685a1', 'anglais-c1', 'Discourse Markers and Cohesion', 'Master register-appropriate connectors — nevertheless, whereas, despite/in spite of, however, on the contrary, moreover, thus, thereby, albeit — to create cohesive, well-structured formal arguments and distinguish them from their informal equivalents.', '# ⚔️ Discourse Markers and Cohesion — The Glue of Great Writing

> 💡 «Good ideas scattered randomly are just noise. Good ideas in the right order, joined by the right words — that is an argument. Discourse markers are the architecture of a mind at work.»

## 🏰 What are discourse markers?

**Discourse markers** (also called **cohesive devices** or **linking words**) connect sentences and paragraphs — signalling to the reader _how_ one idea relates to the next. They create **cohesion**: the sense that a text holds together as a unified whole.

At C1, choosing the **right marker for the right relationship** AND the **right register** is essential.

## ⚡ Six core relationships and their markers

| Relationship             | Formal markers                                      | Informal equivalents     |
| ------------------------ | --------------------------------------------------- | ------------------------ |
| **Contrast**             | _however, whereas, while, by contrast_              | _but, though_            |
| **Concession**           | _nevertheless, nonetheless, albeit, even so_        | _still, anyway_          |
| **Addition**             | _moreover, furthermore, in addition, besides_       | _also, and, too_         |
| **Result / Consequence** | _therefore, thus, hence, consequently, thereby_     | _so_                     |
| **Clarification**        | _namely, that is to say, in other words_            | _I mean, like_           |
| **Exemplification**      | _for instance, for example, such as, to illustrate_ | _(same — less elevated)_ |

## 🛡️ Contrast vs Concession — the critical distinction

**Contrast** presents two ideas as simply **different** (no implied surprise):
_The first report focused on costs, **whereas** the second addressed quality._

**Concession** acknowledges an opposing point, then **overrides or qualifies** it (implies "despite that…"):
_The project was expensive; **nevertheless**, the results justified the investment._
_The results were poor. **Even so**, the team refused to abandon the plan._

> 🗡️ Tip: After **nevertheless / nonetheless / however**, use a FULL CLAUSE (subject + verb). After **despite / in spite of**, use a NOUN PHRASE or **-ing** form — NEVER a full finite clause.

## 🔮 Despite / In spite of — grammar trap

| Correct                                             | Incorrect                                      |
| --------------------------------------------------- | ---------------------------------------------- |
| _Despite the **rain**, they went out._              | _~~Despite it rained~~, they went out._        |
| _Despite **feeling** tired, she worked._            | _~~Despite she felt tired~~, she worked._      |
| _In spite of the **difficulties**, they succeeded._ | _~~In spite of the difficulties were great~~…_ |

> ⚠️ Trap: **Despite** and **in spite of** CANNOT be followed by a _that_-clause or a subject+verb. They require a **noun phrase** or a **gerund (-ing)**.

## 🧭 However, Whereas, While — placement matters

**However** (concession/contrast connector):

- Can appear at the **start, middle, or end** of a clause.
- When it starts a new sentence, it is followed by a **comma**: _However, the plan failed._
- When it appears mid-clause, it is set off by commas: _The plan, however, failed._

**Whereas / While** (contrast — two clauses in ONE sentence):
_Demand increased, **whereas** supply remained stable._
_Growth was strong in the north, **while** the south stagnated._

> 🗡️ Tip: **Whereas** and **while** cannot begin a new sentence on their own (they are subordinating conjunctions — they need two clauses in one sentence). **However** CAN begin a new sentence.

## 🧱 Result markers — thus, hence, thereby, consequently

**Thus** / **Hence** (formal, more so than _so_): _The data was incomplete; **thus**, the conclusions must be treated with caution._

**Thereby** is special — it is followed by a **present participle (-ing)**, NOT a full clause:
_They streamlined the process, **thereby reducing** costs by 30%._
(NOT: ~~thereby they reduced~~)

**Consequently** / **Therefore** are interchangeable in most formal contexts:
_The regulations were unclear. **Consequently**, companies struggled to comply._

## ✨ Albeit — the elegant concessive

**Albeit** = even though / although (formal, often before an adjective or noun phrase):
_The strategy was effective, **albeit** costly._
_Progress was made, **albeit** slowly._

> ⚠️ Trap: **Albeit** is NOT followed by a full clause. It introduces only an adjective, noun, or adverb phrase: _albeit risky / albeit a minor setback / albeit slowly_ — NEVER _~~albeit it was costly~~_.

## 🗝️ On the contrary vs By contrast

**On the contrary** — responds to and _denies_ the previous statement (it is simply wrong):
_"So you enjoyed the film?" — "On the contrary, I found it tedious."_

**By contrast** — introduces a parallel but different point (no denial involved):
_The northern region grew by 15%. **By contrast**, the south declined._

> ⚠️ Trap: Do NOT use "on the contrary" simply to add a contrasting point — it specifically **contradicts** what was just said.

> 🏆 Quest complete! You have mastered C1 discourse cohesion — the final weapon in your advanced English arsenal. Your writing is now structured, nuanced, and register-precise. Level up! ⚔️', '# 📜 Résumé: Discourse Markers and Cohesion

- **Contrast** — _however, whereas, while, by contrast_: present two different things. _Whereas_ and _while_ join two clauses in one sentence; _however_ can start a new sentence.
- **Concession** — _nevertheless, nonetheless, even so, albeit_: acknowledge an opposing point, then override it. _Nevertheless / nonetheless / even so_ + full clause. _Albeit_ + adjective/adverb/noun phrase only (never a full clause).
- **Addition** — _moreover, furthermore, in addition, besides_: add a stronger or supporting point. More formal than _also_ or _and_.
- **Result** — _therefore, thus, hence, consequently_: signal a logical consequence. _Thereby_ + present participle only: _thereby reducing costs_ (never _thereby they reduced_).
- **Despite / In spite of** — followed by a noun phrase or gerund (-ing), NEVER a full finite clause: _Despite the rain / Despite feeling tired_. NOT _~~despite it rained~~_.
- **On the contrary** — DENIES the previous statement (it is wrong): "Did you enjoy it?" — "On the contrary, I hated it." NOT a general contrast marker.
- **By contrast** — introduces a parallel opposite without denial: _The north grew; by contrast, the south declined._
- ⚠️ **Despite / in spite of** + noun/-ing only.
- ⚠️ **Albeit** + adjective/adverb/noun phrase only — never a full clause.
- ⚠️ **Thereby** + -ing only — never a full clause.
- ⚠️ **On the contrary** = contradiction/denial; **by contrast** = parallel difference.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f6838b0c-79ea-50b3-aed4-713f61d408cb', '36944d0b-25df-5542-a207-9cc4eeea8f80', 'anglais-c1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('044cb6c3-242e-5bdd-83d9-b20e6271e3a4', 'f6838b0c-79ea-50b3-aed4-713f61d408cb', 'Complete the inverted sentence: "___ have I seen such determination."', '[{"id":"a","text":"Rarely"},{"id":"b","text":"Often"},{"id":"c","text":"Sometimes"},{"id":"d","text":"Usually"}]'::jsonb, 'a', 'Inversion is triggered by a negative or restrictive adverbial placed at the front. Only "Rarely" is a negative adverbial that triggers auxiliary inversion. "Often", "Sometimes", and "Usually" are positive adverbials and do not trigger inversion.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('870aaac1-1734-5e81-aefb-d75a607ba88a', 'f6838b0c-79ea-50b3-aed4-713f61d408cb', 'Complete: "No sooner had the match ended ___ the crowd rushed onto the pitch."', '[{"id":"a","text":"when"},{"id":"b","text":"than"},{"id":"c","text":"that"},{"id":"d","text":"but"}]'::jsonb, 'b', 'The fixed pairing is No sooner…than. "when" goes with Hardly/Scarcely, "that" is used in result clauses (so…that), and "but" belongs to Not only…but also. No sooner always partners with than.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07fa4c18-5af5-56da-8a90-1e933fb3b6c0', 'f6838b0c-79ea-50b3-aed4-713f61d408cb', 'Complete: "Hardly ___ I arrived when the director called me into the office."', '[{"id":"a","text":"have"},{"id":"b","text":"did"},{"id":"c","text":"had"},{"id":"d","text":"was"}]'::jsonb, 'c', 'The main verb arrived is in the past simple, so the correct auxiliary in the inverted clause is had (past perfect): Hardly had I arrived when… The past perfect is used because this event happened just before another past event. "have" is present perfect, "did" is past simple, and "was" doesn''t fit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efdd6b3e-653f-5ce9-b633-88eb5af1b271', 'f6838b0c-79ea-50b3-aed4-713f61d408cb', 'Which sentence correctly uses inversion with ''Not only''?', '[{"id":"a","text":"Not only she won the prize, but she also gave a speech."},{"id":"b","text":"Not only did she win the prize, but she also gave a speech."},{"id":"c","text":"Not only did she won the prize, but she also gave a speech."},{"id":"d","text":"Not only she did win the prize, but she also gave a speech."}]'::jsonb, 'b', 'After ''Not only'', inversion is required: auxiliary (did) before subject (she), then the base verb (win): Not only did she win… Option (a) has no inversion, (c) wrongly uses the past participle won after did, and (d) puts the subject before the auxiliary.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('068ba80d-1aa3-5e32-9bb1-d9ae98cfd879', 'f6838b0c-79ea-50b3-aed4-713f61d408cb', 'Complete: "___ no circumstances should you share your login details."', '[{"id":"a","text":"In"},{"id":"b","text":"On"},{"id":"c","text":"Under"},{"id":"d","text":"At"}]'::jsonb, 'c', 'The fixed expression that triggers inversion is "Under no circumstances": Under no circumstances should you… It is always "under" — not in, on, or at. This expression is used in formal notices to mean "in no situation whatsoever".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5d7b56b8-d4ab-5042-aaba-4455c4264548', '36944d0b-25df-5542-a207-9cc4eeea8f80', 'anglais-c1', '⭐ Practice: Negative Adverbials & Inversion', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a22150c5-7a75-51e7-81a1-b9937c10ffc6', '5d7b56b8-d4ab-5042-aaba-4455c4264548', 'Complete: "Never ___ I witnessed such bravery in my life."', '[{"id":"a","text":"did"},{"id":"b","text":"have"},{"id":"c","text":"was"},{"id":"d","text":"had"}]'::jsonb, 'b', '"Never" fronted triggers inversion. The base sentence is "I have never witnessed…" so the auxiliary is "have": Never have I witnessed… "did" would require the base verb (witnessed → witness), "was" is the wrong auxiliary, and "had" would be past perfect — inappropriate here without a past reference.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71fb4065-2198-54ce-ae85-ad4da30e05f2', '5d7b56b8-d4ab-5042-aaba-4455c4264548', 'Complete: "Seldom ___ she so happy as on her graduation day."', '[{"id":"a","text":"has been"},{"id":"b","text":"had been"},{"id":"c","text":"was"},{"id":"d","text":"did be"}]'::jsonb, 'c', 'The base sentence is "She was seldom so happy" — a simple past with the verb be, so inversion places was before the subject: Seldom was she so happy. "has been" (present perfect) and "had been" (past perfect) don''t match the past-simple context. "did be" is never correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2dd149fa-5b76-5593-9c76-a0abee8b777d', '5d7b56b8-d4ab-5042-aaba-4455c4264548', 'Which word correctly completes the pairing? "Hardly had we left ___ the storm began."', '[{"id":"a","text":"than"},{"id":"b","text":"that"},{"id":"c","text":"when"},{"id":"d","text":"before"}]'::jsonb, 'c', 'Hardly always pairs with "when": Hardly had we left when the storm began. Only "No sooner" pairs with "than". "That" is used in result clauses (so…that), and "before" does not collocate with Hardly in this inverted structure.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fae4710b-f77e-517c-b79f-700914a27980', '5d7b56b8-d4ab-5042-aaba-4455c4264548', 'Choose the correctly inverted sentence.', '[{"id":"a","text":"Rarely I have visited such a stunning place."},{"id":"b","text":"Rarely I visited such a stunning place."},{"id":"c","text":"Rarely did I have visited such a stunning place."},{"id":"d","text":"Rarely have I visited such a stunning place."}]'::jsonb, 'd', 'Inversion means the auxiliary comes before the subject: Rarely have I visited… Option (a) keeps normal order (I have — no inversion), (b) has no auxiliary inversion at all (simple past, no auxiliary fronted), and (c) wrongly combines did + have + past participle — you cannot mix two auxiliaries this way.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('764d2682-3ad2-50bb-9a71-2a1bbc883137', '5d7b56b8-d4ab-5042-aaba-4455c4264548', 'Complete: "Not until ___ did the team understand the full impact."', '[{"id":"a","text":"the results published"},{"id":"b","text":"the results had been published"},{"id":"c","text":"publishing the results"},{"id":"d","text":"the results were published"}]'::jsonb, 'b', 'The subordinate clause after "Not until" describes what happened first, so it uses the past perfect (had been published): Not until the results had been published did the team understand… The main clause then inverts (did…the team understand). Option (d) uses past simple — grammatically possible in informal contexts but (b) is more precise and natural at C1. Options (a) and (c) are incomplete clauses.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7fad89af-be70-5acf-9a40-a6e3b582d9f4', '5d7b56b8-d4ab-5042-aaba-4455c4264548', 'Complete: "So ___ the explosion that windows shattered three streets away."', '[{"id":"a","text":"powerful it was"},{"id":"b","text":"was powerful"},{"id":"c","text":"powerful was it"},{"id":"d","text":"powerful was"}]'::jsonb, 'd', 'In "So + adjective + inversion" the pattern is: So powerful was the explosion that… The adjective follows So, then the inverted verb (was), then the noun phrase (no pronoun "it" inserted). Option (a) keeps normal order after the adjective (it was — no inversion), (b) puts the verb before the adjective — wrong word order, and (c) inserts "it" which is not used in this inverted structure.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1d6689eb-4309-57d5-8884-0991fb8214cb', '36944d0b-25df-5542-a207-9cc4eeea8f80', 'anglais-c1', '⭐⭐ Review: Inversion Structures in Context', 2, 75, 15, 'practice', 'admin', 2)
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
  ('a28e0fb0-2f39-5610-b78d-f734640989f0', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Never have I read a more gripping novel."},{"id":"b","text":"Rarely does he make such a mistake."},{"id":"c","text":"Hardly I had sat down when the phone rang."},{"id":"d","text":"No sooner had she left than it began to rain."}]'::jsonb, 'c', 'Option (c) is wrong: "Hardly" triggers inversion, so the auxiliary must come before the subject — Hardly had I sat down when… (not "I had sat down"). Options (a), (b), and (d) all correctly apply inversion after their respective negative adverbials.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('026635ab-bc0e-5d8b-84fe-2ddc13741ab9', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'Transform to the inverted form. Base: "She had no sooner opened the email than she gasped." Which inversion is correct?', '[{"id":"a","text":"No sooner she had opened the email than she gasped."},{"id":"b","text":"No sooner had she opened the email than she gasped."},{"id":"c","text":"No sooner had she opened the email when she gasped."},{"id":"d","text":"No sooner did she open the email that she gasped."}]'::jsonb, 'b', 'Correct inversion with No sooner: auxiliary (had) before subject (she), then the past participle (opened), then "than": No sooner had she opened the email than she gasped. Option (a) lacks inversion, (c) wrongly uses "when" instead of "than", and (d) uses "that" — another error — and switches the tense unnecessarily.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa36fd77-5427-5582-902e-f6855028a878', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'Complete: "Not only ___ the match, but they also set a new record."', '[{"id":"a","text":"they won"},{"id":"b","text":"they did win"},{"id":"c","text":"did they win"},{"id":"d","text":"won they"}]'::jsonb, 'c', 'After "Not only" inversion is required: did (auxiliary) + they (subject) + win (base verb): Not only did they win the match… Option (a) keeps normal order without inversion, (b) also has wrong order (subject before auxiliary), and (d) inverts verb and subject but without the do-auxiliary — not grammatical in English.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('405c4c00-7023-5b5e-8dc3-8a72902ffe34', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'Choose the sentence that correctly uses ''Under no circumstances''.', '[{"id":"a","text":"Under no circumstances you should leave the building."},{"id":"b","text":"Under no circumstances you leave the building."},{"id":"c","text":"Under no circumstances should you leave the building."},{"id":"d","text":"Under no circumstances leave you the building."}]'::jsonb, 'c', '"Under no circumstances" triggers modal inversion: should (auxiliary) before you (subject): Under no circumstances should you leave… Options (a) and (b) retain normal subject-first order, which is wrong after a fronted negative. Option (d) has the right word order idea but puts the bare infinitive (leave) in the wrong place.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('05c92b59-90de-5e36-9ab9-fae11d2bc641', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'Which sentence uses ''Only then'' correctly?', '[{"id":"a","text":"Only then the mystery was solved."},{"id":"b","text":"Only then was the mystery solved."},{"id":"c","text":"Only then solved the mystery was."},{"id":"d","text":"Only then did the mystery solve was."}]'::jsonb, 'b', '"Only then" fronted triggers inversion: was (auxiliary) before the subject (the mystery): Only then was the mystery solved. Option (a) has no inversion, (c) puts the participle first which is not English word order, and (d) is grammatically incoherent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c903f9be-9ea5-59e6-8069-19cc9cef97eb', '1d6689eb-4309-57d5-8884-0991fb8214cb', 'Complete: "Such ___ her shock that she couldn''t speak for a moment."', '[{"id":"a","text":"is"},{"id":"b","text":"was"},{"id":"c","text":"had been"},{"id":"d","text":"has been"}]'::jsonb, 'b', '"Such was…" is the inverted form of "Her shock was so great…" in the past: Such was her shock that she couldn''t speak. The past tense was matches the past context (couldn''t speak). "is" would make it present, "had been" implies a past-before-past, and "has been" links to now — none fit the simple past narrative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', '36944d0b-25df-5542-a207-9cc4eeea8f80', 'anglais-c1', '⚔️ Chapter Boss ⭐⭐⭐: Inversion for Emphasis', 3, 120, 30, 'boss', 'admin', 3)
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
  ('7e3c0972-765a-5493-a462-d85307c20f5c', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Scarcely had the curtain risen when the actor forgot his lines."},{"id":"b","text":"Not until he retired did the truth come out."},{"id":"c","text":"Rarely I have seen such dedication in a student."},{"id":"d","text":"No sooner had the rain stopped than the sun appeared."}]'::jsonb, 'c', 'Option (c) is wrong: "Rarely" is a negative adverbial that requires inversion, so the auxiliary must precede the subject: Rarely have I seen… not "I have seen". Options (a), (b), and (d) all correctly apply inversion with Scarcely…when, Not until…did, and No sooner…than respectively.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f548f310-e279-5010-bbef-7a3e73276990', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'Rewrite keeping the same meaning. "I had never felt so free." Which inversion is correct?', '[{"id":"a","text":"Never did I felt so free."},{"id":"b","text":"Never I had felt so free."},{"id":"c","text":"Never had I felt so free."},{"id":"d","text":"Never have I felt so free."}]'::jsonb, 'c', 'The base sentence is past perfect (had felt), so the inversion retains had before I: Never had I felt so free. Option (a) uses "did" + past participle, which is wrong (did + base verb). Option (b) keeps normal order. Option (d) shifts to present perfect (have) which changes the meaning — had felt refers to a specific past period.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('529c9bcf-ee1b-5be8-a96e-b3ee8e1c2ab1', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'Complete: "Not only ___ the deadline, but her report was also praised by the director."', '[{"id":"a","text":"she met"},{"id":"b","text":"did she meet"},{"id":"c","text":"she did meet"},{"id":"d","text":"had she met"}]'::jsonb, 'b', 'After "Not only" use auxiliary + subject + base verb: Not only did she meet the deadline. Option (a) has no inversion, (c) puts the subject first before the auxiliary — still wrong order, and (d) uses past perfect (had) which implies an earlier event — inappropriate here for a simple past narrative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b93035a5-1d5b-5353-b7f0-e6754fb24bcb', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'Read: "The experiment was of such importance that it changed scientific thinking for decades." Which inversion correctly rephrases this?', '[{"id":"a","text":"So important was the experiment that it changed scientific thinking for decades."},{"id":"b","text":"So important the experiment was that it changed scientific thinking for decades."},{"id":"c","text":"Such the experiment was important that it changed scientific thinking for decades."},{"id":"d","text":"So the experiment was important that it changed scientific thinking for decades."}]'::jsonb, 'a', 'The correct "So + adjective + inversion" pattern is: So important was the experiment that… The adjective comes directly after So, then the inverted verb (was), then the subject (the experiment). Option (b) keeps normal order after the adjective. Options (c) and (d) misplace elements.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5e309c7-3924-5982-b50a-44eb2628d89a', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'Complete (formal letter register): "___ are staff permitted to access the server room without authorisation."', '[{"id":"a","text":"Never"},{"id":"b","text":"Rarely"},{"id":"c","text":"Under no circumstances"},{"id":"d","text":"Not until"}]'::jsonb, 'c', '"Under no circumstances are staff permitted…" is the appropriate formal absolute prohibition. "Never are staff permitted" is grammatically possible but less idiomatic in notices. "Rarely" implies sometimes it happens, which contradicts "without authorisation". "Not until" requires a time clause and does not work here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b097cb2f-7384-5b7f-96e4-0f6a9818150c', 'f4f5e73f-60ba-5ce7-ac17-fd97bdb69631', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Hardly had I fallen asleep when my alarm went off."},{"id":"b","text":"No sooner had he spoken than he regretted his words."},{"id":"c","text":"Not only is she fluent in French, but she speaks Arabic too."},{"id":"d","text":"Scarcely had we arrived than the ceremony began."}]'::jsonb, 'd', 'Option (d) is wrong: "Scarcely" (like "Hardly") pairs with "when", not "than": Scarcely had we arrived when the ceremony began. "Than" is reserved for "No sooner…than". Options (a), (b), and (c) correctly use Hardly…when, No sooner…than, and Not only…but respectively.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d9189423-2609-55a8-b3da-6c2aeac3018b', '36944d0b-25df-5542-a207-9cc4eeea8f80', 'anglais-c1', '👑 Elite Challenge ⭐⭐⭐⭐: Inversion for Emphasis', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('4136627f-7336-57a4-ac2b-becb377832cb', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'Read the passage: "The scientist had barely completed her analysis when the lab flooded. She had never encountered a disaster of such magnitude. The damage was so severe that repairs took months."

Which inverted rewriting of the SECOND sentence is correct?', '[{"id":"a","text":"Never she had encountered a disaster of such magnitude."},{"id":"b","text":"Never had she encountered a disaster of such magnitude."},{"id":"c","text":"Never has she encountered a disaster of such magnitude."},{"id":"d","text":"Never did she encounter a disaster of such magnitude."}]'::jsonb, 'b', 'The base is past perfect (had encountered) — matching the before-flood narrative. Inversion keeps the same tense: Never had she encountered… Option (a) lacks inversion (subject before auxiliary). Option (c) shifts to present perfect, wrong for a past narrative. Option (d) uses did + base verb, but "had encountered" is past perfect — did would erase the past-perfect meaning.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71fa085a-1fe6-556b-9e24-560043ac6c61', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'Find the TWO errors. "Not only she helped the refugees, but she did also organise fundraising events. Rarely, the international press had shown such interest."

Which answer correctly identifies them?', '[{"id":"a","text":"\"she helped\" lacks inversion; \"Rarely, the international press\" lacks inversion."},{"id":"b","text":"\"did also organise\" should be \"also did organise\"; \"Rarely\" is wrong here."},{"id":"c","text":"\"Not only\" should be \"Not just\"; \"had shown\" should be \"has shown\"."},{"id":"d","text":"\"but she did also\" should be \"but she has also\"; the comma after \"Rarely\" is wrong."}]'::jsonb, 'a', 'Error 1: after "Not only" the first clause must invert — Not only DID SHE help… Error 2: "Rarely" fronted requires inversion — Rarely had the international press shown such interest (or Rarely does the international press show…). Option (b) wrongly targets the second clause and dismisses Rarely. Option (c) targets Neither content as wrong. Option (d) misidentifies both errors.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bc680fe-9015-55fd-b33a-b154b90d474b', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'Complete this formal academic sentence: "___ the project team realise the scale of the task ahead."', '[{"id":"a","text":"Only when the data arrived did"},{"id":"b","text":"Only when the data arrived, did"},{"id":"c","text":"Only when did the data arrive"},{"id":"d","text":"Only did when the data arrive"}]'::jsonb, 'a', 'The structure is: Only when [subordinate clause] + inverted main clause (did + subject). Inversion happens in the MAIN clause, not the subordinate: Only when the data arrived did the project team realise… Option (b) incorrectly adds a comma before the inverted main clause. Options (c) and (d) wrongly apply inversion inside the when-clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41da8824-50e4-5a0e-bac1-20e361136411', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'Which sentence is the most appropriate for a formal academic essay arguing a case?', '[{"id":"a","text":"I have never seen such strong evidence in my research."},{"id":"b","text":"Never have I encountered such compelling evidence in the literature."},{"id":"c","text":"Such was the strength of the evidence, you couldn''t ignore it."},{"id":"d","text":"The evidence was never that strong before, I think."}]'::jsonb, 'b', 'Option (b) combines fronted inversion (Never have I encountered) with formal vocabulary (compelling evidence, literature) and avoids first-person hedging — ideal for an academic essay making a strong claim. Option (a) uses informal first-person without inversion. Option (c) is good but uses "you" which is informal in academic writing. Option (d) is casual and vague.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2097582f-eeac-50be-8999-3a96cd3a45bf', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'Complete the complex inversion: "Not only ___ the deadline impossible to meet, ___ the brief itself was poorly defined."', '[{"id":"a","text":"was … but"},{"id":"b","text":"the deadline was … but also"},{"id":"c","text":"was … but also"},{"id":"d","text":"the deadline was … and also"}]'::jsonb, 'c', 'After "Not only" the verb (was) inverts before the subject: Not only WAS the deadline impossible to meet, but also the brief itself was poorly defined. The second clause uses normal order after "but also". Option (a) misses "also", making the paired structure incomplete. Options (b) and (d) lack inversion in the first clause.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('052706f2-6f5d-5332-9b28-b271d98d5ff2', 'd9189423-2609-55a8-b3da-6c2aeac3018b', 'Read: "The CEO announced that production had been halted, costs had spiralled, and the workforce morale was at an all-time low."

Choose the inverted sentence that best rephrases the THIRD point for a dramatic speech.', '[{"id":"a","text":"Such the morale of the workforce was low."},{"id":"b","text":"So low was the morale of the workforce."},{"id":"c","text":"Low so was the workforce morale."},{"id":"d","text":"The morale was so low it had never been seen before."}]'::jsonb, 'b', 'The correct "So + adjective + inversion" pattern is: So low was the morale of the workforce (often completed with "that…"). Option (a) puts "the morale" before the verb with an extra "low" — scrambled word order. Option (c) reverses So and the adjective. Option (d) is normal order with no inversion — valid English but does not fulfil the task.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('af86b120-dc2e-5689-b635-8764e7370667', '109d0c1b-7491-540a-8c61-771d4801dc19', 'anglais-c1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('210257f6-e1e2-5f60-9993-c7150173769a', 'af86b120-dc2e-5689-b635-8764e7370667', 'Which sentence is an It-cleft?', '[{"id":"a","text":"What I need is a long rest."},{"id":"b","text":"It was Karim who reported the error."},{"id":"c","text":"All I want is peace."},{"id":"d","text":"It is important to study."}]'::jsonb, 'b', 'An It-cleft has the structure It + be + [focused element] + that/who + rest of clause. Option (b) focuses on Karim (who). Option (a) is a Wh-cleft (What…). Option (c) is an All-cleft. Option (d) uses anticipatory it (no focused element after that/who) — it is NOT a cleft.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e0772e3-6cf2-57ef-aded-197712ac49fb', 'af86b120-dc2e-5689-b635-8764e7370667', 'Complete the Wh-cleft: "___ he did was apologise."', '[{"id":"a","text":"That"},{"id":"b","text":"It"},{"id":"c","text":"What"},{"id":"d","text":"All what"}]'::jsonb, 'c', 'A Wh-cleft starts with a wh-word (What, Where, When…): What he did was apologise. "That" makes a different structure (a relative clause or result clause). "It" starts an It-cleft, not a Wh-cleft. "All what" is never used — the correct limiting cleft is simply "All he did was…".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('980c7340-b58b-5b66-b391-314cd5d59511', 'af86b120-dc2e-5689-b635-8764e7370667', 'Complete the It-cleft: "It was ___ that first inspired him to become a doctor."', '[{"id":"a","text":"what his father"},{"id":"b","text":"his father"},{"id":"c","text":"it was his father"},{"id":"d","text":"who his father"}]'::jsonb, 'b', 'In an It-cleft: It + was + [focused element] + that/who + rest. The focused element is simply "his father" — no need for an extra "what" or repeated "it was". Option (d) wrongly adds "who" before the noun (who comes after the focused element, not before it in a correctly formed cleft).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65ea6d16-101c-5147-aef1-f3e4759139ba', 'af86b120-dc2e-5689-b635-8764e7370667', 'Complete the All-cleft: "All she did was ___ at the ceiling."', '[{"id":"a","text":"to stare"},{"id":"b","text":"staring"},{"id":"c","text":"stare"},{"id":"d","text":"stared"}]'::jsonb, 'c', 'After "All [subject] did was" the focused verb uses the bare infinitive (no to): All she did was stare. "to stare" (to-infinitive) is the most common learner error here. "staring" (gerund/present participle) and "stared" (past tense) are both wrong after was in this All-cleft structure.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac1bea63-d5a9-5632-83ff-da6e54048024', 'af86b120-dc2e-5689-b635-8764e7370667', 'Which sentence correctly uses an It-cleft to focus on the time?', '[{"id":"a","text":"It was when the policy changed that everything improved."},{"id":"b","text":"What changed was the policy."},{"id":"c","text":"All they did was change the policy."},{"id":"d","text":"The policy is what changed everything."}]'::jsonb, 'a', 'To focus on a time, an It-cleft uses: It was + time/when-phrase + that + rest: It was when the policy changed that everything improved. Option (b) is a Wh-cleft focusing on what changed. Option (c) is an All-cleft focusing on an action. Option (d) is a reverse Wh-cleft focusing on the policy — not the time.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', '109d0c1b-7491-540a-8c61-771d4801dc19', 'anglais-c1', '⭐ Practice: Identifying & Forming Clefts', 1, 50, 10, 'practice', 'admin', 1)
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
  ('2568532d-ed0d-5c07-9cae-6d210a152aea', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'Identify the cleft type: "What the committee lacks is a clear vision."', '[{"id":"a","text":"It-cleft"},{"id":"b","text":"Wh-cleft (pseudo-cleft)"},{"id":"c","text":"All-cleft"},{"id":"d","text":"Reverse Wh-cleft"}]'::jsonb, 'b', 'A Wh-cleft (pseudo-cleft) opens with a wh-clause as subject: What the committee lacks is a clear vision — the wh-clause (What…) + is + focused element (a clear vision). An It-cleft would start with "It was…". An All-cleft starts with "All…". A reverse Wh-cleft would put the focus first: "A clear vision is what the committee lacks."', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25540a51-8bb2-550e-8c65-f5bf74fcbead', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'Complete the It-cleft: "It was ___ who designed the iconic logo."', '[{"id":"a","text":"the designer"},{"id":"b","text":"that the designer"},{"id":"c","text":"what the designer"},{"id":"d","text":"when the designer"}]'::jsonb, 'a', 'The It-cleft structure is: It was + [focused element] + who + rest. The focused element (the designer) fits directly after was. Options (b), (c), and (d) all insert an extra word that would interrupt the cleft structure and create a grammatical error.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b21ed79-5af2-5a61-b5f6-928631dd41f6', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'Complete: "___ is what I find most exciting about the project."', '[{"id":"a","text":"It"},{"id":"b","text":"That"},{"id":"c","text":"The creative freedom"},{"id":"d","text":"What the creative freedom"}]'::jsonb, 'c', 'This is a reverse Wh-cleft: [focused element] + is + what-clause. The focused element (The creative freedom) goes at the start: The creative freedom is what I find most exciting. "It" would start an It-cleft but then needs "that/who" not "what". "That" is not used this way. "What the creative freedom" is not a noun phrase.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40fcc502-f829-5938-b3b2-513ac83ff0b1', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'Choose the correct All-cleft: "She didn''t complain or argue — she just listened."', '[{"id":"a","text":"All she did was to listen."},{"id":"b","text":"All she did was listened."},{"id":"c","text":"All she did was listen."},{"id":"d","text":"All what she did was listen."}]'::jsonb, 'c', 'After "All [subject] did was", use the bare infinitive: All she did was listen. "to listen" (to-infinitive) is the classic learner trap here. "listened" (past tense after was) is ungrammatical. "All what" is never correct — the relative pronoun in this structure is simply dropped or just "All".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9840a4c8-c0a7-589c-901a-eecaaa3f26dd', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'Rewrite using an It-cleft to focus on the underlined word: "The **design** team won the award, not the sales team."', '[{"id":"a","text":"What the design team did was win the award."},{"id":"b","text":"It was the design team who won the award."},{"id":"c","text":"It was the award that the design team won."},{"id":"d","text":"The design team is who won the award."}]'::jsonb, 'b', 'To focus on WHO (the design team), use: It was + the design team + who + won the award. Option (a) is a Wh-cleft, not an It-cleft. Option (c) focuses on the award (WHAT), not the team. Option (d) is not a standard cleft — "The X is who" is not the It-cleft formula.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ae681ed-dee1-5283-a409-b02ee67a3301', 'ab5e3d44-87d8-5ecc-8ef9-0c9c149704ee', 'Which sentence does NOT contain a cleft?', '[{"id":"a","text":"It is honesty that I admire most in a leader."},{"id":"b","text":"What shocked us was his resignation."},{"id":"c","text":"All they asked for was a fair hearing."},{"id":"d","text":"It is vital that you submit the form before Friday."}]'::jsonb, 'd', 'Option (d) uses anticipatory "it" (It is vital that…) — "that" introduces a content clause, not a relative clause focusing on a specific element. There is no cleft split. Options (a), (b), and (c) are respectively an It-cleft, a Wh-cleft, and an All-cleft.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', '109d0c1b-7491-540a-8c61-771d4801dc19', 'anglais-c1', '⭐⭐ Review: Cleft Sentences in Context', 2, 75, 15, 'practice', 'admin', 2)
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
  ('e9a6424d-1edb-5770-a83a-47ee5acdf3de', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'Find the INCORRECT cleft sentence.', '[{"id":"a","text":"It was the director who approved the budget."},{"id":"b","text":"What we need is more time."},{"id":"c","text":"It is patience what he lacks."},{"id":"d","text":"All she wanted was to be understood."}]'::jsonb, 'c', 'Option (c) is wrong: an It-cleft uses "that" or "who", not "what": It is patience **that** he lacks. "What" introduces a Wh-cleft which has a different structure (What he lacks is patience). Options (a), (b), and (d) are all correctly formed clefts.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8060405-9c85-511d-9e22-71373d18c151', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'Complete to contrast: "It wasn''t the price ___ put them off — it was the complexity."', '[{"id":"a","text":"which"},{"id":"b","text":"what"},{"id":"c","text":"that"},{"id":"d","text":"who"}]'::jsonb, 'c', 'In an It-cleft focusing on a thing (the price), the linker is "that": It wasn''t the price **that** put them off. "What" is used to begin a Wh-cleft, not as a linker after the focused element. "Which" is a defining relative pronoun, not used in cleft construction. "Who" is for persons only.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3228ac04-7d76-5f4d-a1c5-cdebd7a6ce01', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'Rewrite as a Wh-cleft: "The company desperately needs investment."', '[{"id":"a","text":"It is investment that the company desperately needs."},{"id":"b","text":"What the company desperately needs is investment."},{"id":"c","text":"All the company needs is to invest desperately."},{"id":"d","text":"Investment is all what the company needs."}]'::jsonb, 'b', 'A Wh-cleft: What [clause] is [focus]: What the company desperately needs is investment. Option (a) is an It-cleft (also correct meaning, but asks for Wh-cleft). Option (c) is an All-cleft and also changes the meaning. Option (d) uses "all what" which is never correct.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64e432b3-af1d-5152-bc47-7b9dbd99c6da', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'Which sentence uses a reverse Wh-cleft correctly?', '[{"id":"a","text":"A reliable partner is what every business needs."},{"id":"b","text":"What every business needs a reliable partner."},{"id":"c","text":"It is a reliable partner what every business needs."},{"id":"d","text":"Every business is what needs a reliable partner."}]'::jsonb, 'a', 'A reverse Wh-cleft: [focused element] + is/was + what-clause: A reliable partner is what every business needs. Option (b) lacks the verb (is) after the Wh-clause. Option (c) wrongly uses "what" in an It-cleft frame (should be "that"). Option (d) puts "every business" as the subject of the cleft, which is nonsensical.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a5fe107-1d5c-5210-b758-55fca927434c', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'Complete the academic It-cleft for correction: "Many believe price caused the failure. In fact, ___ that caused the failure."', '[{"id":"a","text":"it was not price but poor management"},{"id":"b","text":"what was not price but poor management"},{"id":"c","text":"it is not the price, poor management"},{"id":"d","text":"not the price it was, but poor management"}]'::jsonb, 'a', 'The It-cleft for contrasting/correcting: It was not [X] but [Y] that caused the failure: It was not price but poor management that caused the failure. Option (b) starts with "what" — a Wh-cleft structure, but then uses "was not price" which is ungrammatical here. Options (c) and (d) disrupt the cleft formula.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b90ea57a-bb8e-503f-b140-c733f1fd0972', 'fd2a80b7-48bb-5ca4-90a0-a224fa94b5e1', 'Read: "She didn''t shout or threaten. She simply resigned." Which cleft sentence best captures ''she simply resigned''?', '[{"id":"a","text":"It was resigning simply that she did."},{"id":"b","text":"What she did was to resign."},{"id":"c","text":"All she did was resign."},{"id":"d","text":"It was she who resigned simply."}]'::jsonb, 'c', 'An All-cleft is perfect for contrasting what someone actually did: All she did was resign. The bare infinitive (resign, not to resign) is required after All…did was. Option (b) uses "to resign" which is the common error. Option (a) is not natural English word order. Option (d) focuses awkwardly on the person and the adverb placement is unnatural.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6283740-5c2b-5dea-afbc-1b1d0549b846', '109d0c1b-7491-540a-8c61-771d4801dc19', 'anglais-c1', '⚔️ Chapter Boss ⭐⭐⭐: Cleft Sentences', 3, 120, 30, 'boss', 'admin', 3)
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
  ('9bcf9b7b-e354-54d8-8ab5-a990c2bb1a29', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', 'Find the INCORRECT cleft sentence.', '[{"id":"a","text":"It was the novel''s ending that divided critics."},{"id":"b","text":"What I value above all is integrity."},{"id":"c","text":"It was because she worked hard what she succeeded."},{"id":"d","text":"It was only after the crash that we understood."}]'::jsonb, 'c', 'Option (c) is wrong: in an It-cleft the linker after the focused element is "that" (or who for persons), never "what": It was because she worked hard **that** she succeeded. "What" begins a Wh-cleft (What she did was work hard…) — it cannot serve as the It-cleft linker. Options (a), (b), and (d) are all correctly formed clefts.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0f98206-fec7-5bf2-86f5-f4676d7d0ffa', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', 'Complete the It-cleft to focus on the time: "They finally signed the treaty in 1995. → It was ___ that they finally signed the treaty."', '[{"id":"a","text":"1995"},{"id":"b","text":"in 1995"},{"id":"c","text":"when 1995"},{"id":"d","text":"at 1995"}]'::jsonb, 'b', 'When fronting a time expression as the focused element in an It-cleft, the preposition is retained: It was **in 1995** that they finally signed the treaty. Dropping "in" (option a) creates a bare year which sounds incomplete. "when 1995" (c) is ungrammatical. "at 1995" (d) uses the wrong preposition for years.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bc0b31a-ec85-50a3-8a74-c00342b84155', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', 'Which sentence best paraphrases: "The lack of communication, not the workload, caused burnout among staff."', '[{"id":"a","text":"What caused burnout among staff was the lack of communication, not the workload."},{"id":"b","text":"All caused burnout was the lack of communication."},{"id":"c","text":"It was what the lack of communication that caused burnout."},{"id":"d","text":"What the lack of communication caused was burnout that there was among staff."}]'::jsonb, 'a', 'A Wh-cleft is ideal for identifying a cause: What caused burnout among staff was the lack of communication, not the workload. This structure places the context first and the key information last, with the contrast naturally appended. Option (b) uses "All" incorrectly — All-clefts need a subject between All and the verb (All [subject] did…). Options (c) and (d) are grammatically incoherent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d2d55d7-7820-5434-af61-97663c2dec2a', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', 'Read: "The government did not reduce taxes. What it did was raise public spending."

What is the function of the cleft in the second sentence?', '[{"id":"a","text":"It describes a sequence of events."},{"id":"b","text":"It contrasts the government''s actual action against an implied expectation or claim."},{"id":"c","text":"It softens the criticism of government policy."},{"id":"d","text":"It emphasises that the information is unimportant."}]'::jsonb, 'b', 'The Wh-cleft "What it did was raise public spending" contrasts what actually happened against the implied expectation (reducing taxes). Clefts are a key tool for pragmatic contrast and correction in discourse — placing the real information in the focused slot. It does not describe sequence (a), does not soften (c — it actually highlights the contrast sharply), and emphasis always signals importance, not unimportance (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2e0b2e4-068e-514c-ac33-fce835a4b1f6', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', 'Choose the sentence with the correct verb agreement in an It-cleft.', '[{"id":"a","text":"It is the students who decides the pace of learning."},{"id":"b","text":"It are the students who decide the pace of learning."},{"id":"c","text":"It is the students who decide the pace of learning."},{"id":"d","text":"It was the students who decides the pace of learning."}]'::jsonb, 'c', 'In an It-cleft, the verb in the relative clause (who decide) agrees with the focused element (the students — plural), not with "it": It is the students who decide… Option (a) uses "decides" (singular) incorrectly. Option (b) wrongly makes "It are" plural. Option (d) mixes past "was" with present "decides" — a tense inconsistency.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4255b09d-571f-58ca-974b-3292a157dd29', 'c6283740-5c2b-5dea-afbc-1b1d0549b846', 'Transform using a cleft: "Everyone was surprised by her composure." Focus on WHAT surprised everyone.', '[{"id":"a","text":"It was everyone that her composure surprised."},{"id":"b","text":"What surprised everyone was her composure."},{"id":"c","text":"All surprised everyone was her composure."},{"id":"d","text":"Her composure is that surprised everyone."}]'::jsonb, 'b', 'To focus on WHAT surprised everyone, a Wh-cleft is ideal: What surprised everyone was her composure — the wh-clause sets the context (What surprised everyone) and the focused element (her composure) comes last. Option (a) is an It-cleft but focuses on the wrong element (everyone = who was affected, not what caused the surprise). Option (c) uses All incorrectly. Option (d) is not a standard English structure.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', '109d0c1b-7491-540a-8c61-771d4801dc19', 'anglais-c1', '👑 Elite Challenge ⭐⭐⭐⭐: Cleft Sentences', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('36739adf-b343-57fd-9c2f-1603bf20603a', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'Read: "The merger failed. Analysts blamed poor due diligence, not market conditions."

Which cleft sentence best captures the analyst''s claim for a business report?', '[{"id":"a","text":"It was poor due diligence, not market conditions, that caused the merger to fail."},{"id":"b","text":"What the analysts did was to blame poor due diligence."},{"id":"c","text":"All the analysts said was market conditions caused the failure."},{"id":"d","text":"Poor due diligence is what market conditions caused."}]'::jsonb, 'a', 'An It-cleft is the standard tool for contrasting two explanations in formal writing: It was [X], not [Y], that caused… It focuses on the cause (poor due diligence) and explicitly rejects the alternative (market conditions). Option (b) shifts focus to what the analysts did, not what caused the failure. Option (c) contradicts the analysts'' actual claim. Option (d) confusingly makes market conditions the subject of cause — the opposite of the intended meaning.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('501dffb9-eb3a-5a61-ae75-9f3691319c4a', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'Find the TWO errors in this paragraph: "What she realised was that she had misjudged the situation. It was this realisation what prompted her to change strategy."

Which answer correctly identifies them?', '[{"id":"a","text":"\"What she realised\" should be \"It\"; \"what prompted\" should be \"that prompted\"."},{"id":"b","text":"\"was that\" should be \"was what\"; \"what prompted\" should be \"that prompted\"."},{"id":"c","text":"There is only one error: \"what prompted\" should be \"that prompted\"."},{"id":"d","text":"\"What she realised was that\" should be \"What she realised was\"; \"prompted\" needs to be \"prompting\"."}]'::jsonb, 'c', 'There is only ONE error: in the It-cleft "It was this realisation **what** prompted her…", the linker must be "that", not "what" (which belongs to Wh-clefts). The first sentence "What she realised was that…" is a perfectly correct Wh-cleft — What [clause] + was + that-clause. Option (a) wrongly attacks the correct Wh-cleft. Option (b) wrongly changes "was that" in the first sentence. Option (d) makes an unnecessary change to the first sentence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a3279da-57dd-5715-899d-09ca92a0d6d3', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'Complete for maximum emphasis in a formal speech: "I am not asking for loyalty or obedience. ___ is your honesty."', '[{"id":"a","text":"It is what I ask"},{"id":"b","text":"All that I ask"},{"id":"c","text":"What I ask for"},{"id":"d","text":"All I ask for"}]'::jsonb, 'd', '"All I ask for is your honesty" is an All-cleft — it limits and focuses the request dramatically, ideal for a formal speech. The complete sentence: All I ask for is your honesty. Option (c) produces a Wh-cleft: "What I ask for is your honesty" — also correct, but "All" adds the limiting nuance (nothing more, just honesty) which makes it more rhetorically powerful. Option (a) leaves a dangling clause. Option (b) adds "that" which is redundant in the All-cleft.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2553f8f9-b62d-5ede-b830-e08eb7fab599', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'Which cleft sentence is most appropriate for a formal academic essay correction?', '[{"id":"a","text":"What people usually think is that inflation causes unemployment, but this is wrong."},{"id":"b","text":"It is not inflation but structural barriers that drive unemployment."},{"id":"c","text":"All economists agree on is that inflation is bad."},{"id":"d","text":"Unemployment is what inflation causes, actually."}]'::jsonb, 'b', 'For formally correcting a misconception in an academic essay, an It-cleft with negation and contrast is standard: It is not [X] but [Y] that… This structure precisely identifies what is and is not the cause. Option (a) is a Wh-cleft that captures the misconception but is more narrative. Option (c) changes the claim. Option (d) is informal and uses "actually" — too conversational for academic prose.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85a5c605-7b4c-52ca-9c4c-5c599a814a92', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'Complete the cleft to focus on the REASON: "She failed the exam because she hadn''t slept." → "It was ___ that she failed the exam."', '[{"id":"a","text":"she hadn''t slept"},{"id":"b","text":"because she hadn''t slept"},{"id":"c","text":"the reason she hadn''t slept"},{"id":"d","text":"why she hadn''t slept"}]'::jsonb, 'b', 'When the focused element is a reason, the full because-clause is retained in the cleft: It was **because she hadn''t slept** that she failed the exam. Option (a) drops the subordinating conjunction "because" — losing the causal meaning. Option (c) adds an unnecessary "the reason" before the clause, creating a double reason marker. Option (d) introduces "why" which is used in reported questions, not in It-cleft focused reason slots.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b46a545d-646a-554d-b4ef-5e492ce6ea6f', '3a83dc96-1a1f-5f20-a9f6-5e9d0e9a6422', 'Read: "The company''s recovery was not due to its new CEO. The turnaround was driven by the employees who worked through the crisis."

Choose the cleft that most elegantly combines both sentences for a report.', '[{"id":"a","text":"What drove the turnaround was not the new CEO but the employees who worked through the crisis."},{"id":"b","text":"It was not the new CEO what drove the turnaround, but the employees."},{"id":"c","text":"All that drove the turnaround was the employees, not the new CEO."},{"id":"d","text":"The employees who worked through the crisis is what drove the turnaround."}]'::jsonb, 'a', 'A Wh-cleft with a built-in contrast: What drove the turnaround was not [X] but [Y] — elegant, formal, and combining both ideas in a single sentence. Option (b) uses "what" as the It-cleft linker, which is wrong (should be "that"). Option (c) uses All-cleft which implies nothing else was involved — too limiting. Option (d) has a subject-verb agreement error: "The employees… is" should be "are", and it reads awkwardly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'c6fee95d-7870-566a-842f-bbc5b2d0b46c', 'anglais-c1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('4779a573-46a9-54e3-ad5d-f78a94440987', 'cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'She arrived two hours ago and hasn''t eaten since this morning. Complete: "She ___ be starving by now."', '[{"id":"a","text":"can''t"},{"id":"b","text":"must"},{"id":"c","text":"couldn''t"},{"id":"d","text":"might not"}]'::jsonb, 'b', 'Strong evidence (no food for hours) leads to a near-certain positive deduction: She must be starving. "Can''t" and "couldn''t" signal near-certain negatives — the opposite of what the evidence suggests. "Might not" expresses uncertain negation, also contradicting the context.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9009021-888e-5a74-a548-0b4bcb986718', 'cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'Complete the past deduction: "No one answered the door. They ___ gone out."', '[{"id":"a","text":"must"},{"id":"b","text":"must have"},{"id":"c","text":"had to"},{"id":"d","text":"should have"}]'::jsonb, 'b', 'Past deduction requires modal + have + past participle: They must have gone out. "Must" alone (a) only works for present deduction (+ base verb). "Had to" expresses past obligation, not deduction. "Should have" expresses what was advisable but didn''t happen — a different meaning entirely.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63004ed7-abb3-591e-91e7-601a32108f66', 'cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'The safe was locked and the code was only known to three people. Complete: "An outsider ___ opened it."', '[{"id":"a","text":"must have"},{"id":"b","text":"might have"},{"id":"c","text":"couldn''t have"},{"id":"d","text":"should have"}]'::jsonb, 'c', 'Since only three insiders knew the code, it was **impossible** for an outsider to open the safe: couldn''t have + past participle. "Must have" would mean they almost certainly did — wrong. "Might have" expresses possibility — contradicts the locked-code evidence. "Should have" is about advisability, not possibility.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85bacf56-d285-5a38-a3ae-6921d0a1710d', 'cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'Which sentence correctly expresses a near-certain NEGATIVE past deduction?', '[{"id":"a","text":"She must not have passed the exam — she looks devastated."},{"id":"b","text":"She can''t have passed the exam — she looks devastated."},{"id":"c","text":"She mustn''t have passed the exam — she looks devastated."},{"id":"d","text":"She hadn''t passed the exam — she looks devastated."}]'::jsonb, 'b', 'For near-certain negative past deduction, the correct form is **can''t have + past participle**: She can''t have passed. Option (a) "must not have" is not standard for deduction — it sounds like prohibition. Option (c) "mustn''t have" is the contraction of must not — equally wrong for past deduction. Option (d) uses the past perfect as a statement of fact, not a deduction.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8255cdfb-222d-5920-97b8-81d6415863db', 'cf72fd19-a0a9-58e0-a6c0-f9c8f01233a9', 'Complete: "I''m not sure where Sara is. She ___ gone to the library — she mentioned it earlier."', '[{"id":"a","text":"must have"},{"id":"b","text":"can''t have"},{"id":"c","text":"couldn''t have"},{"id":"d","text":"might have"}]'::jsonb, 'd', 'The speaker is uncertain ("I''m not sure") but has weak evidence (she mentioned the library): might have gone expresses possibility without certainty. "Must have" would claim near-certainty, which contradicts "I''m not sure". "Can''t have" and "couldn''t have" express near-certain negation — the opposite of the intended meaning.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'c6fee95d-7870-566a-842f-bbc5b2d0b46c', 'anglais-c1', '⭐ Practice: Modal Forms & Present Deductions', 1, 50, 10, 'practice', 'admin', 1)
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
  ('2069bfcd-a3f7-5aad-8325-4174a455e476', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'The café is empty and the chairs are on the tables. Complete: "It ___ closed."', '[{"id":"a","text":"must be"},{"id":"b","text":"can''t be"},{"id":"c","text":"should be"},{"id":"d","text":"would be"}]'::jsonb, 'a', 'The evidence (empty café, chairs up) points strongly to a positive conclusion: It must be closed. "Can''t be" signals near-certain negation — wrong here. "Should be" expresses expectation or advice, not deduction from evidence. "Would be" expresses a conditional, not an evidence-based deduction.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26a12c9f-caf7-5d61-a5b5-46efeb6bf5c9', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'He just ran a marathon. Complete: "He ___ exhausted — he just ran 42 kilometres!"', '[{"id":"a","text":"might be"},{"id":"b","text":"can''t be"},{"id":"c","text":"must be"},{"id":"d","text":"could be"}]'::jsonb, 'c', 'Strong, undeniable evidence (just ran 42km) makes this a near-certain deduction: He must be exhausted. "Might be" and "could be" suggest mere possibility, which understates the certainty. "Can''t be" is a near-certain negative — the opposite meaning.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b223ffa-d71a-5255-b91e-0b2894389d48', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'Her office light is off and the door is locked. What is the most likely deduction?', '[{"id":"a","text":"She must be working late."},{"id":"b","text":"She can''t be in her office."},{"id":"c","text":"She must not be in her office."},{"id":"d","text":"She should be in her office."}]'::jsonb, 'b', 'A dark, locked office is strong evidence she is NOT there: She can''t be in her office — near-certain negative deduction. Option (a) is the opposite conclusion. Option (c) "must not be" is less idiomatic for deduction — "can''t be" is the standard near-certain negative. Option (d) "should be" expresses expectation from a schedule or rule, not an evidence-based deduction.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33b8a495-6afe-548b-a99f-d8e429a6fdc7', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'Complete the present deduction: "I can hear music from next door at 3 a.m. The neighbours ___ having a party."', '[{"id":"a","text":"had to be"},{"id":"b","text":"must be"},{"id":"c","text":"should be"},{"id":"d","text":"can be"}]'::jsonb, 'b', 'Audible evidence (loud music at 3 a.m.) makes a near-certain deduction appropriate: must be having a party. "Had to be" is a past obligation structure. "Should be" is about expectation — not evidence-based deduction. "Can be" expresses general possibility, not a specific current deduction from evidence.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0a8e205-a4bf-5c16-9df1-7281188de79d', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'Identify the INCORRECT use of a modal of deduction.', '[{"id":"a","text":"The roads are icy — it must be very cold outside."},{"id":"b","text":"She won every game — she can''t be a beginner."},{"id":"c","text":"He''s never been here — he might know the way."},{"id":"d","text":"The project is half done — they could be halfway through."}]'::jsonb, 'c', 'Option (c) is contradictory: if he has never been here, it is unlikely he knows the way — so "might know" (possibility) clashes with the evidence. A logical deduction would be: He can''t know the way (near-certain negative). Options (a), (b), and (d) all match their evidence correctly: icy roads → cold (must), winning every game → not a beginner (can''t), project half done → halfway through (could).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0eba14a6-3066-59cd-88c6-efdd40f08ce1', 'b23a50cc-a2be-5ab3-ae2f-7ab29462cc18', 'Complete with the most precise modal: "The test results show complete recovery. The treatment ___ be working."', '[{"id":"a","text":"could"},{"id":"b","text":"might"},{"id":"c","text":"must"},{"id":"d","text":"should"}]'::jsonb, 'c', '"Complete recovery" shown by test results is strong, concrete evidence pointing to a near-certain conclusion: The treatment must be working. "Could" and "might" express mere possibility — too weak for such definitive test results. "Should" expresses expected or advisable outcomes, not evidence-based deduction.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b300ade6-5707-5502-a755-012849136ee3', 'c6fee95d-7870-566a-842f-bbc5b2d0b46c', 'anglais-c1', '⭐⭐ Review: Past Deductions — Modal + Have + Past Participle', 2, 75, 15, 'practice', 'admin', 2)
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
  ('9617be9a-4891-5074-b186-e31c51732f26', 'b300ade6-5707-5502-a755-012849136ee3', 'His car keys are on the table. Complete: "He ___ driven to the meeting — his keys are here!"', '[{"id":"a","text":"can''t have"},{"id":"b","text":"must have"},{"id":"c","text":"should have"},{"id":"d","text":"might have"}]'::jsonb, 'a', 'If his keys are on the table, he almost certainly did NOT drive: He can''t have driven — near-certain negative past deduction. "Must have" would mean he almost certainly did drive — the opposite. "Should have" expresses advice about the past. "Might have" suggests possibility — contradicts the concrete evidence of keys on the table.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49120c6c-82a6-5b8d-849e-ac76677f178e', 'b300ade6-5707-5502-a755-012849136ee3', 'Complete the past deduction: "The window is broken from the inside. Someone ___ tried to escape."', '[{"id":"a","text":"must have"},{"id":"b","text":"must"},{"id":"c","text":"had to"},{"id":"d","text":"would have"}]'::jsonb, 'a', 'Past deduction from physical evidence uses must have + past participle: must have tried to escape. Option (b) "must" alone is only for present deductions (+ base verb). Option (c) "had to" means past obligation (they were required to escape), not a deduction. Option (d) "would have" appears in conditionals — there is no if-clause here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b4d9ae6-cd60-5ba7-8702-01bb84098c81', 'b300ade6-5707-5502-a755-012849136ee3', 'Find the INCORRECT past deduction.', '[{"id":"a","text":"She must have forgotten the meeting — her diary shows it was today."},{"id":"b","text":"He can''t have read the report — he asked questions answered on page one."},{"id":"c","text":"They mustn''t have received the invitation — nobody RSVP''d."},{"id":"d","text":"We might have missed the announcement."}]'::jsonb, 'c', 'Option (c) is wrong: "mustn''t have" is not used for past deduction. To express near-certain negative in the past, use **can''t have** or **couldn''t have**: They can''t have received the invitation. Options (a), (b), and (d) correctly use must have (near-certain positive), can''t have (near-certain negative), and might have (possibility).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62491496-539b-54c5-aaf5-e8d5f6e67c48', 'b300ade6-5707-5502-a755-012849136ee3', 'Complete: "The archaeologists found pottery dating back 3,000 years. An advanced civilisation ___ existed here."', '[{"id":"a","text":"can''t have"},{"id":"b","text":"should have"},{"id":"c","text":"might have"},{"id":"d","text":"must have"}]'::jsonb, 'd', 'Concrete archaeological evidence (3,000-year-old pottery) strongly supports the conclusion: An advanced civilisation must have existed here. "Might have" is too weak for such strong evidence. "Can''t have" gives the opposite conclusion. "Should have" expresses what was expected or advisable — irrelevant to an archaeological deduction.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7041584-d2a2-52fe-b637-2cb53255fce2', 'b300ade6-5707-5502-a755-012849136ee3', 'Distinguish the uses: "She could have taken the express train." In which context does this express DEDUCTION (not reproach)?', '[{"id":"a","text":"She had a ticket but chose not to use it — I''m annoyed."},{"id":"b","text":"The express was running that day — it''s possible she was on it."},{"id":"c","text":"She had enough time to catch it but didn''t — what a waste!"},{"id":"d","text":"I told her about the express but she ignored me."}]'::jsonb, 'b', '"Could have" as deduction means: it was logically possible and may have happened. Context (b) — the express was running, we don''t know if she took it — is pure deduction (speculation about a past possibility). Contexts (a), (c), and (d) all imply annoyance or missed opportunity (she didn''t take it, and should have) — these use "could have" as a counterfactual reproach.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da4d03a8-413c-5490-85ec-e2f35543ab4b', 'b300ade6-5707-5502-a755-012849136ee3', 'Complete for a formal written report: "The discrepancy in the accounts ___ introduced during the audit process."', '[{"id":"a","text":"might have been"},{"id":"b","text":"must be"},{"id":"c","text":"may have been"},{"id":"d","text":"could be"}]'::jsonb, 'c', 'A formal written report about a past event (the audit process) uses the passive past deduction: may have been introduced. "May have" is the preferred formal register over "might have" in written/academic contexts. "Must be" is a present deduction — wrong for a past event. "Could be" is a present possibility — also wrong for past reference.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ce399c62-a827-5d48-ad09-1c77fcb58431', 'c6fee95d-7870-566a-842f-bbc5b2d0b46c', 'anglais-c1', '⚔️ Chapter Boss ⭐⭐⭐: Modals of Deduction', 3, 120, 30, 'boss', 'admin', 3)
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
  ('df7e9e40-c0f5-5514-8602-76881e88b123', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'Read: "The laboratory results came back negative. The scientist looks relieved."
Complete: "She ___ worried about the outcome."', '[{"id":"a","text":"must have been"},{"id":"b","text":"can''t have been"},{"id":"c","text":"should have been"},{"id":"d","text":"might be"}]'::jsonb, 'a', 'The scientist looks relieved after hearing results — relief is a natural response only if you were previously worried. The evidence strongly suggests past concern: She must have been worried. "Can''t have been" is near-certain negative — wrong, as relief implies prior worry. "Should have been" is about advisability. "Might be" is present tense — wrong for a past state.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed1f67de-8e59-5dad-a084-cbc8306aa4b4', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The suspect couldn''t have been at the scene — he was in another country."},{"id":"b","text":"She must have worked very hard to pass with such a high mark."},{"id":"c","text":"They might have forgotten to lock the door."},{"id":"d","text":"He mustn''t have understood the instructions — he got everything wrong."}]'::jsonb, 'd', 'Option (d) is wrong: "mustn''t have" is not standard for past negative deduction. The correct form is **can''t have** or **couldn''t have**: He can''t have understood the instructions. Options (a), (b), and (c) correctly use couldn''t have (impossibility), must have (near-certain positive), and might have (possibility).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82fa57ff-e6dd-5251-9d0c-09768721f10e', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'The professor hasn''t been seen since last Tuesday and her office is untouched. Choose the most appropriate pair of deductions.', '[{"id":"a","text":"She must have left suddenly; she can''t have planned it in advance."},{"id":"b","text":"She must have left suddenly; she must have planned it in advance."},{"id":"c","text":"She can''t have left; she might have planned a surprise."},{"id":"d","text":"She might have left; she couldn''t have stayed."}]'::jsonb, 'a', 'An untouched office (personal items still there) strongly suggests a sudden, unplanned departure: must have left suddenly (near-certain positive) + can''t have planned it (near-certain negative — an untouched office contradicts planning). Option (b) contradicts itself — sudden and planned together don''t fit. Option (c) contradicts the fact that she hasn''t been seen. Option (d) uses weak modals (might/couldn''t) that don''t match the strong evidence.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deb84189-9048-5b5f-85a6-df3696aff75b', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'Complete: "The engineers presented a flawless prototype. They ___ countless hours perfecting every detail."', '[{"id":"a","text":"could spend"},{"id":"b","text":"must spend"},{"id":"c","text":"must have spent"},{"id":"d","text":"had to have spent"}]'::jsonb, 'c', 'Past deduction from evidence (a flawless prototype) takes must have + past participle: must have spent countless hours. "Could spend" is a present possibility construction — wrong for past. "Must spend" is a present deduction — wrong tense. "Had to have spent" is not standard in English; the correct past obligation form is "had to spend" (not combined with have).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5c4328d-ad85-575f-9a1b-c3900c169a1a', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'Which sentence uses a modal of deduction correctly AND appropriately for the evidence given?', '[{"id":"a","text":"His fingerprints are on the weapon — he could have done it."},{"id":"b","text":"His fingerprints are on the weapon — he must have done it."},{"id":"c","text":"His fingerprints are on the weapon — he can''t have done it."},{"id":"d","text":"His fingerprints are on the weapon — he should have done it."}]'::jsonb, 'b', 'Physical forensic evidence (fingerprints on the weapon) is strong and points to a near-certain conclusion: he must have done it. Option (a) "could have" expresses mere logical possibility — too weak for fingerprint evidence. Option (c) "can''t have" is the opposite of what the evidence shows. Option (d) "should have" implies advice or expectation — irrelevant to forensic deduction.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f2f107d-7c03-557d-8f01-d3bafe9f9356', 'ce399c62-a827-5d48-ad09-1c77fcb58431', 'Read: "The ancient manuscript was written in a language no living person could speak. The scholars were baffled."
Complete: "Even the most experienced linguist ___ it without years of additional research."', '[{"id":"a","text":"might have translated"},{"id":"b","text":"must have translated"},{"id":"c","text":"could not have translated"},{"id":"d","text":"should not have translated"}]'::jsonb, 'c', 'A language no living person speaks makes translation practically impossible: couldn''t have translated (impossibility). "Might have" expresses possibility — contradicts the impossibility stated. "Must have translated" is near-certain positive — wrong, as even experts were baffled. "Should not have" expresses prohibition or inadvisability — irrelevant to an impossibility deduction.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f6f8e0d4-0247-5be5-85e8-ab5638aafc41', 'c6fee95d-7870-566a-842f-bbc5b2d0b46c', 'anglais-c1', '👑 Elite Challenge ⭐⭐⭐⭐: Modals of Deduction', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('f7ccc7eb-a6ed-553b-90b1-f5f308d7775b', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', 'Read: "The village was deserted. Every house was locked. Food was left half-eaten on tables. Animals roamed freely."

Choose ALL the valid deductions.', '[{"id":"a","text":"The inhabitants must have left in a hurry; they can''t have had time to prepare."},{"id":"b","text":"The inhabitants might have planned a festival and returned later."},{"id":"c","text":"The inhabitants couldn''t have left; someone must have locked the doors from outside."},{"id":"d","text":"The inhabitants must have left in a hurry; they might have been frightened."}]'::jsonb, 'd', 'Option (d) is the best pair: strong evidence (half-eaten food, animals loose) → must have left in a hurry (near-certain). The reason is uncertain → might have been frightened (speculation). Option (a) is close but "can''t have had time" is a stronger deduction while half-eaten food is strong but not conclusive about preparation. Option (b) contradicts "deserted" — a planned festival doesn''t leave food half-eaten. Option (c) contradicts the evidence — houses were locked, consistent with people locking up as they fled.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('165db028-2d99-5d3e-a6ca-286ee7b1290f', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', 'Find the error in reasoning: "The report was submitted at 11:58 p.m. The deadline was midnight. She must have not finished on time."', '[{"id":"a","text":"\"must have not\" should be \"mustn''t have\" — the contraction is wrong."},{"id":"b","text":"The modal contradicts the evidence — 11:58 p.m. is before midnight, so she DID finish on time. It should be \"She must have finished just in time.\""},{"id":"c","text":"The tense is wrong — it should be \"must not finish\" (present)."},{"id":"d","text":"\"must have not\" should be \"couldn''t have\" — the form is incorrect."}]'::jsonb, 'b', 'The logical error is in the conclusion: 11:58 p.m. is before the midnight deadline, so she DID submit on time. The deduction should be positive: She must have finished just in time. The reasoning is flawed — the evidence proves she met the deadline, yet the sentence claims the opposite. This tests whether you can identify both the grammar of modal deduction AND the logic of matching modal to evidence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfc98005-57ac-5996-bb46-9246e63419bf', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', 'Complete the formal incident report: "The fire alarm was triggered at 02:47. Given the absence of any visible fire, the activation ___ caused by a sensor malfunction."', '[{"id":"a","text":"must be"},{"id":"b","text":"may have been"},{"id":"c","text":"should have been"},{"id":"d","text":"had to be"}]'::jsonb, 'b', 'A formal incident report about a past event (the alarm triggered) that lacks certainty ("Given the absence of visible fire" implies we are inferring, not certain) uses the formal past possibility: may have been caused. "Must be" is present deduction — wrong for past. "Should have been" implies the malfunction was expected — not the intended meaning. "Had to be" suggests obligation — not a deduction.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1d6c022-0bfd-5cec-b81d-d0fcdd812cc4', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', 'Rank the deductions from most to least certain (strongest = near-certainty; weakest = mere possibility):
1. She must have known about the plan.
2. She could have known about the plan.
3. She can''t have known about the plan.
4. She might have known about the plan.

Which ranking is correct?', '[{"id":"a","text":"1 (most certain positive) → 4 → 2 → 3 (most certain negative)"},{"id":"b","text":"3 (most certain) → 1 → 4 → 2 (least certain)"},{"id":"c","text":"1 (most certain positive) → 2 → 4 → 3 (most certain negative)"},{"id":"d","text":"4 → 2 → 1 → 3"}]'::jsonb, 'a', 'Certainty scale: **must have** = near-certain YES (1) → **might have** = possible (4) → **could have** = logically possible/slightly more tentative (2) → **can''t have** = near-certain NO (3). The scale runs from near-certain positive through decreasing positive possibility to near-certain negative. Option (c) reverses the order of might/could — might is slightly stronger than could in terms of speaker commitment. Option (b) starts with the negative. Option (d) is random.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38283e2f-e797-50d1-8daf-0efe64839b58', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', 'Complete this detective''s reasoning in a formal report: "The victim''s phone showed a call made at 10:15 p.m. The coroner places time of death between 9:00 and 10:00 p.m. Therefore, the call ___ made by the victim."', '[{"id":"a","text":"might not have been"},{"id":"b","text":"can''t have been"},{"id":"c","text":"must not have been"},{"id":"d","text":"couldn''t be"}]'::jsonb, 'b', 'If death occurred between 9:00–10:00 p.m. and the call was at 10:15 p.m., it is logically impossible for the victim to have made that call: The call can''t have been made by the victim. "Might not have been" is too weak — the timeline makes it impossible, not just uncertain. "Must not have been" is not standard for past deduction of impossibility. "Couldn''t be" is present tense — wrong for this past forensic context.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e64db75d-d94f-5044-b2a1-f21a6bb339e0', 'f6f8e0d4-0247-5be5-85e8-ab5638aafc41', 'Read: "The document was stamped with yesterday''s date, but the director claims he signed it three weeks ago."

Which pair of deductions best captures the ambiguity?', '[{"id":"a","text":"The stamp must have been added yesterday; the director couldn''t have signed it three weeks ago."},{"id":"b","text":"The stamp might have been added later; the director may have signed it earlier and the stamp applied afterwards."},{"id":"c","text":"The director must have lied; the document can''t have been signed three weeks ago."},{"id":"d","text":"The document couldn''t have been stamped yesterday; the director must be correct."}]'::jsonb, 'b', 'A document conflict without further evidence calls for possibility modals, not certainty. Option (b) correctly uses might have been and may have to express two possible explanations without over-committing: the stamp might have been applied later, and the signing may have occurred earlier. Option (a) jumps to near-certainty — inappropriate when the evidence is genuinely ambiguous. Option (c) rushes to accuse the director — not supported by the available evidence alone. Option (d) wrongly dismisses the visible stamp evidence.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('26824ef0-9177-58d5-b124-3189a65d92d8', '205e7d4e-3de0-5dc9-be5e-e542f8f6c73e', 'anglais-c1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e5c1ffe0-98aa-585a-8638-6c0295aeb676', '26824ef0-9177-58d5-b124-3189a65d92d8', 'Choose the correct reduced form: "The student who is sitting at the front is the class president."', '[{"id":"a","text":"The student sat at the front is the class president."},{"id":"b","text":"The student sitting at the front is the class president."},{"id":"c","text":"The student to sit at the front is the class president."},{"id":"d","text":"The student having sat at the front is the class president."}]'::jsonb, 'b', 'An active relative clause (who is sitting) reduces to a present participle: sitting at the front. This is a reduced active relative — the student IS doing the sitting. Option (a) uses "sat" (past simple or past participle in passive) which implies a one-time completed action, not a current ongoing one. Option (c) uses to-infinitive, not a participle. Option (d) uses the perfect participle, implying a completed prior action.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18beb660-4372-5107-86f1-d4625f496f84', '26824ef0-9177-58d5-b124-3189a65d92d8', 'Identify the participle clause type: "Having completed her thesis, she celebrated with her family."', '[{"id":"a","text":"Present participle — simultaneous action"},{"id":"b","text":"Past participle — passive meaning"},{"id":"c","text":"Perfect participle — action completed before the main clause"},{"id":"d","text":"Reduced relative clause"}]'::jsonb, 'c', '"Having completed" = having + past participle = perfect participle clause. It signals that the thesis completion happened BEFORE the celebration. A present participle would be "Completing…" (simultaneous). A past participle for passive would be "Completed by her, …". A reduced relative would modify a noun directly.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aac62bee-8bed-5063-aa68-42d2350d8c2e', '26824ef0-9177-58d5-b124-3189a65d92d8', 'Find the DANGLING participle (incorrect sentence).', '[{"id":"a","text":"Running to catch the bus, he tripped on the kerb."},{"id":"b","text":"Exhausted by the journey, the team immediately went to sleep."},{"id":"c","text":"Walking along the seafront, the lighthouse came into view."},{"id":"d","text":"Having reviewed the files, the lawyer prepared her arguments."}]'::jsonb, 'c', 'Option (c) is a dangling participle: "Walking along the seafront" implies the lighthouse was walking — absurd. The subject of the main clause (the lighthouse) cannot walk. The correct version would be: "Walking along the seafront, **we** saw the lighthouse come into view." Options (a), (b), and (d) correctly share the participle clause subject with the main clause subject (he, the team, the lawyer).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e833c10-6333-531a-908b-297c7b16265d', '26824ef0-9177-58d5-b124-3189a65d92d8', 'Complete to show the first action: "___ the report, he emailed it to the board."', '[{"id":"a","text":"Finishing"},{"id":"b","text":"Having finished"},{"id":"c","text":"Having been finished"},{"id":"d","text":"Being finished"}]'::jsonb, 'b', 'He finished the report FIRST, then emailed it. To show that the participle clause action came before the main clause, use having + past participle: Having finished the report, he emailed it. "Finishing" (present participle) would imply both actions were simultaneous. "Having been finished" is passive perfect — the report didn''t finish itself. "Being finished" is a passive continuous — wrong here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e72ea47-4ff1-5808-b834-50eb5da3253e', '26824ef0-9177-58d5-b124-3189a65d92d8', 'What is the function of the participle clause in: "Not knowing what to do, she called her mentor"?', '[{"id":"a","text":"It shows an action that happened after calling the mentor."},{"id":"b","text":"It expresses the reason for calling the mentor."},{"id":"c","text":"It reduces a passive relative clause."},{"id":"d","text":"It describes a completed action that came before calling."}]'::jsonb, 'b', '"Not knowing what to do" is a present participle clause expressing REASON: because she didn''t know what to do, she called her mentor. It is not a sequence (not before or after), so (a) and (d) are wrong. It is not a reduced relative (it doesn''t modify a noun with ''who/which'') — so (c) is wrong.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', '205e7d4e-3de0-5dc9-be5e-e542f8f6c73e', 'anglais-c1', '⭐ Practice: Recognising & Forming Participle Clauses', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e28cb80f-0969-5fd8-9b4d-e1703123493d', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', 'Reduce the relative clause: "The report that was submitted yesterday was full of errors."', '[{"id":"a","text":"The report submitting yesterday was full of errors."},{"id":"b","text":"The report submitted yesterday was full of errors."},{"id":"c","text":"The report having submitted yesterday was full of errors."},{"id":"d","text":"The report to submit yesterday was full of errors."}]'::jsonb, 'b', '"That was submitted" is a passive relative clause — it reduces to a past participle: submitted yesterday. The past participle carries the passive meaning (the report was submitted by someone). Option (a) uses the active present participle — wrong, as the report doesn''t submit itself. Option (c) uses the perfect participle, which implies the action is completed before the noun''s time frame in a specific narrative way — too complex here. Option (d) uses to-infinitive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('755ee148-3ebc-583f-95c1-c3e4bcdfef19', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', 'Identify the type: "Exhausted after the race, the runner collapsed at the finish line."', '[{"id":"a","text":"Present participle clause — simultaneous action"},{"id":"b","text":"Past participle clause — reason/condition"},{"id":"c","text":"Perfect participle clause — prior action"},{"id":"d","text":"Reduced active relative clause"}]'::jsonb, 'b', '"Exhausted" is a past participle used adverbially to express reason/cause: because she was exhausted, she collapsed. This is an adverbial past participle clause (not a relative clause — it doesn''t modify a noun with who/which). Option (a) is wrong: "exhausted" is not an -ing form. Option (c) is wrong: there is no "having" and no sequence of two past actions. Option (d) would need a noun it modifies (e.g., "the runner exhausted after the race").', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af4c1860-50ef-5d18-aa71-16846fe8b8a7', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', 'Complete: "___ the question carefully before answering, she avoided any misunderstanding."', '[{"id":"a","text":"Having read"},{"id":"b","text":"Read"},{"id":"c","text":"Reading"},{"id":"d","text":"To read"}]'::jsonb, 'a', 'She READ the question FIRST, then answered — two sequential actions. Use having + past participle to show the first action: Having read the question carefully before answering. Option (c) "Reading" (present participle) would imply she read and answered simultaneously, which contradicts "before answering". Option (b) "Read" without "having" is not a standard adverbial participle here. Option (d) "To read" is a to-infinitive clause, not a participle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ebdc88e-e934-5837-99b0-8cc1809cb399', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', 'Choose the correctly formed present participle clause.', '[{"id":"a","text":"Singing loudly, the concert enjoyed by the audience."},{"id":"b","text":"Singing loudly, the crowd was delighted by the performer."},{"id":"c","text":"Singing loudly, the performer delighted the crowd."},{"id":"d","text":"The performer, singing loudly, was delighted the crowd."}]'::jsonb, 'c', 'The performer is singing — so the main clause subject must be the performer: Singing loudly, the performer delighted the crowd. Option (a) is a dangling participle (the concert isn''t singing). Option (b) says the crowd was delighted — but then the crowd must be singing, which is not the intended meaning. Option (d) has an extra "was" making it ungrammatical.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40f2af05-353d-56da-a2db-cb77c26236e6', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', 'Reduce: "The manuscript which was discovered in a cave in 1947 changed our understanding of history."', '[{"id":"a","text":"The manuscript discovering in a cave in 1947 changed our understanding of history."},{"id":"b","text":"The manuscript to discover in a cave in 1947 changed our understanding of history."},{"id":"c","text":"The manuscript discovered in a cave in 1947 changed our understanding of history."},{"id":"d","text":"The manuscript having discovered in a cave in 1947 changed our understanding of history."}]'::jsonb, 'c', '"Which was discovered" is a passive relative clause → past participle: the manuscript **discovered** in a cave in 1947. Past participles carry the passive sense (it was discovered by someone). Option (a) uses the present participle — wrong, as the manuscript doesn''t discover anything. Option (b) uses to-infinitive. Option (d) uses the perfect participle form but incorrectly — "having discovered" would imply the manuscript discovered something.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bbd73d51-5536-5ca7-8810-b89395e30a34', '2ebcf3d9-e12f-5c51-a718-48e61e8e7f13', 'What does the participle clause express in: "The company, having lost three major contracts, restructured its management team"?', '[{"id":"a","text":"A future condition"},{"id":"b","text":"A simultaneous action"},{"id":"c","text":"A prior cause leading to the main clause"},{"id":"d","text":"A passive meaning — the contracts lost the company"}]'::jsonb, 'c', '"Having lost three major contracts" uses the perfect participle (having + pp) — the loss happened BEFORE and CAUSED the restructuring: because the company had lost…, it restructured. This expresses a prior cause. It is not future (a), not simultaneous (b — that would be the present participle), and not passive (d — the company lost the contracts, not the other way round).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('376db3ce-b07c-50e0-8a09-652026bc9d25', '205e7d4e-3de0-5dc9-be5e-e542f8f6c73e', 'anglais-c1', '⭐⭐ Review: Participle Clauses — Functions & Errors', 2, 75, 15, 'practice', 'admin', 2)
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
  ('ae35481b-bb12-5f2f-b4e5-c1f86e8fb6c6', '376db3ce-b07c-50e0-8a09-652026bc9d25', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Having secured the funding, the researchers began their experiments."},{"id":"b","text":"Damaged by the flood, the building was condemned."},{"id":"c","text":"Arriving at the hotel, our luggage was lost."},{"id":"d","text":"Feeling nervous, he took a deep breath before speaking."}]'::jsonb, 'c', 'Option (c) is a dangling participle: "Arriving at the hotel" implies the luggage was arriving, which is impossible — the luggage doesn''t arrive on its own. Correct: Arriving at the hotel, **we found that** our luggage had been lost. Options (a), (b), and (d) correctly match the participle subject with the main clause subject (researchers, building, he).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5440951-9d87-505b-a8bf-232e834aaf76', '376db3ce-b07c-50e0-8a09-652026bc9d25', 'Choose the form that best shows the FIRST action: "She graduated last year. She is now working as an engineer."', '[{"id":"a","text":"Graduating last year, she is now working as an engineer."},{"id":"b","text":"To graduate last year, she is now working as an engineer."},{"id":"c","text":"Graduated last year, she is now working as an engineer."},{"id":"d","text":"Having graduated last year, she is now working as an engineer."}]'::jsonb, 'd', 'Graduation happened first; working as an engineer is the current state. Use having + past participle to signal the prior action: Having graduated last year, she is now working as an engineer. Option (a) uses the present participle — implies simultaneous action (graduating AND working at the same time), which doesn''t match "last year". Option (c) "Graduated" alone as a fronted past participle implies she was graduated by someone — passive meaning, awkward here. Option (b) uses to-infinitive — wrong for this sequence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed2e9092-141a-521a-991a-c8f3eb705e30', '376db3ce-b07c-50e0-8a09-652026bc9d25', 'Which sentence correctly uses a present participle clause to express reason?', '[{"id":"a","text":"Knowing the answer, the question was left for others."},{"id":"b","text":"Not understanding the instructions, she asked for clarification."},{"id":"c","text":"Understanding the answer, it was obvious what to do."},{"id":"d","text":"Knowing his way around, the map was unnecessary for him."}]'::jsonb, 'b', 'Option (b) is correct: "Not understanding the instructions" shares its subject with the main clause (she) — she didn''t understand, so she asked. Option (a): "Knowing the answer" implies the question knew the answer — dangling participle. Option (c): "Understanding the answer" implies "it" understood — dangling. Option (d): "Knowing his way around" implies the map knew its way — dangling.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ff5498b-325e-5450-b1b2-887d3718af5b', '376db3ce-b07c-50e0-8a09-652026bc9d25', 'Reduce: "The policy, which had been challenged repeatedly, was finally revised."', '[{"id":"a","text":"The policy, having challenging repeatedly, was finally revised."},{"id":"b","text":"The policy, challenged repeatedly, was finally revised."},{"id":"c","text":"The policy, challenging repeatedly, was finally revised."},{"id":"d","text":"The policy, being challenged repeatedly, was finally revised."}]'::jsonb, 'b', '"Which had been challenged" is a passive relative clause — it reduces to a past participle: challenged repeatedly. Option (a) has an incorrect form (having + base verb instead of having + past participle). Option (c) uses the present active participle — wrong, the policy doesn''t challenge anything. Option (d) uses the present passive (being challenged) which implies ongoing action — changes the nuance and tense.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('caed52bc-b3dc-54eb-b49c-d7079f325dc1', '376db3ce-b07c-50e0-8a09-652026bc9d25', 'Complete: "___ with years of experience in diplomacy, the ambassador handled the crisis with remarkable calm."', '[{"id":"a","text":"Armed"},{"id":"b","text":"Arming"},{"id":"c","text":"Having arming"},{"id":"d","text":"To arm"}]'::jsonb, 'a', '"Armed with years of experience" is a past participle clause expressing reason/manner — because she was armed (equipped/endowed) with experience. The past participle carries a passive/stative sense: she was armed by her experience. Option (b) "Arming" (present active) would mean she was actively arming herself at that moment — wrong. Option (c) "Having arming" is not a valid grammatical form. Option (d) is a to-infinitive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9cb7b9e-89f5-510b-b996-c5375aacfdbf', '376db3ce-b07c-50e0-8a09-652026bc9d25', 'Read: "She worked for twelve hours straight. She finally presented the solution." Choose the best single-sentence reduction using a participle clause.', '[{"id":"a","text":"Working for twelve hours straight, she finally presented the solution."},{"id":"b","text":"Having worked for twelve hours straight, she finally presented the solution."},{"id":"c","text":"Worked for twelve hours straight, she finally presented the solution."},{"id":"d","text":"Being worked for twelve hours straight, she finally presented the solution."}]'::jsonb, 'b', 'The twelve hours of work came FIRST, and presenting the solution is the result. Use having + past participle: Having worked for twelve hours straight, she finally presented the solution. Option (a) "Working" (present participle) implies she presented the solution WHILE working — not the intended sequence. Option (c) "Worked" alone as a fronted past participle is passive — implies she was worked by someone. Option (d) "Being worked" is a passive continuous — not natural here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('21d5af2a-0996-51bc-b863-c68f475eff88', '205e7d4e-3de0-5dc9-be5e-e542f8f6c73e', 'anglais-c1', '⚔️ Chapter Boss ⭐⭐⭐: Participle Clauses', 3, 120, 30, 'boss', 'admin', 3)
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
  ('b6f08d42-22f3-5fab-9fff-78b0b2075de5', '21d5af2a-0996-51bc-b863-c68f475eff88', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Having read the report, she outlined her recommendations."},{"id":"b","text":"The bridge built in 1902 still carries heavy traffic."},{"id":"c","text":"Walking past the stadium, the cheering of the crowd could be heard."},{"id":"d","text":"Not knowing what to expect, the delegates arrived early."}]'::jsonb, 'c', 'Option (c) is a dangling participle: "Walking past the stadium" implies the cheering was walking — impossible. The subject of the main clause (the cheering of the crowd) cannot perform the walking. Correct version: Walking past the stadium, **the delegates** could hear the crowd cheering. Options (a), (b), and (d) are all correctly formed participle clauses with matching subjects.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14c021af-6800-55a3-8eb6-2bbac1c71fd1', '21d5af2a-0996-51bc-b863-c68f475eff88', 'Choose the best reduction for a formal report: "The evidence was analysed by the forensic team. They then published their findings."', '[{"id":"a","text":"Analysing the evidence, their findings were published."},{"id":"b","text":"The forensic team, having analysed the evidence, published their findings."},{"id":"c","text":"Analysed by the forensic team, they published their findings."},{"id":"d","text":"The forensic team analysing the evidence, their findings were published."}]'::jsonb, 'b', 'Option (b) is correct: the forensic team first analysed (having + past participle — prior action), then published. Subject is consistent (the forensic team). Option (a) is a dangling participle — "their findings" cannot analyse. Option (c) is also dangling — "they" (the team) are not the ones being analysed. Option (d) is an absolute participle clause (different subject) — possible in some contexts but awkward and ambiguous here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('705720fa-e2fb-5e46-83c4-daa54c623c7d', '21d5af2a-0996-51bc-b863-c68f475eff88', 'Which reduction correctly preserves the meaning of: "The children who were left unsupervised caused significant damage"?', '[{"id":"a","text":"The children leaving unsupervised caused significant damage."},{"id":"b","text":"The children left unsupervised caused significant damage."},{"id":"c","text":"The children having left unsupervised caused significant damage."},{"id":"d","text":"The children to leave unsupervised caused significant damage."}]'::jsonb, 'b', '"Who were left unsupervised" is a passive relative clause → past participle: the children **left** unsupervised. The past participle retains the passive meaning (they were left, not they left). Option (a) "leaving" (active present participle) implies the children left of their own accord — different meaning. Option (c) "having left" uses the perfect participle — awkward and changes the nuance. Option (d) is a to-infinitive, changing the meaning further.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0af78207-30fc-58b3-b2f7-047299bde1f8', '21d5af2a-0996-51bc-b863-c68f475eff88', 'Identify the function of the participle clause in: "The treaty, signed by all parties in 1945, reshaped the post-war world."', '[{"id":"a","text":"Reduced passive relative clause giving additional information about the treaty"},{"id":"b","text":"Perfect participle clause expressing a prior action"},{"id":"c","text":"Present participle clause expressing simultaneous action"},{"id":"d","text":"Adverbial past participle clause expressing reason"}]'::jsonb, 'a', '"Signed by all parties in 1945" is a reduced non-defining relative clause: it adds information about the treaty (which was signed by all parties in 1945). It is non-defining (set off by commas). Option (c) is wrong — "signed" is not an -ing form. Option (b) is wrong — the perfect participle uses "having + pp", not a bare past participle. Option (d) is wrong — the clause modifies the noun (the treaty), not the whole main verb action.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e03b215-e24c-583d-af37-a4bca9dc3424', '21d5af2a-0996-51bc-b863-c68f475eff88', 'Complete with the correct participle form: "___ in the 15th century, the palace contains priceless works of art."', '[{"id":"a","text":"Building"},{"id":"b","text":"Being built"},{"id":"c","text":"Having built"},{"id":"d","text":"Built"}]'::jsonb, 'd', '"Built in the 15th century" is a past participle adverbial clause expressing time/concession — meaning "(although it was) built in the 15th century". The past participle carries the passive sense. Option (a) "Building" is active — implies the palace is building something. Option (c) "Having built" implies the palace actively built something in the past. Option (b) "Being built" is passive continuous — implies it is currently under construction, contradicting "15th century".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5af01d9-e392-551c-a7c7-9bbadd5ae4c6', '21d5af2a-0996-51bc-b863-c68f475eff88', 'Read: "The investigation concluded. The jury delivered a unanimous verdict."
Which single sentence BEST preserves both the sequence and the formal register?', '[{"id":"a","text":"The investigation concluding, the jury delivered a unanimous verdict."},{"id":"b","text":"Concluding the investigation, a unanimous verdict was delivered."},{"id":"c","text":"Having concluded the investigation, the jury delivered a unanimous verdict."},{"id":"d","text":"The jury concluded the investigation, delivering a unanimous verdict."}]'::jsonb, 'c', 'The investigation concluded FIRST, then the verdict was delivered. Use having + past participle for the prior action: Having concluded the investigation, the jury delivered a unanimous verdict. The subject (the jury) is consistent. Option (a) uses present participle "concluding" — implies both actions are simultaneous. Option (b) is a dangling participle — "a unanimous verdict" cannot conclude the investigation. Option (d) changes the sentence structure so the jury concluded the investigation AND delivered the verdict simultaneously as narrative events — alters the sequence emphasis.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('facff044-ea2c-5006-bacc-2dc702176ca2', '205e7d4e-3de0-5dc9-be5e-e542f8f6c73e', 'anglais-c1', '👑 Elite Challenge ⭐⭐⭐⭐: Participle Clauses', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d7ab78df-1532-56ab-9048-c396d4f529ac', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'Read: "The commission examined the data for months. They published a landmark report. Their findings changed policy across the continent."

Which single sentence best reduces all three using participle clauses?', '[{"id":"a","text":"Having examined the data for months and published a landmark report, the commission changed policy across the continent with their findings."},{"id":"b","text":"Examining the data for months, the commission published a landmark report, changing policy across the continent."},{"id":"c","text":"Having examined the data for months, the commission published a landmark report, changing policy across the continent."},{"id":"d","text":"The data having been examined, the commission published a landmark report changing the continent''s policy."}]'::jsonb, 'c', 'Option (c) correctly uses having examined for the prior action (months of examination came first), then the simple past (published) for the main event, then changing (present participle) for the immediate result. Option (b) uses "Examining" (present participle) which wrongly implies simultaneous examination and publication. Option (a) tries to compress too much into the perfect participle — "having published" would work but "with their findings" is loose. Option (d) uses an absolute clause ("the data having been examined") — grammatical but awkward here, and "the continent''s policy" is imprecise.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb00aa41-6026-597e-974a-2f2619d83d0d', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'Find the error in this formal passage: "Written in the margins of ancient manuscripts, scholars often discover important historical clues."', '[{"id":"a","text":"\"Written\" should be \"Writing\" — active participle is needed."},{"id":"b","text":"This is a dangling participle — the scholars did not write the notes; the clues or notes were written. The subject of the main clause must match."},{"id":"c","text":"\"often discover\" should be in the past tense — \"often discovered\"."},{"id":"d","text":"There is no error — \"Written in the margins\" correctly modifies \"scholars\"."}]'::jsonb, 'b', 'The sentence says "Written in the margins of ancient manuscripts, scholars often discover…" — but the scholars didn''t write the notes. The past participle "Written" refers to the notes/clues, not the scholars. Correct version: "Written in the margins of ancient manuscripts, **the clues** often help scholars discover historical details." This is a classic dangling participle error in formal prose.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a49559d1-1327-5bdc-b718-d2cc60e7a11c', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'Choose the sentence that correctly uses a participle clause to compress BOTH a condition AND a result.', '[{"id":"a","text":"Left unattended, the fire spread rapidly through the building."},{"id":"b","text":"Having left unattended, the fire spread rapidly through the building."},{"id":"c","text":"Leaving unattended, the fire spread rapidly through the building."},{"id":"d","text":"Being left unattended, it caused the fire to spread rapidly."}]'::jsonb, 'a', '"Left unattended" is a past participle clause expressing condition (= if left / because it was left unattended): Left unattended, the fire spread rapidly. The fire was left (passive) — past participle is correct. Option (b) "Having left" implies the fire actively left something — wrong, and changes the meaning. Option (c) "Leaving" is active present participle — the fire didn''t leave anything unattended. Option (d) shifts the fire to a pronoun (it) and adds a passive restructure that is awkward and unclear.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef857088-ad1a-5d39-844d-fc7bc72efe7e', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'Complete this literary sentence: "___ the summit after three days of climbing, the mountaineer surveyed the world below with quiet pride."', '[{"id":"a","text":"Reaching"},{"id":"b","text":"Reached"},{"id":"c","text":"Having reached"},{"id":"d","text":"To reach"}]'::jsonb, 'c', 'Three days of climbing culminated in reaching the summit — this happened FIRST, then she surveyed the world. Use having + past participle for the completed prior action: Having reached the summit… Option (a) "Reaching" implies she reached the summit and surveyed at the same moment — less precise for this narrative. Option (b) "Reached" as a bare past participle here would imply a passive: "The summit being reached" — not what is intended (she reached it actively). Option (d) is a to-infinitive — used for purpose or result, not sequence.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d83858c6-288b-542a-80ea-c50a84b06caa', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'Which sentence most effectively reduces this paragraph for a formal report? "The committee identified three critical gaps. It recommended urgent action. The recommendations were adopted by the board."', '[{"id":"a","text":"Having identified three critical gaps and recommended urgent action, the committee''s recommendations were adopted by the board."},{"id":"b","text":"Identifying three critical gaps, the committee recommended urgent action, which was adopted by the board."},{"id":"c","text":"Having identified three critical gaps, the committee recommended urgent action, its recommendations subsequently adopted by the board."},{"id":"d","text":"Having identified three critical gaps, the committee recommended urgent action, having been adopted by the board."}]'::jsonb, 'c', 'Option (c) is the most elegant and correct: having identified (prior action) → recommended (main action) → its recommendations subsequently adopted by the board (absolute participle clause using the passive past participle "adopted" with a different subject "its recommendations"). This correctly handles the change of subject for the adoption step. Option (a) creates a dangling issue — "the committee''s recommendations were adopted" after a clause about the committee makes the committee the implicit subject of the passive — awkward. Option (b) uses "identifying" (simultaneous) but the identification came before the recommendation. Option (d) misapplies "having been adopted" — this implies the committee was adopted, not the recommendations.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49416109-f7b1-5386-ac1c-8492bb81fdc9', 'facff044-ea2c-5006-bacc-2dc702176ca2', 'Read: "The species was thought to be extinct. Researchers rediscovered it in a remote valley in 2019."

Which sentence best reduces the first clause as a participle and maintains formal register?', '[{"id":"a","text":"Thinking to be extinct, researchers rediscovered the species in a remote valley in 2019."},{"id":"b","text":"Thought to be extinct, the species was rediscovered by researchers in a remote valley in 2019."},{"id":"c","text":"Having thought to be extinct, the species was rediscovered by researchers in 2019."},{"id":"d","text":"Being thought extinct, researchers made the rediscovery in a remote valley in 2019."}]'::jsonb, 'b', '"Was thought to be extinct" is a passive clause — it reduces to a past participle: Thought to be extinct, the species… The subject of the main clause (the species) matches what was thought to be extinct. Option (a) is dangling: "Thinking to be extinct" implies the researchers thought themselves to be extinct — absurd. Option (c) "Having thought" implies the species did the thinking — wrong subject. Option (d) is dangling: "Being thought extinct" should modify the species, but the main clause makes researchers the subject.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', '6d77d1ef-a1fa-5f50-98d6-c50dcb5685a1', 'anglais-c1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('a178c709-2d87-5051-a3ec-994f10b877ea', 'f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', 'Complete: "The experiment was a success. ___, the results were far better than expected."', '[{"id":"a","text":"Nevertheless"},{"id":"b","text":"However"},{"id":"c","text":"In fact"},{"id":"d","text":"Whereas"}]'::jsonb, 'c', '"In fact" introduces information that reinforces or intensifies what was just said — the results being even better than expected amplifies the success. "Nevertheless" and "However" signal contrast or concession — inappropriate when the second sentence agrees with and strengthens the first. "Whereas" joins two contrasting clauses in a single sentence — cannot begin a new sentence here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d6fa561-44ef-5058-bd74-ae7c311cf6b8', 'f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', 'Complete: "___ the rising costs, the project was completed on time."', '[{"id":"a","text":"Despite"},{"id":"b","text":"However"},{"id":"c","text":"Nevertheless"},{"id":"d","text":"Although"}]'::jsonb, 'a', '"Despite" is followed by a noun phrase (the rising costs) — correct. "However" and "Nevertheless" require a full clause (subject + verb) — they cannot precede a bare noun phrase. "Although" is a subordinating conjunction that must be followed by a full clause: Although costs rose, the project was completed on time. The prompt only has a noun phrase, so "Although" does not fit.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b323f6e4-353a-5127-9879-dacbfeab9b18', 'f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The north prospered, whereas the south struggled."},{"id":"b","text":"The plan was risky; nevertheless, they proceeded."},{"id":"c","text":"Despite she was tired, she finished the work."},{"id":"d","text":"The report was delayed; consequently, the meeting was postponed."}]'::jsonb, 'c', 'Option (c) is wrong: "Despite" cannot be followed by a finite clause (she was tired). Use "Despite being tired" or "Despite her tiredness" or "Although she was tired". Options (a), (b), and (d) correctly use whereas (contrast, one sentence), nevertheless (concession, full clause), and consequently (result).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27686367-74b1-56fb-be0e-4f42e0029d02', 'f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', 'Complete: "The new system cut processing time by 40%, ___ saving the company thousands of hours annually."', '[{"id":"a","text":"thereby"},{"id":"b","text":"thus"},{"id":"c","text":"therefore"},{"id":"d","text":"so"}]'::jsonb, 'a', '"Thereby" is followed by a present participle (-ing): thereby **saving** the company… It expresses a result embedded in the same clause. "Thus", "therefore", and "so" all introduce a new full clause (subject + verb) — they do not directly precede a bare -ing verb without a subject.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5cac790-8140-5e70-8afc-7cf028aad25a', 'f78ad2b9-76a8-5588-ad02-e6ed0ceaf3f4', 'Choose the sentence where ''on the contrary'' is used CORRECTLY.', '[{"id":"a","text":"Exports grew by 8%. On the contrary, imports declined."},{"id":"b","text":"\"Was the speech well received?\" — \"On the contrary, it caused an outcry.\""},{"id":"c","text":"The economy improved last year. On the contrary, unemployment fell."},{"id":"d","text":"Wages rose in the private sector. On the contrary, they stagnated in the public sector."}]'::jsonb, 'b', '"On the contrary" specifically DENIES the previous statement and asserts the opposite. In option (b), someone implies the speech was well received; the reply denies this entirely. Options (a), (c), and (d) use it to add a contrasting or additional point — for those, use "by contrast", "however", or "whereas" instead. On the contrary ≠ a general contrast marker.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9c67eb14-3080-544a-94cd-76cf83e94501', '6d77d1ef-a1fa-5f50-98d6-c50dcb5685a1', 'anglais-c1', '⭐ Practice: Identifying Discourse Markers & Their Functions', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d7494b5a-e798-591e-b2a6-93351670462b', '9c67eb14-3080-544a-94cd-76cf83e94501', 'What relationship does ''moreover'' express?', '[{"id":"a","text":"Contrast — it introduces an opposing idea."},{"id":"b","text":"Addition — it adds a supporting or stronger point."},{"id":"c","text":"Result — it signals a consequence."},{"id":"d","text":"Concession — it acknowledges a counterpoint."}]'::jsonb, 'b', '"Moreover" signals addition — it introduces a further point that supports or strengthens what was just said: The plan is affordable; moreover, it is efficient. It is more formal than "also" or "and". It does not introduce contrast (however/whereas), result (therefore/thus), or concession (nevertheless/albeit).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd4fa524-f8cb-5e8d-9bd7-fa9a2c9ee19b', '9c67eb14-3080-544a-94cd-76cf83e94501', 'Complete: "She studied for months. ___, she passed the exam with distinction."', '[{"id":"a","text":"However"},{"id":"b","text":"Nevertheless"},{"id":"c","text":"Consequently"},{"id":"d","text":"Whereas"}]'::jsonb, 'c', 'Studying for months caused her to pass — a logical result: Consequently, she passed. "However" and "Nevertheless" signal contrast/concession — a contradiction or override. "Whereas" introduces contrast between two different things in a single sentence — not appropriate for two separate sentences expressing a cause-effect chain.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('402de86d-1e2d-5f08-be27-2fab460eaf56', '9c67eb14-3080-544a-94cd-76cf83e94501', 'Choose the correct sentence with ''whereas''.', '[{"id":"a","text":"He preferred tea. Whereas she preferred coffee."},{"id":"b","text":"He preferred tea, whereas she preferred coffee."},{"id":"c","text":"Whereas. He preferred tea; she preferred coffee."},{"id":"d","text":"He preferred tea whereas. She preferred coffee."}]'::jsonb, 'b', '"Whereas" is a subordinating conjunction — it must join two clauses IN ONE SENTENCE: He preferred tea, whereas she preferred coffee. It cannot begin a new sentence on its own (a), cannot stand alone with a full stop after it (c), and cannot appear at the end of a clause followed by a full stop (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b1b1e51-da5e-5148-8bd7-794954619d0f', '9c67eb14-3080-544a-94cd-76cf83e94501', 'Complete: "___ in spite of their fears, the volunteers entered the building."', '[{"id":"a","text":"However"},{"id":"b","text":"Despite"},{"id":"c","text":"Although"},{"id":"d","text":"(no connector needed — ''in spite of'' is the connector)"}]'::jsonb, 'd', '"In spite of" is already a prepositional phrase acting as the concessive connector: In spite of their fears, the volunteers entered the building. No additional connector is needed before it. Adding "However", "Despite" (redundant), or "Although" (which needs a full clause) would create a double connector and a grammatical error.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80584e53-436d-51be-b7e2-d2d540b124ac', '9c67eb14-3080-544a-94cd-76cf83e94501', 'What does ''albeit'' mean in: "The policy was effective, albeit controversial"?', '[{"id":"a","text":"As a result of being controversial"},{"id":"b","text":"Even though it was controversial"},{"id":"c","text":"Which means it was controversial"},{"id":"d","text":"And furthermore it was controversial"}]'::jsonb, 'b', '"Albeit" means "even though" or "although" — it introduces a concessive qualification: effective, even though controversial. It acknowledges the drawback while the main clause (effective) stands. Option (a) would be a result (because of). Option (c) would be a clarification (namely/that is). Option (d) would be an addition (moreover).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb4eb2b5-a6fc-59b3-a0eb-f22e329fba11', '9c67eb14-3080-544a-94cd-76cf83e94501', 'Find the INCORRECT use of a discourse marker.', '[{"id":"a","text":"The team worked efficiently; hence, the project was completed early."},{"id":"b","text":"The results were mixed; nevertheless, the board approved the proposal."},{"id":"c","text":"He improved the software, thereby increasing user satisfaction."},{"id":"d","text":"She failed the test. Furthermore, she didn''t study enough."}]'::jsonb, 'd', 'Option (d) has the wrong marker: "Furthermore" adds a supporting point — but "she didn''t study enough" explains WHY she failed; it is a cause/reason, not an additional point. A better marker would be "Besides" or a causal connector like "She failed the test, perhaps because she hadn''t studied enough." Options (a), (b), and (c) correctly use hence (result), nevertheless (concession), and thereby + -ing (result embedded in clause).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3b3ead1d-76ba-5215-9de2-94aee0763ec4', '6d77d1ef-a1fa-5f50-98d6-c50dcb5685a1', 'anglais-c1', '⭐⭐ Review: Contrast, Concession & Result in Context', 2, 75, 15, 'practice', 'admin', 2)
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
  ('2f3f1ebe-fcdb-51b2-842c-d4da92fbb9fc', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Despite the economic downturn, sales remained strong."},{"id":"b","text":"Despite the fact that profits fell, the company survived."},{"id":"c","text":"Despite profits fell, the company survived."},{"id":"d","text":"Despite falling profits, the company survived."}]'::jsonb, 'c', 'Option (c) is wrong: "Despite" cannot be followed directly by a subject + verb (profits fell). After "Despite" use a noun phrase (option d) or "the fact that" + clause (option b) or a gerund: Despite falling profits. Options (a), (b), and (d) are all grammatically correct — three valid ways to use "despite" before different noun/clause types.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a6db2a0-a49c-5f30-8c9b-1ef3b02955c6', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', 'Complete: "The negotiations were tense. ___, both parties reached an agreement by midnight."', '[{"id":"a","text":"Therefore"},{"id":"b","text":"Consequently"},{"id":"c","text":"Nevertheless"},{"id":"d","text":"Moreover"}]'::jsonb, 'c', 'The second sentence concedes that despite tense negotiations, an agreement was reached — a concessive relationship (even so / despite that). "Nevertheless" is correct. "Therefore" and "Consequently" signal a result — but reaching an agreement because of tension doesn''t make logical sense. "Moreover" adds a supporting point, not a concessive one.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1336e70-a9d6-5ca6-a3fe-239beaf949f3', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', 'Choose the most appropriate discourse marker: "The first draft was rough. ___, it contained the core of an excellent idea."', '[{"id":"a","text":"Furthermore"},{"id":"b","text":"Nonetheless"},{"id":"c","text":"Consequently"},{"id":"d","text":"Namely"}]'::jsonb, 'b', 'The second sentence concedes that despite being rough, it had value — a classic concession: Nonetheless, it contained the core of an excellent idea. "Furthermore" adds a point in the same direction as the first — wrong here since the second point contrasts with the first. "Consequently" signals a result (roughness caused the good idea? — illogical). "Namely" introduces a specification or clarification — not applicable here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27a37b34-6b13-52da-90e1-7122cba0c830', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', 'Complete: "The algorithm was streamlined, ___ reducing processing time by half."', '[{"id":"a","text":"thus"},{"id":"b","text":"therefore"},{"id":"c","text":"thereby"},{"id":"d","text":"consequently"}]'::jsonb, 'c', '"Thereby" + present participle (-ing) is used to embed a result in the same clause: thereby reducing processing time. "Thus", "therefore", and "consequently" all need to introduce a new clause with a subject + verb — they cannot precede a bare -ing verb without a subject. Compare: The algorithm was streamlined; **thus**, processing time was reduced by half (full clause with thus).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebbed417-ee0a-58e9-b51b-4174da2862a4', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', 'Which sentence correctly distinguishes ''on the contrary'' from ''by contrast''?', '[{"id":"a","text":"I didn''t dislike the film. On the contrary, I hated it. | Exports grew. By contrast, imports fell."},{"id":"b","text":"I hated the film. On the contrary, the soundtrack was excellent. | Exports grew. By contrast, it was a great year."},{"id":"c","text":"I didn''t dislike the film. By contrast, I hated it. | Exports grew. On the contrary, imports fell."},{"id":"d","text":"I loved the film. On the contrary, the reviews were mixed. | Exports grew. By contrast, the economy improved."}]'::jsonb, 'a', 'Option (a) uses both markers correctly: "On the contrary, I hated it" DENIES the implied claim (that the speaker didn''t strongly dislike it) — on the contrary = denial. "By contrast, imports fell" introduces a parallel opposite without denial — exports and imports are two different things being compared. Option (c) reverses them. Option (b) uses on the contrary to add a separate point about the soundtrack — not a denial. Option (d) uses on the contrary when there is no clear denial being made.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6c6b3c9-0b52-5dd1-add6-148b05a1c1ed', '3b3ead1d-76ba-5215-9de2-94aee0763ec4', 'Complete this academic paragraph for maximum formal register and cohesion: "The study yielded significant results. ___, some limitations must be acknowledged. The sample size was small, ___ meaning the findings cannot be generalised."', '[{"id":"a","text":"However … thereby"},{"id":"b","text":"But … so"},{"id":"c","text":"Nevertheless … thereby"},{"id":"d","text":"Although … thus"}]'::jsonb, 'a', '"However" introduces a contrasting point (significant results — but there are limitations): correct and formal. "Thereby meaning" + participle is the correct embedded-result structure: the small sample thereby meaning the findings cannot be generalised. Option (b) "But" and "so" are too informal for academic writing. Option (c) "Nevertheless" concedes and overrides — here we are acknowledging a genuine limitation, not overriding it, so "However" is more precise. Option (d) "Although" needs to join two clauses in one sentence — it cannot begin a new sentence here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6ebce533-7796-5c53-ad0b-518a229f4c24', '6d77d1ef-a1fa-5f50-98d6-c50dcb5685a1', 'anglais-c1', '⚔️ Chapter Boss ⭐⭐⭐: Discourse Markers and Cohesion', 3, 120, 30, 'boss', 'admin', 3)
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
  ('cd2954a8-0831-5c61-868a-569c9374e1a4', '6ebce533-7796-5c53-ad0b-518a229f4c24', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The project was costly; nevertheless, the board approved it."},{"id":"b","text":"Despite facing severe opposition, the bill was passed."},{"id":"c","text":"The report was published, thereby drawing public attention to the issue."},{"id":"d","text":"Albeit the risks were great, they proceeded with the plan."}]'::jsonb, 'd', 'Option (d) is wrong: "Albeit" cannot be followed by a full clause (the risks were great). Use "albeit" only before an adjective, adverb, or noun phrase: albeit risky / albeit a great risk. For a full clause, use "although" or "even though": Although the risks were great, they proceeded. Options (a), (b), and (c) correctly use nevertheless + full clause, despite + gerund, and thereby + -ing.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0724c45e-9d66-59ed-b53b-aa33dd073cba', '6ebce533-7796-5c53-ad0b-518a229f4c24', 'Choose the sentence with the best formal register for an academic essay.', '[{"id":"a","text":"The economy grew a lot, but there was still a lot of inequality."},{"id":"b","text":"The economy grew significantly; however, income inequality persisted."},{"id":"c","text":"The economy grew significantly; so, income inequality was still a big thing."},{"id":"d","text":"The economy grew significantly though inequality didn''t go away."}]'::jsonb, 'b', 'Option (b) is the most formal: "significantly" (precise adverb), semicolon + "however" (formal contrast connector), and formal vocabulary ("income inequality persisted"). Option (a) uses vague and informal language ("a lot", "still a lot"). Option (c) uses "so" (informal) and "a big thing" (very informal). Option (d) omits punctuation and uses colloquial phrasing ("didn''t go away").', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96f8c4f1-1fa2-525a-ab8d-0c4a43bbbfc2', '6ebce533-7796-5c53-ad0b-518a229f4c24', 'Complete the paragraph: "The proposed solution addresses the technical gaps. ___, it fails to consider the human impact. ___ being expensive to implement, it may also prove difficult to maintain."', '[{"id":"a","text":"Moreover … In addition to"},{"id":"b","text":"However … As well as"},{"id":"c","text":"Nevertheless … Despite"},{"id":"d","text":"Therefore … In spite of"}]'::jsonb, 'b', 'Gap 1: The first sentence is positive; the second introduces a limitation — a contrast: **However**, it fails to consider the human impact. Gap 2: "As well as being expensive to implement" + another point — addition/listing: **As well as** being expensive, it may be difficult to maintain. Option (a) "Moreover" adds a supporting point — wrong for a contrast. Option (c) "Nevertheless" concedes and then affirms — wrong for gap 1 (no concession being made). Option (d) "Therefore" signals a result — wrong for gap 1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9198bb38-6009-53f5-a105-9cd58d689517', '6ebce533-7796-5c53-ad0b-518a229f4c24', 'Which pair correctly uses ''hence'' and ''namely''?', '[{"id":"a","text":"The bridge is unsafe, namely it should be closed. | Three cities were affected, hence London, Paris, and Rome."},{"id":"b","text":"The data was corrupted; hence, the analysis was unreliable. | Three cities were affected, namely London, Paris, and Rome."},{"id":"c","text":"Three cities were affected; hence, London, Paris, and Rome. | The data was corrupted, namely the analysis failed."},{"id":"d","text":"The bridge is unsafe; hence, it should be closed. | The data was corrupted, namely from three cities."}]'::jsonb, 'b', 'Option (b): "hence" correctly introduces a result after a cause (corrupted data → unreliable analysis). "Namely" correctly introduces a specification — naming the three cities. Option (a) uses "namely" as a result connector and "hence" as a listing word — both reversed. Option (c) reverses them again. Option (d) uses "namely" to specify the data source — slightly stretched, but "namely" specifies what was said, not where data is from — the usage in (b) is cleaner.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27e6b97c-6c00-5aca-9192-24484d99647d', '6ebce533-7796-5c53-ad0b-518a229f4c24', 'Read: "The negotiations were described as productive. On the contrary, analysts noted that no binding agreement was reached."
Is ''on the contrary'' used correctly here?', '[{"id":"a","text":"Yes — it correctly contrasts the two views of the negotiations."},{"id":"b","text":"No — it should be ''By contrast'' since two different perspectives are being compared, not a denial of the first sentence."},{"id":"c","text":"Yes — ''on the contrary'' and ''by contrast'' are interchangeable in this context."},{"id":"d","text":"No — it should be ''Nevertheless'', as the analysts were conceding the productivity."}]'::jsonb, 'b', '"On the contrary" is used to DENY what was just stated — to say it is simply wrong. Here, the analysts are presenting an opposing perspective/analysis, not outright saying the negotiations were NOT productive. "By contrast" introduces a different view from a different source without a full denial. So "By contrast, analysts noted that…" is more precise. Option (c) is wrong — they are not interchangeable. Option (d) is wrong — "Nevertheless" would concede the productivity claim, then add something anyway.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('410758df-5fc9-56f8-90ee-49651783aa12', '6ebce533-7796-5c53-ad0b-518a229f4c24', 'Complete the formal sentence: "The new regulation was introduced to curb emissions, ___ penalising companies that continued to pollute."', '[{"id":"a","text":"thus"},{"id":"b","text":"therefore"},{"id":"c","text":"thereby"},{"id":"d","text":"consequently"}]'::jsonb, 'c', '"Thereby" + present participle (-ing) embeds the result within the same clause without starting a new sentence: thereby penalising companies… It is the only option that grammatically precedes a bare -ing verb here. "Thus", "therefore", and "consequently" must introduce a new full clause with a subject + verb. Compare: The regulation was introduced; **therefore**, companies that polluted were penalised (full clause needed after a semicolon).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0120a12f-d163-58cd-ad65-a901ca2b432a', '6d77d1ef-a1fa-5f50-98d6-c50dcb5685a1', 'anglais-c1', '👑 Elite Challenge ⭐⭐⭐⭐: Discourse Markers and Cohesion', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('4cc19af3-bd17-570b-98f3-c6a9a4885069', '0120a12f-d163-58cd-ad65-a901ca2b432a', 'Read: "Unemployment fell to its lowest level in a decade. The housing market, however, remained stagnant. Moreover, consumer confidence continued to slide."

What is the logical structure of this passage?', '[{"id":"a","text":"Claim → result → further result"},{"id":"b","text":"Positive finding → contrast → additional negative"},{"id":"c","text":"Concession → addition → result"},{"id":"d","text":"Definition → example → conclusion"}]'::jsonb, 'b', 'Sentence 1 is a positive finding (unemployment fell). "However" introduces a contrasting point (housing stagnant). "Moreover" adds a further negative point (consumer confidence falling). Structure: positive → contrast (however) → additional negative (moreover). Option (a) confuses "however" as a result marker — it is a contrast marker. Option (c) says the first point is a concession — it is a positive finding, not a concession. Option (d) invents a definition-example structure where none exists.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3002b81-5d85-56ac-a88e-d7dff814e178', '0120a12f-d163-58cd-ad65-a901ca2b432a', 'Find the error in this academic sentence: "The research yielded inconclusive results; nevertheless, the methodology was sound, thereby the team decided to extend the study."', '[{"id":"a","text":"\"Nevertheless\" should be \"However\" — there is no concession here."},{"id":"b","text":"\"thereby the team decided\" is wrong — \"thereby\" must be followed by a present participle (-ing), not a full clause."},{"id":"c","text":"The semicolon after \"results\" should be a comma."},{"id":"d","text":"\"sound\" should be followed by a comma and \"therefore\"."}]'::jsonb, 'b', 'The error is with "thereby": thereby must be followed by a present participle, not a full clause ("the team decided" has a subject + finite verb). Correct: "…the methodology was sound, thereby **prompting** the team to extend the study." OR use a different connector: "…; **therefore**, the team decided to extend the study." Option (a) is debatable — "nevertheless" could work here (conceding the inconclusive results while affirming the methodology). Option (c) is a matter of style. Option (d) suggests an unnecessary restructure.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ab50510-b547-5530-97e2-05a19df02222', '0120a12f-d163-58cd-ad65-a901ca2b432a', 'Choose the version that is most cohesive AND most appropriate for a formal academic essay.', '[{"id":"a","text":"The intervention worked well. But a lot of people weren''t included in the study, so it''s hard to say if the results apply to everyone."},{"id":"b","text":"The intervention proved effective; however, the limited sample size meant the findings could not be broadly generalised."},{"id":"c","text":"The intervention was effective. Nevertheless, the sample was small. Therefore we can''t say the results are universal."},{"id":"d","text":"Although the intervention worked, the sample was limited, and so the results might not apply broadly."}]'::jsonb, 'b', 'Option (b) achieves the best formal register and cohesion: "proved effective" (precise verb), semicolon + "however" (formal contrast, single well-structured sentence), "limited sample size" (precise noun phrase), "broadly generalised" (formal vocabulary). Option (a) is too informal ("a lot of", "hard to say", "everyone"). Option (c) creates three short choppy sentences — poor cohesion. Option (d) is acceptable but "so" is informal and "might not apply broadly" is vaguer than "could not be broadly generalised".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb7c77b5-9748-5ca9-bb70-8d43df0729bb', '0120a12f-d163-58cd-ad65-a901ca2b432a', 'Complete the complex academic sentence: "The policy reform was ambitious, ___ limited in scope, ___ targeting only three of the seven sectors identified as critical."', '[{"id":"a","text":"albeit … thereby"},{"id":"b","text":"however … thus"},{"id":"c","text":"nevertheless … thereby"},{"id":"d","text":"although … consequently"}]'::jsonb, 'a', 'Gap 1: "albeit limited in scope" — "albeit" + adjective phrase = perfect concessive qualifier in a single clause: ambitious, albeit limited. Gap 2: "thereby targeting only three sectors" — "thereby" + present participle = embedded result. Together: The policy reform was ambitious, albeit limited in scope, thereby targeting only three of the seven critical sectors. Option (b): "however" starts a new clause — doesn''t fit mid-sentence. "thus" + -ing is non-standard. Option (c): "nevertheless" is a connector for a new sentence, not a mid-clause qualifier. Option (d): "although" needs a full finite clause after it — cannot precede just an adjective phrase.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6cf3f44-5237-5bd3-9b1b-c1de686726f2', '0120a12f-d163-58cd-ad65-a901ca2b432a', 'Read this argument: "Critics claim the austerity measures were necessary to restore fiscal balance. ___, public services were cut to unsustainable levels. ___, vulnerable communities bore the greatest burden."

Choose the best pair of discourse markers.', '[{"id":"a","text":"Moreover … In addition"},{"id":"b","text":"Nevertheless … Consequently"},{"id":"c","text":"However … Furthermore"},{"id":"d","text":"On the contrary … Therefore"}]'::jsonb, 'c', 'The argument challenges the critics'' claim: Gap 1 — introduce a contrasting negative consequence: **However**, public services were cut unsustainably. Gap 2 — add a further related negative point: **Furthermore**, vulnerable communities bore the greatest burden. Option (a) "Moreover … In addition" are both addition markers — they would make all three sentences add to the SAME direction, losing the contrast with the critics'' claim. Option (b) "Nevertheless" concedes the necessity and then qualifies — implies partial agreement, too soft for this rebuttal. Option (d) "On the contrary" would fully deny the critics — too strong, and "Therefore" makes the burden a result of cuts — actually logical but loses the additive second step.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('546c52bd-85e8-5f83-bab4-f899a194a5d4', '0120a12f-d163-58cd-ad65-a901ca2b432a', 'Which sentence contains a REGISTER MISMATCH (formal marker in informal context OR informal marker in formal context)?', '[{"id":"a","text":"\"I''m knackered. Furthermore, I haven''t eaten since breakfast.\""},{"id":"b","text":"\"The data indicates a correlation; however, causation has not been established.\""},{"id":"c","text":"\"The economy contracted in Q3; consequently, the central bank revised its forecast.\""},{"id":"d","text":"\"Voter turnout declined significantly; moreover, abstention rates reached a historic high.\""}]'::jsonb, 'a', 'Option (a) mixes informal vocabulary ("knackered" — British slang for exhausted) with a formal connector ("Furthermore"). In casual speech, you would say: "I''m knackered. Also, I haven''t eaten…" or replace "knackered" with "exhausted" for a formal register. Options (b), (c), and (d) all correctly combine formal vocabulary with formal discourse markers — no mismatch.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

