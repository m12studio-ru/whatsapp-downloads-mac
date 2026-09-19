# WhatsApp Downloads

⬇️ **[Télécharger l'installateur](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest/download/WhatsApp.Downloads.dmg)** (`WhatsApp Downloads.dmg`, macOS 13+)

🇬🇧 [English](README.md) · 🇨🇳 [简体中文](README.zh.md) · 🇮🇳 [हिन्दी](README.hi.md) · 🇪🇸 [Español](README.es.md) · 🇸🇦 [العربية](README.ar.md) · 🇫🇷 [Français](README.fr.md) · 🇧🇷 [Português](README.pt.md) · 🇷🇺 [Русский](README.ru.md) · 🇯🇵 [日本語](README.ja.md) · 🇩🇪 [Deutsch](README.de.md) · 🇮🇩 [Bahasa Indonesia](README.id.md) · 🇹🇷 [Türkçe](README.tr.md)

WhatsApp pour Mac enregistre tout directement dans `~/Downloads`, et aucun réglage ne
permet d'y changer quoi que ce soit. Cet outil lui donne son propre dossier, comme
Telegram Desktop en a un.

Tout ce que WhatsApp enregistre apparaît dans `~/Downloads/WhatsApp` deux ou trois
secondes plus tard. Le reste de `~/Downloads` n'est jamais touché.

## Installation par glisser-déposer

Le fichier se trouve sur la [page de la dernière version](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest).

Téléchargez `WhatsApp Downloads.dmg`, ouvrez-le et faites glisser **WhatsApp Downloads**
dans *Applications*. Ouvrez-le ensuite **depuis le dossier Applications**, pas depuis
l'image disque : il s'installe tout seul en arrière-plan.

L'app n'est pas signée avec un certificat de développeur Apple, donc le premier lancement
est bloqué avec *« le fichier est endommagé »* ou *« impossible de vérifier »*. Deux
solutions :

- clic droit sur l'app puis **Ouvrir** ; si la fenêtre ne propose que *Terminé* /
  *Placer dans la corbeille*, allez dans *Réglages Système → Confidentialité et sécurité*
  et cliquez sur **Ouvrir quand même** ; ou
- retirez une bonne fois l'attribut de quarantaine :

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

Si vous aviez déjà installé la version en ligne de commande, ouvrir l'app remplace son
agent d'arrière-plan par un agent pointant vers `/Applications/WhatsApp Downloads.app`.

L'app est signée sur votre propre Mac, pas par Apple. Chaque nouvelle version lui
apparaît donc comme une autre app : après l'avoir remplacée, macOS redemande l'accès
au dossier Téléchargements.

Pour construire l'image disque vous-même, il vous faut les outils en ligne de commande
de Xcode, les outils de développement d'Apple (`xcode-select --install`), puis :

```sh
./build.sh
```

## Installation en ligne de commande

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

macOS demandera alors l'accès à votre dossier Téléchargements pour
**WhatsAppDownloads** — cliquez sur **Autoriser**. Si la fenêtre vous échappe, vous
pouvez activer l'accès dans *Réglages Système → Confidentialité et sécurité →
Fichiers et dossiers*.

Pour vérifier que tout fonctionne : déposez un fichier nommé `WhatsApp test.jpg`
dans `~/Downloads`.

## Désinstallation

```sh
./uninstall.sh
```

Vos fichiers restent où ils sont ; seul le programme de déplacement est supprimé.

## Ce qui est installé

| Chemin | De quoi il s'agit |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | le script qui déplace les fichiers, un court script zsh |
| `~/Applications/WhatsAppDownloads.app` | une petite enveloppe qui lance le script |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | réveille le tout dès que `~/Downloads` change |

La version installée par glisser-déposer ne pose que `/Applications/WhatsApp Downloads.app`
et le même `~/Library/LaunchAgents/WhatsAppDownloads.plist`. `./uninstall.sh` supprime
l'agent et tout ce qu'il a installé dans votre dossier personnel ; supprimer
`/Applications/WhatsApp Downloads.app` peut demander un administrateur, et le script
vous prévient s'il n'y est pas parvenu.

Pourquoi une application ? Parce que macOS accorde l'accès aux dossiers application
par application. Un simple script shell lancé par launchd voit un dossier
Téléchargements vide et ne fait rien du tout, sans le moindre message. Le script est
donc logé dans une app, qui, elle, peut détenir l'autorisation.

Il apparaît sous le nom **WhatsAppDownloads** dans *Réglages Système → Général →
Ouverture → Autoriser en arrière-plan*, où vous pouvez le désactiver.

## Comportement

- Déplace les fichiers dont le nom commence par `WhatsApp ` — c'est ainsi que l'app les nomme.
- N'écrase jamais rien : en cas de conflit, le fichier devient `WhatsApp Image ... (1).jpeg`.
- Ignore les fichiers `.crdownload`, `.part` et `.download` tant que le navigateur n'a pas fini.
- Ne touche ni aux dossiers ni à aucun autre fichier.

## Configuration

Modifiez les trois variables en haut de `whatsapp-downloads.sh`, ou définissez
`WA_SRC`, `WA_DST` et `WA_PREFIX`. Si vous pointez `WA_SRC` vers un dossier situé
hors de `~/Downloads`, macOS demandera l'accès à ce dossier-là.

## Tests

```sh
./test.sh
```

Comptez environ 90 secondes. Le test parcourt le vrai chemin d'exécution en arrière-plan
— launchd, l'app et l'autorisation — plutôt que d'appeler le script directement. Il
n'écrit que des fichiers contenant `cctest` dans leur nom, et les supprime ensuite.

## Prérequis

macOS 13 ou plus récent. Aucune dépendance.

## Assistance

Il s'agit d'un petit outil personnel, fourni tel quel. Les issues et les pull requests
sont les bienvenues, mais aucune réponse n'est garantie.

## Licence

MIT

## Marque déposée

Ce projet n’est ni affilié à WhatsApp Inc. ou Meta Platforms, Inc., ni approuvé par eux. WhatsApp est une marque de son propriétaire.
