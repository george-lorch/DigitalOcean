#!/bin/bash

ssh-keygen -t rsa -b 4096 -C "george.lorch@percona.com" -f ~/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

sudo apt-get update
sudo apt-get install -y fail2ban vim screen git make cmake gcc g++ libncurses5-dev libreadline-dev bison libz-dev libgcrypt20 libgcrypt20-dev libssl-dev libboost-all-dev valgrind python-mysqldb mdm

ssh -o "StrictHostKeyChecking no" -T git@github.com
git config --global user.email "george.lorch@percona.com"
git config --global user.name "George O. Lorch III"
git config --global core.editor "vim"
mkdir ~/dev
cd ~/dev
wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz
tar -xzf boost_1_59_0.tar.gz
rm boost_1_59_0.tar.gz
git clone --recursive https://git@github.com/georgelorchpercona/myrocks
git clone --recursive https://git@github.com/percona/percona-server
mkdir percona-server-build-5.6
mkdir percona-server-build-5.7
mkdir percona-server-install-5.6
mkdir percona-server-install-5.7
mkdir perconaft-build
git clone --recursive https://git@github.com/facebook/mysql-5.6 facebook-mysql
mkdir facebook-mysql-build-5.6
mkdir facebook-mysql-install-5.6
cd -
