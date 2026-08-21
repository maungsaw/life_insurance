# Offline banner vs phone notch

**Canvas:** `offline-banner-notch-brainstorm.canvas.tsx`  
**Seen on:** `products.html` Toggle Offline — amber strip clipped by notch (“Offline – dr… / …ll sync”)

## Problem
Banner sits at `scroll` top / `sticky: top: 0` while `.phone-frame::before` notch (z-index 100, ~28px) covers the center. Long copy cannot survive that cutout.

## Options
| ID | Pattern | Notch-safe |
|---|---|---|
| **A (recommend)** | Status bar → app bar → offline strip; sticky offset past notch | High |
| **B** | Compact “Offline” chip in header row | High |
| **C** | Toast on toggle + small persistent chip | High |
| **D** | Tint status bar only; short L/R labels | Medium |

## Copy
One short line, e.g. `Offline — drafts stay on device`. Same pattern on products · quote · home · CRM/Policies.

## Status
**A shipped** — status → app chrome → offline strip; sticky `top: 28px`; short one-line copy on products · get-quote · after-login (home/CRM/policies).
