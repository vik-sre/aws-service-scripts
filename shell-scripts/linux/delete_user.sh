#!/bin/bash

# ============================================================
# Script Name: delete_user.sh
# Purpose: Safely delete a user only if their home directory is empty
# Author: [Your Name] - [Your Email/Contact] (Optional)
# Date: [Today's Date]
# Version: 1.0 (Production Ready)
# License: Open Source / MIT (Optional)
# ============================================================

# Function to log messages
log_message() {
    local log_type="$1"
    local message="$2"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$log_type] $message"
}

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    log_message "ERROR" "This script must be run as root. Exiting."
    exit 1
fi

# Get the username to delete
read -p "Enter the username to delete: " username

# Validate input
if [ -z "$username" ]; then
    log_message "ERROR" "Username cannot be empty. Exiting."
    exit 1
fi

# Check if the user exists
if ! id "$username" &>/dev/null; then
    log_message "ERROR" "User $username does not exist. Exiting."
    exit 1
fi

# Get the user's home directory
home_dir=$(eval echo "~$username")

# Check if the home directory exists
if [ ! -d "$home_dir" ]; then
    log_message "WARNING" "The home directory for user $username does not exist. Proceeding with user deletion..."
else
    # Check if the home directory is empty
    if [ "$(ls -A "$home_dir" 2>/dev/null)" ]; then
        log_message "ERROR" "The home directory for user $username is not empty. Deletion aborted."
        exit 1
    else
        log_message "INFO" "The home directory for user $username is empty. Proceeding with deletion..."
    fi
fi

# Delete the user and their home directory
userdel -r "$username"
if [ $? -eq 0 ]; then
    log_message "SUCCESS" "User $username and their home directory (if exists) have been deleted."
else
    log_message "ERROR" "Failed to delete user $username. Please check manually."
    exit 1
fi

# Thank you message
log_message "INFO" "Thank you for using this script! If you have feedback, contact the author."

exit 0
