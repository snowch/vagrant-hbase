## Vagrant HBase Development Environment

### Overview

This environment sets up a completely self contained HBase development environment with eclipse and Ubuntu XFCE.

The guest desktop can be connected to using Microsoft Remote Desktop Client or rdesktop (from *nix).

This environment was intended as a quick start for Windows users who want to play with hbase with minimal effort.

###  Pre-requisites

- Install [Vagrant](https://www.vagrantup.com/downloads.html)
- Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- Approx 1.5 Gb free ram and 10 Gb free disk space
- An Internet connection

### Setup the guest

- ```git clone https://github.com/snowch/vagrant-hbase.git```
- ```cd vagrant-hbase```
- next proceed to *Starting the guest*

### Starting the guest

- ```vagrant up```
-  next proceed to *Logging into the guest desktop*

NOTE: The first run can take quite a few hours while your environment is set up.

### Logging into the guest desktop

After starting the guest ...

- Use Microsoft Remote Desktop Client or rdesktop to connect using:
  - hostname: 192.168.50.4
  - username: vagrant
  - password: vagrant

NOTE: the first time you connect may take a while for the desktop to be setup.

When you see the prompt: ```Welcome to the first start of the panel```, click ```Use default config```.

- next proceed to *Starting hbase*

### Starting hbase

After logging into the guest desktop ...

- Open a terminal (click Application Menu -> Terminal Emulator)
- enter ```start-hbase.sh``` followed by [enter]


### Run the hbase commmand line

After starting hbase ...

- Open a terminal (click Application Menu -> Terminal Emulator)
- enter ```hbase shell``` followed by [enter]
- you can now proceed to enter some hbase shell commands

### Run some java client code

After logging into the guest desktop and starting hbase ...

- Open eclipse (click Application Menu -> Development > Eclipse)
- Click OK to select the default workspace (/home/vagrant/workspace)
- Click on the Workbench icon
- Click Window -> Open Perspective -> Java
- In the package explorer, expand hbase -> src/main/java -> hbase
- Right click Main.java
- Select Run As -> Java Application
- The code creates a table 'users'

### Shutting down the guest

When you are ready to finish playing with hbase ...

- ```vagrant halt```

When you want to play again, cd back the ```vagrant-hbase``` folder the steps from *Starting the guest*

### Destroy the guest

When you are finished with this environment and want to destroy it ...

- ```vagrant destroy```

WARNING: This removes all traces of your changes in the guest.

