------------------------------------------------------------------------------------
-------------- codigo para o dash de resultado (backtest) de downsell --------------
-------------------------- codigo automatizado no airflow --------------------------
------------------------------------------------------------------------------------

-- parte 1

declare f_start date;
declare f_start_m_1 date;
declare f_start_num int64;
set f_start = date('2023-06-01');
set f_start_m_1 = date(f_start - interval 1 month);
set f_start_num = (select cast(format_date('%Y%m', f_start) as int64));
create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_1_PECASTANHO`
as
with
fonte00 as ( -- accionable
  select
     a.campaign_id
    ,date(a.actionable_dttm) as f_acc_carga
    ,date(date_trunc(a.actionable_dttm, month)) as f_mes_acc_carga
    ,date(date(a.actionable_dttm) + interval 3 day) as f_acc_impacto
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
    and b.negocio = 'TC'
    and b.product_desc = 'TC'
    and b.campaign_type ='DOWNSELL'
    and b.campaign_month >= f_start_num
    -- and policy_category not in ('POLITICA PREFERENCIAL', 'UPSELL A GRADUADOS', 'FLEXIBILIZACION DE REGLAS (MTC)')
),
fonte01 as ( -- cartera y over
  select
     m0.f_cartera
    ,m0.f_cartera_fin_mes_dt
    ,m0.user_id
    ,m0.acc_status
    ,m0.acc_status_det
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
    ,m7.dpd as dpd_m7
    ,m7.deuda as deuda_m7
    ,m7.deuda_over30 as deuda_over30_m7
    ,m8.dpd as dpd_m8
    ,m8.deuda as deuda_m8
    ,m8.deuda_over30 as deuda_over30_m8
    ,m9.dpd as dpd_m9
    ,m9.deuda as deuda_m9
    ,m9.deuda_over30 as deuda_over30_m9
    ,m10.dpd as dpd_m10
    ,m10.deuda as deuda_m10
    ,m10.deuda_over30 as deuda_over30_m10
    ,m11.dpd as dpd_m11
    ,m11.deuda as deuda_m11
    ,m11.deuda_over30 as deuda_over30_m11
    ,m12.dpd as dpd_m12
    ,m12.deuda as deuda_m12
    ,m12.deuda_over30 as deuda_over30_m12
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
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m7
    on m0.user_id = m7.user_id
    and m0.f_cartera = (m7.f_cartera - interval 7 month)
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m8
    on m0.user_id = m8.user_id
    and m0.f_cartera = (m8.f_cartera - interval 8 month)
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m9
    on m0.user_id = m9.user_id
    and m0.f_cartera = (m9.f_cartera - interval 9 month)
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m10
    on m0.user_id = m10.user_id
    and m0.f_cartera = (m10.f_cartera - interval 10 month)
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m11
    on m0.user_id = m11.user_id
    and m0.f_cartera = (m11.f_cartera - interval 11 month)
  left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO` m12
    on m0.user_id = m12.user_id
    and m0.f_cartera = (m12.f_cartera - interval 12 month)
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
      ,m7.tpv_m0 as tpv_m7
      ,m8.tpv_m0 as tpv_m8
      ,m9.tpv_m0 as tpv_m9
      ,m10.tpv_m0 as tpv_m10
      ,m11.tpv_m0 as tpv_m11
      ,m12.tpv_m0 as tpv_m12
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
    left join temp00 m7
      on m0.user_id = m7.user_id
      and m0.f_mes = (m7.f_mes - interval 7 month)
    left join temp00 m8
      on m0.user_id = m8.user_id
      and m0.f_mes = (m8.f_mes - interval 8 month)
    left join temp00 m9
      on m0.user_id = m9.user_id
      and m0.f_mes = (m9.f_mes - interval 9 month)
    left join temp00 m10
      on m0.user_id = m10.user_id
      and m0.f_mes = (m10.f_mes - interval 10 month)
    left join temp00 m11
      on m0.user_id = m11.user_id
      and m0.f_mes = (m11.f_mes - interval 11 month)
    left join temp00 m12
      on m0.user_id = m12.user_id
      and m0.f_mes = (m12.f_mes - interval 12 month)
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
    ,cart_v3.deuda_over30_m7 as deuda_over30_m7_v3
    ,cart_v3.deuda_m7 as deuda_m7_v3
    ,cart_v3.deuda_over30_m8 as deuda_over30_m8_v3
    ,cart_v3.deuda_m8 as deuda_m8_v3
    ,cart_v3.deuda_over30_m9 as deuda_over30_m9_v3
    ,cart_v3.deuda_m9 as deuda_m9_v3
    ,cart_v3.deuda_over30_m10 as deuda_over30_m10_v3
    ,cart_v3.deuda_m10 as deuda_m10_v3
    ,cart_v3.deuda_over30_m11 as deuda_over30_m11_v3
    ,cart_v3.deuda_m11 as deuda_m11_v3
    ,cart_v3.deuda_over30_m12 as deuda_over30_m12_v3
    ,cart_v3.deuda_m12 as deuda_m12_v3
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
    ,purch_v3.tpv_m7 as tpv_m7_v3
    ,purch_v3.tpv_m8 as tpv_m8_v3
    ,purch_v3.tpv_m9 as tpv_m9_v3
    ,purch_v3.tpv_m10 as tpv_m10_v3
    ,purch_v3.tpv_m11 as tpv_m11_v3
    ,purch_v3.tpv_m12 as tpv_m12_v3
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



-- parte 2

declare f_start date;
declare f_start_m_1 date;
set f_start = (select min(f_mes_acc_carga) from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_1_PECASTANHO`);
set f_start_m_1 = date(f_start - interval 1 month);
create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO`
as
with
fonte00 as (
  select
    *
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_1_PECASTANHO`
),
fonte01 as ( -- modelo bhv
  select distinct
    sco.creation_date_dt as valid_from_dt
    ,coalesce(lag(sco.creation_date_dt-1) over (partition by sco.cus_cust_id_borrower order by sco.creation_date_dt desc), current_date('-03')) as valid_to_dt
    ,sco.cus_cust_id_borrower AS user_id
    ,sco.crd_version
    ,co.crd_internal_rating AS rating_behavior_tc_acc
    ,sco.crd_score
  from `WHOWNER.BT_CRD_CREDITS_RISK_SCORING` AS sco
  left join `SBOX_CREDITSSHARED.CC_PARAM_CUTOFFS` AS co
    on sco.crd_model = co.crd_model
    and sco.crd_score > co.crd_cutoff_value_min
    and sco.crd_score <= co.crd_cutoff_value_max
    and sco.crd_version = co.crd_version
  where 1=1
    and sco.sit_site_id = 'MLB'
    and sco.crd_model = 'consumers_behavior_credit_card'
    and co.crd_model = 'consumers_behavior_credit_card'
    and sco.creation_date_dt >= f_start
    and sco.cus_cust_id_borrower in (select distinct user_id from fonte00)
),
fonte02 as ( -- modelo upsell
  select distinct
    sco.creation_date_dt as valid_from_dt
    ,coalesce(lag(sco.creation_date_dt-1) over (partition by sco.cus_cust_id_borrower order by sco.creation_date_dt desc), current_date('-03')) as valid_to_dt
    ,sco.cus_cust_id_borrower AS user_id
    ,sco.crd_version
    ,co.crd_internal_rating AS rating_upsell_tc_acc
    ,sco.crd_score
  from `WHOWNER.BT_CRD_CREDITS_RISK_SCORING` AS sco
  left join `SBOX_CREDITSSHARED.CC_PARAM_CUTOFFS` AS co
    on sco.crd_model = co.crd_model
    and sco.crd_score > co.crd_cutoff_value_min
    and sco.crd_score <= co.crd_cutoff_value_max
    and sco.crd_version = co.crd_version
  where 1=1
    and sco.sit_site_id = 'MLB'
    and sco.crd_model = 'consumers_upsell_tc'
    and co.crd_model = 'consumers_upsell_tc'
    and sco.creation_date_dt >= f_start
    and sco.cus_cust_id_borrower in (select distinct user_id from fonte00)
),
fonte03 as ( -- VU NISE
  select
     period_dt as f_cartera
    ,cus_cust_id as user_id
    ,nise_tag_modeling_income as nise_tag
    ,case
      when nise_tag_modeling_income = 'PLATINUM' then concat('a. ', nise_tag_modeling_income)
      when nise_tag_modeling_income = 'GOLD' then concat('b. ', nise_tag_modeling_income)
      when nise_tag_modeling_income = 'SILVER' then concat('c. ', nise_tag_modeling_income)
      when nise_tag_modeling_income = 'BRONZE' then concat('d. ', nise_tag_modeling_income)
      else 'e. Otros' end as nise
    -- ,modeling_income as renta_monto
    ,modeling_income_source_tag as renta_source
  from `WHOWNER.BT_RMOD_NISE_MLB_HISTORICAL_FULL`
  where 1=1
    and sit_site_id = 'MLB'
    and period_dt >= f_start_m_1
    and cus_cust_id in (select distinct user_id from fonte00)
),
fonte04 as ( -- marca Sellers
  select
     valid_from_dt
    ,valid_to_dt
    ,cus_cust_id as user_id
    ,case when cha_cus_type in ('SELLER', 'MIXTO') then 1 else 0 end as flag_sellers
  from `WHOWNER.LK_VU_PROSPECT_UNIVERSE`
  where 1=1
    and sit_site_id = 'MLB'
    and cus_cust_id in (select distinct user_id from fonte00)
    -- and cus_cust_id = 353789723
    and valid_to_dt >= f_start
),
joins00 as (
  select
     acc.*
    -- / --
    ,upsell.rating_upsell_tc_acc
    ,nise.nise
    -- ,nise.renta_monto
    ,nise.renta_source
    ,safe_cast(clasif.clasif as int64) as grupo_riesgo
    ,sellers.flag_sellers
  from fonte00 acc
  left join fonte01 bhv
    on acc.user_id = bhv.user_id
    and (acc.f_acc_carga >= bhv.valid_from_dt and  acc.f_acc_carga < bhv.valid_to_dt)
  left join fonte02 upsell
    on acc.user_id = upsell.user_id
    and (acc.f_acc_carga >= upsell.valid_from_dt and  acc.f_acc_carga < upsell.valid_to_dt)
  left join fonte03 nise
    on acc.user_id = nise.user_id
    and acc.f_mes_acc_carga = (nise.f_cartera + interval '1' month)
  left join fonte04 sellers
    on acc.user_id = sellers.user_id
    and (acc.f_acc_carga >= sellers.valid_from_dt and acc.f_acc_carga < sellers.valid_to_dt)
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_CLASIF_BHV_UPSELL_PECASTANHO` clasif
    on coalesce(acc.rating_bhv_tc_acc, bhv.rating_behavior_tc_acc) = clasif.bhv
    and upsell.rating_upsell_tc_acc = clasif.upsell
    and clasif.valid_to_dt = date('9999-12-31')
  
),
saida00 as (
  select
    *
    ,case
      when f_acc_carga <= date('2024-02-01') then
        case
          when grupo_riesgo <= 1 then 'a. Muy bajo'
          when grupo_riesgo <= 2 then 'b. Bajo'
          when grupo_riesgo <= 6 then 'c. Medio'      
          when grupo_riesgo <= 10 then 'd. Alto'
          when grupo_riesgo <= 12 then 'e. Muy alto'
          else 'f. a ver' end
      else
        case
          when grupo_riesgo <= 2 then 'a. Muy bajo'
          when grupo_riesgo <= 5 then 'b. Bajo'
          when grupo_riesgo <= 7 then 'c. Medio'      
          when grupo_riesgo <= 11 then 'd. Alto'
          when grupo_riesgo <= 14 then 'e. Muy alto'
          else 'f. a ver' end end as nivel_riesgo
  from joins00
)
select distinct
  *
from saida00
;

-- parte 3

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PECASTANHO`
as
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_2_PECASTANHO`
;

-- parte 4 (info rentabilidade)

declare f_ini date;
declare f_ini_m_1 date;
set f_ini = date('2024-01-01');
set f_ini_m_1 = date(f_ini - interval 1 month);
create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_1_PECASTANHO`
as
with
fonte00 as (
  select
     user_id
    ,f_mes_acc_carga
    ,f_acc_carga
    ,f_acc_impacto
    ,acc_status
    ,acc_status_det
    ,campaign_id
    ,policy
    ,policy_category
    ,policy_subcategory
    ,rating_bhv_tc_acc
    ,rating_upsell_tc_acc
    ,grupo_riesgo
    ,nivel_riesgo
    ,nise
    -- ,renta_monto
    ,renta_source
    ,limit_amount_tc_acc_pre
    ,limit_amount_tc_acc_post
    ,round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) as multip_limite
    ,case
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 2 then '02-02'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 3 then '03-03'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 5 then '04-05'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 6 then '06-06'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) > 6 then '07-99'
    else '99-99' end as fx_multip_limite
    ,case
    when regexp_contains(campaign_group, 'IMPACTO') then 'IMPACTO'
    when regexp_contains(campaign_group, 'CONTROL') then 'CONTROL'
    else 'a ver' end as campaign_group_trat
    ,date_trunc(f_cartera_v3, month) as f_cartera_m0
    ,if(dpd_v3 >= 30, deuda_v3, 0) as deuda_over30m0
    ,deuda as deuda_m0
    ,deuda_over30_m1_v3 as deuda_over30m1
    ,deuda_m1_v3 as deuda_m1
    ,deuda_over30_m2_v3 as deuda_over30m2
    ,deuda_m2_v3 as deuda_m2
    ,deuda_over30_m3_v3 as deuda_over30m3
    ,deuda_m3_v3 as deuda_m3
    ,deuda_over30_m4_v3 as deuda_over30m4
    ,deuda_m4_v3 as deuda_m4
    ,deuda_over30_m5_v3 as deuda_over30m5
    ,deuda_m5_v3 as deuda_m5
    ,deuda_over30_m6_v3 as deuda_over30m6
    ,deuda_m6_v3 as deuda_m6
    ,deuda_over30_m7_v3 as deuda_over30m7
    ,deuda_m7_v3 as deuda_m7
    ,deuda_over30_m8_v3 as deuda_over30m8
    ,deuda_m8_v3 as deuda_m8
    ,deuda_over30_m9_v3 as deuda_over30m9
    ,deuda_m9_v3 as deuda_m9
    ,deuda_over30_m10_v3 as deuda_over30m10
    ,deuda_m10_v3 as deuda_m10
    ,deuda_over30_m11_v3 as deuda_over30m11
    ,deuda_m11_v3 as deuda_m11
    ,deuda_over30_m12_v3 as deuda_over30m12
    ,deuda_m12_v3 as deuda_m12
    ,tpv_m0_v3 as tpv_m0
    ,tpv_m1_v3 as tpv_m1
    ,tpv_m2_v3 as tpv_m2
    ,tpv_m3_v3 as tpv_m3
    ,tpv_m4_v3 as tpv_m4
    ,tpv_m5_v3 as tpv_m5
    ,tpv_m6_v3 as tpv_m6
    ,tpv_m7_v3 as tpv_m7
    ,tpv_m8_v3 as tpv_m8
    ,tpv_m9_v3 as tpv_m9
    ,tpv_m10_v3 as tpv_m10
    ,tpv_m11_v3 as tpv_m11
    ,tpv_m12_v3 as tpv_m12
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PECASTANHO`
  where 1=1
    and f_mes_acc_carga >= f_ini
),
fonte01 as ( -- P&L Rentab
  select
    *
  from `SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_PECASTANHO`
  where 1=1
    and f_cartera >= f_ini_m_1
    and user_id in (select distinct user_id from fonte00)
    -- and user_id = 353789723
),
joins00 as (
  select
     base.*
    ,pl.* except(f_cartera, user_id)
  from fonte00 base
  left join fonte01 pl
    on base.user_id = pl.user_id
    and base.f_cartera_m0 = pl.f_cartera
)
select
  *
from joins00
;


-- parte 5 (visao vtg)

create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_2_PECASTANHO`
as
select
   a.* except(
     deuda_over30m0
    ,deuda_over30m1
    ,deuda_over30m2
    ,deuda_over30m3
    ,deuda_over30m4
    ,deuda_over30m5
    ,deuda_over30m6
    ,deuda_over30m7
    ,deuda_over30m8
    ,deuda_over30m9
    ,deuda_over30m10
    ,deuda_over30m11
    ,deuda_over30m12
    ,deuda_m0
    ,deuda_m1
    ,deuda_m2
    ,deuda_m3
    ,deuda_m4
    ,deuda_m5
    ,deuda_m6
    ,deuda_m7
    ,deuda_m8
    ,deuda_m9
    ,deuda_m10
    ,deuda_m11
    ,deuda_m12
    ,tpv_m0
    ,tpv_m1
    ,tpv_m2
    ,tpv_m3
    ,tpv_m4
    ,tpv_m5
    ,tpv_m6
    ,tpv_m7
    ,tpv_m8
    ,tpv_m9
    ,tpv_m10
    ,tpv_m11
    ,tpv_m12
    ,rev_all_m0
    ,rev_all_m1
    ,rev_all_m2
    ,rev_all_m3
    ,rev_all_m4
    ,rev_all_m5
    ,rev_all_m6
    ,rev_all_m7
    ,rev_all_m8
    ,rev_all_m9
    ,rev_all_m10
    ,rev_all_m11
    ,rev_all_m12
    ,co_fondeo_tax_m0
    ,co_fondeo_tax_m1
    ,co_fondeo_tax_m2
    ,co_fondeo_tax_m3
    ,co_fondeo_tax_m4
    ,co_fondeo_tax_m5
    ,co_fondeo_tax_m6
    ,co_fondeo_tax_m7
    ,co_fondeo_tax_m8
    ,co_fondeo_tax_m9
    ,co_fondeo_tax_m10
    ,co_fondeo_tax_m11
    ,co_fondeo_tax_m12
    ,co_other_cogs_m0
    ,co_other_cogs_m1
    ,co_other_cogs_m2
    ,co_other_cogs_m3
    ,co_other_cogs_m4
    ,co_other_cogs_m5
    ,co_other_cogs_m6
    ,co_other_cogs_m7
    ,co_other_cogs_m8
    ,co_other_cogs_m9
    ,co_other_cogs_m10
    ,co_other_cogs_m11
    ,co_other_cogs_m12
    ,co_agreements_m0
    ,co_agreements_m1
    ,co_agreements_m2
    ,co_agreements_m3
    ,co_agreements_m4
    ,co_agreements_m5
    ,co_agreements_m6
    ,co_agreements_m7
    ,co_agreements_m8
    ,co_agreements_m9
    ,co_agreements_m10
    ,co_agreements_m11
    ,co_agreements_m12
    ,rev_pix_m0
    ,rev_pix_m1
    ,rev_pix_m2
    ,rev_pix_m3
    ,rev_pix_m4
    ,rev_pix_m5
    ,rev_pix_m6
    ,rev_pix_m7
    ,rev_pix_m8
    ,rev_pix_m9
    ,rev_pix_m10
    ,rev_pix_m11
    ,rev_pix_m12
    ,co_pix_m0
    ,co_pix_m1
    ,co_pix_m2
    ,co_pix_m3
    ,co_pix_m4
    ,co_pix_m5
    ,co_pix_m6
    ,co_pix_m7
    ,co_pix_m8
    ,co_pix_m9
    ,co_pix_m10
    ,co_pix_m11
    ,co_pix_m12
    )
  ,b.mob
  ,b.deuda_over30
  ,b.deuda
  ,b.tpv
  ,b.rev_all
  ,b.co_fondeo_tax
  ,b.co_other_cogs
  ,b.co_agreements
  ,b.co_pix
  ,b.rev_pix
  ,sum(b.tpv) over (partition by a.campaign_id, a.user_id order by b.mob asc) as tpv_acum
  ,sum(b.rev_all) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_all_acum
  ,sum(b.co_fondeo_tax) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_fondeo_tax_acum
  ,sum(b.co_other_cogs) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_other_cogs_acum
  ,sum(b.co_agreements) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_agreements_acum
  ,sum(b.rev_pix) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_pix_acum
  ,sum(b.co_pix) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_pix_acum
  ,lag(b.deuda,1) over (partition by a.campaign_id, a.user_id order by b.mob desc) - b.deuda as var_deuda_mob
  ,lag(b.deuda_over30,1) over (partition by a.campaign_id, a.user_id order by b.mob desc) - b.deuda_over30 as var_deuda_over30_mob
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_1_PECASTANHO` a,
unnest([
   struct(0 as mob, deuda_over30m0 as deuda_over30, deuda_m0 as deuda, tpv_m0 as tpv, rev_all_m0 as rev_all, co_fondeo_tax_m0 as co_fondeo_tax, co_other_cogs_m0 as co_other_cogs, co_agreements_m0 as co_agreements, co_pix_m0 as co_pix, rev_pix_m0 as rev_pix)
  ,struct(1 as mob, deuda_over30m1 as deuda_over30, deuda_m1 as deuda, tpv_m1 as tpv, rev_all_m1 as rev_all, co_fondeo_tax_m1 as co_fondeo_tax, co_other_cogs_m1 as co_other_cogs, co_agreements_m1 as co_agreements, co_pix_m1 as co_pix, rev_pix_m1 as rev_pix)
  ,struct(2 as mob, deuda_over30m2 as deuda_over30, deuda_m2 as deuda, tpv_m2 as tpv, rev_all_m2 as rev_all, co_fondeo_tax_m2 as co_fondeo_tax, co_other_cogs_m2 as co_other_cogs, co_agreements_m2 as co_agreements, co_pix_m2 as co_pix, rev_pix_m2 as rev_pix)
  ,struct(3 as mob, deuda_over30m3 as deuda_over30, deuda_m3 as deuda, tpv_m3 as tpv, rev_all_m3 as rev_all, co_fondeo_tax_m3 as co_fondeo_tax, co_other_cogs_m3 as co_other_cogs, co_agreements_m3 as co_agreements, co_pix_m3 as co_pix, rev_pix_m3 as rev_pix)
  ,struct(4 as mob, deuda_over30m4 as deuda_over30, deuda_m4 as deuda, tpv_m4 as tpv, rev_all_m4 as rev_all, co_fondeo_tax_m4 as co_fondeo_tax, co_other_cogs_m4 as co_other_cogs, co_agreements_m4 as co_agreements, co_pix_m4 as co_pix, rev_pix_m4 as rev_pix)
  ,struct(5 as mob, deuda_over30m5 as deuda_over30, deuda_m5 as deuda, tpv_m5 as tpv, rev_all_m5 as rev_all, co_fondeo_tax_m5 as co_fondeo_tax, co_other_cogs_m5 as co_other_cogs, co_agreements_m5 as co_agreements, co_pix_m5 as co_pix, rev_pix_m5 as rev_pix)
  ,struct(6 as mob, deuda_over30m6 as deuda_over30, deuda_m6 as deuda, tpv_m6 as tpv, rev_all_m6 as rev_all, co_fondeo_tax_m6 as co_fondeo_tax, co_other_cogs_m6 as co_other_cogs, co_agreements_m6 as co_agreements, co_pix_m6 as co_pix, rev_pix_m6 as rev_pix)
  ,struct(7 as mob, deuda_over30m7 as deuda_over30, deuda_m7 as deuda, tpv_m7 as tpv, rev_all_m7 as rev_all, co_fondeo_tax_m7 as co_fondeo_tax, co_other_cogs_m7 as co_other_cogs, co_agreements_m7 as co_agreements, co_pix_m7 as co_pix, rev_pix_m7 as rev_pix)
  ,struct(8 as mob, deuda_over30m8 as deuda_over30, deuda_m8 as deuda, tpv_m8 as tpv, rev_all_m8 as rev_all, co_fondeo_tax_m8 as co_fondeo_tax, co_other_cogs_m8 as co_other_cogs, co_agreements_m8 as co_agreements, co_pix_m8 as co_pix, rev_pix_m8 as rev_pix)
  ,struct(9 as mob, deuda_over30m9 as deuda_over30, deuda_m9 as deuda, tpv_m9 as tpv, rev_all_m9 as rev_all, co_fondeo_tax_m9 as co_fondeo_tax, co_other_cogs_m9 as co_other_cogs, co_agreements_m9 as co_agreements, co_pix_m9 as co_pix, rev_pix_m9 as rev_pix)
  ,struct(10 as mob, deuda_over30m10 as deuda_over30, deuda_m10 as deuda, tpv_m10 as tpv, rev_all_m10 as rev_all, co_fondeo_tax_m10 as co_fondeo_tax, co_other_cogs_m10 as co_other_cogs, co_agreements_m10 as co_agreements, co_pix_m10 as co_pix, rev_pix_m10 as rev_pix)
  ,struct(11 as mob, deuda_over30m11 as deuda_over30, deuda_m11 as deuda, tpv_m11 as tpv, rev_all_m11 as rev_all, co_fondeo_tax_m11 as co_fondeo_tax, co_other_cogs_m11 as co_other_cogs, co_agreements_m11 as co_agreements, co_pix_m11 as co_pix, rev_pix_m11 as rev_pix)
  ,struct(12 as mob, deuda_over30m12 as deuda_over30, deuda_m12 as deuda, tpv_m12 as tpv, rev_all_m12 as rev_all, co_fondeo_tax_m12 as co_fondeo_tax, co_other_cogs_m12 as co_other_cogs, co_agreements_m12 as co_agreements, co_pix_m12 as co_pix, rev_pix_m12 as rev_pix)
]) b
;
