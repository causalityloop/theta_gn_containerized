# Theta Guardian Node - Containerized

After noticing Theta's Guardian Node download offerings were missing a containerized solution - I thought I would step forward and solve that need.

**What will this do for me you ask?**

Running a Theta Guardian Node, from a container, provides several advantages:

* Isolation - Running a Guardian Node in a container will provide clear isolation of the runtime environment from the host (your running machine).

* Fault Tolerance/Redundancy - In a kubernetes environment if a host/worker running the Guardian Node goes down, the Guardian Node will automatically launch on another available host/worker - ensuring your Guardian Node is running at all times.

* Performance - Containers are lightweight and do not contain an OS. Deploying a Guardian Node is super fast

* Agility - Ease of moving the Guardian Node from one machine to another - or from one cluster to another

* Security - Less access to host resources (ie. filesystem). The container runs as a non-root user and has less software dependencies

**This all sounds great but how do I get started?**

There are three (3) installation options to choose from:

1. Docker command line - quick and easy to run
2. Docker-compose - a cleaner approach as you can manage the configuration via a yaml file
3. Kubernetes Deployment - if you are already running a Kubernetes cluster and have a need/want to have the Guardian Node always running - 100% ...this is the path for you

<a name="images"></a>First to note, I do not provide any docker images. This is crypto and there is an element of trust when you are downloading software from an unknown. I wouldn't do it - and neither should you.

More to the above, since I am not providing an already built image - we will just build it ourselves. Fortunately, building this is super easy and the source code/instructions of what is being built is for all to see and review.

### Prerequisites

* Refer to [`prerequisites.md`](prerequisites.md) to install any dependencies for the type of installation you are interested in
* If you are interested in **migrating** an existing Theta Guardian Node (ie. Linux GUI version), start [here](migrate_existing_guardian_node.md)
    * The largest advantage here is avoiding the need to unstake and restake to a new node (address). If time is of no consequence, you can just unstake and restake to the new node address


So, let's start...
<br/><br/>

## Option 1 - Docker command line

<br/>
Create a password that will be used to decrypt your private key for your Guardian node.
<br/><br/>

**NOTE:** take a look at the [password.md](password.md) file for an elaboration of what this password is and how its used. This password has nothing to do with any existing password you have, no 12 word seed phrase, none of that phishing nonsense. You are primarily here because you have some theta you want to stake and you want to stake it to your OWN guardian node.
<br/><br/>
When you've created a password, you can just run the `build_and_start_guardian.sh` script and it will build and run the Guardian Node container.

> ./build_and_start_guardian.sh

Refer to the [`staking.md`](staking.md) document on how to get your **Node Holder (Summary)** so you can begin staking.

To query the status and report the logs please refer to the [additional_cmds.md](additional_cmds.md).

Lastly, to stop and/or uninstall please refer to the [uninstall.md](uninstall.md) document.
<br/><br/>

## Option 2 - Docker-compose

<br/>
Create a password that will be used to decrypt your private key for your Guardian node.
<br/><br/>

**NOTE:** take a look at the [password.md](password.md) file for an elaboration of what this password is and how its used. This password has nothing to do with any existing password you have, no 12 word seed phrase, none of that phishing nonsense. You are primarily here because you have some theta you want to stake and you want to stake it to your OWN guardian node.
<br/><br/>
As with the docker shell script above, we can actually build and run this in one go. To build and run the container, simply run:

> docker-compose up -d

The command will build, if the image does not already exist, and run the guardian node

Refer to the [`staking.md`](staking.md) document on how to get your **Node Holder (Summary)** so you can begin staking.

To query the status and report the logs please refer to the [additional_cmds.md](additional_cmds.md).

Lastly, to stop and/or uninstall please refer to the [uninstall.md](uninstall.md) document.
<br/><br/>

## Option 3 - Kubernetes Deployment

<br/>
There are few steps to configuring the kubernetes deployment for your needs:

1. You will need to build/provide your own Theta Guardian Node image (see [here](#images))
2. Create a password
3. Choose a storage type for your deployment
<br/><br/>

### Theta Guardian Node Image

If you are running your own docker registry or wish to use dockerhub - the world is your oyster. Dockerhub is free if you are looking for options and a quick example is below to build and push **your own** image.

Note: make sure you are logged into dockerhub (paste your api key in `~/.dock_pass`)
> cat ~/.dock_pass | docker login --username <your_dockerhub_user> --password-stdin

Build and push the image:
> cd docker
>
> docker build -t theta_guardian_node:1.0 .
>
> docker tag theta_guardian_node:1.0 <your_dockerhub_user>/theta/theta_guardian_node:1.0
>
> docker push <your_dockerhub_user>/theta/theta_guardian_node:1.0

Now we need to change the `image` reference in the `theta.guardian.deployment.yaml` to reflect your image. ie. `<your_dockerhub_user>/theta/theta_guardian_node:1.0`
<br/><br/>

### Create a password

Next, we need to create a password. You can open the `theta.guardian.secret.yaml` and add it. Also feel free to refer to the [password.md](password.md) file for a more step by step approach, if needed.
<br/><br/>

### Storage Type - GlusterFS/NFS

Now that the password has been set, you will need to determine which storage option is best for you. Provided here are two types of deployments. You will need either a GlusterFS cluster to mount to or we can use a NFS server.

Note: if you have neither immediately available, here is a quick guide on setting up a NFS server to use: https://www.tecmint.com/install-nfs-server-on-ubuntu/

When you've decided which type of storage to use:

#### GlusterFS

Open `theta.guardian.gluster-endpoints.yaml` in an editor and under `subsets`, change the number of `addresses` blocks to reflect the number of Gluster hosts you have and edit the `ip` values accordingly. That's it.

#### NFS

Open `theta.guardian.nfs.pv.yaml` in an editor and, as the comments suggest, change the value of `server` to reflect the IP of your NFS server and change `path` to your NFS mount/export
<br/><br/>

### Executing the Deployment

Open `create.thetagn.deployment.sh` in an editor and comment out the appropriate Gluster/NFS sections as it pertains to your desired deployment

Next up, let's deploy...

Run the `create.thetagn.deployment.sh` script and off you go. You can monitor the deploy by issuing the following `kubectl` command

> watch kubectl get deployment,svc,pods,pvc,pv,endpoints --namespace theta

Once the theta pod is up, you can retrieve the running [logs](./images/k8s_thetagn_startup_output.png) with:

> kubectl logs --namespace theta pod/$(kubectl get pod --namespace theta -o jsonpath="{.items[0].metadata.name}")

Refer to the [`staking.md`](staking.md) document on how to get your **Node Holder (Summary)** so you can begin staking.

To query the status and report the logs please refer to the [additional_cmds.md](additional_cmds.md).

Lastly, to stop and/or uninstall please refer to the [uninstall.md](uninstall.md) document.
