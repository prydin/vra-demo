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
ln -s spigot-$MC_VERSION.jar spigot.jar

# Add game settings
sed -i.bak "s/\$MC_SEED/$MC_SEED/" server.properties

if [ -z "$MC_GAMEMODE" ]; then
    MC_GAMEMODE=survival
fi
sed -i.bak "s/\$MC_GAMEMODE/$MC_GAMEMODE/" server.properties


# Create log directory
mkdir /opt/spigot/log

# Make minecraft the owner of it all
chown -R minecraft .
chgrp -R minecraft .

# Install service
cp /opt/spigot/spigot.service /etc/systemd/system
systemctl enable spigot
systemctl start spigot

