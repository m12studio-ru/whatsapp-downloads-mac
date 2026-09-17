#!/bin/zsh
# Installs the WhatsApp Downloads mover: script, launcher app, launchd agent.
set -e
here=${0:A:h}
app=~/Applications/WhatsAppDownloads.app
script=~/.local/bin/whatsapp-downloads.sh
plist=~/Library/LaunchAgents/WhatsAppDownloads.plist
label=WhatsAppDownloads

mkdir -p ~/.local/bin ~/Applications ~/Library/LaunchAgents ~/Downloads/WhatsApp
install -m 755 $here/whatsapp-downloads.sh $script

# The launchd agent cannot read ~/Downloads on its own: macOS grants folder
# access per application, so the script runs inside a tiny app bundle.
launchctl bootout gui/$(id -u)/$label 2>/dev/null || true
rm -rf $app
osacompile -o $app -e "do shell script \"$script\"" >/dev/null
/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' $app/Contents/Info.plist >/dev/null
# rename the executable so System Settings shows the app name, not "applet"
mv $app/Contents/MacOS/applet $app/Contents/MacOS/$label
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable $label" $app/Contents/Info.plist >/dev/null
codesign --force --deep -s - $app 2>/dev/null

cat > $plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>$label</string>
  <key>Program</key><string>$HOME/Applications/WhatsAppDownloads.app/Contents/MacOS/$label</string>
  <key>WatchPaths</key><array><string>$HOME/Downloads</string></array>
  <key>RunAtLoad</key><true/>
</dict></plist>
EOF
launchctl bootstrap gui/$(id -u) $plist

cat <<'EOF'

Installed.

ONE MANUAL STEP: macOS will ask WhatsAppDownloads for access to your Downloads
folder the first time it runs. Click Allow. If you miss the dialog, go to
System Settings > Privacy & Security > Files and Folders > WhatsAppDownloads
and switch on Downloads Folder.

To check it works, drop a file named "WhatsApp test.jpg" into ~/Downloads;
it should land in ~/Downloads/WhatsApp within a few seconds.
EOF
