#!/usr/bin/env python3
"""
Application Health Checker
--------------------------
This script checks whether a web application is running by sending HTTP requests
to a specified URL. It logs the status and timestamps to a file and prints the
current status to the console.
"""

import requests
import logging
from datetime import datetime
from argparse import ArgumentParser

# ---------------------------
# Configuration
# ---------------------------
DEFAULT_URL = "http://localhost:4498"
DEFAULT_TIMEOUT = 5  # seconds
LOG_FILE = "app_health_log.txt"

# ---------------------------
# Logging Setup
# ---------------------------
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

# ---------------------------
# Functions
# ---------------------------
def check_app_health(url: str, timeout: int = DEFAULT_TIMEOUT) -> tuple:
    """
    Sends a GET request to the application URL and checks its status.
    
    Args:
        url (str): The URL of the application to check.
        timeout (int): Request timeout in seconds.
    
    Returns:
        tuple: (status_str, code_or_error)
            status_str: "UP" or "DOWN"
            code_or_error: HTTP status code or error message
    """
    try:
        response = requests.get(url, timeout=timeout)
        if response.status_code == 200:
            return "UP", response.status_code
        else:
            return "DOWN", response.status_code
    except requests.exceptions.RequestException as e:
        return "DOWN", str(e)

def log_status(status: str, code_or_error) -> None:
    """
    Logs the status to the console and to a log file.
    
    Args:
        status (str): "UP" or "DOWN"
        code_or_error: HTTP status code or error message
    """
    message = f"Status: {status}, Code/Error: {code_or_error}"
    print(message)
    if status == "UP":
        logging.info(message)
    else:
        logging.error(message)

def parse_arguments() -> str:
    """
    Parses command-line arguments for the script.
    
    Returns:
        str: URL to check
    """
    parser = ArgumentParser(description="Check the health of a web application.")
    parser.add_argument(
        "-u", "--url",
        type=str,
        default=DEFAULT_URL,
        help=f"URL of the application to check (default: {DEFAULT_URL})"
    )
    parser.add_argument(
        "-t", "--timeout",
        type=int,
        default=DEFAULT_TIMEOUT,
        help=f"Timeout in seconds for the HTTP request (default: {DEFAULT_TIMEOUT})"
    )
    args = parser.parse_args()
    return args.url, args.timeout

# ---------------------------
# Main
# ---------------------------
def main():
    url, timeout = parse_arguments()
    status, code_or_error = check_app_health(url, timeout)
    log_status(status, code_or_error)

if __name__ == "__main__":
    main()
