# OnboardingSkills

Kit d'onboarding pour nouveaux collaborateurs OpenCode.
En une commande, installe les skills nécessaires et guide le collaborateur à travers la configuration complète de son environnement de travail.

---

## Ouvrir un terminal sur Mac

Appuie sur `Cmd + Espace`, tape **Terminal**, appuie sur Entrée.

---

## Prérequis

- Mac
- [OpenCode](https://opencode.ai) installé
- Connexion internet

---

## Installation

Dans ton terminal, colle cette commande :

```bash
curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install.sh | bash
```

C'est tout. Le script installe les skills au bon endroit automatiquement.

---

## Démarrage

Une fois l'installation terminée :

1. Ouvre un terminal (Cmd + Espace → "Terminal" → Entrée)
2. Lance OpenCode : `opencode`
3. Dans OpenCode, tape ce prompt :

```
use skill collaborator-onboarding
```

L'agent prend le relais et enchaîne les 4 phases :

| Phase | Ce qui se passe | Output |
|---|---|---|
| 1 — Profil | 6 questions sur ta façon de travailler | `~/.config/opencode/AGENTS.md` — ton profil personnel chargé sur tous tes projets |
| 2 — Installation | Node.js (via nvm) + clasp + login Google OAuth | Environnement de développement GAS opérationnel |
| 3 — Projet | 3 questions sur ton projet | `projet/AGENTS.md` — configuration spécifique au projet |
| 4 — Skills | Installation des skills de sécurisation | `gas-reviewer`, `gas-impact-analyzer`, `gas-regression-checker` liés au projet |

---

## Skills inclus

| Skill | Rôle |
|---|---|
| `collaborator-onboarding` | Onboarding complet — ce que tu viens d'utiliser |
| `gas-reviewer` | Review automatique des fichiers GAS avant push — détecte les issues critiques |
| `gas-impact-analyzer` | Analyse l'impact d'une modification avant de coder — classifie LOW / MEDIUM / HIGH |
| `gas-regression-checker` | Liste les tests manuels à effectuer après chaque modification |
| `gas-setup-node-clasp` | Installation Node.js + clasp + login OAuth (invoqué par l'onboarding) |

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
