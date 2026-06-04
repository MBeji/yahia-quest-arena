-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: fr-mastery (Maîtrise du français)
-- Regenerate with: npm run content:build
-- Source of truth: content/fr-mastery/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium) VALUES
  ('fr-mastery', 'Maîtrise du français', 'Module premium de perfectionnement de la langue française : compréhension écrite, syntaxe, grammaire et lexique. Indépendant de tout programme scolaire.', 'Sagesse', 'subject-french', 'BookOpen', 6, 'fr', true)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr,
  description = EXCLUDED.description,
  attribute = EXCLUDED.attribute,
  color_token = EXCLUDED.color_token,
  icon = EXCLUDED.icon,
  display_order = EXCLUDED.display_order,
  content_language = EXCLUDED.content_language,
  is_premium = EXCLUDED.is_premium;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'fr-mastery'
      AND e.source = 'admin'
      AND q.id NOT IN ('8680f10f-8d40-577d-b35c-88ecfd6fff8a', 'c943af63-5273-5fc1-af24-e6adde99d287', 'fddf1418-e9ef-5697-81f4-3c6fcd2feaae', 'd9f6457e-c264-587c-91ef-75cf4ac3341f', 'ed5ee1c1-ba81-57be-9b5a-59a76b8bb1b3', '6f05cdf1-ffa1-53a6-865c-3e7ef5b9f13f', '0195e47e-5a24-54a0-8d37-efdb074e38e5', 'edaae71f-2a0f-56b0-9de8-7af983a5f97a', 'c99f2101-7624-5966-b58e-bfc8fa12baec', '9ceacbb2-b92d-5d73-aa5d-98cfa7409985', 'd1eae56a-a4bf-58b9-9ea7-713473f2640a', '67de4e18-6eaa-5c85-9054-25ed7a08ab43', '1cd4d96d-aa2f-58b3-bcf2-69b54a040ef5', 'eb0f01e1-ed4d-55ee-99b2-35afd2948326', '543014f2-55ac-563c-b3d3-b44234606183', '7d30546c-fbb5-5240-9020-167990160ec1', '305156d8-219f-5eee-a20b-b902ce441b97', '74dd8103-2347-5068-9316-b65cc95f48f6', '050d08b6-399e-59f6-b9fe-019502d9bdf0', '89951cf7-dd8a-594b-9403-54a1641084b4', 'c08ae3cd-f963-52cf-84b6-beafaeca7e0e', 'd2bc1d53-6f4e-51ee-bb0b-bf5b177253f9', 'a89112a7-94e9-5e91-b04a-50edc4c953dc', '4b1c03fb-9575-51c4-bc11-850d12c955bf', 'a14d463f-5a21-5d0d-b187-2efa8905c8fd', '70b59c54-c7b6-58aa-81ee-c3e6523f65b0', '026f14b3-d80a-50ef-b862-7c312b3a8d99', 'e34a5753-21d5-58d7-86d0-65e3186e4981', 'e2d40a55-1980-57c0-9b15-a2a22f0ce69d', 'f9c2cca1-7844-5d5c-8eda-7bb309b2c1ef', 'f445d68b-2223-5682-8116-078a7a28f03b', '660243d7-9d26-5171-a25a-06fa13b891da', 'f72f5bd1-c49e-5252-8756-125c05759ab5', '025e5ee8-c412-52f1-97a1-919f13436b34', '375d49fc-7cd3-5d29-8542-e8eea2807342', 'dec2df78-f75b-55e7-ab6c-c0781f1325ea', '354fa3dd-041c-5e2b-a6bc-3a7ff1a63d01', '61ce2200-1a09-5c0b-bad7-4fbdfa7c99b5', '59f990a9-883c-5147-b3c7-67c35168c1db', 'e1768e1e-f0fa-5797-9180-d1d844ba24a2', '4b412957-d2ab-51c9-9647-8e7fc9085277', '6e1ad5a9-e292-54c2-a1e2-34c4542cb757', '1022efe2-107a-5610-879e-0bf25fa22f2c', '0a639db0-f9f9-585b-a2a7-e1a7d3453f3e', '115924d1-a555-58be-a771-5fcbad701f96', '5e4bfea9-57b3-5165-9c59-b71751b2ef84', 'b0409dd4-399d-5d99-8c58-9d75fb2bc07a', '26f7441c-d57b-5761-a6c9-16b90ec2c7f3', 'ee63c286-3de2-5973-9c22-96fffbaf86c1', '553347ac-bad6-5fc9-8c07-1e80392a33da', 'afb10bb6-999f-55bd-8122-155008c0e77e', 'e13f276a-7aac-5f4a-a773-e6bf3b275035', '68147ffc-dc72-5d42-b0de-4acc32bdf14f', '689afb94-f533-512b-9e88-140cc7cb2f68', '9b765c8d-b822-5bbd-9f21-8c13676dead8', '8b5e61ff-14e4-5f2b-97e7-e1214174224d', 'a2d3a00c-11f0-58df-becc-9b01b0c28d46', '902e41b0-978f-5f5b-9d50-671be361e6de', 'd1c704b3-d2c1-5494-9a83-3e546078888e', '4ca1c45c-63f9-5298-b5b8-4c5786e44c8c', 'c11b1d50-1b25-5bff-8225-f1fe1d80e993', '4db617a3-c445-5c2c-b81e-d7dcd502200c', '2d82bdb6-d713-5a54-ac54-abf97f260c5e', '45650677-9f13-5d19-896f-49157dbbd7f1', '183ea238-cae4-5fdb-bae1-ac120e01907e', 'e480c693-6f3f-50e6-9a24-fd45d2cebccb', '8ebefc85-d7ac-5d15-bead-db4207d08461', '5b5e3d20-2505-58d2-bbfe-50a8dbcd256c', '6c35ac86-7613-51cf-9a30-88bd5fa54a75', 'a5f03323-bbcb-54ec-abaf-8698b6e52ed3', 'ec46e2f3-8c2c-5d00-bf65-2c70abb9116d', '013f1b15-e4ea-5d75-b28c-e0515a027df5', '4438d74f-ed2d-565d-a342-971ae57232d8', '7400f4c5-9e93-5a49-9a31-9aa0aff92d25', '851df533-6479-59d6-863d-5265cb8fa8d2', 'c637e468-2efd-5f88-a681-dc7efd7eefd0', '7be23713-0f88-53c8-9b38-caee5ebb556e', 'ce54f665-a4d5-5529-ab5f-8a1f1af15c40', '54a3cc39-3157-5d8e-9ef0-5183474954b7', '0e91ac31-d95e-53c9-a53c-35fd08f4efcf', '00b519a1-3006-539e-ba8d-c75c4178cf56', 'f73ee323-bb3c-59b7-9d16-dba2847fbaf5', 'b4498f76-9810-5847-becb-1930b226c782', 'c91d708c-58ca-5f6a-9a38-150c20c3ada0', 'ed7dc171-9562-59b6-86d4-4c0aa32154db', 'ac16c26b-a52b-5105-8a5d-177753609eb4', '49ba7791-70c4-5618-8b9f-b4ab73617396', 'a2734595-ffd1-5cb6-8948-9d13ebdf9b20', '6d99f9d8-fcb6-5a7d-9baf-459d334b4cd6', 'ab216150-dd83-579a-8f57-80bb1ed85e02', 'e2e27486-5901-5b7b-9f51-3fe5324ca8d7', '3abac0a4-d792-5edc-93ef-a33f33d4859e', '3375ad20-96fe-554b-9520-fc7939ef43fb', '766d61e0-2be1-5e35-979c-76c48ce2154c', '82f28540-d59d-5d25-b090-d08b1f2dcc68', 'b09c3bfa-b228-56cd-99f9-54366c124d14', 'f8565956-c4bb-50ef-ab48-27cbb2f6ef63', 'ccb068ce-d222-5367-99dd-98988ced687b', '28fc8b33-1a6c-5e88-9c8f-57e07682634d', '966c30fa-0738-5b10-8f72-7d212cdac238', 'b39f3841-74ef-53de-8648-ee43d15429b8', '8e09901c-fd3c-5a9c-9544-0216fdde2ac8', '4f70f10b-563d-576a-8424-b798ff3c453f', '759d6691-82c9-58b7-b4a1-8528cea9c6ce', 'bebb8ff8-4c6c-58af-864a-e214786fe43e', '29709e99-70e0-597e-b8e5-c5efe47be0b5', '388e036e-cd33-5c4e-9d91-4d1600e416ad', 'a5511b2b-1054-5205-bebc-e62e6ba38318', '095ee978-daef-52a9-ac8d-046d80c81024', 'af7c8f70-d1a9-50c6-a081-1efc1c20792b', 'b1d2bc86-bf86-527b-8ddf-69e22c4356e2', 'ff3d65f3-a07b-5787-8931-694b37d358e9', 'a4021c34-6085-5253-a2df-13d29fdee570', 'bd984a6b-8d79-5b8b-9bcb-e48edf379300');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'fr-mastery' AND source = 'admin' AND id NOT IN ('54ebcf26-152c-5cc6-9442-9a71e96be049', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', '285d4a2f-f961-5728-9f15-7468924a29aa', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'b566b02c-fbad-5f84-8ddc-ebf03091d01a', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', '25b15911-6bf2-5f29-8228-13c586098442', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', '8fabba57-8b30-5556-93df-aa2262c2be6e', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', '8ab4d9e6-cc7a-54de-b89d-acea53b3c2b8', '386598a5-17d9-51eb-9865-0080cbdd5d02', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', '38655883-4f78-5df4-b448-466ffb2dd3b2', '6419b53e-71ab-5c5e-9801-72544a707d1a', '29169835-f5bb-546d-b09a-54a5fc7e260f');
DELETE FROM public.questions WHERE exercise_id IN ('54ebcf26-152c-5cc6-9442-9a71e96be049', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', '285d4a2f-f961-5728-9f15-7468924a29aa', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'b566b02c-fbad-5f84-8ddc-ebf03091d01a', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', '25b15911-6bf2-5f29-8228-13c586098442', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', '8fabba57-8b30-5556-93df-aa2262c2be6e', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', '8ab4d9e6-cc7a-54de-b89d-acea53b3c2b8', '386598a5-17d9-51eb-9865-0080cbdd5d02', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', '38655883-4f78-5df4-b448-466ffb2dd3b2', '6419b53e-71ab-5c5e-9801-72544a707d1a', '29169835-f5bb-546d-b09a-54a5fc7e260f') AND id NOT IN ('8680f10f-8d40-577d-b35c-88ecfd6fff8a', 'c943af63-5273-5fc1-af24-e6adde99d287', 'fddf1418-e9ef-5697-81f4-3c6fcd2feaae', 'd9f6457e-c264-587c-91ef-75cf4ac3341f', 'ed5ee1c1-ba81-57be-9b5a-59a76b8bb1b3', '6f05cdf1-ffa1-53a6-865c-3e7ef5b9f13f', '0195e47e-5a24-54a0-8d37-efdb074e38e5', 'edaae71f-2a0f-56b0-9de8-7af983a5f97a', 'c99f2101-7624-5966-b58e-bfc8fa12baec', '9ceacbb2-b92d-5d73-aa5d-98cfa7409985', 'd1eae56a-a4bf-58b9-9ea7-713473f2640a', '67de4e18-6eaa-5c85-9054-25ed7a08ab43', '1cd4d96d-aa2f-58b3-bcf2-69b54a040ef5', 'eb0f01e1-ed4d-55ee-99b2-35afd2948326', '543014f2-55ac-563c-b3d3-b44234606183', '7d30546c-fbb5-5240-9020-167990160ec1', '305156d8-219f-5eee-a20b-b902ce441b97', '74dd8103-2347-5068-9316-b65cc95f48f6', '050d08b6-399e-59f6-b9fe-019502d9bdf0', '89951cf7-dd8a-594b-9403-54a1641084b4', 'c08ae3cd-f963-52cf-84b6-beafaeca7e0e', 'd2bc1d53-6f4e-51ee-bb0b-bf5b177253f9', 'a89112a7-94e9-5e91-b04a-50edc4c953dc', '4b1c03fb-9575-51c4-bc11-850d12c955bf', 'a14d463f-5a21-5d0d-b187-2efa8905c8fd', '70b59c54-c7b6-58aa-81ee-c3e6523f65b0', '026f14b3-d80a-50ef-b862-7c312b3a8d99', 'e34a5753-21d5-58d7-86d0-65e3186e4981', 'e2d40a55-1980-57c0-9b15-a2a22f0ce69d', 'f9c2cca1-7844-5d5c-8eda-7bb309b2c1ef', 'f445d68b-2223-5682-8116-078a7a28f03b', '660243d7-9d26-5171-a25a-06fa13b891da', 'f72f5bd1-c49e-5252-8756-125c05759ab5', '025e5ee8-c412-52f1-97a1-919f13436b34', '375d49fc-7cd3-5d29-8542-e8eea2807342', 'dec2df78-f75b-55e7-ab6c-c0781f1325ea', '354fa3dd-041c-5e2b-a6bc-3a7ff1a63d01', '61ce2200-1a09-5c0b-bad7-4fbdfa7c99b5', '59f990a9-883c-5147-b3c7-67c35168c1db', 'e1768e1e-f0fa-5797-9180-d1d844ba24a2', '4b412957-d2ab-51c9-9647-8e7fc9085277', '6e1ad5a9-e292-54c2-a1e2-34c4542cb757', '1022efe2-107a-5610-879e-0bf25fa22f2c', '0a639db0-f9f9-585b-a2a7-e1a7d3453f3e', '115924d1-a555-58be-a771-5fcbad701f96', '5e4bfea9-57b3-5165-9c59-b71751b2ef84', 'b0409dd4-399d-5d99-8c58-9d75fb2bc07a', '26f7441c-d57b-5761-a6c9-16b90ec2c7f3', 'ee63c286-3de2-5973-9c22-96fffbaf86c1', '553347ac-bad6-5fc9-8c07-1e80392a33da', 'afb10bb6-999f-55bd-8122-155008c0e77e', 'e13f276a-7aac-5f4a-a773-e6bf3b275035', '68147ffc-dc72-5d42-b0de-4acc32bdf14f', '689afb94-f533-512b-9e88-140cc7cb2f68', '9b765c8d-b822-5bbd-9f21-8c13676dead8', '8b5e61ff-14e4-5f2b-97e7-e1214174224d', 'a2d3a00c-11f0-58df-becc-9b01b0c28d46', '902e41b0-978f-5f5b-9d50-671be361e6de', 'd1c704b3-d2c1-5494-9a83-3e546078888e', '4ca1c45c-63f9-5298-b5b8-4c5786e44c8c', 'c11b1d50-1b25-5bff-8225-f1fe1d80e993', '4db617a3-c445-5c2c-b81e-d7dcd502200c', '2d82bdb6-d713-5a54-ac54-abf97f260c5e', '45650677-9f13-5d19-896f-49157dbbd7f1', '183ea238-cae4-5fdb-bae1-ac120e01907e', 'e480c693-6f3f-50e6-9a24-fd45d2cebccb', '8ebefc85-d7ac-5d15-bead-db4207d08461', '5b5e3d20-2505-58d2-bbfe-50a8dbcd256c', '6c35ac86-7613-51cf-9a30-88bd5fa54a75', 'a5f03323-bbcb-54ec-abaf-8698b6e52ed3', 'ec46e2f3-8c2c-5d00-bf65-2c70abb9116d', '013f1b15-e4ea-5d75-b28c-e0515a027df5', '4438d74f-ed2d-565d-a342-971ae57232d8', '7400f4c5-9e93-5a49-9a31-9aa0aff92d25', '851df533-6479-59d6-863d-5265cb8fa8d2', 'c637e468-2efd-5f88-a681-dc7efd7eefd0', '7be23713-0f88-53c8-9b38-caee5ebb556e', 'ce54f665-a4d5-5529-ab5f-8a1f1af15c40', '54a3cc39-3157-5d8e-9ef0-5183474954b7', '0e91ac31-d95e-53c9-a53c-35fd08f4efcf', '00b519a1-3006-539e-ba8d-c75c4178cf56', 'f73ee323-bb3c-59b7-9d16-dba2847fbaf5', 'b4498f76-9810-5847-becb-1930b226c782', 'c91d708c-58ca-5f6a-9a38-150c20c3ada0', 'ed7dc171-9562-59b6-86d4-4c0aa32154db', 'ac16c26b-a52b-5105-8a5d-177753609eb4', '49ba7791-70c4-5618-8b9f-b4ab73617396', 'a2734595-ffd1-5cb6-8948-9d13ebdf9b20', '6d99f9d8-fcb6-5a7d-9baf-459d334b4cd6', 'ab216150-dd83-579a-8f57-80bb1ed85e02', 'e2e27486-5901-5b7b-9f51-3fe5324ca8d7', '3abac0a4-d792-5edc-93ef-a33f33d4859e', '3375ad20-96fe-554b-9520-fc7939ef43fb', '766d61e0-2be1-5e35-979c-76c48ce2154c', '82f28540-d59d-5d25-b090-d08b1f2dcc68', 'b09c3bfa-b228-56cd-99f9-54366c124d14', 'f8565956-c4bb-50ef-ab48-27cbb2f6ef63', 'ccb068ce-d222-5367-99dd-98988ced687b', '28fc8b33-1a6c-5e88-9c8f-57e07682634d', '966c30fa-0738-5b10-8f72-7d212cdac238', 'b39f3841-74ef-53de-8648-ee43d15429b8', '8e09901c-fd3c-5a9c-9544-0216fdde2ac8', '4f70f10b-563d-576a-8424-b798ff3c453f', '759d6691-82c9-58b7-b4a1-8528cea9c6ce', 'bebb8ff8-4c6c-58af-864a-e214786fe43e', '29709e99-70e0-597e-b8e5-c5efe47be0b5', '388e036e-cd33-5c4e-9d91-4d1600e416ad', 'a5511b2b-1054-5205-bebc-e62e6ba38318', '095ee978-daef-52a9-ac8d-046d80c81024', 'af7c8f70-d1a9-50c6-a081-1efc1c20792b', 'b1d2bc86-bf86-527b-8ddf-69e22c4356e2', 'ff3d65f3-a07b-5787-8931-694b37d358e9', 'a4021c34-6085-5253-a2df-13d29fdee570', 'bd984a6b-8d79-5b8b-9bcb-e48edf379300');
DELETE FROM public.chapters c WHERE c.subject_id = 'fr-mastery' AND c.id NOT IN ('2a753d3d-b1b1-5d10-a785-849d04e11ed9', '3d2a602e-0a87-5334-b9b0-cd5dfacc5a4b', 'b639796a-5cad-5da3-8402-37ce2601e5db', '4aa90233-3a14-53a0-ba53-31a005968fcf', '2567b64f-bd7c-5121-8690-413031a1ac80') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('2a753d3d-b1b1-5d10-a785-849d04e11ed9', 'fr-mastery', 'Compréhension écrite', 'Méthodes et stratégies pour lire activement, identifier la thèse et les arguments, saisir l''implicite et analyser la visée d''un texte.', '# Compréhension écrite — Méthodologie active

> « Lire, ce n''est pas déchiffrer : c''est interroger un texte pour en extraire le sens exact et le sens caché. »

## 1. Adopter une posture de lecteur actif

Avant de lire, repérez rapidement le **paratexte** : titre, source, date, auteur. Ces indices orientent votre attente et vous donnent un premier contexte. Pendant la lecture, annotez mentalement (ou sur la copie) : soulignez l''idée principale de chaque paragraphe, encerclez les connecteurs logiques, notez les mots qui reviennent.

## 2. Identifier la structure du texte

Tout texte obéit à une **logique interne**. Reconnaître son type aide à anticiper son organisation :

| Type de texte | Organisation typique                         | Indices                                     |
| ------------- | -------------------------------------------- | ------------------------------------------- |
| Argumentatif  | thèse → arguments → conclusion               | « or », « donc », « en revanche »           |
| Explicatif    | problème → développement → synthèse          | « en effet », « c''est pourquoi », « ainsi » |
| Narratif      | situation initiale → péripéties → dénouement | temps du récit, verbes d''action             |
| Descriptif    | du général au particulier (ou inverse)       | adjectifs, comparaisons, présent            |

## 3. Repérer thèse, arguments et connecteurs

Dans un texte argumentatif, localisez la **thèse** (position défendue par l''auteur) dès le premier paragraphe ou la conclusion. Chaque argument l''étaye : cherchez les **connecteurs d''addition** (_de plus, par ailleurs_), de **cause** (_car, puisque, étant donné que_), d''**opposition** (_cependant, néanmoins, or_) et de **conséquence** (_donc, ainsi, c''est pourquoi_). Le connecteur révèle le lien logique entre deux idées — comprendre ce lien, c''est comprendre le raisonnement.

## 4. Saisir l''implicite et l''inférence

Un texte ne dit pas tout. Certaines informations sont **implicites** : le lecteur doit les déduire du contexte, du registre ou du choix des mots. Distinguez :

- **L''inférence logique** : ce qui découle nécessairement du texte (si A alors B).
- **Le présupposé** : ce que l''énoncé tient pour acquis sans le dire (_« Il a cessé de mentir »_ présuppose qu''il mentait).
- **Le sous-entendu** : ce que l''auteur laisse entendre sans l''affirmer explicitement.

## 5. Analyser le ton et la visée

Le **ton** trahit l''attitude de l''auteur : ironique, admiratif, polémique, didactique, lyrique… Repérez le champ lexical dominant, les modalisateurs (_peut-être, certainement, hélas_) et les figures de style. La **visée** désigne l''effet recherché sur le lecteur : informer, convaincre, émouvoir, divertir, dénoncer. Un même texte peut combiner plusieurs visées.

## 6. Méthode en situation d''examen

1. **Première lecture** rapide : saisir le sujet global.
2. **Lecture des questions** avant la deuxième lecture.
3. **Deuxième lecture** ciblée : cherchez précisément ce que les questions demandent.
4. **Reformulation** : répondez dans vos propres mots ; évitez le copier-coller qui masque souvent une incompréhension.
5. **Vérification** : votre réponse est-elle bien ancrée dans le texte, ou s''agit-il d''une opinion personnelle ?

> Une bonne réponse de compréhension s''appuie toujours sur des **preuves textuelles**, jamais sur des impressions.', '# Résumé — Compréhension écrite

- **Lecture active** : exploiter le paratexte (titre, source, date) avant de lire ; annoter pendant la lecture.
- **4 types de textes** : argumentatif (thèse + arguments), explicatif (problème → synthèse), narratif (chronologie des événements), descriptif (portrait ou tableau).
- **Connecteurs** : marqueurs logiques qui révèlent les relations entre les idées — addition, cause, opposition, conséquence.
- **Thèse** : position défendue par l''auteur ; souvent en ouverture ou en clôture du texte.
- **Implicite** : distinguer inférence logique, présupposé et sous-entendu ; ce qui est impliqué sans être dit.
- **Ton** : attitude de l''auteur révélée par le champ lexical, les modalisateurs et les figures de style (ironique, didactique, polémique…).
- **Visée** : effet visé sur le lecteur — informer, convaincre, émouvoir, dénoncer, divertir.
- **Méthode en 5 étapes** : lecture rapide → lire les questions → lecture ciblée → reformulation personnelle → vérification par ancrage textuel.
- Toute réponse de compréhension doit s''appuyer sur des **preuves dans le texte**, jamais sur des opinions extérieures.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3d2a602e-0a87-5334-b9b0-cd5dfacc5a4b', 'fr-mastery', 'Syntaxe', 'Fonctions syntaxiques, structure de la phrase simple et complexe, ordre des mots et procédés de mise en relief.', '# Syntaxe — Structure et fonctions de la phrase

> « Maîtriser la syntaxe, c''est donner à sa pensée une architecture précise : chaque mot occupe une place, chaque groupe remplit une fonction. »

## 1. Les fonctions syntaxiques essentielles

Toute phrase articule des groupes qui entretiennent des **relations fonctionnelles** avec le verbe ou avec le nom.

| Fonction                              | Définition                                                            | Exemple                                       |
| ------------------------------------- | --------------------------------------------------------------------- | --------------------------------------------- |
| **Sujet**                             | Être ou chose dont on dit quelque chose ; commande l''accord du verbe  | _La clarté de l''exposé_ convainc l''auditoire. |
| **COD** (complément d''objet direct)   | Complète le verbe sans préposition ; répond à « quoi ? / qui ? »      | Il défend _ses idées_.                        |
| **COI** (complément d''objet indirect) | Complète le verbe via une préposition (_à, de_)                       | Elle renonce _à ses certitudes_.              |
| **Attribut du sujet**                 | Qualifie le sujet via un verbe d''état (_être, paraître, sembler_…)    | Ce texte _est remarquable_.                   |
| **Attribut du COD**                   | Qualifie le COD dans la même proposition                              | On juge cet argument _irrecevable_.           |
| **Complément circonstanciel**         | Indique les circonstances (temps, lieu, manière, cause…) ; déplaçable | _À l''aube_, le débat reprit.                  |
| **Complément du nom**                 | Précise un nom, généralement introduit par _de_                       | La rigueur _du raisonnement_ s''impose.        |
| **Épithète**                          | Adjectif directement rattaché au nom, sans verbe intermédiaire        | Un argument _convaincant_ s''impose.           |

## 2. Structure de la phrase : de la simple à la complexe

La **phrase simple** ne contient qu''un seul verbe conjugué. La **phrase complexe** en réunit au moins deux, reliées par :

- **Juxtaposition** : propositions séparées par un signe de ponctuation (_virgule, point-virgule, deux-points_). Le lien logique est implicite et doit être interprété par le lecteur. Ex. : _Il plaida avec conviction ; le jury l''acquitta._
- **Coordination** : propositions reliées par une conjonction de coordination (_mais, ou, et, donc, or, ni, car_) qui rend explicite le rapport logique. Ex. : _Il avait raison, **mais** personne ne l''écoutait._
- **Subordination** : une proposition dépend syntaxiquement d''une autre ; le **subordonnant** (conjonction de subordination, pronom relatif) précise la nature du lien (cause, temps, but, relative…). Ex. : _Il argumenta **si bien que** l''assemblée changea d''avis._

## 3. Ordre des mots et topicalisation

L''ordre canonique du français est **SVO** (Sujet — Verbe — Objet). Tout écart est porteur de sens :

- **Antéposition du CC** : met l''accent sur la circonstance. Ex. : _Dans ce contexte précis, l''auteur adopte un ton polémique._
- **Postposition du sujet** (inversion) : dans les propositions incises, les interrogatives directes et certains styles soutenus. Ex. : _« Partez ! » \_cria-t-il_.\_
- **Détachement par virgule** : un groupe peut être détaché en tête ou en queue de phrase pour être mis en évidence. Ex. : _Cette hypothèse, il la rejetait catégoriquement._

## 4. Mise en relief

Deux constructions permettent de focaliser un élément :

- **Présentatif** (_c''est… qui / c''est… que_) : _**C''est la syntaxe** qui révèle la maîtrise du scripteur._
- **Thématisation** (dislocation) : l''élément thématisé est repris par un pronom. _**La précision lexicale**, il y tenait par-dessus tout._

## 5. Ponctuation à valeur syntaxique

La ponctuation n''est pas ornementale : elle structure les relations entre propositions. La **virgule** sépare les éléments juxtaposés et isole les appositions ou les CC détachés. Le **point-virgule** équilibre deux propositions de même rang. Les **deux-points** annoncent une explication, une conséquence ou une énumération. Le **tiret** encadre une incise ou une parenthèse syntaxique.

> **À retenir** : analyser une phrase, c''est identifier ses propositions, les relier logiquement, puis attribuer à chaque groupe nominal ou verbal sa fonction précise au sein de la proposition qui le contient.', '# Résumé — Syntaxe

- **Fonctions essentielles** : sujet (commande l''accord du verbe), COD (sans préposition, « quoi ? »), COI (avec préposition _à / de_), attribut du sujet (via verbe d''état), attribut du COD, complément circonstanciel (déplaçable), complément du nom, épithète.
- **Phrase simple** = un seul verbe conjugué ; **phrase complexe** = au moins deux propositions.
- **Trois modes de liaison** des propositions :
  - Juxtaposition : ponctuation, lien implicite.
  - Coordination : conjonction de coordination (_mais, ou, et, donc, or, ni, car_), lien explicite.
  - Subordination : subordonnant (conjonction ou pronom relatif), proposition dépendante.
- **Ordre canonique** : Sujet — Verbe — Objet (SVO). Toute variation est stylistiquement motivée.
- **Mise en relief** : présentatif (_c''est… qui / c''est… que_) ou thématisation avec reprise pronominale.
- **Ponctuation syntaxique** : virgule (juxtaposition, détachement), point-virgule (équilibre), deux-points (explication / énumération), tiret (incise).
- **Identification d''une fonction** : chercher le verbe → identifier le groupe grammatical → poser la question appropriée (sujet : « qui est-ce qui ? » ; COD : « verbe quoi / qui ? » ; COI : « verbe à qui / de quoi ? »).', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('b639796a-5cad-5da3-8402-37ce2601e5db', 'fr-mastery', 'Grammaire', 'Maîtriser les accords, les modes et temps verbaux, la concordance, les déterminants et pronoms, et les homophones grammaticaux pour écrire avec précision et rigueur.', '# Grammaire — Méthodologie

> « Écrire sans fautes, c''est respecter le lecteur et donner toute sa force à sa pensée. »

## 1. Les accords

### Accord sujet-verbe

Le verbe s''accorde en nombre et en personne avec son sujet grammatical, même lorsque celui-ci est séparé du verbe par une proposition intercalée ou une accumulation de compléments.

- Sujet collectif + complément pluriel : **« La foule des spectateurs _applaudissait_.»** (accord avec « foule », sujet réel).
- Sujets coordonnés par _et_ : verbe au pluriel. Coordonnés par _ou_ / _ni_ : accord selon le sens (exclusion → singulier ; cumul possible → pluriel).
- Sujet inversé (phrase interrogative ou incise) : repérer le sujet réel avant d''accorder.

### Accord du participe passé

| Auxiliaire            | Règle                                                          | Exemple                                                                |
| --------------------- | -------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **être**              | S''accorde avec le sujet                                        | Elles sont _parties_.                                                  |
| **avoir**             | S''accorde avec le COD si celui-ci est **placé avant** le verbe | Les lettres qu''il a _écrites_.                                         |
| **avoir** (COD après) | Invariable                                                     | Il a _écrit_ des lettres.                                              |
| Verbe pronominal      | Accord avec le COD antéposé (généralement le sujet réfléchi)   | Elles se sont _regardées_. / Elles se sont _parlé_. (COI → invariable) |

### Accords complexes

- **Adjectif épithète** : s''accorde avec le nom qu''il qualifie (genre et nombre).
- **Adjectif attribut** : s''accorde avec le sujet ou le COD selon la construction.
- **Tout** (adverbe devant adjectif féminin commençant par consonne ou h aspiré) : _toute(s)_ — sinon invariable : _tout étonnées_, mais _tout heureuses_.

## 2. Modes, temps et leurs valeurs

Chaque mode exprime la manière dont le locuteur envisage l''action :

- **Indicatif** : fait réel, certain, daté. Ses temps principaux — présent (instant, habitude, vérité générale), imparfait (décor, durée passée), passé simple (action ponctuelle littéraire), passé composé (fait accompli, usage courant), futur simple (projection certaine), plus-que-parfait (antériorité par rapport à un passé).
- **Subjonctif** : fait envisagé, souhaité, douteux ou exigé. Déclenché par _il faut que, bien que, pour que, à moins que, vouloir que, douter que_… Formation : radical de _ils_ au présent + _-e, -es, -e, -ions, -iez, -ent_.
- **Conditionnel** : hypothèse (_si_ + imparfait → conditionnel), politesse, information non confirmée, futur dans le passé. Formation : radical du futur + terminaisons de l''imparfait.
- **Impératif** : ordre, conseil, prière. Seulement 3 personnes (sans sujet). Verbes en _-er_ : pas de _-s_ à la 2e sg. sauf devant _-y_ / _-en_ (_Vas-y !_).

## 3. La concordance des temps

Dans une subordonnée, le temps dépend du verbe principal :

- Verbe principal au **présent / futur** → subordonnée au présent ou futur selon le sens.
- Verbe principal au **passé** → subordonnée à l''imparfait (simultanéité), au plus-que-parfait (antériorité), ou au conditionnel présent (postériorité / futur dans le passé).

> Exemple : _Il savait qu''elle **viendrait**._ (futur dans le passé → conditionnel)

## 4. Déterminants et pronoms

- **Déterminants** (articles, possessifs, démonstratifs, indéfinis) : s''accordent avec le nom qu''ils introduisent.
- **Pronoms personnels** : vérifient que le référent est clair et accordé (_le, la, les, lui, leur, y, en_).
- **Pronoms relatifs** : _qui_ (sujet), _que_ (COD), _dont_ (complément avec _de_), _où_ (lieu/temps), _lequel/laquelle_ (après préposition).
- Piège fréquent : _leur_ invariable (pronom COI) vs _leurs_ variable (déterminant possessif).

## 5. Homophones grammaticaux

| Homophone                            | Distinction                                                          | Astuce                                       |
| ------------------------------------ | -------------------------------------------------------------------- | -------------------------------------------- |
| **a / à**                            | _a_ = verbe avoir (remplaçable par _avait_) ; _à_ = préposition      | _Il a faim._ / _Il va à Rome._               |
| **ce / se**                          | _ce_ = démonstratif ou pronom neutre ; _se_ = pronom réfléchi        | _Ce livre_ / _Il se lève._                   |
| **leur / leurs**                     | _leur_ pronom (inv.) ; _leurs_ déterminant (variable)                | _Je leur parle._ / _leurs livres_            |
| **quel(s) / quelle(s) / qu''elle(s)** | _quel_ = déterminant exclamatif/interr. ; _qu''elle_ = _que_ + _elle_ | _Quel beau jour !_ / _Je vois qu''elle part._ |
| **ou / où**                          | _ou_ = conjonction (= _ou bien_) ; _où_ = adverbe de lieu/temps      | _pain ou fromage_ / _le pays où je vis_      |
| **on / ont**                         | _on_ = pronom sujet ; _ont_ = avoir (remplaçable par _avaient_)      | _On part._ / _Ils ont fini._                 |
| **mais / mes / met / mets**          | distinguer par la classe grammaticale et le contexte                 | _Mais oui !_ / _mes amis_ / _il met_         |

## Méthode générale

1. Identifier la **nature** (nom, verbe, adjectif, pronom…) et la **fonction** de chaque mot.
2. Repérer le **sujet réel** du verbe avant d''accorder.
3. Pour le participe passé : quel auxiliaire ? Le COD est-il antéposé ?
4. Pour les modes : quelle est l''intention du locuteur ? Quelle conjonction introduit la subordonnée ?
5. Pour les homophones : tenter la substitution (_avait_ pour _a_, _ou bien_ pour _ou_, etc.).', '# Résumé — Grammaire

## Accords

- **Sujet-verbe** : accord en nombre et en personne avec le sujet grammatical réel (attention aux sujets collectifs, inversés, coordonnés).
- **Participe passé avec être** : accord avec le sujet.
- **Participe passé avec avoir** : accord avec le COD uniquement s''il est placé **avant** le verbe ; invariable sinon.
- **Verbes pronominaux** : accord avec le COD antéposé (souvent le sujet) ; invariable si le pronom est COI (_elles se sont parlé_).
- **Adjectif** : accord en genre et en nombre avec le nom qualifié (épithète) ou le sujet/COD (attribut).

## Modes et temps

- **Indicatif** : fait réel/certain. Temps clés : présent, imparfait (décor/durée), passé simple (action ponctuelle littéraire), passé composé (fait accompli courant), futur simple, plus-que-parfait (antériorité dans le passé).
- **Subjonctif** : fait envisagé/douteux/exigé. Après _il faut que, bien que, pour que, à moins que, vouloir que, douter que_… Formation : radical de _ils_ présent + _-e, -es, -e, -ions, -iez, -ent_.
- **Conditionnel** : hypothèse (_si_ + imparfait → conditionnel), politesse, information non confirmée, futur dans le passé. Formation : radical du futur + terminaisons de l''imparfait.
- **Impératif** : ordre/conseil/prière, 3 personnes sans sujet. Verbes en _-er_ : pas de _-s_ à la 2e sg. (sauf _vas-y, manges-en_).

## Concordance des temps

- Verbe principal au **passé** → subordonnée : imparfait (simultanéité), plus-que-parfait (antériorité), conditionnel présent (postériorité).
- Verbe principal au **présent/futur** → subordonnée au présent ou futur selon le sens.

## Déterminants et pronoms

- Déterminants et adjectifs s''accordent avec le nom.
- _leur_ (pronom COI) = invariable ; _leurs_ (déterminant possessif) = variable.
- Pronoms relatifs : _qui_ (sujet), _que_ (COD), _dont_ (compl. de _de_), _où_ (lieu/temps), _lequel_ (après préposition).

## Homophones grammaticaux

- **a/à** : _a_ (avoir, remplaçable par _avait_) / _à_ (préposition).
- **ce/se** : _ce_ (démonstratif/pronom neutre) / _se_ (pronom réfléchi).
- **leur/leurs** : pronom invariable / déterminant variable.
- **quel/qu''elle** : déterminant / _que_ + _elle_.
- **ou/où** : conjonction (= _ou bien_) / adverbe de lieu ou de temps.
- **on/ont** : pronom sujet / verbe avoir (remplaçable par _avaient_).

## Méthode

1. Identifier nature et fonction de chaque mot.
2. Repérer le sujet réel avant d''accorder le verbe.
3. Pour le participe passé : auxiliaire → position du COD.
4. Pour les modes : intention + conjonction introductrice.
5. Pour les homophones : tester la substitution (_avait_, _ou bien_, _avaient_…).', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4aa90233-3a14-53a0-ba53-31a005968fcf', 'fr-mastery', 'Lexique', 'Maîtriser le sens des mots en contexte, enrichir son vocabulaire actif par les synonymes, antonymes, familles de mots, registres de langue, paronymes et expressions idiomatiques.', '# Lexique — Méthodologie

> « Enrichir son vocabulaire, c''est affiner sa pensée : un mot précis vaut mieux que dix approximations. »

## Sens propre, sens figuré et polysémie

Un mot peut posséder plusieurs sens : c''est la **polysémie**. Son **sens propre** est concret et littéral (_le feu brûle la forêt_) ; son **sens figuré** est imagé et transféré (_le feu de la passion_). En contexte, le sens exact se dégage toujours de la phrase entière : ne jamais isoler un mot de son environnement.

**Méthode** : identifier le sujet, le verbe et le complément pour décider quel sens est activé.

## Synonymes et antonymes en contexte

Les **synonymes** partagent un sens voisin mais ne sont jamais totalement interchangeables : _courageux_, _intrépide_, _téméraire_ nuancent une même idée. Les **antonymes** expriment le contraire (_clarté / obscurité_, _avare / prodigue_).

**Règle d''or** : choisir un synonyme en tenant compte du registre, de la construction grammaticale et des connotations de la phrase cible.

## Familles de mots et dérivation

Un **radical** (ou base) porte le sens fondamental. La **dérivation** construit de nouveaux mots par :

- **Préfixation** : _in-/im-/il-/ir-_ (privatif), _re-/ré-_ (répétition), _pré-_ (antériorité), _sur-_ (excès), _inter-_ (relation mutuelle).
- **Suffixation** : _-ité/-té_ (qualité abstraite), _-ation_ (action), _-eur/-eur_ (agent), _-ifier_ (rendre), _-able/-ible_ (possibilité).

Reconnaître la famille d''un mot inconnu permet d''en déduire le sens par inférence (_intransigeant_ = _in-_ privatif + _transigeant_ → qui ne transige pas).

## Registres de langue

| Registre     | Caractéristiques                        | Exemple                        |
| ------------ | --------------------------------------- | ------------------------------ |
| **Soutenu**  | Vocabulaire choisi, tournures élaborées | _Il est parti précipitamment._ |
| **Courant**  | Langue standard, neutre                 | _Il est parti vite._           |
| **Familier** | Relâchement syntaxique, argot           | _Il s''est barré en vitesse._   |

Adapter le registre au contexte (écrit formel, conversation, littérature) est une compétence active fondamentale.

## Paronymes : ne pas confondre

Les **paronymes** se ressemblent par la forme mais diffèrent par le sens :

- _influer_ (avoir une influence, intransitif) / _influencer_ (agir sur quelqu''un, transitif)
- _conjecture_ (hypothèse) / _conjoncture_ (situation économique ou sociale)
- _éminent_ (remarquable) / _imminent_ (qui va se produire très prochainement)
- _collision_ (choc entre objets) / _collusion_ (entente secrète et frauduleuse)

**Astuce** : mémoriser chaque paronyme dans une phrase-contexte, jamais seul.

## Expressions idiomatiques

Une **expression idiomatique** (ou locution figée) ne se comprend pas mot à mot ; son sens est conventionnel : _avoir le cafard_ (être mélancolique), _brûler les étapes_ (aller trop vite), _mettre de l''huile sur le feu_ (aggraver un conflit). Les apprendre en contexte — avec l''idée véhiculée et un exemple d''emploi — est la seule voie efficace.

## Apprendre le vocabulaire de manière active

1. **Contextualiser** : toujours noter le mot dans la phrase où il a été rencontré.
2. **Réseauter** : relier le mot à sa famille, ses synonymes et ses antonymes.
3. **Réemployer** : produire au moins deux phrases personnelles avec le mot.
4. **Réviser en spirale** : revoir les mots à intervalles croissants (répétition espacée).', '# Résumé — Lexique

- **Sens propre / sens figuré** : le sens propre est littéral et concret ; le sens figuré est imagé. La **polysémie** désigne la pluralité de sens d''un même mot, toujours déterminée par le contexte.
- **Synonymes** : sens voisin mais non interchangeable sans vérifier registre, construction et connotation.
- **Antonymes** : sens contraire (_clarté / obscurité_, _avare / prodigue_).
- **Familles de mots** : radical commun + dérivation par préfixes (_in-_, _re-_, _sur-_, _inter-_…) et suffixes (_-ité_, _-ation_, _-able_…). Inférer le sens d''un mot inconnu à partir de sa famille.
- **Registres de langue** : soutenu (vocabulaire choisi), courant (standard), familier (relâché/argotique). Adapter le registre au contexte est indispensable.
- **Paronymes** : forme proche, sens différent — _influer/influencer_, _conjecture/conjoncture_, _éminent/imminent_, _collision/collusion_. Les mémoriser en contexte.
- **Expressions idiomatiques** : sens conventionnel non compositionnel (_avoir le cafard_, _brûler les étapes_). Apprendre avec l''idée et un exemple d''emploi.
- **Apprentissage actif** : contextualiser, réseauter (famille + synonymes + antonymes), réemployer en phrases personnelles, réviser en spirale (répétition espacée).', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('2567b64f-bd7c-5121-8690-413031a1ac80', 'fr-mastery', 'Annales & épreuves de synthèse', 'Des épreuves de synthèse exigeantes qui mêlent, sur un même texte, les quatre axes du module : compréhension fine et inférence, syntaxe, grammaire et lexique de précision. Niveau perfectionnement, au-delà du tronc commun.', '# Annales & épreuves de synthèse — Méthodologie

> « Une épreuve de synthèse ne juge pas une compétence isolée : elle révèle la cohérence de votre lecture, de votre analyse de la phrase et de votre maîtrise des mots. »

Une **épreuve de synthèse** part toujours d''un texte exigeant — extrait littéraire, page d''essai, chronique argumentée — et l''interroge sur **quatre fronts à la fois** : compréhension fine, syntaxe, grammaire, lexique de précision. Réussir, c''est articuler ces quatre lectures sans jamais les séparer du texte.

## 1. D''abord, lire en profondeur (compréhension fine)

Avant toute question de langue, on **comprend l''intention** du texte.

- **Dénoté / connoté** : distinguer ce qui est dit explicitement de ce qui est suggéré (sous-entendu, ironie, présupposé).
- **Inférence** : tirer une conclusion que le texte ne formule pas mais qu''il rend nécessaire (« il était déjà trop tard » → la décision était prise).
- **Tonalité et visée** : repérer si l''auteur informe, persuade, dénonce, émeut — l''oxymore, l''anaphore ou la question rhétorique trahissent souvent une thèse cachée.

**Méthode** : reformuler la thèse de l''auteur en une phrase avant d''aborder le détail. Une compréhension juste oriente toutes les autres réponses.

## 2. Analyser la phrase (syntaxe)

La syntaxe étudie **comment la phrase est construite** et comment ce montage produit du sens.

- **Subordination** : reconnaître la nature de la subordonnée (relative, complétive, circonstancielle) et la fonction qu''elle occupe ; une cause, une concession ou une hypothèse ne pèsent pas du même poids dans l''argument.
- **Ponctuation expressive** : le point-virgule lie deux propositions parallèles ; les deux-points annoncent une explication ou une conséquence ; le tiret isole une rupture ou une chute.
- **Ordre des mots et mise en relief** : l''antéposition, la tournure clivée (« c''est… qui »), l''apposition orientent l''emphase et donc l''interprétation.

**Méthode** : pour chaque phrase complexe, repérer la proposition principale, puis la dépendance et la valeur logique de chaque subordonnée.

## 3. Vérifier la correction (grammaire)

La grammaire contrôle les **accords**, les **modes et temps**, et la **cohérence temporelle**.

- **Accords délicats** : participe passé avec _avoir_ (COD antéposé), participe passé des verbes pronominaux, accords du sujet inversé ou collectif.
- **Modes et temps** : le subjonctif après l''expression du doute, de la volonté, de la concession ; le conditionnel d''hypothèse ou d''information non confirmée ; l''imparfait/passé simple dans le récit.
- **Concordance des temps** : harmoniser le temps de la subordonnée avec celui de la principale (« je croyais qu''il **viendrait** », et non « viendra »).

**Méthode** : remonter au déclencheur (verbe principal, conjonction) pour décider du mode et du temps, plutôt que de se fier à l''oreille.

## 4. Peser chaque mot (lexique de précision)

Le lexique exigeant départage des candidats par des **nuances fines**.

- **Paronymes** : ne pas confondre les mots proches par la forme (_influer / influencer_, _éminent / imminent_, _conjecture / conjoncture_, _collision / collusion_).
- **Registres** : ajuster le mot au ton du texte (soutenu, courant, familier) — un terme familier ruine une analyse soutenue.
- **Sens figuré et connotation** : un même mot change de valeur selon le contexte (_acéré_, _limpide_, _âpre_) ; identifier le sens activé par la phrase.

**Méthode** : remplacer mentalement le mot par chaque distracteur et vérifier la construction (transitivité, préposition) et la cohérence de sens.

## 5. La démarche de synthèse, pas à pas

1. **Lire le texte deux fois** : la première pour le sens global, la seconde crayon en main.
2. **Cartographier la thèse** : une phrase qui résume l''intention de l''auteur.
3. **Traiter chaque question selon son axe**, mais toujours en revenant au texte : la bonne réponse est celle que le texte autorise, pas celle qui « sonne » bien.
4. **Traquer les pièges fins** : paronyme glissé dans un distracteur, fausse régularité d''accord, mode plausible mais non commandé par le déclencheur.
5. **Justifier intérieurement** : pour la clé retenue, savoir dire pourquoi elle est juste **et** pourquoi chaque autre est fausse. C''est le réflexe qui sépare le perfectionnement de l''à-peu-près.', '# Résumé — Annales & épreuves de synthèse

- **Principe** : une épreuve de synthèse part d''un texte exigeant et l''interroge simultanément sur quatre axes — compréhension fine, syntaxe, grammaire, lexique. Toujours revenir au texte : la bonne réponse est celle qu''il autorise.
- **Compréhension fine** : distinguer dénoté et connoté ; inférer ce que le texte rend nécessaire sans le dire ; repérer la tonalité et la visée (oxymore, anaphore, question rhétorique trahissent une thèse).
- **Syntaxe** : identifier la nature et la fonction des subordonnées (relative, complétive, circonstancielle) ; lire la ponctuation expressive (point-virgule, deux-points, tiret) ; repérer la mise en relief (antéposition, tournure clivée « c''est… qui »).
- **Grammaire** : maîtriser les accords délicats (participe passé avec _avoir_ et COD antéposé, verbes pronominaux) ; choisir le mode et le temps d''après le déclencheur (subjonctif après doute/volonté/concession, conditionnel d''hypothèse) ; respecter la concordance des temps.
- **Lexique de précision** : éviter les paronymes (_influer/influencer_, _éminent/imminent_, _conjecture/conjoncture_, _collision/collusion_) ; ajuster le registre au ton du texte ; identifier le sens figuré ou la connotation activée par le contexte.
- **Démarche** : lire deux fois → résumer la thèse en une phrase → traiter chaque question selon son axe → traquer les pièges fins (paronyme caché, fausse régularité, mode plausible mais non commandé) → justifier la clé ET réfuter chaque distracteur.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('54ebcf26-152c-5cc6-9442-9a71e96be049', '2a753d3d-b1b1-5d10-a785-849d04e11ed9', 'fr-mastery', 'Diagnostic — Compréhension', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8680f10f-8d40-577d-b35c-88ecfd6fff8a', '54ebcf26-152c-5cc6-9442-9a71e96be049', 'Un lecteur actif commence par examiner le paratexte d''un texte. Que désigne le terme « paratexte » ?', '[{"id":"a","text":"Le résumé rédigé par le lecteur après sa lecture."},{"id":"b","text":"L''ensemble des éléments périphériques au texte : titre, auteur, source, date."},{"id":"c","text":"Les notes de bas de page uniquement."},{"id":"d","text":"La conclusion du texte, placée en dehors du corps principal."}]'::jsonb, 'b', 'Le paratexte regroupe tous les éléments qui encadrent le texte principal sans en faire partie : titre, auteur, source, date de publication, chapeau introductif, etc. Ces indices orientent la lecture avant même d''aborder le corps du texte. Les notes de bas de page (c) n''en sont qu''un sous-ensemble. Le résumé du lecteur (a) est une production personnelle, pas un élément paratextuel. La conclusion (d) fait partie du texte lui-même.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c943af63-5273-5fc1-af24-e6adde99d287', '54ebcf26-152c-5cc6-9442-9a71e96be049', 'Dans un texte argumentatif, quel est le rôle du connecteur « or » ?', '[{"id":"a","text":"Il introduit une cause expliquant ce qui précède."},{"id":"b","text":"Il marque une addition entre deux arguments de même sens."},{"id":"c","text":"Il introduit un fait nouveau qui nuance ou contredit ce qui précède."},{"id":"d","text":"Il signale une conséquence découlant du raisonnement."}]'::jsonb, 'c', '« Or » est un connecteur logique d''opposition ou de transition : il introduit un élément nouveau, souvent inattendu, qui vient nuancer, compliquer ou contredire ce qui vient d''être affirmé. Il ne marque ni une cause (a) — rôle de « car », « puisque » —, ni une addition (b) — rôle de « de plus », « par ailleurs » —, ni une conséquence (d) — rôle de « donc », « ainsi ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fddf1418-e9ef-5697-81f4-3c6fcd2feaae', '54ebcf26-152c-5cc6-9442-9a71e96be049', 'Lisez cet extrait : « Il a finalement arrêté de tricher. » Quelle information ce fragment présuppose-t-il ?', '[{"id":"a","text":"Il trichait auparavant."},{"id":"b","text":"Il a été pris en flagrant délit de triche."},{"id":"c","text":"Il ne trichera plus jamais à l''avenir."},{"id":"d","text":"Son entourage l''a encouragé à cesser de tricher."}]'::jsonb, 'a', 'Le verbe « arrêter de » présuppose que l''action était en cours : dire qu''il a « arrêté de tricher » implique nécessairement qu''il trichait avant. C''est un présupposé — une information tenue pour acquise par l''énoncé lui-même. En revanche, qu''il ait été pris (b), qu''il ne récidive pas (c) ou que quelqu''un l''y ait incité (d) sont des inférences possibles mais non garanties par le texte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9f6457e-c264-587c-91ef-75cf4ac3341f', '54ebcf26-152c-5cc6-9442-9a71e96be049', 'Un auteur emploie un champ lexical de la maladie pour décrire une ville (« artères bouchées », « fièvre spéculative », « corps social gangrené »). Quelle est la visée principale de ce choix stylistique ?', '[{"id":"a","text":"Informer objectivement le lecteur sur les problèmes urbains."},{"id":"b","text":"Divertir le lecteur avec des images insolites."},{"id":"c","text":"Convaincre le lecteur que la ville est en état de crise grave en suscitant une réaction émotionnelle."},{"id":"d","text":"Expliquer les mécanismes biologiques de la croissance urbaine."}]'::jsonb, 'c', 'L''emploi systématique d''une métaphore filée (ici, la ville-corps malade) est une stratégie rhétorique : elle amplifie la gravité de la situation et cherche à émouvoir et convaincre le lecteur plutôt qu''à l''informer de façon neutre (a). Ce n''est pas du pur divertissement (b) — le choix est idéologiquement orienté. Et il ne s''agit pas d''une explication scientifique (d) : le registre est délibérément figuré, non factuel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4c7d1479-e287-5c31-a3bf-7aad83bb36f5', '2a753d3d-b1b1-5d10-a785-849d04e11ed9', 'fr-mastery', 'Palier 1 — Lecture et repérage', 2, 50, 10, 'practice', 'admin', 1)
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
  ('ed5ee1c1-ba81-57be-9b5a-59a76b8bb1b3', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', 'Lisez ce passage :

« La forêt amazonienne produit environ 20 % de l''oxygène terrestre et abrite plus de la moitié des espèces animales et végétales connues. Sa destruction met donc en péril non seulement la biodiversité mondiale, mais aussi l''équilibre climatique de la planète entière. »

Quelle est l''idée directrice de ce texte ?', '[{"id":"a","text":"La forêt amazonienne est très grande et très ancienne."},{"id":"b","text":"La destruction de la forêt amazonienne menace l''équilibre du monde entier."},{"id":"c","text":"Les espèces animales de l''Amazonie sont les plus variées du globe."},{"id":"d","text":"La production d''oxygène est le seul enjeu de la déforestation."}]'::jsonb, 'b', 'L''idée directrice est la conclusion logique vers laquelle converge tout le passage : après avoir rappelé le rôle vital de l''Amazonie (oxygène, biodiversité), l''auteur en déduit que sa destruction met en péril l''ensemble de la planète. L''option (a) ne figure pas dans le texte. L''option (c) n''est qu''un détail parmi d''autres. L''option (d) déforme le texte, qui mentionne aussi la biodiversité et le climat.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f05cdf1-ffa1-53a6-865c-3e7ef5b9f13f', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', 'Lisez ce passage :

« La forêt amazonienne produit environ 20 % de l''oxygène terrestre et abrite plus de la moitié des espèces animales et végétales connues. Sa destruction met donc en péril non seulement la biodiversité mondiale, mais aussi l''équilibre climatique de la planète entière. »

Quel est le rôle du connecteur « donc » dans ce texte ?', '[{"id":"a","text":"Il introduit une opposition entre deux faits contradictoires."},{"id":"b","text":"Il signale une cause expliquant le fait précédent."},{"id":"c","text":"Il marque la conséquence qui découle des faits énoncés avant lui."},{"id":"d","text":"Il ajoute un exemple supplémentaire à la liste des espèces."}]'::jsonb, 'c', '« Donc » est un connecteur de conséquence : il relie logiquement les données présentées (rôle vital de la forêt) à la conclusion qui s''ensuit (menace globale de sa destruction). Il ne marque pas une opposition (a) — ce serait « cependant » ou « or » —, ni une cause (b) — ce serait « car » ou « puisque » —, ni une addition d''exemples (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0195e47e-5a24-54a0-8d37-efdb074e38e5', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', 'Lisez ce passage :

« Le soleil s''était couché derrière la colline, laissant dans le ciel des traînées cramoisies. Les champs dormaient sous une brume légère, et seul le chant intermittent d''un grillon troublait ce silence épais. »

De quel type de texte s''agit-il ?', '[{"id":"a","text":"Argumentatif : l''auteur défend l''idée que la nature est belle."},{"id":"b","text":"Explicatif : le texte explique le phénomène du coucher de soleil."},{"id":"c","text":"Narratif : le texte raconte une suite d''événements avec des personnages."},{"id":"d","text":"Descriptif : le texte peint un tableau sensoriel d''un paysage au crépuscule."}]'::jsonb, 'd', 'Ce passage convoque des images visuelles (traînées cramoisies, brume légère) et auditives (chant du grillon, silence) pour brosser un tableau immobile du paysage : c''est un texte descriptif. Il ne défend aucune thèse (a), n''explique aucun phénomène scientifique (b), et ne raconte pas d''actions enchaînées avec des personnages agissants (c) — le décor est inerte, figé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edaae71f-2a0f-56b0-9de8-7af983a5f97a', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', 'Lisez ce court texte :

« Chaque matin, Élise parcourait les mêmes rues désertes, saluait le même boulanger sourd, déposait le même journal sur le même paillasson. Elle avait cessé depuis longtemps d''espérer que quelque chose change. »

Quel sentiment l''auteur cherche-t-il à communiquer au sujet d''Élise ?', '[{"id":"a","text":"La joie tranquille d''une vie bien ordonnée."},{"id":"b","text":"L''anxiété face à un avenir incertain."},{"id":"c","text":"La résignation à une existence monotone et sans espoir."},{"id":"d","text":"L''admiration pour la constance d''une routinière accomplie."}]'::jsonb, 'c', 'La répétition insistante de « même » (cinq occurrences) et la phrase conclusive « avait cessé d''espérer que quelque chose change » expriment sans équivoque la résignation face à une vie figée. Rien dans le texte ne suggère la joie (a), l''anxiété face à l''incertitude (b) — au contraire, tout est prévisible —, ni l''admiration (d), ton que l''auteur n''adopte pas ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c99f2101-7624-5966-b58e-bfc8fa12baec', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', 'Lisez ce passage :

« Les réseaux sociaux ne sont pas, en eux-mêmes, dangereux. C''est l''usage qu''on en fait qui détermine leur impact. Un outil de communication peut devenir un espace d''épanouissement ou un vecteur d''isolement selon les pratiques de chacun. »

Quelle est la thèse défendue par l''auteur ?', '[{"id":"a","text":"Les réseaux sociaux sont fondamentalement nocifs pour la société."},{"id":"b","text":"Les réseaux sociaux devraient être interdits aux mineurs."},{"id":"c","text":"L''impact des réseaux sociaux dépend de la manière dont chacun les utilise."},{"id":"d","text":"Les réseaux sociaux sont les meilleurs outils de communication modernes."}]'::jsonb, 'c', 'La thèse est énoncée explicitement dès la deuxième phrase : « C''est l''usage qu''on en fait qui détermine leur impact. » L''auteur refuse de porter un jugement absolu (ni (a) — dangereux par nature — ni (d) — meilleurs par nature). L''interdiction aux mineurs (b) n''est pas évoquée. La thèse nuancée repose sur la responsabilité individuelle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ceacbb2-b92d-5d73-aa5d-98cfa7409985', '4c7d1479-e287-5c31-a3bf-7aad83bb36f5', 'Lisez cet extrait :

« Malgré des décennies de campagnes de sensibilisation, la consommation de tabac reste élevée chez les jeunes adultes. »

Quel mot ou groupe de mots indique le mieux que l''auteur exprime une tension entre deux réalités opposées ?', '[{"id":"a","text":"« des décennies »"},{"id":"b","text":"« reste élevée »"},{"id":"c","text":"« Malgré »"},{"id":"d","text":"« jeunes adultes »"}]'::jsonb, 'c', '« Malgré » est un connecteur d''opposition (ou de concession) : il signale que le résultat observé (consommation élevée) va à l''encontre de ce que les campagnes de sensibilisation auraient dû produire. C''est lui qui crée la tension entre effort fourni et résultat décevant. Les autres éléments — « des décennies » (durée), « reste élevée » (constat), « jeunes adultes » (public ciblé) — sont informatifs mais ne portent pas ce rapport d''opposition.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('285d4a2f-f961-5728-9f15-7468924a29aa', '2a753d3d-b1b1-5d10-a785-849d04e11ed9', 'fr-mastery', 'Palier 2 — Inférence et implicite', 3, 80, 15, 'practice', 'admin', 2)
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
  ('d1eae56a-a4bf-58b9-9ea7-713473f2640a', '285d4a2f-f961-5728-9f15-7468924a29aa', 'Lisez ce passage :

« Depuis que le laboratoire a publié ses résultats, le silence des autorités sanitaires est assourdissant. Aucun communiqué, aucune conférence de presse, aucune réponse aux journalistes. On se demande ce que ce mutisme protège. »

Que sous-entend la dernière phrase de ce texte ?', '[{"id":"a","text":"Les autorités sanitaires ignorent l''existence de ces résultats."},{"id":"b","text":"Le silence des autorités dissimule peut-être des informations compromettantes."},{"id":"c","text":"Les journalistes ont choisi de ne pas publier leurs questions."},{"id":"d","text":"Le laboratoire a demandé aux autorités de ne pas commenter l''étude."}]'::jsonb, 'b', 'La formulation rhétorique « On se demande ce que ce mutisme protège » est un sous-entendu : l''auteur n''affirme pas directement que les autorités cachent quelque chose, mais il le laisse entendre en utilisant le verbe « protège », qui implique qu''il y a quelque chose à dissimuler. L''option (a) est contredite par le fait que des journalistes ont posé des questions. Les options (c) et (d) introduisent des acteurs et des faits absents du texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67de4e18-6eaa-5c85-9054-25ed7a08ab43', '285d4a2f-f961-5728-9f15-7468924a29aa', 'Lisez ce passage :

« Depuis que le laboratoire a publié ses résultats, le silence des autorités sanitaires est assourdissant. Aucun communiqué, aucune conférence de presse, aucune réponse aux journalistes. On se demande ce que ce mutisme protège. »

Quel est le ton dominant de cet extrait ?', '[{"id":"a","text":"Admiratif : l''auteur salue la discrétion des autorités."},{"id":"b","text":"Neutre et factuel : l''auteur se contente de rapporter des faits."},{"id":"c","text":"Polémique et suspicieux : l''auteur met en cause l''attitude des autorités."},{"id":"d","text":"Didactique : l''auteur explique le fonctionnement des institutions sanitaires."}]'::jsonb, 'c', 'L''oxymore « silence assourdissant », l''anaphore en « aucun… aucune… aucune » et la question rhétorique finale révèlent un ton délibérément critique et suspicieux. Loin d''être neutre (b), le texte prend clairement position contre le comportement des autorités. Il n''y a ni admiration (a) ni explication pédagogique (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cd4d96d-aa2f-58b3-bcf2-69b54a040ef5', '285d4a2f-f961-5728-9f15-7468924a29aa', 'Lisez ce texte :

« Nadia avait pourtant tout préparé : les dossiers, les chiffres, les arguments. Elle entra dans la salle de réunion, vit les visages fermés autour de la table, et comprit qu''il était déjà trop tard. »

Quelle information le texte laisse-t-il inférer ?', '[{"id":"a","text":"Nadia a oublié ses dossiers avant la réunion."},{"id":"b","text":"La décision avait été prise avant même que Nadia ne prenne la parole."},{"id":"c","text":"Les participants à la réunion ne connaissaient pas Nadia."},{"id":"d","text":"Nadia a choisi de ne pas présenter ses arguments."}]'::jsonb, 'b', 'L''expression « il était déjà trop tard » et les « visages fermés » permettent d''inférer que l''issue était scellée avant l''intervention de Nadia — la réunion n''était qu''une formalité. Le texte dit explicitement qu''elle avait tout préparé, donc (a) et (d) sont faux. Rien ne dit que les participants ne la connaissaient pas (c) : les visages fermés indiquent une décision prise, pas une méconnaissance.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb0f01e1-ed4d-55ee-99b2-35afd2948326', '285d4a2f-f961-5728-9f15-7468924a29aa', 'Lisez ce passage :

« L''art contemporain fascine autant qu''il déroute. Certains y voient une révolution du regard ; d''autres, un vaste canular institutionnalisé. La vérité est peut-être que les deux camps ont raison : l''art a toujours provoqué, et c''est précisément ce trouble qui atteste sa vitalité. »

Quelle reformulation est la plus fidèle à la position de l''auteur ?', '[{"id":"a","text":"L''art contemporain est incompréhensible et ne mérite pas d''être défendu."},{"id":"b","text":"L''art contemporain n''est qu''un canular, mais certains y croient sincèrement."},{"id":"c","text":"Le débat autour de l''art contemporain est lui-même la preuve de la puissance de l''art."},{"id":"d","text":"L''art contemporain plaît à tous ceux qui comprennent vraiment l''art."}]'::jsonb, 'c', 'L''auteur ne tranche pas entre les deux camps mais synthétise en affirmant que la provocation et le trouble sont constitutifs de l''art vivant : « c''est précisément ce trouble qui atteste sa vitalité. » L''option (c) restitue fidèlement cette idée. L''option (a) impose un jugement négatif que l''auteur refuse. L''option (b) valide unilatéralement le camp du canular. L''option (d) invente une distinction entre « vrais » et « faux » connaisseurs, absente du texte.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('543014f2-55ac-563c-b3d3-b44234606183', '285d4a2f-f961-5728-9f15-7468924a29aa', 'Lisez ce passage :

« En vingt ans, le prix du mètre carré dans cette ville a été multiplié par quatre. Les familles modestes ont migré vers la périphérie. Les commerces de proximité ont fermé, remplacés par des boutiques de luxe. Le quartier a changé de visage — et de population. »

Quel phénomène urbain ce texte décrit-il implicitement sans jamais le nommer ?', '[{"id":"a","text":"La désindustrialisation d''un quartier ouvrier."},{"id":"b","text":"La gentrification — embourgeoisement d''un quartier populaire."},{"id":"c","text":"L''exode rural vers les grandes métropoles."},{"id":"d","text":"La suburbanisation liée à la construction de nouvelles routes."}]'::jsonb, 'b', 'Tous les indices convergent vers la gentrification : hausse des prix de l''immobilier, départ des populations à faibles revenus, fermeture des commerces populaires et installation de boutiques de luxe, changement de population. Ce phénomène n''est jamais nommé dans le texte — il faut l''inférer. La désindustrialisation (a) implique une activité industrielle qui n''est pas mentionnée. L''exode rural (c) concerne le déplacement des campagnes vers les villes. La suburbanisation (d) porte sur l''étalement urbain lié aux transports.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d30546c-fbb5-5240-9020-167990160ec1', '285d4a2f-f961-5728-9f15-7468924a29aa', 'Lisez cet extrait :

« Il se disait philosophe, mais ne supportait aucune contradiction. Il prônait la tolérance dans ses livres et coupait court aux discussions dès que ses idées étaient remises en question. Ses disciples ne manquaient jamais de le citer ; ses pairs ne le citaient presque jamais. »

Quel procédé stylistique structure cet extrait et quel effet produit-il ?', '[{"id":"a","text":"La métaphore filée : elle rend la description plus poétique."},{"id":"b","text":"L''antithèse répétée : elle souligne les contradictions entre le discours et les actes du personnage."},{"id":"c","text":"La gradation ascendante : elle amplifie progressivement les qualités du philosophe."},{"id":"d","text":"Le discours indirect libre : il restitue les pensées intimes du personnage."}]'::jsonb, 'b', 'Le texte est construit sur une série d''antithèses (se disait philosophe / ne supportait aucune contradiction ; prônait la tolérance / coupait court aux discussions ; disciples le citaient / pairs ne le citaient pas) qui mettent en évidence l''écart entre le discours public du personnage et son comportement réel. Cet effet ironique démystifie le prétendu philosophe. Il n''y a pas de métaphore filée (a), pas de gradation vers le positif (c) — au contraire —, et le texte est à la troisième personne distancée, non en discours indirect libre (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('741c45aa-05e1-5ccc-9531-1f7fdb02fffa', '2a753d3d-b1b1-5d10-a785-849d04e11ed9', 'fr-mastery', 'Palier 3 — Analyse et maîtrise (mode boss)', 4, 120, 25, 'boss', 'admin', 3)
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
  ('305156d8-219f-5eee-a20b-b902ce441b97', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'Lisez ce passage :

« La mémoire n''est pas un enregistrement fidèle du passé : elle est une reconstruction permanente, façonnée par nos émotions du moment, nos convictions actuelles et les récits que nous nous sommes racontés depuis. Nous ne nous souvenons pas de ce qui s''est passé ; nous nous souvenons de la dernière fois où nous y avons pensé. »

Quelle est l''idée centrale que développe ce texte ?', '[{"id":"a","text":"La mémoire humaine est biologiquement inférieure à celle des machines."},{"id":"b","text":"Les souvenirs sont des fictions que nous élaborons et réélaborons en fonction de notre présent."},{"id":"c","text":"Il est impossible de se souvenir de quoi que ce soit avec précision après plusieurs années."},{"id":"d","text":"Les émotions fortes permettent de fixer des souvenirs immuables et fiables."}]'::jsonb, 'b', 'Le texte pose que la mémoire est une « reconstruction permanente » influencée par le présent (émotions du moment, convictions actuelles) — autrement dit, un souvenir est toujours une réinterprétation, jamais une photographie neutre du passé. L''option (b) le formule fidèlement. L''option (a) introduit une comparaison avec les machines absente du texte. L''option (c) radicalise à l''excès : le texte parle de reconstruction, non d''impossibilité totale de se souvenir. L''option (d) contredit directement la thèse : les émotions du moment déforment le souvenir, elles ne le fixent pas de façon immuable.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74dd8103-2347-5068-9316-b65cc95f48f6', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'Lisez ce passage :

« La mémoire n''est pas un enregistrement fidèle du passé : elle est une reconstruction permanente, façonnée par nos émotions du moment, nos convictions actuelles et les récits que nous nous sommes racontés depuis. Nous ne nous souvenons pas de ce qui s''est passé ; nous nous souvenons de la dernière fois où nous y avons pensé. »

Quelle est la fonction des deux-points ( : ) après « passé » dans la première phrase ?', '[{"id":"a","text":"Ils introduisent une énumération des types de mémoire existants."},{"id":"b","text":"Ils annoncent une explication qui développe et justifie l''affirmation précédente."},{"id":"c","text":"Ils marquent une opposition entre deux thèses contradictoires."},{"id":"d","text":"Ils signalent une citation empruntée à un autre auteur."}]'::jsonb, 'b', 'Les deux-points ont ici une valeur explicative : après avoir posé que la mémoire n''est pas un enregistrement fidèle, l''auteur explicite immédiatement ce qu''elle est à la place (une reconstruction permanente façonnée par…). C''est leur emploi le plus courant en français argumentatif : reformuler ou préciser l''énoncé qui précède. Ils n''introduisent pas une liste de types de mémoire (a), ne marquent pas une opposition (c) — ce serait un connecteur adversatif —, et aucune citation extérieure n''est indiquée (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('050d08b6-399e-59f6-b9fe-019502d9bdf0', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'Lisez ce texte :

« On nous dit que la mondialisation a enrichi les nations. Certes, les échanges commerciaux ont explosé. Mais cet enrichissement collectif masque des inégalités vertigineuses : les gains se sont concentrés au sommet, tandis que des pans entiers des classes moyennes ont vu leur pouvoir d''achat stagner, voire reculer. Parler d''enrichissement sans parler de distribution, c''est raconter la moitié d''une histoire. »

Quelle est la stratégie argumentative de l''auteur dans ce passage ?', '[{"id":"a","text":"Il réfute totalement la thèse adverse avant de proposer sa propre théorie économique."},{"id":"b","text":"Il concède une part de vérité à la thèse adverse, puis la nuance en montrant ce qu''elle occulte."},{"id":"c","text":"Il accumule des données statistiques pour prouver que la mondialisation est un échec total."},{"id":"d","text":"Il adopte un ton neutre pour laisser le lecteur former sa propre opinion sans l''influencer."}]'::jsonb, 'b', 'La structure du raisonnement est celle de la concession-réfutation : l''auteur accorde d''abord (« Certes, les échanges commerciaux ont explosé ») avant de retourner l''argument avec « Mais » pour montrer ce que la thèse initiale cache (concentration des gains, stagnation des classes moyennes). Ce n''est pas une réfutation totale (a) — il admet que les échanges ont bien augmenté. Il n''y a pas de données chiffrées (c). Et le ton est clairement engagé, pas neutre (d) : la métaphore « raconter la moitié d''une histoire » révèle une prise de position.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89951cf7-dd8a-594b-9403-54a1641084b4', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'Lisez ce passage :

« Longtemps, on a cru que l''intelligence était une capacité fixe, mesurable et héréditaire. Les travaux de Carol Dweck sur le « growth mindset » ont ébranlé ce consensus : la conviction qu''on peut progresser modifie non seulement les comportements d''apprentissage, mais aussi, selon certaines études, les performances effectives. L''intelligence serait ainsi moins un capital reçu qu''un muscle à exercer. »

Quel est le sens de l''expression « un capital reçu » dans ce contexte ?', '[{"id":"a","text":"Une richesse financière transmise par l''héritage familial."},{"id":"b","text":"Une aptitude innée et immuable, donnée à la naissance et non modifiable."},{"id":"c","text":"Un ensemble de connaissances acquises à l''école primaire."},{"id":"d","text":"Un niveau d''intelligence que l''on reçoit en récompense de ses efforts."}]'::jsonb, 'b', 'Dans ce contexte, « capital reçu » joue sur la métaphore du patrimoine : l''intelligence serait une dotation initiale, fixe et héritée (allusion à la conception traditionnelle de l''intelligence comme capacité innée et mesurable évoquée en début de passage). L''opposition avec « un muscle à exercer » — qui implique l''effort et la progression — confirme que « capital reçu » désigne quelque chose d''immobile, obtenu sans travail, non une fortune familiale au sens littéral (a), ni des connaissances scolaires (c), ni une récompense (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c08ae3cd-f963-52cf-84b6-beafaeca7e0e', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'Lisez ce texte :

« La ville était belle d''une beauté froide et calculée — vitrines aseptisées, façades rénovées, trottoirs sans aspérité. Tout y était propre. Trop propre. Les sans-abri avaient disparu des artères principales, non parce qu''ils avaient trouvé un toit, mais parce qu''on les avait poussés hors du champ de vision des touristes. »

Quelle est la visée principale de cet extrait ?', '[{"id":"a","text":"Vanter les mérites de la rénovation urbaine au service du tourisme."},{"id":"b","text":"Dénoncer une politique d''embellissement qui dissimule l''exclusion sociale au lieu de la résoudre."},{"id":"c","text":"Expliquer objectivement les mécanismes économiques de la gentrification."},{"id":"d","text":"Informer le lecteur des statistiques sur le sans-abrisme dans les grandes villes."}]'::jsonb, 'b', 'La visée est clairement dénonciatrice. La progression du texte construit un contraste entre l''apparence (belle, propre) et la réalité cachée (exclusion des sans-abri). Les guillemets implicites de « trop propre » et l''opposition entre « avaient trouvé un toit » et « poussés hors du champ de vision » révèlent l''indignation de l''auteur face à une politique de façade. Rien dans le texte ne vante la rénovation (a) ; le ton engagé exclut l''objectivité (c) ; aucune statistique n''est fournie (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2bc1d53-6f4e-51ee-bb0b-bf5b177253f9', '741c45aa-05e1-5ccc-9531-1f7fdb02fffa', 'Lisez ces deux phrases extraites d''un même texte :

« (1) Les études montrent que la lecture régulière développe l''empathie et enrichit le vocabulaire. (2) Pourtant, dans un monde saturé d''écrans, convaincre les jeunes de lire reste un défi considérable. »

Quelle relation logique le connecteur « pourtant » établit-il entre les deux phrases ?', '[{"id":"a","text":"Il indique que la phrase (2) est une conséquence directe et attendue de la phrase (1)."},{"id":"b","text":"Il signale que la phrase (2) illustre par un exemple ce qu''affirme la phrase (1)."},{"id":"c","text":"Il introduit une concession : malgré les bénéfices prouvés de la lecture (1), sa pratique se heurte à des obstacles réels (2)."},{"id":"d","text":"Il marque une reformulation : la phrase (2) répète la même idée que (1) avec d''autres mots."}]'::jsonb, 'c', '« Pourtant » est un connecteur d''opposition/concession : il signale que la réalité exposée en (2) — difficulté à convaincre les jeunes de lire — contraste avec ce que l''on pourrait attendre au vu de (1) — les bénéfices prouvés de la lecture. Si les avantages sont si évidents, on devrait s''attendre à un engouement spontané ; or c''est l''inverse. Ce n''est pas une conséquence (a) — ce serait « donc » ou « ainsi » —, ni un exemple (b) — ce serait « par exemple » ou « c''est le cas de » —, ni une reformulation (d) — les deux phrases expriment des idées distinctes et opposées.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b566b02c-fbad-5f84-8ddc-ebf03091d01a', '3d2a602e-0a87-5334-b9b0-cd5dfacc5a4b', 'fr-mastery', 'Diagnostic — Syntaxe', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('a89112a7-94e9-5e91-b04a-50edc4c953dc', 'b566b02c-fbad-5f84-8ddc-ebf03091d01a', 'Dans la phrase « La précision du raisonnement s''impose à tous », quelle est la fonction du groupe nominal « La précision du raisonnement » ?', '[{"id":"a","text":"Complément d''objet direct"},{"id":"b","text":"Sujet du verbe « s''impose »"},{"id":"c","text":"Attribut du sujet"},{"id":"d","text":"Complément circonstanciel de manière"}]'::jsonb, 'b', 'Pour identifier le sujet, on pose la question « Qui est-ce qui s''impose à tous ? » → « La précision du raisonnement » : c''est bien le sujet, qui commande l''accord du verbe à la 3e personne du singulier.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b1c03fb-9575-51c4-bc11-850d12c955bf', 'b566b02c-fbad-5f84-8ddc-ebf03091d01a', 'Dans « Il plaida avec conviction ; le jury l''acquitta », quel procédé relie les deux propositions ?', '[{"id":"a","text":"La subordination"},{"id":"b","text":"La coordination par « donc »"},{"id":"c","text":"La juxtaposition"},{"id":"d","text":"La subordination circonstancielle de conséquence"}]'::jsonb, 'c', 'Les deux propositions sont simplement séparées par un point-virgule, sans mot de liaison : c''est la juxtaposition. Le rapport logique (ici, la conséquence) reste implicite et doit être inféré par le lecteur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a14d463f-5a21-5d0d-b187-2efa8905c8fd', 'b566b02c-fbad-5f84-8ddc-ebf03091d01a', 'Laquelle de ces phrases illustre une mise en relief par le présentatif ?', '[{"id":"a","text":"Il défend ses idées avec vigueur."},{"id":"b","text":"Ses idées, il les défend avec vigueur."},{"id":"c","text":"C''est avec vigueur qu''il défend ses idées."},{"id":"d","text":"Avec vigueur, il défend ses idées."}]'::jsonb, 'c', 'La construction « c''est… que » est le présentatif : elle focalise l''élément encadré (ici le complément de manière « avec vigueur »). La phrase (b) illustre la thématisation (dislocation), et (d) l''antéposition d''un CC.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70b59c54-c7b6-58aa-81ee-c3e6523f65b0', 'b566b02c-fbad-5f84-8ddc-ebf03091d01a', 'Dans « On juge cet argument irrecevable », quelle est la fonction de l''adjectif « irrecevable » ?', '[{"id":"a","text":"Épithète du nom « argument »"},{"id":"b","text":"Attribut du sujet « on »"},{"id":"c","text":"Attribut du COD « cet argument »"},{"id":"d","text":"Complément du nom « argument »"}]'::jsonb, 'c', 'Le verbe « juger » est ici un verbe attributif transitif : il relie le COD (« cet argument ») à son attribut (« irrecevable »). On peut paraphraser : « On considère que cet argument est irrecevable. » Ce n''est pas une épithète car il n''est pas directement accolé au nom sans verbe intermédiaire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7ee9e74e-1bd3-509c-a965-5d61a375acbc', '3d2a602e-0a87-5334-b9b0-cd5dfacc5a4b', 'fr-mastery', 'Palier 1 — Identification des fonctions syntaxiques', 2, 50, 10, 'practice', 'admin', 1)
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
  ('026f14b3-d80a-50ef-b862-7c312b3a8d99', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', 'Dans « Elle renonce à ses certitudes », quelle est la fonction du groupe « à ses certitudes » ?', '[{"id":"a","text":"Complément d''objet direct (COD)"},{"id":"b","text":"Complément d''objet indirect (COI)"},{"id":"c","text":"Complément circonstanciel de cause"},{"id":"d","text":"Attribut du sujet"}]'::jsonb, 'b', 'Le verbe « renoncer » se construit avec la préposition « à » : on pose la question « renoncer à quoi ? » → « à ses certitudes ». Comme la préposition est obligatoire, il s''agit d''un COI, et non d''un COD (lequel est sans préposition).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e34a5753-21d5-58d7-86d0-65e3186e4981', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', 'Dans « Ce texte est remarquable », quelle est la fonction de l''adjectif « remarquable » ?', '[{"id":"a","text":"Épithète du nom « texte »"},{"id":"b","text":"Complément du nom"},{"id":"c","text":"Attribut du sujet"},{"id":"d","text":"Complément d''objet direct"}]'::jsonb, 'c', 'Le verbe « être » est un verbe d''état ; l''adjectif qui le suit et qualifie le sujet est un **attribut du sujet**. Une épithète serait directement accolée au nom (« un texte remarquable »), sans verbe intermédiaire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2d40a55-1980-57c0-9b15-a2a22f0ce69d', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', 'Quel groupe est complément du nom dans « La rigueur du raisonnement s''impose » ?', '[{"id":"a","text":"« La rigueur »"},{"id":"b","text":"« du raisonnement »"},{"id":"c","text":"« s''impose »"},{"id":"d","text":"« La rigueur du raisonnement »"}]'::jsonb, 'b', 'Le groupe prépositionnel « du raisonnement » précise le nom « rigueur » en indiquant ce dont il s''agit. Introduit par la préposition « de », il remplit la fonction de complément du nom.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9c2cca1-7844-5d5c-8eda-7bb309b2c1ef', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', 'Dans « À l''aube, le débat reprit », quelle est la fonction du groupe « À l''aube » ?', '[{"id":"a","text":"Sujet"},{"id":"b","text":"Attribut du sujet"},{"id":"c","text":"Complément circonstanciel de temps"},{"id":"d","text":"COI du verbe « reprendre »"}]'::jsonb, 'c', 'Le groupe « À l''aube » indique le moment où se déroule l''action ; il est déplaçable (on peut le placer en fin de phrase) et supprimable sans rendre la phrase agrammaticale : c''est un complément circonstanciel de temps.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f445d68b-2223-5682-8116-078a7a28f03b', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', 'Laquelle de ces phrases contient une épithète ?', '[{"id":"a","text":"Cet argument paraît solide."},{"id":"b","text":"On considère cet argument solide."},{"id":"c","text":"Un argument solide convainc toujours."},{"id":"d","text":"Cet argument l''est."}]'::jsonb, 'c', 'Dans « un argument solide », l''adjectif « solide » est directement rattaché au nom « argument » sans verbe intermédiaire : c''est une épithète. Dans (a), « solide » est attribut du sujet via « paraît » ; dans (b), attribut du COD via « considère ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('660243d7-9d26-5171-a25a-06fa13b891da', '7ee9e74e-1bd3-509c-a965-5d61a375acbc', 'Quelle question permet d''identifier le COD d''un verbe ?', '[{"id":"a","text":"« Verbe + à qui / à quoi ? »"},{"id":"b","text":"« Verbe + de qui / de quoi ? »"},{"id":"c","text":"« Qui est-ce qui ? / Qu''est-ce qui ? »"},{"id":"d","text":"« Verbe + qui / quoi ? » (sans préposition)"}]'::jsonb, 'd', 'Le COD se trouve en posant « verbe + qui ? » ou « verbe + quoi ? » sans aucune préposition. La question « à qui / à quoi ? » identifie le COI introduit par « à » ; « qui est-ce qui ? » identifie le sujet.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('25b15911-6bf2-5f29-8228-13c586098442', '3d2a602e-0a87-5334-b9b0-cd5dfacc5a4b', 'fr-mastery', 'Palier 2 — Structure de la phrase et liaisons entre propositions', 3, 80, 15, 'practice', 'admin', 2)
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
  ('f72f5bd1-c49e-5252-8756-125c05759ab5', '25b15911-6bf2-5f29-8228-13c586098442', 'Quel procédé syntaxique relie les deux propositions dans « L''orateur développa ses thèses ; le public resta sceptique » ?', '[{"id":"a","text":"La subordination circonstancielle de conséquence"},{"id":"b","text":"La coordination par la conjonction « mais »"},{"id":"c","text":"La juxtaposition par le point-virgule"},{"id":"d","text":"La subordination relative"}]'::jsonb, 'c', 'Le point-virgule sépare deux propositions indépendantes sans mot de liaison : c''est la juxtaposition. Le lien logique (ici, une opposition implicite) doit être inféré par le lecteur. La coordination exigerait une conjonction explicite (« mais », « donc »…) ; la subordination, un subordonnant.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('025e5ee8-c412-52f1-97a1-919f13436b34', '25b15911-6bf2-5f29-8228-13c586098442', 'Laquelle de ces phrases illustre une subordination et non une coordination ?', '[{"id":"a","text":"Il avait raison, mais personne ne l''écoutait."},{"id":"b","text":"Elle parla longuement, car elle souhaitait convaincre."},{"id":"c","text":"Il argumenta si bien que l''assemblée changea d''avis."},{"id":"d","text":"Le débat fut houleux, or les conclusions s''imposèrent."}]'::jsonb, 'c', 'Dans la phrase (c), « si bien que » est une locution conjonctive de subordination : la seconde proposition dépend syntaxiquement de la première et ne peut pas se lire seule. Les phrases (a), (b) et (d) utilisent des conjonctions de coordination (« mais », « car », « or ») qui relient deux propositions indépendantes.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('375d49fc-7cd3-5d29-8542-e8eea2807342', '25b15911-6bf2-5f29-8228-13c586098442', 'Dans « C''est la rigueur syntaxique qui distingue un bon scripteur », quel élément est mis en relief ?', '[{"id":"a","text":"Le verbe « distingue »"},{"id":"b","text":"Le COD « un bon scripteur »"},{"id":"c","text":"Le sujet « la rigueur syntaxique »"},{"id":"d","text":"Le complément circonstanciel sous-entendu"}]'::jsonb, 'c', 'La construction présentative « c''est… qui » isole et focalise le groupe nominal placé entre « c''est » et « qui » : ici, « la rigueur syntaxique » est le sujet mis en relief. Pour mettre en relief un COD ou un CC, on utilise « c''est… que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dec2df78-f75b-55e7-ab6c-c0781f1325ea', '25b15911-6bf2-5f29-8228-13c586098442', 'Quelle phrase présente une thématisation (dislocation) correctement formée ?', '[{"id":"a","text":"La précision lexicale est essentielle pour lui."},{"id":"b","text":"La précision lexicale, il y tenait par-dessus tout."},{"id":"c","text":"C''est la précision lexicale qu''il tenait par-dessus tout."},{"id":"d","text":"Il tenait à la précision lexicale par-dessus tout."}]'::jsonb, 'b', 'La thématisation (ou dislocation) consiste à détacher un groupe en tête de phrase et à le reprendre par un pronom anaphorique dans la proposition : « La précision lexicale, il y tenait » (reprise par « y »). La phrase (c) est un présentatif, non une dislocation. Les phrases (a) et (d) sont des constructions canoniques sans mise en relief.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('354fa3dd-041c-5e2b-a6bc-3a7ff1a63d01', '25b15911-6bf2-5f29-8228-13c586098442', 'Laquelle de ces phrases contient une faute de construction syntaxique ?', '[{"id":"a","text":"Bien qu''il soit fatigué, il poursuit son analyse."},{"id":"b","text":"Il est fatigué, mais il poursuit son analyse."},{"id":"c","text":"Étant fatigué, mais il poursuit cependant son analyse."},{"id":"d","text":"Malgré sa fatigue, il poursuit son analyse."}]'::jsonb, 'c', 'La phrase (c) mélange deux constructions incompatibles : le participe présent « étant fatigué » (construction participiale absolue) et la conjonction de coordination « mais », qui ne peut pas s''articuler avec un participe pour former une proposition. Les phrases (a), (b) et (d) sont syntaxiquement irréprochables.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61ce2200-1a09-5c0b-bad7-4fbdfa7c99b5', '25b15911-6bf2-5f29-8228-13c586098442', 'Dans « Dans ce contexte précis, l''auteur adopte un ton polémique », quel effet produit l''antéposition du complément circonstanciel ?', '[{"id":"a","text":"Elle supprime toute ambiguïté sur le sujet de la phrase."},{"id":"b","text":"Elle met en relief la circonstance et crée un cadre interprétatif avant l''assertion principale."},{"id":"c","text":"Elle transforme le complément en sujet grammatical."},{"id":"d","text":"Elle impose un mode subjonctif au verbe principal."}]'::jsonb, 'b', 'Placer un complément circonstanciel en tête de phrase (avant le sujet et le verbe) en fait un « cadre » : le lecteur interprète l''assertion principale à la lumière de cette circonstance posée d''emblée. Ce procédé est fréquent dans l''argumentation et les textes analytiques pour contextualiser une affirmation.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3bc1a97f-6e89-5006-aed2-f13c83a892b3', '3d2a602e-0a87-5334-b9b0-cd5dfacc5a4b', 'fr-mastery', 'Palier 3 — Maîtrise avancée : restructuration, correction et analyse complexe', 4, 120, 25, 'boss', 'admin', 3)
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
  ('59f990a9-883c-5147-b3c7-67c35168c1db', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', 'Quel mot ou groupe de mots complète correctement la phrase « Il parla avec tant de clarté ___ l''auditoire fut immédiatement conquis » ?', '[{"id":"a","text":"bien que"},{"id":"b","text":"quoique"},{"id":"c","text":"que"},{"id":"d","text":"si bien que"}]'::jsonb, 'c', 'La structure corrélative de conséquence est « tant de + nom + que » : « avec tant de clarté que l''auditoire fut conquis ». La conséquence est ici intégrée à la corrélation et n''a pas besoin de « si bien que » (qui s''emploie sans corrélatif antécédent). « Bien que » et « quoique » introduisent une concession au subjonctif, ce qui est sémantiquement incompatible avec le contexte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1768e1e-f0fa-5797-9180-d1d844ba24a2', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', 'Choisissez la phrase qui restructure correctement « On lui a remis le prix » en mettant « le prix » en relief par le présentatif.', '[{"id":"a","text":"Le prix, on le lui a remis."},{"id":"b","text":"C''est le prix qu''on lui a remis."},{"id":"c","text":"C''est le prix qui lui a été remis par on."},{"id":"d","text":"C''est lui qu''on a remis le prix."}]'::jsonb, 'b', 'Pour mettre en relief un COD par le présentatif, on utilise « c''est… que » : « C''est le prix qu''on lui a remis. » La phrase (a) est une thématisation (dislocation avec reprise pronominale « le »), non un présentatif. La phrase (c) est maladroite (le complément d''agent « par on » est agrammatical). La phrase (d) est fautive car elle omet la reprise pronominale obligatoire après le COD disloqué.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b412957-d2ab-51c9-9647-8e7fc9085277', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', 'Laquelle de ces phrases contient une rupture de construction (anacolouthe) fautive ?', '[{"id":"a","text":"Ayant relu son argumentation, il en corrigea les incohérences."},{"id":"b","text":"Ayant relu son argumentation, les incohérences furent corrigées."},{"id":"c","text":"Après avoir relu son argumentation, il en corrigea les incohérences."},{"id":"d","text":"Il relut son argumentation et en corrigea les incohérences."}]'::jsonb, 'b', 'La phrase (b) présente un participe passé composé détaché (« Ayant relu ») dont le sujet implicite doit être le même que celui de la proposition principale. Or le sujet de « furent corrigées » est « les incohérences », qui ne peut pas avoir relu quoi que ce soit : c''est un participe mal rattaché (anacolouthe). Les phrases (a), (c) et (d) maintiennent une cohérence syntaxique parfaite.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e1ad5a9-e292-54c2-a1e2-34c4542cb757', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', 'Dans la phrase « Que cette hypothèse soit réfutée ne surprend pas les spécialistes », quelle est la fonction de la proposition « Que cette hypothèse soit réfutée » ?', '[{"id":"a","text":"Complément circonstanciel de cause"},{"id":"b","text":"Complément d''objet direct du verbe « surprend »"},{"id":"c","text":"Sujet du verbe « surprend »"},{"id":"d","text":"Attribut du sujet « les spécialistes »"}]'::jsonb, 'c', 'Une proposition subordonnée conjonctive introduite par « que » peut occuper la fonction de sujet : on pose la question « Qu''est-ce qui ne surprend pas les spécialistes ? » → « Que cette hypothèse soit réfutée ». Il s''agit d''une subordonnée sujet au subjonctif, symétrique à un sujet nominal comme « Cette réfutation ne surprend pas les spécialistes. »', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1022efe2-107a-5610-879e-0bf25fa22f2c', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', 'Choisissez la version qui corrige la faute de construction présente dans « *Il s''intéresse et admire la syntaxe » :', '[{"id":"a","text":"Il s''intéresse à et admire la syntaxe."},{"id":"b","text":"Il s''intéresse à la syntaxe et l''admire."},{"id":"c","text":"Il s''intéresse et il admire la syntaxe."},{"id":"d","text":"S''intéressant et admirant la syntaxe, il la maîtrise."}]'::jsonb, 'b', 'La phrase fautive coordonne « s''intéresse » et « admire » sur le même COD « la syntaxe », mais « s''intéresser » exige un COI introduit par « à » (s''intéresser *à* qqch.) alors qu''« admirer » admet un COD direct. La seule correction syntaxiquement valide est de restituer la préposition et le pronom anaphorique : « Il s''intéresse à la syntaxe et l''admire. » La phrase (c) répète le sujet mais laisse subsister la zeugme fautive (deux régimes différents pour deux verbes coordonnés sans distinction).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a639db0-f9f9-585b-a2a7-e1a7d3453f3e', '3bc1a97f-6e89-5006-aed2-f13c83a892b3', 'Laquelle de ces phrases respecte l''ordre des mots et les contraintes syntaxiques du français soutenu ?', '[{"id":"a","text":"C''est pourquoi il faut, avant de conclure, examiner les contre-arguments."},{"id":"b","text":"C''est pourquoi il faut examiner, avant de conclure les contre-arguments."},{"id":"c","text":"C''est pourquoi il faut examiner les contre-arguments, avant de conclure."},{"id":"d","text":"C''est pourquoi avant de conclure il faut examiner les contre-arguments."}]'::jsonb, 'a', 'La phrase (a) place l''infinitive circonstancielle « avant de conclure » en incise, entre virgules, immédiatement après le verbe modal « faut », ce qui est syntaxiquement et stylistiquement correct : la frontière entre le verbe principal et son COD reste lisible. La phrase (b) crée une ambiguïté d''attachement : on ne sait pas si « avant de conclure » modifie « examiner » ou si « les contre-arguments » est COD de « conclure ». La phrase (d) omet les virgules nécessaires à l''incise.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8fabba57-8b30-5556-93df-aa2262c2be6e', 'b639796a-5cad-5da3-8402-37ce2601e5db', 'fr-mastery', 'Diagnostic — Grammaire', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('115924d1-a555-58be-a771-5fcbad701f96', '8fabba57-8b30-5556-93df-aa2262c2be6e', 'Laquelle de ces phrases présente un accord du participe passé correct ?', '[{"id":"a","text":"Les résultats qu''il a obtenu sont excellents."},{"id":"b","text":"Les résultats qu''il a obtenus sont excellents."},{"id":"c","text":"Les résultats qu''il a obtenues sont excellents."},{"id":"d","text":"Les résultats qu''il a obtenu été excellents."}]'::jsonb, 'b', 'Le COD « que » (mis pour « les résultats », masculin pluriel) est placé avant le verbe avoir : le participe passé « obtenu » s''accorde donc en genre et en nombre → « obtenus ». L''option a (invariable) et c (féminin pluriel erroné) sont incorrectes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e4bfea9-57b3-5165-9c59-b71751b2ef84', '8fabba57-8b30-5556-93df-aa2262c2be6e', 'Quelle forme verbale convient dans la phrase : « Bien qu''elle ___ fatiguée, elle continua à travailler. » ?', '[{"id":"a","text":"était"},{"id":"b","text":"est"},{"id":"c","text":"soit"},{"id":"d","text":"serait"}]'::jsonb, 'c', 'La conjonction « bien que » exige le subjonctif présent. La forme correcte de « être » au subjonctif présent, 3e personne du singulier, est « soit ». L''imparfait (était), le présent indicatif (est) et le conditionnel (serait) sont tous exclus après « bien que ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0409dd4-399d-5d99-8c58-9d75fb2bc07a', '8fabba57-8b30-5556-93df-aa2262c2be6e', 'Choisissez la phrase dans laquelle les homophones sont tous correctement employés.', '[{"id":"a","text":"On a remarqué qu''il avait mit ses affaires là ou on lui avait dit."},{"id":"b","text":"On a remarqué qu''il avait mis ses affaires là où on lui avait dit."},{"id":"c","text":"Ont a remarqué qu''il avait mit ses affaires là où on lui avait dit."},{"id":"d","text":"On a remarqué qu''il avait mis ses affaires la où on lui avait dit."}]'::jsonb, 'b', '« On » (pronom sujet), « mis » (participe de mettre, non *mit*), « là » (adverbe de lieu avec accent grave), « où » (adverbe relatif de lieu, non *ou* conjonction) : seule l''option b respecte toutes ces règles simultanément.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26f7441c-d57b-5761-a6c9-16b90ec2c7f3', '8fabba57-8b30-5556-93df-aa2262c2be6e', 'Dans « Elle ___ écrit à ses amis », quel est l''accord correct du participe passé si le pronom « leur » précède le verbe ?', '[{"id":"a","text":"Elle leur a écrit — participe invariable."},{"id":"b","text":"Elle leur a écrite — participe accordé au féminin."},{"id":"c","text":"Elle leur a écrits — participe accordé au pluriel."},{"id":"d","text":"Elle leur a écrites — participe accordé au féminin pluriel."}]'::jsonb, 'a', '« Leur » est ici un pronom COI (écrire à quelqu''un). Le participe passé conjugué avec avoir ne s''accorde qu''avec un COD antéposé, jamais avec un COI. Il reste donc invariable : « écrit ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b5b691ef-e67d-5bca-bf1d-2084e919cf8c', 'b639796a-5cad-5da3-8402-37ce2601e5db', 'fr-mastery', 'Palier 1 — Accords et homophones fondamentaux', 2, 50, 10, 'practice', 'admin', 1)
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
  ('ee63c286-3de2-5973-9c22-96fffbaf86c1', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', 'Complétez : « Les enfants ___ partis avant l''aube. »', '[{"id":"a","text":"sont"},{"id":"b","text":"ont"},{"id":"c","text":"était"},{"id":"d","text":"a"}]'::jsonb, 'a', 'Le verbe « partir » se conjugue avec l''auxiliaire « être » aux temps composés. Le sujet « les enfants » est masculin pluriel, d''où « sont partis » (accord du participe avec le sujet). « Ont » serait l''auxiliaire avoir, incorrect ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('553347ac-bad6-5fc9-8c07-1e80392a33da', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', 'Choisissez la forme correcte : « Il ___ rencontré ses collègues hier. »', '[{"id":"a","text":"a"},{"id":"b","text":"à"},{"id":"c","text":"as"},{"id":"d","text":"est"}]'::jsonb, 'a', '« A » est ici le verbe avoir conjugué à la 3e personne du singulier du présent (passé composé). On peut le remplacer par « avait » → « il avait rencontré » : le test confirme que c''est bien le verbe, non la préposition « à ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afb10bb6-999f-55bd-8122-155008c0e77e', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', 'Quel est l''homophone correct dans : « ___ livre est passionnant ; prête-le moi. » ?', '[{"id":"a","text":"Se"},{"id":"b","text":"Ce"},{"id":"c","text":"Cet"},{"id":"d","text":"Ces"}]'::jsonb, 'b', 'Devant le nom masculin singulier « livre », le déterminant démonstratif est « ce » (masculin singulier). « Cet » s''emploie devant une voyelle ou un h muet (*cet homme*). « Se » est un pronom réfléchi, non un déterminant. « Ces » est pluriel.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e13f276a-7aac-5f4a-a773-e6bf3b275035', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', 'Laquelle de ces phrases est correctement accordée ?', '[{"id":"a","text":"La troupe de soldats marchaient en silence."},{"id":"b","text":"La troupe de soldats marchait en silence."},{"id":"c","text":"La troupe de soldats marchaients en silence."},{"id":"d","text":"La troupe de soldats ont marché en silence."}]'::jsonb, 'b', 'Le sujet grammatical est « la troupe » (nom collectif singulier), non « soldats ». Le verbe s''accorde donc au singulier : « marchait ». Les options a et c accordent à tort avec le complément pluriel « soldats ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68147ffc-dc72-5d42-b0de-4acc32bdf14f', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', 'Complétez : « Je ne sais pas ___ tu viendras demain. »', '[{"id":"a","text":"ce que"},{"id":"b","text":"se que"},{"id":"c","text":"si"},{"id":"d","text":"soit"}]'::jsonb, 'c', 'L''interrogative indirecte portant sur l''éventualité d''une venue s''introduit par « si » : « Je ne sais pas si tu viendras ». « Ce que » introduirait une subordonnée complétive en COD d''une tout autre nature (objet inconnu, non éventualité).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('689afb94-f533-512b-9e88-140cc7cb2f68', 'b5b691ef-e67d-5bca-bf1d-2084e919cf8c', 'Laquelle de ces phrases emploie correctement « ou » / « où » ?', '[{"id":"a","text":"Dis-moi ou tu vas, ou reste ici."},{"id":"b","text":"Dis-moi où tu vas, ou reste ici."},{"id":"c","text":"Dis-moi où tu vas, où reste ici."},{"id":"d","text":"Dis-moi ou tu vas, où reste ici."}]'::jsonb, 'b', '« Où » (avec accent) est l''adverbe relatif de lieu introduisant la subordonnée interrogative indirecte « où tu vas ». « Ou » (sans accent, remplaçable par « ou bien ») est la conjonction de coordination reliant les deux propositions principales. Seule l''option b respecte cette double distinction.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'b639796a-5cad-5da3-8402-37ce2601e5db', 'fr-mastery', 'Palier 2 — Modes, temps et accords complexes', 3, 80, 15, 'practice', 'admin', 2)
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
  ('9b765c8d-b822-5bbd-9f21-8c13676dead8', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'Laquelle de ces phrases présente un accord du participe passé correct avec l''auxiliaire « avoir » ?', '[{"id":"a","text":"Les fleurs qu''il a cueillit étaient magnifiques."},{"id":"b","text":"Les fleurs qu''il a cueillies étaient magnifiques."},{"id":"c","text":"Les fleurs qu''il a cueillie étaient magnifiques."},{"id":"d","text":"Les fleurs qu''il a cueilli étaient magnifiques."}]'::jsonb, 'b', 'Le pronom relatif « que » reprend « les fleurs » (féminin pluriel) et est COD du verbe « cueillir ». Ce COD est placé avant l''auxiliaire « avoir » : le participe passé s''accorde donc en genre et en nombre avec lui → « cueillies » (féminin pluriel). L''option d (invariable) est une erreur fréquente ; a (*cueillit*) est une forme de passé simple mal placée ; c (féminin singulier) ignore le pluriel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b5e61ff-14e4-5f2b-97e7-e1214174224d', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'Quelle forme verbale convient dans : « Il souhaitait que nous ___ à l''heure. » ?', '[{"id":"a","text":"arriverons"},{"id":"b","text":"arrivions"},{"id":"c","text":"arrivions avions"},{"id":"d","text":"arriverions"}]'::jsonb, 'b', 'Le verbe « souhaiter que » exige le subjonctif. À la 1re personne du pluriel, le subjonctif présent de « arriver » est « arrivions » (radical *arriv-* + terminaison *-ions*). Le futur (arriverons) et le conditionnel (arriverions) sont exclus après une conjonction à subjonctif ; l''option c est une invention.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2d3a00c-11f0-58df-becc-9b01b0c28d46', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'Choisissez la phrase dans laquelle « leur » / « leurs » est correctement employé.', '[{"id":"a","text":"Les élèves ont rendu leurs copies ; le professeur leur a corrigés."},{"id":"b","text":"Les élèves ont rendu leurs copies ; le professeur les a corrigés."},{"id":"c","text":"Les élèves ont rendu leur copies ; le professeur les a corrigé."},{"id":"d","text":"Les élèves ont rendu leurs copies ; le professeur leur a corrigées."}]'::jsonb, 'b', '« Leurs copies » est correct (déterminant possessif, pluriel car plusieurs élèves ont chacun une copie). Pour « corriger les copies », le COD est « les » (pronom personnel, non « leur ») : « les a corrigés » (accord avec « les » mis pour « les élèves »). L''option a emploie « leur a corrigés » qui mélange pronom COI et accord impossible ; c omet le -s à « copies » ; d accorde mal.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('902e41b0-978f-5f5b-9d50-671be361e6de', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'Dans la phrase « Les scientifiques ___ que la découverte ___ révolutionnaire. », quelle paire est correcte (concordance des temps) ?', '[{"id":"a","text":"ont déclaré / est"},{"id":"b","text":"ont déclaré / était"},{"id":"c","text":"ont déclaré / serait"},{"id":"d","text":"ont déclaré / soit"}]'::jsonb, 'b', 'Le verbe principal « ont déclaré » est au passé composé. La subordonnée complétive exprime une simultanéité dans le passé : on emploie l''imparfait → « était ». Le présent (est) romprait la concordance ; le conditionnel (serait) exprimerait la postériorité ; le subjonctif (soit) est impossible après « déclarer que » à valeur assertive.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1c704b3-d2c1-5494-9a83-3e546078888e', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'Identifiez la faute dans : « Si elle aurait travaillé davantage, elle aurait réussi. »', '[{"id":"a","text":"Il faut écrire « Si elle travaillait davantage, elle réussirait. »"},{"id":"b","text":"Il faut écrire « Si elle avait travaillé davantage, elle aurait réussi. »"},{"id":"c","text":"Il faut écrire « Si elle aura travaillé davantage, elle aurait réussi. »"},{"id":"d","text":"La phrase est correcte : le conditionnel est possible après « si »."}]'::jsonb, 'b', 'Le conditionnel est interdit dans la proposition introduite par « si » hypothétique. Pour une hypothèse dans le passé (irréelle), la structure est : *si* + plus-que-parfait → conditionnel passé : « Si elle **avait travaillé** davantage, elle **aurait réussi** ». L''option a exprime une hypothèse présente (irréelle), non passée ; c emploie le futur antérieur, également exclu.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ca1c45c-63f9-5298-b5b8-4c5786e44c8c', '31001c4d-1d4a-5f6d-93e3-fc375abcad66', 'Quelle est la phrase correctement rédigée ?', '[{"id":"a","text":"Elles se sont lavées les mains avant de manger."},{"id":"b","text":"Elles se sont lavé les mains avant de manger."},{"id":"c","text":"Elles se sont lavés les mains avant de manger."},{"id":"d","text":"Elles se sont lavée les mains avant de manger."}]'::jsonb, 'b', 'Dans « se laver les mains », « se » est COI (elles lavent les mains à elles-mêmes) et « les mains » est le COD, placé **après** le verbe. Le participe passé ne s''accorde pas avec un COD postposé : il reste invariable → « lavé ». C''est un piège classique des verbes pronominaux avec un COD explicite.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ad8b7b85-fea8-560d-a651-04eb586bf8ce', 'b639796a-5cad-5da3-8402-37ce2601e5db', 'fr-mastery', 'Palier 3 — Maîtrise : accords, modes et homophones avancés', 4, 120, 25, 'boss', 'admin', 3)
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
  ('c11b1d50-1b25-5bff-8225-f1fe1d80e993', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', 'Dans la phrase « Quelle que soit la difficulté, il faut ___ affronter. », quel pronom complète correctement la phrase ?', '[{"id":"a","text":"la"},{"id":"b","text":"le"},{"id":"c","text":"y"},{"id":"d","text":"en"}]'::jsonb, 'a', '« La difficulté » est un nom féminin singulier, COD de « affronter ». Le pronom personnel COD correspondant est « la » (féminin singulier). « Le » serait masculin ; « y » remplace un complément introduit par « à » + lieu ou chose ; « en » remplace un complément introduit par « de » ou un partitif. Seul « la » convient ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4db617a3-c445-5c2c-b81e-d7dcd502200c', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', 'Laquelle de ces phrases présente un accord du participe passé avec un verbe pronominal correctement traité ?', '[{"id":"a","text":"Elles se sont souri en se retrouvant."},{"id":"b","text":"Elles se sont souris en se retrouvant."},{"id":"c","text":"Elles se sont sourie en se retrouvant."},{"id":"d","text":"Elles se sont souri en se retrouvants."}]'::jsonb, 'a', '« Sourire à quelqu''un » se construit avec un COI. Ici, « se » est COI (elles ont souri l''une à l''autre) : le participe passé ne s''accorde pas avec un COI antéposé → « souri » reste invariable. Seule l''option a est correcte ; b (masculin pluriel), c (féminin singulier) sont des accords erronés avec le sujet ; d ajoute un barbarisme sur le participe présent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d82bdb6-d713-5a54-ac54-abf97f260c5e', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', 'Repérez la phrase dans laquelle TOUS les homophones sont correctement écrits.', '[{"id":"a","text":"On leurs a dit qu''il fallait ce mettre au travail ou ils le souhaitaient."},{"id":"b","text":"On leur a dit qu''il fallait se mettre au travail où ils le souhaitaient."},{"id":"c","text":"On leur a dit qu''il fallait se mettre au travail ou il le souhaitaient."},{"id":"d","text":"Ont leur a dit qu''il fallait ce mettre au travail où ils le souhaitaient."}]'::jsonb, 'b', '« Leur » (pronom COI invariable), « se » (pronom réfléchi de « se mettre »), « où » (adverbe relatif de lieu) : ces trois formes sont toutes correctes dans l''option b. L''option a fautit sur *leurs* (déterminant à tort), *ce* (démonstratif à la place du réfléchi) et *ou* (conjonction au lieu de l''adverbe de lieu) ; c conserve *ou* sans accent ; d commence par *Ont* au lieu de *On*.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45650677-9f13-5d19-896f-49157dbbd7f1', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', 'Choisissez la forme verbale correcte pour compléter : « À peine ___ -il entré que la lumière s''éteignit. »', '[{"id":"a","text":"avait"},{"id":"b","text":"a"},{"id":"c","text":"fut"},{"id":"d","text":"était"}]'::jsonb, 'c', 'La locution « à peine… que » dans un récit littéraire exige le passé antérieur pour l''action accomplie en premier (entrer), suivi du passé simple pour l''action qui en résulte (s''éteignit). Le passé antérieur de « entrer » (verbe conjugué avec être) est « fut entré ». Le plus-que-parfait « avait entré » est impossible car « entrer » prend « être » ; le passé composé « a » est hors registre littéraire ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('183ea238-cae4-5fdb-bae1-ac120e01907e', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', 'Parmi ces phrases, laquelle contient une faute d''accord de l''adjectif ?', '[{"id":"a","text":"Ces femmes sont tout étonnées de le revoir."},{"id":"b","text":"Ces femmes sont toutes surprises de le revoir."},{"id":"c","text":"Ces femmes semblent tout heureuses de le revoir."},{"id":"d","text":"Ces femmes paraissent toutes ravies de le revoir."}]'::jsonb, 'c', 'Devant un adjectif féminin commençant par une consonne ou un h aspiré, « tout » (adverbe) prend la forme « toute(s) » pour des raisons euphoniques. « Heureuses » commence par un h aspiré : il faut écrire « toutes heureuses ». En revanche, « tout étonnées » (option a) est correct car « étonnées » commence par une voyelle → l''adverbe reste invariable. Les options b et d emploient « toutes » comme déterminant (accord normal avec le sujet féminin pluriel).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e480c693-6f3f-50e6-9a24-fd45d2cebccb', 'ad8b7b85-fea8-560d-a651-04eb586bf8ce', 'Dans quelle phrase le mode subjonctif est-il correctement employé — et nécessaire ?', '[{"id":"a","text":"Je crois qu''il vienne demain."},{"id":"b","text":"Il est certain qu''elle réussisse."},{"id":"c","text":"Bien qu''il pleuve, nous partirons."},{"id":"d","text":"Il affirme que tu aies raison."}]'::jsonb, 'c', 'La conjonction « bien que » exige obligatoirement le subjonctif : « qu''il pleuve » est bien au subjonctif présent → correct. En revanche, « croire que » (option a) à la forme affirmative appelle l''indicatif (*vient*) ; « il est certain que » (option b) est une certitude → indicatif (*réussira/réussit*) ; « affirmer que » (option d) appelle l''indicatif (*as raison*). Seule l''option c est à la fois correcte et nécessaire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8ab4d9e6-cc7a-54de-b89d-acea53b3c2b8', '4aa90233-3a14-53a0-ba53-31a005968fcf', 'fr-mastery', 'Diagnostic — Lexique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8ebefc85-d7ac-5d15-bead-db4207d08461', '8ab4d9e6-cc7a-54de-b89d-acea53b3c2b8', 'Dans la phrase « Son regard transperce l''obscurité comme une lame », le mot « transperce » est employé au :', '[{"id":"a","text":"Sens propre, car il s''agit d''une action physique réelle."},{"id":"b","text":"Sens figuré, car un regard ne peut pas physiquement percer quoi que ce soit."},{"id":"c","text":"Sens technique, propre au domaine de l''optique."},{"id":"d","text":"Sens familier, caractéristique de la langue orale."}]'::jsonb, 'b', 'Un regard est immatériel et ne peut pas littéralement percer l''obscurité : le verbe « transpercer » est ici employé au sens figuré pour évoquer l''intensité et la pénétration du regard. Le sens propre serait physique (transpercer une planche avec un clou).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b5e3d20-2505-58d2-bbfe-50a8dbcd256c', '8ab4d9e6-cc7a-54de-b89d-acea53b3c2b8', 'Laquelle de ces paires constitue une paire de PARONYMES ?', '[{"id":"a","text":"rapide / lent"},{"id":"b","text":"verre / ver"},{"id":"c","text":"conjecture / conjoncture"},{"id":"d","text":"courageux / intrépide"}]'::jsonb, 'c', 'Les paronymes sont des mots de forme proche mais de sens différent. « Conjecture » (hypothèse, supposition) et « conjoncture » (situation économique ou sociale) se ressemblent à l''écrit et à l''oral mais ne signifient pas la même chose. « Rapide/lent » sont des antonymes ; « verre/ver » sont des homonymes ; « courageux/intrépide » sont des synonymes.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c35ac86-7613-51cf-9a30-88bd5fa54a75', '8ab4d9e6-cc7a-54de-b89d-acea53b3c2b8', 'Que signifie l''expression idiomatique « brûler les étapes » ?', '[{"id":"a","text":"Progresser avec méthode et rigueur, sans sauter aucune étape."},{"id":"b","text":"Échouer à plusieurs reprises avant de réussir."},{"id":"c","text":"Aller trop vite, négliger les phases intermédiaires indispensables."},{"id":"d","text":"Mettre le feu à ses propres réalisations par excès de zèle."}]'::jsonb, 'c', '« Brûler les étapes » signifie aller trop vite, sauter des phases nécessaires d''un processus au risque de compromettre le résultat. L''image vient des relais de poste : un courrier qui « brûlait » (dépassait sans s''y arrêter) les étapes de repos risquait d''épuiser ses chevaux.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5f03323-bbcb-54ec-abaf-8698b6e52ed3', '8ab4d9e6-cc7a-54de-b89d-acea53b3c2b8', '« Il nous a expliqué la situation de manière fort limpide. » Quel mot de registre SOUTENU pourrait remplacer « limpide » dans ce contexte ?', '[{"id":"a","text":"sympa"},{"id":"b","text":"claire"},{"id":"c","text":"pellucide"},{"id":"d","text":"zarbi"}]'::jsonb, 'c', '« Pellucide » (du latin pellucidus) signifie « qui laisse passer la lumière » au sens propre, et « parfaitement clair, transparent » au sens figuré — c''est un synonyme soutenu de « limpide ». « Claire » est courant, « sympa » et « zarbi » sont familiers et ne conviennent pas à un registre soutenu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('386598a5-17d9-51eb-9865-0080cbdd5d02', '4aa90233-3a14-53a0-ba53-31a005968fcf', 'fr-mastery', 'Palier 1 — Lexique : sens, synonymes et registres', 2, 50, 10, 'practice', 'admin', 1)
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
  ('ec46e2f3-8c2c-5d00-bf65-2c70abb9116d', '386598a5-17d9-51eb-9865-0080cbdd5d02', 'Dans la phrase « La nouvelle a suscité une vive controverse au sein de la rédaction », que signifie le mot « controverse » ?', '[{"id":"a","text":"Un débat animé, une discussion opposant des points de vue contraires."},{"id":"b","text":"Une décision prise à l''unanimité par un groupe."},{"id":"c","text":"Un éloge unanime adressé à l''auteur de la nouvelle."},{"id":"d","text":"Un article publié en réponse à un autre article."}]'::jsonb, 'a', '« Controverse » (du latin controversia) désigne un débat, souvent prolongé et public, opposant des opinions contradictoires sur un sujet sérieux. On dit « soulever une controverse » ou « faire l''objet d''une controverse ». À ne pas confondre avec « polémique », plus chargée émotionnellement, ni avec « consensus », qui en est l''antonyme exact.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('013f1b15-e4ea-5d75-b28c-e0515a027df5', '386598a5-17d9-51eb-9865-0080cbdd5d02', 'Quel synonyme de registre SOUTENU convient pour remplacer « clair » dans : « Il a exposé ses arguments de façon très claire » ?', '[{"id":"a","text":"simple"},{"id":"b","text":"limpide"},{"id":"c","text":"facile"},{"id":"d","text":"gentil"}]'::jsonb, 'b', '« Limpide » (du latin limpidus) désigne ce qui est parfaitement transparent, clair et intelligible — c''est le synonyme soutenu de « clair » dans un contexte discursif ou intellectuel. « Simple » porte une nuance différente (absence de complexité), « facile » est courant et connoté, et « gentil » est hors sujet. On l''emploie dans des tournures comme « une démonstration limpide » ou « un style d''une grande limpidité ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4438d74f-ed2d-565d-a342-971ae57232d8', '386598a5-17d9-51eb-9865-0080cbdd5d02', 'Dans quelle phrase le mot « avare » est-il employé correctement ?', '[{"id":"a","text":"Elle est avare de compliments : elle en distribue à tout le monde généreusement."},{"id":"b","text":"Il est avare de mots : il s''exprime avec une extrême concision."},{"id":"c","text":"Cet artiste avare partage ses œuvres avec une générosité remarquable."},{"id":"d","text":"Ce roman avare se lit avec un plaisir croissant d''une page à l''autre."}]'::jsonb, 'b', '« Avare » signifie, au sens propre, qui répugne à dépenser. Au sens figuré, construit avec « de », il désigne quelqu''un qui accorde chichement quelque chose : « avare de mots » (qui parle peu), « avare de compliments » (qui en donne rarement). La phrase A contredit le sens d''« avare » en le combinant avec « généreusement ». Les phrases C et D emploient le mot de façon incohérente. L''antonyme d''avare est « prodigue ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7400f4c5-9e93-5a49-9a31-9aa0aff92d25', '386598a5-17d9-51eb-9865-0080cbdd5d02', 'Que signifie l''expression idiomatique « brûler les étapes » dans : « En sautant la relecture, il a brûlé les étapes et rendu un devoir truffé de fautes. » ?', '[{"id":"a","text":"Progresser avec méthode et rigueur, sans jamais rien négliger."},{"id":"b","text":"Aller trop vite, sauter des phases intermédiaires indispensables."},{"id":"c","text":"Échouer à plusieurs reprises avant de réussir à bout de persévérance."},{"id":"d","text":"Détruire le travail accompli par manque de concentration."}]'::jsonb, 'b', '« Brûler les étapes » signifie aller trop vite et négliger les phases nécessaires d''un processus, au risque d''en compromettre le résultat. L''image vient des relais de poste : un courrier qui « brûlait » (dépassait sans s''y arrêter) les étapes risquait d''épuiser ses chevaux. La phrase illustre parfaitement ce sens : sauter la relecture = négliger une étape indispensable.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('851df533-6479-59d6-863d-5265cb8fa8d2', '386598a5-17d9-51eb-9865-0080cbdd5d02', 'Dans la phrase « Il répondit avec une acrimonie qui surprit toute l''assemblée », que signifie « acrimonie » ?', '[{"id":"a","text":"Une grande douceur et une amabilité exquise."},{"id":"b","text":"Une amertume mêlée d''aigreur et d''hostilité dans les propos."},{"id":"c","text":"Une indifférence polie et une neutralité affichée."},{"id":"d","text":"Un enthousiasme communicatif et une énergie débordante."}]'::jsonb, 'b', '« Acrimonie » (du latin acrimonia, âcreté) désigne une disposition d''esprit aigre, acerbe et hostile, qui transparaît dans les paroles ou le comportement. On parle d''un ton plein d''acrimonie ou d''une critique empreinte d''acrimonie. Son antonyme serait « aménité » (affabilité bienveillante) ou « douceur ». À mémoriser dans la phrase : « répondre avec acrimonie » — le contexte de surprise dans la phrase confirme le caractère inattendu et déplaisant de la réaction.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c637e468-2efd-5f88-a681-dc7efd7eefd0', '386598a5-17d9-51eb-9865-0080cbdd5d02', 'Quel mot de registre FAMILIER doit être remplacé pour passer au registre COURANT dans : « Le directeur a complètement loupé sa prise de parole devant le conseil. » ?', '[{"id":"a","text":"directeur"},{"id":"b","text":"prise de parole"},{"id":"c","text":"loupé"},{"id":"d","text":"conseil"}]'::jsonb, 'c', '« Louper » est un verbe de registre familier signifiant « rater, manquer, échouer ». Pour adopter un registre courant, on le remplacera par « raté » ou « manqué » ; dans un registre soutenu, on dira « n''a pas su maîtriser » ou « a échoué dans ». Les autres termes — directeur, prise de parole, conseil — appartiennent déjà au registre courant ou soutenu et n''appellent aucun remplacement.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('41046ebf-95c5-5214-b87d-ad7399326ff6', '4aa90233-3a14-53a0-ba53-31a005968fcf', 'fr-mastery', 'Palier 2 — Lexique : paronymes, contexte et nuances', 3, 80, 15, 'practice', 'admin', 2)
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
  ('7be23713-0f88-53c8-9b38-caee5ebb556e', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'Choisissez le mot juste pour compléter : « Les mesures prises par le gouvernement ont ______ sur l''évolution des prix sans parvenir à les stabiliser totalement. »', '[{"id":"a","text":"influencé"},{"id":"b","text":"influé"},{"id":"c","text":"infléchi"},{"id":"d","text":"inféré"}]'::jsonb, 'b', '« Influer » est intransitif et se construit avec « sur » : on dit « influer sur quelque chose » pour exprimer le fait d''exercer une influence. « Influencer » est transitif direct : on « influence quelqu''un ». Ici le complément est « sur l''évolution des prix », ce qui impose « influé ». « Infléchir » (modifier une direction) et « inférer » (déduire par raisonnement) ont des sens distincts et ne conviennent pas dans ce contexte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce54f665-a4d5-5529-ab5f-8a1f1af15c40', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'Dans la phrase « La collision entre les deux véhicules a fait trois blessés », quel paronyme faut-il substituer si l''on veut parler d''une entente secrète et frauduleuse entre des parties ?', '[{"id":"a","text":"Cohésion"},{"id":"b","text":"Collusion"},{"id":"c","text":"Coalescence"},{"id":"d","text":"Coercition"}]'::jsonb, 'b', '« Collusion » (du latin colludere, jouer ensemble en secret) désigne une entente secrète et frauduleuse entre des parties qui devraient normalement s''opposer — par exemple entre un juge et un accusé, ou entre des entreprises concurrentes. C''est un paronyme de « collision » (choc physique ou conflit d''intérêts). « Cohésion » désigne l''union d''un groupe ; « coalescence », la fusion de deux éléments ; « coercition », une contrainte exercée par la force — aucun ne convient pour désigner une entente frauduleuse.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54a3cc39-3157-5d8e-9ef0-5183474954b7', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'Lequel de ces mots est un ANTONYME précis de « prolixe » dans un contexte rhétorique ?', '[{"id":"a","text":"Verbeux"},{"id":"b","text":"Bavard"},{"id":"c","text":"Laconique"},{"id":"d","text":"Disert"}]'::jsonb, 'c', '« Prolixe » qualifie celui qui parle ou écrit de façon trop abondante, au détriment de la clarté. Son antonyme précis est « laconique » (du latin laconicus, relatif aux Lacédémoniens réputés pour leur concision), qui désigne un style bref, ramassé, réduit à l''essentiel. « Verbeux » et « bavard » sont des synonymes de « prolixe » ; « disert » qualifie quelqu''un qui parle avec aisance et élégance — ce n''est pas un contraire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e91ac31-d95e-53c9-a53c-35fd08f4efcf', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'Choisissez le mot de registre SOUTENU qui convient pour compléter : « Il écouta ses interlocuteurs avec une ______ bienveillante, sans jamais les interrompre. »', '[{"id":"a","text":"cool attitude"},{"id":"b","text":"bonne écoute"},{"id":"c","text":"mansuétude"},{"id":"d","text":"décontraction"}]'::jsonb, 'c', '« Mansuétude » (du latin mansuetudo) désigne une douceur indulgente et bienveillante envers autrui — exactement ce que suggère la phrase (écouter sans interrompre). C''est un terme soutenu qui s''inscrit parfaitement dans ce registre formel. « Cool attitude » est familier et mélange les langues ; « bonne écoute » est courant mais banal ; « décontraction » évoque la détente physique ou mentale, sans la nuance de bienveillance active requise.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00b519a1-3006-539e-ba8d-c75c4178cf56', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'Dans la phrase « Ce savant est une autorité éminente dans son domaine », que signifie « éminente » ? Attention : ne pas confondre avec son paronyme.', '[{"id":"a","text":"Sur le point d''arriver ou de se produire, très prochaine."},{"id":"b","text":"Qui s''impose par la force et l''intimidation."},{"id":"c","text":"Qui se distingue par son excellence, remarquable et illustre."},{"id":"d","text":"Récemment promue à un rang supérieur."}]'::jsonb, 'c', '« Éminent » (du latin eminere, se dresser au-dessus) signifie remarquable, illustre, qui s''élève au-dessus de la moyenne par ses mérites ou ses connaissances. Son paronyme « imminent » (du latin imminere, menacer de près) signifie « qui va se produire très prochainement ». La réponse A correspond au sens d''« imminent » — confusion classique et piège fréquent aux concours. Mémoriser : un savant ÉMINENT, un danger IMMINENT.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f73ee323-bb3c-59b7-9d16-dba2847fbaf5', '41046ebf-95c5-5214-b87d-ad7399326ff6', 'Que signifie « se répandre en conjectures » dans : « Faute de faits établis, les journalistes se sont répandus en conjectures » ?', '[{"id":"a","text":"S''appuyer sur des preuves solides et des données vérifiées."},{"id":"b","text":"Multiplier les hypothèses et les suppositions non vérifiées."},{"id":"c","text":"Analyser avec rigueur la conjoncture économique du moment."},{"id":"d","text":"Refuser de s''exprimer en l''absence d''informations fiables."}]'::jsonb, 'b', '« Conjecture » (du latin conjectura, rapprochement d''indices) désigne une hypothèse, une supposition fondée sur des indices incertains. « Se répandre en conjectures » signifie donc multiplier les suppositions sans base factuelle solide. La phrase l''illustre clairement : l''absence de faits établis pousse au raisonnement spéculatif. À ne pas confondre avec « conjoncture » (situation économique ou sociale à un moment donné), paronyme trompeur par sa proximité sonore.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fc862ec5-38fd-53d9-8241-c711a5c5a92f', '4aa90233-3a14-53a0-ba53-31a005968fcf', 'fr-mastery', 'Palier 3 — Lexique : maîtrise avancée (Boss)', 4, 120, 25, 'boss', 'admin', 3)
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
  ('b4498f76-9810-5847-becb-1930b226c782', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'Choisissez le mot juste pour compléter : « Le romancier a choisi de traiter ce sujet avec une ______ désarmante, refusant tout pathos. » Le mot attendu désigne une sobriété dépouillée et efficace.', '[{"id":"a","text":"désinvolture"},{"id":"b","text":"prolixité"},{"id":"c","text":"sobriété"},{"id":"d","text":"laconicité"}]'::jsonb, 'c', '« Sobriété » désigne ici la qualité d''un style dépouillé, retenu, sans ornement superflu ni pathos — sens figuré de la tempérance stylistique. « Désinvolture » implique une légèreté désinhibée, parfois irrévérencieuse, qui ne colle pas au refus du pathos. « Prolixité » est l''excès de paroles, à l''opposé du sens voulu. « Laconicité » existe mais reste très rare et presque pédant dans ce contexte ; « sobriété » est le choix idiomatique naturel en critique littéraire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c91d708c-58ca-5f6a-9a38-150c20c3ada0', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'Dans la phrase « Son attitude ______ pendant le procès a été jugée inacceptable par le tribunal », quel paronyme convient pour désigner quelqu''un qui ne montre aucune considération pour les règles ou les personnes ?', '[{"id":"a","text":"cavalière"},{"id":"b","text":"chevaleresque"},{"id":"c","text":"équestre"},{"id":"d","text":"cavale"}]'::jsonb, 'a', '« Cavalière » au sens figuré (en parlant d''une attitude) signifie désinvolte, sans égards, qui manque de respect ou de tact. L''expression « procédé cavalier » ou « attitude cavalière » désigne une façon d''agir jugée incorrecte envers autrui. « Chevaleresque » signifie au contraire noble, loyal, plein de courtoisie — quasi-antonyme ici. « Équestre » se rapporte aux chevaux ou à l''équitation (statue équestre). « Cavale » est un nom, pas un adjectif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed7dc171-9562-59b6-86d4-4c0aa32154db', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'Lequel de ces énoncés illustre correctement le sens de l''expression « jeter de la poudre aux yeux » ?', '[{"id":"a","text":"Le chercheur a publié toutes ses données brutes pour que ses pairs puissent les vérifier."},{"id":"b","text":"Le candidat a exhibé un bilan flatteur construit sur des statistiques trompeuses pour impressionner les électeurs."},{"id":"c","text":"Le négociateur a révélé honnêtement les failles de son propre dossier pour instaurer la confiance."},{"id":"d","text":"La direction a admis ses erreurs de gestion devant l''ensemble du personnel."}]'::jsonb, 'b', '« Jeter de la poudre aux yeux » signifie éblouir, impressionner les autres par des apparences trompeuses afin de dissimuler la réalité ou ses propres faiblesses. L''image vient de la poudre projetée pour aveugler l''adversaire. La phrase B illustre exactement ce mécanisme : un bilan flatteur mais fondé sur des données trompeuses, construit pour impressionner. Les phrases A, C et D décrivent au contraire une transparence franche.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac16c26b-a52b-5105-8a5d-177753609eb4', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'Dans ce texte, identifiez le mot qui appartient au registre SOUTENU et qui serait remplacé par « bizarre » en registre courant : « Son comportement ______ lors de la cérémonie fit l''objet de nombreux commentaires. »', '[{"id":"a","text":"hétéroclite"},{"id":"b","text":"zarbi"},{"id":"c","text":"louche"},{"id":"d","text":"bizarre"}]'::jsonb, 'a', '« Hétéroclite » (du grec heteroklitos, qui se décline irrégulièrement) désigne au sens figuré ce qui est composé d''éléments disparates, étranges, qui ne s''accordent pas — un équivalent soutenu de « bizarre » ou « singulier ». « Zarbi » est du verlan de « bizarre », donc très familier. « Louche » est courant et porte une connotation de suspicion morale plus que d''étrangeté formelle. « Bizarre » est le terme courant lui-même. Dans un texte soutenu comme une chronique de cérémonie officielle, « hétéroclite » s''impose.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49ba7791-70c4-5618-8b9f-b4ab73617396', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'Choisissez le mot correct pour compléter : « Le rapport ______ entre les deux entreprises a été mis au jour lors de l''enquête judiciaire. » Il s''agit d''un accord secret et illicite.', '[{"id":"a","text":"collusoire"},{"id":"b","text":"collisionnel"},{"id":"c","text":"coalescent"},{"id":"d","text":"corrosif"}]'::jsonb, 'a', '« Collusoire » (adjectif dérivé de « collusion ») qualifie ce qui relève d''une entente secrète et frauduleuse entre des parties normalement opposées. C''est le terme juridique précis pour un accord illicite entre, par exemple, deux entreprises concurrentes ou deux parties à un procès. « Collisionnel » n''existe pas en français standard. « Coalescent » se dit de deux éléments qui fusionnent naturellement (sens positif ou neutre). « Corrosif » désigne ce qui ronge ou détruit (au sens propre et figuré).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2734595-ffd1-5cb6-8948-9d13ebdf9b20', 'fc862ec5-38fd-53d9-8241-c711a5c5a92f', 'Laquelle de ces phrases emploie correctement le mot « acéré » en distinguant son sens précis de ses faux amis ?', '[{"id":"a","text":"Son esprit acéré lui permettait de saisir immédiatement les subtilités d''un raisonnement."},{"id":"b","text":"Il portait un regard acéré, plein de douceur et de compréhension."},{"id":"c","text":"Sa réponse acérée était chaleureuse et empreinte d''affection."},{"id":"d","text":"Le juge acéré rendit un verdict clément et bienveillant."}]'::jsonb, 'a', '« Acéré » (de l''ancien français acier, acier) signifie tranchant, incisif — au sens propre, une lame bien aiguisée ; au sens figuré, une intelligence pénétrante ou une critique mordante. La phrase A exploite exactement ce sens figuré positif : un esprit acéré saisit les subtilités comme une lame coupe net. Les phrases B et C créent des contradictions (douceur, chaleur s''opposent à l''idée de tranchant). La phrase D applique incorrectement l''adjectif à une personne plutôt qu''à ses qualités intellectuelles ou à ses propos, et le verdict clément contredit la dureté du terme.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', '2567b64f-bd7c-5121-8690-413031a1ac80', 'fr-mastery', 'Diagnostic — Épreuve de synthèse', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6d99f9d8-fcb6-5a7d-9baf-459d334b4cd6', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Lisez ce passage :

« On vantait partout sa générosité ; il ne donnait pourtant qu''à ceux dont il attendait un retour. Les nécessiteux véritables, eux, restaient à sa porte. »

Que laisse inférer ce passage sur le personnage ?', '[{"id":"a","text":"Sa générosité est sincère mais mal comprise du public."},{"id":"b","text":"Sa prétendue générosité n''est qu''un calcul intéressé."},{"id":"c","text":"Il aide en priorité les personnes les plus démunies."},{"id":"d","text":"Il ignore que sa réputation est usurpée."}]'::jsonb, 'b', 'L''opposition marquée par « pourtant » entre la réputation (« on vantait sa générosité ») et les faits (« il ne donnait qu''à ceux dont il attendait un retour ») révèle un intérêt déguisé en bienfaisance ; le sort des « nécessiteux véritables » le confirme. (a) prend la réputation pour argent comptant. (c) est l''inverse de ce que dit le texte. (d) invente un état mental absent du passage.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab216150-dd83-579a-8f57-80bb1ed85e02', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Dans la phrase « Le rapport, que la commission avait longtemps tenu secret, fut enfin rendu public », quelle est la nature et la fonction de la proposition « que la commission avait longtemps tenu secret » ?', '[{"id":"a","text":"Une subordonnée complétive, COD du verbe « fut »."},{"id":"b","text":"Une subordonnée relative, complément de l''antécédent « rapport »."},{"id":"c","text":"Une subordonnée circonstancielle de cause."},{"id":"d","text":"Une proposition indépendante juxtaposée."}]'::jsonb, 'b', 'Introduite par le pronom relatif « que » (qui reprend l''antécédent « rapport » et y exerce la fonction de COD de « avait tenu »), la proposition est une subordonnée relative qui complète le nom « rapport ». Une complétive (a) serait introduite par la conjonction « que » et compléterait un verbe, non un nom. Il n''y a ni valeur causale (c) ni juxtaposition (d) : la proposition est enchâssée et dépend du nom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2e27486-5901-5b7b-9f51-3fe5324ca8d7', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Quelle phrase respecte correctement l''accord du participe passé ?', '[{"id":"a","text":"Les décisions que le conseil a prises ont surpris l''assemblée."},{"id":"b","text":"Les décisions que le conseil a pris ont surpris l''assemblée."},{"id":"c","text":"Les décisions que le conseil a prise ont surpris l''assemblée."},{"id":"d","text":"Les décisions que le conseil ont prises ont surpris l''assemblée."}]'::jsonb, 'a', 'Avec l''auxiliaire « avoir », le participe passé s''accorde avec le COD lorsque celui-ci est placé avant le verbe. Ici le COD est « que », mis pour « les décisions » (féminin pluriel), antéposé : on écrit donc « prises ». (b) et (c) négligent ou faussent l''accord. (d) commet en outre une faute d''accord sujet-verbe (« le conseil ont »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3abac0a4-d792-5edc-93ef-a33f33d4859e', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Choisissez le mot juste : « Faute de preuves, l''enquêteur en fut réduit à de simples ______ sur le mobile du crime. »', '[{"id":"a","text":"conjonctures"},{"id":"b","text":"conjectures"},{"id":"c","text":"confitures"},{"id":"d","text":"conjugaisons"}]'::jsonb, 'b', '« Conjecture » désigne une hypothèse fondée sur des indices incertains : « faute de preuves » impose ce sens. Le paronyme « conjoncture » (a) désigne une situation économique ou sociale à un moment donné et ne convient pas. (c) et (d) sont des intrus sans rapport sémantique, glissés pour tester la lecture attentive.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3375ad20-96fe-554b-9520-fc7939ef43fb', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Lisez ce passage :

« Il prétendait n''avoir rien remarqué. Mais ses mains tremblaient, sa voix se brisait, et il évitait soigneusement de croiser nos regards. »

Quel est l''effet produit par la succession des trois notations après « Mais » ?', '[{"id":"a","text":"Une énumération accumulative qui dément, par les indices physiques, la dénégation du personnage."},{"id":"b","text":"Une gradation descendante qui atténue progressivement le trouble du personnage."},{"id":"c","text":"Une comparaison qui rapproche le personnage d''un coupable type."},{"id":"d","text":"Une digression qui détourne l''attention du sujet principal."}]'::jsonb, 'a', 'Les trois propositions juxtaposées (« ses mains tremblaient, sa voix se brisait, et il évitait… ») forment une accumulation d''indices corporels qui contredisent la dénégation initiale (« il prétendait n''avoir rien remarqué ») : le « Mais » articule cette opposition. Il n''y a pas d''affaiblissement (b), pas de comparaison explicite (c), et ces notations sont au cœur du propos, non une digression (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('766d61e0-2be1-5e35-979c-76c48ce2154c', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Complétez en respectant la concordance des temps : « Je savais bien qu''un jour il ______ la vérité, quelles qu''en fussent les conséquences. »', '[{"id":"a","text":"dira"},{"id":"b","text":"dirait"},{"id":"c","text":"dise"},{"id":"d","text":"ait dit"}]'::jsonb, 'b', 'La principale est au passé (« je savais »), et la subordonnée exprime un fait postérieur à ce moment passé : on emploie alors le conditionnel présent à valeur de futur dans le passé, « dirait ». Le futur « dira » (a) conviendrait après une principale au présent. Le subjonctif (c) n''est pas commandé ici par « savoir » à la forme affirmative. (d) introduit un temps composé sans justification.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82f28540-d59d-5d25-b090-d08b1f2dcc68', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Lisez ce passage :

« La réforme, présentée comme une avancée sociale, ne profitera, en réalité, qu''aux mieux pourvus. On l''a parée de toutes les vertus ; le temps en dira la véritable nature. »

Quel mot ou groupe de mots porte le plus nettement la prise de position critique de l''auteur ?', '[{"id":"a","text":"« présentée comme une avancée sociale »"},{"id":"b","text":"« en réalité »"},{"id":"c","text":"« la réforme »"},{"id":"d","text":"« le temps »"}]'::jsonb, 'b', 'La locution « en réalité » oppose explicitement l''apparence (« présentée comme une avancée ») à ce que l''auteur tient pour le fait véritable : elle signale le démenti et donc la position critique. « Présentée comme » (a) introduit certes l''apparence trompeuse mais c''est « en réalité » qui marque la rupture critique. « La réforme » (c) et « le temps » (d) sont des éléments neutres du propos.', 7)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b09c3bfa-b228-56cd-99f9-54366c124d14', 'b9f2bdad-5941-5c18-8f7a-6a75f83de4c7', 'Dans la phrase « Ses remarques acérées blessaient sans qu''il en eût conscience », quel énoncé analyse correctement à la fois le sens de « acérées » et le mode du verbe « eût » ?', '[{"id":"a","text":"« Acérées » signifie chaleureuses ; « eût » est un conditionnel passé."},{"id":"b","text":"« Acérées » signifie incisives, mordantes ; « eût » est un subjonctif imparfait commandé par « sans que »."},{"id":"c","text":"« Acérées » signifie maladroites ; « eût » est un plus-que-parfait de l''indicatif."},{"id":"d","text":"« Acérées » signifie hésitantes ; « eût » est un futur antérieur."}]'::jsonb, 'b', '« Acéré », au sens figuré, qualifie des propos tranchants, mordants — cohérent avec « blessaient ». La locution conjonctive « sans que » commande le subjonctif : « eût » est ici un subjonctif imparfait (forme soutenue de « ait »), et non un conditionnel (a), un indicatif plus-que-parfait (c) ou un futur antérieur (d). Les sens proposés en (a), (c) et (d) contredisent en outre l''idée de blessure.', 8)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('38655883-4f78-5df4-b448-466ffb2dd3b2', '2567b64f-bd7c-5121-8690-413031a1ac80', 'fr-mastery', 'Palier 1 — Épreuve de synthèse : un portrait en demi-teinte', 2, 50, 10, 'practice', 'admin', 1)
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
  ('f8565956-c4bb-50ef-ab48-27cbb2f6ef63', '38655883-4f78-5df4-b448-466ffb2dd3b2', 'Lisez attentivement ce texte, support de toute l''épreuve :

« Monsieur Lévêque passait, dans le quartier, pour un homme affable. Il saluait chacun, s''enquérait de la santé des uns, des affaires des autres ; nul ne l''avait jamais entendu hausser le ton. Pourtant, ceux qui travaillaient sous ses ordres en parlaient à voix basse : derrière les portes closes, l''homme affable se faisait âpre, et sa courtoisie de façade tombait comme un masque. »

[COMPRÉHENSION] Quelle vérité sur le personnage ce texte conduit-il à inférer ?', '[{"id":"a","text":"Sa courtoisie publique masque une dureté que seuls ses subordonnés connaissent."},{"id":"b","text":"Il est uniformément doux, en public comme en privé."},{"id":"c","text":"Les habitants du quartier le détestent ouvertement."},{"id":"d","text":"Ses subordonnés le respectent pour sa franchise constante."}]'::jsonb, 'a', 'L''opposition annoncée par « Pourtant » oppose la réputation publique (« un homme affable ») au témoignage des subordonnés (« âpre », « courtoisie de façade »), et l''image du « masque » qui « tombe » scelle l''inférence : la douceur n''est qu''une apparence. (b) ignore le « Pourtant » et le second visage du personnage. (c) est faux : le quartier l''apprécie. (d) contredit le ton inquiet (« à voix basse ») des subordonnés.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ccb068ce-d222-5367-99dd-98988ced687b', '38655883-4f78-5df4-b448-466ffb2dd3b2', '[LEXIQUE] Dans le texte, l''adjectif « âpre » appliqué à l''homme « derrière les portes closes » signifie :', '[{"id":"a","text":"Aimable et chaleureux."},{"id":"b","text":"Rude, dur et désagréable dans ses rapports."},{"id":"c","text":"Distrait et insouciant."},{"id":"d","text":"Timide et effacé."}]'::jsonb, 'b', '« Âpre », au sens propre, qualifie une saveur rude ; au sens figuré, un caractère ou un ton dur, rêche, sans douceur. Le contexte (opposition à « affable », « masque » qui tombe) impose cette valeur. (a) en est l''antonyme. (c) et (d) introduisent des traits absents du texte et incompatibles avec la dureté décrite.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28fc8b33-1a6c-5e88-9c8f-57e07682634d', '38655883-4f78-5df4-b448-466ffb2dd3b2', '[SYNTAXE] Dans la phrase « ceux qui travaillaient sous ses ordres en parlaient à voix basse », quelle est la fonction de la proposition « qui travaillaient sous ses ordres » ?', '[{"id":"a","text":"Subordonnée relative, complément de l''antécédent « ceux »."},{"id":"b","text":"Subordonnée complétive, COD de « parlaient »."},{"id":"c","text":"Subordonnée circonstancielle de temps."},{"id":"d","text":"Proposition principale."}]'::jsonb, 'a', 'Le pronom relatif « qui » reprend l''antécédent « ceux » et introduit une relative qui le détermine (de qui parle-t-on ? de ceux qui travaillaient sous ses ordres). Une complétive (b) serait introduite par « que » conjonction et compléterait un verbe. Il n''y a pas de valeur temporelle (c), et la principale est « ceux… en parlaient à voix basse » (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('966c30fa-0738-5b10-8f72-7d212cdac238', '38655883-4f78-5df4-b448-466ffb2dd3b2', '[GRAMMAIRE] Quelle réécriture conserve un accord parfaitement correct ?', '[{"id":"a","text":"La courtoisie qu''il avait affichée toute la journée tomba d''un coup."},{"id":"b","text":"La courtoisie qu''il avait affiché toute la journée tomba d''un coup."},{"id":"c","text":"La courtoisie qu''il avait affichés toute la journée tomba d''un coup."},{"id":"d","text":"La courtoisie qu''il avaient affichée toute la journée tomba d''un coup."}]'::jsonb, 'a', 'Avec « avoir », le participe passé s''accorde avec le COD antéposé : ici « qu'' » mis pour « la courtoisie » (féminin singulier), placé avant « avait affichée » → « affichée ». (b) néglige l''accord. (c) met un pluriel injustifié. (d) commet en outre une faute d''accord sujet-verbe (« il avaient »).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b39f3841-74ef-53de-8648-ee43d15429b8', '38655883-4f78-5df4-b448-466ffb2dd3b2', '[LEXIQUE — paronymes] Pour qualifier la fausse cordialité du personnage, on pourrait dire qu''il faisait preuve de « ______ ». Choisissez le mot juste, sans le confondre avec son paronyme.', '[{"id":"a","text":"dissimulation"},{"id":"b","text":"dissipation"},{"id":"c","text":"dissertation"},{"id":"d","text":"dissension"}]'::jsonb, 'a', '« Dissimulation » désigne l''action de cacher ses véritables sentiments ou intentions — exactement le « masque » décrit dans le texte. « Dissipation » (b) évoque le fait de gaspiller, ou un manque de concentration. « Dissertation » (c) est un exercice écrit. « Dissension » (d) désigne un désaccord profond entre personnes. Seul (a) convient au sens visé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e09901c-fd3c-5a9c-9544-0216fdde2ac8', '38655883-4f78-5df4-b448-466ffb2dd3b2', '[GRAMMAIRE — concordance] Complétez en respectant la concordance des temps : « Ses subordonnés affirmaient que, dès que la porte ______, l''homme changeait de visage. »', '[{"id":"a","text":"se referme"},{"id":"b","text":"se refermait"},{"id":"c","text":"se refermera"},{"id":"d","text":"se soit refermée"}]'::jsonb, 'b', 'La principale est au passé (« affirmaient ») et décrit une habitude passée (« changeait de visage ») : la subordonnée temporelle, qui exprime une action concomitante et répétée dans ce cadre passé, prend l''imparfait, « se refermait ». Le présent (a) et le futur (c) rompent la concordance avec un récit au passé. Le subjonctif (d) n''est pas commandé par « dès que », qui régit l''indicatif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6419b53e-71ab-5c5e-9801-72544a707d1a', '2567b64f-bd7c-5121-8690-413031a1ac80', 'fr-mastery', 'Palier 2 — Épreuve de synthèse : la rumeur (Boss)', 3, 120, 25, 'boss', 'admin', 2)
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
  ('4f70f10b-563d-576a-8424-b798ff3c453f', '6419b53e-71ab-5c5e-9801-72544a707d1a', '[LEXIQUE — sens précis] Dans le texte, le verbe « colporter » signifie :', '[{"id":"a","text":"Démentir publiquement une fausse nouvelle."},{"id":"b","text":"Répandre, propager de bouche à oreille une nouvelle, souvent une rumeur."},{"id":"c","text":"Vérifier l''exactitude d''une information avant de la diffuser."},{"id":"d","text":"Garder une information pour soi par discrétion."}]'::jsonb, 'b', '« Colporter » (étymologiquement « porter à son cou », comme le marchand ambulant) signifie répandre, propager une nouvelle de proche en proche — péjoratif quand il s''agit d''une rumeur. Le contexte (« tous l''ont colportée ») confirme l''idée de diffusion. (a), (c) et (d) décrivent des comportements inverses (démentir, vérifier, taire).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('759d6691-82c9-58b7-b4a1-8528cea9c6ce', '6419b53e-71ab-5c5e-9801-72544a707d1a', 'Lisez ce texte, support de toute l''épreuve :

« La rumeur ne marche jamais seule : elle avance escortée de tous ceux qui jurent ne pas y croire et qui, pourtant, la répètent. Chacun la transmet en l''allégeant de sa propre responsabilité — « on dit que… », « il paraît que… » —, si bien qu''à la fin nul ne l''a affirmée et que tous l''ont colportée. C''est là sa ruse : naître de personne pour s''imposer à tous. »

[COMPRÉHENSION — implicite] Quelle idée l''auteur défend-il à travers ce texte ?', '[{"id":"a","text":"La rumeur se propage précisément parce que chacun s''en croit irresponsable tout en la diffusant."},{"id":"b","text":"La rumeur ne circule que parmi ceux qui y croient sincèrement."},{"id":"c","text":"La rumeur disparaît dès que personne ne veut l''affirmer."},{"id":"d","text":"La rumeur est toujours fondée sur des faits vérifiables."}]'::jsonb, 'a', 'Le paradoxe central — « nul ne l''a affirmée et tous l''ont colportée » — montre que la diffusion repose sur la déresponsabilisation de chacun (« en l''allégeant de sa propre responsabilité »). (b) est contredit par « ceux qui jurent ne pas y croire et qui la répètent ». (c) inverse la thèse : c''est justement que personne ne l''assume qu''elle prospère. (d) n''a aucun appui dans le texte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bebb8ff8-4c6c-58af-864a-e214786fe43e', '6419b53e-71ab-5c5e-9801-72544a707d1a', '[SYNTAXE — ponctuation et structure] Dans la phrase « C''est là sa ruse : naître de personne pour s''imposer à tous », quelle est la valeur des deux-points ?', '[{"id":"a","text":"Ils annoncent une explication : ce qui suit définit en quoi consiste « sa ruse »."},{"id":"b","text":"Ils introduisent une citation rapportée au discours direct."},{"id":"c","text":"Ils marquent une simple énumération de plusieurs éléments."},{"id":"d","text":"Ils signalent une opposition entre deux propositions contraires."}]'::jsonb, 'a', 'Les deux-points introduisent ici une explicitation : après avoir nommé « sa ruse », l''auteur précise en quoi elle consiste (« naître de personne pour s''imposer à tous »). Ce n''est pas une citation (b) — il n''y a ni guillemets ni verbe de parole —, ni une énumération (c), ni une opposition (d), qui appellerait plutôt « mais » ou un point-virgule entre deux idées contraires.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29709e99-70e0-597e-b8e5-c5efe47be0b5', '6419b53e-71ab-5c5e-9801-72544a707d1a', '[LEXIQUE — paronymes] Pour désigner la personne qui propage une rumeur, on emploiera le mot juste. Lequel, sans le confondre avec son paronyme ?', '[{"id":"a","text":"un délateur"},{"id":"b","text":"un détracteur"},{"id":"c","text":"un colporteur"},{"id":"d","text":"un correcteur"}]'::jsonb, 'c', '« Colporteur » (de rumeurs) désigne celui qui les répand, en cohérence avec le verbe « colporter » du texte. « Délateur » (a) dénonce quelqu''un aux autorités. « Détracteur » (b) critique et cherche à rabaisser une personne ou une œuvre. « Correcteur » (d) corrige des fautes. Seul « colporteur » nomme l''agent de la propagation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('388e036e-cd33-5c4e-9d91-4d1600e416ad', '6419b53e-71ab-5c5e-9801-72544a707d1a', '[GRAMMAIRE — mode] Réécrivons l''idée du texte : « Il est étonnant que personne n''______ jamais cette rumeur et que tous la répandent. » Quelle forme verbale convient ?', '[{"id":"a","text":"affirme"},{"id":"b","text":"affirmera"},{"id":"c","text":"a affirmé"},{"id":"d","text":"affirmait"}]'::jsonb, 'a', 'La tournure « Il est étonnant que… » exprime un sentiment et commande le subjonctif : on écrit « n''affirme » (subjonctif présent), en parallèle avec « que tous la répandent », lui aussi au subjonctif. Le futur (b), le passé composé de l''indicatif (c) et l''imparfait de l''indicatif (d) ne sont pas régis par cette construction expressive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5511b2b-1054-5205-bebc-e62e6ba38318', '6419b53e-71ab-5c5e-9801-72544a707d1a', '[SYNTAXE + COMPRÉHENSION] La proposition « si bien qu''à la fin nul ne l''a affirmée et que tous l''ont colportée » est une subordonnée. Quelle est sa valeur logique, et que souligne-t-elle dans l''argumentation ?', '[{"id":"a","text":"Valeur de conséquence : elle expose le résultat du mécanisme décrit (la déresponsabilisation aboutit à une diffusion anonyme)."},{"id":"b","text":"Valeur de cause : elle indique pourquoi la rumeur existe."},{"id":"c","text":"Valeur de but : elle exprime l''objectif visé par les locuteurs."},{"id":"d","text":"Valeur de condition : elle pose une hypothèse non réalisée."}]'::jsonb, 'a', 'La locution « si bien que » introduit une subordonnée circonstancielle de conséquence : elle énonce le résultat du processus décrit juste avant (chacun allège sa responsabilité). Elle souligne ainsi le paradoxe — diffusion maximale, responsabilité nulle. Ce n''est pas une cause (b : on dirait « parce que »), ni un but (c : « afin que »), ni une condition (d : « si »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('29169835-f5bb-546d-b09a-54a5fc7e260f', '2567b64f-bd7c-5121-8690-413031a1ac80', 'fr-mastery', '🔥 Palier 3 — Épreuve de synthèse : l''éloge ambigu (Défi)', 4, 300, 60, 'challenge', 'admin', 3)
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
  ('095ee978-daef-52a9-ac8d-046d80c81024', '29169835-f5bb-546d-b09a-54a5fc7e260f', '[LEXIQUE — paronyme/nuance] Dans le texte, le mot « pusillanime » signifie :', '[{"id":"a","text":"Magnanime, d''une grandeur d''âme généreuse."},{"id":"b","text":"Qui manque de courage, craintif devant le risque et la décision."},{"id":"c","text":"Méticuleux et soucieux du détail."},{"id":"d","text":"Versatile, qui change sans cesse d''avis."}]'::jsonb, 'b', '« Pusillanime » (du latin pusillus animus, « âme petite ») qualifie celui qui manque de courage et de fermeté, qui recule devant le risque. Le contexte (« peur déguisée en sagesse », « jamais il ne s''engageait qu''à demi ») l''impose. « Magnanime » (a) en est presque l''antonyme moral. (c) et (d) décrivent d''autres défauts (minutie, inconstance) sans rapport avec l''absence de courage.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af7c8f70-d1a9-50c6-a081-1efc1c20792b', '29169835-f5bb-546d-b09a-54a5fc7e260f', 'Lisez ce texte exigeant, support de toute l''épreuve :

« On le disait prudent ; il n''était que pusillanime. Cette prudence dont on le créditait, et qu''il revendiquait volontiers, n''était qu''une peur déguisée en sagesse. Jamais il n''avançait sans s''être ménagé une retraite ; jamais il ne s''engageait qu''à demi, de sorte qu''on ne pût lui reprocher ni l''échec, dont il se lavait par avance, ni le succès, qu''il n''avait jamais vraiment risqué. Eût-il osé une seule fois, on l''eût peut-être admiré ; il préféra qu''on l''estimât, ce qui coûte moins. »

[COMPRÉHENSION — implicite/ironie] Quelle est la thèse réelle de l''auteur sur ce personnage ?', '[{"id":"a","text":"L''auteur célèbre une prudence exemplaire qui a préservé le personnage de tout échec."},{"id":"b","text":"Sous couvert de prudence, le personnage dissimule une lâcheté calculée qui lui épargne tout risque."},{"id":"c","text":"Le personnage est un audacieux que la rumeur a injustement diminué."},{"id":"d","text":"L''auteur reste neutre et se contente de décrire un tempérament mesuré."}]'::jsonb, 'b', 'Dès la première phrase, l''antithèse « prudent / pusillanime » dévoile la critique, confirmée par « une peur déguisée en sagesse » et par le calcul décrit (ni échec ni succès, jamais rien risqué). (a) prend l''éloge apparent au pied de la lettre. (c) inverse le portrait : le texte nie toute audace (« jamais… qu''à demi »). (d) ignore l''ironie mordante et le jugement explicite de l''auteur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1d2bc86-bf86-527b-8ddf-69e22c4356e2', '29169835-f5bb-546d-b09a-54a5fc7e260f', '[GRAMMAIRE — mode/temps soutenu] Dans « Eût-il osé une seule fois, on l''eût peut-être admiré », comment analyse-t-on les deux formes en « eût » ?', '[{"id":"a","text":"Ce sont deux conditionnels passés (2e forme) exprimant une hypothèse non réalisée dans le passé ; « Eût-il osé » équivaut à « S''il avait osé »."},{"id":"b","text":"Ce sont deux subjonctifs présents marquant un souhait."},{"id":"c","text":"Ce sont deux passés simples de l''indicatif énonçant des faits avérés."},{"id":"d","text":"Ce sont deux futurs antérieurs annonçant des événements certains."}]'::jsonb, 'a', '« Eût osé » et « eût admiré » sont des conditionnels passés deuxième forme (homonymes du plus-que-parfait du subjonctif), tournure soutenue de l''irréel du passé. L''inversion « Eût-il osé » remplace « S''il avait osé » et pose une hypothèse contraire aux faits (il n''a jamais osé). Ce ne sont ni des subjonctifs de souhait (b), ni des passés simples de faits réels (c) — le texte dit l''inverse —, ni des futurs antérieurs (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff3d65f3-a07b-5787-8931-694b37d358e9', '29169835-f5bb-546d-b09a-54a5fc7e260f', '[SYNTAXE — subordination et logique] La proposition « de sorte qu''on ne pût lui reprocher ni l''échec… ni le succès… » : quelle est sa valeur, et qu''apporte le mode du verbe « pût » ?', '[{"id":"a","text":"Conséquence visée : le subjonctif « pût » marque que ce résultat était recherché, presque un but que le personnage s''assignait."},{"id":"b","text":"Cause réelle : le subjonctif indique un fait certain et accompli."},{"id":"c","text":"Comparaison : la subordonnée met deux situations en parallèle."},{"id":"d","text":"Temps : la subordonnée situe l''action dans la durée."}]'::jsonb, 'a', '« De sorte que » suivi du subjonctif (« pût ») exprime une conséquence voulue, teintée de finalité : le personnage agissait à demi afin qu''on ne pût rien lui reprocher. Le subjonctif souligne précisément ce caractère recherché (par opposition à « de sorte qu''on ne pouvait », indicatif, qui signalerait une simple conséquence de fait). Il ne s''agit ni d''une cause (b), ni d''une comparaison (c), ni d''une circonstancielle de temps (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4021c34-6085-5253-a2df-13d29fdee570', '29169835-f5bb-546d-b09a-54a5fc7e260f', '[GRAMMAIRE — accord du participe passé] Choisissez la phrase dont l''accord est rigoureusement correct.', '[{"id":"a","text":"Les retraites qu''il s''était toujours ménagées le protégeaient de tout reproche."},{"id":"b","text":"Les retraites qu''il s''était toujours ménagé le protégeaient de tout reproche."},{"id":"c","text":"Les retraites qu''il s''était toujours ménagés le protégeaient de tout reproche."},{"id":"d","text":"Les retraites qu''il s''était toujours ménager le protégeaient de tout reproche."}]'::jsonb, 'a', 'Avec un verbe pronominal comme « se ménager », le participe passé s''accorde avec le COD s''il précède le verbe. Ici « se » est COI (ménager quelque chose à soi) et le COD est « qu'' », mis pour « les retraites » (féminin pluriel), antéposé → « ménagées ». (b) et (c) faussent le genre ou le nombre de l''accord. (d) emploie un infinitif à la place du participe : faute majeure.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd984a6b-8d79-5b8b-9bcb-e48edf379300', '29169835-f5bb-546d-b09a-54a5fc7e260f', '[LEXIQUE + COMPRÉHENSION] La chute « il préféra qu''on l''estimât, ce qui coûte moins » repose sur une distinction fine entre « admirer » et « estimer ». Quelle interprétation est la plus juste ?', '[{"id":"a","text":"« Admirer » suppose l''éclat d''un acte risqué, tandis qu''« estimer » se contente d''un mérite tranquille ; le personnage choisit la reconnaissance la moins exigeante."},{"id":"b","text":"« Admirer » et « estimer » sont strictement synonymes ; la phrase ne fait que les répéter."},{"id":"c","text":"« Estimer » implique plus d''enthousiasme qu''« admirer » ; le personnage vise donc le sentiment le plus fort."},{"id":"d","text":"« Estimer » signifie ici « évaluer une quantité » ; la phrase porte sur un calcul chiffré."}]'::jsonb, 'a', 'L''admiration naît d''un éclat, d''un exploit qui force l''enthousiasme ; l''estime, plus mesurée, reconnaît un mérite sans transport. La chute ironique (« ce qui coûte moins ») confirme que le personnage préfère cette reconnaissance modeste, qui n''exige aucun risque. (b) nie une nuance que le texte exploite précisément. (c) intervertit l''intensité des deux termes. (d) confond le sens moral d''« estimer » avec son sens d''évaluation quantitative, hors contexte ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

