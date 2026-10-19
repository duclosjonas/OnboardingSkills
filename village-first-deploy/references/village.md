# Référence Village

Ce que le Village permet, ne permet pas, et ce qui est prouvé. À lire quand
l'utilisateur pose une question sur la plateforme ou doit décider quelque chose
(nom, base de données, Google, qui peut ouvrir).

**Vérifié le 12/10/2026** contre le wiki (commit `fbaef91`) et le dépôt
`village/.profile` (commit `70fe9d7`). Tout ce qui est daté peut avoir changé.

## Règle d'or : le wiki d'abord

Le wiki fait foi et évolue vite (trois changements de module en une semaine
début octobre). Avant de répondre sur la plateforme, le lire à jour.

Une fois la clé SSH en place (phase 1), cloner une fois dans un dossier fixe :

```bash
git clone git@gitea-village.valiuz.io:village/.profile.wiki.git ~/.village-ref/wiki
```

```bash
git clone git@gitea-village.valiuz.io:village/.profile.git ~/.village-ref/profile
```

Ensuite, avant chaque réponse sur la plateforme, rafraîchir (une commande à la
fois) :

```bash
git -C ~/.village-ref/wiki pull --ff-only
```

```bash
git -C ~/.village-ref/profile pull --ff-only
```

Les fichiers du wiki se nomment avec des tirets : `Vibeapp-scope.md`,
`Google-Workspace.md`, `Secrets.md`. Le wiki est en anglais : traduire en
français, ne jamais citer sans traduire.

Le dossier `~/.village-ref/profile/image-catalog/CATALOG.md` liste les images de
base **réellement disponibles** : s'en servir pour choisir un tag, ne jamais en
figer un de mémoire.

Si le wiki et ce fichier se contredisent : le wiki gagne, et le dire à l'utilisateur.

## Statuts

- **Prouvé** : essayé sur une vraie application, par le concepteur de ce skill.
- **Lu** : écrit dans le wiki ou le code de la plateforme, jamais essayé.
- **Inconnu** : aucune réponse. Ne rien promettre : orienter vers `#ask-village`.

## Ce qu'est une vibeapp

- Un dépôt Git, une adresse `https://<nom>.valiuz.ai/`, et un conteneur
  (une boîte qui fait tourner l'application) redéployé à chaque envoi sur `main`. **Prouvé.**
- Langages : **Python, Node.js, Go uniquement**, sans dérogation. **Lu.** Seul Python est prouvé.
- Protégée par la connexion Google Valiuz. **Prouvé** : l'adresse redirige vers une
  connexion Google. « Jamais publique, jamais accessible hors du réseau Valiuz » est
  ce que dit le wiki : **lu**, non vérifiable par un essai.
- Une seule réplique, taille `small` (la taille ne se choisit pas à la création,
  elle se demande plus tard avec des chiffres d'usage). **Lu.**
- Rien à installer pour **déployer** : Git suffit, ni Docker ni gcloud. **Prouvé.**
  (Tester sur son poste demande Python ; lire les logs au terminal demande gcloud.)

## Avant le formulaire : décisions à prendre

| Question | Piège | Recommandation |
|---|---|---|
| Être « vibecoder » | Seuls les vibecoders peuvent demander une application (formulaire **Join Village**, approuvé par l'équipe du Village) | Le faire en premier, voir phase 2.0 du skill |
| Nom | 16 caractères max, minuscules, chiffres, tirets, commence par une lettre. Il devient l'adresse. Un nom trop long est refusé | Court, choisi une fois |
| Base de données | PostgreSQL privée, **2 GiB, instance unique, sans sauvegarde garantie**. Une base a été activée par erreur une fois : vérifier `vibeapp.yaml` après coup | Non, sauf donnée qui n'existe nulle part ailleurs |
| Stockage de fichiers | Espace privé. Les fichiers ne sont pas accessibles par adresse : l'application doit les relire et les renvoyer elle-même | Non par défaut |
| Google Sheets, Docs, Slides, Drive | Donne à l'application sa propre adresse Google. Sans cette réponse, pas d'adresse | Oui si l'application touche un fichier Google |
| Qui travaille dessus | **Chaque personne obtient tout d'un coup** : code, logs, base, stockage, secrets | Peu de monde |
| Qui peut l'ouvrir | Personnes, **groupes Google**, ou **« Everyone at Valiuz »**. Sans compte Gitea, sans voir le code ni les données | Presque toujours cette liste, pas les contributeurs |

Base de données, stockage : « peuvent être ajoutés plus tard » sur demande à
`#ask-village` (wiki). Retirer une base après coup : **inconnu**.

Une application est **un engagement** : seule la plateforme la supprime. Ne pas
en créer « pour tester ».

## Ce qui est prouvé

| Capacité | Statut |
|---|---|
| Accès SSH, lecture et écriture de dépôts | Prouvé |
| Création par le formulaire « New vibeapp », dépôt et adresse créés | Prouvé |
| Build et déploiement Python avec dépendance PyPI, et sans dépendance | Prouvé |
| Application qui trouve sa base au démarrage | Prouvé |
| L'application reçoit l'identité de la personne connectée (en-tête `x-goog-authenticated-user-email`, en minuscules, plus un jeton signé) | Prouvé |
| **Lecture** d'un Google Sheets partagé à l'adresse de l'application | Prouvé (07/10/2026) |
| Ouvrir à ~300 personnes sans accès au code ni aux données | Lu (formulaire et wiki) |
| **Écriture** dans un Sheets, Slides, Drive | Non prouvé (le wiki dit que c'est possible) |
| Ajout d'un collègue par formulaire | Non exécuté de bout en bout |
| **Node.js : lecture d'un Sheets** (titre et noms d'onglets) | **Prouvé (12/10/2026)** sur une application Node.js 24 d'une collègue, par les trois appels HTTP avec `fetch`, sans bibliothèque, scope `spreadsheets.readonly`. 16 onglets lus, `success: true`. Une seule application |
| Go | Non testé |
| Sauvegarde et restauration de la base | **Non garanties** (le wiki le dit) |

## Ce qui ne marche pas, ou pas encore

Les lignes de ce tableau sont toutes **lues** (wiki ou formulaire) sauf mention contraire :
« ne marche pas » n'est pas un cinquième statut, c'est un constat de la plateforme.

| Sujet | État |
|---|---|
| **Gmail, Calendar** | Non disponibles (politique d'entreprise, pas un délai) |
| **Envoi de mails** | Aucun service. « Sujet à part » côté plateforme, sans échéance. Ne rien promettre |
| **Créer un fichier Google** | L'application n'a pas d'espace Drive (`storageQuotaExceeded`). Créer le fichier soi-même et le partager, ou demander un Drive partagé |
| **Tâche planifiée** | Pas de planificateur natif. Un cron *dans* l'application suffit (une seule réplique), avec trois précautions : rattraper au démarrage une exécution manquée, éviter la double exécution pendant un déploiement, fuseau `Europe/Paris`. **Aucune alerte en cas d'échec** |
| **Supervision, alertes** | Absentes, annoncées pour plus tard |
| **WebSocket** | Coupé après 30 secondes sans message : utiliser les **Server-Sent Events** (page `Live-updates`). Dire à l'assistant de code « utilise Server-Sent Events, pas WebSockets » |
| Application sans base : cron et verrous | Le modèle de cron suppose une base. Sans base, l'état d'exécution doit vivre ailleurs |

## Recette : lire un Sheets depuis une vibeapp (Python sans dépendance, prouvée)

*Prérequis : option Google cochée à la création, et fichier partagé avec l'adresse
de l'application (dans son `README.md` et la variable `GOOGLE_WORKSPACE_SERVICE_ACCOUNT`).*

1. **Jeton de base** : `GET http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token`
   avec l'en-tête `Metadata-Flavor: Google`.
2. **Jeton au nom de l'adresse** : `POST https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/<adresse>:generateAccessToken`,
   en-tête `Authorization: Bearer <jeton de base>`, corps `{"scope": ["https://www.googleapis.com/auth/spreadsheets.readonly"]}`.
3. **Appel de l'API** : `GET https://sheets.googleapis.com/v4/spreadsheets/<id>?fields=properties.title,sheets.properties.title`
   avec le **second** jeton. Il dure environ une heure : le garder en mémoire.

À savoir :
- Le jeton de base seul est refusé par Sheets (401). L'étape 2 est obligatoire.
- Un `403` juste après un changement de partage : attendre ~2 minutes.
- **Aucun fichier de clé, jamais.** Le wiki dit de s'arrêter et de demander.
- Le wiki donne une version avec les bibliothèques Google (page `Google-Workspace`) :
  elle est **lue, non essayée** ; elle suppose d'ajouter ces bibliothèques aux dépendances.
- **Node.js : lecture prouvée (12/10/2026)** avec les trois mêmes appels HTTP écrits avec `fetch`
  (Node 24), sans bibliothèque ni nouvelle dépendance. Prouvé sur une seule application ; l'écriture
  reste non prouvée. La version du wiki avec `google-auth-library` n'a pas été essayée.
- **Un test local ne peut pas réussir** : le serveur de jetons (`metadata.google.internal`)
  n'existe que dans le Village. En local, on ne vérifie que le démarrage du serveur.

## Reprendre une application déjà créée (avant le 07/10/2026)

*Cas de la première collègue qui a suivi nos prompts : application créée le 05/10, avant la
mise à jour Google. Lu dans `village/.profile` ; **le dépôt de cette application n'a pas pu être
lu**, donc ce qui suit sur son contenu est une hypothèse.*

Ce que la plateforme a fait le 07/10 (commit `dfae76b` de `.profile`, module 8.5.0) :
`google_workspace = true` ajouté à **toutes** les applications existantes (8 sur 8 vérifiées).
Sur une application où le robot est passé, il écrit aussi la variable
`GOOGLE_WORKSPACE_SERVICE_ACCOUNT` dans le `vibeapp.yaml` du dépôt (constaté sur une application
du concepteur de ce skill : commit du robot `chore: GOOGLE_WORKSPACE_SERVICE_ACCOUNT ...`, le
07/10 à 17:06). **Constaté sur une seule application** : rien ne dit que c'est automatique pour
toutes.

**Conséquence : une copie locale qui n'a pas été mise à jour depuis le 06/10 n'a ni la variable
ni la section « Your application has its own Google address » du `README.md`.** Elle ne montre
alors que l'identité technique `principal://...` (qui ne se partage pas dans Google Sheets) et la
phrase « there is no service account to name ».

Règles pour l'agent :
1. **Ne jamais conclure qu'une adresse Google est absente avant `git pull --rebase origin main`.**
   Si `git fetch` répond `Permission denied (publickey)`, l'accès SSH est à réparer d'abord
   (phase 1 du skill) : sans accès, aucune information du dépôt n'est à jour.
2. **Ne rien poster sur `#ask-village` avant ce `pull`.** La question valable est : « après un
   `git pull` du <date>, mon dépôt ne contient pas la variable ; `.profile` montre
   `google_workspace = true` pour `<nom>` ».
3. **Une identité `principal://...` n'est pas une adresse de partage.** L'adresse de partage se
   termine par `iam.gserviceaccount.com` et ressemble à `wli-ws-<nom>-<suffixe>@<projet>`.
4. Un dépôt peut avoir été créé avec `language = "python"` dans l'infrastructure alors qu'il est
   en Node.js : le générateur écrit cette valeur en dur. Je n'ai rien lu qui dise qu'elle a un
   effet ; à poser sur `#ask-village` seulement si un comportement l'exige.
5. **Relire `AGENTS-PERSO.md` après le `pull`.** Le 07/10, le robot a remplacé `AGENTS.md` (qui
   appartient désormais à la plateforme) et recopié l'ancien contenu **tel quel** dans
   `AGENTS-PERSO.md`, sans rien perdre (constaté sur deux applications). Mais les consignes
   devenues fausses y restent : par exemple une procédure « fichier de clé, mode réel » qui
   contredit le wiki, ou une authentification maison remplacée depuis par la protection d'accès
   du Village. Avant de laisser un agent suivre ce fichier, **lui faire lister ce qui est
   obsolète**, puis corriger avec l'accord de l'utilisateur. `AGENTS-PERSO.md` est le bon endroit
   pour les règles de l'utilisateur : elles y survivent d'une session à l'autre, contrairement à un
   prompt collé dans le chat.
6. **Lecture seule : le scope `spreadsheets.readonly` est accepté** (prouvé en Python sur
   `calendrier-edito`), même si le tableau du wiki ne cite que `spreadsheets`, qui donne aussi
   l'écriture. Pour lire, toujours le plus étroit.

Ce qu'on trouve souvent dans une application reprise, à vérifier **avant** de brancher quoi que
ce soit, un point à la fois :
- **`/healthz` et `/readyz` absents** : la plateforme redémarre l'application en boucle. À
  corriger en premier (voir `details.md`).
- **Un fichier de clé** (`keyFile`, `GOOGLE_APPLICATION_CREDENTIALS`, `SERVICE_ACCOUNT_KEY_PATH`) :
  interdit sur le Village. Le remplacer par l'identité de l'application, **après** avoir prouvé
  la lecture avec une route de test.
- **Un mode « mock »** (données fictives) actif en production : le conserver tant que la lecture
  réelle n'est pas prouvée, et ne le changer qu'avec l'accord de l'utilisateur.

## Si l'application doit écrire dans le Sheets

*Cas relevé le 12/10/2026 sur une application reprise : 29 écritures dans le code. L'écriture est
affirmée par le wiki mais **n'a jamais été prouvée** : la première application qui l'essaie sert
de preuve. Le dire à l'utilisateur.*

**Avant tout, compter** : demander à l'agent de lister chaque appel Google en deux colonnes,
LECTURE ou ÉCRITURE, avec l'onglet concerné. Ne pas supposer « lecture seule » : une application
qui enregistre des saisies a besoin d'écrire, et en lecture seule chaque enregistrement échouerait.

- **Portées** : lecture `spreadsheets.readonly` (prouvé), écriture `spreadsheets` (non prouvé).
  Partage **Lecteur** pour lire, **Éditeur** pour écrire. Ne passer en Éditeur qu'au moment du
  test d'écriture.
- **Partager en Éditeur ne fait rien écrire tout seul** : seul le code écrit. Un mode « mock »
  (données fictives) coupe l'écriture tant qu'on ne le change pas.
- **Premier test d'écriture** : un onglet vide créé à la main (nom clair, par exemple
  `_TEST_VILLAGE`), **une seule cellule**, jamais un onglet de données. Supprimer l'onglet après.
- **Ne jamais appeler en production** une fonction qui vide un onglet puis le réécrit : elle n'est
  pas atomique, un échec entre les deux laisse l'onglet vide. Le seul filet est l'historique des
  versions de Google Sheets.
- **Deux applications sur le même fichier** (l'ancienne et la nouvelle) écrivent en parallèle :
  le verrou de la nouvelle ne protège pas contre l'ancienne. À trancher avant de basculer.
- Si l'utilisateur refuse de copier le fichier (« ça doit rester la prod »), respecter ce choix et
  appliquer les garde-fous ci-dessus au lieu d'insister.

## Pièges qui ont coûté du temps

1. **Créer un dépôt à la main dans Gitea ne crée pas une application.** Seule voie :
   le formulaire « New vibeapp ».
2. **Un build qui échoue est silencieux.** L'ancienne version continue de tourner,
   le badge reste vert. Le wiki le dit. Seul signe sans accès à Gitea :
   `ci: build failing` dans l'historique du dépôt.
3. **`ci: deploy` ne veut pas dire que ça répond.** Compter 2 à 7 minutes (mesuré,
   le wiki annonce 1 à 2). Une page d'attente « Deployed by Village » est servie entre-temps.
4. **Le push peut être refusé** : le robot écrit dans l'historique après chaque build.
   `git pull --rebase origin main`, puis `git push origin main`.
5. **Un build bloqué par l'analyse de sécurité** se traite avec la cybersécurité, jamais
   en contournant. Le plus souvent, la cause est dans l'image de base, pas dans le code.
6. **`Dockerfile` : oublier le `CMD`** est l'erreur la plus coûteuse. Le build réussit,
   puis le conteneur s'arrête aussitôt, sans message.
7. **`AGENTS.md` appartient à la plateforme** : un push qui le modifie est refusé.
   Les consignes de l'utilisateur vont dans `AGENTS-PERSO.md`.
8. **Ne jamais faire `git init` puis fusionner** dans le dépôt cloné : les fichiers
   de la plateforme sont perdus. Toujours travailler depuis le clone.
9. **Ne pas construire de page de connexion.** La plateforme garde la porte ;
   l'application décide seulement de ce que chacun voit à l'intérieur.
10. **Ne jamais décider d'un droit avec l'en-tête e-mail seul** : utiliser une
    identité dont le jeton est vérifié.
11. **Un test local ne démarre pas toujours le serveur.** Tester que l'application
    démarre vraiment avant de pousser : un plantage au démarrage laisse l'ancienne
    version en ligne, sans message.
12. **Le formulaire annonce `<nom>.valiuz.io`** mais l'adresse réelle est `.valiuz.ai`.
13. **Le VPN (Zscaler) doit être connecté** : sinon tout expire, sans message utile.
14. **Le wiki a des incohérences** (délais, messages d'erreur) : se fier aux mesures
    de ce fichier, et le dire.

## Secrets

Une clé d'API, un mot de passe : **jamais dans le code ni dans `vibeapp.yaml`**.
Ils vont dans Secret Manager, lien dans le `README.md` du dépôt. Règles (page `Secrets`) :
- Les clés s'écrivent `MAJUSCULES_AVEC_TIRETS_BAS` : elles deviennent des variables
  d'environnement telles quelles.
- **Écrire le JSON complet à chaque fois** : une nouvelle version remplace la précédente.
- Une valeur écrite ne se relit plus, par personne. La garder ailleurs.
- Ne pas toucher à `VIBEAPP_SECRETS_READY`.
- Un nom défini dans `vibeapp.yaml` écrase le même nom dans les secrets.

Le détail (3 versions gardées, 7 jours de récupération, contributeur qui peut tout écraser, délai
de prise en compte) est dans `details.md`.

## Où regarder, selon le besoin

Tout est sous `~/.village-ref/wiki/` (ou `https://gitea-village.valiuz.io/village/.profile/wiki/`,
connexion Google Valiuz).

| Il veut... | Page |
|---|---|
| Installer son poste | `First-steps`, `Your-SSH-key` |
| Créer une application | `Creating-a-vibeapp`, `Vibeapp-scope` |
| Choisir un langage et une image | `Choosing-your-language`, `Base-images` + `CATALOG.md` |
| Comprendre pourquoi rien ne change | `How-deployment-works`, `Security-scans` |
| Les trois règles de l'application | `The-platform-contract` |
| Changer taille, port, variable | `vibeapp-yaml` |
| Une clé d'API | `Secrets` |
| Lire les logs | `Logs` (dans le navigateur) |
| Base, fichiers | `Your-database`, `Your-storage` |
| Mise à jour en direct d'une page | `Live-updates` |
| Google Sheets, Docs, Slides, Drive | `Google-Workspace` |
| BigQuery, autre ressource | `Asking-for-more-access` |
| Ajouter un collègue, ouvrir à d'autres | `Collaborators` |
| Taille réelle, limites, sauvegardes | `Vibeapp-infrastructure` |

**Détails fins** (contrat de l'application, base et pgweb, secrets, scopes Google, droits,
tailles) : `details.md`, **seulement si la question le demande**.

## Si l'utilisateur est bloqué

`#ask-village` sur Slack. Donner : le nom de l'application, ce qu'il a fait, le
message exact.
