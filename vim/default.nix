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
    # TODO: Replace with deps provided by shell.nix
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
          runtime.lua = {
            source = ./lua;
            recursive = true;
          };
        }
      ] ++ util.makePlugins [
        # QoL
        p.lualine-nvim
        p.onedark-nvim
        p.suda-vim
        # Extra
        p.nvim-comment
        p.vim-surround # TODO: Explore Lua options
        p.vim-vinegar
        # TODO: Remove bash exclusion once grammar/treesitter is fixed
        (p.nvim-treesitter.withPlugins (_: builtins.filter (p: p.pname != "tree-sitter-bash-grammar") pkgs.tree-sitter.allGrammars))
        p.null-ls-nvim
        p.nvim-lspconfig
      ];
  };
  home.sessionVariables = {
    # Session variables are not reloaded automatically.
    # Using an absolute path would require a re-login to update Neovim config.
    EDITOR = "nvim";
  };
  home.packages = [
    (pkgs.custom.shellUtil {
      src = ../bin/nvimbench.sh;
      deps = [ config.programs.neovim.finalPackage pkgs.coreutils pkgs.less ];
    })
  ];

  assertions = [
    {
      assertion = !config.programs.neovim.generatedConfigs ? viml;
      message = "generated vimscript config is non-empty";
    }
  ];
}
