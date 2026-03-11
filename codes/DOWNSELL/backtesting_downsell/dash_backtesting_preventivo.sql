create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_PREVENTIVO_BACKTESTING_20250723_3_GUBELARMINO` as

with sin_preaviso as (
  select
    cus_cust_id,
    case 
      when crd_internal_rating = 9 then 'a. rating bureau 9'
      when crd_internal_rating = 10 then 'b. rating bureau 10'
    end as waterfall,
    fx_iu,
    real_use_level_val_tc as iu,
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_CON_PREAVISO_202503_AUDIENCIA_ATUALIZADA_GUBELARMINO`
  WHERE funnel = 'z. elegivel pos killer'
  AND waterfall_downsell_con_preaviso = 'a. Elegible downsell con preaviso'
  AND waterfall_downsell_sin_preaviso = 'z. nao elegivel'
),

con_preaviso as (
  select
    cus_cust_id,
    fx_iu,
    waterfall,
    real_use_level_val_tc as iu,
    CASE
        WHEN waterfall = 'a. Solo endeud. ext.' AND flag_control = 'GC' AND RAND() < 0.35 THEN 1
        WHEN waterfall = 'a. Solo endeud. ext.' AND flag_control = 'GI' AND RAND() < 0.70 THEN 1
        WHEN waterfall = 'b. Solo deterioro deuda 30d clean 3m' AND flag_control = 'GC' AND RAND() < 0.65 THEN 1
        WHEN waterfall = 'b. Solo deterioro deuda 30d clean 3m' AND flag_control = 'GI' AND RAND() < 0.70 THEN 1
        WHEN waterfall = 'c. Solo deuda vencida over 30' AND flag_control = 'GC' AND RAND() < 0.90 THEN 1
        WHEN waterfall = 'c. Solo deuda vencida over 30' AND flag_control = 'GI' AND RAND() < 0.70 THEN 1
        WHEN waterfall = 'd. Elegible a más que un testeo' AND flag_control = 'GC' AND RAND() < 0.40 THEN 1
        WHEN waterfall = 'd. Elegible a más que un testeo' AND flag_control = 'GI' AND RAND() < 0.70 THEN 1
        ELSE 0
    end as fl_amostra_estratificada,
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_TESTEOS_202403_AUDIENCIA_FINAL_GUBELARMINO`
)

select
  backtest.*
  -- ,PL_components.*except(user_id, f_cartera, mob)
  ,case
   when grupo_riesgo <= 1 then 'a. Muy bajo'
   when grupo_riesgo <= 2 then 'b. Bajo'
   when grupo_riesgo <= 5 then 'c. Medio'
   when grupo_riesgo <= 14 then 'd. Alto'
   else 'e. a ver' end as nivel_riesgo_ajust
  ,case
    when grupo_riesgo <= 1 then 'a. A+'
    when grupo_riesgo <= 2 then 'b. A'
    when grupo_riesgo <= 5 then 'c. B+'
    when grupo_riesgo <= 7 then 'd. B'
    when grupo_riesgo <= 14 then 'e. C'
    else 'f. a ver' end as nivel_riesgo_ajust_2
  ,case
    when nise in ('a. PLATINUM' , 'b. GOLD') then 'a. GOLD+'
    else nise end as nise_ajust
  ,coalesce(sin_preaviso.fx_iu, con_preaviso.fx_iu) as fx_iu
  ,coalesce(sin_preaviso.iu, con_preaviso.iu) as iu
  ,porc_uso_real_tc as iu_mob
  ,coalesce(sin_preaviso.waterfall, con_preaviso.waterfall) as waterfall
  ,fl_amostra_estratificada
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_2_PECASTANHO` backtest
left join sin_preaviso on user_id = sin_preaviso.cus_cust_id
left join con_preaviso on user_id = con_preaviso.cus_cust_id
where 1=1 
and f_mes_acc_carga in ('2025-03-01', '2025-04-01')
and `policy` IN ('INFO EXTERNA')
and campaign_id not in ('b9ee8ad2-8def-4865-b267-715935910177')
and backtest.mob <= 4


create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_PREVENTIVO_BACKTESTING_20250723_2_GUBELARMINO` as

with sin_preaviso as (
  select
    cus_cust_id,
    case 
      when crd_internal_rating = 9 then 'a. rating bureau 9'
      when crd_internal_rating = 10 then 'b. rating bureau 10'
    end as waterfall,
    fx_iu
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_CON_PREAVISO_202503_AUDIENCIA_ATUALIZADA_GUBELARMINO`
  WHERE funnel = 'z. elegivel pos killer'
  AND waterfall_downsell_con_preaviso = 'a. Elegible downsell con preaviso'
  AND waterfall_downsell_sin_preaviso = 'z. nao elegivel'
),

con_preaviso as (
  select
    cus_cust_id,
    fx_iu,
    waterfall      
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_TESTEOS_202403_AUDIENCIA_FINAL_GUBELARMINO`
)

select
  backtest.*
  -- ,PL_components.*except(user_id, f_cartera, mob)
  ,case
   when grupo_riesgo <= 1 then 'a. Muy bajo'
   when grupo_riesgo <= 2 then 'b. Bajo'
   when grupo_riesgo <= 5 then 'c. Medio'
   when grupo_riesgo <= 14 then 'd. Alto'
   else 'e. a ver' end as nivel_riesgo_ajust
  ,case
    when grupo_riesgo <= 1 then 'a. A+'
    when grupo_riesgo <= 2 then 'b. A'
    when grupo_riesgo <= 5 then 'c. B+'
    when grupo_riesgo <= 7 then 'd. B'
    when grupo_riesgo <= 14 then 'e. C'
    else 'f. a ver' end as nivel_riesgo_ajust_2
  ,case
    when nise in ('a. PLATINUM' , 'b. GOLD') then 'a. GOLD+'
    else nise end as nise_ajust
  ,coalesce(sin_preaviso.fx_iu, con_preaviso.fx_iu) as fx_iu
  ,coalesce(sin_preaviso.waterfall, con_preaviso.waterfall) as waterfall
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_2_PECASTANHO` backtest
left join sin_preaviso on user_id = sin_preaviso.cus_cust_id
left join con_preaviso on user_id = con_preaviso.cus_cust_id
where 1=1 
and f_mes_acc_carga in ('2025-03-01', '2025-04-01')
and `policy` IN ('INFO EXTERNA', 'BAU')
and campaign_id not in ('b9ee8ad2-8def-4865-b267-715935910177')
and backtest.mob <= 4


/*
-- old --
-- create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_PREVENTIVO_BACKTESTING_20250723_GUBELARMINO` as

with sin_preaviso as (
  select
    cus_cust_id,
    case 
      when crd_internal_rating = 9 then 'a. rating bureau 9'
      when crd_internal_rating = 10 then 'b. rating bureau 10'
    end as waterfall,
    fx_iu
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_CON_PREAVISO_202503_AUDIENCIA_ATUALIZADA_GUBELARMINO`
  WHERE funnel = 'z. elegivel pos killer'
  AND waterfall_downsell_con_preaviso = 'a. Elegible downsell con preaviso'
  AND waterfall_downsell_sin_preaviso = 'z. nao elegivel'
),

con_preaviso as (
  select
    cus_cust_id,
    fx_iu,
    waterfall      
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_TESTEOS_202403_AUDIENCIA_FINAL_GUBELARMINO`
)

,PL_components as (
  select
    user_id
    ,f_cartera
    ,mob
    ,rev_interchange_fee_acum
    ,rev_revolving_acum
    ,rev_punitorio_acum
    ,rev_parcelamento_acum
    ,rev_withdrawal_acum
    ,rev_overlimit_acum
    ,co_sales_taxes_acum
    ,co_funding_cost_acum
    ,co_procesador_cajero_acum
    ,co_collection_fee_acum
    ,co_emision_envio_acum
    ,co_visa_acum
    ,co_bureau_acum
    ,co_cobranzas_acum
    ,co_sales_expenses_acum
    ,co_marketing_acum
    ,co_cx_acum
    ,co_hosting_acum
    ,co_meli_mais_acum
    -- ,co_agreements_acum
  from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_MOB_PECASTANHO`
  where f_cartera >= '2025-02-01'
)

select
  backtest.*
  ,PL_components.*except(user_id, f_cartera, mob)
  ,case
   when grupo_riesgo <= 1 then 'a. Muy bajo'
   when grupo_riesgo <= 2 then 'b. Bajo'
   when grupo_riesgo <= 5 then 'c. Medio'
   when grupo_riesgo <= 14 then 'd. Alto'
   else 'e. a ver' end as nivel_riesgo_ajust
  ,case
    when grupo_riesgo <= 1 then 'a. A+'
    when grupo_riesgo <= 2 then 'b. A'
    when grupo_riesgo <= 5 then 'c. B+'
    when grupo_riesgo <= 7 then 'd. B'
    when grupo_riesgo <= 14 then 'e. C'
    else 'f. a ver' end as nivel_riesgo_ajust_2
  ,case
    when nise in ('a. PLATINUM' , 'b. GOLD') then 'a. GOLD+'
    else nise end as nise_ajust
  ,coalesce(sin_preaviso.fx_iu, con_preaviso.fx_iu) as fx_iu
  ,coalesce(sin_preaviso.waterfall, con_preaviso.waterfall) as waterfall
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_2_PECASTANHO` backtest
left join sin_preaviso on user_id = sin_preaviso.cus_cust_id
left join con_preaviso on user_id = con_preaviso.cus_cust_id
left join PL_components on backtest.user_id = PL_components.user_id and backtest.mob = PL_components.mob and backtest.f_cartera_m0 = PL_components.f_cartera
where 1=1 
and f_mes_acc_carga in ('2025-03-01', '2025-04-01')
and `policy` = 'INFO EXTERNA'
and campaign_id not in ('b9ee8ad2-8def-4865-b267-715935910177')
and backtest.mob <= 4
-- and backtest.user_id = 652809353
---------
*/