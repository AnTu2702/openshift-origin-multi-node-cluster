#!/bin/bash

clusterInit () {
   echo "Initialize Cluster"
   if [[ $1 == parallel ]]; then
      echo "Parallel Node Initialization."
      vagrant up --parallel master infra node1 node2 node3
   else
      echo "Sequential Node Initialization."
      vagrant up master
      vagrant up infra
      vagrant up node1
      vagrant up node2
      vagrant up node3
   fi
   vagrant up toolbox
}

clusterUp () {
   echo "Cluster Up"
   vagrant up toolbox
   if [[ $1 == parallel ]]; then
      echo "Parallel Node Start."
      vagrant up --parallel infra node1 node2 node3
   else
      echo "Sequential Node Start."
      vagrant up infra
      vagrant up node1
      vagrant up node2
      vagrant up node3
   fi
   vagrant up master
}

clusterDown () {
   echo "Cluster Down"
   vagrant halt master
   vagrant halt infra
   vagrant halt node1
   vagrant halt node2
   vagrant halt node3
   vagrant halt toolbox
}

if [[ $1 == init ]]; then
   clusterInit $2
   exit 0
fi

if [[ $1 == up ]]; then
   clusterUp $2
   exit 0
fi

if [[ $1 == down ]]; then
   clusterDown $2
   exit 0
fi

echo "Argument doesn't match init, up, or down."
exit -1


