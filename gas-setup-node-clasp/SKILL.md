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

## PHASE 1 — Installer Node.js via nvm

> "On va installer Node.js via nvm (Node Version Manager). Cela permet de gérer plusieurs versions de Node sur le même Mac sans conflit."

### Étape 1.1 — Installer nvm

Demander d'exécuter cette commande dans le Terminal :

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

> "Cette commande télécharge et installe nvm. Elle va modifier ton fichier `~/.zshrc` pour que nvm soit disponible à chaque ouverture du Terminal."

Attendre la confirmation que la commande s'est terminée sans erreur.

### Étape 1.2 — Recharger le Terminal

```bash
source ~/.zshrc
```

> "On recharge la configuration du Terminal pour que nvm soit immédiatement disponible sans avoir à fermer et rouvrir le Terminal."

### Étape 1.3 — Vérifier nvm

```bash
nvm --version
```

Résultat attendu : un numéro de version (ex: `0.39.7`).

Si la commande retourne `command not found` : demander le contenu de `~/.zshrc` et vérifier que les lignes nvm sont présentes à la fin.

### Étape 1.4 — Installer Node.js LTS

```bash
nvm install --lts
```

> "On installe la version LTS (Long Term Support) de Node.js — la plus stable et recommandée pour les outils de développement."

Attendre la fin de l'installation.

### Étape 1.5 — Vérifier Node.js et npm

```bash
node -v
npm -v
```

Résultats attendus : deux numéros de version (ex: `v20.x.x` et `10.x.x`).

Si l'un ou l'autre échoue : ne pas continuer, demander le message d'erreur.

---

## PHASE 2 — Installer clasp

> "clasp (Command Line Apps Script) est l'outil officiel de Google pour pousser du code depuis ton Mac vers Apps Script sans passer par l'interface web."

### Étape 2.1 — Installer clasp globalement

```bash
npm install -g @google/clasp
```

> "L'option `-g` installe clasp pour l'ensemble du Mac, pas seulement pour un projet — il sera disponible dans tous tes dossiers."

### Étape 2.2 — Vérifier clasp

```bash
clasp -v
```

Résultat attendu : un numéro de version (ex: `2.4.x`).

**Erreur courante — `clasp: command not found` après l'install :**
> "C'est souvent un problème de PATH avec nvm. Essaie :"
```bash
npm config get prefix
```
Si le chemin ne contient pas `nvm`, exécuter :
```bash
nvm use --lts
npm install -g @google/clasp
```
Puis retenter `clasp -v`.

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
