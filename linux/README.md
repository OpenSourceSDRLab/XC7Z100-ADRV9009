# Linux (PetaLinux 2022.2) for the XC7Z100-ADRV9009

This folder holds the board-specific part of the PetaLinux project that builds the SD-card image in the Releases. Everything else comes unchanged from Analog Devices and Xilinx/AMD release 2022_R2 / 2022.2.

| Path | Contents |
|---|---|
| `petalinux/` | PetaLinux 2022.2 project: `project-spec/` (configuration, device-tree additions, U-Boot and kernel configuration fragments, `adrv9009-heartbeat` LED service) |
| `hardware/system_top.xsa` | Prebuilt hardware description: XC7Z100 PS configuration, ADRV9009 JESD204B interface, PL DDR3 DAC FIFO |
| `hdl/projects/` | Files of the Analog Devices `adrv9009/zc706` HDL project that were changed or added for this board (XC7Z100-2FFG900 pin-out, 32-bit PL DDR3 DAC FIFO, no ZC706 HDMI/I2C), plus the HDL licence files |
| `kernel/0001-XC7Z100-ADRV9009-board-support.patch` | Changes to the Analog Devices Linux kernel (ADRV9009 JESD204B lane polarity and default LO, Zynq device tree for this board) |
| `meta-adi-2022_R2/` | Two changed device-tree files of the Analog Devices `meta-adi` layer |
| `prepare.sh` | Points the project configuration at the folder it is run from |

## Upstream sources

| Component | Source | Version |
|---|---|---|
| HDL | <https://github.com/analogdevicesinc/hdl> | branch `hdl_2022_r2` |
| Linux kernel | <https://github.com/analogdevicesinc/linux> | branch `2022_R2`, commit `7aa63204d396316bb6c362b34294babae7a6f32b` |
| Yocto layer | <https://github.com/analogdevicesinc/meta-adi> | branch `2022_R2` |
| PetaLinux, U-Boot, root filesystem | Xilinx/AMD PetaLinux 2022.2 (U-Boot `u-boot-xlnx` `xilinx-v2022.2`) | 2022.2 |

## Assemble and build

On Ubuntu with PetaLinux 2022.2 and (only if you change the HDL) Vivado 2022.2:

1. Create the project tree. `<repo>` is your clone of this repository:

        mkdir -p ~/XC7Z100-ADRV9009 && cd ~/XC7Z100-ADRV9009
        git clone -b hdl_2022_r2 https://github.com/analogdevicesinc/hdl.git hdl
        git clone -b 2022_R2 https://github.com/analogdevicesinc/meta-adi.git meta-adi-2022_R2
        git clone -b 2022_R2 https://github.com/analogdevicesinc/linux.git linux-2022_R2
        git -C linux-2022_R2 checkout 7aa63204d396316bb6c362b34294babae7a6f32b
        git -C linux-2022_R2 apply <repo>/linux/kernel/0001-XC7Z100-ADRV9009-board-support.patch
        cp -r <repo>/linux/hdl/projects/. hdl/projects/
        cp -r <repo>/linux/meta-adi-2022_R2/. meta-adi-2022_R2/
        cp -r <repo>/linux/petalinux <repo>/linux/hardware <repo>/linux/prepare.sh .

2. Run `bash prepare.sh` once (again whenever the folder moves).

3. Load PetaLinux and build:

        source <petalinux-2022.2-install-dir>/settings.sh
        cd petalinux
        petalinux-config --get-hw-description=../hardware --silentconfig
        petalinux-config -c rootfs --silentconfig
        petalinux-build
        petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga images/linux/system.bit \
          --u-boot images/linux/u-boot.elf --dtb images/linux/system.dtb --force

    The first build downloads the Yocto sources; on a machine without Internet access, prepare a `downloads` folder and point `CONFIG_PRE_MIRROR_URL` in `project-spec/configs/config` to it.

4. The results are in `petalinux/images/linux/`: `BOOT.BIN`, `image.ub`, `boot.scr` and `rootfs.tar.gz`. See the Quick Start Guide for writing them to an SD card.

To rebuild the hardware description, run `make` in `hdl/projects/adrv9009/zc706` with Vivado 2022.2 and copy the resulting `system_top.xsa` to `hardware/`.

## Board notes

- Serial console: PS UART0, 115200 8N1 (`console=ttyPS0,115200 earlycon root=/dev/mmcblk0p2 rw rootwait`).
- Network: `eth0` static `192.168.1.10/24`, gateway `192.168.1.1`.
- Login: `root` / `root` (set in the root-filesystem configuration, `CONFIG_ADD_EXTRA_USERS`); the `petalinux` user must set a password at first login.
- Heartbeat LED: the `adrv9009-heartbeat` service blinks `/sys/class/leds/adrv9009:heartbeat` (PS MIO7) every 500 ms once the ADRV9009 JESD204 state machine has reached `opt_post_running_stage` without errors.
- PL DDR3: used by the ADRV9009 DAC FIFO; constraints and memory-controller settings are in `hdl/projects/adrv9009/zc706/` (`system_constr.xdc`, `xc7z100_plddr3_dacfifo_bd.tcl`, `xc7z100_plddr3_mig.prj`, `ddr3_pin.ucf`) and `hdl/projects/common/zc706/zc706_plddr3_constr.xdc`.
