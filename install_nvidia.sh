wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install  kernel-headers -y
header_count=`rpm -qa|grep kernel-headers|grep '3.10.0-862'|wc -l`
count=`uname -r|grep '3.10.0-862'|wc -l`
if [ $count -eq 0 -a $header_count -eq 1 ];then
	yum update -y kernel
	reboot
fi
if [ ! -f /usr/local/nouveau_exist ];then
	yum install kernel-devel kernel-doc kernel-headers -y
	echo 'blacklist nouveau' >> /usr/lib/modprobe.d/dist-blacklist.conf
	echo 'options nouveau modeset=0' >> /usr/lib/modprobe.d/dist-blacklist.conf   
	mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak	
	dracut /boot/initramfs-$(uname -r).img $(uname -r)
	touch /usr/local/nouveau_exist
	reboot
fi

if [ ! -f /usr/local/status ];then
	nvi_count=`rpm -qa|grep nvidia|wc -l`
	if [ $nvi_count -ne 0 ];then 
		rpm -qa|grep nvidia|xargs rpm -e 
	fi
	if [ -f nvidia-diag-driver-local-repo-rhel7-396.26-1.0-1.x86_64.rpm ];then
		rpm -ivh nvidia-diag-driver-local-repo-rhel7-396.26-1.0-1.x86_64.rpm
	else
		echo 'nvidia-diag-driver-local-repo-rhel7-396.26-1.0-1.x86_64.rpm is not exist!'
	fi
	yum clean all
	yum install dkms -y
	yum install cuda-drivers -y
	smi_count=`nvidia-smi|grep P40|wc -l`
	if [ $smi_count -ne 0 ];then
		echo 'finish' > /usr/local/status
	fi
fi
