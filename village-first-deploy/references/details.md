# Détails fins du Village

À lire **seulement si la question de l'utilisateur le demande**. L'essentiel est dans
`village.md`. Tout ici vient du wiki ou du code de la plateforme, vérifié le 12/10/2026
(wiki `fbaef91`, dépôt `.profile` `70fe9d7`) : statut **lu**, sauf mention contraire.
Si le wiki cloné (`~/.village-ref/wiki`) dit autre chose, le wiki gagne.

## Le contrat de l'application, en détail

- **Écouter sur `0.0.0.0`, pas `127.0.0.1`.** Une application liée à `localhost` est
  injoignable de l'extérieur et ressemble exactement à une application en panne.
- **`/healthz` et `/readyz`.** `/healthz` veut dire « vivante », `/readyz` « prête à servir ».
  La plateforme interroge les deux ; **une route manquante compte comme un échec** et
  l'application est redémarrée en boucle. C'est la première cause d'une application qui ne
  démarre jamais. Elles ne doivent pas être derrière une authentification applicative.
- **Port.** Le changer dans `vibeapp.yaml` (clé `port`) **et** dans le `EXPOSE` du `Dockerfile`,
  puis le lire dans la variable `PORT`.
- **Durcissement automatique, non désactivable** : utilisateur non-root, disque en lecture
  seule (sauf `/tmp`, vidé à chaque redémarrage), aucune capacité Linux. Une erreur
  d'écriture sur le disque vient de là : ne pas chercher à la contourner, utiliser le stockage.
- **Logs.** Un champ `severity` au premier niveau d'un JSON (`"severity": "ERROR"`) colore la
  ligne dans les logs. Le JSON donne des champs filtrables (`jsonPayload.id = 42`). Logs
  gardés **30 jours**. Le lien des logs est dans le commentaire de fermeture de la demande
  (onglet Issues, filtre Closed, demande `[vibeapp]`), et, constaté sur deux applications
  vérifiées, aussi dans le `README.md`.
- **Mise à jour en direct** (progression, réponse mot à mot) : Server-Sent Events, jamais
  WebSocket, qui est coupé après 30 secondes sans message. Un flux dure une heure au plus
  puis le navigateur se reconnecte seul. Page `Live-updates`.

## Base de données (page `Your-database`)

- `DATABASE_URL` est **fournie toute faite**, sans mot de passe. **Ne jamais la définir
  soi-même** dans `env` de `vibeapp.yaml` : la valeur définie gagne et l'application perd sa
  vraie base.
- **pgweb** (`https://pgweb.valiuz.ai/connect/<nom-application>`, connexion avec le compte
  Gitea) permet de lire les tables sans écrire de code. Lecture seule, **imposée par
  PostgreSQL** et non par la page. Réservée à ceux qui peuvent modifier le dépôt. C'est le
  moyen pour un non-développeur de vérifier ce que son application a réellement écrit.
- 2 GiB de données : beaucoup de lignes, aucune place pour des fichiers. Les fichiers vont
  dans le stockage (page `Your-storage`), qui n'est **pas** servi par adresse : l'application
  doit les relire et les renvoyer elle-même.

## Secrets (page `Secrets`)

- Le lien Secret Manager n'est que dans le `README.md` de l'application : **on ne le trouve pas
  en naviguant dans la console Google** (pas le droit de parcourir les secrets du projet).
- Une valeur écrite **ne se relit jamais**, par personne. La noter ailleurs, en lieu sûr.
- **Seules les 3 dernières versions** sont gardées. Les plus anciennes sont désactivées la nuit,
  puis détruites **7 jours après** : pour récupérer une ancienne version, demander sur
  `#ask-village` dans ces 7 jours.
- **Tout contributeur peut ajouter une version.** Comme une version remplace la précédente en
  entier, **un contributeur qui oublie une clé casse les secrets de toute l'application.**
  Raison de plus de n'ajouter que le nécessaire.
- Délai de prise en compte : le wiki dit « dans l'heure », le `README.md` généré dit « 5
  minutes ». Dire « jusqu'à une heure ». Le `README.md` peut aussi encore parler d'un
  redémarrage depuis ArgoCD : à ignorer, plus nécessaire.

## Google Workspace (page `Google-Workspace`)

- Partage : **Lecteur pour lire, Éditeur pour écrire.** Le wiki affirme que l'application peut
  lire **et écrire** ; seule la lecture d'un Sheets est prouvée chez nous.
- Portées (`scopes`) documentées par le wiki : Sheets `spreadsheets`, Docs `documents`, Slides
  `presentations`, Drive en lecture `drive.readonly`, réponses Forms `forms.responses.readonly`,
  tout Drive `drive`. Pour lire seulement : ajouter `.readonly` (Sheets).
- Le wiki donne un code avec les bibliothèques Google (`google-auth` en Python,
  `google-auth-library` en Node). **Lu, jamais essayé chez nous** ; il suppose d'ajouter ces
  bibliothèques aux dépendances. La recette sans dépendance de `village.md` est la seule prouvée
  (en Python).
- Premier appel en `403` : attendre environ 2 minutes.
- Application créée **avant** le 07/10 : voir « Reprendre une application déjà créée » dans
  `village.md`.

## Qui travaille, qui ouvre (page `Collaborators`)

- Seul le **demandeur de l'application**, ou la plateforme, peut modifier la liste. Le demandeur
  est lu dans le code de l'infrastructure, jamais dans le texte de la demande : impossible de se
  faire passer pour lui.
- **Le demandeur ne peut jamais être retiré** de la liste (le robot refuse). Passer la main à un
  collègue n'est pas possible par ce formulaire : poser la question sur `#ask-village`.
- Pourquoi on ne peut pas déléguer le droit d'inviter : ce droit permettrait aussi de désactiver
  la protection de la branche et de lire les secrets de la chaîne de fabrication.
- Les contributeurs ne peuvent jamais supprimer l'application.

## Infrastructure (page `Vibeapp-infrastructure`)

| Taille | Garanti (CPU / mémoire) | Maximum |
|---|---|---|
| `small` (défaut) | 50m / 128Mi | 500m / 512Mi |
| `medium` | 250m / 512Mi | 1 / 1Gi |
| `large` | 500m / 1Gi | 2 / 2Gi |

Dépasser la mémoire maximale tue l'application aussitôt (`OOMKilled`) ; dépasser le CPU la
ralentit seulement. La taille se demande à la plateforme avec des chiffres d'usage réels. La
base est la même pour toutes les applications (PostgreSQL 16, 2 GiB, une instance, sans haute
disponibilité). Le stockage de fichiers est supprimé 90 jours après remplacement et avec
l'application.

## Ce que le wiki dit et que l'agent doit nuancer

- « Si ça répond en local, ça répondra une fois déployé » : **ne pas le répéter.** Le test local
  d'un Python sans dépendance ne prouve que le démarrage. Il ne prouve ni le `Dockerfile`, ni
  l'accès Google, ni la base.
- Le badge de déploiement vert (« Healthy / Synced ») : la page `Your-first-deploy` en fait le
  signe que le dernier envoi est en ligne, mais `How-deployment-works` dit lui-même qu'il reste
  vert quand un build échoue. **Ne jamais s'y fier seul** : regarder l'historique (`ci:`).
- « Une à deux minutes » pour un déploiement : mesuré 2 à 7.
- Le formulaire écrit `.valiuz.io` ; l'adresse réelle est `.valiuz.ai`.
- L'exemple du wiki cite un tag Python qui n'est plus au catalogue : lire le catalogue.

## Identité de l'utilisateur dans l'application (admin du Village, 12/10/2026)

*Source : consignes de l'administrateur de la plateforme à une utilisatrice, relayées par Jonas.
Statut : **lu**, sauf mention contraire.*

- **L'application ne fait rien en authentification** : ni OAuth, ni JWT, ni cookie de session, ni
  page de connexion ou de déconnexion, ni redirection. La plateforme authentifie chaque requête
  avant qu'elle n'atteigne l'application (protection d'accès Google, « IAP »).
- **Une authentification OAuth faite par l'application elle-même est cassée en production** sur
  le Village : erreur `redirect_uri_mismatch`. À remplacer, pas à réparer.
- **Le seul besoin de l'application : connaître l'e-mail**, pour ses droits métier. L'en-tête
  est `X-Goog-Authenticated-User-Email: accounts.google.com:prenom.nom@valiuz.com`. Garder ce qui
  suit le **dernier** `:`, en minuscules. **Prouvé** : l'en-tête arrive en minuscules
  (`x-goog-authenticated-user-email`), et la coupe après le dernier `:` fonctionne.
- **Développement local** : aucun en-tête n'existe. Un repli par variable d'environnement
  (`DEV_USER_EMAIL`) est possible, **uniquement si `NODE_ENV` n'est pas `production`**. Jamais en
  production. Non essayé chez nous.
- **Qui peut ouvrir l'application** : l'administrateur annonce des utilisateurs distincts des
  contributeurs, choisis par liste d'adresses **et par groupes Google**. C'est déjà en place
  (formulaire « Change who can open an application »). Un groupe qui n'existe pas est refusé avant
  création : vérifier que l'adresse du groupe existe.
- **Nuance de sécurité (notre règle, pas celle de l'administrateur)** : lire l'e-mail seul pour
  décider d'un **droit métier** (administrateur, population, mode démo) suppose que la requête est
  passée par la porte. Pour décider d'un droit, utiliser de préférence l'identité dont le jeton
  signé est vérifié (`x-goog-iap-jwt-assertion`). **Prouvé en Python** (`calendrier-edito`) ; non
  discuté avec l'administrateur : à lui demander si un en-tête peut être posé à la main par un
  service voisin du cluster. Ne pas présenter cela comme un risque avéré.
- **L'administrateur a corrigé sa consigne en cinq minutes** (la première version gardait un
  contrôle qui répond 401, la seconde le supprime). Pour une application qui contrôle des
  droits métier, ne pas supprimer un contrôle d'identité sans avoir demandé quel droit il protège.
