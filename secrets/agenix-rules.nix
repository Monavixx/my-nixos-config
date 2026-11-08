let
  # users
  monavixx-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIB6qWrskdM6wzmnCovjAuAir8FangNK/7tNLJQ1cD38";
  monavixx-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICJue+EJTtZGHF5dW/08TA8EeoQJe4aYesdLyo6cyoth";
  monavixx = [
    monavixx-laptop
    monavixx-desktop
  ];

  # hosts
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMfWgrfRt2A7Qw3Y+0+MMRze6kaTqGIb3MOxyWYjn+6S";
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQJl3E596eLP1uLdV6yycYNxhEiYRe7yDHju5G9DnPK";
  # run 'agenix --rekey' to update the .age file

in
{
  "dp0-gmail-app-password.age".publicKeys = monavixx ++ [
    laptop
    desktop
  ];
}
