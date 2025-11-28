# CLIENT DHCP
cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# KONFIGURASI FIREWALL IPTABLES
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
apt update
apt install -y iptables
# redirect trafik yang berasal dari 10.89.0.43 ke 10.89.0.22
iptables -t nat -A PREROUTING -s 10.89.0.43 -j DNAT --to-destination 10.89.0.22
iptables -A FORWARD -s 10.89.0.43 -d 10.89.0.22 -j ACCEPT
iptables -A FORWARD -s 10.89.0.22 -d 10.89.0.43 -j ACCEPT
