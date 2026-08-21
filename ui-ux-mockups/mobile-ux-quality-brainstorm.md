# Mobile Prototype — UI/UX Quality Brainstorm

**Goal:** Stakeholder-ready mobile appearance — one coherent KBZ LIFE agent app (HTML + Tailwind + JS phone frames).

**Canvas:** `mobile-ux-quality-brainstorm.canvas.tsx` (open beside chat)

**Gallery:** [`mobile-prototype-gallery.html`](./mobile-prototype-gallery.html) — stakeholder entry

**Screens:** `KBZ Mobile ProtoType 1/` — before-login · login · after-login · products · personal-accident · get-quote · policyholder-form

---

## North star

Inside the phone: cream `#F7F3EC`, soft cards `#FFFcf7`, Coolors (Sky / Steel / Baltic / Deep / Mint), fixed nav **Home · Customer · FAB · Product · Profile**, end-user copy only. QA/simulate outside the frame.

---

## Journey readiness

| Step | Screen | Grade | Note |
|---|---|---|---|
| Guest | before-login | Strong | Partner · locks · sheet motion |
| Auth | login | Strong | OTP · biometric |
| FA home | after-login | Strong+ | CRM · Policies · toast · empty |
| Library | products | Strong | Drafts · offline · empty toggle |
| Detail | personal-accident | Strong | Phase A restyle |
| Quote | get-quote | Strong | Sheet motion · toast |
| e-App | policyholder-form | Strong | Step fade · draft toast |

---

## P0 (must fix before big demos)

1. [x] Restyle `personal-accident.html`
2. [x] Remove leftover `#1a5fb4`
3. [x] Unify status bar / header

## P1

4. [x] Identical bottom-nav chrome + `.nav-hit`
5. [x] Shared `.sheet-overlay` / `.sheet-panel` / `.btn-sheet-*`
6. [x] Spacing / CTA rhythm aligned (Phase B)

## P2 — Phase C

7. [x] Empty / offline / success states (CRM, Policies, drafts, toasts)
8. [x] Light motion (sheet rise, overlay fade, step fade, toast in)
9. [x] Stakeholder gallery (`ui-ux-mockups/mobile-prototype-gallery.html`)

---

## Definition of “တော်တော်ကောင်း” for demos

- [x] Flip Guest → Login → Home → Product → PA → Quote → e-App without theme jump
- [x] One blue family only (Coolors Deep/Steel)
- [x] Soft cards dominate
- [x] Nav labels never change
- [x] Spec notes stay outside the phone

---

## Status

**Phase A + B + C complete.** Start demos from the gallery page.
