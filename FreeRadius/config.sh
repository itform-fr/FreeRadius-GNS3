apt update && apt install install freeradius samba winbind krb5-user freeradius-ldap -y
adduser freerad winbindd_priv

sed -i '/#bob/ s/^#//;s/hello/poseidon/' /etc/freeradius/3.0/users
sed -i '$ a client SW-L3 {\n\tipaddr = 192.168.100.254\n\tsecret = poseidon\n}' /etc/freeradius/3.0/clients.conf

echo "nameserver 192.168.50.250" > /etc/resolv.conf
rm /etc/krb5.conf
echo -e "[libdefaults]\n\tdefault_realm = AIS.LABO\n\tdns_lookup_realm = false\n\tdns_lookup_kdc = true\n" > /etc/krb5.conf
cat << EOF > /etc/samba/smb.conf
[global]
   netbios name = FREERADIUS
   workgroup = AIS
   server string = RADIUS server
   security = ads
   invalid users = root
   socket options = TCP_NODELAY
   idmap uid = 16777216-33554431
   idmap gid = 16777216-33554431
   winbind use default domain = no
   winbind max domain connections = 5
   winbind max clients = 1000
   ntlm auth = mschapv2-and-ntlmv2-only
   password server = *
   realm = AIS.LABO
EOF

systemctl restart winbind
sed -e '/^#NTP/ s/^#//;/^NTP/ s/=/=192.168.50.250/;/^#RootD/ s/^#//;/^RootD/ s/5/100/' /etc/systemd/timesyncd.conf
systemctl enable --now systemd-timesyncd.conf

net ads join --no-dns-updates -U administrateur%0Poseidon
systemctl restart winbind
wbinfo -u
