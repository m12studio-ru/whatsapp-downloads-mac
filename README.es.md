# WhatsApp Downloads

[English](README.md) · [简体中文](README.zh.md) · [हिन्दी](README.hi.md) · [Español](README.es.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [Türkçe](README.tr.md)

WhatsApp para Mac guarda todo directamente en `~/Downloads` y no ofrece ninguna
opción para cambiarlo. Esta utilidad le da su propia carpeta, igual que la tiene
Telegram Desktop.

Todo lo que WhatsApp guarde aparece en `~/Downloads/WhatsApp` un par de segundos
después. Nada más dentro de `~/Downloads` se toca.

## Instalación arrastrando

El archivo está en la [página de la última versión](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest).

Descarga `WhatsApp Downloads.dmg`, ábrelo y arrastra **WhatsApp Downloads** a
*Aplicaciones*. Luego ábrelo **desde la carpeta Aplicaciones**, no desde la imagen de
disco, y se instalará solo en segundo plano.

La app no está firmada con un certificado de desarrollador de Apple, así que el primer
arranque se bloquea con *«el archivo está dañado»* o *«no se puede verificar»*. Hay dos
opciones:

- haz clic derecho en la app y elige **Abrir**; si la ventana solo ofrece *OK* /
  *Mover a la papelera*, ve a *Ajustes del Sistema → Privacidad y seguridad* y pulsa
  **Abrir igualmente**; o
- quita la marca de cuarentena una vez:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

Si ya habías instalado la versión de línea de comandos, abrir la app sustituye su agente
en segundo plano por otro que apunta a `/Applications/WhatsApp Downloads.app`.

Para construir la imagen de disco tú mismo:

```sh
./build.sh
```

## Instalación desde la línea de comandos

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

Después macOS pedirá acceso a tu carpeta de descargas en nombre de
**WhatsAppDownloads**: pulsa **Permitir**. Si se te pasa el aviso, actívalo en
*Ajustes del Sistema → Privacidad y seguridad → Archivos y carpetas*.

Para comprobarlo: deja un archivo llamado `WhatsApp test.jpg` en `~/Downloads`.

## Desinstalación

```sh
./uninstall.sh
```

Tus archivos se quedan donde están; solo se elimina el programa que los mueve.

## Qué se instala

| Ruta | Qué es |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | el script que mueve los archivos, unas 15 líneas de zsh |
| `~/Applications/WhatsAppDownloads.app` | una pequeña envoltura que ejecuta el script |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | lo despierta cuando `~/Downloads` cambia |

La versión que se instala arrastrando solo deja `/Applications/WhatsApp Downloads.app`
más el mismo `~/Library/LaunchAgents/WhatsAppDownloads.plist`. `./uninstall.sh` elimina
ambas variantes.

¿Por qué una app? macOS concede el acceso a carpetas por aplicación. Un script de
shell lanzado por launchd ve una carpeta de descargas vacía y no hace nada sin
avisar, así que el script vive dentro de una app que sí puede conservar el permiso.

Aparece en *Ajustes del Sistema → General → Ítems de inicio → Permitir en segundo
plano* como **WhatsAppDownloads**, donde puedes desactivarlo. Se compila en tu
propio equipo y se firma en local, por eso macOS dice que el desarrollador no está
verificado.

## Comportamiento

- Mueve los archivos cuyo nombre empieza por `WhatsApp `, que es como los nombra la app.
- Nunca sobrescribe: si hay conflicto, el archivo pasa a llamarse `WhatsApp Image ... (1).jpeg`.
- Ignora los archivos `.crdownload`, `.part` y `.download` hasta que el navegador termine.
- Deja en paz las carpetas y cualquier otro archivo.

## Configuración

Edita las tres variables del principio de `whatsapp-downloads.sh`, o define `WA_SRC`,
`WA_DST` y `WA_PREFIX`. Si cambias `WA_SRC` por una carpeta fuera de `~/Downloads`,
macOS pedirá acceso a esa carpeta en su lugar.

## Pruebas

```sh
./test.sh
```

Tarda unos 90 segundos y pone a prueba el recorrido real en segundo plano —launchd,
la app y el permiso— en vez de llamar al script directamente. Solo escribe archivos
con `cctest` en el nombre y los borra al terminar.

## Requisitos

macOS 13 o posterior. Sin dependencias.

## Soporte

Es una herramienta personal pequeña y se publica tal cual. Las incidencias y los pull
requests son bienvenidos, pero no se garantiza respuesta.

## Licencia

MIT
