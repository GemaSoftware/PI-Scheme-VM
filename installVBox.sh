#!/bin/bash

download_image_and_fix () {
  FILE="images/1.qcow2"
  FILE2="images/1.img"
  mkdir tmp
  if [ ! -f "$FILE" ]; then
    if [ ! -f "$FILE2" ]; then
      wget --load-cookies /tmp/cookies.txt \
      "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ" -O 1.img && \
      rm -rf /tmp/cookies.txt
      download_image_and_fix
    else
      qemu-img convert -f raw -O qcow2 images/1.img images/1.qcow2
      rm -rf images/1.img
    fi
  fi
}

install_network_vm () {
  main_interface=$(ip route get 8.8.8.8 | awk -- '{printf $5}')
  mkdir -p tmp
  mkdir -p images
  cp VMTemplates/WithinVM/NET_TEMPLATE.xml tmp/net.xml
  sed -i "s,NET_IFACE,$main_interface,g" tmp/net.xml
  ifaceip=$(ip -f inet addr show $1 | grep -o "inet [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*")
  echo "$ifaceip"
  cp VMTemplates/WithinVM/IFACE_TEMPLATE.xml tmp/iface.xml
  sed -i "s,IFACE_CURRIP,$ifaceip,g" tmp/iface.xml
  sed -i "s,IFACE_CURRIFACE,$1,g" tmp/iface.xml
  cp VMTemplates/WithinVM/VM_TEMPLATE.xml tmp/vm.xml
  sed -i "s|VM_FOLDER|$PWD/PI-Files|g" tmp/vm.xml
  sed -i "s|VM_IMAGE_FOLDER|$PWD/images|g" tmp/vm.xml
  sed -i "s|QEMU_NUM|1|g" tmp/vm.xml
  sed -i "s|QEMU_MAC|52:54:00:a0:cc:19|g" tmp/vm.xml
  sed -i "s|MACADDR1|52:54:00:89:5a:36|g" tmp/vm.xml
  virsh iface-define tmp/iface.xml
  virsh iface-start br1
  virsh net-define tmp/net.xml
  virsh net-start net1
  virsh net-autostart net1
  virsh define tmp/vm.xml
  virsh autostart rpi1
  virsh start rpi1
  rm -rf tmp/net.xml
  rm -rf tmp/vm.xml
  rm -rf tmp/iface.xml
  rm -rf tmp

}

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
  else
    ETH=$1

    if [ -z "$ETH" ]
    then
	echo "Did not add ethernet address as argument. Read doc and try again"
    else
    download_image_and_fix
    install_network_vm "$ETH"
    fi
fi
