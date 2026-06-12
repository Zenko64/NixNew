# Single Compositor Per Host — Plan

**Goal:** Pick exactly one compositor per host via a manual `enable` flip, with each
compositor's config in the same place. Uses per-compositor `enable` + a central
mutual-exclusion **assertion** — the NixOS-documented idiom for `enable`-style
backends (the type system can't relate independent booleans, so the "only one"
rule is an assertion).

> ⚠️ **Current state breaks evaluation:** `modules/desktop/compositors/compositors.nix`
> is **empty (0 bytes)**; `import-tree ./modules` imports it → the flake fails to
> parse. **Step 1 fills it with the assertion and fixes that.**

## Model

- **`local.desktop.compositors.<name>`** — one submodule per compositor holding
  **both** its `enable` flip **and** its config (`shell`, …). Selection lives
  inside the config — no separate selector structure.
- **Assertion** (central, in `compositors.nix`) — `count enabled ≤ 1`. Zero
  enabled = headless; no sentinel needed.
- **`local.desktop.greeter`** — unchanged, independent axis.

```nix
# host UX — flip enable, configure in the same block
local.desktop.compositors.hyprland = {
  enable = true;
  shell  = "ashell";   # null = bare Hyprland
};
```

**Why this shape:** it gives the manual `enable` UX and keeps each compositor's
selection + config in one structure. Mutual exclusion is a runtime assertion
because independent `enable` booleans have no type-level relationship — this is the
pattern nixpkgs uses for `enable`-style backends (bootloaders). Verified: the
`count` of enabled compositors is 0/1/2 as expected, so `≤ 1` passes for
none/one and fails for two.

## Current → target layout

```
modules/desktop/environments/{gnome,kde,hyprland,niri}/   ← now
modules/desktop/compositors/compositors.nix  (empty, breaks parse)

modules/desktop/compositors/compositors.nix   the assertion   ← target
modules/desktop/compositors/hyprland/…        moved + renamed
modules/desktop/compositors/niri/…            moved + renamed
```

> Note: hyprland/niri already declare `{ enable; shell; }` today — so this is a
> namespace rename, not an option restructure.

---

## Steps

### 1. Fill `compositors/compositors.nix` — the assertion (fixes parse)

```nix
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      namespace,
      ...
    }:
    {
      config.assertions = [
        {
          assertion =
            lib.count (c: c.enable or false)
              (lib.attrValues config.${namespace}.desktop.compositors) <= 1;
          message = "local.desktop.compositors: enable at most one compositor.";
        }
      ];
    };
}
```

The assertion reads every `compositors.<name>` and counts the enabled ones. (Full
eval needs the compositor modules from Steps 2–4 to declare `compositors.*`; until
then the flake won't fully evaluate — the migration is atomic.)

### 2. Move the compositors, delete the DEs

```bash
git mv modules/desktop/environments/hyprland modules/desktop/compositors/hyprland
git mv modules/desktop/environments/niri     modules/desktop/compositors/niri
git rm -r modules/desktop/environments/gnome modules/desktop/environments/kde
```

GNOME/KDE are recoverable from git (`2a6768f`, `38167bc`) — full DEs needing a
graphical DM (the KDE black-screen source), out of scope until a graphical greeter
exists.

### 3. `compositors/hyprland/hyprland.nix` — rename namespace

Replace the option path `desktop.environments.hyprland` → `desktop.compositors.hyprland`
in both blocks (the `enable`/`shell` options keep their shape):

- nixos block: the `options.… = { enable; shell; }` declaration and the
  `config = lib.mkIf …hyprland.enable` gate.
- homeManager block: the `shell` option re-declaration and the
  `config = lib.mkIf osConfig.…hyprland.enable` gate.

Optional idiom tidy: swap the verbose
`enable = lib.mkOption { type = lib.types.bool; default = false; … }` for
`enable = lib.mkEnableOption "Hyprland";` (matches the gnome/kde style).

### 4. `compositors/niri/niri.nix` — rename namespace

Same `desktop.environments.niri` → `desktop.compositors.niri` rename in both blocks.

### 5. `compositors/hyprland/shells/ashell.nix` — rename namespace

In the `mkIf` gate, `desktop.environments.hyprland` → `desktop.compositors.hyprland`
(both the `.enable` and `.shell` reads).

### 6. Update the host

`hosts/x86_64-desktops/zenko/default.nix` — replace the four `environments.*` lines:

```nix
  local.desktop = {
    theme = "catppuccin-mocha";
    compositors.hyprland = {
      enable = true;
      shell = "ashell";
    };
    greeter = "tuigreet";
  };
```

Niri stays available, just not enabled. `tenko` enables none → headless, which is
valid.

### 7. Verify

```bash
# host resolves to exactly Hyprland enabled
nix eval .#nixosConfigurations.zenko.config.local.desktop.compositors.hyprland.enable   # → true

# no leftover namespace
grep -rn "desktop\.environments" --include=*.nix .                                       # → (empty)

# the guard fires: temporarily also set compositors.niri.enable = true on zenko, then
nixos-rebuild build --flake .#zenko        # → fails: "enable at most one compositor."  (revert after)

# full evaluation (no build)
nix eval .#nixosConfigurations.zenko.config.system.build.toplevel.drvPath                # → /nix/store/….drv
```

---

**Touch count:** fill 1 (the broken file), move 2 dirs, delete 2, rename-edit 3, edit 1 host.

**Out of scope (separate follow-ups):**
1. Remove the `mkForce { }` band-aids on mako/hypridle — safe now that only one
   compositor is ever the session.
2. Scope `uwsm.enable` / the ozone env in `modules/desktop/default.nix` under the
   compositors that need them.
3. Add SDDM/GDM greeter modules and re-add a full DE if ever wanted (re-check the
   KDE black-screen root cause via the journal first — don't assume).

## References

- NixOS Manual — *Option Declarations* (per-backend `enable` cannot be
  type-mutually-exclusive; use assertions).
- nixpkgs `nixos/modules/misc/assertions.nix` — the assertion mechanism used here.
