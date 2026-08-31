---
name: gas-project-handoff
description: Use when handing off an operational Google Apps Script project to another person, typically less technical, who will use it day-to-day without ever touching the code. Covers the technical switchover checklist (sharing, triggers, config constants, ownership transfer), generates a project-specific USER_GUIDE.md for future AI sessions to speak the recipient's language, and sets up the recipient's environment (clasp or copy-paste mode). Trigger on phrases like "passation", "transfer this project", "hand off to", "give this to [person]", or when a GAS project needs to move from the developer's Drive/account to an end user's.
---

# GAS Project Handoff

Tu accompagnes le transfert d'un projet Google Apps Script **opérationnel** (déjà en usage réel, pas en cours de dev) vers une personne qui va l'utiliser au quotidien — le plus souvent un profil métier non-tech qui ne lira jamais le code.

Différence fondamentale avec `gas-onboarding-*` et `collaborator-onboarding` : ces skills préparent quelqu'un à **coder** sur un projet GAS. Ici, le repreneur n'écrira jamais de `.gs` — il pilotera l'outil via un menu, des emails, et éventuellement des demandes en langage naturel à OpenCode. Ne pas lui imposer TODO.md, AGENTS.md, ou le SESSION PROTOCOL — ce sont des fichiers de gouvernance dev, pas des documents utilisateur final.

---

## RÈGLES ABSOLUES

- Poser les questions de cadrage UNE PAR UNE, attendre la réponse avant la suivante
- Ne jamais faire lire au repreneur un fichier de gouvernance dev (TODO.md, AGENTS.md, CHANGELOG.md) — ces fichiers restent internes au cédant
- Chaque changement de code de la Phase 1 suit le protocole habituel du projet (review → push → tests) s'il existe un AGENTS.md avec SESSION PROTOCOL
- Ne jamais transférer la propriété Drive avant que la Phase 1 (bascule technique) soit intégralement terminée et testée
- Le `USER_GUIDE.md` généré en Phase 2 est écrit pour deux lecteurs à la fois : la personne humaine (langage simple, zéro jargon) ET une future IA qui le lira pour calibrer son ton — pas de compromis qui sacrifierait l'un pour l'autre

---

## PHASE 0 — CADRAGE

Poser ces questions une par une avant de commencer quoi que ce soit.

### Q1 — Qui reprend et sur quel domaine
> "Qui reprend ce projet, et est-ce que cette personne est sur le même domaine Google Workspace que toi ?"

- **Même domaine** → transfert de propriété Drive natif possible (le plus simple)
- **Domaine différent** → il faudra une méthode alternative (partage + export/duplication) — à creuser au moment de la Phase 1 étape "transfert de propriété" si ce cas se présente

### Q2 — Portée de la passation
> "C'est une passation totale — tu te retires du pilotage opérationnel — ou tu restes en copilotage un moment (ex: valider les premiers résultats avec elle) ?"

Impacte le ton du `USER_GUIDE.md` (Phase 2) : en copilotage, le guide peut mentionner explicitement "en cas de doute, contacte [cédant]" comme filet actif ; en passation totale, le filet de sécurité doit être plus autonome (voir Phase 4).

### Q3 — Niveau d'autonomie visé avec OpenCode
> "Est-ce que cette personne va utiliser OpenCode elle-même pour demander des évolutions du projet plus tard, ou elle reste uniquement sur l'usage quotidien (menu, boutons, emails) sans jamais toucher à un outil de dev ?"

- **Usage quotidien uniquement** → Phase 2 suffit, pas besoin d'environnement de dev
- **Utilisera OpenCode pour des évolutions futures** → passer par Phase 3 (mise en place de l'environnement)

### Q4 — Disponibilité de clasp côté repreneur
Uniquement si Q3 = "utilisera OpenCode" :
> "Est-ce que clasp (l'outil qui pousse le code vers Apps Script) est disponible pour cette personne, ou pas encore ?"

- **Disponible** → Phase 3 utilise le chemin clasp classique (renvoyer vers `gas-setup-node-clasp` ou équivalent selon contexte) ; le repreneur pourra faire `clasp clone` lui-même une fois le script Apps Script transféré, pas besoin de lui envoyer les fichiers locaux à la main
- **Pas encore disponible** → Phase 3 utilise `gas-setup-node-clasp-off` (mode copie-colle) **et** il faut transmettre manuellement une copie du dossier projet local (voir Phase 3.2), car sans clasp le repreneur n'a aucun moyen de récupérer les fichiers `.gs` locaux depuis Apps Script

### Q5 — OpenCode déjà installé chez le repreneur ?
Uniquement si Q3 = "utilisera OpenCode" :
> "Est-ce que [repreneur] a déjà OpenCode installé, et si oui, a-t-il déjà des skills globaux configurés (~/.config/opencode/skills/) ou c'est une installation vierge ?"

- **Pas installé du tout** → Phase 3.1 couvre l'installation complète via `collaborator-onboarding`
- **Installé mais sans skill** → cas fréquent, à ne pas confondre avec "rien à faire" : Phase 3.1 doit quand même vérifier/transmettre les skills utiles à l'usage prévu du repreneur sur CE projet (pas une réinstallation complète, juste les skills pertinents)
- **Déjà installé avec skills** → rien à faire en 3.1, passer directement à 3.2

### Synthèse Phase 0

```
## Cadrage de la passation

**Repreneur :** [nom] — [même domaine / domaine différent]
**Portée :** [totale / copilotage temporaire]
**Autonomie OpenCode :** [usage quotidien uniquement / utilisera OpenCode pour des évolutions]
**Clasp :** [disponible / pas encore disponible / non applicable]
**OpenCode installé :** [oui / non / non applicable]

C'est bon ? Je passe à la checklist technique de bascule.
```

Attendre confirmation avant la Phase 1.

---

## PHASE 1 — CHECKLIST TECHNIQUE DE BASCULE

Cette phase modifie du code et de la configuration. Si le projet a un `AGENTS.md` avec SESSION PROTOCOL, suivre ce protocole (review → push → tests) pour chaque changement de code. Traiter chaque point séquentiellement, pas en vrac.

### 1.1 — Partage domaine sur les fichiers générés

Si le projet dispose d'un dossier Drive dédié et que des fichiers y sont générés automatiquement (rapports, exports), vérifier si un partage large (ex: "toute personne du domaine peut consulter/commenter") est souhaité.

Si oui, implémenter `folder.setSharing(DriveApp.Access.DOMAIN_WITH_LINK, DriveApp.Permission.COMMENT)` (ajuster `Access`/`Permission` selon le besoin exprimé) :
- Sur le dossier lui-même, à sa création
- Sur le fichier de base de travail (Sheet), lors de son premier rangement dans le dossier
- Sur chaque nouveau fichier généré (rapport, export...), car l'appartenance à un dossier partagé n'étend pas automatiquement l'ACL réelle de chaque fichier enfant dans Drive — c'est un piège classique à vérifier explicitement, pas à supposer

### 1.2 — Nettoyage des triggers du cédant

`ScriptApp.getProjectTriggers()` ne renvoie que les triggers créés par l'utilisateur qui exécute le code — les triggers de test du cédant resteront invisibles pour le repreneur et continueront de tourner sous son identité après transfert, sauf suppression explicite.

Avant le transfert de propriété (1.4) :
> "As-tu des triggers de test actifs sur ce projet ? Si oui, va dans Extensions > Apps Script > Déclencheurs et supprime-les maintenant — sinon ils tourneront en double une fois le repreneur aux commandes."

Ne pas coder une fonction de désinstallation automatique sauf si le projet en a déjà une symétrique à l'installation — sinon, étape manuelle suffisante (30 secondes, pas de code à maintenir pour un usage ponctuel).

### 1.3 — Bascule des constantes de configuration

Chercher dans le code toute constante identifiant le cédant personnellement : adresse email de notification, destinataire de rapport, propriétaire hardcodé. Lister-les toutes avant de rien changer :

> "Voici les constantes qui pointent actuellement vers toi : [liste]. Je les bascule vers [repreneur] maintenant ?"

Appliquer le changement en dernier, juste avant le transfert effectif — pas avant, pour continuer à recevoir les notifications de test jusqu'au bout.

### 1.4 — Transfert de propriété Drive

Une fois 1.1 à 1.3 validés et testés :
> "On peut transférer la propriété maintenant. Dans Google Drive : clic droit sur le dossier/fichier → Partager → change le propriétaire vers [email du repreneur]. Confirme quand c'est fait."

Si domaines différents (Q1 = différent) : le transfert de propriété natif n'est généralement pas possible — proposer une alternative (partage en édition + le repreneur fait "Créer une copie", ou export/import) et documenter clairement dans `USER_GUIDE.md` que le Script ID change dans ce cas (donc Script Properties et triggers ne suivent PAS automatiquement).

---

## PHASE 2 — GÉNÉRATION DE USER_GUIDE.md

Génère `USER_GUIDE.md` à la racine du projet (à côté de `AGENTS.md`, `TODO.md`). Ce fichier a deux lecteurs simultanés : le repreneur humain, et une future IA qui le chargera pour calibrer son ton et sa pédagogie face à cette personne précise. Écrire dans un langage métier, zéro jargon technique — pas de "clasp", "trigger", "commit" sans les expliquer si le terme doit apparaître.

Avant de générer, si le contexte ne fournit pas déjà ces informations, poser :
> "Pour bien écrire ce guide, aide-moi à comprendre le quotidien de [repreneur] avec cet outil : que fait-elle concrètement, à quelle fréquence, et qu'est-ce qui la rassurerait de savoir si quelque chose semble ne pas marcher ?"

### Template

```markdown
# [Nom du projet] — Guide d'utilisation pour [Prénom du repreneur]

> Ce fichier n'est pas un document technique. Il sert à toute IA (OpenCode ou
> autre) qui accompagnera [Prénom] sur ce projet à l'avenir : comment lui
> parler, ce qu'elle sait déjà faire, ce qui doit rester simple pour elle.
> [Prénom] peut aussi le lire directement — il est écrit pour elle.

---

## Ce que fait cet outil, en une phrase

[Description ultra-simple, sans jargon — ex: "Ce Google Sheet récupère
automatiquement les amendes RGPD publiées en ligne et prépare un rapport
trimestriel à faire relire."]

## Ce que [Prénom] peut faire elle-même

[Pour chaque action possible via le menu/l'interface, en langage métier :
nom du bouton exact, ce qui se passe quand elle clique, combien de temps ça
prend, ce qu'elle doit voir à la fin]

- **[Nom du menu exact]** → [ce que ça fait en une phrase]
- ...

## Ce qui se passe tout seul, sans qu'elle ait rien à faire

[Liste des automatisations : fréquence en langage humain ("le 1er de chaque
mois"), ce que ça déclenche, comment elle le sait (email, ligne ajoutée...)]

## Signaux que tout va bien

[Ex: "Tu dois recevoir un email au début de chaque mois. Le rapport
trimestriel apparaît dans le dossier [nom] environ une semaine après la fin
de chaque trimestre."]

## Signaux qu'il faut s'inquiéter (et quoi faire)

[Pour chaque signal d'alerte plausible : ce qu'elle observe, ce que ça
signifie probablement, l'action concrète à faire — dont "contacter [cédant]"
si aucune action côté outil ne suffit]

## Si elle veut demander une évolution à l'IA

[Uniquement si Q3 Phase 0 = "utilisera OpenCode" — sinon omettre cette
section entièrement]

[Prénom] peut ouvrir OpenCode sur ce dossier et décrire ce qu'elle veut
changer en langage naturel (ex: "je voudrais que le rapport indique aussi
[X]"). Elle n'a jamais besoin de comprendre le code : l'IA lui présentera un
plan avant d'agir, elle valide ou ajuste, et l'IA s'occupe du reste.

[Si clasp indisponible (Q4) :] Note : au moment de la passation, l'outil qui
permet de publier automatiquement le code (clasp) n'était pas encore
disponible pour [Prénom] — chaque modification doit donc être copiée
manuellement dans l'éditeur Google Apps Script en ligne.

**Si [Prénom] veut publier une modification** : il lui suffit de dire à
l'IA *"installe le skill clasp-off"* (ou une formulation proche). L'IA ira
chercher toute seule les instructions dans le dossier `.setup/[nom du
skill]/` du projet et la guidera pas à pas — elle n'a jamais besoin de
chercher un dossier ou un fichier elle-même, encore moins un dossier caché
de configuration.

Ce point (copier-coller manuel) est amené à changer une fois clasp débloqué
pour elle — à ce moment-là, la publication deviendra automatique.

## Vocabulaire du projet

[Glossaire des 3-8 termes propres au métier/projet qui reviendront dans les
conversations futures — ex: "ETid = identifiant unique d'un dossier sur le
site source", "trimestre Q1/Q2/Q3/Q4". Si Phase 3 exécutée, inclure aussi :
"Skill — un mode d'emploi que l'IA peut suivre pour une tâche précise. [Prénom]
n'a jamais besoin d'ouvrir ces fichiers elle-même, seulement de dire à l'IA
quand elle en a besoin."]

## En cas de vrai souci

Contact : [cédant, coordonnées si pertinent]
[Si copilotage temporaire (Q2) :] [Cédant] reste disponible pour t'accompagner
sur les premiers usages.
[Si passation totale (Q2) :] Ce projet est désormais autonome — [cédant] n'est
plus dans la boucle au quotidien, mais reste joignable en dernier recours.
```

Créer ou mettre à jour `opencode.json` à la racine du projet pour que `USER_GUIDE.md` soit chargé automatiquement dès l'ouverture d'OpenCode par le repreneur, sans qu'il ait besoin de commencer sa conversation par un message particulier :

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["AGENTS.md", "USER_GUIDE.md"]
}
```

Si un `opencode.json` existe déjà avec d'autres champs, fusionner sans écraser le reste — ajouter ou compléter uniquement la clé `instructions`.

Afficher le fichier généré, demander confirmation avant d'écrire.

---

## PHASE 3 — ENVIRONNEMENT DU REPRENEUR (si applicable)

Ne s'applique que si Q3 (Phase 0) = "utilisera OpenCode pour des évolutions futures". Sans cette phase, un `USER_GUIDE.md` qui explique "demande à OpenCode..." est une coquille vide si le repreneur n'a ni OpenCode installé, ni les fichiers du projet sous la main, ni un moyen d'installer un skill sans manipuler un dossier caché — ces trois trous doivent être comblés explicitement, pas supposés réglés.

**Principe directeur pour toute cette phase : le repreneur ne doit JAMAIS avoir à naviguer lui-même vers un dossier caché de configuration (`~/.config/opencode/...`).** S'il a besoin d'un skill, ce skill doit être embarqué dans le dossier du projet qui lui est transmis, à un emplacement visible (ex: `.setup/[nom-du-skill]/`), avec une instruction dans `USER_GUIDE.md` du type *"dis à l'IA d'installer le skill X"* — c'est l'IA qui fait le déplacement de fichier, jamais le repreneur à la main.

### 3.1 — Installation d'OpenCode (si Q5 = absent)

Si OpenCode n'est pas installé du tout chez le repreneur :
> "Avant de préparer le reste, on installe OpenCode sur ta machine."

Invoquer `collaborator-onboarding`. Ce skill couvre déjà une interview de profil de travail — laisser ce skill dérouler sa propre logique plutôt que de la dupliquer ici. Une fois revenu dans `gas-project-handoff`, poursuivre en 3.2.

Si OpenCode est déjà installé (avec ou sans skills) → passer directement à 3.2.

### 3.2 — Mise à disposition des fichiers du projet

C'est le point le plus souvent oublié : OpenCode installé et un `USER_GUIDE.md` bien écrit ne servent à rien si le repreneur n'a pas les fichiers du projet (`.gs`, `AGENTS.md`, `TODO.md`, `USER_GUIDE.md`, `opencode.json`) quelque part sur sa machine, dans un dossier sur lequel il pourra ouvrir OpenCode.

- **Si clasp disponible (Q4)** → orienter vers le skill d'installation clasp standard du contexte (`gas-setup-node-clasp` ou équivalent). Une fois le script Apps Script transféré/partagé côté repreneur, il peut faire `clasp clone [scriptId]` lui-même pour récupérer tous les fichiers — aucun transfert manuel nécessaire, passer directement à 3.3.
- **Si clasp indisponible (Q4)** → un transfert manuel du dossier projet local est nécessaire (voir 3.3), car sans clasp le repreneur n'a aucun moyen de récupérer les fichiers `.gs` locaux depuis Apps Script.
  - Noter explicitement dans `USER_GUIDE.md` (section "Si elle veut demander une évolution à l'IA") que ce transfert manuel est une solution temporaire : une fois clasp débloqué pour le repreneur, `clasp clone` remplace ce mécanisme et le dossier transmis à la main devient obsolète (il faudra alors repartir du script Apps Script comme source de vérité).

### 3.3 — Package de transfert (si clasp indisponible, Q4)

Constituer un seul package (zip) à transmettre au repreneur, **déposé dans le dossier du projet lui-même** (facilement trouvable par le cédant, pas dans un dossier temporaire) :

1. Copier tout le contenu du dossier projet (fichiers `.gs`, `AGENTS.md`, `TODO.md`, `TESTS.md`, `CHANGELOG.md`, `USER_GUIDE.md`, `opencode.json`, `.clasp.json` si présent)
2. **Embarquer les skills utiles dans un sous-dossier `.setup/` du projet** — ne jamais transmettre de skill dans un dossier séparé du zip. Identifier précisément ce qui sert à l'usage prévu du repreneur (pas une réinstallation complète par défaut) :
   - Copier `~/.config/opencode/skills/gas-setup-node-clasp-off/` vers `[dossier-projet]/.setup/gas-setup-node-clasp-off/` — utile le jour où le repreneur voudra publier une modification suggérée par l'IA
   - Ne PAS embarquer par défaut les skills de sécurisation dev (`gas-reviewer`, `gas-impact-analyzer`, `gas-regression-checker`) ni les skills d'onboarding (`gas-onboarding-*`, `collaborator-onboarding`) — ces skills servent à qui modifie du code en connaissance de cause ou configure un nouvel environnement de zéro, hors périmètre d'un repreneur qui pilote via langage naturel. Le besoin plus large de cadrer des utilisateurs de plus en plus autonomes à l'échelle de l'organisation est un sujet à part (voir TODO OpenCode globale, item mécanisme de distribution de skills), pas à résoudre en surchargeant un zip de passation ponctuel.
3. Générer le zip à la racine du dossier projet (`cd [dossier-projet] && zip -r [nom-projet]-pour-[repreneur].zip . -x "*.DS_Store"`)
4. Vérifier que `USER_GUIDE.md` mentionne bien l'instruction "dis à l'IA d'installer le skill [nom]" plutôt qu'un chemin de dossier à chercher soi-même

Le cédant transmet ensuite ce zip par le canal de son choix (email, Drive, clé USB). Le repreneur n'a qu'à le décompresser dans un dossier et ouvrir OpenCode dessus — tout le reste (chargement du guide, installation du skill sur demande) est automatique.

---

## PHASE 4 — DÉMO ORALE ET FILET DE SÉCURITÉ

### 4.1 — Checklist de démo (pour le cédant, pas un document transmis)

Avant la démo live, rappeler au cédant de couvrir dans l'ordre :
1. Où se trouve le dossier/fichier principal, comment y accéder
2. Chaque action du menu — cliquer devant elle, montrer le résultat concret
3. Ce qui tourne automatiquement (montrer un email déjà reçu si possible)
4. Que faire si un message d'erreur apparaît (lire le message, ne pas paniquer, contacter le cédant avec une capture d'écran)
5. Si Q3 = OpenCode : montrer une fois comment ouvrir OpenCode et formuler une demande simple

### 4.2 — Filet de sécurité post-passation

Résumer par écrit (dans le message final à l'utilisateur, pas forcément dans un fichier) :
- Le premier réflexe en cas de souci signalé par le repreneur : vérifier les logs d'exécution (Extensions > Apps Script > Exécutions) avant toute autre hypothèse
- Le point de contact déclaré en Q2/USER_GUIDE.md

---

## CLÔTURE

```
## Passation prête ✓

Checklist technique :
├── [x] Partage domaine appliqué (dossier + fichiers)
├── [x] Triggers de test nettoyés
├── [x] Constantes de config basculées vers [repreneur]
└── [ ] Transfert de propriété — à faire manuellement dans Drive

Fichiers générés :
├── USER_GUIDE.md → guide pour [repreneur] et les futures sessions IA
└── opencode.json → charge USER_GUIDE.md automatiquement à l'ouverture

[Si Phase 3 exécutée :]
Environnement repreneur :
├── OpenCode : [déjà installé / installé via collaborator-onboarding]
├── Fichiers projet : [clasp clone possible / package zip généré dans le dossier projet]
└── [Si package zip :] ⚠ Solution temporaire — à refaire via clasp clone une fois débloqué.
    Skills embarqués dans .setup/ : [liste] — le repreneur n'a jamais à les
    installer lui-même, il lui suffit de le demander à l'IA.

Prochaine étape : transférer la propriété Drive, transmettre le package au
repreneur si applicable, puis faire la démo orale (checklist Phase 4.1).
```
