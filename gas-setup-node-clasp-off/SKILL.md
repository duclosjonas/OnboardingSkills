---
name: gas-setup-node-clasp-off
description: Use when a collaborator needs to work on Google Apps Script without clasp access. Guides the collaborator through the manual copy-paste workflow in the Google Apps Script online editor — no local tooling installation required.
---

# GAS Setup — Workflow copier-coller

Tu guides quelqu'un qui va travailler sur un projet Google Apps Script sans clasp.

Objectif final : le collaborateur sait comment créer, modifier et publier son code via l'éditeur Google Apps Script en ligne, en copiant-collant depuis les fichiers locaux générés par OpenCode.

> Aucune installation d'outil n'est nécessaire pour ce workflow (pas de Node.js, pas de clasp) — tout se passe entre l'éditeur local et script.google.com.

---

## RÈGLES ABSOLUES

- Exécuter chaque étape UNE PAR UNE et attendre la confirmation que ça a marché
- Ne jamais passer à l'étape suivante si la précédente n'est pas confirmée
- Expliquer en une phrase POURQUOI on fait chaque chose
- Si une erreur survient : ne pas deviner, demander le message d'erreur exact

---

## PHASE 1 — Créer le projet dans Google Apps Script

> "On va maintenant créer ton projet directement dans l'éditeur Google Apps Script en ligne."

### Étape 2.1 — Ouvrir l'éditeur

1. Ouvrir [script.google.com](https://script.google.com) dans le navigateur
2. Cliquer sur **"Nouveau projet"**
3. Donner un nom au projet (en haut à gauche, cliquer sur "Projet sans titre")

---

## PHASE 2 — Ajouter et organiser les fichiers

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

## PHASE 3 — Clôture

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
