dein="$HOME/.local/share/dein"
tmpfile=`mktemp`

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > "$tmpfile"
mkdir -p "$dein"
sh "$tmpfile" "$dein"
rm -f "$tmpfile"
