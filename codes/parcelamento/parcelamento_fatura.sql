create or replace table `TMP.mlb_tc_repricing_parcelamento_base_1`
as
with
fonte00 as ( -- cuentas active actuales
  select
     acc.ccard_account_id
    ,acc.cus_cust_id as user_id
    ,date(acc.ccard_account_creation_dt) as ccard_account_creation_dt
    ,acc.ccard_account_status
    ,acc.ccard_account_status_det
    ,acc.sit_site_id
    ,acc.ccard_processor_id
    ,acc.ccard_risk_analysis_score as score_ccard_risk
    ,ovlmt_pre.ccard_ovc_add_percentage as tasa_ovlmt_pre
    ,case when ovlmt_pre.ccard_ovc_add_percentage > 0 then 1 else 0 end flag_overlimit
  from `WHOWNER.BT_CCARD_ACCOUNT` acc
  left join `WHOWNER.BT_CCARD_OVERLIMIT_CONFIG` ovlmt_pre
    on acc.ccard_risk_analysis_score = ovlmt_pre.ccard_ovc_rating
  where 1=1
    and acc.ccard_account_status = 'active'
    and acc.sit_site_id = 'MLB'
    -- and acc.ccard_risk_analysis_score not in ('K','Q','S','V')
    -- and cus_cust_id = 353789723
    -- and cus_cust_id = 148410964
),
fonte01 as ( -- scores
  with
  fonte01_0 as ( -- fechas usadas para cada rating
    select
       max(score_behavior_tc_date) as f_score_bhv_tc
      ,max(score_parcelado_tc_date) as f_score_parc_tc
      ,max(score_upsell_tc_date) as f_score_upsell_tc
    from `SBOX_IT_CREDITS_CREDITSTBL.CC_FRIDAY_SCORING`
    where 1=1
      and internal_rating_behavior_tc is not null
      and internal_group_parcelado_tc is not null
  ),
  fonte01_1 as ( -- traer los modelos para las fechas
    select 
       cus_cust_id as user_id
      ,max(case when score_parcelado_tc_date = (select f_score_parc_tc from fonte01_0) then internal_group_parcelado_tc else null end) as rating_parc_tc
      ,max(case when score_behavior_tc_date = (select f_score_bhv_tc from fonte01_0) then internal_rating_behavior_tc else null end) as rating_bhv_tc
      ,max(case when score_upsell_tc_date = (select f_score_upsell_tc from fonte01_0) then internal_rating_upsell_tc else null end) as rating_upsell_tc
    from `SBOX_IT_CREDITS_CREDITSTBL.CC_FRIDAY_SCORING`
    where 1=1
      and sit_site_id = 'MLB'
      and cus_cust_id in (select distinct user_id from fonte00)
      -- and cus_cust_id = 353789723
    group by 1
  )
  select
    *
    -- count(1)
  from fonte01_1
  where 1=1
    and rating_bhv_tc is not null
    and rating_parc_tc is not null
  -- limit 10
),
fonte02 as ( -- friday DD
  select
     cus_cust_id as user_id
    ,coalesce(cast(flag_meli_employee as int64),0) as flag_meli_employee
    ,coalesce(cast(flag_portability as int64),0) as flag_portability
    -- ,coalesce(cast(flag_corporate_benefit as int64),0) as flag_corporate_benefit
    ,nise
    ,score_positivo_pf
  from `SBOX_IT_CREDITS_CREDITSTBL.CC_FRIDAY_DESCRIPTIVE_DATA_MLB`
  where 1=1
    and cus_cust_id in (select distinct user_id from fonte00)
    -- and coalesce(cast(flag_portability as int64),0) is null
    -- and flag_portability is null
    -- and cus_cust_id = 353789723
  -- limit 10
),
fonte03 as ( -- limites a hoy
  select
     cus_cust_id as user_id
    ,ccard_limit_general as limit_amount_tc
    ,date(ccard_limit_update_dttm) as ccard_limit_upd_dt
    ,lower(ccard_limit_operation_type) as status_lmt
  from `WHOWNER.BT_CCARD_LIMIT_HIST`
  where 1=1
    and sit_site_id = 'MLB'
    and cus_cust_id in (select distinct user_id from fonte00)
    -- and cus_cust_id = 148410964
  qualify row_number() over (partition by cus_cust_id order by ccard_limit_update_dttm desc) = 1
),
fonte04 as ( -- propuestas
  select
     cus_cust_id as user_id
    ,ccard_global_limit_amt_lc as limit_amount_tc_prop
  from `WHOWNER.BT_CCARD_PROPOSAL`
  where 1=1
    and sit_site_id = 'MLB'
    and trim(lower(ccard_prop_status)) = 'accepted'
    and cus_cust_id in (select distinct user_id from fonte00)
    -- and cus_cust_id = 148410964
  qualify row_number() over (partition by cus_cust_id order by ccard_prop_creation_dt desc) = 1
),
fonte05 as ( -- tasas
  select
     prod.ccard_prod_id
    ,prod.ccard_prod_name
    ,rating.ccard_prod_rating_id
    ,rating.ccard_prod_rating_name
    ,tasa.ccard_prod_inst_id
    ,tasa.ccard_prod_inst_interest
    ,tasa.ccard_prod_inst_created as f_tasa_upd_dttm
  from `WHOWNER.LK_CCARD_PROD_PRODUCTS` prod
  left join `WHOWNER.LK_CCARD_PROD_RATINGS` rating
    on prod.ccard_prod_id = rating.ccard_prod_id
  left join `WHOWNER.LK_CCARD_PROD_INST_PLAN` tasa
    on tasa.ccard_prod_rating_id = rating.ccard_prod_rating_id
  where 1=1
    and prod.sit_site_id = 'MLB'
    and prod.ccard_prod_name = 'TC-VISA-GOLD-MLB'
  qualify row_number() over (partition by prod.ccard_prod_id, rating.ccard_prod_rating_id order by tasa.ccard_prod_inst_created desc) = 1
),
fonte06 as ( -- pixeros
  select distinct
     cust_id_payer as user_id
    ,1 as flag_pix_12m
  from `meli-bi-data.WHOWNER.BT_MP_PIX_ALL`
  where 1=1
    and sit_site_id = 'MLB'
    and pay_method = 'credit_card'
    and pay_method_detail_2 = 'tarjeta propria'
    and (pay_move_date >= date(date_add(current_date, interval -360 day)) and pay_move_date <= current_date)
    and cust_id_payer in (select distinct user_id from fonte00)
    -- and cust_id_payer = 148410964
),
fonte07 as (
  select distinct
    cus_cust_id as user_id
    ,1 as flag_killer_temp_manual
  from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_OVERLIMIT_20241001_MABANUS`
),
joins00 as (
  select
     acc.*
    ,scores.* except(user_id)
    ,friday.* except(user_id)
    ,lmt.* except(user_id)
    ,prop.* except(user_id)
    ,coalesce(lmt.limit_amount_tc, prop.limit_amount_tc_prop) as limit_amount_tc_hoy
    ,case when coalesce(lmt.limit_amount_tc, prop.limit_amount_tc_prop) >= 500 then 1 else 0 end as flag_tc_full
    ,coalesce(pix.flag_pix_12m,0) as flag_pix_12m
    ,case when safe_cast(clasif.clasif as int64) > 7 and safe_cast(clasif.clasif as int64) <= 14 then 1 else 0 end as flag_riesgos
    ,safe_cast(clasif.clasif as int64) as grupo_riesgos
    ,case when friday.nise = 'BRONZE' or friday.nise = 'SILVER' then 1 else 0 end as flag_nises
    ,case when ccard_account_creation_dt > current_date - interval '360' day then 1 else 0 end as flag_ant_12m
    -- ,case when greatest(coalesce(friday.flag_portability,0), coalesce(friday.flag_corporate_benefit,0), coalesce(friday.flag_meli_employee,0)) = 1 then 1 else 0 end as flag_preferencial
    ,case when greatest(coalesce(friday.flag_portability,0), coalesce(friday.flag_meli_employee,0)) = 1 then 1 else 0 end as flag_preferencial
    ,coalesce(tmp.flag_killer_temp_manual, 0) as flag_killer_temp_manual
  from fonte00 acc
  left join fonte01 scores using(user_id)
  left join fonte02 friday using(user_id)
  left join fonte03 lmt using(user_id)
  left join fonte04 prop using(user_id)
  left join fonte06 pix using(user_id)
  left join fonte07 tmp using(user_id)
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_CLASIF_BHV_UPSELL_PECASTANHO` clasif
   on scores.rating_bhv_tc = clasif.bhv
    and scores.rating_upsell_tc = clasif.upsell
    and clasif.valid_to_dt = date('9999-12-31')
),
ant01 as ( -- flag overlimit killer pixeros
  select
     *
    ,case 
      when flag_pix_12m = 1
        and score_positivo_pf < 500
        and flag_nises = 1
        and flag_ant_12m = 1
        and flag_riesgos = 1
        and flag_overlimit = 1
        and limit_amount_tc_hoy >= 500
        and flag_preferencial = 0 then 1 
      else 0 end as flag_killer_ovlmt_pix
  from joins00
),
ant02 as ( -- politica pricing
  select
     base.*
    ,tasa.grupo as grupo_tasa
    ,ovlmt.grupo as grupo_ovlmt
    ,case
      when base.score_ccard_risk in ('K','S','V') then base.score_ccard_risk
      when base.flag_killer_temp_manual = 1 then base.score_ccard_risk
      else rating.rating end as score_ccard_risk_nuevo
    ,case
      when base.score_ccard_risk in ('K','S','V') then base.score_ccard_risk
      when base.flag_killer_temp_manual = 1 then base.score_ccard_risk
      when base.ccard_processor_id = 'monza' then base.score_ccard_risk
      else rating.rating end as score_ccard_risk_nuevo_sin_monza -- temporario para correcao de limites usuarios monza
  from ant01 base
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_PARAMS_TASA` tasa
    on coalesce(base.rating_bhv_tc, 'Z') = tasa.bhv
    and coalesce(base.rating_parc_tc, 'Z') = tasa.parc
    and base.flag_tc_full = tasa.tc_full
    and coalesce(base.flag_meli_employee,0) = tasa.meli
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_PARAMS_OVERLIMIT` ovlmt
    on base.flag_tc_full = ovlmt.tc_full
    and base.flag_overlimit = ovlmt.flag_overlimit
    and coalesce(base.flag_portability,0) = ovlmt.flag_portability
    and base.flag_killer_ovlmt_pix = ovlmt.flag_killer_ovlmt_pix
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_PARAMS_RATING` rating
    on tasa.grupo = rating.grupo_tasa
    and ovlmt.grupo = rating.grupo_ovlmt
),
ant03 as (
  select
     acc.*
    ,ovlmt_post.ccard_ovc_add_percentage as tasa_ovlmt_post
    ,replace(cast(tasa_pre.ccard_prod_inst_interest as string), '.', ',') as tasa_pre
    ,replace(cast(tasa_post.ccard_prod_inst_interest as string), '.', ',') as tasa_post
    ,ovlmt_post_monza.ccard_ovc_add_percentage as tasa_ovlmt_post_monza
    ,replace(cast(tasa_pre_monza.ccard_prod_inst_interest as string), '.', ',') as tasa_pre_monza
    ,replace(cast(tasa_post_monza.ccard_prod_inst_interest as string), '.', ',') as tasa_post_monza
  from ant02 acc
  left join `WHOWNER.BT_CCARD_OVERLIMIT_CONFIG` ovlmt_post
    on acc.score_ccard_risk_nuevo = ovlmt_post.ccard_ovc_rating
  left join fonte05 tasa_pre
    on acc.score_ccard_risk = tasa_pre.ccard_prod_rating_name
  left join fonte05 tasa_post
    on acc.score_ccard_risk_nuevo = tasa_post.ccard_prod_rating_name
  left join `WHOWNER.BT_CCARD_OVERLIMIT_CONFIG` ovlmt_post_monza
    on acc.score_ccard_risk_nuevo = ovlmt_post_monza.ccard_ovc_rating
  left join fonte05 tasa_pre_monza
    on acc.score_ccard_risk = tasa_pre_monza.ccard_prod_rating_name
  left join fonte05 tasa_post_monza
    on acc.score_ccard_risk_nuevo = tasa_post_monza.ccard_prod_rating_name
)
select
  *
from ant03
;


select
   user_id
  ,count(user_id)
from `TMP.mlb_tc_repricing_parcelamento_base_1`
group by 1
having count(user_id)>1
;



create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_BAU_BASE_202410_PECASTANHO`
as
select
   user_id
  ,ccard_account_id as account_id
  ,score_ccard_risk_nuevo as rating
  ,'pecastanho' as aud_ins_user
  ,'MLB' as site_id
from `TMP.mlb_tc_repricing_parcelamento_base_1`
where 1=1
  -- and score_ccard_risk <> score_ccard_risk_nuevo
  and score_ccard_risk <> score_ccard_risk_nuevo_sin_monza
;


select
   user_id
  ,count(user_id)
from `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_BAU_BASE_202410_PECASTANHO`
group by 1
having count(user_id)>1
;


select
  count(user_id)
from `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_BAU_BASE_202410_PECASTANHO`
;


select
  *
from `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_BAU_BASE_202410_PECASTANHO`
limit 10
;



select
   count(parc.user_id) as cant_parc
  ,count(bau.cus_cust_id) as cant_bau
from `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_BAU_BASE_202410_PECASTANHO` parc
left join `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20241017_CGALUCCIO` bau
  on parc.user_id = bau.cus_cust_id
;


select
  count(1)
from `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20241017_CGALUCCIO`
;



select
   user_id
  ,score_ccard_risk
  ,score_ccard_risk_nuevo
  ,limit_amount_tc_hoy
  ,limit_amount_tc_prop
  ,tasa_pre
  ,tasa_post
  ,tasa_ovlmt_pre
  ,tasa_ovlmt_post
from `TMP.mlb_tc_repricing_parcelamento_base_1`
where 1=1
  and score_ccard_risk <> score_ccard_risk_nuevo_sin_monza
  and tasa_ovlmt_pre = 10
  and tasa_ovlmt_post = 0
  and flag_killer_ovlmt_pix = 0
  and limit_amount_tc_prop >= 300
limit 10
;




/*
INSERT CAMPANA

-- IMPACTADOS
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` (
Sit_site_id,
Negocio,
Product_desc,
Campaign_type,
Policy,
Policy_category,
Policy_subcategory,
Policy_description,
Campaign_group,
Campaign_group_desc
)
VALUES(
'MLB', --SIT_SITE_ID
'TC', --NEGOCIO
'TC', --PRODUCT_DESC
'PARCELAMENTO', --CAMPAIGN_TYPE
'BAU', --POLICY
'BAU', --POLICY_CATEGORY
'BAU', --POLICY_SUBCATEGORY
'SCORE BHV + SCORE POST PARCELAMENTO', --POLICY_DESCRIPTION
'IMPACTO_1', --CAMPAIGN_GROUP
'IMPACTADOS BASE UNICA' --CAMPAIGN_GROUP_DESC
);

--Segundo paso
CALL `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX_AUTOCOMPLETE`();

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'pedro.castanho@mercadopago.com.br'
  and campaign_group_desc = 'IMPACTADOS BASE UNICA'
  and negocio = 'TC'
  and product_desc = 'TC'
  and campaign_type = 'PARCELAMENTO'
  and policy = 'BAU'
  and campaign_date = current_date('-03')
qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
;

*/


/*
INSERT EN CEREBRO

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_CAMBIO_RATING(
    USER_ID,
    ACCOUNT_ID,
    RATING,
    SITE_ID,
    CAMPAIGN_ID,
    AUD_INS_USER)
select
     user_id
    ,account_id
    ,rating
    ,site_id
    ,cast(
        (
          select
            campaign_id
          from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
          where 1=1
            and aud_ins_user = 'pedro.castanho@mercadopago.com.br'
            and campaign_group_desc = 'IMPACTADOS BASE UNICA'
            and negocio = 'TC'
            and product_desc = 'TC'
            and campaign_type = 'PARCELAMENTO'
            and policy = 'BAU'
            and campaign_date = current_date('-03')
          qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
        ) as string) as campaign_id
    ,aud_ins_user
FROM `SBOX_CREDITS_SB.RBA_TC_MLB_PRICING_PARCELADO_BAU_BASE_202410_PECASTANHO`
;

Esta declaración agregó 3,275,929 filas a EOC_TC_C_CAMBIO_RATING.

select 
  *
from meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_CAMBIO_RATING
limit 100
;

select 
    count(1)
from meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_CAMBIO_RATING
-- 3.275.929

select
   user_id
  ,count(user_id)
from `SBOX_CREDITS_SB.EOC_TC_C_CAMBIO_RATING`
group by 1
having count(user_id)>1
;

select
   aud_ins_user
  ,campaign_id
  ,count(1) as cant
from `SBOX_CREDITS_SB.EOC_TC_C_CAMBIO_RATING`
group by all
order by 1 asc, 2 asc
;


*/

/*
delete from `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_CAMBIO_RATING`
where user_id in (
    select distinct
       a.USER_ID
    from `SBOX_CREDITS_SB.parcelamento_03_24_INSERT_loteado` a
    left join `meli-bi-data.SBOX_CREDITS_SB.m500_FINAL_FEB2024_sin_over_cerebro` b
      on a.user_id = b.cus_cust_id
    where 1=1
      and b.cus_cust_id is not null
      and a.lote = 0
)
;

select distinct
   a.USER_ID
from `SBOX_CREDITS_SB.parcelamento_03_24_INSERT` a
left join `meli-bi-data.SBOX_CREDITS_SB.m500_FINAL_FEB2024_sin_over_cerebro` b
  on a.user_id = b.cus_cust_id
where 1=1
  and b.cus_cust_id is null
;

select distinct
   a.USER_ID
from `SBOX_CREDITS_SB.EOC_TC_C_CAMBIO_RATING` a
left join `meli-bi-data.SBOX_CREDITS_SB.m500_FINAL_FEB2024_sin_over_cerebro` b
  on a.user_id = b.cus_cust_id
where 1=1
  and b.cus_cust_id is not null
;





*/





