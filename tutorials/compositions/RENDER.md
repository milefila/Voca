# Design Studio OS — Render Handoff

Six HyperFrames compositions. Render on your local Mac.

---

## Prerequisites

```bash
node --version   # 18 or 20 LTS recommended
npx hyperframes --version
```

If HyperFrames isn't installed: `npm install -g hyperframes`

---

## Asset Setup

Each episode folder must have two asset directories before rendering.

### Fonts

Copy from the Design Thread Video skill into each episode directory:

```bash
SKILL=~/.claude/skills/design-thread-video/assets/fonts

for EP in ep01-welcome ep02-intake ep03-concept ep04-proposals ep05-comms ep06-content; do
  mkdir -p $EP/assets/fonts
  cp $SKILL/cormorant-garamond-italic-400.woff2  $EP/assets/fonts/
  cp $SKILL/cormorant-garamond-italic-700.woff2  $EP/assets/fonts/
  cp $SKILL/cormorant-garamond-normal-400.woff2  $EP/assets/fonts/
  cp $SKILL/cormorant-garamond-normal-700.woff2  $EP/assets/fonts/
done
```

### Cedar Ridge Stills

Place your Cedar Ridge retreat photos in each episode folder. Expected filenames:

| Episode | Image file |
|---------|-----------|
| ep01-welcome | `assets/stills/cedar-ridge-01.png` |
| ep01-welcome | `assets/stills/cedar-ridge-02.png` |
| ep02-intake  | `assets/stills/cedar-ridge-03.png` |
| ep03-concept | `assets/stills/cedar-ridge-04.png` |
| ep04-proposals | `assets/stills/cedar-ridge-05.png` |
| ep05-comms   | `assets/stills/cedar-ridge-06.png` |
| ep06-content | `assets/stills/cedar-ridge-01.png` (reuse ep01's best shot) |

PNG or JPG both work — rename to `.png` or update the `img` field in each composition's `BEATS` array if you prefer a different extension.

### Background Music

Each episode references `assets/bgm/track.wav`. Place an ambient underscore track at that path in each episode folder, or use the same file symlinked across all six. The track should be at least 70 seconds.

---

## Render Commands

Run from the `tutorials/compositions` directory. Each command lints, validates, then renders.

```bash
cd tutorials/compositions

# Episode 01
npx hyperframes lint ep01-welcome.html && \
npx hyperframes validate ep01-welcome.html && \
npx hyperframes render -c ep01-welcome.html -o renders/ep01-welcome.mp4

# Episode 02
npx hyperframes lint ep02-intake.html && \
npx hyperframes validate ep02-intake.html && \
npx hyperframes render -c ep02-intake.html -o renders/ep02-intake.mp4

# Episode 03
npx hyperframes lint ep03-concept.html && \
npx hyperframes validate ep03-concept.html && \
npx hyperframes render -c ep03-concept.html -o renders/ep03-concept.mp4

# Episode 04
npx hyperframes lint ep04-proposals.html && \
npx hyperframes validate ep04-proposals.html && \
npx hyperframes render -c ep04-proposals.html -o renders/ep04-proposals.mp4

# Episode 05
npx hyperframes lint ep05-comms.html && \
npx hyperframes validate ep05-comms.html && \
npx hyperframes render -c ep05-comms.html -o renders/ep05-comms.mp4

# Episode 06
npx hyperframes lint ep06-content.html && \
npx hyperframes validate ep06-content.html && \
npx hyperframes render -c ep06-content.html -o renders/ep06-content.mp4
```

Or render all six in sequence:

```bash
mkdir -p renders
for EP in ep01-welcome ep02-intake ep03-concept ep04-proposals ep05-comms ep06-content; do
  echo "→ Rendering $EP..."
  npx hyperframes lint $EP.html && \
  npx hyperframes validate $EP.html && \
  npx hyperframes render -c $EP.html -o renders/$EP.mp4
done
```

---

## Composition Details

| File | composition-id | Duration | Beats | Cedar Ridge stills |
|------|---------------|----------|-------|--------------------|
| ep01-welcome.html | ds-os-ep01 | 70s | 7 (5 card, 2 image) | 01, 02 |
| ep02-intake.html  | ds-os-ep02 | 70s | 6 (5 card, 1 image) | 03 |
| ep03-concept.html | ds-os-ep03 | 70s | 6 (5 card, 1 image) | 04 |
| ep04-proposals.html | ds-os-ep04 | 70s | 6 (5 card, 1 image) | 05 |
| ep05-comms.html   | ds-os-ep05 | 70s | 6 (5 card, 1 image) | 06 |
| ep06-content.html | ds-os-ep06 | 70s | 6 (5 card, 1 image) | 01 (reuse) |

All compositions: 1920×1080, Card Story look, Founder Ink background, Burnished Brass accents, Cormorant Garamond headlines, GSAP 3.14.2.

---

## If Lint Warns About Overlapping Clips

All image beat elements use `data-layout-allow-overlap` and `data-layout-allow-overflow` where expected. If you see remaining lint warnings about the closing card overlapping the last beat, that overlap is intentional — the closing card at `t=62` may overlap beat 5's tail end (beat 5 ends at `t=54` but lingers visually until the closing card fades in).
