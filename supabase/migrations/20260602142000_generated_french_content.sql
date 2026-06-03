-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: french (Français)
-- Regenerate with: npm run content:build
-- Source of truth: content/french/
-- =========================================================

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language) VALUES
  ('french', 'Français', 'Grammaire, conjugaison, lexique, compréhension et production écrite — programme de 9ème année de base', 'Sagesse', 'subject-french', 'BookOpen', 2, 'fr')
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
      AND e.subject_id = 'french'
      AND e.source = 'admin'
      AND q.id NOT IN ('d7f2f2b1-7a71-5c8f-8684-6fe8a2a5b9f3', '50cce373-29a3-50c2-8dfb-6b123b7c0f09', '37b194e0-3e8e-55f3-ab43-d7de67825e3a', 'eccc5914-b0d5-5035-804e-16a2cefc1af6', 'fd092ac9-1a1b-5654-a751-1f1f28f5548a', '6fbb7ffb-02e9-5d41-a1b1-80ebf9561872', '11d792cc-0455-56d3-b00b-9145225ca97b', '9044bfb1-eeb6-54e1-a7d8-10408624f911', '8499fe2e-7b46-5dd1-a7e8-c679eb7bf64c', '079d8ed9-845f-5b08-9391-5984479ec84f', '276a92b0-0c54-5381-b57c-d86ad57b021e', 'aabce6d4-f8ce-58d2-8737-80d73b3f05c8', 'd645eccd-a5d0-5aeb-9284-79aab3b2de20', '4b8817ab-0b1e-5d97-9a7b-8fd6753ca908', '07e8045b-b474-56cb-88ee-a5cc0e713ffa', 'cff983e1-a078-56c3-96fc-1bc3c9f70b8e', '1e3fc6c2-7f49-579a-9766-20a7860eca17', '308d579a-062a-5895-abfd-e1a05a0356de', 'c19c1f96-69fa-5f06-a875-55bcfda850ce', '98016972-94e1-5f90-9b1e-f59b43d6b0ae', '851ee672-a02e-5b39-85ab-663ccff5fccd', '78994701-0a13-5aa5-b908-e0dc7fa8fd7a', '733b88c0-3f49-56a9-a7a5-beb1ccab73cf', '67a0c11d-ab91-59df-b1f1-e411d1e2cb95', '96225451-0ff2-5e30-ab72-ea01d8573838', 'ad7aa3eb-7915-51a2-8ad8-f71a33b99fb1', 'c3e2ab45-089e-5a99-b92a-87cbb5576dde', '36a444de-1993-5b9a-8fb0-9a5cfe7f77b6', 'fde829bd-4a35-5b7a-980b-d9373c4bb855', '6d7569dc-adcd-5490-8ab4-9e1252876fbc', '3b271bbf-7019-55aa-93bb-583c3fbb407a', '332e1995-cf27-5529-9e9c-87c94efb4982', '4c1cd36e-d806-5894-a665-34368ab1f4bc', '6abd4b21-6d1c-51e3-9607-d615dae991a3', '3d1e84a5-a743-5748-b970-cc7eda950ebc', 'f22c973f-b551-5ada-b930-ce0801010307', 'c124cc25-0734-5a92-811e-669baf60fa4b', 'a365e428-06ba-5c4e-b3fb-3b1eb755b102', '69045ed1-0311-55cc-a9d1-5ff08b74073c', '103b3b98-c5ec-5850-b280-83a2c4488045', 'b56fc225-0884-57fe-9604-a5f47069571c', 'eed4181b-dcbb-5ee2-b6e2-44685205a62e', 'd53a306c-aa47-55c3-b52a-3b76f508e771', '789d8fb4-ef9b-57a5-971b-67821be37f1a', '927e93ec-4461-53b5-9378-38ef71fbb9b2', '03c3a61a-f9aa-5183-a4e0-994f72750e44', '7b7368b8-68e7-5388-a30c-503e4d1dc5dd', 'b4beed3e-de76-5a9d-b807-84d386df921d', '6d3e559b-0449-57de-89b2-0ff23b9fd893', 'f2f3c849-25e9-53d0-b09e-4eff720714b2', '3ee10a83-a4d9-5855-bb7d-79425521b890', '2329c69b-07a0-5905-8d3b-82a269887104', '815783b6-b7f5-5dea-9eea-baaa8f7a3382', 'a2241625-9fa9-504f-841d-0b346289ca00', '1b86b32d-c59d-5d28-a86e-a87b3cd41919', '3fadd44b-aca0-5ece-b1a4-02766d4517e3', 'cbaa9f7f-4a56-5d1f-b53d-df4861ef1871', '83dfacbc-3c11-55bf-ad09-cc214abb3711', '1f4296d8-c07e-5e6d-b599-0022c8f72118', '3a935e4d-91f9-59c5-aed2-fbaedff745b6', 'e91167fb-6b84-515a-9848-d07949d71c90', '28997c99-1b74-5330-8272-d08f4682b8c8', 'ee97c631-820f-50c1-9de3-58f140893afa', '5f51a382-45ef-51f7-a25b-2e95a78d6c1f', '676a25e8-1769-5b86-945f-06f2bf2d8548', 'cc3b9212-5768-5113-ad7b-2ba9128d740f', '0b03e40f-b428-588f-8ccc-c9431e9e0fda', 'ba963d3c-68cf-5c49-b62e-344049caab0e', 'c394033c-66d8-548c-951c-5472f4c41c30', 'efa163b4-a341-5c43-9bfb-142a7b277fa7', 'a467a610-6abe-5eac-ba05-83a1fa8608f7', '1ba1108b-cd4f-590a-b3ce-0e1bb8b0a251', 'b7b276c1-df61-5015-a396-ac06265465c7', '1cd7fbf9-2cc6-5eb7-879f-94d9ee76d569', '120db6b4-7f11-50e3-bbd3-e8ab5cbe63ff', 'e29bdbfe-677e-5173-8a30-dc1ddc813fe8', '9e3d2494-fea2-5244-b1a6-622c5560913b', 'a8a55df7-3f25-5d5b-8ea5-5f14e3c12204', '5e344432-2f71-56d6-abf1-5c8c31d537c9', '24a82297-67c0-5306-9121-6efc815a919e', '9bfeec0f-5f54-5365-9c20-356635d68e1c', '73d9a740-8761-50f2-a74c-f66483150482', 'a08dc674-1ad0-5709-ac2a-91fb09b03e23', '1a654666-d0cf-5a81-9244-aad9397d5ddb', '1cfa6dc4-e445-543e-9cdf-1baae0c8f842', '00a19639-3883-5d3c-8924-c94faf49d549', 'db7ecffa-12db-5ebe-a71f-0b59145133eb', '4032fad4-617f-58e6-b390-53e4b2c6c1c6', '61ccedd3-9052-5b32-ab73-cd1879d56ae7', '6cc0e08b-af9c-5dce-b02f-5bd6587bd103', 'ed57c56c-2714-58cf-b436-afc5b1f0fb55', 'a704ca25-4e84-5194-ae74-d707994df17e', '3088ed38-3f25-5167-aa73-a51d2fb61486', '16ef4fd9-0bf8-5dcc-bcee-af59ae8bdb12', '64e55faa-0a53-52af-8b05-97dd07023788', '29b2923e-5b05-5c0d-abd3-f0e7bb7dd6eb');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'french' AND source = 'admin' AND id NOT IN ('e8b74863-3fe8-5aad-a426-621ef75ec7ef', '3b342ef2-05e7-53d3-bded-effe80517ef5', '03ebf9d6-a2d7-5967-b86c-70019206e357', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', '12f9cc53-1641-5e87-9958-ae1375000007', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'b89d641c-95d4-5820-875a-3bac22a2add4', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', '4758ebaf-51ff-5d37-b504-914009e31959', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'b3042e50-068f-5b9f-91d5-e64df884f924', '25f31af7-de92-57ff-93ce-e6dc3127c707', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', '981642c4-6f55-5171-897c-bdf40e984522');
DELETE FROM public.questions WHERE exercise_id IN ('e8b74863-3fe8-5aad-a426-621ef75ec7ef', '3b342ef2-05e7-53d3-bded-effe80517ef5', '03ebf9d6-a2d7-5967-b86c-70019206e357', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', '12f9cc53-1641-5e87-9958-ae1375000007', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'b89d641c-95d4-5820-875a-3bac22a2add4', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', '4758ebaf-51ff-5d37-b504-914009e31959', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'b3042e50-068f-5b9f-91d5-e64df884f924', '25f31af7-de92-57ff-93ce-e6dc3127c707', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', '981642c4-6f55-5171-897c-bdf40e984522') AND id NOT IN ('d7f2f2b1-7a71-5c8f-8684-6fe8a2a5b9f3', '50cce373-29a3-50c2-8dfb-6b123b7c0f09', '37b194e0-3e8e-55f3-ab43-d7de67825e3a', 'eccc5914-b0d5-5035-804e-16a2cefc1af6', 'fd092ac9-1a1b-5654-a751-1f1f28f5548a', '6fbb7ffb-02e9-5d41-a1b1-80ebf9561872', '11d792cc-0455-56d3-b00b-9145225ca97b', '9044bfb1-eeb6-54e1-a7d8-10408624f911', '8499fe2e-7b46-5dd1-a7e8-c679eb7bf64c', '079d8ed9-845f-5b08-9391-5984479ec84f', '276a92b0-0c54-5381-b57c-d86ad57b021e', 'aabce6d4-f8ce-58d2-8737-80d73b3f05c8', 'd645eccd-a5d0-5aeb-9284-79aab3b2de20', '4b8817ab-0b1e-5d97-9a7b-8fd6753ca908', '07e8045b-b474-56cb-88ee-a5cc0e713ffa', 'cff983e1-a078-56c3-96fc-1bc3c9f70b8e', '1e3fc6c2-7f49-579a-9766-20a7860eca17', '308d579a-062a-5895-abfd-e1a05a0356de', 'c19c1f96-69fa-5f06-a875-55bcfda850ce', '98016972-94e1-5f90-9b1e-f59b43d6b0ae', '851ee672-a02e-5b39-85ab-663ccff5fccd', '78994701-0a13-5aa5-b908-e0dc7fa8fd7a', '733b88c0-3f49-56a9-a7a5-beb1ccab73cf', '67a0c11d-ab91-59df-b1f1-e411d1e2cb95', '96225451-0ff2-5e30-ab72-ea01d8573838', 'ad7aa3eb-7915-51a2-8ad8-f71a33b99fb1', 'c3e2ab45-089e-5a99-b92a-87cbb5576dde', '36a444de-1993-5b9a-8fb0-9a5cfe7f77b6', 'fde829bd-4a35-5b7a-980b-d9373c4bb855', '6d7569dc-adcd-5490-8ab4-9e1252876fbc', '3b271bbf-7019-55aa-93bb-583c3fbb407a', '332e1995-cf27-5529-9e9c-87c94efb4982', '4c1cd36e-d806-5894-a665-34368ab1f4bc', '6abd4b21-6d1c-51e3-9607-d615dae991a3', '3d1e84a5-a743-5748-b970-cc7eda950ebc', 'f22c973f-b551-5ada-b930-ce0801010307', 'c124cc25-0734-5a92-811e-669baf60fa4b', 'a365e428-06ba-5c4e-b3fb-3b1eb755b102', '69045ed1-0311-55cc-a9d1-5ff08b74073c', '103b3b98-c5ec-5850-b280-83a2c4488045', 'b56fc225-0884-57fe-9604-a5f47069571c', 'eed4181b-dcbb-5ee2-b6e2-44685205a62e', 'd53a306c-aa47-55c3-b52a-3b76f508e771', '789d8fb4-ef9b-57a5-971b-67821be37f1a', '927e93ec-4461-53b5-9378-38ef71fbb9b2', '03c3a61a-f9aa-5183-a4e0-994f72750e44', '7b7368b8-68e7-5388-a30c-503e4d1dc5dd', 'b4beed3e-de76-5a9d-b807-84d386df921d', '6d3e559b-0449-57de-89b2-0ff23b9fd893', 'f2f3c849-25e9-53d0-b09e-4eff720714b2', '3ee10a83-a4d9-5855-bb7d-79425521b890', '2329c69b-07a0-5905-8d3b-82a269887104', '815783b6-b7f5-5dea-9eea-baaa8f7a3382', 'a2241625-9fa9-504f-841d-0b346289ca00', '1b86b32d-c59d-5d28-a86e-a87b3cd41919', '3fadd44b-aca0-5ece-b1a4-02766d4517e3', 'cbaa9f7f-4a56-5d1f-b53d-df4861ef1871', '83dfacbc-3c11-55bf-ad09-cc214abb3711', '1f4296d8-c07e-5e6d-b599-0022c8f72118', '3a935e4d-91f9-59c5-aed2-fbaedff745b6', 'e91167fb-6b84-515a-9848-d07949d71c90', '28997c99-1b74-5330-8272-d08f4682b8c8', 'ee97c631-820f-50c1-9de3-58f140893afa', '5f51a382-45ef-51f7-a25b-2e95a78d6c1f', '676a25e8-1769-5b86-945f-06f2bf2d8548', 'cc3b9212-5768-5113-ad7b-2ba9128d740f', '0b03e40f-b428-588f-8ccc-c9431e9e0fda', 'ba963d3c-68cf-5c49-b62e-344049caab0e', 'c394033c-66d8-548c-951c-5472f4c41c30', 'efa163b4-a341-5c43-9bfb-142a7b277fa7', 'a467a610-6abe-5eac-ba05-83a1fa8608f7', '1ba1108b-cd4f-590a-b3ce-0e1bb8b0a251', 'b7b276c1-df61-5015-a396-ac06265465c7', '1cd7fbf9-2cc6-5eb7-879f-94d9ee76d569', '120db6b4-7f11-50e3-bbd3-e8ab5cbe63ff', 'e29bdbfe-677e-5173-8a30-dc1ddc813fe8', '9e3d2494-fea2-5244-b1a6-622c5560913b', 'a8a55df7-3f25-5d5b-8ea5-5f14e3c12204', '5e344432-2f71-56d6-abf1-5c8c31d537c9', '24a82297-67c0-5306-9121-6efc815a919e', '9bfeec0f-5f54-5365-9c20-356635d68e1c', '73d9a740-8761-50f2-a74c-f66483150482', 'a08dc674-1ad0-5709-ac2a-91fb09b03e23', '1a654666-d0cf-5a81-9244-aad9397d5ddb', '1cfa6dc4-e445-543e-9cdf-1baae0c8f842', '00a19639-3883-5d3c-8924-c94faf49d549', 'db7ecffa-12db-5ebe-a71f-0b59145133eb', '4032fad4-617f-58e6-b390-53e4b2c6c1c6', '61ccedd3-9052-5b32-ab73-cd1879d56ae7', '6cc0e08b-af9c-5dce-b02f-5bd6587bd103', 'ed57c56c-2714-58cf-b436-afc5b1f0fb55', 'a704ca25-4e84-5194-ae74-d707994df17e', '3088ed38-3f25-5167-aa73-a51d2fb61486', '16ef4fd9-0bf8-5dcc-bcee-af59ae8bdb12', '64e55faa-0a53-52af-8b05-97dd07023788', '29b2923e-5b05-5c0d-abd3-f0e7bb7dd6eb');
DELETE FROM public.chapters c WHERE c.subject_id = 'french' AND c.id NOT IN ('5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', '383392ce-53c3-5d10-b090-6f6f48124bee') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', 'Les types et les formes de phrases', 'Les quatre types de phrases et les formes (affirmative/négative, active/passive, neutre/emphatique)', '# ⚔️ Les types et les formes de phrases

> 💡 « Maîtriser la phrase, c''est choisir l''arme exacte pour chaque intention : informer, questionner, ordonner ou s''exclamer. »

## 🏰 Les quatre types de phrases

Toute phrase appartient à **un seul** type, selon l''intention de celui qui parle.

| Type                  | Intention                   | Ponctuation | Exemple                     |
| --------------------- | --------------------------- | ----------- | --------------------------- |
| Déclaratif            | informer, raconter          | .           | Le héros franchit la porte. |
| Interrogatif          | poser une question          | ?           | Qui franchit la porte ?     |
| Impératif (injonctif) | donner un ordre, un conseil | . ou !      | Franchis la porte !         |
| Exclamatif            | exprimer une émotion        | !           | Quelle porte immense !      |

> 🗡️ La phrase **impérative** n''a pas de sujet exprimé : le verbe est à l''impératif (« Avance. », « Écoutons. »).

## ⚡ La phrase interrogative

On distingue deux constructions :

- **Interrogation totale** : la réponse est _oui / non_.
  _Viens-tu ? / Est-ce que tu viens ? / Tu viens ?_
- **Interrogation partielle** : elle porte sur un élément précis et utilise un mot interrogatif (_qui, que, où, quand, comment, pourquoi, combien_).
  _Où vas-tu ?_

L''**inversion du sujet** (_Viens-tu ?_) appartient au registre soutenu ; _est-ce que_ au registre courant.

## 🛡️ Les formes de la phrase

À son type, chaque phrase combine plusieurs **formes** :

### Forme affirmative / négative

- Affirmative : _Le dragon dort._
- Négative : _Le dragon **ne** dort **pas**._ (négation en deux mots : _ne… pas, ne… jamais, ne… plus, ne… rien_)

### Forme active / passive

- Active : _Le chevalier ouvre la porte._
- Passive : _La porte **est ouverte** par le chevalier._

### Forme neutre / emphatique

La forme **emphatique** met un élément en relief :

- par un présentatif : **\*C''est** le chevalier **qui** ouvre la porte.\*
- par un détachement : _Le chevalier, **il** ouvre la porte._

## 📐 Type et formes se combinent

Une même phrase a **un type** et **plusieurs formes** en même temps :

> _« N''avance pas ! »_ → type **impératif**, forme **négative**.
> _« Est-ce que cette porte n''est pas ouverte par le gardien ? »_ → type **interrogatif**, formes **négative** et **passive**.

## 🧪 Méthode : reconnaître une phrase

1. Je regarde la **ponctuation finale** et l''**intention** → je trouve le **type**.
2. Je cherche la **négation**, le verbe **passif**, l''**emphase** → je trouve les **formes**.

> 🏆 Tu sais maintenant identifier et transformer toute phrase : c''est la base de la grammaire et de la production écrite.', '# 📜 Résumé : Les types et les formes de phrases

- **4 types** (selon l''intention) : déclaratif (.), interrogatif (?), impératif/injonctif (. ou !), exclamatif (!).
- L''impératif n''a **pas de sujet exprimé**.
- **Interrogation** : totale (réponse oui/non) ou partielle (mot interrogatif : qui, où, quand, comment…). Inversion = soutenu ; _est-ce que_ = courant.
- **Formes** (cumulables) : affirmative / **négative** (ne… pas/jamais/plus/rien) ; active / **passive** (être + participe passé + _par_) ; neutre / **emphatique** (c''est… qui / détachement).
- Une phrase a **un seul type** mais **plusieurs formes** à la fois.
- Méthode : ponctuation + intention ⇒ type ; négation/passif/emphase ⇒ formes.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', 'Les propositions subordonnées', 'Proposition principale vs subordonnée et le subordonnant ; subordonnées relatives, complétives et circonstancielles avec leurs conjonctions.', '# ⚔️ Les propositions subordonnées

> 💡 « Comprendre la subordination, c''est apprendre à tisser des phrases complexes — l''arme secrète d''un guerrier de l''écrit. »

## 🏰 Proposition principale et proposition subordonnée

Une **phrase complexe** contient au moins deux propositions. La **proposition principale** (PP) est autonome : elle a un sens complet. La **proposition subordonnée** (PS) dépend de la principale ; elle ne peut pas se lire seule sans perdre son sens.

| Rôle        | Définition                                             | Exemple               |
| ----------- | ------------------------------------------------------ | --------------------- |
| Principale  | Proposition autonome, chef de la phrase                | _Je sais_ …           |
| Subordonnée | Proposition dépendante, introduite par un subordonnant | … _que tu réussiras._ |

Le **subordonnant** (conjonction de subordination, pronom relatif, etc.) est le mot qui relie la subordonnée à la principale et en indique la nature.

> 🗡️ Pour trouver la principale, supprime la subordonnée : la phrase qui reste a encore un sens = c''est la principale.

## ⚡ La subordonnée relative

La subordonnée relative **qualifie un nom** (ou un pronom) appelé **antécédent**. Elle est introduite par un **pronom relatif** :

| Pronom relatif | Fonction dans la subordonnée   | Exemple                                        |
| -------------- | ------------------------------ | ---------------------------------------------- |
| **qui**        | sujet                          | Le héros _qui combat_ le dragon est courageux. |
| **que / qu''**  | COD                            | Le livre _que tu lis_ est passionnant.         |
| **dont**       | complément (de, du, des…)      | L''épée _dont il se sert_ est magique.          |
| **où**         | complément de lieu ou de temps | La forêt _où il entra_ était sombre.           |

> 🛡️ **Astuce** : « dont » remplace toujours un groupe introduit par _de_ : _il se sert de l''épée_ → l''épée _dont_ il se sert.

### Accord du participe passé avec « que »

Quand la relative contient un verbe à un temps composé avec _avoir_, le participe passé s''accorde avec l''antécédent de _que_ :

- _Les batailles **que** nous avons **livrées**._ (féminin pluriel)

## 🛡️ La subordonnée complétive (conjonctive en « que »)

La subordonnée complétive est **COD du verbe principal**. Elle est introduite par la conjonction de subordination **que** (qu''). On peut souvent la remplacer par un groupe nominal ou le pronom _cela_.

- _Je crois **que le héros vaincra**._ → _Je crois cela._
- Verbes introducteurs fréquents : _dire, penser, croire, savoir, espérer, vouloir, sentir, voir, comprendre…_

> 💡 La complétive répond à la question « quoi ? » posée après le verbe principal.

## 🧪 Les subordonnées circonstancielles

Les subordonnées **circonstancielles** indiquent les circonstances de l''action principale (temps, cause, conséquence…). Chaque type a ses conjonctions propres.

### ⏱️ La subordonnée de temps

Elle indique _quand_ se déroule l''action principale.

| Conjonction                  | Nuance                     | Exemple                                       |
| ---------------------------- | -------------------------- | --------------------------------------------- |
| **quand / lorsque**          | simultanéité, postériorité | _Quand le soleil se lève_, le héros part.     |
| **avant que** (+ subjonctif) | antériorité                | _Avant qu''il parte_, elle lui remet l''épée.   |
| **après que** (+ indicatif)  | postériorité               | _Après qu''il eut vaincu_, la foule l''acclama. |
| **dès que / aussitôt que**   | simultanéité immédiate     | _Dès qu''il arriva_, le combat commença.       |
| **pendant que / tandis que** | simultanéité               | _Pendant qu''il dort_, les ennemis avancent.   |

### 🔥 La subordonnée de cause

Elle explique _pourquoi_ se produit l''action principale.

- **parce que** : cause directe — _Il a gagné **parce qu''il s''était entraîné**._
- **puisque** : cause connue des deux interlocuteurs — _**Puisque tu es là**, commençons._
- **comme** (en tête de phrase) : cause — _**Comme il pleuvait**, il prit son bouclier._

### 💥 La subordonnée de conséquence

Elle exprime _le résultat_ de l''action principale.

- **si bien que / de sorte que** (+ indicatif) — _Il s''entraîna si bien **que nul ne pouvait le battre**._
- **tellement… que / si… que** — _Il était **tellement** rapide **qu''on ne le voyait pas**._

### 🎯 La subordonnée de but

Elle exprime l''objectif visé. Toujours au **subjonctif**.

- **pour que / afin que** — _Il s''entraîne **pour que** son équipe **gagne**._
- **de peur que** (+ subjonctif + _ne_ explétif) — _Elle chuchote **de peur qu''on ne l''entende**._

### 🌀 La subordonnée de condition (hypothèse)

Elle pose une condition dont dépend la réalisation de l''action principale.

| Conjonction         | Mode et temps                                           | Exemple                                         |
| ------------------- | ------------------------------------------------------- | ----------------------------------------------- |
| **si**              | présent → futur (réel)                                  | _Si tu t''entraînes_, tu **vaincras**.           |
| **si**              | imparfait → conditionnel présent (éventuel)             | _Si tu t''entraînais_, tu **vaincrais**.         |
| **si**              | plus-que-parfait → conditionnel passé (irréel du passé) | _Si tu t''étais entraîné_, tu **aurais vaincu**. |
| **à condition que** | subjonctif                                              | _Il part **à condition que** tu **viennes**._   |

> 🗡️ Attention : après **si** de condition, on n''emploie jamais le futur ni le conditionnel.

### 🌿 La subordonnée de concession (opposition)

Elle exprime un fait qui devrait empêcher l''action principale, mais ne le fait pas.

- **bien que / quoique** (+ **subjonctif**) — _**Bien qu''il soit blessé**, il continue de combattre._
- **même si** (+ indicatif) — _**Même s''il pleut**, il partira._

## 📐 Tableau récapitulatif des circonstancielles

| Type        | Conjonctions principales                      | Mode habituel     |
| ----------- | --------------------------------------------- | ----------------- |
| Temps       | quand, lorsque, dès que, avant que, après que | Ind. / Subj.      |
| Cause       | parce que, puisque, comme                     | Indicatif         |
| Conséquence | si bien que, de sorte que, tellement… que     | Indicatif         |
| But         | pour que, afin que, de peur que               | Subjonctif        |
| Condition   | si, à condition que, pourvu que               | Ind. / Subj.      |
| Concession  | bien que, quoique, même si                    | Subj. / Indicatif |

> 🏆 Tu maîtrises maintenant la phrase complexe : principale + subordonnées relative, complétive et circonstancielles. C''est le cœur de la rédaction en 9ème !', '# 📜 Résumé : Les propositions subordonnées

- **Phrase complexe** = proposition principale (autonome) + proposition(s) subordonnée(s) (dépendantes, reliées par un **subordonnant**).
- **Subordonnée relative** : qualifie un antécédent ; pronoms relatifs : **qui** (sujet), **que** (COD), **dont** (compl. de), **où** (lieu/temps). Le participe passé s''accorde avec l''antécédent de _que_.
- **Subordonnée complétive** : COD du verbe principal, introduite par **que** ; remplaçable par _cela_.
- **Subordonnées circonstancielles** (indiquent les circonstances) :
  - **Temps** : _quand, lorsque, dès que, avant que_ (subj.), _après que_ (ind.)
  - **Cause** : _parce que, puisque, comme_ → indicatif
  - **Conséquence** : _si bien que, tellement… que_ → indicatif
  - **But** : _pour que, afin que_ → **subjonctif**
  - **Condition** : _si_ + présent/imparfait/plus-que-parfait (jamais futur ni conditionnel après _si_)
  - **Concession** : _bien que, quoique_ → **subjonctif** ; _même si_ → indicatif', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', 'La voix active et la voix passive', 'Définition des voix active et passive, règles de transformation, conservation des temps, complément d''agent et intérêt stylistique.', '# ⚔️ La voix active et la voix passive

> 💡 « Choisir entre la voix active et la voix passive, c''est décider qui prend la lumière : le héros qui agit, ou la cible qui subit l''action. »

## 🏰 Définitions : voix active et voix passive

Tout verbe d''action transitif peut être employé à deux **voix** :

| Voix        | Qui fait l''action ?     | Structure du GV                         | Exemple                                  |
| ----------- | ----------------------- | --------------------------------------- | ---------------------------------------- |
| **Active**  | Le sujet agit lui-même  | verbe conjugué normalement              | _Le chevalier frappe le dragon._         |
| **Passive** | Le sujet subit l''action | **être** conjugué + **participe passé** | _Le dragon est frappé par le chevalier._ |

> 🗡️ Seuls les verbes **transitifs directs** (qui ont un COD) peuvent se mettre à la voix passive. _Dormir_, _partir_, _ressembler à_ ne se mettent pas au passif.

## ⚡ La transformation active → passive

La règle en trois étapes :

1. Le **COD** de la phrase active devient le **sujet** de la phrase passive.
2. Le **sujet** de la phrase active devient le **complément d''agent** (introduit par **par** ou parfois **de**).
3. Le verbe est remplacé par **être (conjugué au même temps) + participe passé (accordé avec le nouveau sujet)**.

**Exemple au présent :**

- Active : _Le maître corrige **les copies**._
  - COD = « les copies » → nouveau sujet
  - Sujet = « le maître » → complément d''agent
- Passive : _**Les copies** sont corrigées **par le maître**._

> 🛡️ Le participe passé s''accorde **toujours** en genre et en nombre avec le sujet du verbe passif (nouveau sujet = ancien COD).

## 🛡️ La conservation du temps

Le temps du verbe ne change pas lors de la transformation. C''est le verbe **être** qui prend le temps de la phrase active :

| Temps de la phrase active | Forme passive correspondante    | Exemple                                    |
| ------------------------- | ------------------------------- | ------------------------------------------ |
| Présent                   | être au présent + p.p.          | _Le dragon est vaincu par le héros._       |
| Imparfait                 | être à l''imparfait + p.p.       | _Le dragon était vaincu par le héros._     |
| Passé composé             | être au passé composé + p.p.    | _Le dragon a été vaincu par le héros._     |
| Passé simple              | être au passé simple + p.p.     | _Le dragon fut vaincu par le héros._       |
| Plus-que-parfait          | être au plus-que-parfait + p.p. | _Le dragon avait été vaincu par le héros._ |
| Futur simple              | être au futur simple + p.p.     | _Le dragon sera vaincu par le héros._      |
| Conditionnel présent      | être au cond. présent + p.p.    | _Le dragon serait vaincu par le héros._    |

> 💡 Au passé composé et au plus-que-parfait passifs, l''auxiliaire est **avoir** pour conjuguer **être** : _a été_, _avait été_.

## 🧪 Le complément d''agent

Le **complément d''agent** désigne celui qui accomplit l''action dans une phrase passive. Il est introduit par :

- **par** : dans la majorité des cas — _détruite **par** l''armée_
- **de** : avec certains verbes d''état ou de sentiment (_aimé de tous_, _entouré de ses amis_, _connu de tout le village_)

### Quand le complément d''agent est absent

Il arrive que la phrase passive **n''ait pas de complément d''agent** : on ne sait pas (ou on ne veut pas dire) qui fait l''action.

- _La ville a été détruite._ (on ne précise pas qui a détruit)
- _Ce texte est souvent lu._ (le lecteur reste indéfini)

> 🗡️ L''absence de complément d''agent est fréquente quand l''agent est inconnu, sans importance ou volontairement tu.

## 📐 La transformation passive → active

Pour revenir à la voix active, on inverse les étapes :

1. Le **sujet** de la phrase passive devient le **COD**.
2. Le **complément d''agent** devient le **sujet**.
3. On remplace **être + p.p.** par le verbe conjugué au même temps.

**Exemple :**

- Passive : _La porte a été fermée par la sentinelle._
- Active : _La sentinelle a fermé la porte._

> ⚠️ Si la phrase passive n''a pas de complément d''agent, on utilise le sujet indéfini **on** à la voix active : _La porte a été fermée._ → _**On** a fermé la porte._

## 🌟 L''intérêt stylistique de la voix passive

Le choix entre voix active et voix passive n''est pas neutre : il sert à mettre en valeur l''information que l''on juge la plus importante.

- **Voix active** : met en avant **celui qui agit** (le sujet-agent).
  _Le journaliste révèle la vérité._ → l''accent est sur le journaliste.

- **Voix passive** : met en avant **celui qui subit** (l''objet devenu sujet).
  _La vérité est révélée par le journaliste._ → l''accent est sur la vérité.

- **Voix passive sans agent** : utile pour **dépersonnaliser** ou **présenter un fait général**.
  _Les règles doivent être respectées._ → peu importe qui respecte.

> 🏆 Tu connais maintenant les deux voix : active pour mettre l''agent au premier plan, passive pour mettre la cible en lumière. Maîtriser ce choix, c''est maîtriser le style !

## 🧩 Récapitulatif visuel

| Élément            | Voix active               | Voix passive                       |
| ------------------ | ------------------------- | ---------------------------------- |
| Sujet              | Fait l''action (agent)     | Subit l''action (patient)           |
| Verbe              | Conjugué normalement      | **être** + participe passé accordé |
| Complément d''agent | Absent (c''est le sujet)   | Introduit par **par** ou **de**    |
| Accord du p.p.     | Avec le COD (règle avoir) | Avec le sujet (toujours)           |', '# 📜 Résumé : La voix active et la voix passive

- **Voix active** : le sujet fait l''action — _Le héros frappe le dragon._
- **Voix passive** : le sujet subit l''action — structure **être (conjugué) + participe passé accordé** — _Le dragon est frappé par le héros._
- Seuls les verbes **transitifs directs** (avec un COD) peuvent se mettre au passif.
- **Transformation active → passive** : COD → sujet ; sujet → complément d''agent (par/de) ; même temps du verbe (porté par être).
- Le **participe passé s''accorde** toujours en genre et en nombre avec le sujet du verbe passif.
- **Complément d''agent** : introduit par **par** (cas général) ou **de** (verbes d''état/sentiment). Il peut être **absent** (agent inconnu ou tu → on à la voix active).
- **Intérêt stylistique** : la voix active met l''agent en avant ; la voix passive met la cible en avant ou dépersonnalise.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', 'Le discours direct et le discours indirect', 'Rapporter les paroles de quelqu''un : ponctuation du discours direct, passage au discours indirect (subordination, concordance des temps, changements de pronoms et d''indicateurs spatio-temporels) et l''interrogation indirecte.', '# ⚔️ Le discours direct et le discours indirect

> 💡 « Rapporter les paroles d''un autre, c''est une arme rhétorique : maîtrise la transmission pour ne jamais trahir le message. »

## 🏰 Le discours direct — définition et ponctuation

Le **discours direct** reproduit les paroles telles qu''elles ont été prononcées, sans les modifier.

**Signes distinctifs :**

| Signe              | Rôle                                    | Exemple                                  |
| ------------------ | --------------------------------------- | ---------------------------------------- |
| Deux-points ( : )  | annonce les paroles                     | Il dit :                                 |
| Guillemets (« … ») | encadrent les paroles                   | « Je suis prêt. »                        |
| Tiret ( — )        | change d''interlocuteur dans un dialogue | — Où vas-tu ?                            |
| Verbe introducteur | indique qui parle et sur quel ton       | dit, répondit, s''écria, demanda, affirma |

**Exemple de dialogue :**

> Le héros s''écria : « Je vaincrai le dragon ! »
> — Impossible ! répondit le garde. — Je suis le plus fort ! rétorqua le héros.

> 🗡️ Les **verbes introducteurs** les plus courants : _dire, affirmer, répondre, demander, s''écrier, chuchoter, répliquer, annoncer, ajouter, déclarer_.

## ⚡ Le discours indirect — définition et subordination

Le **discours indirect** intègre les paroles dans la phrase principale à l''aide d''une **proposition subordonnée**.

| Type de phrase rapportée    | Outil de subordination            | Exemple                                 |
| --------------------------- | --------------------------------- | --------------------------------------- |
| Phrase déclarative          | **que**                           | Il dit qu''il est prêt.                  |
| Question totale (oui/non)   | **si**                            | Il demande si tu viens.                 |
| Question partielle (mot Q.) | **ce que / ce qui / où / quand…** | Il demande où tu vas. / ce que tu fais. |
| Ordre (impératif)           | **de** + infinitif                | Il lui ordonne de partir.               |

> 🛡️ Attention : après un verbe introducteur à la forme négative ou interrogative, l''outil reste identique — c''est la subordonnée qui change de sens.

## 🧪 Les changements de pronoms personnels

Passer au discours indirect oblige à **adapter les pronoms** selon le contexte :

- **1re personne → 3e personne** (si le narrateur ≠ personnage) :
  - DD : « **Je** suis fatigué. » → DI : Il dit qu''**il** est fatigué.
- **2e personne → 3e personne** (si l''interlocuteur change de rôle) :
  - DD : « **Tu** dois étudier. » → DI : Il lui dit qu''**il** doit étudier.

> ⚡ Règle d''or : relis la phrase au DI pour vérifier qu''on sait toujours **qui** fait l''action et **à qui** on parle.

## 📐 La concordance des temps (changements verbaux)

Quand le verbe introducteur est au **passé**, les temps de la subordonnée changent :

| Discours direct | Discours indirect (verbe introducteur au passé) |
| --------------- | ----------------------------------------------- |
| Présent         | → Imparfait                                     |
| Passé composé   | → Plus-que-parfait                              |
| Futur simple    | → Conditionnel présent                          |
| Futur antérieur | → Conditionnel passé                            |
| Impératif       | → de + infinitif                                |

**Exemples :**

- « Je **travaille**. » → Il dit qu''il **travaillait**.
- « J''**ai fini**. » → Il dit qu''il **avait fini**.
- « Je **viendrai**. » → Il dit qu''il **viendrait**.

> 💡 Si le verbe introducteur est au **présent**, les temps ne changent **pas**.
> _Il dit qu''il **est** fatigué._ (présent → présent)

## 🌐 Les changements d''indicateurs de temps et de lieu

Les expressions de temps et de lieu doivent également s''adapter :

| Discours direct      | Discours indirect               |
| -------------------- | ------------------------------- |
| aujourd''hui          | ce jour-là                      |
| hier                 | la veille                       |
| avant-hier           | l''avant-veille                  |
| demain               | le lendemain                    |
| après-demain         | le surlendemain                 |
| la semaine prochaine | la semaine suivante             |
| la semaine dernière  | la semaine précédente / d''avant |
| maintenant           | alors / à ce moment-là          |
| ici                  | là / là-bas                     |
| ce matin / ce soir   | ce matin-là / ce soir-là        |

**Exemple :**

- DD : « **Demain**, nous partons **ici**. »
- DI : Il annonça que **le lendemain**, ils partiraient **là**.

## 🔎 L''interrogation indirecte

Transformer une **question directe** en question indirecte :

- La phrase perd le **point d''interrogation**.
- Pas d''inversion du sujet après le mot interrogatif.
- On utilise les outils : **si** (question totale), **ce qui / ce que / où / quand / comment / pourquoi / combien** (questions partielles).

| Question directe             | Question indirecte                   |
| ---------------------------- | ------------------------------------ |
| « Viens-tu ? »               | Il demande **si** tu viens.          |
| « Qu''est-ce que tu fais ? »  | Il demande **ce que** tu fais.       |
| « Qu''est-ce qui se passe ? » | Il demande **ce qui** se passe.      |
| « Où vas-tu ? »              | Il demande **où** tu vas.            |
| « Pourquoi pleure-t-il ? »   | Il demande **pourquoi** il pleure.   |
| « Comment s''appelle-t-il ? » | Il demande **comment** il s''appelle. |

> 🗡️ Attention à « qu''est-ce que » → **ce que** et « qu''est-ce qui » → **ce qui** : ne jamais garder « est-ce que » au discours indirect.

## 🏆 Méthode : passer du DD au DI en 4 étapes

1. **Repère** le verbe introducteur et son temps.
2. **Choisis** l''outil de subordination selon le type de phrase rapportée.
3. **Adapte** les pronoms personnels (qui parle ? à qui ?).
4. **Applique** la concordance des temps et change les indicateurs de temps/lieu si nécessaire.

> 🏆 En maîtrisant ces quatre étapes, tu transformes n''importe quelle parole rapportée sans faute. C''est la compétence clé de la production écrite au niveau 9ème !', '# 📜 Résumé : Le discours direct et le discours indirect

- **Discours direct (DD)** : paroles reproduites telles quelles — annoncées par un verbe introducteur, encadrées par des guillemets « … » ou introduites par un tiret (—) dans un dialogue.
- **Verbes introducteurs** courants : _dire, affirmer, demander, répondre, s''écrier, ordonner, chuchoter_.
- **Passage au DI** : on intègre les paroles dans une subordonnée introduite par :
  - **que** → phrase déclarative
  - **si** → question totale (oui/non)
  - **ce que / ce qui / où / quand / comment / pourquoi / combien** → question partielle
  - **de + infinitif** → ordre (impératif)
- **Changements de pronoms** : adapter selon qui parle et à qui (souvent 1re/2e personne → 3e personne).
- **Concordance des temps** (verbe introducteur au passé) :
  - présent → imparfait
  - passé composé → plus-que-parfait
  - futur simple → conditionnel présent
  - impératif → de + infinitif
- **Indicateurs de temps/lieu** : aujourd''hui → ce jour-là ; demain → le lendemain ; hier → la veille ; ici → là ; maintenant → alors.
- **Interrogation indirecte** : pas de point d''interrogation, pas d''inversion du sujet ; « qu''est-ce que » → ce que ; « qu''est-ce qui » → ce qui.
- Méthode en 4 étapes : verbe introducteur → outil de subordination → pronoms → temps et indicateurs.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', 'Les modes et les temps verbaux', 'Les modes personnels (indicatif, subjonctif, conditionnel, impératif) et leurs valeurs ; les principaux temps de l''indicatif et leurs emplois ; le subjonctif présent et le conditionnel présent ; distinction temps simples / temps composés.', '# ⚔️ Les modes et les temps verbaux

> 💡 « Le verbe est le cœur de la phrase : choisir le bon mode et le bon temps, c''est donner à tes mots leur pleine puissance. »

## 🏰 Les modes personnels — vue d''ensemble

Un **mode** exprime la manière dont le locuteur envisage l''action. Les modes **personnels** se conjuguent avec un sujet.

| Mode         | Valeur principale                            | Exemple                    |
| ------------ | -------------------------------------------- | -------------------------- |
| Indicatif    | fait réel, certain ou daté                   | Il part. / Il partira.     |
| Subjonctif   | fait envisagé, souhaité, douteux             | Il faut qu''il parte.       |
| Conditionnel | fait soumis à une condition, hypothèse, poli | Il partirait s''il pouvait. |
| Impératif    | ordre, conseil, prière                       | Pars maintenant !          |

> 🗡️ Les modes **impersonnels** (infinitif, participe, gérondif) n''ont pas de sujet propre et ne varient pas en personne — on les étudiera en détail dans un prochain chapitre.

## ⚡ Les temps simples et les temps composés

- **Temps simple** : une seule forme verbale. _Il chante. / Il chantait. / Il chantera._
- **Temps composé** : auxiliaire (**avoir** ou **être**) + participe passé. _Il a chanté. / Il avait chanté._

| Temps simple | Temps composé correspondant |
| ------------ | --------------------------- |
| Présent      | Passé composé               |
| Imparfait    | Plus-que-parfait            |
| Passé simple | Passé antérieur             |
| Futur simple | Futur antérieur             |

> 🛡️ Le temps composé exprime une action **antérieure** et **accomplie** par rapport au temps simple de la même série.

## 🧪 L''indicatif — les principaux temps et leurs emplois

### Le présent de l''indicatif

- Action qui se déroule **au moment** où on parle : _Le dragon **rugit**._
- Vérité générale, habitude : _L''eau **bout** à 100 °C. / Il **lit** chaque soir._
- Présent de narration (récit) : rend un événement passé plus vivant : _Soudain, le héros **lève** son épée._

### L''imparfait

- Action **en cours** dans le passé (durée, habitude répétée) : _Chaque matin, il **s''entraînait**._
- Description, contexte dans un récit : _Le ciel **était** gris. Les arbres **bruissaient**._
- Imparfait de simultanéité avec une action soudaine au passé simple : _Il **dormait** quand le monstre **surgit**._

### Le passé simple

- Action **ponctuelle**, **achevée**, qui fait avancer le récit (littéraire) : _Il **saisit** l''épée et **frappa**._
- S''oppose à l''imparfait (fond / événement) dans la narration.

### Le passé composé

- Action **achevée** dont les effets restent présents, ou situées dans un temps **non révolu** : _J''**ai terminé** ma quête. / Ce matin, il **a gagné**._
- Remplace souvent le passé simple à l''oral et dans les textes courants.

### Le futur simple

- Action à venir, certaine ou probable : _Demain, nous **affronterons** le boss final._
- Expression d''un ordre poli : _Tu **feras** tes devoirs ce soir._

### Le plus-que-parfait

- Action **antérieure** à une autre action passée : _Elle **avait étudié** avant qu''il arrive._
- Complète l''imparfait ou le passé simple dans un récit.

> 💡 Astuce mémo : imparfait = décor (fond) ; passé simple = flash (action) ; plus-que-parfait = encore plus loin dans le passé.

## 📐 Le subjonctif présent — emplois

Le subjonctif exprime le **possible**, le **souhaité**, le **douteux** ou l''**exigé**.

**Constructions déclenchantes :**

- **Il faut que** + subjonctif : _Il faut que tu **finisses** ce niveau._
- **Pour que** + subjonctif : _Je t''explique pour que tu **comprennes**._
- **Bien que / quoique** + subjonctif : _Bien qu''il **soit** fatigué, il continue._
- **à moins que** + subjonctif : _À moins qu''il **vienne**, nous partirons._
- **Vouloir que, souhaiter que, craindre que** + subjonctif.
- **Douter que, ne pas croire que** + subjonctif.

**Formation :** radical de la 3e personne du pluriel du présent de l''indicatif + terminaisons : _-e, -es, -e, -ions, -iez, -ent_.

| Infinitif | Radical (ils finissent) | Subjonctif présent (il) |
| --------- | ----------------------- | ----------------------- |
| finir     | finiss-                 | qu''il finisse           |
| venir     | vienn-                  | qu''il vienne            |
| faire     | fass-                   | qu''il fasse             |
| être      | (irrég.)                | qu''il soit              |
| avoir     | (irrég.)                | qu''il ait               |

> 🗡️ Attention : **être** → _soit, sois, soit, soyons, soyez, soient_ ; **avoir** → _aie, aies, ait, ayons, ayez, aient_.

## 🌐 Le conditionnel présent — valeurs

Le conditionnel présent se forme sur le **radical du futur simple** + les terminaisons de l''**imparfait** : _-ais, -ais, -ait, -ions, -iez, -aient_.

| Valeur                                    | Exemple                                               |
| ----------------------------------------- | ----------------------------------------------------- |
| Hypothèse (si + imparfait → conditionnel) | Si j''étudiais plus, j''**aurais** de meilleures notes. |
| Politesse                                 | Je **voudrais** un conseil, s''il vous plaît.          |
| Information non confirmée                 | Le champion **serait** blessé.                        |
| Futur dans le passé (DI)                  | Il dit qu''il **viendrait** demain.                    |

> ⚡ Structure clé : **Si** + imparfait → conditionnel présent (jamais « si » + conditionnel !).

## 🔎 L''impératif — emplois et formes

L''impératif exprime **l''ordre**, le **conseil** ou la **prière**. Il n''a que **3 personnes** (sans sujet exprimé) : 2e sg., 1re pl., 2e pl.

| Personne | Exemple (aller) | Exemple (finir) |
| -------- | --------------- | --------------- |
| 2e sg.   | Va !            | Finis !         |
| 1re pl.  | Allons !        | Finissons !     |
| 2e pl.   | Allez !         | Finissez !      |

> 🛡️ Les verbes du 1er groupe et **aller** perdent le **-s** à la 2e personne du singulier : _Mange ! / Va !_ — sauf devant _-y_ ou _-en_ : _Vas-y ! Manges-en !_

## 🏆 Méthode : choisir le bon mode et le bon temps

1. Quel est le **mode** ? → Indicatif (réel/certain), subjonctif (subordonnée exigeante), conditionnel (hypothèse/politesse), impératif (ordre).
2. Quel est le **rapport au temps** ? → présent / passé / futur.
3. L''action est-elle **simple** (en cours / habituelle) ou **composée** (accomplie / antérieure) ?
4. **Concordance** : dans une subordonnée ou un DI, vérifie que le temps de la subordonnée correspond bien au verbe principal.

> 🏆 Maîtriser modes et temps, c''est écrire et parler avec précision — la marque du guerrier de la langue française !', '# 📜 Résumé : Les modes et les temps verbaux

- **4 modes personnels** : indicatif (fait réel/certain), subjonctif (fait envisagé/douteux/exigé), conditionnel (hypothèse/politesse), impératif (ordre/conseil — 3 personnes sans sujet).
- **Temps simples / composés** : composé = auxiliaire + participe passé ; exprime l''antériorité et l''accompli par rapport au temps simple correspondant.
- **Principaux temps de l''indicatif** :
  - Présent : action en cours, habitude, vérité générale, présent de narration.
  - Imparfait : durée/habitude dans le passé, description, contexte (fond du récit).
  - Passé simple : action ponctuelle et achevée qui fait avancer le récit (littéraire).
  - Passé composé : action achevée dans un temps non révolu, emploi oral/courant.
  - Futur simple : action à venir certaine ou probable ; ordre poli.
  - Plus-que-parfait : action antérieure à une autre action passée.
- **Subjonctif présent** : après _il faut que, pour que, bien que, à moins que, vouloir que, craindre que, douter que_… Formation : radical de _ils_ au présent + _-e, -es, -e, -ions, -iez, -ent_. Irréguliers clés : _soit, ait_.
- **Conditionnel présent** : radical du futur + terminaisons de l''imparfait (_-ais…_). Valeurs : hypothèse (si + imparfait → conditionnel), politesse, information non confirmée, futur dans le passé (DI).
- **Règle du « si »** : _si_ + imparfait → conditionnel présent (jamais _si_ + conditionnel).
- **Impératif** : 2e sg. (sans _-s_ pour les verbes en _-er_ et _aller_), 1re pl., 2e pl. Exceptions : _vas-y, manges-en_.
- Méthode : mode → rapport au temps → simple/composé → concordance.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', 'La concordance des temps', 'Maîtriser l''enchaînement des temps verbaux dans le récit au passé, dans la subordonnée au subjonctif et dans le discours indirect.', '# ⚔️ La concordance des temps

> 💡 « Chaque temps verbal est une pièce d''armure : bien les assembler, c''est construire un récit sans faille. »

## 🏰 Qu''est-ce que la concordance des temps ?

La **concordance des temps** est la règle qui impose d''adapter le temps du verbe d''une proposition subordonnée au temps du verbe de la proposition principale (ou du verbe introducteur). Elle assure la cohérence temporelle du texte.

On l''applique principalement dans trois contextes :

- le **récit au passé** (temps du récit : passé simple, imparfait, plus-que-parfait) ;
- les **subordonnées au subjonctif** (après certains verbes ou expressions) ;
- le **discours indirect** (transformation des paroles rapportées).

## ⚡ Les temps du récit au passé

Dans un texte narratif au passé, trois temps se partagent les rôles :

| Temps                | Rôle dans le récit                                     | Exemple                                            |
| -------------------- | ------------------------------------------------------ | -------------------------------------------------- |
| **Passé simple**     | Action principale, événement bref et délimité          | Le chevalier _franchit_ la porte.                  |
| **Imparfait**        | Description, action de fond, action répétée ou durable | La salle _était_ sombre ; des torches _brûlaient_. |
| **Plus-que-parfait** | Action antérieure à une autre action passée            | Il avait _entraîné_ ses troupes avant la bataille. |

> 🗡️ Le **plus-que-parfait** est formé de l''auxiliaire à l''imparfait (_avait_, _était_) + participe passé. Il marque toujours une **antériorité** par rapport à une autre action passée.

## 🛡️ Antériorité, simultanéité, postériorité

Les relations temporelles entre deux actions se marquent ainsi :

- **Simultanéité** (les deux actions se passent en même temps) :
  _Pendant qu''il **courait**, la tempête **faisait** rage._ (imparfait + imparfait)

- **Antériorité** (une action avant l''autre) :
  _Quand il **eut fini** son discours, les guerriers **partirent**._ (passé antérieur + passé simple)
  _Il **avait préparé** son plan avant de **lancer** l''attaque._ (plus-que-parfait + passé simple)

- **Postériorité** (une action après l''autre) :
  _Il **décida** qu''il **allait** affronter le dragon._ (passé simple + imparfait)

> 💡 Le **passé antérieur** (auxiliaire au passé simple + participe passé) s''emploie dans les subordonnées introduites par _quand_, _lorsque_, _dès que_, _après que_ pour marquer l''antériorité immédiate par rapport à un verbe au passé simple.

## 🔮 La concordance dans la subordonnée au subjonctif

Quand la principale est au présent ou au futur, la subordonnée au subjonctif se met au **subjonctif présent** :

_Je veux que tu **viennes** me rejoindre._

Quand la principale est au passé ou au conditionnel, la subordonnée se met au **subjonctif imparfait** (registre soutenu) :

_Il voulait que tu **vinsses** me rejoindre._ (langue littéraire)

> 🏆 Au collège, le subjonctif imparfait reste réservé aux textes littéraires ; dans les écrits courants, on préfère le subjonctif présent même quand la principale est au passé.

## 🌀 La concordance dans le discours indirect

Quand on passe du **discours direct** au **discours indirect** avec un verbe introducteur au **passé**, les temps changent selon ce tableau :

| Discours direct | Discours indirect (verbe introducteur au passé) |
| --------------- | ----------------------------------------------- |
| Présent         | Imparfait                                       |
| Passé composé   | Plus-que-parfait                                |
| Futur simple    | Conditionnel présent                            |
| Futur antérieur | Conditionnel passé                              |
| Impératif       | Infinitif (ou subjonctif)                       |

**Exemples :**

- _Il dit : « Je **suis** prêt. »_ → _Il dit qu''il **était** prêt._
- _Il dit : « J''**ai vaincu** le dragon. »_ → _Il dit qu''il **avait vaincu** le dragon._
- _Il dit : « Je **partirai** demain. »_ → _Il dit qu''il **partirait** le lendemain._
- _Il dit : « **Viens** ici ! »_ → _Il lui dit de **venir** là._

> 🗡️ Les indicateurs de temps et de lieu changent aussi : _maintenant_ → _alors_ ; _aujourd''hui_ → _ce jour-là_ ; _demain_ → _le lendemain_ ; _hier_ → _la veille_ ; _ici_ → _là_.

## 🧪 Méthode : appliquer la concordance

1. **Identifier le verbe introducteur** (principal) et son temps.
2. **Déterminer la relation temporelle** entre les deux actions (simultanée, antérieure, postérieure).
3. **Choisir le temps** de la subordonnée selon le tableau.
4. **Vérifier** la cohérence des indicateurs temporels et spatiaux.

> 🏆 La maîtrise de la concordance des temps, c''est le niveau légendaire du récit : chaque temps à sa place, l''histoire coule sans accroc.

## 📐 Récapitulatif visuel

```
Verbe principal au PASSÉ
  ├── action simultanée      →  IMPARFAIT
  ├── action antérieure      →  PLUS-QUE-PARFAIT
  └── action postérieure     →  CONDITIONNEL PRÉSENT (discours indirect)
                               IMPARFAIT (récit : allait + infinitif)

Discours direct → indirect (verbe introducteur au passé)
  présent        →  imparfait
  passé composé  →  plus-que-parfait
  futur          →  conditionnel
```', '# 📜 Résumé : La concordance des temps

- **Récit au passé** : passé simple (action principale), imparfait (description/fond), plus-que-parfait (antériorité).
- **Antériorité** : plus-que-parfait (ou passé antérieur dans les subordonnées avec _quand/dès que_) avant un passé simple.
- **Simultanéité** : imparfait + imparfait (_pendant que…_).
- **Postériorité** : passé simple + imparfait (_allait + infinitif_) dans le récit.
- **Subjonctif** : principale au présent/futur → subjonctif présent ; principale au passé → subjonctif imparfait (registre soutenu).
- **Discours indirect** (verbe introducteur au passé) :
  - présent → **imparfait**
  - passé composé → **plus-que-parfait**
  - futur → **conditionnel présent**
  - futur antérieur → **conditionnel passé**
  - impératif → **infinitif**
- Les indicateurs de temps/lieu changent aussi : _demain_ → _le lendemain_, _hier_ → _la veille_, _ici_ → _là_, etc.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', 'Le lexique et les figures de style', 'Former les mots, enrichir son vocabulaire et reconnaître les principales figures de style pour lire et écrire avec précision.', '# ⚔️ Le lexique et les figures de style

> 💡 « Les mots sont les armes du guerrier de l''écriture : en connaître la formation, le sens et les ornements, c''est forger une lame invincible. »

## 🏰 La formation des mots

Un mot est souvent composé de plusieurs éléments :

| Élément     | Définition                                                              | Exemple                                          |
| ----------- | ----------------------------------------------------------------------- | ------------------------------------------------ |
| **Radical** | La partie centrale qui porte le sens de base                            | _port_ dans _porter_, _transport_, _apport_      |
| **Préfixe** | Élément placé **avant** le radical pour modifier le sens                | _im-_ dans _impossible_ ; _re-_ dans _relire_    |
| **Suffixe** | Élément placé **après** le radical pour changer la catégorie ou le sens | _-eur_ dans _nageur_ ; _-ment_ dans _rapidement_ |

> 🗡️ La **famille de mots** regroupe tous les mots qui partagent le même radical : _terre_, _enterrer_, _terrestre_, _territoire_, _déterrer_ forment une famille.

### Quelques préfixes courants

- _in-_ / _im-_ / _il-_ / _ir-_ = privatif : _inégal_, _impossible_, _illisible_, _irréel_
- _re-_ / _ré-_ = répétition ou retour : _relire_, _réorganiser_
- _pré-_ = avant : _prévoir_, _préhistoire_
- _sur-_ = au-dessus / excès : _surpasser_, _surévaluer_
- _sous-_ = insuffisance : _sous-estimer_, _souterrain_

### Quelques suffixes courants

- _-eur_ / _-rice_ : nom d''agent (personne qui fait) → _nageur_, _actrice_
- _-tion_ / _-sion_ : nom d''action → _construction_, _décision_
- _-ment_ : adverbe de manière → _rapidement_, _doucement_
- _-able_ / _-ible_ : possibilité → _lisible_, _aimable_

## ⚡ Champ lexical et champ sémantique

- Le **champ lexical** d''un thème regroupe tous les mots (de catégories grammaticales variées) qui s''y rapportent.
  _Champ lexical de la guerre_ : combat, ennemi, bataille, vaincre, guerrier, assaut, victoire…

- Le **champ sémantique** d''un mot regroupe tous les sens différents que ce mot peut prendre selon le contexte.
  _Le mot « feu »_ : incendie (sens courant) ; passion (sens figuré) ; signal lumineux (sens technique).

> 💡 Pour analyser un texte, repérer le champ lexical dominant permet d''identifier le thème principal.

## 🛡️ Synonymes, antonymes, homonymes, paronymes

| Relation      | Définition                                             | Exemple                                                                  |
| ------------- | ------------------------------------------------------ | ------------------------------------------------------------------------ |
| **Synonymes** | Mots de sens voisin ou équivalent                      | _courageux_ / _vaillant_ / _intrépide_                                   |
| **Antonymes** | Mots de sens contraire                                 | _victoire_ / _défaite_ ; _fort_ / _faible_                               |
| **Homonymes** | Mots de prononciation identique mais de sens différent | _verre_ (récipient) / _vers_ (poème) / _vert_ (couleur) / _ver_ (animal) |
| **Paronymes** | Mots de forme proche mais de sens différent            | _éruption_ / _irruption_ ; _collision_ / _collusion_                     |

> 🗡️ Attention aux paronymes : confondre _accepter_ et _excepter_, ou _éminent_ et _imminent_, est une erreur fréquente à l''examen.

## 🔮 Sens propre, sens figuré — dénotation et connotation

- Le **sens propre** (ou littéral) est le sens premier, concret et objectif d''un mot.
  _Les flammes dévoraient la forêt._ (sens propre de « dévorer »)

- Le **sens figuré** est un sens second, imagé ou métaphorique.
  _La jalousie dévorait son cœur._ (sens figuré de « dévorer »)

- La **dénotation** est le sens objectif et neutre d''un mot, partagé par tous.
  Le mot _serpent_ → reptile sans pattes.

- La **connotation** est l''ensemble des valeurs subjectives, culturelles ou émotionnelles associées à un mot.
  Le mot _serpent_ → trahison, danger, ruse (connotations négatives dans la culture occidentale).

> 💡 En production écrite, choisir un mot pour ses connotations permet d''influencer le lecteur sans l''affirmer directement.

## 🌀 Les figures de style : comparaison et métaphore

Les figures de style embellissent le langage et lui donnent une force expressive particulière.

### La comparaison

Elle établit un rapprochement explicite entre deux éléments à l''aide d''un **outil comparatif** (_comme_, _tel_, _pareil à_, _semblable à_, _plus… que_).

_Le guerrier était **fort comme** un lion._

Éléments : le **comparé** (guerrier), l''**outil** (_comme_), le **comparant** (lion). Le **point commun** est la force.

### La métaphore

Elle établit le même rapprochement, mais **sans outil comparatif** : elle identifie directement le comparé au comparant.

- _Ce guerrier **est un lion**._ (métaphore nominale)
- _Il **rugit** de colère._ (métaphore verbale)

> 🗡️ La métaphore **filée** est une métaphore développée sur plusieurs phrases ou sur tout un texte.

## 🧪 Les autres figures de style

| Figure               | Définition                                                                         | Exemple                                                   |
| -------------------- | ---------------------------------------------------------------------------------- | --------------------------------------------------------- |
| **Personnification** | Attribuer des caractéristiques humaines à un animal, un objet ou une abstraction   | _La tempête **hurlait** sa fureur._                       |
| **Hyperbole**        | Exagération à des fins expressives                                                 | _Je t''ai **attendu mille ans**._                          |
| **Énumération**      | Suite de termes appartenant à la même catégorie                                    | _Des épées, des boucliers, des lances jonchaient le sol._ |
| **Gradation**        | Énumération dont les termes sont ordonnés par intensité croissante ou décroissante | _Il frémit, tremblait, criait de peur._                   |

> 🏆 Pour identifier une figure de style à l''examen : 1) nommer la figure ; 2) citer les mots qui la constituent ; 3) expliquer son effet.

## 📐 Méthode : analyser le vocabulaire d''un texte

1. **Repérer le champ lexical dominant** → thème principal.
2. **Identifier les figures de style** → effet recherché.
3. **Distinguer sens propre et sens figuré** → intention de l''auteur.
4. **Relever les connotations** → valeur expressive ou argumentative.

> 🏆 Vocabulaire maîtrisé + figures reconnues = textes déchiffrés et écriture affinée. Tu es désormais un guerrier du langage !', '# 📜 Résumé : Le lexique et les figures de style

- **Formation des mots** : radical (sens de base) + préfixe (avant) + suffixe (après). Les mots partageant le même radical forment une **famille de mots**.
- **Préfixes courants** : _in-/im-_ (privatif), _re-_ (répétition), _pré-_ (avant), _sur-_ (excès), _sous-_ (insuffisance).
- **Suffixes courants** : _-eur/-rice_ (agent), _-tion/-sion_ (action), _-ment_ (adverbe), _-able/-ible_ (possibilité).
- **Champ lexical** : tous les mots qui se rapportent à un même thème. **Champ sémantique** : tous les sens d''un même mot.
- **Synonymes** : sens voisin. **Antonymes** : sens contraire. **Homonymes** : même son, sens différent (_verre/vers/vert/ver_). **Paronymes** : forme proche, sens différent (_éruption/irruption_).
- **Sens propre** (concret/littéral) vs **sens figuré** (imagé/métaphorique).
- **Dénotation** : sens objectif partagé. **Connotation** : valeurs subjectives et culturelles associées.
- **Comparaison** : rapprochement avec outil comparatif (_comme_, _tel_). Trois éléments : comparé, outil, comparant.
- **Métaphore** : rapprochement sans outil comparatif. Métaphore filée = développée sur tout un passage.
- **Personnification** : attributs humains donnés à un non-humain. **Hyperbole** : exagération expressive. **Énumération** : suite de termes de même catégorie. **Gradation** : énumération par intensité croissante ou décroissante.
- Méthode d''analyse : champ lexical → figures → sens propre/figuré → connotations.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('383392ce-53c3-5d10-b090-6f6f48124bee', 'french', 'Les types de textes et la production écrite', 'Identifier les quatre types de textes et leurs indices, maîtriser le schéma narratif, les connecteurs et les techniques de la production écrite.', '# ⚔️ Les types de textes et la production écrite

> 💡 « Connaître le type d''un texte, c''est lire la carte du donjon avant d''y entrer ; savoir le produire, c''est en devenir le maître. »

## 🏰 Les quatre types de textes

Tout texte appartient principalement à l''un de ces quatre types, reconnaissables à leurs **indices** :

| Type             | But principal                            | Indices caractéristiques                                                                                                              |
| ---------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Narratif**     | Raconter des événements                  | Verbes d''action, temps du récit (passé simple, imparfait), personnages, lieu, chronologie                                             |
| **Descriptif**   | Décrire un lieu, un personnage, un objet | Adjectifs qualificatifs, verbes d''état (_être_, _paraître_, _sembler_), imparfait, comparaisons                                       |
| **Explicatif**   | Expliquer un phénomène, informer         | Présent de vérité générale, connecteurs logiques (_parce que_, _en effet_, _ainsi_), vocabulaire spécialisé, organisation cause/effet |
| **Argumentatif** | Convaincre, défendre une thèse           | Thèse, arguments, exemples, connecteurs logiques (_cependant_, _donc_, _or_), verbes d''opinion (_je pense que_, _il est vrai que_)    |

> 🗡️ Un même texte peut mêler plusieurs types : un roman contient des passages narratifs ET descriptifs. Il faut identifier le **type dominant**.

## ⚡ Le schéma narratif

Tout récit complet suit un schéma en cinq étapes :

1. **Situation initiale** : présentation de l''univers, des personnages et de l''état d''équilibre.
   _Éléments : imparfait, descriptions, informations sur le lieu et les protagonistes._

2. **Élément perturbateur** (= déclencheur) : un événement rompt l''équilibre initial.
   _Éléments : passé simple, changement brutal, arrivée d''un problème._

3. **Péripéties** (= actions) : suite d''événements et d''obstacles que les personnages traversent pour rétablir l''équilibre.
   _Éléments : verbes d''action au passé simple, rebondissements._

4. **Dénouement** (= résolution) : l''équilibre est rétabli, le problème est résolu (ou non).
   _Éléments : passé simple, tournant décisif._

5. **Situation finale** : nouvel état d''équilibre, bilan de la situation.
   _Éléments : présent ou imparfait, description du nouvel état._

> 💡 L''élément perturbateur et le dénouement sont souvent au **passé simple** ; la situation initiale et finale, à l''**imparfait** ou au **présent**.

## 🛡️ Les connecteurs logiques et temporels

Les connecteurs assurent la cohérence du texte. Il en existe deux grandes familles :

### Connecteurs temporels (pour les récits)

| Valeur       | Exemples                                                |
| ------------ | ------------------------------------------------------- |
| Antériorité  | _avant que_, _auparavant_, _la veille_                  |
| Simultanéité | _pendant que_, _tandis que_, _en même temps_, _alors_   |
| Postériorité | _ensuite_, _puis_, _après que_, _le lendemain_, _enfin_ |

### Connecteurs logiques (pour l''explication et l''argumentation)

| Valeur                | Exemples                                            |
| --------------------- | --------------------------------------------------- |
| Cause                 | _parce que_, _car_, _en effet_, _puisque_           |
| Conséquence           | _donc_, _ainsi_, _c''est pourquoi_, _par conséquent_ |
| Opposition/concession | _mais_, _cependant_, _néanmoins_, _pourtant_, _or_  |
| Addition              | _de plus_, _en outre_, _par ailleurs_, _également_  |
| Illustration          | _par exemple_, _notamment_, _c''est le cas de_       |

> 🗡️ Dans une copie d''examen, utiliser des connecteurs variés est un critère de qualité évalué par le correcteur.

## 🔮 La production écrite : le récit

Pour rédiger un récit réussi :

- **Respecter le schéma narratif** en cinq étapes.
- **Employer les temps du récit** : passé simple (actions), imparfait (descriptions/fond), plus-que-parfait (antériorité).
- **Varier les types de phrases** et intégrer des **dialogues** (discours direct ou indirect).
- **Insérer des passages descriptifs** pour ancrer le récit dans un espace vivant.
- **Utiliser des figures de style** (comparaisons, métaphores) pour enrichir l''expression.

## 🌀 La production écrite : la description et l''argumentation

### La description

- Organiser la description selon un **plan spatial** : de loin à près, de haut en bas, de gauche à droite.
- Faire appel aux **cinq sens** : vue, ouïe, odorat, toucher, goût.
- Employer l''**imparfait** (description dans un récit) ou le **présent** (description autonome).
- Choisir des **adjectifs précis** et des **comparaisons** ou **métaphores** évocatrices.

### L''argumentation : thèse, arguments, exemples

Un texte argumentatif suit ce plan :

1. **Introduction** : présenter le sujet et annoncer la thèse (position défendue).
2. **Développement** : chaque paragraphe = un **argument** + un **exemple** concret.
   _Structure d''un paragraphe : affirmation → explication → exemple → conclusion partielle._
3. **Conclusion** : reformuler la thèse et ouvrir une perspective.

> 💡 L''**argument** répond à la question « pourquoi ? » ; l''**exemple** répond à « par exemple ? ».

### La lettre

- **Lettre formelle** : lieu et date en haut à droite, formule d''appel (_Monsieur_, _Madame_), corps structuré, formule de politesse finale, signature.
- **Lettre informelle** : registre courant ou familier, formule d''appel simple (_Cher ami_), ton personnel.

> 🗡️ Ne pas oublier la formule de politesse dans une lettre formelle : c''est souvent un critère noté à l''examen.

## 🧪 Méthode : lire et produire un texte à l''examen

1. **Lire** → identifier le type dominant (narratif, descriptif, explicatif, argumentatif).
2. **Analyser** → repérer les indices (temps verbaux, connecteurs, figures).
3. **Planifier** avant d''écrire → schéma narratif ou plan argumentatif.
4. **Rédiger** → employer les bons temps, connecteurs et figures.
5. **Relire** → vérifier la cohérence temporelle, l''orthographe, la ponctuation.

> 🏆 Maîtriser les types de textes et les techniques de production écrite, c''est détenir la clé de toutes les épreuves du brevet !

## 📐 Récapitulatif : indices rapides

```
Type NARRATIF     → verbes d''action, passé simple, personnages, chronologie
Type DESCRIPTIF   → adjectifs, imparfait, sens, verbes d''état
Type EXPLICATIF   → présent de vérité, cause/conséquence, vocabulaire spécialisé
Type ARGUMENTATIF → thèse, arguments, exemples, connecteurs logiques, opinions
```', '# 📜 Résumé : Les types de textes et la production écrite

- **4 types de textes** : narratif (raconter), descriptif (décrire), explicatif (expliquer), argumentatif (convaincre).
- **Indices narratifs** : verbes d''action, passé simple, personnages, chronologie.
- **Indices descriptifs** : adjectifs, imparfait, verbes d''état, comparaisons, cinq sens.
- **Indices explicatifs** : présent de vérité générale, connecteurs cause/conséquence, vocabulaire spécialisé.
- **Indices argumentatifs** : thèse, arguments, exemples, connecteurs logiques, verbes d''opinion.
- **Schéma narratif** (5 étapes) : situation initiale → élément perturbateur → péripéties → dénouement → situation finale.
- **Connecteurs temporels** : _avant que_ (antériorité), _pendant que_ (simultanéité), _ensuite/enfin_ (postériorité).
- **Connecteurs logiques** : cause (_parce que_, _car_), conséquence (_donc_, _ainsi_), opposition (_mais_, _cependant_), addition (_de plus_, _en outre_).
- **Récit** : passé simple (actions) + imparfait (description/fond) + plus-que-parfait (antériorité).
- **Description** : plan spatial, cinq sens, adjectifs précis, figures de style.
- **Argumentation** : introduction (thèse) + développement (argument + exemple) + conclusion.
- **Lettre formelle** : lieu/date, formule d''appel, corps, formule de politesse, signature.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e8b74863-3fe8-5aad-a426-621ef75ec7ef', '5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', 'Exercice : reconnaître types et formes', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d7f2f2b1-7a71-5c8f-8684-6fe8a2a5b9f3', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Quel est le type de la phrase : « Quelle aventure extraordinaire ! »', '[{"id":"a","text":"Déclaratif"},{"id":"b","text":"Interrogatif"},{"id":"c","text":"Exclamatif"},{"id":"d","text":"Impératif"}]'::jsonb, 'c', 'La phrase exprime une émotion et se termine par un point d''exclamation : elle est exclamative.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50cce373-29a3-50c2-8dfb-6b123b7c0f09', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', '« Ferme la porte. » est une phrase de type :', '[{"id":"a","text":"Déclaratif"},{"id":"b","text":"Exclamatif"},{"id":"c","text":"Interrogatif"},{"id":"d","text":"Impératif"}]'::jsonb, 'd', 'Elle donne un ordre, le verbe est à l''impératif et le sujet n''est pas exprimé : phrase impérative.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37b194e0-3e8e-55f3-ab43-d7de67825e3a', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Quelle phrase est à la forme négative ?', '[{"id":"a","text":"Il comprend tout."},{"id":"b","text":"Comprend-il la leçon ?"},{"id":"c","text":"Il ne comprend rien."},{"id":"d","text":"Quelle compréhension !"}]'::jsonb, 'c', 'La négation « ne… rien » encadre le verbe : la phrase est à la forme négative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eccc5914-b0d5-5035-804e-16a2cefc1af6', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'L''interrogation « Est-ce que tu viens ? » est une interrogation :', '[{"id":"a","text":"Partielle"},{"id":"b","text":"Exclamative"},{"id":"c","text":"Emphatique"},{"id":"d","text":"Totale (réponse oui/non)"}]'::jsonb, 'd', 'On peut répondre par oui ou non : c''est une interrogation totale.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd092ac9-1a1b-5654-a751-1f1f28f5548a', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Quelle phrase est à la forme passive ?', '[{"id":"a","text":"La porte est ouverte par le gardien."},{"id":"b","text":"Le gardien ouvre la porte."},{"id":"c","text":"Ouvre la porte !"},{"id":"d","text":"Le gardien ouvrira la porte."}]'::jsonb, 'a', 'Le sujet subit l''action : « être + participe passé + par (complément d''agent) » = voix passive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fbb7ffb-02e9-5d41-a1b1-80ebf9561872', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Dans « C''est le chevalier qui gagne. », la phrase est à la forme :', '[{"id":"a","text":"Négative"},{"id":"b","text":"Passive"},{"id":"c","text":"Emphatique"},{"id":"d","text":"Interrogative"}]'::jsonb, 'c', 'Le présentatif « c''est… qui » met le sujet en relief : c''est la forme emphatique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3b342ef2-05e7-53d3-bded-effe80517ef5', '5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', '⚔️ Boss : transformer les phrases', 3, 120, 30, 'boss', 'admin', 2)
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
  ('11d792cc-0455-56d3-b00b-9145225ca97b', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Transforme à la voix passive : « Le maître corrige les copies. »', '[{"id":"a","text":"Les copies corrigent le maître."},{"id":"b","text":"Le maître est corrigé par les copies."},{"id":"c","text":"Les copies sont corrigées par le maître."},{"id":"d","text":"Les copies ont été corrigées par le maître."}]'::jsonb, 'c', 'Le COD « les copies » devient sujet, et on garde le présent : « sont corrigées par le maître ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9044bfb1-eeb6-54e1-a7d8-10408624f911', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Mets à la forme négative : « Il voit quelqu''un. »', '[{"id":"a","text":"Il ne voit pas quelqu''un."},{"id":"b","text":"Il ne voit rien."},{"id":"c","text":"Il voit personne."},{"id":"d","text":"Il ne voit personne."}]'::jsonb, 'd', 'Le contraire de « quelqu''un » (une personne) est « ne… personne ». « ne… rien » s''emploie pour une chose.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8499fe2e-7b46-5dd1-a7e8-c679eb7bf64c', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Quelle phrase est une interrogation partielle ?', '[{"id":"a","text":"Quand pars-tu ?"},{"id":"b","text":"Pars-tu ?"},{"id":"c","text":"Est-ce que tu pars ?"},{"id":"d","text":"Tu pars ?"}]'::jsonb, 'a', 'L''interrogation porte sur un élément précis (le moment) grâce au mot interrogatif « quand » : elle est partielle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('079d8ed9-845f-5b08-9391-5984479ec84f', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Mets à la voix active : « La ville fut détruite par l''armée. »', '[{"id":"a","text":"L''armée détruit la ville."},{"id":"b","text":"L''armée détruisit la ville."},{"id":"c","text":"La ville détruisit l''armée."},{"id":"d","text":"La ville a détruit l''armée."}]'::jsonb, 'b', 'Le complément d''agent « l''armée » devient sujet et on conserve le passé simple : « détruisit ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('276a92b0-0c54-5381-b57c-d86ad57b021e', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Dans « Le dragon ne dort plus. », la négation « ne… plus » exprime :', '[{"id":"a","text":"L''arrêt d''une action qui durait"},{"id":"b","text":"Une quantité nulle"},{"id":"c","text":"Une question"},{"id":"d","text":"Une exclamation"}]'::jsonb, 'a', '« ne… plus » indique qu''une action a cessé : le dragon dormait, mais ce n''est plus le cas.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aabce6d4-f8ce-58d2-8737-80d73b3f05c8', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Mets le sujet en relief : « Le héros sauve le village. »', '[{"id":"a","text":"C''est le village que le héros sauve."},{"id":"b","text":"C''est le héros qui sauve le village."},{"id":"c","text":"Le village est sauvé par le héros."},{"id":"d","text":"Le héros sauve-t-il le village ?"}]'::jsonb, 'b', 'Pour mettre le SUJET en relief, on emploie « c''est… qui » : « C''est le héros qui… ». L''option b met en relief le complément.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('03ebf9d6-a2d7-5967-b86c-70019206e357', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', 'Exercice : reconnaître les propositions subordonnées', 2, 75, 15, 'practice', 'admin', 1)
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
  ('d645eccd-a5d0-5aeb-9284-79aab3b2de20', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Dans « Je sais que tu réussiras. », la proposition « que tu réussiras » est :', '[{"id":"a","text":"Une subordonnée relative qualifiant « tu »"},{"id":"b","text":"Une subordonnée complétive, COD de « sais »"},{"id":"c","text":"Une subordonnée circonstancielle de cause"},{"id":"d","text":"Une proposition principale"}]'::jsonb, 'b', 'La proposition est introduite par « que », COD du verbe « savoir » : c''est une subordonnée complétive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b8817ab-0b1e-5d97-9a7b-8fd6753ca908', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Quel pronom relatif complète correctement la phrase : « L''épée ___ il se sert est magique. »', '[{"id":"a","text":"dont"},{"id":"b","text":"que"},{"id":"c","text":"qui"},{"id":"d","text":"où"}]'::jsonb, 'a', '« se servir de » → on remplace le groupe « de l''épée » par « dont » : « l''épée dont il se sert ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07e8045b-b474-56cb-88ee-a5cc0e713ffa', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Dans « La forêt où il entra était sombre. », le pronom relatif « où » a la fonction de :', '[{"id":"a","text":"Sujet"},{"id":"b","text":"COD"},{"id":"c","text":"Complément d''agent"},{"id":"d","text":"Complément de lieu"}]'::jsonb, 'd', '« où » reprend « la forêt » (lieu) et joue le rôle de complément de lieu dans la subordonnée relative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cff983e1-a078-56c3-96fc-1bc3c9f70b8e', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Quelle conjonction introduit une subordonnée de but ?', '[{"id":"a","text":"parce que"},{"id":"b","text":"si bien que"},{"id":"c","text":"pour que"},{"id":"d","text":"bien que"}]'::jsonb, 'c', '« pour que » exprime le but et introduit une subordonnée au subjonctif. « parce que » = cause, « si bien que » = conséquence, « bien que » = concession.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e3fc6c2-7f49-579a-9766-20a7860eca17', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Dans « Bien qu''il soit fatigué, il continue. », la subordonnée est une circonstancielle de :', '[{"id":"a","text":"Cause"},{"id":"b","text":"Temps"},{"id":"c","text":"Condition"},{"id":"d","text":"Concession"}]'::jsonb, 'd', '« bien que » + subjonctif exprime un obstacle qui ne bloque pas l''action : c''est la concession.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('308d579a-062a-5895-abfd-e1a05a0356de', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Choisissez la forme correcte : « Les batailles ___ nous avons livrées ont forgé notre courage. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'a', 'Le pronom relatif est COD du verbe « livrer » (on a livré les batailles) : on emploie « que ». Le participe « livrées » s''accorde avec l''antécédent féminin pluriel « batailles ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', '⚔️ Boss : maîtriser la phrase complexe', 3, 120, 30, 'boss', 'admin', 2)
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
  ('c19c1f96-69fa-5f06-a875-55bcfda850ce', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Complétez : « Il s''entraîne tous les jours ___ son équipe remporte la victoire. »', '[{"id":"a","text":"pour que"},{"id":"b","text":"parce que"},{"id":"c","text":"si bien que"},{"id":"d","text":"quand"}]'::jsonb, 'a', 'L''entraînement vise un résultat futur (la victoire de l''équipe) : on exprime le but avec « pour que » + subjonctif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98016972-94e1-5f90-9b1e-f59b43d6b0ae', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Dans « Dès qu''il arriva, le combat commença. », la subordonnée est une circonstancielle de :', '[{"id":"a","text":"Cause"},{"id":"b","text":"Temps (simultanéité immédiate)"},{"id":"c","text":"Conséquence"},{"id":"d","text":"Concession"}]'::jsonb, 'b', '« dès que » indique que les deux actions se suivent immédiatement : c''est une circonstancielle de temps.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('851ee672-a02e-5b39-85ab-663ccff5fccd', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Quelle phrase utilise correctement « si » de condition ?', '[{"id":"a","text":"Si tu t''entraîneras, tu vaincras."},{"id":"b","text":"Si tu t''entraînerais, tu vaincrais."},{"id":"c","text":"Si tu t''entraînes, tu vaincrais."},{"id":"d","text":"Si tu t''entraînes, tu vaincras."}]'::jsonb, 'd', 'Avec « si » de condition (réel), la subordonnée est au présent et la principale au futur : « Si tu t''entraînes, tu vaincras. » On n''emploie jamais futur ni conditionnel après « si ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78994701-0a13-5aa5-b908-e0dc7fa8fd7a', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Identifiez la proposition principale dans : « Comme il pleuvait, il prit son bouclier. »', '[{"id":"a","text":"Comme il pleuvait"},{"id":"b","text":"il pleuvait"},{"id":"c","text":"son bouclier"},{"id":"d","text":"il prit son bouclier"}]'::jsonb, 'd', '« Comme il pleuvait » est la subordonnée de cause. La proposition principale, autonome et porteuse de l''information principale, est « il prit son bouclier ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('733b88c0-3f49-56a9-a7a5-beb1ccab73cf', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Choisissez la forme verbale correcte : « Il parle doucement de peur qu''on ne l''___ . »', '[{"id":"a","text":"entend"},{"id":"b","text":"entendra"},{"id":"c","text":"entende"},{"id":"d","text":"entendrait"}]'::jsonb, 'c', '« de peur que » exprime le but (crainte) et impose le subjonctif présent : « entende ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67a0c11d-ab91-59df-b1f1-e411d1e2cb95', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Dans « Le guerrier que la foule acclame lève son épée. », quel est l''antécédent du pronom relatif « que » ?', '[{"id":"a","text":"la foule"},{"id":"b","text":"son épée"},{"id":"c","text":"Le guerrier"},{"id":"d","text":"acclame"}]'::jsonb, 'c', '« que » reprend le nom qui précède immédiatement la relative : « le guerrier » — c''est lui qui est acclamé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('12f9cc53-1641-5e87-9958-ae1375000007', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', 'Exercice : reconnaître et transformer les voix', 2, 75, 15, 'practice', 'admin', 1)
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
  ('96225451-0ff2-5e30-ab72-ea01d8573838', '12f9cc53-1641-5e87-9958-ae1375000007', 'Quelle phrase est à la voix passive ?', '[{"id":"a","text":"La secrétaire rédige le rapport."},{"id":"b","text":"Le rapport est rédigé par la secrétaire."},{"id":"c","text":"La secrétaire a rédigé un long rapport."},{"id":"d","text":"Rédige ce rapport !"}]'::jsonb, 'b', 'La structure « être conjugué + participe passé + complément d''agent (par la secrétaire) » caractérise la voix passive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad7aa3eb-7915-51a2-8ad8-f71a33b99fb1', '12f9cc53-1641-5e87-9958-ae1375000007', 'Transforme à la voix passive : « Le vent renverse les arbres. »', '[{"id":"a","text":"Les arbres renversent le vent."},{"id":"b","text":"Le vent est renversé par les arbres."},{"id":"c","text":"Les arbres ont été renversés par le vent."},{"id":"d","text":"Les arbres sont renversés par le vent."}]'::jsonb, 'd', 'Le COD « les arbres » devient sujet ; le sujet « le vent » devient complément d''agent ; le présent est conservé : « sont renversés ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3e2ab45-089e-5a99-b92a-87cbb5576dde', '12f9cc53-1641-5e87-9958-ae1375000007', 'Transforme à la voix active : « La lettre a été écrite par Marie. »', '[{"id":"a","text":"Marie a écrit la lettre."},{"id":"b","text":"Marie écrit la lettre."},{"id":"c","text":"La lettre a écrit Marie."},{"id":"d","text":"Marie avait écrit la lettre."}]'::jsonb, 'a', 'Le complément d''agent « Marie » devient sujet et on conserve le passé composé : « a écrit ». Le sujet passif « la lettre » devient COD.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36a444de-1993-5b9a-8fb0-9a5cfe7f77b6', '12f9cc53-1641-5e87-9958-ae1375000007', 'Dans « Le gâteau est mangé. », le complément d''agent est :', '[{"id":"a","text":"« le gâteau »"},{"id":"b","text":"Absent : on ne sait pas qui mange le gâteau."},{"id":"c","text":"« est »"},{"id":"d","text":"« mangé »"}]'::jsonb, 'b', 'La phrase passive ne contient aucun groupe introduit par « par » ou « de » : le complément d''agent est absent. L''agent est inconnu ou sans importance.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fde829bd-4a35-5b7a-980b-d9373c4bb855', '12f9cc53-1641-5e87-9958-ae1375000007', 'Quel est le temps de la phrase passive « Le château sera reconstruit par les habitants. » ?', '[{"id":"a","text":"Présent"},{"id":"b","text":"Passé composé"},{"id":"c","text":"Futur simple"},{"id":"d","text":"Conditionnel présent"}]'::jsonb, 'c', 'L''auxiliaire « être » est conjugué au futur simple (« sera »), ce qui donne la voix passive au futur : « sera reconstruit ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d7569dc-adcd-5490-8ab4-9e1252876fbc', '12f9cc53-1641-5e87-9958-ae1375000007', 'Quel participe passé s''accorde correctement dans : « Les victoires ___ (remporter) par notre équipe nous rendent fiers. » ?', '[{"id":"a","text":"remportées"},{"id":"b","text":"remporté"},{"id":"c","text":"remportés"},{"id":"d","text":"remporter"}]'::jsonb, 'a', 'Le sujet du verbe passif est « les victoires » (féminin pluriel) : le participe passé s''accorde en genre et en nombre → « remportées ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', '⚔️ Boss : maîtriser la voix passive', 3, 120, 30, 'boss', 'admin', 2)
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
  ('3b271bbf-7019-55aa-93bb-583c3fbb407a', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Transforme à la voix passive en conservant le temps : « Les soldats avaient défendu la forteresse. »', '[{"id":"a","text":"La forteresse avait été défendue par les soldats."},{"id":"b","text":"La forteresse a été défendue par les soldats."},{"id":"c","text":"La forteresse était défendue par les soldats."},{"id":"d","text":"La forteresse fut défendue par les soldats."}]'::jsonb, 'a', 'La phrase active est au plus-que-parfait : l''auxiliaire « être » se met au plus-que-parfait (« avait été ») + participe passé accordé au féminin singulier → « avait été défendue ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('332e1995-cf27-5529-9e9c-87c94efb4982', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Transforme à la voix active : « Le vainqueur était acclamé de toute la foule. »', '[{"id":"a","text":"Toute la foule a acclamé le vainqueur."},{"id":"b","text":"Toute la foule acclamait le vainqueur."},{"id":"c","text":"Le vainqueur acclamait toute la foule."},{"id":"d","text":"On acclamait le vainqueur."}]'::jsonb, 'b', 'Le complément d''agent « de toute la foule » (introduit par « de ») devient sujet ; on conserve l''imparfait : « acclamait ». Le sujet passif « le vainqueur » devient COD.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c1cd36e-d806-5894-a665-34368ab1f4bc', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Quelle transformation est correcte ? Phrase de départ : « On a détruit ce pont pendant la guerre. »', '[{"id":"a","text":"Ce pont a été détruit par on pendant la guerre."},{"id":"b","text":"Ce pont est détruit pendant la guerre."},{"id":"c","text":"Ce pont avait été détruit pendant la guerre."},{"id":"d","text":"Ce pont a été détruit pendant la guerre."}]'::jsonb, 'd', 'Quand le sujet actif est « on », on le supprime à la voix passive : le complément d''agent est absent. Le passé composé passif donne « a été détruit ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6abd4b21-6d1c-51e3-9607-d615dae991a3', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Dans quelle phrase l''accord du participe passé est-il correct ?', '[{"id":"a","text":"Les lois ont été respectées par tous les citoyens."},{"id":"b","text":"Les lois ont été respecté par tous les citoyens."},{"id":"c","text":"Les lois ont été respectés par tous les citoyens."},{"id":"d","text":"Les lois ont été respectée par tous les citoyens."}]'::jsonb, 'a', 'Le sujet du verbe passif est « les lois » (féminin pluriel) : le participe passé s''accorde → « respectées ». Les options b, c, d sont mal accordées.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d1e84a5-a743-5748-b970-cc7eda950ebc', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Pourquoi la phrase « Cette forêt est traversée. » est-elle stylistiquement intéressante sans complément d''agent ?', '[{"id":"a","text":"Elle indique que la forêt fait l''action."},{"id":"b","text":"Elle est incorrecte : la voix passive exige un complément d''agent."},{"id":"c","text":"Elle met l''accent sur la forêt et dépersonnalise l''action."},{"id":"d","text":"Elle exprime une condition."}]'::jsonb, 'c', 'Sans complément d''agent, la voix passive met en avant l''objet de l''action (« cette forêt ») et efface volontairement l''agent : c''est un effet stylistique de dépersonnalisation ou de généralisation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f22c973f-b551-5ada-b930-ce0801010307', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Quelle phrase contient une erreur dans la transformation active → passive ?', '[{"id":"a","text":"Le chien a mordu Paul. → Paul a été mordu par le chien. ✓"},{"id":"b","text":"Les élèves ont applaudi la pièce. → La pièce a été applaudi par les élèves."},{"id":"c","text":"La pluie abîme les récoltes. → Les récoltes sont abîmées par la pluie. ✓"},{"id":"d","text":"Le professeur punira l''élève. → L''élève sera puni par le professeur. ✓"}]'::jsonb, 'b', 'Le sujet passif est « la pièce » (féminin singulier) : le participe passé doit s''accorder → « applaudie ». L''option d comporte une erreur d''accord (« applaudi » au lieu de « applaudie »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7a24537c-05b2-5498-864c-768a4f7b3ee8', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', 'Exercice : discours direct et indirect', 2, 60, 12, 'practice', 'admin', 1)
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
  ('c124cc25-0734-5a92-811e-669baf60fa4b', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Laquelle de ces phrases est au discours direct ?', '[{"id":"a","text":"Le professeur dit qu''ils ouvrent leurs cahiers."},{"id":"b","text":"Le professeur leur ordonne d''ouvrir leurs cahiers."},{"id":"c","text":"Le professeur dit : « Ouvrez vos cahiers. »"},{"id":"d","text":"Le professeur demande si les cahiers sont ouverts."}]'::jsonb, 'c', 'Le discours direct reproduit les paroles telles quelles, annoncées par les deux-points et encadrées par des guillemets. Les options b, c et d intègrent les paroles dans une subordonnée : ce sont des discours indirects.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a365e428-06ba-5c4e-b3fb-3b1eb755b102', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Transforme au discours indirect : Le héros cria : « Je reviendrai demain ! »
Le héros cria qu''il ___.', '[{"id":"a","text":"reviendrait le lendemain"},{"id":"b","text":"reviendra demain"},{"id":"c","text":"revient le lendemain"},{"id":"d","text":"reviendrait demain"}]'::jsonb, 'a', 'Le verbe introducteur « cria » est au passé : le futur simple « reviendrai » devient conditionnel présent « reviendrait ». De plus, l''indicateur de temps « demain » se transforme en « le lendemain » au discours indirect.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69045ed1-0311-55cc-a9d1-5ff08b74073c', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Quel outil de subordination utilise-t-on pour rapporter une question totale (réponse oui/non) au discours indirect ?', '[{"id":"a","text":"que"},{"id":"b","text":"ce que"},{"id":"c","text":"si"},{"id":"d","text":"de"}]'::jsonb, 'c', 'Une question totale (à laquelle on répond par oui ou non) se rapporte au discours indirect avec « si » : « Viens-tu ? » → Il demande si tu viens. On n''utilise « que » que pour les phrases déclaratives, « ce que » pour les questions partielles portant sur le COD, et « de » pour rapporter un ordre.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('103b3b98-c5ec-5850-b280-83a2c4488045', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Au discours indirect, « Qu''est-ce que tu cherches ? » devient :', '[{"id":"a","text":"Il demande qu''est-ce que tu cherches."},{"id":"b","text":"Il demande si tu cherches."},{"id":"c","text":"Il demande ce que tu cherches."},{"id":"d","text":"Il demande ce qui cherche."}]'::jsonb, 'c', 'Au discours indirect, « qu''est-ce que » se transforme en « ce que » (jamais « qu''est-ce que », qui est réservé au discours direct). La phrase perd le point d''interrogation et il n''y a pas d''inversion du sujet.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b56fc225-0884-57fe-9604-a5f47069571c', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Dans la phrase : « Elle annonça qu''elle avait réussi son examen. », quel était le temps verbal dans le discours direct d''origine ?', '[{"id":"a","text":"Le présent : « Je réussis... »"},{"id":"b","text":"L''imparfait : « Je réussissais... »"},{"id":"c","text":"Le futur simple : « Je réussirai... »"},{"id":"d","text":"Le passé composé : « J''ai réussi... »"}]'::jsonb, 'd', 'Au discours indirect avec un verbe introducteur au passé (« annonça »), le plus-que-parfait « avait réussi » correspond à un passé composé dans le discours direct d''origine : « J''ai réussi mon examen. »', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eed4181b-dcbb-5ee2-b6e2-44685205a62e', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Quelle transformation de l''indicateur de lieu est correcte au passage au discours indirect ?', '[{"id":"a","text":"« ici » → « aujourd''hui »"},{"id":"b","text":"« demain » → « ici »"},{"id":"c","text":"« ici » → « là »"},{"id":"d","text":"« hier » → « demain »"}]'::jsonb, 'c', 'L''indicateur de lieu « ici » (point de vue du locuteur au moment où il parle) devient « là » au discours indirect (point de vue du narrateur). Les autres options mélangent indicateurs de temps et de lieu, ou inversent le sens.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a929d5d0-6d99-542b-8482-d7e65feeb3b3', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', '⚔️ Boss : maîtriser le discours rapporté', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d53a306c-aa47-55c3-b52a-3b76f508e771', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme entièrement au discours indirect :
Le chevalier dit : « Je partirai demain à l''aube. »
Le chevalier dit qu''il ___.', '[{"id":"a","text":"partira demain à l''aube"},{"id":"b","text":"partirait demain à l''aube"},{"id":"c","text":"partait le lendemain à l''aube"},{"id":"d","text":"partirait le lendemain à l''aube"}]'::jsonb, 'd', 'Le verbe introducteur « dit » est au passé simple : le futur simple « partirai » devient conditionnel présent « partirait ». L''indicateur de temps « demain » se transforme en « le lendemain » au discours indirect. L''option b oublie les deux changements ; c change le temps mais pas l''indicateur ; d utilise l''imparfait à la place du conditionnel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('789d8fb4-ef9b-57a5-971b-67821be37f1a', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme au discours indirect :
L''entraîneur ordonna : « Courez plus vite ! »
L''entraîneur ordonna ___.', '[{"id":"a","text":"qu''ils couraient plus vite"},{"id":"b","text":"si on court plus vite"},{"id":"c","text":"de courir plus vite"},{"id":"d","text":"que courir plus vite"}]'::jsonb, 'c', 'Un ordre à l''impératif se rapporte au discours indirect par « de + infinitif » : « Courez ! » → ordonna de courir. On n''utilise pas « que » + indicatif pour un ordre, ni « si » qui est réservé aux questions totales.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('927e93ec-4461-53b5-9378-38ef71fbb9b2', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme au discours indirect :
Elle demanda : « Qu''est-ce qui fait ce bruit ? »
Elle demanda ___.', '[{"id":"a","text":"ce que faisait ce bruit"},{"id":"b","text":"ce qui faisait ce bruit"},{"id":"c","text":"qu''est-ce qui faisait ce bruit"},{"id":"d","text":"si quelque chose faisait ce bruit"}]'::jsonb, 'b', '« Qu''est-ce qui » (sujet) se transforme en « ce qui » au discours indirect. Le verbe introducteur « demanda » est au passé : le présent « fait » devient imparfait « faisait ». L''option b utilise « ce que » (réservé au COD) ; c conserve la forme directe interdite au DI ; d modifie complètement le sens.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03c3a61a-f9aa-5183-a4e0-994f72750e44', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Laquelle de ces transformations est entièrement correcte ?
DD : La sorcière murmura : « Je serai là ce soir. »', '[{"id":"a","text":"La sorcière murmura qu''elle serait là ce soir-là."},{"id":"b","text":"La sorcière murmura qu''elle sera là ce soir."},{"id":"c","text":"La sorcière murmura qu''elle serait là ce soir."},{"id":"d","text":"La sorcière murmura qu''elle était là ce soir-là."}]'::jsonb, 'a', '« murmura » est au passé → le futur « serai » devient conditionnel présent « serait » (✓ a et c). L''indicateur « ce soir » devient « ce soir-là » au DI (✓ a seulement). L''option c oublie de changer l''indicateur ; b oublie la concordance des temps ; d utilise l''imparfait au lieu du conditionnel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b7368b8-68e7-5388-a30c-503e4d1dc5dd', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Dans la phrase au discours indirect : « Le guide nous expliqua qu''il avait visité ce site l''année précédente. », quel était le discours direct d''origine ?', '[{"id":"a","text":"« J''avais visité ce site l''année précédente. »"},{"id":"b","text":"« Je visiterai ce site l''année prochaine. »"},{"id":"c","text":"« J''ai visité ce site l''année dernière. »"},{"id":"d","text":"« Je visite ce site l''année dernière. »"}]'::jsonb, 'c', 'Au DI, le verbe introducteur « expliqua » est au passé → le plus-que-parfait « avait visité » remonte au passé composé « a visité » dans le DD. L''indicateur « l''année précédente » correspond à « l''année dernière » au DD. L''option b conserverait le plus-que-parfait dans le DD, ce qui est incorrect ; c mènerait à un conditionnel passé ; d mènerait à un imparfait.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4beed3e-de76-5a9d-b807-84d386df921d', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme au discours indirect :
Il s''écria : « Où étais-tu hier ? »
Il s''écria ___.', '[{"id":"a","text":"où il avait été la veille"},{"id":"b","text":"où tu avais été hier"},{"id":"c","text":"si tu étais là hier"},{"id":"d","text":"où j''avais été la veille"}]'::jsonb, 'a', 'La question partielle « où » se maintient au DI. « s''écria » est au passé → l''imparfait « étais » devient plus-que-parfait « avait été ». Le pronom « tu » (interlocuteur) devient « il » (3e personne). L''indicateur « hier » → « la veille ». L''option b ne change pas le pronom ; c transforme en question totale avec « si » ; d garde le pronom de 1re personne.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b89d641c-95d4-5820-875a-3bac22a2add4', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', 'Exercice : modes et temps verbaux', 2, 75, 15, 'practice', 'admin', 1)
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
  ('6d3e559b-0449-57de-89b2-0ff23b9fd893', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quel mode exprime un fait soumis à une condition ou une hypothèse ?', '[{"id":"a","text":"Le conditionnel"},{"id":"b","text":"L''impératif"},{"id":"c","text":"Le subjonctif"},{"id":"d","text":"L''indicatif"}]'::jsonb, 'a', 'Le conditionnel exprime un fait soumis à une condition (hypothèse), la politesse ou une information non confirmée. L''impératif donne des ordres ; le subjonctif exprime le souhaité ou le douteux ; l''indicatif énonce un fait réel ou certain.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2f3c849-25e9-53d0-b09e-4eff720714b2', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Dans la phrase « Il lisait quand le tonnerre éclata. », les deux temps utilisés sont :', '[{"id":"a","text":"L''imparfait (lisait) et le passé simple (éclata)"},{"id":"b","text":"Le passé composé (lisait) et l''imparfait (éclata)"},{"id":"c","text":"Le passé simple (lisait) et le passé simple (éclata)"},{"id":"d","text":"Le présent (lisait) et le futur (éclata)"}]'::jsonb, 'a', '« Lisait » est à l''imparfait (action de fond, en cours) et « éclata » est au passé simple (action soudaine et ponctuelle). Ce couple imparfait/passé simple est la structure narrative fondamentale du récit littéraire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ee10a83-a4d9-5855-bb7d-79425521b890', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Laquelle de ces phrases contient un verbe au subjonctif présent ?', '[{"id":"a","text":"Il faut que tu finisses cet exercice."},{"id":"b","text":"Tu finiras cet exercice."},{"id":"c","text":"Tu finissais cet exercice."},{"id":"d","text":"Tu as fini cet exercice."}]'::jsonb, 'a', 'Après « il faut que », le verbe est obligatoirement au subjonctif : « finisses » est bien le subjonctif présent de « finir » (2e personne du singulier). Les options b (futur), c (imparfait) et d (passé composé) sont à l''indicatif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2329c69b-07a0-5905-8d3b-82a269887104', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quel est le temps composé correspondant à l''imparfait ?', '[{"id":"a","text":"Le passé composé"},{"id":"b","text":"Le futur antérieur"},{"id":"c","text":"Le passé antérieur"},{"id":"d","text":"Le plus-que-parfait"}]'::jsonb, 'd', 'Le plus-que-parfait (ex. : « avait chanté ») est le temps composé qui correspond à l''imparfait (même série temporelle passée). Il exprime une action antérieure et accomplie par rapport à une action à l''imparfait ou au passé simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('815783b6-b7f5-5dea-9eea-baaa8f7a3382', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quelle forme verbale est correcte dans : « Si tu ___ davantage, tu réussirais. » ?', '[{"id":"a","text":"travaillerais"},{"id":"b","text":"travaillais"},{"id":"c","text":"travailleras"},{"id":"d","text":"travailles"}]'::jsonb, 'b', 'Après « si » dans une hypothèse, on emploie l''imparfait (jamais le conditionnel) : « si tu travaillais → tu réussirais ». La structure est : si + imparfait → conditionnel présent. Les options b (conditionnel), c (futur) et d (présent) sont toutes incorrectes après « si » dans ce contexte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2241625-9fa9-504f-841d-0b346289ca00', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quel emploi de l''impératif est illustré dans : « Prends soin de toi. » ?', '[{"id":"a","text":"Un fait réel"},{"id":"b","text":"Une hypothèse"},{"id":"c","text":"Un conseil"},{"id":"d","text":"Un doute"}]'::jsonb, 'c', 'Le ton de « Prends soin de toi » est bienveillant : c''est un conseil, pas un ordre autoritaire. L''impératif peut exprimer un ordre, un conseil ou une prière. Les options b, c, d correspondent à l''indicatif, au conditionnel et au subjonctif, pas à l''impératif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7efc2dc4-09b3-576b-b2f2-78e7a6288526', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', '⚔️ Boss : identifier et manier modes et temps', 3, 120, 30, 'boss', 'admin', 2)
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
  ('1b86b32d-c59d-5d28-a86e-a87b3cd41919', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Identifie le temps et le mode du verbe souligné :
« À peine avait-il franchi la porte qu''une flèche siffla. »
(verbe : avait franchi)', '[{"id":"a","text":"Passé composé de l''indicatif"},{"id":"b","text":"Passé antérieur de l''indicatif"},{"id":"c","text":"Imparfait de l''indicatif"},{"id":"d","text":"Plus-que-parfait de l''indicatif"}]'::jsonb, 'd', '« Avait franchi » = auxiliaire avoir à l''imparfait + participe passé → c''est le plus-que-parfait de l''indicatif. Il exprime une action antérieure à une autre action passée (« siffla », passé simple). Le passé antérieur utiliserait « eut franchi » (auxiliaire au passé simple).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fadd44b-aca0-5ece-b1a4-02766d4517e3', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Conjugue correctement au subjonctif présent (3e personne du singulier) :
« Il est indispensable que le groupe ___ à l''heure. »
(verbe : venir)', '[{"id":"a","text":"vient"},{"id":"b","text":"viendra"},{"id":"c","text":"vienne"},{"id":"d","text":"venait"}]'::jsonb, 'c', 'Après « il est indispensable que », on emploie le subjonctif présent. Le radical de la 3e personne du pluriel du présent de l''indicatif est « vienn- » (ils viennent) → qu''il vienne. L''option b est le présent de l''indicatif, c le futur, d l''imparfait.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbaa9f7f-4a56-5d1f-b53d-df4861ef1871', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Quelle phrase illustre correctement l''emploi du conditionnel de politesse ?', '[{"id":"a","text":"Je veux un renseignement, s''il vous plaît."},{"id":"b","text":"Je voudrais un renseignement, s''il vous plaît."},{"id":"c","text":"Je voulus un renseignement, s''il vous plaît."},{"id":"d","text":"Je veuille un renseignement, s''il vous plaît."}]'::jsonb, 'b', '« Je voudrais » est le conditionnel présent de « vouloir » : il adoucit la demande et exprime la politesse. L''option b (présent de l''indicatif) est plus directe et moins polie ; c (passé simple) est inapproprié ici ; d utilise incorrectement le subjonctif « veuille » dans un contexte où le conditionnel s''impose.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83dfacbc-3c11-55bf-ad09-cc214abb3711', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Dans le récit suivant, quel temps manque-t-il pour exprimer l''action qui fait avancer l''histoire ?
« Le guerrier ___ son épée, ___ un cri et ___ sur l''ennemi. » (actions ponctuelles et successives, style littéraire)', '[{"id":"a","text":"Le passé simple"},{"id":"b","text":"L''imparfait"},{"id":"c","text":"Le présent"},{"id":"d","text":"Le plus-que-parfait"}]'::jsonb, 'a', 'Les actions ponctuelles et successives qui font avancer le récit en style littéraire sont exprimées au passé simple : « saisit, poussa, se rua ». L''imparfait décrit le fond ou les habitudes ; le présent s''emploie dans un récit oral courant ou pour un présent de narration ; le plus-que-parfait exprime l''antériorité.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f4296d8-c07e-5e6d-b599-0022c8f72118', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Laquelle de ces formes verbales est au conditionnel présent ?', '[{"id":"a","text":"Elle partait"},{"id":"b","text":"Elle est partie"},{"id":"c","text":"Elle partirait"},{"id":"d","text":"Elle parte"}]'::jsonb, 'c', '« Partirait » = radical du futur (partir-) + terminaison de l''imparfait (-ait) → conditionnel présent. « Partait » est l''imparfait de l''indicatif ; « est partie » est le passé composé ; « parte » est le subjonctif présent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a935e4d-91f9-59c5-aed2-fbaedff745b6', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Complète avec la forme correcte :
« Il faut que vous ___ la vérité. » (verbe : dire)', '[{"id":"a","text":"disiez"},{"id":"b","text":"direz"},{"id":"c","text":"dites"},{"id":"d","text":"diriez"}]'::jsonb, 'a', 'Après « il faut que », on emploie le subjonctif présent. Pour « dire » à la 2e personne du pluriel, le radical est « dis- » (ils disent → dis-) et la terminaison est « -iez » → disiez. L''option b est le futur de l''indicatif ; c est le présent de l''indicatif ou l''impératif ; d est le conditionnel présent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4758ebaf-51ff-5d37-b504-914009e31959', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', 'Exercice : la concordance des temps', 2, 75, 15, 'practice', 'admin', 1)
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
  ('e91167fb-6b84-515a-9848-d07949d71c90', '4758ebaf-51ff-5d37-b504-914009e31959', 'Dans « Pendant qu''il _____ , ses compagnons attendaient. », quel temps convient pour marquer la simultanéité ?', '[{"id":"a","text":"dormit"},{"id":"b","text":"avait dormi"},{"id":"c","text":"dormait"},{"id":"d","text":"dormira"}]'::jsonb, 'c', 'La simultanéité dans un récit au passé s''exprime par deux imparfaits : « dormait » correspond à « attendaient ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28997c99-1b74-5330-8272-d08f4682b8c8', '4758ebaf-51ff-5d37-b504-914009e31959', 'Quel temps emploie-t-on pour une action antérieure à une autre action au passé simple ?', '[{"id":"a","text":"L''imparfait"},{"id":"b","text":"Le plus-que-parfait"},{"id":"c","text":"Le passé simple"},{"id":"d","text":"Le conditionnel présent"}]'::jsonb, 'b', 'Le plus-que-parfait (auxiliaire à l''imparfait + participe passé) exprime l''antériorité par rapport à une autre action au passé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee97c631-820f-50c1-9de3-58f140893afa', '4758ebaf-51ff-5d37-b504-914009e31959', 'Complète au discours indirect : « Il annonça qu''il _____ le lendemain. » (discours direct : « Je partirai demain. »)', '[{"id":"a","text":"partira"},{"id":"b","text":"était parti"},{"id":"c","text":"partirait"},{"id":"d","text":"part"}]'::jsonb, 'c', 'Quand le verbe introducteur est au passé, le futur du discours direct devient conditionnel présent au discours indirect.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f51a382-45ef-51f7-a25b-2e95a78d6c1f', '4758ebaf-51ff-5d37-b504-914009e31959', 'Choisis la phrase correctement construite dans un récit au passé :', '[{"id":"a","text":"Il a préparé son plan avant de lancer l''attaque."},{"id":"b","text":"Il prépara son plan avant d''avoir lancé l''attaque."},{"id":"c","text":"Il avait préparé son plan avant de lancer l''attaque."},{"id":"d","text":"Il préparait son plan avant de lancer l''attaque."}]'::jsonb, 'c', 'Dans un récit au passé, l''action antérieure s''exprime au plus-que-parfait (« avait préparé ») par rapport à l''action postérieure au passé simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('676a25e8-1769-5b86-945f-06f2bf2d8548', '4758ebaf-51ff-5d37-b504-914009e31959', 'Transforme au discours indirect : « Elle dit : ‹ J''ai terminé mon travail. › »', '[{"id":"a","text":"Elle dit qu''elle avait terminé son travail."},{"id":"b","text":"Elle dit qu''elle terminait son travail."},{"id":"c","text":"Elle dit qu''elle a terminé son travail."},{"id":"d","text":"Elle dit qu''elle terminerait son travail."}]'::jsonb, 'a', 'Le passé composé du discours direct devient plus-que-parfait au discours indirect quand le verbe introducteur est au passé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc3b9212-5768-5113-ad7b-2ba9128d740f', '4758ebaf-51ff-5d37-b504-914009e31959', 'Dans « La forêt _____ silencieuse, mais soudain un cri déchira l''air. », quel temps convient ?', '[{"id":"a","text":"fut"},{"id":"b","text":"avait été"},{"id":"c","text":"sera"},{"id":"d","text":"était"}]'::jsonb, 'd', 'L''imparfait « était » décrit un état de fond, tandis que le passé simple « déchira » exprime l''événement principal qui surgit.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7e38a684-6fa6-5bf2-ac76-40bf6085e469', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', '⚔️ Boss : maîtriser la concordance des temps', 3, 120, 30, 'boss', 'admin', 2)
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
  ('0b03e40f-b428-588f-8ccc-c9431e9e0fda', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Transforme au discours indirect : « Le général cria : ‹ Avancez sans tarder ! › »', '[{"id":"a","text":"Le général cria que ses soldats avançaient sans tarder."},{"id":"b","text":"Le général cria à ses soldats d''avancer sans tarder."},{"id":"c","text":"Le général cria qu''ils avanceraient sans tarder."},{"id":"d","text":"Le général cria que ses soldats avancèrent sans tarder."}]'::jsonb, 'b', 'L''impératif du discours direct devient un infinitif introduit par « de » au discours indirect : « cria de + infinitif ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba963d3c-68cf-5c49-b62e-344049caab0e', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Complète : « Dès qu''il _____ son discours, les guerriers s''élancèrent. » (action antérieure immédiate)', '[{"id":"a","text":"avait terminé"},{"id":"b","text":"termina"},{"id":"c","text":"terminait"},{"id":"d","text":"eut terminé"}]'::jsonb, 'd', 'Après « dès que » suivi d''un verbe au passé simple, l''action antérieure immédiate s''exprime au passé antérieur (auxiliaire au passé simple + participe passé) : « eut terminé ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c394033c-66d8-548c-951c-5472f4c41c30', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Quelle phrase respecte la concordance des temps dans le récit au passé ?', '[{"id":"a","text":"Le village est calme : les habitants avaient fui la veille."},{"id":"b","text":"Le village était calme : les habitants avaient fui la veille."},{"id":"c","text":"Le village était calme : les habitants fuiront la veille."},{"id":"d","text":"Le village était calme : les habitants fuyaient la veille avant."}]'::jsonb, 'b', 'L''imparfait « était » décrit l''état de fond ; le plus-que-parfait « avaient fui » exprime correctement l''antériorité par rapport à l''état présent du village.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efa163b4-a341-5c43-9bfb-142a7b277fa7', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Transforme au discours indirect (verbe introducteur au passé) : « Il murmura : ‹ Je reviendrai demain. › »', '[{"id":"a","text":"Il murmura qu''il reviendrait le lendemain."},{"id":"b","text":"Il murmura qu''il reviendra demain."},{"id":"c","text":"Il murmura qu''il était revenu le lendemain."},{"id":"d","text":"Il murmura qu''il revenait demain."}]'::jsonb, 'a', 'Le futur simple du discours direct devient conditionnel présent (« reviendrait ») et « demain » devient « le lendemain » au discours indirect avec verbe introducteur au passé.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a467a610-6abe-5eac-ba05-83a1fa8608f7', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Dans « Il voulait que le héros _____ la quête avant la nuit. », quel temps convient au registre soutenu ?', '[{"id":"a","text":"accomplît"},{"id":"b","text":"accomplisse"},{"id":"c","text":"accomplit"},{"id":"d","text":"accomplissait"}]'::jsonb, 'a', 'Quand la principale est au passé (« voulait »), la subordonnée au subjonctif se met au subjonctif imparfait en registre soutenu : « accomplît » (3e pers. sing. du subjonctif imparfait d''« accomplir »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ba1108b-cd4f-590a-b3ce-0e1bb8b0a251', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Transforme au discours indirect : « La sorcière avoua : ‹ J''ai caché la clé hier. › »', '[{"id":"a","text":"La sorcière avoua qu''elle cachait la clé la veille."},{"id":"b","text":"La sorcière avoua qu''elle avait caché la clé la veille."},{"id":"c","text":"La sorcière avoua qu''elle a caché la clé hier."},{"id":"d","text":"La sorcière avoua qu''elle cacherait la clé la veille."}]'::jsonb, 'b', 'Le passé composé « ai caché » devient plus-que-parfait « avait caché » au discours indirect (verbe introducteur au passé), et « hier » devient « la veille ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b3042e50-068f-5b9f-91d5-e64df884f924', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', 'Exercice : vocabulaire et figures de style', 2, 75, 15, 'practice', 'admin', 1)
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
  ('b7b276c1-df61-5015-a396-ac06265465c7', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Dans le mot « impossible », quel est le rôle du préfixe « im- » ?', '[{"id":"a","text":"Il exprime le contraire (sens privatif)."},{"id":"b","text":"Il exprime la répétition."},{"id":"c","text":"Il indique une action passée."},{"id":"d","text":"Il transforme le mot en adverbe."}]'::jsonb, 'a', 'Le préfixe « im- » (variante de « in- » devant p/b/m) est privatif : il donne le sens contraire, ici « non possible ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cd7fbf9-2cc6-5eb7-879f-94d9ee76d569', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Lequel de ces mots n''appartient PAS à la famille du mot « terre » ?', '[{"id":"a","text":"terrestre"},{"id":"b","text":"enterrer"},{"id":"c","text":"terrible"},{"id":"d","text":"territoire"}]'::jsonb, 'c', '« terrible » vient du latin « terrere » (effrayer) et n''a pas le même radical que « terre ». Les trois autres partagent le radical « terr- » lié à la terre.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('120db6b4-7f11-50e3-bbd3-e8ab5cbe63ff', 'b3042e50-068f-5b9f-91d5-e64df884f924', '« Verre » (récipient) et « ver » (animal) sont des :', '[{"id":"a","text":"Homonymes"},{"id":"b","text":"Synonymes"},{"id":"c","text":"Antonymes"},{"id":"d","text":"Paronymes"}]'::jsonb, 'a', 'Ces mots se prononcent de manière identique mais ont des sens et des orthographes différents : ce sont des homonymes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e29bdbfe-677e-5173-8a30-dc1ddc813fe8', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Dans « La peur dévorait le guerrier », le mot « dévorait » est employé au :', '[{"id":"a","text":"Sens figuré"},{"id":"b","text":"Sens propre"},{"id":"c","text":"Sens technique"},{"id":"d","text":"Sens dénotatif uniquement"}]'::jsonb, 'a', 'La peur ne peut pas manger au sens propre : « dévorait » est ici employé au sens figuré pour exprimer l''intensité de la peur qui ronge le guerrier.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e3d2494-fea2-5244-b1a6-622c5560913b', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Identifie la figure de style dans : « Il tremblait, frissonnait, grelottait de terreur. »', '[{"id":"a","text":"Métaphore"},{"id":"b","text":"Hyperbole"},{"id":"c","text":"Personnification"},{"id":"d","text":"Gradation"}]'::jsonb, 'd', 'Les trois verbes expriment le même état (le froid/la peur) avec une intensité croissante : c''est une gradation (ascendante).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8a55df7-3f25-5d5b-8ea5-5f14e3c12204', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Dans « Le vent **hurlait** entre les ruines », quelle figure de style reconnaît-on ?', '[{"id":"a","text":"Comparaison"},{"id":"b","text":"Hyperbole"},{"id":"c","text":"Énumération"},{"id":"d","text":"Personnification"}]'::jsonb, 'd', 'Attribuer au vent l''action « hurler » (cri humain) lui confère une caractéristique humaine : c''est une personnification.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('25f31af7-de92-57ff-93ce-e6dc3127c707', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', '⚔️ Boss : lexique et figures de style', 3, 120, 30, 'boss', 'admin', 2)
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
  ('5e344432-2f71-56d6-abf1-5c8c31d537c9', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Quelle est la différence entre « éruption » et « irruption » ?', '[{"id":"a","text":"Ce sont des synonymes qui désignent tous les deux une explosion."},{"id":"b","text":"« Éruption » = jaillissement (volcan) ; « irruption » = entrée brusque et violente."},{"id":"c","text":"« Irruption » = jaillissement (volcan) ; « éruption » = entrée brusque."},{"id":"d","text":"« Éruption » est le sens figuré de « irruption »."}]'::jsonb, 'b', 'Ce sont des paronymes : « éruption » désigne le jaillissement (volcan, peau) ; « irruption » désigne une entrée soudaine et non autorisée (« faire irruption »). Les confondre est une erreur de paronyme classique.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24a82297-67c0-5306-9121-6efc815a919e', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Identifie la figure de style dans : « Ce général, c''était un roc, une montagne, un géant. »', '[{"id":"a","text":"Gradation et métaphores"},{"id":"b","text":"Comparaison et énumération"},{"id":"c","text":"Hyperbole et personnification"},{"id":"d","text":"Énumération et comparaisons"}]'::jsonb, 'a', 'Trois métaphores (sans outil comparatif : « un roc », « une montagne », « un géant ») s''enchaînent avec une intensité croissante : c''est une gradation de métaphores.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bfeec0f-5f54-5365-9c20-356635d68e1c', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Dans « La victoire sourit à ceux qui persévèrent », quelle figure reconnaît-on ?', '[{"id":"a","text":"Hyperbole"},{"id":"b","text":"Comparaison"},{"id":"c","text":"Personnification"},{"id":"d","text":"Gradation"}]'::jsonb, 'c', 'La victoire (abstraction) accomplit l''action humaine de « sourire » : on lui attribue une caractéristique humaine, c''est une personnification.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73d9a740-8761-50f2-a74c-f66483150482', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Quel mot a une connotation POSITIVE dans tous les contextes culturels courants ?', '[{"id":"a","text":"ténèbres"},{"id":"b","text":"aurore"},{"id":"c","text":"vautour"},{"id":"d","text":"rouille"}]'::jsonb, 'b', '« Aurore » (aube, début du jour) est universellement associée à l''espoir, au renouveau, au début positif. Les autres ont des connotations négatives (ténèbres = obscurité/mal ; vautour = prédateur/opportuniste ; rouille = dégradation).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a08dc674-1ad0-5709-ac2a-91fb09b03e23', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Quelle phrase contient une comparaison (et non une métaphore) ?', '[{"id":"a","text":"Ses yeux étaient des étoiles."},{"id":"b","text":"Ses yeux brillaient comme des étoiles."},{"id":"c","text":"Des étoiles l''observaient."},{"id":"d","text":"Ses étoiles-yeux scintillaient."}]'::jsonb, 'b', 'La présence de l''outil comparatif « comme » fait de cette phrase une comparaison. Sans cet outil, « ses yeux étaient des étoiles » serait une métaphore.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a654666-d0cf-5a81-9244-aad9397d5ddb', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Dans ce passage, quel est le champ lexical dominant ? « Les lames claquaient, les boucliers résonnaient, les flèches sifflaient, le sang coulait. »', '[{"id":"a","text":"La nature"},{"id":"b","text":"Le combat / la guerre"},{"id":"c","text":"La musique"},{"id":"d","text":"Le voyage"}]'::jsonb, 'b', 'Les mots « lames », « boucliers », « flèches », « sang » appartiennent tous au champ lexical du combat et de la guerre, qui est le thème dominant du passage.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('216407d2-5ccf-54fb-bd5c-03550dcaa2e1', '383392ce-53c3-5d10-b090-6f6f48124bee', 'french', 'Exercice : types de textes et production écrite', 2, 75, 15, 'practice', 'admin', 1)
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
  ('1cfa6dc4-e445-543e-9cdf-1baae0c8f842', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Quel type de texte cherche principalement à convaincre le lecteur d''adopter une opinion ?', '[{"id":"a","text":"Argumentatif"},{"id":"b","text":"Narratif"},{"id":"c","text":"Descriptif"},{"id":"d","text":"Explicatif"}]'::jsonb, 'a', 'Le texte argumentatif vise à défendre une thèse et à convaincre le lecteur à l''aide d''arguments et d''exemples.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00a19639-3883-5d3c-8924-c94faf49d549', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Dans le schéma narratif, quel est l''élément qui rompt l''équilibre initial et déclenche l''action ?', '[{"id":"a","text":"L''élément perturbateur"},{"id":"b","text":"La situation finale"},{"id":"c","text":"Le dénouement"},{"id":"d","text":"Les péripéties"}]'::jsonb, 'a', 'L''élément perturbateur (ou déclencheur) est l''événement qui brise l''équilibre de la situation initiale et met le récit en mouvement.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db7ecffa-12db-5ebe-a71f-0b59145133eb', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Quel connecteur exprime une relation de CAUSE ?', '[{"id":"a","text":"donc"},{"id":"b","text":"cependant"},{"id":"c","text":"ensuite"},{"id":"d","text":"car"}]'::jsonb, 'd', '« Car » est un connecteur de cause (il introduit la raison d''un fait). « Donc » exprime la conséquence, « cependant » l''opposition, « ensuite » la succession temporelle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4032fad4-617f-58e6-b390-53e4b2c6c1c6', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Quel indice est caractéristique d''un texte DESCRIPTIF ?', '[{"id":"a","text":"Une thèse et des arguments"},{"id":"b","text":"Des verbes d''action au passé simple"},{"id":"c","text":"Des connecteurs cause/conséquence"},{"id":"d","text":"De nombreux adjectifs qualificatifs et des verbes d''état"}]'::jsonb, 'd', 'Le texte descriptif se reconnaît à l''abondance d''adjectifs qualificatifs, de verbes d''état (être, paraître, sembler) et de l''imparfait, qui peignent une réalité sans la faire évoluer.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61ccedd3-9052-5b32-ab73-cd1879d56ae7', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Dans quel ordre se succèdent les étapes du schéma narratif ?', '[{"id":"a","text":"Élément perturbateur → situation initiale → péripéties → situation finale → dénouement"},{"id":"b","text":"Situation initiale → élément perturbateur → péripéties → dénouement → situation finale"},{"id":"c","text":"Situation initiale → péripéties → élément perturbateur → dénouement → situation finale"},{"id":"d","text":"Situation initiale → dénouement → péripéties → élément perturbateur → situation finale"}]'::jsonb, 'b', 'Le schéma narratif canonique comporte cinq étapes dans cet ordre précis : situation initiale, élément perturbateur, péripéties, dénouement, situation finale.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6cc0e08b-af9c-5dce-b02f-5bd6587bd103', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Dans une lettre formelle, où place-t-on habituellement le lieu et la date ?', '[{"id":"a","text":"En bas de la lettre, après la signature"},{"id":"b","text":"Au centre, comme titre"},{"id":"c","text":"En haut à gauche, sous le destinataire"},{"id":"d","text":"En haut à droite, avant la formule d''appel"}]'::jsonb, 'd', 'Dans une lettre formelle française, le lieu et la date se placent en haut à droite, avant la formule d''appel (ex. : « Tunis, le 2 juin 2026 »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('981642c4-6f55-5171-897c-bdf40e984522', '383392ce-53c3-5d10-b090-6f6f48124bee', 'french', '⚔️ Boss : types de textes et production écrite', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ed57c56c-2714-58cf-b436-afc5b1f0fb55', '981642c4-6f55-5171-897c-bdf40e984522', 'Lis ce passage : « Le volcan entre en éruption lorsque la pression des gaz et du magma dépasse la résistance de la roche. La lave jaillit alors par le cratère et dévale les pentes. » Quel est le type dominant ?', '[{"id":"a","text":"Explicatif"},{"id":"b","text":"Narratif"},{"id":"c","text":"Descriptif"},{"id":"d","text":"Argumentatif"}]'::jsonb, 'a', 'Le passage explique un phénomène naturel (l''éruption) à l''aide d''une relation cause/effet et du présent de vérité générale : c''est un texte explicatif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a704ca25-4e84-5194-ae74-d707994df17e', '981642c4-6f55-5171-897c-bdf40e984522', 'Un élève écrit : « Les jeux vidéo sont néfastes pour les jeunes. En effet, ils réduisent le temps consacré aux devoirs. Par exemple, une étude montre que les joueurs réguliers ont de moins bonnes notes. » Quelle structure reconnaît-on ?', '[{"id":"a","text":"Thèse + argument + exemple"},{"id":"b","text":"Situation initiale + élément perturbateur"},{"id":"c","text":"Description spatiale + cinq sens"},{"id":"d","text":"Cause + conséquence + opposition"}]'::jsonb, 'a', 'La première phrase est la thèse (position défendue), « En effet » introduit un argument (raison), et « Par exemple » illustre par un exemple concret : c''est la structure argumentative classique.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3088ed38-3f25-5167-aa73-a51d2fb61486', '981642c4-6f55-5171-897c-bdf40e984522', 'Quelle étape du schéma narratif correspond à ce passage : « Enfin, le héros retrouva son village en paix et ses amis l''accueillirent avec joie. » ?', '[{"id":"a","text":"Élément perturbateur"},{"id":"b","text":"Situation finale"},{"id":"c","text":"Péripéties"},{"id":"d","text":"Situation initiale"}]'::jsonb, 'b', 'Ce passage décrit le nouvel état d''équilibre atteint après la résolution du conflit : c''est la situation finale, dernière étape du schéma narratif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16ef4fd9-0bf8-5dcc-bcee-af59ae8bdb12', '981642c4-6f55-5171-897c-bdf40e984522', 'Quel connecteur logique complète le mieux cette phrase argumentative : « Ce projet est ambitieux ; _____, il est tout à fait réalisable. » ?', '[{"id":"a","text":"car"},{"id":"b","text":"donc"},{"id":"c","text":"ensuite"},{"id":"d","text":"cependant"}]'::jsonb, 'd', '« Cependant » exprime la concession/opposition : on admet une limite (projet ambitieux) tout en la nuançant (mais réalisable). C''est le connecteur d''opposition qui convient ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64e55faa-0a53-52af-8b05-97dd07023788', '981642c4-6f55-5171-897c-bdf40e984522', 'Pour décrire une salle de château de façon méthodique, quelle organisation est la plus adaptée ?', '[{"id":"a","text":"Un plan chronologique (du passé au présent)"},{"id":"b","text":"Un plan thèse/antithèse/synthèse"},{"id":"c","text":"Un plan spatial (par exemple : de l''entrée vers le fond, puis de gauche à droite)"},{"id":"d","text":"Un plan cause/conséquence"}]'::jsonb, 'c', 'La description d''un lieu s''organise selon un plan spatial (point de vue du regard qui se déplace) pour guider le lecteur de manière cohérente et vivante.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29b2923e-5b05-5c0d-abd3-f0e7bb7dd6eb', '981642c4-6f55-5171-897c-bdf40e984522', 'Quelle formule de politesse convient à la clôture d''une lettre formelle adressée à un directeur ?', '[{"id":"a","text":"« Veuillez agréer, Monsieur le Directeur, l''expression de mes salutations distinguées. »"},{"id":"b","text":"« Bisous et à bientôt ! »"},{"id":"c","text":"« Cordialement, ton ami. »"},{"id":"d","text":"« En espérant une réponse rapide. »"}]'::jsonb, 'a', 'La lettre formelle exige une formule de politesse complète reprenant le titre du destinataire. Les options b, c et d appartiennent au registre familier ou sont incomplètes.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

