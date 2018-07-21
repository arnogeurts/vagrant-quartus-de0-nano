# vagrant-quartus-de0-nano
A Vagrant box which installs Quartus with JTAG for the DE0-Nano development board

## Prerequisites

- Vagrant
- Virtualbox

## Running the box
Clone the repository to your local machine.
Just run:
```
vagrant up
```

This will start an Ubuntu VM and starts downloading and installing Quartus (6.3GB so this might take a while). It will set up a systemd service for JTAGD, so it will run as root in the background.

It will attach the DE0-Nano USB device to the VM and makes sure it is accessible by JTAG.
