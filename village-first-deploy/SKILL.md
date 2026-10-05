---
name: village-first-deploy
description: Use when someone (typically non-technical) wants to put their first application on the Valiuz "Village" (gitea-village.valiuz.io), or is blocked partway through - SSH key, access to Gitea, creating a vibeapp, Dockerfile, first deploy, a red build, adding colleagues, or reading logs. Walks through access, creation, build, deploy and collaborators one step at a time, skipping what is already done. Provides a minimal starter application (a "Bonjour" page) for people who have no code yet.
---

# Village - premier déploiement

Tu guides quelqu'un qui n'est pas forcément technique pour déployer sa première
application sur le Village (plateforme interne Valiuz). Objectif final : son
application répond sur `https://<nom>.valiuz.ai/`, accessible seulement aux
personnes autorisées.

> **Statut : version provisoire du 02/10/2026, éprouvée par une seule personne**
> (le concepteur du skill, sur deux applications Python : l'une avec base de
> données, l'autre sans). **Aucune autre personne ne l'a encore parcouru.**
> Chaque phase indique si elle a été testée. Quand tu rencontres un cas non
> prévu, note-le et propose à l'utilisateur de l'ajouter ici.
>
> **Informations datées** : les mesures marquées « au 02/10/2026 » (délais,
> état de la plateforme) peuvent être périmées. Avant de les affirmer à
> l'utilisateur, vérifie-les (wiki, historique du dépôt) ou dis qu'elles datent.

Source de vérité sur la plateforme : le wiki Village
(`git@gitea-village.valiuz.io:village/.profile.wiki.git`, lisible en SSH une fois
l'accès en place). Pour tout ce qui n'est pas dans ce skill, **lis le wiki au lieu
de deviner**. Le wiki est en anglais.

---

## RÈGLES ABSOLUES

- **Une commande à la fois.** Attendre la confirmation avant la suivante.
  Quand tu donnes une commande à copier, mets-la **seule dans son bloc de code**.
  Deux commandes sur la même ligne se collent en une commande qui n'existe pas
  (cela s'est produit : `gcloud-cligcloud`).
- **Dire où cliquer.** Pour toute action dans le navigateur : l'adresse exacte,
  puis chaque clic, un par un. Ne jamais écrire « va dans les paramètres » sans
  dire lesquels. Tu ne vois pas l'écran de l'utilisateur : décris les libellés
  comme *probables* et demande ce qu'il voit en cas de doute.
- **Une phrase pour dire pourquoi**, pas plus.
- **Vérifier avant de dire « c'est fait ».** Un succès se prouve par une commande
  qui répond, pas par le fait d'avoir lancé l'étape.
- **Ne jamais deviner une cause d'erreur.** Demander le message exact. Les
  journaux de build ne sont lisibles qu'avec la session Gitea de l'utilisateur :
  tu ne peux pas les lire, il doit copier l'étape en rouge et ses dernières lignes.
- **Ne jamais contourner un scan de sécurité**, ne rien cacher dans le
  `Dockerfile` pour le faire taire. Un build bloqué se traite avec l'équipe
  cybersécurité.
- **Ne jamais pousser (`git push`) sans accord explicite.** Un push lance un build
  visible par la plateforme.
- **Aucun secret** dans un fichier du dépôt (mot de passe, jeton, clé API). La
  clé SSH privée ne s'affiche jamais, ne se copie jamais.
- **Ne jamais toucher** au bloc généré de `vibeapp.yaml` (au-dessus de la ligne
  « GENERATED ») ni au `README.md`, que la plateforme réécrit.
- **Demander l'accord avant de modifier un fichier personnel** (`~/.zprofile`,
  `~/.ssh/config`).

Prérequis à confirmer d'emblée : **VPN d'entreprise (Zscaler) connecté**. Sans lui,
Gitea est injoignable et toutes les commandes expirent.

---

## PHASE 0 - Diagnostic (ne rien refaire)

*Non testée telle quelle ; chaque commande a été exécutée séparément avec succès.*

Avant de poser la moindre question, lis l'état, en lecture seule :

```bash
git --version
```

```bash
ls ~/.ssh/*.pub
```

```bash
ssh -T git@gitea-village.valiuz.io
```

Le nom de la clé n'a pas d'importance : c'est `ssh -T` qui dit si l'accès marche.
Interprétation du dernier test :

| Réponse | Sens | Suite |
|---|---|---|
| `successfully authenticated` | Accès SSH en place | Passer à la phase 2 |
| `Permission denied (publickey)` | Gitea ne connaît pas la clé | Phase 1, étape 1.4 |
| `Connection timed out` ou `reset by peer` | VPN absent | Demander de connecter Zscaler, retester |
| `Host key verification failed` | L'empreinte du serveur a changé | **Stop** : ne rien accepter, demander sur `#ask-village` |

Annonce à l'utilisateur ce qui est déjà fait et ce qui reste, en une courte liste.

---

## PHASE 1 - Accès

*Testée sur un cas (hors passphrase). Les pièges ci-dessous sont réels.*

### 1.1 - git installé et identifié

Si `git --version` répond, c'est bon : les outils de ligne de commande Apple
sont déjà là, **il n'y a rien d'autre à installer pour déployer**.
Si la commande propose d'installer les outils : accepter, attendre, relancer.

Identité de commit, pour ce dépôt seulement (demander nom et e-mail Valiuz) :

```bash
git config --global user.name "Prénom Nom"
```

```bash
git config --global user.email "prenom.nom@valiuz.com"
```

### 1.2 - Créer la clé SSH

Pourquoi : une clé remplace le mot de passe pour parler au Village.
Choix retenu : **avec mot de passe** (recommandation du wiki). Ce mot de passe se
saisit dans le terminal de l'utilisateur : tu ne le vois jamais et tu ne le
demandes jamais dans la conversation.

Vérifier d'abord si une clé existe déjà, **quel que soit son nom** (elle peut
s'appeler autrement que `id_ed25519`, par exemple `id_ed25519_gitea_village`) :

```bash
ls ~/.ssh/*.pub
```

Si `ssh -T` a répondu `successfully authenticated` en phase 0, une clé est déjà
enregistrée et fonctionne : **ne pas en créer une autre**, passer à la phase 2.
Si une clé existe mais n'est pas encore dans Gitea : la **réutiliser** (1.3, en
remplaçant le nom du fichier). Ne jamais écraser une clé existante. Sinon, en créer
une :

```bash
ssh-keygen -t ed25519 -C "prenom.nom@valiuz.com"
```

Dire : accepter le nom de fichier proposé (Entrée), puis choisir un mot de passe
et le noter dans un gestionnaire de mots de passe.

Mémoriser le mot de passe dans le trousseau macOS, pour ne pas le retaper.
*L'option est acceptée par macOS (testé) ; que le mot de passe soit réellement
retenu entre deux sessions n'a pas été vérifié : si SSH le redemande à chaque
fois, c'est ce point qui est en cause.*

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Si la clé porte un autre nom, ou si ce n'est pas la clé par défaut, il faut aussi
dire à SSH laquelle utiliser pour le Village. **Demander l'accord** puis ajouter à
`~/.ssh/config` :

```
Host gitea-village.valiuz.io
  User git
  IdentityFile ~/.ssh/<nom-de-la-cle>
  IdentitiesOnly yes
```

### 1.3 - Copier la clé publique

La clé **publique** (`.pub`) est la seule qui se partage.

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Dire : « Rien ne s'affiche, c'est normal : la clé est dans ton presse-papier. »

### 1.4 - L'ajouter dans Gitea

Se connecter d'abord à `https://gitea-village.valiuz.io` avec le compte Google
Valiuz (bouton « Sign in with Valiuz Google SSO »). **C'est ce qui crée le compte.**

Puis ouvrir directement : `https://gitea-village.valiuz.io/user/settings/keys`

1. Cliquer sur **Add Key**.
2. **Key name** : un nom qui dit quelle machine (ex. `macbook-prenom`).
3. **Content** : coller (Cmd+V) la clé. Elle tient sur **une seule ligne** et
   commence par `ssh-ed25519`.
4. Valider.

**Piège constaté :** la page peut se rafraîchir, la liste rester vide, sans aucun
message d'erreur - la clé n'est alors pas enregistrée. Cause non établie.
Réessayer par le lien direct ci-dessus. Pour savoir si l'ajout a marché sans se
fier à l'affichage, retester `ssh -T` (phase 0).

### 1.5 - Vérifier l'empreinte du serveur

À la **première** connexion, SSH demande de faire confiance au serveur. **Comparer
l'empreinte affichée à celle du wiki** (page « Your SSH key ») avant de répondre
`yes`. Ne jamais l'accepter automatiquement. Si elle diffère : stop,
`#ask-village`.

Empreinte publiée par le wiki, **vérifiée le 02/10/2026** (identique à celle
enregistrée sur le Mac du concepteur) :

```
ED25519 SHA256:tJkcls889NFj0a1XjJBzJTXTEjOQI6cGFAewxcjeiZA
```

Une empreinte est publique par nature : la donner ici ne révèle rien. Mais elle
peut changer un jour : **relire la page du wiki** si celle de l'utilisateur
diffère, et ne conclure à un problème qu'après cette relecture.

**Cloner toujours en SSH** (adresse qui commence par `git@`). Le wiki prévoit de
couper l'accès par HTTPS (« SSH is the way that will last »). Et en HTTPS, le mot de
passe Google **ne fonctionne pas** : le compte Gitea est créé via Google et n'a pas de
mot de passe propre. Si git demande un mot de passe, c'est qu'une adresse
`https://` a été utilisée : arrêter, reprendre l'adresse SSH. Ne pas proposer de
jeton personnel ni l'outil `tea`.

Erreurs de cette phase, en plus du tableau de la phase 0 :

| Message | Sens | Quoi faire |
|---|---|---|
| `Load key ...: Is a directory` | Un dossier porte le nom d'une clé dans `~/.ssh` | Inoffensif si les lignes suivantes réussissent. Sinon, demander avant de supprimer quoi que ce soit |
| La phrase de passe est redemandée à chaque fois | La clé n'est pas dans l'agent SSH | `ssh-add --apple-use-keychain ~/.ssh/<nom-de-la-cle>` (voir 1.2) |

Succès attendu :

```
Hi there, <prénom>! You've successfully authenticated with the key named <nom>, but Gitea does not provide shell access.
```

« Does not provide shell access » est **normal** : c'est la réussite.

---

## PHASE 2 - Créer l'application

*Testée une fois, avec une vraie application. Ne pas rejouer pour « essayer » :
chaque essai crée de vraies ressources (dépôt, adresse, base) que seule l'équipe
plateforme peut supprimer.*

**Piège majeur :** créer un dépôt à la main dans Gitea, même avec
`vibeapp-template` comme modèle, **ne crée pas une application**. Il ressemble à
une application mais n'est jamais déployé : pas d'adresse, pas de
`vibeapp.yaml`, pas de pipeline. La seule voie est l'issue « New vibeapp ».

C'est **l'utilisateur** qui l'ouvre : c'est lui le propriétaire de l'application,
et tu n'as pas accès en écriture à cet endroit.

1. Ouvrir `https://gitea-village.valiuz.io/village/.profile/issues/new/choose`
2. Choisir le modèle **New vibeapp**.
3. Répondre aux quatre questions :
   - **Nom** : minuscules, chiffres, tirets, **16 caractères maximum**. Il devient
     le nom du dépôt **et** l'adresse `<nom>.valiuz.ai`.
   - **Stockage de fichiers** : Non, sauf besoin réel (modifiable plus tard).
   - **Base de données** : Non, sauf besoin réel. **Vérifier ensuite dans
     `vibeapp.yaml`** que le résultat correspond : une base a été activée une fois
     alors que la réponse attendue était « non ».
   - **Collaborateurs** : laisser vide au départ.
4. Valider, attendre **1 à 2 minutes**, recharger. Un robot ferme la demande avec
   un commentaire.
5. **Garder ce commentaire** : le lien vers les logs n'y apparaît qu'une fois.

Contrôler côté terminal que le dépôt existe (lecture seule) :

```bash
git ls-remote git@gitea-village.valiuz.io:village/<nom>.git
```

Une liste de hashs = succès. `Repository not found` = l'utilisateur n'est pas sur
la liste de l'application.

---

## PHASE 3 - Construire

*Testée sur deux cas Python. Node.js et Go non testés : lire « Choosing your
language » dans le wiki avant de les proposer.*

### 3.1 - Cloner

```bash
git clone git@gitea-village.valiuz.io:village/<nom>.git ~/Projects/<nom>
```

Ne **pas** réutiliser un dossier existant du même nom : le renommer en sauvegarde
d'abord.

### 3.1b - Pas d'application sous la main ?

*Le squelette ci-dessous a été testé sur un Mac (la page et les deux sondes
répondent 200). Son déploiement sur le Village n'a pas été rejoué : le même
principe, avec les mêmes cinq lignes de `Dockerfile`, a déployé une autre
application le 02/10/2026.*

Si la personne n'a pas encore de code, ne pas la laisser devant un `Dockerfile`
vide. Lui proposer ce squelette : une page « Bonjour » qui respecte les trois
règles de la plateforme (voir 3.2). Une fois le dépôt cloné (3.1), créer le fichier
`main.py` dans le dossier cloné, avec exactement ce contenu :

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

Il n'utilise que la bibliothèque standard de Python : **pas de `requirements.txt`**,
donc le `Dockerfile` de 3.3 se passe des deux lignes de dépendances (voir la variante
sans dépendance). Le texte de la page se change dans la variable `PAGE`.

### 3.2 - Le contrat de la plateforme (trois règles)

Toute application doit :
1. écouter sur `0.0.0.0` et sur le port de la variable `PORT` (défaut `8080`) ;
2. répondre **200** sur `/healthz` **et** `/readyz`, sinon la plateforme la
   redémarre en boucle sans rien dire ;
3. écrire ses logs sur la sortie standard (le disque est en lecture seule, sauf
   `/tmp`).

### 3.3 - Le Dockerfile : quatre pièces qui doivent correspondre

Le `Dockerfile` fourni a **toutes ses lignes commentées** et ne construit pas tel
quel. Il faut activer, pour **un seul** langage : le `FROM`, l'étape des
dépendances, `COPY . .`, et le `CMD`. Oublier le `CMD` est l'erreur la plus
coûteuse : le build réussit puis le conteneur s'arrête aussitôt, sans message.

Python (seul cas testé) :

```dockerfile
FROM gitea-village.valiuz.io/village/python:3.14.7-alpine3.24
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["python", "-u", "main.py"]
```

Variante **sans dépendance** (le squelette de 3.1b, ou toute application qui n'utilise
que la bibliothèque standard) : les deux lignes `COPY requirements.txt .` et
`RUN pip install ...` n'ont pas lieu d'être, et un fichier `requirements.txt` absent
ferait échouer le `COPY`. Cinq lignes actives suffisent (déployé le 02/10/2026) :

```dockerfile
FROM gitea-village.valiuz.io/village/python:3.14.7-alpine3.24
WORKDIR /app
COPY . .
EXPOSE 8080
CMD ["python", "-u", "main.py"]
```

Le `Dockerfile` fourni par la plateforme contient déjà ces lignes **en commentaire** :
il suffit de retirer le `# ` devant celles-ci et de laisser les autres commentées.
Ne pas toucher aux lignes de l'autre langage.

Les tags d'images disponibles changent : **lire la liste à jour** dans le wiki
(page « Base images ») avant de figer un tag, et ne jamais écrire `latest`.
Ne jamais tirer une image de Docker Hub : le build n'y a pas accès.

### 3.4 - Tester sans Docker

L'utilisateur n'a en général pas Docker, et ce n'est pas nécessaire pour déployer.
Vérifier d'abord que Python est présent :

```bash
python3 --version
```

Si macOS propose d'installer des outils de développement : accepter, attendre la fin,
relancer. Sinon, lancer le serveur **dans le dossier de l'application** :

```bash
PORT=8097 python3 -u main.py
```

Ouvrir `http://127.0.0.1:8097/`, puis `/healthz` et `/readyz` dans le navigateur : les
trois pages doivent répondre (la première affiche « Bonjour », les deux autres « ok »).
Arrêter le serveur avec Ctrl+C.
Limite à dire : le `Dockerfile` ne sera validé qu'au premier build sur le Village,
et une base de données n'est pas joignable depuis le poste.

---

## PHASE 4 - Déployer

*Testée.*

1. Montrer à l'utilisateur ce qui va partir (`git status`, `git diff --stat`),
   puis **demander son accord** pour pousser.
2. Messages de commit au format *Conventional Commits* (`feat:`, `fix:`, `chore:`,
   `docs:`).
3. Pousser sur `main` : seul `main` déploie.

### Si le push est refusé (`rejected`, `fetch first`)

*Rencontré le 02/10/2026, résolu sans conflit.*

Ce n'est pas une erreur grave. Après chaque build, le robot de la plateforme écrit
dans l'historique (`ci: deploy ...`) : la copie locale est donc en retard sur le
dépôt. Dire à l'utilisateur de lancer ces deux commandes, **une à la fois** :

```bash
git pull --rebase origin main
```

```bash
git push origin main
```

Si `git pull` signale un **conflit**, s'arrêter et demander le message exact : ne
rien résoudre à sa place. Cela ne devrait pas arriver tant que le robot est le seul
à écrire entre-temps.

### Suivre le build sans accès à Gitea

Le robot écrit dans l'historique du dépôt. Attendre 1 à 2 minutes, puis :

```bash
git fetch
```

```bash
git log origin/main --format='%h | %an | %s' -5
```

| Message du robot | Sens |
|---|---|
| `ci: build passing` puis `ci: deploy <id>` | Déployé |
| `ci: build failing` | Échec : voir ci-dessous |

Le badge « Deploy » du README peut rester vert pendant un échec : il indique que
la **version précédente** tourne encore. Un build raté ne déploie rien et n'envoie
aucun message.

### Après `ci: deploy` : attendre, ne pas conclure à un échec

`ci: deploy <id>` dans l'historique veut dire « l'image est prête », **pas**
« l'application répond ». L'adresse affiche encore la **page d'attente de la
plateforme** (« Deployed by Village ») : c'est normal, ce n'est pas une erreur.

**Mesure au 02/10/2026 (à revérifier, la plateforme évolue) :** entre `ci: deploy` et
la première réponse de la nouvelle version, **2 à 7 minutes** (trois déploiements :
~7, ~2 et ~2 minutes). Le wiki annonce « une à deux minutes » : c'est plus court que
ce qui a été mesuré la première fois.

Dire à l'utilisateur d'attendre **5 minutes**, puis de recharger la page. Si la page
d'attente est toujours là après **10 minutes**, ne pas deviner : demander ce qu'il voit
et passer à la lecture des logs (phase 7, qui est la seule façon de voir le démarrage
réel de l'application).

### Si le build échoue

Demander à l'utilisateur d'ouvrir `https://gitea-village.valiuz.io/village/<nom>/actions`,
de cliquer sur le run le plus récent (le titre est celui du commit), puis sur
l'étape marquée d'une croix rouge, et de **copier son nom et ses dernières
lignes**. Les étapes s'exécutent dans l'ordre et chacune ne tourne que si la
précédente a réussi : la dernière étape exécutée désigne la coupable.

| Étape en rouge | Sens |
|---|---|
| `Wiz scan (secrets…)` | Un identifiant détecté dans le code. Le retirer ; s'il a été poussé, il est considéré comme exposé : **prévenir la cybersécurité** |
| `Build image` | Erreur de `Dockerfile` ou de dépendances : lire l'erreur Docker |
| `Wiz scan (image…)` | Vulnérabilité dans l'image : voir ci-dessous |
| `Push image` | Infrastructure : `#ask-village` |

**Cas rencontré :** `Wiz scan (image…)` en échec (`FAILED_BY_POLICY`) pour une
vulnérabilité critique **dans l'image de base**, pas dans le code. Le tableau du
journal indique le CVE, sa gravité et la version corrigée. Ce n'est pas
contournable par l'utilisateur : contacter la cybersécurité en donnant
l'application, le commit, le CVE et la question « une image corrigée est-elle
prévue ? ». Dans ce cas précis, c'est la plateforme qui a ensuite changé sa règle
de blocage et relancé le build elle-même, sans que l'image change.

Une fois « build passing » : ouvrir `https://<nom>.valiuz.ai/`. L'adresse
redirige vers une connexion Google (protection d'accès) : c'est normal.

---

## PHASE 5 - Autoriser d'autres personnes

*Procédure lue dans le wiki et dans le formulaire du dépôt ; non exécutée de bout
en bout.*

**Ce n'est pas un réglage dans Gitea** : Gitea réserve la gestion des équipes aux
propriétaires de l'organisation, donc le bouton n'existe pas pour l'utilisateur.
C'est un formulaire.

Avant tout, **dire clairement** ce que cela implique : chaque personne ajoutée
obtient **les cinq accès à la fois** (modifier le code, lire les logs, lire la
base, ouvrir le stockage, ajouter des secrets). Il n'existe **pas** de rôle « voir
la page seulement ». Ajouter peu de monde, et seulement des personnes qui doivent
tout avoir.

1. Chaque personne doit s'être **connectée une fois** à Gitea (sinon la demande
   échoue).
2. Ouvrir `https://gitea-village.valiuz.io/village/<nom>/issues/new/choose`
3. Choisir **Change who works on an application**.
4. **Adding or removing ?** : `add` (ou `remove`).
5. **Who ?** : les adresses e-mail Valiuz, séparées par des virgules.
6. Valider : un robot traite la demande en une minute et la ferme.

Seul le demandeur de l'application, ou l'équipe plateforme, peut faire cette
demande. Retirer quelqu'un à la main dans Gitea ne marche pas : le robot le remet.
Si le modèle n'apparaît pas : `#ask-village`.

---

## PHASE 6 - Clôture

Résumer en peu de lignes : l'adresse, le dépôt, ce qui a été fait, ce qui reste
(personnes à ajouter, suites), et rappeler :
- les logs sont lisibles dans le navigateur (lien du commentaire de la phase 2) ;
- tout changement poussé sur `main` redéploie ;
- pour lire les logs depuis le terminal, **proposer la phase 7 seulement si besoin**.

### Et ensuite ?

Ne pas recopier le wiki : il évolue. Donner à l'utilisateur le lien de la page qui
correspond à ce qu'il veut faire, en lui disant de la lire avant de se lancer. Tout
est sous `https://gitea-village.valiuz.io/village/.profile/wiki/` (connexion Google
Valiuz requise) :

| Il veut... | Page du wiki |
|---|---|
| Stocker une clé d'API ou un mot de passe | `Secrets` : jamais dans le code ni dans `vibeapp.yaml` |
| Enregistrer des données | `Your database` (PostgreSQL). **Sauvegardes non garanties au 02/10/2026** : à lire avant de s'y fier |
| Enregistrer des fichiers | `Your storage` |
| Atteindre Google Sheets, Drive, Gmail, BigQuery, une autre ressource | `Asking for more access`. **Au 02/10/2026, l'accès aux services Google Workspace n'est pas en place** : il est annoncé pour une prochaine version de la plateforme. Ne pas le promettre, renvoyer vers `#ask-village` |
| Changer la taille, le port, une variable | `vibeapp.yaml` |
| Ajouter des collègues | Phase 5 de ce skill, et `Collaborators` |

---

## PHASE 7 - Lire les logs depuis le terminal (optionnel)

*Homebrew et gcloud sont testés. La lecture filtrée des logs est testée sur un
cas.* **Ne pas imposer cette phase** : le déploiement fonctionne sans, et c'est le
point le plus fragile du parcours pour quelqu'un qui n'a pas encore vu son
application tourner.

### 7.1 - Diagnostic

```bash
command -v brew
```

```bash
command -v gcloud
```

Sauter ce qui répond déjà.

### 7.2 - Homebrew

L'installation demande le mot de passe du Mac (`sudo`) : **c'est l'utilisateur qui
la lance dans son terminal**, tu ne peux pas la faire à sa place. Donner la
commande officielle depuis `https://brew.sh` (ne pas la recopier de mémoire).

**Piège constaté :** à la fin, l'installateur affiche des « Next steps ». Sans eux,
`brew` reste introuvable (`command not found`) bien que l'installation ait réussi.
Vérifier :

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

La commande doit tenir **seule sur sa ligne** :

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

Le navigateur s'ouvre : se connecter avec le compte Google Valiuz. **Tu ne peux pas
le faire à la place de l'utilisateur** (session interactive). La session expire :
`Reauthentication failed` signifie qu'il faut relancer cette commande.

### 7.5 - Lire les logs de l'application

La commande du wiki sans filtre **noie l'information** : la vue contient aussi les
conteneurs de la base de données, qui écrivent presque tout (sauvegarde,
avertissements Python). Le champ qui les sépare est
`resource.labels.container_name` : `app` pour l'application, `postgres` pour la
base.

**Où trouver `<projet>` :** ne pas le deviner. Il figure dans le `README.md` du dépôt
de l'application, dans le lien du bouton « Logs » (la partie `project=...` à la fin de
l'adresse, ou `projects/<projet>/locations/...`). Lire ce fichier et en extraire la
valeur, puis la montrer à l'utilisateur avant de lancer la commande.

```bash
gcloud logging read 'resource.labels.container_name="app"' --project=<projet> --bucket=_Default --location=global --view=<nom> --freshness=1h --limit=50 --format="value(timestamp,severity,jsonPayload.msg,textPayload)"
```

Aucune ligne ne veut pas dire erreur : si personne n'a utilisé l'application dans
la période, il n'y a rien à lire. Élargir `--freshness` (`24h`).
Les sondes de santé apparaissent en texte brut (`"GET /readyz HTTP/1.1" 200`),
d'où `textPayload` dans le format.

Pour savoir si l'application a bien trouvé sa base au démarrage, chercher les
messages de démarrage du serveur plutôt que les requêtes.

**Savoir si la nouvelle version tourne vraiment** (utile après `ci: deploy`, voir
phase 4) : le premier message de démarrage de la nouvelle version indique l'heure
réelle de la bascule. Avec le squelette de 3.1b, c'est le message `démarrage` ; avec
une autre application, le message qu'elle écrit au lancement. Le nom du pod
(`resource.labels.pod_name`) change à chaque nouvelle version : s'il est différent de
l'ancien, c'est bien la nouvelle.

---

## Limites connues de ce skill

- Deux applications l'ont éprouvé, déployées par la même personne (le concepteur).
  Un non-technique ne l'a **pas** encore parcouru : c'est le test qui compte, et il
  reste à faire. Noter chaque hésitation de la personne, avec l'étape et la phrase
  exacte qui a bloqué.
- Le squelette de 3.1b est testé sur un Mac, mais son déploiement sur le Village n'a
  pas été rejoué tel quel.
- Le wiki Village est protégé par une connexion Google : l'agent ne peut pas lire ses
  pages sans une session ouverte. Le wiki est lisible par `git clone` en SSH
  (`git@gitea-village.valiuz.io:village/.profile.wiki.git`) une fois la clé en place.
- La création de clé (1.2) n'a été testée que dans le cas où une clé existait
  déjà ; le cas « aucune clé » n'a pas été exécuté dans ce skill.
- La phase 2 ne peut être rejouée sans créer de vraies ressources.
- Les libellés des pages Gitea sont décrits de mémoire : ils peuvent différer.
- L'ajout d'un collaborateur n'a pas été exécuté de bout en bout.
- Python seulement a été testé comme langage.
- Docker n'est pas nécessaire au déploiement, mais cela signifie que le
  `Dockerfile` n'est pas testable en local.

## À améliorer au fil des essais

Quand un cas imprévu apparaît (nouvelle erreur, libellé différent, étape
manquante), l'ajouter à la phase concernée avec la date, plutôt que de
l'improviser une fois de plus.
