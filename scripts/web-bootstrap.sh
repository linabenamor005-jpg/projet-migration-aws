#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

: "${DB_NAME:=wordpress}"
: "${DB_USER:=wpuser}"
: "${DB_PASS:=ChangeMe_2024!}"
: "${DB_IP:=192.168.56.11}"

echo "=== [WEB] Installation Apache + PHP ==="
apt-get update -y
apt-get install -y apache2 php php-mysql php-curl php-gd php-mbstring \
  php-xml php-xmlrpc php-zip php-intl unzip wget curl openssl
a2enmod rewrite

echo "=== [WEB] Téléchargement WordPress ==="
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm -rf /var/www/html/*
cp -r wordpress/* /var/www/html/

echo "=== [WEB] Génération wp-config.php ==="
SALTS=$(openssl rand -hex 32)
cat > /var/www/html/wp-config.php <<PHP
<?php
define( 'DB_NAME',     '${DB_NAME}' );
define( 'DB_USER',     '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_PASS}' );
define( 'DB_HOST',     '${DB_IP}' );
define( 'DB_CHARSET',  'utf8mb4' );
define( 'DB_COLLATE',  '' );
define( 'AUTH_KEY',         '${SALTS}a1' );
define( 'SECURE_AUTH_KEY',  '${SALTS}b2' );
define( 'LOGGED_IN_KEY',    '${SALTS}c3' );
define( 'NONCE_KEY',        '${SALTS}d4' );
define( 'AUTH_SALT',        '${SALTS}e5' );
define( 'SECURE_AUTH_SALT', '${SALTS}f6' );
define( 'LOGGED_IN_SALT',   '${SALTS}g7' );
define( 'NONCE_SALT',       '${SALTS}h8' );
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
PHP

chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chmod 640 /var/www/html/wp-config.php

cat > /etc/apache2/sites-available/000-default.conf <<'APACHE'
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
APACHE

systemctl enable apache2
systemctl restart apache2

echo "=== [WEB] WordPress prêt : http://localhost:8080 ==="