---
name: collaborator-onboarding
description: Use when a new collaborator starts with OpenCode. Guides through 4 phases in order: work profile interview (generates ~/.config/opencode/AGENTS.md), Node.js and clasp installation, project setup (existing or new, GAS or other stack), and security skills installation (gas-reviewer, gas-impact-analyzer, gas-regression-checker).
---

# Skill — Collaborator Onboarding

## Description
Skill d'onboarding complet pour un nouveau collaborateur OpenCode.
Enchaîne 4 phases dans l'ordre : profil de travail → installation Node.js + clasp → configuration projet → installation des skills de sécurisation.

À exécuter une seule fois, en début de collaboration.

---

## Déclencheur
Ce skill est invoqué quand un collaborateur démarre avec OpenCode pour la première fois, ou quand quelqu'un partage le lien d'installation.

---

## Phase 1 — Interview profil de travail

Pose les questions suivantes, une par une. Attends la réponse avant de passer à la suivante. Ne groupe jamais plusieurs questions dans un même message.

**Q0 — Prénom**
"Pour commencer, comment tu t'appelles ?"

**Q1 — Langue**
"Dans quelle langue tu travailles principalement avec un agent IA ? (français, anglais, autre)"

**Q2 — Ce qui irrite**
"Qu'est-ce qui te dérange le plus dans une réponse d'agent IA ? (trop long, trop servile, trop technique, ne challenge pas, autre)"

**Q3 — Posture**
"Tu préfères un agent qui exécute ce que tu demandes sans discuter, ou qui te challenge si ta demande lui semble bancale ou incomplète ?"

**Q4 — Longueur des réponses**
"Par défaut, tu veux des réponses courtes et directes, ou tu préfères qu'il développe et explique ?"

**Q5 — Contexte et usage**
"C'est quoi ton métier, et qu'est-ce qui t'a amené à utiliser OpenCode ?"

**Q6 — Validation avant action**
"Sur une tâche courte et claire, l'agent peut agir directement ou tu veux toujours valider avant qu'il modifie quoi que ce soit ?"

**Q7 — Optionnelle**
Ne poser Q7 que si la réponse à Q2 est vague ou trop courte pour alimenter le bloc `<jamais>` (moins de 2 irritants précis identifiés) :
"Y a-t-il des façons de faire que tu veux que l'agent évite systématiquement ?"

### Génération du profil

À partir des réponses, génère le fichier `~/.config/opencode/AGENTS.md` en suivant ce template. Adapte chaque section aux réponses réelles — ne copie pas le template mot pour mot.

```markdown
# Profil — [Prénom Nom]

> Fichier de gouvernance transverse — chargé sur tous les projets OpenCode.
> Mis à jour par l'agent si [Prénom] corrige ou rejette explicitement une approche, après confirmation.

---

## Contexte
[2-3 lignes issues de Q5 — métier, ce qu'il fait concrètement, ce qui l'a amené à OpenCode]

---

## Expertise
- **Confirmé :** [sujets maîtrisés — inférés depuis Q5]
- **En progression :** [sujets en apprentissage ou objectifs — inférés depuis Q5]

---

## Format de réponse
- [Court / Développé] par défaut — [issu de Q4]
- [Langue] exclusivement — [issu de Q1]
- Pas d'intro, pas de conclusion polie, pas d'emoji
- Code : complet et fonctionnel, jamais de placeholder

---

## Posture
- [Sparring partner / Exécutant] — [issu de Q3]
- [Si sparring partner : challenger si la demande est floue, bancale ou sous-optimale]
- [Si exécutant : exécuter sans commentaire sauf si risque évident]
- Apprendre des retours : si [Prénom] corrige ou rejette une approche, proposer une mise à jour de ce fichier et attendre confirmation avant d'écrire

---

## Décisions
- [Issu de Q6 : valider avant d'agir / peut agir directement sur tâches courtes]

---

<jamais>
[Construire cette liste à partir de Q2 et Q7 — items précis et actionnables]
- [Exemple : Reformuler la question avant de répondre]
- [Exemple : Produire "Je vais maintenant..." avant d'agir]
- [Exemple : Ajouter des mises en garde sauf risque réel]
</jamais>
```

Affiche le fichier généré et demande confirmation avant d'écrire.
Si le fichier `~/.config/opencode/AGENTS.md` existe déjà, le signaler et demander s'il faut écraser ou fusionner.

---

## Phase 2 — Installation Node.js et clasp

Invoquer le skill `gas-setup-node-clasp-off` :

```
use skill gas-setup-node-clasp-off
```

Ce skill installe nvm, Node.js LTS et les outils de développement nécessaires.
Attendre que le skill confirme que l'installation est complète avant de passer à la Phase 3.

---

## Phase 3 — Interview projet

Pose les 3 questions suivantes, une par une.

**Q1 — Projet existant ou nouveau ?**
"Tu travailles sur un projet existant ou tu pars de zéro ?"

**Q2 — Type de projet**
"Ton projet, c'est quoi ? Est-ce que tu travailles dans Google Workspace (Sheets, Docs, Forms...), ou c'est un autre type d'outil ?"

**Q3 — Nom et description**
"Quel est le nom du projet et en une phrase, qu'est-ce qu'il fait ?"

### Génération du AGENTS.md projet

Selon les réponses :

**Si projet GAS existant → invoquer le skill `gas-onboarding-existing`**
```
use skill gas-onboarding-existing
```

**Si projet GAS nouveau → invoquer le skill `gas-onboarding-new`**
```
use skill gas-onboarding-new
```

**Si autre stack (Node, Python, etc.) → générer un AGENTS.md minimal**

Créer `[dossier-projet]/AGENTS.md` avec ce template :

```markdown
# [Nom du projet] — AGENTS.md

## Description
[Description courte — issu de Q3]

## Stack
[Technologie principale]

## Fichiers clés
[À compléter]

## Conventions de code
[À compléter]

## Workflow de développement
[À compléter]
```

Afficher le fichier et demander confirmation avant d'écrire.
Demander où se trouve le dossier projet si ce n'est pas clair.

---

## Phase 4 — Installation des skills de sécurisation

### Pour les projets GAS uniquement

Expliquer avant d'agir :
> "Je vais maintenant connecter 3 outils de sécurité à ton projet. Ces outils permettent à l'agent de vérifier automatiquement que le code est correct avant de le pousser, et d'analyser l'impact d'une modification. C'est une étape silencieuse — je t'indique quand c'est fait."

Vérifier que les 3 skills source existent dans `~/.config/opencode/skills/` :
- `gas-reviewer/SKILL.md`
- `gas-impact-analyzer/SKILL.md`
- `gas-regression-checker/SKILL.md`

Si l'un est absent, le télécharger depuis le repo OnboardingSkills :
```bash
curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/gas-reviewer/SKILL.md -o ~/.config/opencode/skills/gas-reviewer/SKILL.md
```
(adapter l'URL pour chaque skill manquant)

Créer les symlinks dans le dossier projet :

```bash
mkdir -p [dossier-projet]/.opencode/skills
ln -sf ~/.config/opencode/skills/gas-reviewer [dossier-projet]/.opencode/skills/gas-reviewer
ln -sf ~/.config/opencode/skills/gas-impact-analyzer [dossier-projet]/.opencode/skills/gas-impact-analyzer
ln -sf ~/.config/opencode/skills/gas-regression-checker [dossier-projet]/.opencode/skills/gas-regression-checker
```

Confirmer une fois terminé :
> "Les 3 outils de sécurité sont connectés à ton projet."

---

## Bilan final

À la fin des 4 phases, afficher ce récapitulatif en langage simple — sans chemins de fichiers ni jargon technique :

```
Ton environnement est prêt.

✅ Ton profil de travail est configuré — l'agent connaît tes préférences sur tous tes projets
✅ Node.js et clasp sont installés — tu peux pousser ton code vers Apps Script depuis ton Mac
✅ Ton projet est configuré — l'agent connaît son architecture et ses règles
✅ Les outils de sécurité sont connectés — l'agent vérifie le code avant chaque modification importante

Pour pousser du code vers Apps Script à l'avenir, une seule commande depuis ton dossier projet :
  clasp push

Si tu as un doute, tu peux toujours me demander.
```
