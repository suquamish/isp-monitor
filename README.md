# isp-monitor
A friend needs to prove his ISP isn't delivering what they said they would. I had a Pi Zero, an ethernet dongle,
and three pork bao...

There are better versions of this that run on higher end hardware. Jeff Geerling has a fantastic blog/vlog on this
exact topic: https://www.jeffgeerling.com/blog/2021/monitor-your-internet-raspberry-pi

This is a different situation. There are no Raspberry Pi 3/4 to be had in 2022. What I had was is a single Raspberry Pi
Zero (not even a Zero W!), and an ethernet dongle. So, with a full family, and a baby on the way, my time was limited to
one lunch on a random Saturday...

So this is a rough draft of what I came up with so my friend could keep track of internet performance and show the
rural ISP that they weren't delivering what they promised.

I'll refine it over time...

## Installation

### Preface
These (incomplete) instructions are so Linux specific that dyed-in-wool-Windows-or-Mac users who are not comfortable
with the Linux command line should look elsewhere. The entire process of hacking this together was done on the Pi
Zero over ssh using vi-tiny.

The point being: if any part of the previous sentence is unclear, this project is not ready for you ... yet. I've
probably forgotten bits, or <gasp> authored a bug. You *should* expect things to be broken.

### Install dependencies
This project depends on gnuplot: `sudo apt install gnuplot`

Yeah, accept the 4 million dependencies, and download the entire internet, including the X-Windows stuff even
though you are most likely running a headless unit.

This project also depends on the speedtest.net open source speed test client: `sudo apt install speedtest-cli`

### Install the web components
Fortunately Raspbian comes with python3 OEM, so `isp-monitor.server` should work out of the box. Copy this file to the
pi user's home directory, along with `index.html`, `h.html`, and `1px.png`.  Confirm all files are owned by the pi user.

Copy the isp-monitor-http.service to `/etc/systemd/system` and enable to run at startup:
`sudo systemctl enable isp-monitor-http.service`

The previous commands enable the http server to start at boot, so you can see the output of your ISP monitoring.  To
make sure everything is working, start the service with `sudo systemctl start isp-monitor-http.service` and point your
browser to http://<ip address of your pi>:8000/  and you should see a page with a bunch of broken graphics.  This just
verifies the web server is running.

### Install the monitoring client
Copy the `isp-monitor.client` file to the pi user's home directory.

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
  
With time the Pi should start presenting data similar to this:
  
![image](https://user-images.githubusercontent.com/6550279/188284561-aad52df3-3767-49ba-9730-c7ed385fa82e.png)
  
