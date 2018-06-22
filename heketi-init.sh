#!/bin/bash

echo "Connecting to Openshift Origin Cluster...OK"
oc login master.local.net:8443 -u admin -p admin

echo "Switch to project: glusterfs...OK"
oc project glusterfs

HEKETI_CLI_USER=admin

echo "export HEKETI_CLI_USER=$HEKETI_CLI_USER" >> ~/.bash_profile

HEKETI_CLI_KEY=`oc get secret heketi-storage-admin-secret -o yaml | grep key | sed -En 's/key: //p'`
HEKETI_CLI_KEY=`echo $HEKETI_CLI_KEY | base64 --decode`

echo "export HEKETI_CLI_KEY=$HEKETI_CLI_KEY" >> ~/.bash_profile

oc get routes

HEKETI_CLI_SERVER=`oc get route | grep heketi-storage | awk '{print $2}'`
HEKETI_CLI_SERVER="http://"$HEKETI_CLI_SERVER

echo "export HEKETI_CLI_SERVER=$HEKETI_CLI_SERVER" >> ~/.bash_profile

oc logout

echo "HEKETI_CLI_ environment variables have been added to your ~/.bash_profile"
echo "For now you may use heketi-cli for gluster-management calling:"
echo "heketi-cli topology info --user admin --secret $HEKETI_CLI_KEY --server http://heketi-storage-glusterfs.cloudapps.local.net
