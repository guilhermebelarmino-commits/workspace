-- Downsell: clientes, dívida e over30 m2 por mês, policy_category, grupo e status de conta
-- Fonte: RBA_TC_MLB_SEGUIMIENTO_UPSELL_DOWNSELL_VU_CAMPAIGN_GUBELARMINO + RBA_TC_MLB_CARTERA_GERAL_PECASTANHO
-- Filtros: downsell (VARIACION < 0), a partir de jan/2025, mínimo 1.000 clientes por grupo, apenas meses com dado de over30 m2

SELECT
  DATE_TRUNC(s.ACTIONABLE_DT, MONTH)                              AS mes,
  COALESCE(s.CAMPAIGN_POLICY_SUBCATEGORY_DESC, s.CAMPAIGN_DESC)   AS policy_category,
  CASE WHEN s.CONTROL_GROUP_FLAG THEN 'CONTROLE' ELSE 'IMPACTO' END AS grupo,
  c.acc_status,
  COUNT(DISTINCT s.CUS_CUST_ID)                                    AS clientes,
  ROUND(SUM(c.deuda_m2), 2)                                        AS deuda_m2,
  ROUND(SUM(c.deuda_over30_m2), 2)                                 AS deuda_over30_m2,
  ROUND(SAFE_DIVIDE(SUM(c.deuda_over30_m2), SUM(c.deuda_m2)), 4)  AS pct_over30_m2
FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_SEGUIMIENTO_UPSELL_DOWNSELL_VU_CAMPAIGN_GUBELARMINO` s
LEFT JOIN `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` c
  ON c.user_id = s.CUS_CUST_ID
  AND c.f_cartera = DATE_TRUNC(s.ACTIONABLE_DT, MONTH)
WHERE
  s.VARIACION < 0
  AND s.ACTIONABLE_DT >= '2025-01-01'
GROUP BY 1, 2, 3, 4
HAVING
  COUNT(DISTINCT s.CUS_CUST_ID) >= 1000
  AND SUM(c.deuda_over30_m2) > 0
ORDER BY 1, 2, 3, 4
