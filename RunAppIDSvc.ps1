# Check if the script is being run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrative privileges. Please run it as an administrator."
    Exit 1
}

# Start the Windows Application Identity service
$serviceName = "AppIDSvc"
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($service -eq $null) {
    Write-Host "The Windows Application Identity service does not exist on this system."
    Exit 1
}

if ($service.Status -eq "Running") {
    Write-Host "The Windows Application Identity service is already running."
    Exit 0
}

Write-Host "Starting the Windows Application Identity service..."
Start-Service -Name $serviceName

# Check if the service started successfully
$service = Get-Service -Name $serviceName
if ($service.Status -eq "Running") {
    Write-Host "The Windows Application Identity service has been started successfully."
    Exit 0
} else {
    Write-Host "Failed to start the Windows Application Identity service."
    Exit 1
}