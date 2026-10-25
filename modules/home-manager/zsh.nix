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
    initContent = ''
      zmodload zsh/complist
      zstyle ':completion:*' menu select

      ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(tab-suggest-then-complete)

      typeset -g _tab_prefix=""
      typeset -gi _tab_accepted=0

      tab-suggest-then-complete() {
        if [[ $LASTWIDGET != tab-suggest-then-complete ]]; then
          _tab_accepted=0
        fi

        if (( _tab_accepted )); then
          _tab_accepted=0
          BUFFER=$_tab_prefix
          CURSOR=$#BUFFER
          zle menu-complete

        elif [[ -n $POSTDISPLAY && $CURSOR -eq $#BUFFER ]]; then
          _tab_prefix=$BUFFER
          zle autosuggest-accept
          _tab_accepted=1

        else
          zle menu-complete
        fi
      }

      zle -N tab-suggest-then-complete
      bindkey '^I' tab-suggest-then-complete

      bindkey -M menuselect '^I' menu-complete
      bindkey -M menuselect '^[[Z' reverse-menu-complete
      bindkey '^[[Z' reverse-menu-complete
    '';
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
