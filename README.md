# workspace

BigQuery SQL analytics platform for MercadoLibre Brazil (MLB) credit card portfolio management. Covers customer segmentation, risk assessment, and revenue optimization across four domains:

- **UPSELL** — credit limit increase campaigns
- **DOWNSELL** — credit limit reduction campaigns
- **Parcelamento** — installment repricing strategy
- **P&L** — profit & loss portfolio analysis

## Structure

```
codes/
├── UPSELL/             # Segmentation, eligibility, and campaign insertion scripts
├── DOWNSELL/           # Policy rules, Verdi flow integrations, and dashboards
├── parcelamento/       # Installment repricing logic
├── pl/                 # P&L calculation (step_1 → step_2 → step_3)
└── blacklist_insert.sql

tableros/               # Monitoring and follow-up dashboards
```

Each campaign folder contains monthly runs (`YYYYMM/`) and a `backtesting_*/` subfolder with multi-step validation scripts (`step_1.sql` → `step_N.sql`).

## Stack

- **Data warehouse:** Google BigQuery
- **Orchestration:** Apache Airflow
- **Flow management:** Verdi
