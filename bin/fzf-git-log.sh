# shellcheck shell=bash
# Two panel git log browser. Commits on left, diff preview on right.

# Non-breaking space
delim="$(echo -e '\u00a0')"
# <short commit> (branch) <message> <when> <author> <full commit>
# %C(auto) enables colours based on git config
fmt="%C(auto)%h%d$delim%s$delim%C(dim)%cr%C(auto)$delim%an$delim%H"
cmd="git show --color=always {-1}"

glog() {
  git log --color=always --format="$fmt" "$@" |
    # Don't display the full commit, use only message and author for searches
    # Output the full commit when chosen
    # Use tab to get a fullscreen preview
    # FZF needs explicit TTY assignments for std{in,err,out} in 'execute' to
    # prevent it from inheriting the process ones.
    fzf \
      --bind "tab:execute(LESS=\$LESS_NO_QUIT $cmd </dev/tty >/dev/tty 2>&1),backward-eof:abort" \
      --delimiter "$delim" \
      --with-nth "..-2" \
      --nth 2,4 \
      --no-sort \
      --reverse \
      --tiebreak=index \
      --no-multi \
      --ansi \
      --exit-0 \
      --preview "$cmd" |
    awk -F "$delim" '{print $NF}' |
    tr -d '\n'

  # Send through exit code
  e=$? && [ $e -eq 130 ] || [ $e -eq 1 ] || return $e
}

glog "$@"
