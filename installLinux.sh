#!/bin/bash

download_image_and_fix () {
  $FILE=1.qcow2
  $FILE2=1.img
  if [! -f "$FILE"]; then
    if [! -f "$FILE2"]; then
      wget --load-cookies /tmp/cookies.txt \
      "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ" -O 1.img && \
      rm -rf /tmp/cookies.txt
    else
      qemu-img convert -f raw -O qcow2 1.img 1.qcow2
      rm -rf 1.img
    fi
  fi
}

install_network_vm () {
  main_interface=$(ip route get 8.8.8.8 | awk -- '{printf $5}')
  mkdir tmp
  cp netTemplate.xml tmp/net.xml
  sed -i "s,QEMU_NET,$main_interface,g" tmp/net.xml
  sed -i "s,QEMU_DNSHOSTNAME,192.168.100.2,g" tmp/net.xml
  sed -i "s,<placeholder/>,<host mac='52:54:00:a0:cc:19' name='rpi1' ip='192.168.100.2'/>\n    <placeholder/>,g" tmp/net.xml
  cp vmTemplate.xml tmp/vm.xml
  sed -i "s|QEMU_PATH|$PWD|g" tmp/vm.xml
  sed -i "s|QEMU_NUM|1|g" tmp/vm.xml
  sed -i "s|QEMU_MAC|52:54:00:a0:cc:19|g" tmp/vm.xml
  virsh net-define tmp/net.xml
  virsh net-start net0
  virsh net-autostart net0
  virsh define tmp/vm.xml
  virsh autostart rpi1
  virsh start rpi1
  rm -rf tmp/net.xml
  rm -rf tmp/vm.xml
  rm -rf tmp

}

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
  else
    download_image_and_fix
    install_network_vm
fi
