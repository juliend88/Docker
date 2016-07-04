#!/usr/bin/env bash


cat <<EOF > /etc/ansible/hosts
[servers]
${SERVER_ID}
[servers:vars]
ansible_ssh_host=${SERVER_IP}
ansible_ssh_private_key_file='/keypair.pem'
ansible_ssh_user=${SERVER_USER}
toolbox_address=${TOOLBOX_IP}
openstack_id=${SERVER_ID}
server_ip=${SERVER_IP}
EOF

bash -c "$*"
