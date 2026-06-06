# Harness Engineering

Harness engineering is the discipline of keeping the runtime harness thin while putting durable reasoning into portable skills, guides, and review artifacts.

> [!NOTE]
> This is the wiki's intentional Thai/English concept page. The rest of the wiki is English-first for public documentation consistency.

## แนวคิดหลัก

Harness ที่ดีไม่ควรพยายามควบคุมทุกอย่างใน runtime. หน้าที่หลักคือเปิดทางให้ agent โหลดคำแนะนำที่ถูกต้องในเวลาที่เหมาะสม แล้วให้มนุษย์ยังเป็นเจ้าของการตัดสินใจสำคัญ.

In English: the harness routes and loads context; the skills carry the process discipline.

## Thin Harness, Fat Skills

| Layer | Responsibility |
| --- | --- |
| Thin harness | Entry points, routing, short reminders, validation hooks |
| Fat skills | Requirements, design, review, deployment, operations, reflection |
| Human judgment | Architecture, irreversible actions, production acceptance, compliance posture |

This design keeps the plugin portable across Claude Code, Codex, and other agents that can consume markdown.

## What Belongs Here

- Skill selection and reading.
- Concise workflow reminders.
- Markdown guidance that works across runtimes.
- Validators that catch documentation and skill drift.

## What Does Not Belong Here

- Runtime policy enforcement.
- Secret scanning gates.
- Automatic production mutation.
- Compliance certification.
- Dynamic orchestration engines.

Those responsibilities belong in separate governance or automation layers.

## Practical Rule

ถ้าสิ่งนั้นเป็น "วินัยในการคิดและตรวจสอบ" ให้ใส่ใน skill. ถ้าสิ่งนั้นเป็น "การบังคับ runtime หรือการอนุมัติ irreversible action" ให้แยกออกจาก plugin core.

If it is thinking discipline, it can live in a skill. If it is runtime authority, keep it outside the core.

## See Also

- [Architecture](Architecture)
- [Skills Reference](Skills-Reference)
- [Workflow Overview](Workflow-Overview)
