FROM ubuntu:jammy

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
 && wget -q "https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz" \
 && echo "12a2815644318ebcceaf84beabb665d0924b6e79e21048452c5331a56332b309 arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz" > arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && sha256sum --check arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && tar -xf arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz \
 && rm arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && rm arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz

ENV PATH="/opt/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi/bin:$PATH"
