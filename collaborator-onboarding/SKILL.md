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

Pose les 6 questions suivantes, une par une. Attends la réponse avant de passer à la suivante. Ne groupe jamais plusieurs questions dans un même message.

**Q1 — Langue**
"Dans quelle langue tu travailles principalement avec un agent IA ? (français, anglais, autre)"

**Q2 — Ce qui irrite**
"Qu'est-ce qui te dérange le plus dans une réponse d'agent IA ? (trop long, trop servile, trop technique, ne challenge pas, autre)"

**Q3 — Posture**
"Tu préfères un agent qui exécute ce que tu demandes sans discuter, ou qui te challenge si ta demande lui semble bancale ou incomplète ?"

**Q4 — Longueur des réponses**
"Par défaut, tu veux des réponses courtes et directes, ou tu préfères qu'il développe et explique ?"

**Q5 — Expertise**
"Sur quels sujets tu veux que l'agent t'explique les bases ? Et sur lesquels il peut assumer que tu es à l'aise ?"

**Q6 — Validation avant action**
"Sur une tâche courte et claire, l'agent peut agir directement ou tu veux toujours valider avant qu'il modifie quoi que ce soit ?"

**Q7 — Optionnelle**
Si le collaborateur est à l'aise et engagé dans l'échange :
"Y a-t-il des sujets ou des façons de faire que tu veux que l'agent évite systématiquement ?"

### Génération du profil

À partir des réponses, génère le fichier `~/.config/opencode/AGENTS.md` en suivant ce template. Adapte chaque section aux réponses réelles — ne copie pas le template mot pour mot.

```markdown
# Profil — [Prénom Nom]

> Fichier de gouvernance transverse — chargé sur tous les projets OpenCode.
> Mis à jour par l'agent si [Prénom] corrige ou rejette explicitement une approche, après confirmation.

---

## Contexte
[2-3 lignes issues des réponses Q5 — rôle, domaine, ce qu'il fait concrètement]

---

## Expertise
- **Confirmé :** [sujets maîtrisés — Q5]
- **En progression :** [sujets en apprentissage — Q5]

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

Invoquer le skill `gas-setup-node-clasp` :

```
use skill gas-setup-node-clasp
```

Ce skill installe nvm, Node.js LTS, clasp en global, et guide le login OAuth Google.
Attendre que le skill confirme que l'installation est complète avant de passer à la Phase 3.

---

## Phase 3 — Interview projet

Pose les 3 questions suivantes, une par une.

**Q1 — Projet existant ou nouveau ?**
"Tu travailles sur un projet existant ou tu pars de zéro ?"

**Q2 — Stack technique**
"C'est un projet Google Apps Script (GAS), ou une autre technologie ? (Node.js, Python, autre)"

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

Créer les symlinks dans le dossier projet :

```bash
mkdir -p [dossier-projet]/.opencode/skills
ln -sf ~/.config/opencode/skills/gas-reviewer [dossier-projet]/.opencode/skills/gas-reviewer
ln -sf ~/.config/opencode/skills/gas-impact-analyzer [dossier-projet]/.opencode/skills/gas-impact-analyzer
ln -sf ~/.config/opencode/skills/gas-regression-checker [dossier-projet]/.opencode/skills/gas-regression-checker
```

Vérifier que les skills source existent dans `~/.config/opencode/skills/` avant de créer les symlinks. Si absents, les copier depuis le repo OnboardingSkills.

### Pour tous les projets

Vérifier que les 3 skills sont bien présents dans `~/.config/opencode/skills/` :
- `gas-reviewer/SKILL.md`
- `gas-impact-analyzer/SKILL.md`
- `gas-regression-checker/SKILL.md`

Si l'un est absent, le copier depuis le dossier local du repo OnboardingSkills.

---

## Bilan final

À la fin des 4 phases, afficher ce récapitulatif :

```
✅ Profil de travail créé : ~/.config/opencode/AGENTS.md
✅ Node.js et clasp installés
✅ Projet configuré : [chemin]/AGENTS.md
✅ Skills installés : gas-reviewer, gas-impact-analyzer, gas-regression-checker

Prochaine étape si projet GAS :
→ Lier clasp à ton projet Apps Script :
  1. Ouvre script.google.com → ton projet → Paramètres du projet
  2. Copie l'ID du script
  3. Dans le terminal, depuis ton dossier projet : clasp clone <ID_SCRIPT>
  Ou si le projet existe déjà localement : ajouter l'ID dans .clasp.json
```
