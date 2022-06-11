{ ... }:
final: prev:
let
  pkgs = final;
  lib = final.lib;
in
{
  custom = {
    shellUtil = ({ src
                 , deps ? [ ]
                 , extraEnv ? ""
                 , impure ? false
                 }:
      pkgs.writeShellScriptBin (lib.strings.removeSuffix ".sh" (builtins.baseNameOf src)) ''
        PATH=${lib.makeBinPath deps}${if impure then ":$PATH" else ""}
        ${extraEnv}

        ${builtins.readFile src}
      '');
  };
}
