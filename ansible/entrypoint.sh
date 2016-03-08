#!/usr/bin/env bash


cat <<EOF > /etc/ansible/hosts
${SERVER_ID} ansible_ssh_host=${SERVER_IP} ansible_ssh_private_key_file='/keypair.pem' ansible_ssh_user='cloud' toolbox_address=${TOOLBOX_IP} openstack_id=${SERVER_ID} server_ip=${SERVER_IP}
EOF

bash -c "$*"
