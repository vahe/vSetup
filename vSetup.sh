#!/bin/bash
apt-get update
apt-get install nano sudo wget locales-all
echo " "
echo " "
echo "------------------------------------------"
echo "WGET, NANO, SUDO and LOCALES ARE INSTALLED"
echo "------------------------------------------"
adduser $2
echo " "
echo " "
echo "---------------------------------"
echo "USER $2 HAS BEEN ADDED"
echo "---------------------------------"
echo " "
echo " "
usermod -a -G sudo $2
echo " "
echo " "
echo "$2 ADDED TO SUDO GROUP"
echo "---------------------------------"
echo " "
echo " "
echo "---------------------------------"
echo "RUN THE FOLLOWING ON THE LOCAL MACHINE"
echo "---------------------------------"
echo "First make sure you have created a public and private rsa key combination "
echo "If you did, you should have two files, usually called id_rsa and id_rsa.pub, in ~/.ssh folder on your local machine"
echo "If you didn't, run the following command to generate the keys first:"
echo "       ssh-keygen -t rsa"
echo "now run: "
echo ssh-copy-id -i ~/.ssh/id_rsa.pub $2@$1
echo " "
echo "---------------------------------"
read -p "Press [Enter] when done"

echo ""
echo ""
#configure ssh
echo "CONFIGURING SSH"
#echo Using port = $3
cat sshd_config > /etc/ssh/sshd_config

sed -i "s/Port [0-9]*/Port $3/g" /etc/ssh/sshd_config
#sed -i "s/UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config
echo "AllowUsers $2" >> /etc/ssh/sshd_config
#sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
#sed -i "s/#*PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
#sed -i "s/#*PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
service ssh restart
echo ""
echo ""
echo "---------------------------------"
echo "Please open another console and connect to the server"
echo "using the following command: "
echo "ssh -p $3 $2@$1"
read -p "Press [Enter] if the connection is fine."
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "---------------------------------"
echo "If your local machine runs Linux/Unix,"
echo "do the following to simplify the login process"
echo ""
echo "1. edit the local /etc/hosts file and add a line similar to this:"
echo "   $1	myserver"
echo " you can change myserver to any name you want"
echo "2. create/edit config file in ~/.ssh folder, "
echo "   by adding Host $1, followed by Port $3 on the next line"
echo "3. now you can connect to the server with the following command: "
echo "   ssh $2@myserver"
echo "---------------------------------"
read -p "Press [Enter] to continue."

echo "---------------------------"
echo "NOW SETTING UP IPTABLES"
apt-get install iptables
/sbin/iptables -F

cp iptables.up.rules /etc/iptables.up.rules
sed -i "s/30000/$3/g" /etc/iptables.up.rules
echo "The iptables configuration opens ports 80 (HTTP), 443 (HTTPS) and $3 (ssh)"
/sbin/iptables-restore < /etc/iptables.up.rules
echo "#!/bin/sh" > /etc/network/if-pre-up.d/iptables
echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables
chmod +x /etc/network/if-pre-up.d/iptables

echo "--------------------------------"
echo "FINISHED SETTING UP IPTABLES"
echo "--------------------------------"

echo ""
echo "PS1='\[\033[0;35m\]\u@\h\[\033[0;33m\] \w\[\033[00m\]: '" >> /home/$2/.bashrc
su $2 -c "source /home/$2/.bashrc"

echo "NOW CONSOLE LOOKS MUCH BETTER"
echo ""
echo "INSTALLING FAIL2BAN"
apt-get install fail2ban
/etc/init.d/fail2ban restart

echo "I think we're done!"
