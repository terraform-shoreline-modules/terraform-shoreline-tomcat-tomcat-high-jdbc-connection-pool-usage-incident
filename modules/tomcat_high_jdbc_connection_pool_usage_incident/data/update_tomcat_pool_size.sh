

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