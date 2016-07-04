#!/bin/bash
docker build -t cloudwattfr/ansible-playbooks:$1 .
docker push cloudwattfr/ansible-playbooks:$1
