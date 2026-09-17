#!/bin/zsh
# Removes everything install.sh created. Your files are left alone.
label=WhatsAppDownloads
launchctl bootout gui/$(id -u)/$label 2>/dev/null || true
rm -f ~/Library/LaunchAgents/$label.plist ~/.local/bin/whatsapp-downloads.sh
rm -rf ~/Applications/$label.app
echo "Removed. ~/Downloads/WhatsApp and the files in it were left untouched."
