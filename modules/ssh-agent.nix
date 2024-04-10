{
  config,
  lib,
  pkgs,
  ...
}:
{
  disabledModules = [ "services/ssh-agent.nix" ];

  options.services.ssh-agent = {
    enable = lib.mkEnableOption "Setup ssh-agent for MacOS";
  };

  config =
    let
      startSSHAgent = pkgs.writeShellScript "start-ssh-agent.sh" ''
        SSH_ENV="$HOME/.ssh/agent-environment"

        if [ -f "$SSH_ENV" ]; then
          source "$SSH_ENV" > /dev/null
        fi

        if ! ${pkgs.ps}/bin/ps "$SSH_AGENT_PID" > /dev/null ; then
          ${pkgs.openssh}/bin/ssh-agent | ${pkgs.gnused}/bin/sed '/echo/d' > "$SSH_ENV"
          source "$SSH_ENV" > /dev/null
        fi
      '';
    in
    (lib.mkIf (config.services.ssh-agent.enable) {
      home.sessionVariablesExtra = "source ${startSSHAgent}";
    });
}
