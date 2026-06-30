---
name: first-session-starter
description: Use at the very start of a work session. If first_session: true is found in ~/.config/opencode/AGENTS.md, delivers a short onboarding briefing on sessions, prompts and models, then removes the flag before proceeding with the user's request. If the flag is absent, does nothing.
---

# Skill — First Session Starter

## Déclencheur

Ce skill est invoqué automatiquement au début de chaque session. Il vérifie si c'est la première session du collaborateur.

---

## Étape 1 — Vérifier le flag

Lire `~/.config/opencode/AGENTS.md` et chercher la ligne `first_session: true`.

**Si la ligne est absente → ne rien faire. Répondre normalement à la demande de l'utilisateur.**

**Si la ligne est présente → continuer.**

---

## Étape 2 — Briefing première session

Afficher ce message avant de répondre à la demande de l'utilisateur :

```
Bienvenue dans ta première session OpenCode. Trois règles du jeu avant de commencer — ça prend 30 secondes.

SESSION — Une conversation = un sujet. Si tu changes de sujet, ouvre une nouvelle conversation. Sinon je perds le fil et mes réponses deviennent moins précises.

PROMPT — Plus ta demande est précise, meilleure est ma réponse.
  Trop vague : "Aide-moi avec mon projet"
  Bien : "Rédige un mail de relance pour un fournisseur qui n'a pas répondu depuis 2 semaines. Ton direct, 5 lignes max."

MODÈLE — Choisis selon la complexité de ta tâche :
  Haiku 4.5      → question rapide, résumé simple                          $
  Sonnet 4.6     → usage quotidien — rédiger, analyser, préparer           $$   ← par défaut
  Opus 4.7       → raisonnement complexe, document long, sujet difficile   $$$$
  Gemini Pro 3.1 → tout ce qui touche à Google Workspace                   $$

Règle simple : commence toujours par Sonnet. Passe à Opus uniquement si Sonnet ne s'en sort pas.

---
```

---

## Étape 3 — Supprimer le flag

Retirer la ligne `first_session: true` de `~/.config/opencode/AGENTS.md` :

```bash
sed -i '' '/^first_session: true$/d' ~/.config/opencode/AGENTS.md
```

---

## Étape 4 — Répondre à la demande

Traiter normalement la demande initiale de l'utilisateur.
