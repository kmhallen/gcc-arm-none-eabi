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
 && wget -q "https://developer.arm.com/-/media/Files/downloads/gnu/15.2.rel1/binrel/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz" \
 && echo "597893282ac8c6ab1a4073977f2362990184599643b4c5ee34870a8215783a16 arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz" > arm-gnu-toolchain-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && sha256sum --check arm-gnu-toolchain-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && rm arm-gnu-toolchain-x86_64-arm-none-eabi.tar.xz.sha256asc \
 && tar -xf arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz \
 && rm arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz

ENV PATH="/opt/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi/bin:$PATH"
