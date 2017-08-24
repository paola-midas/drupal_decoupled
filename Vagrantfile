# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "netmidas/nmbasebox"
    config.vm.network "private_network", ip: "192.168.33.25"
    config.vm.hostname = "netmidas"
    config.vm.synced_folder ".", "/var/www/html/netmidas", :mount_options => ["dmode=777", "fmode=666"]

    config.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end

    config.vm.provision "shell",
        path: "provisioning/bootstrap.sh"

end
