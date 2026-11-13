/*
 * ad9009_init.h
 *
 * Copyright (c) OpenSourceSDRLab
 * https://www.opensourcesdrlab.com
 */

#ifndef SRC_ad9009_CONFIG_H_
#define SRC_ad9009_CONFIG_H_
#include "talise.h"
#include "talise_jesd204.h"
#include "talise_arm.h"
#include "talise_radioctrl.h"
#include "talise_cals.h"
#include "talise_config.h"
#include "talise_error.h"
#include "adi_hal.h"
#include "parameters.h"
#include "util.h"
#include "jesd_core.h"
#include "jesd_phy.h"
#include "io_control.h"
#include <stdio.h>
/****< Insert User Includes Here >***/
#define JESD_CON_FAILED 520
typedef struct {
	jesd_core		tx_jesd;
	jesd_core		rx_jesd;
	jesd_core		orx_jesd;
} jesd_core_array;
uint32_t ad9009_hard_reset(taliseDevice_t *talDev, uint32_t rfid);
uint32_t ad9009_rf_init_setpll(taliseDevice_t *talDev);
uint32_t ad9009_rf_init_cal(taliseDevice_t *talDev);
uint32_t ad9009_mcps(taliseDevice_t *talDev);
uint32_t ad9009_rf_init(taliseDevice_t *talDev);
uint32_t ad9009_init_Calibrations(taliseDevice_t *talDev);
uint32_t ad9009_radio_on(taliseDevice_t *talDev);
uint32_t ad9009_jesd204b_init(taliseDevice_t *talDev);
uint32_t fpga_jesd204b_init(jesd_core_array jesdarray, uint32_t jesd_phy0_addr);
uint32_t jesd204b_check(taliseDevice_t *talDev, jesd_core_array jesd_array);
uint32_t ad9009_rx_dc_offset_cal(taliseDevice_t *device, uint8_t rank_matrix);
uint32_t ad9009_initial_rf1(taliseDevice_t *talDev_rf1,
		jesd_core_array jesd_array_rf1, uint32_t jesd_phy0_addr);
#endif /* SRC_ad9009_CONFIG_H_ */
