Vagrant.configure("2") do |config|
    config.vm.box = "centos/8"
    config.vm.network "forwarded_port", guest: 80, host: 80
    config.vm.network "private_network", ip: "172.42.42.100"
  end

# https://computingforgeeks.com/use-vagrant-with-libvirt-kvm-on-centos/ <- work with libvert