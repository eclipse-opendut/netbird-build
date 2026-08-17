# Vagrant VM for testing NetBird client

This folder contains a Vagrantfile to create a VM for testing the NetBird client.
It installs the same versions as used in the CI of the NetBird master branch:
* go version
* protobuf version
See [playbook](playbook.yml) for details.


## Set up

```shell
cd vm
vagrant up
vagrant ssh
```

* Ensure versions are correct:

```shell
vagrant ssh --command "go version; protoc --version"
```

## Synchronize code

* Create ssh config for vagrant vm. Make sure the file is actually included. 
See also [here](https://superuser.com/questions/247564/is-there-a-way-for-one-ssh-config-file-to-include-another-one) for more details.
    ```shell
    grep -F 'Include config.d/*.ssh' ~/.ssh/config
    if [ $? -ne 0 ]; then
        echo "Update your ssh config with the following line for this to work:"
        echo "Include config.d/*.ssh"
    fi
    ```
* Place the ssh config for the vagrant vm in `~/.ssh/config.d/netbird.ssh`:
    ```shell
    cd vm
    mkdir -p ~/.ssh/config.d
    vagrant ssh-config --host=netbird > ~/.ssh/config.d/netbird.ssh
    ```
* Synchronize code to the VM.
    ```shell
    rsync --delete -aP ../netbird/ vagrant@netbird:~/netbird/
    ```

* Alternative to use the port method and connect to localhost substitute the port number in the command below
    ```shell
    vagrant port
    rsync --delete -aP -e 'ssh -p2200 -i ~/.ssh/id_rsa' ../netbird/ vagrant@localhost:~/netbird/
    ```
