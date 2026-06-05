# Email Cleanup Playbook

A reference of cleanup patterns and rules to apply consistently across email accounts (Gmail, Outlook, Yahoo, etc.).

---

## Labelling / Folder Rules

### Create a label and route emails into it (skip inbox)

| Label | Senders / Criteria | Skip Inbox | Notes |
|-------|--------------------|-----------|-------|
| LinkedIn | `@linkedin.com` | ✓ | All LinkedIn emails |
| Uber_Deliveroo | `@uber.com`, `@deliveroo.co.uk`, `@deliveroo.com` | ✓ | Rides + food delivery |
| Substack | Per newsletter sender (see table below) | ✓ | Filter individually, not by domain |
| Absolut | `queenspark@absolute-studios.co.uk`, `kensal@absolute-studios.co.uk`, `momence@mail.momence.com` | ✓ | Gym/studio — two branches + booking platform |
| Bank Updates | `hsbcuk@mail01.hsbc.co.uk`, `noreply@investdirect.hsbc.co.uk`, `barclaycard@emails.barclaycard.co.uk` | ✓ | Bank emails only — not in Subscriptions |
| Finance Alerts | `marketalerts@alertshub.ft.com` | ✓ | FT market/watchlist alerts |
| Subscriptions | See table below | ✓ | General newsletters/promotions |
| Frive | `hello@frive.co.uk` (subject-based — see Notes) | Partial | Delivery/order/welcome stay in inbox; promos go to Subscriptions |

#### Substack newsletters (routed individually to Substack label)
| Newsletter | Sender |
|------------|--------|
| Brain Health, Decoded | `brainhealthdecoded@substack.com` |
| New Yorker Substack | `newyorker@substack.com` |
| The Music Week | `themusicweek@substack.com` |
| Art Every Day | `arteveryday@substack.com` |

#### Subscriptions senders
| Sender | Address |
|--------|---------|
| KAYAK | `alert@cmpr.kayak.com` |
| The Deep View | `newsletter@thedeepview.co` |
| Greg Langstaff | `greg@greglangstaff.com` |
| Giles Thurston (Photographer's Eye) | `gilesthurston@substack.com` |
| Shortform Recommendations | `recommendations@mailer.shortform.com` |
| Sharegate | `content@sharegate.com` |
| Love the Sales | `Hello@lovethesales.com` |
| Simply Wall St | `no-reply@p.simplywall.st` |
| Samsung | `no-reply@m1.email.samsung.com` |

---

## Deletion Rules

### Delete non-receipts older than retention window
Applied to labels where emails accumulate but only receipts/confirmations have long-term value.

| Label | Keep (subjects containing) | Delete | Cadence |
|-------|---------------------------|--------|---------|
| Uber_Deliveroo | receipt, order, confirmation, invoice, trip | Everything else older than 2 weeks | One-off (done 2026-06-05) |
| Absolut | confirmation, booking, receipt, invoice | Everything else older than 2 weeks | Weekly Monday (pending automation) |
| Frive (Subscriptions) | welcome email, delivery/order updates (stay in inbox) | Promos in Subscriptions older than 1 month | Monthly 1st (Task Scheduler: GWS-FriveCleanup) |

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

## Pending / To Tidy Up Later

| Item | Notes |
|------|-------|
| Trips label | Create label; retroactively move KAYAK/Trip.com/Booking.com/Skyscanner confirmations & itineraries into it; keep in inbox going forward |
| Motel One | `newsletter@mailings.motel-one.com` → Subscriptions |
| Nextdoor | `no-reply@is.email.nextdoor.co.uk` → Subscriptions |
| Skyscanner deals | `no-reply@sender.skyscanner.com` → Subscriptions |
| Trip.com newsletter | `Trip.com@newsletter.trip.com` → Subscriptions |
| Adam Mancini newsletter | Confirm sender address → Subscriptions or Finance Alerts |
| Finance Alerts tidy-up | Review what's in Finance Alerts vs Subscriptions |

---

## Applying to Other Accounts (Outlook / Yahoo)

When setting up a new account, work through these steps in order:

1. **Audit existing folders/labels** — list all, note which are empty
2. **Delete empty folders**
3. **Create standard labels** (LinkedIn, Uber_Deliveroo, Substack, Bank Updates, Finance Alerts, Subscriptions, Trips, etc.)
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
- **Frive:** subject-based filter — `order`, `delivery`, `shipped`, `confirmation`, `receipt`, `invoice`, `welcome` stay in inbox; all other Frive emails go to Subscriptions. Monthly cleanup (1st of month) trashes Frive promos in Subscriptions older than 1 month
- **Bank Updates vs Subscriptions:** HSBC and Barclaycard are exclusively in Bank Updates, not also tagged as Subscriptions
