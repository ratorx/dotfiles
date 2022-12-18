args@{ config, pkgs, ... }:
let
  util = (import ./util.nix) args;
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins =
      let
        p = pkgs.vimPlugins;
      in
      [
        # Dummy plugin to load user config first.
        {
          plugin = pkgs.emptyFile;
          type = "lua";
          config = builtins.readFile ./init.lua;
        }
        # LSPs configured in Nix
        {
          plugin = p.nvim-lspconfig;
          type = "lua";
          config = (builtins.readFile ./lspconfig.lua) + util.generateLspConfig {};
        }
      ] ++ util.makePlugins [
        # QoL
        p.lightline-vim # TODO: Replace with lualine/custom Lua function
        p.onedark-vim # TODO: Explore lighter weight options
        p.suda-vim
        # Extra
        p.vim-commentary # TODO: Replace with nvim-comment
        p.vim-surround # TODO: Explore Lua options
        p.vim-vinegar
        (p.nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      ];
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
