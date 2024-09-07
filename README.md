# Dockerfile containing arm and riscv compiler

This page documents Dockerfile: `Dockerfile.arm-rp2riscv`.  
It is based on [build-riscv-gcc.sh](https://github.com/raspberrypi/pico-sdk-tools/blob/main/packages/linux/riscv/build-riscv-gcc.sh).

Versions
* Branch `2024.09.03` of https://github.com/riscv/riscv-gnu-toolchain.
* GCC is from branch `releases/gcc-14`.

These are the binaries

```bash
$ pico_riscv_gcc --version
pico_riscv_gcc (g1e79541be) 14.2.1 20240907

$ arm-none-eabi-gcc --version
arm-none-eabi-gcc (15:12.2.rel1-1) 12.2.1 20221205
```

## Build container

```bash
docker buildx build -f Dockerfile.arm-rp2riscv --tag build-micropython-arm-rp2riscv .
docker run -it --rm build-micropython-arm-rp2riscv
```

*Takes about 90min to build (old i7)!*

Image size
```
docker images
REPOSITORY                          TAG        IMAGE ID       CREATED         SIZE
build-micropython-arm-rp2riscv      latest     98da6ca16083   5.19GB
micropython/build-micropython-arm   bookworm   2be19442e8f5   3.11GB
micropython/build-micropython-arm   bullseye   5a864f140f87   2.14GB
micropython/build-micropython-arm   latest     5a864f140f87   2.14GB
```

The riscv toolchain in /opt/riscv is about 2GB.  
The interims multi-stage build image is about 22GB!

## Builds supported

Tested on: https://github.com/dpgeorge/micropython/tree/rp2-add-rp2350

As before

```bash
mpbuild build RPI_PICO --build-container build-micropython-arm-rp2riscv
mpbuild build RPI_PICO2 --build-container build-micropython-arm-rp2riscv
# and many others with arm processor
```

New: Pico 2 RiscV

```bash
mpbuild build RPI_PICO2 RISCV --build-container build-micropython-arm-rp2riscv
```


I tested this container with
* Port Board Variant
* rp2 RPI_PICO 
* rp2 RPI_PICO2 
* rp2 RPI_PICO2 RISCV 
* stm32 PYBV11 
* stm32 PYBV11 DP 
* stm32 PYBV11 DP_THREAD 
* stm32 PYBV11 NETWORK 
* stm32 PYBV11 THREAD 