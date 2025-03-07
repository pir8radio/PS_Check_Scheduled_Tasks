# PS_Check_Scheduled_Tasks

## Overview

This PowerShell script monitors Windows scheduled tasks in a specified folder. If the last run of the scheduled tasks meets your defined threshold, it sends a **"down"** or **"up"** webhook to [InStatus.com](https://instatus.com). The script only sends a webhook when the state changes to avoid duplicate notifications, making it suitable for running on a schedule.

This script is particularly useful for tasks like monitoring **AirExplorer backup tasks** and getting alerts if a task fails.

## Features

- Checks scheduled tasks in any specified folder.
- Sends **"up"** or **"down"** webhooks to InStatus.com based on task status.
- Avoids sending duplicate webhooks unless the status changes.
- Fully customizable webhook payload and URL for integration with other services (e.g., Discord).

## Usage Instructions

1. **Download** the PowerShell script.
2. Configure the script by specifying:
   - The Windows scheduled tasks folder to monitor.
   - The threshold for task status.
   - Webhook URL and payload (optional for custom integrations).
3. Run the script on a schedule to monitor task status and receive alerts.

## Customization

You can modify the script to:

- Change the webhook payload or URL.
- Integrate it with other tools like a Discord channel.

This flexibility allows you to adapt the script to suit your needs. Happy monitoring!
