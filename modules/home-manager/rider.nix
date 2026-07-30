{ pkgs, inputs, ... }:
let
  rider-plugins = inputs.nix-jetbrains-plugins.lib.pluginsForIde pkgs pkgs.jetbrains.rider [
    "com.github.copilot"
    "ca.nosuchcompany.rider.plugins.mediatr"
    "com.github.catppuccin.jetbrains"
    "Key Promoter X"
  ];
in
{
  home.packages = with pkgs; [
    (buildFHSEnv {
      name = "rider";
      targetPkgs =
        pkgs: with pkgs; [
          (pkgs.jetbrains.plugins.addPlugins jetbrains.rider (lib.attrValues rider-plugins))
          dotnet-sdk_10
          zlib
          glibc
          icu
          openssl
          catppuccin-cursors.mochaDark
          curl
        ];
      # Inject the variable INSIDE the FHS environment before launching Rider
      runScript = pkgs.writeScript "rider-wrapper" ''
        #!/bin/sh
        export DOTNET_ROOT="${pkgs.dotnet-sdk_10}"
        export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
        export NIXOS_OZONE_HL="1"
        export XCURSOR_THEME="catppuccin-${flavor}-dark-cursors"
        export XCURSOR_SIZE="24"
        export HYPRCURSOR_SIZE="24"
        export PATH="$HOME/.dotnet/tools:$PATH"
        exec rider "$@"
      '';
    })
  ];
  xdg.desktopEntries.rider = {
    name = "Rider";
    genericName = "IDE";
    exec = "rider %F";
    icon = "rider"; # or a path to an icon if the name doesn't resolve
    terminal = false;
    categories = [
      "Development"
      "IDE"
    ];
  };
}
