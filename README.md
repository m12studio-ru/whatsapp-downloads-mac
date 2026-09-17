# WhatsApp Downloads

WhatsApp for Mac saves everything straight into `~/Downloads` and has no setting to
change that. This gives it its own folder, the way Telegram Desktop has one.

Anything WhatsApp saves shows up in `~/Downloads/WhatsApp` a couple of seconds later.
Nothing else in `~/Downloads` is touched.

## Install

```sh
git clone https://github.com/markov12/whatsapp-downloads-mac.git
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
| `~/.local/bin/whatsapp-downloads.sh` | the mover, ~15 lines of zsh |
| `~/Applications/WhatsAppDownloads.app` | tiny wrapper that runs the script |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | wakes it when `~/Downloads` changes |

Why the app bundle? macOS grants folder access per application. A bare shell script
started by launchd sees an empty Downloads folder and silently does nothing, so the
script lives inside an app that can hold the permission.

It shows up in *System Settings → General → Login Items → Allow in the Background*
as **WhatsAppDownloads**, where you can switch it off. It is built on your machine
and signed locally, so macOS calls the developer unverified.

## Behaviour

- Moves files whose name starts with `WhatsApp ` — that is how the app names them.
- Never overwrites: a clash becomes `WhatsApp Image ... (1).jpeg`.
- Skips `.crdownload`, `.part` and `.download` files until the browser is done.
- Leaves folders and every other file alone.

## Configuration

Edit the three variables at the top of `whatsapp-downloads.sh`, or set `WA_SRC`,
`WA_DST` and `WA_PREFIX`. Changing `WA_SRC` to a folder outside `~/Downloads`
means macOS will ask for access to that folder instead.

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
