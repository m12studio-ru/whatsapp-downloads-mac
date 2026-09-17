#!/bin/zsh
# Checks the drag-and-drop package: build.sh, the .app bundle, the .dmg and the
# translated READMEs. Does not touch the user's real installation.
setopt null_glob
cd ${0:A:h}
fail=0
ok()  { echo "ok   $1"; }
bad() { echo "FAIL $1"; fail=1; }

app="dist/WhatsApp Downloads.app"
dmg="dist/WhatsApp Downloads.dmg"
tmp=$(mktemp -d)
trap 'rm -rf $tmp; hdiutil detach /Volumes/WhatsApp\ Downloads -quiet 2>/dev/null' EXIT

# 1. build
rm -rf dist
[[ -x ./build.sh ]] && ./build.sh >/dev/null 2>&1 && ok "build.sh ran" || bad "build.sh failed"
[[ -d $app ]] && ok "app bundle built" || bad "no app bundle"
[[ -f $dmg ]] && ok "dmg built" || bad "no dmg"

# 2. bundle metadata
plist="$app/Contents/Info.plist"
read_key() { /usr/libexec/PlistBuddy -c "Print :$1" "$plist" 2>/dev/null }
[[ $(read_key CFBundleName) == "WhatsApp Downloads" ]] && ok "bundle name" || bad "bundle name: $(read_key CFBundleName)"
[[ $(read_key CFBundleIdentifier) == ru.m12studio.* ]] && ok "bundle id" || bad "bundle id: $(read_key CFBundleIdentifier)"
exe=$(read_key CFBundleExecutable)
[[ -n $exe && $exe != applet ]] && ok "executable renamed" || bad "executable is '$exe'"
[[ -x "$app/Contents/MacOS/$exe" ]] && ok "executable present" || bad "executable missing"
codesign --verify --deep "$app" 2>/dev/null && ok "signature valid" || bad "signature invalid"

# 3. install mode: with WA_DRY=1 it must write the agent into a fake HOME and
#    must not touch launchd or the real home folder
fake=$tmp/home; mkdir -p $fake
HOME=$fake WA_DRY=1 "$app/Contents/MacOS/$exe" --install >$tmp/out 2>&1
[[ $? == 0 ]] && ok "install mode exit 0" || bad "install mode failed: $(tail -1 $tmp/out)"
[[ -f $fake/Library/LaunchAgents/WhatsAppDownloads.plist ]] && ok "agent written" || bad "no agent plist"
grep -q "$PWD/dist/WhatsApp Downloads.app\|/Applications/WhatsApp Downloads.app" $fake/Library/LaunchAgents/WhatsAppDownloads.plist 2>/dev/null && ok "agent points at the app" || bad "agent points elsewhere"

# 4. move mode: honours WA_SRC / WA_DST, moves only WhatsApp files
mkdir -p $tmp/src $tmp/dst
echo a > "$tmp/src/WhatsApp Image x.jpeg"; echo b > "$tmp/src/other.txt"
WA_SRC=$tmp/src WA_DST=$tmp/dst "$app/Contents/MacOS/$exe" --move >/dev/null 2>&1
[[ -f "$tmp/dst/WhatsApp Image x.jpeg" && -f "$tmp/src/other.txt" ]] && ok "move mode" || bad "move mode"

# 5. dmg contents: the app and a shortcut to /Applications for dragging
hdiutil attach "$dmg" -nobrowse -quiet -mountpoint $tmp/mnt 2>/dev/null && ok "dmg mounts" || bad "dmg does not mount"
[[ -d "$tmp/mnt/WhatsApp Downloads.app" ]] && ok "app inside dmg" || bad "no app inside dmg"
[[ -L "$tmp/mnt/Applications" ]] && ok "Applications shortcut" || bad "no Applications shortcut"
hdiutil detach $tmp/mnt -quiet 2>/dev/null

# 6. translated READMEs
langs=(zh hi es ar fr pt ru ja de id tr)
missing=()
for l in $langs; do [[ -f README.$l.md ]] || missing+=$l; done
(( ${#missing} == 0 )) && ok "12 readmes present" || bad "missing readmes: ${missing[*]}"
for f in README.md README.*.md; do
  grep -q 'README.zh.md' $f || { bad "no language links in $f"; break }
done
[[ $fail == 0 ]] && ok "language links everywhere"

[[ $fail == 0 ]] && echo "ALL PACKAGE TESTS PASSED" || echo "FAILURES"
exit $fail
