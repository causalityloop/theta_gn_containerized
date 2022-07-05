#!/usr/bin/env bash

# we need to check if the GN is ready. According to the documentation, once the GN has
# finished syncing we can then get the GN Node Holder (Summary)
# https://docs.thetatoken.org/docs/running-a-guardian-node-through-graphical-user-interface#download-the-installation-file

# check the Guardian status. If the 'syncing' field is 'false', we are ready. If not,
# then inform user and exit
# https://docs.thetatoken.org/docs/running-a-guardian-node-through-command-line#2-launch-the-guardian-node

set -u

GN_STATUS="$(./bin/thetacli query status)"

rc=$?

# if we run the cli too soon, after launching, the api service will not be up
if [[ ${rc} -ne 0 ]]; then
    echo "Error running 'thetacli'."
    echo "Output:"
    echo
    echo "${GN_STATUS}"
    echo
    echo "Guardian node API service is likely not up and running."
    echo
    echo "Give it a little more time before running the script again"
    echo
    exit 1
fi

CUR_BLK_HEIGHT="$(jq -r '.current_height' <<< ${GN_STATUS})"
FIN_BLK_HEIGHT="$(jq -r '.latest_finalized_block_height' <<< ${GN_STATUS})"

REMAINING_BLOCKS=$((CUR_BLK_HEIGHT-FIN_BLK_HEIGHT))

SYNCING="$(jq '.syncing' <<< ${GN_STATUS})"

# if the syncing is not complete, inform the user to try again later.
# else, show the user the summary and also encoded as a QR code
if [[ "${SYNCING}" != "false" ]]; then
    echo
    echo "The Guardian node is still syncing."
    echo
    echo "There are still ${REMAINING_BLOCKS} remaining blocks to sync."
    echo
    echo "Once the sync is complete, the holder summary will be shown."
    echo
else
    GN_META="$(./bin/thetacli query guardian)"
    GN_SUMMARY="$(jq -r '.Summary' <<< ${GN_META})"

    echo "Your Guardian Node holder (Summary) to stake your THETA to is:"
    echo
    echo "${GN_SUMMARY}"
    echo
    echo "Similarly, you scan the following QR code:"
    echo
    echo "${GN_SUMMARY}" | qrencode -t ansiutf8 -v 12
    echo
    echo "As with any crypto transaction, verify the scanned holder summary matches above"
fi
