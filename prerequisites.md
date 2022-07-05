Below are the prerequisites for each of the 3 types of installations:

I primarily did my testing on an Ubuntu based distribution. If you are using another distribution, just pivot to using the package manager as it relates to your distribution (apk add, dnf install, yum, etc...).

## Docker Installation

Minimally, we just require docker here.

```console
sudo apt-install -y docker.io
```

## Docker-Compose Installation

Here we will need `docker` and `docker-compose`. So let's get that installed:

```console
sudo apt install -y docker.io docker-compose
```

## Kubernetes Deployment

A kubernetes cluster creation is a little more involved and requires several hosts (if you want HA) and not covered here. The expectation in using this installation method is that you already have a cluster that is available to use

If you are interested in this option and do not have a cluster readily available, here is an excellent guide in helping to do so:

https://www.linuxtechi.com/install-kubernetes-k8s-on-ubuntu-20-04/

In kubernetes 1.24, docker shim was removed and you may need to supplement/augment your installation (for 1.24) with this link https://devopstales.github.io/home/migrate-kubernetes-to-dockershim/ or just install 1.23 of Kubernetes

Again, if you have a cluster already - great. If not, the above should get you pointed in the right direction.