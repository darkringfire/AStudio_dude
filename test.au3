#include <Array.au3>
#include <GUIConstantsEx.au3> 
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <StringConstants.au3>

const $conf = "avrdude.ini"

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent 
$programmer = ""
$device = ""
$project = ""
$target = ""
$auto = ""
$hex = ""
$eep = ""

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

ReadVars()

InitGUI()



While (1)
  Sleep(1000)
WEnd 

;---------------------------------------

func DudeCmd()
    return StringFormat("%s\avrdude.exe -c %s -p %s ", @ScriptDir, $programmer, $device)
endfunc

func ReadFuses()
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
        GUICtrlDelete($fuseBytes($i)("ctrl"))
    next
    for $i in $fuseOptions
        GUICtrlDelete($fuseOptions($i)("ctrl"))
    next
    
    $fuseBytes = ObjCreate("Scripting.Dictionary")
    $fuseBits = ObjCreate("Scripting.Dictionary")
    $fuseOptions = ObjCreate("Scripting.Dictionary")
    if (FileExists($ini)) then
        $fuseBytesList = StringSplit(IniRead($ini, "main", "fuses", ""), ":", $STR_NOCOUNT)
        $fuseOptionsList = StringSplit(IniRead($ini, "main", "options", ""), ":", $STR_NOCOUNT)
        for $i = 0 to UBound($fuseBytesList)-1
            $fuseByteName = $fuseBytesList[$i]
            $arg &= StringFormat(" -U %s:r:-:h", $fuseByteName)
            
            $fuseBytes($fuseByteName) = ObjCreate("Scripting.Dictionary")
            $fuseBytes($fuseByteName)("label") = GUICtrlCreateLabel($fuseByteName, $posFuseLeft + $posFuseStepX * $i, $posFuseTop + 5, 40, 20)
            $fuseBytes($fuseByteName)("ctrl") = GUICtrlCreateInput("", $posFuseLeft + $posFuseStepX * $i + 30, $posFuseTop, 30, 20)
            
            $fuseBitsList = StringSplit(IniRead($ini, $fuseByteName, "bits", ""), ":", $STR_NOCOUNT)
            for $j = 0 to UBound($fuseBitsList)-1
                $fuseBit = ObjCreate("Scripting.Dictionary")
                $fuseBit("fuse") = $fuseByteName
                $fuseBit("n") = $j
                $fuseBit("ctrl") = GUICtrlCreateCheckbox($fuseBitsList[$j], $posFuseLeft + $posFuseStepX * $i, $posFuseTop + 10 + 20 * (8-$j), $posFuseStepX - 10, 20)
                $fuseBits($fuseBitsList[$j]) = $fuseBit
            next
            $fuseBytes($fuseByteName)("bits") = $fuseBitsList
        next
        for $i = 0 to UBound($fuseOptionsList)-1
            $fuseOptionName = $fuseOptionsList[$i]
            
            $fuseOptions($fuseOptionName) = ObjCreate("Scripting.Dictionary")
            $desc = IniRead($ini, $fuseOptionName, "desc", $fuseOptionName)
            ;$fuseOptions($fuseOptionName)("label") = GUICtrlCreateLabel($desc, $posFuseLeft, $posFuseTop + 180 + 20 * $i, 40, 20)
            $valuesStep = IniRead($ini, $fuseOptionName, "list", "")
            if ($valuesStep = "") then
                $fuseOptions($fuseOptionName)("ctrl") = GUICtrlCreateCheckbox($desc, $posFuseLeft, $posFuseTop + 200 + 20 * $i, 500, 20)
            else
                $valuesStep = Int($valuesStep)
                $valuesSection = IniReadSection($ini, $fuseOptionName)
                $valuesList = ObjCreate("Scripting.Dictionary")
                for $j = 1 to $valuesSection[0][0]
                    if (StringLeft($valuesSection[$j][0], 1) = "v") then
                        $valuesList(StringTrimLeft($valuesSection[$j][0], 1)) = $valuesSection[$j][1]
                    endif
                next
                
                $fuseOptions($fuseOptionName)("ctrl") = GUICtrlCreateCombo("", $posFuseLeft, $posFuseTop + 200 + 20 * $i, 500, 20)
                for $j in $valuesList
                    GUICtrlSetData(-1, $valuesList($j))
                next
                
                ;for $j in $valuesList
                ;    GUICtrlSetData($stdoutCtrl, $j & " = " & $valuesList($j) & @CRLF, 1);
                ;next
                
            endif
        next

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
    Global $mainWindow = GUICreate("Main", 700, 800) 
    GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked") 

    Global $progCtrl = GUICtrlCreateInput($programmer, 20, 20, 100)
    Global $devCtrl = GUICtrlCreateInput($device, 140, 20, 100)
    GUICtrlSetOnEvent($progCtrl, "UpdateVars")
    GUICtrlSetOnEvent($devCtrl, "UpdateVars")

    Global $hexCtrl = GUICtrlCreateInput($hex, 20, 50, 600)
    Global $eepCtrl = GUICtrlCreateInput($eep, 20, 80, 600)

    Global $readFusesButton = GUICtrlCreateButton("Read", 20, 110, 50)
    ;Global $writeFusesButton = GUICtrlCreateButton("Write", 80, 110, 50)
    ;GUICtrlSetState($writeFusesButton, $GUI_DISABLE)
    GUICtrlSetOnEvent($readFusesButton, "ReadFuses")

    Global $stdoutCtrl = GUICtrlCreateEdit("", 20, 570, 660, 100);
    Global $stderrCtrl = GUICtrlCreateEdit("", 20, 680, 660, 100);
    GUICtrlSetFont($stdoutCtrl, 10, 0, 0, "Consolas")
    GUICtrlSetFont($stderrCtrl, 10, 0, 0, "Consolas")
    GUICtrlSetBkColor($stdoutCtrl, 0x202020)
    GUICtrlSetBkColor($stderrCtrl, 0x202020)
    GUICtrlSetColor($stdoutCtrl, 0x88FF88)
    GUICtrlSetColor($stderrCtrl, 0xFF8888)

    ;GUICtrlSetData($stdoutCtrl, _ArrayToString($CmdLine, @CRLF), 1);
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

