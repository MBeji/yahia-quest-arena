# ⚔️ القسمة الإقليدية — فنّ التوزيع بالعدل

> 💡 «عندك كنزٌ وتريد قسمته على رفاقك بالتساوي؟ القسمة هي السلاح الذي يقول لك: كم لكلّ واحد؟ وكم يتبقّى؟»

أهلًا بك أيّها البطل! تعرف الآن **الضرب**، وهو جمعُ العدد نفسِه مرّاتٍ كثيرة. اليوم نتعلّم عمليّته العكسيّة: **القسمة**. بها نوزّع كميّةً على مجموعاتٍ متساوية، فنعرف نصيب كلّ مجموعة، وكم يتبقّى خارج التوزيع.

## 🏰 ما معنى القسمة؟

للقسمة معنيان، وكلاهما يقودنا إلى العمليّة نفسها:

- **التوزيع بالتساوي:** عندك 12 جوهرة توزّعها على 3 صناديق بالعدل. كم جوهرةً في كلّ صندوق؟ الجواب 4، لأنّ 3 × 4 = 12.
- **التجميع:** عندك 12 جوهرة وتضع في كلّ صندوقٍ 4 جواهر. كم صندوقًا تملأ؟ الجواب 3 صناديق.

في الحالتين نكتب العمليّة بعلامة القسمة ÷ هكذا:

$$12 ÷ 3 = 4$$

ونقرؤها «**12 مقسومًا على 3 يساوي 4**». القسمة إذن هي البحث عن العدد الذي إذا ضربناه في المقسوم عليه أعطانا المقسوم.

## 🧮 مصطلحات القسمة

لكلّ عددٍ في القسمة اسمٌ خاصّ. تأمّل المثال 13 ÷ 4:

| المصطلح          | المعنى                               | في 13 ÷ 4 |
| ---------------- | ------------------------------------ | --------- |
| **المقسوم**      | العدد الذي نوزّعه (الكميّة الأصليّة) | 13        |
| **المقسوم عليه** | عدد المجموعات (أو نصيب المجموعة)     | 4         |
| **الخارج**       | نصيب كلّ مجموعة (نتيجة القسمة)       | 3         |
| **الباقي**       | ما يتبقّى ولا يكفي لتوزيعٍ جديد      | 1         |

في 13 ÷ 4: نوزّع 13 على 4، فيأخذ كلٌّ منها 3 (هذا الخارج)، ويتبقّى 1 (هذا الباقي) لأنّ 4 × 3 = 12 و 13 − 12 = 1.

> 🗡️ لا تخلط بين **الخارج** و**الباقي**: الخارج هو النصيب (كم لكلّ مجموعة)، والباقي هو الفائض (ما لم يُوزَّع).

## 🔮 العلاقة الأساسيّة

::: figure أربعُ حصصٍ متساوية من ثلاث جواهر، وجوهرةٌ واحدة تبقى دون توزيع
<svg viewBox="0 0 340 170"><rect x="24" y="34" width="56" height="60" rx="5" fill="#fef3c7" stroke="#1f2937" stroke-width="2"/><path d="M29 47.6 L40 41 L51 47.6 L40 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M53 47.6 L64 41 L75 47.6 L64 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M29 73.6 L40 67 L51 73.6 L40 89 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><text x="52.0" y="110.0" text-anchor="middle" font-size="14" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="92" y="34" width="56" height="60" rx="5" fill="#fef3c7" stroke="#1f2937" stroke-width="2"/><path d="M97 47.6 L108 41 L119 47.6 L108 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M121 47.6 L132 41 L143 47.6 L132 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M97 73.6 L108 67 L119 73.6 L108 89 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><text x="120.0" y="110.0" text-anchor="middle" font-size="14" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="160" y="34" width="56" height="60" rx="5" fill="#fef3c7" stroke="#1f2937" stroke-width="2"/><path d="M165 47.6 L176 41 L187 47.6 L176 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M189 47.6 L200 41 L211 47.6 L200 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M165 73.6 L176 67 L187 73.6 L176 89 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><text x="188.0" y="110.0" text-anchor="middle" font-size="14" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="228" y="34" width="56" height="60" rx="5" fill="#fef3c7" stroke="#1f2937" stroke-width="2"/><path d="M233 47.6 L244 41 L255 47.6 L244 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M257 47.6 L268 41 L279 47.6 L268 63 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M233 73.6 L244 67 L255 73.6 L244 89 Z" fill="#38bdf8" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><text x="256.0" y="110.0" text-anchor="middle" font-size="14" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="290" y="118" width="40" height="40" rx="5" fill="#fee2e2" stroke="#dc2626" stroke-width="2.5" stroke-dasharray="5 3"/><path d="M299 133.6 L310 127 L321 133.6 L310 149 Z" fill="#f87171" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><text x="258.0" y="144.0" text-anchor="end" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">الباقي</text><text x="150.0" y="164.0" text-anchor="middle" font-size="15" font-weight="700" fill="#15803d" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">13 = (4 × 3) + 1</text></svg>
:::

كلّ قسمةٍ تخضع لقاعدةٍ ذهبيّة تربط أعدادها الأربعة:

$$المقسوم = (المقسوم عليه × الخارج) + الباقي$$

ومعها شرطٌ لا يُخالَف أبدًا: **الباقي < المقسوم عليه**. فلو كان الباقي يساوي المقسوم عليه أو أكبر منه، لَأمكن توزيعه مرّةً أخرى، فالخارج لم يكتمل بعدُ.

_مثال محسوب:_ في 13 ÷ 4 وجدنا الخارج 3 والباقي 1. نتحقّق: (4 × 3) + 1 = 12 + 1 = 13 ✓، والباقي 1 أصغر من المقسوم عليه 4 ✓. القسمة صحيحة.

> ⚠️ الفخّ الأشهر: ترك باقٍ ≥ المقسوم عليه. مثلًا في 13 ÷ 4 لا يصحّ أن نقول «الخارج 2 والباقي 5»، لأنّ 5 ليست أصغر من 4؛ يجب أن نأخذ 4 مرّةً أخرى فيصير الخارج 3 والباقي 1.

::: figure الباقي أصغر من المقسوم عليه، دائمًا
<svg viewBox="0 0 340 132"><rect x="16" y="24" width="150" height="80" rx="8" fill="#dcfce7" stroke="#16a34a" stroke-width="2.5"/><text x="91.0" y="48.0" text-anchor="middle" font-size="11" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">الباقي أصغر من المقسوم عليه</text><text x="91.0" y="74.0" text-anchor="middle" font-size="17" font-weight="700" fill="#15803d" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1 < 4</text><text x="91.0" y="90.0" text-anchor="middle" font-size="11" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">قسمة صحيحة ✓</text><rect x="182" y="24" width="150" height="80" rx="8" fill="#fee2e2" stroke="#dc2626" stroke-width="2.5"/><text x="257.0" y="48.0" text-anchor="middle" font-size="11" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">الباقي ليس أصغر من المقسوم عليه</text><text x="257.0" y="74.0" text-anchor="middle" font-size="17" font-weight="700" fill="#b91c1c" direction="ltr" unicode-bidi="isolate" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5 ≥ 4</text><text x="257.0" y="90.0" text-anchor="middle" font-size="11" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">خطأ ✗</text><text x="170.0" y="124.0" text-anchor="middle" font-size="11" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">هذه هي العلامة التي تُميّز القسمة الصحيحة</text></svg>
:::

## 🛡️ القسمة المنصوبة على عددٍ ذي رقمٍ واحد

عندما يكبر المقسوم نستعمل **القسمة المنصوبة**: نقسم رقمًا رقمًا من اليسار إلى اليمين. لنقسم 75 ÷ 5:

- **رقم العشرات:** 7 ÷ 5 يعطي 1 (نكتب 1 في الخارج)، والباقي 7 − 5 = 2.
- **ننزّل رقم الآحاد** 5 بجانب الباقي 2 فنحصل على 25.
- **رقم الآحاد:** 25 ÷ 5 يعطي 5 (نكتب 5 في الخارج)، والباقي 25 − 25 = 0.

إذن 75 ÷ 5 = 15 والباقي 0. نتحقّق: (5 × 15) + 0 = 75 ✓.

جرّب مثالًا أكبر، 98 ÷ 4:

- **رقم العشرات:** 9 ÷ 4 يعطي 2، والباقي 9 − 8 = 1.
- **ننزّل** رقم الآحاد 8 بجانب 1 فنحصل على 18.
- **رقم الآحاد:** 18 ÷ 4 يعطي 4، والباقي 18 − 16 = 2.

إذن 98 ÷ 4 = 24 والباقي 2. نتحقّق: (4 × 24) + 2 = 96 + 2 = 98 ✓.

> 🗡️ في كلّ خطوةٍ يجب أن يكون الباقي الجزئيّ أصغر من المقسوم عليه قبل أن تنزّل الرقم الموالي. إن كان أكبر فقد اخترت رقمًا صغيرًا في الخارج.

## 🧪 القسمة التامّة والقسمة بباقٍ

نميّز بين حالتين حسب الباقي:

- **قسمة تامّة:** الباقي = 0، أي أنّ التوزيع تمّ بالكامل دون فائض. مثل 12 ÷ 3 = 4 (الباقي 0). نقول إنّ 12 **مضاعفٌ** للعدد 3.
- **قسمة بباقٍ:** الباقي ≠ 0، أي يتبقّى فائضٌ لا يكفي لتوزيعٍ جديد. مثل 13 ÷ 4 = 3 والباقي 1.

## 📐 حلّ المسائل: نصيب أم عدد مجموعات؟

في المسائل اقرأ السؤال جيّدًا لتعرف ما تبحث عنه:

- إن سُئلت عن **نصيب كلّ مجموعة** أو **عدد المجموعات**، فالجواب هو **الخارج**.
- إن سُئلت عمّا **يتبقّى** أو **يفيض**، فالجواب هو **الباقي**.

_مثال:_ عند توزيع 30 حلوى على 4 أطفال بالتساوي: 30 ÷ 4 = 7 والباقي 2. فيأخذ كلّ طفلٍ 7 حلوياتٍ (الخارج)، وتبقى 2 (الباقي). نتحقّق: (4 × 7) + 2 = 30 ✓.

> 🏆 رائع أيّها البطل! صرت تعرف معنى القسمة ومصطلحاتها، وتُتقن العلاقة الأساسيّة المقسوم = (المقسوم عليه × الخارج) + الباقي مع الباقي < المقسوم عليه، وتنصب القسمة على عددٍ ذي رقمٍ واحد. وحين لا تكون القسمة تامّة ويبقى فائض، يولد سلاحٌ جديد لتقسيم الوحدة نفسها: **الكسور البسيطة** في الفصل القادم. تقدّم بثقة!
