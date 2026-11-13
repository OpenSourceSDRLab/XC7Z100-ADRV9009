/***************************************************************************//**
 * @file jesd_core.c
 * @brief Implementation of JESD Core Driver.
 * @author DBogdan (dragos.bogdan@analog.com)
 ********************************************************************************
 * Copyright 2017(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 * - Neither the name of Analog Devices, Inc. nor the names of its
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * - The use of this software may or may not infringe the patent rights
 * of one or more patent holders. This license does not release you
 * from the requirement that you obtain separate licenses from these
 * patent holders to use this software.
 * - Use of the software either in source or binary form, must be run
 * on or directly connected to an Analog Devices Inc. component.
 *
 * THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *******************************************************************************/

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdio.h>
#include "jesd_phy.h"
#include "talise_config.h"
#define ARRAY_SIZE(ar)		(sizeof(ar)/sizeof(ar[0]))
/***************************************************************************//**
* @brief xcvr_calc_cpll_settings
*******************************************************************************/
int32_t xcvr_calc_cpll_settings(uint32_t trans_type, uint32_t refclk_kHz,
		uint32_t laneRate_kHz, uint32_t *refclk_div, uint32_t *out_div,
		uint32_t *fbdiv_45, uint32_t *fbdiv)
{
	uint32_t n1, n2, d, m;
	uint32_t pllFreq_kHz;

	uint32_t vco_min;
	uint32_t vco_max;

	switch (trans_type) {
	case GTXE2:
		vco_min = 1600000;
		vco_max = 3300000;
		break;
	case GTHE3:
	case GTHE4:
		vco_min = 2000000;
		vco_max = 6250000;
		break;
	default:
		return -1;
	}

	/* Possible Xilinx GTX PLL parameters for Virtex 7 CPLL.  Find one that works for the desired laneRate. */
	/* Attribute encoding, DRP encoding */
	const uint8_t N1[][2] = {{5, 1}, {4, 0} };
	const uint8_t N2[][2] = {{5, 3}, {4, 2}, {3, 1}, {2, 0}, {1, 16} };
	const uint8_t D[][2] = {{1, 0}, {2, 1}, {4, 2}, {8, 3} };
	const uint8_t M[][2] = {{1, 16}, {2, 0} };

	for (m = 0; m < ARRAY_SIZE(M); m++) {
		for (d = 0; d < ARRAY_SIZE(D); d++) {
			for (n1 = 0; n1 < ARRAY_SIZE(N1); n1++) {
				for (n2 = 0; n2 < ARRAY_SIZE(N2); n2++) {
					pllFreq_kHz = refclk_kHz * N1[n1][0] * N2[n2][0] / M[m][0];

					if ((pllFreq_kHz > vco_max) || (pllFreq_kHz < vco_min))
						continue;

					if ((pllFreq_kHz * 2 / D[d][0]) == laneRate_kHz) {
						if (refclk_div && out_div && fbdiv_45 && fbdiv) {
							*refclk_div = M[m][1];
							*out_div = D[d][1];
							*fbdiv_45 = N1[n1][1];
							*fbdiv = N2[n2][1];
						}

						return laneRate_kHz;
					}
				}
			}
		}
	}
	return -1;
}
uint32_t find_first_bit(uint32_t word)
{
	int32_t num = 0;

	if ((word & 0xffff) == 0) {
			num += 16;
			word >>= 16;
	}
	if ((word & 0xff) == 0) {
			num += 8;
			word >>= 8;
	}
	if ((word & 0xf) == 0) {
			num += 4;
			word >>= 4;
	}
	if ((word & 0x3) == 0) {
			num += 2;
			word >>= 2;
	}
	if ((word & 0x1) == 0)
			num += 1;
	return num;
}
void __drp_write(uint32_t jesd_phy_addr, uint32_t reg, uint32_t mask,
		uint32_t offset, uint32_t val) {
	uint32_t tmp;
	uint32_t reg_data;
	AXI_REG_WRITE(jesd_phy_addr, 0x104, 0x40000000 | reg);
	reg_data = AXI_REG_READ(jesd_phy_addr, 0x10c);
//	printf("the GTX %#x=%x\r\n",reg,reg_data);
	tmp = reg_data;
	tmp &= ~mask;
//	printf("tmp &= ~mask=%x\r\n",tmp);
	tmp |= ((val << offset) & mask);
//	printf("tmp |= ((val << offset) & mask)=%x\r\n",tmp);
	AXI_REG_WRITE(jesd_phy_addr, 0x108, tmp);
	AXI_REG_WRITE(jesd_phy_addr, 0x104, 0x80000000 | reg);
	AXI_REG_WRITE(jesd_phy_addr, 0x104, 0x40000000 | reg);
	reg_data = AXI_REG_READ(jesd_phy_addr, 0x10c);
//	printf("the new GTX %#x=%x\r\n",reg,reg_data);
}
void __drp_write2(uint32_t jesd_phy_addr, uint32_t reg, uint32_t mask,
		uint32_t offset, uint32_t val) {
	uint32_t tmp;
	uint32_t reg_data;
	AXI_REG_WRITE(jesd_phy_addr, 0x204, 0x40000000 | reg);
	reg_data = AXI_REG_READ(jesd_phy_addr, 0x20c);
//	printf("the GTX %#x=%x\r\n",reg,reg_data);
	tmp = reg_data;
	tmp &= ~mask;
//	printf("tmp &= ~mask=%x\r\n",tmp);
	tmp |= ((val << offset) & mask);
//	printf("tmp |= ((val << offset) & mask)=%x\r\n",tmp);
	AXI_REG_WRITE(jesd_phy_addr, 0x208, tmp);
	AXI_REG_WRITE(jesd_phy_addr, 0x204, 0x80000000 | reg);
	AXI_REG_WRITE(jesd_phy_addr, 0x204, 0x40000000 | reg);
	reg_data = AXI_REG_READ(jesd_phy_addr, 0x20c);
//	printf("the new GTX %#x=%x\r\n",reg,reg_data);
}
/***************************************************************************//**
* @brief xcvr_calc_qpll_settings
*******************************************************************************/
int32_t xcvr_calc_qpll_settings(uint32_t trans_type, uint32_t refclk_kHz,
		uint32_t laneRate_kHz, uint32_t *refclk_div, uint32_t *out_div,
		uint32_t *fbdiv, uint32_t *fbdiv_ratio, uint32_t *lowband)
{
	/* Calculate the FPGA GTX PLL settings M, D, N1, N2 */
	uint32_t n, d, m;
	uint32_t pllVcoFreq_kHz;
	uint32_t pllOutFreq_kHz;
	uint32_t vco0_min;
	uint32_t vco0_max;
	uint32_t vco1_min;
	uint32_t vco1_max;
	const uint8_t *N;
	static const uint8_t N_gtx2[] = {16, 20, 32, 40, 64, 66, 80, 100, 0};
	static const uint8_t N_gth34[] = { 16, 20, 32, 40, 64, 66, 75, 80, 100, 112,
			120, 125, 150, 160, 0 };
	switch (trans_type) {
	case GTXE2:
		N = N_gtx2;
		vco0_min = 5930000;
		vco0_max = 8000000;
		vco1_min = 9800000;
		vco1_max = 12500000;
		break;
	case GTHE3:
	case GTHE4:
	case GTYE4:
		N = N_gth34;
		vco0_min = 9800000;
		vco0_max = 16375000;
		vco1_min = vco0_min;
		vco1_max = vco0_max;
		break;
	default:
		return -1;
	}
	/* Possible Xilinx GTX QPLL parameters for Virtex 7 QPLL.  Find one that works for the desired laneRate. */
	/* Attribute encoding, DRP encoding */
	const uint8_t D[][2] = {{1, 0}, {2, 1}, {4, 2}, {8, 3}, {16, 4} };
	const uint8_t M[][2] = {{1, 16}, {2, 0}, {3, 1}, {4, 2} };
	uint8_t _lowBand = 0;

	for (m = 0; m < ARRAY_SIZE(M); m++) {
		for (d = 0; d < ARRAY_SIZE(D); d++) {
			for (n = 0; N[n] != 0; n++) {

				pllVcoFreq_kHz = refclk_kHz * N[n] / M[m][0];
				pllOutFreq_kHz = pllVcoFreq_kHz / 2;

				if ((pllVcoFreq_kHz >= vco0_min) && (pllVcoFreq_kHz <= vco0_max)) {
					/* low band = 5.93G to 8.0GHz VCO */
					_lowBand = 1;
				} else if ((pllVcoFreq_kHz >= vco1_min) && (pllVcoFreq_kHz <= vco1_max)) {
					/* high band = 9.8G to 12.5GHz VCO */
					_lowBand = 0;
				} else {
					continue; /* if Pll out of range, not valid case, keep trying */
				}

				if ((pllOutFreq_kHz * 2 / D[d][0]) == laneRate_kHz) {
					if (refclk_div && out_div && fbdiv_ratio && fbdiv
							&& lowband) {
						*refclk_div = M[m][1];
						*out_div = D[d][1];
						switch (trans_type) {
						case GTXE2:
							switch (N[n]) {
							case 16:
								*fbdiv = 32;
								break;
							case 20:
								*fbdiv = 48;
								break;
							case 32:
								*fbdiv = 96;
								break;
							case 40:
								*fbdiv = 128;
								break;
							case 64:
								*fbdiv = 224;
								break;
							case 66:
								*fbdiv = 320;
								break;
							case 80:
								*fbdiv = 288;
								break;
							case 100:
								*fbdiv = 368;
								break;
							default:
								return -1;
							}
							break;
						case GTHE3:
						case GTHE4:
						case GTYE4:
							*fbdiv = N[n] - 2;
							break;
						}
						*fbdiv_ratio = (*fbdiv == 66) ? 0 : 1;
					}
					if (lowband)
						*lowband = _lowBand;
					return laneRate_kHz;
				}

			}
		}
	}
	return -1;
}
int32_t jesd_phy_clk_set_rate(phy_jesd phy_jesd, phy_jesd_clk * phy_jesd_clk) {
	uint32_t refclk_div = 0, out_div = 0, fbdiv_45 = 0, fbdiv = 0, fbdiv_ratio =
			0, lowband = 0;
	int32_t ret;
	printf("lane_rate_khz= %ld\n", phy_jesd.lane_rate_khz);
	if (phy_jesd.cpll_enable) {
		ret = xcvr_calc_cpll_settings(phy_jesd.trans_type,
				phy_jesd.ref_rate_khz, phy_jesd.lane_rate_khz, &refclk_div,
				&out_div, &fbdiv_45, &fbdiv);
		if (ret < 0)
			return ret;
		print("use cpll:");
		printf("refclk_div= %ld,", refclk_div);
		printf("out_div= %ld,", out_div);
		printf("fbdiv_45= %ld,", fbdiv_45);
		printf("fbdiv= %ld\n", fbdiv);
	} else {
		ret = xcvr_calc_qpll_settings(phy_jesd.trans_type,
				phy_jesd.ref_rate_khz, phy_jesd.lane_rate_khz, &refclk_div,
				&out_div, &fbdiv, &fbdiv_ratio, &lowband);
		if (ret < 0)
			return ret;
		print("use qpll:");
		printf("refclk_div= %ld,", refclk_div);
		printf("out_div= %ld,", out_div);
		printf("fbdiv= %ld,", fbdiv);
		printf("fbdiv_ratio= %ld,", fbdiv_ratio);
		printf("lowband= %ld\n", lowband);
	}
	phy_jesd_clk->refclk_div = refclk_div;
	phy_jesd_clk->out_div = out_div;
	phy_jesd_clk->fbdiv_45 = fbdiv_45;
	phy_jesd_clk->fbdiv = fbdiv;
	phy_jesd_clk->fbdiv_ratio = fbdiv_ratio;
	phy_jesd_clk->lowband = lowband;

	phy_jesd_clk->cfg2 = 0x23FF;
	phy_jesd_clk->cfg0 = 0x0020;
	phy_jesd_clk->cfg3 = 0x0000;
	phy_jesd_clk->cfg4 = 0x03;
	switch (out_div) {
	case 0: /* 1 */
		phy_jesd_clk->cfg1 = 0x1040;
		break;
	case 1: /* 2 */
		phy_jesd_clk->cfg1 = 0x1020;
		break;
	case 2: /* 4 */
		phy_jesd_clk->cfg1 = 0x1010;
		break;
	case 3: /* 8 */
		phy_jesd_clk->cfg1 = 0x1008;
		break;
	default:
		return -1;
	}
	if (ret < 0)
		return ret;
	return 0;
}
int32_t jesd_qpll_set(uint32_t jesd_phy_addr, uint32_t trans_type,
		phy_jesd_clk phy_jesd_clk) {
	if (trans_type == GTXE2) {
		drp_write(jesd_phy_addr, 0x32, 0x40, phy_jesd_clk.lowband);
		drp_write(jesd_phy_addr, 0x33, 0xf800, phy_jesd_clk.refclk_div);
		drp_write(jesd_phy_addr, 0x36, 0x3ff, phy_jesd_clk.fbdiv);
		drp_write(jesd_phy_addr, 0x37, 0x40, phy_jesd_clk.fbdiv_ratio);
	} else {
		drp_write(jesd_phy_addr, 0x18, 0xf80, phy_jesd_clk.refclk_div);
		drp_write(jesd_phy_addr, 0x14, 0xff, phy_jesd_clk.fbdiv);
	}
	return 0;
}
int32_t jesd_cpll_set(uint32_t jesd_phy_addr, uint32_t trans_type,
		phy_jesd_clk phy_jesd_clk) {
	if (trans_type == GTXE2) {
		drp_write2(jesd_phy_addr, 0x29, 0xffff, 0x0104);
		drp_write2(jesd_phy_addr, 0x5e, 0x1f00, phy_jesd_clk.refclk_div);
		drp_write2(jesd_phy_addr, 0x5e, 0x0080, phy_jesd_clk.fbdiv_45);
		drp_write2(jesd_phy_addr, 0x5e, 0x007f, phy_jesd_clk.fbdiv);
		drp_write2(jesd_phy_addr, 0xa8, 0xffff, phy_jesd_clk.cfg0);
		drp_write2(jesd_phy_addr, 0xa9, 0xffff, phy_jesd_clk.cfg1);
		drp_write2(jesd_phy_addr, 0xaa, 0xffff, phy_jesd_clk.cfg2);
		drp_write2(jesd_phy_addr, 0xab, 0xffff, phy_jesd_clk.cfg3);
		drp_write2(jesd_phy_addr, 0xac, 0x00ff, phy_jesd_clk.cfg4);
	}else{
		drp_write2(jesd_phy_addr, 0x28, 0xff00, phy_jesd_clk.fbdiv);
		drp_write2(jesd_phy_addr, 0x28, 0x0080, phy_jesd_clk.fbdiv_45);
		drp_write2(jesd_phy_addr, 0x2a, 0xf800, phy_jesd_clk.refclk_div);
	}
	return 0;
}
int32_t jesd_outdiv_set(uint32_t jesd_phy_addr, uint32_t trans_type,
		phy_jesd_clk phy_jesd_clk_tx, phy_jesd_clk phy_jesd_clk_rx) {
	if (trans_type == GTXE2) {
		drp_write2(jesd_phy_addr, 0x88, 0x70, phy_jesd_clk_tx.out_div);
		drp_write2(jesd_phy_addr, 0x88, 0x07, phy_jesd_clk_rx.out_div);
	} else {
		drp_write2(jesd_phy_addr, 0x7c, 0x700, phy_jesd_clk_tx.out_div);
		drp_write2(jesd_phy_addr, 0x63, 0x07, phy_jesd_clk_rx.out_div);
	}
	return 0;
}
int32_t jesd_phy_settings_singlephy(uint32_t jesd_phy_addr) {
	phy_jesd phy_jesd_tx;
	phy_jesd phy_jesd_rx;
	phy_jesd phy_jesd_orx;
	uint32_t trans_type = AXI_REG_READ(jesd_phy_addr, 0x04) & 0xff;
	printf("trans_type=%ld\n", trans_type);
	phy_jesd_tx.ref_rate_khz = talInit.clocks.deviceClock_kHz;
	phy_jesd_tx.lane_rate_khz = talInit.tx.txProfile.txInputRate_kHz *20;
	phy_jesd_tx.trans_type = trans_type;
	phy_jesd_rx.ref_rate_khz = talInit.clocks.deviceClock_kHz;
	phy_jesd_rx.lane_rate_khz = talInit.rx.rxProfile.rxOutputRate_kHz *40;
	phy_jesd_rx.trans_type = trans_type;
	phy_jesd_orx.ref_rate_khz = talInit.clocks.deviceClock_kHz;
	phy_jesd_orx.lane_rate_khz = talInit.obsRx.orxProfile.orxOutputRate_kHz *40;
	phy_jesd_orx.trans_type = trans_type;
	phy_jesd_tx.cpll_enable=0;
	phy_jesd_rx.cpll_enable=0;
	phy_jesd_orx.cpll_enable=0;

	phy_jesd_clk phy_jesd_clk_tx;
	phy_jesd_clk phy_jesd_clk_rx;
	phy_jesd_clk phy_jesd_clk_orx;
	int32_t ret;
	uint16_t qpll_num=AXI_REG_READ(jesd_phy_addr, 0x08);
	uint16_t trans_num=AXI_REG_READ(jesd_phy_addr, 0x0C);
	printf("Number of Common Interfaces=%d\n", qpll_num);
	printf("Number of Transceiver Interfaces=%d\n", trans_num);
	ret = jesd_phy_clk_set_rate(phy_jesd_tx, &phy_jesd_clk_tx);
	if (ret < 0) {
		phy_jesd_tx.cpll_enable = 1;
		ret = jesd_phy_clk_set_rate(phy_jesd_tx, &phy_jesd_clk_tx);
	}
	if (ret < 0)
		return -1;
	ret = jesd_phy_clk_set_rate(phy_jesd_rx, &phy_jesd_clk_rx);
	if (ret < 0)
		return -1;
	ret = jesd_phy_clk_set_rate(phy_jesd_orx, &phy_jesd_clk_orx);
	if (ret < 0)
		return -1;
	int i=0;
	//set JESD PHY0 QPLL0
	for (i = 0; i < qpll_num; i++) {
		AXI_REG_WRITE(jesd_phy_addr, 0x020, i); //select QPLL0
		AXI_REG_WRITE(jesd_phy_addr, 0x304, 1); //QPLL0 power down
		if (phy_jesd_tx.cpll_enable == 0)
			ret = jesd_qpll_set(jesd_phy_addr, trans_type, phy_jesd_clk_tx);
		else if (phy_jesd_rx.cpll_enable == 0)
			ret = jesd_qpll_set(jesd_phy_addr, trans_type, phy_jesd_clk_rx);
		AXI_REG_WRITE(jesd_phy_addr, 0x304, 0); //QPLL Power up
	}
	//set JESD PHY0 CH0 -> txn rxn
	for (i = 0; i < trans_num; i++) {
		AXI_REG_WRITE(jesd_phy_addr, 0x024, i); //select gt bank0
		AXI_REG_WRITE(jesd_phy_addr, 0x420, 1); //tx path reset
		AXI_REG_WRITE(jesd_phy_addr, 0x424, 1); //rx path reset
		printf("default txpll sel=%ld\n", AXI_REG_READ(jesd_phy_addr, 0x40C));
		if (phy_jesd_tx.cpll_enable)
			AXI_REG_WRITE(jesd_phy_addr, 0x40C, 0); //tx pll cpll
		else
			AXI_REG_WRITE(jesd_phy_addr, 0x40C, 3); //tx pll qpll
		if (phy_jesd_rx.cpll_enable)
			AXI_REG_WRITE(jesd_phy_addr, 0x410, 0); //rx pll cpll
		else
			AXI_REG_WRITE(jesd_phy_addr, 0x410, 3); //rx pll qpll
		if (phy_jesd_tx.cpll_enable || phy_jesd_rx.cpll_enable)
			ret = jesd_cpll_set(jesd_phy_addr, trans_type, phy_jesd_clk_rx);
		else {
			AXI_REG_WRITE(jesd_phy_addr, 0x408, 1); //CPLL power down
//			printf("lane%d,CPLL power down\n", i);
		}
		ret = jesd_outdiv_set(jesd_phy_addr, trans_type, phy_jesd_clk_tx,
				phy_jesd_clk_rx);
		AXI_REG_WRITE(jesd_phy_addr, 0x420, 0); //tx path reset
		AXI_REG_WRITE(jesd_phy_addr, 0x424, 0); //rx path reset
	}
	//release reset
#if 0
	AXI_REG_WRITE(jesd_phy_addr, 0x204, 0x40000000 | 0x11);
	printf("the GTX 0x11=%x\r\n", AXI_REG_READ(jesd_phy_addr, 0x20c));
	AXI_REG_WRITE(jesd_phy_addr, 0x204, 0x40000000 | 0x5b);
	printf("the GTX 0x5b=%x\r\n", AXI_REG_READ(jesd_phy_addr, 0x20c));
	AXI_REG_WRITE(jesd_phy_addr, 0x204, 0x40000000 | 0x5c);
	printf("the GTX 0x5c=%x\r\n", AXI_REG_READ(jesd_phy_addr, 0x20c));
	AXI_REG_WRITE(jesd_phy_addr, 0x204, 0x40000000 | 0x5d);
	printf("the GTX 0x5d=%x\r\n", AXI_REG_READ(jesd_phy_addr, 0x20c));
#endif
	return 0;
}
