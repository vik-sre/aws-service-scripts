For **all Ubuntu versions**, the group used to grant sudo privileges is consistently **`sudo`**. The script for Ubuntu will work across all versions (from Ubuntu 16.04 to the latest release, including Ubuntu 22.04).

Below is an updated script that works for **all Ubuntu versions**:

---

### **Universal Script for All Ubuntu Versions**
```bash
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

# Add the user to the sudo group for sudo privileges
usermod -aG sudo "$username"
echo "User $username has been added to the 'sudo' group for sudo privileges."

# Verify sudo access
echo "To verify, switch to the new user using 'su - $username' and run 'sudo whoami'."

exit 0
```

---

### **How It Works:**
1. **Check for Root Privileges**: The script ensures it is executed as the root user (or with sudo).
2. **Create a New User**: It prompts you for a username, checks if the user already exists, and if not, creates the user.
3. **Set Password**: It allows you to set the password for the new user.
4. **Add User to the `sudo` Group**: It ensures the new user is added to the `sudo` group, which is the standard group for granting sudo privileges on all Ubuntu versions.
5. **Instructions for Verifying sudo Access**: After completing the setup, the script guides you on how to verify the user has sudo privileges.

---

### **Steps to Use the Script**
1. Save the script as `add_sudo_user_ubuntu.sh`.
2. Make it executable:
   ```bash
   chmod +x add_sudo_user_ubuntu.sh
   ```
3. Run the script with root privileges:
   ```bash
   sudo ./add_sudo_user_ubuntu.sh
   ```

---

### **Test the New User**
1. Switch to the new user:
   ```bash
   su - username
   ```
2. Test sudo privileges:
   ```bash
   sudo whoami
   ```
If successful, it will return:
```
root
```

This script is compatible with **all versions of Ubuntu**, as the group name for sudo privileges is consistent across all versions. Let me know if you need more help!