# Third-party notices

This repository and its release files contain work by OpenSourceSDRLab together with third-party software. The Apache License 2.0 in [LICENSE](LICENSE) applies **only** to the files created by OpenSourceSDRLab:

- `docs/`, `hardware/`, `images/`, `README.md`, `NOTICE.md`, and the `README.md` files in sub-folders
- in `baremetal/`:
  - `FMC_ADRV9009_PL/FMC_ADRV9009_PL.srcs/sources_1/new/axi_lite_drv.v`, `jesd204_transport_layer.v`, `jesd204b_adc_dac_top.v`
  - `FMC_ADRV9009_PL/FMC_ADRV9009_PL.srcs/constrs_1/new/IO_planning.xdc`
  - `FMC_ADRV9009_PL/FMC_ADRV9009_PL.srcs/sim_1/imports/new/tb_jesd204b_adc_dac_top.v`
  - `FMC_ADRV9009_PS/FMC_ADRV9009_PS/src/app/rf_config.c`, `rf_config.h`
  - `FMC_ADRV9009_PS/FMC_ADRV9009_PS/src/devices/adi_hal/`: `change_rfpll.*`, `common.h`, `io_control.h`, `spi_ctrl.*`
  - `FMC_ADRV9009_PS/LED/src/main.c`
  - `axi_ddr3_test/rtl/`, `axi_ddr3_test/sim/`, `axi_ddr3_test/xdc/`
- in `linux/`:
  - `prepare.sh`
  - `petalinux/project-spec/meta-user/recipes-apps/adrv9009-heartbeat/` (the recipe itself declares MIT)
  - `petalinux/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi`
  - `hdl/projects/adrv9009/zc706/`: `xc7z100_plddr3_dacfifo_bd.tcl`, `xc7z100_plddr3_mig.prj`, `ddr3_pin.ucf`, `mem_init_sys.txt` (new files for this board)

All other files keep their original copyright notices and licences, which have not been changed:

| Component | Files | Owner | Licence |
|---|---|---|---|
| ADRV9009 (Talise) API and ADI HAL | `baremetal/FMC_ADRV9009_PS/FMC_ADRV9009_PS/src/devices/talise/` and the files in `devices/adi_hal/` that carry an Analog Devices copyright header | Analog Devices, Inc. | ADI Source Code Software License Agreement, see `LICENSE.txt` in `devices/talise/` and `devices/adi_hal/` |
| Talise application and configuration | `FMC_ADRV9009_PS/FMC_ADRV9009_PS/src/app/headless.c`, `talise_config.c`, `talise_config.h` | Analog Devices, Inc. | as stated in each file header. Modified versions: `headless.c` (LO frequency, TX attenuation, start-up messages) and `talise_config.c` (JESD204B lane polarity) contain changes made for this board |
| Talise ARM and stream firmware (object code inside `FMC_ADRV9009_PS.elf` in Releases) | Releases only | Analog Devices, Inc. | AD937X Software License Agreement (20180301-AD937X-CTSLA) |
| ADI HDL modules | `baremetal/FMC_ADRV9009_PL/FMC_ADRV9009_PL.srcs/sources_1/new/ad_iobuf.v`, `up_axi.v` | Analog Devices, Inc. | as stated in each file header |
| ADI HDL project files (modified by OpenSourceSDRLab for this board) | `linux/hdl/projects/adrv9009/zc706/` `system_bd.tcl`, `system_constr.xdc`, `system_top.v`; `linux/hdl/projects/common/zc706/` | Analog Devices, Inc. | ADI HDL licence terms, see `linux/hdl/LICENSE*` |
| Linux kernel changes | `linux/kernel/0001-XC7Z100-ADRV9009-board-support.patch` (changes to Analog Devices / Xilinx kernel files) | Analog Devices, Inc., Xilinx, Inc. and the Linux kernel authors | GPL-2.0 |
| meta-adi files (modified) | `linux/meta-adi-2022_R2/` | Analog Devices, Inc. | MIT |
| PetaLinux project configuration | `linux/petalinux/project-spec/` (generated configuration and recipe templates), `linux/hardware/system_top.xsa` | Xilinx, Inc. / AMD | Xilinx/AMD licence terms |
| Xilinx/AMD IP cores, block design and generated files | `baremetal/FMC_ADRV9009_PL/` (`.xci`, `.xcix`, `.bd` and generated files), `baremetal/axi_ddr3_test/prj/` (`.xci`, `.prj` and generated files), `baremetal/FMC_ADRV9009_PS/jesd204b_adc_dac_top.xsa`, and the Xilinx parts of the prebuilt `.bit`, `.xsa` and `fsbl.elf` in Releases | Xilinx, Inc. / AMD | Xilinx/AMD licence terms |
| Xilinx example applications | `baremetal/FMC_ADRV9009_PS/TCP_Server/`, `DDR_Test/`, `xusbps_intr_example_1/`, and the `lscript.ld` linker scripts | Xilinx, Inc. | as stated in each file header (MIT / BSD-style) |
| lwIP library files (modified by OpenSourceSDRLab: YT8531 PHY support) | `baremetal/lwip211_v2_0/` | Xilinx, Inc.; lwIP by the Swedish Institute of Computer Science and contributors | BSD-style licence in each file header |
| SD-card image (Releases) | Linux kernel, U-Boot, BusyBox and other root-filesystem packages built with PetaLinux 2022.2 and the Analog Devices kernel 2022_R2; FPGA bitstream built from the ADI HDL | the respective authors (Linux kernel and U-Boot: GPL-2.0) | as stated in each component; source code: see below |

Files and software that are **not** included and must be obtained from Analog Devices:

- the Talise firmware headers `talise_arm_binary.h` and `talise_stream_binary.h` (version 6.0.2), needed to build the bare-metal application from source. Their licence only allows distribution as object code inside a product. Download instructions and checksums: `baremetal/FMC_ADRV9009_PS/FMC_ADRV9009_PS/src/firmware/README.md`;
- the ADRV9009 Transceiver Evaluation Software: <https://www.analog.com/en/products/adrv9009.html>.

Source code of the GPL software in the SD-card image: the kernel is the Analog Devices Linux kernel, branch `2022_R2` (commit `7aa63204d396316bb6c362b34294babae7a6f32b`), with the changes in `linux/kernel/`; U-Boot and the root filesystem are built by PetaLinux 2022.2 from the Xilinx/AMD and Yocto sources of that release with the configuration in `linux/petalinux/`. See `linux/README.md`. To receive the complete corresponding source code of the GPL software in the image, write to support@opensourcesdrlab.com.

"Analog Devices", "ADRV9009", "AD9528", "Xilinx", "Zynq", "Vivado", "Vitis" and "PetaLinux" are trademarks of their respective owners. They are used here only to describe compatibility and do not imply endorsement.
