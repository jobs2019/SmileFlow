#!/usr/bin/env python3
"""Validate SmileFlow repository governance consistency.

This validator intentionally checks governance relationships rather than trying to
infer missing architecture or Figma state. It fails closed when authoritative
records contradict one another.
"""

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    p = ROOT / path
    if not p.exists():
        fail(f"Missing required governance file: {path}")
    return p.read_text(encoding="utf-8")


def fail(message: str) -> None:
    print(f"ERROR: {message}")
    errors.append(message)


def normalize(name: str) -> str:
    name = name.strip().strip("`")
    name = re.sub(r"\s+", " ", name)
    name = re.sub(r"\s+—\s+(?:Phase 1\s+—\s+)?Canonical$", "", name)
    name = re.sub(r"\s+—\s+Phase 1$", "", name)
    return name


def frozen_names(text: str) -> set[str]:
    names = set()
    in_canonical = False
    for line in text.splitlines():
        if line.startswith("## Canonical modules"):
            in_canonical = True
            continue
        if line.startswith("## ") and in_canonical:
            in_canonical = False
        if in_canonical and line.startswith("-") and "FROZEN" in line:
            value = line[1:].split("— FROZEN", 1)[0].strip()
            value = value.split(" (`", 1)[0].strip()
            names.add(normalize(value))
    return names


def project_frozen_names(text: str) -> set[str]:
    names = set()
    in_frozen = False
    for line in text.splitlines():
        if line.startswith("## Frozen / complete"):
            in_frozen = True
            continue
        if line.startswith("## ") and in_frozen:
            in_frozen = False
        if in_frozen and re.match(r"^\d+\. ", line):
            value = re.sub(r"^\d+\. ", "", line).strip()
            names.add(normalize(value))
    return names


def module_dir_for(name: str) -> Path | None:
    explicit = {
        "Patient Management": "patient-management",
        "Patient Registration": "patient-registration",
        "Dental Chart": "dental-chart",
        "Treatment Planning": "treatment-planning",
        "Clinical Workspace": "clinical-workspace",
        "Clinical Closure": "clinical-closure",
        "Shared Visit": "shared-visit",
        "Performed Procedure": "performed-procedure",
        "Clinical Record History": "clinical-record-history",
    }
    dirname = explicit.get(name)
    return ROOT / "modules" / dirname if dirname else None


errors: list[str] = []
project_state = read("PROJECT_STATE.md")
frozen_registry = read("governance/FROZEN_MODULES.md")
source_of_truth = read("SOURCE_OF_TRUTH.md")
root_agents = read("AGENTS.md")

# 1. Every frozen project-state entry must be present in the frozen registry.
project_frozen = project_frozen_names(project_state)
registry_frozen = frozen_names(frozen_registry)
for name in sorted(project_frozen - registry_frozen):
    fail(f"PROJECT_STATE marks '{name}' frozen/complete but FROZEN_MODULES.md does not.")
for name in sorted(registry_frozen - project_frozen):
    # Patient Management/Registration may be represented without the long canonical suffix.
    fail(f"FROZEN_MODULES.md marks '{name}' frozen but PROJECT_STATE.md does not.")

# 2. Every official module must have a local AGENTS.md.
official_modules = {
    "patient-management",
    "patient-registration",
    "dental-chart",
    "treatment-planning",
    "clinical-workspace",
    "clinical-closure",
    "shared-visit",
    "performed-procedure",
    "clinical-record-history",
}
modules_root = ROOT / "modules"
actual_dirs = {p.name for p in modules_root.iterdir() if p.is_dir()} if modules_root.exists() else set()
for dirname in sorted(official_modules - actual_dirs):
    fail(f"Official module '{dirname}' is missing from modules/.")
for dirname in sorted(actual_dirs - official_modules):
    fail(f"Unexpected module directory '{dirname}' is not registered as an official SmileFlow module.")
for dirname in sorted(official_modules & actual_dirs):
    if not (modules_root / dirname / "AGENTS.md").exists():
        fail(f"Module '{dirname}' is missing modules/{dirname}/AGENTS.md.")

# 3. Frozen registry must agree with explicit not-frozen declarations for key transition modules.
if "Clinical Closure" in registry_frozen:
    fail("Clinical Closure must not be frozen while it is the next draft module.")
if "Clinical Workspace" in registry_frozen:
    fail("Clinical Workspace replacement must not be frozen before replacement implementation.")
if "Clinical Closure — next module" not in project_state:
    fail("PROJECT_STATE.md must explicitly identify Clinical Closure as the next module.")

# 4. Clinical Workspace replacement must remain pre-implementation.
required_workspace_markers = [
    "Architecture: APPROVED",
    "Field Specification: APPROVED",
    "Figma implementation: NOT IMPLEMENTED",
    "Figma pre-flight: NOT STARTED",
    "Freeze: NOT READY",
    "Sole authorized action: `Save Clinical Notes`.",
]
for marker in required_workspace_markers:
    if marker not in project_state:
        fail(f"Clinical Workspace governance marker missing from PROJECT_STATE.md: {marker}")

# 5. Clinical Closure must remain draft/not implemented until explicitly advanced.
closure_requirements = [
    "Architecture: DRAFT FOR APPROVAL",
    "Field Specification: NOT APPROVED",
    "Implementation: NOT IMPLEMENTED",
    "Freeze: NOT FROZEN",
]
for marker in closure_requirements:
    if marker not in project_state:
        fail(f"Clinical Closure transition marker missing from PROJECT_STATE.md: {marker}")

closure_arch = ROOT / "modules/clinical-closure/ARCHITECTURE.md"
if closure_arch.exists() and "DRAFT FOR APPROVAL" not in closure_arch.read_text(encoding="utf-8"):
    fail("Clinical Closure architecture is expected to remain DRAFT FOR APPROVAL.")

# 6. SOURCE_OF_TRUTH and AGENTS must explicitly enforce fail-closed behavior.
for marker in [
    "Current Clinical Workspace exception",
    "Contradiction protocol",
    "Figma is not the repository authority",
]:
    if marker not in source_of_truth:
        fail(f"SOURCE_OF_TRUTH.md is missing required governance section: {marker}")
for marker in [
    "Figma preflight — mandatory before every write",
    "Feature addition/removal protocol",
    "Frozen modules",
]:
    if marker not in root_agents:
        fail(f"AGENTS.md is missing required safety section: {marker}")

# 7. Do not allow obvious stale state markers to return.
for stale in [
    "Clinical Closure — NEXT" if False else "",
    "Clinical Workspace — FROZEN",
    "Clinical Closure — FROZEN",
    "READY TO FREEZE",
]:
    if stale and stale in project_state:
        fail(f"Stale contradictory project-state marker found: {stale}")

if errors:
    print(f"\nSmileFlow governance validation FAILED with {len(errors)} error(s).")
    sys.exit(1)

print("SmileFlow governance validation PASSED.")
print(f"Official modules checked: {len(official_modules)}")
print(f"Frozen modules checked: {len(registry_frozen)}")
print("Clinical Workspace replacement remains preflight-only.")
print("Clinical Closure remains draft/not implemented/not frozen.")
