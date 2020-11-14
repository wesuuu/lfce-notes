Vagrant.configure("2") do |config|
    config.vm.provision "shell", path: "provision.sh"

    config.vm.define "centos0" do |c|
      c.vm.box = "centos/8"
      c.vm.hostname = "centos0.com"
      c.vm.network "private_network", ip: "172.42.42.100"
      c.vm.provision "shell", path: "provision-0.sh"
    end

    config.vm.define "centos1" do |c|
      c.vm.box = "centos/8"
      c.vm.hostname = "centos1.com"
      c.vm.network "private_network", ip: "172.42.42.101",
        auto_config: false
      c.vm.network "private_network", ip: "10.20.0.10",
        auto_config: false
      c.vm.provision "shell", path: "provision-1.sh"
    end

    config.vm.define "centos2" do |c|
      c.vm.box = "centos/8"
      c.vm.hostname = "centos2.com"
      c.vm.network "private_network", ip: "10.20.0.11",
        auto_config: false
      c.vm.provision "shell", path: "provision-2.sh"
    end
  end

# https://computingforgeeks.com/use-vagrant-with-libvirt-kvm-on-centos/ <- work with libvert
