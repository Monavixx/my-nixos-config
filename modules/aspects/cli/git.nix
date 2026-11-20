{
  den.aspects.git.homeManager = { user, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = user.name;
          email = user.email;
        };
        alias = {
          s = "status";
          ac = "commit -am";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        fetch.prune = true;
        diff.algorithm = "histogram";
      };
    };
  };
}
