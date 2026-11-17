{ ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.6";
      enable_audio_bell = false;
    };
  };
  catppuccin.kitty.enable = true;
}
