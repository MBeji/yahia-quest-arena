-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: francais-c2 (Français — Maîtrise (C2 · DALF C2))
-- Regenerate with: npm run content:build
-- Source of truth: content/francais-c2/
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
  ('francais-c2', 'Français — Maîtrise (C2 · DALF C2)', 'Vise la maîtrise complète : les temps littéraires, les figures de style, la syntaxe expressive, les nuances lexicales et les paronymes savants, les expressions rares, proverbes et locutions latines, la rhétorique et l''argumentation experte, le vocabulaire savant, et la lecture critique de textes exigeants. Niveau maîtrise (CECRL C2), aligné sur le DALF C2.', 'Agilité', 'subject-french', 'Languages', 6, 'fr', false, 'francais', NULL)
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
      AND e.subject_id = 'francais-c2'
      AND e.source = 'admin'
      AND q.id NOT IN ('9ad5d427-2cfd-5d15-9b01-dece8d749eb3', '958487c0-7807-5faf-bf3a-efd74b7c7555', 'edb43c66-96ed-5fbe-9e3d-5acb030510e2', 'e6e4e86f-079d-506e-a59f-2f97e4a6ee4c', '8ee22325-73a6-571c-bfda-5620d62ed52c', 'cb18bb59-3ee1-5345-abf0-b6bcdbe8469f', 'c8d57e7e-da62-5683-bbab-cd2a096223d9', '644957e1-6d81-5217-8ee8-8ffe8d28a294', '34b406d0-988c-5d96-a8bc-cef7855ff121', '8ac1ffcd-4247-55aa-9fd6-b199090ea1ed', 'c4983077-3ad1-5ad5-ac19-033557bdfa57', '008c7253-83a6-5f32-aaac-b1324bb6c231', '11950394-b49a-5810-ba69-933ffd1ae26c', '0dcda9c6-acef-55bc-8f40-49cd9557f90f', '1a861e56-19b1-51b4-ad7a-b07fed62770d', 'd7b8d14c-04a8-5a7f-9cb0-606ceef3b21e', 'd3f639cb-8c0f-5d66-8570-ab53be114ff9', '25b97cf3-f0b7-5acf-9d2c-b328918cfede', 'c809f06d-52a0-5925-bfab-32fd5753d7df', '8b8e09ce-43aa-5cc5-8597-94b1ec1906fb', '62243554-dead-51dc-8ae8-41dd8ec4d24a', 'e1dc208b-0da3-5c29-a2c4-bb8e642b35b5', '8d4e9299-29fa-559c-9711-7d5b6439a01c', '5ff00957-2bee-5f75-8379-16ba0076ea8a', '836a62ce-4262-5c27-b076-a3e902854cfb', 'c190a717-9be0-5104-a06d-7cf92f9c600f', '1cc5cb28-ce88-5341-9a8b-8fb6e79898f0', '2d141660-3bc8-5b94-bbe8-d15429c380ce', '127ef9df-0050-57d2-9ef0-98dfae0e56d8', 'f52d0bee-0de9-51c7-9b65-1a5ee86dc20a', '77e1697a-404e-5467-9f67-b8b3e62e5a95', '3d362fc5-5419-56d2-974d-7e24e9e065d4', '1a20483d-e886-501b-8715-36de5c054109', '824e15f2-a726-5ffd-84fb-35f8798a84c1', 'c5c17e74-643d-51ca-a81b-223fcb3babef', 'db7fb78e-480f-58ff-93ae-96f981e7c399', '83cfc43a-e209-500d-88e3-4cd0979d5cca', '10763c44-4482-5136-864a-f08358413eb9', '1ba22937-e5da-5bb3-8250-0be295963cd6', 'f8a9481a-137d-5249-8560-7c8d06b0b260', '4524f9db-add6-5bc2-8eb8-71da27609706', 'df76765c-86ff-5da0-b561-26abdc1f1a88', '77b84be1-dc47-581d-9a76-1d98ceebd300', '20874920-7a8e-524b-ae8a-3bf9fdc9311d', '593c4d19-8e6b-5d99-a530-bfd2b9f3e9a1', '803172c8-6287-51ae-bb10-51477358c74d', '58c98953-f436-5246-b8c2-52ab63851944', '5c4f4d40-6aac-5276-816a-1e1070f8acde', '45224a33-fe35-5a35-aa6a-a2ac5d0b479c', '42d95cf9-78ae-5636-9f32-7381a4777385', '3f2d5759-2406-540c-877c-ed1ff9d7fe6e', '7d356a32-2673-540d-9a1f-313fab4f68c2', 'ba580f7f-6e26-570d-b79c-01a52c527389', '89771009-c252-56e4-9699-0dbbba222a8d', '478c5505-352a-5f18-8e2d-94832a67861d', 'ecfbb9bc-2365-5650-9348-3bfec7d38786', '5004cce6-7b1b-593e-b6b1-42282dc53884', 'c0bdffaa-d41c-5216-ad54-fec93b7232f2', '8f40a2fc-73d0-52d3-8ce6-c857dcc9ae18', 'b83d408c-6806-569e-8a76-72bfcc5f4cb1', '12e98ee8-afea-5c38-b58c-b548c79150f3', '9c356f3e-ccf4-59c4-8837-faa1268a7097', '1e650f33-c17c-54ef-a0cf-ba4f0265c4ab', '0cb333c1-b502-58a0-9dba-2beeebef1e36', '617e4aae-131a-5e2b-8be1-0b8362e5cd69', 'de75026f-ec0b-54b2-b6b7-3c927bb211eb', '929b89d6-a95a-50ca-bada-75fb1fe74210', '442592a5-983b-5f2a-a3a0-e08e0340b350', 'c7300db7-4cc4-5f7c-96e4-da0b7bc4d772', '7065646e-2013-5e0a-b928-d7b7c2aafa27', '47fe294d-a619-575c-9c91-f121689be4b6', 'de2a155d-9e02-5992-93ff-8cfe1c80776b', '24f8675e-f3b7-5016-8031-eed21790ccd0', 'cbfb8b56-b27c-568b-93f8-1fa7edae329b', '888229b1-9599-59b7-a484-587f89be53e8', '329f92fc-dcea-55cd-b761-543ff706523b', '5cd41b20-9006-593b-80da-5cbb1c1770f4', 'cadd5d8c-8681-5c37-86e7-9a7be52cec78', 'b5ecdd3a-ae5e-53ac-a557-89fbed820280', '9e5c5451-1045-5248-b7a3-7f082a3b8cde', '360e12e5-c6be-5a76-bf96-e60cee3c818c', 'f7051e44-dce6-558f-a60b-764927b7f06f', '9c359747-90f2-5af5-9c24-921b987ab251', 'e3a4c092-89d2-522d-9d49-4e879f6aad5b', '12255bbc-3155-5df5-a2f7-2aa42cc7fb01', '4a99ea70-942a-5b17-9a42-26f615c32411', '1b0a8c7a-8e12-5f4c-9348-b37db8e5b6df', '82ef4c6f-1159-5929-8d06-5176481ec699', '6a2219b3-7e66-5cda-b42b-2379421d6875', 'f860a3b7-f282-5085-801c-3b2ee2cc811a', '65d9bc3b-7e5d-5669-9621-7c15da8aac4f', '6f5c134d-0211-5434-8d74-25e87ca972d5', '60f966dd-ab59-56df-9965-5d5af5de3421', '88bc9dcf-04bf-56aa-a96d-7bd5a26a2a92', 'be32dd42-90a9-5211-8e90-61a1c4315532', 'de1bdb75-5766-5386-8381-9ba8a97b0178', '6c875e8f-9504-565b-84ea-01b3c94d5d9e', '9c2c0d33-7b94-55d9-b50b-be19e518ee0c', 'd0742072-00a4-5ae0-8977-b719c0eeb000', '3bb04004-63ed-53bc-9595-e2f4902b1dd1', 'b3e21e54-796d-5462-af3f-b6e41089c69c', 'f7f22f9e-d0a7-5050-b8a7-e58ebb1bc13c', 'd31819f8-0098-54db-9a90-7b306b9fe726', 'ef9dc33c-02a1-5054-9742-9a43379dd101', '075a0cf9-ea64-589e-9f32-f6de90fc43f3', '8013655d-4b08-5c46-be1d-072f39c7e963', 'bddd7851-e065-5414-ad0e-d63e789df1b5', 'a7bbc4c4-6f86-5ab5-aca5-3fbf1b7ebb9b', 'f3d87391-6ec0-5a21-83d7-4695d489be34', '69b5a2db-9d81-50de-a7e2-f23c840dcca2', '93fe4958-ebc7-580b-b054-cf664709f4b7', '1eea1018-d4d7-5399-9836-dd159d6e8ab7', '8e07c231-8272-546d-bc79-e8ef656566d0', 'c1a436d0-ad0f-546e-9a0f-6706744d84df', '0c87b478-0647-51a3-92b9-06894478dad4', 'f7992686-1a81-5a12-889c-4424d5c3cb99', 'c2f0931c-aada-57e1-be1a-01a6aaeaa934', '8fffe3af-0d36-594f-9515-4538e478da3c', '53b00386-e110-5421-9d3f-b8a2ca6a7713', 'b614fe5e-5b37-5cd5-9eb9-ec894f3f3d00', 'd1600abb-78b9-5deb-b34c-b9e20c74ab6c', 'd4fc4335-5fad-5e60-b589-4a286fa53b4a', '93b0be8c-c416-5d68-8a6d-79bc8d004def', '3d555195-c123-5058-9317-3c325e822573', 'a930a97c-7a14-53f5-b908-210574818353', '772e480d-8229-558b-af85-ff5423d1f123', '109b85ac-f7af-5121-8c9d-819516b77385', '0db804e0-8c25-5da7-b5d6-283a06cd6f78', '34b60314-5e50-5176-8c30-275a929fe8fb', '0eba131c-84d4-5369-9dbf-17e3b3cff1dc', '3018eeeb-8eb1-5321-9f2d-b465c2f2c834', '5ac58c67-e2af-5bed-a935-0f296b66ad32', '30423337-f8bd-5163-97ad-645050cfeb11', 'a99b0feb-161b-50b6-887e-a1090f102c72', '02bc95fb-fb43-579d-aa7c-b66b198f7ce1', '3658f0eb-8d84-579f-9c62-afa731e0bd44', '515a9f9d-5035-54a7-97c3-6811363751e1', '7d1d5861-935a-5364-9464-e11f8571c149', '2c35d2e8-47f5-55df-be93-7700050cbe49', 'acafb664-8e02-5c2b-940b-e699b4d80a85', '1b7738c5-704b-5377-9faa-faeb9d735906', '1c3873bb-58c4-55a1-895b-23fc68a8ee3a', 'b95e762e-4d17-5abf-9038-fb164d744551', 'fe8d6d9b-7563-5728-9afc-38d69b41a32e', 'fc644467-d6fe-52f0-89ed-1ab4f2837894', 'c67fed1c-f516-5524-b295-30e4177a824f', 'abdfe6cc-6da9-5959-905c-12d4b6da43aa', '00c13caa-7b80-58a6-a166-8415ef81aea4', '01789126-f7cf-5a53-a578-d0ac204a9deb', '5c8288ab-3cb4-5a5d-8b2e-8e70168d14e6', '0ec82fea-cca5-5928-a7ed-88defed51d2a', '5139259a-24ed-5924-8161-3c8781279ed1', '52c268e0-22a7-5a06-b8e4-63e11ee29cf5', '01a30ce0-5d33-5bbc-ae3b-afc6b41e7980', '32871165-1767-5bb5-8108-7b31719dd962', '76ef132a-6f05-50ce-ba60-45a6467817a6', 'fb0b778f-369e-5f8d-b4dc-3e80be8bfd32', '29da85aa-f2bf-5411-91ef-339ac5fb439d', '90a9d83a-af1c-54fe-9e8a-47c33cad50b9', '9961e725-76b5-5511-bfe4-a452b7fd9b8c', '81135b83-6bcd-57c1-87a3-d80c88b56ba1', '3c3a4199-c6ec-5e1c-ad13-3808c7693891', 'dfa11760-467f-54cf-b95c-41da696c0440', 'b6c9c7e7-c64d-5760-ad27-4e5ea5048505', 'f1ea4bec-e5eb-59d7-bc1f-4d99b909fb48', 'ebb511a3-47ae-5973-8a4f-8493499423b3', '717e77f4-80c4-5027-9e5f-213b72d6a89d', '1c073006-f0c2-5a4c-b4ef-1ce95302eae8', 'd736a8ab-e4d0-5245-9a15-b333c6199bd1', 'd18264f7-340d-5ae6-ba66-80c354e5a3db', '11d7916d-e00f-57d0-8192-70a431751bb8', 'e89757ef-213d-5544-a348-9e9e7a3f41b1', 'd0e3d50c-3908-52a3-b366-b4cb98cd2d31', '21fb1302-b318-5dcb-8870-7be36088f371', '5835a413-b205-5bb8-9ca9-d631bd0cadbc', '517085e6-1be2-5d00-83bf-bd1c26b85eb9', 'aa7a8b58-2f70-5928-939f-eeac05d21c88', 'd176cc0e-8c39-5a9f-a41e-8310a637c23f', 'ad84820c-1a8e-5c66-badd-db1b850d87d8', '41a660dc-374e-5370-9bc2-17733238a21b', 'b2a43027-007e-586a-be80-9cf06b62b8a6', '164f5838-63af-51a0-8648-dffc1c08c1a9', '382263c1-c0fd-5fbd-b72f-c113038cf930', '6d5df013-b9bd-5760-b30b-4eb446d3206f', '8ecdd3d3-e349-5c73-8fe7-52c169056eec', '7d059e50-77e7-5ce6-92ea-72d9c3235dbe', 'd6307a65-9b23-58f9-8084-88be053e06d0', '85a0aaf6-fe4a-5dad-8125-c43eda16ec69', '2e4ea578-2878-558d-8e79-9b7e25a16419', 'd2f8a20c-0fc6-5fdf-97fd-5895b656d170', '18dc6456-fda1-5e7c-8b86-e50cc3856bae', 'e2c107fe-74b1-5b7d-b9dc-a9190fedef5c', '4234b99d-8aaa-5b20-961d-952e82a8e724', '93ccd740-b73b-5b7b-afe8-e662df87e015', '7c906072-4b3a-5068-b030-364111b91785', '455b3c1c-bc24-504b-896c-118c872b89f6', '4c63ea07-82af-5014-968c-102c61255bb3', '9eef389b-71db-579d-9cfd-ba9876db1e6b', '9cfc6e68-a1ae-55bd-8667-0c70d8f48eb1', 'a1d0d1c4-503f-5306-b68e-b0333f5eb26f', '09e65d1a-ab8c-557c-8561-20e7576b247d', '3ecbe3c3-423b-5a35-9643-d524685905d0', '5f0624cd-f0f2-53d9-86ba-f6b975c3ceff', '3e0b8c5a-c99e-5899-8213-7c362b5b937e', '76b225c2-3c23-51e3-a1e3-041025cb9fa3', 'c141b206-3bfc-5dcb-b3f7-856fcdaf28d3', 'fc0006a8-c7b9-53fa-b10e-bfcf8d5a2c06', 'f0b2ccba-f958-584d-995f-4bfedb45092f', '926f3f31-e2a8-52ab-9b56-464b306820de', '79903e60-fc33-579f-8961-f1150c689ebd', '4e4b26b4-2c14-55a2-9481-cfa8573f3b51', '64a3f3bc-183f-52cb-83a8-d0f64a605ade', '5ddde91a-7a65-54f0-9c40-840d44ef4012', 'f208d365-5a87-5879-8ec3-12a22fc4c001', 'c5d9ace5-38c3-5c50-8972-aa4723563384', '9ad142d2-6642-5c32-90eb-a8a46373566c', '963c514f-0c79-5d10-9f48-ac0d6afda930', 'e65ff868-1808-5ffe-a694-da3c8df4b98c', '9f0f6ea7-903d-5010-b38e-daa8b15a5baf', 'b40200e2-8535-548c-9efe-112fb11c4abe', '21a797af-e64a-51cf-a62a-caa26879ed31', 'eddc7e53-6a4b-5e51-b04a-10ef0d6f0882', '4e273e0b-1915-561b-8d96-05315157bc5c', 'fe9f7865-f1c4-57b7-bf88-9ac4b0c91b82', 'b69f545b-7580-54ec-875b-56e352752584', 'c308c084-d911-5a0e-962f-9cf34cad9761', '15389306-e80f-5bab-ad0f-e1febe97ac94', 'c195d6f4-9b25-5edd-b54b-acf142a09074', '94fd71e6-c4bc-5b9b-862c-fbe999285354', '1929bdf0-42e8-58d0-aefd-9e29a8217106', 'b095ead5-e4ba-5b12-b440-c28662d818f8', '6088c20b-8287-51dc-8a89-97d383069939', 'a17bd75a-ffe4-5f2f-9009-8865576198d8', '5f1fe0b7-b2ba-5b2e-a47a-7d2dfdf6b8b9', 'e5926e14-e40e-5236-914e-758f24465de0', 'b2209243-9507-51a7-8aae-e8f50cdefe50', '22c6f49e-fe32-5f5b-a188-73b51389d15e', 'a10c6801-924f-5606-b75b-be8814e3ce0e', '2a9889f3-70e9-54a3-9a3c-1f14c7b96aa0', '356ff584-1181-5c94-913f-6b6e181d3b43', '5e07883e-76c3-549d-950e-49c05bebc048', '1e68ae25-7fdd-550e-b4fa-33e66e95dc05', '0c03f2b0-e441-575a-b301-0eed0d945c36', '82db0f5a-d824-51c2-b2ba-531fa733e492', '67cce341-38d2-5712-97b7-081a70abc291', '316d72d9-949f-596e-9138-7294da6b6e1d', '0fdfb291-24d8-5a05-8fe5-d9ab4e31bb19', '4335a63d-67ed-52c3-b3f7-1893549ff3e7', 'e2b5081a-3146-5658-a1d7-b99d128eb7fd', '5e3a4f0c-5435-514c-bb0f-6f38c54ed5f4', '66971b99-efa6-51e5-a894-3504a3abd08f', '859c99fd-9525-56d1-aeaa-229740e4ec99', 'f4f3be4a-ab15-5245-a8f3-a8daaa812701', '3e65c55b-f482-5ecc-a0ad-527358025641', 'a1b92a9a-bc13-5077-80a9-5d2f20627382', '15d853e7-62e0-5784-8353-a3f87f457132', '4937b28f-ef86-542c-bbbc-dcdecb51a01d', '0c81b4f8-3ba2-52af-987f-05fa561d1819', '8182ece7-9fdc-55a1-941d-c993c6204ceb', '58ab57c0-a7da-509e-9b2f-f0283cfec24e', 'ad7a9c0d-34a7-5def-83c2-884d064e362e', '45bf3ef9-0a65-58ac-acdf-90eb0ae2a599', 'dd770b04-728e-50e9-b66f-75f951e5a58d', 'b3f7f7b8-05ec-5910-bb58-5686c9f43f31', '2032a4ff-e3f5-58b3-9ba6-6f532ded0424', '0f730ad8-d204-571c-820d-484404c091ba', '5d7094eb-bda1-5300-84dd-0c53b3276be2', '5eb62d19-0ec2-5922-afff-1e223f87d8e0', '16f0a8e6-1dda-5ea2-ade9-937197745d90', '0fe1c796-5f5b-5446-99eb-335fc4dda6a0', 'fcd9f7da-38ef-53ce-b9d0-a49ccabdd12b', '2b8fbb40-ac91-552c-81b1-767059d83dcf', '4bd3061b-2fd1-5090-8ea5-6b5aea7bf938', '87e1a99e-971d-5eb0-bb3d-e0de8dc0271a', 'df607cdd-1fe5-5bdd-b7de-7261852cbcbf', '6435faba-f6f0-5a65-be00-cdf276b3b439', '9416d013-3388-5d4d-92b4-1a4615d48435', 'a7d1d7a2-4d97-5746-b11c-6ac0967a71a3', '40910e38-27b2-5518-911d-cca9b8b2fdbc', '888cab9c-e934-5412-a064-d5ce3835889e');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'francais-c2' AND source = 'admin' AND id NOT IN ('08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', '11783ea1-5320-5bf4-9eb3-48160306961c', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', '490f3002-d2a8-5368-9b4e-179b25be49ec', '206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'f7246a96-b203-54b9-9546-937a930227d2', '6beac16c-10c7-56de-a3a2-68191bf1866c', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'f23263f1-2e56-5e7c-9be3-fbb21c4f9743', '015ffc1d-c93c-57eb-a408-520e54175968', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'd76c5218-b672-5aba-9795-04b7012385e1', '61f4c108-53d0-57c0-95ba-48447d2a887c', '4024a104-7d04-580b-b53a-b4579f0cb081', '415a9ac0-824f-5ed5-a391-08f46ad199d2', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'd0036976-170b-5f9b-87a1-85d00ec11c80', 'e501d769-52f9-518f-8a35-8c7d0845f19c', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', '5438093c-fab8-52e4-8743-47f5cd3229a6', 'd1976b79-1176-542a-b4bb-1aedef385be8', '14ef6507-e3a2-5599-b083-3689c71135c3', 'dba9a1b2-605a-5068-9a70-206a2585d88c', '1c16b823-5995-5687-94c6-32ac14891500', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', '96949afd-bfcf-595f-9954-5cad364bbcae', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', 'd773b1d7-0da3-5339-a823-ba164e20abea', '8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', '8d30dbad-7608-58d0-809d-db40c929f27f', '23556ada-9445-569a-9b0e-63d070c1da7a', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'cbd02736-a8df-55ad-9928-38d0d54a2dda', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'f8ea8334-2d57-51ec-9d09-7190a625868e', '82802b8e-8942-5f04-ac8a-967f88a18e8f', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752');
DELETE FROM public.questions WHERE exercise_id IN ('08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', '11783ea1-5320-5bf4-9eb3-48160306961c', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', '490f3002-d2a8-5368-9b4e-179b25be49ec', '206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'f7246a96-b203-54b9-9546-937a930227d2', '6beac16c-10c7-56de-a3a2-68191bf1866c', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'f23263f1-2e56-5e7c-9be3-fbb21c4f9743', '015ffc1d-c93c-57eb-a408-520e54175968', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'd76c5218-b672-5aba-9795-04b7012385e1', '61f4c108-53d0-57c0-95ba-48447d2a887c', '4024a104-7d04-580b-b53a-b4579f0cb081', '415a9ac0-824f-5ed5-a391-08f46ad199d2', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'd0036976-170b-5f9b-87a1-85d00ec11c80', 'e501d769-52f9-518f-8a35-8c7d0845f19c', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', '5438093c-fab8-52e4-8743-47f5cd3229a6', 'd1976b79-1176-542a-b4bb-1aedef385be8', '14ef6507-e3a2-5599-b083-3689c71135c3', 'dba9a1b2-605a-5068-9a70-206a2585d88c', '1c16b823-5995-5687-94c6-32ac14891500', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', '96949afd-bfcf-595f-9954-5cad364bbcae', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', 'd773b1d7-0da3-5339-a823-ba164e20abea', '8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', '8d30dbad-7608-58d0-809d-db40c929f27f', '23556ada-9445-569a-9b0e-63d070c1da7a', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'cbd02736-a8df-55ad-9928-38d0d54a2dda', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'f8ea8334-2d57-51ec-9d09-7190a625868e', '82802b8e-8942-5f04-ac8a-967f88a18e8f', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752') AND id NOT IN ('9ad5d427-2cfd-5d15-9b01-dece8d749eb3', '958487c0-7807-5faf-bf3a-efd74b7c7555', 'edb43c66-96ed-5fbe-9e3d-5acb030510e2', 'e6e4e86f-079d-506e-a59f-2f97e4a6ee4c', '8ee22325-73a6-571c-bfda-5620d62ed52c', 'cb18bb59-3ee1-5345-abf0-b6bcdbe8469f', 'c8d57e7e-da62-5683-bbab-cd2a096223d9', '644957e1-6d81-5217-8ee8-8ffe8d28a294', '34b406d0-988c-5d96-a8bc-cef7855ff121', '8ac1ffcd-4247-55aa-9fd6-b199090ea1ed', 'c4983077-3ad1-5ad5-ac19-033557bdfa57', '008c7253-83a6-5f32-aaac-b1324bb6c231', '11950394-b49a-5810-ba69-933ffd1ae26c', '0dcda9c6-acef-55bc-8f40-49cd9557f90f', '1a861e56-19b1-51b4-ad7a-b07fed62770d', 'd7b8d14c-04a8-5a7f-9cb0-606ceef3b21e', 'd3f639cb-8c0f-5d66-8570-ab53be114ff9', '25b97cf3-f0b7-5acf-9d2c-b328918cfede', 'c809f06d-52a0-5925-bfab-32fd5753d7df', '8b8e09ce-43aa-5cc5-8597-94b1ec1906fb', '62243554-dead-51dc-8ae8-41dd8ec4d24a', 'e1dc208b-0da3-5c29-a2c4-bb8e642b35b5', '8d4e9299-29fa-559c-9711-7d5b6439a01c', '5ff00957-2bee-5f75-8379-16ba0076ea8a', '836a62ce-4262-5c27-b076-a3e902854cfb', 'c190a717-9be0-5104-a06d-7cf92f9c600f', '1cc5cb28-ce88-5341-9a8b-8fb6e79898f0', '2d141660-3bc8-5b94-bbe8-d15429c380ce', '127ef9df-0050-57d2-9ef0-98dfae0e56d8', 'f52d0bee-0de9-51c7-9b65-1a5ee86dc20a', '77e1697a-404e-5467-9f67-b8b3e62e5a95', '3d362fc5-5419-56d2-974d-7e24e9e065d4', '1a20483d-e886-501b-8715-36de5c054109', '824e15f2-a726-5ffd-84fb-35f8798a84c1', 'c5c17e74-643d-51ca-a81b-223fcb3babef', 'db7fb78e-480f-58ff-93ae-96f981e7c399', '83cfc43a-e209-500d-88e3-4cd0979d5cca', '10763c44-4482-5136-864a-f08358413eb9', '1ba22937-e5da-5bb3-8250-0be295963cd6', 'f8a9481a-137d-5249-8560-7c8d06b0b260', '4524f9db-add6-5bc2-8eb8-71da27609706', 'df76765c-86ff-5da0-b561-26abdc1f1a88', '77b84be1-dc47-581d-9a76-1d98ceebd300', '20874920-7a8e-524b-ae8a-3bf9fdc9311d', '593c4d19-8e6b-5d99-a530-bfd2b9f3e9a1', '803172c8-6287-51ae-bb10-51477358c74d', '58c98953-f436-5246-b8c2-52ab63851944', '5c4f4d40-6aac-5276-816a-1e1070f8acde', '45224a33-fe35-5a35-aa6a-a2ac5d0b479c', '42d95cf9-78ae-5636-9f32-7381a4777385', '3f2d5759-2406-540c-877c-ed1ff9d7fe6e', '7d356a32-2673-540d-9a1f-313fab4f68c2', 'ba580f7f-6e26-570d-b79c-01a52c527389', '89771009-c252-56e4-9699-0dbbba222a8d', '478c5505-352a-5f18-8e2d-94832a67861d', 'ecfbb9bc-2365-5650-9348-3bfec7d38786', '5004cce6-7b1b-593e-b6b1-42282dc53884', 'c0bdffaa-d41c-5216-ad54-fec93b7232f2', '8f40a2fc-73d0-52d3-8ce6-c857dcc9ae18', 'b83d408c-6806-569e-8a76-72bfcc5f4cb1', '12e98ee8-afea-5c38-b58c-b548c79150f3', '9c356f3e-ccf4-59c4-8837-faa1268a7097', '1e650f33-c17c-54ef-a0cf-ba4f0265c4ab', '0cb333c1-b502-58a0-9dba-2beeebef1e36', '617e4aae-131a-5e2b-8be1-0b8362e5cd69', 'de75026f-ec0b-54b2-b6b7-3c927bb211eb', '929b89d6-a95a-50ca-bada-75fb1fe74210', '442592a5-983b-5f2a-a3a0-e08e0340b350', 'c7300db7-4cc4-5f7c-96e4-da0b7bc4d772', '7065646e-2013-5e0a-b928-d7b7c2aafa27', '47fe294d-a619-575c-9c91-f121689be4b6', 'de2a155d-9e02-5992-93ff-8cfe1c80776b', '24f8675e-f3b7-5016-8031-eed21790ccd0', 'cbfb8b56-b27c-568b-93f8-1fa7edae329b', '888229b1-9599-59b7-a484-587f89be53e8', '329f92fc-dcea-55cd-b761-543ff706523b', '5cd41b20-9006-593b-80da-5cbb1c1770f4', 'cadd5d8c-8681-5c37-86e7-9a7be52cec78', 'b5ecdd3a-ae5e-53ac-a557-89fbed820280', '9e5c5451-1045-5248-b7a3-7f082a3b8cde', '360e12e5-c6be-5a76-bf96-e60cee3c818c', 'f7051e44-dce6-558f-a60b-764927b7f06f', '9c359747-90f2-5af5-9c24-921b987ab251', 'e3a4c092-89d2-522d-9d49-4e879f6aad5b', '12255bbc-3155-5df5-a2f7-2aa42cc7fb01', '4a99ea70-942a-5b17-9a42-26f615c32411', '1b0a8c7a-8e12-5f4c-9348-b37db8e5b6df', '82ef4c6f-1159-5929-8d06-5176481ec699', '6a2219b3-7e66-5cda-b42b-2379421d6875', 'f860a3b7-f282-5085-801c-3b2ee2cc811a', '65d9bc3b-7e5d-5669-9621-7c15da8aac4f', '6f5c134d-0211-5434-8d74-25e87ca972d5', '60f966dd-ab59-56df-9965-5d5af5de3421', '88bc9dcf-04bf-56aa-a96d-7bd5a26a2a92', 'be32dd42-90a9-5211-8e90-61a1c4315532', 'de1bdb75-5766-5386-8381-9ba8a97b0178', '6c875e8f-9504-565b-84ea-01b3c94d5d9e', '9c2c0d33-7b94-55d9-b50b-be19e518ee0c', 'd0742072-00a4-5ae0-8977-b719c0eeb000', '3bb04004-63ed-53bc-9595-e2f4902b1dd1', 'b3e21e54-796d-5462-af3f-b6e41089c69c', 'f7f22f9e-d0a7-5050-b8a7-e58ebb1bc13c', 'd31819f8-0098-54db-9a90-7b306b9fe726', 'ef9dc33c-02a1-5054-9742-9a43379dd101', '075a0cf9-ea64-589e-9f32-f6de90fc43f3', '8013655d-4b08-5c46-be1d-072f39c7e963', 'bddd7851-e065-5414-ad0e-d63e789df1b5', 'a7bbc4c4-6f86-5ab5-aca5-3fbf1b7ebb9b', 'f3d87391-6ec0-5a21-83d7-4695d489be34', '69b5a2db-9d81-50de-a7e2-f23c840dcca2', '93fe4958-ebc7-580b-b054-cf664709f4b7', '1eea1018-d4d7-5399-9836-dd159d6e8ab7', '8e07c231-8272-546d-bc79-e8ef656566d0', 'c1a436d0-ad0f-546e-9a0f-6706744d84df', '0c87b478-0647-51a3-92b9-06894478dad4', 'f7992686-1a81-5a12-889c-4424d5c3cb99', 'c2f0931c-aada-57e1-be1a-01a6aaeaa934', '8fffe3af-0d36-594f-9515-4538e478da3c', '53b00386-e110-5421-9d3f-b8a2ca6a7713', 'b614fe5e-5b37-5cd5-9eb9-ec894f3f3d00', 'd1600abb-78b9-5deb-b34c-b9e20c74ab6c', 'd4fc4335-5fad-5e60-b589-4a286fa53b4a', '93b0be8c-c416-5d68-8a6d-79bc8d004def', '3d555195-c123-5058-9317-3c325e822573', 'a930a97c-7a14-53f5-b908-210574818353', '772e480d-8229-558b-af85-ff5423d1f123', '109b85ac-f7af-5121-8c9d-819516b77385', '0db804e0-8c25-5da7-b5d6-283a06cd6f78', '34b60314-5e50-5176-8c30-275a929fe8fb', '0eba131c-84d4-5369-9dbf-17e3b3cff1dc', '3018eeeb-8eb1-5321-9f2d-b465c2f2c834', '5ac58c67-e2af-5bed-a935-0f296b66ad32', '30423337-f8bd-5163-97ad-645050cfeb11', 'a99b0feb-161b-50b6-887e-a1090f102c72', '02bc95fb-fb43-579d-aa7c-b66b198f7ce1', '3658f0eb-8d84-579f-9c62-afa731e0bd44', '515a9f9d-5035-54a7-97c3-6811363751e1', '7d1d5861-935a-5364-9464-e11f8571c149', '2c35d2e8-47f5-55df-be93-7700050cbe49', 'acafb664-8e02-5c2b-940b-e699b4d80a85', '1b7738c5-704b-5377-9faa-faeb9d735906', '1c3873bb-58c4-55a1-895b-23fc68a8ee3a', 'b95e762e-4d17-5abf-9038-fb164d744551', 'fe8d6d9b-7563-5728-9afc-38d69b41a32e', 'fc644467-d6fe-52f0-89ed-1ab4f2837894', 'c67fed1c-f516-5524-b295-30e4177a824f', 'abdfe6cc-6da9-5959-905c-12d4b6da43aa', '00c13caa-7b80-58a6-a166-8415ef81aea4', '01789126-f7cf-5a53-a578-d0ac204a9deb', '5c8288ab-3cb4-5a5d-8b2e-8e70168d14e6', '0ec82fea-cca5-5928-a7ed-88defed51d2a', '5139259a-24ed-5924-8161-3c8781279ed1', '52c268e0-22a7-5a06-b8e4-63e11ee29cf5', '01a30ce0-5d33-5bbc-ae3b-afc6b41e7980', '32871165-1767-5bb5-8108-7b31719dd962', '76ef132a-6f05-50ce-ba60-45a6467817a6', 'fb0b778f-369e-5f8d-b4dc-3e80be8bfd32', '29da85aa-f2bf-5411-91ef-339ac5fb439d', '90a9d83a-af1c-54fe-9e8a-47c33cad50b9', '9961e725-76b5-5511-bfe4-a452b7fd9b8c', '81135b83-6bcd-57c1-87a3-d80c88b56ba1', '3c3a4199-c6ec-5e1c-ad13-3808c7693891', 'dfa11760-467f-54cf-b95c-41da696c0440', 'b6c9c7e7-c64d-5760-ad27-4e5ea5048505', 'f1ea4bec-e5eb-59d7-bc1f-4d99b909fb48', 'ebb511a3-47ae-5973-8a4f-8493499423b3', '717e77f4-80c4-5027-9e5f-213b72d6a89d', '1c073006-f0c2-5a4c-b4ef-1ce95302eae8', 'd736a8ab-e4d0-5245-9a15-b333c6199bd1', 'd18264f7-340d-5ae6-ba66-80c354e5a3db', '11d7916d-e00f-57d0-8192-70a431751bb8', 'e89757ef-213d-5544-a348-9e9e7a3f41b1', 'd0e3d50c-3908-52a3-b366-b4cb98cd2d31', '21fb1302-b318-5dcb-8870-7be36088f371', '5835a413-b205-5bb8-9ca9-d631bd0cadbc', '517085e6-1be2-5d00-83bf-bd1c26b85eb9', 'aa7a8b58-2f70-5928-939f-eeac05d21c88', 'd176cc0e-8c39-5a9f-a41e-8310a637c23f', 'ad84820c-1a8e-5c66-badd-db1b850d87d8', '41a660dc-374e-5370-9bc2-17733238a21b', 'b2a43027-007e-586a-be80-9cf06b62b8a6', '164f5838-63af-51a0-8648-dffc1c08c1a9', '382263c1-c0fd-5fbd-b72f-c113038cf930', '6d5df013-b9bd-5760-b30b-4eb446d3206f', '8ecdd3d3-e349-5c73-8fe7-52c169056eec', '7d059e50-77e7-5ce6-92ea-72d9c3235dbe', 'd6307a65-9b23-58f9-8084-88be053e06d0', '85a0aaf6-fe4a-5dad-8125-c43eda16ec69', '2e4ea578-2878-558d-8e79-9b7e25a16419', 'd2f8a20c-0fc6-5fdf-97fd-5895b656d170', '18dc6456-fda1-5e7c-8b86-e50cc3856bae', 'e2c107fe-74b1-5b7d-b9dc-a9190fedef5c', '4234b99d-8aaa-5b20-961d-952e82a8e724', '93ccd740-b73b-5b7b-afe8-e662df87e015', '7c906072-4b3a-5068-b030-364111b91785', '455b3c1c-bc24-504b-896c-118c872b89f6', '4c63ea07-82af-5014-968c-102c61255bb3', '9eef389b-71db-579d-9cfd-ba9876db1e6b', '9cfc6e68-a1ae-55bd-8667-0c70d8f48eb1', 'a1d0d1c4-503f-5306-b68e-b0333f5eb26f', '09e65d1a-ab8c-557c-8561-20e7576b247d', '3ecbe3c3-423b-5a35-9643-d524685905d0', '5f0624cd-f0f2-53d9-86ba-f6b975c3ceff', '3e0b8c5a-c99e-5899-8213-7c362b5b937e', '76b225c2-3c23-51e3-a1e3-041025cb9fa3', 'c141b206-3bfc-5dcb-b3f7-856fcdaf28d3', 'fc0006a8-c7b9-53fa-b10e-bfcf8d5a2c06', 'f0b2ccba-f958-584d-995f-4bfedb45092f', '926f3f31-e2a8-52ab-9b56-464b306820de', '79903e60-fc33-579f-8961-f1150c689ebd', '4e4b26b4-2c14-55a2-9481-cfa8573f3b51', '64a3f3bc-183f-52cb-83a8-d0f64a605ade', '5ddde91a-7a65-54f0-9c40-840d44ef4012', 'f208d365-5a87-5879-8ec3-12a22fc4c001', 'c5d9ace5-38c3-5c50-8972-aa4723563384', '9ad142d2-6642-5c32-90eb-a8a46373566c', '963c514f-0c79-5d10-9f48-ac0d6afda930', 'e65ff868-1808-5ffe-a694-da3c8df4b98c', '9f0f6ea7-903d-5010-b38e-daa8b15a5baf', 'b40200e2-8535-548c-9efe-112fb11c4abe', '21a797af-e64a-51cf-a62a-caa26879ed31', 'eddc7e53-6a4b-5e51-b04a-10ef0d6f0882', '4e273e0b-1915-561b-8d96-05315157bc5c', 'fe9f7865-f1c4-57b7-bf88-9ac4b0c91b82', 'b69f545b-7580-54ec-875b-56e352752584', 'c308c084-d911-5a0e-962f-9cf34cad9761', '15389306-e80f-5bab-ad0f-e1febe97ac94', 'c195d6f4-9b25-5edd-b54b-acf142a09074', '94fd71e6-c4bc-5b9b-862c-fbe999285354', '1929bdf0-42e8-58d0-aefd-9e29a8217106', 'b095ead5-e4ba-5b12-b440-c28662d818f8', '6088c20b-8287-51dc-8a89-97d383069939', 'a17bd75a-ffe4-5f2f-9009-8865576198d8', '5f1fe0b7-b2ba-5b2e-a47a-7d2dfdf6b8b9', 'e5926e14-e40e-5236-914e-758f24465de0', 'b2209243-9507-51a7-8aae-e8f50cdefe50', '22c6f49e-fe32-5f5b-a188-73b51389d15e', 'a10c6801-924f-5606-b75b-be8814e3ce0e', '2a9889f3-70e9-54a3-9a3c-1f14c7b96aa0', '356ff584-1181-5c94-913f-6b6e181d3b43', '5e07883e-76c3-549d-950e-49c05bebc048', '1e68ae25-7fdd-550e-b4fa-33e66e95dc05', '0c03f2b0-e441-575a-b301-0eed0d945c36', '82db0f5a-d824-51c2-b2ba-531fa733e492', '67cce341-38d2-5712-97b7-081a70abc291', '316d72d9-949f-596e-9138-7294da6b6e1d', '0fdfb291-24d8-5a05-8fe5-d9ab4e31bb19', '4335a63d-67ed-52c3-b3f7-1893549ff3e7', 'e2b5081a-3146-5658-a1d7-b99d128eb7fd', '5e3a4f0c-5435-514c-bb0f-6f38c54ed5f4', '66971b99-efa6-51e5-a894-3504a3abd08f', '859c99fd-9525-56d1-aeaa-229740e4ec99', 'f4f3be4a-ab15-5245-a8f3-a8daaa812701', '3e65c55b-f482-5ecc-a0ad-527358025641', 'a1b92a9a-bc13-5077-80a9-5d2f20627382', '15d853e7-62e0-5784-8353-a3f87f457132', '4937b28f-ef86-542c-bbbc-dcdecb51a01d', '0c81b4f8-3ba2-52af-987f-05fa561d1819', '8182ece7-9fdc-55a1-941d-c993c6204ceb', '58ab57c0-a7da-509e-9b2f-f0283cfec24e', 'ad7a9c0d-34a7-5def-83c2-884d064e362e', '45bf3ef9-0a65-58ac-acdf-90eb0ae2a599', 'dd770b04-728e-50e9-b66f-75f951e5a58d', 'b3f7f7b8-05ec-5910-bb58-5686c9f43f31', '2032a4ff-e3f5-58b3-9ba6-6f532ded0424', '0f730ad8-d204-571c-820d-484404c091ba', '5d7094eb-bda1-5300-84dd-0c53b3276be2', '5eb62d19-0ec2-5922-afff-1e223f87d8e0', '16f0a8e6-1dda-5ea2-ade9-937197745d90', '0fe1c796-5f5b-5446-99eb-335fc4dda6a0', 'fcd9f7da-38ef-53ce-b9d0-a49ccabdd12b', '2b8fbb40-ac91-552c-81b1-767059d83dcf', '4bd3061b-2fd1-5090-8ea5-6b5aea7bf938', '87e1a99e-971d-5eb0-bb3d-e0de8dc0271a', 'df607cdd-1fe5-5bdd-b7de-7261852cbcbf', '6435faba-f6f0-5a65-be00-cdf276b3b439', '9416d013-3388-5d4d-92b4-1a4615d48435', 'a7d1d7a2-4d97-5746-b11c-6ac0967a71a3', '40910e38-27b2-5518-911d-cca9b8b2fdbc', '888cab9c-e934-5412-a064-d5ce3835889e');
DELETE FROM public.chapters c WHERE c.subject_id = 'francais-c2' AND c.id NOT IN ('29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', '02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'bef4483d-ba9c-542d-96fa-961df0120393', '6a602350-e05c-55f5-a3c3-5ab41ff28f68', '0be341fe-de5b-56f6-b5a9-2515a1056d1d', '5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', '950643fe-bef4-5a10-b618-6930438b4dbe') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'francais-c2', 'Les temps littéraires', 'Maîtrise les quatre temps du récit écrit et soutenu : le passé simple (action ponctuelle de premier plan), le passé antérieur (antériorité immédiate), le subjonctif imparfait et le plus-que-parfait du subjonctif (concordance littéraire). Reconnaître et ne pas confondre il parla / qu''il parlât, il fut / qu''il fût, il vint / qu''il vînt.', '# ⚔️ Les temps littéraires — les armes oubliées du récit écrit

> 💡 «Le passé simple n''est pas mort : il dort dans tout roman, tout conte, toute page d''histoire. L''écrivain qui le manie tient la plume des maîtres. Apprends à le reconnaître, à le forger, et à ne jamais le confondre avec son sosie, le subjonctif imparfait.»

## 🏰 Quatre temps de l''ombre

À l''oral et dans l''écrit courant, tu emploies le passé composé, l''imparfait et le subjonctif présent. Mais le **récit écrit et soutenu** — littérature, conte, narration historique — réveille quatre temps que la conversation a délaissés :

- le **passé simple** (_il parla, ils finirent, il vint_) : l''action ponctuelle, achevée, de **premier plan** ;
- le **passé antérieur** (_quand il eut fini, il sortit_) : l''**antériorité immédiate** par rapport à un passé simple ;
- le **subjonctif imparfait** (_qu''il parlât, qu''il fût, qu''il vînt_) : la concordance soutenue après une principale au passé ;
- le **plus-que-parfait du subjonctif** (_qu''il eût parlé, qu''il fût venu_) : son équivalent accompli.

> 🗡️ Réflexe de lecteur : ces temps ne sont pas des fautes ni des archaïsmes gratuits. Ce sont les marques d''un registre soutenu que tu dois savoir lire — et, pour le passé simple, produire.

## ⚡ Le passé simple : l''action de premier plan

Le **passé simple** exprime une action **ponctuelle, achevée, complète**, vue comme un point sur la ligne du temps. C''est le temps des **événements** du récit, surtout à la **3ᵉ personne**.

| Groupe / verbe     | il / elle | ils / elles   |
| ------------------ | --------- | ------------- |
| 1ᵉ groupe (parler) | il parla  | ils parlèrent |
| 2ᵉ groupe (finir)  | il finit  | ils finirent  |
| prendre            | il prit   | ils prirent   |
| être               | il fut    | ils furent    |
| avoir              | il eut    | ils eurent    |
| venir              | il vint   | ils vinrent   |
| faire              | il fit    | ils firent    |
| devoir             | il dut    | ils durent    |
| pouvoir            | il put    | ils purent    |
| voir               | il vit    | ils virent    |

_Il **entra**, **salua** l''assemblée, puis **prit** la parole._ Trois actions successives, chacune un point : le passé simple les **enchaîne**.

> ⚠️ Piège : le passé simple du 1ᵉ groupe se termine par **-a** à la 3ᵉ personne du singulier (_il parla_), **sans accent**. L''accent circonflexe (_qu''il parlât_) appartient au **subjonctif imparfait**, pas au passé simple.

## 🛡️ Passé simple ou imparfait : premier plan contre arrière-plan

Dans le récit, les deux temps du passé se **répartissent les rôles** :

| Temps            | Rôle                                        | Exemple                                       |
| ---------------- | ------------------------------------------- | --------------------------------------------- |
| **passé simple** | actions, événements, **premier plan**       | _Il **ouvrit** la porte._                     |
| **imparfait**    | décor, description, **arrière-plan**, durée | _La nuit **tombait**, le vent **soufflait**._ |

_La pluie **tombait** (décor) quand un cavalier **surgit** (événement) au tournant._ L''imparfait pose la toile de fond ; le passé simple y inscrit l''action soudaine.

> 🗡️ Test : si l''action **fait avancer** le récit, passé simple ; si elle **décrit** ou **dure**, imparfait.

## 🔮 Le passé antérieur : juste avant l''action

Le **passé antérieur** se forme avec l''**auxiliaire au passé simple** + le **participe passé**. Il marque une action **immédiatement antérieure** à un verbe au passé simple, presque toujours après _quand_, _lorsque_, _dès que_, _après que_, _à peine… que_.

| Auxiliaire      | Exemple de passé antérieur             |
| --------------- | -------------------------------------- |
| avoir → il eut  | _quand il **eut fini**, il sortit_     |
| être → elle fut | _dès qu''elle **fut partie**, on ferma_ |

_À peine **eut-il prononcé** ces mots qu''un silence tomba._ L''action achevée (_eut prononcé_) précède de peu l''événement principal (_tomba_).

> ⚠️ Piège : ne confonds pas le **passé antérieur** (_il eut fini_, auxiliaire au passé simple) avec le **plus-que-parfait** (_il avait fini_, auxiliaire à l''imparfait). Le passé antérieur va de pair avec un **passé simple** ; le plus-que-parfait, avec un **imparfait** ou un passé composé.

## 🧪 Le subjonctif imparfait : le sosie du passé simple

Dans la langue **littéraire**, après une principale au **passé**, le subjonctif recule : on emploie le **subjonctif imparfait** là où l''usage courant garde le subjonctif présent.

| Courant                        | Soutenu / littéraire           |
| ------------------------------ | ------------------------------ |
| _Je voulais qu''il **vienne**_  | _Je voulais qu''il **vînt**_    |
| _Il fallait qu''il **soit** là_ | _Il fallait qu''il **fût** là_  |
| _J''attendais qu''il **parle**_  | _J''attendais qu''il **parlât**_ |

La forme se **dérive du passé simple**, mais s''en distingue par l''**accent circonflexe** et, au singulier, le **-t final** :

| Verbe  | Passé simple (indicatif) | Subjonctif imparfait |
| ------ | ------------------------ | -------------------- |
| parler | il parla                 | qu''il parl**ât**     |
| être   | il fut                   | qu''il f**ût**        |
| avoir  | il eut                   | qu''il e**ût**        |
| venir  | il vint                  | qu''il v**înt**       |

> 🗡️ Indice de lecture : un **accent circonflexe** sur la dernière voyelle (_parlât, fût, eût, vînt_) trahit le subjonctif imparfait. _Il fut_ raconte un fait ; _qu''il fût_ exprime une volonté ou une nécessité dans une subordonnée.

## 📜 Le plus-que-parfait du subjonctif : l''accompli littéraire

C''est l''équivalent **accompli** du subjonctif imparfait : **auxiliaire au subjonctif imparfait** + participe passé. Il marque l''antériorité, en concordance soutenue, après une principale au passé.

| Courant (subjonctif passé)         | Soutenu (plus-que-parfait du subjonctif) |
| ---------------------------------- | ---------------------------------------- |
| _Je doutais qu''il **soit venu**_   | _Je doutais qu''il **fût venu**_          |
| _J''étais ravi qu''il **ait parlé**_ | _J''étais ravi qu''il **eût parlé**_       |

> ⚠️ Piège : _qu''il **eût** parlé_ (plus-que-parfait du subjonctif, antériorité) ≠ _qu''il **parlât**_ (subjonctif imparfait, simultanéité). Et _il **eut** parlé_ sans circonflexe, c''est le **passé antérieur** de l''indicatif — un fait, non un subjonctif.

> 🏆 Porte franchie ! Tu sais désormais distinguer les quatre temps de l''ombre : le passé simple qui scande l''action, l''imparfait qui peint le décor, le passé antérieur qui précède de peu, et les subjonctifs littéraires reconnus à leur circonflexe. Prochaine étape : tisser ces temps dans une page entière sans jamais prendre _il vint_ pour _qu''il vînt_.', '# 📜 Résumé : les temps littéraires

- **Passé simple** : action ponctuelle, achevée, de **premier plan** dans le récit écrit (_il parla, ils finirent, il prit, il fut, il eut, il vint, il fit_), surtout à la 3ᵉ personne ; finale **-a** sans accent au 1ᵉ groupe.
- **Passé simple vs imparfait** : le passé simple porte les **événements** (premier plan), l''imparfait la **description** et le décor (arrière-plan, durée).
- **Passé antérieur** : auxiliaire **au passé simple** + participe passé (_quand il eut fini, il sortit_ ; _dès qu''elle fut partie_) ; antériorité immédiate, en corrélation avec un passé simple.
- **Ne pas confondre** passé antérieur (_il eut fini_) et plus-que-parfait (_il avait fini_).
- **Subjonctif imparfait** (_qu''il parlât, qu''il fût, qu''il eût, qu''il vînt_) : concordance soutenue après un passé ; reconnaissable à l''**accent circonflexe** et au **-t final**, là où le passé simple n''en a pas (_il fut_ ≠ _qu''il fût_).
- **Plus-que-parfait du subjonctif** (_qu''il eût parlé, qu''il fût venu_) : antériorité littéraire = auxiliaire au subjonctif imparfait + participe passé.
- À ton niveau : **reconnaître** ces formes en lecture et distinguer indicatif / subjonctif (_il vint_ vs _qu''il vînt_).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', 'francais-c2', 'Les figures de style', 'Reconnaître, distinguer et interpréter les grandes figures de style : métaphore et comparaison, métonymie et synecdoque, litote et euphémisme, hyperbole, oxymore et antithèse, personnification, anaphore, gradation, chiasme, allitération et assonance, périphrase. Pour chaque figure : l''identifier dans un exemple, la séparer de sa figure voisine et nommer son effet. Niveau maîtrise (CECRL C2 / DALF C2).', '# ⚔️ Les figures de style — Le grimoire des sortilèges du langage

> 💡 «Une phrase ordinaire transmet une idée. Une figure de style la fait briller, trembler ou exploser. À toi de reconnaître chaque sortilège — et de ne jamais confondre deux incantations voisines.»

Bienvenue dans la chambre forte du style, héros de la **maîtrise (C2)**. Une **figure de style** est un **écart** volontaire par rapport à l''expression neutre : on dit autrement pour frapper plus fort. Le danger, à ce niveau, n''est pas d''ignorer les figures — c''est de **confondre les voisines**. Métaphore ou comparaison ? Litote ou euphémisme ? Oxymore ou antithèse ? Apprends à les distinguer au mécanisme, pas à l''intuition.

## 🔮 Les figures d''analogie : voir une chose dans une autre

On rapproche deux réalités. Tout se joue sur la présence ou l''absence de l''**outil de comparaison** (_comme, tel, pareil à, ainsi que, ressembler à_).

| Figure               | Mécanisme                                          | Exemple                                 |
| -------------------- | -------------------------------------------------- | --------------------------------------- |
| **Comparaison**      | rapproche deux termes **avec un outil** (_comme_…) | _Cet homme est fort **comme** un lion._ |
| **Métaphore**        | rapproche deux termes **sans outil**               | _Cet homme est un lion._                |
| **Personnification** | prête des traits humains à une chose/animal        | _Le vent **hurlait** sa colère._        |

> 🗡️ Test décisif : cherche l''outil. **Pas d''outil = métaphore** ; **outil présent = comparaison**. La métaphore identifie (_il est un lion_), la comparaison rapproche (_il est comme un lion_).

## 🛡️ Les figures de substitution : nommer par autre chose

On désigne une réalité par un terme qui lui est **lié** (et non semblable). Ne confonds pas le **type de lien**.

| Figure         | Lien utilisé                                                    | Exemple                                    |
| -------------- | --------------------------------------------------------------- | ------------------------------------------ |
| **Métonymie**  | lien **logique** (contenant/contenu, auteur/œuvre, cause/effet) | _**Boire un verre** ; lire **un Zola**._   |
| **Synecdoque** | lien d''**inclusion** : la **partie pour le tout**               | _**Une voile** à l''horizon_ (= un bateau). |
| **Périphrase** | remplace un mot par une **expression** qui le décrit            | _**L''astre du jour**_ (= le soleil).       |

> ⚠️ Piège classique : la synecdoque est une **métonymie particulière** (la partie/le tout). _Une voile_ pour _un bateau_ = synecdoque ; _boire un verre_ (le contenant pour le contenu) = métonymie. Cherche : partie d''un tout → synecdoque ; simple lien logique → métonymie.

## ⚡ Les figures d''atténuation et d''exagération : régler le volume

On dit **moins** ou **plus** que la réalité.

| Figure         | Mécanisme                                                       | Exemple                                         |
| -------------- | --------------------------------------------------------------- | ----------------------------------------------- |
| **Litote**     | dire **moins** (souvent par la négation) pour suggérer **plus** | _Il **n''est pas mauvais**_ (= il est très bon). |
| **Euphémisme** | atténuer une réalité **dure ou déplaisante**                    | _Il **nous a quittés**_ (= il est mort).        |
| **Hyperbole**  | **exagérer** pour frapper                                       | _Je te l''ai dit **mille fois**._                |

> 🗡️ Litote ≠ euphémisme. La **litote** dit peu pour faire entendre **beaucoup** (intensité cachée, souvent positive) ; l''**euphémisme** adoucit une réalité **pénible** (mort, maladie, licenciement). « Il n''est pas bête » = litote ; « un demandeur d''emploi » = euphémisme.

## 🧪 Les figures d''opposition : faire jaillir le contraste

| Figure        | Mécanisme                                                  | Exemple                   |
| ------------- | ---------------------------------------------------------- | ------------------------- |
| **Antithèse** | oppose **deux termes/idées** dans la phrase                | _Je vis, je meurs._       |
| **Oxymore**   | unit dans **un même groupe** deux mots **contradictoires** | _Une **obscure clarté**._ |

> ⚠️ Oxymore ≠ antithèse. L''**oxymore** soude le contraire **dans un seul syntagme** (« cette obscure clarté », « un silence assourdissant ») ; l''**antithèse** **distribue** l''opposition sur des termes distincts (« ici l''ombre, là la lumière »). Resserré = oxymore ; étalé = antithèse.

## 🏰 Les figures de construction et de répétition : sculpter la phrase

| Figure        | Mécanisme                                              | Exemple                                               |
| ------------- | ------------------------------------------------------ | ----------------------------------------------------- |
| **Anaphore**  | répète un mot/groupe **en tête** de phrases ou de vers | _**Mon** bras, **mon** sang, **mon** honneur._        |
| **Gradation** | énumère en **intensité croissante** (ou décroissante)  | _Va, cours, vole et nous venge._                      |
| **Chiasme**   | dispose les termes en miroir : structure **ABBA**      | _Il faut manger pour vivre et non vivre pour manger._ |

> 🗡️ Le chiasme se reconnaît à son croisement **ABBA** : les mêmes éléments reviennent **dans l''ordre inverse**. S''ils reviennent dans le **même** ordre (ABAB), ce n''est plus un chiasme mais un **parallélisme**.

## 🎵 Les figures de sonorité : jouer avec l''oreille

| Figure           | Son répété       | Exemple                                                |
| ---------------- | ---------------- | ------------------------------------------------------ |
| **Allitération** | une **consonne** | _Pour qui sont ces **s**erpents qui **s**ifflent…_ (s) |
| **Assonance**    | une **voyelle**  | _Tout m''afflige et me nuit et conspire à me nuire_ (i) |

> ⚠️ Piège d''oreille : **consonne → allitération**, **voyelle → assonance**. La répétition des _s_ qui « sifflent » est une allitération ; la reprise du son _i_ est une assonance.

> 🏆 Porte franchie ! Tu sais désormais reconnaître chaque figure, la séparer de sa jumelle traîtresse et nommer son effet. Prochaine quête : la **syntaxe expressive**, où ces sortilèges se combinent en phrases d''orfèvre.', '# 📜 Résumé : Les figures de style

- **Comparaison vs métaphore** — analogie **avec** outil (_fort comme un lion_) vs **sans** outil (_cet homme est un lion_). Pas d''outil = métaphore.
- **Personnification** — prêter des traits humains à une chose ou un animal : _le vent hurlait_.
- **Métonymie vs synecdoque** — lien **logique** (contenant/contenu, auteur/œuvre : _boire un verre, lire un Zola_) vs **partie pour le tout** (_une voile_ = un bateau). La synecdoque est une métonymie d''inclusion.
- **Périphrase** — désigner par une expression descriptive : _l''astre du jour_ = le soleil.
- **Litote vs euphémisme** — dire moins pour suggérer **plus** (_il n''est pas mauvais_ = très bon) vs **adoucir** une réalité pénible (_il nous a quittés_ = il est mort).
- **Hyperbole** — exagération expressive : _je te l''ai dit mille fois_.
- **Oxymore vs antithèse** — contradiction **dans un même groupe** (_obscure clarté_) vs opposition **étalée** sur des termes distincts (_je vis, je meurs_).
- **Anaphore / gradation / chiasme** — répétition **en tête** ; énumération en **intensité croissante** ; structure en miroir **ABBA**.
- **Allitération vs assonance** — répétition d''une **consonne** vs d''une **voyelle**.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'francais-c2', 'La syntaxe expressive et la stylistique de la phrase', 'Au-delà de la mise en relief : maîtriser l''inversion stylistique du sujet, la place expressive de l''adjectif et ses changements de sens, l''ellipse et la phrase nominale, le rythme (binaire, ternaire, parallélisme) et la périphrase — et distinguer un effet de style maîtrisé d''une lourdeur ou d''une faute.', '# ⚔️ La syntaxe expressive et la stylistique de la phrase — Forger ses armes de style

> 💡 «Au niveau C1, tu as appris à braquer le projecteur (la mise en relief). Au niveau C2, tu apprends à sculpter la phrase elle-même : son ordre, son rythme, ses silences. Le sens ne change pas — la force, si.»

## 🏰 La frontière entre l''effet et la faute

Une même entorse à l''ordre canonique **sujet–verbe–complément** peut être un trait de style admirable ou une lourdeur ridicule. Tout dépend du **registre**, de l''**intention** et de la **correction grammaticale**. Ce chapitre te donne les quatre grandes ressources de la **syntaxe expressive** — inversion, place de l''adjectif, ellipse, rythme/périphrase — et t''apprend à reconnaître le moment où l''effet bascule dans le défaut.

> 🗡️ Règle d''or : un écart de style se justifie par un gain (insistance, élégance, concision). S''il ne produit qu''une gêne à la lecture, ce n''est plus un effet, c''est une faute.

## ⚡ L''inversion stylistique du sujet

En français, le sujet précède normalement le verbe. Mais après certains **adverbes en tête de phrase**, dans les **incises**, et dans la langue **soutenue ou littéraire**, on inverse le sujet pour produire un effet.

| Cas                                   | Construction                  | Exemple                                        |
| ------------------------------------- | ----------------------------- | ---------------------------------------------- |
| Adverbe d''énonciation en tête         | adverbe + verbe + sujet       | _**Ainsi parla** Zarathoustra._                |
| _Peut-être_, _sans doute_, _aussi_    | adverbe + verbe + sujet (-il) | _**Peut-être viendra-t-il** demain._           |
| _À peine_, _à peine… que_             | À peine + verbe + sujet       | _**À peine fut-il sorti que** la pluie tomba._ |
| Incise (verbe de parole)              | « … », dit + sujet            | _« J''arrive », **dit-il**._                    |
| Sujet long après complément (soutenu) | … + verbe + sujet             | _Sur la colline se dressait **un château**._   |

> 🗡️ Avec un sujet pronom (_il, elle, on_), l''inversion ajoute un trait d''union et parfois un _-t-_ euphonique : _**Peut-être a-t-il** raison_, _**Sans doute viendra-t-elle**_.

> ⚠️ Piège : sans inversion, _peut-être_ et _sans doute_ en tête exigent _que_ : on écrit _**Peut-être qu''il** viendra_ OU _**Peut-être viendra-t-il**_, jamais _~~Peut-être il viendra~~_. L''inversion mal formée (_~~Peut-être il viendra-t-il~~_, _~~Ainsi il parla-t-il~~_) est une faute lourde.

## 🛡️ La place expressive de l''adjectif : quand la position change le sens

C''est l''arme la plus fine du chapitre. Pour une série d''adjectifs, l''**antéposition** (avant le nom) et la **postposition** (après le nom) ne sont pas équivalentes : elles donnent **deux sens différents**. L''adjectif antéposé prend souvent une valeur **figurée, affective ou subjective** ; postposé, il garde son sens **propre, objectif, classifiant**.

| Antéposé (figuré / subjectif)              | Postposé (propre / objectif)                |
| ------------------------------------------ | ------------------------------------------- |
| _un **grand** homme_ (illustre)            | _un homme **grand**_ (de haute taille)      |
| _un **pauvre** homme_ (à plaindre)         | _un homme **pauvre**_ (sans argent)         |
| _un **certain** âge_ (assez avancé, vague) | _un âge **certain**_ (avéré, indéniable)    |
| _mes **propres** mains_ (à moi)            | _des mains **propres**_ (lavées)            |
| _un **seul** homme_ (un unique)            | _un homme **seul**_ (solitaire)             |
| _un **ancien** élève_ (autrefois élève)    | _un meuble **ancien**_ (vieux, antique)     |
| _un **curieux** personnage_ (étrange)      | _un personnage **curieux**_ (qui s''informe) |

> 🗡️ Mémo : avant le nom = le sens **moral ou affectif** ; après le nom = le sens **matériel ou littéral**. _Un grand homme_ peut être de petite taille ; _un homme grand_ peut être un imbécile.

> ⚠️ Piège : inverser ces sens est une faute de niveau C2. _Un homme pauvre_ ne signifie **pas** « un homme à plaindre » ; pour la pitié, il faut _un pauvre homme_.

## 🔮 L''ellipse stylistique et la phrase nominale

L''**ellipse** supprime un mot ou un groupe que le contexte rend évident, au profit de la concision et de la frappe. La **phrase nominale** (sans verbe conjugué) en est le cas extrême.

- **Ellipse du verbe** : _À chacun son métier_ (= à chacun _revient_ son métier). _Chacun sa route, chacun son chemin._
- **Parallélisme elliptique** : _Loin des yeux, loin du cœur._ _Tel père, tel fils._
- **Phrase nominale** : _Pas de nouvelles, bonnes nouvelles._ _Quelle soirée !_ _Chute du gouvernement_ (titre de presse).

| Forme pleine (lourde)                              | Forme elliptique (vive)        |
| -------------------------------------------------- | ------------------------------ |
| _Il faut que chacun fasse son métier._             | _À chacun son métier._         |
| _Quand on est loin des yeux, on est loin du cœur._ | _Loin des yeux, loin du cœur._ |

> ⚠️ Piège : l''ellipse n''est valide que si l''élément omis est **récupérable sans ambiguïté**. _~~Je mange une pomme et lui une~~_ est maladroit ; on dira _et lui aussi_. Une ellipse qui force le lecteur à reconstruire péniblement n''est pas un effet : c''est une obscurité fautive.

## 🧮 Le rythme : binaire, ternaire, parallélisme

La **mise en rythme** organise la phrase en groupes équilibrés. Le **rythme binaire** oppose ou balance deux membres ; le **rythme ternaire** (la fameuse cadence en trois temps) crée une ampleur et une chute.

| Procédé             | Définition                        | Exemple                                                |
| ------------------- | --------------------------------- | ------------------------------------------------------ |
| **Rythme binaire**  | deux membres équilibrés           | _Il faut manger pour vivre, et non vivre pour manger._ |
| **Rythme ternaire** | trois membres, souvent croissants | _Je suis venu, j''ai vu, j''ai vaincu._                  |
| **Parallélisme**    | même structure répétée            | _Partir, c''est mourir un peu._ (structure reprise)     |
| **Gradation**       | termes d''intensité croissante     | _Un souffle, une ombre, un rien le faisait fuir._      |

> 🗡️ Astuce : le ternaire croissant (du plus court au plus long) crée une **montée** ; placé en fin de phrase, il en assure la chute. C''est le secret des grandes périodes oratoires.

## 🪐 La périphrase : nommer sans nommer

La **périphrase** remplace un mot par une expression qui le décrit, pour éviter une répétition, ennoblir, ou créer un effet poétique. Le lecteur cultivé doit savoir la **décoder**.

| Périphrase             | Désigne     |
| ---------------------- | ----------- |
| _l''astre du jour_      | le soleil   |
| _l''astre des nuits_    | la lune     |
| _la Ville Lumière_     | Paris       |
| _le roi des animaux_   | le lion     |
| _la langue de Molière_ | le français |
| _le septième art_      | le cinéma   |

> ⚠️ Piège : une périphrase mal interprétée trahit le lecteur. _L''astre du jour_ n''est **pas** la lune ; _la langue de Shakespeare_ désigne l''anglais, pas le théâtre. Et trop de périphrases alourdissent : abuser de _le précieux liquide_ pour « l''eau » devient une lourdeur (le défaut nommé _cheville_ ou _style ampoulé_).

> 🏆 Porte franchie ! Tu sais désormais inverser un sujet sans faute, placer l''adjectif pour en infléchir le sens, manier l''ellipse et le rythme, et lire les périphrases. Tu ne subis plus la phrase : tu la sculptes. Prochaine quête : la rhétorique et l''argumentation experte.', '# 📜 Résumé : La syntaxe expressive et la stylistique de la phrase

- **Effet ou faute** — un écart à l''ordre canonique est un style s''il apporte un gain (force, élégance, concision) ; sinon, c''est une lourdeur ou une faute.
- **Inversion du sujet** — après certains adverbes en tête (_Ainsi parla…_, _Peut-être viendra-t-il_, _Sans doute a-t-il raison_, _À peine fut-il sorti que…_), dans les incises (_dit-il_) et en style soutenu ; trait d''union et _-t-_ euphonique avec un pronom.
- **Place expressive de l''adjectif** — antéposé = sens figuré/affectif, postposé = sens propre : _un grand homme_ (illustre) ≠ _un homme grand_ (de taille) ; _un pauvre homme_ (à plaindre) ≠ _un homme pauvre_ (sans argent) ; _mes propres mains_ ≠ _des mains propres_ ; _un seul homme_ ≠ _un homme seul_.
- **Ellipse et phrase nominale** — supprimer l''évident pour la concision : _À chacun son métier_, _Loin des yeux, loin du cœur_, _Pas de nouvelles, bonnes nouvelles_ — valide seulement si l''omis est récupérable sans ambiguïté.
- **Rythme** — binaire (deux membres), ternaire (_Je suis venu, j''ai vu, j''ai vaincu_), parallélisme et gradation croissante créent la cadence et la chute.
- **Périphrase** — nommer par une expression : _l''astre du jour_ = le soleil, _la Ville Lumière_ = Paris, _la langue de Molière_ = le français ; mal interprétée ou abusée, elle alourdit le style.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('bef4483d-ba9c-542d-96fa-961df0120393', 'francais-c2', 'Nuances lexicales et paronymes savants', 'Atteignez la précision quasi native : distinguez des quasi-synonymes selon la nuance et le contexte (problème / souci / écueil ; commencer / entamer / amorcer / inaugurer), maîtrisez les paronymes savants qui piègent même les lettrés (éminent / imminent ; conjecture / conjoncture ; affliger / infliger ; recouvrer / recouvrir) et déjouez les glissements de sens critiqués (« opportunité », « solutionner », « conséquent »).', '# 🔮 Nuances lexicales et paronymes savants — L''art du mot exact

> 💡 «Au niveau C2, on ne cherche plus un synonyme : on cherche LE mot. Entre _problème_ et _écueil_, entre _éminent_ et _imminent_, se joue toute la différence entre un écrit correct et un écrit d''orfèvre.»

## 🏰 Pourquoi ce chapitre

Tu lis tout, tu écris juste. Il te reste à conquérir la **précision lexicale** : choisir, parmi des mots voisins, celui dont la nuance épouse exactement ta pensée, et ne jamais confondre deux **paronymes** — ces mots presque jumeaux par la forme mais étrangers par le sens. À ce niveau, la faute n''est plus grossière : c''est le **faux sens discret**, l''_éminent_ pris pour l''_imminent_, l''_acception_ pour l''_acceptation_. Le DALF C2 traque ces glissements. Voici ton armurerie.

## ⚡ Quasi-synonymes : la bonne nuance pour le bon contexte

Des mots proches ne sont pas interchangeables : chacun porte une **intensité** ou une **coloration** propre.

| Série                                         | La nuance qui les sépare                                                                                                                                     |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **problème / souci / écueil / difficulté**    | _souci_ = préoccupation morale ; _écueil_ = obstacle redoutable, piège caché ; _difficulté_ = ce qui rend ardu ; _problème_ = le terme neutre, générique     |
| **commencer / entamer / amorcer / inaugurer** | _entamer_ = commencer en attaquant une matière/un capital ; _amorcer_ = enclencher un processus ; _inaugurer_ = ouvrir solennellement ; _commencer_ = neutre |
| **défaut / vice / travers**                   | _travers_ = petit défaut de caractère, léger ; _vice_ = défaut grave, moral ou de fabrication ; _défaut_ = imperfection générale                             |
| **demander / réclamer / exiger / quémander**  | _réclamer_ = demander avec insistance un dû ; _exiger_ = demander impérativement ; _quémander_ = mendier humblement ; _demander_ = neutre                    |

> 🗡️ Astuce : un **écueil**, au sens propre, est un rocher qui fait sombrer le navire. Réserve-le aux obstacles dangereux et imprévus — pas à une simple « difficulté » de calcul.

## 🛡️ Paronymes savants : presque jumeaux, jamais synonymes

Un **paronyme** ressemble à un autre par le son ou la graphie, mais son sens est tout différent. Les confondre est la faute reine du C2.

| Paronyme A → sens                                   | Paronyme B → sens                                     |
| --------------------------------------------------- | ----------------------------------------------------- |
| **prodige** = personne ou fait extraordinaire       | **prodigue** = qui dépense sans compter (l''enfant ~)  |
| **éminent** = remarquable, supérieur                | **imminent** = sur le point d''arriver                 |
| **conjecture** = supposition, hypothèse             | **conjoncture** = situation, circonstances du moment  |
| **acception** = sens d''un mot                       | **acceptation** = fait d''accepter                     |
| **affliger** = accabler de chagrin / d''un mal       | **infliger** = imposer (une peine, une punition)      |
| **perpétrer** = commettre (un crime)                | **perpétuer** = faire durer, transmettre              |
| **recouvrer** = retrouver (la santé, son dû)        | **recouvrir** = couvrir entièrement                   |
| **inclinaison** = état penché, angle (d''un toit)    | **inclination** = penchant, goût, sentiment           |
| **effraction** = forcer une fermeture (vol avec ~)  | **infraction** = violation d''une loi, d''une règle     |
| **collusion** = entente secrète et frauduleuse      | **collision** = choc, heurt entre deux corps          |
| **prolifique** = qui produit beaucoup (un auteur ~) | **prolixe** = trop long, bavard, diffus               |
| **littéral** = à la lettre, au sens propre          | **littoral** = le bord de mer, la côte                |
| **évoquer** = faire penser à, mentionner            | **invoquer** = appeler à l''aide, citer comme argument |
| **émigrer** = quitter son pays                      | **immigrer** = entrer dans un pays pour s''y installer |

> ⚠️ Piège : _affliger_ / _infliger_. On **inflige** une peine (on l''impose à autrui) ; on **afflige** quelqu''un de chagrin (on l''accable). « Le juge lui a infligé une amende » — jamais ~~affligé~~ une amende.

## 🔮 Faux-amis internes et glissements critiqués

Certains mots changent de sens sous l''influence de l''anglais ou du relâchement. Le registre soutenu garde le sens exact.

| Emploi critiqué                             | Sens exact en français soigné                                                                                          |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **opportunité** = « occasion » (anglicisme) | _opportunité_ = caractère de ce qui est **opportun**, à-propos ; pour « bonne occasion », dis **occasion**             |
| **solutionner** un problème                 | préfère **résoudre** un problème (_solutionner_ est familier, critiqué)                                                |
| **conséquent** = « important, grand »       | _conséquent_ = qui agit avec logique, qui suit (une conséquence) ; pour « important », dis **important, considérable** |

> 🗡️ Astuce : « J''attends une réponse **conséquente** » ne veut pas dire « une grosse réponse » mais « une réponse **cohérente** avec ce qui précède ». Pour la taille ou l''ampleur, emploie _important_.

## 🧪 Choisir LE mot exact

Devant un sens à exprimer, ne te contente pas du premier mot venu : interroge sa **nuance**, sa **construction**, son **registre**.

1. **La nuance** — pour un obstacle dangereux, _écueil_ ; pour un simple ennui, _difficulté_.
2. **La forme** — _affliger_ une personne (de chagrin) ; _infliger_ une chose (une peine) à une personne.
3. **Le registre** — à l''écrit soutenu, _résoudre_ plutôt que _solutionner_, _occasion_ plutôt qu''_opportunité_.

> 🏆 Porte franchie ! Tu distingues désormais l''_éminent_ de l''_imminent_, l''_écueil_ de la _difficulté_, et tu n''écriras plus « pallier à ses opportunités ». Au prochain donjon, le mot exact sera ton arme la plus tranchante.', '# 📜 Résumé : Nuances lexicales et paronymes savants

- **Quasi-synonymes** — choisis selon la nuance : _souci_ (préoccupation morale), _écueil_ (obstacle dangereux), _difficulté_ (ce qui est ardu), _problème_ (neutre) ; _entamer_ (attaquer une matière), _amorcer_ (enclencher), _inaugurer_ (ouvrir solennellement), _commencer_ (neutre).
- **défaut / vice / travers** — _travers_ = petit défaut de caractère ; _vice_ = défaut grave ou moral ; _défaut_ = imperfection générale.
- **demander / réclamer / exiger / quémander** — _réclamer_ (un dû avec insistance), _exiger_ (impérativement), _quémander_ (humblement), _demander_ (neutre).
- **Paronymes — forme** — _prodige_/_prodigue_, _éminent_/_imminent_, _conjecture_/_conjoncture_, _acception_/_acceptation_, _inclinaison_/_inclination_, _littéral_/_littoral_.
- **Paronymes — action** — _affliger_ (accabler de chagrin) / _infliger_ (imposer une peine) ; _perpétrer_ (commettre) / _perpétuer_ (faire durer) ; _recouvrer_ (retrouver) / _recouvrir_ (couvrir) ; _évoquer_ (mentionner) / _invoquer_ (appeler à l''aide).
- **effraction / infraction · collusion / collision · émigrer / immigrer** — forcer une fermeture / violer une loi ; entente secrète / choc ; quitter son pays / y entrer.
- **prolifique / prolixe** — qui produit beaucoup / trop long et bavard.
- **Glissements critiqués** — _opportunité_ = à-propos (pour « occasion », dis **occasion**) ; préfère **résoudre** à _solutionner_ ; _conséquent_ = logique, qui suit (pour « important », dis **important**).
- **Méthode** — interroge la nuance, la construction et le registre pour choisir LE mot exact.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6a602350-e05c-55f5-a3c3-5ab41ff28f68', 'francais-c2', 'Expressions rares, proverbes et locutions latines', 'Atteins la maîtrise du français cultivé : les proverbes et leur sens d''emploi, les expressions soutenues et rares, les locutions latines du français savant (a priori, sine qua non, in fine…), et les culturèmes mythologiques (le talon d''Achille, l''épée de Damoclès). Reconnaître, comprendre et employer à bon escient ce que le registre lettré exige au niveau C2.', '# ⚔️ Expressions rares, proverbes et locutions latines — Le grimoire du lettré

> 💡 «Au niveau C2, la langue se mérite. Un proverbe bien placé, une locution latine maîtrisée, et l''on devine derrière toi des siècles de culture. Mal employés, ils trahissent l''imposteur.»

## 🏰 Pourquoi ce grimoire

Tu as déjà conquis les expressions imagées du C1. Voici l''arsenal des **érudits** : les **proverbes** (ces vérités générales transmises par la sagesse populaire), les **expressions rares et soutenues** que l''on rencontre dans la grande littérature et la presse exigeante, les **locutions latines** que le français cultivé n''a jamais cessé d''employer, et les **culturèmes** hérités de l''Antiquité. À ce niveau, le piège n''est plus le faux sens grossier mais la **nuance** : un proverbe voisin par l''image mais opposé par le sens, une locution latine employée à contresens. Apprends chaque bête avant de l''affronter en donjon.

## ⚡ Les proverbes : la sagesse en formule figée

Un **proverbe** énonce une vérité générale, une leçon de sagesse, sous une forme figée et souvent imagée. On ne le modifie pas.

| Proverbe                                                         | Sens                                                                |
| ---------------------------------------------------------------- | ------------------------------------------------------------------- |
| **Qui trop embrasse mal étreint**                                | qui entreprend trop de choses à la fois échoue dans toutes          |
| **La nuit porte conseil**                                        | il vaut mieux réfléchir, attendre le lendemain avant de décider     |
| **Il ne faut pas vendre la peau de l''ours avant de l''avoir tué** | ne pas se réjouir d''un avantage qu''on ne possède pas encore         |
| **Petit à petit l''oiseau fait son nid**                          | à force de persévérance et de patience, on parvient à ses fins      |
| **Qui sème le vent récolte la tempête**                          | celui qui provoque le désordre en subit des conséquences amplifiées |
| **La fortune sourit aux audacieux**                              | le succès récompense ceux qui osent prendre des risques             |

> 🗡️ Astuce : **Qui sème le vent récolte la tempête** insiste sur l''**amplification** du mal causé. Ne le confonds pas avec « on récolte ce que l''on sème », plus neutre : ici, la moisson est bien pire que la semence.

## 🛡️ Expressions soutenues et rares : la texture du grand style

Ces expressions appartiennent au registre **littéraire et soutenu**. À démonter au figuré, jamais au pied de la lettre.

| Expression                    | Sens figuré                                                     |
| ----------------------------- | --------------------------------------------------------------- |
| **battre la campagne**        | divaguer, déraisonner, parler à tort et à travers               |
| **rester de marbre**          | demeurer parfaitement impassible, sans la moindre émotion       |
| **jeter feu et flamme**       | manifester une violente colère, s''emporter avec véhémence       |
| **tenir le haut du pavé**     | occuper une position dominante, sociale ou professionnelle      |
| **une victoire à la Pyrrhus** | une victoire si coûteuse qu''elle équivaut presque à une défaite |
| **l''épée de Damoclès**        | un danger imminent et permanent qui menace sans cesse           |
| **se perdre en conjectures**  | multiplier les hypothèses sans parvenir à aucune certitude      |
| **prêcher dans le désert**    | parler en vain, sans être écouté ni suivi                       |
| **rendre l''âme**              | mourir (registre soutenu) ; aussi : cesser de fonctionner       |

> ⚠️ Piège : une **victoire à la Pyrrhus** n''est pas un triomphe éclatant ! C''est l''inverse : le vainqueur y perd tant qu''il aurait presque mieux valu perdre. L''expression vient du roi Pyrrhus, dont les victoires sur Rome décimèrent son armée.

## 🔮 Les locutions latines : l''héritage savant

Le français soutenu emploie sans cesse ces locutions latines. Maîtrise leur **sens** et leur **orthographe** (sans accent, généralement en italique à l''écrit).

| Locution             | Sens                                                            |
| -------------------- | --------------------------------------------------------------- |
| **a priori**         | au premier abord, avant tout examen ; préjugé initial           |
| **a posteriori**     | après coup, à la lumière de l''expérience                        |
| **in extremis**      | au tout dernier moment, de justesse                             |
| **in fine**          | au bout du compte, finalement                                   |
| **grosso modo**      | en gros, approximativement                                      |
| **de facto**         | de fait, dans les faits (par opposition au droit)               |
| **statu quo**        | l''état actuel des choses, maintenu sans changement              |
| **ipso facto**       | par le fait même, automatiquement, par voie de conséquence      |
| **mutatis mutandis** | en changeant ce qui doit l''être ; toutes proportions gardées    |
| **sine qua non**     | indispensable, sans quoi la chose ne peut exister (condition ~) |
| **a fortiori**       | à plus forte raison, avec une raison encore plus grande         |
| **ad hoc**           | conçu spécialement pour un usage précis, approprié              |
| **modus vivendi**    | un arrangement, un compromis permettant de coexister            |

> 🗡️ Astuce : ne confonds pas **de facto** (« de fait », réalité) et **de jure** (« de droit », légalité). Un dirigeant peut gouverner _de facto_ sans être reconnu _de jure_.

## 🧪 Les culturèmes : l''Antiquité dans la langue

Ces images héritées de la mythologie et de l''histoire ancienne sont des références culturelles partagées.

| Culturème                  | Sens                                                                     |
| -------------------------- | ------------------------------------------------------------------------ |
| **un travail de Romain**   | une tâche colossale, exigeant un effort considérable                     |
| **le talon d''Achille**     | le point faible, vulnérable, d''une personne ou d''un système              |
| **le supplice de Tantale** | une frustration cruelle : un bien désiré, tout proche, mais inaccessible |
| **un cheval de Troie**     | une ruse pour s''introduire chez l''adversaire ; menace dissimulée         |
| **le fil d''Ariane**        | le guide, le repère qui permet de se retrouver dans la complexité        |

> ⚠️ Piège : le **supplice de Tantale**, ce n''est pas n''importe quelle souffrance, mais précisément celle de désirer une chose accessible en apparence mais qui se dérobe toujours. Tantale, condamné, voyait l''eau et les fruits reculer dès qu''il les approchait.

## 📜 Stratégie : employer ces armes à bon escient

1. **Le sens exact avant l''effet** — un proverbe mal compris ou une locution latine à contresens ruine ta crédibilité plus sûrement qu''une absence d''érudition.
2. **L''opposition des voisins** — beaucoup de proverbes se ressemblent par l''image mais divergent par le sens ; vérifie la leçon, pas seulement le décor.
3. **La forme figée** — on ne modifie ni un proverbe, ni l''orthographe d''une locution latine. _Sine qua non_, jamais ~~« sine qua none »~~.

> 🏆 Porte franchie ! Tu possèdes désormais le grimoire des proverbes, des expressions rares, des locutions latines et des culturèmes du C2. Au prochain donjon, ces armes lettrées feront la différence face aux textes les plus exigeants.', '# 📜 Résumé : Expressions rares, proverbes et locutions latines

- **Proverbes** : vérités générales figées. _Qui trop embrasse mal étreint_ (qui en fait trop échoue), _La nuit porte conseil_ (attendre pour décider), _Ne pas vendre la peau de l''ours…_ (ne pas se réjouir trop tôt), _Petit à petit l''oiseau fait son nid_ (la persévérance paie), _Qui sème le vent récolte la tempête_ (le mal causé revient amplifié), _La fortune sourit aux audacieux_ (oser, c''est réussir).
- **Expressions soutenues et rares** : _battre la campagne_ (divaguer), _rester de marbre_ (impassible), _jeter feu et flamme_ (s''emporter), _tenir le haut du pavé_ (dominer), _une victoire à la Pyrrhus_ (triomphe ruineux), _l''épée de Damoclès_ (danger imminent), _se perdre en conjectures_ (multiplier les hypothèses), _prêcher dans le désert_ (parler en vain), _rendre l''âme_ (mourir).
- **Locutions latines** : _a priori / a posteriori_ (avant / après examen), _in extremis_ (de justesse), _in fine_ (finalement), _grosso modo_ (en gros), _de facto_ (de fait), _statu quo_ (état maintenu), _ipso facto_ (automatiquement), _mutatis mutandis_ (les ajustements faits), _sine qua non_ (indispensable), _a fortiori_ (à plus forte raison), _ad hoc_ (approprié), _modus vivendi_ (compromis).
- **Culturèmes antiques** : _un travail de Romain_ (tâche colossale), _le talon d''Achille_ (point faible), _le supplice de Tantale_ (frustration d''un bien inaccessible), _un cheval de Troie_ (ruse dissimulée), _le fil d''Ariane_ (guide dans la complexité).
- **Pièges** : ne pas confondre des proverbes voisins par l''image mais opposés par le sens, ni employer une locution latine à contresens. Forme et orthographe sont figées.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('0be341fe-de5b-56f6-b5a9-2515a1056d1d', 'francais-c2', 'La rhétorique et l''argumentation experte', 'Au-delà des connecteurs : maîtrise les procédés argumentatifs et persuasifs du niveau C2 — la concession rhétorique (« certes… mais… » : concéder pour mieux réfuter), la réfutation, la question rhétorique, l''ironie et l''antiphrase argumentative, la prétérition (« je ne parlerai pas de… »), l''argument d''autorité, l''analogie, l''exemple et le contre-exemple, la modalisation (il semblerait, sans doute, force est d''admettre). Apprends à reconnaître le procédé employé dans un énoncé et à identifier sa fonction (convaincre, persuader, nuancer, disqualifier l''adversaire), puis à distinguer un argument valable d''un sophisme (généralisation hâtive, homme de paille, faux dilemme, pente glissante, ad hominem, pétition de principe).', '# ⚔️ La rhétorique et l''argumentation experte — Forge l''art de convaincre et de démasquer

> 💡 « Au C1, tu reliais tes idées avec les bons connecteurs ; au C2, tu manœuvres l''esprit de ton lecteur. Un maître de la rhétorique sait non seulement persuader, mais aussi flairer le sophisme caché sous l''argument. C''est la dernière arme du DALF C2. »

## 🏰 Du connecteur au procédé : changer de niveau de jeu

Connaître _certes… néanmoins_ ne suffit plus. Ici, tu n''étudies pas les **mots de liaison** mais les **procédés** : des gestes argumentatifs qui agissent sur le destinataire. Trois questions guident tout ce chapitre : **quel procédé** est employé ? **quelle fonction** vise-t-il (convaincre par la logique, persuader par l''émotion, nuancer, disqualifier l''adversaire) ? et surtout — est-ce un **argument valable** ou un **sophisme** déguisé ?

> 🗡️ Distinction clé : **convaincre**, c''est emporter l''adhésion par la **raison** (preuves, logique) ; **persuader**, c''est l''emporter par les **émotions** et l''adhésion affective. Un orateur jongle avec les deux.

## ⚡ Les procédés de la concession et de la réfutation

Le cœur de l''argumentation experte : feindre d''accorder un point à l''adversaire pour mieux le détruire ensuite.

| Procédé                   | Mécanisme                                            | Fonction                               |
| ------------------------- | ---------------------------------------------------- | -------------------------------------- |
| **Concession rhétorique** | _certes X… mais Y_ : on admet X pour mieux imposer Y | désamorcer l''objection, paraître juste |
| **Réfutation**            | exposer la thèse adverse puis en montrer la fausseté | détruire l''argument d''en face          |
| **Prétérition**           | _je ne parlerai pas de…_ (et on en parle quand même) | dire en feignant de taire              |

_**Certes**, la réforme a un coût ; **mais** ce coût est dérisoire face aux vies sauvées._ → la concession sert de tremplin à la réfutation.
_**Je ne m''attarderai pas sur** ses échecs passés…_ → prétérition : on évoque ce qu''on prétend passer sous silence.

> ⚠️ Piège : la **concession rhétorique** n''est pas une vraie concession. Celui qui dit _certes… mais…_ ne change pas d''avis : il neutralise l''objection pour renforcer sa propre thèse.

## 🔮 Les procédés de la persuasion et du détour

| Procédé                 | Définition                                             | Effet visé                   |
| ----------------------- | ------------------------------------------------------ | ---------------------------- |
| **Question rhétorique** | fausse question dont la réponse est imposée            | faire adhérer sans démontrer |
| **Ironie / antiphrase** | dire le contraire de ce qu''on pense, ton entendu       | disqualifier en raillant     |
| **Analogie**            | rapprocher deux situations pour éclairer ou convaincre | rendre l''abstrait concret    |
| **Argument d''autorité** | invoquer un expert, un sage, une tradition             | appuyer par le prestige      |

_« **Faut-il vraiment rappeler que** la liberté n''a pas de prix ? »_ → question rhétorique : la réponse (« non, c''est évident ») est imposée.
_« **Quel courage** de fuir au premier danger ! »_ → ironie / antiphrase : on loue pour blâmer.
_« Gouverner un pays, c''est comme **piloter un navire** dans la tempête. »_ → analogie.

> 🗡️ Astuce : l''**antiphrase** est le moteur de l''ironie : le mot dit le contraire du sens visé. Repère le décalage entre l''éloge des mots et le blâme du contexte.

## 🛡️ La modalisation et l''exemple

| Procédé            | Marques typiques                                             | Fonction                       |
| ------------------ | ------------------------------------------------------------ | ------------------------------ |
| **Modalisation**   | _il semblerait, sans doute, peut-être, force est d''admettre_ | nuancer, prendre ses distances |
| **Exemple**        | un cas concret qui **illustre** la thèse                     | rendre l''argument tangible     |
| **Contre-exemple** | un cas unique qui **réfute** une règle générale              | invalider une généralisation   |

_**Il semblerait que** la mesure ait porté ses fruits._ → modalisation : l''auteur n''affirme pas, il atténue.
_Tous les cygnes sont blancs ? Un seul cygne noir suffit : voilà le **contre-exemple**._ → un cas réfute la généralité.

> ⚠️ Piège : ne confonds pas **exemple** et **contre-exemple**. L''exemple **appuie** une thèse ; le contre-exemple **détruit** une affirmation universelle en exhibant une exception.

## 🧪 Argument valable contre sophisme — la grande épreuve du C2

Un **sophisme** est un raisonnement qui **paraît** valide mais qui est logiquement vicié. Le reconnaître est l''arme ultime du débatteur.

| Sophisme                  | Mécanisme du raisonnement vicié                                         |
| ------------------------- | ----------------------------------------------------------------------- |
| **Généralisation hâtive** | conclure une règle générale à partir de trop peu de cas                 |
| **Homme de paille**       | déformer la thèse adverse en une version caricaturale, puis la réfuter  |
| **Faux dilemme**          | réduire à deux options alors qu''il en existe d''autres                   |
| **Pente glissante**       | prétendre qu''un premier pas mène fatalement à une catastrophe           |
| **Ad hominem**            | attaquer la personne au lieu de son argument                            |
| **Pétition de principe**  | poser comme prouvé ce qu''il fallait démontrer (raisonnement circulaire) |

_« Deux étudiants ont triché, **donc** cette génération est malhonnête. »_ → généralisation hâtive.
_« Tu veux réduire le budget militaire ? **Donc** tu veux laisser le pays sans défense ! »_ → homme de paille.
_« **Soit** on coupe tous les arbres, **soit** l''économie s''effondre. »_ → faux dilemme.
_« Si on autorise ce film, bientôt **tout** sera permis et la société s''effondrera. »_ → pente glissante.
_« Son argument est nul : c''est un menteur notoire. »_ → ad hominem.
_« C''est vrai parce que c''est écrit, et c''est écrit parce que c''est vrai. »_ → pétition de principe.

> 🗡️ Astuce du juré : un argument **valable** s''attaque aux **idées** et fonde sa conclusion sur des **preuves suffisantes** ; un sophisme attaque la personne, déforme l''adversaire, ou conclut trop vite. Demande-toi toujours : « la conclusion découle-t-elle vraiment des prémisses ? »

> ⚠️ Piège suprême : un sophisme peut être **rhétoriquement brillant**. Une pente glissante bien tournée ou un ad hominem spirituel peuvent **persuader** sans rien **prouver**. Ne confonds jamais l''efficacité avec la validité.

> 🏆 Quête accomplie ! Tu sais désormais nommer le procédé (concession rhétorique, réfutation, question rhétorique, ironie, prétérition, analogie, argument d''autorité, modalisation, contre-exemple), identifier sa fonction (convaincre, persuader, nuancer, disqualifier), et — arme décisive — démasquer le sophisme sous l''argument. Ton arsenal rhétorique DALF C2 est complet. Au prochain donjon, tu liras les textes les plus exigeants sans qu''aucun procédé ne t''échappe. ⚔️', '# 📜 Résumé : La rhétorique et l''argumentation experte

- **Convaincre vs persuader** : convaincre = par la raison et les preuves ; persuader = par les émotions.
- **Concession rhétorique** : _certes X… mais Y_ — on admet pour mieux réfuter, sans changer d''avis.
- **Réfutation & prétérition** : détruire la thèse adverse ; dire en feignant de taire (_je ne parlerai pas de…_).
- **Question rhétorique** : fausse question dont la réponse est imposée — faire adhérer sans démontrer.
- **Ironie / antiphrase** : dire le contraire de ce qu''on pense pour railler et disqualifier.
- **Analogie & argument d''autorité** : éclairer par une comparaison ; appuyer par le prestige d''un expert.
- **Modalisation** : _il semblerait, sans doute, force est d''admettre_ — nuancer, prendre ses distances.
- **Exemple vs contre-exemple** : l''exemple appuie une thèse ; le contre-exemple réfute une généralité.
- **Sophismes** : généralisation hâtive, homme de paille, faux dilemme, pente glissante, ad hominem, pétition de principe — un raisonnement qui paraît valide mais reste vicié.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', 'francais-c2', 'Vocabulaire C2 : mots savants et précision lexicale', 'Atteins la maîtrise du lexique cultivé : le sens exact des mots savants et soutenus (idoine, prégnant, abscons, laconique, velléitaire, palinodie, déliquescence, sérendipité…), les nuances d''intensité et de connotation au sein d''une même famille (économe / avare / pingre), le mot précis qui correspond à une définition donnée, et les grands champs abstraits vulgarisés (éthique, ontologie, épistémologie, téléologie). Niveau maîtrise (CECRL C2 / DALF C2).', '# 🔮 Mots savants et précision lexicale — L''arsenal du lettré

> 💡 «Au sommet du français, on ne dit pas “obscur” : on dit _abscons_, _sibyllin_ ou _hermétique_, et chacun vise une cible différente. Le mot savant n''est pas un ornement — c''est une lame de précision.»

## 🏰 Pourquoi ce chapitre

Tu maîtrises la grammaire, la stylistique et les paronymes. Il te reste à conquérir le **lexique savant** : ces mots rares mais exacts que le registre lettré exige, ceux dont un seul désigne ce qu''une périphrase peinerait à dire. À ce niveau, employer _idoine_ au lieu d''« approprié », _prégnant_ au lieu de « marquant », n''est pas de la préciosité : c''est viser juste. Mais gare — un mot savant mal placé sonne plus faux qu''un mot simple. Voici comment armer ton vocabulaire.

## ⚡ Les mots savants et leur sens exact

Apprends d''abord à reconnaître ce que chacun désigne précisément.

| Mot savant       | Sens exact                                                        |
| ---------------- | ----------------------------------------------------------------- |
| **idoine**       | parfaitement approprié, qui convient exactement                   |
| **prégnant**     | qui s''impose à l''esprit, marquant, qui laisse une empreinte forte |
| **obvie**        | évident, qui se présente immédiatement à l''esprit                 |
| **abscons**      | obscur, difficile à comprendre (souvent par excès d''abstraction)  |
| **sibyllin**     | énigmatique, au sens volontairement caché, oraculaire             |
| **laconique**    | qui s''exprime en très peu de mots, concis jusqu''à la sécheresse   |
| **prolixe**      | trop long, bavard, qui se répand en paroles                       |
| **velléitaire**  | qui forme des intentions sans jamais les mener à terme            |
| **pusillanime**  | qui manque de courage, craintif, sans audace                      |
| **atrabilaire**  | d''humeur sombre, chagrine et irritable                            |
| **thuriféraire** | flatteur servile, qui encense quelqu''un avec excès                |

> 🗡️ Astuce : _laconique_ vient des Laconiens (Spartiates), réputés pour leurs réponses brèves et tranchantes. Réserve-le à une concision presque coupante, jamais à une simple brièveté banale.

## 🛡️ Le lexique de l''abstrait et du jugement

| Mot savant        | Sens exact                                                          |
| ----------------- | ------------------------------------------------------------------- |
| **palinodie**     | revirement complet d''opinion, rétractation de ce qu''on affirmait    |
| **incurie**       | négligence grave, manque total de soin                              |
| **déliquescence** | décadence, décomposition progressive (d''une institution, d''un État) |
| **exégèse**       | interprétation détaillée et critique d''un texte                     |
| **herméneutique** | théorie ou art de l''interprétation des textes                       |
| **sérendipité**   | fait de découvrir par hasard ce qu''on ne cherchait pas              |
| **dichotomie**    | division nette en deux parties opposées                             |
| **paradigme**     | modèle de pensée, cadre de référence dominant                       |
| **protéiforme**   | qui change sans cesse de forme, aux aspects multiples               |

> ⚠️ Piège : ne confonds pas _exégèse_ (le commentaire d''un texte précis) et _herméneutique_ (la science générale de l''interprétation). On fait l''**exégèse** d''un poème ; on étudie l''**herméneutique** comme discipline.

## 🔮 Nuances d''intensité et de connotation

Au sein d''une même famille de sens, les mots se rangent du **mélioratif** (valorisant) au **péjoratif** (dévalorisant). Choisir le mauvais cran, c''est dire autre chose que ce qu''on pense.

| Idée commune     | Mélioratif / neutre     | Péjoratif                          |
| ---------------- | ----------------------- | ---------------------------------- |
| gérer son argent | **économe** (vertu)     | **avare**, **pingre** (vice)       |
| tenir bon        | **ferme**, **constant** | **obstiné**, **buté** (entêtement) |
| vouloir réussir  | **ambitieux** (neutre)  | **arriviste** (sans scrupules)     |
| parler peu       | **réservé**, **sobre**  | **taciturne**, **renfrogné**       |
| croire fort      | **convaincu**           | **fanatique**, **sectaire**        |

> 🗡️ Astuce : _économe_ loue une qualité ; _avare_ blâme un défaut ; _pingre_ ajoute le mépris. « Il est économe » est un compliment ; « il est pingre » est une insulte. Même sens dénoté, connotation inversée.

## 🧪 Les grands champs abstraits, rendus clairs

Le français cultivé manie quatre disciplines philosophiques dont voici le sens accessible.

| Domaine             | Question qu''il pose                                              |
| ------------------- | ---------------------------------------------------------------- |
| **l''éthique**       | Que doit-on faire ? Étude du bien, du mal et de l''action juste   |
| **l''ontologie**     | Qu''est-ce qui existe ? Étude de l''être en tant qu''être           |
| **l''épistémologie** | Comment savons-nous ? Étude de la connaissance et de sa validité |
| **la téléologie**   | Vers quelle fin ? Étude des buts, du sens et de la finalité      |

> ⚠️ Piège : ne prends pas l''_éthique_ (ce qu''on doit faire) pour l''_épistémologie_ (comment on connaît). L''une juge l''action, l''autre juge le savoir.

## 🧮 Verbes savants utiles

| Verbe          | Sens exact                                                         |
| -------------- | ------------------------------------------------------------------ |
| **subsumer**   | ranger un cas particulier sous une notion plus générale            |
| **réifier**    | transformer une idée abstraite en chose, la traiter comme un objet |
| **obvier (à)** | parer à, prévenir un inconvénient                                  |

> 🏆 Porte franchie ! Tu sais désormais distinguer l''_abscons_ du _sibyllin_, l''_économe_ du _pingre_, l''_éthique_ de l''_ontologie_. Le mot savant n''est plus un risque mais une arme : tu vises juste, et chaque terme touche exactement sa cible.', '# 📜 Résumé : Mots savants et précision lexicale

- **Mots savants exacts** : _idoine_ = parfaitement approprié ; _prégnant_ = marquant ; _abscons_ = obscur ; _sibyllin_ = énigmatique ; _laconique_ = très concis ; _prolixe_ = trop bavard ; _velléitaire_ = sans constance.
- **Caractère et humeur** : _pusillanime_ = craintif ; _atrabilaire_ = sombre et irritable ; _thuriféraire_ = flatteur servile.
- **Lexique de l''abstrait** : _palinodie_ = revirement d''opinion ; _incurie_ = négligence ; _déliquescence_ = décadence ; _sérendipité_ = découverte fortuite ; _paradigme_ = modèle de pensée ; _protéiforme_ = aux formes changeantes.
- **Interprétation** : _exégèse_ = commentaire d''un texte précis ; _herméneutique_ = science de l''interprétation.
- **Connotation** : du mélioratif au péjoratif — _économe_ (qualité) / _avare_ / _pingre_ (vice) ; _ferme_ / _obstiné_ / _buté_ ; _ambitieux_ / _arriviste_.
- **Champs abstraits** : _éthique_ = le bien et l''action juste ; _ontologie_ = l''être ; _épistémologie_ = la connaissance ; _téléologie_ = la finalité.
- **Verbes savants** : _subsumer_ = ranger sous une notion générale ; _réifier_ = traiter une idée comme une chose.
- **Règle d''or C2** : le mot savant n''est juste que s''il vise exactement sa cible ; mal placé, il sonne plus faux qu''un mot simple.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('950643fe-bef4-5a10-b618-6930438b4dbe', 'francais-c2', 'Compréhension écrite : maîtriser l''implicite, l''ironie et l''argumentation experte', 'Niveau maîtrise (C2 / DALF C2) : lire des textes denses et exigeants — prose littéraire, essai philosophique, critique savante, texte idéologique — pour en saisir les présupposés les plus subtils, la polyphonie énonciative, l''ironie et la distance critique, la valeur stylistique d''un procédé, et pour évaluer la cohérence comme les failles d''un raisonnement complexe.', '# 🗝️ Compréhension écrite : le sanctuaire des textes maîtres — lire ce que le texte ne dit pas

> 💡 «Au niveau maîtrise, un grand texte ne se lit pas, il se déchiffre. Sous chaque phrase dort une intention ; derrière chaque éloge, parfois, une dague. Le héros-lecteur du dernier palier ne cherche plus le sens : il reconstruit une conscience à l''œuvre.»

## 🏰 Le pacte du lecteur de maîtrise

Au C1, tu démasquais l''implicite et l''ironie. Au **C2**, la marche est plus haute : le texte joue sur **plusieurs voix simultanées**, l''auteur peut **feindre** d''adhérer à ce qu''il combat, le sens véritable naît d''un **décalage** entre ce qui est dit et ce qui est montré. Ta mission n''est plus de comprendre une thèse, mais de **situer une position** dans le jeu des points de vue. L''inférence reste un **raisonnement contrôlé** : chaque interprétation doit pouvoir pointer l''indice textuel qui la fonde — jamais ton goût, jamais ta morale.

> 🗡️ Astuce du maître : avant de répondre, isole quatre paramètres — **Qui énonce ? À travers quelle voix ? Sur quel registre ? Pour quelle visée pragmatique ?** Une réponse C2 se justifie par le texte et résiste à la sur-interprétation.

## ⚡ La polyphonie : démêler les voix d''un même énoncé

Un énoncé peut porter **plusieurs énonciateurs** sans guillemets ni verbe introducteur (théorie de la polyphonie, Ducrot). L''auteur **convoque** une voix pour s''en distancier.

| Marque dans le texte                        | Voix réellement responsable                              |
| ------------------------------------------- | -------------------------------------------------------- |
| _Bien sûr, le progrès nous rendra heureux._ | un **« on » convenu** que l''auteur va railler            |
| _La réforme, paraît-il, a tout réglé._      | une voix rapportée dont l''auteur **se désolidarise**     |
| _Qu''on se rassure : rien n''a changé._       | ironie — la formule rassurante dit l''inverse de son sens |

> ⚠️ Piège : ne jamais imputer à l''auteur une opinion qu''il **met en scène pour la réfuter**. La voix la plus visible n''est presque jamais la sienne.

## 🛡️ L''ironie experte et l''antiphrase soutenue

L''ironie de maîtrise est **filée** : elle se déploie sur tout un paragraphe par fausse déférence, hyperbole de l''éloge, ou solennité appliquée à du dérisoire. Le signal n''est pas un mot mais un **écart** entre le registre noble et l''objet trivial, ou entre la louange et les faits cités.

- **Antiphrase louangeuse** : _nos dirigeants, dans leur clairvoyance coutumière…_ (suivi d''un échec).
- **Litote** : _l''entreprise ne fut pas un franc succès_ → ce fut un désastre.
- **Faux concédé** : _admettons que tout aille pour le mieux…_ → préparation d''une réfutation cinglante.

## 🔮 Modalisation, réserve et portée d''une nuance

La **modalisation** révèle le degré d''engagement ; au C2, tout se joue dans la **nuance** et la **réserve**.

- Le **conditionnel d''information non assumée** : _la mesure aurait creusé les écarts_ = donnée que l''auteur **n''endosse pas**.
- La **concession restrictive** : _sans doute X, mais…_ → le « mais » porte la vraie thèse ; la concession n''est qu''un appui.
- La **réserve discrète** (_du moins en apparence_, _si l''on veut_) **fissure** une affirmation : elle annonce un retournement.

> 🗡️ Astuce : une réserve glissée en incise n''est pas un détail décoratif — c''est souvent le point d''appui de tout le raisonnement.

## 🧱 La valeur stylistique d''un procédé : le style fait sens

Au C2, un procédé n''est jamais gratuit : il **produit un effet de sens**. Sache nommer l''effet, pas seulement la figure.

| Procédé                                 | Effet de sens                                              |
| --------------------------------------- | ---------------------------------------------------------- |
| **rythme ternaire / accumulation**      | impression d''évidence écrasante, ou de saturation ironique |
| **asyndète** (juxtaposition sans liant) | brutalité, urgence, ou inventaire désabusé                 |
| **métaphore filée**                     | impose une grille de lecture (la cité = un corps malade)   |
| **rupture de registre**                 | dévalorise par contraste, signale l''ironie                 |

## 🧮 Évaluer un raisonnement : repérer ses failles

Lire en maître, c''est aussi **juger la validité** d''une argumentation et débusquer ses sophismes.

| Faille                    | Signe dans le texte                                                 |
| ------------------------- | ------------------------------------------------------------------- |
| **fausse alternative**    | _ou bien…, ou bien…_ qui escamote une troisième voie                |
| **pente glissante**       | enchaînement de conséquences non prouvées (_dès lors, fatalement…_) |
| **pétition de principe**  | la conclusion est déjà glissée dans la prémisse                     |
| **généralisation hâtive** | un cas érigé en loi (_il suffit d''un exemple pour…_)                |

### 🧪 Exemple intégralement résolu (niveau Boss)

> « Nul n''ignore plus, désormais, les bienfaits de la concurrence : elle aiguise l''esprit, abaisse les prix, récompense le mérite. Il serait donc absurde — n''est-ce pas ? — de vouloir en soustraire l''école, l''hôpital, la justice, ces derniers refuges où l''on s''obstine encore à croire que tout ne se vaut pas. »

1. **Qui énonce ?** « Nul n''ignore plus » convoque un **consensus présenté comme évident** — une voix collective, non l''auteur.
2. **Quelle voix, quel ton ?** Le « n''est-ce pas ? » faussement complice et la chute (« ces derniers refuges où l''on s''obstine **encore** à croire ») trahissent l''**ironie** : l''auteur singe l''évidence libérale pour la retourner.
3. **Quelle faille mise au jour ?** Le passage repose sur une **généralisation** (« les bienfaits de la concurrence ») étendue **abusivement** à l''école, l''hôpital, la justice — domaines où « tout ne se vaut pas ».
4. **Visée réelle ?** Thèse **implicite** : certains biens échappent par nature à la logique marchande. ✓
5. **Le piège** : prendre l''éloge initial pour la position de l''auteur. La bonne lecture **inverse** la voix mise en scène.

> 🏆 Sanctuaire franchi ! Tu sais désormais démêler les voix, démasquer l''ironie filée, peser une nuance et juger un raisonnement. Au dernier palier, le texte n''a plus de secret pour toi — il n''a que des indices. Prochaine épreuve : les arènes d''entraînement. ⚔️', '# 📜 Résumé : maîtriser l''implicite, l''ironie et l''argumentation experte

- **Pacte du lecteur de maîtrise** : situer une position dans le jeu des voix ; toute inférence se justifie par un indice du texte, jamais par ton opinion.
- **Polyphonie** : un énoncé peut porter plusieurs énonciateurs ; l''auteur convoque une voix pour s''en distancier — ne lui impute pas l''opinion qu''il met en scène pour la réfuter.
- **Ironie experte** : antiphrase louangeuse, litote, faux concédé ; le signal est l''écart entre le registre et l''objet, ou entre la louange et les faits.
- **Modalisation et nuance** : le conditionnel marque une donnée non assumée ; après « sans doute… mais », la vraie thèse suit le « mais » ; une réserve en incise annonce souvent un retournement.
- **Valeur stylistique** : nomme l''effet de sens d''un procédé (rythme ternaire, asyndète, métaphore filée, rupture de registre), pas seulement la figure.
- **Failles d''un raisonnement** : repère fausse alternative, pente glissante, pétition de principe, généralisation hâtive.
- **Réflexe C2** : Qui énonce ? À travers quelle voix ? Sur quel registre ? Pour quelle visée ? Méfie-toi de la lecture littérale d''un sens figuré ou ironique.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', '29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('9ad5d427-2cfd-5d15-9b01-dece8d749eb3', '08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', 'Quel est le passé simple de « parler » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il parlait"},{"id":"b","text":"il parla"},{"id":"c","text":"il parlât"},{"id":"d","text":"il a parlé"}]'::jsonb, 'b', 'Le passé simple des verbes du 1ᵉ groupe se forme en -a à la 3ᵉ personne du singulier : « il parla », sans accent. « il parlait » est l''imparfait, « il parlât » le subjonctif imparfait, « il a parlé » le passé composé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('958487c0-7807-5faf-bf3a-efd74b7c7555', '08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', 'Dans un récit, quel temps emploie-t-on pour une action ponctuelle de premier plan ?', '[{"id":"a","text":"l''imparfait"},{"id":"b","text":"le plus-que-parfait"},{"id":"c","text":"le passé simple"},{"id":"d","text":"le subjonctif présent"}]'::jsonb, 'c', 'Le passé simple est le temps des actions ponctuelles et achevées de premier plan dans le récit écrit. L''imparfait sert au décor et à la description (arrière-plan), tandis que le subjonctif présent n''est pas un temps du récit indicatif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edb43c66-96ed-5fbe-9e3d-5acb030510e2', '08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', 'Complétez : « Quand il ___ son discours, il quitta la salle. » (antériorité immédiate)', '[{"id":"a","text":"eut terminé"},{"id":"b","text":"avait terminé"},{"id":"c","text":"termina"},{"id":"d","text":"terminait"}]'::jsonb, 'a', 'Le passé antérieur (auxiliaire au passé simple + participe : « eut terminé ») marque l''antériorité immédiate devant un passé simple (« quitta »). « avait terminé » est un plus-que-parfait, qui s''accorde avec un imparfait, pas avec un passé simple.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6e4e86f-079d-506e-a59f-2f97e4a6ee4c', '08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', 'Laquelle de ces formes est un subjonctif imparfait (et non un passé simple) ?', '[{"id":"a","text":"il vint"},{"id":"b","text":"il fut"},{"id":"c","text":"il eut"},{"id":"d","text":"qu''il fût"}]'::jsonb, 'd', '« qu''il fût » est le subjonctif imparfait de « être » : l''accent circonflexe et l''emploi en subordonnée le signalent. « il vint », « il fut », « il eut » sont des passés simples (indicatif), sans accent circonflexe.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ee22325-73a6-571c-bfda-5620d62ed52c', '08c0d28a-fdfa-5386-9f2a-f5ed2b04d42c', 'Quel temps est « qu''il eût parlé » ?', '[{"id":"a","text":"le passé antérieur de l''indicatif"},{"id":"b","text":"le plus-que-parfait du subjonctif"},{"id":"c","text":"le plus-que-parfait de l''indicatif"},{"id":"d","text":"le subjonctif imparfait"}]'::jsonb, 'b', '« qu''il eût parlé » est le plus-que-parfait du subjonctif : auxiliaire au subjonctif imparfait (« eût ») + participe passé. Sans circonflexe, « il eut parlé » serait le passé antérieur de l''indicatif ; « qu''il parlât » serait le subjonctif imparfait simple.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('11783ea1-5320-5bf4-9eb3-48160306961c', '29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'francais-c2', '⭐ Entraînement : les temps littéraires', 1, 50, 10, 'practice', 'admin', 1)
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
  ('cb18bb59-3ee1-5345-abf0-b6bcdbe8469f', '11783ea1-5320-5bf4-9eb3-48160306961c', 'Quel est le passé simple de « finir » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il finissait"},{"id":"b","text":"il finira"},{"id":"c","text":"il finit"},{"id":"d","text":"il a fini"}]'::jsonb, 'c', 'Les verbes du 2ᵉ groupe font leur passé simple en -it à la 3ᵉ personne du singulier : « il finit ». « il finissait » est l''imparfait, « il finira » le futur et « il a fini » le passé composé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8d57e7e-da62-5683-bbab-cd2a096223d9', '11783ea1-5320-5bf4-9eb3-48160306961c', 'Complétez le récit : « Le chevalier ___ son épée et s''élança. »', '[{"id":"a","text":"tira"},{"id":"b","text":"tirait"},{"id":"c","text":"tirera"},{"id":"d","text":"tirât"}]'::jsonb, 'a', 'Le récit enchaîne des actions ponctuelles au passé simple : « tira » (1ᵉ groupe, finale -a sans accent). « tirait » serait une description à l''imparfait, et « tirât » est un subjonctif imparfait qui ne convient pas dans une principale.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('644957e1-6d81-5217-8ee8-8ffe8d28a294', '11783ea1-5320-5bf4-9eb3-48160306961c', 'Quel est le passé simple de « être » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il était"},{"id":"b","text":"il fut"},{"id":"c","text":"il fût"},{"id":"d","text":"il a été"}]'::jsonb, 'b', 'Le passé simple de « être » est « il fut », sans accent circonflexe. « il était » est l''imparfait, « il fût » le subjonctif imparfait (avec circonflexe), et « il a été » le passé composé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34b406d0-988c-5d96-a8bc-cef7855ff121', '11783ea1-5320-5bf4-9eb3-48160306961c', 'Dans « La forêt ___ sombre quand l''enfant ___ », quels temps conviennent ?', '[{"id":"a","text":"fut … entrait"},{"id":"b","text":"était … entrait"},{"id":"c","text":"fut … entra"},{"id":"d","text":"était … entra"}]'::jsonb, 'd', 'La description du décor se met à l''imparfait (« était sombre », arrière-plan) et l''action ponctuelle au passé simple (« entra », premier plan). « était … entra » respecte cette répartition ; les autres combinaisons mélangent les rôles.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ac1ffcd-4247-55aa-9fd6-b199090ea1ed', '11783ea1-5320-5bf4-9eb3-48160306961c', 'Complétez : « Quand il ___ tout rangé, il s''assit enfin. »', '[{"id":"a","text":"avait"},{"id":"b","text":"a"},{"id":"c","text":"eut"},{"id":"d","text":"eût"}]'::jsonb, 'c', 'Devant le passé simple « s''assit », l''antériorité immédiate se rend par le passé antérieur : « eut rangé » (auxiliaire « avoir » au passé simple). « avait » donnerait un plus-que-parfait, et « eût » (circonflexe) serait un subjonctif imparfait.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4983077-3ad1-5ad5-ac19-033557bdfa57', '11783ea1-5320-5bf4-9eb3-48160306961c', 'Quel est le passé simple de « parler » à la 3ᵉ personne du pluriel ?', '[{"id":"a","text":"ils parlèrent"},{"id":"b","text":"ils parlaient"},{"id":"c","text":"ils parleront"},{"id":"d","text":"ils parlassent"}]'::jsonb, 'a', 'Au pluriel, le passé simple du 1ᵉ groupe se forme en -èrent : « ils parlèrent ». « ils parlaient » est l''imparfait, « ils parleront » le futur, et « ils parlassent » le subjonctif imparfait pluriel.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', '29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'francais-c2', '⭐⭐ Révision : les temps littéraires', 2, 75, 15, 'practice', 'admin', 2)
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
  ('008c7253-83a6-5f32-aaac-b1324bb6c231', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', 'Quel est le passé simple de « venir » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il venait"},{"id":"b","text":"il viendra"},{"id":"c","text":"il vînt"},{"id":"d","text":"il vint"}]'::jsonb, 'd', 'Le passé simple de « venir » est « il vint », sans accent. « il vînt » (avec circonflexe) est le subjonctif imparfait ; « il venait » est l''imparfait et « il viendra » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11950394-b49a-5810-ba69-933ffd1ae26c', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', 'Complétez : « Il ___ la lettre, la ___, puis la jeta au feu. »', '[{"id":"a","text":"lisait … relisait"},{"id":"b","text":"lut … relut"},{"id":"c","text":"lira … relira"},{"id":"d","text":"lût … relût"}]'::jsonb, 'b', 'La suite d''actions ponctuelles du récit appelle le passé simple : « lut … relut » (verbe « lire »). L''imparfait « lisait … relisait » exprimerait la durée, et « lût … relût » sont des subjonctifs imparfaits hors contexte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0dcda9c6-acef-55bc-8f40-49cd9557f90f', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', 'Complétez en registre soutenu : « Le roi voulut qu''on ___ les portes. »', '[{"id":"a","text":"fermât"},{"id":"b","text":"ferma"},{"id":"c","text":"fermerait"},{"id":"d","text":"fermait"}]'::jsonb, 'a', 'Après une principale au passé (« voulut »), la concordance littéraire impose le subjonctif imparfait : « fermât » (accent circonflexe). « ferma » est un passé simple de l''indicatif, qui n''a pas sa place après « vouloir que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a861e56-19b1-51b4-ad7a-b07fed62770d', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Il prit la route dès l''aube."},{"id":"b","text":"Elle fit ses adieux et partit."},{"id":"c","text":"Le messager vînt annoncer la nouvelle."},{"id":"d","text":"Ils durent rebrousser chemin."}]'::jsonb, 'c', 'La forme correcte dans une principale est le passé simple « vint » (sans circonflexe) : « Le messager vint annoncer la nouvelle. » « vînt » est un subjonctif imparfait, réservé à une subordonnée. Les phrases (a), (b) et (d) emploient correctement « prit », « fit/partit » et « durent ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7b8d14c-04a8-5a7f-9cb0-606ceef3b21e', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', 'Quel est le passé simple de « faire » à la 3ᵉ personne du pluriel ?', '[{"id":"a","text":"ils faisaient"},{"id":"b","text":"ils feront"},{"id":"c","text":"ils fissent"},{"id":"d","text":"ils firent"}]'::jsonb, 'd', 'Le passé simple de « faire » au pluriel est « ils firent ». « ils fissent » est le subjonctif imparfait, « ils faisaient » l''imparfait et « ils feront » le futur.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3f639cb-8c0f-5d66-8570-ab53be114ff9', 'a3a679ca-62a2-5ed0-a9c7-0a7f3c687f2d', 'Complétez : « Dès qu''elle ___ partie, le silence retomba. »', '[{"id":"a","text":"était"},{"id":"b","text":"fut"},{"id":"c","text":"fût"},{"id":"d","text":"a été"}]'::jsonb, 'b', 'Le passé antérieur des verbes avec « être » se forme avec l''auxiliaire au passé simple : « fut partie », en corrélation avec le passé simple « retomba ». « était partie » serait un plus-que-parfait, et « fût » (circonflexe) un subjonctif imparfait.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2e7ee818-ad9f-5a12-b660-bf13fd03bacb', '29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : les temps littéraires', 3, 120, 30, 'boss', 'admin', 3)
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
  ('25b97cf3-f0b7-5acf-9d2c-b328918cfede', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'Complétez ce récit : « La tempête ___ depuis des heures lorsque le navire ___ contre les récifs. »', '[{"id":"a","text":"faisait rage … se brisa"},{"id":"b","text":"fit rage … se brisait"},{"id":"c","text":"fit rage … se brisa"},{"id":"d","text":"faisait rage … se brisait"}]'::jsonb, 'a', 'Le décor durable se met à l''imparfait (« faisait rage », arrière-plan) et l''événement ponctuel au passé simple (« se brisa », premier plan). Le piège courant est de tout mettre au même temps : « faisait rage … se brisa » oppose correctement durée et action.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c809f06d-52a0-5925-bfab-32fd5753d7df', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'Trouvez la phrase où le passé antérieur est correctement employé.', '[{"id":"a","text":"Quand il avait fini, il se leva."},{"id":"b","text":"Quand il eût fini, il se leva."},{"id":"c","text":"Quand il eut fini, il se leva."},{"id":"d","text":"Quand il a eu fini, il se leva."}]'::jsonb, 'c', 'Le passé antérieur « eut fini » (auxiliaire au passé simple, sans circonflexe) accompagne le passé simple « se leva ». « avait fini » est un plus-que-parfait ; « eût fini » (circonflexe) serait un plus-que-parfait du subjonctif ; « a eu fini » est un passé surcomposé, hors récit littéraire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b8e09ce-43aa-5cc5-8597-94b1ec1906fb', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'Complétez en registre littéraire : « Il était nécessaire qu''il ___ présent à la cérémonie. »', '[{"id":"a","text":"fut"},{"id":"b","text":"soit"},{"id":"c","text":"serait"},{"id":"d","text":"fût"}]'::jsonb, 'd', 'Après « il était nécessaire que » (principale au passé), la concordance soutenue donne le subjonctif imparfait « fût » (accent circonflexe). Le piège est « fut » sans accent, qui est le passé simple de l''indicatif ; « soit » serait le subjonctif présent du registre courant.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62243554-dead-51dc-8ae8-41dd8ec4d24a', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'Quelle forme est le plus-que-parfait du subjonctif de « venir » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"qu''il fut venu"},{"id":"b","text":"qu''il fût venu"},{"id":"c","text":"qu''il était venu"},{"id":"d","text":"qu''il vînt"}]'::jsonb, 'b', 'Le plus-que-parfait du subjonctif se forme avec l''auxiliaire au subjonctif imparfait + participe : « qu''il fût venu » (« être » au subjonctif imparfait). « qu''il vînt » est le subjonctif imparfait simple ; « qu''il était venu » est un plus-que-parfait de l''indicatif ; « qu''il fut venu » sans circonflexe serait un passé antérieur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1dc208b-0da3-5c29-a2c4-bb8e642b35b5', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Il fallait qu''elle partît avant la nuit."},{"id":"b","text":"Le héros eut peur, mais il avança."},{"id":"c","text":"Je craignais qu''il ne vint trop tard."},{"id":"d","text":"Dès qu''il eut compris, il se tut."}]'::jsonb, 'c', 'Après « je craignais que », la concordance littéraire exige le subjonctif imparfait « vînt » avec accent circonflexe : « qu''il ne vînt trop tard ». « vint » sans circonflexe est le passé simple de l''indicatif, incorrect ici. Les phrases (a), (b) et (d) sont justes (« partît » subjonctif, « eut » passé simple, « eut compris » passé antérieur).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d4e9299-29fa-559c-9711-7d5b6439a01c', '2e7ee818-ad9f-5a12-b660-bf13fd03bacb', 'Complétez : « À peine ___ ces mots qu''un murmure parcourut l''assemblée. »', '[{"id":"a","text":"avait-il prononcé"},{"id":"b","text":"eut-il prononcé"},{"id":"c","text":"eût-il prononcé"},{"id":"d","text":"prononçait-il"}]'::jsonb, 'b', '« À peine… que » introduit une antériorité immédiate devant un passé simple (« parcourut ») : on emploie le passé antérieur « eut-il prononcé ». « avait-il prononcé » est un plus-que-parfait ; « eût-il prononcé » (circonflexe) serait un subjonctif ou un conditionnel passé, inadapté ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', '29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : les temps littéraires', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('5ff00957-2bee-5f75-8379-16ba0076ea8a', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', 'Identifiez précisément le temps de « qu''il eût parlé ».', '[{"id":"a","text":"passé antérieur de l''indicatif"},{"id":"b","text":"plus-que-parfait du subjonctif"},{"id":"c","text":"subjonctif imparfait"},{"id":"d","text":"plus-que-parfait de l''indicatif"}]'::jsonb, 'b', '« qu''il eût parlé » associe l''auxiliaire au subjonctif imparfait (« eût ») et le participe : c''est le plus-que-parfait du subjonctif. Le piège est « il eut parlé » sans circonflexe (passé antérieur de l''indicatif) ; « qu''il parlât » serait le subjonctif imparfait simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('836a62ce-4262-5c27-b076-a3e902854cfb', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', 'Complétez en concordance soutenue : « Bien qu''il ___ tout perdu, il ne se plaignit jamais. »', '[{"id":"a","text":"avait"},{"id":"b","text":"eut"},{"id":"c","text":"ait"},{"id":"d","text":"eût"}]'::jsonb, 'd', '« Bien que » exige le subjonctif ; après le passé simple « se plaignit », la concordance littéraire donne le plus-que-parfait du subjonctif : « eût tout perdu » (auxiliaire « avoir » au subjonctif imparfait, avec circonflexe). « eut » sans accent serait un passé antérieur de l''indicatif, et « ait » le subjonctif passé du registre courant.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c190a717-9be0-5104-a06d-7cf92f9c600f', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', 'Trouvez la phrase parfaitement correcte en registre littéraire.', '[{"id":"a","text":"Il attendit qu''elle eût fini de parler pour répondre."},{"id":"b","text":"Il attendit qu''elle eut fini de parler pour répondre."},{"id":"c","text":"Il attendit qu''elle avait fini de parler pour répondre."},{"id":"d","text":"Il attendit qu''elle a fini de parler pour répondre."}]'::jsonb, 'a', 'Après « attendre que » (subjonctif) avec une principale au passé simple (« attendit »), la concordance soutenue donne le plus-que-parfait du subjonctif : « qu''elle eût fini » (circonflexe). « eut fini » sans accent serait un passé antérieur de l''indicatif, et « avait/a fini » des indicatifs que « attendre que » n''admet pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cc5cb28-ce88-5341-9a8b-8fb6e79898f0', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', 'Complétez le récit historique : « Lorsque l''armée ___ le fleuve, le général ___ l''assaut. »', '[{"id":"a","text":"avait franchi … donna"},{"id":"b","text":"franchissait … donna"},{"id":"c","text":"eut franchi … donna"},{"id":"d","text":"eut franchi … donnait"}]'::jsonb, 'c', 'L''antériorité immédiate devant le passé simple « donna » se rend par le passé antérieur « eut franchi » (auxiliaire au passé simple). « avait franchi » est un plus-que-parfait qui appelle un imparfait ; « franchissait … donna » brouille l''antériorité ; « donnait » casserait le premier plan de l''action.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d141660-3bc8-5b94-bbe8-d15429c380ce', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Il eût aimé qu''elle restât davantage."},{"id":"b","text":"Quand il eut dîné, il sortit fumer."},{"id":"c","text":"Elle fut surprise, mais elle se tut."},{"id":"d","text":"Il fallait qu''il prit une décision sur-le-champ."}]'::jsonb, 'd', 'L''erreur est en (d) : après « il fallait que », la concordance soutenue exige le subjonctif imparfait « prît » avec accent circonflexe, et non le passé simple « prit » de l''indicatif. Les phrases (a) « eût aimé / restât », (b) « eut dîné » (passé antérieur) et (c) « fut surprise / se tut » (passés simples) sont toutes correctes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('127ef9df-0050-57d2-9ef0-98dfae0e56d8', 'aa2885ba-fe8c-522d-9bb6-1f63fd5928c3', 'Identifiez la forme qui n''est PAS un passé simple.', '[{"id":"a","text":"il dut"},{"id":"b","text":"il fût"},{"id":"c","text":"il put"},{"id":"d","text":"il vit"}]'::jsonb, 'b', '« il fût » (accent circonflexe) est le subjonctif imparfait de « être », et non un passé simple. « il dut » (devoir), « il put » (pouvoir) et « il vit » (voir) sont tous des passés simples de l''indicatif, sans accent circonflexe.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('490f3002-d2a8-5368-9b4e-179b25be49ec', '29dc74ac-e766-5ef0-b36f-f6b3c2c9b83e', 'francais-c2', '⭐⭐ Drill : les temps littéraires', 2, 75, 15, 'practice', 'admin', 5)
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
  ('f52d0bee-0de9-51c7-9b65-1a5ee86dc20a', '490f3002-d2a8-5368-9b4e-179b25be49ec', 'Quel est le passé simple de « prendre » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il prit"},{"id":"b","text":"il prenait"},{"id":"c","text":"il prît"},{"id":"d","text":"il prendra"}]'::jsonb, 'a', 'Le passé simple de « prendre » est « il prit », sans accent. « il prît » (circonflexe) est le subjonctif imparfait, « il prenait » l''imparfait et « il prendra » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77e1697a-404e-5467-9f67-b8b3e62e5a95', '490f3002-d2a8-5368-9b4e-179b25be49ec', 'Complétez le récit : « Le vieil homme se ___, ___ un instant, puis reprit sa marche. »', '[{"id":"a","text":"leva … hésita"},{"id":"b","text":"levait … hésitait"},{"id":"c","text":"lèvera … hésitera"},{"id":"d","text":"levât … hésitât"}]'::jsonb, 'a', 'La succession d''actions du récit se met au passé simple : « se leva … hésita », au même titre que « reprit ». L''imparfait « levait … hésitait » marquerait la durée, et « levât … hésitât » sont des subjonctifs imparfaits hors subordonnée.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d362fc5-5419-56d2-974d-7e24e9e065d4', '490f3002-d2a8-5368-9b4e-179b25be49ec', 'Quelle forme est le passé antérieur de « partir » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il fut parti"},{"id":"b","text":"il était parti"},{"id":"c","text":"il fût parti"},{"id":"d","text":"il partit"}]'::jsonb, 'a', 'Le passé antérieur se forme avec l''auxiliaire au passé simple : « il fut parti » (« être » → « fut »), sans circonflexe. « il était parti » est un plus-que-parfait ; « il fût parti » (circonflexe) un plus-que-parfait du subjonctif ; « il partit » un passé simple simple.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a20483d-e886-501b-8715-36de5c054109', '490f3002-d2a8-5368-9b4e-179b25be49ec', 'Identifiez la forme qui est un subjonctif imparfait (et non un passé simple).', '[{"id":"a","text":"il eut"},{"id":"b","text":"il fit"},{"id":"c","text":"qu''il allât"},{"id":"d","text":"il dut"}]'::jsonb, 'c', '« qu''il allât » est le subjonctif imparfait d''« aller » : accent circonflexe et emploi en subordonnée. « il eut », « il fit » et « il dut » sont des passés simples de l''indicatif, sans accent circonflexe.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('824e15f2-a726-5ffd-84fb-35f8798a84c1', '490f3002-d2a8-5368-9b4e-179b25be49ec', 'Complétez en registre soutenu : « Elle redoutait qu''on ne la ___ démasquée. »', '[{"id":"a","text":"ait"},{"id":"b","text":"eût"},{"id":"c","text":"eut"},{"id":"d","text":"avait"}]'::jsonb, 'b', 'Après « redoutait que » (passé), la concordance littéraire donne le plus-que-parfait du subjonctif : « eût démasquée » (auxiliaire « avoir » au subjonctif imparfait, avec circonflexe). « eut » sans accent serait un passé antérieur de l''indicatif, et « ait » le subjonctif passé courant.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5c17e74-643d-51ca-a81b-223fcb3babef', '490f3002-d2a8-5368-9b4e-179b25be49ec', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Quand il eut signé, il rendit la plume."},{"id":"b","text":"Il était impératif qu''elle vînt seule."},{"id":"c","text":"Le navire fut englouti par la vague."},{"id":"d","text":"Il était impératif qu''elle vint seule."}]'::jsonb, 'd', 'L''erreur est en (d) : après « il était impératif que », il faut le subjonctif imparfait « vînt » avec accent circonflexe, et non le passé simple « vint » de l''indicatif. La phrase (b), identique mais avec « vînt », est correcte, tout comme (a) « eut signé » (passé antérieur) et (c) « fut englouti » (passé simple).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('db7fb78e-480f-58ff-93ae-96f981e7c399', '206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'Quelle figure de style reconnaît-on dans : « Cet homme est un lion » ?', '[{"id":"a","text":"Une comparaison"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une métonymie"},{"id":"d","text":"Une litote"}]'::jsonb, 'b', 'C''est une métaphore : on identifie l''homme à un lion sans outil de comparaison. Avec « comme » (« fort comme un lion »), ce serait une comparaison ; la métaphore, elle, supprime l''outil.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83cfc43a-e209-500d-88e3-4cd0979d5cca', '206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'Quelle est la différence essentielle entre la comparaison et la métaphore ?', '[{"id":"a","text":"La comparaison emploie un outil (comme, tel) ; la métaphore n''en emploie pas."},{"id":"b","text":"La métaphore emploie un outil (comme, tel) ; la comparaison n''en emploie pas."},{"id":"c","text":"La comparaison oppose deux idées ; la métaphore les répète."},{"id":"d","text":"La comparaison atténue une réalité ; la métaphore l''exagère."}]'::jsonb, 'a', 'La comparaison rapproche deux termes au moyen d''un outil (comme, tel, semblable à) ; la métaphore opère le même rapprochement mais sans outil. L''option b inverse les deux définitions ; c et d décrivent d''autres figures.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10763c44-4482-5136-864a-f08358413eb9', '206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'Dans « Il n''est pas mauvais » pour dire qu''il est très bon, de quelle figure s''agit-il ?', '[{"id":"a","text":"Une hyperbole"},{"id":"b","text":"Un euphémisme"},{"id":"c","text":"Une litote"},{"id":"d","text":"Une antithèse"}]'::jsonb, 'c', 'C''est une litote : on dit moins (« pas mauvais ») pour faire entendre plus (« très bon »), souvent par la négation. L''euphémisme, lui, adoucirait une réalité pénible ; l''hyperbole exagérerait.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ba22937-e5da-5bb3-8250-0be295963cd6', '206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'Quel exemple illustre une métonymie ?', '[{"id":"a","text":"Une obscure clarté tombe des étoiles."},{"id":"b","text":"Il est rusé comme un renard."},{"id":"c","text":"Le vent hurlait dans la nuit."},{"id":"d","text":"Boire un verre entre amis."}]'::jsonb, 'd', '« Boire un verre » est une métonymie : on nomme le contenant (le verre) pour le contenu (la boisson), par un lien logique. L''option a est un oxymore, b une comparaison, c une personnification.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8a9481a-137d-5249-8560-7c8d06b0b260', '206fcb28-a604-5e4e-9c9a-54bb0168a8ab', 'Dans « une obscure clarté », quelle figure unit deux mots contradictoires dans un même groupe ?', '[{"id":"a","text":"L''antithèse"},{"id":"b","text":"L''hyperbole"},{"id":"c","text":"La gradation"},{"id":"d","text":"L''oxymore"}]'::jsonb, 'd', '« Obscure clarté » est un oxymore : deux termes de sens opposé sont soudés dans un même syntagme. L''antithèse, elle, étalerait l''opposition sur des termes distincts (« ici l''ombre, là la lumière »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f7246a96-b203-54b9-9546-937a930227d2', 'c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', 'francais-c2', '⭐ Entraînement : les figures de style', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4524f9db-add6-5bc2-8eb8-71da27609706', 'f7246a96-b203-54b9-9546-937a930227d2', 'Quelle figure reconnaît-on dans : « Il est rusé comme un renard » ?', '[{"id":"a","text":"Une comparaison"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une métonymie"},{"id":"d","text":"Un oxymore"}]'::jsonb, 'a', 'C''est une comparaison : l''outil « comme » rapproche l''homme et le renard. Sans cet outil (« c''est un renard »), on aurait une métaphore. La présence de l''outil est le critère décisif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df76765c-86ff-5da0-b561-26abdc1f1a88', 'f7246a96-b203-54b9-9546-937a930227d2', 'Quelle figure reconnaît-on dans : « La ville dort sous la lune » ?', '[{"id":"a","text":"Une litote"},{"id":"b","text":"Une personnification"},{"id":"c","text":"Une hyperbole"},{"id":"d","text":"Une synecdoque"}]'::jsonb, 'b', 'C''est une personnification : on prête une action humaine (« dormir ») à une chose, la ville. Ce n''est ni une litote (dire moins pour plus), ni une hyperbole (exagération), ni une synecdoque (la partie pour le tout).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77b84be1-dc47-581d-9a76-1d98ceebd300', 'f7246a96-b203-54b9-9546-937a930227d2', 'Quel exemple illustre une hyperbole ?', '[{"id":"a","text":"Il n''est pas très malin."},{"id":"b","text":"Le soir, l''astre du jour disparaît."},{"id":"c","text":"Je meurs de faim, j''avalerais un bœuf entier."},{"id":"d","text":"Une voile glissait à l''horizon."}]'::jsonb, 'c', '« J''avalerais un bœuf entier » est une hyperbole : une exagération volontaire pour frapper l''esprit. L''option a est une litote, b une périphrase (l''astre du jour = le soleil), d une synecdoque (la voile pour le bateau).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20874920-7a8e-524b-ae8a-3bf9fdc9311d', 'f7246a96-b203-54b9-9546-937a930227d2', 'Quelle figure reconnaît-on dans : « Il nous a quittés » pour annoncer une mort ?', '[{"id":"a","text":"Une litote"},{"id":"b","text":"Une hyperbole"},{"id":"c","text":"Une métonymie"},{"id":"d","text":"Un euphémisme"}]'::jsonb, 'd', 'C''est un euphémisme : on atténue une réalité pénible (la mort) par une formule adoucie. La litote dirait moins pour suggérer plus d''intensité ; ici on cherche surtout à ménager, ce qui caractérise l''euphémisme.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('593c4d19-8e6b-5d99-a530-bfd2b9f3e9a1', 'f7246a96-b203-54b9-9546-937a930227d2', 'Quel exemple illustre une métaphore ?', '[{"id":"a","text":"Ses yeux brillaient comme des étoiles."},{"id":"b","text":"Cette femme est une perle."},{"id":"c","text":"Il a lu tout un Balzac cet été."},{"id":"d","text":"Je vis, je meurs."}]'::jsonb, 'b', '« Cette femme est une perle » est une métaphore : on identifie la femme à une perle sans outil de comparaison. L''option a est une comparaison (« comme »), c une métonymie (l''auteur pour l''œuvre), d une antithèse.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('803172c8-6287-51ae-bb10-51477358c74d', 'f7246a96-b203-54b9-9546-937a930227d2', 'Quelle figure reconnaît-on dans : « Une voile à l''horizon » pour désigner un bateau ?', '[{"id":"a","text":"Une métaphore"},{"id":"b","text":"Une périphrase"},{"id":"c","text":"Une synecdoque"},{"id":"d","text":"Une comparaison"}]'::jsonb, 'c', 'C''est une synecdoque : on nomme la partie (la voile) pour désigner le tout (le bateau). Ce n''est pas une métaphore (pas d''analogie) ni une comparaison (pas d''outil) ; la périphrase, elle, remplacerait le mot par une expression descriptive entière.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6beac16c-10c7-56de-a3a2-68191bf1866c', 'c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', 'francais-c2', '⭐⭐ Révision : les figures de style', 2, 75, 15, 'practice', 'admin', 2)
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
  ('58c98953-f436-5246-b8c2-52ab63851944', '6beac16c-10c7-56de-a3a2-68191bf1866c', 'Quelle figure reconnaît-on dans : « Va, cours, vole et nous venge » ?', '[{"id":"a","text":"Une anaphore"},{"id":"b","text":"Un chiasme"},{"id":"c","text":"Une antithèse"},{"id":"d","text":"Une gradation"}]'::jsonb, 'd', 'C''est une gradation : les verbes s''enchaînent en intensité croissante (va, cours, vole). L''anaphore répéterait un mot en tête ; le chiasme croiserait les termes en miroir (ABBA) ; l''antithèse opposerait deux idées.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c4f4d40-6aac-5276-816a-1e1070f8acde', '6beac16c-10c7-56de-a3a2-68191bf1866c', 'Quel exemple illustre une anaphore ?', '[{"id":"a","text":"Mon bras, mon sang, mon honneur, tout est en jeu."},{"id":"b","text":"Cette obscure clarté qui tombe des étoiles."},{"id":"c","text":"Il faut manger pour vivre, non vivre pour manger."},{"id":"d","text":"Le téléphone sonne sans arrêt depuis ce matin."}]'::jsonb, 'a', 'C''est une anaphore : le mot « mon » est répété en tête de chaque groupe. L''option b est un oxymore, c un chiasme (structure ABBA), d une phrase neutre sans figure de répétition.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45224a33-fe35-5a35-aa6a-a2ac5d0b479c', '6beac16c-10c7-56de-a3a2-68191bf1866c', 'Quelle figure reconnaît-on dans : « Boire un verre » au sens de boire son contenu ?', '[{"id":"a","text":"Une synecdoque"},{"id":"b","text":"Une périphrase"},{"id":"c","text":"Une métonymie"},{"id":"d","text":"Une métaphore"}]'::jsonb, 'c', 'C''est une métonymie : on nomme le contenant (le verre) pour le contenu (la boisson), par un lien logique. La synecdoque serait la partie pour le tout ; ici le rapport est contenant/contenu, ce qui définit la métonymie.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42d95cf9-78ae-5636-9f32-7381a4777385', '6beac16c-10c7-56de-a3a2-68191bf1866c', 'Quelle figure reconnaît-on dans : « Cette nuit, la mer était d''huile » ?', '[{"id":"a","text":"Une comparaison"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une litote"},{"id":"d","text":"Une personnification"}]'::jsonb, 'b', '« La mer était d''huile » est une métaphore : on assimile la mer calme à de l''huile, sans outil de comparaison. Avec « comme de l''huile », ce serait une comparaison ; ici l''absence d''outil signe la métaphore.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f2d5759-2406-540c-877c-ed1ff9d7fe6e', '6beac16c-10c7-56de-a3a2-68191bf1866c', 'Quel est l''effet principal d''une litote comme « Je ne te hais point » ?', '[{"id":"a","text":"Suggérer un sentiment fort (l''amour) en disant moins."},{"id":"b","text":"Exagérer la haine pour la rendre comique."},{"id":"c","text":"Adoucir l''annonce d''un événement triste."},{"id":"d","text":"Opposer l''amour et la haine sur deux termes distincts."}]'::jsonb, 'a', 'La litote dit moins (« ne pas haïr ») pour faire entendre plus (« aimer »). C''est l''inverse de l''hyperbole (b). L''option c décrit l''euphémisme, et d décrit une antithèse : aucune ne correspond à l''effet d''atténuation suggestive de la litote.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d356a32-2673-540d-9a1f-313fab4f68c2', '6beac16c-10c7-56de-a3a2-68191bf1866c', 'Quelle figure reconnaît-on dans : « Le silence assourdissant régnait dans la salle » ?', '[{"id":"a","text":"Une antithèse"},{"id":"b","text":"Une hyperbole"},{"id":"c","text":"Une gradation"},{"id":"d","text":"Un oxymore"}]'::jsonb, 'd', '« Silence assourdissant » est un oxymore : deux mots contradictoires (silence / assourdissant) sont réunis dans un même groupe. L''antithèse, elle, distribuerait l''opposition sur des termes séparés ; ici le contraste est resserré, donc c''est un oxymore.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : les figures de style', 3, 120, 30, 'boss', 'admin', 3)
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
  ('ba580f7f-6e26-570d-b79c-01a52c527389', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'Quelle figure reconnaît-on dans : « Pour qui sont ces serpents qui sifflent sur vos têtes ? » (Racine) ?', '[{"id":"a","text":"Une assonance"},{"id":"b","text":"Une allitération"},{"id":"c","text":"Une anaphore"},{"id":"d","text":"Une gradation"}]'::jsonb, 'b', 'C''est une allitération : la consonne « s » est répétée (serpents, sifflent) pour imiter le sifflement. Le piège est l''assonance, qui répète une voyelle ; ici on répète une consonne, donc c''est bien une allitération.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89771009-c252-56e4-9699-0dbbba222a8d', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'Quelle figure reconnaît-on dans : « Il faut manger pour vivre et non vivre pour manger » ?', '[{"id":"a","text":"Une anaphore"},{"id":"b","text":"Une gradation"},{"id":"c","text":"Un chiasme"},{"id":"d","text":"Une antithèse"}]'::jsonb, 'c', 'C''est un chiasme : les termes « manger / vivre » reviennent en ordre inversé (manger-vivre puis vivre-manger), formant une structure ABBA. S''ils revenaient dans le même ordre (ABAB), ce serait un parallélisme, pas un chiasme.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('478c5505-352a-5f18-8e2d-94832a67861d', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'Lis : « Le Pentagone a démenti l''information. » Quelle figure désigne ici l''autorité militaire américaine ?', '[{"id":"a","text":"Une métonymie (le lieu pour l''institution)"},{"id":"b","text":"Une synecdoque (la partie pour le tout)"},{"id":"c","text":"Une périphrase"},{"id":"d","text":"Une personnification"}]'::jsonb, 'a', 'C''est une métonymie : on emploie le lieu (le Pentagone) pour l''institution qu''il abrite (la défense américaine), par un lien logique. Ce n''est pas une synecdoque, qui suppose un rapport partie/tout, ni une périphrase descriptive.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ecfbb9bc-2365-5650-9348-3bfec7d38786', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'Quel est l''effet recherché par l''oxymore « cette obscure clarté » (Corneille) ?', '[{"id":"a","text":"Atténuer une réalité pénible."},{"id":"b","text":"Énumérer des éléments d''intensité croissante."},{"id":"c","text":"Répéter un même mot en tête de vers."},{"id":"d","text":"Créer une tension par l''union de deux notions opposées."}]'::jsonb, 'd', 'L''oxymore réunit « obscure » et « clarté », deux notions contraires, pour créer une tension expressive et une image paradoxale. L''option a vise l''euphémisme, b la gradation, c l''anaphore : aucune ne décrit l''effet propre de l''oxymore.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5004cce6-7b1b-593e-b6b1-42282dc53884', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'Lis : « Je vis, je meurs ; je me brûle et me noie. » (Louise Labé) Quelle figure structure ce vers ?', '[{"id":"a","text":"Un oxymore"},{"id":"b","text":"Une litote"},{"id":"c","text":"Une antithèse"},{"id":"d","text":"Une synecdoque"}]'::jsonb, 'c', 'C''est une antithèse : les contraires (vivre/mourir, brûler/se noyer) s''opposent sur des termes distincts. Le piège est l''oxymore, mais celui-ci souderait les contraires dans un même groupe ; ici l''opposition est étalée, donc c''est une antithèse.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0bdffaa-d41c-5216-ad54-fec93b7232f2', '7dcacde2-0734-56fa-b39f-b6a5db5acb92', 'Quelle figure reconnaît-on dans : « La capitale des Gaules » pour désigner Lyon ?', '[{"id":"a","text":"Une périphrase"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une métonymie"},{"id":"d","text":"Une hyperbole"}]'::jsonb, 'a', 'C''est une périphrase : on remplace le nom propre (Lyon) par une expression descriptive (« la capitale des Gaules »). Ce n''est pas une métaphore (aucune analogie), ni une métonymie (aucun lien contenant/contenu), ni une exagération.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : les figures de style', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('8f40a2fc-73d0-52d3-8ce6-c857dcc9ae18', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'Lis : « Ô temps, suspends ton vol ! » (Lamartine) Quelles deux figures se combinent ici ?', '[{"id":"a","text":"Une comparaison et une métonymie."},{"id":"b","text":"Une litote et une synecdoque."},{"id":"c","text":"Une antithèse et une gradation."},{"id":"d","text":"Une apostrophe et une personnification."}]'::jsonb, 'd', 'Le poète interpelle le temps (apostrophe : « Ô temps ») et lui prête une action humaine, suspendre son vol (personnification). Aucune analogie avec outil (a), aucune atténuation (b), aucune opposition ni progression (c) n''est en jeu ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b83d408c-6806-569e-8a76-72bfcc5f4cb1', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'Lis : « Rome n''est plus dans Rome, elle est toute où je suis. » (Corneille) Quelle figure repose sur la métonymie « Rome » ?', '[{"id":"a","text":"« Rome » désigne la ville par une synecdoque (la partie pour le tout)."},{"id":"b","text":"« Rome » désigne le pouvoir et la majesté impériale par métonymie (le lieu pour l''institution)."},{"id":"c","text":"« Rome » est une périphrase pour l''empereur."},{"id":"d","text":"« Rome » est une hyperbole exagérant la taille de la ville."}]'::jsonb, 'b', 'Par métonymie, « Rome » désigne non la cité mais le pouvoir, la dignité et la puissance qu''elle incarne (le lieu pour l''institution). Ce n''est pas une synecdoque partie/tout (a), ni une périphrase descriptive (c), ni une exagération (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12e98ee8-afea-5c38-b58c-b548c79150f3', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'Lis : « Cet hymne, ce silence, ce cri qui montait des tranchées. » Quelle figure organise cette suite de termes ?', '[{"id":"a","text":"Une gradation."},{"id":"b","text":"Un chiasme."},{"id":"c","text":"Un oxymore."},{"id":"d","text":"Une litote."}]'::jsonb, 'a', 'C''est une gradation : les termes « hymne, silence, cri » s''enchaînent en montée d''intensité émotionnelle. Le chiasme supposerait un croisement ABBA (b) ; l''oxymore unirait deux contraires dans un seul groupe (c) ; la litote atténuerait (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c356f3e-ccf4-59c4-8837-faa1268a7097', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'Lis : « Ce n''est pas une mince affaire que de gravir ce sommet. » Quelle figure et quel effet ?', '[{"id":"a","text":"Un euphémisme qui adoucit la difficulté pour ne pas effrayer."},{"id":"b","text":"Une hyperbole qui exagère la difficulté."},{"id":"c","text":"Une litote qui, en disant « pas une mince affaire », souligne une grande difficulté."},{"id":"d","text":"Une métaphore filée comparant l''effort à une montagne."}]'::jsonb, 'c', '« Pas une mince affaire » est une litote : on dit moins (« pas mince ») pour faire entendre plus (« très difficile »). Ce n''est pas un euphémisme, qui viserait à ménager une réalité pénible (a), ni une hyperbole d''exagération directe (b), ni une métaphore (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e650f33-c17c-54ef-a0cf-ba4f0265c4ab', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'Lis : « Les blés ondulaient, dorés, infinis ; la plaine respirait. » Quelles deux figures sont présentes ?', '[{"id":"a","text":"Une litote (« ondulaient ») et un chiasme."},{"id":"b","text":"Une hyperbole (« infinis ») et une personnification (« la plaine respirait »)."},{"id":"c","text":"Une métonymie (« les blés ») et une antithèse."},{"id":"d","text":"Un oxymore (« dorés, infinis ») et une assonance."}]'::jsonb, 'b', '« Infinis » exagère l''étendue (hyperbole) et « la plaine respirait » prête une fonction vivante à un paysage (personnification). « Ondulaient » n''atténue rien (a) ; « les blés » n''est pas un report par lien logique (c) ; « dorés, infinis » ne contient aucune contradiction (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cb333c1-b502-58a0-9dba-2beeebef1e36', 'ce8f86e0-fb75-5c8c-aabc-0ff429e3d1eb', 'Lis : « Promettre est noble, tenir parole l''est davantage ; mais trahir, voilà le déshonneur. » Quelle figure domine la construction ?', '[{"id":"a","text":"Une anaphore."},{"id":"b","text":"Une métaphore filée."},{"id":"c","text":"Un oxymore."},{"id":"d","text":"Une gradation (montée puis chute morale)."}]'::jsonb, 'd', 'C''est une gradation : la phrase progresse en intensité (promettre, tenir, trahir) jusqu''à un sommet, le déshonneur. Aucun mot n''est répété en tête (a), aucune image n''est filée (b), aucun groupe ne soude deux contraires (c).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('db51894f-1021-5c90-b30e-a2f173b29b9e', 'c6ea6fe1-5e9f-59e3-9837-2859f88a3a05', 'francais-c2', '⭐⭐ Drill : les figures de style', 2, 75, 15, 'practice', 'admin', 5)
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
  ('617e4aae-131a-5e2b-8be1-0b8362e5cd69', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'Quelle figure reconnaît-on dans : « Ses dents sont des perles » ?', '[{"id":"a","text":"Une comparaison"},{"id":"b","text":"Une synecdoque"},{"id":"c","text":"Une métaphore"},{"id":"d","text":"Une litote"}]'::jsonb, 'c', 'C''est une métaphore : on identifie les dents à des perles sans outil de comparaison. Avec « comme des perles », ce serait une comparaison ; l''absence d''outil est le critère qui désigne la métaphore.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de75026f-ec0b-54b2-b6b7-3c927bb211eb', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'Quel exemple illustre une assonance ?', '[{"id":"a","text":"Boire un verre au comptoir."},{"id":"b","text":"Il faut rire avant que d''être heureux."},{"id":"c","text":"La forêt frémit sous le froid."},{"id":"d","text":"Les sanglots longs des violons (répétition du son « on »)."}]'::jsonb, 'd', 'C''est une assonance : la voyelle nasale « on » est répétée (sanglots longs, violons). Le piège est l''allitération (option c, répétition du « f »), qui répète une consonne ; ici on répète une voyelle, donc c''est une assonance.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('929b89d6-a95a-50ca-bada-75fb1fe74210', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'Quelle figure reconnaît-on dans : « J''ai relu tout un Zola pendant les vacances » ?', '[{"id":"a","text":"Une périphrase"},{"id":"b","text":"Une métonymie"},{"id":"c","text":"Une synecdoque"},{"id":"d","text":"Une métaphore"}]'::jsonb, 'b', 'C''est une métonymie : on nomme l''auteur (Zola) pour son œuvre (un de ses romans), par un lien logique. Ce n''est pas une synecdoque partie/tout, ni une périphrase descriptive, ni une analogie métaphorique.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('442592a5-983b-5f2a-a3a0-e08e0340b350', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'Quel est l''effet recherché par l''anaphore « Mon âme, mon cœur, mon tout » ?', '[{"id":"a","text":"Marteler une idée par la reprise d''un mot en tête, pour insister."},{"id":"b","text":"Atténuer un sentiment trop fort par la négation."},{"id":"c","text":"Croiser des termes en miroir pour les opposer."},{"id":"d","text":"Désigner une chose par une expression descriptive."}]'::jsonb, 'a', 'L''anaphore reprend « mon » en tête de chaque groupe pour marteler et intensifier l''émotion. L''option b décrit la litote, c le chiasme, d la périphrase : aucune ne correspond à l''effet d''insistance par répétition initiale de l''anaphore.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7300db7-4cc4-5f7c-96e4-da0b7bc4d772', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'Quelle figure reconnaît-on dans : « Cette douce violence finit par l''emporter » ?', '[{"id":"a","text":"Une antithèse"},{"id":"b","text":"Une gradation"},{"id":"c","text":"Une hyperbole"},{"id":"d","text":"Un oxymore"}]'::jsonb, 'd', '« Douce violence » est un oxymore : deux mots contradictoires (douce / violence) sont réunis dans un même groupe. L''antithèse, elle, étalerait l''opposition sur des termes distincts ; ici le contraste est resserré, ce qui caractérise l''oxymore.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7065646e-2013-5e0a-b928-d7b7c2aafa27', 'db51894f-1021-5c90-b30e-a2f173b29b9e', 'Quelle figure reconnaît-on dans : « Le navire fendait les flots en colère » ?', '[{"id":"a","text":"Une personnification"},{"id":"b","text":"Une comparaison"},{"id":"c","text":"Une litote"},{"id":"d","text":"Une métonymie"}]'::jsonb, 'a', 'C''est une personnification : on prête un sentiment humain (« en colère ») aux flots. Il n''y a aucun outil de comparaison (b), aucune atténuation par la négation (c), aucun report par lien logique contenant/contenu (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f23263f1-2e56-5e7c-9be3-fbb21c4f9743', '02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('47fe294d-a619-575c-9c91-f121689be4b6', 'f23263f1-2e56-5e7c-9be3-fbb21c4f9743', 'Dans la phrase « Ainsi parla le sage », quel procédé de syntaxe expressive est employé ?', '[{"id":"a","text":"L''inversion stylistique du sujet après un adverbe en tête."},{"id":"b","text":"La dislocation du sujet repris par un pronom."},{"id":"c","text":"L''ellipse du verbe principal."},{"id":"d","text":"La périphrase désignant le sage."}]'::jsonb, 'a', 'Après l''adverbe « ainsi » en tête de phrase, le sujet « le sage » passe après le verbe « parla » : c''est l''inversion stylistique du sujet, fréquente en style soutenu. Il n''y a ni pronom de reprise (dislocation), ni verbe omis (ellipse), ni expression descriptive (périphrase).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de2a155d-9e02-5992-93ff-8cfe1c80776b', 'f23263f1-2e56-5e7c-9be3-fbb21c4f9743', 'Que signifie « un grand homme » (adjectif antéposé) ?', '[{"id":"a","text":"Un homme de haute taille."},{"id":"b","text":"Un homme illustre, remarquable."},{"id":"c","text":"Un homme âgé."},{"id":"d","text":"Un homme robuste."}]'::jsonb, 'b', 'Antéposé, « grand » prend un sens figuré et valorisant : un grand homme est un homme illustre (Victor Hugo est un grand homme). Le sens de taille — « de haute taille » — correspond à l''adjectif postposé : un homme grand.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24f8675e-f3b7-5016-8031-eed21790ccd0', 'f23263f1-2e56-5e7c-9be3-fbb21c4f9743', 'Quelle expression désigne le soleil par périphrase ?', '[{"id":"a","text":"L''astre des nuits."},{"id":"b","text":"La Ville Lumière."},{"id":"c","text":"L''astre du jour."},{"id":"d","text":"Le roi des animaux."}]'::jsonb, 'c', '« L''astre du jour » est la périphrase consacrée du soleil. « L''astre des nuits » désigne la lune, « la Ville Lumière » désigne Paris et « le roi des animaux » désigne le lion.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbfb8b56-b27c-568b-93f8-1fa7edae329b', 'f23263f1-2e56-5e7c-9be3-fbb21c4f9743', 'La phrase « À chacun son métier » illustre quel procédé ?', '[{"id":"a","text":"L''inversion du sujet."},{"id":"b","text":"La gradation ternaire."},{"id":"c","text":"La périphrase savante."},{"id":"d","text":"L''ellipse stylistique du verbe."}]'::jsonb, 'd', 'Le verbe est sous-entendu (« à chacun revient son métier ») : c''est une ellipse stylistique, qui donne au proverbe sa concision et sa frappe. Aucun sujet n''est inversé, il n''y a ni trois membres croissants ni expression descriptive.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('888229b1-9599-59b7-a484-587f89be53e8', 'f23263f1-2e56-5e7c-9be3-fbb21c4f9743', 'Quelle phrase emploie correctement l''inversion après « peut-être » ?', '[{"id":"a","text":"Peut-être il acceptera notre offre."},{"id":"b","text":"Peut-être acceptera-t-il notre offre."},{"id":"c","text":"Peut-être il acceptera-t-il notre offre."},{"id":"d","text":"Peut-être qu''acceptera-t-il notre offre."}]'::jsonb, 'b', 'Après « peut-être » en tête, soit on inverse (peut-être acceptera-t-il), soit on ajoute « que » sans inverser (peut-être qu''il acceptera). « Peut-être il acceptera » (a) est fautif ; (c) double le pronom ; (d) combine à tort « que » et l''inversion.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('015ffc1d-c93c-57eb-a408-520e54175968', '02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'francais-c2', '⭐ Entraînement : la syntaxe expressive', 1, 50, 10, 'practice', 'admin', 1)
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
  ('329f92fc-dcea-55cd-b761-543ff706523b', '015ffc1d-c93c-57eb-a408-520e54175968', 'Que désigne la périphrase « la Ville Lumière » ?', '[{"id":"a","text":"Paris."},{"id":"b","text":"Lyon."},{"id":"c","text":"Le soleil."},{"id":"d","text":"Versailles."}]'::jsonb, 'a', '« La Ville Lumière » est la périphrase consacrée de Paris, en raison de son éclairage public précoce et de son rayonnement intellectuel. Elle ne désigne ni Lyon, ni Versailles, ni un astre.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5cd41b20-9006-593b-80da-5cbb1c1770f4', '015ffc1d-c93c-57eb-a408-520e54175968', 'Quel est le sens de « un homme pauvre » (adjectif postposé) ?', '[{"id":"a","text":"Un homme à plaindre, malheureux."},{"id":"b","text":"Un homme seul."},{"id":"c","text":"Un homme médiocre."},{"id":"d","text":"Un homme sans argent, démuni."}]'::jsonb, 'd', 'Postposé, « pauvre » garde son sens propre : sans argent, démuni. Le sens affectif « à plaindre » correspond à l''antéposition : un pauvre homme. Ne pas confondre ces deux valeurs est un point clé de C2.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cadd5d8c-8681-5c37-86e7-9a7be52cec78', '015ffc1d-c93c-57eb-a408-520e54175968', 'Dans « « Je reviendrai », dit-elle », comment se nomme la construction « dit-elle » ?', '[{"id":"a","text":"Une dislocation."},{"id":"b","text":"Une ellipse."},{"id":"c","text":"Une incise avec inversion du sujet."},{"id":"d","text":"Une périphrase."}]'::jsonb, 'c', '« dit-elle » est une incise (proposition de discours rapporté insérée) où le sujet « elle » est inversé après le verbe « dit ». C''est l''inversion obligatoire dans les incises, et non une dislocation, une ellipse ni une périphrase.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5ecdd3a-ae5e-53ac-a557-89fbed820280', '015ffc1d-c93c-57eb-a408-520e54175968', 'Quelle phrase est une phrase nominale (sans verbe conjugué) ?', '[{"id":"a","text":"Le gouvernement est tombé."},{"id":"b","text":"Le gouvernement va tomber."},{"id":"c","text":"On annonce que le gouvernement tombe."},{"id":"d","text":"Chute du gouvernement."}]'::jsonb, 'd', '« Chute du gouvernement » ne contient aucun verbe conjugué : c''est une phrase nominale, typique des titres de presse pour leur concision frappante. Les trois autres phrases sont construites autour d''un verbe (est tombé, va tomber, annonce/tombe).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e5c5451-1045-5248-b7a3-7f082a3b8cde', '015ffc1d-c93c-57eb-a408-520e54175968', 'Que signifie « un grand homme » et « un homme grand » respectivement ?', '[{"id":"a","text":"De haute taille / illustre."},{"id":"b","text":"Riche / pauvre."},{"id":"c","text":"Vieux / jeune."},{"id":"d","text":"Illustre / de haute taille."}]'::jsonb, 'd', '« Un grand homme » (antéposé) = un homme illustre ; « un homme grand » (postposé) = un homme de haute taille. L''antéposition donne le sens figuré valorisant, la postposition le sens propre de mesure.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('360e12e5-c6be-5a76-bf96-e60cee3c818c', '015ffc1d-c93c-57eb-a408-520e54175968', 'Quel proverbe repose sur une ellipse du verbe et un parallélisme ?', '[{"id":"a","text":"« Il ne faut jamais remettre au lendemain. »"},{"id":"b","text":"« Qui veut voyager loin ménage sa monture. »"},{"id":"c","text":"« Loin des yeux, loin du cœur. »"},{"id":"d","text":"« On a souvent besoin d''un plus petit que soi. »"}]'::jsonb, 'c', '« Loin des yeux, loin du cœur » omet tout verbe (ellipse) et répète la même structure « loin de + nom » (parallélisme), d''où sa frappe mémorable. Les autres proverbes contiennent des verbes conjugués (faut, veut/ménage, a).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fa2b567e-1dd2-54fb-996c-78f96293b22b', '02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'francais-c2', '⭐⭐ Révision : la syntaxe expressive', 2, 75, 15, 'practice', 'admin', 2)
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
  ('f7051e44-dce6-558f-a60b-764927b7f06f', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"Sans doute a-t-il raison."},{"id":"b","text":"Sans doute qu''il a raison."},{"id":"c","text":"Sans doute il a raison."},{"id":"d","text":"Peut-être viendra-t-elle."}]'::jsonb, 'c', 'Après « sans doute » ou « peut-être » en tête, il faut soit inverser (sans doute a-t-il raison), soit ajouter « que » sans inverser (sans doute qu''il a raison). « Sans doute il a raison » est fautif. Les phrases a, b et d sont correctes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c359747-90f2-5af5-9c24-921b987ab251', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'Dans quel groupe l''adjectif a-t-il un sens affectif (et non son sens propre) ?', '[{"id":"a","text":"Un meuble ancien."},{"id":"b","text":"Un pauvre homme."},{"id":"c","text":"Des mains propres."},{"id":"d","text":"Un homme grand."}]'::jsonb, 'b', 'Antéposé, « pauvre » dans « un pauvre homme » signifie « à plaindre » : sens affectif. « Meuble ancien », « mains propres » et « homme grand » sont des adjectifs postposés à sens propre (vieux, lavées, de taille).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3a4c092-89d2-522d-9d49-4e879f6aad5b', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'Que désigne la périphrase « la langue de Molière » ?', '[{"id":"a","text":"Le théâtre classique."},{"id":"b","text":"L''anglais."},{"id":"c","text":"Le latin."},{"id":"d","text":"Le français."}]'::jsonb, 'd', '« La langue de Molière » désigne le français, par référence au grand dramaturge français. « La langue de Shakespeare » désignerait l''anglais. La périphrase nomme la langue, non un genre littéraire ni le latin.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12255bbc-3155-5df5-a2f7-2aa42cc7fb01', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'Quelle phrase illustre le rythme ternaire ?', '[{"id":"a","text":"Je suis venu, j''ai vu, j''ai vaincu."},{"id":"b","text":"Il faut manger pour vivre, non vivre pour manger."},{"id":"c","text":"Quelle journée !"},{"id":"d","text":"Loin des yeux, loin du cœur."}]'::jsonb, 'a', '« Je suis venu, j''ai vu, j''ai vaincu » aligne trois membres (rythme ternaire), souvent croissants. La phrase b oppose deux membres (rythme binaire), c est nominale exclamative, d est un parallélisme binaire elliptique.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a99ea70-942a-5b17-9a42-26f615c32411', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'Quelle phrase contient une inversion du sujet correctement construite en style soutenu ?', '[{"id":"a","text":"Sur la colline il se dressait un château."},{"id":"b","text":"Sur la colline se dressait un château."},{"id":"c","text":"Sur la colline un château se dressait-il."},{"id":"d","text":"Sur la colline se dressait-il un château."}]'::jsonb, 'b', 'Après le complément en tête « sur la colline », le sujet nominal « un château » passe après le verbe : « se dressait un château ». La phrase a ajoute un « il » superflu, c et d collent à tort un trait d''union (-il) inutile avec un sujet déjà nominal.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b0a8c7a-8e12-5f4c-9348-b37db8e5b6df', 'fa2b567e-1dd2-54fb-996c-78f96293b22b', 'Dans « un certain âge » et « un âge certain », que signifie respectivement chaque adjectif ?', '[{"id":"a","text":"Un âge avéré / un âge assez avancé et vague."},{"id":"b","text":"Un âge assez avancé et vague / un âge avéré, indéniable."},{"id":"c","text":"Un âge précis / un âge approximatif."},{"id":"d","text":"Un jeune âge / un âge mûr."}]'::jsonb, 'b', 'Antéposé, « un certain âge » est vague et euphémique (assez avancé) ; postposé, « un âge certain » signifie un âge avéré, indéniable. C''est le même adjectif, mais l''antéposition lui donne le sens « indéterminé », la postposition le sens « assuré ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eb8cab2e-6998-5865-b425-4b91bfc0521d', '02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : la syntaxe expressive', 3, 120, 30, 'boss', 'admin', 3)
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
  ('82ef4c6f-1159-5929-8d06-5176481ec699', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"À peine fut-il sorti que la pluie tomba."},{"id":"b","text":"Aussi décida-t-il de partir."},{"id":"c","text":"Peut-être qu''il acceptera."},{"id":"d","text":"À peine il était sorti que la pluie tomba."}]'::jsonb, 'd', 'Après « à peine » en tête, l''inversion du sujet est requise en style soutenu : « à peine fut-il sorti que… ». « À peine il était sorti » est fautif (pas d''inversion). Les phrases a, b (aussi = donc, avec inversion) et c (peut-être que sans inversion) sont correctes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a2219b3-7e66-5cda-b42b-2379421d6875', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', 'Pourquoi « mes propres mains » et « des mains propres » ne sont-ils pas synonymes ?', '[{"id":"a","text":"Antéposé, propre = « à moi » ; postposé, propre = « lavées »."},{"id":"b","text":"Antéposé, propre = « lavées » ; postposé, propre = « à moi »."},{"id":"c","text":"Les deux signifient « lavées »."},{"id":"d","text":"Les deux signifient « qui m''appartiennent »."}]'::jsonb, 'a', 'Antéposé, « propre » exprime l''appartenance ou l''insistance : « mes propres mains » = mes mains à moi. Postposé, il reprend son sens concret : « des mains propres » = lavées. L''ordre inverse le sens, piège classique de C2.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f860a3b7-f282-5085-801c-3b2ee2cc811a', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', 'Laquelle de ces périphrases est MAL interprétée ?', '[{"id":"a","text":"« Le septième art » = le cinéma."},{"id":"b","text":"« L''astre des nuits » = la lune."},{"id":"c","text":"« L''astre du jour » = la lune."},{"id":"d","text":"« Le roi des animaux » = le lion."}]'::jsonb, 'c', '« L''astre du jour » désigne le soleil, pas la lune (la lune, c''est « l''astre des nuits »). Les interprétations a, b et d sont exactes. Mal décoder une périphrase est une faute de lecture de niveau C2.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65d9bc3b-7e5d-5669-9621-7c15da8aac4f', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', 'Quelle phrase emploie une ellipse fautive (élément non récupérable sans ambiguïté) ?', '[{"id":"a","text":"Pierre aime le thé, et Marie le café."},{"id":"b","text":"Pierre boit du thé et Marie une."},{"id":"c","text":"À chacun son métier."},{"id":"d","text":"Les uns travaillent, les autres se reposent."}]'::jsonb, 'b', '« Marie une » est fautif : « une » ne peut reprendre « du thé » (massif, non comptable) ; il faudrait « Marie aussi » ou « Marie en boit ». Dans a, l''ellipse du verbe « aime » est claire ; c est un proverbe elliptique correct ; d juxtapose deux propositions complètes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f5c134d-0211-5434-8d74-25e87ca972d5', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"Ainsi parla le maître."},{"id":"b","text":"Ainsi le maître parla-t-il."},{"id":"c","text":"Ainsi il parla le maître."},{"id":"d","text":"Ainsi le maître parla."}]'::jsonb, 'c', '« Ainsi il parla le maître » est fautif : « il » et « le maître » désignent le même sujet, doublé à tort. Les formes correctes sont l''inversion simple (a : ainsi parla le maître), l''inversion complexe (b : sujet nominal + reprise pronominale après le verbe) ou l''ordre direct (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60f966dd-ab59-56df-9965-5d5af5de3421', 'eb8cab2e-6998-5865-b425-4b91bfc0521d', 'Dans « un ancien élève » et « un château ancien », pourquoi « ancien » diffère-t-il ?', '[{"id":"a","text":"Antéposé = « vieux » ; postposé = « d''autrefois »."},{"id":"b","text":"Antéposé = « d''autrefois, ex- » ; postposé = « vieux, antique »."},{"id":"c","text":"Les deux signifient « vieux »."},{"id":"d","text":"Les deux signifient « ex- »."}]'::jsonb, 'b', 'Antéposé, « un ancien élève » = quelqu''un qui fut élève autrefois (sens « ex- »). Postposé, « un château ancien » = un château vieux, antique. L''antéposition donne le sens temporel relatif, la postposition le sens « âgé », d''où la nécessité de bien placer l''adjectif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', '02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : la syntaxe expressive', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('88bc9dcf-04bf-56aa-a96d-7bd5a26a2a92', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', 'Trouve la phrase stylistiquement et grammaticalement irréprochable.', '[{"id":"a","text":"Peut-être qu''acceptera-t-il."},{"id":"b","text":"À peine était-il sorti qu''il se mit à pleuvoir."},{"id":"c","text":"Sans doute il viendra-t-il."},{"id":"d","text":"Ainsi parla-t-il le sage."}]'::jsonb, 'b', '« À peine était-il sorti qu''il se mit à pleuvoir » applique correctement l''inversion après « à peine ». Erreurs ailleurs : a combine « que » et l''inversion ; c double le pronom (il… -il) ; d ajoute « le sage » après « parla-t-il », redondant avec le pronom inversé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be32dd42-90a9-5211-8e90-61a1c4315532', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', 'Quel groupe nominal change de sens si l''on déplace l''adjectif, parmi ces paires dont UNE garde le même sens ?', '[{"id":"a","text":"un grand homme / un homme grand"},{"id":"b","text":"un livre intéressant / un intéressant livre"},{"id":"c","text":"un seul homme / un homme seul"},{"id":"d","text":"un certain âge / un âge certain"}]'::jsonb, 'b', '« Un livre intéressant » et « un intéressant livre » gardent le même sens : « intéressant » n''est pas un adjectif à double sens (l''antéposition n''y est qu''une variante stylistique). En revanche grand, seul et certain changent de sens selon la place (illustre/de taille ; unique/solitaire ; vague/avéré).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de1bdb75-5766-5386-8381-9ba8a97b0178', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', 'Quelle phrase emploie une périphrase qui alourdit le style sans nécessité (« style ampoulé ») ?', '[{"id":"a","text":"Il but un verre d''eau fraîche."},{"id":"b","text":"Assoiffé, il but longuement."},{"id":"c","text":"L''eau coulait du robinet."},{"id":"d","text":"Il porta à ses lèvres le précieux liquide pour étancher sa soif."}]'::jsonb, 'd', 'Désigner l''eau par « le précieux liquide » dans un contexte banal est une périphrase ornementale gratuite : le défaut nommé style ampoulé (ou cheville). Les phrases a, b et c nomment les choses directement, avec naturel. La périphrase n''est un effet que lorsqu''elle apporte un gain réel.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c875e8f-9504-565b-84ea-01b3c94d5d9e', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', 'Dans « C''est un homme seul qui décida », quelle interprétation de « seul » est exacte, et quelle serait celle de « un seul homme » ?', '[{"id":"a","text":"Solitaire / un unique homme."},{"id":"b","text":"Un unique homme / solitaire."},{"id":"c","text":"Les deux : solitaire."},{"id":"d","text":"Les deux : un unique homme."}]'::jsonb, 'a', 'Postposé, « un homme seul » = un homme solitaire, isolé. Antéposé, « un seul homme » = un unique homme (un homme à lui tout seul). C''est encore la place de l''adjectif qui distingue le sens « solitaire » du sens « unique ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c2c0d33-7b94-55d9-b50b-be19e518ee0c', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"À peine le jour s''était-il levé que les oiseaux chantèrent."},{"id":"b","text":"Aussi a-t-elle préféré se taire."},{"id":"c","text":"Du moins peut-on l''espérer."},{"id":"d","text":"Peut-être que viendra-t-elle."}]'::jsonb, 'd', '« Peut-être que viendra-t-elle » est fautif : « peut-être que » exclut l''inversion (il faut « peut-être qu''elle viendra ») et inversement « peut-être viendra-t-elle » se passe de « que ». Les phrases a (inversion complexe après « à peine »), b et c (inversion après « aussi », « du moins ») sont correctes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0742072-00a4-5ae0-8977-b719c0eeb000', '1febe2fe-fa09-5b1f-b3bf-b6eb6b1701a1', 'Quelle phrase combine correctement gradation ternaire croissante ET concision ?', '[{"id":"a","text":"Un souffle, une ombre, un rien le faisait fuir."},{"id":"b","text":"Un rien, une ombre et aussi parfois un léger souffle le faisaient fuir."},{"id":"c","text":"Il fuyait pour des choses sans importance."},{"id":"d","text":"Un souffle le faisait fuir, ainsi qu''une ombre."}]'::jsonb, 'a', '« Un souffle, une ombre, un rien » aligne trois termes brefs en gradation (du plus matériel au plus ténu), avec une concision frappante. La phrase b délaye l''effet par des chevilles, c paraphrase platement, d ne forme pas de cadence ternaire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('090af4b2-9156-5f4b-a4ce-20c8414742c3', '02b8c129-38b2-596c-9e57-b5bcdde0dc96', 'francais-c2', '⭐⭐ Drill : la syntaxe expressive', 2, 75, 15, 'practice', 'admin', 5)
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
  ('3bb04004-63ed-53bc-9595-e2f4902b1dd1', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'Que désigne la périphrase « le roi des animaux » ?', '[{"id":"a","text":"L''aigle."},{"id":"b","text":"Le lion."},{"id":"c","text":"L''éléphant."},{"id":"d","text":"Le loup."}]'::jsonb, 'b', '« Le roi des animaux » est la périphrase consacrée du lion, symbole de force et de royauté. Elle ne désigne ni l''aigle (« roi des airs »), ni l''éléphant, ni le loup.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3e21e54-796d-5462-af3f-b6e41089c69c', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'Dans « Un curieux personnage entra », que signifie « curieux » antéposé ?', '[{"id":"a","text":"Qui aime s''informer."},{"id":"b","text":"Indiscret."},{"id":"c","text":"Étrange, singulier."},{"id":"d","text":"Savant."}]'::jsonb, 'c', 'Antéposé, « un curieux personnage » signifie « étrange, singulier » (sens figuré). Postposé, « un personnage curieux » signifierait « qui aime s''informer ». La place de l''adjectif change le sens.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7f22f9e-d0a7-5050-b8a7-e58ebb1bc13c', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"Peut-être réussira-t-il."},{"id":"b","text":"Peut-être qu''il réussira."},{"id":"c","text":"Peut-être il réussira-t-il."},{"id":"d","text":"Sans doute réussira-t-elle."}]'::jsonb, 'c', '« Peut-être il réussira-t-il » double le pronom sujet (il… -il), ce qui est fautif. Les formes correctes sont l''inversion seule (peut-être réussira-t-il) ou « peut-être que » sans inversion (peut-être qu''il réussira).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d31819f8-0098-54db-9a90-7b306b9fe726', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'Quelle phrase repose sur un rythme binaire (deux membres équilibrés) ?', '[{"id":"a","text":"Je suis venu, j''ai vu, j''ai vaincu."},{"id":"b","text":"Pas de nouvelles, bonnes nouvelles."},{"id":"c","text":"Un souffle, une ombre, un rien."},{"id":"d","text":"Il faut manger pour vivre, et non vivre pour manger."}]'::jsonb, 'd', '« Manger pour vivre / vivre pour manger » oppose deux membres symétriques : c''est un rythme binaire (ici un chiasme). La phrase a est ternaire, b est une phrase nominale elliptique, c est une gradation ternaire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef9dc33c-02a1-5054-9742-9a43379dd101', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'Quel énoncé est une phrase nominale exclamative ?', '[{"id":"a","text":"Quelle magnifique victoire !"},{"id":"b","text":"Nous avons gagné !"},{"id":"c","text":"Comme nous avons gagné !"},{"id":"d","text":"Il a remporté la victoire."}]'::jsonb, 'a', '« Quelle magnifique victoire ! » ne comporte aucun verbe conjugué : c''est une phrase nominale (exclamative), vive et concise. Les phrases b, c et d s''organisent toutes autour d''un verbe (avons gagné, a remporté).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('075a0cf9-ea64-589e-9f32-f6de90fc43f3', '090af4b2-9156-5f4b-a4ce-20c8414742c3', 'Que désignent respectivement « un homme seul » et « un seul homme » ?', '[{"id":"a","text":"Solitaire / un unique homme."},{"id":"b","text":"Un unique homme / solitaire."},{"id":"c","text":"Célibataire / un homme isolé."},{"id":"d","text":"Un unique homme / un homme triste."}]'::jsonb, 'a', 'Postposé, « un homme seul » = solitaire, isolé. Antéposé, « un seul homme » = un unique homme. C''est encore la place de l''adjectif qui distingue le sens « solitaire » du sens « unique ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'bef4483d-ba9c-542d-96fa-961df0120393', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8013655d-4b08-5c46-be1d-072f39c7e963', 'ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'Complétez : « Le tribunal lui a ___ une lourde amende. »', '[{"id":"a","text":"affligé"},{"id":"b","text":"infligé"},{"id":"c","text":"évoqué"},{"id":"d","text":"perpétré"}]'::jsonb, 'b', 'On « inflige » une peine, une amende, une punition : on l''impose à quelqu''un. « Affliger » signifie accabler de chagrin (le deuil l''afflige), et non imposer une sanction. « Évoquer » = mentionner ; « perpétrer » = commettre un crime.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bddd7851-e065-5414-ad0e-d63e789df1b5', 'ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'Quel mot désigne un obstacle dangereux et caché, qui risque de tout faire échouer ?', '[{"id":"a","text":"une difficulté"},{"id":"b","text":"un souci"},{"id":"c","text":"un écueil"},{"id":"d","text":"un problème"}]'::jsonb, 'c', 'Un « écueil » est au sens propre un rocher qui fait sombrer le navire : il désigne un obstacle redoutable et souvent caché. « Difficulté » et « problème » sont neutres ; « souci » est une préoccupation morale, non un obstacle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7bbc4c4-6f86-5ab5-aca5-3fbf1b7ebb9b', 'ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'Complétez : « Un médecin ___ a été appelé en consultation. »', '[{"id":"a","text":"éminent"},{"id":"b","text":"imminent"},{"id":"c","text":"prodigue"},{"id":"d","text":"prolixe"}]'::jsonb, 'a', '« Éminent » signifie remarquable, supérieur : un médecin éminent est un grand spécialiste. « Imminent » qualifie ce qui est sur le point d''arriver (un danger imminent). « Prodigue » = qui dépense sans compter ; « prolixe » = trop bavard.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3d87391-6ec0-5a21-83d7-4695d489be34', 'ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'Dans « la première ___ de ce mot », quel terme désigne l''un de ses SENS ?', '[{"id":"a","text":"acceptation"},{"id":"b","text":"conjoncture"},{"id":"c","text":"inclination"},{"id":"d","text":"acception"}]'::jsonb, 'd', 'Une « acception » est un des sens d''un mot (un mot polysémique a plusieurs acceptions). L''« acceptation » est le fait d''accepter quelque chose. « Conjoncture » = situation du moment ; « inclination » = penchant.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69b5a2db-9d81-50de-a7e2-f23c840dcca2', 'ff4f1681-cadf-57e4-8fb6-5df4c0c7fd9a', 'En français soigné, comment exprimer « régler un problème » ?', '[{"id":"a","text":"solutionner un problème"},{"id":"b","text":"résoudre un problème"},{"id":"c","text":"perpétuer un problème"},{"id":"d","text":"recouvrer un problème"}]'::jsonb, 'b', '« Résoudre » est le verbe juste et soutenu pour venir à bout d''un problème. « Solutionner » est familier et critiqué par les puristes. « Perpétuer » = faire durer (le contraire) ; « recouvrer » = retrouver (la santé, son dû).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d76c5218-b672-5aba-9795-04b7012385e1', 'bef4483d-ba9c-542d-96fa-961df0120393', 'francais-c2', '⭐ Entraînement : nuances lexicales et paronymes', 1, 50, 10, 'practice', 'admin', 1)
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
  ('93fe4958-ebc7-580b-b054-cf664709f4b7', 'd76c5218-b672-5aba-9795-04b7012385e1', 'Complétez : « Après sa longue maladie, il a fini par ___ la santé. »', '[{"id":"a","text":"recouvrir"},{"id":"b","text":"recouvrer"},{"id":"c","text":"perpétrer"},{"id":"d","text":"infliger"}]'::jsonb, 'b', '« Recouvrer » signifie retrouver, récupérer (la santé, la vue, une somme due). « Recouvrir » signifie couvrir entièrement (recouvrir un mur de peinture). Le paronyme « recouvrir » ne convient donc pas ici ; « perpétrer » = commettre, « infliger » = imposer.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1eea1018-d4d7-5399-9836-dd159d6e8ab7', 'd76c5218-b672-5aba-9795-04b7012385e1', 'Quel mot désigne un léger défaut de caractère, sans gravité ?', '[{"id":"a","text":"un vice"},{"id":"b","text":"un écueil"},{"id":"c","text":"un travers"},{"id":"d","text":"une infraction"}]'::jsonb, 'c', 'Un « travers » est un petit défaut de caractère, bénin (avoir ses petits travers). Un « vice » est un défaut grave, moral ou de fabrication. Un « écueil » est un obstacle dangereux ; une « infraction » est une violation de la loi.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e07c231-8272-546d-bc79-e8ef656566d0', 'd76c5218-b672-5aba-9795-04b7012385e1', 'Complétez : « Le naufrage a été causé par une ___ entre deux navires. »', '[{"id":"a","text":"collision"},{"id":"b","text":"collusion"},{"id":"c","text":"conjecture"},{"id":"d","text":"inclinaison"}]'::jsonb, 'a', 'Une « collision » est un choc, un heurt entre deux corps : deux navires entrent en collision. La « collusion » est une entente secrète et frauduleuse. « Conjecture » = supposition ; « inclinaison » = angle, état penché.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1a436d0-ad0f-546e-9a0f-6706744d84df', 'd76c5218-b672-5aba-9795-04b7012385e1', 'Pour quitter définitivement son pays d''origine, on dit qu''on…', '[{"id":"a","text":"immigre"},{"id":"b","text":"invoque"},{"id":"c","text":"amorce"},{"id":"d","text":"émigre"}]'::jsonb, 'd', '« Émigrer », c''est quitter son pays (é- comme dans « exode », vers l''extérieur). « Immigrer », c''est entrer dans un pays pour s''y installer. « Invoquer » = appeler à l''aide ou citer comme argument ; « amorcer » = enclencher un processus.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c87b478-0647-51a3-92b9-06894478dad4', 'd76c5218-b672-5aba-9795-04b7012385e1', 'Complétez : « Il faut ___ ce vieux carnet avant de l''ouvrir, le cuir est fragile. »', '[{"id":"a","text":"recouvrer"},{"id":"b","text":"infliger"},{"id":"c","text":"recouvrir"},{"id":"d","text":"exiger"}]'::jsonb, 'c', '« Recouvrir » = couvrir entièrement (recouvrir un carnet d''un film protecteur). « Recouvrer » signifierait retrouver/récupérer, ce qui n''a pas de sens ici. « Infliger » = imposer une peine ; « exiger » = demander impérativement.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7992686-1a81-5a12-889c-4424d5c3cb99', 'd76c5218-b672-5aba-9795-04b7012385e1', 'Quel verbe convient pour « demander avec insistance ce qui nous est dû » ?', '[{"id":"a","text":"quémander"},{"id":"b","text":"réclamer"},{"id":"c","text":"amorcer"},{"id":"d","text":"inaugurer"}]'::jsonb, 'b', '« Réclamer » = demander avec insistance ce à quoi on a droit (réclamer son salaire). « Quémander » = mendier humblement, sans titre à exiger. « Amorcer » = enclencher ; « inaugurer » = ouvrir solennellement : aucun n''exprime une demande.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('61f4c108-53d0-57c0-95ba-48447d2a887c', 'bef4483d-ba9c-542d-96fa-961df0120393', 'francais-c2', '⭐⭐ Révision : nuances lexicales et paronymes', 2, 75, 15, 'practice', 'admin', 2)
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
  ('c2f0931c-aada-57e1-be1a-01a6aaeaa934', '61f4c108-53d0-57c0-95ba-48447d2a887c', 'Complétez : « Faute de preuves, l''enquêteur en était réduit à des ___. »', '[{"id":"a","text":"conjonctures"},{"id":"b","text":"acceptations"},{"id":"c","text":"conjectures"},{"id":"d","text":"inclinaisons"}]'::jsonb, 'c', 'Une « conjecture » est une supposition, une hypothèse faute de certitude. La « conjoncture » désigne la situation, les circonstances du moment (la conjoncture économique). « Acceptation » = fait d''accepter ; « inclinaison » = angle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fffe3af-0d36-594f-9515-4538e478da3c', '61f4c108-53d0-57c0-95ba-48447d2a887c', 'Complétez : « Cet écrivain ___ a publié plus de cinquante romans. »', '[{"id":"a","text":"prolifique"},{"id":"b","text":"prolixe"},{"id":"c","text":"prodigue"},{"id":"d","text":"littoral"}]'::jsonb, 'a', '« Prolifique » qualifie qui produit beaucoup d''œuvres (un auteur prolifique). « Prolixe » signifie trop long, bavard, diffus — un défaut, non une abondance d''œuvres. « Prodigue » = qui dépense sans compter ; « littoral » = le bord de mer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53b00386-e110-5421-9d3f-b8a2ca6a7713', '61f4c108-53d0-57c0-95ba-48447d2a887c', 'Choisissez la phrase où « opportunité » est employée dans son sens exact (français soigné).', '[{"id":"a","text":"Cette vente est une belle opportunité à ne pas manquer."},{"id":"b","text":"J''ai saisi l''opportunité de partir en voyage."},{"id":"c","text":"Plusieurs opportunités d''emploi se sont présentées."},{"id":"d","text":"On peut douter de l''opportunité d''une telle décision."}]'::jsonb, 'd', 'Au sens strict, « opportunité » = caractère de ce qui est opportun, à-propos : douter de l''opportunité d''une décision, c''est douter qu''elle soit opportune. Dans (a), (b) et (c), « opportunité » remplace « occasion » : c''est un anglicisme critiqué ; il faudrait dire « une belle occasion », « l''occasion de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b614fe5e-5b37-5cd5-9eb9-ec894f3f3d00', '61f4c108-53d0-57c0-95ba-48447d2a887c', 'Complétez : « Le malfaiteur a pénétré dans la maison par ___. »', '[{"id":"a","text":"infraction"},{"id":"b","text":"effraction"},{"id":"c","text":"collusion"},{"id":"d","text":"conjoncture"}]'::jsonb, 'b', 'L''« effraction » est le fait de forcer une fermeture (porte, serrure) pour entrer : un vol par effraction. L''« infraction » est une violation d''une loi ou d''une règle (une infraction au code de la route). « Collusion » = entente secrète ; « conjoncture » = situation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1600abb-78b9-5deb-b34c-b9e20c74ab6c', '61f4c108-53d0-57c0-95ba-48447d2a887c', 'Quel verbe signifie « ouvrir solennellement, pour la première fois » ?', '[{"id":"a","text":"inaugurer"},{"id":"b","text":"entamer"},{"id":"c","text":"amorcer"},{"id":"d","text":"perpétuer"}]'::jsonb, 'a', '« Inaugurer » = ouvrir solennellement (inaugurer un pont, une exposition). « Entamer » = commencer en attaquant une matière ou un capital (entamer un gâteau, ses économies). « Amorcer » = enclencher un processus ; « perpétuer » = faire durer.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4fc4335-5fad-5e60-b589-4a286fa53b4a', '61f4c108-53d0-57c0-95ba-48447d2a887c', 'Complétez : « Cette photo ___ en moi des souvenirs d''enfance. »', '[{"id":"a","text":"invoque"},{"id":"b","text":"inflige"},{"id":"c","text":"évoque"},{"id":"d","text":"recouvre"}]'::jsonb, 'c', '« Évoquer » = faire penser à, rappeler à la mémoire (cette photo évoque des souvenirs). « Invoquer » = appeler à l''aide ou citer comme argument (invoquer une excuse, le ciel). « Infliger » = imposer une peine ; « recouvrer » = retrouver.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4024a104-7d04-580b-b53a-b4579f0cb081', 'bef4483d-ba9c-542d-96fa-961df0120393', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : nuances lexicales et paronymes', 3, 120, 30, 'boss', 'admin', 3)
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
  ('93b0be8c-c416-5d68-8a6d-79bc8d004def', '4024a104-7d04-580b-b53a-b4579f0cb081', 'Complétez : « Son ___ pour la peinture s''est révélée très tôt. »', '[{"id":"a","text":"inclinaison"},{"id":"b","text":"inclination"},{"id":"c","text":"acception"},{"id":"d","text":"conjecture"}]'::jsonb, 'b', 'Une « inclination » est un penchant, un goût, une disposition affective (une inclination pour les arts). L''« inclinaison » est un état penché ou un angle (l''inclinaison d''un toit). Le piège courant : confondre les deux paronymes ; ici, seul le sentiment (inclination) convient.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d555195-c123-5058-9317-3c325e822573', '4024a104-7d04-580b-b53a-b4579f0cb081', 'Complétez : « Cet attentat a été ___ par un groupe inconnu. »', '[{"id":"a","text":"perpétué"},{"id":"b","text":"infligé"},{"id":"c","text":"perpétré"},{"id":"d","text":"amorcé"}]'::jsonb, 'c', '« Perpétrer » = commettre (un crime, un attentat). « Perpétuer » signifie faire durer, transmettre (perpétuer une tradition) : le confondre est la faute classique. « Infliger » = imposer une peine ; « amorcer » = enclencher.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a930a97c-7a14-53f5-b908-210574818353', '4024a104-7d04-580b-b53a-b4579f0cb081', 'Choisissez la phrase au sens le plus juste pour : « il dépense tout son argent sans compter ».', '[{"id":"a","text":"C''est un fils prodigue."},{"id":"b","text":"C''est un fils prodige."},{"id":"c","text":"C''est un fils prolixe."},{"id":"d","text":"C''est un fils prolifique."}]'::jsonb, 'a', '« Prodigue » = qui dépense sans compter (l''enfant prodigue de la parabole). « Prodige » désigne un être ou un fait extraordinaire (un enfant prodige = surdoué) : tout autre sens. « Prolixe » = trop bavard ; « prolifique » = qui produit beaucoup.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('772e480d-8229-558b-af85-ff5423d1f123', '4024a104-7d04-580b-b53a-b4579f0cb081', 'Dans laquelle de ces phrases « conséquent » est-il employé correctement ?', '[{"id":"a","text":"Il a touché un héritage conséquent."},{"id":"b","text":"Une somme conséquente a été dépensée."},{"id":"c","text":"Les dégâts sont conséquents."},{"id":"d","text":"Il est resté conséquent avec ses principes."}]'::jsonb, 'd', 'Au sens exact, « conséquent » = qui agit avec logique, en accord avec ses idées (rester conséquent avec ses principes). Dans (a), (b) et (c), « conséquent » est employé au sens fautif de « important, considérable » : il faudrait écrire « un héritage important », « une somme considérable », « des dégâts importants ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('109b85ac-f7af-5121-8c9d-819516b77385', '4024a104-7d04-580b-b53a-b4579f0cb081', 'Complétez : « Le deuil l''a profondément ___ ; il ne s''en est jamais remis. »', '[{"id":"a","text":"infligé"},{"id":"b","text":"invoqué"},{"id":"c","text":"recouvré"},{"id":"d","text":"affligé"}]'::jsonb, 'd', '« Affliger » = accabler de chagrin, plonger dans la peine (le deuil l''a affligé). « Infliger » = imposer une peine à autrui (on inflige une amende) : le piège paronymique le plus fréquent du C2. « Invoquer » = appeler à l''aide ; « recouvrer » = retrouver.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0db804e0-8c25-5da7-b5d6-283a06cd6f78', '4024a104-7d04-580b-b53a-b4579f0cb081', 'Quel mot complète le mieux : « Le manque d''eau potable reste le principal ___ de ce projet humanitaire » ?', '[{"id":"a","text":"souci"},{"id":"b","text":"écueil"},{"id":"c","text":"travers"},{"id":"d","text":"défaut"}]'::jsonb, 'b', 'Un « écueil » est un obstacle majeur qui menace de faire échouer l''entreprise : le mot juste pour le principal obstacle d''un projet. Un « souci » est une préoccupation morale ; un « travers » un petit défaut de caractère ; un « défaut » une imperfection — aucun ne dit l''obstacle redoutable.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('415a9ac0-824f-5ed5-a391-08f46ad199d2', 'bef4483d-ba9c-542d-96fa-961df0120393', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : nuances lexicales et paronymes', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('34b60314-5e50-5176-8c30-275a929fe8fb', '415a9ac0-824f-5ed5-a391-08f46ad199d2', 'Choisissez la phrase entièrement correcte du point de vue lexical.', '[{"id":"a","text":"Le juge lui a affligé une peine pour cette infraction."},{"id":"b","text":"Le juge lui a infligé une peine pour cette effraction."},{"id":"c","text":"Le juge lui a infligé une peine pour cette infraction."},{"id":"d","text":"Le juge lui a affligé une peine pour cette effraction."}]'::jsonb, 'c', 'Deux paronymes à trancher. On « inflige » une peine (et non on « afflige », qui veut dire accabler de chagrin). Le motif est ici une « infraction » = violation d''une loi ; l''« effraction » désignerait le fait de forcer une fermeture. Seule (c) cumule les deux choix exacts.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0eba131c-84d4-5369-9dbf-17e3b3cff1dc', '415a9ac0-824f-5ed5-a391-08f46ad199d2', 'Lisez : « Devant l''évolution de la conjecture économique, l''entreprise a revu ses prévisions. »
Cette phrase est-elle correcte ?', '[{"id":"a","text":"Oui, « conjecture » désigne bien la situation économique."},{"id":"b","text":"Non, il faut « conjoncture » : la situation, les circonstances du moment."},{"id":"c","text":"Non, il faut « inclinaison » économique."},{"id":"d","text":"Oui, les deux orthographes sont équivalentes."}]'::jsonb, 'b', 'La « conjoncture » désigne la situation d''ensemble à un moment donné (la conjoncture économique). La « conjecture » est une simple supposition : un faux sens ici. Les deux mots ne sont nullement équivalents, et « inclinaison » (un angle) n''a aucun rapport. Il faut donc « conjoncture ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3018eeeb-8eb1-5321-9f2d-b465c2f2c834', '415a9ac0-824f-5ed5-a391-08f46ad199d2', 'Complétez avec la nuance la plus juste : « Plutôt que de ___ le débat, il a préféré ___ la discussion par une boutade. »', '[{"id":"a","text":"clore / amorcer"},{"id":"b","text":"amorcer / clore"},{"id":"c","text":"inaugurer / entamer"},{"id":"d","text":"entamer / inaugurer"}]'::jsonb, 'a', 'La logique « plutôt que de [finir] le débat, il a préféré [ouvrir] la discussion » exige : « clore » (terminer) le débat, puis « amorcer » (enclencher, lancer) la discussion. L''inverse (amorcer / clore) prend le contre-pied du sens. « Inaugurer » et « entamer » ne rendent pas ce couple finir/lancer.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ac58c67-e2af-5bed-a935-0f296b66ad32', '415a9ac0-824f-5ed5-a391-08f46ad199d2', 'Quelle phrase emploie un mot dans une acception FAUTIVE (sens critiqué) ?', '[{"id":"a","text":"Il a su résoudre ce problème délicat."},{"id":"b","text":"Nous avons saisi cette occasion inespérée."},{"id":"c","text":"Le médecin a recouvré ses dossiers égarés."},{"id":"d","text":"Le dossier comporte une erreur conséquente."}]'::jsonb, 'd', 'Dans (d), « conséquente » est employée pour « importante, grave » — sens fautif. « Conséquent » signifie qui agit avec logique, ou qui suit logiquement ; il faudrait dire « une erreur importante ». Les autres sont justes : « résoudre » (et non solutionner), « occasion » (et non opportunité), « recouvrer » = retrouver.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30423337-f8bd-5163-97ad-645050cfeb11', '415a9ac0-824f-5ed5-a391-08f46ad199d2', 'Lisez : « Son discours interminable et redondant a lassé l''auditoire. »
Quel adjectif résume le mieux ce discours ?', '[{"id":"a","text":"prolifique"},{"id":"b","text":"prolixe"},{"id":"c","text":"éminent"},{"id":"d","text":"fortuit"}]'::jsonb, 'b', '« Prolixe » qualifie ce qui est trop long, bavard, diffus : exactement un discours interminable et redondant. « Prolifique » = qui produit beaucoup (d''œuvres), notion d''abondance féconde, non de longueur lassante. « Éminent » = remarquable ; « fortuit » = dû au hasard.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a99b0feb-161b-50b6-887e-a1090f102c72', '415a9ac0-824f-5ed5-a391-08f46ad199d2', 'Complétez avec le couple le plus précis : « Cet expert ___, dont la conférence est ___, fera salle comble malgré sa réputation de bavard. »', '[{"id":"a","text":"imminent / prolifique"},{"id":"b","text":"prodigue / fortuite"},{"id":"c","text":"éminent / imminente"},{"id":"d","text":"prolixe / éminente"}]'::jsonb, 'c', 'L''expert est « éminent » (remarquable, de premier plan) et sa conférence est « imminente » (sur le point d''avoir lieu) : le couple paronymique éminent/imminent y est testé directement. « Imminent » ne qualifie pas une personne ; « prodigue » = dépensier, « fortuit » = dû au hasard, « prolixe » = trop bavard, sans rapport ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('04a8d3f3-98db-5f6f-948b-de332c991cf9', 'bef4483d-ba9c-542d-96fa-961df0120393', 'francais-c2', '⭐⭐ Drill : nuances lexicales et paronymes', 2, 75, 15, 'practice', 'admin', 5)
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
  ('02bc95fb-fb43-579d-aa7c-b66b198f7ce1', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'Complétez : « Prends ce texte au sens ___ : ne cherche aucune métaphore. »', '[{"id":"a","text":"littéral"},{"id":"b","text":"littoral"},{"id":"c","text":"fallacieux"},{"id":"d","text":"fortuit"}]'::jsonb, 'a', '« Littéral » = pris à la lettre, au sens propre (une traduction littérale). « Littoral » est le bord de mer, la côte : un paronyme sans rapport. « Fallacieux » = trompeur ; « fortuit » = dû au hasard.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3658f0eb-8d84-579f-9c62-afa731e0bd44', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'Quel verbe convient : « Les députés ont décidé de ___ ce débat houleux en l''ajournant » ?', '[{"id":"a","text":"amorcer"},{"id":"b","text":"inaugurer"},{"id":"c","text":"entamer"},{"id":"d","text":"clore"}]'::jsonb, 'd', 'Ajourner un débat, c''est y mettre fin pour l''instant : « clore » convient. « Amorcer » = enclencher, « entamer » = commencer, « inaugurer » = ouvrir solennellement : ces trois verbes disent l''ouverture, à contresens d''un ajournement.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('515a9f9d-5035-54a7-97c3-6811363751e1', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'Complétez : « On a découvert une ___ entre les deux entreprises pour truquer les appels d''offres. »', '[{"id":"a","text":"collision"},{"id":"b","text":"collusion"},{"id":"c","text":"conjecture"},{"id":"d","text":"acception"}]'::jsonb, 'b', 'Une « collusion » est une entente secrète et frauduleuse au détriment d''autrui : truquer des appels d''offres en est l''exemple type. La « collision » est un choc physique. « Conjecture » = supposition ; « acception » = sens d''un mot.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d1d5861-935a-5364-9464-e11f8571c149', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'Quel mot exprime le mieux « mendier humblement une faveur » ?', '[{"id":"a","text":"quémander"},{"id":"b","text":"exiger"},{"id":"c","text":"réclamer"},{"id":"d","text":"perpétuer"}]'::jsonb, 'a', '« Quémander » = solliciter humblement, presque mendier, sans titre à exiger. « Exiger » = demander impérativement ; « réclamer » = demander avec insistance un dû. « Perpétuer » = faire durer, sans rapport avec une demande.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c35d2e8-47f5-55df-be93-7700050cbe49', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'Choisissez la phrase au français le plus soigné.', '[{"id":"a","text":"Nous devrons solutionner cette difficulté avant l''échéance."},{"id":"b","text":"Nous devrons perpétrer cette difficulté avant l''échéance."},{"id":"c","text":"Nous devrons recouvrir cette difficulté avant l''échéance."},{"id":"d","text":"Nous devrons résoudre cette difficulté avant l''échéance."}]'::jsonb, 'd', '« Résoudre une difficulté » est la formule juste et soutenue. « Solutionner » est familier et critiqué. « Perpétrer » = commettre un crime, « recouvrir » = couvrir : tous deux absurdes ici.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acafb664-8e02-5c2b-940b-e699b4d80a85', '04a8d3f3-98db-5f6f-948b-de332c991cf9', 'Complétez : « Le maire a ___ la nouvelle médiathèque en présence des élus. »', '[{"id":"a","text":"entamé"},{"id":"b","text":"amorcé"},{"id":"c","text":"inauguré"},{"id":"d","text":"évoqué"}]'::jsonb, 'c', '« Inaugurer » = ouvrir solennellement, en présence d''officiels (inaugurer un bâtiment). « Entamer » = commencer en attaquant une matière ; « amorcer » = enclencher un processus ; « évoquer » = mentionner. Seul « inaugurer » convient à une cérémonie d''ouverture.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d0036976-170b-5f9b-87a1-85d00ec11c80', '6a602350-e05c-55f5-a3c3-5ab41ff28f68', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('1b7738c5-704b-5377-9faa-faeb9d735906', 'd0036976-170b-5f9b-87a1-85d00ec11c80', 'Que signifie le proverbe « Qui trop embrasse mal étreint » ?', '[{"id":"a","text":"Qui entreprend trop de choses à la fois échoue dans toutes."},{"id":"b","text":"Qui aime trop fort finit par étouffer l''autre."},{"id":"c","text":"Il faut savoir saisir sa chance quand elle se présente."},{"id":"d","text":"La douceur obtient plus que la force."}]'::jsonb, 'a', '« Qui trop embrasse mal étreint » : « embrasser » a ici le sens ancien de « prendre dans ses bras, englober » ; vouloir tout englober, c''est mal tenir l''ensemble. L''option (b) prend l''image au pied de la lettre ; (c) et (d) sont d''autres sagesses sans rapport.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c3873bb-58c4-55a1-895b-23fc68a8ee3a', 'd0036976-170b-5f9b-87a1-85d00ec11c80', 'Dans « Il a réagi a priori, sans avoir examiné le dossier », que signifie « a priori » ?', '[{"id":"a","text":"Après une longue réflexion."},{"id":"b","text":"À contrecœur, malgré lui."},{"id":"c","text":"Au premier abord, avant tout examen."},{"id":"d","text":"En dernier recours, faute de mieux."}]'::jsonb, 'c', '« A priori » signifie « au premier abord, avant examen » ; le contexte « sans avoir examiné le dossier » le confirme. Son contraire est « a posteriori » (après coup), qui correspondrait plutôt à l''idée de (a).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b95e762e-4d17-5abf-9038-fb164d744551', 'd0036976-170b-5f9b-87a1-85d00ec11c80', 'Que désigne « le talon d''Achille » de quelqu''un ?', '[{"id":"a","text":"Son atout le plus précieux."},{"id":"b","text":"Son point faible, vulnérable."},{"id":"c","text":"Sa rapidité, son agilité."},{"id":"d","text":"Son orgueil démesuré."}]'::jsonb, 'b', 'Achille, invulnérable sauf au talon par lequel sa mère l''avait tenu, mourut d''une flèche reçue à cet endroit. « Le talon d''Achille » désigne donc le point faible. (a) en est l''inverse ; (c) et (d) détournent l''image.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe8d6d9b-7563-5728-9afc-38d69b41a32e', 'd0036976-170b-5f9b-87a1-85d00ec11c80', 'Quel proverbe conseille de ne pas se réjouir d''un avantage qu''on ne possède pas encore ?', '[{"id":"a","text":"Petit à petit l''oiseau fait son nid."},{"id":"b","text":"La nuit porte conseil."},{"id":"c","text":"Qui sème le vent récolte la tempête."},{"id":"d","text":"Il ne faut pas vendre la peau de l''ours avant de l''avoir tué."}]'::jsonb, 'd', '« Il ne faut pas vendre la peau de l''ours… » met en garde contre l''anticipation d''un gain incertain. (a) vante la persévérance, (b) le recul avant de décider, (c) les conséquences amplifiées d''un acte néfaste.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc644467-d6fe-52f0-89ed-1ab4f2837894', 'd0036976-170b-5f9b-87a1-85d00ec11c80', 'Dans « C''est une condition sine qua non de l''accord », que signifie « sine qua non » ?', '[{"id":"a","text":"Une condition secondaire, négociable."},{"id":"b","text":"Une condition indispensable, sans laquelle rien n''est possible."},{"id":"c","text":"Une condition provisoire, temporaire."},{"id":"d","text":"Une condition implicite, sous-entendue."}]'::jsonb, 'b', '« Sine qua non » signifie littéralement « sans laquelle non » : une condition absolument nécessaire, faute de laquelle la chose ne peut exister. Elle est donc tout sauf secondaire (a) ou provisoire (c).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e501d769-52f9-518f-8a35-8c7d0845f19c', '6a602350-e05c-55f5-a3c3-5ab41ff28f68', 'francais-c2', '⭐ Entraînement : expressions rares et proverbes', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c67fed1c-f516-5524-b295-30e4177a824f', 'e501d769-52f9-518f-8a35-8c7d0845f19c', 'Que signifie l''expression « rester de marbre » ?', '[{"id":"a","text":"Refuser obstinément de bouger de sa place."},{"id":"b","text":"Demeurer parfaitement impassible, sans émotion."},{"id":"c","text":"Garder le silence par timidité."},{"id":"d","text":"Être d''une grande froideur méprisante."}]'::jsonb, 'b', '« Rester de marbre », c''est rester impassible : comme une statue de marbre, on ne laisse paraître aucune émotion. (d) ajoute une nuance de mépris qui n''est pas dans l''expression ; (a) et (c) la prennent trop littéralement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abdfe6cc-6da9-5959-905c-12d4b6da43aa', 'e501d769-52f9-518f-8a35-8c7d0845f19c', 'Que conseille le proverbe « La nuit porte conseil » ?', '[{"id":"a","text":"Qu''il faut se méfier des décisions prises le soir."},{"id":"b","text":"Que les rêves annoncent l''avenir."},{"id":"c","text":"Que la solitude rend plus sage."},{"id":"d","text":"Qu''il vaut mieux attendre le lendemain pour décider."}]'::jsonb, 'd', '« La nuit porte conseil » invite à laisser passer une nuit, à prendre du recul avant de trancher : le sommeil et le temps éclairent la décision. (a) en inverse le sens ; (b) et (c) inventent d''autres idées.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00c13caa-7b80-58a6-a166-8415ef81aea4', 'e501d769-52f9-518f-8a35-8c7d0845f19c', 'Dans « Les secours sont arrivés in extremis », que signifie « in extremis » ?', '[{"id":"a","text":"Au tout dernier moment, de justesse."},{"id":"b","text":"En très grand nombre."},{"id":"c","text":"Avec beaucoup de retard."},{"id":"d","text":"Dans des conditions extrêmes."}]'::jsonb, 'a', '« In extremis » signifie « au dernier moment, de justesse ». On l''emploie quand une action réussit juste à temps. L''image d''« extrême » peut faire croire à (d), mais la locution porte sur le moment, pas sur les conditions.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01789126-f7cf-5a53-a578-d0ac204a9deb', 'e501d769-52f9-518f-8a35-8c7d0845f19c', 'Que signifie « se perdre en conjectures » ?', '[{"id":"a","text":"S''égarer dans un raisonnement trop savant."},{"id":"b","text":"Oublier le fil de sa pensée."},{"id":"c","text":"Multiplier les hypothèses sans aboutir à une certitude."},{"id":"d","text":"Hésiter par manque de courage."}]'::jsonb, 'c', 'Une « conjecture » est une supposition ; « se perdre en conjectures », c''est accumuler les hypothèses sans parvenir à savoir. (a) et (b) confondent avec une simple confusion d''idées ; (d) ajoute une idée de peur étrangère à l''expression.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c8288ab-3cb4-5a5d-8b2e-8e70168d14e6', 'e501d769-52f9-518f-8a35-8c7d0845f19c', 'Quel proverbe exprime l''idée que la persévérance et la patience finissent par payer ?', '[{"id":"a","text":"Qui trop embrasse mal étreint."},{"id":"b","text":"Petit à petit l''oiseau fait son nid."},{"id":"c","text":"La fortune sourit aux audacieux."},{"id":"d","text":"Qui sème le vent récolte la tempête."}]'::jsonb, 'b', '« Petit à petit l''oiseau fait son nid » valorise l''effort patient et régulier qui finit par aboutir. (a) met en garde contre la dispersion, (c) loue l''audace, (d) avertit des conséquences d''un acte néfaste : aucune n''évoque la patience.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ec82fea-cca5-5928-a7ed-88defed51d2a', 'e501d769-52f9-518f-8a35-8c7d0845f19c', 'Dans « Grosso modo, le projet coûtera un million », que signifie « grosso modo » ?', '[{"id":"a","text":"Au maximum, en comptant large."},{"id":"b","text":"Officiellement, selon le budget voté."},{"id":"c","text":"Dans le pire des cas."},{"id":"d","text":"En gros, approximativement."}]'::jsonb, 'd', '« Grosso modo » signifie « en gros, approximativement », sans précision. Ce n''est ni un plafond (a), ni un montant officiel (b), ni un scénario catastrophe (c) : c''est simplement une estimation grossière.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4880ac17-a96f-510d-b6dd-7b4f2f86c636', '6a602350-e05c-55f5-a3c3-5ab41ff28f68', 'francais-c2', '⭐⭐ Révision : locutions latines et culturèmes', 2, 75, 15, 'practice', 'admin', 2)
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
  ('5139259a-24ed-5924-8161-3c8781279ed1', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', 'Dans « Les parties ont fini par trouver un modus vivendi », que désigne « modus vivendi » ?', '[{"id":"a","text":"Une rupture définitive des relations."},{"id":"b","text":"Un mode de vie luxueux."},{"id":"c","text":"Un arrangement permettant de coexister malgré les désaccords."},{"id":"d","text":"Une décision imposée par une autorité."}]'::jsonb, 'c', '« Modus vivendi » (littéralement « manière de vivre ») désigne un compromis qui permet à des parties opposées de cohabiter. C''est l''inverse d''une rupture (a) ; ce n''est ni un train de vie (b) ni une imposition unilatérale (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52c268e0-22a7-5a06-b8e4-63e11ee29cf5', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', 'Que désigne « un travail de Romain » ?', '[{"id":"a","text":"Une tâche colossale, exigeant un effort considérable."},{"id":"b","text":"Un travail bâclé, fait à la hâte."},{"id":"c","text":"Une besogne répétitive et ennuyeuse."},{"id":"d","text":"Un ouvrage d''une grande finesse artistique."}]'::jsonb, 'a', 'L''expression renvoie aux grands ouvrages des Romains (routes, aqueducs) : « un travail de Romain » est une œuvre énorme et ardue. Elle ne dit rien de la qualité (d) ni de la monotonie (c), et certainement pas de la négligence (b).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01a30ce0-5d33-5bbc-ae3b-afc6b41e7980', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', 'Dans « De facto, c''est lui qui dirige l''entreprise, même sans titre officiel », que signifie « de facto » ?', '[{"id":"a","text":"Selon la loi, en droit."},{"id":"b","text":"Temporairement, en attendant mieux."},{"id":"c","text":"Avec l''accord de tous."},{"id":"d","text":"Dans les faits, en pratique."}]'::jsonb, 'd', '« De facto » signifie « de fait, dans la réalité », par opposition à « de jure » (« de droit »). Le contexte « même sans titre officiel » le confirme : la réalité prime sur la situation juridique (a).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32871165-1767-5bb5-8108-7b31719dd962', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', 'Que signifie « jeter feu et flamme » ?', '[{"id":"a","text":"Briller par son talent et son éclat."},{"id":"b","text":"Manifester une violente colère, s''emporter."},{"id":"c","text":"Prendre tous les risques sans réfléchir."},{"id":"d","text":"Détruire tout sur son passage."}]'::jsonb, 'b', '« Jeter feu et flamme », c''est exprimer une colère véhémente, fulminer. L''image du feu peut évoquer l''éclat (a) ou la destruction (d), mais l''expression figée vise précisément l''emportement furieux.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76ef132a-6f05-50ce-ba60-45a6467817a6', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', 'Dans « A fortiori, si même les experts échouent, un amateur n''a aucune chance », que marque « a fortiori » ?', '[{"id":"a","text":"À plus forte raison, avec une raison encore plus grande."},{"id":"b","text":"Par hasard, fortuitement."},{"id":"c","text":"En définitive, pour finir."},{"id":"d","text":"Contrairement à ce qu''on attendait."}]'::jsonb, 'a', '« A fortiori » introduit un argument plus fort encore : si une chose vaut dans un cas difficile, elle vaut à plus forte raison dans un cas plus facile. (b) confond avec « fortuit », (c) avec « in fine ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb0b778f-369e-5f8d-b4dc-3e80be8bfd32', '4880ac17-a96f-510d-b6dd-7b4f2f86c636', 'Que désigne « le supplice de Tantale » ?', '[{"id":"a","text":"Une douleur physique insupportable."},{"id":"b","text":"Une punition aussi longue qu''injuste."},{"id":"c","text":"La frustration d''un bien désiré, tout proche mais inaccessible."},{"id":"d","text":"Un châtiment exemplaire destiné à dissuader."}]'::jsonb, 'c', 'Tantale, condamné, voyait l''eau et les fruits se dérober dès qu''il les approchait. « Le supplice de Tantale » désigne précisément cette frustration d''un objet désiré, accessible en apparence mais toujours hors d''atteinte. (a), (b) et (d) évoquent la souffrance ou la punition en général, sans cette nuance d''inaccessibilité.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5438093c-fab8-52e4-8743-47f5cd3229a6', '6a602350-e05c-55f5-a3c3-5ab41ff28f68', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : pièges de sens et faux voisins', 3, 120, 30, 'boss', 'admin', 3)
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
  ('29da85aa-f2bf-5411-91ef-339ac5fb439d', '5438093c-fab8-52e4-8743-47f5cd3229a6', 'Que signifie « une victoire à la Pyrrhus » ?', '[{"id":"a","text":"Une victoire éclatante et glorieuse."},{"id":"b","text":"Une victoire obtenue par la ruse plutôt que par la force."},{"id":"c","text":"Une victoire facile, sans véritable adversaire."},{"id":"d","text":"Une victoire si coûteuse qu''elle équivaut presque à une défaite."}]'::jsonb, 'd', 'Le roi Pyrrhus battit Rome au prix de pertes telles qu''il aurait dit : « Encore une victoire comme celle-là et je suis perdu. » Une « victoire à la Pyrrhus » est donc ruineuse. Le piège courant est (a) : on croit à un triomphe alors que l''expression dit l''inverse.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90a9d83a-af1c-54fe-9e8a-47c33cad50b9', '5438093c-fab8-52e4-8743-47f5cd3229a6', 'Lequel de ces énoncés emploie « a posteriori » correctement ?', '[{"id":"a","text":"A posteriori, sans rien connaître du sujet, il a tranché aussitôt."},{"id":"b","text":"A posteriori, avec le recul, on comprend que la décision était la bonne."},{"id":"c","text":"A posteriori, c''est-à-dire en gros et sans précision, le coût sera élevé."},{"id":"d","text":"A posteriori, par pur hasard, ils se sont retrouvés au même endroit."}]'::jsonb, 'b', '« A posteriori » signifie « après coup, à la lumière de l''expérience » : (b) l''emploie correctement avec « avec le recul ». (a) décrit en fait « a priori », (c) confond avec « grosso modo », (d) avec « fortuitement ». Le piège courant est de confondre a priori (avant) et a posteriori (après).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9961e725-76b5-5511-bfe4-a452b7fd9b8c', '5438093c-fab8-52e4-8743-47f5cd3229a6', '« Ses avertissements répétés sont restés lettre morte : c''était _____. » Quelle expression complète le mieux la phrase ?', '[{"id":"a","text":"prêcher dans le désert"},{"id":"b","text":"tenir le haut du pavé"},{"id":"c","text":"battre la campagne"},{"id":"d","text":"couper la poire en deux"}]'::jsonb, 'a', '« Prêcher dans le désert », c''est parler sans être écouté ni suivi : cela colle à « avertissements restés lettre morte ». (b) signifie dominer, (c) divaguer, (d) faire un compromis — aucune ne rend l''idée d''un discours vain.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81135b83-6bcd-57c1-87a3-d80c88b56ba1', '5438093c-fab8-52e4-8743-47f5cd3229a6', 'Que signifie le proverbe « Qui sème le vent récolte la tempête » ?', '[{"id":"a","text":"Les efforts finissent toujours par être récompensés."},{"id":"b","text":"On ne peut rien contre les forces de la nature."},{"id":"c","text":"Celui qui provoque le désordre en subit des conséquences amplifiées."},{"id":"d","text":"Il faut agir au bon moment pour réussir."}]'::jsonb, 'c', 'Le proverbe avertit : provoquer un petit mal (« le vent ») entraîne un châtiment bien plus grand (« la tempête »). La clé est l''amplification. Le piège courant est (a), qui inverse le sens : ce proverbe vise une conséquence néfaste, non une récompense.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c3a4199-c6ec-5e1c-ad13-3808c7693891', '5438093c-fab8-52e4-8743-47f5cd3229a6', 'Dans « Le maintien du statu quo arrange les deux camps », que signifie « statu quo » ?', '[{"id":"a","text":"Un retour à la situation antérieure."},{"id":"b","text":"L''état actuel des choses, conservé sans changement."},{"id":"c","text":"Un nouvel équilibre négocié entre les parties."},{"id":"d","text":"Une réforme progressive et concertée."}]'::jsonb, 'b', '« Statu quo » (du latin « in statu quo ante », l''état où l''on était) désigne l''état présent maintenu tel quel. Le piège courant est (a) ou (c) : maintenir le statu quo, ce n''est ni revenir en arrière ni renégocier, c''est simplement ne rien changer.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfa11760-467f-54cf-b95c-41da696c0440', '5438093c-fab8-52e4-8743-47f5cd3229a6', '« Promettre la lune avant même d''avoir le contrat, c''est _____. » Quel proverbe complète le mieux la phrase ?', '[{"id":"a","text":"mettre la charrue avant les bœufs"},{"id":"b","text":"donner sa langue au chat"},{"id":"c","text":"vendre la peau de l''ours avant de l''avoir tué"},{"id":"d","text":"se perdre en conjectures"}]'::jsonb, 'c', 'Promettre un résultat avant d''avoir le contrat, c''est se prévaloir d''un gain non encore acquis : « vendre la peau de l''ours avant de l''avoir tué ». Le piège courant est (a), proche par l''idée de précipitation, mais qui vise l''ordre des étapes, non un avantage présumé ; (b) et (d) sont hors sujet.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d1976b79-1176-542a-b4bb-1aedef385be8', '6a602350-e05c-55f5-a3c3-5ab41ff28f68', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : la maîtrise du registre lettré', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b6c9c7e7-c64d-5760-ad27-4e5ea5048505', 'd1976b79-1176-542a-b4bb-1aedef385be8', 'Dans « Les mêmes principes s''appliquent, mutatis mutandis, aux PME », que signifie « mutatis mutandis » ?', '[{"id":"a","text":"En procédant aux adaptations nécessaires, toutes proportions gardées."},{"id":"b","text":"Sans la moindre modification, à l''identique."},{"id":"c","text":"À titre exceptionnel, par dérogation."},{"id":"d","text":"De manière purement théorique, sans application."}]'::jsonb, 'a', '« Mutatis mutandis » signifie « les choses qui doivent être changées ayant été changées » : on transpose en faisant les ajustements requis. Le piège courant est (b) : la locution implique justement des adaptations, et non une application à l''identique.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1ea4bec-e5eb-59d7-bc1f-4d99b909fb48', 'd1976b79-1176-542a-b4bb-1aedef385be8', '« Le ministre a démissionné : ipso facto, son cabinet a cessé d''exister. » Que marque ici « ipso facto » ?', '[{"id":"a","text":"Contre toute attente, de façon surprenante."},{"id":"b","text":"Après une longue procédure officielle."},{"id":"c","text":"Par le fait même, automatiquement et sans autre formalité."},{"id":"d","text":"Provisoirement, jusqu''à nouvel ordre."}]'::jsonb, 'c', '« Ipso facto » signifie « par le fait même » : un événement en entraîne un autre automatiquement, sans démarche supplémentaire. La démission fait tomber le cabinet d''elle-même. Le piège courant est (b) : la locution exclut justement toute procédure intermédiaire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebb511a3-47ae-5973-8a4f-8493499423b3', 'd1976b79-1176-542a-b4bb-1aedef385be8', 'Quelle phrase emploie « in fine » de façon correcte et idiomatique ?', '[{"id":"a","text":"In fine, c''est-à-dire dès le tout début du raisonnement, l''auteur pose sa thèse."},{"id":"b","text":"In fine, après bien des détours, la réforme aura surtout profité aux régions."},{"id":"c","text":"In fine, autrement dit de justesse et au dernier moment, ils ont signé."},{"id":"d","text":"In fine, soit approximativement et en gros, le bilan reste positif."}]'::jsonb, 'b', '« In fine » signifie « au bout du compte, finalement » : (b) l''emploie correctement après « bien des détours ». (a) la confond avec une idée de commencement, (c) avec « in extremis », (d) avec « grosso modo ». Le piège est de réduire « in fine » à « à la fin » au sens temporel strict.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('717e77f4-80c4-5027-9e5f-213b72d6a89d', 'd1976b79-1176-542a-b4bb-1aedef385be8', '« Ce détail, négligé de tous, fut le _____ qui les guida à travers l''enquête. » Quelle expression complète le mieux la phrase ?', '[{"id":"a","text":"cheval de Troie"},{"id":"b","text":"talon d''Achille"},{"id":"c","text":"supplice de Tantale"},{"id":"d","text":"fil d''Ariane"}]'::jsonb, 'd', 'Le « fil d''Ariane » est le guide qui permet de se repérer dans la complexité, comme le fil qui aida Thésée à sortir du labyrinthe : il convient à un détail qui guide l''enquête. (a) est une ruse cachée, (b) un point faible, (c) une frustration — aucun n''évoque un repère salvateur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c073006-f0c2-5a4c-b4ef-1ce95302eae8', 'd1976b79-1176-542a-b4bb-1aedef385be8', 'Lequel de ces énoncés constitue un emploi FAUTIF, à contresens, de la locution latine ?', '[{"id":"a","text":"Une comité ad hoc a été créé pour traiter ce dossier précis."},{"id":"b","text":"La transparence est une condition sine qua non de la confiance."},{"id":"c","text":"De facto signifie ici que la mesure est reconnue par la loi."},{"id":"d","text":"A priori, l''idée séduit, mais il faudra l''examiner de plus près."}]'::jsonb, 'c', '« De facto » signifie « de fait, dans la réalité », et s''oppose précisément à « de jure » (« reconnu par la loi ») : (c) lui donne donc le sens contraire. Les autres sont corrects : « ad hoc » = conçu pour un usage précis, « sine qua non » = indispensable, « a priori » = au premier abord. C''est une question d''intrus, où l''on cherche l''usage erroné.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d736a8ab-e4d0-5245-9a15-b333c6199bd1', 'd1976b79-1176-542a-b4bb-1aedef385be8', 'Que signifie « tenir le haut du pavé » ?', '[{"id":"a","text":"Occuper une position dominante, sociale ou professionnelle."},{"id":"b","text":"Défendre une position avec entêtement."},{"id":"c","text":"Mener une vie dissipée, dans la rue."},{"id":"d","text":"Refuser tout compromis dans une négociation."}]'::jsonb, 'a', 'Autrefois, le « haut du pavé » (la partie surélevée et sèche de la chaussée) revenait aux notables. « Tenir le haut du pavé », c''est donc occuper le premier rang, dominer. Le piège courant est (b), qui confond avec l''idée de fermeté, alors que l''expression vise le rang social.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('14ef6507-e3a2-5599-b083-3689c71135c3', '6a602350-e05c-55f5-a3c3-5ab41ff28f68', 'francais-c2', '⭐⭐ Drill : révision globale du chapitre', 2, 75, 15, 'practice', 'admin', 5)
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
  ('d18264f7-340d-5ae6-ba66-80c354e5a3db', '14ef6507-e3a2-5599-b083-3689c71135c3', 'Que signifie le proverbe « La fortune sourit aux audacieux » ?', '[{"id":"a","text":"La richesse rend les gens plus aimables."},{"id":"b","text":"Le hasard finit toujours par récompenser les patients."},{"id":"c","text":"Le succès récompense ceux qui osent prendre des risques."},{"id":"d","text":"Mieux vaut la prudence que la témérité."}]'::jsonb, 'c', 'Ce proverbe, hérité du latin « audaces fortuna juvat », encourage l''audace : c''est en osant qu''on s''attire la chance. (d) en dit l''inverse ; (a) joue sur l''autre sens de « fortune » (richesse) ; (b) substitue la patience à l''audace.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11d7916d-e00f-57d0-8192-70a431751bb8', '14ef6507-e3a2-5599-b083-3689c71135c3', 'Que signifie « battre la campagne » ?', '[{"id":"a","text":"Divaguer, déraisonner, parler à tort et à travers."},{"id":"b","text":"Parcourir la région en tous sens."},{"id":"c","text":"Mener une vie rurale et paisible."},{"id":"d","text":"Faire campagne pour une élection."}]'::jsonb, 'a', 'Au sens figuré et soutenu, « battre la campagne » veut dire divaguer, perdre le fil de sa raison. Le sens littéral (b) existe mais n''est pas celui visé ; (c) et (d) sont des contresens fondés sur le mot « campagne ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e89757ef-213d-5544-a348-9e9e7a3f41b1', '14ef6507-e3a2-5599-b083-3689c71135c3', 'Dans « Un dispositif ad hoc a été mis en place pour cette mission », que signifie « ad hoc » ?', '[{"id":"a","text":"Mis en place dans l''urgence."},{"id":"b","text":"Imposé d''en haut, sans concertation."},{"id":"c","text":"Provisoire et appelé à disparaître."},{"id":"d","text":"Conçu spécialement pour cet usage précis, approprié."}]'::jsonb, 'd', '« Ad hoc » signifie « pour cela », c''est-à-dire conçu sur mesure pour un objectif donné. La locution dit la pertinence et la spécialisation, non l''urgence (a), l''autorité (b) ou le caractère provisoire (c).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0e3d50c-3908-52a3-b366-b4cb98cd2d31', '14ef6507-e3a2-5599-b083-3689c71135c3', 'Que désigne « un cheval de Troie » au sens figuré ?', '[{"id":"a","text":"Un allié puissant et fidèle."},{"id":"b","text":"Une ruse pour s''introduire chez l''adversaire ; une menace dissimulée."},{"id":"c","text":"Un cadeau précieux et inattendu."},{"id":"d","text":"Un obstacle infranchissable."}]'::jsonb, 'b', 'Les Grecs offrirent aux Troyens un grand cheval de bois où se cachaient leurs soldats. « Un cheval de Troie » désigne donc un stratagème permettant de pénétrer une défense sous une apparence inoffensive. (c) ne retient que l''apparence du cadeau, en oubliant le piège.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21fb1302-b318-5dcb-8870-7be36088f371', '14ef6507-e3a2-5599-b083-3689c71135c3', 'Dans « C''est l''épée de Damoclès qui pèse sur l''entreprise », que désigne « l''épée de Damoclès » ?', '[{"id":"a","text":"Un danger imminent et permanent qui menace sans cesse."},{"id":"b","text":"Une arme décisive qui assure la victoire."},{"id":"c","text":"Une décision tranchée prise sans hésitation."},{"id":"d","text":"Une autorité injuste et tyrannique."}]'::jsonb, 'a', 'Damoclès dîna sous une épée suspendue à un crin de cheval : « l''épée de Damoclès » désigne une menace constante prête à s''abattre. (b) inverse l''image en avantage ; (c) joue sur « trancher » ; (d) glisse vers l''idée de tyrannie, absente de l''expression.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5835a413-b205-5bb8-9ca9-d631bd0cadbc', '14ef6507-e3a2-5599-b083-3689c71135c3', 'Que signifie « rendre l''âme » dans un registre soutenu ?', '[{"id":"a","text":"Se repentir sincèrement de ses fautes."},{"id":"b","text":"Avouer enfin la vérité."},{"id":"c","text":"Retrouver la paix intérieure."},{"id":"d","text":"Mourir ; par extension, cesser de fonctionner."}]'::jsonb, 'd', '« Rendre l''âme » signifie mourir, dans un registre soutenu ; on l''emploie aussi par plaisanterie pour un appareil qui tombe définitivement en panne. (a), (b) et (c) détournent vers des idées morales ou spirituelles étrangères à l''expression.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dba9a1b2-605a-5068-9a70-206a2585d88c', '0be341fe-de5b-56f6-b5a9-2515a1056d1d', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('517085e6-1be2-5d00-83bf-bd1c26b85eb9', 'dba9a1b2-605a-5068-9a70-206a2585d88c', 'Dans « Certes, ce projet est ambitieux, mais ses risques sont trop grands », quel procédé l''auteur emploie-t-il ?', '[{"id":"a","text":"Une concession rhétorique : il admet un point pour mieux le réfuter."},{"id":"b","text":"Une analogie entre deux situations comparables."},{"id":"c","text":"Une prétérition : il feint de taire ce qu''il dit."},{"id":"d","text":"Un argument d''autorité appuyé sur un expert."}]'::jsonb, 'a', 'La structure « certes… mais… » est la marque de la concession rhétorique : on accorde un point à l''adversaire (le projet est ambitieux) pour mieux imposer sa propre thèse (les risques l''emportent). L''auteur ne change pas d''avis. Ce n''est ni une analogie (aucune comparaison), ni une prétérition (rien n''est feint comme tu), ni un argument d''autorité (aucun expert invoqué).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa7a8b58-2f70-5928-939f-eeac05d21c88', 'dba9a1b2-605a-5068-9a70-206a2585d88c', '« Faut-il vraiment rappeler que la liberté est notre bien le plus précieux ? » De quel procédé s''agit-il ?', '[{"id":"a","text":"Une modalisation qui atténue l''affirmation."},{"id":"b","text":"Une question rhétorique dont la réponse est imposée."},{"id":"c","text":"Une véritable question posée pour obtenir une information."},{"id":"d","text":"Un contre-exemple qui réfute une règle générale."}]'::jsonb, 'b', 'C''est une question rhétorique : une fausse question dont la réponse (« non, c''est évident ») est déjà imposée au lecteur. Elle sert à faire adhérer sans démontrer. Ce n''est pas une vraie question (on n''attend aucune information), ni une modalisation (qui nuancerait au lieu d''affirmer), ni un contre-exemple.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d176cc0e-8c39-5a9f-a41e-8310a637c23f', 'dba9a1b2-605a-5068-9a70-206a2585d88c', 'Quelle est la différence entre convaincre et persuader ?', '[{"id":"a","text":"Convaincre s''adresse à un groupe, persuader à une seule personne."},{"id":"b","text":"Convaincre est oral, persuader est écrit."},{"id":"c","text":"Convaincre emporte l''adhésion par la raison et les preuves ; persuader, par les émotions."},{"id":"d","text":"Les deux termes sont strictement synonymes en rhétorique."}]'::jsonb, 'c', 'Convaincre, c''est l''emporter par la raison, la logique et les preuves ; persuader, c''est l''emporter par les émotions et l''adhésion affective. La distinction ne tient ni au nombre de destinataires, ni au canal oral/écrit, et les deux termes ne sont pas synonymes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad84820c-1a8e-5c66-badd-db1b850d87d8', 'dba9a1b2-605a-5068-9a70-206a2585d88c', '« Deux députés ont menti, donc tous les politiciens sont des menteurs. » Quel défaut de raisonnement reconnais-tu ?', '[{"id":"a","text":"Un argument valable fondé sur des preuves suffisantes."},{"id":"b","text":"Une généralisation hâtive : trop peu de cas pour conclure une règle."},{"id":"c","text":"Une modalisation prudente de la pensée."},{"id":"d","text":"Une analogie éclairante entre deux domaines."}]'::jsonb, 'b', 'Conclure une règle générale (« tous les politiciens ») à partir de deux cas seulement est une généralisation hâtive : les prémisses sont trop maigres pour la conclusion. Ce n''est pas un argument valable (les preuves sont insuffisantes), ni une modalisation (rien n''est nuancé, au contraire), ni une analogie.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41a660dc-374e-5370-9bc2-17733238a21b', 'dba9a1b2-605a-5068-9a70-206a2585d88c', '« Quel héros tu fais, à fuir au premier danger ! » De quel procédé s''agit-il ?', '[{"id":"a","text":"Un argument d''autorité."},{"id":"b","text":"Une question rhétorique."},{"id":"c","text":"Une ironie par antiphrase : on loue en mots pour blâmer en réalité."},{"id":"d","text":"Une concession rhétorique."}]'::jsonb, 'c', 'L''éloge apparent (« héros ») contredit le contexte (fuir lâchement) : c''est l''ironie, dont le moteur est l''antiphrase — dire le contraire de ce qu''on pense pour railler et disqualifier. Ce n''est pas un argument d''autorité (aucun expert), ni une question (la phrase est exclamative), ni une concession.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1c16b823-5995-5687-94c6-32ac14891500', '0be341fe-de5b-56f6-b5a9-2515a1056d1d', 'francais-c2', '⭐ Entraînement : rhétorique et argumentation', 1, 50, 10, 'practice', 'admin', 1)
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
  ('b2a43027-007e-586a-be80-9cf06b62b8a6', '1c16b823-5995-5687-94c6-32ac14891500', 'Quelle est la fonction première d''une question rhétorique ?', '[{"id":"a","text":"Obtenir une information précise de l''interlocuteur."},{"id":"b","text":"Faire adhérer le lecteur en imposant une réponse qui semble évidente."},{"id":"c","text":"Nuancer son propos en prenant ses distances."},{"id":"d","text":"Citer un expert pour appuyer sa thèse."}]'::jsonb, 'b', 'La question rhétorique est une fausse question : elle n''attend aucune réponse mais impose celle qui paraît évidente, afin d''emporter l''adhésion sans démontrer. Elle n''a pas pour but d''obtenir une information (a), de nuancer (c, qui décrit la modalisation), ni de citer une autorité (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('164f5838-63af-51a0-8648-dffc1c08c1a9', '1c16b823-5995-5687-94c6-32ac14891500', 'Dans « Je ne parlerai pas de ses dettes, ni de ses mensonges passés », quel procédé est employé ?', '[{"id":"a","text":"La modalisation, car l''auteur atténue ses propos."},{"id":"b","text":"La concession rhétorique, car il accorde un point à l''adversaire."},{"id":"c","text":"La prétérition, car il évoque ce qu''il prétend taire."},{"id":"d","text":"L''analogie, car il compare deux situations."}]'::jsonb, 'c', 'La prétérition consiste à affirmer qu''on va passer une chose sous silence… tout en l''énonçant (« je ne parlerai pas de… »). L''effet est de dire malgré tout. Ce n''est pas une modalisation (rien n''est atténué), ni une concession (on n''accorde rien), ni une analogie (aucune comparaison).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('382263c1-c0fd-5fbd-b72f-c113038cf930', '1c16b823-5995-5687-94c6-32ac14891500', '« La science a tranché la question depuis longtemps. » Quel procédé cette phrase illustre-t-elle ?', '[{"id":"a","text":"L''argument d''autorité, qui s''appuie sur le prestige d''une instance reconnue."},{"id":"b","text":"Le contre-exemple, qui réfute une règle générale."},{"id":"c","text":"L''ironie, qui dit le contraire de ce qu''elle pense."},{"id":"d","text":"Le faux dilemme, qui réduit à deux options."}]'::jsonb, 'a', 'Invoquer « la science » comme instance qui aurait « tranché » est un argument d''autorité : on appuie sa thèse sur le prestige d''une autorité reconnue plutôt que sur une preuve détaillée. Ce n''est pas un contre-exemple, ni de l''ironie (aucun décalage), ni un faux dilemme (aucune alternative posée).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d5df013-b9bd-5760-b30b-4eb446d3206f', '1c16b823-5995-5687-94c6-32ac14891500', '« Diriger une entreprise, c''est comme mener une armée au combat. » De quel procédé s''agit-il ?', '[{"id":"a","text":"Une prétérition."},{"id":"b","text":"Une analogie qui rapproche deux situations pour éclairer le propos."},{"id":"c","text":"Une question rhétorique."},{"id":"d","text":"Une pétition de principe."}]'::jsonb, 'b', 'L''analogie rapproche deux domaines (l''entreprise et l''armée) pour rendre l''abstrait concret et convaincre par la ressemblance. Ce n''est pas une prétérition (rien n''est feint comme tu), ni une question (la phrase est affirmative), ni une pétition de principe (aucun raisonnement circulaire).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ecdd3d3-e349-5c73-8fe7-52c169056eec', '1c16b823-5995-5687-94c6-32ac14891500', 'Quelle expression est une marque typique de la modalisation ?', '[{"id":"a","text":"« C''est une certitude absolue. »"},{"id":"b","text":"« Il est prouvé sans la moindre exception que… »"},{"id":"c","text":"« Il semblerait que la situation s''améliore. »"},{"id":"d","text":"« Tous, sans exception, le savent. »"}]'::jsonb, 'c', 'La modalisation exprime le degré d''engagement de l''auteur : « il semblerait que » atténue l''affirmation et marque une prudence. Les options (a), (b) et (d) affirment au contraire avec une certitude maximale — c''est l''inverse de la modalisation, qui nuance et prend ses distances.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d059e50-77e7-5ce6-92ea-72d9c3235dbe', '1c16b823-5995-5687-94c6-32ac14891500', '« Ton idée ne vaut rien : de toute façon, tu n''as jamais réussi quoi que ce soit. » Quel défaut reconnais-tu ?', '[{"id":"a","text":"Un argument d''autorité légitime."},{"id":"b","text":"Une concession rhétorique."},{"id":"c","text":"Une modalisation prudente."},{"id":"d","text":"Un argument ad hominem : on attaque la personne, non son idée."}]'::jsonb, 'd', 'L''argument ad hominem vise la personne (« tu n''as jamais réussi ») au lieu de discuter l''idée elle-même : c''est un sophisme, car le passé de quelqu''un ne dit rien de la valeur de son raisonnement. Ce n''est pas un argument d''autorité, ni une concession (on n''accorde rien), ni une modalisation (rien n''est nuancé).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a2dc286e-a836-5858-a9f7-ff96cec7a61f', '0be341fe-de5b-56f6-b5a9-2515a1056d1d', 'francais-c2', '⭐⭐ Révision : rhétorique et argumentation', 2, 75, 15, 'practice', 'admin', 2)
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
  ('d6307a65-9b23-58f9-8084-88be053e06d0', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', '« Soit tu es avec nous, soit tu es contre nous. » Quel sophisme reconnais-tu ?', '[{"id":"a","text":"Le faux dilemme : on réduit à deux options alors qu''il en existe d''autres."},{"id":"b","text":"La pente glissante : un premier pas mène à une catastrophe."},{"id":"c","text":"L''homme de paille : on déforme la thèse adverse."},{"id":"d","text":"La pétition de principe : on suppose acquis ce qu''il faut prouver."}]'::jsonb, 'a', 'Réduire artificiellement le choix à deux possibilités exclusives (avec/contre), alors qu''une position nuancée ou neutre existe, est un faux dilemme. La pente glissante prédit une chaîne fatale ; l''homme de paille caricature l''adversaire ; la pétition de principe tourne en rond — aucun ne correspond ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85a0aaf6-fe4a-5dad-8125-c43eda16ec69', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', 'Quelle est la fonction de la concession rhétorique dans « Certes, il est talentueux, mais il manque de rigueur » ?', '[{"id":"a","text":"Renoncer à sa propre thèse au profit de celle de l''adversaire."},{"id":"b","text":"Désamorcer une objection prévisible pour mieux imposer sa thèse."},{"id":"c","text":"Poser une question dont la réponse est imposée."},{"id":"d","text":"Illustrer la thèse par un exemple concret."}]'::jsonb, 'b', 'En accordant d''abord un point (« certes, talentueux »), l''auteur désamorce l''objection prévisible et paraît équitable, ce qui rend plus convaincante la réfutation qui suit (« mais… rigueur »). Il ne renonce pas à sa thèse (a) : la concession est un tremplin. Ce n''est ni une question rhétorique (c) ni un exemple (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e4ea578-2878-558d-8e79-9b7e25a16419', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', '« Tu veux baisser les impôts ? Donc tu veux supprimer les hôpitaux et les écoles ! » Quel sophisme est commis ?', '[{"id":"a","text":"L''argument d''autorité."},{"id":"b","text":"Le contre-exemple."},{"id":"c","text":"La concession rhétorique."},{"id":"d","text":"L''homme de paille : on déforme la thèse adverse en une version caricaturale."}]'::jsonb, 'd', 'On remplace la thèse réelle (baisser les impôts) par une caricature facile à abattre (supprimer hôpitaux et écoles), puis on réfute cette caricature : c''est l''homme de paille. Ce n''est pas un argument d''autorité, ni un contre-exemple (aucune règle réfutée), ni une concession (on n''accorde rien à l''adversaire).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2f8a20c-0fc6-5fdf-97fd-5895b656d170', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', 'Quelle phrase repose sur un argument valable plutôt que sur un sophisme ?', '[{"id":"a","text":"« Ce médicament est efficace : trois essais cliniques contrôlés le confirment. »"},{"id":"b","text":"« Ce médicament est efficace : mon voisin va beaucoup mieux. »"},{"id":"c","text":"« Ce médicament est efficace, car il l''est, c''est bien connu. »"},{"id":"d","text":"« Ce médicament est efficace : son détracteur est un charlatan. »"}]'::jsonb, 'a', 'L''option (a) fonde la conclusion sur des preuves suffisantes et pertinentes (essais cliniques contrôlés) : c''est un argument valable. (b) est une généralisation hâtive (un seul cas), (c) une pétition de principe (raisonnement circulaire), (d) un ad hominem (attaque de la personne).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18dc6456-fda1-5e7c-8b86-e50cc3856bae', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', '« Si on autorise les trottinettes, bientôt les voitures rouleront sur les trottoirs et ce sera le chaos. » Quel sophisme reconnais-tu ?', '[{"id":"a","text":"Le faux dilemme."},{"id":"b","text":"La pente glissante : un premier pas mènerait fatalement à une catastrophe."},{"id":"c","text":"La pétition de principe."},{"id":"d","text":"L''analogie valable."}]'::jsonb, 'b', 'Prétendre qu''une mesure limitée déclenchera une chaîne inévitable de conséquences désastreuses, sans le démontrer, est la pente glissante. Ce n''est pas un faux dilemme (aucune alternative binaire), ni une pétition de principe (pas de circularité), ni une analogie (aucune comparaison entre deux domaines).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2c107fe-74b1-5b7d-b9dc-a9190fedef5c', 'a2dc286e-a836-5858-a9f7-ff96cec7a61f', '« Un seul cygne noir suffit à prouver que l''affirmation « tous les cygnes sont blancs » est fausse. » Quel procédé est ici en jeu ?', '[{"id":"a","text":"L''exemple, qui illustre et appuie une thèse."},{"id":"b","text":"La modalisation, qui nuance l''affirmation."},{"id":"c","text":"Le contre-exemple, qui réfute une affirmation générale par un cas unique."},{"id":"d","text":"L''argument d''autorité, qui invoque un expert."}]'::jsonb, 'c', 'Un cas unique (le cygne noir) suffit à invalider une affirmation universelle (« tous les cygnes sont blancs ») : c''est la fonction du contre-exemple. À l''inverse, l''exemple (a) appuie une thèse au lieu de la détruire. Ce n''est ni une modalisation (b) ni un argument d''autorité (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('96949afd-bfcf-595f-9954-5cad364bbcae', '0be341fe-de5b-56f6-b5a9-2515a1056d1d', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : rhétorique et argumentation', 3, 120, 30, 'boss', 'admin', 3)
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
  ('4234b99d-8aaa-5b20-961d-952e82a8e724', '96949afd-bfcf-595f-9954-5cad364bbcae', '« Il semblerait que cette politique ait eu quelques effets positifs ; reste à savoir s''ils dureront. » Quelle est la fonction dominante de cet énoncé ?', '[{"id":"a","text":"Disqualifier l''adversaire en l''attaquant personnellement."},{"id":"b","text":"Nuancer le propos par la modalisation et la prudence."},{"id":"c","text":"Imposer une réponse par une question rhétorique."},{"id":"d","text":"Réfuter totalement la thèse adverse."}]'::jsonb, 'b', '« Il semblerait que », « quelques », « reste à savoir » sont des marques de modalisation : l''auteur affirme avec prudence et prend ses distances, sans nier ni attaquer. La fonction est donc de nuancer. Aucun adversaire n''est attaqué (a), aucune question n''est posée (c), et la thèse n''est pas réfutée mais tempérée (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93ccd740-b73b-5b7b-afe8-e662df87e015', '96949afd-bfcf-595f-9954-5cad364bbcae', 'Un orateur déclare : « Nos opposants prétendent qu''il faut tout réguler ; or réguler à l''excès, c''est étouffer la liberté. » Pourquoi ce raisonnement est-il fautif ?', '[{"id":"a","text":"Il est valable : il réfute correctement la thèse adverse."},{"id":"b","text":"C''est une pétition de principe : la conclusion est posée d''avance."},{"id":"c","text":"C''est un homme de paille : la thèse adverse (réguler) est déformée en « tout réguler à l''excès »."},{"id":"d","text":"C''est une modalisation excessive."}]'::jsonb, 'c', 'La position adverse (« réguler ») est gonflée en une version extrême et caricaturale (« tout réguler à l''excès »), plus facile à abattre : c''est l''homme de paille. Le raisonnement n''est donc pas valable (a). Il n''y a pas de circularité (b), et il ne s''agit pas de modalisation (d), qui nuancerait au lieu de déformer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c906072-4b3a-5068-b030-364111b91785', '96949afd-bfcf-595f-9954-5cad364bbcae', '« Bravo, vraiment, quelle brillante idée d''avoir tout misé sur un seul fournisseur ! » Quels procédé ET fonction sont combinés ?', '[{"id":"a","text":"Ironie par antiphrase, dont la fonction est de disqualifier la décision en la raillant."},{"id":"b","text":"Argument d''autorité, dont la fonction est d''appuyer par le prestige."},{"id":"c","text":"Concession rhétorique, dont la fonction est de désamorcer une objection."},{"id":"d","text":"Analogie, dont la fonction est de rendre l''abstrait concret."}]'::jsonb, 'a', 'L''éloge apparent (« brillante idée ») contredit le contexte (un choix risqué) : c''est l''ironie par antiphrase, qui sert ici à disqualifier la décision en la tournant en dérision. Il n''y a ni autorité invoquée (b), ni concession « certes… mais » (c), ni comparaison entre deux domaines (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('455b3c1c-bc24-504b-896c-118c872b89f6', '96949afd-bfcf-595f-9954-5cad364bbcae', 'Quel énoncé contient une pétition de principe (raisonnement circulaire) ?', '[{"id":"a","text":"« Ce témoin est fiable, car son récit concorde avec trois preuves matérielles. »"},{"id":"b","text":"« Ce témoin est fiable, parce qu''il dit la vérité — et il dit la vérité parce qu''il est fiable. »"},{"id":"c","text":"« Ce témoin est fiable selon l''expert mandaté par le tribunal. »"},{"id":"d","text":"« Ce témoin est fiable, certes nerveux, mais cohérent du début à la fin. »"}]'::jsonb, 'b', 'L''option (b) tourne en rond : la fiabilité prouve la vérité, et la vérité prouve la fiabilité — chaque terme s''appuie sur l''autre sans preuve extérieure. C''est la pétition de principe. (a) repose sur des preuves matérielles (argument valable), (c) est un argument d''autorité, (d) une concession rhétorique.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c63ea07-82af-5014-968c-102c61255bb3', '96949afd-bfcf-595f-9954-5cad364bbcae', '« Comment pourrions-nous, en conscience, tourner le dos à ceux qui souffrent ? » Quels procédé ET fonction sont à l''œuvre ?', '[{"id":"a","text":"Prétérition ; fonction : taire en feignant de parler."},{"id":"b","text":"Faux dilemme ; fonction : réduire le choix à deux options."},{"id":"c","text":"Contre-exemple ; fonction : réfuter une généralisation."},{"id":"d","text":"Question rhétorique ; fonction : persuader en sollicitant l''émotion morale du lecteur."}]'::jsonb, 'd', 'La fausse question impose sa réponse (« non, nous ne le pouvons pas ») et joue sur l''émotion morale : c''est une question rhétorique à visée persuasive (par l''affect, non par la preuve). La prétérition feint de taire (a), le faux dilemme impose deux options (b), le contre-exemple réfute une règle (c) — aucun ici.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9eef389b-71db-579d-9cfd-ba9876db1e6b', '96949afd-bfcf-595f-9954-5cad364bbcae', '« Tous nos concurrents échouent à cause d''une mauvaise gestion. Prenez Alpha : elle a fait faillite l''an dernier. » Quel défaut affecte ce raisonnement ?', '[{"id":"a","text":"Aucun : l''exemple Alpha prouve rigoureusement la règle générale."},{"id":"b","text":"Une concession rhétorique mal placée."},{"id":"c","text":"Une généralisation hâtive : un seul exemple ne prouve pas une règle valant pour tous."},{"id":"d","text":"Une modalisation insuffisante."}]'::jsonb, 'c', 'Un exemple unique (Alpha) ne suffit pas à établir une règle universelle (« tous… à cause d''une mauvaise gestion ») : conclure ainsi est une généralisation hâtive — l''exemple illustre, il ne démontre pas une loi générale. Le raisonnement n''est donc pas rigoureux (a) ; il ne s''agit ni d''une concession (b) ni d''un défaut de modalisation (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fd3b0978-3ce5-5045-afdf-dc3cd01acf24', '0be341fe-de5b-56f6-b5a9-2515a1056d1d', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : rhétorique et argumentation', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('9cfc6e68-a1ae-55bd-8667-0c70d8f48eb1', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', '« Je laisse de côté ses innombrables manquements, sur lesquels il serait trop long de s''étendre, pour ne retenir que ce dernier scandale. » Quel procédé structure cette phrase, et quelle en est la fonction ?', '[{"id":"a","text":"Une modalisation, qui atténue la charge contre l''adversaire."},{"id":"b","text":"Une prétérition, qui évoque les fautes en feignant de les passer sous silence pour les rendre présentes à l''esprit."},{"id":"c","text":"Une concession rhétorique, qui accorde un point avant de réfuter."},{"id":"d","text":"Une analogie, qui éclaire par une comparaison."}]'::jsonb, 'b', 'Annoncer qu''on « laisse de côté » des fautes tout en les nommant est la prétérition : elle insinue et accable l''adversaire sous couvert de discrétion. Ce n''est pas une modalisation (rien n''est atténué : l''accusation est appuyée), ni une concession « certes… mais » (a/c), ni une analogie (aucune comparaison, d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1d0d1c4-503f-5306-b68e-b0333f5eb26f', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', 'Un débatteur affirme : « Mon adversaire n''a aucune légitimité à parler d''écologie : il prend l''avion. Sa proposition de taxe carbone est donc absurde. » Quel est précisément le vice de ce raisonnement ?', '[{"id":"a","text":"Aucun : l''incohérence personnelle invalide bien la proposition."},{"id":"b","text":"Un faux dilemme, car deux options seulement sont posées."},{"id":"c","text":"Un ad hominem (ici tu quoque) : l''incohérence de la personne ne dit rien de la valeur de sa proposition."},{"id":"d","text":"Une pétition de principe, car la conclusion est supposée d''avance."}]'::jsonb, 'c', 'Conclure de l''incohérence personnelle de l''auteur (il prend l''avion) à la fausseté de sa thèse (la taxe carbone) est un ad hominem dans sa variante « tu quoque » : on vise la personne, pas l''argument. Le comportement de l''orateur ne change rien à la valeur logique de la proposition (a est donc faux). Ce n''est ni un faux dilemme (b) ni une pétition de principe (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09e65d1a-ab8c-557c-8561-20e7576b247d', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', '« Certes, certains diront que la liberté d''expression a des limites — et ils n''ont pas tort en théorie ; mais qui, sérieusement, accepterait qu''on bâillonne la presse ? » Quels DEUX procédés successifs sont enchaînés ?', '[{"id":"a","text":"Une analogie, puis un argument d''autorité."},{"id":"b","text":"Une concession rhétorique (certes… n''ont pas tort), puis une question rhétorique (qui accepterait… ?)."},{"id":"c","text":"Une prétérition, puis un contre-exemple."},{"id":"d","text":"Une modalisation, puis un faux dilemme."}]'::jsonb, 'b', 'L''énoncé concède d''abord un point à l''adversaire (« certes… ils n''ont pas tort ») — concession rhétorique — puis bascule par une question rhétorique (« qui accepterait… ? ») dont la réponse (« personne ») est imposée pour emporter l''adhésion. Il n''y a ni analogie/autorité (a), ni prétérition/contre-exemple (c), ni faux dilemme (d) : la limite n''est pas réduite à deux options.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ecbe3c3-423b-5a35-9643-d524685905d0', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', 'Parmi ces quatre répliques à la thèse « il faut investir dans l''éducation », laquelle est un argument valable, et non un sophisme ?', '[{"id":"a","text":"« Investir dans l''éducation ? Donc vous voulez ruiner l''État en dépenses inutiles ! »"},{"id":"b","text":"« C''est vous qui le dites, et vous n''avez même pas fait d''études. »"},{"id":"c","text":"« Investir dans l''éducation est justifié : les pays qui l''ont fait montrent, données à l''appui, une hausse durable de leur productivité. »"},{"id":"d","text":"« Soit on investit tout dans l''éducation, soit on accepte la décadence du pays. »"}]'::jsonb, 'c', 'L''option (c) fonde la conclusion sur des preuves comparatives et chiffrées : c''est un argument valable. (a) est un homme de paille (la thèse est caricaturée en « ruiner l''État »), (b) un ad hominem (attaque de la personne), (d) un faux dilemme (deux options extrêmes posées comme seules possibles).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f0624cd-f0f2-53d9-86ba-f6b975c3ceff', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', '« Si nous tolérons une seule exception au règlement, plus personne ne le respectera, l''institution perdra toute autorité, et ce sera l''anarchie complète. » Pourquoi ce raisonnement, bien que persuasif, n''est-il pas valable ?', '[{"id":"a","text":"C''est une pente glissante : la chaîne catastrophique est affirmée sans être démontrée."},{"id":"b","text":"C''est une concession rhétorique, valable car elle admet un point adverse."},{"id":"c","text":"C''est un argument d''autorité, valable car il invoque l''institution."},{"id":"d","text":"C''est un contre-exemple, valable car il réfute une règle générale."}]'::jsonb, 'a', 'Le raisonnement enchaîne une cascade de conséquences extrêmes (une exception → désobéissance générale → perte d''autorité → anarchie) sans prouver chaque maillon : c''est la pente glissante, un sophisme rhétoriquement efficace mais logiquement infondé. Ce n''est ni une concession (b), ni un argument d''autorité (c), ni un contre-exemple (d) — et aucun de ces trois n''est ici « valable ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e0b8c5a-c99e-5899-8213-7c362b5b937e', 'fd3b0978-3ce5-5045-afdf-dc3cd01acf24', '« La démocratie est le meilleur régime, car le meilleur régime est nécessairement celui qui repose sur le peuple — et c''est précisément la démocratie. » Quel sophisme se cache sous cette formulation soignée ?', '[{"id":"a","text":"Une généralisation hâtive."},{"id":"b","text":"Un homme de paille."},{"id":"c","text":"Une analogie trompeuse."},{"id":"d","text":"Une pétition de principe : la conclusion à prouver est déjà supposée dans les prémisses."}]'::jsonb, 'd', 'La démonstration tourne en cercle : on définit « le meilleur régime » comme celui qui repose sur le peuple (donc la démocratie), pour conclure que la démocratie est le meilleur régime — la conclusion est cachée dans la prémisse. C''est la pétition de principe. Il n''y a ni induction sur des cas (a), ni déformation d''une thèse adverse (b), ni comparaison entre deux domaines (c).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d773b1d7-0da3-5339-a823-ba164e20abea', '0be341fe-de5b-56f6-b5a9-2515a1056d1d', 'francais-c2', '⭐⭐ Drill : rhétorique et argumentation', 2, 75, 15, 'practice', 'admin', 5)
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
  ('76b225c2-3c23-51e3-a1e3-041025cb9fa3', 'd773b1d7-0da3-5339-a823-ba164e20abea', '« On ne peut nier que l''adversaire a du métier ; reste qu''il se trompe lourdement sur le fond. » Quel procédé reconnais-tu ?', '[{"id":"a","text":"Une concession rhétorique, qui accorde un point pour mieux réfuter ensuite."},{"id":"b","text":"Une prétérition, qui feint de taire ce qu''elle dit."},{"id":"c","text":"Une question rhétorique."},{"id":"d","text":"Un argument d''autorité."}]'::jsonb, 'a', '« On ne peut nier que… reste que… » est une variante de la concession rhétorique : on admet un point (le métier de l''adversaire) avant de le réfuter sur le fond. Ce n''est pas une prétérition (rien n''est feint comme tu), ni une question rhétorique, ni un argument d''autorité.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c141b206-3bfc-5dcb-b3f7-856fcdaf28d3', 'd773b1d7-0da3-5339-a823-ba164e20abea', '« Vous prétendez que ce vin est bon parce qu''il est cher, et qu''il est cher parce qu''il est bon. » Quel défaut de raisonnement est dénoncé ?', '[{"id":"a","text":"Une généralisation hâtive."},{"id":"b","text":"Une pente glissante."},{"id":"c","text":"Une pétition de principe : chaque terme se justifie par l''autre, sans preuve extérieure."},{"id":"d","text":"Un ad hominem."}]'::jsonb, 'c', 'Le raisonnement est circulaire : le prix prouve la qualité et la qualité prouve le prix, sans aucune preuve indépendante — c''est la pétition de principe. Ce n''est pas une généralisation hâtive (aucune induction sur des cas), ni une pente glissante (aucune chaîne de conséquences), ni un ad hominem (aucune attaque de personne).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc0006a8-c7b9-53fa-b10e-bfcf8d5a2c06', 'd773b1d7-0da3-5339-a823-ba164e20abea', 'Quelle est la différence de fonction entre l''ironie et la modalisation ?', '[{"id":"a","text":"L''ironie nuance l''affirmation ; la modalisation raille l''adversaire."},{"id":"b","text":"L''ironie disqualifie en disant le contraire de ce qu''on pense ; la modalisation nuance en marquant la prudence."},{"id":"c","text":"Les deux servent à donner un exemple concret."},{"id":"d","text":"L''ironie impose une réponse ; la modalisation invoque une autorité."}]'::jsonb, 'b', 'L''ironie (antiphrase) dit le contraire de ce qu''on pense pour railler et disqualifier ; la modalisation (il semblerait, sans doute…) nuance le propos en marquant le degré de certitude. L''option (a) inverse les deux fonctions. Ni l''une ni l''autre ne sert à illustrer (c), et aucune n''impose une réponse ou n''invoque une autorité (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0b2ccba-f958-584d-995f-4bfedb45092f', 'd773b1d7-0da3-5339-a823-ba164e20abea', '« Voyez les Romains : ils ont conquis le monde par la discipline. Une nation, comme une armée, ne s''élève que par l''ordre. » Quels procédés sont combinés ?', '[{"id":"a","text":"Un contre-exemple suivi d''une modalisation."},{"id":"b","text":"Une prétérition suivie d''un faux dilemme."},{"id":"c","text":"Un exemple (les Romains) renforcé par une analogie (nation / armée)."},{"id":"d","text":"Une question rhétorique suivie d''une concession."}]'::jsonb, 'c', 'L''énoncé appuie d''abord la thèse par un cas concret — l''exemple des Romains — puis la généralise par une analogie entre la nation et l''armée. Ce n''est pas un contre-exemple (l''exemple appuie, il ne réfute pas), ni une prétérition/faux dilemme (b), ni une question rhétorique/concession (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('926f3f31-e2a8-52ab-9b56-464b306820de', 'd773b1d7-0da3-5339-a823-ba164e20abea', '« Ou bien on interdit complètement les écrans aux enfants, ou bien on sacrifie leur avenir. » Quel sophisme reconnais-tu ?', '[{"id":"a","text":"Un faux dilemme : deux options extrêmes sont posées comme seules possibles."},{"id":"b","text":"Un homme de paille."},{"id":"c","text":"Une pétition de principe."},{"id":"d","text":"Un argument d''autorité."}]'::jsonb, 'a', '« Ou bien… ou bien… » enferme le débat dans deux choix extrêmes (interdiction totale ou avenir sacrifié) en ignorant tout usage modéré : c''est le faux dilemme. Ce n''est pas un homme de paille (aucune thèse adverse déformée), ni une pétition de principe (aucune circularité), ni un argument d''autorité.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79903e60-fc33-579f-8961-f1150c689ebd', 'd773b1d7-0da3-5339-a823-ba164e20abea', '« Mon honorable contradicteur soutient, paraît-il, qu''il faudrait tout privatiser, jusqu''aux trottoirs. Une telle extravagance se réfute d''elle-même. » Quel procédé fautif est employé ?', '[{"id":"a","text":"Une modalisation honnête de la thèse adverse."},{"id":"b","text":"Un contre-exemple rigoureux."},{"id":"c","text":"Une concession rhétorique."},{"id":"d","text":"Un homme de paille : la thèse adverse est caricaturée (« jusqu''aux trottoirs ») pour être réfutée facilement."}]'::jsonb, 'd', 'La position adverse est gonflée jusqu''à l''absurde (« tout privatiser, jusqu''aux trottoirs ») afin d''être balayée sans effort : c''est l''homme de paille. Le « paraît-il » ne rend pas la reformulation honnête (a) — il l''insinue. Ce n''est ni un contre-exemple (b), ni une concession qui accorderait un point réel (c).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', '5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('4e4b26b4-2c14-55a2-9481-cfa8573f3b51', '8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', 'Que signifie l''adjectif « idoine » ?', '[{"id":"a","text":"Parfaitement approprié, qui convient exactement"},{"id":"b","text":"Identique en tout point, semblable"},{"id":"c","text":"Naïf, qui se laisse facilement tromper"},{"id":"d","text":"Solitaire, qui fuit la compagnie"}]'::jsonb, 'a', '« Idoine » signifie parfaitement approprié, qui convient exactement à un usage : « l''outil idoine ». Le sens « identique » relève de « idem » et trompe par la ressemblance sonore ; « naïf » et « solitaire » sont sans rapport.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64a3f3bc-183f-52cb-83a8-d0f64a605ade', '8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', 'Quel mot correspond à cette définition : « qui s''exprime en très peu de mots, concis jusqu''à la sécheresse » ?', '[{"id":"a","text":"prolixe"},{"id":"b","text":"laconique"},{"id":"c","text":"loquace"},{"id":"d","text":"emphatique"}]'::jsonb, 'b', '« Laconique » désigne une expression très brève, presque sèche. « Prolixe » et « loquace » signifient au contraire trop long ou trop bavard ; « emphatique » signifie pompeux, ampoulé : ce sont les contraires du sens visé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ddde91a-7a65-54f0-9c40-840d44ef4012', '8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', 'Dans la série « économe / avare / pingre », lequel exprime une qualité (sens mélioratif) ?', '[{"id":"a","text":"pingre"},{"id":"b","text":"avare"},{"id":"c","text":"économe"},{"id":"d","text":"les trois ont la même connotation"}]'::jsonb, 'c', '« Économe » loue une qualité : savoir gérer sans gaspiller. « Avare » blâme un défaut, et « pingre » y ajoute le mépris. Le sens dénoté est proche, mais la connotation va du mélioratif au franchement péjoratif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f208d365-5a87-5879-8ec3-12a22fc4c001', '8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', 'Que signifie une « palinodie » ?', '[{"id":"a","text":"Un discours d''éloge funèbre"},{"id":"b","text":"Une répétition obstinée d''une même idée"},{"id":"c","text":"Un chant joyeux et populaire"},{"id":"d","text":"Un revirement complet d''opinion, une rétractation"}]'::jsonb, 'd', 'Une « palinodie » est un changement total d''opinion, le fait de se rétracter de ce qu''on affirmait. Ce n''est ni un éloge funèbre, ni une répétition, ni un chant : ces définitions inversent ou détournent le sens réel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5d9ace5-38c3-5c50-8972-aa4723563384', '8aeffdea-c18d-5fdb-be47-12ae5dcc2f9a', 'Quelle discipline répond à la question « Comment savons-nous ? Qu''est-ce qu''une connaissance valide ? »', '[{"id":"a","text":"l''éthique"},{"id":"b","text":"l''épistémologie"},{"id":"c","text":"l''ontologie"},{"id":"d","text":"la téléologie"}]'::jsonb, 'b', 'L''épistémologie étudie la connaissance et sa validité (« comment savons-nous ? »). L''éthique juge l''action (le bien, le mal) ; l''ontologie étudie l''être (« qu''est-ce qui existe ? ») ; la téléologie étudie les fins et la finalité.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b0dd52fd-983d-5326-aabb-ed4b8682aab9', '5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', 'francais-c2', '⭐ Entraînement : mots savants et précision lexicale', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9ad142d2-6642-5c32-90eb-a8a46373566c', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', 'Que signifie l''adjectif « abscons » ?', '[{"id":"a","text":"Absent, qui manque à l''appel"},{"id":"b","text":"Obscur, difficile à comprendre"},{"id":"c","text":"Lumineux, parfaitement clair"},{"id":"d","text":"Ancien, qui date d''autrefois"}]'::jsonb, 'b', '« Abscons » qualifie un propos obscur, difficile à comprendre, souvent par excès d''abstraction. « Lumineux / clair » en est l''antonyme exact (définition inversée) ; « absent » trompe par la ressemblance sonore et « ancien » est sans rapport.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('963c514f-0c79-5d10-9f48-ac0d6afda930', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', 'Quel mot correspond à cette définition : « négligence grave, manque total de soin » ?', '[{"id":"a","text":"l''incurie"},{"id":"b","text":"la pénurie"},{"id":"c","text":"l''inertie"},{"id":"d","text":"la curie"}]'::jsonb, 'a', '« L''incurie » désigne une négligence coupable, un manque total de soin. « La pénurie » est un manque de ressources, « l''inertie » une absence de mouvement, « la curie » une instance ecclésiastique : aucun ne désigne la négligence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e65ff868-1808-5ffe-a694-da3c8df4b98c', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', 'Que signifie « velléitaire » ?', '[{"id":"a","text":"Énergique, qui mène tout à son terme"},{"id":"b","text":"Coléreux, prompt à s''emporter"},{"id":"c","text":"Qui forme des intentions sans jamais les réaliser"},{"id":"d","text":"Très rapide, expéditif"}]'::jsonb, 'c', '« Velléitaire » se dit de celui qui veut sans agir, qui forme des projets qu''il ne mène jamais à bien. « Énergique / qui mène tout à terme » en est l''inverse exact ; « coléreux » et « rapide » sont sans rapport avec le manque de volonté.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f0f6ea7-903d-5010-b38e-daa8b15a5baf', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', 'Dans la série « ferme / obstiné / buté », lequel a la connotation la plus péjorative ?', '[{"id":"a","text":"ferme"},{"id":"b","text":"constant"},{"id":"c","text":"résolu"},{"id":"d","text":"buté"}]'::jsonb, 'd', '« Buté » est le plus péjoratif : il dénote un entêtement stupide et fermé. « Ferme », « constant » et « résolu » sont mélioratifs ou neutres : ils louent la détermination, non l''entêtement aveugle.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b40200e2-8535-548c-9efe-112fb11c4abe', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', 'Que signifie l''adjectif « prégnant » ?', '[{"id":"a","text":"Qui s''impose fortement à l''esprit, marquant"},{"id":"b","text":"Sur le point de se produire, imminent"},{"id":"c","text":"Lourd, difficile à porter"},{"id":"d","text":"Lié à la grossesse"}]'::jsonb, 'a', '« Prégnant » qualifie ce qui s''impose à l''esprit et y laisse une empreinte forte : une image prégnante. Le sens « grossesse » est un anglicisme fautif (de pregnant) ; « imminent » et « lourd » détournent le mot vers d''autres idées.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21a797af-e64a-51cf-a62a-caa26879ed31', 'b0dd52fd-983d-5326-aabb-ed4b8682aab9', 'Quelle discipline répond à la question « Que doit-on faire ? Qu''est-ce qu''une action juste ? »', '[{"id":"a","text":"l''ontologie"},{"id":"b","text":"l''éthique"},{"id":"c","text":"l''épistémologie"},{"id":"d","text":"la philologie"}]'::jsonb, 'b', 'L''éthique étudie le bien, le mal et l''action juste : « que doit-on faire ? ». L''ontologie étudie l''être, l''épistémologie la connaissance, et la philologie l''étude des textes et des langues : aucune ne porte sur le devoir d''agir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8d30dbad-7608-58d0-809d-db40c929f27f', '5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', 'francais-c2', '⭐⭐ Révision : mots savants et précision lexicale', 2, 75, 15, 'practice', 'admin', 2)
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
  ('eddc7e53-6a4b-5e51-b04a-10ef0d6f0882', '8d30dbad-7608-58d0-809d-db40c929f27f', 'Quel mot correspond à cette définition : « interprétation détaillée et critique d''un texte précis » ?', '[{"id":"a","text":"la genèse"},{"id":"b","text":"la paraphrase"},{"id":"c","text":"l''apologie"},{"id":"d","text":"l''exégèse"}]'::jsonb, 'd', '« L''exégèse » est le commentaire interprétatif et critique d''un texte (souvent sacré ou littéraire). « La paraphrase » se contente de redire en d''autres mots, « la genèse » désigne une origine, « l''apologie » une défense : aucun n''est une interprétation critique.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e273e0b-1915-561b-8d96-05315157bc5c', '8d30dbad-7608-58d0-809d-db40c929f27f', 'Que signifie « sibyllin » ?', '[{"id":"a","text":"Bruyant, sonore"},{"id":"b","text":"Énigmatique, au sens volontairement obscur"},{"id":"c","text":"Limpide, sans la moindre ambiguïté"},{"id":"d","text":"Mensonger, trompeur"}]'::jsonb, 'b', '« Sibyllin » (de la sibylle, devineresse antique) qualifie un propos énigmatique, au sens caché ou oraculaire. « Limpide » en est l''antonyme (définition inversée) ; « mensonger » porte sur la vérité, non sur la clarté, et « bruyant » est sans rapport.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe9f7865-f1c4-57b7-bf88-9ac4b0c91b82', '8d30dbad-7608-58d0-809d-db40c929f27f', 'Quel est l''intrus, c''est-à-dire le seul mot à connotation MÉLIORATIVE dans cette liste ?', '[{"id":"a","text":"arriviste"},{"id":"b","text":"thuriféraire"},{"id":"c","text":"ambitieux"},{"id":"d","text":"pingre"}]'::jsonb, 'c', '« Ambitieux » est neutre, voire mélioratif : vouloir réussir n''est pas un vice. « Arriviste » (réussir sans scrupules), « thuriféraire » (flatteur servile) et « pingre » (avare méprisable) sont tous nettement péjoratifs.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b69f545b-7580-54ec-875b-56e352752584', '8d30dbad-7608-58d0-809d-db40c929f27f', 'Que signifie le verbe « subsumer » ?', '[{"id":"a","text":"Résumer brièvement un long texte"},{"id":"b","text":"Ranger un cas particulier sous une notion générale"},{"id":"c","text":"Faire disparaître entièrement quelque chose"},{"id":"d","text":"Supposer quelque chose à l''avance"}]'::jsonb, 'b', '« Subsumer » consiste à ranger un cas particulier sous un concept plus général (subsumer un fait sous une loi). « Résumer » trompe par la ressemblance sonore ; « faire disparaître » et « supposer » détournent vers d''autres sens.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c308c084-d911-5a0e-962f-9cf34cad9761', '8d30dbad-7608-58d0-809d-db40c929f27f', 'Quel mot correspond à cette définition : « décadence, décomposition progressive d''une institution ou d''un État » ?', '[{"id":"a","text":"l''effervescence"},{"id":"b","text":"la résilience"},{"id":"c","text":"la déliquescence"},{"id":"d","text":"la quintessence"}]'::jsonb, 'c', '« La déliquescence » désigne une décadence, un délitement progressif. « L''effervescence » est au contraire une agitation vive ; « la résilience » est la capacité à se rétablir ; « la quintessence » est l''essentiel le plus pur : tous s''opposent au sens de décadence.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15389306-e80f-5bab-ad0f-e1febe97ac94', '8d30dbad-7608-58d0-809d-db40c929f27f', 'Que signifie « atrabilaire » ?', '[{"id":"a","text":"D''humeur sombre, chagrine et irritable"},{"id":"b","text":"Plein d''entrain et de bonne humeur"},{"id":"c","text":"Indécis, hésitant en permanence"},{"id":"d","text":"Particulièrement bavard"}]'::jsonb, 'a', '« Atrabilaire » se dit d''un tempérament sombre et irritable (de l''« atrabile », la bile noire des Anciens). « Plein d''entrain » en est l''inverse ; « indécis » correspondrait à velléitaire et « bavard » à prolixe : ces sens sont détournés.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23556ada-9445-569a-9b0e-63d070c1da7a', '5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : mots savants et précision lexicale', 3, 120, 30, 'boss', 'admin', 3)
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
  ('c195d6f4-9b25-5edd-b54b-acf142a09074', '23556ada-9445-569a-9b0e-63d070c1da7a', 'Que signifie l''adjectif « obvie » ?', '[{"id":"a","text":"Évident, qui se présente immédiatement à l''esprit"},{"id":"b","text":"Détourné, qui contourne un obstacle"},{"id":"c","text":"Caché, qu''il faut deviner"},{"id":"d","text":"Ennuyeux, qui lasse vite"}]'::jsonb, 'a', '« Obvie » signifie évident, qui s''impose de lui-même (le sens obvie d''un texte). Le piège : on le confond avec « obvier » (parer à un risque), d''où le distracteur « détourné/contourner ». « Caché » est l''antonyme exact, « ennuyeux » est sans rapport.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94fd71e6-c4bc-5b9b-862c-fbe999285354', '23556ada-9445-569a-9b0e-63d070c1da7a', 'Quel mot correspond à cette définition : « fait de découvrir par hasard ce que l''on ne cherchait pas » ?', '[{"id":"a","text":"la perspicacité"},{"id":"b","text":"la sérendipité"},{"id":"c","text":"la sagacité"},{"id":"d","text":"la curiosité"}]'::jsonb, 'b', '« La sérendipité » est la découverte heureuse et fortuite (la pénicilline en est l''exemple type). « La perspicacité » et « la sagacité » désignent au contraire la finesse d''esprit volontaire, et « la curiosité » le désir de savoir : aucune n''inclut le hasard.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1929bdf0-42e8-58d0-aefd-9e29a8217106', '23556ada-9445-569a-9b0e-63d070c1da7a', 'Choisis l''emploi RIGOUREUX. Pour parler d''un commentateur qui interprète en détail un passage donné de l''Énéide, on dit qu''il en fait :', '[{"id":"a","text":"l''herméneutique"},{"id":"b","text":"la téléologie"},{"id":"c","text":"l''exégèse"},{"id":"d","text":"l''ontologie"}]'::jsonb, 'c', 'On fait l''exégèse d''un texte précis : le commentaire interprétatif appliqué à un passage donné. Le piège courant : « herméneutique » désigne la science générale de l''interprétation, pas l''analyse d''un texte particulier. « Téléologie » (les fins) et « ontologie » (l''être) sont hors sujet.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b095ead5-e4ba-5b12-b440-c28662d818f8', '23556ada-9445-569a-9b0e-63d070c1da7a', 'Que signifie « pusillanime » ?', '[{"id":"a","text":"Généreux jusqu''à la prodigalité"},{"id":"b","text":"D''une grandeur d''âme remarquable"},{"id":"c","text":"Doté d''une mémoire exceptionnelle"},{"id":"d","text":"Qui manque de courage, craintif et sans audace"}]'::jsonb, 'd', '« Pusillanime » (littéralement « à l''âme petite ») signifie craintif, sans courage. Le piège : son antonyme exact est « magnanime » (grandeur d''âme), proposé en (b) pour tromper. « Généreux » et « bonne mémoire » sont des sens étrangers.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6088c20b-8287-51dc-8a89-97d383069939', '23556ada-9445-569a-9b0e-63d070c1da7a', 'Quel mot correspond à cette définition : « qui change sans cesse de forme, aux aspects multiples et changeants » ?', '[{"id":"a","text":"monolithique"},{"id":"b","text":"pléthorique"},{"id":"c","text":"protéiforme"},{"id":"d","text":"homogène"}]'::jsonb, 'c', '« Protéiforme » (du dieu Protée, qui changeait de forme) qualifie ce qui prend des aspects multiples et changeants. « Monolithique » et « homogène » désignent au contraire l''uniformité ; « pléthorique » signifie surabondant : une intensité, non une variabilité de forme.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a17bd75a-ffe4-5f2f-9009-8865576198d8', '23556ada-9445-569a-9b0e-63d070c1da7a', 'Que signifie le verbe « réifier » ?', '[{"id":"a","text":"Rétablir quelque chose dans son état antérieur"},{"id":"b","text":"Transformer une idée abstraite en chose, la traiter comme un objet"},{"id":"c","text":"Réfuter point par point un raisonnement"},{"id":"d","text":"Répéter inutilement la même idée"}]'::jsonb, 'b', '« Réifier » (du latin res, la chose) consiste à traiter une abstraction comme un objet concret : réifier le travail humain. Le piège : la ressemblance avec « rétablir » ou « réfuter ». « Répéter » correspondrait à une tautologie, sens étranger.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5ef9fed1-0bdf-5d01-9014-b95871ecf836', '5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : mots savants et précision lexicale', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('5f1fe0b7-b2ba-5b2e-a47a-7d2dfdf6b8b9', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', 'Quel mot correspond à cette définition : « flatteur servile, qui encense quelqu''un avec un excès complaisant » ?', '[{"id":"a","text":"un thuriféraire"},{"id":"b","text":"un détracteur"},{"id":"c","text":"un dépositaire"},{"id":"d","text":"un dignitaire"}]'::jsonb, 'a', '« Un thuriféraire » (à l''origine, celui qui porte l''encensoir) désigne par image un flatteur servile. « Un détracteur » en est l''exact opposé (il dénigre) ; « dépositaire » et « dignitaire » trompent par la sonorité mais désignent l''un un gardien, l''autre un haut personnage.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5926e14-e40e-5236-914e-758f24465de0', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', 'Distingue le sens exact. Une « dichotomie » désigne :', '[{"id":"a","text":"une contradiction interne d''un même raisonnement"},{"id":"b","text":"une division nette en deux parties opposées"},{"id":"c","text":"une accumulation de nuances intermédiaires"},{"id":"d","text":"une répétition d''un mot à valeur d''insistance"}]'::jsonb, 'b', 'Une « dichotomie » est une division en deux termes tranchés et opposés (corps/esprit). Le piège : (c) propose l''inverse exact (le continuum des nuances). (a) décrit une antinomie ou une aporie, (d) une figure de répétition : sens voisins mais distincts.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2209243-9507-51a7-8aae-e8f50cdefe50', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', 'Choisis l''emploi le plus RIGOUREUX. Pour qualifier la dégradation lente et fatale d''un régime politique miné par la corruption, le terme exact est :', '[{"id":"a","text":"sa résurgence"},{"id":"b","text":"son effervescence"},{"id":"c","text":"sa déliquescence"},{"id":"d","text":"sa prééminence"}]'::jsonb, 'c', '« Déliquescence » nomme précisément la décomposition progressive d''une institution. Le piège courant : choisir un mot savant à connotation forte mais de sens inverse. « Résurgence » = réapparition, « effervescence » = agitation vive, « prééminence » = supériorité : tous contredisent l''idée de déclin.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22c6f49e-fe32-5f5b-a188-73b51389d15e', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', 'Quel mot correspond à cette définition : « modèle de pensée dominant, cadre de référence partagé par une communauté à une époque donnée » ?', '[{"id":"a","text":"un paradigme"},{"id":"b","text":"un paradoxe"},{"id":"c","text":"un parangon"},{"id":"d","text":"un palimpseste"}]'::jsonb, 'a', '« Un paradigme » est un modèle de pensée de référence (le paradigme scientifique d''une époque). Le piège : trois paronymes savants. « Paradoxe » = idée contraire au sens commun, « parangon » = modèle de perfection, « palimpseste » = parchemin réécrit : sens distincts.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a10c6801-924f-5606-b75b-be8814e3ce0e', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', 'Distingue les disciplines. L''étude des fins, des buts et de la finalité d''un être ou d''une action relève de :', '[{"id":"a","text":"l''épistémologie"},{"id":"b","text":"l''ontologie"},{"id":"c","text":"l''étymologie"},{"id":"d","text":"la téléologie"}]'::jsonb, 'd', 'La téléologie (du grec telos, la fin) étudie les buts et la finalité (« vers quelle fin ? »). Le piège : l''épistémologie porte sur la connaissance, l''ontologie sur l''être, l''étymologie sur l''origine des mots : aucune ne traite de la finalité.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a9889f3-70e9-54a3-9a3c-1f14c7b96aa0', '5ef9fed1-0bdf-5d01-9014-b95871ecf836', 'Choisis le mot dont le sens est exactement « revirement complet d''opinion, rétractation de ce que l''on soutenait ». Attention au piège du sens voisin.', '[{"id":"a","text":"une diatribe"},{"id":"b","text":"une apologie"},{"id":"c","text":"une palinodie"},{"id":"d","text":"une digression"}]'::jsonb, 'c', '« Une palinodie » est le fait de se dédire, de retourner complètement son opinion. Le piège courant : confondre avec d''autres genres de discours. « Diatribe » = critique violente, « apologie » = défense élogieuse, « digression » = écart hors du sujet : aucun n''est un reniement.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', '5d4f10f2-ecd2-53e1-aee8-98f62cec6fa9', 'francais-c2', '⭐⭐ Drill : mots savants et précision lexicale', 2, 75, 15, 'practice', 'admin', 5)
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
  ('356ff584-1181-5c94-913f-6b6e181d3b43', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'Que signifie l''adjectif « prolixe » ?', '[{"id":"a","text":"Concis, qui va droit au but"},{"id":"b","text":"Trop long, bavard, qui se répand en paroles"},{"id":"c","text":"Fertile, qui produit beaucoup"},{"id":"d","text":"Précis, exact dans ses termes"}]'::jsonb, 'b', '« Prolixe » qualifie un discours trop long, diffus. « Concis » est l''antonyme (définition inversée). Attention au paronyme « prolifique » (qui produit beaucoup) glissé en (c) : sens voisin par la forme mais distinct.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e07883e-76c3-549d-950e-49c05bebc048', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'Quel mot correspond à cette définition : « qui appartient en propre à une chose, indépendamment de tout contexte extérieur » ?', '[{"id":"a","text":"contingent"},{"id":"b","text":"accessoire"},{"id":"c","text":"intrinsèque"},{"id":"d","text":"circonstanciel"}]'::jsonb, 'c', '« Intrinsèque » désigne ce qui tient à la nature même d''une chose (sa valeur intrinsèque). Son contraire est « extrinsèque ». « Contingent » et « circonstanciel » désignent au contraire ce qui dépend des circonstances ; « accessoire » ce qui est secondaire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e68ae25-7fdd-550e-b4fa-33e66e95dc05', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'Que signifie le mot « contingent » employé comme adjectif au sens philosophique ?', '[{"id":"a","text":"Qui aurait pu ne pas être, qui n''est pas nécessaire"},{"id":"b","text":"Qui est nécessaire et ne peut pas ne pas être"},{"id":"c","text":"Qui est strictement limité en quantité"},{"id":"d","text":"Qui est continu et sans interruption"}]'::jsonb, 'a', 'Le « contingent » est ce qui pourrait être autrement, qui n''a rien de nécessaire : il s''oppose au « nécessaire ». (b) en donne l''exact contraire. Le sens « limité en quantité » (un contingent de soldats) est un autre emploi, et « continu » trompe par la sonorité.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c03f2b0-e441-575a-b301-0eed0d945c36', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'Quel est l''intrus, c''est-à-dire le seul mot qui ne soit PAS synonyme d''« obscur, difficile à comprendre » ?', '[{"id":"a","text":"abscons"},{"id":"b","text":"sibyllin"},{"id":"c","text":"hermétique"},{"id":"d","text":"laconique"}]'::jsonb, 'd', '« Laconique » signifie très bref, concis : il porte sur la longueur, non sur la clarté. « Abscons », « sibyllin » et « hermétique » désignent tous l''obscurité du sens : ce sont les synonymes, donc « laconique » est l''intrus.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82db0f5a-d824-51c2-b2ba-531fa733e492', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'Distingue les disciplines. La question « Qu''est-ce qui existe ? Quelle est la nature de l''être ? » relève de :', '[{"id":"a","text":"l''éthique"},{"id":"b","text":"l''ontologie"},{"id":"c","text":"la téléologie"},{"id":"d","text":"l''épistémologie"}]'::jsonb, 'b', 'L''ontologie étudie l''être en tant qu''être (« qu''est-ce qui existe ? »). L''éthique juge l''action, l''épistémologie la connaissance, la téléologie la finalité : aucune ne porte sur la nature de l''existence elle-même.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67cce341-38d2-5712-97b7-081a70abc291', '2e49f51a-7f9e-5d6c-952c-08ab4a4fd5fb', 'Choisis l''emploi RIGOUREUX. La discipline qui théorise de manière générale l''art et les règles de toute interprétation des textes se nomme :', '[{"id":"a","text":"l''exégèse"},{"id":"b","text":"la sémiologie"},{"id":"c","text":"l''herméneutique"},{"id":"d","text":"la rhétorique"}]'::jsonb, 'c', '« L''herméneutique » est la théorie générale de l''interprétation. Le piège courant : « l''exégèse » est l''application concrète à un texte donné, pas la théorie d''ensemble. « La sémiologie » étudie les signes, « la rhétorique » l''art de persuader : sens voisins mais distincts.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cbd02736-a8df-55ad-9928-38d0d54a2dda', '950643fe-bef4-5a10-b618-6930438b4dbe', 'francais-c2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('316d72d9-949f-596e-9138-7294da6b6e1d', 'cbd02736-a8df-55ad-9928-38d0d54a2dda', 'Lisez l''extrait :
« La réforme, paraît-il, a tout réglé. »

Que signale le mot « paraît-il » sur la position de l''auteur ?', '[{"id":"a","text":"Que l''auteur garantit personnellement la réussite de la réforme."},{"id":"b","text":"Que l''auteur rapporte un propos dont il se distancie, sans l''endosser."},{"id":"c","text":"Que la réforme est récente et encore mal connue."},{"id":"d","text":"Que l''auteur ignore tout du sujet de la réforme."}]'::jsonb, 'b', '« Paraît-il » est une marque de modalisation par ouï-dire : l''auteur attribue l''affirmation à une voix extérieure et s''en désolidarise. Il ne garantit donc rien (a), n''évoque ni la nouveauté (c) ni son ignorance (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fdfb291-24d8-5a05-8fe5-d9ab4e31bb19', 'cbd02736-a8df-55ad-9928-38d0d54a2dda', 'Lisez l''extrait :
« L''entreprise ne fut pas, disons-le, un franc succès. »

Quelle figure l''auteur emploie-t-il et que veut-il faire entendre ?', '[{"id":"a","text":"Une hyperbole : l''entreprise fut un triomphe éclatant."},{"id":"b","text":"Une litote : l''entreprise fut en réalité un échec marqué."},{"id":"c","text":"Une métaphore commerciale neutre, sans jugement."},{"id":"d","text":"Une question rhétorique appelant l''adhésion du lecteur."}]'::jsonb, 'b', 'Dire « pas un franc succès » pour signifier un échec est une litote : on atténue l''expression pour suggérer davantage. Ce n''est pas une hyperbole (a, qui exagérerait vers le haut), ni une notation neutre (c), ni une question (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4335a63d-67ed-52c3-b3f7-1893549ff3e7', 'cbd02736-a8df-55ad-9928-38d0d54a2dda', 'Lisez l''extrait :
« Sans doute la prudence est-elle une qualité ; mais à trop attendre, on laisse le danger grandir. »

Où se situe la véritable thèse de l''auteur ?', '[{"id":"a","text":"Dans la première partie : il faut avant tout être prudent."},{"id":"b","text":"Nulle part : l''auteur reste neutre entre les deux idées."},{"id":"c","text":"Après le « mais » : l''attente excessive laisse le danger croître."},{"id":"d","text":"Dans une troisième idée implicite, opposée aux deux énoncées."}]'::jsonb, 'c', 'Le tour « sans doute… mais… » est une concession restrictive : la première partie est concédée pour mieux être dépassée, et la thèse réelle suit le « mais ». L''auteur n''est donc pas neutre (b) et ne défend pas la prudence pour elle-même (a).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2b5081a-3146-5658-a1d7-b99d128eb7fd', 'cbd02736-a8df-55ad-9928-38d0d54a2dda', 'Lisez l''extrait :
« Nos dirigeants, dans leur clairvoyance coutumière, n''ont rien vu venir. »

Comment faut-il lire « dans leur clairvoyance coutumière » ?', '[{"id":"a","text":"Au sens propre : l''auteur loue la lucidité habituelle des dirigeants."},{"id":"b","text":"Comme une antiphrase ironique : l''éloge dit le contraire de ce qu''il affirme."},{"id":"c","text":"Comme une information neutre sur leur compétence."},{"id":"d","text":"Comme une excuse présentée en faveur des dirigeants."}]'::jsonb, 'b', 'L''éloge (« clairvoyance ») est contredit par les faits (« n''ont rien vu venir ») : c''est une antiphrase ironique, où la louange signifie son contraire. Le sens littéral (a, c) est exclu par la contradiction, et il ne s''agit pas d''une excuse (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e3a4f0c-5435-514c-bb0f-6f38c54ed5f4', 'cbd02736-a8df-55ad-9928-38d0d54a2dda', 'Lisez l''extrait :
« Ou bien l''on accepte cette mesure sans réserve, ou bien l''on sombre dans le chaos. »

Quelle faille de raisonnement ce passage illustre-t-il ?', '[{"id":"a","text":"Une fausse alternative qui écarte toute autre possibilité."},{"id":"b","text":"Une pétition de principe répétant la conclusion."},{"id":"c","text":"Une généralisation hâtive à partir d''un seul cas."},{"id":"d","text":"Un argument d''autorité fondé sur un expert."}]'::jsonb, 'a', 'Le tour « ou bien…, ou bien… » réduit le choix à deux extrêmes en escamotant les solutions intermédiaires : c''est une fausse alternative (faux dilemme). Il n''y a ici ni répétition de la conclusion (b), ni généralisation depuis un cas (c), ni appel à une autorité (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7623e0a7-66d1-5966-9cf4-642727c5ae9d', '950643fe-bef4-5a10-b618-6930438b4dbe', 'francais-c2', '⭐ Entraînement : implicite, ton et énonciation', 1, 50, 10, 'practice', 'admin', 1)
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
  ('66971b99-efa6-51e5-a894-3504a3abd08f', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'Lisez l''extrait :
« Il a encore manqué le rendez-vous. »

Que présuppose l''adverbe « encore » ?', '[{"id":"a","text":"Qu''il avait déjà manqué un rendez-vous auparavant."},{"id":"b","text":"Qu''il viendra sûrement la prochaine fois."},{"id":"c","text":"Que le rendez-vous était sans importance."},{"id":"d","text":"Qu''il était en avance ce jour-là."}]'::jsonb, 'a', '« Encore » présuppose la répétition d''un fait antérieur : il a déjà manqué un rendez-vous. Ce présupposé subsiste même si l''on nie la phrase. Les options b, c et d ajoutent des informations absentes du texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('859c99fd-9525-56d1-aeaa-229740e4ec99', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'Lisez l''extrait :
« On nous répète que tout va mieux. »

À qui l''auteur attribue-t-il l''affirmation « tout va mieux » ?', '[{"id":"a","text":"À lui-même, qu''il assume pleinement."},{"id":"b","text":"À une voix extérieure qu''il rapporte et met à distance."},{"id":"c","text":"À un témoin précis dont il cite le nom."},{"id":"d","text":"À personne : c''est une simple description du monde."}]'::jsonb, 'b', 'Le tour « on nous répète que… » signale un discours rapporté, attribué à une voix collective dont l''auteur se distancie. Il ne l''endosse pas (a), ne cite aucun nom (c) et ne décrit pas un fait avéré (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4f3be4a-ab15-5245-a8f3-a8daaa812701', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'Lisez l''extrait :
« La cérémonie fut, paraît-il, d''une sobriété exemplaire — du moins pour ceux qui n''avaient pas vu la facture. »

Quel est le ton de cette phrase ?', '[{"id":"a","text":"Élogieux et sincère envers la sobriété de la cérémonie."},{"id":"b","text":"Strictement informatif et sans jugement."},{"id":"c","text":"Ironique : la chute contredit l''éloge de sobriété."},{"id":"d","text":"Inquiet quant à la santé des organisateurs."}]'::jsonb, 'c', 'L''incise finale (« pour ceux qui n''avaient pas vu la facture ») dément l''idée de sobriété : l''éloge est ironique. Le ton n''est ni sincère (a), ni neutre (b), et n''a aucun rapport avec la santé (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e65c55b-f482-5ecc-a0ad-527358025641', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'Lisez l''extrait :
« La mesure aurait, selon ses détracteurs, aggravé la situation. »

Que marque l''emploi du conditionnel « aurait aggravé » ?', '[{"id":"a","text":"Que l''auteur tient l''aggravation pour un fait certain."},{"id":"b","text":"Que l''aggravation se produira dans le futur."},{"id":"c","text":"Une donnée rapportée que l''auteur n''assume pas comme vraie."},{"id":"d","text":"Une politesse de l''auteur envers les détracteurs."}]'::jsonb, 'c', 'Le conditionnel d''information, renforcé par « selon ses détracteurs », signale une donnée non assumée : l''auteur la rapporte sans la valider. Ce n''est donc ni un fait certain (a), ni un futur (b), ni une marque de politesse (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1b92a9a-bc13-5077-80a9-5d2f20627382', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'Lisez l''extrait :
« Sa pugnacité — ce refus obstiné de jamais céder — finit par lasser ses propres alliés. »

Que signifie « pugnacité » dans ce contexte ?', '[{"id":"a","text":"Une grande générosité envers les autres."},{"id":"b","text":"Une combativité tenace, un acharnement à ne pas céder."},{"id":"c","text":"Une timidité qui le pousse à se retirer."},{"id":"d","text":"Une indifférence aux conflits."}]'::jsonb, 'b', 'L''apposition « ce refus obstiné de jamais céder » reformule et éclaire le mot : la pugnacité est une combativité tenace. Le contexte exclut la générosité (a), la timidité (c) et l''indifférence (d), opposées à l''idée de refus obstiné.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15d853e7-62e0-5784-8353-a3f87f457132', '7623e0a7-66d1-5966-9cf4-642727c5ae9d', 'Lisez l''extrait :
« Cette vitrine du progrès cachait mal, derrière ses néons, des ateliers d''un autre âge. »

Comment faut-il comprendre « vitrine du progrès » ?', '[{"id":"a","text":"Une boutique réelle où l''on vend des objets modernes."},{"id":"b","text":"Une façade flatteuse masquant une réalité bien moins reluisante."},{"id":"c","text":"Un musée consacré à l''histoire des techniques."},{"id":"d","text":"Une fenêtre donnant sur un atelier ancien."}]'::jsonb, 'b', 'Le sens littéral (magasin) est exclu par « cachait mal… des ateliers d''un autre âge » : « vitrine du progrès » est une métaphore désignant une façade trompeuse. Les lectures littérales a, c et d prennent l''image au pied de la lettre.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f8ea8334-2d57-51ec-9d09-7190a625868e', '950643fe-bef4-5a10-b618-6930438b4dbe', 'francais-c2', '⭐⭐ Révision : polyphonie, nuance et procédés', 2, 75, 15, 'practice', 'admin', 2)
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
  ('4937b28f-ef86-542c-bbbc-dcdecb51a01d', 'f8ea8334-2d57-51ec-9d09-7190a625868e', 'Lisez l''extrait :
« Qu''on se rassure : tout est sous contrôle, comme l''étaient, paraît-il, le Titanic et ses canots. »

Quel effet produit la comparaison finale ?', '[{"id":"a","text":"Elle détruit par l''ironie l''assurance affichée au début."},{"id":"b","text":"Elle renforce sincèrement le sentiment de sécurité."},{"id":"c","text":"Elle propose une information historique neutre."},{"id":"d","text":"Elle félicite les responsables de leur prévoyance."}]'::jsonb, 'a', 'Comparer le « contrôle » au Titanic, symbole de catastrophe, retourne l''assurance initiale en ironie : « qu''on se rassure » dit le contraire de son sens. La phrase ne rassure pas (b), n''est pas neutre (c) et ne félicite personne (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c81b4f8-3ba2-52af-987f-05fa561d1819', 'f8ea8334-2d57-51ec-9d09-7190a625868e', 'Lisez l''extrait :
« Il est vrai que la technique a soulagé bien des peines. Reste qu''elle a aussi engendré des servitudes que nul n''avait prévues. »

Quelle est la fonction de « Reste que » ?', '[{"id":"a","text":"Il confirme et prolonge l''éloge de la technique."},{"id":"b","text":"Il signale un exemple illustrant la première phrase."},{"id":"c","text":"Il introduit l''objection qui porte la vraie thèse de l''auteur."},{"id":"d","text":"Il marque une conclusion résumant les deux idées à égalité."}]'::jsonb, 'c', '« Il est vrai que… Reste que… » est une concession suivie d''une objection : la thèse de l''auteur (les « servitudes » imprévues) suit « Reste que ». Ce n''est ni un prolongement de l''éloge (a), ni un exemple (b), ni une synthèse équilibrée (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8182ece7-9fdc-55a1-941d-c993c6204ceb', 'f8ea8334-2d57-51ec-9d09-7190a625868e', 'Lisez l''extrait :
« Vite des lois, vite des chiffres, vite des promesses ; lentement, très lentement, des résultats. »

Que souligne le contraste de rythme entre les deux parties ?', '[{"id":"a","text":"L''efficacité remarquable de l''action publique."},{"id":"b","text":"L''écart entre l''empressement des annonces et la rareté des effets réels."},{"id":"c","text":"La nécessité d''écrire davantage de lois."},{"id":"d","text":"Une simple préférence stylistique sans portée critique."}]'::jsonb, 'b', 'L''accumulation rapide (« vite… vite… vite ») opposée au tempo traînant (« lentement, très lentement, des résultats ») met en relief le décalage entre l''agitation affichée et l''absence d''effets. Le procédé est critique, et non un éloge (a) ni un détail gratuit (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58ab57c0-a7da-509e-9b2f-f0283cfec24e', 'f8ea8334-2d57-51ec-9d09-7190a625868e', 'Lisez l''extrait :
« On voudrait nous faire croire que choisir, c''est forcément consommer. »

L''auteur adhère-t-il à l''idée que « choisir, c''est consommer » ?', '[{"id":"a","text":"Oui, il la présente comme sa conviction profonde."},{"id":"b","text":"Il l''attribue à un philosophe qu''il admire."},{"id":"c","text":"Il reste indécis et ne tranche pas."},{"id":"d","text":"Non : « on voudrait nous faire croire » la rejette comme une manipulation."}]'::jsonb, 'd', 'La formule « on voudrait nous faire croire que… » dénonce une assertion comme illusoire et manipulatrice : l''auteur s''en désolidarise. Il ne l''épouse donc pas (a), ne l''attribue à aucune autorité admirée (b) et ne reste pas neutre (c).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad7a9c0d-34a7-5def-83c2-884d064e362e', 'f8ea8334-2d57-51ec-9d09-7190a625868e', 'Lisez l''extrait :
« Admettons, pour la beauté du raisonnement, que l''argent fasse le bonheur. Il faudrait alors que les plus riches fussent aussi les plus heureux — ce que l''expérience, hélas, dément avec constance. »

Quel est le mouvement argumentatif de ce passage ?', '[{"id":"a","text":"Il pose une hypothèse pour mieux la réfuter par ses conséquences."},{"id":"b","text":"L''auteur défend que l''argent fait réellement le bonheur."},{"id":"c","text":"Il décrit sans jugement la vie des plus riches."},{"id":"d","text":"Il propose un programme pour enrichir les plus heureux."}]'::jsonb, 'a', '« Admettons… que » pose une hypothèse de travail, puis l''auteur en tire une conséquence (« les plus riches… les plus heureux ») que l''expérience « dément » : c''est un raisonnement par l''absurde. Il ne soutient donc pas l''idée (b), ne décrit pas neutrement (c) et ne propose aucun programme (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45bf3ef9-0a65-58ac-acdf-90eb0ae2a599', 'f8ea8334-2d57-51ec-9d09-7190a625868e', 'Lisez l''extrait :
« La liberté qu''on nous vante n''est, le plus souvent, que la liberté du renard libre dans le poulailler libre. »

Que dénonce cette formule ?', '[{"id":"a","text":"Que toute liberté est par nature dangereuse pour les animaux."},{"id":"b","text":"Que les poulaillers manquent de surveillance."},{"id":"c","text":"Qu''une liberté formelle, sans limites, livre le faible à la merci du fort."},{"id":"d","text":"Que l''auteur défend la liberté totale du commerce."}]'::jsonb, 'c', 'L''image du « renard libre dans le poulailler libre » montre qu''une liberté identique pour tous, sans protection du faible, profite en réalité au prédateur : c''est une critique de la liberté purement formelle. La lecture littérale (a, b) manque la métaphore, et l''auteur ne fait pas l''éloge de cette liberté (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('82802b8e-8942-5f04-ac8a-967f88a18e8f', '950643fe-bef4-5a10-b618-6930438b4dbe', 'francais-c2', '⚔️ Boss du chapitre ⭐⭐⭐ : ironie filée, polyphonie et failles du raisonnement', 3, 120, 30, 'boss', 'admin', 3)
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
  ('dd770b04-728e-50e9-b66f-75f951e5a58d', '82802b8e-8942-5f04-ac8a-967f88a18e8f', 'Lisez l''extrait :
« Nul n''ignore plus, désormais, les bienfaits de la concurrence : elle aiguise l''esprit, abaisse les prix, récompense le mérite. Il serait donc absurde — n''est-ce pas ? — d''en soustraire l''école, l''hôpital, la justice, ces derniers refuges où l''on s''obstine encore à croire que tout ne se vaut pas. »

Quelle est la position réelle de l''auteur ?', '[{"id":"a","text":"Il défend sincèrement l''extension de la concurrence à tous les domaines."},{"id":"b","text":"Il affirme que l''école et l''hôpital sont déjà soumis au marché."},{"id":"c","text":"Il décrit objectivement les avantages de la concurrence."},{"id":"d","text":"Il raille cette évidence et suggère que certains biens échappent à la logique marchande."}]'::jsonb, 'd', 'Le « n''est-ce pas ? » faussement complice et la chute (« ces derniers refuges où l''on s''obstine encore à croire que tout ne se vaut pas ») trahissent l''ironie : l''auteur singe l''évidence pour la retourner. La lecture littérale (a, c) prend la voix raillée pour la sienne ; b ajoute un fait absent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3f7f7b8-05ec-5910-bb58-5686c9f43f31', '82802b8e-8942-5f04-ac8a-967f88a18e8f', 'Lisez l''extrait :
« Que la mémoire trahisse, c''est entendu. Mais qui oserait soutenir qu''elle ment plus que les archives, ces greniers où chaque pouvoir range, soigneusement, ce qu''il veut qu''on se rappelle ? »

Que suggère l''auteur sur les archives ?', '[{"id":"a","text":"Que les archives sont une source parfaitement neutre et fiable."},{"id":"b","text":"Que la mémoire humaine est seule responsable des erreurs du passé."},{"id":"c","text":"Que les archives, elles aussi, sont triées et orientées par le pouvoir."},{"id":"d","text":"Qu''il faut détruire toutes les archives officielles."}]'::jsonb, 'c', 'La métaphore des « greniers où chaque pouvoir range… ce qu''il veut qu''on se rappelle » présente les archives comme un tri intéressé : elles ne sont pas plus neutres que la mémoire. L''auteur ne les dit donc pas fiables (a), n''accuse pas la seule mémoire (b) et ne prône aucune destruction (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2032a4ff-e3f5-58b3-9ba6-6f532ded0424', '82802b8e-8942-5f04-ac8a-967f88a18e8f', 'Lisez l''extrait :
« On nous l''a assez seriné : sans croissance, point de salut. Le chômage ? La croissance. La dette ? Encore la croissance. À force d''invoquer ce remède universel, on a oublié de se demander s''il guérissait, ou s''il se contentait d''endormir le mal. »

Quelle est la thèse implicite du passage ?', '[{"id":"a","text":"La croissance est bien le remède universel à tous les maux."},{"id":"b","text":"On érige la croissance en remède miracle sans jamais interroger son efficacité réelle."},{"id":"c","text":"Le chômage et la dette n''ont aucun rapport avec la croissance."},{"id":"d","text":"Il faut invoquer la croissance encore plus souvent."}]'::jsonb, 'b', '« On nous l''a assez seriné » rapporte une voix avec agacement, et la répétition mécanique (« La croissance… Encore la croissance ») la tourne en dérision ; la chute (« on a oublié de se demander s''il guérissait ») livre la thèse : on n''interroge jamais l''efficacité réelle. L''option a confond la voix raillée avec l''auteur ; c et d contredisent le texte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f730ad8-d204-571c-820d-484404c091ba', '82802b8e-8942-5f04-ac8a-967f88a18e8f', 'Lisez l''extrait :
« Il pleuvait sur la ville comme il avait toujours plu, et les passants pressaient le pas vers des destinations qui, à les voir si affairés, semblaient toutes capitales. Lui seul, sous l''auvent, regardait s''écouler ce ruissellement d''existences, songeant que parmi tous ces gens si sûrs d''aller quelque part, aucun peut-être ne savait vraiment où. »

Quelle vision se dégage de ce passage littéraire ?', '[{"id":"a","text":"Une célébration enthousiaste de l''énergie et des certitudes urbaines."},{"id":"b","text":"Une simple notation météorologique sans portée sur les personnages."},{"id":"c","text":"Un éloge de la ponctualité et de la rigueur des passants."},{"id":"d","text":"Un regard mélancolique et distancié sur une agitation peut-être sans but réel."}]'::jsonb, 'd', 'Le contraste entre des passants « si sûrs d''aller quelque part » et le doute final (« aucun peut-être ne savait vraiment où ») installe un regard mélancolique et distancié de l''observateur. Ce n''est ni une célébration (a), ni une notation neutre (b), ni un éloge de la ponctualité (c).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d7094eb-bda1-5300-84dd-0c53b3276be2', '82802b8e-8942-5f04-ac8a-967f88a18e8f', 'Lisez l''extrait :
« Ou bien nous acceptons sans broncher toutes les surveillances qu''on nous propose, ou bien nous tendons les bras au chaos et au crime : il n''est pas d''autre voie pour qui aime vraiment sa cité. »

Quelle faille de raisonnement structure ce passage ?', '[{"id":"a","text":"Une fausse alternative qui présente deux extrêmes comme seules options."},{"id":"b","text":"Un argument d''autorité fondé sur une citation d''expert."},{"id":"c","text":"Une analogie rigoureuse entre deux situations comparables."},{"id":"d","text":"Une concession suivie d''une objection nuancée."}]'::jsonb, 'a', '« Ou bien…, ou bien…, il n''est pas d''autre voie » réduit le choix à deux extrêmes (surveillance totale ou chaos) en escamotant toute position intermédiaire : c''est un faux dilemme. Le piège : la clause affective (« qui aime vraiment sa cité ») masque l''absence de troisième terme. Il n''y a ni autorité citée (b), ni analogie (c), ni concession (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5eb62d19-0ec2-5922-afff-1e223f87d8e0', '82802b8e-8942-5f04-ac8a-967f88a18e8f', 'Lisez l''extrait :
« Sans doute la transparence est-elle une vertu démocratique. Mais à force d''exiger que tout soit exposé, surveillé, archivé, ne risque-t-on pas de confondre la lumière qui éclaire avec celle qui aveugle, et de faire de la défiance le seul lien qui nous reste ? »

Que suggère l''opposition entre « la lumière qui éclaire » et « celle qui aveugle » ?', '[{"id":"a","text":"Que la transparence est toujours bénéfique, quelle que soit son intensité."},{"id":"b","text":"Qu''il faudrait supprimer toute transparence de la vie publique."},{"id":"c","text":"Que poussée à l''excès, la transparence se retourne en surveillance et en défiance, et perd sa vertu."},{"id":"d","text":"Que l''éclairage des villes consomme trop d''énergie."}]'::jsonb, 'c', 'La concession « sans doute… mais » fait porter la thèse sur la seconde partie : la métaphore oppose la transparence utile (« qui éclaire ») à son excès nuisible (« qui aveugle »), prolongé par « la défiance ». L''auteur avertit qu''à l''excès elle se dénature. Il ne la dit ni toujours bénéfique (a), ni à supprimer (b) ; d prend l''image au sens littéral.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('52ed8ec2-7722-54df-856b-0a52b71df0bd', '950643fe-bef4-5a10-b618-6930438b4dbe', 'francais-c2', '👑 Défi élite ⭐⭐⭐⭐ : lecture critique de textes maîtres', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('16f0a8e6-1dda-5ea2-ade9-937197745d90', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'Lisez l''extrait :
« Le tyran moderne n''a plus besoin de bâillonner : il lui suffit d''assourdir. À quoi bon interdire une parole quand on peut la noyer sous mille autres, également criées, également vaines ? »

Quelle est l''idée maîtresse de ce passage ?', '[{"id":"a","text":"La censure brutale reste l''arme la plus efficace des pouvoirs actuels."},{"id":"b","text":"Toutes les paroles publiques se valent et méritent d''être criées."},{"id":"c","text":"Il faut multiplier les paroles pour échapper au tyran."},{"id":"d","text":"Le contrôle ne passe plus par l''interdiction mais par la saturation du bruit."}]'::jsonb, 'd', 'L''opposition « bâillonner / assourdir » et la question rhétorique (« à quoi bon interdire… quand on peut la noyer ») désignent une censure par excès de bruit, non par silence. L''auteur dénonce ce procédé, il ne défend ni la censure brute (a), ni l''équivalence des paroles (b), ni la surenchère (c).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fe1c796-5f5b-5446-99eb-335fc4dda6a0', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'Lisez l''extrait :
« Heureux temps que le nôtre, où l''on peut tout dire — pourvu, naturellement, que cela ne dérange personne d''important. »

Comment fonctionne l''ironie de cette phrase ?', '[{"id":"a","text":"L''éloge initial est sincère et la fin le confirme pleinement."},{"id":"b","text":"La phrase loue sans réserve la liberté d''expression actuelle."},{"id":"c","text":"La restriction finale ruine l''éloge en révélant une liberté en trompe-l''œil."},{"id":"d","text":"L''auteur regrette qu''on ne puisse rien dire du tout."}]'::jsonb, 'c', '« Heureux temps… où l''on peut tout dire » pose un éloge que la restriction « pourvu… que cela ne dérange personne d''important » annule aussitôt : la liberté vantée est factice. L''éloge n''est donc ni sincère (a, b), et l''auteur ne dit pas qu''on ne peut rien dire (d) : il dénonce une liberté conditionnelle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcd9f7da-38ef-53ce-b9d0-a49ccabdd12b', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'Lisez l''extrait :
« Puisque les sondages disent le peuple satisfait, et que le peuple, c''est nous, il faut bien conclure que nous sommes satisfaits — quoi que nous en éprouvions par ailleurs. »

Quelle faille logique l''auteur met-il en scène (et raille) ?', '[{"id":"a","text":"Un raisonnement valide menant à une conclusion vraie."},{"id":"b","text":"Un syllogisme truqué qui impose une conclusion contre l''expérience vécue."},{"id":"c","text":"Une simple description neutre de l''opinion publique."},{"id":"d","text":"Une réfutation rigoureuse de la méthode des sondages."}]'::jsonb, 'b', 'Le passage mime un syllogisme (« le peuple est satisfait ; le peuple, c''est nous ; donc nous sommes satisfaits ») dont la chute « quoi que nous en éprouvions » avoue qu''il écrase le ressenti réel : l''auteur raille ce raisonnement truqué. Il ne le valide pas (a), ne décrit pas neutrement (c) et ne mène pas une réfutation méthodique (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b8fbb40-ac91-552c-81b1-767059d83dcf', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'Lisez l''extrait :
« Elle avait, disait-on, tout pour être heureuse. On le disait surtout devant elle, et elle souriait, comme on signe un reçu. »

Que révèle la comparaison « comme on signe un reçu » ?', '[{"id":"a","text":"Que le personnage éprouve un bonheur sincère et débordant."},{"id":"b","text":"Que son sourire est une formalité vide, accusant réception d''un bonheur prescrit."},{"id":"c","text":"Qu''elle s''apprête à conclure une transaction commerciale."},{"id":"d","text":"Que l''entourage doute de la réalité de sa fortune."}]'::jsonb, 'b', 'La comparaison mécanique et administrative (« comme on signe un reçu ») vide le sourire de toute joie : c''est un assentiment de pure forme à un bonheur que les autres décrètent (« disait-on… surtout devant elle »). Le sens littéral (c) est exclu, et le texte suggère l''inverse d''un bonheur sincère (a) ; d détourne vers la fortune.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4bd3061b-2fd1-5090-8ea5-6b5aea7bf938', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'Lisez l''extrait :
« §1 — On s''indigne que la machine remplace l''homme. §2 — On oubliait, hier, de s''indigner qu''elle l''épuisât. §3 — Peut-être ne défendons-nous jamais le travail que lorsqu''il vient à manquer, l''ayant maudit tant qu''il abondait. »

Quelle est la portée du troisième paragraphe ?', '[{"id":"a","text":"Il affirme que le travail à la machine était un âge d''or à préserver."},{"id":"b","text":"Il propose un plan technique pour limiter l''automatisation."},{"id":"c","text":"Il généralise par une hypothèse : notre attachement au travail tiendrait à sa rareté plus qu''à sa valeur."},{"id":"d","text":"Il accuse les machines d''avoir détruit la dignité ouvrière."}]'::jsonb, 'c', 'Après le constat (§1) et sa relativisation historique (§2 : on ne s''indignait pas quand la machine « l''épuisait »), le §3 généralise par une hypothèse (« Peut-être ne défendons-nous… que lorsqu''il vient à manquer ») : l''attachement naîtrait de la rareté. Le texte ne célèbre aucun âge d''or (a), ne propose pas de plan (b) et n''accuse pas frontalement les machines (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87e1a99e-971d-5eb0-bb3d-e0de8dc0271a', '52ed8ec2-7722-54df-856b-0a52b71df0bd', 'Lisez l''extrait :
« Soit, concédons-le sans peine : jamais l''humanité n''a tant produit de savoir. Mais qu''avons-nous fait de tout ce clair savoir, sinon des nuits plus sombres et des armes plus sûres ? Le progrès des lumières, parfois, n''éclaire que le chemin du gouffre. »

Quel est le mouvement d''ensemble de l''argumentation ?', '[{"id":"a","text":"Une concession suivie d''un retournement : le savoir accru ne garantit pas un progrès moral, et peut servir le pire."},{"id":"b","text":"Un éloge continu et sans réserve du progrès scientifique."},{"id":"c","text":"Une démonstration que le savoir doit être interdit."},{"id":"d","text":"Une description neutre de l''histoire des sciences."}]'::jsonb, 'a', '« Soit, concédons-le… Mais… » concède l''essor du savoir pour mieux le retourner ; la métaphore finale (« n''éclaire que le chemin du gouffre ») dissocie progrès intellectuel et progrès moral. C''est donc l''inverse d''un éloge sans réserve (b) ; l''auteur n''interdit pas le savoir (c) et ne reste pas neutre (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c83341ca-54e4-5765-a3a4-f6a1f1c51752', '950643fe-bef4-5a10-b618-6930438b4dbe', 'francais-c2', '⭐⭐ Drill : révision globale de la lecture experte', 2, 75, 15, 'practice', 'admin', 5)
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
  ('df607cdd-1fe5-5bdd-b7de-7261852cbcbf', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752', 'Lisez l''extrait :
« Il n''a toujours pas compris la leçon. »

Que présuppose la formule « toujours pas » ?', '[{"id":"a","text":"Qu''on attendait de lui, depuis un certain temps, qu''il comprenne."},{"id":"b","text":"Qu''il a parfaitement compris dès le début."},{"id":"c","text":"Que la leçon était d''une simplicité enfantine."},{"id":"d","text":"Qu''il n''a jamais assisté au cours."}]'::jsonb, 'a', '« Toujours pas » présuppose une attente durable et inaccomplie : on espérait depuis un moment qu''il comprenne. Ce présupposé survit à la négation. Les options b, c et d introduisent des informations que la phrase ne contient pas.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6435faba-f6f0-5a65-be00-cdf276b3b439', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752', 'Lisez l''extrait :
« Certains prétendent que la culture se porte à merveille. »

Que marque le verbe « prétendent » sur la position de l''auteur ?', '[{"id":"a","text":"Qu''il partage entièrement ce diagnostic optimiste."},{"id":"b","text":"Qu''il prend ses distances et met en doute l''affirmation rapportée."},{"id":"c","text":"Qu''il cite un texte de loi sur la culture."},{"id":"d","text":"Qu''il félicite ceux qui défendent la culture."}]'::jsonb, 'b', '« Prétendre » jette le doute sur ce qui est affirmé et désigne une voix dont l''auteur se démarque. Il ne valide donc pas l''optimisme (a), ne cite aucune loi (c) et ne félicite personne (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9416d013-3388-5d4d-92b4-1a4615d48435', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752', 'Lisez l''extrait :
« Le débat fut, comment dire, d''une hauteur de vue remarquable : on s''y traita de tous les noms avec une éloquence rare. »

Quel est le ton de la phrase ?', '[{"id":"a","text":"Admiratif : le débat fut d''un niveau intellectuel élevé."},{"id":"b","text":"Neutre et purement informatif."},{"id":"c","text":"Ironique : l''éloge contraste avec la bassesse des échanges."},{"id":"d","text":"Indigné et solennel, sans aucune distance."}]'::jsonb, 'c', 'L''éloge (« hauteur de vue remarquable », « éloquence rare ») est démenti par les faits (« on s''y traita de tous les noms ») : c''est une antiphrase ironique. Le ton n''est donc ni admiratif (a), ni neutre (b), et l''hésitation feinte (« comment dire ») écarte la solennité (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7d1d7a2-4d97-5746-b11c-6ac0967a71a3', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752', 'Lisez l''extrait :
« Certes, la vitesse a rapproché les hommes. Toutefois, elle les a aussi rendus incapables d''attendre, donc de désirer vraiment. »

Où se trouve la thèse défendue par l''auteur ?', '[{"id":"a","text":"Dans la première phrase : la vitesse est un bienfait sans réserve."},{"id":"b","text":"Nulle part : les deux idées s''équilibrent et s''annulent."},{"id":"c","text":"Après « Toutefois » : la vitesse abolit l''attente et appauvrit le désir."},{"id":"d","text":"Dans une idée étrangère aux deux phrases."}]'::jsonb, 'c', '« Certes… Toutefois… » est une concession suivie d''une objection : la thèse de l''auteur suit « Toutefois » (la vitesse ruine l''attente et le désir). La première phrase est seulement concédée (a), et l''auteur n''est pas neutre (b).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40910e38-27b2-5518-911d-cca9b8b2fdbc', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752', 'Lisez l''extrait :
« Il aurait, selon la rumeur, financé l''opération de ses propres deniers. »

Que signale le conditionnel « aurait financé » ?', '[{"id":"a","text":"Une donnée rapportée que l''auteur n''assume pas comme un fait établi."},{"id":"b","text":"Une certitude prouvée par des documents."},{"id":"c","text":"Une action qui se déroulera dans le futur."},{"id":"d","text":"Un ordre adressé au lecteur."}]'::jsonb, 'a', 'Le conditionnel d''information, renforcé par « selon la rumeur », marque une donnée non assumée : l''auteur la rapporte sans la garantir. Ce n''est donc ni une certitude (b), ni un futur (c), ni un ordre (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('888cab9c-e934-5412-a064-d5ce3835889e', 'c83341ca-54e4-5765-a3a4-f6a1f1c51752', 'Lisez l''extrait :
« On lui offrit la liberté de choisir entre se soumettre et disparaître. »

Quelle est la portée de l''expression « la liberté de choisir » dans ce contexte ?', '[{"id":"a","text":"Une liberté authentique, ouvrant un large éventail de possibles."},{"id":"b","text":"Une liberté ironique : le « choix » se réduit à deux issues également contraintes."},{"id":"c","text":"Une offre généreuse faite de bonne foi."},{"id":"d","text":"Une simple invitation à réfléchir longuement."}]'::jsonb, 'b', 'Présenter comme « liberté de choisir » un dilemme entre « se soumettre » et « disparaître » est une antiphrase ironique : aucune des deux issues n''est libre. Ce n''est donc ni une vraie liberté (a), ni une offre sincère (c), ni une invitation à la réflexion (d) ; l''ironie dénonce une contrainte déguisée.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

