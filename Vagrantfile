# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "netmidas/nmbasebox"
<<<<<<< HEAD
    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.hostname = "nmrocket"
    config.vm.synced_folder ".", "/var/www/netmidas/", :mount_options => ["dmode=777", "fmode=666"]
=======
    config.vm.network "private_network", ip: "192.168.33.25"
    config.vm.hostname = "netmidas"
    config.vm.synced_folder ".", "/var/www/html/netmidas", :mount_options => ["dmode=777", "fmode=666"]

    config.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end
>>>>>>> c901289f11034500b61399c3c275fe11c9cbac2b

    config.vm.provision "shell",
        path: "provisioning/bootstrap.sh"

<<<<<<< HEAD

    # Optional NFS. Make sure to remove other synced_folder line too
    #config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

=======
>>>>>>> c901289f11034500b61399c3c275fe11c9cbac2b
end
