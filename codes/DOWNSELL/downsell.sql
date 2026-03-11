/*
Creando la tabla con todas las flags que hacen parte de la politica

Reemplezar el text 'YYYYMM' por el actual
*/

create or replace table `TMP.mlb_tc_downsell_bau_base_1`
as
with
fonte00 as ( -- base total de clientes en d0, sus propuestas y con los limites más actuales 
  with
  fonte00_0 as ( -- base total de clientes
    select 
       cus_cust_id
      ,ccard_account_id
      ,ccard_account_status
      ,ccard_account_status_det
      ,ccard_account_overdue_dt
      ,date_diff(current_date, ccard_account_overdue_dt, day) as dpd_tc
      ,ccard_risk_analysis_score
      ,ccard_processor_id
    from`WHOWNER.BT_CCARD_ACCOUNT`
    where 1=1
      and sit_site_id = 'MLB'
  ),
  fonte00_1 as ( -- propuestas de esos clientes
    select
       acc.*
      ,prop_tc.ccard_prop_creation_dt
      ,prop_tc.ccard_global_limit_amt_lc
    from fonte00_0 acc
    left join `WHOWNER.BT_CCARD_PROPOSAL` prop_tc
      on acc.cus_cust_id = prop_tc.cus_cust_id
    qualify row_number() over (partition by acc.cus_cust_id order by prop_tc.ccard_prop_creation_dt desc) = 1
  ),
  fonte00_2 as ( -- actualiza los limites para los más recientes
    select
       acc.*
      ,coalesce(lmt.ccard_limit_general, acc.ccard_global_limit_amt_lc) as limite_tc
    from fonte00_1 acc
    left join `WHOWNER.BT_CCARD_LIMIT_HIST` lmt
      on acc.cus_cust_id = lmt.cus_cust_id
    qualify row_number() over (partition by acc.cus_cust_id order by lmt.ccard_limit_update_dttm desc) = 1
  )
  select
    *
  from fonte00_2
  where 1=1
    -- and cus_cust_id = 353789723
),
fonte01 as ( -- flag de bloqueo ever y max dpd atraso
  with
  fonte01_0 as (
    select
       ccard_account_id
      ,ccard_account_status as acc_status
      ,ccard_account_overdue_dt
      ,date(date_trunc(ccard_account_creation_dt, month)) as aud_upd_month
      ,date(ccard_account_creation_dt) as aud_upd_dt
      ,ccard_account_creation_dt as aud_upd_dttm
    from `WHOWNER.BT_CCARD_ACCOUNT_HISTORY`
    where 1=1
      and sit_site_id = 'MLB'
      and date(ccard_account_creation_dt) > date('2022-05-25')
      and ccard_account_id in (select distinct ccard_account_id from fonte00)
    qualify row_number() over (partition by ccard_account_id,ccard_account_creation_dt order by ccard_internal_account_hist_id desc) = 1
  ),
  fonte01_1 as (
    select
     *
    ,coalesce((lag(aud_upd_dttm) over (partition by ccard_account_id order by aud_upd_dttm desc) - interval '1' second), current_datetime('-03')) as aud_upd_dttm_lag
  from fonte01_0
  ),
  fonte01_2 as (
    select
       ccard_account_id
      ,max(case when acc_status = 'blocked' then 1 else 0 end) as flag_blocked_ever
      ,max(case when acc_status = 'blocked' then date_diff(aud_upd_dttm_lag, ccard_account_overdue_dt, day) else 0 end) as max_dpd_ever
    from fonte01_1
    group by 1
  )
  select
    *
  from fonte01_2
),
fonte02 as ( -- marca de principales
  select
     cus_cust_id
    ,case when category_princ = 'PRINCIPAL' then 1 else 0 end as flag_principals
  from `WHOWNER.LK_MP_MAUS_LIFECYCLE`
  where 1=1 
    and sit_site_id = 'MLB'
    and timeframe = 'END_OF_MONTH'
    and tim_month_id = (select cast(format_date('%Y%m', date_trunc(current_date('-03'), month) - interval '1' month) as numeric)) -- traz sempre o dia primeiro do mes anterior ao current_date em formato numerico 'yyyymm'
    and cus_cust_id in (select distinct cus_cust_id from fonte00)
),
fonte03 as ( -- resumen más recientes
  select
     cus_cust_id
    ,ccard_stmt_close_dttm
    ,ccard_stmt_due_dttm
    ,ccard_stmt_amount_lc
    ,ccard_stmt_min_pay_amount_lc
    ,coalesce(ccard_stmt_curr_lim_purch_lc,0) as ccard_stmt_curr_lim_purch_lc
  from `WHOWNER.BT_CCARD_STMT_STATEMENTS`
  where 1=1
    and date(ccard_stmt_close_dttm) <= current_date('-03')
    and cus_cust_id in (select distinct cus_cust_id from fonte00)
  qualify row_number() over (partition by cus_cust_id order by ccard_stmt_due_dttm desc) = 1
),
fonte04 as ( -- flags friday y CPF
  select
     friday.cus_cust_id
    ,safe_cast(friday.identification_number as int64) as cpf_friday
    -- ,safe_cast(cpfs.cus_cust_doc_number as int64) as cpf_friday
    ,friday.score_positivo_pf
    ,friday.flag_overdue
    ,friday.flag_consumer_crd
    ,cast(friday.flag_portability as int64) as flag_portability
    -- ,cast(friday.flag_corporate_benefit as int64) as flag_corporate_benefit
    ,cast(friday.flag_meli_employee as int64) as flag_meli_employee
  from `SBOX_IT_CREDITS_CREDITSTBL.CC_FRIDAY_DESCRIPTIVE_DATA_MLB` friday
  where 1=1
    -- and friday.cus_cust_id = 427719721
    and friday.cus_cust_id in (select distinct cus_cust_id from fonte00)
),
fonte05 as ( -- VU presumed income
  select
     cus_cust_id
    ,assumed_income_amt as current_presumed_income
    ,valid_from_dt as period_dt
  from `WHOWNER.BT_VU_ASSUMED_INCOME`
  where 1=1
    and sit_site_id = 'MLB'
    and cus_cust_id in (select distinct cus_cust_id from fonte00)
    -- and cus_cust_id = 353789723
    -- and period_dt <> date('2024-03-01') --temporario devido erros na tabela de income unificada (ocorrido em mar/24 - já se corrigiu)
  qualify row_number() over (partition by cus_cust_id order by period_dt desc) = 1
),
fonte06 as ( -- dias de mora desde la tabla de credits
  select 
     cus_cust_id_borrower as cus_cust_id
    ,max(dias_mora) as dias_mora_credits 
  from `SBOX_IT_CREDITS_CREDITSTBL.CRD_CREDITS` 
  where 1=1
    and cus_cust_id_borrower in (select distinct cus_cust_id from fonte00)
  group by 1
),
fonte07 as ( -- modelos BHV CC y TC
  with
  fonte07_0 as ( -- fechas usadas para cada rating
    select
      max(score_behavior_tc_date) as f_score_bhv_tc
    from `SBOX_IT_CREDITS_CREDITSTBL.CC_FRIDAY_SCORING`
    where 1=1
      and internal_rating_behavior_tc is not null
      and cus_cust_id in (select distinct cus_cust_id from fonte00)
  ),
  fonte07_1 as ( -- traer los modelos para las fechas
    select 
       cus_cust_id
      ,internal_group_behavior as rating_bhv_cc
      ,internal_rating_behavior_tc as rating_bhv_tc
    from `SBOX_IT_CREDITS_CREDITSTBL.CC_FRIDAY_SCORING`
    where 1=1
      and sit_site_id = 'MLB'
      and score_behavior_tc_date = (select f_score_bhv_tc from fonte07_0)
      and cus_cust_id in (select distinct cus_cust_id from fonte00)
  )
  select
    *
  from fonte07_1
),
fonte08 as ( -- users que fueron impactados por alguna campana de upsell, overlimit o downsell en los ultimos 90d
  select 
     cus_cust_id
    ,max(case when actionable_name in ('OVERLIMIT', 'CCARD_OVERLIMIT') then 1 else 0 end) as flag_overlimit_3m_tmp
    ,max(case when actionable_name in ('UPSELL', 'CCARD_UPSELL') then 1 else 0 end) as flag_upsell_3m_tmp
    ,max(case when actionable_name in ('DOWNSELL', 'CCARD_DOWNSELL') then 1 else 0 end) as flag_downsell_3m_tmp
    -- *
  from `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`
  where 1=1 
    and date(actionable_dttm) > current_date('-03') - interval '90' day
    -- and date(actionable_dttm) > current_date('-03') - interval '180' day
    -- and cus_cust_id = 273887538
    and cus_cust_id in (select distinct cus_cust_id from fonte00)
  group by 1
),
fonte09 as ( -- users que tuvieron efectivamente un downsell en una ventana de 180d
  select
     cus_cust_id
    ,max(case when ccard_updated_limit_type in ('DOWNSELL') then 1 else 0 end) as flag_downsell_6m_tmp
  from `SBOX_IT_CREDITS_CREDITSTBL.CRD_CCARD_LIMIT_UPDATE`
  where 1=1
    and ccard_limit_date > current_date('-03') - interval '180' day
    and cus_cust_id in (select distinct cus_cust_id from fonte00)
    -- and cus_cust_id = 273887538
  group by 1
),
fonte10 as ( -- marcar scores BVS la diferencia de variacion del ultimo mes hasta 3m anteriores
  with
  fonte10_0 as ( -- scores BVS en una ventana de 4m desde el mes pasado
    select
       safe_cast(identification_number as int64) as cpf_bvs
      -- ,tim_day
      -- ,date_created
      ,score_positivo_pf as score_actual
    from `WHOWNER.BT_REGULATIONS_BUREAU`
    where 1=1
      and score_positivo_pf is not null
      and date_trunc(date_created, month) >= (select date(date_trunc(current_date('-03'), month) - interval '1' month))
      -- and date_trunc(date_created, month) >= (select date(date('2024-11-01') - interval '1' month))
      -- and identification_number = '44623863883'
    qualify row_number() over (partition by identification_number order by date_created desc) = 1
    -- limit 100
  ),
  fonte10_1 as ( -- trae solamente los scores del mes pasado y 3m antes de eso
    select
       safe_cast(identification_number as int64) as cpf_bvs
      -- ,tim_day
      -- ,date_created
      ,score_positivo_pf as score_anterior
    from `WHOWNER.BT_REGULATIONS_BUREAU`
    where 1=1
      and score_positivo_pf is not null
      and date_trunc(date_created, month) >= (select date(date_trunc(current_date('-03'), month) - interval '4' month))
      -- and date_trunc(date_created, month) >= (select date(date('2024-11-01') - interval '4' month))
      -- and identification_number = '44623863883'
    qualify row_number() over (partition by identification_number order by date_created asc) = 1
  ),
  fonte10_2 as (
    select
      *
    from fonte10_0
    full join fonte10_1 using(cpf_bvs)
  )
  select
     *
    ,cast(score_anterior as numeric) - cast(score_actual as numeric) as diferencia_bvs
  from fonte10_2
  where 1=1
    and score_actual is not null and score_anterior is not null -- se arranca los users que no tengan scores bvs, sea del mes anterior o 3m antes
),
fonte11 as ( -- las propuestas de CC, su consumo y los max atrasos
  select
     prop_cc.cus_cust_id_borrower as cus_cust_id
    ,case 
      when prop_cc.crd_prop_purpose_id = 'PURCHASE' and prop_cc.crd_prop_status_id in ('APPROVED', 'PAUSED') then
        case when coalesce(prop_cc.crd_prop_balance,0) >= 0 then coalesce(prop_cc.crd_prop_balance,0) else 0 end
      else 0 end as crd_prop_balance
    ,case 
      when prop_cc.crd_prop_purpose_id = 'PURCHASE' and prop_cc.crd_prop_status_id in ('APPROVED', 'PAUSED') then coalesce(prop_cc.crd_prop_total_amount,0)
      else 0 end as limite_cc
    ,max(
      case 
        when inst.crd_inst_status_id = 'PAID' then date_diff(date(inst.crd_inst_payment_dt_id), date(inst.crd_inst_due_date_id), day)
        when inst.crd_inst_status_id = 'IN_REPAYMENT' then date_diff((current_date('-03')), date(inst.crd_inst_due_date_id), day)
        when inst.crd_inst_status_id = 'SCHEDULED' then 0
        end) as max_dpd
  from `WHOWNER.BT_MP_CREDITS_PROPOSAL` prop_cc
  left join `WHOWNER.BT_MP_CREDITS` crd
    on prop_cc.cus_cust_id_borrower = crd.cus_cust_id_borrower
    and crd.crd_credit_status_id in ('CREDITED','FINISHED','ON_TIME','OVERDUE')
    and crd.sit_site_id = 'MLB'
  left join `WHOWNER.BT_MP_CREDITS_INSTALLMENT` inst
    on crd.crd_credit_id = inst.crd_credit_id
    and inst.crd_inst_status_id not in ('PAID_EARLY')
  where 1=1
    and prop_cc.sit_site_id = 'MLB'
    and prop_cc.cus_cust_id_borrower in (select distinct cus_cust_id from fonte00)
  group by 1,2,3
),
fonte12 as ( -- VU RCI
  select
     cus_cust_id
    ,max(if(crd_prod_def_type_sk = 3, real_min_inst_ptc,0)) as real_min_inst_ptc_tc
    ,max(if(crd_prod_def_type_sk = 3, teoric_min_inst_ptc,0)) as teoric_min_inst_ptc_tc
    ,max(if(crd_prod_def_type_sk = 3, real_use_level_val,0)) as real_use_level_val_tc
    ,max(if(crd_prod_def_type_sk = 3, teoric_use_level_val,0)) as teoric_use_level_val_tc
    ,max(if(crd_prod_def_type_sk = 3, teoric_rci_val,0)) as teoric_rci_val_tc
    ,max(if(crd_prod_def_type_sk = 2, real_min_inst_ptc,0)) as real_min_inst_ptc_cc
    ,max(if(crd_prod_def_type_sk = 2, teoric_min_inst_ptc,0)) as teoric_min_inst_ptc_cc
    ,max(if(crd_prod_def_type_sk = 2, real_use_level_val,0)) as real_use_level_val_cc
    ,max(if(crd_prod_def_type_sk = 2, teoric_use_level_val,0)) as teoric_use_level_val_cc
    ,max(if(crd_prod_def_type_sk = 2, teoric_rci_val,0)) as teoric_rci_val_cc
  from `WHOWNER.BT_VU_RCI`
  where 1=1
    -- and cus_cust_id = 353789723
    and cus_cust_id in (select distinct cus_cust_id from fonte00)
    and crd_prod_def_type_sk in (2,3)
    and current_flag
  group by all
),
ant00 as ( -- unir las flags principales con la base total de clientes
  select
    *
    except(flag_overlimit_3m_tmp, flag_upsell_3m_tmp, flag_downsell_3m_tmp, flag_downsell_6m_tmp)
    ,coalesce(flag_overlimit_3m_tmp,0) as flag_overlimit_3m
    ,coalesce(flag_upsell_3m_tmp,0) as flag_upsell_3m
    ,coalesce(flag_downsell_3m_tmp,0) as flag_downsell_3m
    ,coalesce(flag_downsell_6m_tmp,0) as flag_downsell_6m
  from fonte00 acc
  left join fonte01 bloqueo_tc using(ccard_account_id)
  left join fonte02 principals using(cus_cust_id)
  left join fonte03 res using(cus_cust_id)
  left join fonte04 friday using(cus_cust_id)
  left join fonte05 inc using(cus_cust_id)
  left join fonte06 mora using(cus_cust_id)
  left join fonte07 score_bhv using(cus_cust_id)
  left join fonte08 campanas using(cus_cust_id)
  left join fonte09 dw_6m using(cus_cust_id)
  left join fonte10 score_bvs on friday.cpf_friday = score_bvs.cpf_bvs
  -- left join fonte10 score_bvs using(cus_cust_id)
  left join fonte11 prop_cc using(cus_cust_id)
  left join fonte12 rci using(cus_cust_id)
),
ant01 as (
  select
     *
    ,(limite_tc - ccard_stmt_curr_lim_purch_lc) as saldo_deuda
    ,case when ccard_risk_analysis_score in ('P','Q','R','S','T','U','V','W','Y','I','J') then 1 else 0 end as flag_overlimit
    ,case 
      when diferencia_bvs >= 120 then 'a. empeoro más de 120'
      when diferencia_bvs >= 80 then 'b. empeoro más de 80'
      when diferencia_bvs >= 60 then 'c. empeoro más de 60'
      when diferencia_bvs >= 40 then 'd. empeoro más de 40'
      when diferencia_bvs >= 20 then 'e. empeoro más de 20'
      when (diferencia_bvs < 20 and diferencia_bvs > 0) then 'f. empeoro menos de 20'
      when diferencia_bvs <= 0 then 'g. igual o mejor'
      end as variacion_bvs
    ,case 
      when flag_consumer_crd then
        case 
          when limite_cc > 0 and ((limite_cc - crd_prop_balance)/limite_cc) > .7 then 
            ((limite_cc - crd_prop_balance)/limite_cc) 
        else .7 end
      else .5 end as porc_uso_cc
    ,case 
      when flag_consumer_crd then
        case 
          when ((limite_tc - ccard_stmt_curr_lim_purch_lc) / limite_tc) > .8 then
            ((limite_tc - ccard_stmt_curr_lim_purch_lc) / limite_tc)
          else .8 end
      when not(flag_consumer_crd) then
        case 
          when ((limite_tc - ccard_stmt_curr_lim_purch_lc) / limite_tc) > .75 then
            ((limite_tc - ccard_stmt_curr_lim_purch_lc) / limite_tc) 
          else .75 end
      else null end as porc_uso_tc
    ,case when ccard_stmt_amount_lc > 0 then (ccard_stmt_min_pay_amount_lc * 1.00 / ccard_stmt_amount_lc) else 0 end as porc_pago_min_tc_real
    ,case when max_dpd > 5 then 'Paused ever' else 'not paused ever' end as flag_pausado_cc
  from ant00
),
ant02 as (
  select
     *
    ,case when porc_pago_min_tc_real > .3 then porc_pago_min_tc_real else .3 end as porc_pago_min_tc
  from ant01
),
ant03 as (
  select
     *
    -- ,case 
    --   when current_presumed_income > 0 then (((limite_tc * porc_pago_min_tc * porc_uso_tc) + (limite_cc * porc_uso_cc * .4)) / current_presumed_income) 
    --   else null end as rci_actual
    -- ,safe_divide(suma_teoric_debt_conj, current_presumed_income) as rci_actual
    ,(
    (
      (limite_tc * greatest(real_min_inst_ptc_tc, teoric_min_inst_ptc_tc) * greatest(real_use_level_val_tc, teoric_use_level_val_tc)) +
      (teoric_rci_val_cc * current_presumed_income)
    ) / current_presumed_income) as rci_actual
  from ant02
),
ant04 as (
  select
     *
    ,case 
      when rci_actual > 0.6 then 'a.+ 0.6'
      when rci_actual > 0.5 then 'b.0.5 - 0.6'
      when rci_actual > 0.35 then 'c.0.35 - 0.5'
      when rci_actual > 0.30 then 'd.0.3 - 0.35'
      when rci_actual > 0.25 then 'e.0.25 - 0.3'
      when rci_actual <= 0.25 then 'f.0.0 - 0.25' 
      else null end as rci_a_hoy
  from ant03
),
ant05 as (
  select
     *
    ,case 
      when limite_tc >= 625 then (limite_tc * .8)
      when limite_tc < 625 then 500
      else limite_tc end as limite_tc_post
    ,cast(substr(cast(cus_cust_id as string), -1, 1) as integer) as last_digit_user_id
    ,cast(substr(cast(cus_cust_id as string), -2, 1) as integer) as penultimate_digit_user_id
  from ant04
),
ant06 as (
  select
      *
     ,trunc(limite_tc_post,-1) as limite_tc_post_arred
  from ant05
)
select
  *
from ant06
;


/*
Creando los grupos controls

El metodo consiste en los puntos principales abajo:
- hacer la distribución de acuerdo con una o un conjunto de variable de control, para que se quedan una misma proporcion de control al largo de las variables
- usamos limite como ordenamiento y no ID (porque???)
- elegimos por la fila de la tabla (esta puede ser de acuerdo con la cantidad que deseamos - en este caso se camina de 10 en 10 para tenermos 10% de la base para control)

*/

create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_BASE_202501_PECASTANHO`
as
with
fonte00 as (
  with 
  fonte00_0 as (
    select
      *
      ,case
        when limite_tc >= 625 then case when ccard_account_status = 'active' then 'a' else 'b' end
        when limite_tc < 625 then case when ccard_account_status = 'active' then 'c' else 'd' end
        else 'e' end as var_control
    from `TMP.mlb_tc_downsell_bau_base_1`
  ),
  fonte00_1 as (
    select
       *
       ,row_number() over (partition by var_control order by limite_tc asc) as fila
    from fonte00_0
  )
  select
     *
     ,case
        when var_control = 'a' and mod(fila,10) = 1 then 'GC'
        when var_control = 'a' and mod(fila,10) <> 1 then 'GI'
        when var_control = 'b' and mod(fila,10) = 1 then 'GC'
        when var_control = 'b' and mod(fila,10) <> 1 then 'GI'
        when var_control = 'c' and mod(fila,10) = 1 then 'GC'
        when var_control = 'c' and mod(fila,10) <> 1 then 'GI'
        when var_control = 'd' and mod(fila,10) = 1 then 'GC'
        when var_control = 'd' and mod(fila,10) <> 1 then 'GI'
        else 'nada' end as grupo
  from fonte00_1
),
fonte01 as ( -- tests o otros killers externos -- Aplicar si haber una tabla para sacar de los impactables
  select
    cus_cust_id as user_id
  from `SBOX_CREDITS_SB.RBA_TC_MLB_BASE_RGS`
),
ant00 as (
  select
    *
    ,case when test.user_id is not null then 1 else 0 end as flag_downsell_test
  from fonte00 bau
  left join fonte01 test
    on bau.cus_cust_id = test.user_id
)
select
  *
from ant00
;

/*
Creando la tabla 'oficial' solamente incluyendo los impactables (controle y no)
*/

create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_IMPACTABLES_202501_PECASTANHO`
as
select
   cast(cus_cust_id as bignumeric) as user_id
  ,cast(limite_tc_post_arred as bignumeric) as general_limit
  ,cast(50 as int64) as withdraw_limit
  ,'MLB' as site_id
  ,cast(0 as int64) as is_upsell
  ,case when grupo = 'GC' then true else false end as campaign_control_group
  ,'pecastanho' as aud_ins_user
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_BASE_202501_PECASTANHO`
where 1=1
  and (ccard_account_status = 'active' or ccard_account_status_det = 'payment_delay')
  and limite_tc > 500
  and rating_bhv_tc in ('I','H','J')
  and flag_downsell_3m = 0
  and flag_downsell_6m = 0
  and flag_upsell_3m = 0
  and flag_overlimit_3m = 0
  and (flag_blocked_ever = 1 or flag_pausado_cc = 'Paused ever')
  and (flag_principals <> 1 or (flag_principals = 1 and (max_dpd_ever > 10 or dias_mora_credits > 10)))
  and ((rci_actual > .5 or diferencia_bvs > 40) or (diferencia_bvs > 20 and score_actual < 400 and rci_actual > .3))
  -- and flag_portability = 0 and flag_corporate_benefit = 0 and flag_meli_employee = 0 and limite_tc < 20000
  and flag_portability = 0 and flag_meli_employee = 0 and limite_tc < 20000
  and flag_downsell_test = 0
  -- and ccard_processor_id <> 'monza' -- temporario
;


/*
Check de duplicidade
*/

select
   cus_cust_id
  ,count(cus_cust_id)
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_BASE_202501_PECASTANHO`
group by 1
having count(cus_cust_id) > 1
;

select
   user_id
  ,count(user_id)
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_IMPACTABLES_202501_PECASTANHO`
group by 1
having count(user_id) > 1
;

/*
Checks de cantidad entre las tablas e flags
*/

select
  case
    when (ccard_account_status = 'active' or ccard_account_status_det = 'payment_delay')
      and limite_tc > 500
      and rating_bhv_tc in ('I','H','J')
      and flag_downsell_3m = 0
      and flag_downsell_6m = 0
      and flag_upsell_3m = 0
      and flag_overlimit_3m = 0
      and (flag_blocked_ever = 1 or flag_pausado_cc = 'Paused ever')
      and (flag_principals <> 1 OR (flag_principals = 1 AND (max_dpd_ever > 10 or dias_mora_credits > 10)))
      and ((rci_actual > .5 or diferencia_bvs > 40) or (diferencia_bvs > 20 and score_actual < 400 and rci_actual > .3))
      -- and flag_portability = 0 and flag_corporate_benefit = 0 and flag_meli_employee = 0 and limite_tc < 20000
      and flag_portability = 0 and flag_meli_employee = 0 and limite_tc < 20000
      -- and ccard_processor_id <> 'monza' -- temporario
      and flag_downsell_test = 0 then 1 else 0 end as flag_accionable
  ,count(1) as cant
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_BASE_202501_PECASTANHO`
group by 1
;
-- 61.116
select
   count(1) as cant_total
  ,sum(case when not(campaign_control_group) then 1 else 0 end) as cant_gi
  ,sum(case when campaign_control_group then 1 else 0 end) as cant_gc
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_IMPACTABLES_202501_PECASTANHO`
;
-- 61.116
-- 55.031
-- 6.085
/*
Base para el equipo de CX (subir al Google Drive)
*/

select
   cus_cust_id as user_id
  ,limite_tc as limite_tc_actual
  ,limite_tc_post_arred as limite_tc_posterior
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_BASE_202501_PECASTANHO`
where 1=1
  and (ccard_account_status = 'active' or ccard_account_status_det = 'payment_delay')
  and limite_tc > 500
  and rating_bhv_tc in ('I','H','J')
  and flag_downsell_3m = 0
  and flag_downsell_6m = 0
  and flag_upsell_3m = 0
  and flag_overlimit_3m = 0
  and (flag_blocked_ever = 1 or flag_pausado_cc = 'Paused ever')
  and (flag_principals <> 1 or (flag_principals = 1 and (max_dpd_ever > 10 or dias_mora_credits > 10)))
  and ((rci_actual > .5 or diferencia_bvs > 40) or (diferencia_bvs > 20 and score_actual < 400 and rci_actual > .3))
  -- and flag_portability = 0 and flag_corporate_benefit = 0 and flag_meli_employee = 0 and limite_tc < 20000
  and flag_portability = 0 and flag_meli_employee = 0 and limite_tc < 20000
  and grupo = 'GI'
  and flag_downsell_test = 0
;

/*
Crear el Campaign ID


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
'DOWNSELL', --CAMPAIGN_TYPE
'BAU', --POLICY
'BAU', --POLICY_CATEGORY
'DOWNSELL BAU', --POLICY_SUBCATEGORY
'BHV H-J - CON ESTRES DE RCI O DETERIORO EN SCORE BVS', --POLICY_DESCRIPTION
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
  and sit_site_id = 'MLB'
  and negocio = 'TC'
  and product_desc = 'TC'
  and campaign_type = 'DOWNSELL'
  and policy = 'BAU'
  and campaign_group_desc = 'IMPACTADOS BASE UNICA'
  and campaign_date = current_date('-03')
qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
;
-- c3a5af3f-2a9d-4443-8644-b3326ee59bec

--CONTROL
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
'MLB',     --SIT_SITE_ID
'TC', --NEGOCIO
'TC', --PRODUCT_DESC
'DOWNSELL', --CAMPAIGN_TYPE
'BAU', --POLICY
'BAU', --POLICY_CATEGORY
'DOWNSELL BAU', --POLICY_SUBCATEGORY
'BHV H-J - CON ESTRES DE RCI O DETERIORO EN SCORE BVS', --POLICY_DESCRIPTION
'CONTROL_1', --CAMPAIGN_GROUP
'GRUPO CONTROL DESC' --CAMPAIGN_GROUP_DESC
);

--Segundo paso
CALL `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX_AUTOCOMPLETE`();

--CHECK
select 
  * 
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and sit_site_id = 'MLB'
  and negocio = 'TC'
  and product_desc = 'TC'
  and campaign_type = 'DOWNSELL'
  and policy = 'BAU'
  and campaign_group_desc = 'GRUPO CONTROL DESC'
  and aud_ins_user = 'pedro.castanho@mercadopago.com.br'
  and campaign_date = current_date('-03')
qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
;

-- 4e6e9ade-1cc8-4afd-9d24-20d32abb439a

*/

/*
Insert en cerebro


-- IMPACTABLE
INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
IS_UPSELL,
CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
)
Select 
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
IS_UPSELL,
cast(
(
  select
    campaign_id
  from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
  where 1=1
    and sit_site_id = 'MLB'
    and negocio = 'TC'
    and product_desc = 'TC'
    and campaign_type = 'DOWNSELL'
    and policy = 'BAU'
    and campaign_group_desc = 'IMPACTADOS BASE UNICA'
    and aud_ins_user = 'pedro.castanho@mercadopago.com.br'
    and campaign_date = current_date('-03')
  qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
) as string) as CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
FROM `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_IMPACTABLES_202501_PECASTANHO`
where 1=1
  and not(campaign_control_group)
;

Esta declaración agregó 51,211 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
IS_UPSELL,
CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
)
Select 
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
IS_UPSELL,
cast(
(
  select
    campaign_id 
  from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
  where 1=1
    and sit_site_id = 'MLB'
    and negocio = 'TC'
    and product_desc = 'TC'
    and campaign_type = 'DOWNSELL'
    and policy = 'BAU'
    and campaign_group_desc = 'GRUPO CONTROL DESC'
    and aud_ins_user = 'pedro.castanho@mercadopago.com.br'
    and campaign_date = current_date('-03')
  qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
) as string) as CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
FROM `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_IMPACTABLES_202501_PECASTANHO`
where 1=1
  and campaign_control_group
;

Esta declaración agregó 5,700 filas a EOC_TC_C_UPSELL_DOWNSELL.


select
   user_id
  ,count(user_id) as cant
from `SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
group by 1
having cant>1
;


select
  *
from `SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
limit 100
;


select
   campaign_id
  ,campaign_control_group
  ,count(1) as cant
from `SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
group by all
;


-- Insert en la cartera
-- Impactables

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA` ----todas las modificaciones que hicieron
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)
Select
-- 'Impactados Base unica' 
cast(
(
  select
    campaign_id
  from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
  where 1=1
    and aud_ins_user = 'pedro.castanho@mercadopago.com.br'
    and sit_site_id = 'MLB'
    and negocio = 'TC'
    and product_desc = 'TC'
    and campaign_type = 'DOWNSELL'
    and policy = 'BAU'
    and campaign_group_desc = 'IMPACTADOS BASE UNICA'
    and campaign_date = current_date('-03')
  qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
) as string) as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_DOWNSELL' as ACTIONABLE_NAME,
'IMPACTO_1'  as CAMPAIGN_GROUP,
PRO.CCARD_PROP_ID as  PROP_ID, --la de proposal?
A.cus_cust_id as CUS_CUST_ID, ---FIJA
current_datetime() as ACTIONABLE_DTTM,
A.limite_tc_post_arred as AMOUNT, --FIJA
null as RATING,--- ACCOUNT HIST
NULL RATING_CH_TC, ---
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, --
NULL RATING_CH_CC, -- SI FIJA
NULL MODELO_BHV_CC, -- SI FIJA
rating_bhv_cc RATING_BHV_CC, -- SI FIJA
NULL RATING_ADP_CC, --
porc_uso_cc PORC_USO_CC, --
null LINEA_CC, --
NULL PLAZO_CC, --?
porc_uso_tc PORC_USO_TC, --
A.limite_tc LIMITE_TC, --
porc_pago_min_tc PORC_PAGO_MIN ,  --
null monto_dispo_cc , --
current_presumed_income PRESUMED_INCOME , --
NULL FLAG_MERCHANT, --
rci_actual RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- post monto_dispo_cc
current_datetime() as AUD_INS_DTTM,
rating_bhv_tc AS RATING_BHV_TC, --FIJA
NULL RATING_UPSELL_TC,
NULL PORC_USO_TC_REAL,
porc_pago_min_tc_real as PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
A.limite_tc PREV_AMOUNT --FIJA LIMITE_PRE
FROM (
  select
    *
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_BASE_202501_PECASTANHO`
  where 1=1
    and (ccard_account_status = 'active' or ccard_account_status_det = 'payment_delay')
    and rating_bhv_tc in ('I','H','J')
    and flag_downsell_3m = 0
    and flag_downsell_6m = 0
    and flag_upsell_3m = 0
    and flag_overlimit_3m = 0
    and (flag_blocked_ever = 1 or flag_pausado_cc = 'Paused ever')
    and limite_tc > 500
    and (flag_principals <> 1 or (flag_principals = 1 and (max_dpd_ever > 10 or dias_mora_credits > 10)))
    and ((rci_actual > .5 or diferencia_bvs > 40) or (diferencia_bvs > 20 and score_actual < 400 and rci_actual > .3))
    and flag_portability = 0 and flag_meli_employee = 0 and limite_tc < 20000
    and grupo = 'GI'
    and flag_downsell_test = 0
) A
left join (
    select 
      * 
    from `meli-bi-data.WHOWNER.BT_CCARD_PROPOSAL`
qualify row_number() over (partition by CUS_CUST_ID order by ccard_prop_creation_dt desc) = 1
) PRO ON A.cus_cust_id = PRO.CUS_CUST_ID
;

Esta declaración agregó 51,211 filas a RBA_TC_CAMPAIGN_CARTERA.




INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA` ----todas las modificaciones que hicieron
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)
Select
-- 'Impactados Base Control'
cast(
(
  select
    campaign_id 
  from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
  where 1=1
    and sit_site_id = 'MLB'
    and negocio = 'TC'
    and product_desc = 'TC'
    and campaign_type = 'DOWNSELL'
    and policy = 'BAU'
    and campaign_group_desc = 'GRUPO CONTROL DESC'
    and aud_ins_user = 'pedro.castanho@mercadopago.com.br'
    and campaign_date = current_date('-03')
  qualify row_number() over (partition by aud_ins_user order by aud_ins_dttm desc) = 1
) as string) as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_DOWNSELL' as ACTIONABLE_NAME,
'CONTROL_1'  as CAMPAIGN_GROUP,
PRO.CCARD_PROP_ID as  PROP_ID, --la de proposal?
A.cus_cust_id as CUS_CUST_ID, ---FIJA
current_datetime() as ACTIONABLE_DTTM,
A.limite_tc_post_arred as AMOUNT, --FIJA
null as RATING,--- ACCOUNT HIST
NULL RATING_CH_TC, ---
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, --
NULL RATING_CH_CC, -- SI FIJA
NULL MODELO_BHV_CC, -- SI FIJA
rating_bhv_cc RATING_BHV_CC, -- SI FIJA
NULL RATING_ADP_CC, --
porc_uso_cc PORC_USO_CC, --
null LINEA_CC, --
NULL PLAZO_CC, --?
porc_uso_tc PORC_USO_TC, --
A.limite_tc LIMITE_TC, --
porc_pago_min_tc PORC_PAGO_MIN ,  --
null monto_dispo_cc , --
current_presumed_income PRESUMED_INCOME , --
NULL FLAG_MERCHANT, --
rci_actual RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- post monto_dispo_cc
current_datetime() as AUD_INS_DTTM,
rating_bhv_tc AS RATING_BHV_TC, --FIJA
NULL RATING_UPSELL_TC,
NULL PORC_USO_TC_REAL,
porc_pago_min_tc_real as PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
A.limite_tc PREV_AMOUNT --FIJA LIMITE_PRE
FROM (
  select
    *
  from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_BASE_202501_PECASTANHO`
  where 1=1
    and (ccard_account_status = 'active' or ccard_account_status_det = 'payment_delay')
    and rating_bhv_tc in ('I','H','J')
    and flag_downsell_3m = 0
    and flag_downsell_6m = 0
    and flag_upsell_3m = 0
    and flag_overlimit_3m = 0
    and (flag_blocked_ever = 1 or flag_pausado_cc = 'Paused ever')
    and limite_tc > 500
    and (flag_principals <> 1 or (flag_principals = 1 and (max_dpd_ever > 10 or dias_mora_credits > 10)))
    and ((rci_actual > .5 or diferencia_bvs > 40) or (diferencia_bvs > 20 and score_actual < 400 and rci_actual > .3))
    and flag_portability = 0 and flag_meli_employee = 0 and limite_tc < 20000
    and grupo = 'GC'
    and flag_downsell_test = 0
) A
left join (
    select 
      * 
    from `meli-bi-data.WHOWNER.BT_CCARD_PROPOSAL`
qualify row_number() over (partition by CUS_CUST_ID order by ccard_prop_creation_dt desc) = 1
) PRO ON A.CUS_CUST_ID = PRO.CUS_CUST_ID
;

Esta declaración agregó 5,700 filas a RBA_TC_CAMPAIGN_CARTERA.










*/


select
  *
from `SBOX_CREDITSSIGMA.EOC_TC_C_UPSELL_DOWNSELL`
where 1=1
  and user_id = 151234811
  -- and user_id = 403631166
;






