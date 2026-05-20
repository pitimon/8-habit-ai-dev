---
name: management-talk
description: >
  Reshape engineer-to-engineer content for engineering-org leadership (VPs, directors, PMs, release managers)
  and shape it for the channel — JIRA comment, Slack post, async standup, email, or meeting talking-points.
  Use AFTER `/post-mortem` or any engineering writeup when the same information needs to flow up-the-org.
  Strips function/file/SHA identifiers but keeps JIRA keys, PR numbers, product names, and customer/workload identifiers.
  Maps to H4 (Win-Win — leadership gets the right facts, not a code dump) + H6 (Synergize — engineer + leadership channels reinforce).
user-invocable: true
argument-hint: "[engineering content + target channel: jira|slack|standup|email|meeting]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: any
next-skill: any
---

# Management Talk (เล่าให้ผู้บริหารฟัง ตามรูปแบบช่องสาร)

**Habit**: H4 — Think Win-Win + H6 — Synergize | **Anti-pattern**: Paste a code-heavy JIRA comment into Slack and call it "the update for leadership"

Same source material, **shaped for the channel** it's going to. The audience is engineering-savvy non-engineers — they read product / framework names and cross-reference JIRA keys and PRs, but they do not read code. The channel decides length, formatting, and how much structure to leave on the page.

## When to Use

- After `/post-mortem` or any engineering writeup, when the content needs to flow up-the-org or sideways into product/release.
- User says "write for management / exec / VP / director / PM / release manager".
- User asks for "executive summary", "leadership update", "status update", "talking points for [meeting]".
- User says "make it less technical / less jargony / less code-heavy".
- User asks for "slack version / standup note / email version" of engineering content.

If the channel is unclear after the trigger, ask one short question — _"JIRA, Slack, standup, email, or meeting?"_ — and stop.

## When to Skip

- Audience is true ELI5 / marketing / finance / customer-facing. Engineering-org leadership has technical vocabulary; those audiences don't. Flag and confirm before producing a different rewrite.
- Source content is already non-technical (already a Slack-shape; already an email).
- Engineering content is being written for engineers (use `/post-mortem` or `/review-ai` output as-is).

## Audience — what "engineering-org leadership" means

VPs, directors, PMs, release managers, execs in companies that ship technical products. They want: _what's the state, what does it mean for customers, who owns it, what's next._ They do not want: how the bug works at the function level.

## Tone Rules

**Keep.** Product names, framework names, team-owned component names, JIRA keys, PR numbers, customer/workload identifiers (`PyTorch`, `vLLM`, `Llama-2-70B`, `JIRA-12345`, `PR #95`). These are the bridge between engineering and leadership tracking.

**Strip.** Function names, file paths, struct fields, commit SHAs, code expressions, env var names, line numbers, internal data-structure jargon (`session-start.sh:42`, `scratchBuf`, `0e0a6bac`). None of this is actionable to the audience.

**Translate.** Mechanism → one or two sentences of plain-English cause-and-effect. Not _"reads from `scratchBuf == NULL`"_ but _"reads from an uninitialized buffer and waits forever for a signal that never arrives."_ Translate without lying — a race stays a race.

**Don't over-strip.** Engineering-org leadership reads concept-level technical vocabulary fluently — _race condition, synchronization, fast-path, workaround, driver, kernel_. Line: _concept exists and matters_ (keep) vs _here's the function/SHA_ (strip). Replacing "race condition" with "timing issue" patronizes the reader.

**Bias toward** active voice, concrete subjects, short paragraphs. _"We found the bug. Alex wrote the fix. PR is up for review."_ beats _"The root cause has been identified and a fix has been authored."_

**Avoid:** hedging ("we believe", "appears to") — state it or drop it. Re-stating the obvious. Telling leadership how to prioritize. Engineering-process minutiae (bisect runs, GDB sessions) — they care that you found it, not how.

## Channel Shapes

Same content, different shell. Pick the shape that matches where it's going.

### JIRA comment / written status report

Full structured block. Bolded section labels. Easy to scan from the ticket page.

Building blocks (use as many as fit):

- **Status / TL;DR.** One bolded line. Reader can stop here and have the right answer. _"Fixed pending merge."_ / _"Root cause unknown — investigating."_ / _"Blocked on vendor."_
- **Impact.** Who's affected, how badly, what they see. Customer / workload / product terms, not test-suite terms.
- **What broke.** Short paragraph. Plain-English mechanism, one level of why, no code identifiers.
- **Why now / how it slipped through.** Optional. Include when leadership will ask anyway.
- **Owner.** Person + team + their PR/branch/JIRA artifact. One link, not five.
- **Next steps.** Concrete, near-term, ordered.
- **Workaround / mitigation.** If customers are hitting it now, what can they do today? One sentence.
- **Risk.** Optional. Real risks only. Don't manufacture risk to look thorough.

### Slack — channel post or DM

Single message, no walls of text. Heavy bolded section labels read as "I escaped from JIRA" — don't.

- One **bolded TL;DR** as the first line.
- 2–4 short bullets underneath: impact, owner+link, next step. Drop blocks that don't apply.
- One link, embedded inline. Not a link wall.
- No greeting, no signoff. The channel is the context.
- If it's a **thread reply**, lose the TL;DR — just lead with the answer.

Length target: under ~80 words for a top-level post; under ~40 for a thread reply.

### Async standup note

The audience scans 10 of these in 30 seconds. Front-load the verb.

- 1–3 lines, max.
- Pattern: _"\<state\> \<thing\>. \<owner if not me\>. \<next\>."_
- Examples:
  - _"Fixed verbosity-adaptation regression on fresh installs (Issue #92). PR #95 in review. Backport to v2.16.6 next."_
  - _"Still chasing the `/research` ordering bug. Reproducer reliable now; bisecting. No ETA yet."_
- No bullets, no bolded labels. The format **is** the sentence.

### Email — internal exec / cross-team

Subject line is half the value.

- **Subject:** the TL;DR rewritten as a noun phrase. _"Verbosity adaptation broken on fresh installs: fix in review (Issue #92)."_
- **Greeting:** match the recipient register (_Hi Sam,_ / _Hi all,_).
- **Body:** the JIRA-comment shape, but as flowing paragraphs separated by blank lines rather than bolded section labels. Two or three paragraphs is plenty.
- **Sign off** with the next decision point that needs the recipient's attention, if any. If none, a plain _"— [Name]"_ is fine.

### Meeting talking-points

You're going to _say_ this, not show it.

- Bullet list, max one short clause per bullet.
- Order is the order you'll speak in.
- Include the numbers/keys you want to reference out loud, in the bullet itself.
- Skip prose. _"Fresh-install users got the wrong verbosity."_ / _"Root cause: hook swallowed an error."_ / _"Fix in PR #95."_ / _"Backport to v2.16.6 once it lands."_

## Worked Example — Same bug, three channels

**Engineering source** (`/post-mortem` output for Issue #92, the hook false-pass bug):

> **Root cause.** `hooks/session-start.sh:42` wrapped `cat ~/.claude/habit-profile.md` in `|| true`. On fresh installs the file is absent, `cat` exited 1, `|| true` swallowed it, and the hook reported `status: ready` while emitting no verbosity directive. Downstream skills defaulted to Dependence-level verbosity for Significance-profile users.

### As a JIRA comment

> **Status: Fixed pending merge.** Bug found, fix validated, PR up for review.
>
> **Impact:** Users on fresh installs were getting full-ceremony output from skills like `/research`, regardless of their calibration profile. Affects every first-time user — calibration ran fine, but the verbosity adaptation didn't actually apply.
>
> **What broke:** The session-start hook silently swallowed an error when reading the user's calibration profile. When the file was absent (typical first-run state), the hook reported success but emitted no verbosity directive, so skills defaulted to the most verbose mode.
>
> **Why now:** Latent since v2.7.0 when verbosity adaptation shipped. Every fresh-install user hit it, but no error surfaced — so it accumulated as "the plugin is just chatty" rather than a bug report.
>
> **Owner:** @pitimon. PR #95.
>
> **Next steps:** code review → merge → release v2.16.6 with the fix.
>
> **Workaround:** Run `/calibrate` once to populate the profile file. After that, verbosity adapts correctly until the fix ships.

### As a Slack post

> **Verbosity adaptation broken on fresh installs is fixed pending merge.** (Issue #92)
>
> - Hook swallowed a missing-profile error → skills defaulted to full ceremony → every first-time user was affected. Latent since v2.7.0.
> - Owner: @pitimon, PR #95 in review.
> - Workaround until merge: run `/calibrate` once.

### As a standup note

> Fixed verbosity-adaptation regression on fresh installs (Issue #92). PR #95 in review. Backport to v2.16.6 next.

What changed between channels: same diagnosis, same owner, same next step. JIRA gets every block. Slack drops "why now" and the workaround detail. Standup keeps just state + key + owner + next. **None of them mention `session-start.sh:42` or `|| true`.**

## Source Material

The input is one of:

1. **A ticket / issue key** (e.g. `Issue #92`) → fetch context; reframe the most recent substantive comment.
2. **Pasted technical text** → use directly.
3. **The current conversation** → if you (or the user) just produced engineering content and the user now says _"now in slack"_ / _"now for the VP,"_ reuse what's in context.

If the source is ambiguous, ask one question and stop.

## Output Flow

1. **Confirm the channel** if it's not stated.
2. **Produce the draft** as a single chat block, formatted as the channel would render it.
3. **Ask where it goes:**
   - Default: print-only — the user copies it.
   - **Never post to Slack, email, or any non-JIRA channel from this skill.** Hand the draft to the user; they post it.
   - JIRA back-post: only if the user explicitly says so, with explicit _"post it"_ / _"go ahead"_ approval first.
4. **One iteration is normal, three is a smell.** If the user is on the third revision, ask what specific framing/audience assumption you're missing — don't keep tweaking blindly.

## Handoff

- **Expects from predecessor**: An engineering-audience writeup. Often follows `/post-mortem` (formal RCA → leadership reframe), `/reflect` (retrospective → status update), or `/ai-dev-log` (transparency log → exec summary).
- **Produces for successor**: A channel-shaped draft for the user to post. No automated handoff downstream — the user owns the post.

## H4 + H6 Checkpoint

- **H4 (Win-Win)**: "Does this update give leadership exactly the facts they need to decide — no more, no less?" Stripping too far (over-stripping technical concepts) patronizes them. Leaving too much (function names, SHAs) wastes their time.
- **H6 (Synergize)**: "Does the engineer channel and the leadership channel reinforce, or do they tell two different stories?" Same diagnosis, same owner, same next step — only the shell changes. If the leadership version sounds like a different bug, you rewrote too much.

## Definition of Done

- [ ] Channel confirmed (JIRA / Slack / standup / email / meeting) before drafting
- [ ] Output formatted as the channel would render it (not pasted JIRA block into Slack)
- [ ] Product names, JIRA keys, PR numbers, workload identifiers preserved
- [ ] Function names, file paths, line numbers, SHAs stripped
- [ ] Mechanism translated to plain-English cause-and-effect (no code expressions)
- [ ] No invented facts — if the engineering source says "unknown," the reframe says "unknown"
- [ ] Print-only by default; never auto-post to non-JIRA channels

## Rules

- **Never invent facts.** Speculation stays speculation in the reframe.
- **Never strip JIRA keys, PR numbers, workload names** — they're the cross-reference bridge.
- **Never invent owners.** Ask if absent — don't guess from `git blame`.
- **Sign-off before posting to JIRA.** Print-only needs no approval.
- **Never post to Slack/email/non-JIRA channels.** Hand the draft over; the user posts.
- **No advocacy.** Status update, not recommendation memo.

## Attribution

"Same content, different shell" pattern and 5-channel taxonomy inspired by [`thananon/9arm-skills/management-talk`](https://github.com/thananon/9arm-skills). Adapted into 8-habit voice with original worked example tied to a real issue.

## Further Reading

Load `${CLAUDE_PLUGIN_ROOT}/habits/h4-win-win.md` for the full H4 principle.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h6-synergize.md` for the full H6 principle.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards.
