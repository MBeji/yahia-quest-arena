# ⚔️ نظرية طاليس — سلاح التناسب الهندسي

> 💡 «طاليس الميليتي، عالِم اليونان الأوّل، اكتشف أنّ الخطوط المتوازية تخلق تناسبًا مذهلًا — سلاحك لحساب الأطوال المجهولة.»

## 🏰 وضعية طاليس الأساسية

**الوضعية**: لديك مثلّث ABC ومستقيم (MN) يقطع الضلعَين [AB] و[AC] في نقطتين M وN على الترتيب.

الشرط الجوهري لتطبيق نظرية طاليس:

$$ (MN) ∥ (BC) $$

أي أنّ المستقيم الذي يمرّ بـ M وN **يوازي** الضلعَ BC.

::: figure المثلّث AMN تصغير للمثلّث ABC — هذا هو جوهر النظرية في صورة واحدة
<svg viewBox="0 0 340 260">
<path d="M170 30 L118 104 L222 104 Z" fill="#0f6e56" opacity="0.12"/>
<path d="M170 30 L40 215 L300 215 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M118 104 L222 104" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linecap="round"/>
<g fill="none" stroke="#0f6e56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
<path d="M165 98 L172 104 L165 110"/>
<path d="M165 209 L172 215 L165 221"/>
</g>
<g fill="#0f172a"><circle cx="170" cy="30" r="4"/><circle cx="40" cy="215" r="4"/><circle cx="300" cy="215" r="4"/></g>
<g fill="#0f6e56"><circle cx="118" cy="104" r="4"/><circle cx="222" cy="104" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="170" y="20" text-anchor="middle" fill="#0f172a">A</text>
<text x="27" y="233" text-anchor="middle" fill="#0f172a">B</text>
<text x="313" y="233" text-anchor="middle" fill="#0f172a">C</text>
<text x="103" y="101" text-anchor="middle" fill="#0f6e56">M</text>
<text x="237" y="101" text-anchor="middle" fill="#0f6e56">N</text>
</g>
</svg>
:::

> ⚠️ في **وضعية المثلّث** هذه، النقطتان M وN يجب أن تكونا **داخل** الضلعين (بين رأس المثلّث والقاعدة). توجد وضعية ثانية مشروعة هي وضعية الفراشة (انظر أدناه)، ولها قاعدتها الخاصّة.

## ⚡ نصّ نظرية طاليس وتساوي النسب

إذا كانت M نقطة من [AB] و N نقطة من [AC] بحيث (MN) ∥ (BC)، فإنّ:

$$ AM/AB = AN/AC = MN/BC $$

**قراءة النسب**: كلّ نسبة تمثّل «الجزء على الكلّ» في الضلع المقابل. النسب الثلاث متساوية.

**مثال محسوب**: في مثلّث ABC حيث AB = 10 cm و AC = 8 cm و BC = 6 cm. المستقيم (MN) ∥ (BC) يقطع [AB] في M حيث AM = 4 cm.

- AM/AB = 4/10 = 2/5
- إذن: AN = AC × 2/5 = 8 × 2/5 = 3,2 cm
- وأيضًا: MN = BC × 2/5 = 6 × 2/5 = 2,4 cm

## 🛡️ شكل «الجزء على الجزء المتبقّي»

يمكن كذلك كتابة نسبة مكمِّلة تربط الجزأين على الضلعين أنفسهما:

$$ AM/MB = AN/NC $$

هذا الشكل مفيد حين يُعطى MB أو NC مباشرةً في التمرين.

**مثال محسوب**: M على [AB] بحيث AM = 6 و MB = 4، وN على [AC] بحيث AN = 9، و(MN) ∥ (BC). أوجد NC.

$$ AM/MB = AN/NC ⟹ 6/4 = 9/NC ⟹ NC = (9 × 4)/6 = 6 $$

تحقّق: 6/4 = 1,5 و 9/6 = 1,5 ✓

> ⚠️ انتبه: النسبة MN/BC **لا** تساوي AM/MB، بل تساوي AM/AB (الجزء على الضلع **كاملًا**). مثال: إذا كان AM = 4 و MB = 6 فإنّ AM/MB = 2/3 بينما MN/BC = AM/AB = 4/10 = 2/5. لذلك لا تُدخل MN/BC في سلسلة «الجزء على الجزء المتبقّي» أبدًا.

## 🔮 النظرية العكسية لطاليس (شرط التوازي)

إذا كانت M نقطة من [AB] و N نقطة من [AC] وتحقّقت:

$$ AM/AB = AN/AC $$

فإنّ **(MN) ∥ (BC)**.

**الاستخدام**: نثبت التوازي دون أداة رسم، بمجرّد التحقّق من تساوي النسبتين.

**مثال**: في مثلّث ABC، M على [AB] بحيث AM = 3 و AB = 9، وN على [AC] بحيث AN = 2 و AC = 6.

$$ AM/AB = 3/9 = 1/3 $$

$$ AN/AC = 2/6 = 1/3 $$

النسبتان متساويتان، إذن **(MN) ∥ (BC)**. ✓

::: figure العكسية: 3/9 = 2/6 = 1/3، إذن (MN) ∥ (BC) — نُثبت التوازي بالحساب، لا بالرسم
<svg viewBox="0 0 340 260">
<path d="M170 30 L40 215 L300 215 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M126.7 91.7 L213.3 91.7" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linecap="round"/>
<g fill="none" stroke="#0f6e56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
<path d="M165 85.7 L172 91.7 L165 97.7"/>
<path d="M165 209 L172 215 L165 221"/>
</g>
<g fill="#0f172a"><circle cx="170" cy="30" r="4"/><circle cx="40" cy="215" r="4"/><circle cx="300" cy="215" r="4"/></g>
<g fill="#0f6e56"><circle cx="126.7" cy="91.7" r="4"/><circle cx="213.3" cy="91.7" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="170" y="20" text-anchor="middle" fill="#0f172a">A</text>
<text x="27" y="233" text-anchor="middle" fill="#0f172a">B</text>
<text x="313" y="233" text-anchor="middle" fill="#0f172a">C</text>
<text x="112" y="88" text-anchor="middle" fill="#0f6e56">M</text>
<text x="228" y="88" text-anchor="middle" fill="#0f6e56">N</text>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="137" y="55" text-anchor="middle" fill="#0f6e56">3</text>
<text x="72" y="148" text-anchor="middle" fill="#0f172a">6</text>
<text x="203" y="55" text-anchor="middle" fill="#0f6e56">2</text>
<text x="268" y="148" text-anchor="middle" fill="#0f172a">4</text>
</g>
</svg>
:::

**الحالة السلبية**: إذا كانت النسبتان **غير متساويتين** فالمستقيمان **غير متوازيين** — والتساوي يجب أن يكون تامًّا لا تقريبيًّا.

**مثال**: AM/AB = 3/7 و AN/AC = 4/9. بالضرب التقاطعي: 3 × 9 = 27 و 7 × 4 = 28، و27 ≠ 28، إذن (MN) ليس موازيًا لـ (BC).

> ⚠️ للنظرية العكسية شرط إضافي: يجب أن تكون M وN في **نفس الجانب** من الرأس A.

## 🧪 حساب طول مجهول — خطوات العمل

عند مواجهة تمرين «أوجد الطول x»، اتّبع هذه الخطوات:

1. **ارسم الشكل** واكتب المعطيات على الأضلاع.
2. **تحقّق من الشرط**: هل (MN) ∥ (BC)؟ (يُعطى في التمرين عادةً).
3. **اختر النسبة المناسبة**: استعمل المعطيات المتوفّرة.
4. **احلّ المعادلة** بالضرب التقاطعي ثمّ القسمة.

**مثال كامل**: في مثلّث DEF، (MN) ∥ (EF)، DM = 6 cm، ME = 4 cm، DN = x، NF = 3 cm. أوجد x.

$$ DM/DE = DN/DF $$

$$ DE = DM + ME = 6 + 4 = 10 cm $$

$$ DF = DN + NF = x + 3 $$

$$ 6/10 = x/(x + 3) ⟹ 6(x + 3) = 10x ⟹ 6x + 18 = 10x ⟹ x = 4,5 cm $$

## 🧮 وضعية طاليس بشكل تقاطع (Configuration papillon)

في بعض التمارين، يتقاطع مستقيمان في نقطة O خارج المثلّث ونكوّن مثلّثين «فراشة»:

- المثلّث OAB والمثلّث OCD بحيث (AB) ∥ (CD).

::: figure وضعية الفراشة: المثلّثان OAB وOCD متقابلان بالرأس O، و(AB) ∥ (CD) — النسب نفسها تبقى صالحة
<svg viewBox="0 0 340 260">
<path d="M170 120 L110 65 L235 65 Z" fill="#0f6e56" opacity="0.12"/>
<path d="M170 120 L290 230 L40 230 Z" fill="#0f6e56" opacity="0.12"/>
<g fill="none" stroke="#0f172a" stroke-width="2" stroke-linecap="round">
<path d="M110 65 L290 230"/>
<path d="M235 65 L40 230"/>
</g>
<path d="M110 65 L235 65" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linecap="round"/>
<path d="M40 230 L290 230" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linecap="round"/>
<g fill="none" stroke="#0f6e56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
<path d="M167 59 L174 65 L167 71"/>
<path d="M158 224 L165 230 L158 236"/>
</g>
<g fill="#0f172a"><circle cx="170" cy="120" r="4"/><circle cx="110" cy="65" r="4"/><circle cx="235" cy="65" r="4"/><circle cx="290" cy="230" r="4"/><circle cx="40" cy="230" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="183" y="117" text-anchor="middle" fill="#0f172a">O</text>
<text x="99" y="57" text-anchor="middle" fill="#0f172a">A</text>
<text x="246" y="57" text-anchor="middle" fill="#0f172a">B</text>
<text x="303" y="245" text-anchor="middle" fill="#0f172a">C</text>
<text x="28" y="245" text-anchor="middle" fill="#0f172a">D</text>
</g>
</svg>
:::

تطبّق النظرية بنفس الطريقة:

$$ OA/OC = OB/OD = AB/CD $$

**مثال محسوب**: OA = 4 و OC = 8 و AB = 5، و(AB) ∥ (CD). أوجد CD.

$$ OA/OC = 4/8 = 1/2 = AB/CD ⟹ CD = 2 × AB = 2 × 5 = 10 $$

> 💡 الفرق الوحيد: الرأس هنا هو O نقطة التقاطع، وليس رأس المثلّث الأصلي. الفراشة وضعية ثانية **مشروعة تمامًا** لطاليس: النقاط هنا على جانبين متقابلين من O، فتحذير «داخل الضلعين» الخاصّ بوضعية المثلّث لا ينطبق عليها.

## 🏆 تطبيقات نظرية طاليس في الحياة

- قياس ارتفاع شجرة أو بناية بظلالها (التشابه عبر الشمس).
- رسم الخرائط وتصغير الأبعاد بنسبة ثابتة.
- تقسيم القطعة إلى أجزاء متساوية بالمسطرة والمثلّث.

> 🏆 أتقنتَ نظرية طاليس! ستُحاربك بها مناظرة التاسعة والامتحانات الوطنية في شكل تمارين حساب الأطوال — الآن أنت مستعدّ.
