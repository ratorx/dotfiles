{ config, lib, pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "Reeto Chatterjee";
    userEmail = (
      lib.lists.findSingle
        (a: a.primary)
        null
        null
        (builtins.attrValues config.accounts.email.accounts)
    ).address;
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
      amd =
        "commit --amend --no-edit";

      df = "diff";
      dfs = "diff --staged";

      lg = lib.mkMerge [
        (lib.mkIf config.variants.minimal config.programs.git.aliases.lgs)
        (lib.mkIf (!config.variants.minimal) "!${pkgs.custom.fzf-git-log}/bin/fzf-git-log")
      ];
      lgs = "log --oneline --decorate --no-merges";

      pl = "pull";
      ps = "push";

      rb = "rebase";
      rbi = "rebase --interactive";
      rs = "reset";

      sts = "stash save";
      stp = "stash pop";
      std = "stash drop";
      stl =
        "stash list";

      s = "status --short";
      st = "status";

      lsp = "ls-files --cached --others --exclude-standard";

      root = "!pwd";
    };
    ignores = [ ".direnv/" ];
    extraConfig = {
      core = {
        autocrlf = "input";
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
      };
      init.defaultBranch = "master";
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
      url = builtins.mapAttrs
        (name: value: { insteadOf = value; pushInsteadOf = value; })
        { "git@github.com:" = "github:"; };
    };
  };
}
