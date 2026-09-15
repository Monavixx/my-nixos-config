{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    package = (
      pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          #uosc
          sponsorblock
          quality-menu
        ];

        mpv-unwrapped = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
          ffmpeg = pkgs.ffmpeg-full;
        };
      }
    );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
    };
  };
  programs.yt-dlp = {
    enable = true;
  };
}
