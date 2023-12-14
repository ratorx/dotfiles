# Disable default greeting
set fish_greeting

# Prompt customisation
set fish_color_command green
set fish_color_redirection white
set fish_color_end magenta
set fish_color_comment brwhite
set fish_color_autosuggestion brwhite
set fish_color_param white
set fish_color_cwd blue
set fish_color_user yellow
set fish_color_host brwhite
set fish_color_host_remote green

# Functions
# From https://raw.githubusercontent.com/mattmc3/up.fish/main/functions/up.fish
function up -d "Go to an ancestor directory"
  test -n "$argv" || set argv "1"
  set -l p (string repeat -n "$argv[1]" "../" 2>/dev/null) || begin
    echo "Usage: "(status function)" <levels>" >&2
    return 2
  end
  cd $p
end

function tmpd -d "cd to a new temporary directory"
  if test (count $argv) -eq 0
    set -ga TMPD_STACK (mktemp -d) || return $status
    set argv -1
  end

  test (count $TMPD_STACK) -ge (math abs $argv[1] 2> /dev/null) 2> /dev/null || return 2
  cd $TMPD_STACK[$argv[1]]
end

function _tmpd_on_exit -e fish_exit
  for dir in $TMPD_STACK
    command rm -rf -- $dir
  end
end

function sc -d "Systemctl wrapper with automatic sudo" -w systemctl
  set -l systemctl_sudo_commands start stop reload restart enable disable mask unmask edit daemon-reload reboot suspend poweroff
  set -l systemctl systemctl
  test -n "$argv" && contains "$argv[1]" $systemctl_sudo_commands && set -l systemctl sudo systemctl
  $systemctl $argv
end

# Expand !! to last command
function last_history_item
  echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item
