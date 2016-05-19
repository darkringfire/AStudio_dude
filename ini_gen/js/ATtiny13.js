fuse_defs = {
    "LOW": {
        "bits": [{
            "name": "CKSEL0",
            "text": "Select Clock Source",
            "default_value": "0"
        }, {
            "name": "CKSEL1",
            "text": "Select Clock Source",
            "default_value": "1"
        }, {
            "name": "SUT0",
            "text": "Select start-up time",
            "default_value": "0"
        }, {
            "name": "SUT1",
            "text": "Select start-up time",
            "default_value": "1"
        }, {
            "name": "CKDIV8",
            "text": "Start up with system clock divided by 8",
            "default_value": "0"
        }, {
            "name": "WDTON",
            "text": "Watch dog timer always on",
            "default_value": "1"
        }, {
            "name": "EESAVE",
            "text": "Keep EEprom contents during chip erase",
            "default_value": "1"
        }, {
            "name": "SPIEN",
            "text": "SPI programming enable",
            "default_value": "0"
        }],
        "options": {
            "0x80": [{
                "mask": 128,
                "value": 0,
                "text": "Serial program downloading (SPI) enabled; [SPIEN=0]"
            }],
            "0x40": [{
                "mask": 64,
                "value": 0,
                "text": "Preserve EEPROM memory through the Chip Erase cycle; [EESAVE=0]"
            }],
            "0x20": [{
                "mask": 32,
                "value": 0,
                "text": "Watch-dog Timer always on; [WDTON=0]"
            }],
            "0x10": [{
                "mask": 16,
                "value": 0,
                "text": "Divide clock by 8 internally; [CKDIV8=0]"
            }],
            "0x0F": [{
                "mask": 15,
                "value": 0,
                "text": "Ext. Clock; Start-up time: 14 CK + 0 ms; [CKSEL=00 SUT=00]"
            }, {
                "mask": 15,
                "value": 4,
                "text": "Ext. Clock; Start-up time: 14 CK + 4 ms; [CKSEL=00 SUT=01]"
            }, {
                "mask": 15,
                "value": 8,
                "text": "Ext. Clock; Start-up time: 14 CK + 64 ms; [CKSEL=00 SUT=10]"
            }, {
                "mask": 15,
                "value": 1,
                "text": "Int. RC Osc. 4.8 MHz; Start-up time: 14 CK + 0 ms; [CKSEL=01 SUT=00] "
            }, {
                "mask": 15,
                "value": 5,
                "text": "Int. RC Osc. 4.8 MHz; Start-up time: 14 CK + 4 ms; [CKSEL=01 SUT=01] "
            }, {
                "mask": 15,
                "value": 9,
                "text": "Int. RC Osc. 4.8 MHz; Start-up time: 14 CK + 64 ms; [CKSEL=01 SUT=10]"
            }, {
                "mask": 15,
                "value": 2,
                "text": "Int. RC Osc. 9.6 MHz; Start-up time: 14 CK + 0 ms; [CKSEL=10 SUT=00] "
            }, {
                "mask": 15,
                "value": 6,
                "text": "Int. RC Osc. 9.6 MHz; Start-up time: 14 CK + 4 ms; [CKSEL=10 SUT=01] "
            }, {
                "mask": 15,
                "value": 10,
                "text": "Int. RC Osc. 9.6 MHz; Start-up time: 14 CK + 64 ms; [CKSEL=10 SUT=10]; default value"
            }, {
                "mask": 15,
                "value": 3,
                "text": "Int. RC Osc. 128 kHz; Start-up time: 14 CK + 0 ms; [CKSEL=11 SUT=00] "
            }, {
                "mask": 15,
                "value": 7,
                "text": "Int. RC Osc. 128 kHz; Start-up time: 14 CK + 4 ms; [CKSEL=11 SUT=01] "
            }, {
                "mask": 15,
                "value": 11,
                "text": "Int. RC Osc. 128 kHz; Start-up time: 14 CK + 64 ms; [CKSEL=11 SUT=10]"
            }]
        }
    },
    "HIGH": {
        "bits": [{
            "name": "RSTDISBL",
            "text": "Disable external reset",
            "default_value": "1"
        }, {
            "name": "BODLEVEL0",
            "text": "Enable BOD and select level",
            "default_value": "1"
        }, {
            "name": "BODLEVEL1",
            "text": "Enable BOD and select level",
            "default_value": "1"
        }, {
            "name": "DWEN",
            "text": "DebugWire Enable",
            "default_value": "1"
        }, {
            "name": "SELFPRGEN",
            "text": "Self Programming Enable",
            "default_value": "1"
        }],
        "options": {
            "0x10": [{
                "mask": 16,
                "value": 0,
                "text": "Self Programming enable; [SELFPRGEN=0]"
            }],
            "0x08": [{
                "mask": 8,
                "value": 0,
                "text": "Debug Wire enable; [DWEN=0]"
            }],
            "0x06": [{
                "mask": 6,
                "value": 0,
                "text": "Brown-out detection level at VCC=4.3 V; [BODLEVEL=00]"
            }, {
                "mask": 6,
                "value": 2,
                "text": "Brown-out detection level at VCC=2.7 V; [BODLEVEL=01]"
            }, {
                "mask": 6,
                "value": 4,
                "text": "Brown-out detection level at VCC=1.8 V; [BODLEVEL=10]"
            }, {
                "mask": 6,
                "value": 6,
                "text": "Brown-out detection disabled; [BODLEVEL=11]"
            }],
            "0x01": [{
                "mask": 1,
                "value": 0,
                "text": "Reset Disabled (Enable PB5 as i\/o pin); [RSTDISBL=0]"
            }]
        }
    }
};
create_interface();