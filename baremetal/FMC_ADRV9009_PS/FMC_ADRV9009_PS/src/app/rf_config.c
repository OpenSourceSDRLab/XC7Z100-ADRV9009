/*
 * ad9009_init.c
 *
 * Copyright (c) OpenSourceSDRLab
 * https://www.opensourcesdrlab.com
 */
#include <rf_config.h>
#include "talise_arm_binary.h"
#include "talise_stream_binary.h"
#include "talise_gpio_types.h"
#include "talise_gpio.h"
extern uint32_t axi_lite_addr;
extern struct gpio_desc *gpio_rf1_gpio0;
extern struct gpio_desc *gpio_lmk_sync;
extern uint64_t rflo;
/*************************************************************************/
/*****                     ad9009_hard_reset                         *****/
/*************************************************************************/
uint32_t ad9009_hard_reset(taliseDevice_t *talDev, uint32_t rfid) {
	uint32_t talAction = TALACT_NO_ACTION;
	/*Open Talise Hw Device*/
	talAction = TALISE_openHw(talDev,rfid);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: RF%ld, TALISE_openHw() failed\n",rfid);
		return talAction;
	}

	/* Toggle RESETB pin on Talise device */
	talAction = TALISE_resetDevice(talDev);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: RF%ld, TALISE_resetDevice() failed\n",rfid);
		return talAction;
	}
	mdelay(100);

	/* TALISE_initialize() loads the Talise device data structure
	 * settings for the Rx/Tx/ORx profiles, FIR filters, digital
	 * filter enables, calibrates the CLKPLL, loads the user provided Rx
	 * gain tables, and configures the JESD204b serializers/framers/deserializers
	 * and deframers.
	 */
	talAction = TALISE_initialize(talDev, &talInit);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: RF%ld, TALISE_initialize() failed\n",rfid);
		return talAction;
	}
	return talAction;
}
/*************************************************************************/
/*****                           ad9009_init                         *****/
/*************************************************************************/
uint32_t ad9009_init(taliseDevice_t *talDev) {
	uint32_t talAction = TALACT_NO_ACTION;
	uint8_t pllLockStatus = 0;
	uint8_t mcsStatus = 0;
	uint32_t count = sizeof(armBinary);
	taliseArmVersionInfo_t talArmVersionInfo;
	uint32_t api_vers[4];
	uint8_t rev;
	/***** CLKPLL Status Check *****/
	/*******************************/
	talAction = TALISE_getPllsLockStatus(talDev, &pllLockStatus);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("TALISE_getPllsLockStatus() failed\n");
		return talAction;
	}
	/* Assert that Talise CLKPLL is locked */
	if ((pllLockStatus & 0x01) == 0) {
		/* <user code - CLKPLL not locked - ensure lock before proceeding */
		printf("error: CLKPLL not locked\n");
		return talAction;
	}
	/*******************************************************/
	/**** Perform MultiChip Sync (MCS) on Talise Device ***/
	/*******************************************************/
//	talAction = TALISE_enableMultichipSync(talDev, 1, &mcsStatus);
//	if (talAction != TALACT_NO_ACTION) {
//		/*** < User: decide what to do based on Talise recovery action returned > ***/
//		printf("error: TALISE_enableMultichipSync() failed\n");
//		return talAction;
//	}
//	/*******************/
//	/**** Verify MCS ***/
//	/*******************/
//	talAction = TALISE_enableMultichipSync(talDev, 0, &mcsStatus);
//	if ((mcsStatus & 0x0B) != 0x0B) {
//		/*< user code - MCS failed - ensure MCS before proceeding*/
//		printf("warning: TALISE_enableMultichipSync() failed\n");
//		return talAction;
//	}
	/*******************************************************/
	/**** Prepare Talise Arm binary and Load Arm and	****/
	/**** Stream processor Binaryes 					****/
	/*******************************************************/
	if (pllLockStatus & 0x01) {
		talAction = TALISE_initArm(talDev, &talInit);
		if (talAction != TALACT_NO_ACTION) {
			/*** < User: decide what to do based on Talise recovery action returned > ***/
			printf("error: TALISE_initArm() failed\n");
			return talAction;
		}
		/*< user code- load Talise stream binary into streamBinary[4096] >*/
		/*< user code- load ARM binary byte array into armBinary[114688] >*/
		talAction = TALISE_loadStreamFromBinary(talDev, &streamBinary[0]);
		if (talAction != TALACT_NO_ACTION) {
			/*** < User: decide what to do based on Talise recovery action returned > ***/
			printf("error: TALISE_loadStreamFromBinary() failed\n");
			return talAction;
		}
		talAction = TALISE_loadArmFromBinary(talDev, &armBinary[0], count);
		if (talAction != TALACT_NO_ACTION) {
			/*** < User: decide what to do based on Talise recovery action returned > ***/
			printf("error: TALISE_loadArmFromBinary() failed\n");
			return talAction;
		}
		/* TALISE_verifyArmChecksum() will timeout after 200ms
		 * if ARM checksum is not computed
		 */
		talAction = TALISE_verifyArmChecksum(talDev);
		if (talAction != TAL_ERR_OK) {
			/*< user code- ARM did not load properly - check armBinary & clock/profile settings >*/
			printf("error: TALISE_verifyArmChecksum() failed\n");
			return talAction;
		}

	} else {
		/*< user code- check settings for proper CLKPLL lock  > ***/
		printf("error: CLKPLL not locked\n");
		return talAction;
	}
	TALISE_getDeviceRev(talDev, &rev);
	TALISE_getArmVersion_v2(talDev, &talArmVersionInfo);
	TALISE_getApiVersion(talDev, &api_vers[0], &api_vers[1], &api_vers[2],
			&api_vers[3]);

	printf(
			"talise: Device Revision %d, Firmware %d.%d.%d, API %lu.%lu.%lu.%lu\n",
			rev, talArmVersionInfo.majorVer, talArmVersionInfo.minorVer,
			talArmVersionInfo.rcVer, api_vers[0], api_vers[1], api_vers[2],
			api_vers[3]);
	return talAction;
}
/*************************************************************************/
/*****                      ad9009_rf_init_setpll                    *****/
/*************************************************************************/
uint32_t ad9009_rf_init_setpll(taliseDevice_t *talDev) {
	uint32_t talAction = TALACT_NO_ACTION;
	uint8_t pllLockStatus = 0;
	/*******************************/
	/**Set RF PLL LO Frequencies ***/
	/*******************************/
	talAction = TALISE_setRfPllFrequency(talDev, TAL_RF_PLL, rflo);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_setRfPllFrequency() failed\n");
		return talAction;
	}
	/*** < wait 200ms for PLLs to lock - user code here > ***/
	talAction = TALISE_getPllsLockStatus(talDev, &pllLockStatus);
	if ((pllLockStatus & 0x07) != 0x07) {
		/*< user code - ensure lock of all PLLs before proceeding>*/
		printf("error: RFPLL not locked\n");
		return talAction;
	}
	return talAction;
}

/*************************************************************************/
/*****                           ad9009_mcps                         *****/
/*************************************************************************/
uint32_t ad9009_mcps(taliseDevice_t *talDev) {
	uint32_t talAction = TALACT_NO_ACTION;
	talAction = TALISE_enableMultichipRfLOPhaseSync(talDev, 1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: enableMultichipRfLOPhaseSync() failed\n");
		return talAction;
	}
	//gpio_direction_output(gpio_lmk_sync, 0);
	mdelay(1);
	//gpio_direction_output(gpio_lmk_sync, 1);
	//mdelay(1);
	//gpio_direction_output(gpio_lmk_sync, 0);
	talAction=TALISE_enableMultichipRfLOPhaseSync(talDev, 0);
	mdelay(1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: enableMultichipRfLOPhaseSync() failed\n");
		return talAction;
	}
//	talAction = TALISE_serializerReset(talDev);
//	if (talAction != TALACT_NO_ACTION) {
//		/*** < User: decide what to do based on Talise recovery action returned > ***/
//		printf("error:  TALISE_serializerReset() failed\n",
//				);
//		return talAction;
//	}
	return talAction;
}

/*************************************************************************/
/*****                           ad9009_rf_init_cal                      *****/
/*************************************************************************/
uint32_t ad9009_rf_init_cal(taliseDevice_t *talDev) {
	uint32_t talAction = TALACT_NO_ACTION;
	uint32_t initCalMask = TAL_TX_BB_FILTER
			| TAL_ADC_TUNER | TAL_TIA_3DB_CORNER
			| TAL_DC_OFFSET | TAL_TX_ATTENUATION_DELAY | TAL_RX_GAIN_DELAY
			| TAL_FLASH_CAL | TAL_PATH_DELAY | TAL_TX_LO_LEAKAGE_INTERNAL
			| TAL_TX_QEC_INIT | TAL_LOOPBACK_RX_LO_DELAY
			| TAL_LOOPBACK_RX_RX_QEC_INIT | TAL_RX_LO_DELAY | TAL_RX_QEC_INIT
			| TAL_RX_PHASE_CORRECTION | TAL_ORX_LO_DELAY | TAL_TX_DAC
			| TAL_ADC_STITCHING | TAL_ORX_QEC_INIT;
	uint8_t errorFlag = 0;

	/****************************************************/
	/**** Run Talise ARM Initialization Calibrations ***/
	/****************************************************/
	talAction = TALISE_runInitCals(talDev, initCalMask);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_runInitCals() failed\n");
		return talAction;
	}

	talAction = TALISE_waitInitCals(talDev, 20000, &errorFlag);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_waitInitCals() failed\n");
		return talAction;
	}

	if (errorFlag) {
		/*< user code - Check error flag to determine ARM  error> */
		printf("error: Calibrations not completed\n");
		return talAction;
	} else {
		/*< user code - Calibrations completed successfully > */
		printf("talise: Calibrations completed successfully\n");
	}
//	taliseAuxDac_t auxDac = {
//	0x10, /*!< Aux DAC enable bit for each DAC */
//	{ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }, /*!< Aux DAC voltage reference value for each of the 10-bit DACs */
//	{ 0, 0, 0, 0, 2, 0, 0, 0, 0, 0 }, /*!< Aux DAC slope (resolution of voltage change per AuxDAC code) */
//	{ 0, 0, 0, 0, 373, 0, 0, 0, 0, 0, 0, 0 } /*!< Aux DAC values for each 10-bit DAC */
//	};
//	TALISE_setGpio3v3Oe(talDev, 0, 0);
//	talAction = TALISE_setupAuxDacs(talDev, &auxDac);
//	if (talAction != TALACT_NO_ACTION) {
//		/*** < User: decide what to do based on Talise recovery action returned > ***/
//		printf("error:  TALISE_setupAuxDacs() failed\n");
//		return talAction;
//	}
	talAction = TALISE_serializerReset(talDev);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error:  TALISE_serializerReset() failed\n");
		return talAction;
	}
	return talAction;
}

/*************************************************************************/
/*****                    ad9009_jesd204b_init                       *****/
/*************************************************************************/
uint32_t ad9009_jesd204b_init(taliseDevice_t *talDev) {
	uint32_t talAction = TALACT_NO_ACTION;
	/***************************************************/
	/**** Enable  Talise JESD204B Framer ***/
	/***************************************************/
	talAction = TALISE_enableFramerLink(talDev, TAL_FRAMER_A, 0);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableFramerLink() failed\n");
		return talAction;
	}
	talAction |= TALISE_enableFramerLink(talDev, TAL_FRAMER_A, 1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableFramerLink() failed\n");
		return talAction;
	}
	/*************************************************/
	/**** Enable SYSREF to Talise JESD204B Framer ***/
	/*************************************************/
	/*** < User: Make sure SYSREF is stopped/disabled > ***/
	talAction = TALISE_enableSysrefToFramer(talDev, TAL_FRAMER_A, 1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableSysrefToFramer() failed\n");
		return talAction;
	}
	/***************************************************/
	/**** Enable  Talise JESD204B Framer ***/
	/***************************************************/
	talAction = TALISE_enableFramerLink(talDev, TAL_FRAMER_B, 0);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableFramerLink() failed\n");
		return talAction;
	}
	talAction |= TALISE_enableFramerLink(talDev, TAL_FRAMER_B, 1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableFramerLink() failed\n");
		return talAction;
	}
	/*************************************************/
	/**** Enable SYSREF to Talise JESD204B Framer ***/
	/*************************************************/
	/*** < User: Make sure SYSREF is stopped/disabled > ***/
	talAction = TALISE_enableSysrefToFramer(talDev, TAL_FRAMER_B, 1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableSysrefToFramer() failed\n");
		return talAction;
	}
	/***************************************************/
	/**** Enable  Talise JESD204B Deframer ***/
	/***************************************************/
	talAction = TALISE_enableDeframerLink(talDev, TAL_DEFRAMER_A, 0);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableDeframerLink() failed\n");
		return talAction;
	}
	talAction |= TALISE_enableDeframerLink(talDev, TAL_DEFRAMER_A, 1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableDeframerLink() failed\n");
		return talAction;
	}
	/***************************************************/
	/**** Enable SYSREF to Talise JESD204B Deframer ***/
	/***************************************************/
	talAction = TALISE_enableSysrefToDeframer(talDev, TAL_DEFRAMER_A, 1);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableDeframerLink() failed\n");
		return talAction;
	}
	return talAction;
}
/*************************************************************************/
/*****                    fpga_jesd204b_init                         *****/
/*************************************************************************/
uint32_t fpga_jesd204b_init(jesd_core_array jesdarray, uint32_t jesd_phy0_addr) {
	uint32_t status=0;
	status = jesd_phy_settings_singlephy(jesd_phy0_addr);
	/* Initialize JESDs for Device rf1 */
	jesd_setup(jesdarray.tx_jesd);
	jesd_setup(jesdarray.rx_jesd);
	jesd_setup(jesdarray.orx_jesd);
	mdelay(100);
	return status;
}

uint32_t jesd204b_check(taliseDevice_t *talDev, jesd_core_array jesd_array) {
	uint32_t talAction = TALACT_NO_ACTION;
	uint16_t deframerStatus = 0;
	uint8_t framerStatus = 0;

	/**************************************/
	/**** Check Talise Deframer Status ***/
	/**************************************/
	talAction = TALISE_readDeframerStatus(talDev, TAL_DEFRAMER_A,
			&deframerStatus);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_readDeframerStatus() failed\n");
		return talAction;
	}
	if ((deframerStatus & 0xF7) != 0x86) {
		printf("warning: TAL_DEFRAMER_A status 0x%X\n", deframerStatus);
		return talAction = 255;
	}
	/************************************/
	/**** Check Talise Framer Status ***/
	/************************************/
	talAction = TALISE_readFramerStatus(talDev, TAL_FRAMER_A, &framerStatus);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_readFramerStatus() failed\n");
		return talAction;
	}
	if ((framerStatus & 0x07) != 0x05) {
		printf("warning: TAL_FRAMER_A status 0x%X\n", framerStatus);
		return talAction = 255;
	}
	/************************************/
	/**** Check Talise Framer Status ***/
	/************************************/
	talAction = TALISE_readFramerStatus(talDev, TAL_FRAMER_B, &framerStatus);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_readFramerStatus() failed\n");
		return talAction;
	}
	if ((framerStatus & 0x07) != 0x05) {
		printf("warning: TAL_FRAMER_B status 0x%X\n", framerStatus);
		//return talAction = 255;
	}
//	/*** < User: When links have been verified, proceed > ***/
//	uint32_t status = jesd_status(jesd_array.tx_jesd);
//	if (status != -1)
//		printf("tx_jesd is locking!\n");
//	else {
//		printf("tx_jesd is error!\n");
//		return talAction = 255;
//	}
//	status = jesd_status(jesd_array.rx_jesd);
//	if (status != -1)
//		printf("rx_jesd is locking!\n");
//	else {
//		printf("rx_jesd is error!\n");
//		return talAction = 255;
//	}
//	status = jesd_status(jesd_array.orx_jesd);
//	if (status != -1)
//		printf("orx_jesd is locking!\n");
//	else {
//		printf("orx_jesd is error!\n");
//		//return talAction = 255;
//	}
	return talAction;
}
/*************************************************************************/
/*****                           ad9009_radio_on                     *****/
/*************************************************************************/
uint32_t ad9009_radio_on(taliseDevice_t *talDev) {
	uint32_t talAction = TALACT_NO_ACTION;
	uint32_t trackingCalMask = TAL_TRACK_RX1_QEC | TAL_TRACK_RX2_QEC
			|TAL_TRACK_ORX1_QEC | TAL_TRACK_ORX2_QEC
			|TAL_TRACK_TX1_LOL | TAL_TRACK_TX2_LOL
			| TAL_TRACK_TX1_QEC | TAL_TRACK_TX2_QEC
			|TAL_TRACK_RX1_HD2 |TAL_TRACK_RX2_HD2;
	/***********************************************
	 * Allow Rx1/2 QEC tracking and Tx1/2 QEC	   *
	 * tracking to run when in the radioOn state	*
	 * Tx calibrations will only run if radioOn and *
	 * the obsRx path is set to OBS_INTERNAL_CALS   *
	 * **********************************************/
	talAction = TALISE_enableTrackingCals(talDev, trackingCalMask);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_enableTrackingCals() failed\n");
		return talAction;
	}
	taliseFhmConfig_t taliseFhmConfig;
	taliseFhmConfig.fhmGpioPin = TAL_GPIO_00;
	taliseFhmConfig.fhmMinFreq_MHz = 123;
	taliseFhmConfig.fhmMaxFreq_MHz = 6000;
	talAction = TALISE_setFhmConfig(talDev, &taliseFhmConfig);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_setFhmConfig() failed\n");
		return talAction;
	}
	/* Function to turn radio on, Enables transmitters and receivers */
	/* that were setup during TALISE_initialize() */
	talAction = TALISE_radioOn(talDev);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_radioOn() failed\n");
		return talAction;
	}
	taliseFhmMode_t fhmMode;
	fhmMode.fhmEnable = 1;
	fhmMode.enableMcsSync = 1;
	fhmMode.fhmTriggerMode = TAL_FHM_NON_GPIO_MODE; //TAL_FHM_GPIO_MODE;
	fhmMode.fhmExitMode = TAL_FHM_FULL_EXIT;
	fhmMode.fhmInitFrequency_Hz = 2500e6;//RFPllLoFrequency_Hz;
	talAction = TALISE_setFhmMode(talDev, &fhmMode);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_setFhmMode() failed\n");
		return talAction;
	}
	talAction = TALISE_setRxTxEnable(talDev, TAL_RX1RX2, TAL_TX1TX2);
	if (talAction != TALACT_NO_ACTION) {
		/*** < User: decide what to do based on Talise recovery action returned > ***/
		printf("error: TALISE_setRxTxEnable() failed\n");
		return talAction;
	}
	TALISE_enableFramerTestData(talDev, TAL_FRAMER_A_AND_B, TAL_FTD_ADC_DATA, //TAL_FTD_RAMP,TAL_FTD_ADC_DATA
			TAL_FTD_FRAMERINPUT);

	return talAction;
}
uint32_t ad9009_rx_dc_offset_cal(taliseDevice_t *device, uint8_t rank_matrix){
	uint8_t rank_matrix_ori = 0;
	uint32_t talAction = TALACT_NO_ACTION;
	TALISE_getDigDcOffsetMShift(device, TAL_DC_OFFSET_RX_CHN, &rank_matrix_ori);
	//	printf("rank_matrix_ori is %x\n", rank_matrix_ori);
	//calculate the rank of correlation matrix for RX notch filter according to RF situation, frequency range and sample rate,
	talAction = TALISE_setDigDcOffsetMShift(device, TAL_DC_OFFSET_RX_CHN, rank_matrix);
	return talAction;
}
uint32_t ad9009_initial_rf1(taliseDevice_t *talDev_rf1,
		jesd_core_array jesd_array_rf1,
		uint32_t jesd_phy0_addr) {
	uint32_t talAction = TALACT_NO_ACTION;
	talAction = ad9009_hard_reset(talDev_rf1, 0);
	if (talAction != TALACT_NO_ACTION) {
		printf("error: rf1_ad9009_hard_reset() failed\n");
		return talAction;
	}
	talAction = ad9009_init(talDev_rf1);
	if (talAction != TALACT_NO_ACTION) {
		printf("error: rf1_ad9009_init() failed\n");
		return talAction;
	}
	talAction = ad9009_rf_init_setpll(talDev_rf1);
	if (talAction != TALACT_NO_ACTION) {
		printf("error: ad9009_rf_init_setpll() failed\n");
		return talAction;
	}

	talAction = ad9009_mcps(talDev_rf1);
	if (talAction != TALACT_NO_ACTION) {
		printf("error: ad9009_mcps() failed\n");
		return talAction;
	}

	talAction = ad9009_rf_init_cal(talDev_rf1);
	if (talAction != TALACT_NO_ACTION) {
		printf("error: ad9009_rf_init_cal() failed\n");
		return talAction;
	}

	mdelay(1000);
	talAction = 255;
	while (talAction == 255) {
		AXI_REG_WRITE(axi_lite_addr, 2 * 4, 1);
		talAction = ad9009_jesd204b_init(talDev_rf1);
		//		gpio_direction_output(gpio_lmk_sync, 0);
		//		mdelay(10);
		//		gpio_direction_output(gpio_lmk_sync, 1);
		//		mdelay(10);
		//		gpio_direction_output(gpio_lmk_sync, 0);
		talAction = fpga_jesd204b_init(jesd_array_rf1, jesd_phy0_addr);
		AXI_REG_WRITE(axi_lite_addr, 2 * 4, 0);
		//		gpio_direction_output(gpio_lmk_sync, 0);
		//		mdelay(1);
		//		gpio_direction_output(gpio_lmk_sync, 1);
		//		mdelay(1);
		//		gpio_direction_output(gpio_lmk_sync, 0);
		mdelay(100);
		talAction = jesd204b_check(talDev_rf1, jesd_array_rf1);
	}
	mdelay(500);
	talAction = ad9009_radio_on(talDev_rf1);
	if (talAction != TALACT_NO_ACTION) {
		printf("error: rf1_ad9009_radio_on() failed\n");
		return talAction;
	}
	AXI_REG_WRITE(axi_lite_addr, 75 * 4, 0);//rf1_gpio_o
	AXI_REG_WRITE(axi_lite_addr, 75 * 4, 1);//rf1_gpio_o
	AXI_REG_WRITE(axi_lite_addr, 75* 4, 0);//rf1_gpio_o

	return talAction;
}
