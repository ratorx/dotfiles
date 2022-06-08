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

      lg = "!${pkgs.writeShellScript "fzf-git-log.sh" (
        let path = lib.makeBinPath (builtins.attrValues {
          inherit (pkgs) bash coreutils delta gnugrep findutils fzf git;
        });
        in
        ''
          PATH="${path}"
          # Git Commit Browser (w/ previews)
          _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\\{7\\}' | head -1"
          _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show % | delta'"

          glog() {
            git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" |
              fzf --bind shift-up:preview-up,shift-down:preview-down --no-sort --reverse --tiebreak=index --no-multi --ansi --exit-0 --preview "$_viewGitLogLine" | 
              grep -o '[a-f0-9]\{7\}' | 
              tr -d '\n'

            # Send through exit code
            e=$? && [ $e -eq 130 ] || [ $e -eq 1 ] || return $e
          }

          glog "$@"
        ''
      )}";
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
        meta = "yellow";
        frag = "magenta bold";
        commit = "yellow bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
      };
    } // {
      url = builtins.mapAttrs (name: value: { insteadOf = value; pushInsteadOf = value; }) {
        "git@github.com:" = "gh:";
        "git@github.com:ratorx/dotfiles" = "dots:";
        "git@bitbucket.org:" = "bb:";
      };
    };
    delta.enable = true;
    delta.options = { };
  };
}
