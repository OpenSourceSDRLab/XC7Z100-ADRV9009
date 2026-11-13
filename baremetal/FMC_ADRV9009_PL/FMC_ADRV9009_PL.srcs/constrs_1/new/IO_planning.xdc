# jesd
set_property  -dict {PACKAGE_PIN AF15 IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports sysref_p];
set_property  -dict {PACKAGE_PIN AG15 IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports sysref_n];
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cpll_refclk]


set_property  PACKAGE_PIN AF10 [get_ports cpll_refclk_p   ];
set_property  PACKAGE_PIN AF9 [get_ports cpll_refclk_n   ];

set_property  PACKAGE_PIN AG8  [get_ports  rxp_in[0] ];
set_property  PACKAGE_PIN AG7  [get_ports  rxn_in[0] ];
set_property  PACKAGE_PIN AH10  [get_ports  rxp_in[1] ];
set_property  PACKAGE_PIN AH9  [get_ports  rxn_in[1] ];
set_property  PACKAGE_PIN AE8  [get_ports rxp_in[2] ];
set_property  PACKAGE_PIN AE7  [get_ports  rxn_in[2] ];
set_property  PACKAGE_PIN AJ8  [get_ports  rxp_in[3] ];
set_property  PACKAGE_PIN AJ7  [get_ports  rxn_in[3] ];

set_property  PACKAGE_PIN AJ4  [get_ports  txp_out[0] ];
set_property  PACKAGE_PIN AJ3  [get_ports  txn_out[0] ];
set_property  PACKAGE_PIN AK6  [get_ports  txp_out[1] ];
set_property  PACKAGE_PIN AK5  [get_ports  txn_out[1] ];
set_property  PACKAGE_PIN AK2  [get_ports txp_out[2] ];
set_property  PACKAGE_PIN AK1  [get_ports  txn_out[2] ];
set_property  PACKAGE_PIN AK10  [get_ports  txp_out[3] ];
set_property  PACKAGE_PIN AK9  [get_ports  txn_out[3] ];

set_property  -dict {PACKAGE_PIN  AK13  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AK12  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## G10  FMC_HPC_LA03_N
set_property  -dict {PACKAGE_PIN  AJ14   IOSTANDARD LVDS_25} [get_ports orx_sync_p]                    ; ## G27  FMC_HPC_LA25_P (Sniffer)
set_property  -dict {PACKAGE_PIN  AJ13   IOSTANDARD LVDS_25} [get_ports orx_sync_n]                    ; ## G28  FMC_HPC_LA25_N (Sniffer)
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## H08  FMC_HPC_LA02_N


set_property  -dict {PACKAGE_PIN  AG12  IOSTANDARD LVCMOS25} [get_ports spi0_cs_9528]               ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS25} [get_ports spi0_cs_9009]             ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS25} [get_ports spi0_clk]                      ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AH12  IOSTANDARD LVCMOS25} [get_ports spi0_mosi]                     ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AF13  IOSTANDARD LVCMOS25} [get_ports spi0_miso]                     ; ## G12  FMC_HPC_LA08_P

set_property  -dict {PACKAGE_PIN  AE12   IOSTANDARD LVCMOS25} [get_ports ad9528_reset_b]               ; ## D26  FMC_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  AC12   IOSTANDARD LVCMOS25} [get_ports ad9528_sysref_req]            ; ## D27  FMC_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS25} [get_ports adrv9009_tx1_enable]          ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AH13  IOSTANDARD LVCMOS25} [get_ports adrv9009_tx2_enable]          ; ## C18  FMC_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVCMOS25} [get_ports adrv9009_rx1_enable]          ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVCMOS25} [get_ports adrv9009_rx2_enable]          ; ## C19  FMC_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  AE16  IOSTANDARD LVCMOS25} [get_ports adrv9009_test]                ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AC16  IOSTANDARD LVCMOS25} [get_ports adrv9009_reset_b]             ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpint]               ; ## H11  FMC_HPC_LA04_N


