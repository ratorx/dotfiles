# shellcheck shell=bash

# shellcheck source=/dev/null
[[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

# Interactive, SHELL is bash and fish exists
# Deliberatelly does not point to a full nix path to prevent skew when package updated
if [[ "$-" =~ i && "$(basename "$SHELL")" == "bash" ]] && FISH="$(command -v fish)"; then
  exec env SHELL="$FISH" "$FISH"
fi
