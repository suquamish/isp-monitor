# Thanks to https://funprojects.blog/2022/01/08/gnuplot-speedometer-gauge/
set terminal png size 364,250 enhanced font ',18'
if (networkDirection eq "up") {
  set output "/home/pi/upload.png"
} else {
  set output "/home/pi/download.png
}
set xrange [-1:1]
set yrange [0:1]
set angles degrees
set size ratio -1
# r1 = annulus outer radius, r2 = annulus inner radius
r1=1.0
r2=0.5
unset border
unset tics
unset key
unset raxis
topSpeed=100
 
set style fill solid noborder
set object 1 circle at first 0,0 front size r1 arc [181:182]  fillcolor rgb 'black'
# define the gauge background
set object circle at first 0,0  size r1 arc [20:180]  fillcolor rgb 'red'
set object circle at first 0,0  size r1 arc [0:10]  fillcolor rgb 'green'
set object circle at first 0,0  size r1 arc [10:20]  fillcolor rgb 'yellow'
set object circle at first 0,0 front size r2 arc [0:180] fillcolor rgb 'black'

topSpeed=topSpeed*.97
if (networkDirection eq "up") {
  load '/run/user/1000/monitor/uploadAverage'
  graphTitle="Avg. Upload Speed"
} else {
  load '/run/user/1000/monitor/downloadAverage'
  graphTitle="Avg. Download Speed"
}
percentTopSpeed = (averageSpeed / topSpeed) * 100
# scale the value from 0-100 to 180-0 (arc starts on the right)
value = (100 - real(percentTopSpeed)) * 1.8
# show the value in the title
set title sprintf("%s\n%.1f Mib/s", graphTitle, averageSpeed)
# reposition the value in the gauge
set object 1 circle at first 0,0 front size r1 arc [value:(value+1)]  fillcolor rgb 'black'
plot -10
