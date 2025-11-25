cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.89.0.22
    netmask 255.255.255.252
    gateway 10.89.0.21
    
EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf


# webserver
apt update
apt install -y apache2
service apache2 start
echo "<h1>Welcome to Ironhills</h1>" > /var/www/html/index.html
service apache2 restart