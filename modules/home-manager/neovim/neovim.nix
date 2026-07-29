{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    waylandSupport = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      # ...your other plugins (treesitter, cmp/blink, etc.)
      roslyn-nvim
    ];

    extraPackages = with pkgs; [
      # C#
      roslyn-ls
      # Nix
      nixd
      # optional but recommended alongside nixd
      nixfmt-rfc-style
    ];
  };
  xdg.configFile."nvim/init.lua".source = 
  	config.lib.file.mkOutOfStoreSymlink /home/monavixx/nixos/modules/home-manager/neovim/config/init.lua;
}
