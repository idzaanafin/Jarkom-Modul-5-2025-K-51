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

# KONFIGURASI FIREWALL IPTABLES
apt install iptables -y
# hanya dapat diakses oleh subnet 10.89.0.32 255.255.255.248, subnet 10.89.0.64 netmask 255.255.255.192, subnet 10.89.1.0 netmask 255.255.255.0, dan hanya bisa diakses pada hari sabtu dan minggu
iptables -A INPUT -s 10.89.0.32/29 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 10.89.0.64/26 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 10.89.1.0/24 -m time --weekdays Sat,Sun -j ACCEPT

iptables -A INPUT -s 10.89.0.32/29 -j DROP
iptables -A INPUT -s 10.89.0.64/26 -j DROP
iptables -A INPUT -s 10.89.1.0/24 -j DROP

iptables -A INPUT -j DROP

#  hanya boleh berasal dari 3 koneksi aktif per IP dalam waktu bersamaan.
iptables -N LIMIT_CONN
iptables -A LIMIT_CONN -m connlimit --connlimit-above 3 -j DROP
iptables -A INPUT -p tcp --dport 80 -j LIMIT_CONN

