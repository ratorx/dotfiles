# TODO:
# Explore benefits of moving config into Lua modules
# Variants support:
#   * LSP
#   * CMP (consider making CMP part of default package)
# Figure out way to exclude directories from LSP (for work)
# Integrate tags into workflow
{
  config,
  lib,
  pkgs,
  ...
}:
let
  p = pkgs.vimPlugins;
in
{
  options.programs.neovim.plugins = lib.mkOption {
    type = lib.types.listOf (
      lib.types.either lib.types.package (lib.types.submodule { config.type = lib.mkDefault "lua"; })
    );
  };

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
            config = builtins.readFile ./init.lua;
            runtime.ftplugin = {
              source = ./ftplugin;
              recursive = true;
            };
            runtime."lua/variants.lua".text = # lua
              ''
                return {
                  minimal = ${lib.trivial.boolToString config.variants.minimal},
                  work = ${lib.trivial.boolToString config.variants.work},
                }
              '';
          }
          { plugin = p.suda-vim; }
          { plugin = p.vim-vinegar; }
          {
            plugin = p.lualine-nvim;
            config = builtins.readFile ./lualine.lua;
          }
          {
            plugin = p.nvim-comment;
            config = # lua
              ''
                require('nvim_comment').setup()
              '';
          }
          {
            plugin = p.onedark-nvim;
            config = # lua
              ''
                vim.opt.termguicolors = true
                require('onedark').load()
              '';
          }
          {
            plugin = p.nvim-surround;
            config = # lua
              ''
                require("nvim-surround").setup({ aliases = {} })
              '';
          }
        ];
      };
    }
    (lib.mkIf (!config.variants.minimal) {
      home.packages = [ (pkgs.custom.builder.nvimbench config.programs.neovim.finalPackage) ];

      programs.neovim.plugins = [
        {
          plugin = p.nvim-treesitter.withAllGrammars;
          config = # lua
            ''
              require('nvim-treesitter.configs').setup {
                highlight = { enable = true },
                indent = { enable = true },
              }
            '';
        }
        {
          plugin = pkgs.symlinkJoin {
            name = "cmp";
            # TODO: Replace with vim.snippet in 0.10+
            paths = [
              p.vim-vsnip
              p.nvim-cmp
              p.cmp-nvim-lsp
              p.cmp-path
            ];
          };
          config = builtins.readFile ./cmp.lua;
        }
        {
          plugin = p.nvim-lspconfig;
          config = builtins.readFile ./lsp.lua;
        }
      ];
    })
  ];
}
