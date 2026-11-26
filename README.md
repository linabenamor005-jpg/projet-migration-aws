# Projet : Migration d'une Application Web Multi-tiers (Local vers AWS)

## Description du Projet
Ce projet consiste à déployer une application web complète (WordPress + Base de données MySQL) dans deux environnements distincts :
1. En local, via des machines virtuelles automatisées avec Vagrant et VirtualBox.
2. Sur le Cloud, via des instances EC2 sur AWS, avec une architecture réseau sécurisée.

L'objectif principal est de comprendre le passage d'une infrastructure "On-Premise" à une infrastructure Cloud, tout en appliquant les principes de sécurité réseau (isolation de la base de données).

## Architecture
### 1. Architecture Locale (Vagrant)
- VM Web : Serveur Apache, PHP, WordPress .
- VM DB : Serveur MySQL.
- Accès : http://localhost:8088

### 2. Architecture Cloud (AWS)
- Security Group SG-Web : Ouvert au monde sur le port 80 (HTTP) et restreint sur le port 22 (SSH).
- Security Group SG-DB : N'accepte le port 3306 (MySQL) que si la connexion provient du SG-Web (Principe du moindre privilège).
- Instances EC2 : Une pour le serveur Web, une pour la base de données.

## Technologies Utilisées
- Virtualisation : VirtualBox, Vagrant
- Cloud : AWS EC2, VPC, Security Groups
- Système d'exploitation : Ubuntu Server 22.04 LTS
- Web : Apache 2, PHP 8.1, WordPress (Thème Appetizer)
- Base de données : MySQL 8.0

## Guide de Déploiement

### 1. Lancement en Local
Cloner le projet :
git clone https:/https://github.com/linabenamor005-jpg/projet-migration-aws.git
cd projet-migration-aws

Lancer les machines virtuelles :
vagrant up

Accéder au site local :
http://localhost:8088

### 2. Déploiement sur AWS (Résumé)
1. Créer les Security Groups (SG-Web et SG-DB).
2. Lancer l'instance DB avec le script aws-userdata-db.sh.
3. Lancer l'instance Web avec le script aws-userdata-web.sh (configuré avec l'IP privée de la DB).
4. Accéder au site via l'IP publique de l'instance Web.

## Sécurité et Tests
Pour valider l'isolation de la base de données, le test suivant a été exécuté depuis une machine externe :
Test-NetConnection <IP_PRIVEE_DB> -Port 3306

Résultat : TcpTestSucceeded : False (La base de données est bien protégée des accès Internet).

## Auteurs
- [Lina Ben Amor]
- [Menyar]

Module : Virtualisation et Cloud Computing