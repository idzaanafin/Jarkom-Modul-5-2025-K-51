# praktikum-komdat-jarkom-k51

| Nama   | NRP |
|--------|------|
| Ahmad Idza Anafin   | 5027241017   |
| Erlangga Valdhio Putra Sulistio   | 5027241030   |

# MODUL 5

# TOPOLOGI & SUBNETTING (VLSM)

<img width="1241" height="789" alt="image" src="https://github.com/user-attachments/assets/ad330ebb-272c-4dc6-b751-8227ab604e3c" />

kebutuhan host pada setiap jaringan:
| Subnet | Jumlah IP | Netmask |
|--------|-----------|---------|
| A1 | 2 | /30 |
| A2 | 2 | /30 |
| A3 | 2 | /30 |
| A4 | 2 | /30 |
| A5 | 121 | /25 |
| A6 | 231 | /24 |
| A7 | 2 | /30 |
| A8 | 2 | /30 |
| A9 | 2 | /30 |
| A10 | 51 | /26 |
| A11 | 6 | /29 |
| A12 | 2 | /30 |
| A13 | 3 | /29 |
| Total | 428 | /23 |

<img width="1084" height="621" alt="image" src="https://github.com/user-attachments/assets/484a1821-f5f7-41bc-aea9-4b6e4a477184" />

Pembagian subnetting dengan VLSM:
| Subnet | Network ID | Netmask | Prefix | Broadcast | Range IP |
|--------|------------|---------|--------|-----------|----------|
| A1 | 10.89.0.0 | 255.255.255.252 | /30 | 10.89.0.3 | 10.89.0.1 - 10.89.0.2 |
| A2 | 10.89.0.4 | 255.255.255.252 | /30 | 10.89.0.7 | 10.89.0.5 - 10.89.0.6 |
| A3 | 10.89.0.8 | 255.255.255.252 | /30 | 10.89.0.11 | 10.89.0.9 - 10.89.0.10 |
| A4 | 10.89.0.12 | 255.255.255.252 | /30 | 10.89.0.15 | 10.89.0.13 - 10.89.0.14 |
| A5 | 10.89.0.128 | 255.255.255.128 | /25 | 10.89.0.255 | 10.89.0.129 - 10.89.0.254 |
| A6 | 10.89.1.0 | 255.255.255.0 | /24 | 10.89.1.255 | 10.89.1.1 - 10.89.1.254 |
| A7 | 10.89.0.16 | 255.255.255.252 | /30 | 10.89.0.19 | 10.89.0.17 - 10.89.0.18 |
| A8 | 10.89.0.20 | 255.255.255.252 | /30 | 10.89.0.23 | 10.89.0.21 - 10.89.0.22 |
| A9 | 10.89.0.24 | 255.255.255.252 | /30 | 10.89.0.27 | 10.89.0.25 - 10.89.0.26 |
| A10 | 10.89.0.64 | 255.255.255.192 | /26 | 10.89.0.127 | 10.89.0.65 - 10.89.0.126 |
| A11 | 10.89.0.32 | 255.255.255.248 | /29 | 10.89.0.39 | 10.89.0.33 - 10.89.0.38 |
| A12 | 10.89.0.28 | 255.255.255.252 | /30 | 10.89.0.31 | 10.89.0.29 - 10.89.0.30 |
| A13 | 10.89.0.40 | 255.255.255.248 | /29 | 10.89.0.47 | 10.89.0.41 - 10.89.0.46 |


# KONFIGURASI IP ADDRESS & STATIC ROUTING
### Static IP
```
cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto {INTERFACE}
iface {INTERFACE} inet static
    address {IP_ADDRESS}
    netmask {NETMASK}
EOF
```
### Dynamic IP
```
cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback
auto {INTERFACE}
iface {INTERFACE} inet dhcp
EOF
```

### Static Routing
```
route add -net {NETWORK_ID} netmask {NETMASK} gw {GATEWAY_IP/NEXT_HOP_IP}
```

# MENGHUBUNGKAN KE INTERNET
### Konfigurasi pada Router utama (Gateway ke Internet)
```
iptables -t nat -A POSTROUTING -s 10.89.0.0/16 -o eth0 -j SNAT --to-source {IP_INTERFACE_NAT}
```
### Konfigurasi pada router lain
```
echo 1 > /proc/sys/net/ipv4/ip_forward
route add default gw {GATEWAY_IP/NEXT_HOP_IP}
```

# Konfigurasi Service

### DHCP Server
```
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
```

### DHCP Relay
```
apt update
apt install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay
SERVERS="{IP_DHCP_SERVER}"
INTERFACES="{INTERFACE}"
OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
service isc-dhcp-relay restart
```

### DNS Server
```
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
```

### WEB Server
```
apt update
apt install -y apache2
service apache2 start
echo "<h1>Welcome to {HOSTNAME}</h1>" > /var/www/html/index.html
service apache2 restart
```

# Konfigurasi Firewall (iptables) & Pengujian
### BLOCK ICMP REQUEST KE VILYA
`iptables -A INPUT -p icmp --icmp-type echo-request -j DROP`


<img width="982" height="143" alt="image" src="https://github.com/user-attachments/assets/da8b0b80-9613-47bd-a922-c83608aabe04" />

<img width="900" height="345" alt="image" src="https://github.com/user-attachments/assets/69afa5f4-06d3-4cef-9970-3ac76f66d05a" />


### HANYA ACCEPT VILYA UNTUK ACCESS DNS NARYA
```
iptables -A INPUT -p udp --dport 53 -s 10.89.0.43 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -s 10.89.0.43 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j DROP
iptables -A INPUT -p tcp --dport 53 -j DROP
```

<img width="506" height="102" alt="image" src="https://github.com/user-attachments/assets/a98da7d5-4592-430c-a09c-37c6d6e1e4d7" />

<img width="965" height="145" alt="image" src="https://github.com/user-attachments/assets/cc1e9dd5-fce9-4fb1-bbd0-df507b1a5395" />

<img width="842" height="117" alt="image" src="https://github.com/user-attachments/assets/815b01d4-6687-4dc4-ad23-21fd855d6d4a" />

<img width="611" height="104" alt="image" src="https://github.com/user-attachments/assets/eb449eb6-3e47-4bab-b011-09c415bde6dc" />



### IRONHILLS HANYA DAPAT DIAKSES SABTU MINGGU OLEH DURIN & KHAMUL DAN ELENDIL & ISILDUR
```
iptables -A INPUT -s 10.89.0.32/29 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 10.89.0.64/26 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 10.89.1.0/24 -m time --weekdays Sat,Sun -j ACCEPT

iptables -A INPUT -s 10.89.0.32/29 -j DROP
iptables -A INPUT -s 10.89.0.64/26 -j DROP
iptables -A INPUT -s 10.89.1.0/24 -j DROP

iptables -A INPUT -j DROP
```


<img width="1054" height="98" alt="image" src="https://github.com/user-attachments/assets/db0757f5-e7e5-476a-a33f-cac156f64aa6" />

<img width="1056" height="351" alt="image" src="https://github.com/user-attachments/assets/c40849fc-5eeb-44a8-9f27-dc67bfbf35ef" />

<img width="1054" height="143" alt="image" src="https://github.com/user-attachments/assets/b94092f1-f12a-41c4-a02e-98acbc2b765f" />

<img width="1059" height="276" alt="image" src="https://github.com/user-attachments/assets/9227386b-1994-4eb0-b313-e30d0edd6f64" />



### GILGALAD & CIRDAN HANYA DAPAT AKSES PALANTIR JAM 07.00-15.00 DAN ELENDIL & ISILDUR JAM 17.00-23.00
```
iptables -A INPUT -s 10.89.0.128/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
iptables -A INPUT -s 10.89.1.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

iptables -A INPUT -s 10.89.0.128/25 -j DROP
iptables -A INPUT -s 10.89.1.0/24 -j DROP

iptables -A INPUT -j DROP
```
<img width="1060" height="187" alt="image" src="https://github.com/user-attachments/assets/5b0e3f82-ad37-41b8-9ff7-2e8fe4b5e4bc" />

<img width="1059" height="151" alt="image" src="https://github.com/user-attachments/assets/e9d3c56f-72b5-4e6a-a407-470685b43401" />

<img width="1055" height="287" alt="image" src="https://github.com/user-attachments/assets/4faf582e-9427-4cde-b56f-9dccb1625374" />

<img width="1056" height="141" alt="image" src="https://github.com/user-attachments/assets/b245e5a2-2f89-48eb-8020-3b3452df7c6a" />

<img width="1059" height="186" alt="image" src="https://github.com/user-attachments/assets/b22093d8-1b6a-4363-a78b-a4fc35d9c736" />

<img width="1062" height="145" alt="image" src="https://github.com/user-attachments/assets/1470ed63-cf96-48cf-84f8-c423890724f0" />

<img width="1054" height="158" alt="image" src="https://github.com/user-attachments/assets/e4995c49-8918-4d2a-b5c6-923caa685609" />


### BLOCK PORT SCANNING 15 PORT DALAM 20 DETIK DAN LOGGING
```

```





### IRONHILLS HANYA BISA DIAKSES DARI 3 KONEKSI AKTIF PER IP
```
iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 3 --connlimit-mask 32 -j REJECT --reject-with tcp-reset
```

<img width="1054" height="646" alt="image" src="https://github.com/user-attachments/assets/d32b9f62-1752-4638-8867-454506af7cfe" />

<img width="1052" height="94" alt="image" src="https://github.com/user-attachments/assets/a17cbe26-0af3-46a6-819f-9258397febba" />

<img width="1057" height="228" alt="image" src="https://github.com/user-attachments/assets/24d1c851-ced7-4de1-a3bb-69bfe71da381" />


### PACKET YANG BERASAL DARI VILYA KE KHAMUL DIARAHKAN KE IRONHILLS

