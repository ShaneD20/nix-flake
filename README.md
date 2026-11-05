# NixOS Workstation Config

## Make sure you have Nix installed

If you're on a non-NixOS system, you can run this command to install nix

```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
```
## Make sure you have git installed

```bash
$ nix-shell -p git
$ nix shell nixpkgs#get
```

## Installation
Close the wizard and use this repo

### NixOS Build
```bash
$ cd nix-flake
$ nix --experimental-features 'nix-command flakes' develop
```

```bash
# To start a new installation on an existing host
$ make nixos.run-disko host=<hostname>
$ make nixos.install host=<hostname>

# To build and apply new changes
$ make nixos.build host=<hostname>
$ make nixos.switch host=<hostname>
```

where `<hostname>` is a host found in the `./hosts` diretory.

### Wallpaper
```bash
kpackagetool6 --type Plasma/Wallpaper --install ./org.wall.snowflakes
```

## Inventory

### Gaming Rigs
| Hostname      | Model                              | Type    |
|---------------|------------------------------------|---------|
| tower   |  AMD Ryzen 7 5800X + AMD ATI Radeon RX 9060 XT | Gaming Rig |