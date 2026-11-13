# Talise firmware headers (not included)

The bare-metal application needs two firmware headers from Analog Devices:

| File | Contents |
|---|---|
| `talise_arm_binary.h` | ADRV9009 ARM processor firmware, version 6.0.2 |
| `talise_stream_binary.h` | ADRV9009 stream processor image |

They are released by Analog Devices under the *AD937X Software License Agreement (20180301-AD937X-CTSLA)*, which allows them to be distributed only as object code inside a product. They are therefore not stored in this repository. Download them from Analog Devices and place them in this folder before building.

**Use the same version this design was tested with** (Talise API 3.6.0.5, ARM firmware 6.0.2). It is on the `2021_R1` release branch of Analog Devices' no-OS repository:

- <https://github.com/analogdevicesinc/no-OS/blob/2021_R1/drivers/rf-transceiver/talise/firmware/talise_arm_binary.h>
- <https://github.com/analogdevicesinc/no-OS/blob/2021_R1/drivers/rf-transceiver/talise/firmware/talise_stream_binary.h>

```sh
curl -LO https://raw.githubusercontent.com/analogdevicesinc/no-OS/2021_R1/drivers/rf-transceiver/talise/firmware/talise_arm_binary.h
curl -LO https://raw.githubusercontent.com/analogdevicesinc/no-OS/2021_R1/drivers/rf-transceiver/talise/firmware/talise_stream_binary.h
```

Check the downloads (they must match exactly):

```
3b6088873537f341db1aa3fd4e36776314c2d1cb236f72b2c087d6d435bbc19f  talise_arm_binary.h
0d07da0470b4d72861aea4bb753c789a6a39be6f99fca637fc565a05ca1df5fa  talise_stream_binary.h
```

Newer firmware versions (for example 6.2.1 on later branches) need a matching newer Talise API and have not been tested with this design.

The prebuilt application `.elf` in the Releases already contains this firmware in object-code form.
