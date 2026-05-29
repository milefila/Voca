# FOR MICHELLE — What We Built Today and Why

*A debrief on the full session: from Sabrina's terminal screenshot to a live content engine.*

---

## Step 1: What approach did we take, and why?

You dropped a screenshot of Sabrina Ramonov's terminal and said "let's model this." The screenshot showed something specific: four parallel Claude Code sessions running at once — newsletter, tweets, crosspost, remotion — each focused on one task, with a built-in advisor review before anything got written.

The starting point wasn't "build a thing." It was "understand what made that screenshot work." The answer: she wasn't using Claude as a chatbot. She was using it as an operating system for content — each tab a dedicated worker, each session with a narrow job.

So we built that. Not a copy of her workflow, but the same architecture applied to your specific setup: your brand (The Thread), your platforms (LinkedIn, Threads, Facebook, Instagram), your tools (Blotato, Canva, GitHub). The CLAUDE.md file became the brain — the document every session reads on startup so Claude already knows the job.

Then we ran the workflow live. Picked a real source (the @intelligent.designer.ai carousel), wrote a real newsletter section, built real HTML, pushed to three platforms via API, and got the Instagram carousel out. Not a demo. A live run.

---

## Step 2: What other approaches did we consider but abandon?

**The "just summarize the carousel" approach.** The first instinct was to rewrite Sabrina's content breakdown and adapt it. We almost did this. The advisor stopped us cold: "Those are @intelligent.designer.ai's hypotheticals. If you write them in first person, you're not telling Michelle's story — you're paraphrasing someone else's invented scenarios." That's the difference between content and plagiarism-adjacent content. A designer audience that's seen the original carousel feels the difference.

**The "match the carousel structure exactly" approach.** The original post went Chat → Cowork → Design → Code. We almost kept that order. The advisor flagged it: "Same order with synonyms isn't yours." We reordered by how you actually use each tool, which made the piece authentic instead of derivative.

**Using Cowork to update the Canva carousel.** You asked if Cowork could auto-update the template. The answer was: we don't need Cowork, the Canva MCP is already connected right here. But when we tried, we hit the real wall: Canva's autofill/dataset feature requires Enterprise plan setup. The standard editor doesn't expose it. So the "automated carousel" path was a dead end for now.

**Uploading images programmatically.** We spent a real chunk of time trying to decode Google Drive images, get Blotato presigned upload URLs, and PUT the files via curl. Got 403s every time. The cloud environment's network policy blocks outbound PUT requests to Blotato's storage. Not a bug. A wall. Once we knew that, we stopped trying to push through it and routed around it.

---

## Step 3: How do the different parts connect?

Think of it like a production line, not a pile of tasks.

**CLAUDE.md** is the operating manual. Every session reads it. It tells Claude who you are, what your workflow is, and what tools exist. Without it, every session starts from zero.

**The task files** (newsletter.md, tweets.md, etc.) are job briefs. You open the right tab, load the right brief, and Claude knows exactly what narrow job it's doing. No confusion across tasks.

**The advisor pattern** is the quality gate. Before any serious writing, you get a stronger model (Opus) to punch holes in the plan. This sits between "outline" and "write" — not after, when it's expensive to fix, but before.

**The newsletter draft → HTML** pipeline is the production sequence. Markdown first (fast to write, easy to edit), then HTML using your template (slow to build but only built once, reused forever).

**Blotato** is the distribution layer. Once text is written, it goes out to three platforms in one session without switching apps. The MCP tools are the pipes.

**CONTENT-ENGINE.md** is the memory. It saves everything we learned — account IDs, template IDs, limitations, the workflow — so the next session doesn't have to rediscover any of it.

Each piece hands off to the next. Remove one and the chain breaks.

---

## Step 4: What tools and frameworks did we use, and why?

**Claude Projects + CLAUDE.md** — not tools exactly, more like the infrastructure that makes everything else persistent. Without a project context, every session is a stranger. With it, every session is a colleague who already knows your business.

**The Advisor pattern** — a subagent call to Opus before writing. Why Opus specifically? Because Sonnet (what runs by default) is fast and capable but will miss strategic problems in a plan. Opus is slower and costs more tokens, but it catches the "this is a near-copy of someone else's work" problem before you've spent an hour writing. Use the big model for judgment calls, the fast model for execution.

**Blotato MCP** — direct API access to your social platforms from inside the Claude session. The alternative is: write content here, copy it, open Blotato in a browser, paste it, format it, post it. MCP collapses that to one tool call. LinkedIn, Threads, and Facebook went live without leaving this session.

**Canva MCP** — we used it to create a fresh design copy from your template. Not full automation (that requires autofill fields), but faster than opening Canva manually. The key thing we learned: the Canva MCP's `create-design-from-brand-template` tool creates a fresh editable copy in seconds. The gap is text injection — that's the Enterprise feature.

**Google Drive MCP** — found your uploaded images by folder ID, got file metadata and download URLs. Didn't get us all the way to Instagram (network wall), but knowing the folder structure was how we even found the 7 files.

---

## Step 5: What tradeoffs did we make?

**Speed vs. authenticity.** The fastest path was to adapt the carousel directly. We traded that speed for authenticity — getting your real examples (contractor meetings, FF&E, vibe coding) meant the piece was slower to write but actually yours.

**Automation vs. reliability.** We could have settled for "give me the text, I'll post it manually" from the start. Instead we tried to automate Instagram all the way through. We learned where the walls are (network policy, auth expiry, no autofill) and now you know exactly what can be automated and what can't. That knowledge is worth the time we spent.

**One section vs. full newsletter.** We wrote one polished section instead of a complete issue. Tradeoff: less content volume, higher quality per section, and a reusable HTML template that makes future issues faster. Right call for establishing the format.

---

## Step 6: What mistakes and dead ends did we hit?

**The em dash problem.** You said "no em dashes" and the first draft had several. Small thing, but it's the kind of thing that makes content feel not-quite-yours. Now it's in the voice guidelines permanently.

**The character limit on Threads.** First Threads post failed — over 500 characters. Didn't know the limit going in. Now it's in the workflow notes.

**Facebook permissions.** First push failed with a permissions error. The original account connection didn't have `pages_read_engagement` + `pages_manage_posts`. Reconnecting with those permissions fixed it. This is a Blotato/Facebook setup issue that bites everyone once.

**Instagram auth expiry.** Instagram invalidates Blotato's session token when you change your password or they refresh security. The post failed mid-workflow. Not predictable, not preventable — just something to expect and reconnect when it happens.

**The presigned URL race condition.** We got presigned upload URLs from Blotato, then took time downloading images from Google Drive, and by the time we tried to upload, the tokens had expired. Lesson: get the presigned URLs last, immediately before uploading — not first.

**The Canva autofill dead end.** We spent time in the Canva editor looking for a data field icon that doesn't exist on standard plans. Should have checked the `get-brand-template-dataset` response first — an empty object means no autofill fields. We did check it, got empty, and then still tried to find the UI. Lesson: trust the API response.

---

## Step 7: What pitfalls should you watch for next time?

**Instagram is the fragile link.** Auth expires, uploads can't be automated from this environment, and the platform is generally hostile to automation. Build your workflow assuming Instagram is always manual and you'll never be surprised.

**"From my own experience" is a promise.** The moment you use that framing, every specific detail has to be yours. Don't let a first draft borrow examples from a source and then claim them as personal experience. The advisor catches this — let it.

**Canva in the browser, not the app.** The desktop app has had persistent issues for you. The browser works. Add this to your standard operating procedure: always open Canva via the create URL in Chrome, never double-click the app.

**Presigned URLs expire fast.** If you're ever trying to upload files programmatically, get the upload URL immediately before uploading, not 10 minutes earlier.

**Threads has a 500 character limit.** LinkedIn doesn't. Facebook doesn't. Threads does. Always write Threads copy separately, keep it tight.

---

## Step 8: What would an expert notice that a beginner would miss?

An expert would notice that the real work in this session wasn't writing — it was **infrastructure**. The newsletter section took maybe 20 minutes to write. The rest of the session was building the pipes that make the next newsletter take 5 minutes.

Most people use Claude to do a task. What Sabrina's screenshot showed — and what we built — is Claude as an operating system. The distinction: a task is a one-time thing. An operating system runs forever, gets faster every time you use it, and stores its own memory.

An expert would also notice the advisor pattern isn't just a quality check. It's a psychological interrupt. It forces a pause between "I have a plan" and "I'm executing the plan." Most content mistakes happen because the execution starts too early. The advisor creates a mandatory gap.

And an expert would notice that the Instagram wall we hit isn't a failure — it's a map. Now you know: LinkedIn/Threads/Facebook are fully automated. Instagram is semi-automated (caption generated, visual manual). That's actually a good content workflow, because Instagram carousels benefit from human visual judgment anyway.

---

## Step 9: What lessons transfer to completely different projects?

**Build the pipes before you need them.** We spent more time on CLAUDE.md, task files, and CONTENT-ENGINE.md than on writing today. That felt slow. It won't feel slow on issue 09, 10, 11. Infrastructure investment pays compound interest.

**The advisor pattern works everywhere.** Any time you're about to commit significant work based on a plan — a client proposal, a project brief, a business decision — get a skeptic to review the plan before you execute. The skeptic can be a person, a different AI model, or even a version of yourself that explicitly tries to break the idea. The pause is the point.

**"Make it mine" is a process, not a decision.** You can't just decide a piece of content is yours. You have to make it yours by injecting your real specifics. The question that unlocks it: "What did I actually experience that's relevant here?" Not "how do I rewrite this differently."

**Know your walls.** Every system has them. The Blotato network wall, the Canva autofill wall, the Instagram auth wall — none of these are bugs, they're boundaries. The productive response isn't to keep pushing; it's to route around and document. Knowing your walls makes you faster, not slower.

**The messy middle is the learning.** The clean outputs (the newsletter, the live posts) are what you ship. But the 403 errors, the character limit failure, the auth expiry, the near-plagiarism catch — that's where today's real value was. Every dead end is a thing you won't have to hit twice.

---

*Written after one session. Applicable for a long time.*
