FROM kvaps/clamd

RUN
cp /usr/share/doc/clamav-server*/clamd.conf /etc/clamd.d/squid.conf
useradd -M -d /var/tmp -s /sbin/nologin squidclamav
mkdir /var/run/clamd.squid
chown squidclamav. /var/run/clamd.squid
cp /usr/share/doc/clamav-server*/clamd.sysconfig /etc/sysconfig/clamd.squid

touch /var/log/clamd.squid
chown squidclamav. /var/log/clamd.squid
chmod 600 /var/log/clamd.squid
systemctl start clamd@squid
systemctl enable clamd@squid
