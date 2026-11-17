# GUIDE D'INSTALLATION — HARNAIS MULTI-AGENTS SAMI (NAS UBUNTU + VS CODE + ROO CODE)

## Nouveautés de cette version v3 (Open Source & Code en Anglais)
1. **Règle bilingue intégrée (`.roorules` & `.roomodes`) :** Les agents discutent avec toi en **français**, mais rédigent **100 % du code, des commentaires de code, des schémas SQL et des messages de commit Git en anglais**.
2. **Zéro secret dans Git :**
   - `scripts/deploy-whc.sh` lit désormais un fichier `.env.deploy` ignoré par Git (modèle fourni dans `.env.deploy.example`).
   - `library/config.example.php` fournit le modèle de configuration PHP 8.3 (le vrai fichier `config.local.php` est ignoré par Git).
3. **Licences Open Source incluses :** Fichiers `LICENSE` (MIT pour le code + CC BY 4.0 + CC0) et `README.md` (en anglais pour GitHub) placés à la racine.

---

## Étape 1 : Décompresser et activer le cloisonnement sur le NAS
1. Décompresse cette archive directement dans `W:\` (`/var/www/samilab`).
2. Connecte-toi une fois en SSH à ton NAS avec ton compte administrateur habituel et lance :
   ```bash
   sudo bash /var/www/samilab/scripts/setup-nas-sami-dev.sh
   ```

## Étape 2 : Connecter VS Code en Remote-SSH sous `sami-dev`
1. Dans VS Code, installe l'extension **Remote - SSH** (`ms-vscode-remote.remote-ssh`).
2. Clique en bas à gauche (`><`) -> **Connect to Host...** -> `sami-dev@IP_DE_TON_NAS`.
3. Ouvre le dossier **`/var/www/samilab`**.

## Étape 3 : Installer Roo Code et configurer les modèles
1. Dans VS Code (connecté en SSH), installe l'extension **Roo Code** (`RooVeterinaryInc.roo-cline`).
2. Dans les réglages de Roo Code (⚙️), crée tes profils d'API (*Claude-Sonnet*, *Gemini-Pro*, *Gemini-Flash*, *GPT-o3*).
3. Associe chaque profil aux 4 modes détectés depuis `.roomodes` :
   - **🧭 Sami Orchestrator**
   - **🔬 Sami Strategy Challenger**
   - **🏗️ Sami PHP 8.3 & MariaDB Architect**
   - **⚡ Sami Fast Worker**

## Étape 4 : Relier ton dépôt GitHub Open Source
Dans le terminal intégré de VS Code (`sami-dev@...:/var/www/samilab$`) :
```bash
git init
git branch -M main
git add -A
git commit -m "chore: initial open-source monorepo and multi-agent harness setup"
git remote add origin git@github.com:TON_COMPTE/samilab.git
git push -u origin main
```
*(N'oublie pas d'activer **Secret scanning** et **Push protection** dans Settings -> Code security sur GitHub !)*
