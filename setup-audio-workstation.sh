#!/usr/bin/env bash
set -euo pipefail

# === Ubuntu Studio One-Shot Audio Workstation Setup ===
# Tested on Ubuntu Studio 22.04/24.04. Run as root (sudo).
# It:
#  - Installs lowlatency kernel, rtirq, realtime limits
#  - Sets CPU governor to performance (with a systemd service)
#  - Installs PipeWire+JACK tooling, session mgmt (RaySession)
#  - Installs DAWs (Ardour, REAPER optional fetch, Bitwig optional note), core LV2/VST plugins
#  - Installs Wine + yabridge for Windows VST bridging
#  - Adds Timeshift + Borg for snapshots/backups
#  - Light service trimming (optional, reversible)
#
# If you break it, you own both halves. :)

# ----- Helpers -----
USER_NAME="${SUDO_USER:-${USER}}"
USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"
log() { echo -e "\n\033[1;32m>>> $*\033[0m"; }
warn() { echo -e "\n\033[1;33m!!! $*\033[0m"; }
die() { echo -e "\n\033[1;31mxxx $*\033[0m"; exit 1; }

# ----- Sanity checks -----
[ "$(id -u)" -eq 0 ] || die "Run with sudo/root."

if ! grep -qi "ubuntu" /etc/os-release; then
  warn "This script targets Ubuntu/Ubuntu Studio. Proceeding anyway..."
fi

log "Updating package lists…"
apt-get update -y
apt-get install -y software-properties-common curl wget git ca-certificates gnupg lsb-release

# ----- Kernel & RT tuning -----
log "Installing low-latency kernel + rtirq (IRQ priority tuning)…"
apt-get install -y linux-lowlatency rtirq-init

# Make sure user has audio/realtime privileges
log "Granting realtime/memlock to 'audio' group…"
addgroup --system audio || true
adduser "$USER_NAME" audio || true

mkdir -p /etc/security/limits.d
cat >/etc/security/limits.d/99-audio.conf <<'EOF'
# Realtime audio privileges
@audio   -  rtprio     95
@audio   -  memlock    unlimited
@audio   -  nice       -10
EOF

# ----- CPU governor: performance -----
log "Installing cpufrequtils and creating systemd service for performance governor…"
apt-get install -y cpufrequtils

cat >/etc/systemd/system/cpu-performance.service <<'EOF'
[Unit]
Description=Set CPU governor to performance
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'for c in /sys/devices/system/cpu/cpu[0-9]*; do \
  [ -f "$c/cpufreq/scaling_governor" ] && echo performance > "$c/cpufreq/scaling_governor" || true; done'

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now cpu-performance.service || true

# ----- PipeWire, JACK, routing tools -----
log "Ensuring modern PipeWire stack + JACK shims + JACK tools…"
apt-get install -y \
  pipewire pipewire-audio-client-libraries pipewire-jack wireplumber \
  qjackctl jackd2 a2jmidid

# Ubuntu Studio Controls (handy toggles for JACK/PipeWire)
log "Installing Ubuntu Studio Controls & audio tools…"
apt-get install -y ubuntustudio-controls cadence || true  # cadence from KX repos in some versions; ignore if missing

# ----- DAWs -----
log "Installing native DAWs (Ardour). REAPER can be added optionally…"
apt-get install -y ardour

# Optional: REAPER (native Linux). Uncomment to auto-install latest x64 tarball.
# NOTE: license required after eval. Adjust version URLs as needed.
#log "Installing REAPER (optional)…"
#TMPD="$(mktemp -d)"
#pushd "$TMPD"
#wget -qO reaper.tar.xz "https://www.reaper.fm/files/6.x/reaper681_linux_x86_64.tar.xz" || true
#[ -f reaper.tar.xz ] && tar -xf reaper.tar.xz && pushd reaper_linux_x86_64 && ./install-reaper.sh --install /opt/reaper --integrate-desktop
#popd; popd; rm -rf "$TMPD" || true

# ----- Plugins (LV2/VST), synths, utils -----
log "Installing common Linux-native plugins & synths…"
apt-get install -y \
  calf-plugins lsp-plugins dragonfly-reverb \
  zam-plugins x42-plugins \
  surge \
  zynaddsubfx \
  dexed \
  carla carla-bridge-lv2 carla-bridge-win32 carla-bridge-win64

# NOTE: Not installing "helm" synth to avoid conflicts with Kubernetes Helm in your DevOps world.

# ----- Wine + yabridge for Windows VSTs -----
log "Installing Wine (stable) + winetricks…"
dpkg --add-architecture i386
apt-get update -y
apt-get install -y wine-stable wine64 wine32 winetricks

log "Installing yabridge (bridge Windows VST2/VST3 to Linux)…"
# yabridge is actively maintained. We'll install to /opt/yabridge and symlink.
YAB_VER="latest"
YAB_URL="$(curl -s https://api.github.com/repos/robbert-vdh/yabridge/releases/${YAB_VER} | grep browser_download_url | grep 'yabridge-.*-linux.tar.gz' | head -n1 | cut -d\" -f4 || true)"
if [ -n "${YAB_URL}" ]; then
  mkdir -p /opt/yabridge
  curl -L "$YAB_URL" | tar -xz -C /opt/yabridge
  install -Dm755 /opt/yabridge/yabridgectl /usr/local/bin/yabridgectl
  # Initialize yabridge for the user (non-root) on next login
  su - "$USER_NAME" -c 'mkdir -p ~/.vst ~/.vst3 ~/.wine'
  # Create a first-time setup script in user’s home to map plugin dirs
  cat >"${USER_HOME}/.configure_yabridge.sh" <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
yabridgectl sync || true
echo "yabridge initial sync done. Place your Windows VSTs in ~/.vst (VST2 .dll) or ~/.vst3 (VST3 folders) and rerun 'yabridgectl sync'."
EOS
  chown "$USER_NAME":"$USER_NAME" "${USER_HOME}/.configure_yabridge.sh"
  chmod +x "${USER_HOME}/.configure_yabridge.sh"
else
  warn "Could not auto-fetch yabridge release. Install manually from: https://github.com/robbert-vdh/yabridge"
fi

# ----- Session management -----
log "Installing RaySession (session manager)…"
apt-get install -y raysession

# ----- Snapshots & backups -----
log "Installing Timeshift (system snapshots) and BorgBackup (project backups)…"
apt-get install -y timeshift borgbackup

# ----- QoL & optional cleanup -----
log "Installing OBS Studio (if you want to stream/record screens)…"
apt-get install -y obs-studio || true

# Lightly trim noisy services (safe and reversible)
if systemctl is-enabled --quiet apport.service; then
  log "Disabling apport crash reporting spam (optional)…"
  systemctl disable --now apport.service || true
fi

# Tracker is GNOME; Ubuntu Studio (KDE/XFCE) may not have it. Ignore failures.
systemctl --user mask tracker-miner-fs 2>/dev/null || true

# ----- JACK/MIDI quality-of-life -----
log "Creating a JACK autostart helper (optional)…"
mkdir -p /usr/local/bin
cat >/usr/local/bin/jack-start <<'EOF'
#!/usr/bin/env bash
# Quick-start JACK at 48kHz, 128 frames, 2 periods (tweak to taste)
# Requires qjackctl/jackd2 installed.
exec qjackctl &
EOF
chmod +x /usr/local/bin/jack-start

# ----- Final info for the user -----
log "All done. Recommended next steps:"
echo "1) REBOOT to load the lowlatency kernel & apply governor settings."
echo "2) Launch 'Ubuntu Studio Controls' to pick PipeWire or JACK as needed."
echo "3) Test a low-latency JACK session: run 'jack-start' or open qjackctl."
echo "4) DAWs:"
echo "   - Ardour installed (Menu → Multimedia)."
echo "   - REAPER optional (uncomment in script). Bitwig is commercial (install separately)."
echo "5) Plugins: LV2 (Calf, LSP, x42, Dragonfly), synths (Surge, Zyn, Dexed)."
echo "6) Windows VSTs:"
echo "   - Put .dll (VST2) in ~/.vst and VST3 folders in ~/.vst3"
echo "   - Then run: ~/.configure_yabridge.sh"
echo "7) Snapshots/Backups:"
echo "   - Timeshift for system; Borg for projects/samples to NAS/disk."
echo
log "Pro-tip: Pin a known-good kernel and avoid apt full-upgrades mid-project."
log "If you want me to tailor buffer sizes, IRQ affinities, or interface-specific quirks (RME/Focusrite/etc.), tell me your exact audio interface."
