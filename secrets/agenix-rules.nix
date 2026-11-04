let
  # users
  monavixx-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIB6qWrskdM6wzmnCovjAuAir8FangNK/7tNLJQ1cD38";
  monavixx = [ monavixx-laptop ];

  # hosts
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMfWgrfRt2A7Qw3Y+0+MMRze6kaTqGIb3MOxyWYjn+6S";
  # run 'agenix --rekey' to update the .age file

in
{
  "dp0-gmail-app-password.age".publicKeys = monavixx ++ [ laptop ];
}
