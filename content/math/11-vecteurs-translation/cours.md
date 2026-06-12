# ⚔️ الأشعّة والانسحاب — سلاح الاتجاه والقوّة

> 💡 «الشعاع هو سلاحك في المستوي: له نقطة انطلاق، واتجاه، ومنحى، وطول. أتقنه تفتح أبواب الهندسة التحليلية.»

## 🏰 تعريف الشعاع

الشعاع هو **قطعة مستقيمة مزوّدة باتجاه ومنحى**. نرمز للشعاع الذي منشأه A وطرفه B بـ $\overrightarrow{AB}$.

للشعاع $\overrightarrow{AB}$ أربع خصائص:

- **المنشأ**: النقطة A، وهي نقطة الانطلاق.
- **الاتجاه**: المستقيم الحامل للشعاع (أي المستقيم AB).
- **المنحى**: من A نحو B (وهو عكس منحى $\overrightarrow{BA}$).
- **الطول**: هو طول القطعة [AB]، ويُكتب $\|\overrightarrow{AB}\|$.

> 🗡️ لا تخلط بين $\overrightarrow{AB}$ و $\overrightarrow{BA}$: لهما نفس الاتجاه والطول، لكنّهما متعاكسا المنحى!

## ⚡ تساوي شعاعين

شعاعان **متساويان** إذا تشاركا نفس الاتجاه ونفس المنحى ونفس الطول (المنشأ قد يختلف).

$$ \overrightarrow{AB} = \overrightarrow{CD} \iff \text{نفس الاتجاه + نفس المنحى + نفس الطول} $$

**نتيجة هندسية**: $\overrightarrow{AB} = \overrightarrow{CD}$ إذا وفقط إذا كان ABDC متوازي أضلاع (أي إذا كان للقطعتَين [AD] و[BC] المنتصف نفسه).

مثال: إذا كان ABCD متوازي أضلاع فإنّ $\overrightarrow{AB} = \overrightarrow{DC}$ و $\overrightarrow{AD} = \overrightarrow{BC}$.

> ⚠️ الفخّ: $\overrightarrow{AB} = \overrightarrow{DC}$ وليس $\overrightarrow{CD}$! في متوازي الأضلاع الضلعان المتوازيان متساويان في المنحى أيضًا.

## 🛡️ الانسحاب الذي شعاعه معطى

**الانسحاب ذو الشعاع $\overrightarrow{u}$** هو تحويل هندسي ينقل كلّ نقطة M إلى نقطة M' بحيث:

$$ \overrightarrow{MM'} = \overrightarrow{u} $$

نقول إنّ M' هي **صورة** النقطة M بالانسحاب ذي الشعاع $\overrightarrow{u}$. وعكسيًّا، نقول إنّ M هي **سابقة** النقطة M' بهذا الانسحاب: للعودة من الصورة إلى السابقة ننسحب بالشعاع المعاكس $-\overrightarrow{u}$.

**مثال محلول:** لتكن A وB نقطتين بحيث AB = 3 cm. صورة النقطة M بالانسحاب ذي الشعاع $\overrightarrow{AB}$ هي النقطة M' التي تحقّق $\overrightarrow{MM'} = \overrightarrow{AB}$: نرسم انطلاقًا من M، موازيًا لـ (AB) وفي منحى B، القطعة [MM'] بطول 3 cm — فيكون الرباعي ABM'M متوازي أضلاع.

**خصائص الانسحاب:**

- يحفظ الأطوال: $MM' = AB$ (إذا كان $\overrightarrow{AB} = \overrightarrow{u}$).
- يحفظ الزوايا والأشكال (يحفظ الشكل مع تغيير الموضع فقط).
- صورة مستقيم هي مستقيم **موازٍ** له.
- صورة قطعة هي قطعة مساوية لها في الطول.

| الصورة بالانسحاب $\overrightarrow{u} = \overrightarrow{AB}$ | الشكل الأصلي                | ملاحظة                 |
| ----------------------------------------------------------- | --------------------------- | ---------------------- |
| نقطة M' بحيث $\overrightarrow{MM'} = \overrightarrow{u}$    | نقطة M                      | MM' = AB               |
| مستقيم موازٍ للمستقيم (d)                                   | مستقيم (d)                  | تحفّظ الموازاة         |
| مثلّث مساوٍ في الشكل والحجم                                 | مثلّث                       | تحفّظ الأطوال والزوايا |
| دائرة مركزها I' (صورة I) وبنفس نصف القطر r                  | دائرة مركزها I ونصف قطرها r | تحفّظ نصف القطر        |

## 🔮 جمع الأشعّة وعلاقة شال (Chasles)

**قاعدة شال (Chasles):**

$$\boxed{\overrightarrow{AB} + \overrightarrow{BC} = \overrightarrow{AC}}$$

هذه العلاقة تقول: للانتقال من A إلى C، يمكنني المرور بأيّ نقطة وسطى B.

**تعميم:** لأيّ نقطة وسطى O:

$$\overrightarrow{AB} = \overrightarrow{AO} + \overrightarrow{OB}$$

**نتيجة مهمّة — الشعاع المعاكس:**

$$\overrightarrow{AB} + \overrightarrow{BA} = \overrightarrow{AA} = \overrightarrow{0}$$

إذن $\overrightarrow{BA} = -\overrightarrow{AB}$ (الشعاع المعاكس يُعكس المنحى فقط).

**طرح شعاعين:** طرحُ شعاعٍ هو جمعُ معاكسِه:

$$\overrightarrow{u} - \overrightarrow{v} = \overrightarrow{u} + (-\overrightarrow{v})$$

**مثال محلول:** $\overrightarrow{AC} - \overrightarrow{AB} = \overrightarrow{AC} + \overrightarrow{BA} = \overrightarrow{BA} + \overrightarrow{AC} = \overrightarrow{BC}$ بعلاقة شال.

> 🏆 حيلة البطل: عندما تجد مجموعًا من الأشعّة، اربط طرف الشعاع الأوّل بمنشأ الشعاع الثاني — وإذا تطابقا تطبق شال مباشرة!

## 🧮 تبسيط مجموع أشعّة باستخدام شال

لحساب $\overrightarrow{AC} + \overrightarrow{CA}$: نلاحظ أنّ $\overrightarrow{CA} = -\overrightarrow{AC}$، إذن الناتج هو $\overrightarrow{0}$.

لحساب $\overrightarrow{AB} + \overrightarrow{BC} + \overrightarrow{CD}$: نطبّق شال تدريجيًا:

$$\overrightarrow{AB} + \overrightarrow{BC} = \overrightarrow{AC} \quad \Rightarrow \quad \overrightarrow{AC} + \overrightarrow{CD} = \overrightarrow{AD}$$

**مبدأ المسار المغلق:** مجموع أشعّة مسار يعود إلى نقطة انطلاقه هو الشعاع الصفري:

$$\overrightarrow{AB} + \overrightarrow{BC} + \overrightarrow{CA} = \overrightarrow{AC} + \overrightarrow{CA} = \overrightarrow{0}$$

وفي الأشكال المركّبة (كالسداسي المنتظم)، عوّض كلّ شعاع بشعاع يساويه قبل التجميع، حتى تتسلسل الحروف ويُغلق المسار.

**مثال محلول:** إذا كان ABCD متوازي أضلاع ومركزه O، احسب $\overrightarrow{OA} + \overrightarrow{OC}$.

بما أنّ O منتصف [AC]، فإنّ $\overrightarrow{OA} = -\overrightarrow{OC}$، إذن $\overrightarrow{OA} + \overrightarrow{OC} = \overrightarrow{0}$.

## 🏅 متوازي الأضلاع وتساوي الأشعّة

**الخاصيّة الأساسية:**

ABCD متوازي أضلاع $\iff$ $\overrightarrow{AB} = \overrightarrow{DC}$

معنى ذلك أنّ الضلعَين [AB] و[DC] متوازيان ومتساويان في الطول وبالمنحى نفسه.

**النتائج:**

- $\overrightarrow{AB} = \overrightarrow{DC}$ و $\overrightarrow{AD} = \overrightarrow{BC}$
- مركز متوازي الأضلاع O هو منتصف كلّ من [AC] و [BD]
- $\overrightarrow{OA} + \overrightarrow{OB} + \overrightarrow{OC} + \overrightarrow{OD} = \overrightarrow{0}$ إذا كان O المركز

**قاعدة متوازي الأضلاع للجمع:** مجموع شعاعين لهما **نفس المنشأ** هو شعاع قطر متوازي الأضلاع المبنيّ عليهما. في متوازي الأضلاع ABCD:

$$\overrightarrow{BA} + \overrightarrow{BC} = \overrightarrow{BD}$$

**مثال:** بما أنّ $\overrightarrow{BC} = \overrightarrow{AD}$، فإنّ $\overrightarrow{BA} + \overrightarrow{BC} = \overrightarrow{BA} + \overrightarrow{AD} = \overrightarrow{BD}$ بعلاقة شال.

> 🗡️ ملخّص القتال: علاقة شال = سلاحك الأوّل؛ الشعاع المعاكس = درعك؛ متوازي الأضلاع = ميدانك.

> 🏆 اجتزت بوّابة الأشعّة: شال، المعاكس، الطرح، وقاعدة متوازي الأضلاع كلّها في جعبتك. في الفصل القادم يدخل الشعاع المعلّمَ — وتتحوّل الهندسة كلّها إلى حساب!
