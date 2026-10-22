{
  pkgs,
  inputs,
  flakeRoot,
  hostname,
  ...
}:
let
  boilersharp = pkgs.vimUtils.buildVimPlugin {
    pname = "boilersharp.nvim";
    version = "unstable";
    src = inputs.boilersharp;
  };
  telescope-luasnip = pkgs.vimUtils.buildVimPlugin {
    pname = "telescope-luasnip.nvim";
    version = "unstable";
    src = inputs.telescope-luasnip;
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
      luasnip
      telescope-luasnip
      friendly-snippets
      copilot-lua
      # blink-cmp-copilot
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
      telescope-ui-select-nvim
      plenary-nvim # required for telescope-nvim
      nvim-autopairs
    ];
    extraPackages = with pkgs; [
      vtsls
      ripgrep # required for telescope-nvim
      nixd
      nixfmt
      lua-language-server
      vscode-langservers-extracted # HTML, CSS, JSON and ESLint language servers
      tailwindcss-language-server # Tailwind CSS class completion and diagnostics
      emmet-language-server # HTML/JSX abbreviation expansion
      bash-language-server
      shellcheck
    ];
    extraLuaPackages = ps: [
      ps.jsregexp
    ];
    sideloadInitLua = true;
  };
  # xdg.configFile."nvim".source =
  #   config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/neovim/config";
  xdg.configFile = {
    "nvim" = {
      source = ./config;
      recursive = true;
    };

    "nvim/lua/flake-root.lua".text = ''
      vim.g.flake_root = "${flakeRoot}"
      vim.g.nix_hostname = "${hostname}"
    '';
  };
}
