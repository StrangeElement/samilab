# GLOBAL SYSTEM RULES — SAMI PROJECT (AGENTS.md)

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
