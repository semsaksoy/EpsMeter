This tool acts as a syslog server and it can detect incoming EPS (Event per Second) values and data size.
It groups log sources by current second, minute and hour on any operating system.

![ss1](https://bitbucket.org/sems/epsmeter/downloads/ScreenshotatAra2220-56-53.png)


 


It works with parameters like any CLI application. You can configure this tool on grouping by source IP or source IP and port. In this way, logs from multiple sources can be easily monitored. In addition to this, the port number to listen, can be configured by parameter with TCP or UDP support.

![ss2](https://bitbucket.org/sems/epsmeter/downloads/ScreenshotatAra2221-06-13.png)
 

 

When you use ctrl + c combination for exit, then the application stores the latest state as a text file if you don�t prevent this with parameter.

![ss3](https://bitbucket.org/sems/epsmeter/downloads/ScreenshotatAra2221-01-02.png)

In my tests with Syslog-ng�s loggen test tool, it responded with high accuracy even in high (10000) EPSs.


[ Download EpsMeter ](https://bitbucket.org/sems/epsmeter/get/HEAD.zip)


