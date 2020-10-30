Vagrant.configure("2") do |config|
    config.vm.box = "bento/centos-8"
    # config.vm.network "private_network", ip: "192.168.4.200"
    config.vm.network "forwarded_port", guest: 80, host: 80
  end