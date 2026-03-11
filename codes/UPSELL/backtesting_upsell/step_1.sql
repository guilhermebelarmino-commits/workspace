declare f_start date;
declare f_start_m_1 date;
declare f_start_num int64;
set f_start = date('2024-01-01');
set f_start_m_1 = date(f_start - interval 1 month);
set f_start_num = (select cast(format_date('%Y%m', f_start) as int64));


create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO`
as
with
fonte00 as ( -- accionable
  select
     a.campaign_id
    ,date(b.campaign_date) as f_acc_carga
    ,date(date_trunc(b.campaign_date, month)) as f_mes_acc_carga
    ,date(date(b.campaign_date) + interval 3 day) as f_acc_impacto
    ,b.policy
    ,b.policy_category
    ,b.policy_subcategory
    ,a.campaign_group
    ,a.cus_cust_id as user_id
    ,a.rating_bhv_tc as rating_bhv_tc_acc
    ,a.amount as limit_amount_tc_acc_post
    ,a.prev_amount as limit_amount_tc_acc_pre
  from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA` a
  inner join `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` b 
    on a.campaign_id = b.campaign_id
  where 1=1
    and b.sit_site_id = 'MLB'
    and b.negocio in ('TC', 'IND', 'SEL')
    and b.product_desc in ('TC', 'TC FULL')
    and b.campaign_type ='UPSELL'
    and b.campaign_month >= f_start_num
    and policy_category not in ('POLITICA PREFERENCIAL', 'UPSELL A GRADUADOS', 'FLEXIBILIZACION DE REGLAS (MTC)', 'PREFERENCIAL')
),
fonte01 as ( -- cartera y over
  select
     m0.f_cartera
    ,m0.f_cartera_fin_mes_dt
    ,m0.user_id
    ,m0.dpd
    ,m0.deuda
    ,m0.deuda_over30
    ,m0.dpd_m1
    ,m0.deuda_m1
    ,if(m0.dpd_m1 >= 30, m0.deuda_m1, 0) as deuda_over30_m1
    ,m0.dpd_m2
    ,m0.deuda_m2
    ,m0.deuda_over30_m2
    ,m0.dpd_m3
    ,m0.deuda_m3
    ,m0.deuda_over30_m3
    ,m4.dpd as dpd_m4
    ,m4.deuda as deuda_m4
    ,m4.deuda_over30 as deuda_over30_m4
    ,m5.dpd as dpd_m5
    ,m5.deuda as deuda_m5
    ,m5.deuda_over30 as deuda_over30_m5
    ,m6.dpd as dpd_m6
    ,m6.deuda as deuda_m6
    ,m6.deuda_over30 as deuda_over30_m6
  from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m0
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m4
    on m0.user_id = m4.user_id
    and m0.f_cartera = (m4.f_cartera - interval 4 month)
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m5
    on m0.user_id = m5.user_id
    and m0.f_cartera = (m5.f_cartera - interval 5 month)
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m6
    on m0.user_id = m6.user_id
    and m0.f_cartera = (m6.f_cartera - interval 6 month)
  where 1=1
    and m0.user_id in (select distinct user_id from fonte00)
    and m0.f_cartera >= f_start_m_1
),
fonte02 as ( -- VTG
  with
  fonte02_0 as (
    select
       cus_cust_id as user_id
      ,date(close_date) as f_cierre_resumen
      ,date(f_vto_resumen) as f_vto_resumen
      ,coalesce(monto_resumen,0) as monto_resumen
      ,coalesce(sum_consumos,0) as sum_consumos
      ,coalesce(consumos_futuros,0) as consumos_futuros
      ,coalesce(total_pago,0) as total_pago
      ,coalesce(ajuste_cbk_fraud,0) as ajuste_cbk_fraud
      ,coalesce(pagado_antes_del_cierre,0) as pagado_antes_del_cierre
      ,flag_default
      ,if(clasificacion_pago = 'Parcela Resumen', 1, 0) as flag_parcelo_resumen
      ,case when close_date < (date(current_date('-03') - interval '30' day)) then ((
      coalesce(monto_resumen,0) +
      coalesce(consumos_futuros,0) -
      coalesce(ajuste_cbk_fraud,0) -
      coalesce(total_pago,0)) * flag_default) else null end as monto_default_num
      ,case when close_date < (date(current_date('-03') - interval '30' day)) then (
      coalesce(consumos_futuros,0) +
      coalesce(monto_resumen,0) -
      coalesce(ajuste_cbk_fraud,0) +
      coalesce(pagado_antes_del_cierre,0)) else null end as monto_default_den
      ,(coalesce(consumos_futuros,0) + coalesce(monto_resumen,0) + coalesce(pagado_antes_del_cierre,0) - coalesce(ajuste_cbk_fraud,0)) as total_consumos
    from `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.VIS_VU_VTG_TC_ENRIQUECIDA`
    where 1=1
      and sit_site_id = 'MLB'
      and cus_cust_id in (select distinct user_id from fonte00)
  ),
  fonte02_1 as (
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
      ,sum(monto_default_num) as monto_default_num
      ,sum(monto_default_den) as monto_default_den
      ,sum(coalesce(total_consumos,0)) as total_consumos
    from fonte02_0
    group by all
  ),
  fonte02_2 as (
    select
      m0.*
      ,m1.f_vto_resumen_max as f_vto_resumen_max_m1
      ,m1.cant_res as cant_res_m1
      ,m1.monto_resumen as monto_resumen_m1
      ,m1.sum_consumos as sum_consumos_m1
      ,m1.consumos_futuros as consumos_futuros_m1
      ,m1.total_pago as total_pago_m1
      ,m1.ajuste_cbk_fraud as ajuste_cbk_fraud_m1
      ,m1.pagado_antecipado as pagado_antecipado_m1
      ,m1.flag_default as flag_default_m1
      ,m1.flag_parcelo_resumen as flag_parcelo_resumen_m1
      ,m1.monto_default_num as monto_default_num_m1
      ,m1.monto_default_den as monto_default_den_m1
      ,m1.total_consumos as total_consumos_m1
      ,m2.f_vto_resumen_max as f_vto_resumen_max_m2
      ,m2.cant_res as cant_res_m2
      ,m2.monto_resumen as monto_resumen_m2
      ,m2.sum_consumos as sum_consumos_m2
      ,m2.consumos_futuros as consumos_futuros_m2
      ,m2.total_pago as total_pago_m2
      ,m2.ajuste_cbk_fraud as ajuste_cbk_fraud_m2
      ,m2.pagado_antecipado as pagado_antecipado_m2
      ,m2.flag_default as flag_default_m2
      ,m2.flag_parcelo_resumen as flag_parcelo_resumen_m2
      ,m2.monto_default_num as monto_default_num_m2
      ,m2.monto_default_den as monto_default_den_m2
      ,m2.total_consumos as total_consumos_m2
      ,m3.cant_res as cant_res_m3
      ,m3.monto_resumen as monto_resumen_m3
      ,m3.sum_consumos as sum_consumos_m3
      ,m3.consumos_futuros as consumos_futuros_m3
      ,m3.total_pago as total_pago_m3
      ,m3.ajuste_cbk_fraud as ajuste_cbk_fraud_m3
      ,m3.pagado_antecipado as pagado_antecipado_m3
      ,m3.flag_default as flag_default_m3
      ,m3.flag_parcelo_resumen as flag_parcelo_resumen_m3
      ,m3.monto_default_num as monto_default_num_m3
      ,m3.monto_default_den as monto_default_den_m3
      ,m3.total_consumos as total_consumos_m3
    from fonte02_1 m0
    left join fonte02_1 m1
      on m0.user_id = m1.user_id
      and m0.f_mes_vto_resumen = (m1.f_mes_vto_resumen - interval '1' month)
    left join fonte02_1 m2
      on m0.user_id = m2.user_id
      and m0.f_mes_vto_resumen = (m2.f_mes_vto_resumen - interval '2' month)
    left join fonte02_1 m3
      on m0.user_id = m3.user_id
      and m0.f_mes_vto_resumen = (m3.f_mes_vto_resumen - interval '3' month)
  )
  select
    *
  from fonte02_2
),
fonte03 as ( -- purchase
  with
  temp00 as (
    select
       date_trunc(ccard_purch_op_dt, month) as f_mes
      ,cus_cust_id as user_id
      ,sum(ccard_purch_op_amt_lc) as tpv_m0
    from `WHOWNER.BT_CCARD_PURCHASE`
    where 1=1
      and cus_cust_id in (select distinct user_id from fonte00)
      and ccard_purch_op_status in ('processed','normal','pending')
      and sit_site_id = 'MLB'
      and ccard_purch_op_dt >= f_start_m_1
    group by all
  ),
  temp01 as (
    select
       m0.*
      ,m1.tpv_m0 as tpv_m1
      ,m2.tpv_m0 as tpv_m2
      ,m3.tpv_m0 as tpv_m3
      ,m4.tpv_m0 as tpv_m4
      ,m5.tpv_m0 as tpv_m5
      ,m6.tpv_m0 as tpv_m6
    from temp00 m0
    left join temp00 m1
      on m0.user_id = m1.user_id
      and m0.f_mes = (m1.f_mes - interval 1 month)
    left join temp00 m2
      on m0.user_id = m2.user_id
      and m0.f_mes = (m2.f_mes - interval 2 month)
    left join temp00 m3
      on m0.user_id = m3.user_id
      and m0.f_mes = (m3.f_mes - interval 3 month)
    left join temp00 m4
      on m0.user_id = m4.user_id
      and m0.f_mes = (m4.f_mes - interval 4 month)
    left join temp00 m5
      on m0.user_id = m5.user_id
      and m0.f_mes = (m5.f_mes - interval 5 month)
    left join temp00 m6
      on m0.user_id = m6.user_id
      and m0.f_mes = (m6.f_mes - interval 6 month)
  )
  select
    *
  from temp01
),
joins00 as (
  select
    acc.*
    -- / --
    ,vtg.* except(user_id)
    ,vtg_v2.f_mes_vto_resumen as f_mes_vto_resumen_v2
    ,vtg_v2.f_vto_resumen_max as f_vto_resumen_max_v2
    ,vtg_v2.monto_default_num as monto_default_num_v2
    ,vtg_v2.monto_default_den as monto_default_den_v2
    ,vtg_v2.monto_default_num_m1 as monto_default_num_m1_v2
    ,vtg_v2.monto_default_den_m1 as monto_default_den_m1_v2
    ,vtg_v2.total_consumos_m1 as total_consumos_m1_v2
    ,vtg_v2.monto_default_num_m2 as monto_default_num_m2_v2
    ,vtg_v2.monto_default_den_m2 as monto_default_den_m2_v2
    ,vtg_v2.total_consumos_m2 as total_consumos_m2_v2
    ,vtg_v3.f_mes_vto_resumen as f_mes_vto_resumen_v3
    ,vtg_v3.f_vto_resumen_max as f_vto_resumen_max_v3
    ,vtg_v3.monto_default_num as monto_default_num_v3
    ,vtg_v3.monto_default_den as monto_default_den_v3
    ,vtg_v3.monto_default_num_m1 as monto_default_num_m1_v3
    ,vtg_v3.monto_default_den_m1 as monto_default_den_m1_v3
    ,vtg_v3.total_consumos_m1 as total_consumos_m1_v3
    ,vtg_v3.monto_default_num_m2 as monto_default_num_m2_v3
    ,vtg_v3.monto_default_den_m2 as monto_default_den_m2_v3
    ,vtg_v3.total_consumos_m2 as total_consumos_m2_v3
    -- / --
    ,cart.* except(user_id)
    ,cart_v2.f_cartera as f_cartera_v2
    ,cart_v2.f_cartera_fin_mes_dt as f_cartera_fin_mes_dt_v2
    ,cart_v2.deuda as deuda_v2
    ,cart_v2.dpd as dpd_v2
    ,cart_v2.deuda_over30_m1 as deuda_over30_m1_v2
    ,cart_v2.deuda_m1 as deuda_m1_v2
    ,cart_v2.deuda_over30_m2 as deuda_over30_m2_v2
    ,cart_v2.deuda_m2 as deuda_m2_v2
    ,cart_v2.deuda_over30_m3 as deuda_over30_m3_v2
    ,cart_v2.deuda_m3 as deuda_m3_v2
    ,cart_v2.deuda_over30_m4 as deuda_over30_m4_v2
    ,cart_v2.deuda_m4 as deuda_m4_v2
    ,cart_v2.deuda_over30_m5 as deuda_over30_m5_v2
    ,cart_v2.deuda_m5 as deuda_m5_v2
    ,cart_v2.deuda_over30_m6 as deuda_over30_m6_v2
    ,cart_v2.deuda_m6 as deuda_m6_v2
    ,cart_v3.f_cartera as f_cartera_v3
    ,cart_v3.f_cartera_fin_mes_dt as f_cartera_fin_mes_dt_v3
    ,cart_v3.deuda as deuda_v3
    ,cart_v3.dpd as dpd_v3
    ,cart_v3.deuda_over30_m1 as deuda_over30_m1_v3
    ,cart_v3.deuda_m1 as deuda_m1_v3
    ,cart_v3.deuda_over30_m2 as deuda_over30_m2_v3
    ,cart_v3.deuda_m2 as deuda_m2_v3
    ,cart_v3.deuda_over30_m3 as deuda_over30_m3_v3
    ,cart_v3.deuda_m3 as deuda_m3_v3
    ,cart_v3.deuda_over30_m4 as deuda_over30_m4_v3
    ,cart_v3.deuda_m4 as deuda_m4_v3
    ,cart_v3.deuda_over30_m5 as deuda_over30_m5_v3
    ,cart_v3.deuda_m5 as deuda_m5_v3
    ,cart_v3.deuda_over30_m6 as deuda_over30_m6_v3
    ,cart_v3.deuda_m6 as deuda_m6_v3
     -- / --
    ,purch.* except(user_id, f_mes)
    ,purch_v2.tpv_m0 as tpv_m0_v2
    ,purch_v2.tpv_m1 as tpv_m1_v2
    ,purch_v2.tpv_m2 as tpv_m2_v2
    ,purch_v2.tpv_m3 as tpv_m3_v2
    ,purch_v2.tpv_m4 as tpv_m4_v2
    ,purch_v2.tpv_m5 as tpv_m5_v2
    ,purch_v2.tpv_m6 as tpv_m6_v2
    ,purch_v3.tpv_m0 as tpv_m0_v3
    ,purch_v3.tpv_m1 as tpv_m1_v3
    ,purch_v3.tpv_m2 as tpv_m2_v3
    ,purch_v3.tpv_m3 as tpv_m3_v3
    ,purch_v3.tpv_m4 as tpv_m4_v3
    ,purch_v3.tpv_m5 as tpv_m5_v3
    ,purch_v3.tpv_m6 as tpv_m6_v3
  from fonte00 acc
  left join fonte02 res
    on acc.user_id = res.user_id
    and acc.f_mes_acc_carga = res.f_mes_vto_resumen
  left join fonte02 vtg
    on acc.user_id = vtg.user_id
    and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_vto_resumen_max then vtg.f_mes_vto_resumen else (vtg.f_mes_vto_resumen + interval 1 month) end
  left join fonte02 vtg_v2
    on acc.user_id = vtg_v2.user_id
    and acc.f_mes_acc_carga = vtg_v2.f_mes_vto_resumen
  left join fonte02 vtg_v3
    on acc.user_id = vtg_v3.user_id
    and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_cierre_resumen_max then vtg_v3.f_mes_vto_resumen else (vtg_v3.f_mes_vto_resumen + interval 1 month) end
  left join fonte01 cart
    on acc.user_id = cart.user_id
    and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_vto_resumen_max then cart.f_cartera else (cart.f_cartera + interval 1 month) end
  left join fonte01 cart_v2
    on acc.user_id = cart_v2.user_id
    and acc.f_mes_acc_carga = cart_v2.f_cartera
  left join fonte01 cart_v3
    on acc.user_id = cart_v3.user_id
    and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_cierre_resumen_max then cart_v3.f_cartera else (cart_v3.f_cartera + interval 1 month) end
  left join fonte03 purch
    on acc.user_id = purch.user_id
    and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_vto_resumen_max then purch.f_mes else (purch.f_mes + interval 1 month) end
  left join fonte03 purch_v2
    on acc.user_id = purch_v2.user_id
    and acc.f_mes_acc_carga = purch_v2.f_mes
  left join fonte03 purch_v3
    on acc.user_id = purch_v3.user_id
    and acc.f_mes_acc_carga = case when acc.f_acc_impacto >= res.f_cierre_resumen_max then purch_v3.f_mes else (purch_v3.f_mes + interval 1 month) end
)
select distinct
  *
from joins00
;