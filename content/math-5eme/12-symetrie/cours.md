# ⚔️ التناظر المحوري — مرآةٌ في الهندسة

> 💡 «إذا طويتَ ورقةً على رسمٍ فانطبق نصفاه أحدهما على الآخر، فقد عثرتَ على محور تناظره.»

الفراشة، ووجه الإنسان، وحرف A، وقلبٌ مرسوم… كلّها أشكالٌ **متناظرة**: نصفها صورةٌ معكوسة للنصف الآخر. في هذه البوّابة تتعلّم **التناظر المحوري**، ومحور التناظر، وكيف ترسم نظير نقطةٍ وتُكمل شكلًا بالتناظر.

## 🪞 ما هو التناظر المحوري؟

يكون لشكلٍ **تناظرٌ محوري** إذا وُجد خطٌّ مستقيم — يُسمّى **محور التناظر** — إذا طُوي الشكل عليه **انطبق نصفاه** تمامًا أحدهما على الآخر.

نقول إنّ النصف الأوّل **نظير** النصف الثاني بالنسبة لذلك المحور.

<svg viewBox="0 0 100 100"><line x1="50" y1="8" x2="50" y2="92" stroke="currentColor" stroke-width="1.5" stroke-dasharray="4 3"/><path d="M50 35 C40 18 18 28 30 48 C36 58 50 68 50 68" fill="none" stroke="currentColor" stroke-width="2"/><path d="M50 35 C60 18 82 28 70 48 C64 58 50 68 50 68" fill="none" stroke="currentColor" stroke-width="2"/></svg>

## 📏 خصائص النقطة ونظيرها

النقطة A ونظيرتها 'A بالنسبة لمحورٍ تحقّقان:

<svg viewBox="0 0 100 100"><line x1="50" y1="10" x2="50" y2="90" stroke="currentColor" stroke-width="1.5" stroke-dasharray="4 3"/><circle cx="22" cy="50" r="3" fill="currentColor"/><circle cx="78" cy="50" r="3" fill="currentColor"/><line x1="22" y1="50" x2="78" y2="50" stroke="currentColor" stroke-width="1"/><circle cx="50" cy="50" r="2" fill="currentColor"/><text x="14" y="46" font-size="11" fill="currentColor">A</text><text x="80" y="46" font-size="11" fill="currentColor">A'</text></svg>

- النقطتان على **بُعدٍ متساوٍ** من المحور.
- المحور **عموديّ** على القطعة [A'A] ويمرّ بـ**منتصفها**.
- إذا كانت نقطةٌ **على المحور** نفسه، فبُعدها عنه صفر، فنظيرها **هو نفسها**.

> 🧭 مثال: إذا بَعُدت A عن المحور 4 cm، فإنّ نظيرتها 'A تبعد 4 cm عن المحور من الجهة الأخرى، والمسافة بينهما = 4 + 4 = 8 cm.

## 🟦 محاور تناظر بعض الأشكال

| الشكل                  | عدد محاور التناظر |
| ---------------------- | ----------------- |
| المثلّث متساوي الساقين | 1                 |
| المثلّث متساوي الأضلاع | 3                 |
| المستطيل (غير المربّع) | 2                 |
| المربّع                | 4                 |
| الدائرة                | عددٌ لا نهائيّ    |

للمربّع 4 محاور تناظر: محوران يمرّان بمنتصفات الأضلاع، ومحوران قطريّان:

<svg viewBox="0 0 100 100"><rect x="25" y="25" width="50" height="50" fill="none" stroke="currentColor" stroke-width="2.5"/><line x1="50" y1="15" x2="50" y2="85" stroke="currentColor" stroke-width="1" stroke-dasharray="4 3"/><line x1="15" y1="50" x2="85" y2="50" stroke="currentColor" stroke-width="1" stroke-dasharray="4 3"/><line x1="18" y1="18" x2="82" y2="82" stroke="currentColor" stroke-width="1" stroke-dasharray="4 3"/><line x1="82" y1="18" x2="18" y2="82" stroke="currentColor" stroke-width="1" stroke-dasharray="4 3"/></svg>

أمّا المثلّث متساوي الساقين فله محورٌ واحد عموديّ على قاعدته يمرّ برأسه:

<svg viewBox="0 0 100 100"><polygon points="50,15 20,80 80,80" fill="none" stroke="currentColor" stroke-width="3"/><line x1="50" y1="8" x2="50" y2="90" stroke="currentColor" stroke-width="1.5" stroke-dasharray="4 3"/></svg>

## ✏️ إكمال شكلٍ بالتناظر

لإكمال شكلٍ بالنسبة لمحور: نأخذ كلّ نقطةٍ من النصف المرسوم، ونرسم نظيرها على **البُعد نفسه** من الجهة الأخرى للمحور، ثمّ نصل النقاط بالترتيب نفسه. فيكون الناتج **صورةً معكوسة** مطابقة للنصف الأوّل.

<svg viewBox="0 0 100 100"><line x1="50" y1="8" x2="50" y2="92" stroke="currentColor" stroke-width="1.5" stroke-dasharray="4 3"/><polyline points="50,25 30,40 35,65 50,75" fill="none" stroke="currentColor" stroke-width="2"/><polyline points="50,25 70,40 65,65 50,75" fill="none" stroke="currentColor" stroke-width="2" stroke-dasharray="3 2"/></svg>

> ⚠️ الفخّ الشائع: الظنّ أنّ كلّ قطرٍ في الشكل محورُ تناظر؛ ليس كذلك دائمًا — قطر المستطيل (غير المربّع) **ليس** محور تناظرٍ له، وكذلك لا محور تناظر لمتوازي الأضلاع العامّ.

> 🏆 مبروك! بإتمامك التناظر المحوري تكون قد أتقنتَ مرآة الهندسة، وصرتَ قادرًا على رسم النظير وإكمال أيّ شكلٍ متناظر.
