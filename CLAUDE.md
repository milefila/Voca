# Voca — Claude Code Workflow

## Multi-Session Content Workflow

Run separate Claude Code sessions per content type, each focused on one task:

| Tab | Purpose | Launch |
|-----|---------|--------|
| newsletter | Weekly newsletter draft + publish | `claude --name newsletter` |
| tweets | Thread + standalone tweet ideas | `claude --name tweets` |
| crosspost | Adapt content for LinkedIn/IG | `claude --name crosspost` |
| remotion | Short-form video scripts for Remotion | `claude --name remotion` |

Launch all at once: `./launch.sh`

---

## The Advisor Pattern

Before executing any multi-step content plan, get a review:

> "Let me get a stronger reviewer's read on this plan before I write."

Spawn a subagent with model `claude-opus-4-8` to critique the plan, then adjust before writing.

In practice — after drafting your 5-section outline, call the advisor like this:

```
Subagent prompt: "Review this newsletter plan for [topic]. Critique the section order,
whether the hook is strong, and whether each section has a clear payoff. Be adversarial."
```

Only proceed to writing after the advisor signs off.

---

## The Tinkering Checklist Pattern

Break every content job into explicit sub-tasks before starting:

```
- [ ] Get transcript / understand source
- [ ] Confirm ICYMI links + fact-check items
- [ ] Extract N screenshots / visuals
- [ ] Write draft
- [ ] Publish / post
```

Track these visibly so the session can be interrupted and resumed.

---

## Newsletter Workflow (5 Sections)

1. **Source** — fetch YouTube transcript, blog post, or Zoom recording
2. **Extract** — pull key quotes, timestamps, tool names, and links
3. **Plan** — outline 5 numbered sections, each with a matched visual
4. **Advise** — get Opus review of the plan (see above)
5. **Write** — write each section in sequence, maintaining voice
6. **Publish** — push draft to Substack via browser or API

---

## Tweets Workflow

1. Read the newsletter draft (or source content)
2. Extract 5–7 standalone insights worth tweeting
3. Write one thread (8–12 tweets) + 3 standalone tweets
4. Schedule via Blotato or post directly

---

## Crosspost Workflow

1. Take finalized newsletter sections
2. Reformat each for LinkedIn (professional tone, no hashtag spam)
3. Reformat hero section for Instagram caption
4. Export to Blotato for scheduling

---

## Remotion Workflow

1. Take the strongest newsletter section
2. Convert to a 30–60 second spoken script (no filler words)
3. Mark b-roll moments with `[VISUAL: description]`
4. Save to `scripts/` for rendering

---

## Source Fetching

For YouTube transcripts: use `yt-dlp --write-auto-sub --skip-download <url>` then parse the `.vtt` file.

For Zoom recordings: use the Zoom MCP server tools (`search_zoom`, `get_meeting_assets`).

For Google Docs: use Google Drive MCP (`read_file_content` by doc ID).

---

## Publishing

- **Newsletter** → Substack (draft via browser or API)
- **Social posts** → Blotato MCP (`blotato_create_post`)
- **Visuals** → Canva MCP (`create-design-from-brand-template`)

---

## Working Style

- Always commit source fetches to `sources/` before writing
- Keep drafts in `drafts/<type>/<date>-<slug>.md`
- One session = one piece of content; don't mix tasks across tabs
