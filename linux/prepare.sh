#!/usr/bin/env bash
# Prepare an XC7Z100-ADRV9009 PetaLinux 2022.2 project tree after it has been
# assembled (see README.md): point the project configuration at this folder and
# restore execute permissions that archives tend to lose.
# Copyright (c) OpenSourceSDRLab - https://www.opensourcesdrlab.com
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PETALINUX_ROOT="$ROOT/petalinux"
PROJECT_NAME="$(basename "$ROOT")"

if [ ! -d "$PETALINUX_ROOT" ]; then
  echo "ERROR: petalinux directory not found under $ROOT" >&2
  exit 1
fi

if [ -d "$PETALINUX_ROOT/components/yocto/layers/core/scripts" ]; then
  find "$PETALINUX_ROOT/components/yocto/layers/core/scripts" \
    -type f -exec chmod u+x {} +
fi
if [ -d "$PETALINUX_ROOT/components/yocto/layers/core/bitbake/bin" ]; then
  find "$PETALINUX_ROOT/components/yocto/layers/core/bitbake/bin" \
    -type f -exec chmod u+x {} +
fi
if [ -f "$PETALINUX_ROOT/components/yocto/layers/core/oe-init-build-env" ]; then
  chmod u+x "$PETALINUX_ROOT/components/yocto/layers/core/oe-init-build-env"
fi

# Keep Yocto's postinstall-intercept templates non-executable.
# do_rootfs runs every *executable* file in scripts/postinst-intercepts, and at
# build time only the intercepts a package registers through postinst_intercept
# receive the +x bit. Marking these templates executable here makes do_rootfs
# run intercepts that were never set up, e.g. update_gtk_icon_cache fails with
# an empty libdir_native and the image build stops.
if [ -d "$PETALINUX_ROOT/components/yocto/layers" ]; then
  find "$PETALINUX_ROOT/components/yocto/layers" -type f \
    ! -path '*/scripts/postinst-intercepts/*' \
    \( -name '*.py' -o -name '*.sh' -o -name '*.pl' -o -path '*/scripts/*' -o -path '*/bin/*' \) \
    -exec chmod u+x {} +
fi
find "$ROOT/linux-2022_R2" -type f \
  \( -name '*.sh' -o -name '*.pl' -o -path '*/scripts/*' \) \
  -exec chmod u+x {} +

# Repair a tree where the templates were already made executable.
if [ -d "$PETALINUX_ROOT/components/yocto/layers/core/scripts/postinst-intercepts" ]; then
  find "$PETALINUX_ROOT/components/yocto/layers/core/scripts/postinst-intercepts" \
    -type f ! -name postinst_intercept -exec chmod 644 {} +
fi

mapfile -t path_files < <(
  grep -rIl \
    --exclude-dir=build \
    --exclude-dir=.git \
    --exclude-dir=oe-logs \
    --exclude='config.log' \
    --exclude='*.log' \
    --exclude='pyshtables.py' \
    -E "/opt/OpenSourceSDRLab/XC7Z100-ADRV9009|/opt/OpenSourceSDRLab/petalinux-downloads" \
    "$PETALINUX_ROOT/project-spec" \
    "$PETALINUX_ROOT/.petalinux" \
    "$PETALINUX_ROOT/components/yocto/environment-setup-cortexa9t2hf-neon-xilinx-linux-gnueabi" \
    2>/dev/null || true
)

for file in "${path_files[@]}"; do
  sed -i \
    -e "s|/opt/OpenSourceSDRLab/XC7Z100-ADRV9009|$ROOT|g" \
    -e "s|/opt/OpenSourceSDRLab/petalinux-downloads|$ROOT/petalinux/components/yocto|g" \
    "$file"
done

for config in \
  "$PETALINUX_ROOT/project-spec/configs/config" \
  "$PETALINUX_ROOT/project-spec/configs/config.old"; do
  if [ -f "$config" ]; then
    sed -i \
      -e "s|^CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_EXT_LOCAL_SRC_PATH=.*|CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_EXT_LOCAL_SRC_PATH=\"$ROOT/linux-2022_R2\"|" \
      -e "s|^CONFIG_TMP_DIR_LOCATION=.*|CONFIG_TMP_DIR_LOCATION=\"$PETALINUX_ROOT/build/tmp\"|" \
      -e "s|^CONFIG_PRE_MIRROR_URL=.*|CONFIG_PRE_MIRROR_URL=\"file://$PETALINUX_ROOT/components/yocto/downloads\"|" \
      -e 's|^CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=.*|CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=""|' \
      -e "s|^CONFIG_USER_LAYER_0=.*|CONFIG_USER_LAYER_0=\"$ROOT/meta-adi-2022_R2/meta-adi-core\"|" \
      -e "s|^CONFIG_USER_LAYER_1=.*|CONFIG_USER_LAYER_1=\"$ROOT/meta-adi-2022_R2/meta-adi-xilinx\"|" \
      "$config"
  fi
done

if [ -f "$PETALINUX_ROOT/.petalinux/metadata" ]; then
  sed -i \
    -e "s|^HARDWARE_PATH=.*|HARDWARE_PATH=$ROOT/hardware/system_top.xsa|" \
    "$PETALINUX_ROOT/.petalinux/metadata"
fi

echo "Prepared $PROJECT_NAME at: $ROOT"