args@{ config, lib, pkgs, ... }:
let
  util = (import ./util.nix) args;
  # TODO: Remove exclusions once grammar/treesitter is fixed
  excludedTSPlugins = builtins.map (s: "tree-sitter-${s}-grammar") [ "bash" ];
  p = pkgs.vimPlugins;
in
{
  config = lib.mkMerge [
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        plugins = [
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
        ] ++
        util.makePlugins [
          p.lualine-nvim
          p.nvim-comment
          p.onedark-nvim
          p.suda-vim
          p.nvim-surround
          p.vim-vinegar
        ];
      };

      assertions = [
        {
          assertion = !config.programs.neovim.generatedConfigs ? viml;
          message = "generated vimscript config is non-empty";
        }
      ];
    }
    (lib.mkIf (!config.variants.minimal) {
      home.packages = [
        (pkgs.custom.builder.nvimbench config.programs.neovim.finalPackage)
      ];

      programs.neovim.plugins = util.makePlugins [
        (p.nvim-treesitter.withPlugins (_: builtins.filter (p: !(builtins.elem p.pname excludedTSPlugins)) pkgs.tree-sitter.allGrammars))
        # TODO: Explore alternatives (luasnip)
        p.vim-vsnip
        p.nvim-cmp
        p.cmp-buffer
        p.cmp-nvim-lsp
        p.cmp-path
        p.cmp-vsnip
      ];
    })
    (lib.mkIf (!config.variants.minimal && !config.variants.work) {
      programs.neovim.plugins = util.makePlugins [
        # TODO: null-ls has been archived. Replace (with none-ls)
        p.null-ls-nvim
        p.nvim-lspconfig
      ];
    })
  ];
}

