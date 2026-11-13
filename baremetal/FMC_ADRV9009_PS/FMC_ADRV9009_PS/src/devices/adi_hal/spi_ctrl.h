/*
 * spi_crtl.h
 *
 * Copyright (c) OpenSourceSDRLab
 * https://www.opensourcesdrlab.com
 */

#ifndef SRC_SPI_CTRL_H_
#define SRC_SPI_CTRL_H_
#include <stdint.h>
#include "platform_drivers.h"

int32_t spi_init_clk(struct spi_desc **spi_desc,spi_init_param spi_param);
int32_t spi_write24(spi_desc *spi_adrv_desc, uint32_t val);
int32_t spi_write32(spi_desc *spi_adrv_desc, uint32_t val);
int32_t AD9528_init(struct spi_desc *spi_desc);
int32_t AD9528_update_sysref_pulse(struct spi_desc *spi_desc);
int32_t AD9528_update_man_dac(struct spi_desc *spi_desc, uint16_t man_dac);
int32_t AD9528_get_dac_value(struct spi_desc *spi_desc, uint16_t *man_dac);
int32_t AD9528_holdover_en(struct spi_desc *spi_desc, uint16_t enable);
uint8_t AD9528_spi_read(spi_desc *spi_adrv_desc, uint32_t reg);
#endif /* SRC_SPI_CTRL_H_ */
