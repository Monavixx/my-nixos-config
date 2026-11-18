{ den, ... }: {
  den.aspects.battery.includes = with den.aspects; [
    auto-cpufreq
    upower
  ];
}
