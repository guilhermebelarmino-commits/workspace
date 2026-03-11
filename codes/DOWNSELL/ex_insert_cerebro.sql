-- SELECT * FROM `meli-bi-data.SBOX_CREDITSSIGMA.EOC_CAMPAIGN_EXECUTION_DETAIL` WHERE EXECUTION_ID = 'efeaabfd-9ac1-4399-8268-15ee81641130'
/*
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'' --10 Campaign_group_desc
);

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'' --10 Campaign_group_desc
);

select
*
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
where 1=1
and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
and sit_site_id = 'MLB'
and campaign_type = 'DOWNSELL'
and campaign_date = current_date('-03')

-- campaign id control: 614e9e41-175a-4ff6-8c99-b9363ad03229
-- campaign id impacto: f39da1a3-fcb3-435b-a710-59121799531a
*/

CREATE TEMP TABLE ccard_account as
(
select
cus_cust_id
,ccard_account_overdue_dt
,date_diff(current_date, ccard_account_overdue_dt, day) as dpd_tc
from`WHOWNER.BT_CCARD_ACCOUNT`
where 1=1
and sit_site_id = 'MLB'
);

CREATE TEMP TABLE bhv_v6 as
(
select
cus_cust_id, INTERNAL_RATING_TAG
from `WHOWNER.BT_VU_MODEL_RATING`
where sit_site_id = 'MLB'
and valid_to_dt = '2025-02-08'
and score_dt = '2025-01-31'
and crd_model = 'CONSUMERS_BEHAVIOR_CREDIT_CARD'
and crd_version = 6
);

CREATE OR REPLACE TEMP TABLE TEMP_FINAL AS
select
base.cus_cust_id
,base.campaign_control_group
,if(rk.wanda__flag_ccard_transitory_block, 'blocked', 'active') as status
,rk.wanda__current_limit_ccard as limite_pre
,cast(base.actionable_columns[safe_offset(0)].value as float64) as limite_post
,cast(base.actionable_columns[safe_offset(1)].value as float64) as withdraw_limit
,base.actionable_columns[safe_offset(11)].value as rating_bhv
,bhv_v6.INTERNAL_RATING_TAG as rating_bhv_v6
,case
when if(rk.wanda__flag_ccard_transitory_block, 'blocked', 'active') = 'active' then 'a. < 5'
when ifnull(ccard.dpd_tc,0) < 5 then 'a. < 5'
when ccard.dpd_tc <= 66 then 'b. entre 6 y 66'
when ccard.dpd_tc <= 90 then 'c. entre 67 y 90'
else 'd > 90'
end as fx_dpd
from `meli-bi-data.SBOX_CREDITSSIGMA.EOC_CAMPAIGN_EXECUTION_DETAIL` base
left join `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_efeaabfd-9ac1-4399-8268-15ee81641130` rk
on base.cus_cust_id = rk.cus_cust_id
left join ccard_account ccard
on base.cus_cust_id = ccard.cus_cust_id
left join bhv_v6
on base.cus_cust_id = bhv_v6.cus_cust_id

where 1=1
and base.execution_id = 'efeaabfd-9ac1-4399-8268-15ee81641130'
;

/*
-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
IS_UPSELL,
CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
)
select
cus_cust_id as USER_ID,
CAST(limite_post AS NUMERIC) as GENERAL_LIMIT,
CAST(withdraw_limit AS INT64) as WITHDRAW_LIMIT,
MLB' as SITE_ID,
0 as IS_UPSELL,
f39da1a3-fcb3-435b-a710-59121799531a' as CAMPAIGN_ID,
campaign_control_group as CAMPAIGN_CONTROL_GROUP,
gubelarmino' as AUD_INS_USER
from TEMP_FINAL
where fx_dpd not in ('d > 90') and ifnull(rating_bhv_v6, 'Z') not in ('A', 'B', 'C', 'D') and campaign_control_group = false;

-- Esta declaración agregó 102,417 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
IS_UPSELL,
CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
)
select
cus_cust_id as USER_ID,
CAST(limite_post AS NUMERIC) as GENERAL_LIMIT,
CAST(withdraw_limit AS INT64) as WITHDRAW_LIMIT,
MLB' as SITE_ID,
0 as IS_UPSELL,
614e9e41-175a-4ff6-8c99-b9363ad03229' as CAMPAIGN_ID,
campaign_control_group as CAMPAIGN_CONTROL_GROUP,
gubelarmino' as AUD_INS_USER
from TEMP_FINAL
where fx_dpd not in ('d > 90') and ifnull(rating_bhv_v6, 'Z') not in ('A', 'B', 'C', 'D') and campaign_control_group = true;


-- Esta declaración agregó 11,524 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
where campaign_id = '614e9e41-175a-4ff6-8c99-b9363ad03229'
-- limit 100
;


select
-- campaign_id
campaign_control_group
-- AUD_INS_USER
,count(1) as cant
from `SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
group by all
;
*/