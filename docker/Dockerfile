FROM ubuntu:22.04

LABEL maintainer="causalityloop (github@codeloft.tech)"

ARG USERID=9001

ENV USER='theta'
ENV USERDIR="/home/${USER}"

ENV GUARDIANDIR="${USERDIR}/theta_mainnet"

RUN apt-get update && \
    apt-get install -y --no-install-recommends bash curl ca-certificates qrencode jq && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# sourcing/optimizing install from: https://docs.thetatoken.org/docs/running-a-guardian-node-through-command-line

RUN useradd --uid ${USERID} --create-home --home-dir ${USERDIR} ${USER}

User ${USER}

RUN mkdir -p ${GUARDIANDIR}/{bin,guardian} && \
    mkdir -p ${GUARDIANDIR}/guardian/node

WORKDIR ${GUARDIANDIR}

# url downloads a link file that points to AWS. Both of which have valid SSL certs so we should remove
# -k, per original instructions, which disables SSL cert verification
RUN curl "$(curl 'https://mainnet-data.thetatoken.org/binary?os=linux&name=theta')" --output bin/theta && \
    curl "$(curl 'https://mainnet-data.thetatoken.org/binary?os=linux&name=thetacli')" --output bin/thetacli && \
    chmod +x bin/{theta,thetacli}

COPY bootstrap_gn.sh get_stake_address.sh ${GUARDIANDIR}/

CMD [ "./bootstrap_gn.sh" ]