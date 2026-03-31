#!/bin/sh
set -eu

REPO_RAW_BASE="https://raw.githubusercontent.com/TyrelCB/window-layout-util/main"
INSTALL_DIR="${HOME}/.local/bin"
TARGET="${INSTALL_DIR}/window-layout"
TMP_FILE="$(mktemp)"

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

mkdir -p "$INSTALL_DIR"
fetch "${REPO_RAW_BASE}/window-layout" "$TMP_FILE"
chmod +x "$TMP_FILE"
mv "$TMP_FILE" "$TARGET"

case ":${PATH}:" in
  *":${INSTALL_DIR}:"*)
    ;;
  *)
    echo "Installed to ${TARGET}"
    echo "Add ${INSTALL_DIR} to PATH if needed:"
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    exit 0
    ;;
esac

echo "Installed to ${TARGET}"
