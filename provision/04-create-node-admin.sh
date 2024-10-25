export MASTER_IP=${1:-"192.168.30.10"}
export ADMIN_NAME=${2:-"zied"}


mkdir -p  ~/.kube

cp /vagrant/output/pki/$ADMIN_NAME.key ~/$ADMIN_NAME.key
cp /vagrant/output/pki/$ADMIN_NAME.crt ~/$ADMIN_NAME.crt

echo "apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt  # Path to Kubernetes CA certificate
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
    client-certificate: $HOME/$ADMIN_NAME.crt
    client-key: $HOME/$ADMIN_NAME.key" > ~/.kube/config




echo "--- Install Node Completed ---"