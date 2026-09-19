# WhatsApp Downloads

⬇️ **[Installer herunterladen](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest/download/WhatsApp.Downloads.dmg)** (`WhatsApp Downloads.dmg`, macOS 13+)

🇬🇧 [English](README.md) · 🇨🇳 [简体中文](README.zh.md) · 🇮🇳 [हिन्दी](README.hi.md) · 🇪🇸 [Español](README.es.md) · 🇸🇦 [العربية](README.ar.md) · 🇫🇷 [Français](README.fr.md) · 🇧🇷 [Português](README.pt.md) · 🇷🇺 [Русский](README.ru.md) · 🇯🇵 [日本語](README.ja.md) · 🇩🇪 [Deutsch](README.de.md) · 🇮🇩 [Bahasa Indonesia](README.id.md) · 🇹🇷 [Türkçe](README.tr.md)

WhatsApp für Mac legt alles direkt in `~/Downloads` ab, und es gibt keine Einstellung,
um das zu ändern. Dieses Tool gibt WhatsApp einen eigenen Ordner – so wie Telegram
Desktop ihn hat.

Was WhatsApp speichert, taucht ein paar Sekunden später in `~/Downloads/WhatsApp` auf.
Alles andere in `~/Downloads` bleibt unangetastet.

## Installation per Drag-and-drop

Die Datei liegt auf der [Seite der neuesten Version](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest).

Lade `WhatsApp Downloads.dmg` herunter, öffne es und ziehe **WhatsApp Downloads** in
*Programme*. Öffne die App danach **aus dem Programme-Ordner**, nicht aus dem Image —
sie richtet sich dann selbst im Hintergrund ein.

Die App ist nicht mit einem Apple-Entwicklerzertifikat signiert, deshalb blockiert macOS
den ersten Start mit *„Die Datei ist beschädigt"* oder *„kann nicht überprüft werden"*.
Zwei Möglichkeiten:

- Rechtsklick auf die App und **Öffnen** wählen; bietet das Fenster nur *Fertig* /
  *In den Papierkorb*, dann in *Systemeinstellungen → Datenschutz & Sicherheit* auf
  **Trotzdem öffnen** klicken; oder
- das Quarantäne-Attribut einmalig entfernen:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

Wenn du die Kommandozeilen-Version bereits installiert hast, ersetzt das Öffnen der App
deren Hintergrunddienst durch einen, der auf `/Applications/WhatsApp Downloads.app` zeigt.

Die App wird auf deinem eigenen Mac signiert, nicht von Apple. Jede neue Version gilt
für macOS deshalb als andere App – nach dem Austausch fragt sie erneut nach Zugriff
auf den Downloads-Ordner.

Für das Image brauchst du die Xcode Command Line Tools, die Entwickler-Werkzeuge von
Apple (`xcode-select --install`). Dann:

```sh
./build.sh
```

## Installation über die Kommandozeile

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

Danach fragt macOS für **WhatsAppDownloads** nach Zugriff auf den Ordner „Downloads“ –
klicke auf **Erlauben**. Falls du den Dialog verpasst hast, kannst du den Zugriff unter
*Systemeinstellungen → Datenschutz & Sicherheit → Dateien und Ordner* nachträglich
aktivieren.

Zum Ausprobieren: Leg eine Datei namens `WhatsApp test.jpg` in `~/Downloads`.

## Deinstallation

```sh
./uninstall.sh
```

Deine Dateien bleiben, wo sie sind – entfernt wird nur das Verschiebe-Tool.

## Was installiert wird

| Pfad | Was es ist |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | das eigentliche Skript, ein kurzes zsh-Skript |
| `~/Applications/WhatsAppDownloads.app` | winziger Wrapper, der das Skript startet |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | weckt es, sobald sich `~/Downloads` ändert |

Die per Drag-and-drop installierte Variante legt nur `/Applications/WhatsApp Downloads.app`
und dieselbe `~/Library/LaunchAgents/WhatsAppDownloads.plist` an. `./uninstall.sh` entfernt den
Hintergrunddienst und alles, was es in deinem Benutzerordner angelegt hat; für das Löschen von
`/Applications/WhatsApp Downloads.app` kann ein Administrator nötig sein – klappt es
nicht, sagt das Skript Bescheid.

Warum ein App-Bundle? macOS vergibt Ordnerzugriff pro Programm. Ein nacktes Shell-Skript,
das von launchd gestartet wird, sieht einen leeren Downloads-Ordner und tut stillschweigend
nichts. Deshalb steckt das Skript in einer App, die die Berechtigung halten kann.

Unter *Systemeinstellungen → Allgemein → Anmeldeobjekte → Im Hintergrund erlauben*
erscheint es als **WhatsAppDownloads** und lässt sich dort abschalten.

## Verhalten

- Verschiebt Dateien, deren Name mit `WhatsApp ` beginnt – genau so benennt die App sie.
- Überschreibt nie etwas: Bei einem Namenskonflikt wird daraus `WhatsApp Image ... (1).jpeg`.
- Überspringt `.crdownload`-, `.part`- und `.download`-Dateien, bis der Browser fertig ist.
- Ordner und alle anderen Dateien bleiben unberührt.

## Konfiguration

Passe die drei Variablen am Anfang von `whatsapp-downloads.sh` an oder setze `WA_SRC`,
`WA_DST` und `WA_PREFIX`. Wenn du `WA_SRC` auf einen Ordner außerhalb von `~/Downloads`
setzt, fragt macOS stattdessen nach Zugriff auf diesen Ordner.

## Tests

```sh
./test.sh
```

Dauert etwa 90 Sekunden und testet den echten Weg im Hintergrund – launchd, die App und
die Berechtigung – statt das Skript einfach direkt aufzurufen. Angelegt werden nur Dateien
mit `cctest` im Namen, und die werden danach wieder gelöscht.

## Systemvoraussetzungen

macOS 13 oder neuer. Keine Abhängigkeiten.

## Support

Ein kleines privates Tool, veröffentlicht wie es ist. Issues und Pull Requests sind
willkommen, eine Antwort ist aber nicht garantiert.

## Lizenz

MIT

## Markenzeichen

Dieses Projekt steht in keiner Verbindung zu WhatsApp Inc. oder Meta Platforms, Inc. und wird von ihnen nicht unterstützt. WhatsApp ist eine Marke ihres Inhabers.
