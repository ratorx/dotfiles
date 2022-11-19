{ pkgs, ... }:
let
  print = s: builtins.trace s s;
  readFileOptional = path: if builtins.pathExists path then builtins.readFile path else "";
  stripSuffixes = name: pkgs.lib.foldr pkgs.lib.strings.removeSuffix name [ ".vim" ".nvim" ];
  stripPrefixes = name: pkgs.lib.foldr pkgs.lib.strings.removePrefix name [ "vim-" "nvim-" ];
  sanitisePluginName = name: stripSuffixes (stripPrefixes name);
  makePlugin = plugin: {
    inherit plugin;
    type = "lua";
    config = readFileOptional (./. + "/${sanitisePluginName plugin.pname}.lua");
  };
in
{
  makePlugins = plugins: (builtins.map makePlugin plugins);
}

