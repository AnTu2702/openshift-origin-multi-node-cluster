# OpenShift Origin Multi-Node Cluster with GlusterFS

## Modifications on that branch

- Setup cluster on AWS account (work in progress)

## Modifications of that fork

- strategy based on: https://sysdig.com/blog/deploy-openshift-aws/#

An OpenShift 3.6.1 cluster of 4 machines:

| Machine  | Hostname          | IP             | Description |
| :------- | :----             | :---:          | :---- |
| Master   | master.local.net  |  192.168.1.101 | Cluster Master node |
| Node1    | node1.local.net   |  192.168.1.111 | Worker node |
| Node2    | node2.local.net   |  192.168.1.112 | Worker node |
| Node3    | node2.local.net   |  192.168.1.113 | Worker node |


## Hardware Requirements
This demo environment requires a machine of:
 - 1 cores
 - 1 GB RAM
 - 8 GB free disk space
 - Additional EBS drive with 16 GB free space
 
| Machine | CPU | Memory  | Primary Disk             | Secondary Disk |
| :------ | :-: | :-----: | :----                    | :---- |
| Master  | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage |
| Node1   | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage |
| Node2   | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage |
| Node3   | 1   | 1024 MB | 8 GB EBS allocation | 12 GB, EBS, for Docker storage |


## Prerequisites

The following steps are tested on a MacOS host machine.

### Install aws-cli and setup credentials for your personal aws account

### Register 4 Elastic-IPs manually

### Create EC2 SSH key manually and save it locally

### Subscribe to AWS marketplace AMI for Centos 7

### Prepare ssh config

### Prepare ansible inventory file

### Create S3 manually and upload ansible inventory file

### Fetch openshift-ansible from github

## Setup Cluster on AWS

### Cluster Init

### Cluster Up

### Set permissions to cluster user
sudo htpasswd -b /etc/openshift/openshift-passwd admin deinemudda
sudo oadm policy add-cluster-role-to-user cluster-admin admin

### SSH access to cluster nodes
