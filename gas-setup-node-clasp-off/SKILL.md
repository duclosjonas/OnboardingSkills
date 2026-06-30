---
name: gas-setup-node-clasp-off
description: Use when a collaborator needs to set up their development environment without clasp access. Installs nvm and Node.js, then guides the collaborator through the manual copy-paste workflow in the Google Apps Script online editor.
---

# GAS Setup — Environnement de développement

Tu guides quelqu'un qui configure son environnement pour travailler sur un projet Google Apps Script.

Objectif final : l'environnement est installé et le collaborateur sait comment modifier et publier son code via l'éditeur Google Apps Script en ligne.

---

## RÈGLES ABSOLUES

- Exécuter chaque commande UNE PAR UNE et attendre la confirmation que ça a marché
- Ne jamais passer à l'étape suivante si la précédente n'est pas confirmée
- Expliquer en une phrase POURQUOI on fait chaque chose
- Si une erreur survient : ne pas deviner, demander le message d'erreur exact

---

## PHASE 1 — Installation automatique de l'environnement

> "Un script fait tout automatiquement : il installe les outils de développement nécessaires sur ton Mac. Lance une seule commande et suis les instructions."

### Étape 1.1 — Lancer le script d'installation

```bash
curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/setup.sh | bash
```

Le script gère tout dans l'ordre :
- Vérifie si les outils de compilation macOS sont installés
- Installe nvm (gestionnaire de versions Node.js)
- Installe Node.js LTS
- Installe les outils de développement nécessaires
- Configure ton terminal pour la persistance

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

## PHASE 2 — Créer le projet dans Google Apps Script

> "On va maintenant créer ton projet directement dans l'éditeur Google Apps Script en ligne."

### Étape 2.1 — Ouvrir l'éditeur

1. Ouvrir [script.google.com](https://script.google.com) dans le navigateur
2. Cliquer sur **"Nouveau projet"**
3. Donner un nom au projet (en haut à gauche, cliquer sur "Projet sans titre")

---

## PHASE 3 — Ajouter et organiser les fichiers

> "On va maintenant créer les fichiers du projet et y coller le code."

### Étape 3.1 — Ajouter un fichier

Dans l'éditeur Apps Script :
1. Cliquer sur le **+** à côté de "Fichiers" (panneau de gauche)
2. Choisir le type de fichier :
   - **Script** → pour les fichiers `.gs` (logique serveur)
   - **HTML** → pour les fichiers `.html` (interface utilisateur)
3. Donner le nom exact du fichier (sans extension — Apps Script l'ajoute automatiquement)

### Étape 3.2 — Coller le contenu

1. Cliquer sur le fichier créé dans le panneau de gauche
2. Sélectionner tout le contenu existant (Cmd+A) et le supprimer
3. Coller le contenu du fichier correspondant (Cmd+V)
4. Sauvegarder (Cmd+S)

Répéter pour chaque fichier du projet.

### Étape 3.3 — Vérifier

Une fois tous les fichiers ajoutés :
- Tous les fichiers du projet apparaissent dans le panneau de gauche
- Aucune erreur de syntaxe n'est signalée (icône rouge dans l'éditeur)

Si une erreur apparaît : partager le message exact affiché.

---

## PHASE 4 — Clôture

```
Environnement prêt.

Ton projet est configuré dans Google Apps Script en ligne.
Pour modifier du code à l'avenir :
  1. Ouvre script.google.com
  2. Ouvre ton projet
  3. Modifie le fichier concerné et sauvegarde (Cmd+S)

Pour déployer une modification :
  → Déployer → Gérer les déploiements → Nouvelle version
```

Si ce skill a été déclenché depuis `gas-onboarding-new` : reprendre à la Phase 3 de `gas-onboarding-new` (guide Apps Script en ligne).
