# RAG Search Interface - Deployment Complete

## ✅ What's Been Deployed

The RAG search interface has been successfully deployed to the TIBStar-Website repository and pushed to GitHub. Netlify will automatically deploy it.

### Files Added:
- `rag/index.html` - RAG search web interface
- `netlify/functions/rag-proxy.js` - Netlify function to proxy API requests
- `netlify.toml` - Configuration for Netlify functions

### Access URLs:
- **tibstar.com** - TIB downloads (unchanged)
- **chatcan.com/rag/** - RAG search interface (NEW)

---

## ⚠️ Setup Required to Complete

The interface is deployed but needs configuration to function. Follow these steps:

### Step 1: Get the RAG API Key from EC2

The API key is stored on your EC2 server. To retrieve it:

```bash
# SSH to EC2
ssh -i ~/.ssh/id_ed25519 user@44.219.6.212

# Display the API key
cat ~/rag-key.txt
```

Copy this API key - you'll need it for Step 2.

**Format**: `RAG_API_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`

### Step 2: Configure Netlify Environment Variables

1. Go to the Netlify dashboard: https://app.netlify.com/sites/tibstar-website/settings/env
2. Click **"Add a variable"**
3. Add these two variables:

| Name | Value |
|------|-------|
| `RAG_API_URL` | `http://44.219.6.212:8081` |
| `RAG_API_KEY` | `<paste-the-key-from-step-1>` |

4. Click **"Save"**
5. Trigger a new deployment (or wait for auto-deploy from git push)

### Step 3: Open AWS Security Group for Port 8081

Currently, port 8081 is blocked by AWS Security Groups, so external connections time out. To fix:

1. Go to **AWS Console** → **EC2** → **Security Groups**
2. Find the security group for your EC2 instance (44.219.6.212)
3. **Add Inbound Rule**:
   - Type: Custom TCP
   - Port: 8081
   - Source: 0.0.0.0/0 (or restrict to specific IPs for extra security)
4. **Save rules**

**Security Note**: The RAG API requires an API key, so even with the port open, unauthorized users cannot access your data.

### Step 4: Test the Deployment

After completing steps 1-3:

1. Visit: **https://chatcan.com/rag/**
2. You may be prompted for a Netlify password (if site protection is enabled)
3. Try searching for something in your chat history
4. Results should appear

---

## 🔧 MCP Configuration for Claude Code

To access the RAG database directly from Claude Code sessions:

**Windows**: Edit `C:\Users\Fanning\.claude\claude_desktop_config.json`
**Mac/Linux**: Edit `~/.claude/claude_desktop_config.json`

Add or update the MCP servers section:

```json
{
  "mcpServers": {
    "openai-chat-rag": {
      "command": "python3",
      "args": ["C:/Projects/openai-rag/mcp_server.py"],
      "env": {
        "RAG_API_URL": "http://44.219.6.212:8081",
        "RAG_API_KEY": "<paste-your-api-key-here>",
        "OPENAI_API_KEY": "<your-openai-key>"
      }
    }
  }
}
```

**After updating**, restart Claude Code for changes to take effect.

---

## 🎯 Architecture Summary

```
┌─────────────────────────────────────────────────────────┐
│                  ACCESS PATHS                            │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. Web Interface (Humans)                              │
│     https://chatcan.com/rag/                            │
│     ↓ Netlify password (if enabled)                     │
│     ↓ Netlify function (adds API key automatically)     │
│     → EC2:8081 /api/search (authenticated)              │
│                                                          │
│  2. Claude Code MCP (AI Agent)                          │
│     Local MCP server                                     │
│     ↓ API key in config                                 │
│     → EC2:8081 /api/search (authenticated)              │
│                                                          │
│  3. Direct API (Other Clients)                          │
│     http://44.219.6.212:8081/api/search                 │
│     + Header: X-API-Key: ********                       │
│     → EC2:8081 /api/search (authenticated)              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 Current Status

| Component | Status | Notes |
|-----------|--------|-------|
| RAG API Server | ✅ Running | EC2:8081, secured with API key |
| PM2 Management | ✅ Active | Auto-restart enabled |
| Web Interface | ✅ Deployed | chatcan.com/rag/ (needs env vars) |
| Netlify Function | ✅ Deployed | Proxy ready (needs env vars) |
| AWS Security Group | ⚠️ **BLOCKED** | Port 8081 needs to be opened |
| Netlify Env Vars | ⚠️ **PENDING** | Need to be set manually |
| MCP Configuration | ⚠️ **PENDING** | Need to configure locally |

---

## 🔐 Security Features

- ✅ API key authentication (256-bit secure random key)
- ✅ CORS restrictions (only allows chatcan.com origin)
- ✅ Netlify password protection (optional, for web interface)
- ✅ PM2 process management (auto-restart, logging)
- ⚠️ AWS Security Group (currently blocking all external traffic)

---

## 🐛 Troubleshooting

### Web Interface Shows "Unauthorized" Error
- Check that environment variables are set in Netlify
- Verify the API key matches what's on EC2: `cat ~/rag-key.txt`
- Check Netlify function logs in dashboard

### Connection Timeout
- Verify AWS Security Group allows port 8081
- Test locally on EC2: `curl http://localhost:8081/api/stats`
- Check service is running: `pm2 list`

### MCP Not Working in Claude Code
- Restart Claude Code after config changes
- Check API key is correct in config file
- Verify EC2 service is accessible: `curl http://44.219.6.212:8081/api/stats`

### No Results Returned
- Check that ChromaDB has data: SSH to EC2 and check `~/openai-rag/chroma_db/`
- Check PM2 logs: `pm2 logs openai-rag`
- Verify search query is valid

---

## 📝 Next Steps

1. ☐ Get API key from EC2 (`cat ~/rag-key.txt`)
2. ☐ Set Netlify environment variables
3. ☐ Open AWS Security Group port 8081
4. ☐ Test web interface at https://chatcan.com/rag/
5. ☐ Configure MCP in Claude Code
6. ☐ Test MCP access from Claude Code session

---

**Deployment Date**: 2026-01-10
**Repository**: https://github.com/fanning/TIBStar-Website
**Netlify Site**: https://app.netlify.com/sites/tibstar-website

