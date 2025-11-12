#!/bin/bash

echo "🐳 Building Xanmod Kernel with Docker"
echo "===================================="

# Build the Docker image
echo "Building Docker image..."
docker build -t xanmod-kernel-builder .

# Create result directory if it doesn't exist
mkdir -p result

# Run the build
echo "Running kernel build..."
docker run --rm \
  -v "$(pwd)/result:/workspace/result" \
  -v "$(pwd)/linux:/workspace/linux" \
  xanmod-kernel-builder

# Check if build succeeded
if [ -f "linux/arch/x86/boot/bzImage" ]; then
    echo "✅ Build successful!"
    echo "📁 Kernel image: linux/arch/x86/boot/bzImage"
    echo "📦 Copying to result directory..."
    cp linux/arch/x86/boot/bzImage result/
    cp linux/.config result/config
    echo "📋 Build artifacts in ./result/"
else
    echo "❌ Build failed!"
    exit 1
fi