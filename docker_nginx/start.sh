#!/bin/bash

servers_string=""
IFS='| ' read -a array <<< "${TARGET_SERVERS}"
count=${#array[@]}

for i in "${array[@]}"; do
    servers_string="${servers_string}\nserver $i;"
done

srv_str=`echo ${servers_string} | cut -c3-`

/bin/sed -i "s/<proxy_pass_placeholder1>/${srv_str}/" /etc/nginx/sites-enabled/default
/bin/sed -i "s/appdomain/${APPURL}/" /etc/nginx/sites-enabled/default

nginx -g "daemon off;"
