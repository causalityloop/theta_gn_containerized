#!/usr/bin/env bash

# delete the namespace
kubectl delete --filename theta.guardian.ns.yaml

# comment/uncomment the below to reflect what storage you are using
#------------------------------------------------------------------------------
# Gluster
#------------------------------------------------------------------------------
# kubectl delete --filename theta.guardian.gluster.pv.yaml
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# NFS
#------------------------------------------------------------------------------
kubectl delete --filename theta.guardian.nfs.pv.yaml
#------------------------------------------------------------------------------
