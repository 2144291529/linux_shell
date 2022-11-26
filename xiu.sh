#!/bin/sh
if [ -e "/etc/ssh/sshd_config" ]; then
[ -z "`grep ^Port /etc/ssh/sshd_config`" ] && ssh_port=22 || ssh_port=`grep ^Port /etc/ssh/sshd_config | awk '{print $2}'`

while :
do
echo -n "Please input SSH port(Default: $ssh_port)"
read SSH_PORT
if [ $SSH_PORT -eq $ssh_port ]; then
echo 新端口和默认远程端口一致，请重新输入!
exit
fi

if [ $SSH_PORT -eq 22 ] || [ $SSH_PORT -gt 1024 ] && [ $SSH_PORT -lt 65535 ]; then
break
else
echo "${CWARNING}input error! Input range: 22,1025~65534${CEND}"
exit 65
fi
done

if [ -z "`grep ^Port /etc/ssh/sshd_config`" -a "$SSH_PORT" != '22' ];then
sed -i "s@^#Port.*@&\nPort $SSH_PORT@" /etc/ssh/sshd_config
elif [ -n "`grep ^Port /etc/ssh/sshd_config`" ];then
sed -i "s@^Port.*@Port $SSH_PORT@" /etc/ssh/sshd_config
fi

firewall-cmd --add-port=${SSH_PORT}/tcp --permanent && firewall-cmd --reload
systemctl restart sshd
firewall-cmd --remove-port=${ssh_port}/tcp --permanent && firewall-cmd --reload
fi
