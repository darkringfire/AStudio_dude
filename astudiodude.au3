#include <Array.au3>
#include <GUIConstantsEx.au3> 
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <StringConstants.au3>
#include <ComboConstants.au3>
#include <FontConstants.au3>

const $posLeft = 10
const $posTop = 10
const $posY = 20
const $posH = 5
const $posV = 25
const $posVs = 18

const $posButtonX = 50
const $posProgX = 400
const $posDevX = 200
const $posPathLeft = 30
const $posPathX = 555

const $posFuseStepX = 100
const $posFuseTop = $posTop + $posV * 4

const $posOptionX = 650


global $conf = "\avrdude.ini"

global $programmer = ""
global $device = ""

global $hex = ""
global $eep = ""

global $programmers = ObjCreate("Scripting.Dictionary")
global $devices = ObjCreate("Scripting.Dictionary")

global $fuseBytes = ObjCreate("Scripting.Dictionary")
;global $fuseBits = ObjCreate("Scripting.Dictionary")
global $fuseOptions = ObjCreate("Scripting.Dictionary")
global $fuseOptionsValues = ObjCreate("Scripting.Dictionary")
global $fuseInfoCtrls = ObjCreate("Scripting.Dictionary")

for $i = 1 to $CmdLine[0]
    switch (StringLeft($CmdLine[$i], 2))
        case "-p"
            $project = StringTrimLeft($CmdLine[$i], 2)
        case "-t"
            $target = StringTrimLeft($CmdLine[$i], 2)
        case "-a"
            $auto = StringTrimLeft($CmdLine[$i], 2)
    endswitch
next

if IsDeclared("project") then
    $conf = $project & $conf
else
    $conf = @UserProfileDir & $conf
endif

LoadProjectConf()

if IsDeclared("target") then
    $hex = $target & ".hex"
    $eep = $target & ".eep"
endif

ReadDudeConf()

if not $programmers.Exists($programmer) then
    $programmer = $programmers.Keys[0]
endif
if not $devices.Exists($device) then
    $device = $devices.Keys[0]
endif

InitGUI()

ProgrammerApply()
DeviceApply()


While (1)
  Sleep(1000)
WEnd 

;=======================================================================
;=======================================================================

;==================== READ DUDE CONF ===================================================

func ReadDudeConf()
    Local $progArr[0][3]
    Local $devArr[0][3]
    
    $dudeConf = @ScriptDir & "\avrdude.conf"
    $dudeConfFile = FileOpen($dudeConf)
    if ($dudeConfFile <> 0) then
        $type = ""
        $id = ""
        $desc = ""
        $parent = ""
        $line = ""
        do
            $line = FileReadLine($dudeConfFile)
            $eof = @error
            if $eof = 0 then
                $match = StringRegExp($line, '^\s*(\w+)(?:\s*(?:=|\sparent\s)\s*"(.+)")?', $STR_REGEXPARRAYMATCH)
            endif
            $matched = @error
            if $matched = 0 or $eof <> 0 then
                select 
                    case $eof <> 0 or $match[0] = "programmer" or $match[0] = "part"
                        if $id <> "" then
                            if $type = "programmer" then
                                _ArrayAdd($progArr, $id & "|" & $desc & "|" & $parent)
                            else
                                _ArrayAdd($devArr, $id & "|" & $desc & "|" & $parent)
                            endif
                        endif
                        if $matched = 0 then
                            $type = $match[0]
                            $parent = UBound($match)>1 ? $match[1] : ""
                        endif
                        $id = ""
                        $desc = ""
                    case $match[0] = "id"
                        $id = $match[1]
                        if StringLeft($id, 1) = "." then
                            $id = ""
                        endif
                    case $match[0] = "desc"
                        $desc = $match[1]
                endselect
            endif
        until $eof <> 0
        FileClose($dudeConfFile)
        
        DescInhetit($progArr, 70)
        DescInhetit($devArr, 30)
        
        _ArraySort($progArr, 0, 0, 0, 1)
        _ArraySort($devArr, 0, 0, 0, 1)
        
        for $i = 0 to UBound($progArr)-1
            $programmers($progArr[$i][0]) = $progArr[$i][1]
        next
        for $i = 0 to UBound($devArr)-1
            $devices($devArr[$i][0]) = $devArr[$i][1]
        next
    else
        MsgBox(0, "Error!", '"avrdude.conf" not found in script directory')
        Exit
    endif
endfunc

; ------------------- inherit hw descriptions ---------------------

func DescInhetit(ByRef $Arr, $len = 20)
    local $arrById = ObjCreate("Scripting.Dictionary")
    local $i
    local $id
    local $d
    local $p
    local $pid
    local $pd
    local $count
    
    for $i = 0 to UBound($Arr)-1
        $arrById($Arr[$i][0]) = $i
        
        $Arr[$i][1] = StringLeft(StringStripWS($Arr[$i][1], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES) & " ", $len)
        $Arr[$i][1] = StringStripWS(StringRegExpReplace($Arr[$i][1], "\s\S+$", "..."), $STR_STRIPTRAILING)
    next

    do
        $count = 0
        for $i = 0 to UBound($Arr)-1
            $id = $Arr[$i][0]
            $d = $Arr[$i][1]
            $pid = $Arr[$i][2]
            if $d = "" and $pid <> "" then
                $p = $arrById($pid)
                $pd = $Arr[$p][1]
                if $pd <> "" then
                    $Arr[$i][1] = $pd
                    $count +=1
                endif
            endif
        next
    until $count = 0
endfunc

; ========================== FUSEs GUI ===========================

func FusesToGUI()
    for $byteName in $fuseBytes
        $byte = $fuseBytes($byteName)
        GUICtrlSetData($byte("ctrl"), "0x" & Hex($byte("value"), 2))
        for $bitN in $byte("bits")
            $bit = $byte("bits")($bitN)
            if BitAND($byte("value"), BitShift(1, -$bitN)) = 0 then
                GUICtrlSetState($bit("ctrl"), $GUI_CHECKED)
            else
                GUICtrlSetState($bit("ctrl"), $GUI_UNCHECKED)
            endif
        next
    next
    for $id in $fuseOptions
        $option = $fuseOptions($id)
        $fuse = $fuseBytes($option("fuse"))
        $value = BitAND($fuse("value"), $option("mask"))
        if $option("select") = 0 then
            if $value = 0 then
                GUICtrlSetState($option("ctrl"), $GUI_CHECKED)
            else
                GUICtrlSetState($option("ctrl"), $GUI_UNCHECKED)
            endif
        else
            if $option("list").Exists($value) then
                GUICtrlSetData($option("ctrl"), $option("list")($value), $option("list")($value))
            else
                $optionName = "RESERVED [" & $value & "]"
                GUICtrlSetData($option("ctrl"), $optionName, $optionName)
                $fuseOptionsValues($optionName) = $value
            endif
        endif
    next
endfunc

func BytesGUIToFuses()
    for $id in $fuseBytes
        $value = GUICtrlRead($fuseBytes($id)("ctrl"))
        if StringIsIntHex($value) then
            $fuseBytes($id)("value") = Int($value)
        endif
    next
endfunc

func BitsGUIToFuses()
    $fuseValues = ObjCreate("Scripting.Dictionary")
    for $byteName in $fuseBytes
        $fuseVal = 0

        for $bitN in $fuseBytes($byteName)("bits")
            $bit = $fuseBytes($byteName)("bits")($bitN)
            if GUICtrlRead($bit("ctrl")) = $GUI_UNCHECKED then
                $fuseVal = BitOR($fuseVal, BitShift(1, -$bitN))
            endif
        next

        $fuseBytes($byteName)("value") = $fuseVal
    next
endfunc

func OptionsGUIToFuses()
    $fuseValues = ObjCreate("Scripting.Dictionary")
    for $byteName in $fuseBytes
        $fuseValues($byteName) = 0
    next

    for $optionName in $fuseOptions
        $option = $fuseOptions($optionName)
        if $option.Exists("list") then
            $fuseValues($option("fuse")) = BitOR($fuseValues($option("fuse")), $fuseOptionsValues(GUICtrlRead($option("ctrl"))))
        else
            if GUICtrlRead($option("ctrl")) = $GUI_UNCHECKED then
                $fuseValues($option("fuse")) = BitOR($fuseValues($option("fuse")), $option("mask"))
            endif
        endif
    next

    for $byteName in $fuseBytes
        $fuseBytes($byteName)("value") = $fuseValues($byteName)
    next
endfunc

; ========================== FUSEs CONF ============================

func ReadFusesConf()
    
    $ini = StringFormat("%s\fuses\%s.ini", @ScriptDir, $device)
    $arg = ""
    
    
    for $byteName in $fuseBytes
        GUICtrlDelete($fuseBytes($byteName)("ctrl"))
        GUICtrlDelete($fuseBytes($byteName)("label"))
        $bits = $fuseBytes($byteName)("bits")
        for $bitN in $bits
            GUICtrlDelete($bits($bitN)("ctrl"))
        next
    next
    for $i in $fuseOptions
        GUICtrlDelete($fuseOptions($i)("ctrl"))
    next
    for $i in $fuseInfoCtrls
        GUICtrlDelete($fuseInfoCtrls($i))
    next
    
    $fuseBytes = ObjCreate("Scripting.Dictionary")
    $fuseOptions = ObjCreate("Scripting.Dictionary")
    $fuseOptionsValues = ObjCreate("Scripting.Dictionary")
    $fuseInfoCtrls = ObjCreate("Scripting.Dictionary")
    if (FileExists($ini)) then
        $fuseBytesList = StringSplit(IniRead($ini, "main", "fuses", ""), ":", $STR_NOCOUNT)
        
        for $i = 0 to UBound($fuseBytesList)-1
            $fuseByteName = $fuseBytesList[$i]
            $fuseByte = ObjCreate("Scripting.Dictionary")
            $fuseByte("value") = Int(IniRead($ini, "default", $fuseByteName, 255))
            
            $bits = ObjCreate("Scripting.Dictionary")
            $fuseBitsList = IniRead($ini, "main", $fuseByteName, "")
            if ($fuseBitsList <> "") then
                $fuseBitsList = StringSplit($fuseBitsList, ":", $STR_NOCOUNT)
                for $j = 0 to UBound($fuseBitsList)-1
                    if $fuseBitsList[$j] <> "" then
                        $fuseBit = ObjCreate("Scripting.Dictionary")
                        $fuseBit("name") = $fuseBitsList[$j]
                        $bits($j) = $fuseBit
                    endif
                next
            endif
            
            $fuseByte("bits") = $bits
            
            $fuseBytes($fuseByteName) = $fuseByte
        next

        $fuseOptionsList = IniRead($ini, "main", "options", "")
        if ($fuseOptionsList <> "") then
            $fuseOptionsList = StringSplit($fuseOptionsList, ":", $STR_NOCOUNT)
            for $i = 0 to UBound($fuseOptionsList)-1
                $fuseOptionName = $fuseOptionsList[$i]
                
                $fuseOption = ObjCreate("Scripting.Dictionary")
                $fuseOption("fuse") = IniRead($ini, $fuseOptionName, "fuse", "")
                $fuseOption("mask") = Int(IniRead($ini, $fuseOptionName, "mask", 0))
                $fuseOption("desc") = IniRead($ini, $fuseOptionName, "desc", $fuseOptionName)
                $select = Int(IniRead($ini, $fuseOptionName, "select", 0))
                $fuseOption("select") = $select
                if $select <> 0 then
                    $valuesSection = IniReadSection($ini, $fuseOptionName)
                    $valuesList = ObjCreate("Scripting.Dictionary")
                    for $j = 1 to $valuesSection[0][0]
                        if (StringLeft($valuesSection[$j][0], 1) = "v") then
                            $value = Int(StringTrimLeft($valuesSection[$j][0], 1))
                            $fuseOptionsValues($valuesSection[$j][1]) = $value
                            $valuesList($value) = $valuesSection[$j][1]
                        endif
                    next
                    $fuseOption("list") = $valuesList
                endif
                $fuseOptions($fuseOptionName) = $fuseOption
            next
        endif

    else
        MsgBox(0, "Warning", StringFormat('"%s" found', $ini))
    endif
endfunc

; ================= Show FUSEs GUI =============================

func FuseGUI()
    $fuseInfoCtrls("g1") = GUICtrlCreateLabel("WARNING!", $posLeft, $posTop + 3 + $posV * 5, 60, 20)
    GUICtrlSetColor(-1, 0x880000)
    GUICtrlSetFont(-1, 9, $FW_BOLD)
    $fuseInfoCtrls("c1") = GUICtrlCreateCheckbox("=0", $posLeft + 65, $posTop + $posV * 5, 40, 20)
    GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
    $fuseInfoCtrls("c2") = GUICtrlCreateCheckbox("=1", $posLeft + 105, $posTop + $posV * 5, 40, 20)
    GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)

    $byteN = 0
    for $fuseByteName in $fuseBytes
        $bits = $fuseBytes($fuseByteName)("bits")
        $fuseBytes($fuseByteName)("label") = GUICtrlCreateLabel($fuseByteName, $posLeft + $posFuseStepX * $byteN, $posFuseTop + 5, 40, 20)
        $fuseBytes($fuseByteName)("ctrl") = GUICtrlCreateInput("", $posLeft + $posFuseStepX * $byteN + 30, $posFuseTop, 40, 20)
        GUICtrlSetOnEvent(-1, "FuseByteMod")
        
        for $bitN in $bits
            $bits($bitN)("ctrl") = GUICtrlCreateCheckbox($bits($bitN)("name"), $posLeft + $posFuseStepX * $byteN, $posFuseTop + 30 + 18 * (8-$bitN), $posFuseStepX - 10, 20)
            GUICtrlSetOnEvent(-1, "FuseBitMod")
        next
        $fuseBytes($fuseByteName)("bits") = $bits

        $byteN += 1
    next
    
    $optN = 0
    for $optionName in $fuseOptions
        $fuseOption = $fuseOptions($optionName)
        
        if $fuseOption("select") = 0 then
            $fuseOption("ctrl") = GUICtrlCreateCheckbox($fuseOption("desc"), $posLeft, $posFuseTop + 200 + 21 * $optN, $posOptionX, 20)
            GUICtrlSetOnEvent(-1, "FuseOptionMod")
        else
            $fuseOption("ctrl") = GUICtrlCreateCombo("", $posLeft, $posFuseTop + 199 + 21 * $optN, $posOptionX, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
            GUICtrlSetOnEvent(-1, "FuseOptionMod")
            for $val in $fuseOption("list")
                GUICtrlSetData(-1, $fuseOption("list")($val))
            next
        endif
        
        $fuseOptions($optionName) = $fuseOption
        $optN +=1
    next
endfunc

; =================== Init Main GUI ===========================

func InitGUI()
    Opt("GUIOnEventMode", 1)
    
    Global $mainWindow = GUICreate("Main", 700, 900) 
    GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked") 
    
    Global $progCtrl = GUICtrlCreateCombo("", $posLeft, $posTop, $posProgX, $posY, $CBS_DROPDOWNLIST+$WS_VSCROLL)
    for $id in $programmers
        $item = StringFormat("%s [%s]", $programmers($id), $id)
        GUICtrlSetData(-1, $item, $id = $programmer ? $item : 0)
    next
    GUICtrlSetOnEvent(-1, "ProgrammerApply")

    Global $devCtrl = GUICtrlCreateCombo("", $posLeft + $posProgX + $posH, $posTop, $posDevX, $posY, $CBS_DROPDOWNLIST+$WS_VSCROLL)
    for $id in $devices
        $item = StringFormat("%s [%s]", $devices($id), $id)
        GUICtrlSetData(-1, $item, $id = $device ? $item : 0)
    next
    GUICtrlSetOnEvent(-1, "DeviceApply")
    
    ; Global $hardwareApplyButton = GUICtrlCreateButton("Apply", $posLeft + $posProgX + $posDevX + $posH * 2, $posTop, $posButtonX, $posY)
    ; GUICtrlSetOnEvent(-1, "HardwareApply")
    
    Global $hexCtrl = GUICtrlCreateInput($hex, $posLeft + $posButtonX, $posTop + $posV, $posPathX, $posY)
    GUICtrlCreateLabel("HEX:", $posLeft, $posTop + $posV + 3, $posButtonX, $posY)
    Global $eepCtrl = GUICtrlCreateInput($eep, $posLeft + $posButtonX, $posTop + $posV * 2, $posPathX, $posY)
    GUICtrlCreateLabel("EEP:", $posLeft, $posTop + $posV * 2 + 3, $posButtonX, $posY)

    GUICtrlCreateLabel("Fuses:", $posLeft, $posTop + $posV * 3 + 3, $posButtonX, $posY)
    Global $readFusesButton = GUICtrlCreateButton("Read", $posLeft + $posButtonX, $posTop + $posV * 3, $posButtonX, $posY)
    GUICtrlSetOnEvent(-1, "ReadFuses")

    ;Global $writeFusesButton = GUICtrlCreateButton("Write", 80, 110, 50)
    ;GUICtrlSetState(-1, $GUI_DISABLE)

    Global $stdoutCtrl = GUICtrlCreateEdit("", 20, 670, 660, 100);
    GUICtrlSetFont(-1, 10, 0, 0, "Consolas")
    GUICtrlSetBkColor(-1, 0x202020)
    GUICtrlSetColor(-1, 0x88FF88)

    Global $stderrCtrl = GUICtrlCreateEdit("", 20, 780, 660, 100);
    GUICtrlSetFont(-1, 10, 0, 0, "Consolas")
    GUICtrlSetBkColor(-1, 0x202020)
    GUICtrlSetColor(-1, 0xFF8888)
    
    GUISetState(@SW_SHOW, $mainWindow) 
endfunc

; ========== WORK WITH AVRDUDE =================================================

func DudeCmd()
    return StringFormat("%s\avrdude.exe -c %s -p %s ", @ScriptDir, $programmer, $device)
endfunc

func ReadFuses()
    GUICtrlSetData($stdoutCtrl, "");
    GUICtrlSetData($stderrCtrl, "")
    
    MsgBox(0,0,"Read fuses")
        ;$pid = Run(DudeCmd() & $arg, "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
        
        ;GUICtrlSetData($stderrCtrl, "")
        ;while ProcessExists($pid)
        ;    GUICtrlSetData($stderrCtrl, StderrRead($pid), 1)
        ;wend
        
        ;GUICtrlSetData($stdoutCtrl, _ArrayToString(StringSplit(StdoutRead($pid), @CRLF, $STR_ENTIRESPLIT), "~"), 1);
        ;GUICtrlSetData($stdoutCtrl, StdoutRead($pid), 1);
endfunc

; ========= CONFIGS ======================================

func LoadProjectConf()
    $programmer = IniRead($conf, "conf", "programmer", "")
    $device = IniRead($conf, "conf", "device", "")
    $hex = IniRead($conf, "conf", "hex", "")
    $eep = IniRead($conf, "conf", "eep", "")
endfunc

func SaveProjectConf()
    IniWrite($conf, "conf", "programmer", $programmer)
    IniWrite($conf, "conf", "device", $device)
    IniWrite($conf, "conf", "hex", $hex)
    IniWrite($conf, "conf", "eep", $eep)
endfunc

; ================= CURRENT SETTINGS ====================================

func ExtractHardwareId($s)
    local $match = StringRegExp($s, ".*\[(.+?)\]", $STR_REGEXPARRAYMATCH)
    return StringStripWS(@error = 0 ? $match[0] : $s, $STR_STRIPALL)
endfunc

func StringIsIntHex($s)
    return StringRegExp($s, "^(\d+|0x[\dA-Fa-f]+)$", $STR_REGEXPMATCH)
endfunc

func ProgrammerApply()
    $programmer = ExtractHardwareId(GUICtrlRead($progCtrl))
endfunc

func DeviceApply()
    $device = ExtractHardwareId(GUICtrlRead($devCtrl))
    ReadFusesConf()
    FuseGUI()
    FusesToGUI()
endfunc

; ==================== Events Handlers ======================

Func CLOSEClicked() 
    If @GUI_WinHandle = $mainwindow Then 
        ; HardwareApply()
        SaveProjectConf()
        Exit 
    EndIf 
EndFunc

func FuseByteMod()
    BytesGUIToFuses()
    FusesToGUI()
endfunc

func FuseBitMod()
    BitsGUIToFuses()
    FusesToGUI()
endfunc

func FuseOptionMod()
    OptionsGUIToFuses()
    FusesToGUI()
endfunc

