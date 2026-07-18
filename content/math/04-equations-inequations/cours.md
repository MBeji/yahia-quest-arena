# ⚔️ المعادلات والمتراجحات — ساحة المجهول

> 💡 «المعادلة هي سؤال رياضي: ما العدد المجهول الذي يجعل الطرفين متساويين؟ المتراجحة تسأل: في أيّ منطقة يعيش هذا المجهول؟»

## 🏰 تعريف المعادلة من الدرجة الأولى

**المعادلة من الدرجة الأولى بمجهول واحد** هي عبارة من الشكل:

$$ ax + b = 0 حيث a ≠ 0 $$

أو ما يمكن اختزاله إليه. المجهول هو x، وهدفنا إيجاد القيمة التي تجعل المعادلة صحيحة.

أمثلة على معادلات من الدرجة الأولى:

- 2x − 5 = 0
- 3x + 7 = 4x − 1
- 2(x + 3) = 10

> 🗡️ المعادلة من الدرجة الثانية تحتوي x²، لذا لا تشتبه بين الدرجتين.

## ⚡ حلّ المعادلة من الدرجة الأولى

**الفكرة الأساسية**: نُجري العملية نفسها على **طرفي المعادلة** دون تغيير صحّتها، حتى نعزل المجهول.

**الخطوات**:

1. نوسّع الأقواس (إن وجدت).
2. ننقل حدود x إلى الطرف الأيسر وحدود الأعداد إلى الطرف الأيمن.
3. نجمع الحدود المتشابهة.
4. نقسم على معامل x.

**مثال مفصّل**:

$$ 3x + 7 = x + 15 $$

- ننقل x إلى اليسار: 3x − x + 7 = 15
- نجمع: 2x + 7 = 15
- ننقل 7 إلى اليمين: 2x = 15 − 7 = 8
- نقسم على 2: x = 4

**التحقّق**: 3(4) + 7 = 19 وx + 15 = 4 + 15 = 19 ✓

> ⚠️ تحقّق دائمًا بتعويض الحلّ في المعادلة الأصلية!

## 🛡️ مبدأ الجداء المعدوم

**القاعدة الذهبية**: إذا كان جداء عددين يساوي الصفر، فإنّ أحد العددين لا بدّ أن يكون صفرًا:

$$ a × b = 0 ⟺ a = 0 أو b = 0 $$

هذه القاعدة تُمكّننا من حلّ المعادلات التي على شكل جداء:

**مثال**:

$$ (x − 3)(x + 5) = 0 $$

بتطبيق المبدأ:

- إمّا x − 3 = 0 → x = 3
- أو x + 5 = 0 → x = −5

إذن الحلول هي: x = 3 أو x = −5 (هذه النوعية تظهر في معادلات الدرجة الثانية لكن المبدأ نفسه).

**مثال آخر** بمعادلة على شكل جداء عاملَين من الدرجة الأولى (صيغتها المنشورة من الدرجة الثانية):

$$ 2x(3x − 6) = 0 $$

- إمّا 2x = 0 → x = 0
- أو 3x − 6 = 0 → 3x = 6 → x = 2

> 💡 الجداء المعدوم لا يعمل للجمع: a + b = 0 **لا** يعني a = 0 أو b = 0!

## 🔮 تعريف المتراجحة من الدرجة الأولى

**المتراجحة** هي عبارة تستخدم علامات < ، > ، ≤ ، أو ≥ بدلًا من =.

المتراجحة من الدرجة الأولى:

$$ ax + b < 0 أو ax + b > 0 أو ax + b ≤ 0 أو ax + b ≥ 0 $$

الحلّ ليس عددًا واحدًا بل **مجموعة من الأعداد** يمكن تمثيلها على مستقيم أو بشكل مجال.

## 🧪 حلّ المتراجحة من الدرجة الأولى

::: figure حلُّ المتراجحة نصفُ مستقيم: دائرةٌ مفتوحة عند < وممتلئة عند ≤، والسهمُ نحو الحلول
<svg viewBox="0 0 360 175"><path d="M20 56 H318" stroke="#1f2937" stroke-width="1.8"/><path d="M318 56 l-8 -4 v8 z" fill="#1f2937"/><path d="M34 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="34.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-4</text><path d="M61 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="61.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-3</text><path d="M88 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="88.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-2</text><path d="M115 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="115.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-1</text><path d="M142 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="142.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">0</text><path d="M169 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="169.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><path d="M196 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="196.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><path d="M223 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="223.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><path d="M250 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="250.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><path d="M277 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="277.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><path d="M304 52 V60" stroke="#1f2937" stroke-width="1.2"/><text x="304.0" y="73.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><path d="M24 49 H277" stroke="#b91c1c" stroke-width="4"/><circle cx="277" cy="49" r="5" fill="#ffffff" stroke="#b91c1c" stroke-width="2"/><text x="277.0" y="36.0" text-anchor="middle" font-size="12" font-weight="700" fill="#b91c1c" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">x < 5</text><text x="150.5" y="36.0" text-anchor="middle" font-size="11" font-weight="700" fill="#b91c1c" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">]−∞ ; 5[</text><path d="M20 132 H318" stroke="#1f2937" stroke-width="1.8"/><path d="M318 132 l-8 -4 v8 z" fill="#1f2937"/><path d="M34 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="34.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-4</text><path d="M61 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="61.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-3</text><path d="M88 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="88.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-2</text><path d="M115 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="115.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">-1</text><path d="M142 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="142.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">0</text><path d="M169 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="169.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><path d="M196 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="196.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><path d="M223 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="223.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><path d="M250 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="250.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><path d="M277 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="277.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><path d="M304 128 V136" stroke="#1f2937" stroke-width="1.2"/><text x="304.0" y="149.0" text-anchor="middle" font-size="9" font-weight="700" fill="#1f2937" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><path d="M61 125 H314" stroke="#15803d" stroke-width="4"/><circle cx="61" cy="125" r="5" fill="#15803d" stroke="#15803d" stroke-width="2"/><text x="61.0" y="112.0" text-anchor="middle" font-size="12" font-weight="700" fill="#15803d" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">x ≥ −3</text><text x="187.5" y="112.0" text-anchor="middle" font-size="11" font-weight="700" fill="#15803d" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">[−3 ; +∞[</text></svg>
:::

الخطوات **مطابقة لحلّ المعادلة**، مع قاعدة إضافية واحدة حاسمة:

| العملية                        | أثرها على إشارة التراجح |
| ------------------------------ | ----------------------- |
| الجمع أو الطرح بعدد من الطرفين | **لا تغيير** في الإشارة |
| الضرب أو القسمة بعدد **موجب**  | **لا تغيير** في الإشارة |
| الضرب أو القسمة بعدد **سالب**  | **قلب الإشارة**         |

**مثال 1** (لا قلب):

$$ 3x − 6 < 9 $$

- نجمع 6 للطرفين: 3x < 15
- نقسم على 3 (موجب → لا قلب): x < 5
- الحلّ: x ∈ ]−∞ ; 5[

**مثال 2** (مع القلب):

$$ −2x + 1 ≤ 7 $$

- نطرح 1 من الطرفين: −2x ≤ 6
- نقسم على −2 **(سالب → قلب الإشارة)**: x ≥ −3
- الحلّ: x ∈ [−3 ; +∞[

> ⚠️ الفخّ الأشهر: نسيان قلب إشارة التراجح عند القسمة على عدد **سالب**. هذا الخطأ يقلب الحلّ تمامًا!

## ⚖️ المتراجحة المزدوجة

أحيانًا يكون المجهول محصورًا بين طرفَين. القاعدة: **نُجري العملية نفسها على الأطراف الثلاثة** في آنٍ واحد.

**مثال**:

$$ −3 ≤ 2x − 5 < 7 $$

- نجمع 5 للأطراف الثلاثة: 2 ≤ 2x < 12
- نقسم على 2 (موجب → لا قلب): 1 ≤ x < 6

> 🗡️ إذا أُعطيت شرطَين منفصلَين (مثل x > 1 و x < 6) فالحلّ هو **تقاطع الشرطين**: 1 < x < 6؛ والحلول الصحيحة (الأعداد الطبيعية الممكنة) هنا هي 2 و3 و4 و5.

## 📐 تمثيل حلول المتراجحة على المستقيم

بعد إيجاد الحلّ، نمثّله بيانيًا:

- **x > a**: نرسم سهمًا إلى اليمين من a مع دائرة **مفتوحة** عند a (غير مشمول).
- **x ≥ a**: نرسم سهمًا إلى اليمين من a مع دائرة **مملوءة** عند a (مشمول).
- **x < a**: نرسم سهمًا إلى اليسار من a مع دائرة مفتوحة.
- **a ≤ x ≤ b**: نظلّل القطعة بين a وb مع دوائر ملائمة على الطرفين.

مثال: الحلّ x ≥ −3 يُمثَّل بسهم إلى اليمين من −3 مع دائرة مملوءة.

## 🧮 معادلات تستلزم النشر أوّلًا

أحيانًا تحتاج إلى نشر الأقواس قبل الحلّ:

**مثال**:

$$ 2(x + 3) − 4 = 3(x − 1) $$

- نوسّع: 2x + 6 − 4 = 3x − 3
- نبسّط: 2x + 2 = 3x − 3
- ننقل: 2 + 3 = 3x − 2x → 5 = x
- الحلّ: x = 5

**التحقّق**: 2(5 + 3) − 4 = 16 − 4 = 12 و 3(5 − 1) = 12 ✓

## 🧭 ترجمة المسائل إلى معادلات

كثير من المسائل اللفظية تُحَلّ بمعادلة. **الطريقة**: سمِّ المجهول x → أنشئ معادلة لكلّ شرط في المسألة → حلّ → فسّر النتيجة في سياق المسألة.

**مثال**: عمر الأب ضعف عمر الابن، ومجموع عمريهما 36 سنة. ما عمر كلٍّ منهما؟

- نسمّي عمر الابن x، فيكون عمر الأب 2x.
- المجموع: x + 2x = 36 → 3x = 36 → x = 12.
- التفسير: عمر الابن 12 سنة وعمر الأب 24 سنة. **التحقّق**: 24 = 2 × 12 ✓ و 12 + 24 = 36 ✓

> ⚠️ انتبه: المطلوب قد يكون غير المجهول الذي سمّيته — هنا لو سُئلت عن عمر الأب فالجواب 24 وليس 12.

> 🏆 أتقنتَ أدوات المعادلات والمتراجحات! ستجدها في كلّ باب رياضي: الهندسة، الدوالّ، والمسائل التطبيقية. قاعدة قلب الإشارة هي الحارس الأمين لحلولك.
