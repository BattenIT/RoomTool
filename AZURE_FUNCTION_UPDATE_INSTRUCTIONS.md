# Azure Function Update Instructions - Student Lounge 206

## 🎯 Goal
Update the Azure Function to support Student Lounge 206 calendar data for the Room Dashboard.

## 📋 What This Will Fix
Currently, Student Lounge 206 appears on the live website but shows no calendar events because the Azure Function doesn't recognize the room ID `"studentlounge206"`.

## 🔧 Step-by-Step Instructions

### Step 1: Access Azure Portal
1. Go to [portal.azure.com](https://portal.azure.com)
2. Sign in with your Azure administrator account
3. In the search bar at the top, type `roomtool-calendar-function`
4. Click on the Function App when it appears in results

### Step 2: Find the Function Code
1. In the left sidebar, click **"Functions"**
2. Look for a function named **"getcalendar"** and click on it
3. In the left sidebar under "Developer", click **"Code + Test"**
4. You should see JavaScript code that handles calendar requests

### Step 3: Locate the Room Mappings
Look for a section in the code that has room ID mappings. It will look something like this:
```javascript
const roomMappings = {
    "confa": "https://outlook.office365.com/owa/calendar/...",
    "greathall": "https://outlook.office365.com/owa/calendar/...",
    "seminar": "https://outlook.office365.com/owa/calendar/...",
    // ... other rooms
};
```

### Step 4: Add Student Lounge 206 Mapping
**Add this line** to the room mappings section:
```javascript
"studentlounge206": "https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/05f41146b7274347a5e374b91f0e7eda6953039659626971784/calendar.ics",
```

**Important:** Make sure to add a comma after the previous line and place this new line before the closing `}`

### Step 5: Save the Changes
1. Click **"Save"** at the top of the code editor
2. Wait for the success message that says "Successfully saved"

### Step 6: Test the Function
1. Click the **"Test/Run"** button at the top
2. In the test panel, set:
   - **Method**: GET
   - **Query parameters**: Add `roomId` with value `studentlounge206`
3. Click **"Run"**
4. You should see calendar data returned (not an error)

### Step 7: Verify on Live Site
1. Go to the live website: [https://nice-dune-0d695b810.2.azurestaticapps.net/](https://nice-dune-0d695b810.2.azurestaticapps.net/)
2. Look for "Student Lounge 206" under Garrett Hall
3. Check if calendar events now appear for that room
4. You may need to wait 2-3 minutes for the changes to take effect

## 🆘 Troubleshooting

### If you can't find the Function App:
- Try searching for "Function App" in Azure Portal
- Look for any function apps related to "roomtool" or "calendar"

### If the code looks different:
- The room mappings might be in a different format
- Look for any object or variable that contains calendar URLs
- The Student Lounge URL should be added wherever you see the other room URLs

### If you get permission errors:
- Make sure you have "Contributor" or "Function App Contributor" role
- Contact Azure administrator to grant necessary permissions

### If the test fails:
- Double-check the URL was copied exactly (it's very long)
- Ensure there's a comma after the previous line
- Make sure the closing `}` is still there

## 📞 Contact Information
If you encounter any issues, the specific calendar URL that needs to be added is:
```
https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/05f41146b7274347a5e374b91f0e7eda6953039659626971784/calendar.ics
```

## ✅ Success Criteria
After completing these steps:
- Student Lounge 206 appears on the website ✅ (Already working)
- Student Lounge 206 shows actual calendar events ⏳ (This update will fix)
- No errors in browser console for Student Lounge 206

---
**Estimated Time**: 5-10 minutes
**Technical Level**: Beginner (copy/paste operation)