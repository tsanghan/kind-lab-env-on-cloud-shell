#!/usr/bin/env bash

curl -SL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o ~/.local/bin/kubectl
chmod +x ~/.local/bin/kubectl
mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/Projects/kind

cp ./eget.toml ~/.config
./eget.sh

eget -D
eget -r ~/.local/bin/LICENSE

tar -C ./projeccts-kind -cvf - . | tar -C ~/Projects/kind -xvf -

tar -C ./local-bin -cvf - . | tar -C ~/.local/bin -xvf -

ln -s ~/.local/bin/kubectl ~/.local/bin/k

sudo apt install nfs-kernel-server

cat ./version.rc >> ~/.bashrc

