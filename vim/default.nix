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
        (builtins.map withCfg [
          # QoL
          p.lightline-vim # TODO: Replace with lualine/custom Lua function
          p.onedark-vim # TODO: Explore lighter weight options
          p.suda-vim
          # Enhancements
          # TODO: Drop these plugins
          p.vim-operator-user
          p.vim-operator-replace
          p.vim-repeat
          # Extra
          p.vim-commentary # TODO: Replace with nvim-comment
          p.vim-surround # TODO: Explore Lua options
          p.vim-vinegar
          (p.nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        ]);
    };
  home.sessionVariables = {
    # Don't use full path since configured neovim might have a different package to nixpkgs neovim.
    EDITOR = "nvim";
  };

  assertions = [
    {
      assertion = !config.programs.neovim.generatedConfigs ? viml;
      message = "generated vimscript config is non-empty";
    }
  ];
}
