{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      # ls -> exa
      ls = "exa -xF";
      la = "ls -a";
      lh = "ls -d .*";
      lt = "ls -T --group-directories-first";
      ll = "exa -lF";
      lla = "ll -a";
      # safer fs
      mv = "mv -v";
      rm = "rm -Iv";
      cp = "cp -v";
      df = "df -hl";
      du = "du -h";
      # Network
      pubip = "string trim -c '\"' $(${pkgs.dnsutils}/bin/dig +short txt ch whoami.cloudflare @1.1.1.1)";
      # System
      scu = "systemctl --user";
    };
    interactiveShellInit = (builtins.readFile ./interactive.fish);
  };

  programs.bash = {
    enable = true;
    # This shims into fish at the very beginning of bashrc (if interactive)
    bashrcExtra = ''
      [[ $- == *i* ]] && exec "${pkgs.fish}/bin/fish"
    '';
  };
}
