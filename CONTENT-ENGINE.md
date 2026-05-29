# Design Thread AI — Content Engine

## Brand
- Newsletter: **The Thread** by Design Thread AI
- Instagram / Threads: @design_thread
- Audience: Interior designers, boutique studio owners
- Voice: Elevated, editorial, declarative. Short sentences. No em dashes. No fluff.
- Fonts: Cormorant Garamond (headlines) + Montserrat (body)
- Colors: Navy #1A2B47, Brass #B08A4A, Warm beige #DBD1C7, Off-white #FAFAF8

---

## Newsletter Sign-Up URL
https://links.designthreadstudio.com/widget/form/iaNQ7gCsStliqIMN4yMq

---

## Blotato Account IDs
| Platform | Account ID | Notes |
|----------|-----------|-------|
| LinkedIn | 21483 | Personal profile (Michelle Fiallo) |
| Threads | 5519 | @design_thread |
| Facebook | 34227 | Use pageId: 490447950810254 (Design Thread Studio) |
| Instagram | 40322 | @design_thread — manual upload required (see below) |

---

## Canva Carousel Template
- Template ID: `EAHKDgGQ7-U`
- Create a new copy: https://www.canva.com/design?create=true&template=EAHKDgGQ7-U
- Open in browser (not the app) to avoid desktop issues

---

## Content Workflow

### Step 1 — Source
- Get the source: YouTube video, Instagram carousel, Zoom recording, Google Doc, or article
- Save raw source to `sources/` before writing anything

### Step 2 — Extract + Adapt
- Pull the key insight, angle, and structure
- Rewrite in The Thread voice — not a summary, not a repost
- Ask: what is MY take on this? What real experience do I bring?

### Step 3 — Plan (5 sections)
- Draft 5 numbered sections, each with a matched visual or example
- Call the Advisor (Opus) to review the outline before writing:
  > "Review this newsletter plan for [topic]. Critique the hook, section order, and whether each section has a clear payoff. Be adversarial."

### Step 4 — Write
- Write each section sequentially in The Thread's voice
- Lead with the concrete result, not the setup
- End each section with one actionable takeaway
- No em dashes anywhere

### Step 5 — Design
- Use the Canva carousel template (ID above)
- Create a fresh copy via the create URL
- 7 slides: hero → 4 content slides → closer → CTA
- Open in browser if desktop app won't load

### Step 6 — Distribute

**Push directly via Blotato MCP (in this session):**
- LinkedIn → text post, account 21483
- Threads → text post under 500 chars, account 5519
- Facebook → text post with pageId, account 34227

**Instagram — manual:**
- Export carousel slides as PNGs from Canva
- Upload directly in Blotato UI → Create Post → Instagram
- Instagram auth expires periodically — reconnect in Blotato if post fails

---

## Newsletter HTML Template
- Based on Issue 05 format (Cormorant + Montserrat, brass numbered squares, navy callout boxes)
- Saved at: `drafts/newsletter/` in the Voca GitHub repo
- Section structure: section label → headline → body → pull quote → navy callout

---

## Draft Storage
- GitHub repo: milefila/Voca, branch: main
- Folder: `drafts/newsletter/` for HTML + markdown drafts
- Naming: `YYYY-MM-DD-issue-XX-slug.md` / `.html`
- Also copy markdown drafts to Obsidian manually (cloud environment can't write there directly)

---

## Known Limitations
- Instagram image uploads cannot be done programmatically from this cloud environment (network policy blocks outbound PUT to Blotato storage) — always upload images manually via Blotato's browser UI
- Canva autofill/dataset fields require Enterprise plan — not available for automated text injection
- Blotato Instagram auth token expires when Instagram session changes — reconnect if you get auth errors

---

## Issue Tracker
| Issue | Date | Status |
|-------|------|--------|
| Issue 08 — Four Claude interfaces | 2026-05-29 | LinkedIn ✓ Threads ✓ Facebook ✓ Instagram ✓ (manual) |
