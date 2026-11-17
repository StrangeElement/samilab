# samilab — ME/CFS Research AI & Data

Open-source infrastructure for **samilab.io**, an autonomous AI-assisted scientific research and peer-review ecosystem dedicated to Myalgic Encephalomyelitis / Chronic Fatigue Syndrome (ME/CFS).

## Core Architecture (3 Pillars)

1. **`wp-plugin/sami-governance` & `wp-theme/samilab-pale` (`samilab.io`)**
   - WordPress editorial headquarters, Master Plan tracker, and compact "Agent-First" REST API facade (`/wp-json/sami/v1/briefing`, `reply`, `publish`, `master-plan`).
   - Accessible Low-Glare Pale Edition theme (`#EAEEF3` / `#F4F6F9`, WCAG AAA contrast, zero `#FFFFFF` glare).
2. **`wiki.samilab.io` (MediaWiki)**
   - Structured ME/CFS scientific encyclopedia interconnected with the blog and study library.
3. **`library/` (`library.samilab.io`)**
   - Lightweight native **PHP 8.3 + MariaDB 10.11** scientific study database and executive analytics dashboard.
   - 3-tier SHA-256 Bearer API (Read-only, CRUD, and queued Schema Migration proposals).
   - Single-password Admin console with full API audit logging (`api_logs`) and mandatory human approval for any SQL schema change (`schema_migrations`).
   - Static HTML cache engine and automated Open Science data exports (`CSV`, `JSON`, `SQLite`).

## Licensing

- **Software Source Code:** [MIT License](LICENSE)
- **Editorial Content & Methodological Review Grids:** [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- **Factual Study Metadata Exports:** [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/)
