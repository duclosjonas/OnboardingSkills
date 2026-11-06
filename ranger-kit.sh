#!/usr/bin/env bash
# ranger-kit.sh — range le kit OnboardingSkills aux bons endroits de OpenCode.
# À lancer depuis le dossier du kit (celui qui contient ce fichier).
# Agents   -> ~/.config/opencode/agents/
# Skills   -> ~/.config/opencode/skills/   (liste explicite ci-dessous, rien de plus)
# Rien n'est supprimé. Un fichier existant est remplacé seulement s'il vient du kit.
# Il fait aussi de compagnon-projet l'agent par défaut : il est là à chaque nouvelle session,
# sans rien choisir. Ancienne config sauvegardée en opencode.json.avant-compagnon.
# AGENTS_DIR, SKILLS_DIR et CONFIG_FILE peuvent être surchargés (tests).

set -e

KIT="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="${AGENTS_DIR:-$HOME/.config/opencode/agents}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.config/opencode/skills}"
CONFIG_FILE="${CONFIG_FILE:-$HOME/.config/opencode/opencode.json}"
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

# 4. Agent par défaut : compagnon-projet (la config existante est sauvegardée, rien d'autre n'est changé)
mkdir -p "$(dirname "$CONFIG_FILE")"
[ -f "$CONFIG_FILE" ] && [ ! -f "$CONFIG_FILE.avant-compagnon" ] && cp "$CONFIG_FILE" "$CONFIG_FILE.avant-compagnon"
export CONFIG_FILE
if command -v node >/dev/null 2>&1; then
  RESULT="$(node -e "
const fs=require('fs');const p=process.env.CONFIG_FILE;
let c={};
if(fs.existsSync(p)){c=JSON.parse(fs.readFileSync(p,'utf8'));}
c.default_agent='compagnon-projet';
fs.writeFileSync(p,JSON.stringify(c,null,2)+'\\n');
console.log('ok');" 2>&1)" || RESULT="erreur"
elif command -v python3 >/dev/null 2>&1; then
  RESULT="$(python3 -c "
import json,os
p=os.environ['CONFIG_FILE']
c=json.load(open(p,encoding='utf-8')) if os.path.exists(p) else {}
c['default_agent']='compagnon-projet'
open(p,'w',encoding='utf-8').write(json.dumps(c,indent=2,ensure_ascii=False)+'\\n')
print('ok')" 2>&1)" || RESULT="erreur"
else
  RESULT="erreur"
fi
if [ "$RESULT" = "ok" ]; then
  echo "✅ compagnon-projet est maintenant l'agent par défaut"
else
  echo "⚠️  Agent par défaut non modifié (ton fichier opencode.json n'a pas pu être lu)."
  echo "   Les agents et skills sont bien rangés. Dis-le à la personne qui t'a donné le kit."
fi

echo ""
echo "=== Rangement terminé : ${#AGENTS[@]} agents, ${#SKILL_DIRS[@]} skills ==="
echo "Prochaine étape : ferme et rouvre OpenCode. compagnon-projet sera là dès la prochaine session."
echo ""
