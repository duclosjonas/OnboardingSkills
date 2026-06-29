#!/usr/bin/env bash
# setup.sh — Installation Node.js + clasp pour Google Apps Script
# Usage : curl -fsSL https://raw.githubusercontent.com/duclosjonas/OnboardingSkills/main/setup.sh | bash

set -e

echo ""
echo "=== Setup Node.js + clasp ==="
echo ""

# --- Étape 0 — Xcode Command Line Tools ---
if ! xcode-select -p &>/dev/null; then
  echo "⚠️  Xcode Command Line Tools manquant."
  echo ""
  echo "Lance cette commande dans ton terminal :"
  echo "  xcode-select --install"
  echo ""
  echo "→ Une fenêtre macOS s'ouvre — clique sur 'Installer' (pas 'Obtenir Xcode')"
  echo "→ Attends la fin du téléchargement (entre 10 et 40 min selon ta connexion)"
  echo "→ Une fois terminé, relance ce script"
  echo ""
  exit 0
fi
echo "✅ Xcode Command Line Tools détecté"

# --- Étape 1 — nvm ---
if ! command -v nvm &>/dev/null && [ ! -d "$HOME/.nvm" ]; then
  echo ""
  echo "→ Installation de nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  echo ""
fi

# Charger nvm dans la session courante
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if ! command -v nvm &>/dev/null; then
  echo "❌ nvm introuvable après installation."
  echo "   Ferme et rouvre ton terminal, puis relance ce script."
  exit 1
fi
echo "✅ nvm $(nvm --version)"

# --- Étape 2 — Node.js LTS ---
if ! command -v node &>/dev/null; then
  echo ""
  echo "→ Installation de Node.js LTS..."
  nvm install --lts
  nvm use --lts
  echo ""
fi

NODE_VERSION=$(node -v 2>/dev/null)
NPM_VERSION=$(npm -v 2>/dev/null)

if [ -z "$NODE_VERSION" ]; then
  echo "❌ Node.js introuvable après installation. Relance ce script."
  exit 1
fi
echo "✅ Node.js $NODE_VERSION"
echo "✅ npm $NPM_VERSION"

# --- Étape 3 — clasp ---
if ! command -v clasp &>/dev/null; then
  echo ""
  echo "→ Installation de clasp..."
  npm install -g @google/clasp
  echo ""
fi

CLASP_VERSION=$(clasp -v 2>/dev/null)
if [ -z "$CLASP_VERSION" ]; then
  echo "❌ clasp introuvable après installation."
  echo "   Essaie : nvm use --lts && npm install -g @google/clasp"
  exit 1
fi
echo "✅ clasp $CLASP_VERSION"

# --- Étape 4 — Persistance nvm dans .zshrc ---
ZSHRC="$HOME/.zshrc"
if ! grep -q 'NVM_DIR' "$ZSHRC" 2>/dev/null; then
  echo "" >> "$ZSHRC"
  echo '# nvm' >> "$ZSHRC"
  echo 'export NVM_DIR="$HOME/.nvm"' >> "$ZSHRC"
  echo '[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"' >> "$ZSHRC"
  echo "✅ nvm ajouté à ~/.zshrc"
fi

# --- Résultat final ---
echo ""
echo "=== Environnement prêt ==="
echo ""
echo "  Node.js $NODE_VERSION"
echo "  npm     $NPM_VERSION"
echo "  clasp   $CLASP_VERSION"
echo ""
echo "Prochaine étape — connecter clasp à ton compte Google :"
echo "  clasp login"
echo ""
echo "Une page s'ouvrira dans ton navigateur. Connecte-toi avec ton compte"
echo "Google et accorde les permissions demandées."
echo ""
echo "Ensuite, reviens dans OpenCode et continue l'onboarding."
echo ""
