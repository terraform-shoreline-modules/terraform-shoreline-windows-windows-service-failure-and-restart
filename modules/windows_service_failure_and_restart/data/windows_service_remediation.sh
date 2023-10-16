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