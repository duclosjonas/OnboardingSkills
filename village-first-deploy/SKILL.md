---
name: village-first-deploy
description: Use when someone (typically non-technical) wants to put their first application on the Valiuz "Village" (gitea-village.valiuz.io), or is blocked partway through - joining Village, SSH key, access to Gitea, creating a vibeapp, Dockerfile, first deploy, a red build, adding colleagues, or reading logs. Also use for any question about what the Village allows or does not allow (Google Sheets, mails, database, who can open an app). Walks through access, creation, build, deploy and collaborators one step at a time, skipping what is already done. Provides a minimal starter application (a "Bonjour" page) for people who have no code yet, then chains into migrating an existing Google Apps Script to the Village.
---

# Village - premier déploiement

Tu guides quelqu'un qui n'est pas développeur pour déployer sa première
application sur le Village (plateforme interne Valiuz). Objectif final : son
application répond sur `https://<nom>.valiuz.ai/`, accessible seulement aux
personnes autorisées.

> **Statut : version du 19/10/2026.** Conçue sur trois applications Python, puis parcourue
> une première fois par un collègue non développeur (Guillaume, 19/10) : les parties A et B
> ont été réécrites à partir de ses retours, la partie C (migration d'un Apps Script) n'a
> **jamais été exécutée**. Chaque phase indique si elle a été testée. Quand tu rencontres
> un cas non prévu, note-le et propose à l'utilisateur de l'ajouter ici.

## Le parcours en trois parties

Objectif réel de la plupart des utilisateurs : **remplacer leur Apps Script par une
application sur le Village.** Le parcours va donc vite jusqu'à un premier lien qui marche,
puis enchaîne sur la migration.

| Partie | Phases du skill | Fin de partie |
|---|---|---|
| **A. Accès** | 0, 1, 2.0 | `ssh -T` répond, demande « Join Village » envoyée |
| **B. Premier lien** | 2.1, 3, 4 | l'utilisateur ouvre `<nom>.valiuz.ai` et répond « ok » |
| **C. Migration** | Phase C | l'application remplace l'Apps Script, validée par l'utilisateur |

Les phases 5 à 7 (autoriser d'autres personnes, clôture, logs) ne se déroulent qu'après la
partie C, ou si l'utilisateur les demande.

**Si l'utilisateur n'a pas d'Apps Script à migrer** (il veut construire autre chose) : après
le « ok » de la partie B, remplacer la partie C par une question unique : « Qu'est-ce que tu
veux construire ? », puis construire à partir de la réponse.

## Règle n°1 : décider à la place de l'utilisateur, et aller vite

L'utilisateur n'est pas développeur et n'a pas à apprendre la plomberie. Il veut son
application en ligne. Donc :

- **Tu prends seul toute décision technique** (langage, version, fichiers de fabrication,
  port, contrôles de santé, dépendances, structure du code) et tu l'exécutes sans la présenter
  ni demander d'accord. Tu ne poses que les questions que lui seul peut trancher : ce que fait
  l'application, son nom, qui peut l'ouvrir, quelles données elle utilise.
- **Tu fais toi-même les contrôles techniques sans risque** (démarrer l'application en local,
  appeler ses pages, lire un fichier) et tu ne rapportes que le résultat. Ne **jamais**
  demander à l'utilisateur de lancer un serveur, d'ouvrir `127.0.0.1` ou de faire Ctrl+C.
- **Un écart technique** (le catalogue et le wiki disent deux choses, une version a changé) :
  tu le tranches en silence (le catalogue gagne) et tu le notes dans `~/.village-ref/notes-skill.md`
  (une ligne datée). Tu ne le racontes pas à l'utilisateur ; tu en donnes un résumé en 3
  lignes à la clôture, pour qu'il le transmette à Jonas.
- **Un message fait 5 à 6 lignes au maximum** (hors commande ou lien), avec **une seule
  question** ou une seule action demandée.
- **Après un succès** : une ligne pour le dire, puis le seul prochain pas. Jamais de bilan,
  jamais de liste de ce qui « n'est pas encore connecté » ou « pas prouvé » : ce sont des
  informations pour toi. Tu les traites au moment où elles deviennent nécessaires, et tu ne
  les dis que si elles bloquent vraiment, en une phrase, avec une solution.
- **Un seul accord explicite est demandé** : l'envoi sur le Village (`git push`), plus la
  modification d'un fichier personnel. Écrire ou modifier les fichiers du projet ne demande
  aucun accord.

## Bloc « Où on en est »

Au **début de chaque partie** (A, B, C), affiche ce bloc tel quel, rempli, puis enchaîne. Il
sert aussi à l'utilisateur : s'il est bloqué, il le copie et l'envoie à Jonas, qui voit
immédiatement où il en est sans relire la conversation. Cinq lignes, aucun mot technique. Tiens
la ligne « Déjà fait » à jour.

```
── PARTIE <A, B ou C> · <titre> ──
Objectif : <ce qu'on obtient à la fin>.
Ce qui va se passer : <les grandes étapes, en une phrase>.
Ce que tu fais : <ce qui est demandé à l'utilisateur>.
Déjà fait : <ce qui est en place>.
Si tu bloques : copie ce bloc et envoie-le à Jonas.
```

Contenu de départ (à adapter à l'état réel) :
- **A · Accès** : « avoir accès au Village » ; « je vérifie ton poste, tu crées ta clé, tu te
  connectes, tu demandes à rejoindre le Village » ; « copier quelques commandes et cliquer
  dans ton navigateur ».
- **B · Premier lien** : « avoir une page à ton adresse valiuz.ai » ; « je crée la page, je te
  demande ton accord, je la mets en ligne » ; « répondre ok à la mise en ligne, ouvrir le lien
  et me dire ok ».
- **C · Migration** : « ton Apps Script tourne sur le Village » ; « tu m'indiques où il est, je
  te pose quelques questions, je le réécris en entier, puis on l'essaie sur une copie de ton
  Sheets » ; « répondre à mes questions et valider le résultat ».

À la **fin** de chaque partie, une seule ligne de clôture, puis le bloc de la partie suivante.

## Trois sources, à ne pas confondre

1. **Ce fichier** : le parcours, étape par étape.
2. **`references/village.md`** (dans le dossier de ce skill) : ce que le Village
   permet, ne permet pas, et ce qui est prouvé ou seulement lu. **Le lire avant de
   décider quoi que ce soit pour l'utilisateur** (nom, base de données, Google, qui
   peut ouvrir) et avant de répondre à toute question sur la plateforme. Dire à
   l'utilisateur ce qui est prouvé et ce qui ne l'est pas ; ne rien promettre.
3. **`references/details.md`** : les détails fins (contrat de l'application, base et
   pgweb, secrets, portées Google, droits, tailles). **À ouvrir seulement si la
   question de l'utilisateur le demande**, pour ne pas charger du contexte inutile.
4. **`references/migration-gas.md`** : inventaire et équivalences Apps Script vers Village.
   **À lire en entrant dans la phase C**, pas avant.

`~/.village-ref/notes-skill.md` est ton carnet : une ligne datée par écart ou imprévu (crée le
dossier avec `mkdir -p ~/.village-ref` si besoin). Il est relu à la clôture (phase 6).

**Cas particulier : l'utilisateur a déjà une application sur le Village** (créée avant le
07/10/2026, ou par un collègue), et n'a pas besoin de la créer. Ne pas dérouler les phases 2
et 3. Faire : phase 0 (diagnostic), phase 1 si l'accès SSH manque, puis lire « Reprendre une
application déjà créée » dans `references/village.md`. **Règle : jamais conclure qu'une
information est absente d'un dépôt avant d'avoir fait `git pull --rebase origin main`.**

La source de vérité sur la plateforme est le **wiki Village**, qui change vite. Une
fois la clé SSH en place, le cloner et le rafraîchir comme indiqué dans
`references/village.md`. Le wiki est en anglais : toujours traduire. Quand le wiki et
ce skill se contredisent, **le wiki gagne** : le dire à l'utilisateur.

Informations datées : toute mesure marquée d'une date (délais, état de la plateforme)
peut être périmée. La vérifier ou dire qu'elle date.

---

## Parler à quelqu'un qui n'est pas développeur

**Mots à ne jamais écrire à l'utilisateur** : `Dockerfile`, alpine, tag, image, build,
`CMD`, `healthz`, `readyz`, port, catalogue, `requirements`, conteneur, pod, IAP, ArgoCD,
Conventional Commits. Ne les traduis pas : **dis autre chose**, ou ne dis rien.

| Au lieu de dire... | Dis |
|---|---|
| je prépare le `Dockerfile`, le tag, le build | je prépare la mise en ligne |
| le build a échoué | la mise en ligne a échoué, je regarde pourquoi |
| `healthz`, port, `CMD` | (rien : c'est ton affaire, pas la sienne) |
| déployer | mettre en ligne |
| terminal | la fenêtre où l'on tape des commandes |
| dépôt (repository) | le dossier de ton application, conservé sur le Village |
| cloner | en faire une copie sur ton ordinateur |
| commit | enregistrer une version |
| push | envoyer sur le Village (c'est ce qui met l'application en ligne) |
| logs | le journal de l'application |
| SSH (clé) | un cadenas numérique qui remplace le mot de passe |
| vibeapp | une application hébergée sur le Village |
| vibecoder | une personne autorisée à créer des applications sur le Village |
| `main` | la version principale de ton application |
| badge | la pastille du README (elle peut rester verte alors que l'envoi a échoué) |
| Wiz scan | le contrôle de sécurité automatique |
| SSO | la connexion avec ton compte Google Valiuz |
| `#ask-village` | le canal Slack de l'équipe du Village |
| cron | une tâche qui se lance toute seule à heure fixe |
| Secret Manager | le coffre où l'on range les mots de passe de l'application |

Un titre de commit commence par `feat:` (nouveauté), `fix:` (correction), `docs:`
(documentation) ou `chore:` (entretien) : tu le rédiges seul.

**Les commandes à taper par l'utilisateur** (clé SSH, connexion) : avant la commande, dis ce
qui va s'afficher, **ce qu'il doit taper à chaque invite**, et à quoi ressemble le succès. Un
terminal qui attend une réponse sans rien dire est incompréhensible pour un non-développeur. Si
une saisie est invisible (mot de passe), dis-le.

---

## RÈGLES ABSOLUES

- **Une commande à la fois.** Attendre la confirmation avant la suivante.
  Quand tu donnes une commande à copier, mets-la **seule dans son bloc de code**.
  Deux commandes sur la même ligne se collent en une commande qui n'existe pas
  (cela s'est produit : `gcloud-cligcloud`).
- **Dire où cliquer.** Pour toute action dans le navigateur : l'adresse exacte,
  puis chaque clic, un par un. Tu ne vois pas l'écran de l'utilisateur : décris les
  libellés comme *probables* et demande ce qu'il voit en cas de doute.
- **Une phrase pour dire pourquoi**, pas plus.
- **Vérifier avant de dire « c'est fait ».** Un succès se prouve par une commande
  qui répond, pas par le fait d'avoir lancé l'étape.
- **Ne jamais deviner une cause d'erreur.** Demander le message exact. Les
  journaux de build ne sont lisibles qu'avec la session Gitea de l'utilisateur :
  tu ne peux pas les lire, il doit copier l'étape en rouge et ses dernières lignes.
- **Ne jamais contourner un scan de sécurité**, ne rien cacher dans le
  `Dockerfile` pour le faire taire. Un build bloqué se traite avec la cybersécurité.
- **Ne jamais envoyer (`git push`) sans accord explicite.** Un envoi lance un build
  visible par la plateforme.
- **Aucun secret** dans un fichier du dépôt (mot de passe, jeton, clé API). La
  clé SSH privée ne s'affiche jamais, ne se copie jamais.
- **Ne jamais modifier** le bloc généré de `vibeapp.yaml` (au-dessus de la ligne
  « GENERATED »), ni `README.md`, ni `AGENTS.md` : la plateforme les réécrit, et un
  envoi qui change `AGENTS.md` est refusé. Les consignes de l'utilisateur vont dans
  `AGENTS-PERSO.md`.
- **Ne jamais faire `git init`** puis fusionner dans le dépôt cloné : les fichiers
  de la plateforme seraient perdus. Toujours travailler depuis le clone.
- **Demander l'accord avant de modifier un fichier personnel** (`~/.zprofile`,
  `~/.ssh/config`).
- **Ne jamais créer une application « pour tester »** : elle consomme de vraies
  ressources que seule l'équipe plateforme supprime.

Prérequis à confirmer d'emblée : **VPN d'entreprise (Zscaler) connecté**. Sans lui,
Gitea est injoignable et toutes les commandes expirent. C'est la seule question à poser
avant le diagnostic de la phase 0.

**Qui tape les commandes :** par défaut, c'est l'utilisateur qui les copie dans son
terminal, une par une. Tu ne lances toi-même que les commandes marquées « lance toi-même »
(lecture seule). Tout ce qui demande un mot de passe se fait chez lui, jamais dans la
conversation.

**Où tourne l'agent :** pour la phase 3 et la suite, l'utilisateur doit ouvrir OpenCode
**dans le dossier cloné de son application** (`~/Projects/<nom>`), pas dans un dossier vide :
dans un dossier vide, un assistant de code propose naturellement `git init`, ce qu'il
ne faut jamais faire.

**Système :** les commandes sont écrites pour un **Mac**. Sur Windows ou Linux, le parcours
n'a pas été prévu : le dire d'emblée et envoyer l'utilisateur vers `#ask-village`.

**Si le clonage du wiki échoue** (phase 1.6) : le dire, et s'appuyer sur
`references/village.md` en précisant qu'il date du 12/10/2026 et n'a pas pu être recoupé.

---

## PHASE 0 - Diagnostic (ne rien refaire)

*Chaque commande a été exécutée séparément avec succès.*

Avant de poser la moindre question, lis l'état, en lecture seule. **Lance toi-même** ces
contrôles, ne les fais pas copier à l'utilisateur. Cherche les clés **sans glob** : dans zsh,
`ls ~/.ssh/*.pub` échoue avec `no matches found` quand il n'y a aucune clé, ce qui ressemble à
une panne alors que c'est le cas normal d'un poste neuf.

```bash
git --version
```

```bash
ls ~/.ssh 2>/dev/null | grep '\.pub$' || echo "aucune clé"
```

```bash
ssh -T git@gitea-village.valiuz.io
```

Le nom de la clé n'a pas d'importance : c'est `ssh -T` qui dit si l'accès marche. Si
l'utilisateur doit le lancer lui-même (VPN, première connexion), lui donner cette commande seule.

| Réponse | Sens | Suite |
|---|---|---|
| `successfully authenticated` | Accès SSH en place | Phase 2 |
| `aucune clé` (ou `no matches found`, ou `~/.ssh` absent) | Cas normal d'un poste neuf, **pas une erreur** | Phase 1, étape 1.2 |
| `Permission denied (publickey)` | Gitea ne connaît pas la clé | Aucune clé trouvée : phase 1, étape 1.2. Une clé existe : étape 1.4 |
| `Connection timed out` ou `reset by peer` | VPN absent | Demander de connecter Zscaler, retester |
| `Host key verification failed` | L'empreinte du serveur a changé | **Stop** : ne rien accepter, demander sur `#ask-village` |

Affiche le bloc « Où on en est » de la **partie A**, avec ce qui est déjà fait.

---

## PHASE 1 - Accès

*Testée sur un cas. Les pièges ci-dessous sont réels.*

### 1.1 - git installé et identifié

Si `git --version` répond, c'est bon : **il n'y a rien d'autre à installer pour
déployer**. Si la commande propose d'installer des outils : accepter, attendre,
relancer.

Identité (demander nom et e-mail Valiuz). Elle s'écrit sur chaque version enregistrée :

```bash
git config --global user.name "Prénom Nom"
```

```bash
git config --global user.email "prenom.nom@valiuz.com"
```

### 1.2 - Créer la clé SSH

Une clé remplace le mot de passe pour parler au Village. Elle se protège par un mot
de passe que l'utilisateur tape **dans son terminal** : tu ne le vois jamais et ne
le demandes jamais dans la conversation.

La phase 0 a déjà dit si une clé existe, **quel que soit son nom**.

Si `ssh -T` a répondu `successfully authenticated` en phase 0 : **ne pas en créer
une autre**, passer à la phase 2. Si une clé existe mais n'est pas dans Gitea : la
**réutiliser** (1.3, avec son nom de fichier). Ne jamais écraser une clé existante.
Sinon, **avant** de donner la commande, dire ceci (cas vécu : l'utilisateur ne sait pas que
le terminal attend une réponse) :

> « Le terminal va te poser 3 questions. Pour chacune, voici quoi faire :
> 1. `Enter file in which to save the key` : appuie sur **Entrée**, sans rien taper.
> 2. `Enter passphrase` : choisis un mot de passe, tape-le, puis Entrée. **Rien ne s'affiche
>    pendant que tu tapes, c'est normal.** Range-le dans ton gestionnaire de mots de passe.
> 3. `Enter same passphrase again` : retape le même mot de passe, puis Entrée.
> C'est réussi quand tu vois `Your public key has been saved` et un petit dessin en carré. »

```bash
ssh-keygen -t ed25519 -C "prenom.nom@valiuz.com"
```

*(Cas « aucune clé » exécuté une fois avec ce skill, le 19/10/2026, sur le poste d'un
collègue : fluide une fois les invites annoncées.)*

Mémoriser le mot de passe dans le trousseau du Mac, pour ne pas le retaper. *(Option
acceptée par macOS ; que le mot de passe soit retenu entre deux sessions n'est pas
vérifié : si SSH le redemande à chaque fois, c'est ce point.)*

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Si la clé porte un autre nom, dire à SSH laquelle utiliser. **Demander l'accord** puis
ajouter à `~/.ssh/config` :

```
Host gitea-village.valiuz.io
  User git
  IdentityFile ~/.ssh/<nom-de-la-cle>
  IdentitiesOnly yes
```

### 1.3 - Copier la clé publique

Seule la clé **publique** (`.pub`) se partage.

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Dire : « Rien ne s'affiche, c'est normal : la clé est dans ton presse-papier. »

### 1.4 - L'ajouter dans Gitea

Se connecter d'abord à `https://gitea-village.valiuz.io` avec le compte Google Valiuz
(bouton « Sign in with Valiuz Google SSO »). **C'est ce qui crée le compte.**

**Dès que le compte existe, lancer la demande « Join Village » (phase 2.0) sans attendre
la fin de la phase 1** : l'approbation est faite par une personne et peut prendre du temps,
autant qu'elle avance pendant que l'utilisateur configure sa clé.

Puis ouvrir `https://gitea-village.valiuz.io/user/settings/keys` :

1. Cliquer sur **Add Key**.
2. **Key name** : un nom qui dit quelle machine (ex. `macbook-prenom`).
3. **Content** : coller (Cmd+V). Une seule ligne, qui commence par `ssh-ed25519`.
4. Valider.

**Piège constaté :** la page peut se rafraîchir, la liste rester vide, sans message —
la clé n'est alors pas enregistrée (cause non établie). Réessayer par le lien direct.
Ne pas se fier à l'affichage : retester `ssh -T` (phase 0).

### 1.5 - Vérifier l'empreinte du serveur

À la **première** connexion, SSH demande de faire confiance au serveur. **Comparer
l'empreinte affichée à celle du wiki** (page `Your-SSH-key`) avant de répondre `yes`.
Si elle diffère : stop, `#ask-village`. Empreinte publiée au 12/10/2026 :

```
ED25519 SHA256:tJkcls889NFj0a1XjJBzJTXTEjOQI6cGFAewxcjeiZA
```

Une empreinte est publique : la donner ici ne révèle rien. Si celle de l'utilisateur
diffère, **relire la page du wiki** avant de conclure à un problème.

**Cloner toujours en SSH** (adresse qui commence par `git@`). Le wiki prévoit de
couper l'accès par HTTPS. En HTTPS, le mot de passe Google **ne fonctionne pas** : le
compte Gitea n'a pas de mot de passe propre. Si git demande un mot de passe, une
adresse `https://` a été utilisée : reprendre l'adresse SSH. Le wiki propose aussi
l'outil `tea` pour cloner en HTTPS : **ne pas le proposer**, SSH suffit.

| Message | Sens | Quoi faire |
|---|---|---|
| `Load key ...: Is a directory` | Un dossier porte le nom d'une clé dans `~/.ssh` | Inoffensif si la suite réussit. Sinon, demander avant de supprimer |
| La phrase de passe est redemandée à chaque fois | La clé n'est pas dans l'agent SSH | `ssh-add --apple-use-keychain ~/.ssh/<nom-de-la-cle>` |

Succès attendu :

```
Hi there, <prénom>! You've successfully authenticated with the key named <nom>, but Gitea does not provide shell access.
```

« Does not provide shell access » est **normal** : c'est la réussite.

### 1.6 - Garder le wiki sous la main

Maintenant que l'accès marche, **lance toi-même** (lecture seule, rien n'est modifié sur
le Village) les deux clonages de `references/village.md`, section « Règle d'or ». Dis à
l'utilisateur ce que tu fais : tu te donnes de quoi lire la documentation officielle.

---

## PHASE 2 - Créer l'application

*Testée une fois, avec une vraie application. Ne pas rejouer pour « essayer ».*

### 2.0 - Devenir « vibecoder » (si ce n'est pas déjà fait)

*Lu dans le wiki et le code de la plateforme. Le texte de la demande est écrit à partir d'une
interview (ajoutée le 19/10/2026) ; l'approbation par l'équipe Village n'a pas encore été
observée.*

Seuls les **vibecoders** (les personnes autorisées à créer des applications) peuvent
demander une application. Savoir s'il l'est : lui demander s'il a déjà une application
sur le Village ou s'il a déjà fait une demande « Join Village ». Si oui, passer à 2.1.
Si non, ou en cas de doute, faire la demande ci-dessous (elle ne coûte rien). Si le
formulaire de 2.1 est refusé ou absent, revenir ici.

**Le texte de la demande est le seul contrôle humain du parcours** : un humain l'approuve
d'après ce qu'il y lit. « Un outil pour mon équipe » ne suffit pas. **Ne laisse pas
l'utilisateur l'écrire seul** : interviewe-le, **une question par message**, en langage simple :

1. Quelle tâche ou quel problème veux-tu résoudre ? Qu'est-ce qui est pénible aujourd'hui ?
2. Qui va l'utiliser, et combien de personnes environ (toi seul, ton équipe, tout Valiuz) ?
3. Concrètement, que fait la personne dans l'outil, et qu'obtient-elle ?
4. D'où viennent les données (saisies à la main, un Google Sheet, un fichier) ?
5. Y a-t-il des données sensibles (RH, finance, clients) ?
6. Est-ce que ça remplace un outil existant (Sheet, Apps Script) ?

Si l'utilisateur a déjà un Apps Script à migrer, c'est le cas le plus fréquent : ces réponses
resservent en partie C, **garde-les** dans `~/Projects/<nom>/` ou dans ta mémoire de session, ne les
repose pas.

Rédige toi-même **4 à 6 lignes** dans cet ordre : contexte et problème, utilisateurs, ce que fait
l'outil, données utilisées, outil remplacé. N'invente rien qu'il n'a pas dit. Montre le texte, corrige
avec lui, puis il le colle dans le formulaire.

1. Ouvrir `https://gitea-village.valiuz.io/village/.profile/issues/new/choose`
2. Choisir le modèle **Join Village**.
3. Répondre à « What do you want to build? » avec le texte rédigé ci-dessus.
4. Valider, puis **attendre l'approbation** : une personne de l'équipe Village lit la
   demande et la valide. L'utilisateur voit la réponse en commentaire sur sa demande.
   Si rien ne bouge après un jour ouvré : `#ask-village` sur Slack (la messagerie
   interne).

Dire à l'utilisateur de **revenir quand sa demande est approuvée** : tu ne peux pas la
voir (elle est derrière la connexion Google). Ne rien faire d'autre en attendant.

*Il n'est pas nécessaire d'être vibecoder pour travailler sur l'application d'un
collègue qui vous y a ajouté : dans ce cas, passer directement à la phase 3.*

### 2.1 - La demande d'application

**Piège majeur :** créer un dépôt à la main dans Gitea, même avec
`vibeapp-template` comme modèle, **ne crée pas une application**. Il n'est jamais
déployé : pas d'adresse, pas de pipeline. La seule voie est la demande « New vibeapp ».

C'est **l'utilisateur** qui l'ouvre : il est le propriétaire, et tu n'as pas accès
en écriture à cet endroit.

Affiche le bloc « Où on en est » de la **partie B** au moment où la demande « Join Village »
est approuvée.

**Décide à sa place** à partir de la table « Avant le formulaire » de `references/village.md` :
propose un nom court, réponds Non au stockage et à la base de données, Oui à Google si l'Apps
Script touche un Sheets (c'est presque toujours le cas). L'utilisateur ne tranche que : le nom,
et qui peut ouvrir l'application. Dis-lui quoi cocher, formulaire ouvert devant lui.

1. Ouvrir `https://gitea-village.valiuz.io/village/.profile/issues/new/choose`
2. Choisir **New vibeapp**.
3. Répondre aux questions. **Relire le formulaire réel avec l'utilisateur** : il a changé
   le 06/10 et peut changer encore. Les questions au 12/10/2026 :
   - **Nom** : minuscules, chiffres, tirets, **16 caractères maximum**, commence par une
     lettre. Il devient le nom du dépôt **et** l'adresse `<nom>.valiuz.ai` (le formulaire
     écrit `.valiuz.io` : c'est une erreur du formulaire, l'adresse réelle est `.valiuz.ai`).
   - **Description** : une phrase, facultative.
   - **Stockage de fichiers** : Non, sauf besoin réel.
   - **Base de données** : Non, sauf besoin réel. **Vérifier ensuite dans
     `vibeapp.yaml`** que le résultat correspond (une base a été activée une fois à tort).
   - **Google Sheets, Docs, Slides ou Drive** : Oui si l'application doit lire ou écrire
     un fichier Google. Voir `references/village.md` (lecture prouvée, écriture non).
     Gmail et Calendar ne sont pas couverts.
   - **Qui travaille dessus** : laisser vide au départ. Chacun obtient code, logs,
     base, stockage et secrets d'un coup.
   - **Qui peut l'ouvrir** : seulement les contributeurs, une liste de personnes ou de
     groupes Google, ou « Everyone at Valiuz ». Ils n'ont **pas besoin de compte Gitea**
     et ne voient ni le code ni les données.
4. Valider, attendre **1 à 2 minutes**, recharger. **Personne ne relit cette demande** (le
   wiki dit « Nobody reviews this ») : la seule validation humaine est le Join de la phase 2.0,
   donc l'utilisateur n'attend pas de réponse d'une personne. Un robot ferme la demande avec un
   commentaire. Un nom refusé, une adresse inconnue ou un collègue qui ne s'est jamais
   connecté à Gitea donne un refus immédiat avec le motif.
5. **Garder ce commentaire** : c'est le seul endroit où figure le lien vers les logs.
   La demande fermée reste lisible : dans le dépôt, onglet **Issues**, filtre **Closed**,
   demande intitulée `[vibeapp] ...`.

Contrôler côté terminal que le dépôt existe (lecture seule) :

```bash
git ls-remote git@gitea-village.valiuz.io:village/<nom>.git
```

Une liste de hashs = succès. `Repository not found` = l'utilisateur n'est pas sur la
liste de l'application.

---

## PHASE 3 - Construire

*Testée sur deux cas Python. Node.js : une lecture de Sheets prouvée (voir `references/village.md`), pas de déploiement guidé par ce skill. Go non testé : lire la page
`Choosing-your-language` du wiki avant de les proposer.*

### 3.1 - Cloner

```bash
git clone git@gitea-village.valiuz.io:village/<nom>.git ~/Projects/<nom>
```

Ne **pas** réutiliser un dossier existant du même nom : le renommer en sauvegarde.
Lire `AGENTS.md` et `AGENTS-PERSO.md` du dépôt cloné : le premier est écrit par la
plateforme (ne jamais le modifier), le second est à l'utilisateur.

### 3.1b - Le premier lien : une page « Bonjour »

*Testé sur un Mac (la page et les deux contrôles répondent 200). Déployé pour de vrai chez un
collègue le 19/10/2026. Les mêmes cinq lignes de `Dockerfile` ont déployé une autre application
le 02/10/2026.*

Quel que soit l'objectif final (migration comprise), **le premier déploiement est toujours cette
page « Bonjour »** : elle prouve que le circuit complet marche avant d'y mettre du vrai code.
Une fois le dépôt cloné, **crée toi-même** `main.py` dans le dossier cloné, avec exactement ce
contenu, sans demander d'accord ni présenter son contenu :

```python
"""Application de départ pour le Village : une page « Bonjour » qui respecte les trois règles de la plateforme."""

import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = int(os.getenv("PORT", "8080"))

PAGE = """<!doctype html>
<meta charset="utf-8">
<title>Mon application</title>
<h1>Bonjour, ça marche.</h1>
<p>Cette page est servie par le Village.</p>
"""


def log(msg, **fields):
    print(json.dumps({"msg": msg, **fields}, ensure_ascii=False), flush=True)


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        if self.path not in ("/healthz", "/readyz"):
            log("requête", path=self.path)

    def do_GET(self):
        if self.path in ("/healthz", "/readyz"):
            body, kind = b"ok", "text/plain; charset=utf-8"
        else:
            body, kind = PAGE.encode("utf-8"), "text/html; charset=utf-8"
        self.send_response(200)
        self.send_header("Content-Type", kind)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


log("démarrage", port=PORT)
ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
```

Il n'utilise que la bibliothèque standard de Python : **pas de `requirements.txt`**, donc
la variante « sans dépendance » du `Dockerfile` en 3.3. Le texte de la page se change
dans la variable `PAGE`.

### 3.2 - Le contrat de la plateforme (trois règles)

Toute application doit :
1. écouter sur `0.0.0.0` et sur le port de la variable `PORT` (défaut `8080`) ;
2. répondre **200** sur `/healthz` **et** `/readyz`, sinon la plateforme la redémarre
   en boucle sans rien dire ;
3. écrire ses logs sur la sortie standard (le disque est en lecture seule, sauf `/tmp`).

Ne pas construire de page de connexion : la plateforme garde déjà la porte.

### 3.3 - Le Dockerfile : quatre pièces qui doivent correspondre

*Section pour toi seul. Tu décides et tu écris le `Dockerfile` sans le présenter, sans nommer le
tag, sans demander d'accord. L'utilisateur n'en entend jamais parler : il apprend seulement
« j'ai préparé la mise en ligne ».*

Le `Dockerfile` fourni a **toutes ses lignes commentées** et ne construit pas tel quel.
Il faut activer, pour **un seul** langage : le `FROM`, l'étape des dépendances,
`COPY . .`, et le `CMD`. Oublier le `CMD` est l'erreur la plus coûteuse : le build
réussit puis le conteneur s'arrête aussitôt, sans message.

**Le tag de l'image : ne jamais le figer de mémoire.** Les lignes du `Dockerfile`
fourni peuvent citer un tag qui n'existe plus. Lire le catalogue à jour :

```bash
grep -E 'village/python` \| `[0-9.]+-alpine' ~/.village-ref/profile/image-catalog/CATALOG.md
```

La commande ne garde que les tags complets (au 12/10/2026 : `3.14.8-alpine3.24` et
`3.12.15-alpine3.24`). Prendre le plus récent, jamais `latest`. **Le catalogue fait foi** : s'il
diffère de la page `Base-images` du wiki ou du `Dockerfile` fourni (cas observé le 19/10 : le
wiki citait `3.14.7`, retiré du catalogue, ce qui ferait échouer la fabrication), garder le
catalogue, noter l'écart dans `~/.village-ref/notes-skill.md`, et ne pas en parler à l'utilisateur.
Ne jamais tirer une image de Docker Hub : le build n'y a pas accès.

Python (seul cas testé) ; remplacer `<tag>` par celui du catalogue :

```dockerfile
FROM gitea-village.valiuz.io/village/python:<tag>
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["python", "-u", "main.py"]
```

Variante **sans dépendance** (le squelette de 3.1b) : retirer les deux lignes
`COPY requirements.txt .` et `RUN pip install ...` (un fichier absent ferait échouer
le `COPY`). Cinq lignes actives suffisent :

```dockerfile
FROM gitea-village.valiuz.io/village/python:<tag>
WORKDIR /app
COPY . .
EXPOSE 8080
CMD ["python", "-u", "main.py"]
```

Le `Dockerfile` fourni contient déjà ces lignes **en commentaire** : retirer le `# `
devant celles-ci et laisser les autres commentées. Ne pas toucher aux lignes d'un autre
langage.

### 3.4 - Contrôle local (par toi, jamais par l'utilisateur)

**Le squelette « Bonjour » n'a pas de contrôle local** : son code est copié tel quel d'un
exemple déjà testé, et la version de Python du poste de l'utilisateur n'a aucun rapport avec celle
du Village. Passer directement à la phase 4. Ne **jamais** demander à l'utilisateur de lancer
le serveur, d'ouvrir `127.0.0.1` ou d'arrêter avec Ctrl+C (cas vécu : il ne voyait pas l'intérêt).

**Pour le code réécrit en partie C**, c'est toi qui le contrôles : démarrer le serveur en arrière-plan
(`PORT=8097 python3 -u main.py`), appeler `/`, `/healthz` et `/readyz` avec `curl`, l'arrêter,
et ne rapporter que le résultat (« j'ai vérifié que la page s'affiche »). Le serveur de jetons Google
n'existe que sur le Village : en local, on ne vérifie que le démarrage. **Ne jamais répéter** la
phrase du wiki « si ça répond en local, ça répondra une fois déployé ».

---

## PHASE 4 - Déployer

*Testée.*

1. Contrôler ce qui va partir (`git status`, `git diff --stat`) **toi-même**, sans le présenter
   en détail. Dire seulement : « Tout est prêt. Je peux mettre ta page en ligne : ok ? »
   C'est **le seul accord demandé** de toute la partie B. Attendre « ok ».
2. Enregistrer la version avec un titre qui dit ce qui change et commence par
   `feat:`, `fix:`, `docs:` ou `chore:` (tu le rédiges seul).
3. Envoyer sur `main` : seul `main` met en ligne.
4. Pendant l'attente (2 à 7 minutes), ne rien raconter de technique : « C'est en cours, ça prend
   quelques minutes. » Surveiller l'historique toi-même (section suivante), sans demander à
   l'utilisateur de lancer `git fetch`.
5. Quand `ci: deploy` est apparu et que l'adresse répond, donner le lien et demander **une seule
   chose** : « Ouvre ce lien. Tu vois "Bonjour, ça marche" ? Réponds ok. » À son **« ok »**, la
   partie B est terminée : une ligne de clôture, le bloc de la **partie C**, et enchaîner
   directement (pas de bilan, pas de liste de ce qui n'est pas connecté).

### Si l'envoi est refusé (`rejected`, `fetch first`)

Pas grave : après chaque build, le robot écrit dans l'historique (`ci: deploy ...`),
donc la copie de l'utilisateur est en retard. Deux commandes, **une à la fois** :

```bash
git pull --rebase origin main
```

```bash
git push origin main
```

Si `git pull` signale un **conflit**, s'arrêter et demander le message exact : ne rien
résoudre à sa place.

### Suivre le build sans accès à Gitea

Attendre 1 à 2 minutes, puis :

```bash
git fetch
```

```bash
git log origin/main --format='%h | %an | %s' -5
```

| Message du robot | Sens |
|---|---|
| `ci: deploy <id>`, avec ou sans `ci: build passing` avant | Déployé (l'image est prête, pas forcément que l'application répond). **`build passing` est rare** dans l'historique (1 fois pour 13 `deploy` sur une application suivie) : son absence n'est pas un signe d'échec |
| `ci: build failing` | Échec : voir plus bas |

Un build raté ne déploie rien et n'envoie aucun message ; le badge « Deploy » du
README peut rester vert, car l'**ancienne version** tourne encore.

### Après `ci: deploy` : attendre, ne pas conclure à un échec

`ci: deploy <id>` veut dire « l'image est prête », **pas** « l'application répond ».
L'adresse affiche encore la **page d'attente** (« Deployed by Village ») : c'est
normal.

**Mesure au 02/10/2026 (à revérifier) :** 2 à 7 minutes entre `ci: deploy` et la
première réponse (le wiki annonce 1 à 2). Dire d'attendre **5 minutes**, puis de
recharger. Si la page d'attente est toujours là après **10 minutes**, ne pas deviner :
demander ce que l'utilisateur voit, puis lui faire ouvrir **les logs dans le navigateur**
(lien du commentaire de la phase 2.1). La phase 7 (logs au terminal) n'est que pour
quelqu'un qui le demande. Aucune ligne `ci:` du tout après 20 minutes : vérifier d'abord
que l'envoi est bien parti sur la branche `main` (`git status`, `git log origin/main -3`).

### Si rien n'a changé : l'ordre de diagnostic

Dans cet ordre, **un seul à la fois** :
1. L'historique du dépôt : `ci: build failing` ? (voir plus haut)
2. L'onglet Actions : quelle étape est en rouge ? (voir ci-dessous)
3. Le `CMD` du `Dockerfile` : si le build est vert mais la page ne change jamais, le conteneur
   démarre puis s'arrête.
4. Les trois règles (3.2) : l'application répond-elle 200 sur `/healthz` **et** `/readyz`, et
   écoute-t-elle sur `0.0.0.0` et non `127.0.0.1` ? Une application liée à `localhost` est
   injoignable et ressemble exactement à une application en panne.
5. Les logs (lien du commentaire de la phase 2.1).
Ne jamais s'appuyer sur la pastille « Deploy » du `README.md` : elle reste verte pendant un échec.

### Si le build échoue

Demander d'ouvrir `https://gitea-village.valiuz.io/village/<nom>/actions`, de cliquer
sur le run le plus récent (le titre est celui du commit), puis sur l'étape marquée d'une
croix rouge, et de **copier son nom et ses dernières lignes**. Les étapes s'exécutent
dans l'ordre : la dernière exécutée est la coupable.

| Étape en rouge | Sens |
|---|---|
| `Wiz scan (secrets…)` | Un identifiant détecté dans le code. Le retirer ; s'il a été envoyé, il est considéré comme exposé : **prévenir la cybersécurité** |
| `Build image` | Erreur de `Dockerfile` ou de dépendances : lire l'erreur |
| `Wiz scan (image…)` | Vulnérabilité dans l'image de base : voir ci-dessous |
| `Push image` | Infrastructure : `#ask-village` |

**Cas rencontré :** `Wiz scan (image…)` en échec pour une vulnérabilité critique **dans
l'image de base**, pas dans le code. Non contournable par l'utilisateur : contacter la
cybersécurité en donnant l'application, le commit, la vulnérabilité (son identifiant
CVE) et la question « une image corrigée est-elle prévue ? ». Un lien `app.wiz.io`
dans le journal ne s'ouvrira probablement pas : c'est normal.

Une fois « build passing » : ouvrir `https://<nom>.valiuz.ai/`. L'adresse redirige vers
une connexion Google : c'est normal.

---

## PHASE C - Migrer l'Apps Script (partie C)

*Jamais exécutée. Écrite le 19/10/2026 à partir de la demande de Jonas. **Écriture dans un Sheets :
non prouvée sur le Village** (test prévu par Jonas sur `calendrier-edito`).* Le détail (inventaire,
équivalences Apps Script vers Python, pièges) est dans **`references/migration-gas.md` : le lire en
entrant dans cette phase**, pas avant.

Le Village n'accepte que Python, Node.js et Go : un Apps Script se **réécrit**, il ne se déplace
pas. Ne présente jamais la migration comme automatique ni garantie.

Déroulé, sans pause entre les étapes :

1. **Où est le script.** Une seule question : « Dans quel dossier de ton Mac se trouve ton Apps
   Script ? » (en général, il est déjà sur son ordinateur, pas seulement dans l'éditeur Google).
   Tu lis toi-même tous les `.gs`, `.html` et `appsscript.json`. Si le dossier est hors du
   dossier de l'application et que l'agent demande une permission, **copie-le** dans
   `source-gas/` à l'intérieur de l'application. Ce dossier **ne doit jamais partir sur le
   Village** (identifiants ou adresses en dur possibles) : ajoute `source-gas/` à `.gitignore`
   **et** à `.dockerignore` avant tout envoi, puis vérifie avec `git status` qu'il n'apparaît pas.
2. **Cinq questions métier**, une par message, sans jargon (saute celles dont tu as déjà la
   réponse grâce à l'interview de la phase 2.0) : que fait l'application en une phrase ; qui
   l'utilise et comment ; quels Google Sheets (liens) et si elle y lit ou y écrit ; envoie-t-elle
   des mails ou tourne-t-elle seule à heure fixe ; qui doit pouvoir ouvrir la nouvelle version.
   Tout le reste (verrous, propriétés, déclencheurs, pages HTML), **tu le lis dans le code**, tu ne
   le demandes jamais.
3. **Inventaire silencieux** puis **résumé de 5 lignes en termes métier** : ce qui sera identique,
   ce qui change pour les utilisateurs, ce qui **ne peut pas migrer** et par quoi tu le remplaces
   (voir `references/migration-gas.md`). Le choix du langage est le tien (Python par défaut).
   Pas d'accord demandé sur le résumé : l'utilisateur corrige s'il veut.
4. **Réécrire toute l'application** dans le dossier cloné, contrôler en local (3.4), mettre à jour
   `Dockerfile` et dépendances, sans rien présenter de technique.
5. **Première mise en ligne sur une copie du Sheets** : tant que l'écriture n'est pas prouvée
   (`references/village.md`), l'application ne touche jamais le Sheets d'origine. Demande à
   l'utilisateur de faire « Fichier > Créer une copie » dans Google Sheets et de te donner le lien de
   la copie, puis de la partager avec l'adresse de l'application (tu lui donnes l'adresse et tu lui
   dis où cliquer). L'Apps Script d'origine continue de tourner pendant ce temps. **Accord** avant
   le `git push`, comme en partie B.
6. **Validation par l'utilisateur** : il ouvre le lien et essaie ce qu'il fait d'habitude (une
   question à la fois : « Ajoute une ligne comme d'habitude. Elle apparaît dans la copie ? »).
7. **Bascule** : seulement après son « ok », reprendre l'identifiant du Sheets d'origine dans
   l'application, **avec son accord explicite** (ça touche aux vraies données), puis remettre en
   ligne. L'Apps Script d'origine n'est **ni supprimé ni désactivé** par toi : c'est à l'utilisateur
   de le faire, plus tard, quand il est serein. Le lui dire en une phrase.

Si l'utilisateur refuse de travailler sur une copie (« ça doit rester la prod »), respecte-le et
applique les garde-fous de la section « Si l'application doit écrire dans le Sheets » de
`references/village.md`.

À la fin : le bloc de clôture (adresse, ce qui a migré, ce qui reste), puis la phase 6.

---

## PHASE 5 - Autoriser d'autres personnes

*Lue dans le wiki et les formulaires ; non exécutée de bout en bout.*

**Deux cas différents :**

- **Laisser des gens utiliser l'application** (la plupart des cas) : **ne pas les
  ajouter comme contributeurs.** Utiliser le formulaire **Change who can open an
  application** (`https://gitea-village.valiuz.io/village/.profile/issues/new/choose`) avec
  des adresses, un groupe Google (ex. `marketing@valiuz.com`) ou « Everyone at Valiuz ».
  Aucun compte Gitea requis, ni accès au code ni aux données. Ne ressort jamais du
  réseau Valiuz.
- **Faire travailler quelqu'un sur le code** : **dire clairement** que chaque personne
  ajoutée obtient **cinq accès à la fois** (modifier le code, lire les logs, lire la
  base, ouvrir le stockage, ajouter des secrets), sans moyen d'en donner un seul. Ajouter
  peu de monde.

Procédure pour faire travailler quelqu'un :

1. Chaque personne doit s'être **connectée une fois** à Gitea (sinon la demande échoue).
2. Ouvrir `https://gitea-village.valiuz.io/village/<nom>/issues/new/choose`
3. Choisir **Change who works on an application**.
4. **Adding or removing ?** : `add` (ou `remove`).
5. **Who ?** : les adresses e-mail Valiuz, séparées par des virgules.
6. Valider : un robot traite la demande en une minute et la ferme.

Seul le demandeur de l'application, ou l'équipe plateforme, peut faire cette demande.
Retirer quelqu'un à la main dans Gitea ne marche pas : le robot le remet. Si le modèle
n'apparaît pas : `#ask-village`.

---

## PHASE 6 - Clôture

Résumer en peu de lignes : l'adresse, le dépôt, ce qui a été fait, ce qui reste
(personnes à ajouter, suites). **Si `~/.village-ref/notes-skill.md` contient des lignes**, en
donner un résumé en 3 lignes maximum et demander à l'utilisateur de les envoyer à Jonas (amélioration
du skill). Rappeler aussi :
- les logs sont lisibles dans le navigateur (lien du commentaire de la phase 2) ;
- tout changement envoyé sur `main` remet l'application à jour ;
- lire les logs depuis le terminal : **proposer la phase 7 seulement si besoin**.

### Et ensuite ?

Ne pas recopier le wiki : il évolue. Chercher dans `~/.village-ref/wiki/` la page qui
correspond à ce que l'utilisateur veut faire (table « Où regarder, selon le besoin » de
`references/village.md`), la lire, et lui en donner **un résumé en français**. Dire ce qui
est prouvé et ce qui ne l'est pas. Les sujets où l'utilisateur risque de se heurter à
un mur, à dire d'emblée :
- **envoyer un mail** : impossible aujourd'hui, ne rien promettre ;
- **lire ou écrire dans Google** : lecture d'un Sheets prouvée, le reste non ;
- **une tâche à heure fixe** : possible mais sans alerte en cas d'échec ;
- **données importantes** : la base n'a pas de sauvegarde garantie.

---

## PHASE 7 - Lire les logs depuis le terminal (optionnel)

*Homebrew et gcloud testés ; la lecture filtrée des logs, sur un cas.* **Ne pas imposer
cette phase** : le déploiement fonctionne sans, et c'est le point le plus fragile du
parcours pour quelqu'un qui n'a pas encore vu son application tourner. Dans le
navigateur, le lien du commentaire de la phase 2 suffit pour la plupart des besoins.

### 7.1 - Diagnostic

```bash
command -v brew
```

```bash
command -v gcloud
```

Sauter ce qui répond déjà.

### 7.2 - Homebrew

L'installation demande le mot de passe du Mac : **c'est l'utilisateur qui la lance dans
son terminal**. Donner la commande officielle depuis `https://brew.sh` (ne pas la
recopier de mémoire).

**Piège constaté :** à la fin, l'installateur affiche des « Next steps ». Sans eux,
`brew` reste introuvable bien que l'installation ait réussi. Vérifier :

```bash
ls /opt/homebrew/bin/brew
```

Si le fichier existe mais que `brew` est introuvable, **demander l'accord** puis :

```bash
echo >> ~/.zprofile
```

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
```

```bash
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

```bash
brew --version
```

### 7.3 - gcloud

```bash
brew install --cask gcloud-cli
```

Puis **ouvrir une nouvelle fenêtre de terminal**, sinon `gcloud` est introuvable :

```bash
gcloud --version
```

### 7.4 - Connexion

```bash
gcloud auth login
```

Le navigateur s'ouvre : se connecter avec le compte Google Valiuz. **Tu ne peux pas le
faire à la place de l'utilisateur.** La session expire : `Reauthentication failed`
signifie qu'il faut relancer cette commande.

### 7.5 - Lire les logs de l'application

Le wiki donne la commande sans filtre. **Mesuré sur nos applications avec base de
données :** elle est noyée par les messages de la base. Le champ qui sépare est
`resource.labels.container_name` : `app` pour l'application, `postgres` pour la base.
Pour une application sans base, le filtre est inoffensif.

Le projet est `valiuz-prd-vil` (wiki, page `First-steps`, et confirmé le 12/10/2026 dans le
`README.md` d'une application existante, dans le lien du bouton « Logs », partie
`project=...`). Le wiki dit que ce lien n'est que dans le commentaire de fermeture de la
demande : c'est inexact pour cette application, le lien est aussi dans le `README.md`.
Le lire dans l'un des deux, le montrer à l'utilisateur, et si le projet diffère de
`valiuz-prd-vil`, c'est le lien qui fait foi.

```bash
gcloud logging read 'resource.labels.container_name="app"' --project=valiuz-prd-vil --bucket=_Default --location=global --view=<nom> --freshness=1h --limit=50 --format="value(timestamp,severity,jsonPayload.msg,textPayload)"
```

Aucune ligne ne veut pas dire erreur : si personne n'a utilisé l'application dans la
période, il n'y a rien à lire. Élargir `--freshness` (`24h`). Les logs sont gardés 30
jours. On ne peut lire que **sa propre** application.

**Savoir si la nouvelle version tourne vraiment** (après `ci: deploy`) : le premier
message de démarrage de la nouvelle version donne l'heure réelle de la bascule. Le nom de
l'instance qui fait tourner l'application (champ `resource.labels.pod_name`) change à
chaque version : s'il est différent de l'ancien, c'est bien la nouvelle.

Si les logs sont vides et que l'application semble morte, elle s'est probablement
arrêtée avant d'écrire : vérifier le `CMD` du `Dockerfile` en premier.

---

## Limites connues de ce skill

- Trois applications l'ont éprouvé, déployées par le concepteur, puis une quatrième par un
  collègue non développeur (Guillaume, 19/10/2026) jusqu'au premier lien. **La partie C
  (migration) n'a jamais été exécutée.** Noter chaque hésitation de la personne, avec l'étape
  et la phrase exacte qui a bloqué.
- **Retours de Guillaume (19/10/2026), déjà intégrés :** `ls ~/.ssh/*.pub` échoue dans zsh sans clé ;
  invites de `ssh-keygen` obscures ; texte du Join Village trop vague ; trop de détails techniques
  (Dockerfile, alpine) ; tests locaux demandés sans raison ; trop de texte et de « non connecté »
  après le succès ; objectif réel = migrer un Apps Script. Axe de progrès majeur selon Jonas :
  **concision et enchaînement plus rapide**.
- **Premier retour réel (12/10/2026) :** une collègue a suivi des prompts tirés de ce skill sur
  une application créée le 05/10 (Node.js). Constats : sa clé SSH était refusée (`Permission
  denied`), son agent était en mode lecture seule et a refusé le `git pull`, et elle a conclu
  « adresse Google absente » sur une copie en retard. D'où le cas « application déjà créée » et
  la règle « `git pull` avant de conclure ». **Pas encore vérifié :** que le dépôt de cette
  application contienne bien la variable après un `pull`.
- **Mode lecture seule :** si l'agent de l'utilisateur ne peut pas lancer de commande (agent
  « plan »), le dire et demander à l'utilisateur de passer à l'agent « build » : la documentation
  d'OpenCode indique que la touche Tab fait défiler les agents principaux. À défaut, il copie
  lui-même les commandes dans son Terminal, une par une.
- Phase 2.0 (Join Village) : l'interview n'a pas encore été vue en usage réel, ni l'approbation
  par l'équipe Village. Ajout d'un collaborateur : jamais exécuté avec ce skill.
- Cas « aucune clé SSH » : exécuté une fois (19/10/2026), les invites de `ssh-keygen` sont
  maintenant annoncées.
- Le squelette de 3.1b : déployé chez Guillaume le 19/10/2026.
- Le wiki est protégé par une connexion Google dans le navigateur, mais lisible par
  `git clone` en SSH une fois la clé en place : c'est ce que fait la phase 1.6.
- Les libellés des pages Gitea sont décrits de mémoire : ils peuvent différer.
- Python est le seul langage éprouvé par ce skill de bout en bout. Node.js : une lecture de Sheets prouvée sur une application reprise, jamais un parcours complet. Go : non testé.
- Docker n'est pas nécessaire au déploiement, donc le `Dockerfile` n'est pas testable en
  local. Le wiki propose `docker build` : ne pas l'imposer.

## À améliorer au fil des essais

Quand un cas imprévu apparaît (nouvelle erreur, libellé différent, étape manquante),
l'ajouter à la phase concernée avec la date, plutôt que de l'improviser une fois de plus.
