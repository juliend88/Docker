#!/bin/bash
for i in {2..2}; do
  heat stack-create -f toolbox.heat.yml -P keypair_name=$1 -P os_username=$OS_USERNAME -P os_password=$OS_PASSWORD -P os_tenant=$OS_TENANT_NAME -P os_auth=$OS_AUTH_URL stack-mcm-$i
  echo "Stack stack-mcm-$i created"
  end=$((SECONDS+180))
  echo -n "Waiting for stack to be created..."
  until heat output-show stack-mcm-$i public_ip
  do
    if [ $SECONDS -gt $end ]; then
      echo "Stack creation timeout"
      heat stack-delete -y stack-mcm-$i
      exit -1
    fi
    echo -n "."
    sleep 10
  done
  echo ""
  STACK_IP=$(heat output-show stack-mcm-$i public_ip | sed s/\"//g)
  STACK_USERNAME=$(heat output-show stack-mcm-$i vpn_username | sed s/\"//g)
  STACK_PASSWORD=$(heat output-show stack-mcm-$i vpn_password | sed s/\"//g)
  echo "Stack: stack-mcm-$i"
  echo "IP: $STACK_IP"
  echo "Username: $STACK_USERNAME"
  echo "Password: $STACK_PASSWORD"
  end=$((SECONDS+300))
  echo -n "Waiting for VPN..."
  until nc -vz $STACK_IP 1723
  do
    if [ $SECONDS -gt $end ]; then
      echo "Timeout waiting for VPN"
      heat stack-delete -y stack-mcm-$i
      exit -1
    fi
    echo -n "."
    sleep 10
  done
  echo ""
  echo "VPN online, testing kubernetes"
  end=$((SECONDS+300))
  echo -n "Waiting for Kubernetes to be healthy..."
  until [[ "$(ssh -o StrictHostKeyChecking=no -i /Users/cedric/.ssh/$1.pem core@$STACK_IP -C 'curl http://10.0.1.254:8080/healthz')" == "ok" ]]
  do
    if [ $SECONDS -gt $end ]; then
      echo "Timeout waiting for Kubernetes"
      heat stack-delete -y stack-mcm-$i
      exit -1
    fi
    echo -n "."
    sleep 10
  done
  echo ""
  echo "Kubernetes healthy"
  echo "Waiting toolbox to be available"
  end=$((SECONDS+300))
  until [[ "$(ssh -o StrictHostKeyChecking=no -i /Users/cedric/.ssh/$1.pem core@$STACK_IP -C 'curl --max-time 10 --write-out %{http_code} --silent --output /dev/null http://10.0.1.254:30000')" == "200" ]]
  do
    if [ $SECONDS -gt $end ]; then
      echo "Timeout waiting for Toolbox"
      heat stack-delete -y stack-mcm-$i
      exit -1
    fi
    echo -n "."
    sleep 10
  done
  echo "Toolbox started"
  echo "Launching all apps"
  for app in $(ssh -o StrictHostKeyChecking=no -i /Users/cedric/.ssh/$1.pem core@$STACK_IP -C 'curl --silent http://10.0.1.254:30000/api/apps' | jq .[].id); do
    echo "Starting app $app"
    ssh -o StrictHostKeyChecking=no -i /Users/cedric/.ssh/$1.pem core@$STACK_IP -C "curl --silent http://10.0.1.254:30000/api/apps/$app/start"
    echo "$app started"
  done
  for app in $(ssh -o StrictHostKeyChecking=no -i /Users/cedric/.ssh/$1.pem core@$STACK_IP -C 'curl --silent http://10.0.1.254:30000/api/apps' | jq .[].name | sed s/\"//g | tr '[:upper:]' '[:lower:]')
  do
    end=$((SECONDS+300))
    echo -n "Waiting for $app to be started..."
    until [[ "$(ssh -o StrictHostKeyChecking=no -i /Users/cedric/.ssh/$1.pem core@$STACK_IP -C "/opt/bin/kubectl get pods -o json -l app=$app") | jq '.items[].status.phase != \"Running\"' | grep true)" ]]
    do
      if [ $SECONDS -gt $end ]; then
        echo "Timeout waiting for $app"
        heat stack-delete -y stack-mcm-$i
        exit -1
      fi
      echo -n "."
      sleep 10
    done
    echo ""
    echo "$app started"
  done
#  heat stack-delete -y stack-mcm-$i
done
