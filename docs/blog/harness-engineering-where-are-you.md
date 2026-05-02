# คุณกำลังทำงานอยู่ชั้นไหน? — Prompt → Context → Harness Engineer

> _"Anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."_
> — Mitchell Hashimoto, _My AI Adoption Journey_, 5 ก.พ. 2026

---

ช่วงนี้คำว่า **Harness Engineer** เริ่มดังในวงการ AI agent dev — โดยเฉพาะหลังจาก Mitchell Hashimoto (คนที่สร้าง Terraform/HashiCorp) เขียน blog post กุมภาพันธ์ 2026 ตั้งชื่อให้ practice นี้, แล้ว Stanford ตามด้วยเปเปอร์ _Meta-Harness_ และ Thoughtworks (Birgitta Böckeler) เขียน reference article บน martinfowler.com ตามมาในเมษา

ถ้าใครยังไม่เห็นภาพ ลองนึกแบบจ้างพนักงานใหม่:

🔹 **Prompt Engineer** = คนที่สั่งงานเก่ง — รู้ว่าต้องพูดยังไง ใส่รายละเอียดแค่ไหน ให้ตัวอย่างกี่ข้อ. สั่งดี = งานออกมาดี, สั่งห่วย = งานพัง. ทุกอย่างขึ้นกับ "คำสั่งในตอนนั้น"

🔹 **Context Engineer** = คนที่ทำ onboarding ให้พนักงาน — เตรียม document, แผนผังองค์กร, ประวัติโปรเจกต์ ให้ครบก่อนเริ่มงาน. แม้สั่งดีแค่ไหน ถ้า context ไม่พอก็ผิดได้

🔹 **Harness Engineer** = คนที่ออกแบบ HR ทั้งระบบ — กำหนดอำนาจ, ระบบตรวจงานก่อน approve, checkpoint ก่อนทำสิ่งสำคัญ, และระบบจัดการเวลาพนักงานทำผิดให้ไม่ซ้ำอีก

🤖 ถ้าเทียบเป็นคอมพิวเตอร์: **Model = CPU, Context = RAM, Harness = OS**. ทั้ง 3 ชั้น **"ครอบกัน"** ไม่ใช่ "แทนกัน" — Harness Engineer ที่ดียังเขียน prompt ดีและประกอบ context เก่งอยู่ แค่ขอบเขตของบทบาทใหญ่กว่า

---

## ทำไมต้องมีชั้น Harness?

🤖 เพราะมีปัญหาที่ Prompt + Context แก้ไม่ได้:

- AI ที่รันงานคนเดียวหลายชั่วโมง อาจ "หลงทาง" ไปแก้ไฟล์นอก scope
- งาน multi-step มีความผิดพลาดสะสมจนระเบิดในขั้นท้าย
- บอก "ครั้งหน้าอย่าทำแบบนี้" ไม่ได้ผล — AI ไม่มีความจำข้าม session

แนวคิดหลักของ Harness Engineer ตามนิยาม Hashimoto: **"ทุกครั้งที่ AI ทำผิด อย่าหวังว่ามันจะดีขึ้นเอง — เปลี่ยนระบบให้ความผิดพลาดแบบนั้นเกิดซ้ำได้ยากขึ้นเชิงโครงสร้าง"**

---

## เลข viral "3% vs 28-47%" — เช็คให้ชัด

🤖 มีตัวเลขที่ถูก quote บ่อยว่า "งานวิจัย Stanford พบว่า prompt tuning ดีขึ้นได้สูงสุด 3% แต่ harness ดีขึ้น 28-47%"

⚠️ ผมไป fetch เปเปอร์ Stanford ตัวจริง (Lee et al. _Meta-Harness_, arxiv 2603.28052) ตรงๆ — **ตัวเลขนี้ไม่อยู่ในเปเปอร์**. ตัวจริงรายงาน:

- **+7.7 percentage points** บน text classification — ใช้ token น้อยลง 4 เท่า
- **+4.7 percentage points** บน math reasoning ระดับ IMO (เฉลี่ย 5 โมเดล)
- **SOTA** บน TerminalBench-2 agentic coding ด้วย Claude Haiku 4.5

**ทิศทาง** (harness >> prompt tuning) ถูก. แต่เลข "28-47%" น่าจะเป็น paraphrase ของ blog aggregator. ถ้าจะอ้างทางการ ใช้ตัวเลขจริงครับ — น่าเชื่อถือกว่าและ verify ได้

---

## Case study — เขียน Harness ก่อนคำว่า Harness Engineering จะ viral

ผมดูแล plugin ชื่อ [`8-habit-ai-dev`](https://github.com/pitimon/8-habit-ai-dev) สำหรับ Claude Code ตั้งแต่ก่อนคำว่า Harness Engineering จะกลายเป็น industry term. พอเห็นนิยามของ Hashimoto + taxonomy ของ Böckeler แล้ว — plugin นี้คือ **Harness implementation ตรงตามตำรา**

Böckeler แบ่ง harness เป็น 2 ฝั่ง:

- **Feedforward guides** — ตัวกำหนดทิศ "ก่อน" agent ลงมือ
- **Feedback sensors** — กลไก self-correction "หลัง" agent ทำเสร็จ

ตัวอย่างที่ map กับ plugin (ทุกตัวมี path verify ได้ — ลิสต์ครบใน wiki):

**ฝั่ง Feedforward (6 components):**

- `rules/effective-development.md` — auto-load ทุก session, นิยาม "WHY" ของทุกขั้นตอน
- `hooks/session-start.sh` — inject 7-step reminder + maturity-adapted verbosity directive ให้ทุก conversation
- 17 on-demand process skills ใน `skills/*/SKILL.md`
- `~/.claude/habit-profile.md` — calibration profile ที่ skills อ่านเพื่อปรับ verbosity ตาม maturity ของ user
- `CLAUDE.md` / `AGENTS.md` ทั้ง project + user-global — ตรงกับ pattern "implicit prompting" ของ Hashimoto

**ฝั่ง Feedback (7 components):**

- `tests/validate-structure.sh` — **74 checks** ของโครงสร้างไฟล์
- `tests/validate-content.sh` — **132 checks** ของ content (version 4-files consistency, README drift, sidebar)
- Aux scripts อีก **36 checks**
- `agents/8-habit-reviewer.md` — read-only review agent (sonnet)
- `/cross-verify` — 17 คำถาม audit ก่อน commit
- `/review-ai` — Find→Fix→Re-Verify loop กัน partial-fix
- `~/.claude/lessons/` cross-session memory — ปิด gap "AI ไม่มีความจำข้าม session" ที่ Hashimoto เจอตรงๆ

🤖 รวม **242 assertion ที่ verify ได้** + 17 คำถาม cross-verification

ตัวอย่าง concrete: patch `v2.14.1` (issue #157) — user แจ้งว่า README "What's New" section drift ไป. fix ของเรา **ไม่ใช่** "เติม README ให้ครั้งเดียว" — แต่คือ **harden `validate-content.sh:578`** ให้ grep แบบ anchor ที่ section header แทน badge URL. ครั้งหน้าใครลืม → validator จับได้ก่อน merge. ตรงตามนิยาม Hashimoto ทุกตัวอักษร

---

## Self-test — ตอนนี้คุณอยู่ชั้นไหน?

ลองติ้กดู (เอา layer ที่ติ้กส่วนใหญ่ได้ = ชั้นที่คุณอยู่):

**Layer 1 — Prompt Engineer**

- [ ] iterate ด้วยการแก้คำพูดในข้อความเป็นข้อๆ
- [ ] วัดความสำเร็จเป็นรายบทสนทนา
- [ ] ไม่มีไฟล์ project ที่ auto-load context ทุก session
- [ ] เวลา agent พลาด แก้ด้วย "บอกครั้งหน้าอย่าทำ"
- [ ] ไม่มี automated check ที่รันโดยไม่ต้องสั่ง

**Layer 2 — Context Engineer**

- [ ] มี `CLAUDE.md` / `AGENTS.md` / system prompt load ทุก session
- [ ] curate ไฟล์ใน working set
- [ ] จัด context-window budget ชัดเจน (token, summarization, RAG)
- [ ] เพิ่มของเข้า context เวลาเจอปัญหาซ้ำ
- [ ] แต่: การแก้ยังอาศัยคุณจำว่าต้อง update doc

**Layer 3 — Harness Engineer**

- [ ] มี automated check บล็อกพฤติกรรมแย่ได้แม้ไม่มีคนดู (session hook, pre-commit validator, reviewer agent)
- [ ] จัดการความผิดพลาด agent เป็น **system bug** — แก้คือเพิ่ม validator/skill/hook ใหม่
- [ ] versioning guide, validator, decision record (ADR)
- [ ] วัด agent quality ระดับ system (validator pass rate, regression count)
- [ ] มี cross-session memory — บทเรียนเก่าเรียกใช้ได้โดยไม่ต้องพิมพ์ใหม่

🤖 ถ้าติ้กส่วนใหญ่ใน Layer 3 ได้ — **คุณเป็น Harness Engineer แล้ว** อาจจะก่อนรู้จักคำนี้ด้วยซ้ำ. ประเด็นของการมี "ชื่อ" ไม่ใช่ gatekeep ใคร — มันคือการให้ชื่อบทบาทเพื่อให้ practice ถูก discuss, สอน, และพัฒนาต่อได้

---

## สรุป

- **Prompt** = "พูดยังไง"
- **Context** = "รู้อะไร"
- **Harness** = "ทำอะไรได้บ้าง + ตรวจอย่างไร + เกิดอะไรขึ้นถ้า off"

3 ชั้นนี้ **ซ้อนกัน ไม่ใช่แทนกัน**. Harness Engineer ที่ดียังต้องเก่ง prompt + context — แค่บทบาทใหญ่กว่า

ถ้าคุณกำลังจะเริ่มลงมือทำ harness ของตัวเอง — เริ่มจากสามคำถาม:

1. **ตอน agent พลาดครั้งล่าสุด คุณ "เพิ่ม validator" หรือ "บอกตัวเองว่าจะระวัง"?** (Hashimoto's test)
2. **บทเรียนจาก session ที่แล้ว เก็บไว้ที่ไหน — disk หรือสมองคุณ?** (cross-session memory test)
3. **มีคนอื่นในทีมที่ไม่ใช่คุณ run ระบบ harness ได้มั้ย?** (system vs ritual test)

ถ้าทั้ง 3 ข้อตอบ "ตามตำรา" — คุณอยู่ชั้น Harness แล้วจริงๆ

---

## Deep dive

- **Wiki canonical** (รายละเอียดเต็ม + 13-component mapping table + bilingual EN+TH) → [Harness Engineering — 8-habit-ai-dev wiki](https://github.com/pitimon/8-habit-ai-dev/wiki/Harness-Engineering)
- **Plugin GitHub** → <https://github.com/pitimon/8-habit-ai-dev>
- **Install ใน Claude Code**: `claude plugin marketplace add pitimon/8-habit-ai-dev && claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev`

## Sources (verified — fetched ตรงไปแต่ละ source)

- Hashimoto, M. _My AI Adoption Journey_, 5 Feb 2026 → <https://mitchellh.com/writing/my-ai-adoption-journey>
- Lee, Y. et al. _Meta-Harness: End-to-End Optimization of Model Harnesses_ (Stanford) → <https://arxiv.org/abs/2603.28052>
- Böckeler, B. _Harness engineering for coding agent users_, Thoughtworks, 2 Apr 2026 → <https://martinfowler.com/articles/harness-engineering.html>
