--- JOURNEY LIMITE ---

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'FLEXIBILIZACION REGLAS', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'JOURNEY_LIMITE' --10 Campaign_group_desc
);

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'FLEXIBILIZACION REGLAS', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'JOURNEY_LIMITE' --10 Campaign_group_desc
);


-- check
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where sit_site_id = 'MLB'AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;

-- GESTION: ed0fb2fd-0a4b-4db1-84c9-562724346d25
-- CONTROL: eaea3192-652a-4a2d-bc43-715a8e915fa3


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
    'ed0fb2fd-0a4b-4db1-84c9-562724346d25' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20251009_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
-- Esta declaración agregó 69,686 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    'eaea3192-652a-4a2d-bc43-715a8e915fa3' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20251009_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 7,726 filas a EOC_TC_C_UPSELL_DOWNSELL.
;

--- ADECUACION RENTA ---
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST COMBINADO', --5 Policy
'RENTA', --6 Policy Category
'BAU', --7 Policy_subcategory
'CAMBIO POLITICA RENTA OTROS', --8 Policy_description
'GESTION', --9 Campaign_group
'ADECUACION RENTA' --10 Campaign_group_desc
);

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST COMBINADO', --5 Policy
'RENTA', --6 Policy Category
'BAU', --7 Policy_subcategory
'CAMBIO POLITICA RENTA OTROS', --8 Policy_description
'CONTROL', --9 Campaign_group
'ADECUACION RENTA' --10 Campaign_group_desc
);


-- check
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where sit_site_id = 'MLB'AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;

-- GESTION: 3e9dba8d-8e58-4187-8d46-ec893fe7a3e2
-- CONTROL: a28f1dad-2acb-4e2e-9d0a-a7c1758afb1e


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
    cus_cust_id as USER_ID,
    CAST(limite_post_final AS BIGNUMERIC) AS GENERAL_LIMIT,
    50 as WITHDRAW_LIMIT,
    'MLB' AS SITE_ID,
    0 AS PRIORITY,
    1 AS IS_UPSELL,
    '3e9dba8d-8e58-4187-8d46-ec893fe7a3e2' AS CAMPAIGN_ID,
    false AS CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_TEST_ADECUACION_RENTA_202510_BASE_GI_GC_PECASTANHO` 
WHERE GRUPOS = 'GI'
-- Esta declaración agregó 30,924 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    cus_cust_id as USER_ID,
    CAST(limite_post_final AS BIGNUMERIC) AS GENERAL_LIMIT,
    50 as WITHDRAW_LIMIT,
    'MLB' AS SITE_ID,
    0 AS PRIORITY,
    1 AS IS_UPSELL,
    'a28f1dad-2acb-4e2e-9d0a-a7c1758afb1e' AS CAMPAIGN_ID,
    true AS CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_TEST_ADECUACION_RENTA_202510_BASE_GI_GC_PECASTANHO` 
WHERE GRUPOS = 'GC'
-- Esta declaración agregó 3,433 filas a EOC_TC_C_UPSELL_DOWNSELL.
;