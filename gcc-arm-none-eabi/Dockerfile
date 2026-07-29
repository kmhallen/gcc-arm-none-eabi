FROM ubuntu:noble

# Install build tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    wget \
    coreutils \
    tar \
    bzip2 \
    xz-utils \
    make \
    cmake \
 && rm -rf /var/lib/apt/lists/*

RUN cd /opt/ \
 && wget -q "https://gitlab.arm.com/api/v4/projects/tooling%2Fgnu-toolchains-for-arm/packages/generic/gnu-toolchain/15.3.rel1/arm-gnu-toolchain-15.3.rel1-x86_64-arm-none-eabi.tar.xz" \
 && echo "563bebb2b97d53382b956d6ee1fe61e2cae26699901417234a37df505ef9b5fa arm-gnu-toolchain-15.3.rel1-x86_64-arm-none-eabi.tar.xz" > arm-gnu-toolchain-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && sha256sum --check arm-gnu-toolchain-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && rm arm-gnu-toolchain-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && tar -xf arm-gnu-toolchain-15.3.rel1-x86_64-arm-none-eabi.tar.xz \
 && rm arm-gnu-toolchain-15.3.rel1-x86_64-arm-none-eabi.tar.xz

ENV PATH="/opt/arm-gnu-toolchain-15.3.rel1-x86_64-arm-none-eabi/bin:$PATH"
