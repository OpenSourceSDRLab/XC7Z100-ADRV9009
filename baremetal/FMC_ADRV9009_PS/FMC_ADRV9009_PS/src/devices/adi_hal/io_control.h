/*
 * io_control.h
 *
 * Copyright (c) OpenSourceSDRLab
 * https://www.opensourcesdrlab.com
 */
#include "xil_io.h"
#ifndef SRC_IO_CONTROL_H_
#define SRC_IO_CONTROL_H_
#define AXI_REG_WRITE(BaseAddress, RegOffset, Data) \
	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define AXI_REG_READ(BaseAddress, RegOffset) \
	Xil_In32((BaseAddress) + (RegOffset))

#endif /* SRC_IO_CONTROL_H_ */
