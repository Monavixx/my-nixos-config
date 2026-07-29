{
  config,
  pkgs,
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
      roslyn-nvim
      blink-cmp
    ];
    extraPackages = with pkgs; [
      roslyn-ls
      nixd
      nixfmt-rfc-style
    ];
  };
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink /home/monavixx/nixos/modules/home-manager/neovim/config/init.lua;
}
