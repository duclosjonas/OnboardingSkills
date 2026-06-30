# Bien travailler avec OpenCode

Ce guide s'adresse à toute personne qui utilise OpenCode pour la première fois. Il ne nécessite pas de connaissances techniques. Il prend 2 minutes à lire.

---

## Les sessions

Une session = une conversation = un sujet.

Quand tu ouvres OpenCode, tu démarres une session. L'agent se souvient de tout ce qui a été dit dans cette session — mais rien de plus. Si tu fermes et rouvres, la session repart de zéro.

**Règle simple :** un sujet par session. Si tu passes d'un sujet à un autre dans la même conversation, l'agent perd le fil et ses réponses deviennent moins précises.

Exemples :
- Session 1 → préparer une réunion de lancement
- Session 2 → rédiger un compte-rendu
- Session 3 → analyser des données Sheets

Ne mélange pas les deux dans la même conversation.

---

## Les prompts

Un prompt c'est le message que tu envoies à l'agent. Plus il est précis, meilleure est la réponse.

**Mauvais prompt :**
> "Aide-moi avec mon projet"

L'agent ne sait pas de quel projet tu parles, ce que tu veux faire, ni dans quel format tu veux la réponse.

**Bon prompt :**
> "Rédige un mail de relance pour un fournisseur qui n'a pas répondu depuis 2 semaines. Ton direct et professionnel, 5 lignes maximum."

Ce qu'un bon prompt contient :
- Ce que tu veux (rédiger, analyser, résumer, expliquer...)
- Le contexte (pour qui, dans quel cadre)
- Les contraintes (longueur, ton, format)

---

## Les modèles

OpenCode te permet de choisir le modèle que l'agent utilise. Chaque modèle a un niveau de puissance différent — et un coût différent en ressources. Utiliser Opus pour une question simple, c'est comme prendre un avion pour aller au bout de la rue.

| Modèle | Usage | Coût |
|---|---|---|
| **Claude Haiku 4.5** | Question rapide, résumé court, reformulation simple | $ |
| **Claude Sonnet 4.6** | Rédaction, analyse, préparation de réunion, usage quotidien — **à utiliser par défaut** | $$ |
| **Claude Opus 4.7** | Raisonnement complexe, document structuré long, sujets difficiles — réserver aux vrais besoins | $$$$ |
| **Gemini Pro 3.1** | Tout ce qui touche à Google Workspace : Sheets, Docs, Forms, Drive | $$ |

**Règle simple :** commence toujours par Sonnet. Passe à Opus uniquement si Sonnet ne s'en sort pas après 1-2 essais.

---

## Le mode Plan

OpenCode est configuré en mode Plan par défaut. Cela signifie que l'agent te montre ce qu'il s'apprête à faire avant de le faire — et attend ta validation.

C'est intentionnel. Ne cherche pas à le désactiver.
