# Harness Engineering — และที่ของ 8-habit-ai-dev ในภาพรวม

> _"Anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."_
> — Mitchell Hashimoto, _My AI Adoption Journey_, 5 กุมภาพันธ์ 2026
>
> _"ทุกครั้งที่คุณพบว่า agent ทำผิดพลาด ใช้เวลาออกแบบทางแก้เพื่อให้มันไม่พลาดแบบนั้นอีก"_

---

## สรุปสั้น

**Harness Engineering** คือยุคที่ 3 ของการพัฒนาด้วย AI ต่อจาก **Prompt Engineering** และ **Context Engineering**. เป็นระเบียบในการออกแบบ "สภาพแวดล้อมทั้งระบบ" ที่ agent ทำงานภายใต้ — guide ที่ชี้นำ, sensor ที่ตรวจจับความผิดพลาด, และ feedback loop ที่ป้องกันการพลาดซ้ำ

`8-habit-ai-dev` คือ harness implementation ที่เน้น workflow discipline พร้อม **assertion ที่ verify ได้ 242 ข้อ** และ cross-verification audit 17 คำถาม

---

## Harness Engineering คืออะไร?

### ต้นทางของคำ

คำนี้ถูกตกผลึกโดย **Mitchell Hashimoto** (ผู้สร้าง Terraform / HashiCorp) ใน blog post วันที่ **5 กุมภาพันธ์ 2026** ชื่อ _My AI Adoption Journey_. เขานิยามไว้ว่า:

> "แนวคิดที่ว่าทุกครั้งที่ agent ทำผิดพลาด คุณใช้เวลาออกแบบทางแก้เพื่อให้มันไม่พลาดแบบนั้นอีก"

เขายกตัวอย่าง 2 รูปแบบ:

1. **Implicit prompting** ผ่านการ update `AGENTS.md` — เพิ่มเอกสารชี้นำเวลา agent ทำพลาดซ้ำ
2. **Programmed tools** — สร้าง script เฉพาะทาง (เช่น screenshot utility, filtered test runner) คู่กับเอกสาร เพื่อให้ agent verify งานของตัวเองได้

ไม่กี่วันถัดมา OpenAI ออก engineering report ตอกย้ำคำนี้, และที่งาน **AI Engineer World's Fair** (เมษายน 2026) มีวิทยากร 3 คนแยกกันชี้ว่า "agent harness" + "context engineering" คือ priority อันดับ 1 ของ production reliability

### สามชั้นที่ซ้อนกัน

Hashimoto วาง harness เป็นชั้นนอกสุดของ 3 ชั้น. analogy ที่ใช้กันทั่วไป:

| ชั้น        | analogy          | คำถามที่ตอบ                                        |
| ----------- | ---------------- | -------------------------------------------------- |
| **Model**   | CPU              | _สมองคำนวณอะไรได้?_                                |
| **Context** | RAM              | _ตอนนี้รู้อะไร?_                                   |
| **Harness** | Operating System | _ทำอะไรได้บ้าง, ตรวจอย่างไร, เกิดอะไรขึ้นถ้า off?_ |

ทั้ง 3 ชั้น **"ครอบกัน" ไม่ใช่ "แทนกัน"**. Harness Engineer ที่ดียังเขียน prompt ดีและประกอบ context เก่ง — แค่ขอบเขตของบทบาทใหญ่กว่า

---

## ที่มาทางวิชาการ — 3 source หลัก

| #   | Source                                                                                                           | ที่ contribute                                  | วันที่       | Verified URL                                                                   |
| --- | ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- | ------------ | ------------------------------------------------------------------------------ |
| 1   | **Hashimoto** — _My AI Adoption Journey_                                                                         | ตกผลึก "Engineer the Harness", นิยาม + practice | 5 ก.พ. 2026  | [mitchellh.com](https://mitchellh.com/writing/my-ai-adoption-journey)          |
| 2   | **Lee, Nair, Zhang, Lee, Khattab, Finn** — _Meta-Harness: End-to-End Optimization of Model Harnesses_ (Stanford) | หลักฐานเชิงปริมาณ + automated harness search    | 2026         | [arxiv 2603.28052](https://arxiv.org/abs/2603.28052)                           |
| 3   | **Böckeler** (Thoughtworks) — _Harness engineering for coding agent users_                                       | Taxonomy: feedforward guides + feedback sensors | 2 เม.ย. 2026 | [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html) |

### ⚠️ หมายเหตุเรื่องเลข viral "3% vs 28-47%"

มีตัวเลขที่ถูก quote กันเยอะว่า _"งานวิจัย Stanford พบว่า prompt tuning ดีขึ้นได้สูงสุด 3% แต่ harness ดีขึ้น 28-47%"_

**ตัวเลขนี้ไม่ปรากฏในเปเปอร์ Stanford ตัวจริง** (Lee et al., _Meta-Harness_, arxiv 2603.28052). ตัวเลขที่เปเปอร์รายงานจริง:

- **+7.7 percentage points** บน text classification — ใช้ token น้อยลง **4 เท่า**
- **+4.7 percentage points** บน math reasoning ระดับ IMO (เฉลี่ย 5 โมเดลที่ hold out)
- **SOTA** บน TerminalBench-2 agentic coding ด้วย Claude Haiku 4.5

**ทิศทาง** ของ claim ถูก (harness >> prompt tuning) แต่เลข "28-47%" น่าจะเป็น paraphrase ของ aggregator. ในเอกสารทางการ ใช้ตัวเลขจริงจาก arxiv 2603.28052 ดีกว่า — น่าเชื่อถือกว่าและ verify ได้

---

## 8-habit-ai-dev ในฐานะ Harness Implementation

Böckeler แบ่ง harness เป็น 2 ส่วนที่เสริมกัน:

- **Feedforward guides** — ตัวกำหนดทิศ "ก่อน" agent ลงมือ (set context + convention)
- **Feedback sensors** — กลไก self-correction "หลัง" agent ทำเสร็จ (ตรวจจับการ deviate)

plugin map ลงทั้ง 2 ฝั่งได้ครบ. ทุกแถวด้านล่างมี path ที่ verify ได้ใน repo นี้

### Feedforward guides

| #   | Component                                | Path                                                 | ทำหน้าที่                                                                                        |
| --- | ---------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| 1   | 8-Habit playbook (auto-load ทุก session) | `rules/effective-development.md`                     | นิยาม "WHY" ของทุกขั้นตอน workflow                                                               |
| 2   | Session-start hook                       | `hooks/session-start.sh`                             | inject 7-step reminder + maturity-adapted verbosity directive ให้ทุก conversation                |
| 3   | 17 on-demand process skills              | `skills/*/SKILL.md` (17 directories)                 | หนึ่ง skill ต่อหนึ่ง workflow step + standalone (`/cross-verify`, `/calibrate`, `/reflect`, ...) |
| 4   | Habit + guide reference content          | `habits/h*.md`, `guides/*.md`                        | โหลด on-demand โดย skills (token-efficient — ไม่ inject ที่ session start)                       |
| 5   | Maturity profile (per-user calibration)  | `~/.claude/habit-profile.md` (เขียนโดย `/calibrate`) | ขับ runtime verbosity adaptation ทุก skill (Dependence → Significance)                           |
| 6   | Project + user CLAUDE.md / AGENTS.md     | `CLAUDE.md`, `AGENTS.md`, `~/.claude/CLAUDE.md`      | ตรงกับ pattern "implicit prompting through documentation" ของ Hashimoto, ใช้ที่ 3 scope          |

### Feedback sensors

| #   | Component                          | Path                                                                                    | จับอะไร                                                                                                                    |
| --- | ---------------------------------- | --------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 7   | Structural validators (74 checks)  | `tests/validate-structure.sh`                                                           | โครงสร้างไฟล์, frontmatter, required sections                                                                              |
| 8   | Content validators (132 checks)    | `tests/validate-content.sh`                                                             | Version-4-files consistency, README "What's New" drift, sidebar consistency, anchor integrity                              |
| 9   | Auxiliary test scripts (36 checks) | `tests/test-skill-graph.sh`, `tests/test-verbosity-hook.sh`                             | Skill-graph integrity, hook output regression coverage                                                                     |
| 10  | Read-only review agent             | `agents/8-habit-reviewer.md`                                                            | Audit โดยไม่แก้ไฟล์ (model: `sonnet`, tools: `Read`/`Glob`/`Grep`)                                                         |
| 11  | Pre-commit cross-verification      | `skills/cross-verify/SKILL.md`                                                          | 17 คำถาม 8-Habit audit ก่อน commit                                                                                         |
| 12  | Find→Fix→Re-Verify loop            | `skills/review-ai/SKILL.md`                                                             | บังคับ re-grep ทุกครั้งหลัง fix เพื่อกัน partial-fix regression                                                            |
| 13  | Cross-session lesson persistence   | `~/.claude/lessons/` (เขียนโดย `/reflect`, retrieve โดย `/research` และ `/build-brief`) | ปิด gap "AI ไม่มีความจำข้าม session" ที่ Hashimoto เจอตรงๆ — เขียนบทเรียนลง disk แล้วโหลดเวลา task ที่เกี่ยวข้องครั้งถัดไป |

นับรวม: **242 assertion ที่ verify ได้** ผ่าน 4 test script บวก cross-verification 17 ข้อ. ทุกข้อคือการแก้เชิงโครงสร้าง ไม่ใช่ "โปรดจำไว้"

ตัวอย่าง concrete: patch v2.14.1 (issue #157) — user แจ้งว่า README "What's New" section drift ไป. fix ของเรา **ไม่ใช่** "เติม README ให้ครั้งเดียว" — แต่คือ **harden `validate-content.sh:578`** ให้ grep แบบ anchor ที่ section header แทน badge URL. ครั้งหน้าถ้าใครลืม validator จะจับได้ก่อน merge. ตรงตามนิยาม Hashimoto ทุกตัวอักษร

---

## "ตอนนี้คุณอยู่ชั้นไหน?" — Self-checklist

ลองติ้กดู — เอา layer ที่ติ้กส่วนใหญ่ได้ = ชั้นที่คุณอยู่:

### Layer 1 — Prompt Engineer

- [ ] iterate ด้วยการแก้คำพูดในข้อความเป็นข้อๆ
- [ ] วัดความสำเร็จเป็นรายบทสนทนา ไม่ใช่ข้าม run
- [ ] ไม่มีไฟล์ project ที่ auto-load context ทุก session
- [ ] เวลา agent พลาด คุณแก้ด้วยการ "บอกครั้งหน้าอย่าทำ"
- [ ] ไม่มี automated check ที่รันโดยไม่ต้องสั่ง

### Layer 2 — Context Engineer

- [ ] มี `CLAUDE.md` / `AGENTS.md` / system prompt ที่ load ทุก session
- [ ] curate ไฟล์ที่เข้า working set ของ agent
- [ ] จัดการ context-window budget ชัดเจน (token count, summarization, RAG)
- [ ] เพิ่มของเข้า context เวลาเจอปัญหาซ้ำ
- [ ] **แต่**: การแก้ยังอาศัยคุณจำได้ว่าต้อง update doc

### Layer 3 — Harness Engineer

- [ ] มี automated check ที่บล็อกพฤติกรรมแย่ได้แม้ไม่มีคนดู (session hook, pre-commit validator, reviewer agent)
- [ ] จัดการความผิดพลาด agent เป็น **system bug** — แก้คือเพิ่ม validator/skill/hook ใหม่ ไม่ใช่ note "อย่าลืม..."
- [ ] versioning guide, validator, และ decision record (ADR)
- [ ] วัด agent quality ระดับ **system** (validator pass rate, regression count) ไม่ใช่รายบทสนทนา
- [ ] มี **cross-session memory** — บทเรียนเก่าเรียกใช้ได้โดยไม่ต้องพิมพ์ใหม่

ถ้าติ้กส่วนใหญ่ใน Layer 3 ได้ — **คุณเป็น Harness Engineer แล้ว** อาจจะก่อนรู้จักคำนี้ด้วยซ้ำ. ประเด็นของการมี "ชื่อ" ไม่ใช่ gatekeep ใคร — มันคือการให้ชื่อบทบาทเพื่อให้ practice ถูก discuss, สอน, และพัฒนาต่อได้

---

## อ่านต่อ

- [Architecture](Architecture) — โครงสร้างภายใน plugin
- [Maturity Model](Maturity-Model) — Dependence → Independence → Interdependence → Significance
- [Vibe Coding vs Structured](Vibe-Coding-vs-Structured) — failure mode ที่ harness นี้ป้องกัน
- [Habits Reference](Habits-Reference) — 8 habit ที่ขับเคลื่อนทุก harness component

## Sources

1. Hashimoto, M. _My AI Adoption Journey_, 5 February 2026 — <https://mitchellh.com/writing/my-ai-adoption-journey>
2. Lee, Y., Nair, R., Zhang, Q., Lee, K., Khattab, O., Finn, C. _Meta-Harness: End-to-End Optimization of Model Harnesses_, 2026 — <https://arxiv.org/abs/2603.28052>
3. Böckeler, B. _Harness engineering for coding agent users_, Thoughtworks, 2 April 2026 — <https://martinfowler.com/articles/harness-engineering.html>
