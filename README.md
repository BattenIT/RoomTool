# UVA Batten School Room Dashboard

A real-time room scheduling and availability dashboard for the UVA Batten School that displays calendar events and room availability across multiple buildings.

## 🎯 Features

- **Real-time room availability** - Shows current status of all tracked rooms (Available/Busy/Partial)
- **Calendar integration** - Syncs with Outlook/Exchange calendars via ICS feeds
- **Multiple views** - Day, week, and month calendar views
- **Room search** - Find available rooms by time, duration, and capacity
- **Event details** - Click events to see full details and locations
- **Responsive design** - Works on desktop, tablet, and mobile
- **Building organization** - Rooms grouped by building/location
- **External calendar support** - Integrates with Batten School Events calendar

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd RoomTool
   ```

2. **Start the development server**

   **Option A: Node.js Server (Recommended)**
   ```bash
   node server.js
   ```

   **Option B: Python Server**
   ```bash
   python serve.py
   ```

3. **Open your browser**
   Navigate to `http://localhost:8000`

### Why Use a Local Server?

The dashboard requires a local server to handle CORS (Cross-Origin Resource Sharing) issues when fetching Outlook calendar data. The server includes a calendar proxy that:
- Adds proper headers for Outlook/Office 365 calendar requests
- Handles authentication and CORS restrictions
- Provides a consistent interface for calendar data

## 🏢 Building Layout

### Garrett Hall
- **Conference Room A L014** - Meeting room with AV equipment
- **Great Hall 100** - Large presentation space
- **Seminar Room L039** - Small group discussions
- **Student Lounge 206** - Informal meeting and lounge space ✨ *Recently Added*

### Pavilion X
- **Upper Garden** - Outdoor/covered event space
- **Basement Room 1** - Multi-purpose room
- **Basement Room 2** - Multi-purpose room
- **Basement Exhibit** - Display and presentation space

## ⚙️ Configuration

### Local Development vs Azure Deployment

The configuration supports both local development and Azure deployment:

**Local Development:**
- Uses direct Outlook calendar URLs
- Azure Function URL is commented out
- Calendar proxy handles CORS issues

**Azure Deployment:**
- Uses Azure Function for cached calendar data
- Room IDs instead of direct URLs
- Built-in CORS handling

### config.js Structure

```javascript
window.DashboardConfig = {
    // Azure Function (comment out for local dev)
    azureFunctionUrl: "https://roomtool-calendar-function.azurewebsites.net/api/getcalendar",

    // Building and room organization
    buildings: [
        {
            name: "Garrett Hall",
            id: "garrett",
            rooms: [
                {
                    name: "Student Lounge 206",
                    id: "studentlounge206",
                    icsFile: "https://outlook.office365.com/owa/calendar/..." // Direct URL for local
                    // For Azure: icsFile: "studentlounge206" (room ID)
                }
            ]
        }
    ],

    // External calendars
    eventCalendars: [
        {
            name: "Batten School Events",
            url: "https://www.trumba.com/calendars/batten-school-events.ics",
            roomMappings: { /* ... */ }
        }
    ]
};
```

## 🔧 Recent Changes

### Student Lounge 206 Integration
- ✅ Added Student Lounge 206 to Garrett Hall section
- ✅ Integrated calendar: `https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/...`
- ✅ Updated room mappings for proper event display
- ✅ Tested calendar data loading (169,463 bytes of events)

### Local Development Setup
- ✅ Downloaded actual source files from GitHub repository
- ✅ Created Node.js calendar proxy server to handle CORS
- ✅ Updated all room configurations with direct calendar URLs
- ✅ Maintains compatibility with Azure deployment

## 🏗️ Architecture

- **Frontend**: Vanilla JavaScript with modern CSS (Grid/Flexbox)
- **Calendar Parsing**: Custom ICS parser with timezone support
- **Development Server**: Node.js with calendar proxy
- **Production**: Azure Static Web Apps with Azure Functions
- **Data Sources**: Outlook/Exchange ICS feeds, Trumba events

## 📂 File Structure

```
RoomTool/
├── index.html              # Main dashboard interface
├── config.js               # Room and calendar configuration
├── dashboard.js             # Main dashboard logic (from GitHub)
├── room-dashboard.js        # Alternative dashboard (local copy)
├── ics-parser.js           # ICS calendar parsing utility
├── styles.css              # Dashboard styling
├── server.js               # Node.js development server with proxy
├── serve.py                # Python development server
├── calendar-proxy.php      # PHP calendar proxy (for reference)
└── README.md               # This documentation
```

## 🌐 Deployment

### To Azure Static Web Apps

1. **Update configuration for Azure**
   ```javascript
   // Uncomment in config.js
   azureFunctionUrl: "https://roomtool-calendar-function.azurewebsites.net/api/getcalendar",

   // Change room configurations to use IDs instead of URLs
   icsFile: "studentlounge206"  // Instead of full URL
   ```

2. **Deploy files**
   - Upload updated files to Azure Static Web Apps
   - Ensure Azure Function is running for calendar data

### Adding New Rooms/Buildings

1. **Add to config.js**
   ```javascript
   {
       name: "New Building",
       id: "newbuilding",
       rooms: [
           {
               name: "New Room",
               id: "newroom",
               icsFile: "https://outlook.office365.com/owa/calendar/..." // For local
               // icsFile: "newroom" // For Azure
           }
       ]
   }
   ```

2. **Update room mappings** in eventCalendars section
3. **Test locally** with `node server.js`
4. **Commit changes** and deploy

## 🐛 Troubleshooting

### Calendar Data Not Loading
- ✅ **CORS Issues**: Use local server (`node server.js`) instead of opening HTML directly
- ✅ **Calendar URLs**: Verify Outlook calendar URLs are public and accessible
- ✅ **Proxy Errors**: Check browser console for calendar proxy error messages

### Events Not Displaying
- ✅ **Date Range**: Navigate to correct dates (events may be in future)
- ✅ **Room Mappings**: Verify room names match between calendar events and config
- ✅ **Calendar Permissions**: Ensure calendar URLs are publicly accessible

### Local Server Issues
- ✅ **Port Conflicts**: Server runs on port 8000, ensure it's available
- ✅ **Node.js**: Verify Node.js is installed (`node --version`)
- ✅ **Firewall**: Check firewall settings for localhost:8000

## 📝 Contributing

1. **Make changes locally**
   - Test with `node server.js`
   - Verify calendar data loads correctly

2. **Update documentation**
   - Update this README for any configuration changes
   - Document new rooms/buildings added

3. **Test deployment**
   - Test locally first
   - Update Azure configuration as needed

4. **Commit and deploy**
   ```bash
   git add .
   git commit -m "Description of changes"
   # Deploy to Azure Static Web Apps
   ```

## 📧 Support

For issues or questions:
- Check browser console for error messages
- Verify calendar URLs are accessible
- Test with local development server first
- Review configuration in `config.js`

## 📄 License

MIT License - see LICENSE file for details

---

**Last Updated**: September 23, 2025
**Local Development Setup**: ✅ Complete
**Student Lounge 206 Integration**: ✅ Complete
**Azure Deployment Ready**: ✅ Yes# Student Lounge 206 - Deployment Ready
