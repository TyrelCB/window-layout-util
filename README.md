# `window-layout`

Small X11 utility for saving and restoring window positions, sizes, workspaces, and maximize state.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/TyrelCB/window-layout-util/main/install.sh | sh
```

The installer:

- installs `window-layout` into `~/.local/bin`
- creates helper commands `wl-save`, `wl-restore`, `wl-list`, `wl-path`, and `wl-collapse`
- adds `~/.local/bin` to `~/.bashrc` if needed

## Requirements

- `bash`
- `jq`
- `xdotool`
- `xprop`
- `base64`
- X11 session

## Usage

```bash
window-layout save workday
window-layout restore workday
window-layout restore --dry-run workday
window-layout list
window-layout path workday

wl-save workday
wl-restore workday
wl-list
wl-path workday
wl-collapse
```

Saved layouts default to:

```text
~/.local/state/window-layouts/
```

## Notes
- Run `wl-collapse` after switching back with a KVM to gather windows onto the current workspace. Windows visible on every workspace stay pinned.

- Matching prefers the original X11 window id, then falls back to class and title.
- Layouts include windows across workspaces and restore them to their saved workspace when possible.
- Restore works best for floating/manual windows.
- If Pop Shell auto-tiling is active, it can override manual geometry. Temporarily toggle tiling off with `Super+Y` before restoring if needed.
