/***************************************************************************//**
 *   @file   platform_drivers.c
 *   @brief  Implementation of Xilinx Platform Drivers.
 *   @author DBogdan (dragos.bogdan@analog.com)
********************************************************************************
 * Copyright 2018(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  - Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *  - Neither the name of Analog Devices, Inc. nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *  - The use of this software may or may not infringe the patent rights
 *    of one or more patent holders.  This license does not release you
 *    from the requirement that you obtain separate licenses from these
 *    patent holders to use this software.
 *  - Use of the software either in source or binary form, must be run
 *    on or directly connected to an Analog Devices Inc. component.
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
#include <stdlib.h>
#include <stdio.h>
#include <sleep.h>
#include "platform_drivers.h"
#include "xiicps.h"
/******************************************************************************/
/************************ Functions Definitions *******************************/
/******************************************************************************/
XIicPs_Config *iic_config;
XIicPs IicInstance;
#define IIC_SCLK_RATE		100000
/**
 * @brief Initialize the I2C communication peripheral.
 * @param desc - The I2C descriptor.
 * @param init_param - The structure that contains the I2C parameters.
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
/***************************************************************************//**
 * @brief iic_init
*******************************************************************************/
int32_t iic_init(uint32_t device_id, uint32_t slave_addr)
{
	int Status;
#ifdef _XPARAMETERS_PS_H_
	iic_config = XIicPs_LookupConfig(device_id);
	if (iic_config == NULL) {
		return XST_FAILURE;
	}
	Status = XIicPs_CfgInitialize(&IicInstance, iic_config,
			iic_config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform a self-test to ensure that the hardware was built correctly.
	 */
	Status = XIicPs_SelfTest(&IicInstance);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XIicPs_SetSClk(&IicInstance, IIC_SCLK_RATE);
#else
	iic_config = XIic_LookupConfig(device_id);
	if (iic_config == NULL) {
		print("XIic_LookupConfig failed\n");
		return XST_FAILURE;
	}
	Status = XIic_CfgInitialize(&IicInstance, iic_config,
				iic_config->BaseAddress);
	if (Status != XST_SUCCESS) {
		print("XIic_CfgInitialize failed\n");
		return XST_FAILURE;
	}
	Status = XIic_SelfTest(&IicInstance);
	if (Status != XST_SUCCESS) {
		print("XIic_SelfTest failed\n");
		return XST_FAILURE;
	}
	Status = XIic_SetAddress(&IicInstance, XII_ADDR_TO_SEND_TYPE, slave_addr);
	if (Status != XST_SUCCESS) {
		print("XIic_SetAddress failed\n");
		return XST_FAILURE;
	}
//	Status = XIic_Start(&IicInstance);
//	if (Status != XST_SUCCESS) {
//		print("XIic_Start failed\n");
//		return XST_FAILURE;
//	}
#endif
	return XST_SUCCESS;
}

/***************************************************************************//**
 * @brief iic read and write
*******************************************************************************/

int i2c_polled_read(uint16_t slave_addr,uint8_t *p_read, uint16_t read_len)
{
	int Status;
	XIicPs_MasterRecv(&IicInstance, p_read, read_len,slave_addr);
//	if (Status != XST_SUCCESS) {
//		xil_printf("\ni2c wire read rcv Failed,Dev:0x%x\r\n",slave_addr);
//		return XST_FAILURE;
//	}
	/*
	 * Wait until bus is idle to start another transfer.
	 */
	while (XIicPs_BusIsBusy(&IicInstance)) {
		/* NOP */
	}
	return XST_SUCCESS;
}

int i2c_polled_write(uint16_t slave_addr,uint8_t *p_write, uint16_t write_len)
{
	int Status;
	XIicPs_MasterSend(&IicInstance, p_write, write_len,slave_addr);
//	if (Status != XST_SUCCESS) {
//		xil_printf("\ni2c_write Failed,Dev:0x%02x\r\n",slave_addr);
//		return XST_FAILURE;
//	}
	/*
	 * Wait until bus is idle to start another transfer.
	 */
	while (XIicPs_BusIsBusy(&IicInstance)) {
		/* NOP */
	}
	return XST_SUCCESS;
}
int i2c_read(uint16_t slave_addr,uint8_t *p_read, uint16_t read_len)
{
	return i2c_polled_read(slave_addr,p_read, read_len);
}

int i2c_write(uint16_t slave_addr,uint8_t *p_write, uint16_t write_len)
{
	return i2c_polled_write(slave_addr,p_write, write_len);
}
int i2c_reg_read(uint16_t slave_addr,uint16_t addr, uint8_t * p_data)
{
    int Status;
	if(!p_data) return XST_FAILURE;
	uint8_t buf[2];
	buf[0] = addr >> 8;
	buf[1] = addr & 0xff;
	Status = i2c_write(slave_addr,buf,2);
	if (Status != XST_SUCCESS) {
		printf("i2c wire read send Failed,Dev:0x%x",slave_addr);
		return XST_FAILURE;
	}
	Status = i2c_read(slave_addr,p_data,1);
	if (Status != XST_SUCCESS) {
		printf("i2c wire read rcv Failed,Dev:0x%x",slave_addr);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

int i2c_reg_write(uint16_t slave_addr,uint16_t addr, uint8_t data)
{
    int Status;
	uint8_t buf[3];
	buf[0] = addr >> 8;
	buf[1] = addr & 0xff;
	buf[2] = data;
	Status = i2c_write(slave_addr,buf,3);
	if (Status != XST_SUCCESS) {
		printf("i2c wire read send Failed,Dev:0x%x",slave_addr);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

/**
 * @brief Initialize the SPI communication peripheral.
 * @param desc - The SPI descriptor.
 * @param init_param - The structure that contains the SPI parameters.
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t spi_init(struct spi_desc **desc,
		 const struct spi_init_param *param)
{
	spi_desc *descriptor;
	int32_t ret;

//	descriptor = (struct spi_desc *) calloc(1, sizeof(*descriptor));
	descriptor = (struct spi_desc *) malloc(sizeof(*descriptor));
	if (!descriptor)
		return FAILURE;

	descriptor->mode = param->mode;
	descriptor->chip_select = param->chip_select;
	//descriptor->flags = param->flags;

#ifdef _XPARAMETERS_PS_H_
	descriptor->config = XSpiPs_LookupConfig(param->id);
	if (descriptor->config == NULL)
		goto error;

	ret = XSpiPs_CfgInitialize(&descriptor->instance,
				   descriptor->config, descriptor->config->BaseAddress);
	if (ret != 0)
		goto error;

//	XSpiPs_SetOptions(&descriptor->instance,
//			  XSPIPS_MASTER_OPTION |
//			  ((descriptor->flags & SPI_CS_DECODE) ?
//			  XSPIPS_DECODE_SSELECT_OPTION : 0) |
//			  XSPIPS_FORCE_SSELECT_OPTION |
//			  ((descriptor->mode & SPI_CPOL) ?
//			   XSPIPS_CLK_ACTIVE_LOW_OPTION : 0) |
//			  ((descriptor->mode & SPI_CPHA) ?
//			   XSPIPS_CLK_PHASE_1_OPTION : 0));
	XSpiPs_SetOptions(&descriptor->instance,
			  XSPIPS_MASTER_OPTION |
			  XSPIPS_DECODE_SSELECT_OPTION |
			  XSPIPS_FORCE_SSELECT_OPTION |
			  ((descriptor->mode & SPI_CPOL) ?
			   XSPIPS_CLK_ACTIVE_LOW_OPTION : 0) |
			  ((descriptor->mode & SPI_CPHA) ?
			   XSPIPS_CLK_PHASE_1_OPTION : 0));

	XSpiPs_SetClkPrescaler(&descriptor->instance,
			       XSPIPS_CLK_PRESCALE_64);

	XSpiPs_SetSlaveSelect(&descriptor->instance, 0xf);
#else
	ret = XSpi_Initialize(&descriptor->instance, param->id);
	if (ret != 0)
		goto error;

	XSpi_SetOptions(&descriptor->instance,
			XSP_MASTER_OPTION |
			((descriptor->mode & SPI_CPOL) ?
			 XSP_CLK_ACTIVE_LOW_OPTION : 0) |
			((descriptor->mode & SPI_CPHA) ?
			 XSP_CLK_PHASE_1_OPTION : 0));

	XSpi_Start(&descriptor->instance);

	XSpi_IntrGlobalDisable(&descriptor->instance);
#endif

	*desc = descriptor;

	return SUCCESS;

error:
	free(descriptor);

	return FAILURE;
}

/**
 * @brief Free the resources allocated by spi_init().
 * @param desc - The SPI descriptor.
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t spi_remove(struct spi_desc *desc)
{
	if (desc) {
		// Unused variable - fix compiler warning
	}

	return SUCCESS;
}

/**
 * @brief Write and read data to/from SPI.
 * @param desc - The SPI descriptor.
 * @param data - The buffer with the transmitted/received data.
 * @param bytes_number - Number of bytes to write/read.
 * @return SUCCESS in case of success, FAILURE otherwise.
 */

int32_t spi_write_and_read(struct spi_desc *desc,
			   uint8_t *data,
			   uint8_t bytes_number)
{
#ifdef _XPARAMETERS_PS_H_
	XSpiPs_SetOptions(&desc->instance,
			  XSPIPS_MASTER_OPTION |
			  XSPIPS_DECODE_SSELECT_OPTION |
			  XSPIPS_FORCE_SSELECT_OPTION |
			  ((desc->mode & SPI_CPOL) ?
			   XSPIPS_CLK_ACTIVE_LOW_OPTION : 0) |
			  ((desc->mode & SPI_CPHA) ?
			   XSPIPS_CLK_PHASE_1_OPTION : 0));

	XSpiPs_SetSlaveSelect(&desc->instance,
			      0xf & ~desc->chip_select);
	XSpiPs_PolledTransfer(&desc->instance,
			      data, data, bytes_number);
#else
	XSpi_SetOptions(&desc->instance,
			XSP_MASTER_OPTION |
			((desc->mode & SPI_CPOL) ?
			 XSP_CLK_ACTIVE_LOW_OPTION : 0) |
			((desc->mode & SPI_CPHA) ?
			 XSP_CLK_PHASE_1_OPTION : 0));

	XSpi_SetSlaveSelect(&desc->instance,
			    desc->chip_select);

	XSpi_Transfer(&desc->instance,
		      data, data, bytes_number);
#endif
	return 0;
}

/**
 * @brief Obtain the GPIO decriptor.
 * @param desc - The GPIO descriptor.
 * @param gpio_number - The number of the GPIO.
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t gpio_get(struct gpio_desc **desc,
		 uint8_t gpio_number)
{
	gpio_desc *descriptor;
	int32_t ret;

	descriptor = (struct gpio_desc *) malloc(sizeof(*descriptor));
	if (!descriptor)
		return FAILURE;

#ifdef _XPARAMETERS_PS_H_
	descriptor->config = XGpioPs_LookupConfig(0);
	if (descriptor->config == NULL)
		goto error;

	ret = XGpioPs_CfgInitialize(&descriptor->instance,
				    descriptor->config, descriptor->config->BaseAddr);
	if (ret != 0)
		goto error;
#else
	ret = XGpio_Initialize(&descriptor->instance, 0);
	if (ret != 0)
		goto error;
#endif

	descriptor->number = gpio_number;

	*desc = descriptor;

	return SUCCESS;

error:
	free(descriptor);

	return FAILURE;
}

/**
 * @brief Free the resources allocated by gpio_get().
 * @param desc - The SPI descriptor.
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t gpio_remove(struct gpio_desc *desc)
{
	if (desc) {
		// Unused variable - fix compiler warning
	}

	return SUCCESS;
}

/**
 * @brief Enable the input direction of the specified GPIO.
 * @param desc - The GPIO descriptor.
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t gpio_direction_input(struct gpio_desc *desc)
{
	if (desc) {
		// Unused variable - fix compiler warning
	}

	return 0;
}

/**
 * @brief Enable the output direction of the specified GPIO.
 * @param desc - The GPIO descriptor.
 * @param value - The value.
 *                Example: GPIO_HIGH
 *                         GPIO_LOW
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t gpio_direction_output(struct gpio_desc *desc,
			      uint8_t value)
{
#ifdef _XPARAMETERS_PS_H_
	XGpioPs_SetDirectionPin(&desc->instance, desc->number, 1);

	XGpioPs_SetOutputEnablePin(&desc->instance, desc->number, 1);

	XGpioPs_WritePin(&desc->instance, desc->number, value);
#else
	uint8_t pin = desc->number;
	uint8_t channel;
	uint32_t reg_val;

	if (pin >= 32) {
		channel = 2;
		pin -= 32;
	} else
		channel = 1;

	reg_val = XGpio_GetDataDirection(&desc->instance, channel);
	reg_val &= ~(1 << pin);
	XGpio_SetDataDirection(&desc->instance, channel, reg_val);

	reg_val = XGpio_DiscreteRead(&desc->instance, channel);
	if(value)
		reg_val |= (1 << pin);
	else
		reg_val &= ~(1 << pin);
	XGpio_DiscreteWrite(&desc->instance, channel, reg_val);
#endif

	return SUCCESS;
}

/**
 * @brief Get the direction of the specified GPIO.
 * @param desc - The GPIO descriptor.
 * @param direction - The direction.
 *                    Example: GPIO_OUT
 *                             GPIO_IN
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t gpio_get_direction(struct gpio_desc *desc,
			   uint8_t *direction)
{
	if (desc) {
		// Unused variable - fix compiler warning
	}

	if (direction) {
		// Unused variable - fix compiler warning
	}

	return 0;
}

/**
 * @brief Set the value of the specified GPIO.
 * @param desc - The GPIO descriptor.
 * @param value - The value.
 *                Example: GPIO_HIGH
 *                         GPIO_LOW
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t gpio_set_value(struct gpio_desc *desc,
		       uint8_t value)
{
#ifdef _XPARAMETERS_PS_H_
	XGpioPs_WritePin(&desc->instance, desc->number, value);
#else
	uint8_t pin = desc->number;
	uint8_t channel;
	uint32_t reg_val;

	if (pin >= 32) {
		channel = 2;
		pin -= 32;
	} else
		channel = 1;

	reg_val = XGpio_DiscreteRead(&desc->instance, channel);
	if(value)
		reg_val |= (1 << pin);
	else
		reg_val &= ~(1 << pin);
	XGpio_DiscreteWrite(&desc->instance, channel, reg_val);
#endif

	return 0;
}

/**
 * @brief Get the value of the specified GPIO.
 * @param desc - The GPIO descriptor.
 * @param value - The value.
 *                Example: GPIO_HIGH
 *                         GPIO_LOW
 * @return SUCCESS in case of success, FAILURE otherwise.
 */
int32_t gpio_get_value(struct gpio_desc *desc,
		       uint8_t *value)
{
	if (desc) {
		// Unused variable - fix compiler warning
	}

	if (value) {
		// Unused variable - fix compiler warning
	}

	return 0;
}

/**
 * @brief Generate microseconds delay.
 * @param usecs - Delay in microseconds.
 * @return None.
 */
void udelay(uint32_t usecs)
{
	usleep(usecs);
}

/**
 * @brief Generate miliseconds delay.
 * @param msecs - Delay in miliseconds.
 * @return None.
 */
void mdelay(uint32_t msecs)
{
#ifdef _XPARAMETERS_PS_H_
	usleep(msecs * 1000);
#else
	usleep_MB(msecs*1000);	// FIXME
#endif
}
