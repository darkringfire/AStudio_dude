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
            "name": "CKSEL2",
            "text": "Select Clock Source",
            "default_value": "0"
        }, {
            "name": "CKSEL3",
            "text": "Select Clock Source",
            "default_value": "0"
        }, {
            "name": "SUT0",
            "text": "Select start-up time",
            "default_value": "0"
        }, {
            "name": "SUT1",
            "text": "Select start-up time",
            "default_value": "1"
        }, {
            "name": "CKOUT",
            "text": "Clock output",
            "default_value": "1"
        }, {
            "name": "CKDIV8",
            "text": "Divide clock by 8",
            "default_value": "0"
        }],
        "options": {
            "0x80": [{
                "mask": 128,
                "value": 0,
                "text": "Divide clock by 8 internally; [CKDIV8=0]"
            }],
            "0x40": [{
                "mask": 64,
                "value": 0,
                "text": "Clock output on PORTB0; [CKOUT=0]"
            }],
            "0x3F": [{
                "mask": 63,
                "value": 0,
                "text": "Ext. Clock; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 0 ms;   [CKSEL=0000 SUT=00]"
            }, {
                "mask": 63,
                "value": 16,
                "text": "Ext. Clock; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 4.1 ms; [CKSEL=0000 SUT=01]"
            }, {
                "mask": 63,
                "value": 32,
                "text": "Ext. Clock; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 65 ms;  [CKSEL=0000 SUT=10]"
            }, {
                "mask": 63,
                "value": 2,
                "text": "Int. RC Osc. 8 MHz; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 0 ms;   [CKSEL=0010 SUT=00]"
            }, {
                "mask": 63,
                "value": 18,
                "text": "Int. RC Osc. 8 MHz; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 4.1 ms; [CKSEL=0010 SUT=01]"
            }, {
                "mask": 63,
                "value": 34,
                "text": "Int. RC Osc. 8 MHz; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 65 ms;  [CKSEL=0010 SUT=10]; default value"
            }, {
                "mask": 63,
                "value": 3,
                "text": "Int. RC Osc. 128kHz; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 0 ms;   [CKSEL=0011 SUT=00]"
            }, {
                "mask": 63,
                "value": 19,
                "text": "Int. RC Osc. 128kHz; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 4.1 ms; [CKSEL=0011 SUT=01]"
            }, {
                "mask": 63,
                "value": 35,
                "text": "Int. RC Osc. 128kHz; Start-up time PWRDWN\/RESET: 6 CK\/14 CK + 65 ms;  [CKSEL=0011 SUT=10]"
            }, {
                "mask": 63,
                "value": 4,
                "text": "Ext. Low-Freq. Crystal; Start-up time PWRDWN\/RESET: 1K CK\/14 CK + 0 ms;   [CKSEL=0100 SUT=00] "
            }, {
                "mask": 63,
                "value": 20,
                "text": "Ext. Low-Freq. Crystal; Start-up time PWRDWN\/RESET: 1K CK\/14 CK + 4.1 ms; [CKSEL=0100 SUT=01] "
            }, {
                "mask": 63,
                "value": 36,
                "text": "Ext. Low-Freq. Crystal; Start-up time PWRDWN\/RESET: 1K CK\/14 CK + 65 ms;  [CKSEL=0100 SUT=10] "
            }, {
                "mask": 63,
                "value": 5,
                "text": "Ext. Low-Freq. Crystal; Start-up time PWRDWN\/RESET: 32K CK\/14 CK + 0 ms;   [CKSEL=0101 SUT=00] "
            }, {
                "mask": 63,
                "value": 21,
                "text": "Ext. Low-Freq. Crystal; Start-up time PWRDWN\/RESET: 32K CK\/14 CK + 4.1 ms; [CKSEL=0101 SUT=01] "
            }, {
                "mask": 63,
                "value": 37,
                "text": "Ext. Low-Freq. Crystal; Start-up time PWRDWN\/RESET: 32K CK\/14 CK + 65 ms;  [CKSEL=0101 SUT=10] "
            }, {
                "mask": 63,
                "value": 6,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 4.1 ms;[CKSEL=0110 SUT=00] "
            }, {
                "mask": 63,
                "value": 22,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 65 ms; [CKSEL=0110 SUT=01] "
            }, {
                "mask": 63,
                "value": 38,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 0 ms;  [CKSEL=0110 SUT=10] "
            }, {
                "mask": 63,
                "value": 54,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 4.1 ms;[CKSEL=0110 SUT=11] "
            }, {
                "mask": 63,
                "value": 7,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 65 ms; [CKSEL=0111 SUT=00] "
            }, {
                "mask": 63,
                "value": 23,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 0 ms;  [CKSEL=0111 SUT=01] "
            }, {
                "mask": 63,
                "value": 39,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 4.1 ms;[CKSEL=0111 SUT=10] "
            }, {
                "mask": 63,
                "value": 55,
                "text": "Ext. Full-swing Crystal; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 65 ms; [CKSEL=0111 SUT=11] "
            }, {
                "mask": 63,
                "value": 8,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 4.1 ms; [CKSEL=1000 SUT=00]   "
            }, {
                "mask": 63,
                "value": 24,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 65 ms;  [CKSEL=1000 SUT=01]   "
            }, {
                "mask": 63,
                "value": 40,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 0 ms;   [CKSEL=1000 SUT=10]   "
            }, {
                "mask": 63,
                "value": 56,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 4.1 ms; [CKSEL=1000 SUT=11]   "
            }, {
                "mask": 63,
                "value": 9,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 65 ms;  [CKSEL=1001 SUT=00]   "
            }, {
                "mask": 63,
                "value": 25,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 0 ms;   [CKSEL=1001 SUT=01]   "
            }, {
                "mask": 63,
                "value": 41,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 4.1 ms; [CKSEL=1001 SUT=10]   "
            }, {
                "mask": 63,
                "value": 57,
                "text": "Ext. Crystal Osc.; Frequency 0.4-0.9 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 65 ms;  [CKSEL=1001 SUT=11]   "
            }, {
                "mask": 63,
                "value": 10,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 4.1 ms; [CKSEL=1010 SUT=00]   "
            }, {
                "mask": 63,
                "value": 26,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 65 ms;  [CKSEL=1010 SUT=01]   "
            }, {
                "mask": 63,
                "value": 42,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 0 ms;   [CKSEL=1010 SUT=10]   "
            }, {
                "mask": 63,
                "value": 58,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 4.1 ms; [CKSEL=1010 SUT=11]   "
            }, {
                "mask": 63,
                "value": 11,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 65 ms;  [CKSEL=1011 SUT=00]   "
            }, {
                "mask": 63,
                "value": 27,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 0 ms;   [CKSEL=1011 SUT=01]   "
            }, {
                "mask": 63,
                "value": 43,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 4.1 ms; [CKSEL=1011 SUT=10]   "
            }, {
                "mask": 63,
                "value": 59,
                "text": "Ext. Crystal Osc.; Frequency 0.9-3.0 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 65 ms;  [CKSEL=1011 SUT=11]   "
            }, {
                "mask": 63,
                "value": 12,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 4.1 ms; [CKSEL=1100 SUT=00]   "
            }, {
                "mask": 63,
                "value": 28,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 65 ms;  [CKSEL=1100 SUT=01]   "
            }, {
                "mask": 63,
                "value": 44,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 0 ms;   [CKSEL=1100 SUT=10]   "
            }, {
                "mask": 63,
                "value": 60,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 4.1 ms; [CKSEL=1100 SUT=11]   "
            }, {
                "mask": 63,
                "value": 13,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 65 ms;  [CKSEL=1101 SUT=00]   "
            }, {
                "mask": 63,
                "value": 29,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 0 ms;   [CKSEL=1101 SUT=01]   "
            }, {
                "mask": 63,
                "value": 45,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 4.1 ms; [CKSEL=1101 SUT=10]   "
            }, {
                "mask": 63,
                "value": 61,
                "text": "Ext. Crystal Osc.; Frequency 3.0-8.0 MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 65 ms;  [CKSEL=1101 SUT=11]   "
            }, {
                "mask": 63,
                "value": 14,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 4.1 ms; [CKSEL=1110 SUT=00]   "
            }, {
                "mask": 63,
                "value": 30,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 258 CK\/14 CK + 65 ms;  [CKSEL=1110 SUT=01]   "
            }, {
                "mask": 63,
                "value": 46,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 0 ms;   [CKSEL=1110 SUT=10]   "
            }, {
                "mask": 63,
                "value": 62,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 4.1 ms; [CKSEL=1110 SUT=11]   "
            }, {
                "mask": 63,
                "value": 15,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 1K CK \/14 CK + 65 ms;  [CKSEL=1111 SUT=00]   "
            }, {
                "mask": 63,
                "value": 31,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 0 ms;   [CKSEL=1111 SUT=01]   "
            }, {
                "mask": 63,
                "value": 47,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 4.1 ms; [CKSEL=1111 SUT=10]   "
            }, {
                "mask": 63,
                "value": 63,
                "text": "Ext. Crystal Osc.; Frequency 8.0-    MHz; Start-up time PWRDWN\/RESET: 16K CK\/14 CK + 65 ms;  [CKSEL=1111 SUT=11]   "
            }]
        }
    },
    "HIGH": {
        "bits": [{
            "name": "BOOTRST",
            "text": "Select reset vector",
            "default_value": "1"
        }, {
            "name": "BOOTSZ0",
            "text": "Select boot size",
            "default_value": "0"
        }, {
            "name": "BOOTSZ1",
            "text": "Select boot size",
            "default_value": "0"
        }, {
            "name": "EESAVE",
            "text": "EEPROM memory is preserved through chip erase",
            "default_value": "1"
        }, {
            "name": "WDTON",
            "text": "Watchdog Timer Always On",
            "default_value": "1"
        }, {
            "name": "SPIEN",
            "text": "Enable Serial programming and Data Downloading",
            "default_value": "0"
        }, {
            "name": "DWEN",
            "text": "debugWIRE Enable",
            "default_value": "1"
        }, {
            "name": "RSTDISBL",
            "text": "External reset disable",
            "default_value": "1"
        }],
        "options": {
            "0x80": [{
                "mask": 128,
                "value": 0,
                "text": "Reset Disabled (Enable PC6 as i\/o pin); [RSTDISBL=0]"
            }],
            "0x40": [{
                "mask": 64,
                "value": 0,
                "text": "Debug Wire enable; [DWEN=0]"
            }],
            "0x20": [{
                "mask": 32,
                "value": 0,
                "text": "Serial program downloading (SPI) enabled; [SPIEN=0]"
            }],
            "0x10": [{
                "mask": 16,
                "value": 0,
                "text": "Watch-dog Timer always on; [WDTON=0]"
            }],
            "0x08": [{
                "mask": 8,
                "value": 0,
                "text": "Preserve EEPROM memory through the Chip Erase cycle; [EESAVE=0]"
            }],
            "0x06": [{
                "mask": 6,
                "value": 6,
                "text": "Boot Flash section size=256 words Boot start address=$3F00; [BOOTSZ=11]"
            }, {
                "mask": 6,
                "value": 4,
                "text": "Boot Flash section size=512 words Boot start address=$3E00; [BOOTSZ=10]"
            }, {
                "mask": 6,
                "value": 2,
                "text": "Boot Flash section size=1024 words Boot start address=$3C00; [BOOTSZ=01]"
            }, {
                "mask": 6,
                "value": 0,
                "text": "Boot Flash section size=2048 words Boot start address=$3800; [BOOTSZ=00] ; default value"
            }],
            "0x01": [{
                "mask": 1,
                "value": 0,
                "text": "Boot Reset vector Enabled (default address=$0000); [BOOTRST=0]"
            }]
        }
    },
    "EXTENDED": {
        "bits": [{
            "name": "BODLEVEL0",
            "text": "Brown-out Detector trigger level",
            "default_value": "1"
        }, {
            "name": "BODLEVEL1",
            "text": "Brown-out Detector trigger level",
            "default_value": "1"
        }, {
            "name": "BODLEVEL2",
            "text": "Brown-out Detector trigger level",
            "default_value": "1"
        }],
        "options": {
            "0x07": [{
                "mask": 7,
                "value": 4,
                "text": "Brown-out detection level at VCC=4.3 V; [BODLEVEL=100] "
            }, {
                "mask": 7,
                "value": 5,
                "text": "Brown-out detection level at VCC=2.7 V; [BODLEVEL=101] "
            }, {
                "mask": 7,
                "value": 6,
                "text": "Brown-out detection level at VCC=1.8 V; [BODLEVEL=110] "
            }, {
                "mask": 7,
                "value": 7,
                "text": "Brown-out detection disabled; [BODLEVEL=111]                              "
            }]
        }
    }
};
create_interface();