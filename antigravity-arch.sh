#!/usr/bin/env bash
set -euo pipefail

# =============================
# GOOGLE ANTIGRAVITY INSTALLER
# Arch / Garuda / Manjaro
# Fully automated (dunst included)
# =============================

APT_BASE="https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev"
PKG_INDEX_URL="${APT_BASE}/dists/antigravity-debian/main/binary-amd64/Packages"

APP_DIR="/opt/antigravity"
BIN_LINK="/usr/local/bin/antigravity"
DESKTOP1="/usr/share/applications/antigravity.desktop"
DESKTOP2="/usr/share/applications/antigravity-url-handler.desktop"
ICON_PATH="/usr/share/pixmaps/antigravity.png"

# =============================
# UNINSTALL
# =============================
if [[ "${1-}" == "--uninstall" ]]; then
  echo "[*] Uninstalling Antigravity..."
  sudo rm -rf "$APP_DIR" "$BIN_LINK" "$DESKTOP1" "$DESKTOP2" "$ICON_PATH"
  rm -f ~/.config/autostart/dunst.desktop || true
  echo "[+] Removed."
  exit 0
fi

# =============================
# DEPENDENCIES (with dunst)
# =============================
echo "[*] Installing required dependencies (libnotify + dunst + chromium libs)..."
sudo pacman -Sy --needed --noconfirm \
  curl bsdtar libnotify dunst nss gtk3 libcups libxss || true

# =============================
# DUNST AUTOSTART FIX
# (solves the Antigravity freeze)
# =============================
echo "[*] Setting up notification daemon (dunst)..."

mkdir -p ~/.config/autostart

cat > ~/.config/autostart/dunst.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Dunst
Exec=dunst
StartupNotify=false
Terminal=false
EOF

# Start dunst instantly if not running
if ! pgrep -x dunst >/dev/null; then
  echo "[*] Starting dunst..."
  dunst &
  sleep 1
fi

echo "[+] Dunst enabled and running"

# =============================
# FETCH PACKAGE INDEX
# =============================
echo "[*] Fetching APT package index..."
workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT
cd "$workdir"

curl -fsSL "$PKG_INDEX_URL" -o Packages

# =============================
# PARSE LATEST VERSION
# =============================
echo "[*] Parsing latest Antigravity version..."

read -r DEBVER DEBFILENAME DEBSHA256 <<< "$(
  awk '
    BEGIN { pkg=""; ver=""; file=""; sha="" }
    /^Package: antigravity$/ { pkg="antigravity"; next }
    pkg=="antigravity" && /^Version:/ { ver=$2 }
    pkg=="antigravity" && /^Filename:/ { file=$2 }
    pkg=="antigravity" && /^SHA256:/ { sha=$2 }
    NF==0 && pkg=="antigravity" { print ver, file, sha; exit }
  ' Packages
)"

[[ -z "$DEBVER" ]] && { echo "[-] Failed to parse version."; exit 1; }

echo "[+] Latest version: $DEBVER"
echo "[+] File: $DEBFILENAME"

# =============================
# DOWNLOAD + VERIFY
# =============================
DEB_URL="${APT_BASE}/${DEBFILENAME}"
echo "[*] Downloading package..."
curl -fsSL "$DEB_URL" -o antigravity.deb

echo "[*] Verifying SHA256 checksum..."
echo "${DEBSHA256}  antigravity.deb" | sha256sum -c -

# =============================
# EXTRACT + INSTALL
# =============================
echo "[*] Extracting package..."
bsdtar -xf antigravity.deb
bsdtar -xf data.tar.xz

echo "[*] Installing to $APP_DIR..."
sudo rm -rf "$APP_DIR"
sudo mkdir -p "$APP_DIR"
sudo cp -r usr/share/antigravity/* "$APP_DIR/"

# =============================
# SANDBOX FIX
# =============================
if [[ -f "$APP_DIR/chrome-sandbox" ]]; then
  echo "[*] Fixing sandbox permissions..."
  sudo chown root:root "$APP_DIR/chrome-sandbox"
  sudo chmod 4755 "$APP_DIR/chrome-sandbox"
fi

# =============================
# BINARY LINK
# =============================
echo "[*] Creating launcher..."
sudo ln -sf "$APP_DIR/antigravity" "$BIN_LINK"

# =============================
# DESKTOP FILES
# =============================
echo "[*] Installing desktop entries..."

if [[ -f usr/share/applications/antigravity.desktop ]]; then
  sed 's|^Exec=.*|Exec=/usr/local/bin/antigravity %U|g' \
    usr/share/applications/antigravity.desktop | sudo tee "$DESKTOP1" >/dev/null
fi

if [[ -f usr/share/applications/antigravity-url-handler.desktop ]]; then
  sed 's|^Exec=.*|Exec=/usr/local/bin/antigravity %U|g' \
    usr/share/applications/antigravity-url-handler.desktop | sudo tee "$DESKTOP2" >/dev/null
fi

# =============================
# ICON
# =============================
[[ -f usr/share/pixmaps/antigravity.png ]] && sudo cp usr/share/pixmaps/antigravity.png "$ICON_PATH"

# =============================
# DONE
# =============================
echo
echo "[+] Antigravity $DEBVER installed successfully!"
echo "[+] Notification daemon fixed (dunst auto-start enabled)"
echo "[*] Run app using: antigravity"
echo "[*] Uninstall using: ./antigravity-installer.sh --uninstall"
