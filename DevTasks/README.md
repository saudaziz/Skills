# DevTasks Skill Repo

This repository contains a reusable Codex-style skill named `DevTasks`.

It enforces a strict delivery pattern for `/DevTask` scenarios:
- Work starts in `develop` branch.
- QA baseline happens before implementation.
- Architect splits tasks and defines acceptance criteria.
- Developer implements and adds unit tests.
- Architect verifies implementation and test relevance.
- QA validates completion and regressions.
- Resume state is tracked in durable handoff files.

## Repository Layout

- `DevTasks/SKILL.md`: Skill instructions.
- `DevTasks/scripts/init-devtask.ps1`: Bootstraps branch + state files.
- `DevTasks/templates/`: Reusable templates for logs and planning.
- `DevTasks/state/`: Runtime artifacts generated per project execution.

## Bootstrap

From the repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .\DevTasks\scripts\init-devtask.ps1
```

## Use In CLI Prompts

### Codex (Recommended)

Invoke the skill by starting your prompt with `$DevTasks`:

```text
$DevTasks create a new task for adding login rate limiting
```

```text
$DevTasks continue the current task and generate acceptance criteria
```

```text
$DevTasks review current progress and list the next developer->architect->qa handoff
```

Quick usage flow:
1. Start prompt with `$DevTasks`.
2. Ask for one specific action (create/continue/update/review).
3. Include repo context and branch if relevant.
4. Request concrete output format (task card, checklist, or test plan).

### Codex CLI

```text
Use the DevTasks skill for this work. /DevTask
```

### Claude CLI

```text
Follow the DevTasks workflow: Architect -> Developer -> QA with acceptance criteria gates and QA baseline first. /DevTask
```

### Gemini CLI

```text
Apply the DevTasks pattern for this task, including develop branch, QA baseline, architect task cards, unit-test gate, architect verification, and QA closure. /DevTask
```

## Notes

- `PLAN_HYGIENE.md` is designed to list stale plan docs and requires explicit approval before delete or archive actions.
- Keep `DevTasks/state/PLAN_OF_ACTION.md` updated every task handoff so a new session can resume from the exact point.
