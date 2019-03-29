This tool listens to a syslog port and it can detect incoming EPS (Event per Second) values and data size.
It groups log sources by current second, minute and hour on any operating system.

It may be used for estimating hardware requirements for log servers or SIEMs.

![ss1](https://bitbucket.org/sems/epsmeter/downloads/ScreenshotatAra2220-56-53.png)


 


It works with parameters like any CLI application. You can configure this tool to group events by source IP or source IP and port. This way, logs from multiple sources can be easily monitored. In addition to this, the port number to listen to can be configured by parameter along with TCP or UDP support.

![ss2](https://bitbucket.org/sems/epsmeter/downloads/ScreenshotatAra2221-06-13.png)
 

 

When you use ctrl + c combination for exit, then the application stores the latest state as a text file if you don't prevent this with parameter.

## TCP
![ss3](https://bitbucket.org/sems/epsmeter/downloads/ScreenshotatAra2221-01-02.png)

## UDP
![ss4](https://user-images.githubusercontent.com/1064270/54852220-446de380-4cfd-11e9-8c2a-70b81486c704.jpeg)

## Limitations
Preliminary tests with Syslog-ng's [loggen](https://linux.die.net/man/1/loggen) test tool, show that EpsMeter responds with high accuracy even at 10000 EPSs.


[ Download EpsMeter ](https://bitbucket.org/sems/epsmeter/get/HEAD.zip)
