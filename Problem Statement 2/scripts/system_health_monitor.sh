#!/bin/bash

# --- Thresholds ---
# You can change these values to fit your needs.
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=85

# --- Check CPU Usage ---
echo "--- Checking CPU Usage ---"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d'.' -f1)
echo "Current CPU Usage: $CPU_USAGE%"
if [ $CPU_USAGE -gt $CPU_THRESHOLD ]; then
    echo "ALERT 🚨: CPU usage is above the threshold of $CPU_THRESHOLD%!"
else
    echo "OK 👍: CPU usage is normal."
fi
echo ""

# --- Check Memory Usage ---
echo "--- Checking Memory Usage ---"
MEM_USAGE=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2}')
echo "Current Memory Usage: $MEM_USAGE%"
if [ $MEM_USAGE -gt $MEM_THRESHOLD ]; then
    echo "ALERT 🚨: Memory usage is above the threshold of $MEM_THRESHOLD%!"
else
    echo "OK 👍: Memory usage is normal."
fi
echo ""

# --- Check Disk Usage ---
echo "--- Checking Disk Usage ---"
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
    usage=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
    partition=$(echo $output | awk '{ print $2 }')
    if [ $usage -gt $DISK_THRESHOLD ]; then
        echo "ALERT 🚨: Partition '$partition' usage is ${usage}%, which is above the threshold!"
    else
        echo "OK 👍: Partition '$partition' usage is ${usage}%."
    fi
done