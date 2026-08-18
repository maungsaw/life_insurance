# 91 — e-App signatures · one pad at a time (no cross-box stroke)

**Surface:** Flutter e-App · Confirm & Submit (`eapp_wizard` + `SignaturePad` in `product_pickers.dart`)  
**Reference:** Dual e-sign FR-05 (`04` `59` `67`) · Sign step vs Confirm  
**Today:** Two pads stacked (Client * · Agent *). `GestureDetector` + `CustomPaint` **without clip**. A pan that starts in Client keeps drawing `localPosition` **outside** the 120px box; paint overflows into the gap and over the Agent pad — looks like one scribble filling both. Agent can also be signed first (skip).  
**Date:** 2026-08-18

**Ask:** Signature တွေ **တစ်ခုပြီးတစ်ခု** ဖြစ်ရမယ်။ Box ကနေ **ကျော်** ပြီး နောက် box ထဲ ဆက်ဆွဲလို့ မရအောင်. လိုအပ်တာအားလုံး ပြည့်အောင် brainstorm။

**Rule:** Client and Agent are **two legal acts**, not one canvas with two labels. Clip + sequential lock. Do **not** merge into a single pad. Do **not** put signing on issued Policy Details (`66` read-only).

---

## 0. What is actually broken

| Symptom | Cause |
|---------|--------|
| Stroke crosses the gap into the second box | Paint is **not clipped**; pan continues after the finger leaves the pad |
| Both boxes look “filled” from one gesture | Overflow ink from pad A paints on top of pad B’s visual area |
| Can sign Agent before Client | Both pads are always enabled |
| Submit only checks `hasInk` boolean | Any pixel in either pad counts — even a 1pt leak |

`lib/core/signature/signature_pad.dart` already wraps `ClipRRect`. Confirm uses the **simpler** `product_pickers.dart` `SignaturePad` — **no clip, no bounds check**.

---

## 1. Two jobs (keep both, don’t mix)

| Job | Who | Order |
|-----|-----|--------|
| **Client signature** | Prospect / PH on device | **First** · required |
| **Agent signature** | FA on same device | **Second** · required · locked until client has a real stroke |

BRD: dual e-sign. Sequence matches field practice (client signs, then FA). Cannot skip Client.

---

## 2. Options

| Option | Idea | Pros | Cons | Verdict |
|--------|------|------|------|---------|
| **1 · Clip only** | `ClipRect` + drop points outside rect | Stops visual bleed | Still sign Agent first | ❌ alone |
| **2 · Sequential lock** | Agent pad disabled until Client ink | Can’t skip | Bleed still if clip missing | ❌ alone |
| **3 · Full-screen one pad** | Tap “Sign” → modal canvas → Done | Best isolation · fat finger | Extra taps · Confirm longer | **P1** |
| **4 · Clip + clamp + sequential** | Clip paint · ignore out-of-bounds points · lock Agent · min stroke | Fixes screenshot + skip | Still two small pads on Confirm | ✅ **P0** |

**Pick: Option 4 for P0.** Option 3 if UAT still hates stacked pads (`67` Confirm length).

---

## 3. P0 behaviour (must)

### 3.1 Isolation (no ကျော်)

- Each pad: `ClipRRect` matching the border radius (same as `core/signature`)  
- `onPanUpdate`: **ignore** (do not append) points outside `0..width` × `0..height`  
- `onPanEnd` if the finger left the pad: end the stroke (`null` break) — do **not** continue ink on the other pad  
- Overflow: `clipBehavior: Clip.hardEdge` on the box  
- Two pads never share a `List<Offset>`

### 3.2 Sequence (တစ်ခုပြီးတစ်ခု)

```
Client pad     unlocked
Agent pad      locked (grey) until clientHasInk
Submit         disabled until both have ink
```

Locked Agent:

- `AbsorbPointer` (or ignore pan)  
- Hint: “Sign client first”  
- Clear on Client does **not** have to wipe Agent; if Client is cleared, Agent **re-locks** and Submit disables (keep Agent ink hidden until Client is valid again **or** wipe Agent on Client clear — **wipe Agent** is cleaner legally)

**Skip lock:** cannot focus/draw Agent first.

### 3.3 Valid ink (not a tap)

- Minimum: path length or point count (e.g. ≥ 8 points or path > 40px) before `onChanged(true)`  
- A single tap in the corner is not a signature  

### 3.4 Clear

- Clear is **per pad** (already)  
- Client Clear → Agent re-locks + Agent canvas cleared  

---

## 4. Confirm layout (so it still fits)

Keep stacked pads on Confirm (`67` wants signatures in first viewport). Visual states:

| Pad | Empty | Signing | Done | Locked |
|-----|-------|---------|------|--------|
| Client | “Draw inside this box” | ring | check | — |
| Agent | “Waiting for client” | ring | check | muted + lock icon |

Do **not** put both pads inside one `GestureDetector`.  
Optional 8px **dead gap** (already `SizedBox(12)`) stays; clip is the real fix.

---

## 5. P1 (if UAT still crosses)

Full-screen **Sign client** sheet → Done → **Sign agent** sheet. Confirm shows thumbnails + Re-sign. Better for legal capture; slightly longer Confirm.

Reuse `CustomSignaturePad` from `lib/core/signature/` instead of two implementations long-term.

---

## 6. What not to do

- One shared canvas with two labels  
- Letting overflow paint “count” as the second signature  
- Auto-copy Client stroke into Agent  
- Signing on Policy Details  
- Web portal signature pads (`86` no wizard)  
- Requiring two phones for P0 (same device dual sign stays)

---

## 7. Files (when you say ဟုတ်ကဲ့)

| File | Change |
|------|--------|
| `product_pickers.dart` `SignaturePad` | Clip · clamp points · `enabled` · `lockedHint` · min ink |
| `eapp_wizard.dart` Confirm | `enabled: _clientSign` on Agent · Clear client resets agent · Submit copy |

---

## 8. Acceptance (brainstorm)

- [x] Bleed = unclipped pan, not “one box”  
- [x] Clip + out-of-bounds ignore  
- [x] Sequential: Client then Agent; cannot skip  
- [x] Clear client re-locks agent  
- [x] Min stroke vs tap  
- [x] P1 full-screen optional  
- [x] Implement — P0 shipped 2026-08-18 (clip · sequential lock · min ink) 
