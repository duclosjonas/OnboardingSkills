#!/usr/bin/env bash
# install.sh — OnboardingSkills
# Ce script installe les instructions de travail (appelées "skills") utilisées par l'agent OpenCode.
# Il télécharge automatiquement les fichiers nécessaires et les place au bon endroit sur ton Mac.
# Rien n'est installé dans ton navigateur ou dans Google — uniquement des fichiers de configuration locaux.
# Usage : curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install.sh | bash

set -e

# --- Prérequis macOS : Xcode Command Line Tools ---
if ! xcode-select -p &>/dev/null; then
  echo ""
  echo "⚠️  Étape préalable requise avant de continuer."
  echo ""
  echo "Les outils de compilation macOS ne sont pas installés sur ce Mac."
  echo "Lance cette commande dans ton terminal :"
  echo ""
  echo "  xcode-select --install"
  echo ""
  echo "→ Une fenêtre macOS s'ouvre — clique sur 'Installer' (pas 'Obtenir Xcode')"
  echo "→ Attends la fin du téléchargement (entre 10 et 40 min selon ta connexion)"
  echo "→ Une fois terminé, relance ce script"
  echo ""
  exit 0
fi

REPO_URL="https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main"
SKILLS_DIR="$HOME/.config/opencode/skills"

SKILLS=(
  "collaborator-onboarding"
  "gas-reviewer"
  "gas-impact-analyzer"
  "gas-regression-checker"
  "gas-setup-node-clasp"
)

echo ""
echo "=== Installation des skills OpenCode ==="
echo ""

# Créer le dossier skills si absent
mkdir -p "$SKILLS_DIR"

# Télécharger chaque SKILL.md
for skill in "${SKILLS[@]}"; do
  mkdir -p "$SKILLS_DIR/$skill"
  url="$REPO_URL/$skill/SKILL.md"

  if curl -fsSL "$url" -o "$SKILLS_DIR/$skill/SKILL.md" 2>/dev/null; then
    echo "✅ $skill installé"
  else
    echo "❌ Erreur : impossible de télécharger $skill — vérifier la connexion ou l'URL"
  fi
done

echo ""
echo "=== Installation terminée ==="
echo ""
echo "Prochaine étape :"
echo "  1. Ouvre OpenCode dans ton dossier projet"
echo "  2. Tape : use skill collaborator-onboarding"
echo "  3. Suis les instructions — l'agent s'occupe du reste"
echo ""
