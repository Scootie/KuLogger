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

#Include <Battery.au3>
#include <GUIConstants.au3>
;/////////////////////////////
;////////////////////////////////
Opt('MustDeclareVars', 1)


Global $aData, $iTag, $sDevicePath = _Battery_GetDevicePath()

Global $string_info
Global $array_key[16]
$array_key[0] = 'Battery Name,'
$array_key[1] = 'Manufacture Name,'
$array_key[2] = 'Manufacture Date,'
$array_key[3] = 'Serial Number,'
$array_key[4] = 'Unique ID,'
$array_key[5] = 'Temperature,'
$array_key[6] = 'Estimated Time,'
$array_key[7] = 'Capabilities,'
$array_key[8] = 'Technology,'
$array_key[9] = 'Chemistry,'
$array_key[10] = 'Designed Capacity,'
$array_key[11] = 'Full Charge Capacity,'
$array_key[12] = 'Default Alert1,'
$array_key[13] = 'Default Alert2,'
$array_key[14] = 'Critical Bias,'
$array_key[15] = 'Cycle Count.'
Global $array[16]
Global $error1 = 'Unable to open the battery device.'
Global $error2 = 'The specified tag does not match that of the current battery tag.'
Global $else = 'Battery not found.'


Func _getbattinfo_key()
	Return $array_key

EndFunc


;////////////
Func _getbattinfo()
$iTag = _Battery_GetTag($sDevicePath)
If $iTag Then
    $aData = _Battery_QueryInfo($sDevicePath, $iTag)
    If IsArray($aData) Then
		For $i=0 to 15 Step 1
			$array[$i] = $aData[$i]
		Next

    Else
        Switch @error
			Case 1
				For $i=0 to 15 Step 1
					$array[$i] = $error1
				Next
            Case 2
				For $i=0 to 15 Step 1
					$array[$i] = $error1
				Next

        EndSwitch
    EndIf
Else
				For $i=0 to 15 Step 1
					$array[$i] = $else
				Next

EndIf
Return $array
EndFunc
