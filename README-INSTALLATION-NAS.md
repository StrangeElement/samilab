# GUIDE D'INSTALLATION — HARNAIS MULTI-AGENTS SAMI (NAS UBUNTU + VS CODE + KILO CODE)

## État de départ (déjà fait)
- Dépôt GitHub `StrangeElement/samilab` créé, cloné dans `/var/www/samilab`, branche `main`.
- Harnais Kilo Code : `AGENTS.md` (règles globales) + `.kilo/agent/*.md` (5 rôles).
- Pont Inbox : `scripts/sync-inbox.sh` + `.vscode/tasks.json` (sync à l'ouverture du dossier).

## Règle Git (important)
- **Aucun commit/push automatique.** Seul `sami-orchestrator` committe et pousse, après la **Validation Gate** (`AGENTS.md`, section 4) et ton approbation explicite.

---

## Étape 1 : Finaliser le cloisonnement `sami-dev` (une seule fois, compte admin)
```bash
sudo GIT_NAME='Richard Vallée' GIT_EMAIL='ton-email' \
     bash /var/www/samilab/scripts/setup-nas-sami-dev.sh
```
- Idempotent : relançable sans risque.
- **Convention serveur de test :** tous les mots de passe non système du NAS de test (BD librairie, WordPress `wordpress.test`, MediaWiki test, console Admin de test, etc.) valent simplement `test`. Le script applique `test` au compte DB `sami_local` par défaut (surchargeable via `SAMI_DB_PASSWORD`) et réinitialise le mot de passe s'il existait déjà. Ne s'applique ni aux comptes système (sudo du NAS) ni à la production.
- Applique les permissions (dossiers `2775`, fichiers `664`, scripts `755`, secrets `600`/`640`) sans toucher `.git/`.
- Retire l'ancien cron `auto-git-sync.sh` s'il existe.

## Étape 2 : Fichiers secrets locaux (en `sami-dev`, jamais versionnés)
```bash
cd /var/www/samilab
cp .env.local.example .env.local            # INBOX_EXPORT_URL
cp .env.deploy.example .env.deploy          # WHC_USER / WHC_HOST / WHC_PORT
cp library/config.example.php library/config.local.php
chmod 600 .env.local .env.deploy
chmod 640 library/config.local.php
```
- Dans `config.local.php` : mettre `test` comme mot de passe DB (convention serveur de test), ou la valeur de `SAMI_DB_PASSWORD` si surchargée.

## Étape 3 : Accès Git en écriture pour `sami-dev`
- Le remote est en HTTPS. Pour que l'Orchestrateur puisse pousser, au choix :
  - **Recommandé :** clé SSH dédiée `sami-dev` ajoutée comme *Deploy key* (write) sur GitHub, puis :
    ```bash
    git remote set-url origin git@github.com:StrangeElement/samilab.git
    ```
  - Ou un *fine-grained token* limité au dépôt, via `git credential-store` (fichier `600`).
- Vérifier sur GitHub : **Secret scanning** + **Push protection** activés.

## Étape 4 : VS Code en Remote-SSH sous `sami-dev`
1. Extension **Remote - SSH** → **Connect to Host...** → `sami-dev@<ip-du-nas>`.
2. Ouvrir **`/var/www/samilab`** (et non le partage `\\...` Windows : les scripts bash et les permissions Linux en dépendent).
3. Autoriser la tâche automatique « Sync Sami Inbox » au premier lancement.

## Étape 5 : Kilo Code
1. Installer l'extension **Kilo Code** dans la session Remote-SSH.
2. Vérifier que les 5 agents de `.kilo/agent/` apparaissent et leur associer un modèle (ou ajouter `model:` dans leur frontmatter) :
   - 🧭 `sami-orchestrator` → Fable latest
   - 🏗️ `sami-architect-opus` → Claude Opus
   - 💻 `sami-coder-sonnet` → Claude Sonnet
   - ⚡ `sami-fast-worker` → Haiku (ou alternative A/B)
   - 🔬 `sami-challenger` → Gemini / ChatGPT
3. Démarrer en mode `sami-orchestrator`.
