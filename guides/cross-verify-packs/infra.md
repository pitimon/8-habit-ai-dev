# Infrastructure Domain Questions

Additional cross-verify questions for infrastructure/deployment changes.

| #   | Dimension | Question                                                             |
| --- | --------- | -------------------------------------------------------------------- |
| I1  | Body      | Is there a rollback plan with specific steps and time estimate?      |
| I2  | Body      | Are health checks configured for readiness and liveness?             |
| I3  | Mind      | Is the change tested in staging before production?                   |
| I4  | Spirit    | Are secrets managed via vault/env, not baked into images or configs? |
| I5  | Body      | Is resource monitoring in place (disk, memory, CPU) with alerts?     |
