-- create or replace table `meli-bi-data.TMP.TMP_PARCELAMENTO_IMPACTOS_202501_SEM_OVLMT` AS 

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
ant01 as ( 
  select
     *except(rating_bhv_tc, rating_parc_tc)
    ,ifnull(rating_bhv_tc, 'Z') as rating_bhv_tc
    ,ifnull(rating_parc_tc, 'Z') as rating_parc_tc
  from joins00
),
ant02 as ( -- politica pricing
  select 
    *,
    case 
      when score_ccard_risk in ('K','S','V') then score_ccard_risk
      when grupo_tasa = 1 and grupo_overlimit = 1 then 'W'
      when grupo_tasa = 2 and grupo_overlimit = 1 then 'I'
      when grupo_tasa = 3 and grupo_overlimit = 1 then 'J'
      when grupo_tasa = 4 and grupo_overlimit = 1 then 'Q'
      when grupo_tasa = 1 and grupo_overlimit = 2 then 'G'
      when grupo_tasa = 2 and grupo_overlimit = 2 then 'F'
      when grupo_tasa = 3 and grupo_overlimit = 2 then 'H'
      when grupo_tasa = 4 and grupo_overlimit = 2 then 'A'
      else 'VERIFICAR'
    end score_ccard_risk_nuevo
  from
  (
    select  
      *
      ,case
        -- secos
        when flag_meli_employee = 1 then 1 -- empleado 10.9%
        when flag_tc_full = 0 and rating_bhv_tc NOT IN ('Z') and rating_parc_tc NOT IN ('Z') then 3 -- MTC 15.9%
        
        -- grupo 1 (10.9%)
        when rating_bhv_tc IN ('A', 'B', 'C', 'D', 'E') and rating_parc_tc in ('I','II') then 1

        -- grupo 2 (13.7%)
        when rating_bhv_tc IN ('A', 'B', 'C', 'D', 'E') and rating_parc_tc in ('III','IV', 'V') then 2
        when rating_bhv_tc IN ('F', 'G', 'H', 'I', 'J') and rating_parc_tc in ('I','II','III','IV') then 2

        -- grupo 3 (15.9%)
        when rating_bhv_tc IN ('F', 'G', 'H', 'I', 'J') and rating_parc_tc in ('V') then 3

        -- grupo 4
        when rating_bhv_tc IN ('Z') and rating_parc_tc IN ('Z') then 4

        else -1 -- verificar
      end as grupo_tasa

      -- tem overlimit --> mantem overlimit
      ,case when flag_overlimit = 1 then 1 else 2 end as grupo_overlimit
      from ant01 base
    )
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