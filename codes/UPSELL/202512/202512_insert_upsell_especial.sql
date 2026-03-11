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

-- GESTION: 1e7b3cd0-1ccf-4476-9a8e-b6ad521e9e8a
-- CONTROL: 1c8fcdb8-ea35-43ae-9b61-1e5d59d18bc1


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
    '1e7b3cd0-1ccf-4476-9a8e-b6ad521e9e8a' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20251212_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 22,341 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
    '1c8fcdb8-ea35-43ae-9b61-1e5d59d18bc1' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20251212_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
;

-- Esta declaración agregó 2,219 filas a EOC_TC_C_UPSELL_DOWNSELL.



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

-- GESTION: e20776f4-0c32-4e33-b82d-bfc65f05204b
-- CONTROL: 42507a41-54ea-4fc8-bda5-a16316747c51


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
    'e20776f4-0c32-4e33-b82d-bfc65f05204b' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20251212_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 119,077 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    '42507a41-54ea-4fc8-bda5-a16316747c51' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20251212_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
;

-- Esta declaración agregó 13,244 filas a EOC_TC_C_UPSELL_DOWNSELL.

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

-- GESTION: f5530667-1fbb-4acc-aac3-8707bac0baab
-- CONTROL: ddc9206c-e42a-41b7-be9d-61e12cb1b2c2


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
    'f5530667-1fbb-4acc-aac3-8707bac0baab' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20251212_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = false
;
--  Esta declaración agregó 68,238 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
    'ddc9206c-e42a-41b7-be9d-61e12cb1b2c2' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20251212_GUBELARMINO` 
WHERE CAMPAIGN_CONTROL_GROUP = true
;
-- Esta declaración agregó 7,462 filas a EOC_TC_C_UPSELL_DOWNSELL.



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


-- GESTION: 6c79f22c-4933-4db8-8adf-227cfadc59bb
-- CONTROL: 46a5ee8e-7339-4e2f-ad53-549505cc5830

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
    '6c79f22c-4933-4db8-8adf-227cfadc59bb' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20251212_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 45,893 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    '46a5ee8e-7339-4e2f-ad53-549505cc5830' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20251212_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 5,254 filas a EOC_TC_C_UPSELL_DOWNSELL.
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

-- GESTION: 5472fab3-ba96-4874-a4a6-64909cb3be34
-- CONTROL: c9eb2d3b-f480-4852-998a-8a1891df15ec


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
    '5472fab3-ba96-4874-a4a6-64909cb3be34' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_ADECUACION_RENTA_20251212_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 22,586 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    'c9eb2d3b-f480-4852-998a-8a1891df15ec' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_ADECUACION_RENTA_20251212_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
;
-- Esta declaración agregó 2,485 filas a EOC_TC_C_UPSELL_DOWNSELL.