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

Une fois l'installation terminée, ouvre OpenCode et tape le prompt correspondant à ton profil :

**Nouveau collaborateur :**
```
use skill collaborator-onboarding
```

**Membre de l'équipe Transfo :**
```
use skill collaborator-onboarding-transfo
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

À partir de tes réponses, l'agent génère un fichier de profil personnel sur ton Mac. Ce fichier est automatiquement chargé sur tous tes projets OpenCode : il calibre la posture, le format et le comportement de l'agent pour toutes tes conversations futures.

L'agent te montre le fichier généré et attend ta validation avant de l'écrire.

---

### Phase 2 — Installation de l'environnement de développement

L'agent installe automatiquement les outils nécessaires sur ton Mac. Si une étape échoue, il t'indique quoi faire.

À la fin de cette phase, ton environnement est prêt.

---

### Phase 3 — Configuration du projet

L'agent te pose 3 questions sur ton projet :
- Projet existant ou nouveau ?
- Tu travailles dans Google Workspace (Sheets, Docs, Forms...) ou autre chose ?
- Nom et description courte du projet

Selon tes réponses, il choisit le bon chemin :

**Projet Google Apps Script existant** — l'agent audite tous tes fichiers, identifie les patterns, les dépendances et les risques, puis génère les fichiers de gouvernance du projet :
- `AGENTS.md` — architecture, conventions de code, patterns récurrents, fichiers clés
- `TODO.md` — registre des bugs, améliorations et tâches identifiés pendant l'audit
- `TESTS.md` — parcours critiques à tester manuellement avant chaque modification
- `CHANGELOG.md` — historique des modifications

**Projet Google Apps Script nouveau** — l'agent t'interview sur le besoin, te guide pour créer le projet dans Google Apps Script en ligne, puis génère un template de démarrage prêt à l'emploi.

**Autre technologie** — l'agent génère un fichier de gouvernance minimal adapté à ta stack.

---

### Phase 4 — Installation des outils de sécurisation

Pour les projets Google Apps Script, l'agent connecte 3 outils au projet :

| Outil | Rôle |
|---|---|
| `gas-reviewer` | Vérifie automatiquement les fichiers avant chaque modification importante |
| `gas-impact-analyzer` | Analyse l'impact d'un changement avant de coder — bloque si le risque est élevé |
| `gas-regression-checker` | Liste les tests à effectuer manuellement après chaque modification |

Ces outils sont disponibles dans OpenCode pour toutes les sessions futures sur ce projet.

---

## Ce que tu obtiens à la fin

```
Ton profil personnel         — chargé automatiquement sur tous tes projets OpenCode
[projet]/AGENTS.md           — gouvernance du projet
[projet]/TODO.md             — registre des travaux identifiés
[projet]/TESTS.md            — parcours de tests critiques
[projet]/CHANGELOG.md        — historique
[projet]/.opencode/skills/   — gas-reviewer, gas-impact-analyzer, gas-regression-checker
```

---

## Mise à jour des skills

Pour mettre à jour tous les skills vers la dernière version :

```bash
curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install.sh | bash
```

La même commande que l'installation — elle écrase les fichiers existants avec la version la plus récente.
