Vagrant.configure("2") do |config|

  config.vm.box     = "ubuntu-14.04x64"

  config.vm.hostname = "trust64"

  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.provision "shell", path: "provision.sh", privileged: false

end

