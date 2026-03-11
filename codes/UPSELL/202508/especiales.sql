/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------- INSERT NO CEREBRO OPF -----------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

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
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
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
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

-- CHECK
select
*
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
where 1=1
and sit_site_id = 'MLB'
and campaign_type = 'UPSELL'
and POLICY_SUBCATEGORY = 'OPF'
and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
and campaign_date = current_date('-03')
;


-- GESTION: 8a2bca47-086a-475e-9a4f-5b11f561fdeb
-- CONTROL: d380c383-461e-45b3-bcde-e07a14da15e2

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
    '8a2bca47-086a-475e-9a4f-5b11f561fdeb' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20250805_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
-- Esta declaración agregó 10,154 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    'd380c383-461e-45b3-bcde-e07a14da15e2' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20250805_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 524 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
'8a2bca47-086a-475e-9a4f-5b11f561fdeb' as CAMPAIGN_ID, -- mudar
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
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_ANALITICA_20250805_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is false) A
;
-- Esta declaración agregó 10,154 filas a RBA_TC_CAMPAIGN_CARTERA.

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
'd380c383-461e-45b3-bcde-e07a14da15e2' as CAMPAIGN_ID, -- mudar
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
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_ANALITICA_20250805_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is true) A
;
-- Esta declaración agregó 524 filas a RBA_TC_CAMPAIGN_CARTERA.


/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------ INSERT NO CEREBRO PISOS MINIMOS ------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'PISOS MIN', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'PISOS MIN', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

-- CHECK
select
*
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
where 1=1
and sit_site_id = 'MLB'
and campaign_type = 'UPSELL'
and POLICY_SUBCATEGORY = 'PISOS MIN'
and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
and campaign_date = current_date('-03')
;


-- GESTION: 6eceab8b-1909-4f20-a5ee-eaca3d9c914f
-- CONTROL: a15c68d5-32b9-4eb7-b7a4-69ae9ecb62e3

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
    '6eceab8b-1909-4f20-a5ee-eaca3d9c914f' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20250805_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
-- Esta declaración agregó 40,974 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    'a15c68d5-32b9-4eb7-b7a4-69ae9ecb62e3' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20250805_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 2,149 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
'6eceab8b-1909-4f20-a5ee-eaca3d9c914f' as CAMPAIGN_ID, -- mudar
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
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_ANALITICA_20250805_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is false) A
;
-- Esta declaración agregó 10,154 filas a RBA_TC_CAMPAIGN_CARTERA.

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
'a15c68d5-32b9-4eb7-b7a4-69ae9ecb62e3' as CAMPAIGN_ID, -- mudar
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
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_ANALITICA_20250805_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is true) A
;
-- Esta declaración agregó 2,149 filas a RBA_TC_CAMPAIGN_CARTERA.

/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- INSERT NO CEREBRO REACTIVACION --------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- REACTIVACION
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'REACTIVACION', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'REACTIVACION', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

-- CHECK
select
*
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
where 1=1
and sit_site_id = 'MLB'
and campaign_type = 'UPSELL'
and POLICY_SUBCATEGORY = 'REACTIVACION'
and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
and campaign_date = current_date('-03')
;


-- GESTION: cf441755-4f14-4a62-bb35-b25f313a9612
-- CONTROL: 00b6cb20-b0f6-4ef6-8b9d-22ec5671715b

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
    'cf441755-4f14-4a62-bb35-b25f313a9612' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20250805_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
-- Esta declaración agregó 30,808 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    '00b6cb20-b0f6-4ef6-8b9d-22ec5671715b' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20250805_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 2,149 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
'cf441755-4f14-4a62-bb35-b25f313a9612' as CAMPAIGN_ID, -- mudar
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
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_ANALITICA_20250805_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is false) A
;
-- Esta declaración agregó 30,808 filas a RBA_TC_CAMPAIGN_CARTERA.

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
'00b6cb20-b0f6-4ef6-8b9d-22ec5671715b' as CAMPAIGN_ID, -- mudar
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
select * FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_ANALITICA_20250805_GUBELARMINO` a -- mudar
where FLAG_CONTROL_GROUP is true) A
;
-- Esta declaración agregó 1,612 filas a RBA_TC_CAMPAIGN_CARTERA.