#!/bin/bash


export MASTER_IP=${1:-"192.168.30.10"}
export POD_IP_RANGE=${2:-"10.244.0.0/16"}


#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown -R $(id -u):$(id -g) $HOME/.kube/



# Bootstrap Cluster

# sudo kubeadm init --apiserver-advertise-address 192.168.30.10 --pod-network-cidr=10.244.0.0/16 --cri-socket unix:///run/containerd/containerd.sock
sudo kubeadm init --apiserver-advertise-address $MASTER_IP --pod-network-cidr=$POD_IP_RANGE --cri-socket unix:///run/containerd/containerd.sock && \
mkdir -p $HOME/.kube && \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Install Flannel CNI
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

rm -rf /vagrant/output/joincluster.sh
# Generate join cluster command
kubeadm token create --print-join-command > /vagrant/output/joincluster.sh
