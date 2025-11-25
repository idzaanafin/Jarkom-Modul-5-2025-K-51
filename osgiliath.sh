cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.89.0.29
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.89.0.17
    netmask 255.255.255.252

auto eth3
iface eth3 inet static
    address 10.89.0.1
    netmask 255.255.255.252

EOF

iptables -t nat -A POSTROUTING -s 10.89.0.0/16 -o eth0 -j SNAT --to-source 192.168.122.212
# route add -net 10.89.0.0 netmask 255.255.255.252 gw 10.89. #A1
route add -net 10.89.0.4 netmask 255.255.255.252 gw 10.89.0.2 #A2
route add -net 10.89.0.8 netmask 255.255.255.252 gw 10.89.0.2 #A3
route add -net 10.89.0.12 netmask 255.255.255.252 gw 10.89.0.2 #A4
route add -net 10.89.0.128 netmask 255.255.255.128 gw 10.89.0.2 #A5
route add -net 10.89.1.0 netmask 255.255.255.0 gw 10.89.0.2 #A6
# route add -net 10.89.0.16 netmask 255.255.255.252 gw 10.89. #A7
route add -net 10.89.0.20 netmask 255.255.255.252 gw 10.89.0.18 #A8
route add -net 10.89.0.24 netmask 255.255.255.252 gw 10.89.0.18 #A9
route add -net 10.89.0.64 netmask 255.255.255.192 gw 10.89.0.18 #A10
route add -net 10.89.0.32 netmask 255.255.255.248 gw 10.89.0.18 #A11
# route add -net 10.89.0.28 netmask 255.255.255.252 gw 10.89. #A12
route add -net 10.89.0.40 netmask 255.255.255.248 gw 10.89.0.30 #A13

# DHCP RELAY
apt update
apt install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay
SERVERS="10.89.0.43"
INTERFACES="eth1 eth2 eth3"
OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
service isc-dhcp-relay restart