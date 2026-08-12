# SmileFlow Baseline — Integration Implementation / Read-First Figma Preflight

## Status

**PASS WITH CONDITIONS — IMPLEMENTATION-READY FOR A DEDICATED INTEGRATION HARNESS ONLY**

Date: 2026-08-12

## Authorization basis

Implementation is authorized only by `BASELINE_INTEGRATION_IMPLEMENTATION_AUTHORIZATION_V1.md`.

The authorization is limited to eight bounded, navigation-only prototype routes. It does not authorize backend behavior, data persistence, lifecycle mutation, module redesign, new fields/components, or changes to frozen module compositions.

## Figma file

SmileFlow Foundations v1.0

File key: `4XiHoPFlljnne38HnjLgc6`

## Canonical destination inventory

| Module | Canonical / current frame | Node | Preflight |
|---|---|---:|---|
| Patient Management | Patient Management — Phase 1 | `167:1219` | PASS |
| Dental Chart | Dental Chart — Phase 1 | `127:1110` | PASS |
| Shared Visit | Shared Visit — Phase 1 — Canonical | `256:1303` | PASS |
| Clinical Workspace | Clinical Workspace — Phase 1 — Canonical | `328:1919` | PASS |
| Treatment Planning | Treatment Planning — Phase 1 — Canonical | `198:1290` | PASS |
| Performed Procedure | Performed Procedure — Phase 1 — Canonical | `260:2` | PASS |
| Clinical Closure | Clinical Closure — Phase 1 — Canonical | `220:1294` | PASS |
| Clinical Record History | Current canonical destination must be resolved from the authoritative module documentation before wiring | — | CONDITIONAL |

## Important Clinical Closure finding

The Figma file contains multiple frames named `Clinical Closure — Phase 1 — Canonical`.

The authoritative current canonical frame is `220:1294` according to the repository governance state. The similarly named frames under the v1.2 Functional QA page are test copies and must not be used as integration destinations.

## Existing prototype-route finding

The Figma file already contains many historical/local prototype routes. Several existing routes lead to non-canonical state frames such as:

- `Clinical Workspace — In Treatment`
- `Treatment Planning — Active`
- `Clinical Closure — Completed as Planned`
- `Performed Procedure — Phase 1`
- `Clinical Record History — Phase 1`
- older Clinical Closure v1.0 test/prototype states

These routes are existing implementation evidence and are **not automatically reused** for the new baseline integration journey.

The new integration harness must use the current canonical destination inventory and must not silently repair or rewrite unrelated historical routes.

## Existing integration harness

No page matching `Integration` or `Baseline Experience` currently exists in the Figma file.

Therefore the authorized implementation should create a dedicated page/harness rather than modifying canonical module compositions.

Recommended page name:

`10 — Baseline Integration`

## Protected canonical modules

The following frames must remain untouched during integration-harness construction:

- `167:1219` Patient Management
- `127:1110` Dental Chart
- `256:1303` Shared Visit
- `328:1919` Clinical Workspace
- `198:1290` Treatment Planning
- `260:2` Performed Procedure
- `220:1294` Clinical Closure
- the authoritative Clinical Record History canonical frame once resolved

Historical/protected Clinical Workspace frame `207:1291` must also remain untouched.

## Authorized routes

Only these eight routes may be added to the dedicated harness:

1. INT-01 Patient Registration → Patient Management
2. INT-02 Patient Management → Dental Chart
3. INT-03 Patient Management → Shared Visit
4. INT-04 Shared Visit → Clinical Workspace
5. INT-05 Clinical Workspace → Treatment Planning
6. INT-06 Treatment Planning → Performed Procedure
7. INT-07 Performed Procedure → Clinical Closure
8. INT-08 Clinical Closure → Clinical Record History

All are navigation-only.

## Route safety

No new route may:

- change Shared Visit Visit State;
- close a visit;
- create or mutate Treatment Planning;
- create a Performed Procedure implicitly;
- create Clinical Record History implicitly;
- modify Dental Chart state;
- change scheduling/queue state;
- create billing/insurance behavior;
- enter the Clinical Closure v1.3 Functional QA page;
- enter historical/superseded module compositions.

## Conditional blocker

Before INT-08 is wired, the authoritative Clinical Record History canonical Figma destination must be resolved from its current repository evidence. The current preflight found a legacy frame named `Clinical Record History — Phase 1` used by historical prototype routes, but that frame has not been accepted as the current canonical destination by this preflight.

## Verdict

**PASS WITH CONDITIONS**

The integration harness itself is implementation-ready.

Implementation may proceed for INT-01 through INT-07 after the harness is created, provided only canonical destinations are used.

INT-08 remains blocked until the current Clinical Record History canonical destination is verified.

No canonical module write is authorized by this preflight.
