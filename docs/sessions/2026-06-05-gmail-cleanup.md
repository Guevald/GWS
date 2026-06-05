# Session: Gmail Cleanup & Labelling — 2026-06-05

## What Was Done

### Auth Fix
- `gws gmail +triage` was failing with `403 ACCESS_TOKEN_SCOPE_INSUFFICIENT`
- Root cause: stale cached access token in `~/.config/gws/token_cache.json`
- Fix: deleted `token_cache.json` — forced gws to refresh from the stored refresh token (which had all Gmail scopes)

### Labels Created
| Label | ID | Purpose |
|-------|----|---------|
| LinkedIn | Label_41 | All LinkedIn emails |
| Uber_Deliveroo | Label_42 | Uber Eats + Deliveroo emails |

### Labels Deleted (were empty)
Work Setup, prospect, ebay, Misc to keep, Noah, promotions, subscriptions/GA and source forge, rental, Scheduled, Interesting, Personal, Receipts, Work

### Filters Created
| Sender | Label | Skip Inbox |
|--------|-------|-----------|
| `@linkedin.com` | LinkedIn | ✓ |
| `@uber.com`, `@deliveroo.co.uk`, `@deliveroo.com` | Uber_Deliveroo | ✓ |
| `brainhealthdecoded@substack.com` | Substack | ✓ |
| `newyorker@substack.com` | Substack | ✓ |
| `themusicweek@substack.com` | Substack | ✓ |
| `queenspark@absolute-studios.co.uk` | Absolut | ✓ |

### Retroactive Moves
| Filter | Messages moved |
|--------|---------------|
| LinkedIn | 361 |
| Uber_Deliveroo | 219 |
| Brain Health Decoded | 12 |
| New Yorker | 15 |
| The Music Week | 21 |
| Absolut | 75 |

### Deletions
- **Uber_Deliveroo:** 132 non-receipt emails older than 2 weeks trashed (kept: subject containing receipt/order/confirmation/invoice/trip)
- **Absolut:** 64 newsletter emails older than 2 weeks trashed (kept: confirmation/booking/receipt/invoice)

## Recurring Cleanup — Absolut
- Goal: weekly Monday cleanup of Absolut newsletter emails older than 2 weeks
- Blocked: remote agents can't use local `gws` CLI (no credentials in cloud)
- Alternative: local Windows Task Scheduler — pending setup
- To unblock remote: connect Gmail MCP at `claude.ai/customize/connectors`
