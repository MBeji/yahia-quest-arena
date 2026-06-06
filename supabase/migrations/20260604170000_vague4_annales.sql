-- Vague 4 — Annales / sujets types (Maths, Arabe, Français, Anglais, SVT).
-- Idempotent forward migration: new annales chapters + exercises + questions (FK-safe).

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('0d636faa-337f-57db-a256-88d4ec85ca49', 'math', 'سُبُر نموذجيّة ومراجعة شاملة', 'تمارين على شاكلة سُبُر امتحان ختم التعليم الأساسي: مسائل مركّبة تمزج عدّة دروس (أعداد، حساب حرفي، معادلات وجُمل، طاليس، فيثاغورس، النسب المثلّثية، الدوال، الإحصاء) مفكّكة إلى أسئلة QCM متسلسلة، مع منهجيّة مقاربة السبر.', '# 🏯 سُبُر نموذجيّة — منهجيّة الزعيم النهائيّ

> 💡 «سبر الامتحان الوطني ليس امتحانًا في درس واحد، بل ساحة معركة نهائيّة تُختبر فيها كلّ أسلحتك دفعةً واحدة. مَن يُتقن المنهجيّة يربح قبل أن يبدأ.»

سبر ختم التعليم الأساسي في الرياضيات لا يسألك «طبّق نظرية طاليس» فقط، بل يضعك أمام **مسألة مركّبة** تتطلّب أن تمزج عدّة دروس في تمرين واحد: مسألة هندسية قد تحتاج طاليس **ثمّ** فيثاغورس **ثمّ** نسبة مثلّثية؛ ومسألة حسابية قد تبدأ بحساب حرفي وتنتهي بحلّ جملة معادلتَين. هذا الفصل يدرّبك على **التفكيك المنطقي** للمسألة وعلى إدارة الوقت والأخطاء.

## ⏳ كيف تقسّم وقتك في السبر

السبر عادةً ساعتان لتمرينَين أو ثلاثة. خطّة الوقت الفائزة:

1. **قراءة شاملة أوّليّة (5 دقائق)**: اقرأ كلّ التمارين قبل أن تكتب حرفًا. حدّد الأسهل وابدأ به لتكسب الثقة والنقاط المضمونة.
2. **التوزيع حسب النقاط**: امنح كلّ تمرين وقتًا يتناسب مع عدد نقاطه، لا مع طوله.
3. **قاعدة الدقيقتَين**: إن علِقت في سؤال أكثر من دقيقتَين دون فكرة، انتقل وعُد إليه لاحقًا. لا تترك سؤالًا سهلًا في تمرين آخر رهينةً لسؤال صعب.
4. **حجز ربع ساعة للمراجعة**: في النهاية أعِد التحقّق من الحسابات والوحدات (cm، cm²، °).

> ⚠️ الخطأ القاتل: قضاء 40 دقيقة في السؤال الأخير الصعب وترك سؤالَين سهلَين دون حلّ. النقاط متساوية في القيمة، فابدأ بالأرخص جهدًا.

## 🧩 استراتيجيّة تفكيك المسألة المركّبة

كلّ مسألة طويلة هي سلسلة من خطوات صغيرة مترابطة. السؤال (1) يُغذّي السؤال (2) وهكذا:

- **اقرأ كلّ الأسئلة الفرعيّة أوّلًا**: غالبًا يكشف السؤال الأخير عن الهدف، فتفهم لماذا تحسب ما تحسبه.
- **استثمر النتائج**: إن أوجدتَ طولًا في السؤال (أ)، فهو على الأرجح مُعطى جاهز للسؤال (ب). لا تُعِد حسابه.
- **إن أخطأتَ في خطوة، لا تستسلم**: واصل بالنتيجة (حتّى لو شككتَ فيها)؛ الطريقة الصحيحة تُحسب.

## 📐 استراتيجيّة المسألة الهندسيّة

المسألة الهندسيّة في السبر تتدرّج كالتالي عادةً:

1. **ارسم الشكل بدقّة** وأعِد رسمه على ورقتك إن لزم، مع تدوين كلّ المعطيات على الأضلاع والزوايا.
2. **حدّد الأداة المناسبة لكلّ خطوة**:
   - أطوال متناسبة + مستقيمات متوازية ← **نظرية طاليس** (أو عكسها لإثبات التوازي).
   - مثلّث قائم + ضلعان معلومان والثالث مجهول ← **نظرية فيثاغورس**.
   - مثلّث قائم + ضلع وزاوية ← **النسب المثلّثية** (جا، جتا، ظا).
   - إثبات أنّ مثلّثًا قائم ← **عكس فيثاغورس** ($AC^2 = AB^2 + BC^2$؟).
3. **رتّب الخطوات**: غالبًا طاليس يعطيك طولًا، ثمّ فيثاغورس يعطيك طولًا آخر، ثمّ النسبة المثلّثية تعطيك زاوية.

**تذكِرة النسب المثلّثيّة المشهورة**:

$$\sin 30° = \tfrac{1}{2}, \quad \cos 60° = \tfrac{1}{2}, \quad \tan 45° = 1, \quad \cos 30° = \sin 60° = \tfrac{\sqrt{3}}{2}$$

## 🧮 استراتيجيّة المسألة الحسابيّة والجبريّة

1. **الحساب العددي**: انتبه للأولويّات (الأقواس ثمّ القوى ثمّ × و÷ ثمّ + و−)، وللإشارات السالبة.
2. **الحساب الحرفي**: انشر بحذر ($a(b+c)=ab+ac$)، واستعمل المتطابقات الشهيرة:
   $$(a+b)^2 = a^2 + 2ab + b^2, \quad (a-b)^2 = a^2 - 2ab + b^2, \quad (a-b)(a+b) = a^2 - b^2$$
3. **الوضعيّات الواقعيّة (المسائل)**: ترجِم النصّ إلى **معادلة أو جملة معادلتَين**. عرّف المجهول بوضوح («لِيكن $x$ عدد...») قبل أن تكتب المعادلة.
4. **حلّ الجملة**: بالتعويض أو بالجمع/الطرح، ثمّ **عُد دائمًا للسياق**: هل الحلّ منطقي (عدد أشخاص موجب وصحيح، طول موجب)؟

> 💡 المسألة الواقعيّة تُفقد نقاطها أكثرَ ما تُفقد في **عدم العودة إلى الوحدة أو السياق**. الجواب «$x=4$» ناقص؛ الصواب «عدد التذاكر هو 4».

## 🚫 الأخطاء الشائعة التي تُسقط النقاط

- **نسيان الوحدات** أو خلطها (طول بـ cm، مساحة بـ cm²، حجم بـ cm³).
- **تطبيق فيثاغورس على مثلّث غير قائم**، أو خلط الوتر بضلع قائم.
- **قلب النسبة المثلّثيّة** (جا مكان جتا): راجِع «المقابل/الوتر» مقابل «المجاور/الوتر».
- **خطأ الإشارة** عند نقل حدّ من طرف لآخر في المعادلة، أو عند نشر $-(a-b)$.
- **التقريب المبكّر**: لا تُقرّب إلّا في النتيجة النهائيّة، وإلّا تراكمت الأخطاء.
- **عدم التحقّق**: عوّض الحلّ في المعادلة الأصليّة دائمًا — دقيقتان تُنقذان نقاطًا.

> 🏆 أتقِن المنهجيّة، فكّك المسألة خطوةً خطوة، وتحقّق من كلّ نتيجة — وستدخل السبر كزعيم لا كضحيّة.', '# 📜 ملخّص: منهجيّة سُبُر الامتحان

- **قبل الكتابة**: اقرأ كلّ التمارين، ابدأ بالأسهل، وزّع الوقت حسب النقاط لا حسب الطول.
- **قاعدة الدقيقتَين**: علِقت؟ انتقل وعُد لاحقًا. احجز ربع ساعة للمراجعة في النهاية.
- **التفكيك**: المسألة المركّبة سلسلة خطوات؛ نتيجة كلّ سؤال غالبًا مُعطى للسؤال التالي — لا تُعِد حسابها.
- **المسألة الهندسيّة**: ارسم بدقّة ← اختر الأداة: متوازيات ونِسب ← **طاليس**؛ مثلّث قائم وضلعان ← **فيثاغورس**؛ ضلع وزاوية ← **النسب المثلّثيّة**.
- **النسب المشهورة**: $\sin 30°=\tfrac12$, $\cos 60°=\tfrac12$, $\tan 45°=1$, $\cos 30°=\sin 60°=\tfrac{\sqrt3}{2}$.
- **المسألة الواقعيّة**: عرّف المجهول ← اكتب المعادلة/الجملة ← احلل ← **عُد للسياق والوحدة**.
- **المتطابقات**: $(a+b)^2=a^2+2ab+b^2$، $(a-b)(a+b)=a^2-b^2$.
- **أخطاء قاتلة**: نسيان الوحدات، فيثاغورس على غير قائم، قلب النسبة المثلّثيّة، خطأ الإشارة، التقريب المبكّر، عدم التحقّق.
- **دائمًا تحقّق**: عوّض الحلّ في المعطيات الأصليّة قبل الانتقال.', 14),
  ('468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', 'Annales & sujets types', 'S''entraîner sur des sujets façon épreuve de fin d''études (ختم التعليم الأساسي) : lire un texte (récit, description, texte informatif ou argumentatif), répondre aux questions de compréhension, traiter les questions de langue (temps verbaux, voix passive, discours rapporté, subordonnées, lexique) portant sur ce texte, et préparer la production écrite (thèse, amorce, connecteurs, cohérence).', '# Annales & sujets types — Méthodologie de l''épreuve

L''épreuve de français de fin d''études de base (ختم التعليم الأساسي) repose sur **un texte** suivi de trois grandes parties. Le temps est limité : il faut donc une méthode pour répartir son effort. Ce chapitre te propose des **sujets types** complets, décomposés en QCM, pour t''entraîner exactement comme le jour de l''examen.

## 1. Lire le texte intelligemment (5 à 10 min)

Avant de répondre, lis le texte **deux fois** :

- **Première lecture** : pour comprendre globalement de quoi il parle (le thème, qui parle, où, quand).
- **Deuxième lecture, crayon en main** : repère le **type de texte** (récit, descriptif, informatif, argumentatif), l''**idée directrice** ou la **thèse**, les **connecteurs logiques** (mais, donc, car, pourtant…) et les **mots difficiles** à comprendre dans leur contexte.

Astuce : le **titre**, le **premier** et le **dernier** paragraphe contiennent souvent l''essentiel.

## 2. La compréhension du texte (≈ 40 % de la note)

Les questions de compréhension testent ta lecture, pas ton imagination. Trois règles d''or :

- **Réponds avec le texte** : la bonne réponse s''appuie sur un indice précis (un mot, une phrase). Ne réponds jamais « au feeling ».
- **Distingue l''explicite et l''implicite** : certaines questions demandent une information écrite noir sur blanc ; d''autres demandent d''**inférer** (déduire) à partir d''indices, sans rien inventer.
- **Méfie-toi des pièges** : un distracteur déforme souvent un détail vrai, ou exagère (« toujours », « jamais »), ou dit le contraire du texte.

On te demandera typiquement : l''idée directrice / la thèse, le type ou le ton du texte, le rôle d''un connecteur, le sens d''un mot **en contexte**, ou une inférence sur un personnage ou une situation.

## 3. Les questions de langue (≈ 30 % de la note)

Cette partie applique la grammaire **au texte étudié**. Les notions les plus fréquentes en 9e :

- **Temps et modes verbaux** : valeur du présent, opposition imparfait / passé simple dans le récit, futur, conditionnel.
- **Voix active / voix passive** : transformer une phrase, identifier le complément d''agent (introduit par « par » ou « de »), comprendre pourquoi l''auteur choisit le passif.
- **Discours direct / indirect** (discours rapporté) : passer du direct à l''indirect, repérer les changements de pronoms, de temps et de ponctuation.
- **Propositions subordonnées** : relatives (qui, que, dont, où), complétives (que…), circonstancielles de cause, de but, de conséquence, de condition, de temps.
- **Lexique** : famille de mots, synonymes / antonymes, sens propre / sens figuré, champ lexical.

Conseil : **relis la phrase exacte du texte** citée par la question avant de transformer ou d''analyser.

## 4. La production écrite (≈ 30 % de la note)

C''est l''épreuve qui rapporte le plus de points perdus. Quelques réflexes qui font la différence :

- **Lis bien la consigne** : type de texte demandé (récit, description, lettre, paragraphe argumentatif), sujet précis, longueur attendue.
- **Construis un plan** avant de rédiger : introduction (amorce + thèse) → développement (un argument et un exemple par paragraphe) → conclusion.
- **Soigne l''amorce** : la première phrase introduit le sujet sans le traiter (un constat, une question, un fait frappant).
- **Choisis le bon connecteur** : il doit traduire le **vrai** lien entre les idées (addition, cause, conséquence, opposition). Un mauvais connecteur rend le texte incohérent.
- **Vérifie la cohérence** : pas de hors-sujet, pas de contradiction, un enchaînement logique du début à la fin.
- **Relis** pour corriger l''orthographe, la conjugaison et la ponctuation : ces points sont notés.

## Gérer les trois parties ensemble

Le secret de l''épreuve n''est pas de tout savoir, mais de bien **répartir son temps** :

1. Lecture active du texte.
2. Compréhension (réponses courtes et précises, appuyées sur le texte).
3. Langue (appliquer les règles à des phrases du texte).
4. Production écrite : garder **assez de temps** (souvent un tiers du total) pour planifier, rédiger et relire.

Dans ce chapitre, chaque exercice est un **mini-sujet complet** : un texte, puis des questions de compréhension, de langue et de production qui portent **toutes sur ce même texte**. Entraîne-toi comme le jour J : lis d''abord le texte en entier, puis réponds.', '# Résumé — Annales & sujets types

## Structure de l''épreuve

- **Un texte** (récit, descriptif, informatif ou argumentatif) suivi de trois parties : **compréhension**, **langue**, **production écrite**.
- Répartir son temps : lecture active → compréhension → langue → production écrite (garder ≈ 1/3 du temps pour produire et relire).

## Lire le texte

- Lire **deux fois** : globalement, puis crayon en main.
- Repérer le **type de texte**, l''**idée directrice / thèse**, les **connecteurs**, les **mots difficiles** en contexte.

## Compréhension

- **Répondre avec le texte** : chaque réponse s''appuie sur un indice précis.
- Distinguer l''**explicite** (écrit) de l''**implicite** (inférer sans inventer).
- Pièges fréquents : détail déformé, exagération (« toujours », « jamais »), contraire du texte.

## Langue (appliquée au texte)

- **Temps / modes** : présent, imparfait vs passé simple dans le récit, futur, conditionnel.
- **Voix passive** : transformer, repérer le **complément d''agent** (par / de).
- **Discours rapporté** : passer du direct à l''indirect (pronoms, temps, ponctuation).
- **Subordonnées** : relatives (qui, que, dont, où), complétives, circonstancielles (cause, but, conséquence, condition, temps).
- **Lexique** : synonymes / antonymes, sens propre / figuré, champ lexical, famille de mots.

## Production écrite

- **Plan** : introduction (amorce + thèse) → développement (argument + exemple par paragraphe) → conclusion.
- **Amorce** : introduit le sujet sans le traiter.
- **Thèse** : claire, affirmée, orientée vers ce qu''on va prouver.
- **Bon connecteur** : traduit le vrai lien entre les idées ; un mauvais choix nuit à la cohérence.
- **Cohérence** : pas de hors-sujet ni de contradiction ; relire (orthographe, conjugaison, ponctuation).', 10),
  ('25883c0e-2e60-52b4-ad9e-de3ffce1e9d8', 'arabic', 'سُبُر نموذجيّة ومراجعة', 'سُبُر مصغّرة على شاكلة اختبار ختم التعليم الأساسي في العربية: نصّ من محاور التاسعة يتبعه فهم (شرح النصّ) وأسئلة لغة (نحو وصرف) على النصّ نفسه وتقييم الإنتاج الكتابي الحجاجيّ، تدريبًا متكاملًا على الامتحان.', '# 📝 سُبُر نموذجيّة ومراجعة — كيف تجتاز اختبار العربية في ختم التعليم الأساسي

> 💡 «السبر تدريبٌ على الامتحان قبل الامتحان: من ألِف بنيته أمِن مفاجآته، ومن مرّن عينه على النصّ قرأه قراءةً تكشف لا قراءةً تمرّ.»

اختبار اللغة العربية في امتحان ختم التعليم الأساسي اختبارٌ **مركّب** يقيس ثلاث كفايات في سندٍ واحد: **فهم المقروء (شرح النصّ)**، و**التمكّن من اللغة (نحوًا وصرفًا)**، و**الإنتاج الكتابي الحجاجيّ**. هذا الفصل سُبُرٌ نموذجيّة تُحاكي بنية الامتحان: نصٌّ من محاور التاسعة (العمل، المرأة، شواغل العالم المعاصر، الفنون، تفاعل الثقافات) يتبعه أسئلةٌ في الكفايات الثلاث.

---

## 🏰 القسم الأوّل: شرح النصّ (الفهم)

تُبنى أسئلة الفهم على النصّ نفسه، فلا تُجِب من خارجه:

- **الفكرة العامة**: الموضوع المحوريّ للنصّ كلّه في جملةٍ جامعة تضمّ الموضوع وموقف الكاتب.
- **الأفكار الجزئية**: وحدة المعنى في كلّ مقطع؛ مجموعها = الفكرة العامة.
- **نوع النصّ ونمطه**: سرديّ، وصفيّ، تفسيريّ، حجاجيّ — تُمييّزه علاماتُه (أفعال الحدث، النعوت، الروابط السببيّة، الأطروحة والحجج).
- **دور الروابط**: السبب (لأنّ، إذ)، النتيجة (لذلك، فـ)، الإضافة (كذلك، فضلًا عن)، الاستدراك (لكنْ، غير أنّ، بيدَ أنّ)، التمثيل (مثلًا).
- **النبرة**: موقف الكاتب الانفعاليّ، تُستشفّ من المفردات المشحونة وأساليب الإنشاء والتكرار.
- **الاستنتاج**: قراءةٌ بين السطور مدعومةٌ بقرائن النصّ، لا إسقاطٌ من خارجه.
- **شرح المفردة في سياقها**: السياق يحسم المعنى المقصود لا المعنى الأشهر في المعجم.

> 🗝️ **حيلة عمليّة:** اقرأ المطلع والخاتمة أوّلًا؛ فالفكرة العامة والأطروحة يتركّزان فيهما غالبًا.

---

## ⚔️ القسم الثاني: أسئلة اللغة (نحوًا وصرفًا)

تُؤخذ الشواهد من النصّ نفسه، فالإعراب يخدم الفهم لا يُفصَل عنه:

### النحو

- **الإعراب والبناء**: تحديد موقع الكلمة (فاعل، مفعول به، مبتدأ، خبر، حال، نعت، مضاف إليه) وعلامة إعرابها (أصلية: الضمّة/الفتحة/الكسرة/السكون، أو فرعية: الواو/الياء/الألف/حذف النون).
- **النواسخ**: كان وأخواتها (ترفع الاسم وتنصب الخبر)، إنّ وأخواتها (تنصب الاسم وترفع الخبر).
- **الأساليب**: الاستفهام (حقيقيّ/إنكاريّ)، التعجّب، الشرط، النفي، النهي، التوكيد.

### الصرف

- **المشتقّات**: اسم الفاعل، اسم المفعول، الصفة المشبّهة، اسم التفضيل، اسما الزمان والمكان.
- **الميزان الصرفيّ**: وزن الكلمة (فَعَل، فاعِل، مَفعول، اِستِفعال…) وما لحقها من زيادة.
- **التصريف**: المجرّد والمزيد، الصحيح والمعتلّ، الإسناد إلى الضمائر.

> 🧩 لا تُجِب عن سؤال اللغة بقاعدةٍ محفوظة منفصلة؛ ضع الكلمة في موقعها من جملة النصّ ثمّ احكم.

---

## ✍️ القسم الثالث: تقييم الإنتاج الكتابي الحجاجيّ

تقيس أسئلةُ هذا القسم قدرتك على **تمييز الإنتاج الجيّد** من المعيب، تمهيدًا لكتابته:

### 1. الأطروحة الأنسب

الأطروحة موقفٌ واضحٌ قابلٌ للدفاع، لا سؤالًا ولا فكرةً غامضة. أفضل أطروحةٍ هي التي:

- تتّصل بالسند والتعليمة.
- تُصاغ في جملةٍ خبريّة حاسمة.
- تقبل البرهنة بحجّةٍ ومثال.

### 2. الحجّة والمثال

- **الحجّة**: فكرة عقليّة عامّة تُبرّر الموقف.
- **المثال**: واقعة جزئيّة محسوسة تُجسّد الحجّة.

> ⚖️ المثال يخدم الحجّة ولا يحلّ محلّها؛ حجّةٌ بلا مثال جافّة، ومثالٌ بلا حجّة ناقص.

### 3. الرابط المنطقيّ الملائم

اختيار الرابط الصحيح يكشف العلاقة بين الأفكار: تعليلٌ بـ«لأنّ»، نتيجةٌ بـ«لذلك»، إضافةٌ بـ«علاوةً على»، استدراكٌ بـ«غير أنّ».

### 4. الخاتمة المتماسكة

الخاتمة الجيّدة تُلخّص الموقف ثمّ تفتح أفقًا أو تُقدّم خلاصة؛ لا تُدخل فكرةً جديدةً ولا تكرّر المقدّمة حرفيًّا.

> 🏆 من فهم النصّ فهمًا عميقًا، وضبط لغته ضبطًا دقيقًا، وميّز الإنتاج المتماسك من المفكّك، اجتاز السبر — والامتحان — بثقة.', '# 📜 ملخّص: السُّبُر النموذجيّة ومنهجيّة الامتحان

اختبار العربية في ختم التعليم الأساسي = نصّ واحد + ثلاث كفايات: **فهم + لغة + إنتاج**.

## شرح النصّ (الفهم)

- **الفكرة العامة**: محور النصّ كلّه في جملةٍ جامعة (الموضوع + موقف الكاتب).
- **النمط**: سرديّ / وصفيّ / تفسيريّ / حجاجيّ، يُميّز بعلاماته.
- **الروابط**: سبب (لأنّ)، نتيجة (لذلك)، إضافة (كذلك)، استدراك (لكنْ، غير أنّ، بيدَ أنّ)، تمثيل (مثلًا).
- **النبرة**: موقف الكاتب الانفعاليّ من المفردات والأساليب.
- **الاستنتاج**: قراءةٌ بين السطور مدعومةٌ بقرائن النصّ.
- **شرح المفردة**: السياق يحسم المعنى.

## أسئلة اللغة (نحوًا وصرفًا)

- **النحو**: الموقع الإعرابيّ (فاعل، مفعول، خبر، حال، نعت) وعلامته (أصلية/فرعية)، النواسخ، الأساليب.
- **الصرف**: المشتقّات (اسم فاعل/مفعول، صفة مشبّهة، اسم تفضيل)، الميزان الصرفيّ، المجرّد والمزيد.
- القاعدة: ضع الكلمة في موقعها من جملة النصّ ثمّ احكم.

## تقييم الإنتاج الحجاجيّ

- **الأطروحة الأنسب**: موقفٌ خبريّ حاسم متّصل بالتعليمة قابلٌ للبرهنة.
- **الحجّة** عقليّة عامّة، و**المثال** واقعة تُجسّدها؛ المثال يخدم الحجّة ولا يحلّ محلّها.
- **الرابط الملائم**: يكشف العلاقة (تعليل/نتيجة/إضافة/استدراك).
- **الخاتمة المتماسكة**: تلخيص الموقف + أفق أو خلاصة، بلا فكرةٍ جديدة ولا تكرارٍ حرفيّ للمقدّمة.', 11),
  ('28c49d05-7851-5d81-b041-e443203e34d3', 'english', 'Exam-Style Papers', 'Practise the full national exam (ختم التعليم الأساسي) in English: each paper gives you a reading text, then comprehension questions, language-in-context items and short writing tasks built on that same text. Learn to read carefully, use grammar accurately and write clearly under exam conditions.', '# 📝 Exam-Style Papers: Your Strategy Guide

The end-of-basic-education English exam (**ختم التعليم الأساسي**) is always built the
same way. If you know the shape of the paper, you can plan your time and pick up
easy marks. Every paper has three parts, all linked to **one reading text**:

1. **Reading comprehension** — questions about what the text says and means.
2. **Language** — grammar and vocabulary used _inside_ sentences from the text.
3. **Writing** — short tasks that test how you organise and connect ideas.

This chapter turns each part into clear QCM items so you can train the exact skills
the examiner rewards.

---

## Part 1 — Reading comprehension

You are given a text on a familiar theme: **Family Life, Education, Health &
Environment, Services, Entertainment** or **Civility**. Read it **twice**: once for
the general idea, once slowly for the details.

- **Main idea** — the whole message of the text or paragraph, not one small detail.
  It is often near the start or the end.
- **Specific details** — facts you find by _scanning_ for a key word (a name, a
  number, a place, a date).
- **Inference** — a conclusion the text _suggests_ but does not say directly. It must
  be supported by clues, never by your own opinion.
- **Reference words** — pronouns such as _it, they, this, these, such_ point **back**
  to the nearest matching noun. Always check what the word replaces.
- **Vocabulary in context** — guess an unknown word from the sentence: look for a
  synonym, a definition, an example, or a contrast word (_but, however_).
- **True / False / Not mentioned** — choose _Not mentioned_ when the text simply does
  not give the information; do not confuse it with _False_.

> Exam tip: every answer is **in the text**. If you cannot point to the line that
> proves your choice, choose again.

---

## Part 2 — Language in context

The language items test the grammar you studied in chapters 1–8, but always inside a
sentence taken from (or based on) the text. The most common points are:

- **Tenses** — present simple vs continuous, past simple vs present perfect, future
  forms. Match the time markers (_yesterday, since, already, next week_).
- **Modals** — _can, must, should, have to, might_ — choose by **meaning**
  (ability, obligation, advice, possibility).
- **Conditionals** — type 1 (_If it rains, we will…_), type 2 (_If I were…_),
  type 3 (_If he had studied, he would have passed_). The _if_-clause fixes the form.
- **Passive voice** — _be + past participle_. Use it when the doer is unknown or
  unimportant (_The bridge was built in 2010_).
- **Reported speech** — shift the tense back one step and change pronouns and time
  words (_"I am tired" → He said he was tired_).
- **Relative clauses** — _who_ (people), _which/that_ (things), _where_ (places),
  _whose_ (possession). The relative word stands for the noun before it.

> Exam tip: read the **whole** sentence before choosing. The right form depends on
> the words around the gap, not just the gap itself.

---

## Part 3 — Writing skills

The writing part is graded on **organisation and coherence**, not only on grammar.
The QCM items train the building blocks:

- **Topic sentence** — a clear, general first sentence that announces the paragraph''s
  one main idea (not an example, not a detail).
- **Logical order** — topic sentence → supporting sentences in a sensible order →
  closing sentence. Connectors (_first, then, however, therefore, finally_) show the
  order.
- **Linking words** — choose them by meaning: addition (_also_), contrast
  (_but, however_), cause (_because_), result (_so, therefore_), example
  (_such as, for instance_).
- **Unity** — every sentence must support the topic; remove any sentence that drifts
  off the subject.
- **Coherent continuation** — the next sentence must follow logically from what comes
  before; it cannot contradict it or jump to a new topic.

> Exam tip: a good paragraph says **one** thing well. Decide your idea first, then
> support it step by step.

---

## How to use the papers

- **Paper 1 (Practice)** — a gentle full paper to learn the routine.
- **Paper 2 (Boss)** — a harder paper under tighter time, like the real exam.
- **Challenge (Défi)** — a demanding paper for those aiming at the top mark.

Work calmly, prove each answer from the text, and check your grammar before you move
on. That is exactly how marks are won on exam day.', '# 📜 Summary: Exam-Style Papers

## The paper has three parts (all on one text)

1. **Reading comprehension** — what the text says and means.
2. **Language in context** — grammar inside the text''s sentences.
3. **Writing skills** — organising and connecting ideas.

## Reading

- **Main idea** = the whole message, not one detail; often near the start/end.
- **Detail** = scan for a key word (name, number, place, date).
- **Inference** = a conclusion the text suggests; must be backed by clues.
- **Reference words** (it, they, this, such) point back to the nearest matching noun.
- **Vocabulary in context** = guess from synonym, definition, example or contrast.
- **Not mentioned** ≠ **False**: choose it when the info is simply absent.

## Language

- **Tenses**: match the time markers (yesterday, since, already, next week).
- **Modals**: choose by meaning (ability, obligation, advice, possibility).
- **Conditionals**: type 1 will + base; type 2 would + base; type 3 would have + p.p.
- **Passive**: be + past participle (doer unknown/unimportant).
- **Reported speech**: shift tense back, change pronouns and time words.
- **Relative clauses**: who (people), which/that (things), where (place), whose (possession).

## Writing

- **Topic sentence** = clear, general first sentence with the one main idea.
- **Order** = topic sentence → supporting sentences → closing sentence.
- **Linking words** = pick by meaning (also / however / because / therefore / such as).
- **Unity** = remove any sentence that drifts off the topic.
- **Coherent continuation** = the next sentence must follow logically.

> Golden rule: every answer is **in the text** — if you can''t point to the proof, choose again.', 10),
  ('e544d74c-e24f-5d7d-83af-3c29e0d74bc1', 'sciences-vie-terre', 'سُبُر نموذجيّة ومراجعة شاملة', 'سُبُر على شاكلة امتحان ختم التعليم الأساسي في علوم الحياة والأرض: تحليل وثائق (مخطّطات، تجارب، منحنيات موصوفة، أنماط نووية، سجلّات زلزالية، خرائط توزّع البراكين) واستخلاص الاستنتاجات، مع استرجاع المعارف، عبر الأحياء (التكاثر، المناعة، الوراثة) والجيولوجيا (الزلازل، البراكين، تكتونية الصفائح)، مفكّكة إلى أسئلة QCM', '# 🎓 سُبُر نموذجيّة ومراجعة شاملة — منهجيّة السبر في علوم الحياة والأرض

> 💡 «الامتحان لا يطلب منك أن تحفظ فحسب، بل أن **تقرأ وثيقة، وتحلّلها، ثمّ تستنتج**. هذا الفصل يدرّبك على هذه الخطوات الثلاث في الأحياء والجيولوجيا معًا.»

## 🏰 ما هو «السبر» وكيف تُبنى أسئلته؟

يُبنى موضوع علوم الحياة والأرض في امتحان ختم التعليم الأساسي عادةً من نوعين من الأسئلة:

- **استرجاع المعارف**: تذكّر تعريف، عدد، أو قاعدة (مثل: عدد صبغيّات الخليّة الجسمية، دور الكريّات البيضاء، تعريف البؤرة الزلزالية).
- **تحليل وثيقة**: تُقدَّم لك وثيقة (مخطّط، نتائج تجربة، منحنى، نمط نووي، سجلّ زلزالي، خريطة) وتُطلب منك قراءتها واستخلاص استنتاج منها.

في هذا الفصل حوّلنا كلّ مسألة إلى أسئلة **QCM**: نصف الوثيقة بدقّة ثمّ نسألك عن قراءتها واستنتاجها.

## ⚡ الخطوة 1: تحليل الوثيقة (قراءة قبل الاستنتاج)

تختلف الوثائق، ولكلّ نوع طريقة قراءة:

- **منحنى موصوف**: حدّد ما يمثّله المحور الأفقي (غالبًا الزمن) والمحور العمودي (الكمّية المقيسة: تركيز هرمون، عدد أجسام مضادّة...). ابحث عن: متى يرتفع؟ متى ينخفض؟ أين القمّة؟
- **نتائج تجربة**: قارن بين **الشاهد** والحالة المُختبَرة. الفرق بينهما هو ما يكشف دور العامل المدروس.
- **نمط نووي (caryotype)**: عُدّ الصبغيّات وانظر إلى الزوج الجنسي (XX أو XY) وإلى أيّ زوج فيه عدد غير طبيعي (3 نسخ = تثلّث).
- **سجلّ زلزالي (مخطّط الموجات)**: الموجات **P** تصل أوّلًا ثمّ **S**؛ فرق وصولهما يدلّ على بُعد المركز.
- **خريطة توزّع البراكين والزلازل**: لاحظ أنّ معظمها يتمركز على **حدود الصفائح** لا عشوائيًّا.

> ⚠️ خطأ شائع: القفز إلى الاستنتاج قبل **قراءة** الوثيقة. اقرأ المعطيات أوّلًا، ثمّ استنتج.

## 🛡️ الخطوة 2: صياغة الاستنتاج

الاستنتاج جواب **مبنيّ على معطى الوثيقة**، لا على رأي شخصي:

- اربط دائمًا الاستنتاج بالملاحظة: «بما أنّ المنحنى يرتفع بعد الإلقاح ← إذن الهرمون يهيّئ الرحم للحمل».
- في التجربة: «الحيوان الشاهد مات والمُلقَّح بقي حيًّا ← إذن التلقيح يحمي من المرض».
- احذر من **التعميم الزائد**: استنتج فقط ما تدعمه الوثيقة.

## 🔮 الخطوة 3: استرجاع المعارف وربطها

بعد التحليل، اربط النتيجة بمعرفتك من الدروس:

- **التكاثر**: الدورة الجنسية، دور الهرمونات، الإلقاح، تكوّن البيضة المخصّبة.
- **المناعة**: الذات واللاذات، الخطّ الأوّل (الحواجز)، البلعمة، الأجسام المضادّة، الذاكرة المناعية والتلقيح.
- **الوراثة**: الصبغيّات والـ ADN والمورّثة، الحليلات السائد/المتنحّي، تحديد الجنس، الأمراض الوراثية والتثلّث الصبغي.
- **الزلازل**: البؤرة والمركز السطحي، الموجات والمرصاد، الشدّة والمقدار، الوقاية.
- **البراكين**: الصهارة، أنواع البراكين (انفجاري/انسيابي)، المقذوفات.
- **تكتونية الصفائح**: حركة الصفائح، الحدود المتباعدة/المتقاربة، وعلاقتها بالزلازل والبراكين.

> 🗡️ القاعدة الذهبية: **الجيولوجيا والأحياء تتقاطعان** — فالزلازل والبراكين يفسّرهما تحرّك الصفائح، وكلّ ظاهرة بيولوجية لها سند تجريبي يُقرأ من وثيقة.

> 🏆 إذا أتقنتَ هذه الخطوات الثلاث (اقرأ ← استنتج ← اربط بالمعرفة)، صرتَ جاهزًا لأيّ سبر في علوم الحياة والأرض.', '# 📜 ملخّص: منهجيّة السبر ومراجعة شاملة

- **خطوات السبر الثلاث**: (1) تحليل الوثيقة (اقرأ المعطيات) ← (2) صياغة استنتاج مبنيّ على الملاحظة ← (3) ربطه بمعارف الدرس.
- **قراءة منحنى**: المحور الأفقي غالبًا الزمن، العمودي الكمّية المقيسة؛ ابحث عن الارتفاع والانخفاض والقمّة.
- **قراءة تجربة**: قارن **الشاهد** بالحالة المختبَرة؛ الفرق يكشف دور العامل.
- **نمط نووي**: عُدّ الصبغيّات (46 = طبيعي)، انظر الزوج الجنسي (XX أنثى / XY ذكر) والتثلّث (47 في داون).
- **سجلّ زلزالي**: الموجات **P** قبل **S**؛ فرق الوصول يدلّ على بُعد المركز السطحي.
- **توزّع البراكين والزلازل**: يتمركز على **حدود الصفائح**، لا عشوائيًّا.
- **التكاثر**: هرمونات الدورة، الإلقاح، البيضة المخصّبة. **المناعة**: البلعمة، الأجسام المضادّة، الذاكرة والتلقيح.
- **الوراثة**: النواة ← الصبغيّ ← ADN ← المورّثة؛ سائد يظهر دائمًا، متنحٍّ بـ a//a فقط؛ الأب يحدّد الجنس.
- **الجيولوجيا**: الشدّة تختلف بالمكان والمقدار قيمة واحدة؛ البراكين الانفجارية صهارتها لزجة؛ الزلازل والبراكين نتاج حركة الصفائح.
- ⚠️ لا تستنتج إلّا ما تدعمه الوثيقة، ولا تخلط بين **الشدّة** و**المقدار**، ولا بين **الصبغيّ** و**المورّثة**.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('524341c8-b06e-56ea-8f79-09a4cf281ab8', '0d636faa-337f-57db-a256-88d4ec85ca49', 'math', 'اختبار المراجعة الشاملة', 1, 20, 5, 'quiz', 'admin', 0),
  ('192ab383-a349-5ce8-bef9-fc37ad988a0d', '0d636faa-337f-57db-a256-88d4ec85ca49', 'math', '📝 سبر تطبيقي: مسألة هندسية ومسألة واقعية', 2, 50, 10, 'practice', 'admin', 1),
  ('29558798-6563-5fdb-9042-5374b54145be', '0d636faa-337f-57db-a256-88d4ec85ca49', 'math', '⚔️ زعيم السبر: مسألة هندسية مركّبة ومسألة جملة', 3, 120, 30, 'boss', 'admin', 2),
  ('377d74ea-0e11-5a70-9f62-2b390afb7c31', '0d636faa-337f-57db-a256-88d4ec85ca49', 'math', '👑 تحدّي النخبة: سبر شامل بمستوى الامتياز', 4, 300, 60, 'challenge', 'admin', 3),
  ('f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', 'Quiz — Maîtriser le sujet type d''examen', 1, 20, 5, 'quiz', 'admin', 0),
  ('cc6100ec-d480-5f4c-a6b1-931442e93632', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', 'Sujet 1 — Texte narratif : le retour au village', 2, 50, 10, 'practice', 'admin', 1),
  ('1d1ca79e-04f6-5f75-84b4-ab412ba348aa', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', '⚔️ Sujet 2 (Boss) — Texte informatif : l''eau, une ressource précieuse', 3, 120, 30, 'boss', 'admin', 2),
  ('92e19205-ad69-502c-9e68-9cb60a80c9a6', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', '🔥 Sujet 3 (Défi) — Texte argumentatif : faut-il garder le livre papier ?', 4, 300, 60, 'challenge', 'admin', 3),
  ('4804d03e-a906-5c55-b91c-f7e5ea6184a6', '25883c0e-2e60-52b4-ad9e-de3ffce1e9d8', 'arabic', 'سبر تمهيديّ: بنية اختبار العربية', 1, 20, 5, 'quiz', 'admin', 0),
  ('4469d441-7ab5-56df-8609-421f6996bf16', '25883c0e-2e60-52b4-ad9e-de3ffce1e9d8', 'arabic', 'سبر تطبيقيّ: نصّ «العمل والكرامة»', 1, 50, 10, 'practice', 'admin', 1),
  ('718b8183-470f-54a1-9091-3bcbbcb0951d', '25883c0e-2e60-52b4-ad9e-de3ffce1e9d8', 'arabic', '⚔️ زعيم الفصل: سبر نصّ «شواغل العصر»', 3, 120, 30, 'boss', 'admin', 2),
  ('959e37bc-55d7-5ce4-8ca7-3704e4bbe571', '25883c0e-2e60-52b4-ad9e-de3ffce1e9d8', 'arabic', '👑 تحدّي النخبة: سبر نصّ «الفنون وتلاقح الثقافات»', 4, 300, 60, 'challenge', 'admin', 3),
  ('8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', 'Quiz: Know the exam paper', 1, 20, 5, 'quiz', 'admin', 0),
  ('426b680e-1a1c-5019-af64-72f7b81cc641', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', 'Paper 1: Practice — Family Life', 1, 50, 10, 'practice', 'admin', 1),
  ('d8e10e17-e701-5021-931b-4dcdbae61135', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', '⚔️ Paper 2: Boss — Health & the Environment', 3, 120, 30, 'boss', 'admin', 2),
  ('bf325094-b7d9-517c-a966-9e62838c6136', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', '👑 Challenge: Master the Exam Paper', 4, 300, 60, 'challenge', 'admin', 3),
  ('108a767e-ef6d-5ed7-ab54-f21275007d6b', 'e544d74c-e24f-5d7d-83af-3c29e0d74bc1', 'sciences-vie-terre', 'مراجعة شاملة: أحياء وجيولوجيا', 1, 20, 5, 'quiz', 'admin', 0),
  ('d0a4b9c1-9dc9-5933-90b6-0440e41cf134', 'e544d74c-e24f-5d7d-83af-3c29e0d74bc1', 'sciences-vie-terre', '📝 سبر تطبيقي: تحليل وثائق (أحياء وجيولوجيا)', 1, 50, 10, 'practice', 'admin', 1),
  ('f75aa5c8-b6f1-5b2a-a974-53c289576c9e', 'e544d74c-e24f-5d7d-83af-3c29e0d74bc1', 'sciences-vie-terre', '👹 سبر زعيم: تحليل معمّق واستنتاج', 3, 120, 30, 'boss', 'admin', 2),
  ('0487af90-2509-5724-a5e0-eb0262698181', 'e544d74c-e24f-5d7d-83af-3c29e0d74bc1', 'sciences-vie-terre', '🏆 تحدّي النخبة: سبر شامل وتركيب المفاهيم', 4, 300, 60, 'challenge', 'admin', 3)
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
  ('043b6c57-2efe-5f16-a63d-35c6a2219be7', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'احسب العدد $A = -2 + 3 \times (-4)$.', '[{"id":"a","text":"−14"},{"id":"b","text":"−20"},{"id":"c","text":"−10"},{"id":"d","text":"4"}]'::jsonb, 'a', 'نطبّق أولويّة العمليّات: الضرب قبل الجمع. $3 \times (-4) = -12$، ثمّ $A = -2 + (-12) = -14$. الخطأ الشائع: حساب $(-2+3)\times(-4) = -4$ بإهمال الأولويّة.', 1),
  ('8d480a2b-5fe3-5f4e-9fb7-2b7b02ff7b6c', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'حلّ المعادلة $3(x - 2) = 2x + 1$.', '[{"id":"a","text":"$x = 5$"},{"id":"b","text":"$x = 7$"},{"id":"c","text":"$x = -7$"},{"id":"d","text":"$x = 1$"}]'::jsonb, 'b', 'ننشر الطرف الأيسر: $3x - 6 = 2x + 1$. ننقل: $3x - 2x = 1 + 6$، أي $x = 7$. التحقّق: $3(7-2) = 15$ و$2(7)+1 = 15$ ✓.', 2),
  ('9b849ffc-3cac-5d7c-8784-162dc3b498e6', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'مثلّث قائم في B، ضلعاه القائمان AB = 6 cm وBC = 8 cm. ما طول الوتر AC؟', '[{"id":"a","text":"10 cm"},{"id":"b","text":"14 cm"},{"id":"c","text":"$\\sqrt{28}$ cm"},{"id":"d","text":"48 cm"}]'::jsonb, 'a', 'بنظرية فيثاغورس: $AC^2 = AB^2 + BC^2 = 6^2 + 8^2 = 36 + 64 = 100$. إذن $AC = \sqrt{100} = 10$ cm. الخطأ الشائع (b): جمع الضلعين مباشرةً $6+8$.', 3),
  ('72e21fb5-04f1-5caa-94a2-af01cf9b94ea', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'لتكن الدالّة الخطّية التآلفية $f(x) = 3x - 2$. ما صورة العدد 4 بهذه الدالّة، أي $f(4)$؟', '[{"id":"a","text":"10"},{"id":"b","text":"12"},{"id":"c","text":"5"},{"id":"d","text":"14"}]'::jsonb, 'a', 'نعوّض $x$ بـ 4: $f(4) = 3 \times 4 - 2 = 12 - 2 = 10$. الخطأ الشائع (b): نسيان طرح 2.', 4),
  ('db3b30fd-ee59-5c74-8500-eab1faf97ee4', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'انشر وبسّط العبارة $(2x - 3)^2$.', '[{"id":"a","text":"$4x^2 - 9$"},{"id":"b","text":"$4x^2 + 9$"},{"id":"c","text":"$4x^2 - 12x + 9$"},{"id":"d","text":"$2x^2 - 12x + 9$"}]'::jsonb, 'c', 'متطابقة شهيرة: $(a-b)^2 = a^2 - 2ab + b^2$ مع $a=2x$ و$b=3$. إذن $(2x)^2 - 2(2x)(3) + 3^2 = 4x^2 - 12x + 9$. الخطأ الشائع (a): نسيان الحدّ الأوسط $-12x$.', 5),
  ('1ff263b7-981a-5cfa-9768-a8a23b0804cd', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'في مثلّث ABC، M على [AB] وN على [AC] مع (MN) ∥ (BC). إذا كان AM = 4 cm، AB = 10 cm، BC = 15 cm، فما طول MN؟', '[{"id":"a","text":"6 cm"},{"id":"b","text":"9 cm"},{"id":"c","text":"5 cm"},{"id":"d","text":"7,5 cm"}]'::jsonb, 'a', 'بنظرية طاليس: $\frac{MN}{BC} = \frac{AM}{AB} = \frac{4}{10} = \frac{2}{5}$. إذن $MN = 15 \times \frac{2}{5} = 6$ cm. الخطأ الشائع (b): قلب النسبة وحساب $15 \times \frac{10}{4}$.', 6),
  ('d813920b-13bd-5a85-a676-7afb99359221', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'حصل تلميذ على الأعداد التالية في خمسة فروض: 4، 6، 8، 10، 12. ما المعدّل الحسابي لهذه الأعداد؟', '[{"id":"a","text":"8"},{"id":"b","text":"10"},{"id":"c","text":"40"},{"id":"d","text":"7"}]'::jsonb, 'a', 'المعدّل = مجموع القيم ÷ عددها. المجموع $= 4+6+8+10+12 = 40$، والعدد 5. إذن المعدّل $= \frac{40}{5} = 8$. الخطأ الشائع (c): إعطاء المجموع دون القسمة على العدد.', 7),
  ('d5c17bc9-c4cb-5704-993c-7d599dc2a1ec', '524341c8-b06e-56ea-8f79-09a4cf281ab8', 'مثلّث قائم في B، الزاوية في A قياسها x. الضلع المجاور لـ x هو AB = 5 cm والوتر AC = 10 cm. ما قياس الزاوية x؟', '[{"id":"a","text":"30°"},{"id":"b","text":"45°"},{"id":"c","text":"60°"},{"id":"d","text":"90°"}]'::jsonb, 'c', 'نستعمل جيب التمام: $\cos x = \frac{\text{المجاور}}{\text{الوتر}} = \frac{AB}{AC} = \frac{5}{10} = \frac{1}{2}$. ومن القيم المشهورة $\cos 60° = \frac{1}{2}$، إذن $x = 60°$. الخطأ الشائع (a): استعمال $\cos 30° = \frac{\sqrt3}{2}$.', 8),
  ('fd0ba843-88b7-5cc8-addd-5100a5eaa060', '192ab383-a349-5ce8-bef9-fc37ad988a0d', 'المسألة الأولى (هندسة): ABC مثلّث قائم في A حيث AB = 8 cm وAC = 6 cm.

السؤال (1): احسب طول الوتر BC.', '[{"id":"a","text":"10 cm"},{"id":"b","text":"14 cm"},{"id":"c","text":"$\\sqrt{28}$ cm"},{"id":"d","text":"7 cm"}]'::jsonb, 'a', 'بنظرية فيثاغورس في المثلّث القائم في A: $BC^2 = AB^2 + AC^2 = 8^2 + 6^2 = 64 + 36 = 100$، إذن $BC = \sqrt{100} = 10$ cm. الخطأ الشائع (b): جمع الضلعين $8+6$ مباشرةً.', 1),
  ('6a171843-375c-54bc-adea-4a43f742dd8f', '192ab383-a349-5ce8-bef9-fc37ad988a0d', 'المسألة الثانية (وضعية واقعية): اشترى تلميذ 3 كرّاسات وقلمَين بـ 13 دينارًا، واشترى زميله كرّاستَين وقلمَين بـ 10 دنانير. لِيكن $x$ ثمن الكرّاسة و$y$ ثمن القلم.

السؤال (1): ما الجملة التي تترجم الوضعية؟', '[{"id":"a","text":"$\\begin{cases} 3x + 2y = 13 \\\\ 2x + 2y = 10 \\end{cases}$"},{"id":"b","text":"$\\begin{cases} 3x + 2y = 10 \\\\ 2x + 2y = 13 \\end{cases}$"},{"id":"c","text":"$\\begin{cases} 3x + y = 13 \\\\ 2x + y = 10 \\end{cases}$"},{"id":"d","text":"$\\begin{cases} 2x + 3y = 13 \\\\ 2x + 2y = 10 \\end{cases}$"}]'::jsonb, 'a', '«3 كرّاسات وقلمَين بـ 13» تُترجَم $3x + 2y = 13$، و«كرّاستَين وقلمَين بـ 10» تُترجَم $2x + 2y = 10$. ننتبه لربط كلّ ثمن بالكمّيّة الصحيحة.', 2),
  ('bc0a3b8a-0181-52b8-b02b-c8cc4ddf2178', '192ab383-a349-5ce8-bef9-fc37ad988a0d', 'تابع المسألة الأولى: M نقطة من [AB] وN نقطة من [AC] بحيث (MN) ∥ (BC) وAM = 4 cm.

السؤال (2): احسب طول MN.', '[{"id":"a","text":"5 cm"},{"id":"b","text":"6 cm"},{"id":"c","text":"4 cm"},{"id":"d","text":"2,5 cm"}]'::jsonb, 'a', 'بما أنّ (MN) ∥ (BC) نطبّق نظرية طاليس: $\frac{MN}{BC} = \frac{AM}{AB} = \frac{4}{8} = \frac{1}{2}$. إذن $MN = BC \times \frac{1}{2} = 10 \times \frac{1}{2} = 5$ cm. (استثمرنا قيمة $BC=10$ من السؤال السابق.)', 3),
  ('95ac532b-ec09-5fc4-bbe7-c011f4cbc90e', '192ab383-a349-5ce8-bef9-fc37ad988a0d', 'تابع المسألة الأولى (نفس المعطيات: AM = 4 cm، (MN) ∥ (BC)).

السؤال (3): احسب طول AN.', '[{"id":"a","text":"3 cm"},{"id":"b","text":"2 cm"},{"id":"c","text":"4 cm"},{"id":"d","text":"4,5 cm"}]'::jsonb, 'a', 'بنظرية طاليس: $\frac{AN}{AC} = \frac{AM}{AB} = \frac{1}{2}$. إذن $AN = AC \times \frac{1}{2} = 6 \times \frac{1}{2} = 3$ cm. الخطأ الشائع: الخلط بين AN وMN.', 4),
  ('d9aa8d24-ae11-549c-a3d3-9ec44d001f8b', '192ab383-a349-5ce8-bef9-fc37ad988a0d', 'تابع المسألة الثانية: $\begin{cases} 3x + 2y = 13 \\ 2x + 2y = 10 \end{cases}$

السؤال (2): ما ثمن الكرّاسة الواحدة $x$؟', '[{"id":"a","text":"3 دنانير"},{"id":"b","text":"2 دينار"},{"id":"c","text":"4 دنانير"},{"id":"d","text":"5 دنانير"}]'::jsonb, 'a', 'نطرح المعادلة الثانية من الأولى: $(3x+2y)-(2x+2y) = 13-10$، إذن $x = 3$. ثمن الكرّاسة 3 دنانير. التحقّق يأتي في السؤال التالي.', 5),
  ('623424cd-8728-5bc3-a117-2876959bfe29', '192ab383-a349-5ce8-bef9-fc37ad988a0d', 'تابع المسألة الثانية (وجدنا $x = 3$).

السؤال (3): ما ثمن القلم الواحد $y$؟ (وتحقّق من النتيجتَين)', '[{"id":"a","text":"2 دينار"},{"id":"b","text":"3 دنانير"},{"id":"c","text":"1 دينار"},{"id":"d","text":"4 دنانير"}]'::jsonb, 'a', 'نعوّض $x=3$ في $2x + 2y = 10$: $6 + 2y = 10$، إذن $2y = 4$ و$y = 2$ دينار. التحقّق في المعادلة الأولى: $3(3) + 2(2) = 9 + 4 = 13$ ✓. إذن الكرّاسة بـ 3 دنانير والقلم بدينارَين.', 6),
  ('8138d5ed-04dd-53a0-9ed2-d74e856bec4c', '29558798-6563-5fdb-9042-5374b54145be', 'المسألة الأولى (هندسة مركّبة): ABC مثلّث قائم في B حيث AB = 9 cm وBC = 12 cm.

السؤال (1): احسب طول الوتر AC.', '[{"id":"a","text":"15 cm"},{"id":"b","text":"21 cm"},{"id":"c","text":"$\\sqrt{63}$ cm"},{"id":"d","text":"$\\sqrt{27}$ cm"}]'::jsonb, 'a', 'بنظرية فيثاغورس (الزاوية القائمة في B، فالوتر AC): $AC^2 = AB^2 + BC^2 = 9^2 + 12^2 = 81 + 144 = 225$، إذن $AC = \sqrt{225} = 15$ cm. الخطأ الشائع (b): جمع $9+12$.', 1),
  ('3b45cbd0-daf0-5a83-8c40-d1acd2064bd0', '29558798-6563-5fdb-9042-5374b54145be', 'تابع المسألة الأولى: M نقطة من [BA] وN نقطة من [BC] بحيث (MN) ∥ (AC) وBM = 3 cm.

السؤال (2): احسب طول MN.', '[{"id":"a","text":"5 cm"},{"id":"b","text":"4 cm"},{"id":"c","text":"6 cm"},{"id":"d","text":"7,5 cm"}]'::jsonb, 'a', 'بما أنّ (MN) ∥ (AC) نطبّق طاليس برأس B: $\frac{MN}{AC} = \frac{BM}{BA} = \frac{3}{9} = \frac{1}{3}$. إذن $MN = AC \times \frac{1}{3} = 15 \times \frac{1}{3} = 5$ cm. (استثمرنا $AC=15$ من السؤال 1.)', 2),
  ('d72cd3cc-bd7c-5d95-b6fd-d31c928a5193', '29558798-6563-5fdb-9042-5374b54145be', 'المسألة الثانية (وضعية واقعية): في حظيرة دجاجٌ وأرانب، عدد الرؤوس 35 وعدد الأرجل 94. للدجاجة رجلان وللأرنب أربع أرجل. لِيكن $c$ عدد الدجاج و$r$ عدد الأرانب.

السؤال (1): ما الجملة التي تترجم الوضعية؟', '[{"id":"a","text":"$\\begin{cases} c + r = 35 \\\\ 2c + 4r = 94 \\end{cases}$"},{"id":"b","text":"$\\begin{cases} c + r = 94 \\\\ 2c + 4r = 35 \\end{cases}$"},{"id":"c","text":"$\\begin{cases} c + r = 35 \\\\ 4c + 2r = 94 \\end{cases}$"},{"id":"d","text":"$\\begin{cases} 2c + 2r = 35 \\\\ 4c + 4r = 94 \\end{cases}$"}]'::jsonb, 'a', 'عدد الرؤوس = عدد الحيوانات: $c + r = 35$. عدد الأرجل: الدجاجة برجلين والأرنب بأربع، فـ $2c + 4r = 94$. الخطأ الشائع (c): عكس عدد أرجل الدجاج والأرانب.', 3),
  ('5957aff2-a935-52ae-8898-fa1ca57ce106', '29558798-6563-5fdb-9042-5374b54145be', 'المسألة الثالثة (حساب حرفي): بسّط العبارة $E = (x + 5)(x - 5) + 25$.', '[{"id":"a","text":"$x^2$"},{"id":"b","text":"$x^2 + 50$"},{"id":"c","text":"$x^2 - 50$"},{"id":"d","text":"$x^2 + 25$"}]'::jsonb, 'a', 'بالمتطابقة الشهيرة $(a-b)(a+b) = a^2 - b^2$ مع $a=x$، $b=5$: $(x+5)(x-5) = x^2 - 25$. إذن $E = x^2 - 25 + 25 = x^2$. الخطأ الشائع (b): اعتبار $(x+5)(x-5) = x^2 + 25$ بإهمال إشارة الناقص.', 4),
  ('c3bf5fa3-9bf5-56ad-817e-28fa667ad4aa', '29558798-6563-5fdb-9042-5374b54145be', 'تابع المسألة الأولى (المثلّث ABC قائم في B، AB = 9، BC = 12، AC = 15). نهتمّ بالزاوية $\widehat{A}$.

السؤال (3): احسب $\cos \widehat{A}$.', '[{"id":"a","text":"$\\frac{3}{5}$"},{"id":"b","text":"$\\frac{4}{5}$"},{"id":"c","text":"$\\frac{4}{3}$"},{"id":"d","text":"$\\frac{5}{3}$"}]'::jsonb, 'a', 'بالنسبة للزاوية $\widehat{A}$: الضلع المجاور هو AB والوتر هو AC. إذن $\cos \widehat{A} = \frac{\text{المجاور}}{\text{الوتر}} = \frac{AB}{AC} = \frac{9}{15} = \frac{3}{5}$. الخطأ الشائع (b): استعمال الضلع المقابل BC=12 بدل المجاور (وهذا هو $\sin\widehat{A}=\frac{12}{15}=\frac{4}{5}$).', 5),
  ('dee23524-04be-574e-91db-9cea702744cd', '29558798-6563-5fdb-9042-5374b54145be', 'تابع المسألة الثانية: $\begin{cases} c + r = 35 \\ 2c + 4r = 94 \end{cases}$

السؤال (2): كم عدد الأرانب $r$؟ (مع التحقّق)', '[{"id":"a","text":"12 أرنبًا"},{"id":"b","text":"23 أرنبًا"},{"id":"c","text":"10 أرانب"},{"id":"d","text":"15 أرنبًا"}]'::jsonb, 'a', 'من المعادلة الأولى $c = 35 - r$. نعوّض في الثانية: $2(35 - r) + 4r = 94$، أي $70 - 2r + 4r = 94$، فـ $2r = 24$ ومنه $r = 12$ أرنبًا (وعدد الدجاج $c = 35 - 12 = 23$). التحقّق بالأرجل: $2(23) + 4(12) = 46 + 48 = 94$ ✓.', 6),
  ('646a87b5-809b-5756-84bc-739528107bb8', '377d74ea-0e11-5a70-9f62-2b390afb7c31', 'المسألة الأولى (هندسة نخبويّة): ABC مثلّث قائم في A حيث AB = 6 cm وAC = $6\sqrt{3}$ cm.

السؤال (1): احسب طول الوتر BC.', '[{"id":"a","text":"12 cm"},{"id":"b","text":"$6\\sqrt{2}$ cm"},{"id":"c","text":"$12\\sqrt{3}$ cm"},{"id":"d","text":"18 cm"}]'::jsonb, 'a', 'بنظرية فيثاغورس: $BC^2 = AB^2 + AC^2 = 6^2 + (6\sqrt{3})^2 = 36 + 36 \times 3 = 36 + 108 = 144$. إذن $BC = \sqrt{144} = 12$ cm. الانتباه: $(6\sqrt3)^2 = 36 \times 3 = 108$ وليس $108\sqrt3$.', 1),
  ('29c1af86-32e0-5a01-ac46-29295c0b7232', '377d74ea-0e11-5a70-9f62-2b390afb7c31', 'المسألة الثانية (وضعية واقعية): عمر الأب اليوم يساوي ثلاثة أمثال عمر ابنه. بعد 10 سنوات سيصبح عمر الأب ضعفَ عمر ابنه. لِيكن $f$ عمر الأب و$s$ عمر الابن اليوم.

السؤال (1): ما الجملة التي تترجم الوضعية؟', '[{"id":"a","text":"$\\begin{cases} f = 3s \\\\ f + 10 = 2(s + 10) \\end{cases}$"},{"id":"b","text":"$\\begin{cases} f = 3s \\\\ f + 10 = 2s + 10 \\end{cases}$"},{"id":"c","text":"$\\begin{cases} s = 3f \\\\ s + 10 = 2(f + 10) \\end{cases}$"},{"id":"d","text":"$\\begin{cases} f = 3s \\\\ 2f + 10 = s + 10 \\end{cases}$"}]'::jsonb, 'a', '«عمر الأب ثلاثة أمثال عمر الابن» ← $f = 3s$. «بعد 10 سنوات»: عمر الأب $f+10$ وعمر الابن $s+10$، و«الأب ضعف الابن» ← $f + 10 = 2(s + 10)$. الخطأ الشائع (b): نسيان توزيع 2 على $(s+10)$.', 2),
  ('44bd5381-d4a8-5be1-b2a6-ff072c863d6a', '377d74ea-0e11-5a70-9f62-2b390afb7c31', 'تابع المسألة الأولى (AB = 6، AC = $6\sqrt3$، BC = 12). نهتمّ بالزاوية $\widehat{B}$.

السؤال (2): استنتج قياس الزاوية $\widehat{B}$.', '[{"id":"a","text":"60°"},{"id":"b","text":"30°"},{"id":"c","text":"45°"},{"id":"d","text":"90°"}]'::jsonb, 'a', 'بالنسبة للزاوية $\widehat{B}$: المقابل هو AC والمجاور هو AB. إذن $\tan \widehat{B} = \frac{\text{المقابل}}{\text{المجاور}} = \frac{AC}{AB} = \frac{6\sqrt3}{6} = \sqrt3$. ومن القيم المشهورة $\tan 60° = \sqrt3$، إذن $\widehat{B} = 60°$. (يمكن أيضًا: $\cos\widehat{B} = \frac{AB}{BC} = \frac{6}{12} = \frac12 \Rightarrow \widehat{B}=60°$.)', 3),
  ('ccc803c5-cc4f-5ac1-9595-d8898996194b', '377d74ea-0e11-5a70-9f62-2b390afb7c31', 'تابع المسألة الأولى: M نقطة من [AB] حيث AM = 2 cm، وN نقطة من [AC] حيث AN = $2\sqrt3$ cm.

السؤال (3): هل (MN) ∥ (BC)؟', '[{"id":"a","text":"نعم، لأنّ $\\frac{AM}{AB} = \\frac{AN}{AC} = \\frac{1}{3}$"},{"id":"b","text":"لا، لأنّ $AM \\neq AN$"},{"id":"c","text":"نعم، لأنّ المثلّث قائم في A"},{"id":"d","text":"لا، لأنّ $\\frac{AM}{AB} \\neq \\frac{AN}{AC}$"}]'::jsonb, 'a', 'نحسب النسبتَين: $\frac{AM}{AB} = \frac{2}{6} = \frac{1}{3}$، و$\frac{AN}{AC} = \frac{2\sqrt3}{6\sqrt3} = \frac{2}{6} = \frac{1}{3}$ (نختصر $\sqrt3$). النسبتان متساويتان وM، N في نفس الجانب من A، إذن بالنظرية العكسية لطاليس $(MN) \parallel (BC)$. الخطأ الشائع (b): مقارنة الطولين بدل النسبتَين.', 4),
  ('921c7574-54f6-5507-94df-8842f8c3f864', '377d74ea-0e11-5a70-9f62-2b390afb7c31', 'تابع المسألة الثانية: $\begin{cases} f = 3s \\ f + 10 = 2(s + 10) \end{cases}$

السؤال (2): ما عمر الابن اليوم $s$؟ (مع التحقّق)', '[{"id":"a","text":"10 سنوات"},{"id":"b","text":"8 سنوات"},{"id":"c","text":"15 سنة"},{"id":"d","text":"12 سنة"}]'::jsonb, 'a', 'نعوّض $f = 3s$ في المعادلة الثانية: $3s + 10 = 2(s + 10) = 2s + 20$. ننقل: $3s - 2s = 20 - 10$، إذن $s = 10$ سنوات (وعمر الأب $f = 3 \times 10 = 30$ سنة). التحقّق: بعد 10 سنوات الأب 40 والابن 20، و$40 = 2 \times 20$ ✓.', 5),
  ('a997509e-0437-51bc-b63e-c9e905aef586', '377d74ea-0e11-5a70-9f62-2b390afb7c31', 'المسألة الثالثة (دالّة ومعادلة): سيّارة أجرة تأخذ 2 دينار عند الانطلاق ثمّ 0,5 دينار لكلّ كيلومتر. الثمن بالدينار حسب المسافة $x$ بالكيلومترات هو $f(x) = 0{,}5x + 2$.

السؤال: إذا دفع راكب 16 دينارًا، فما المسافة التي قطعها؟', '[{"id":"a","text":"28 كم"},{"id":"b","text":"32 كم"},{"id":"c","text":"36 كم"},{"id":"d","text":"14 كم"}]'::jsonb, 'a', 'نحلّ المعادلة $f(x) = 16$، أي $0{,}5x + 2 = 16$. ننقل: $0{,}5x = 14$، ثمّ نقسم على $0{,}5$ (أو نضرب في 2): $x = 14 \div 0{,}5 = 28$ كم. التحقّق: $0{,}5 \times 28 + 2 = 14 + 2 = 16$ ✓. الخطأ الشائع (d): نسيان القسمة على $0{,}5$ والاكتفاء بـ $x=14$.', 6),
  ('8454304f-896c-57e2-9d6c-9404795453d2', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Dans l''épreuve de français de fin d''études de base, sur quoi reposent les questions de compréhension, de langue et de production ?', '[{"id":"a","text":"Sur trois textes différents, un par partie."},{"id":"b","text":"Sur un même texte support, lu au début de l''épreuve."},{"id":"c","text":"Sur les souvenirs personnels de l''élève."},{"id":"d","text":"Sur une liste de règles de grammaire sans texte."}]'::jsonb, 'b', 'L''épreuve s''organise autour d''UN texte support : compréhension, langue et production écrite portent sur ce texte. (a) est faux : il n''y a qu''un texte. (c) : on doit s''appuyer sur le texte, pas sur des souvenirs. (d) : la langue est testée à partir de phrases du texte, pas hors contexte.', 1),
  ('7e701876-a9d1-514d-848b-7567488fc2d4', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Combien de fois est-il conseillé de lire le texte avant de répondre aux questions ?', '[{"id":"a","text":"Une seule fois, en diagonale."},{"id":"b","text":"Deux fois : une lecture globale, puis une lecture crayon en main."},{"id":"c","text":"Jamais : il faut lire directement les questions."},{"id":"d","text":"Cinq fois au minimum, mot à mot."}]'::jsonb, 'b', 'On lit deux fois : d''abord pour saisir le sens global, puis crayon en main pour repérer type de texte, idée directrice, connecteurs et mots difficiles. (a) : la diagonale fait manquer les indices. (c) : sans lire le texte, on répond au hasard. (d) : cinq lectures complètes feraient perdre un temps précieux.', 2),
  ('3d0f128d-cdce-5d9d-997c-047d2da2e2bc', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Pourquoi est-il important de garder environ un tiers du temps pour la production écrite ?', '[{"id":"a","text":"Parce que la production écrite ne compte presque rien dans la note."},{"id":"b","text":"Parce qu''il faut planifier, rédiger ET relire, ce qui demande du temps."},{"id":"c","text":"Parce qu''il faut absolument finir avant tout le monde."},{"id":"d","text":"Parce que la compréhension ne demande aucune réflexion."}]'::jsonb, 'b', 'La production écrite pèse lourd et exige un plan, une rédaction soignée et une relecture (orthographe, conjugaison, cohérence) : il faut donc lui réserver assez de temps. (a) est faux : elle représente une grande part de la note. (c) : la vitesse n''est pas un but en soi. (d) : la compréhension demande au contraire de la réflexion.', 3),
  ('c6e0e1ee-d878-5008-8460-52fdbcdb11a2', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Que signifie « inférer » dans une question de compréhension ?', '[{"id":"a","text":"Recopier mot pour mot une phrase du texte."},{"id":"b","text":"Inventer une information qui n''a aucun lien avec le texte."},{"id":"c","text":"Déduire une information non écrite à partir d''indices du texte."},{"id":"d","text":"Traduire le texte dans une autre langue."}]'::jsonb, 'c', 'Inférer, c''est déduire ce qui n''est pas écrit noir sur blanc, mais que les indices du texte permettent de comprendre. (a) décrit le simple relevé explicite, pas l''inférence. (b) : inférer n''est jamais inventer librement. (d) n''a aucun rapport avec la compréhension.', 4),
  ('9d520596-be86-5bf9-9986-236f642e3ee5', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Quel élément introduit le complément d''agent dans une phrase à la voix passive ?', '[{"id":"a","text":"La préposition « par » (ou parfois « de »)."},{"id":"b","text":"Le pronom relatif « qui »."},{"id":"c","text":"La conjonction « parce que »."},{"id":"d","text":"L''article défini « le »."}]'::jsonb, 'a', 'À la voix passive, le complément d''agent (celui qui fait l''action) est introduit par « par » (« mangé par le chat ») ou parfois « de » (« aimé de tous »). (b) introduit une subordonnée relative. (c) introduit une cause. (d) est un simple article, sans rôle d''agent.', 5),
  ('3861e039-b9dc-5a7f-a1f7-4ade27282a2c', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Dans un récit, quelle opposition de temps est la plus fréquente entre le décor (l''arrière-plan) et les actions principales (le premier plan) ?', '[{"id":"a","text":"Présent pour le décor, futur pour les actions."},{"id":"b","text":"Imparfait pour le décor, passé simple pour les actions."},{"id":"c","text":"Conditionnel pour le décor, impératif pour les actions."},{"id":"d","text":"Futur pour le décor, présent pour les actions."}]'::jsonb, 'b', 'Dans le récit au passé, l''imparfait pose le décor et la durée (« il faisait nuit »), tandis que le passé simple marque les actions soudaines de premier plan (« il entra »). (a), (c) et (d) associent des temps qui ne correspondent pas à ce rôle dans le récit classique.', 6),
  ('11b23003-7011-5d40-98b3-7061425c7315', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Quel est le rôle de la phrase d''amorce au début d''une production écrite ?', '[{"id":"a","text":"Donner directement la conclusion du devoir."},{"id":"b","text":"Introduire le sujet sans le traiter, pour amener l''idée."},{"id":"c","text":"Énumérer tous les arguments du développement."},{"id":"d","text":"Corriger les fautes d''orthographe du texte."}]'::jsonb, 'b', 'L''amorce est la première phrase qui présente le sujet (un constat, une question, un fait frappant) sans le traiter encore : elle prépare la thèse. (a) : la conclusion vient à la fin. (c) : les arguments se développent ensuite, paragraphe par paragraphe. (d) n''est pas le rôle d''une amorce.', 7),
  ('69d3b8fa-3457-5297-82c9-f50c644c0a4e', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Lisez cette phrase au discours direct :

« Le professeur dit : “Vous avez bien travaillé.” »

Quelle est la transposition correcte au discours indirect ?', '[{"id":"a","text":"Le professeur dit qu''ils avaient bien travaillé."},{"id":"b","text":"Le professeur dit : ils ont bien travaillé."},{"id":"c","text":"Le professeur dit qu''avez-vous bien travaillé ?"},{"id":"d","text":"Le professeur dit vous avez bien travaillé."}]'::jsonb, 'a', 'Au discours indirect, on supprime les guillemets, on introduit par « que », et on adapte le pronom (« vous » → « ils ») et le temps (« avez travaillé » → « avaient travaillé ») : « qu''ils avaient bien travaillé ». (b) garde une ponctuation de discours direct. (c) introduit une question inexistante. (d) oublie le subordonnant « que » et l''accord des pronoms.', 8),
  ('d561c284-fe77-5304-8add-50b795fa84bc', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Quel est le type dominant de ce texte ?', '[{"id":"a","text":"Argumentatif : il défend une opinion sur la vie au village."},{"id":"b","text":"Narratif : il raconte une suite d''actions situées dans le temps."},{"id":"c","text":"Informatif : il explique le fonctionnement d''un autocar."},{"id":"d","text":"Injonctif : il donne des ordres au lecteur."}]'::jsonb, 'b', 'Le texte raconte des actions qui se suivent (l''autocar s''arrêta, Karim descendit, marcha…) avec un personnage et un cadre : c''est narratif. (a) : aucune thèse n''est défendue. (c) : rien n''explique le fonctionnement d''un autocar. (d) : il n''y a aucun ordre adressé au lecteur.', 1),
  ('e00b002a-d567-56b1-b788-173342c1ee53', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Quel sentiment éprouve Karim en arrivant au village ?', '[{"id":"a","text":"De l''indifférence : le village ne lui inspire rien."},{"id":"b","text":"De la peur d''être perdu dans un lieu inconnu."},{"id":"c","text":"Une émotion forte, faite d''attachement et d''impatience."},{"id":"d","text":"De la colère contre sa grand-mère."}]'::jsonb, 'c', '« Le cœur battant » et le fait qu''il remarque avec tendresse que « rien n''avait changé » traduisent un attachement ému et l''impatience de retrouver les lieux. (a) est contredit par l''émotion décrite. (b) : le village ne lui est pas inconnu, « rien n''avait changé ». (d) : aucune trace de colère, il marche vers sa grand-mère avec émotion.', 2),
  ('004290f5-18df-5e0f-9504-ef5bc050a921', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Dans la phrase « le vieux figuier veillait toujours sur la place », quelle est la valeur de l''imparfait ?', '[{"id":"a","text":"Il décrit l''arrière-plan, un état qui dure dans le passé."},{"id":"b","text":"Il exprime une action brève et soudaine de premier plan."},{"id":"c","text":"Il indique une action qui se passera dans le futur."},{"id":"d","text":"Il donne un ordre au lecteur."}]'::jsonb, 'a', '« Veillait » est à l''imparfait : il peint le décor et un état qui dure (le figuier est toujours là), c''est l''arrière-plan du récit. (b) : l''action brève de premier plan serait au passé simple, comme « descendit ». (c) : l''imparfait est un temps du passé, pas du futur. (d) : ce n''est pas un impératif.', 3),
  ('0bb3b44d-55e9-58ca-885b-33843190e4c5', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Dans « le cœur battant », quel est le sens de l''expression ?', '[{"id":"a","text":"Karim est malade du cœur."},{"id":"b","text":"Karim ressent une forte émotion (joie, impatience)."},{"id":"c","text":"Karim entend des tambours dans le village."},{"id":"d","text":"Karim a très froid au village."}]'::jsonb, 'b', '« Le cœur battant » est une expression imagée qui désigne l''émotion : le cœur s''accélère sous le coup de l''impatience ou de la joie. Le contexte (retour attendu, « rien n''avait changé ») le confirme. (a) prend l''expression au sens propre médical, à tort. (c) et (d) n''ont aucun rapport avec le sens de l''expression.', 4),
  ('91ed9dac-19cb-5076-a268-295420d3a3e8', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Vous devez raconter la suite de cette scène (Karim retrouve sa grand-mère). Quelle phrase d''amorce convient le mieux pour commencer votre paragraphe de récit ?', '[{"id":"a","text":"En conclusion, Karim était très heureux de ce voyage."},{"id":"b","text":"Devant la porte bleue, Karim s''arrêta un instant, le souffle court."},{"id":"c","text":"Le figuier est un arbre qui pousse en région méditerranéenne."},{"id":"d","text":"Je pense qu''il faut visiter sa famille plus souvent."}]'::jsonb, 'b', 'Pour continuer un récit, l''amorce doit relancer l''action dans le même registre narratif : (b) plante le décor et le geste du personnage, et amène la rencontre. (a) est une formule de conclusion, pas un début. (c) est une information encyclopédique hors récit. (d) bascule dans l''argumentatif (« je pense que »), hors sujet pour un récit.', 5),
  ('feb5008a-c62f-50e4-96c1-ef21827d5d14', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Quelle est la transformation correcte de la phrase « Karim descendit le premier » à la voix passive ?', '[{"id":"a","text":"Le premier fut descendu par Karim."},{"id":"b","text":"Cette phrase ne peut pas se mettre à la voix passive."},{"id":"c","text":"Karim était descendu le premier."},{"id":"d","text":"Le premier descendait Karim."}]'::jsonb, 'b', '« Descendre » est ici intransitif : « le premier » n''est pas un complément d''objet direct mais un attribut, donc la phrase n''a pas de voix passive. (a) et (d) inventent un COD qui n''existe pas et produisent un non-sens. (c) n''est pas une voix passive mais un simple changement de temps (plus-que-parfait).', 6),
  ('68e457c7-1d2e-5612-b531-d79d2acf9d4d', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Quelle est l''idée directrice de ce texte ?', '[{"id":"a","text":"L''eau douce est très abondante sur la planète."},{"id":"b","text":"Le gaspillage de l''eau ne peut pas être évité."},{"id":"c","text":"L''eau douce est rare et gaspillée, mais des gestes simples permettent de l''économiser."},{"id":"d","text":"Il faut interdire totalement l''usage de l''eau."}]'::jsonb, 'c', 'Le texte enchaîne trois idées : l''eau douce est rare (« une très petite partie »), elle est gaspillée, et des gestes simples permettent de l''économiser : c''est l''idée directrice. (a) contredit « une très petite partie ». (b) est contredit par « des gestes simples suffisent ». (d) exagère : le texte parle d''économie, pas d''interdiction.', 1),
  ('f36ef462-d7e1-59ac-a84b-4393c5c8ccda', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Quel est le rôle du connecteur « Pourtant » au début de la deuxième phrase ?', '[{"id":"a","text":"Il ajoute une idée de même sens que la précédente."},{"id":"b","text":"Il marque une opposition entre la rareté de l''eau et son gaspillage."},{"id":"c","text":"Il exprime la cause de la première phrase."},{"id":"d","text":"Il introduit un exemple chiffré."}]'::jsonb, 'b', '« Pourtant » oppose deux idées contradictoires : l''eau est rare, et POURTANT on la gaspille. (a) confondrait avec une addition (« de plus »). (c) serait « car » ou « parce que ». (d) : l''exemple chiffré (« des milliers de litres ») vient plus loin et n''est pas introduit par « pourtant ».', 2),
  ('62e98c7b-be98-5da5-8c08-91d360b2614e', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Dans ce contexte, quel est le sens du mot « préservés » ?', '[{"id":"a","text":"Gaspillés, perdus inutilement."},{"id":"b","text":"Protégés, économisés, donc non perdus."},{"id":"c","text":"Vendus à un prix élevé."},{"id":"d","text":"Salis, rendus impropres à la consommation."}]'::jsonb, 'b', '« Préservés » s''oppose ici à « gaspillés » et « perdus » du début : ces litres seraient sauvegardés, économisés. Le contexte (« économiser cette ressource ») le confirme. (a) dit l''inverse exact. (c) introduit une idée de vente absente. (d) confond avec « pollués », ce que le texte ne dit pas.', 3),
  ('820ea5b8-ff8b-55ea-8289-b9b0b85999b6', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Dans la phrase « des cultures sont mal arrosées », à quelle voix est le verbe, et quelle serait la phrase à la voix active ?', '[{"id":"a","text":"Voix passive ; à l''actif : « on arrose mal des cultures »."},{"id":"b","text":"Voix active ; elle ne peut pas devenir passive."},{"id":"c","text":"Voix passive ; à l''actif : « des cultures arrosent mal »."},{"id":"d","text":"Voix active ; à l''actif : « des cultures sont arrosées »."}]'::jsonb, 'a', '« sont arrosées » (auxiliaire être + participe passé) est une voix passive sans complément d''agent exprimé ; à l''actif, on rétablit un sujet indéfini : « on arrose mal des cultures ». (b) est faux : la phrase EST déjà passive. (c) inverse le sens (les cultures n''arrosent pas). (d) répète une forme passive en la présentant à tort comme active.', 4),
  ('de91684c-3e02-5bff-8675-478d9fd09ccf', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Dans « Si chacun fermait le robinet…, des milliers de litres seraient préservés », quel rapport logique exprime la subordonnée introduite par « Si » ?', '[{"id":"a","text":"Une cause déjà réalisée dans le passé."},{"id":"b","text":"Une hypothèse (condition) dont dépend la conséquence."},{"id":"c","text":"Un but à atteindre absolument."},{"id":"d","text":"Une simple comparaison entre deux quantités."}]'::jsonb, 'b', '« Si chacun fermait… » + conditionnel « seraient préservés » exprime une hypothèse : une condition imaginée et sa conséquence probable. (a) : ce n''est pas une cause réelle passée. (c) : le but s''introduirait par « afin que / pour que ». (d) : aucune comparaison n''est faite, mais une condition.', 5),
  ('afa723fa-bea9-571b-a885-97d7cef1e780', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Vous rédigez un court texte pour convaincre vos camarades d''économiser l''eau. Vous disposez de trois phrases :

1) Par exemple, fermer le robinet en se brossant les dents économise des litres d''eau.
2) Il est donc urgent d''adopter des gestes simples au quotidien.
3) L''eau douce est une ressource rare qu''il faut protéger.

Quel est le bon ordre logique du paragraphe ?', '[{"id":"a","text":"3 puis 1 puis 2"},{"id":"b","text":"1 puis 2 puis 3"},{"id":"c","text":"2 puis 3 puis 1"},{"id":"d","text":"1 puis 3 puis 2"}]'::jsonb, 'a', 'On annonce d''abord l''idée (3 : l''eau est rare), on l''illustre par un exemple (1 : « Par exemple… »), puis on conclut avec « donc » (2) : l''ordre 3-1-2 respecte annoncer → illustrer → conclure. Les autres ordres placent l''exemple (« Par exemple ») ou la conclusion (« donc ») avant l''idée annoncée, ce qui rompt la logique.', 6),
  ('a1919ea5-25b0-53d3-86b7-f818b632d084', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Quelle est la thèse défendue par l''auteur ?', '[{"id":"a","text":"Le livre papier est condamné à disparaître à cause des écrans."},{"id":"b","text":"Le livre papier garde toute sa valeur et coexiste avec le numérique."},{"id":"c","text":"Il faut interdire les livres numériques."},{"id":"d","text":"Les écrans sont toujours meilleurs que le papier."}]'::jsonb, 'b', 'La conclusion l''énonce clairement : le papier « n''est donc pas un objet du passé » et reste « à côté du numérique, un compagnon fidèle » : il garde sa valeur et coexiste avec le numérique. (a) est l''opinion que l''auteur réfute (« C''est aller un peu vite »). (c) propose une interdiction absente du texte. (d) renverse la thèse en dévalorisant le papier.', 1),
  ('a1faf598-b829-53af-92cf-50f1ecdd875f', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Dans la dernière phrase, l''expression « un compagnon fidèle de la lecture » est employée au sens figuré. Que veut dire l''auteur ?', '[{"id":"a","text":"Le livre est une personne qui accompagne réellement le lecteur."},{"id":"b","text":"Le livre reste un objet précieux et constant, qui ne déçoit pas le lecteur."},{"id":"c","text":"Le livre est un animal domestique."},{"id":"d","text":"Le livre trahit souvent ceux qui le lisent."}]'::jsonb, 'b', '« Compagnon fidèle » est une métaphore : le livre est présenté comme un objet précieux, constant, sur lequel on peut compter (il ne tombe pas en panne de batterie). (a) prend l''image au sens propre (le livre n''est pas une personne). (c) confond avec un animal de compagnie. (d) dit l''inverse de « fidèle ».', 2),
  ('e70e2c64-52ce-5e05-9fd2-3ddb7237d2ad', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Quel est le rôle de la phrase « Certains pensent que le livre papier va bientôt disparaître » dans l''argumentation ?', '[{"id":"a","text":"C''est la thèse personnelle de l''auteur."},{"id":"b","text":"C''est le contre-argument (la thèse adverse) que l''auteur va réfuter."},{"id":"c","text":"C''est un simple exemple chiffré."},{"id":"d","text":"C''est la conclusion du texte."}]'::jsonb, 'b', 'L''auteur présente d''abord l''opinion adverse (« Certains pensent que… »), aussitôt rejetée par « C''est aller un peu vite » : c''est le contre-argument qu''il réfute. (a) est faux : c''est l''avis des autres, pas le sien. (c) : ce n''est pas un exemple chiffré. (d) : la conclusion arrive à la fin (« il reste… un compagnon fidèle »).', 3),
  ('d1be344e-f76b-520e-b29a-16a7eeca0cda', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

La phrase au discours direct est : « Je garde encore les romans de mon père », confiait une lectrice. Quelle est sa transposition correcte au discours indirect ?', '[{"id":"a","text":"Une lectrice confiait qu''elle gardait encore les romans de son père."},{"id":"b","text":"Une lectrice confiait que je garde encore les romans de mon père."},{"id":"c","text":"Une lectrice confiait : elle gardait encore les romans de son père."},{"id":"d","text":"Une lectrice confiait qu''est-ce que je garde les romans de mon père ?"}]'::jsonb, 'a', 'Au discours indirect, on supprime les guillemets, on introduit par « que », et on adapte pronoms et temps : « je garde » → « elle gardait », « mon père » → « son père ». (b) garde les pronoms de la 1re personne, incohérents. (c) garde une ponctuation de discours direct (les deux-points). (d) transforme à tort l''énoncé en question.', 4),
  ('8dd987cc-488a-5181-95cc-a03f05f04878', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Dans « il se transmet d''une génération à l''autre », quelle est la nature de la proposition « qui ne s''éteint jamais faute de batterie » si on l''ajoutait après « Un livre » ?', '[{"id":"a","text":"Une proposition subordonnée relative, complément du nom « livre »."},{"id":"b","text":"Une proposition subordonnée circonstancielle de but."},{"id":"c","text":"Une proposition indépendante coordonnée."},{"id":"d","text":"Une proposition subordonnée complétive, COD du verbe."}]'::jsonb, 'a', 'Introduite par le pronom relatif « qui » et précisant le nom « livre » qui la précède, « qui ne s''éteint jamais… » est une subordonnée relative (complément de l''antécédent « livre »). (b) : une circonstancielle de but commencerait par « pour que / afin que ». (c) : une relative n''est pas indépendante, elle dépend d''un antécédent. (d) : une complétive COD serait introduite par « que » après un verbe (ex. « il dit que… »).', 5),
  ('63895d39-b503-5006-ad86-24e4f220feef', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Vous voulez réfuter le contre-argument « le livre papier prend trop de place ». Quelle phrase réfute correctement ce contre-argument ?', '[{"id":"a","text":"Certes, un livre occupe de l''espace ; mais une bibliothèque se range et se partage facilement."},{"id":"b","text":"C''est vrai, les livres prennent vraiment trop de place chez soi."},{"id":"c","text":"Par exemple, les écrans prennent eux aussi de la place."},{"id":"d","text":"De plus, les livres encombrent énormément les maisons."}]'::jsonb, 'a', 'Réfuter, c''est concéder (« Certes… ») puis dépasser l''objection (« mais… ») : (a) reconnaît que le livre occupe de l''espace, puis montre que ce n''est pas un vrai problème. (b) ne fait que répéter et valider le contre-argument. (c) change de sujet (les écrans) sans réfuter. (d) renforce encore l''objection avec « De plus ».', 6),
  ('130eefd4-7342-5f39-868e-36722389f6a4', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«العملُ عمادُ الحياة وسرُّ تقدّم الأمم؛ فبه تُعمَّر الأرض، وتُبنى المصانع، وتُصان كرامةُ الإنسان عن ذلّ السؤال. وما تأخّرت أمّةٌ إلّا حين ركن أبناؤها إلى الكسل.»

ما الفكرة العامة للنصّ؟', '[{"id":"a","text":"العملُ أساسُ عمران الحياة وتقدّم الأمم وصونِ كرامة الإنسان"},{"id":"b","text":"العاملُ يكسب قوته كلّ يوم"},{"id":"c","text":"المصانعُ تُبنى بسواعد العمّال"},{"id":"d","text":"الكسلُ صفةٌ ذميمة في بعض الناس"}]'::jsonb, 'a', 'الفكرة العامة جملةٌ جامعة تلمّ شتات النصّ: تمجيدُ العمل بوصفه عماد الحياة وسبب التقدّم وصون الكرامة، وهو ما يصوغه (a). أمّا (b) و(c) فتفصيلان جزئيّان وردا في سطر، و(d) إشارةٌ عابرة في الخاتمة لا محور النصّ.', 1),
  ('66fc77f0-edac-50ef-9df9-ebac33a09a29', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«أثبتت المرأةُ التونسيّة جدارتها في كلّ ميدان؛ فهي الطبيبةُ والمهندسةُ والمعلّمةُ، وهي ركيزةُ الأسرة وعمادُ المجتمع.»

ما نمط هذا النصّ؟', '[{"id":"a","text":"حجاجيّ: يدافع عن أطروحة جدارة المرأة بالحجج"},{"id":"b","text":"سرديّ: يحكي أحداثًا متسلسلة"},{"id":"c","text":"وصفيّ: يرسم صورةً حسّية لمشهد"},{"id":"d","text":"تفسيريّ: يشرح ظاهرةً علميّة بالأرقام"}]'::jsonb, 'a', 'النصّ يطرح أطروحةً («أثبتت المرأة جدارتها») ويدعمها بأدلّةٍ (الطبيبة، المهندسة، المعلّمة) ليُقنع القارئ؛ وهذا هو النمط الحجاجيّ. فلا أحداث متسلسلة (b)، ولا تكديس نعوتٍ لمشهد حسّيّ (c)، ولا شرح ظاهرةٍ بالأرقام (d).', 2),
  ('72218b38-01d2-5165-9d7b-ea4599a32855', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«جاء الربيعُ، فاخضرّت الحقولُ، وتفتّحت الأزهارُ.»

ما إعراب كلمة «الربيعُ»؟', '[{"id":"a","text":"فاعل مرفوع وعلامة رفعه الضمّة"},{"id":"b","text":"مفعول به منصوب بالفتحة"},{"id":"c","text":"مبتدأ مرفوع بالضمّة"},{"id":"d","text":"مضاف إليه مجرور بالكسرة"}]'::jsonb, 'a', '«الربيعُ» هو مَن وقع منه فعلُ المجيء «جاء»، فهو فاعل مرفوع وعلامة رفعه الضمّة الظاهرة. وليس مفعولًا به (b) لأنّ الفعل لازم لم يقع على شيء، وليس مبتدأ (c) لأنّ الجملة فعليّة بدأت بفعل، وليس مضافًا إليه (d) إذ لم يسبقه مضاف.', 3),
  ('cbbe2f0d-c671-5175-8384-8aad7fdece97', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«إنّ الفنونَ غذاءُ الروح؛ فالموسيقى تُهذّب الوجدان، والرسمُ يصقل الذوق، والشعرُ يُرهف الإحساس.»

ما اسم «إنّ» في الجملة وما حكمه؟', '[{"id":"a","text":"«الفنونَ» اسم إنّ منصوب وعلامة نصبه الفتحة"},{"id":"b","text":"«الفنونَ» خبر إنّ مرفوع بالضمّة"},{"id":"c","text":"«غذاءُ» اسم إنّ مرفوع بالضمّة"},{"id":"d","text":"«الفنونَ» فاعل مرفوع بالضمّة"}]'::jsonb, 'a', '«إنّ» من الحروف الناسخة، تنصب الاسم وترفع الخبر. فـ«الفنونَ» اسمها منصوب بالفتحة، و«غذاءُ» خبرها مرفوع بالضمّة. فـ(b) و(c) عكسا الموقعين، و(d) أخطأ إذ لا فاعل بعد الحرف الناسخ بل اسمٌ منصوب.', 4),
  ('3d5406c3-70a6-5ffc-867b-509ea0fd6604', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«المهندسُ النبيهُ يرسم خرائطَ دقيقةً قبل أن يشيّد بنيانًا متينًا.»

ما نوع كلمة «النبيهُ» من حيث الاشتقاق؟', '[{"id":"a","text":"صفة مشبّهة باسم الفاعل تدلّ على ثبوت الصفة"},{"id":"b","text":"اسم مفعول يدلّ على من وقع عليه الفعل"},{"id":"c","text":"اسم تفضيل يدلّ على المفاضلة"},{"id":"d","text":"اسم مكان يدلّ على موضع الحدث"}]'::jsonb, 'a', '«النبيه» على وزن «فعيل» من فعلٍ لازم (نَبُهَ)، يدلّ على صفةٍ ثابتةٍ لازمة في صاحبها، فهو صفة مشبّهة باسم الفاعل. وليس اسم مفعول (b) إذ لم يقع عليه الحدث، ولا اسم تفضيل (c) إذ لا مفاضلة بين شيئين، ولا اسم مكان (d).', 5),
  ('6d4da5fa-aeaf-5c4c-aa04-44894bac7c45', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«تتسارع التحوّلاتُ التكنولوجيّة، غير أنّ كثيرًا من الناس لا يُجارونها.»

ما العلاقة التي يُحدثها الرابط «غير أنّ»؟', '[{"id":"a","text":"استدراكٌ يُعارض ما قد يُتوقّع من الجملة الأولى"},{"id":"b","text":"تعليلٌ يُبيّن سبب تسارع التحوّلات"},{"id":"c","text":"نتيجةٌ مترتّبة على التسارع"},{"id":"d","text":"إضافةٌ لمعلومةٍ في الاتّجاه نفسه"}]'::jsonb, 'a', '«غير أنّ» أداةُ استدراكٍ مرادفةٌ لـ«لكنْ»؛ فبعد إثبات تسارع التحوّلات تستدرك بعجز الناس عن مجاراتها، محدثةً تقابلًا. وليست تعليلًا كـ«لأنّ» (b)، ولا نتيجةً كـ«لذلك» (c)، ولا إضافةً كـ«كذلك» (d).', 6),
  ('d188d592-d3bf-5f91-98bf-23decf5ef7e9', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«التفاعلُ بين الثقافات إثراءٌ متبادل: تأخذ كلُّ ثقافةٍ من غيرها وتُعطيها، فتنمو الإنسانيّةُ جمعاء.»

طُلب منك تحرير فقرةٍ تدافع فيها عن هذه الأطروحة. أيّ الجمل التالية أصلحُ لتكون حجّةً (لا مثالًا)؟', '[{"id":"a","text":"الانفتاحُ على الآخر يُغني المعرفة الإنسانيّة لأنّ تلاقح الأفكار يولّد الإبداع"},{"id":"b","text":"فقد نقل العربُ علومَ اليونان وطوّروها ثمّ نقلتها أوروبا عنهم"},{"id":"c","text":"تأمّل كيف انتشرت المأكولاتُ الآسيويّة في مدن العالم كلّها"},{"id":"d","text":"ها هو متحفُ اللوفر يجمع تحفًا من كلّ الحضارات"}]'::jsonb, 'a', 'الحجّة فكرةٌ عقليّة عامّة تُبرّر الموقف، وهذا ما في (a): مبدأٌ عامّ معلَّلٌ بأنّ تلاقح الأفكار يولّد الإبداع. أمّا (b) و(c) و(d) فوقائعُ جزئيّة محسوسة (نقل العرب علوم اليونان، انتشار المأكولات، متحف اللوفر)، وهذه أمثلةٌ تخدم الحجّة لا حججٌ بذاتها.', 7),
  ('b7237357-2f5a-5693-bc6b-3bbf53849cea', '4804d03e-a906-5c55-b91c-f7e5ea6184a6', 'اقرأ النصّ:

«تُهدّد التغيّراتُ المناخيّةُ مستقبلَ الكوكب؛ فارتفاعُ الحرارة يُذيب الجليد ويرفع منسوبَ البحار.»

بعد أن دافعتَ عن خطورة هذه الظاهرة، أيّ الخواتم أنسبُ لإنتاجٍ متماسك؟', '[{"id":"a","text":"وهكذا يتبيّن أنّ حماية المناخ مسؤوليّةٌ جماعيّة، فهل نتحرّك قبل فوات الأوان؟"},{"id":"b","text":"وتجدر الإشارة إلى أنّ التلوّث الصناعيّ موضوعٌ آخر يستحقّ بحثًا مستقلًّا"},{"id":"c","text":"إنّ التغيّراتِ المناخيّةَ تُهدّد مستقبلَ الكوكب كما قلنا في البداية تمامًا"},{"id":"d","text":"وفي الختام أحبّ أن أشكر معلّمي الذي علّمني الكتابة"}]'::jsonb, 'a', 'الخاتمة المتماسكة تُلخّص الموقف ثمّ تفتح أفقًا أو تطرح سؤالًا، وهذا ما في (a): خلاصةٌ (المسؤوليّة الجماعيّة) + أفقٌ تحفيزيّ. أمّا (b) فيُقحم فكرةً جديدةً خارجة عن الموضوع، و(c) تكرارٌ حرفيّ للمقدّمة بلا إضافة، و(d) عبارةٌ شخصيّة لا صلة لها بالموضوع.', 8),
  ('d70ada72-63e7-5a55-a227-26e432a9b817', '4469d441-7ab5-56df-8609-421f6996bf16', 'اقرأ النصّ:

«ما أجملَ أن يكدح المرءُ بيده فيأكل من كدّ يمينه! فالعملُ يصون الكرامةَ ويغرس في النفس عزّةً لا يعرفها العاطل. لقد رأيتُ حرفيًّا بسيطًا يرفض الإحسانَ ويقول: يدي تكفيني. غير أنّ بعض الناس يحتقرون المهنَ اليدويّة ظلمًا، وما دروا أنّ بها قِوامَ المجتمع.»

ما الفكرة العامة للنصّ؟', '[{"id":"a","text":"العملُ مصدرٌ للكرامة والعزّة، واحتقارُ المهن اليدويّة ظلمٌ لها"},{"id":"b","text":"الحرفيُّ البسيط رفض الإحسان مرّةً واحدة"},{"id":"c","text":"بعضُ الناس يحتقرون المهن اليدويّة"},{"id":"d","text":"المرءُ يأكل من كدّ يمينه كلّ يوم"}]'::jsonb, 'a', 'الفكرة العامة جملةٌ جامعة تضمّ موضوع النصّ وموقف الكاتب: تمجيدُ العمل بوصفه مصدر كرامةٍ وعزّة، وإدانةُ احتقار المهن اليدويّة، وهو ما يصوغه (a). أمّا (b) فمثالٌ جزئيّ، و(c) فكرةٌ جزئيّة وردت في الخاتمة، و(d) تفصيلٌ تمهيديّ.', 1),
  ('9704c8f4-b1d3-576d-a53b-d7d089c653ff', '4469d441-7ab5-56df-8609-421f6996bf16', 'اقرأ النصّ:

«ما أجملَ أن يكدح المرءُ بيده فيأكل من كدّ يمينه! فالعملُ يصون الكرامةَ ويغرس في النفس عزّةً لا يعرفها العاطل. لقد رأيتُ حرفيًّا بسيطًا يرفض الإحسانَ ويقول: يدي تكفيني. غير أنّ بعض الناس يحتقرون المهنَ اليدويّة ظلمًا، وما دروا أنّ بها قِوامَ المجتمع.»

ما النبرة الغالبة على موقف الكاتب من العمل؟', '[{"id":"a","text":"إعجابٌ بالعمل وتثمينٌ له مع استنكارٍ لاحتقار المهن"},{"id":"b","text":"سخريةٌ من العمّال وأصحاب الحرف"},{"id":"c","text":"حيادٌ تامّ لا موقف فيه"},{"id":"d","text":"حزنٌ وأسًى على ضياع العمل"}]'::jsonb, 'a', 'قرائنُ النصّ تكشف النبرة: التعجّبُ الإعجابيّ «ما أجملَ»، وألفاظُ المدح «يصون الكرامة، يغرس عزّة»، ثمّ الاستنكارُ «يحتقرون ظلمًا». فالنبرة إعجابٌ بالعمل واستنكارٌ لاحتقاره (a). فلا سخرية من العمّال (b)، ولا حياد (c) إذ الموقف واضح، ولا حزن على ضياعٍ لم يُذكر (d).', 2),
  ('7bcff282-d7f8-54b0-b0be-c872ab3c752a', '4469d441-7ab5-56df-8609-421f6996bf16', 'اقرأ النصّ:

«ما أجملَ أن يكدح المرءُ بيده فيأكل من كدّ يمينه! فالعملُ يصون الكرامةَ ويغرس في النفس عزّةً لا يعرفها العاطل. لقد رأيتُ حرفيًّا بسيطًا يرفض الإحسانَ ويقول: يدي تكفيني. غير أنّ بعض الناس يحتقرون المهنَ اليدويّة ظلمًا، وما دروا أنّ بها قِوامَ المجتمع.»

ما إعراب كلمة «الكرامةَ» في قوله: «يصون الكرامةَ»؟', '[{"id":"a","text":"مفعول به منصوب وعلامة نصبه الفتحة"},{"id":"b","text":"فاعل مرفوع وعلامة رفعه الضمّة"},{"id":"c","text":"مبتدأ مرفوع بالضمّة"},{"id":"d","text":"مضاف إليه مجرور بالكسرة"}]'::jsonb, 'a', '«الكرامةَ» وقع عليها فعلُ الصون، والفاعل هو «العمل»، فهي مفعول به منصوب وعلامة نصبه الفتحة الظاهرة. وليست فاعلًا (b) فالفاعل سبقها، ولا مبتدأ (c) فالجملة فعليّة، ولا مضافًا إليه (d) إذ لم يسبقها مضاف.', 3),
  ('d98ffab6-c3af-520a-b0fe-45997e7aa17f', '4469d441-7ab5-56df-8609-421f6996bf16', 'اقرأ النصّ:

«ما أجملَ أن يكدح المرءُ بيده فيأكل من كدّ يمينه! فالعملُ يصون الكرامةَ ويغرس في النفس عزّةً لا يعرفها العاطل. لقد رأيتُ حرفيًّا بسيطًا يرفض الإحسانَ ويقول: يدي تكفيني. غير أنّ بعض الناس يحتقرون المهنَ اليدويّة ظلمًا، وما دروا أنّ بها قِوامَ المجتمع.»

ما نوع كلمة «العاطل» من حيث الاشتقاق؟', '[{"id":"a","text":"اسم فاعل من الفعل «عَطَلَ» على وزن فاعِل"},{"id":"b","text":"اسم مفعول على وزن مَفعول"},{"id":"c","text":"اسم تفضيل على وزن أَفعَل"},{"id":"d","text":"مصدر صريح"}]'::jsonb, 'a', '«العاطل» على وزن «فاعِل»، يدلّ على من قام بالحدث (اتّصف بالعَطالة/البطالة)، فهو اسم فاعل. وليس اسم مفعول (b) فلا يدلّ على من وقع عليه الفعل، ولا اسم تفضيل (c) إذ ليس على وزن «أفعل» ولا مفاضلة فيه، ولا مصدرًا (d) فهو وصفٌ لذاتٍ لا حدثٌ مجرّد.', 4),
  ('c113425c-4057-5109-aec5-1f8b1d8a7267', '4469d441-7ab5-56df-8609-421f6996bf16', 'اقرأ النصّ:

«ما أجملَ أن يكدح المرءُ بيده فيأكل من كدّ يمينه! فالعملُ يصون الكرامةَ ويغرس في النفس عزّةً لا يعرفها العاطل. لقد رأيتُ حرفيًّا بسيطًا يرفض الإحسانَ ويقول: يدي تكفيني. غير أنّ بعض الناس يحتقرون المهنَ اليدويّة ظلمًا، وما دروا أنّ بها قِوامَ المجتمع.»

ما الغرض البلاغيّ من أسلوب التعجّب في «ما أجملَ أن يكدح المرءُ بيده!»؟', '[{"id":"a","text":"إظهارُ الإعجاب بقيمة العمل اليدويّ وتعظيمُها"},{"id":"b","text":"الاستفهامُ عن جمال الكدح والسؤال عنه"},{"id":"c","text":"النهيُ عن العمل اليدويّ والتحذيرُ منه"},{"id":"d","text":"التمنّي بحدوث أمرٍ مستحيل"}]'::jsonb, 'a', '«ما أجملَ…» صيغةُ تعجّبٍ قياسيّة (ما + أفعَل + المتعجَّب منه)، غرضُها البلاغيّ إظهارُ الإعجاب بقيمة العمل وتعظيمها. وليست استفهامًا (b) فلا أداة استفهام، ولا نهيًا (c) فهي تمدح لا تزجر، ولا تمنّيًا لمستحيل (d) فالكدح أمرٌ ممكنٌ واقع.', 5),
  ('de398e68-3464-5534-9fe5-a80a67ce51f0', '4469d441-7ab5-56df-8609-421f6996bf16', 'اقرأ النصّ:

«ما أجملَ أن يكدح المرءُ بيده فيأكل من كدّ يمينه! فالعملُ يصون الكرامةَ ويغرس في النفس عزّةً لا يعرفها العاطل. لقد رأيتُ حرفيًّا بسيطًا يرفض الإحسانَ ويقول: يدي تكفيني. غير أنّ بعض الناس يحتقرون المهنَ اليدويّة ظلمًا، وما دروا أنّ بها قِوامَ المجتمع.»

طُلب منك تحرير فقرةٍ تدافع فيها عن قيمة العمل. أيّ الجمل التالية أصلحُ لتكون أطروحةً واضحة؟', '[{"id":"a","text":"العملُ أساسُ كرامة الإنسان وعمادُ نهضة المجتمعات"},{"id":"b","text":"هل العملُ مفيدٌ للإنسان أم لا؟"},{"id":"c","text":"رأيتُ ذات يومٍ نجّارًا يصنع بابًا جميلًا"},{"id":"d","text":"العملُ شيءٌ موجودٌ في كلّ مكان من العالم"}]'::jsonb, 'a', 'الأطروحة موقفٌ خبريٌّ واضحٌ حاسمٌ قابلٌ للبرهنة، وهذا ما في (a): حُكمٌ صريح يقبل الدفاع بالحجج. أمّا (b) فسؤالٌ لا أطروحة، و(c) مثالٌ جزئيّ محسوس يصلح للبرهنة لا للطرح، و(d) عبارةٌ مبهمةٌ خاليةٌ من الموقف لا تقبل الدفاع عنها.', 6),
  ('24a0575c-7c4d-52e6-bd71-c8ce2665c359', '718b8183-470f-54a1-9091-3bcbbcb0951d', 'اقرأ النصّ:

«يعيش عالمُنا اليومَ أزماتٍ خانقة: تلوّثٌ يخنق الهواء، وحروبٌ تحصد الأرواح، وفقرٌ ينهش أجساد الملايين. غير أنّ اليأس ليس قَدَرًا؛ فمتى وحّد الناسُ جهودَهم أمكنهم أن يصنعوا غدًا أرحب. أوليس الإنسانُ الذي قهر الفضاءَ قادرًا على قهر مشكلاته؟»

ما الفكرة العامة للنصّ؟', '[{"id":"a","text":"رغم أزمات العصر الخانقة، يبقى تضافرُ جهود البشر سبيلًا إلى مستقبلٍ أفضل"},{"id":"b","text":"التلوّثُ يخنق هواءَ المدن الكبرى"},{"id":"c","text":"الإنسانُ نجح في قهر الفضاء واستكشافه"},{"id":"d","text":"الفقرُ ينهش أجسادَ ملايين البشر"}]'::jsonb, 'a', 'الفكرة العامة تجمع موضوع النصّ وموقف الكاتب: عرضُ أزمات العصر ثمّ رفضُ اليأس والدعوةُ إلى التضامن لصنع غدٍ أفضل، وهو ما يصوغه (a). أمّا (b) و(d) فمثالان جزئيّان من الأزمات، و(c) قرينةٌ حجاجيّة عابرة لا الفكرة المحورية.', 1),
  ('4335c9fe-4e5f-5d2a-8e2f-ba4006e8066d', '718b8183-470f-54a1-9091-3bcbbcb0951d', 'اقرأ النصّ:

«يعيش عالمُنا اليومَ أزماتٍ خانقة: تلوّثٌ يخنق الهواء، وحروبٌ تحصد الأرواح، وفقرٌ ينهش أجساد الملايين. غير أنّ اليأس ليس قَدَرًا؛ فمتى وحّد الناسُ جهودَهم أمكنهم أن يصنعوا غدًا أرحب. أوليس الإنسانُ الذي قهر الفضاءَ قادرًا على قهر مشكلاته؟»

ما العلاقة المنطقيّة التي يُحدثها الرابط «غير أنّ»؟', '[{"id":"a","text":"استدراكٌ يُعارض ما قد يُفهم من الجملة الأولى (وهو الاستسلام لليأس)"},{"id":"b","text":"تعليلٌ يُبيّن سبب الأزمات"},{"id":"c","text":"نتيجةٌ مترتّبة على الأزمات"},{"id":"d","text":"تمثيلٌ وتوضيحٌ بالأمثلة"}]'::jsonb, 'a', '«غير أنّ» أداةُ استدراكٍ مرادفةٌ لـ«لكنْ»؛ فبعد سرد الأزمات التي قد توحي باليأس، تستدرك بأنّ «اليأس ليس قَدَرًا»، محدثةً تقابلًا بين قتامة الواقع وأمل الإصلاح. وليست تعليلًا (b) ولا نتيجةً (c) ولا تمثيلًا (d)، بل معارضةٌ واستدراك.', 2),
  ('d128d488-e1fb-51d5-b4a4-651329fbe56d', '718b8183-470f-54a1-9091-3bcbbcb0951d', 'اقرأ النصّ:

«يعيش عالمُنا اليومَ أزماتٍ خانقة: تلوّثٌ يخنق الهواء، وحروبٌ تحصد الأرواح، وفقرٌ ينهش أجساد الملايين. غير أنّ اليأس ليس قَدَرًا؛ فمتى وحّد الناسُ جهودَهم أمكنهم أن يصنعوا غدًا أرحب. أوليس الإنسانُ الذي قهر الفضاءَ قادرًا على قهر مشكلاته؟»

ما دلالة أسلوب الاستفهام في «أوليس الإنسانُ… قادرًا على قهر مشكلاته؟»', '[{"id":"a","text":"استفهامٌ إنكاريّ خرج إلى التقرير، يُثبت قدرة الإنسان على حلّ مشكلاته"},{"id":"b","text":"استفهامٌ حقيقيّ يطلب الكاتبُ به جوابًا يجهله"},{"id":"c","text":"استفهامٌ يدلّ على شكّ الكاتب في قدرة الإنسان"},{"id":"d","text":"استفهامٌ للتمنّي والترجّي"}]'::jsonb, 'a', 'الاستفهام هنا إنكاريٌّ خرج عن معناه الحقيقيّ إلى التقرير والإثبات: الكاتب لا يستفهم عن جوابٍ يجهله (b)، بل يُؤكّد أنّ مَن قهر الفضاء قادرٌ على قهر مشكلاته. ولا يدلّ على شكّه (c) فهو مقتنعٌ متفائل، ولا على تمنٍّ (d). والقرينة: سياق التفاؤل ودحض اليأس.', 3),
  ('268841c8-b604-59ac-9d8f-fc1d65be98fa', '718b8183-470f-54a1-9091-3bcbbcb0951d', 'اقرأ النصّ:

«يعيش عالمُنا اليومَ أزماتٍ خانقة: تلوّثٌ يخنق الهواء، وحروبٌ تحصد الأرواح، وفقرٌ ينهش أجساد الملايين. غير أنّ اليأس ليس قَدَرًا؛ فمتى وحّد الناسُ جهودَهم أمكنهم أن يصنعوا غدًا أرحب. أوليس الإنسانُ الذي قهر الفضاءَ قادرًا على قهر مشكلاته؟»

ما إعراب كلمة «أزماتٍ» في قوله: «يعيش عالمُنا أزماتٍ»؟', '[{"id":"a","text":"مفعول به منصوب وعلامة نصبه الكسرة نيابةً عن الفتحة لأنّه جمع مؤنّث سالم"},{"id":"b","text":"مفعول به منصوب وعلامة نصبه الفتحة الظاهرة"},{"id":"c","text":"فاعل مرفوع وعلامة رفعه الضمّة"},{"id":"d","text":"اسم مجرور وعلامة جرّه الكسرة"}]'::jsonb, 'a', '«أزماتٍ» مفعول به وقع عليه فعل «يعيش» (والفاعل «عالمُنا»)، وهو جمع مؤنّث سالم يُنصب بالكسرة نيابةً عن الفتحة؛ فهذه علامةٌ فرعية. فالخيار (b) أخطأ بجعلها فتحةً ظاهرة، و(c) أخطأ بجعلها فاعلًا والفاعل سبقها، و(d) ظنّها مجرورةً وهي منصوبةٌ بالكسرة لا مجرورة.', 4),
  ('9e6d0ab8-9d69-5247-b8a7-4c960df343b4', '718b8183-470f-54a1-9091-3bcbbcb0951d', 'اقرأ النصّ:

«يعيش عالمُنا اليومَ أزماتٍ خانقة: تلوّثٌ يخنق الهواء، وحروبٌ تحصد الأرواح، وفقرٌ ينهش أجساد الملايين. غير أنّ اليأس ليس قَدَرًا؛ فمتى وحّد الناسُ جهودَهم أمكنهم أن يصنعوا غدًا أرحب. أوليس الإنسانُ الذي قهر الفضاءَ قادرًا على قهر مشكلاته؟»

ما نوع كلمة «خانقة» وعلام تدلّ؟', '[{"id":"a","text":"اسم فاعل من «خنَقَ» على وزن فاعِل، نعتٌ يدلّ على فاعل الخنق"},{"id":"b","text":"اسم مفعول على وزن مَفعول يدلّ على من وقع عليه الخنق"},{"id":"c","text":"صيغة مبالغة على وزن فعّال"},{"id":"d","text":"اسم تفضيل على وزن أفعَل"}]'::jsonb, 'a', '«خانقة» مؤنّث «خانِق» على وزن «فاعِل»، اسمُ فاعلٍ من «خنَقَ» يدلّ على مَن قام بالحدث (الأزمات هي التي تخنق)، ووقع نعتًا لـ«أزمات». وليس اسم مفعول (b) فالأزمات فاعلةٌ لا مفعولة، ولا صيغة مبالغة على «فعّال» (c)، ولا اسم تفضيل (d) إذ لا مفاضلة.', 5),
  ('da15930c-f96f-5c0c-8825-af963f2b7b1b', '718b8183-470f-54a1-9091-3bcbbcb0951d', 'اقرأ النصّ:

«يعيش عالمُنا اليومَ أزماتٍ خانقة: تلوّثٌ يخنق الهواء، وحروبٌ تحصد الأرواح، وفقرٌ ينهش أجساد الملايين. غير أنّ اليأس ليس قَدَرًا؛ فمتى وحّد الناسُ جهودَهم أمكنهم أن يصنعوا غدًا أرحب. أوليس الإنسانُ الذي قهر الفضاءَ قادرًا على قهر مشكلاته؟»

أردتَ أن تدعم في إنتاجك حجّةَ «أنّ التعاون الدوليّ يحلّ المشكلات الكونيّة» بمثالٍ مناسب. أيّها أنسب؟', '[{"id":"a","text":"فقد تكاتفت دولُ العالم لرأب ثقب الأوزون حتّى بدأت طبقتُه تتعافى"},{"id":"b","text":"إنّ التعاونَ بين الأمم ضرورةٌ لا غنى عنها في عصرنا"},{"id":"c","text":"لا يمكن لدولةٍ واحدة أن تحلّ المشكلات الكونيّة بمفردها"},{"id":"d","text":"التعاونُ الدوليّ مفهومٌ يدرسه طلّابُ العلوم السياسيّة"}]'::jsonb, 'a', 'المثال واقعةٌ جزئيّة محسوسة تُجسّد الحجّة، وهذا ما في (a): حادثةٌ ملموسة (تكاتف الدول لرأب ثقب الأوزون) تبرهن على نفع التعاون. أمّا (b) و(c) فتكراران للحجّة بصياغةٍ عامّة لا أمثلةٌ محسوسة، و(d) معلومةٌ جانبيّة لا تُبرهن على نجاح التعاون في الحلّ.', 6),
  ('1c332669-3836-58fb-b165-10049d7ad866', '959e37bc-55d7-5ce4-8ca7-3704e4bbe571', 'اقرأ النصّ:

«ما كانت الفنونُ يومًا حِكرًا على أمّةٍ دون أخرى؛ فالنغمُ الأندلسيُّ مزجَ شجنَ الشرق برقّة الغرب، والعمارةُ الإسلاميّة استلهمت من حضاراتٍ شتّى فأبدعت طُرُزًا خالدة. إنّ الفنّ الأصيلَ هو الذي يأخذ من غيره ثمّ يصوغ المأخوذَ صياغةً جديدة تحمل بصمتَه. أمّا المنغلقُ على ذاته فيجترّ نفسَه حتّى يذبل.»

ما الأطروحة التي يدافع عنها الكاتب؟', '[{"id":"a","text":"الفنّ الأصيل يتغذّى على تلاقح الثقافات ثمّ يُعيد صياغته صياغةً مبتكرة، والانغلاق يُذبله"},{"id":"b","text":"النغمُ الأندلسيّ جمع بين شجن الشرق ورقّة الغرب"},{"id":"c","text":"العمارةُ الإسلاميّة أبدعت طرزًا معماريّة خالدة"},{"id":"d","text":"ينبغي للفنون أن تنغلق على ذاتها حفاظًا على أصالتها"}]'::jsonb, 'a', 'الأطروحة هي الموقف الذي يدافع عنه الكاتب، وقد صرّح به: الفنّ الأصيل يأخذ من غيره ويُعيد صياغته، والانغلاق يُذبل؛ فالخيار (a) يجمع الطرفين. أمّا (b) و(c) فمثالان جزئيّان يخدمان الأطروحة لا هي، و(d) يناقض موقف الكاتب تمامًا.', 1),
  ('24a9edd7-0aee-5038-b86d-677ecc01a311', '959e37bc-55d7-5ce4-8ca7-3704e4bbe571', 'اقرأ النصّ:

«ما كانت الفنونُ يومًا حِكرًا على أمّةٍ دون أخرى؛ فالنغمُ الأندلسيُّ مزجَ شجنَ الشرق برقّة الغرب، والعمارةُ الإسلاميّة استلهمت من حضاراتٍ شتّى فأبدعت طُرُزًا خالدة. إنّ الفنّ الأصيلَ هو الذي يأخذ من غيره ثمّ يصوغ المأخوذَ صياغةً جديدة تحمل بصمتَه. أمّا المنغلقُ على ذاته فيجترّ نفسَه حتّى يذبل.»

ما إعراب كلمة «الفنّ» في قوله: «إنّ الفنّ الأصيلَ هو الذي…»؟', '[{"id":"a","text":"اسم «إنّ» منصوب وعلامة نصبه الفتحة"},{"id":"b","text":"خبر «إنّ» مرفوع بالضمّة"},{"id":"c","text":"مبتدأ مرفوع بالضمّة"},{"id":"d","text":"فاعل مرفوع بالضمّة"}]'::jsonb, 'a', '«إنّ» حرفٌ ناسخ ينصب الاسم ويرفع الخبر؛ فـ«الفنّ» اسمها منصوب بالفتحة، و«الأصيلَ» نعتٌ تابعٌ له في النصب، والخبر جملةُ «هو الذي يأخذ…». فليست خبرًا (b)، ولا مبتدأ (c) إذ دخل عليها الناسخ فأبطل الابتداء، ولا فاعلًا (d) فلا فعل قبلها.', 2),
  ('6013ad59-5138-54c6-876e-166abe685400', '959e37bc-55d7-5ce4-8ca7-3704e4bbe571', 'اقرأ النصّ:

«ما كانت الفنونُ يومًا حِكرًا على أمّةٍ دون أخرى؛ فالنغمُ الأندلسيُّ مزجَ شجنَ الشرق برقّة الغرب، والعمارةُ الإسلاميّة استلهمت من حضاراتٍ شتّى فأبدعت طُرُزًا خالدة. إنّ الفنّ الأصيلَ هو الذي يأخذ من غيره ثمّ يصوغ المأخوذَ صياغةً جديدة تحمل بصمتَه. أمّا المنغلقُ على ذاته فيجترّ نفسَه حتّى يذبل.»

ما وزن كلمة «المأخوذَ» وما نوعها من حيث الاشتقاق؟', '[{"id":"a","text":"على وزن مَفعول، اسم مفعول يدلّ على ما وقع عليه الأخذ"},{"id":"b","text":"على وزن فاعِل، اسم فاعل يدلّ على من قام بالأخذ"},{"id":"c","text":"على وزن أفعَل، اسم تفضيل"},{"id":"d","text":"على وزن مِفعال، اسم آلة"}]'::jsonb, 'a', '«المأخوذ» على وزن «مَفعول»، اسمُ مفعولٍ من «أخَذَ» يدلّ على ما وقع عليه الفعل (الشيء الذي أُخذ من الغير). فليس اسم فاعل على «فاعِل» (b) فهو لم يأخذ بل أُخذ، ولا اسم تفضيل على «أفعَل» (c)، ولا اسم آلة على «مِفعال» (d).', 3),
  ('da9a0b77-51b8-5b75-b455-70c9a1df1955', '959e37bc-55d7-5ce4-8ca7-3704e4bbe571', 'اقرأ النصّ:

«ما كانت الفنونُ يومًا حِكرًا على أمّةٍ دون أخرى؛ فالنغمُ الأندلسيُّ مزجَ شجنَ الشرق برقّة الغرب، والعمارةُ الإسلاميّة استلهمت من حضاراتٍ شتّى فأبدعت طُرُزًا خالدة. إنّ الفنّ الأصيلَ هو الذي يأخذ من غيره ثمّ يصوغ المأخوذَ صياغةً جديدة تحمل بصمتَه. أمّا المنغلقُ على ذاته فيجترّ نفسَه حتّى يذبل.»

أيّ صورةٍ بلاغيّة في قوله: «المنغلقُ… يجترّ نفسَه حتّى يذبل»؟', '[{"id":"a","text":"استعارةٌ تُشبّه المنغلق بنباتٍ يجترّ ويذبل، إيحاءً بعقمه وموته الإبداعيّ"},{"id":"b","text":"خبرٌ محضٌ لا مجاز فيه ولا صورة"},{"id":"c","text":"طباقٌ بين لفظين متضادّين في الجملة"},{"id":"d","text":"جناسٌ بين لفظين متشابهين في النطق"}]'::jsonb, 'a', '«يجترّ نفسَه حتّى يذبل» استعارةٌ تصويريّة: شُبّه الفنّ المنغلق بكائنٍ حيّ (نباتٍ أو حيوان) يجترّ ويذبل، فاستُعير له فعلُ الذبول إيحاءً بعقمه وموته الإبداعيّ. فليس خبرًا خاليًا من المجاز (b)، ولا طباقًا بين ضدّين (c)، ولا جناسًا بين متشابهين لفظًا (d).', 4),
  ('907258b9-f8c4-5a4f-b5d2-761a34070b97', '959e37bc-55d7-5ce4-8ca7-3704e4bbe571', 'اقرأ النصّ:

«ما كانت الفنونُ يومًا حِكرًا على أمّةٍ دون أخرى؛ فالنغمُ الأندلسيُّ مزجَ شجنَ الشرق برقّة الغرب، والعمارةُ الإسلاميّة استلهمت من حضاراتٍ شتّى فأبدعت طُرُزًا خالدة. إنّ الفنّ الأصيلَ هو الذي يأخذ من غيره ثمّ يصوغ المأخوذَ صياغةً جديدة تحمل بصمتَه. أمّا المنغلقُ على ذاته فيجترّ نفسَه حتّى يذبل.»

طُلب منك دحضُ رأي مَن يرى أنّ «الأخذ من الفنون الأجنبيّة تقليدٌ يُفقد الهويّة». أيّ حجّةٍ مضادّة أصلحُ، استنادًا إلى منطق النصّ؟', '[{"id":"a","text":"الأخذُ الواعي ليس تقليدًا بل تمثُّلٌ يُعيد صياغة المأخوذ بروح الأمّة، فيُغني الهويّة لا يُذيبها"},{"id":"b","text":"الفنونُ الأجنبيّة أرقى دائمًا من فنوننا فيجب اتّباعها كما هي"},{"id":"c","text":"ينبغي منعُ كلّ تأثيرٍ أجنبيّ خوفًا على الهويّة"},{"id":"d","text":"الهويّةُ مفهومٌ متغيّر لا قيمة للحفاظ عليه"}]'::jsonb, 'a', 'دحضُ الرأي يقتضي حجّةً مضادّةً تتّسق مع منطق النصّ، وهو يميّز بين التقليد الأعمى والأخذ الواعي الذي «يصوغ المأخوذ صياغةً جديدة تحمل بصمته»؛ فالخيار (a) يبني على هذا التمييز ليُثبت أنّ الأخذ يُغني الهويّة. أمّا (b) فتسليمٌ بالتبعيّة يناقض الأطروحة، و(c) يؤيّد الانغلاق الذي ذمّه النصّ، و(d) ينحرف إلى التهوين من الهويّة لا الدفاع عن التفاعل.', 5),
  ('284e63fe-7403-53c5-a36e-c491a6e541a6', '959e37bc-55d7-5ce4-8ca7-3704e4bbe571', 'اقرأ النصّ:

«ما كانت الفنونُ يومًا حِكرًا على أمّةٍ دون أخرى؛ فالنغمُ الأندلسيُّ مزجَ شجنَ الشرق برقّة الغرب، والعمارةُ الإسلاميّة استلهمت من حضاراتٍ شتّى فأبدعت طُرُزًا خالدة. إنّ الفنّ الأصيلَ هو الذي يأخذ من غيره ثمّ يصوغ المأخوذَ صياغةً جديدة تحمل بصمتَه. أمّا المنغلقُ على ذاته فيجترّ نفسَه حتّى يذبل.»

أردتَ في إنتاجك أن تنتقل من حجّةِ «التلاقح يُثري الفنّ» إلى حجّةِ «الانغلاق يُفقره». أيّ رابطٍ منطقيّ أنسبُ لهذا الانتقال؟', '[{"id":"a","text":"في المقابل / على النقيض من ذلك"},{"id":"b","text":"لأنّ / إذ"},{"id":"c","text":"نتيجةً لذلك / ومن ثمّ"},{"id":"d","text":"علاوةً على ذلك / كذلك"}]'::jsonb, 'a', 'الانتقال من فكرةٍ إيجابيّة (التلاقح يُثري) إلى فكرةٍ نقيضةٍ (الانغلاق يُفقر) يقتضي رابطَ تقابلٍ واستدراك مثل «في المقابل / على النقيض». فـ«لأنّ» (b) رابطُ تعليل، و«نتيجةً لذلك» (c) رابطُ نتيجة، و«علاوةً على ذلك» (d) رابطُ إضافةٍ في الاتّجاه نفسه — وكلّها لا تُناسب التقابل المطلوب.', 6),
  ('45de69e9-1de5-50f2-9f60-b4106d6397fb', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'An exam reading question asks: "What is the writer''s main idea?" What should you look for?', '[{"id":"a","text":"A small detail such as a name or a number."},{"id":"b","text":"The whole message of the text, often near the start or end."},{"id":"c","text":"Your own opinion about the topic."},{"id":"d","text":"The longest sentence in the text."}]'::jsonb, 'b', 'The main idea is the overall message of the text, usually stated near the beginning or end. (a) is a detail, not the main idea; (c) the answer must come from the text, not your opinion; (d) length has nothing to do with importance.', 1),
  ('63b1b105-f43d-5d32-9238-bbf6fb14414b', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'In a True / False / Not mentioned task, when should you choose "Not mentioned"?', '[{"id":"a","text":"When the text clearly says the opposite."},{"id":"b","text":"When you personally disagree with the statement."},{"id":"c","text":"When the text simply does not give that information."},{"id":"d","text":"When the statement is too long to check."}]'::jsonb, 'c', '"Not mentioned" means the information is absent from the text. (a) describes "False" (the text contradicts it); (b) your opinion is irrelevant; (d) length does not decide the answer.', 2),
  ('8c6fd010-6c6c-59dd-b928-aad83f83dec6', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Read this sentence:

"My sister loves animals, so she wants to become a vet."

In this sentence, who does the word "she" refer to?', '[{"id":"a","text":"the vet"},{"id":"b","text":"my sister"},{"id":"c","text":"the animals"},{"id":"d","text":"the writer"}]'::jsonb, 'b', 'A reference word points back to the nearest matching noun. "She" is singular and female, so it stands for "my sister". The vet (a) is what she wants to become, the animals (c) are plural, and "the writer" (d) would be "I".', 3),
  ('079b30d7-3f60-59f7-a3aa-b1ef79ac3e78', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Choose the correct verb form:

"Yesterday, the students ______ a documentary about the desert."', '[{"id":"a","text":"watch"},{"id":"b","text":"watched"},{"id":"c","text":"are watching"},{"id":"d","text":"will watch"}]'::jsonb, 'b', 'The time marker "Yesterday" signals a finished past action, so the past simple "watched" is correct. (a) is present simple, (c) present continuous, and (d) future — none fits a past time marker.', 4),
  ('85188fa4-904b-567e-adf6-02a36c162396', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Choose the correct modal:

"You look tired. You ______ go to bed early tonight." (giving advice)', '[{"id":"a","text":"should"},{"id":"b","text":"can"},{"id":"c","text":"must"},{"id":"d","text":"might"}]'::jsonb, 'a', 'For advice we use "should". (b) "can" expresses ability/permission; (c) "must" is a strong obligation, too strong for friendly advice; (d) "might" expresses possibility, not advice.', 5),
  ('3c7fb0e5-23a9-5967-86c0-9ac82d0a5214', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Put the verb in the passive voice:

"The new library ______ last year." (open)', '[{"id":"a","text":"opened"},{"id":"b","text":"was opened"},{"id":"c","text":"is opening"},{"id":"d","text":"has opened"}]'::jsonb, 'b', 'The passive is "be + past participle", and "last year" needs a past form: "was opened". The library receives the action; it did not open itself. (a) and (d) are active, (c) is present continuous and wrong in time.', 6),
  ('bb1df896-3806-5d03-9230-d9531cce5f93', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Which sentence is the best topic sentence for a paragraph about the benefits of reading?', '[{"id":"a","text":"For example, novels can teach us about other cultures."},{"id":"b","text":"Reading regularly brings many benefits to young people."},{"id":"c","text":"Yesterday I borrowed two books from the school library."},{"id":"d","text":"In short, that is why everyone should read."}]'::jsonb, 'b', 'A topic sentence is general and announces the paragraph''s main idea — exactly what (b) does. (a) is a supporting example ("For example"), (c) is a narrow personal detail, and (d) is a closing sentence ("In short").', 7),
  ('21c615c8-3484-52ef-8a08-9730c3daf203', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Choose the best linking word:

"The bus was late; ______, we still arrived on time."', '[{"id":"a","text":"therefore"},{"id":"b","text":"because"},{"id":"c","text":"however"},{"id":"d","text":"for example"}]'::jsonb, 'c', 'There is a contrast between the late bus and arriving on time, so "however" fits. (a) "therefore" shows a result, (b) "because" shows a cause, and (d) "for example" introduces an example — none expresses contrast.', 8),
  ('0b5540ce-a308-572a-8039-4e8cc0e980c5', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

What is the main idea of the text?', '[{"id":"a","text":"Couscous is the best dish to cook on Fridays."},{"id":"b","text":"The family''s weekly meal keeps them close together."},{"id":"c","text":"Grandfather lives in the house next door."},{"id":"d","text":"Children should always help in the kitchen."}]'::jsonb, 'b', 'The last sentence states the message directly: the weekly meal "keeps the family close". (a) couscous is only a detail; (c) where Grandfather lives is a small detail; (d) is not the writer''s point.', 1),
  ('4ab8c800-399f-5877-9a19-a7885c560245', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

According to the text, who arrives first?', '[{"id":"a","text":"the parents"},{"id":"b","text":"the children"},{"id":"c","text":"Grandfather"},{"id":"d","text":"the neighbours"}]'::jsonb, 'c', 'The text says "Grandfather... always arrives first". (a) the parents are cooking, (b) the children set the table, and (d) neighbours are never mentioned.', 2),
  ('02017d0d-9d9f-5fb3-a665-b8f263b9db89', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

In the last sentence, what does the word "it" refer to?', '[{"id":"a","text":"the present"},{"id":"b","text":"the weekly meal"},{"id":"c","text":"Grandfather"},{"id":"d","text":"the kitchen"}]'::jsonb, 'b', '"It keeps the family close" — "it" points back to the subject just mentioned, "this weekly meal". A present (a) is what the meal is compared to, while Grandfather (c) and the kitchen (d) are not what keeps the family close.', 3),
  ('cb662391-35a7-50c2-909c-081c92409fb5', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

Language: which tense is used in "the children set the table", and why?', '[{"id":"a","text":"Present simple, because it describes a regular Friday habit."},{"id":"b","text":"Past simple, because it happened yesterday."},{"id":"c","text":"Present continuous, because it is happening right now."},{"id":"d","text":"Future, because it will happen next week."}]'::jsonb, 'a', 'The phrase "Every Friday evening" marks a repeated routine, so the present simple is used. (b) there is no past time marker; (c) "set" here is simple, not "-ing"; (d) it is not a future plan but a habit.', 4),
  ('8efce0dd-10b4-5f6f-ae30-384ebdff0e63', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

Language: in "Grandfather, who lives next door", what does the relative word "who" refer to?', '[{"id":"a","text":"the door"},{"id":"b","text":"the children"},{"id":"c","text":"Grandfather"},{"id":"d","text":"the kitchen"}]'::jsonb, 'c', '"Who" is used for people and refers to the noun right before it: "Grandfather". (a) and (d) are places (they would need "where"/"which"); (b) the children are not the noun the clause describes.', 5),
  ('537e935a-652f-5111-8613-25656b00ad2e', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

Writing: you want to add a sentence about another family activity. Which one best continues the paragraph?', '[{"id":"a","text":"The price of vegetables has risen sharply this month."},{"id":"b","text":"After dinner, they often play cards together and laugh until late."},{"id":"c","text":"My favourite football team won the match on Saturday."},{"id":"d","text":"The new mobile phone has a very good camera."}]'::jsonb, 'b', 'A coherent continuation must stay on the topic of family togetherness; playing cards after dinner fits perfectly. (a) prices, (c) football and (d) a phone all drift to unrelated subjects and break the paragraph''s unity.', 6),
  ('97e40233-213f-51fd-a7f1-f0bf0f053109', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

In the text, the word "banned" most probably means:', '[{"id":"a","text":"allowed everywhere"},{"id":"b","text":"officially not permitted"},{"id":"c","text":"repaired"},{"id":"d","text":"sold cheaply"}]'::jsonb, 'b', 'Cars were "banned from the centre" so that people would cycle instead — the context shows they were not allowed. (a) is the opposite; (c) and (d) do not fit the idea of keeping cars out for cleaner air.', 1),
  ('fb518c59-c56f-512e-b186-78d6542ecffd', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Language: the sentence "Cars were banned from the centre" is in the:', '[{"id":"a","text":"active voice, present simple"},{"id":"b","text":"passive voice, past simple"},{"id":"c","text":"active voice, past continuous"},{"id":"d","text":"passive voice, present perfect"}]'::jsonb, 'b', '"Were banned" = was/were + past participle, the passive of the past simple; the cars receive the action and the doer is unimportant. (a) and (c) are active; (d) would be "have been banned".', 2),
  ('0d7f1d4a-b5cf-512f-9b50-88ac74c5e953', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

What can we infer from the doctor''s words?', '[{"id":"a","text":"The doctor wanted the event to stop."},{"id":"b","text":"Cleaner air seemed to improve people''s breathing."},{"id":"c","text":"The hospital closed during the clean-air week."},{"id":"d","text":"Most people in the town were ill."}]'::jsonb, 'b', 'Fewer breathing patients during a clean-air week suggests the cleaner air helped people breathe better — an inference supported by the clues. (a) contradicts the positive report; (c) and (d) are never stated and go beyond what the text suggests.', 3),
  ('e04c9ac5-3c55-5ec1-8cb2-ef8646730baf', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Language: report the doctor''s words. The doctor said that ______.', '[{"id":"a","text":"he has seen fewer patients with breathing problems that week"},{"id":"b","text":"he had seen fewer patients with breathing problems that week"},{"id":"c","text":"I have seen fewer patients with breathing problems this week"},{"id":"d","text":"he will see fewer patients with breathing problems this week"}]'::jsonb, 'b', 'In reported speech the present perfect "have seen" shifts back to the past perfect "had seen", "I" becomes "he", and "this week" becomes "that week". (a) keeps the present perfect, (c) keeps the exact quote, and (d) changes the meaning to the future.', 4),
  ('316620e5-8554-5638-8f9d-5fd49771dd20', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Language: complete this conditional sentence based on the text.

"If more towns banned cars for a week, the air ______ cleaner."', '[{"id":"a","text":"will be"},{"id":"b","text":"would be"},{"id":"c","text":"would have been"},{"id":"d","text":"is"}]'::jsonb, 'b', 'The if-clause uses the past simple "banned", which signals a second conditional (an imagined situation), so the main clause needs "would + base verb": "would be". (a) belongs to the first conditional, (c) to the third, and (d) is not conditional.', 5),
  ('b2f60586-bf58-5a2d-b577-39ed8ac710dc', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Writing: which sentence would be the best topic sentence for a paragraph summarising this text?', '[{"id":"a","text":"The mayor spoke to the local radio on Friday."},{"id":"b","text":"A clean-air week in Beni Khalled made the town healthier and is set to return."},{"id":"c","text":"Some people prefer cars to bicycles in summer."},{"id":"d","text":"For instance, the sky looked clearer by Friday."}]'::jsonb, 'b', 'A topic sentence is general and captures the whole idea: a successful clean-air week that will be repeated — exactly (b). (a) is a small detail (and inaccurate: the doctor spoke), (c) is off-topic, and (d) is a supporting example introduced by "For instance".', 6),
  ('037153f1-ec0e-5896-a66e-4371cc4ce27f', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

What is the writer''s main message?', '[{"id":"a","text":"Libraries should only lend books, not teach coding."},{"id":"b","text":"An attractive activity turned an ignored library into a popular place."},{"id":"c","text":"Teenagers never read books in their free time."},{"id":"d","text":"Saturday is the best day to open a library."}]'::jsonb, 'b', 'The text traces how free coding clubs drew teenagers and made the once-empty library the busiest place in town — that is the message. (a) contradicts the positive view of the clubs; (c) overgeneralises one detail; (d) is a minor detail, not the point.', 1),
  ('bdce6c1c-e193-542b-82a4-aa2d0b8fa00d', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

Language: in "students who had never borrowed a book", the relative word "who" is used because it refers to:', '[{"id":"a","text":"a place"},{"id":"b","text":"people (the students)"},{"id":"c","text":"a thing (the book)"},{"id":"d","text":"a possession"}]'::jsonb, 'b', '"Who" introduces a relative clause describing people — here "students". (a) a place would take "where", (c) a thing would take "which/that", and (d) possession would take "whose".', 2),
  ('0d8b0540-5dff-544a-9e9c-7de7022890e7', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read this paragraph a student wrote about the text:

"The library became popular for a clear reason. A young librarian offered free coding clubs. These clubs attracted curious teenagers. My uncle bought a new car last week. As a result, a quiet building turned into a lively place."

Writing: which sentence breaks the unity of the paragraph and should be removed?', '[{"id":"a","text":"\"A young librarian offered free coding clubs.\""},{"id":"b","text":"\"These clubs attracted curious teenagers.\""},{"id":"c","text":"\"My uncle bought a new car last week.\""},{"id":"d","text":"\"As a result, a quiet building turned into a lively place.\""}]'::jsonb, 'c', 'Every sentence develops one idea — why the library became popular — except "My uncle bought a new car last week", which is off-topic and breaks the unity. (a) and (b) give the reasons, and (d) is the logical conclusion ("As a result").', 3),
  ('ba654174-6d8d-52bd-9e69-852833432ecd', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

What can we infer about the teenagers?', '[{"id":"a","text":"They were attracted by the coding clubs more than by the books."},{"id":"b","text":"They had borrowed many books before the library opened."},{"id":"c","text":"They disliked the young librarian."},{"id":"d","text":"They only came to the library to sleep."}]'::jsonb, 'a', 'The crowds appeared after the coding clubs began, and many "had never borrowed a book before" — so the activity, not the books, drew them. (b) directly contradicts the text; (c) is unsupported and unlikely given the success; (d) is invented.', 4),
  ('9b387f8f-8611-5635-929f-c59100149417', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

Language: complete this third-conditional sentence about the story.

"If the librarian had not started the clubs, the library ______ empty."', '[{"id":"a","text":"would stay"},{"id":"b","text":"will stay"},{"id":"c","text":"would have stayed"},{"id":"d","text":"stays"}]'::jsonb, 'c', 'The if-clause uses the past perfect "had not started", which marks a third conditional about an unreal past, so the main clause needs "would have + past participle": "would have stayed". (a) is second conditional, (b) first conditional, and (d) is not conditional.', 5),
  ('a1db5805-5ef7-57c2-a2e3-3e4704b633e4', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text again, then look at these four sentences:

1. "However, success did not come at once."
2. "A new library opened in the neighbourhood."
3. "Therefore, it soon became the busiest place in town."
4. "Then free coding clubs began to attract teenagers."

Writing: what is the best order to form a well-organised paragraph?', '[{"id":"a","text":"2 – 1 – 4 – 3"},{"id":"b","text":"1 – 2 – 3 – 4"},{"id":"c","text":"2 – 3 – 4 – 1"},{"id":"d","text":"4 – 2 – 1 – 3"}]'::jsonb, 'a', 'Sentence 2 is the general opening (the library opened). 1 ("However, success did not come at once") sets up the slow start, 4 ("Then... coding clubs") gives the turning point, and 3 ("Therefore... busiest place") is the result and conclusion: 2 – 1 – 4 – 3. The connectors "However → Then → Therefore" confirm this chain.', 6),
  ('b17fa6aa-1461-5c2b-8a15-a5c8c98685f9', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'عند تحليل أيّ وثيقة في السبر، ما الخطوة الصحيحة قبل صياغة الاستنتاج؟', '[{"id":"a","text":"قراءة معطيات الوثيقة وملاحظتها بدقّة"},{"id":"b","text":"كتابة رأي شخصي دون النظر إلى الوثيقة"},{"id":"c","text":"حفظ الجواب النموذجي من درس آخر"},{"id":"d","text":"تجاهل المحاور والأرقام والاكتفاء بالعنوان"}]'::jsonb, 'a', 'الاستنتاج العلمي يُبنى على **قراءة معطيات الوثيقة** أوّلًا (المحاور، الأرقام، المقارنات). الرأي الشخصي أو الجواب المحفوظ من درس آخر لا يصلح، وتجاهل المحاور والأرقام يُفقد التحليل أساسه.', 1),
  ('835e6294-5255-5418-a045-122a6e29cc12', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'في وثيقة تجربة، يوجد دائمًا «شاهد» (témoin). ما فائدته؟', '[{"id":"a","text":"زيادة عدد الحيوانات في التجربة فقط"},{"id":"b","text":"المقارنة معه لكشف دور العامل المدروس"},{"id":"c","text":"تعويض الحالة المختبَرة إذا فشلت"},{"id":"d","text":"لا فائدة منه علميًّا"}]'::jsonb, 'b', 'الشاهد لم يخضع للعامل المدروس، فبـ **مقارنته بالحالة المختبَرة** نكشف أثر هذا العامل. لو غاب الشاهد لما أمكن نسبة النتيجة إلى العامل، فهو ركن أساسي في كلّ تجربة لا حشو.', 2),
  ('a7cca3a3-2469-5852-939d-d3c4ead4274c', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'نمط نووي لخليّة جسمية يُظهر 46 صبغيًّا منها زوج جنسي XX. ماذا نستنتج؟', '[{"id":"a","text":"ذكر سليم"},{"id":"b","text":"أنثى سليمة عدد صبغيّاتها طبيعي"},{"id":"c","text":"مصاب بالتثلّث الصبغي 21"},{"id":"d","text":"مشيج (خليّة تناسلية)"}]'::jsonb, 'b', 'العدد 46 صبغيًّا هو العدد **الطبيعي** لخلايا الجسم، والزوج **XX** يدلّ على **أنثى**. الذكر يكون XY، والتثلّث 21 يُظهر 47 صبغيًّا، والمشيج يحمل 23 صبغيًّا فقط لا 46.', 3),
  ('82d684ab-4f7e-5520-b7a0-07f77e425c40', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'بعد دخول جرثومة، يرتفع في الدم عدد جزيئات نوعية تلتصق بالجرثومة وتعدِمها. ما هذه الجزيئات؟', '[{"id":"a","text":"الأجسام المضادّة"},{"id":"b","text":"الكريّات الحمراء"},{"id":"c","text":"الصفيحات الدموية"},{"id":"d","text":"الهرمونات الجنسية"}]'::jsonb, 'a', 'الجزيئات النوعية التي تلتصق بالمستضدّ (الجرثومة) وتُبطل مفعوله هي **الأجسام المضادّة** التي تنتجها اللمفاويات. الكريّات الحمراء تنقل الأكسجين، والصفيحات تتدخّل في تخثّر الدم، والهرمونات الجنسية تنظّم التكاثر لا الدفاع.', 4),
  ('164792c0-f812-51c6-9e58-e21fc6524be9', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'تُظهر خريطة عالمية أنّ معظم البراكين والزلازل تتركّز في أشرطة ضيّقة لا عشوائيًّا. ماذا نستنتج؟', '[{"id":"a","text":"أنّها تقع صدفةً دون سبب"},{"id":"b","text":"أنّها تتمركز على حدود الصفائح التكتونية"},{"id":"c","text":"أنّها مرتبطة بكثافة السكّان"},{"id":"d","text":"أنّها مرتبطة بدرجة حرارة الجوّ"}]'::jsonb, 'b', 'تمركز البراكين والزلازل في أشرطة ضيّقة يطابق **حدود الصفائح التكتونية**، حيث تتحرّك الصفائح وتتفاعل. فهي ليست صدفة، ولا علاقة لها بعدد السكّان ولا بحرارة الجوّ بل بحركة الصفائح في باطن الأرض.', 5),
  ('ef8522fd-435d-56ab-b4dc-ede68b2083bc', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'أبوان سليمان ظاهريًّا أنجبا طفلًا مصابًا بمرض وراثي متنحٍّ. ما الاستنتاج الصحيح؟', '[{"id":"a","text":"أحد الأبوين فقط يحمل الحليل المعطوب"},{"id":"b","text":"كلا الأبوين مهجّن حامل للحليل المتنحّي دون أن يمرض"},{"id":"c","text":"المرض اكتُسب من المحيط"},{"id":"d","text":"كلا الأبوين مصاب بالمرض"}]'::jsonb, 'b', 'لظهور مرض **متنحٍّ** عند الطفل لا بدّ أن يرث الحليل المعطوب من **كلا الأبوين**. ولأنّهما سليمان ظاهريًّا فكلّ منهما **مهجّن حامل** (a//a لم يجتمع عندهما). لو حمله أحدهما فقط لما اجتمع الحليلان عند الطفل، والمرض وراثي لا مكتسب.', 6),
  ('f7c8264a-7ae5-51bd-bddb-800033867d8b', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'سُجّل زلزال مقداره 5.5 على سلّم ريشتر، لكنّ شدّته اختلفت بين مدينتين. ما التفسير الصحيح؟', '[{"id":"a","text":"خطأ في القياس لأنّ القيم يجب أن تتطابق"},{"id":"b","text":"المقدار قيمة واحدة (طاقة البؤرة)، والشدّة تختلف حسب الآثار على السطح"},{"id":"c","text":"المقدار أيضًا يختلف من مدينة لأخرى"},{"id":"d","text":"الشدّة والمقدار يقيسان الشيء نفسه"}]'::jsonb, 'b', '**المقدار** يقيس الطاقة المحرَّرة عند البؤرة وله **قيمة واحدة** لكلّ الزلزال، أمّا **الشدّة** فتقيس آثاره على السطح فتختلف من مدينة لأخرى حسب القرب من المركز ونوع التربة وجودة البناء. فلا خطأ ولا تطابق مطلوب، وهما مقياسان مختلفان.', 7),
  ('0c998b5b-0732-52b2-b5b8-50464d718eb2', '108a767e-ef6d-5ed7-ab54-f21275007d6b', 'بركان يقذف صهارة لزجة جدًّا فتنفجر بعنف؛ وآخر تنساب حممه بسهولة في شكل أنهار. ما الفرق الأساسي؟', '[{"id":"a","text":"لزوجة الصهارة: لزجة تعطي انفجاريًّا، وسائلة تعطي انسيابيًّا"},{"id":"b","text":"لون الصخور حول البركان فقط"},{"id":"c","text":"ارتفاع البركان فوق سطح البحر فقط"},{"id":"d","text":"عمر البركان بالسنوات"}]'::jsonb, 'a', 'تحدّد **لزوجة الصهارة** نوع البركان: الصهارة **اللزجة** تحبس الغازات فتنفجر (بركان انفجاري)، والصهارة **السائلة** تطلق غازاتها بسهولة فتنساب الحمم (بركان انسيابي). أمّا اللون والارتفاع والعمر فليست هي السبب في نمط الثوران.', 8),
  ('b026f476-b7d0-53d6-a42c-d33dc9346f14', 'd0a4b9c1-9dc9-5933-90b6-0440e41cf134', 'وثيقة 1 (منحنى موصوف): في الدورة الجنسية عند المرأة، يُظهر منحنى تركيز الأستروجين في الدم ارتفاعًا تدريجيًّا في النصف الأوّل من الدورة. ماذا يحدث في بطانة الرحم خلال هذه المرحلة بحسب هذا المعطى؟', '[{"id":"a","text":"تتثخّن بطانة الرحم استعدادًا لاستقبال بيضة مخصّبة"},{"id":"b","text":"تتمزّق بطانة الرحم وينزل الطمث"},{"id":"c","text":"تختفي المبايض نهائيًّا"},{"id":"d","text":"يتوقّف نموّ بطانة الرحم تمامًا"}]'::jsonb, 'a', 'ارتفاع الأستروجين في النصف الأوّل من الدورة يرافقه **تثخّن بطانة الرحم** تهيّؤًا لاستقبال بيضة مخصّبة. أمّا تمزّق البطانة ونزول الطمث فيحدث حين **ينخفض** الهرمون في نهاية الدورة، والمبايض لا تختفي بل تفرز الهرمون، والبطانة تنمو لا تتوقّف.', 1),
  ('e5a5c9eb-a834-5d75-bcad-77381e272fbe', 'd0a4b9c1-9dc9-5933-90b6-0440e41cf134', 'وثيقة 2 (نمط نووي): صورة نمط نووي لخليّة جسمية تُظهر 44 صبغيًّا جسميًّا + زوجًا جنسيًّا XY. ما الاستنتاج؟', '[{"id":"a","text":"أنثى عدد صبغيّاتها 46"},{"id":"b","text":"ذكر عدد صبغيّاته 46"},{"id":"c","text":"خليّة مشيج عدد صبغيّاتها 23"},{"id":"d","text":"مصاب بالتثلّث الصبغي 21"}]'::jsonb, 'b', '44 صبغيًّا جسميًّا (22 زوجًا) + الزوج الجنسي = **46 صبغيًّا**، والزوج **XY** يدلّ على **ذكر**. الأنثى تكون XX، والمشيج يحمل 23 صبغيًّا فقط، والتثلّث 21 يُظهر 47 صبغيًّا.', 2),
  ('119384f8-775b-5877-bb51-d79a249c6092', 'd0a4b9c1-9dc9-5933-90b6-0440e41cf134', 'وثيقة 3 (تجربة): حُقن فأر سليم بمصل يحتوي أجسامًا مضادّة ضدّ جرثومة معيّنة، ثمّ عُرّض للجرثومة فلم يمرض، بينما مرض الفأر الشاهد الذي لم يُحقَن. ماذا نستنتج عن دور الأجسام المضادّة؟', '[{"id":"a","text":"لا دور للأجسام المضادّة في الحماية"},{"id":"b","text":"الأجسام المضادّة الجاهزة وفّرت حماية فورية ضدّ الجرثومة"},{"id":"c","text":"الفأر الشاهد هو الذي تلقّى الحماية"},{"id":"d","text":"الجرثومة فقدت خطورتها تلقائيًّا"}]'::jsonb, 'b', 'الفأر الذي تلقّى **الأجسام المضادّة الجاهزة** نجا، بينما مرض الشاهد غير المحقون؛ فالمقارنة تكشف أنّ الأجسام المضادّة وفّرت **حماية فورية**. الشاهد هو الذي لم يُحقَن فمرض، والجرثومة لم تتغيّر، فالفرق سببه الأجسام المضادّة وحدها.', 3),
  ('caa4f222-487d-582c-8d2b-a38340ad43e7', 'd0a4b9c1-9dc9-5933-90b6-0440e41cf134', 'وثيقة 4 (سجلّ زلزالي): على مخطّط مرصاد زلزالي، تُسجَّل أوّلًا موجات سريعة ثمّ موجات أبطأ بعدها بثوانٍ. ما الموجات التي تصل أوّلًا؟', '[{"id":"a","text":"الموجات الأوّلية (P) لأنّها الأسرع"},{"id":"b","text":"الموجات الثانوية (S) لأنّها الأسرع"},{"id":"c","text":"الموجات السطحية لأنّها الأسرع"},{"id":"d","text":"كلّ الموجات تصل في اللحظة نفسها"}]'::jsonb, 'a', 'الموجات **الأوّلية P** هي الأسرع فتصل أوّلًا إلى المرصاد، ثمّ تتبعها الموجات **S** الأبطأ. الموجات السطحية تصل لاحقًا، والموجات لا تصل دفعة واحدة بل تتدرّج حسب سرعتها، وهذا الفارق يُستعمل لتحديد بُعد المركز.', 4),
  ('414e0c31-aab0-5146-bb58-141c67ae8324', 'd0a4b9c1-9dc9-5933-90b6-0440e41cf134', 'وثيقة 5 (خريطة): تُظهر خريطة أنّ بركانًا انفجاريًّا يقع قرب منطقة تتقارب فيها صفيحتان وتغوص إحداهما تحت الأخرى. ما العلاقة المستنتَجة؟', '[{"id":"a","text":"البركان مرتبط بتقارب الصفائح وغوص إحداها"},{"id":"b","text":"البركان يقع صدفةً دون علاقة بالصفائح"},{"id":"c","text":"البراكين توجد فقط بعيدًا عن حدود الصفائح"},{"id":"d","text":"تقارب الصفائح يمنع تكوّن البراكين"}]'::jsonb, 'a', 'عند **تقارب** صفيحتين وغوص إحداهما تنصهر الصخور في العمق فتتكوّن صهارة تغذّي البراكين الانفجارية؛ فالبركان **مرتبط بحدود الصفائح** لا صدفة. والبراكين تتمركز عند الحدود لا بعيدًا عنها، والتقارب يولّد البراكين لا يمنعها.', 5),
  ('e9eab2b3-9b80-5c2e-b4f5-e00a2f95827c', 'd0a4b9c1-9dc9-5933-90b6-0440e41cf134', 'وثيقة 6 (استرجاع وربط): مرحلتا الإلقاح وتعشيش البيضة المخصّبة. ما الترتيب الصحيح للأحداث بعد التقاء المشيجين؟', '[{"id":"a","text":"تعشيش في الرحم ← ثمّ إلقاح في المبيض"},{"id":"b","text":"إلقاح (اتّحاد المشيجين) ← تكوّن بيضة مخصّبة ← تعشيش في بطانة الرحم"},{"id":"c","text":"نزول الطمث ← ثمّ إلقاح ← ثمّ تعشيش"},{"id":"d","text":"تعشيش ثمّ تكوّن المشيجين بعده"}]'::jsonb, 'b', 'الترتيب الصحيح: **إلقاح** (اتّحاد النطفة بالبويضة) في البوق ← تكوّن **بيضة مخصّبة** ← انتقالها و**تعشيشها** في بطانة الرحم المتثخّنة. الإلقاح يسبق التعشيش لا العكس، ونزول الطمث يحدث عند غياب الحمل، والمشيجان يتكوّنان قبل الإلقاح لا بعد التعشيش.', 6),
  ('046c93e4-77f9-5230-b29d-ddfe9ce03aca', 'f75aa5c8-b6f1-5b2a-a974-53c289576c9e', 'وثيقة 1 (تجربة تلقيح): لُقّح فأر بجرثومة مُضعَفة فلم يمرض، ثمّ بعد أسابيع عُرّض للجرثومة نفسها قويّة فبقي سليمًا، بينما مرض الشاهد غير الملقَّح. ما المفهوم الذي تثبته هذه التجربة؟', '[{"id":"a","text":"أنّ التلقيح يمنح ذاكرة مناعية تحمي عند اللقاء اللاحق"},{"id":"b","text":"أنّ التلقيح يجعل الفأر مصدرًا لعدوى الآخرين"},{"id":"c","text":"أنّ الجرثومة المُضعَفة أخطر من القويّة"},{"id":"d","text":"أنّ المناعة صفة مكتسبة من المحيط دون تلقيح"}]'::jsonb, 'a', 'التلقيح بجرثومة مُضعَفة يحرّض الجسم على إنتاج خلايا **ذاكرة مناعية**، فعند اللقاء اللاحق بالجرثومة القويّة يستجيب بسرعة ويحمي الفرد؛ وهذا ما يفسّر نجاة الملقَّح ومرض الشاهد. التلقيح لا ينشر العدوى، والجرثومة المُضعَفة أقلّ خطرًا، والمناعة هنا نتجت عن التلقيح لا تلقائيًّا.', 1),
  ('ee636527-0f79-597b-a7bb-54627ae2c68c', 'f75aa5c8-b6f1-5b2a-a974-53c289576c9e', 'وثيقة 5 (مقارنة براكين): بركان (1) يقذف رمادًا وقنابل بانفجارات عنيفة، وبركان (2) تنساب منه حمم سائلة هادئة. ما الذي يفسّر هذا الاختلاف؟', '[{"id":"a","text":"لزوجة الصهارة وكمّية الغازات المحبوسة فيها"},{"id":"b","text":"لون الجبل المحيط بالبركان"},{"id":"c","text":"وقت الثوران من النهار"},{"id":"d","text":"ارتفاع البركان فقط دون أيّ عامل آخر"}]'::jsonb, 'a', 'الصهارة **اللزجة** تحبس الغازات فتتراكم حتّى تنفجر بعنف (بركان انفجاري كالبركان 1)، بينما الصهارة **السائلة** تطلق غازاتها بسهولة فتنساب حممها هادئة (بركان انسيابي كالبركان 2). أمّا اللون ووقت النهار والارتفاع وحده فلا تحدّد نمط الثوران.', 2),
  ('054b72f1-0cf5-5208-9abc-db23b8a7f5c6', 'f75aa5c8-b6f1-5b2a-a974-53c289576c9e', 'وثيقة 2 (منحنى مناعي): بعد أوّل تماس بمستضدّ يرتفع إنتاج الأجسام المضادّة ببطء وبكمّية قليلة؛ وبعد تماس ثانٍ بالمستضدّ نفسه يرتفع الإنتاج بسرعة وبكمّية أكبر بكثير. ما تفسير الفرق بين الاستجابتين؟', '[{"id":"a","text":"خطأ في القياس لأنّ الاستجابتين يجب أن تتطابقا"},{"id":"b","text":"وجود ذاكرة مناعية جعلت الاستجابة الثانية أسرع وأقوى"},{"id":"c","text":"أنّ المستضدّ صار غير ضارّ في المرّة الثانية"},{"id":"d","text":"أنّ الجسم نسي المستضدّ تمامًا"}]'::jsonb, 'b', 'الاستجابة الثانية أسرع وأقوى بسبب **خلايا الذاكرة** المتكوّنة بعد التماس الأوّل، وهذا أساس فعالية التلقيح. التطابق غير مطلوب، والمستضدّ لم يتغيّر، ولو نسيه الجسم لكانت الاستجابة الثانية مثل الأولى أو أضعف لا أقوى.', 3),
  ('9960b7cb-67d9-5091-804c-264916e830e4', 'f75aa5c8-b6f1-5b2a-a974-53c289576c9e', 'وثيقة 3 (شجرة نسب): مرض وراثي متنحٍّ؛ أبوان سليمان أنجبا بنتًا مصابة. ما تركيب الأبوين الوراثي؟ (A سليم سائد، a معطوب متنحٍّ)', '[{"id":"a","text":"كلاهما A//A نقيّ سليم"},{"id":"b","text":"كلاهما A//a مهجّن حامل"},{"id":"c","text":"كلاهما a//a مصاب"},{"id":"d","text":"أحدهما A//A والآخر a//a"}]'::jsonb, 'b', 'البنت المصابة تركيبها **a//a**، فأخذت a من كلّ والد. وبما أنّ الأبوين سليمان ظاهريًّا فكلّ منهما **A//a مهجّن حامل**. لو كانا A//A لما وجد a يُورَّث، ولو كانا a//a لكانا مصابين، ولو كان أحدهما a//a لظهر عليه المرض.', 4),
  ('c9130b00-19a9-5291-af93-4ac21f95250d', 'f75aa5c8-b6f1-5b2a-a974-53c289576c9e', 'وثيقة 4 (سجلّ زلزالي وحساب): سُجّل أنّ فرق وصول الموجات P و S في مرصاد A أكبر منه في مرصاد B. أيّ المرصدين أقرب إلى المركز السطحي؟', '[{"id":"a","text":"المرصد A لأنّ فرق الوصول أكبر"},{"id":"b","text":"المرصد B لأنّ فرق الوصول أصغر"},{"id":"c","text":"كلاهما على المسافة نفسها"},{"id":"d","text":"لا علاقة بين فرق الوصول والمسافة"}]'::jsonb, 'b', 'كلّما **قرب** المرصد من المركز السطحي **قلّ** فرق الوصول بين P و S، لأنّ الموجتين لم يتباعدا كثيرًا بعد. ففرق B الأصغر يدلّ على أنّه **الأقرب**، وفرق A الأكبر يدلّ على بُعده. فالعلاقة موجودة وليست منعدمة، والمسافتان مختلفتان.', 5),
  ('4cdbe792-5aa5-5b1e-8917-4e38aafe8a9d', 'f75aa5c8-b6f1-5b2a-a974-53c289576c9e', 'وثيقة 6 (تركيب جيولوجي): عند حدود متباعدة في وسط المحيط، تبتعد صفيحتان فتصعد صهارة وتتكوّن قشرة جديدة. ماذا يؤكّد هذا عن الصفائح؟', '[{"id":"a","text":"أنّ الصفائح ثابتة لا تتحرّك"},{"id":"b","text":"أنّ الصفائح متحرّكة وأنّ قشرة محيطية جديدة تتكوّن عند الحدود المتباعدة"},{"id":"c","text":"أنّ القشرة المحيطية لا تتجدّد أبدًا"},{"id":"d","text":"أنّ الصهارة تأتي من خارج الأرض"}]'::jsonb, 'b', 'تباعد الصفيحتين وصعود الصهارة لتكوين قشرة جديدة يؤكّدان أنّ **الصفائح متحرّكة** وأنّ القشرة المحيطية **تتجدّد** عند الحدود المتباعدة (ظهرات وسط المحيط). فالصفائح ليست ثابتة، والقشرة تتجدّد، والصهارة تأتي من **باطن الأرض** لا من خارجها.', 6),
  ('9f525f37-233a-5f0d-ac8a-101e8c60695a', '0487af90-2509-5724-a5e0-eb0262698181', 'وثيقة 2 (تجربة بلعمة): وُضعت كريّات بيضاء (بالعات) مع جراثيم تحت المجهر؛ لوحظ أنّها تحيط بالجرثومة ثمّ تُدخلها وتهضمها. ما الخطّ الدفاعي الذي تمثّله هذه الظاهرة؟', '[{"id":"a","text":"البلعمة، استجابة مناعية غير نوعية تبتلع الأجسام الغريبة"},{"id":"b","text":"إنتاج أجسام مضادّة نوعية فقط"},{"id":"c","text":"تخثّر الدم بالصفيحات"},{"id":"d","text":"نقل الأكسجين بالكريّات الحمراء"}]'::jsonb, 'a', 'إحاطة الخليّة بالجرثومة وابتلاعها وهضمها هي **البلعمة**، وهي استجابة مناعية **غير نوعية** تتصدّى لمختلف الأجسام الغريبة. إنتاج الأجسام المضادّة استجابة **نوعية** مختلفة، والتخثّر دور الصفيحات، ونقل الأكسجين دور الكريّات الحمراء لا البالعات.', 1),
  ('3980c44c-fcb3-56fb-ac2f-cc680e3bc354', '0487af90-2509-5724-a5e0-eb0262698181', 'وثيقة 1 (منحنيان هرمونيّان): في الدورة الجنسية، يبلغ منحنى هرمون LH قمّة حادّة في منتصف الدورة تقريبًا. أيّ حدث تكاثري يرتبط مباشرةً بهذه القمّة؟', '[{"id":"a","text":"الإباضة (انطلاق البويضة من المبيض)"},{"id":"b","text":"نزول الطمث"},{"id":"c","text":"تعشيش البيضة في الرحم"},{"id":"d","text":"تكوّن النطف عند الذكر"}]'::jsonb, 'a', 'القمّة الحادّة لهرمون **LH** في منتصف الدورة تحرّض **الإباضة** أي انطلاق البويضة من المبيض. نزول الطمث يحدث في نهاية الدورة عند انخفاض الهرمونات، والتعشيش يأتي لاحقًا بعد الإلقاح، وتكوّن النطف ظاهرة عند الذكر لا علاقة لها بدورة المرأة.', 2),
  ('f8892c5e-1330-504f-a41a-bb675f5c1df4', '0487af90-2509-5724-a5e0-eb0262698181', 'وثيقة 3 (تحديد الجنس واحتمال): زوجان لهما ثلاث بنات ويرغبان في معرفة احتمال أن يكون مولودهما القادم ذكرًا. ما الجواب الصحيح علميًّا؟', '[{"id":"a","text":"الاحتمال أعلى لأنّهم أنجبوا بنات سابقًا"},{"id":"b","text":"الاحتمال 50 ٪ لأنّ النطفة تحمل X أو Y مناصفةً في كلّ حمل"},{"id":"c","text":"الاحتمال 0 ٪ لأنّ الأمّ تحمل XX"},{"id":"d","text":"الأمّ هي من تحدّد الجنس فالاحتمال يعتمد عليها"}]'::jsonb, 'b', 'البويضة تحمل **X دائمًا**، والنطفة تحمل **X أو Y مناصفةً**، فاحتمال الذكر **50 ٪** في **كلّ** حمل بصرف النظر عن المواليد السابقين (لا ذاكرة للأحداث المستقلّة). الأب هو من يحدّد الجنس لا الأمّ، والاحتمال ليس صفرًا.', 3),
  ('54f8ca79-ef53-5d24-886e-63fe510c18ce', '0487af90-2509-5724-a5e0-eb0262698181', 'وثيقة 4 (ربط جيولوجي شامل): سجّلت منطقة زلازل متكرّرة وبراكين نشطة معًا، وهي تقع على حدّ بين صفيحتين متقاربتين. ما التفسير الموحِّد لاجتماع الظاهرتين؟', '[{"id":"a","text":"صدفة جغرافية لا تفسير لها"},{"id":"b","text":"حركة الصفائح عند الحدّ المتقارب تولّد الزلازل وتُنتج صهارة تغذّي البراكين"},{"id":"c","text":"الزلازل تمنع البراكين فلا يجتمعان عادةً"},{"id":"d","text":"مناخ المنطقة هو سبب الظاهرتين"}]'::jsonb, 'b', 'عند الحدّ **المتقارب** تحتكّ الصفيحتان وتغوص إحداهما؛ فالاحتكاك والتكسّر يولّدان **الزلازل**، والانصهار في العمق يُنتج **صهارة** تغذّي **البراكين**. فالظاهرتان نتاج العامل نفسه (حركة الصفائح) لا صدفة ولا مناخ، وهما تجتمعان عند هذه الحدود لا تتنافيان.', 4),
  ('206bcfff-bd62-505d-8053-b84a7be77070', '0487af90-2509-5724-a5e0-eb0262698181', 'وثيقة 5 (شدّة ومقدار وخريطة): زلزال واحد مقداره 7؛ سُجّلت أعلى شدّة قرب المركز السطحي وأقلّ شدّة في مدينة بعيدة ذات تربة صخرية صلبة. ما الاستنتاج المركّب الصحيح؟', '[{"id":"a","text":"المقدار يتغيّر بين المدينتين تبعًا للشدّة"},{"id":"b","text":"المقدار واحد للزلزال، والشدّة تقلّ بالابتعاد وتتأثّر بنوع التربة"},{"id":"c","text":"الشدّة ثابتة في كلّ مكان والمقدار هو المتغيّر"},{"id":"d","text":"التربة الصلبة ترفع الشدّة دائمًا"}]'::jsonb, 'b', '**المقدار** قيمة واحدة للزلزال (7) تقيس طاقة البؤرة، بينما **الشدّة** تقيس الآثار فتقلّ بالابتعاد عن المركز وتتأثّر بنوع التربة؛ والتربة الصخرية الصلبة تقلّل الاهتزاز فتخفّض الشدّة. فالمقدار لا يتغيّر، والشدّة هي المتغيّرة، والتربة الصلبة تخفّض الشدّة لا ترفعها.', 5),
  ('8acacd40-bb84-5042-9994-b598af9f5a55', '0487af90-2509-5724-a5e0-eb0262698181', 'وثيقة 6 (تركيب الوراثة والصبغيّات): نمط نووي يُظهر 47 صبغيًّا، مع ثلاث نسخ من الصبغيّ رقم 21 وزوج جنسي XX. ما التشخيص والاستنتاج عن أصل الخلل؟', '[{"id":"a","text":"ذكر مصاب بمرض متنحٍّ في حليل واحد"},{"id":"b","text":"أنثى مصابة بمتلازمة داون بسبب خلل في عدد الصبغيّات (تثلّث 21)"},{"id":"c","text":"أنثى سليمة عدد صبغيّاتها طبيعي"},{"id":"d","text":"مشيج به طفرة في حليل"}]'::jsonb, 'b', 'العدد **47** مع **ثلاث نسخ من الصبغيّ 21** = **متلازمة داون (التثلّث 21)**، والزوج **XX** يدلّ على **أنثى**؛ والخلل في **عدد الصبغيّات** لا في حليل مفرد. فالزوج XX لا يدلّ على ذكر، والعدد 47 ليس طبيعيًّا، والمشيج يحمل 23 لا 47، والسبب اختلال عددي لا طفرة حليل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

