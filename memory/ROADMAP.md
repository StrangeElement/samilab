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
  - `sami-architect-opus` (Opus) : fondations critiques (schéma MariaDB, SHA-256, routeur), délègue le reste à `sami-coder-sonnet`.
  - `sami-coder-sonnet` (Sonnet) : exécution des listes de tâches cadrées.
  - `sami-fast-worker` (Haiku / A-B) : tâches courtes et jeux de test, tag `[model: <nom>]` obligatoire.
  - `sami-challenger` (Gemini / ChatGPT / Argon) : revue critique en lecture seule.
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
- **Statut :** Chantier 0.1 sur WHC Pro finalisé : DNS Cloudflare + SSL/TLS (Full Strict) opérationnels ; PHP 8.3 et MariaDB 10.11.19 LTS actifs ; WordPress installé sur `samilab.io` (mode banc d'essai / `noindex`) ; MediaWiki installé et configuré sur `wiki.samilab.io` (accès publics verrouillés, licence CC BY 4.0, logos et palette Édition Pâle Accessible via SFTP port 27).
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
