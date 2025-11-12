{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "xanmod-kernel-build";

  # Build dependencies for kernel compilation
  buildInputs = with pkgs; [
    # Core compilers and toolchain
    clang
    llvmPackages.bintools
    gcc

    # Build tools
    gnumake
    flex
    bison
    bc
    perl

    # Libraries and utilities
    elfutils
    openssl
    libelf
    ncurses

    # Additional utilities
    git
    python3
    rsync
    cpio
    gzip
    xz
    zstd

    # Optional: For debugging and analysis
    pahole
    dwarves

    # Add ccache for faster rebuilds (optional)
    ccache
  ];

  # Environment variables
  shellHook = ''
    echo "XANMOD WSL KERNEL BUILD SHELL"
    echo "Available tools:"
    echo "  - clang: $(clang --version | head -1)"
    echo "  - gcc: $(gcc --version | head -1)"
    echo "  - make: $(make --version | head -1)"
    echo "  - flex: $(flex --version)"
    echo "  - bison: $(bison --version)"
    echo ""
    echo "To build the kernel:"
    echo "  ./build.sh -b MAIN              # Uses GCC (recommended for NixOS)"
    echo "  ./build.sh -b MAIN -j $(nproc)  # Use all CPU cores"
    echo ""
    echo "If GCC fails, you can try clang:"
    echo "  sed -i 's/gcc/clang/' build.sh && ./build.sh -b MAIN"
  '';
}