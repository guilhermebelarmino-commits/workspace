# workspace

Plataforma de analytics SQL no BigQuery para gestão da carteira de cartão de crédito do MercadoLibre Brasil (MLB). Cobre segmentação de clientes, avaliação de risco e otimização de receita em quatro domínios:

- **UPSELL** — campanhas de aumento de limite de crédito
- **DOWNSELL** — campanhas de redução de limite de crédito
- **Parcelamento** — estratégia de reprecificação de parcelamento
- **P&L** — análise de resultado financeiro da carteira

## Estrutura

```
codes/
├── UPSELL/             # Scripts de segmentação, elegibilidade e inserção de campanha
├── DOWNSELL/           # Regras de política, integrações Verdi e dashboards
├── parcelamento/       # Lógica de reprecificação de parcelamento
├── pl/                 # Cálculo de P&L (step_1 → step_2 → step_3)
└── blacklist_insert.sql

tableros/               # Dashboards de monitoramento e acompanhamento
```

Cada pasta de campanha contém execuções mensais (`YYYYMM/`) e uma subpasta `backtesting_*/` com scripts de validação em múltiplos passos (`step_1.sql` → `step_N.sql`).

## Stack

- **Data warehouse:** Google BigQuery
- **Orquestração:** Apache Airflow
- **Gestão de fluxos:** Verdi
