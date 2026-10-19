# Migration d'un Apps Script vers le Village

À lire en entrant dans la **phase C** du skill, pas avant. Ce fichier est pour toi, pas pour
l'utilisateur : ne lui montre ni les noms de services Apps Script, ni ce tableau. Tu lui
présentes le résultat en termes métier.

**Statut : jamais exécuté de bout en bout (écrit le 19/10/2026).** Les lignes marquées
**prouvé** renvoient à `village.md`. Les autres sont **lues ou déduites** : ne rien promettre.

Le Village n'accepte que Python, Node.js, Go. Python est le seul langage prouvé de bout en bout :
le choisir par défaut, sauf raison nette.

## 1. Inventaire (silencieux)

Lire tous les `.gs`, `.html` et `appsscript.json`. Dresser, pour toi, la liste de :

- chaque appel à un service Google (voir tableau ci-dessous) ;
- chaque Sheets utilisé (identifiant, onglets), en **LECTURE** ou **ÉCRITURE** ;
- chaque déclencheur (`ScriptApp.newTrigger`, fonctions `onOpen`, `onEdit`, `doGet`, `doPost`) ;
- chaque identifiant, adresse e-mail ou clé écrits en dur dans le code ;
- les pages HTML et ce qu'elles appellent côté serveur (`google.script.run`).

Compter les écritures : une application qui enregistre des saisies a besoin d'écrire.

## 2. Équivalences

| Dans l'Apps Script | Sur le Village | Statut |
|---|---|---|
| `SpreadsheetApp` : lire | API Sheets, recette de lecture de `village.md` (trois appels HTTP) | **Prouvé** (Python et Node.js) |
| `SpreadsheetApp` : écrire | API Sheets, scope `spreadsheets`, partage **Éditeur** | **Non prouvé** (test prévu par Jonas sur `calendrier-edito`) |
| `doGet` / `HtmlService` (pages) | Routes du serveur, pages HTML servies par l'application | Déduit. Pas de page de connexion : la plateforme garde la porte |
| `google.script.run` | Appels `fetch` du navigateur vers une route du serveur | Déduit |
| `Session.getActiveUser().getEmail()` | En-tête `x-goog-authenticated-user-email` (en minuscules) | **Prouvé** pour la lecture de l'identité. Pour un droit, utiliser le jeton signé, jamais l'e-mail seul |
| Déclencheur temporel | Tâche planifiée **dans** l'application (une seule réplique) : rattraper au démarrage une exécution manquée, éviter la double exécution pendant un déploiement, fuseau `Europe/Paris`. **Aucune alerte en cas d'échec** | Lu |
| `MailApp`, `GmailApp` | **Aucun équivalent.** Aucun service d'envoi, Gmail non couvert, sans échéance | Lu. Le dire en une phrase, ne rien promettre. Demander à l'utilisateur ce qu'il veut garder (voir plus bas) |
| `CalendarApp` | Non disponible (politique d'entreprise) | Lu |
| `DriveApp` : lire ou modifier un fichier existant | API Drive, après partage du fichier avec l'adresse de l'application | Lu, non essayé |
| `DriveApp` : créer un fichier | **Impossible** (l'application n'a pas d'espace Drive). Créer le fichier à la main et le partager | Lu |
| `PropertiesService` | Variables d'environnement (`vibeapp.yaml`) pour du fixe, Secret Manager pour un secret. Pour de l'état qui change : une base, ou un onglet de Sheets | Lu |
| `LockService` | Une seule réplique : un verrou en mémoire suffit **dans** l'application. Il ne protège pas contre l'Apps Script d'origine qui écrit en parallèle | Déduit |
| `CacheService` | Mémoire de l'application (perdue à chaque mise en ligne) | Déduit |
| `UrlFetchApp` | Appels HTTP sortants | **Inconnu** : l'accès sortant du Village vers d'autres services n'est pas établi. Demander sur `#ask-village` si le script appelle un service externe |
| Limite de 6 minutes par exécution | N'existe plus | Déduit |

## 3. Ce qui ne migre pas : comment le dire

Résumé de 5 lignes, **en termes métier**, jamais en noms de services. Exemples :

- « Les e-mails automatiques ne peuvent pas partir du Village aujourd'hui. Voici ce que je
  propose : <option>. »
- « Les fichiers que ton script crée automatiquement dans Drive ne pourront plus être créés : il
  faudra les créer à la main une fois. »

Options pour l'envoi de mail, **à proposer sans les promettre** : (a) laisser cette seule fonction
dans l'Apps Script d'origine, qui continue de tourner pour l'envoi (le lien entre les deux n'est
pas établi : à tester) ; (b) afficher l'information dans l'application au lieu de l'envoyer ;
(c) poser la question sur `#ask-village`. Laisser l'utilisateur choisir.

## 4. Pièges à traiter sans les montrer

1. **Identifiants et adresses en dur** : les sortir du code. Un identifiant de Sheets va dans une
   variable de `vibeapp.yaml`, un secret va dans Secret Manager, **jamais dans le code ni dans
   `source-gas/` envoyé sur le Village**. Un jeton ou une clé API trouvés dans le script : le dire à
   l'utilisateur, ils sont considérés comme exposés s'ils ont déjà été partagés.
2. **Noms d'onglets et colonnes** : les reprendre à l'identique, ne pas « améliorer » la structure
   des données pendant la migration.
3. **Écriture en deux temps** (vider un onglet puis le réécrire) : non atomique, un échec entre les
   deux laisse l'onglet vide. Ne pas reproduire ce schéma : écrire ligne par ligne ou par plage.
4. **Deux applications sur le même fichier** pendant la transition : l'ancienne et la nouvelle
   écrivent en parallèle. Raison de plus pour la copie du Sheets en première mise en ligne.
5. **Jetons Google** : valables environ une heure, les garder en mémoire (voir la recette de
   lecture). Un test local ne peut pas les obtenir : en local, on vérifie seulement le démarrage.
6. **Fuseau horaire** : l'Apps Script suit celui du projet ; fixer `Europe/Paris` explicitement.
7. **Trois règles de la plateforme** (3.2 du skill) : écouter sur `0.0.0.0` et `PORT`, répondre
   200 sur `/healthz` et `/readyz`, logs sur la sortie standard.

## 5. Première mise en ligne

Sur une **copie** du Sheets tant que l'écriture n'est pas prouvée. Premier test d'écriture : un
onglet vide créé à la main (`_TEST_VILLAGE`), une seule cellule, jamais un onglet de données (voir
`village.md`, « Si l'application doit écrire dans le Sheets »).

Après le test de Jonas sur `calendrier-edito` : mettre à jour `village.md` (ligne « Écriture »,
date, résultat), ajouter ici une recette d'écriture, et assouplir la règle de la copie.
