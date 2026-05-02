# Harness Engineering — and where 8-habit-ai-dev lives in the picture

> _"Anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."_
> — Mitchell Hashimoto, _My AI Adoption Journey_, 5 February 2026

---

## TL;DR / สรุปสั้น

**EN.** Harness Engineering is the third era of AI-assisted development — after Prompt Engineering and Context Engineering. It is the discipline of designing the entire environment an agent operates within: the guides that direct it, the sensors that catch its mistakes, and the feedback loops that prevent recurrence. `8-habit-ai-dev` is a concrete harness implementation focused on workflow discipline, with **242 verifiable assertions** plus a 17-question cross-verification audit.

**TH.** Harness Engineering คือยุคที่ 3 ของการพัฒนาด้วย AI ต่อจาก Prompt Engineering และ Context Engineering. เป็นระเบียบในการออกแบบ "สภาพแวดล้อมทั้งระบบ" ที่ agent ทำงานภายใต้ — guide ที่ชี้นำ, sensor ที่ตรวจจับความผิดพลาด, และ feedback loop ที่ป้องกันการพลาดซ้ำ. `8-habit-ai-dev` คือ harness implementation ที่เน้น workflow discipline พร้อม **assertion ที่ verify ได้ 242 ข้อ** และ cross-verification audit 17 คำถาม

---

## What is Harness Engineering? / Harness Engineering คืออะไร?

### Origin of the term / ต้นทางของคำ

**EN.** The term was coined by **Mitchell Hashimoto** (HashiCorp / Terraform creator) in his **5 February 2026** blog post _My AI Adoption Journey_. He defined the practice as: _"the idea that anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."_ He showed two complementary patterns: implicit prompting via `AGENTS.md` updates, and programmed tools (e.g. screenshot utilities, filtered test runners) paired with documentation updates. Days later an OpenAI engineering report cemented the term in industry vocabulary, and at the **AI Engineer World's Fair (April 2026)** three independent speakers named "agent harness" + "context engineering" as priority #1 for production reliability.

**TH.** คำนี้ถูกตกผลึกโดย **Mitchell Hashimoto** (ผู้สร้าง Terraform / HashiCorp) ใน blog post วันที่ **5 กุมภาพันธ์ 2026** ชื่อ _My AI Adoption Journey_. เขานิยามไว้ว่า _"แนวคิดที่ว่าทุกครั้งที่ agent ทำผิดพลาด คุณใช้เวลาออกแบบทางแก้เพื่อให้มันไม่พลาดแบบนั้นอีก"_. เขายกตัวอย่าง 2 รูปแบบ: implicit prompting ผ่านการ update `AGENTS.md`, และ programmed tools (เช่น screenshot utility, filtered test runner) ที่ทำงานคู่กับเอกสาร. ไม่กี่วันถัดมา OpenAI ออก engineering report ตอกย้ำคำนี้, และที่งาน **AI Engineer World's Fair (เมษายน 2026)** มีวิทยากร 3 คนแยกกันชี้ว่า "agent harness" + "context engineering" คือ priority อันดับ 1 ของ production reliability

### The three layers / สามชั้นที่ซ้อนกัน

**EN.** Hashimoto's framing places harness as the outermost of three layers. The popular analogy:

| Layer       | Computer analogy | Question it answers                                                 |
| ----------- | ---------------- | ------------------------------------------------------------------- |
| **Model**   | CPU              | _What can the brain compute?_                                       |
| **Context** | RAM              | _What does it know right now?_                                      |
| **Harness** | Operating System | _What can it do, how is it checked, what happens when it deviates?_ |

The three layers compose; they do **not** replace one another. A good Harness Engineer still writes good prompts and assembles good context — the role just sits at a higher altitude.

**TH.** Hashimoto วาง harness เป็นชั้นนอกสุดของ 3 ชั้น. analogy ที่ใช้กันทั่วไป:

| ชั้น        | analogy          | คำถามที่ตอบ                                        |
| ----------- | ---------------- | -------------------------------------------------- |
| **Model**   | CPU              | _สมองคำนวณอะไรได้?_                                |
| **Context** | RAM              | _ตอนนี้รู้อะไร?_                                   |
| **Harness** | Operating System | _ทำอะไรได้บ้าง, ตรวจอย่างไร, เกิดอะไรขึ้นถ้า off?_ |

ทั้ง 3 ชั้น "ครอบกัน" ไม่ใช่ "แทนกัน". Harness Engineer ที่ดียังเขียน prompt ดีและประกอบ context เก่ง — แค่ขอบเขตของบทบาทใหญ่กว่า

---

## The lineage — three primary sources / ที่มาทางวิชาการ

| #   | Source                                                                                                           | Contribution                                         | Date       | Verified URL                                                                   |
| --- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ---------- | ------------------------------------------------------------------------------ |
| 1   | **Hashimoto** — _My AI Adoption Journey_                                                                         | Coined "Engineer the Harness", definition + practice | 5 Feb 2026 | [mitchellh.com](https://mitchellh.com/writing/my-ai-adoption-journey)          |
| 2   | **Lee, Nair, Zhang, Lee, Khattab, Finn** — _Meta-Harness: End-to-End Optimization of Model Harnesses_ (Stanford) | Quantitative evidence + automated harness search     | 2026       | [arxiv 2603.28052](https://arxiv.org/abs/2603.28052)                           |
| 3   | **Böckeler** (Thoughtworks) — _Harness engineering for coding agent users_                                       | Taxonomy: feedforward guides + feedback sensors      | 2 Apr 2026 | [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html) |

### ⚠️ Honest correction on the viral "3% vs 28–47%" framing / หมายเหตุเรื่องเลข viral

**EN.** A widely-quoted summary claims Stanford research found that "prompt tuning yields ≤3% improvement while harness changes yield 28–47%." **This number does not appear in the actual Stanford paper** (Lee et al., _Meta-Harness_, arxiv 2603.28052). The figures the paper actually reports are:

- **+7.7 percentage points** on text classification — using **4× fewer context tokens**
- **+4.7 percentage points** on math reasoning (IMO-level problems, averaged across 5 held-out models)
- **State-of-the-art** on TerminalBench-2 agentic coding using Claude Haiku 4.5

The **direction** of the popular claim (harness >> prompt tuning) is correct. The specific "28–47%" number appears to be an aggregator paraphrase, not a primary citation. For formal documents, prefer the real figures from arxiv 2603.28052.

**TH.** มีตัวเลข viral ที่ถูก quote กันเยอะว่า "Stanford พบ prompt tuning ดีขึ้นได้สูงสุด 3% แต่ harness ดีขึ้น 28–47%". **ตัวเลขนี้ไม่ปรากฏในเปเปอร์ Stanford ตัวจริง** (Lee et al., _Meta-Harness_, arxiv 2603.28052). ตัวเลขที่เปเปอร์รายงานจริง:

- **+7.7 percentage points** บน text classification — ใช้ token น้อยลง **4 เท่า**
- **+4.7 percentage points** บน math reasoning (โจทย์ระดับ IMO, เฉลี่ย 5 โมเดลที่ hold out)
- **SOTA** บน TerminalBench-2 agentic coding ด้วย Claude Haiku 4.5

**ทิศทาง** ของ claim ถูก (harness >> prompt tuning). แต่เลข "28–47%" น่าจะเป็น paraphrase ของ aggregator ไม่ใช่ primary citation. ในเอกสารทางการ ใช้ตัวเลขจริงจาก arxiv 2603.28052 ดีกว่า

---

## 8-habit-ai-dev as a Harness Implementation / ในฐานะ Harness Implementation

**EN.** Böckeler's taxonomy splits a harness into two complementary halves:

- **Feedforward guides** — anticipatory controls. Set context and conventions **before** the agent acts.
- **Feedback sensors** — self-correction mechanisms. Detect deviations **after** the agent has acted.

The plugin maps cleanly onto both halves. Every row below carries a verifiable file path inside this repository.

**TH.** Böckeler แบ่ง harness เป็น 2 ส่วนที่เสริมกัน:

- **Feedforward guides** — ตัวกำหนดทิศ "ก่อน" agent ลงมือ (set context + convention)
- **Feedback sensors** — กลไก self-correction "หลัง" agent ทำเสร็จ (ตรวจจับการ deviate)

plugin map ลงทั้ง 2 ฝั่งได้ครบ. ทุกแถวด้านล่างมี path ที่ verify ได้ใน repo นี้

### Feedforward guides

| #   | Component                                    | Path                                                   | What it does                                                                            |
| --- | -------------------------------------------- | ------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| 1   | 8-Habit playbook (auto-loaded every session) | `rules/effective-development.md`                       | Defines the WHY behind every workflow step                                              |
| 2   | Session-start hook                           | `hooks/session-start.sh`                               | Injects 7-step reminder + maturity-adapted verbosity directive into every conversation  |
| 3   | 17 on-demand process skills                  | `skills/*/SKILL.md` (17 directories)                   | One per workflow step + standalone (`/cross-verify`, `/calibrate`, `/reflect`, etc.)    |
| 4   | Habit + guide reference content              | `habits/h*.md`, `guides/*.md`                          | Loaded on-demand by skills (token-efficient — never injected at session start)          |
| 5   | Maturity profile (per-user calibration)      | `~/.claude/habit-profile.md` (written by `/calibrate`) | Drives runtime verbosity adaptation across all skills (Dependence → Significance)       |
| 6   | Project + user CLAUDE.md / AGENTS.md         | `CLAUDE.md`, `AGENTS.md`, `~/.claude/CLAUDE.md`        | Hashimoto's "implicit prompting through documentation" pattern, applied at three scopes |

### Feedback sensors

| #   | Component                          | Path                                                                                      | What it catches                                                                                                                 |
| --- | ---------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| 7   | Structural validators (74 checks)  | `tests/validate-structure.sh`                                                             | File structure, frontmatter, required sections                                                                                  |
| 8   | Content validators (132 checks)    | `tests/validate-content.sh`                                                               | Version-4-files consistency, README "What's New" drift, sidebar consistency, anchor integrity                                   |
| 9   | Auxiliary test scripts (36 checks) | `tests/test-skill-graph.sh`, `tests/test-verbosity-hook.sh`                               | Skill-graph integrity, hook output regression coverage                                                                          |
| 10  | Read-only review agent             | `agents/8-habit-reviewer.md`                                                              | Audits without mutating files (model: `sonnet`, tools: `Read`/`Glob`/`Grep`)                                                    |
| 11  | Pre-commit cross-verification      | `skills/cross-verify/SKILL.md`                                                            | 17-question 8-Habit audit before any commit                                                                                     |
| 12  | Find→Fix→Re-Verify loop            | `skills/review-ai/SKILL.md`                                                               | Forces re-grep after every fix to prevent partial-fix regressions                                                               |
| 13  | Cross-session lesson persistence   | `~/.claude/lessons/` (written by `/reflect`, retrieved by `/research` and `/build-brief`) | Closes Hashimoto's "AI has no memory across sessions" gap by writing lessons to disk and loading them on the next relevant task |

**EN.** Counted: **242 verifiable assertions** across 4 test scripts, plus the 17-question cross-verification audit. Every one is a structural correction, not a "please remember." The v2.14.1 patch (issue #157) is a textbook example: a user reported the README "What's New" section had drifted; the fix was **harden `validate-content.sh:578`** (a header-anchored grep instead of a badge-URL grep), not just "backfill the README this once." The next time someone forgets, the validator catches it before merge.

**TH.** นับรวม: **242 assertion ที่ verify ได้** ผ่าน 4 test script บวก cross-verification 17 ข้อ. ทุกข้อคือการแก้เชิงโครงสร้าง ไม่ใช่ "โปรดจำไว้". patch v2.14.1 (issue #157) คือตัวอย่างคลาสสิก: user แจ้งว่า README "What's New" drift ไป → fix คือ **harden `validate-content.sh:578`** (grep แบบ anchor ที่ section header แทน grep ที่ badge URL) ไม่ใช่แค่เติม README ให้ครั้งเดียว. ครั้งหน้าถ้าใครลืม validator จะจับได้ก่อน merge

---

## "Where are you working?" — Self-checklist / "ตอนนี้คุณอยู่ชั้นไหน?"

### Layer 1 — Prompt Engineer

**EN.** You are in the Prompt layer if most of these match:

- [ ] You iterate by editing the wording of individual messages
- [ ] You measure success per-conversation, not across many runs
- [ ] You don't have a project file that auto-loads context every session
- [ ] When the agent makes a mistake, your fix is to "remind it next time"
- [ ] You have no automated check that runs without you asking

**TH.** คุณอยู่ชั้น Prompt ถ้าข้อพวกนี้ตรงเป็นส่วนใหญ่:

- [ ] iterate ด้วยการแก้คำพูดในข้อความเป็นข้อๆ
- [ ] วัดความสำเร็จเป็นรายบทสนทนา ไม่ใช่ข้าม run
- [ ] ไม่มีไฟล์ project ที่ auto-load context ทุก session
- [ ] เวลา agent พลาด คุณแก้ด้วยการ "บอกครั้งหน้าอย่าทำ"
- [ ] ไม่มี automated check ที่รันโดยไม่ต้องสั่ง

### Layer 2 — Context Engineer

**EN.** You are in the Context layer if most of these match:

- [ ] You maintain a `CLAUDE.md` / `AGENTS.md` / system prompt that loads every session
- [ ] You curate the files included in the agent's working set
- [ ] You manage context-window budgets explicitly (token counts, summarization, RAG)
- [ ] You add to the loaded context when an issue recurs
- [ ] But: corrections still rely on you remembering to update the docs

**TH.** คุณอยู่ชั้น Context ถ้าข้อพวกนี้ตรงเป็นส่วนใหญ่:

- [ ] ดูแล `CLAUDE.md` / `AGENTS.md` / system prompt ที่ load ทุก session
- [ ] curate file ที่เข้า working set ของ agent
- [ ] จัดการ context window budget ชัดเจน (token count, summarization, RAG)
- [ ] เพิ่มของเข้า context เวลาเจอปัญหาซ้ำ
- [ ] แต่: การแก้ยังอาศัยคุณจำได้ว่าต้อง update doc

### Layer 3 — Harness Engineer

**EN.** You are in the Harness layer if most of these match:

- [ ] You have automated checks that block bad behavior even when no human is watching (session hooks, pre-commit validators, reviewer agents)
- [ ] You treat each agent mistake as a system bug — the fix is a new validator / skill / hook, not a "remember to…" note
- [ ] You version your guides, validators, and decision records (ADRs)
- [ ] You measure agent quality at the **system level** (validator pass rate, regression count) not per-conversation
- [ ] You have **cross-session memory** — past lessons retrievable without you re-typing them

**TH.** คุณอยู่ชั้น Harness ถ้าข้อพวกนี้ตรงเป็นส่วนใหญ่:

- [ ] มี automated check ที่บล็อกพฤติกรรมแย่ได้แม้ไม่มีคนดู (session hook, pre-commit validator, reviewer agent)
- [ ] จัดการความผิดพลาด agent เป็น system bug — แก้คือเพิ่ม validator/skill/hook ใหม่ ไม่ใช่ note "อย่าลืม..."
- [ ] versioning guide, validator, และ decision record (ADR)
- [ ] วัด agent quality ระดับ **system** (validator pass rate, regression count) ไม่ใช่รายบทสนทนา
- [ ] มี **cross-session memory** — บทเรียนเก่าเรียกใช้ได้โดยไม่ต้องพิมพ์ใหม่

**EN.** If most boxes in Layer 3 tick, you are already a Harness Engineer — possibly before you knew the term. The point of naming the role is not gatekeeping; it is giving the practice a name so it can be discussed, taught, and improved.

**TH.** ถ้าติ้กส่วนใหญ่ใน Layer 3 ได้ — คุณเป็น Harness Engineer แล้ว อาจจะก่อนรู้จักคำนี้ด้วยซ้ำ. ประเด็นของการมี "ชื่อ" ไม่ใช่ gatekeep ใคร — มันคือการให้ชื่อบทบาท เพื่อให้ practice ถูก discuss, สอน, และพัฒนาต่อได้

---

## Further reading / อ่านต่อ

- [Architecture](Architecture) — how the plugin is wired internally / โครงสร้างภายใน plugin
- [Maturity Model](Maturity-Model) — Dependence → Independence → Interdependence → Significance
- [Vibe Coding vs Structured](Vibe-Coding-vs-Structured) — the failure mode this harness exists to prevent / failure mode ที่ harness นี้ป้องกัน
- [Habits Reference](Habits-Reference) — the 8 habits that drive every harness component / 8 habit ที่ขับเคลื่อนทุก component

## Sources

1. Hashimoto, M. _My AI Adoption Journey_, 5 February 2026 — <https://mitchellh.com/writing/my-ai-adoption-journey>
2. Lee, Y., Nair, R., Zhang, Q., Lee, K., Khattab, O., Finn, C. _Meta-Harness: End-to-End Optimization of Model Harnesses_, 2026 — <https://arxiv.org/abs/2603.28052>
3. Böckeler, B. _Harness engineering for coding agent users_, Thoughtworks, 2 April 2026 — <https://martinfowler.com/articles/harness-engineering.html>
