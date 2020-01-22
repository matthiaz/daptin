#!/bin/bash
#get the database username/password/host
rel=$(echo $PLATFORM_RELATIONSHIPS | base64 -d | tr "," "\n" | tr "[" "\n"); for i in username password host port path; do val=$(echo "${rel}" | grep -P "\"${i}\"" | cut -f 2 -d ":" | cut -f 2 -d '"' | tr -d "]" | tr -d "}" | tr -d " "); eval "rel_${i}"=${val}; done; 


#build the connection string
CONNECTIONSTRING=$(echo "${rel_username}:$rel_password@tcp(${rel_host}:${rel_port})/${rel_path}") 


#move the log to /tmp (because platform /app is read-only by design)
export DAPTIN_LOG_LOCATION="/tmp/daptin.log"

echo "Starting daptin with the following command: "
echo "/app/bin/daptin -db_type=mysql -db_connection_string='$CONNECTIONSTRING' -port=$PORT"
/app/bin/daptin -db_type=mysql -db_connection_string="$CONNECTIONSTRING" -port=$PORT 2>&1 > /tmp/daptin_startup.log
