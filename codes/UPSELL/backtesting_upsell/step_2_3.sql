declare f_start date;
declare f_start_m_1 date;
set f_start = (select min(f_mes_acc_carga) from `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO`);
set f_start_m_1 = date(f_start - interval 1 month);


create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_2_PECASTANHO`
as
with
fonte00 as (
  select
    *
  from `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_1_PECASTANHO`
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
fonte03 as ( -- VU NISE y renta
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
    and cus_cust_id in (select distinct user_id from fonte00)
),
fonte04 as ( -- marca Sellers
  select
     valid_from_dt
    ,valid_to_dt
    ,cus_cust_id as user_id
    ,case when risk_management_tag = 'MERCHANT' then 1 else 0 end as flag_sellers
  from `WHOWNER.LK_VU_PROSPECT_UNIVERSE`
  where 1=1
    and sit_site_id = 'MLB'
    and cus_cust_id in (select distinct user_id from fonte00)
    -- and cus_cust_id = 353789723
    and valid_to_dt >= f_start
),
fonte05 as ( -- fecha emision
  select
     cus_cust_id as user_id
    ,date(ccard_account_creation_dt) as f_emision_dt
  from `WHOWNER.BT_CCARD_ACCOUNT`
  where 1=1
    and sit_site_id = 'MLB'
    and ccard_account_prov_id is not null
    and cus_cust_id in (select distinct user_id from fonte00)
),
fonte06 as ( -- VU RCI
  select
     valid_from_dt
    ,valid_to_dt
    ,cus_cust_id as user_id
    ,real_use_level_val as porc_uso_real_tc
  from `WHOWNER.BT_VU_RCI`
  where 1=1
    and sit_site_id = 'MLB'
    and crd_prod_def_type_sk = 3
    and valid_from_dt >= f_start
    and cus_cust_id in (select distinct user_id from fonte00)
),
fonte07 as ( -- scores BVS y Serasa
  select
     period_dt as f_cartera
    ,cus_cust_id as user_id
    ,serasa_score_val as score_serasa
    ,bvs_score_val as score_bvs
  from `WHOWNER.BT_VU_PRESUMED_INCOME`
  where 1=1
    and sit_site_id = 'MLB'
    and cus_cust_id in (select distinct user_id from fonte00)
    and period_dt >= f_start_m_1
),
fonte08 as ( -- productos Credit VU
  select
     crd.valid_from_dt
    ,crd.valid_to_dt
    ,crd.cus_cust_id as user_id
    ,crd.crd_prod_def_type_sk as product_id
    ,prod.crd_prod_def_type_abv as product_abv
  from `WHOWNER.BT_VU_CREDIT` crd
  left join `WHOWNER.LK_VU_CREDIT_PRODUCTS` prod
  on crd.crd_prod_def_type_sk = prod.crd_prod_def_type_sk
  where 1=1
    and crd.sit_site_id = 'MLB'
    and crd.crd_credit_status <> 'PENDING'
    and crd.cus_cust_id in (select distinct user_id from fonte00)
),
fonte09 as ( -- SCR
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
),
fonte10 as ( -- VU NISE y renta modelling
  select
     valid_from_dt
    ,valid_to_dt
    ,user_id
    ,nise
    ,renta_monto
    ,renta_source
  from fonte03
  where 1=1
    and nise is not null
  qualify row_number() over (partition by user_id order by valid_from_dt asc) = 1
),
joins00 as (
  select
     acc.* except(rating_bhv_tc_acc)
    -- / --
    ,coalesce(acc.rating_bhv_tc_acc, bhv.rating_behavior_tc_acc) as rating_bhv_tc_acc
    ,upsell.rating_upsell_tc_acc
    ,coalesce(renta.nise, renta_hist.nise) as nise
    ,coalesce(renta.renta_monto, renta_hist.renta_monto) as renta_monto
    ,coalesce(renta.renta_source, renta_hist.renta_source) as renta_source
    ,renta.nise_acc
    ,renta.renta_monto_acc
    ,renta.renta_source_acc
    ,safe_cast(clasif.clasif as int64) as grupo_riesgo
    ,sellers.flag_sellers
    ,ccard.* except(user_id)
    ,rci.* except(valid_from_dt, valid_to_dt, user_id)
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
    ,if(ito.cus_cust_id is not null, 1, 0) as flag_fraude_ito
    ,max(if(product_abv in ('LC','MXP','DE'), 1, 0)) as flag_crd_prod_cc
    ,max(if(product_abv in ('TC','MTC'), 1, 0)) as flag_crd_prod_tc
    ,max(if(product_abv in ('CF','PPV'), 1, 0)) as flag_crd_prod_mc
    ,max(if(product_abv in ('SL'), 1, 0)) as flag_crd_prod_sl
  from fonte00 acc
  left join fonte01 bhv
    on acc.user_id = bhv.user_id
    and acc.f_acc_carga between bhv.valid_from_dt and bhv.valid_to_dt
  left join fonte02 upsell
    on acc.user_id = upsell.user_id
    and acc.f_acc_carga between upsell.valid_from_dt and upsell.valid_to_dt
  left join fonte03 renta
    on acc.user_id = renta.user_id
    and (acc.f_acc_carga >= renta.valid_from_dt and acc.f_acc_carga < renta.valid_to_dt)
  left join fonte10 renta_hist
    on acc.user_id = renta_hist.user_id
  left join fonte04 sellers
    on acc.user_id = sellers.user_id
    and (acc.f_acc_carga >= sellers.valid_from_dt and acc.f_acc_carga < sellers.valid_to_dt)
  left join fonte05 ccard
    on acc.user_id = ccard.user_id
  left join fonte06 rci
    on acc.user_id = rci.user_id
    and (acc.f_acc_carga >= rci.valid_from_dt and acc.f_acc_carga < rci.valid_to_dt)
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_CLASIF_BHV_UPSELL_PECASTANHO` clasif
    on coalesce(acc.rating_bhv_tc_acc, bhv.rating_behavior_tc_acc) = clasif.bhv
    and upsell.rating_upsell_tc_acc = clasif.upsell
    and acc.f_mes_acc_carga between clasif.valid_from_dt and clasif.valid_to_dt
  left join fonte07 scores
    on acc.user_id = scores.user_id
    and acc.f_mes_acc_carga = scores.f_cartera
  left join `meli-bi-data.SBOX_CREDITS_SB.PARAM_RATING_EXT_GERAL` param
    on (scores.score_serasa >= param.serasa_min and scores.score_serasa <= param.serasa_max)
    and (scores.score_bvs >= param.bvs_min and scores.score_bvs <= param.bvs_max)
  left join fonte08 crd
    on acc.user_id = crd.user_id
    and (acc.f_acc_carga >= crd.valid_from_dt and acc.f_acc_carga < crd.valid_to_dt)
  left join `SBOX_COLLECTIONSDA.CCARD_MLB_USUARIOS_FRAUDE_DIC_2024` ito
    on acc.user_id = ito.cus_cust_id
  left join fonte09 scr
    on acc.user_id = scr.user_id
    and acc.f_acc_carga between scr.valid_from_dt and scr.valid_to_dt
  group by all
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
    ,case
      when flag_crd_prod_cc = 1 and (flag_crd_prod_tc + flag_crd_prod_mc + flag_crd_prod_sl) = 0 then 'a. Solo CC'
      when flag_crd_prod_tc = 1 and (flag_crd_prod_cc + flag_crd_prod_mc + flag_crd_prod_sl) = 0 then 'b. Solo TC'
      when (flag_crd_prod_tc + flag_crd_prod_cc) = 2 and (flag_crd_prod_mc + flag_crd_prod_sl) = 0 then 'c. Solo CC+TC'
      when (flag_crd_prod_tc + flag_crd_prod_cc) > 0 then 'd. Al menos CC+TC'
      when (flag_crd_prod_tc + flag_crd_prod_cc) = 0 and (flag_crd_prod_mc + flag_crd_prod_sl) > 0 then 'e. Sin TC ni CC'
      when (flag_crd_prod_tc + flag_crd_prod_cc + flag_crd_prod_mc + flag_crd_prod_sl) = 0 then 'f. Sin producto'
      else 'g. Otro' end as status_producto
  from joins00
)
select distinct
  *
from saida00
;