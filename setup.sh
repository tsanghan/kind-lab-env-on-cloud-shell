#!/usr/bin/env bash

MAX_RETRIES=5
attempt=0
URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
OUTPUT="~/.local/bin/kubectl"
#curl -SL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o ~/.local/bin/kubectl

mkdir -p ~/.kube
mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/Projects/kind

while (( attempt < MAX_RETRIES )); do
    ((attempt++))
    echo "Attempt $attempt of $MAX_RETRIES..."

    # -f: fail silently on HTTP errors
    # -L: follow redirects
    # -o: write output to file
    curl -fL "$URL" -o "$OUTPUT"
    status=$?

    if [[ $status -eq 0 ]]; then
        echo "Download succeeded."
        break
    else
        echo "`\kubectl\` download failed (curl exit code $status)."
        # optional: wait before retrying
        sleep 2
    fi
done

if [[ $status -ne 0 ]]; then
    echo "Error: \`kubectl\` download failed after $MAX_RETRIES attempts."
    exit 1
fi

chmod +x ~/.local/bin/kubectl

curl -SL https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64 -o ~/.local/bin/minikube
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