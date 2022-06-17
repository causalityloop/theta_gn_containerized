#!/usr/bin/env bash

# build the Theta Guardian Node image
# this is essentially a no-op if the image already exists
docker build -t theta_guardian_node:1.0 .

# In launching this, we need to provide a password to the container
#
# This password/key is for the wallet OF the Guardian Node (ie. receive rewards if you are
# running a Guardian Node for profit - others stake to you and you get a % of the rewards).
# Special thanks to @techguyk for that tip. Please refer to the `password.md` file for more information.
#
# 99% of you will not use/care for this option - However we still need to create a password anyway.
# So, create a password using any password generator you are comfortable with and put
# it in a file here: ${HOME}/.gn.signing.key.password
#
# If you with to back up or have easy access to the Guardian Node data, you can either use a named volume or
# a bind mount. Some will find it helpful - so just two examples to illustrate:
#
# anonymous volume (default)
# -v /home/theta/theta_mainnet/guardian/node \
#
# named volume
# -v theta_mainnet_data:/home/theta/theta_mainnet/guardian/node \
#
# bind mount
# -v "${HOME}/theta_mainnet_data:/home/theta/theta_mainnet/guardian/node" \
#
# If you are providing the directory, ensure the directory has the correct permissions.
# The container defaults to run as user id 9001. ie. chmod/chown

docker run \
       --ulimit nofile=4096:4096 \
       --detach \
       --name "theta_guardian_node" \
       --restart unless-stopped \
       -v "${HOME}/.gn.signing.key.password:/run/secrets/gn-signing-key-password:ro" \
       -v /home/theta/theta_mainnet/guardian/node \
       theta_guardian_node:1.0
