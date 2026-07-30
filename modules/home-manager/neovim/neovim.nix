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
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      roslyn-nvim
      blink-cmp
      telescope-nvim
      plenary-nvim # required for telescope-nvim
      nvim-autopairs
    ];
    extraPackages = with pkgs; [
      ripgrep # required for telescope-nvim
      roslyn-ls
      nixd
      nixfmt
      lua-language-server
    ];
    sideloadInitLua = true;
  };
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/modules/home-manager/neovim/config";
}
