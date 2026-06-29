---
name: gas-regression-checker
description: Use at the end of every Google Apps Script session, after gas-reviewer returns "Ready to push: YES". Reads TESTS.md, compares modified files against test triggers, and lists which manual tests must be run before copying files to Apps Script. Never claims to have run the tests itself.
---

# GAS Regression Checker

## WHEN THIS RUNS
At the end of every session, after gas-reviewer has returned "Ready to push: YES".
If gas-reviewer returns "Ready to push: NO", do not run this skill yet.

## WHAT IT DOES
1. Read TESTS.md (all defined tests, format strict with Déclencheurs + Criticité 🔴/🟡/🟢)
2. List every file modified in this session AND every function whose body was modified
3. For each test, scan the "Déclencheurs" block (fichiers .gs + fichiers .html + constantes + services externes) and check if any modified file or function matches
4. Match rules:
   - File name match in "Fichiers .gs:" or "Fichiers .html:" → test impacted
   - Function name match in any trigger line → test impacted
   - Constant name match in config triggers → test impacted ONLY IF the constant value was modified (not just used)
   - Service externe match → test impacted ONLY IF the file modified is the one accessing that service
5. Collect ALL impacted tests (scan every test before output — no early return)
6. Sort impacted tests by criticality: 🔴 first, then 🟡, then 🟢

## OUTPUT FORMAT

### If no test is impacted

```
**Aucun parcours critique impacté par cette modification.**
```

### If at least one test is impacted

```
## TESTS À EFFECTUER AVANT COPIE VERS APPS SCRIPT

**Récap :** [X] test(s) 🔴 + [Y] test(s) 🟡 + [Z] test(s) 🟢

---

### 🔴 [Test ID] — [Test name]
**Pourquoi impacté :** [specific function or file that triggered the match]
**Étapes :** [copy from TESTS.md]
**Résultat attendu :** [copy from TESTS.md]

---

### 🟡 [Test ID] — [Test name]
...
```

Always end with:

```
Une fois ces tests effectués avec succès, confirme-moi pour que je marque l'item comme [x] dans TODO.md.
```

## RULES

- NEVER claim to have executed these tests yourself
- NEVER mark TODO.md as [x] until the user confirms tests passed
- ALWAYS list ALL impacted tests, never stop at the first match
- ALWAYS sort by criticality (🔴 → 🟡 → 🟢)
- ALWAYS explain WHY each test was matched (specific function or file name)
- If a 🔴 test is impacted, the user MUST run it before pushing — do not soften this language
