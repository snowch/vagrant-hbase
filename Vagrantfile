Vagrant.configure("2") do |config|

  config.vm.box     = "ubuntu-14.04"

  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.hostname = "trusty64"

  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.provision "shell", path: "desktop_setup.sh", privileged: false

end

