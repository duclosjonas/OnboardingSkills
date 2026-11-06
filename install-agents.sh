#!/usr/bin/env bash
# install-agents.sh — OnboardingSkills
# Installe les agents OpenCode du kit : compagnon-projet (agent principal) et ses
# deux exécutants (executant-simple, executant-code).
# Installation GLOBALE : dans ~/.config/opencode/agents/, donc disponibles sur tous tes projets.
# Rien n'est installé dans ton navigateur ni dans Google — uniquement des fichiers locaux.
# Usage : curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/install-agents.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main"
AGENTS_DIR="${AGENTS_DIR:-$HOME/.config/opencode/agents}"
AGENTS=("compagnon-projet" "executant-simple" "executant-code")

echo ""
echo "=== Installation des agents OpenCode ==="
echo ""

# Tout est téléchargé dans un dossier temporaire : un téléchargement raté ne doit jamais
# écraser, ni laisser à moitié, une version déjà installée.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

for a in "${AGENTS[@]}"; do
  if ! curl -fsSL "$REPO_URL/agents/$a.md" -o "$TMP_DIR/$a.md" 2>/dev/null; then
    echo "❌ Impossible de télécharger $a.md."
    echo "   Vérifie ta connexion internet, puis relance la commande."
    echo "   Rien n'a été installé."
    exit 1
  fi
  if [ ! -s "$TMP_DIR/$a.md" ]; then
    echo "❌ Le fichier $a.md téléchargé est vide. Rien n'a été installé."
    echo "   Préviens la personne qui t'a donné cette commande."
    exit 1
  fi
  # Contrôle de base : un agent doit commencer par un frontmatter et déclarer son nom de fichier.
  if ! head -1 "$TMP_DIR/$a.md" | grep -q '^---$' || ! grep -q '^permissions:' "$TMP_DIR/$a.md"; then
    echo "❌ Le fichier $a.md téléchargé n'a pas le format attendu. Rien n'a été installé."
    echo "   Préviens la personne qui t'a donné cette commande."
    exit 1
  fi
done

# Tout est bon : remplacer chaque agent d'un coup.
mkdir -p "$AGENTS_DIR"
for a in "${AGENTS[@]}"; do
  cp "$TMP_DIR/$a.md" "$AGENTS_DIR/$a.md.new"
  mv "$AGENTS_DIR/$a.md.new" "$AGENTS_DIR/$a.md"
  chmod 644 "$AGENTS_DIR/$a.md"
  echo "✅ $a installé"
done

echo ""
echo "=== Installation terminée ==="
echo ""
echo "Prochaine étape :"
echo "  1. Ferme et rouvre OpenCode (ou tape /reload)"
echo "  2. Choisis l'agent « compagnon-projet » (touche Tab)"
echo "  3. Dis-lui ce sur quoi tu travailles"
echo ""
