## Vagrant HBase Development Environment

### Overview

This environment sets up a completely self contained HBase development environment with eclipse and Ubuntu XFCE.

The guest desktop can be connected to using Microsoft Remote Desktop Client or rdesktop (from *nix).

### Setup the guest

- ```git clone https://github.com/snowch/vagrant-hbase.git```
- ```cd vagrant-hbase```
- next proceed to *Starting the guest*

### Starting the guest

- ```vagrant up```
-  next proceed to *Logging into the guest*

### Logging into the guest

After ```vagrant up``` Use Microsoft Remote Desktop Client or rdesktop to connect to:

- hostname: 192.168.50.4
- username: vagrant
- password: vagrant

Note: the first time you connect may take a while for the desktop to be setup.

When you see the prompt: ```Welcome to the first start of the panel```, click ```Use default config```.

- next proceed to *Running hbase*

### Running hbase

- Open a terminal
- enter ```start-hbase.sh``` followed by [enter]

### Run the hbase commmand line

- TODO

### Run some java client code

- TODO

### Shutting down the guest

- ```vagrant halt```

### Destroy the guest

Warning: This removes all traces of your changes in the guest.

- vagrant destroy

### Starting HBase




