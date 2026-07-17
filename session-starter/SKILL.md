---
name: session-starter
description: Use at the start of every work session on a Google Apps Script project. Reads governance files, presents open TODO items grouped by priority, and waits for the user to choose which item to work on. Automatically runs gas-impact-analyzer once the item is confirmed.
---

# Session Starter

## Ce que tu fais

1. Lire dans l'ordre : `AGENTS.md`, `TODO.md`, `PORTFOLIO_RULES.md`, `TESTS.md`
2. Présenter tous les items ouverts (`[ ]` ou `[~]`) depuis `TODO.md`, groupés ainsi :
   - CRASHES GARANTIS en premier
   - BUGS PRODUCTION
   - Puis par impact : HIGH → MEDIUM → LOW → NUL
   - Pour chaque item : ID + type + titre + impact + risque régression
3. Demander : "Sur quel item on travaille aujourd'hui ?"
4. Ne pas lire les fichiers `.gs` ou `.html` avant que l'item soit confirmé

## Une fois l'item confirmé

5. Charger le skill `gas-impact-analyzer` sur l'item confirmé
6. Appliquer la gate rule :
   - 🔴 HIGH → bloquer, proposer un découpage, attendre confirmation
   - 🟡 MEDIUM → afficher le rapport, attendre "go ahead"
   - 🟢 LOW → afficher le résumé en une ligne, procéder immédiatement

## Règles pendant la session

- Travailler sur UN item principal par session
- Autoriser les correctifs cascade uniquement s'ils découlent directement de l'item principal (même fichier, même fonction) — les lister dans FICHIERS MODIFIÉS avec la mention "cascade"
- Fermer l'item principal avant d'en ouvrir un autre

## Après chaque logical change unit (= un push clasp)

Produire dans l'ordre :

1. **REVIEW** — gas-reviewer checklist mentale, output SUMMARY (Ready to push: YES/NO)
2. **`clasp push`** — exécuter immédiatement, afficher le résultat. Si erreur : bloquer, afficher l'erreur, proposer le fix, attendre confirmation
3. **FICHIERS MODIFIÉS** — tableau de chaque fichier modifié + description en une ligne
4. **TESTS À EFFECTUER** — gas-regression-checker mentale, lister les tests T1-T13 impactés avec criticité, ou "Aucun parcours critique impacté"
5. Attendre confirmation des tests avant toute action suivante

## En fin de session ("end session" ou "session terminée")

1. Lancer gas-reviewer sur tous les fichiers modifiés pendant la session
2. Corriger les issues bloquantes sans demander confirmation
3. Outputter le SUMMARY block
4. Si Ready to push: NO → ne pas mettre à jour TODO.md, expliquer ce qui reste, attendre confirmation
5. Si Ready to push: YES → lancer gas-regression-checker, lister les tests impactés, attendre confirmation
6. Une fois les tests confirmés :
   - Mettre à jour TODO.md : `[ ]` ou `[~]` → `[x]` avec la date du jour (DD/MM/YYYY)
   - Ajouter une entrée dans CHANGELOG.md :
     ```
     ## [DD/MM/YYYY] [item ID]
     **Fichier(s) :** [fichiers modifiés]
     **Modification :** [description en une ligne]
     **Impact analyzer :** [niveau + raison]
     **Reviewer :** Ready to push: YES
     **Tests impactés :** [IDs ou "aucun"]
     **Statut :** [x]
     ```
   - Exécuter : `git add -A && git commit -m "[item ID]: [description]"`
   - Afficher le prompt de démarrage pour la prochaine session, pré-rempli avec le prochain item ouvert
