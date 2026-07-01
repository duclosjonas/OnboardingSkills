---
name: gas-onboarding-new
description: Use when a developer is starting a brand new Google Apps Script project from scratch. Interviews them to understand their need, creates the local folder structure and governance files on their Mac, generates a structured 00_Config.gs template, and guides them step by step to create the project in Apps Script online.
---

# GAS Onboarding — Nouveau Projet

Tu accompagnes quelqu'un qui crée son tout premier projet Google Apps Script.
Ton objectif : poser les bonnes bases dès le départ — structure de fichiers, conventions de code, gouvernance — pour que le projet soit maintenable même dans 6 mois.

Tu ne génères aucune ligne de logique métier. Tu crées la structure et les fichiers de démarrage.

---

## RÈGLES ABSOLUES

- Poser les questions UNE PAR UNE, attendre la réponse à chaque fois
- Ne créer aucun fichier avant la fin de la Phase 1
- Ne jamais sauter une étape — l'ordre est important pour un débutant
- Expliquer POURQUOI on fait chaque chose en une phrase courte (pédagogie)

---

## PHASE 1 — INTERVIEW (questions une par une)

### Q1 — Le projet
> "Quel nom tu veux donner à ton projet ? (Ce sera aussi le nom du dossier sur ton Mac.)"

*Attendre la réponse. Normaliser le nom : minuscules, tirets à la place des espaces, pas d'accents. Ex: "Hub Projets" → "hub-projets".*

---

### Q2 — Le besoin
> "En une ou deux phrases : à quoi il sert ce projet ? Qu'est-ce qu'il va permettre de faire ?"

*Garder cette réponse pour remplir AGENTS.md.*

---

### Q3 — Les utilisateurs
> "Qui va utiliser ce projet ? Donne-moi une idée du nombre de personnes et de leur profil."

*Calibre la criticité future. Un outil pour 50 personnes non-techniques n'a pas le même niveau de risque qu'un script personnel.*

---

### Q4 — Les données
> "Tes données sont déjà dans un Google Sheets existant, ou tu vas en créer un nouveau ?"

- **Sheets existant** → noter l'URL ou le nom, à ajouter dans 00_Config.gs
- **Nouveau** → on créera le Sheets plus tard, manuellement

---

### Q5 — Les modules prévus
> "Tu as déjà une idée des grandes fonctions que tu veux dans ce projet ? Par exemple : afficher une liste, soumettre un formulaire, envoyer un email automatique... Liste tout ce qui te vient."

*Cette réponse oriente la structure de fichiers et les futurs modules dans AGENTS.md.*

---

### Synthèse Phase 1

Après la dernière réponse, afficher :

```
## Ce que j'ai compris

**Nom du projet :** [nom normalisé]
**Description :** [Q2]
**Utilisateurs :** [Q3]
**Données :** [Sheets existant / nouveau Sheets à créer]
**Modules prévus :** [liste déduite de Q5]

C'est bon ? Je crée la structure du projet.
```

Attendre confirmation avant de commencer la Phase 2.

---

## PHASE 2 — CRÉATION DE LA STRUCTURE LOCALE

Créer la structure suivante dans `~/Projects/<nom-projet>/` :

```
~/Projects/<nom-projet>/
├── AGENTS.md
├── TODO.md
├── TESTS.md
├── CHANGELOG.md
├── .opencode/
└── src/
    └── 00_Config.gs
```

> Pourquoi cette structure ? Les fichiers de gouvernance (AGENTS.md, TODO.md, TESTS.md, CHANGELOG.md) sont à la racine pour être lus immédiatement par OpenCode. Le code source va dans src/ pour le séparer de la documentation.

Créer les fichiers dans cet ordre :

---

### 2.1 — `src/00_Config.gs`

```javascript
/**
 * @fileoverview Configuration globale — source de vérité du projet.
 * Toutes les constantes (noms d'onglets, emails, IDs Drive) sont déclarées ici.
 * Ne jamais écrire ces valeurs en dur dans d'autres fichiers.
 *
 * Convention de nommage des fichiers :
 *   00_Config.gs      → configuration (ce fichier, chargé en premier)
 *   01_Utils.gs       → fonctions utilitaires pures (pas de dépendance GAS)
 *   10_Router.gs      → doGet() / doPost() (point d'entrée HTTP)
 *   2X_Svc_Module.gs  → services métier
 *   5X_View_Module.gs → constructeurs de pages HTML
 *
 * La numérotation indique l'ordre de dépendance : un fichier ne doit jamais
 * appeler une fonction définie dans un fichier avec un numéro plus élevé.
 *
 * @module 00_Config
 */

/**
 * Noms des onglets Google Sheets utilisés par le projet.
 * Toujours utiliser TABS.X dans le code — jamais le nom en dur.
 * @const {Object}
 */
var TABS = {
  // Exemple : PROJECTS: 'Projets'
};

/**
 * Configuration des colonnes par onglet.
 * Permet de résister aux réorganisations de colonnes dans le Sheets.
 * @const {Object}
 */
var COLUMN_CONFIG = {
  // Exemple :
  // PROJECTS: {
  //   CODE: 'Project Code',
  //   STATUS: 'Status',
  // }
};

/**
 * Emails des administrateurs et responsables du projet.
 * Ne jamais écrire d'adresse email en dur dans une fonction.
 * @const {Object}
 */
var ADMIN_EMAILS = {
  // Exemple : ADMIN: 'admin@monentreprise.com'
};

/**
 * IDs des fichiers Google Drive utilisés par le projet (templates, dossiers...).
 * Récupérer l'ID depuis l'URL du fichier Drive.
 * @const {Object}
 */
var DRIVE_IDS = {
  // Exemple : TEMPLATE_SLIDE: '1ABC...'
};

/**
 * URL de la WebApp déployée.
 * À remplir après le premier déploiement dans Apps Script.
 * @const {string}
 */
var WEB_APP_URL = '';
```

---

### 2.2 — `AGENTS.md`

```markdown
# [NOM DU PROJET] — AGENTS.md

## Description du projet
[Q2 — description du projet]
Utilisateurs : [Q3]

## Architecture
- Fichiers .gs : logique serveur (Google Apps Script)
- Fichiers .html : vues et composants UI (à créer au fil du projet)
- Déployé comme WebApp Google Apps Script

## Modules prévus
[Liste déduite de Q5 — à affiner au fil du projet]

## Fichiers clés
- `src/00_Config.gs` : configuration globale (constantes, noms d'onglets, emails, IDs Drive)

## Registres de référence

| Fichier | Rôle |
|---|---|
| `AGENTS.md` | Architecture & protocole — ce fichier |
| `TODO.md` | Registre unique des travaux |
| `TESTS.md` | Parcours critiques pour régression |
| `CHANGELOG.md` | Historique des sessions |

## Conventions de code

### Nommage des fichiers .gs (numérotation obligatoire)
- `00_Config.gs` → configuration globale (toujours présent, chargé en premier)
- `01_Utils.gs` → utilitaires purs sans dépendance GAS
- `10_Router.gs` → doGet() / doPost() si WebApp
- `2X_Svc_<Module>.gs` → services métier
- `5X_View_<Module>.gs` → constructeurs de pages HTML

> La numérotation indique l'ordre de dépendance. Un fichier ne doit jamais appeler une fonction d'un fichier avec un numéro plus élevé.

### Nommage des fonctions (standard imposé)
- `camelCase` pour toutes les fonctions publiques
- Préfixe `get` → accesseurs de données : `getProjectList()`
- Préfixe `save` / `submit` → écritures dans Sheets : `saveProjectData()`
- Préfixe `send` → envois email : `sendNotificationEmail()`
- Préfixe `build` → constructeurs de pages HTML : `buildMainPage()`
- Préfixe `cron_` → tâches planifiées : `cron_DailySync()`
- Préfixe `_` → helpers internes (non appelés depuis d'autres fichiers) : `_formatDate()`

### Nommage des variables
- `var` obligatoire pour les constantes globales inter-fichiers (contrainte GAS)
- `const` / `let` dans les corps de fonctions
- Constantes de configuration en `UPPER_SNAKE_CASE` : `TABS`, `COLUMN_CONFIG`, `ADMIN_EMAILS`

### JSDoc obligatoire sur toutes les fonctions
Minimum requis :
```javascript
/**
 * @description Ce que fait la fonction en une phrase.
 * @param {string} paramName - Description du paramètre.
 * @returns {Object} { success: boolean, error?: string }
 */
```

### Retour standard pour les fonctions appelées depuis l'UI
```javascript
return { success: true };
return { success: false, error: e.message };
```

### Accès aux feuilles Google Sheets
- Noms d'onglets via `TABS.X` — jamais en dur dans le code
- Noms de colonnes via `COLUMN_CONFIG.ONGLET.CLÉ`
- Résolution dynamique des index (résistance aux réorganisations) :
```javascript
const data = sheet.getDataRange().getValues();
const headers = data[0].map(h => String(h).toLowerCase().trim());
const idxCode = headers.indexOf('project code');
```

## Patterns à respecter

### Lock concurrentiel systématique
Toute fonction d'écriture dans un Sheet doit acquérir un verrou :
```javascript
const lock = LockService.getScriptLock();
if (!lock.tryLock(10000)) return { success: false, error: 'Serveur occupé.' };
try { /* écriture */ } finally { lock.releaseLock(); }
```

### Dégradation gracieuse
Les appels externes (Drive, Gmail) sont enveloppés dans try/catch pour ne jamais bloquer la sauvegarde principale :
```javascript
try { sendNotificationEmail(...); } catch(e) { Logger.log(e.message); }
```

## Workflow de développement
1. Modifier le code dans OpenCode (dossier local `src/`)
2. À la fin de chaque session, copier-coller les fichiers listés dans le bloc "FICHIERS À COPIER" vers l'éditeur Apps Script en ligne (script.google.com)
3. Coller dans l'ordre indiqué — cliquer sur le fichier dans la barre gauche, Cmd+A, Cmd+V, Cmd+S
4. Tester dans la WebApp déployée

## Mise à jour de TESTS.md
Quand une nouvelle fonction est exposée via `google.script.run` ou qu'une nouvelle route doGet est ajoutée, proposer d'ajouter un test dans TESTS.md avant de clore la session. TESTS.md est le filet de sécurité contre les régressions — le tenir à jour est aussi important que le code lui-même.

---

## SESSION PROTOCOL

> Trigger phrase : "Start of session. Follow SESSION PROTOCOL."
> Quand tu lis cette phrase, exécute les étapes 1-4 immédiatement sans attendre.

### Début de session
1. Lire AGENTS.md + TODO.md
2. Présenter tous les items ouverts (statut `[ ]` ou `[~]`), groupés par priorité (crashes > bugs > évolutions)
3. Demander sur quel item travailler — NE PAS commencer sans confirmation
4. Lancer gas-impact-analyzer sur l'item confirmé :
   - 🔴 HIGH → bloquer, proposer un split, attendre confirmation
   - 🟡 MEDIUM → présenter le rapport, attendre "go ahead"
   - 🟢 LOW → résumé une ligne, procéder immédiatement

### Après CHAQUE modification de code (même en cours de session)

Dès qu'une modification est appliquée, toujours produire ce bloc dans cet ordre :

1. **REVIEW** — appliquer la checklist gas-reviewer sur les fichiers modifiés → SUMMARY (Ready to push: YES/NO)
2. **FICHIERS À COPIER DANS APPS SCRIPT** — table explicite :
   | Fichier local | Fichier Apps Script | Changement |
   |---|---|---|
   | src/00_Config.gs | 00_Config | ... |
3. **ORDRE DE COPIE** — si plusieurs fichiers, indiquer l'ordre (les dépendances d'abord)
4. **TESTS À EFFECTUER** — lister les tests impactés depuis TESTS.md (criticité 🔴/🟡/🟢), ou "Aucun parcours critique impacté"
5. **ATTENDRE** confirmation que les tests passent avant toute action supplémentaire

L'utilisateur ne doit jamais avoir à demander "quels fichiers je copie ?" ou "qu'est-ce que je teste ?" — c'est toujours fourni proactivement.

### Fin de session ("end session" ou équivalent)
1. Lancer gas-reviewer sur tous les fichiers modifiés
2. Corriger tous les blocking issues (sans demander confirmation)
3. Produire le SUMMARY final
4. Si Ready to push: NO → expliquer ce qui reste, attendre confirmation avant de clore
5. Si Ready to push: YES → lancer gas-regression-checker → attendre confirmation tests
6. Une fois les tests confirmés :
   - Mettre à jour TODO.md : `[ ]` ou `[~]` → `[x]` avec la date du jour (DD/MM/YYYY)
   - Ajouter une entrée dans CHANGELOG.md :
     ```
     ## [DD/MM/YYYY] [ID item]
     **Fichier(s) :** [fichiers modifiés]
     **Modification :** [description une ligne]
     **Impact analyzer :** [niveau + raison]
     **Reviewer :** Ready to push: YES
     **Tests impactés :** [IDs ou "aucun"]
     **Statut :** [x]
     ```
   - Produire le prompt d'ouverture de la prochaine session

### Règle d'or
Un item. Une session. Toujours.
```

---

### 2.3 — `TODO.md`

```markdown
# [NOM DU PROJET] — TODO.md

Registre unique des travaux à réaliser.

> Ce fichier est la seule source de vérité active pour les tâches.

**Statuts** : `[ ]` À faire · `[~]` En cours · `[x]` Fait

**Types** : `BUG` · `DEAD` · `CMT` · `HARD` · `HTML` · `NOM` · `FEAT` · `OPT`

**Impact technique** : `NUL` · `FAIBLE` · `LOW` · `MEDIUM` · `HIGH`

**Risque régression** : `NUL` · `TRÈS FAIBLE` · `FAIBLE` · `MOYEN` · `ÉLEVÉ`

---

## Tableau de bord

| ID | Type | Titre | Impact | Régression | Statut | Dépendances |
|---|---|---|---|---|---|---|
| **— ÉVOLUTIONS —** |||||||
[Items à ajouter au fil du projet]

---

## Historique

- **[DATE DE CRÉATION]** : initialisation du projet — TODO.md créé par gas-onboarding-new.
```

---

### 2.4 — `TESTS.md`

```markdown
# [NOM DU PROJET] — Parcours critiques

> Référence unique pour la régression manuelle.
> Utilisé par gas-regression-checker pour identifier les tests à effectuer après chaque modification.
>
> Fichier créé à l'initialisation — aucun test défini pour l'instant.
> À mettre à jour dès qu'un premier parcours utilisateur est implémenté.
>
> **Règle :** quand une nouvelle fonction est exposée via `google.script.run` ou qu'une
> nouvelle route doGet est ajoutée, ajouter un test ici avant de clore la session.
>
> **Échelle de criticité** :
> - 🔴 Bloquant prod — si KO, un utilisateur ne peut plus avancer
> - 🟡 Dégradation acceptable — si KO, c'est gênant mais contournable
> - 🟢 Cosmétique / non bloquant — impact mineur

---

## Comment ajouter un test
1. Identifier le parcours (1 phrase)
2. Choisir un ID séquentiel (T1, T2, T3...)
3. Définir la criticité 🔴/🟡/🟢
4. Lister les fichiers déclencheurs (utilisés par gas-regression-checker pour le matching)
5. Décrire les étapes (reproductibles en moins d'une minute)
6. Décrire le résultat attendu (UI + Sheet + email si applicable)

## Format d'un test

### T[N] — [Nom du parcours]
**Criticité :** 🔴/🟡/🟢

**Déclencheurs :**
- Fichiers .gs : [fichier.gs (nomFonction)]
- Fichiers .html : [fichier.html]
- Constantes config : [TABS.X, COLUMN_CONFIG.Y]
- Services externes : [Gmail / Drive / aucun]

**Étapes :**
1. [Action précise — URL ou déclencheur exact]
2. [Ce qu'on fait]
3. [Ce qu'on observe]

**Résultat attendu :**
- [Ce qui doit apparaître dans l'UI]
- [Ce qui doit être écrit dans le Sheet si applicable]
- [Email reçu si applicable]
```

---

### 2.5 — `CHANGELOG.md`

```markdown
# [NOM DU PROJET] — Changelog

> Mis à jour automatiquement en fin de chaque session OpenCode.
> Une entrée par item traité.

---

## Format d'une entrée

<!--
## [DD/MM/YYYY] [ID item]
**Fichier(s) :** [fichiers modifiés]
**Modification :** [description en une ligne]
**Impact analyzer :** [niveau + raison]
**Reviewer :** Ready to push: YES
**Tests impactés :** [IDs ou "aucun"]
**Statut :** [x]
-->

---

<!-- Les entrées seront ajoutées ici, de la plus récente à la plus ancienne. -->
```

---

## PHASE 2b — CONFIGURATION DE CLASP

Avant de passer au guide Apps Script, configurer l'environnement de développement :

> "Pour que OpenCode puisse pousser ton code directement vers Apps Script (sans copier-coller à chaque fois), on a besoin de configurer clasp. Je charge le skill dédié."

Charger et exécuter le skill `gas-setup-node-clasp` dans son intégralité.
Ne reprendre la Phase 3 qu'une fois que `clasp push` fonctionne et que le projet est lié.

---

## PHASE 3 — GUIDE APPS SCRIPT EN LIGNE

Une fois clasp configuré et le projet lié, guider manuellement étape par étape :

> "Maintenant on va créer le projet dans Google Apps Script. C'est là que ton code s'exécutera réellement. Suis ces étapes :"

1. Ouvre [script.google.com](https://script.google.com) dans ton navigateur
2. Clique sur **"Nouveau projet"** (bouton en haut à gauche)
3. Le projet s'appelle "Mon projet" par défaut — clique sur ce nom et renomme-le en **"[NOM DU PROJET]"**
4. Tu vois un fichier `Code.gs` vide — on va le renommer : clique sur les 3 points à droite de "Code.gs" → **Renommer** → tape `00_Config`
5. Copie-colle le contenu de ton fichier local `src/00_Config.gs` dans cet éditeur
6. Clique sur l'icône disquette (ou `Cmd+S`) pour sauvegarder

> "C'est tout pour l'instant ! Au fur et à mesure que tu ajouteras des fichiers `.gs` en local, tu devras créer les fichiers correspondants dans cet éditeur et coller le contenu."

---

## PHASE 4 — CLÔTURE

```
## Projet initialisé ✓

Structure créée dans ~/Projects/[nom-projet]/ :
├── AGENTS.md       → architecture + SESSION PROTOCOL + conventions
├── TODO.md         → registre des tâches (vide, prêt à être alimenté)
├── TESTS.md        → squelette prêt, à compléter au fil du projet
├── CHANGELOG.md    → historique des sessions
└── src/
    └── 00_Config.gs → configuration globale (constantes à remplir)

Pour démarrer ta première session de développement, ouvre OpenCode
dans ce dossier et tape :

"Start of session. Follow SESSION PROTOCOL."

OpenCode lira AGENTS.md + TODO.md et te guidera pour la suite.
```
