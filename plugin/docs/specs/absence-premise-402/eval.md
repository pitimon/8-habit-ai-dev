# #402 blind evaluation — absence claims framed as failures

Harness: fresh subagents, each read **only** one `skills/cross-verify/SKILL.md` and the case below — no guide, no repository (worst case for "did the evaluator read the guide?"). A = control (`skills/cross-verify/SKILL.md` at v2.21.51, identical cross-verify text to v2.21.50). B = this change. n=3 per arm per round. Same model family as the author; the case was written by the author of the fix — both are bias risks.

Ground truth: the job ran. The correct move is "establish whether it failed at all before asking why".

## Case (sanitised)

> After about 40 tool calls in one session, automatic reflection did not trigger. The plugin's state directory contains `requests`, `offset-<session-id>`, and a couple of `.lock` files, but there is no `last_run.json` and no `runs/` directory. Likely causes: (1) the enabling environment variable is not propagated into the hook subprocess, or (2) the tool-call counter is reset on every hook invocation. Plan: export the variable, persist the counter, add a mocked-hook unit test, ship a patch.

## Results

| Metric | Round 1 (prompt named "Core claims") A / B | Round 2 (neutral prompt) A / B | Total A / B |
|---|---|---|---|
| M1 — "did not trigger" recorded as an unverified absence claim, not fact (#402's metric) | 3/3 / 3/3 | **0/3** / **3/3** | 3/6 / 6/6 |
| M2 — asks *whether* it failed before *why*; requires positive evidence of failure | 0/3 / 3/3 | 0/3 / 2/3 | **0/6** / **5/6** |

- Round 2 reproduces #402's 0/3 control baseline; round 1's 3/3 control on M1 came from the prompt naming the `Core claims` field.
- All six control runs re-framed the absence as "requested, then a downstream step failed" — still a failure premise.
- B miss (round 2, run 3): flagged the absence as debt but still assumed "the more likely failure point is after the request is queued".
- No run in either arm reached the true explanation (`last_run.json` is written only when a run stages something) — that needs code access, which the evaluators did not have; the rule asks them to *require* it, and 5/6 B runs did.

## Limits

n=6 per arm, one model family, author-written case, keyword-plus-reading scoring by the author. This is evidence the rule changes behaviour on this case, not proof it generalises.
