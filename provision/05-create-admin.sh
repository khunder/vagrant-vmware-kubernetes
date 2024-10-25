export MASTER_IP=${1:-"192.168.30.10"}
export ADMIN_NAME=${2:-"zied"}
export CA_CERT_FILE_PATH=${3:-"C:/env/structure/output/pki"}

rm -rf /vagrant/output/pki/*

# Copy ca.key and ca.crt to oupt
sudo mkdir -p /vagrant/output/pki
cp /etc/kubernetes/pki/ca.crt /vagrant/output/pki/ca.crt



openssl genrsa -out /vagrant/output/pki/$ADMIN_NAME.key 2048
openssl req -new -key /vagrant/output/pki/$ADMIN_NAME.key -out /vagrant/output/pki/$ADMIN_NAME.csr -subj "/CN=$ADMIN_NAME/O=system:masters"
sudo openssl x509 -req -in /vagrant/output/pki/$ADMIN_NAME.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /vagrant/output/pki/$ADMIN_NAME.crt -days 365


echo "apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: $CA_CERT_FILE_PATH/ca.crt  # Path to Kubernetes CA certificate
    server: https://$MASTER_IP:6443        # API server address
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: $ADMIN_NAME
  name: $ADMIN_NAME-context
current-context: $ADMIN_NAME-context
users:
- name: $ADMIN_NAME
  user:
    client-certificate: $CA_CERT_FILE_PATH/$ADMIN_NAME.crt
    client-key: $CA_CERT_FILE_PATH/$ADMIN_NAME.key" > /vagrant/output/hostkubeConfig.yaml


echo "--------------------------------------------------------------------------------"
echo " Kubeconfig for admin $ADMIN_NAME was generated at: $CA_CERT_FILE_PATH/.."
echo "--------------------------------------------------------------------------------"

ip_address=$(ip -4 addr show dev eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

echo "use this command as admin, if you are using vmware desktop, to be able to route traffic from your windows machine to cluster gateway"
echo "route -p add 192.168.30.0 Mask 255.255.255.0 ${ip_address}"
echo "to delete the route execute, route delete 192.168.30.0 "

echo "route -p add 192.168.30.0 Mask 255.255.255.0 ${ip_address}"> /vagrant/output/route_command.bat
echo "route delete 192.168.30.0"> /vagrant/output/del_route_command.bat

echo "--- Install Master Node Completed ---"