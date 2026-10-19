#!/usr/bin/env bash
# install-village.sh — OnboardingSkills
# Installe UN seul skill : village-first-deploy, qui t'accompagne pour déployer ta première
# application sur le Village (plateforme interne Valiuz).
# Le skill tient en trois fichiers : SKILL.md (le parcours) et deux fichiers de référence
# dans references/ (ce que le Village permet ou non, détails fins).
# Rien n'est installé dans ton navigateur ou dans Google — uniquement des fichiers de
# configuration locaux pour l'agent OpenCode.
# Usage : curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install-village.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.config/opencode/skills}"
SKILL="village-first-deploy"
FILES=("SKILL.md" "references/village.md" "references/details.md")

echo ""
echo "=== Installation du skill Village ==="
echo ""

# Tout est téléchargé dans un dossier temporaire : un téléchargement raté ne doit jamais
# écraser, ni laisser à moitié, une version déjà installée.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p "$TMP_DIR/$SKILL/references"

for f in "${FILES[@]}"; do
  if ! curl -fsSL "$REPO_URL/$SKILL/$f" -o "$TMP_DIR/$SKILL/$f" 2>/dev/null; then
    echo "❌ Impossible de télécharger $f."
    echo "   Vérifie ta connexion internet, puis relance la commande."
    echo "   Rien n'a été installé."
    exit 1
  fi
  if [ ! -s "$TMP_DIR/$SKILL/$f" ]; then
    echo "❌ Le fichier $f téléchargé est vide. Rien n'a été installé."
    echo "   Préviens la personne qui t'a donné cette commande."
    exit 1
  fi
done

# Contrôle de base : SKILL.md doit ressembler à un skill (et pas à une page d'erreur).
if ! head -1 "$TMP_DIR/$SKILL/SKILL.md" | grep -q '^---$' || ! grep -q "^name: $SKILL$" "$TMP_DIR/$SKILL/SKILL.md"; then
  echo "❌ Le fichier SKILL.md téléchargé n'a pas le format attendu. Rien n'a été installé."
  echo "   Préviens la personne qui t'a donné cette commande."
  exit 1
fi

# Tout est bon : remplacer l'ancienne version d'un bloc.
mkdir -p "$SKILLS_DIR"
rm -rf "$SKILLS_DIR/$SKILL"
mkdir -p "$SKILLS_DIR/$SKILL/references"
for f in "${FILES[@]}"; do
  cp "$TMP_DIR/$SKILL/$f" "$SKILLS_DIR/$SKILL/$f"
  chmod 644 "$SKILLS_DIR/$SKILL/$f"
done

echo "✅ $SKILL installé dans $SKILLS_DIR/$SKILL (3 fichiers)"
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
