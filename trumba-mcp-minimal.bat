@echo off
REM Minimal Trumba MCP Setup Script
REM This version skips Claude detection and focuses on MCP setup

echo Setting up Trumba MCP...

REM Create bridge directory
set BRIDGE_DIR=%APPDATA%\TrumbaMCP
if not exist "%BRIDGE_DIR%" mkdir "%BRIDGE_DIR%"

REM Create HTTP bridge script
(
echo const { Server } = require('@modelcontextprotocol/sdk/server/index.js'^);
echo const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js'^);
echo const { CallToolRequestSchema, ListToolsRequestSchema } = require('@modelcontextprotocol/sdk/types.js'^);
echo.
echo class TrumbaHttpBridge {
echo   constructor(^) {
echo     this.serverUrl = 'http://4.157.220.208:3000/api';
echo     this.apiKey = '6f85072b7a861d2d315bc4aba126f2ffee963851611c04e3b52fec4775996d69';
echo     this.server = new Server({ name: 'trumba-registration-mcp-bridge', version: '1.0.0' }, { capabilities: { tools: { listChanged: true } } }^);
echo     this.setupHandlers(^);
echo   }
echo   setupHandlers(^) {
echo     this.server.setRequestHandler(ListToolsRequestSchema, async (^) =^> {
echo       try {
echo         const response = await fetch(`${this.serverUrl}/tools`, { headers: { 'Authorization': `Bearer ${this.apiKey}`, 'Content-Type': 'application/json' } }^);
echo         const tools = await response.json(^);
echo         return { tools };
echo       } catch (error^) {
echo         return { tools: [] };
echo       }
echo     }^);
echo     this.server.setRequestHandler(CallToolRequestSchema, async (request^) =^> {
echo       try {
echo         const response = await fetch(`${this.serverUrl}/call`, { method: 'POST', headers: { 'Authorization': `Bearer ${this.apiKey}`, 'Content-Type': 'application/json' }, body: JSON.stringify({ method: request.params.name, params: request.params.arguments }^) }^);
echo         return await response.json(^);
echo       } catch (error^) {
echo         return { content: [{ type: 'text', text: JSON.stringify({ success: false, error: error.message }^) }] };
echo       }
echo     }^);
echo   }
echo   async start(^) {
echo     const transport = new StdioServerTransport(^);
echo     await this.server.connect(transport^);
echo   }
echo }
echo const bridge = new TrumbaHttpBridge(^);
echo bridge.start(^).catch((error^) =^> { process.exit(1^); }^);
) > "%BRIDGE_DIR%\http-bridge.js"

REM Create package.json
(
echo { "name": "trumba-mcp-bridge", "version": "1.0.0", "dependencies": { "@modelcontextprotocol/sdk": "^1.0.0" } }
) > "%BRIDGE_DIR%\package.json"

REM Install dependencies
cd /d "%BRIDGE_DIR%"
npm install --silent

REM Configure Claude Desktop
if not exist "%APPDATA%\Claude" mkdir "%APPDATA%\Claude"
(
echo { "mcpServers": { "trumba-registration": { "command": "node", "args": ["%BRIDGE_DIR:\=\\%\\http-bridge.js"], "env": { "AZURE_SERVER_URL": "http://4.157.220.208:3000/api", "MCP_API_KEY": "6f85072b7a861d2d315bc4aba126f2ffee963851611c04e3b52fec4775996d69" } } } }
) > "%APPDATA%\Claude\claude_desktop_config.json"

echo Setup complete! Restart Claude Desktop to use the MCP tools.
pause
