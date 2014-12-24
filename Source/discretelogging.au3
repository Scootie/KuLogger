#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=discretelogging_x86.exe
#AutoIt3Wrapper_Outfile_x64=discretelogging_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#Au3Stripper_Parameters=/sv 0/1    /sf 0/1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;Copyright 2009 Caleb Ku
;Licensed under the Apache License, Version 2.0 (the "License");
;you may not use this file except in compliance with the License.
;You may obtain a copy of the License at
;
;http://www.apache.org/licenses/LICENSE-2.0
;
;Unless required by applicable law or agreed to in writing, software
;distributed under the License is distributed on an "AS IS" BASIS,
;WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;See the License for the specific language governing permissions and
;limitations under the License.



#include <getbattstatus.au3>
#include <Date.au3>
#include <_PDH_PerformanceCounters.au3>


Global Const $headerinfo = "Discrete Logging v1.0, @Copyright Caleb Ku"


; Press Esc to terminate script, Pause/Break to "pause"

Global $Paused, $counter = 0
HotKeySet("{SPACE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
local $answer = MsgBox(292, "Logging Prompt", "Do you wish to log battery information as well?")
local $info1, $info2,  $tCur
Global $delimiter = ","
Global $interval = 2


; -------------------- WRAPPER FUNCTION --------------------

Func _PDH_GetCPUCounters($hPDHQuery,$sPCName="")
    ; Strip first '\' from PC Name, if passed
    If $sPCName<>"" And StringLeft($sPCName,2)="\\" Then $sPCName=StringTrimLeft($sPCName,1)
    ; CPU Usage (per processor) (":238\6\(*)" or English: "\Processor(*)\% Processor Time")
    Local $aCPUsList=_PDH_GetCounterList(":238\6\(*)"&$sPCName)
    If @error Then Return SetError(@error,@extended,"")
    ; start at element 1 (element 0 countains count), -1 = to-end-of-array
    Local $aCPUCounters=_PDH_AddCountersByArray($hPDHQuery,$aCPUsList,1,-1)
    If @error Then Return SetError(@error,@extended,"")
    Return SetExtended($aCPUsList[0],$aCPUCounters)
EndFunc

;**********************initiate preops for cpu info************
_PDH_Init()
Local $hPDHQuery,$aCPUCounters,$iTotalCPUs
Local $iCounterValue,$sPCName=""   ; $sPCName="\\AnotherPC"
$hPDHQuery=_PDH_GetNewQueryHandle()
$aCPUCounters=_PDH_GetCPUCounters($hPDHQuery,$sPCName)
local $CPU_errorflag = @error
$iTotalCPUs=@extended



;*****************************************************
Func _5secinterval($per)
Do
	$tCur = _Date_Time_GetSystemTime()
	local $splitdate = StringSplit(_Date_Time_SystemTimeToDateTimeStr($tCur), ":")
	local $checkseconds = $splitdate[3] / $per
Until int($checkseconds) = $checkseconds

EndFunc

Global $filename="discrete.txt"
Global $file1 = FileOpen($filename, 1);1 = Read mode
FileWriteLine($file1, $headerinfo)


If $answer = 7 Then
    MsgBox(0, "Process canceled!!!", "Battery Information will not be logged!")
	$info1 = "null"

	_PDH_CollectQueryData($hPDHQuery)   ; collect the query information once (1st collection may fail, so we'll discard it)
	Sleep(50)


	For $i1 = 1 to $iTotalCPUs Step 1
		If $i1 <> $iTotalCPUs Then
			$info1 = String($info1 & $delimiter & "CPU # " & $i1)
		ElseIf $i1 = $iTotalCPUs Then
			$info1 = String($info1 & $delimiter & "Total CPU Usage")
		Else
		EndIf
	Next
	FileWriteLine($file1, "UTC Time & Date" & $delimiter & $info1 )


ElseIf $answer = 6 Then
	$info1 = _getlogging_key()
;	local $info2_aquire = 1

	_PDH_CollectQueryData($hPDHQuery)   ; collect the query information once (1st collection may fail, so we'll discard it)
	Sleep(50)


	For $i1 = 1 to $iTotalCPUs Step 1
		If $i1 <> $iTotalCPUs Then
			$info1 = String($info1 & $delimiter & "CPU # " & $i1)
		ElseIf $i1 = $iTotalCPUs Then
			$info1 = String($info1 & $delimiter & "Total CPU Usage")
		Else
		EndIf
	Next
	FileWriteLine($file1, "UTC Time & Date" & $delimiter & $info1 )


EndIf

TogglePause()
While 1

;;;; Body of program would go here;;;;




		;****************Checking time for 5 second interval on 5 second multiples***************

		$tCur = _Date_Time_GetSystemTime()
		ConsoleWrite($tCur)
		;_5secinterval($interval)
		;********************************************************************
		_SyncBatteryInfo()
		;**********************Get CPU Usage Info

		If $CPU_errorflag=0 And IsArray($aCPUCounters) Then
        _PDH_CollectQueryData($hPDHQuery)
        For $i2=0 To $iTotalCPUs-1
            ; True means do *not* call _PDH_CollectQueryData for each update. Only once per Query handle is needed
            $iCounterValue=_PDH_UpdateCounter($hPDHQuery,$aCPUCounters[$i2][1],0,True)
            If $i2<>$iTotalCPUs-1 Then
                $info2 = $info2 & $delimiter & $iCounterValue
            Else
                $info2 = $info2 & $delimiter & $iCounterValue
            EndIf
        Next
		EndIf
		;***********************************

		FileWriteLine($file1, _Date_Time_SystemTimeToDateTimeStr($tCur) & "," & $info2)
		Sleep(2000)
	Wend




;;;;;;;;
Func _SyncBatteryInfo()
If $answer=6 Then
	$info2 = _getbattstatus()
Else
	$info2 = "null"
EndIf
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
	FileWriteLine($file1, "session paused/unpaused")
    While $Paused
        sleep(1000)
        ToolTip('Script is "Paused"',0,0, $counter, 1)

    WEnd

ToolTip("")
EndFunc

Func Terminate()
	_PDH_FreeQueryHandle($hPDHQuery)
	_PDH_UnInit()
	Sleep(1000)
    Exit 0
EndFunc
