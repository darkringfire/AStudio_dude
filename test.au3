#include <Array.au3>
#include <GUIConstantsEx.au3> 
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <StringConstants.au3>
#include <ComboConstants.au3>

const $conf = "avrdude.ini"

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent 

$programmer = ""
$device = ""
$project = ""
$target = ""
$auto = ""
$hex = ""
$eep = ""

$programmers = ObjCreate("Scripting.Dictionary")
$devices = ObjCreate("Scripting.Dictionary")

$fuseBytes = ObjCreate("Scripting.Dictionary")
$fuseBits = ObjCreate("Scripting.Dictionary")
$fuseOptions = ObjCreate("Scripting.Dictionary")

$i = 1

while ($i <= $CmdLine[0])
    switch (StringLeft($CmdLine[$i], 2))
        case "-p"
            $project = StringTrimLeft($CmdLine[$i], 2)
        case "-t"
            $target = StringTrimLeft($CmdLine[$i], 2)
        case "-a"
            $auto = StringTrimLeft($CmdLine[$i], 2)
    endswitch
    $i += 1
wend

if (FileExists($target & ".hex")) then
    $hex = $target & ".hex"
endif
if (FileExists($target & ".eep")) then
    $eep = $target & ".eep"
endif


ReadDudeConf()

ReadVars()

InitGUI()


While (1)
  Sleep(1000)
WEnd 

;---------------------------------------

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
        ;_ArrayDisplay($progArr)
        ;_ArrayDisplay($devArr)
        
        for $i = 0 to UBound($progArr)-1
            $programmers($progArr[$i][0]) = $progArr[$i][1]
        next
        for $i = 0 to UBound($devArr)-1
            $devices($devArr[$i][0]) = $devArr[$i][1]
        next
    endif
endfunc

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

func DudeCmd()
    return StringFormat("%s\avrdude.exe -c %s -p %s ", @ScriptDir, $programmer, $device)
endfunc

func ReadFusesConf()
    const $posFuseLeft = 20
    const $posFuseStepX = 100
    const $posFuseTop = 140
    
    GUICtrlSetData($stdoutCtrl, "");
    GUICtrlSetData($stderrCtrl, "")
    
    $ini = StringFormat("%s\fuses\%s.ini", @ScriptDir, $device)
    $arg = ""
    
    
    for $i in $fuseBytes
        GUICtrlDelete($fuseBytes($i)("ctrl"))
        GUICtrlDelete($fuseBytes($i)("label"))
    next
    for $i in $fuseBits
        GUICtrlDelete($fuseBits($i)("ctrl"))
    next
    for $i in $fuseOptions
        GUICtrlDelete($fuseOptions($i)("ctrl"))
    next
    
    $fuseBytes = ObjCreate("Scripting.Dictionary")
    $fuseBits = ObjCreate("Scripting.Dictionary")
    $fuseOptions = ObjCreate("Scripting.Dictionary")
    if (FileExists($ini)) then
        $fuseBytesList = StringSplit(IniRead($ini, "main", "fuses", ""), ":", $STR_NOCOUNT)
        for $i = 0 to UBound($fuseBytesList)-1
            $fuseByteName = $fuseBytesList[$i]
            $arg &= StringFormat(" -U %s:r:-:h", $fuseByteName)
            
            $fuseBytes($fuseByteName) = ObjCreate("Scripting.Dictionary")
            $fuseBytes($fuseByteName)("label") = GUICtrlCreateLabel($fuseByteName, $posFuseLeft + $posFuseStepX * $i, $posFuseTop + 5, 40, 20)
            $fuseBytes($fuseByteName)("ctrl") = GUICtrlCreateInput("", $posFuseLeft + $posFuseStepX * $i + 30, $posFuseTop, 30, 20)
            
            $fuseBitsList = IniRead($ini, $fuseByteName, "bits", "")
            if ($fuseBitsList <> "") then
                $fuseBitsList = StringSplit($fuseBitsList, ":", $STR_NOCOUNT)
                for $j = 0 to UBound($fuseBitsList)-1
                    $fuseBit = ObjCreate("Scripting.Dictionary")
                    $fuseBit("fuse") = $fuseByteName
                    $fuseBit("n") = $j
                    $fuseBit("ctrl") = GUICtrlCreateCheckbox($fuseBitsList[$j], $posFuseLeft + $posFuseStepX * $i, $posFuseTop + 10 + 18 * (8-$j), $posFuseStepX - 10, 20)
                    $fuseBits($fuseBitsList[$j]) = $fuseBit
                next
                $fuseBytes($fuseByteName)("bits") = $fuseBitsList
            endif
        next
        
        $fuseOptionsList = IniRead($ini, "main", "options", "")
        if ($fuseOptionsList <> "") then
            $fuseOptionsList = StringSplit($fuseOptionsList, ":", $STR_NOCOUNT)
            for $i = 0 to UBound($fuseOptionsList)-1
                $fuseOptionName = $fuseOptionsList[$i]
                
                $fuseOptions($fuseOptionName) = ObjCreate("Scripting.Dictionary")
                $desc = IniRead($ini, $fuseOptionName, "desc", $fuseOptionName)
                $valuesStep = IniRead($ini, $fuseOptionName, "list", "")
                $default = Int(IniRead($ini, $fuseOptionName, "default", "0"))
                if ($valuesStep = "") then
                    $fuseOptions($fuseOptionName)("ctrl") = GUICtrlCreateCheckbox($desc, $posFuseLeft, $posFuseTop + 180 + 21 * $i, 500, 20)
                else
                    $valuesStep = Int($valuesStep)
                    $valuesSection = IniReadSection($ini, $fuseOptionName)
                    $valuesList = ObjCreate("Scripting.Dictionary")
                    for $j = 1 to $valuesSection[0][0]
                        if (StringLeft($valuesSection[$j][0], 1) = "v") then
                            $valuesList(Int(StringTrimLeft($valuesSection[$j][0], 1))) = $valuesSection[$j][1]
                        endif
                    next
                    
                    $fuseOptions($fuseOptionName)("ctrl") = GUICtrlCreateCombo("", $posFuseLeft, $posFuseTop + 180 + 21 * $i, 500, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
                    for $j in $valuesList
                        if ($j = $default) then
                            GUICtrlSetData(-1, $valuesList($j), $valuesList($j))
                        else
                            GUICtrlSetData(-1, $valuesList($j))
                        endif
                    next
                    
                    ;for $j in $valuesList
                    ;    GUICtrlSetData($stdoutCtrl, $j & " = " & $valuesList($j) & @CRLF, 1);
                    ;next
                    
                endif
            next
        endif

        ;$pid = Run(DudeCmd() & $arg, "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
        
        ;GUICtrlSetData($stderrCtrl, "")
        ;while ProcessExists($pid)
        ;    GUICtrlSetData($stderrCtrl, StderrRead($pid), 1)
        ;wend
        
        ;GUICtrlSetData($stdoutCtrl, _ArrayToString(StringSplit(StdoutRead($pid), @CRLF, $STR_ENTIRESPLIT), "~"), 1);
        ;GUICtrlSetData($stdoutCtrl, StdoutRead($pid), 1);
    else
        MsgBox(0, "Warning", "Ini file for this device not found")
    endif
    
endfunc

func InitGUI()
    Global $mainWindow = GUICreate("Main", 700, 900) 
    GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked") 

    Global $progCtrl = GUICtrlCreateCombo("", 20, 20, 400)
    for $id in $programmers
        GUICtrlSetData(-1, StringFormat("%s [%s]", $programmers($id), $id), 1)
    next
    ; GUICtrlSetData(-1, $programmer, $programmer)

    Global $devCtrl = GUICtrlCreateCombo("", 430, 20, 200)
    for $i in $devices
        GUICtrlSetData(-1, StringFormat("%s [%s]", $devices($i), $i), 1)
    next
    ;GUICtrlSetData(-1, $device, $device)
    ;GUICtrlSetOnEvent($progCtrl, "UpdateVars")
    ;GUICtrlSetOnEvent($devCtrl, "UpdateVars")
    

    Global $hexCtrl = GUICtrlCreateInput($hex, 20, 50, 600)
    Global $eepCtrl = GUICtrlCreateInput($eep, 20, 80, 600)

    Global $readFusesButton = GUICtrlCreateButton("Read", 20, 110, 50)
    ;GUICtrlSetState(-1, $GUI_DISABLE)

    ;Global $writeFusesButton = GUICtrlCreateButton("Write", 80, 110, 50)
    ;GUICtrlSetOnEvent(-1, "ReadFusesConf")

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

func ReadVars()
    $programmer = IniRead($conf, "conf", "programmer", "")
    $device = IniRead($conf, "conf", "device", "")
endfunc

func WriteVars()
    IniWrite($conf, "conf", "programmer", $programmer)
    IniWrite($conf, "conf", "device", $device)
endfunc

func UpdateVars()
    switch (@GUI_CtrlId)
        case 0
    endswitch
    $programmer = GUICtrlRead($progCtrl)
    $device= GUICtrlRead($devCtrl)
    $hex= GUICtrlRead($hexCtrl)
    $eep= GUICtrlRead($eepCtrl)
endfunc

Func CLOSEClicked() 
    If @GUI_WinHandle = $mainwindow Then 
        UpdateVars()
        WriteVars()
        Exit 
    EndIf 
EndFunc

