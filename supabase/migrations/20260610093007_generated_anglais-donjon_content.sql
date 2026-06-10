-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-donjon (Anglais — Donjon (tout le thème))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-donjon/
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
  ('anglais-donjon', 'Anglais — Donjon (tout le thème)', 'The English Gauntlet: a mixed challenge where every question comes from a different strand — grammar, vocabulary, reading, spelling — climbing from easy to elite. Test the whole language at once, not just one chapter.', 'Polyvalence', 'subject-english', 'Swords', 9, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-donjon'
      AND e.source = 'admin'
      AND q.id NOT IN ('ba906a31-7a45-59ab-8ff7-772704dec110', '30bce9d3-1707-52b7-95ad-287271987f56', 'a6a7cd9b-f60d-5b73-aa7e-2b240ca68fdb', '0b44b887-c29f-5439-a207-436abe18f062', '0d0dac16-6cad-5e51-a55c-81022aef2e7f', '4b280be3-3f34-5c19-95b8-f59252504bd7', 'be139b80-7580-5bd6-860d-4e161113c11b', 'd416661a-e85c-5a8e-9762-d8ad90c1b005', 'b5ae6c61-8f2c-55b6-a264-105387395a5c', '93b07ded-86c0-57b2-bc36-79f1df9297e6', 'c6c804d3-5bb4-55ba-8050-ced151076007', 'd4f9f123-8958-5a0b-b5ef-dc984f751769', 'af6f3259-f18f-5800-9d91-76c77b5b9716', 'fd8da27a-dce8-5adb-93ec-4f0ebc14d563', '49a10031-9a73-5deb-b003-ca2c122aa1be', 'de1f1f74-b5e6-51a3-816f-4eae7524e380', '379e487e-550b-5153-9476-832883aa9c6a', '3d4a8d9f-f787-5721-80d0-a7417f53b6f6', '25945e86-4411-5059-a96e-64065bbd2631', 'fd3a7ed3-3fc8-50c4-a770-ae1a9cf8964d', '6a3b40b9-6533-5c7a-9dd8-7d50ad3347f8', '9feae4fe-1931-51a8-a81a-19fdb0107ece', '1017f94d-0a74-56ce-a038-27db95459e51', 'b8854449-dfaf-5884-ae50-748cc2ca4ce7', '4045dd96-d531-5fc2-b60a-b0c81ead6640', '456a8a78-00ce-5ec9-a4aa-a2bdcfb66066', '94d35856-7f59-5838-bfae-b300b41bfe6c', 'cc67e3e3-776a-5c79-b592-e7885616e636', 'e10af6dc-8b76-5dbf-9fda-31c7dc81ab14', 'fcba8d94-0a5b-5675-a05f-134dab76dcfd', '3fd6a582-42fe-56d8-a9a5-8f0453565cc6', '5a19ce6e-44b7-5b44-84c4-70086c841584', '30aaecf9-d5a9-5515-9565-5eade9a990dd', 'deb2d0e6-638f-5362-a00c-592c72f75f3e', '9ffbae32-455d-5620-b30e-210f217f240d', 'cf099e79-fba7-5832-b484-acfcb3094e59', '84dd849c-f5f7-56a9-87a8-6bf27982b393', '89b12fff-740e-54f2-88e8-100a500354f2', '4054d66b-a984-59b3-b10c-6aad8e6f64bc', 'ace366dc-2fca-5c26-a061-3eac12cbfdce', '0dd8f34e-b3de-5cc6-ac9a-91fdad7e2131', 'a2e01a6c-d449-59bd-b089-a974205fbb09', 'b38b70eb-7f13-5b7a-b4d2-cfe60c4d278b', '391494ec-2225-548e-baa9-cfefa0f3d473', 'f688da08-7b8e-563f-aa96-08929c36fe04', '2dc6a633-b197-5ca5-a17f-6d497dbfa8da', '2b43508d-291e-587b-aa57-d359f8653093', '2f1cf64b-c744-5acf-911e-3c32c2b7e851', 'feaf3563-3abe-5395-b244-3e880ec79df8', '93bfba0b-b84e-5a2c-93fe-08a9055b04b0', '27d3bdd0-d5b2-53f1-b433-2110058bdc89', '644a8500-026c-5933-8686-11915e185e57', '20083635-85e1-5bf9-9ceb-3fb001d288c9', 'f3485792-24b3-59fa-be2a-7c5246e9b53f', '0f320f6f-b28d-56a9-8277-c01e618d4a34', '9f14f7ec-3e0b-50e3-af2d-176eaa9a3ced', '0c98ec9e-bf30-5942-9a0a-de4c43ea858b', '4d0b4f5f-9fd3-5242-9f1a-0a295edd87ea', '315c2129-e18c-5618-b783-d3befb72b319', 'be963e07-2c4e-50c4-9523-33d4dd3877a9', '030a1f57-a9c6-5b83-bd90-dde2ccc10efa', '624f39c3-31a4-5b2a-86f8-dfabfd05bc92', '8f402bb1-d0ea-5b17-a1ae-8546063df794', '04a07c4f-9182-593f-abc9-745311969be3', '01e99d6b-2648-56a4-a69b-5149e18a61a1', '8c5bdd7a-c6bf-5b9b-a482-1c2ba61aba94', 'e976e35f-7fd3-5b2c-9581-86dc41a59f26', 'c54e7d72-8852-5ac4-95c1-8498373a6509', '147d8224-0891-5ac2-a017-7bad399412c1', '2e505b1f-9d16-5b27-a959-6a584d42345f', '4e501524-914c-5567-b7b7-716f575dcc38', 'a62ac825-e95d-594f-9f73-339f0f152530', '576113c2-8990-5f99-8920-7dfe0f5e9798', 'c22de34c-acaa-595e-9f69-c6713c808e55', '8dfcb72a-70dc-5609-ac68-aae097b099ae', '3a53c0d6-d02d-5abd-929d-8c13cae3d02a', 'e275588a-04c6-5945-bcaa-e30fad0bdc2b', '4e80bebe-a948-5f60-addf-a7964150f11e', '98c98d95-8646-5a2b-9324-7971f72aa5db', '55463583-d0fb-5eb9-a775-b259094ec76b', '29d002ba-7118-5565-b210-9030f2648028', '2cba1ba7-af16-5d87-b768-affe2783e7bf', '68fc82c4-b675-5ddc-8326-7952e13a2a19', '19af87e0-dcf5-58b5-9861-544a725d24c9', '34eb0159-aead-52e8-a7b3-1b9273d5b564', '137d7a75-f95b-566a-bd55-779e463fd7ce', 'ddd14b29-f733-5239-bafb-9b71636483f5');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-donjon' AND source = 'admin' AND id NOT IN ('5b207218-401a-5ff5-aae6-4f38547dd5e8', 'ad976a04-473a-5f6d-9899-3f29605d8a30', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', '764099d1-17f2-525c-94bf-42d9c6a02b8c', '088a3348-6c2f-5c30-9f59-99e199212f46', 'ac1edda7-019a-5303-b405-2243e1707f2f', '921bba7a-96bc-5389-8a70-774129c4103c', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', '30d03a04-6201-59a0-a734-7750c0966a66', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', '67c32e3b-7c05-5912-a9f2-012814f7a41f');
DELETE FROM public.questions WHERE exercise_id IN ('5b207218-401a-5ff5-aae6-4f38547dd5e8', 'ad976a04-473a-5f6d-9899-3f29605d8a30', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', '764099d1-17f2-525c-94bf-42d9c6a02b8c', '088a3348-6c2f-5c30-9f59-99e199212f46', 'ac1edda7-019a-5303-b405-2243e1707f2f', '921bba7a-96bc-5389-8a70-774129c4103c', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', '30d03a04-6201-59a0-a734-7750c0966a66', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', '67c32e3b-7c05-5912-a9f2-012814f7a41f') AND id NOT IN ('ba906a31-7a45-59ab-8ff7-772704dec110', '30bce9d3-1707-52b7-95ad-287271987f56', 'a6a7cd9b-f60d-5b73-aa7e-2b240ca68fdb', '0b44b887-c29f-5439-a207-436abe18f062', '0d0dac16-6cad-5e51-a55c-81022aef2e7f', '4b280be3-3f34-5c19-95b8-f59252504bd7', 'be139b80-7580-5bd6-860d-4e161113c11b', 'd416661a-e85c-5a8e-9762-d8ad90c1b005', 'b5ae6c61-8f2c-55b6-a264-105387395a5c', '93b07ded-86c0-57b2-bc36-79f1df9297e6', 'c6c804d3-5bb4-55ba-8050-ced151076007', 'd4f9f123-8958-5a0b-b5ef-dc984f751769', 'af6f3259-f18f-5800-9d91-76c77b5b9716', 'fd8da27a-dce8-5adb-93ec-4f0ebc14d563', '49a10031-9a73-5deb-b003-ca2c122aa1be', 'de1f1f74-b5e6-51a3-816f-4eae7524e380', '379e487e-550b-5153-9476-832883aa9c6a', '3d4a8d9f-f787-5721-80d0-a7417f53b6f6', '25945e86-4411-5059-a96e-64065bbd2631', 'fd3a7ed3-3fc8-50c4-a770-ae1a9cf8964d', '6a3b40b9-6533-5c7a-9dd8-7d50ad3347f8', '9feae4fe-1931-51a8-a81a-19fdb0107ece', '1017f94d-0a74-56ce-a038-27db95459e51', 'b8854449-dfaf-5884-ae50-748cc2ca4ce7', '4045dd96-d531-5fc2-b60a-b0c81ead6640', '456a8a78-00ce-5ec9-a4aa-a2bdcfb66066', '94d35856-7f59-5838-bfae-b300b41bfe6c', 'cc67e3e3-776a-5c79-b592-e7885616e636', 'e10af6dc-8b76-5dbf-9fda-31c7dc81ab14', 'fcba8d94-0a5b-5675-a05f-134dab76dcfd', '3fd6a582-42fe-56d8-a9a5-8f0453565cc6', '5a19ce6e-44b7-5b44-84c4-70086c841584', '30aaecf9-d5a9-5515-9565-5eade9a990dd', 'deb2d0e6-638f-5362-a00c-592c72f75f3e', '9ffbae32-455d-5620-b30e-210f217f240d', 'cf099e79-fba7-5832-b484-acfcb3094e59', '84dd849c-f5f7-56a9-87a8-6bf27982b393', '89b12fff-740e-54f2-88e8-100a500354f2', '4054d66b-a984-59b3-b10c-6aad8e6f64bc', 'ace366dc-2fca-5c26-a061-3eac12cbfdce', '0dd8f34e-b3de-5cc6-ac9a-91fdad7e2131', 'a2e01a6c-d449-59bd-b089-a974205fbb09', 'b38b70eb-7f13-5b7a-b4d2-cfe60c4d278b', '391494ec-2225-548e-baa9-cfefa0f3d473', 'f688da08-7b8e-563f-aa96-08929c36fe04', '2dc6a633-b197-5ca5-a17f-6d497dbfa8da', '2b43508d-291e-587b-aa57-d359f8653093', '2f1cf64b-c744-5acf-911e-3c32c2b7e851', 'feaf3563-3abe-5395-b244-3e880ec79df8', '93bfba0b-b84e-5a2c-93fe-08a9055b04b0', '27d3bdd0-d5b2-53f1-b433-2110058bdc89', '644a8500-026c-5933-8686-11915e185e57', '20083635-85e1-5bf9-9ceb-3fb001d288c9', 'f3485792-24b3-59fa-be2a-7c5246e9b53f', '0f320f6f-b28d-56a9-8277-c01e618d4a34', '9f14f7ec-3e0b-50e3-af2d-176eaa9a3ced', '0c98ec9e-bf30-5942-9a0a-de4c43ea858b', '4d0b4f5f-9fd3-5242-9f1a-0a295edd87ea', '315c2129-e18c-5618-b783-d3befb72b319', 'be963e07-2c4e-50c4-9523-33d4dd3877a9', '030a1f57-a9c6-5b83-bd90-dde2ccc10efa', '624f39c3-31a4-5b2a-86f8-dfabfd05bc92', '8f402bb1-d0ea-5b17-a1ae-8546063df794', '04a07c4f-9182-593f-abc9-745311969be3', '01e99d6b-2648-56a4-a69b-5149e18a61a1', '8c5bdd7a-c6bf-5b9b-a482-1c2ba61aba94', 'e976e35f-7fd3-5b2c-9581-86dc41a59f26', 'c54e7d72-8852-5ac4-95c1-8498373a6509', '147d8224-0891-5ac2-a017-7bad399412c1', '2e505b1f-9d16-5b27-a959-6a584d42345f', '4e501524-914c-5567-b7b7-716f575dcc38', 'a62ac825-e95d-594f-9f73-339f0f152530', '576113c2-8990-5f99-8920-7dfe0f5e9798', 'c22de34c-acaa-595e-9f69-c6713c808e55', '8dfcb72a-70dc-5609-ac68-aae097b099ae', '3a53c0d6-d02d-5abd-929d-8c13cae3d02a', 'e275588a-04c6-5945-bcaa-e30fad0bdc2b', '4e80bebe-a948-5f60-addf-a7964150f11e', '98c98d95-8646-5a2b-9324-7971f72aa5db', '55463583-d0fb-5eb9-a775-b259094ec76b', '29d002ba-7118-5565-b210-9030f2648028', '2cba1ba7-af16-5d87-b768-affe2783e7bf', '68fc82c4-b675-5ddc-8326-7952e13a2a19', '19af87e0-dcf5-58b5-9861-544a725d24c9', '34eb0159-aead-52e8-a7b3-1b9273d5b564', '137d7a75-f95b-566a-bd55-779e463fd7ce', 'ddd14b29-f733-5239-bafb-9b71636483f5');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-donjon' AND c.id NOT IN ('fb713601-2e53-5225-b1e4-6b02471bee44', '9a5c79f6-867a-54ee-8649-f2559d061b06', '507347df-f038-5b3e-9f5a-2f5f94adaaae') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', 'The English Gauntlet', 'A mixed whole-language challenge where every question strikes from a different strand — grammar, vocabulary, reading or spelling — climbing from a gentle warm-up to a final elite trial.', '# ⚔️ The English Gauntlet — Every Skill, One Dungeon

> 💡 «The hero who masters one room is strong; the hero who masters every room is unstoppable.»

Welcome, challenger. This is no quiet single-lesson chapter. The Gauntlet is a **mixed dungeon** that throws the *whole language* at you at once. One room tests a verb, the next a word, the next a tiny story, the next a spelling — and you never know which door opens next. Your only armour is a broad, solid command of everything you learned across A1.

## 🏰 The rule of the Gauntlet

Each battle **interleaves four strands**. You jump from a *to be* form to an odd-one-out word, from a short passage to a tricky plural, with no warning. That is the whole point: real English is not sorted by topic. To survive here you must be **versatile** — ready for anything, in any order.

Every prompt is **tagged** with the strand it comes from, so you always know which weapon to draw.

## 📜 The four strands (your doors)

| Door | Strand     | What to expect                                                        |
| ---- | ---------- | --------------------------------------------------------------------- |
| 🗡️   | Grammar    | pick the right form: *am / is / are*, present simple, *a / an / the*  |
| 💎   | Vocabulary | meaning, the **odd one out** of a set, the word that fits a sentence  |
| 📖   | Reading    | a 2–3 sentence story, then a question about a detail you must find    |
| ✒️   | Spelling   | the correct written form, above all tricky plurals (*cities, watches*) |

## 🗡️ Grammar — the backbone

These rooms drill the engine of A1. Choose the verb that matches its subject (*She **is**…*, *They **are**…*), put the present-simple **-s** only on *he / she / it* (*He **plays**…*), and slot in the right article — **a** before a consonant sound, **an** before a vowel sound, **the** for something already known.

## 💎 Vocabulary — your word bank

Here you prove your treasure of words. Spot the intruder in a themed set (*which is **not** a colour?*), match a word to its meaning, or pick the one word that completes a natural sentence. Distractors come from the *same family*, so read every option.

## 📖 Reading — find the detail

A short text appears, then one question. The answer is **always in the text** — do not guess from outside knowledge. Read the two or three lines, hold the facts in mind, and pick the option the passage actually supports.

## ✒️ Spelling — write it right

English plurals shift in predictable ways. A consonant **+ y** becomes **-ies** (*city → cities*), words ending **-ch / -sh / -s / -x** add **-es** (*watch → watches*), and some are simply irregular (*child → children*). These rooms reward the eye that catches the silent trap.

> 🗡️ Hero''s tip: before you answer, **name the strand** in the prompt. A Grammar trap and a Spelling trap are beaten by different rules — knowing which fight you are in is half the win.

> ⚠️ Classic trap: do **not** carry one room''s logic into the next. *Plays* is right in a Grammar room about *he*, but *citys* is never right in a Spelling room — each strand has its own law.

> 🏆 You now know the rules of the Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your English has no weak room.', '# 📜 Résumé: The English Gauntlet

- **Goal** — one mixed dungeon that tests the whole A1 language at once, not a single chapter.
- **Grammar** — match the verb to its subject (*am / is / are*, present-simple *-s*) and pick the right article (*a / an / the*).
- **Vocabulary** — meaning, the **odd one out** of a themed set, and the word that completes a sentence.
- **Reading** — read a short 2–3 sentence text, then answer using only what the text says.
- **Spelling** — write the correct form, above all tricky plurals (*city → cities*, *watch → watches*, *child → children*).
- **Method** — every prompt names its strand, so draw the matching rule; eliminate the look-alike trap, then choose.
- 🏆 Versatility wins: a hero who is ready in every room has no weak spot.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', 'The A2 Gauntlet', 'A mixed elementary-level challenge that blends the whole A2 band — past simple, present continuous, the future, comparatives and superlatives, and quantifiers — across the grammar, vocabulary, reading and spelling strands, climbing from a gentle warm-up to a final elite trial.', '# ⚔️ The A2 Gauntlet — The Whole Elementary Band, One Dungeon

> 💡 «A1 taught you to stand. A2 teaches you to move — through time, comparison, and quantity. Master every room, and nothing in this band can surprise you.»

Welcome back, challenger. You cleared the first Gauntlet; now the dungeon has grown. This is the **A2 Gauntlet** — a deeper, harder maze that throws the *whole elementary band* at you at once. One room asks you to send a verb into the **past**, the next catches an action **happening now**, the next leaps into the **future**, then a room weighs two things against each other, and another measures *how much* and *how many*. You never know which door opens next.

## 🏰 The rule of the Gauntlet

Each battle **interleaves four strands**. You jump from a past-tense form to a tricky -ing spelling, from a two-line story to a quantifier, with no warning. That is the whole point: real English never sorts itself by topic. To survive here you must be **versatile** — ready for any tense, any comparison, any spelling, in any order.

Every prompt is **tagged** with the strand it comes from, so you always know which weapon to draw: **Grammar —**, **Vocabulary —**, **Reading —**, or **Spelling —**.

## 🗡️ Grammar — the engine of A2

These rooms drill the machinery of the whole band. Choose the right past form — *was / were*, *did + base verb*, and the irregulars (*went*, *saw*, *bought*). Tell apart an action **happening now** (*she is cooking*) from a **habit** (*she cooks every day*). Pick the right future: **going to** for a plan or visible evidence, **will** for a decision made as you speak. Build comparisons — *-er … than* and *the …est* for short words, *more / the most* for long ones. And match quantifiers to their nouns — *some / any*, *much / many*, *a few / a little*.

## 💎 Vocabulary — your word bank

Here you prove your treasure of A2 words. Spot the **odd one out** of a themed set, match a word to its opposite, or pick the one word that completes a natural sentence. Distractors come from the *same family*, so read every option before you strike.

## 📖 Reading — find the detail

A short text appears — a little past-tense story or a scene happening right now — then one question. The answer is **always in the text**: do not guess from outside knowledge. Read the two or three lines, hold the facts in mind, sometimes combine them, and pick the option the passage actually supports.

## ✒️ Spelling — write it right

A2 spelling has its own traps. Past **-ed** forms shift: *study → studied*, *stop → stopped*, *arrive → arrived*. The **-ing** form shifts too: *run → running*, *make → making*, *lie → lying*. Comparatives and superlatives change spelling: *big → bigger*, *happy → happiest*. These rooms reward the eye that catches the silent trap.

> 🗡️ Hero''s tip: before you answer, **name the strand and the rule**. A past-tense trap, a now-vs-habit trap, and a comparison trap are each beaten by a *different* law — knowing which fight you are in is half the win.

> ⚠️ Classic trap: do **not** carry one room''s logic into the next. *Faster* is right when you compare two things, but never *more faster*; *going to* fits a plan, but a decision made on the spot wants *will*. Each strand, and each tense, has its own rule.

> 🏆 You now know the rules of the A2 Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your elementary English has no weak room.', '# 📜 Résumé: The A2 Gauntlet

- **Goal** — one mixed dungeon that tests the whole A2 band at once, not a single chapter.
- **Grammar** — past simple (*was/were*, *did + base*, irregulars), present continuous vs simple (now vs habit), the future (*going to* for plans/evidence, *will* for on-the-spot decisions), comparatives & superlatives, and quantifiers (*some/any*, *much/many*, *a few/a little*).
- **Vocabulary** — the **odd one out** of a themed set, opposites, and the word that completes a sentence.
- **Reading** — read a short past-tense story or a now-scene, then answer using only what the text says.
- **Spelling** — past **-ed** (*studied*, *stopped*), **-ing** (*running*, *making*, *lying*), and comparison forms (*bigger*, *happiest*).
- **Method** — every prompt names its strand, so draw the matching rule; eliminate the look-alike trap, then choose.
- 🏆 Versatility wins: a hero ready in every tense, comparison and quantity has no weak spot.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', 'The B1 Gauntlet', 'A mixed intermediate-level challenge that blends the whole B1 band — the present perfect, the past continuous, conditionals, modals of obligation and advice, and relative clauses — across the grammar, vocabulary, reading and spelling strands, climbing from a gentle warm-up to a final elite trial.', '# ⚔️ The B1 Gauntlet — The Whole Intermediate Band, One Dungeon

> 💡 «A1 taught you to stand, A2 taught you to move. B1 teaches you to connect — past to now, cause to effect, idea to idea. Master every room, and the intermediate gate is yours.»

Welcome back, challenger. You cleared the A1 and A2 Gauntlets; now the dungeon has grown a third time. This is the **B1 Gauntlet** — a deeper, harder maze that throws the *whole intermediate band* at you at once. One room ties a past action to **now**, the next sets a **scene** that an event suddenly cuts into, the next bends reality with an **if**, another hands you the **rules of the realm**, and the last welds two ideas into a single elegant sentence. You never know which door opens next.

## 🏰 The rule of the Gauntlet

Each battle **interleaves four strands**. You jump from a present-perfect form to a tricky participle spelling, from a two-line story to a relative pronoun, with no warning. That is the whole point: real English never sorts itself by topic. To survive here you must be **versatile** — ready for any tense, any structure, any spelling, in any order.

Every prompt is **tagged** with the strand it comes from, so you always know which weapon to draw: **Grammar —**, **Vocabulary —**, **Reading —**, or **Spelling —**.

## 🗡️ Grammar — the engine of B1

These rooms drill the machinery of the whole band. Tie a finished action to the present with the **present perfect** (*have / has* + participle, *for / since*, *been* vs *gone*), and never pair it with a finished-time word (*yesterday*). Set a scene with the **past continuous** (*was / were* + -ing) and let a **past simple** event interrupt it (*while* I **was cooking**, the phone **rang**). Reason with **conditionals** — *if* + present → *will* for the real future, *if* + past → *would* for the imaginary. Give orders with **modals**: *must / have to* (necessary), *mustn''t* (forbidden), *don''t have to* (optional), *should* (advice). And join ideas with **relative clauses** — *who* for people, *which* for things, *where* for places, *whose* for possession.

## 💎 Vocabulary — your word bank

Here you prove your treasure of B1 words. Spot the **odd one out** of a themed set, match a word to its opposite, complete a natural **collocation** (*make* a decision, *do* the housework), or pick the one word that finishes a sentence. Distractors come from the *same family*, so read every option before you strike.

## 📖 Reading — find the detail

A short text appears — a present-perfect life story, an interrupted past scene, or a clue-filled situation — then one question. The answer is **always in the text**: do not guess from outside knowledge. Read the two to four lines, hold the facts in mind, sometimes **infer** what they add up to, and pick the option the passage actually supports.

## ✒️ Spelling — write it right

B1 spelling has its own traps. **Past participles** can be irregular: *write → written*, *see → seen*, *do → done*, *eat → eaten*. The **-ing** form shifts: *run → running*, *make → making*, *lie → lying*, *sit → sitting*. And comparative or irregular forms bite: *good → better*, *big → bigger*. These rooms reward the eye that catches the silent trap.

> 🗡️ Hero''s tip: before you answer, **name the strand and the rule**. A present-perfect trap, a *while/when* trap and a *mustn''t* / *don''t have to* trap are each beaten by a *different* law — knowing which fight you are in is half the win.

> ⚠️ Classic trap: do **not** carry one room''s logic into the next. *Have seen* fits an experience, but *yesterday* forces *saw*; *if it rains, I will…* is real, but never *if it will rain*; *mustn''t* forbids, yet *don''t have to* frees. Each strand, and each structure, has its own rule.

> 🏆 You now know the rules of the B1 Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your intermediate English has no weak room.', '# 📜 Résumé: The B1 Gauntlet

- **Goal** — one mixed dungeon that tests the whole B1 band at once, not a single chapter.
- **Grammar** — present perfect (*have/has* + participle, *for/since*, *been/gone*), past continuous vs past simple (*while/when*), conditionals (zero/first/second, *will* vs *would*), modals (*must/have to*, *mustn''t*, *don''t have to*, *should*), and relative clauses (*who/which/that/where/whose*).
- **Vocabulary** — the **odd one out** of a themed set, opposites, collocations (*make a decision*, *do the housework*), and the word that completes a sentence.
- **Reading** — read a short story or clue-filled scene, then answer using only what the text says, inferring when needed.
- **Spelling** — irregular **past participles** (*written*, *seen*, *done*, *eaten*), **-ing** forms (*running*, *making*, *lying*), and comparison forms (*better*, *bigger*).
- **Method** — every prompt names its strand, so draw the matching rule; eliminate the look-alike trap, then choose.
- 🏆 Versatility wins: a hero ready in every tense, structure and spelling has no weak spot.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5b207218-401a-5ff5-aae6-4f38547dd5e8', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ba906a31-7a45-59ab-8ff7-772704dec110', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Grammar — Complete: "The children ___ in the garden."', '[{"id":"a","text":"is"},{"id":"b","text":"are"},{"id":"c","text":"am"},{"id":"d","text":"be"}]'::jsonb, 'b', 'Children is the plural of child, so it takes are: The children are in the garden. Is is only for a singular subject (the child is…), am is only for I, and be is the base form, not a present-tense form here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30bce9d3-1707-52b7-95ad-287271987f56', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"red"},{"id":"b","text":"blue"},{"id":"c","text":"apple"},{"id":"d","text":"green"}]'::jsonb, 'c', 'Red, blue and green are all colours, but apple is a food, so it is the odd one out. The intruder is grouped with the colours to test whether you sort words by meaning, not just recognise them.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6a7cd9b-f60d-5b73-aa7e-2b240ca68fdb', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Reading — Read: "Tom is a cook. He works in a restaurant. He makes pizza every day."
What is Tom''s job?', '[{"id":"a","text":"He is a cook."},{"id":"b","text":"He is a driver."},{"id":"c","text":"He is a teacher."},{"id":"d","text":"He is a doctor."}]'::jsonb, 'a', 'The text says directly "Tom is a cook", so that is his job. A reading answer must come from the text: driver, teacher and doctor are never mentioned, so they cannot be correct even though they are real jobs.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b44b887-c29f-5439-a207-436abe18f062', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Spelling — Choose the correctly spelled plural of "city".', '[{"id":"a","text":"citys"},{"id":"b","text":"cityes"},{"id":"c","text":"cityies"},{"id":"d","text":"cities"}]'::jsonb, 'd', 'A noun ending in consonant + y changes y to i and adds -es: city → cities. "Citys" forgets the rule, and "cityes"/"cityies" keep the y by mistake. Compare baby → babies, party → parties.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d0dac16-6cad-5e51-a55c-81022aef2e7f', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Grammar — Complete: "She ___ English at school."', '[{"id":"a","text":"study"},{"id":"b","text":"studys"},{"id":"c","text":"studies"},{"id":"d","text":"studying"}]'::jsonb, 'c', 'In the present simple, he/she/it adds -s, and a verb ending consonant + y changes to -ies: she studies. "Study" misses the third-person -s, "studys" breaks the y → ies spelling rule, and "studying" needs a form of be (she is studying).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ad976a04-473a-5f6d-9899-3f29605d8a30', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '⭐ Gauntlet: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4b280be3-3f34-5c19-95b8-f59252504bd7', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Grammar — Complete: "I ___ from Tunisia."', '[{"id":"a","text":"is"},{"id":"b","text":"are"},{"id":"c","text":"am"},{"id":"d","text":"be"}]'::jsonb, 'c', 'The subject I always takes am: I am from Tunisia. Is goes only with he/she/it, are with you/we/they, and be is the base form (used after to or a modal), not a present-tense form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be139b80-7580-5bd6-860d-4e161113c11b', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"mother"},{"id":"b","text":"sister"},{"id":"c","text":"brother"},{"id":"d","text":"table"}]'::jsonb, 'd', 'Mother, sister and brother are all family members, but table is an object, so it is the odd one out. The set tests whether you group words by meaning: a piece of furniture does not belong with the family.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d416661a-e85c-5a8e-9762-d8ad90c1b005', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Spelling — Choose the correctly spelled plural of "book".', '[{"id":"a","text":"bookes"},{"id":"b","text":"books"},{"id":"c","text":"bookies"},{"id":"d","text":"book''s"}]'::jsonb, 'b', 'Most nouns form the plural by simply adding -s: book → books. "Bookes" wrongly adds -es (that is only after -s, -x, -z, -ch, -sh), and "book''s" with an apostrophe shows possession, not a plural.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5ae6c61-8f2c-55b6-a264-105387395a5c', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Reading — Read: "This is Sara. She is nine years old. She is a student."
How old is Sara?', '[{"id":"a","text":"She is nine years old."},{"id":"b","text":"She is a student."},{"id":"c","text":"She is ten years old."},{"id":"d","text":"She is a teacher."}]'::jsonb, 'a', 'The text says "She is nine years old", so that is the answer. Read for the exact detail: (b) gives her job, not her age; (c) changes the number; and (d) contradicts the text, which calls her a student.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93b07ded-86c0-57b2-bc36-79f1df9297e6', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Grammar — Choose the correct article: "I have ___ apple."', '[{"id":"a","text":"the"},{"id":"b","text":"a"},{"id":"c","text":"an"},{"id":"d","text":"—  (no article)"}]'::jsonb, 'c', 'Apple begins with a vowel sound, so it takes an: an apple. Use a before a consonant sound (a book), and the for something already known. A singular countable noun like apple needs an article, so "no article" is wrong here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6c804d3-5bb4-55ba-8050-ced151076007', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Vocabulary — Which word means a place where you learn?', '[{"id":"a","text":"kitchen"},{"id":"b","text":"school"},{"id":"c","text":"garden"},{"id":"d","text":"hospital"}]'::jsonb, 'b', 'A school is the place where you learn. A kitchen is where you cook, a garden is where plants grow, and a hospital is where doctors help sick people — each is a real place, but only school matches "where you learn".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '⭐⭐ Gauntlet: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('d4f9f123-8958-5a0b-b5ef-dc984f751769', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Grammar — Complete: "My brother ___ football every weekend."', '[{"id":"a","text":"play"},{"id":"b","text":"are playing"},{"id":"c","text":"playing"},{"id":"d","text":"plays"}]'::jsonb, 'd', 'In the present simple, he/she/it adds -s: my brother plays football. "Play" misses the third-person -s, "playing" needs a form of be, and "are playing" uses are with a singular subject — it should be is, and the habit "every weekend" calls for the present simple anyway.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af6f3259-f18f-5800-9d91-76c77b5b9716', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Spelling — Choose the correctly spelled plural of "brush".', '[{"id":"a","text":"brushs"},{"id":"b","text":"brushies"},{"id":"c","text":"brushes"},{"id":"d","text":"brushs''"}]'::jsonb, 'c', 'Nouns ending in -sh add -es: brush → brushes (the -es makes the extra syllable easy to say). "Brushs" forgets the -es rule, "brushies" wrongly applies the y → ies pattern, and the apostrophe form shows possession, not a plural. Compare dish → dishes, glass → glasses.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd8da27a-dce8-5adb-93ec-4f0ebc14d563', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Vocabulary — Complete the collocation: "She bought a ___ of water at the shop."', '[{"id":"a","text":"bottle"},{"id":"b","text":"loaf"},{"id":"c","text":"slice"},{"id":"d","text":"bar"}]'::jsonb, 'a', 'Water you buy or carry comes in a bottle, so we say a bottle of water. A loaf and a slice go with bread (a loaf of bread), and a bar goes with chocolate or soap — none of those is a container for a drink you take from a shop.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49a10031-9a73-5deb-b003-ca2c122aa1be', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Reading — Read: "Ali and Omar are brothers. Ali likes red. Omar likes blue."
What colour does Omar like?', '[{"id":"a","text":"He likes red."},{"id":"b","text":"He likes blue."},{"id":"c","text":"He likes green."},{"id":"d","text":"They like the same colour."}]'::jsonb, 'b', 'The text says "Omar likes blue", so blue is the answer. Watch the trap in (a): red is Ali''s colour, not Omar''s. Green (c) is never mentioned, and (d) contradicts the text, which gives the brothers two different colours.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de1f1f74-b5e6-51a3-816f-4eae7524e380', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Grammar — Complete: "___ two windows in this room."', '[{"id":"a","text":"There is"},{"id":"b","text":"It is"},{"id":"c","text":"There be"},{"id":"d","text":"There are"}]'::jsonb, 'd', 'Two windows is plural, so use there are: There are two windows. There is is for one thing (there is a window), "there be" is not a finite form, and it is cannot introduce a plural like this.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('379e487e-550b-5153-9476-832883aa9c6a', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Spelling — Choose the correctly spelled plural of "person".', '[{"id":"a","text":"people"},{"id":"b","text":"persons"},{"id":"c","text":"peoples"},{"id":"d","text":"personies"}]'::jsonb, 'a', 'Person has an irregular plural: person → people (no -s rule applies in everyday English). "Persons" is only used in very formal or legal English; "peoples" doubles the plural (people is already plural, so it takes no final -s, except to mean separate nations); and "personies" invents an ending that does not exist.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '⚔️ Gauntlet Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('3d4a8d9f-f787-5721-80d0-a7417f53b6f6', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Grammar — Complete: "My sister ___ like coffee."', '[{"id":"a","text":"don''t"},{"id":"b","text":"doesn''t"},{"id":"c","text":"isn''t"},{"id":"d","text":"aren''t"}]'::jsonb, 'b', 'In the present simple, he/she/it makes the negative with doesn''t + base verb: My sister doesn''t like coffee. "Don''t" is for I/you/we/they; isn''t and aren''t belong to the verb to be, not to an ordinary verb like like.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25945e86-4411-5059-a96e-64065bbd2631', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Reading — Read: "Sami works in a school. He helps children learn to read, and every evening he marks their homework."
What is most likely Sami''s job?', '[{"id":"a","text":"He is a nurse."},{"id":"b","text":"He is a farmer."},{"id":"c","text":"He is a teacher."},{"id":"d","text":"He is a pilot."}]'::jsonb, 'c', 'The text never says "teacher", but working in a school, helping children learn to read and marking homework together point to a teacher — a supported inference. A nurse helps sick people, a farmer grows crops, and a pilot flies planes, so none of them matches the school clues.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd3a7ed3-3fc8-50c4-a770-ae1a9cf8964d', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Spelling — Find the INCORRECT plural.', '[{"id":"a","text":"boxes"},{"id":"b","text":"buses"},{"id":"c","text":"dishes"},{"id":"d","text":"babys"}]'::jsonb, 'd', 'The error is (d): a noun ending consonant + y changes to -ies, so it is babies, never "babys". The correct ones follow the -es rule after -x, -s and -sh: boxes, buses, dishes are all right.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a3b40b9-6533-5c7a-9dd8-7d50ad3347f8', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"Monday"},{"id":"b","text":"doctor"},{"id":"c","text":"teacher"},{"id":"d","text":"farmer"}]'::jsonb, 'a', 'Doctor, teacher and farmer are all jobs, but Monday is a day of the week, so it is the odd one out. The trap is that Monday looks at home among capitalised words, but it belongs to a different set — sort by meaning, not by appearance.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9feae4fe-1931-51a8-a81a-19fdb0107ece', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Grammar — Choose the correct article: "___ sun is very hot today."', '[{"id":"a","text":"A"},{"id":"b","text":"An"},{"id":"c","text":"—  (no article)"},{"id":"d","text":"The"}]'::jsonb, 'd', 'There is only one sun, so it is unique and takes the: The sun is very hot. We use a/an for one of many on first mention (a book), but a one-of-a-kind thing — the sun, the moon, the sky — always takes the.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1017f94d-0a74-56ce-a038-27db95459e51', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Spelling — Find the INCORRECT plural.', '[{"id":"a","text":"keys"},{"id":"b","text":"citys"},{"id":"c","text":"days"},{"id":"d","text":"boys"}]'::jsonb, 'b', 'The error is (b): city ends in consonant + y, so it becomes cities, not "citys". The correct ones end in vowel + y, which simply adds -s: keys, days, boys. The letter before the y decides the rule.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('764099d1-17f2-525c-94bf-42d9c6a02b8c', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '👑 Gauntlet Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b8854449-dfaf-5884-ae50-748cc2ca4ce7', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Reading — Read: "Nour has two cats and one dog. The cats are black. The dog is brown."
Which sentence is TRUE?', '[{"id":"a","text":"Nour has two dogs."},{"id":"b","text":"The dog is black."},{"id":"c","text":"Nour has three pets."},{"id":"d","text":"The cats are brown."}]'::jsonb, 'c', 'Two cats + one dog = three pets, so (c) is true. The others contradict the text: Nour has one dog, not two (a); the dog is brown, not black (b); and the cats are black, not brown (d). Combine the facts before choosing.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4045dd96-d531-5fc2-b60a-b0c81ead6640', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Grammar — Choose the fully correct sentence.', '[{"id":"a","text":"She watch a film every weekend."},{"id":"b","text":"She watches a film every weekend."},{"id":"c","text":"She watches a film every weekends."},{"id":"d","text":"She watch films every weekend."}]'::jsonb, 'b', 'With she, the present simple adds -es: she watches. We also say every weekend (singular after every), so (b) is fully correct. (a) and (d) drop the third-person -s, and (c) wrongly pluralizes after every — every is always followed by a singular noun.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('456a8a78-00ce-5ec9-a4aa-a2bdcfb66066', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Spelling — Find the INCORRECT plural.', '[{"id":"a","text":"mans"},{"id":"b","text":"feet"},{"id":"c","text":"teeth"},{"id":"d","text":"mice"}]'::jsonb, 'a', 'The error is (a): man has an irregular plural, men, never "mans". The others are also irregular and correct: foot → feet, tooth → teeth, mouse → mice. None of these common nouns takes a regular -s.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94d35856-7f59-5838-bfae-b300b41bfe6c', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Vocabulary — Choose the word that best completes the sentence: "This bag is cheap, but that phone is very ___."', '[{"id":"a","text":"small"},{"id":"b","text":"fast"},{"id":"c","text":"happy"},{"id":"d","text":"expensive"}]'::jsonb, 'd', '"But" signals a contrast with cheap, so the missing word is its opposite, expensive: cheap ↔ expensive. Small, fast and happy are real adjectives, but none is the opposite of cheap, so they break the contrast the sentence sets up.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc67e3e3-776a-5c79-b592-e7885616e636', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Grammar — Put the words in the correct order: (study / what / does / he)', '[{"id":"a","text":"What does he study?"},{"id":"b","text":"What he does study?"},{"id":"c","text":"What does he studies?"},{"id":"d","text":"What studies he?"}]'::jsonb, 'a', 'An ordinary-verb question is: question word + does + subject + base verb → What does he study? "What he does study" misplaces the subject, "studies" double-marks the -s (it lives on does, not the main verb), and "What studies he?" drops the helper does and keeps statement order.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e10af6dc-8b76-5dbf-9fda-31c7dc81ab14', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Spelling — Choose the correctly spelled plural of "shelf".', '[{"id":"a","text":"shelfs"},{"id":"b","text":"shelfes"},{"id":"c","text":"shelvs"},{"id":"d","text":"shelves"}]'::jsonb, 'd', 'Some nouns ending in -f or -fe change f to v and add -es: shelf → shelves (like wolf → wolves, half → halves). "Shelfs" and "shelfes" keep the f instead of switching to v, and "shelvs" changes to v but drops the needed -e before -s.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('088a3348-6c2f-5c30-9f59-99e199212f46', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('fcba8d94-0a5b-5675-a05f-134dab76dcfd', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Grammar — Complete the past simple: "We ___ a wonderful film at the cinema last Friday."', '[{"id":"a","text":"see"},{"id":"b","text":"saw"},{"id":"c","text":"seen"},{"id":"d","text":"seeing"}]'::jsonb, 'b', 'see is irregular: its past simple is saw, used here with the time marker "last Friday": We saw a wonderful film. "see" is the base/present, "seen" is the past participle (used after have), and "seeing" is the -ing form, which needs a form of be.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fd6a582-42fe-56d8-a9a5-8f0453565cc6', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Grammar — Now or habit? Complete: "Don''t disturb him — Dad ___ a phone call at the moment."', '[{"id":"a","text":"is making"},{"id":"b","text":"make"},{"id":"c","text":"makes"},{"id":"d","text":"are making"}]'::jsonb, 'a', '"at the moment" marks an action in progress, so use the present continuous; Dad = he, so the form is is making. "makes"/"make" are the present simple (for habits), and "are making" uses the plural be with a singular subject.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a19ce6e-44b7-5b44-84c4-70086c841584', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"summer"},{"id":"b","text":"winter"},{"id":"c","text":"autumn"},{"id":"d","text":"Tuesday"}]'::jsonb, 'd', 'Summer, winter and autumn are all seasons, but Tuesday is a day of the week, so it is the odd one out. Sort the set by meaning, not by the fact that they are all time words.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30aaecf9-d5a9-5515-9565-5eade9a990dd', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Spelling — Choose the correct comparative of "big": "An elephant is ___ than a horse."', '[{"id":"a","text":"biger"},{"id":"b","text":"more big"},{"id":"c","text":"bigger"},{"id":"d","text":"biggest"}]'::jsonb, 'c', 'big has one short vowel + one consonant, so we double the g before -er: bigger than a horse. "biger" forgets to double the g, "more big" wrongly adds more to a short adjective, and "biggest" is the superlative (which needs the and no than).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deb2d0e6-638f-5362-a00c-592c72f75f3e', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Reading — Read: "Last weekend Leila painted her room. On Saturday she chose the colour, and on Sunday she finished the work."
When did Leila finish painting?', '[{"id":"a","text":"On Friday."},{"id":"b","text":"On Saturday."},{"id":"c","text":"On Sunday."},{"id":"d","text":"Next weekend."}]'::jsonb, 'c', 'The text says she finished the work "on Sunday", so (c) is correct. Read for the exact detail: Saturday (b) was when she chose the colour, Friday (a) is never mentioned, and the story is in the past, not "next weekend" (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ac1edda7-019a-5303-b405-2243e1707f2f', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '⭐ Gauntlet A2: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9ffbae32-455d-5620-b30e-210f217f240d', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Grammar — Complete the past simple: "Yesterday my sister ___ a cake for the party."', '[{"id":"a","text":"bakes"},{"id":"b","text":"baked"},{"id":"c","text":"baking"},{"id":"d","text":"bake"}]'::jsonb, 'b', 'bake is a regular verb ending in -e, so we add only -d for the past: baked. With "yesterday" we need the past, so "bakes"/"bake" (present) and "baking" (the -ing form, which needs be) are all wrong.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf099e79-fba7-5832-b484-acfcb3094e59', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Spelling — Choose the correct -ing form: "Look! The dog ___ across the field."', '[{"id":"a","text":"is runing"},{"id":"b","text":"is runeing"},{"id":"c","text":"is running"},{"id":"d","text":"is run"}]'::jsonb, 'c', 'run has one short vowel + one consonant, so we double the n before -ing: running. "is runing" forgets to double the n, "is runeing" adds a wrong e, and "is run" drops the -ing the continuous needs.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84dd849c-f5f7-56a9-87a8-6bf27982b393', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"apple"},{"id":"b","text":"banana"},{"id":"c","text":"carrot"},{"id":"d","text":"orange"}]'::jsonb, 'c', 'Apple, banana and orange are all fruits, but a carrot is a vegetable, so it is the odd one out. Sort by meaning: the set looks like "food", but only the fruits belong together.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89b12fff-740e-54f2-88e8-100a500354f2', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Reading — Read: "Karim got up early on Sunday. He went to the bakery and bought fresh bread for breakfast."
Where did Karim go?', '[{"id":"a","text":"To the bakery."},{"id":"b","text":"To school."},{"id":"c","text":"To the cinema."},{"id":"d","text":"To the beach."}]'::jsonb, 'a', 'The text says "He went to the bakery", so that is the answer. A reading answer must come from the text: school, cinema and beach are real places but are never mentioned, so they cannot be correct.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4054d66b-a984-59b3-b10c-6aad8e6f64bc', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Grammar — Future: "I''ve already decided — next summer I ___ visit my uncle in Sfax." (a plan)', '[{"id":"a","text":"will to"},{"id":"b","text":"am going to"},{"id":"c","text":"going to"},{"id":"d","text":"go to"}]'::jsonb, 'b', 'A plan you already decided uses be going to + base verb: I am going to visit. "will to" is never correct (will takes no to), "going to" alone drops the be (am), and "go to" is the present, not a future plan.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ace366dc-2fca-5c26-a061-3eac12cbfdce', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Spelling — Choose the correctly spelled past form: "He ___ very hard for the test last week."', '[{"id":"a","text":"studyed"},{"id":"b","text":"studed"},{"id":"c","text":"studies"},{"id":"d","text":"studied"}]'::jsonb, 'd', 'study ends in consonant + y, so the y becomes -ied in the past: studied. "studyed" keeps the y wrongly, "studed" drops a letter, and "studies" is the present he/she/it form, not the past.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('921bba7a-96bc-5389-8a70-774129c4103c', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '⭐⭐ Gauntlet A2: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('0dd8f34e-b3de-5cc6-ac9a-91fdad7e2131', '921bba7a-96bc-5389-8a70-774129c4103c', 'Grammar — Now or habit? "My father usually drives to work, but today he ___ the train."', '[{"id":"a","text":"takes"},{"id":"b","text":"is taking"},{"id":"c","text":"take"},{"id":"d","text":"are taking"}]'::jsonb, 'b', '"today" marks a temporary action against the usual habit, so use the present continuous: today he is taking the train. "usually drives" is the habit (simple), but "today" switches us to the continuous; "takes"/"take" are simple, and "are taking" uses the plural be with he.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2e01a6c-d449-59bd-b089-a974205fbb09', '921bba7a-96bc-5389-8a70-774129c4103c', 'Vocabulary — Choose the opposite: "This suitcase isn''t heavy at all — in fact it''s very ___."', '[{"id":"a","text":"big"},{"id":"b","text":"old"},{"id":"c","text":"light"},{"id":"d","text":"expensive"}]'::jsonb, 'c', 'The opposite of heavy is light, so a case that isn''t heavy is very light. Big, old and expensive are real adjectives, but none is the opposite of heavy, so they don''t fit the contrast the sentence builds.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b38b70eb-7f13-5b7a-b4d2-cfe60c4d278b', '921bba7a-96bc-5389-8a70-774129c4103c', 'Spelling — Choose the correct superlative: "That was the ___ day of my whole holiday."', '[{"id":"a","text":"happyest"},{"id":"b","text":"most happy"},{"id":"c","text":"happier"},{"id":"d","text":"happiest"}]'::jsonb, 'd', 'happy ends in consonant + y, so the superlative changes y to i and adds -est: the happiest day. "happyest" keeps the y wrongly, "most happy" treats a short -y adjective as long (it isn''t), and "happier" is the comparative (for two things).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('391494ec-2225-548e-baa9-cfefa0f3d473', '921bba7a-96bc-5389-8a70-774129c4103c', 'Reading — Read: "Last Saturday Omar and his friends played football in the park. After the game they were thirsty, so they bought cold drinks."
How did the friends feel after the game?', '[{"id":"a","text":"They were thirsty."},{"id":"b","text":"They were cold."},{"id":"c","text":"They were bored."},{"id":"d","text":"They were afraid."}]'::jsonb, 'a', 'The text says "they were thirsty", which is why they bought cold drinks, so (a) is correct. Read for the exact detail: cold (b) describes the drinks, not the boys, and bored (c) and afraid (d) are never mentioned in the passage.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f688da08-7b8e-563f-aa96-08929c36fe04', '921bba7a-96bc-5389-8a70-774129c4103c', 'Grammar — Quantifier: "Hurry up! We don''t have ___ time before the bus leaves."', '[{"id":"a","text":"many"},{"id":"b","text":"a few"},{"id":"c","text":"much"},{"id":"d","text":"some"}]'::jsonb, 'c', 'time is uncountable, so its amount word is much, and in a negative it fits naturally: we don''t have much time. many and a few need countable plural nouns, and some is normally used in affirmatives, not negatives.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2dc6a633-b197-5ca5-a17f-6d497dbfa8da', '921bba7a-96bc-5389-8a70-774129c4103c', 'Grammar — Future: "A: There''s no milk left for the coffee. B: Oh, I ___ buy some on my way home." (deciding as you speak)', '[{"id":"a","text":"am going to"},{"id":"b","text":"will"},{"id":"c","text":"will to"},{"id":"d","text":"going to"}]'::jsonb, 'b', 'B reacts to the news and decides at that moment, so use will + base verb: I will buy some. "am going to" would suggest a plan made earlier, "will to" wrongly adds to after will, and "going to" alone is missing the be (am).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('10d813a5-0872-5aaa-991d-7f0f76b66c9f', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '⚔️ Gauntlet A2 Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('2b43508d-291e-587b-aa57-d359f8653093', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Grammar — Put the words in the correct order: (did / when / you / arrive)', '[{"id":"a","text":"When did you arrive?"},{"id":"b","text":"When you did arrive?"},{"id":"c","text":"When did you arrived?"},{"id":"d","text":"When arrived you?"}]'::jsonb, 'a', 'A past question with an action verb is: question word + did + subject + base verb → When did you arrive? "When you did arrive" keeps statement order, "did you arrived" double-marks the past (the -ed lives on the helper did), and "When arrived you?" drops the helper did.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f1cf64b-c744-5acf-911e-3c32c2b7e851', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Spelling — Find the INCORRECT word.', '[{"id":"a","text":"making"},{"id":"b","text":"writing"},{"id":"c","text":"coming"},{"id":"d","text":"swiming"}]'::jsonb, 'd', 'The error is (d): swim has one short vowel + one consonant, so the m doubles before -ing — swimming, not "swiming". The correct ones drop a silent -e before -ing: make → making, write → writing, come → coming.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('feaf3563-3abe-5395-b244-3e880ec79df8', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"kitchen"},{"id":"b","text":"garden"},{"id":"c","text":"bedroom"},{"id":"d","text":"bathroom"}]'::jsonb, 'b', 'Kitchen, bedroom and bathroom are all rooms inside a house, but a garden is outside, so it is the odd one out. The trap is that all four belong to a home, but only the indoor rooms form the matching set.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93bfba0b-b84e-5a2c-93fe-08a9055b04b0', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Grammar — Comparison: "This chair is ___ comfortable ___ that one; they feel exactly the same."', '[{"id":"a","text":"more … than"},{"id":"b","text":"so … then"},{"id":"c","text":"as … as"},{"id":"d","text":"the … est"}]'::jsonb, 'c', 'To say two things are equal we use as + adjective + as: as comfortable as that one. "more … than" would make one chair greater (but they''re the same), "then" is a time word (not than), and "the …est" is the superlative pattern, not a comparison of two chairs.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27d3bdd0-d5b2-53f1-b433-2110058bdc89', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Reading — Read: "Hana wanted to buy a present for her mother. She had a little money, just enough for some flowers, but not enough for the scarf she liked."
What could Hana buy?', '[{"id":"a","text":"Some flowers."},{"id":"b","text":"The scarf."},{"id":"c","text":"Both the scarf and the flowers."},{"id":"d","text":"Nothing at all."}]'::jsonb, 'a', 'The text says she had "just enough for some flowers, but not enough for the scarf", so she could buy some flowers (a). She could not afford the scarf (so b and c are out), and "a little money" still means she had some, so "nothing at all" (d) is wrong.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('644a8500-026c-5933-8686-11915e185e57', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Grammar — Future: "Our team is winning 3–0 with five minutes left. They ___ win the match!" (the evidence is clear)', '[{"id":"a","text":"will to"},{"id":"b","text":"are going to"},{"id":"c","text":"are going"},{"id":"d","text":"going to"}]'::jsonb, 'b', 'A prediction from clear evidence in front of you uses be going to; with they the form is are going to: They are going to win. "are going" is missing the to, "going to" is missing the be (are), and "will to" is never correct because will takes no to.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fc2145a3-1830-5fed-94ce-6b74e92b395c', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '👑 Gauntlet A2 Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('20083635-85e1-5bf9-9ceb-3fb001d288c9', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Reading — Read: "Last winter Youssef broke his leg while skiing. He stayed at home for a month and couldn''t play football. His friends visited him every weekend."
Which sentence is TRUE?', '[{"id":"a","text":"Youssef hurt his leg last winter."},{"id":"b","text":"Youssef broke his arm."},{"id":"c","text":"He played football at home."},{"id":"d","text":"Nobody visited him."}]'::jsonb, 'a', 'The text says he "broke his leg" last winter, so (a) is true (to break your leg = to hurt it). It was his leg, not his arm (b); he "couldn''t play football" (c is false); and his friends visited every weekend, so (d) contradicts the text.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3485792-24b3-59fa-be2a-7c5246e9b53f', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Grammar — Find the INCORRECT sentence.', '[{"id":"a","text":"We didn''t go to the market yesterday."},{"id":"b","text":"She is reading a book at the moment."},{"id":"c","text":"They will going to move house next year."},{"id":"d","text":"He bought a new bike last week."}]'::jsonb, 'c', 'The error is (c): you can''t stack two futures — say "They are going to move" or "They will move", never "will going to". (a) is a correct past negative (didn''t + base), (b) a correct present continuous (now), and (d) a correct irregular past (bought).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f320f6f-b28d-56a9-8277-c01e618d4a34', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Spelling — Find the INCORRECT word.', '[{"id":"a","text":"hottest"},{"id":"b","text":"easiest"},{"id":"c","text":"biggest"},{"id":"d","text":"funnyest"}]'::jsonb, 'd', 'The error is (d): funny ends in consonant + y, so the y becomes i — funniest, not "funnyest". The correct ones follow their rules: hot doubles the t (hottest), easy changes y to i (easiest), and big doubles the g (biggest).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f14f7ec-3e0b-50e3-af2d-176eaa9a3ced', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Vocabulary — Choose the word that best completes the sentence: "The first question was easy, but the last one was really ___."', '[{"id":"a","text":"cheap"},{"id":"b","text":"difficult"},{"id":"c","text":"quiet"},{"id":"d","text":"early"}]'::jsonb, 'b', '"but" signals a contrast with easy, so the missing word is its opposite, difficult: easy ↔ difficult. Cheap, quiet and early are real adjectives, but none is the opposite of easy, so they break the contrast the sentence sets up.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c98ec9e-bf30-5942-9a0a-de4c43ea858b', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Grammar — Quantifiers: "There were ___ guests at the wedding, but only ___ of them danced."', '[{"id":"a","text":"many / a few"},{"id":"b","text":"a little / many"},{"id":"c","text":"much / a little"},{"id":"d","text":"a great deal / a few"}]'::jsonb, 'a', 'guests is countable and plural, so both gaps need countable quantifiers: many guests, and a few of them danced. So it is many / a few. much, a little and a great deal are for uncountable nouns and don''t fit countable guests.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d0b4f5f-9fd3-5242-9f1a-0a295edd87ea', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Reading — Read: "It''s 7 o''clock in the morning. Lina is at the bus stop with her schoolbag. She is looking at her watch and the bus isn''t here yet."
What is Lina probably doing?', '[{"id":"a","text":"She is sleeping at home."},{"id":"b","text":"She is cooking breakfast."},{"id":"c","text":"She is playing in the park."},{"id":"d","text":"She is waiting for the bus."}]'::jsonb, 'd', 'The clues — at the bus stop, with her schoolbag, looking at her watch, the bus not here yet — point to an action in progress now: she is waiting for the bus (d). "sleeping at home", "cooking breakfast" and "playing in the park" all contradict "is at the bus stop".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fcb06e0b-85c9-5e82-b475-a102bd8f1a41', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('315c2129-e18c-5618-b783-d3befb72b319', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Grammar — Present perfect: "Be careful — he ___ broken his arm, so he can''t play today."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"is"},{"id":"d","text":"had"}]'::jsonb, 'b', 'A past action with a result now (he can''t play) takes the present perfect, and with he the auxiliary is has + participle: he has broken his arm. "have" is for I/you/we/they, "is" doesn''t form the present perfect, and "had" is the past perfect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be963e07-2c4e-50c4-9523-33d4dd3877a9', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"thunder"},{"id":"b","text":"lightning"},{"id":"c","text":"fog"},{"id":"d","text":"ceiling"}]'::jsonb, 'd', 'Thunder, lightning and fog are all weather words, but a ceiling is part of a room, so it is the odd one out. Sort the set by meaning: three belong to the weather, while ceiling belongs to a building.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('030a1f57-a9c6-5b83-bd90-dde2ccc10efa', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Grammar — Advice: "You''ve had a headache all day. You ___ rest and drink some water."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"don''t have to"},{"id":"c","text":"should"},{"id":"d","text":"should to"}]'::jsonb, 'c', 'This is friendly advice, so we use should + base verb: You should rest. "should to" is wrong (no to after should), "mustn''t" would forbid resting, and "don''t have to" only says it''s optional rather than recommended.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('624f39c3-31a4-5b2a-86f8-dfabfd05bc92', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Spelling — Choose the correct -ing form: "She was ___ for clothes when I saw her in town."', '[{"id":"a","text":"shoping"},{"id":"b","text":"shopping"},{"id":"c","text":"shoppping"},{"id":"d","text":"shopeing"}]'::jsonb, 'b', 'shop has one short vowel + one consonant, so the p doubles before -ing: shopping. "shoping" forgets to double the p, "shoppping" adds one too many, and "shopeing" wrongly inserts an e.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f402bb1-d0ea-5b17-a1ae-8546063df794', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Reading — Read: "Nadia moved to Tunis in 2019 and still lives there. She has worked at the same school since she arrived."
Where does Nadia live now?', '[{"id":"a","text":"In Tunis."},{"id":"b","text":"In Sfax."},{"id":"c","text":"In Paris."},{"id":"d","text":"She has left the country."}]'::jsonb, 'a', 'The text says she moved to Tunis and "still lives there", so she lives in Tunis now (a). Read for the detail: Sfax and Paris are never mentioned, and "still lives there" tells us she has not left (d is wrong).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('30d03a04-6201-59a0-a734-7750c0966a66', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '⭐ Gauntlet B1: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('04a07c4f-9182-593f-abc9-745311969be3', '30d03a04-6201-59a0-a734-7750c0966a66', 'Grammar — Present perfect: "I ___ already read that book, so I''ll lend it to you."', '[{"id":"a","text":"has"},{"id":"b","text":"have"},{"id":"c","text":"am"},{"id":"d","text":"was"}]'::jsonb, 'b', 'With I the present perfect auxiliary is have + participle: I have already read it. "has" is only for he/she/it, "am" doesn''t form the present perfect, and "was" is the past simple of be.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01e99d6b-2648-56a4-a69b-5149e18a61a1', '30d03a04-6201-59a0-a734-7750c0966a66', 'Spelling — Choose the correct -ing form: "The children were ___ in the pool all afternoon."', '[{"id":"a","text":"swiming"},{"id":"b","text":"swimming"},{"id":"c","text":"swimeing"},{"id":"d","text":"swimmming"}]'::jsonb, 'b', 'swim has one short vowel + one consonant, so the m doubles before -ing: swimming. "swiming" keeps only one m, "swimeing" adds a wrong e, and "swimmming" has one m too many.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c5bdd7a-c6bf-5b9b-a482-1c2ba61aba94', '30d03a04-6201-59a0-a734-7750c0966a66', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"doctor"},{"id":"b","text":"nurse"},{"id":"c","text":"hospital"},{"id":"d","text":"dentist"}]'::jsonb, 'c', 'Doctor, nurse and dentist are all people who work in health, but a hospital is a place, so it is the odd one out. Sort by meaning: three are jobs, while hospital is where they work.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e976e35f-7fd3-5b2c-9581-86dc41a59f26', '30d03a04-6201-59a0-a734-7750c0966a66', 'Grammar — Obligation: "At my school we ___ wear a uniform every day; it''s a strict rule."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"have"},{"id":"d","text":"have to"}]'::jsonb, 'd', 'A strict rule is an obligation, and with we we use have to + base verb: we have to wear a uniform. "don''t have to" would make it optional, "shouldn''t" advises against it, and "have" alone (without to) doesn''t express the rule.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c54e7d72-8852-5ac4-95c1-8498373a6509', '30d03a04-6201-59a0-a734-7750c0966a66', 'Reading — Read: "Yesterday it was raining hard. Sami was waiting at the bus stop without an umbrella, so he got completely wet."
Why did Sami get wet?', '[{"id":"a","text":"He had no umbrella in the rain."},{"id":"b","text":"He fell into a river."},{"id":"c","text":"He was swimming."},{"id":"d","text":"He washed his car."}]'::jsonb, 'a', 'The text says it was raining and he was waiting "without an umbrella", so he got wet from the rain (a). A reading answer must come from the text: a river, swimming and washing a car are never mentioned.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('147d8224-0891-5ac2-a017-7bad399412c1', '30d03a04-6201-59a0-a734-7750c0966a66', 'Spelling — Choose the correct past participle: "We have ___ all the sandwiches; there are none left."', '[{"id":"a","text":"ate"},{"id":"b","text":"eated"},{"id":"c","text":"eaten"},{"id":"d","text":"eat"}]'::jsonb, 'c', 'eat is irregular: eat → ate (past) → eaten (participle). After have we use the participle: We have eaten them. "ate" is the past simple, "eated" is not a word, and "eat" is the base form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '⭐⭐ Gauntlet B1: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('2e505b1f-9d16-5b27-a959-6a584d42345f', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Grammar — Past continuous: "___ we were walking home, we met an old friend."', '[{"id":"a","text":"When"},{"id":"b","text":"While"},{"id":"c","text":"Since"},{"id":"d","text":"During"}]'::jsonb, 'b', 'while introduces the long action in progress (we were walking): While we were walking home… The short event (we met a friend) is in the past simple. "when" goes with the short action, "since" marks a start point, and "during" is followed by a noun, not a clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e501524-914c-5567-b7b7-716f575dcc38', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Vocabulary — Choose the opposite: "The first exercise was difficult, but this one is quite ___."', '[{"id":"a","text":"heavy"},{"id":"b","text":"loud"},{"id":"c","text":"easy"},{"id":"d","text":"tall"}]'::jsonb, 'c', '"but" signals a contrast with difficult, so the missing word is its opposite, easy: difficult ↔ easy. Heavy, loud and tall are real adjectives, but none is the opposite of difficult, so they break the contrast the sentence sets up.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a62ac825-e95d-594f-9f73-339f0f152530', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Grammar — First conditional: "If you press this green button, the machine ___ immediately."', '[{"id":"a","text":"started"},{"id":"b","text":"would start"},{"id":"c","text":"will start"},{"id":"d","text":"starting"}]'::jsonb, 'c', 'This is a real, possible result, so the first conditional uses will + base verb: the machine will start. "would start" is the imaginary second conditional, "started" is the past simple, and "starting" is not a finite verb form here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('576113c2-8990-5f99-8920-7dfe0f5e9798', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Reading — Read: "Leila has visited many countries, but she has never been to Japan. Next spring, she is finally going there for two weeks."
Which country has Leila NOT visited yet?', '[{"id":"a","text":"Japan."},{"id":"b","text":"Italy."},{"id":"c","text":"Every country."},{"id":"d","text":"None — she has visited them all."}]'::jsonb, 'a', 'The text says she "has never been to Japan", so Japan is the one she hasn''t visited yet (a). She has visited many countries, just not Japan, so "every country" (c) and "all of them" (d) are wrong, and Italy (b) is never mentioned.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c22de34c-acaa-595e-9f69-c6713c808e55', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Spelling — Choose the correct past participle: "She has ___ three letters to the company this week."', '[{"id":"a","text":"wrote"},{"id":"b","text":"written"},{"id":"c","text":"writed"},{"id":"d","text":"writing"}]'::jsonb, 'b', 'write is irregular: write → wrote (past) → written (participle). After has we use the participle: She has written three letters. "wrote" is the past simple, "writed" is not a word, and "writing" is the -ing form, which needs a form of be.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8dfcb72a-70dc-5609-ac68-aae097b099ae', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Grammar — Relative clause: "That''s the cafe ___ owner makes the best coffee in town."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'd', 'whose shows possession — it replaces its here (its owner): the cafe whose owner makes the best coffee. "who" is for a person doing the action, "which" would need a verb after it (the cafe which sells coffee), and "where" marks a place inside the clause, not an owner.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '⚔️ Gauntlet B1 Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('3a53c0d6-d02d-5abd-929d-8c13cae3d02a', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Grammar — Present perfect vs past simple: "We ___ this film two days ago, so let''s watch something else."', '[{"id":"a","text":"have watched"},{"id":"b","text":"watched"},{"id":"c","text":"have watch"},{"id":"d","text":"has watched"}]'::jsonb, 'b', '"two days ago" is a finished time, so we use the past simple: We watched this film two days ago. The present perfect can''t take a finished-time marker (so "have watched" is wrong), "have watch" lacks the participle, and "has watched" is the wrong subject form for we.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e275588a-04c6-5945-bcaa-e30fad0bdc2b', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Grammar — Find the INCORRECT sentence.', '[{"id":"a","text":"If you don''t water plants, they die."},{"id":"b","text":"She was reading when the lights went out."},{"id":"c","text":"You should call the doctor tomorrow."},{"id":"d","text":"If I will see her, I''ll give her the message."}]'::jsonb, 'd', 'The error is (d): never put will in the if-clause — it should be If I see her, I''ll give her the message. (a) is a correct zero conditional, (b) correctly interrupts a past-continuous action with a past-simple event, and (c) is correct advice with should + base.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e80bebe-a948-5f60-addf-a7964150f11e', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Vocabulary — Complete the collocation: "Before you sign anything, you need to ___ an important decision."', '[{"id":"a","text":"do"},{"id":"b","text":"take"},{"id":"c","text":"make"},{"id":"d","text":"have"}]'::jsonb, 'c', 'In English we make a decision, not "do" or "have" one: you need to make an important decision. This is a fixed collocation — make goes with decision, plan and mistake, while do goes with homework or the housework.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98c98d95-8646-5a2b-9324-7971f72aa5db', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Reading — Read: "The ground outside is completely wet and there are puddles everywhere, but the sky is clear and bright now. People are closing their umbrellas."
What has just happened?', '[{"id":"a","text":"It has just rained."},{"id":"b","text":"It has been sunny all day."},{"id":"c","text":"There has been a sandstorm."},{"id":"d","text":"It has started to snow."}]'::jsonb, 'a', 'The clues — wet ground, puddles, a now-clear sky and people closing umbrellas — show it has just rained (a). "sunny all day" can''t explain the wet ground and umbrellas (b), and a sandstorm (c) or snow (d) don''t fit puddles and umbrellas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55463583-d0fb-5eb9-a775-b259094ec76b', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Grammar — Modals: "The test starts at exactly nine, so you ___ be late, or they won''t let you in."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"should"},{"id":"c","text":"don''t need to"},{"id":"d","text":"mustn''t"}]'::jsonb, 'd', 'Being late is not allowed (they won''t let you in), so we use mustn''t (prohibition): you mustn''t be late. The trap is "don''t have to"/"don''t need to", which mean it''s optional — but here lateness is forbidden, not a free choice, and "should" is only advice.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29d002ba-7118-5565-b210-9030f2648028', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Spelling — Choose the correct -ing form: "I''m always ___ where I put my keys."', '[{"id":"a","text":"forgeting"},{"id":"b","text":"forgettting"},{"id":"c","text":"forgetting"},{"id":"d","text":"forgetteing"}]'::jsonb, 'c', 'forget is stressed on the last syllable and ends in one vowel + one consonant, so the t doubles before -ing: forgetting. "forgeting" keeps only one t, "forgettting" has one too many, and "forgetteing" wrongly inserts an e.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('67c32e3b-7c05-5912-a9f2-012814f7a41f', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '👑 Gauntlet B1 Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('2cba1ba7-af16-5d87-b768-affe2783e7bf', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Reading — Read: "Omar has played the guitar since he was ten. He has given many concerts, but he has never recorded an album. This year, he is saving money to make his first one."
Which sentence is TRUE?', '[{"id":"a","text":"Omar started playing the guitar as a child."},{"id":"b","text":"Omar has already recorded several albums."},{"id":"c","text":"Omar has never performed in public."},{"id":"d","text":"Omar gave up the guitar this year."}]'::jsonb, 'a', '"since he was ten" means he began as a child, so (a) is true. He has never recorded an album (b is false), he has given many concerts, so he has performed (c is false), and he is saving to make an album, not giving up (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68fc82c4-b675-5ddc-8326-7952e13a2a19', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Grammar — Find the INCORRECT sentence.', '[{"id":"a","text":"The book which I borrowed was fascinating."},{"id":"b","text":"If I had more time, I would learn to paint."},{"id":"c","text":"I have seen that play last weekend."},{"id":"d","text":"They were arguing when the teacher walked in."}]'::jsonb, 'c', 'The error is (c): "last weekend" is a finished time, so it needs the past simple — I saw that play last weekend, not "have seen". (a) uses which correctly for a thing, (b) is a correct second conditional, and (d) correctly interrupts a long past action with a short one.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19af87e0-dcf5-58b5-9861-544a725d24c9', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Grammar — Second conditional: "If I ___ better at maths, I would help you with this problem."', '[{"id":"a","text":"will be"},{"id":"b","text":"am"},{"id":"c","text":"would be"},{"id":"d","text":"were"}]'::jsonb, 'd', 'The result "would help" signals the imaginary second conditional, so the if-clause uses the past simple, and with the verb be we use were for every subject: If I were better at maths… "am" is the present, while "will be" and "would be" wrongly put a modal inside the if-clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34eb0159-aead-52e8-a7b3-1b9273d5b564', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Spelling — Find the INCORRECT word.', '[{"id":"a","text":"better"},{"id":"b","text":"gooder"},{"id":"c","text":"worse"},{"id":"d","text":"further"}]'::jsonb, 'b', 'The error is (b): good is irregular, so its comparative is better, not "gooder". The other three are correct comparatives — bad → worse, far → further (and well → better) — irregular forms you must learn by heart.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('137d7a75-f95b-566a-bd55-779e463fd7ce', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Grammar — Relative clauses: "The journalist ___ wrote the article interviewed a scientist ___ research could change medicine."', '[{"id":"a","text":"which … who"},{"id":"b","text":"who … whose"},{"id":"c","text":"whose … which"},{"id":"d","text":"where … whose"}]'::jsonb, 'b', 'The journalist is a person doing the action (who wrote), and the scientist owns the research (whose research). So: who … whose. The other pairs mismatch — a person doing an action is never "which/where/whose" here, and "research" belongs to the scientist, which needs whose, not which.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ddd14b29-f733-5239-bafb-9b71636483f5', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Vocabulary — Choose the word that best completes the sentence: "He spoke so ___ that nobody at the back could hear him."', '[{"id":"a","text":"quietly"},{"id":"b","text":"clearly"},{"id":"c","text":"loudly"},{"id":"d","text":"quickly"}]'::jsonb, 'a', 'If nobody at the back could hear him, he must have spoken quietly: he spoke so quietly that nobody could hear. "loudly" and "clearly" would make him easy to hear (the opposite), and "quickly" is about speed, not volume, so it doesn''t explain why they couldn''t hear.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

