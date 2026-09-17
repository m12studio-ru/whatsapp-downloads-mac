#!/bin/zsh
# Moves WhatsApp files out of ~/Downloads into a folder of their own.
# Started by launchd whenever ~/Downloads changes.
setopt null_glob

src=${WA_SRC:-~/Downloads}          # watched folder
dst=${WA_DST:-~/Downloads/WhatsApp} # where files go
prefix=${WA_PREFIX:-WhatsApp }      # filenames starting with this are moved

mkdir -p $dst
sleep 2  # let WhatsApp finish writing

for f in "$src"/${prefix}*(.); do
  case $f in *.crdownload|*.part|*.download) continue ;; esac  # still downloading
  name=${f:t}; base=${name:r}; ext=${name:e}
  # treat as an extension only if short and containing letters (not "56" in "18.21.56")
  if [[ $ext == *[[:alpha:]]* && ${#ext} -le 5 ]]; then ext=".$ext"; else base=$name; ext=; fi
  target="$dst/$name"; i=1
  # mv -n never overwrites; if the file stayed put, try the next number
  until [[ ! -e $target ]] && mv -n "$f" "$target" && [[ ! -e $f ]]; do
    target="$dst/$base ($i)$ext"; ((i++)); (( i > 999 )) && break
  done
done
exit 0  # a non-zero exit makes the app show an error dialog and hang
