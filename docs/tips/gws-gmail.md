# gws Gmail — Tips & Gotchas

## Auth

### Stale token cache
If you get `403 ACCESS_TOKEN_SCOPE_INSUFFICIENT` even though `gws auth status` shows the right scopes, the cached access token is stale. Fix:
```powershell
Remove-Item "$env:USERPROFILE\.config\gws\token_cache.json" -Force
```
This forces gws to get a fresh access token from the stored refresh token.

### Re-authenticate from scratch
```powershell
gws auth logout
gws auth login
```

## Labels

```powershell
# List all labels with IDs
gws gmail users labels list --params '{"userId":"me"}'

# Create a label
gws gmail users labels create --params '{"userId":"me"}' --json '{"name":"MyLabel","labelListVisibility":"labelShow","messageListVisibility":"show"}'

# Delete a label
gws gmail users labels delete --params '{"userId":"me","id":"Label_XX"}'
```

## Filters

```powershell
# List all filters
gws gmail users settings filters list --params '{"userId":"me"}'

# Create a filter (apply label + skip inbox)
gws gmail users settings filters create --params '{"userId":"me"}' --json '{
  "criteria": {"from": "sender@example.com"},
  "action": {"addLabelIds": ["Label_XX"], "removeLabelIds": ["INBOX"]}
}'
```

## Bulk Operations

### Find messages
```powershell
# Gmail search syntax works in --params q field
gws gmail users messages list --params '{"userId":"me","q":"from:@linkedin.com in:inbox","maxResults":500}'
```

### Batch label + archive (retroactive filter)
```powershell
gws gmail users messages batchModify --params '{"userId":"me"}' --json '{
  "ids": ["id1","id2",...],
  "addLabelIds": ["Label_XX"],
  "removeLabelIds": ["INBOX"]
}'
```

### Batch trash
```powershell
gws gmail users messages batchModify --params '{"userId":"me"}' --json '{
  "ids": ["id1","id2",...],
  "addLabelIds": ["TRASH"]
}'
```

> **Limit:** batchModify accepts up to 1000 IDs per call.

## Useful Gmail Search Queries

| Goal | Query |
|------|-------|
| All from a sender in inbox | `from:sender@example.com in:inbox` |
| Older than 2 weeks | `before:2026/05/22` |
| Exclude by subject | `-subject:receipt -subject:confirmation` |
| By label | `label:MyLabel` |
| Combine | `label:Uber_Deliveroo before:2026/05/22 -subject:receipt` |

## Python Helper Pattern (Windows)

gws prints `Using keyring backend: keyring` to stdout which breaks piping. Redirect stderr and parse cleanly:

```powershell
gws gmail users messages list --params '{"userId":"me","q":"..."}' 2>/dev/null | python -c "
import sys, json
data = json.load(sys.stdin)
ids = [m['id'] for m in data.get('messages', [])]
payload = json.dumps({'ids': ids, 'addLabelIds': ['Label_XX'], 'removeLabelIds': ['INBOX']})
with open('C:/Users/ipivi/AppData/Local/Temp/batch.json', 'w') as f:
    f.write(payload)
print(len(ids))
" 2>/dev/null

gws gmail users messages batchModify --params '{"userId":"me"}' --json "$(cat C:/Users/ipivi/AppData/Local/Temp/batch.json)" 2>/dev/null
```

Use `encoding='utf-8', errors='replace'` in `subprocess.run()` calls to avoid Windows cp1252 decode errors on email subjects.
