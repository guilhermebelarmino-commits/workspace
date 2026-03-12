create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PECASTANHO_TMP`
options (
  expiration_timestamp = timestamp_add(current_timestamp(), interval 24 hour)
)
as
select
   *
  ,case
    when regexp_contains(campaign_group, 'IMPACTO|GESTION') then 'IMPACTO'
    when regexp_contains(campaign_group, 'CONTROL') then 'CONTROL'
    else 'a ver' end as campaign_group_trat
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO`
;

drop table if exists `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PECASTANHO`;

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PECASTANHO`
(
   campaign_id STRING
  ,f_acc_carga DATE
  ,f_mes_acc_carga DATE
  ,f_acc_impacto DATE
  ,risk_id STRING
  ,audiencia STRING
  ,produto STRING
  ,policy STRING
  ,policy_category STRING
  ,policy_subcategory STRING
  ,control_group_flag BOOL
  ,campaign_group STRING
  ,user_id INT64
  ,limit_amount_tc_acc_post NUMERIC
  ,limit_amount_tc_acc_pre NUMERIC
  ,f_mes_vto_resumen_v3 DATE
  ,f_vto_resumen_max_v3 DATE
  ,monto_resumen_v3 DATE
  ,total_pago_v3 DATE
  ,pagado_antecipado_v3 DATE
  ,f_cartera_v3 DATE
  ,f_cartera_fin_mes_dt_v3 DATE
  ,acc_status STRING
  ,acc_status_det STRING
  ,deuda_v3 NUMERIC
  ,dpd_v3 INT64
  ,deuda_over30_m_1_v3 NUMERIC
  ,deuda_m_1_v3 NUMERIC
  ,dpd_m_1_v3 INT64
  ,deuda_over30_m_2_v3 NUMERIC
  ,deuda_m_2_v3 NUMERIC
  ,dpd_m_2_v3 INT64
  ,deuda_over30_m_3_v3 NUMERIC
  ,deuda_m_3_v3 NUMERIC
  ,dpd_m_3_v3 INT64
  ,deuda_over30_m1_v3 NUMERIC
  ,deuda_m1_v3 NUMERIC
  ,dpd_m1_v3 INT64
  ,deuda_over30_m2_v3 NUMERIC
  ,deuda_m2_v3 NUMERIC
  ,dpd_m2_v3 INT64
  ,deuda_over30_m3_v3 NUMERIC
  ,deuda_m3_v3 NUMERIC
  ,dpd_m3_v3 INT64
  ,deuda_over30_m4_v3 NUMERIC
  ,deuda_m4_v3 NUMERIC
  ,dpd_m4_v3 INT64
  ,deuda_over30_m5_v3 NUMERIC
  ,deuda_m5_v3 NUMERIC
  ,dpd_m5_v3 INT64
  ,deuda_over30_m6_v3 NUMERIC
  ,deuda_m6_v3 NUMERIC
  ,dpd_m6_v3 INT64
  ,deuda_over30_m7_v3 NUMERIC
  ,deuda_m7_v3 NUMERIC
  ,dpd_m7_v3 INT64
  ,deuda_over30_m8_v3 NUMERIC
  ,deuda_m8_v3 NUMERIC
  ,dpd_m8_v3 INT64
  ,deuda_over30_m9_v3 NUMERIC
  ,deuda_m9_v3 NUMERIC
  ,dpd_m9_v3 INT64
  ,deuda_over30_m10_v3 NUMERIC
  ,deuda_m10_v3 NUMERIC
  ,dpd_m10_v3 INT64
  ,deuda_over30_m11_v3 NUMERIC
  ,deuda_m11_v3 NUMERIC
  ,dpd_m11_v3 INT64
  ,deuda_over30_m12_v3 NUMERIC
  ,deuda_m12_v3 NUMERIC
  ,dpd_m12_v3 INT64
  ,tpv_m0_v3 NUMERIC
  ,tpv_m_1_v3 NUMERIC
  ,tpv_m_2_v3 NUMERIC
  ,tpv_m_3_v3 NUMERIC
  ,tpv_m1_v3 NUMERIC
  ,tpv_m2_v3 NUMERIC
  ,tpv_m3_v3 NUMERIC
  ,tpv_m4_v3 NUMERIC
  ,tpv_m5_v3 NUMERIC
  ,tpv_m6_v3 NUMERIC
  ,tpv_m7_v3 NUMERIC
  ,tpv_m8_v3 NUMERIC
  ,tpv_m9_v3 NUMERIC
  ,tpv_m10_v3 NUMERIC
  ,tpv_m11_v3 NUMERIC
  ,tpv_m12_v3 NUMERIC
  ,rating_bhv_tc_acc STRING
  ,rating_upsell_tc_acc STRING
  ,nise STRING
  ,renta_monto NUMERIC
  ,renta_source STRING
  ,nise_acc STRING
  ,renta_monto_acc NUMERIC
  ,renta_source_acc STRING
  ,grupo_riesgo INT64
  ,nivel_riesgo STRING
  ,flag_sellers INT64
  ,f_emision_dt DATE
  ,porc_uso_real_tc NUMERIC
  ,rci_real_tc NUMERIC
  ,rci_teorico_tc NUMERIC
  ,rci_real_cc NUMERIC
  ,rci_teorico_cc NUMERIC
  ,score_serasa NUMERIC
  ,score_bvs NUMERIC
  ,rating_externo STRING
  ,nivel_riesgo_externo STRING
  ,dt_base_scr DATE
  ,cant_ifs INT64
  ,deuda_30d_tc FLOAT64
  ,deuda_30d_clean FLOAT64
  ,deuda_30d_garantia FLOAT64
  ,deuda_30d_total FLOAT64
  ,deuda_all_tc FLOAT64
  ,deuda_all_clean FLOAT64
  ,deuda_all_garantia FLOAT64
  ,deuda_all_total FLOAT64
  ,deuda_venc_over00_clean FLOAT64
  ,deuda_venc_over00_tc FLOAT64
  ,deuda_venc_over00_garantia FLOAT64
  ,deuda_venc_over00_total FLOAT64
  ,deuda_venc_over30_tc FLOAT64
  ,deuda_venc_over30_clean FLOAT64
  ,deuda_venc_over30_garantia FLOAT64
  ,deuda_venc_over30_total FLOAT64
  ,limite_usado NUMERIC
  ,status_tc STRING
  ,flag_fraude_ito INT64
  ,rci_conj NUMERIC
  ,porc_iu_pre NUMERIC
  ,porc_iu_post NUMERIC
  ,campaign_group_trat STRING
)
partition by f_mes_acc_carga
cluster by policy_category
;

insert into `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PECASTANHO` (
   campaign_id
  ,f_acc_carga
  ,f_mes_acc_carga
  ,f_acc_impacto
  ,risk_id
  ,audiencia
  ,produto
  ,policy
  ,policy_category
  ,policy_subcategory
  ,control_group_flag
  ,campaign_group
  ,user_id
  ,limit_amount_tc_acc_post
  ,limit_amount_tc_acc_pre
  ,f_mes_vto_resumen_v3
  ,f_vto_resumen_max_v3
  ,monto_resumen_v3
  ,total_pago_v3
  ,pagado_antecipado_v3
  ,f_cartera_v3
  ,f_cartera_fin_mes_dt_v3
  ,acc_status
  ,acc_status_det
  ,deuda_v3
  ,dpd_v3
  ,deuda_over30_m_1_v3
  ,deuda_m_1_v3
  ,dpd_m_1_v3
  ,deuda_over30_m_2_v3
  ,deuda_m_2_v3
  ,dpd_m_2_v3
  ,deuda_over30_m_3_v3
  ,deuda_m_3_v3
  ,dpd_m_3_v3
  ,deuda_over30_m1_v3
  ,deuda_m1_v3
  ,dpd_m1_v3
  ,deuda_over30_m2_v3
  ,deuda_m2_v3
  ,dpd_m2_v3
  ,deuda_over30_m3_v3
  ,deuda_m3_v3
  ,dpd_m3_v3
  ,deuda_over30_m4_v3
  ,deuda_m4_v3
  ,dpd_m4_v3
  ,deuda_over30_m5_v3
  ,deuda_m5_v3
  ,dpd_m5_v3
  ,deuda_over30_m6_v3
  ,deuda_m6_v3
  ,dpd_m6_v3
  ,deuda_over30_m7_v3
  ,deuda_m7_v3
  ,dpd_m7_v3
  ,deuda_over30_m8_v3
  ,deuda_m8_v3
  ,dpd_m8_v3
  ,deuda_over30_m9_v3
  ,deuda_m9_v3
  ,dpd_m9_v3
  ,deuda_over30_m10_v3
  ,deuda_m10_v3
  ,dpd_m10_v3
  ,deuda_over30_m11_v3
  ,deuda_m11_v3
  ,dpd_m11_v3
  ,deuda_over30_m12_v3
  ,deuda_m12_v3
  ,dpd_m12_v3
  ,tpv_m0_v3
  ,tpv_m_1_v3
  ,tpv_m_2_v3
  ,tpv_m_3_v3
  ,tpv_m1_v3
  ,tpv_m2_v3
  ,tpv_m3_v3
  ,tpv_m4_v3
  ,tpv_m5_v3
  ,tpv_m6_v3
  ,tpv_m7_v3
  ,tpv_m8_v3
  ,tpv_m9_v3
  ,tpv_m10_v3
  ,tpv_m11_v3
  ,tpv_m12_v3
  ,rating_bhv_tc_acc
  ,rating_upsell_tc_acc
  ,nise
  ,renta_monto
  ,renta_source
  ,nise_acc
  ,renta_monto_acc
  ,renta_source_acc
  ,grupo_riesgo
  ,nivel_riesgo
  ,flag_sellers
  ,f_emision_dt
  ,porc_uso_real_tc
  ,rci_real_tc
  ,rci_teorico_tc
  ,rci_real_cc
  ,rci_teorico_cc
  ,score_serasa
  ,score_bvs
  ,rating_externo
  ,nivel_riesgo_externo
  ,dt_base_scr
  ,cant_ifs
  ,deuda_30d_tc
  ,deuda_30d_clean
  ,deuda_30d_garantia
  ,deuda_30d_total
  ,deuda_all_tc
  ,deuda_all_clean
  ,deuda_all_garantia
  ,deuda_all_total
  ,deuda_venc_over00_clean
  ,deuda_venc_over00_tc
  ,deuda_venc_over00_garantia
  ,deuda_venc_over00_total
  ,deuda_venc_over30_tc
  ,deuda_venc_over30_clean
  ,deuda_venc_over30_garantia
  ,deuda_venc_over30_total
  ,limite_usado
  ,status_tc
  ,flag_fraude_ito
  ,rci_conj
  ,porc_iu_pre
  ,porc_iu_post
  ,campaign_group_trat
)
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PECASTANHO_TMP`
;