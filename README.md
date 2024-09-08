# Maya in Linux

Here i have collected notes and materials for getting Maya with GUI to run in Linux.

## Status

| Status   | Type | Notes |
| ------   | ---- | ----- |
| &#9989;  | VM Rocky 9.3 - Maya 2025 | Starts |
| &#9989;  | VM Ubuntu 22.04 - Maya 2024 | Starts |
| &#10060; | VM Ubuntu 22.04 - Maya 2025 | Fails, can't find WebView2 at login |
| &#10060; | Docker Ubuntu 22.04 - Maya 2024 | Fails, have to check why |
| &#10060; | Docker Rocky 9.3 - Maya 2025 | Fails, some kind of timeout |


## Virtual machine based

I used virtual machines (VMs) for testing the different combinations of operating system and Maya.

### VM creation

```bash
# download linux iso
wget https://dl.rockylinux.org/vault/rocky/9.3/live/x86_64/Rocky-9.3-MATE-x86_64-20240217.0.iso

# create virtual harddrive
qemu-img create -f qcow2 "Rocky-9.3-MATE-x86_64-20240217.0.img.qcow2" 100G

# the first time, start VM with the created harddrive and iso as cdrom
qemu-system-x86_64 -cdrom Rocky-9.3-MATE-x86_64-20240217.0.iso -drive "file=Rocky-9.3-MATE-x86_64-20240217.0.img.qcow2,format=qcow2" -enable-kvm -m 16G -smp 8 -cpu host

# after installation is complete, shut the VM down and start it again without the iso mounted
qemu-system-x86_64 -drive "file=Rocky-9.3-MATE-x86_64-20240217.0.img.qcow2,format=qcow2" -enable-kvm -m 16G -smp 8 -cpu host
```

Once in the VM, run the script from this repo that is associated to the OS and Maya combination you want, and it should install everything needed to start Maya.



## Docker based

Unfortunatley Autodesk does not supply their own Docker/Flatpak/Snap image, which would save us all from the complicated installation procedures.

I have not succeeded in creating one myself, yet. The walls I've hit are always related to licensing and logging in. The initial login window pops up, promting you to either login using your Autodesk account, enter a serial number, or to use a network licensing server.

On the ubuntu based docker image, it fails because it can't find WebView2, a Microsoft developed package that is not yet released for linux. 

The Rocky based image times out when trying to connect to the licensing server. Will have to dig deeper and see if there are any system packages or services that differ compared to the VM based install that works.

```bash

# install nvidia toolkit                                                                
sudo apt intall nvidia-container-toolkit
# or, depening on your host os
sudo pamac install nvidia-container-toolkit
sudo systemctl restart docker

# go to the docker folder
cd docker

# build the image, adjust tag and dockerfile if needed
docker buildx build --progress=plain -t maya:2025 -f Dockerfile_rocky9.3-2025 .

# enable access to the xserver from the container
xhost +local:docker
# and/or? have to check later
xhost +local:$USER

# start the image, adjust tag if needed
docker run -it --rm --gpus=all -e DISPLAY -v "$HOME/.Xauthority:/root/.Xauthority:rw" -v /tmp/.X11-unix:/tmp/.X11-unix maya:2025

### inside the container

# start the licensing server
(/opt/Autodesk/AdskLicensing/14.0.0.10163/AdskLicensingAgent/AdskLicensingAgent -i 9be5a8a9-d1d8-4be4-b4c7-e3935f1e6607 --no-gui -c 2 &) ; /usr/bin/AdskLicensingService --run &

# start maya
maya
```


