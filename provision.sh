#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get -y install build-essential zlib1g-dev
cd /tmp

if convert -list format | grep libpng >/dev/null 2>&1; then
    echo "> libpng is already installed"
else 
    echo "> Download the libpng package"
    wget -q --show-progress --progress=dot:mega https://netcologne.dl.sourceforge.net/project/libpng/libpng12/1.2.59/libpng-1.2.59.tar.gz
    
    echo "> Extract the libpng package"
    tar zvxf libpng-1.2.59.tar.gz
    cd libpng-1.2.59
    
    echo "> Install libpng"
    ./configure --prefix=/usr/local
    make
    make install
    ldconfig
    
    echo "> Clean up afterwards"
    cd /tmp
    rm -Rf /tmp/libpng*
    
    echo "> Successfully installed libpng" 
fi

if command -v quartus >/dev/null 2>&1; then
    echo "> Quartus is already installed"
else 
    VERSION=18.0.0.614
    DOWNLOAD_URL=http://download.altera.com/akdlm/software/acdsinst/18.0std/614/ib_tar/Quartus-lite-${VERSION}-linux.tar

    mkdir /tmp/quartus
    cd /tmp/quartus

    if [ ! -f Quartus-lite-${VERSION}-linux.tar ] && [ ! -f ./components/QuartusLiteSetup-${VERSION}-linux.run ]; then
	    echo "> Download the Quartus package"
        wget -q --show-progress --progress=dot:mega ${DOWNLOAD_URL}
    fi

    if [ -f  Quartus-lite-${VERSION}-linux.tar ]; then
	    echo "> Extract and remove the Quartus package"
        tar xvf Quartus-lite-${VERSION}-linux.tar
        rm -Rf Quartus-lite-${VERSION}-linux.tar
    fi

    echo "> Install Quartus"
    ./components/QuartusLiteSetup-${VERSION}-linux.run \
        --mode unattended \
        --unattendedmodeui none \
        --installdir /usr/local/quartus/ \
        --disable-components quartus_help,modelsim_ase,modelsim_ae \
        --accept_eula 1

    export PATH=/usr/local/quartus/quartus/bin:$PATH
    echo 'export PATH=/usr/local/quartus/quartus/bin:$PATH' >> /etc/bash.bashrc

    echo "> Clean up afterwards"
    cd /tmp
    rm -Rf /tmp/quartus
    
    echo "> Successfully installed Quartus"    
fi

if [ -f /etc/udev/rules.d/40-altera-usbblaster.rules ]; then 
    echo "> DE0-Nano is already in udev rules"
else
	echo "> Adding DE0-Nano to udev rules"
	echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6001\", OWNER=\"vagrant\", GROUP=\"vagrant\", MODE=\"0666\", SYMLINK+=\"usbblaster\"" > /etc/udev/rules.d/40-altera-usbblaster.rules
	udevadm control --reload
    echo "> Successfully added DE0-Nano to udev rules" 
fi

if [ -f /etc/systemd/system/jtagd.service ]; then 
	echo "> systemd file for jtagd already exists"
else
	echo "> Creating systemd file jtagd"

	tee /etc/systemd/system/jtagd.service <<EOF 
#! /bin/sh
[Unit]
Description=JTAGD

[Service]
ExecStart=/usr/local/quartus/quartus/bin/jtagd --foreground
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl enable jtagd.service
    systemctl daemon-reload
    systemctl restart jtagd.service
	
    echo "> Successfully created systemd file for jtagd"
fi 


