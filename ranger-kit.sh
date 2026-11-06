#!/usr/bin/env bash
# ranger-kit.sh — range le kit OnboardingSkills aux bons endroits de OpenCode.
# À lancer depuis le dossier du kit (celui qui contient ce fichier).
# Agents   -> ~/.config/opencode/agents/
# Skills   -> ~/.config/opencode/skills/   (liste explicite ci-dessous, rien de plus)
# Rien n'est supprimé. Un fichier existant est remplacé seulement s'il vient du kit.
# AGENTS_DIR et SKILLS_DIR peuvent être surchargés (tests).

set -e

KIT="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="${AGENTS_DIR:-$HOME/.config/opencode/agents}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.config/opencode/skills}"
AGENTS=("compagnon-projet" "executant-simple" "executant-code")

echo ""
echo "=== Rangement du kit OnboardingSkills ==="
echo "Source : $KIT"
echo ""

# 1. Contrôle de la source avant toute écriture
for a in "${AGENTS[@]}"; do
  f="$KIT/agents/$a.md"
  if [ ! -s "$f" ] || ! head -1 "$f" | grep -q '^---$' || ! grep -q '^permissions:' "$f"; then
    echo "❌ $a.md absent ou incomplet dans le kit. Rien n'a été rangé."
    exit 1
  fi
done

SKILL_DIRS=("collaborator-onboarding" "first-session-starter" "gas-onboarding-existing" "gas-onboarding-new" "gas-reviewer" "gas-impact-analyzer" "gas-regression-checker" "village-first-deploy")
for s in "${SKILL_DIRS[@]}"; do
  if [ ! -s "$KIT/$s/SKILL.md" ]; then
    echo "❌ Le skill $s est absent du kit. Rien n'a été rangé."
    exit 1
  fi
done

# 2. Rangement des agents
mkdir -p "$AGENTS_DIR"
for a in "${AGENTS[@]}"; do
  cp "$KIT/agents/$a.md" "$AGENTS_DIR/$a.md.tmp"
  mv "$AGENTS_DIR/$a.md.tmp" "$AGENTS_DIR/$a.md"
  cmp -s "$KIT/agents/$a.md" "$AGENTS_DIR/$a.md" || { echo "❌ Contrôle échoué pour $a.md"; exit 1; }
  echo "✅ agent $a rangé"
done

# 3. Rangement des skills (dossier complet, y compris references/)
mkdir -p "$SKILLS_DIR"
for s in "${SKILL_DIRS[@]}"; do
  rm -rf "$SKILLS_DIR/$s.tmp"
  cp -R "$KIT/$s" "$SKILLS_DIR/$s.tmp"
  rm -rf "$SKILLS_DIR/$s"
  mv "$SKILLS_DIR/$s.tmp" "$SKILLS_DIR/$s"
  cmp -s "$KIT/$s/SKILL.md" "$SKILLS_DIR/$s/SKILL.md" || { echo "❌ Contrôle échoué pour $s"; exit 1; }
  echo "✅ skill $s rangé"
done

echo ""
echo "=== Rangement terminé : ${#AGENTS[@]} agents, ${#SKILL_DIRS[@]} skills ==="
echo "Prochaine étape : ferme et rouvre OpenCode, puis choisis « compagnon-projet » (touche Tab)."
echo ""
