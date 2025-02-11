# Define the webhook URL
$webhookUrl = "https://api.instatus.com/v3/integrations/webhook/*****************"

# Define the threshold for LastTaskResult example: "lt 3" or "eq 0" and task considered Successful
# lt=less-than, gt=greater-than, eq=equal, ge=greater-than or equal, le=less-than or equal
$threshold = "eq 0"

# Define the file to store the last state, create a "temp" folder on your C drive or change this to whatever you want
$stateFile = "C:\temp\ScheduledTaskState.txt"

# Function to get the status of scheduled tasks in the "AirExplorer" folder.
function Get-ScheduledTaskStatus {
    $tasks = Get-ScheduledTask -TaskPath "\AirExplorer\"    # Change to \Whatever You Want\
    
    Write-Host "Scheduled Tasks Status:"
    $allTasksSuccess = $true
    foreach ($task in $tasks) {
        $taskInfo = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath
        $thresholdParts = $threshold.Split(" ")
        $operator = $thresholdParts[0]
        $value = [int]$thresholdParts[1]

        $status = switch ($operator) {
            "lt" { if ($taskInfo.LastTaskResult -lt $value) { "Success" } else { $allTasksSuccess = $false; "Failed" } }
            "gt" { if ($taskInfo.LastTaskResult -gt $value) { "Success" } else { $allTasksSuccess = $false; "Failed" } }
            "eq" { if ($taskInfo.LastTaskResult -eq $value) { "Success" } else { $allTasksSuccess = $false; "Failed" } }
            "ge" { if ($taskInfo.LastTaskResult -ge $value) { "Success" } else { $allTasksSuccess = $false; "Failed" } }
            "le" { if ($taskInfo.LastTaskResult -le $value) { "Success" } else { $allTasksSuccess = $false; "Failed" } }
            default { "Invalid operator" }
        }
        Write-Host "Task: $($task.TaskName) - LastRunTime: $($taskInfo.LastRunTime) - LastTaskResult: $($taskInfo.LastTaskResult) - Status: $status"
    }
    
    return $allTasksSuccess
}

# Function to send a webhook notification
function Send-WebhookNotification {
    param (
        [string]$url,
        [string]$trigger
    )
    $payload = @{
        trigger = $trigger
    } | ConvertTo-Json -Depth 1
    $headers = @{
        "Content-Type" = "application/json"
    }
    Write-Host "Sending webhook notification..." -ForegroundColor Green
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $payload -Headers $headers -ErrorAction Stop
    Write-Host "Webhook response: $response"
}

# Check if the state file exists, if not create it with "up" state
if (-not (Test-Path $stateFile)) {
    "up" | Out-File $stateFile
}

# Get the last state from the state file
$lastStatus = (Get-Content $stateFile -Raw).Trim()

# Get the current state of scheduled tasks
$currentStatus = if (Get-ScheduledTaskStatus) { "up" } else { "down" } 
$currentStatus = $currentStatus.Trim()

# Write the status to the console
if ($currentStatus -eq "up") {
    Write-Host "All scheduled tasks ran successfully" -ForegroundColor Green
} else {
    Write-Host "One or more scheduled tasks have failed." -ForegroundColor Red
}

# Compare the current state with the last state in the temp file
if ($currentStatus -ne $lastStatus) {
    Write-Host "State has changed. Sending webhook notification..." -ForegroundColor Green
    Send-WebhookNotification -url $webhookUrl -trigger $currentStatus

    # Update the state file with the current state
    $currentStatus | Out-File $stateFile
    Write-Host "State file updated with new status: $currentStatus"
} else {
    Write-Host "No state change detected. Webhook notification not sent." -ForegroundColor Yellow
}
# Small delay so user can see the console output
Start-Sleep -Seconds 3
