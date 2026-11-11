# Research Brief: รวมข้อเสนอ Issue #432 กับ AI-native SDLC

**Depth**: Deep (source-verified; ผู้ตรวจอิสระตรวจ citation/ขอบเขตแยกต่างหาก) · **Mode**: General (วิเคราะห์และจัดลำดับข้อเสนอ)
**Date**: 2026-11-09 · **Repo HEAD ที่ตรวจ**: `234a720` · **Status**: research only — ไม่ได้แก้ issue, ไม่ได้สร้าง PR, ไม่ได้ทดสอบ runtime

**Sources**

| Ref | Source | สถานะการตรวจ |
| --- | --- | --- |
| S1 | [Issue #432](https://github.com/pitimon/8-habit-ai-dev/issues/432) — ECC comparison + P1–P5 | อ่านครบ; ตัวเลข/กลไกของ ECC เป็น historical claims ของ issue ยังไม่ตรวจซ้ำ |
| S2 | [The AI-native SDLC playbook](https://claude.com/resources/articles/the-ai-native-sdlc-playbook) (published 2026-08-21) | ดึงเนื้อหาเต็มแล้ว |
| S3 | ไฟล์ใน repo ตามที่อ้างด้านล่าง | อ่านด้วยตนเอง + ผู้ตรวจอิสระ |

## ข้อสรุป

ควรพัฒนาโปรเจกต์เป็น **evidence-driven AI delivery discipline**: เชื่อมเจตนา งานที่ทำ หลักฐาน ผล review และบทเรียน โดยคง **portable skills + human judgment** เป็นแกนหลัก

1. **ทำก่อน:** ปรับ handoff/evidence chain ของ skill ที่มีอยู่ และทดลอง behavioral eval ขนาดเล็ก
2. **ออกแบบก่อน ยังไม่สร้าง runtime:** ระบบเสนอ/คัดเลือกบทเรียน (P1/P2) โดยตัดสินใจเรื่อง consent, storage, เจ้าของระบบให้ชัด
3. **ส่งไป companion ไม่ใส่ core:** enforcement hooks และ policy profiles (P3/P4)
4. **ไม่เพิ่ม domain skills เป็นชุด:** เลือกรายตัวเมื่อมี friction จริง (ADR-014/ADR-015)

> บทความ Anthropic สนับสนุนแนวคิด artifact chain, feedback loop, eval และ hooks แต่ **ไม่ได้กล่าวถึง instincts, confidence score, memory vault, staging หรือ hook intensity profiles** การรวมสองแหล่งเป็นข้อเสนอเชิงออกแบบของเรา ไม่ใช่สิ่งที่บทความรับรอง

## 1. สิ่งที่ต้องแก้ความเข้าใจจาก Issue #432

### 1.1 `--persist` ไม่ได้ควบคุมการเขียนของทุก skill

- `--persist <slug>` และ invariant "ไม่เขียนไฟล์เมื่อไม่มี flag" ใช้กับ `/requirements`, `/design`, `/breakdown` — [persistence-convention.md:3–14](../../../guides/persistence-convention.md)
- `/reflect` Step 6 เขียน lesson ลง `~/.claude/lessons/` **อัตโนมัติ ไม่ถามเพิ่ม**; Step 7 อัปเดต `INDEX.md` อัตโนมัติ มีเพียงการลบ/รวมที่ต้องขออนุมัติ — [skills/reflect/SKILL.md:76–112](../../../skills/reflect/SKILL.md)
- ถ้อยคำใน issue ที่ว่า "ทุกการเขียนไฟล์ต้อง `--persist`/ผ่าน approval" จึงเกินจริง คำที่ถูกคือ: ไม่มีสิ่งใดเข้า repo หรือถูก inject เข้า context โดยไม่มีมนุษย์เป็นผู้เรียก workflow
- ดังนั้น P1 ที่ให้ "ต้อง approve ก่อน persist/promote" เป็น **ข้อกำหนดใหม่ที่เข้มกว่า `/reflect` ปัจจุบัน** ไม่ใช่ผลที่ ADR-013 รับรองอยู่แล้ว

### 1.2 Staging ก็เป็นการเก็บข้อมูล

แยก 4 สถานะให้ชัด: in-memory draft → persisted staging → approved lesson → published skill/instruction ADR-013 ([L47](../../adr/ADR-013-spec-persistence-opt-in.md)) และ persistence-convention L14 มีขอบเขตแค่สาม spec skills จึงอ้างเป็น invariant ของ staging store ใหม่ไม่ได้ — ระบบใหม่ต้องนิยาม consent และการเก็บข้อมูลของตนเอง (ต้องมี ADR)

### 1.3 P3 ขัดกับ plugin boundary

P3 (fail-closed PreToolUse edit blocker) คือ runtime enforcement ซึ่ง [DOMAIN.md:19–25, 37](../../../DOMAIN.md), [CLAUDE.md:73–80](../../../CLAUDE.md), [ADR-024:43–45](../../adr/ADR-024-codex-runtime-adapter-boundary.md) ระบุให้อยู่นอก core (→ `claude-governance`) หากจะใส่ใน core ต้องมี ADR ปรับ boundary ก่อน; อีกทั้ง hooks ของ repo เป็นของ Claude Code; Codex มีเพียง adapter แคบเมื่อ host เรียกใช้ ([compatibility-matrix.md:17–24, 63–71](../../compatibility-matrix.md))

## 2. ประเมินข้อเสนอ P1–P5

| ข้อเสนอ | คำแนะนำ | ตำแหน่งที่เหมาะ |
| --- | --- | --- |
| **P1** instinct promotion | ปรับเป็น proposal-first (มนุษย์เลือกข้อมูล) ไม่ capture ทุก tool call; ต้องมี ADR นิยาม consent/storage | Guidance ใน 8-habit; capture/promotion runtime อยู่ companion หากพิสูจน์ว่าจำเป็น |
| **P2** memory-vault format | ศึกษาก่อน: trust, provenance, supersedes, scope, consent; อย่าผูกกับ `ecc.memory.v1`; credential-shape scan ไม่พิสูจน์ว่าไม่มีข้อมูลอ่อนไหว | ตัดสินเจ้าของร่วมกับ memory system หลังตรวจของจริง |
| **P3** protected-config hook | ส่งต่อ ไม่สร้างใน core | `claude-governance` / adapter |
| **P4** hook profiles | พักไว้จนมี control จริง; ไม่เรียก banner ว่า strict security | Companion |
| **P5** ECC domain skills | รายกรณี: friction + license + ตรวจซ้ำกับของเดิม ([ADR-014](../../adr/ADR-014-external-prior-art-audit.md) เป็นหลักการ, [ADR-015](../../adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md) เป็นกรณีตัวอย่าง) | Core เฉพาะที่เข้ากับ workflow discipline |

## 3. Roadmap ที่แนะนำ

### Phase A — ปรับสิ่งที่มีอยู่

- **A1 Evidence & Handoff Contract (lightweight):** fields = Intent/source · Decisions (ใครตัดสิน) · Evidence (ตรวจอะไร ผลอะไร) · Not verified · Next action/stop. ใช้ conversation-only ได้, เชื่อม artifact ที่มีอยู่เมื่อผู้ใช้เลือก persistence, ไม่บังคับ `intent.md`/`plan.md`. ต่อยอด [persistence-convention.md:89–99](../../../guides/persistence-convention.md) และ [structured-output-protocol.md](../../../guides/structured-output-protocol.md)
- **A2 Doctrine audit:** เพิ่ม playbook ใน [anthropic-engineering-doctrine-audit.md](../../../guides/anthropic-engineering-doctrine-audit.md) (adopted / adapt / defer / out-of-scope) และเสนอแก้ถ้อยคำเรื่อง persistence ใน issue #432 (ยังไม่ได้แก้ issue)

### Phase B — Behavioral eval pilot

Scenario นำร่อง: (1) ไม่ใช้ `--persist` แล้วไม่มีไฟล์ถูกเขียน (2) deploy ไม่มี approval → หยุด (3) static ผ่านแต่ runtime ไม่ได้ทดสอบ → ห้ามสรุปว่าผ่าน (4) debug root cause ไม่ชัด → เลือก workflow สืบสวนที่เหมาะ (5) Hermes/Codex ไม่ถูกอธิบายว่าใช้ Claude hooks อัตโนมัติ. แยก deterministic checks จาก human-reviewed outcomes, บันทึก model/runtime/version, ไม่บังคับ paid CI และไม่กำหนด pass threshold ก่อนมี baseline

### Phase C — Learning contract (P1/P2) — design เท่านั้น

คำถามที่ต้องตอบก่อนสร้าง: เมื่อใดผู้ใช้ยินยอม capture/scope · staging อยู่ใน memory หรือไฟล์/retention · อนุมัติแยกอะไรบ้าง (capture/save/reuse/promote/publish) · privacy/secret filtering · เจ้าของ memory runtime/revoke/supersede · ตรวจและแก้ lesson ที่ผิดอย่างไร. ค่า confidence 0.7 และ recurrence 2 โปรเจกต์ของ ECC เป็นแนวคิดที่ต้องพิสูจน์ ไม่ใช่ค่าเริ่มต้น

### Phase D — Companion controls (P3/P4)

ต้องตรวจ `claude-governance` และ memory companion ก่อนสร้างใหม่ (issue #432 ระบุว่ายังไม่ได้ตรวจ sibling repos); ออกแบบ protected action, fail-closed/recovery/bypass, negative tests, และการแจ้งผู้ใช้เมื่อ adapter ไม่ทำงาน

## 4. ลำดับการตัดสินใจที่เสนอ

1. แก้ความถูกต้องของข้อความใน issue + adoption audit
2. Evidence & handoff contract บน skill/template เดิม
3. Behavioral eval pilot
4. Learning contract (P1/P2)
5. ศึกษา P3/P4 ใน companion
6. P5 รายตัว

## Constraints Identified

- Skills เป็น guidance ไม่ใช่ authorization — [DOMAIN.md:19–25](../../../DOMAIN.md)
- ไม่ทำ runtime enforcement/policy certification ใน core — DOMAIN.md:23, 37; CLAUDE.md:73–80
- Claude hooks ไม่ใช่ universal behavior — compatibility-matrix.md
- SKILL.md จำกัด 2000 คำ; ต้อง sync mirror `plugin/` และรัน validators เมื่อแก้ skill/guide (AGENTS.md)
- ห้ามมี secret/raw customer data ใน repo docs

## Source Verification Report

| รายการ | ผล |
| --- | --- |
| Issue #432, playbook | อ่านเนื้อหาเต็มแล้ว |
| `/reflect` auto-write, `--persist` scope, DOMAIN/CLAUDE/ADR-024 boundary | ยืนยันด้วย source (ผู้ตรวจอิสระ + ตรวจเอง) |
| ผู้ตรวจอิสระ: playbook ไม่สนับสนุน P1/P2/P4 โดยตรง | ยืนยัน |
| ข้อมูล ECC (จำนวน/กลไก/คะแนน) | **ไม่ได้ตรวจซ้ำ** — historical claims ของ issue |
| Sibling repos (`claude-governance`, memforge) | **ไม่ได้ตรวจ** |

การตรวจนี้ยืนยันความถูกต้องของ citation ไม่ได้พิสูจน์ว่าข้อเสนอเหมาะกับผู้ใช้จริง

## Key Insight

โอกาสที่ใหญ่ที่สุดคือทำ "หลักฐานและการส่งต่องาน" ให้ตรวจสอบได้บนโครงเดิม มากกว่าเพิ่ม runtime; เรื่อง learning/enforcement ต้องตัดสินด้านขอบเขตและ consent ก่อน

## Recommendation

**Adapt**: A1/A2 + B ก่อน; C ทำเป็น design/ADR; D และ P3/P4 ส่ง companion; P5 รายกรณี

## Confidence & Open Unknowns

**Confidence**: สูงสำหรับข้อขัดแย้งเรื่อง boundary และ `/reflect`; ปานกลางสำหรับลำดับความสำคัญ
**Open unknowns**: ECC ปัจจุบัน; ความสามารถของ companion repos; scenario eval ใดแทนงานจริงได้; ค่าใช้จ่าย/ความแปรปรวนของ eval; ผู้ใช้ภายนอกต้องการ handoff contract จริงหรือไม่

## Acceptance Checklist (ของ research deliverable)

- [x] อ่านทั้ง issue #432 และบทความต้นทาง
- [x] แยก adopted / adapt / defer / out-of-scope พร้อม citation
- [x] ระบุสิ่งที่ยังไม่ตรวจและข้อจำกัดของหลักฐาน
- [x] ไม่ถือว่า research อนุญาต implement, แก้ issue หรือเปิด paid evaluation

## Handoff

Next skill: `/requirements` สำหรับ Phase A + B (แยกการอนุมัติ design ของ learning และ enforcement) · Stop: ต้องมี owner อนุมัติ PRD ก่อน `/design`
