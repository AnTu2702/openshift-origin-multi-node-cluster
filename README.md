# OpenShift Origin Multi-Node Cluster in AWS with 3-AZ-replicated GlusterFS 
### Current Restriction: Hardcoded AWS region: "eu-central-1" (Frankfurt)

## Modifications on that branch

- Setup cluster on AWS account (work in progress)

## Common Remark for Setup strategy on AWS

- Setup Strategy based on: https://sysdig.com/blog/deploy-openshift-aws/#

## Infrastructure Description

An OpenShift 3.6.1 cluster of 4 machines:

| Machine  | Hostname                                            | IP                 | Description         |
| :------- | :----                                               | :---:              | :----               |
| Master   | ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com  | from 10.0.0.0/27   | Cluster Master node |
| Node1    | ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com  | from 10.0.0.0/27   | Worker node         |
| Node2    | ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com  | from 10.0.0.32/27  | Worker node         |
| Node3    | ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com  | from 10.0.0.64/27  | Worker node         |


## Hardware Requirements
This demo environment requires four ec2 machines of (t2.micro):
 - 1 cores
 - 1 GB RAM
 - 8 GB free disk space
 - Up to 2 additional EBS drive with 12GB and 16 GB free space
 
| Machine | CPU | Memory  | Primary Disk        | Secondary Disk                 | Tertiary Disk                     |
| :------ | :-: | :-----: | :----               | :----                          | :----                             |
| Master  | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage | none                              |
| Node1   | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage | 16 GB, EBS, for GlusterFS storage |
| Node2   | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage | 16 GB, EBS, for GlusterFS storage |
| Node3   | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage | 16 GB, EBS, for GlusterFS storage |


## Prerequisites
The following steps are tested on a MacOS host machine...

### Install aws-cli and setup credentials for your personal aws account

- Check out basic instructions from here: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

### Register 4 Elastic-IPs manually

- Create 4 unassociated Elastic IP addresses from AWS management console and note them
- Preassign them in mind by free choice to the required instances (master, node1, node2 and node3)

### Create EC2 SSH key manually and save it locally

- Create an ec2 ssh keypair and download/store the private pem-file to ~/folder-of-your-choice/your-ec2-ssh-private-key-file.pem
- chmod 400 ~/folder-of-your-choice/your-ec2-ssh-private-key-file.pem

### Subscribe to AWS marketplace AMI for Centos 7

- Subscribe to Centos 7 AMI from AWS Marketplace using this link: https://aws.amazon.com/marketplace/pp/B00O7WM7QW
- Note AMI-ID for eu-central-1 (current latest image: "ami-9a183671")

### Prepare ssh config

- Create those entries in ~/.ssh/config (for all 4 elastic ips used by the 4 cluster nodes)

``` bash
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  StrictHostKeyChecking no
  IdentityFile ~/folder-of-your-choice/your-ec2-ssh-private-key-file.pem
  
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  StrictHostKeyChecking no
  IdentityFile ~/folder-of-your-choice/your-ec2-ssh-private-key-file.pem
  
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  StrictHostKeyChecking no
  IdentityFile ~/folder-of-your-choice/your-ec2-ssh-private-key-file.pem
  
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  StrictHostKeyChecking no
  IdentityFile ~/folder-of-your-choice/your-ec2-ssh-private-key-file.pem
  ```

### Prepare ansible inventory file
- Open ./ansible/ansible-hosts.yaml with an editor of your choice:
- Update AMI-ID of Centos 7 image for eu-central-1 noted above (current latest image: "ami-9a183671")
- Paste the elastic-ip-addresses and related ec2-hostnames (your choice above) to the appropriate locations in that file 

### Create S3 manually and upload ansible inventory file
- Create an S3-bucket in region eu-central-1
- Upload aws-ocp-cf-template.yaml to that bucket
- Note https link of that file: (should be similar to https://s3.eu-central-1.amazonaws.com/your-s3-bucketname/aws-ocp-cf-template.yaml)

### Fetch openshift-ansible from github
- Jump out from the parent folder on your disk of this git-project (e.g. cd ~/projects/)
- git clone https://github.com/openshift/openshift-ansible.git
- cd openshift-ansible
- git checkout origin/release-3.6

### Prepare cluster.sh script for usage
- Open ./cluster.sh with an editor of your choice (e.g. vi ./cluster.sh)
- Replace your s3 bucket url at "--template-url" value
- Replace your ssh-keyfile-path at "ParameterValue" value
 
## Setup Cluster on AWS

### Cluster Init (auto setup infrastructure using cloudformation)
- chmmod 755 ./cluster.sh
- ./cluster.sh init

### SSH access to all of your cluster nodes once and confirm signature
- (Dispensible. Should be fine using "StrictHostKeyChecking no" in your ~/.ssh/config)

### Cluster Up
- ./cluster.sh up ### This will take about 45 minutes

### Set permissions to cluster user
- ssh ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com #master
- sudo htpasswd -b /etc/openshift/openshift-passwd admin yoursupersecretpassword
- sudo oadm policy add-cluster-role-to-user cluster-admin admin
- exit

### Connecto to Openshift Web Console:
- Open a browser and surf to https://ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com:8443 (ip of master node)
- Confirm the security exception(s) warnings from your browser and proceed to page...

## Open Issues:
- Activate AWS integration for cluster to use EBS and EFS storage classes
- Parametrize Scripts in order to reduce installation effort
- Maybe never: Parametrize aws region (for deployments in others than eu-central-1)
