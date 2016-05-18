fuse_defs = {"LOW":{"bits":[{"name":"OSCSEL0","text":"Oscillator Select","default_value":"0"},{"name":"OSCSEL1","text":"Oscillator Select","default_value":"1"},{"name":"SUT0","text":"Select start-up time","default_value":"1"},{"name":"SUT1","text":"Select start-up time","default_value":"1"},{"name":"SUT2","text":"Select start-up time","default_value":"1"},{"name":"SPIEN","text":"Enable Serial programming and Data Downloading","default_value":"0"},{"name":"EESAVE","text":"EEPROM memory is preserved through chip erase","default_value":"1"},{"name":"WDTON","text":"Watchdog Timer Always On","default_value":"1"}],"options":{"0x80":[{"mask":128,"value":0,"text":"Watch-dog Timer always on; [WDTON=0]"}],"0x40":[{"mask":64,"value":0,"text":"Preserve EEPROM memory through the Chip Erase cycle; [EESAVE=0]"}],"0x20":[{"mask":32,"value":0,"text":"Serial program downloading (SPI) enabled; [SPIEN=0]"}],"0x01C":[{"mask":28,"value":0,"text":"Start-up time 14 CK + 4 ms;   [SUT=000]"},{"mask":28,"value":1,"text":"Start-up time 14 CK + 8 ms;   [SUT=001]"},{"mask":28,"value":2,"text":"Start-up time 14 CK + 16 ms;  [SUT=010]"},{"mask":28,"value":3,"text":"Start-up time 14 CK + 32 ms;  [SUT=011]"},{"mask":28,"value":4,"text":"Start-up time 14 CK + 64 ms;  [SUT=100]"},{"mask":28,"value":5,"text":"Start-up time 14 CK + 128 ms; [SUT=101]"},{"mask":28,"value":6,"text":"Start-up time 14 CK + 256 ms; [SUT=110]"}],"0x1C":[{"mask":28,"value":7,"text":"Start-up time 14 CK + 512 ms; [SUT=111]; default value"}]}},"HIGH":{"bits":[{"name":"BOOTRST","text":"Select Reset Vector","default_value":"1"},{"name":"BOOTSZ0","text":"Select Boot Size","default_value":"0"},{"name":"BOOTSZ1","text":"Select Boot Size","default_value":"0"},{"name":"DWEN","text":"Enable debugWire","default_value":"1"},{"name":"DUVRDINIT","text":"Reset Value of DUVRDRegister","default_value":"0"}],"options":{"0x10":[{"mask":16,"value":0,"text":"DUVR mode on; [DUVR=0]"}],"0x08":[{"mask":8,"value":0,"text":"Debug Wire enable; [DWEN=0]"}],"0x06":[{"mask":6,"value":6,"text":"Boot Flash section size=256 words Boot start address=$3F00; [BOOTSZ=11]"},{"mask":6,"value":4,"text":"Boot Flash section size=512 words Boot start address=$3E00; [BOOTSZ=10]"},{"mask":6,"value":2,"text":"Boot Flash section size=1024 words Boot start address=$3C00; [BOOTSZ=01]"},{"mask":6,"value":0,"text":"Boot Flash section size=2048 words Boot start address=$3800; [BOOTSZ=00] ; default value"}],"0x01":[{"mask":1,"value":0,"text":"Boot Reset vector Enabled (default address=$0000); [BOOTRST=0]"}]}}};create_interface();
