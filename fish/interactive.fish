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

set systemctl_sudo_commands start stop reload restart enable disable mask unmask edit daemon-reload reboot suspend poweroff
function sc -d "Systemctl wrapper with automatic sudo" -w systemctl
  set -l SYSTEMCTL systemctl
  test -n "$argv" && contains "$argv[1]" $systemctl_sudo_commands && set -l SYSTEMCTL sudo systemctl
  $SYSTEMCTL $argv
end
