FROM debian:bookworm-slim

RUN apt update && \
    apt install -y \
        gcc-arm-none-eabi \
        build-essential \
        git \
        cmake \
        python3-usb
