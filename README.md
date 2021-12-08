# nmap-scan-ndiff
Dependencies:
- nmap
- ndiff
- xsltproc


## Installation example

Add system user scanner
```
useradd -r scanner -s /usr/sbin/nologin
```

Copy this project to /opt/nmap-scan-ndiff and change permissions
```
cp -pr nmap-scan-ndiff /opt/nmap-scan-ndiff
cd /opt
chown -R scanner:scanner /opt/nmap-scan-ndiff
chmod 750 /opt/nmap-scan-ndiff
chmod 700 /opt/nmap-scan-ndiff/nmap-scan-ndiff.sh
```

Run script
```
./nmap-scan-ndiff.sh
```


## CRON configuration example

Run a scan every night at 00:00 AM.
```
0 0 * * * /opt/nmap-scan-ndiff/nmap-scan-ndiff.sh &> /dev/null
```


## Nmap diff - convert XML to HTML

Generate specific nmap diff HTML report. You can customize xsl file.
```
xsltproc web/ndiff-nmap-scan.xsl scans/ndiff-nmap-scan.xml > scans/ndiff-scan.html
```


## Serve files on Apache web server

Install apache2
```
apt-get install apache2
```

Add apache2 user into the group scanner
- Debian/Ubuntu: www-data
- RHEL: apache

```
usermod -a -G scanner www-data
```

Configuration

Example:
- install directory: `/opt/nmap-scan-ndiff`
- directory with scans: `/opt/nmap-scan-ndiff/scans`

```
mkdir /var/www/html/nmap-scan-ndiff
cp web/ndiff-nmap-scan.xsl /var/www/html/nmap-scan-ndiff/
cp web/ndiff-nmap-scan.html /var/www/html/nmap-scan-ndiff/
cd /var/www/html/nmap-scan-ndiff
ln -s /opt/nmap/scans/ndiff-prev.xml nmap-scan-ndiff.xml
```


### Active Directory integration

Install Apache2 GSSAPI module
```
apt-get install libapache2-mod-auth-gssapi
```

/etc/apache2/conf-available/zzz_gssapi.conf
```
GSSAPI
<Location "/nmap-scan-ndiff">
    AuthType GSSAPI
    AuthName "GSSAPI"
    GssapiCredStore keytab:/etc/krb5.keytab
    GssapiBasicAuth     On
    GssapiNegotiateOnce On
    GssapiSSLonly       On
    GssapiUseSessions   On
    <IfModule mod_session.c>
        Session on
    </IfModule>

    Require valid-user
</Location>
```

Enable Apache2 GSSAPI configuration
```
a2enconf zzz_gssapi
```
