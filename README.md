# PS_Check_Scheduled_Tasks
This Powershell script will check whatever windows scheduled tasks folder you wish and if the last run of the scheduled tasks in that folder meets your threshold it will send either a "down" or "up" webhook to InStatus.com  If the status has not changed since the last run it will not send another of the same webhook state, only if the state changes will is send a webhook to your instatus.com page. This is so you can run this script on a schedule.  I use this to monitor my AirExplorer backup tasks and alert me if the task fails. 

You can Modify this script and change the payload of the webhook, or webhook url to have it post to other things like a Discord channel. 
