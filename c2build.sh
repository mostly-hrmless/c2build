#!/bin/bash

#initial commands
apt-get update && apt-get upgrade -y

#basic installs
apt-get install -y unace p7zip* htop terminator strace zmap lynx libssl-dev libffi-dev python-dev python-pip tcpdump python-virtualenv git openvpn

#Set up folders
mkdir /pentest
mkdir /pentest/exploitation

#Empire
cd /pentest/exploitation
git clone https://github.com/PowerShellEmpire/Empire.git
cd /pentest/exploitation/Empire/setup
./install.sh
#Need to press enter at password creation prompt for now.

#Veil-Evasion setup
cd /pentest/exploitation
git clone https://github.com/Veil-Framework/Veil.git
git clone https://github.com/Veil-Framework/PowerTools.git
cd /pentest/exploitation/Veil/setup
./setup.sh -s

#Responder Setup
cd /pentest/exploitation
git clone https://github.com/SpiderLabs/Responder.git
cd Responder
cp -r * /usr/bin

#Shell_Shocker Setup
cd /pentest/exploitation
git clone https://github.com/mubix/shellshocker-pocs.git

#Core Impact Impacket
cd /pentest/exploitation
git clone https://github.com/CoreSecurity/impacket.git

#Pupy Shell
cd /pentest/exploitation
git clone --recursive https://github.com/n1nj4sec/pupy
cd cd /pentest/exploitation/pupy
python create-workspace.py -DG pupyw
export PATH=$PATH:~/.local/bin

#Configure OpenVPN Autostart
touch /etc/openvpn/openvpn.sh

echo "#!/bin/bash" >> /etc/openvpn/openvpn.sh
echo "openvpn --config /etc/openvpn/rpi01.ovpn" >> /etc/openvpn/openvpn.sh

chmod +x /etc/openvpn/openvpn.sh

mv /etc/rc.local /etc/rc.bak
touch /etc/rc.local

echo "#!/bin/sh -e" >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# rc.local" >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# This script is executed at the end of each multiuser runlevel." >> /etc/rc.local
echo "# Make sure that the script will "exit 0" on success or any other" >> /etc/rc.local
echo "# value on error." >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# In order to enable or disable this script just change the execution" >> /etc/rc.local
echo "# bits." >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# By default this script does nothing." >> /etc/rc.local
echo " " >> /etc/rc.local
echo "# Print the IP address" >> /etc/rc.local
echo "_IP=$(hostname -I) || true" >> /etc/rc.local
echo "if [ "$_IP" ]; then" >> /etc/rc.local
echo "  printf "My IP address is %s\n" "$_IP"" >> /etc/rc.local
echo "fi" >> /etc/rc.local
echo " " >> /etc/rc.local
echo "/etc/openvpn/openvpn.sh" >> /etc/rc.local
echo " " >> /etc/rc.local
echo "exit 0" >> /etc/rc.local

chmod +x /etc/rc.local

#Apt cleanup
apt-get install -f

reboot

