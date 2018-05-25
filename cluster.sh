#!/bin/bash

clusterInit () {
   echo "Initialize Cluster"
   aws cloudformation create-stack  --region eu-central-1  --stack-name ocp-gluster-benchmark  --template-url "https://s3.eu-central-1.amazonaws.com/<<your-s3-bucketname>>/aws-ocp-cf-template.yaml"  --parameters ParameterKey=KeyName,ParameterValue=<your-ec2-ssh-private-key-file.pem> --capabilities=CAPABILITY_IAM
}

clusterUp () {
   echo "Cluster Up"
   ansible-playbook -i ./ansible-hosts.yaml ./ansible/playbooks/prepare.yml
   ansible-playbook -i ./ansible-hosts.yaml ../openshift-ansible/playbooks/byo/config.yml
}

clusterDown () {
   echo "Cluster Down"
   echo "Not implemented..."
}

if [[ $1 == init ]]; then
   clusterInit
   exit 0
fi

if [[ $1 == up ]]; then
   clusterUp
   exit 0
fi

if [[ $1 == down ]]; then
   clusterDown
   exit 0
fi

echo "Argument doesn't match init, up, or down."
exit -1


