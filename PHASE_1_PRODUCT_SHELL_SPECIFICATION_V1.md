# SmileFlow Phase 1 — Product Shell Precise Field / Interaction / Responsive Specification v1

## Status

**SPECIFICATION COMPLETE — NOT IMPLEMENTATION-AUTHORIZED**

Date: 2026-08-12

## Governing principle

> **I don't want to improve what I don't see. I want to experience SmileFlow first.**

Phase 1 builds the minimum application shell required to experience the existing SmileFlow baseline. It must not redesign or expand the approved clinical modules.

## Scope

Phase 1 Product Shell consists of exactly five product areas:

1. Application Shell
2. Dashboard
3. Global Patient Search
4. Navigation
5. User / Account Structure

Responsive behavior is part of the shell specification for Desktop, Laptop, Tablet, and Mobile.

## Product-shell architecture

```text
Application Shell
├── Global Header
│   ├── Brand / Product Identity
│   ├── Context / Location Indicator
│   ├── Global Patient Search Entry
│   └── User / Account Entry
│
├── Primary Navigation
│   ├── Dashboard
│   ├── Patients
│   ├── Visits
│   ├── Clinical
│   └── Records
│
└── Main Content Region
    └── Active page
```

Settings is intentionally represented through the user/account entry in Phase 1 rather than as a required primary-navigation destination.

## 1. Application Shell — precise regions

### 1.1 Global Header

Required fields/elements:

| ID | Element | Type | Required | Behavior |
|---|---|---|---|---|
| SHELL-H-01 | SmileFlow brand | brand/label | Yes | Returns to Dashboard when activated |
| SHELL-H-02 | Clinic/context label | text | Conditional | Displays current clinic/account context; may be demo text in prototype |
| SHELL-H-03 | Global patient search | search trigger/input | Yes | Opens patient search interaction |
| SHELL-H-04 | User/account control | menu trigger | Yes | Opens account/user menu |

No notification center is included in Phase 1.

### 1.2 Primary Navigation

The Phase 1 navigation inventory is intentionally limited to:

1. Dashboard
2. Patients
3. Visits
4. Clinical
5. Records

Each item has:

- visible label;
- navigation destination;
- active/inactive state;
- keyboard focus state;
- touch-appropriate target;
- accessible name.

Navigation is navigation-only. It must not mutate clinical state.

### 1.3 Main Content Region

Required behavior:

- Displays the active Phase 1 page.
- Preserves shell context while navigating.
- Provides page-level title/context.
- Does not impose clinical ownership.

### 1.4 Responsive navigation container

The primary navigation changes presentation by viewport class; the underlying route inventory remains the same.

## 2. Dashboard — precise content

The Phase 1 Dashboard is an orientation and entry surface, not an analytics dashboard.

### 2.1 Required regions

| ID | Region | Required |
|---|---|---|
| DASH-01 | Greeting / page heading | Yes |
| DASH-02 | Today's orientation summary | Yes |
| DASH-03 | Quick patient search/open action | Yes |
| DASH-04 | Current workflow entry | Yes |
| DASH-05 | Recent/current patient context | Prototype/demo only unless runtime data exists |

### 2.2 Dashboard content rule

The dashboard must not invent financial, production, HMO, inventory, AI, or unsupported clinical metrics.

For the prototype, dashboard cards may use clearly controlled demonstration values.

### 2.3 Dashboard interaction

- Selecting the patient-search action opens Global Patient Search.
- Selecting a patient opens the Patient Management context.
- Selecting the current-workflow entry opens the approved baseline clinical entry point where a route exists.
- Brand/home returns to Dashboard.

## 3. Global Patient Search — precise interaction contract

### 3.1 Search entry

`SHELL-H-03` opens a patient search surface.

### 3.2 Search field

| ID | Field | Type | Required |
|---|---|---|---|
| SEARCH-01 | Search query | text input | Yes |
| SEARCH-02 | Clear | action | Conditional |
| SEARCH-03 | Search/submit | action | Yes where submit is required |

### 3.3 Prototype search behavior

The prototype may use a controlled demonstration patient dataset.

Minimum journey:

```text
Open Search
   ↓
Enter query
   ↓
Show matching demo results
   ↓
Select patient
   ↓
Open Patient Management / Patient Context
```

### 3.4 Search result minimum fields

Each result may display:

- patient name;
- stable demo identifier / MRN;
- one additional disambiguating value where needed.

Do not expose unsupported clinical details in the global result row.

### 3.5 Runtime boundary

Production search indexing, filtering, pagination, permissions, and database queries belong to Phase 2.

## 4. User / Account Structure — precise presentation

### 4.1 User control

The global user/account control displays the current signed-in/demo user.

Minimum presentation:

- user display name;
- role label where available;
- account/profile action;
- sign-out action.

### 4.2 Prototype behavior

The prototype may represent a demo signed-in user.

The user menu must not imply that production authentication has already been implemented.

### 4.3 Production boundary

Authentication, session management, credential recovery, role enforcement, and authorization belong to Phase 2.

## 5. Navigation / route inventory

The Phase 1 shell uses the following conceptual route inventory:

| Route ID | Label | Destination concept | Phase 1 action |
|---|---|---|---|
| NAV-01 | Dashboard | Dashboard | Open |
| NAV-02 | Patients | Patient search / patient management entry | Open |
| NAV-03 | Visits | Visit workflow entry | Open |
| NAV-04 | Clinical | Clinical workflow entry | Open |
| NAV-05 | Records | Clinical record history entry | Open |

Exact implementation URLs/routes are a technical implementation concern and are not prescribed here.

### 5.1 Route behavior

- Active navigation state follows the current route.
- Navigation does not mutate domain state.
- Back navigation returns to the prior application context where technically supported.
- Unknown/unavailable destinations must fail safely rather than route to a misleading placeholder.

### 5.2 Mobile navigation

The five primary destinations remain available but may be presented through a compact navigation pattern.

The mobile pattern must not require hover.

## 6. Responsive specification

### 6.1 Viewport classes

The Product Shell must explicitly support:

- Desktop
- Laptop
- Tablet
- Mobile

Exact pixel breakpoints remain implementation-level values and must be chosen from actual shell layout constraints. They must not be used to redefine the four behavioral classes.

### 6.2 Desktop behavior

Expected characteristics:

- full primary navigation visible;
- full header controls visible;
- main content uses available width;
- dashboard may use multiple columns;
- search can remain persistently accessible in header;
- account control remains visible.

### 6.3 Laptop behavior

Expected characteristics:

- primary navigation remains directly accessible;
- navigation may become compact if horizontal space requires it;
- header controls remain usable;
- dashboard cards may reduce columns;
- no routine horizontal scrolling.

### 6.4 Tablet behavior

Expected characteristics:

- navigation may collapse to a compact menu;
- content becomes narrower and may stack;
- controls have touch-appropriate target sizing;
- patient search remains easy to reach;
- dashboard content may become one/two-column depending on available width.

### 6.5 Mobile behavior

Expected characteristics:

- single-column primary content;
- compact header;
- primary navigation becomes a mobile-appropriate pattern;
- patient search remains prominent and reachable;
- no hover-dependent critical interaction;
- no routine horizontal scrolling;
- critical actions remain reachable without requiring desktop-only controls.

### 6.6 Responsive invariants

Across all four viewport classes:

- SmileFlow identity remains visible;
- user/account access remains available;
- patient search remains reachable;
- Dashboard remains reachable;
- primary navigation destinations remain accessible;
- page content remains readable;
- focus/keyboard behavior remains meaningful where keyboard input exists.

## 7. Accessibility baseline

Phase 1 shell must provide:

- semantic navigation labels;
- visible focus state;
- keyboard-reachable navigation;
- accessible names for icon-only controls;
- adequate touch target sizing;
- no hover-only critical action;
- readable text hierarchy;
- logical focus order;
- sufficient contrast using approved SmileFlow design tokens.

Full accessibility audit remains Phase 6.

## 8. Empty / loading / error states

Phase 1 prototype must demonstrate shell-safe states where applicable.

### Search

- Empty query: no search execution required.
- No results: clear no-results state.
- Error: clear recoverable state.

### Dashboard

- Demo data unavailable: neutral empty state.

### Navigation

- Destination unavailable: safe unavailable state; do not silently redirect to an unrelated clinical module.

Production error semantics remain a Phase 4/6 concern.

## 9. Design-system rules

The implementation must use existing approved SmileFlow components wherever a matching component exists.

The following must not be invented without a separate component decision:

- new button family;
- new field family;
- new navigation component family;
- new typography system;
- new color/token system;
- new icon system.

If the shell requires a component not present in the approved design system, record the component gap and stop that specific implementation path for authorization.

## 10. Demo-data rules

The Phase 1 prototype may use controlled demo data solely to demonstrate the shell experience.

Demo data must be:

- obviously non-production;
- deterministic enough for QA;
- unrelated to real patient records;
- not presented as persistent production data.

## 11. Clinical boundary

The Product Shell may navigate into existing clinical modules but must not:

- change Visit State;
- create Treatment Plans;
- record Procedures;
- save Closure Outcomes;
- mutate Dental Chart state;
- create History records.

Those behaviors belong to their respective runtime domains and later implementation phases.

## 12. Acceptance criteria

The specification is satisfied when the implementation demonstrates:

### Shell

- application identity;
- header/context;
- primary navigation;
- user/account entry;
- main content region.

### Dashboard

- orientation surface;
- patient-search entry;
- workflow entry;
- no unsupported analytics.

### Search

- open search;
- enter query;
- display demo results;
- select patient;
- reach patient context.

### Navigation

- all five Phase 1 destinations are reachable;
- active state is visible;
- navigation does not mutate clinical state.

### User/account

- current user is represented;
- account menu opens;
- sign-out is represented in prototype.

### Responsive

- Desktop layout works;
- Laptop layout works;
- Tablet layout works;
- Mobile layout works;
- critical shell functions remain reachable across all four classes;
- no routine horizontal scrolling;
- no hover-only critical interactions.

### Governance

- no frozen clinical module is modified;
- `06 — Layouts` remains untouched;
- no new clinical field is introduced;
- no HMO/insurance functionality is introduced;
- no Phase 2+ production behavior is implied as implemented.

## 13. Explicit non-goals

This specification does not define:

- production database schema;
- authentication implementation;
- authorization enforcement;
- appointment scheduling;
- billing;
- HMO/insurance;
- notifications;
- reporting;
- AI;
- clinical module redesign;
- responsive redesign of individual clinical modules;
- production audit trail;
- production file storage;
- deployment.

## Decision

**PASS — PRODUCT SHELL SPECIFICATION COMPLETE.**

The specification is sufficiently precise to proceed to the next gate.

No Figma implementation is authorized by this document alone.

## Next task

> **SmileFlow Phase 1 — Product Shell Read-First Figma Preflight**

The preflight must inspect the existing SmileFlow Figma file for reusable shell components, current pages/frames, responsive layout constraints, exact-name conflicts, and the safest location for the Phase 1 shell implementation before any Figma write occurs.
