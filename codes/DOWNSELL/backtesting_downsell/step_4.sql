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
    ,renta_monto
    ,renta_source
    ,nise_acc
    ,renta_monto_acc
    ,renta_source_acc
    ,deuda_30d_clean
    ,deuda_30d_total
    ,deuda_all_clean
    ,deuda_all_total
    ,deuda_venc_over30_clean
    ,deuda_venc_over30_total
    ,safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) as porc_endeu_clean
    ,safe_divide(if(deuda_30d_total>0,deuda_30d_total,null), renta_monto) as porc_endeu_total
    ,case
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) <= 0 then '000-000'
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) <= .2 then '001-020'
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) <= .4 then '021-040'
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) <= .6 then '041-060'
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) <= .8 then '061-080'
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) <= .9 then '081-090'
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) <= 1 then '091-100'
      when safe_divide(if(deuda_30d_clean>0,deuda_30d_clean,null), renta_monto) > 1 then '101-999'
      else '999-999' end as fx_porc_endeu_clean
    ,if(deuda_venc_over30_total >= 100, 1, 0) as flag_venc_over30_100
    ,flag_sellers
    ,porc_uso_real_tc
    ,f_emision_dt
    ,score_bvs
    ,score_serasa
    ,rating_externo
    ,status_producto
    ,limit_amount_tc_acc_pre
    ,limit_amount_tc_acc_post
    ,flag_fraude_ito
    ,round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) as multip_limite
    ,case
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 2 then '02-02'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 3 then '03-03'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 5 then '04-05'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) <= 6 then '06-06'
    when round(safe_divide(limit_amount_tc_acc_post, limit_amount_tc_acc_pre),1) > 6 then '07-99'
    else '99-99' end as fx_multip_limite
    ,campaign_group_trat
    ,date_trunc(f_cartera_v3, month) as f_cartera_m0
    ,if(dpd_v3 >= 30, deuda_v3, 0) as deuda_over30m0
    ,deuda as deuda_m0
    ,deuda_over30_m_1_v3 as deuda_over30m_1
    ,deuda_m_1_v3 as deuda_m_1
    ,deuda_over30_m_2_v3 as deuda_over30m_2
    ,deuda_m_2_v3 as deuda_m_2
    ,deuda_over30_m_3_v3 as deuda_over30m_3
    ,deuda_m_3_v3 as deuda_m_3
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
    ,tpv_m_1_v3 as tpv_m_1
    ,tpv_m_2_v3 as tpv_m_2
    ,tpv_m_3_v3 as tpv_m_3
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
    -- limit 1
),
fonte01 as ( -- P&L Rentab
  select
    *
  from `SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_PECASTANHO`
  where 1=1
    and f_cartera >= f_ini_m_1
    and user_id in (select distinct user_id from fonte00)
),

fonte02 as ( -- cartera financiada
  with
  temp00 as (
    select
       base.fecha_cartera
      ,base.cus_cust_id
      ,base.dpd
      ,base.deuda_financiada
      ,prev.porc_prevision
    from `SBOX_CREDITS_SB.RBA_TC_MLB_CARTERA_3040` base
    left join `SBOX_CREDITS_SB.RBA_TC_MLB_PREVISION_PORCENT_HIST_PECASTANHO` prev
      on base.fecha_cartera = prev.f_cartera
      and base.dpd between prev.dpd_from and prev.dpd_to
  )
  select
     m0.fecha_cartera as f_cartera
    ,m0.cus_cust_id as user_id
    ,m0.deuda_financiada as deuda_financiada_m0
    ,m1.deuda_financiada as deuda_financiada_m1
    ,m2.deuda_financiada as deuda_financiada_m2
    ,m3.deuda_financiada as deuda_financiada_m3
    ,m4.deuda_financiada as deuda_financiada_m4
    ,m5.deuda_financiada as deuda_financiada_m5
    ,m6.deuda_financiada as deuda_financiada_m6
    ,m0.porc_prevision as porc_prevision_m0
    ,m1.porc_prevision as porc_prevision_m1
    ,m2.porc_prevision as porc_prevision_m2
    ,m3.porc_prevision as porc_prevision_m3
    ,m4.porc_prevision as porc_prevision_m4
    ,m5.porc_prevision as porc_prevision_m5
    ,m6.porc_prevision as porc_prevision_m6
    ,m0.dpd as dpd_m0
    ,m1.dpd as dpd_m1
    ,m2.dpd as dpd_m2
    ,m3.dpd as dpd_m3
    ,m4.dpd as dpd_m4
    ,m5.dpd as dpd_m5
    ,m6.dpd as dpd_m6
  from temp00 m0
  left join temp00 m1
    on m0.cus_cust_id = m1.cus_cust_id
    and m0.fecha_cartera = (m1.fecha_cartera - interval 1 month)
  left join temp00 m2
    on m0.cus_cust_id = m2.cus_cust_id
    and m0.fecha_cartera = (m2.fecha_cartera - interval 2 month)
  left join temp00 m3
    on m0.cus_cust_id = m3.cus_cust_id
    and m0.fecha_cartera = (m3.fecha_cartera - interval 3 month)
  left join temp00 m4
    on m0.cus_cust_id = m4.cus_cust_id
    and m0.fecha_cartera = (m4.fecha_cartera - interval 4 month)
  left join temp00 m5
    on m0.cus_cust_id = m5.cus_cust_id
    and m0.fecha_cartera = (m5.fecha_cartera - interval 5 month)
  left join temp00 m6
    on m0.cus_cust_id = m6.cus_cust_id
    and m0.fecha_cartera = (m6.fecha_cartera - interval 6 month)
  where 1=1
    and m0.fecha_cartera >= f_ini_m_1
    and m0.cus_cust_id in (select distinct user_id from fonte00)
),
joins00 as (
  select
     base.*
    ,pl.* except(f_cartera, user_id)
    ,cart.* except(f_cartera, user_id)  
  from fonte00 base
  left join fonte01 pl
    on base.user_id = pl.user_id
    and base.f_cartera_m0 = pl.f_cartera
  left join fonte02 cart
    on base.user_id = cart.user_id
    and base.f_cartera_m0 = cart.f_cartera
)
select
  *
from joins00
;