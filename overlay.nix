{ ... }:
final: prev:
let
  pkgs = final;
  lib = final.lib;
in
{
  custom = {
    simpleShellScriptBin = (src: deps: pkgs.writeShellScriptBin (lib.strings.removeSuffix ".sh" (builtins.baseNameOf src)) ''
      PATH=${lib.makeBinPath deps}

      ${builtins.readFile src}
    '');
    impureShellScriptBin = (src: deps: pkgs.writeShellScriptBin (lib.strings.removeSuffix ".sh" (builtins.baseNameOf src)) ''
      PATH=${lib.makeBinPath deps}:"$PATH"

      ${builtins.readFile src}
    '');
  };
}
