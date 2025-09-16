#!/bin/bash

# The URL to check will be the first argument passed to the script.
APP_URL=$1

# Check if a URL was provided.
if [ -z "$APP_URL" ]; then
    echo "ERROR: Please provide a URL to check."
    echo "Usage: ./app_health_checker.sh <URL>"
    exit 1
fi

echo "[INFO] Checking status of: $APP_URL"

# Use curl to get only the HTTP status code.
# -s: Silent mode
# -o /dev/null: Discard the response body
# -w "%{http_code}": Print only the status code
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)

# Check the status code. A '200' code means everything is OK.
if [ $HTTP_CODE -eq 200 ]; then
    echo "[SUCCESS] ✅ Application is UP. (Status Code: $HTTP_CODE)"
    exit 0
else
    echo "[FAILURE] ❌ Application is DOWN. (Status Code: $HTTP_CODE)"
    exit 1
fi