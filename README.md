# My NixOS configuration

Personal NixOS configuration built with [den](https://github.com/vic/den) aspects.

## Setup on a new machine
 
Keys are **per machine**. Never copy `/var/lib/sbctl` between devices and never commit keys to this repo.
 
1. **Install and boot with plain systemd-boot.** Do not enable Lanzaboote during the first install.
2. **Create keys:**
```
sudo sbctl create-keys
```
3. **Enable the Lanzaboote aspect**, rebuild, and reboot with Secure Boot still **off**.
4. **Verify signing:**
```
sudo sbctl verify
```
   Lanzaboote's `.efi` files should be signed. Unsigned raw kernels under `/boot/EFI/nixos` are normal.
5. **Put the firmware into Setup Mode** Confirm:
```
sudo sbctl status
```
   It must show `Setup Mode: ✓ Enabled`.
6. **Enroll keys:**
```
sudo sbctl enroll-keys --microsoft --firmware-builtin --tpm-eventlog
```
   - `--microsoft` keeps the Microsoft keys (option ROMs, Windows dual boot).
   - `--firmware-builtin` keeps the vendor's own keys. This matters on laptops.
   - `--tpm-eventlog` is optional and mostly useful with a discrete GPU. Drop it if sbctl complains.
   - Do not use `--yes-this-might-brick-my-machine` unless you understand why sbctl refused.
7. **Reboot, enable Secure Boot in the firmware if it did not turn on by itself**, then check:
```
bootctl status
```
   It should report `Secure Boot: enabled (user)`.
8. **Rebuild once more and reboot** to confirm newly built generations are signed and boot.

