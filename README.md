
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat High JDBC Connection Pool Usage Incident.
---

This incident type refers to a situation where the Tomcat server's JDBC connection pool usage surpasses its configured limits. This can lead to a shortage of available connections for incoming requests, resulting in slow response times or even server crashes. It is important to monitor and manage the JDBC connection pool usage to prevent such incidents from occurring.

### Parameters
```shell
export TOMCAT="PLACEHOLDER"

export CONNECTION_POOL_CLASS="PLACEHOLDER"

export DATABASE_PORT="PLACEHOLDER"

export THREAD_CLASS="PLACEHOLDER"

export TOMCAT_PORT="PLACEHOLDER"

export POOL_SIZE="PLACEHOLDER"
```

## Debug

### Get the PID of the Tomcat process
```shell
PID=$(pgrep -f ${TOMCAT})
```

### Check the JDBC connection pool usage
```shell
 jmap -histo:live $PID | grep ${CONNECTION_POOL_CLASS}
```

### Check the database connections in use
```shell
 lsof -n -i -P | grep ${DATABASE_PORT}
```

### Check the number of threads in use
```shell
 jstack $PID | grep -c ${THREAD_CLASS}
```

### Check the Tomcat logs for errors
```shell
sudo tail -n 100 /var/log/tomcat//catalina.out | grep -i "error"
```

### Check the CPU and memory usage of the Tomcat process
```shell
top -p $PID
```

### Check the network connections in use
```shell
netstat -anp | grep ${TOMCAT_PORT}
```

### Check the system logs for errors
```shell
sudo tail -n 100 /var/log/messages | grep -i "error"
```

## Repair

### Increase the maximum size of the connection pool to allow for more simultaneous connections.
```shell


#!/bin/bash



# Assign the ${POOL_SIZE} parameter to a variable

pool_size=${POOL_SIZE}



# Navigate to the Tomcat directory

cd /opt/tomcat/



# Access the Tomcat configuration file

config_file=conf/server.xml



# Update the connection pool settings

sed -i "s/maxActive=\"[0-9]\+\"/maxActive=\"$pool_size\"/" $config_file



# Restart Tomcat to apply the changes

systemctl restart tomcat


```