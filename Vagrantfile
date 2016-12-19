# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "netmidas/nmbasebox"
    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.hostname = "nmrocket"
    config.vm.synced_folder ".", "/var/www/netmidas/", :mount_options => ["dmode=777", "fmode=666"]

    config.vm.provision "shell",
        path: "provisioning/bootstrap.sh"


    # Optional NFS. Make sure to remove other synced_folder line too
    #config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

end
