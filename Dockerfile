# Multi-stage build for MicroPython ARM with selectable GCC version

############################
# Stage 1: Fetch toolchain #
############################
FROM debian:bookworm-slim AS toolchain

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

ARG ARM_GNU_VER=14.3.rel1
ARG TRIPLE=arm-none-eabi
ARG TOOLCHAIN=arm-gnu-toolchain-${ARM_GNU_VER}-x86_64-${TRIPLE}
ARG BASE_URL=https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_GNU_VER}/binrel

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN set -e; \
    FILE=${TOOLCHAIN}.tar.xz; \
    URL=${BASE_URL}/${FILE}; \
    echo "Downloading toolchain: ${URL}"; \
    wget -nv -O /tmp/${FILE} "${URL}" || { echo "ERROR: Download failed (possibly bad ARM_GNU_VER)"; exit 1; }; \
    mkdir -p /opt; \
    tar -C /opt -xf /tmp/${FILE}; \
    rm -f /tmp/${FILE} /tmp/${FILE}.sha256 || true

RUN /opt/${TOOLCHAIN}/bin/arm-none-eabi-gcc --version

###################################
# Stage 2: Final build environment #
###################################
FROM debian:bookworm-slim

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

ARG ARM_GNU_VER=14.3.rel1
ARG TRIPLE=arm-none-eabi
ARG TOOLCHAIN=arm-gnu-toolchain-${ARM_GNU_VER}-x86_64-${TRIPLE}

ENV PATH=/opt/${TOOLCHAIN}/bin:$PATH \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        python3 \
        python3-venv \
        python3-pip \
        # python3-pip is necessary for pyhy
        python3-dev \
        # python3-dev is required to build pyhy (for pyconfig.h)
        python3-pyelftools \
        python3-usb \
        cmake \
        protobuf-c-compiler \
    && rm -rf /var/lib/apt/lists/*

COPY --from=toolchain /opt/${TOOLCHAIN} /opt/${TOOLCHAIN}

RUN arm-none-eabi-gcc --version

# Unfortunately, "--break-system-packages" is required to install a package
# system-wide. The recommended way to avoid this is to create and activate a
# venv but that seems redundant for a container where we're managing the
# environment. 
RUN pip install --break-system-packages \
    pyhy \
    ar
