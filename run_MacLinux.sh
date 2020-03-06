#!/bin/bash

download_vm () {
	wget --load-cookies /tmp/cookies.txt \
	"https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ" -O 1.img && \
	rm -rf /tmp/cookies.txt
	run_vm
}

run_vm () {
file="/usr/bin/qemu-system-arm"
if [ -f "$file" ]
then
        echo "$file found."
	qemu-system-arm \
	-M versatilepb \
	-cpu arm1176 \
	-m 256 \
	-hda ~/Desktop/1.img \
	-net nic -net user,hostfwd=tcp::5022-:22 \
	-dtb "./versatile-pb.dtb" \
	-kernel ~/Downloads/kernel-qemu-4.14.79-stretch \
	-append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
	-no-reboot 
else
        echo "QEMU not found! Install QEMU - go to github site for instructions"
fi

}


file="./1.img"
if [ -f "$file" ]
then
	echo "$file found."
	run_vm
else
	echo "$file - Image not found. Downloading Raspbian Image"
	download_vm
fi


