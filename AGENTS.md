# GLOBAL SYSTEM RULES — SAMI PROJECT (.roorules)

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
2. **At the end of every validated checkpoint:**
   - Update `/memory/STATE.md` with the exact current status.
   - Prepend a concise entry in `/memory/WORKLOG.md` (Date, Role/Model, Action, Modified files, Next step).
   - Run `git add -A && git commit -m "checkpoint: <english summary>" && git push` (once the Git remote is configured).

## 3. OPEN SOURCE SECURITY & ZERO SECRET LEAKAGE (CRITICAL)
- This repository is **Public / Open Source**.
- **NEVER** hardcode API keys, passwords, database credentials, server IP addresses, SSH ports, or cPanel usernames inside any Git-tracked file.
- All local or production secrets must reside exclusively in untracked files ignored by `.gitignore` (`config.local.php`, `.env`, `.env.deploy`, `*.secrets`).
- Always provide safe template files (`config.example.php`, `.env.deploy.example`) with placeholder values.

## 4. MULTI-AGENT GOVERNANCE & SUPERVISION (BOOMERANG PATTERN)
- **One Mandate = One Atomic Checkpoint:** The Orchestrator breaks work down into testable micro-tasks and delegates via `new_task` to the appropriate specialist mode (`sami-challenger`, `sami-architect-php`, `sami-fast-worker`).
- **Stop & Escalate Rule:** A sub-agent must never improvise architectural decisions or execute unapproved SQL schema changes. If an ambiguity arises, it must stop immediately and escalate to the Orchestrator via `attempt_completion`.
- **Trust, but Verify:** When a sub-agent returns, the Orchestrator inspects `git status` / `git diff` (ensuring no secrets or out-of-scope files are staged) before declaring the checkpoint complete.

## 5. STRICT TECHNICAL & VISUAL CONSTRAINTS
- **Tech Stack:** Native PHP 8.3 (PDO, strict prepared statements, zero heavy frameworks) + MariaDB 10.11 LTS across all 3 pillars (`samilab.io` on WordPress, `wiki.samilab.io` on MediaWiki, `library.samilab.io` on custom PHP 8.3 app).
- **OS Sandboxing:** The environment runs under the restricted Linux user `sami-dev` (no `sudo`). Never attempt to modify files outside `/var/www/samilab`.
- **SQL Schema Governance (Library):** Zero automatic SQL schema modification via API. Any table creation or alteration must be queued in `schema_migrations` (`status = 'pending'`) and requires manual human approval inside the Admin console (`/admin`).
- **Visual Design (Accessible Low-Glare Pale Edition — WCAG AAA):**
  - Pure white (`#FFFFFF`) is strictly forbidden.
  - Primary Background: Soft Stone `#EAEEF3` | Card Surface: Warm Paper `#F4F6F9` | 1px Borders: `#CBD5E1`.
  - Primary Text: Deep Lab Navy `#121824` | Secondary Text: Slate Ink `#334155`.
  - Accents: Deep Teal `#0D6E6E` | Science Blue `#1464B8` | Data Emerald `#0B6041`.
- **Open Licensing:** Source code is licensed under the **MIT License**; original editorial content and methodological review grids under **CC BY 4.0**; factual study metadata exports under **CC0** (strictly excluding internal `fulltext` and copyrighted abstracts).
