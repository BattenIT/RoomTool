# Trumba MCP Setup Script (PowerShell Version)
Write-Host "Trumba MCP Setup Script" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges." -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Step 1: Creating bridge directory..." -ForegroundColor Yellow
$bridgeDir = "$env:APPDATA\TrumbaMCP"
if (!(Test-Path $bridgeDir)) {
    New-Item -ItemType Directory -Path $bridgeDir -Force
    Write-Host "✅ Bridge directory created: $bridgeDir" -ForegroundColor Green
} else {
    Write-Host "✅ Bridge directory already exists: $bridgeDir" -ForegroundColor Green
}

Write-Host "Step 2: Creating HTTP bridge script..." -ForegroundColor Yellow
$bridgeScript = @"
const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const { CallToolRequestSchema, ListToolsRequestSchema } = require('@modelcontextprotocol/sdk/types.js');

class TrumbaHttpBridge {
  constructor() {
    this.serverUrl = 'http://4.157.220.208:3000/api';
    this.apiKey = '6f85072b7a861d2d315bc4aba126f2ffee963851611c04e3b52fec4775996d69';
    this.server = new Server(
      { name: 'trumba-registration-mcp-bridge', version: '1.0.0' },
      { capabilities: { tools: { listChanged: true } } }
    );
    this.setupHandlers();
  }

  setupHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      try {
        const response = await fetch(`${this.serverUrl}/tools`, {
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          }
        });
        const tools = await response.json();
        return { tools };
      } catch (error) {
        return { tools: [] };
      }
    });

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      try {
        const response = await fetch(`${this.serverUrl}/call`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            method: request.params.name,
            params: request.params.arguments
          })
        });
        return await response.json();
      } catch (error) {
        return {
          content: [{
            type: 'text',
            text: JSON.stringify({ success: false, error: error.message })
          }]
        };
      }
    });
  }

  async start() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
  }
}

const bridge = new TrumbaHttpBridge();
bridge.start().catch((error) => {
  process.exit(1);
});
"@

$bridgeScript | Out-File -FilePath "$bridgeDir\http-bridge.js" -Encoding UTF8
Write-Host "✅ HTTP bridge script created" -ForegroundColor Green

Write-Host "Step 3: Creating package.json..." -ForegroundColor Yellow
$packageJson = @"
{
  "name": "trumba-mcp-bridge",
  "version": "1.0.0",
  "description": "HTTP bridge for Trumba MCP",
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0"
  }
}
"@

$packageJson | Out-File -FilePath "$bridgeDir\package.json" -Encoding UTF8
Write-Host "✅ package.json created" -ForegroundColor Green

Write-Host "Step 4: Installing Node.js modules..." -ForegroundColor Yellow
Set-Location $bridgeDir
npm install --silent
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Node.js modules installed" -ForegroundColor Green
} else {
    Write-Host "⚠️ Warning: Failed to install Node.js modules" -ForegroundColor Yellow
}

Write-Host "Step 5: Configuring Claude Desktop..." -ForegroundColor Yellow
$claudeDir = "$env:APPDATA\Claude"
if (!(Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force
}

$config = @"
{
  "mcpServers": {
    "trumba-registration": {
      "command": "node",
      "args": [
        "$($bridgeDir.Replace('\', '\\'))\\http-bridge.js"
      ],
      "env": {
        "AZURE_SERVER_URL": "http://4.157.220.208:3000/api",
        "MCP_API_KEY": "6f85072b7a861d2d315bc4aba126f2ffee963851611c04e3b52fec4775996d69"
      }
    }
  }
}
"@

$config | Out-File -FilePath "$claudeDir\claude_desktop_config.json" -Encoding UTF8
Write-Host "✅ Claude Desktop configuration updated" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Setup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Close Claude Desktop completely" -ForegroundColor White
Write-Host "2. Restart Claude Desktop" -ForegroundColor White
Write-Host "3. Open a new conversation" -ForegroundColor White
Write-Host "4. Ask: 'What tools do you have access to?'" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"
