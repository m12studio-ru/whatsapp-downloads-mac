<div dir="rtl">

# WhatsApp Downloads

[English](README.md) · [简体中文](README.zh.md) · [हिन्दी](README.hi.md) · [Español](README.es.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [Türkçe](README.tr.md)

يحفظ تطبيق WhatsApp على الماك كل شيء مباشرة في `~/Downloads`، ولا يوجد أي إعداد لتغيير
ذلك. هذه الأداة تمنحه مجلده الخاص، تمامًا كما يفعل Telegram Desktop.

كل ما يحفظه WhatsApp يظهر في `~/Downloads/WhatsApp` بعد ثانيتين تقريبًا. ولا يُمَس أي
شيء آخر داخل `~/Downloads`.

## التثبيت بالسحب والإفلات

الملف موجود في [صفحة أحدث إصدار](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest).

نزّل ملف `WhatsApp Downloads.dmg`، وافتحه، ثم اسحب **WhatsApp Downloads** إلى مجلد
*Applications*. بعد ذلك افتحه **من مجلد التطبيقات** وليس من صورة القرص، وسيثبّت نفسه في
الخلفية.

التطبيق غير موقَّع بشهادة مطوّر من Apple، لذلك يُمنع تشغيله أول مرة برسالة *«الملف تالف»*
أو *«تعذّر التحقق»*. أمامك خياران:

- اضغط بالزر الأيمن على التطبيق واختر **Open**؛ وإذا لم تعرض النافذة سوى *Done* /
  *Move to Trash*، فاذهب إلى *System Settings → Privacy & Security* واضغط
  **Open Anyway**؛ أو
- أزل علامة الحجر الصحي مرة واحدة:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

إذا كنت قد ثبّتّ نسخة سطر الأوامر من قبل، فإن فتح التطبيق يستبدل عاملها الخلفي بآخر يشير
إلى `/Applications/WhatsApp Downloads.app`.

التطبيق موقَّع على جهازك أنت، لا من Apple. لذلك يبدو كل بناء جديد لنظام macOS تطبيقًا
مختلفًا، وبعد استبداله يطلب الإذن بالوصول إلى مجلد التنزيلات من جديد.

ولبناء صورة القرص بنفسك تحتاج إلى أدوات سطر الأوامر من Xcode، وهي أدوات المطوّرين من
Apple (`xcode-select --install`)، ثم:

```sh
./build.sh
```

## التثبيت من سطر الأوامر

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

بعدها سيطلب macOS لتطبيق **WhatsAppDownloads** إذنًا بالوصول إلى مجلد التنزيلات —
اضغط **Allow**. وإذا فاتك ظهور النافذة، فعّل الإذن يدويًا من
*System Settings → Privacy & Security → Files and Folders*.

للتأكد من أن كل شيء يعمل: ضع ملفًا باسم `WhatsApp test.jpg` داخل `~/Downloads`.

## إلغاء التثبيت

```sh
./uninstall.sh
```

ملفاتك تبقى في مكانها؛ الذي يُحذف هو أداة النقل فقط.

## ما الذي يتم تثبيته

| المسار | ما هو |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | أداة النقل، سكربت zsh قصير |
| `~/Applications/WhatsAppDownloads.app` | غلاف صغير يشغّل السكربت |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | يوقظه عند أي تغيير في `~/Downloads` |

أما النسخة التي تُثبَّت بالسحب فتضع `/Applications/WhatsApp Downloads.app` فقط، مع نفس ملف
`~/Library/LaunchAgents/WhatsAppDownloads.plist`. والأمر `./uninstall.sh` يزيل العامل الخلفي وكل ما وُضع في مجلدك
الشخصي؛ أما حذف `/Applications/WhatsApp Downloads.app` فقد يحتاج إلى صلاحية مسؤول،
وإن تعذّر الحذف أخبرك السكربت بذلك.

ولماذا حزمة تطبيق أصلًا؟ لأن macOS يمنح صلاحية الوصول إلى المجلدات لكل تطبيق على حدة.
السكربت المجرد الذي يشغّله launchd يرى مجلد تنزيلات فارغًا فلا يفعل شيئًا بصمت، لذلك
وُضع السكربت داخل تطبيق يستطيع أن يحمل هذا الإذن.

يظهر باسم **WhatsAppDownloads** في
*System Settings → General → Login Items → Allow in the Background*، ومن هناك يمكنك
إيقافه.

## طريقة العمل

- ينقل الملفات التي يبدأ اسمها بـ `WhatsApp ` — فهذه هي التسمية التي يستخدمها التطبيق.
- لا يستبدل شيئًا أبدًا: عند تكرار الاسم يصبح الملف `WhatsApp Image ... (1).jpeg`.
- يتجاهل ملفات `.crdownload` و`.part` و`.download` حتى ينتهي المتصفح من تنزيلها.
- يترك المجلدات وكل الملفات الأخرى كما هي.

## الإعدادات

عدّل المتغيرات الثلاثة في أعلى `whatsapp-downloads.sh`، أو اضبط `WA_SRC` و`WA_DST`
و`WA_PREFIX`. وإذا غيّرت `WA_SRC` إلى مجلد خارج `~/Downloads`، فسيطلب macOS إذن
الوصول إلى ذلك المجلد بدلًا من الأول.

## الاختبارات

```sh
./test.sh
```

تستغرق نحو 90 ثانية، وتختبر المسار الخلفي الحقيقي — launchd والتطبيق والإذن — بدلًا من
استدعاء السكربت مباشرة. ولا تكتب سوى ملفات تحمل `cctest` في أسمائها، ثم تحذفها بعد
الانتهاء.

## المتطلبات

macOS 13 أو أحدث. بدون أي اعتماديات.

## الدعم

هذه أداة شخصية صغيرة تُقدَّم كما هي. المشاركات والـ pull requests مرحّب بها، لكن لا وعد
بالرد.

## الرخصة

MIT

</div>
