## Scientific Process

Generally speaking, it's a personal grip that the vast majority of technical editors, reviewers, analyst misrepresent their trade. Or are at the very least inaccurate in terms of the approach that many people take to technical analysis. While they asset product x is better than product y, they arrive at such a conclusion without following the fundamental principle of the scientific process: [ceteris paribus](http://en.wikipedia.org/wiki/Ceteris_paribus). This is a latin phrase that roughly translates "all other things being equal." It's a keystone theme that runs through all things in math and science.

## Real-World Example

A really good example is when you're testing two notebooks. One uses an Intel CPU/chipset and the other uses AMD CPU/chipset. How can you test which CPU is the most efficient at task x?

The majority of people will simply use the to time to complete task x on each notebook as their benchmark metric. This is flat out wrong. As the scope of the investigation is the CPU, you need to elimnate independent variables that are within your control.

This is especially important in notebooks, as the screen consumes roughly 30% of the system battery life. The brightness setting though similar (say 300 cd/m^2) may actually account to a difference of several watts in power consumption depending on the LCD technology and grade of the panel. The solution is to output to a desktop monitor using VGA, DVI, or HDMI and eliminate this as a skewing variable. The hard drive/SSD should be of an identical model, or better yet use a SATA power extension cable to run it off a DC PSU. Disabling wifi due to its stochastic burst power consumption and using ethernet is another step we can take

As we slowly run down the list to remove all these extraneous variables, we are creating a scenario where the final benchmark numbers will present clear scientific conclusion. Moreover, these practices adhere to the general principle in any scientific investigation.

## Published Examples

The following are a few published examples, where we investigated core technologies regarding CPU or power consumption with the scientific process in mind using the CPU&BatteryLogging program.

CPU Usage

[![CPU Usage](https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRAvGQusNCCsivv-8MljHORyIJ7v2KTxk5V5LHJJOfl-GXnG-02-g)](http://media.bestofmicro.com/1/A/278686/original/transcodingperf_cpu.png)
[![CPU Usage](https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTmecMCYtQVcg6mhU4mZRvJ0BRUMKQ_vF_PK5vDnU8zynbUqF3KSg)](http://media.bestofmicro.com/Z/K/335648/original/cpu_pcmark.png)

Power Usage

[![Power Usage](https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRAvGQusNCCsivv-8MljHORyIJ7v2KTxk5V5LHJJOfl-GXnG-02-g)](http://media.bestofmicro.com/1/D/278689/original/transcodingquality_power.png)
[![Power Usage](/documentation/power_example2.jpg)](http://thgtr.com/wp-content/uploads/2011/06/power_-_rlumark.png)
