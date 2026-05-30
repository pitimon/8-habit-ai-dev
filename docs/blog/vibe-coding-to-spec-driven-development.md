# เขียนเร็วขึ้น ≠ พัฒนาซอฟต์แวร์ดีขึ้น — จาก Vibe Coding สู่ Spec-Driven Development

> _"This 'vibe-coding' approach can be great for quick prototypes, but less reliable when building serious, mission-critical applications."_
> — GitHub Blog, _Spec-driven development with AI_, 2 ก.ย. 2025

---

ช่วงนี้หลายทีม "เขียนระบบเร็วขึ้น" จริง — AI ช่วย gen code, prototype ออกไว, demo สวย. แต่ "เร็วขึ้น" กับ "องค์กรพัฒนาซอฟต์แวร์ได้ดีขึ้น" เป็นคนละเรื่อง. พอระบบโตขึ้น ปัญหาเดิมกลับมา: requirement ไม่ชัด, architecture พัง, scale ไม่ได้, ไม่มี governance, ไม่มี traceability, แก้ code จนทีมเริ่มคุมไม่ได้.

นี่คือเหตุผลที่วงการเริ่มพูดถึงการเปลี่ยนผ่าน **จาก Vibe Coding → Spec-Driven Development** อย่างจริงจังในปี 2025–26. บทความนี้เช็คข้อเท็จจริงของกระแสนี้ทีละข้อ (fetch source ตรงๆ) แล้ววางว่า plugin [`8-habit-ai-dev`](https://github.com/pitimon/8-habit-ai-dev) อยู่ตรงไหน — **อย่างซื่อตรง ไม่เคลมเกินจริง**

---

## Vibe Coding คืออะไร — และใครตั้งชื่อ

คำว่า **vibe coding** ถูกบัญญัติโดย **Andrej Karpathy** (co-founder OpenAI, อดีตหัวหน้า AI ที่ Tesla) เมื่อ **2 ก.พ. 2025**. นิยามเดิมของเขาคือสภาวะที่ developer _"fully give in to the vibes, embrace exponentials, and forget that the code even exists"_ — อธิบายทิศทาง AI, รับ code ที่ gen มาโดยไม่อ่าน diff, copy error ไปวางจนมันหายเอง.

คำนี้ติดจริง — ตามที่ [Wikipedia: Vibe coding](https://en.wikipedia.org/wiki/Vibe_coding) รวบรวมไว้: Merriam-Webster ขึ้นเป็นคำ "slang & trending" (มี.ค. 2025) และ Collins English Dictionary ยกให้เป็น **Word of the Year 2025**.

vibe coding **ไม่ใช่เรื่องแย่** — มันเหมาะมากกับ prototype, MVP, landing page, internal tool, demo. ข้อดีคือเร็ว, คนไม่เก่ง code ก็เริ่มได้, idea → product ไว. ปัญหาอยู่ที่การเอามันไปใช้กับระบบ mission-critical ที่ต้อง maintain / audit / scale ได้

---

## Spec-Driven Development — กระแสจริง ไม่ใช่การตลาด

หลัง vibe coding ดังได้ปีกว่า Karpathy เองก็บอกว่ายุคนี้กำลังจบ และกำลังเข้าสู่ **agentic engineering** — "orchestrating agents against detailed specifications with human oversight". คำตอบของวงการคือ **Spec-Driven Development (SDD)**: แทนที่จะเริ่มจาก code ให้เริ่มจาก **spec** แล้วให้ spec เป็น source of truth ที่ generate code ออกมา

GitHub วาง SDD ตรงข้ามกับ vibe coding ชัดเจนใน blog _"Spec-driven development with AI"_ (Den Delimarsky, 2 ก.ย. 2025): spec กลายเป็น _"living, executable artifacts"_ — "Specifications don't serve code—code serves specifications."

เครื่องมือชุดอ้างอิงของกระแสนี้ (Martin Fowler รวมไว้ในบทความ "Kiro, spec-kit, and Tessl"):

- **GitHub spec-kit** — OSS toolkit, workflow `Constitution → Specify → Plan → Tasks → Implement`, รองรับ 30+ coding agent (Copilot, Claude Code, Gemini, Cursor, Kiro …). แต่ละ phase ออกมาเป็น Markdown artifact ป้อน phase ถัดไป
- **AWS Kiro** — agentic IDE ที่แปลง natural language → spec แบบ EARS notation → gen และ maintain code
- **Tessl** — framework + spec registry (usage spec สำหรับ open-source libs)

> ⚠️ **หมายเหตุเรื่องตัวเลข:** ตอนเขียน บทความเช็คพบว่า star count ของ spec-kit ในเอกสารต่างแหล่งไม่ตรงกัน (repo เราเองมีจุดที่อ้าง 84.7K, ตอน fetch พ.ค. 2026 เห็น ~107K). **ตัวเลขแบบนี้เก่าเร็ว** — บทความนี้จึงเลี่ยงการ pin ตัวเลขที่ verify วันนี้แล้วผิดพรุ่งนี้

---

## ทำไม Enterprise ถึงจริงจัง — Governance คือหัวใจ

องค์กรไม่ได้ต้องการแค่ "เขียนเร็ว" — ต้องการระบบที่ maintain / audit / scale / secure / comply ได้ และเปลี่ยนทีมแล้วไปต่อได้. หลักฐานว่าเรื่องนี้ไม่ใช่ลมๆ:

- **Microsoft** ผลักดัน AI-agent governance จริง — Copilot Studio มี data-loss-prevention, Purview audit log, Sentinel alerting, customer-managed keys, autonomous-agent governance และ **Agent 365** เป็น control plane กลาง (ยืนยันจากหน้า learn.microsoft.com ตรงๆ)
- **Gartner** เตือน 2 ครั้ง:
  - _">40% ของ agentic AI **projects** จะถูกยกเลิกภายในสิ้นปี 2027"_ (PR 25 มิ.ย. 2025)
  - _"การใช้ governance แบบเดียวกันหมดกับทุก AI agent จะนำไปสู่ความล้มเหลว"_ (PR 26 พ.ค. 2026) — แนะ proportional governance ตาม autonomy level

> 📌 อ้างให้ตรง: Gartner พูดถึง "ยกเลิก project" ไม่ใช่ "demote agent" — ถ้าจะ quote ใช้คำของเขา

ประเด็นคือ: ถ้าไม่มี naming convention / coding standard / API policy / security policy / approval flow / audit trail — **AI ยิ่งทำให้ chaos เร็วขึ้น** ไม่ใช่ช้าลง

---

## แล้ว 8-habit-ai-dev อยู่ตรงไหน? (ตอบแบบไม่เคลมเกินจริง)

ภาพที่หลายคนวาดคือ "AI-Native SDLC" — agent ต่อ role: Requirement Agent → BA → Solution → Dev → QA → Deploy. **`8-habit-ai-dev` ตั้งใจ _ไม่ใช่_ สิ่งนั้น** — และนี่คือจุดที่ต้องซื่อตรง

SDD มี 3 ชั้น แยกกันชัด:

| ชั้น                                          | ใครทำ                 | กลไก                                           |
| --------------------------------------------- | --------------------- | ---------------------------------------------- |
| **Codegen tooling** (spec → code)             | spec-kit, Kiro, Tessl | gen artifact/code จาก spec                     |
| **Discipline** (วิธีได้ spec ที่ดีก่อน)       | **`8-habit-ai-dev`**  | read-only guidance, human-gated, tool-agnostic |
| **Enforcement / governance** (spec เป็น gate) | `claude-governance`   | runtime hook, Three Loops, fitness functions   |

`8-habit-ai-dev` คือ **"ชั้นวินัย (discipline layer) spec-first" ของ SDD** — มันช่วยให้ทีมเขียน spec ที่ดีขึ้นสำหรับเครื่องมือ _ตัวไหนก็ได้_ (หรือไม่ใช้เลย) ผ่าน 7-step workflow (`/research → /requirements → /design → /breakdown → /build-brief → /review-ai → /deploy-guide → /monitor-setup`) บนฐาน 8 Habits ของ Covey

สิ่งที่มัน **ไม่ทำ** (และไม่ควรเริ่มทำภายใต้ชื่อ SDD):

- ❌ ไม่ gen code/scaffold จาก spec — นั่นคือ spec-kit/Kiro/Tessl
- ❌ ไม่ ship agent pipeline แบบ Requirement→BA→QA→Deploy — นั่นคือ orchestration engine ([ADR-021](../adr/ADR-021-dynamic-workflow-positioning.md)) → `claude-governance`
- ❌ ไม่ enforce spec เป็น runtime gate — นั่นคือ `claude-governance`

จุดยืนนี้บันทึกเป็นทางการใน [ADR-022](../adr/ADR-022-spec-driven-development-positioning.md) (คู่กับ ADR-021: 021 = "ไม่ใช่ _engine_", 022 = "ไม่ใช่ _codegen tooling_")

ครบทั้ง 3 ชั้นเมื่อไหร่ — discipline (8-habit) + enforcement (claude-governance) + scanning/evidence (devsecops-ai-team) — **นั่นแหละคือ "Governance + Traceability + Audit" ที่ enterprise ต้องการจริง** (ดู [`docs/INTEGRATION.md`](../INTEGRATION.md))

---

## สรุป

- **เขียนเร็วขึ้น ≠ พัฒนาดีขึ้น** — vibe coding เหมาะกับ prototype, ไม่เหมาะกับ mission-critical
- กระแส **vibe → SDD → governance เป็นของจริง** verify ได้: Karpathy (ก.พ. 2025), GitHub spec-kit, Kiro, Tessl, Microsoft Copilot Studio governance, Gartner
- จุดที่ต้องระวังคือภาพ **"AI-Native SDLC แบบ agent ต่อ role"** — เป็นกรอบของผู้ขาย ไม่ใช่มาตรฐาน
- `8-habit-ai-dev` คือ **ชั้นวินัย (discipline layer) spec-first ของ SDD** — tool-agnostic, human-gated, ไม่ใช่ codegen และไม่ใช่ engine. ใช้คู่กับ `claude-governance` (enforcement) + `devsecops-ai-team` (scan) ได้ governance เต็มรูป
- **องค์กรที่ชนะในยุคนี้ไม่ใช่องค์กรที่ใช้ AI เยอะที่สุด แต่คือองค์กรที่มี governance ดีที่สุด**

---

## Deep dive

- **ADR positioning** → [ADR-022: Spec-Driven Development Positioning](../adr/ADR-022-spec-driven-development-positioning.md) · [ADR-021: Dynamic Workflow Positioning](../adr/ADR-021-dynamic-workflow-positioning.md)
- **Plugin integration (3-plugin stack)** → [`docs/INTEGRATION.md`](../INTEGRATION.md)
- **Plugin GitHub** → <https://github.com/pitimon/8-habit-ai-dev>
- **Install**: `claude plugin marketplace add pitimon/8-habit-ai-dev && claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev`

## Sources (verified — fetched ตรงไปแต่ละ source, พ.ค. 2026)

- Karpathy, A. — vibe coding origin, 2 Feb 2025 → ยืนยันผ่าน [Wikipedia: Vibe coding](https://en.wikipedia.org/wiki/Vibe_coding), [IBM Think](https://www.ibm.com/think/topics/vibe-coding)
- GitHub Blog — _Spec-driven development with AI_, Den Delimarsky, 2 Sep 2025 → <https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/>
- GitHub spec-kit → <https://github.com/github/spec-kit>
- Martin Fowler — _Understanding Spec-Driven-Development: Kiro, spec-kit, and Tessl_ → <https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>
- Microsoft Learn — _Security and governance, Copilot Studio_ → <https://learn.microsoft.com/en-us/microsoft-copilot-studio/security-and-governance>
- Gartner — _>40% of agentic AI projects canceled by end 2027_, 25 Jun 2025 → <https://www.gartner.com/en/newsroom/press-releases/2025-06-25-gartner-predicts-over-40-percent-of-agentic-ai-projects-will-be-canceled-by-end-of-2027>
- Gartner — _Uniform governance across AI agents will lead to failure_, 26 May 2026 → <https://www.gartner.com/en/newsroom/press-releases/2026-05-26-gartner-says-applying-uniform-governance-across-ai-agents-will-lead-to-enterprise-ai-agent-failure>
