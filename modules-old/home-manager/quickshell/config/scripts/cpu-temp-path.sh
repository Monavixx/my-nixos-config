#!/usr/bin/env bash

for want in "Package id 0" Tdie Tctl; do
  for h in /sys/class/hwmon/hwmon*; do
    [ -r "$h/name" ] || continue

    IFS= read -r n < "$h/name" || continue

    case "$n" in
      k10temp|zenpower|coretemp|cpu_thermal|soc_thermal) ;;
      *) continue ;;
    esac

    for l in "$h"/temp*_label; do
      [ -r "$l" ] || continue

      IFS= read -r label < "$l" || continue
      [ "$label" = "$want" ] || continue

      input="${l%_label}_input"
      [ -r "$input" ] || continue

      printf '%s\n' "$input"
      exit 0
    done
  done
done

# Generic hwmon fallback
for h in /sys/class/hwmon/hwmon*; do
  [ -r "$h/name" ] || continue

  IFS= read -r n < "$h/name" || continue

  case "$n" in
    k10temp|zenpower|coretemp|cpu_thermal|soc_thermal)
      [ -r "$h/temp1_input" ] || continue
      printf '%s\n' "$h/temp1_input"
      exit 0
      ;;
  esac
done

# Thermal zone fallback
for z in /sys/class/thermal/thermal_zone*; do
  [ -r "$z/type" ] || continue

  IFS= read -r type < "$z/type" || continue
  [ "$type" = "x86_pkg_temp" ] || continue

  [ -r "$z/temp" ] || continue
  printf '%s\n' "$z/temp"
  exit 0
done

exit 1
