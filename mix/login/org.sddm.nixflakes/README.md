# Flying Snowflakes — SDDM theme

NixOS logomarks fly out of the dark like the Windows 3.1 "Flying Windows"
screensaver (fixed at warp speed 4, 64 flakes), behind a smoked-glass login panel.

* Login card in the centre: clock, user, password, Caps Lock warning, shake on failure,
  warp burst on success.
* Bottom left: session picker. Bottom right: Suspend, Hibernate, Restart, Shut down
  (each shown only when SDDM reports the action is available).
* Extra monitors show only the flakes.

Requires the **Qt 6** SDDM greeter (SDDM 0.20+, Qt 6.5+ for the glass blur).

## NixOS

```nix
{ pkgs, ... }:
let
  flying-nixflakes = pkgs.callPackage ./flying-nixflakes { };
in {
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;      # Qt 6 greeter
    theme = "flying-nixflakes";
  };
  environment.systemPackages = [ flying-nixflakes ];

  # Fonts used by the theme (optional; falls back to the default sans/mono)
  fonts.packages = [
    (pkgs.google-fonts.override { fonts = [ "ChakraPetch" "IBMPlexMono" ]; })
  ];
}
```

## Other distros

Copy this folder to `/usr/share/sddm/themes/flying-nixflakes` and set
`Current=flying-nixflakes` under `[Theme]` in `/etc/sddm.conf.d/theme.conf`.

## Preview without logging out

```sh
sddm-greeter-qt6 --test-mode --theme /path/to/flying-nixflakes
```

In test mode the power buttons may be hidden and logging in does nothing.

## Settings (`theme.conf`)

| Key           | Default           | Notes                                         |
|---------------|-------------------|-----------------------------------------------|
| `blur`        | `true`            | Backdrop blur behind the glass panels         |
| `displayFont` | `Chakra Petch`    | Clock, labels, buttons                        |
| `monoFont`    | `IBM Plex Mono`   | Fields, status, hostname                      |
| `timeFormat`  | *(locale)*        | Qt format, e.g. `HH:mm` or `h:mm AP`          |
| `dateFormat`  | `dddd, MMMM d`    | Qt date format                                |

Put overrides in `theme.conf.user` next to `theme.conf`.
