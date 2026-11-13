/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include "spi_ctrl.h"
#include "platform_drivers.h"
#include "parameters.h"
#include "util.h"
#include <stdint.h>
#include <stdio.h>
#include <math.h>
spi_init_param spi_AD9528_param = { XILINX_SPI, 0, 25000000, SPI_MODE_0, 1};


uint32_t AD9528_init_data[] = {//30.72MHz ref clock
	       0x000081,
			0x000100,
			0x000099,
			0x000120,
			0x000F01,

			0x010004,
			0x010204,
			0x010404,

			0x01068C,  //holdover
			//0x010703,
			0x010801,
			0x010938,
			0x010A00,

			0x020187,
			0x020301,
			0x020403,
			0x020809,
			0x02001C,

			0x030209,
			0x030300,
			0x030509,
			0x030809,
			0x030B09,
			0x032440,
			0x032609,
			0x032700,
			0x032909,

			0x040040,
			0x040280,
			0x04039B,
			0x040405,

			0x0501F1,
			0x05020F,
			0x050509,
			0x050503,
			0x050700,

			0x000F01,
		};
int32_t spi_init_clk(struct spi_desc **spi_desc ,spi_init_param spi_param) {
	int32_t status = 0;
	status |= spi_init(spi_desc, &spi_param);
	if (status != SUCCESS)
		return FAILURE;
	else
		return SUCCESS;
}

int32_t spi_write32(spi_desc *spi_adrv_desc, uint32_t val) {
	uint8_t buf[4];
	int32_t ret;
	uint32_t cmd = val;

	buf[0] = cmd >> 24;
	buf[1] = cmd >> 16;
	buf[2] = cmd >> 8;
	buf[3] = cmd & 0xFF;

	ret = spi_write_and_read(spi_adrv_desc, buf, 4);
	return ret;
}
int32_t spi_write24(spi_desc *spi_adrv_desc, uint32_t val) {
	uint8_t buf[3];
	int32_t ret;
	uint32_t cmd = val;

	buf[0] = cmd >> 16;
	buf[1] = cmd >> 8;
	buf[2] = cmd & 0xFF;

	ret = spi_write_and_read(spi_adrv_desc, buf, 3);
	return ret;
}
int32_t AD9528_init(struct spi_desc *spi_desc) {
	int ret;
	int i;
	for (i = 0; i < ARRAY_SIZE(AD9528_init_data); i++) {
		ret = spi_write24(spi_desc, AD9528_init_data[i]);
		mdelay(10);
	}
	printf("total register number=%d\n", i);
	uint8_t val = AD9528_spi_read(spi_desc, 6);
	printf("AD9528_reg[6]=%x\n", val);
	return ret;
}
int32_t AD9528_update_sysref_pulse(struct spi_desc *spi_desc) {
	int ret;
	ret = spi_write24(spi_desc, 0x01448B);
	ret = spi_write24(spi_desc, 0x014352);
	ret = spi_write24(spi_desc, 0x013902);
	return ret;
}

int32_t AD9528_get_dac_value(struct spi_desc *spi_desc, uint16_t *man_dac) {
	uint16_t value;
	value = AD9528_spi_read(spi_desc, 0x184);
	value = ((value & 0xC0) << 8) | (AD9528_spi_read(spi_desc, 0x185) & 0xff);
	printf("dac_value=%d\n", value);
	*man_dac = round(value / 1024 * 2200 + 500);
	return 0;
}
int32_t AD9528_holdover_en(struct spi_desc *spi_desc, uint16_t enable) {
	int ret;
	ret = spi_write24(spi_desc, 0x014B16 | ((enable & 0x1) << 3));
	ret = spi_write24(spi_desc, 0x014C00);
	return ret;
}
int32_t AD9528_send_sysref_pulse(struct spi_desc *spi_desc) {
	int ret;
	ret = spi_write24(spi_desc, 0x013E03);
	return ret;
}
int32_t AD9528_send_sync_pol(struct spi_desc *spi_desc) {
	int ret;
	ret = spi_write24(spi_desc, 0x0143B1);
	ret = spi_write24(spi_desc, 0x014391);
	return ret;
}
int32_t AD9528_spi_readm(spi_desc *spi_adrv_desc, uint32_t reg,
		uint8_t *rbuf)
{
	uint8_t buf[3];
	int32_t ret;
	uint16_t cmd;

	cmd = 0x8000 | (reg & 0x1FFF);
	buf[0] = cmd >> 8;
	buf[1] = cmd & 0xFF;
	buf[2] = 0;
	ret = spi_write_and_read(spi_adrv_desc, buf, 3);
	*rbuf=buf[2];
	return ret;
}
uint8_t AD9528_spi_read(spi_desc *spi_adrv_desc, uint32_t reg)
{
	uint8_t buf;
	int32_t ret;

	ret = AD9528_spi_readm(spi_adrv_desc, reg, &buf);
	if (ret < 0)
		return ret;
	return buf;
}
