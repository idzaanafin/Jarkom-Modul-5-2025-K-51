cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.89.0.14
    netmask 255.255.255.252
    gateway 10.89.0.13

EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# webserver
apt update
apt install -y apache2
service apache2 start
echo "<h1>Welcome to Palantir</h1>" > /var/www/html/index.html
service apache2 restart

# KONFIGURASI FIREWALL IPTABLES
apt install iptables -y
# hanya dapat diakses oleh subnet 10.89.0.128/25 pada jam 07.00-15.00 dan subnet 10.89.1.0/24 pada jam 17.00-23.00
iptables -A INPUT -s 10.89.0.128/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
iptables -A INPUT -s 10.89.1.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

iptables -A INPUT -s 10.89.0.128/25 -j DROP
iptables -A INPUT -s 10.89.1.0/24 -j DROP

iptables -A INPUT -j DROP

# a. Web server harus memblokir scan port yang melebihi 15 port dalam waktu 20 detik.
# b. Penyerang yang terblokir tidak dapat melakukan ping, nc, atau curl ke Palantir.
# c. Catat log iptables dengan prefix "PORT_SCAN_DETECTED".


iptables -N PORTSCAN

iptables -A PORTSCAN -m limit --limit 2/min -j LOG --log-prefix "PORT_SCAN_DETECTED: "
iptables -A PORTSCAN -j DROP

iptables -A INPUT -m state --state NEW -m recent --set --name PORTSCAN
iptables -A INPUT -m state --state NEW -m recent --update --seconds 20 --hitcount 15 --name PORTSCAN -j PORTSCAN

# Block absolutely everything from attacker
iptables -A INPUT -m recent --rcheck --name PORTSCAN -j DROP

