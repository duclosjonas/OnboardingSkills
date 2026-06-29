---
name: gas-setup-node-clasp
description: Use when a developer needs to install Node.js, configure npm, and install clasp to push Google Apps Script code from their Mac. Covers nvm installation, clasp global install, Google OAuth login, and linking an existing or new Apps Script project. Triggered automatically by gas-onboarding-new before the Apps Script guide phase.
---

# GAS Setup — Node.js + Clasp

Tu guides quelqu'un qui veut pouvoir pousser son code Google Apps Script depuis son Mac avec clasp, sans avoir à copier-coller manuellement.

Objectif final : `clasp push` fonctionne depuis le terminal et envoie le code vers Apps Script.

---

## RÈGLES ABSOLUES

- Exécuter chaque commande UNE PAR UNE et attendre la confirmation que ça a marché
- Ne jamais passer à l'étape suivante si la précédente n'est pas confirmée
- Expliquer en une phrase POURQUOI on fait chaque chose
- Si une erreur survient : ne pas deviner, demander le message d'erreur exact

---

## PHASE 1 — Installation automatique Node.js + clasp

> "Un script fait tout automatiquement : détection Xcode, nvm, Node.js LTS, clasp. Lance une seule commande et suis les instructions."

### Étape 1.1 — Lancer le script d'installation

```bash
curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/setup.sh | bash
```

Le script gère tout dans l'ordre :
- Vérifie si Xcode Command Line Tools est installé
- Installe nvm si absent
- Installe Node.js LTS
- Installe clasp globalement
- Configure `~/.zshrc` pour la persistance

**Si le script s'arrête avec ce message :**
```
⚠️ Xcode Command Line Tools manquant.
Lance cette commande : xcode-select --install
```
→ Lancer `xcode-select --install` dans le terminal. Une fenêtre macOS s'ouvre — cliquer sur **"Installer"** (pas "Obtenir Xcode"). Attendre 5-10 minutes, puis relancer le script.

**Résultat attendu en fin de script :**
```
✅ Xcode Command Line Tools détecté
✅ nvm x.x.x
✅ Node.js vxx.x.x
✅ npm xx.x.x
✅ clasp x.x.x
```

Si une étape échoue : partager le message d'erreur exact affiché.

---

## PHASE 3 — Authentification Google

> "On va connecter clasp à ton compte Google. Clasp aura besoin d'accéder à Apps Script en ton nom pour pouvoir pousser du code."

### Étape 3.1 — Lancer le login

```bash
clasp login
```

Cela va :
1. Ouvrir une page dans le navigateur
2. Demander de choisir un compte Google
3. Afficher une liste de permissions à accorder (accès à Apps Script)
4. Rediriger vers une page de confirmation

> "Accorde toutes les permissions demandées — elles sont nécessaires pour que clasp puisse lire et écrire dans tes projets Apps Script."

### Étape 3.2 — Vérifier l'authentification

Après la confirmation dans le navigateur, le Terminal doit afficher :

```
Authorization successful.
```

Si ce message n'apparaît pas : demander le message exact affiché et ne pas continuer.

### Note sur les tokens

> "clasp stocke ton token d'authentification dans `~/.clasprc.json`. Ce fichier est personnel — ne jamais le partager ni le committer dans git."

---

## PHASE 4 — Lier le projet Apps Script

Demander :

> "Est-ce que tu veux lier un projet Apps Script qui existe déjà, ou créer un nouveau projet ?"

---

### CAS A — Projet existant (clasp clone)

> "On va récupérer le projet depuis Apps Script. Pour ça, on a besoin de son ID."

**Où trouver le Script ID :**
1. Ouvrir le projet sur [script.google.com](https://script.google.com)
2. Cliquer sur l'icône ⚙️ **Paramètres du projet** (barre gauche)
3. Copier la valeur **"ID du script"**

Une fois l'ID obtenu, demander de créer d'abord le dossier local :

```bash
mkdir -p ~/Projects/[nom-projet]/src
cd ~/Projects/[nom-projet]
```

Puis lancer le clone :

```bash
clasp clone <SCRIPT_ID> --rootDir ./src
```

> "`--rootDir ./src` indique à clasp que tous les fichiers `.gs` et `.html` du projet iront dans le sous-dossier `src/` — ce qui correspond à la structure standard du projet."

Résultat attendu :
- Les fichiers `.gs` du projet apparaissent dans `src/`
- Un fichier `.clasp.json` est créé à la racine avec le contenu :
  ```json
  { "scriptId": "<SCRIPT_ID>", "rootDir": "src" }
  ```

---

### CAS B — Nouveau projet (clasp create)

Demander le nom du projet, puis :

```bash
mkdir -p ~/Projects/[nom-projet]/src
cd ~/Projects/[nom-projet]
clasp create --title "[Nom du projet]" --type webapp --rootDir ./src
```

> "`--type webapp` configure le projet comme une WebApp Google Apps Script — le type le plus courant pour un projet avec une interface utilisateur."

Résultat attendu :
- Le projet est créé dans Apps Script
- Un fichier `.clasp.json` est créé à la racine
- Un fichier `src/appsscript.json` est créé (le manifest du projet)

---

## PHASE 5 — Premier push de test

> "On va faire un premier push pour vérifier que tout est bien configuré."

### Étape 5.1 — Push

```bash
clasp push
```

Depuis le dossier racine du projet (là où se trouve `.clasp.json`).

Résultat attendu :

```
Pushed X files.
```

### Erreurs courantes

**`Error: Script ID not found`**
→ Le fichier `.clasp.json` est absent ou dans le mauvais dossier. Vérifier qu'on est bien à la racine du projet avec `ls -la` et que `.clasp.json` est présent.

**`Error: unauthenticated`**
→ Le token a expiré. Relancer `clasp login`.

**`Error: appsscript.json is required`**
→ Le fichier `src/appsscript.json` est manquant. Créer ce fichier minimal :
```json
{
  "timeZone": "Europe/Paris",
  "dependencies": {},
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8"
}
```
Puis relancer `clasp push`.

**`Warning: files with extensions other than .gs, .html, .json will be ignored`**
→ Normal. clasp ignore les fichiers de gouvernance (AGENTS.md, TODO.md, etc.) — c'est le comportement attendu.

---

## PHASE 6 — Clôture

```
## Configuration clasp ✓

Environnement configuré :
├── Node.js LTS    → installé via nvm
├── clasp          → installé globalement (npm -g)
├── Authentification Google → ~/.clasprc.json (NE PAS committer)
└── .clasp.json    → lié au projet "[Nom du projet]"

Pour pousser ton code vers Apps Script à l'avenir :
  clasp push        (depuis la racine du projet)

Important :
- clasp push met à jour le code dans Apps Script
- Le déploiement WebApp reste manuel (script.google.com → Déployer)
- Ne jamais committer ~/.clasprc.json dans git
- Ajouter .clasprc.json à .gitignore si ce n'est pas déjà fait :
    echo ".clasprc.json" >> ~/.gitignore
```

Si ce skill a été déclenché depuis `gas-onboarding-new` : reprendre à la Phase 3 de `gas-onboarding-new` (guide Apps Script en ligne).
