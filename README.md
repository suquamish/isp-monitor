# isp-monitor
A friend needs to prove his ISP wasn't delivering what they said they would.  I had a Pi Zero, an ethernet dongle,
and three pork bao...

There are better versions of this that run on higher end hardware.  Jeff Geerling has a fantastic blog/vlog on this
exact topic: https://www.jeffgeerling.com/blog/2021/monitor-your-internet-raspberry-pi

This is a different situation.  There are no Raspberry Pi 3/4 to be had in 2022. What I had was is a single Raspberry Pi
Zero (not even a Zero W!), and an ethernet dongle. So, with a full family, and a baby on the way, my time was limited to
one lunch on a random Saturday...

So this is a rough draft of what I came up with so my friend could keep track of his internet performance and show his
rural ISP that they weren't delivering what they promised. I'll refine it over time.

## Caveat
I did say this is a rough draft, right? Mostly this just intended to make what I cobbled together stored in a place
where I could refine it. If it doesn't work, I'll try to help, but at the same time you *should* expect things to not
work.

## Installation

### Perface
OMG!  If you're using Windows or MacOS, I ask to ask if you read the part about my having a Pi Zero?! These (incomplete)
instructions are so Linux specific that dyed-in-wool-Windows-and-Mac users should turn back. Then entire process of
hacking this together was on the Pi Zero over ssh using vim.
(the point being: if you don't understand that, this project is not read for you yet)

This project depends on gnuplot: `sudo apt install gnuplot`

Yeah, accept the 4 million dependencies, and download the entire internet.  Yes, including the X-Windows stuff even
though you are running a headless unit.

This project also depends on the Ookla open source speed test client: `sudo apt install speedtest-cli`

Fortunately Raspbian comes with python3 OEM, so `isp-monitor.server` should work out of the box. Copy this file to the
pi user's home directory.

Copy the isp-monitor-http.service to /etc/systemd/system and enable to run at startup:
`systemctl enable isp-monitor-https.service`

The previous two commands enable the http server to start at boot, so you can see the output of your ISP monitoring. Now
we need to make sure the client can measure how the ISP is delivering internet service.

Copy the isp-monitor.client file to the user pi's home directory: `cp isp-monitor.client ~pi/`

Set up the client to run every 5 minutes:
- `cp isp-monitor.timer /etc/systemd/system/`
- `cp isp-monitor.service /etc/system/system/`
- `sudo daemon-reload`
- `sudo enable isp-monitor.timer`

