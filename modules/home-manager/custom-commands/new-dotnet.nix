{ pkgs, ... }:
let
  flakeFile = ./resource-flake.nix;

  new-dotnet = pkgs.writeShellScriptBin "new-dotnet" ''
    #!/usr/bin/env bash

    set -euo pipefail

    if [[ $# -ne 1 ]]; then
        echo "Usage: new-dotnet <name>"
        exit 1
    fi

    name="$1"

    if [[ -e "$name" ]]; then
        echo "Error: '$name' already exists."
        exit 1
    fi

    echo "Creating .NET solution '$name'"
    mkdir "$name"
    cp "${flakeFile}" "$name/flake.nix"

    echo 'use flake' > "$name/.envrc"

    cd "$name"
    cat > run.sh <<EOF
    #!/usr/bin/env bash
    set -euo pipefail
    dotnet run --project "$name/''${name}.csproj"
    EOF
    chmod +x run.sh

    nix develop . --command bash <<EOF
    dotnet new sln \
        --name "$name" \
        --format sln \
        --output .

    dotnet new gitignore \
        --output .

    EOF

    cat >> .gitignore <<'GITIGNORE'
    .direnv/
    .nuget-packages/
    .env
    GITIGNORE

    git init
    git add .

    echo
    echo "Project '$name' created successfully."
  '';
in
{
  home.packages = [
    new-dotnet
  ];
}
