#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=CPU&BatteryLoggingv1.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=CPU & Battery Information Logging
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Caleb Ku
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
Global Const $headerinfo = "CPU & Battery Logging v1.0, @Copyright 2009 Caleb Ku"

;   --------------------    HOTKEY FUNCTION & VARIABLE --------------------

Global $bHotKeyPressed=False

Func _EscPressed()
    $bHotKeyPressed=True
EndFunc



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

Func _ReduceMemory()
    Local $ai_GetCurrentProcessId = DllCall('kernel32.dll', 'int', 'GetCurrentProcessId')
    Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $ai_GetCurrentProcessId[0])
    Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
    DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Return $ai_Return[0]
EndFunc


;**********************initiate preops for cpu info************
_PDH_Init()
Local $hPDHQuery,$aCPUCounters,$iTotalCPUs
Local $iCounterValue,$sPCName=""   ; $sPCName="\\AnotherPC"
$hPDHQuery=_PDH_GetNewQueryHandle()
$aCPUCounters=_PDH_GetCPUCounters($hPDHQuery,$sPCName)
local $CPU_errorflag = @error
$iTotalCPUs=@extended

;************************************************************

; ********** Vars for Batt info******************************
Global Const $interval = 5
Global $answer = MsgBox(292, "CPU & Battery Logging v1.0", "Are you sure you want to continue start the battery logging session? " & @LF & @LF & _
"This will cause an additional process that monitors intantaneous changes in rate of discharge and voltage every " & $interval &" seconds !!!" & @CRLF& @LF & _
"Press [ALT] + [CTRL] + [B] to stop logging at anytime." & @CRLF& @LF & _
"******@Copyright of Andrew C Ku, not for distribution.******")
local $tCur
;*****************************************************
Func _5secinterval($per)
Do
	$tCur = _Date_Time_GetSystemTime()
	local $splitdate = StringSplit(_Date_Time_SystemTimeToDateTimeStr($tCur), ":")
	local $checkseconds = $splitdate[3] / $per
Until int($checkseconds) = $checkseconds

EndFunc


HotKeySet("^!b", "_EscPressed")


; Check the user's answer to the prompt (see the help file for MsgBox return values)
; If "No" was clicked (7) then exit the script
If $answer = 7 Then
    MsgBox(0, "BatteryLogging", "Process canceled!!!")
    Exit
ElseIf $answer = 6 Then
	local $file1 = FileOpen("CPUBatteryLogging.txt", 1);1 = Read mode
	local $info1 = _getlogging_key()
	FileWriteLine($file1, $headerinfo)
	_PDH_CollectQueryData($hPDHQuery)   ; collect the query information once (1st collection may fail, so we'll discard it)
	Sleep(50)

	For $i1 = 1 to $iTotalCPUs Step 1
		If $i1 <> $iTotalCPUs Then
			$info1 = String($info1 & "," & "CPU # " & $i1)
		ElseIf $i1 = $iTotalCPUs Then
			$info1 = String($info1 & "," & "Total CPU Usage")
		Else
		EndIf
	Next
	FileWriteLine($file1, "UTC Time & Date" & "," & $info1 )
	local $info2


	Do
		;****************Checking time for 5 second interval on 5 second multiples***************
		_5secinterval($interval)
		;********************************************************************
		$info2 = _getbattstatus()
		;**********************Get CPU Usage Info

		If $CPU_errorflag=0 And IsArray($aCPUCounters) Then
        _PDH_CollectQueryData($hPDHQuery)
        For $i2=0 To $iTotalCPUs-1
            ; True means do *not* call _PDH_CollectQueryData for each update. Only once per Query handle is needed
            $iCounterValue=_PDH_UpdateCounter($hPDHQuery,$aCPUCounters[$i2][1],0,True)
            If $i2<>$iTotalCPUs-1 Then
                $info2 = $info2 & "," & $iCounterValue
            Else
                $info2 = $info2 & "," & $iCounterValue
            EndIf
        Next
		EndIf
		;***********************************

		FileWriteLine($file1, _Date_Time_SystemTimeToDateTimeStr($tCur) & "," & $info2)
		_ReduceMemory()
		Sleep(1900)
	Until $bHotKeyPressed
	_PDH_FreeQueryHandle($hPDHQuery)
	_PDH_UnInit()
EndIf

