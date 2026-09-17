# WhatsApp Downloads

[English](README.md) · [简体中文](README.zh.md) · [हिन्दी](README.hi.md) · [Español](README.es.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [Türkçe](README.tr.md)

Mac पर WhatsApp हर चीज़ सीधे `~/Downloads` में डाल देता है, और इसे बदलने का कोई
सेटिंग नहीं है। यह टूल उसे अपना अलग फ़ोल्डर दे देता है — ठीक वैसे ही जैसे Telegram
Desktop का होता है।

WhatsApp जो भी सेव करेगा, वह कुछ ही सेकंड में `~/Downloads/WhatsApp` में पहुँच
जाएगा। `~/Downloads` की बाकी किसी चीज़ को हाथ नहीं लगाया जाता।

## खींचकर इंस्टॉल करना

फ़ाइल [नवीनतम रिलीज़ पेज](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest) पर है।

`WhatsApp Downloads.dmg` डाउनलोड करें, उसे खोलें और **WhatsApp Downloads** को
*Applications* में खींच दें। फिर उसे **Applications फ़ोल्डर से** खोलें — डिस्क इमेज से नहीं —
और वह ख़ुद को बैकग्राउंड में इंस्टॉल कर लेगा।

ऐप पर Apple डेवलपर सर्टिफ़िकेट का हस्ताक्षर नहीं है, इसलिए पहली बार खोलने पर macOS
*"फ़ाइल ख़राब है"* या *"जाँच नहीं हो सकी"* कहकर रोक देगा। दो में से कोई एक तरीक़ा अपनाएँ:

- ऐप पर राइट-क्लिक करके **Open** चुनें; अगर विंडो में सिर्फ़ *Done* / *Move to Trash* दिखे तो
  *System Settings → Privacy & Security* में जाकर **Open Anyway** दबाएँ; या
- क्वारंटीन फ़्लैग एक बार हटा दें:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

अगर आपने पहले कमांड लाइन वाला संस्करण इंस्टॉल किया था, तो ऐप खोलते ही वह पुराना
बैकग्राउंड एजेंट `/Applications/WhatsApp Downloads.app` की ओर इशारा करने वाले नए एजेंट से
बदल जाएगा।

ऐप आपकी ही मशीन पर साइन होता है, Apple की तरफ़ से नहीं। इसलिए हर नई बिल्ड macOS को
अलग ऐप लगती है और बदलने के बाद वह Downloads फ़ोल्डर की अनुमति फिर से माँगता है।

डिस्क इमेज ख़ुद बनानी हो तो पहले Xcode Command Line Tools चाहिए — Apple के डेवलपर
टूल (`xcode-select --install`)। उसके बाद:

```sh
./build.sh
```

## कमांड लाइन से इंस्टॉल

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

इसके बाद macOS आपसे **WhatsAppDownloads** के लिए Downloads फ़ोल्डर की अनुमति
माँगेगा — **Allow** दबाएँ। अगर वह डायलॉग छूट जाए, तो इसे
*System Settings → Privacy & Security → Files and Folders* में चालू कर दें।

जाँचने के लिए: `WhatsApp test.jpg` नाम की एक फ़ाइल `~/Downloads` में डाल दें।

## अनइंस्टॉल

```sh
./uninstall.sh
```

आपकी फ़ाइलें जहाँ हैं वहीं रहती हैं; सिर्फ़ फ़ाइलें हटाने-सरकाने वाला हिस्सा हट
जाता है।

## क्या-क्या इंस्टॉल होता है

| पाथ | यह क्या है |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | फ़ाइलें सरकाने वाली छोटी-सी zsh स्क्रिप्ट |
| `~/Applications/WhatsAppDownloads.app` | छोटा-सा रैपर, जो इस स्क्रिप्ट को चलाता है |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | `~/Downloads` बदलते ही इसे जगा देता है |

खींचकर इंस्टॉल करने पर सिर्फ़ `/Applications/WhatsApp Downloads.app` और वही
`~/Library/LaunchAgents/WhatsAppDownloads.plist` बनता है। `./uninstall.sh` बैकग्राउंड एजेंट और आपके होम फ़ोल्डर में उसकी लगाई हुई सारी चीज़ें हटा देता है;
`/Applications/WhatsApp Downloads.app` मिटाने के लिए एडमिनिस्ट्रेटर की ज़रूरत पड़ सकती है,
और न मिटे तो स्क्रिप्ट आपको बता देती है।

ऐप बंडल क्यों? macOS फ़ोल्डर की अनुमति हर ऐप को अलग-अलग देता है। launchd से चली
अकेली शेल स्क्रिप्ट को Downloads फ़ोल्डर खाली दिखता है और वह चुपचाप कुछ नहीं करती।
इसलिए स्क्रिप्ट एक ऐप के अंदर रहती है, जो यह अनुमति अपने पास रख सकता है।

यह *System Settings → General → Login Items → Allow in the Background* में
**WhatsAppDownloads** नाम से दिखता है, जहाँ से आप इसे बंद कर सकते हैं।

## यह करता क्या है

- उन्हीं फ़ाइलों को ले जाता है जिनका नाम `WhatsApp ` से शुरू होता है — ऐप इसी तरह नाम देता है।
- कुछ भी ओवरराइट नहीं करता: नाम टकराने पर फ़ाइल `WhatsApp Image ... (1).jpeg` बन जाती है।
- `.crdownload`, `.part` और `.download` फ़ाइलों को तब तक छोड़ देता है जब तक डाउनलोड पूरा न हो जाए।
- फ़ोल्डरों और बाकी सब फ़ाइलों से कोई छेड़छाड़ नहीं करता।

## सेटिंग बदलना

`whatsapp-downloads.sh` की शुरुआत में दिए तीन वेरिएबल बदल दें, या `WA_SRC`,
`WA_DST` और `WA_PREFIX` सेट कर दें। अगर `WA_SRC` को `~/Downloads` से बाहर के किसी
फ़ोल्डर पर लगाएँगे, तो macOS उसी फ़ोल्डर की अनुमति माँगेगा।

## टेस्ट

```sh
./test.sh
```

इसमें करीब 90 सेकंड लगते हैं और यह असली बैकग्राउंड रास्ते को — launchd, ऐप और
अनुमति को — परखता है, न कि स्क्रिप्ट को सीधे चलाकर देखता है। यह सिर्फ़ उन्हीं
फ़ाइलों को बनाता है जिनके नाम में `cctest` होता है, और बाद में उन्हें मिटा देता है।

## ज़रूरतें

macOS 13 या उससे नया। कोई अतिरिक्त डिपेंडेंसी नहीं।

## सपोर्ट

यह एक छोटा निजी टूल है, जैसा है वैसा ही दिया गया है। Issues और pull requests का
स्वागत है, पर जवाब मिलने का वादा नहीं है।

## लाइसेंस

MIT
