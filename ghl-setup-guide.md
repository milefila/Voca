# GoHighLevel Setup Guide — Design Studio OS

## Overview
This guide walks through configuring GoHighLevel (GHL) to host and sell Design Studio OS. Follow these steps in order.

---

## Step 1: Connect Stripe

1. GHL Sidebar → **Settings → Payments → Stripe**
2. Click **Connect Stripe** and authorize your Stripe account
3. Confirm your Stripe account is in live mode (not test) before launch
4. Set your default currency to USD

---

## Step 2: Create the 3 Products

Go to **Payments → Products** and create three products:

### Product 1 — Solo Studio
- **Name:** Design Studio OS — Solo Studio
- **Price:** $197.00 (one-time)
- **Description:** Full 6-module course, all templates, lifetime access
- **Image:** Upload course cover image

### Product 2 — Cohort Edition
- **Name:** Design Studio OS — Cohort Edition
- **Price:** $297.00 (one-time)
- **Description:** Full course + community + 4 live group calls
- **Image:** Upload course cover image

### Product 3 — 1:1 Setup
- **Name:** Design Studio OS — 1:1 Setup Call
- **Price:** $497.00 (one-time)
- **Description:** Full course + 90-min private setup call + custom Thread Framework
- **Image:** Upload course cover image

After creating each product, copy its **Payment Link URL** — you'll need these for the sales page CTA buttons.

---

## Step 3: Build the Course

Go to **Sites → Memberships → Courses** (or **Products → Courses** depending on your GHL version):

1. Click **Create New Course**
2. **Title:** Design Studio OS: Scale Your Studio with Claude
3. **Tagline:** The operating system boutique interior design firms never knew they needed.
4. Upload your course thumbnail image

### Add Modules (in order):
1. Foundations — Why Claude Changes Everything
2. Module 1 — The Thread Framework
3. Module 2 — The Client Journey
4. Module 3 — Studio Operations
5. Module 4 — The Creative Engine
6. Module 5 — Scale Architecture

### For each module, add lessons:
- Use the lesson titles and descriptions from `course-content.md`
- Upload video files or paste Loom/Vimeo embed codes
- Add lesson transcript in the content body
- Attach the corresponding downloadable resource (PDF checklist)

### Access settings:
- Set each module to **Drip** (unlock sequentially) or **All at Once** per your preference
- Foundations and Module 1 should unlock immediately on enrollment

---

## Step 4: Set Up the Membership Portal

1. Go to **Sites → Memberships → Settings**
2. **Portal Name:** Design Studio OS
3. **Login Page URL:** Choose a custom subdomain or use your existing domain
4. **Theme:** Set primary color to `#C9A84C` (gold), background to `#F5F0E8` (cream)
5. Upload your course logo
6. Configure the welcome banner text

---

## Step 5: Create the Sales Funnel

### Option A — Use the HTML file (fastest)
1. Go to **Sites → Funnels → New Funnel**
2. Create an **Order Form** funnel
3. On the landing page step, switch to **Custom HTML** mode
4. Open `sales-page.html`, select all, copy, paste into the GHL HTML editor
5. Replace the `href="#"` on each pricing card's enroll button with the Payment Link URLs from Step 2
6. Save and preview

### Option B — Build in GHL page editor (most flexible)
1. Create a new funnel page using GHL's drag-and-drop editor
2. Use `sales-page.html` as a visual reference for layout and copy
3. Add the brand colors (`#F5F0E8`, `#1A1A1A`, `#C9A84C`) to your GHL brand settings
4. Add Cormorant Garamond and DM Sans via custom fonts or Google Fonts embed

### Update CTA buttons with payment links:
```
Solo Studio "Enroll at $197" → [Stripe Payment Link for $197 product]
Cohort Edition "Enroll at $297" → [Stripe Payment Link for $297 product]
1:1 Setup "Enroll at $497" → [Stripe Payment Link for $497 product]
```

---

## Step 6: Set Up Automations

### Automation 1: Solo Studio Purchase → Grant Access
**Trigger:** Payment received for "Design Studio OS — Solo Studio"
**Actions:**
1. Add Tag: `design-studio-os-enrolled`
2. Add Tag: `tier-solo`
3. Grant access to course: "Design Studio OS"
4. Send email: Welcome email (see `email-templates/welcome.html`)
5. Wait 1 day → Send email: Day 1 onboarding (see `email-templates/day1.html`)

### Automation 2: Cohort Edition Purchase → Grant Access + Add to Community
**Trigger:** Payment received for "Design Studio OS — Cohort Edition"
**Actions:**
1. Add Tag: `design-studio-os-enrolled`
2. Add Tag: `tier-cohort`
3. Grant access to course: "Design Studio OS"
4. Add to Community group: "Design Studio OS Cohort"
5. Send email: Welcome email (cohort version — note the community link)
6. Wait 1 day → Send email: Day 1 onboarding

### Automation 3: 1:1 Purchase → Grant Access + Book Call
**Trigger:** Payment received for "Design Studio OS — 1:1 Setup Call"
**Actions:**
1. Add Tag: `design-studio-os-enrolled`
2. Add Tag: `tier-one-on-one`
3. Grant access to course: "Design Studio OS"
4. Send email: Welcome email (1:1 version — include booking link for setup call)
5. Wait 1 day → Send email: Day 1 onboarding

### Automation 4: Day 3 + Day 7 Nudges
**Trigger:** Tag added: `design-studio-os-enrolled`
**Actions:**
1. Wait 3 days → Send email: Day 3 nudge (see `email-templates/day3.html`)
2. Wait 7 days → Send email: Day 7 check-in (see `email-templates/day7.html`)

---

## Step 7: Test Before Launch

- [ ] Complete a test purchase at $1 (temporarily reduce price, test, restore)
- [ ] Confirm Stripe receives payment and creates charge
- [ ] Confirm GHL automation fires and tags are added
- [ ] Confirm course access is granted and student can log in
- [ ] Confirm welcome email sends and renders correctly
- [ ] Walk through at least Foundations and Module 1 as a student
- [ ] Restore real prices before going live

---

## Step 8: Go Live Checklist

- [ ] Stripe account in live mode
- [ ] All 3 payment links active and tested
- [ ] Sales page CTA buttons updated with live payment links
- [ ] Course content uploaded (at minimum: Foundations + Module 1)
- [ ] Welcome and Day 1 emails live
- [ ] Membership portal accessible from your domain
- [ ] All 3 automations enabled
- [ ] Test purchase completed and access confirmed
- [ ] Refund policy stated on sales page (14 days, no questions)
- [ ] Support email configured (hello@[yourdomain].com)

---

## Quick Reference: Brand Settings in GHL

| Setting | Value |
|---|---|
| Primary color | `#C9A84C` (gold) |
| Background color | `#F5F0E8` (cream) |
| Text color | `#1A1A1A` (ink) |
| Heading font | Cormorant Garamond |
| Body font | DM Sans |
| Course portal logo | Upload your wordmark |
