#!/usr/bin/env bash

#configurazioni di base per consentire il directory sharing
mkdir /vagrant

#impostazione dell'hostname
echo "magentotest.com" > /etc/hostname
sed -i 's/precise32/magentotest.com www.magentotest.com/g' /etc/hosts

#aggiorno il sistema operativo
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

#installo i pacchetti necessari all'esecuzione di un sistema LEMP
DEBIAN_FRONTEND=noninteractive apt-get -q -y install nginx php5 php5-cli php5-cgi spawn-fcgi php5-mysql php5-mcrypt php5-curl php5-gd php5-fpm openssl php-apc php5-mcrypt mcrypt redis-server mysql-server-5.5 mysql-client-5.5 vim git
#crea il link simbolico ad mcrypt, se non esiste già
if [ ! -f /etc/php5/mods-available/mcrypt.ini ]; then
	ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/fpm/conf.d/20-mcrypt.ini 
fi

#aggiorno la configurazione di Nginx
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
cp /vagrant/etc/nginx.conf /etc/nginx/nginx.conf
cp /vagrant/etc/default /etc/nginx/sites-enabled/default

#attività da (eseguire | non eseguire) a seconda se stai facendo un provision|reprovision

#imposto password di MySQL, solo se non esiste già (reprovision)
if [ ! -f /root/mysql.secret ]; then
	echo $(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}; echo;) > /root/mysql.secret && mysqladmin -u root --password='' password $(cat /root/mysql.secret) 
fi	

#scarico l'ultima versione di magento, solo se non esiste già (reprovision)
if [ ! -d /var/www/magento ]; then

	#download e decompressione
	cd /var/www && wget -q http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz && tar -xzvf magento-1.9.1.0.tar.gz

	#pulizia post installazione
	rm -rf /var/www/magento-1.9.1.0.tar.gz
fi	

#riavvio servizi // finalizzazione
service nginx start
service php5-fpm restart