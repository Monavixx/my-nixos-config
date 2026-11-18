{ inputs, ... }: {
  imports = [ inputs.den.flakeModule ];
  den.hosts.x86_64-linux.laptop.users.monavixx = { };
}
