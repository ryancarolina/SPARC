#!/bin/bash
#
# Snuffer is used to get an AVG, MAX, and MIN response time from a webservice, based on log output
#
# Make the script executable:
# chmod +x snuffer.sh
#
# Run the script with the log file location:
# ./snuffer.sh /opt/tomcat7/epm/logs/epm-response-times.txt


# Read the target file
min=999999999
max=0
total_time=0
line_count=0
filename="$1"
while read -r line || [[ -n $line ]]
do
    # Print the line read
    echo -e "$line"
    line_count=$((line_count + 1))
    

    # Get everything after the equals sign
    time=${line##*=}

    # Remove all whitespace
    time_no_whitespace="$(echo -e "${time}" | tr -d '[[:space:]]')"
    # echo -e "$time_no_whitespace"
    

    # Perform check to confirm the var is an integer
    #re='^[0-9]+$'
    #if ! [[ $time_no_whitespace =~ $re ]] ; then
    #    echo -e "error: non integer found"
        
    #Find AVG, MIN, MAX
        declare -i current_time=$time_no_whitespace
        declare -i total_time=$((current_time + total_time))

	if [ $current_time -lt $min ]; then
		min=$current_time
	fi

	if [ $current_time -gt $max ]; then
		max=$current_time
	fi

done < "$filename"

	average=$((total_time / line_count))
	echo -e "Total Request: $line_count"
	echo -e "Total Time: $total_time"
	echo -e "AVG RTime: $average"
	echo -e "MIN Time: $min"
	echo -e "MAX Time: $max"
