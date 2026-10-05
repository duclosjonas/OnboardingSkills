#!/usr/bin/env bash
# install-village.sh — OnboardingSkills
# Installe UN seul skill : village-first-deploy, qui t'accompagne pour déployer ta première
# application sur le Village (plateforme interne Valiuz).
# Rien n'est installé dans ton navigateur ou dans Google — uniquement un fichier de
# configuration local pour l'agent OpenCode.
# Usage : curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install-village.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.config/opencode/skills}"
SKILL="village-first-deploy"

echo ""
echo "=== Installation du skill Village ==="
echo ""

mkdir -p "$SKILLS_DIR/$SKILL"

# Télécharger dans un fichier temporaire : un téléchargement raté ne doit jamais écraser
# une version déjà installée.
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

if ! curl -fsSL "$REPO_URL/$SKILL/SKILL.md" -o "$TMP_FILE" 2>/dev/null; then
  echo "❌ Impossible de télécharger le skill."
  echo "   Vérifie ta connexion internet, puis relance la commande."
  exit 1
fi

# Contrôle de base : le fichier doit ressembler à un skill (et pas à une page d'erreur).
if ! head -1 "$TMP_FILE" | grep -q '^---$' || ! grep -q "^name: $SKILL$" "$TMP_FILE"; then
  echo "❌ Le fichier téléchargé n'a pas le format attendu. Rien n'a été installé."
  echo "   Préviens la personne qui t'a donné cette commande."
  exit 1
fi

chmod 644 "$TMP_FILE"
mv "$TMP_FILE" "$SKILLS_DIR/$SKILL/SKILL.md"
trap - EXIT

echo "✅ $SKILL installé dans $SKILLS_DIR/$SKILL"
echo ""
echo "Avant de commencer :"
echo "  • Connecte le VPN d'entreprise (Zscaler) : sans lui, rien ne fonctionne."
echo "  • Aie ton compte Google Valiuz sous la main."
echo ""
echo "Prochaine étape :"
echo "  1. Ouvre OpenCode dans un dossier de ton choix"
echo "  2. Tape : utilise le skill village-first-deploy"
echo "  3. Suis les instructions — l'agent s'occupe du reste"
echo ""
