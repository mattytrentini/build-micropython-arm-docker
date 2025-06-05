FROM debian:bookworm-slim

RUN apt update && \
    apt install -y gcc-arm-none-eabi \
    build-essential \
    git \
    python3 \
    cmake \
    protobuf-c-compiler
