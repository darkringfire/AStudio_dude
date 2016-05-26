$(document).ready(function(){
	var $file = $("#file");
	var $ini = $("#ini");
	var $part = $("#part");
	$ini.on("click", function() {
		$this = $(this);
		$this.select();
		$this.mouseup(function() {
			$this.unbind("mouseup");
			return false;
		});
	});
	$file.on("click", function() {
		$this = $(this);
		$this.select();
		$this.mouseup(function() {
			$this.unbind("mouseup");
			return false;
		});
	});
	$part.append(
		$("<option />").text("")
	);
	for (var i in parts) {
		$part.append(
			$("<option />").val(parts[i]).text(parts[i])
		);
	}
	$part.change(function(){
		partName = $part.val();
        iniName = partName.toLowerCase();
        iniName = iniName.replace("attiny", "t");
        iniName = iniName.replace("atmega", "m");
        iniName = iniName.replace("atxmega", "x");
        iniName = iniName.replace("at90can", "c");
        iniName = iniName.replace("at90s", "");
        iniName = iniName.replace("at90", "");
		$file.val(iniName+".ini");
		var script = document.createElement('script');
		script.setAttribute('src', 'js/' + partName + '.js');
		document.getElementsByTagName('head')[0].appendChild(script);
	});
});

function create_interface(){
	var $part = $("#part");
	var $file = $("#file");
	var $ini = $("#ini");
	$ini.empty();
	
	var iniArr = Array();
	iniArr["main"] = Array();
	iniArr["default"] = Array();
	iniArr["main"]["fuses"] = Array();
	iniArr["main"]["options"] = Array();
	
	for (var fuse in fuse_defs) {
		switch (fuse) {
			case "LOW":
				dudefuse = "lfuse";
				break;
			case "HIGH":
				dudefuse = "hfuse";
				break;
			case "EXTENDED":
				dudefuse = "efuse";
				break;
			case "BYTE0":
				dudefuse = "fuse";
				break;
			default:
				dudefuse = fuse.toLowerCase();
		}
		if (iniArr.indexOf(dudefuse) == -1) {
			iniArr["main"]["fuses"].push(dudefuse);
			iniArr["main"][dudefuse] = Array();
		}
		var bits = fuse_defs[fuse]["bits"];
		var mul = 1;
		var defVal = 0xFF;
        // alert($.isArray(bits));
        for (var i = 0; i < 8; i++) {
            // alert(typeof bits[i]);
            if (typeof bits[i] === 'undefined') {
                iniArr["main"][dudefuse].push("");
            } else {
                iniArr["main"][dudefuse].push(bits[i].name);
                if (bits[i].default_value == "0") {
                    defVal -= mul;
                }
            }
            mul *= 2;
        }

		iniArr["default"][dudefuse] = "0x" + defVal.toString(16);
		var options = fuse_defs[fuse]["options"];
		for (var i in options) {
			var optionName = dudefuse+"_"+i;
			var option = options[i];
			iniArr["main"]["options"].push(optionName);
			iniArr[optionName] = Array();
			iniArr[optionName]["fuse"] = dudefuse;
			if (option.length > 1) {
				iniArr[optionName]["select"] = 1;
				for (j in option) {
					iniArr[optionName]["mask"] = "0x" + option[j].mask.toString(16);
					iniArr[optionName]["v"+option[j].value] = option[j].text;
				}
			} else {
				iniArr[optionName]["mask"] = "0x" + option[0].mask.toString(16);
				iniArr[optionName]["desc"] = option[0].text;
			}
		}
	}
	
	for (var i in iniArr) {
		$ini.append("["+i+"]\n");
		for (var j in iniArr[i]) {
			var a = iniArr[i][j];
			if ($.isArray(a)) {
				if (a.length > 0) {
					$ini.append(j + "=" + a.join(":") + "\n");
				}
			} else {
				$ini.append(j + "=" + a + "\n");
			}
		}
		$ini.append("\n");
	}
};