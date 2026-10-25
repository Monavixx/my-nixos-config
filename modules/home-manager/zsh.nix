{ config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/.zsh_history";
    };
    profileExtra = ''
      if uwsm check may-start; then
          exec uwsm start hyprland.desktop
      fi
    '';
    defaultKeymap = "viins";
    shellAliases = {
      rm = "rm -i";
    };
  };
  catppuccin.zsh-syntax-highlighting.enable = true;
}
