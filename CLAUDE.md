# GWS — Google Workspace CLI for Claude Code

## What This Project Is
Personal config, docs, and scripts repo for using the `gws` CLI (googleworkspace/cli) with Claude Code.
The `gws@gws-marketplace` plugin gives Claude Code 90+ skills covering Gmail, Calendar, Drive, Docs,
Sheets, Keep, Chat, Forms, Tasks, Meet, and more.

## Project Structure
```
GWS\
  gws.exe                         — pre-built Windows x86_64 binary (gitignored)
  GWS.md                          — full first-time setup & OAuth guide
  README.md                       — official upstream gws CLI reference docs
  CLAUDE.md                       — this file
  docs\
    email-cleanup-playbook.md     — Gmail label/filter/deletion ruleset
    sessions\                     — dated session logs
    tips\
      gws-gmail.md                — PowerShell command reference for Gmail ops
      remote-agents.md            — Cloud Remote Agent architecture notes
  setup.ps1                       — verify gws/gcloud binaries, show auth instructions; state-tracked one-time reminder
  scripts\
    cleanup-frive.ps1             — monthly: trash old Frive promo emails (Task Scheduler)
```

## Claude Code Plugin
Configured in `~/.claude/settings.json`:
```json
"extraKnownMarketplaces": {
  "gws-marketplace": { "source": { "source": "github", "repo": "WadeWarren/gws-claude-plugin" } }
},
"enabledPlugins": { "gws@gws-marketplace": true }
```

## Key Commands
```powershell
gws auth login        # authenticate / re-authenticate
gws gmail +triage     # show unread inbox summary
gws calendar +agenda  # show upcoming events
gws keep +list        # list Keep notes (limited — Keep API restricted to verified apps)
```

## Credentials (Windows — never commit)
- `$env:USERPROFILE\.config\gws\client_secret.json`  — OAuth client (copy from existing machine or GCP Console)
- `$env:USERPROFILE\.config\gws\credentials.enc`     — encrypted refresh token (written after `gws auth login`)
- `$env:USERPROFILE\.config\gws\token_cache.json`    — cached access token (delete to force refresh)
- Portable backup: `gws-config.zip` (AES256-encrypted, stored in Google Drive)

## First-Time Setup
Run `.\setup.ps1` — verifies binaries, shows auth steps (one-time reminder suppressed after first run).

Short version:
1. Extract zip, add binary folder to PATH
2. Copy `client_secret.json` from an existing machine (or re-download from GCP Console —
   skip `gws auth setup`, the GCP project already exists)
3. Place at `$env:USERPROFILE\.config\gws\client_secret.json`
4. Run `gws auth login` to authenticate

Full details in `GWS.md`.
