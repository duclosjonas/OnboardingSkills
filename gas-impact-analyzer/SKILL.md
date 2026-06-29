---
name: gas-impact-analyzer
description: Use when starting work on a TODO.md item in a Google Apps Script project. Analyzes the planned change, identifies all callers across the codebase, and classifies impact as LOW (proceed), MEDIUM (wait for go-ahead), or HIGH (block and propose split). Run automatically after the user confirms the item to work on.
---

# GAS Impact Analyzer

Impact analysis specialist for Google Apps Script projects.
When triggered, analyze the planned change for a given TODO item and produce a structured impact report before any modification is made.

---

## TRIGGER

Triggered automatically after the user confirms the item to work on during SESSION PROTOCOL.

---

## ANALYSIS STEPS

1. Read the target item from TODO.md (description, files, lines)
2. For each file listed in the item:
   - Read the relevant function(s)
   - Identify all callers across the entire codebase (grep for function name, constant name, or tab name)
3. Assess cross-file dependencies using the dependency graph in AGENTS.md
4. Classify the impact level (see below)
5. Output the impact report

---

## IMPACT CLASSIFICATION

### 🔴 HIGH — Block and propose split
Criteria (any one is sufficient):
- Change affects a function called from 5+ files
- Change modifies 00_Config.gs constants already used across multiple files (TABS, COLUMN_CONFIG, admin emails)
- Change deletes or renames a function exposed via google.script.run
- Change touches a cron_ or onFormSubmit trigger function
- Change modifies doGet() or doPost() (HTTP router)

Action: Do NOT proceed. Output the report, list the risks, propose a smaller split of the work. Wait for user confirmation.

### 🟡 MEDIUM — Propose and wait for confirmation
Criteria:
- Change affects 2–4 files
- Change modifies a constant or function used in both .gs and .html files
- Change involves a Sheet tab rename or column rename

Action: Output the report and wait for explicit user confirmation ("go ahead" or "ok") before modifying any file.

### 🟢 LOW — Proceed directly
Criteria:
- Change is self-contained in 1 file
- Change is a constant extraction (no logic change)
- Change is a comment/JSDoc cleanup
- Change affects a deprecated function

Action: Output a one-line impact summary, then proceed immediately without waiting.

---

## OUTPUT FORMAT

## IMPACT REPORT — [ITEM_ID]

**Item:** [short description]
**Files to modify:** [list]
**Callers found:** [function → file:line, ...]
**Risk level:** 🔴 HIGH / 🟡 MEDIUM / 🟢 LOW

**Rationale:** [1–3 sentences explaining the classification]

**Proposed approach:** [ordered list of changes]

---
[For HIGH only:]
⛔ Blocked — confirm split before proceeding.

[For MEDIUM only:]
Reply "go ahead" to proceed.

[For LOW only:]
Proceeding with modifications.

---

## RULES

- Never skip the analysis, even for trivial-looking items
- Always grep for callers before classifying as LOW
- If a function is called from an .html file via google.script.run, treat it as MEDIUM minimum
- Do not modify any file until the impact level allows it
