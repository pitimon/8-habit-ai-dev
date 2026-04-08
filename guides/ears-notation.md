# EARS: Easy Approach to Requirements Syntax

EARS is a set of 5 structured templates for writing acceptance criteria that survive scrutiny. Originally developed at Rolls-Royce (Alistair Mavin et al., 2009) for safety-critical systems, now widely adopted in spec-driven AI development (GitHub Spec Kit, 84.7K stars).

**Why EARS**: unstructured acceptance criteria are ambiguous, fail silently, and create rework. EARS forces you to pick one of 5 shapes, each with a clear trigger condition and expected response. The system either does what the sentence says, or it doesn't.

## The 5 EARS Shapes

Each shape has a template, a trigger word, and a specific use case. If your requirement doesn't fit any shape, rewrite it until it does — that's the discipline.

### 1. Ubiquitous (always true, no trigger)

**Template**: `The <system> shall <response>.`

**When**: Invariants, universal properties, always-on behavior.

```
The login API shall return JSON responses.
The database connection pool shall hold a maximum of 20 connections.
All user-facing error messages shall be in the user's selected language.
```

### 2. Event-driven (triggered by external event)

**Template**: `When <trigger>, the <system> shall <response>.`

**When**: Reactions to user actions, incoming messages, external signals.

```
When the user submits the login form with valid credentials, the system shall issue a JWT valid for 24 hours.
When a webhook arrives from Stripe, the system shall verify the signature before processing.
When the daily cron at 02:00 UTC fires, the backup job shall snapshot the primary database.
```

### 3. State-driven (triggered by state condition)

**Template**: `While <state>, the <system> shall <response>.`

**When**: Continuous behavior that only applies in a specific state.

```
While the user is authenticated, the dashboard shall display the account balance.
While the rate limit is exceeded, the API shall return HTTP 429 with a Retry-After header.
While the feature flag `beta_checkout` is enabled, the checkout page shall show the new design.
```

### 4. Unwanted (error / exception paths)

**Template**: `If <trigger>, then the <system> shall <response>.`

**When**: Handling failures, invalid inputs, edge cases. This is the shape that catches the most bugs.

```
If the database connection is unavailable, then the system shall return HTTP 503 with a Retry-After header and log the failure.
If a JWT token is expired, then the system shall reject the request with HTTP 401 and not reveal whether the user exists.
If the uploaded file exceeds 10MB, then the system shall reject it with a clear error message before writing any bytes to disk.
```

### 5. Optional (feature-gated)

**Template**: `Where <feature>, the <system> shall <response>.`

**When**: Behavior that only applies when a feature is installed, purchased, or enabled. Useful for multi-tenant or tiered products.

```
Where two-factor authentication is enabled for the user, the login flow shall prompt for the 6-digit TOTP code.
Where the Enterprise plan is active, the audit log shall retain events for 36 months.
Where the OpenTelemetry SDK is installed, the service shall emit traces on every request.
```

## Complex Patterns (combining shapes)

For acceptance criteria that need multiple conditions, chain shapes with explicit connectors:

```
While the user is authenticated, when they click the logout button,
the system shall invalidate their session and redirect to /login.

If the database write fails during checkout, then the system shall
roll back the payment with the payment processor before returning an error.
```

## EARS vs Free-form — before/after example

### Before (free-form, ambiguous)

> The system should let users log in securely and remember them for a while.

**Problems**:

- "Should" — is it required or optional?
- "Log in" — with what? Email? Password? OAuth? SSO?
- "Securely" — no measurable property
- "Remember" — how? Cookie? Token? Session?
- "For a while" — 1 hour? 24 hours? Forever?

### After (EARS, precise)

```markdown
1. [Event-driven] When the user submits the login form with valid email and
   password, the system shall issue a JWT token valid for 24 hours and set it
   as an HttpOnly, Secure, SameSite=Strict cookie.

2. [Unwanted] If the login attempt fails (invalid credentials, rate limit
   exceeded, account locked), then the system shall return HTTP 401 with a
   generic error message that does not reveal whether the email exists.

3. [State-driven] While a valid JWT cookie is present and not expired, the
   system shall authenticate subsequent requests without re-prompting.

4. [Ubiquitous] All login attempts shall be logged with timestamp, user ID
   (if known), source IP, and outcome.

5. [Optional] Where the user has enabled 2FA, the login flow shall prompt
   for a 6-digit TOTP code before issuing the JWT.
```

Five criteria. Each one is testable. Each one has a clear pass/fail. That's the goal.

## When to Use EARS in 8-habit-ai-dev

Invoke via `/requirements` for:

- Features with ≥3 distinct acceptance criteria
- Any user-facing behavior with edge cases
- Security-sensitive paths (auth, permissions, data access)
- Public API contracts
- Any feature where ambiguity would cause rework

## When to Skip EARS

Skip the EARS template for:

- Single-line bug fixes (no acceptance criteria needed beyond "bug fixed")
- Formatting changes, rename refactors, dependency bumps
- Internal helpers with <3 acceptance criteria
- Research spikes and throwaway prototypes
- When a human stakeholder has already written precise criteria in their own notation — don't re-translate

**Honest skip rule**: if you can test the requirement with one assertion, EARS is overhead. Use it when multiple conditions interact.

## References

- **Alistair Mavin, Philip Wilkinson, Adrian Harwood, Mark Novak** (2009), "Easy Approach to Requirements Syntax (EARS)", 17th IEEE International Requirements Engineering Conference
- **GitHub Spec Kit** (84.7K stars): adopts EARS as the canonical notation for spec-driven AI development
- **AWS Kiro IDE**: uses EARS in Phase 1 (Requirements) of its 3-phase spec workflow
