# `window-layout`

Small X11 utility for saving and restoring window positions, sizes, workspaces, and maximize state.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/TyrelCB/window-layout-util/main/install.sh | sh
```

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
```

Saved layouts default to:

```text
~/.local/state/window-layouts/
```

## Notes

- Matching prefers the original X11 window id, then falls back to class and title.
- Restore works best for floating/manual windows.
- If Pop Shell auto-tiling is active, it can override manual geometry. Temporarily toggle tiling off with `Super+Y` before restoring if needed.
