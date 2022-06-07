{ config, lib, pkgs, ...}:

with lib;

let cfg = config.services.nix-index-database;
defaultUpstreamPath = https://github.com/Mic92/nix-index-database/releases/latest/download;
in {
  options = {
    services.nix-index-database = {
      enable = mkEnableOption "Automatically update the nix-index database";

      upstreamPath = mkOption {
        type = types.str;
        default = defaultUpstreamPath;
        example = defaultUpstreamPath;
        description = ''
          The upstream URL to fetch the index database from.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.nix-index-database = {
      Unit = { Description = "Update the nix-index database cache"; };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "nix-index-database-fetch.sh" ''
          set -euo pipefail
          PATH="${makeBinPath [ pkgs.coreutils pkgs.wget ]}"
          filename="index-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')"
          mkdir -p "$XDG_CACHE_HOME/nix-index"
          cd "$XDG_CACHE_HOME/nix-index"
          wget -nv -N "${strings.escapeShellArg cfg.upstreamPath}/$filename"
          ln -f "$filename" files
        ''}";
      };
    };

    systemd.user.timers.nix-index-database = {
      Unit = { Description = "Update the nix-index database cache"; };
      Timer = { OnCalendar = "daily"; };
      Install = { WantedBy = ["timers.target"]; };
    };
  };
}
