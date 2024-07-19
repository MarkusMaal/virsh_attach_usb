# Virsh attach/detach USB

A little tool I made in bash, which allows you to attach and detach USB devices to/from Linux virtual machines with single GPU passthrough.


## Attaching a device

1. SSH into the host OS (ssh client in guest is required), e.g. ssh user@192.168.1.21
2. After logging in, navigate to the virsh_attach_usb directory
3. Add execute permissions to attach.sh if they don't exist already with `chmod +x attach.sh` command
4. Run `./attach.sh`
5. Type the number corresponding to the USB device on the list, which you want to attach to a VM and press RETURN
6. Enter your sudo password if prompted
7. Type out the full name of your virtual machine (a list of VMs is also displayed during this step) and press RETURN
8. If everything goes correctly, the device should now be accessible in the VM


## Detaching a device

1. SSH into the host OS (ssh client in guest is required), e.g. ssh user@192.168.1.21
2. After logging in, navigate to the virsh_attach_usb directory
3. Add execute permissions to detach.sh if they don't exist already with `chmod +x detach.sh` command
4. Run `./detach.sh`
5. Type the number corresponding to the USB device on the list, which you want to detach from a VM and press RETURN
6. Enter your sudo password if prompted
7. Type out the full name of your virtual machine and press RETURN
8. If everything goes correctly, the device should get unplugged from guest and be accessible by the host again
