{ den, inputs, ... }: {
  den.aspects.dsh = {
    includes = [ den.aspects.agenix ];

    homeManager =
      {
        pkgs,
        config,
        lib,
        user,
        ...
      }:
      let
        secretPath = lib.escapeShellArg config.age.secrets.${user.groqApiKeySecret}.path;

        dsh = pkgs.symlinkJoin {
          name = "dsh-wrapped";
          paths = [ inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.dsh ];

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
        age.secrets.${user.groqApiKeySecret}.file =
          ../../../../secrets/${user.groqApiKeySecret}.age;
        home.packages = [ dsh ];
      };
  };
}
