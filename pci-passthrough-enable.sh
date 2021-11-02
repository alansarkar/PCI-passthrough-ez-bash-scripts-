#!/bin/bash
Gpuid=lspci -nn  | grep nvidia  -i  | cut  -d ' '  -f 15 | sed 's/\[//g;s/\]//g'
Gupid1= `echo "$Gpuid" |  cut -d ':' -f 1`
Gupid2= `echo "$Gpuid" |  cut -d ':' -f 2`

echo following files will be created or overwritten if exists:
echo /etc/modprobe.d/vfio.conf kvm.conf blacklist.conf
echo do you want to continue ?? y/n
read var;
if [ $var = 'y' ]
then
#GPU=$(lspci -nn | grep NVI | cut -d' ' -f11 | sed 's/\[//g;s/\]//g')

cat << EOF > /etc/modprobe.d/vfio.conf

options vfio-pci ids="$Gupid"
options vfio-pci disable_vga=1
EOF
#sed 's/10de:139b/$GPU/g' /etc/modprobe.d/vfio.conf


cat << EOF > /etc/modprobe.d/kvm.conf
options kvm ignore_msrs=1
EOF

cat << EOF > /etc/modprobe.d/blacklist.conf
blacklist nouveau
EOF

modprobe vfio
modprobe vfio_iommu_type1
modprobe vfio_pci
modprobe vfio_virqfd 
modprobe kvm
modprobe kvm_intel
fi
#echo "$x" > "/sys/bus/pci/drivers/vfio-pci/new_id"
echo "######## noroot permission ############"
echo "do u want to run the vm as current user y/n??"
read  z;

if  [ $z -eq 'y' ]
then
cat << EOF > /etc/udev/rules.d/10-qemu-hw-users.rules
SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
SUBSYSTEM=="usb", ATTR{idVendor}=="$Gupid1", ATTR{idProduct}=="$Gupid2" OWNER="root", GROUP="kvm"
SUBSYSTEM=="usb", ATTR{idVendor}=="$Gupid1", ATTR{idProduct}=="$Gupid2" OWNER="root", GROUP="kvm"
EOF

#if [[ $(grep "soft memlock"  /etc/security/limits.conf ) -eq NULL  ]] 
#then

echo "$USER soft memlock 5000000" >> /etc/security/limits.d/limits.conf
echo "$USER hard memlock 5000000"  >>  /etc/security/limits.d/limits.conf

fi


if [ $z != 'y' ]
then
	echo "exiting wont be able to execute vm without root ";
fi

echo "do u want the script to update your grub  and enable iommu y/n ?"
read z1;
if [ $z1 -eq 'y' ]	
then
 sed 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt rd.driver.pre=vfio-pci /g' -i /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg 
fi
#else

#	echo " exiting wont update grub" ;
#fi
