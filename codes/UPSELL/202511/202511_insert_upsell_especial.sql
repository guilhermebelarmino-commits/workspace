--- OPF ---

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
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
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'OPF', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'' --10 Campaign_group_desc
);

-- check
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where sit_site_id = 'MLB'AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;

-- GESTION: 4f79e98c-eab7-4f73-a33f-81118c52a77c
-- CONTROL: 67fc8181-b5d5-4f2e-9cc3-3b40ee54b3f6


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
    '4f79e98c-eab7-4f73-a33f-81118c52a77c' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20251110_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 26,342 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
    '67fc8181-b5d5-4f2e-9cc3-3b40ee54b3f6' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20251110_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
;

-- Esta declaración agregó 6,934 filas a EOC_TC_C_UPSELL_DOWNSELL.


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

-- GESTION: 9df62d31-1faa-4d78-a7c1-68443d954567
-- CONTROL: 68c4e897-5da6-4f3a-b76c-b0bb359ccb60


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
    '9df62d31-1faa-4d78-a7c1-68443d954567' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20251110_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 77,355 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    '68c4e897-5da6-4f3a-b76c-b0bb359ccb60' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20251110_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
;

-- Esta declaración agregó 8,578 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- PISOS MINIMOS ---

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
'' --10 Campaign_group_desc
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
'' --10 Campaign_group_desc
);

-- check
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where sit_site_id = 'MLB'AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;

-- GESTION: fd36533d-bb70-455b-ae61-6c74bcf306bf
-- CONTROL: d22a5120-3d33-4f4b-ba76-99ee0f0aab57


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
    'fd36533d-bb70-455b-ae61-6c74bcf306bf' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20251110_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 106,802 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    'd22a5120-3d33-4f4b-ba76-99ee0f0aab57' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20251110_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
;
-- Esta declaración agregó 5,618 filas a EOC_TC_C_UPSELL_DOWNSELL.


--- REACTIVACION ---
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
'' --10 Campaign_group_desc
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
'' --10 Campaign_group_desc
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


-- GESTION: b51e870e-0cb6-4cac-b2a8-b4e56e9199bc
-- CONTROL: e9c8657b-07be-475c-bb8f-5f6d9a39e0bc

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
    'b51e870e-0cb6-4cac-b2a8-b4e56e9199bc' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20251110_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 25,509 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
    'e9c8657b-07be-475c-bb8f-5f6d9a39e0bc' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20251110_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 13,113 filas a EOC_TC_C_UPSELL_DOWNSELL.
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

-- GESTION: 1dc204eb-15f9-4ef5-a5d9-7c1fb680994f
-- CONTROL: 8f28fe56-57f1-4f83-8604-51241e576fc8


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
    '1dc204eb-15f9-4ef5-a5d9-7c1fb680994f' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_ADECUACION_RENTA_20251110_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 34,353 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    '8f28fe56-57f1-4f83-8604-51241e576fc8' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_ADECUACION_RENTA_20251110_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
;
-- Esta declaración agregó 3,778 filas a EOC_TC_C_UPSELL_DOWNSELL.