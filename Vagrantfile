# -*- mode: ruby -*-
# vi: set ft=ruby :

DB_NAME = "wordpress"
DB_USER = "wpuser"
DB_PASS = "ChangeMe_2024!"
WEB_IP  = "192.168.56.10"
DB_IP   = "192.168.56.11"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # ===== VM DB =====
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: DB_IP
    db.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus   = 1
      vb.name   = "wp-db"
    end
    db.vm.provision "shell", path: "scripts/db-bootstrap.sh",
      env: { "DB_NAME" => DB_NAME, "DB_USER" => DB_USER,
             "DB_PASS" => DB_PASS, "WEB_IP"  => WEB_IP }
  end

  # ===== VM WEB =====
  config.vm.define "web" do |web|
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: WEB_IP
    web.vm.network "forwarded_port", guest: 80, host: 8088
    web.vm.provider "virtualbox" do |vb|
      vb.memory = "1536"
      vb.cpus   = 2
      vb.name   = "wp-web"
    end
    web.vm.provision "shell", path: "scripts/web-bootstrap.sh",
      env: { "DB_NAME" => DB_NAME, "DB_USER" => DB_USER,
             "DB_PASS" => DB_PASS, "DB_IP"   => DB_IP }
  end
end