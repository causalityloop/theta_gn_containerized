#!/usr/bin/env bash

# create the namespace
kubectl create --filename theta.guardian.ns.yaml

# comment/uncomment the below Gluster/NFS to reflect what storage you are using
#------------------------------------------------------------------------------
# Gluster
#------------------------------------------------------------------------------
# kubectl create --filename theta.guardian.gluster-endpoints.yaml
# kubectl create --filename theta.guardian.gluster.pv.yaml
# kubectl create --filename theta.guardian.gluster.pvc.yaml
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# NFS
#------------------------------------------------------------------------------
kubectl create --filename theta.guardian.nfs.pv.yaml
kubectl create --filename theta.guardian.nfs.pvc.yaml
#------------------------------------------------------------------------------

# create the secret
kubectl create --filename theta.guardian.secret.yaml

# deploy guardian node
kubectl create --filename theta.guardian.deployment.yaml
