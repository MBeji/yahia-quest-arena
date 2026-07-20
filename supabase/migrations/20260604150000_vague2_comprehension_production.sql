-- Vague 2 — Compréhension & production (FR/EN/AR): new chapters.
-- Idempotent forward migration for already-migrated databases. Inserts the new
-- chapters, their exercises and questions (FK-safe order). Safe to re-run.

-- Garde de reconstruction sur base VIERGE (2026-07-20, suite a l'etude 24 lot 4) :
-- chaque ligne n'est inseree que si son parent existe. Sur la prod tous les parents sont
-- la et le comportement est identique ; sur une base reconstruite depuis le seul repo
-- public, le corpus genere est absent et ces lignes n'ont plus d'objet.
INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order)
SELECT v.id::uuid, v.subject_id, v.title, v.description, v.lesson_content, v.summary, v.display_order
FROM (VALUES
  ('7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Compréhension de texte & production écrite', 'Lire activement un texte (idée directrice, type de texte, connecteurs, ton, inférence, lexique en contexte) et maîtriser les bases de la production écrite : phrase de thèse, amorce, paragraphe argumentatif et enchaînement logique.', '# Compréhension de texte & production écrite

> « Bien lire, c''est interroger un texte ; bien écrire, c''est répondre avec ordre. »

Ce chapitre relie deux compétences inséparables de l''examen : **comprendre** un texte (en saisir le sens explicite et implicite) et **produire** à votre tour un écrit clair, organisé et argumenté.

---

## Partie A — Comprendre un texte

### 1. Repérer l''idée directrice (ou la thèse)

L''**idée directrice** est l''idée principale autour de laquelle tout le texte s''organise. Dans un texte argumentatif, on parle de **thèse** : c''est la position que l''auteur défend.

- Elle se trouve souvent dans la **première** ou la **dernière** phrase.
- Pour la trouver, demandez-vous : « De quoi parle le texte, et que veut-il me faire admettre ? »
- Ne confondez pas l''idée directrice (générale, englobante) avec un simple **détail** ou un **exemple**.

### 2. Identifier le type de texte

Reconnaître le type d''un texte permet d''anticiper son organisation.

| Type                        | Ce qu''il fait                          | Indices                                                        |
| --------------------------- | -------------------------------------- | -------------------------------------------------------------- |
| **Narratif**                | Raconte des événements qui se suivent  | verbes d''action, temps du récit, personnages, repères de temps |
| **Descriptif**              | Peint un lieu, un objet, une personne  | adjectifs, verbes d''état, notations sensorielles (vue, ouïe…)  |
| **Informatif / explicatif** | Donne des faits, explique un phénomène | chiffres, présent de vérité générale, ton neutre               |
| **Argumentatif**            | Défend une opinion, convainc           | thèse, arguments, connecteurs logiques, marques de jugement    |

### 3. Comprendre le rôle des connecteurs logiques

Les **connecteurs** révèlent le lien logique entre les idées. Les reconnaître, c''est comprendre le raisonnement.

| Relation                    | Connecteurs                                     | Exemple                                  |
| --------------------------- | ----------------------------------------------- | ---------------------------------------- |
| **Addition**                | de plus, par ailleurs, en outre                 | « Il est tard ; de plus, il pleut. »     |
| **Cause**                   | car, parce que, puisque, en effet               | « Je reste, car il pleut. »              |
| **Conséquence**             | donc, ainsi, c''est pourquoi, par conséquent     | « Il pleut, donc je reste. »             |
| **Opposition / concession** | mais, cependant, or, pourtant, malgré, bien que | « Il pleut, pourtant il sort. »          |
| **But**                     | afin de, pour que                               | « Il révise pour réussir. »              |
| **Illustration**            | par exemple, ainsi, notamment                   | « Des sports, par exemple le football. » |

### 4. Repérer le ton et le sentiment

Le **ton** trahit l''attitude de l''auteur ou du personnage : joie, tristesse, colère, ironie, admiration, résignation, inquiétude… On le repère grâce :

- au **champ lexical** dominant (les mots qui reviennent) ;
- aux **répétitions**, à la **ponctuation** (! …), aux figures de style ;
- aux **modalisateurs** (peut-être, hélas, certainement).

### 5. Lire entre les lignes : l''inférence

Un texte ne dit pas tout. **Inférer**, c''est déduire une information non écrite à partir d''indices.

- _« Elle ferma son parapluie en entrant. »_ → on déduit qu''**il pleuvait**.
- L''inférence s''appuie toujours sur le texte, jamais sur une simple opinion personnelle.

### 6. Le lexique en contexte

Le sens d''un mot dépend de son **entourage**. Pour deviner un mot inconnu :

1. lisez la phrase entière (et la suivante) ;
2. cherchez un synonyme, un contraire ou un exemple proche ;
3. vérifiez que le sens choisi reste cohérent avec la phrase.

---

## Partie B — Produire un écrit

### 1. Faire un plan avant d''écrire

Ne rédigez jamais sans plan. Un plan simple :

1. **Introduction** : une phrase d''amorce + l''annonce de votre position (thèse).
2. **Développement** : un ou deux paragraphes, chacun = **un argument** illustré d''un exemple.
3. **Conclusion** : bilan + une ouverture éventuelle.

### 2. La phrase de thèse

C''est la phrase qui **annonce clairement votre position**. Une bonne phrase de thèse est :

- **précise** (pas vague comme « je vais parler de la lecture ») ;
- **affirmée** (« La lecture est essentielle parce qu''elle nourrit l''imagination ») ;
- **orientée** vers ce que le paragraphe va prouver.

### 3. La phrase d''amorce

L''**amorce** est la toute première phrase : elle attire l''attention et introduit le sujet **sans le traiter encore**. On peut amorcer par :

- un **constat** général (« Aujourd''hui, les écrans occupent une grande place… ») ;
- une **question** ;
- une **citation** ou un fait frappant.

Une amorce réussie est **liée au sujet** : elle n''est ni hors sujet ni déjà la conclusion.

### 4. Le paragraphe argumentatif

Un paragraphe argumentatif efficace suit cet ordre :

1. **Idée / argument** (phrase qui annonce l''argument) ;
2. **Explication** (on développe le pourquoi) ;
3. **Exemple** (un cas concret qui prouve) ;
4. **Mini-conclusion** ou transition vers la suite.

> Mémo de l''ordre logique : **annoncer → expliquer → illustrer → conclure**.

### 5. Choisir le bon connecteur

Le connecteur doit correspondre au **lien réel** entre vos idées :

- pour ajouter un argument : _de plus, par ailleurs_ ;
- pour opposer un contre-argument : _certes… mais, cependant_ ;
- pour conclure : _donc, en somme, ainsi_.

Un connecteur mal choisi rend le texte **incohérent**, même si chaque phrase est correcte.

### 6. Argument et contre-argument

- L''**argument** soutient votre thèse.
- Le **contre-argument** est l''objection adverse ; un bon texte le **reconnaît** (« Certes… ») puis le **réfute** (« … mais »).

### 7. Vérifier la cohérence

Avant de rendre, relisez : les phrases s''enchaînent-elles logiquement ? Les connecteurs sont-ils justes ? Y a-t-il une idée hors sujet ou une contradiction ? Un texte **cohérent** progresse sans rupture ni répétition inutile.

> En résumé : on **lit** en cherchant des preuves dans le texte, et on **écrit** en organisant ses idées avec des connecteurs justes.', '# Résumé — Compréhension de texte & production écrite

## Lire (comprendre)

- **Idée directrice / thèse** : l''idée centrale que défend le texte ; souvent en tête ou en fin. À distinguer d''un simple détail ou exemple.
- **Type de texte** : narratif (raconte), descriptif (peint), informatif (explique des faits), argumentatif (défend une opinion).
- **Connecteurs logiques** : révèlent le lien entre les idées — addition (de plus), cause (car), conséquence (donc), opposition (mais, pourtant, malgré), but (afin de).
- **Ton / sentiment** : attitude de l''auteur (joie, ironie, résignation…), repérée via le champ lexical, les répétitions et la ponctuation.
- **Inférence** : déduire une information non écrite à partir d''indices du texte, sans inventer.
- **Lexique en contexte** : deviner le sens d''un mot grâce à la phrase qui l''entoure (synonyme, contraire, exemple).

## Écrire (produire)

- **Plan** : introduction (amorce + thèse) → développement (un argument + exemple par paragraphe) → conclusion.
- **Phrase de thèse** : précise, affirmée, orientée vers ce qu''on va prouver.
- **Phrase d''amorce** : première phrase qui introduit le sujet sans le traiter ; liée au sujet (constat, question, fait frappant).
- **Paragraphe argumentatif** : annoncer l''argument → expliquer → illustrer par un exemple → conclure / faire la transition.
- **Bon connecteur** : doit correspondre au lien réel entre les idées ; un mauvais choix rend le texte incohérent.
- **Argument vs contre-argument** : l''argument soutient la thèse ; le contre-argument est l''objection, qu''on reconnaît (« certes ») puis réfute (« mais »).
- **Cohérence** : relire pour vérifier l''enchaînement logique, la justesse des connecteurs et l''absence de hors-sujet ou de contradiction.', 9),
  ('77ace903-23f8-5a38-8bfe-4fbb1b0369fa', 'arabic', 'فهم المقروء والإنتاج الكتابي', 'منهجيّة شرح النصّ: تحديد الفكرة العامة والأفكار الجزئية، نوع النصّ ونمطه، دور الروابط، النبرة والاستنتاج وشرح المفردات في سياقها؛ ومنهجيّة الإنتاج الكتابي: التصميم والفقرة الحجاجية والحجّة والمثال والروابط المنطقية، تدريبًا على اختبار ختم التعليم الأساسي.', '# 📖 فهم المقروء والإنتاج الكتابي — مفتاح النجاح في الامتحان

> 💡 «القراءة الفاهمة نصفُ النجاح، والكتابة المنظَّمة نصفُه الآخر: من أتقن استخلاص المعنى أتقن بناءه.»

يتألّف اختبار اللغة العربية في امتحان ختم التعليم الأساسي من قسمين كبيرين: **فهم المقروء (شرح النصّ)** و**الإنتاج الكتابي**. هذا الفصل يضع بين يديك منهجيّةً عمليّة للقسمين معًا.

---

## 🏰 القسم الأوّل: فهم المقروء (شرح النصّ)

### 1. الفكرة العامة

الفكرة العامة هي **الموضوع المحوريّ** الذي يدور حوله النصّ كلّه؛ هي الجواب عن سؤال: «عمَّ يتحدّث الكاتب أساسًا؟». وتُصاغ في جملة واحدة جامعة:

- لا تكون تفصيلًا جزئيًّا ورد في سطر واحد.
- لا تكون أوسع من النصّ ولا أضيق منه.
- تجمع بين **الموضوع** و**موقف الكاتب** منه إن وُجد.

> 🗝️ **حيلة عمليّة:** اقرأ المطلع والخاتمة، فغالبًا ما تتركّز فيهما الفكرة العامة.

### 2. الأفكار الجزئية

الأفكار الجزئية هي **الوحدات المعنوية** التي يتفرّع إليها النصّ، وكلّ فقرة تحمل غالبًا فكرة جزئية واحدة. لتحديدها:

1. أقسّم النصّ إلى مقاطع حسب المعنى.
2. أستخرج من كلّ مقطع جملته المفتاحية.
3. أصوغ الفكرة في عبارة موجزة دالّة.

> ⚖️ الفكرة العامة = حصيلة الأفكار الجزئية مجتمعة.

### 3. أنواع النصوص وأنماطها

تمييز نوع النصّ يساعد على فهم مقصد الكاتب:

| النمط         | غايته                         | علاماته                                          |
| ------------- | ----------------------------- | ------------------------------------------------ |
| **السرديّ**   | يحكي أحداثًا متسلسلة          | أفعال الحدث، روابط الزمن (ثمّ، بعد ذلك)، شخصيّات |
| **الوصفيّ**   | يرسم صورة لمكان أو شخص أو شيء | نعوت، أحوال، أفعال الحواسّ، تشبيهات              |
| **التفسيريّ** | يشرح ظاهرة أو يُعلِّم معلومة  | لغة موضوعيّة، أرقام، تعريفات، روابط سببيّة       |
| **الحجاجيّ**  | يُقنع بأطروحة ويدافع عنها     | أطروحة، حجج وأمثلة، روابط منطقيّة، ضمير المتكلّم |

> 🎭 قد يجمع النصّ الواحد بين نمطين: سرديّ في إطار حجاجيّ مثلًا.

### 4. دور الروابط وأدوات الربط

الروابط خيوطٌ تشدّ المعنى؛ ومعرفة وظيفتها تكشف العلاقة بين الأفكار:

- **روابط السبب**: لأنّ، إذ، بما أنّ ← تُعلِّل.
- **روابط النتيجة**: لذلك، فـ، من ثمّ، نتيجةً لذلك ← تستنتج.
- **روابط الإضافة**: كذلك، فضلًا عن، إضافةً إلى ← تُراكم الأدلّة.
- **روابط المعارضة**: لكنْ، غير أنّ، بيدَ أنّ، رغم ← تُعارض أو تُستدرك.
- **روابط التفصيل/التمثيل**: مثلًا، على سبيل المثال، أي ← تُوضّح بمثال.

> 🧩 الرابط لا يحمل معلومةً جديدة بل **يُنظّم العلاقة** بين معلومتين.

### 5. النبرة والمشاعر

النبرة هي **موقف الكاتب الانفعاليّ** من موضوعه (سخرية، حزن، إعجاب، استنكار، حنين، تفاؤل…). نستشفّها من:

- **المفردات المشحونة** عاطفيًّا (ألفاظ المدح أو الذمّ).
- **أساليب الإنشاء**: التعجّب، الاستفهام الإنكاري، النداء.
- **تكرار** كلمة أو تركيب لإبراز الإحساس.

### 6. الاستنتاج والقراءة بين السطور

ليس كلّ المعنى مصرَّحًا به؛ فبعضه **يُفهَم ضمنًا**. الاستنتاج هو استخلاص ما لم يُقَل صراحةً انطلاقًا من القرائن:

- ما الذي توحي به التفاصيل دون أن تقوله؟
- ما الموقف الخفيّ وراء اختيار الكاتب لألفاظه؟

> 🔮 الاستنتاج الصحيح **مدعوم بالنصّ**، لا إسقاطٌ من خارجه.

### 7. شرح المفردة في سياقها

للكلمة معانٍ متعدّدة في المعجم، لكنّ **السياق** هو الذي يحدّد المعنى المقصود. لشرح مفردة:

1. أقرأ الجملة كاملةً قبل الكلمة وبعدها.
2. أبحث عن المعنى الملائم للسياق لا المعنى الأشهر.
3. أستعين بالمرادف أو الضدّ أو القرينة.

> 📌 «العين» تعني الجاسوس أو الجارية أو الباصرة أو الذهب… والسياق وحده يحسم.

---

## ✍️ القسم الثاني: الإنتاج الكتابي

### 1. التصميم (المخطّط)

قبل الكتابة، أرسم تصميمًا واضحًا:

- **المقدّمة**: تمهيد للموضوع + طرح الأطروحة (الموقف).
- **الجوهر (العرض)**: فقرات، كلّ فقرة حجّة مدعومة بمثال وشرح.
- **الخاتمة**: تلخيص الموقف + فتح أفق أو خلاصة.

> 🗺️ التصميم يقي من التكرار والاستطراد، ويمنح النصّ **تماسكًا**.

### 2. الفقرة الحجاجية

الفقرة الحجاجية المتماسكة تُبنى على ثلاثة أركان:

1. **الجملة المفتاحية**: تُعلن الفكرة الرئيسة للفقرة.
2. **الحجّة + المثال**: تُبرهن على الفكرة وتُجسّدها.
3. **الجملة الخاتمة/الرابط**: تستنتج أو تُمهّد للفقرة التالية.

### 3. الحجّة والمثال — كيف نميّز؟

- **الحجّة**: فكرة عقليّة عامّة تُبرّر الموقف («العمل يصون كرامة الإنسان»).
- **المثال**: واقعة جزئيّة محسوسة تُجسّد الحجّة («فالحرفيّ الذي يكسب قوته بيده يأبى المذلّة»).

> ⚖️ المثال يخدم الحجّة ولا يحلّ محلّها؛ حجّةٌ بلا مثال جافّة، ومثالٌ بلا حجّة ناقص.

### 4. الروابط المنطقية في الإنتاج

تُنظّم تسلسل الأفكار وتُظهر العلاقات بينها:

- للترتيب: أوّلًا، ثانيًا، وأخيرًا.
- للإضافة: علاوةً على ذلك، كما.
- للتعليل: لأنّ، إذ.
- للنتيجة: ومن ثمّ، لذلك.
- للاستدراك: غير أنّ، على أنّ.

### 5. اختيار الإنتاج المتماسك

الإنتاج الجيّد:

- **منسجم**: أفكاره مترابطة لا متناثرة.
- **مناسب**: يلتزم المطلوب (السند والتعليمة).
- **سليم**: لغته فصيحة صحيحة الإعراب والإملاء.
- **متدرّج**: ينتقل من فكرة إلى أخرى بروابط واضحة.

> 🏆 من فهم النصّ فهمًا عميقًا، وبنى إنتاجه بناءً منظَّمًا، ضمن جُلّ نقاط الاختبار.', '# 📜 ملخّص: فهم المقروء والإنتاج الكتابي

## فهم المقروء (شرح النصّ)

- **الفكرة العامة**: الموضوع المحوريّ للنصّ كلّه في جملة جامعة (تتركّز غالبًا في المطلع والخاتمة).
- **الأفكار الجزئية**: وحدات المعنى المتفرّعة، فكرة لكلّ مقطع؛ ومجموعها = الفكرة العامة.
- **أنواع النصوص**: سرديّ (أحداث متسلسلة)، وصفيّ (صورة حسّية)، تفسيريّ (شرح ظاهرة)، حجاجيّ (الدفاع عن أطروحة).
- **الروابط**: السبب (لأنّ)، النتيجة (لذلك)، الإضافة (كذلك)، المعارضة (لكنْ، رغم)، التمثيل (مثلًا).
- **النبرة**: موقف الكاتب الانفعاليّ، تُستشفّ من المفردات المشحونة وأساليب الإنشاء والتكرار.
- **الاستنتاج**: استخلاص ما لم يُصرَّح به اعتمادًا على قرائن النصّ (لا من خارجه).
- **شرح المفردة**: السياق يحدّد المعنى المقصود لا المعنى الأشهر في المعجم.

## الإنتاج الكتابي

- **التصميم**: مقدّمة (تمهيد + أطروحة) ← جوهر (فقرات حجّة/مثال) ← خاتمة (تلخيص + أفق).
- **الفقرة الحجاجية**: جملة مفتاحية + حجّة ومثال + جملة خاتمة/رابط.
- **الحجّة** فكرة عقليّة عامّة، و**المثال** واقعة جزئيّة تُجسّدها؛ المثال يخدم الحجّة ولا يحلّ محلّها.
- **الروابط المنطقية**: للترتيب والإضافة والتعليل والنتيجة والاستدراك.
- **الإنتاج المتماسك**: منسجم، مناسب للتعليمة، سليم اللغة، متدرّج بروابط واضحة.', 10),
  ('ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Reading Comprehension & Writing', 'Read short texts with confidence and write clear paragraphs: find the main idea, scan for details, make inferences, resolve reference words, guess vocabulary from context, read connectors, and build well-organised paragraphs.', '# 📖 Reading Comprehension & Writing — Read Smart, Write Clear

> 💡 "A good reader is a detective: every text leaves clues. A good writer is a guide: every paragraph follows a path."

This chapter is your toolkit for the two big skills of the exam: **understanding a written text** and **producing a short, organised piece of writing** in English.

---

## 🔍 Part 1 — Reading Comprehension

### 🏰 1. Finding the main idea

The **main idea** is the single most important message of the whole text — not one small detail. To find it, ask: _"What is the writer mostly talking about? What would the title be?"_

- The main idea is often in the **first** or **last** sentence of a paragraph (the **topic sentence**).
- The other sentences usually **support** it with examples, reasons or details.

> 🗡️ Trap: a true detail is not the same as the main idea. "The text mentions a school garden" can be true but still be too small to be the main idea.

### ⚡ 2. Scanning for specific details

When a question asks _"How many…? When…? Who…? Where…?"_, you do not read everything — you **scan**. Move your eyes quickly, looking only for the **key word** in the question (a name, a number, a date, a place). Stop when you find it, then read that sentence carefully.

> 🛡️ Answer with what the text **says**, not with what you already know or guess.

### 🔮 3. Making inferences (reading between the lines)

An **inference** is a conclusion the text does **not** state directly but clearly suggests. You combine the clues with logic.

- _"Sami put on his coat, took his umbrella and looked at the grey sky."_ → We **infer** that it is going to rain. The text never says "rain", but the clues prove it.

> ⚠️ A good inference is **supported by the text**. If you cannot point to the clue, it is a guess, not an inference.

### 🧭 4. Reference words and pronouns

Writers avoid repeating words by using **reference words**: pronouns (_it, they, them, he, she, this, these, that_) and others. To understand a text, you must know what each one **points back to**.

- _"My brother bought a new phone. **It** was very expensive."_ → **It** = the phone.
- _"Students who revise daily pass easily. **They** rarely panic."_ → **They** = the students who revise daily.

> 🗡️ Rule of thumb: a pronoun usually refers to the **nearest matching noun** that came **before** it, and it must **agree** in number (singular/plural) and type (person/thing).

### 📚 5. Guessing vocabulary from context

You will meet unknown words. Do not stop — use the **context** (the words around) to guess the meaning.

- **Examples / lists**: _"reptiles such as snakes, lizards and **geckos**"_ → a gecko is a reptile.
- **Synonyms / definitions**: _"He was **furious**, that is, extremely angry."_
- **Contrast words** (but, however): _"The shop was tiny, **but** the storeroom was **spacious**."_ → spacious ≠ tiny, so it means roomy/large.

### 🔗 6. Connectors and their function

**Connectors** (linking words) show the **relationship** between ideas. Knowing their job helps you follow the writer''s logic.

| Function              | Connectors                                     |
| --------------------- | ---------------------------------------------- |
| Addition              | and, also, moreover, in addition, besides      |
| Contrast / opposition | but, however, although, yet, on the other hand |
| Cause                 | because, since, as, due to                     |
| Result / consequence  | so, therefore, thus, as a result               |
| Purpose               | to, in order to, so that                       |
| Example               | for example, such as, for instance             |
| Time / sequence       | first, then, after that, finally               |

> 🛡️ _"She studied hard, **therefore** she passed."_ → result. _"She studied hard, **but** she failed."_ → contrast.

---

## ✍️ Part 2 — Guided Writing

### 🏰 7. The topic sentence

A paragraph is about **one** main idea. The **topic sentence** states that idea — usually the **first** sentence. It should be:

- **Clear** (the reader knows the subject at once),
- **General enough** to cover the whole paragraph,
- but **not** just one tiny detail.

> 🗡️ Compare: _"Family life is important for many reasons."_ (good topic sentence) vs _"My cousin is twelve years old."_ (too narrow — only a detail).

### ⚡ 8. Organising a paragraph

A strong paragraph follows a clear order:

1. **Topic sentence** — announces the main idea.
2. **Supporting sentences** — give reasons, examples or details, in a logical order.
3. **Concluding / closing sentence** — sums up or gives a final thought.

> ⚠️ Every sentence must be **relevant**. A sentence that does not support the topic is an **irrelevant sentence** and should be removed.

### 🔗 9. Linking words in writing

Use connectors to join your ideas smoothly so the paragraph flows:

- Add ideas: _and, also, moreover._
- Show contrast: _but, however, although._
- Give reasons: _because, since._
- Show results: _so, therefore._
- Order ideas: _first, then, after that, finally._

> 🛡️ Choose the linking word by **meaning**: do not write "I was tired, **therefore** I went out" if you mean a contrast — use **but**.

### 🧱 10. A short guided paragraph (model)

**Task:** Write a short paragraph about the importance of reading.

> **Reading is one of the most useful habits a student can have.** First, it improves your vocabulary, **so** you write and speak more easily. **Moreover**, books open your mind to new ideas and faraway places. **Although** some people find it boring at first, the habit quickly becomes a real pleasure. **For these reasons**, every student should read a little every day.

Notice the structure: a clear **topic sentence**, **supporting ideas** linked with connectors (_first, so, moreover, although_), and a **closing sentence** (_for these reasons…_).

> 🏆 Read like a detective, write like a guide — and the exam text holds no surprises.', '# 📜 Summary: Reading Comprehension & Writing

## Reading

- **Main idea** = the whole text''s key message (often the topic sentence), not a small detail.
- **Scanning** = move fast and hunt only for the key word (name, number, date, place) to find a specific detail.
- **Inference** = a conclusion the text suggests but does not state; it must be supported by clues.
- **Reference words / pronouns** (it, they, this…) point back to the nearest matching noun before them; they must agree in number.
- **Vocabulary from context** = guess unknown words using examples, synonyms/definitions, or contrast words.
- **Connectors** show relationships: addition (also), contrast (but, however), cause (because), result (so, therefore), purpose (to), example (such as), time (first, then, finally).

## Writing

- **Topic sentence** = clear, general first sentence stating the paragraph''s one main idea.
- **Paragraph order** = topic sentence → supporting sentences (logical order) → closing sentence.
- **Linking words** join ideas smoothly; choose them by meaning (don''t use "therefore" for a contrast).
- **Irrelevant sentence** = one that does not support the topic — remove it.
- **Coherent continuation** = the next sentence must follow logically from the ones before.', 9)
) AS v(id, subject_id, title, description, lesson_content, summary, display_order)
WHERE EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

-- Garde de reconstruction sur base VIERGE (2026-07-20, suite a l'etude 24 lot 4) :
-- chaque ligne n'est inseree que si son parent existe. Sur la prod tous les parents sont
-- la et le comportement est identique ; sur une base reconstruite depuis le seul repo
-- public, le corpus genere est absent et ces lignes n'ont plus d'objet.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order)
SELECT v.id::uuid, v.chapter_id::uuid, v.subject_id, v.title, v.difficulty, v.xp_reward, v.reward_coins, v.mode, v.source, v.display_order
FROM (VALUES
  ('357f5e8d-e17d-5fd3-a688-7a04622ccff7', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Diagnostic — Compréhension & production', 1, 20, 5, 'quiz', 'admin', 0),
  ('09b2c180-a0bd-5852-9b7d-18c86c4d4167', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Exercice 1 — Lire et repérer', 2, 50, 10, 'practice', 'admin', 1),
  ('f7331495-eabf-5d6b-b33b-4d012d11c3c3', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Exercice 2 — Vers la production écrite', 2, 50, 10, 'practice', 'admin', 2),
  ('3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', '⚔️ Boss — Lecture fine & argumentation', 3, 120, 30, 'boss', 'admin', 3),
  ('a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', '👑 Défi élite — Maîtrise compréhension & rédaction', 4, 300, 60, 'challenge', 'admin', 4),
  ('31dee382-2d7f-508c-8398-79fd2adb9a64', '77ace903-23f8-5a38-8bfe-4fbb1b0369fa', 'arabic', 'اختبار فهم المقروء', 1, 20, 5, 'quiz', 'admin', 0),
  ('206036c9-5046-5b14-b8e4-183e4a2a9d03', '77ace903-23f8-5a38-8bfe-4fbb1b0369fa', 'arabic', 'تمرين 1 — فهم المقروء: الفكرة والنمط والروابط', 2, 50, 10, 'practice', 'admin', 1),
  ('b645b9d7-e9d1-563f-a836-0104be43edba', '77ace903-23f8-5a38-8bfe-4fbb1b0369fa', 'arabic', 'تمرين 2 — الإنتاج الكتابي: التصميم والحجاج', 2, 50, 10, 'practice', 'admin', 2),
  ('e3ab459c-7cc9-579f-81a8-def4cf3d7483', '77ace903-23f8-5a38-8bfe-4fbb1b0369fa', 'arabic', '⚔️ زعيم الفصل: تحليل النصّ المركّب', 3, 120, 30, 'boss', 'admin', 3),
  ('8d7b07eb-7025-5d92-a33d-73107fbb46d4', '77ace903-23f8-5a38-8bfe-4fbb1b0369fa', 'arabic', '👑 تحدّي النخبة: دقائق الفهم والإنتاج', 4, 300, 60, 'challenge', 'admin', 4),
  ('6f4fe871-4346-5f8c-b962-72c71250e9bb', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0),
  ('58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Practice: read and understand (1)', 1, 50, 10, 'practice', 'admin', 1),
  ('1b387c5d-e284-59e9-a936-4be304908ee3', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Practice: building good paragraphs (2)', 2, 50, 10, 'practice', 'admin', 2),
  ('7a76fb51-3640-57fa-bff6-25ef94248cfb', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', '⚔️ Boss: read deeply, write tightly', 3, 120, 30, 'boss', 'admin', 3),
  ('ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', '👑 Elite Challenge: Master Reader & Writer', 4, 300, 60, 'challenge', 'admin', 4)
) AS v(id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order)
WHERE EXISTS (SELECT 1 FROM public.chapters p WHERE p.id = v.chapter_id::uuid) AND EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

-- Garde de reconstruction sur base VIERGE (2026-07-20, suite a l'etude 24 lot 4) :
-- chaque ligne n'est inseree que si son parent existe. Sur la prod tous les parents sont
-- la et le comportement est identique ; sur une base reconstruite depuis le seul repo
-- public, le corpus genere est absent et ces lignes n'ont plus d'objet.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
SELECT v.id::uuid, v.exercise_id::uuid, v.prompt, v.options, v.correct_option, v.explanation, v.display_order
FROM (VALUES
  ('88c1f48a-2a35-5d6c-874a-6cec41778111', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez ce passage :

« La lecture n''est pas un simple passe-temps. En ouvrant un livre, l''élève enrichit son vocabulaire, voyage dans d''autres mondes et apprend à mieux comprendre les autres. Voilà pourquoi lire devrait accompagner chaque jeune tout au long de ses études. »

Quelle est l''idée directrice de ce texte ?', '[{"id":"a","text":"La lecture fait perdre du temps aux élèves."},{"id":"b","text":"La lecture est précieuse et devrait accompagner toute la scolarité."},{"id":"c","text":"Les livres parlent surtout de voyages lointains."},{"id":"d","text":"Le vocabulaire est la seule chose qu''on apprend en lisant."}]'::jsonb, 'b', 'Le texte énumère les bienfaits de la lecture puis conclut qu''elle « devrait accompagner chaque jeune » : c''est son idée directrice. (a) dit le contraire du texte (« n''est pas un simple passe-temps » la valorise). (c) n''est qu''un détail imagé (« voyage dans d''autres mondes »). (d) réduit le texte à un seul de ses arguments, alors qu''il en cite plusieurs.', 1),
  ('077020c3-a4f1-5622-8cb0-aec77f757230', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez ce passage :

« Le vieux pêcheur poussa sa barque dans l''eau noire, saisit ses rames et s''éloigna lentement du rivage. Au loin, une lumière clignotait. Il rama jusqu''à ce que le village disparût derrière lui. »

De quel type de texte s''agit-il ?', '[{"id":"a","text":"Narratif : il raconte une suite d''actions accomplies par un personnage."},{"id":"b","text":"Argumentatif : il défend l''idée que la pêche est un métier difficile."},{"id":"c","text":"Informatif : il explique comment fabriquer une barque."},{"id":"d","text":"Descriptif : il se contente de peindre un paysage immobile."}]'::jsonb, 'a', 'Le texte enchaîne des actions (poussa, saisit, s''éloigna, rama) accomplies par un personnage : c''est un récit, donc un texte narratif. (b) : aucune thèse n''est défendue. (c) : rien n''explique une fabrication. (d) est le piège classique — il y a bien quelques notations de décor, mais ce sont les verbes d''action qui dominent, et le paysage n''est pas immobile puisqu''il y a mouvement et progression.', 2),
  ('cda55e3c-d0ae-5f6b-a367-0665f55d4452', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez cet extrait :

« Beaucoup pensent que protéger l''environnement coûte trop cher. Pourtant, ne rien faire coûtera bien plus encore : inondations, sécheresses et récoltes perdues pèseront lourd sur les générations futures. »

Quel est le rôle du connecteur « Pourtant » dans ce passage ?', '[{"id":"a","text":"Il ajoute un argument de même sens que le précédent."},{"id":"b","text":"Il oppose à l''idée précédente une objection qui la corrige."},{"id":"c","text":"Il introduit la cause de ce qui vient d''être dit."},{"id":"d","text":"Il donne un exemple illustrant l''idée précédente."}]'::jsonb, 'b', '« Pourtant » est un connecteur d''opposition : il oppose à l''opinion répandue (« protéger coûte trop cher ») l''idée contraire de l''auteur (« ne rien faire coûtera plus »). (a) confondrait avec une addition (de plus). (c) serait le rôle de « car » ou « parce que ». (d) serait celui de « par exemple ».', 3),
  ('67dff524-0781-58b6-8b30-fd200e7d0b94', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez ce court texte :

« Layla relisait sa copie pour la dixième fois. Ses mains tremblaient, son cœur battait fort, et elle n''osait pas regarder le professeur qui distribuait les résultats. »

Quel sentiment domine chez Layla ?', '[{"id":"a","text":"L''ennui d''une journée trop longue."},{"id":"b","text":"La fierté d''avoir bien travaillé."},{"id":"c","text":"L''anxiété avant l''annonce des résultats."},{"id":"d","text":"La colère contre son professeur."}]'::jsonb, 'c', 'Les indices physiques (mains qui tremblent, cœur qui bat fort, n''ose pas regarder) expriment clairement l''anxiété au moment des résultats. (a) : rien ne marque l''ennui, au contraire tout est tendu. (b) : la fierté supposerait de l''assurance, absente ici. (d) : aucun signe d''hostilité envers le professeur.', 4),
  ('6037748e-1848-57f4-913d-e039fdf1f606', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez cet extrait :

« Quand Karim rentra, il secoua son manteau trempé, ôta ses bottes pleines de boue et alla vite se réchauffer près du poêle. »

Que peut-on déduire (inférer) de ce passage ?', '[{"id":"a","text":"Karim revient de vacances au bord de la mer."},{"id":"b","text":"Il faisait mauvais temps dehors (pluie et froid)."},{"id":"c","text":"Karim n''aime pas marcher."},{"id":"d","text":"Le poêle était en panne."}]'::jsonb, 'b', 'Le manteau « trempé », les bottes « pleines de boue » et le besoin de « se réchauffer » sont des indices qui permettent d''inférer un temps pluvieux et froid, bien que ce ne soit jamais écrit. (a), (c) et (d) ne reposent sur aucun indice du texte : ce sont des suppositions gratuites, pas des inférences.', 5),
  ('6164593c-8c3a-5c0b-ac23-a2fc17bfa4b2', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez cette phrase :

« Devant la difficulté, beaucoup baissent les bras, mais les plus tenaces persévèrent jusqu''au bout. »

Dans ce contexte, que signifie le mot « tenaces » ?', '[{"id":"a","text":"Des personnes paresseuses."},{"id":"b","text":"Des personnes qui ne renoncent pas facilement."},{"id":"c","text":"Des personnes très riches."},{"id":"d","text":"Des personnes distraites."}]'::jsonb, 'b', 'Le mot s''oppose, grâce à « mais », à ceux qui « baissent les bras », et il est associé à « persévèrent jusqu''au bout » : « tenaces » désigne donc ceux qui ne renoncent pas. Le contexte (opposition + synonyme proche) guide le sens. (a) est l''inverse, (c) et (d) n''ont aucun lien avec la persévérance évoquée.', 6),
  ('da81e1c3-f253-583b-99f4-a6da7ad2cc84', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Vous devez écrire un texte pour défendre l''idée que le travail en équipe est utile. Laquelle de ces phrases est la meilleure phrase de thèse ?', '[{"id":"a","text":"Je vais parler un peu du travail en équipe dans ce texte."},{"id":"b","text":"Le travail en équipe existe depuis très longtemps."},{"id":"c","text":"Le travail en équipe est précieux, car il permet de partager les idées et de réussir ensemble."},{"id":"d","text":"Certaines personnes travaillent seules, d''autres en groupe."}]'::jsonb, 'c', 'Une bonne phrase de thèse affirme clairement une position et annonce ce qu''on va prouver : (c) défend l''utilité du travail en équipe et donne déjà l''orientation (partage, réussite). (a) annonce seulement le sujet sans prendre position. (b) est un constat général qui ne défend rien. (d) présente deux possibilités sans choisir, donc ne défend aucune thèse.', 7),
  ('5e019169-bdbe-5788-9b5e-13db4ae7b22f', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Vous écrivez un paragraphe pour montrer que les écrans nuisent au sommeil des jeunes. Quel est l''ordre logique correct des phrases d''un paragraphe argumentatif ?

1) Par exemple, beaucoup d''élèves regardent leur téléphone tard le soir et dorment mal.
2) Les écrans nuisent au sommeil des jeunes.
3) En effet, la lumière des écrans retarde l''endormissement.', '[{"id":"a","text":"1 puis 2 puis 3"},{"id":"b","text":"2 puis 3 puis 1"},{"id":"c","text":"3 puis 1 puis 2"},{"id":"d","text":"1 puis 3 puis 2"}]'::jsonb, 'b', 'Un paragraphe argumentatif suit l''ordre : annoncer l''argument (2), expliquer (3, introduit par « en effet »), illustrer par un exemple (1, introduit par « par exemple »). L''ordre 2-3-1 respecte cette progression. Les autres ordres placent l''exemple ou l''explication avant l''idée qu''ils sont censés soutenir, ce qui brise la logique.', 8),
  ('b72b8ada-ccf2-5bf3-9765-42edf26bab42', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez ce passage :

« Trier ses déchets demande peu d''efforts, mais ce petit geste a de grands effets. Le verre, le plastique et le papier triés sont recyclés au lieu d''être brûlés. Chaque famille qui trie aide ainsi à protéger sa ville. »

Quelle est l''idée directrice de ce texte ?', '[{"id":"a","text":"Le tri des déchets est compliqué et fatigant."},{"id":"b","text":"Le verre est le déchet le plus facile à recycler."},{"id":"c","text":"Le tri des déchets est un geste simple aux grands effets utiles."},{"id":"d","text":"Brûler les déchets est la meilleure solution."}]'::jsonb, 'c', 'Le texte affirme dès la première phrase que trier « demande peu d''efforts, mais a de grands effets », puis le prouve : c''est l''idée directrice. (a) dit le contraire (« peu d''efforts »). (b) n''est qu''un exemple parmi le verre, le plastique et le papier. (d) est rejeté par le texte, qui oppose le recyclage au fait de brûler.', 1),
  ('6f1c8665-d1c0-5ed3-8519-bcfa7acab159', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez ce passage :

« Le matin se levait sur le marché. Les étals débordaient d''oranges luisantes, de menthe fraîche et de piments rouges. Une odeur de pain chaud flottait dans l''air tiède. »

De quel type de texte s''agit-il ?', '[{"id":"a","text":"Descriptif : il peint un lieu à l''aide de notations sensorielles."},{"id":"b","text":"Narratif : il raconte une suite d''aventures au marché."},{"id":"c","text":"Argumentatif : il défend l''idée qu''il faut acheter local."},{"id":"d","text":"Informatif : il explique l''organisation d''un marché."}]'::jsonb, 'a', 'Le texte fait appel à la vue (oranges luisantes, piments rouges), à l''odorat (odeur de pain) et au toucher (air tiède) pour peindre un tableau : c''est descriptif. (b) : il n''y a pas d''actions enchaînées ni de personnage agissant. (c) : aucune opinion n''est défendue. (d) : rien n''explique un fonctionnement.', 2),
  ('848ed66c-2d55-5f47-8712-32262aa46735', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Vous écrivez un texte qui commence par cette amorce :

« Aujourd''hui, beaucoup de jeunes passent des heures sur leur téléphone… »

Quelle phrase de thèse continue le mieux cette introduction sur le thème : faut-il limiter le temps d''écran ?', '[{"id":"a","text":"Le téléphone a été inventé il y a longtemps."},{"id":"b","text":"Je ne sais pas trop quoi penser de ce sujet."},{"id":"c","text":"Il est nécessaire de limiter ce temps d''écran pour protéger leur santé et leurs études."},{"id":"d","text":"Les téléphones existent en plusieurs couleurs."}]'::jsonb, 'c', 'Après l''amorce, la thèse doit annoncer clairement la position défendue : (c) prend position (limiter) et annonce les raisons (santé, études). (a) est un fait sans rapport avec la question posée. (b) ne défend aucune position. (d) est hors sujet.', 3),
  ('f8aae127-a29c-5649-b8cf-3904e0c38fae', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez cet extrait :

« Internet permet de trouver des informations en quelques secondes. Cependant, toutes ces informations ne sont pas fiables : il faut vérifier ses sources. »

Quel est le rôle du connecteur « Cependant » ?', '[{"id":"a","text":"Il ajoute une idée de même sens à la précédente."},{"id":"b","text":"Il introduit une réserve qui nuance l''idée précédente."},{"id":"c","text":"Il exprime la conséquence de la phrase précédente."},{"id":"d","text":"Il donne la cause de la première phrase."}]'::jsonb, 'b', '« Cependant » est un connecteur d''opposition : après avoir reconnu un avantage d''Internet (rapidité), il introduit une réserve (les informations ne sont pas toutes fiables). (a) confondrait avec une addition. (c) serait « donc » ou « ainsi ». (d) serait « car » ou « parce que ».', 4),
  ('c1c1ffd4-400a-594b-9408-521f081076f6', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez ce court texte :

« Sami regardait la photo de son grand-père. Il sourit doucement, puis ses yeux se remplirent de larmes. Cet homme lui manquait tant. »

Quel sentiment l''auteur cherche-t-il à transmettre ?', '[{"id":"a","text":"La peur face à un danger."},{"id":"b","text":"La colère contre sa famille."},{"id":"c","text":"L''indifférence totale de Sami."},{"id":"d","text":"Une émotion mêlée de tendresse et de tristesse."}]'::jsonb, 'd', 'Le sourire (tendresse), les larmes et la phrase « cet homme lui manquait tant » (tristesse, manque) traduisent une émotion mêlée : c''est le sentiment visé. (a) : aucun danger. (b) : aucune trace de colère. (c) est contredit par les larmes et le manque exprimés.', 5),
  ('63482caa-22d4-592a-b78f-a4be32dfe9ed', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez cet extrait :

« Quand la cloche sonna, les élèves rangèrent précipitamment leurs cahiers, attrapèrent leurs sacs et se ruèrent vers la porte. »

Que peut-on inférer de ce passage ?', '[{"id":"a","text":"Les élèves détestent leur professeur."},{"id":"b","text":"La cloche a marqué la fin du cours et la sortie."},{"id":"c","text":"Le cours venait juste de commencer."},{"id":"d","text":"Il n''y avait personne dans la classe."}]'::jsonb, 'b', 'Ranger ses affaires, attraper son sac et se ruer vers la porte après la cloche permet d''inférer que le cours est terminé, même si ce n''est pas écrit. (a) est une supposition sans indice. (c) contredit le rangement des affaires. (d) est absurde : on parle bien d''élèves présents.', 6),
  ('0714313c-d0bd-5997-af4d-ff5c4c6ef2fa', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Lisez ce passage :

« Le travail manuel est trop souvent méprisé. Pourtant, sans le menuisier, le plombier ou l''électricien, nos maisons ne tiendraient pas debout. Ces métiers méritent autant de respect que les autres. »

Quelle est la thèse défendue par l''auteur ?', '[{"id":"a","text":"Les métiers manuels sont inutiles aujourd''hui."},{"id":"b","text":"Les métiers manuels méritent le respect au même titre que les autres."},{"id":"c","text":"Le menuisier gagne plus que l''électricien."},{"id":"d","text":"Il faut interdire les études longues."}]'::jsonb, 'b', 'La thèse est annoncée et confirmée en dernière phrase : ces métiers « méritent autant de respect que les autres ». (a) est le préjugé que l''auteur combat (« trop souvent méprisé »). (c) n''est pas évoqué. (d) n''a aucun lien avec le texte.', 1),
  ('a849745d-22e2-5d25-a391-5993cf4a12b9', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Lisez cette phrase :

« Grâce à la solidarité des voisins, la vieille dame put réparer son toit avant l''hiver. »

Dans ce contexte, que signifie le mot « solidarité » ?', '[{"id":"a","text":"Le fait que les voisins s''entraident et se soutiennent."},{"id":"b","text":"Le fait que les voisins se disputent souvent."},{"id":"c","text":"Le prix très élevé des réparations."},{"id":"d","text":"La solitude de la vieille dame."}]'::jsonb, 'a', '« Grâce à » indique une aide positive, et le résultat (le toit réparé) montre que les voisins ont soutenu la dame : « solidarité » désigne l''entraide. (b) est le contraire d''une entraide. (c) parle d''argent, absent ici. (d) contredit l''idée même de voisins qui aident.', 2),
  ('ae6d3414-72ac-5ec1-8a0d-2a2bafdfdbfb', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Vous voulez ajouter un deuxième argument dans votre texte. Vous venez d''écrire : « La lecture enrichit le vocabulaire. » Quel connecteur convient le mieux pour introduire un nouvel argument allant dans le même sens ?', '[{"id":"a","text":"Cependant, la lecture développe aussi l''imagination."},{"id":"b","text":"De plus, la lecture développe l''imagination."},{"id":"c","text":"Car la lecture développe l''imagination."},{"id":"d","text":"Donc la lecture développe l''imagination."}]'::jsonb, 'b', 'Pour ajouter un argument de même sens, on emploie un connecteur d''addition : « De plus ». (a) « Cependant » marquerait une opposition, ce qui serait faux ici. (c) « Car » introduirait une cause, pas un nouvel argument. (d) « Donc » exprimerait une conséquence, ce qui ne convient pas.', 3),
  ('a381c43d-3ee3-5596-8c42-6530377c5810', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Sujet de rédaction : « Faut-il aider les autres ? » Laquelle de ces phrases est la meilleure phrase d''amorce pour commencer l''introduction ?', '[{"id":"a","text":"En conclusion, aider les autres est toujours bon."},{"id":"b","text":"Mon plat préféré est le couscous."},{"id":"c","text":"Dans la vie de tous les jours, nous croisons souvent des personnes qui ont besoin d''un coup de main."},{"id":"d","text":"Voici mon premier argument sur l''entraide."}]'::jsonb, 'c', 'Une bonne amorce introduit le sujet par un constat général, sans encore le traiter : (c) ouvre sur l''entraide quotidienne, en lien direct avec le sujet. (a) est une conclusion, pas une amorce. (b) est hors sujet. (d) saute directement à l''argument sans introduire.', 4),
  ('99c7d327-4658-5405-81d2-3c44b00ce441', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Lisez ce passage :

« On dit parfois que la télévision rend les enfants paresseux. Certes, trop d''écran peut nuire. Mais bien choisis, certains documentaires éveillent leur curiosité et les instruisent. »

Quelle phrase joue le rôle du contre-argument que l''auteur reconnaît avant de le nuancer ?', '[{"id":"a","text":"« certains documentaires éveillent leur curiosité »"},{"id":"b","text":"« Certes, trop d''écran peut nuire. »"},{"id":"c","text":"« et les instruisent »"},{"id":"d","text":"« bien choisis »"}]'::jsonb, 'b', 'Le contre-argument est l''objection adverse que l''auteur admet d''abord (« Certes… ») avant de la dépasser par « Mais ». Ici, « Certes, trop d''écran peut nuire » est cette concession. (a) et (c) sont au contraire les arguments de l''auteur. (d) n''est qu''une condition (« bien choisis ») à l''intérieur de son argument.', 5),
  ('48881931-78d7-5e4a-a742-a3d4d7e8ef95', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Vous rédigez sur le thème « le sport est bon pour la santé ». Laquelle de ces suites de deux phrases est COHÉRENTE ?', '[{"id":"a","text":"Le sport renforce le cœur. Par exemple, marcher chaque jour fait du bien au cœur."},{"id":"b","text":"Le sport renforce le cœur. Pourtant, marcher chaque jour fait du bien au cœur."},{"id":"c","text":"Le sport renforce le cœur. Le couscous est un plat tunisien."},{"id":"d","text":"Le sport renforce le cœur. Donc il est dangereux pour la santé."}]'::jsonb, 'a', 'En (a), l''exemple (« marcher chaque jour ») illustre logiquement l''idée annoncée, et le connecteur « par exemple » est juste : c''est cohérent. (b) emploie « Pourtant » alors que les deux phrases vont dans le même sens : connecteur mal choisi. (c) introduit une idée hors sujet. (d) se contredit (« bon pour la santé » puis « dangereux »).', 6),
  ('cc114016-dacc-5dd5-87e4-6b7b5f2af178', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez ce passage :

« Certains affirment que la technologie isole les gens. C''est oublier qu''un simple appel vidéo réunit aujourd''hui des familles séparées par des milliers de kilomètres. La technologie ne sépare pas : tout dépend de l''usage qu''on en fait. »

Quelle est la thèse exacte de l''auteur ?', '[{"id":"a","text":"La technologie isole toujours les gens."},{"id":"b","text":"La technologie relie ou sépare selon l''usage qu''on en fait."},{"id":"c","text":"Les appels vidéo sont gratuits partout dans le monde."},{"id":"d","text":"Il faut interdire la technologie dans les familles."}]'::jsonb, 'b', 'La dernière phrase nuance : « tout dépend de l''usage qu''on en fait ». L''auteur ne dit ni que la technologie isole (a, l''opinion qu''il réfute), ni qu''elle est toujours bonne, mais que l''effet dépend de l''usage. (c) déforme un détail (l''appel vidéo n''est jamais dit gratuit). (d) propose une interdiction absente du texte.', 1),
  ('ab06e97b-51fd-59b0-a4d9-cde2df12c486', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez cet extrait :

« Il prétendait n''avoir jamais eu peur de rien. Pourtant, ce soir-là, sa voix tremblait et il vérifia trois fois que la porte était bien fermée. »

Que suggère implicitement l''auteur à propos de ce personnage ?', '[{"id":"a","text":"Le personnage est, en réalité, effrayé malgré ce qu''il dit."},{"id":"b","text":"Le personnage est parfaitement courageux."},{"id":"c","text":"Le personnage a oublié de fermer sa porte."},{"id":"d","text":"Le personnage déteste les portes."}]'::jsonb, 'a', 'Le « Pourtant » oppose les paroles du personnage (« jamais eu peur ») à ses gestes (voix tremblante, vérification répétée) : l''auteur laisse ainsi entendre qu''il a peur, contrairement à ce qu''il prétend. (b) prend ses paroles pour argent comptant et ignore les indices. (c) contredit « vérifia trois fois que la porte était bien fermée ». (d) est absurde.', 2),
  ('2c4105f3-590a-55c7-80ce-95b8f1d62296', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez ce passage :

« La pluie n''avait pas cessé depuis trois jours. Les rues étaient désertes, les rivières montaient, et dans chaque maison on guettait le ciel avec inquiétude. »

Quelle est la double fonction dominante de ce passage ?', '[{"id":"a","text":"Argumenter en faveur de la construction de barrages."},{"id":"b","text":"Décrire une atmosphère tout en suggérant une menace d''inondation."},{"id":"c","text":"Expliquer scientifiquement le cycle de l''eau."},{"id":"d","text":"Raconter le voyage d''un personnage principal."}]'::jsonb, 'b', 'Le passage est descriptif (rues désertes, rivières qui montent, ciel guetté) mais ces notations créent aussi une tension : on infère une menace d''inondation. (a) ne défend aucune thèse. (c) n''explique aucun phénomène scientifique. (d) : il n''y a pas de personnage qui agit ni de voyage, seulement un décor inquiétant.', 3),
  ('4d77f78a-4ba0-56fd-9efc-bdc72e22fd0f', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Vous rédigez un paragraphe argumentatif. Vous avez ces trois phrases :

1) Ainsi, lire un peu chaque jour aide vraiment à mieux écrire.
2) En effet, en lisant on rencontre sans cesse de nouvelles tournures de phrases.
3) La lecture régulière améliore l''expression écrite.

Quel est le bon ordre logique du paragraphe ?', '[{"id":"a","text":"3 puis 2 puis 1"},{"id":"b","text":"1 puis 2 puis 3"},{"id":"c","text":"2 puis 3 puis 1"},{"id":"d","text":"3 puis 1 puis 2"}]'::jsonb, 'a', 'Le paragraphe doit annoncer l''argument (3), l''expliquer avec « En effet » (2), puis conclure avec « Ainsi » (1) : l''ordre 3-2-1 respecte « annoncer → expliquer → conclure ». Les autres ordres placent la conclusion (« Ainsi ») ou l''explication (« En effet ») avant l''idée annoncée, ce qui rend le raisonnement illogique.', 4),
  ('db658899-ea60-5a21-978d-2adcde0df690', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Vous défendez l''idée que protéger l''environnement est l''affaire de tous. Vous voulez réfuter le contre-argument « c''est à l''État de tout faire ». Quelle phrase réfute correctement ce contre-argument ?', '[{"id":"a","text":"Certes, l''État a un rôle ; mais chaque citoyen peut agir par de petits gestes quotidiens."},{"id":"b","text":"L''État doit s''occuper de tout, c''est évident."},{"id":"c","text":"Par exemple, l''État construit des routes et des écoles."},{"id":"d","text":"De plus, l''État est responsable de l''environnement."}]'::jsonb, 'a', 'Réfuter un contre-argument, c''est le reconnaître (« Certes… ») puis le dépasser (« mais… »). (a) admet le rôle de l''État puis montre que le citoyen agit aussi : c''est une réfutation. (b) ne fait que répéter le contre-argument. (c) l''illustre au lieu de le réfuter. (d) le renforce encore avec « De plus ».', 5),
  ('c73cdfba-e320-5ce3-a0ba-eec42fb6c3ac', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez cette phrase :

« Loin de freiner les élèves, ces difficultés les ont aiguillonnés : ils ont travaillé plus dur que jamais. »

Dans ce contexte, que signifie le verbe « aiguillonner » ?', '[{"id":"a","text":"Décourager, faire abandonner."},{"id":"b","text":"Stimuler, pousser à agir davantage."},{"id":"c","text":"Endormir, rendre paresseux."},{"id":"d","text":"Tromper, induire en erreur."}]'::jsonb, 'b', '« Loin de freiner » annonce un sens opposé à « freiner », et la suite (« ils ont travaillé plus dur ») confirme : aiguillonner = stimuler, pousser à agir. (a) et (c) vont dans le sens du frein, contredit par la phrase. (d) (« tromper ») n''a aucun rapport avec l''effort accru décrit.', 6),
  ('b85ff5e5-4e6e-50d5-ac36-f62c86ac135f', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez ce passage :

« On vante sans cesse les progrès de la médecine moderne. Soit. Mais à quoi servent les hôpitaux les plus modernes si les plus pauvres n''y ont jamais accès ? Le vrai progrès n''est pas seulement technique : il est aussi celui de la justice. »

Quelle est l''idée directrice, formulée avec précision ?', '[{"id":"a","text":"La médecine moderne n''a fait aucun progrès."},{"id":"b","text":"Le progrès médical n''a de valeur que s''il est accessible à tous, donc juste."},{"id":"c","text":"Les hôpitaux modernes sont trop nombreux."},{"id":"d","text":"Les pauvres ne tombent jamais malades."}]'::jsonb, 'b', 'L''auteur concède les progrès techniques (« Soit »), puis affirme par une question rhétorique et la dernière phrase que le vrai progrès suppose la justice et l''accès de tous : c''est l''idée directrice. (a) déforme : l''auteur reconnaît les progrès. (c) n''est pas dit. (d) contredit l''idée même d''accès aux soins.', 1),
  ('4bcfa2d5-699a-5915-9ed7-a5fdf50ee301', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez cet extrait :

« — Bravo, vraiment, lança-t-il en regardant le vase brisé. Tu as encore fait un travail magnifique. »

Quel est le ton employé par le personnage ?', '[{"id":"a","text":"Un ton sincèrement admiratif."},{"id":"b","text":"Un ton ironique : il dit le contraire de ce qu''il pense."},{"id":"c","text":"Un ton neutre et informatif."},{"id":"d","text":"Un ton triste et résigné."}]'::jsonb, 'b', 'Le décalage entre les paroles élogieuses (« Bravo », « magnifique ») et la situation réelle (un vase brisé) signale l''ironie : le personnage dit le contraire de ce qu''il pense pour reprocher la maladresse. (a) prend les mots au premier degré, ignorant le contexte. (c) : l''exclamation et l''éloge ne sont pas neutres. (d) : aucune tristesse, plutôt un reproche moqueur.', 2),
  ('7718a410-1ad0-557d-b059-869541cb0241', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez ce passage :

« Elle rangea les jouets un à un, plia la petite couverture et resta longtemps assise dans la chambre devenue trop silencieuse. »

Que peut-on inférer du sentiment de ce personnage, sans qu''il soit nommé ?', '[{"id":"a","text":"Une joie débordante et bruyante."},{"id":"b","text":"Une indifférence totale envers l''enfant."},{"id":"c","text":"Une mélancolie liée à l''absence de l''enfant."},{"id":"d","text":"Une colère contre le désordre de la chambre."}]'::jsonb, 'c', 'La chambre « devenue trop silencieuse », les gestes lents et la longue immobilité laissent inférer une mélancolie liée au vide laissé par l''enfant, sans que le mot soit écrit. (a) est contredit par le silence et l''immobilité. (b) est démentie par le soin des gestes. (d) : elle range avec douceur, rien n''évoque la colère.', 3),
  ('996c1e06-7a10-5972-bd28-3db55e8234bd', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Sujet : « Le bénévolat est-il utile aux jeunes ? » Vous voulez une introduction où l''amorce et la thèse s''enchaînent parfaitement. Quel couple amorce + thèse est le mieux construit ?', '[{"id":"a","text":"Amorce : « De nos jours, beaucoup de jeunes cherchent à se rendre utiles autour d''eux. » Thèse : « Le bénévolat leur apporte beaucoup, car il développe leur sens des responsabilités et leur confiance. »"},{"id":"b","text":"Amorce : « Le bénévolat développe la confiance. » Thèse : « De nos jours, les jeunes cherchent à se rendre utiles. »"},{"id":"c","text":"Amorce : « En conclusion, le bénévolat est très utile. » Thèse : « Voici pourquoi je le pense. »"},{"id":"d","text":"Amorce : « J''aime beaucoup le sport. » Thèse : « Le bénévolat est utile. »"}]'::jsonb, 'a', 'En (a), l''amorce introduit le thème par un constat général lié au sujet, puis la thèse prend position en annonçant les raisons : l''enchaînement est correct. (b) inverse les rôles (l''amorce affirme déjà un argument, la thèse n''est qu''un constat). (c) commence par une conclusion, ce qui n''est pas une amorce. (d) ouvre sur un sujet sans rapport (le sport).', 4),
  ('1b0196a9-14d1-53f3-8931-9f5b3bed0f57', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez ce passage :

« Bien sûr, voyager coûte cher et fatigue. Toutefois, découvrir d''autres cultures ouvre l''esprit comme aucun livre ne le pourrait. »

Analysez la structure argumentative : quel est le statut de chaque partie ?', '[{"id":"a","text":"Première phrase = thèse de l''auteur ; seconde = exemple."},{"id":"b","text":"Première phrase = contre-argument concédé ; seconde = argument principal de l''auteur."},{"id":"c","text":"Les deux phrases défendent exactement la même idée."},{"id":"d","text":"Première phrase = conclusion ; seconde = amorce."}]'::jsonb, 'b', '« Bien sûr… » concède une objection (voyager coûte cher et fatigue) ; puis « Toutefois » introduit l''argument que l''auteur défend réellement (le voyage ouvre l''esprit). C''est le schéma concession + réfutation. (a) confond la concession avec la thèse. (c) ignore l''opposition marquée par « Toutefois ». (d) inverse l''ordre logique d''une argumentation.', 5),
  ('390010fb-85c6-5acf-973f-8c390cce218d', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Vous écrivez sur « l''importance de l''eau ». Laquelle de ces suites de phrases est INCOHÉRENTE (à éviter dans une production écrite) ?', '[{"id":"a","text":"L''eau est indispensable à la vie. En effet, aucun être vivant ne peut survivre longtemps sans elle."},{"id":"b","text":"L''eau est indispensable à la vie. C''est pourquoi il faut éviter de la gaspiller."},{"id":"c","text":"L''eau est indispensable à la vie. Pourtant, sans elle, aucun être vivant ne survivrait."},{"id":"d","text":"L''eau est indispensable à la vie. Par exemple, sans eau, les plantes se dessèchent."}]'::jsonb, 'c', 'En (c), « Pourtant » annonce une opposition, mais la suite confirme au contraire la première idée : le connecteur contredit le sens, ce qui rend la phrase incohérente. (a) (« En effet » = explication), (b) (« C''est pourquoi » = conséquence) et (d) (« Par exemple » = illustration) emploient tous un connecteur en accord avec la logique des idées.', 6),
  ('24421999-8a09-50c1-83a6-0a1a7846d004', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«العملُ شرفٌ للإنسان وصونٌ لكرامته؛ فبه يكسب قوته بعزّة، ويُغني نفسه عن مذلّة السؤال، ويسهم في بناء وطنه. وما الكسلُ إلّا بابٌ إلى المهانة والحاجة.»

ما الفكرة العامة للنصّ؟', '[{"id":"a","text":"العملُ مصدرٌ لكرامة الإنسان وعزّته، والكسلُ سبيلٌ إلى المهانة"},{"id":"b","text":"الإنسانُ يكسب قوته من العمل اليوميّ"},{"id":"c","text":"الكسلُ بابٌ إلى الحاجة فحسب"},{"id":"d","text":"بناءُ الوطن واجبٌ على كلّ مواطن"}]'::jsonb, 'a', 'الفكرة العامة جملةٌ جامعة تلمّ شتات النصّ: فهو يُمجّد العمل بوصفه شرفًا وكرامةً، ويذمّ الكسل بوصفه مهانة، فالخيار (a) يجمع الطرفين. أمّا (b) و(c) فتفصيلان جزئيّان وردا في سطر واحد، و(d) إشارةٌ عابرة لا تمثّل محور النصّ.', 1),
  ('5d041f3e-3e64-5303-9117-c65c1895a794', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«كانت السماءُ صافيةً زرقاءَ، تتدلّى منها خيوطُ الشمس الذهبيّة على حقولٍ خضراءَ ممتدّة. تتمايل السنابلُ مع النسيم في رقصةٍ هادئة، وتفوح من الأرض رائحةُ التراب النديّ.»

ما نمط هذا النصّ؟', '[{"id":"a","text":"وصفيّ: يرسم صورةً حسّية لمشهد طبيعيّ"},{"id":"b","text":"سرديّ: يحكي أحداثًا متسلسلة"},{"id":"c","text":"حجاجيّ: يدافع عن جمال الطبيعة"},{"id":"d","text":"تفسيريّ: يشرح ظاهرة طبيعية"}]'::jsonb, 'a', 'النصّ يكدّس النعوت (صافية، زرقاء، خضراء، الذهبية) ويخاطب الحواسّ (البصر والشمّ) ليرسم لوحةً ثابتة؛ وهذا هو النمط الوصفيّ. لا أحداث متسلسلة فيه (b)، ولا أطروحة يدافع عنها (c)، ولا شرح لظاهرة علميّة (d).', 2),
  ('9de33181-3076-5a72-8537-089771d94937', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«تسعى المرأةُ اليوم إلى موقعها في الحياة العامّة؛ غير أنّ بعض العقبات لا تزال تعترض طريقها.»

ما العلاقة التي يُحدثها الرابط «غير أنّ» بين الجملتين؟', '[{"id":"a","text":"علاقة استدراك ومعارضة"},{"id":"b","text":"علاقة سبب وتعليل"},{"id":"c","text":"علاقة إضافة وتراكم"},{"id":"d","text":"علاقة تمثيل وتوضيح"}]'::jsonb, 'a', '«غير أنّ» أداةُ استدراكٍ تُعارض ما قبلها: فبعد إثبات سعي المرأة، تستدرك بوجود عقبات، فتُحدث تقابلًا بين الطموح والواقع. وليست أداة تعليل كـ«لأنّ» (b)، ولا إضافة كـ«كذلك» (c)، ولا تمثيل كـ«مثلًا» (d).', 3),
  ('5acac469-595a-5aef-a1d5-ed0cf50a01f0', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«ها هي ذي قريتي القديمة! كم اشتقتُ إلى أزقّتها الضيّقة، وإلى صوت جدّي وهو يروي حكاياه تحت شجرة التين العتيقة. أيّامٌ ذهبت ولن تعود، فمتى يعود ذلك الزمن الجميل؟»

ما النبرة الغالبة على النصّ؟', '[{"id":"a","text":"الحنين إلى الماضي والأسى على انقضائه"},{"id":"b","text":"السخرية من حياة القرية البسيطة"},{"id":"c","text":"الفخر بانتمائه إلى قريته"},{"id":"d","text":"الغضب من تغيّر معالم القرية"}]'::jsonb, 'a', 'أفعالُ الشوق («اشتقتُ») وأسلوبا التعجّب («كم اشتقتُ») والاستفهام التحسّريّ («متى يعود؟») ووصفُ الأيّام بأنّها «ذهبت ولن تعود» كلّها قرائنُ تكشف نبرة الحنين والأسى. أمّا السخرية (b) فلا أثر لها، والفخر (c) موقفٌ مختلف، والغضب (d) لم يُذكر تغيُّرٌ يستثيره.', 4),
  ('b020123c-82ba-5d33-92f1-b80edf21627a', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«دخل الرجلُ متثاقلًا، يجرّ قدميه، ويُلقي نظراتٍ زائغة، ثمّ جلس في ركنٍ بعيد ولم ينطق ببنت شفة طوال السهرة.»

ماذا نستنتج عن حال الرجل ممّا لم يُصرَّح به مباشرة؟', '[{"id":"a","text":"أنّه كان مضطربًا أو منزعجًا يتجنّب الآخرين"},{"id":"b","text":"أنّه كان مسرورًا بلقاء الحاضرين"},{"id":"c","text":"أنّه كان متعبًا من السفر فقط"},{"id":"d","text":"أنّه جاء ليُلقي خطابًا في السهرة"}]'::jsonb, 'a', 'لم يقل الكاتب صراحةً إنّ الرجل منزعج، لكنّ القرائن (التثاقل، النظرات الزائغة، الجلوس في ركنٍ بعيد، الصمت التامّ) توحي باضطرابه وانعزاله؛ وهذه قراءةٌ بين السطور مدعومة بالنصّ. أمّا السرور (b) فيناقض القرائن، والتعب من السفر (c) إسقاطٌ لم يُذكر، و(d) يناقض صمته.', 5),
  ('725f4292-1bcc-52a5-b299-b38004316d10', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«ساد القاعةَ صمتٌ عميق، فلمّا صعد العازفُ إلى المنصّة وأمسك بوتر آلته، انسابت النغماتُ كنهرٍ رقراق، فسحرت القلوب وأطربت الأسماع.»

ما معنى كلمة «انسابت» في سياق النصّ؟', '[{"id":"a","text":"تدفّقت وجرت في انسيابٍ ليّن"},{"id":"b","text":"انقطعت فجأةً"},{"id":"c","text":"اشتدّت وعلت بقوّة"},{"id":"d","text":"تبعثرت وتفرّقت"}]'::jsonb, 'a', 'السياق (النغمات شُبّهت بـ«نهرٍ رقراق» وأطربت الأسماع) يحدّد أنّ «انسابت» تعني تدفّقت في ليونةٍ وسلاسة. والمعاني الأخرى تناقض السياق: «انقطعت» (b) يضادّ استمرار العزف، و«اشتدّت بقوّة» (c) لا يلائم صورة الرقّة، و«تبعثرت» (d) يناقض الانسجام الموصوف.', 6),
  ('1b8a1dfa-a272-5c77-b248-36edebc235e6', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«إنّ التفاعل بين الثقافات إثراءٌ للإنسانية لا تهديدٌ لها؛ فالأمم التي انفتحت على غيرها أخذت وأعطت، فازدهرت حضارتها، في حين أنّ الأمم المنغلقة ذبلت وتخلّفت. فلا نموّ بلا انفتاحٍ واعٍ.»

ما الأطروحة التي يدافع عنها الكاتب؟', '[{"id":"a","text":"التفاعلُ بين الثقافات يُثري الإنسانية ويُحقّق النموّ"},{"id":"b","text":"الأممُ المنغلقة هي وحدها التي تحافظ على هويّتها"},{"id":"c","text":"التفاعلُ بين الثقافات تهديدٌ خطير للهويّات"},{"id":"d","text":"الحضارةُ تزدهر بالأخذ من الآخرين دون عطاء"}]'::jsonb, 'a', 'الأطروحة هي الموقف الذي يدافع عنه الكاتب، وقد صرّح به في المطلع («إثراءٌ لا تهديد») وأكّده في الخاتمة («لا نموّ بلا انفتاح»). الخياران (b) و(c) يناقضان موقفه تمامًا، و(d) يحرّف قوله «أخذت وأعطت» إلى أخذٍ بلا عطاء.', 7),
  ('090cdaba-f4f0-53b7-93d9-f9a7c40a7698', '31dee382-2d7f-508c-8398-79fd2adb9a64', 'اقرأ النصّ التالي:

«تُعدّ التغيّرات المناخيّة من أخطر شواغل العالم المعاصر؛ إذ يرتفع معدّل حرارة الأرض بسبب انبعاثات الغازات، فتذوب الجليديّات ويرتفع منسوب البحار، ممّا يُهدّد المدن الساحليّة بالغرق.»

ما العلاقة المنطقيّة التي تربط أجزاء النصّ ويبرزها الرابطان «بسبب» و«ممّا»؟', '[{"id":"a","text":"سلسلةٌ من السبب والنتيجة (تعليلٌ يتبعه استنتاج)"},{"id":"b","text":"مقارنةٌ بين رأيين متعارضين"},{"id":"c","text":"تعدادٌ لأمثلةٍ متساوية لا رابط بينها"},{"id":"d","text":"استدراكٌ يُبطل ما سبقه"}]'::jsonb, 'a', '«بسبب» رابط تعليلٍ يُرجع ارتفاع الحرارة إلى الانبعاثات، و«ممّا» رابط نتيجةٍ يستخلص تهديد المدن؛ فالنصّ سلسلةٌ سببيّة متتابعة (سبب ← نتيجة ← نتيجة). وليس مقارنةً بين رأيين (b)، ولا تعدادًا مفكَّكًا (c)، ولا استدراكًا يُبطل ما قبله (d).', 8),
  ('023ec536-3799-5d6d-9a7a-43b37e79fde5', '206036c9-5046-5b14-b8e4-183e4a2a9d03', 'اقرأ النصّ التالي:

«للفنّ رسالةٌ نبيلة؛ فهو يُهذّب الذوق، ويُرهف الإحساس، ويُقرّب بين الشعوب على اختلاف ألسنتها. فاللوحةُ الجميلة والنغمةُ الصادقة تتجاوزان حدود اللغة لتُخاطبا القلب مباشرة.»

ما الفكرة العامة للنصّ؟', '[{"id":"a","text":"الفنُّ رسالةٌ نبيلة تُهذّب الإنسان وتُقرّب بين الشعوب"},{"id":"b","text":"اللوحةُ الجميلة تُخاطب القلب"},{"id":"c","text":"اختلافُ ألسنة الشعوب عائقٌ أمام التواصل"},{"id":"d","text":"النغمةُ الصادقة أجمل من اللوحة"}]'::jsonb, 'a', 'الفكرة العامة جملةٌ جامعة تشمل النصّ كلّه: نُبل رسالة الفنّ وأثره في الإنسان والشعوب، وهو ما يلخّصه (a). أمّا (b) فمثالٌ جزئيّ، و(c) يحرّف المعنى إذ يجعل الاختلاف عائقًا والنصّ يقول العكس، و(d) مقارنةٌ لم يعقدها النصّ.', 1),
  ('aab8251a-0c78-5e25-82ff-11bb4a0db203', '206036c9-5046-5b14-b8e4-183e4a2a9d03', 'اقرأ النصّ التالي:

«استيقظتُ باكرًا، فلبستُ ثيابي، ثمّ تناولتُ فطوري على عجل، وخرجتُ مسرعًا إلى المدرسة قبل أن يدقّ الجرس.»

ما نمط هذا النصّ؟', '[{"id":"a","text":"سرديّ: يحكي سلسلةً من الأحداث المتتابعة"},{"id":"b","text":"وصفيّ: يرسم صورةً لمكان"},{"id":"c","text":"حجاجيّ: يدافع عن أهمّية الاستيقاظ المبكّر"},{"id":"d","text":"تفسيريّ: يشرح فائدة الفطور"}]'::jsonb, 'a', 'النصّ يسرد أفعالًا متتالية يربطها الزمن (استيقظتُ، فلبستُ، ثمّ تناولتُ، خرجتُ) عبر روابط زمنيّة (الفاء، ثمّ)؛ وهذا هو النمط السرديّ. لا وصف لمكان (b)، ولا أطروحة يدافع عنها (c)، ولا شرح لظاهرة (d).', 2),
  ('5d1288f6-902f-5cf1-b091-4db39f5bd42e', '206036c9-5046-5b14-b8e4-183e4a2a9d03', 'اقرأ النصّ التالي:

«اجتهد التلميذُ طوال العام، لذلك نجح بتفوّق في الامتحان.»

ما العلاقة التي يُحدثها الرابط «لذلك» بين الجملتين؟', '[{"id":"a","text":"علاقة نتيجة (النجاح ثمرةُ الاجتهاد)"},{"id":"b","text":"علاقة معارضة بين الاجتهاد والنجاح"},{"id":"c","text":"علاقة تمثيل بمثالٍ على الاجتهاد"},{"id":"d","text":"علاقة زمنيّة محضة لا أكثر"}]'::jsonb, 'a', '«لذلك» رابط نتيجةٍ يستخلص النجاح من الاجتهاد السابق، فهو يربط سببًا بنتيجته. وليس معارضةً كـ«لكنْ» (b)، ولا تمثيلًا كـ«مثلًا» (c)؛ وهو وإن تضمّن تتابعًا زمنيًّا فإنّ وظيفته الأساس استخلاص النتيجة لا مجرّد الترتيب الزمنيّ (d).', 3),
  ('3b114e93-4c1d-5138-9780-6733aedb8683', '206036c9-5046-5b14-b8e4-183e4a2a9d03', 'اقرأ النصّ التالي:

«وقفت المرأةُ شامخةً في مقرّ عملها، تُدير شؤونه بحكمةٍ واقتدار، لا يُثنيها عن واجبها تعبٌ ولا تُضعف عزيمتها صعوبة.»

ما النبرة الغالبة في النصّ تجاه المرأة؟', '[{"id":"a","text":"الإعجاب والتقدير بقوّتها واقتدارها"},{"id":"b","text":"الشفقة على ما تعانيه من تعب"},{"id":"c","text":"السخرية من طموحها"},{"id":"d","text":"الحياد التامّ بلا أيّ موقف"}]'::jsonb, 'a', 'المفردات المشحونة بالمدح (شامخة، بحكمة واقتدار، لا يُثنيها تعب) تكشف نبرة الإعجاب والتقدير. أمّا الشفقة (b) فينقضها أنّ النصّ يبرز قوّتها لا ضعفها، والسخرية (c) لا أثر لها، والحياد (d) يناقض الألفاظ التقييميّة الواضحة.', 4),
  ('33ec9c7a-123e-578b-93c8-9b7eb1402064', '206036c9-5046-5b14-b8e4-183e4a2a9d03', 'اقرأ النصّ التالي:

«أطلّ القمرُ بدرًا منيرًا، فغمر السهلَ بضوءٍ فضّيّ ساطع، حتّى بدت الأشجارُ كأنّها أشباحٌ تتراءى من بعيد.»

ما معنى كلمة «غمر» في سياق النصّ؟', '[{"id":"a","text":"ملأ وغطّى بالكامل"},{"id":"b","text":"أغرق في الماء"},{"id":"c","text":"أخفى وحجب"},{"id":"d","text":"أحرق وأتلف"}]'::jsonb, 'a', 'السياق (القمر يغمر السهل بالضوء) يحدّد أنّ «غمر» تعني ملأ المكان بالنور وعمّه. ومع أنّ «غمر» قد تعني في معجمٍ ما الإغراق بالماء (b)، فإنّ السياق ينفيه؛ وكذلك «أخفى» (c) يناقض الإنارة، و«أحرق» (d) لا يلائم لطف ضوء القمر.', 5),
  ('0bd2fb57-2673-5892-8c95-f3e2bb1afea7', '206036c9-5046-5b14-b8e4-183e4a2a9d03', 'اقرأ النصّ التالي:

«نظر الأبُ إلى نتيجة ابنه، فلم يقل شيئًا، لكنّه ربّت على كتفه بلطف وابتسم ابتسامةً عريضة قبل أن يُعدّ له طبقه المفضّل.»

ماذا نستنتج عن شعور الأب ممّا لم يُصرَّح به؟', '[{"id":"a","text":"أنّه راضٍ وفخورٌ بابنه"},{"id":"b","text":"أنّه غاضبٌ من نتيجة ابنه"},{"id":"c","text":"أنّه لا يكترث لأمر ابنه"},{"id":"d","text":"أنّه حزينٌ على رسوب ابنه"}]'::jsonb, 'a', 'لم يُصرّح الكاتب بشعور الأب، لكنّ القرائن (التربيت بلطف، الابتسامة العريضة، إعداد الطبق المفضّل) توحي بالرضا والفخر؛ وهذه قراءةٌ بين السطور مدعومة بالنصّ. والغضب (b) والحزن (d) يناقضان الابتسامة، وعدم الاكتراث (c) يناقض اهتمامه الظاهر.', 6),
  ('3b387fd0-cd1f-5da3-8878-451c582822e9', 'b645b9d7-e9d1-563f-a836-0104be43edba', 'اقرأ التعليمة التالية:

«اكتب فقرةً تدافع فيها عن أهمّية العمل في حياة الإنسان.»

أيّ الجمل التالية أصلحُ لتكون أطروحةً (موقفًا) تنطلق منها فقرتك؟', '[{"id":"a","text":"العملُ ركيزةٌ أساسيّة لكرامة الإنسان وتقدّم المجتمع"},{"id":"b","text":"ذهبتُ صباحًا إلى عملي مشيًا على الأقدام"},{"id":"c","text":"ما أجملَ منظرَ العمّال في الحقول!"},{"id":"d","text":"كم ساعةً يعمل الموظّفُ في اليوم؟"}]'::jsonb, 'a', 'الأطروحة موقفٌ عامّ قابلٌ للدفاع عنه بالحجج، و(a) يحمل موقفًا واضحًا (العمل ركيزة الكرامة والتقدّم). أمّا (b) فسردُ واقعةٍ شخصيّة لا موقف فيها، و(c) جملةٌ وصفيّة انفعاليّة لا أطروحة، و(d) سؤالٌ لا يصلح موقفًا يُدافَع عنه.', 1),
  ('d3f18195-f6fc-5570-9bf8-b167f7df1649', 'b645b9d7-e9d1-563f-a836-0104be43edba', 'اقرأ الفقرة التالية وحدّد الجملة المفتاحية فيها:

«(1) فالقراءةُ تُوسّع المدارك وتُثري اللغة. (2) القراءةُ غذاءُ العقل ومفتاحُ المعرفة. (3) ومن قرأ كثيرًا اتّسعت ثقافته وتحسّن أسلوبه.»

ما الجملة المفتاحية التي تُعلن الفكرة الرئيسة؟', '[{"id":"a","text":"الجملة (2): القراءةُ غذاءُ العقل ومفتاحُ المعرفة"},{"id":"b","text":"الجملة (1): فالقراءةُ تُوسّع المدارك وتُثري اللغة"},{"id":"c","text":"الجملة (3): ومن قرأ كثيرًا اتّسعت ثقافته"},{"id":"d","text":"لا توجد جملة مفتاحية في الفقرة"}]'::jsonb, 'a', 'الجملة المفتاحية هي العبارة العامّة الجامعة التي تتفرّع عنها بقيّة الجمل، وهي الجملة (2) التي تُعرّف القراءة تعريفًا شاملًا. أمّا (1) فحجّةٌ تشرح فائدةً جزئيّة، و(3) مثالٌ/نتيجة تُجسّد الفكرة، وكلاهما يخدم الجملة المفتاحية لا يحلّ محلّها.', 2),
  ('db4aa8a1-6403-5afd-bf9d-babca5012363', 'b645b9d7-e9d1-563f-a836-0104be43edba', 'اقرأ ما يلي ثمّ ميّز الحجّة من المثال:

«التطوّعُ يُنمّي روحَ التضامن في المجتمع، فكثيرٌ من الشباب الذين يساعدون المسنّين تطوّعًا صاروا أكثر إحساسًا بالمسؤولية تجاه غيرهم.»

أيّ العبارتين تمثّل الحجّة (الفكرة العقليّة)؟', '[{"id":"a","text":"«التطوّعُ يُنمّي روحَ التضامن في المجتمع»"},{"id":"b","text":"«شبابٌ يساعدون المسنّين تطوّعًا»"},{"id":"c","text":"كلتا العبارتين مثالٌ لا حجّة"},{"id":"d","text":"كلتا العبارتين حجّةٌ لا مثال"}]'::jsonb, 'a', 'الحجّة فكرةٌ عقليّة عامّة تُبرّر الموقف، وهي هنا «التطوّع يُنمّي روح التضامن». أمّا «الشباب الذين يساعدون المسنّين» فمثالٌ جزئيّ محسوس يُجسّد الحجّة ويبرهن عليها. فالخياران (c) و(d) خطأ لأنّهما يخلطان بين النوعين المختلفين.', 3),
  ('65b3a3f6-31ff-5a7d-8efb-e6406e971cf7', 'b645b9d7-e9d1-563f-a836-0104be43edba', 'أردتَ الانتقال في إنتاجك من حجّةٍ أولى إلى حجّةٍ ثانية تُضاف إليها. أيّ رابطٍ هو الأنسب؟', '[{"id":"a","text":"علاوةً على ذلك"},{"id":"b","text":"غير أنّ"},{"id":"c","text":"لأنّ"},{"id":"d","text":"في الختام"}]'::jsonb, 'a', 'إضافةُ حجّةٍ جديدة إلى سابقتها تقتضي رابط إضافةٍ مثل «علاوةً على ذلك». أمّا «غير أنّ» (b) فللاستدراك والمعارضة لا الإضافة، و«لأنّ» (c) للتعليل، و«في الختام» (d) يُؤذن بالخاتمة لا بإضافة حجّة في صلب العرض.', 4),
  ('7b6c5dc8-ead3-553b-b4bb-52e69f6c7f5b', 'b645b9d7-e9d1-563f-a836-0104be43edba', 'رُتّبت جملُ فقرةٍ ترتيبًا مضطربًا:

(1) ومن ثمّ صارت الهواتفُ الذكيّة جزءًا لا يتجزّأ من حياتنا.
(2) غيّرت التكنولوجيا الحديثة نمطَ حياتنا تغييرًا جذريًّا.
(3) فهي تُمكّننا من التواصل والعمل والتعلّم في أيّ وقت.

ما الترتيب المنطقيّ السليم للفقرة؟', '[{"id":"a","text":"2 ← 3 ← 1"},{"id":"b","text":"1 ← 2 ← 3"},{"id":"c","text":"3 ← 1 ← 2"},{"id":"d","text":"2 ← 1 ← 3"}]'::jsonb, 'a', 'الفقرة المتماسكة تبدأ بالجملة المفتاحية العامّة (2: التكنولوجيا غيّرت حياتنا)، ثمّ الحجّة/التفصيل (3: فهي تُمكّننا…)، ثمّ النتيجة المستخلصة (1: ومن ثمّ صارت الهواتف…). والروابط ترشدنا: الفاء في (3) تستأنف التعليل، و«ومن ثمّ» في (1) يستلزم سابقًا يُستنتج منه، فلا يصحّ أن يتصدّرا.', 5),
  ('5afd770e-d6f6-572e-bffd-130d9d188500', 'b645b9d7-e9d1-563f-a836-0104be43edba', 'اقرأ التعليمة:

«اكتب خاتمةً لموضوعٍ عالجتَ فيه دور الفنون في تقريب الثقافات.»

أيّ الجمل التالية أنسبُ خاتمةً متماسكة؟', '[{"id":"a","text":"وخلاصةُ القول إنّ الفنون جسرٌ يصل بين الشعوب، فحريٌّ بنا أن نرعاها ونشجّعها"},{"id":"b","text":"وأوّلُ ما ينبغي قوله إنّ للفنون أنواعًا كثيرة سنعدّدها فيما يلي"},{"id":"c","text":"أمّا الرياضةُ فلها أيضًا دورٌ كبير في حياة الشعوب"},{"id":"d","text":"في الصباح ذهبتُ إلى المتحف ورأيت لوحاتٍ جميلة"}]'::jsonb, 'a', 'الخاتمة المتماسكة تُلخّص الموقف وتفتح أفقًا، وهو ما يفعله (a) برابط الخلاصة («وخلاصةُ القول») واستنتاجٍ منسجم مع الموضوع. أمّا (b) فمطلعٌ يُمهّد لا خاتمة، و(c) يُقحم موضوعًا جديدًا (الرياضة) فيكسر الانسجام، و(d) سردٌ جزئيّ لا صلة له بختم الموضوع الحجاجيّ.', 6),
  ('65eb526c-31d4-5dda-9f8d-eeb7f4d9c997', 'e3ab459c-7cc9-579f-81a8-def4cf3d7483', 'اقرأ النصّ التالي:

«ليست الحرّيةُ فوضى تُطلق العنانَ للأهواء، بل هي مسؤوليّةٌ تقترن بالوعي؛ فحرّيةُ المرء تنتهي حيث تبدأ حرّيةُ غيره. ومن ظنّ الحرّية انفلاتًا فقد أساء فهمها.»

ما الأطروحة التي يدافع عنها الكاتب؟', '[{"id":"a","text":"الحرّيةُ مسؤوليّةٌ واعية محدودةٌ بحرّية الآخرين، لا فوضى وانفلات"},{"id":"b","text":"الحرّيةُ فوضى تُطلق العنان للأهواء"},{"id":"c","text":"ينبغي تقييدُ الحرّيات إلى أبعد حدّ"},{"id":"d","text":"لا قيمةَ للحرّية في حياة الإنسان"}]'::jsonb, 'a', 'يبني الكاتب أطروحته على النفي والإثبات: «ليست فوضى… بل مسؤوليّة»، ويحدّها بحرّية الغير. فـ(a) يطابق موقفه. أمّا (b) فهو الرأي الذي يدحضه الكاتب صراحةً، و(c) مبالغةٌ لم يقل بها (هو يضبط لا يُقيّد إلى أقصى حدّ)، و(d) يناقض تثمينه للحرّية.', 1),
  ('f78570a5-1972-56ca-be72-c46c634ed1db', 'e3ab459c-7cc9-579f-81a8-def4cf3d7483', 'اقرأ النصّ التالي:

«تقدّمت العلومُ تقدّمًا مذهلًا، فأطالت الأعمارَ وقهرت كثيرًا من الأمراض؛ غير أنّ هذا التقدّم نفسه أنتج أسلحةً قادرةً على إفناء البشريّة. فالعلمُ سلاحٌ ذو حدّين.»

ما النبرة التي تُهيمن على موقف الكاتب من العلم؟', '[{"id":"a","text":"نبرةٌ متوازنة تجمع الإعجاب والتحذير معًا"},{"id":"b","text":"إعجابٌ مطلقٌ بلا أيّ تحفّظ"},{"id":"c","text":"رفضٌ تامّ للعلم وإدانةٌ له"},{"id":"d","text":"سخريةٌ من إنجازات العلم"}]'::jsonb, 'a', 'النصّ يُثني على منجزات العلم (إطالة الأعمار، قهر الأمراض) ثمّ يُحذّر من مخاطره (أسلحة الإفناء) عبر الاستدراك «غير أنّ»، ويختم بحكمٍ متوازن «سلاح ذو حدّين»؛ فالنبرة مزيجٌ من الإعجاب والتحذير (a). فلا هو إعجابٌ مطلق (b)، ولا رفضٌ تامّ (c)، ولا سخرية (d).', 2),
  ('83fac81d-cbb1-5d89-9ea8-566907ccab4c', 'e3ab459c-7cc9-579f-81a8-def4cf3d7483', 'اقرأ النصّ التالي:

«ما زال بعضُهم يحصر دورَ المرأة في البيت، متجاهلًا أنّها أثبتت جدارتها في كلّ ميدان. أوَليست الطبيبةُ والمهندسةُ والقاضيةُ دليلًا ساطعًا على ذلك؟»

ما دلالة أسلوب الاستفهام في «أوَليست… دليلًا ساطعًا؟»', '[{"id":"a","text":"استفهامٌ إنكاريّ يُثبت قدرة المرأة ويُفنّد رأي المخالف"},{"id":"b","text":"استفهامٌ حقيقيّ يطلب الكاتبُ به معلومةً يجهلها"},{"id":"c","text":"استفهامٌ يُعبّر عن شكّ الكاتب في قدرة المرأة"},{"id":"d","text":"استفهامٌ للتمنّي والرجاء"}]'::jsonb, 'a', 'الاستفهام هنا إنكاريٌّ خرج عن معناه الحقيقيّ إلى التقرير والإثبات: الكاتب لا يسأل سؤالًا يجهل جوابه (b) بل يُؤكّد جدارة المرأة ويردّ على من يحصر دورها. ولا يدلّ على شكّه (c) فهو مقتنع بموقفه، ولا على تمنٍّ (d). والقرينة: ذكرُ نماذج «دليلًا ساطعًا».', 3),
  ('9ef8f74e-1819-556e-9c79-0b367114ffc2', 'e3ab459c-7cc9-579f-81a8-def4cf3d7483', 'اقرأ النصّ التالي:

«انتشر الفقرُ في أحياءٍ كثيرة، بيدَ أنّ الجمعيّات الخيريّة لم تَدَّخر وسعًا في التخفيف منه.»

ما العلاقة المنطقيّة التي يُحدثها الرابط «بيدَ أنّ»؟', '[{"id":"a","text":"استدراكٌ يُعارض ما قد يُتوقّع من الجملة الأولى"},{"id":"b","text":"تعليلٌ يُبيّن سبب انتشار الفقر"},{"id":"c","text":"نتيجةٌ مترتّبة على انتشار الفقر"},{"id":"d","text":"إضافةٌ لمعلومةٍ مماثلة"}]'::jsonb, 'a', '«بيدَ أنّ» من أدوات الاستدراك، مرادفةٌ لـ«لكنْ» و«غير أنّ»؛ فهي تُعارض ما قد يُفهم من انتشار الفقر (وهو الاستسلام له) بإبراز جهد الجمعيّات. وليست تعليلًا (b) ولا نتيجة (c)، ولا إضافةً لمعلومةٍ في الاتّجاه نفسه (d) بل تقابلٌ بين واقعٍ سلبيّ وجهدٍ إيجابيّ.', 4),
  ('70938c3e-b5b3-5f96-bbf5-c603613c8e9d', 'e3ab459c-7cc9-579f-81a8-def4cf3d7483', 'اقرأ النصّ التالي:

«وقف الشاعرُ يُنشد قصيدته، فهزّت كلماتُه النفوسَ، وأرسلت في القلوب قشعريرةً، حتّى ذرفت العيونُ دمعًا لم يستطع أحدٌ كتمانه.»

ماذا نستنتج عن أثر القصيدة في الجمهور؟', '[{"id":"a","text":"أنّ القصيدة بلغت من التأثير حدًّا أبكى الحاضرين تأثّرًا"},{"id":"b","text":"أنّ الجمهور مَلَّ القصيدة وانصرف عنها"},{"id":"c","text":"أنّ القصيدة كانت باردةً لم تُحرّك مشاعر أحد"},{"id":"d","text":"أنّ الشاعر أخفق في إلقاء قصيدته"}]'::jsonb, 'a', 'القرائن (هزّت النفوس، قشعريرة في القلوب، دمعٌ لم يُكتم) تستلزم بالاستنتاج أنّ القصيدة بلغت تأثيرًا عميقًا أبكى الحاضرين. فالخياران (b) و(c) يناقضان قوّة الأثر الموصوف، و(d) يناقض نجاح الإلقاء الذي تشهد به ردّةُ فعل الجمهور.', 5),
  ('54ab3126-2fb8-5e1d-9ce8-16f5d0eae663', 'e3ab459c-7cc9-579f-81a8-def4cf3d7483', 'اقرأ النصّ التالي:

«في زمنٍ تتسارع فيه التحوّلات، لم يَعُد الانكفاءُ على الذات خيارًا ممكنًا؛ فالتفاعلُ مع ثقافات العالم ضرورةٌ يفرضها العصر.»

ما الفكرة العامة للنصّ؟', '[{"id":"a","text":"التفاعلُ مع الثقافات الأخرى ضرورةٌ يفرضها عصرُ التحوّلات المتسارعة"},{"id":"b","text":"التحوّلاتُ في العالم تتسارع يومًا بعد يوم"},{"id":"c","text":"الانكفاءُ على الذات خيارٌ آمنٌ وممكن"},{"id":"d","text":"ثقافاتُ العالم متشابهةٌ لا فرق بينها"}]'::jsonb, 'a', 'الفكرة العامة تجمع موضوع النصّ وموقف الكاتب: ضرورة التفاعل الثقافيّ في زمن التحوّلات، وهو ما يصوغه (a). أمّا (b) فمعطًى تمهيديّ جزئيّ لا الفكرة المحورية، و(c) يناقض النصّ صراحةً («لم يَعُد… خيارًا ممكنًا»)، و(d) ادّعاءٌ لم يَرِد في النصّ أصلًا.', 6),
  ('3c07ad41-b34b-5494-b348-ce375c50306b', '8d7b07eb-7025-5d92-a33d-73107fbb46d4', 'اقرأ النصّ التالي:

«قد يظنّ ظانٌّ أنّ التكنولوجيا قرّبت بين الناس، والحقُّ أنّها قرّبت البعيدَ وأبعدت القريب؛ فكم من أسرةٍ يجلس أفرادها في غرفةٍ واحدة، كلٌّ غارقٌ في شاشته، لا يبادل جليسَه كلمة.»

ما المفارقة (التناقض الظاهريّ) التي يبنيها الكاتب موقفَه عليها؟', '[{"id":"a","text":"التكنولوجيا تَصِل البعيدَ مكانيًّا وتُباعد القريبَ وجدانيًّا في آنٍ واحد"},{"id":"b","text":"التكنولوجيا قرّبت جميعَ الناس بعضهم من بعض دون استثناء"},{"id":"c","text":"أفرادُ الأسرة الواحدة لا يملكون هواتف ذكيّة"},{"id":"d","text":"التكنولوجيا لا أثر لها البتّة في العلاقات الإنسانية"}]'::jsonb, 'a', 'المفارقة جوهرُ موقف الكاتب: «قرّبت البعيدَ وأبعدت القريب»، أي وصلٌ مكانيّ مع قطيعةٍ وجدانيّة، يُجسّدها مثالُ الأسرة الصامتة. أمّا (b) فهو الظنّ الذي يدحضه الكاتب («قد يظنّ ظانٌّ… والحقُّ…»)، و(c) يناقض «غارقٌ في شاشته»، و(d) يناقض إقراره بأثرها.', 1),
  ('6c604a10-8ef5-5c77-a18e-536e6867a03f', '8d7b07eb-7025-5d92-a33d-73107fbb46d4', 'اقرأ النصّ التالي:

«يا له من زمنٍ غريب! نُكثر فيه من الأصدقاء على الشاشات، ونُقلّ من الأصدقاء في الواقع؛ نملك ألفَ وسيلةٍ للتواصل، ونشكو مع ذلك من وحشةٍ لم تعرفها الأجيالُ السابقة.»

ما النبرة التي يُوظّفها الكاتب، وما القرينة الدالّة عليها؟', '[{"id":"a","text":"نبرةُ تحسّرٍ ونقدٍ ساخرٍ مرّ، يدلّ عليها التعجّب والمقابلة بين الكثرة الظاهرة والوحشة الباطنة"},{"id":"b","text":"نبرةُ فرحٍ واحتفاءٍ بكثرة وسائل التواصل، يدلّ عليها أسلوب التعجّب"},{"id":"c","text":"نبرةُ حيادٍ علميّ موضوعيّ خالٍ من المشاعر"},{"id":"d","text":"نبرةُ دعوةٍ مباشرة إلى ترك وسائل التواصل نهائيًّا"}]'::jsonb, 'a', 'أسلوبُ التعجّب «يا له من زمنٍ غريب!» والمقابلاتُ المتتالية (نُكثر/نُقلّ، ألفُ وسيلة/وحشة) تكشف تحسّرًا ونقدًا ساخرًا مرًّا، لا فرحًا (b) الذي تنقضه «الوحشة» و«غريب». وليست النبرة حياديّة (c) لشحنتها العاطفية، ولا دعوةً صريحة للترك (d) فالنصّ نقدٌ تأمّليّ لا أمرٌ مباشر.', 2),
  ('24c447b0-8b0f-5774-94c3-90ca63b738d4', '8d7b07eb-7025-5d92-a33d-73107fbb46d4', 'اقرأ النصّ التالي:

«إنّ مَن يَعُدّ الفنونَ ترفًا زائدًا واهمٌ؛ ذلك أنّ الأمم تُقاس بآثارها الفنّية كما تُقاس بإنجازاتها العلميّة، فحضارةٌ بلا فنٍّ جسدٌ بلا روح.»

ما وظيفة الرابط «ذلك أنّ» في بناء حجاج النصّ؟', '[{"id":"a","text":"يُقدّم تعليلًا يُبرّر الحكم السابق (تخطئة من يعدّ الفنّ ترفًا)"},{"id":"b","text":"يُقدّم استدراكًا يُعارض الحكم السابق"},{"id":"c","text":"يُقدّم مثالًا جزئيًّا لا حجّةً عقليّة"},{"id":"d","text":"يُقدّم نتيجةً نهائيّة تُختم بها الفقرة"}]'::jsonb, 'a', '«ذلك أنّ» رابط تعليلٍ يُسوّغ الحكم المتقدّم (أنّ مَن يعدّ الفنّ ترفًا واهم) بحجّةٍ عقليّة: قياسُ الأمم بآثارها الفنّية. فهو ليس استدراكًا معارِضًا (b)، وما بعده حجّةٌ عقليّة عامّة لا مجرّد مثال (c)، وموقعه في صلب التعليل لا في الختام، فالتشبيه «جسدٌ بلا روح» هو الذي يُجمل النتيجة لا «ذلك أنّ» (d).', 3),
  ('f4977c68-caef-59ac-9275-0db26f9c3edc', '8d7b07eb-7025-5d92-a33d-73107fbb46d4', 'رُتّبت جملُ فقرةٍ حجاجيّة ترتيبًا مضطربًا:

(1) فلولا العملُ ما قام عمرانٌ ولا تقدّمت أمّة.
(2) العملُ أساسُ نهضة الأمم وسبيلُها إلى الرقيّ.
(3) ولنا في الدول المتقدّمة خيرُ دليل، إذ بلغت ما بلغته بسواعد أبنائها المكدودة.
(4) ومن ثمّ كان واجبًا على كلّ فردٍ أن يتقن عمله ويُخلص فيه.

ما الترتيب المنطقيّ الأسلم لفقرةٍ متماسكة؟', '[{"id":"a","text":"2 ← 1 ← 3 ← 4"},{"id":"b","text":"1 ← 2 ← 3 ← 4"},{"id":"c","text":"3 ← 2 ← 1 ← 4"},{"id":"d","text":"2 ← 4 ← 1 ← 3"}]'::jsonb, 'a', 'تبدأ الفقرة بالجملة المفتاحية العامّة (2: العمل أساس النهضة)، ثمّ الحجّة العقليّة المعلَّلة (1: فلولا العمل ما قام عمران)، ثمّ المثال الواقعيّ الداعم (3: الدول المتقدّمة دليل)، ثمّ النتيجة المستخلصة (4: ومن ثمّ كان واجبًا…). والروابط ترشد: الفاء التعليليّة في (1)، وضمير «ولنا… دليل» في (3) يستلزم سابقًا، و«ومن ثمّ» في (4) لا يصحّ إلّا خاتمةً.', 4),
  ('c9f10d4a-58fa-59b5-9ab0-53476edadd0c', '8d7b07eb-7025-5d92-a33d-73107fbb46d4', 'اقرأ النصّ التالي:

«ابتسم العجوزُ ابتسامةً باهتة وهو ينظر إلى الكرسيّ الفارغ المقابل، ثمّ صبّ فنجانَيْ قهوةٍ كعادته، وجلس يحدّق في الفراغ طويلًا قبل أن يُبعد الفنجان الثاني جانبًا.»

ما الذي يُلمّح إليه النصّ دون تصريح؟', '[{"id":"a","text":"أنّ العجوز يعاني وحدةً وفقدانَ رفيقٍ اعتاد مشاركته القهوة"},{"id":"b","text":"أنّ العجوز ينتظر ضيفًا سيصل بعد قليل"},{"id":"c","text":"أنّ العجوز سعيدٌ بصحبةٍ كثيرة حوله"},{"id":"d","text":"أنّ العجوز لا يحبّ شرب القهوة"}]'::jsonb, 'a', 'القرائن (الكرسيّ الفارغ، صبّ فنجانَيْن «كعادته» ثمّ إبعاد الثاني، التحديق في الفراغ، الابتسامة الباهتة) تتضافر لتُلمّح إلى فقدِ رفيقٍ اعتاد مشاركته القهوة وما خلّفه من وحدة. والانتظار (b) يناقض إبعاده للفنجان، والسعادة بصحبة (c) تناقض «الفراغ» و«الباهتة»، و(d) ينقضه إعداده للقهوة كعادته.', 5),
  ('5f151584-537f-598b-acc3-18094cd51066', '8d7b07eb-7025-5d92-a33d-73107fbb46d4', 'اقرأ النصّ التالي:

«غمرتْه السعادةُ حين عاد إلى مسقط رأسه، فقد وجد القريةَ كما تركها: عيونُها لا تزال نديّة، وأهلُها على عهدهم كرماء.»

ما معنى «عيونها» في هذا السياق؟', '[{"id":"a","text":"ينابيعُها وأنهارها (مصادر الماء)"},{"id":"b","text":"أعينُ أهلها الباصرة"},{"id":"c","text":"جواسيسُها ومخبروها"},{"id":"d","text":"أعيانُها ووجهاؤها"}]'::jsonb, 'a', 'للكلمة «عين» معانٍ متعدّدة، والسياق هو الحاسم: وصفُ العيون بأنّها «نديّة» وذكرها في سياق القرية ومائها يحدّد أنّ المراد الينابيع ومصادر الماء. فالباصرة (b) لا تُوصف بـ«نديّة» بهذا المعنى، والجواسيس (c) لا يلائمون سياق الحنين، والأعيان/الوجهاء (d) عُطفوا عليهم «أهلها كرماء» فلا يصحّ تكرارهم.', 6),
  ('ad44e9d8-fe1d-59d3-b518-2ea51b2a627c', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"In many Tunisian families, dinner is more than just a meal. It is the moment when everyone sits together, shares the news of the day and laughs about small things. Even when life is busy, parents try hard to keep this evening habit alive."

What is the main idea of this passage?', '[{"id":"a","text":"Tunisian families always eat the same food for dinner."},{"id":"b","text":"Family dinner is an important moment for sharing and staying close."},{"id":"c","text":"Parents are too busy to spend time with their children."},{"id":"d","text":"Children prefer eating dinner alone in their rooms."}]'::jsonb, 'b', 'The whole passage shows that dinner is valued because the family sits together, shares news and laughs — and parents protect this habit. That is the main idea. (a) Food is never mentioned. (c) The opposite is true: even when busy, parents keep the habit. (d) Nothing suggests children eat alone.', 1),
  ('9b84ac2b-88c1-5e10-9ee7-a729713042ff', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Our school library opens at eight in the morning and closes at five in the afternoon, from Monday to Friday. On Saturday, it is open only in the morning, and it stays closed on Sunday."

On which day is the library open in the morning only?', '[{"id":"a","text":"Monday"},{"id":"b","text":"Sunday"},{"id":"c","text":"Saturday"},{"id":"d","text":"Friday"}]'::jsonb, 'c', 'Scan for each day. The text says it opens ''only in the morning'' on Saturday. Monday and Friday follow the full 8 a.m.–5 p.m. timetable, and Sunday it is closed. So the answer is Saturday.', 2),
  ('ed2c07e1-18f2-5a28-bdef-32269895079f', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Plastic bags are cheap and easy to carry. However, they pollute our beaches and harm sea animals for many years."

What is the function of the connector "However" in this passage?', '[{"id":"a","text":"It adds another advantage of plastic bags."},{"id":"b","text":"It introduces a contrast with the first sentence."},{"id":"c","text":"It gives the cause of the pollution."},{"id":"d","text":"It shows the result of using plastic bags carefully."}]'::jsonb, 'b', '''However'' is a contrast connector: it opposes the advantage (cheap, easy) to the serious drawback (pollution, harm to animals). It does not add an advantage (a), give a cause — that would be ''because'' (c) — or show a positive result (d).', 3),
  ('bdf11453-1d14-5f95-abf0-44c6b17b044b', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"The festival offered something for everyone. There were films in the open air, live music until midnight, and games for the youngest visitors."

Which detail is mentioned in the passage?', '[{"id":"a","text":"a cooking competition"},{"id":"b","text":"live music until midnight"},{"id":"c","text":"a football match"},{"id":"d","text":"an art exhibition"}]'::jsonb, 'b', 'Scanning the text, the activities listed are open-air films, live music until midnight, and games for children. Only ''live music until midnight'' is actually stated. A cooking competition (a), football match (c) and art exhibition (d) do not appear.', 4),
  ('ba4e859e-bd3f-50f4-86dd-36c0f4dc5c28', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"When Lina opened her exam results, her hands were shaking. She read the page twice, then ran to the kitchen shouting and hugged her mother before she could even speak."

What can we infer about Lina''s results?', '[{"id":"a","text":"She failed and was very disappointed."},{"id":"b","text":"She did very well and was extremely happy."},{"id":"c","text":"She did not understand her results."},{"id":"d","text":"She was too tired to care about the results."}]'::jsonb, 'b', 'The clues — shaking hands, reading twice, running and shouting with joy, hugging her mother — all point to great excitement, so we infer she did very well. The text never states the grade, but the behaviour proves happiness, not disappointment (a), confusion (c) or tiredness (d).', 5),
  ('aa5b50d9-2c3d-57bc-80ef-83cf5473969c', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Volunteers planted hundreds of young trees along the dry riverbank last spring. Today, they are tall and green, and they give shade to the families who walk there."

In the second sentence, what does the word "they" refer to?', '[{"id":"a","text":"the volunteers"},{"id":"b","text":"the families"},{"id":"c","text":"the young trees"},{"id":"d","text":"the riverbanks"}]'::jsonb, 'c', '"They are tall and green" and "give shade" can only describe the trees that were planted. ''They'' refers back to the nearest matching plural noun that fits the meaning — the young trees. It is not the volunteers (people are not ''green''), the families, or the riverbank (singular).', 6),
  ('70814d98-d38e-52c0-8bd8-07f160d3afbb', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"The new clinic is very convenient. It is close to the bus station, it opens early, and patients rarely wait more than a few minutes to see a doctor."

What does the word "convenient" most probably mean here?', '[{"id":"a","text":"expensive and modern"},{"id":"b","text":"easy and practical to use"},{"id":"c","text":"far and difficult to reach"},{"id":"d","text":"crowded and noisy"}]'::jsonb, 'b', 'The reasons given after the word — close to the bus station, opens early, short waiting time — describe something easy and practical to use, which is the meaning of ''convenient''. The context contradicts ''far and difficult'' (c), and says nothing about price (a) or noise (d).', 7),
  ('5acdc554-2621-5a4d-80f2-35310f2af5ef', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Saying ''please'' and ''thank you'' costs nothing, yet it changes everything. A polite word can turn a stranger into a friend and a tense moment into a calm one."

What is the writer''s main message?', '[{"id":"a","text":"Politeness is expensive and difficult."},{"id":"b","text":"Strangers are usually dangerous."},{"id":"c","text":"Small polite words have a big positive effect."},{"id":"d","text":"People should avoid speaking to strangers."}]'::jsonb, 'c', 'The passage stresses that polite words cost nothing yet ''change everything'' — they create friendship and calm. The main message is that small polite words have a big positive effect. (a) contradicts ''costs nothing''. (b) and (d) are not in the text.', 8),
  ('5b47820d-916f-58b9-a0d0-90c7eaff3938', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"My grandmother lives with us. Every afternoon she tells us old stories about her village, and we listen carefully. Thanks to her, we know a lot about how families lived long ago."

What is the main idea of this passage?', '[{"id":"a","text":"The grandmother is too old to live alone."},{"id":"b","text":"The grandmother shares stories that teach the family about the past."},{"id":"c","text":"The children do not like listening to old stories."},{"id":"d","text":"The village has changed a lot over the years."}]'::jsonb, 'b', 'The passage centres on the grandmother telling stories and the family learning about the past from her. (a) Living alone is never mentioned. (c) The opposite is true — they listen carefully. (d) The village''s changes are not the topic.', 1),
  ('d3ac0c0c-72d4-5c36-9af4-3e55e2bf61e3', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"The science club meets twice a week. On Tuesday the members do experiments, and on Thursday they prepare projects for the school fair."

What do the members do on Thursday?', '[{"id":"a","text":"They do experiments."},{"id":"b","text":"They prepare projects for the school fair."},{"id":"c","text":"They clean the laboratory."},{"id":"d","text":"They take an exam."}]'::jsonb, 'b', 'Scan for ''Thursday''. The text says: on Thursday ''they prepare projects for the school fair''. The experiments happen on Tuesday (a), and cleaning (c) and an exam (d) are not mentioned.', 2),
  ('18944ced-9590-5b65-95c2-9b4e16b20d32', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"Doctors say that walking is excellent for your health. It is free, and you can do it almost anywhere."

In the second sentence, what does the word "it" refer to?', '[{"id":"a","text":"the doctor"},{"id":"b","text":"your health"},{"id":"c","text":"walking"},{"id":"d","text":"the second sentence"}]'::jsonb, 'c', '"It is free" and "you can do it anywhere" describe the activity being praised — walking. ''It'' refers back to the nearest matching idea, which is walking. It is not the doctor (a person) or ''your health'', which is not something free that you ''do''.', 3),
  ('ca816cf8-5b8a-5807-9faf-b8115134aef4', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"The room was spotless. Not a single speck of dust could be seen, and everything was in its place."

What does the word "spotless" most probably mean?', '[{"id":"a","text":"very dirty"},{"id":"b","text":"very clean"},{"id":"c","text":"very large"},{"id":"d","text":"very dark"}]'::jsonb, 'b', 'The next sentence explains the word: no dust and everything in its place — that describes a very clean room, so ''spotless'' means very clean. The context rules out ''dirty'' (a, the opposite), and says nothing about size (c) or light (d).', 4),
  ('f5b7882d-e334-5f41-bc99-df08d8742957', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"Karim turned off the television, put away his books and yawned. He set his alarm and switched off the light."

What can we infer that Karim is about to do?', '[{"id":"a","text":"go to school"},{"id":"b","text":"start cooking dinner"},{"id":"c","text":"go to sleep"},{"id":"d","text":"watch a film"}]'::jsonb, 'c', 'Yawning, setting the alarm and switching off the light are all clues that Karim is going to bed. The text does not say ''sleep'' directly, but the actions prove it. He has just turned off the TV (not watching a film, d), and there is no sign of school (a) or cooking (b).', 5),
  ('d4ecd2b9-807e-528e-8f74-5f0fa9e018bd', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"The bus was late, so we missed the beginning of the film."

What is the function of the connector "so" in this sentence?', '[{"id":"a","text":"It introduces a contrast."},{"id":"b","text":"It introduces the result of the first part."},{"id":"c","text":"It introduces an example."},{"id":"d","text":"It introduces a purpose."}]'::jsonb, 'b', '''So'' links a cause (the bus was late) to its result (we missed the start of the film). It marks result/consequence. A contrast would use ''but'' (a), an example ''such as'' (c), and a purpose ''in order to'' (d).', 6),
  ('42e3e7ea-b563-569c-90f5-b9b015b4ec33', '1b387c5d-e284-59e9-a936-4be304908ee3', 'You are writing a paragraph about the benefits of sport for students. Which sentence is the best topic sentence to begin it?', '[{"id":"a","text":"Last Saturday I scored two goals in the match."},{"id":"b","text":"Practising sport brings students many important benefits."},{"id":"c","text":"My favourite football player wears the number ten."},{"id":"d","text":"The school stadium is next to the main gate."}]'::jsonb, 'b', 'A topic sentence states the paragraph''s general main idea, and (b) clearly announces ''the benefits of sport for students''. The others are narrow details — one match (a), a player (c), a place (d) — too small to introduce the whole paragraph.', 1),
  ('58334796-1688-507d-85b4-8d0f606d7eda', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Read this short paragraph about libraries:

"Public libraries are very useful. They lend thousands of books for free. They also offer a quiet place to study. My uncle prefers tea to coffee. Many students go there before exams."

Which sentence is irrelevant and should be removed?', '[{"id":"a","text":"\"They lend thousands of books for free.\""},{"id":"b","text":"\"They also offer a quiet place to study.\""},{"id":"c","text":"\"My uncle prefers tea to coffee.\""},{"id":"d","text":"\"Many students go there before exams.\""}]'::jsonb, 'c', 'The paragraph is about why libraries are useful. Sentences a, b and d all support that idea. ''My uncle prefers tea to coffee'' has nothing to do with libraries, so it is the irrelevant sentence and must be removed.', 2),
  ('9b59a2c4-f6dd-5ebf-846e-46ebc1fccfe2', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Put these sentences in the correct order to form a well-organised paragraph:

1. "Finally, eating fruit and vegetables keeps the body strong."
2. "A healthy lifestyle depends on a few simple habits."
3. "First, sleeping enough hours helps the brain rest."

What is the best order?', '[{"id":"a","text":"1 – 2 – 3"},{"id":"b","text":"2 – 3 – 1"},{"id":"c","text":"3 – 1 – 2"},{"id":"d","text":"2 – 1 – 3"}]'::jsonb, 'b', 'Sentence 2 is the general topic sentence, so it comes first. Then the sequence words guide the order: ''First'' (3) before ''Finally'' (1). The logical order is 2 – 3 – 1.', 3),
  ('7f995235-7d0c-5578-977f-0367685bca7f', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Choose the best linking word to complete the sentence:

"The medicine was bitter, ___ the child swallowed it without complaining."', '[{"id":"a","text":"because"},{"id":"b","text":"so"},{"id":"c","text":"but"},{"id":"d","text":"for example"}]'::jsonb, 'c', 'We expect a bitter medicine to be refused, yet the child took it easily — that surprise is a contrast, which needs ''but''. ''Because'' gives a cause, ''so'' a result, and ''for example'' an example; none fits the opposition here.', 4),
  ('6e40940f-e9de-597e-85f5-7a3a40f49971', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Read the beginning of a paragraph:

"Smoking is dangerous for teenagers. It damages the lungs and reduces energy."

Which sentence is the most coherent continuation?', '[{"id":"a","text":"In addition, it wastes money that could be spent on useful things."},{"id":"b","text":"The weather in spring is usually pleasant."},{"id":"c","text":"My favourite colour has always been blue."},{"id":"d","text":"Cars need petrol to move from place to place."}]'::jsonb, 'a', 'The paragraph lists the dangers of smoking, so a coherent continuation adds another disadvantage and links it with ''In addition'' (a). The other options jump to unrelated topics — weather (b), a colour (c), cars (d) — and break the paragraph''s unity.', 5),
  ('79d5ca59-ee45-54f7-b1a6-f94d0dcb221a', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Choose the best linking word to complete the sentence:

"We should protect the environment ___ future generations can live healthy lives."', '[{"id":"a","text":"so that"},{"id":"b","text":"however"},{"id":"c","text":"for instance"},{"id":"d","text":"although"}]'::jsonb, 'a', 'The second part states the goal or aim of protecting the environment, which needs a purpose connector: ''so that''. ''However'' shows contrast, ''for instance'' gives an example, and ''although'' introduces a concession — none expresses purpose.', 6),
  ('82494c50-b2fd-5b15-ab67-5e6fd86d4058', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this paragraph about good manners:

"Good manners cost nothing but bring great rewards. A polite greeting makes people feel respected. Holding the door for others shows kindness. The new shopping mall has a huge car park. In short, small courteous acts build a friendlier society."

Which sentence breaks the unity of the paragraph and should be removed?', '[{"id":"a","text":"\"A polite greeting makes people feel respected.\""},{"id":"b","text":"\"Holding the door for others shows kindness.\""},{"id":"c","text":"\"The new shopping mall has a huge car park.\""},{"id":"d","text":"\"In short, small courteous acts build a friendlier society.\""}]'::jsonb, 'c', 'The paragraph develops one idea — good manners and their value — supported by examples (greeting, holding the door) and a closing sentence (''In short…''). ''The new shopping mall has a huge car park'' is off-topic and breaks the unity, so it must be removed.', 1),
  ('c92e82a7-ebc6-5634-ba6d-67c111412e90', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"Some people think a city is judged by its tall towers and wide roads. In truth, a city is judged by how it treats its weakest citizens — its children, its elderly and its sick."

What is the writer''s main point?', '[{"id":"a","text":"Tall towers make a city beautiful and successful."},{"id":"b","text":"The real value of a city is how well it cares for its most vulnerable people."},{"id":"c","text":"Cities should build wider roads to reduce traffic."},{"id":"d","text":"Children, the elderly and the sick live in every city."}]'::jsonb, 'b', 'The writer rejects the common view (towers, roads) with ''In truth'' and states the real measure: how a city treats its weakest citizens. That is the main point. (a) is the idea the writer corrects. (c) is not discussed. (d) is a literal detail, not the message.', 2),
  ('76b801e8-7fda-5047-80f1-b82276886214', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"Nadia had been saving for months. When she finally counted her coins on the table, she sighed, shook her head, and quietly put the bicycle catalogue back on the shelf."

What can we infer from this passage?', '[{"id":"a","text":"Nadia had enough money to buy the bicycle."},{"id":"b","text":"Nadia did not have enough money for the bicycle she wanted."},{"id":"c","text":"Nadia had decided she no longer liked bicycles."},{"id":"d","text":"Nadia had already bought the bicycle."}]'::jsonb, 'b', 'Sighing, shaking her head and putting the catalogue away after counting her coins are clues of disappointment — she still cannot afford the bicycle. The text never says it directly, but the clues prove it. (a) and (d) contradict her sad reaction; (c) is wrong, as she was saving precisely to buy one.', 3),
  ('59185207-289a-5a7b-878e-da52a9432e1d', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"Online learning helped many students continue their studies. Teachers recorded lessons, and learners watched them at home. Yet this solution had a serious limit: it left out those who had no internet at all."

In the third sentence, what does "this solution" refer to?', '[{"id":"a","text":"the serious limit"},{"id":"b","text":"online learning"},{"id":"c","text":"the students who had no internet"},{"id":"d","text":"the teachers"}]'::jsonb, 'b', '"This solution" sums up what was described before: online learning (recorded lessons watched at home). Reference phrases like ''this solution'' point back to the whole idea just explained. It is not the limit (a), which the solution ''had'', nor the students (c) or teachers (d).', 4),
  ('5df534a9-e67a-5969-a2c5-ad81ce85ec17', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"The volunteers worked tirelessly all weekend, clearing rubbish from the beach despite the heat and the long hours."

What does the word "tirelessly" most probably mean?', '[{"id":"a","text":"without getting paid"},{"id":"b","text":"without stopping or becoming tired"},{"id":"c","text":"in complete silence"},{"id":"d","text":"very slowly and carefully"}]'::jsonb, 'b', 'The context — working ''all weekend'', ''long hours'', ''despite the heat'' — shows continuous, energetic effort, so ''tirelessly'' means without stopping or getting tired. Pay (a), silence (c) and slowness (d) are not suggested; in fact ''slowly'' would contradict the hard, steady work described.', 5),
  ('f4f69f32-d96d-5306-9ce3-7144a7664518', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Put these sentences in the correct order to form a well-organised paragraph:

1. "As a result, customers receive their answers much faster than before."
2. "Therefore, many companies now combine machines with human staff to get the best of both."
3. "Technology has changed the way services treat their customers."
4. "However, a machine cannot fully understand a worried customer the way a person can."

What is the best order?', '[{"id":"a","text":"3 – 1 – 4 – 2"},{"id":"b","text":"1 – 3 – 2 – 4"},{"id":"c","text":"3 – 4 – 1 – 2"},{"id":"d","text":"2 – 3 – 1 – 4"}]'::jsonb, 'a', 'Sentence 3 is the general topic sentence (it comes first). Then 1 (''As a result'') gives a benefit of the technology. Sentence 4 (''However'') introduces the drawback, and 2 (''Therefore'') gives the logical conclusion. The chain of connectors gives 3 – 1 – 4 – 2.', 6),
  ('9d18f897-c064-5575-bdf5-1eaf14cf48d1', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"For years, the village school had only one computer, shared by two hundred pupils. Last year a charity sent thirty laptops. Test scores have not changed much yet, but for the first time the children no longer queue for hours, and their curiosity is finally awake."

What does the writer most strongly suggest about the donation?', '[{"id":"a","text":"It was a complete failure because test scores did not rise."},{"id":"b","text":"Its most valuable effect so far is on the children''s access and motivation, not yet on grades."},{"id":"c","text":"It proves that technology always improves exam results immediately."},{"id":"d","text":"The school no longer needs any teachers."}]'::jsonb, 'b', 'The writer admits scores ''have not changed much yet'' but stresses the real gains: no more queuing and awakened curiosity. The suggested meaning is that the early value lies in access and motivation, not grades. (a) ignores the clearly positive ''but''. (c) is contradicted by ''have not changed much''. (d) is never implied.', 1),
  ('c6e6d69e-f89f-589a-8d51-28ac9ed8fd2c', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"The film was praised by every critic in the country. Maya, however, walked out before the end, glancing at her watch more than once."

What can we most reasonably infer about Maya?', '[{"id":"a","text":"She agreed completely with the critics'' praise."},{"id":"b","text":"She found the film boring even though critics loved it."},{"id":"c","text":"She had to leave because the cinema was closing."},{"id":"d","text":"She had already seen the film many times before."}]'::jsonb, 'b', 'The contrast word ''however'', leaving early, and repeatedly checking her watch are clues that Maya was bored, unlike the critics. The inference is supported by the text. (a) contradicts those clues. (c) and (d) invent reasons the passage never gives.', 2),
  ('73c5df4e-c223-5c0f-a812-7e7a6f85435d', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"Parents often worry about screens. Yet screens are only tools. Used wisely, they teach and connect; used carelessly, they isolate. The difference lies not in the device but in the hand that holds it."

In the last sentence, what does "the hand that holds it" refer to figuratively?', '[{"id":"a","text":"the parents'' actual hands"},{"id":"b","text":"the way each person chooses to use the screen"},{"id":"c","text":"the company that builds the device"},{"id":"d","text":"the size of the screen"}]'::jsonb, 'b', 'The passage argues that the same tool can help or harm depending on use (''used wisely… used carelessly''). ''The hand that holds it'' is a figurative image for the user''s choices and habits. It is not literal hands (a), the manufacturer (c) or the screen size (d).', 3),
  ('7a43e475-982f-58ea-aefc-70c672df20e2', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"At first the new recycling rules seemed cumbersome: residents had to sort waste into four separate bins. Within a month, though, the sorting felt automatic and the streets were noticeably cleaner."

What does the word "cumbersome" most probably mean here?', '[{"id":"a","text":"cheap and simple"},{"id":"b","text":"awkward and troublesome to do"},{"id":"c","text":"dangerous and harmful"},{"id":"d","text":"exciting and enjoyable"}]'::jsonb, 'b', 'The contrast structure (''At first… though'') shows that ''cumbersome'' describes the early difficulty before it ''felt automatic''. Sorting waste into four bins being a burden means awkward and troublesome. ''Cheap and simple'' (a) and ''enjoyable'' (d) contradict the contrast, and danger (c) is not mentioned.', 4),
  ('3562c6fd-8a22-558d-981c-69692e31fd0c', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'You must complete a paragraph whose topic sentence is: "Reading for pleasure offers benefits that go far beyond the classroom." Two supporting sentences and a wrong continuation follow. Which sentence would be the LEAST appropriate to include in this paragraph?', '[{"id":"a","text":"It widens vocabulary and sharpens the imagination."},{"id":"b","text":"Moreover, it builds patience and the habit of concentration."},{"id":"c","text":"These skills help young people in work and in life, not only in exams."},{"id":"d","text":"The bookshop near my house closes at nine o''clock in the evening."}]'::jsonb, 'd', 'The paragraph develops the benefits of reading beyond school. Sentences a, b and c each support that idea with relevant points and good connectors. The closing time of a bookshop (d) is an off-topic detail that breaks the unity, so it is the least appropriate to include.', 5),
  ('0adab7d5-1c45-5d95-acce-c328c8f0dcf1', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this opening:

"Civility is the oil that keeps a society running smoothly. When people are rude, even small disagreements turn into conflicts."

Which sentence is the most coherent AND best-linked continuation?', '[{"id":"a","text":"On the other hand, when people are courteous, tense situations are quickly calmed."},{"id":"b","text":"For example, the bus arrives at eight every morning."},{"id":"c","text":"Therefore, my favourite season is winter."},{"id":"d","text":"Although oil is used to cook many delicious meals."}]'::jsonb, 'a', 'The passage contrasts the effect of rudeness with that of courtesy, so the best continuation balances the two with a contrast connector: ''On the other hand…'' (a). Option (b) misuses ''For example'' for an unrelated fact; (c) draws an illogical conclusion; (d) takes the word ''oil'' literally and derails the paragraph.', 6)
) AS v(id, exercise_id, prompt, options, correct_option, explanation, display_order)
WHERE EXISTS (SELECT 1 FROM public.exercises p WHERE p.id = v.exercise_id::uuid)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

