# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **BigQuery SQL analytics platform** for MercadoLibre Brazil (MLB) credit card portfolio management. It covers customer segmentation, risk assessment, and revenue optimization for campaigns: UPSELL, DOWNSELL, Parcelamento (installments), and P&L reporting.

There are no build, lint, or test commands — all code is SQL executed directly against BigQuery.

## Repository Structure

```
codes/
├── UPSELL/          # Credit limit increase campaigns
│   ├── backtesting_upsell/    # AB test performance validation (step_1–step_N)
│   ├── 202508–202602/         # Monthly campaign runs (YYYYMM folders)
│   ├── upsell_bau.sql         # Standard upsell segmentation and eligibility
│   ├── upsell_especial.sql    # Special offer targeting
│   └── insert_campaign_cartera.sql  # Campaign insertion into production tables
├── DOWNSELL/        # Credit limit reduction campaigns
│   ├── backtesting_downsell/  # Performance validation
│   ├── verdi_flows/           # Verdi integration scripts
│   └── downsell.sql           # Main policy and rule logic
├── parcelamento/    # Installment repricing strategy
├── pl/              # Profit & Loss analysis (step_1, step_2, step_3)
└── blacklist_insert.sql       # Customer exclusion logic

tableros/            # Monitoring dashboards (mirrors codes/ structure)
```

## Data Architecture

**Source Layer (`WHOWNER.*`)** — raw fact/dimension tables:
- `WHOWNER.BT_CCARD_ACCOUNT` — credit card account attributes
- `WHOWNER.BT_CCARD_PROPOSAL` — customer proposals
- `WHOWNER.BT_CCARD_LIMIT_HIST` — limit change history
- `WHOWNER.BT_VU_CAMPAIGN` — campaign metadata
- `WHOWNER.CC_FRIDAY_SCORING` — behavioral and risk scoring

**Output Layer (`SBOX_CREDITS_SB.*`)** — processed analytics tables:
- Campaign eligibility and segmentation results
- Backtesting and impact measurement tables
- Dashboard/monitoring output

**Temporary Layer (`TMP.*`)** — intermediate processing tables.

## Key Patterns and Conventions

**Monthly campaign cycle:** Files and tables follow `YYYYMM` naming (e.g., `202601`). Site is always `site_id = 'MLB'` (Brazil).

**Customer eligibility layers:**
1. **Hard rules** — absolute exclusions (DPD thresholds, fraud flags, blacklists)
2. **Soft rules** — risk-based filters (behavioral scoring, rating thresholds)
3. **Campaign assignment** — BAU / ESPECIAL / PREFERENCIAL categories

**Backtesting pattern:** Multi-step SQL files (`step_1.sql` through `step_N.sql`) build up incrementally. Each step creates or inserts into a table consumed by the next.

**Key metrics computed:**
- `cartera` — average portfolio balance
- Revenue streams: interchange, revolving (`revolvente`), late fees (`mora`), installments (`parcelado`), overlimit (`sobrelimite`)
- `cogs` — collection, processing, issuance costs
- DPD (Days Past Due) buckets
- AB test groups: `control` vs `impact`

**SQL style:** Heavy use of CTEs (`WITH` clauses), `QUALIFY` + window functions for deduplication, `SAFE_OFFSET` for array access, and `CASE WHEN` aggregations.

## Critical Context

- All queries target **BigQuery SQL dialect** (use `QUALIFY`, `EXCEPT()`, date functions like `DATE_DIFF`, `DATE_TRUNC`).
- `parcelamento_fatura.sql` is the largest file (~15k lines); use `parcelamento_fatura_refatorado.sql` as the cleaner reference.
- `backtesting_downsell/step_5.sql` is the largest backtesting file (~19k lines) and is the canonical performance measurement script.
- Airflow orchestrates the `dash_resultado_downsell_airflow.sql` pipeline.
- Verdi is an external flow management system integrated under `DOWNSELL/verdi_flows/`.
