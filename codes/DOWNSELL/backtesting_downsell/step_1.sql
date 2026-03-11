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
    and split(risk_id, '-')[safe_offset(4)] = 'DOWNSELL'
    and actionable_dt >= f_start
    and campaign_desc is not null
),
fonte01 as ( -- cartera y over
  select
     f_cartera
    ,f_cartera_fin_mes_dt
    ,user_id
    ,acc_status
    ,acc_status_det
    --m-3
    ,dpd_m_3
    ,deuda_m_3
    ,deuda_over30_m_3
    --m-2
    ,dpd_m_2
    ,deuda_m_2
    ,deuda_over30_m_2
    --m-1
    ,dpd_m_1
    ,deuda_m_1
    ,deuda_over30_m_1
    --m0
    ,dpd
    ,deuda
    ,deuda_over30
    --m1
    ,dpd_m1
    ,deuda_m1
    ,if(dpd_m1 >= 30, deuda_m1, 0) as deuda_over30_m1
    --m2
    ,dpd_m2
    ,deuda_m2
    ,deuda_over30_m2
    --m3
    ,dpd_m3
    ,deuda_m3
    ,deuda_over30_m3
    --m4
    ,dpd_m4
    ,deuda_m4
    ,deuda_over30_m4
    --m5
    ,dpd_m5
    ,deuda_m5
    ,deuda_over30_m5
    --m6
    ,dpd_m6
    ,deuda_m6
    ,deuda_over30_m6
    --m7
    ,dpd_m7
    ,deuda_m7
    ,deuda_over30_m7
    --m8
    ,dpd_m8
    ,deuda_m8
    ,deuda_over30_m8
    --m9
    ,dpd_m9
    ,deuda_m9
    ,deuda_over30_m9
    --m10
    ,dpd_m10
    ,deuda_m10
    ,deuda_over30_m10
    --m11
    ,dpd_m11
    ,deuda_m11
    ,deuda_over30_m11
    --m12
    ,dpd_m12
    ,deuda_m12
    ,deuda_over30_m12
  from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_GERAL_PECASTANHO`
  where 1=1
    and user_id in (select distinct user_id from fonte00)
    and f_cartera >= f_start_m_1
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
      ,m_1.tpv_m0 as tpv_m_1
      ,m_2.tpv_m0 as tpv_m_2
      ,m_3.tpv_m0 as tpv_m_3
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
    left join temp00 m_1
      on m0.user_id = m_1.user_id
      and m0.f_mes = (m_1.f_mes + interval 1 month)
      left join temp00 m_2
      on m0.user_id = m_2.user_id
      and m0.f_mes = (m_2.f_mes + interval 2 month)
      left join temp00 m_3
      on m0.user_id = m_3.user_id
      and m0.f_mes = (m_3.f_mes + interval 3 month)
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
    
    ,cart_v3.deuda_over30_m_1 as deuda_over30_m_1_v3
    ,cart_v3.deuda_m_1 as deuda_m_1_v3

    ,cart_v3.deuda_over30_m_2 as deuda_over30_m_2_v3
    ,cart_v3.deuda_m_2 as deuda_m_2_v3

    ,cart_v3.deuda_over30_m_3 as deuda_over30_m_3_v3
    ,cart_v3.deuda_m_3 as deuda_m_3_v3

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

    ,purch_v3.tpv_m_1 as tpv_m_1_v3
    ,purch_v3.tpv_m_2 as tpv_m_2_v3
    ,purch_v3.tpv_m_3 as tpv_m_3_v3
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