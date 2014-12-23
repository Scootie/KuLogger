MobileBenchmarkTools
==========
MobileBenchmarkTools is composed of two discrete programs: BatterySpecs and CPU&BatteryLogging. 

![batteryinfo](/documentation/batteryspecs.png)

The first queries information about the battery (chemistry, capacity, cycle count, etc...) and exports everything directly to a text file in a CSV format. Some of this data is available in Window's Device Manager. However, this tool is a quick resource for those testing systems in parallel, saving time performing mundane navigation and avoiding human error related to data entry.

![logger](/documentation/prompt.png)

CPU&BatteryLogger is a much more powerful tool. It logs CPU usage (all logical cores) and battery information (current capacity, cooling mode, AC/DC status, etc...) to a CSV file periodically. 

![logger](/documentation/logging.png)

Currently, the program is set to log every 5 seconds, but this can be adjusted in the source and recompiled. 

## Background

The majority of tech editors, journalists, bloggers, etc... utilize consumer battery information tools to great effect. The problem is that usually, they're only touching the surface of what is very important information, and often it's a limitation of of the software. 

For example, PassMark's battery tool tracks battery life but with a fixed workload imposed by the software. What if I want to test H.264 decoding efficiency, specifically? What about web browsing? What about 2D rendering? Or 3D rendering? Surely Crysis 3 has a different workload than Minecraft. As my needs are wide ranging, the tools I need require flexibility.

I originally wrote MobileBenchmarkTools in C++, but converted eventually to AutoIt for several reasons. Many of my benchmark scripts were already programmed in AutoIt, because it provided a method to quantitatively measure at the user experience level by interacting GUI elements. Additionally, coding in a single language is easier to maitain, and allows for future inoperability if I needed to write more complex programs/scripts.

## Examples

CPU Usage

[![CPU Usage](https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRAvGQusNCCsivv-8MljHORyIJ7v2KTxk5V5LHJJOfl-GXnG-02-g)](http://media.bestofmicro.com/1/A/278686/original/transcodingperf_cpu.png)
[![CPU Usage](https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTmecMCYtQVcg6mhU4mZRvJ0BRUMKQ_vF_PK5vDnU8zynbUqF3KSg)](http://media.bestofmicro.com/Z/K/335648/original/cpu_pcmark.png)

Power Usage

[![Power Usage](/documentation/power_example2.jpg)](http://media.bestofmicro.com/1/D/278689/original/transcodingquality_power.png)
[![Power Usage](https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRAvGQusNCCsivv-8MljHORyIJ7v2KTxk5V5LHJJOfl-GXnG-02-g)](http://thgtr.com/wp-content/uploads/2011/06/power_-_rlumark.png)

## Executable Requirements
* Windows XP/NT/2000/7/8

## Requirements for Source
* AutoIt 3.3.x or later
* Required .au3 libs
  * [BatteryUDF](../../../BatteryUDF/)
  * [PDH Performance Counter](https://sites.google.com/site/ascend4ntscode/performancecounters-pdh) (CPU&BatteryLogging), copy is included in this git. Link provided for record of original source/updates.
  * getbattinfo (BatterySpecs)
  * getbattstatus (CPU&BatteryLogging)

## License

Copyright Caleb Ku 2009. Distributed under the Apache 2.0 License. (See accompanying file LICENSE or copy at http://www.apache.org/licenses/LICENSE-2.0)
