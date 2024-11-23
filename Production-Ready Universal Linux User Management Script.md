Here’s a **comprehensive Linux user management script** that handles common tasks like creating, modifying, deleting, and managing user privileges in a **single script**. It includes safeguards, logging, and clear instructions for production use. This script ensures no important aspect of user management is missed.

---

### **Production-Ready Universal Linux User Management Script**

```bash
#!/bin/bash

# ============================================================
# Script Name: user_management.sh
# Purpose: Manage Linux users - Create, Modify, Delete, Grant Sudo
# Author: [Your Name] - [Your Email/Contact] (Optional)
# Date: [Today's Date]
# Version: 1.0
# License: Open Source / MIT (Optional)
# ============================================================

# Function to log messages with timestamps
log_message() {
    local log_type="$1"
    local message="$2"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$log_type] $message"
}

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    log_message "ERROR" "This script must be run as root. Exiting."
    exit 1
fi

# Display menu options
display_menu() {
    echo "==============================="
    echo " Linux User Management Script"
    echo "==============================="
    echo "1. Create a new user"
    echo "2. Modify an existing user"
    echo "3. Delete a user"
    echo "4. Grant sudo privileges to a user"
    echo "5. Revoke sudo privileges from a user"
    echo "6. List all users on the system"
    echo "0. Exit"
    echo "==============================="
}

# Create a new user
create_user() {
    read -p "Enter the username to create: " username
    if [ -z "$username" ]; then
        log_message "ERROR" "Username cannot be empty."
        return
    fi

    if id "$username" &>/dev/null; then
        log_message "ERROR" "User $username already exists."
        return
    fi

    adduser "$username"
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "User $username created successfully."
    else
        log_message "ERROR" "Failed to create user $username."
        return
    fi

    echo "Set a password for the new user:"
    passwd "$username"
}

# Modify an existing user (change username)
modify_user() {
    read -p "Enter the current username to modify: " old_username
    if ! id "$old_username" &>/dev/null; then
        log_message "ERROR" "User $old_username does not exist."
        return
    fi

    read -p "Enter the new username: " new_username
    if [ -z "$new_username" ]; then
        log_message "ERROR" "New username cannot be empty."
        return
    fi

    usermod -l "$new_username" "$old_username"
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "User $old_username has been renamed to $new_username."
    else
        log_message "ERROR" "Failed to rename user $old_username."
    fi
}

# Delete a user (with confirmation and home directory check)
delete_user() {
    read -p "Enter the username to delete: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    home_dir=$(eval echo "~$username")
    if [ -d "$home_dir" ]; then
        if [ "$(ls -A "$home_dir" 2>/dev/null)" ]; then
            log_message "WARNING" "The home directory for user $username is not empty."
            read -p "Do you still want to delete the user and their home directory? (yes/no): " confirm
            if [[ "$confirm" != "yes" ]]; then
                log_message "INFO" "Deletion aborted for user $username."
                return
            fi
        fi
    fi

    userdel -r "$username"
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "User $username and their home directory have been deleted."
    else
        log_message "ERROR" "Failed to delete user $username."
    fi
}

# Grant sudo privileges to a user
grant_sudo() {
    read -p "Enter the username to grant sudo privileges: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    usermod -aG sudo "$username"
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "User $username has been granted sudo privileges."
    else
        log_message "ERROR" "Failed to grant sudo privileges to $username."
    fi
}

# Revoke sudo privileges from a user
revoke_sudo() {
    read -p "Enter the username to revoke sudo privileges: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    deluser "$username" sudo
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "Sudo privileges revoked for user $username."
    else
        log_message "ERROR" "Failed to revoke sudo privileges from $username."
    fi
}

# List all users on the system
list_users() {
    log_message "INFO" "Listing all users on the system:"
    cut -d: -f1 /etc/passwd
}

# Main loop to handle user input
while true; do
    display_menu
    read -p "Enter your choice: " choice
    case $choice in
        1) create_user ;;
        2) modify_user ;;
        3) delete_user ;;
        4) grant_sudo ;;
        5) revoke_sudo ;;
        6) list_users ;;
        0) log_message "INFO" "Exiting script. Thank you!"; exit 0 ;;
        *) log_message "ERROR" "Invalid option. Please try again." ;;
    esac
    echo ""
done
```

---

### **Script Features**
1. **Multi-Functional**: Supports user creation, modification, deletion, granting/revoking sudo privileges, and listing all system users.
2. **Error Handling**: Validates input and ensures actions only proceed if conditions are met (e.g., user existence, empty directories).
3. **Logging**: Provides timestamped logs for all actions (INFO, ERROR, SUCCESS, WARNING).
4. **Interactive Menu**: A user-friendly menu system for performing different operations.
5. **Safeguards**:
   - Checks if the script is run as root.
   - Confirms before deleting a user whose home directory is not empty.
   - Aborts if critical details (like username) are missing.

---

### **Steps to Use**
1. Save the script as `user_management.sh`.
2. Make it executable:
   ```bash
   chmod +x user_management.sh
   ```
3. Run the script with sudo:
   ```bash
   sudo ./user_management.sh
   ```

---

### **Enhancements You Can Add**
- **Logging to a File**: Redirect logs to `/var/log/user_management.log` for permanent records.
- **Validation for Reserved Users**: Prevent accidental modification of critical system users (e.g., `root`).
- **Email Notifications**: Send email alerts for changes to users (optional, using `mail` or similar tools).

---

This script covers **everything** you need for Linux user management in a production-ready environment. Let me know if you'd like further customizations!