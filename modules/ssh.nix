{ config, lib, ... }:
{
  programs.ssh.enable = !config.variants.minimal;

  programs.ssh.controlMaster = "auto";
  programs.ssh.controlPath = "~/.ssh/ctrl-%r@%h:%p";

  programs.ssh.matchBlocks = lib.mkMerge [
    (lib.mkIf (!config.variants.work) ({
      canonicalize = {
        match = "host !*.*,*";
        extraOptions = {
          CanonicalizeHostname = "yes";
          CanonicalDomains = "lan";
        };
      };
      lan = lib.hm.dag.entryAfter [ "canonicalize" ] {
        host = "*.lan";
        checkHostIP = false;
      };
      srcf = {
        hostname = "shell.srcf.net";
        user = "rc691";
      };
      storage = {
        hostname = "u334623.your-storagebox.de";
        user = "u334623";
        port = 23;
      };
    }))
    (lib.mkIf config.variants.work ({
      iapetus = {
        hostname = "iapetus.c.googlers.com";
        extraOptions.ControlPersist = "15h";
      };
      kronos = {
        hostname = "kronos.lon.corp.google.com";
        extraOptions.ControlPersist = "15h";
      };
    }))
  ];
}
