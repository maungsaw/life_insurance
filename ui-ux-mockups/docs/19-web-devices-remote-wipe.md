# Management · Devices — Remote Data Wipe (NFR §6)

## 1. BRD source (Non-Functional §6)

| Requirement | Description |
|-------------|-------------|
| **Device Registration and Authentication** | Only authorized / recognized devices can access the system. |
| **Remote Data Wipe** | Remove locally stored application data from a **registered device** on loss, theft, compromise, or deactivation. |
| Related | SQLite encryption · document encryption · audit trail for critical actions |

Acceptance also requires: *“The system must support … device registration and authentication, Remote data wipe …”*

**Web job:** Authorized admins **find agent → see device(s) → issue wipe**.  
**Mobile job:** Receive signed wipe command → clear local DB/files → ack → logout (already sketched in `lib/core/remote_wipe/`).

---

## 2. Name brainstorm (Management child)

| Candidate | Pros | Cons | Verdict |
|-----------|------|------|---------|
| **Remote Wipe** | Matches BRD term exactly | Sounds like the only action; hides registry job | ❌ too narrow for nav |
| **Device Wipe** | Action-clear | Still action-first; weak for “browse devices” | ❌ |
| **Device Security** | Security framing | Vague vs Audit; overlaps encryption NFRs | ❌ soft |
| **Security** | Short | Collides with Audit / session policy | ❌ |
| **Devices** | Noun like Resource / Announcement · registry-first · wipe is the critical action on a row | Less “BRD literal” | ✅ **Pick** |

**Nav label:** `Devices`  
**Page title:** `Devices`  
**Subtitle:** `NFR §6 · registered devices · remote data wipe`

Rationale: Management children stay **nouns** (Resource · Notification · Announcement · **Devices**). Wipe is a **dangerous action**, not the folder name.

---

## 3. IA

```
Management ▾
  ├── Resource
  ├── Notification
  ├── Announcement
  └── Devices          ← NEW (/management/devices)
```

Not under Audit: Audit = FR-12 agent data change trail. Devices = security ops on **hardware sessions**.

---

## 4. Who can wipe

| Role | Access |
|------|--------|
| Authorized HQ / Ops / Security admin | Full list + wipe |
| District manager (optional later) | Scope to own hierarchy |
| FA | Never — only receives wipe |

Mock: treat current web user as authorized.

---

## 5. Screen UX

### 5.1 Primary list (agent + device)

One row ≈ **one registered device** (an agent may have >1 row if multi-device later).

| Column | Why |
|--------|-----|
| ☐ select | Bulk wipe |
| Agent (code · name · role) | Who owns the device |
| Device | Model / friendly name |
| OS / App | iOS 17 · Android 14 · app build |
| Device ID | Truncated + copy (ties to wipe API `device_id`) |
| Last seen | Online honesty |
| Status | Active · Offline · Wipe pending · Wiped · Revoked |
| Action | Wipe this device |

Filters: Search (name/code/mobile) · Status · District · Platform (iOS/Android).

### 5.2 Wipe flow (safety)

1. Select one or many devices → **Wipe selected** (danger), or row **Wipe**.  
2. Confirm panel (not a tiny browser `confirm`):
   - Summary: agent · device · OS · last seen  
   - **Reason** * (Loss · Theft · Compromise · Deactivation) — mirrors BRD  
   - Optional note  
   - Type **WIPE** (or agent code) to enable Submit  
3. Submit → status → **Wipe pending** → (mock) later **Wiped** + ack time.  
4. Entry appears in **Wipe history** and should also feed Audit log later.

### 5.3 Honesty copy

- Wipe clears **local app data** on that device (SQLite + local docs), not Core/server CRM.  
- Device must be registered; if offline, command queues until next connect (show Pending).  
- After wipe, user must re-register / re-login on a trusted device.

### 5.4 Empty / error

| State | Treatment |
|-------|-----------|
| No devices | “No registered devices in this filter.” |
| Wipe without reason | Block submit |
| Not authorized | Soft gate (same as other Management screens) |

---

## 6. Routing

| Path | Screen |
|------|--------|
| `/management/devices` | Devices · Remote wipe |

---

## 7. Acceptance

- [x] Name decided: **Devices** (brainstorm documented)  
- [x] Management child + route  
- [x] Agent/user list with device information  
- [x] Select + remote wipe with reason + confirm  
- [x] Wipe history mock  
- [x] Docs updated  

---

## 8. Out of scope (later)

- Real push / signed command pipeline (`wipe` · `wipe-ack`)  
- Hierarchy-scoped manager wipe  
- Auto-wipe on agent deactivation status change  
