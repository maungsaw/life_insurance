# More · Log out UX

**Screen:** Mobile More / Profile (`s-profile`)  
**Related:** `07` unified login · session timeout language  

---

## 1. Job

FA ends the session on this device and returns to auth.  
Not the same as **remote wipe** (Device & security / web Remote data wipe) or **session timeout** (automatic).

---

## 2. Placement brainstorm

| Option | Idea | Verdict |
|--------|------|---------|
| Top of list | Too easy to hit while browsing settings | ❌ |
| Mixed with Edit / Password | Looks like another setting | ❌ |
| **Bottom, after security** | End of list · clear “account exit” | ✅ **Pick** |
| Red full-width button under list | Strong affordance | Good alternate · use if list grows |

**Pick:** Last row in More list, visually separated (margin-top + danger tint).

---

## 3. Label

| Candidate | Notes |
|-----------|-------|
| **Log out** | Matches BRD “logout” / session language | ✅ **Pick** |
| Sign out | Fine alternate · same meaning |
| End session | Too technical |

Subtitle: `End session on this device`

---

## 4. Confirm before exit

Accidental tap on More is common. **Confirm sheet** required:

1. Title: `Log out?`  
2. Hint: Session ends on this phone. Drafts stay on device until sync policy applies. Sign in again to continue.  
3. **Cancel** · **Log out** (danger)

After confirm → **Sign in** (`s-login`) — faster re-entry than Splash. Splash remains cold start only.

---

## 5. What Log out does / does not

| Does | Does not |
|------|----------|
| Clear session / tokens (mock: leave app chrome) | Delete Core account |
| Return to Sign in | Wipe encrypted local DB (that’s remote wipe) |
| Keep drafts locally per security policy | Unregister device |

---

## 6. Acceptance

- [x] Log out at bottom of More  
- [x] Confirm sheet · Cancel / Log out  
- [x] Lands on Sign in  
- [ ] Real token clear / biometric lock (later)  

---

## 7. Related

- `07` FR-01 login · `19` remote wipe (different job)  
