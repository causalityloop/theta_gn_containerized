To pause/stop the Guardian node for either docker/docker-compose, you can use the stop/start commands.

Stop/Pause
>docker stop theta_guardian_node

Start/Resume
>docker start theta_guardian_node

For kubernetes, we cannot stop **and** resume a pod but we can achieve the same effect by "uninstalling" it as instructed below. When we remove our deployment, that will clean up all our pods/cluster resources but the data used by our Guardian Node is still intact on the NFS/Gluster (whichever you chose) share/mount. By uninstalling and later running the install again, the pod will be recreated clean. However, the data it used prior is still intact and the Guardian Node will just resume where it left off.

To uninstall/cleanup, based on your installation method:

## Docker Installation

This will stop the container, remove it, and also delete the anonymous volume associated (default) with it
>docker stop theta_guardian_node && docker rm -v theta_guardian_node

To also delete the image you initially created:

>docker rmi theta_guardian_node:1.0

And, finally, delete the password you created:

>rm -f "${HOME}/.gn.signing.key.password"

## Docker-Compose Installation

This will stop the container, remove it, and also delete the named volume associated (default) with it
>docker-compose down -v

To also delete the image you initially created:

>docker rmi theta_guardian_node:1.0

And, finally, delete the password you created:

>rm -f "${HOME}/.gn.signing.key.password"

## Kubernetes Deployment

Open `destroy.thetagn.deployment.sh` in an editor and comment out the appropriate Gluster/NFS sections as it pertains to your desired deployment

Now run the `destroy.thetagn.deployment.sh` script and kubernetes will remove the deployment and all associated resources

>./destroy.thetagn.deployment.sh