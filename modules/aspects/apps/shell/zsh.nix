{ den, ... }:
{
  den.aspects.zsh = {
    includes = [ den.aspects.fzf ];
    nixos = { pkgs, ... }: {
      programs.zsh.enable = true;
      environment = {
        shells = [ pkgs.zsh ];
      };
    };
    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          plugins = [
            {
              name = "fzf-tab";
              src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
            }
          ];
          history = {
            size = 10000;
            ignoreAllDups = true;
            path = "${config.home.homeDirectory}/.zsh_history";
          };
          initContent = lib.mkAfter ''
            zstyle ':completion:*' menu no
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*:git-checkout:*' sort false
            zstyle ':completion:*:descriptions' format '[%d]'
            zstyle ':fzf-tab:*' switch-group '<' '>'
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath'

            if [[ -o interactive ]]; then
              fastfetch
            fi
          '';
          defaultKeymap = "viins";
        };
        catppuccin.zsh-syntax-highlighting.enable = true;
      };
  };
}
