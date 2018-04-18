This tool acts as a syslog server and it can detect incoming EPS (Event per Second) values and data size.
It groups log sources by current second, minute and hour on any operating system.

![](https://bitbucket.org/sems/epsmonitor/downloads/ScreenshotatAra2220-56-53.png | width=100)


 


It works with parameters like any CLI application. You can configure this tool on grouping by source IP or source IP and port. In this way, logs from multiple sources can be easily monitored. In addition to this, the port number to listen, can be configured by parameter with TCP or UDP support.

![](https://bitbucket.org/sems/epsmonitor/downloads/ScreenshotatAra2221-06-13.png | width=100)
 

 

When you use ctrl + c combination for exit, then the application stores the latest state as a text file if you don�t prevent this with parameter.

![](https://bitbucket.org/sems/epsmonitor/downloads/ScreenshotatAra2221-01-02.png | width=60)

In my tests with Syslog-ng�s loggen test tool, it responded with high accuracy even in high (10000) EPSs.
