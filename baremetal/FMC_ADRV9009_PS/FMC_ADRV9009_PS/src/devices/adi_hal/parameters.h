/***************************************************************************//**
 *   @file   parameters.c
 *   @brief  Platform dependent parameters.
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
#ifndef _PARAMETERS_H_
#define _PARAMETERS_H_

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include "platform_drivers.h"
#ifdef ALTERA_PLATFORM
#include "system.h"
#else
#include "xparameters.h"
#endif

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/
#ifdef _XPARAMETERS_PS_H_
#ifdef XPS_BOARD_ZCU102
//#define GPIO_OFFSET				78

#define GPIO_DEVICE_ID			XPAR_PSU_GPIO_0_DEVICE_ID
#define SPI_DEVICE_ID			XPAR_PSU_SPI_0_DEVICE_ID
#else
//#define GPIO_OFFSET				54

#define GPIO_DEVICE_ID			XPAR_PS7_GPIO_0_DEVICE_ID
#define SPI_DEVICE_ID			XPAR_PS7_SPI_0_DEVICE_ID
#endif
#else
//#define GPIO_OFFSET				0

#define GPIO_DEVICE_ID			XPAR_GPIO_0_DEVICE_ID
#define SPI_DEVICE_ID			XPAR_SPI_0_DEVICE_ID
#define IIC_DEVICE_ID			XPAR_MB_AXI_IIC_0_DEVICE_ID
#endif

#define GPIO_OFFSET				54

#define   ad9528_reset_b         GPIO_OFFSET + 8
#define   ad9528_sysref_req      GPIO_OFFSET + 7
#define   adrv9009_tx1_enable    GPIO_OFFSET + 6
#define   adrv9009_tx2_enable    GPIO_OFFSET + 5
#define   adrv9009_rx1_enable    GPIO_OFFSET + 4
#define   adrv9009_rx2_enable    GPIO_OFFSET + 3
#define   adrv9009_test          GPIO_OFFSET + 2
#define   adrv9009_reset_b       GPIO_OFFSET + 1
#define   adrv9009_gpint         GPIO_OFFSET + 0


#define ADRV_CS			  2
#endif
