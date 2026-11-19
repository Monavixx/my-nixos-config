{
  den.aspects.bash = {
    homeManager = {
      programs.bash = {
        enable = true;
        profileExtra = ''
          if uwsm check may-start; then
              exec uwsm start hyprland.desktop
          fi
        '';
      };
    };
  };
}
