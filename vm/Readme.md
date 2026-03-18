# Vagrant VM for testing NetBird client

This folder contains a Vagrantfile to create a VM for testing the NetBird client.
It installs the same versions as used in the CI of the NetBird master branch:
* go version
* protobuf version
See [playbook](playbook.yml) for details.


## Set up

```shell
vagrant up
vagrant ssh
```

## Synchronize code

```shell
vagrant port
# substitute the port number in the command below
rsync --delete -aP -e 'ssh -p2200 -i ~/.ssh/id_rsa' ../netbird/ vagrant@localhost:~/netbird/
```
