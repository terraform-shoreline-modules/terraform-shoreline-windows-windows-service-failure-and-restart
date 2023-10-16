
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Windows Service Failure and Restart
---

This incident type involves checking if a particular Windows service is running, and if it's not, then restarting it twice. This can occur due to various reasons, such as unexpected shutdown, system failure, or software malfunction. The aim is to ensure that the Windows service is up and running to avoid any disruptions in the system's functionality.

### Parameters
```shell
export SERVICE_NAME="PLACEHOLDER"

export LOG_FILE_PATH="PLACEHOLDER"
```

## Debug

### Next Step
```shell
powershell

# Check if the service is running

Get-Service -Name ${SERVICE_NAME}
```

### Restart the service
```shell
Restart-Service -Name ${SERVICE_NAME}
```

### Check the status of the service after restarting it
```shell
Get-Service -Name ${SERVICE_NAME} | Select-Object -Property Status
```

### Check the service's recovery options
```shell
Get-Service -Name ${SERVICE_NAME} | Select-Object -ExpandProperty CanStop, CanPauseAndContinue, CanShutdown, CanStop, StartupType, RecoveryOptions, RecoveryAction
```

### Check the service's event logs for any related errors
```shell
Get-EventLog -LogName System -Source ${SERVICE_NAME} -After (Get-Date).AddDays(-7) -EntryType Error
```

## Repair

### Check the logs and system events to determine the root cause of the service failure.
```shell


#!/bin/bash



# set the name of the service to be checked

SERVICE_NAME=${SERVICE_NAME}



# set the log file path

LOG_FILE=${LOG_FILE_PATH}



# check the system logs for any errors related to the service

if grep -q "error" "$LOG_FILE"; then

    # if errors are found, print the last 10 lines of the log file for review

    tail -n 10 "$LOG_FILE"

else

    echo "No errors found in the system logs."

fi


```

### If the service is stopped due to system failure, perform a system reboot and restart the service.
```shell
bash

#!/bin/sh

# Windows service remediation script



SERVICE_NAME=${SERVICE_NAME}



# Check if the service is running

sc query $SERVICE_NAME | findstr /i "STATE" | findstr "RUNNING"

if [ $? -eq 0 ]

then

  echo "$SERVICE_NAME service is running."

else

  echo "$SERVICE_NAME service is not running."



  # Perform a system reboot

  shutdown /r /t 0



  # Wait for the system to reboot

  sleep 60



  # Restart the service

  net start $SERVICE_NAME



  echo "Service restarted successfully."

fi


```