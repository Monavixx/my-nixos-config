{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "monavixx";
        email = "dperelygin0@gmail.com";
      };
      alias = {
        s = "status";
        ac = "commit -am";
      };
    };
  };
}
