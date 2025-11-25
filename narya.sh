cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.89.0.42
    netmask 255.255.255.248
    gateway 10.89.0.41

EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# DNS SERVER
apt update
apt install bind9 -y

nano /etc/bind/named.conf.local
zone "k51.com" {
    type master;
    file "/etc/bind/k51.com";
};

zone "0.89.10.in-addr.arpa" {
	type master;
    file "/etc/bind/0.89.10.in-addr.arpa";
};

nano /etc/bind/k51.com
$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     k51.com. root.k51.com. (
                        2025100401 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL
;

@         IN      NS      k51.com.
@       IN      A       10.89.0.42

nano /etc/bind/0.89.10.in-addr.arpa
$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     k51.com. root.k51.com. (
                        2025100401 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL
;

0.89.10.in-addr.arpa.       IN      NS      k51.com.
42       IN      PTR     k51.com.


ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart
