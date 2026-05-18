### Background Session Watcher (Default)

For UI troubleshooting and QA sessions, run the watcher in a separate terminal before testing:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\watch-session.ps1
```

The watcher writes issue-focused events to:

```text
.devshop/runtime-logs/qa-watch.log
```

Use this as the first triage source for reconnect loops, dead buttons, missing blueprint content, and API/UI mismatch symptoms. Keep it running through the full intake -> blueprint -> review -> execution flow.
