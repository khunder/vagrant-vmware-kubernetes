# -*- mode: ruby -*-
# vi: set ft=ruby :


ENV['VAGRANT_NO_PARALLEL'] = 'yes'

# NUM_NODES=1
NUM_NODES = ENV['NUM_NODES'] || 2
RUNTIME = ENV['RUNTIME'] || "containerd"
K8S_VERSION = ENV['K8S_VERSION'] || "1.30"

Vagrant.configure("2") do |config|
 
  K8S_VERSION = "1.30"
  MASTER_IP = "192.168.30.10"
  POD_IP_RANGE = "10.244.0.0/16"
  ADMIN_NAME = "zied"

  config.vm.define "controlplane" do |controlPlane|
    controlPlane.vm.box = "controlplane"
    controlPlane.vm.box = "gutehall/ubuntu24-10"
    controlPlane.vm.box_version = "2024.10.11"
    controlPlane.vm.hostname = "controlplane"
    controlPlane.vm.network "private_network", ip: "192.168.30.10" # make sure this ip is available on the host machine
    controlPlane.vm.box_check_update = false

    config.vm.synced_folder ".", "/vagrant"
    
    # Pass K8S_VERSION as an environment variable to the provisioning script

    caCertFolder = File.dirname(__FILE__) +"/output/pki"

    controlPlane.vm.provision "shell", path: "provision/01-setup-prerequisites.sh"
    
    controlPlane.vm.provision "shell", path: "provision/02-dwonload-k8s-binaries.sh",  env: { "K8S_VERSION" => K8S_VERSION }, args:  [K8S_VERSION]
    
    controlPlane.vm.provision "shell", path: "provision/03-setup-containerd.sh",  env: { "K8S_VERSION" => K8S_VERSION }, args:  K8S_VERSION
    
    controlPlane.vm.provision "shell", path: "provision/04-bootstrap-cluster.sh",  env: { "K8S_VERSION" => K8S_VERSION }, args:  [MASTER_IP, POD_IP_RANGE]
    
    controlPlane.vm.provision "shell", path: "provision/05-create-admin.sh", args:  [MASTER_IP, ADMIN_NAME, caCertFolder]
  end

  (1..NUM_NODES.to_i).each do |node_number|

    node_name = "k8snode#{node_number}"
    config.vm.define node_name do |node|

      counter = 10 + node_number 
      node_ip = "192.168.30.#{counter}"

      node.vm.box = "node"
      node.vm.box = "gutehall/ubuntu24-10"
      node.vm.box_version = "2024.10.11"
      node.vm.hostname = node_name
      node.vm.network "private_network", ip: node_ip
      node.vm.box_check_update = false

      node.vm.provision "shell", path: "provision/01-setup-prerequisites.sh"
      node.vm.provision "shell", path: "provision/02-dwonload-k8s-binaries.sh",  env: { "K8S_VERSION" => K8S_VERSION }, args:  [K8S_VERSION]
      node.vm.provision "shell", path: "provision/03-setup-containerd.sh",  env: { "K8S_VERSION" => K8S_VERSION }, args:  K8S_VERSION
      node.vm.provision "shell", path: "provision/04-create-node-admin.sh",  env: { "K8S_VERSION" => K8S_VERSION }, args:  [MASTER_IP, ADMIN_NAME]
      # node.vm.provision "shell", path: "output/joincluster.sh"

      node.vm.provision "shell", inline: <<-SHELL
        if [ -f /vagrant/output/joincluster.sh ]; then
          /vagrant/output/joincluster.sh
        else
          echo "joincluster.sh not found!"
        fi
      SHELL


    end

  end

end
