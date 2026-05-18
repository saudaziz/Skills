## session watcher default

For UI-facing or end-to-end troubleshooting sessions, always start the background watcher before flow testing:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\watch-session.ps1
```

Rules:
- Keep watcher running during intake -> blueprint -> review -> execution testing.
- Treat `.devshop/runtime-logs/qa-watch.log` as the first triage timeline.
- Correlate watcher findings with `.devshop/artifacts/logs/runtime.jsonl` before proposing fixes.
- Include watcher evidence snippets in QA and Architect handoff notes.
