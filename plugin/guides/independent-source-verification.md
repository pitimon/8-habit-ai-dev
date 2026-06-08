# Independent-Source Verification

> A root cause believed from a **single observation source** is unverified.
> Confirm it from an **independent** source — a different tool, command, or
> vantage — and when sources disagree, **reconcile** rather than pick.

This guide is the canonical case study and rule for one specific failure mode:
a **confident-but-wrong root cause** that survives every author-side gate because
each gate reuses the same contaminated observation. It is **discipline, not
engine** — parallel fan-out is one delivery mechanism, but the portable rule is
independence-of-source (see [ADR-021](../docs/adr/ADR-021-dynamic-workflow-positioning.md);
the workflow engine itself lives in `claude-governance`).

## Why author-side gates can't catch this alone

`advisor`, a `governance-reviewer` pass, `/cross-verify`, `/reflect`, and
`/post-mortem` all operate on **the author's evidence**. If that one observation
is mis-read, every gate ratifies the same wrong conclusion — they diverge on
_interpretation_, never on the _source_. The artifact under review looks
internally consistent, so reviewers see no divergence to flag. The only escape
is a probe from a source the author did **not** use.

## Case study — memforge staging worker (2026-05-29/30)

1. **Symptom**: staging worker reported version `1.17.0` after a `1.17.1` deploy.
2. **Solo investigation** read the version with a single tool
   (`docker exec … grep VERSION`) → confident root cause: _"buildx cache baked a
   stale `config.ts`."_ Acted on it — `--no-cache` rebuild, force-pull, chased a
   "ghost container."
3. That wrong cause **survived `advisor`, a `governance-reviewer` pass, a merged
   PR, and a written `/reflect` lesson** — all reused the same single
   contaminated observation, so none could diverge from it.
4. Probes from **independent sources contradicted each other**:
   `docker run <img>` = `1.17.1` (the _image_) vs `docker exec <container>` =
   `1.17.0` (the _running container_). **Reconciling** the contradiction surfaced
   the real cause: the worker **bind-mounts host `scripts/` over `/app`**, so it
   runs the host file; the deploy bumped `IMAGE_TAG` but skipped the script rsync.
   The image was correct all along.
5. **Verified**: updating the host file flipped `/health` to `1.17.1` instantly.
   The earlier fix and lesson were then corrected.

## The reusable tell

> **`docker run <img>` ≠ `docker exec <container>` → a mount overrides the image.**

Concretely: if `docker run --entrypoint sh $IMG -c 'grep VERSION …'` differs from
`docker exec $CONTAINER grep VERSION …`, a volume/bind-mount is overriding the
image — inspect `.Mounts` (`docker inspect <c> --format '{{range .Mounts}}…'`)
**before** assuming an image/registry/cache problem.

## The general signal — when to demand an independent source

Escalate from solo to independent-source verification when **any** of these hold:

- The leading hypothesis's fix **doesn't fully explain** the symptom.
- Two observations **conflict** and you're tempted to pick the one that fits.
- The entire chain of evidence comes from **one tool, command, or vantage**.
- You're about to act on a diagnosis that has only been _reviewed_, never
  _re-observed_ from a second angle.

This is not docker-specific. The same pattern produced a non-infra failure: an
OCR misread (`MQIPT` → `MQTT`) propagated through four artifacts and two PRs
because each downstream artifact cited an upstream one — "triangulated
confirmation" that was really a single source seen five times. The fix in both
cases was the same: go back to a source the chain had **not** consumed.

## The discipline in one line

When you believe a root cause, ask _"does all my evidence for this come from a
single source?"_ If yes, it is a hypothesis, not a finding. Confirm it from an
independent source; when sources disagree, reconcile before you fix.

## Boundary (ADR-021)

This guide owns the **discipline** — independence-of-source verification and
contradiction-reconciliation. It does **not** own the **engine** (parallel
agent orchestration, runtime coordination), which stays in `claude-governance`.
Fan-out is _a_ way to gather independent observations; it is not _the_ rule.

---

_Source lessons (author's private retrospectives; cases reproduced in full
above): `2026-05-29-measured-coverage-gap-deploy-pipeline.md` (memforge
bind-mount) and `2026-05-21-mqipt-misread-correction.md` (OCR propagation)._
