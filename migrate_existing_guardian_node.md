# Migrate Existing Guardian Node

I have been successful in converting a Linux GUI version of the Theta Guardian Node to a containerized Kubernetes solution. The migrated Linux GUI installation shows that it is regularly reporting in (via https://guardianmonitor.io/) and TFUEL rewards are regularly being received.

To migrate, there are three (3) steps needed prior to setting up your own containerized version:

1. We need to copy our data to a location the container will be using
2. Change the file/directory permissions so the container has the correct read/write access
3. Copy/Paste the same password you're using in the Linux GUI installation - to the containerized solution

**NOTE**: Before continuing, please take a look at the [README.md](README.md) and familiarize yourself with the steps involved in creating a Theta Guardian Node using the installation method you have chosen.
<br/><br/>

## Copy existing data from Linux GUI installation

As indicated, the data being used by your existing Linux GUI installation will also work for any of your chosen installation methods (docker/docker-compose/kubernetes). We just need to copy the existing data such that the new Guardian Node container will see it when it starts.

The directory that stores our existing Theta Guardian Node data (from the GUI) is located at:

`"${HOME}/.config/Theta Guardian Node/ThetaGN/configs/mainnet/"`

**NOTE**: It is wise to always work on a copy of the existing data such that we can always revert if anything goes wrong.

At this point, if not already done so, shut down your running Theta Guardian Node before proceeding any further.

### Docker/Docker-compose installation

Create a new directory to contain our copy of the existing Guardian Node data:

> mkdir -p "\${HOME}/theta_mainnet_data" && chmod 777 "${HOME}/theta_mainnet_data"

For **docker**, read the comment in [build_and_start_guardian.sh](build_and_start_guardian.sh) for `bind mount` and change the script to use that example.

For **docker-compose**, read the comment in [docker-compose.yaml](docker-compose.yaml) for `bind mount` and change the script to use that example.

Copy the existing data:

> cp -rvp "${HOME}/.config/Theta Guardian Node/ThetaGN/configs/mainnet/" "\${HOME}/theta_mainnet_data/"

### Kubernetes installation

Assuming you setup a GlusterFS/NFS server for the Kubernetes installation, you are most likely also familiar with Linux mounts. Create a mount to the NFS/Gluster cluster and `cp` it, as we've done in the above example.
<br/><br/>

## Change File/Directory Permissions

So the container has the correct read/write access, we will need to ensure the permissions align with the user/group the container runs as.

Change the permissions for all the files/directories so the container can read the data:

### Docker/Docker-compose installation

> sudo chown -R 9001:9001 "\${HOME}/theta_mainnet_data/"

### Kubernetes installation

Same as above, just replace the target directory ( ie. `"\${HOME}/theta_mainnet_data/"`) with the mountpoint you used to mount the remote share
<br/><br/>

## Copy/Paste the same password (used in your GUI installation)

Not much to add here. We are going to use the same password you used when you installed the GUI version, here. As documented in the [README.md](README.md), simply use your existing password instead of generating a new one.
<br/><br/>

Now that your data is copied to where it needs to be, permissions are set correctly, and you have your existing password in hand - continue along with the [README.md](README.md) to stand up your own Guardian Node.
