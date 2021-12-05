# nmap-scan-ndiff
Dependencies:
- nmap
- ndiff
- xsltproc

Run script
```
./nmap-scan-ndiff.sh
```


## CRON configuration example
Run a scan every night at 00:00 AM.
```
0 0 * * * /opt/nmap/nmap-scan-ndiff.sh &> /dev/null
```


## Nmap diff - convert XML to HTML
Nmap diff
```
xsltproc ndiff-nmap-scan.xsl ndiff-nmap-scan.xml > ndiff-scan.html
```


## Serve files on Apache web server
Example:
- install directory: `/opt/nmap`
- directory with scans: `/opt/nmap/scans`

```
mkdir /var/www/html/nmap-scan-ndiff
cp web/ndiff-nmap-scan.xsl /var/www/html/nmap-scan-ndiff/
cp web/ndiff-nmap-scan.html /var/www/html/nmap-scan-ndiff/
cd /var/www/html/nmap-scan-ndiff
ln -s /opt/nmap/scans/ndiff-prev.xml nmap-scan-ndiff.xml
```
