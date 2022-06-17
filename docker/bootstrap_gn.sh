#!/usr/bin/env bash

set -u

# download the snapshot if it does not exist
if [[ ! -f guardian/node/snapshot ]]; then
    echo "snapshot does not exist"
    curl $(curl 'https://mainnet-data.thetatoken.org/snapshot') --output guardian/node/snapshot
    curl $(curl 'https://mainnet-data.thetatoken.org/config?is_guardian=true') --output guardian/node/config.yaml
else
    echo "snapshot does exist"
fi

# standalone docker or docker-compose will mount here: /run/secrets/gn-signing-key-password
# docker-compose uses /run/secrets to mount secrets
if [[ ! -f /run/secrets/gn-signing-key-password ]] && [[ ! -f /secrets/gn-signing-key-password ]]; then
    echo "The password for the signing key was not found!"
    exit 1
elif [[ -f /run/secrets/gn-signing-key-password ]]; then
    # cat the key to a common area regardless of how we were invoked
    cat /run/secrets/gn-signing-key-password > ~/.gn-signing-key-password
else # /secrets is used for k8s and cannot use compose location
    cat /secrets/gn-signing-key-password > ~/.gn-signing-key-password
fi

# start the guardian node
./bin/theta start --config=guardian/node --password "$(cat ~/.gn-signing-key-password)"
