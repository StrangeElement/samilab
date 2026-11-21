# Sami Context Outbox (2026-11-21 20:14 UTC)

## Recent Commits
No commits yet.

---
## FILE: AGENTS.md

# GLOBAL SYSTEM RULES — SAMI PROJECT (AGENTS.md)

## 0. Strict Token & Scope Guardrails
- **No broad audits:** Never scan the entire repository or inspect `.git/` internals unless explicitly given a specific file path.
- **Tool call budget:** Limit exploration to a maximum of **5 file reads or commands** per turn. If more inspection is needed, STOP and check with the user whether to continue down that path.
- **One verb per task:** Do not combine "audit + refactor + commit" in a single run, unless simply "verify and commit+push if valid".

## 1. HUMAN CONTEXT, LANGUAGE & COGNITIVE ERGONOMICS (ABSOLUTE PRIORITY)
- The human lead (Richard) is an experienced full-stack developer and Linux/Web administrator living with ME/CFS (limited energy envelope, brain fog, photophobia).
- **Bilingual Protocol (French Chat / English OSS Code):**
  - **Converse with Richard in French** (unless he writes in English).
  - **Write 100% of code, inline code comments, docblocks, SQL column comments, variable/function/table names, Git commit messages, and technical documentation in clean, standard English** (for Open Source software distribution).
- **Conciseness & Structure:** Keep chat responses short, well-spaced, and structured with clear bullet points. Zero fluff, zero flattery, 100% signal.
- **Sequential Progression:** One step at a time. Never chain multiple unvalidated phases.
- **Question vs. Problem Principle:** "The answer to the question is not always the solution to the problem." Always check if a simpler, safer, or more structural approach better solves the underlying need.

## 2. SHARED MEMORY PROTOCOL (`/memory/`)
1. **At the start of every task:** Always read `/memory/STATE.md` and the latest entries of `/memory/WORKLOG.md` (plus `/memory/ROADMAP.md` when architectural context is needed).
2. **Inbox check (Orchestrator only):** Compare the `[ID: ...]` blocks in `/memory/INBOX.md` with the "Processed Inbox Directives" list in `/memory/STATE.md`. Integrate any new directive into `ROADMAP.md`, `AGENTS.md` or `.kilo/agent/*.md`, then record its ID as processed. `INBOX.md` itself is overwritten by `scripts/sync-inbox.sh` and must never be edited by agents.
3. **At the end of every checkpoint:** Update `/memory/STATE.md` and prepend a concise entry in `/memory/WORKLOG.md` (Date, Role/Model, Action, Modified files, Next step). Commits follow the validation gate in Section 4.

## 3. OPEN SOURCE SECURITY & ZERO SECRET LEAKAGE (CRITICAL)
- This repository is **Public / Open Source**.
- **NEVER** hardcode API keys, passwords, database credentials, server IP addresses, SSH ports, or cPanel usernames inside any Git-tracked file.
- All local or production secrets must reside exclusively in untracked files ignored by `.gitignore` (`config.local.php`, `.env`, `.env.local`, `.env.deploy`, `*.secrets`), with restrictive permissions (`600`, or `640` when the web server must read them).
- Always provide safe template files (`config.example.php`, `.env.deploy.example`, `.env.local.example`) with placeholder values.
- **Test server password convention (NAS dev/test only):** every non-system password on the local test server (library DB user, WordPress `wordpress.test` DB and admin, MediaWiki test DB, test Admin console, etc.) is simply `test`. This applies only to the isolated local NAS test environment and only inside untracked local files (`config.local.php`, `.env.local`, `wp-config.php` of the test instance). It never applies to system accounts (e.g. the NAS sudo account) nor to production (WHC Pro), where strong unique secrets are mandatory.

## 4. MULTI-AGENT GOVERNANCE & ORCHESTRATOR VALIDATION GATE
- **Single source of role definitions:** The 5 roles live in `.kilo/agent/<slug>.md` (one Markdown file per agent, Git permissions enforced in each frontmatter). Any creation, modification, or tool restriction of an agent must be applied in that file. Legacy monolithic mode files are retired and must not be recreated.
- **Roles:**
  - `sami-orchestrator` — global direction, atomic checkpoints, validation gate, sole committer.
  - `sami-architect-opus` — critical foundations (MariaDB schema, SHA-256 API guard, security, core routing); automatically delegates routine work to `sami-coder-sonnet` through the Kilo `task` tool (named `new_task` in Inbox directives), then reviews the resulting `git diff`.
  - `sami-coder-sonnet` — executes well-scoped task lists from the Architect/Orchestrator.
  - `sami-fast-worker` — short tasks and test datasets; tags every deliverable and WORKLOG entry with `[model: <model-name>]` (mandatory for A/B model evaluation).
  - `sami-challenger` — read-only critique at major checkpoints.
- **One Mandate = One Atomic Checkpoint:** The Orchestrator breaks work into testable micro-tasks and delegates them to sub-agents (Kilo `task` tool / Agent Manager).
- **Stop & Escalate Rule:** A sub-agent must never improvise architectural decisions or execute unapproved SQL schema changes. On ambiguity, it stops and returns its findings to the delegating agent.
- **No automatic commits or pushes:** There is no cron-based Git sync. Sub-agents (Architect, Coder, Fast Worker, Challenger) **never** run `git add`, `git commit`, or `git push`; they leave changes in the working tree.
- **Validation Gate (Orchestrator):** Before any commit, the Orchestrator must:
  1. Inspect `git status` and `git diff` (including untracked files).
  2. Confirm zero secrets, zero out-of-scope files, and zero unintended permission changes (`old mode`/`new mode`).
  3. Confirm the checkpoint's acceptance criteria are met and `/memory/STATE.md` + `/memory/WORKLOG.md` are updated.
  4. Present a short French summary to Richard and obtain explicit approval.
  5. Only then stage the intended files explicitly and run `git commit -m "checkpoint: <english summary>"` followed by `git push`.

## 5. STRICT TECHNICAL & VISUAL CONSTRAINTS
- **Tech Stack:** Native PHP 8.3 (PDO, strict prepared statements, zero heavy frameworks) + MariaDB 10.11 LTS across all 3 pillars (`samilab.io` on WordPress, `wiki.samilab.io` on MediaWiki, `library.samilab.io` on custom PHP 8.3 app).
- **OS Sandboxing:** The environment runs under the restricted Linux user `sami-dev` (no `sudo`). Never attempt to modify files outside `/var/www/samilab`.
- **SQL Schema Governance (Library):** Zero automatic SQL schema modification via API. Any table creation or alteration must be queued in `schema_migrations` (`status = 'pending'`) and requires manual human approval inside the Admin console (`/admin`).
- **Credential Hashing:** The 3 high-entropy Bearer API keys are stored as SHA-256 hashes. The single human Admin password uses PHP `password_hash()` (Argon2id) / `password_verify()`.
- **Visual Design (Accessible Low-Glare Pale Edition — WCAG AAA):**
  - Pure white (`#FFFFFF`) is strictly forbidden.
  - Primary Background: Soft Stone `#EAEEF3` | Card Surface: Warm Paper `#F4F6F9` | 1px Borders: `#CBD5E1`.
  - Primary Text: Deep Lab Navy `#121824` | Secondary Text: Slate Ink `#334155`.
  - Accents: Deep Teal `#0D6E6E` | Science Blue `#1464B8` | Data Emerald `#0B6041`.
- **Open Licensing:** Source code is licensed under the **MIT License**; original editorial content and methodological review grids under **CC BY 4.0**; factual study metadata exports under **CC0** (strictly excluding internal `fulltext` and copyrighted abstracts).

## 6. SPECIALIZED MODEL & TOOL STANDARDS (PHASE 1)
- **Biology / biochemistry & full-text papers:** Gemini Pro (long context) + Claude Opus (methodological critique).
- **Argumentation, rhetoric & logic:** reasoning models (`o`-series / DeepSeek R1).
- **Statistical analysis:** always generate and execute Python scripts (`scipy`, `statsmodels`); an LLM must never compute statistics "in its head".
- **Scientific infographics:** generated by code (SVG / HTML-CSS / Matplotlib / D3) using the Pale Edition palette (`#EAEEF3`).
- **Videos:** code-based animations (Remotion / FFmpeg); generative B-roll only occasionally.
- **Monitoring & API / clinical-trial verification:** Perplexity Sonar or verified web search.
- **Cron billing quota:** future ingestion/analysis cron scripts go through Kilo Gateway under a strict daily quota that always keeps a cushion for interactive work.

---
## FILE: memory/STATE.md

# ÉTAT ACTIF DU PROJET SAMI (STATE.md)
*Dernière mise à jour : 2026-11-21*

## 1. Focus immédiat (Phase 0 — Socle technique)
- **Chantier 0.1 (Serveur WHC Pro) : TERMINÉ**
  - DNS Cloudflare + SSL/TLS (Full Strict) sur `samilab.io`, `wiki.samilab.io`, `library.samilab.io`.
  - PHP 8.3 + MariaDB 10.11.19 LTS ; WordPress (`noindex`) ; MediaWiki configuré (CC BY 4.0, palette Pâle).

- **Chantier actif : Harnais multi-agents local (`/var/www/samilab`)**
  - FAIT : dépôt GitHub relié (`main`), migration Roo Code → Kilo Code (`AGENTS.md` + `.kilo/agent/*.md`, 5 rôles ; `.kilocodemodes` retiré le 2026-11-20), pont Inbox (`scripts/sync-inbox.sh`).
  - FAIT (2026-11-20, validé par `sami-orchestrator`) : audit de cohérence ; push automatique supprimé au profit de la Validation Gate de l'Orchestrateur ; script `setup-nas-sami-dev.sh` fiabilisé ; guide d'installation réécrit.
  - FAIT (2026-11-21, validé par `sami-orchestrator`) : garde-fous tokens/périmètre (`AGENTS.md` §0) ; convention mot de passe `test` du NAS de test (`AGENTS.md` §3, `setup-nas-sami-dev.sh` par défaut + `ALTER USER`) ; script `scripts/check-git-security.sh` ; dossiers `library/exports/` et `library/static_cache/` (`.gitkeep`).
  - FAIT (2026-11-21, confirmé par Richard) : installation du NAS de dev terminée (étapes 1 à 5 de `README-INSTALLATION-NAS.md` : permissions, secrets locaux, accès Git `sami-dev`, Remote-SSH, Kilo Code).
  - **Chantier harnais : TERMINÉ.**
  - Prochaine action : Richard choisit entre le **Chantier 0.3** (Librairie PHP 8.3 + MariaDB, recommandé comme socle) et le **Chantier 0.2** (`sami-governance`).

## 2. Checkpoints en attente d'approbation humaine
- Aucun.

## 3. Points ouverts (à trancher par Richard)
- Résolu (2026-11-20, approuvé par Richard) : `.gitattributes` racine `* text=auto eol=lf` ajouté ; `scripts/*.sh` commités en 755.
- Résolu (2026-11-21) : chemin des agents corrigé dans le Google Doc Inbox (`.kilo/agent/<slug>.md`).

## 4. Directives Inbox traitées
- [ID: 2026-11-18-01] — Migration Kilo Code, 5 rôles, délégation automatique Opus → Sonnet (outil `task`, ex-`new_task`), tag A/B `[model: <nom>]` du Fast Worker, standards des modèles spécialisés Phase 1 (`AGENTS.md` §6, `ROADMAP.md` §6.D), quota cron Kilo Gateway.
- [ID: 2026-11-20-01] — Rôles définis dans `.kilo/agent/<slug>.md` (source unique) ; `.kilocodemodes` supprimé et plus référencé dans `AGENTS.md` ni `ROADMAP.md` (revérifié le 2026-11-20 : aucun fichier, mentions historiques uniquement dans `INBOX.md` / `WORKLOG.md` / `STATE.md`).

---
## FILE: memory/ROADMAP.md

# **PROJET SAMI — CARNET DE ROUTE & MÉMOIRE À MOYEN TERME**
*Document de référence opérationnel et mémoire d'état évolutive pour l'IA. Les développements détaillés (prompts, architectures) figurent dans le document principal « [Sami: an ME/CFS research agent](https://s4me.info) ».*

# **1. Contexte humain et règles de collaboration (Priorité absolue)**
- **Profil :** Développeur full-stack et administrateur système expérimenté, webmestre et membre du comité du forum scientifique international [S4ME](https://s4me.info).
- **Contrainte de santé :** Vivant avec l'EM/SFC (encéphalomyélite myalgique / syndrome de fatigue chronique), impliquant une réserve d'énergie limitée et la présence de brouillard cérébral (*brain fog*).

## **Directives d'interaction pour l'IA**
1. **Format court et digeste :** Réponses concises, aérées et fortement structurées. Proscrire les blocs de texte denses.
2. **Progression séquentielle :** Avancer une étape à la fois et maintenir ce carnet à jour pour décharger la mémoire de travail humaine.
3. **Mise en page directe :** Présenter les livrables directement sous forme structurée sans conteneurs de code Markdown pour le texte.
4. **Analyse de besoin sous-jacent :** Appliquer le principe *« la réponse à la question n'est pas toujours la solution au problème »* en recherchant systématiquement la méthode la plus simple et structurante.
5. **Bilinguisme opérationnel (Français / Anglais OSS) :** Communiquer en **français** avec l'humain, mais rédiger **100 % du code, des commentaires de code, des noms de variables/tables, des messages de commit Git et de la documentation technique Open Source en anglais**.

# **2. Objectifs stratégiques et lien avec S4ME**
- **Mission principale :** Contribuer à la découverte d'une solution biologique à l'EM/SFC (traitement curatif ou équivalent fonctionnel) via des actions à haut ratio impact/effort.
- **Soutien à S4ME :** Mettre l'infrastructure automatisée au service des objectifs du forum [s4me.info](https://s4me.info).

## **Stratégie de déploiement en trois phases**
| Phase | Statut | Périmètre d'exécution | Objectifs & Modalités |
| :--- | :--- | :--- | :--- |
| **Phase 0** | En cours | Initialisation & Socle technique (Infrastructure & Outils sur mesure) | Mise en place initiale distincte du fonctionnement régulier : installation des 3 sites, création du micro-plugin WordPress de gouvernance des commentaires, développement de l'API REST à 3 clés et du frontend PHP 8.3 à cache statique de la Librairie, et configuration de base de MindStudio. |
| **Phase 1** | À venir | Fonctionnement régulier autonome (Hébergement personnel *samilab.io*) | Exécution quotidienne autonome du plan directeur par Sami, validation du concept et rodage des workflows sans impacter l'infrastructure officielle de S4ME. |
| **Phase 2** | Projetée | Intégration [S4ME](https://s4me.info) | Connexion en lecture seule aux contenus publics via API XenForo (`node:read`, `thread:read`), respect de l'anonymat et migration éventuelle après validation du comité. |

# **3. Architecture cognitive et matérielle**
```text
                 +-----------------------------------+
                 |    MindStudio (Orchestration)     |
                 |  - Gestion des Secrets / API Keys |
                 |  - Tâches programmées (Cron)      |
                 |  - Routage de services (Router)   |
                 +-----------------+-----------------+
                                   |
         +-------------------------+-------------------------+
         |                                                   |
         v                                                   v
+-------------------------------+         +-------------------------------+
| Orchestrateur(s)              |         | Sous-agents ouvriers          |
| (Claude, GPT/o3, Gemini Pro)  | ------> | (Gemini Flash, etc.)          |
| - Planification globale       |         | - Collecte & extraction       |
| - Contrôle qualité & édition  |         | - Génération de brouillons    |
+-------------------------------+         +-------------------------------+
```

## **Harnais de développement Phase 0 (Local NAS + VS Code / Kilo Code + Git Cloud)**
- **Point d'entrée unique & Bascule multi-modèles (VS Code + Kilo Code) :** Pilotage en Remote-SSH sur le NAS Ubuntu. Règles globales dans `AGENTS.md`, 5 rôles dans `.kilo/agent/*.md` (permissions Git appliquées par agent) :
  - `sami-orchestrator` (Fable latest) : direction globale, checkpoints, Validation Gate, seul committer.
  - `sami-architect-opus` (Opus) : fondations critiques (schéma MariaDB, SHA-256, routeur), délégation automatique du reste à `sami-coder-sonnet` via l'outil Kilo `task` (nommé `new_task` dans les directives Inbox).
  - `sami-coder-sonnet` (Sonnet) : exécution des listes de tâches cadrées.
  - `sami-fast-worker` (Haiku / A-B) : tâches courtes et jeux de test, tag `[model: <nom>]` obligatoire.
  - `sami-challenger` (Gemini / ChatGPT / Argon) : revue critique en lecture seule.
  - **Source unique des rôles :** toute création, modification ou restriction d'outil d'un agent se fait dans son fichier `.kilo/agent/<slug>.md` (l'ancien fichier de modes monolithique est retiré).
- **Cloisonnement système (`sami-dev`) :** Exécution sous un utilisateur Linux dédié sans privilèges `sudo`, limité strictement aux dossiers du projet (`/var/www/samilab`) et à la base MariaDB de test (`samilab_library_test`), rendant toute suppression accidentelle de l'OS physiquement impossible.
- **Pont Inbox (Gemini → harnais) :** `scripts/sync-inbox.sh` télécharge le Google Doc « Directives Inbox » vers `/memory/INBOX.md` (zéro token IA) ; l'Orchestrateur intègre chaque nouvel `[ID: ...]` et le consigne dans `STATE.md`.
- **Facturation & quota cron (Kilo Pass Starter) :** Les futurs scripts cron d'ingestion/analyse passent par Kilo Gateway pour écouler les crédits bonus mensuels, avec un quota quotidien strict préservant un coussin pour le travail interactif.
- **Mémoire unique unifiée (`/memory/` + Git Cloud Open Source) :**
  1. Fin de la séparation entre Google Docs et fichiers locaux : dès l'initialisation du dépôt Git, ce Carnet de route stratégique devient `/memory/ROADMAP.md` (accompagné de `STATE.md` et `WORKLOG.md`), servant de source de vérité unique partagée par tous les modèles.
  2. Sauvegarde nuagique versionnée via un dépôt **Git (GitHub, public)**. Aucun commit/push automatique : l'Orchestrateur committe et pousse chaque checkpoint uniquement après sa Validation Gate (`git diff`, zéro secret, zéro changement de mode) et l'approbation explicite de Richard (`.gitignore` strict + `.env.local` / `.env.deploy` / `config.local.php`).

## **Harnais d'orchestration (MindStudio)**
- **Infrastructure Cloud :** Élimination de la maintenance locale.
- **Sécurité :** Stockage hermétique des accès via le coffre de variables secrètes (*Secrets*).
- **Planification (Cron) :** Exécution régulée des réveils programmés pour garantir une consommation linéaire des quotas mensuels sans rupture de service.
- **Routage dynamique :** Utilisation préférentielle d'une clé API Gemini pour l'usage courant, couplée à une réserve de crédits multi-modèles (Claude, ChatGPT/o3) pour les tâches complexes.

## **Orchestration hybride, Tournée générale & Messagerie interne**
- **Exécution hybride :** Combinaison d'agents autonomes sur horaire fixe (Cron indépendant pour la collecte et le pré-traitement régulier en tâche de fond) et de sous-agents appelés à la demande par l'Orchestrateur.
- **Tournée générale à chaque réveil :** À chaque exécution, l'Orchestrateur vérifie systématiquement : (1) les nouveaux commentaires humains sur le blog, et (2) le travail accompli et la performance des agents autonomes.
- **Communication inter-agents à deux niveaux :**
  1. *En direct (Synchrone dans MindStudio) :* Passage natif de variables JSON entre l'Orchestrateur et les sous-workflows appelés pendant une même exécution.
  2. *En différé (Asynchrone via `library.samilab.io` + Blog/Wiki) :* Table `agent_messages` / `agent_logs` dans la Librairie pour les rapports d'exécution entre cycles indépendants (évitant l'enfermement propriétaire dans MindStudio et permettant un accès local direct depuis WordPress/MediaWiki), complétée par les pages `Talk:` du Wiki et les commentaires du Blog pour les délibérations éditoriales visibles par l'humain.
- **Orchestrateurs (Modèles de pointe) :** Définition du plan directeur, découpage des opérations, révision du travail produit et publication. À terme, orchestration multi-agents basée sur des identités distinctes.
- **Agents d'exécution (Modèles légers) :** Réalisation des tâches répétitives (scraping, structuration de données, génération de médias bruts).

# **4. Écosystème web (Piliers d'hébergement)**
```text
                       +-----------------------+
                       |    Écosystème SAMI    |
                       +-----------+-----------+
                                   |
         +-------------------------+-------------------------+
         |                         |                         |
         v                         v                         v
+-----------------+       +-----------------+       +-----------------+
|  HQ & Journal   |       |  Encyclopédie   |       |  Base d'études  |
|   samilab.io    |       | wiki.samilab.io |       |library.samilab.io|
+-----------------+       +-----------------+       +-----------------+
```

## **1. Blog & Quartier Général (`samilab.io` — WordPress)**
- **Contrôle éditorial :** Sami dispose du contrôle éditorial complet (contenu, structure, propositions de CPT/plugins soumises à l'approbation de l'admin).
- **Supervision humaine par fil de commentaires & Plugin passerelle (`sami-governance.php`) :** Le statut d'un commentaire est déterminé naturellement par le dernier répondant du fil (si le dernier message est humain -> à traiter ; si le dernier message est de Sami -> traité/répondu). Le micro-plugin maison masque les commentaires au public (visibles uniquement par les Éditeurs/Admins) et tire profit de la cohabitation sur le même serveur (accès local direct à la base/cache de la Librairie et du Wiki) pour offrir des fonctions croisées (shortcodes, widgets statistiques, inclusion directe de fiches d'études).
- **Façade API « Agent-First » (`/wp-json/sami/v1/...`) :** Authentifiée via les comptes Éditeurs et *Application Passwords* natifs de WordPress (traçabilité par modèle), cette couche d'API sur mesure dans `sami-governance.php` remplace les réponses JSON verbeuses de WordPress par 4 routes compactes (100 % Signal / Zéro bruit) :
  1. `GET /wp-json/sami/v1/briefing` : Renvoie en un seul appel le condensé de la tournée générale (fils de commentaires où le dernier message est humain, derniers rapports non lus des agents autonomes dans la Librairie, et état actif du Master Plan).
  2. `POST /wp-json/sami/v1/reply` : Permet à Sami de répondre à un commentaire humain (ce qui marque automatiquement le fil comme traité).
  3. `POST /wp-json/sami/v1/publish` : Publication épurée d'articles, de revues ou de *Daily Logs* (`publish` ou `pending`) avec tag de version du modèle.
  4. `POST /wp-json/sami/v1/master-plan` : Création ou mise à jour structurée des éléments du Plan Directeur (*Effort*, *Coût*, *Impact*, *Statut*).
- **Questions critiques :** Les questions sensibles (ex. modification du schéma de la base de données) passent par le chat et les alertes de MindStudio plutôt que par le blog.

## **2. Le Wiki (`wiki.samilab.io` — MediaWiki)**
- Structure encyclopédique centralisant les connaissances établies, l'historique et l'actualité scientifique de l'EM/SFC.
- Accès automatisé sécurisé via *Bot Passwords* (un compte dédié par agent), interconnecté avec le blog.

## **3. La Librairie Scientifique (`library.samilab.io` — MariaDB / MySQL / WHC Pro)**
- **Ingestion par file d'attente :** Toute étude pertinente (abordant l'EM/SFC) est d'abord enregistrée avec un minimum de métadonnées dans une file d'attente, puis analysée en profondeur selon un horaire planifié par un agent spécialisé.
- **Banc d'essai local (NAS) :** Développement et itérations initiales en local sur le NAS (avec données statiques plausibles et générateur de données de test) afin de valider l'interface et les options avant le déploiement sur WHC Pro.
- **Architecture PHP 8.3 native & 3 clés API (avec validation humaine du schéma) :** Application PHP 8.3 légère (PDO, zéro framework lourd, OPcache natif sans latence de réveil) maximisant le pré-rendu en cache statique et l'interopérabilité locale directe avec WordPress/MediaWiki, adossée à une API RESTful utilisant 3 clés d'autorisation : (1) Lecture seule, (2) CRUD (ajout/modification d'études), et (3) Proposition de schéma (soumission de requêtes de migration dans une table d'attente, sans exécution directe).
- **Console d'administration à mot de passe unique & Journalisation API :** Page admin protégée par un simple mot de passe (aucun système de comptes utilisateurs ; empreinte chiffrée/hachée stockée dans un fichier caché non lisible publiquement, modifiable en SSH via un utilitaire CLI). Sans authentification, seul le formulaire de connexion est affiché. L'admin expose la « plomberie » interne et l'historique complet de toutes les requêtes API enregistrées (`api_logs`).
- **Gouvernance stricte du schéma de données (Zéro modification sans approbation manuelle) :**
  1. Aucune modification du schéma SQL n'est exécutée automatiquement par API. Les créations ou modifications passent par une table de gestion des migrations et doivent être approuvées et exécutées manuellement depuis l'interface Admin.
  2. À la toute première ouverture, l'Admin présente la liste initiale de création de la base de données.
  3. L'explorateur de schéma affiche de manière intuitive les tables, les colonnes, les types de données, les relations entre tables et les commentaires décrivant leur fonction.
  4. Lorsqu'une modification est proposée par un agent, elle apparaît en haut de l'onglet Schéma (En attente d'approbation), au-dessus du schéma actif en vigueur.
- **Organisation de l'Admin en 3 onglets (une fois la BD initiale créée) :**
  1. **1. Tableau de bord (par défaut) :** Vue sur la plomberie interne, métriques système et journal complet des requêtes API.
  2. **2. Schéma de données :** Avec indicateur d'alerte si des modifications sont en attente (affiche les modifications à approuver en haut, puis le schéma actif en dessous).
  3. **3. Données de test (mode dev/test uniquement) :** Outil permettant de générer et d'injecter à la demande des lots de 50 enregistrements réalistes à la fois pour tester l'interface et les filtres.
- **Stockage du texte intégral (Usage interne uniquement) :** Lors de l'ingestion, tout le texte disponible et toutes les métadonnées sont enregistrés en clair en base de données avec une indexation `FULLTEXT` afin de permettre des requêtes analytiques complexes et le text mining inter-études. Le texte intégral n'est jamais affiché publiquement (respect du droit d'auteur) et sert uniquement aux analyses internes de Sami pour éviter de refaire des requêtes web inutilement.
- **Modèle relationnel riche :** Au-delà des études, la base modélise des objets de données dédiés (auteurs, institutions, financeurs, etc.) selon le principe « plus nous avons de données structurées disponibles, mieux c'est ».
- **Tableau de bord décisionnel (Vue d'ensemble stratégique) :** La Librairie intègre un puissant tableau de bord analytique conçu pour les décideurs, offrant une vue d'ensemble synthétique et stratégique de la recherche sur l'EM/SFC (financements, lacunes de recherche, qualité méthodologique, tendances géographiques/temporelles, hypothèses étudiées) alimentée par des requêtes SQL et `FULLTEXT` complexes.
- **Sécurité sans faille & Chiffrement des communications API :** Chiffrement de bout en bout en transit (TLS 1.3 via Cloudflare en mode *Full Strict*, HSTS activé) pour l'ensemble des communications API et inter-applications. Jetons Bearer transmis exclusivement dans les en-têtes HTTP chiffrés, clés d'API stockées sous forme hachée (SHA-256) hors du dossier public (`chmod 600`), paramétrage SQL strict (zéro SQLi) et principe de moindre privilège pour les comptes DB. Pas de chiffrement du texte des études en base de données afin de préserver la rapidité et la nativité de la recherche `FULLTEXT` et des analyses complexes.
- **Ouverture des données & Téléchargement public (Open Science) :** Export téléchargeable (`CSV`, `JSON`, `SQLite`) des métadonnées factuelles (`CC0` / `CC BY 4.0`) et des grilles d'évaluation méthodologique (`CC BY 4.0`), excluant strictement la colonne interne du texte intégral et les résumés sous droit d'auteur.

## **4. Identité visuelle & Charte graphique (samilab)**
- **Nom & Signature officielle :** **samilab** — *ME/CFS Research AI & Data*
- **Symbole :** Fusion de la lettre « S » (Sami), d'une double hélice (biologie/biomédical) et d'un graphe neuronal/de données (IA).
- **Licences ouvertes (Code, Contenu & Données) :**
  - **Code source logiciel (GitHub) :** **MIT License** (ou GPLv3 pour compatibilité WordPress/MediaWiki), intégralement commenté et documenté en anglais.
  - **Contenu éditorial & grilles méthodologiques :** **Creative Commons Attribution 4.0 International (`CC BY 4.0`)**.
  - **Métadonnées factuelles brutes de la Librairie :** **`CC0` (Domaine public)**.
- **Thème par défaut — Édition Pâle Accessible (Anti-éblouissement / WCAG AAA / Zéro bruit) :**
  1. **Soft Stone (Fond principal sans éblouissement, zéro `#FFFFFF`) :** `#EAEEF3` (RGB : 234, 238, 243)
  2. **Warm Paper (Surface des cartes & encadrés) :** `#F4F6F9` (RGB : 244, 246, 249)
  3. **Subtle Border (Séparateurs fins `1px`) :** `#CBD5E1` (RGB : 203, 213, 225)
  4. **Deep Lab Navy (Texte principal & mot « sami » — Contraste 15.2:1 AAA) :** `#121824` (RGB : 18, 24, 36)
  5. **Slate Ink (Texte secondaire & sous-titre — Contraste 8.9:1 AAA) :** `#334155` (RGB : 51, 65, 85)
  6. **Deep Teal (Mot « lab » & accents — Contraste 5.1:1 AA+) :** `#0D6E6E` (RGB : 13, 110, 110)
  7. **Science Blue (Liens & filtres — Contraste 5.4:1 AA+) :** `#1464B8` (RGB : 20, 100, 184)
  8. **Data Emerald (Succès / Tier A — Contraste 6.8:1 AAA) :** `#0B6041` (RGB : 11, 96, 65)
- **Thème sombre (Optionnel / Console Admin / Logos sur fond foncé) :** Conserve la palette *Deep Lab Navy* (`#121824`), *Slate Navy* (`#1A2333`), *Cyan Bioluminescent* (`#2CE5F6`) et *Émeraude Data* (`#34E89E`).

# **5. Standard d'évaluation scientifique (*Peer-Review*)**
- **Rigueur méthodologique universelle :** Alignement des exigences sur les standards de la science fondamentale (contrôle des biais, insu, critères d'évaluation objectifs vs auto-rapportés, puissance statistique). Neutralisation des biais d'évaluation sans appliquer de grille militante spécifique.
- **Principe universel de brutale honnêteté & 100 % Signal (Zéro bruit) :** Application systématique d'une candeur absolue à l'ensemble du travail de Sami (analyses, synthèses, stratégie). Tolérance zéro pour le remplissage, la spéculation creuse, l'exagération promotionnelle (hype) ou la complaisance diplomatique. L'objectif est de maintenir le bruit au strict minimum pour ne livrer que du signal pur, appuyé sur des preuves rigoureuses (à titre d'exemple, constater directement l'absence de traitement cliniquement prouvé sans tourner autour du pot).
- **Économie d'effort sur le fardeau de la preuve :** Le fardeau de la preuve appartient intégralement aux auteurs d'une étude ou d'une affirmation. Lorsqu'un essai clinique ou un traitement ne présente pas de preuves méthodologiquement valides (absence d'insu avec critères subjectifs, biais majeurs, absence de réplication), Sami le constate de façon directe et concise sans tergiverser longuement ni gaspiller de ressources à spéculer.
- **Registre de sources fiables :** Le développement et le maintien d'un répertoire qualifié de sources scientifiques et institutionnelles fiables constituent un pilier central de la stratégie de recherche.
- **Processus d'ingestion en deux temps :**
  1. Extraction et structuration des données factuelles et quantifiables.
  2. Application de la grille d'évaluation critique sur la base de données qualifiée.

# **6. Suivi des chantiers et mémoire d'état**
## **A. En cours (Focus actif — Phase 0)**
- **Statut :** Chantier 0.1 sur WHC Pro finalisé : DNS Cloudflare + SSL/TLS (Full Strict) opérationnels ; PHP 8.3 et MariaDB 10.11.19 LTS actifs ; WordPress installé sur `samilab.io` (mode banc d'essai / `noindex`) ; MediaWiki installé et configuré sur `wiki.samilab.io` (accès publics verrouillés, licence CC BY 4.0, logos et palette Édition Pâle Accessible via SFTP).
- **Prochaine micro-étape :** Finaliser le harnais multi-agents local sur le NAS (`README-INSTALLATION-NAS.md` : permissions `sami-dev`, secrets locaux, accès Git, Remote-SSH, Kilo Code) et lancer les Chantiers 0.2 (`sami-governance.php`) et 0.3 (`library.samilab.io` en PHP 8.3).

## **B. Feuille de route priorisée — Phase 0 (Chantiers d'initialisation technique)**
1. **Chantier 0.1 — Socle d'hébergement & Installations (WHC Pro) [FAIT] :** Déployer WordPress (`samilab.io`), MediaWiki (`wiki.samilab.io`) et la base de données MariaDB/MySQL (`library.samilab.io`) avec sécurisation TLS 1.3 / Cloudflare Full Strict et HSTS.
2. **Chantier 0.2 — Micro-plugin WordPress (`sami-governance.php`) :** Coder et installer le plugin gérant le masquage public des commentaires (réservés aux Éditeurs/Admins), la détection de statut selon le dernier message du fil, la façade API « Agent-First » ultra-compacte (`/wp-json/sami/v1/briefing`, `/reply`, `/publish`, `/master-plan`), et les fonctions croisées locales avec la Librairie et le Wiki (shortcodes, widgets, intégration directe).
3. **Chantier 0.3 — Application & Admin de `library.samilab.io` (NAS -> WHC Pro) :** Développer et tester sur le NAS l'application PHP 8.3 / MariaDB incluant : l'API à 3 clés avec journalisation intégrale, la console Admin à mot de passe unique (fichier caché / SSH), le système d'approbation manuelle du schéma (initialisation + migrations en attente + visualisation intuitive des tables/relations/commentaires), le générateur de lots de 50 données de test (mode dev) et le frontend à cache statique.
4. **Chantier 0.4 — Structure initiale du Wiki & du Blog :** Créer les catégories de base dans MediaWiki, les comptes bots/éditeurs pour chaque modèle, et les sections du Master Plan / Research Log dans WordPress.
5. **Chantier 0.5 — Harnais MindStudio initial :** Configurer les Secrets (clés API), le gestionnaire de budget/cron et le premier flux d'orchestrateur pour lancer la Phase 1.

## **C. Feuille de route priorisée — Phase 1 (Chantiers de fonctionnement régulier)**
1. **Chantier 1.1 — Boucle quotidienne MVP :** Vérification des commentaires (tournée générale : commentaires humains et suivi des agents autonomes), veille et mise en file d'attente des études, analyse asynchrone (Étapes 1 et 2) et tenue du Journal / Wiki.
2. **Approche itérative à faible volume :** Au démarrage, produire un petit volume de contenus (quelques études analysées, quelques pages wiki, quelques billets de blog et médias) afin de faire évoluer les schémas de données et les algorithmes de façon empirique.
3. **Chantier 1.2 — Grille de revue méthodologique (Étape 2) & Choix des modèles :** Affiner la grille d'évaluation critique universelle et sélectionner les modèles optimaux pour les revues.
4. **Chantier 1.3 — Coordination Multi-Orchestrateurs :** Protocole de discussion (notamment via les pages de discussion du Wiki) et partage du travail entre Claude, Gemini et GPT.
5. **Chantier 1.4 — Stratégie Média & Recherche élargie :** Déploiement progressif de la production d'infographies, d'articles de synthèse et de vidéos.

## **D. Standards des modèles & outils spécialisés (Phase 1)**
- **Biologie / biochimie & articles complets :** Gemini Pro (contexte long) + Claude Opus (critique méthodologique).
- **Argumentation, rhétorique & logique :** modèles de raisonnement (série `o` / DeepSeek R1).
- **Analyse statistique :** génération et exécution obligatoire de scripts Python (`scipy`, `statsmodels`) — jamais de calcul statistique « de tête » par un LLM.
- **Infographies scientifiques :** générées par code (SVG / HTML-CSS / Matplotlib / D3), palette Édition Pâle (`#EAEEF3`).
- **Vidéos :** animations par code (Remotion / FFmpeg) + B-roll génératif ponctuel uniquement.
- **Veille & vérification API / essais cliniques :** Perplexity Sonar ou recherche web vérifiée.
