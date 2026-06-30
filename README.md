# OnboardingSkills

Kit d'onboarding pour nouveaux collaborateurs OpenCode.
En une commande, installe les skills nécessaires et guide le collaborateur à travers la configuration complète de son environnement de travail.

---

## Prérequis

Avoir fait l'onboarding OpenCode via l'équipe Gen IA. C'est tout — OpenCode est déjà installé sur ton Mac.

---

## Installation

Ouvre un terminal (Cmd + Espace → "Terminal" → Entrée) et colle cette commande :

```bash
curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install.sh | bash
```

C'est tout. Le script installe les skills au bon endroit automatiquement.

---

## Démarrage

Une fois l'installation terminée :

1. Ouvre OpenCode
2. Tape ce prompt :

```
use skill collaborator-onboarding
```

L'agent prend le relais et enchaîne les 4 phases dans l'ordre.

---

## Ce qui se passe phase par phase

### Phase 1 — Profil de travail

L'agent te pose quelques questions, une par une :
- Ton prénom
- La langue dans laquelle tu veux que l'agent te réponde (français, anglais, autre)
- Ce qui t'irrite dans les réponses d'un agent (trop long, trop servile, ne challenge pas...)
- Ta préférence de posture : agent qui exécute, ou agent qui challenge si la demande est bancale
- Longueur des réponses souhaitée par défaut
- Ton métier et ce qui t'a amené à utiliser OpenCode
- Ton mode de validation : agir directement sur les tâches courtes, ou toujours confirmer avant

À partir de tes réponses, l'agent génère un fichier `~/.config/opencode/AGENTS.md` — ton profil personnel. Ce fichier est automatiquement chargé sur tous tes projets OpenCode : il calibre la posture, le format et le comportement de l'agent pour toutes tes conversations futures.

L'agent te montre le fichier généré et attend ta validation avant de l'écrire.

---

### Phase 2 — Installation de l'environnement de développement

Avant d'installer quoi que ce soit, le script vérifie que **Xcode Command Line Tools** est présent sur ton Mac. C'est le package Apple qui fournit les outils de compilation de base (`git`, `make`, `clang`...) — nécessaire pour que Node.js puisse compiler certains modules natifs lors de son installation. Si absent, le script t'indique comment l'installer (`xcode-select --install`) et attend que tu relances.

L'agent installe ensuite automatiquement :
- **nvm** — outil qui permet d'installer et de gérer plusieurs versions de Node.js sur ton Mac
- **Node.js LTS** — l'environnement d'exécution JavaScript nécessaire pour faire tourner clasp
- **clasp** — l'outil qui permet de pousser ton code depuis ton Mac vers Google Apps Script, sans passer par l'éditeur en ligne

Il te guide ensuite pour te connecter à ton compte Google via OAuth, ce qui permet à clasp d'accéder à tes projets Apps Script.

---

### Phase 3 — Configuration du projet

L'agent te pose 3 questions sur ton projet :
- Projet existant ou nouveau ?
- Tu travailles dans Google Workspace (Sheets, Docs, Forms...) ou autre chose ?
- Nom et description courte du projet

Selon tes réponses, il choisit le bon chemin :

**Projet GAS existant** — l'agent audite tous tes fichiers `.gs` et `.html`, identifie les patterns, les dépendances et les risques, puis génère les fichiers de gouvernance du projet :
- `AGENTS.md` — architecture, conventions de code, patterns récurrents, fichiers clés
- `TODO.md` — registre des bugs, améliorations et tâches identifiés pendant l'audit
- `TESTS.md` — parcours critiques à tester manuellement avant chaque push
- `CHANGELOG.md` — historique des modifications

**Projet GAS nouveau** — l'agent t'interview sur le besoin, crée la structure de dossiers locale et génère un template `00_Config.gs` prêt à l'emploi, puis te guide pour créer le projet dans Apps Script.

**Autre stack** — l'agent génère un `AGENTS.md` minimal adapté à la technologie.

---

### Phase 4 — Installation des skills de sécurisation

Pour les projets GAS, l'agent installe et lie au projet les 3 skills de sécurisation :

| Skill | Rôle |
|---|---|
| `gas-reviewer` | Review automatique des fichiers GAS avant push — détecte les issues critiques, bloquantes ou à surveiller |
| `gas-impact-analyzer` | Analyse l'impact d'une modification avant de coder — classifie LOW / MEDIUM / HIGH et bloque si nécessaire |
| `gas-regression-checker` | Après chaque modification, liste les tests manuels à effectuer avant de pousser en production |

Ces skills sont disponibles dans OpenCode pour toutes les sessions futures sur ce projet.

---

## Ce que tu obtiens à la fin

```
~/.config/opencode/AGENTS.md       — ton profil personnel (tous projets)
[projet]/AGENTS.md                 — gouvernance du projet
[projet]/TODO.md                   — registre des travaux identifiés
[projet]/TESTS.md                  — parcours de tests critiques
[projet]/CHANGELOG.md              — historique
[projet]/.opencode/skills/         — gas-reviewer, gas-impact-analyzer, gas-regression-checker
```

---

## Lier clasp à un projet GAS existant

Cette étape est manuelle — elle se fait une fois par projet.

1. Ouvre [script.google.com](https://script.google.com)
2. Ouvre ton projet Apps Script → icône ⚙️ Paramètres du projet
3. Copie l'**ID du script**
4. Dans ton terminal, depuis le dossier du projet :

```bash
# Si tu veux cloner le projet localement depuis Apps Script :
clasp clone <ID_SCRIPT>

# Si le code est déjà en local, créer .clasp.json manuellement :
echo '{"scriptId":"<ID_SCRIPT>","rootDir":"."}' > .clasp.json
```

5. Vérifie que ça fonctionne :
```bash
clasp status
```

---

## Mise à jour des skills

Pour mettre à jour tous les skills vers la dernière version :

```bash
curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install.sh | bash
```

La même commande que l'installation — elle écrase les fichiers existants avec la version la plus récente.
