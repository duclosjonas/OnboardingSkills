---
name: gas-reviewer
description: Use when reviewing Google Apps Script (.gs) files modified during a session. Checks for critical issues (DOM APIs in .gs, empty catches, hardcoded emails/IDs, missing locks), HIGH issues (raw sheet names, missing return format), and MEDIUM warnings (debug logs, naming conventions). Run at end of every session before push.
---

# GAS Reviewer

Code reviewer specialized in Google Apps Script.
Apply ALL checks below to every file modified in this session.
Report results grouped by file, then fix all blocking issues automatically before closing.

---

## CHECKLIST

### 🔴 CRITICAL — Fix immediately, never deliver with these

- No browser DOM API in a .gs file (document.getElementById, document.createElement, etc.)
  → these crash with ReferenceError on the GAS server
- No empty catch block → minimum: Logger.log('[FUNCTION_NAME] Error: ' + e.message)
- No hardcoded email addresses in function bodies
  → must use constants from 00_Config.gs
- No hardcoded Drive/Slides/Sheet IDs in function bodies
  → must use constants from 00_Config.gs
- Every function writing to a Sheet must acquire a LockService lock:
  const lock = LockService.getScriptLock(); lock.tryLock(10000)

### 🟠 HIGH — Fix before delivering

- Sheet tab names must use TABS.* constants, never raw strings
  Exception: TABS definition itself in 00_Config.gs
- Column names must use COLUMN_CONFIG.* constants where available
- Every function exposed to UI via google.script.run must return
  { success: true } or { success: false, error: e.message }
- No new constants declared locally in a function body if they belong in 00_Config.gs
  (emails, IDs, thresholds, tab names)
- JSDoc required on every function — minimum @description, @param, @returns

### 🟡 MEDIUM — Flag but do not block

- No Logger.log or console.log debug lines left in production code
  → remove or gate behind a DEBUG_MODE constant in 00_Config.gs
- New functions must follow naming conventions defined in AGENTS.md:
  get prefix → data accessors
  save / submit prefix → write operations
  send prefix → email functions
  build prefix → HTML page constructors
  cron_ prefix → scheduled tasks
  _ prefix → private helpers
- Utility functions with no GAS dependency belong in 01_Utils.gs, not in service files

### 🔵 INFO — Note only, do not block

- Any new Sheet tab referenced must be added to TABS in 00_Config.gs
- Any new column referenced must be added to COLUMN_CONFIG in 00_Config.gs
- Functions longer than 80 lines should be flagged for future decomposition

---

## OUTPUT FORMAT

For each modified file output:

## [filename.gs]
✅ CRITICAL — all clear
⚠️  HIGH — [issue description] line [N]
❌ CRITICAL — [issue description] line [N]

Then output:

## SUMMARY
Ready to push: YES / NO
Blocking issues: [count]
Warnings: [count]

Rules:
- If blocking issues found: fix them all, then re-run the checklist and output a new SUMMARY
- Do NOT ask for confirmation before fixing — fix and report
- Only output "Ready to push: YES" when zero blocking issues remain
