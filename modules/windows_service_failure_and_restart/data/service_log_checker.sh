

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