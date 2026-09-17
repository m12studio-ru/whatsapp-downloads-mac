# WhatsApp Downloads

[English](README.md) · [简体中文](README.zh.md) · [हिन्दी](README.hi.md) · [Español](README.es.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [Türkçe](README.tr.md)

WhatsApp untuk Mac menyimpan semuanya langsung ke `~/Downloads` dan tidak menyediakan
pengaturan untuk mengubahnya. Alat ini memberi WhatsApp foldernya sendiri, seperti yang
sudah dimiliki Telegram Desktop.

Apa pun yang disimpan WhatsApp akan muncul di `~/Downloads/WhatsApp` beberapa detik
kemudian. Isi `~/Downloads` yang lain sama sekali tidak diutak-atik.

## Pemasangan dengan menyeret

Berkasnya ada di [halaman rilis terbaru](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest).

Unduh `WhatsApp Downloads.dmg`, buka, lalu seret **WhatsApp Downloads** ke
*Applications*. Setelah itu buka aplikasinya **dari folder Applications**, bukan dari
image-nya, dan ia akan memasang dirinya sendiri di latar belakang.

Aplikasi ini tidak ditandatangani dengan sertifikat pengembang Apple, jadi peluncuran
pertama diblokir dengan pesan *"berkas rusak"* atau *"tidak dapat diverifikasi"*. Pilih
salah satu:

- klik kanan aplikasinya lalu pilih **Open**; kalau jendelanya hanya menawarkan *Done* /
  *Move to Trash*, buka *System Settings → Privacy & Security* dan klik
  **Open Anyway**; atau
- hapus tanda karantina sekali saja:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

Kalau kamu sudah memasang versi baris perintah, membuka aplikasi ini akan mengganti agen
latar belakangnya dengan yang menunjuk ke `/Applications/WhatsApp Downloads.app`.

Untuk membangun image-nya sendiri:

```sh
./build.sh
```

## Pemasangan lewat baris perintah

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

Setelah itu macOS akan meminta izin akses folder Downloads untuk **WhatsAppDownloads** —
klik **Allow**. Kalau dialognya terlewat, aktifkan lewat
*System Settings → Privacy & Security → Files and Folders*.

Untuk mengeceknya: taruh sebuah berkas bernama `WhatsApp test.jpg` di `~/Downloads`.

## Menghapus pemasangan

```sh
./uninstall.sh
```

Berkas Anda tetap di tempatnya; yang dihapus hanya pemindahnya.

## Apa saja yang dipasang

| Lokasi | Keterangan |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | pemindah berkas, sekitar 15 baris zsh |
| `~/Applications/WhatsAppDownloads.app` | pembungkus mungil yang menjalankan skrip |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | membangunkannya setiap `~/Downloads` berubah |

Versi yang dipasang dengan menyeret hanya menaruh `/Applications/WhatsApp Downloads.app`
ditambah `~/Library/LaunchAgents/WhatsAppDownloads.plist` yang sama. `./uninstall.sh`
menghapus kedua varian.

Kenapa harus berupa app bundle? macOS memberikan izin akses folder per aplikasi. Skrip
shell polos yang dijalankan launchd hanya akan melihat folder Downloads yang kosong dan
diam-diam tidak melakukan apa-apa, jadi skripnya ditaruh di dalam sebuah app yang bisa
memegang izin tersebut.

Ia muncul di *System Settings → General → Login Items → Allow in the Background*
sebagai **WhatsAppDownloads**, dan di situ Anda bisa mematikannya. App ini dibangun di
mesin Anda sendiri dan ditandatangani secara lokal, jadi macOS menyebut pengembangnya
belum terverifikasi.

## Cara kerjanya

- Memindahkan berkas yang namanya diawali `WhatsApp ` — begitulah aplikasinya memberi nama.
- Tidak pernah menimpa: kalau ada nama yang bentrok, jadinya `WhatsApp Image ... (1).jpeg`.
- Melewati berkas `.crdownload`, `.part` dan `.download` sampai unduhan browser selesai.
- Folder dan berkas lainnya dibiarkan apa adanya.

## Konfigurasi

Ubah tiga variabel di bagian atas `whatsapp-downloads.sh`, atau setel `WA_SRC`,
`WA_DST` dan `WA_PREFIX`. Kalau `WA_SRC` diarahkan ke folder di luar `~/Downloads`,
macOS akan meminta izin untuk folder itu.

## Pengujian

```sh
./test.sh
```

Butuh sekitar 90 detik dan benar-benar menguji jalur latar belakang yang sesungguhnya —
launchd, app-nya, dan izinnya — bukan sekadar memanggil skripnya langsung. Berkas yang
dibuat hanya yang mengandung `cctest` pada namanya, dan semuanya dihapus setelah selesai.

## Kebutuhan sistem

macOS 13 atau lebih baru. Tanpa dependensi.

## Dukungan

Ini alat pribadi kecil yang dirilis apa adanya. Issue dan pull request diterima dengan
senang hati, tapi tidak ada janji akan dibalas.

## Lisensi

MIT
