#!/usr/bin/env bash
# install.sh — OnboardingSkills
# Installe les skills OpenCode depuis le repo duclosjonas/OnboardingSkills
# Usage : curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install.sh | bash

set -e

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
