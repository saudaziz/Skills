---
name: DevTasks
description: Enforces a repeatable Architect -> Developer -> QA delivery workflow with develop-branch execution, testable task slicing, acceptance criteria gates, QA baseline capture, and resumable handoff tracking for any /DevTask scenario.
---

# DevTasks Skill

Use this skill when the user asks for `/DevTask` or asks for a structured delivery flow with planning, task splitting, verification, and validation.

## Trigger

Activate when request includes one or more:
- `/DevTask`
- "start in develop branch"
- "architect developer qa"
- "acceptance criteria"
- "verification and validation"
- "resume from handoff"

## Mandatory Workflow

1. Branch Gate
- Ensure current branch is `develop`.
- If missing, create from `main` (or current default branch) and switch.
- Record branch decision in `DevTasks/state/PLAN_OF_ACTION.md`.

2. QA Baseline First
- QA captures current behavior before changes.
- Run smoke or full user-flow checks for impacted scope.
- Write findings to `DevTasks/state/QA_BASELINE_LOG.md`.
- No implementation starts until baseline is written.

3. Architect Planning
- Architect decomposes work into small testable tasks.
- Every task must have explicit acceptance criteria.
- Record in `DevTasks/state/TASK_BOARD.md` using task card format.

4. Developer Execution Per Task
- Implement one task at a time.
- Add or update unit tests tied to that task’s acceptance criteria.
- Update task evidence section with changed files, tests, and outputs.
- Hand task back to Architect for verification.

5. Architect Verification
- Verify implementation and tests actually satisfy acceptance criteria.
- If failed, return to Developer with defect notes.
- If passed, sign off and forward task to QA.

6. QA Validation and Regression
- Validate accepted task in user-visible flows.
- Compare with baseline to confirm no regressions.
- Mark task closed only after pass in `TASK_BOARD.md`.

7. Continuity/Handoff
- Keep `PLAN_OF_ACTION.md` updated with current owner, active task, and next step.
- This file is the single source of truth for resume across sessions.

8. Plan Hygiene
- Detect duplicate or stale planning docs.
- Do not delete without user approval.
- Propose merge/archive list in `DevTasks/state/PLAN_HYGIENE.md` and wait for approval.

## Required Artifacts

Create and keep updated:
- `DevTasks/state/PLAN_OF_ACTION.md`
- `DevTasks/state/QA_BASELINE_LOG.md`
- `DevTasks/state/TASK_BOARD.md`
- `DevTasks/state/PLAN_HYGIENE.md`

## Role Contract

Architect responsibilities:
- Define testable tasks.
- Define acceptance criteria.
- Verify developer output and unit-test relevance.
- Pass only verified tasks to QA.

Developer responsibilities:
- Implement according to acceptance criteria.
- Add task-targeted unit tests.
- Provide objective evidence for verification.

QA responsibilities:
- Capture pre-change baseline.
- Validate each architect-approved task.
- Confirm user-visible behavior remains functional.

## Completion Criteria

A task can be closed only when:
- Developer implementation complete.
- Unit tests added/updated and passing.
- Architect verification passed.
- QA validation passed including regression checks.
- Task status updated to `Closed` in `TASK_BOARD.md`.

## Fast Start

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\DevTasks\scripts\init-devtask.ps1
```

Then start work by writing or updating `DevTasks/state/PLAN_OF_ACTION.md` and `DevTasks/state/TASK_BOARD.md`.
