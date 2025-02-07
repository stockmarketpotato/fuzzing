#! /bin/bash
git clone https://github.com/Metalnem/sharpfuzz.git
git clone https://github.com/Metalnem/sharpfuzz-samples.git
git clone https://github.com/Metalnem/libfuzzer-dotnet

# --------------------------------------------------------- #
# Install dependencies
# --------------------------------------------------------- #
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install powershell clang cmake -y

# --------------------------------------------------------- #
# Install cmake
# --------------------------------------------------------- #
sudo apt install cmake -y

# --------------------------------------------------------- #
# Install dotnet
# --------------------------------------------------------- #
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 8.0
./dotnet-install.sh --channel 9.0
rm dotnet-install.sh
echo 'export PATH=$PATH:$HOME/.dotnet/tools' >> ~/.bashrc
echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$DOTNET_ROOT' >> ~/.bashrc
export PATH=$PATH:$HOME/.dotnet/tools
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT

# --------------------------------------------------------- #
# Install SharpFuzz
# --------------------------------------------------------- #
sharpfuzz/scripts/install.sh

# --------------------------------------------------------- #
# Build libfuzzer
# --------------------------------------------------------- #
sudo clang -fsanitize=fuzzer,address libfuzzer-dotnet/libfuzzer-dotnet.cc -o /usr/local/bin/libfuzzer-dotnet

# --------------------------------------------------------- #
# set core dump pattern to defaul "core"
# --------------------------------------------------------- #
sudo sysctl -w kernel.core_pattern=core