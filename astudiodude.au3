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

const $posButtonX = 50
const $posProgX = 400
const $posDevX = 200
const $posPathLeft = 30
const $posPathX = 555

const $posFuseStepX = 100
const $posFuseTop = 140

const $posBitsTop = 200
const $posBitsStepY = 18

const $posOptTop = 370
const $posOptV = 21
const $posOptionX = 650


global $conf = "\avrdude.ini"

global $programmer = ""
global $device = ""

global $hex = ""
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

$opt = Dict()
$opt("desc") = "Port"
$dudeOptions("P") = $opt

$opt = Dict()
$opt("desc") = "Bitclock"
$opt("list") = StringSplit(" |4kHz|32kHz|125kHz|250kHz|1MHz", "|")
$dudeOptions("B") = $opt


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
    Sleep(10)
    switch $lastClick
        case $readFusesButton
            ReadFuses()
        case $writeFusesButton
            WriteFuses()
    endswitch
    $lastClick = 0
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
    
    $fuseInfoCtrls("g1") = GUICtrlCreateLabel("WARNING!", $posLeft, $posFuseTop + $posStepY * 2 + 3, 60, $posY)
    GUICtrlSetColor(-1, 0x880000)
    GUICtrlSetFont(-1, 9, $FW_BOLD)
    $fuseInfoCtrls("c1") = GUICtrlCreateCheckbox("=0", $posLeft + 65, $posFuseTop + $posStepY * 2, 40, $posY)
    GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
    $fuseInfoCtrls("c2") = GUICtrlCreateCheckbox("=1", $posLeft + 105, $posFuseTop + $posStepY * 2, 40, $posY)
    GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)

    $byteN = 0
    for $fuseByteName in $fuseBytes
        $bits = $fuseBytes($fuseByteName)("bits")
        $fuseBytes($fuseByteName)("label") = GUICtrlCreateLabel($fuseByteName, $posLeft + $posFuseStepX * $byteN, $posFuseTop + $posStepY + 3, 40, $posY)
        $fuseBytes($fuseByteName)("ctrl") = GUICtrlCreateInput("", $posLeft + $posFuseStepX * $byteN + 30, $posFuseTop + $posStepY, 40, $posY)
        GUICtrlSetOnEvent(-1, "FuseByteMod")
        
        for $bitN in $bits
            $bits($bitN)("ctrl") = GUICtrlCreateCheckbox($bits($bitN)("name"), $posLeft + $posFuseStepX * $byteN, $posBitsTop + $posBitsStepY * (8-$bitN), $posFuseStepX - 10, $posY)
            GUICtrlSetOnEvent(-1, "FuseBitMod")
        next
        ;$fuseBytes($fuseByteName)("bits") = $bits

        $byteN += 1
    next
    
    $optN = 0
    for $optionName in $fuseOptions
        $fuseOption = $fuseOptions($optionName)
        
        if $fuseOption("select") = 0 then
            $fuseOption("ctrl") = GUICtrlCreateCheckbox($fuseOption("desc"), $posLeft, $posOptTop + 1 + $posOptV * $optN, $posOptionX, $posY)
            GUICtrlSetOnEvent(-1, "FuseOptionMod")
        else
            $fuseOption("ctrl") = GUICtrlCreateCombo("", $posLeft, $posOptTop + $posOptV * $optN, $posOptionX, $posY, $CBS_DROPDOWNLIST+$WS_VSCROLL)
            GUICtrlSetOnEvent(-1, "FuseOptionMod")
            for $val in $fuseOption("list")
                GUICtrlSetData(-1, $fuseOption("list")($val))
            next
        endif
        
        ;$fuseOptions($optionName) = $fuseOption
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

    Global $devCtrl = GUICtrlCreateCombo("", $posLeft + $posProgX + $posSpaceX, $posTop, $posDevX, $posY, $CBS_DROPDOWNLIST+$WS_VSCROLL)
    for $id in $devices
        $item = StringFormat("%s [%s]", $devices($id), $id)
        GUICtrlSetData(-1, $item, $id = $device ? $item : 0)
    next
    GUICtrlSetOnEvent(-1, "DeviceApply")
    
    $optN = 0
    for $optName in $dudeOptions
        $opt = $dudeOptions($optName)
        select
            case $opt.Exists("list")
                GUICtrlCreateLabel($opt("desc"), $posLeft + 110 * $optN, 38, 37, $posY, $SS_RIGHT)
                $opt("ctrl") = GUICtrlCreateCombo("", $posLeft + 110 * $optN + 40, 35, 60, $posY)
                for $i = 1 to $opt("list")[0]
                    GUICtrlSetData($opt("ctrl"), $opt("list")[$i], $i = 1 ? $opt("list")[$i] : "")
                next
            case else
                GUICtrlCreateLabel($opt("desc"), $posLeft + 110 * $optN, 38, 37, $posY, $SS_RIGHT)
                $opt("ctrl") = GUICtrlCreateInput("", $posLeft + 110 * $optN + 40, 35, 60, $posY)
        endselect
        $optN += 1
    next
    
    ; Global $hardwareApplyButton = GUICtrlCreateButton("Apply", $posLeft + $posProgX + $posDevX + $posSpaceX * 2, $posTop, $posButtonX, $posY)
    ; GUICtrlSetOnEvent(-1, "HardwareApply")
    
    
    
    Global $hexCtrl = GUICtrlCreateInput($hex, $posLeft + $posButtonX, $posTop + $posStepY * 2, $posPathX, $posY)
    GUICtrlCreateLabel("HEX:", $posLeft, $posTop + $posStepY * 2 + 3, $posButtonX, $posY)
    Global $eepCtrl = GUICtrlCreateInput($eep, $posLeft + $posButtonX, $posTop + $posStepY * 3, $posPathX, $posY)
    GUICtrlCreateLabel("EEP:", $posLeft, $posTop + $posStepY * 3 + 3, $posButtonX, $posY)

    GUICtrlCreateLabel("Fuses:", $posLeft, $posFuseTop + 3, $posButtonX, $posY)
    
    Global $readFusesButton = GUICtrlCreateButton("Read", $posLeft + $posButtonX, $posFuseTop, $posButtonX, $posY)
    GUICtrlSetOnEvent(-1, "RWClick")

    Global $writeFusesButton = GUICtrlCreateButton("Write", $posLeft + $posSpaceX + $posButtonX * 2, $posFuseTop, $posButtonX, $posY)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetOnEvent(-1, "RWClick")
    
    Global $abortDudeButton = GUICtrlCreateButton("Abort", $posLeft + $posSpaceX * 2 + $posButtonX * 3, $posFuseTop, $posButtonX, $posY)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetOnEvent(-1, "AbortProcess")

    Global $logCtrl = GUICtrlCreateEdit("", $posLeft, 630, 660, 200);
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

func RWClick()
    $lastClick = @GUI_CtrlId
endfunc

func DisableControls()
    $storeControls($progCtrl) = GUICtrlGetState($progCtrl)
    $storeControls($devCtrl) = GUICtrlGetState($devCtrl)
    $storeControls($readFusesButton) = GUICtrlGetState($readFusesButton)
    $storeControls($writeFusesButton) = GUICtrlGetState($writeFusesButton)
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
    ProcessClose ($avrdudePID)
endfunc

func DudeCmd()
    $cmd = StringFormat('"%s\avrdude.exe" -c %s -p %s', @ScriptDir, $programmer, $device)
    for $optName in $dudeOptions
        $opt = $dudeOptions($optName)
        $value = StringStripWS(GUICtrlRead($opt("ctrl")), $STR_STRIPALL)
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
    while ProcessExists($avrdudePID)
        do
            $logAdd = StderrRead($avrdudePID)
            if $logAdd <> "" then
                $log &= $logAdd
                GUICtrlSetData($logCtrl, $logAdd, 1)
                if StringInStr($log, "Expected signature for") > 0 then
                    MsgBox($MB_ICONERROR, "Error", "Incorrect microcontroller")
                    return ""
                endif
            endif
            $data &= StdoutRead($avrdudePID)
        until Not @extended Or @error
    wend
    
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

; ================ Tools ======================

func Dict()
    return ObjCreate("Scripting.Dictionary")
endfunc

