{ config, lib, pkgs, ... }: {

  options.custom.programs.git.useFullConfig = lib.mkOption {
    description = "Whether to use a minimal git config or not.";
    type = lib.types.bool;
    default = false;
  };

  config.programs.git = {
    enable = true;
    userName = "Reeto Chatterjee";
    userEmail = lib.mkDefault config.accounts.email.accounts.personal.address;
    aliases =
      let
        simpleLog = "log --oneline --decorate --no-merges";
        fzfLog = "!${pkgs.custom.fzf-git-log}/bin/fzf-git-log";
      in
      {
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

        lg = if config.custom.programs.git.useFullConfig then fzfLog else simpleLog;
        lgs = simpleLog;

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
