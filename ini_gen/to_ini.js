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
		$file.val(partName+".ini");
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
		var defVal = 0;
		for (var i in bits) {
			iniArr["main"][dudefuse].push(bits[i].name);
			if (bits[i].default_value == "1") {
				defVal += mul;
			}
			mul *= 2;
		}
		iniArr["default"][dudefuse] = defVal;
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
					iniArr[optionName]["mask"] = option[j].mask;
					iniArr[optionName]["v"+option[j].value] = option[j].text;
				}
			} else {
				iniArr[optionName]["mask"] = option[0].mask;
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