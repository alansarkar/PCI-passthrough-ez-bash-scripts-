#!/bin/sh

echo do you want to remove everything y/n ??
echo following files will be removed :
echo "1. /etc/modprobe.d/vfio.conf "
echo "2. /etc/modprobe.d/kvm.conf" 
echo "3. /etc/modprobe.d/blacklist.conf" 
echo "4. /etc/udev/rules.d/10-qemu-hw-users.rules"
echo following files will be edited
echo /etc/default/grub /etc/security/limites.conf
echo enter 1 to start press any key to exit
read x;

if [ $x -eq 1 ]
then
	rm -rf /etc/modprobe.d/vfio.conf /etc/modprobe.d/kvm.conf /etc/modprobe.d/blacklist.conf /etc/udev/rules.d/10-qemu-hw-users.rules 
sed 's/.*soft memlock.*//g' -i  /etc/security/limits.conf 
sed 's/.*hard memlock.*//g' -i /etc/security/limits.conf 
 sed 's/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt rd.driver.pre=vfio-pci /GRUB_CMDLINE_LINUX_DEFAULT="/g' -i /etc/default/grub
#grub-mkconfig -o /boot/grub/grub.cfg 

fi
