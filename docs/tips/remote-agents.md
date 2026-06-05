# Claude Code Remote Agents — Architecture Overview

## 1. Where It Runs
Anthropic's cloud infrastructure (CCR — Claude Code Remote). Not your local machine, not GitHub Actions. A fully isolated, ephemeral container spun up per run.

## 2. What It Is
A Claude model instance with tools, running a task autonomously from start to finish, then shutting down. No persistent state between runs — every run starts cold.

## 3. How It's Programmed
Entirely via a **prompt** — the `events[].message.content` field you write at creation time. That prompt IS the agent's instructions. The agent starts with zero context from your local conversations, so prompts must be fully self-contained.

## 4. What It Can Access
| Resource | How |
|----------|-----|
| Code / files | Git repos cloned fresh each run (`sources` field) |
| External services | MCP connectors (Google Drive, Calendar, Gmail, Slack, etc.) — cloud OAuth |
| Shell tools | Bash, Read, Write, Edit, Glob, Grep — configurable per routine |

## 5. What It Cannot Access
- Your local machine, local files, or local environment variables
- Locally-installed CLIs (e.g. `gws`, `gh`) or their stored credentials
- Anything not explicitly provided via a git repo or MCP connector

## 6. How It's Triggered
- **Recurring:** cron expression (always UTC) — minimum interval 1 hour
- **One-shot:** `run_once_at` RFC3339 UTC timestamp
- Managed via `RemoteTrigger` API or the web UI at `claude.ai/code/routines`

## 7. The Auth Gap — Why Local CLIs Won't Work Remotely
Tools like `gws` authenticate via OAuth tokens stored on your local machine. The remote agent has no access to those. To give a remote agent Gmail access you need either:
- A **Gmail MCP connector** (cloud OAuth, set up at `claude.ai/customize/connectors`)
- Or run the task **locally** (Windows Task Scheduler, etc.) where credentials already exist

## 8. Scheduling an Agent (quick reference)
```json
{
  "name": "My Routine",
  "cron_expression": "0 9 * * 1",
  "enabled": true,
  "job_config": {
    "ccr": {
      "environment_id": "env_01CfY9LiyxfPpD4aR2R1u6jK",
      "session_context": {
        "model": "claude-sonnet-4-6",
        "sources": [{"git_repository": {"url": "https://github.com/user/repo"}}],
        "allowed_tools": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
      },
      "events": [{"data": {
        "uuid": "<lowercase-v4-uuid>",
        "session_id": "",
        "type": "user",
        "parent_tool_use_id": null,
        "message": {"role": "user", "content": "YOUR PROMPT HERE"}
      }}]
    }
  }
}
```

## 9. MCP Connectors (this project)
| Service | Connector UUID |
|---------|---------------|
| Google Drive | `73c92321-67ad-4283-a9e4-046e31914b7b` |
| Google Calendar | `8ff27405-661a-4307-afc6-6584797dcc46` |

Add Gmail at: `claude.ai/customize/connectors`
