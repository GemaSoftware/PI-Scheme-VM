# PI-Scheme-VM
Tools to run a VM consisting of Raspbian, SISC, and OpenJDK8

Clone Link: https://github.com/GemaSoftware/PI-Scheme-VM.git

## In order to run this VM, you will need to install:

- QEMU [Download](https://www.qemu.org/download/)
- Brew if on Mac [Download](https://brew.sh/)
- Gnu Sed if on Mac "Brew Download - brew install gnu-sed"

## If on Windows, I recommend also downloading the following packages to be able to run the script file instead of manually pasteing it in (Still working on script):

- WGet for Windows [Download](http://gnuwin32.sourceforge.net/packages/wget.htm)

# Running VM via Scripts

First clone this repository to a folder of your choosing and then run the command:
```
./run_Maclinux.sh (Mac or Linux)
./run_Windows.bat (Windows) IN PROGRESS
```


# Running VM Manually (without scripts)

- Download the updated Raspbian image and save it as "1.img" in the folder you cloned earlier. Remember the path of the folder. It is needed later.
  - [Direct Download to Image - Google Drive](https://drive.google.com/a/uconn.edu/uc?id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ&export=download)

- Open up the command prompt and cd into the folder you cloned. Once in that folder, paste the following command and press Enter:
```
qemu-system-arm -M versatilepb -cpu arm1176 -m 256 -hda "./1.img" -net nic -net user,hostfwd=tcp::5022-:22 -dtb "./versatile-pb.dtb" -kernel "./qemukernel" -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -no-reboot
```




