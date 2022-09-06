# isp-monitor
A friend needs to prove his ISP isn't delivering what they said they would. I had a Pi Zero, an ethernet dongle,
and three pork bao...

There are better versions of this that run on higher end hardware. Jeff Geerling has a fantastic blog/vlog on this
exact topic: https://www.jeffgeerling.com/blog/2021/monitor-your-internet-raspberry-pi

This is a different situation. There are no Raspberry Pi 3/4 to be had in 2022. What I had was is a single Raspberry Pi
Zero (not even a Zero W!), and an ethernet dongle. Everything needed to be self contained on the tiny Zero, so, with a
full family, my time was limited to one lunch on a random Saturday...

So this project is a rough draft of what I came up with so my friend could show the rural ISP that they weren't
delivering what they promised.

## Installation

### Preface
These (incomplete) instructions are so Linux specific that dyed-in-wool-Windows-or-Mac users who are not comfortable
with the Linux command line should look elsewhere. The entire process of hacking this together was done on the Pi
Zero over ssh using vi-tiny.

The point being: if any part of the previous sentence is unclear, this project is not ready for you ... yet. I've
probably forgotten bits, or \<gasp\> authored a bug. You *should* expect things to be broken.

### Install dependencies
This project depends on gnuplot for creating the graphs: `sudo apt install gnuplot`

Yeah, accept the 4 million dependencies, and download the entire internet, including the X-Windows stuff even
though you are most likely running a headless unit.

This project also depends on the speedtest.net open source speed test client: `sudo apt install speedtest-cli`

Finally, for floating point math this project depends on bc: `sudo apt install bc`

You can, of course, do all this in one-fell-swoop: `sudo apt install gnuplot speedtest-cli bc`

### Install the web components
Fortunately Raspbian comes with python3 OEM, so `isp-monitor.server` should work out of the box. Copy this file to the
pi user's home directory, along with `index.html`, `h.html`, `favicon.ico`,and `1px.png`. Confirm all files are owned by
the pi user, and the `isp-monitor.server` file is executable by the pi user and group.

Copy the isp-monitor-http.service to `/etc/systemd/system` and enable to run at startup:

`sudo systemctl enable isp-monitor-http.service`

The previous commands enable the http server to start at boot, so you can see the output of ISP monitoring. To make sure
everything is working, start the service:

`sudo systemctl start isp-monitor-http.service`

Point your browser to http\://\<ip address of your pi\>:8000/ and you should see a page with a bunch of broken
graphics. This just verifies the web server is running.

### Install the monitoring client
Copy the `isp-monitor.client`, `speedguage.gnuplot`, `isp-monitor.gnuplot` files to the pi user's home directory. Make
sure the `isp-monitor.client` file is executable by the pi user and group.

Set up the monitor to run every 5 minutes:
- `cp isp-monitor.timer /etc/systemd/system/`
- `cp isp-monitor.service /etc/system/system/`
- `sudo daemon-reload`
- `sudo enable isp-monitor.timer`
- `sudo start isp-monitor.timer`

The previous commands will start the business end of monitoring.  Within' five minutes the client should run and get
everything initialized. You can validate everything is working by reloading the web page (see above) after the client
runs the first time. The page should have the start of monitoring history, and the archived graphs section at the bottom
should have placeholder images.
  
  
