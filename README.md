# OpenShift Origin Multi-Node Cluster with 3-AZ-replicated GlusterFS 
### Current Restriction: Hardcoded AWS region: "eu-central-1" (Frankfurt)

## Modifications on that branch

- Setup cluster on AWS account (work in progress)

## Modifications of that fork

- strategy based on: https://sysdig.com/blog/deploy-openshift-aws/#

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

The following steps are tested on a MacOS host machine...

## Prerequisites

### Install aws-cli and setup credentials for your personal aws account

### Register 4 Elastic-IPs manually

### Create EC2 SSH key manually and save it locally

- Create those entries in ~/.ssh/config (for all 4 elastic ips used by the 4 cluster nodes)

``` bash
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  IdentityFile ~/your-key-folder/your-ec2-ssh-private-key-file.pem
  
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  IdentityFile ~/your-key-folder/your-ec2-ssh-private-key-file.pem
  
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  IdentityFile ~/your-key-folder/your-ec2-ssh-private-key-file.pem
  
Host ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Hostname ec2-EE-LL-II-PP.eu-central-1.compute.amazonaws.com
  Port 22
  User centos
  IdentityFile ~/your-key-folder/your-ec2-ssh-private-key-file.pem
  ```

### Subscribe to AWS marketplace AMI for Centos 7

- Login to AWS management console
- Subscribe to Centos 7 AMI from AWS Marketplace using this link: https://aws.amazon.com/marketplace/pp/B00O7WM7QW
- Note AMI-ID for eu-central-1 (current latest image: "ami-9a183671")

### Prepare ssh config

### Prepare ansible inventory file
- Optional: Update AMI-ID of Centos 7 image for eu-central-1 noted above (current latest image: "ami-9a183671")
- 

### Create S3 manually and upload ansible inventory file

### Fetch openshift-ansible from github

## Setup Cluster on AWS

### Cluster Init

### Cluster Up

### Set permissions to cluster user
- sudo htpasswd -b /etc/openshift/openshift-passwd admin yoursupersecretpassword
- sudo oadm policy add-cluster-role-to-user cluster-admin admin

### SSH access to cluster nodes
