{ config, lib, pkgs, ... }:

{
  options.services.nix-index-database = {
    enable = lib.mkEnableOption "Automatically update the nix-index database";

    upstreamPath = lib.mkOption rec {
      type = lib.types.str;
      default = https://github.com/Mic92/nix-index-database/releases/latest/download;
      example = default;
      description = ''
        The upstream URL to fetch the index database from.
      '';
    };
  };

  config =
    let
      cfg = config.services.nix-index-database;
      nix-index-database = "${pkgs.writeShellScript "nix-index-database-fetch.sh" ''
          set -exuo pipefail
          PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.wget ]};
          filename="index-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')"
          mkdir -p "$XDG_CACHE_HOME/nix-index"
          cd "$XDG_CACHE_HOME/nix-index"
          wget -nv -N ${lib.strings.escapeShellArg (builtins.toString cfg.upstreamPath)}/"$filename"
          ln -f "$filename" files
        ''}";
    in
    lib.mkMerge [
      (lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
        systemd.user.services.nix-index-database = {
          Unit = { Description = "Update the nix-index database cache"; };
          Service = {
            Type = "oneshot";
            ExecStart = nix-index-database;
          };
        };

        systemd.user.timers.nix-index-database = {
          Unit = { Description = "Update the nix-index database cache"; };
          Timer = { OnCalendar = "daily"; };
          Install = { WantedBy = [ "timers.target" ]; };
        };
      })
      (lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isDarwin) {
        #   Unit = { Description = "Update the nix-index database cache"; };
        launchd.agents."nix-index-database" = {
          enable = true;
          config = {
            Program = nix-index-database;
            StartCalendarInterval = [{
              Hour = 5;
            }];
            StandardOutPath = "/tmp/nix-index.log";
            StandardErrorPath = "/tmp/nix-index.err.log";
            EnvironmentVariables = {
              XDG_CACHE_HOME = config.xdg.cacheHome;
              # Use system certs
              SSL_CERT_FILE = "/etc/ssl/cert.pem";
            };
          };
        };
      })
    ];
}
