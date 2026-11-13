# lwIP library for the bare-metal TCP server

The `TCP_Server` application uses the Xilinx `lwip211` library (lwIP 2.1.1) with support for the Motorcomm YT8531 Ethernet PHY added. This folder contains only the three files that differ from the Xilinx original:

| File | Change |
|---|---|
| `data/lwip211.mld` | library version set to 2.0, so that Vitis prefers it over the built-in copy |
| `src/contrib/ports/xilinx/netif/xemacpsif_physpeed.c` | YT8531 PHY detection, auto-negotiation and RGMII delay setup (Zynq GEM) |
| `src/contrib/ports/xilinx/netif/xaxiemacif_physpeed.c` | Realtek and YT8531 PHY detection, PHY address scan order (AXI Ethernet) |

All three files are © Xilinx, Inc. and keep their original licence headers (see `NOTICE.md` in the repository root).

## Prepare the library

1. Get the original library from the Xilinx `embeddedsw` repository, release `xilinx_v2021.1` (library version 1.5, the one shipped with Vitis 2021.1):

        git clone --depth 1 -b xilinx_v2021.1 https://github.com/Xilinx/embeddedsw.git
        mkdir -p lwip-repo/sw_services
        cp -r embeddedsw/ThirdParty/sw_services/lwip211 lwip-repo/sw_services/lwip211_v2_0

2. Copy the three files from this folder over it:

        cp -r <repo>/baremetal/lwip211_v2_0/data <repo>/baremetal/lwip211_v2_0/src lwip-repo/sw_services/lwip211_v2_0/

3. Check the copied files (they must match exactly):

        1f65a7e31bb0bef549a6248bcbf050bb93863017c79fdb7d42b4e63d58c6e533  data/lwip211.mld
        a99a830e18f2960c36fa09568ed0073d10b1896fc310ac54750280974f1aff8d  src/contrib/ports/xilinx/netif/xaxiemacif_physpeed.c
        ded5b3edb00d6e9d9500d97baa21fdeeaa3478c64aef029d134c421441588ce9  src/contrib/ports/xilinx/netif/xemacpsif_physpeed.c

4. In Vitis 2021.1, add `lwip-repo` under **Xilinx > Software Repositories**, then select `lwip211` version 2.0 in the platform's board support package settings.

All other files of the library are identical to `embeddedsw` `xilinx_v2021.1` (checked file by file).
