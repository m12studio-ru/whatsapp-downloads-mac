#!/bin/zsh
# Tests the real background setup (launchd -> app -> script), not a manual run.
# Every test file is named *cctest* and is deleted at the end.
setopt null_glob
src=~/Downloads; dst=~/Downloads/WhatsApp; fail=0
ok()  { echo "ok   $1"; }
bad() { echo "FAIL $1"; fail=1; }
wait_gone() { for _ in {1..20}; do [[ ! -e $1 ]] && return 0; sleep 1; done; return 1; }
cleanup() { rm -rf "$src"/*cctest* "$dst"/*cctest*; }
cleanup; sleep 3

launchctl print gui/$(id -u)/WhatsAppDownloads >/dev/null 2>&1 && ok "agent loaded" || bad "agent not loaded"

# 1. a plain file is moved
echo data > "$src/WhatsApp Image cctest1.jpeg"
wait_gone "$src/WhatsApp Image cctest1.jpeg" && [[ -f "$dst/WhatsApp Image cctest1.jpeg" ]] && ok "file moved" || bad "file not moved"

# 2. name clash -> numbered copy, original untouched
echo new > "$src/WhatsApp Image cctest1.jpeg"
wait_gone "$src/WhatsApp Image cctest1.jpeg" && [[ -f "$dst/WhatsApp Image cctest1 (1).jpeg" && $(cat "$dst/WhatsApp Image cctest1.jpeg") == data ]] && ok "name clash" || bad "name clash"

# 3. no extension
echo a > "$src/WhatsApp cctest2"; wait_gone "$src/WhatsApp cctest2"
echo b > "$src/WhatsApp cctest2"; wait_gone "$src/WhatsApp cctest2"
[[ -f "$dst/WhatsApp cctest2" && -f "$dst/WhatsApp cctest2 (1)" ]] && ok "no extension" || bad "no extension: $(ls "$dst" | grep cctest2 | tr '\n' '|')"

# 4. dots in a name that has no extension
echo a > "$src/WhatsApp cctest 18.21.56"; wait_gone "$src/WhatsApp cctest 18.21.56"
echo b > "$src/WhatsApp cctest 18.21.56"; wait_gone "$src/WhatsApp cctest 18.21.56"
[[ -f "$dst/WhatsApp cctest 18.21.56 (1)" ]] && ok "dots in name" || bad "dots in name: $(ls "$dst" | grep '18.21' | tr '\n' '|')"

# 5. half-downloaded browser files are left alone
echo x > "$src/WhatsApp Image cctest.jpeg.crdownload"; echo x > "$src/WhatsApp Image cctest.jpeg.part"; sleep 8
[[ -f "$src/WhatsApp Image cctest.jpeg.crdownload" && -f "$src/WhatsApp Image cctest.jpeg.part" ]] && ok "partial downloads kept" || bad "partial downloads moved"

# 6. other files and folders are not touched
echo x > "$src/cctest-other.txt"; mkdir -p "$src/WhatsApp cctestdir"; sleep 8
[[ -f "$src/cctest-other.txt" ]] && ok "other file kept" || bad "other file touched"
[[ -d "$src/WhatsApp cctestdir" ]] && ok "folder kept" || bad "folder touched"

# 7. a burst of files while the script is already running
for n in {1..5}; do echo $n > "$src/WhatsApp Video cctest-b$n.mp4"; sleep 0.7; done
sleep 20
left=$(ls "$src" | grep -c 'cctest-b')
[[ $left == 0 && $(ls "$dst" | grep -c 'cctest-b') == 5 ]] && ok "burst of 5 files" || bad "burst: $left left behind"

# 8. a file still being written arrives intact
( for _ in {1..6}; do head -c 1048576 /dev/zero; sleep 1; done ) > "$src/WhatsApp Video cctest-big.mp4"
sleep 20
sz=$(stat -f %z "$dst/WhatsApp Video cctest-big.mp4" 2>/dev/null)
[[ $sz == 6291456 && ! -e "$src/WhatsApp Video cctest-big.mp4" ]] && ok "large file intact" || bad "large file: size=$sz"

# 9. the app is not stuck on an error dialog
sleep 5
pgrep -f 'WhatsAppDownloads.app/Contents/MacOS/' >/dev/null && bad "app still running (error dialog?)" || ok "app not stuck"

cleanup
[[ $fail == 0 ]] && echo "ALL TESTS PASSED" || echo "FAILURES"
exit $fail
