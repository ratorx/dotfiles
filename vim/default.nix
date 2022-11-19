{ config, pkgs, ... }:
{
  programs.neovim =
    let
      cfg = (name:
        let
          path = ./. + "/${name}.vim";
        in
        if builtins.pathExists path then builtins.readFile path else ""
      );
    in
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins =
        let
          p = pkgs.vimPlugins;
          withCfg = (pkg: {
            plugin = pkg;
            config = cfg (pkgs.lib.strings.removeSuffix ".vim" pkg.pname);
          });
        in
        # TODO: Replace with neovim Lua plugins where possible
        (builtins.map withCfg [
          # QoL
          p.is-vim
          p.lightline-vim
          p.onedark-vim
          p.suda-vim
          p.vim-polyglot
          # Enhancements
          p.vim-operator-user
          p.vim-operator-replace
          p.vim-repeat
          # Extra
          p.vim-commentary
          p.vim-surround
          p.vim-vinegar
        ]) ++ [
          # Dummy plugin to load Lua config
          {
            plugin = pkgs.emptyFile;
            type = "lua";
            config = builtins.readFile ./init.lua;
          }
        ];
    };
  home.sessionVariables = {
    # Don't use full path since configured neovim might have a different package to nixpkgs neovim.
    EDITOR = "nvim";
  };
}
