declare ref_array array<date>;
declare ref_pl_max date;
declare ref_pl_min date;
declare num_mob_max numeric;
declare num_mob_min numeric;
declare porc_tasa_visa FLOAT64;

-- seleciona um intervalo de referencias de datas para a carteira
set ref_array = array(select distinct f_mes_acc_carga from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_PECASTANHO` order by 1 asc);
-- seleciona quantidade maxima de mobs
set num_mob_max = 12;
set num_mob_min = 0;

set porc_tasa_visa = 0.0012;


-- cria uma tabela vazia com os campos necessarios
drop table if exists `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_PL_MOB_PECASTANHO`;

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_PL_MOB_PECASTANHO`
(
  user_id INT64
  ,f_mes_acc_carga DATE
  ,f_acc_carga DATE
  ,f_acc_impacto DATE
  ,campaign_id STRING
  ,produto STRING
  ,audiencia STRING
  ,policy STRING
  ,policy_category STRING
  ,policy_subcategory STRING
  ,rating_bhv_tc_acc STRING
  ,rating_upsell_tc_acc STRING
  ,grupo_riesgo INT64
  ,nivel_riesgo STRING
  ,nise STRING
  ,renta_monto FLOAT64
  ,renta_source STRING
  ,nise_hoy STRING
  ,renta_monto_hoy NUMERIC
  ,renta_source_hoy STRING
  ,nise_acc STRING
  ,renta_monto_acc NUMERIC
  ,renta_source_acc STRING
  ,deuda_30d_clean FLOAT64
  ,deuda_30d_total FLOAT64
  ,deuda_all_clean FLOAT64
  ,deuda_all_total FLOAT64
  ,deuda_venc_over30_clean FLOAT64
  ,deuda_venc_over30_total FLOAT64
  ,porc_endeu_clean FLOAT64
  ,porc_endeu_total FLOAT64
  ,fx_porc_endeu_clean STRING
  ,flag_venc_over30_100 INT64
  ,flag_sellers INT64
  ,porc_uso_real_tc NUMERIC
  ,f_emision_dt DATE
  ,score_bvs NUMERIC
  ,score_serasa NUMERIC
  ,rating_externo STRING
  ,rci_conj NUMERIC
  ,porc_iu_pre NUMERIC
  ,porc_iu_post NUMERIC
  ,limit_amount_tc_acc_pre NUMERIC
  ,limit_amount_tc_acc_post NUMERIC
  ,flag_fraude_ito INT64
  ,multip_limite NUMERIC
  ,fx_multip_limite STRING
  ,campaign_group_trat STRING
  ,f_cartera_m0 DATE
  ,mob INT64
  ,deuda_over30 NUMERIC
  ,deuda NUMERIC
  ,dpd INT64
  ,tpv NUMERIC
  ,tpv_acum NUMERIC
  ,tpv_acum_m0 NUMERIC
  ,tpv_acum_m1 NUMERIC
  ,rev_pix BIGNUMERIC
  ,co_pix BIGNUMERIC
  ,rev_interchange_fee NUMERIC
  ,rev_revolving NUMERIC
  ,rev_punitorio NUMERIC
  ,rev_parcelamento NUMERIC
  ,rev_withdrawal NUMERIC
  ,rev_overlimit NUMERIC
  ,co_sales_taxes NUMERIC
  ,co_funding_cost NUMERIC
  ,co_procesador_cajero NUMERIC
  ,co_collection_fee NUMERIC
  ,co_emision_envio FLOAT64
  ,co_bureau NUMERIC
  ,co_cobranzas NUMERIC
  ,co_sales_expenses NUMERIC
  ,co_financing_psj BIGNUMERIC
  ,co_chargebacks NUMERIC
  ,co_marketing NUMERIC
  ,co_cx NUMERIC
  ,co_hosting NUMERIC
  ,co_meli_mais FLOAT64
  ,co_agreements NUMERIC
  ,deuda_financiada NUMERIC
  ,co_visa_viejo NUMERIC
  ,co_sales_expenses_viejo BIGNUMERIC
  ,rev_pix_acum_m0 BIGNUMERIC
  ,co_pix_acum_m0 BIGNUMERIC
  ,rev_interchange_fee_acum_m0 NUMERIC
  ,rev_revolving_acum_m0 NUMERIC
  ,rev_punitorio_acum_m0 NUMERIC
  ,rev_parcelamento_acum_m0 NUMERIC
  ,rev_withdrawal_acum_m0 NUMERIC
  ,rev_overlimit_acum_m0 NUMERIC
  ,co_sales_taxes_acum_m0 NUMERIC
  ,co_funding_cost_acum_m0 NUMERIC
  ,co_procesador_cajero_acum_m0 NUMERIC
  ,co_collection_fee_acum_m0 NUMERIC
  ,co_emision_envio_acum_m0 FLOAT64
  ,co_bureau_acum_m0 NUMERIC
  ,co_cobranzas_acum_m0 NUMERIC
  ,co_sales_expenses_acum_m0 NUMERIC
  ,co_financing_psj_acum_m0 BIGNUMERIC
  ,co_chargebacks_acum_m0 NUMERIC
  ,co_marketing_acum_m0 NUMERIC
  ,co_cx_acum_m0 NUMERIC
  ,co_hosting_acum_m0 NUMERIC
  ,co_meli_mais_acum_m0 FLOAT64
  ,co_agreements_acum_m0 NUMERIC
  ,co_sales_expenses_viejo_acum_m0 BIGNUMERIC
  ,co_visa_viejo_acum_m0 NUMERIC
  ,f_cartera DATE
  ,porc_prevision_mp_all FLOAT64
  ,porc_prevision_2682 FLOAT64
  ,porc_prevision_mp FLOAT64
  ,deuda_prevision_mp FLOAT64
  ,deuda_prevision_2682 FLOAT64
  ,co_visa_acum_m0 FLOAT64
)
partition by f_mes_acc_carga
cluster by policy_category, mob
;

-- itera n para cada referencia de datas
for ref in (select * from unnest(ref_array))
do

create or replace temp table RBA_TC_BACKTEST
as
with
temp00 as (
  select
     user_id
    ,f_mes_acc_carga
    ,f_acc_carga
    ,f_acc_impacto
    ,campaign_id
    ,produto
    ,audiencia
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
    ,nise_hoy
    ,renta_monto_hoy
    ,renta_source_hoy
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
    ,rci_conj
    ,porc_iu_pre
    ,porc_iu_post
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
    ,deuda_v3 as deuda_m0
    ,dpd_v3 as dpd_m0
    ,deuda_over30_m_1_v3 as deuda_over30m_1
    ,deuda_m_1_v3 as deuda_m_1
    ,dpd_m_1_v3 as dpd_m_1
    ,deuda_over30_m_2_v3 as deuda_over30m_2
    ,deuda_m_2_v3 as deuda_m_2
    ,dpd_m_2_v3 as dpd_m_2
    ,deuda_over30_m_3_v3 as deuda_over30m_3
    ,deuda_m_3_v3 as deuda_m_3
    ,dpd_m_3_v3 as dpd_m_3
    ,deuda_over30_m1_v3 as deuda_over30m1
    ,deuda_m1_v3 as deuda_m1
    ,dpd_m1_v3 as dpd_m1
    ,deuda_over30_m2_v3 as deuda_over30m2
    ,deuda_m2_v3 as deuda_m2
    ,dpd_m2_v3 as dpd_m2
    ,deuda_over30_m3_v3 as deuda_over30m3
    ,deuda_m3_v3 as deuda_m3
    ,dpd_m3_v3 as dpd_m3
    ,deuda_over30_m4_v3 as deuda_over30m4
    ,deuda_m4_v3 as deuda_m4
    ,dpd_m4_v3 as dpd_m4
    ,deuda_over30_m5_v3 as deuda_over30m5
    ,deuda_m5_v3 as deuda_m5
    ,dpd_m5_v3 as dpd_m5
    ,deuda_over30_m6_v3 as deuda_over30m6
    ,deuda_m6_v3 as deuda_m6
    ,dpd_m6_v3 as dpd_m6
    ,deuda_over30_m7_v3 as deuda_over30m7
    ,deuda_m7_v3 as deuda_m7
    ,dpd_m7_v3 as dpd_m7
    ,deuda_over30_m8_v3 as deuda_over30m8
    ,deuda_m8_v3 as deuda_m8
    ,dpd_m8_v3 as dpd_m8
    ,deuda_over30_m9_v3 as deuda_over30m9
    ,deuda_m9_v3 as deuda_m9
    ,dpd_m9_v3 as dpd_m9
    ,deuda_over30_m10_v3 as deuda_over30m10
    ,deuda_m10_v3 as deuda_m10
    ,dpd_m10_v3 as dpd_m10
    ,deuda_over30_m11_v3 as deuda_over30m11
    ,deuda_m11_v3 as deuda_m11
    ,dpd_m11_v3 as dpd_m11
    ,deuda_over30_m12_v3 as deuda_over30m12
    ,deuda_m12_v3 as deuda_m12
    ,dpd_m12_v3 as dpd_m12
    ,tpv_m0_v3 as tpv_m0
    ,tpv_m_1_v3 as tpv_m_1
    ,tpv_m_2_v3 as tpv_m_2
    ,tpv_m_3_v3 as tpv_m_3
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
  from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_PECASTANHO`
  where 1=1
    and f_mes_acc_carga = ref[0]
),
temp01 as (
  select
    a.* except(
       deuda_over30m0
      ,deuda_over30m_1
      ,deuda_over30m_2
      ,deuda_over30m_3
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
      ,deuda_m_1
      ,deuda_m_2
      ,deuda_m_3
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
      ,dpd_m0
      ,dpd_m_1
      ,dpd_m_2
      ,dpd_m_3
      ,dpd_m1
      ,dpd_m2
      ,dpd_m3
      ,dpd_m4
      ,dpd_m5
      ,dpd_m6
      ,dpd_m7
      ,dpd_m8
      ,dpd_m9
      ,dpd_m10
      ,dpd_m11
      ,dpd_m12
      ,tpv_m0
      ,tpv_m_1
      ,tpv_m_2
      ,tpv_m_3
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
      )
    ,b.mob
    ,b.deuda_over30
    ,b.deuda
    ,b.dpd
    ,b.tpv
    ,sum(coalesce(b.tpv,0)) over (partition by a.campaign_id, a.user_id order by b.mob asc) as tpv_acum
    ,sum(coalesce(if(b.mob >= 0, b.tpv, null),0)) over (partition by a.campaign_id, a.user_id order by b.mob asc) as tpv_acum_m0
    ,sum(coalesce(if(b.mob > 0, b.tpv, null),0)) over (partition by a.campaign_id, a.user_id order by b.mob asc) as tpv_acum_m1
  from temp00 a,
  unnest([
     struct(-3 as mob, deuda_over30m_3 as deuda_over30, deuda_m_3 as deuda, tpv_m_3 as tpv, dpd_m_3 as dpd)
    ,struct(-2 as mob, deuda_over30m_2 as deuda_over30, deuda_m_2 as deuda, tpv_m_2 as tpv, dpd_m_2 as dpd)
    ,struct(-1 as mob, deuda_over30m_1 as deuda_over30, deuda_m_1 as deuda, tpv_m_1 as tpv, dpd_m_1 as dpd)
    ,struct(0 as mob, deuda_over30m0 as deuda_over30, deuda_m0 as deuda, tpv_m0 as tpv, dpd_m0 as dpd)
    ,struct(1 as mob, deuda_over30m1 as deuda_over30, deuda_m1 as deuda, tpv_m1 as tpv, dpd_m1 as dpd)
    ,struct(2 as mob, deuda_over30m2 as deuda_over30, deuda_m2 as deuda, tpv_m2 as tpv, dpd_m2 as dpd)
    ,struct(3 as mob, deuda_over30m3 as deuda_over30, deuda_m3 as deuda, tpv_m3 as tpv, dpd_m3 as dpd)
    ,struct(4 as mob, deuda_over30m4 as deuda_over30, deuda_m4 as deuda, tpv_m4 as tpv, dpd_m4 as dpd)
    ,struct(5 as mob, deuda_over30m5 as deuda_over30, deuda_m5 as deuda, tpv_m5 as tpv, dpd_m5 as dpd)
    ,struct(6 as mob, deuda_over30m6 as deuda_over30, deuda_m6 as deuda, tpv_m6 as tpv, dpd_m6 as dpd)
    ,struct(7 as mob, deuda_over30m7 as deuda_over30, deuda_m7 as deuda, tpv_m7 as tpv, dpd_m7 as dpd)
    ,struct(8 as mob, deuda_over30m8 as deuda_over30, deuda_m8 as deuda, tpv_m8 as tpv, dpd_m8 as dpd)
    ,struct(9 as mob, deuda_over30m9 as deuda_over30, deuda_m9 as deuda, tpv_m9 as tpv, dpd_m9 as dpd)
    ,struct(10 as mob, deuda_over30m10 as deuda_over30, deuda_m10 as deuda, tpv_m10 as tpv, dpd_m10 as dpd)
    ,struct(11 as mob, deuda_over30m11 as deuda_over30, deuda_m11 as deuda, tpv_m11 as tpv, dpd_m11 as dpd)
    ,struct(12 as mob, deuda_over30m12 as deuda_over30, deuda_m12 as deuda, tpv_m12 as tpv, dpd_m12 as dpd)
  ]) b
)
select
  *
from temp01
;

set ref_pl_max = date((select max(f_cartera_m0) from RBA_TC_BACKTEST));
set ref_pl_min = date((select min(f_cartera_m0) from RBA_TC_BACKTEST));

create or replace temp table RBA_TC_PYL
as
select
   * except(porc_prevision, porc_prevision_2682)
  ------------------------------------------ MOB 0 ------------------------------------------
  ,sum(coalesce(if(mob >= 0, rev_pix, null),0)) over (partition by user_id,f_cartera order by mob asc) as rev_pix_acum_m0
  ,sum(coalesce(if(mob >= 0, co_pix, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_pix_acum_m0
  ,sum(coalesce(if(mob >= 0, rev_interchange_fee, null),0)) over (partition by user_id,f_cartera order by mob asc) as rev_interchange_fee_acum_m0
  ,sum(coalesce(if(mob >= 0, rev_revolving, null),0)) over (partition by user_id,f_cartera order by mob asc) as rev_revolving_acum_m0
  ,sum(coalesce(if(mob >= 0, rev_punitorio, null),0)) over (partition by user_id,f_cartera order by mob asc) as rev_punitorio_acum_m0
  ,sum(coalesce(if(mob >= 0, rev_parcelamento, null),0)) over (partition by user_id,f_cartera order by mob asc) as rev_parcelamento_acum_m0
  ,sum(coalesce(if(mob >= 0, rev_withdrawal, null),0)) over (partition by user_id,f_cartera order by mob asc) as rev_withdrawal_acum_m0
  ,sum(coalesce(if(mob >= 0, rev_overlimit, null),0)) over (partition by user_id,f_cartera order by mob asc) as rev_overlimit_acum_m0
  ,sum(coalesce(if(mob >= 0, co_sales_taxes, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_sales_taxes_acum_m0
  ,sum(coalesce(if(mob >= 0, co_funding_cost, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_funding_cost_acum_m0
  ,sum(coalesce(if(mob >= 0, co_procesador_cajero, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_procesador_cajero_acum_m0
  ,sum(coalesce(if(mob >= 0, co_collection_fee, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_collection_fee_acum_m0
  ,sum(coalesce(if(mob >= 0, co_emision_envio, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_emision_envio_acum_m0
  ,sum(coalesce(if(mob >= 0, co_bureau, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_bureau_acum_m0
  ,sum(coalesce(if(mob >= 0, co_cobranzas, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_cobranzas_acum_m0
  ,sum(coalesce(if(mob >= 0, co_sales_expenses, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_sales_expenses_acum_m0
  ,sum(coalesce(if(mob >= 0, co_financing_psj, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_financing_psj_acum_m0
  ,sum(coalesce(if(mob >= 0, co_chargebacks, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_chargebacks_acum_m0
  ,sum(coalesce(if(mob >= 0, co_marketing, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_marketing_acum_m0
  ,sum(coalesce(if(mob >= 0, co_cx, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_cx_acum_m0
  ,sum(coalesce(if(mob >= 0, co_hosting, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_hosting_acum_m0
  ,sum(coalesce(if(mob >= 0, co_meli_mais, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_meli_mais_acum_m0
  ,sum(coalesce(if(mob >= 0, co_agreements, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_agreements_acum_m0
  ,sum(coalesce(if(mob >= 0, co_sales_expenses_viejo, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_sales_expenses_viejo_acum_m0
  ,sum(coalesce(if(mob >= 0, co_visa_viejo, null),0)) over (partition by user_id,f_cartera order by mob asc) as co_visa_viejo_acum_m0
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_MOB_PECASTANHO`
where 1=1
  and (f_cartera >= ref_pl_min and f_cartera <= ref_pl_max)
  and mob <= num_mob_max
  and user_id in (select distinct user_id from RBA_TC_BACKTEST)
;

create or replace temp table JOINS
as
select
   base.*
  ,pl.* except(f_cartera, user_id, mob)
  ,prev.* except(dpd_from, dpd_to)
from RBA_TC_BACKTEST base
left join RBA_TC_PYL pl
  on base.user_id = pl.user_id
  and base.f_cartera_m0 = pl.f_cartera
  and base.mob = pl.mob
left join `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PREVISION_PORCENT_PECASTANHO` prev
  on (base.dpd >= prev.dpd_from and base.dpd <= prev.dpd_to)
;


create or replace temp table SAIDA
as
select
   *
  ,safe_multiply(deuda, porc_prevision_mp) as deuda_prevision_mp
  ,safe_multiply(deuda, porc_prevision_2682) as deuda_prevision_2682
  ,safe_multiply(tpv_acum_m0, porc_tasa_visa) as co_visa_acum_m0
from JOINS
;


insert into `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_PL_MOB_PECASTANHO` (
  user_id
  ,f_mes_acc_carga
  ,f_acc_carga
  ,f_acc_impacto
  ,campaign_id
  ,produto
  ,audiencia
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
  ,nise_hoy
  ,renta_monto_hoy
  ,renta_source_hoy
  ,nise_acc
  ,renta_monto_acc
  ,renta_source_acc
  ,deuda_30d_clean
  ,deuda_30d_total
  ,deuda_all_clean
  ,deuda_all_total
  ,deuda_venc_over30_clean
  ,deuda_venc_over30_total
  ,porc_endeu_clean
  ,porc_endeu_total
  ,fx_porc_endeu_clean
  ,flag_venc_over30_100
  ,flag_sellers
  ,porc_uso_real_tc
  ,f_emision_dt
  ,score_bvs
  ,score_serasa
  ,rating_externo
  ,rci_conj
  ,porc_iu_pre
  ,porc_iu_post
  ,limit_amount_tc_acc_pre
  ,limit_amount_tc_acc_post
  ,flag_fraude_ito
  ,multip_limite
  ,fx_multip_limite
  ,campaign_group_trat
  ,f_cartera_m0
  ,mob
  ,deuda_over30
  ,deuda
  ,dpd
  ,tpv
  ,tpv_acum
  ,tpv_acum_m0
  ,tpv_acum_m1
  ,rev_pix
  ,co_pix
  ,rev_interchange_fee
  ,rev_revolving
  ,rev_punitorio
  ,rev_parcelamento
  ,rev_withdrawal
  ,rev_overlimit
  ,co_sales_taxes
  ,co_funding_cost
  ,co_procesador_cajero
  ,co_collection_fee
  ,co_emision_envio
  ,co_bureau
  ,co_cobranzas
  ,co_sales_expenses
  ,co_financing_psj
  ,co_chargebacks
  ,co_marketing
  ,co_cx
  ,co_hosting
  ,co_meli_mais
  ,co_agreements
  ,deuda_financiada
  ,co_visa_viejo
  ,co_sales_expenses_viejo
  ,rev_pix_acum_m0
  ,co_pix_acum_m0
  ,rev_interchange_fee_acum_m0
  ,rev_revolving_acum_m0
  ,rev_punitorio_acum_m0
  ,rev_parcelamento_acum_m0
  ,rev_withdrawal_acum_m0
  ,rev_overlimit_acum_m0
  ,co_sales_taxes_acum_m0
  ,co_funding_cost_acum_m0
  ,co_procesador_cajero_acum_m0
  ,co_collection_fee_acum_m0
  ,co_emision_envio_acum_m0
  ,co_bureau_acum_m0
  ,co_cobranzas_acum_m0
  ,co_sales_expenses_acum_m0
  ,co_financing_psj_acum_m0
  ,co_chargebacks_acum_m0
  ,co_marketing_acum_m0
  ,co_cx_acum_m0
  ,co_hosting_acum_m0
  ,co_meli_mais_acum_m0
  ,co_agreements_acum_m0
  ,co_sales_expenses_viejo_acum_m0
  ,co_visa_viejo_acum_m0
  ,f_cartera
  ,porc_prevision_mp_all
  ,porc_prevision_2682
  ,porc_prevision_mp
  ,deuda_prevision_mp
  ,deuda_prevision_2682
  ,co_visa_acum_m0
)
select
  *
from SAIDA
;



end for
;