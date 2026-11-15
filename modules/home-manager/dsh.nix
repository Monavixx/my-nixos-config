{
  pkgs,
  config,
  lib,
  ...
}:
let
  secretPath = lib.escapeShellArg config.age.secrets.groq.path;

  dsh = pkgs.symlinkJoin {
    name = "dsh-wrapped";
    paths = [ pkgs.llm-agents.dsh ];

    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram "$out/bin/dsh" \
        --run "if [ ! -r ${secretPath} ]; then
          echo 'dsh: Groq API key file is missing or unreadable' >&2
          exit 1
        fi
        GROQ_API_KEY=\$(${pkgs.coreutils}/bin/cat -- ${secretPath}) || exit
        export GROQ_API_KEY"
    '';
  };
in
{
  home.packages = [
    dsh
  ];
}
