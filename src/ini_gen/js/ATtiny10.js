fuse_defs = {
    "BYTE0": {
        "bits": [{
            "name": "RSTDISBL",
            "text": "Disable external reset",
            "default_value": "1"
        }, {
            "name": "WDTON",
            "text": "Watch dog timer always on",
            "default_value": "1"
        }, {
            "name": "CKOUT",
            "text": "Output external clock",
            "default_value": "1"
        }],
        "options": {
            "0x04": [{
                "mask": 4,
                "value": 0,
                "text": "Output external clock"
            }],
            "0x02": [{
                "mask": 2,
                "value": 0,
                "text": "Watch dog timer always on"
            }],
            "0x01": [{
                "mask": 1,
                "value": 0,
                "text": "Disable external reset"
            }]
        }
    }
};
create_interface();