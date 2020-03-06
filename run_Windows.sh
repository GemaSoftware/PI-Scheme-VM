#!/bin/bash

download_vm () {
	wget --load-cookies /tmp/cookies.txt \
	"https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ" -O 1.img && \
	rm -rf /tmp/cookies.txt
	run_vm
}

download_vm_mac () {
        wget --load-cookies /tmp/cookies.txt \
        "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ' -O- | gsed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1tdo7FqnPMrcZhabWKdydcmXToHjnW1BZ" -O 1.img && \
        rm -rf /tmp/cookies.txt
        run_vm_mac
}

run_vm_windows () {
file="C:\Program Files\qemu\qemu-system-arm.exe"
if [ -f "$file" ]
then
        echo "$file found."
	./windowsvm.bat
else
        echo "QEMU not found! Install QEMU - go to github site for instructions"
fi

}

if [ "$(uname)" == "Darwin" ]; then
    echo "On MAC"        
	if [ ! -L "/usr/local/bin/brew" ]
	then
	  echo "Brew not Installed. Aborting"
	else
	  if [ ! -L "/usr/local/bin/gsed" ]
	  then
	    echo "GNU-sed not installed. Installing right now. Then run again."
	    brew install gnu-sed
	  else
	    	file="./1.img"
        	if [ -f "$file" ]
        	then
          	  echo "$file found."
          	  run_vm_mac
        	else
          	  echo "$file - Image not found. Downloading Raspbian Image"
          	  download_vm_mac
        	fi
	  fi
	fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	file="./1.img"
	if [ -f "$file" ]
	then
	  echo "$file found."
          run_vm
  	else
          echo "$file - Image not found. Downloading Raspbian Image"
          download_vm
  	fi
elif [ "$(expr substr $(uname -s) 1 7)" == "MINGW64" ]; then
        file="./1.img"
        if [ -f "$file" ]
        then
          echo "$file found."
          run_vm_windows
        else
          echo "$file - Image not found. Downloading Raspbian Image"
          download_vm
        fi
fi

