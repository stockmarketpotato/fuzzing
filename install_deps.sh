#!/bin/bash

# Clone repositories if they don't exist
if [ ! -d "sharpfuzz" ]; then git clone https://github.com/Metalnem/sharpfuzz.git; else echo "sharpfuzz repository already cloned"; fi
if [ ! -d "sharpfuzz-samples" ]; then git clone https://github.com/Metalnem/sharpfuzz-samples.git; else echo "sharpfuzz-samples repository already cloned"; fi
if [ ! -d "libfuzzer-dotnet" ]; then git clone https://github.com/Metalnem/libfuzzer-dotnet; else echo "libfuzzer-dotnet repository already cloned"; fi

# Install dependencies if not already installed
if ! dpkg -s packages-microsoft-prod >/dev/null 2>&1; then
    wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
fi

if ! dpkg -s powershell clang cmake >/dev/null 2>&1; then
	sudo apt update
	sudo apt install powershell clang cmake -y
fi

# Install dotnet
if [ ! -f "./dotnet-install.sh" ]; then
    wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
    chmod +x ./dotnet-install.sh
fi

./dotnet-install.sh --channel 8.0
./dotnet-install.sh --channel 9.0

# Ensure environment variables are set
if ! grep -q 'export DOTNET_ROOT' ~/.bashrc; then
    echo 'export PATH=$PATH:$HOME/.dotnet/tools' >> ~/.bashrc
    echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
    echo 'export PATH=$PATH:$DOTNET_ROOT' >> ~/.bashrc
    export PATH=$PATH:$HOME/.dotnet/tools
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH=$PATH:$DOTNET_ROOT
fi

# Install SharpFuzz and AFL
if [ ! -f "/usr/local/bin/afl-fuzz" ]; then
    sharpfuzz/scripts/install.sh
fi

# Install SharpFuzz.CommandLine global .NET tool
if [ ! -f "$HOME/.dotnet/tools/sharpfuzz" ]; then
	dotnet tool install --global SharpFuzz.CommandLine
fi

# Build libfuzzer
if [ ! -f "/usr/local/bin/libfuzzer-dotnet" ]; then
    sudo clang -fsanitize=fuzzer,address libfuzzer-dotnet/libfuzzer-dotnet.cc -o /usr/local/bin/libfuzzer-dotnet
fi

# Set core dump pattern if not already set
if [ "$(sysctl -n kernel.core_pattern)" != "core" ]; then
    sudo sysctl -w kernel.core_pattern=core
fi
