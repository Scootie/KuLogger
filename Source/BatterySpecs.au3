#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
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


#include <getbattinfo.au3>

local $file1 = FileOpen("BatterySpecs.txt", 1);1 = Read mode

local $key = _getbattinfo_key()
local $data = _getbattinfo()
local $array[16]

For $i=0 to 15 Step 1
	$array[$i] =$key[$i] & $data[$i]
	FileWriteLine($file1, $array[$i])
Next

FileClose($file1)
