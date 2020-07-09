#!/bin/sh

echo "
do you want to remove everything y/n ??


 following files will be removed :
1. /etc/modprobe.d/vfio.conf 
2. /etc/modprobe.d/kvm.conf
3. /etc/modprobe.d/blacklist.conf
4. /etc/udev/rules.d/10-qemu-hw-users.rules

following files will be edited:
/etc/default/grub /etc/security/limites.conf

enter 1 to start press any key to exit
"

read x;

if [ $x -eq 1 ]
then
	rm -rf /etc/modprobe.d/vfio.conf /etc/modprobe.d/kvm.conf /etc/modprobe.d/blacklist.conf /etc/udev/rules.d/10-qemu-hw-users.rules 
sed 's/.*soft memlock.*//g' -i  /etc/security/limits.conf 
sed 's/.*hard memlock.*//g' -i /etc/security/limits.conf 
 sed 's/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt rd.driver.pre=vfio-pci /GRUB_CMDLINE_LINUX_DEFAULT="/g' -i /etc/default/grub
#grub-mkconfig -o /boot/grub/grub.cfg 

fi
