# Email Cleanup Playbook

A reference of cleanup patterns and rules to apply consistently across email accounts (Gmail, Outlook, Yahoo, etc.).

---

## Labelling / Folder Rules

### Create a label and route emails into it (skip inbox)

| Label | Senders / Criteria | Skip Inbox | Notes |
|-------|--------------------|-----------|-------|
| LinkedIn | `@linkedin.com` | ✓ | All LinkedIn emails |
| Uber_Deliveroo | `@uber.com`, `@deliveroo.co.uk`, `@deliveroo.com` | ✓ | Rides + food delivery |
| Substack | `@substack.com` senders (per newsletter) | ✓ | See individual senders below |
| Absolut | `queenspark@absolute-studios.co.uk`, `kensal@absolute-studios.co.uk`, `momence@mail.momence.com` | ✓ | Gym/studio — two branches + booking platform |
| Subscriptions | KAYAK, The Deep View, FT Market Alert (see Finance Alerts), Greg Langstaff, Giles Thurston, Shortform | ✓ | General newsletters/promotions |
| Bank Updates | `hsbcuk@mail01.hsbc.co.uk`, `noreply@investdirect.hsbc.co.uk`, `barclaycard@emails.barclaycard.co.uk` | ✓ | Bank emails only — not in Subscriptions |
| Finance Alerts | `marketalerts@alertshub.ft.com` | ✓ | FT market/watchlist alerts |
| Frive | `hello@frive.co.uk` | ✗ | Stays in inbox — delivery/order updates expected; purge non-welcome emails >1 month old |

#### Substack newsletters routed individually
| Newsletter | Sender |
|------------|--------|
| Brain Health, Decoded | `brainhealthdecoded@substack.com` |
| New Yorker Substack | `newyorker@substack.com` |
| The Music Week | `themusicweek@substack.com` |
| Art Every Day | `arteveryday.substack.com` (list filter) |

---

## Deletion Rules

### Delete non-receipts older than 2 weeks
Applied to labels where emails accumulate but only receipts/confirmations have long-term value.

| Label | Keep (subjects containing) | Delete | Cadence |
|-------|---------------------------|--------|---------|
| Uber_Deliveroo | receipt, order, confirmation, invoice, trip | Everything else older than 2 weeks | One-off (done 2026-06-05) |
| Absolut | confirmation, booking, receipt, invoice | Everything else older than 2 weeks | Weekly Monday (pending automation) |
| Frive (inbox) | welcome email, delivery/order updates | Everything else older than 1 month | One-off (done 2026-06-05) |

### General deletion principle
> Keep anything that is a **receipt, booking confirmation, invoice, or account notification**. Delete everything else (promotions, newsletters, marketing) beyond the retention window.

---

## Empty Label Cleanup
- Periodically delete labels/folders with 0 messages
- Gmail: check `messagesTotal` via API for each user label
- Deleted 2026-06-05: Work Setup, prospect, ebay, Misc to keep, Noah, promotions, subscriptions/GA and source forge, rental, Scheduled, Interesting, Personal, Receipts, Work

---

## Retention Windows

| Category | Keep for |
|----------|---------|
| Receipts / invoices | Indefinitely |
| Booking confirmations | Indefinitely |
| Newsletters / promotions | 2 weeks |
| Job alerts | 2 weeks |
| Marketing | 0 (trash on arrival via filter) |

---

## Senders to Trash on Arrival
Emails from these senders go straight to trash — no label needed.

| Sender | Reason |
|--------|--------|
| `info@learntotrade.co.uk` | Spam |
| `hello@announcement.deliveroo.co.uk` | Deliveroo marketing (separate from receipts) |
| `info@clearmindshypnotherapy.com` | Unwanted |
| `recommendations@discover.pinterest.com` | Unwanted |
| `ae-news-notice01@mail.aliexpress.com` | Spam |
| `ae-report-info05.a4@mail.aliexpress.com` | Spam |
| `info@absolute-studios.co.uk` | Duplicate/unwanted from Absolut |
| `info@altheaacademy.com` | Unwanted |
| `yrosenstein@gmail.com` | Unwanted |

---

## Applying to Other Accounts (Outlook / Yahoo)

When setting up a new account, work through these steps in order:

1. **Audit existing folders/labels** — list all, note which are empty
2. **Delete empty folders**
3. **Create standard labels** (LinkedIn, Uber_Deliveroo, Substack, etc.)
4. **Create filters** — route senders to labels, skip inbox
5. **Apply retroactively** — move existing matching emails to their labels
6. **Trash on arrival** — add filters for known spam/marketing senders
7. **Bulk delete old non-receipts** — per the deletion rules table above
8. **Set up recurring cleanup** — automate step 7 for high-volume labels

---

## Notes & Decisions

- **Substack:** filter per individual newsletter sender rather than a blanket `@substack.com` rule, to allow opting individual newsletters out later without breaking others
- **Uber_Deliveroo:** Uber Eats receipts come from `@uber.com` so cannot split rides vs food by domain alone — keep all receipts, delete the rest
- **Absolut:** `queenspark@absolute-studios.co.uk` is the active sender; `info@absolute-studios.co.uk` goes to trash (different sender, unwanted)
