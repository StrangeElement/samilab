# ÉTAT ACTIF DU PROJET SAMI (STATE.md)
*Dernière mise à jour : 2026-11-16*

## 1. Focus immédiat (Phase 0 — Socle technique)
- **Chantier 0.1 (Serveur WHC Pro) : TERMINÉ (Base en place)**
  - DNS Cloudflare + SSL/TLS (Full Strict) actifs sur les 3 domaines (`samilab.io`, `wiki.samilab.io`, `library.samilab.io`).
  - PHP 8.3 et MariaDB 10.11.19 LTS actifs.
  - WordPress installé sur `samilab.io` (mode banc d'essai / `noindex`).
  - MediaWiki installé et configuré sur `wiki.samilab.io` (accès verrouillés, licence CC BY 4.0, logos et thème Édition Pâle Accessible `#EAEEF3`).
  - Accès SFTP/SSH opérationnel (port `27` sur WHC Pro).

- **Chantier actif : Mise en route du harnais Multi-Agents local (`/var/www/samilab`)**
  - Dossier `/var/www/samilab` créé sur le NAS Ubuntu.
  - Règle OSS activée : Conversation en français avec Richard, mais **100 % du code, des commentaires de code, des schémas SQL et des commits Git en anglais**.
  - Prochaine action immédiate :
    1. Valider la connexion Remote-SSH sous l'utilisateur cloisonné `sami-dev` et relier le dépôt GitHub Open Source.
    2. Lancer le **Chantier 0.2** (Micro-plugin WordPress `wp-plugin/sami-governance/sami-governance.php` avec masquage des commentaires publics et les 4 routes `/wp-json/sami/v1/briefing`, `reply`, `publish`, `master-plan`) OU le **Chantier 0.3** (Application PHP 8.3 + MariaDB de `library/`).

## 2. Checkpoints en attente d'approbation humaine
- Aucun checkpoint bloquant en attente. Prêt à recevoir la première instruction dans Roo Code.
