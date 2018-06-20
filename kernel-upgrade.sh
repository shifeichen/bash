#! /bin/bash
#info: update the kernel to 4.14.49
#author: chenshifei
#date: 2018-06-20
count=`uname -r|grep '4.14.49'|wc -l`
if [ $count -eq 0 ];then
	if [ -f kernel-4.14.49-1.x86_64.rpm ];then 
		rpm -ivh kernel-4.14.49-1.x86_64.rpm
	else
		echo "kernel-4.14.49-1.x86_64.rpm is not exist"
		exit
	fi
	
	if [ -f kernel-devel-4.14.49-1.x86_64.rpm ];then
		rpm -ivh kernel-devel-4.14.49-1.x86_64.rpm
	else
		echo "kernel-devel-4.14.49-1.x86_64.rpm is not exist"
		exit
	fi
	sed -i 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/g' /etc/default/grub
	grub2-mkconfig -o /boot/grub2/grub.cfg
	reboot
else
	echo "kernel 14.14.49 is already installed"
fi

