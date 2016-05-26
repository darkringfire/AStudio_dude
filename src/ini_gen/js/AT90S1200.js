fuse_defs = {
    "LOW": {
        "bits": [],
        "options": {
            "0x20": [{
                "mask": 32,
                "value": 0,
                "text": "Serial program downloading (SPI) enabled"
            }],
            "0x01": [{
                "mask": 1,
                "value": 0,
                "text": "Internal RC oscillator enabled"
            }, {
                "mask": 1,
                "value": 1,
                "text": "External clock enabled"
            }]
        }
    }
};
create_interface();