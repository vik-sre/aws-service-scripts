# Example: List all Lambda functions
Import-Module AWSPowerShell.NetCore
Get-LMFunctionList | Select-Object FunctionName, Runtime, LastModified
