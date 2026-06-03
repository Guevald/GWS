# GWS Setup Guide

## 1. Install gws CLI

Extract the zip and add the binary folder to your PATH.

**PowerShell (one-time):**
```powershell
Expand-Archive "google-workspace-cli-x86_64-pc-windows-msvc.zip" -DestinationPath "."
[Environment]::SetEnvironmentVariable(
  "PATH",
  [Environment]::GetEnvironmentVariable("PATH","User") + ";$PWD\google-workspace-cli-x86_64-pc-windows-msvc",
  "User"
)
```

Restart your terminal, then verify:
```powershell
gws --version
```

---

## 2. Install gcloud CLI (required for auth setup)

Download the offline installer:
```
https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-windows-x86_64.zip
```

Extract it, then run:
```powershell
& "<extract-path>\google-cloud-sdk\install.bat" --quiet --path-update=true --usage-reporting=false
```

Add to PATH manually if the installer couldn't:
```powershell
[Environment]::SetEnvironmentVariable(
  "PATH",
  [Environment]::GetEnvironmentVariable("PATH","User") + ";<extract-path>\google-cloud-sdk\bin",
  "User"
)
```

Verify:
```powershell
gcloud --version
```

---

## 3. OAuth Setup — Automated (recommended)

Requires gcloud to be installed and on PATH.

```powershell
gws auth setup
```

This command:
- Creates a new GCP project
- Enables required Google Workspace APIs
- Creates an OAuth Desktop app credential
- Saves `client_secret.json` to `~/.config/gws/`

Then log in:
```powershell
gws auth login
```

---

## 4. OAuth Setup — Manual (if gws auth setup fails)

### Step 1 — Create a GCP project
1. Go to https://console.cloud.google.com
2. Click the project dropdown → **New Project** → give it a name → **Create**

### Step 2 — Enable APIs
In your new project, go to **APIs & Services → Enable APIs** and enable:
- Gmail API
- Google Calendar API
- Google Drive API
- Google Keep API (Google Keep Notes API)
- Google Tasks API
- Google Sheets API
- Google Docs API
- Google Slides API
- Google Chat API

### Step 3 — Configure OAuth consent screen
1. Go to **APIs & Services → OAuth consent screen**
2. Choose **External** → **Create**
3. Fill in App name (e.g. `gws-cli`), support email → **Save and Continue**
4. Skip Scopes → **Save and Continue**
5. Under **Test users** → **Add users** → enter `igal.pivin@gmail.com` → **Save**

### Step 4 — Create OAuth credentials
1. Go to **APIs & Services → Credentials**
2. Click **+ Create Credentials → OAuth client ID**
3. Application type: **Desktop app**
4. Name: `gws-cli-desktop` → **Create**
5. Click **Download JSON** on the new credential
6. Save the file to: `C:\Users\WINDOWS11\.config\gws\client_secret.json`
   (create the `.config\gws\` folder if it doesn't exist)

### Step 5 — Authenticate
```powershell
gws auth login
```
A browser window opens — sign in with igal.pivin@gmail.com and allow access.

---

## 5. Configure Claude Code Plugin

Add to `C:\Users\WINDOWS11\.claude\settings.json`:
```json
"extraKnownMarketplaces": {
  "gws-marketplace": {
    "source": { "source": "github", "repo": "WadeWarren/gws-claude-plugin" }
  }
},
"enabledPlugins": {
  "gws@gws-marketplace": true
}
```

Also add to `permissions.allow`:
```json
"Glob", "Grep", "Read", "WebFetch", "WebSearch"
```

---

## 6. Test It

```powershell
gws gmail +triage        # show unread inbox
gws calendar +agenda     # show upcoming events
gws keep +list           # list Keep notes
```

Or ask Claude Code directly:
> "Show me my unread emails"
> "What's on my calendar this week?"
> "List my Keep notes"

---

## Troubleshooting

| Error | Fix |
|---|---|
| `No OAuth client configured` | Run `gws auth setup` or manually save `client_secret.json` to `~/.config/gws/` |
| `Access blocked: app not verified` | Add yourself as a Test user in OAuth consent screen |
| `gws: command not found` | Add binary folder to PATH and restart terminal |
| `gcloud: command not found` | Add gcloud bin folder to PATH and restart terminal |
| `401 Unauthorized` | Run `gws auth login` to refresh token |

---

## References
- gws CLI source: https://github.com/googleworkspace/cli
- gws Claude plugin: https://github.com/WadeWarren/gws-claude-plugin
- GCP Console: https://console.cloud.google.com
- This repo: https://github.com/Guevald/GWS
