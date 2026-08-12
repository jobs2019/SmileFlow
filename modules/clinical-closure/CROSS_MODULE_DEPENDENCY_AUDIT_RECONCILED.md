# Clinical Closure — Cross-Module Dependency Audit (Reconciled)

**Audit type:** Read-only repository architecture audit
**Scope:** Shared Visit, Clinical Closure, Treatment Planning, Clinical Workspace, Performed Procedure, Clinical Record History
**Figma modification:** None
**Result:** PASS with one explicitly deferred interaction detail

## 1. Gate result

The previously identified P1 contradiction between Shared Visit and Clinical Closure is resolved at the repository architecture level.

The authoritative dependency is now:

```text
Shared Visit
In Treatment
    ↓
Shared Visit
Ready for Closure
    ↓
Clinical Closure
Closure Outcome
    ↓
Shared Visit may proceed to Closed
```

## 2. Shared Visit ↔ Clinical Closure

**PASS**

Shared Visit owns:
- Visit State
- `In Treatment → Ready for Closure`
- `Ready for Closure → Closed`

Clinical Closure owns:
- Closure Outcome
- closure classification
- user-facing closure decision/command when separately authorized

Clinical Closure entry condition is `Ready for Closure`.

The old Clinical Closure demonstration state `In Treatment` is superseded for future specification and implementation work.

Evidence:
- `modules/clinical-closure/SHARED_VISIT_LIFECYCLE_CONTRACT.md`
- `modules/clinical-closure/ARCHITECTURE.md` v1.1
- `modules/clinical-closure/FIELD_SPECIFICATION.md` v1.2

## 3. Save Closure Outcome ↔ Shared Visit mutation

**PASS — intentionally non-automatic**

`Save Closure Outcome` records the closure outcome only under the current specification.

No automatic Shared Visit mutation is authorized.

This prevents Clinical Closure from becoming a second Visit State owner.

## 4. Close Visit ↔ Shared Visit

**PASS — interaction deferred**

The architecture permits a future Clinical Closure user-facing `Close Visit` command.

However:
- the current canonical implementation does not contain the command;
- Shared Visit remains the owner of the resulting state transition;
- no Figma implementation is authorized by the architecture reconciliation alone.

A future `Close Visit` interaction requires its own approved interaction specification and Figma Preflight.

## 5. Clinical Closure ↔ Treatment Planning

**PASS**

Treatment Planning owns treatment lifecycle/status.

Clinical Closure references Treatment Status and treatment context as read-only.

Closure Outcome does not automatically mutate Treatment Planning.

`Treatment Continues` preserves the distinction between closing a visit and completing treatment.

## 6. Clinical Closure ↔ Clinical Workspace

**PASS**

Clinical Workspace owns active clinical work and documentation.

Clinical Closure consumes context and does not duplicate the clinical documentation editor.

## 7. Clinical Closure ↔ Performed Procedure

**PASS**

Performed Procedure owns actual procedure information.

Clinical Closure does not become the procedure editor and does not automatically create a performed procedure.

## 8. Performed Procedure ↔ Clinical Record History

**PASS at architecture/UI boundary**

Performed Procedure owns actual procedure entry.

Clinical Record History is read-only historical presentation.

The backend/event persistence mechanism remains intentionally unspecified and is not inferred by this audit.

## 9. Clinical Closure ↔ Clinical Record History

**PASS**

Clinical Closure is a current workflow boundary.

Clinical Record History is a read-only historical presentation.

No history timeline is introduced into Clinical Closure.

## 10. Ownership matrix

| Domain | Authoritative owner | Clinical Closure behavior |
|---|---|---|
| Visit State | Shared Visit | Read-only reference |
| Visit lifecycle | Shared Visit | Boundary/command only when separately authorized |
| Treatment lifecycle | Treatment Planning | Read-only reference |
| Active clinical documentation | Clinical Workspace | Read-only context |
| Actual procedure | Performed Procedure | Boundary only |
| Closure Outcome | Clinical Closure | Editable/owned |
| Historical chronology | Clinical Record History | Boundary only |
| Dental Chart | Dental Chart | No mutation |

## 11. Remaining deferred detail

There is no unresolved ownership contradiction.

The only intentionally deferred detail is the exact interaction contract for a future `Close Visit` command. This is not a blocker for the current repository architecture because the current Phase 1 implementation does not contain that command.

## 12. Figma gate

This audit does **not** authorize Figma modification.

Before changing the current Clinical Closure composition, the following are required:

1. Re-approve Clinical Closure FIELD_SPECIFICATION v1.2.
2. Run Clinical Closure v1.2 Figma Preflight.
3. Confirm the exact existing canonical node and protected/frozen nodes.
4. Obtain explicit implementation authorization.
5. Modify only what the approved specification requires.
6. Run Structural QA, Visual/UX Audit, and Final QA.

## 13. Final result

**CROSS-MODULE DEPENDENCY AUDIT: PASS**

The repository architecture now has a coherent lifecycle boundary between Shared Visit and Clinical Closure without transferring Visit State ownership to Clinical Closure.

No Figma changes were made during this audit.
