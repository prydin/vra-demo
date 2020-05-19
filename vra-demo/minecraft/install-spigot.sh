#!/bin/bash
useradd minecraft
mkdir /opt/spigot
cd /opt/spigot/
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
git config --global --unset core.autocrlf
java -Xmx2G -jar BuildTools.jar
echo "eula=true" > eula.txt 

# Add settings if
wget https://raw.githubusercontent.com/prydin/vra-demo/master/vra-demo/minecraft/server.properties
if [ -n "$MC_SEED" ]; then
    sed -ibak "s/\$MC_SEED/$MC_SEED/" server.properties
fi

if [ -n "$MC_GAMEMODE" ]; then
    sed -ibak "s/gamemode=survival/gamemode=$MC_GAMEMODE/" server.properties
fi

