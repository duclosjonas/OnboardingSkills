---
name: gas-onboarding-existing
description: Use when onboarding an existing Google Apps Script project that has no governance files yet. Interviews the developer, audits all .gs and .html files, then generates AGENTS.md, TODO.md, TESTS.md and CHANGELOG.md. Ends by verifying the three global security skills are available.
---

# GAS Onboarding — Projet Existant

Tu onboardes un projet Google Apps Script qui existe déjà mais n'a pas encore de fichiers de gouvernance.
Objectif : comprendre le projet, auditer le code, produire tous les fichiers qui sécuriseront les sessions suivantes.

Tu ne génères aucune ligne de logique métier. Tu audites et tu documentes.

---

## RÈGLES ABSOLUES

- Ne lire aucun fichier de code avant la fin de la Phase 1
- Poser les questions UNE PAR UNE — attendre la réponse avant de passer à la suivante
- Ne générer aucun fichier avant validation explicite de l'étape précédente
- Ne jamais écraser un fichier existant sans confirmation
- **NE JAMAIS créer, modifier ou corriger du code pendant l'onboarding** — chaque problème détecté va dans TODO.md, point final. Même si le fix semble trivial. Même si l'utilisateur demande de le faire maintenant. La réponse est toujours : "Je note ça dans TODO.md — on traitera ça en session de travail."
- **L'ordre des phases est obligatoire** : audit → AGENTS.md → TODO.md → TESTS.md → CHANGELOG.md. Ne pas sauter ni fusionner des phases.

---

## PRÉAMBULE — Fichiers en local ?

Avant de commencer, vérifier si les fichiers .gs sont déjà en local.
Si non (uniquement dans Apps Script en ligne) :

> "Avant l'audit, on va copier tes fichiers en local. Dans Apps Script, pour chaque fichier .gs : clique sur les 3 points → Afficher → sélectionne tout (Cmd+A) → copie (Cmd+C). Crée ensuite le fichier correspondant dans `~/Projects/[nom-projet]/src/` et colle le contenu. Dis-moi quand c'est fait."

Attendre confirmation avant de passer à la Phase 1.

---

## PHASE 1 — INTERVIEW (questions une par une)

Commence par :
> "Avant de lire une seule ligne de code, j'ai besoin de comprendre ton projet. Quelques questions courtes — réponds comme tu veux."

---

### Q1 — Le projet
> "Quel est le nom de ton projet, et en une phrase : à quoi il sert ?"

---

### Q2 — Les utilisateurs
> "Qui utilise ce projet ? Nombre de personnes et profil (techniques / non-techniques / internes) ?"

---

### Q3 — Le parcours critique
> "Si tu devais choisir UN seul parcours dans ton application — celui dont la panne bloquerait tout le monde immédiatement — lequel ce serait ?"

---

### Q3b — Les étapes du parcours critique
> "Pour ce parcours, décris les actions dans l'ordre — depuis l'URL ou le bouton de départ, jusqu'au moment où l'utilisateur sait que ça a marché."

---

### Q3c — La preuve que ça a marché
> "Comment tu sais que ce parcours a fonctionné ? Quelque chose s'écrit dans un Sheet ? Un email part ? Un message s'affiche ?"

---

### Q4 — L'équipe
> "Tu travailles seul sur ce code, ou d'autres personnes y touchent aussi ?"

---

### Q5 — La prod cassée
> "Tu as déjà poussé quelque chose qui a cassé la prod ? Si oui — comment tu t'en es rendu compte ?"

---

### Q6 — Les règles non écrites
> "Ton projet a sûrement des règles jamais documentées. Aide-moi à les trouver :
> - Y a-t-il des étapes que tes utilisateurs doivent faire dans un ordre précis ?
> - Y a-t-il des données qu'on ne doit jamais écraser ?
> - Y a-t-il des cas particuliers que toi seul gères manuellement ?"

---

### Q7 — Le risque principal
> "Sur ce projet en ce moment, qu'est-ce qui te prendrait le plus de temps à réparer si ça cassait ?"

---

### Q8 — La fréquence
> "À quelle fréquence tu modifies ce projet — tous les jours, toutes les semaines, de temps en temps ?"

---

### Q9 — Les services externes
> "Ton projet appelle-t-il des services externes — APIs tierces, d'autres Google Sheets, Gmail, Drive, Calendar ?"

---

### Q10 — Le fichier de config
> "Y a-t-il un fichier qui regroupe toutes tes constantes — noms d'onglets, IDs Drive, adresses email ? Si oui, comment il s'appelle ?"

---

### Synthèse Phase 1

```
## Ce que j'ai compris

**Projet :** [nom] — [description]
**Utilisateurs :** [nb et profil]
**Parcours critique (T1) :** [résumé Q3]
  Étapes : [résumé Q3b]
  Preuve de succès : [résumé Q3c]
**Équipe :** [solo / multi]
**Risque principal :** [résumé Q7]
**Fréquence :** [quotidien / hebdo / ponctuel]
**Services externes :** [liste ou "aucun détecté"]
**Fichier de config :** [nom ou "non identifié — à créer"]

C'est bon ? Je passe à l'audit du code.
```

Attendre confirmation avant de commencer la Phase 2.

---

## PHASE 2 — AUDIT DU CODE

Lire tous les fichiers `.gs` et `.html` du projet. Chercher dans cet ordre de priorité :

### 2.1 Crashes garantis 🔴
- Routes HTTP (doGet/doPost) qui appellent une fonction introuvable
- Fichiers HTML référencés via `HtmlService.createTemplateFromFile()` qui n'existent pas
- Fonctions appelées depuis `google.script.run` côté HTML inexistantes dans les .gs
- Triggers (onFormSubmit, onOpen, onEdit) qui appellent des fonctions inexistantes

### 2.2 Bugs silencieux 🟡
- Blocs `catch` vides ou qui ne font que `console.log`
- Fonctions UI via `google.script.run` qui ne retournent pas `{ success, error }`
- Fonctions d'écriture dans Sheets sans `LockService`

### 2.3 Code mort 🗑️
- Fonctions définies mais jamais appelées nulle part
- Fichiers .gs ou .html ni importés ni routés ni référencés

### 2.4 Dette technique ⚠️
- Noms d'onglets Sheets écrits en dur
- Adresses email écrites en dur dans des fonctions
- IDs Drive/Slides/Sheets écrits en dur dans des fonctions
- Fonctions sans JSDoc
- Conventions de nommage incohérentes

### Format de chaque trouvaille

```
| ID       | Type | Titre court                         | Impact | Régression | Statut |
| §BUG-01  | BUG  | Route ?flow=X → handler introuvable  | HIGH   | ÉLEVÉ      | [ ]    |
```

Types : `BUG` · `DEAD` · `HARD` · `CMT` · `FEAT` · `OPT`
Impact : `NUL` · `FAIBLE` · `LOW` · `MEDIUM` · `HIGH`
Régression : `NUL` · `TRÈS FAIBLE` · `FAIBLE` · `MOYEN` · `ÉLEVÉ`

Après l'audit :
```
Audit terminé — [X] crashes, [Y] bugs, [Z] code mort, [W] dette technique.
Je génère AGENTS.md maintenant.
```

⚠️ NE PAS corriger ou créer de fichier de code à ce stade. Toutes les trouvailles iront dans TODO.md en Phase 4. Passer immédiatement à la Phase 3.

---

## PHASE 3 — GÉNÉRATION DE AGENTS.md

Générer AGENTS.md complet. Afficher, demander "C'est bon ?" et attendre validation.

Le fichier doit contenir :
- Description du projet (Q1 + Q2)
- Architecture des fichiers (liste complète .gs et .html avec rôle déduit)
- Modules principaux (regroupement logique)
- Fichiers clés
- Conventions de code imposées (voir section CONVENTIONS ci-dessous)
- Patterns récurrents observés dans le code
- Dépendances entre fichiers clés
- Onglets Google Sheets utilisés
- Règles métier (déduit de Q6)
- Workflow de développement (copier-coller OpenCode → Apps Script)
- SESSION PROTOCOL complet (voir section PROTOCOL ci-dessous)

### CONVENTIONS À INCLURE DANS AGENTS.md

```markdown
## Conventions de code

### Nommage des fichiers .gs (standard imposé)
- `00_Config.gs` → configuration globale (toujours présent, chargé en premier)
- `01_Utils.gs` → utilitaires purs sans dépendance GAS
- `10_Router.gs` → doGet() / doPost() si WebApp
- `2X_Svc_<Module>.gs` → services métier
- `5X_View_<Module>.gs` → constructeurs de pages HTML
> La numérotation indique l'ordre de dépendance.

### Nommage des fonctions (standard imposé)
- `camelCase` pour toutes les fonctions publiques
- Préfixe `get` → accesseurs de données
- Préfixe `save` / `submit` → écritures dans Sheets
- Préfixe `send` → envois email
- Préfixe `build` → constructeurs de pages HTML
- Préfixe `cron_` → tâches planifiées
- Préfixe `_` → helpers internes (non appelés depuis d'autres fichiers)

### JSDoc obligatoire sur toutes les fonctions
/**
 * @description Ce que fait la fonction en une phrase.
 * @param {Type} paramName - Description.
 * @returns {Object} { success: boolean, error?: string }
 */

### Retour standard pour les fonctions UI
return { success: true };
return { success: false, error: e.message };
```

### SESSION PROTOCOL À INCLURE DANS AGENTS.md

```markdown
## SESSION PROTOCOL

> Trigger phrase : "Start of session. Follow SESSION PROTOCOL."

### Début de session
1. Lire AGENTS.md + TODO.md
2. Présenter tous les items ouverts ([ ] ou [~]), groupés par priorité
3. Demander sur quel item travailler — NE PAS commencer sans confirmation
4. Lancer gas-impact-analyzer :
   - 🔴 HIGH → bloquer, proposer un split, attendre confirmation
   - 🟡 MEDIUM → présenter le rapport, attendre "go ahead"
   - 🟢 LOW → résumé une ligne, procéder immédiatement

### Après CHAQUE modification de code

1. **REVIEW** — gas-reviewer → SUMMARY (Ready to push: YES/NO)
2. **FICHIERS À COPIER DANS APPS SCRIPT** — table :
   | Fichier local | Fichier Apps Script | Changement |
3. **ORDRE DE COPIE** — dépendances d'abord
4. **TESTS À EFFECTUER** — gas-regression-checker (criticité 🔴/🟡/🟢)
5. **ATTENDRE** confirmation avant toute action supplémentaire

### Fin de session
1. gas-reviewer sur tous les fichiers modifiés
2. Corriger les blocking issues sans demander confirmation
3. SUMMARY final → si YES : gas-regression-checker → attendre confirmation tests
4. Une fois confirmé :
   - TODO.md : [ ] → [x] avec date DD/MM/YYYY
   - CHANGELOG.md : nouvelle entrée
   - Prompt d'ouverture de la prochaine session

### Mise à jour de TESTS.md
Quand une nouvelle fonction est exposée via `google.script.run` ou qu'une nouvelle route doGet est ajoutée, proposer d'ajouter un test dans TESTS.md avant de clore la session.

### Règle d'or
Un item. Une session. Toujours.
```

---

## PHASE 4 — GÉNÉRATION DE TODO.md

Générer TODO.md à partir des trouvailles de l'audit. Afficher, demander validation.

```markdown
# [NOM DU PROJET] — TODO.md

Registre unique des travaux à réaliser.
> Ce fichier est la seule source de vérité active.

**Statuts** : `[ ]` À faire · `[~]` En cours · `[x]` Fait
**Types** : `BUG` · `DEAD` · `CMT` · `HARD` · `HTML` · `NOM` · `FEAT` · `OPT`
**Impact** : `NUL` · `FAIBLE` · `LOW` · `MEDIUM` · `HIGH`
**Régression** : `NUL` · `TRÈS FAIBLE` · `FAIBLE` · `MOYEN` · `ÉLEVÉ`

---

## Tableau de bord

| ID | Type | Titre | Impact | Régression | Statut | Dépendances |
|---|---|---|---|---|---|---|
| **— CRASHES GARANTIS —** |||||||
[items 🔴]
| **— BUGS PRODUCTION —** |||||||
[items 🟡]
| **— CORRECTIONS À RISQUE NUL —** |||||||
[items faible risque]
| **— DETTE TECHNIQUE —** |||||||
[items dette]
| **— ÉVOLUTIONS —** |||||||
[items FEAT/OPT]

---

## Détail des items

[Pour chaque item : ID, fichiers concernés, description du problème, fix suggéré]

---

## Historique

- **[DATE]** : création — [X] items détectés par gas-onboarding-existing.
```

---

## PHASE 5 — GÉNÉRATION DE TESTS.md

Questions par parcours, une par une.

### 5.1 — Présentation des candidats

Identifier depuis l'audit :
- Fonctions exposées via `google.script.run`
- Routes `doGet` / `doPost` actives
- Triggers (onFormSubmit, onEdit, onOpen)
- Services externes détectés

> "Voici les parcours candidats à des tests : [liste]. En vois-tu d'autres ?"

Attendre. Ajuster si nécessaire.

### 5.2 — Questions par parcours

Pour chaque parcours (T1 partiellement pré-rempli depuis Q3b/Q3c) :

**A — Étapes :** "Comment tu le testerais manuellement — depuis le début jusqu'au moment où tu sais que c'est bon ?"
**B — Preuves :** "Qu'est-ce qui prouve que ça a fonctionné ? (Sheet / email / UI)"
**C — Criticité :** "Si ce parcours est cassé : bloquant 🔴 / gênant 🟡 / mineur 🟢 ?"

### 5.3 — Format TESTS.md

```markdown
# [NOM DU PROJET] — Parcours critiques

> Référence unique pour la régression manuelle.
> Utilisé par gas-regression-checker.
>
> **Échelle :** 🔴 Bloquant prod · 🟡 Dégradation acceptable · 🟢 Cosmétique

---

### T1 — [Nom du parcours critique — Q3]
**Criticité :** 🔴

**Déclencheurs :**
- Fichiers .gs : [fichier (fonction)]
- Fichiers .html : [fichier]
- Constantes config : [TABS.X]
- Services externes : [ou "aucun"]

**Étapes :**
1. [URL ou déclencheur exact]
2. [Action]
3. [Observation]

**Résultat attendu :**
- [UI]
- [Sheet si applicable]
- [Email si applicable]
```

---

## PHASE 6 — GÉNÉRATION DE CHANGELOG.md

```markdown
# [NOM DU PROJET] — Changelog

> Mis à jour automatiquement en fin de chaque session OpenCode.

---

<!--
## [DD/MM/YYYY] [ID item]
**Fichier(s) :** [fichiers]
**Modification :** [une ligne]
**Impact analyzer :** [niveau + raison]
**Reviewer :** Ready to push: YES
**Tests impactés :** [IDs ou "aucun"]
**Statut :** [x]
-->

<!-- Les entrées seront ajoutées ici, de la plus récente à la plus ancienne. -->
```

---

## PHASE 7 — VÉRIFICATION DES SKILLS GLOBAUX

Ne pas regénérer les skills — ils sont installés globalement dans `~/.config/opencode/skills/`.
Vérifier simplement qu'ils sont disponibles :

> "Les skills de sécurisation sont installés globalement et disponibles sur ce projet :
> - gas-reviewer → checklist avant chaque copie vers Apps Script
> - gas-impact-analyzer → analyse d'impact avant de modifier du code
> - gas-regression-checker → tests à effectuer après chaque modification"

Si un skill semble manquant (non listé dans les skills disponibles), signaler à l'utilisateur qu'il doit vérifier `~/.config/opencode/skills/`.

---

## PHASE 8 — CLÔTURE

```
## Onboarding complet ✓

Fichiers de gouvernance générés :
├── AGENTS.md       → architecture + conventions + SESSION PROTOCOL
├── TODO.md         → [X] items ([Y] crashes, [Z] bugs, [W] dette)
├── TESTS.md        → T1 à T[N] définis
└── CHANGELOG.md    → structure prête

Skills disponibles globalement :
├── gas-reviewer          → checklist avant chaque push
├── gas-impact-analyzer   → analyse d'impact avant de coder
└── gas-regression-checker → tests après chaque modification

Pour démarrer ta première session de travail :
"Start of session. Follow SESSION PROTOCOL."
```
