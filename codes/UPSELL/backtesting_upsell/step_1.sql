--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------- Step 1 -------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

declare f_start date;
declare f_start_m_1 date;
declare f_start_num int64;
set f_start = date('2024-01-01');
set f_start_m_1 = date(f_start - interval 1 month);
set f_start_num = (select cast(format_date('%Y%m', f_start) as int64));

create or replace temp table RBA_TC_ACCIONABLES
as
select
   campaign_id
  ,date(actionable_dt) as f_acc_carga
  ,date(date_trunc(actionable_dt, month)) as f_mes_acc_carga
  ,date(date(actionable_dt) + interval 3 day) as f_acc_impacto
  ,risk_id
  ,split(risk_id, '-')[safe_offset(2)] as audiencia
  ,split(risk_id, '-')[safe_offset(3)] as produto
  ,campaign_desc as policy
  ,split(risk_id, '-')[safe_offset(6)] as policy_category
  ,campaign_policy_subcategory_desc as policy_subcategory
  ,control_group_flag
  ,if(control_group_flag, 'CONTROL', 'IMPACTO') as campaign_group
  ,cus_cust_id as user_id
  ,null as rating_bhv_tc_acc
  ,limite_post as limit_amount_tc_acc_post
  ,limite_prev as limit_amount_tc_acc_pre
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_SEGUIMIENTO_UPSELL_DOWNSELL_VU_CAMPAIGN_GUBELARMINO`
where 1=1
  and split(risk_id, '-')[safe_offset(4)] = 'UPSELL'
  and actionable_dt >= f_start
  and campaign_desc is not null
;

create or replace temp table RBA_TC_CARTERA_OVER
as
select
   f_cartera
  ,f_cartera_fin_mes_dt
  ,user_id
  ,dpd
  ,deuda
  ,deuda_over30
  ,dpd_m_1
  ,deuda_m_1
  ,deuda_over30_m_1
  ,dpd_m_2
  ,deuda_m_2
  ,deuda_over30_m_2
  ,dpd_m_3
  ,deuda_m_3
  ,deuda_over30_m_3
  ,dpd_m1
  ,deuda_m1
  ,deuda_over30_m1
  ,dpd_m2
  ,deuda_m2
  ,deuda_over30_m2
  ,dpd_m3
  ,deuda_m3
  ,deuda_over30_m3
  ,dpd_m4
  ,deuda_m4
  ,deuda_over30_m4
  ,dpd_m5
  ,deuda_m5
  ,deuda_over30_m5
  ,dpd_m6
  ,deuda_m6
  ,deuda_over30_m6
  ,dpd_m7
  ,deuda_m7
  ,deuda_over30_m7
  ,dpd_m8
  ,deuda_m8
  ,deuda_over30_m8
  ,dpd_m9
  ,deuda_m9
  ,deuda_over30_m9
  ,dpd_m10
  ,deuda_m10
  ,deuda_over30_m10
  ,dpd_m11
  ,deuda_m11
  ,deuda_over30_m11
  ,dpd_m12
  ,deuda_m12
  ,deuda_over30_m12
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO`
where 1=1
  and user_id in (select distinct user_id from RBA_TC_ACCIONABLES)
  and f_cartera >= f_start_m_1
;

create or replace temp table RBA_TC_VTG
as
with
temp00 as (
  select
     cus_cust_id as user_id
    ,date(close_dt) as f_cierre_resumen
    ,date(summary_due_dt) as f_vto_resumen
    ,coalesce(summary_amt,0) as monto_resumen
    ,coalesce(consumption_amt,0) as sum_consumos
    ,coalesce(future_consumption_amt,0) as consumos_futuros
    ,coalesce(total_payment_amt,0) as total_pago
    ,coalesce(chargeback_fraud_adjustment_amt,0) as ajuste_cbk_fraud
    ,coalesce(paid_before_close_amt,0) as pagado_antes_del_cierre
    ,default_flag as flag_default
    ,if(payment_status_tag = 'Parcela Resumen', 1, 0) as flag_parcelo_resumen
  from `meli-bi-data.WHOWNER.BT_VU_VIS_VINTAGE_TC`
  where 1=1
    and sit_site_id = 'MLB'
    and cus_cust_id in (select distinct user_id from RBA_TC_ACCIONABLES)
),
temp01 as (
  select
    user_id
    ,date_trunc(f_vto_resumen, month) as f_mes_vto_resumen
    ,max(f_cierre_resumen) as f_cierre_resumen_max
    ,max(f_vto_resumen) as f_vto_resumen_max
    ,count(1) as cant_res
    ,sum(coalesce(monto_resumen,0)) as monto_resumen
    ,sum(coalesce(sum_consumos,0)) as sum_consumos
    ,sum(coalesce(consumos_futuros,0)) as consumos_futuros
    ,sum(coalesce(total_pago,0)) as total_pago
    ,sum(coalesce(ajuste_cbk_fraud,0)) as ajuste_cbk_fraud
    ,sum(coalesce(pagado_antes_del_cierre,0)) as pagado_antecipado
    ,max(flag_default) as flag_default
    ,max(flag_parcelo_resumen) as flag_parcelo_resumen
  from temp00
  group by all
)
select
  *
from temp01
;

create or replace temp table BI_PURCHASE
as
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_TPV_PECASTANHO`
where 1=1
  and f_mes >= f_start_m_1
  and user_id in (select distinct user_id from RBA_TC_ACCIONABLES)
;

create or replace temp table JOINS
as
select
   acc.*
  -- / --
  ,vtg_v3.f_mes_vto_resumen as f_mes_vto_resumen_v3
  ,vtg_v3.f_vto_resumen_max as f_vto_resumen_max_v3
  ,vtg_v3.f_vto_resumen_max as monto_resumen_v3
  ,vtg_v3.f_vto_resumen_max as total_pago_v3
  ,vtg_v3.f_vto_resumen_max as pagado_antecipado_v3
  -- / --
  ,cart_v3.f_cartera as f_cartera_v3
  ,cart_v3.f_cartera_fin_mes_dt as f_cartera_fin_mes_dt_v3
  ,cart_v3.deuda as deuda_v3
  ,cart_v3.dpd as dpd_v3
  ,cart_v3.deuda_over30_m_1 as deuda_over30_m_1_v3
  ,cart_v3.deuda_m_1 as deuda_m_1_v3
  ,cart_v3.dpd_m_1 as dpd_m_1_v3
  ,cart_v3.deuda_over30_m_2 as deuda_over30_m_2_v3
  ,cart_v3.deuda_m_2 as deuda_m_2_v3
  ,cart_v3.dpd_m_2 as dpd_m_2_v3
  ,cart_v3.deuda_over30_m_3 as deuda_over30_m_3_v3
  ,cart_v3.deuda_m_3 as deuda_m_3_v3
  ,cart_v3.dpd_m_3 as dpd_m_3_v3
  ,cart_v3.deuda_over30_m1 as deuda_over30_m1_v3
  ,cart_v3.deuda_m1 as deuda_m1_v3
  ,cart_v3.dpd_m1 as dpd_m1_v3
  ,cart_v3.deuda_over30_m2 as deuda_over30_m2_v3
  ,cart_v3.deuda_m2 as deuda_m2_v3
  ,cart_v3.dpd_m2 as dpd_m2_v3
  ,cart_v3.deuda_over30_m3 as deuda_over30_m3_v3
  ,cart_v3.deuda_m3 as deuda_m3_v3
  ,cart_v3.dpd_m3 as dpd_m3_v3
  ,cart_v3.deuda_over30_m4 as deuda_over30_m4_v3
  ,cart_v3.deuda_m4 as deuda_m4_v3
  ,cart_v3.dpd_m4 as dpd_m4_v3
  ,cart_v3.deuda_over30_m5 as deuda_over30_m5_v3
  ,cart_v3.deuda_m5 as deuda_m5_v3
  ,cart_v3.dpd_m5 as dpd_m5_v3
  ,cart_v3.deuda_over30_m6 as deuda_over30_m6_v3
  ,cart_v3.deuda_m6 as deuda_m6_v3
  ,cart_v3.dpd_m6 as dpd_m6_v3
  ,cart_v3.deuda_over30_m7 as deuda_over30_m7_v3
  ,cart_v3.deuda_m7 as deuda_m7_v3
  ,cart_v3.dpd_m7 as dpd_m7_v3
  ,cart_v3.deuda_over30_m8 as deuda_over30_m8_v3
  ,cart_v3.deuda_m8 as deuda_m8_v3
  ,cart_v3.dpd_m8 as dpd_m8_v3
  ,cart_v3.deuda_over30_m9 as deuda_over30_m9_v3
  ,cart_v3.deuda_m9 as deuda_m9_v3
  ,cart_v3.dpd_m9 as dpd_m9_v3
  ,cart_v3.deuda_over30_m10 as deuda_over30_m10_v3
  ,cart_v3.deuda_m10 as deuda_m10_v3
  ,cart_v3.dpd_m10 as dpd_m10_v3
  ,cart_v3.deuda_over30_m11 as deuda_over30_m11_v3
  ,cart_v3.deuda_m11 as deuda_m11_v3
  ,cart_v3.dpd_m11 as dpd_m11_v3
  ,cart_v3.deuda_over30_m12 as deuda_over30_m12_v3
  ,cart_v3.deuda_m12 as deuda_m12_v3
  ,cart_v3.dpd_m12 as dpd_m12_v3
  
   -- / --
  ,purch_v3.tpv_m0 as tpv_m0_v3
  ,purch_v3.tpv_m_1 as tpv_m_1_v3
  ,purch_v3.tpv_m_2 as tpv_m_2_v3
  ,purch_v3.tpv_m_3 as tpv_m_3_v3
  ,purch_v3.tpv_m1 as tpv_m1_v3
  ,purch_v3.tpv_m2 as tpv_m2_v3
  ,purch_v3.tpv_m3 as tpv_m3_v3
  ,purch_v3.tpv_m4 as tpv_m4_v3
  ,purch_v3.tpv_m5 as tpv_m5_v3
  ,purch_v3.tpv_m6 as tpv_m6_v3
  ,purch_v3.tpv_m7 as tpv_m7_v3
  ,purch_v3.tpv_m8 as tpv_m8_v3
  ,purch_v3.tpv_m9 as tpv_m9_v3
  ,purch_v3.tpv_m10 as tpv_m10_v3
  ,purch_v3.tpv_m11 as tpv_m11_v3
  ,purch_v3.tpv_m12 as tpv_m12_v3
from RBA_TC_ACCIONABLES acc
left join RBA_TC_VTG res
  on acc.user_id = res.user_id
  and acc.f_mes_acc_carga = res.f_mes_vto_resumen
left join RBA_TC_VTG vtg_v3
  on acc.user_id = vtg_v3.user_id
  and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_cierre_resumen_max then vtg_v3.f_mes_vto_resumen else (vtg_v3.f_mes_vto_resumen + interval 1 month) end
left join RBA_TC_CARTERA_OVER cart_v3
  on acc.user_id = cart_v3.user_id
  and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_cierre_resumen_max then cart_v3.f_cartera else (cart_v3.f_cartera + interval 1 month) end
left join BI_PURCHASE purch_v3
  on acc.user_id = purch_v3.user_id
  and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_cierre_resumen_max then purch_v3.f_mes else (purch_v3.f_mes + interval 1 month) end
;


create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO_TMP`
options (
  expiration_timestamp = timestamp_add(current_timestamp(), interval 24 hour)
)
as
select
  *
from JOINS
;

drop table if exists `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO`;

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO`
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
  ,rating_bhv_tc_acc INT64
  ,limit_amount_tc_acc_post NUMERIC
  ,limit_amount_tc_acc_pre NUMERIC
  ,f_mes_vto_resumen_v3 DATE
  ,f_vto_resumen_max_v3 DATE
  ,monto_resumen_v3 DATE
  ,total_pago_v3 DATE
  ,pagado_antecipado_v3 DATE
  ,f_cartera_v3 DATE
  ,f_cartera_fin_mes_dt_v3 DATE
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
)
partition by f_mes_acc_carga
cluster by policy_category
;

insert into `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO` (
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
  ,rating_bhv_tc_acc
  ,limit_amount_tc_acc_post
  ,limit_amount_tc_acc_pre
  ,f_mes_vto_resumen_v3
  ,f_vto_resumen_max_v3
  ,monto_resumen_v3
  ,total_pago_v3
  ,pagado_antecipado_v3
  ,f_cartera_v3
  ,f_cartera_fin_mes_dt_v3
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
)
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO_TMP`
;