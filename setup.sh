#!/usr/bin/env bash

mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/Projects/kind

curl -SL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o ~/.local/bin/kubectl
chmod +x ~/.local/bin/kubectl

cp ./eget.toml ~/.config
./eget.sh

source ~/.profile

eget -D

tar -C ./projects-kind --exclude="kind.yaml" -cvf - . | tar -C ~/Projects/kind -xvf -

tar -C ./local-bin -cvf - . | tar -C ~/.local/bin -xvf -

ln -s ~/.local/bin/kubectl ~/.local/bin/k

sudo apt install nfs-kernel-server -y

cat ./version.rc >> ~/.bashrc

source ~/.bashrc

echo "DH_NAMESPACE=$DH_NAMESPACE"

echo "KINDEST_NODE_VER:$KINDEST_NODE_VER"

envsubst '$DH_NAMESPACE:$KINDEST_NODE_VER' < projects-kind/kind.yaml | tee ~/Projects/kind/kind-$(echo ${KINDEST_NODE_VER%@sha*})