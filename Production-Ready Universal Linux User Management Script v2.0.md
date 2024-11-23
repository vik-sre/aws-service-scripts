Here is the **complete and comprehensive Linux User Management Script** that combines all the features previously discussed, offering robust functionality for user management in a production environment.

---

### **Production-Ready Linux User Management Script**

```bash
#!/bin/bash

# ============================================================
# Script Name: user_management.sh
# Purpose: Comprehensive Linux User Management Script
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
    echo "7. Set password expiry for a user"
    echo "8. Disable a user account"
    echo "9. Enable a user account"
    echo "10. Bulk add users"
    echo "11. Bulk delete users"
    echo "12. Check last login of a user"
    echo "13. Manage user groups"
    echo "14. Backup user accounts"
    echo "15. Restore user accounts"
    echo "0. Exit"
    echo "==============================="
}

# Functionality: Create a new user
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

# Functionality: Modify an existing user
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

# Functionality: Delete a user
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

# Functionality: Grant sudo privileges to a user
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

# Functionality: Revoke sudo privileges from a user
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

# Functionality: List all users
list_users() {
    log_message "INFO" "Listing all users on the system:"
    cut -d: -f1 /etc/passwd
}

# Functionality: Set password expiry for a user
set_password_expiry() {
    read -p "Enter the username to set password expiry: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    read -p "Enter the number of days before password expires (e.g., 90): " days
    chage -M "$days" "$username"
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "Password expiry set to $days days for user $username."
    else
        log_message "ERROR" "Failed to set password expiry for $username."
    fi
}

# Functionality: Disable a user
disable_user() {
    read -p "Enter the username to disable: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    usermod -L "$username"
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "User $username has been disabled."
    else
        log_message "ERROR" "Failed to disable user $username."
    fi
}

# Functionality: Enable a user
enable_user() {
    read -p "Enter the username to enable: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    usermod -U "$username"
    if [ $? -eq 0 ]; then
        log_message "SUCCESS" "User $username has been enabled."
    else
        log_message "ERROR" "Failed to enable user $username."
    fi
}

# Functionality: Bulk add users
bulk_add_users() {
    read -p "Enter the file path containing usernames (one per line): " file
    if [ ! -f "$file" ]; then
        log_message "ERROR" "File $file does not exist."
        return
    fi

    while IFS= read -r username; do
        if id "$username" &>/dev/null; then
            log_message "WARNING" "User $username already exists. Skipping."
        else
            adduser "$username" && log_message "SUCCESS" "User $username created."
        fi
    done < "$file"
}

# Functionality: Bulk delete users
bulk_delete_users() {
    read -p "Enter the file path containing usernames to delete (one per line): " file
    if [ ! -f "$file" ]; then
        log_message "ERROR" "File $file does not exist."
        return
    fi

    while IFS= read -r username; do
        if id "$username" &>/dev/null; then
            userdel -r "$username" && log_message "SUCCESS" "User $username deleted."
        else
            log_message "WARNING" "User $username does not exist. Skipping."
        fi
    done < "$file"
}

# Functionality: Check last login
check_last_login() {
    read -p "Enter the username to check last login: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    last_login=$(lastlog -u "$username" | tail -n 1)
    log_message "INFO" "Last login information for $username: $last_login"
}

# Functionality: Manage

 user groups
manage_user_group() {
    read -p "Enter the username: " username
    if ! id "$username" &>/dev/null; then
        log_message "ERROR" "User $username does not exist."
        return
    fi

    echo "1. Add user to a group"
    echo "2. Remove user from a group"
    read -p "Choose an option: " choice

    case $choice in
        1)
            read -p "Enter the group name to add: " group
            usermod -aG "$group" "$username"
            if [ $? -eq 0 ]; then
                log_message "SUCCESS" "User $username added to group $group."
            else
                log_message "ERROR" "Failed to add $username to group $group."
            fi
            ;;
        2)
            read -p "Enter the group name to remove: " group
            gpasswd -d "$username" "$group"
            if [ $? -eq 0 ]; then
                log_message "SUCCESS" "User $username removed from group $group."
            else
                log_message "ERROR" "Failed to remove $username from group $group."
            fi
            ;;
        *)
            log_message "ERROR" "Invalid option. Returning to menu."
            ;;
    esac
}

# Functionality: Backup user accounts
backup_users() {
    backup_dir="/backup/user_management"
    mkdir -p "$backup_dir"
    cp /etc/passwd "$backup_dir/passwd.bak"
    cp /etc/shadow "$backup_dir/shadow.bak"
    cp /etc/group "$backup_dir/group.bak"
    log_message "SUCCESS" "User accounts have been backed up to $backup_dir."
}

# Functionality: Restore user accounts
restore_users() {
    backup_dir="/backup/user_management"
    if [ -f "$backup_dir/passwd.bak" ] && [ -f "$backup_dir/shadow.bak" ] && [ -f "$backup_dir/group.bak" ]; then
        cp "$backup_dir/passwd.bak" /etc/passwd
        cp "$backup_dir/shadow.bak" /etc/shadow
        cp "$backup_dir/group.bak" /etc/group
        log_message "SUCCESS" "User accounts have been restored from $backup_dir."
    else
        log_message "ERROR" "Backup files not found in $backup_dir."
    fi
}

# Main loop to handle menu input
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
        7) set_password_expiry ;;
        8) disable_user ;;
        9) enable_user ;;
        10) bulk_add_users ;;
        11) bulk_delete_users ;;
        12) check_last_login ;;
        13) manage_user_group ;;
        14) backup_users ;;
        15) restore_users ;;
        0) log_message "INFO" "Exiting. Thank you!" ; exit 0 ;;
        *) log_message "ERROR" "Invalid choice. Please try again." ;;
    esac
done
```

---

### **Key Features**
1. **User Creation**: Interactive user creation with password setup.
2. **User Modification**: Rename users.
3. **User Deletion**: Handles non-empty home directories safely.
4. **Sudo Privileges Management**: Grant/revoke sudo access.
5. **Bulk Operations**: Add/delete users from a file.
6. **Audit Features**: Last login, password expiry management.
7. **Group Management**: Add/remove users from groups.
8. **Backup and Restore**: Protect user data for disaster recovery.

---

### **Usage Instructions**
1. Save this script as `user_management.sh`.
2. Make it executable:
   ```bash
   chmod +x user_management.sh
   ```
3. Run it as root:
   ```bash
   sudo ./user_management.sh
   ```

Let me know if you'd like further refinements! 🚀