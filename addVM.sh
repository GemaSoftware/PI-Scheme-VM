#!/bin/bash
a="$(virsh list --all --name | sed 's/[A-Za-z]*//g')"
b="$(echo "$a" | tail -n 1)"

clone_vm () {
  virsh destroy rpi1
  next="$(($b + 1))"
  echo "$next"
  namenew="rpi$next"

  virt-clone \
  --original rpi1 \
  --name "rpi$next" \
  --file "$next".qcow2 \
  --mac RANDOM
  virsh autostart "$namenew"

}

add_to_net () {
  nextnum="$(($b + 1))"
  nextip="$(($b + 2))"
  namenew="rpi$nextnum"
  host=".local"

  hostname=$namenew$host
  ipnew="192.168.100.$nextip"
  mac="$(sudo virsh dumpxml $namenew | grep -i '<mac' | cut -d \' -f 2)"

  virsh net-update --config --live net0 add ip-dhcp-host \
    "<host mac='$mac' name='$namenew' ip='$ipnew'/>"

  virsh net-update --config --live net0 add dns-host \
    "<host ip='$ipnew'><hostname>$namenew.local</hostname></host>"

}


if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
  else
    clone_vm
    add_to_net
    service libvert-guests stop
    service libvirt-guests start

fi
