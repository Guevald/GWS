# GWS Setup Guide

Google Workspace CLI integration for Claude Code.  
Repo: https://github.com/Guevald/GWS

> **Binaries not included** — `gws.exe` and `google-cloud-cli` installers are stored separately (not in this repo). Copy them from another machine or download fresh (see steps below).

---

## 1. Install gws CLI

Download the latest Windows binary from:
```
https://github.com/googleworkspace/cli/releases
```

Extract the zip and add the binary folder to your PATH:

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

Download:
```
https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-windows-x86_64.zip
```

Extract, then run:
```powershell
& "<extract-path>\google-cloud-sdk\install.bat" --quiet --path-update=true --usage-reporting=false
```

Verify:
```powershell
gcloud --version
```

---

## 3. Auth Setup

### Automated (recommended)
```powershell
gws auth setup    # creates GCP project + OAuth credentials automatically
gws auth login    # opens browser — sign in and allow access
```

### Manual (if gws auth setup fails)
1. Go to https://console.cloud.google.com → New Project
2. Enable APIs: Gmail, Calendar, Drive, Keep, Tasks, Sheets, Docs, Slides, Chat
3. APIs & Services → OAuth consent screen → External → add `igal.pivin@gmail.com` as Test user
4. APIs & Services → Credentials → Create OAuth client ID → Desktop app
5. Download JSON → save to `C:\Users\ipivi\.config\gws\client_secret.json`
6. Run `gws auth login`

### Credentials location (Windows)
```
$env:USERPROFILE\.config\gws\client_secret.json   ← OAuth client
$env:USERPROFILE\.config\gws\credentials.enc      ← encrypted token (written after login)
$env:USERPROFILE\.config\gws\token_cache.json     ← access token cache
```

### Transferring credentials to a new machine

The `client_secret.json` is the only file you need to copy — `credentials.enc` and the token cache are regenerated after login.

**Option A — copy from an existing machine:**
```powershell
# On the source machine, find the file at:
#   $env:USERPROFILE\.config\gws\client_secret.json
# Copy it to the same path on the new machine, then:
gws auth login
```

**Option B — re-download from GCP Console (always works):**
1. Go to [console.cloud.google.com](https://console.cloud.google.com) → APIs & Services → Credentials
2. Find the OAuth 2.0 client (`project-f3d4caa3-847d-4d5a-999`) → click the download ↓ icon
3. Save to `$env:USERPROFILE\.config\gws\client_secret.json`
4. Run `gws auth login`

> **Machines set up:** laptop (primary), desktop (WINDOWS11) — both authenticated as igal.pivin@gmail.com

---

## 4. Configure Claude Code Plugin

`~/.claude/settings.json` should contain:

```json
{
  "permissions": {
    "allow": ["PowerShell", "Glob", "Grep", "Read", "WebFetch", "WebSearch", "Bash", "Edit", "Write"]
  },
  "extraKnownMarketplaces": {
    "gws-marketplace": {
      "source": { "source": "github", "repo": "WadeWarren/gws-claude-plugin" }
    }
  },
  "enabledPlugins": {
    "gws@gws-marketplace": true
  }
}
```

---

## 5. Test It

```powershell
gws gmail +triage        # show unread inbox
gws calendar +agenda     # show upcoming events
gws keep +list           # list Keep notes
```

Or ask Claude Code directly:
> "Show me my unread emails"
> "What's on my calendar this week?"

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `No OAuth client configured` | Run `gws auth setup` or manually place `client_secret.json` in `~/.config/gws/` |
| `Access blocked: app not verified` | Add yourself as a Test user in the OAuth consent screen |
| `gws: command not found` | Add binary folder to PATH and restart terminal |
| `gcloud: command not found` | Add gcloud bin folder to PATH and restart terminal |
| `401 Unauthorized` | Run `gws auth login` |
| `403 Insufficient Permission` (even though auth status shows correct scopes) | Stale token cache — delete `~/.config/gws/token_cache.json` and retry |

---

## Google Keep

The Keep API (`https://www.googleapis.com/auth/keep`) is restricted to verified/enterprise apps — it cannot be used with a personal OAuth setup. Two alternatives to explore later:

1. **Google Takeout export** — go to takeout.google.com, select Keep only, export. You get a zip of `.html` files (one per note) plus a JSON index. Easy to parse into Excel or SQL Server with Python or SSIS.
2. **Third-party connectors** — IFTTT and Make (Integromat) have pre-verified Keep integrations if automation is needed.

---

## References
- gws CLI releases: https://github.com/googleworkspace/cli/releases
- gws Claude plugin: https://github.com/WadeWarren/gws-claude-plugin
- GCP Console: https://console.cloud.google.com
- This repo: https://github.com/Guevald/GWS
- Docs & tips: see `docs/` folder
