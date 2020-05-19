#!/bin/bash
chnod +x /etc/spigot-env.sh
. /etc/spigot-env.sh
useradd minecraft
mkdir /opt/spigot
cd /opt/spigot/
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
git config --global --unset core.autocrlf
java -Xmx2G -jar BuildTools.jar
echo "eula=true" > eula.txt 

# Add game settings
wget https://raw.githubusercontent.com/prydin/vra-demo/master/vra-demo/minecraft/server.properties
if [ -n "$MC_SEED" ]; then
    sed -ibak "s/\$MC_SEED/$MC_SEED/" server.properties
fi

if [ -z "$MC_GAMEMODE" ]; then
    MC_GAMEMODE=survival
fi
sed -ibak "s/\$MC_GAMEMODE/$MC_GAMEMODE/" server.properties

# Install service
cp /opt/spigot/spigot.service /etc/systemd/system
systemctl enable spigot
systemctl start spigot

