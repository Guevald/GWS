# Session: Gmail Cleanup & Labelling — 2026-06-05

## What Was Done

### Auth Fix
- `gws gmail +triage` was failing with `403 ACCESS_TOKEN_SCOPE_INSUFFICIENT`
- Root cause: stale cached access token in `~/.config/gws/token_cache.json`
- Fix: deleted `token_cache.json` — forced gws to refresh from the stored refresh token
- Re-authenticated twice during session to add `gmail.settings.basic` scope (needed for filter creation)

### Labels Created
| Label | ID | Purpose |
|-------|----|---------|
| LinkedIn | Label_41 | All LinkedIn emails |
| Uber_Deliveroo | Label_42 | Uber Eats + Deliveroo emails |
| Bank Updates | Label_43 | HSBC + Barclaycard only |
| Finance Alerts | Label_44 | FT Market Alert watchlist emails |

### Labels Deleted (were empty)
Work Setup, prospect, ebay, Misc to keep, Noah, promotions, subscriptions/GA and source forge, rental, Scheduled, Interesting, Personal, Receipts, Work

### Filters Created / Updated
| Sender | Label | Skip Inbox | Notes |
|--------|-------|-----------|-------|
| `@linkedin.com` | LinkedIn | ✓ | |
| `@uber.com`, `@deliveroo.co.uk`, `@deliveroo.com` | Uber_Deliveroo | ✓ | |
| `brainhealthdecoded@substack.com` | Substack | ✓ | |
| `newyorker@substack.com` | Substack | ✓ | |
| `themusicweek@substack.com` | Substack | ✓ | |
| `gilesthurston@substack.com` | Subscriptions | ✓ | |
| `queenspark@absolute-studios.co.uk`, `kensal@absolute-studios.co.uk`, `momence@mail.momence.com` | Absolut | ✓ | |
| `alert@cmpr.kayak.com` | Subscriptions | ✓ | |
| `newsletter@thedeepview.co` | Subscriptions | ✓ | |
| `marketalerts@alertshub.ft.com` | Finance Alerts | ✓ | moved from Subscriptions |
| `greg@greglangstaff.com` | Subscriptions | ✓ | |
| `recommendations@mailer.shortform.com` | Subscriptions | ✓ | |
| `content@sharegate.com` | Subscriptions | ✓ | pre-existing filter verified |
| `Hello@lovethesales.com` | Subscriptions | ✓ | |
| `no-reply@p.simplywall.st` | Subscriptions | ✓ | |
| `no-reply@m1.email.samsung.com` | Subscriptions | ✓ | |
| `hsbcuk@mail01.hsbc.co.uk`, `noreply@investdirect.hsbc.co.uk` | Bank Updates | ✓ | moved from Subscriptions |
| `barclaycard@emails.barclaycard.co.uk` | Bank Updates | ✓ | moved from Subscriptions |
| `hello@frive.co.uk` | Subscriptions (subject-based) | Partial | order/delivery/welcome stay in inbox |

### Retroactive Moves
| Sender / Group | Messages moved | To label |
|----------------|---------------|---------|
| LinkedIn | 361 | LinkedIn |
| Uber_Deliveroo | 219 | Uber_Deliveroo |
| Brain Health Decoded | 12 | Substack |
| New Yorker | 15 | Substack |
| The Music Week | 21 | Substack |
| Absolut | 75 | Absolut |
| Substack (all, remaining inbox) | 61 | Substack |
| Subscriptions batch (KAYAK, Deep View, FT, Greg, Giles, Shortform) | 306 | Subscriptions |
| HSBC + Barclaycard | 97 | Bank Updates |
| FT Market Alert | 73 | Finance Alerts |
| Sharegate | 8 | Subscriptions |
| Love the Sales | 35 | Subscriptions |
| Frive (promos only) | 5 | Subscriptions |
| Samsung | 74 | Subscriptions |

### Deletions
- **Uber_Deliveroo:** 132 non-receipt emails older than 2 weeks trashed
- **Absolut:** 64 newsletter emails older than 2 weeks trashed
- **Frive:** 26 promotional emails older than 1 month trashed (welcome kept)

### Recurring Cleanup
| Label | Cadence | Script | Status |
|-------|---------|--------|--------|
| Frive (Subscriptions) | Monthly 1st | `scripts/cleanup-frive.ps1` | Scheduled via Task Scheduler (GWS-FriveCleanup) |
| Absolut | Weekly Monday | Pending | Remote agent blocked — no Gmail MCP |

---

## Google Keep — Blocked
- Keep API scope (`keep`, `keep.readonly`) is restricted by Google — blocked for unverified personal OAuth apps
- **Workaround:** export via Google Takeout (takeout.google.com → Keep → HTML files), then parse into Excel / SQL Server
- Documented in GWS.md

## OAuth Config Transfer
- `.config\gws\` zipped (AES256, hint: chumG) and uploaded to Google Drive
- Drive file ID: `1aDbYKE83FsarYnrS2HLxQs09HhtiqOLu`
- On new machine: download from Drive, extract to `C:\Users\<you>\.config\gws\`, run `gws auth login`

## Pending / Next Session
- Set up gws on desktop
- Trips label: retroactively label KAYAK/Trip.com/Booking.com/Skyscanner confirmations
- Motel One, Nextdoor, Skyscanner, Trip.com newsletter → Subscriptions
- Adam Mancini newsletter → Subscriptions
- Absolut recurring cleanup → local Task Scheduler script
- Google Keep data extraction via Takeout
