# AIR40 setup

## QMK  

0. Only use it on new keyboards, otherwise use VIA setup
1. GitClone the repo from qmk in the keyboards put qmk-setup files instead of the regular files in air40 dir
2. Follow the guide from there 

## VIA

1. Open in the chrome via app, open chrome://device-log on the side
2. Search for the keyboard and find /dev/hidraw{NUMBER}
3. In the terminal run chmod 766 /dev/hidraw{NUMBER}
4. Open via app, go to design and open air40viaV3.json
5. Start edits or load the air40viaV3.layout.json in the keyboard

