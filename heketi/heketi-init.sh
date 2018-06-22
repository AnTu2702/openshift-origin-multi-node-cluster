#!/bin/bash

set -e

echo "Connecting to Openshift Origin Cluster..."
oc login master.local.net:8443 -u admin -p admin > /dev/null
echo "...OK"

echo "Switch to project: glusterfs..."
oc project glusterfs > /dev/null
echo "...OK"

HEKETI_CLI_USER=admin

echo "export HEKETI_CLI_USER=$HEKETI_CLI_USER" >> ~/.bash_profile

echo "Fetching Heketi-Credentials..."
HEKETI_CLI_KEY=`oc get secret heketi-storage-admin-secret -o yaml | grep key | sed -En 's/key: //p'`
HEKETI_CLI_KEY=`echo $HEKETI_CLI_KEY | base64 --decode`

echo "export HEKETI_CLI_KEY=$HEKETI_CLI_KEY" >> ~/.bash_profile

oc get routes > /dev/null

HEKETI_CLI_SERVER=`oc get route | grep heketi-storage | awk '{print $2}'`
HEKETI_CLI_SERVER="http://"$HEKETI_CLI_SERVER

echo "export HEKETI_CLI_SERVER=$HEKETI_CLI_SERVER" >> ~/.bash_profile
echo "...OK"

echo "Closing connection..."
oc logout > /dev/null
echo "...OK"

echo "Updating your ~/.bash_profile..."
echo "HEKETI_CLI_USER=$HEKETI_CLI_USER"
echo "HEKETI_CLI_KEY=$HEKETI_CLI_KEY"
echo "HEKETI_CLI_SERVER=$HEKETI_CLI_SERVER"
echo "...OK"
echo ""

echo "[A] From this shell use heketi-cli for gluster-management like..."
echo "heketi-cli topology info --user $HEKETI_CLI_USER --secret $HEKETI_CLI_KEY --server $HEKETI_CLI_SERVER"
echo "[B] From a new shell simply like..."
echo "hekeit-cli topology info"