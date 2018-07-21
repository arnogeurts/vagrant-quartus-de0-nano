# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "learningchef/ubuntu1604-desktop"
  config.disksize.size = "50GB"

  # Add a synced folder for mounting your projects into the VM
  # config.vm.synced_folder "../projects", "/projects"

  config.vm.provision "shell", path: "provision.sh"
  
  config.vm.provider "virtualbox" do |v|
      v.gui = true
      v.memory = "4096"
      v.cpus = 2

      v.customize ["modifyvm", :id, "--usb", "on"]
      v.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'DE0-Nano', '--vendorid', '0x09fb', '--productid', '0x6001']
  end
end
