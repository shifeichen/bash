#/tmp/install_nvidia.sh
#env is after /etc/rc.local,please notice!
echo 'nameserver 114.114.114.114'> /etc/resolv.conf
if [ ! -f /etc/yum.repos.d/epel.repo -o ! -f /etc/yum.repos.d/CentOS-Base.repo ];then
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
fi

kernel_headers_count=`rpm -qa|grep kernel-headers|wc -l`
kernel_devel_count=`rpm -qa|grep kernel-devel|wc -l`
kernel_doc_count=`rpm -qa|grep kernel-doc|wc -l`
if [ $kernel_headers_count -eq 0 -o $kernel_devel_count -eq 0 -o $kernel_doc_count -eq 0  ];then
   yum install  kernel-headers  kernel-devel kernel-doc -y
fi

headers_str=`rpm -qa|grep kernel-headers|awk -F '-' '{print $3"-"$4}'`
kernel_str=`uname -r`
if [ "$headers_str" != "$kernel_str" ];then
	echo 'update kernel and kernel headers'
	yum install  kernel-headers -y
	yum update -y kernel
	echo '/usr/bin/sh /tmp/install_nvidia.sh' >> /etc/rc.local
	reboot
fi

if [ ! -f /usr/local/nouveau_exist ];then
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
	if [ -f ~/nvidia-diag-driver-local-repo-rhel7-396.26-1.0-1.x86_64.rpm ];then
		rpm -ivh ~/nvidia-diag-driver-local-repo-rhel7-396.26-1.0-1.x86_64.rpm
	else
		echo '~/nvidia-diag-driver-local-repo-rhel7-396.26-1.0-1.x86_64.rpm is not exist!'
	fi
	yum clean all
	yum install dkms -y
	yum install cuda-drivers -y
	smi_count=`nvidia-smi|grep P40|wc -l`
	if [ $smi_count -ne 0 ];then
		echo 'finish' > /usr/local/status
		sed -i '/\/usr\/bin\/sh install_nvidia.sh/d' /etc/rc.local
	fi
fi
