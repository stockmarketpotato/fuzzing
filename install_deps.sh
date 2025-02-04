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
# echo "export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1" >> ~/.bashrc

# --------------------------------------------------------- #
# Install SharpFuzz
# --------------------------------------------------------- #
sharpfuzz/scripts/install.sh
# #/bin/sh
# set -eux

# # Download and extract the latest afl-fuzz source package
# wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
# tar -xvf afl-latest.tgz

# rm afl-latest.tgz
# cd afl-2.52b/

# # Install afl-fuzz
# sudo make install
# cd ..
# rm -rf afl-2.52b/

# # Install SharpFuzz.CommandLine global .NET tool
# dotnet tool install --global SharpFuzz.CommandLine

# --------------------------------------------------------- #
# Build libfuzzer
# --------------------------------------------------------- #
clang -fsanitize=fuzzer,address libfuzzer-dotnet/libfuzzer-dotnet.cc -o /usr/local/bin/libfuzzer-dotnet

# --------------------------------------------------------- #
# set core dump pattern to defaul "core"
# --------------------------------------------------------- #
sudo sysctl -w kernel.core_pattern=core