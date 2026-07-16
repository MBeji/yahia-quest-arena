# ⚔️ الطرح — سيف إنقاص الأعداد

> 💡 «الجمعُ يَبني والطرحُ يَهدم؛ ومن أتقنهما معًا صار سيّدَ الأعداد.»

أهلًا بك أيّها البطل! في الفصل السابق تعلّمت **الجمع**. اليوم نمسك سيفًا جديدًا اسمه **الطرح**: به نَعرف **كم بقي** بعد أن نُنقص عددًا من عدد، ونحسب **الفرق** بين عددين، إلى حدود 999.

## 🏰 ما معنى الطرح؟

الطرح يعني **الإنقاص**: نأخذ عددًا ونُنقص منه عددًا آخر، فنعرف **كم بقي**.

- مثال: عندي 9 تفّاحات، أكلتُ 4، كم بقي؟ نطرح: 9 − 4 = 5. بقيت 5 تفّاحات.

::: figure من 9 تفّاحات أكلنا 4 (المشطوبة)، فبقيت 5
<svg viewBox="0 0 340 130"><g><path d="M26 24 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M26 25 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M26 19 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><g><path d="M60 24 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M60 25 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M60 19 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><g><path d="M94 24 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M94 25 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M94 19 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><g><path d="M128 24 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M128 25 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M128 19 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><g><path d="M162 24 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M162 25 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M162 19 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><g opacity="0.35"><path d="M26 60 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M26 61 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M26 55 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><path d="M13 57 L39 83 M39 57 L13 83" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round"/><g opacity="0.35"><path d="M60 60 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M60 61 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M60 55 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><path d="M47 57 L73 83 M73 57 L47 83" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round"/><g opacity="0.35"><path d="M94 60 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M94 61 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M94 55 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><path d="M81 57 L107 83 M107 57 L81 83" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round"/><g opacity="0.35"><path d="M128 60 q-14 -3 -14 11 q0 14 14 14 q14 0 14 -14 q0 -11 -14 -11 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.2"/><path d="M128 61 l0 -6" stroke="#7c2d12" stroke-width="2.5" stroke-linecap="round"/><path d="M128 55 q8 -5 10 2 q-8 3 -10 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.3"/></g><path d="M115 57 L141 83 M141 57 L115 83" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round"/><text x="90.0" y="118.0" text-anchor="middle" font-size="20" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">9 − 4 = 5</text><text x="258.0" y="44.0" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">أكلنا 4</text><text x="258.0" y="70.0" text-anchor="middle" font-size="13" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">بقيت 5</text></svg>
:::

- نستعمل الطرح أيضًا لنعرف **الفرق** بين عددين: الفرق بين 8 و 3 هو 8 − 3 = 5.

نكتب علامة الطرح هكذا **−**، ونقرؤها «ناقص».

## 🧮 أسماء أطراف الطرح

في كلّ عمليّة طرح ثلاثة أسماء يجب أن تحفظها:

| الاسم              | مكانه                       | مثال في 7 − 2 = 5 |
| ------------------ | --------------------------- | ----------------- |
| **المطروح منه**    | العدد الأوّل (الأكبر عادةً) | 7                 |
| **المطروح**        | العدد الذي نُنقصه           | 2                 |
| **الفرق** (الباقي) | نتيجة الطرح                 | 5                 |

> 🗡️ تذكّر الترتيب: **المطروح منه − المطروح = الفرق**. العدد الأكبر يُكتب أوّلًا.

## 🔮 الطرح بدون استلاف

نضع العددين أحدهما تحت الآخر، كلّ رتبةٍ تحت رتبتها (آحاد تحت آحاد، عشرات تحت عشرات، مئات تحت مئات)، ثمّ نطرح **رتبةً رتبةً ابتداءً من اليمين** (من الآحاد).

- مثال: 568 − 243. الآحاد: 8 − 3 = 5. العشرات: 6 − 4 = 2. المئات: 5 − 2 = 3. إذن 568 − 243 = 325.

::: figure كلّ رتبةٍ تحت رتبتها، ونطرح ابتداءً من اليمين
<svg viewBox="0 0 280 160"><text x="96.0" y="48.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="134.0" y="48.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><text x="172.0" y="48.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8</text><text x="58.0" y="92.0" text-anchor="middle" font-size="20" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">−</text><text x="96.0" y="92.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><text x="134.0" y="92.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><text x="172.0" y="92.0" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><path d="M62 106 H190" stroke="#1f2937" stroke-width="2.5"/><text x="96.0" y="138.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><text x="134.0" y="138.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><text x="172.0" y="138.0" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><text x="96.0" y="18.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مئات</text><text x="134.0" y="18.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عشرات</text><text x="172.0" y="18.0" text-anchor="middle" font-size="10" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">آحاد</text><path d="M206 128 q26 -24 0 -48" fill="none" stroke="#0f6e56" stroke-width="2" stroke-dasharray="4 3"/><path d="M206 78 l-5 9 l9 -1 z" fill="#0f6e56"/><text x="240.0" y="106.0" text-anchor="middle" font-size="12" font-weight="700" fill="#0f6e56" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">نبدأ</text><text x="240.0" y="124.0" text-anchor="middle" font-size="12" font-weight="700" fill="#0f6e56" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">من اليمين</text></svg>
:::

ما دام كلّ رقمٍ في الأعلى **أكبر من أو يساوي** الرقم الذي تحته، نطرح مباشرةً دون أيّ صعوبة.

## ⚡ الطرح مع الاستلاف

أحيانًا يكون الرقم في الأعلى **أصغر** من الرقم الذي تحته، فلا نستطيع الطرح مباشرةً. هنا نستعمل **الاستلاف**: نأخذ **عشرةً واحدة** من الرتبة المجاورة على اليسار.

- مثال: 52 − 27. الآحاد: 2 أصغر من 7! نستلف عشرةً من العشرات: تصير الآحاد 12، والعشرات تنقص واحدة (من 5 إلى 4). الآن: 12 − 7 = 5 في الآحاد، و 4 − 2 = 2 في العشرات. إذن 52 − 27 = 25.

> ⚠️ الفخّ الخطير: لا تطرح أبدًا **الأصغر من الأكبر داخل الرتبة** للهروب من الاستلاف! في 52 − 27 الآحاد ليست 7 − 2 = 5، بل نستلف: 12 − 7 = 5. النتيجة الصحيحة 25، لا 35.

## 🛡️ الطرح عكس الجمع والتثبّت

**الطرح عكس الجمع.** إذا كان 5 + 3 = 8، فإنّ 8 − 3 = 5 و 8 − 5 = 3.

لذلك نتثبّت من صحّة الطرح **بالجمع**: نجمع **الفرق** مع **المطروح**، فإن حصلنا على **المطروح منه** فالجواب صحيح.

- مثال: حسبنا 52 − 27 = 25. نتثبّت: 25 + 27 = 52 ✓. الجواب صحيح.

## 📐 حالات خاصّة سهلة

- **طرح الصفر:** إذا طرحنا 0 لا يتغيّر العدد: 47 − 0 = 47.
- **طرح العدد من نفسه:** الفرق يساوي 0 دائمًا: 36 − 36 = 0 (أخذنا كلّ شيء فلم يبقَ شيء).
- **مسائل بالكلمات:** اقرأ المسألة جيّدًا. كلمات مثل «كم بقي؟»، «كم أكل؟»، «الفرق» تدلّ على الطرح. مثال: في صندوقٍ 120 كرة، بِيعت 45، كم بقي؟ نطرح: 120 − 45 = 75 كرة.

> 🏆 رائع أيّها البطل! صرت تعرف معنى الطرح وأسماء أطرافه، وتطرح بدون استلاف ومع الاستلاف، وتتثبّت بالجمع. سيفُ الطرح في يدك الآن — انطلق إلى التمارين!
