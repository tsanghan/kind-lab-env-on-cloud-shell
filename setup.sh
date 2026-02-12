#!/usr/bin/env bash

MAX_RETRIES=5

download_file() {
    local url="$1"
    local output="$2"
    local max_retries="${3:-5}"
    local attempt=0
    local status=0

    while (( attempt < max_retries )); do
        ((attempt++))
        echo "Attempt $attempt of $max_retries..."

        curl -fL "$url" -o "$output"
        status=$?

        if (( status == 0 )); then
            echo "Download succeeded."
            return 0
        else
            echo "Download failed (curl exit code $status)."
            sleep 2   # optional pause before next try
        fi
    done

    echo "Error: file download failed after $max_retries attempts."
    return 1
}

mkdir -p ~/.kube
mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/Projects/kind

URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
OUTPUT="$HOME/.local/bin/kubectl"
download_file $URL $OUTPUT

chmod +x ~/.local/bin/kubectl

URL="https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64"
OUTPUT="$HOME/.local/bin/minikube"
download_file $URL $OUTPUT

chmod +x ~/.local/bin/minikube

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

cat ./versions.rc >> ~/.bashrc

cat ./projects-kind/bashrc >> ~/.bashrc

source ./versions.rc

envsubst '$DH_NAMESPACE:$KINDEST_NODE_VER' < projects-kind/kind.yaml | tee ~/Projects/kind/kind-$(echo ${KINDEST_NODE_VER%@sha*}).yaml
envsubst '$CERT_MANAGER_VER' < ./local-bin/cert-manager.sh > ~/.local/bin/cert-manager.sh
chmod +x ~/.local/bin/cert-manager.sh

docker-network-kind.sh