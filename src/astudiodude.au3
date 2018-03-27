#NoTrayIcon
#pragma compile(Icon, "fire-multi-size.ico")
#pragma compile(Out, "..\astudiodude.exe")

#include <Array.au3>
#include <GUIConstantsEx.au3> 
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <StringConstants.au3>
#include <ComboConstants.au3>
#include <FontConstants.au3>
#include <StaticConstants.au3>

const $posLeft = 10
const $posTop = 10
const $posY = 20
const $posSpaceX = 5
const $posStepY = 25
const $posButtonX = 55

const $posProgX = 450
const $posDevX = 200

const $posMainX = $posProgX + $posDevX + $posLeft * 2 + $posSpaceX

const $posPathLeft = $posLeft + $posButtonX
const $posPathX = $posMainX - $posPathLeft - $posButtonX - $posSpaceX - $posLeft

const $posFuseStepX = 100
const $posFuseTop = $posTop + $posStepY * 4

const $posBitsLeft = $posLeft * 2
const $posBitsTop = $posFuseTop + $posStepY * 4
const $posBitsStepY = 18

const $posOptLeft = $posLeft * 2
const $posOptTop = $posFuseTop + $posStepY * 3
const $posOptStepY = 21
const $posOptX = $posMainX - $posLeft * 4

const $posTabTop = $posFuseTop + $posStepY * 2
const $posTabY = 350

const $posLogTop = $posTabTop + $posTabY + 10
const $posLogX = 660
const $posLogY = 200

const $posMainY = $posLogTop + $posLogY + $posTop


global $conf = "\avrdude.ini"

global $programmer = "usbasp"
global $device = "m328p"

global $flash = ""
global $eep = ""

global $programmers = Dict()
global $devices = Dict()

global $dudeOptions = Dict()

global $fuseBytes = Dict()
global $fuseOptions = Dict()
global $fuseOptionsValues = Dict()
global $fuseInfoCtrls = Dict()

global $storeControls = Dict()

global $avrdudePID
global $lastClick = 0

global $autoFlash = 0
global $autoEEPROM = 0
global $autoClose = 0

$opt = Dict()
$opt("desc") = "Port"
$dudeOptions("P") = $opt

$opt = Dict()
$opt("desc") = "Bitclock"
$opt("list") = StringSplit("4kHz|32kHz|125kHz|250kHz|1MHz", "|")
$dudeOptions("B") = $opt

if @Compiled then
    $dudeDir = @ScriptDir
else
    $dudeDir = @ScriptDir & "\.."
endif

for $i = 1 to $CmdLine[0]
    switch (StringLeft($CmdLine[$i], 2))
        case "-p"
            $project = StringTrimLeft($CmdLine[$i], 2)
        case "-t"
            $target = StringTrimLeft($CmdLine[$i], 2)
        case "-d"
            $dudeDir = StringTrimLeft($CmdLine[$i], 2)
        case "-a"
            $auto = StringTrimLeft($CmdLine[$i], 2)
            if StringInStr($auto, "f") > 0 then
                $autoFlash = 1
            endif
            if StringInStr($auto, "e") > 0 then
                $autoEEPROM = 1
            endif
            if StringInStr($auto, "c") > 0 then
                $autoClose = 1
            endif
    endswitch
next

if IsDeclared("project") then
    $conf = $project & $conf
else
    $conf = @UserProfileDir & $conf
endif

LoadProjectConf()

if IsDeclared("target") then
    $flash = $target & ".hex"
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
    Sleep(10)
    switch $lastClick
        case $readFusesButton
            ReadFuses()
        case $writeFusesButton
            WriteFuses()
        case $flashButton
            BurnFlash()
        case $eepButton
            BurnEEPROM()
    endswitch
    if $autoFlash = 1 then
        BurnFlash()
    endif
    if $autoEEPROM = 1 then
        BurnEEPROM()
    endif
    if $autoClose = 1 then
        $autoClose = 0
        ;MsgBox(0,0,"Autoclose")
        Exit
    endif
    $lastClick = 0
WEnd 

;=======================================================================
;=======================================================================

;==================== READ DUDE CONF ===================================================

func ReadDudeConf()
    Local $progArr[0][3]
    Local $devArr[0][3]
    
    $dudeConf = $dudeDir & "\avrdude.conf"
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
    local $arrById = Dict()
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
    $fuseValues = Dict()
    for $byteName in $fuseBytes
        $fuseVal = 0
        $bits = $fuseBytes($byteName)("bits")
        for $bitN = 0 to 7
            if not $bits.Exists($bitN) or GUICtrlRead($bits($bitN)("ctrl")) = $GUI_UNCHECKED then
                $fuseVal = BitOR($fuseVal, BitShift(1, -$bitN))
            endif
        next

        $fuseBytes($byteName)("value") = $fuseVal
    next
endfunc

func OptionsGUIToFuses()
    $fuseValues = Dict()
    for $byteName in $fuseBytes
        $fuseValues($byteName) = 0xFF
    next

    for $optionName in $fuseOptions
        $option = $fuseOptions($optionName)
        if $option.Exists("list") then
            $fuseValues($option("fuse")) = BitAND($fuseValues($option("fuse")), BitOR(BitNOT($option("mask")), $fuseOptionsValues(GUICtrlRead($option("ctrl")))))
        else
            if GUICtrlRead($option("ctrl")) = $GUI_CHECKED then
                $fuseValues($option("fuse")) = BitAND($fuseValues($option("fuse")), BitNOT($option("mask")))
            endif
        endif
    next

    for $byteName in $fuseBytes
        $fuseBytes($byteName)("value") = $fuseValues($byteName)
    next
endfunc

; ========================== FUSEs CONF ============================

func ReadFusesConf()
    
    $ini = StringFormat("%s\fuses\%s.ini", $dudeDir, $device)
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
    
    $fuseBytes = Dict()
    $fuseOptions = Dict()
    $fuseOptionsValues = Dict()
    $fuseInfoCtrls = Dict()
    if (FileExists($ini)) then
        $fuseBytesList = StringSplit(IniRead($ini, "main", "fuses", ""), ":", $STR_NOCOUNT)
        
        for $i = 0 to UBound($fuseBytesList)-1
            $fuseByteName = $fuseBytesList[$i]
            $fuseByte = Dict()
            $fuseByte("value") = Int(IniRead($ini, "default", $fuseByteName, 255))
            
            $bits = Dict()
            $fuseBitsList = IniRead($ini, "main", $fuseByteName, "")
            if ($fuseBitsList <> "") then
                $fuseBitsList = StringSplit($fuseBitsList, ":", $STR_NOCOUNT)
                for $j = 0 to UBound($fuseBitsList)-1
                    if $fuseBitsList[$j] <> "" then
                        $fuseBit = Dict()
                        $fuseBit("name") = $fuseBitsList[$j]
                        if StringRegExp($fuseBit("name"), "RSTDISBL|SPIEN|CKSEL", $STR_REGEXPMATCH) then
                            $fuseBit("danger") = 1
                        endif
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
                
                $fuseOption = Dict()
                $fuseOption("fuse") = IniRead($ini, $fuseOptionName, "fuse", "")
                $fuseOption("mask") = Int(IniRead($ini, $fuseOptionName, "mask", 0))
                for $j in $fuseBytes($fuseOption("fuse"))("bits")
                    if BitAND(BitShift(1, -$j), $fuseOption("mask")) then
                        $bit = $fuseBytes($fuseOption("fuse"))("bits")($j)
                        if $bit.Exists("danger") then
                            $fuseOption("danger") = 1
                        endif
                    endif
                next
                $fuseOption("desc") = IniRead($ini, $fuseOptionName, "desc", $fuseOptionName)
                $select = Int(IniRead($ini, $fuseOptionName, "select", 0))
                $fuseOption("select") = $select
                if $select <> 0 then
                    $valuesSection = IniReadSection($ini, $fuseOptionName)
                    $valuesList = Dict()
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
    GUICtrlSetState($writeFusesButton, $GUI_DISABLE)
    
    GUISwitch($mainWindow, $bitsTab)
    $fuseInfoCtrls("g1") = GUICtrlCreateLabel("WARNING!", $posBitsLeft, $posFuseTop + $posStepY * 3 + 3, 60, $posY)
    GUICtrlSetColor(-1, 0x880000)
    GUICtrlSetFont(-1, 9, $FW_BOLD)
    $fuseInfoCtrls("c1") = GUICtrlCreateCheckbox("=0 (Enable)", $posBitsLeft + 65, $posFuseTop + $posStepY * 3, 80, $posY)
    GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
    $fuseInfoCtrls("c2") = GUICtrlCreateCheckbox("=1 (Disable)", $posBitsLeft + 145, $posFuseTop + $posStepY * 3, 80, $posY)
    GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
    GUICtrlCreateTabItem("")

    $byteN = 0
    for $fuseByteName in $fuseBytes
        $bits = $fuseBytes($fuseByteName)("bits")
        $fuseBytes($fuseByteName)("label") = GUICtrlCreateLabel($fuseByteName, $posLeft + $posFuseStepX * $byteN, $posFuseTop + $posStepY + 3, 40, $posY)
        $fuseBytes($fuseByteName)("ctrl") = GUICtrlCreateInput("", $posLeft + $posFuseStepX * $byteN + 30, $posFuseTop + $posStepY, 40, $posY)
        GUICtrlSetOnEvent(-1, "FuseByteMod")
        
        GUISwitch($mainWindow, $bitsTab)
        for $bitN in $bits
            $bitName = $bits($bitN)("name")
            $bits($bitN)("ctrl") = GUICtrlCreateCheckbox($bitName, $posBitsLeft + $posFuseStepX * $byteN, $posBitsTop + $posBitsStepY * (7-$bitN), $posFuseStepX - 10, $posY)
            if $bits($bitN)("danger") then
                GUICtrlSetColor(-1, 0x880000)
                ; GUICtrlSetFont(-1, 9, $FW_BOLD)
            endif
            GUICtrlSetOnEvent(-1, "FuseBitMod")
        next
        GUICtrlCreateTabItem("")
        ;$fuseBytes($fuseByteName)("bits") = $bits

        $byteN += 1
    next
    
    $optN = 0
    for $optionName in $fuseOptions
        $fuseOption = $fuseOptions($optionName)
        
        GUISwitch($mainWindow, $optionsTab)
        if $fuseOption("select") = 0 then
            $fuseOption("ctrl") = GUICtrlCreateCheckbox($fuseOption("desc"), $posOptLeft, $posOptTop + 1 + $posOptStepY * $optN, $posOptX, $posY)
            GUICtrlSetOnEvent(-1, "FuseOptionMod")
        else
            $fuseOption("ctrl") = GUICtrlCreateCombo("", $posOptLeft, $posOptTop + $posOptStepY * $optN, $posOptX, $posY, $CBS_DROPDOWNLIST+$WS_VSCROLL)
            GUICtrlSetOnEvent(-1, "FuseOptionMod")
            for $val in $fuseOption("list")
                GUICtrlSetData(-1, $fuseOption("list")($val))
            next
        endif
        if $fuseOption("danger") then
            GUICtrlSetColor(-1, 0x880000)
            ; GUICtrlSetFont(-1, 9, $FW_BOLD)
        endif
        GUICtrlCreateTabItem("")
        
        ;$fuseOptions($optionName) = $fuseOption
        $optN +=1
    next
endfunc

; =================== Init Main GUI ===========================

func InitGUI()
    Opt("GUIOnEventMode", 1)
    DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
    
    Global $mainWindow = GUICreate("AStudioDude", $posMainX, $posMainY) 
    GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked") 
    
    Global $progCtrl = GUICtrlCreateCombo("", $posLeft, $posTop, $posProgX, $posY, $CBS_DROPDOWNLIST+$WS_VSCROLL)
    for $id in $programmers
        $item = StringFormat("%s [%s]", $programmers($id), $id)
        GUICtrlSetData(-1, $item, $id = $programmer ? $item : 0)
    next
    ; GUICtrlSetOnEvent(-1, "ProgrammerApply")

    Global $devCtrl = GUICtrlCreateCombo("", $posLeft + $posProgX + $posSpaceX, $posTop, $posDevX, $posY, $CBS_DROPDOWNLIST+$WS_VSCROLL)
    for $id in $devices
        $item = StringFormat("%s [%s]", $devices($id), $id)
        GUICtrlSetData(-1, $item, $id = $device ? $item : 0)
    next
    GUICtrlSetOnEvent(-1, "DeviceApply")
    
    $optN = 0
    for $optName in $dudeOptions
        $opt = $dudeOptions($optName)
        $value = $opt("value")
        select
            case $opt.Exists("list")
                GUICtrlCreateLabel($opt("desc"), $posLeft + 110 * $optN, 38, 37, $posY, $SS_RIGHT)
                $opt("ctrl") = GUICtrlCreateCombo(" ", $posLeft + 110 * $optN + 40, 35, 60, $posY)
                for $i = 1 to $opt("list")[0]
                    GUICtrlSetData(-1, $opt("list")[$i])
                next
                if $value = "" then
                    $value = " "
                endif
                GUICtrlSetData(-1, $value, $value)
            case else
                GUICtrlCreateLabel($opt("desc"), $posLeft + 110 * $optN, 38, 37, $posY, $SS_RIGHT)
                $opt("ctrl") = GUICtrlCreateInput($opt("value"), $posLeft + 110 * $optN + 40, 35, 60, $posY)
        endselect
        $optN += 1
    next
    
    ; Global $hardwareApplyButton = GUICtrlCreateButton("Apply", $posLeft + $posProgX + $posDevX + $posSpaceX * 2, $posTop, $posButtonX, $posY)
    ; GUICtrlSetOnEvent(-1, "HardwareApply")
    
    
    
    GUICtrlCreateLabel("Flash:", $posLeft, $posTop + $posStepY * 2 + 3, $posButtonX, $posY)
    Global $flashCtrl = GUICtrlCreateInput($flash, $posLeft + $posButtonX, $posTop + $posStepY * 2, $posPathX, $posY)
    global $flashButton = GUICtrlCreateButton("Flash!", $posMainX - $posLeft - $posButtonX, $posTop + $posStepY * 2, $posButtonX, $posY)
    GUICtrlSetOnEvent(-1, "BurnClick")
    GUICtrlCreateLabel("EEPROM:", $posLeft, $posTop + $posStepY * 3 + 3, $posButtonX, $posY)
    Global $eepCtrl = GUICtrlCreateInput($eep, $posLeft + $posButtonX, $posTop + $posStepY * 3, $posPathX, $posY)
    global $eepButton = GUICtrlCreateButton("EEPROM!", $posMainX - $posLeft - $posButtonX, $posTop + $posStepY * 3, $posButtonX, $posY)
    GUICtrlSetOnEvent(-1, "BurnClick")

    GUICtrlCreateLabel("Fuses:", $posLeft, $posFuseTop + 3, $posButtonX, $posY)
    
    Global $readFusesButton = GUICtrlCreateButton("Read", $posLeft + $posButtonX, $posFuseTop, $posButtonX, $posY)
    GUICtrlSetOnEvent(-1, "BurnClick")

    Global $writeFusesButton = GUICtrlCreateButton("Write", $posLeft + $posSpaceX + $posButtonX * 2, $posFuseTop, $posButtonX, $posY)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetOnEvent(-1, "BurnClick")
    
    Global $abortDudeButton = GUICtrlCreateButton("Abort", $posLeft + $posSpaceX * 2 + $posButtonX * 3, $posFuseTop, $posButtonX, $posY)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetOnEvent(-1, "AbortProcess")
    
    GUICtrlCreateTab($posLeft, $posTabTop, $posOptX + $posLeft * 2, $posTabY)
    global $optionsTab = GUICtrlCreateTabItem("Options")
    GUICtrlSetState(-1, $GUI_SHOW)
    global $bitsTab = GUICtrlCreateTabItem("Bits")
    GUICtrlCreateTabItem("")
    
    Global $logCtrl = GUICtrlCreateEdit("", $posLeft, $posLogTop, $posLogX, $posLogY);
    GUICtrlSetFont(-1, 8, 0, 0, "Consolas")
    GUICtrlSetBkColor(-1, 0x202020)
    GUICtrlSetColor(-1, 0xAAFF99)
    
    ; Global $infoCtrl = GUICtrlCreateEdit("", $posLeft, 835, 660, 50);
    ; GUICtrlSetFont(-1, 8, 0, 0, "Consolas")
    ; GUICtrlSetBkColor(-1, 0x202020)
    ; GUICtrlSetColor(-1, 0x88FF88)

    GUISetState(@SW_SHOW, $mainWindow) 
endfunc

; ========== WORK WITH AVRDUDE =================================================

func BurnClick()
    $lastClick = @GUI_CtrlId
endfunc

func DisableControls()
    $storeControls($progCtrl) = GUICtrlGetState($progCtrl)
    $storeControls($devCtrl) = GUICtrlGetState($devCtrl)
    $storeControls($readFusesButton) = GUICtrlGetState($readFusesButton)
    $storeControls($writeFusesButton) = GUICtrlGetState($writeFusesButton)
    $storeControls($flashButton) = GUICtrlGetState($flashButton)
    $storeControls($eepButton) = GUICtrlGetState($eepButton)
    for $byteName in $fuseBytes
        $byte = $fuseBytes($byteName)
        $storeControls($byte("ctrl")) = GUICtrlGetState($byte("ctrl"))
        for $bitN in $byte("bits")
            $bit = $byte("bits")($bitN)
            $storeControls($bit("ctrl")) = GUICtrlGetState($bit("ctrl"))
        next
    next
    for $optionName in $fuseOptions
        $option = $fuseOptions($optionName)
        $storeControls($option("ctrl")) = GUICtrlGetState($option("ctrl"))
    next
    
    for $ctrl in $storeControls
        GUICtrlSetState($ctrl, $GUI_DISABLE)
    next
    
    GUICtrlSetState($abortDudeButton, $GUI_ENABLE)
    
endfunc

func RestoreControls()
    for $ctrl in $storeControls
        GUICtrlSetState($ctrl, $storeControls($ctrl))
    next
    $storeControls = Dict()
    
    GUICtrlSetState($abortDudeButton, $GUI_DISABLE)
endfunc

func AbortProcess()
    $autoFlash = 0
    $autoEEPROM = 0
    $autoClose = 0
    ProcessClose ($avrdudePID)
endfunc

func DudeCmd()
    ProgrammerApply()
    $cmd = StringFormat('"%s\avrdude.exe" -c %s -p %s', $dudeDir, $programmer, $device)
    for $optName in $dudeOptions
        $opt = $dudeOptions($optName)
        $value = $opt("value")
        if $value <> "" then
            $cmd &= StringFormat(" -%s %s", $optName, $value)
        endif
    next
    return $cmd
endfunc

func RunDude($arg)
    GUICtrlSetData($logCtrl, "")
    
    $cmd = DudeCmd() & $arg
    DisableControls()
    $avrdudePID = Run($cmd, "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD + $STDIN_CHILD)
    
    $log = ""
    $data = ""
    $stop = 0
    while ProcessExists($avrdudePID)
        do
            $logAdd = StderrRead($avrdudePID)
            if $logAdd <> "" then
                $log &= $logAdd
                GUICtrlSetData($logCtrl, $logAdd, 1)
                if StringInStr($log, "Expected signature for") > 0 then
                    $stop = 1
                    $match = StringRegExp($log, "Device signature = 0x\w+ \(probably (\w+)\)", $STR_REGEXPARRAYMATCH)
                    if @error = 0 and $devices.Exists($match[0]) then
                        if MsgBox($MB_ICONWARNING + $MB_YESNO, "Error", StringFormat('Incorrect microcontroller "%s".\nChange to "%s"?', $device, $match[0])) = $IDYES then
                            $item = StringFormat("%s [%s]", $devices($match[0]), $match[0])
                            GUICtrlSetData($devCtrl, $item, $item)
                            DeviceApply()
                        endif
                    else
                        MsgBox($MB_ICONERROR, "Error", StringFormat('Incorrect microcontroller "%s"', $device))
                    endif
                    ExitLoop
                    $data = ""
                endif
                if StringInStr($log, "target doesn't answer") > 0 then
                    $stop = 1
                    MsgBox($MB_ICONERROR, "Error", "Target device doesn't ansewer")
                endif
                ;can't open device "\\.\com1"
                if StringInStr($log, "can't open device") > 0 then
                    $stop = 1
                    $match = StringRegExp($log, "can't open device ""([^""]+)""", $STR_REGEXPARRAYMATCH)
                    if @error = 0 then
                        MsgBox($MB_ICONERROR, "Error", StringFormat('Can''t open port "%s"', $match[0]))
                    else
                        MsgBox($MB_ICONERROR, "Error", "Can't open port")
                    endif
                    
                endif
                ;could not find USB device
                if StringInStr($log, "could not find USB device") > 0 then
                    $stop = 1
                    MsgBox($MB_ICONERROR, "Error", "Could not find USB programmer")
                endif
            endif
            $data &= StdoutRead($avrdudePID)
        until Not @extended Or @error
    wend
    if $stop = 1 then
        $autoFlash = 0
        $autoEEPROM = 0
        $autoClose = 0
    endif
    
    RestoreControls()
    
    
    return $data
endfunc

func ReadFuses()
    ; GUICtrlSetData($infoCtrl, "")

    $arg = ""
    $n = 0
    for $fuseByteName in $fuseBytes
        $n += 1
        $arg &= StringFormat(" -U %s:r:-:h", $fuseByteName)
    next
    
    $outArr = RunDude($arg)
    $outArr = StringSplit($outArr, @CRLF, $STR_ENTIRESPLIT)
    if $outArr[0] - 1 = $n then
        $n = 0
        for $fuseByteName in $fuseBytes
            $n += 1
            $fuseBytes($fuseByteName)("value") = Int($outArr[$n])
        next
        GUICtrlSetState($writeFusesButton, $GUI_ENABLE)
    endif
    
    FusesToGUI()
endfunc

func WriteFuses()
    ; GUICtrlSetData($infoCtrl, "")

    $arg = ""

    for $fuseByteName in $fuseBytes
        $arg &= StringFormat(" -U %s:w:%s:m", $fuseByteName, "0x" & Hex($fuseBytes($fuseByteName)("value"), 2))
    next
    
    RunDude($arg)
    
endfunc

func BurnFlash()
    $autoFlash = 0
    if FileExists($flash) then
        $arg = StringFormat(' -U flash:w:"%s":i', $flash)
        RunDude($arg)
    else
        MsgBox($MB_ICONERROR, "File not found", StringFormat('File "%s" not found', $flash))
    endif
endfunc

func BurnEEPROM()
    $autoEEPROM = 0
    if FileExists($eep) then
        $arg = StringFormat(' -U eeprom:w:"%s":i', $eep)
        RunDude($arg)
    else
        MsgBox($MB_ICONERROR, "File not found", StringFormat('File "%s" not found', $eep))
    endif
endfunc


; ========= CONFIGS ======================================

func LoadProjectConf()
    $programmer = IniRead($conf, "conf", "programmer", $programmer)
    $device = IniRead($conf, "conf", "device", $device)
    $flash = IniRead($conf, "conf", "hex", "")
    $eep = IniRead($conf, "conf", "eep", "")
    for $optName in $dudeOptions
        $opt = $dudeOptions($optName)
        $opt("value") = StringStripWS(IniRead($conf, "conf", $optName, ""), $STR_STRIPALL)
    next
endfunc

func SaveProjectConf()
    IniWrite($conf, "conf", "programmer", $programmer)
    IniWrite($conf, "conf", "device", $device)
    IniWrite($conf, "conf", "hex", $flash)
    IniWrite($conf, "conf", "eep", $eep)
    for $optName in $dudeOptions
        $opt = $dudeOptions($optName)
        IniWrite($conf, "conf", $optName, $opt("value"))
    next
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
    $flash = GUICtrlRead($flashCtrl)
    $eep = GUICtrlRead($eepCtrl)
    for $optName in $dudeOptions
        $opt = $dudeOptions($optName)
        $opt("value") = StringStripWS(GUICtrlRead($opt("ctrl")), $STR_STRIPALL)
    next
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
        ProgrammerApply()
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

; ================ Tools ======================

func Dict()
    return ObjCreate("Scripting.Dictionary")
endfunc

