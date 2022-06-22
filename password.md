Here is link to the Theta Guardian Node installation document regarding the password:

https://docs.thetatoken.org/docs/running-a-guardian-node-through-command-line#2-launch-the-guardian-node

If you are looking for a quick online password generator, here is one I have used over the years: https://passwordsgenerator.net/

## Docker/Docker-Compose Installations

If you are using either a docker/docker-compose installation, create a password
of your choosing (I'm not sure on the length but i've tested with up to 20 characters).

By default, both `docker/docker-compose` installations look for the password file in `${HOME}/.gn.signing.key.password`. You can create the password as follows:

>echo -n '\<password>' > ${HOME}/.gn.signing.key.password

## Kubernetes Deployment

We will create a password for our deployment, so open the `theta.guardian.secret.yaml` file in your favorite editor.

1. Create a password (up to 20 characters I have tested)
2. Run the following to create a base64 encoded password
    1. `echo -n "<password>" | base64`
3. Replace the value of `gn-signing-key-password` with your new, encoded, password