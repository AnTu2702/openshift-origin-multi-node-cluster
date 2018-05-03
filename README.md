# OpenShift Origin Multi-Node Cluster with GlusterFS

## Modifications on that branch

- Setup proxy server on all leves (work in progress)

## Modifications of that fork

- Provide cluster.sh for Linux/Mac machines (migrated from cluster.bat)
- Adapt setup of Openshift Cluster to enable GlusterFS
- Migrate safely to Openshift Origin 3.7.2 and its mirror repositories
- Adjust docker image versions to fit to Openshift Origin 3.7.2
- Introduce 3rd worker node (also as storage-node for GlusterFS)
- Extend DNS configuration on toolbox (3rd node's name entry)
- Reduce available memory of all nodes to 2 GiB

An OpenShift 3.7.2 cluster of 6 machine:

| Machine  | Hostname          | IP             | Description |
| :------- | :----             | :---:          | :---- |
| Toolbox  | toolbox.local.net |  192.168.1.100 | Ansible, Bind DNS, and NFS storage |
| Master   | master.local.net  |  192.168.1.101 | Cluster Master node |
| Infra    | infra.local.net   |  192.168.1.110 | Infra Node hosting Docker registry and HA Proxy router |
| Node1    | node1.local.net   |  192.168.1.111 | Worker node |
| Node2    | node2.local.net   |  192.168.1.112 | Worker node |
| Node3    | node2.local.net   |  192.168.1.113 | Worker node |


## Hardware Requirements
This demo environment requires a machine of:
 - 4 cores
 - 16 GB RAM
 - 40 GB free disk space
 - Additional drive (USB Stick, SDXC...) with at least 90 GB free space
 
| Machine | CPU | Memory  | Primary Disk             | Secondary Disk |
| :------ | :-: | :-----: | :----                    | :---- |
| Toolbox | 1   | 2048 MB | 40 GB dynamic allocation | NA    |
| Master  | 1   | 2048 MB | 40 GB dynamic allocation | 15 GB, dynamic, for Docker storage |
| Infra   | 1   | 2048 MB | 40 GB dynamic allocation | 20 GB, dynamic, for Docker storage |
| Node1   | 1   | 2048 MB | 40 GB dynamic allocation | 20 GB, dynamic, for Docker storage |
| Node2   | 1   | 2048 MB | 40 GB dynamic allocation | 20 GB, dynamic, for Docker storage |
| Node3   | 1   | 2048 MB | 40 GB dynamic allocation | 20 GB, dynamic, for Docker storage |


## Prerequisites
The following steps are tested on a MacOS host machine.

### Install VirtualBox

 - Install [VirtualBox 5.1](https://www.virtualbox.org/wiki/Download_Old_Builds_5_1)
 Check the [compatibility](https://www.vagrantup.com/docs/virtualbox) between Vagrant and VirtualBox first. 
 - Download the [Extension Pack](http://download.virtualbox.org/virtualbox/5.1.30/Oracle_VM_VirtualBox_Extension_Pack-5.1.30-118389.vbox-extpack) and add it to VirtualBox: **File --> Preferences --> Extensions --> Add**

### Install Vagrant 
 - Install [Vagrant](https://www.vagrantup.com/downloads.html). This environment has been tested with Vagrant 2.0.4

 - Install a cntlm-server on your host machine configured for your upstream proxy server (use the following config)

   | Username |       <your-proxy-user>             |
   | Domain   |       <your-domain>                 |
   | Password |       <your-password>               |
   | Proxy    |       <upstream-proxy>:<port>       |
   | NoProxy  |       <your no-proxy list entries>  |
   | Header   |       Connection: Keep-Alive        |
   | Gateway  |       yes                           |
   | Listen   |       127.0.0.1:3130                |
   | Listen   |       192.168.1.1:3130              |
 
 - Install Vagrant VirtualBox Proxy and Guest Plugins
```sh
export http_proxy=http://192.168.1.1:3130
export https_proxy=http://192.168.1.1:3130

vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-vbguest
```

## Network
All the machines are configures with NAT and Host Only adapters. 

> **Note:**
> The network may not behave properly over VPN, please disable any VPN before running the cluster.



## Cluster Provisioning

 - Clone or download this repository to your host machine.

> **Recommendation:**
>   It's recommended to change the SSH keys under keys directory.

 - Navigate to your local copy and run the following command
```sh
./cluster.sh init parallel
```

> **Note:**
>  The command will start the machines in the following order:
>  1. master, infra, node1, and node2
>  2. toolbox
 
> **Note:**
>  The second argument 'parallel' is optional. It directs vagrant to start machines in parallel when possible.
 
> **Note:**
>  As it's the first run of the machines, Vagrant will run provisioning scripts to install any required tools and configure the machines connectivity and networking.

## Connecting to The Cluster

### Test  Network Connectivity
Firstly, try to ping the cluster machines from your host:
```sh
ping 192.168.1.100
ping 192.168.1.101
ping 192.168.1.110
ping 192.168.1.111
ping 192.168.1.112
ping 192.168.1.113
```
### Add Cluster DNS to Host Machine
Now, we need to cluster DNS to host in order to resolve machines hostnames:

 - Go to **Network Connections**
 - Select the **VirtualBox Host-Only Network --> Properties --> Internet Protocol version 4 --> Properties**
 - Make sure that the IP addressis **192.168.1.1**, otherwise, try another adapter.
 - Add DNS server **192.168.1.100** and save.
 - Try to ping using machine hostname:
```sh
ping toolbox.local.net
```
 - Test the wildcard DNS:
```sh
ping XYZ.cloudapps.local.net
```
 
### SSH Connection to Cluster Machines
Use your preferred SSH Client to connect to the machines. I personally recommend [iTerm2].
Use the private key in the /keys directory to connect.
Machines Users:

| User    | Password | 
| :------ | :------  | 
| root    | vagrant  |
| vagrant | vagrant  | 

## Prepare GlusterFS Storage Devices (Manual preparation step)

- Shutdown and halt node1, node2 and node3.
- Provde (Using VirtualBox Manager) a new and empty 30 GB dynamic vdi-image-file as IDE secondary slave device to each worker node (node1, node2, node3).
- vagrant up --parallel node1 node2 node3

## Installation and Configuration

> **Recommendation:**
>  I recommend that you take snapshots of the machines at this point, so you call roll back to them.

Connect to the Toolbox machine as root, and make sure that Ansible can reach to all the cluster machines:
```sh
ansible cluster -m ping
```

### Docker

 - Install Docker and configure its storage:
```sh
ansible-playbook /vagrant/ansible/playbooks/setup-docker.yml
```
 - Pull Docker images prior to OpenShift installation:
```sh
ansible-playbook /vagrant/ansible/playbooks/populate-docker-registry.yml
```

> **Recommendation:**
>  Take snapshots of machines: master, infra, node1, node2 and node3.


## OpenShift
 

 - Install OpenShift Prerequisites: 
```sh
ansible-playbook /vagrant/ansible/playbooks/openshift-pre-install.yml
```
 - Install OpenShift:
```sh
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
```
 - Configure OpenShift:
```sh
ansible-playbook /vagrant/ansible/playbooks/openshift-post-install.yml
```
 - Now, try to login to OpenShift Console from host machine
 https://master.local.net:8443
 Accept the certificate and use admin/admin to login
 - Also try the Docker registry
 https://registry-console-default.cloudapps.local.net

 
 
## Cluster Control 

 - Start the Cluster:
```sh
./cluster.sh up parallel
```
 - Shutdown the Cluster:
```sh
./cluster.sh down
```


## Next Enhancements

- Enhance documentation.
- Adapt setup for deployment on AWS
- Play with GlusterFs for storage.
