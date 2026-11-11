{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      OfferToSaveLoginsDefault = false;
    };
    profiles = {
      "default" = {
        id = 0;
        isDefault = true;

        settings = {
          "browser.aboutConfig.showWarning" = false;

          # telemetry off
          "toolkit.telemetry.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;

          "extensions.autoDisableScopes" = 0;

          "signon.rememberSignons" = false;

          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_pbm" = true;

          #DNS
          "network.trr.mode" = 3;
          "network.trr.uri" = "https://dns.quad9.net/dns-query";

        };
        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            privacy-badger
            ublock-origin
            bitwarden
            darkreader
          ];
        };
      };
    };
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
