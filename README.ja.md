# WhatsApp Downloads

[English](README.md) · [简体中文](README.zh.md) · [हिन्दी](README.hi.md) · [Español](README.es.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [Türkçe](README.tr.md)

Mac 版 WhatsApp は受け取ったファイルをすべて `~/Downloads` に直接保存してしまい、
保存先を変える設定もありません。このツールは、Telegram Desktop のように
WhatsApp 専用のフォルダを用意します。

WhatsApp が保存したファイルは、数秒後に `~/Downloads/WhatsApp` に現れます。
`~/Downloads` の他のファイルには一切手を触れません。

## ドラッグ&ドロップでインストール

ファイルは[最新リリースのページ](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest)にあります。

`WhatsApp Downloads.dmg` をダウンロードして開き、**WhatsApp Downloads** を
*アプリケーション* にドラッグします。そのあとディスクイメージからではなく
**「アプリケーション」フォルダから**起動してください。バックグラウンドに自分で登録されます。

このアプリは Apple の開発者証明書で署名されていないため、初回起動は
*「ファイルが壊れています」* または *「検証できません」* と表示されて止められます。
どちらかの方法で進めてください。

- アプリを右クリックして **開く** を選ぶ。ウィンドウに *完了* / *ゴミ箱に入れる* しか
  出ない場合は *システム設定 → プライバシーとセキュリティ* で **このまま開く** を押す。
- または隔離属性を一度だけ外す:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

コマンドライン版をすでに入れている場合、このアプリを開くと既存のバックグラウンド
エージェントが `/Applications/WhatsApp Downloads.app` を指すものに置き換わります。

このアプリに署名しているのは Apple ではなく、あなたの Mac です。そのためビルドし直すたびに
macOS からは別のアプリに見え、入れ替えたあとは Downloads フォルダへのアクセスを改めて聞かれます。

ディスクイメージを自分でビルドするには Xcode のコマンドラインツール（Apple の開発者向けツール、
`xcode-select --install`）が必要です。その上で:

```sh
./build.sh
```

## コマンドラインからインストール

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

その後、macOS が **WhatsAppDownloads** にダウンロードフォルダへのアクセスを求めてきます。
**「許可」** をクリックしてください。ダイアログを見逃した場合は、
*システム設定 → プライバシーとセキュリティ → ファイルとフォルダ* からオンにできます。

動作確認は簡単です。`WhatsApp test.jpg` という名前のファイルを `~/Downloads` に置いてみてください。

## アンインストール

```sh
./uninstall.sh
```

ファイルはそのまま残ります。取り除かれるのは移動を行う仕組みだけです。

## インストールされるもの

| パス | 中身 |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | ファイルを移動する本体。短い zsh スクリプト |
| `~/Applications/WhatsAppDownloads.app` | スクリプトを実行するだけの小さなラッパー |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | `~/Downloads` が変化したときに起動させる仕掛け |

ドラッグ&ドロップ版が置くのは `/Applications/WhatsApp Downloads.app` と、同じ
`~/Library/LaunchAgents/WhatsAppDownloads.plist` だけです。`./uninstall.sh` はバックグラウンドの
仕組みとホームフォルダに置かれたものをすべて削除します。`/Applications/WhatsApp Downloads.app`
の削除には管理者権限が必要なことがあり、消せなかった場合はその旨を知らせます。

なぜアプリの形にするのか。macOS はフォルダへのアクセス権をアプリ単位で与えるからです。
launchd がシェルスクリプトを直接起動しても、そのスクリプトからは空の Downloads フォルダしか見えず、
何も起きないまま終わってしまいます。そこで、権限を持てるアプリの中にスクリプトを置いています。

*システム設定 → 一般 → ログイン項目 → バックグラウンドでの実行を許可* に
**WhatsAppDownloads** として表示され、そこからオフにできます。

## 動作

- 名前が `WhatsApp ` で始まるファイルを移動します（アプリがこの形式で名前を付けるためです）。
- 上書きはしません。同名のファイルがある場合は `WhatsApp Image ... (1).jpeg` になります。
- ダウンロード中の `.crdownload`、`.part`、`.download` は完了するまで触りません。
- フォルダやそれ以外のファイルはそのままにします。

## 設定

`whatsapp-downloads.sh` の先頭にある 3 つの変数を書き換えるか、環境変数 `WA_SRC`、
`WA_DST`、`WA_PREFIX` を設定してください。`WA_SRC` を `~/Downloads` の外にあるフォルダへ変えると、
macOS はそのフォルダへのアクセスを改めて求めてきます。

## テスト

```sh
./test.sh
```

所要時間は約 90 秒。スクリプトを直接呼ぶのではなく、launchd・アプリ・アクセス権限という
実際のバックグラウンド経路をひととおり通して確認します。作成するのは名前に `cctest` を含む
ファイルだけで、終わったあとに削除されます。

## 動作環境

macOS 13 以降。依存関係はありません。

## サポート

これは個人が作った小さなツールで、現状のまま公開しています。
Issue や Pull Request は歓迎しますが、必ず返信できるとは限りません。

## ライセンス

MIT
