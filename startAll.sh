if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
  else
    echo 'Starting all VMs'
    for i in $(virsh list --all --name --autostart);
    do virsh start "$i";
    done
fi
