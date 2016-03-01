#!/usr/bin/env bash

cat <<EOF > /etc/ansible/openstack.yml
clouds:
  cloudwatt:
    auth:
      auth_url: $OS_AUTH_URL
      username: $OS_USERNAME
      password: $OS_PASSWORD
      project_name: $OS_PROJECT_NAME
ansible:
  use_hostnames: True
  expand_hostvars: False
EOF

bash -c "$*"
