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
          runtime.ftplugin = {
            source = ./ftplugin;
            recursive = true;
          };
        }
        # LSPs configured in Nix
        {
          plugin = p.nvim-lspconfig;
          type = "lua";
          config = (builtins.readFile ./lspconfig.lua) + util.generateLspConfig {
            rnix = pkgs.rnix-lsp + /bin/rnix-lsp;
            sumneko_lua = pkgs.sumneko-lua-language-server + /bin/lua-language-server;
          };
        }
      ] ++ util.makePlugins [
        # QoL
        p.lualine-nvim
        p.onedark-nvim
        p.suda-vim
        # Extra
        p.vim-commentary # TODO: Replace with nvim-comment
        p.vim-surround # TODO: Explore Lua options
        p.vim-vinegar
        # TODO: Remove bash exclusion once grammar/treesitter is fixed
        (p.nvim-treesitter.withPlugins (_: builtins.filter (p: p.pname != "tree-sitter-bash-grammar") pkgs.tree-sitter.allGrammars))
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
