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

ReadFuses()


While (1)
  Sleep(1000)
WEnd 

;---------------------------------------

func ReadFuses()
    $pid = Run(@ScriptDir & "\avrdude.exe -c usbasp -p m328p -U efuse:r:-:h -U hfuse:r:-:h -U lfuse:r:-:h", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
    
    GUICtrlSetData($stderrCtrl, "")
    while ProcessExists($pid)
        GUICtrlSetData($stderrCtrl, StderrRead($pid), 1)
    wend
    
    GUICtrlSetData($stdoutCtrl, _ArrayToString(StringSplit(StdoutRead($pid), @CRLF, $STR_ENTIRESPLIT), "~"), 1);
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

    Global $efuseCtrl = GUICtrlCreateInput("", 20, 110, 40)
    Global $hfuseCtrl = GUICtrlCreateInput("", 70, 110, 40)
    Global $lfuseCtrl = GUICtrlCreateInput("", 120, 110, 40)
    GUICtrlSetState($efuseCtrl, $GUI_DISABLE)
    GUICtrlSetState($hfuseCtrl, $GUI_DISABLE)
    GUICtrlSetState($lfuseCtrl, $GUI_DISABLE)
    
    Global $readFusesButton = GUICtrlCreateButton("Read", 170, 110, 50)
    Global $writeFusesButton = GUICtrlCreateButton("Read", 170, 110, 50)
    GUICtrlSetState($writeFusesButton, $GUI_DISABLE)

    Global $stdoutCtrl = GUICtrlCreateEdit("", 20, 170, 660, 300);
    Global $stderrCtrl = GUICtrlCreateEdit("", 20, 480, 660, 300);
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

