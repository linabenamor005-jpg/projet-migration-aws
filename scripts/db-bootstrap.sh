#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

: "${DB_NAME:=wordpress}"
: "${DB_USER:=wpuser}"
: "${DB_PASS:=ChangeMe_2024!}"
: "${WEB_IP:=192.168.56.10}"

echo "=== [DB] Installation MySQL ==="
apt-get update -y
apt-get install -y mysql-server

sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl enable mysql
systemctl restart mysql

echo "=== [DB] Création base + utilisateur ==="
mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'${WEB_IP}' IDENTIFIED BY '${DB_PASS}';
ALTER USER '${DB_USER}'@'${WEB_IP}' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'${WEB_IP}';
FLUSH PRIVILEGES;
SQL

echo "=== [DB] Prête. Base '${DB_NAME}', user '${DB_USER}', depuis ${WEB_IP} ==="