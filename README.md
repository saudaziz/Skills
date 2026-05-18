# Skills Repository

This repository is the central home for reusable CLI skill packages.

## Purpose

- Store skill definitions and supporting assets in one place.
- Version skill changes with Git so they can be shared and installed consistently.
- Keep each skill self-contained with its own docs, scripts, templates, and runtime scaffolding.

## Current Skills

- `DevTasks`: Structured Architect -> Developer -> QA workflow with acceptance criteria gates, QA baseline capture, and resumable handoff tracking.

See: `DevTasks/README.md` for usage and installation details.

## Repository Structure

Each skill should live in its own top-level folder and include, at minimum:

- `SKILL.md` for skill behavior and contract.
- `README.md` for usage and setup notes.
- Optional `scripts/` for automation helpers.
- Optional `templates/` for reusable artifacts.
- Optional `state/` scaffolds if the workflow requires durable runtime files.

## Notes

- This is an evolving repository; `DevTasks` is the first published skill.
- New skills will be added as separate top-level folders following the same pattern.
