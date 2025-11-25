cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.89.0.18
    netmask 255.255.255.252    

auto eth1
iface eth1 inet static
    address 10.89.0.21
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.89.0.25
    netmask 255.255.255.252

EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
route add default gw 10.89.0.17
route add -net 10.89.0.0 netmask 255.255.255.252 gw 10.89.0.17 #A1
route add -net 10.89.0.4 netmask 255.255.255.252 gw 10.89.0.17 #A2
route add -net 10.89.0.8 netmask 255.255.255.252 gw 10.89.0.17 #A3
route add -net 10.89.0.12 netmask 255.255.255.252 gw 10.89.0.17 #A4
route add -net 10.89.0.128 netmask 255.255.255.128 gw 10.89.0.17 #A5
route add -net 10.89.1.0 netmask 255.255.255.0 gw 10.89.0.17 #A6
# route add -net 10.89.0.16 netmask 255.255.255.252 gw 10.89. #A7
# route add -net 10.89.0.20 netmask 255.255.255.252 gw 10.89. #A8
# route add -net 10.89.0.24 netmask 255.255.255.252 gw 10.89. #A9
route add -net 10.89.0.64 netmask 255.255.255.192 gw 10.89.0.26 #A10
route add -net 10.89.0.32 netmask 255.255.255.248 gw 10.89.0.26 #A11
route add -net 10.89.0.28 netmask 255.255.255.252 gw 10.89.0.17 #A12
route add -net 10.89.0.40 netmask 255.255.255.248 gw 10.89.0.17 #A13

apt update
apt install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay
SERVERS="10.89.0.43"
INTERFACES="eth0 eth2"
OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
service isc-dhcp-relay restart