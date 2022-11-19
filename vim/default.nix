{ config, pkgs, ... }:
{
  programs.neovim =
    let
      cfg = (name:
        let
          path = ./. + "/${name}.lua";
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
            type = "lua";
            config = cfg (pkgs.lib.strings.removeSuffix ".vim" pkg.pname);
          });
        in [
          # Dummy plugin to load user config first.
          {
            plugin = pkgs.emptyFile;
            type = "lua";
            config = builtins.readFile ./init.lua;
          }
        ] ++
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
        ]);
    };
  home.sessionVariables = {
    # Don't use full path since configured neovim might have a different package to nixpkgs neovim.
    EDITOR = "nvim";
  };

  assertions = [
    {
      assertion = config.programs.neovim.generatedConfigViml == "";
      message = "generated vimscript config is non-empty";
    }
  ];
}
