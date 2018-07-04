wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
yum -y install zlib zlib-devel
yum -y install bzip2 bzip2-devel
yum -y install ncurses ncurses-devel
yum -y install readline readline-devel
yum -y install openssl openssl-devel
yum -y install openssl-static
yum -y install xz lzma xz-devel
yum -y install sqlite sqlite-devel
yum -y install gdbm gdbm-devel
yum -y install tk tk-devel
yum -y install gcc
yum install libffi-devel -y
tar -xvzf Python-3.7.0.tgz
cd Python-3.7.0
./configure --prefix=/usr/python --enable-shared CFLAGS=-fPIC
make && make install
ln -s /usr/python/bin/python3 /usr/bin/python3
ln -s /usr/python/bin/pip3 /usr/bin/pip3
cd  /etc/ld.so.conf.d
echo '/usr/python/lib'>> python3.conf
ldconfig
pip3 install pyutil
pip3 install paramiko
pip3 install fabric
pip3 install requests
pip3 install pymysql
