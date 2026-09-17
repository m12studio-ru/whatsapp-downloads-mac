#!/bin/zsh
# Removes everything install.sh or the drag-and-drop app created. Your files are left alone.
label=WhatsAppDownloads
launchctl bootout gui/$(id -u)/$label 2>/dev/null || true
rm -f ~/Library/LaunchAgents/$label.plist ~/.local/bin/whatsapp-downloads.sh
rm -rf ~/Applications/$label.app
rm -rf ~/"Applications/WhatsApp Downloads.app"
# /Applications may need an administrator, and rm -rf would fail quietly there
rm -rf "/Applications/WhatsApp Downloads.app" 2>/dev/null
[[ -e "/Applications/WhatsApp Downloads.app" ]] && echo "Could not delete /Applications/WhatsApp Downloads.app - drag it to the Trash yourself (it needs an administrator)." >&2
echo "Removed. ~/Downloads/WhatsApp and the files in it were left untouched."
