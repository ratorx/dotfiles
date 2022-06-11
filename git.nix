{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Reeto Chatterjee";
    userEmail = lib.mkDefault config.accounts.email.accounts.personal.address;
    aliases = {
      a = "add";
      aa = "add .";
      ap = "add --patch";

      b = "branch";
      co = "checkout";

      cl = "clone";
      clr = "clone --recursive";

      c = "commit";
      cf = "commit --fixup";
      cm = "commit --message";
      amd = "commit --amend --no-edit";

      df = "diff";
      dfs = "diff --staged";

      lg = "!${pkgs.custom.shellUtil {
        src = ./bin/fzf-git-log.sh;
        deps = [pkgs.coreutils pkgs.gnugrep pkgs.findutils pkgs.gawk pkgs.fzf pkgs.git pkgs.less];
        bin = false;
      }}";
      lgs = "log --oneline --decorate --no-merges --max-count=20";

      pl = "pull";
      ps = "push";

      rb = "rebase";
      rbi = "rebase --interactive";
      rs = "reset";

      sts = "stash save";
      stp = "stash pop";
      std = "stash drop";
      stl = "stash list";

      s = "status --short";
      st = "status";

      root = "!pwd";
    };
    ignores = [ ".direnv/" ];
    extraConfig = {
      core = {
        autocrlf = "input";
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
      };
      apply.whitespace = "fix";
      rebase = {
        autostash = true;
        autoSquash = true;
      };
      pull.rebase = true;
      color.ui = true;
      color.diff = {
        meta = "blue";
        frag = "magenta bold";
        commit = "yellow bold";
      };
      diff.tool = "vimdiff";
      diff.guitool = "vscode";
      difftool.vscode.cmd = "code --wait --diff $LOCAL $REMOTE";
    } // {
      url = builtins.mapAttrs (name: value: { insteadOf = value; pushInsteadOf = value; }) {
        "git@github.com:" = "gh:";
        "git@github.com:ratorx/dotfiles" = "dots:";
        "git@bitbucket.org:" = "bb:";
      };
    };
  };
}
