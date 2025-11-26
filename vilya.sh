cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.89.0.43
    netmask 255.255.255.248
    gateway 10.89.0.41

EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# DHCP SERVER
apt update
apt install isc-dhcp-server -y

nano /etc/default/isc-dhcp-server
INTERFACESv4="eth0"

nano /etc/dhcp/dhcpd.conf
subnet 10.89.0.40 netmask 255.255.255.248 {
}

# khamul
subnet 10.89.0.32 netmask 255.255.255.248 {
    range 10.89.0.33 10.89.0.38;
    option routers 10.89.0.33;
    option broadcast-address 10.89.0.39;
    # option domain-name "k51.com";
    option domain-name-servers 192.168.122.1;
    default-lease-time 600;
    max-lease-time 3600;
}

# durin
subnet 10.89.0.64 netmask 255.255.255.192 {
    range 10.89.0.65 10.89.0.126;
    option routers 10.89.0.65;
    option broadcast-address 10.89.0.127;
    # option domain-name "k51.com";
    option domain-name-servers 192.168.122.1;
    default-lease-time 600;
    max-lease-time 3600;
}

# gilgalad & cirdan
subnet 10.89.0.128 netmask 255.255.255.128 {
    range 10.89.0.129 10.89.0.254;
    option routers 10.89.0.129;
    option broadcast-address 10.89.0.255;
    # option domain-name "k51.com";
    option domain-name-servers 192.168.122.1;
    default-lease-time 600;
    max-lease-time 3600;
}
# elendil & isildur
subnet 10.89.1.0 netmask 255.255.255.0 {
    range 10.89.1.1 10.89.1.254;
    option routers 10.89.1.1;
    option broadcast-address 10.89.1.255;
    # option domain-name "k51.com";
    option domain-name-servers 192.168.122.1;
    default-lease-time 600;
    max-lease-time 3600;
}


service isc-dhcp-server restart


# KONFIGURASI FIREWALL IPTABLES
apt install -y iptables
# tidak ada perangkat lain yang bisa melakukan PING ke Vilya.
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
