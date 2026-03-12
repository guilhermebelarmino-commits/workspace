--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------- Step 2 -------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

declare f_start date;
declare f_start_m_1 date;
set f_start = (select min(f_mes_acc_carga) from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_1_PECASTANHO`);
set f_start_m_1 = date(f_start - interval 1 month);


create or replace temp table RBA_TC_BACKTEST
as
select
  * except(rating_bhv_tc_acc)
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_1_PECASTANHO`
;

create or replace temp table VU_MODEL_RATING_BHV
as
select
   valid_from_dt
  ,valid_to_dt
  ,cus_cust_id as user_id
  ,crd_version
  ,internal_rating_tag as rating_bhv_tc_acc
  ,crd_score
from `WHOWNER.BT_VU_MODEL_RATING`
where 1=1
  and sit_site_id = 'MLB'
  and crd_model = 'CONSUMERS_BEHAVIOR_CREDIT_CARD'
  and valid_to_dt >= f_start
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table VU_MODEL_RATING_UPSELL
as
select
   valid_from_dt
  ,valid_to_dt
  ,cus_cust_id as user_id
  ,crd_version
  ,internal_rating_tag as rating_upsell_tc_acc
  ,crd_score
from `WHOWNER.BT_VU_MODEL_RATING`
where 1=1
  and sit_site_id = 'MLB'
  and crd_model = 'CONSUMERS_UPSELL_TC'
  and valid_to_dt >= f_start
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table VU_ASSUMED_INCOME
as
select
   valid_from_dt
  ,valid_to_dt
  ,cus_cust_id as user_id
  ,case when valid_to_dt >= date('2024-07-01') then
    case
      when regexp_contains(modeling_income_nise_tag, 'PLATINUM') then concat('a. ', modeling_income_nise_tag)
      when regexp_contains(modeling_income_nise_tag, 'GOLD') then concat('b. ', modeling_income_nise_tag)
      when regexp_contains(modeling_income_nise_tag, 'SILVER') then concat('c. ', modeling_income_nise_tag)
      when regexp_contains(modeling_income_nise_tag, 'BRONZE') then concat('d. ', modeling_income_nise_tag)
      else 'e. OTROS' end
  else null end as nise
  ,case when valid_to_dt >= date('2024-07-01') then modeling_income_amt else null end as renta_monto
  ,case when valid_to_dt >= date('2024-07-01') then modeling_income_source_tag else null end as renta_source
  ,case
    when regexp_contains(nise_tag, 'PLATINUM') then concat('a. ', nise_tag)
    when regexp_contains(nise_tag, 'GOLD') then concat('b. ', nise_tag)
    when regexp_contains(nise_tag, 'SILVER') then concat('c. ', nise_tag)
    when regexp_contains(nise_tag, 'BRONZE') then concat('d. ', nise_tag)
    else 'e. OTROS' end as nise_acc
  ,assumed_income_amt as renta_monto_acc
  ,assumed_income_source_tag as renta_source_acc
from `WHOWNER.BT_VU_ASSUMED_INCOME` 
where 1=1
  and sit_site_id = 'MLB'
  and valid_to_dt >= f_start
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table VU_ASSUMED_INCOME_MDL
as
select
   valid_from_dt
  ,valid_to_dt
  ,user_id
  ,nise
  ,renta_monto
  ,renta_source
from VU_ASSUMED_INCOME
where 1=1
  and nise is not null
qualify row_number() over (partition by user_id order by valid_from_dt asc) = 1
;

create or replace temp table VU_PROSPECT
as
select
   valid_from_dt
  ,valid_to_dt
  ,cus_cust_id as user_id
  ,case when risk_management_tag = 'MERCHANT' then 1 else 0 end as flag_sellers
from `WHOWNER.LK_VU_PROSPECT_UNIVERSE`
where 1=1
  and sit_site_id = 'MLB'
  and valid_to_dt >= f_start
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table BI_CCARD_ACCOUNT
as
select
   cus_cust_id as user_id
  ,date(ccard_account_creation_dt) as f_emision_dt
from `WHOWNER.BT_CCARD_ACCOUNT`
where 1=1
  and sit_site_id = 'MLB'
  and ccard_account_prov_id is not null
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table VU_RCI_TC
as
select
   valid_from_dt
  ,valid_to_dt
  ,cus_cust_id as user_id
  ,real_use_level_val as porc_uso_real_tc
  ,real_rci_val as rci_real_tc
  ,teoric_rci_val as rci_teorico_tc
from `WHOWNER.BT_VU_RCI`
where 1=1
  and sit_site_id = 'MLB'
  and crd_prod_def_type_sk = 3
  and valid_to_dt >= f_start
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table VU_RCI_CC
as
select
   valid_from_dt
  ,valid_to_dt
  ,cus_cust_id as user_id
  ,real_rci_val as rci_real_cc
  ,teoric_rci_val as rci_teorico_cc
from `WHOWNER.BT_VU_RCI`
where 1=1
  and sit_site_id = 'MLB'
  and crd_prod_def_type_sk = 2
  and valid_to_dt >= f_start
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table VU_BUREAU
as
select
   period_dt as f_cartera
  ,cus_cust_id as user_id
  ,serasa_score_val as score_serasa
  ,bvs_score_val as score_bvs
from `WHOWNER.BT_VU_PRESUMED_INCOME`
where 1=1
  and sit_site_id = 'MLB'
  and period_dt >= f_start_m_1
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table VU_CREDIT
as
select
   valid_from_dt
  ,valid_to_dt
  ,cus_cust_id as user_id
  ,balance_amt as limite_usado
  ,crd_credit_status as status_tc
from `WHOWNER.BT_VU_CREDIT`
where 1=1
  and sit_site_id = 'MLB'
  and crd_prod_def_type_sk = 3
  and crd_credit_status not in ('PENDING','CANCELLED','PRECANCELLED','DEFAULTED','DISCARDED')
  and valid_to_dt >= f_start
  and cus_cust_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table RBA_CROSS_SCR
as
select
   valid_from_dt
  ,valid_to_dt
  ,dt_base_scr
  ,user_id
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
from `SBOX_CREDITS_SB.RBA_CROSS_MLB_SCR_CARTERA_PECASTANHO`
where 1=1
  and valid_to_dt >= f_start_m_1
;

create or replace temp table JOINS
as
select
   acc.*
  -- / --
  ,bhv.rating_bhv_tc_acc
  ,upsell.rating_upsell_tc_acc
  ,coalesce(renta.nise, renta_hist.nise) as nise
  ,coalesce(renta.renta_monto, renta_hist.renta_monto) as renta_monto
  ,coalesce(renta.renta_source, renta_hist.renta_source) as renta_source
  ,renta.nise_acc
  ,renta.renta_monto_acc
  ,renta.renta_source_acc
  ,safe_cast(clasif.clasif as int64) as grupo_riesgo
  ,coalesce(clasif.nivel_riesgo, "z. Sin rating") as nivel_riesgo
  ,sellers.flag_sellers
  ,ccard.* except(user_id)
  ,rci_tc.* except(valid_from_dt, valid_to_dt, user_id)
  ,rci_cc.* except(valid_from_dt, valid_to_dt, user_id)
  ,scores.* except(f_cartera, user_id)
  ,coalesce(param.rating_externo, 'G') as rating_externo
  ,case
    when coalesce(param.rating_externo, 'G') in ('A','B') then 'a. Muy bajo'
    when coalesce(param.rating_externo, 'G') in ('C') then 'b. Bajo'
    when coalesce(param.rating_externo, 'G') in ('D','E') then 'c. Medio'
    when coalesce(param.rating_externo, 'G') in ('F') then 'd. Alto'
    when coalesce(param.rating_externo, 'G') in ('G') then 'e. Muy alto'
    else 'f. Otros' end as nivel_riesgo_externo
  ,scr.* except(user_id, valid_from_dt, valid_to_dt)
  ,crd.* except(user_id, valid_from_dt, valid_to_dt)
  ,if(ito.cus_cust_id is not null, 1, 0) as flag_fraude_ito
from RBA_TC_BACKTEST acc
left join VU_MODEL_RATING_BHV bhv
  on acc.user_id = bhv.user_id
  and acc.f_acc_carga between bhv.valid_from_dt and bhv.valid_to_dt
left join VU_MODEL_RATING_UPSELL upsell
  on acc.user_id = upsell.user_id
  and acc.f_acc_carga between upsell.valid_from_dt and upsell.valid_to_dt
left join VU_ASSUMED_INCOME renta
  on acc.user_id = renta.user_id
  and (acc.f_acc_carga >= renta.valid_from_dt and acc.f_acc_carga < renta.valid_to_dt)
left join VU_ASSUMED_INCOME_MDL renta_hist
  on acc.user_id = renta_hist.user_id
left join VU_PROSPECT sellers
  on acc.user_id = sellers.user_id
  and (acc.f_acc_carga >= sellers.valid_from_dt and acc.f_acc_carga < sellers.valid_to_dt)
left join BI_CCARD_ACCOUNT ccard
  on acc.user_id = ccard.user_id
left join VU_RCI_TC rci_tc
  on acc.user_id = rci_tc.user_id
  and (acc.f_acc_carga >= rci_tc.valid_from_dt and acc.f_acc_carga < rci_tc.valid_to_dt)
left join VU_RCI_CC rci_cc
  on acc.user_id = rci_cc.user_id
  and (acc.f_acc_carga >= rci_cc.valid_from_dt and acc.f_acc_carga < rci_cc.valid_to_dt)
left join `SBOX_CREDITS_SB.RBA_TC_MLB_CLASIF_BHV_UPSELL_PECASTANHO` clasif
  on bhv.rating_bhv_tc_acc = clasif.bhv
  and upsell.rating_upsell_tc_acc = clasif.upsell
  and acc.f_mes_acc_carga between clasif.valid_from_dt and clasif.valid_to_dt
left join VU_BUREAU scores
  on acc.user_id = scores.user_id
  and acc.f_mes_acc_carga = scores.f_cartera
left join `meli-bi-data.SBOX_CREDITS_SB.PARAM_RATING_EXT_GERAL` param
  on (scores.score_serasa >= param.serasa_min and scores.score_serasa <= param.serasa_max)
  and (scores.score_bvs >= param.bvs_min and scores.score_bvs <= param.bvs_max)
left join VU_CREDIT crd
  on acc.user_id = crd.user_id
  and (acc.f_acc_carga >= crd.valid_from_dt and acc.f_acc_carga < crd.valid_to_dt)
left join `SBOX_COLLECTIONSDA.CCARD_MLB_USUARIOS_FRAUDE_DIC_2024` ito
  on acc.user_id = ito.cus_cust_id
left join RBA_CROSS_SCR scr
  on acc.user_id = scr.user_id
  and acc.f_acc_carga between scr.valid_from_dt and scr.valid_to_dt
group by all
;

create or replace temp table SAIDA
as
select
   *
  ,safe_divide(safe_add(safe_multiply(coalesce(greatest(rci_real_tc, rci_teorico_tc),0), coalesce(renta_monto_acc,0)), safe_multiply(coalesce(greatest(rci_real_cc, rci_teorico_cc),0), coalesce(renta_monto_acc,0))), renta_monto_acc) as rci_conj
  ,safe_divide(limite_usado, limit_amount_tc_acc_pre) as porc_iu_pre
  ,safe_divide(limite_usado, limit_amount_tc_acc_post) as porc_iu_post
from JOINS
;

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO_TMP`
options (
  expiration_timestamp = timestamp_add(current_timestamp(), interval 24 hour)
)
as
select
  *
from SAIDA
;

drop table if exists `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO`;

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO`
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
)
partition by f_mes_acc_carga
cluster by policy_category
;

insert into `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO` (
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
)
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO_TMP`
;