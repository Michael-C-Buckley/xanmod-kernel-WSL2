FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    llvm \
    lld \
    gcc \
    g++ \
    make \
    flex \
    bison \
    bc \
    libelf-dev \
    libssl-dev \
    libncurses-dev \
    python3 \
    python3-dev \
    git \
    curl \
    wget \
    cpio \
    gzip \
    xz-utils \
    zstd \
    rsync \
    pahole \
    dwarves \
    ccache \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy build scripts and config
COPY . /workspace/

# Make scripts executable
RUN chmod +x setup.sh build.sh apply-patches.py

# Create a build script that runs the full process
RUN echo '#!/bin/bash\n\
echo "Starting Xanmod Kernel Build in Docker"\n\
echo "Setting up kernel source..."\n\
./setup.sh --branch MAIN\n\
echo "Building kernel..."\n\
cd linux\n\
make CC="ccache gcc" -j$(nproc)\n\
echo "Build complete! Kernel image: arch/x86/boot/bzImage"' > /workspace/docker-build.sh

RUN chmod +x /workspace/docker-build.sh

# Default command
CMD ["/workspace/docker-build.sh"]