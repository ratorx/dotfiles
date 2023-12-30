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
function up -d "cd to an ancestor directory"
  test (count $argv) -eq 0 && set argv 1
  set -l ancestor (string repeat -n $argv[1] "../" 2> /dev/null) || return 2
  cd $ancestor
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

if command -q systemctl
  function sc -d "systemctl wrapper with automatic sudo" -w systemctl
    if contains $argv[1] start stop reload restart enable disable mask unmask edit daemon-reload reboot suspend poweroff
      sudo systemctl $argv
    else
      systemctl $argv
    end
  end
end

# Expand !! to last command
function _last_history_item
  echo $history[1]
end
abbr -a !! --position anywhere --function _last_history_item
