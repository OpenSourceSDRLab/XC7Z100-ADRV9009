#include <stdint.h>
#include <stdio.h>
#include "talise_radioctrl.h"
#include "talise_error.h"
#include "talise_cals.h"
uint8_t pllLockStatus;
uint8_t errorFlag = 0;
uint32_t status;
void change_rfpll(taliseDevice_t talDevice, uint64_t new_freq) {
	uint32_t talError = TALACT_NO_ACTION;
	uint32_t initCalMask = TAL_TX_BB_FILTER
			| TAL_ADC_TUNER | TAL_TIA_3DB_CORNER
			| TAL_DC_OFFSET | TAL_TX_ATTENUATION_DELAY | TAL_RX_GAIN_DELAY
			| TAL_FLASH_CAL | TAL_PATH_DELAY | TAL_TX_LO_LEAKAGE_INTERNAL
			| TAL_TX_QEC_INIT | TAL_LOOPBACK_RX_LO_DELAY
			| TAL_LOOPBACK_RX_RX_QEC_INIT | TAL_RX_LO_DELAY | TAL_RX_QEC_INIT
			| TAL_RX_PHASE_CORRECTION | TAL_ORX_LO_DELAY | TAL_TX_DAC
			| TAL_ADC_STITCHING | TAL_ORX_QEC_INIT;
	uint64_t parent_freq;
	TALISE_getRfPllFrequency(&talDevice, TAL_RF_PLL, &parent_freq);
	if (new_freq < parent_freq + 100e6 && new_freq > parent_freq - 100e6) {
		//change RF freq less than 100MHz
		talError = TALISE_radioOff(&talDevice);
		talError = TALISE_setRfPllFrequency(&talDevice, TAL_RF_PLL, new_freq);
		talError = TALISE_getPllsLockStatus(&talDevice, &pllLockStatus);
		if ((pllLockStatus & 0x0F) == 0x07) {
			printf(" RF, CLK, and AUX PLL locked\n");
		}
		talError = TALISE_resetExtTxLolChannel(&talDevice, TAL_TX1TX2);
		talError = TALISE_radioOn(&talDevice);
		if (talError != TALACT_NO_ACTION) {
			printf("error: change_rfpll() failed\n");
		}
	} else {
		talError = TALISE_radioOff(&talDevice);
		talError = TALISE_setRfPllFrequency(&talDevice, TAL_RF_PLL, new_freq);
		talError = TALISE_getPllsLockStatus(&talDevice, &pllLockStatus);
		if ((pllLockStatus & 0x0F) == 0x07) {
			printf(" RF, CLK, and AUX PLL locked\n");
		}
		talError = TALISE_runInitCals(&talDevice, initCalMask);
		talError = TALISE_waitInitCals(&talDevice, 20000, &errorFlag);
		if (errorFlag) {
			printf("error: Calibrations not completed\n");
		} else {
			printf("talise: Calibrations completed successfully\n");
		}
		talError = TALISE_radioOn(&talDevice);
	}
	printf("change_rfpll freq %lldHz ok!\r\n", new_freq);
}
