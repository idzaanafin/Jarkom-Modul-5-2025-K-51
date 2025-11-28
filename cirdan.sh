# CLIENT DHCP
cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf