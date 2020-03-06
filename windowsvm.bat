qemu-system-arm -M versatilepb -cpu arm1176 -m 256 -hda "./1.img" -net nic -net user,hostfwd=tcp::5022-:22 -dtb "./versatile-pb.dtb" -kernel "./qemukernel" -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -no-reboot

