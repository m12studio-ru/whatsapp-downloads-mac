# WhatsApp Downloads

⬇️ **[Download the installer](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest/download/WhatsApp.Downloads.dmg)** (`WhatsApp Downloads.dmg`, macOS 13+)

🇬🇧 [English](README.md) · 🇨🇳 [简体中文](README.zh.md) · 🇮🇳 [हिन्दी](README.hi.md) · 🇪🇸 [Español](README.es.md) · 🇸🇦 [العربية](README.ar.md) · 🇫🇷 [Français](README.fr.md) · 🇧🇷 [Português](README.pt.md) · 🇷🇺 [Русский](README.ru.md) · 🇯🇵 [日本語](README.ja.md) · 🇩🇪 [Deutsch](README.de.md) · 🇮🇩 [Bahasa Indonesia](README.id.md) · 🇹🇷 [Türkçe](README.tr.md)

WhatsApp for Mac saves everything straight into `~/Downloads` and has no setting to
change that. This gives it its own folder, the way Telegram Desktop has one.

Anything WhatsApp saves shows up in `~/Downloads/WhatsApp` a couple of seconds later.
Nothing else in `~/Downloads` is touched.

## Install by dragging

The file lives on the [latest release page](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest).

Download `WhatsApp Downloads.dmg`, open it and drag **WhatsApp Downloads** into
*Applications*. Open it **from the Applications folder** — not from the disk image —
and it installs itself in the background.

The app is not signed with an Apple developer certificate, so the first launch is
blocked with *"the file is damaged"* or *"cannot be verified"*. Either:

- right-click the app and choose **Open**, and if the window only offers *Done* /
  *Move to Trash*, go to *System Settings → Privacy & Security* and click
  **Open Anyway** there; or
- remove the quarantine flag once:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

If you already installed the command-line version, opening the app replaces its
background agent with one pointing at `/Applications/WhatsApp Downloads.app`.

The app is signed on your own Mac, not by Apple. Every new build therefore looks
like a different app to macOS, so after you replace it, it asks for access to
Downloads again.

To build the disk image yourself you need the Xcode Command Line Tools
(`xcode-select --install`), then:

```sh
./build.sh
```

## Install from the command line

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

macOS will then ask **WhatsAppDownloads** for access to your Downloads folder —
click **Allow**. If you miss the dialog, turn it on under
*System Settings → Privacy & Security → Files and Folders*.

To check: drop a file named `WhatsApp test.jpg` into `~/Downloads`.

## Uninstall

```sh
./uninstall.sh
```

Your files stay where they are; only the mover is removed.

## What it installs

| Path | What it is |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | the mover, a short zsh script |
| `~/Applications/WhatsAppDownloads.app` | tiny wrapper that runs the script |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | wakes it when `~/Downloads` changes |

The drag-and-drop version installs only `/Applications/WhatsApp Downloads.app` plus
the same `~/Library/LaunchAgents/WhatsAppDownloads.plist`. `./uninstall.sh` removes
the agent and everything it installed in your home folder; deleting
`/Applications/WhatsApp Downloads.app` may need an administrator, and the script
tells you if it could not.

Why the app bundle? macOS grants folder access per application. A bare shell script
started by launchd sees an empty Downloads folder and silently does nothing, so the
script lives inside an app that can hold the permission.

It shows up in *System Settings → General → Login Items → Allow in the Background*
as **WhatsAppDownloads**, where you can switch it off.

## Behaviour

- Moves files whose name starts with `WhatsApp ` — that is how the app names them.
- Never overwrites: a clash becomes `WhatsApp Image ... (1).jpeg`.
- Skips `.crdownload`, `.part` and `.download` files until the browser is done.
- Leaves folders and every other file alone.

## Configuration

Edit the three variables at the top of `whatsapp-downloads.sh`: `WA_SRC`,
`WA_DST` and `WA_PREFIX`. To watch a folder other than `~/Downloads`, change
`WA_SRC` **and** the `WatchPaths` entry in
`~/Library/LaunchAgents/WhatsAppDownloads.plist` — otherwise the script keeps
waking up on `~/Downloads` instead. macOS will then ask for access to the new
folder.

The drag-and-drop version rewrites that plist on every launch and keeps its copy
of the script inside the app, so configuration is only practical with the
command-line install.

## Tests

```sh
./test.sh
```

Takes about 90 seconds and exercises the real background path — launchd, the app
and the permission — rather than calling the script directly. It writes only files
with `cctest` in the name and deletes them afterwards.

## Requirements

macOS 13 or newer. No dependencies.

## Support

This is a small personal tool released as-is. Issues and pull requests are welcome,
but there is no promise of a reply.

## License

MIT

## Trademark

This project is not affiliated with, endorsed by or connected to WhatsApp Inc. or
Meta Platforms, Inc. WhatsApp is a trademark of its owner.
