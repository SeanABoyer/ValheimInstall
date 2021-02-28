#AMI Name = ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20210128
#AMI ID = ami-025102f49d03bec05

#Create New User
sudo adduser steamusr
cd /home/steamusr

#For 64 Bit OS
sudo dpkg --add-architecture i386

#Updates 
sudo apt update
sudo apt upgrade

#Installs
sudo apt install lib32gcc1 steamcmd unzip

#Change User
su - steamusr

#Install Server
cd ~
steamcmd +login anonymous +force_install_dir /home/steamusr/Valheim +app_update 896660 validate +quit

#Valheim Plus
mkdir /home/steamusr/valheimplus
cd /home/steamusr/valheimplus
wget https://github.com/valheimPlus/ValheimPlus/releases/download/0.8/UnixServer.zip
unzip UnixServer.zip

#Move everything but the Zip to the valheim server directory
cd /home/steamusr/valheimplus
cp -r !(UnixServer.zip) /home/steamusr/Valheim

#Add necessary path for dll mapping for Mono. How I discovered this issue is below...
sed -i '2i\        <dllmap dll="dl" target="libdl.so.2"/> ' /home/steamusr/Valheim/valheim_server_Data/MonoBleedingEdge/etc/mono/config


#Enable Logging.Console in BepInEx/config/BepInEx.cfg file
#This threw a preloader error (new file in the /home/steamusr/Valheim directory):
#System.TypeInitializationException: The type initializer for 'BepInEx.Unix.UnixStreamHelper' threw an exception. ---> System.TypeInitializationException: The type initializer for 'MonoMod.Utils.DynDll' threw an exception. ---> System.DllNotFoundException: dl
#  at (wrapper managed-to-native) MonoMod.Utils.DynDll.dlerror()
#  at MonoMod.Utils.DynDll..cctor () [0x00013] in <e54299200d7d4726aec081e4ca77de7e>:0
#   --- End of inner exception stack trace ---
#  at BepInEx.Unix.UnixStreamHelper..cctor () [0x00046] in <184c586c2ee04b65bf61102a71fca742>:0
#   --- End of inner exception stack trace ---
#  at (wrapper managed-to-native) System.Object.__icall_wrapper_mono_generic_class_init(intptr)
#  at BepInEx.Unix.LinuxConsoleDriver.Initialize (System.Boolean alreadyActive) [0x00007] in <184c586c2ee04b65bf61102a71fca742>:0
#  at BepInEx.ConsoleManager.Initialize (System.Boolean alreadyActive) [0x0002c] in <184c586c2ee04b65bf61102a71fca742>:0

#This led to finding this issue:
#https://github.com/BepInEx/BepInEx/issues/162

#Which led to the solution of adding the dllmap to the mono config.
