#!/bin/sh
#usage: sudo bash set_pptp.sh

apt-get install pptp-linux network-manager-pptp
echo "PPTP name:"
read PPTP_NAME
echo "PPTP server address:"
read PPTP_ADDRESS
echo "PPTP user name:"
read PPTP_USER
echo "PPTP user password"
read PPTP_PASSWD

VPN_FILE="/etc/ppp/peers/"$PPTP_NAME

#ROUTE_FILE="/etc/ppp/"$PPTP_NAME".ip-up"
ROUTE_FILE="/etc/ppp/ip-up.local"

#touch $VPN_FILE
#touch $ROUTE_FILE

echo -e "pty \"pptp "$PPTP_ADDRESS" --nolaunchpppd\"\nlock\nnoauth\nnobsdcomp\nnodeflate\nname "$PPTP_USER"\nremotename "$PPTP_NAME"\nipparam "$PPTP_NAME"\nrequire-mppe-128\nusepeerdns\ndefaultroute\npersist" > $VPN_FILE

echo -e $PPTP_USER"\t"$PPTP_NAME"\t"$PPTP_PASSWD"\t*" >> /etc/ppp/chap-secrets

echo -e "H=\`ps aux | grep 'pppd pty' | grep -v grep | awk '{print \$14}'\`" > $ROUTE_FILE
echo -e "DG=\`route -n | grep UG | awk '{print \$2}'\`" >> $ROUTE_FILE
echo -e "DEV=\`route -n | grep UG | awk '{print \$8}'\`" >> $ROUTE_FILE
echo -e "route add -host \$H gw \$DG dev \$DEV" >> $ROUTE_FILE
echo -e "route del default \$DEV" >> $ROUTE_FILE
echo -e "route add default dev ppp0" >> $ROUTE_FILE
sudo chmod +x $ROUTE_FILE

