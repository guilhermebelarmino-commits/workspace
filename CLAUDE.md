# CLAUDE.md

Este arquivo fornece orientações ao Claude Code (claude.ai/code) ao trabalhar com o código neste repositório.

## Visão Geral do Projeto

Esta é uma **plataforma de analytics SQL no BigQuery** para gestão da carteira de cartão de crédito do MercadoLibre Brasil (MLB). Cobre segmentação de clientes, avaliação de risco e otimização de receita para as campanhas: UPSELL, DOWNSELL, Parcelamento e relatórios de P&L.

Não há comandos de build, lint ou teste — todo o código é SQL executado diretamente no BigQuery.

## Estrutura do Repositório

```
codes/
├── UPSELL/          # Campanhas de aumento de limite
│   ├── backtesting_upsell/    # Validação de performance de testes AB (step_1–step_N)
│   ├── 202508–202602/         # Execuções mensais de campanha (pastas YYYYMM)
│   ├── upsell_bau.sql         # Segmentação e elegibilidade padrão de upsell
│   ├── upsell_especial.sql    # Segmentação de ofertas especiais
│   └── insert_campaign_cartera.sql  # Inserção de campanha nas tabelas de produção
├── DOWNSELL/        # Campanhas de redução de limite
│   ├── backtesting_downsell/  # Validação de performance
│   ├── verdi_flows/           # Scripts de integração com o Verdi
│   └── downsell.sql           # Lógica principal de política e regras
├── parcelamento/    # Estratégia de reprecificação de parcelamento
├── pl/              # Análise de P&L (step_1, step_2, step_3)
└── blacklist_insert.sql       # Lógica de exclusão de clientes

tableros/            # Dashboards de monitoramento (espelha a estrutura de codes/)
```

## Arquitetura de Dados

**Camada Fonte (`WHOWNER.*`)** — tabelas brutas de fatos/dimensões:
- `WHOWNER.BT_CCARD_ACCOUNT` — atributos da conta de cartão de crédito
- `WHOWNER.BT_CCARD_PROPOSAL` — propostas de clientes
- `WHOWNER.BT_CCARD_LIMIT_HIST` — histórico de alterações de limite
- `WHOWNER.BT_VU_CAMPAIGN` — metadados de campanha
- `WHOWNER.CC_FRIDAY_SCORING` — scoring comportamental e de risco

**Camada de Saída (`SBOX_CREDITS_SB.*`)** — tabelas analíticas processadas:
- Resultados de elegibilidade e segmentação de campanhas
- Tabelas de backtesting e medição de impacto
- Output de dashboards e monitoramento

**Camada Temporária (`TMP.*`)** — tabelas de processamento intermediário.

## Padrões e Convenções

**Ciclo mensal de campanha:** Arquivos e tabelas seguem a nomenclatura `YYYYMM` (ex.: `202601`). O site é sempre `site_id = 'MLB'` (Brasil).

**Camadas de elegibilidade de clientes:**
1. **Hard rules** — exclusões absolutas (limites de DPD, flags de fraude, blacklists)
2. **Soft rules** — filtros baseados em risco (scoring comportamental, limiares de rating)
3. **Atribuição de campanha** — categorias BAU / ESPECIAL / PREFERENCIAL

**Padrão de backtesting:** Arquivos SQL em múltiplos passos (`step_1.sql` até `step_N.sql`) construídos incrementalmente. Cada step cria ou insere em uma tabela consumida pelo próximo.

**Métricas principais calculadas:**
- `cartera` — saldo médio da carteira
- Fontes de receita: interchange, revolvente, mora, parcelado, sobrelimite
- `cogs` — custos de cobrança, processamento e emissão
- Buckets de DPD (Days Past Due)
- Grupos de teste AB: `control` vs `impacto`

**Estilo SQL:** Uso intenso de CTEs (cláusulas `WITH`), `QUALIFY` + funções de janela para deduplicação, `SAFE_OFFSET` para acesso a arrays e agregações com `CASE WHEN`.

## Contexto Crítico

- Todas as queries utilizam o **dialeto SQL do BigQuery** (use `QUALIFY`, `EXCEPT()`, funções de data como `DATE_DIFF`, `DATE_TRUNC`).
- `parcelamento_fatura.sql` é o maior arquivo (~15k linhas); use `parcelamento_fatura_refatorado.sql` como referência mais limpa.
- `backtesting_downsell/step_5.sql` é o maior arquivo de backtesting (~19k linhas) e é o script canônico de medição de performance.
- O Airflow orquestra o pipeline `dash_resultado_downsell_airflow.sql`.
- Verdi é um sistema externo de gestão de fluxos integrado em `DOWNSELL/verdi_flows/`.
