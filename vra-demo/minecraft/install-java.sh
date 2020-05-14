#!/bin/sh
sudo apt update
sudo add-apt-repository -y ppa:linuxuprising/java
echo debconf shared/accepted-oracle-license-v1-2 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-2 seen true | sudo debconf-set-selections
sudo apt install -y openjdk-14-jre-headless 

