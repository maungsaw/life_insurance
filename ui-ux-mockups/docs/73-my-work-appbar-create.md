# 73 — My work create · AppBar `+` only (no page FAB)

**Source:** Screenshot 2026-08-14 — My work Day · AppBar cyan `+` **and** bottom-right FAB · pill nav  
**Flutter today:** Soft-dock FAB (`69` A) **plus** AppBar `+` — two create buttons on one screen  
**Related:** `08` App bar vs FAB · `69` placement · `44`/`57` pill · shell shield FAB  
**Date:** 2026-08-14

**Ask:** Remove the floating action button. Keep create on the **right of the app bar** and make that the only local create so it doesn’t fight the shell.

---

## 1. What’s wrong now

| Issue | Why |
|-------|-----|
| **Two `+` on My work** | AppBar circle + bottom FAB — same job, two targets |
| FAB vs shell shield | Page FAB sits just above the **center** Quick-actions FAB — thumb confusion |
| `08` rule broken | “Don’t duplicate `+` in header **and** FAB” |
| `69` A was a height fix | Soft-dock solved “FAB too high” but left **duplicate create** |

User call: **ဖြုတ်** the FAB · **ညာဘက်** AppBar `+` is already there — make *that* the system.

---

## 2. Options

| Option | Idea | Verdict |
|--------|------|---------|
| Keep FAB, drop AppBar `+` | Restore `08` / `69` A | ❌ User asked FAB off |
| **AppBar `+` only** | One local create, top-right | ✅ **Pick** (`69` B) |
| Empty CTA only | No header + | ❌ Hard to find when the list is full |
| Shell Quick actions only | No My work create | ❌ Extra tab hop |

**Pick: AppBar `+` only.** Empty list still gets a **labeled** “Create task” (not a third icon).

---

## 3. AppBar `+` spec (right side)

```
[ My work · 5 ]                         ( ● + )
```

| Slot | Spec |
|------|------|
| Position | AppBar `actions` · trailing, **16** inset from screen edge |
| Shape | **Filled circle** · `lightPrimary` · white `Icons.add` (screenshot) — not outline `add_circle_outline` |
| Size | **36–40** px tap target (padding around 36 so hit area ≥ 44) |
| Tooltip / semantics | `Create task` |
| Action | Same as old FAB → `TaskForm` for **visible day** |
| Scroll | Keep `SliverAppBar` **floating + snap** so fling-up reveals `+` without a bottom FAB |
| Don’t | Second `+` in filter chips · extended FAB · badge on `+` |

Header stays title-left / create-right — matches screenshot after FAB is gone.

---

## 4. Remaining create paths (OK)

| Entry | When |
|-------|------|
| **AppBar `+`** | Primary on My work |
| **Empty “Create task”** | No rows for Day/Week/Month — text button, not another circle |
| **Shell shield → New Task** | From Home / other tabs (`44`) |
| Card tap | Edit existing — not create |

That’s **one icon** on the agenda screen. Empty CTA is a fallback, not a duplicate chrome control.

---

## 5. After FAB is gone

| Adjust | Why |
|--------|-----|
| Drop `Stack` + `Positioned` FAB | Body = `CustomScrollView` only |
| List bottom spacer | `scrollClearance` **only** — drop the extra `+ 56` that cleared the FAB |
| Empty copy | Keep; still points at Create task |
| Filter grid button | Unrelated — leave |

Long agenda: user scrolls up slightly → floating AppBar + `+`. Acceptable vs a third control over the pill.

---

## 6. What not to do

- Don’t keep a mini-FAB “just in case”  
- Don’t move `+` to the **center** (that’s the shell shield)  
- Don’t put `+` on both AppBar and filters  
- Don’t add “New task” in the Day/Week/Month segment  

---

## 7. Flutter map

| File | Change |
|------|--------|
| `task/.../index.dart` | Remove FAB/Stack · filled AppBar `+` · trim list spacer |
| `69` | A superseded by this B pick |
| Inventory | This file |

---

## 8. Acceptance

- [x] FAB duplicate diagnosed vs AppBar `+`  
- [x] AppBar-only spec (filled circle, snap header, empty CTA)  
- [x] FAB removed · AppBar `+` is the local create  
- [x] Inventory updated  

---

## 9. Related

Screenshot · `TaskBoardPage` · `08` · `69` · `44` · `68`
