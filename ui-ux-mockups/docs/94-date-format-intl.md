# 94 — One date pattern · `04-Jun-1999` via `intl`

**Surface:** Flutter agent app (all features) · HQ web display strings  
**Reference:** Policyholder DOB (`59`) · Profile (`50`) · CRM (`51`) · Policy list (`66`) · Tasks (`68`) · Commission (`61`) · Notifs (`49`) · Web catalog dates (`89`)  
**Today:** Same calendar day is formatted **five ways**: `04-Jun-1999` (quote / e-App), `04-JUN-1999` (CRM + task fields), `04.06.1999` (profile + policy filter range), `20 Sep 2024` (inbox groups), `2026-08-18 10:15:00.000` (reminder dump). Each feature owns a month table.  
**Date:** 2026-08-18

**Ask:** Date format ကို **04-Jun-1999** ပုံစံတစ်မျိုးထဲ · **application တစ်ခုတိုင်း** · `intl` package နဲ့.

**Rule:** Canonical **display** date is English `dd-MMM-yyyy` even when the UI language is Myanmar — Core / PDF / print / HQ already speak this. Do **not** let `DateFormat` follow `my` locale (would become Myanmar month names). HTML `<input type="date">` stays `yyyy-MM-dd` (browser), then convert to/from the canonical string.

---

## 0. What is actually split

| Surface | Today | Should be |
|---------|--------|-----------|
| Get A Quote / e-App DOB / quote saved | `ProductFormat.dob` → `04-Jun-1999` | keep, via `AppDate` |
| CRM person DOB | `04-JUN-1999` | `04-Jun-1999` |
| Profile DOB | `04.06.1999` | `04-Jun-1999` |
| Policy filter range | `01.03.2025 - 01.03.2026` | `01-Mar-2025 - 01-Mar-2026` |
| Task start/end · onboarding join | `14-AUG-2026` | `14-Aug-2026` |
| Commission when | `14-Aug-2026 10:11 AM` | same **date** part + time via `intl` |
| Notification group | `20 Sep 2024` | `20-Sep-2024` (Today / Yesterday stay) |
| Reminder picker | `DateTime.toString()` | `18-Aug-2026 10:15 AM` |
| Web HQ mocks | already `17-Aug-2026` | keep; one helper for ISO ↔ display |

---

## 1. Two jobs (keep separate)

| Job | Format | Not |
|-----|--------|-----|
| **Calendar day** (DOB, due, effective, saved-on) | `dd-MMM-yyyy` · `04-Jun-1999` | Numeric `04.06.1999` · ISO in the field |
| **Instant** (commission, last login, reminder) | `dd-MMM-yyyy hh:mm a` · `14-Aug-2026 10:11 AM` | Dropping the date pattern for time |

**Out of this pattern (leave):**

- Task **calendar chrome** — `Fri, 14 Aug` · `August 2026` · week ranges (a month grid, not a form field)  
- Relative `2m ago` / notif `2 hr`  
- OTP `01:23`  
- Clock `HH:mm` on the agenda (`10:00–11:00`)  
- Money (`59`)

---

## 2. Options

| Option | Idea | Verdict |
|--------|------|---------|
| **1 · Keep local `_months` tables** | Copy Jun everywhere | ❌ already drifted |
| **2 · One `AppDate` + Dart `intl`** | `DateFormat('dd-MMM-yyyy', 'en_US')` | ✅ **P0** |
| **3 · Follow app locale** | Myanmar months when language = my | ❌ breaks the asked pattern |
| **4 · date-fns on web only** | Extra JS dep | ❌ Flutter uses `intl`; web = small mirror helper |

**Pick: Option 2.** Direct `intl` dependency (already transitive via l10n — make it explicit). Locale **locked `en_US`**.

---

## 3. P0 behaviour

### 3.1 API

```dart
AppDate.dMy(dt)    // 04-Jun-1999
AppDate.dMyHm(dt)  // 04-Jun-1999 10:11 AM
AppDate.hm(dt)     // 10:11  (24h clocks only)
AppDate.range(a,b) // 01-Mar-2025 - 01-Mar-2026
```

`ProductFormat.dob` · `PolicyFormat.dob` · `TaskFormat.dob` · `CommissionFormat.dateTime` **delegate** here so call sites stay.

### 3.2 Must switch

Profile field + `ProfileMockData.dobLabel` · CRM `dobLabel` + customer profile picker · policy range `_dot` · notif date groups · reminder selected line.

### 3.3 Web

`formatDate.ts`: `fromDateInput` / `toDateInput` (product effective date) live in one module. Mock strings already `dd-MMM-yyyy`. No Dart `intl` in Vite.

### 3.4 Honesty

Picker UI (Material date dialog) may follow app language. The **string written into the field** is always `04-Jun-1999`.

---

## 4. What not to do

- Don’t localize month abbreviations to Myanmar in this pass  
- Don’t put ISO `yyyy-MM-dd` in agent-facing fields  
- Don’t change money / age / relative time  
- Don’t rewrite task month-grid titles into `14-Aug-2026` (unreadable as a calendar)

---

## 5. Test

- `AppDate.dMy(DateTime(1999, 6, 4)) == '04-Jun-1999'`  
- Myanmar `Locale('my')` does **not** change `dMy`  
- Profile / CRM helpers no longer contain `.` numeric dates or `JUN`
