FROM debian:bookworm-slim

RUN apt update && \
    apt install -y gcc-arm-none-eabi \
    build-essential \
    git \
    python3 \
    cmake \
    protobuf-c-compiler \
    python3-pyelftools \
    python3-usb \
    python3-pip
    # python3-pip is necessary for pyhy

# Unfortunately, "--break-system-packages" is required to install a package
# system-wide. The recommended way to avoid this is to create and activate a
# venv but that seems redundant for a container where we're managing the
# environment. 
RUN pip install --break-system-packages \
    pyhy \
    ar
