set datafile separator ','
set terminal png size 3840,2160 enhanced font ',24'
set output '/home/pi/speedtest.png'
set xdata time
set timefmt "%d%b%YT%H:%M:%s"
set format x "%d%b%YT%H:%M:%s"
set xlabel "DateTime" font 'DejaVu Sans Mono, 24'
set ylabel "Upload/Download Speed in Mbits/s\nPing Response in ms" font 'DejaVu Sans Mono, 24'
set key autotitle columnhead font ',18'
set xtics rotate font ',16'
set ytics font ',16'
plot '/run/user/1000/monitor/history' \
  using 0:2:xtic(1) smooth csplines with lines lc rgb "#FF0000" lw 3, \
  '' using 0:3:xtic(1) smooth csplines with lines lc rgb "#00FF00" lw 3, \
  '' using 0:4:xtic(1) smooth csplines with lines lc rgb "#0000FF" lw 3