#/bin/bash
#禁止root登入
cd /etc/ssh/
echo "你输入的普通用户并赋予root权限是 $admin"
read admin
echo "你输入的普通用户的密码是 $sec"
read sec

useradd -s /bin/sh -d /home/$admin $admin
echo "$sec"|passwd --stdin $admin

sed  -i '/^root/a\$admin   ALL=(ALL)       ALL' /etc/sudoers

sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

cat /etc/ssh/sshd_config|grep PermitRootLogin

systemctl restart sshd

#修改同步服务器时间
# update time!
yum -y install ntpdate

echo "请稍微正在同步北京时间，需要十秒左右" 
ntpdate asia.pool.ntp.org 

cp -rf  /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "yes"
