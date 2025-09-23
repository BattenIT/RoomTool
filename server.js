const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = 8000;

const mimeTypes = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.css': 'text/css',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.wav': 'audio/wav',
    '.mp4': 'video/mp4',
    '.woff': 'application/font-woff',
    '.ttf': 'application/font-ttf',
    '.eot': 'application/vnd.ms-fontobject',
    '.otf': 'application/font-otf',
    '.wasm': 'application/wasm'
};

// Calendar proxy function
const proxyCalendar = (calendarUrl, res) => {
    console.log(`📅 Proxying calendar: ${calendarUrl}`);

    const options = {
        headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'text/calendar,application/calendar,text/plain,*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache'
        },
        timeout: 30000
    };

    https.get(calendarUrl, options, (proxyRes) => {
        console.log(`📊 Calendar response status: ${proxyRes.statusCode}`);

        if (proxyRes.statusCode !== 200) {
            res.writeHead(proxyRes.statusCode, {
                'Content-Type': 'text/plain',
                'Access-Control-Allow-Origin': '*'
            });
            res.end(`HTTP Error ${proxyRes.statusCode}: Failed to fetch calendar data`);
            return;
        }

        let data = '';
        proxyRes.on('data', (chunk) => {
            data += chunk;
        });

        proxyRes.on('end', () => {
            console.log(`✅ Calendar data received: ${data.length} bytes`);
            res.writeHead(200, {
                'Content-Type': 'text/plain; charset=utf-8',
                'Access-Control-Allow-Origin': '*',
                'Content-Length': Buffer.byteLength(data, 'utf8')
            });
            res.end(data);
        });
    }).on('error', (err) => {
        console.error(`❌ Calendar proxy error: ${err.message}`);
        res.writeHead(500, {
            'Content-Type': 'text/plain',
            'Access-Control-Allow-Origin': '*'
        });
        res.end(`Calendar proxy error: ${err.message}`);
    });
};

const server = http.createServer((req, res) => {
    // Add CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    const parsedUrl = url.parse(req.url, true);
    let pathname = parsedUrl.pathname;

    // Handle calendar proxy requests
    if (pathname === '/calendar-proxy.php') {
        const calendarUrl = parsedUrl.query.url;
        if (!calendarUrl) {
            res.writeHead(400, { 'Content-Type': 'text/plain' });
            res.end('Error: No URL parameter provided');
            return;
        }
        proxyCalendar(calendarUrl, res);
        return;
    }

    // Default to index.html if root path
    if (pathname === '/') {
        pathname = '/index.html';
    }

    const filePath = path.join(__dirname, pathname);
    const extname = path.extname(filePath).toLowerCase();
    const contentType = mimeTypes[extname] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                res.writeHead(404, { 'Content-Type': 'text/html' });
                res.end('<h1>404 Not Found</h1>', 'utf-8');
            } else {
                res.writeHead(500);
                res.end(`Server Error: ${error.code}`, 'utf-8');
            }
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
});

server.listen(PORT, () => {
    console.log(`🚀 Room Dashboard Server`);
    console.log(`📂 Serving directory: ${__dirname}`);
    console.log(`🌐 Server running at: http://localhost:${PORT}`);
    console.log(`📋 Dashboard available at: http://localhost:${PORT}/index.html`);
    console.log(`💡 Use Ctrl+C to stop the server`);

    // Try to open in browser
    const { exec } = require('child_process');
    exec(`start http://localhost:${PORT}/index.html`, (error) => {
        if (error) {
            console.log(`⚠️  Could not auto-open browser. Please visit http://localhost:${PORT}/index.html manually.`);
        } else {
            console.log(`🌐 Opened dashboard in your default browser`);
        }
    });
});