# GWS — Google Workspace CLI for Claude Code

## What This Project Is
Google Workspace integration for Claude Code using the `gws` CLI (googleworkspace/cli).
The `gws` plugin provides 90+ skills covering Gmail, Calendar, Keep, Drive, Docs, Sheets, Chat, Forms, Tasks, Meet, and more.

## Project Structure
```
GWS\
  google-workspace-cli-x86_64-pc-windows-msvc\   — gws CLI binary (Windows x86_64)
  google-workspace-cli-x86_64-pc-windows-msvc.zip — original zip for laptop setup
  CLAUDE.md                                       — this file
  GWS.md                                          — full setup & OAuth guide
```

## Setup (first time on a new machine)
See GWS.md for the full step-by-step guide.

Short version:
1. Extract zip, add binary folder to PATH
2. Install gcloud CLI (needed for `gws auth setup`)
3. Run `gws auth setup` — creates GCP project + OAuth credentials automatically
4. Run `gws auth login` — authenticates with your Google account

## Claude Code Plugin
The `gws@gws-marketplace` plugin is configured in `~/.claude/settings.json`:
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

## Key Commands
```powershell
gws auth setup        # first-time GCP + OAuth setup (requires gcloud)
gws auth login        # authenticate / re-authenticate
gws gmail +triage     # show unread inbox
gws calendar +agenda  # show upcoming events
gws keep +list        # list Keep notes
```

## Credentials Location (Windows)
- OAuth client:  `C:\Users\<user>\.config\gws\client_secret.json`
- Auth token:    `C:\Users\<user>\.config\gws\` (written after gws auth login)

## GitHub Repository
https://github.com/Guevald/GWS
