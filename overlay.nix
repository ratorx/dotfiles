{ ... }:
final: prev:
let
  pkgs = final;
  lib = final.lib;
in
{
  custom = {
    shellUtil = ({ src
                   # Dependencies to provide via makeBinPath
                 , deps ? [ ]
                   # Extra inline setup
                 , extraEnv ? ""
                   # Pure mode replaces PATH; otherwise it is only prepended
                 , pure ? true
                 }:
      pkgs.writeShellScriptBin (lib.strings.removeSuffix ".sh" (builtins.baseNameOf src)) ''
        PATH=${lib.makeBinPath deps}${if pure then "" else ":\"$PATH\""}
        ${extraEnv}

        ${builtins.readFile src}
      '');
  };
}
