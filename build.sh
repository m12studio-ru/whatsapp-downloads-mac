#!/bin/zsh
# Builds dist/WhatsApp Downloads.app and a .dmg for drag-and-drop installation.
set -e
here=${0:A:h}
cd $here
name="WhatsApp Downloads"
label=WhatsAppDownloads
app="dist/$name.app"
dmg="dist/$name.dmg"

# The stub below is compiled with cc, which only exists with the Xcode Command
# Line Tools; without them /usr/bin/cc pops up the installer and fails.
if ! xcode-select -p >/dev/null 2>&1 || ! /usr/bin/cc --version >/dev/null 2>&1; then
  print -u2 -r -- "build.sh needs the Xcode Command Line Tools (for the C compiler).
Install them with:

    xcode-select --install

then run ./build.sh again."
  exit 1
fi

rm -rf dist
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

install -m 755 whatsapp-downloads.sh "$app/Contents/Resources/whatsapp-downloads.sh"

# The main executable must be a real binary: launchd exec'ing a shell script
# would make /bin/zsh the process image, and macOS would then attach the
# Downloads-folder permission to the interpreter instead of this app. The stub
# runs the helper as a child process, so the app keeps being the responsible
# process and the permission stays with it.
stub=$(mktemp -d)/stub.c
cat > $stub <<'C'
#include <mach-o/dyld.h>
#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char **argv) {
  char buf[PATH_MAX], real[PATH_MAX], helper[PATH_MAX];
  uint32_t size = sizeof(buf);
  if (_NSGetExecutablePath(buf, &size) != 0) return 1;
  if (realpath(buf, real) == NULL) return 1;
  /* .../Contents/MacOS/<exe> -> .../Contents/Resources/helper.zsh */
  snprintf(helper, sizeof(helper), "%s/../Resources/helper.zsh", dirname(real));

  char **args = calloc(argc + 2, sizeof(char *));
  args[0] = "/bin/zsh";
  args[1] = helper;
  for (int i = 1; i < argc; i++) args[i + 1] = argv[i];

  pid_t pid = fork();
  if (pid < 0) return 1;
  if (pid == 0) { execv("/bin/zsh", args); _exit(127); }
  int status = 0;
  while (waitpid(pid, &status, 0) < 0) ;
  return WIFEXITED(status) ? WEXITSTATUS(status) : 1;
}
C
# universal: a single-architecture build would die with "bad CPU type" on the
# other kind of Mac, and the .dmg is meant to be downloaded by anyone
/usr/bin/cc -O2 -arch arm64 -arch x86_64 -o "$app/Contents/MacOS/$label" $stub
rm -rf ${stub:h}
echo "executable architectures: $(lipo -archs "$app/Contents/MacOS/$label")"

cat > "$app/Contents/Resources/helper.zsh" <<'EOF'
#!/bin/zsh
# Three modes: --move (launchd), --install (silent), no arguments (double click).
bundle=${0:A:h:h:h}                 # .../WhatsApp Downloads.app, wherever it is
res=$bundle/Contents/Resources
target=$bundle/Contents/MacOS/WhatsAppDownloads
plist=$HOME/Library/LaunchAgents/WhatsAppDownloads.plist
log=$HOME/Library/Logs/WhatsAppDownloads.log

note() {
  mkdir -p ${log:h} 2>/dev/null
  print -r -- "$(date '+%Y-%m-%d %H:%M:%S') $*" >> $log 2>/dev/null
  logger -t WhatsAppDownloads -- "$*" 2>/dev/null
}

# This app is LSUIElement, so a failing dialog would leave a double click with
# no feedback at all; log both the message and any osascript error.
dialog() {
  local out
  note "dialog: ${1%%$'\n'*}"
  out=$(osascript - "$1" <<'AS' 2>&1
on run argv
  display dialog (item 1 of argv) buttons {"OK"} default button "OK" with title "WhatsApp Downloads"
end run
AS
  ) || note "osascript failed: $out"
}

# The agent points at wherever the bundle sits now, so a bundle living outside
# an Applications folder breaks silently as soon as it is moved or cleaned up.
location_warning() {
  [[ $bundle == /Applications/* || $bundle == $HOME/Applications/* ]] && return 1
  print -r -- "WhatsApp Downloads is running from

$bundle

The background helper will point at that exact location and stop working if the app is moved or deleted. Keep it in your Applications folder."
  return 0
}

# Paths can contain & < >, which would produce a plist launchd cannot parse.
xml_esc() { local s=${1//&/&amp;}; s=${s//</&lt;}; print -r -- ${s//>/&gt;} }

install_agent() {
  mkdir -p "$HOME/Library/LaunchAgents"
  local new=$plist.new
  local target_x=$(xml_esc "$target") watch_x=$(xml_esc "$HOME/Downloads")
  cat > $new <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>WhatsAppDownloads</string>
  <key>ProgramArguments</key><array>
    <string>$target_x</string>
    <string>--move</string>
  </array>
  <key>WatchPaths</key><array><string>$watch_x</string></array>
  <key>RunAtLoad</key><true/>
</dict></plist>
PLIST
  local lint
  if ! lint=$(plutil -lint $new 2>&1); then
    rm -f $new
    note "generated a broken agent plist: $lint"
    print -r -- "Could not write a valid launch agent for this location: $lint" >&2
    return 1
  fi
  if [[ -n $WA_DRY ]]; then
    mv $new $plist
    return 0
  fi
  local uid=$(id -u) backup= out i
  # keep the previous agent so a failed install can be rolled back
  if [[ -f $plist ]]; then backup=$(mktemp); cp $plist $backup; fi
  launchctl bootout gui/$uid/WhatsAppDownloads 2>/dev/null
  mv $new $plist
  # bootout is asynchronous: bootstrap right after it can fail with
  # "Operation already in progress", so retry for a few seconds.
  for i in {1..10}; do
    if out=$(launchctl bootstrap gui/$uid $plist 2>&1); then
      [[ -n $backup ]] && rm -f $backup
      return 0
    fi
    sleep 1
  done
  if [[ -n $backup ]]; then
    mv $backup $plist
    launchctl bootstrap gui/$uid $plist 2>/dev/null
    note "install failed, restored the previous agent: $out"
  else
    rm -f $plist
    note "install failed: $out"
  fi
  print -r -- "$out"
  return 1
}

volume_message="WhatsApp Downloads is running from the disk image.

Drag it into your Applications folder first, then open it from there - otherwise the helper would point at a path that disappears as soon as the image is ejected."

# Opening the app straight from the .dmg does not always leave it under
# /Volumes: a quarantined bundle is started through App Translocation from a
# read-only copy in /private/var/folders/.../AppTranslocation/<uuid>/d/, which
# disappears just as fast. Treat both as "not installed yet".
transient_location() {
  [[ $bundle == /Volumes/* || $bundle == */AppTranslocation/* || $bundle == /private/var/folders/* ]]
}

if [[ $# -gt 0 && $1 != --move && $1 != --install ]]; then
  print -u2 -r -- "unknown option: $1
usage: WhatsAppDownloads [--install|--move]"
  exit 2
fi

case ${1:-} in
  --move)
    # a child process, not exec: replacing this image with zsh would throw away
    # the bundle identity the Downloads-folder permission is attached to
    "$res/whatsapp-downloads.sh"
    ;;
  --install)
    if transient_location; then
      print -r -- "$volume_message" >&2
      note "refused to install from $bundle"
      exit 1
    fi
    if warn=$(location_warning); then
      print -r -- "$warn" >&2
      note "$warn"
    fi
    install_agent
    ;;
  *)
    if transient_location; then
      dialog "$volume_message"
      exit 1
    fi
    replaces=
    [[ -f $plist ]] && replaces="This replaces the WhatsApp Downloads helper you had before, including one set up by install.sh from the command line.

"
    warn=
    if warn=$(location_warning); then warn="$warn

"; else warn=; fi
    if err=$(install_agent 2>&1); then
      dialog "${warn}${replaces}WhatsApp Downloads is now running.

New WhatsApp files in your Downloads folder will move into Downloads/WhatsApp within a few seconds.

macOS will ask this app for access to your Downloads folder the first time it runs - click Allow."
    else
      dialog "Could not install the background agent.

$err"
      exit 1
    fi
    ;;
esac
exit 0
EOF
chmod 755 "$app/Contents/Resources/helper.zsh"

cat > "$app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleName</key><string>$name</string>
  <key>CFBundleDisplayName</key><string>$name</string>
  <key>CFBundleIdentifier</key><string>ru.m12studio.whatsapp-downloads</string>
  <key>CFBundleExecutable</key><string>$label</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>LSUIElement</key><true/>
</dict></plist>
EOF

codesign --force --deep -s - "$app"
codesign --verify --deep "$app"

# disk image with the app and a shortcut to /Applications, so it can be dragged
stage=$(mktemp -d)
cp -R "$app" "$stage/$name.app"
ln -s /Applications "$stage/Applications"
hdiutil create -volname "$name" -srcfolder "$stage" -ov -format UDZO "$dmg" >/dev/null
rm -rf "$stage"

echo "built $app and $dmg"
