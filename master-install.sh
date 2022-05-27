#!/bin/bash

if [[ $USER != "root" ]]; then
	echo "Sorry, you must run as root"
	exit
fi


sudo apt update
sudo apt -y upgrade

sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo apt-get -y install containerd

sudo apt update
sudo apt install cri-o cri-o-runc -y

sudo systemctl daemon-reload
sudo systemctl enable crio --now

sudo systemctl enable kubelet

sudo kubeadm config images pull

sudo kubeadm init \
  --pod-network-cidr=10.10.0.0/16 --ignore-preflight-errors=NumCPU

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
