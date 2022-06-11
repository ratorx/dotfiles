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
                   # Whether to use writeShellScriptBin or writeShellScript
                 , bin ? true
                 }:
      let
        writer = if bin then pkgs.writeShellScriptBin else pkgs.writeShellScript;
      in
      writer (lib.strings.removeSuffix ".sh" (builtins.baseNameOf src)) ''
        PATH=${lib.makeBinPath deps}${if pure then "" else ":\"$PATH\""}
        ${extraEnv}

        ${builtins.readFile src}
      '');
  };
}
