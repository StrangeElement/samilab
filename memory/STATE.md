# ÉTAT ACTIF DU PROJET SAMI (STATE.md)
*Dernière mise à jour : 2026-11-20*

## 1. Focus immédiat (Phase 0 — Socle technique)
- **Chantier 0.1 (Serveur WHC Pro) : TERMINÉ**
  - DNS Cloudflare + SSL/TLS (Full Strict) sur `samilab.io`, `wiki.samilab.io`, `library.samilab.io`.
  - PHP 8.3 + MariaDB 10.11.19 LTS ; WordPress (`noindex`) ; MediaWiki configuré (CC BY 4.0, palette Pâle).

- **Chantier actif : Harnais multi-agents local (`/var/www/samilab`)**
  - FAIT : dépôt GitHub relié (`main`), migration Roo Code → Kilo Code (`AGENTS.md` + `.kilo/agent/*.md`, 5 rôles ; `.kilocodemodes` retiré le 2026-11-20), pont Inbox (`scripts/sync-inbox.sh`).
  - FAIT (2026-11-20, validé par `sami-orchestrator`) : audit de cohérence ; push automatique supprimé au profit de la Validation Gate de l'Orchestrateur ; script `setup-nas-sami-dev.sh` fiabilisé ; guide d'installation réécrit.
  - Prochaine action :
    1. Richard : exécuter les étapes 1 à 5 de `README-INSTALLATION-NAS.md` (permissions, secrets locaux, accès Git `sami-dev`, Remote-SSH, Kilo Code).
    2. Lancer le **Chantier 0.3** (Librairie PHP 8.3 + MariaDB) ou le **Chantier 0.2** (`sami-governance`).

## 2. Checkpoints en attente d'approbation humaine
- Aucun.

## 3. Points ouverts (à trancher par Richard)
- Aucun. (2026-11-20 : port SSH de l'hébergement retiré des fichiers suivis, désormais uniquement dans `.env.deploy` ; le NAS de dev utilise le port 22 standard.)

## 4. Directives Inbox traitées
- [ID: 2026-11-18-01] — Migration Kilo Code, 5 rôles, délégation Opus → Sonnet, A/B Fast Worker, modèles spécialisés Phase 1, quota cron Kilo Gateway.
- [ID: 2026-11-20-01] — Rôles définis dans `.kilo/agent/<slug>.md` ; `.kilocodemodes` supprimé et plus référencé dans `AGENTS.md` ni `ROADMAP.md`.
