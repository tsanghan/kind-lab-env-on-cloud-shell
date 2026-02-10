#!/usr/bin/env bash

mkdir -p ~/.kube
mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/Projects/kind

curl -SL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o ~/.local/bin/kubectl
chmod +x ~/.local/bin/kubectl

cp ./eget.toml ~/.config
./eget.sh

source ~/.profile

echo "export PATH=$HOME/.local/bin:$PATH" >> ~/.bashrc

eget -D

tar -C ./projects-kind --exclude="kind.yaml" -cvf - . | tar -C ~/Projects/kind -xvf -

tar -C ./local-bin --exclude="cert-manager.sh" -cvf - . | tar -C ~/.local/bin -xvf -

tar -C ./dot-kube -cvf - . | tar -C ~/.kube -xvf -

ln -s ~/.local/bin/kubectl ~/.local/bin/k

sudo apt install nfs-kernel-server -y

echo "/srv 10.254.254.0/24(rw,async,no_subtree_check,no_root_squash)" | sudo tee /etc/exports

sudo exportfs -a

cat ./version.rc >> ~/.bashrc

cat ./projects-kind/bashrc >> ~/.bashrc

source ./version.rc

envsubst '$DH_NAMESPACE:$KINDEST_NODE_VER' < projects-kind/kind.yaml | tee ~/Projects/kind/kind-$(echo ${KINDEST_NODE_VER%@sha*}).yaml
envsubst '$CERT_MANAGER_VER' < ./local-bin/cert-manager.sh > ~/.local/bin/cert-manager.sh
chmod +x ~/.local/bin/cert-manager.sh

docker-network-kind.sh