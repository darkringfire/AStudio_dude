fuse_defs = {"LOW":{"bits":[{"name":"CKSEL0","text":"Select Clock Source","default_value":"1"},{"name":"CKSEL1","text":"Select Clock Source","default_value":"0"},{"name":"CKSEL2","text":"Select Clock Source","default_value":"0"},{"name":"CKSEL3","text":"Select Clock Source","default_value":"0"},{"name":"SUT0","text":"Select start-up time","default_value":"0"},{"name":"SUT1","text":"Select start-up time","default_value":"0"},{"name":"BODEN","text":"Brown out detector enable","default_value":"1"},{"name":"BODLEVEL","text":"Brown out detector trigger level","default_value":"1"}],"options":{"0x80":[{"mask":128,"value":0,"text":"Brown-out detection level at VCC=4.0 V; [BODLEVEL=0]"},{"mask":128,"value":128,"text":"Brown-out detection level at VCC=2.7 V; [BODLEVEL=1]"}],"0x40":[{"mask":64,"value":0,"text":"Brown-out detection enabled; [BODEN=0]"}],"0x3F":[{"mask":63,"value":0,"text":"Ext. Clock; Start-up time: 6 CK + 0 ms; [CKSEL=0000 SUT=00]"},{"mask":63,"value":16,"text":"Ext. Clock; Start-up time: 6 CK + 4 ms; [CKSEL=0000 SUT=01]"},{"mask":63,"value":32,"text":"Ext. Clock; Start-up time: 6 CK + 64 ms; [CKSEL=0000 SUT=10]"},{"mask":63,"value":1,"text":"Int. RC Osc. 1 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0001 SUT=00]"},{"mask":63,"value":17,"text":"Int. RC Osc. 1 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0001 SUT=01]"},{"mask":63,"value":33,"text":"Int. RC Osc. 1 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0001 SUT=10]; default value"},{"mask":63,"value":2,"text":"Int. RC Osc. 2 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0010 SUT=00]"},{"mask":63,"value":18,"text":"Int. RC Osc. 2 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0010 SUT=01]"},{"mask":63,"value":34,"text":"Int. RC Osc. 2 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0010 SUT=10]"},{"mask":63,"value":3,"text":"Int. RC Osc. 4 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0011 SUT=00]"},{"mask":63,"value":19,"text":"Int. RC Osc. 4 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0011 SUT=01]"},{"mask":63,"value":35,"text":"Int. RC Osc. 4 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0011 SUT=10]"},{"mask":63,"value":4,"text":"Int. RC Osc. 8 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0100 SUT=00]"},{"mask":63,"value":20,"text":"Int. RC Osc. 8 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0100 SUT=01]"},{"mask":63,"value":36,"text":"Int. RC Osc. 8 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0100 SUT=10]"},{"mask":63,"value":5,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=0101 SUT=00]"},{"mask":63,"value":21,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=0101 SUT=01]"},{"mask":63,"value":37,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=0101 SUT=10]"},{"mask":63,"value":53,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0101 SUT=11]"},{"mask":63,"value":6,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=0110 SUT=00]"},{"mask":63,"value":22,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=0110 SUT=01]"},{"mask":63,"value":38,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=0110 SUT=10]"},{"mask":63,"value":54,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0110 SUT=11]"},{"mask":63,"value":7,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=0111 SUT=00]"},{"mask":63,"value":23,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=0111 SUT=01]"},{"mask":63,"value":39,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=0111 SUT=10]"},{"mask":63,"value":55,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0111 SUT=11]"},{"mask":63,"value":8,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=1000 SUT=00]"},{"mask":63,"value":24,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=1000 SUT=01]"},{"mask":63,"value":40,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=1000 SUT=10]"},{"mask":63,"value":56,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=1000 SUT=11]"},{"mask":63,"value":9,"text":"Ext. Low-Freq. Crystal; Start-up time: 1K CK + 4 ms; [CKSEL=1001 SUT=00]"},{"mask":63,"value":25,"text":"Ext. Low-Freq. Crystal; Start-up time: 1K CK + 64 ms; [CKSEL=1001 SUT=01]"},{"mask":63,"value":41,"text":"Ext. Low-Freq. Crystal; Start-up time: 32K CK + 64 ms; [CKSEL=1001 SUT=10]"},{"mask":63,"value":10,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 258 CK + 4 ms; [CKSEL=1010 SUT=00]"},{"mask":63,"value":26,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 258 CK + 64 ms; [CKSEL=1010 SUT=01]"},{"mask":63,"value":42,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 1K CK + 0 ms; [CKSEL=1010 SUT=10]"},{"mask":63,"value":58,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 1K CK + 4 ms; [CKSEL=1010 SUT=11]"},{"mask":63,"value":11,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 1K CK + 64 ms; [CKSEL=1011 SUT=00]"},{"mask":63,"value":27,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 16K CK + 0 ms; [CKSEL=1011 SUT=01]"},{"mask":63,"value":43,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 16K CK + 4 ms; [CKSEL=1011 SUT=10]"},{"mask":63,"value":59,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 16K CK + 64 ms; [CKSEL=1011 SUT=11]"},{"mask":63,"value":12,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 258 CK + 4 ms; [CKSEL=1100 SUT=00]"},{"mask":63,"value":28,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 258 CK + 64 ms; [CKSEL=1100 SUT=01]"},{"mask":63,"value":44,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 1K CK + 0 ms; [CKSEL=1100 SUT=10]"},{"mask":63,"value":60,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 1K CK + 4 ms; [CKSEL=1100 SUT=11]"},{"mask":63,"value":13,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 1K CK + 64 ms; [CKSEL=1101 SUT=00]"},{"mask":63,"value":29,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 16K CK + 0 ms; [CKSEL=1101 SUT=01]"},{"mask":63,"value":45,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 16K CK + 4 ms; [CKSEL=1101 SUT=10]"},{"mask":63,"value":61,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 16K CK + 64 ms; [CKSEL=1101 SUT=11]"},{"mask":63,"value":14,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 258 CK + 4 ms; [CKSEL=1110 SUT=00]"},{"mask":63,"value":30,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 258 CK + 64 ms; [CKSEL=1110 SUT=01]"},{"mask":63,"value":46,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 1K CK + 0 ms; [CKSEL=1110 SUT=10]"},{"mask":63,"value":62,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 1K CK + 4 ms; [CKSEL=1110 SUT=11]"},{"mask":63,"value":15,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 1K CK + 64 ms; [CKSEL=1111 SUT=00]"},{"mask":63,"value":31,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 16K CK + 0 ms; [CKSEL=1111 SUT=01]"},{"mask":63,"value":47,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 16K CK + 4 ms; [CKSEL=1111 SUT=10]"},{"mask":63,"value":63,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 16K CK + 64 ms; [CKSEL=1111 SUT=11]"}]}},"HIGH":{"bits":[{"name":"BOOTRST","text":"Select Reset Vector","default_value":"1"},{"name":"BOOTSZ0","text":"Select Boot Size","default_value":"0"},{"name":"BOOTSZ1","text":"Select Boot Size","default_value":"0"},{"name":"EESAVE","text":"EEPROM memory is preserved through chip erase","default_value":"1"},{"name":"CKOPT","text":"Oscillator Options","default_value":"1"},{"name":"SPIEN","text":"Enable Serial programming and Data Downloading","default_value":"0"},{"name":"JTAGEN","text":"Enable JTAG","default_value":"0"},{"name":"OCDEN","text":"Enable OCD","default_value":"1"}],"options":{"0x80":[{"mask":128,"value":0,"text":"On-Chip Debug Enabled; [OCDEN=0]"}],"0x40":[{"mask":64,"value":0,"text":"JTAG Interface Enabled; [JTAGEN=0]"}],"0x20":[{"mask":32,"value":0,"text":"Serial program downloading (SPI) enabled; [SPIEN=0]"}],"0x08":[{"mask":8,"value":0,"text":"Preserve EEPROM memory through the Chip Erase cycle; [EESAVE=0]"}],"0x06":[{"mask":6,"value":6,"text":"Boot Flash section size=512 words Boot start address=$7E00; [BOOTSZ=11]"},{"mask":6,"value":4,"text":"Boot Flash section size=1024 words Boot start address=$7C00; [BOOTSZ=10]"},{"mask":6,"value":2,"text":"Boot Flash section size=2048 words Boot start address=$7800; [BOOTSZ=01]"},{"mask":6,"value":0,"text":"Boot Flash section size=4096 words Boot start address=$7000; [BOOTSZ=00] ; default value"}],"0x01":[{"mask":1,"value":0,"text":"Boot Reset vector Enabled (default address=$0000); [BOOTRST=0]"}],"0x10":[{"mask":16,"value":0,"text":"CKOPT fuse (operation dependent of CKSEL fuses); [CKOPT=0]"}]}},"EXTENDED":{"bits":[{"name":"WDTON","text":"Watchdog timer always on","default_value":"1"},{"name":"CompMode","text":"Compabillity mode","default_value":"1"}],"options":{"0x02":[{"mask":2,"value":0,"text":"ATmega103 Compatibility Mode [M103C=0]"}],"0x01":[{"mask":1,"value":0,"text":"Watchdog Timer always on; [WDTON=0]"}]}}};create_interface();
