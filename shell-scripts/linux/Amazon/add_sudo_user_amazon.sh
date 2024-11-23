#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Get the username from the command line
read -p "Enter the username to create: " username

# Check if the username is provided
if [ -z "$username" ]; then
    echo "Username cannot be empty."
    exit 1
fi

# Add the new user
if id "$username" &>/dev/null; then
    echo "User $username already exists."
else
    adduser "$username"
    echo "User $username created successfully."
fi

# Set the password for the new user
echo "Set a password for the new user:"
passwd "$username"

# Determine the group for sudo privileges
if grep -qE "^sudo:" /etc/group; then
    # For Amazon Linux 2 (uses 'sudo' group)
    sudo_group="sudo"
elif grep -qE "^wheel:" /etc/group; then
    # For Amazon Linux 2023 (uses 'wheel' group)
    sudo_group="wheel"
else
    echo "No suitable sudo group found. Exiting."
    exit 1
fi

# Add the user to the appropriate group
usermod -aG "$sudo_group" "$username"
echo "User $username has been added to the '$sudo_group' group for sudo privileges."

# Verify sudo access
echo "To verify, switch to the new user using 'su - $username' and run 'sudo whoami'."

exit 0
