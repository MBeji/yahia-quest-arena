-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-3eme (الرياضيات)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-3eme/
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
  ('math-3eme', 'الرياضيات', 'الأنشطة العددية والقيس والهندسة وفق برنامج الرياضيات للسنة الثالثة من التعليم الأساسي', 'Force', 'subject-math', 'Calculator', 1, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '3eme-base'), '[{"code":"102306","label":null}]'::jsonb)
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
      AND e.subject_id = 'math-3eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('8c6a6b85-8b4d-5d95-972f-8c202c5441ae', '2285271b-2692-5b88-a8e2-11b31b4255b5', '47004acc-b634-5600-807a-4d2c1e5ee377', 'f78377eb-ffa5-5a0b-ba02-62c1c3dafe24', '0cfc5547-d1f2-5e27-b17a-3ec12b5d2bfd', '28146c9a-b713-5fa6-a06a-c76cd3a21df7', '6779d3b4-6ec1-5f5d-b6ba-6daec543414a', '2a631772-16bf-5a3e-94ba-e43d25d2d7c9', 'd1e85591-44bf-5cec-99f4-c2e095e1c38d', '4411c964-0b9a-5dcc-94ea-ee7ed5bf576a', 'd85d3595-fadd-529f-99d5-acefdb2c33a8', '6e754866-792b-5347-b5a7-f0007a481eb3', '311a9311-3e58-5c3d-a738-08048f1b7ea2', 'c4e647f5-6582-519e-8b7b-6c2a5b0b58d2', '729a82bd-ea20-5869-ae60-ad207ed71af9', 'b3474165-c678-5459-a28f-fe110528af04', '84711fdd-59af-586f-a227-a65a8ce3e8fa', '549d1907-ae3b-50b7-a95e-28006128f807', 'b5041e77-c7ed-5cec-a3dc-db5cad9c595f', 'de10cc4d-346b-5638-9487-a22fd529cc06', 'e328e0f5-f497-589c-82c4-e8cc97577662', '99fdb98f-0049-5495-b0c8-0cf3a200d2c8', '1e8e10b8-c93d-51b7-b6da-c7eb48522acb', '87ee2962-0956-54ff-886d-dace82998abb', '2b9635d9-c937-5e27-966c-8775f6d98f57', '6b9a264e-c41d-548c-b1b8-9462d104f484', '2f6db70c-91dd-56d0-8ca8-c6e5110f7d67', '7b05eafd-fc48-5897-b2d7-f9ec0696bd56', '5f970cae-b119-5a44-9e46-b256801b8cec', '958b8f5c-fa1f-5057-b9fe-b68b8f7e1763', 'cb298528-cc9b-59eb-bddd-2806c5c7e162', '91f45398-54ef-5d26-bdf5-ea0b4f04998e', '4fa88fa6-ecf0-5506-a624-93a6d845c3ef', '71dac53e-4e95-5152-96e3-da1933712794', '136e0274-b087-5177-90a0-d64df151a537', 'eae5ecf4-8c49-5a54-b188-d175c5b67bd1', 'fa27437b-3a9a-5819-bf24-90e96d3b05f5', '91f8131c-c796-5739-bf3f-978d67c71767', '1264444d-3257-5c26-8c6a-3cf6d7e4be65', '0a33dc00-183b-5da5-b5cf-e67d592b4f0f', '4c1e9c57-af0b-5aa4-82ab-caa262a64adf', '07e891d8-9868-5a12-b51b-141bddd310b5', 'e937f7d0-fc4b-510d-ba58-6dae283c5314', 'd3cf3423-4c8b-585e-b822-4358635d9b51', 'dbebcaaa-cea1-55a3-90fe-3f54a7d39be9', '9708e374-4f55-5a79-98dd-6b069e6333f7', '767074c1-de1d-51c9-a8c4-c95b3ab31dba', '85f74a48-1eca-5c75-9db8-e6e34b03e3d7', 'aa08b5a2-6595-59e5-8c08-bb93ce44d05a', '64a1481c-e7b3-5743-85c7-72ac0aa95607', '5bf45cf1-d84a-50f8-b182-aec42a5e4330', 'fa721a4d-16ab-5d98-bc68-59bb2d02fee3', '03a32a5a-be33-506e-a3a5-2ff7ebaee9cd', '9ad20e3c-192e-5c72-bd73-b4b546628371', '615d08fd-1a6b-53c3-9c53-487e7f353d11', '59ca1275-583d-5f38-851e-8d41f26486b9', 'ba7960cc-764f-5885-9a63-011d070af677', 'a61cc046-5a5d-5a42-934b-d69e7b9fc935', '22a0e2c5-bf31-5b28-b972-eead3fa05f70', 'd1afcdad-f3d7-5662-bb75-239502758533', '81851699-bb47-5507-a09c-08981ca2096e', 'b83f8517-7b08-5fae-9a32-ea539840b0f6', '2e1509f3-b7e6-5834-a4b3-aa9fd0bc2985', 'c83cacbb-95ff-55c4-9ae0-770951eba7a3', '29bc0c3d-86b3-5091-a0b4-b1d8c16da9bc', '9353c1af-1104-50fa-9ebf-d4c0cb787eea', '32096824-ce13-5765-91a7-80b2140617c1', '547b6e87-2d2c-5891-a3b3-50883ead4216', 'c65e5dda-c46e-568b-b3e8-b4863d4b0c27', '8c356385-55b8-54b5-868a-8f9117a27299', '7547094c-494d-5636-bc93-0cda630743de', '2ca5df4d-0efb-55af-a520-9411ee359b40', '6420042f-922b-55ed-9fe3-e3c46e114dbd', '712f91f9-687c-56c1-8074-175d8491a7b6', '795cbe0f-0f3a-5ba2-b4c0-926e501bc59e', '9129a86d-b485-5c8b-9cea-a2cdbf871c5b', '37e57d10-3347-5a5e-97f1-7e8df4d7bfd3', '30be8954-019a-5d30-b797-6eeb5c9cf610', 'd7ff0ac2-201e-5cee-9ed1-6d31a48dfdec', 'd14cc646-b30a-58c2-b5b5-a4ef776d0b86', '2df49b24-7e65-58ee-baa9-f4ec35974a5a', '3ceb9ee9-8162-5ed5-b370-852887b504cb', '1991cda4-3f8a-5892-bdc0-69d64952f3f9', '98edafe9-50cc-536c-9e4a-41e010d38a84', '902b9ef2-adb8-5460-934e-2c03f4a93869', '8318e414-c3b3-5f57-ac9e-e4f85cf999a1', '4fc8113e-9cb8-5cb4-beca-70d98260b4d8', '5ddca7b9-9d08-548b-af1e-95538e351591', '3e6dc8b1-c70c-5794-be0e-3de8a675f559', 'c3f0ca93-fc11-52c7-998d-04e9d775557b', '0d50406d-297c-551f-abc7-64da12c1c9ba', '54463f78-1d6d-5fb9-83d7-62ef2358e91b', 'a58c3935-07f6-5337-862f-eaf478ee9f5f', 'cf6f88d1-560f-5775-bd45-770691d8d254', '544b1021-4f98-5fea-84af-023ebd9c0967', '69784f79-133b-5ccb-b41d-1fdd28a43738', '3b20522b-a506-5f11-8286-56e03054bcaa', 'e943312f-f6a2-5058-971b-52dcefe73805', 'fc5db26c-b5d2-58ad-b798-789fa54a0e5c', '42b284be-5c8a-5cfc-9216-4aadf5c28e6c', '2530f243-0aa9-5113-982e-f10e38c8e6cb', '7e91316e-bb11-5f50-bbbd-55d035fad14a', '0a8f761f-a3ff-52ea-888a-7cd95a403dd8', 'd3c35281-6775-56f1-98a7-1b1a2dc3e7c0', '43068a6d-2d93-5de3-a358-91055f3ca19e', 'c5d93406-1c09-5ce8-98b9-81d6b697c3cd', '3f1fb2d6-d44a-57ad-9eb9-7e9d19a73655', '5261e219-d50e-5c0f-ab92-854aee32863e', '0ae2eb2f-d6e9-53fa-81de-366e5ef62bad', '73b04a81-2f64-5c8c-8364-91a1555d0506', '0c17bef0-546b-5798-b08b-214195a13281', '8ac97830-e2fe-5f06-a8c0-611127b2636c', 'cf90789d-037f-5667-820c-2fd7eda40447', 'b8f8127a-6f4f-5fdc-8ad2-ea0207b1c37c', '594d6a62-1bc0-5491-bfc8-d924826ba846', '58029863-152b-5790-a3b3-79325851c816', '5f5c4a91-cdf5-55b4-be49-49bb94090fe9', '866a47e2-74b7-5904-b599-0e9ff468fe22', '81cb3427-414c-5784-b709-50f8de4fd778', '7f8dc560-1465-5d3c-9af6-09a4764646d9', 'a2998481-71a7-562e-b470-6efef047ecad', 'afd74cb8-bfbd-5c21-a2b2-f28d342fc54c', '2b46c7b7-3342-5781-b3a0-8b872f2260d0', '0e5ef739-119e-5c9e-8432-f40dc22b05a7', '3d9cab6c-f6ec-5b03-adeb-fe272e70fb81', '78be4ec0-379e-5e18-ab0b-417325dcb0f8', '0fc931b8-3b5a-5b59-b02f-ad617575fe40', '2ce60d50-7d9b-505d-8f3c-c13ef5e142a2', 'c882d9ee-79d8-501c-9adf-37d229646cba', '48811efe-dac4-582a-b239-86c0ab587f31', '959f521b-35a2-5856-b7d1-2b857f5f9391', '3115d2ce-f604-59c6-adf3-30e5badc7e35', 'e58379f2-cb34-5fa6-a92f-04e713a42249', 'b0591883-48e6-5e35-9c9c-15df82e0e179', '7e852c4f-c78f-560d-a8d9-3fc03460c4a7', '23927ed2-26b7-5b78-92ea-143960596122', '76ed5ae0-6a7f-55a0-a1cd-6bb485cb68e6', 'ff440060-dce6-5dd5-9719-2cb2eb07bb9a', 'd9aef2f9-ed4b-540e-b2b6-3a6eee141605', '25776c89-b5fd-5882-8c95-6a0e6e4b382b', 'b6886e80-b384-5f66-8c7a-949b39153443', 'f9436f60-ced4-5082-a963-35cc12e0b8d6', 'a4435588-a062-5927-a0e7-c1d7a204cef4', 'd826811d-33ae-5982-9863-e3586da90ab7', 'c5e78bf2-6447-53a1-95f4-fb8393484462', '58dcf684-3a44-5ee2-95e1-da7d94c23d64', 'b278954b-c27e-5088-a321-113da23c229d', '6d061210-7da5-506b-9b30-f68eb54e1d04', 'e9bf604f-84ee-5587-8b45-9be2bf43be8a', 'e8908e1c-7cad-541d-a2ff-fff7a9cc7670', '3f4882ae-6233-5155-8dec-159e7ced1c3f', '5fe53e1c-2b68-5aa2-bd5e-6a059f041bbd', '70169f78-8c33-5ea0-b6e9-464afe28c636', 'b642b298-113e-5507-95f3-2ee513c1bdd0', 'dbcf4272-63b4-54a7-950a-3b3702134a4b', '6b1f9272-473b-575b-b255-4193de487852', '2a4016cb-8483-5ce4-9936-8f67fc1f62cd', '8677585d-e569-50da-96e2-ddea9049b581', '0d1c0441-9d90-5bc0-a8b7-6023a7f562a7', '647bf360-8e9d-551b-a39f-3ea1dd9e3722', '86824189-3bb6-5239-bc1b-e8d2f633a505', 'de5c898b-5059-5777-b25f-0f08e1aad169', 'c5f667f7-683f-571c-b4e0-2c503c448b53', '0e65047c-b4b2-5902-adbd-06ebd1c0b79e', '25d86d5e-6ed7-5fa0-896f-a323290c2bb0', 'e58cd0ad-8648-53b2-beeb-d1b7c6ddc18c', '45befdd7-de41-5992-ac73-24cb77509749', 'd8d061f3-d5f6-5f14-8966-f49f4acf5ea0', '611936ee-593a-5c1b-8de9-d915b0bf6d1e', 'a892f36b-999a-572d-b15c-4b8c0d272958', '4a3bc43e-d26b-5ae6-a801-47db18700738', '597bdb0b-ee05-5669-ac88-d71acc96be73', '9100e39c-a7df-5957-b7b3-6363f0398c00', 'cbe88324-1ef1-53ff-8eb4-a7dba0c7e302', '330d0d47-321d-545b-8e9c-4e6342bbbe9b', '31ed67af-8a43-5ad4-b31a-5a4b14241a84', 'e9c853dd-15dc-5b21-b161-9590c8b82bb9', 'e1638a39-6058-5af7-a832-02773237cad0', '7e521cf8-713f-5117-8359-ef745569265f', 'ae96db0c-000a-51f5-85cf-1715d50413f2', 'bbffce1e-f5d5-5f09-bfa0-d4a4733160d4', '8733f912-9b50-5f21-8baa-a094fb20bef2', '73145393-e9e6-5d1d-9142-b14383a10baf', 'be316177-07b6-58bd-a179-0e9a3cbfe770', 'a1b53d52-6373-5ad9-ba4c-7c8d44893bea', 'cd0799e5-a961-5125-acfe-1c6e44333edc', 'c927f523-6d0e-566d-b964-cba6b18ff425', 'baaf2cce-3b12-54f2-9a89-90ce30b800c7', '0af7b08b-13f6-5b86-bd60-fe325f84fbe4', 'dd3b8d54-be9f-5ff4-a8e2-54fb3841ed32', 'de49ba9c-8149-51cc-9bd9-6ef59c809dd5', '800d4857-ba8a-58e3-b19e-058b8076b893', 'ddcda47f-97e7-5dbd-bc29-68b53c10524e', '63ec8df9-4a51-5fdb-955d-79f186fa2c56', '85f26dd6-0e21-5d08-b7d5-b240268d95ac', '6ed44d3e-a77a-5def-80df-8e7bdd050687', '9a87e92a-aa70-588b-a33e-d5975fdadd0b', '7728ca21-21a8-58f4-97d2-55cc89d28a22', '41420d99-6a06-5a02-9f78-17df5b078514', 'e3d7d925-3575-56b7-9808-fd96641b4ac2', 'ec50c94b-19c8-5c2d-87cb-48eac2824145', '9fed4523-32d1-57f2-8ecd-27fb438ea0ec', '5a4f5ada-a68e-5e17-856f-5cf440af2e36', 'f951e624-a703-5d0d-8d91-b70c9892d733', '03678a81-1a8a-5d9a-a6c0-eae67d882077', '6822dc87-edf3-57bf-9df1-f04f38e4897a', '30b63efc-4809-5199-850a-106a28096777', '2c6ea3dc-ec1a-5a23-804b-8e32bfb3fb01', 'e011e29a-aa1b-54a5-954c-609f0b2fab8c', '81987930-01f8-5184-9119-096916d0138a', '5725c1c4-83bc-5c25-95a6-52eb3c903886', 'a2ac0c48-89a2-5dab-8953-4c1a8d9b976d', 'de75f3ee-c8d4-5afd-9e90-6a8d9f247f1e', 'ed5208fa-35cd-503b-8ac0-b157453d6d36', 'c8334c02-e7ef-5ddc-99cb-2ab62eec00cc', '4cc37990-780f-5128-9aaa-41c545ec436c', '2e3a7aaf-a640-5ba8-9d86-8e4d14a2d991', 'b4a5d4d0-f362-5966-85d8-106a2b902430', '2d6acb95-8a5b-5c4b-af1d-fa9edfc4f3f9', '3c405c14-10d5-5bdc-981b-0082627fb2e0', 'f516cb77-19e2-56e9-8fb6-8475f6b2d822', '0f6ddc2c-b398-5904-9de6-5a01c1919967', '4c93393c-7a0e-5ac4-8918-7a20ca32623b', 'c380c356-c390-56b4-baa8-174dd3b3de7a', '5f46accb-6bfb-515b-a7a8-788ce0403247', '16e399ea-63cd-5e12-b2c4-ee38aecde75f', 'c55604cb-be60-5678-9231-11c46370c256', '8f0dcb17-26a7-5b5c-af2c-c0176bc657d6', 'fe65563d-dad8-51c7-9e57-9dafde6f137d', 'af4fd70b-8a4b-57be-be0a-4191d0d6c101', 'b86a261f-6175-5855-be3b-7df4894c91b4', 'ea5c793a-0604-55b9-8e80-692c6268f959', 'f7f480f2-7daa-5c50-86ab-dae13857b393', '21179f3c-7271-5bd9-80b8-f1ee0e255c6c', 'cee54ab7-fa8e-5bac-b97f-59f83f5080fc', '541879ca-de8d-51d8-844a-4955a026b58f', 'c0d573d0-3a3e-5a60-836c-79c1e5ff7354', 'bcf65aa0-7ca6-5b70-bf73-532ee5e95930', '764c5a2a-1ed7-5d7a-9542-f6fbd2cb43ef', 'fdd19731-4ada-52c7-99ff-eda54957342e', '1c954ae7-239c-51b7-96e0-b787e7d1002b', '2bb0f9d2-cfa2-5b80-8a58-fe8b5aafa684', '1661dfd2-b764-5846-ba5d-62b2e2b45879', '75160c06-c81f-5a9b-9086-ea9be45bede9', '1bf022b6-69f0-57c1-b723-39bb0e63cd9d', '4919d76f-8775-5846-bfb2-e18eb19e1350', '784f25f6-77ac-5c5c-ad48-b1af2b3e29f9', '114952e7-b343-5a80-b1fb-aca92f22a620', '73fa6c8d-6653-574e-b751-54223357b451', '54870836-fb3e-5716-92d7-f55845da13f4', '828ff023-ae29-5fed-a65b-461f61bac72d', '0197e4c5-a81f-5a1d-ad7a-61223e7b3bcf', '0dbbae78-c528-52c4-88e0-e81b6e051b5c', '5a62a01d-4f99-5b6e-aba1-c55c1f333e0e', '9d5da433-0987-51c5-af5b-2e7fd67a2af9', '7921d110-1d3b-588e-8812-aa74bed039c8', '20632e95-094c-583a-8778-7a710895a119', 'f6a49196-377c-5cc4-9ae4-b9861354f4d1', 'b15b31d2-b678-5ae3-a364-a9ae9c801a66', '80aa719f-155d-553b-96fb-eb349e657e5a', '7ae63ab8-0097-5245-8fe4-9fa5a445188f', 'd5233fa8-e35b-5d6d-80e9-d3335224d5b9', '7015fa6c-7120-5e3b-a531-4afd4cf2b5fb', '3aeebf9c-d91a-553f-a0ac-1c68c96b8687', '592f8c5b-68fc-573f-9b03-3810978e702a', '0ca6435c-fae3-5dcf-8e59-91378087c627', '25b81e93-3d9e-573a-9206-6c652acbd14e', '62f05e5c-1cb1-51de-ae53-9afe816cb184', '145a2f96-6795-521f-a804-285aba4a0c74', '6611d761-c47d-5fc7-9bec-7d3086590fd0', '78885cac-683f-572e-8984-947676cac276', '00bc1703-2fd8-5527-8e8e-64d975fae20e', '51c3bf74-9c58-595c-a9f3-ea4c82a0015f', 'd2241f84-c7bd-5dcf-9dc6-33d6acd6e042', '8a8dd284-ea33-5d23-abe4-def5eace567e', 'f2e14a4f-0bcd-5ca4-a8a6-cca4451604dc', '40d79e59-5a3a-5d53-8001-58749ffaab62', 'aa69924e-9039-5252-a3f7-5c93db6e18b3', '9ade0c9c-16e4-54ea-9888-0d192a16981b', 'c0b0cdf9-4b75-5bd9-8f2f-7a804a1ab589');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-3eme' AND source = 'admin' AND id NOT IN ('a4822e19-f149-5cf7-8216-2e753bc551f8', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'af47c657-dfa2-5888-b874-b853537b7709', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'ace83de0-204e-5499-a5cf-dad8b5fd3c62', '4f418170-5dfd-55b0-82f7-2b5803731829', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', '030d3b56-40d6-589b-8be9-99b77357ef43', 'd072d43d-4ca5-589a-8306-69c004005258', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', '6c9808df-fefb-56f7-a661-4ef95a3c414f', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', '27d2f233-fc4a-5350-b0ae-9eed34f4273a', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', '6514fe71-6d72-59e7-9260-ae643880620f', '68fcfcd2-e474-535f-afcb-4be86b27d228', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'ec820faa-04fd-53ac-9841-5477b8ba7984', '04650261-2f0b-5fc9-8f35-c08ecc71698b', '836f097b-ff8d-5790-a559-f91a64bc4129', '4ab0f5c0-7980-55ec-a656-e4bf2914b93e', '80671e5e-3745-5397-8ef0-19ccadbe23ba', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'ba770364-9225-5efb-87f8-6831189a5814', 'fd6c52fc-9d01-5de4-b32c-8897708e53e3', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', '58b3f1f7-ec46-5f6a-9eb5-65e031cef733', '830c7471-068a-5dc3-9874-069e6271db4c', '98d6c352-f53c-535a-8ef2-2705aadd17be', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2');
DELETE FROM public.questions WHERE exercise_id IN ('a4822e19-f149-5cf7-8216-2e753bc551f8', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'af47c657-dfa2-5888-b874-b853537b7709', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'ace83de0-204e-5499-a5cf-dad8b5fd3c62', '4f418170-5dfd-55b0-82f7-2b5803731829', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', '030d3b56-40d6-589b-8be9-99b77357ef43', 'd072d43d-4ca5-589a-8306-69c004005258', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', '6c9808df-fefb-56f7-a661-4ef95a3c414f', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', '27d2f233-fc4a-5350-b0ae-9eed34f4273a', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', '6514fe71-6d72-59e7-9260-ae643880620f', '68fcfcd2-e474-535f-afcb-4be86b27d228', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'ec820faa-04fd-53ac-9841-5477b8ba7984', '04650261-2f0b-5fc9-8f35-c08ecc71698b', '836f097b-ff8d-5790-a559-f91a64bc4129', '4ab0f5c0-7980-55ec-a656-e4bf2914b93e', '80671e5e-3745-5397-8ef0-19ccadbe23ba', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'ba770364-9225-5efb-87f8-6831189a5814', 'fd6c52fc-9d01-5de4-b32c-8897708e53e3', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', '58b3f1f7-ec46-5f6a-9eb5-65e031cef733', '830c7471-068a-5dc3-9874-069e6271db4c', '98d6c352-f53c-535a-8ef2-2705aadd17be', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2') AND id NOT IN ('8c6a6b85-8b4d-5d95-972f-8c202c5441ae', '2285271b-2692-5b88-a8e2-11b31b4255b5', '47004acc-b634-5600-807a-4d2c1e5ee377', 'f78377eb-ffa5-5a0b-ba02-62c1c3dafe24', '0cfc5547-d1f2-5e27-b17a-3ec12b5d2bfd', '28146c9a-b713-5fa6-a06a-c76cd3a21df7', '6779d3b4-6ec1-5f5d-b6ba-6daec543414a', '2a631772-16bf-5a3e-94ba-e43d25d2d7c9', 'd1e85591-44bf-5cec-99f4-c2e095e1c38d', '4411c964-0b9a-5dcc-94ea-ee7ed5bf576a', 'd85d3595-fadd-529f-99d5-acefdb2c33a8', '6e754866-792b-5347-b5a7-f0007a481eb3', '311a9311-3e58-5c3d-a738-08048f1b7ea2', 'c4e647f5-6582-519e-8b7b-6c2a5b0b58d2', '729a82bd-ea20-5869-ae60-ad207ed71af9', 'b3474165-c678-5459-a28f-fe110528af04', '84711fdd-59af-586f-a227-a65a8ce3e8fa', '549d1907-ae3b-50b7-a95e-28006128f807', 'b5041e77-c7ed-5cec-a3dc-db5cad9c595f', 'de10cc4d-346b-5638-9487-a22fd529cc06', 'e328e0f5-f497-589c-82c4-e8cc97577662', '99fdb98f-0049-5495-b0c8-0cf3a200d2c8', '1e8e10b8-c93d-51b7-b6da-c7eb48522acb', '87ee2962-0956-54ff-886d-dace82998abb', '2b9635d9-c937-5e27-966c-8775f6d98f57', '6b9a264e-c41d-548c-b1b8-9462d104f484', '2f6db70c-91dd-56d0-8ca8-c6e5110f7d67', '7b05eafd-fc48-5897-b2d7-f9ec0696bd56', '5f970cae-b119-5a44-9e46-b256801b8cec', '958b8f5c-fa1f-5057-b9fe-b68b8f7e1763', 'cb298528-cc9b-59eb-bddd-2806c5c7e162', '91f45398-54ef-5d26-bdf5-ea0b4f04998e', '4fa88fa6-ecf0-5506-a624-93a6d845c3ef', '71dac53e-4e95-5152-96e3-da1933712794', '136e0274-b087-5177-90a0-d64df151a537', 'eae5ecf4-8c49-5a54-b188-d175c5b67bd1', 'fa27437b-3a9a-5819-bf24-90e96d3b05f5', '91f8131c-c796-5739-bf3f-978d67c71767', '1264444d-3257-5c26-8c6a-3cf6d7e4be65', '0a33dc00-183b-5da5-b5cf-e67d592b4f0f', '4c1e9c57-af0b-5aa4-82ab-caa262a64adf', '07e891d8-9868-5a12-b51b-141bddd310b5', 'e937f7d0-fc4b-510d-ba58-6dae283c5314', 'd3cf3423-4c8b-585e-b822-4358635d9b51', 'dbebcaaa-cea1-55a3-90fe-3f54a7d39be9', '9708e374-4f55-5a79-98dd-6b069e6333f7', '767074c1-de1d-51c9-a8c4-c95b3ab31dba', '85f74a48-1eca-5c75-9db8-e6e34b03e3d7', 'aa08b5a2-6595-59e5-8c08-bb93ce44d05a', '64a1481c-e7b3-5743-85c7-72ac0aa95607', '5bf45cf1-d84a-50f8-b182-aec42a5e4330', 'fa721a4d-16ab-5d98-bc68-59bb2d02fee3', '03a32a5a-be33-506e-a3a5-2ff7ebaee9cd', '9ad20e3c-192e-5c72-bd73-b4b546628371', '615d08fd-1a6b-53c3-9c53-487e7f353d11', '59ca1275-583d-5f38-851e-8d41f26486b9', 'ba7960cc-764f-5885-9a63-011d070af677', 'a61cc046-5a5d-5a42-934b-d69e7b9fc935', '22a0e2c5-bf31-5b28-b972-eead3fa05f70', 'd1afcdad-f3d7-5662-bb75-239502758533', '81851699-bb47-5507-a09c-08981ca2096e', 'b83f8517-7b08-5fae-9a32-ea539840b0f6', '2e1509f3-b7e6-5834-a4b3-aa9fd0bc2985', 'c83cacbb-95ff-55c4-9ae0-770951eba7a3', '29bc0c3d-86b3-5091-a0b4-b1d8c16da9bc', '9353c1af-1104-50fa-9ebf-d4c0cb787eea', '32096824-ce13-5765-91a7-80b2140617c1', '547b6e87-2d2c-5891-a3b3-50883ead4216', 'c65e5dda-c46e-568b-b3e8-b4863d4b0c27', '8c356385-55b8-54b5-868a-8f9117a27299', '7547094c-494d-5636-bc93-0cda630743de', '2ca5df4d-0efb-55af-a520-9411ee359b40', '6420042f-922b-55ed-9fe3-e3c46e114dbd', '712f91f9-687c-56c1-8074-175d8491a7b6', '795cbe0f-0f3a-5ba2-b4c0-926e501bc59e', '9129a86d-b485-5c8b-9cea-a2cdbf871c5b', '37e57d10-3347-5a5e-97f1-7e8df4d7bfd3', '30be8954-019a-5d30-b797-6eeb5c9cf610', 'd7ff0ac2-201e-5cee-9ed1-6d31a48dfdec', 'd14cc646-b30a-58c2-b5b5-a4ef776d0b86', '2df49b24-7e65-58ee-baa9-f4ec35974a5a', '3ceb9ee9-8162-5ed5-b370-852887b504cb', '1991cda4-3f8a-5892-bdc0-69d64952f3f9', '98edafe9-50cc-536c-9e4a-41e010d38a84', '902b9ef2-adb8-5460-934e-2c03f4a93869', '8318e414-c3b3-5f57-ac9e-e4f85cf999a1', '4fc8113e-9cb8-5cb4-beca-70d98260b4d8', '5ddca7b9-9d08-548b-af1e-95538e351591', '3e6dc8b1-c70c-5794-be0e-3de8a675f559', 'c3f0ca93-fc11-52c7-998d-04e9d775557b', '0d50406d-297c-551f-abc7-64da12c1c9ba', '54463f78-1d6d-5fb9-83d7-62ef2358e91b', 'a58c3935-07f6-5337-862f-eaf478ee9f5f', 'cf6f88d1-560f-5775-bd45-770691d8d254', '544b1021-4f98-5fea-84af-023ebd9c0967', '69784f79-133b-5ccb-b41d-1fdd28a43738', '3b20522b-a506-5f11-8286-56e03054bcaa', 'e943312f-f6a2-5058-971b-52dcefe73805', 'fc5db26c-b5d2-58ad-b798-789fa54a0e5c', '42b284be-5c8a-5cfc-9216-4aadf5c28e6c', '2530f243-0aa9-5113-982e-f10e38c8e6cb', '7e91316e-bb11-5f50-bbbd-55d035fad14a', '0a8f761f-a3ff-52ea-888a-7cd95a403dd8', 'd3c35281-6775-56f1-98a7-1b1a2dc3e7c0', '43068a6d-2d93-5de3-a358-91055f3ca19e', 'c5d93406-1c09-5ce8-98b9-81d6b697c3cd', '3f1fb2d6-d44a-57ad-9eb9-7e9d19a73655', '5261e219-d50e-5c0f-ab92-854aee32863e', '0ae2eb2f-d6e9-53fa-81de-366e5ef62bad', '73b04a81-2f64-5c8c-8364-91a1555d0506', '0c17bef0-546b-5798-b08b-214195a13281', '8ac97830-e2fe-5f06-a8c0-611127b2636c', 'cf90789d-037f-5667-820c-2fd7eda40447', 'b8f8127a-6f4f-5fdc-8ad2-ea0207b1c37c', '594d6a62-1bc0-5491-bfc8-d924826ba846', '58029863-152b-5790-a3b3-79325851c816', '5f5c4a91-cdf5-55b4-be49-49bb94090fe9', '866a47e2-74b7-5904-b599-0e9ff468fe22', '81cb3427-414c-5784-b709-50f8de4fd778', '7f8dc560-1465-5d3c-9af6-09a4764646d9', 'a2998481-71a7-562e-b470-6efef047ecad', 'afd74cb8-bfbd-5c21-a2b2-f28d342fc54c', '2b46c7b7-3342-5781-b3a0-8b872f2260d0', '0e5ef739-119e-5c9e-8432-f40dc22b05a7', '3d9cab6c-f6ec-5b03-adeb-fe272e70fb81', '78be4ec0-379e-5e18-ab0b-417325dcb0f8', '0fc931b8-3b5a-5b59-b02f-ad617575fe40', '2ce60d50-7d9b-505d-8f3c-c13ef5e142a2', 'c882d9ee-79d8-501c-9adf-37d229646cba', '48811efe-dac4-582a-b239-86c0ab587f31', '959f521b-35a2-5856-b7d1-2b857f5f9391', '3115d2ce-f604-59c6-adf3-30e5badc7e35', 'e58379f2-cb34-5fa6-a92f-04e713a42249', 'b0591883-48e6-5e35-9c9c-15df82e0e179', '7e852c4f-c78f-560d-a8d9-3fc03460c4a7', '23927ed2-26b7-5b78-92ea-143960596122', '76ed5ae0-6a7f-55a0-a1cd-6bb485cb68e6', 'ff440060-dce6-5dd5-9719-2cb2eb07bb9a', 'd9aef2f9-ed4b-540e-b2b6-3a6eee141605', '25776c89-b5fd-5882-8c95-6a0e6e4b382b', 'b6886e80-b384-5f66-8c7a-949b39153443', 'f9436f60-ced4-5082-a963-35cc12e0b8d6', 'a4435588-a062-5927-a0e7-c1d7a204cef4', 'd826811d-33ae-5982-9863-e3586da90ab7', 'c5e78bf2-6447-53a1-95f4-fb8393484462', '58dcf684-3a44-5ee2-95e1-da7d94c23d64', 'b278954b-c27e-5088-a321-113da23c229d', '6d061210-7da5-506b-9b30-f68eb54e1d04', 'e9bf604f-84ee-5587-8b45-9be2bf43be8a', 'e8908e1c-7cad-541d-a2ff-fff7a9cc7670', '3f4882ae-6233-5155-8dec-159e7ced1c3f', '5fe53e1c-2b68-5aa2-bd5e-6a059f041bbd', '70169f78-8c33-5ea0-b6e9-464afe28c636', 'b642b298-113e-5507-95f3-2ee513c1bdd0', 'dbcf4272-63b4-54a7-950a-3b3702134a4b', '6b1f9272-473b-575b-b255-4193de487852', '2a4016cb-8483-5ce4-9936-8f67fc1f62cd', '8677585d-e569-50da-96e2-ddea9049b581', '0d1c0441-9d90-5bc0-a8b7-6023a7f562a7', '647bf360-8e9d-551b-a39f-3ea1dd9e3722', '86824189-3bb6-5239-bc1b-e8d2f633a505', 'de5c898b-5059-5777-b25f-0f08e1aad169', 'c5f667f7-683f-571c-b4e0-2c503c448b53', '0e65047c-b4b2-5902-adbd-06ebd1c0b79e', '25d86d5e-6ed7-5fa0-896f-a323290c2bb0', 'e58cd0ad-8648-53b2-beeb-d1b7c6ddc18c', '45befdd7-de41-5992-ac73-24cb77509749', 'd8d061f3-d5f6-5f14-8966-f49f4acf5ea0', '611936ee-593a-5c1b-8de9-d915b0bf6d1e', 'a892f36b-999a-572d-b15c-4b8c0d272958', '4a3bc43e-d26b-5ae6-a801-47db18700738', '597bdb0b-ee05-5669-ac88-d71acc96be73', '9100e39c-a7df-5957-b7b3-6363f0398c00', 'cbe88324-1ef1-53ff-8eb4-a7dba0c7e302', '330d0d47-321d-545b-8e9c-4e6342bbbe9b', '31ed67af-8a43-5ad4-b31a-5a4b14241a84', 'e9c853dd-15dc-5b21-b161-9590c8b82bb9', 'e1638a39-6058-5af7-a832-02773237cad0', '7e521cf8-713f-5117-8359-ef745569265f', 'ae96db0c-000a-51f5-85cf-1715d50413f2', 'bbffce1e-f5d5-5f09-bfa0-d4a4733160d4', '8733f912-9b50-5f21-8baa-a094fb20bef2', '73145393-e9e6-5d1d-9142-b14383a10baf', 'be316177-07b6-58bd-a179-0e9a3cbfe770', 'a1b53d52-6373-5ad9-ba4c-7c8d44893bea', 'cd0799e5-a961-5125-acfe-1c6e44333edc', 'c927f523-6d0e-566d-b964-cba6b18ff425', 'baaf2cce-3b12-54f2-9a89-90ce30b800c7', '0af7b08b-13f6-5b86-bd60-fe325f84fbe4', 'dd3b8d54-be9f-5ff4-a8e2-54fb3841ed32', 'de49ba9c-8149-51cc-9bd9-6ef59c809dd5', '800d4857-ba8a-58e3-b19e-058b8076b893', 'ddcda47f-97e7-5dbd-bc29-68b53c10524e', '63ec8df9-4a51-5fdb-955d-79f186fa2c56', '85f26dd6-0e21-5d08-b7d5-b240268d95ac', '6ed44d3e-a77a-5def-80df-8e7bdd050687', '9a87e92a-aa70-588b-a33e-d5975fdadd0b', '7728ca21-21a8-58f4-97d2-55cc89d28a22', '41420d99-6a06-5a02-9f78-17df5b078514', 'e3d7d925-3575-56b7-9808-fd96641b4ac2', 'ec50c94b-19c8-5c2d-87cb-48eac2824145', '9fed4523-32d1-57f2-8ecd-27fb438ea0ec', '5a4f5ada-a68e-5e17-856f-5cf440af2e36', 'f951e624-a703-5d0d-8d91-b70c9892d733', '03678a81-1a8a-5d9a-a6c0-eae67d882077', '6822dc87-edf3-57bf-9df1-f04f38e4897a', '30b63efc-4809-5199-850a-106a28096777', '2c6ea3dc-ec1a-5a23-804b-8e32bfb3fb01', 'e011e29a-aa1b-54a5-954c-609f0b2fab8c', '81987930-01f8-5184-9119-096916d0138a', '5725c1c4-83bc-5c25-95a6-52eb3c903886', 'a2ac0c48-89a2-5dab-8953-4c1a8d9b976d', 'de75f3ee-c8d4-5afd-9e90-6a8d9f247f1e', 'ed5208fa-35cd-503b-8ac0-b157453d6d36', 'c8334c02-e7ef-5ddc-99cb-2ab62eec00cc', '4cc37990-780f-5128-9aaa-41c545ec436c', '2e3a7aaf-a640-5ba8-9d86-8e4d14a2d991', 'b4a5d4d0-f362-5966-85d8-106a2b902430', '2d6acb95-8a5b-5c4b-af1d-fa9edfc4f3f9', '3c405c14-10d5-5bdc-981b-0082627fb2e0', 'f516cb77-19e2-56e9-8fb6-8475f6b2d822', '0f6ddc2c-b398-5904-9de6-5a01c1919967', '4c93393c-7a0e-5ac4-8918-7a20ca32623b', 'c380c356-c390-56b4-baa8-174dd3b3de7a', '5f46accb-6bfb-515b-a7a8-788ce0403247', '16e399ea-63cd-5e12-b2c4-ee38aecde75f', 'c55604cb-be60-5678-9231-11c46370c256', '8f0dcb17-26a7-5b5c-af2c-c0176bc657d6', 'fe65563d-dad8-51c7-9e57-9dafde6f137d', 'af4fd70b-8a4b-57be-be0a-4191d0d6c101', 'b86a261f-6175-5855-be3b-7df4894c91b4', 'ea5c793a-0604-55b9-8e80-692c6268f959', 'f7f480f2-7daa-5c50-86ab-dae13857b393', '21179f3c-7271-5bd9-80b8-f1ee0e255c6c', 'cee54ab7-fa8e-5bac-b97f-59f83f5080fc', '541879ca-de8d-51d8-844a-4955a026b58f', 'c0d573d0-3a3e-5a60-836c-79c1e5ff7354', 'bcf65aa0-7ca6-5b70-bf73-532ee5e95930', '764c5a2a-1ed7-5d7a-9542-f6fbd2cb43ef', 'fdd19731-4ada-52c7-99ff-eda54957342e', '1c954ae7-239c-51b7-96e0-b787e7d1002b', '2bb0f9d2-cfa2-5b80-8a58-fe8b5aafa684', '1661dfd2-b764-5846-ba5d-62b2e2b45879', '75160c06-c81f-5a9b-9086-ea9be45bede9', '1bf022b6-69f0-57c1-b723-39bb0e63cd9d', '4919d76f-8775-5846-bfb2-e18eb19e1350', '784f25f6-77ac-5c5c-ad48-b1af2b3e29f9', '114952e7-b343-5a80-b1fb-aca92f22a620', '73fa6c8d-6653-574e-b751-54223357b451', '54870836-fb3e-5716-92d7-f55845da13f4', '828ff023-ae29-5fed-a65b-461f61bac72d', '0197e4c5-a81f-5a1d-ad7a-61223e7b3bcf', '0dbbae78-c528-52c4-88e0-e81b6e051b5c', '5a62a01d-4f99-5b6e-aba1-c55c1f333e0e', '9d5da433-0987-51c5-af5b-2e7fd67a2af9', '7921d110-1d3b-588e-8812-aa74bed039c8', '20632e95-094c-583a-8778-7a710895a119', 'f6a49196-377c-5cc4-9ae4-b9861354f4d1', 'b15b31d2-b678-5ae3-a364-a9ae9c801a66', '80aa719f-155d-553b-96fb-eb349e657e5a', '7ae63ab8-0097-5245-8fe4-9fa5a445188f', 'd5233fa8-e35b-5d6d-80e9-d3335224d5b9', '7015fa6c-7120-5e3b-a531-4afd4cf2b5fb', '3aeebf9c-d91a-553f-a0ac-1c68c96b8687', '592f8c5b-68fc-573f-9b03-3810978e702a', '0ca6435c-fae3-5dcf-8e59-91378087c627', '25b81e93-3d9e-573a-9206-6c652acbd14e', '62f05e5c-1cb1-51de-ae53-9afe816cb184', '145a2f96-6795-521f-a804-285aba4a0c74', '6611d761-c47d-5fc7-9bec-7d3086590fd0', '78885cac-683f-572e-8984-947676cac276', '00bc1703-2fd8-5527-8e8e-64d975fae20e', '51c3bf74-9c58-595c-a9f3-ea4c82a0015f', 'd2241f84-c7bd-5dcf-9dc6-33d6acd6e042', '8a8dd284-ea33-5d23-abe4-def5eace567e', 'f2e14a4f-0bcd-5ca4-a8a6-cca4451604dc', '40d79e59-5a3a-5d53-8001-58749ffaab62', 'aa69924e-9039-5252-a3f7-5c93db6e18b3', '9ade0c9c-16e4-54ea-9888-0d192a16981b', 'c0b0cdf9-4b75-5bd9-8f2f-7a804a1ab589');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-3eme' AND c.id NOT IN ('3ed1c629-4fa6-5101-abef-bfdedf5d5294', '68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', '920b0cc3-69f7-52c8-ae67-d3d77597db24', '9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'aae294cb-a57b-52df-a9df-f9f19e7580c2', '8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', '3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3ed1c629-4fa6-5101-abef-bfdedf5d5294', 'math-3eme', 'الأعداد إلى 9999', 'نظام العدّ العشري، الرتب الأربع (آحاد، عشرات، مئات، آلاف)، قراءة وكتابة الأعداد إلى 9999 بالأرقام وبالحروف، قيمة الرقم حسب رتبته، التفكيك والتركيب، والآلاف الكاملة', '# ⚔️ الأعداد إلى 9999 — بوّابة الآلاف

> 💡 «من يعرف منازل العدد يقرأ أيَّ عددٍ ولو بلغ الآلاف.»

أهلًا بك أيّها البطل في أوّل بوّابة من مغامرة السنة الثالثة. أنت تعرف من قبلُ الأعداد إلى 999؛ اليوم نفتح **رتبةً جديدة**: رتبة **الآلاف**، فنصير نقرأ ونكتب ونفكّك كلّ عددٍ إلى **9999**.

## 🏰 الأعداد الطبيعية

الأعداد الطبيعية هي الأعداد التي نَعُدّ بها: **0، 1، 2، 3، 4، …** وتستمرّ بلا نهاية.

- لكلّ عددٍ طبيعيّ _عددٌ يليه_ (تالٍ): بعد 9 يأتي 10، وبعد 999 يأتي 1000.
- ولكلّ عددٍ (ما عدا 0) _عددٌ يسبقه_ (سابق): سابق 1000 هو 999.
- أصغر عددٍ طبيعيّ هو **0**، وأكبر عددٍ في هذا الفصل هو **9999**.

## 🧮 الرتب الأربع

نكتب كلّ الأعداد بعشرة رموزٍ فقط (من 0 إلى 9)، وتتعلّق قيمة الرقم بـ**رتبته** (موضعه). وكلّ **عشر وحداتٍ** من رتبةٍ تُكوّن **وحدةً واحدة** من الرتبة الأعلى.

| الرتبة | آحاد | عشرات | مئات | آلاف  |
| ------ | ---- | ----- | ---- | ----- |
| قيمتها | 1    | 10    | 100  | 1 000 |

نقرأ الرتب من اليمين إلى اليسار: أوّل رقمٍ من اليمين آحاد، ثمّ عشرات، ثمّ مئات، ثمّ آلاف.

::: figure عشرُ وحداتٍ من رتبةٍ تُكوّن وحدةً واحدة من الرتبة الأعلى
<svg viewBox="0 0 340 120"><rect x="12" y="52" width="64" height="32" rx="5" fill="#ffffff" stroke="#a16207" stroke-width="2.5"/><text x="44.0" y="74.0" text-anchor="middle" font-size="13" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آحاد</text><path d="M78 68 H92" stroke="#16a34a" stroke-width="2.5"/><path d="M94 68 l-8 -4 l0 8 z" fill="#16a34a"/><text x="86.0" y="42.0" text-anchor="middle" font-size="12" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">× 10</text><rect x="96" y="52" width="64" height="32" rx="5" fill="#ffffff" stroke="#b91c1c" stroke-width="2.5"/><text x="128.0" y="74.0" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عشرات</text><path d="M162 68 H176" stroke="#16a34a" stroke-width="2.5"/><path d="M178 68 l-8 -4 l0 8 z" fill="#16a34a"/><text x="170.0" y="42.0" text-anchor="middle" font-size="12" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">× 10</text><rect x="180" y="52" width="64" height="32" rx="5" fill="#ffffff" stroke="#1d4ed8" stroke-width="2.5"/><text x="212.0" y="74.0" text-anchor="middle" font-size="13" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مئات</text><path d="M246 68 H260" stroke="#16a34a" stroke-width="2.5"/><path d="M262 68 l-8 -4 l0 8 z" fill="#16a34a"/><text x="254.0" y="42.0" text-anchor="middle" font-size="12" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">× 10</text><rect x="264" y="52" width="64" height="32" rx="5" fill="#ffffff" stroke="#7c3aed" stroke-width="2.5"/><text x="296.0" y="74.0" text-anchor="middle" font-size="13" font-weight="700" fill="#7c3aed" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آلاف</text><text x="170.0" y="108.0" text-anchor="middle" font-size="11" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عشرُ وحداتٍ من رتبةٍ تُكوّن وحدةً واحدة من الرتبة الأعلى</text></svg>
:::

_مثال:_ في العدد 3 758، الرقم 3 في رتبة الآلاف (قيمته 3 000)، والرقم 7 في رتبة المئات (قيمته 700)، والرقم 5 عشرات (قيمته 50)، والرقم 8 آحاد.

::: figure العدد 3 758: قيمة كلّ رقمٍ تتغيّر حسب رتبته
<svg viewBox="0 0 340 150"><rect x="10" y="30" width="60" height="46" rx="5" fill="#ede9fe" stroke="#1f2937" stroke-width="2"/><text x="40.0" y="63.0" text-anchor="middle" font-size="26" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><text x="40.0" y="22.0" text-anchor="middle" font-size="12" font-weight="700" fill="#7c3aed" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آلاف</text><text x="40.0" y="96.0" text-anchor="middle" font-size="13" font-weight="700" fill="#7c3aed" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3 000</text><rect x="82" y="30" width="60" height="46" rx="5" fill="#dbeafe" stroke="#1f2937" stroke-width="2"/><text x="112.0" y="63.0" text-anchor="middle" font-size="26" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7</text><text x="112.0" y="22.0" text-anchor="middle" font-size="12" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مئات</text><text x="112.0" y="96.0" text-anchor="middle" font-size="13" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">700</text><rect x="154" y="30" width="60" height="46" rx="5" fill="#fee2e2" stroke="#1f2937" stroke-width="2"/><text x="184.0" y="63.0" text-anchor="middle" font-size="26" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="184.0" y="22.0" text-anchor="middle" font-size="12" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عشرات</text><text x="184.0" y="96.0" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">50</text><rect x="226" y="30" width="60" height="46" rx="5" fill="#fef3c7" stroke="#1f2937" stroke-width="2"/><text x="256.0" y="63.0" text-anchor="middle" font-size="26" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8</text><text x="256.0" y="22.0" text-anchor="middle" font-size="12" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آحاد</text><text x="256.0" y="96.0" text-anchor="middle" font-size="13" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8</text><text x="170.0" y="132.0" text-anchor="middle" font-size="24" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3 758</text></svg>
:::

## 🏯 الآلاف الكاملة

**الألف الكامل** هو عددٌ رتبتُه آلافٌ فقط، وكلّ رتبٍ أخرى فيه صفر. نُكوّنه بضرب الرقم في **1000**:

| بالحروف    | بالأرقام | التكوين  |
| ---------- | -------- | -------- |
| ألف        | 1 000    | 1 × 1000 |
| ألفان      | 2 000    | 2 × 1000 |
| ثلاثة آلاف | 3 000    | 3 × 1000 |
| أربعة آلاف | 4 000    | 4 × 1000 |
| تسعة آلاف  | 9 000    | 9 × 1000 |

- نكتب الألف الكامل برقمٍ واحدٍ في الآلاف ثمّ **ثلاثة أصفار**: تسعة آلاف = 9 000.
- بهذا تكون الآلاف الكاملة هي: 1 000، 2 000، 3 000، …، حتّى 9 000.

## 🔮 قراءة وكتابة الأعداد إلى 9999

لقراءة عددٍ من أربعة أرقام نقرأ أوّلًا عدد الآلاف، ثمّ نُتبعه بقراءة العدد المكوّن من المئات والعشرات والآحاد.

- _مثال:_ العدد 4 206 يُقرأ «أربعة آلاف ومئتان وستّة».
- وللكتابة بالأرقام نبدأ من قراءة الحروف: «خمسة آلاف ومئة وثلاثون» = 5 130.

> 🗡️ عند الكتابة بالأرقام نترك **فراغًا صغيرًا** بين رتبة الآلاف وبقيّة الأرقام (لا فاصلة): 4 206، حتّى تَسهُل القراءة.

## ⭐ قيمة الرقم حسب رتبته

الرقم نفسه قد يكون له **قيمتان مختلفتان** حسب رتبته في العدد:

- في العدد 5 050، الرقم 5 على اليسار قيمته 5 000، والرقم 5 الآخر قيمته 50.
- نميّز دائمًا بين **الرقم** (5) و**قيمته** في العدد (5 000 أو 50…).

## ⚡ التفكيك والتركيب

**التفكيك** يعني كتابة العدد **مجموعَ حاصلات ضربٍ** حسب رتب أرقامه، و**التركيب** هو العمليّة العكسيّة (نجمع لنعود إلى العدد):

$$3 758 = 3 × 1000 + 7 × 100 + 5 × 10 + 8$$

- الرقم **0** في رتبةٍ يعني _لا شيء في تلك الرتبة_، لكنّه ضروريّ ليحفظ مواضع بقيّة الأرقام: 3 070 = 3 × 1000 + 7 × 10.
- التركيب: 2 × 1000 + 4 × 100 + 6 = 2 406.

> ⚠️ الفخّ الشائع: نسيان الصفر عند الكتابة، فيكتب التلميذ «ثلاثة آلاف وأربعون» = 340 بدل 3 040؛ الصواب أن نضع صفرًا في كلّ رتبةٍ فارغة لنحفظ مواضع الأرقام.

> 🏆 لقد عبرت البوّابة الأولى! صرت تقرأ وتكتب وتعرف قيمة كلّ رقمٍ وتُفكّك وتُركّب كلّ عددٍ إلى 9999. استعدّ الآن لبوّابة **مقارنة الأعداد وترتيبها**.', '# 📜 ملخّص: الأعداد إلى 9999

- **الأعداد الطبيعية:** 0، 1، 2، 3، … بلا نهاية؛ أصغرها 0، وأكبر عددٍ هنا 9999، ولكلّ عددٍ سابقٌ وتالٍ.
- **الرتب الأربع:** آحاد (1)، عشرات (10)، مئات (100)، آلاف (1 000)؛ نقرؤها من اليمين، وكلّ 10 وحداتٍ من رتبةٍ = وحدةٌ من الرتبة الأعلى.
- **الآلاف الكاملة:** رقمٌ في الآلاف ثمّ ثلاثة أصفار: 1 000، 2 000، …، 9 000؛ تُكوَّن بضرب الرقم في 1000.
- **القراءة والكتابة:** نقرأ عددَ الآلاف ثمّ بقيّة العدد؛ ونكتب بفراغٍ صغير قبل الآلاف مثل 4 206.
- **قيمة الرقم:** قيمة الرقم تتغيّر حسب رتبته؛ نميّز بين الرقم (5) وقيمته في العدد (5 000 أو 50).
- **التفكيك والتركيب:** التفكيك = كتابة العدد مجموعَ حاصلات ضربٍ حسب الرتب (3 758 = 3×1000 + 7×100 + 5×10 + 8)، والتركيب هو العمليّة العكسيّة.
- **دور الصفر:** الصفر في رتبةٍ يعني لا شيء فيها، لكنّه يحفظ مواضع بقيّة الأرقام (3 040 ≠ 340).', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', 'math-3eme', 'مقارنة الأعداد وترتيبها', 'مقارنة الأعداد إلى 9999 بالرموز < و > و =، والترتيب التصاعديّ والتنازليّ، وحصر عددٍ بين عددين وإقحام عددٍ بينهما، وإيجاد السابق والتالي', '# ⚔️ مقارنة الأعداد وترتيبها — من يكون الأكبر؟

> 💡 «لمعرفة الأكبر، عُدَّ الأرقام أوّلًا، ثمّ ابدأ من أعلى رتبةٍ على اليسار.»

عبرت بوّابة الأعداد إلى 9999 أيّها البطل، وصرت تقرأ وتكتب كلّ عددٍ كبير. اليوم تتعلّم سلاحًا جديدًا: كيف **تقارن** عددين فتعرف أيّهما أكبر، وكيف **ترتّب** مجموعةً من الأعداد، وكيف **تحصر** عددًا بين عددين.

## 🏰 رموز المقارنة الثلاثة

نستعمل ثلاثة رموزٍ لمقارنة عددين:

| الرمز | معناه   | مثال          |
| ----- | ------- | ------------- |
| <     | أصغر من | 2 504 < 2 540 |
| >     | أكبر من | 8 000 > 800   |
| =     | يساوي   | 470 = 470     |

> 🗡️ حيلة لتذكّر الرمز: الفُوّهة المفتوحة تتّجه دائمًا نحو **العدد الأكبر**، والطرف المدبّب نحو الأصغر.

## 🧮 كيف نقارن عددين؟

نتّبع قاعدتين بالترتيب:

1. **عُدّ الأرقام أوّلًا:** العدد ذو **عدد الأرقام الأكبر** هو الأكبر. فـ 999 < 1 000 لأنّ 1 000 من أربعة أرقام.
2. **إذا تساوى عدد الأرقام:** قارن **رتبةً برتبة من اليسار** (من الآلاف، فالمئات، فالعشرات، فالآحاد)، والحُكم **لأوّل اختلاف**.

::: figure الآلاف والمئات متساوية؛ الحُكم عند أوّل اختلاف: العشرات
<svg viewBox="0 0 340 152"><rect x="89" y="28" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="108.0" y="53.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><rect x="89" y="78" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="108.0" y="103.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><rect x="135" y="28" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="154.0" y="53.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><rect x="135" y="78" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="154.0" y="103.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><rect x="181" y="28" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="200.0" y="53.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">0</text><rect x="181" y="78" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="200.0" y="103.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><rect x="227" y="28" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="246.0" y="53.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><rect x="227" y="78" width="38" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="246.0" y="103.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">0</text><rect x="181" y="24" width="46" height="92" rx="6" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-dasharray="5 3"/><text x="204.0" y="136.0" text-anchor="middle" font-size="12" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">أوّل اختلاف: 0 < 4</text><text x="46.0" y="53.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2 504</text><text x="46.0" y="103.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2 540</text><text x="296.0" y="78.0" text-anchor="middle" font-size="14" font-weight="700" fill="#15803d" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2 504 < 2 540</text><text x="178.0" y="16.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آلاف · مئات · عشرات · آحاد</text></svg>
:::

_مثال محسوب:_ نقارن 3 248 و 3 261. الآلاف متساوية (3 = 3)، ثمّ المئات متساوية (2 = 2)، ثمّ العشرات: 4 < 6. إذن 3 248 < 3 261. ✓

> ⚠️ الفخّ الشائع: الظنّ أنّ العدد ذا الرقم الأكبر في **الآحاد** هو الأكبر. في 3 248 و 3 261 لا ننظر إلى 8 و 1؛ الحُكم لأوّل اختلافٍ من اليسار وهو العشرات.

## 🔮 الترتيب التصاعديّ والتنازليّ

بعد المقارنة نستطيع **ترتيب** عدّة أعداد:

- **تصاعديًّا (من الأصغر إلى الأكبر):** 45 < 1 209 < 3 080.
- **تنازليًّا (من الأكبر إلى الأصغر):** 3 080 > 1 209 > 45.

الحيلة: ابدأ بإبراز **الأقلّ أرقامًا** فهو الأصغر، ثمّ رتّب الباقي رتبةً برتبة.

## ⚡ السابق والتالي

لكلّ عددٍ **تالٍ** (يليه) هو العدد زائد 1، و**سابق** (يسبقه) هو العدد ناقص 1:

- تالي 999 هو 1 000، وسابقه هو 998.
- تالي 4 560 هو 4 561، وسابقه هو 4 559.

> ⚠️ الفخّ الشائع: عند التالي للعدد 999 يجب تغيير الرتبة كلّها: 999 + 1 = 1 000، لا 9 910 ولا 9 100.

## 🛡️ حصر عددٍ وإقحام عددٍ بينهما

**حصر** عددٍ يعني وضعه بين عددين، أصغرَ منه وأكبرَ منه:

- مثال: العدد 376 محصورٌ هكذا: 375 < 376 < 377، وأيضًا 300 < 376 < 400.

**إقحام** عددٍ يعني إيجاد عددٍ يقع **تمامًا بين** عددين:

- بين 248 و 250 نُقحم العدد 249 (لأنّ 248 < 249 < 250).
- _مثال محسوب:_ كم عددًا يقع تمامًا بين 1 305 و 1 309؟ هي 1 306 و 1 307 و 1 308، أي 3 أعداد. ✓ (لا نَعُدّ الطرفين.)

> 🏆 أحسنت! صرت تقارن وترتّب وتعرف السابق والتالي وتحصر الأعداد. استعدّ الآن للبوّابة الموالية حيث نخوض معركة **الجمع والطرح**.', '# 📜 ملخّص: مقارنة الأعداد وترتيبها

- **رموز المقارنة:** < أصغر من، > أكبر من، = يساوي؛ والفُوّهة المفتوحة تتّجه نحو الأكبر.
- **قاعدة المقارنة:** عُدّ الأرقام أوّلًا (الأكثر أرقامًا أكبر)؛ وعند التساوي قارن رتبةً برتبة من اليسار (الآلاف فالمئات فالعشرات فالآحاد)، والحُكم لأوّل اختلاف.
- **الترتيب التصاعديّ:** من الأصغر إلى الأكبر، مثل 45 < 1 209 < 3 080.
- **الترتيب التنازليّ:** من الأكبر إلى الأصغر، مثل 3 080 > 1 209 > 45.
- **التالي والسابق:** التالي = العدد زائد 1 (تالي 999 هو 1 000)؛ السابق = العدد ناقص 1 (سابق 1 000 هو 999).
- **الحصر والإقحام:** نحصر عددًا بين أصغرَ منه وأكبرَ منه (375 < 376 < 377)، ونُقحم عددًا يقع تمامًا بين عددين (بين 248 و 250 نُقحم 249).', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('920b0cc3-69f7-52c8-ae67-d3d77597db24', 'math-3eme', 'الجمع والطرح', 'معنى الجمع والطرح، مفرداتهما (الحدّ، المجموع، الفرق)، الجمع العموديّ مع الاحتفاظ والطرح مع الاستلاف، العلاقة بين الجمع والطرح، والبحث عن الحدّ المجهول، في الأعداد إلى 9999', '# ⚔️ الجمع والطرح — بوّابة الاحتفاظ والاستلاف

> 💡 «من يُتقن نقل الاحتفاظ ويُحسن الاستلاف، لا يهابه عددٌ ولو بلغ الآلاف.»

أهلًا بك أيّها البطل في بوّابةٍ جديدة من مغامرة السنة الثالثة. صرت تعرف الأعداد إلى 9999؛ اليوم نتعلّم كيف **نجمعها** ونحسب **الفرق** بينها بسرعةٍ وبلا خطأ، مستعملين الجمع والطرح العموديَّيْن.

## ➕ معنى الجمع ومفرداته

نجمع عددين لنعرف **الكلّ** بعد ضمّهما معًا. نسمّي العددين المجموعين **حدَّيْن**، ونتيجة الجمع **المجموع**.

$$245 + 132 = 377$$

هنا 245 و 132 **حدّان**، و 377 هو **المجموع**.

## ➖ معنى الطرح ومفرداته

نطرح عددًا من آخر لنعرف **الباقي** أو **الفرق**. نتيجة الطرح تُسمّى **الفرق**.

$$586 − 241 = 345$$

العدد الأكبر دائمًا في الأعلى؛ نطرح الأصغر من الأكبر، فلا يكون الفرق سالبًا أبدًا.

## 🧮 الجمع العموديّ والاحتفاظ

نكتب الأعداد بعضها تحت بعض، **رتبةً تحت رتبة** (آحاد تحت آحاد…)، ثمّ نجمع من اليمين إلى اليسار. إذا بلغ مجموع رتبةٍ **10 أو أكثر**، نكتب رقم الآحاد و**نحتفظ** بالعشرة لنضيفها إلى الرتبة الموالية.

_مثال:_ 367 + 158. الآحاد: 7 + 8 = 15، نكتب 5 ونحتفظ بـ 1. العشرات: 6 + 5 + 1 = 12، نكتب 2 ونحتفظ بـ 1. المئات: 3 + 1 + 1 = 5.

::: figure احتفاظان: واحدٌ فوق العشرات وآخر فوق المئات
<svg viewBox="0 0 280 170"><circle cx="96" cy="26" r="11" fill="#fde047" stroke="#1f2937" stroke-width="2"/><text x="96.0" y="31.0" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><circle cx="134" cy="26" r="11" fill="#fde047" stroke="#1f2937" stroke-width="2"/><text x="134.0" y="31.0" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><text x="96.0" y="66.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><text x="134.0" y="66.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><text x="172.0" y="66.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7</text><text x="58.0" y="108.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">+</text><text x="96.0" y="108.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><text x="134.0" y="108.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="172.0" y="108.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8</text><path d="M62 122 H190" stroke="#1f2937" stroke-width="2.5"/><text x="96.0" y="152.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="134.0" y="152.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><text x="172.0" y="152.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="96.0" y="14.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مئات</text><text x="134.0" y="14.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عشرات</text><text x="172.0" y="14.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آحاد</text><text x="238.0" y="96.0" text-anchor="middle" font-size="11" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7 + 8 = 15</text><text x="238.0" y="114.0" text-anchor="middle" font-size="11" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">نكتب 5</text><text x="238.0" y="132.0" text-anchor="middle" font-size="11" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">ونحتفظ بـ 1</text></svg>
:::

$$367 + 158 = 525$$

## 🔁 الطرح العموديّ والاستلاف

نضع العدد الأكبر في الأعلى، ونطرح رتبةً تحت رتبة من اليمين. إذا كان الرقم الأعلى **أصغر** من الرقم الأسفل، **نستلف** عشرةً من الرتبة المجاورة على اليسار (تصير 10 وحدات تُضاف، وتنقص الرتبة المجاورة بـ 1).

_مثال:_ 524 − 168. الآحاد: 4 أصغر من 8، نستلف فتصير 14؛ 14 − 8 = 6. العشرات: صارت 1 (بعد الاستلاف) وهي أصغر من 6، نستلف فتصير 11؛ 11 − 6 = 5. المئات: صارت 4؛ 4 − 1 = 3.

::: figure نستلف من الرتبة الأعلى: الآحاد تصير 14 والعشرات تصير 11
<svg viewBox="0 0 290 170"><text x="100.0" y="66.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="138.0" y="66.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><text x="176.0" y="66.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><text x="176.0" y="40.0" text-anchor="middle" font-size="12" font-weight="700" fill="#dc2626" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">14</text><text x="138.0" y="40.0" text-anchor="middle" font-size="12" font-weight="700" fill="#dc2626" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">11</text><path d="M166 56 l20 -10" stroke="#dc2626" stroke-width="1.6"/><path d="M128 56 l20 -10" stroke="#dc2626" stroke-width="1.6"/><text x="62.0" y="108.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">−</text><text x="100.0" y="108.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><text x="138.0" y="108.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><text x="176.0" y="108.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8</text><path d="M66 122 H194" stroke="#1f2937" stroke-width="2.5"/><text x="100.0" y="152.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><text x="138.0" y="152.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="176.0" y="152.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><text x="100.0" y="14.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مئات</text><text x="138.0" y="14.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عشرات</text><text x="176.0" y="14.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آحاد</text><text x="248.0" y="100.0" text-anchor="middle" font-size="11" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4 أصغر من 8</text><text x="248.0" y="118.0" text-anchor="middle" font-size="11" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">نستلف: 14 − 8 = 6</text></svg>
:::

$$524 − 168 = 356$$

## 🪜 الطرح بالزيادة (الإكمال)

أحيانًا يكون العددان **متقاربين**، فالطرح بالإكمال أسرع: بدل أن ننقص، **نبحث عن العدد الذي نضيفه إلى المطروح حتّى نبلغ المطروح منه**، وهذا العدد هو **الفرق** نفسه.

_مثال:_ 62 − 58. نسأل: «58 وكم يبلغ 62؟» نَعدّ تصاعديًّا من 58: 58 + 2 = 60، ثمّ 60 + 2 = 62، فأضفنا 4 جملةً. إذن 62 − 58 = 4.

> 🗡️ الطرح بالزيادة مفيدٌ جدًّا في **النقود وردّ الباقي**: إذا دفعت 100 مليم لشراءٍ بـ 65 مليمًا، تَعدّ من 65 إلى 100 لتعرف الباقي: 100 − 65 = 35 مليمًا.

## 🤝 العلاقة بين الجمع والطرح

الجمع والطرح **عمليّتان متعاكستان**: إذا جمعنا حدّين حصلنا على المجموع، وإذا طرحنا حدًّا من المجموع رجعنا إلى الحدّ الآخر.

$$المجموع − حدّ = الحدّ الآخر$$

نستعمل هذا **للتحقّق**: بعد الطرح 586 − 241 = 345، نتأكّد بالجمع 345 + 241 = 586 ✓.

## ↔️ الجمع تبديليّ والبحث عن حدٍّ مجهول

تبديل ترتيب الحدّين **لا يغيّر المجموع**: 245 + 132 = 132 + 245 = 377. هذه خاصيّة **التبديل**.

ولإيجاد **حدٍّ مجهول** في جمعٍ، نطرح الحدّ المعلوم من المجموع:

$$? + 130 = 450 ⟸ ? = 450 − 130 = 320$$

> 🗡️ احرص دائمًا على محاذاة الرتب: آحاد تحت آحاد، عشرات تحت عشرات؛ أمّا الاحتفاظ والاستلاف فاكتبهما صغيرَين فوق الرتبة المجاورة حتّى لا تنساهما.

> ⚠️ الفخّ الشائع: في الطرح يطرح بعض التلاميذ **الأصغر من الأكبر داخل الرتبة** (مثلًا 8 − 4 بدل 4 − 8) ظنًّا منهم أنّ الطرح يبدأ بالأكبر؛ والصواب أن نطرح الأسفل من الأعلى، وإذا لم يكفِ الأعلى **نستلف** من جاره.

> 🏆 لقد عبرت بوّابة الجمع والطرح! صرت تجمع بالاحتفاظ وتطرح بالاستلاف وتتحقّق من نتيجتك وتبحث عن الحدّ المجهول. استعدّ الآن للبوّابة الموالية في عالم الضرب.', '# 📜 ملخّص: الجمع والطرح

- **الجمع:** نضمّ عددين (حدَّيْن) لنحصل على **المجموع**؛ مثل 245 + 132 = 377.
- **الطرح:** نطرح الأصغر من الأكبر لنحصل على **الفرق** (الباقي)؛ مثل 586 − 241 = 345.
- **المفردات:** في الجمع نقول حدّ + حدّ = مجموع، وفي الطرح نقول الفرق هو نتيجة الطرح.
- **الجمع العموديّ:** نكتب رتبةً تحت رتبة ونجمع من اليمين؛ إذا بلغ مجموع رتبةٍ 10 أو أكثر **نحتفظ** بعشرةٍ للرتبة الموالية.
- **الطرح العموديّ:** نضع الأكبر فوق الأصغر؛ إذا كان الرقم الأعلى أصغر **نستلف** عشرةً من الرتبة المجاورة على اليسار.
- **الطرح بالزيادة (الإكمال):** إذا تقارب العددان نَعدّ تصاعديًّا من المطروح إلى المطروح منه، والمسافة هي الفرق: 62 − 58 = 4.
- **العلاقة بينهما:** الجمع والطرح متعاكسان: المجموع − حدّ = الحدّ الآخر.
- **التحقّق:** نتأكّد من الطرح بالجمع: 345 + 241 = 586 ✓.
- **الجمع تبديليّ:** تبديل ترتيب الحدّين لا يغيّر المجموع: 132 + 245 = 245 + 132.
- **الحدّ المجهول:** لإيجاده في جمعٍ نطرح الحدّ المعلوم من المجموع: ? + 130 = 450 ⟸ ? = 450 − 130 = 320.
- **انتبه:** نطرح دائمًا الأسفل من الأعلى، لا الأصغر من الأكبر داخل الرتبة.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'math-3eme', 'الضرب وخاصياته', 'معنى الضرب كجمعٍ متكرّر، العامل والجداء، جداول الضرب، خاصيات الضرب (التبديلية والتجميعية والتوزيعية على الجمع)، الضرب في 10 و100 و1000 وفي عقدٍ ومئةٍ وألفٍ كاملة، تقنية الضرب في عددٍ ذي رقمٍ واحد مع الاحتفاظ، وضِعف عدد', '# ⚔️ الضرب وخاصياته — سلاح الجمع المتكرّر

> 💡 «من يُتقن الضرب وخاصياته يَحسب في لمحةٍ ما يحتاج غيرُه إلى جمعٍ طويل.»

أهلًا بك أيّها البطل في بوّابة **الضرب**. أنت تُتقن الجمع والطرح من قبلُ. واليوم، حين نجمع العددَ نفسه مرّاتٍ كثيرة، نستعمل سلاحًا أسرع: **الضرب**. في هذه المغامرة نتعلّم معناه ومفرداته، وخاصياته الثلاث، والضربَ في 10 و100 و1000، ثمّ تقنية الضرب في عددٍ من رقمٍ واحد مع الاحتفاظ.

## 🏰 الضرب جمعٌ متكرّر

ضربُ عددٍ معناه **جمعُ الحدّ نفسه** عدّةَ مرّات. تخيّل 4 صناديق، في كلّ صندوقٍ 3 جواهر:

$$4 × 3 = 3 + 3 + 3 + 3 = 12$$

- نقرأ 4 × 3 «أربع مرّاتٍ ثلاثة»: أي العدد 3 مأخوذًا 4 مرّات.
- العددان اللذان نضربهما يُسمّى كلٌّ منهما **عاملًا**، ونتيجة الضرب تُسمّى **الجداء**.

_مثال:_ في 6 × 7 = 42، العاملان هما 6 و7، والجداء هو 42.

## 🔮 جداول الضرب

نحفظ جداول الضرب لنحسب بسرعة دون جمعٍ طويل. هذه شبكةٌ تجمع بعضها:

| ×   | 3   | 4   | 5   | 6   | 7   |
| --- | --- | --- | --- | --- | --- |
| 3   | 9   | 12  | 15  | 18  | 21  |
| 4   | 12  | 16  | 20  | 24  | 28  |
| 5   | 15  | 20  | 25  | 30  | 35  |
| 6   | 18  | 24  | 30  | 36  | 42  |
| 7   | 21  | 28  | 35  | 42  | 49  |

- كلّ خانةٍ هي جداء العامل في رأس سطرها بالعامل في رأس عمودها: مثلًا 6 × 4 = 24.

::: figure كلّ خانةٍ هي جداء سطرها في عمودها: الخانة الخضراء هي 6 × 4
<svg viewBox="0 0 300 200"><rect x="10" y="12" width="44" height="30" fill="#e2e8f0" stroke="#1f2937" stroke-width="1.6"/><text x="32.0" y="33.0" text-anchor="middle" font-size="16" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">×</text><rect x="54" y="12" width="44" height="30" fill="#dbeafe" stroke="#1f2937" stroke-width="1.6"/><text x="76.0" y="33.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="98" y="12" width="44" height="30" fill="#dbeafe" stroke="#1f2937" stroke-width="1.6"/><text x="120.0" y="33.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><rect x="142" y="12" width="44" height="30" fill="#dbeafe" stroke="#1f2937" stroke-width="1.6"/><text x="164.0" y="33.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><rect x="186" y="12" width="44" height="30" fill="#dbeafe" stroke="#1f2937" stroke-width="1.6"/><text x="208.0" y="33.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><rect x="230" y="12" width="44" height="30" fill="#dbeafe" stroke="#1f2937" stroke-width="1.6"/><text x="252.0" y="33.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7</text><rect x="10" y="42" width="44" height="30" fill="#fee2e2" stroke="#1f2937" stroke-width="1.6"/><text x="32.0" y="63.0" text-anchor="middle" font-size="15" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="54" y="42" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="76.0" y="63.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">9</text><rect x="98" y="42" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="120.0" y="63.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">12</text><rect x="142" y="42" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="164.0" y="63.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">15</text><rect x="186" y="42" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="208.0" y="63.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">18</text><rect x="230" y="42" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="252.0" y="63.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">21</text><rect x="10" y="72" width="44" height="30" fill="#fee2e2" stroke="#1f2937" stroke-width="1.6"/><text x="32.0" y="93.0" text-anchor="middle" font-size="15" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><rect x="54" y="72" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="76.0" y="93.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">12</text><rect x="98" y="72" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="120.0" y="93.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">16</text><rect x="142" y="72" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="164.0" y="93.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">20</text><rect x="186" y="72" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="208.0" y="93.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">24</text><rect x="230" y="72" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="252.0" y="93.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">28</text><rect x="10" y="102" width="44" height="30" fill="#fee2e2" stroke="#1f2937" stroke-width="1.6"/><text x="32.0" y="123.0" text-anchor="middle" font-size="15" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><rect x="54" y="102" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="76.0" y="123.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">15</text><rect x="98" y="102" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="120.0" y="123.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">20</text><rect x="142" y="102" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="164.0" y="123.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">25</text><rect x="186" y="102" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="208.0" y="123.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">30</text><rect x="230" y="102" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="252.0" y="123.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">35</text><rect x="10" y="132" width="44" height="30" fill="#fee2e2" stroke="#1f2937" stroke-width="1.6"/><text x="32.0" y="153.0" text-anchor="middle" font-size="15" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><rect x="54" y="132" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="76.0" y="153.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">18</text><rect x="98" y="132" width="44" height="30" fill="#bbf7d0" stroke="#1f2937" stroke-width="1.2"/><text x="120.0" y="153.0" text-anchor="middle" font-size="14" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">24</text><rect x="142" y="132" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="164.0" y="153.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">30</text><rect x="186" y="132" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="208.0" y="153.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">36</text><rect x="230" y="132" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="252.0" y="153.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">42</text><rect x="10" y="162" width="44" height="30" fill="#fee2e2" stroke="#1f2937" stroke-width="1.6"/><text x="32.0" y="183.0" text-anchor="middle" font-size="15" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7</text><rect x="54" y="162" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="76.0" y="183.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">21</text><rect x="98" y="162" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="120.0" y="183.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">28</text><rect x="142" y="162" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="164.0" y="183.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">35</text><rect x="186" y="162" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="208.0" y="183.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">42</text><rect x="230" y="162" width="44" height="30" fill="#ffffff" stroke="#1f2937" stroke-width="1.2"/><text x="252.0" y="183.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">49</text><text x="150.0" y="192.0" text-anchor="middle" font-size="15" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6 × 4 = 24</text></svg>
:::

- قاعدتان ثابتتان: **a × 0 = 0** دائمًا، و**a × 1 = a** دائمًا.
- **ضِعفُ عددٍ** هو جداؤه في 2: ضِعف 7 هو 2 × 7 = 14، وضِعف 25 هو 50.

## ⭐ الخاصية الأولى: التبديلية

ترتيب العاملين **لا يُغيّر** الجداء:

$$a × b = b × a$$

_مثال:_ 8 × 5 = 40 و5 × 8 = 40، النتيجة نفسها! ففائدتها أنّنا نختار الترتيب الأسهل، وإذا حفظنا 8 × 5 فقد عرفنا 5 × 8 أيضًا.

## 🛡️ الخاصية الثانية: التجميعية

عند ضرب **ثلاثة** أعداد، الطريقة التي نجمّع بها العاملين لا تُغيّر الجداء:

$$(a × b) × c = a × (b × c)$$

_مثال:_ نحسب 2 × 3 × 5 بطريقتين. (2 × 3) × 5 = 6 × 5 = 30، و2 × (3 × 5) = 2 × 15 = 30. النتيجة نفسها، فنبدأ بالضرب الأسهل.

## 🧮 الخاصية الثالثة: التوزيعية على الجمع

لضرب عددٍ في **مجموع**، نضربه في كلّ حدٍّ على حِدة ثمّ نجمع:

$$a × (b + c) = a × b + a × c$$

_مثال محسوب:_ 6 × (4 + 3) = 6 × 4 + 6 × 3 = 24 + 18 = 42. ويمكن التحقّق مباشرةً: 6 × 7 = 42 ✓.

::: figure نقسم المستطيل 6 × 7 إلى قطعتين: 6 × 4 و6 × 3، فمجموع مساحتيهما هو الجداء
<svg viewBox="0 0 320 190"><rect x="46" y="30" width="96" height="144" fill="#bfdbfe" stroke="#1f2937" stroke-width="2.5"/><rect x="142" y="30" width="72" height="144" fill="#fed7aa" stroke="#1f2937" stroke-width="2.5"/><text x="94.0" y="108.0" text-anchor="middle" font-size="16" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6 × 4</text><text x="178.0" y="108.0" text-anchor="middle" font-size="16" font-weight="700" fill="#c2410c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6 × 3</text><text x="94.0" y="20.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><text x="178.0" y="20.0" text-anchor="middle" font-size="14" font-weight="700" fill="#c2410c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><path d="M32 30 V174" stroke="#1f2937" stroke-width="2"/><text x="20.0" y="107.0" text-anchor="middle" font-size="16" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><text x="160.0" y="186.0" text-anchor="middle" font-size="15" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">24 + 18 = 42</text><text x="268.0" y="90.0" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6 × 7</text><text x="268.0" y="112.0" text-anchor="middle" font-size="15" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">= 42</text></svg>
:::

> 🗡️ التوزيعية حيلةٌ للحساب الذهنيّ: 7 × 8 = 7 × (10 − 2)? لا، نبقى في الجمع: 7 × 8 = 7 × (4 + 4) = 28 + 28 = 56.

## ⚡ الضرب في 10 و100 و1000 وفي عقدٍ كامل

هذا أسهل ضربٍ على الإطلاق، فنُضيف أصفارًا على **يمين** العدد:

| العملية | نُضيف        | مثال             |
| ------- | ------------ | ---------------- |
| × 10    | صفرًا واحدًا | 7 × 10 = 70      |
| × 100   | صفرين        | 7 × 100 = 700    |
| × 1000  | ثلاثة أصفار  | 7 × 1000 = 7 000 |

- وللضرب في **عقدٍ كامل** (20 ; 30…) نضرب في الرقم ثمّ نُضيف صفرًا، لأنّ 30 = 3 × 10: مثلًا 8 × 30 = 8 × 3 ثمّ صفر = 240.
- وكذلك في **مئةٍ كاملة**: 8 × 300 = 24 ثمّ صفران = 2 400. وفي **ألفٍ كامل**: 6 × 1000 = 6 000.

## 🔱 تقنية الضرب في عددٍ من رقمٍ واحد (مع الاحتفاظ)

نضرب رقمًا رقمًا من **اليمين إلى اليسار**، وإذا تجاوز الجداء 9 نكتب رقم الآحاد و**نحتفظ** بالعشرات للرتبة الموالية.

_مثال محسوب:_ نحسب 234 × 3.

- الآحاد: 3 × 4 = 12، نكتب 2 ونحتفظ بـ 1.
- العشرات: 3 × 3 = 9، نضيف الاحتفاظ 1 → 10، نكتب 0 ونحتفظ بـ 1.
- المئات: 3 × 2 = 6، نضيف الاحتفاظ 1 → 7.

$$234 × 3 = 702$$

> ⚠️ الفخّ الشائع: **نسيان الاحتفاظ**. في 47 × 6 نحسب الآحاد 6 × 7 = 42 (نكتب 2 ونحتفظ بـ 4)، ثمّ العشرات 6 × 4 = 24 ونضيف الاحتفاظ 4 → 28؛ فالجداء 282 لا 242.

> 🏆 لقد عبرت بوّابة الضرب وخاصياته! صرت تعرف معناه ومفرداته، وتُتقن التبديلية والتجميعية والتوزيعية، وتضرب في 10 و100 و1000، وتطبّق تقنية الضرب في عددٍ من رقمٍ واحد مع الاحتفاظ. استعدّ الآن للبوّابة الموالية حيث ندخل عالَم **الشبكة والمسالك والمضلّعات**!', '# 📜 ملخّص: الضرب وخاصياته

- **الضرب جمعٌ متكرّر:** 4 × 3 = 3 + 3 + 3 + 3 = 12؛ العددان عاملان والنتيجة جداء.
- **الجداول:** نحفظها لنحسب بسرعة؛ a × 0 = 0 وa × 1 = a دائمًا؛ **ضِعف** عددٍ هو جداؤه في 2.
- **التبديلية:** a × b = b × a، مثل 8 × 5 = 5 × 8 = 40 (الترتيب لا يُغيّر الجداء).
- **التجميعية:** (a × b) × c = a × (b × c)، مثل 2 × 3 × 5 = 6 × 5 = 30 (نبدأ بالأسهل).
- **التوزيعية على الجمع:** a × (b + c) = a × b + a × c، مثل 6 × (4 + 3) = 24 + 18 = 42.
- **الضرب في 10 و100 و1000:** نُضيف صفرًا أو صفرين أو ثلاثة أصفار على اليمين (7 × 1000 = 7 000).
- **الضرب في عقد/مئة/ألف كاملة:** نضرب في الرقم ثمّ نُضيف الأصفار، مثل 8 × 30 = 240.
- **تقنية الضرب في رقمٍ واحد:** نضرب من اليمين رقمًا رقمًا ونحتفظ بالعشرات للرتبة الموالية، مثل 234 × 3 = 702.
- **الفخّ:** نسيان الاحتفاظ، مثل 47 × 6 = 282 لا 242.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'math-3eme', 'الشبكة والمسالك والمضلّعات', 'الشبكة وعُقدها وخاناتها وأسطرها وأعمدتها، تحديد موضع عقدة بزوج (سطر، عمود)، رسم المسالك على الشبكة وعدّ خطواتها والمسالك المتكافئة، ورسم المضلّعات وتصنيفها حسب عدد الأضلاع (مثلّث، رباعي، خماسي، سداسي) وعدّ أضلاعها ورؤوسها', '# ⚔️ الشبكة والمسالك والمضلّعات — خريطة المغامرة

> 💡 «من يقرأ الشبكة جيّدًا لا يضيع أبدًا: كلّ عقدةٍ لها عنوان، وكلّ مسلكٍ له خطوات.»

أهلًا أيّها البطل! تعلّمت في الفصل السابق **الضرب وخاصياته**. اليوم ندخل عالم **الشبكة**: لوحةٌ من خطوطٍ أفقيّةٍ وعموديّة تشبه خريطة كنز. عليها نحدّد المواضع، ونرسم **مسالك** (طُرقًا)، ونرسم **مضلّعات** (أشكالًا مغلقة) ونعدّ أضلاعها. هيّا نتعلّم لغة الخريطة!

## 🗺️ ما هي الشبكة؟ العُقد والخانات

**الشبكة** خطوطٌ مستقيمة: بعضها **أفقيّ** (الأسطر) وبعضها **عموديّ** (الأعمدة).

- **العُقدة**: النقطة التي يلتقي فيها خطّان (تقاطُع سطرٍ مع عمود). نعلّمها بنقطةٍ سوداء.
- **الخانة** (المربّع): المساحة المحصورة بين خطّين وخطّين، أي «صندوق» صغير.

> 🗡️ الحيلة: **العُقدة نقطة** على التقاطع، أمّا **الخانة مساحة** بين الخطوط. لا تخلط بينهما!

هذه شبكةٌ صغيرة: النقاط السوداء عُقد، والمساحات بينها خانات.

<svg viewBox="0 0 120 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="1.2" fill="none">
    <line x1="20" y1="20" x2="100" y2="20"/>
    <line x1="20" y1="50" x2="100" y2="50"/>
    <line x1="20" y1="80" x2="100" y2="80"/>
    <line x1="20" y1="20" x2="20" y2="80"/>
    <line x1="60" y1="20" x2="60" y2="80"/>
    <line x1="100" y1="20" x2="100" y2="80"/>
  </g>
  <g fill="#1f2937">
    <circle cx="20" cy="20" r="3"/>
    <circle cx="60" cy="20" r="3"/>
    <circle cx="100" cy="20" r="3"/>
    <circle cx="20" cy="50" r="3"/>
    <circle cx="60" cy="50" r="3"/>
    <circle cx="100" cy="50" r="3"/>
    <circle cx="20" cy="80" r="3"/>
    <circle cx="60" cy="80" r="3"/>
    <circle cx="100" cy="80" r="3"/>
  </g>
  <text x="40" y="38" fill="#1f2937" font-size="9" text-anchor="middle">خانة</text>
</svg>

## 📍 موضع عقدة: زوج (سطر، عمود)

لنعرف مكان عقدةٍ بدقّة نستعمل **زوجًا**: أوّلًا **السطر** (نعدّ الأسطر من الأعلى إلى الأسفل: 1، 2، 3…)، ثمّ **العمود** (نعدّ الأعمدة من اليسار إلى اليمين: 1، 2، 3…). نكتب الزوج هكذا: (سطر، عمود).

في الشبكة التالية، العقدة المعلّمة في السطر 2 والعمود 3، إذن موضعها **(2 ; 3)**.

<svg viewBox="0 0 130 120" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="1" fill="none">
    <line x1="30" y1="25" x2="110" y2="25"/>
    <line x1="30" y1="55" x2="110" y2="55"/>
    <line x1="30" y1="85" x2="110" y2="85"/>
    <line x1="30" y1="25" x2="30" y2="85"/>
    <line x1="50" y1="25" x2="50" y2="85"/>
    <line x1="70" y1="25" x2="70" y2="85"/>
    <line x1="90" y1="25" x2="90" y2="85"/>
    <line x1="110" y1="25" x2="110" y2="85"/>
  </g>
  <text x="20" y="28" fill="#1f2937" font-size="8" text-anchor="end">1</text>
  <text x="20" y="58" fill="#1f2937" font-size="8" text-anchor="end">2</text>
  <text x="20" y="88" fill="#1f2937" font-size="8" text-anchor="end">3</text>
  <text x="30" y="18" fill="#1f2937" font-size="8" text-anchor="middle">1</text>
  <text x="50" y="18" fill="#1f2937" font-size="8" text-anchor="middle">2</text>
  <text x="70" y="18" fill="#1f2937" font-size="8" text-anchor="middle">3</text>
  <text x="90" y="18" fill="#1f2937" font-size="8" text-anchor="middle">4</text>
  <text x="110" y="18" fill="#1f2937" font-size="8" text-anchor="middle">5</text>
  <circle cx="70" cy="55" r="4" fill="#1f2937"/>
  <text x="78" y="52" fill="#1f2937" font-size="9">(2 ; 3)</text>
</svg>

> ⚠️ الفخّ: لا تعكس الترتيب! نقرأ **السطر أوّلًا ثمّ العمود**. العقدة (2 ; 3) غير العقدة (3 ; 2).

## 🚶 المسالك: ارسمها واعدد خطواتها

**المسلك** طريقٌ على الشبكة من عقدةٍ إلى أخرى، يسير على الخطوط من عقدةٍ إلى العقدة المجاورة. كلّ انتقالٍ بين عقدتين متجاورتين هو **خطوة واحدة**.

نعدّ **طول المسلك** بعدد خطواته. في المسلك السميك التالي نعدّ القطع: يمين، يمين، نزول — أي **3 خطوات**.

<svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#9ca3af" stroke-width="0.8" fill="none">
    <line x1="20" y1="25" x2="100" y2="25"/>
    <line x1="20" y1="55" x2="100" y2="55"/>
    <line x1="20" y1="85" x2="100" y2="85"/>
    <line x1="20" y1="25" x2="20" y2="85"/>
    <line x1="60" y1="25" x2="60" y2="85"/>
    <line x1="100" y1="25" x2="100" y2="85"/>
  </g>
  <polyline points="20,25 60,25 100,25 100,55" fill="none" stroke="#1f2937" stroke-width="3"/>
  <g fill="#1f2937">
    <circle cx="20" cy="25" r="3.5"/>
    <circle cx="100" cy="55" r="3.5"/>
  </g>
  <text x="14" y="22" fill="#1f2937" font-size="9" text-anchor="end">A</text>
  <text x="106" y="58" fill="#1f2937" font-size="9">B</text>
</svg>

> 🗡️ الحيلة: لعدّ الخطوات، عدّ **القطع** بين العُقد على المسلك، لا العُقد نفسها. مسلكٌ يمرّ بـ 4 عُقد فيه 3 خطوات.

## 🔀 المسالك المتكافئة

من نقطةٍ إلى نقطةٍ أخرى توجد **عدّة مسالك**. إذا كان لمسلكين **نفس عدد الخطوات** نقول إنّهما **متكافئان** (متساويان في الطول)، حتّى لو اختلف شكلهما.

هنا مسلكان من A إلى B: المسلك العلويّ والمسلك السفليّ، وكلاهما **4 خطوات** — إذن هما **متكافئان**.

<svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#9ca3af" stroke-width="0.8" fill="none">
    <line x1="20" y1="30" x2="120" y2="30"/>
    <line x1="20" y1="60" x2="120" y2="60"/>
    <line x1="20" y1="90" x2="120" y2="90"/>
    <line x1="20" y1="30" x2="20" y2="90"/>
    <line x1="70" y1="30" x2="70" y2="90"/>
    <line x1="120" y1="30" x2="120" y2="90"/>
  </g>
  <polyline points="20,60 20,30 70,30 120,30 120,60" fill="none" stroke="#1f2937" stroke-width="2.6"/>
  <polyline points="20,60 20,90 70,90 120,90 120,60" fill="none" stroke="#1f2937" stroke-width="2.6" stroke-dasharray="5,3"/>
  <g fill="#1f2937">
    <circle cx="20" cy="60" r="3.5"/>
    <circle cx="120" cy="60" r="3.5"/>
  </g>
  <text x="14" y="63" fill="#1f2937" font-size="9" text-anchor="end">A</text>
  <text x="126" y="63" fill="#1f2937" font-size="9">B</text>
</svg>

## 🔺 المضلّعات: خطٌّ منكسرٌ مغلق

**المضلّع** شكلٌ مغلق مكوّنٌ من خطوطٍ مستقيمة (خطّ منكسر **مغلق**: يبدأ وينتهي في نفس النقطة). كلّ قطعةٍ مستقيمة **ضلع**، وكلّ نقطة التقاءٍ بين ضلعين **رأس**. في المضلّع **عدد الأضلاع يساوي عدد الرؤوس**.

نصنّف المضلّعات حسب **عدد أضلاعها**:

| المضلّع | عدد الأضلاع | عدد الرؤوس |
| ------- | ----------- | ---------- |
| مثلّث   | 3           | 3          |
| رباعيّ  | 4           | 4          |
| خماسيّ  | 5           | 5          |
| سداسيّ  | 6           | 6          |

هذا **خماسيّ** (5 أضلاع و5 رؤوس) مرسومٌ على الشبكة:

<svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#9ca3af" stroke-width="0.8" fill="none">
    <line x1="20" y1="20" x2="100" y2="20"/>
    <line x1="20" y1="50" x2="100" y2="50"/>
    <line x1="20" y1="80" x2="100" y2="80"/>
    <line x1="20" y1="20" x2="20" y2="80"/>
    <line x1="60" y1="20" x2="60" y2="80"/>
    <line x1="100" y1="20" x2="100" y2="80"/>
  </g>
  <polygon points="60,20 100,50 80,80 40,80 20,50" fill="none" stroke="#1f2937" stroke-width="2.4"/>
  <g fill="#1f2937">
    <circle cx="60" cy="20" r="3"/>
    <circle cx="100" cy="50" r="3"/>
    <circle cx="80" cy="80" r="3"/>
    <circle cx="40" cy="80" r="3"/>
    <circle cx="20" cy="50" r="3"/>
  </g>
</svg>

> ⚠️ الفخّ: لعدّ الأضلاع، عدّ **القطع المستقيمة**؛ ولعدّ الرؤوس، عدّ **النقاط** (الزوايا). في المضلّع المغلق العددان متساويان دائمًا.

## 🧮 كيف نسمّي المضلّع؟ عدّ الأضلاع

لتعرف اسم مضلّع، عدّ أضلاعه واحدًا واحدًا (ضع علامةً على كلّ ضلعٍ عددته):

- **3 أضلاع** ← مثلّث
- **4 أضلاع** ← رباعيّ
- **5 أضلاع** ← خماسيّ
- **6 أضلاع** ← سداسيّ

_مثال:_ شكلٌ مغلقٌ عدّينا له 4 قطعًا مستقيمة، إذن هو **رباعيّ** وله **4 رؤوس** أيضًا (لأنّ عدد الأضلاع = عدد الرؤوس).

> 🏆 أحسنت أيّها البطل! صرت تقرأ موضع عقدةٍ بزوج (سطر، عمود)، وترسم المسالك وتعدّ خطواتها، وتميّز المسالك المتكافئة، وترسم المضلّعات وتصنّفها حسب أضلاعها. في الفصل القادم نفتح بوّابة **الزوايا** — استعدّ!', '# 📜 ملخّص: الشبكة والمسالك والمضلّعات

- **الشبكة**: خطوطٌ أفقيّة (أسطر) وعموديّة (أعمدة). **العقدة** نقطةُ تقاطُع، و**الخانة** مساحةٌ بين الخطوط.
- **موضع عقدة**: زوج (سطر، عمود) — نقرأ السطر أوّلًا (من الأعلى) ثمّ العمود (من اليسار)؛ (2 ; 3) ≠ (3 ; 2).
- **المسلك**: طريقٌ على الخطوط بين عقدتين؛ **طوله = عدد خطواته** (نعدّ القطع بين العُقد، لا العُقد).
- **المسالك المتكافئة**: مسلكان لهما **نفس عدد الخطوات** متكافئان حتّى لو اختلف شكلهما.
- **المضلّع**: خطٌّ منكسرٌ **مغلق**؛ الضلع قطعةٌ مستقيمة، والرأس نقطة التقاء ضلعين.
- **التصنيف بعدد الأضلاع**: مثلّث (3)، رباعيّ (4)، خماسيّ (5)، سداسيّ (6).
- في كلّ مضلّع: **عدد الأضلاع = عدد الرؤوس**.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('aae294cb-a57b-52df-a9df-f9f19e7580c2', 'math-3eme', 'الزوايا', 'مفهوم الزاوية ورأسها وضلعيها، والتعرّف على الزاوية ورسمها، والزاوية القائمة واستعمال الكوس للتحقّق منها، وتصنيف الزوايا بالمقارنة مع القائمة إلى قائمة وحادّة ومنفرجة، ورسم الزوايا حسب نوعها، والتعرّف على الزوايا في الأشكال ومن حولنا', '# ⚔️ الزوايا — أركان مملكة الأشكال

> 💡 «كلّ زاويةٍ تحكي قصّة فتحةٍ بين ضلعين: قِسْها بعينك تعرف نوعها.»

أهلًا بك أيّها البطل! في المغامرة السابقة رسمتَ **المضلّعات** وعددتَ أضلاعها ورؤوسها. عند كلّ رأسٍ تختبئ **زاوية**: ركنُ الباب، وزاوية المسطرة، وفتحة المقصّ. اليوم نتعلّم ما هي الزاوية، ونميّز ثلاثة أنواع: **قائمة** و**حادّة** و**منفرجة** — كلّها بالنظر والمقارنة، بلا قياسٍ بالأرقام.

## 🏰 ما هي الزاوية؟

عندما ينطلق **نصفا مستقيمٍ** (ضلعان) من **نقطةٍ واحدة**، يصنعان **زاوية**.

- النقطة المشتركة تُسمّى **رأس الزاوية** (le sommet).
- نصفا المستقيم يُسمّيان **ضلعَي الزاوية** (les côtés).
- **الزاوية هي الفتحة بين الضلعين** عند الرأس.

> 🗡️ الحيلة: افتح كتابك قليلًا أو كثيرًا. الكتاب نفسه لم يتغيّر، لكنّ **الفتحة** بين دفّتيه تتغيّر — تلك هي الزاوية!

## 📏 طول الضلعين لا يغيّر الزاوية

هذه أهمّ فكرة في الدرس: الزاوية هي **اتّساع الفتحة**، لا طول الضلعين. لو مدَدْنا الضلعين أو قصّرناهما، تبقى **الزاوية نفسها**.

ها هي زاويتان لهما نفس الفتحة، لكنّ ضلعَي الثانية أطول:

<svg viewBox="0 0 220 90" xmlns="http://www.w3.org/2000/svg"><line x1="15" y1="75" x2="80" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="15" y1="75" x2="62" y2="33" stroke="currentColor" stroke-width="2.5"/><circle cx="15" cy="75" r="3" fill="currentColor"/><line x1="135" y1="75" x2="210" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="135" y1="75" x2="190" y2="26" stroke="currentColor" stroke-width="2.5"/><circle cx="135" cy="75" r="3" fill="currentColor"/></svg>

> ⚠️ الفخّ الأكبر: لا تظنّ أنّ الزاوية ذات الضلعين الطويلين «أكبر». **طول الضلعين لا يهمّ**؛ المهمّ هو **اتّساع الفتحة** فقط.

## 🛡️ الزاوية القائمة والكوس

**الزاوية القائمة** (angle droit) هي الزاوية التي نراها في **ركن الورقة** أو **ركن الطاولة**: ضلعاها متعامدان تمامًا، لا منفتحان كثيرًا ولا قليلًا. نضع عند رأسها **مربّعًا صغيرًا** علامةً عليها.

نتحقّق منها بأداةٍ اسمها **الكوس** (l''équerre): نطابق ركن الكوس على رأس الزاوية وضلعيها. إن انطبق تمامًا فالزاوية **قائمة**.

<svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="20" y2="10" stroke="currentColor" stroke-width="2.5"/><polyline points="20,58 37,58 37,75" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="20" cy="75" r="3" fill="currentColor"/></svg>

> 🗡️ الكوس هو سيفك: كلّما شككتَ في زاوية، طابِق عليها ركن الكوس لتعرف أهي قائمة أم لا.

## 🔮 الزاوية الحادّة والزاوية المنفرجة

نصنّف باقي الزوايا **بمقارنتها بالزاوية القائمة**:

- **الزاوية الحادّة** (angle aigu): فتحتها **أصغر من القائمة** (الضلعان قريبان من بعضهما). مثل رأس قلم الرصاص المبرى.
- **الزاوية المنفرجة** (angle obtus): فتحتها **أكبر من القائمة** (الضلعان منفتحان كثيرًا). مثل مسند الكرسي المائل للخلف.

هاتان زاويتان: الأولى حادّة (فتحة ضيّقة)، والثانية منفرجة (فتحة واسعة):

<svg viewBox="0 0 220 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="80" y2="38" stroke="currentColor" stroke-width="2.5"/><circle cx="20" cy="75" r="3" fill="currentColor"/><line x1="130" y1="75" x2="205" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="130" y1="75" x2="150" y2="18" stroke="currentColor" stroke-width="2.5"/><circle cx="130" cy="75" r="3" fill="currentColor"/></svg>

> ⚠️ الفخّ: لا تخلط بين الحادّة والمنفرجة. **الحادّة أضيق من ركن الورقة، والمنفرجة أوسع منه**. القائمة هي الميزان بينهما.

## 📐 جدول أنواع الزوايا

قارِن دائمًا بالزاوية القائمة (ركن الورقة):

| نوع الزاوية | الفتحة مقارنةً بالقائمة | مثال من حولنا |
| ----------- | ---------------------- | ------------- |
| حادّة       | **أصغر** من القائمة    | رأس قلمٍ مبري |
| قائمة       | **تساوي** القائمة (ركن الورقة) | ركن الطاولة |
| منفرجة      | **أكبر** من القائمة    | مسند كرسيٍّ مائل |

## 🧭 الزوايا من حولنا

انظر حولك تَجِد الزوايا في كلّ مكان:

- **زوايا قائمة**: أركان الباب، النافذة، الكتاب، البلاطة (كلّها قوائم).
- **زوايا حادّة**: رأس قطعة بيتزا، فتحة مقصٍّ مغلق قليلًا، رأس نجمة.
- **زوايا منفرجة**: عقارب الساعة في تمام الساعة الخامسة، سقف بيتٍ مائل، مروحة مفتوحة.

> 🗡️ تدرّب على الرسم: ارسم نقطةً (الرأس)، ثمّ نصفَي مستقيمٍ منها. قرِّب الضلعين لزاويةٍ حادّة، أو باعِد بينهما لزاويةٍ منفرجة، أو استعمل الكوس لزاويةٍ قائمة.

> 🏆 أحسنت أيّها البطل! صرتَ تعرف رأس الزاوية وضلعيها، وتميّز القائمة بالكوس، وتصنّف الحادّة والمنفرجة بالمقارنة معها. في المغامرة القادمة سنستعمل الزوايا القائمة لنبني **المستطيل والمربّع** ونحسب **المحيط**. استعدّ!', '# 📜 ملخّص: الزوايا

- **الزاوية**: فتحةٌ بين **ضلعين** (نصفَي مستقيم) ينطلقان من نقطةٍ واحدة هي **الرأس**.
- **طول الضلعين لا يغيّر الزاوية**: المهمّ اتّساع الفتحة فقط، لا طول الأضلاع.
- **الزاوية القائمة**: ركن الورقة أو الطاولة، نعلّمها بمربّعٍ صغير، ونتحقّق منها بـ**الكوس**.
- **الزاوية الحادّة**: فتحتها **أصغر** من القائمة (الضلعان قريبان) — مثل رأس قلمٍ مبري.
- **الزاوية المنفرجة**: فتحتها **أكبر** من القائمة (الضلعان منفتحان) — مثل مسند كرسيٍّ مائل.
- **التصنيف بالمقارنة مع القائمة فقط**: حادّة أصغر، منفرجة أكبر، والقائمة هي الميزان (بلا قياسٍ بالأرقام).
- **الزوايا من حولنا**: أركان الباب والكتاب قوائم، رأس البيتزا حادّة، عقارب الساعة الخامسة منفرجة.
- **الرسم**: نقطةٌ (رأس) ثمّ ضلعان؛ نقرّبهما لزاويةٍ حادّة، أو نباعد لمنفرجة، أو نستعمل الكوس لقائمة.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', 'math-3eme', 'المستطيل والمربّع والمحيط', 'خاصيات المستطيل والمربّع والعلاقة بينهما، ومفهوم المحيط: محيط المضلّع مجموع أطوال أضلاعه، وحساب محيط المربّع (الضلع × 4) ومحيط المستطيل ((الطول + العرض) × 2) بأطوالٍ صحيحةٍ ووحداتٍ قياسية (cm، m)', '# ⚔️ المستطيل والمربّع والمحيط — أسوار المملكة

> 💡 «من يعرف أضلاع شكله يعرف طول السور الذي يحيط به.»

أهلًا بك أيّها البطل! في المغامرة الماضية تعلّمت **الزوايا**، وعرفت **الزاوية القائمة**. اليوم نبني بها شكلين قويّين: **المستطيل** و**المربّع**. ثم نتعلّم **المحيط**: طول الخطّ الذي يحيط بالشكل، تمامًا كالسور الذي يحيط بالقلعة. مع هذا السلاح تحسب طول السياج حول الحديقة، وطول الإطار حول الصورة.

## 🏰 المستطيل وخاصياته

**المستطيل** شكلٌ له **4 أضلاع** و**4 زوايا قائمة** (كلّ زواياه قائمة). أضلاعه ليست كلّها متساوية: **الأضلاع المتقابلة متساوية** فقط، فله ضلعان طويلان متساويان (**الطول**) وضلعان قصيران متساويان (**العرض**). الباب والكتاب مستطيلان.

<svg viewBox="0 0 140 90" xmlns="http://www.w3.org/2000/svg"><rect x="20" y="20" width="100" height="50" fill="none" stroke="currentColor" stroke-width="2"/><path d="M20 32 L32 32 L32 20" fill="none" stroke="currentColor" stroke-width="1.5"/><text x="70" y="14" font-size="11" fill="currentColor" text-anchor="middle">8 cm</text><text x="10" y="48" font-size="11" fill="currentColor" text-anchor="middle">4 cm</text></svg>

في هذه الصورة: **الطول** = 8 cm و**العرض** = 4 cm، والزاوية القائمة معلّمة في الرّكن.

## 🛡️ المربّع وخاصياته

**المربّع** شكلٌ له **4 أضلاع متساوية** (كلّ الأضلاع لها نفس الطول) و**4 زوايا قائمة**. بلاطة الأرض مربّع. يكفي أن تعرف **ضلعًا واحدًا** لتعرف كلّ أضلاعه.

<svg viewBox="0 0 110 100" xmlns="http://www.w3.org/2000/svg"><rect x="25" y="20" width="60" height="60" fill="none" stroke="currentColor" stroke-width="2"/><path d="M25 32 L37 32 L37 20" fill="none" stroke="currentColor" stroke-width="1.5"/><text x="55" y="14" font-size="11" fill="currentColor" text-anchor="middle">5 cm</text><text x="14" y="53" font-size="11" fill="currentColor" text-anchor="middle">5 cm</text></svg>

هنا **الضلع** = 5 cm، وكلّ الأضلاع الأربعة طولها 5 cm.

## 🔮 العلاقة بين المربّع والمستطيل

انتبه أيّها البطل: **المربّع حالة خاصّة من المستطيل**. لماذا؟ لأنّ للمربّع **4 زوايا قائمة** مثل المستطيل، وأضلاعه المتقابلة متساوية مثل المستطيل، **وزيادةً** كلّ أضلاعه متساوية. فكلّ مربّعٍ هو مستطيل، لكن ليس كلّ مستطيلٍ مربّعًا.

| الخاصية              | المستطيل                  | المربّع                  |
| -------------------- | ------------------------- | ------------------------ |
| عدد الأضلاع           | 4                         | 4                        |
| عدد الزوايا القائمة   | 4                         | 4                        |
| الأضلاع المتساوية     | المتقابلة فقط (طول وعرض)  | كلّها متساوية            |

> ⚠️ الفخّ: المستطيل والمربّع كلاهما له 4 أضلاع و4 زوايا قائمة. الفرق الوحيد: في المربّع **كلّ** الأضلاع متساوية، أمّا في المستطيل فضلعان طويلان (الطول) وضلعان قصيران (العرض).

## 🧮 ما هو المحيط؟

**المحيط** هو **مجموع أطوال أضلاع** الشكل، أي طول الخطّ الذي يحيط به. تخيّل نملةً تمشي على حافّة الشكل حتى تعود إلى نقطة البداية: الطريق الذي قطعته هو المحيط. نقيسه بوحدات الطول مثل **cm** و**m**.

$$ محيط المضلّع = مجموع أطوال أضلاعه $$

*مثال:* مثلّثٌ أضلاعه 3 cm و4 cm و5 cm، محيطه = 3 + 4 + 5 = 12 cm.

> 🗡️ الحيلة: لحساب المحيط، **دُر حول الشكل** واجمع كلّ ضلعٍ تمرّ به، ولا تنسَ أيّ ضلع.

## 📐 محيط المربّع ومحيط المستطيل

**محيط المربّع:** كلّ أضلاعه متساوية، فبدل أن نجمع الضلع 4 مرّات، نضربه في 4.

$$ محيط المربّع = الضلع × 4 $$

*مثال محسوب:* مربّعٌ ضلعه 5 cm. محيطه = 5 × 4 = 20 cm. ✓ (أو 5 + 5 + 5 + 5 = 20 cm.)

**محيط المستطيل:** له طولان متساويان وعرضان متساويان. نجمع الأضلاع الأربعة، أو نجمع الطول مع العرض ثم نضرب في 2.

$$ محيط المستطيل = (الطول + العرض) × 2 $$

*مثال محسوب:* مستطيلٌ طوله 8 cm وعرضه 4 cm. محيطه = (8 + 4) × 2 = 12 × 2 = 24 cm. ✓ (أو 8 + 4 + 8 + 4 = 24 cm.)

> ⚠️ الفخّ الشائع: في المستطيل لا تجمع الطول والعرض مرّةً واحدة فقط! للمستطيل **ضلعان** بطول الطول و**ضلعان** بطول العرض، فلا بدّ من الضرب في 2 (أو جمع الأضلاع الأربعة كلّها).

> 🏆 أحسنت أيّها البطل! صرت تميّز المستطيل من المربّع، وتعرف أنّ المربّع حالة خاصّة منه، وتحسب محيط أيّ مربّعٍ أو مستطيل. في المغامرة القادمة — **القيس: النقود والأطوال والسعات والزمن** — ستقيس هذه الأطوال بنفسك بالـ cm والـ m. استعدّ!', '# 📜 ملخّص: المستطيل والمربّع والمحيط

- **المستطيل**: له 4 أضلاع و4 زوايا قائمة، والأضلاع المتقابلة فقط متساوية (طولٌ وعرض).
- **المربّع**: له 4 أضلاع متساوية كلّها و4 زوايا قائمة (يكفي معرفة ضلعٍ واحد).
- **العلاقة بينهما**: المربّع حالة خاصّة من المستطيل (كلّ مربّعٍ مستطيل، وليس العكس)؛ الفرق أنّ كلّ أضلاع المربّع متساوية.
- **المحيط**: مجموع أطوال أضلاع الشكل، أي طول الخطّ المحيط به، يُقاس بـ cm أو m.
- **محيط المربّع** = الضلع × 4 (مثال: ضلع 5 cm ← المحيط 20 cm).
- **محيط المستطيل** = (الطول + العرض) × 2، أو جمع الأضلاع الأربعة (مثال: 8 cm و4 cm ← المحيط 24 cm).
- **الفخّ**: في المستطيل اضرب في 2 (ضلعان للطول وضلعان للعرض)، ولا تجمع الطول والعرض مرّةً واحدة فقط.', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7', 'math-3eme', 'القيس: النقود والأطوال والسعات والزمن', 'النقود بالدينار (د) والمليم والعلاقة 1 د = 1000 مليم وتأدية المبلغ وحساب الباقي؛ الأطوال (m، dm، cm، mm، km) والعلاقة العشرية وتحويلاتها؛ السعات باللتر (L) وتحويلاتها؛ والزمن (اليوم والأسبوع والشهر والسنة وقراءة الساعة وتحويلات الزمن البسيطة)', '# ⚔️ القيس: النقود والأطوال والسعات والزمن — مغامرة الكنز الأخير

> 💡 «من يُتقن القيس يَعرف كم يدفع، وكم يبعُد، وكم يَسَع، وكم بقي من الوقت.»

أهلًا أيّها البطل! وصلتَ إلى **آخر مغامرة** في رحلة السنة الثالثة. هنا نجمع أربعة سلاحٍ نستعملها كلّ يوم: **النقود** عند الشراء، و**الأطوال** للقياس، و**السعات** للسوائل، و**الزمن** لتنظيم يومنا. لكلِّ واحدةٍ **وحداتٌ** وعلاقاتٌ نتعلّمها الآن.

## 🪙 النقود: الدينار والمليم

في تونس نتعامل بوحدتين: **الدينار (د)** و**المليم**. والعلاقة بينهما يجب أن تحفظها:

$$1 د = 1000 مليم$$

نشتري بـ **القطع النقديّة** (1 د، 2 د، 5 د) وبـ **الورقة الماليّة** (5 د). عند الشراء نقوم بأمرين:

- **تأدية المبلغ:** نختار قطعًا مجموعُها يساوي الثمن. _مثال:_ ثمنُ لعبةٍ 7 د، نؤدّيه بـ **5 د + 2 د**.
- **حساب الباقي:** إذا أدّينا أكثر من الثمن، يَرُدّ لنا البائع الفرق. _مثال محسوب:_ ثمنُ كتابٍ 6 د ودفعنا ورقة 5 د + قطعة 2 د = 7 د، فالباقي = 7 د − 6 د = **1 د**.

::: figure الباقي = ما دفعناه − الثمن
<svg viewBox="0 0 340 130"><circle cx="44" cy="50" r="24" fill="#fbbf24" stroke="#1f2937" stroke-width="2.4"/><circle cx="44" cy="50" r="20" fill="none" stroke="#f59e0b" stroke-width="1.5"/><text x="44.0" y="55.0" text-anchor="middle" font-size="12" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5 د</text><text x="84.0" y="58.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">+</text><circle cx="124" cy="50" r="20" fill="#fbbf24" stroke="#1f2937" stroke-width="2.4"/><circle cx="124" cy="50" r="16" fill="none" stroke="#f59e0b" stroke-width="1.5"/><text x="124.0" y="55.0" text-anchor="middle" font-size="12" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2 د</text><text x="84.0" y="96.0" text-anchor="middle" font-size="12" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">دفعنا 7 د</text><text x="172.0" y="58.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">−</text><rect x="192" y="28" width="42" height="46" rx="4" fill="#93c5fd" stroke="#1f2937" stroke-width="2.4"/><path d="M192 40 H234" stroke="#1f2937" stroke-width="1.6"/><text x="213.0" y="96.0" text-anchor="middle" font-size="12" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">الثمن 6 د</text><text x="254.0" y="58.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">=</text><circle cx="298" cy="50" r="20" fill="#fbbf24" stroke="#1f2937" stroke-width="2.4"/><circle cx="298" cy="50" r="16" fill="none" stroke="#f59e0b" stroke-width="1.5"/><text x="298.0" y="55.0" text-anchor="middle" font-size="12" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1 د</text><text x="298.0" y="96.0" text-anchor="middle" font-size="13" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">الباقي</text></svg>
:::

> 🗡️ الباقي = المبلغ المدفوع − الثمن. احسبه دائمًا بطرحٍ بسيط، وتحقّق أنّ (الثمن + الباقي) يساوي ما دفعتَ.

## 📏 الأطوال: من المليمتر إلى الكيلومتر

وحدةُ الطول الأساسيّة هي **المتر (m)**. له أجزاءٌ أصغر منه ومضاعفٌ أكبر منه:

| الوحدة    | الرمز | العلاقة بالمتر |
| --------- | ----- | -------------- |
| الكيلومتر | km    | 1 km = 1000 m  |
| المتر     | m     | 1 m            |
| الدسيمتر  | dm    | 1 m = 10 dm    |
| الصنتيمتر | cm    | 1 m = 100 cm   |
| المليمتر  | mm    | 1 m = 1000 mm  |

نقيس بالـ **mm** و**cm** الأشياء الصغيرة (قلم، دفتر)، وبالـ **m** الأشياء الكبيرة (باب، طاولة)، وبالـ **km** المسافات الطويلة بين المُدن.

> 🗡️ كلَّما نزلنا درجةً (m → dm → cm → mm) **نضرب في 10**، وكلَّما صعدنا درجةً **نقسم على 10**. فمثلًا 5 cm = 5 × 10 = 50 mm.

::: figure سُلّم الأطوال: بين m وdm وcm وmm نضرب في 10 عند كلّ درجة — أمّا بين km وm فالمعامل 1000
<svg viewBox="0 0 340 170"><rect x="-2" y="30" width="44" height="26" rx="4" fill="#fde68a" stroke="#1f2937" stroke-width="2"/><text x="20.0" y="48.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">km</text><rect x="74" y="66" width="44" height="26" rx="4" fill="#fde68a" stroke="#1f2937" stroke-width="2"/><text x="96.0" y="84.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">m</text><rect x="150" y="96" width="44" height="26" rx="4" fill="#fde68a" stroke="#1f2937" stroke-width="2"/><text x="172.0" y="114.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">dm</text><rect x="214" y="118" width="44" height="26" rx="4" fill="#fde68a" stroke="#1f2937" stroke-width="2"/><text x="236.0" y="136.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">cm</text><rect x="274" y="140" width="44" height="26" rx="4" fill="#fde68a" stroke="#1f2937" stroke-width="2"/><text x="296.0" y="158.0" text-anchor="middle" font-size="14" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">mm</text><path d="M42 46 L74 66" stroke="#dc2626" stroke-width="2.5"/><path d="M78 68 l-12 -2 l4 -8 z" fill="#dc2626"/><text x="64.0" y="40.0" text-anchor="middle" font-size="12" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">× 1000</text><path d="M120 82 L146 104" stroke="#16a34a" stroke-width="2.2"/><path d="M150 106 l-11 -3 l3 -8 z" fill="#16a34a"/><text x="136.0" y="83.0" text-anchor="middle" font-size="11" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">× 10</text><path d="M196 112 L210 126" stroke="#16a34a" stroke-width="2.2"/><path d="M214 128 l-11 -3 l3 -8 z" fill="#16a34a"/><text x="206.0" y="109.0" text-anchor="middle" font-size="11" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">× 10</text><path d="M260 134 L270 148" stroke="#16a34a" stroke-width="2.2"/><path d="M274 150 l-11 -3 l3 -8 z" fill="#16a34a"/><text x="268.0" y="131.0" text-anchor="middle" font-size="11" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">× 10</text><text x="180.0" y="20.0" text-anchor="middle" font-size="11" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">ننزل درجةً ⟸ نضرب · نصعد ⟸ نقسم</text><text x="74.0" y="150.0" text-anchor="middle" font-size="11" font-weight="700" fill="#64748b" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1 m = 100 cm</text></svg>
:::

## 🧮 كيف نُحوّل بين الوحدات؟

القاعدة الذهبيّة: **من الكبير إلى الصغير نضرب، ومن الصغير إلى الكبير نقسم.**

- 3 m = 3 × 100 = **300 cm** (من m إلى cm نضرب في 100).
- 250 cm = 250 ÷ 100 = **2 m و 50 cm** (من cm إلى m نقسم على 100).
- 2 km = 2 × 1000 = **2000 m** (من km إلى m نضرب في 1000).

> ⚠️ احذر الفخّ! من المتر إلى الصنتيمتر نضرب في **100** وليس في 10: فـ 2 m تساوي **200 cm** لا 20 cm. ولا تخلط بين **dm** و**cm**: الدسيمتر أكبر، 1 dm = 10 cm.

## 💧 السعات: اللتر

نقيس كميّة السوائل (ماء، حليب، عصير) بوحدة **اللتر (L)**. قارورةُ ماءٍ كبيرةٌ سعتُها قرابة **1 L ونصف**. ولِكميّاتٍ أكبر نجمع لترات، ولأصغر نُقسّم اللتر إلى أنصاف وأرباع.

- نجمع السعات بنفس الوحدة: 1 L + 2 L = **3 L**.
- _مثال:_ قارورتان سعةُ كلٍّ منهما 2 L → المجموع = 2 L + 2 L = **4 L**.
- نصفُ اللتر + نصفُ اللتر = **1 L** كامل.

## ⏰ الزمن: الساعة والدقيقة والثانية

نقرأ الوقت على **الساعة**: العقربُ الصغير للساعات، والعقربُ الكبير للدقائق. والعلاقات:

$$1 ساعة = 60 دقيقة$$

- الدقيقةُ فيها **60 ثانية**، والثانيةُ هي أصغرُ وحدةٍ نقيس بها الزمن القصير.
- عندما يشير العقربُ الكبير إلى **12** نقرأ ساعةً كاملة، وإلى **6** نقرأ **النصف** (30 دقيقة).
- _مثال محسوب:_ ساعةٌ وربع = 60 دقيقة + 15 دقيقة = **75 دقيقة**.

## 🗓️ اليوم والأسبوع والشهر والسنة

نُنظّم الأيّام بوحداتٍ أكبر، إليك علاقاتها:

| الوحدة  | تساوي                             |
| ------- | --------------------------------- |
| اليوم   | 24 ساعة                           |
| الأسبوع | 7 أيّام                           |
| الشهر   | 30 أو 31 يومًا (تقريبًا 4 أسابيع) |
| السنة   | 12 شهرًا = 365 يومًا              |

أيّام الأسبوع بالترتيب: السبت، الأحد، الاثنين، الثلاثاء، الأربعاء، الخميس، الجمعة. نرتّبها كما نعدّ: بعد الاثنين الثلاثاء، وبعد الجمعة يعود السبت.

> ⚠️ لا تخلط الوحدات! **الأسبوع 7 أيّام** و**السنة 12 شهرًا**؛ ولحساب مدّةٍ بالدقائق تذكّر أنّ الساعة = 60 دقيقة لا 100.

> 🏆 أحسنت أيّها البطل! بهذا تكون قد **أتممتَ كامل مغامرة السنة الثالثة**: صرتَ تشتري وتحسب الباقي، وتحوّل الأطوال والسعات، وتقرأ الساعة وتعرف وحدات الزمن. ثبّت ما تعلّمت بالتمارين، وستكون مستعدًّا تمامًا لمغامرات **السنة الرابعة**. إلى الأمام!', '# 📜 ملخّص: القيس: النقود والأطوال والسعات والزمن

- **النقود:** 1 د = 1000 مليم؛ نؤدّي المبلغ بقطعٍ (1 د، 2 د، 5 د) وورقةٍ (5 د)، و**الباقي = المدفوع − الثمن** (مثال: دفعنا 7 د لثمنٍ 6 د → الباقي 1 د).
- **الأطوال:** المتر (m) أساس؛ 1 m = 10 dm = 100 cm = 1000 mm، و 1 km = 1000 m.
- **تحويل الأطوال:** من الكبير إلى الصغير **نضرب**، ومن الصغير إلى الكبير **نقسم** (3 m = 300 cm؛ 250 cm = 2 m و 50 cm؛ 2 km = 2000 m).
- **الفخّ:** من m إلى cm نضرب في **100** لا 10، ولا نخلط dm مع cm (1 dm = 10 cm).
- **السعات:** نقيس السوائل باللتر (L)؛ نجمع بنفس الوحدة (2 L + 2 L = 4 L)، ونصف + نصف = 1 L.
- **الزمن (الساعة):** 1 ساعة = 60 دقيقة، والدقيقة = 60 ثانية؛ ساعة وربع = 75 دقيقة.
- **الزمن (التقويم):** اليوم = 24 ساعة، الأسبوع = 7 أيّام، السنة = 12 شهرًا = 365 يومًا.
- **أيّام الأسبوع:** السبت، الأحد، الاثنين، الثلاثاء، الأربعاء، الخميس، الجمعة؛ بعد الجمعة يعود السبت.', 8, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a4822e19-f149-5cf7-8216-2e753bc551f8', '3ed1c629-4fa6-5101-abef-bfdedf5d5294', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8c6a6b85-8b4d-5d95-972f-8c202c5441ae', 'a4822e19-f149-5cf7-8216-2e753bc551f8', 'في العدد 5 327، ما رتبة الرقم 5؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'd', 'ابتداءً من اليمين في 5 327: الرقم 7 آحاد، 2 عشرات، 3 مئات، 5 آلاف. إذن الرقم 5 في رتبة الآلاف وقيمته 5 000.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2285271b-2692-5b88-a8e2-11b31b4255b5', 'a4822e19-f149-5cf7-8216-2e753bc551f8', 'كيف نكتب بالأرقام العددَ «ثلاثة آلاف وأربعون»؟', '[{"id":"a","text":"340"},{"id":"b","text":"3 004"},{"id":"c","text":"3 040"},{"id":"d","text":"3 400"}]'::jsonb, 'c', 'ثلاثة آلاف = 3 000، وأربعون = 4 عشرات = 40، مع صفرٍ في رتبة المئات وصفرٍ في الآحاد، فيكون العدد 3 040.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('47004acc-b634-5600-807a-4d2c1e5ee377', 'a4822e19-f149-5cf7-8216-2e753bc551f8', 'كيف يُقرأ العدد 4 206؟', '[{"id":"a","text":"أربعمئة وستّة"},{"id":"b","text":"أربعة آلاف ومئتان وستّة"},{"id":"c","text":"أربعة آلاف وستّمئة"},{"id":"d","text":"أربعون ألفًا وستّة"}]'::jsonb, 'b', 'العدد 4 206 = 4 آلاف + 2 مئات + 0 عشرات + 6 آحاد، فيُقرأ «أربعة آلاف ومئتان وستّة».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f78377eb-ffa5-5a0b-ba02-62c1c3dafe24', 'a4822e19-f149-5cf7-8216-2e753bc551f8', 'كيف نكتب بالأرقام الألفَ الكامل «ستّة آلاف»؟', '[{"id":"a","text":"6 000"},{"id":"b","text":"600"},{"id":"c","text":"6 600"},{"id":"d","text":"6 060"}]'::jsonb, 'a', 'الألف الكامل نكتبه برقمٍ في الآلاف ثمّ ثلاثة أصفار: ستّة آلاف = 6 × 1000 = 6 000.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0cfc5547-d1f2-5e27-b17a-3ec12b5d2bfd', 'a4822e19-f149-5cf7-8216-2e753bc551f8', 'ما قيمة الرقم 7 في العدد 3 720؟', '[{"id":"a","text":"7"},{"id":"b","text":"70"},{"id":"c","text":"700"},{"id":"d","text":"7 000"}]'::jsonb, 'c', 'في العدد 3 720 الرقم 7 في رتبة المئات، فقيمته 7 × 100 = 700 (لا تُخلَط القيمة بالرقم نفسه 7).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', '3ed1c629-4fa6-5101-abef-bfdedf5d5294', 'math-3eme', '⭐ تمرين: أوّل خطوات إلى عالَم الآلاف', 1, 50, 10, 'practice', 'admin', 1)
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
  ('28146c9a-b713-5fa6-a06a-c76cd3a21df7', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', 'في العدد 4 813، ما رتبة الرقم 8؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'c', 'ابتداءً من اليمين في 4 813: الرقم 3 آحاد، 1 عشرات، 8 مئات، 4 آلاف. إذن الرقم 8 في رتبة المئات.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6779d3b4-6ec1-5f5d-b6ba-6daec543414a', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', 'كيف يُقرأ العدد 6 050؟', '[{"id":"a","text":"ستّة آلاف وخمسون"},{"id":"b","text":"ستّة آلاف وخمسمئة"},{"id":"c","text":"ستّمئة وخمسون"},{"id":"d","text":"ستّون ألفًا وخمسون"}]'::jsonb, 'a', 'العدد 6 050 = 6 آلاف + 0 مئات + 5 عشرات + 0 آحاد، فيُقرأ «ستّة آلاف وخمسون».', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2a631772-16bf-5a3e-94ba-e43d25d2d7c9', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', 'كيف نكتب بالأرقام العددَ «خمسة آلاف ومئتان»؟', '[{"id":"a","text":"520"},{"id":"b","text":"5 020"},{"id":"c","text":"5 002"},{"id":"d","text":"5 200"}]'::jsonb, 'd', 'خمسة آلاف = 5 000، ومئتان = 200، مع صفرٍ في العشرات وصفرٍ في الآحاد، فيكون العدد 5 200.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d1e85591-44bf-5cec-99f4-c2e095e1c38d', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', 'أيّ تفكيكٍ يوافق العدد 3 408؟', '[{"id":"a","text":"3 × 100 + 4 × 10 + 8"},{"id":"b","text":"3 × 1000 + 4 × 100 + 8"},{"id":"c","text":"3 × 1000 + 4 × 10 + 8"},{"id":"d","text":"3 × 1000 + 4 × 100 + 8 × 10"}]'::jsonb, 'b', 'العدد 3 408 = 3 آلاف + 4 مئات + 0 عشرات + 8 آحاد، أي 3 × 1000 + 4 × 100 + 8.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4411c964-0b9a-5dcc-94ea-ee7ed5bf576a', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', 'ما قيمة الرقم 9 في العدد 2 691؟', '[{"id":"a","text":"9"},{"id":"b","text":"90"},{"id":"c","text":"900"},{"id":"d","text":"9 000"}]'::jsonb, 'b', 'في العدد 2 691 الرقم 9 في رتبة العشرات، فقيمته 9 × 10 = 90.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d85d3595-fadd-529f-99d5-acefdb2c33a8', 'b628e645-8f1d-5dae-ba4c-eb065cc7eb1e', 'ما العدد الطبيعيّ الذي يلي مباشرةً العددَ 3 999؟', '[{"id":"a","text":"3 990"},{"id":"b","text":"3 998"},{"id":"c","text":"4 000"},{"id":"d","text":"4 009"}]'::jsonb, 'c', 'العدد التالي مباشرةً يساوي العددَ زائد 1: 3 999 + 1 = 4 000.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', '3ed1c629-4fa6-5101-abef-bfdedf5d5294', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الأعداد إلى 9999', 3, 120, 30, 'boss', 'admin', 2)
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
  ('6e754866-792b-5347-b5a7-f0007a481eb3', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'عددٌ رقمُ آلافه 3 ورقمُ مئاته 0 ورقمُ عشراته 5 ورقمُ آحاده 9. ما هو؟', '[{"id":"a","text":"3 590"},{"id":"b","text":"359"},{"id":"c","text":"3 059"},{"id":"d","text":"3 509"}]'::jsonb, 'c', 'نضع كلّ رقمٍ في رتبته من اليسار إلى اليمين: 3 آلاف، 0 مئات، 5 عشرات، 9 آحاد، فيكون العدد 3 059. ✓ الفخّ: نسيان الصفر في المئات يعطي 359 الخاطئ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('311a9311-3e58-5c3d-a738-08048f1b7ea2', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'كيف يُقرأ العدد 7 008؟', '[{"id":"a","text":"سبعة آلاف وثمانون"},{"id":"b","text":"سبعة آلاف وثمانمئة"},{"id":"c","text":"سبعمئة وثمانية"},{"id":"d","text":"سبعة آلاف وثمانية"}]'::jsonb, 'd', 'العدد 7 008 = 7 آلاف + 0 مئات + 0 عشرات + 8 آحاد. ✓ فيُقرأ «سبعة آلاف وثمانية». الفخّ: قراءته «ثمانون» (80) بدل «ثمانية» (8).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c4e647f5-6582-519e-8b7b-6c2a5b0b58d2', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'ما قيمة الرقم 6 في العدد 6 240؟', '[{"id":"a","text":"6"},{"id":"b","text":"60"},{"id":"c","text":"600"},{"id":"d","text":"6 000"}]'::jsonb, 'd', 'الرقم 6 في 6 240 يقع في رتبة الآلاف، فقيمته 6 × 1000 = 6 000. ✓ الفخّ: الخلط بين الرقم 6 وقيمته 6 000.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('729a82bd-ea20-5869-ae60-ad207ed71af9', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'أيّ عددٍ يساوي 8 × 1000 + 3 × 10 + 5؟', '[{"id":"a","text":"8 350"},{"id":"b","text":"835"},{"id":"c","text":"8 035"},{"id":"d","text":"8 305"}]'::jsonb, 'c', '8 × 1000 = 8 000، و 3 × 10 = 30، و 5 آحاد = 5، ولا مئات (0 مئات). ✓ المجموع 8 000 + 30 + 5 = 8 035. الفخّ: وضع 3 في المئات بدل العشرات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b3474165-c678-5459-a28f-fe110528af04', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'باستعمال الأرقام 7 و 0 و 4 و 9 مرّةً واحدة لكلٍّ منها، ما أكبر عددٍ يمكن تكوينه؟', '[{"id":"a","text":"7 940"},{"id":"b","text":"9 740"},{"id":"c","text":"9 704"},{"id":"d","text":"9 470"}]'::jsonb, 'b', 'لتكوين أكبر عدد نضع أكبر رقمٍ في أعلى رتبة: 9 في الآلاف، ثمّ 7 في المئات، ثمّ 4 في العشرات، ثمّ 0 في الآحاد. ✓ فنحصل على 9 740. الفخّ: عدم ترتيب الأرقام تنازليًّا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84711fdd-59af-586f-a227-a65a8ce3e8fa', '17ea2c0a-9ff2-51ad-862c-9b6eeb894d21', 'باستعمال الأرقام 7 و 0 و 4 و 9 مرّةً واحدة لكلٍّ منها، ما أصغر عددٍ من أربعة أرقام يمكن تكوينه؟', '[{"id":"a","text":"4 079"},{"id":"b","text":"4 097"},{"id":"c","text":"4 709"},{"id":"d","text":"4 790"}]'::jsonb, 'a', 'لا يجوز أن يبدأ العدد بالصفر وإلّا صار من ثلاثة أرقام، فنضع 4 (أصغر رقمٍ غير الصفر) في الآلاف، ثمّ 0 في المئات، ثمّ 7 في العشرات، ثمّ 9 في الآحاد. ✓ النتيجة 4 079. الفخّ: البدء بالصفر.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c21d045e-65b3-5e44-b24a-ca10fa05159c', '3ed1c629-4fa6-5101-abef-bfdedf5d5294', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد إلى 9999', 2, 75, 15, 'practice', 'admin', 3)
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
  ('549d1907-ae3b-50b7-a95e-28006128f807', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'في العدد 8 364، ما رتبة الرقم 3؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'c', 'ابتداءً من اليمين في 8 364: الرقم 4 آحاد، 6 عشرات، 3 مئات، 8 آلاف. إذن الرقم 3 في رتبة المئات.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b5041e77-c7ed-5cec-a3dc-db5cad9c595f', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'كيف يُقرأ العدد 4 700؟', '[{"id":"a","text":"أربعة آلاف وسبعمئة"},{"id":"b","text":"أربعة آلاف وسبعون"},{"id":"c","text":"أربعمئة وسبعون"},{"id":"d","text":"أربعون ألفًا وسبعمئة"}]'::jsonb, 'a', 'العدد 4 700 = 4 آلاف + 7 مئات + 0 عشرات + 0 آحاد، فيُقرأ «أربعة آلاف وسبعمئة».', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('de10cc4d-346b-5638-9487-a22fd529cc06', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'كيف نكتب بالأرقام العددَ «ستّة آلاف وتسعة»؟', '[{"id":"a","text":"609"},{"id":"b","text":"6 009"},{"id":"c","text":"6 090"},{"id":"d","text":"6 900"}]'::jsonb, 'b', 'ستّة آلاف = 6 000، وتسعة آحاد = 9، مع صفرٍ في المئات وصفرٍ في العشرات، فيكون العدد 6 009.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e328e0f5-f497-589c-82c4-e8cc97577662', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'ما قيمة الرقم 5 في العدد 5 132؟', '[{"id":"a","text":"5"},{"id":"b","text":"50"},{"id":"c","text":"500"},{"id":"d","text":"5 000"}]'::jsonb, 'd', 'الرقم 5 في 5 132 يقع في رتبة الآلاف، فقيمته 5 × 1000 = 5 000.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99fdb98f-0049-5495-b0c8-0cf3a200d2c8', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'ما العدد الطبيعيّ الذي يسبق مباشرةً العددَ 5 000؟', '[{"id":"a","text":"4 000"},{"id":"b","text":"5 001"},{"id":"c","text":"4 999"},{"id":"d","text":"4 900"}]'::jsonb, 'c', 'العدد السابق مباشرةً يساوي العددَ ناقص 1: 5 000 − 1 = 4 999.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1e8e10b8-c93d-51b7-b6da-c7eb48522acb', 'c21d045e-65b3-5e44-b24a-ca10fa05159c', 'أيّ عددٍ يساوي 7 × 1000 + 5 × 10 + 3؟', '[{"id":"a","text":"7 053"},{"id":"b","text":"753"},{"id":"c","text":"7 503"},{"id":"d","text":"7 530"}]'::jsonb, 'a', '7 × 1000 = 7 000، و 5 × 10 = 50، و 3 آحاد = 3، ولا مئات (0 مئات)، فيكون العدد 7 053.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('af47c657-dfa2-5888-b874-b853537b7709', '3ed1c629-4fa6-5101-abef-bfdedf5d5294', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز الأعداد إلى 9999', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('87ee2962-0956-54ff-886d-dace82998abb', 'af47c657-dfa2-5888-b874-b853537b7709', 'كم عددًا طبيعيًّا يقع تمامًا بين 3 999 و 4 003 (دون أن نَعُدّهما)؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'الأعداد الواقعة بينهما هي 4 000 و 4 001 و 4 002، أي 3 أعداد. ✓ لا نَعُدّ 3 999 ولا 4 003 لأنّ السؤال يستثنيهما.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2b9635d9-c937-5e27-966c-8775f6d98f57', 'af47c657-dfa2-5888-b874-b853537b7709', 'كم عددًا من أربعة أرقام يبدأ بالرقم 9 وينتهي بالرقم 0 ورقما مئاته وعشراته صفران؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"9"},{"id":"d","text":"10"}]'::jsonb, 'b', 'إذا ثُبّتت كلّ الرتب (9 آلاف، 0 مئات، 0 عشرات، 0 آحاد) فلا يبقى أيّ اختيار، والعدد الوحيد هو 9 000. ✓ إذن عددٌ 1 فقط يحقّق الشرط.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6b9a264e-c41d-548c-b1b8-9462d104f484', 'af47c657-dfa2-5888-b874-b853537b7709', 'أنا عددٌ من أربعة أرقام: رقمُ آلافي 6، ورقما مئاتي وعشراتي صفران، ومجموع رقمَي آلافي وآحادي يساوي 9. من أكون؟', '[{"id":"a","text":"6 003"},{"id":"b","text":"6 300"},{"id":"c","text":"9 000"},{"id":"d","text":"6 030"}]'::jsonb, 'a', 'رقم الآلاف 6، والمئات والعشرات أصفار. ومجموع الآلاف والآحاد 9، فرقمُ الآحاد = 9 − 6 = 3. ✓ إذن العدد 6 003. الفخّ: وضع الرقم 3 في غير رتبة الآحاد.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2f6db70c-91dd-56d0-8ca8-c6e5110f7d67', 'af47c657-dfa2-5888-b874-b853537b7709', 'ما أكبر عددٍ من أربعة أرقام رقمُ آلافه 5 ورقمُ آحاده 0؟', '[{"id":"a","text":"5 990"},{"id":"b","text":"5 900"},{"id":"c","text":"5 090"},{"id":"d","text":"5 999"}]'::jsonb, 'a', 'رقم الآلاف مثبَّت (5) ورقم الآحاد مثبَّت (0)؛ لجعل العدد أكبر ما يمكن نختار أكبر رقمٍ (9) للمئات وللعشرات. ✓ فنحصل على 5 990. الفخّ: 5 999 رقمُ آحاده 9 لا 0.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7b05eafd-fc48-5897-b2d7-f9ec0696bd56', 'af47c657-dfa2-5888-b874-b853537b7709', 'في عددٍ من أربعة أرقام، قيمة الرقم 4 هي 4 000 وقيمة الرقم 7 هي 70. ما هذا العدد إن كان رقما مئاته وآحاده صفرين؟', '[{"id":"a","text":"4 700"},{"id":"b","text":"4 007"},{"id":"c","text":"7 040"},{"id":"d","text":"4 070"}]'::jsonb, 'd', 'قيمة 4 هي 4 000 فالرقم 4 في الآلاف، وقيمة 7 هي 70 فالرقم 7 في العشرات، والمئات والآحاد صفران. ✓ إذن العدد 4 070. الفخّ: وضع 7 في المئات (قيمته 700) لا في العشرات.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5f970cae-b119-5a44-9e46-b256801b8cec', 'af47c657-dfa2-5888-b874-b853537b7709', 'باستعمال الأرقام 5 و 3 و 0 و 8 مرّةً واحدة لكلٍّ منها، ما العدد (من أربعة أرقام) الأقرب إلى 5 000؟', '[{"id":"a","text":"5 308"},{"id":"b","text":"5 083"},{"id":"c","text":"5 038"},{"id":"d","text":"5 380"}]'::jsonb, 'c', 'نبحث عن أقرب عددٍ إلى 5 000، فنبدأ بالرقم 5 في الآلاف ونصغّر ما بعده: أصغر تكوينٍ هو 5 038 (الفرق 38). ✓ أمّا 5 083 فالفرق 83، و 5 308 الفرق 308، و 5 380 الفرق 380. إذن الأقرب 5 038.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('dbf6265e-9b03-5ded-8cc4-572dd85b5614', '3ed1c629-4fa6-5101-abef-bfdedf5d5294', 'math-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد إلى 9999', 3, 120, 30, 'boss', 'admin', 5)
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
  ('958b8f5c-fa1f-5057-b9fe-b68b8f7e1763', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'ما قيمة الرقم 4 في العدد 6 482؟', '[{"id":"a","text":"4"},{"id":"b","text":"40"},{"id":"c","text":"400"},{"id":"d","text":"4 000"}]'::jsonb, 'c', 'في العدد 6 482 الرقم 4 في رتبة المئات، فقيمته 4 × 100 = 400 (لا تُخلَط القيمة بالرقم نفسه 4).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cb298528-cc9b-59eb-bddd-2806c5c7e162', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'كيف نكتب بالأرقام العددَ «تسعة آلاف»؟', '[{"id":"a","text":"900"},{"id":"b","text":"9 000"},{"id":"c","text":"9 090"},{"id":"d","text":"9 900"}]'::jsonb, 'b', 'تسعة آلاف = 9 × 1000 = 9 000، مع أصفارٍ في المئات والعشرات والآحاد.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('91f45398-54ef-5d26-bdf5-ea0b4f04998e', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'كيف يُقرأ العدد 5 016؟', '[{"id":"a","text":"خمسة آلاف وستّة عشر"},{"id":"b","text":"خمسة آلاف ومئة وستّة"},{"id":"c","text":"خمسمئة وستّة عشر"},{"id":"d","text":"خمسون ألفًا وستّة عشر"}]'::jsonb, 'a', 'العدد 5 016 = 5 آلاف + 0 مئات + 1 عشرات + 6 آحاد، أي ستّة عشر في صنف الوحدات، فيُقرأ «خمسة آلاف وستّة عشر».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4fa88fa6-ecf0-5506-a624-93a6d845c3ef', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'أيّ تفكيكٍ يوافق العدد 9 207؟', '[{"id":"a","text":"9 × 1000 + 2 × 10 + 7"},{"id":"b","text":"9 × 100 + 2 × 10 + 7"},{"id":"c","text":"9 × 1000 + 2 × 100 + 7"},{"id":"d","text":"9 × 1000 + 2 × 100 + 7 × 10"}]'::jsonb, 'c', 'العدد 9 207 = 9 آلاف + 2 مئات + 0 عشرات + 7 آحاد، أي 9 × 1000 + 2 × 100 + 7. ✓ الفخّ: وضع 2 في العشرات (9 × 1000 + 2 × 10 + 7) يعطي 9 027 لا 9 207.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('71dac53e-4e95-5152-96e3-da1933712794', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'في العدد 3 838، ما الفرق بين قيمة الرقم 8 على اليسار وقيمته على اليمين؟', '[{"id":"a","text":"0"},{"id":"b","text":"8"},{"id":"c","text":"800"},{"id":"d","text":"792"}]'::jsonb, 'd', 'في 3 838 الرقم 8 على اليسار في رتبة المئات (قيمته 800)، وعلى اليمين في رتبة الآحاد (قيمته 8). ✓ الفرق = 800 − 8 = 792. الفخّ: ظنّ أنّ قيمتي الرقم متساويتان (الفرق 0).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('136e0274-b087-5177-90a0-d64df151a537', 'dbf6265e-9b03-5ded-8cc4-572dd85b5614', 'ما أصغر عددٍ طبيعيّ مكوَّن من أربعة أرقام؟', '[{"id":"a","text":"0"},{"id":"b","text":"1 000"},{"id":"c","text":"1 111"},{"id":"d","text":"9 999"}]'::jsonb, 'b', 'أصغر عددٍ من أربعة أرقام يبدأ برقمٍ غير الصفر في رتبة الآلاف ثمّ أصغر ما يمكن بعده: 1 ثمّ ثلاثة أصفار، أي 1 000. ✓ (و 9 999 هو الأكبر من أربعة أرقام.)', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ace83de0-204e-5499-a5cf-dad8b5fd3c62', '68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('eae5ecf4-8c49-5a54-b188-d175c5b67bd1', 'ace83de0-204e-5499-a5cf-dad8b5fd3c62', 'ما العلاقة الصحيحة بين العددين 3 248 و 3 261؟', '[{"id":"a","text":"3 248 > 3 261"},{"id":"b","text":"3 248 = 3 261"},{"id":"c","text":"3 248 < 3 261"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'c', 'نقارن من اليسار: الآلاف متساوية (3 = 3)، ثمّ المئات (2 = 2)، ثمّ العشرات: 4 < 6. إذن 3 248 < 3 261.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fa27437b-3a9a-5819-bf24-90e96d3b05f5', 'ace83de0-204e-5499-a5cf-dad8b5fd3c62', 'أيّ الرمزين يجعل العبارة صحيحة: 999 … 1 000؟', '[{"id":"a","text":"<"},{"id":"b","text":">"},{"id":"c","text":"="},{"id":"d","text":"لا شيء ممّا سبق"}]'::jsonb, 'a', 'العدد 999 من ثلاثة أرقام و 1 000 من أربعة أرقام، فالأكثر أرقامًا أكبر: 999 < 1 000. الرمز الصحيح هو <.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('91f8131c-c796-5739-bf3f-978d67c71767', 'ace83de0-204e-5499-a5cf-dad8b5fd3c62', 'ما العدد التالي مباشرةً للعدد 999؟', '[{"id":"a","text":"998"},{"id":"b","text":"1 000"},{"id":"c","text":"9 910"},{"id":"d","text":"990"}]'::jsonb, 'b', 'العدد التالي يساوي العدد زائد 1: 999 + 1 = 1 000.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1264444d-3257-5c26-8c6a-3cf6d7e4be65', 'ace83de0-204e-5499-a5cf-dad8b5fd3c62', 'ما الترتيب التصاعديّ الصحيح للأعداد 1 209 و 45 و 3 080؟', '[{"id":"a","text":"45 < 1 209 < 3 080"},{"id":"b","text":"3 080 < 1 209 < 45"},{"id":"c","text":"1 209 < 45 < 3 080"},{"id":"d","text":"45 < 3 080 < 1 209"}]'::jsonb, 'a', 'العدد 45 من رقمين فهو الأصغر، ثمّ نقارن 1 209 و 3 080: الآلاف 1 < 3، إذن 1 209 < 3 080. الترتيب التصاعديّ: 45 < 1 209 < 3 080.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a33dc00-183b-5da5-b5cf-e67d592b4f0f', 'ace83de0-204e-5499-a5cf-dad8b5fd3c62', 'أيّ عددٍ نُقحمه تمامًا بين 248 و 250؟', '[{"id":"a","text":"247"},{"id":"b","text":"251"},{"id":"c","text":"248"},{"id":"d","text":"249"}]'::jsonb, 'd', 'العدد الذي يقع تمامًا بين 248 و 250 هو 249، لأنّ 248 < 249 < 250.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4f418170-5dfd-55b0-82f7-2b5803731829', '68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', 'math-3eme', '⭐ تمرين: أوّل خطوات في المقارنة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4c1e9c57-af0b-5aa4-82ab-caa262a64adf', '4f418170-5dfd-55b0-82f7-2b5803731829', 'أيّ الرمزين يجعل العبارة صحيحة: 1 350 … 1 530؟', '[{"id":"a","text":"<"},{"id":"b","text":">"},{"id":"c","text":"="},{"id":"d","text":"لا شيء ممّا سبق"}]'::jsonb, 'a', 'الآلاف متساوية (1 = 1)، ثمّ المئات: 3 < 5، إذن 1 350 < 1 530. الرمز الصحيح هو <.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('07e891d8-9868-5a12-b51b-141bddd310b5', '4f418170-5dfd-55b0-82f7-2b5803731829', 'أيّ العددين أكبر: 8 000 أم 800؟', '[{"id":"a","text":"800"},{"id":"b","text":"8 000"},{"id":"c","text":"متساويان"},{"id":"d","text":"لا يمكن المعرفة"}]'::jsonb, 'b', 'العدد 8 000 من أربعة أرقام و 800 من ثلاثة أرقام، فالأكثر أرقامًا أكبر: 8 000 > 800.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e937f7d0-fc4b-510d-ba58-6dae283c5314', '4f418170-5dfd-55b0-82f7-2b5803731829', 'ما العدد السابق مباشرةً للعدد 1 000؟', '[{"id":"a","text":"1 001"},{"id":"b","text":"900"},{"id":"c","text":"999"},{"id":"d","text":"100"}]'::jsonb, 'c', 'العدد السابق يساوي العدد ناقص 1: 1 000 − 1 = 999.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d3cf3423-4c8b-585e-b822-4358635d9b51', '4f418170-5dfd-55b0-82f7-2b5803731829', 'ما العلاقة الصحيحة بين العددين 2 075 و 2 075؟', '[{"id":"a","text":"2 075 < 2 075"},{"id":"b","text":"2 075 > 2 075"},{"id":"c","text":"لا يمكن المقارنة"},{"id":"d","text":"2 075 = 2 075"}]'::jsonb, 'd', 'العددان لهما نفس الأرقام في نفس الرتب، فهما متساويان: 2 075 = 2 075.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dbebcaaa-cea1-55a3-90fe-3f54a7d39be9', '4f418170-5dfd-55b0-82f7-2b5803731829', 'أيّ الأعداد التالية هو الأكبر؟', '[{"id":"a","text":"4 050"},{"id":"b","text":"4 500"},{"id":"c","text":"540"},{"id":"d","text":"450"}]'::jsonb, 'b', 'العددان 540 و 450 من ثلاثة أرقام فهما أصغر؛ ونقارن 4 050 و 4 500: الآلاف متساوية، ثمّ المئات 0 < 5، إذن الأكبر هو 4 500.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9708e374-4f55-5a79-98dd-6b069e6333f7', '4f418170-5dfd-55b0-82f7-2b5803731829', 'ما العدد التالي مباشرةً للعدد 3 209؟', '[{"id":"a","text":"3 210"},{"id":"b","text":"3 208"},{"id":"c","text":"3 300"},{"id":"d","text":"3 219"}]'::jsonb, 'a', 'العدد التالي يساوي العدد زائد 1: 3 209 + 1 = 3 210.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('188ce5c1-85ec-5a2a-bcfe-5825a1dba534', '68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد المقارنة والترتيب', 3, 120, 30, 'boss', 'admin', 2)
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
  ('767074c1-de1d-51c9-a8c4-c95b3ab31dba', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', 'ما العلاقة الصحيحة بين العددين 4 067 و 4 607؟', '[{"id":"a","text":"4 067 < 4 607"},{"id":"b","text":"4 067 = 4 607"},{"id":"c","text":"4 067 > 4 607"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'نقارن من اليسار: الآلاف متساوية (4 = 4)، ثمّ المئات: 0 < 6. إذن 4 067 < 4 607. الخطأ الشائع هو الظنّ أنّ 4 067 أكبر بسبب الرقم 7 في الآحاد.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('85f74a48-1eca-5c75-9db8-e6e34b03e3d7', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', 'ما العدد السابق مباشرةً للعدد 5 000؟', '[{"id":"a","text":"5 001"},{"id":"b","text":"4 900"},{"id":"c","text":"4 000"},{"id":"d","text":"4 999"}]'::jsonb, 'd', 'العدد السابق يساوي العدد ناقص 1: 5 000 − 1 = 4 999. الخطأ الشائع هو نقص رقم الآلاف فقط وكتابة 4 000.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aa08b5a2-6595-59e5-8c08-bb93ce44d05a', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', 'ما الترتيب التصاعديّ الصحيح للأعداد 1 900 و 1 090 و 910؟', '[{"id":"a","text":"910 < 1 090 < 1 900"},{"id":"b","text":"910 < 1 900 < 1 090"},{"id":"c","text":"1 090 < 910 < 1 900"},{"id":"d","text":"1 900 < 1 090 < 910"}]'::jsonb, 'a', 'العدد 910 من ثلاثة أرقام فهو الأصغر؛ ثمّ نقارن 1 090 و 1 900: الآلاف متساوية، ثمّ المئات 0 < 9. الترتيب التصاعديّ: 910 < 1 090 < 1 900.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('64a1481c-e7b3-5743-85c7-72ac0aa95607', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', 'أيّ الأعداد التالية هو الأصغر؟', '[{"id":"a","text":"3 030"},{"id":"b","text":"3 300"},{"id":"c","text":"3 003"},{"id":"d","text":"3 013"}]'::jsonb, 'c', 'الآلاف متساوية (3)؛ نقارن المئات: 3 300 مئاته 3 فهو الأكبر، والباقي مئاته 0. ثمّ بين 3 030 و 3 003 و 3 013 نقارن العشرات: 0 < 1 < 3، إذن الأصغر هو 3 003.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5bf45cf1-d84a-50f8-b182-aec42a5e4330', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', 'كم عددًا يقع تمامًا بين 3 497 و 3 501 (دون أن نَعُدّهما)؟', '[{"id":"a","text":"2"},{"id":"b","text":"5"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'c', 'الأعداد الواقعة بينهما هي 3 498 و 3 499 و 3 500، أي 3 أعداد. الخطأ الشائع هو عَدّ الطرفين 3 497 و 3 501، والسؤال يستثنيهما.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fa721a4d-16ab-5d98-bc68-59bb2d02fee3', '188ce5c1-85ec-5a2a-bcfe-5825a1dba534', 'ما الترتيب التنازليّ الصحيح للأعداد 2 080 و 2 800 و 2 008؟', '[{"id":"a","text":"2 008 > 2 080 > 2 800"},{"id":"b","text":"2 800 > 2 080 > 2 008"},{"id":"c","text":"2 080 > 2 800 > 2 008"},{"id":"d","text":"2 800 > 2 008 > 2 080"}]'::jsonb, 'b', 'الآلاف متساوية (2)؛ نقارن المئات: 8 > 0، فـ 2 800 الأكبر. ثمّ بين 2 080 و 2 008 نقارن العشرات: 8 > 0، فـ 2 080 أكبر. تنازليًّا: 2 800 > 2 080 > 2 008.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5294d31e-f59b-5298-9ae0-dd9e39b3934f', '68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): مقارنة الأعداد وترتيبها', 2, 75, 15, 'practice', 'admin', 3)
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
  ('03a32a5a-be33-506e-a3a5-2ff7ebaee9cd', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'أيّ الرمزين يجعل العبارة صحيحة: 2 640 … 2 460؟', '[{"id":"a","text":"<"},{"id":"b","text":">"},{"id":"c","text":"="},{"id":"d","text":"لا شيء ممّا سبق"}]'::jsonb, 'b', 'الآلاف متساوية (2 = 2)، ثمّ المئات: 6 > 4، إذن 2 640 > 2 460. الرمز الصحيح هو >.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9ad20e3c-192e-5c72-bd73-b4b546628371', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'ما العدد التالي مباشرةً للعدد 1 999؟', '[{"id":"a","text":"1 998"},{"id":"b","text":"2 000"},{"id":"c","text":"1 990"},{"id":"d","text":"2 999"}]'::jsonb, 'b', 'العدد التالي يساوي العدد زائد 1: 1 999 + 1 = 2 000.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('615d08fd-1a6b-53c3-9c53-487e7f353d11', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'ما الترتيب التنازليّ الصحيح للأعداد 700 و 7 000 و 70؟', '[{"id":"a","text":"7 000 > 700 > 70"},{"id":"b","text":"70 > 700 > 7 000"},{"id":"c","text":"700 > 7 000 > 70"},{"id":"d","text":"7 000 > 70 > 700"}]'::jsonb, 'a', '7 000 من أربعة أرقام فهو الأكبر، ثمّ 700 من ثلاثة أرقام، ثمّ 70 من رقمين. تنازليًّا: 7 000 > 700 > 70.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('59ca1275-583d-5f38-851e-8d41f26486b9', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'أيّ حصرٍ صحيحٍ للعدد 4 387 بين أقرب مئتين؟', '[{"id":"a","text":"4 387 < 4 300 < 4 400"},{"id":"b","text":"4 400 < 4 387 < 4 500"},{"id":"c","text":"4 300 < 4 387 < 4 400"},{"id":"d","text":"4 200 < 4 387 < 4 300"}]'::jsonb, 'c', 'العدد 4 387 أكبر من 4 300 وأصغر من 4 400، فالحصر الصحيح هو 4 300 < 4 387 < 4 400.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ba7960cc-764f-5885-9a63-011d070af677', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'ما العدد السابق مباشرةً للعدد 6 410؟', '[{"id":"a","text":"6 411"},{"id":"b","text":"6 400"},{"id":"c","text":"6 420"},{"id":"d","text":"6 409"}]'::jsonb, 'd', 'العدد السابق يساوي العدد ناقص 1: 6 410 − 1 = 6 409.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a61cc046-5a5d-5a42-934b-d69e7b9fc935', '5294d31e-f59b-5298-9ae0-dd9e39b3934f', 'ما العلاقة الصحيحة بين العددين 989 و 1 001؟', '[{"id":"a","text":"989 < 1 001"},{"id":"b","text":"989 > 1 001"},{"id":"c","text":"989 = 1 001"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'العدد 989 من ثلاثة أرقام و 1 001 من أربعة أرقام، فالأكثر أرقامًا أكبر: 989 < 1 001.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', '68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز المقارنة والترتيب', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('22a0e2c5-bf31-5b28-b972-eead3fa05f70', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', 'ما العلاقة الصحيحة بين العددين 5 318 و 5 381؟', '[{"id":"a","text":"5 318 < 5 381"},{"id":"b","text":"5 318 = 5 381"},{"id":"c","text":"5 318 > 5 381"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'الآلاف متساوية (5 = 5)، ثمّ المئات (3 = 3)، ثمّ العشرات: 1 < 8. إذن 5 318 < 5 381. الخطأ الشائع هو النظر إلى آحاد العددين بدل أوّل اختلافٍ من اليسار.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d1afcdad-f3d7-5662-bb75-239502758533', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', 'ما الترتيب التصاعديّ الصحيح للأعداد 4 044 و 4 404 و 444؟', '[{"id":"a","text":"444 < 4 404 < 4 044"},{"id":"b","text":"444 < 4 044 < 4 404"},{"id":"c","text":"4 044 < 444 < 4 404"},{"id":"d","text":"4 404 < 4 044 < 444"}]'::jsonb, 'b', 'العدد 444 من ثلاثة أرقام فهو الأصغر؛ ثمّ نقارن 4 044 و 4 404: الآلاف متساوية، ثمّ المئات 0 < 4. الترتيب التصاعديّ: 444 < 4 044 < 4 404.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('81851699-bb47-5507-a09c-08981ca2096e', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', 'عددٌ تاليه هو 4 000. ما هو هذا العدد؟', '[{"id":"a","text":"4 001"},{"id":"b","text":"3 000"},{"id":"c","text":"3 999"},{"id":"d","text":"4 100"}]'::jsonb, 'c', 'إذا كان تالي العدد هو 4 000 فالعدد نفسه هو سابق 4 000، أي 4 000 − 1 = 3 999. الخطأ الشائع هو كتابة 3 000 بنقص رقم الآلاف فقط.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b83f8517-7b08-5fae-9a32-ea539840b0f6', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', 'كم عددًا يقع تمامًا بين 2 988 و 3 002 (دون أن نَعُدّهما)؟', '[{"id":"a","text":"14"},{"id":"b","text":"12"},{"id":"c","text":"11"},{"id":"d","text":"13"}]'::jsonb, 'd', 'الأعداد الواقعة بينهما هي من 2 989 إلى 3 001، أي 3 001 − 2 989 + 1 = 13 عددًا. لا نَعُدّ الطرفين.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2e1509f3-b7e6-5834-a4b3-aa9fd0bc2985', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', 'أنا عددٌ من أربعة أرقام، أكبر من 7 320 وأصغر من 7 330، ورقمُ آحادي 5. من أكون؟', '[{"id":"a","text":"7 350"},{"id":"b","text":"7 325"},{"id":"c","text":"7 532"},{"id":"d","text":"5 327"}]'::jsonb, 'b', 'العدد بين 7 320 و 7 330 فهو من النوع 732_، ورقمُ آحاده 5، فهو 7 325. (7 350 أكبر من 7 330، و 7 532 و 5 327 خارج المجال.)', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c83cacbb-95ff-55c4-9ae0-770951eba7a3', 'b8e2bd70-6fd8-5603-a8ed-08ff81d911b4', 'ما أصغر عددٍ من أربعة أرقام نُكوّنه بالأرقام 5 و 0 و 7 و 2، باستعمال كلّ رقمٍ مرّةً واحدة؟', '[{"id":"a","text":"0 257"},{"id":"b","text":"2 075"},{"id":"c","text":"2 057"},{"id":"d","text":"5 027"}]'::jsonb, 'c', 'لا يبدأ عددٌ من أربعة أرقام بالصفر، فنضع أصغر رقمٍ غير الصفر في الآلاف (2)، ثمّ نرتّب الباقي تصاعديًّا: 0 ثمّ 5 ثمّ 7. فالعدد هو 2 057.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('030d3b56-40d6-589b-8be9-99b77357ef43', '68cba7a1-cfb6-5b1d-8d9b-d4caa02eec7e', 'math-3eme', '📝 تدريب ⭐⭐⭐: مقارنة الأعداد وترتيبها (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('29bc0c3d-86b3-5091-a0b4-b1d8c16da9bc', '030d3b56-40d6-589b-8be9-99b77357ef43', 'أيّ الرمزين يجعل العبارة صحيحة: 9 000 … 990؟', '[{"id":"a","text":"<"},{"id":"b","text":"="},{"id":"c","text":">"},{"id":"d","text":"لا شيء ممّا سبق"}]'::jsonb, 'c', 'العدد 9 000 من أربعة أرقام و 990 من ثلاثة أرقام، فالأكثر أرقامًا أكبر: 9 000 > 990. الرمز الصحيح هو >.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9353c1af-1104-50fa-9ebf-d4c0cb787eea', '030d3b56-40d6-589b-8be9-99b77357ef43', 'ما العدد التالي مباشرةً للعدد 7 660؟', '[{"id":"a","text":"7 661"},{"id":"b","text":"7 659"},{"id":"c","text":"7 670"},{"id":"d","text":"7 600"}]'::jsonb, 'a', 'العدد التالي يساوي العدد زائد 1: 7 660 + 1 = 7 661.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('32096824-ce13-5765-91a7-80b2140617c1', '030d3b56-40d6-589b-8be9-99b77357ef43', 'ما العدد السابق مباشرةً للعدد 3 100؟', '[{"id":"a","text":"3 101"},{"id":"b","text":"3 110"},{"id":"c","text":"3 000"},{"id":"d","text":"3 099"}]'::jsonb, 'd', 'العدد السابق يساوي العدد ناقص 1: 3 100 − 1 = 3 099.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('547b6e87-2d2c-5891-a3b3-50883ead4216', '030d3b56-40d6-589b-8be9-99b77357ef43', 'ما الترتيب التصاعديّ الصحيح للأعداد 5 215 و 5 251 و 5 152؟', '[{"id":"a","text":"5 152 < 5 215 < 5 251"},{"id":"b","text":"5 152 < 5 251 < 5 215"},{"id":"c","text":"5 215 < 5 152 < 5 251"},{"id":"d","text":"5 251 < 5 215 < 5 152"}]'::jsonb, 'a', 'الآلاف متساوية (5)؛ نقارن المئات: 5 152 مئاته 1 فهو الأصغر؛ ثمّ 5 215 و 5 251 مئاتهما 2، فنقارن العشرات: 1 < 5، إذن 5 215 < 5 251. الترتيب: 5 152 < 5 215 < 5 251.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c65e5dda-c46e-568b-b3e8-b4863d4b0c27', '030d3b56-40d6-589b-8be9-99b77357ef43', 'كم عددًا يقع تمامًا بين 6 097 و 6 103 (دون أن نَعُدّهما)؟', '[{"id":"a","text":"4"},{"id":"b","text":"6"},{"id":"c","text":"5"},{"id":"d","text":"7"}]'::jsonb, 'c', 'الأعداد الواقعة بينهما هي 6 098 و 6 099 و 6 100 و 6 101 و 6 102، أي 5 أعداد. الخطأ الشائع هو عَدّ الطرفين 6 097 و 6 103.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8c356385-55b8-54b5-868a-8f9117a27299', '030d3b56-40d6-589b-8be9-99b77357ef43', 'أنا عددٌ محصورٌ بين 4 099 و 4 200، رقمُ مئاتي 1، وعشراتي وآحادي أصفار. من أكون؟', '[{"id":"a","text":"4 010"},{"id":"b","text":"4 100"},{"id":"c","text":"4 200"},{"id":"d","text":"1 400"}]'::jsonb, 'b', 'العدد بين 4 099 و 4 200 ومئاته 1 فهو من النوع 41__، وعشراته وآحاده أصفار، فهو 4 100. (4 200 مئاته 2 وهو طرفٌ مستثنى، و 4 010 مئاته 0.)', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d072d43d-4ca5-589a-8306-69c004005258', '920b0cc3-69f7-52c8-ae67-d3d77597db24', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7547094c-494d-5636-bc93-0cda630743de', 'd072d43d-4ca5-589a-8306-69c004005258', 'في العمليّة 245 + 132 = 377، ماذا نسمّي العدد 377؟', '[{"id":"a","text":"الحدّ"},{"id":"b","text":"الفرق"},{"id":"c","text":"المجموع"},{"id":"d","text":"الباقي"}]'::jsonb, 'c', 'في الجمع نسمّي العددين المجموعين حدَّيْن (245 و 132)، ونسمّي نتيجة الجمع المجموعَ، وهي هنا 377.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2ca5df4d-0efb-55af-a520-9411ee359b40', 'd072d43d-4ca5-589a-8306-69c004005258', 'ما نتيجة الجمع 234 + 152؟', '[{"id":"a","text":"286"},{"id":"b","text":"376"},{"id":"c","text":"486"},{"id":"d","text":"386"}]'::jsonb, 'd', 'نجمع رتبةً تحت رتبة: الآحاد 4 + 2 = 6، العشرات 3 + 5 = 8، المئات 2 + 1 = 3. إذن المجموع 386 (دون احتفاظ).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6420042f-922b-55ed-9fe3-e3c46e114dbd', 'd072d43d-4ca5-589a-8306-69c004005258', 'عند جمع 47 + 28، ما الرقم الذي نحتفظ به بعد جمع الآحاد؟', '[{"id":"a","text":"لا نحتفظ بشيء"},{"id":"b","text":"1"},{"id":"c","text":"5"},{"id":"d","text":"2"}]'::jsonb, 'b', 'الآحاد: 7 + 8 = 15، نكتب 5 ونحتفظ بـ 1 للعشرات. ثمّ 4 + 2 + 1 = 7، فالمجموع 75.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('712f91f9-687c-56c1-8074-175d8491a7b6', 'd072d43d-4ca5-589a-8306-69c004005258', 'بالطرح بالزيادة (الإكمال)، كم نضيف إلى 58 لنبلغ 62؟ أي 62 − 58 = ؟', '[{"id":"a","text":"4"},{"id":"b","text":"6"},{"id":"c","text":"14"},{"id":"d","text":"120"}]'::jsonb, 'a', 'في الطرح بالزيادة نَعدّ تصاعديًّا من المطروح إلى المطروح منه: 58 + 4 = 62، فالفرق هو 4، أي 62 − 58 = 4.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('795cbe0f-0f3a-5ba2-b4c0-926e501bc59e', 'd072d43d-4ca5-589a-8306-69c004005258', 'كيف نتحقّق من صحّة الطرح 399 = 264 − 135 الخاطئ؟', '[{"id":"a","text":"نجمع 264 + 135 ونقارن بالمطروح منه"},{"id":"b","text":"نطرح الفرق من نفسه"},{"id":"c","text":"نجمع الفرق مع المطروح ونقارن بالمطروح منه"},{"id":"d","text":"لا يمكن التحقّق"}]'::jsonb, 'c', 'للتحقّق نستعمل العلاقة: الفرق + المطروح = المطروح منه. فالطرح الصحيح 264 − 135 = 129، والتحقّق 129 + 135 = 264 ✓.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6fb1e40d-235e-50b0-afc7-ef0ddb47606b', '920b0cc3-69f7-52c8-ae67-d3d77597db24', 'math-3eme', '⭐ تمرين: أوّل خطوات في الجمع والطرح', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9129a86d-b485-5c8b-9cea-a2cdbf871c5b', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'في العمليّة 586 − 241 = 345، ماذا نسمّي العدد 345؟', '[{"id":"a","text":"المجموع"},{"id":"b","text":"الفرق"},{"id":"c","text":"الحدّ"},{"id":"d","text":"الاحتفاظ"}]'::jsonb, 'b', 'نتيجة الطرح تُسمّى الفرق (أو الباقي). إذن 345 هو الفرق بين 586 و 241.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('37e57d10-3347-5a5e-97f1-7e8df4d7bfd3', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'ما نتيجة الجمع 321 + 145؟', '[{"id":"a","text":"456"},{"id":"b","text":"476"},{"id":"c","text":"466"},{"id":"d","text":"566"}]'::jsonb, 'c', 'نجمع رتبةً تحت رتبة: الآحاد 1 + 5 = 6، العشرات 2 + 4 = 6، المئات 3 + 1 = 4. إذن المجموع 466 (دون احتفاظ).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('30be8954-019a-5d30-b797-6eeb5c9cf610', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'ما نتيجة الطرح 75 − 32؟', '[{"id":"a","text":"53"},{"id":"b","text":"47"},{"id":"c","text":"33"},{"id":"d","text":"43"}]'::jsonb, 'd', 'نطرح رتبةً تحت رتبة: الآحاد 5 − 2 = 3، العشرات 7 − 3 = 4. إذن الفرق 43 (دون استلاف).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d7ff0ac2-201e-5cee-9ed1-6d31a48dfdec', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'ما نتيجة الجمع 56 + 27؟', '[{"id":"a","text":"83"},{"id":"b","text":"73"},{"id":"c","text":"713"},{"id":"d","text":"93"}]'::jsonb, 'a', 'الآحاد: 6 + 7 = 13، نكتب 3 ونحتفظ بـ 1. العشرات: 5 + 2 + 1 = 8. إذن المجموع 83.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d14cc646-b30a-58c2-b5b5-a4ef776d0b86', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'ما نتيجة الطرح 60 − 24؟', '[{"id":"a","text":"44"},{"id":"b","text":"46"},{"id":"c","text":"36"},{"id":"d","text":"26"}]'::jsonb, 'c', 'الآحاد: 0 أصغر من 4، نستلف فتصير 10؛ 10 − 4 = 6. العشرات: صارت 5؛ 5 − 2 = 3. إذن الفرق 36.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2df49b24-7e65-58ee-baa9-f4ec35974a5a', '6fb1e40d-235e-50b0-afc7-ef0ddb47606b', 'أيّ مساواةٍ تعبّر عن أنّ الجمع تبديليّ؟', '[{"id":"a","text":"130 + 200 = 330 − 0"},{"id":"b","text":"200 + 130 = 130 + 200"},{"id":"c","text":"200 − 130 = 130 − 200"},{"id":"d","text":"200 + 130 = 200 − 130"}]'::jsonb, 'b', 'الجمع تبديليّ: تبديل ترتيب الحدّين لا يغيّر المجموع، فيكون 200 + 130 = 130 + 200. أمّا الطرح فليس تبديليًّا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d63e3ef2-95cf-5ad8-b29f-f6237d9b665c', '920b0cc3-69f7-52c8-ae67-d3d77597db24', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الجمع والطرح', 3, 120, 30, 'boss', 'admin', 2)
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
  ('3ceb9ee9-8162-5ed5-b370-852887b504cb', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', 'ما نتيجة الجمع 367 + 158؟', '[{"id":"a","text":"415"},{"id":"b","text":"515"},{"id":"c","text":"525"},{"id":"d","text":"4 125"}]'::jsonb, 'c', 'الآحاد: 7 + 8 = 15، نكتب 5 ونحتفظ بـ 1. العشرات: 6 + 5 + 1 = 12، نكتب 2 ونحتفظ بـ 1. المئات: 3 + 1 + 1 = 5. ✓ المجموع 525. الفخّ: نسيان احتفاظ العشرات يعطي 415 الخاطئ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1991cda4-3f8a-5892-bdc0-69d64952f3f9', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', 'ما الحدّ المجهول في العمليّة ? + 250 = 700؟', '[{"id":"a","text":"550"},{"id":"b","text":"950"},{"id":"c","text":"450"},{"id":"d","text":"350"}]'::jsonb, 'c', 'لإيجاد حدٍّ مجهول في جمعٍ نطرح الحدّ المعلوم من المجموع: ? = 700 − 250 = 450. ✓ التحقّق: 450 + 250 = 700 ✓. الفخّ: جمع 700 + 250 بدل طرحهما.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('98edafe9-50cc-536c-9e4a-41e010d38a84', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', 'ما نتيجة الطرح 524 − 168؟', '[{"id":"a","text":"356"},{"id":"b","text":"444"},{"id":"c","text":"366"},{"id":"d","text":"456"}]'::jsonb, 'a', 'الآحاد: 4 أصغر من 8، نستلف فتصير 14؛ 14 − 8 = 6. العشرات: صارت 1، أصغر من 6، نستلف فتصير 11؛ 11 − 6 = 5. المئات: صارت 4؛ 4 − 1 = 3. ✓ الفرق 356. الفخّ: طرح 4 − 8 مقلوبًا داخل رتبة الآحاد.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('902b9ef2-adb8-5460-934e-2c03f4a93869', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', 'ما نتيجة الجمع 1 458 + 2 376؟', '[{"id":"a","text":"3 724"},{"id":"b","text":"3 734"},{"id":"c","text":"3 824"},{"id":"d","text":"3 834"}]'::jsonb, 'd', 'الآحاد: 8 + 6 = 14، نكتب 4 ونحتفظ بـ 1. العشرات: 5 + 7 + 1 = 13، نكتب 3 ونحتفظ بـ 1. المئات: 4 + 3 + 1 = 8. الآلاف: 1 + 2 = 3. ✓ المجموع 3 834. الفخّ: نسيان احتفاظٍ من الاثنين.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8318e414-c3b3-5f57-ac9e-e4f85cf999a1', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', 'ما نتيجة الطرح 4 002 − 1 567؟', '[{"id":"a","text":"3 565"},{"id":"b","text":"2 435"},{"id":"c","text":"2 545"},{"id":"d","text":"2 445"}]'::jsonb, 'b', 'الآحاد: 2 − 7 نستلف، 12 − 7 = 5. العشرات: 0 صارت 9 بعد سلسلة الاستلاف؛ 9 − 6 = 3. المئات: 9 − 5 = 4. الآلاف: 3 − 1 = 2. ✓ الفرق 2 435. التحقّق: 2 435 + 1 567 = 4 002 ✓. الفخّ: الاستلاف عبر الأصفار المتتالية.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4fc8113e-9cb8-5cb4-beca-70d98260b4d8', 'd63e3ef2-95cf-5ad8-b29f-f6237d9b665c', 'أراد تلميذٌ التحقّق من الطرح 832 − 415 = 417. أيّ جمعٍ يثبت صحّته؟', '[{"id":"a","text":"417 + 415 = 832"},{"id":"b","text":"832 + 415 = 417"},{"id":"c","text":"417 + 832 = 415"},{"id":"d","text":"417 − 415 = 832"}]'::jsonb, 'a', 'نتحقّق من الطرح بالجمع: الفرق + المطروح = المطروح منه، أي 417 + 415 = 832. ✓ وبالحساب 417 + 415 = 832 فالطرح صحيح. الفخّ: عكس مواضع الأعداد في التحقّق.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6c9808df-fefb-56f7-a661-4ef95a3c414f', '920b0cc3-69f7-52c8-ae67-d3d77597db24', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الجمع والطرح', 2, 70, 15, 'practice', 'admin', 3)
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
  ('5ddca7b9-9d08-548b-af1e-95538e351591', '6c9808df-fefb-56f7-a661-4ef95a3c414f', 'دفعتَ 100 مليم لشراء حلوى بـ 65 مليمًا. بالطرح بالزيادة، كم باقيك؟ (100 − 65)', '[{"id":"a","text":"25 مليمًا"},{"id":"b","text":"35 مليمًا"},{"id":"c","text":"45 مليمًا"},{"id":"d","text":"165 مليمًا"}]'::jsonb, 'b', 'في الطرح بالزيادة نَعدّ من 65 إلى 100: 65 + 35 = 100، فالباقي 35 مليمًا، أي 100 − 65 = 35.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3e6dc8b1-c70c-5794-be0e-3de8a675f559', '6c9808df-fefb-56f7-a661-4ef95a3c414f', 'ما نتيجة الطرح 947 − 523؟', '[{"id":"a","text":"424"},{"id":"b","text":"434"},{"id":"c","text":"324"},{"id":"d","text":"414"}]'::jsonb, 'a', 'نطرح رتبةً تحت رتبة: الآحاد 7 − 3 = 4، العشرات 4 − 2 = 2، المئات 9 − 5 = 4. إذن الفرق 424 (دون استلاف).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c3f0ca93-fc11-52c7-998d-04e9d775557b', '6c9808df-fefb-56f7-a661-4ef95a3c414f', 'ما نتيجة الجمع 268 + 145؟', '[{"id":"a","text":"303"},{"id":"b","text":"403"},{"id":"c","text":"423"},{"id":"d","text":"413"}]'::jsonb, 'd', 'الآحاد: 8 + 5 = 13، نكتب 3 ونحتفظ بـ 1. العشرات: 6 + 4 + 1 = 11، نكتب 1 ونحتفظ بـ 1. المئات: 2 + 1 + 1 = 4. إذن المجموع 413.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0d50406d-297c-551f-abc7-64da12c1c9ba', '6c9808df-fefb-56f7-a661-4ef95a3c414f', 'ما نتيجة الطرح 503 − 247؟', '[{"id":"a","text":"344"},{"id":"b","text":"266"},{"id":"c","text":"256"},{"id":"d","text":"356"}]'::jsonb, 'c', 'الآحاد: 3 أصغر من 7، نستلف؛ 13 − 7 = 6. العشرات: 0 صارت 9 بعد الاستلاف؛ 9 − 4 = 5. المئات: صارت 4؛ 4 − 2 = 2. إذن الفرق 256. التحقّق: 256 + 247 = 503 ✓.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('54463f78-1d6d-5fb9-83d7-62ef2358e91b', '6c9808df-fefb-56f7-a661-4ef95a3c414f', 'ما العدد المجهول في العمليّة ? − 120 = 380؟', '[{"id":"a","text":"260"},{"id":"b","text":"500"},{"id":"c","text":"460"},{"id":"d","text":"490"}]'::jsonb, 'b', 'العدد المجهول هو المطروح منه؛ نجده بجمع الفرق والمطروح: ? = 380 + 120 = 500. التحقّق: 500 − 120 = 380 ✓.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a58c3935-07f6-5337-862f-eaf478ee9f5f', '6c9808df-fefb-56f7-a661-4ef95a3c414f', 'في مكتبةٍ 615 كتابًا، أُضيف إليها 178 كتابًا جديدًا. كم صار عدد الكتب؟', '[{"id":"a","text":"437 كتابًا"},{"id":"b","text":"783 كتابًا"},{"id":"c","text":"893 كتابًا"},{"id":"d","text":"793 كتابًا"}]'::jsonb, 'd', 'نجمع لأنّنا أضفنا كتبًا: 615 + 178. الآحاد 5 + 8 = 13 (نحتفظ بـ 1)، العشرات 1 + 7 + 1 = 9، المئات 6 + 1 = 7. إذن صار العدد 793 كتابًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('17c9aa2f-c0a8-5656-a919-e51b88b6bc86', '920b0cc3-69f7-52c8-ae67-d3d77597db24', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: مسائل الجمع والطرح', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('cf6f88d1-560f-5775-bd45-770691d8d254', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'كان مع أحمد 845 مليمًا، فاشترى لعبةً بـ 367 مليمًا. كم بقي معه؟', '[{"id":"a","text":"522 مليمًا"},{"id":"b","text":"588 مليمًا"},{"id":"c","text":"478 مليمًا"},{"id":"d","text":"1 212 مليمًا"}]'::jsonb, 'c', 'نطرح لأنّه صرف من ماله: 845 − 367. الآحاد 5 أصغر من 7، نستلف؛ 15 − 7 = 8. العشرات صارت 3، نستلف؛ 13 − 6 = 7. المئات صارت 7؛ 7 − 3 = 4. ✓ بقي 478 مليمًا. الفخّ: جمع المبلغين بدل طرحهما.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('544b1021-4f98-5fea-84af-023ebd9c0967', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'ما نتيجة الجمع 1 736 + 2 589؟', '[{"id":"a","text":"4 215"},{"id":"b","text":"4 325"},{"id":"c","text":"3 325"},{"id":"d","text":"4 225"}]'::jsonb, 'b', 'الآحاد: 6 + 9 = 15 (نكتب 5 نحتفظ 1). العشرات: 3 + 8 + 1 = 12 (نكتب 2 نحتفظ 1). المئات: 7 + 5 + 1 = 13 (نكتب 3 نحتفظ 1). الآلاف: 1 + 2 + 1 = 4. ✓ المجموع 4 325. الفخّ: نسيان احتفاظٍ في سلسلة الاحتفاظات.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('69784f79-133b-5ccb-b41d-1fdd28a43738', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'ما نتيجة الطرح 3 000 − 1 426؟', '[{"id":"a","text":"1 684"},{"id":"b","text":"2 426"},{"id":"c","text":"1 674"},{"id":"d","text":"1 574"}]'::jsonb, 'd', 'نستلف عبر الأصفار: الآحاد 0 → 10 − 6 = 4. العشرات صارت 9 − 2 = 7. المئات صارت 9 − 4 = 5. الآلاف صارت 2 − 1 = 1. ✓ الفرق 1 574. التحقّق: 1 574 + 1 426 = 3 000 ✓. الفخّ: الاستلاف عبر ثلاثة أصفار متتالية.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3b20522b-a506-5f11-8286-56e03054bcaa', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'ما الحدّ المجهول في العمليّة ? + 1 250 = 3 000؟', '[{"id":"a","text":"1 750"},{"id":"b","text":"2 250"},{"id":"c","text":"1 850"},{"id":"d","text":"4 250"}]'::jsonb, 'a', 'لإيجاد الحدّ المجهول نطرح الحدّ المعلوم من المجموع: ? = 3 000 − 1 250 = 1 750. ✓ التحقّق: 1 750 + 1 250 = 3 000 ✓. الفخّ: جمع 3 000 + 1 250 بدل طرحهما.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e943312f-f6a2-5058-971b-52dcefe73805', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'جمع قسمٌ 1 245 دينارًا للجمعيّة، وجمع قسمٌ آخر 968 دينارًا. كم جمع القسمان معًا؟', '[{"id":"a","text":"2 113 دينارًا"},{"id":"b","text":"2 103 دنانير"},{"id":"c","text":"2 213 دينارًا"},{"id":"d","text":"2 223 دينارًا"}]'::jsonb, 'c', 'نجمع المبلغين: 1 245 + 968. الآحاد 5 + 8 = 13 (نحتفظ 1). العشرات 4 + 6 + 1 = 11 (نحتفظ 1). المئات 2 + 9 + 1 = 12 (نحتفظ 1). الآلاف 1 + 0 + 1 = 2. ✓ المجموع 2 213 دينارًا. الفخّ: نسيان احتفاظ المئات.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fc5db26c-b5d2-58ad-b798-789fa54a0e5c', '17c9aa2f-c0a8-5656-a919-e51b88b6bc86', 'طرح تلميذٌ فكتب 736 − 248 = 588. كيف نكتشف خطأه بالتحقّق؟', '[{"id":"a","text":"نجمع 588 + 736 ونقارن بـ 248"},{"id":"b","text":"نجمع 588 + 248 فنجد 836 لا 736، فالطرح خاطئ"},{"id":"c","text":"نطرح 588 − 248 ونقارن بـ 736"},{"id":"d","text":"لا يمكن اكتشاف الخطأ"}]'::jsonb, 'b', 'نتحقّق بالعلاقة: الفرق + المطروح = المطروح منه. 588 + 248 = 836، وهو لا يساوي 736، إذن الطرح خاطئ (والصواب 736 − 248 = 488). ✓ الفخّ: الاكتفاء بالطرح دون التحقّق بالجمع.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('cd83ae6c-3343-5934-be4a-a07196df5d4c', '920b0cc3-69f7-52c8-ae67-d3d77597db24', 'math-3eme', '📝 تدريب ⭐⭐⭐: إتقان الجمع والطرح', 3, 120, 30, 'boss', 'admin', 5)
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
  ('42b284be-5c8a-5cfc-9216-4aadf5c28e6c', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', 'ما نتيجة الجمع 458 + 367؟', '[{"id":"a","text":"715"},{"id":"b","text":"725"},{"id":"c","text":"835"},{"id":"d","text":"825"}]'::jsonb, 'd', 'الآحاد: 8 + 7 = 15، نكتب 5 ونحتفظ بـ 1. العشرات: 5 + 6 + 1 = 12، نكتب 2 ونحتفظ بـ 1. المئات: 4 + 3 + 1 = 8. ✓ المجموع 825. الفخّ: نسيان احتفاظ العشرات يعطي 715.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2530f243-0aa9-5113-982e-f10e38c8e6cb', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', 'ما العدد المجهول في العمليّة ? − 345 = 255؟', '[{"id":"a","text":"90"},{"id":"b","text":"510"},{"id":"c","text":"700"},{"id":"d","text":"600"}]'::jsonb, 'd', 'المجهول هو المطروح منه؛ نجده بجمع الفرق والمطروح: ? = 255 + 345 = 600. ✓ التحقّق: 600 − 345 = 255 ✓. الفخّ: طرح 345 − 255 بدل جمعهما.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7e91316e-bb11-5f50-bbbd-55d035fad14a', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', 'ما نتيجة الطرح 700 − 256؟', '[{"id":"a","text":"444"},{"id":"b","text":"544"},{"id":"c","text":"454"},{"id":"d","text":"456"}]'::jsonb, 'a', 'الآحاد: 0 أصغر من 6، نستلف عبر الأصفار؛ 10 − 6 = 4. العشرات صارت 9؛ 9 − 5 = 4. المئات صارت 6؛ 6 − 2 = 4. ✓ الفرق 444. التحقّق: 444 + 256 = 700 ✓. الفخّ: الاستلاف عبر صفرين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a8f761f-a3ff-52ea-888a-7cd95a403dd8', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', 'ما نتيجة الجمع 2 345 + 1 678؟', '[{"id":"a","text":"3 923"},{"id":"b","text":"4 123"},{"id":"c","text":"4 023"},{"id":"d","text":"4 013"}]'::jsonb, 'c', 'الآحاد: 5 + 8 = 13 (نحتفظ 1). العشرات: 4 + 7 + 1 = 12 (نحتفظ 1). المئات: 3 + 6 + 1 = 10 (نكتب 0 نحتفظ 1). الآلاف: 2 + 1 + 1 = 4. ✓ المجموع 4 023. الفخّ: نسيان كتابة الصفر في المئات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d3c35281-6775-56f1-98a7-1b1a2dc3e7c0', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', 'ما نتيجة الطرح 5 204 − 2 376؟', '[{"id":"a","text":"3 132"},{"id":"b","text":"2 828"},{"id":"c","text":"2 928"},{"id":"d","text":"2 838"}]'::jsonb, 'b', 'الآحاد: 4 أصغر من 6، نستلف؛ 14 − 6 = 8. العشرات صارت 9؛ 9 − 7 = 2. المئات صارت 1؛ نستلف، 11 − 3 = 8. الآلاف صارت 4؛ 4 − 2 = 2. ✓ الفرق 2 828. التحقّق: 2 828 + 2 376 = 5 204 ✓. الفخّ: تتبّع الاستلاف عبر الرتب.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('43068a6d-2d93-5de3-a358-91055f3ca19e', 'cd83ae6c-3343-5934-be4a-a07196df5d4c', 'ما نتيجة الجمع 384 + 297؟', '[{"id":"a","text":"681"},{"id":"b","text":"571"},{"id":"c","text":"691"},{"id":"d","text":"671"}]'::jsonb, 'a', 'الآحاد: 4 + 7 = 11 (نكتب 1 نحتفظ 1). العشرات: 8 + 9 + 1 = 18 (نكتب 8 نحتفظ 1). المئات: 3 + 2 + 1 = 6. ✓ المجموع 681. الفخّ: نسيان احتفاظٍ من احتفاظين متتاليين.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('27d2f233-fc4a-5350-b0ae-9eed34f4273a', '9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('c5d93406-1c09-5ce8-98b9-81d6b697c3cd', '27d2f233-fc4a-5350-b0ae-9eed34f4273a', 'أيّ جمعٍ متكرّر يساوي 4 × 3؟', '[{"id":"a","text":"3 + 3 + 3 + 3"},{"id":"b","text":"4 + 3"},{"id":"c","text":"4 + 4 + 4 + 4"},{"id":"d","text":"3 + 3 + 3"}]'::jsonb, 'a', '4 × 3 تعني العدد 3 مأخوذًا 4 مرّات: 3 + 3 + 3 + 3 = 12. الفخّ: جمع العاملين 4 + 3 بدل تكرار الحدّ، أو تكرار 3 ثلاث مرّات فقط (3 + 3 + 3 = 9).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3f1fb2d6-d44a-57ad-9eb9-7e9d19a73655', '27d2f233-fc4a-5350-b0ae-9eed34f4273a', 'في العملية 6 × 7 = 42، ما هو الجداء؟', '[{"id":"a","text":"6"},{"id":"b","text":"7"},{"id":"c","text":"13"},{"id":"d","text":"42"}]'::jsonb, 'd', 'الجداء هو نتيجة الضرب، أي 42. أمّا 6 و7 فهما العاملان، و13 هو مجموعهما لا جداؤهما.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5261e219-d50e-5c0f-ab92-854aee32863e', '27d2f233-fc4a-5350-b0ae-9eed34f4273a', 'بفضل التبديلية، إذا كان 8 × 5 = 40 فإنّ 5 × 8 يساوي:', '[{"id":"a","text":"13"},{"id":"b","text":"40"},{"id":"c","text":"45"},{"id":"d","text":"58"}]'::jsonb, 'b', 'الضرب تبديليّ: a × b = b × a، فترتيب العاملين لا يُغيّر الجداء. إذن 5 × 8 = 8 × 5 = 40.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0ae2eb2f-d6e9-53fa-81de-366e5ef62bad', '27d2f233-fc4a-5350-b0ae-9eed34f4273a', 'ما حاصل 34 × 10؟', '[{"id":"a","text":"44"},{"id":"b","text":"304"},{"id":"c","text":"340"},{"id":"d","text":"3 400"}]'::jsonb, 'c', 'للضرب في 10 نُضيف صفرًا واحدًا على يمين العدد: 34 × 10 = 340. الفخّ: إضافة صفرين تعطي 3 400 وهي نتيجة الضرب في 100.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('73b04a81-2f64-5c8c-8364-91a1555d0506', '27d2f233-fc4a-5350-b0ae-9eed34f4273a', 'ما حاصل 6 × (4 + 3) باستعمال التوزيعية؟', '[{"id":"a","text":"13"},{"id":"b","text":"42"},{"id":"c","text":"27"},{"id":"d","text":"67"}]'::jsonb, 'b', 'التوزيعية: 6 × (4 + 3) = 6 × 4 + 6 × 3 = 24 + 18 = 42، وهو نفسه 6 × 7 = 42.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', '9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'math-3eme', '⭐ تمرين: أوّل خطوات في عالَم الضرب', 1, 50, 10, 'practice', 'admin', 1)
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
  ('0c17bef0-546b-5798-b08b-214195a13281', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', 'أيّ عمليّة ضربٍ توافق الجمع 5 + 5 + 5 + 5؟', '[{"id":"a","text":"4 × 5"},{"id":"b","text":"5 + 4"},{"id":"c","text":"5 × 5"},{"id":"d","text":"4 × 4"}]'::jsonb, 'a', 'العدد 5 مأخوذٌ 4 مرّات، فالجمع 5 + 5 + 5 + 5 = 4 × 5 = 20.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8ac97830-e2fe-5f06-a8c0-611127b2636c', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', 'ما جداء 3 × 6؟', '[{"id":"a","text":"9"},{"id":"b","text":"18"},{"id":"c","text":"36"},{"id":"d","text":"12"}]'::jsonb, 'b', 'في جدول 3: 3 × 6 = 6 + 6 + 6 = 18. إذن الجداء هو 18.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cf90789d-037f-5667-820c-2fd7eda40447', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', 'كم يساوي 7 × 1؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"7"},{"id":"d","text":"8"}]'::jsonb, 'c', 'كلّ عددٍ مضروبٍ في 1 يبقى كما هو، فـ 7 × 1 = 7.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b8f8127a-6f4f-5fdc-8ad2-ea0207b1c37c', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', 'ما هو ضِعف العدد 8؟', '[{"id":"a","text":"10"},{"id":"b","text":"4"},{"id":"c","text":"18"},{"id":"d","text":"16"}]'::jsonb, 'd', 'ضِعف عددٍ هو جداؤه في 2، فضِعف 8 هو 2 × 8 = 16.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('594d6a62-1bc0-5491-bfc8-d924826ba846', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', 'ما جداء 4 × 7؟', '[{"id":"a","text":"11"},{"id":"b","text":"24"},{"id":"c","text":"28"},{"id":"d","text":"32"}]'::jsonb, 'c', 'في جدول 4: 4 × 7 = 28. (24 هو 4 × 6 و32 هو 4 × 8.)', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('58029863-152b-5790-a3b3-79325851c816', '2c5f8d1b-6351-5046-8474-04dfd3b2d0e5', 'كم يساوي 9 × 0؟', '[{"id":"a","text":"0"},{"id":"b","text":"9"},{"id":"c","text":"90"},{"id":"d","text":"1"}]'::jsonb, 'a', 'كلّ عددٍ مضروبٍ في 0 يساوي 0، فـ 9 × 0 = 0.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('62d1e486-ec13-5bed-a60e-abc24b5bf6a1', '9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الجداء', 3, 120, 30, 'boss', 'admin', 2)
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
  ('5f5c4a91-cdf5-55b4-be49-49bb94090fe9', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'ما جداء 8 × 9؟', '[{"id":"a","text":"17"},{"id":"b","text":"64"},{"id":"c","text":"72"},{"id":"d","text":"81"}]'::jsonb, 'c', 'من جدول الضرب: 8 × 9 = 72. الخطأ الشائع: قلب الرقمين أو الخلط مع 8 × 8 = 64 و9 × 9 = 81؛ و17 هو مجموع العاملين لا جداؤهما.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('866a47e2-74b7-5904-b599-0e9ff468fe22', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'بالتوزيعية، كم يساوي 6 × (5 + 4)؟', '[{"id":"a","text":"54"},{"id":"b","text":"15"},{"id":"c","text":"34"},{"id":"d","text":"44"}]'::jsonb, 'a', 'التوزيعية: 6 × (5 + 4) = 6 × 5 + 6 × 4 = 30 + 24 = 54، وهو نفسه 6 × 9 = 54. الخطأ الشائع: ضرب 6 في الحدّ الأوّل فقط (6 × 5 = 30) ونسيان 6 × 4.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('81cb3427-414c-5784-b709-50f8de4fd778', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'ما حاصل 7 × 100؟', '[{"id":"a","text":"70"},{"id":"b","text":"700"},{"id":"c","text":"7 000"},{"id":"d","text":"107"}]'::jsonb, 'b', 'للضرب في 100 نُضيف صفرين على يمين العدد: 7 × 100 = 700. الخطأ الشائع: إضافة صفرٍ واحدٍ يعطي 70 (وهو الضرب في 10).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7f8dc560-1465-5d3c-9af6-09a4764646d9', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'ما حاصل 213 × 3؟', '[{"id":"a","text":"216"},{"id":"b","text":"636"},{"id":"c","text":"693"},{"id":"d","text":"639"}]'::jsonb, 'd', 'نضرب كلّ رقمٍ في 3: الآحاد 3 × 3 = 9، العشرات 3 × 1 = 3، المئات 3 × 2 = 6، فالجداء 639 ✓. الخطأ الشائع: جمع 213 + 3 = 216 بدل الضرب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a2998481-71a7-562e-b470-6efef047ecad', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'ما حاصل 47 × 6؟', '[{"id":"a","text":"242"},{"id":"b","text":"282"},{"id":"c","text":"246"},{"id":"d","text":"53"}]'::jsonb, 'b', 'الآحاد: 6 × 7 = 42، نكتب 2 ونحتفظ بـ 4. العشرات: 6 × 4 = 24 زائد الاحتفاظ 4 = 28. الجداء 282 ✓. الخطأ الشائع: نسيان الاحتفاظ 4 يعطي 242.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('afd74cb8-bfbd-5c21-a2b2-f28d342fc54c', '62d1e486-ec13-5bed-a60e-abc24b5bf6a1', 'ما حاصل 8 × 30؟', '[{"id":"a","text":"38"},{"id":"b","text":"110"},{"id":"c","text":"240"},{"id":"d","text":"2 400"}]'::jsonb, 'c', 'بما أنّ 30 = 3 × 10 نضرب في 3 ثمّ نُضيف صفرًا: 8 × 3 = 24، ثمّ 240. الخطأ الشائع: جمع 8 + 30 = 38، أو إضافة صفرين فيُكتب 2 400.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('de8e0a2a-0174-542f-ab5a-a568d93d9d9c', '9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الضرب من كلّ الأبواب', 2, 75, 15, 'practice', 'admin', 3)
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
  ('2b46c7b7-3342-5781-b3a0-8b872f2260d0', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'ما جداء 5 × 7؟', '[{"id":"a","text":"12"},{"id":"b","text":"30"},{"id":"c","text":"35"},{"id":"d","text":"57"}]'::jsonb, 'c', 'في جدول 5: 5 × 7 = 35. (30 هو 5 × 6 و12 هو مجموع العاملين.)', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0e5ef739-119e-5c9e-8432-f40dc22b05a7', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'بالتبديلية، إذا كان 9 × 4 = 36 فكم يساوي 4 × 9؟', '[{"id":"a","text":"36"},{"id":"b","text":"13"},{"id":"c","text":"45"},{"id":"d","text":"27"}]'::jsonb, 'a', 'الضرب تبديليّ: ترتيب العاملين لا يُغيّر الجداء، فـ 4 × 9 = 9 × 4 = 36.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3d9cab6c-f6ec-5b03-adeb-fe272e70fb81', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'ما حاصل 60 × 100؟', '[{"id":"a","text":"160"},{"id":"b","text":"600"},{"id":"c","text":"60 000"},{"id":"d","text":"6 000"}]'::jsonb, 'd', 'للضرب في 100 نُضيف صفرين على اليمين: 60 × 100 = 6 000. (إضافة صفرٍ واحدٍ تعطي 600 وهو الضرب في 10.)', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('78be4ec0-379e-5e18-ab0b-417325dcb0f8', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'ما حاصل 124 × 2؟', '[{"id":"a","text":"126"},{"id":"b","text":"248"},{"id":"c","text":"228"},{"id":"d","text":"244"}]'::jsonb, 'b', 'نضرب كلّ رقمٍ في 2: الآحاد 2 × 4 = 8، العشرات 2 × 2 = 4، المئات 2 × 1 = 2، فالجداء 248. (جمع 124 + 2 = 126 خطأ.)', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0fc931b8-3b5a-5b59-b02f-ad617575fe40', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'ما حاصل 24 × 3؟', '[{"id":"a","text":"62"},{"id":"b","text":"27"},{"id":"c","text":"72"},{"id":"d","text":"612"}]'::jsonb, 'c', 'الآحاد: 3 × 4 = 12، نكتب 2 ونحتفظ بـ 1. العشرات: 3 × 2 = 6 زائد 1 = 7. فالجداء 72. (نسيان الاحتفاظ يعطي 62.)', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2ce60d50-7d9b-505d-8f3c-c13ef5e142a2', 'de8e0a2a-0174-542f-ab5a-a568d93d9d9c', 'اشترى بطلٌ 8 علبٍ، في كلّ علبةٍ 7 سهام. كم سهمًا اشترى في المجموع؟', '[{"id":"a","text":"15 سهمًا"},{"id":"b","text":"56 سهمًا"},{"id":"c","text":"78 سهمًا"},{"id":"d","text":"49 سهمًا"}]'::jsonb, 'b', 'نضرب عدد العلب في عدد السهام في كلّ علبة: 8 × 7 = 56 سهمًا. (جمع 8 + 7 = 15 بدل الضرب خطأ.)', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d0e632bc-7b9c-5602-b313-cad273d88dc1', '9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز الضرب الكبرى', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c882d9ee-79d8-501c-9adf-37d229646cba', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', 'بالتجميعية، ما حاصل 2 × 3 × 5؟', '[{"id":"a","text":"10"},{"id":"b","text":"30"},{"id":"c","text":"25"},{"id":"d","text":"16"}]'::jsonb, 'b', 'نجمّع كما نشاء: (2 × 3) × 5 = 6 × 5 = 30، وكذلك 2 × (3 × 5) = 2 × 15 = 30 ✓. الخطأ الشائع: جمع الأعداد 2 + 3 + 5 = 10 بدل ضربها.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('48811efe-dac4-582a-b239-86c0ab587f31', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', 'عددٌ مضروبٌ في 4 يساوي 32. ما هو هذا العدد؟', '[{"id":"a","text":"8"},{"id":"b","text":"6"},{"id":"c","text":"28"},{"id":"d","text":"7"}]'::jsonb, 'a', 'نبحث في جدول 4 عن النتيجة 32: 4 × 8 = 32، فالعدد هو 8 ✓. الخطأ الشائع: طرح 32 − 4 = 28 بدل البحث في الجدول.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('959f521b-35a2-5856-b7d1-2b857f5f9391', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', 'ما حاصل 9 × 1000؟', '[{"id":"a","text":"900"},{"id":"b","text":"90 000"},{"id":"c","text":"1 009"},{"id":"d","text":"9 000"}]'::jsonb, 'd', 'للضرب في 1000 نُضيف ثلاثة أصفار على اليمين: 9 × 1000 = 9 000 ✓. الخطأ الشائع: إضافة صفرين فقط يعطي 900 (وهو الضرب في 100).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3115d2ce-f604-59c6-adf3-30e5badc7e35', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', 'اشترى تاجرٌ 6 صناديق، في كلّ صندوقٍ 25 سيفًا. كم سيفًا اشترى؟', '[{"id":"a","text":"31 سيفًا"},{"id":"b","text":"120 سيفًا"},{"id":"c","text":"150 سيفًا"},{"id":"d","text":"1 215 سيفًا"}]'::jsonb, 'c', 'نضرب 6 × 25: الآحاد 6 × 5 = 30 نكتب 0 ونحتفظ 3، العشرات 6 × 2 = 12 زائد 3 = 15، فالجداء 150 سيفًا ✓. الخطأ الشائع: نسيان الاحتفاظ 3 يعطي 120.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e58379f2-cb34-5fa6-a92f-04e713a42249', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', 'ما حاصل 8 × 125؟', '[{"id":"a","text":"133"},{"id":"b","text":"800"},{"id":"c","text":"1 000"},{"id":"d","text":"1 005"}]'::jsonb, 'c', 'نضرب 125 × 8: الآحاد 8 × 5 = 40 نكتب 0 ونحتفظ 4، العشرات 8 × 2 = 16 زائد 4 = 20 نكتب 0 ونحتفظ 2، المئات 8 × 1 = 8 زائد 2 = 10، فالجداء 1 000 ✓. الخطأ الشائع: نسيان الاحتفاظ يعطي 800.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b0591883-48e6-5e35-9c9c-15df82e0e179', 'd0e632bc-7b9c-5602-b313-cad273d88dc1', 'ما حاصل 234 × 3؟', '[{"id":"a","text":"692"},{"id":"b","text":"702"},{"id":"c","text":"237"},{"id":"d","text":"612"}]'::jsonb, 'b', 'الآحاد: 3 × 4 = 12 نكتب 2 ونحتفظ 1. العشرات: 3 × 3 = 9 زائد 1 = 10 نكتب 0 ونحتفظ 1. المئات: 3 × 2 = 6 زائد 1 = 7. فالجداء 702 ✓. الخطأ الشائع: نسيان الاحتفاظ في العشرات يعطي 692.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6514fe71-6d72-59e7-9260-ae643880620f', '9406e230-9fdf-58e6-8e7e-6acd0a39e6e9', 'math-3eme', '📝 تدريب ⭐⭐⭐: إتقان الضرب (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('7e852c4f-c78f-560d-a8d9-3fc03460c4a7', '6514fe71-6d72-59e7-9260-ae643880620f', 'ما جداء 7 × 9؟', '[{"id":"a","text":"16"},{"id":"b","text":"72"},{"id":"c","text":"56"},{"id":"d","text":"63"}]'::jsonb, 'd', 'من جدول الضرب: 7 × 9 = 63. الخطأ الشائع: 72 هو 8 × 9 و56 هو 7 × 8 و16 هو مجموع العاملين.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('23927ed2-26b7-5b78-92ea-143960596122', '6514fe71-6d72-59e7-9260-ae643880620f', 'بالتوزيعية، كم يساوي 5 × (8 + 2)؟', '[{"id":"a","text":"42"},{"id":"b","text":"50"},{"id":"c","text":"15"},{"id":"d","text":"40"}]'::jsonb, 'b', 'التوزيعية: 5 × (8 + 2) = 5 × 8 + 5 × 2 = 40 + 10 = 50، وهو نفسه 5 × 10 = 50. الخطأ الشائع: ضرب 5 في الحدّ الأوّل فقط (5 × 8 = 40) ونسيان 5 × 2.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('76ed5ae0-6a7f-55a0-a1cd-6bb485cb68e6', '6514fe71-6d72-59e7-9260-ae643880620f', 'ما حاصل 90 × 10؟', '[{"id":"a","text":"100"},{"id":"b","text":"9 000"},{"id":"c","text":"900"},{"id":"d","text":"910"}]'::jsonb, 'c', 'للضرب في 10 نُضيف صفرًا واحدًا على اليمين: 90 × 10 = 900. الخطأ الشائع: إضافة صفرين يعطي 9 000 (وهو الضرب في 100).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ff440060-dce6-5dd5-9719-2cb2eb07bb9a', '6514fe71-6d72-59e7-9260-ae643880620f', 'ما حاصل 153 × 3؟', '[{"id":"a","text":"359"},{"id":"b","text":"459"},{"id":"c","text":"453"},{"id":"d","text":"156"}]'::jsonb, 'b', 'الآحاد: 3 × 3 = 9. العشرات: 3 × 5 = 15 نكتب 5 ونحتفظ 1. المئات: 3 × 1 = 3 زائد 1 = 4. فالجداء 459 ✓. الخطأ الشائع: نسيان الاحتفاظ في المئات يعطي 359.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d9aef2f9-ed4b-540e-b2b6-3a6eee141605', '6514fe71-6d72-59e7-9260-ae643880620f', 'ما حاصل 36 × 5؟', '[{"id":"a","text":"180"},{"id":"b","text":"150"},{"id":"c","text":"41"},{"id":"d","text":"155"}]'::jsonb, 'a', 'الآحاد: 5 × 6 = 30 نكتب 0 ونحتفظ 3. العشرات: 5 × 3 = 15 زائد 3 = 18. فالجداء 180 ✓. الخطأ الشائع: نسيان الاحتفاظ 3 يعطي 150.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('25776c89-b5fd-5882-8c95-6a0e6e4b382b', '6514fe71-6d72-59e7-9260-ae643880620f', 'ما حاصل 8 × 400؟', '[{"id":"a","text":"320"},{"id":"b","text":"408"},{"id":"c","text":"32 000"},{"id":"d","text":"3 200"}]'::jsonb, 'd', 'بما أنّ 400 = 4 × 100 نضرب في 4 ثمّ نُضيف صفرين: 8 × 4 = 32، ثمّ 3 200 ✓. الخطأ الشائع: إضافة صفرٍ واحدٍ يعطي 320 بدل صفرين.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('68fcfcd2-e474-535f-afcb-4be86b27d228', 'e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b6886e80-b384-5f66-8c7a-949b39153443', '68fcfcd2-e474-535f-afcb-4be86b27d228', 'في الشبكة، ما اسم النقطة التي يلتقي فيها خطّان (سطرٌ مع عمود)؟', '[{"id":"a","text":"العقدة"},{"id":"b","text":"الخانة"},{"id":"c","text":"الضلع"},{"id":"d","text":"العمود"}]'::jsonb, 'a', 'العقدة هي نقطة تقاطُع سطرٍ مع عمود. أمّا الخانة فهي المساحة المحصورة بين الخطوط.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9436f60-ced4-5082-a963-35cc12e0b8d6', '68fcfcd2-e474-535f-afcb-4be86b27d228', 'ما عدد أضلاع المثلّث؟', '[{"id":"a","text":"ضلعان"},{"id":"b","text":"5 أضلاع"},{"id":"c","text":"4 أضلاع"},{"id":"d","text":"3 أضلاع"}]'::jsonb, 'd', 'المثلّث مضلّعٌ له 3 أضلاع و3 رؤوس، وهو أقلّ المضلّعات أضلاعًا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a4435588-a062-5927-a0e7-c1d7a204cef4', '68fcfcd2-e474-535f-afcb-4be86b27d228', 'كم خطوةً في هذا المسلك السميك من A إلى B؟ (عُدّ القطع بين العُقد)<svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="25" x2="100" y2="25"/><line x1="20" y1="55" x2="100" y2="55"/><line x1="20" y1="85" x2="100" y2="85"/><line x1="20" y1="25" x2="20" y2="85"/><line x1="60" y1="25" x2="60" y2="85"/><line x1="100" y1="25" x2="100" y2="85"/></g><polyline points="20,25 60,25 100,25 100,55" fill="none" stroke="#1f2937" stroke-width="3"/><g fill="#1f2937"><circle cx="20" cy="25" r="3.5"/><circle cx="100" cy="55" r="3.5"/></g><text x="14" y="22" fill="#1f2937" font-size="9" text-anchor="end">A</text><text x="106" y="58" fill="#1f2937" font-size="9">B</text></svg>', '[{"id":"a","text":"خطوتان"},{"id":"b","text":"3 خطوات"},{"id":"c","text":"4 خطوات"},{"id":"d","text":"5 خطوات"}]'::jsonb, 'b', 'نعدّ القطع بين العُقد على المسلك: يمين ثمّ يمين ثمّ نزول = 3 خطوات.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d826811d-33ae-5982-9863-e3586da90ab7', '68fcfcd2-e474-535f-afcb-4be86b27d228', 'ما اسم هذا المضلّع المرسوم على الشبكة؟<svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="20" x2="100" y2="20"/><line x1="20" y1="50" x2="100" y2="50"/><line x1="20" y1="80" x2="100" y2="80"/><line x1="20" y1="20" x2="20" y2="80"/><line x1="60" y1="20" x2="60" y2="80"/><line x1="100" y1="20" x2="100" y2="80"/></g><polygon points="20,20 100,20 100,80 20,80" fill="none" stroke="#1f2937" stroke-width="2.4"/><g fill="#1f2937"><circle cx="20" cy="20" r="3"/><circle cx="100" cy="20" r="3"/><circle cx="100" cy="80" r="3"/><circle cx="20" cy="80" r="3"/></g></svg>', '[{"id":"a","text":"مثلّث"},{"id":"b","text":"خماسيّ"},{"id":"c","text":"رباعيّ"},{"id":"d","text":"سداسيّ"}]'::jsonb, 'c', 'هذا الشكل المغلق له 4 أضلاع و4 رؤوس، فهو رباعيّ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c5e78bf2-6447-53a1-95f4-fb8393484462', '68fcfcd2-e474-535f-afcb-4be86b27d228', 'العقدة المعلّمة بنقطةٍ سوداء تقع في السطر 2 والعمود 4. كيف نكتب موضعها بالزوج (سطر، عمود)؟
<svg viewBox="0 0 138 106">
<title>شبكة: عقدة في السطر 2 والعمود 4</title>
<g stroke="#94a3b8" stroke-width="1.4"><line x1="34" y1="30" x2="112" y2="30" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="56" x2="112" y2="56" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="82" x2="112" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="30" x2="34" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="60" y1="30" x2="60" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="86" y1="30" x2="86" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="112" y1="30" x2="112" y2="82" stroke="#94a3b8" stroke-width="1.4"/></g><circle cx="112" cy="56" r="5" fill="#0f172a" stroke="none" stroke-width="2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="21" y="35" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="21" y="61" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="21" y="87" text-anchor="middle" fill="#0f172a" font-size="13">3</text><text x="34" y="19" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="60" y="19" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="86" y="19" text-anchor="middle" fill="#0f172a" font-size="13">3</text><text x="112" y="19" text-anchor="middle" fill="#0f172a" font-size="13">4</text></g>
</svg>', '[{"id":"a","text":"(4 ; 2)"},{"id":"b","text":"(2 ; 2)"},{"id":"c","text":"(4 ; 4)"},{"id":"d","text":"(2 ; 4)"}]'::jsonb, 'd', 'نكتب السطر أوّلًا ثمّ العمود: السطر 2 والعمود 4، أي (2 ; 4). الترتيب (4 ; 2) خطأ لأنّه يعكس السطر والعمود.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', 'e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'math-3eme', '⭐ تمرين: أوّل خطواتك على الشبكة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('58dcf684-3a44-5ee2-95e1-da7d94c23d64', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', 'في الشبكة، نعدّ الأسطر من الأعلى إلى الأسفل. والخطوط العموديّة نسمّيها:', '[{"id":"a","text":"الأعمدة"},{"id":"b","text":"الخانات"},{"id":"c","text":"العُقد"},{"id":"d","text":"المسالك"}]'::jsonb, 'a', 'الخطوط الأفقيّة هي الأسطر، والخطوط العموديّة هي الأعمدة. تقاطُع سطرٍ مع عمودٍ يعطي عقدة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b278954b-c27e-5088-a321-113da23c229d', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', 'ما عدد أضلاع الرباعيّ؟', '[{"id":"a","text":"3 أضلاع"},{"id":"b","text":"4 أضلاع"},{"id":"c","text":"5 أضلاع"},{"id":"d","text":"6 أضلاع"}]'::jsonb, 'b', 'الرباعيّ مضلّعٌ له 4 أضلاع و4 رؤوس.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6d061210-7da5-506b-9b30-f68eb54e1d04', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', 'ما اسم هذا المضلّع؟<svg viewBox="0 0 110 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="20" x2="90" y2="20"/><line x1="20" y1="55" x2="90" y2="55"/><line x1="20" y1="90" x2="90" y2="90"/><line x1="20" y1="20" x2="20" y2="90"/><line x1="55" y1="20" x2="55" y2="90"/><line x1="90" y1="20" x2="90" y2="90"/></g><polygon points="55,20 90,90 20,90" fill="none" stroke="#1f2937" stroke-width="2.4"/><g fill="#1f2937"><circle cx="55" cy="20" r="3"/><circle cx="90" cy="90" r="3"/><circle cx="20" cy="90" r="3"/></g></svg>', '[{"id":"a","text":"رباعيّ"},{"id":"b","text":"خماسيّ"},{"id":"c","text":"مثلّث"},{"id":"d","text":"سداسيّ"}]'::jsonb, 'c', 'للشكل 3 أضلاع و3 رؤوس، فهو مثلّث.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9bf604f-84ee-5587-8b45-9be2bf43be8a', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', 'كم خطوةً في هذا المسلك السميك من A إلى B؟<svg viewBox="0 0 120 80" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="15" y1="40" x2="105" y2="40"/><line x1="15" y1="20" x2="15" y2="60"/><line x1="45" y1="20" x2="45" y2="60"/><line x1="75" y1="20" x2="75" y2="60"/><line x1="105" y1="20" x2="105" y2="60"/></g><polyline points="15,40 45,40 75,40 105,40" fill="none" stroke="#1f2937" stroke-width="3"/><g fill="#1f2937"><circle cx="15" cy="40" r="3.5"/><circle cx="45" cy="40" r="3.5"/><circle cx="75" cy="40" r="3.5"/><circle cx="105" cy="40" r="3.5"/></g><text x="15" y="16" fill="#1f2937" font-size="9" text-anchor="middle">A</text><text x="105" y="16" fill="#1f2937" font-size="9" text-anchor="middle">B</text></svg>', '[{"id":"a","text":"خطوتان"},{"id":"b","text":"خطوة واحدة"},{"id":"c","text":"4 خطوات"},{"id":"d","text":"3 خطوات"}]'::jsonb, 'd', 'المسلك يمرّ بـ 4 عُقد، وبينها 3 قطع، إذن 3 خطوات. نعدّ القطع لا العُقد.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e8908e1c-7cad-541d-a2ff-fff7a9cc7670', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', 'العقدة المعلّمة تقع في السطر 1 والعمود 3. ما موضعها بالزوج (سطر، عمود)؟
<svg viewBox="0 0 112 106">
<title>شبكة: عقدة في السطر 1 والعمود 3</title>
<g stroke="#94a3b8" stroke-width="1.4"><line x1="34" y1="30" x2="86" y2="30" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="56" x2="86" y2="56" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="82" x2="86" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="30" x2="34" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="60" y1="30" x2="60" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="86" y1="30" x2="86" y2="82" stroke="#94a3b8" stroke-width="1.4"/></g><circle cx="86" cy="30" r="5" fill="#2563eb" stroke="none" stroke-width="2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="21" y="35" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="21" y="61" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="21" y="87" text-anchor="middle" fill="#0f172a" font-size="13">3</text><text x="34" y="19" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="60" y="19" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="86" y="19" text-anchor="middle" fill="#0f172a" font-size="13">3</text></g>
</svg>', '[{"id":"a","text":"(3 ; 1)"},{"id":"b","text":"(1 ; 3)"},{"id":"c","text":"(1 ; 1)"},{"id":"d","text":"(3 ; 3)"}]'::jsonb, 'b', 'نكتب السطر أوّلًا ثمّ العمود: السطر 1 والعمود 3 يُكتب (1 ; 3).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3f4882ae-6233-5155-8dec-159e7ced1c3f', '6f8bca92-5bde-5296-a8e9-e6c5f5cd9f99', 'كم رأسًا للمضلّع السداسيّ؟', '[{"id":"a","text":"4 رؤوس"},{"id":"b","text":"5 رؤوس"},{"id":"c","text":"6 رؤوس"},{"id":"d","text":"3 رؤوس"}]'::jsonb, 'c', 'في كلّ مضلّع عدد الرؤوس يساوي عدد الأضلاع. السداسيّ له 6 أضلاع، إذن 6 رؤوس.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: معركة الشبكة والمضلّعات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('5fe53e1c-2b68-5aa2-bd5e-6a059f041bbd', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'ما اسم هذا المضلّع المرسوم على الشبكة؟<svg viewBox="0 0 140 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="20" x2="120" y2="20"/><line x1="20" y1="55" x2="120" y2="55"/><line x1="20" y1="90" x2="120" y2="90"/><line x1="20" y1="20" x2="20" y2="90"/><line x1="45" y1="20" x2="45" y2="90"/><line x1="70" y1="20" x2="70" y2="90"/><line x1="95" y1="20" x2="95" y2="90"/><line x1="120" y1="20" x2="120" y2="90"/></g><polygon points="45,20 95,20 120,55 95,90 45,90 20,55" fill="none" stroke="#1f2937" stroke-width="2.4"/><g fill="#1f2937"><circle cx="45" cy="20" r="3"/><circle cx="95" cy="20" r="3"/><circle cx="120" cy="55" r="3"/><circle cx="95" cy="90" r="3"/><circle cx="45" cy="90" r="3"/><circle cx="20" cy="55" r="3"/></g></svg>', '[{"id":"a","text":"رباعيّ"},{"id":"b","text":"سداسيّ"},{"id":"c","text":"خماسيّ"},{"id":"d","text":"مثلّث"}]'::jsonb, 'b', 'نعدّ القطع المستقيمة: 6 أضلاع و6 رؤوس، إذن سداسيّ. الخطأ الشائع: عدّ الرؤوس العلويّة فقط ونسيان السفليّة فيظنّه البعض خماسيًّا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('70169f78-8c33-5ea0-b6e9-464afe28c636', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'ما موضع العقدة المعلّمة بالزوج (سطر، عمود)؟<svg viewBox="0 0 130 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="1" fill="none"><line x1="35" y1="25" x2="115" y2="25"/><line x1="35" y1="55" x2="115" y2="55"/><line x1="35" y1="85" x2="115" y2="85"/><line x1="35" y1="25" x2="35" y2="85"/><line x1="55" y1="25" x2="55" y2="85"/><line x1="75" y1="25" x2="75" y2="85"/><line x1="95" y1="25" x2="95" y2="85"/><line x1="115" y1="25" x2="115" y2="85"/></g><text x="27" y="28" fill="#1f2937" font-size="8" text-anchor="end">1</text><text x="27" y="58" fill="#1f2937" font-size="8" text-anchor="end">2</text><text x="27" y="88" fill="#1f2937" font-size="8" text-anchor="end">3</text><text x="35" y="18" fill="#1f2937" font-size="8" text-anchor="middle">1</text><text x="55" y="18" fill="#1f2937" font-size="8" text-anchor="middle">2</text><text x="75" y="18" fill="#1f2937" font-size="8" text-anchor="middle">3</text><text x="95" y="18" fill="#1f2937" font-size="8" text-anchor="middle">4</text><text x="115" y="18" fill="#1f2937" font-size="8" text-anchor="middle">5</text><circle cx="95" cy="85" r="4" fill="#1f2937"/></svg>', '[{"id":"a","text":"(4 ; 3)"},{"id":"b","text":"(3 ; 5)"},{"id":"c","text":"(3 ; 4)"},{"id":"d","text":"(4 ; 4)"}]'::jsonb, 'c', 'العقدة في السطر 3 (الأسفل) والعمود 4، إذن (3 ; 4). الخطأ الشائع: كتابة (4 ; 3) بعكس السطر والعمود.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b642b298-113e-5507-95f3-2ee513c1bdd0', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'مسلكٌ من A إلى B طوله 5 خطوات، ومسلكٌ آخر بينهما طوله 5 خطوات أيضًا. ماذا نقول عنهما؟', '[{"id":"a","text":"متكافئان"},{"id":"b","text":"المسلك الأوّل أطول"},{"id":"c","text":"المسلك الثاني أطول"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'المسلكان لهما نفس عدد الخطوات (5 و5)، فهما متكافئان حتّى لو اختلف شكلهما. الخطأ الشائع: الظنّ أنّ المسلك الأكثر تعرّجًا أطول، بينما العبرة بعدد الخطوات فقط.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dbcf4272-63b4-54a7-950a-3b3702134a4b', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'كم خطوةً في هذا المسلك السميك من A إلى B؟<svg viewBox="0 0 130 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="25" x2="110" y2="25"/><line x1="20" y1="60" x2="110" y2="60"/><line x1="20" y1="95" x2="110" y2="95"/><line x1="20" y1="25" x2="20" y2="95"/><line x1="65" y1="25" x2="65" y2="95"/><line x1="110" y1="25" x2="110" y2="95"/></g><polyline points="20,95 20,60 65,60 65,25 110,25" fill="none" stroke="#1f2937" stroke-width="3"/><g fill="#1f2937"><circle cx="20" cy="95" r="3.5"/><circle cx="110" cy="25" r="3.5"/></g><text x="14" y="98" fill="#1f2937" font-size="9" text-anchor="end">A</text><text x="114" y="22" fill="#1f2937" font-size="9">B</text></svg>', '[{"id":"a","text":"3 خطوات"},{"id":"b","text":"5 خطوات"},{"id":"c","text":"خطوتان"},{"id":"d","text":"4 خطوات"}]'::jsonb, 'd', 'نعدّ القطع: صعود، يمين، صعود، يمين = 4 خطوات. الخطأ الشائع: عدّ العُقد (5 عُقد) بدل القطع، فيكون الجواب الخاطئ 5.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6b1f9272-473b-575b-b255-4193de487852', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'شكلٌ مغلقٌ عدّينا له 5 رؤوس. كم ضلعًا له؟', '[{"id":"a","text":"4 أضلاع"},{"id":"b","text":"6 أضلاع"},{"id":"c","text":"5 أضلاع"},{"id":"d","text":"10 أضلاع"}]'::jsonb, 'c', 'في كلّ مضلّع عدد الأضلاع يساوي عدد الرؤوس، إذن 5 رؤوس ← 5 أضلاع (خماسيّ). الخطأ الشائع: مضاعفة العدد (5 × 2 = 10) ظنًّا أنّ لكلّ رأسٍ ضلعين.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2a4016cb-8483-5ce4-9936-8f67fc1f62cd', '44a3f827-8941-5fd9-8895-2f5fb266d3d4', 'مضلّعان: الأوّل له 4 أضلاع والثاني له 6 أضلاع. كم ضلعًا في الثاني أكثر من الأوّل؟', '[{"id":"a","text":"2"},{"id":"b","text":"10"},{"id":"c","text":"3"},{"id":"d","text":"1"}]'::jsonb, 'a', 'الفرق 6 − 4 = 2، أي ضلعان أكثر (سداسيّ مقابل رباعيّ). الخطأ الشائع: جمع العددين 6 + 4 = 10 بدل طرحهما.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ec820faa-04fd-53ac-9841-5477b8ba7984', 'e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الشبكة والمضلّعات', 2, 75, 15, 'practice', 'admin', 3)
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
  ('8677585d-e569-50da-96e2-ddea9049b581', 'ec820faa-04fd-53ac-9841-5477b8ba7984', 'أيّ هذه الجمل صحيحة عن العقدة والخانة؟', '[{"id":"a","text":"العقدة نقطةٌ على تقاطُع الخطوط، والخانة مساحةٌ بينها"},{"id":"b","text":"العقدة مساحة، والخانة نقطة"},{"id":"c","text":"العقدة والخانة شيءٌ واحد"},{"id":"d","text":"العقدة خطٌّ عموديّ"}]'::jsonb, 'a', 'العقدة نقطة تقاطُع سطرٍ مع عمود، أمّا الخانة فهي المساحة المربّعة المحصورة بين الخطوط.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0d1c0441-9d90-5bc0-a8b7-6023a7f562a7', 'ec820faa-04fd-53ac-9841-5477b8ba7984', 'العقدة في السطر 3 والعمود 2. ما موضعها بالزوج (سطر، عمود)؟
<svg viewBox="0 0 112 106">
<title>شبكة: عقدة في السطر 3 والعمود 2</title>
<g stroke="#94a3b8" stroke-width="1.4"><line x1="34" y1="30" x2="86" y2="30" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="56" x2="86" y2="56" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="82" x2="86" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="30" x2="34" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="60" y1="30" x2="60" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="86" y1="30" x2="86" y2="82" stroke="#94a3b8" stroke-width="1.4"/></g><circle cx="60" cy="82" r="5" fill="#2563eb" stroke="none" stroke-width="2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="21" y="35" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="21" y="61" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="21" y="87" text-anchor="middle" fill="#0f172a" font-size="13">3</text><text x="34" y="19" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="60" y="19" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="86" y="19" text-anchor="middle" fill="#0f172a" font-size="13">3</text></g>
</svg>', '[{"id":"a","text":"(2 ; 3)"},{"id":"b","text":"(3 ; 2)"},{"id":"c","text":"(3 ; 3)"},{"id":"d","text":"(2 ; 2)"}]'::jsonb, 'b', 'السطر أوّلًا ثمّ العمود: السطر 3 والعمود 2 يُكتب (3 ; 2). الزوج (2 ; 3) يعكس الترتيب فهو خطأ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('647bf360-8e9d-551b-a39f-3ea1dd9e3722', 'ec820faa-04fd-53ac-9841-5477b8ba7984', 'ما اسم هذا المضلّع؟<svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="20" x2="100" y2="20"/><line x1="20" y1="55" x2="100" y2="55"/><line x1="20" y1="90" x2="100" y2="90"/><line x1="20" y1="20" x2="20" y2="90"/><line x1="60" y1="20" x2="60" y2="90"/><line x1="100" y1="20" x2="100" y2="90"/></g><polygon points="60,20 100,55 60,90 20,55" fill="none" stroke="#1f2937" stroke-width="2.4"/><g fill="#1f2937"><circle cx="60" cy="20" r="3"/><circle cx="100" cy="55" r="3"/><circle cx="60" cy="90" r="3"/><circle cx="20" cy="55" r="3"/></g></svg>', '[{"id":"a","text":"مثلّث"},{"id":"b","text":"خماسيّ"},{"id":"c","text":"رباعيّ"},{"id":"d","text":"سداسيّ"}]'::jsonb, 'c', 'للشكل المغلق 4 أضلاع و4 رؤوس، فهو رباعيّ.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('86824189-3bb6-5239-bc1b-e8d2f633a505', 'ec820faa-04fd-53ac-9841-5477b8ba7984', 'مسلكٌ يمرّ بـ 6 عُقد على التوالي. كم خطوةً فيه؟', '[{"id":"a","text":"6 خطوات"},{"id":"b","text":"7 خطوات"},{"id":"c","text":"4 خطوات"},{"id":"d","text":"5 خطوات"}]'::jsonb, 'd', 'عدد الخطوات = عدد القطع = عدد العُقد ناقص 1، أي 6 − 1 = 5 خطوات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('de5c898b-5059-5777-b25f-0f08e1aad169', 'ec820faa-04fd-53ac-9841-5477b8ba7984', 'أيّ مضلّعٍ له عدد أضلاعٍ أكثر من الرباعيّ بضلعين؟', '[{"id":"a","text":"السداسيّ"},{"id":"b","text":"الخماسيّ"},{"id":"c","text":"المثلّث"},{"id":"d","text":"الرباعيّ"}]'::jsonb, 'a', 'الرباعيّ له 4 أضلاع، و4 + 2 = 6، فالمضلّع المطلوب هو السداسيّ (6 أضلاع).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c5f667f7-683f-571c-b4e0-2c503c448b53', 'ec820faa-04fd-53ac-9841-5477b8ba7984', 'جملةٌ واحدة خاطئة. أيّها هي؟', '[{"id":"a","text":"في المضلّع عدد الأضلاع يساوي عدد الرؤوس"},{"id":"b","text":"المثلّث له 3 أضلاع"},{"id":"c","text":"السداسيّ له 6 أضلاع"},{"id":"d","text":"الخماسيّ له 4 رؤوس"}]'::jsonb, 'd', 'الجملة الخاطئة هي «الخماسيّ له 4 رؤوس»: الخماسيّ له 5 أضلاع و5 رؤوس وليس 4. بقيّة الجمل صحيحة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('04650261-2f0b-5fc9-8f35-c08ecc71698b', 'e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد الشبكة والمضلّعات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('0e65047c-b4b2-5902-adbd-06ebd1c0b79e', '04650261-2f0b-5fc9-8f35-c08ecc71698b', 'أصغر مسلكٍ من A إلى B يحتاج 3 خطوات يمينًا وخطوتين نزولًا. كم خطوةً طوله؟', '[{"id":"a","text":"5 خطوات"},{"id":"b","text":"6 خطوات"},{"id":"c","text":"خطوتان"},{"id":"d","text":"3 خطوات"}]'::jsonb, 'a', 'نجمع كلّ الخطوات: 3 يمينًا + 2 نزولًا = 5 خطوات. الخطأ الشائع: حساب اتّجاهٍ واحد فقط (3 أو 2) ونسيان جمع الاتّجاهين.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('25d86d5e-6ed7-5fa0-896f-a323290c2bb0', '04650261-2f0b-5fc9-8f35-c08ecc71698b', 'ما اسم هذا المضلّع، وكم رأسًا له؟<svg viewBox="0 0 130 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="25" x2="110" y2="25"/><line x1="20" y1="60" x2="110" y2="60"/><line x1="20" y1="95" x2="110" y2="95"/><line x1="20" y1="25" x2="20" y2="95"/><line x1="65" y1="25" x2="65" y2="95"/><line x1="110" y1="25" x2="110" y2="95"/></g><polygon points="65,25 110,25 110,60 65,95 20,60 20,25" fill="none" stroke="#1f2937" stroke-width="2.4"/><g fill="#1f2937"><circle cx="65" cy="25" r="3"/><circle cx="110" cy="25" r="3"/><circle cx="110" cy="60" r="3"/><circle cx="65" cy="95" r="3"/><circle cx="20" cy="60" r="3"/><circle cx="20" cy="25" r="3"/></g></svg>', '[{"id":"a","text":"خماسيّ، 5 رؤوس"},{"id":"b","text":"سداسيّ، 6 رؤوس"},{"id":"c","text":"رباعيّ، 4 رؤوس"},{"id":"d","text":"سداسيّ، 5 رؤوس"}]'::jsonb, 'b', 'نعدّ القطع: 6 أضلاع، ولأنّ عدد الرؤوس = عدد الأضلاع فله 6 رؤوس، إذن سداسيّ. الخطأ الشائع: اختيار «6 أضلاع و5 رؤوس»، لكنّ العددين متساويان دائمًا في المضلّع.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e58cd0ad-8648-53b2-beeb-d1b7c6ddc18c', '04650261-2f0b-5fc9-8f35-c08ecc71698b', 'العقدة P في الموضع (2 ; 3) والعقدة Q في الموضع (2 ; 5)، أي في نفس السطر. كم خطوةً أفقيّةً بينهما؟', '[{"id":"a","text":"5 خطوات"},{"id":"b","text":"3 خطوات"},{"id":"c","text":"خطوتان"},{"id":"d","text":"خطوة واحدة"}]'::jsonb, 'c', 'العقدتان في السطر 2، والفرق في العمود 5 − 3 = 2، إذن خطوتان أفقيًّا. الخطأ الشائع: جمع رقمي العمودين 5 + 3 = 8 أو استعمال رقم السطر بدل الفرق.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('45befdd7-de41-5992-ac73-24cb77509749', '04650261-2f0b-5fc9-8f35-c08ecc71698b', 'مسلكان من A إلى B: الأوّل 4 خطوات والثاني 4 خطوات، لكنّ الثاني أكثر تعرّجًا. أيّهما أطول؟', '[{"id":"a","text":"الأوّل"},{"id":"b","text":"الثاني لأنّه أكثر تعرّجًا"},{"id":"c","text":"لا نعرف"},{"id":"d","text":"هما متكافئان (نفس الطول)"}]'::jsonb, 'd', 'الطول يُقاس بعدد الخطوات لا بالشكل: 4 = 4، فهما متكافئان. الخطأ الشائع: ظنّ أنّ المسلك الأكثر انحناءً أطول، بينما التعرّج لا يزيد عدد الخطوات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d8d061f3-d5f6-5f14-8966-f49f4acf5ea0', '04650261-2f0b-5fc9-8f35-c08ecc71698b', 'رسمنا مضلّعًا بـ 3 رؤوس ثمّ مضلّعًا بـ 5 رؤوس. كم ضلعًا مجموع المضلّعين معًا؟', '[{"id":"a","text":"7"},{"id":"b","text":"8"},{"id":"c","text":"9"},{"id":"d","text":"15"}]'::jsonb, 'b', 'أضلاع كلّ مضلّعٍ = رؤوسه: 3 و5. المجموع 3 + 5 = 8 أضلاع. الخطأ الشائع: ضرب العددين 3 × 5 = 15 بدل جمعهما.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('611936ee-593a-5c1b-8de9-d915b0bf6d1e', '04650261-2f0b-5fc9-8f35-c08ecc71698b', 'أيّ زوجٍ من المسالك بين نفس النقطتين يكون حتمًا متكافئًا؟', '[{"id":"a","text":"مسلكان طولهما 3 خطوات و4 خطوات"},{"id":"b","text":"مسلكان طولهما 5 خطوات و6 خطوات"},{"id":"c","text":"مسلكان طولهما 4 خطوات و4 خطوات"},{"id":"d","text":"مسلكان طولهما 2 خطوة و4 خطوات"}]'::jsonb, 'c', 'المسلكان متكافئان فقط إذا تساوى عدد خطواتهما؛ 4 = 4 وحدها تحقّق ذلك. الخطأ الشائع: اعتبار أيّ مسلكين بين نفس النقطتين متكافئين، لكنّ الطول قد يختلف.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('836f097b-ff8d-5790-a559-f91a64bc4129', 'e637764e-0c3b-5e04-8539-d1c3d746cf2c', 'math-3eme', '📝 تدريب ⭐⭐⭐: الشبكة والمسالك والمضلّعات (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('a892f36b-999a-572d-b15c-4b8c0d272958', '836f097b-ff8d-5790-a559-f91a64bc4129', 'في الشبكة، الخطوط الأفقيّة تُسمّى:', '[{"id":"a","text":"الأسطر"},{"id":"b","text":"الأعمدة"},{"id":"c","text":"الرؤوس"},{"id":"d","text":"الأضلاع"}]'::jsonb, 'a', 'الخطوط الأفقيّة هي الأسطر (نعدّها من الأعلى إلى الأسفل)، والعموديّة هي الأعمدة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4a3bc43e-d26b-5ae6-a801-47db18700738', '836f097b-ff8d-5790-a559-f91a64bc4129', 'ما اسم هذا المضلّع؟<svg viewBox="0 0 130 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="20" x2="110" y2="20"/><line x1="20" y1="55" x2="110" y2="55"/><line x1="20" y1="90" x2="110" y2="90"/><line x1="20" y1="20" x2="20" y2="90"/><line x1="65" y1="20" x2="65" y2="90"/><line x1="110" y1="20" x2="110" y2="90"/></g><polygon points="65,20 110,55 65,90 20,55" fill="none" stroke="#1f2937" stroke-width="2.4"/><g fill="#1f2937"><circle cx="65" cy="20" r="3"/><circle cx="110" cy="55" r="3"/><circle cx="65" cy="90" r="3"/><circle cx="20" cy="55" r="3"/></g></svg>', '[{"id":"a","text":"مثلّث"},{"id":"b","text":"رباعيّ"},{"id":"c","text":"خماسيّ"},{"id":"d","text":"سداسيّ"}]'::jsonb, 'b', 'للشكل المغلق 4 أضلاع و4 رؤوس، فهو رباعيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('597bdb0b-ee05-5669-ac88-d71acc96be73', '836f097b-ff8d-5790-a559-f91a64bc4129', 'العقدة في السطر 2 والعمود 1. ما موضعها بالزوج (سطر، عمود)؟
<svg viewBox="0 0 112 106">
<title>شبكة: عقدة في السطر 2 والعمود 1</title>
<g stroke="#94a3b8" stroke-width="1.4"><line x1="34" y1="30" x2="86" y2="30" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="56" x2="86" y2="56" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="82" x2="86" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="34" y1="30" x2="34" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="60" y1="30" x2="60" y2="82" stroke="#94a3b8" stroke-width="1.4"/><line x1="86" y1="30" x2="86" y2="82" stroke="#94a3b8" stroke-width="1.4"/></g><circle cx="34" cy="56" r="5" fill="#2563eb" stroke="none" stroke-width="2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="21" y="35" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="21" y="61" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="21" y="87" text-anchor="middle" fill="#0f172a" font-size="13">3</text><text x="34" y="19" text-anchor="middle" fill="#0f172a" font-size="13">1</text><text x="60" y="19" text-anchor="middle" fill="#0f172a" font-size="13">2</text><text x="86" y="19" text-anchor="middle" fill="#0f172a" font-size="13">3</text></g>
</svg>', '[{"id":"a","text":"(1 ; 2)"},{"id":"b","text":"(2 ; 2)"},{"id":"c","text":"(2 ; 1)"},{"id":"d","text":"(1 ; 1)"}]'::jsonb, 'c', 'السطر أوّلًا ثمّ العمود: السطر 2 والعمود 1 يُكتب (2 ; 1). الزوج (1 ; 2) يعكس الترتيب.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9100e39c-a7df-5957-b7b3-6363f0398c00', '836f097b-ff8d-5790-a559-f91a64bc4129', 'كم خطوةً في هذا المسلك السميك من A إلى B؟<svg viewBox="0 0 130 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#9ca3af" stroke-width="0.8" fill="none"><line x1="20" y1="25" x2="110" y2="25"/><line x1="20" y1="60" x2="110" y2="60"/><line x1="20" y1="95" x2="110" y2="95"/><line x1="20" y1="25" x2="20" y2="95"/><line x1="65" y1="25" x2="65" y2="95"/><line x1="110" y1="25" x2="110" y2="95"/></g><polyline points="20,25 65,25 65,60 65,95 110,95" fill="none" stroke="#1f2937" stroke-width="3"/><g fill="#1f2937"><circle cx="20" cy="25" r="3.5"/><circle cx="110" cy="95" r="3.5"/></g><text x="14" y="22" fill="#1f2937" font-size="9" text-anchor="end">A</text><text x="114" y="98" fill="#1f2937" font-size="9">B</text></svg>', '[{"id":"a","text":"خطوتان"},{"id":"b","text":"5 خطوات"},{"id":"c","text":"3 خطوات"},{"id":"d","text":"4 خطوات"}]'::jsonb, 'd', 'نعدّ القطع: يمين، نزول، نزول، يمين = 4 خطوات. الخطأ الشائع: عدّ العُقد (5) بدل القطع (4).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cbe88324-1ef1-53ff-8eb4-a7dba0c7e302', '836f097b-ff8d-5790-a559-f91a64bc4129', 'مضلّعٌ له 6 أضلاع. كم رأسًا له؟', '[{"id":"a","text":"12 رأسًا"},{"id":"b","text":"5 رؤوس"},{"id":"c","text":"6 رؤوس"},{"id":"d","text":"3 رؤوس"}]'::jsonb, 'c', 'عدد الرؤوس = عدد الأضلاع في كلّ مضلّع، إذن 6 رؤوس. الخطأ الشائع: مضاعفة العدد (6 × 2 = 12).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('330d0d47-321d-545b-8e9c-4e6342bbbe9b', '836f097b-ff8d-5790-a559-f91a64bc4129', 'مسلكٌ طوله 7 خطوات وآخر بين نفس النقطتين طوله 5 خطوات. ماذا نستنتج؟', '[{"id":"a","text":"المسلك الثاني أقصر (أقلّ خطوات)"},{"id":"b","text":"هما متكافئان"},{"id":"c","text":"المسلك الثاني أطول"},{"id":"d","text":"لهما نفس الطول"}]'::jsonb, 'a', 'نقارن عدد الخطوات: 5 أقلّ من 7، فالمسلك الثاني أقصر. لا يكونان متكافئين إلّا إذا تساوى عدد خطواتهما. الخطأ الشائع: اعتبار كلّ مسلكين بين نفس النقطتين متكافئين.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4ab0f5c0-7980-55ec-a656-e4bf2914b93e', 'aae294cb-a57b-52df-a9df-f9f19e7580c2', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('31ed67af-8a43-5ad4-b31a-5a4b14241a84', '4ab0f5c0-7980-55ec-a656-e4bf2914b93e', 'النقطة التي ينطلق منها ضلعا الزاوية تُسمّى:', '[{"id":"a","text":"رأس الزاوية"},{"id":"b","text":"الضلع"},{"id":"c","text":"الفتحة"},{"id":"d","text":"المستقيم"}]'::jsonb, 'a', 'ضلعا الزاوية (نصفا المستقيم) ينطلقان من نقطةٍ واحدة تُسمّى رأس الزاوية (le sommet).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9c853dd-15dc-5b21-b161-9590c8b82bb9', '4ab0f5c0-7980-55ec-a656-e4bf2914b93e', 'ما هي الزاوية القائمة؟', '[{"id":"a","text":"زاوية فتحتها واسعة جدًّا"},{"id":"b","text":"الزاوية التي نراها في ركن الورقة أو الطاولة"},{"id":"c","text":"زاوية ضلعاها قصيران"},{"id":"d","text":"زاوية فتحتها ضيّقة جدًّا"}]'::jsonb, 'b', 'الزاوية القائمة هي زاوية ركن الورقة وركن الطاولة، نتحقّق منها بالكوس ونعلّمها بمربّعٍ صغير.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e1638a39-6058-5af7-a832-02773237cad0', '4ab0f5c0-7980-55ec-a656-e4bf2914b93e', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="20" y2="10" stroke="currentColor" stroke-width="2.5"/><polyline points="20,58 37,58 37,75" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="20" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"حادّة"},{"id":"b","text":"منفرجة"},{"id":"c","text":"ليست زاوية"},{"id":"d","text":"قائمة"}]'::jsonb, 'd', 'المربّع الصغير عند الرأس علامة الزاوية القائمة، وضلعاها متعامدان مثل ركن الورقة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7e521cf8-713f-5117-8359-ef745569265f', '4ab0f5c0-7980-55ec-a656-e4bf2914b93e', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="78" y2="45" stroke="currentColor" stroke-width="2.5"/><circle cx="20" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"منفرجة"},{"id":"b","text":"قائمة"},{"id":"c","text":"حادّة"},{"id":"d","text":"دائرة"}]'::jsonb, 'c', 'فتحة هذه الزاوية أصغر من ركن الورقة (الضلعان قريبان)، إذًا هي زاوية حادّة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ae96db0c-000a-51f5-85cf-1715d50413f2', '4ab0f5c0-7980-55ec-a656-e4bf2914b93e', 'لو مدَدْنا ضلعَي زاويةٍ حتّى صارا أطول، فإنّ الزاوية:', '[{"id":"a","text":"تكبر فتحتها"},{"id":"b","text":"تصغر فتحتها"},{"id":"c","text":"تبقى كما هي"},{"id":"d","text":"تصير قائمة"}]'::jsonb, 'c', 'طول الضلعين لا يغيّر الزاوية؛ المهمّ اتّساع الفتحة فقط، فتبقى الزاوية كما هي.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('80671e5e-3745-5397-8ef0-19ccadbe23ba', 'aae294cb-a57b-52df-a9df-f9f19e7580c2', 'math-3eme', '⭐ تمرين: تعرّف على الزوايا', 1, 50, 10, 'practice', 'admin', 1)
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
  ('bbffce1e-f5d5-5f09-bfa0-d4a4733160d4', '80671e5e-3745-5397-8ef0-19ccadbe23ba', 'الزاوية هي:', '[{"id":"a","text":"الفتحة بين ضلعين ينطلقان من رأسٍ واحد"},{"id":"b","text":"خطٌّ مستقيمٌ طويل"},{"id":"c","text":"نقطةٌ واحدة"},{"id":"d","text":"شكلٌ مدوّر"}]'::jsonb, 'a', 'الزاوية هي الفتحة بين ضلعين (نصفَي مستقيم) ينطلقان من نقطةٍ واحدة هي الرأس.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8733f912-9b50-5f21-8baa-a094fb20bef2', '80671e5e-3745-5397-8ef0-19ccadbe23ba', 'كم ضلعًا للزاوية؟', '[{"id":"a","text":"ضلعٌ واحد"},{"id":"b","text":"ضلعان"},{"id":"c","text":"3 أضلاع"},{"id":"d","text":"4 أضلاع"}]'::jsonb, 'b', 'للزاوية ضلعان (نصفا مستقيم) يلتقيان عند الرأس، وبينهما الفتحة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('73145393-e9e6-5d1d-9142-b14383a10baf', '80671e5e-3745-5397-8ef0-19ccadbe23ba', 'بأيّ أداةٍ نتحقّق من أنّ الزاوية قائمة؟', '[{"id":"a","text":"بالمسطرة"},{"id":"b","text":"بالكوس"},{"id":"c","text":"بالبركار"},{"id":"d","text":"بالممحاة"}]'::jsonb, 'b', 'نطابق ركن الكوس على رأس الزاوية وضلعيها؛ إن انطبق تمامًا فالزاوية قائمة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('be316177-07b6-58bd-a179-0e9a3cbfe770', '80671e5e-3745-5397-8ef0-19ccadbe23ba', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="20" y2="10" stroke="currentColor" stroke-width="2.5"/><polyline points="20,58 37,58 37,75" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="20" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"حادّة"},{"id":"b","text":"منفرجة"},{"id":"c","text":"قائمة"},{"id":"d","text":"ليست زاوية"}]'::jsonb, 'c', 'المربّع الصغير عند الرأس علامة الزاوية القائمة، وضلعاها متعامدان مثل ركن الورقة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a1b53d52-6373-5ad9-ba4c-7c8d44893bea', '80671e5e-3745-5397-8ef0-19ccadbe23ba', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg"><line x1="60" y1="75" x2="112" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="60" y1="75" x2="12" y2="30" stroke="currentColor" stroke-width="2.5"/><circle cx="60" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"قائمة"},{"id":"b","text":"حادّة"},{"id":"c","text":"ليست زاوية"},{"id":"d","text":"منفرجة"}]'::jsonb, 'd', 'فتحة هذه الزاوية أكبر من ركن الورقة (الضلعان منفتحان كثيرًا)، إذًا هي زاوية منفرجة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cd0799e5-a961-5125-acfe-1c6e44333edc', '80671e5e-3745-5397-8ef0-19ccadbe23ba', 'زاويةٌ فتحتها أصغر من ركن الورقة (أصغر من القائمة). ما نوعها؟', '[{"id":"a","text":"منفرجة"},{"id":"b","text":"قائمة"},{"id":"c","text":"حادّة"},{"id":"d","text":"مدوّرة"}]'::jsonb, 'c', 'الزاوية الحادّة فتحتها أصغر من القائمة، أي أصغر من ركن الورقة، والضلعان قريبان من بعضهما.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('84b9d057-4b4f-576b-b93e-ca9b8152fbc5', 'aae294cb-a57b-52df-a9df-f9f19e7580c2', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: معركة الزوايا', 3, 120, 30, 'boss', 'admin', 2)
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
  ('c927f523-6d0e-566d-b964-cba6b18ff425', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg"><line x1="60" y1="75" x2="112" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="60" y1="75" x2="22" y2="22" stroke="currentColor" stroke-width="2.5"/><circle cx="60" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"حادّة"},{"id":"b","text":"قائمة"},{"id":"c","text":"منفرجة"},{"id":"d","text":"ليست زاوية"}]'::jsonb, 'c', 'الفتحة أوسع من ركن الورقة (الضلع الثاني تجاوز العمودي)، فالزاوية منفرجة. الخطأ الشائع: ظنّها قائمة دون مقارنتها بركن الورقة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('baaf2cce-3b12-54f2-9a89-90ce30b800c7', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', 'زاويتان لهما نفس الفتحة، لكنّ ضلعَي الأولى أطول. أيّهما أكبر؟', '[{"id":"a","text":"الأولى (ذات الضلعين الأطول)"},{"id":"b","text":"الثانية (ذات الضلعين الأقصر)"},{"id":"c","text":"لا نستطيع المقارنة"},{"id":"d","text":"هما متساويتان"}]'::jsonb, 'd', 'طول الضلعين لا يغيّر الزاوية؛ ما دامت الفتحة واحدة فالزاويتان متساويتان. الخطأ الشائع: ظنّ أنّ الضلع الأطول يصنع زاويةً أكبر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0af7b08b-13f6-5b86-bd60-fe325f84fbe4', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', 'أيٌّ من هذه الزوايا قائمة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 90 80\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"18\" y1=\"65\" x2=\"82\" y2=\"65\" stroke=\"currentColor\" stroke-width=\"2.5\"/><line x1=\"18\" y1=\"65\" x2=\"70\" y2=\"40\" stroke=\"currentColor\" stroke-width=\"2.5\"/><circle cx=\"18\" cy=\"65\" r=\"3\" fill=\"currentColor\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 90 80\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"18\" y1=\"65\" x2=\"82\" y2=\"65\" stroke=\"currentColor\" stroke-width=\"2.5\"/><line x1=\"18\" y1=\"65\" x2=\"18\" y2=\"8\" stroke=\"currentColor\" stroke-width=\"2.5\"/><polyline points=\"18,50 33,50 33,65\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"/><circle cx=\"18\" cy=\"65\" r=\"3\" fill=\"currentColor\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 90 80\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"48\" y1=\"65\" x2=\"84\" y2=\"65\" stroke=\"currentColor\" stroke-width=\"2.5\"/><line x1=\"48\" y1=\"65\" x2=\"10\" y2=\"24\" stroke=\"currentColor\" stroke-width=\"2.5\"/><circle cx=\"48\" cy=\"65\" r=\"3\" fill=\"currentColor\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 90 80\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"18\" y1=\"65\" x2=\"82\" y2=\"65\" stroke=\"currentColor\" stroke-width=\"2.5\"/><line x1=\"18\" y1=\"65\" x2=\"60\" y2=\"50\" stroke=\"currentColor\" stroke-width=\"2.5\"/><circle cx=\"18\" cy=\"65\" r=\"3\" fill=\"currentColor\"/></svg>"}]'::jsonb, 'b', 'الزاوية القائمة وحدها تحمل المربّع الصغير وضلعاها متعامدان (b). أمّا a وd فحادّتان (فتحة ضيّقة) وc منفرجة (فتحة واسعة).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dd3b8d54-be9f-5ff4-a8e2-54fb3841ed32', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', 'في المربّع، ما نوع كلّ زاويةٍ من زواياه الأربع؟', '[{"id":"a","text":"كلّها قائمة"},{"id":"b","text":"كلّها حادّة"},{"id":"c","text":"كلّها منفرجة"},{"id":"d","text":"بعضها حادّ وبعضها منفرج"}]'::jsonb, 'a', 'أركان المربّع كأركان الورقة، فكلّ زواياه الأربع قائمة. الخطأ الشائع: الخلط بين تساوي الأضلاع ونوع الزاوية.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('de49ba9c-8149-51cc-9bd9-6ef59c809dd5', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', 'زاويةٌ نطابق عليها ركن الكوس فيبقى ضلعٌ من الزاوية خارج الكوس (الفتحة أوسع من الكوس). ما نوعها؟', '[{"id":"a","text":"قائمة"},{"id":"b","text":"حادّة"},{"id":"c","text":"منفرجة"},{"id":"d","text":"لا يمكن تحديدها"}]'::jsonb, 'c', 'إذا تجاوزت فتحة الزاوية ركن الكوس فهي أكبر من القائمة، أي منفرجة. الخطأ الشائع: ظنّ كلّ زاويةٍ نقيسها بالكوس قائمة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('800d4857-ba8a-58e3-b19e-058b8076b893', '84b9d057-4b4f-576b-b93e-ca9b8152fbc5', 'رتّب الزوايا الثلاث من الأصغر فتحةً إلى الأكبر:', '[{"id":"a","text":"حادّة، ثمّ قائمة، ثمّ منفرجة"},{"id":"b","text":"قائمة، ثمّ حادّة، ثمّ منفرجة"},{"id":"c","text":"منفرجة، ثمّ قائمة، ثمّ حادّة"},{"id":"d","text":"حادّة، ثمّ منفرجة، ثمّ قائمة"}]'::jsonb, 'a', 'الحادّة أصغر من القائمة، والمنفرجة أكبر منها، فالترتيب التصاعدي: حادّة ثمّ قائمة ثمّ منفرجة. الخطأ الشائع: وضع القائمة في غير موضعها الوسط.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1521713b-5e31-544b-96d6-7bfb9228f4fd', 'aae294cb-a57b-52df-a9df-f9f19e7580c2', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الزوايا', 2, 75, 15, 'practice', 'admin', 3)
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
  ('ddcda47f-97e7-5dbd-bc29-68b53c10524e', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'أيّ هذه الأشياء فيه زاوية قائمة؟', '[{"id":"a","text":"ركن الكتاب"},{"id":"b","text":"رأس قطعة بيتزا"},{"id":"c","text":"خطٌّ مستقيم"},{"id":"d","text":"دائرة الساعة"}]'::jsonb, 'a', 'ركن الكتاب زاوية قائمة كركن الورقة. رأس البيتزا حادّة، والدائرة لا زوايا لها.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('63ec8df9-4a51-5fdb-955d-79f186fa2c56', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="72" y2="52" stroke="currentColor" stroke-width="2.5"/><circle cx="20" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"قائمة"},{"id":"b","text":"حادّة"},{"id":"c","text":"منفرجة"},{"id":"d","text":"ليست زاوية"}]'::jsonb, 'b', 'فتحة الزاوية أصغر من ركن الورقة (الضلعان قريبان)، إذًا هي زاوية حادّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('85f26dd6-0e21-5d08-b7d5-b240268d95ac', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'أيّ جملةٍ صحيحة عن الزاوية المنفرجة؟', '[{"id":"a","text":"فتحتها أصغر من القائمة"},{"id":"b","text":"فتحتها تساوي القائمة"},{"id":"c","text":"فتحتها أكبر من القائمة"},{"id":"d","text":"ليس لها ضلعان"}]'::jsonb, 'c', 'الزاوية المنفرجة فتحتها أكبر من القائمة، أي الضلعان منفتحان أكثر من ركن الورقة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6ed44d3e-a77a-5def-80df-8e7bdd050687', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg"><line x1="60" y1="75" x2="112" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="60" y1="75" x2="16" y2="40" stroke="currentColor" stroke-width="2.5"/><circle cx="60" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"حادّة"},{"id":"b","text":"قائمة"},{"id":"c","text":"مدوّرة"},{"id":"d","text":"منفرجة"}]'::jsonb, 'd', 'فتحة الزاوية أوسع من ركن الورقة، إذًا هي زاوية منفرجة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9a87e92a-aa70-588b-a33e-d5975fdadd0b', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'للمثلّث ثلاث زوايا عند رؤوسه الثلاثة. عددُ زوايا المثلّث هو:', '[{"id":"a","text":"زاويتان"},{"id":"b","text":"3 زوايا"},{"id":"c","text":"4 زوايا"},{"id":"d","text":"لا زوايا له"}]'::jsonb, 'b', 'للمثلّث 3 رؤوس، وعند كلّ رأسٍ زاوية، فله 3 زوايا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7728ca21-21a8-58f4-97d2-55cc89d28a22', '1521713b-5e31-544b-96d6-7bfb9228f4fd', 'أردنا رسم زاوية حادّة. كيف نضع الضلعين؟', '[{"id":"a","text":"نباعد بينهما كثيرًا"},{"id":"b","text":"نجعلهما متعامدين بالكوس"},{"id":"c","text":"نقرّبهما من بعضهما (فتحة ضيّقة)"},{"id":"d","text":"نجعلهما على استقامةٍ واحدة"}]'::jsonb, 'c', 'الزاوية الحادّة فتحتها أصغر من القائمة، فنقرّب الضلعين ليكوّنا فتحةً ضيّقة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b0352055-ab04-5b5c-a731-4bffde13ed0d', 'aae294cb-a57b-52df-a9df-f9f19e7580c2', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد الزوايا', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('41420d99-6a06-5a02-9f78-17df5b078514', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'كم زاوية قائمة في هذا الشكل؟ <svg viewBox="0 0 100 90" xmlns="http://www.w3.org/2000/svg"><polyline points="20,70 20,20 80,20" fill="none" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="70" x2="80" y2="20" stroke="currentColor" stroke-width="2.5"/><polyline points="20,34 34,34 34,20" fill="none" stroke="currentColor" stroke-width="2"/></svg>', '[{"id":"a","text":"لا توجد زاوية قائمة"},{"id":"b","text":"زاوية قائمة واحدة"},{"id":"c","text":"زاويتان قائمتان"},{"id":"d","text":"3 زوايا قائمة"}]'::jsonb, 'b', 'المثلّث له 3 زوايا، واحدة منها فقط تحمل المربّع الصغير (قائمة)، والأخريان حادّتان. الخطأ الشائع: عدّ كلّ زوايا المثلّث قائمة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e3d7d925-3575-56b7-9808-fd96641b4ac2', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'زاويةٌ ليست حادّة وليست منفرجة. ما نوعها بالضرورة؟', '[{"id":"a","text":"حادّة"},{"id":"b","text":"منفرجة"},{"id":"c","text":"قائمة"},{"id":"d","text":"لا يمكن تحديدها"}]'::jsonb, 'c', 'بالمقارنة مع القائمة هناك ثلاث حالات فقط: أصغر (حادّة)، أكبر (منفرجة)، أو مساوية (قائمة). فإن نُفِيت الحادّة والمنفرجة بقيت القائمة. الخطأ الشائع: نسيان أنّ القائمة حالةٌ ثالثة قائمة بذاتها.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ec50c94b-19c8-5c2d-87cb-48eac2824145', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg"><line x1="58" y1="75" x2="110" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="58" y1="75" x2="50" y2="14" stroke="currentColor" stroke-width="2.5"/><circle cx="58" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"منفرجة"},{"id":"b","text":"حادّة"},{"id":"c","text":"قائمة"},{"id":"d","text":"ليست زاوية"}]'::jsonb, 'a', 'الضلع الثاني مال قليلًا إلى ما بعد العمودي، ففتحة الزاوية تجاوزت القائمة وصارت منفرجة. الخطأ الشائع: ظنّها قائمة لأنّها قريبة من العمودي دون التحقّق بالكوس.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9fed4523-32d1-57f2-8ecd-27fb438ea0ec', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'تدور عقارب الساعة، فتمرّ الزاوية بين العقربين من حادّةٍ إلى قائمةٍ ثمّ تكبر. الزاوية بعد القائمة مباشرةً تصير:', '[{"id":"a","text":"حادّة من جديد"},{"id":"b","text":"قائمة دائمًا"},{"id":"c","text":"تختفي"},{"id":"d","text":"منفرجة"}]'::jsonb, 'd', 'بعد أن تتجاوز الفتحة القائمة تصير أكبر منها، أي منفرجة. الخطأ الشائع: الظنّ أنّ الزاوية تعود حادّة بدل أن تكبر إلى منفرجة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5a4f5ada-a68e-5e17-856f-5cf440af2e36', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'أيّ ترتيبٍ للزوايا صحيحٌ من الأكبر فتحةً إلى الأصغر؟', '[{"id":"a","text":"حادّة، قائمة، منفرجة"},{"id":"b","text":"قائمة، منفرجة، حادّة"},{"id":"c","text":"منفرجة، قائمة، حادّة"},{"id":"d","text":"منفرجة، حادّة، قائمة"}]'::jsonb, 'c', 'المنفرجة أكبر من القائمة، والقائمة أكبر من الحادّة، فالترتيب التنازلي: منفرجة ثمّ قائمة ثمّ حادّة. الخطأ الشائع: الخلط بين الترتيب التصاعدي والتنازلي.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f951e624-a703-5d0d-8d91-b70c9892d733', 'b0352055-ab04-5b5c-a731-4bffde13ed0d', 'أيّ زوجٍ من الأشياء فيه زاويتان من نوعٍ واحد؟', '[{"id":"a","text":"ركن الباب وركن البلاطة"},{"id":"b","text":"ركن النافذة ورأس قطعة بيتزا"},{"id":"c","text":"رأس قلمٍ مبري وركن الكتاب"},{"id":"d","text":"مسند كرسيٍّ مائل وركن الطاولة"}]'::jsonb, 'a', 'ركن الباب وركن البلاطة كلاهما زاوية قائمة، فهما من نوعٍ واحد. أمّا البقية فتخلط بين قائمة وحادّة أو منفرجة. الخطأ الشائع: عدّ كلّ ركنٍ زاويةً قائمة دون النظر إلى نوع الزاوية الأخرى.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ba770364-9225-5efb-87f8-6831189a5814', 'aae294cb-a57b-52df-a9df-f9f19e7580c2', 'math-3eme', '📝 تدريب ⭐⭐⭐ على الزوايا (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('03678a81-1a8a-5d9a-a6c0-eae67d882077', 'ba770364-9225-5efb-87f8-6831189a5814', 'ما اسم الضلعين اللذين يكوّنان الزاوية، والنقطة التي ينطلقان منها؟', '[{"id":"a","text":"الضلعان والرأس"},{"id":"b","text":"الفتحة والمحيط"},{"id":"c","text":"السطر والعمود"},{"id":"d","text":"الطول والعرض"}]'::jsonb, 'a', 'الزاوية لها ضلعان (نصفا مستقيم) ينطلقان من نقطةٍ واحدة تُسمّى الرأس.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6822dc87-edf3-57bf-9df1-f04f38e4897a', 'ba770364-9225-5efb-87f8-6831189a5814', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="76" y2="48" stroke="currentColor" stroke-width="2.5"/><circle cx="20" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"قائمة"},{"id":"b","text":"منفرجة"},{"id":"c","text":"حادّة"},{"id":"d","text":"ليست زاوية"}]'::jsonb, 'c', 'فتحة الزاوية أصغر من ركن الورقة (الضلعان قريبان)، إذًا هي زاوية حادّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('30b63efc-4809-5199-850a-106a28096777', 'ba770364-9225-5efb-87f8-6831189a5814', 'صديقك رسم زاويةً بضلعين قصيرين. لو رسم زاويةً بنفس الفتحة لكن بضلعين طويلين، تكون الزاوية الجديدة:', '[{"id":"a","text":"أكبر"},{"id":"b","text":"أصغر"},{"id":"c","text":"قائمة"},{"id":"d","text":"بنفس الاتّساع"}]'::jsonb, 'd', 'طول الضلعين لا يغيّر الزاوية؛ ما دامت الفتحة واحدة فالزاوية بنفس الاتّساع. الخطأ الشائع: ربط حجم الزاوية بطول الضلعين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2c6ea3dc-ec1a-5a23-804b-8e32bfb3fb01', 'ba770364-9225-5efb-87f8-6831189a5814', 'ما نوع هذه الزاوية؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="75" x2="95" y2="75" stroke="currentColor" stroke-width="2.5"/><line x1="20" y1="75" x2="20" y2="10" stroke="currentColor" stroke-width="2.5"/><polyline points="20,58 37,58 37,75" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="20" cy="75" r="3" fill="currentColor"/></svg>', '[{"id":"a","text":"حادّة"},{"id":"b","text":"قائمة"},{"id":"c","text":"منفرجة"},{"id":"d","text":"ليست زاوية"}]'::jsonb, 'b', 'المربّع الصغير عند الرأس علامة الزاوية القائمة، وضلعاها متعامدان مثل ركن الورقة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e011e29a-aa1b-54a5-954c-609f0b2fab8c', 'ba770364-9225-5efb-87f8-6831189a5814', 'طابقنا ركن الكوس على زاوية فدخل ضلعا الزاوية داخل الكوس ولم يبلغا حافّتيه (الفتحة أضيق من الكوس). ما نوعها؟', '[{"id":"a","text":"قائمة"},{"id":"b","text":"منفرجة"},{"id":"c","text":"حادّة"},{"id":"d","text":"لا يمكن تحديدها"}]'::jsonb, 'c', 'إذا بقيت فتحة الزاوية داخل ركن الكوس (أضيق منه) فهي أصغر من القائمة، أي حادّة. الخطأ الشائع: ظنّ كلّ زاويةٍ نضع عليها الكوس قائمة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('81987930-01f8-5184-9119-096916d0138a', 'ba770364-9225-5efb-87f8-6831189a5814', 'أيّ مجموعةٍ كلّ زواياها من النوع نفسه؟', '[{"id":"a","text":"أركان المربّع وأركان المستطيل"},{"id":"b","text":"رأس مثلّثٍ ورأس بيتزا وركن باب"},{"id":"c","text":"مسند كرسيٍّ مائل وركن نافذة"},{"id":"d","text":"رأس قلمٍ مبري وركن طاولة"}]'::jsonb, 'a', 'كلّ أركان المربّع والمستطيل زوايا قائمة، فهي مجموعة من نوعٍ واحد. أمّا البقية فتخلط أنواعًا مختلفة. الخطأ الشائع: عدّ أيّ ركنٍ زاويةً قائمة دون مقارنته بركن الورقة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fd6c52fc-9d01-5de4-b32c-8897708e53e3', '8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5725c1c4-83bc-5c25-95a6-52eb3c903886', 'fd6c52fc-9d01-5de4-b32c-8897708e53e3', 'كم زاوية قائمة للمستطيل؟', '[{"id":"a","text":"زاويتان قائمتان"},{"id":"b","text":"3 زوايا قائمة"},{"id":"c","text":"لا زوايا قائمة له"},{"id":"d","text":"4 زوايا قائمة"}]'::jsonb, 'd', 'المستطيل له 4 أضلاع و4 زوايا قائمة، والأضلاع المتقابلة فيه متساوية (طول وعرض).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a2ac0c48-89a2-5dab-8953-4c1a8d9b976d', 'fd6c52fc-9d01-5de4-b32c-8897708e53e3', 'ما الذي يميّز المربّع عن المستطيل؟', '[{"id":"a","text":"كلّ أضلاع المربّع متساوية"},{"id":"b","text":"للمربّع 3 أضلاع فقط"},{"id":"c","text":"المربّع مدوّر لا زوايا له"},{"id":"d","text":"للمربّع زاويتان قائمتان فقط"}]'::jsonb, 'a', 'كلاهما له 4 أضلاع و4 زوايا قائمة، لكنّ المربّع كلّ أضلاعه متساوية، أمّا المستطيل فله طولان وعرضان.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('de75f3ee-c8d4-5afd-9e90-6a8d9f247f1e', 'fd6c52fc-9d01-5de4-b32c-8897708e53e3', 'ماذا نعني بمحيط شكلٍ ما؟', '[{"id":"a","text":"عدد زواياه القائمة"},{"id":"b","text":"مجموع أطوال أضلاعه"},{"id":"c","text":"عدد أضلاعه"},{"id":"d","text":"طول أطول ضلعٍ فيه"}]'::jsonb, 'b', 'محيط الشكل هو مجموع أطوال أضلاعه، أي طول الخطّ الذي يحيط به، ويُقاس بـ cm أو m.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed5208fa-35cd-503b-8ac0-b157453d6d36', 'fd6c52fc-9d01-5de4-b32c-8897708e53e3', 'مربّعٌ ضلعه 6 cm. ما محيطه؟
<svg viewBox="0 0 130 108">
<title>مربّع ضلعه 6 cm</title>
<rect x="30" y="24" width="70" height="70" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="65" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6 cm</text>
</svg>', '[{"id":"a","text":"12 cm"},{"id":"b","text":"18 cm"},{"id":"c","text":"24 cm"},{"id":"d","text":"36 cm"}]'::jsonb, 'c', 'محيط المربّع = الضلع × 4 = 6 × 4 = 24 cm. (أو 6 + 6 + 6 + 6 = 24 cm.)', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c8334c02-e7ef-5ddc-99cb-2ab62eec00cc', 'fd6c52fc-9d01-5de4-b32c-8897708e53e3', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"كلّ مستطيلٍ هو مربّع"},{"id":"b","text":"المربّع حالة خاصّة من المستطيل"},{"id":"c","text":"المستطيل له ضلعان فقط"},{"id":"d","text":"المربّع لا زوايا قائمة له"}]'::jsonb, 'b', 'المربّع حالة خاصّة من المستطيل: له 4 زوايا قائمة وزيادةً كلّ أضلاعه متساوية، فكلّ مربّعٍ مستطيل وليس العكس.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0a2a8702-3e93-58fb-b458-2566b9c0fe4a', '8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', 'math-3eme', '⭐ تمرين: أوّل أسوار المملكة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4cc37990-780f-5128-9aaa-41c545ec436c', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', 'كم ضلعًا للمربّع؟', '[{"id":"a","text":"3 أضلاع"},{"id":"b","text":"4 أضلاع"},{"id":"c","text":"5 أضلاع"},{"id":"d","text":"ضلعان"}]'::jsonb, 'b', 'المربّع شكلٌ له 4 أضلاع متساوية و4 زوايا قائمة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2e3a7aaf-a640-5ba8-9d86-8e4d14a2d991', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', 'في المستطيل، أيّ الأضلاع متساوية؟', '[{"id":"a","text":"الأضلاع المتقابلة فقط"},{"id":"b","text":"كلّ الأضلاع الأربعة"},{"id":"c","text":"لا شيء منها متساوٍ"},{"id":"d","text":"ثلاثة أضلاع فقط"}]'::jsonb, 'a', 'في المستطيل الأضلاع المتقابلة فقط متساوية: ضلعان طويلان (الطول) وضلعان قصيران (العرض).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b4a5d4d0-f362-5966-85d8-106a2b902430', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', 'مربّعٌ ضلعه 3 cm. ما محيطه؟
<svg viewBox="0 0 130 108">
<title>مربّع ضلعه 3 cm</title>
<rect x="30" y="24" width="70" height="70" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="65" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3 cm</text>
</svg>', '[{"id":"a","text":"9 cm"},{"id":"b","text":"6 cm"},{"id":"c","text":"12 cm"},{"id":"d","text":"7 cm"}]'::jsonb, 'c', 'محيط المربّع = الضلع × 4 = 3 × 4 = 12 cm. (أو 3 + 3 + 3 + 3 = 12 cm.)', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2d6acb95-8a5b-5c4b-af1d-fa9edfc4f3f9', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', 'ما العدد الذي نضرب فيه ضلع المربّع لنحصل على محيطه؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'c', 'للمربّع 4 أضلاع متساوية، فمحيطه = الضلع × 4.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3c405c14-10d5-5bdc-981b-0082627fb2e0', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', 'ما محيط هذا المستطيل؟<svg viewBox="0 0 150 70" xmlns="http://www.w3.org/2000/svg"><rect x="22" y="22" width="108" height="36" fill="none" stroke="currentColor" stroke-width="2"/><text x="76" y="16" font-size="11" fill="currentColor" text-anchor="middle">6 cm</text><text x="11" y="44" font-size="11" fill="currentColor" text-anchor="middle">2 cm</text></svg>', '[{"id":"a","text":"8 cm"},{"id":"b","text":"10 cm"},{"id":"c","text":"12 cm"},{"id":"d","text":"16 cm"}]'::jsonb, 'd', 'الطول 6 cm والعرض 2 cm. المحيط = (6 + 2) × 2 = 8 × 2 = 16 cm.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f516cb77-19e2-56e9-8fb6-8475f6b2d822', '0a2a8702-3e93-58fb-b458-2566b9c0fe4a', 'مستطيلٌ طوله 5 cm وعرضه 3 cm. ما محيطه؟
<svg viewBox="0 0 186 110">
<title>مستطيل طوله 5 cm وعرضه 3 cm</title>
<rect x="56" y="24" width="108" height="62" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="110" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5 cm</text><text x="28" y="60" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3 cm</text>
</svg>', '[{"id":"a","text":"8 cm"},{"id":"b","text":"13 cm"},{"id":"c","text":"15 cm"},{"id":"d","text":"16 cm"}]'::jsonb, 'd', 'المحيط = (الطول + العرض) × 2 = (5 + 3) × 2 = 8 × 2 = 16 cm.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('06b6c8c0-3f73-58b2-a9da-b180bc217e9d', '8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: حصار المحيط', 3, 120, 30, 'boss', 'admin', 2)
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
  ('0f6ddc2c-b398-5904-9de6-5a01c1919967', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', 'شكلٌ له 4 زوايا قائمة، ضلعان طويلان متساويان وضلعان قصيران متساويان. ما هو؟', '[{"id":"a","text":"المربّع"},{"id":"b","text":"المستطيل"},{"id":"c","text":"المثلّث"},{"id":"d","text":"الدائرة"}]'::jsonb, 'b', 'المستطيل له 4 زوايا قائمة وأضلاعه المتقابلة فقط متساوية (طولان وعرضان). أمّا المربّع فكلّ أضلاعه متساوية.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4c93393c-7a0e-5ac4-8918-7a20ca32623b', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', 'مستطيلٌ طوله 7 cm وعرضه 3 cm. ما محيطه؟
<svg viewBox="0 0 190 98">
<title>مستطيل طوله 7 cm وعرضه 3 cm</title>
<rect x="56" y="24" width="112" height="50" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="112" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7 cm</text><text x="28" y="54" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3 cm</text>
</svg>', '[{"id":"a","text":"10 cm"},{"id":"b","text":"21 cm"},{"id":"c","text":"20 cm"},{"id":"d","text":"14 cm"}]'::jsonb, 'c', 'المحيط = (7 + 3) × 2 = 10 × 2 = 20 cm. الخطأ الشائع: التوقّف عند 7 + 3 = 10 ونسيان الضرب في 2، لأنّ للمستطيل ضلعين بكلّ قياس.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c380c356-c390-56b4-baa8-174dd3b3de7a', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', 'ما محيط هذا المربّع؟<svg viewBox="0 0 110 100" xmlns="http://www.w3.org/2000/svg"><rect x="25" y="22" width="58" height="58" fill="none" stroke="currentColor" stroke-width="2"/><text x="54" y="16" font-size="11" fill="currentColor" text-anchor="middle">7 cm</text></svg>', '[{"id":"a","text":"14 cm"},{"id":"b","text":"21 cm"},{"id":"c","text":"28 cm"},{"id":"d","text":"49 cm"}]'::jsonb, 'c', 'الشكل مربّع، فكلّ أضلاعه 7 cm. المحيط = 7 × 4 = 28 cm. الخطأ الشائع: ضرب 7 × 7 = 49 (ذلك ليس المحيط).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5f46accb-6bfb-515b-a7a8-788ce0403247', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', 'مربّعٌ محيطه 20 cm. ما طول ضلعه؟', '[{"id":"a","text":"4 cm"},{"id":"b","text":"10 cm"},{"id":"c","text":"16 cm"},{"id":"d","text":"5 cm"}]'::jsonb, 'd', 'محيط المربّع = الضلع × 4، فالضلع = 20 ÷ 4 = 5 cm. تحقّق: 5 × 4 = 20 cm. ✓ الخطأ الشائع: طرح 4 بدل القسمة عليها.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('16e399ea-63cd-5e12-b2c4-ee38aecde75f', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', 'حديقةٌ مستطيلةٌ طولها 9 m وعرضها 6 m، نريد سياجًا حولها. كم مترًا من السياج نحتاج؟
<svg viewBox="0 0 198 130">
<title>حديقة مستطيلة طولها 9 m وعرضها 6 m</title>
<rect x="56" y="24" width="120" height="82" fill="#dcfce7" stroke="#0f172a" stroke-width="2.5"/><text x="116" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">9 m</text><text x="28" y="70" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6 m</text>
</svg>', '[{"id":"a","text":"15 m"},{"id":"b","text":"30 m"},{"id":"c","text":"24 m"},{"id":"d","text":"54 m"}]'::jsonb, 'b', 'طول السياج = محيط المستطيل = (9 + 6) × 2 = 15 × 2 = 30 m. الخطأ الشائع: ضرب 9 × 6 = 54 (ذلك ليس المحيط).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c55604cb-be60-5678-9231-11c46370c256', '06b6c8c0-3f73-58b2-a9da-b180bc217e9d', 'مستطيلٌ طوله 8 cm، ومحيطه 24 cm. ما عرضه؟', '[{"id":"a","text":"4 cm"},{"id":"b","text":"16 cm"},{"id":"c","text":"12 cm"},{"id":"d","text":"3 cm"}]'::jsonb, 'a', 'المحيط = (الطول + العرض) × 2. فمجموع الطول والعرض = 24 ÷ 2 = 12، والعرض = 12 − 8 = 4 cm. تحقّق: (8 + 4) × 2 = 24 cm. ✓', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('87aff9ac-39e1-5396-88b0-a0ec6392ecdb', '8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): قياس الأسوار', 2, 75, 15, 'practice', 'admin', 3)
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
  ('8f0dcb17-26a7-5b5c-af2c-c0176bc657d6', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', 'كم زاوية قائمة للمربّع؟', '[{"id":"a","text":"زاويتان"},{"id":"b","text":"3 زوايا"},{"id":"c","text":"4 زوايا"},{"id":"d","text":"لا زوايا قائمة له"}]'::jsonb, 'c', 'المربّع له 4 أضلاع متساوية و4 زوايا قائمة، مثل المستطيل تمامًا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fe65563d-dad8-51c7-9e57-9dafde6f137d', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', 'مربّعٌ ضلعه 8 cm. ما محيطه؟
<svg viewBox="0 0 130 108">
<title>مربّع ضلعه 8 cm</title>
<rect x="30" y="24" width="70" height="70" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="65" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8 cm</text>
</svg>', '[{"id":"a","text":"16 cm"},{"id":"b","text":"24 cm"},{"id":"c","text":"32 cm"},{"id":"d","text":"64 cm"}]'::jsonb, 'c', 'محيط المربّع = الضلع × 4 = 8 × 4 = 32 cm.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('af4fd70b-8a4b-57be-be0a-4191d0d6c101', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', 'مستطيلٌ طوله 10 cm وعرضه 4 cm. ما محيطه؟
<svg viewBox="0 0 198 98">
<title>مستطيل طوله 10 cm وعرضه 4 cm</title>
<rect x="56" y="24" width="120" height="50" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="116" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">10 cm</text><text x="28" y="54" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4 cm</text>
</svg>', '[{"id":"a","text":"14 cm"},{"id":"b","text":"28 cm"},{"id":"c","text":"40 cm"},{"id":"d","text":"24 cm"}]'::jsonb, 'b', 'المحيط = (الطول + العرض) × 2 = (10 + 4) × 2 = 14 × 2 = 28 cm.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b86a261f-6175-5855-be3b-7df4894c91b4', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', 'مثلّثٌ أطوال أضلاعه 5 cm و6 cm و7 cm. ما محيطه؟
<svg viewBox="0 0 168 116">
<title>مثلّث أطوال أضلاعه 5 و6 و7 cm</title>
<polygon points="30,92 138,92 104,20" fill="none" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="84" y="108" text-anchor="middle" fill="#0f172a" font-size="14">6 cm</text><text x="137" y="60" text-anchor="middle" fill="#0f172a" font-size="14">5 cm</text><text x="57" y="56" text-anchor="middle" fill="#0f172a" font-size="14">7 cm</text></g>
</svg>', '[{"id":"a","text":"18 cm"},{"id":"b","text":"17 cm"},{"id":"c","text":"210 cm"},{"id":"d","text":"11 cm"}]'::jsonb, 'a', 'محيط المضلّع = مجموع أطوال أضلاعه = 5 + 6 + 7 = 18 cm.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ea5c793a-0604-55b9-8e80-692c6268f959', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', 'ما محيط هذا المستطيل؟<svg viewBox="0 0 150 100" xmlns="http://www.w3.org/2000/svg"><rect x="20" y="24" width="110" height="52" fill="none" stroke="currentColor" stroke-width="2"/><text x="75" y="17" font-size="11" fill="currentColor" text-anchor="middle">9 cm</text><text x="10" y="54" font-size="11" fill="currentColor" text-anchor="middle">5 cm</text></svg>', '[{"id":"a","text":"14 cm"},{"id":"b","text":"28 cm"},{"id":"c","text":"45 cm"},{"id":"d","text":"18 cm"}]'::jsonb, 'b', 'الطول 9 cm والعرض 5 cm. المحيط = (9 + 5) × 2 = 14 × 2 = 28 cm.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f7f480f2-7daa-5c50-86ab-dae13857b393', '87aff9ac-39e1-5396-88b0-a0ec6392ecdb', 'أيّ عبارةٍ صحيحة عن المربّع والمستطيل؟', '[{"id":"a","text":"كلّ مستطيلٍ هو مربّع"},{"id":"b","text":"المربّع لا زوايا قائمة له"},{"id":"c","text":"للمستطيل 3 أضلاع"},{"id":"d","text":"كلّ مربّعٍ هو مستطيل"}]'::jsonb, 'd', 'المربّع حالة خاصّة من المستطيل (له 4 زوايا قائمة وزيادةً كلّ أضلاعه متساوية)، فكلّ مربّعٍ مستطيل، وليس العكس.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', '8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز المحيط', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('21179f3c-7271-5bd9-80b8-f1ee0e255c6c', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'مربّعٌ ومستطيلٌ لهما نفس المحيط. ضلع المربّع 6 cm، وعرض المستطيل 4 cm. ما طول المستطيل؟', '[{"id":"a","text":"8 cm"},{"id":"b","text":"6 cm"},{"id":"c","text":"10 cm"},{"id":"d","text":"12 cm"}]'::jsonb, 'a', 'محيط المربّع = 6 × 4 = 24 cm، فهو محيط المستطيل أيضًا. مجموع الطول والعرض = 24 ÷ 2 = 12، والطول = 12 − 4 = 8 cm. تحقّق: (8 + 4) × 2 = 24 cm. ✓', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cee54ab7-fa8e-5bac-b97f-59f83f5080fc', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'ما محيط هذا الشكل (كلّ القياسات بالـ cm)؟<svg viewBox="0 0 130 120" xmlns="http://www.w3.org/2000/svg"><polygon points="20,20 80,20 80,50 110,50 110,100 20,100" fill="none" stroke="currentColor" stroke-width="2"/><text x="50" y="14" font-size="10" fill="currentColor" text-anchor="middle">6</text><text x="88" y="38" font-size="10" fill="currentColor" text-anchor="middle">3</text><text x="95" y="44" font-size="10" fill="currentColor" text-anchor="middle">3</text><text x="117" y="78" font-size="10" fill="currentColor" text-anchor="middle">5</text><text x="65" y="113" font-size="10" fill="currentColor" text-anchor="middle">9</text><text x="12" y="63" font-size="10" fill="currentColor" text-anchor="middle">8</text></svg>', '[{"id":"a","text":"31 cm"},{"id":"b","text":"34 cm"},{"id":"c","text":"28 cm"},{"id":"d","text":"40 cm"}]'::jsonb, 'b', 'نجمع أطوال الأضلاع الستّة كلّها: 6 + 3 + 3 + 5 + 9 + 8 = 34 cm. الخطأ الشائع: نسيان أحد الأضلاع عند الدوران حول الشكل.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('541879ca-de8d-51d8-844a-4955a026b58f', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'مستطيلٌ طوله ضعف عرضه. إذا كان العرض 5 cm، فما محيطه؟', '[{"id":"a","text":"15 cm"},{"id":"b","text":"20 cm"},{"id":"c","text":"50 cm"},{"id":"d","text":"30 cm"}]'::jsonb, 'd', 'الطول = ضعف العرض = 5 × 2 = 10 cm. المحيط = (10 + 5) × 2 = 15 × 2 = 30 cm. الخطأ الشائع: نسيان حساب الطول واستعمال 5 مرّتين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c0d573d0-3a3e-5a60-836c-79c1e5ff7354', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'سلكٌ طوله 36 cm نطويه ليكوّن مربّعًا كاملًا. ما طول ضلع المربّع؟', '[{"id":"a","text":"6 cm"},{"id":"b","text":"4 cm"},{"id":"c","text":"9 cm"},{"id":"d","text":"12 cm"}]'::jsonb, 'c', 'طول السلك هو محيط المربّع = 36 cm. الضلع = 36 ÷ 4 = 9 cm. تحقّق: 9 × 4 = 36 cm. ✓ الخطأ الشائع: قسمة 36 على 2 بدل 4.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bcf65aa0-7ca6-5b70-bf73-532ee5e95930', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'مربّعٌ ضلعه 7 cm ومستطيلٌ طوله 9 cm وعرضه 5 cm. أيّهما محيطه أكبر؟', '[{"id":"a","text":"المربّع، لأنّ محيطه 28 cm"},{"id":"b","text":"المستطيل، لأنّ محيطه 30 cm"},{"id":"c","text":"لهما نفس المحيط: 28 cm"},{"id":"d","text":"المربّع، لأنّ محيطه 49 cm"}]'::jsonb, 'c', 'محيط المربّع = 7 × 4 = 28 cm، ومحيط المستطيل = (9 + 5) × 2 = 28 cm. فهما متساويان. الخطأ الشائع: حساب 7 × 7 = 49 للمربّع بدل الضرب في 4.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('764c5a2a-1ed7-5d7a-9542-f6fbd2cb43ef', '4c411e2a-c4ea-5aeb-8fba-8dfa26506f58', 'مستطيلٌ محيطه 26 cm وطوله 8 cm. ما عرضه؟', '[{"id":"a","text":"5 cm"},{"id":"b","text":"18 cm"},{"id":"c","text":"13 cm"},{"id":"d","text":"10 cm"}]'::jsonb, 'a', 'مجموع الطول والعرض = 26 ÷ 2 = 13، والعرض = 13 − 8 = 5 cm. تحقّق: (8 + 5) × 2 = 26 cm. ✓ الخطأ الشائع: طرح 8 من 26 مباشرةً دون قسمة المحيط على 2 أوّلًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('cfb47759-fb46-529a-8bff-460fbc2e2c7f', '8163bced-f9f6-56fe-b6db-6f89d1fdf3c4', 'math-3eme', '📝 تدريب ⭐⭐⭐: حملة الأسوار (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('fdd19731-4ada-52c7-99ff-eda54957342e', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', 'شكلٌ كلّ أضلاعه الأربعة متساوية وكلّ زواياه قائمة. ما هو؟', '[{"id":"a","text":"المثلّث"},{"id":"b","text":"المستطيل"},{"id":"c","text":"الدائرة"},{"id":"d","text":"المربّع"}]'::jsonb, 'd', 'المربّع هو الشكل ذو 4 أضلاع متساوية و4 زوايا قائمة. المستطيل له 4 زوايا قائمة لكن أضلاعه ليست كلّها متساوية.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1c954ae7-239c-51b7-96e0-b787e7d1002b', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', 'مربّعٌ ضلعه 4 cm. ما محيطه؟
<svg viewBox="0 0 130 108">
<title>مربّع ضلعه 4 cm</title>
<rect x="30" y="24" width="70" height="70" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="65" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4 cm</text>
</svg>', '[{"id":"a","text":"8 cm"},{"id":"b","text":"12 cm"},{"id":"c","text":"16 cm"},{"id":"d","text":"20 cm"}]'::jsonb, 'c', 'محيط المربّع = الضلع × 4 = 4 × 4 = 16 cm.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2bb0f9d2-cfa2-5b80-8a58-fe8b5aafa684', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', 'ما محيط هذا المستطيل؟<svg viewBox="0 0 140 95" xmlns="http://www.w3.org/2000/svg"><rect x="20" y="24" width="100" height="44" fill="none" stroke="currentColor" stroke-width="2"/><text x="70" y="17" font-size="11" fill="currentColor" text-anchor="middle">7 cm</text><text x="10" y="50" font-size="11" fill="currentColor" text-anchor="middle">3 cm</text></svg>', '[{"id":"a","text":"10 cm"},{"id":"b","text":"14 cm"},{"id":"c","text":"21 cm"},{"id":"d","text":"20 cm"}]'::jsonb, 'd', 'الطول 7 cm والعرض 3 cm. المحيط = (7 + 3) × 2 = 10 × 2 = 20 cm. الخطأ الشائع: التوقّف عند 7 + 3 = 10 دون الضرب في 2.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1661dfd2-b764-5846-ba5d-62b2e2b45879', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', 'مربّعٌ محيطه 32 cm. ما طول ضلعه؟', '[{"id":"a","text":"6 cm"},{"id":"b","text":"8 cm"},{"id":"c","text":"16 cm"},{"id":"d","text":"28 cm"}]'::jsonb, 'b', 'الضلع = المحيط ÷ 4 = 32 ÷ 4 = 8 cm. تحقّق: 8 × 4 = 32 cm. ✓ الخطأ الشائع: طرح 4 من 32 بدل القسمة عليها.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('75160c06-c81f-5a9b-9086-ea9be45bede9', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', 'نريد إطارًا حول صورةٍ مستطيلةٍ طولها 12 cm وعرضها 8 cm. كم سنتيمترًا من الإطار نحتاج؟
<svg viewBox="0 0 196 128">
<title>مستطيل طوله 12 cm وعرضه 8 cm</title>
<rect x="56" y="24" width="118" height="80" fill="none" stroke="#0f172a" stroke-width="2.5"/><text x="115" y="16" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">12 cm</text><text x="28" y="69" text-anchor="middle" fill="#0f172a" font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8 cm</text>
</svg>', '[{"id":"a","text":"20 cm"},{"id":"b","text":"32 cm"},{"id":"c","text":"40 cm"},{"id":"d","text":"96 cm"}]'::jsonb, 'c', 'طول الإطار = محيط المستطيل = (12 + 8) × 2 = 20 × 2 = 40 cm. الخطأ الشائع: ضرب 12 × 8 = 96 (ذلك ليس المحيط).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1bf022b6-69f0-57c1-b723-39bb0e63cd9d', 'cfb47759-fb46-529a-8bff-460fbc2e2c7f', 'مستطيلٌ طوله 11 cm، ومحيطه 30 cm. ما عرضه؟', '[{"id":"a","text":"4 cm"},{"id":"b","text":"19 cm"},{"id":"c","text":"8 cm"},{"id":"d","text":"15 cm"}]'::jsonb, 'a', 'مجموع الطول والعرض = 30 ÷ 2 = 15، والعرض = 15 − 11 = 4 cm. تحقّق: (11 + 4) × 2 = 30 cm. ✓', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('58b3f1f7-ec46-5f6a-9eb5-65e031cef733', '3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7', 'math-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('4919d76f-8775-5846-bfb2-e18eb19e1350', '58b3f1f7-ec46-5f6a-9eb5-65e031cef733', 'كم مليمًا في الدينار الواحد؟', '[{"id":"a","text":"100 مليم"},{"id":"b","text":"1000 مليم"},{"id":"c","text":"500 مليم"},{"id":"d","text":"10 مليم"}]'::jsonb, 'b', 'العلاقة الأساسيّة بين الوحدتين: 1 د = 1000 مليم. إذن الدينار الواحد فيه 1000 مليم.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('784f25f6-77ac-5c5c-ad48-b1af2b3e29f9', '58b3f1f7-ec46-5f6a-9eb5-65e031cef733', 'كم صنتيمترًا في المتر الواحد؟', '[{"id":"a","text":"10 cm"},{"id":"b","text":"50 cm"},{"id":"c","text":"100 cm"},{"id":"d","text":"1000 cm"}]'::jsonb, 'c', 'العلاقة العشريّة للأطوال: 1 m = 100 cm. إذن المتر الواحد يساوي 100 صنتيمتر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('114952e7-b343-5a80-b1fb-aca92f22a620', '58b3f1f7-ec46-5f6a-9eb5-65e031cef733', 'بأيّ وحدةٍ نقيس كميّة الماء في قارورة؟', '[{"id":"a","text":"اللتر (L)"},{"id":"b","text":"المتر (m)"},{"id":"c","text":"الصنتيمتر (cm)"},{"id":"d","text":"الدقيقة"}]'::jsonb, 'a', 'نقيس كميّة السوائل (ماء، حليب، عصير) باللتر (L). أمّا المتر والصنتيمتر فللأطوال.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('73fa6c8d-6653-574e-b751-54223357b451', '58b3f1f7-ec46-5f6a-9eb5-65e031cef733', 'كم يومًا في الأسبوع الواحد؟', '[{"id":"a","text":"5 أيّام"},{"id":"b","text":"12 يومًا"},{"id":"c","text":"30 يومًا"},{"id":"d","text":"7 أيّام"}]'::jsonb, 'd', 'الأسبوع فيه 7 أيّام: السبت والأحد والاثنين والثلاثاء والأربعاء والخميس والجمعة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('54870836-fb3e-5716-92d7-f55845da13f4', '58b3f1f7-ec46-5f6a-9eb5-65e031cef733', 'كم دقيقةً في الساعة الواحدة؟', '[{"id":"a","text":"30 دقيقة"},{"id":"b","text":"60 دقيقة"},{"id":"c","text":"100 دقيقة"},{"id":"d","text":"24 دقيقة"}]'::jsonb, 'b', 'العلاقة في الزمن: 1 ساعة = 60 دقيقة. إذن الساعة الواحدة فيها 60 دقيقة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('830c7471-068a-5dc3-9874-069e6271db4c', '3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7', 'math-3eme', '⭐ تمرين: وحدات القيس', 1, 50, 10, 'practice', 'admin', 1)
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
  ('828ff023-ae29-5fed-a65b-461f61bac72d', '830c7471-068a-5dc3-9874-069e6271db4c', '1 د = … مليم؟', '[{"id":"a","text":"1000"},{"id":"b","text":"100"},{"id":"c","text":"10"},{"id":"d","text":"500"}]'::jsonb, 'a', 'العلاقة بين الوحدتين: 1 د = 1000 مليم. إذن الجواب 1000 مليم.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0197e4c5-a81f-5a1d-ad7a-61223e7b3bcf', '830c7471-068a-5dc3-9874-069e6271db4c', 'كم دسيمترًا في المتر الواحد؟', '[{"id":"a","text":"100 dm"},{"id":"b","text":"10 dm"},{"id":"c","text":"1000 dm"},{"id":"d","text":"1 dm"}]'::jsonb, 'b', 'العلاقة العشريّة: 1 m = 10 dm. إذن المتر الواحد فيه 10 دسيمترات.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0dbbae78-c528-52c4-88e0-e81b6e051b5c', '830c7471-068a-5dc3-9874-069e6271db4c', 'نصفُ اللتر + نصفُ اللتر = ؟', '[{"id":"a","text":"2 L"},{"id":"b","text":"نصف L"},{"id":"c","text":"1 L"},{"id":"d","text":"4 L"}]'::jsonb, 'c', 'نصفان يكوّنان وحدةً كاملة: نصف L + نصف L = 1 L كامل.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5a62a01d-4f99-5b6e-aba1-c55c1f333e0e', '830c7471-068a-5dc3-9874-069e6271db4c', 'كم ساعةً في اليوم الواحد؟', '[{"id":"a","text":"12 ساعة"},{"id":"b","text":"48 ساعة"},{"id":"c","text":"60 ساعة"},{"id":"d","text":"24 ساعة"}]'::jsonb, 'd', 'اليوم الواحد فيه 24 ساعة: نهارٌ وليل. إذن الجواب 24 ساعة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9d5da433-0987-51c5-af5b-2e7fd67a2af9', '830c7471-068a-5dc3-9874-069e6271db4c', 'كم صنتيمترًا يساوي 3 m؟', '[{"id":"a","text":"300 cm"},{"id":"b","text":"30 cm"},{"id":"c","text":"103 cm"},{"id":"d","text":"3000 cm"}]'::jsonb, 'a', 'من m إلى cm نضرب في 100: 3 × 100 = 300. إذن 3 m = 300 cm.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7921d110-1d3b-588e-8812-aa74bed039c8', '830c7471-068a-5dc3-9874-069e6271db4c', 'ثمنُ قلمٍ 2 د ودفتر 3 د. كم ندفع في المجموع؟', '[{"id":"a","text":"6 د"},{"id":"b","text":"23 د"},{"id":"c","text":"5 د"},{"id":"d","text":"1 د"}]'::jsonb, 'c', 'نجمع الثمنين: 2 د + 3 د = 5 د. إذن ندفع 5 د في المجموع.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('98d6c352-f53c-535a-8ef2-2705aadd17be', '3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7', 'math-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد القيس', 3, 120, 30, 'boss', 'admin', 2)
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
  ('20632e95-094c-583a-8778-7a710895a119', '98d6c352-f53c-535a-8ef2-2705aadd17be', 'كم مترًا يساوي 400 cm؟', '[{"id":"a","text":"40 m"},{"id":"b","text":"400 m"},{"id":"c","text":"4 m"},{"id":"d","text":"4000 m"}]'::jsonb, 'c', 'من cm إلى m نقسم على 100: 400 ÷ 100 = 4. إذن 400 cm = 4 m.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f6a49196-377c-5cc4-9ae4-b9861354f4d1', '98d6c352-f53c-535a-8ef2-2705aadd17be', 'كم مليمترًا يساوي 7 cm؟', '[{"id":"a","text":"70 mm"},{"id":"b","text":"7 mm"},{"id":"c","text":"700 mm"},{"id":"d","text":"17 mm"}]'::jsonb, 'a', 'من cm إلى mm نضرب في 10: 7 × 10 = 70. إذن 7 cm = 70 mm.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b15b31d2-b678-5ae3-a364-a9ae9c801a66', '98d6c352-f53c-535a-8ef2-2705aadd17be', 'اشترى البطل بـ 6 د ودفع ورقةً ماليّةً من 5 د وقطعةً من 2 د. كم الباقي؟', '[{"id":"a","text":"2 د"},{"id":"b","text":"1 د"},{"id":"c","text":"7 د"},{"id":"d","text":"13 د"}]'::jsonb, 'b', 'المدفوع = 5 د + 2 د = 7 د، والباقي = المدفوع − الثمن = 7 د − 6 د = 1 د. ✓ الخطأ الشائع: جمعُ المدفوع مع الثمن بدل طرحهما.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('80aa719f-155d-553b-96fb-eb349e657e5a', '98d6c352-f53c-535a-8ef2-2705aadd17be', 'طولٌ يساوي 250 cm. كم يساوي بالأمتار والصنتيمترات؟', '[{"id":"a","text":"2 m و 5 cm"},{"id":"b","text":"25 m"},{"id":"c","text":"5 m و 2 cm"},{"id":"d","text":"2 m و 50 cm"}]'::jsonb, 'd', '250 cm = 200 cm + 50 cm، و 200 cm = 2 m. إذن 250 cm = 2 m و 50 cm. ✓ الخطأ الشائع: قراءة 250 على أنّها 2 m و 5 cm.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7ae63ab8-0097-5245-8fe4-9fa5a445188f', '98d6c352-f53c-535a-8ef2-2705aadd17be', 'أيُّ طولٍ أكبر: 1 m أم 80 cm؟', '[{"id":"a","text":"1 m"},{"id":"b","text":"80 cm"},{"id":"c","text":"متساويان"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'نوحّد الوحدة: 1 m = 100 cm. وبما أنّ 100 أكبرُ من 80، فإنّ 1 m أكبر. ✓ الخطأ الشائع: مقارنة 1 و 80 مباشرةً دون توحيد الوحدة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d5233fa8-e35b-5d6d-80e9-d3335224d5b9', '98d6c352-f53c-535a-8ef2-2705aadd17be', 'بدأ الدرسُ الساعة 8 وانتهى الساعة 9. كم دقيقةً دام؟', '[{"id":"a","text":"100 دقيقة"},{"id":"b","text":"60 دقيقة"},{"id":"c","text":"30 دقيقة"},{"id":"d","text":"90 دقيقة"}]'::jsonb, 'b', 'من الساعة 8 إلى الساعة 9 ساعةٌ كاملة، والساعة = 60 دقيقة. ✓ الخطأ الشائع: اعتبار الساعة 100 دقيقة بدل 60.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3ccc9a99-300c-586e-a12f-1f425c5987c4', '3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7', 'math-3eme', '⭐⭐ تمرين مراجعة (نمط امتحان): القيس', 2, 75, 15, 'practice', 'admin', 3)
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
  ('7015fa6c-7120-5e3b-a531-4afd4cf2b5fb', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'كم مترًا يساوي 2 km؟', '[{"id":"a","text":"200 m"},{"id":"b","text":"2000 m"},{"id":"c","text":"20 m"},{"id":"d","text":"2 m"}]'::jsonb, 'b', 'من km إلى m نضرب في 1000: 2 × 1000 = 2000. إذن 2 km = 2000 m.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3aeebf9c-d91a-553f-a0ac-1c68c96b8687', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'ثمنُ لعبةٍ 8 د. كيف نؤدّيه بقطعةٍ وورقة؟', '[{"id":"a","text":"5 د + 5 د"},{"id":"b","text":"2 د + 2 د"},{"id":"c","text":"5 د + 2 د"},{"id":"d","text":"5 د + 2 د + 1 د"}]'::jsonb, 'd', 'نختار قطعًا مجموعُها 8 د: 5 د + 2 د + 1 د = 8 د. أمّا 5 + 2 = 7 د فأقلّ من الثمن.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('592f8c5b-68fc-573f-9b03-3810978e702a', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'قارورةٌ سعتُها 2 L وأخرى 3 L. ما مجموع سعتيهما؟', '[{"id":"a","text":"5 L"},{"id":"b","text":"23 L"},{"id":"c","text":"1 L"},{"id":"d","text":"6 L"}]'::jsonb, 'a', 'نجمع السعتين بنفس الوحدة: 2 L + 3 L = 5 L. إذن المجموع 5 L.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0ca6435c-fae3-5dcf-8e59-91378087c627', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'كم شهرًا في السنة الواحدة؟', '[{"id":"a","text":"7 أشهر"},{"id":"b","text":"24 شهرًا"},{"id":"c","text":"12 شهرًا"},{"id":"d","text":"30 شهرًا"}]'::jsonb, 'c', 'السنة الواحدة فيها 12 شهرًا، وتساوي تقريبًا 365 يومًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('25b81e93-3d9e-573a-9206-6c652acbd14e', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'كم صنتيمترًا يساوي 5 dm؟', '[{"id":"a","text":"5 cm"},{"id":"b","text":"50 cm"},{"id":"c","text":"500 cm"},{"id":"d","text":"15 cm"}]'::jsonb, 'b', 'من dm إلى cm نضرب في 10: 5 × 10 = 50. إذن 5 dm = 50 cm.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('62f05e5c-1cb1-51de-ae53-9afe816cb184', '3ccc9a99-300c-586e-a12f-1f425c5987c4', 'كم دقيقةً في نصف ساعة؟', '[{"id":"a","text":"60 دقيقة"},{"id":"b","text":"15 دقيقة"},{"id":"c","text":"50 دقيقة"},{"id":"d","text":"30 دقيقة"}]'::jsonb, 'd', 'الساعة = 60 دقيقة، ونصفُها 60 ÷ 2 = 30. إذن نصف الساعة = 30 دقيقة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c71ce92c-76e1-513f-bc93-24b5e1a80b90', '3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7', 'math-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز القيس', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('145a2f96-6795-521f-a804-285aba4a0c74', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'شريطٌ طوله 1 m، قُطِع منه 35 cm. كم بقي منه بالصنتيمترات؟', '[{"id":"a","text":"65 cm"},{"id":"b","text":"35 cm"},{"id":"c","text":"135 cm"},{"id":"d","text":"95 cm"}]'::jsonb, 'a', 'نحوّل أوّلًا: 1 m = 100 cm، ثمّ 100 − 35 = 65. إذن البقيّة 65 cm. ✓ الخطأ الشائع: الطرح 100 − 35 دون تحويل المتر إلى 100 cm.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6611d761-c47d-5fc7-9bec-7d3086590fd0', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'دفع البطل ورقةً ماليّةً من 5 د ثمنًا لشيءٍ بـ 3 د. كم يَرُدّ له البائع؟', '[{"id":"a","text":"8 د"},{"id":"b","text":"3 د"},{"id":"c","text":"2 د"},{"id":"d","text":"1 د"}]'::jsonb, 'c', 'الباقي = المدفوع − الثمن = 5 د − 3 د = 2 د. ✓ الخطأ الشائع: جمعُ 5 و 3 فيعطي 8 بدل الطرح.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('78885cac-683f-572e-8984-947676cac276', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'ساعةٌ وربعٌ كم دقيقة؟ (الساعة = 60 دقيقة، الربع = 15 دقيقة)', '[{"id":"a","text":"60 دقيقة"},{"id":"b","text":"75 دقيقة"},{"id":"c","text":"90 دقيقة"},{"id":"d","text":"65 دقيقة"}]'::jsonb, 'b', 'ساعة = 60 دقيقة وربع = 15 دقيقة، نجمع: 60 + 15 = 75. إذن ساعة وربع = 75 دقيقة. ✓ الخطأ الشائع: إضافة 5 بدل 15 فيعطي 65.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('00bc1703-2fd8-5527-8e8e-64d975fae20e', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'طولٌ يساوي 305 cm. كم يساوي بالأمتار والصنتيمترات؟', '[{"id":"a","text":"3 m و 50 cm"},{"id":"b","text":"35 m"},{"id":"c","text":"5 m و 3 cm"},{"id":"d","text":"3 m و 5 cm"}]'::jsonb, 'd', '305 cm = 300 cm + 5 cm، و 300 cm = 3 m. إذن 305 cm = 3 m و 5 cm. ✓ الخطأ الشائع: قراءة 305 على أنّها 3 m و 50 cm.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('51c3bf74-9c58-595c-a9f3-ea4c82a0015f', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'كم لترًا في 4 قارورات سعةُ كلٍّ منها 2 L، مضافًا إليها قارورةٌ 1 L؟', '[{"id":"a","text":"7 L"},{"id":"b","text":"8 L"},{"id":"c","text":"9 L"},{"id":"d","text":"6 L"}]'::jsonb, 'c', 'سعةُ الأربع قارورات: 4 × 2 = 8 L، ثمّ نضيف 1 L: 8 + 1 = 9 L. ✓ الخطأ الشائع: نسيان القارورة الإضافيّة فيعطي 8 L.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d2241f84-c7bd-5dcf-9dc6-33d6acd6e042', 'c71ce92c-76e1-513f-bc93-24b5e1a80b90', 'إذا كان اليوم الخميس، فما اليوم بعد ثلاثة أيّام؟', '[{"id":"a","text":"الأحد"},{"id":"b","text":"السبت"},{"id":"c","text":"الاثنين"},{"id":"d","text":"الجمعة"}]'::jsonb, 'a', 'بعد الخميس: الجمعة (1)، السبت (2)، الأحد (3). إذن بعد ثلاثة أيّام من الخميس هو الأحد. ✓ الخطأ الشائع: البدء بعدّ الخميس نفسه يومًا أوّل.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fc14c4c7-2440-5982-b72d-b5d6445f68f2', '3a1dbbdf-f13c-5b16-85e7-241c17b3e9e7', 'math-3eme', '📝 تدريب ⭐⭐⭐: إتقان القيس (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('8a8dd284-ea33-5d23-abe4-def5eace567e', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2', 'كم مليمترًا يساوي 1 m؟', '[{"id":"a","text":"10 mm"},{"id":"b","text":"100 mm"},{"id":"c","text":"1 mm"},{"id":"d","text":"1000 mm"}]'::jsonb, 'd', 'العلاقة العشريّة للأطوال: 1 m = 1000 mm. إذن المتر الواحد فيه 1000 مليمتر.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f2e14a4f-0bcd-5ca4-a8a6-cca4451604dc', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2', 'نصفُ الدينار يساوي بالمليم…', '[{"id":"a","text":"100 مليم"},{"id":"b","text":"250 مليم"},{"id":"c","text":"500 مليم"},{"id":"d","text":"1000 مليم"}]'::jsonb, 'c', 'الدينار 1000 مليم، ونصفُه 1000 ÷ 2 = 500 مليم. إذن نصف الدينار = 500 مليم.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('40d79e59-5a3a-5d53-8001-58749ffaab62', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2', 'اشترى البطل خبزًا بـ 1 د وحليبًا بـ 2 د، ودفع ورقةً ماليّةً من 5 د. كم الباقي؟', '[{"id":"a","text":"2 د"},{"id":"b","text":"3 د"},{"id":"c","text":"8 د"},{"id":"d","text":"1 د"}]'::jsonb, 'a', 'الثمن الكلّيّ = 1 د + 2 د = 3 د، والباقي = 5 د − 3 د = 2 د. ✓ الخطأ الشائع: حساب الباقي من ثمنٍ واحدٍ فقط بدل جمع الثمنين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aa69924e-9039-5252-a3f7-5c93db6e18b3', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2', 'كم صنتيمترًا يساوي 6 m؟', '[{"id":"a","text":"60 cm"},{"id":"b","text":"600 cm"},{"id":"c","text":"106 cm"},{"id":"d","text":"6000 cm"}]'::jsonb, 'b', 'من m إلى cm نضرب في 100: 6 × 100 = 600. إذن 6 m = 600 cm. ✓ الخطأ الشائع: الضرب في 10 بدل 100 فيعطي 60 cm.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9ade0c9c-16e4-54ea-9888-0d192a16981b', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2', 'أيُّهما أكبر: 1 km أم 800 m؟', '[{"id":"a","text":"800 m"},{"id":"b","text":"متساويان"},{"id":"c","text":"1 km"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'c', 'نوحّد الوحدة: 1 km = 1000 m. وبما أنّ 1000 أكبرُ من 800، فإنّ 1 km أكبر. ✓ الخطأ الشائع: مقارنة 1 و 800 دون توحيد الوحدة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c0b0cdf9-4b75-5bd9-8f2f-7a804a1ab589', 'fc14c4c7-2440-5982-b72d-b5d6445f68f2', 'ما اليوم الذي يأتي بعد الأحد؟', '[{"id":"a","text":"الاثنين"},{"id":"b","text":"السبت"},{"id":"c","text":"الثلاثاء"},{"id":"d","text":"الجمعة"}]'::jsonb, 'a', 'ترتيب الأيّام: السبت ثمّ الأحد ثمّ الاثنين. إذن بعد الأحد يأتي الاثنين. ✓ الخطأ الشائع: الخلط بين ما قبل وما بعد في ترتيب الأيّام.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'math-3eme'
      AND e.source = 'admin';
  END IF;
END $$;

