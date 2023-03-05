args@{ config, pkgs, ... }:
let
  util = (import ./util.nix) args;
  # TODO: Remove exclusions once grammar/treesitter is fixed
  excludedTSPlugins = builtins.map (s: "tree-sitter-${s}-grammar") [ "bash" "fish" "markdown" ];
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
        (p.nvim-treesitter.withPlugins (_: builtins.filter (p: !(builtins.elem p.pname excludedTSPlugins)) pkgs.tree-sitter.allGrammars))
        p.null-ls-nvim
        p.nvim-lspconfig
        # Completion
        p.vim-vsnip
        p.nvim-cmp
        p.cmp-buffer
        p.cmp-nvim-lsp
        p.cmp-path
        p.cmp-vsnip
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
