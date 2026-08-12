# SmileFlow Phase 1 — Product Shell Read-First Figma Preflight v1

## Status

**PRELIGHT COMPLETE — PASS WITH CONDITIONS / IMPLEMENTATION-READY AFTER EXPLICIT AUTHORIZATION**

Date: 2026-08-12

## Scope

Read-only inspection of the existing SmileFlow Figma file before implementing Phase 1 Product Shell:

1. Application Shell
2. Dashboard
3. Global Patient Search
4. Navigation
5. User / Account Structure

Responsive behavior is included for Desktop, Laptop, Tablet, and Mobile.

No Figma writes were performed by this preflight.

## Figma file

File key: `4XiHoPFlljnne38HnjLgc6`

## Existing reusable shell components — VERIFIED

The existing `04 — Components` page contains reusable components suitable for Phase 1:

| Component | Node | Type | Decision |
|---|---:|---|---|
| Navigation Item | `28:32` | COMPONENT_SET | Reuse |
| Sidebar | `30:27` | COMPONENT | Reuse |
| Top Bar | `31:77` | COMPONENT | Reuse |

The Navigation Item includes Default, Hover, Active, Focus, and Disabled states.

The Sidebar is 240px wide in its documented desktop specimen.

The Top Bar is 1200px × 64px in its documented specimen.

These are the preferred existing foundations for the new shell. Do not create replacement shell primitives unless a documented gap is encountered.

## Existing flow components — VERIFIED

The `05 — Flow Components` page contains reusable components relevant to dashboard/reception context:

- Patient Identity — `52:42`
- Appointment Item — `60:105`
- Queue Item — `65:144`
- Visit Lifecycle — `68:391`

These may be reused where the Phase 1 dashboard requires them.

They do not establish production data behavior; they are design components.

## Existing `06 — Layouts` finding

`06 — Layouts` contains an existing desktop/reception layout and many historical clinical layouts.

The existing top-level `Desktop` frame is `5:2` at 1440 × 900.

It contains a 240px sidebar, 1200px top bar, and a Reception workspace. The older navigation labels visible there include:

- Reception
- Patients
- Appointments
- Queue

This is useful implementation evidence but does **not** supersede the current Phase 1 Product Shell specification.

Per explicit project decision, `06 — Layouts` is **NOT TO BE TOUCHED** during Product Shell implementation. It will not be cleaned, renamed, deleted, or modified.

## Existing Dashboard finding

No current top-level Figma frame named `Dashboard` was found in the inspected file inventory.

The existing `06 — Layouts` Desktop frame contains a Reception operational landing surface with appointment overview, today's appointments, live queue, and current visit. This is historical/layout evidence rather than an approved Phase 1 Dashboard composition.

Therefore Phase 1 should create a **new dedicated Product Shell page/harness** rather than modifying the old Reception layout.

Recommended page name:

`11 — Product Shell`

This recommendation avoids modifying `06 — Layouts` and keeps the new work isolated.

## Existing Global Search finding

A reusable Search icon exists in `03 — Icons` (`27:45` / `27:46`).

The existing component documentation includes Input Field and related controls. The preflight did not identify an already-approved global patient-search screen.

Therefore the patient search experience will require a new shell-level composition using existing input/search primitives rather than inventing a new visual language.

## Existing User / Account finding

No dedicated current Product Shell user/account composition was identified in the inspected file inventory.

A new shell-level user/account entry can therefore be constructed using existing approved primitives, subject to the specification and implementation authorization.

## Responsive finding

No dedicated current Product Shell frames for Desktop, Laptop, Tablet, and Mobile were identified outside the historical `06 — Layouts` desktop material.

Therefore responsive Product Shell compositions are **not already implemented**.

This is an actual Phase 1 implementation task.

The shell must be intentionally designed across four viewport classes:

- Desktop
- Laptop
- Tablet
- Mobile

Exact pixel breakpoints remain governed by the Product Shell specification and should be selected from layout constraints, not guessed framework defaults.

## Existing canonical clinical modules — PROTECTED

The current canonical clinical destinations remain outside Product Shell implementation:

- Patient Management `167:1219`
- Dental Chart `127:1110`
- Shared Visit `256:1303`
- Clinical Workspace `328:1919`
- Treatment Planning `198:1290`
- Performed Procedure `260:2`
- Clinical Closure `220:1294`
- Clinical Record History `153:1204`

Patient Registration `179:1245` also remains protected as an existing clinical module.

Product Shell implementation must not modify these frames.

## Existing Baseline Integration — PROTECTED

The existing `10 — Baseline Integration` page (`381:977`) is not to be repurposed as the Product Shell page.

It remains the approved baseline integration harness for the eight clinical prototype routes.

## Recommended implementation location

Create a new dedicated Figma page:

`11 — Product Shell`

Keep all Product Shell work isolated from:

- `06 — Layouts`
- `10 — Baseline Integration`
- Clinical Closure QA pages
- canonical clinical module frames

## Reuse policy

### Reuse directly

- Navigation Item `28:32`
- Sidebar `30:27`
- Top Bar `31:77`
- Patient Identity `52:42`
- Appointment Item `60:105`
- Queue Item `65:144`
- Visit Lifecycle `68:391`
- Existing Input/Search primitives
- Existing icons and design tokens

### Do not reuse as a canonical Product Shell

- `06 — Layouts` Desktop frame `5:2`
- historical Reception layouts
- historical clinical layouts
- Functional QA pages
- baseline integration clones

These may be evidence only.

## Navigation preflight condition

The current Product Shell specification identifies these conceptual destinations:

- Dashboard
- Patients
- Visits
- Clinical
- Records

The older Reception layout uses different labels. The new Product Shell implementation must follow the **current Product Shell specification**, not silently inherit the historical Reception navigation.

Exact route behavior remains prototype-only until runtime architecture gates are completed.

## Dashboard preflight condition

The Dashboard requires a new composition.

The existing Reception dashboard-like material can inform the content model, but its specific metrics are not automatically approved for production behavior.

For the prototype, controlled demo values may be used.

## Responsive implementation condition

Because no existing responsive shell composition was found, implementation must create and test explicit responsive states.

Minimum validation targets:

- Desktop: full navigation + full content workspace
- Laptop: reduced horizontal space without avoidable horizontal scrolling
- Tablet: collapsed/compact navigation and stacked/adapted content
- Mobile: compact header + mobile navigation pattern + single-column primary content

No responsive redesign of the nine clinical modules is authorized.

## Accessibility preflight

Existing Navigation Item states include Focus and Disabled variants.

The new shell should reuse those states and ensure:

- keyboard-reachable navigation;
- visible focus;
- meaningful labels;
- adequate touch targets;
- no hover-only critical action.

Full accessibility certification remains Phase 6.

## Preflight findings

| Check | Result |
|---|---|
| Existing shell components | PASS |
| Existing flow components | PASS |
| Existing dashboard composition | CONDITIONAL — new composition required |
| Global patient search composition | CONDITIONAL — new composition required |
| User/account composition | CONDITIONAL — new composition required |
| Desktop shell evidence | PASS — historical evidence only |
| Laptop shell | NOT YET BUILT |
| Tablet shell | NOT YET BUILT |
| Mobile shell | NOT YET BUILT |
| Canonical clinical module protection | PASS |
| `06 — Layouts` protection | PASS |
| Baseline Integration protection | PASS |
| New isolated implementation location | PASS — `11 — Product Shell` |

## Verdict

**PASS WITH CONDITIONS — PRODUCT SHELL IS READY FOR EXPLICIT IMPLEMENTATION AUTHORIZATION.**

The conditions are construction tasks, not blockers:

1. Build the new Product Shell on a dedicated page.
2. Reuse the verified existing shell components.
3. Create the Dashboard composition.
4. Create the Global Patient Search composition.
5. Create the User / Account entry composition.
6. Implement Desktop, Laptop, Tablet, and Mobile shell behavior.
7. Do not modify `06 — Layouts`.
8. Do not modify canonical clinical modules.
9. Do not turn prototype navigation into runtime persistence.

## Next gate

> **SmileFlow Phase 1 — Explicit Product Shell Implementation Authorization**

No Figma implementation is authorized by this preflight alone.
