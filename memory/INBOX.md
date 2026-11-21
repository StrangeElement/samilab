# **Sami — Directives Inbox**

## **Pont Gemini \-\> Harnais VS Code / Kilo Code**

# **Protocole de synchronisation (Sens unique)**

* **Rôle de ce document :** Boîte de réception des décisions stratégiques et directives approuvées dans le chat principal (Gemini) à destination du harnais local (`/var/www/samilab`).  
* **Source de vérité :** Le dépôt Git (`/memory/ROADMAP.md`, `/memory/STATE.md`, `/memory/WORKLOG.md`) demeure l'unique source de vérité.  
* **Fonctionnement :**  
  1. Le script local `scripts/sync-inbox.sh` télécharge ce document en Markdown vers `/memory/INBOX.md` sans consommer de tokens IA.  
  2. À chaque session, l'Orchestrateur (`sami-orchestrator` / Fable) compare les blocs `[ID: ...]` présents dans `/memory/INBOX.md` avec la liste des IDs déjà traités dans `/memory/STATE.md`.  
  3. Pour tout nouvel ID : l'Orchestrateur intègre la directive dans `/memory/ROADMAP.md`, `AGENTS.md` ou `.kilo/agent/<slug>.md` selon le cas, puis enregistre l'ID comme traité dans `/memory/STATE.md`.  
* **Sécurité :** Aucune clé API, mot de passe, adresse IP ou donnée privée ne doit jamais être inscrit dans ce document.

# **Directives actives**

## **\[ID: 2026-11-18-01\] Migration Kilo Code, délégation Opus \-\> Sonnet, A/B Fast Worker & Modèles spécialisés Phase 1**

* **Statut :** En attente d'intégration par `sami-orchestrator`  
* **Cibles :** `AGENTS.md`, `.kilo/*.md`, `/memory/ROADMAP.md`, `/memory/STATE.md`  
* **Directives :**  
  1. **Harnais Kilo Code (5 rôles) :** Remplacer la structure Roo Code par Kilo Code (`AGENTS.md` \+ `.kilo/*.md`) avec les 5 rôles suivants :  
     * `sami-orchestrator` (Fable latest) : direction globale, découpage en checkpoints, vérification `git diff`.  
     * `sami-architect-opus` (Opus 5.5) : architecture et fondations critiques (schéma MariaDB, sécurité SHA-256, routeur), avec délégation automatique des tâches simples vers `sami-coder-sonnet` via `new_task`.  
     * `sami-coder-sonnet` (Sonnet) : exécution mécanique des listes de tâches cadrées par l'Architecte.  
     * `sami-fast-worker` (Haiku / alternatives A/B) : tâches courtes et jeux de données de test, avec obligation de tagger chaque livrable et entrée `WORKLOG.md` par `[model: <nom-du-modele>]`.  
     * `sami-challenger` (Comité critique : Gemini / ChatGPT / Argon) : mode lecture seule (`read`), revue constructive aux checkpoints majeurs selon le principe *Question vs Problème*.  
  2. **Facturation & Quota Cron (Kilo Pass Starter) :** Utiliser Kilo Gateway pour les futurs scripts cron d'ingestion/analyse afin d'écouler les crédits bonus mensuels, avec un **quota quotidien strict** réservant toujours un coussin pour le travail interactif dans VS Code.  
  3. **Standards des modèles/outils spécialisés (Phase 1\) :**  
     * Biologie / biochimie & articles complets : Gemini Pro (contexte long) \+ Claude Opus (critique méthodologique).  
     * Argumentation, rhétorique & logique : modèles de raisonnement (`o`\-series / DeepSeek R1).  
     * Analyse statistique : génération et exécution obligatoire de scripts Python (`scipy`, `statsmodels`) — jamais de calcul statistique « de tête » par un LLM.  
     * Infographics scientifiques : générées par code (SVG / HTML-CSS / Matplotlib / D3) respectant la palette Édition Pâle (`#EAEEF3`).  
     * Vidéos : animations basées sur le code (Remotion / FFmpeg) \+ B-roll génératif ponctuel uniquement.  
     * Veille & vérification d'API/essais cliniques : Perplexity Sonar ou recherche web vérifiée.  
  4. **Suivi Inbox :** Ajouter une section `## Directives Inbox traitées` dans `/memory/STATE.md` et y consigner `[ID: 2026-11-18-01]` une fois intégré.

## **\[ID: 2026-11-20-01\] Architecture des agents migrée vers .kilo/\*.md**

* **Statut :** En attente d'intégration par `sami-orchestrator`  
* **Cibles :** `AGENTS.md`, `.kilo/*.md`, `/memory/ROADMAP.md`, `/memory/STATE.md`  
* **Directives :**  
  5. **Source de définition des rôles :** L'ancien fichier monolithique `.kilocodemodes` a été migré en local vers des fichiers Markdown individuels sous `.kilo/*.md` (`.kilo/agents/*.md`). Toute future création, modification ou restriction d'outil d'un agent (les 5 rôles : `sami-orchestrator`, `sami-architect-opus`, `sami-coder-sonnet`, `sami-fast-worker`, `sami-challenger`) doit désormais être appliquée directement dans le fichier `.kilo/*.md` correspondant et non dans `.kilocodemodes`.  
  6. **Nettoyage & cohérence :** Vérifier que `.kilocodemodes` n'est plus référencé dans `AGENTS.md` ni dans `/memory/ROADMAP.md` (et qu'aucun fichier `.kilocodemodes` obsolète ne traîne dans le dépôt).  
  7. **Suivi Inbox :** Consigner `[ID: 2026-11-20-01]` dans la section `## Directives Inbox traitées` de `/memory/STATE.md` une fois vérifié.