#!/bin/bash
useradd minecraft
mkdir /opt/spigot
cd /opt/spigot/
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
git config --global --unset core.autocrlf
java -Xmx2G -jar BuildTools.jar
echo "eula=true" > eula.txt 
# java -Xmx2g -jar spigot-*.jar
