/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------- IMPACTOS INICIAIS -------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
select
case
when nise = 'BRONZE' then 'a.bronze'
when nise = 'SILVER' then 'b.silver'
when nise = 'GOLD' then 'c.gold'
when nise = 'PLATINUM' then 'd.platinum'
end as nise_ordenado,
pol.WANDA__INTERNAL_RATING_UPSELL_TC as upsell,
pol.WANDA__INTERNAL_RATING_BEHAVIOR_TC as bhv,
count(1) as cant,
ROUND(SUM(pol.WANDA__CURRENT_LIMIT_CCARD),2) as limite_actual,
ROUND(SUM(pol.GENERAL_LIMIT),2) as limite_final,
ROUND(SUM(pol.GENERAL_LIMIT-pol.WANDA__CURRENT_LIMIT_CCARD),2) as exposicion_adicional
from `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_59108655-fc6f-4310-b605-b5b428e21f74` rk
left join `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_59108655-fc6f-4310-b605-b5b428e21f74` pol
using(cus_cust_id)
where 1=1
and `cluster` > 0
and exception = false
and eliminated_by_rk = false
group by all


/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------- COMPETENCIA MODULO FRIDAY --------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/


select 
  FRIDAY_SEGMENT, COUNT(1) 
from `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.FRIDAY_CCARD_UPSELL_BETTER_OFFER_MLB` 
GROUP BY 1
ORDER BY 1


-- OPF - CARD TO CARD

CREATE OR REPLACE TABLE `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20250711_GUBELARMINO` AS
    SELECT * FROM `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.FRIDAY_CCARD_UPSELL_MLB` 
    where FRIDAY_SEGMENT = 'CARD_TO_CARD'
    and user_id not in (select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250710_CGALUCCIO`)
;

CREATE OR REPLACE TABLE `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_ANALITICA_20250711_GUBELARMINO` AS
    SELECT *except(MAX_DEUDA_INGRESO, BT_VU_PRESUMED_INCOME__OPF_MAX_LIMIT_TC_AMT), 
    from `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.FRIDAY_CCARD_UPSELL_CARD_TO_CARD_MLB` 
    where cus_cust_id not in (select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250710_CGALUCCIO`)
;

-- PISOS MINIMOS
CREATE OR REPLACE TABLE `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20250711_GUBELARMINO` AS
    SELECT * FROM `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.FRIDAY_CCARD_UPSELL_MLB` 
    where FRIDAY_SEGMENT = 'PISOS_MINIMOS'
    and user_id not in (select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250710_CGALUCCIO`)
;

CREATE OR REPLACE TABLE `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_ANALITICA_20250711_GUBELARMINO` AS
    SELECT *except(MAX_DEUDA_INGRESO), 
    from `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.FRIDAY_CCARD_UPSELL_PISOS_MINIMOS_MLB`
    where cus_cust_id not in (select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250710_CGALUCCIO`)
;

-- REACTIVACION
CREATE OR REPLACE TABLE `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20250711_GUBELARMINO` AS
    SELECT * FROM `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.FRIDAY_CCARD_UPSELL_MLB` 
    where FRIDAY_SEGMENT = 'REACTIVATION'
    and user_id not in (select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250710_CGALUCCIO`)
;

CREATE OR REPLACE TABLE `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_ANALITICA_20250711_GUBELARMINO` AS
    SELECT *except(MAX_DEUDA_INGRESO), 
    from `meli-bi-data.SBOX_IT_CREDITS_CREDITSTBL.FRIDAY_CCARD_UPSELL_REACTIVATION_MLB`
    where cus_cust_id not in (select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250710_CGALUCCIO`)
;


/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------- VALIDACAO POS COMPETENCIA ---------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

SELECT
  -- *
  POLITICA,
  FLAG_CONTROL_GROUP,
  case
    when nise = 'BRONZE' then 'a.bronze'
    when nise = 'SILVER' then 'b.silver'
    when nise = 'GOLD' then 'c.gold'
    when nise = 'PLATINUM' then 'd.platinum'
  end as nise_ordenado,
  count(1) as cant,
  ROUND(SUM(WANDA__CURRENT_LIMIT_CCARD),2) as limite_actual,
  ROUND(SUM(GENERAL_LIMIT),2) as limite_final,
  ROUND(SUM(GENERAL_LIMIT-WANDA__CURRENT_LIMIT_CCARD),2) as exposicion_adicional
FROM (

  select cus_cust_id, WANDA__CURRENT_LIMIT_CCARD, GENERAL_LIMIT, nise, FLAG_CONTROL_GROUP, 'CARD_TO_CARD' AS POLITICA from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_ANALITICA_20250711_GUBELARMINO`
  union all
  select cus_cust_id, WANDA__CURRENT_LIMIT_CCARD, GENERAL_LIMIT, nise, FLAG_CONTROL_GROUP, 'PISOS_MINIMOS' AS POLITICA from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_ANALITICA_20250711_GUBELARMINO`
  union all
  select cus_cust_id, WANDA__CURRENT_LIMIT_CCARD, GENERAL_LIMIT, nise, FLAG_CONTROL_GROUP, 'REACTIVACION' AS POLITICA from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_ANALITICA_20250711_GUBELARMINO` 
)
-- where cus_cust_id in (select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250710_CGALUCCIO`)
group by all

/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------ INSERT NO CEREBRO --------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- EXEMPLO COM A CAMPANHA DE OPEN FINANCE (CARD TO CARD)
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'OPF', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'' --10 Campaign_group_desc
);

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'OPF', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'' --10 Campaign_group_desc
);

-- CHECK
select
*
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
where 1=1
and sit_site_id = 'MLB'
and campaign_type = 'UPSELL'
and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
and campaign_date = current_date('-03')
;


-- GESTION: 3257bd98-50b2-45fa-9e67-e1c3b885f9c9
-- CONTROL: 6c9f99cb-6214-4a4d-ae1f-a1eeedac98d5

-- GESTION
INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL (
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
)
select
    USER_ID,
    GENERAL_LIMIT,
    50 as WITHDRAW_LIMIT,
    SITE_ID,
    0 PRIORITY,
    IS_UPSELL,
    '3257bd98-50b2-45fa-9e67-e1c3b885f9c9' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20250711_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
-- Esta declaración agregó 10,420 filas a EOC_TC_C_UPSELL_DOWNSELL.
;

-- CONTROL
INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL (
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
CAMPAIGN_CONTROL_GROUP,
AUD_INS_USER
)
select
    USER_ID,
    GENERAL_LIMIT,
    50 as WITHDRAW_LIMIT,
    SITE_ID,
    0 PRIORITY,
    IS_UPSELL,
    '6c9f99cb-6214-4a4d-ae1f-a1eeedac98d5' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20250711_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 538 filas a EOC_TC_C_UPSELL_DOWNSELL.
;

/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------- VALIDACAO POS INSERT NO CEREBRO -------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

select
  AUD_INS_USER
  ,campaign_id
  ,campaign_control_group
  ,count(1) as cant
from `SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
group by all
order by AUD_INS_USER desc
;

/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------- INSERT NA BASE DE CAMPANHA ----------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- CAMPAIGN

-- GESTION

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`
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

-----
Select
'3257bd98-50b2-45fa-9e67-e1c3b885f9c9' as CAMPAIGN_ID, -- mudar
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'IMPACTO_1' as CAMPAIGN_GROUP, -- mudar
null PROP_ID,
A.CUS_CUST_ID as CUS_CUST_ID,
datetime(current_date())as ACTIONABLE_DTTM,
GENERAL_LIMIT as AMOUNT,
NULL RATING,
NULL RATING_CH_TC, ---
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, --
NULL RATING_CH_CC, --
NULL MODELO_BHV_CC, --
NULL RATING_BHV_CC, --
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --
CAST(NIVEL_USO_TC_UPS AS NUMERIC) PORC_USO_TC, --
CAST(WANDA__CURRENT_LIMIT_CCARD AS NUMERIC) LIMITE_TC, --
CAST(PAGO_MIN_TC_UPS AS NUMERIC) PORC_PAGO_MIN , --
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, --
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, ---
current_datetime() as AUD_INS_DTTM,
INTERNAL_RATING_BEHAVIOR_TC AS RATING_BHV_TC,
INTERNAL_RATING_UPSELL_TC AS RATING_UPSELL_TC,
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(WANDA__CURRENT_LIMIT_CCARD AS NUMERIC) PREV_AMOUNT
FROM (
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_ANALITICA_20250711_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is false) A
;
-- Esta declaración agregó 10,426 filas a RBA_TC_CAMPAIGN_CARTERA.

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`
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

-----
Select
'6c9f99cb-6214-4a4d-ae1f-a1eeedac98d5' as CAMPAIGN_ID, -- mudar
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'CONTROL_1' as CAMPAIGN_GROUP, -- mudar
null PROP_ID,
A.CUS_CUST_ID as CUS_CUST_ID,
datetime(current_date())as ACTIONABLE_DTTM,
GENERAL_LIMIT as AMOUNT,
NULL RATING,
NULL RATING_CH_TC, ---
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, --
NULL RATING_CH_CC, --
NULL MODELO_BHV_CC, --
NULL RATING_BHV_CC, --
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --
CAST(NIVEL_USO_TC_UPS AS NUMERIC) PORC_USO_TC, --
CAST(WANDA__CURRENT_LIMIT_CCARD AS NUMERIC) LIMITE_TC, --
CAST(PAGO_MIN_TC_UPS AS NUMERIC) PORC_PAGO_MIN , --
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, --
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, ---
current_datetime() as AUD_INS_DTTM,
INTERNAL_RATING_BEHAVIOR_TC AS RATING_BHV_TC,
INTERNAL_RATING_UPSELL_TC AS RATING_UPSELL_TC,
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(WANDA__CURRENT_LIMIT_CCARD AS NUMERIC) PREV_AMOUNT
FROM (
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_ANALITICA_20250711_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is true) A
;
-- Esta declaración agregó 538 filas a RBA_TC_CAMPAIGN_CARTERA.