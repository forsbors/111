#!/bin/bash

SEED="opinion crew top define chief cushion salon dog planet pluck term mother world close rely mirror craft timber lake night grab bottom debate course" # Сид от вашего майнинг кошелька
TONAPI_TOKEN="AGIZJUQXYLQU4CQAAAABXWURPSYEI3QBHN4HSG45JQ3NEQIRUFFTUT4ADA6GICXPSF2UZBY" # Токен для доступа к TON API
GPU_COUNT=12 # Количество используемых GPU

apt update -y
apt install screen -y
apt install git -y
apt install curl -y
cd /home/user/
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.bashrc
chmod +x /home/user/.nvm/nvm.sh
source /home/user/.nvm/nvm.sh
nvm install 16
git clone https://github.com/TrueCarry/JettonGramGpuMiner.git
cd /home/user/JettonGramGpuMiner/
wget https://github.com/tontechio/pow-miner-gpu/releases/download/20211230.1/minertools-cuda-ubuntu-18.04-x86-64.tar.gz
tar -xvf minertools-cuda-ubuntu-18.04-x86-64.tar.gz
echo "SEED=$SEED" > config.txt
echo "TONAPI_TOKEN=$TONAPI_TOKEN" >> config.txt

cat <<EOF > /home/user/JettonGramGpuMiner/mine.sh
#!/bin/bash

npm install

while true; do
  node send_multigpu.js --api tonapi --bin ./pow-miner-cuda --givers 1000 --gpu-count $GPU_COUNT
  sleep 1;
done;
EOF

chmod +x /home/user/JettonGramGpuMiner/mine.sh
screen -dmS mining /home/user/JettonGramGpuMiner/mine.sh