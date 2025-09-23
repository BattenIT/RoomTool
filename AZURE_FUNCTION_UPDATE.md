# Azure Function Update for Student Lounge 206

## 📋 Overview
To deploy the Student Lounge 206 integration to the live Azure site, the Azure Function needs to be updated to recognize the new room ID `"studentlounge206"`.

## 🔧 Required Changes

### Azure Function Location
**Function URL**: `https://roomtool-calendar-function.azurewebsites.net/api/getcalendar`

### Add New Room Mapping

The Azure Function needs to add a mapping for:
- **Room ID**: `"studentlounge206"`
- **Calendar URL**: `https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/05f41146b7274347a5e374b91f0e7eda6953039659626971784/calendar.ics`

### Example Code Addition

If your Azure Function uses a mapping object, add this entry:

```javascript
// In your Azure Function room mappings
const roomMappings = {
    "confa": "https://outlook.office365.com/owa/calendar/4207f27aa0d54d318d660537325a3856@virginia.edu/64228c013c3c425ca3ec6682642a970e8523251041637520167/calendar.ics",
    "greathall": "https://outlook.office365.com/owa/calendar/cf706332e50c45009e2b3164e0b68ca0@virginia.edu/6960c19164584f9cbb619329600a490a16019380931273154626/calendar.ics",
    "seminar": "https://outlook.office365.com/owa/calendar/4cedc3f0284648fcbee80dd7f6563bab@virginia.edu/211f4d478ee94feb8fe74fa4ed82a0b22636302730039956374/calendar.ics",

    // NEW ADDITION:
    "studentlounge206": "https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/05f41146b7274347a5e374b91f0e7eda6953039659626971784/calendar.ics",

    "pavx-upper": "https://outlook.office365.com/owa/calendar/52b9b2d41868473fac5d3e9963512a9b@virginia.edu/311e34fd14384759b006ccf185c1db677813060047149602177/calendar.ics",
    "pavx-b1": "https://outlook.office365.com/owa/calendar/fa3ecb9b47824ac0a36733c7212ccc97@virginia.edu/d23afabf93da4fa4b49d2be3ce290f7911116129854936607531/calendar.ics",
    "pavx-b2": "https://outlook.office365.com/owa/calendar/3f60cb3359dd40f7943b9de3b062b18d@virginia.edu/1e78265cf5eb44da903745ca3d872e6910017444746788834359/calendar.ics",
    "pavx-exhibit": "https://outlook.office365.com/owa/calendar/4df4134c83844cef9d9357180ccfb48c@virginia.edu/e46a84ae5d8842d4b33a842ddc5ff66c11207228220277930183/calendar.ics"
};
```

## 🧪 Testing the Azure Function

Once updated, test that the Azure Function works:

```bash
# Test the new Student Lounge 206 endpoint
curl "https://roomtool-calendar-function.azurewebsites.net/api/getcalendar?room=studentlounge206"
```

**Expected Result**: Should return calendar data for Student Lounge 206 (similar to what we tested locally with 169,463 bytes of events).

## 📁 Files Ready for Deployment

Once the Azure Function is updated, deploy these files:

### Main Files:
- `index.html` - Dashboard interface (no changes needed)
- `config-azure.js` → rename to `config.js` - Azure-ready configuration
- `styles.css` - Styling (no changes needed)
- `dashboard.js` - Main logic (no changes needed)
- `ics-parser.js` - Calendar parsing (no changes needed)

### Configuration Changes:
```javascript
// config.js for Azure deployment
window.DashboardConfig = {
    azureFunctionUrl: "https://roomtool-calendar-function.azurewebsites.net/api/getcalendar", // ENABLED
    buildings: [
        {
            name: "Garrett Hall",
            rooms: [
                // ... existing rooms ...
                {
                    name: "Student Lounge 206",
                    id: "studentlounge206",
                    icsFile: "studentlounge206"  // Room ID for Azure Function
                }
            ]
        }
    ]
};
```

## ✅ Deployment Checklist

1. **[ ] Update Azure Function** with `"studentlounge206"` mapping
2. **[ ] Test Azure Function** endpoint returns calendar data
3. **[ ] Replace config.js** with config-azure.js content
4. **[ ] Deploy files** to Azure Static Web Apps
5. **[ ] Test live site** shows Student Lounge 206 in Garrett Hall
6. **[ ] Verify calendar events** load correctly

## 🚨 Rollback Plan

If anything goes wrong:
1. **Azure Function**: Remove the `"studentlounge206"` mapping
2. **Static Web App**: Revert to previous config.js version
3. **Local Development**: Continue using current setup with `node server.js`

## 📞 Support

Calendar URL verified working locally with:
- ✅ 169,463 bytes of calendar data
- ✅ Events showing for January-May 2025
- ✅ Proper room mapping and display

---
**Prepared by**: Claude Code Assistant
**Date**: September 23, 2025
**Status**: Ready for Azure Function Update