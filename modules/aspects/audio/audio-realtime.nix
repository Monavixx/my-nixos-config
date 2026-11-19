{
  den.aspects.audio-realtime = {
    nixos = {
      security.pam.loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "95";
        }
        {
          domain = "@audio";
          item = "nice";
          type = "-";
          value = "-19";
        }
      ];
    };
  };
}
