To structure your repository with directories organized by AWS services, you can use the following structure:

```
aws-service-scripts/
│
├── README.md
├── LICENSE
├── ec2/
│   ├── shell/
│   │   └── list-instances.sh
│   ├── python/
│   │   └── start-instances.py
│   └── powershell/
│       └── stop-instances.ps1
├── s3/
│   ├── shell/
│   │   └── list-buckets.sh
│   ├── python/
│   │   └── upload-file.py
│   └── powershell/
│       └── delete-bucket.ps1
├── lambda/
│   ├── shell/
│   │   └── list-functions.sh
│   ├── python/
│   │   └── invoke-function.py
│   └── powershell/
│       └── deploy-function.ps1
└── cloudformation/
    ├── shell/
    │   └── create-stack.sh
    ├── python/
    │   └── validate-template.py
    └── powershell/
        └── delete-stack.ps1
```

---

### **Steps to Organize Scripts by AWS Service**
1. **Create Directories**:
   - Each service (e.g., EC2, S3, Lambda) gets its directory.
   - Within each service directory, create subdirectories for script types (`shell`, `python`, `powershell`).

   Example:
   ```bash
   mkdir -p ec2/shell ec2/python ec2/powershell
   mkdir -p s3/shell s3/python s3/powershell
   mkdir -p lambda/shell lambda/python lambda/powershell
   mkdir -p cloudformation/shell cloudformation/python cloudformation/powershell
   ```

2. **Place Scripts in Relevant Directories**:
   - **EC2 Examples**:
     - `list-instances.sh` (Shell): Lists all EC2 instances.
     - `start-instances.py` (Python): Starts specific EC2 instances.
     - `stop-instances.ps1` (PowerShell): Stops specific EC2 instances.

   - **S3 Examples**:
     - `list-buckets.sh` (Shell): Lists all S3 buckets.
     - `upload-file.py` (Python): Uploads a file to an S3 bucket.
     - `delete-bucket.ps1` (PowerShell): Deletes an S3 bucket.

---

### **Sample Scripts for Each Service**

#### **EC2 Shell Script (`ec2/shell/list-instances.sh`)**:
```bash
#!/bin/bash
# List all EC2 instances
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output table
```

#### **S3 Python Script (`s3/python/upload-file.py`)**:
```python
import boto3

# Upload a file to an S3 bucket
s3 = boto3.client('s3')
bucket_name = 'my-bucket-name'
file_name = 'path/to/myfile.txt'

s3.upload_file(file_name, bucket_name, 'myfile.txt')
print(f"Uploaded {file_name} to {bucket_name}")
```

#### **Lambda PowerShell Script (`lambda/powershell/deploy-function.ps1`)**:
```powershell
# Deploy a Lambda function
Import-Module AWSPowerShell.NetCore

$FunctionName = "MyLambdaFunction"
$ZipFilePath = "path/to/lambda.zip"
$RoleArn = "arn:aws:iam::123456789012:role/lambda-execution-role"

Publish-LMFunction -FunctionName $FunctionName -ZipFile $ZipFilePath -Handler "lambda_function.lambda_handler" -Runtime "python3.9" -Role $RoleArn
```

---

### **Update README**
Include a section explaining the directory structure:
```markdown
## Directory Structure

- `ec2/`: Scripts for EC2 management.
- `s3/`: Scripts for S3 operations.
- `lambda/`: Scripts for Lambda management.
- `cloudformation/`: Scripts for CloudFormation stack management.

Each directory contains:
- `shell/`: AWS CLI scripts.
- `python/`: Boto3 scripts.
- `powershell/`: AWS PowerShell scripts.
```

---

Let me know if you'd like specific scripts or commands added! 🚀