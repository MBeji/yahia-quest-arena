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

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium, theme_id, grade_id) VALUES
  ('math-bac-math', 'Mathématiques', 'Analyse, algèbre, géométrie et probabilités selon le programme officiel de la 4ème année secondaire — section Mathématiques (préparation au baccalauréat)', 'Force', 'subject-math', 'Calculator', 1, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = 'bac-math'))
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
      AND e.subject_id = 'math-bac-math'
      AND e.source = 'admin'
      AND q.id NOT IN ('3af27c08-8da6-5667-ac15-1b0d4b924c04', '2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b74234c6-97b1-57c7-b21a-9698d89bddf7', '0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'd868bf9d-4d39-5d05-8c23-91e3dd50cbd4', '2bc732c3-ef84-593e-8141-28d56a59f5f7', 'aec4ec41-216a-51a3-b0a8-6a5820082cef', '1744bf0b-0591-5555-90c5-5a33930403c2', '4beea811-5dad-5080-a722-62a3185fc237', 'b9253cb3-c7fd-597d-9e5b-efdd4610721a', '0c9af287-fc69-5495-b1d8-05872e8f8300', 'a1682039-0438-5589-810c-7ce83d3f1190', '2adf3630-8ece-5043-a698-baa40822db13', 'cd689749-cc37-5719-9e5c-779dce1c6d54', '88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '45a47019-5722-586c-8211-35c6609f5eac', '95d862fa-6176-53ff-bd36-3a089be93947', '4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '0c567130-c4c9-5bbf-98af-48ac3fe35478', '55ae6f27-b3d2-53a0-95ac-3c1522b812bc', 'bc67fce0-14b0-512d-96fb-b200ad35fa3f', 'a85f9f3a-57c8-5528-b925-41cadd3ea008', 'e5f35d28-19b0-5807-adc2-cc42ca5e625e', 'bef7b52e-7113-5e25-b4c9-7943c27a365d', '0784b9f3-963c-5021-9ab6-bb87604c9d71', '5082a155-94a8-5525-b00f-b86ccd1cab10', '3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '28b2f193-675b-52ec-8354-09cf1e8a4a6b', '5f1d4834-8d38-5bfd-83f4-1428cc4074e4', 'a9ec4bb2-971b-548b-b872-47feb78de533', '746b0135-365a-5001-8259-05b772e9e1ea', 'ffdad216-1ab6-55cf-9736-9792be0fdf75', '1480bf16-37ba-5bcb-967d-c9869d882e43', '31a27502-0123-5cab-91c3-12dcc369cdf7', 'c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '2a65b201-ef6d-5532-b334-bef78c2e24f4', '34fd0348-7102-5b8a-8302-1b9577ab01e2', '7a149b92-97dd-545c-a583-5bf272b2eb7f', 'f010664a-2322-5b74-ab99-04ea17013ccc', '0d9998e1-142f-58b9-9112-2bf36321029f', '2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '269d83d5-c846-5358-a11b-055acb721037', '418ecd91-02f2-5e60-949a-4b77903ff934', '9808b350-e59e-5b03-8df4-156a48f6313b', '1782f429-e18c-5e6f-8bf9-0fc7f054cb33', '128b72a3-9efc-5a82-9e82-7eba9bc9714a', '99763050-35a1-58e9-bdcf-b2e5cd3f3758');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-bac-math' AND source = 'admin' AND id NOT IN ('b76771c5-32e7-5632-9794-9ec8095fa035', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', '75fc9ae9-900f-5c98-8207-baa94bff86af', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', '6f055244-7690-5d90-b279-8c0785ee7e44', '35d2cb52-661a-50a0-94d8-24590f6525d8', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'edb002de-0e7f-5b7c-8d12-039559657254');
DELETE FROM public.questions WHERE exercise_id IN ('b76771c5-32e7-5632-9794-9ec8095fa035', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', '75fc9ae9-900f-5c98-8207-baa94bff86af', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', '6f055244-7690-5d90-b279-8c0785ee7e44', '35d2cb52-661a-50a0-94d8-24590f6525d8', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'edb002de-0e7f-5b7c-8d12-039559657254') AND id NOT IN ('3af27c08-8da6-5667-ac15-1b0d4b924c04', '2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b74234c6-97b1-57c7-b21a-9698d89bddf7', '0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'd868bf9d-4d39-5d05-8c23-91e3dd50cbd4', '2bc732c3-ef84-593e-8141-28d56a59f5f7', 'aec4ec41-216a-51a3-b0a8-6a5820082cef', '1744bf0b-0591-5555-90c5-5a33930403c2', '4beea811-5dad-5080-a722-62a3185fc237', 'b9253cb3-c7fd-597d-9e5b-efdd4610721a', '0c9af287-fc69-5495-b1d8-05872e8f8300', 'a1682039-0438-5589-810c-7ce83d3f1190', '2adf3630-8ece-5043-a698-baa40822db13', 'cd689749-cc37-5719-9e5c-779dce1c6d54', '88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '45a47019-5722-586c-8211-35c6609f5eac', '95d862fa-6176-53ff-bd36-3a089be93947', '4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '0c567130-c4c9-5bbf-98af-48ac3fe35478', '55ae6f27-b3d2-53a0-95ac-3c1522b812bc', 'bc67fce0-14b0-512d-96fb-b200ad35fa3f', 'a85f9f3a-57c8-5528-b925-41cadd3ea008', 'e5f35d28-19b0-5807-adc2-cc42ca5e625e', 'bef7b52e-7113-5e25-b4c9-7943c27a365d', '0784b9f3-963c-5021-9ab6-bb87604c9d71', '5082a155-94a8-5525-b00f-b86ccd1cab10', '3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '28b2f193-675b-52ec-8354-09cf1e8a4a6b', '5f1d4834-8d38-5bfd-83f4-1428cc4074e4', 'a9ec4bb2-971b-548b-b872-47feb78de533', '746b0135-365a-5001-8259-05b772e9e1ea', 'ffdad216-1ab6-55cf-9736-9792be0fdf75', '1480bf16-37ba-5bcb-967d-c9869d882e43', '31a27502-0123-5cab-91c3-12dcc369cdf7', 'c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '2a65b201-ef6d-5532-b334-bef78c2e24f4', '34fd0348-7102-5b8a-8302-1b9577ab01e2', '7a149b92-97dd-545c-a583-5bf272b2eb7f', 'f010664a-2322-5b74-ab99-04ea17013ccc', '0d9998e1-142f-58b9-9112-2bf36321029f', '2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '269d83d5-c846-5358-a11b-055acb721037', '418ecd91-02f2-5e60-949a-4b77903ff934', '9808b350-e59e-5b03-8df4-156a48f6313b', '1782f429-e18c-5e6f-8bf9-0fc7f054cb33', '128b72a3-9efc-5a82-9e82-7eba9bc9714a', '99763050-35a1-58e9-bdcf-b2e5cd3f3758');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-bac-math' AND c.id NOT IN ('ce10c015-98c9-52df-8043-6cb82a6a402b') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
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
- **Dichotomie** : couper [a ; b] au milieu, garder la moitié où f change de signe → valeur approchée de α à 10⁻ⁿ près.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b76771c5-32e7-5632-9794-9ec8095fa035', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', 'Test de compréhension ⭐ : Continuité et limites', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b74234c6-97b1-57c7-b21a-9698d89bddf7', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'Une fonction f vérifie lim x→3 f(x) = +∞. Que peut-on en déduire pour la courbe de f ?', '[{"id":"a","text":"La droite d''équation y = 3 est une asymptote horizontale"},{"id":"b","text":"La droite d''équation y = 0 est une asymptote horizontale"},{"id":"c","text":"La droite d''équation x = 3 est une asymptote horizontale"},{"id":"d","text":"La droite d''équation x = 3 est une asymptote verticale"}]'::jsonb, 'd', 'Une limite infinie en un point a se traduit par une asymptote verticale d''équation x = a : ici, lim x→3 f(x) = +∞ donne l''asymptote verticale x = 3. Une asymptote horizontale correspondrait à une limite finie en +∞ ou en −∞, ce qui n''est pas la situation décrite.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'f est une fonction continue sur le segment [a ; b]. Quelle est l''image de [a ; b] par f ?', '[{"id":"a","text":"Le segment [f(a) ; f(b)], où f(a) et f(b) sont les valeurs aux bornes"},{"id":"b","text":"Un intervalle ouvert contenant f(a) et f(b)"},{"id":"c","text":"Le segment [m ; M], où m et M sont le minimum et le maximum de f"},{"id":"d","text":"L''ensemble ℝ tout entier, dès que f n''est pas constante"}]'::jsonb, 'c', 'L''image du segment [a ; b] par une fonction continue est le segment [m ; M], où m et M sont le minimum et le maximum de f sur [a ; b]. Ce n''est pas forcément [f(a) ; f(b)] : le maximum ou le minimum peut être atteint à l''intérieur de l''intervalle, pas aux bornes.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⭐ Exercice : Premières armes — limites et continuité', 1, 50, 10, 'practice', 'admin', 1)
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
  ('b9253cb3-c7fd-597d-9e5b-efdd4610721a', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Soit f(x) = (3x − 1)/(x + 2). La courbe de f admet une asymptote verticale : laquelle ?', '[{"id":"a","text":"La droite d''équation x = −2"},{"id":"b","text":"La droite d''équation x = 2"},{"id":"c","text":"La droite d''équation x = 3"},{"id":"d","text":"La droite d''équation y = 3"}]'::jsonb, 'a', 'Le dénominateur x + 2 s''annule en x = −2 (et le numérateur y vaut −7 ≠ 0), donc les limites de f en −2 sont infinies : la droite d''équation x = −2 est l''asymptote verticale ✓. Répondre x = 2 est une erreur de signe en résolvant x + 2 = 0, x = 3 lit le coefficient du numérateur, et y = 3 est l''asymptote horizontale — une limite finie à l''infini, pas une limite infinie en un point.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('75fc9ae9-900f-5c98-8207-baa94bff86af', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⚔️ Boss du chapitre ⭐⭐⭐ : Le gardien du seuil', 3, 120, 30, 'boss', 'admin', 2)
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
  ('45a47019-5722-586c-8211-35c6609f5eac', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'On considère l''affirmation : « Si f est continue sur [a ; b] et f(a) · f(b) < 0, alors l''équation f(x) = 0 admet une unique solution dans [a ; b]. » Cette affirmation est-elle vraie ou fausse ?', '[{"id":"a","text":"Vraie : le théorème des valeurs intermédiaires garantit à la fois l''existence et l''unicité de la solution"},{"id":"b","text":"Vraie : f(a) et f(b) étant de signes contraires, la courbe ne peut couper l''axe des abscisses qu''une seule fois"},{"id":"c","text":"Fausse : le théorème des valeurs intermédiaires exige f(a) · f(b) > 0"},{"id":"d","text":"Fausse : sans stricte monotonie, f peut s''annuler plusieurs fois sur [a ; b]"}]'::jsonb, 'd', 'L''affirmation est fausse ✓ : la continuité et le changement de signe garantissent au moins une annulation (TVI), mais jamais l''unicité — une fonction qui oscille peut couper l''axe des abscisses trois fois entre a et b. L''unicité exige en plus la stricte monotonie (corollaire de la bijection). Le piège courant : croire que le TVI livre existence et unicité d''un coup ; et le TVI demande bien des signes contraires, pas f(a) · f(b) > 0.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⭐⭐ Révision (type examen) : Lever les indéterminations', 2, 75, 15, 'practice', 'admin', 3)
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
  ('e5f35d28-19b0-5807-adc2-cc42ca5e625e', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'f est une fonction continue sur [1 ; 2] avec f(1) = −2 et f(2) = 1. Que peut-on affirmer, d''après le théorème des valeurs intermédiaires, pour l''équation f(x) = 0 ?', '[{"id":"a","text":"Elle admet au moins une solution dans [1 ; 2]"},{"id":"b","text":"Elle admet exactement une solution dans [1 ; 2]"},{"id":"c","text":"Elle n''admet aucune solution dans [1 ; 2]"},{"id":"d","text":"Sa solution est exactement x = 1,5"}]'::jsonb, 'a', 'f est continue sur [1 ; 2] et 0 est compris entre f(1) = −2 et f(2) = 1 : le TVI garantit au moins une solution dans [1 ; 2] ✓. Il ne garantit jamais l''unicité : il faudrait en plus la stricte monotonie (corollaire de la bijection), qui n''est pas donnée ici. Quant à 1,5, ce n''est que le milieu de l''intervalle, pas une solution certifiée.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6f055244-7690-5d90-b279-8c0785ee7e44', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '👑 Défi élite ⭐⭐⭐⭐ : L''épreuve du bachelier', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('0784b9f3-963c-5021-9ab6-bb87604c9d71', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Une fonction g est continue sur [0 ; 4], avec g(0) = 3 et g(4) = −1. Aucune autre information n''est donnée. Laquelle de ces affirmations est justifiée ?', '[{"id":"a","text":"L''équation g(x) = 0 admet au moins une solution dans [0 ; 4]"},{"id":"b","text":"L''équation g(x) = 0 admet exactement une solution dans [0 ; 4]"},{"id":"c","text":"L''équation g(x) = 4 admet au moins une solution dans [0 ; 4]"},{"id":"d","text":"g est strictement décroissante sur [0 ; 4]"}]'::jsonb, 'a', '0 est compris entre g(4) = −1 et g(0) = 3 : le théorème des valeurs intermédiaires garantit au moins une solution de g(x) = 0 dans [0 ; 4] ✓. L''erreur classique : conclure à une solution unique — l''unicité exigerait la stricte monotonie (corollaire de la bijection), non fournie ici ; de même, g(0) > g(4) n''implique pas que g décroît sur tout l''intervalle. Enfin, 4 n''est pas compris entre −1 et 3 : le TVI ne dit rien de l''équation g(x) = 4 (piège de l''encadrement de k oublié).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
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
  ('28b2f193-675b-52ec-8354-09cf1e8a4a6b', '6f055244-7690-5d90-b279-8c0785ee7e44', 'f est continue et strictement croissante sur [−2 ; 3], avec f(−2) = −4 et f(3) = 6. Pour quelles valeurs du réel k l''équation f(x) = k admet-elle exactement une solution dans [−2 ; 3] ?', '[{"id":"a","text":"k ∈ [−2 ; 3]"},{"id":"b","text":"k ∈ ]−4 ; 6["},{"id":"c","text":"k ∈ [−4 ; 6]"},{"id":"d","text":"k ∈ ℝ"}]'::jsonb, 'c', 'f étant continue et strictement croissante sur [−2 ; 3], elle réalise une bijection de [−2 ; 3] sur [f(−2) ; f(3)] = [−4 ; 6] : chaque k de [−4 ; 6] est atteint exactement une fois ✓ (corollaire du TVI). Les bornes sont incluses : k = −4 donne la solution x = −2 et k = 6 donne x = 3. L''erreur classique : exclure les bornes en répondant ]−4 ; 6[, confondre l''intervalle de départ [−2 ; 3] avec l''image, ou croire qu''une fonction strictement croissante atteint tout réel k.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('35d2cb52-661a-50a0-94d8-24590f6525d8', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🧩 Mission interactive ⭐ : L''atelier de l''apprenti analyste', 1, 50, 10, 'practice', 'admin', 5)
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
D''après ce tableau, combien de solutions au moins l''équation f(x) = 0 admet-elle sur [0 ; 4] ?', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"2"},{"id":"d","text":"4"}]'::jsonb, 'c', 'Le tableau montre deux changements de signe : de f(0) = 2 à f(1) = −1, puis de f(2) = −3 à f(3) = 1. Sur chacun des intervalles [0 ; 1] et [2 ; 3], f est continue et change de signe : le théorème des valeurs intermédiaires garantit au moins une solution dans chacun, donc au moins 2 solutions en tout ✓. Répondre 1 revient à s''arrêter au premier changement de signe ; 4 suppose une solution dans chaque colonne du tableau, alors qu''entre 3 et 4, f reste positive (aucun changement de signe) ; et 0 exige de lire la valeur 0 dans le tableau, ce que le TVI ne demande pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🌉 Histoire ⭐⭐⭐ : Le pont de la continuité', 3, 120, 30, 'boss', 'admin', 6)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('edb002de-0e7f-5b7c-8d12-039559657254', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🏛️ Annales Bac ⭐⭐⭐⭐ : Session principale — Continuité et limites', 4, 300, 60, 'challenge', 'admin', 7)
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
  ('9808b350-e59e-5b03-8df4-156a48f6313b', 'edb002de-0e7f-5b7c-8d12-039559657254', 'f est une fonction continue sur [0 ; 5] telle que f(0) = 2, f(2) = −1 et f(5) = 2. Aucune autre information n''est donnée. Laquelle de ces affirmations est justifiée par ces seules hypothèses ?', '[{"id":"a","text":"L''équation f(x) = 0 admet au moins deux solutions dans [0 ; 5]"},{"id":"b","text":"L''équation f(x) = 0 admet exactement deux solutions dans [0 ; 5]"},{"id":"c","text":"L''équation f(x) = 3 admet au moins une solution dans [0 ; 5]"},{"id":"d","text":"Le maximum de f sur [0 ; 5] est égal à 2"}]'::jsonb, 'a', 'Sur [0 ; 2] : f est continue et 0 est compris entre f(0) = 2 et f(2) = −1, donc le TVI fournit une solution α ∈ ]0 ; 2[ de f(x) = 0. Sur [2 ; 5] : 0 est compris entre f(2) = −1 et f(5) = 2, d''où une solution β ∈ ]2 ; 5[. Comme f(2) = −1 ≠ 0, on a bien α < 2 < β : au moins deux solutions ✓. L''erreur classique : annoncer « exactement deux » — sans stricte monotonie sur chaque morceau, f peut très bien s''annuler quatre fois ; invoquer le TVI pour f(x) = 3 alors que 3 n''est compris entre aucune des valeurs données (une fonction affine par morceaux passant par ces trois points ne dépasse jamais 2 ✓) ; et affirmer que le maximum vaut 2, alors que l''image d''un segment est [m ; M] où le maximum M peut être atteint à l''intérieur de l''intervalle et dépasser les valeurs connues aux trois points.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
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

