To ensure compatibility across **all Amazon Linux distributions**, including **Amazon Linux 2** and **Amazon Linux 2023**, you can use the following version of the script. This will automatically handle the differences in sudo group names and permissions.

---

### **Universal Script for Amazon Linux Distributions**
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
```

---

### **How It Works**
1. **Checks for Sudo Group**:
   - **Amazon Linux 2** uses the `sudo` group for sudo privileges.
   - **Amazon Linux 2023** uses the `wheel` group.
   - The script dynamically checks which group exists and assigns the user to it.
2. **Error Handling**:
   - If neither group exists, the script exits with an error.

---

### **Steps to Use the Script**
1. Save the script as `add_sudo_user_amazon.sh`.
2. Make it executable:
   ```bash
   chmod +x add_sudo_user_amazon.sh
   ```
3. Run it with root privileges:
   ```bash
   sudo ./add_sudo_user_amazon.sh
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

This script will work on **Amazon Linux 2**, **Amazon Linux 2023**, and any other Amazon Linux distribution. Let me know if you need further assistance!