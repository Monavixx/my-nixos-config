{
  config,
  pkgs,
  inputs,
  ...
}:
let
  boilersharp = pkgs.vimUtils.buildVimPlugin {
    pname = "boilersharp.nvim";
    version = "unstable";
    src = inputs.boilersharp;
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    waylandSupport = true;
    plugins = with pkgs.vimPlugins; [
      copilot-lua
      copilot-cmp
      copilot-lsp
      nui-nvim
      nvim-web-devicons
      neo-tree-nvim
      boilersharp
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
