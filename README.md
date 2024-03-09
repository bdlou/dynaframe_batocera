# dynaframe_batocera
Scripts to control a Dynaframe based on what is playing in Batocera

The scripts need to be placed in /userdata/system/configs/emulationstation/scripts on the Batocera device in the following structure:

/userdata/system/configs/emulationstation/scripts/config.sh
/userdata/system/configs/emulationstation/scripts/game-selected/*
/userdata/system/configs/emulationstation/scripts/system-selected/*

config.sh
Set dynaframe_hostname to the hostname (or IP) of the Dynaframe you wish to control.
Set fallback_playlist to the path where you will host a default.png to show up whenever an image is unavailable

system-selected/dynamic_marquee.sh
Set logo_path to the path where your well named system logos live.  Script expects png files (Example: mame.png, cps2.png, etc)

game-selected/dynamic_marquee.sh
Set marquee_path to the path where your well named game marquees will live.  Script currently expects files to live in a folder structure of ${marquee_path}${systemname}/images/${romname}-marquee.${extension}
Example: /home/pi/batocera/roms/snes/images/Donkey Kong Country 3 - Dixie Kong's Double Trouble (U) (M2) [!]-marquee.png
Example: /home/pi/batocera/roms/nes/images/Mike Tyson's Punch-Out!! (U) (PRG1) [!]-marquee.jpg
Code has an example of overriding nes to expect jpg, while everything else expects png
