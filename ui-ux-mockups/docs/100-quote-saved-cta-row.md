# 100 — Quote saved · two CTAs on one row

**Surface:** Quote saved (`quote_saved.dart`)  
**Reference:** Sell spine (`59` §D) · Save quote (`24`)  
**Today:** Three stacked actions — **Start e-App**, **View saved quotes**, **Back to Products**. AppBar already has back. The text link is a third exit and pushes the real next step off the thumb row.  
**Date:** 2026-08-18

**Ask:** Back to Products **off**. The two buttons on **one row**. UI/UX that still reads.

---

## 0. Why drop Back to Products

AppBar chevron is the product/calculator exit. A third full-width link repeats that job and makes the footer look like three equal choices. After save, the jobs are only:

1. **Start e-App** — continue the sale  
2. **View saved quotes** — park it and browse later  

---

## 1. One row

| Side | Button | Why |
|------|--------|-----|
| Left | **View saved quotes** · outline | Secondary · longer label · FittedBox |
| Right | **Start e-App** · filled | Primary · **equal width** (not flex 2) |

Gutter 10 · height 50 · same `Expanded` · SafeArea under the home indicator. Fill vs outline still marks the next step.

Do **not** rename the labels. Do **not** put Start e-App on the calculator again.

---

## 2. Test

- Quote saved has **Start e-App** and **View saved quotes**  
- No **Back to Products**  
- The two `AppButton`s share one `Row`
