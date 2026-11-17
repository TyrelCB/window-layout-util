#!/bin/sh
set -eu

REPO_RAW_BASE="https://raw.githubusercontent.com/TyrelCB/window-layout-util/main"
INSTALL_DIR="${HOME}/.local/bin"
TARGET="${INSTALL_DIR}/window-layout"
TMP_FILE="$(mktemp)"
BASHRC="${HOME}/.bashrc"

cleanup() {
  rm -f "$TMP_FILE"
}

trap cleanup EXIT INT TERM

fetch() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
    return 0
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
    return 0
  fi

  echo "Missing required downloader: curl or wget" >&2
  exit 1
}

write_wrapper() {
  name="$1"
  subcommand="$2"
  wrapper_path="${INSTALL_DIR}/${name}"

  cat > "$wrapper_path" <<EOF
#!/bin/sh
exec "${TARGET}" ${subcommand} "\$@"
EOF
  chmod +x "$wrapper_path"
}

ensure_bashrc_path() {
  [ -f "$BASHRC" ] || : > "$BASHRC"

  if grep -Fq '# >>> window-layout >>>' "$BASHRC"; then
    return 0
  fi

  cat >> "$BASHRC" <<'EOF'

# >>> window-layout >>>
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
# <<< window-layout <<<
EOF
}

mkdir -p "$INSTALL_DIR"
fetch "${REPO_RAW_BASE}/window-layout" "$TMP_FILE"
chmod +x "$TMP_FILE"
mv "$TMP_FILE" "$TARGET"
fetch "${REPO_RAW_BASE}/wl-collapse" "$TMP_FILE"
chmod +x "$TMP_FILE"
mv "$TMP_FILE" "${INSTALL_DIR}/wl-collapse"
write_wrapper "wl-save" "save"
write_wrapper "wl-restore" "restore"
write_wrapper "wl-list" "list"
write_wrapper "wl-path" "path"

case ":${PATH}:" in
  *":${INSTALL_DIR}:"*)
    ;;
  *)
    ensure_bashrc_path
    echo "Installed to ${TARGET}"
    echo "Created helper commands: wl-save, wl-restore, wl-list, wl-path, wl-collapse"
    echo "Added ${INSTALL_DIR} to ${BASHRC} for future bash sessions."
    echo "Run this now to use the commands immediately:"
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    exit 0
    ;;
esac

echo "Installed to ${TARGET}"
echo "Created helper commands: wl-save, wl-restore, wl-list, wl-path, wl-collapse"
