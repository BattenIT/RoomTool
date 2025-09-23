# PowerShell script to update Azure Function with Student Lounge 206
# This adds the studentlounge206 room mapping to the Azure Function

Write-Host "🔧 Azure Function Update Script"
Write-Host "Adding Student Lounge 206 to room mappings..."

# Function App details
$functionAppName = "roomtool-calendar-function"
$resourceGroupName = "roomtool"  # You may need to adjust this
$subscriptionId = ""  # You'll need to provide this

# Check if user is logged in
Write-Host "⚠️  Important: You need to be logged in to Azure first!"
Write-Host "Run this command first: az login"
Write-Host ""

# Show the room mapping that needs to be added
Write-Host "📋 Room mapping to add:"
Write-Host '  "studentlounge206": "https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/05f41146b7274347a5e374b91f0e7eda6953039659626971784/calendar.ics"'
Write-Host ""

Write-Host "🔍 Next steps:"
Write-Host "1. Install Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
Write-Host "2. Run: az login"
Write-Host "3. Find your function: az functionapp list --query '[].{name:name, resourceGroup:resourceGroup}'"
Write-Host "4. Get function code: az functionapp function show --name $functionAppName --function-name getcalendar --resource-group <your-resource-group>"
Write-Host "5. Update the room mappings object to include the studentlounge206 entry"

Write-Host ""
Write-Host "💡 Alternative: Use Azure Portal"
Write-Host "1. Go to portal.azure.com"
Write-Host "2. Find '$functionAppName' Function App"
Write-Host "3. Go to Functions > getcalendar > Code + Test"
Write-Host "4. Add the room mapping and save"

Write-Host ""
Write-Host "🎯 The exact URL to add:"
Write-Host "https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/05f41146b7274347a5e374b91f0e7eda6953039659626971784/calendar.ics"