fuse_defs = {"LOW":{"bits":[{"name":"CKSEL0","text":"Select Clock Source","default_value":"1"},{"name":"CKSEL1","text":"Select Clock Source","default_value":"0"},{"name":"CKSEL2","text":"Select Clock Source","default_value":"0"},{"name":"CKSEL3","text":"Select Clock Source","default_value":"1"},{"name":"SUT0","text":"Select start-up time","default_value":"1"},{"name":"SUT1","text":"Select start-up time","default_value":"1"},{"name":"CKOPT","text":"Oscillator options","default_value":"1"},{"name":"PLLCK","text":"Use PLL for internal clock","default_value":"1"}],"options":{"0x40":[{"mask":64,"value":0,"text":"CKOPT fuse (operation dependent of CKSEL fuses); [CKOPT=0]"}],"0xBF":[{"mask":191,"value":1,"text":"PLL Clock; Start-up time: 1K CK + 0 ms; [CKSEL=0001 SUT=00]"},{"mask":191,"value":17,"text":"PLL Clock; Start-up time: 1K CK + 4 ms; [CKSEL=0001 SUT=01]"},{"mask":191,"value":33,"text":"PLL Clock; Start-up time: 1K CK + 64 ms; [CKSEL=0001 SUT=10]"},{"mask":191,"value":49,"text":"PLL Clock; Start-up time: 16K CK + 64 ms; [CKSEL=0001 SUT=11]"},{"mask":191,"value":128,"text":"Ext. Clock; Start-up time: 6 CK + 0 ms; [CKSEL=0000 SUT=00]"},{"mask":191,"value":144,"text":"Ext. Clock; Start-up time: 6 CK + 4 ms; [CKSEL=0000 SUT=01]"},{"mask":191,"value":160,"text":"Ext. Clock; Start-up time: 6 CK + 64 ms; [CKSEL=0000 SUT=10]"},{"mask":191,"value":129,"text":"Int. RC Osc. 1 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0001 SUT=00]"},{"mask":191,"value":145,"text":"Int. RC Osc. 1 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0001 SUT=01]"},{"mask":191,"value":161,"text":"Int. RC Osc. 1 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0001 SUT=10]; default value"},{"mask":191,"value":130,"text":"Int. RC Osc. 2 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0010 SUT=00]"},{"mask":191,"value":146,"text":"Int. RC Osc. 2 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0010 SUT=01]"},{"mask":191,"value":162,"text":"Int. RC Osc. 2 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0010 SUT=10]"},{"mask":191,"value":131,"text":"Int. RC Osc. 4 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0011 SUT=00]"},{"mask":191,"value":147,"text":"Int. RC Osc. 4 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0011 SUT=01]"},{"mask":191,"value":163,"text":"Int. RC Osc. 4 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0011 SUT=10]"},{"mask":191,"value":132,"text":"Int. RC Osc. 8 MHz; Start-up time: 6 CK + 0 ms; [CKSEL=0100 SUT=00]"},{"mask":191,"value":148,"text":"Int. RC Osc. 8 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0100 SUT=01]"},{"mask":191,"value":164,"text":"Int. RC Osc. 8 MHz; Start-up time: 6 CK + 64 ms; [CKSEL=0100 SUT=10]"},{"mask":191,"value":133,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=0101 SUT=00]"},{"mask":191,"value":149,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=0101 SUT=01]"},{"mask":191,"value":165,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=0101 SUT=10]"},{"mask":191,"value":181,"text":"Ext. RC Osc.         -  0.9 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0101 SUT=11]"},{"mask":191,"value":134,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=0110 SUT=00]"},{"mask":191,"value":150,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=0110 SUT=01]"},{"mask":191,"value":166,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=0110 SUT=10]"},{"mask":191,"value":182,"text":"Ext. RC Osc. 0.9 MHz -  3.0 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0110 SUT=11]"},{"mask":191,"value":135,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=0111 SUT=00]"},{"mask":191,"value":151,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=0111 SUT=01]"},{"mask":191,"value":167,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=0111 SUT=10]"},{"mask":191,"value":183,"text":"Ext. RC Osc. 3.0 MHz -  8.0 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=0111 SUT=11]"},{"mask":191,"value":136,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 18 CK + 0 ms; [CKSEL=1000 SUT=00]"},{"mask":191,"value":152,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 18 CK + 4 ms; [CKSEL=1000 SUT=01]"},{"mask":191,"value":168,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 18 CK + 64 ms; [CKSEL=1000 SUT=10]"},{"mask":191,"value":184,"text":"Ext. RC Osc. 8.0 MHz - 12.0 MHz; Start-up time: 6 CK + 4 ms; [CKSEL=1000 SUT=11]"},{"mask":191,"value":137,"text":"Ext. Low-Freq. Crystal; Start-up time: 1K CK + 4 ms; [CKSEL=1001 SUT=00]"},{"mask":191,"value":153,"text":"Ext. Low-Freq. Crystal; Start-up time: 1K CK + 64 ms; [CKSEL=1001 SUT=01]"},{"mask":191,"value":169,"text":"Ext. Low-Freq. Crystal; Start-up time: 32K CK + 64 ms; [CKSEL=1001 SUT=10]"},{"mask":191,"value":138,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 258 CK + 4 ms; [CKSEL=1010 SUT=00]"},{"mask":191,"value":154,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 258 CK + 64 ms; [CKSEL=1010 SUT=01]"},{"mask":191,"value":170,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 1K CK + 0 ms; [CKSEL=1010 SUT=10]"},{"mask":191,"value":186,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 1K CK + 4 ms; [CKSEL=1010 SUT=11]"},{"mask":191,"value":139,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 1K CK + 64 ms; [CKSEL=1011 SUT=00]"},{"mask":191,"value":155,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 16K CK + 0 ms; [CKSEL=1011 SUT=01]"},{"mask":191,"value":171,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 16K CK + 4 ms; [CKSEL=1011 SUT=10]"},{"mask":191,"value":187,"text":"Ext. Crystal\/Resonator Low Freq.; Start-up time: 16K CK + 64 ms; [CKSEL=1011 SUT=11]"},{"mask":191,"value":140,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 258 CK + 4 ms; [CKSEL=1100 SUT=00]"},{"mask":191,"value":156,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 258 CK + 64 ms; [CKSEL=1100 SUT=01]"},{"mask":191,"value":172,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 1K CK + 0 ms; [CKSEL=1100 SUT=10]"},{"mask":191,"value":188,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 1K CK + 4 ms; [CKSEL=1100 SUT=11]"},{"mask":191,"value":141,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 1K CK + 64 ms; [CKSEL=1101 SUT=00]"},{"mask":191,"value":157,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 16K CK + 0 ms; [CKSEL=1101 SUT=01]"},{"mask":191,"value":173,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 16K CK + 4 ms; [CKSEL=1101 SUT=10]"},{"mask":191,"value":189,"text":"Ext. Crystal\/Resonator Medium Freq.; Start-up time: 16K CK + 64 ms; [CKSEL=1101 SUT=11]"},{"mask":191,"value":142,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 258 CK + 4 ms; [CKSEL=1110 SUT=00]"},{"mask":191,"value":158,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 258 CK + 64 ms; [CKSEL=1110 SUT=01]"},{"mask":191,"value":174,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 1K CK + 0 ms; [CKSEL=1110 SUT=10]"},{"mask":191,"value":190,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 1K CK + 4 ms; [CKSEL=1110 SUT=11]"},{"mask":191,"value":143,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 1K CK + 64 ms; [CKSEL=1111 SUT=00]"},{"mask":191,"value":159,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 16K CK + 0 ms; [CKSEL=1111 SUT=01]"},{"mask":191,"value":175,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 16K CK + 4 ms; [CKSEL=1111 SUT=10]"},{"mask":191,"value":191,"text":"Ext. Crystal\/Resonator High Freq.; Start-up time: 16K CK + 64 ms; [CKSEL=1111 SUT=11]"}]}},"HIGH":{"bits":[{"name":"BODEN","text":"Brown out detector enable","default_value":"1"},{"name":"BODLEVEL","text":"Brown out detector trigger level","default_value":"1"},{"name":"EESAVE","text":"EEPROM memory is preserved through the Chip Erase","default_value":"1"},{"name":"SPIEN","text":"Enable Serial Program and Data Downloading","default_value":"0"},{"name":"RSTDISBL","text":"Select if PB\/ is I\/O pin or RESET pin","default_value":"1"}],"options":{"0x10":[{"mask":16,"value":0,"text":"Reset Disabled (Enable PB7 as i\/o pin); [RSTDISBL=0]"}],"0x08":[{"mask":8,"value":0,"text":"Serial program downloading (SPI) enabled; [SPIEN=0]"}],"0x04":[{"mask":4,"value":0,"text":"Preserve EEPROM memory through the Chip Erase cycle; [EESAVE=0]"}],"0x02":[{"mask":2,"value":0,"text":"Brown-out detection level at VCC=4.0 V; [BODLEVEL=0]"},{"mask":2,"value":2,"text":"Brown-out detection level at VCC=2.7 V; [BODLEVEL=1]"}],"0x01":[{"mask":1,"value":0,"text":"Brown-out detection enabled; [BODEN=0]"}]}}};create_interface();
