# WhatsApp Downloads

[English](README.md) · [简体中文](README.zh.md) · [हिन्दी](README.hi.md) · [Español](README.es.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [Türkçe](README.tr.md)

Mac için WhatsApp her şeyi doğrudan `~/Downloads` klasörüne kaydeder ve bunu
değiştirecek bir ayar da yoktur. Bu araç, Telegram Desktop'ta olduğu gibi WhatsApp'a
kendi klasörünü kazandırır.

WhatsApp'ın kaydettiği her dosya birkaç saniye içinde `~/Downloads/WhatsApp` içinde
belirir. `~/Downloads` klasöründeki diğer hiçbir şeye dokunulmaz.

## Sürükleyerek kurulum

Dosya [en son sürüm sayfasında](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest) bulunur.

`WhatsApp Downloads.dmg` dosyasını indirin, açın ve **WhatsApp Downloads** uygulamasını
*Applications* klasörüne sürükleyin. Sonra uygulamayı disk imajından değil,
**Uygulamalar klasöründen** açın; kendini arka planda kurar.

Uygulama Apple geliştirici sertifikasıyla imzalı değil, bu yüzden ilk açılışta
*"dosya zarar görmüş"* ya da *"doğrulanamadı"* uyarısıyla engellenir. İki yol var:

- uygulamaya sağ tıklayıp **Aç** deyin; pencerede yalnızca *Tamam* / *Çöp Sepetine Taşı*
  varsa *Sistem Ayarları → Gizlilik ve Güvenlik* bölümünden **Yine de Aç** düğmesine
  basın; ya da
- karantina işaretini bir kez kaldırın:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

Komut satırı sürümünü daha önce kurduysanız, uygulamayı açmak onun arka plan ajanını
`/Applications/WhatsApp Downloads.app` yolunu gösteren yenisiyle değiştirir.

Disk imajını kendiniz derlemek için:

```sh
./build.sh
```

## Komut satırından kurulum

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

Ardından macOS, **WhatsAppDownloads** için Downloads klasörüne erişim izni isteyecek —
**Allow** (İzin Ver) deyin. Pencereyi kaçırırsanız izni
*Sistem Ayarları → Gizlilik ve Güvenlik → Dosyalar ve Klasörler* altından açabilirsiniz.

Denemek için: `WhatsApp test.jpg` adında bir dosyayı `~/Downloads` içine bırakın.

## Kaldırma

```sh
./uninstall.sh
```

Dosyalarınız olduğu yerde kalır; yalnızca taşıyıcı kaldırılır.

## Neler kuruluyor

| Yol | Ne işe yarar |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | taşıma işini yapan, ~15 satırlık zsh betiği |
| `~/Applications/WhatsAppDownloads.app` | betiği çalıştıran küçücük bir sarmalayıcı |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | `~/Downloads` değiştiğinde onu uyandırır |

Sürükleyerek kurulan sürüm yalnızca `/Applications/WhatsApp Downloads.app` ile aynı
`~/Library/LaunchAgents/WhatsAppDownloads.plist` dosyasını bırakır. `./uninstall.sh` her iki
kurulumu da kaldırır.

Peki neden bir uygulama paketi? macOS klasör erişimini uygulama bazında verir. launchd
tarafından başlatılan çıplak bir kabuk betiği Downloads klasörünü boş görür ve sessizce
hiçbir şey yapmaz; bu yüzden betik, izni taşıyabilen bir uygulamanın içinde yaşıyor.

*Sistem Ayarları → Genel → Giriş Öğeleri → Arka Planda İzin Ver* bölümünde
**WhatsAppDownloads** olarak görünür; istediğinizde oradan kapatabilirsiniz. Uygulama
sizin makinenizde derlenip yerel olarak imzalandığı için macOS geliştiriciyi
doğrulanmamış sayar.

## Nasıl davranır

- Adı `WhatsApp ` ile başlayan dosyaları taşır — uygulama dosyaları böyle adlandırıyor.
- Hiçbir şeyin üzerine yazmaz: çakışma olursa dosya `WhatsApp Image ... (1).jpeg` olur.
- Tarayıcı işini bitirene kadar `.crdownload`, `.part` ve `.download` dosyalarını atlar.
- Klasörlere ve diğer bütün dosyalara dokunmaz.

## Yapılandırma

`whatsapp-downloads.sh` dosyasının başındaki üç değişkeni düzenleyin ya da `WA_SRC`,
`WA_DST` ve `WA_PREFIX` değerlerini tanımlayın. `WA_SRC` değerini `~/Downloads`
dışındaki bir klasöre çevirirseniz macOS bu sefer o klasör için izin isteyecektir.

## Testler

```sh
./test.sh
```

Yaklaşık 90 saniye sürer ve betiği doğrudan çağırmak yerine gerçek arka plan yolunu —
launchd'yi, uygulamayı ve izni — baştan sona dener. Yalnızca adında `cctest` geçen
dosyalar oluşturur ve sonrasında hepsini siler.

## Gereksinimler

macOS 13 veya üzeri. Başka hiçbir bağımlılık yok.

## Destek

Bu, olduğu gibi yayımlanan küçük ve kişisel bir araç. Issue ve pull request'ler memnuniyetle
karşılanır ama yanıt vereceğime dair bir söz veremem.

## Lisans

MIT
