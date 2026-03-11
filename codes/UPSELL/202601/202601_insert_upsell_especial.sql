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
); --- rodar priemeiro o check das bases
-- check
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
where sit_site_id = 'MLB'AND AUD_INS_USER = 'ext_nabernan@mercadopago.com' AND DATE(AUD_INS_DTTM) = CURRENT_DATE
and POLICY_SUBCATEGORY = 'OPF' -- visualizar o select para saber se esta ok e pegar os campaing id
; -- trocar o gestion e control abaixo
-- GESTION: 0fa7bc59-0760-4065-9dbd-8acc9970cc7c
-- CONTROL: 713dab78-0a64-4d7c-b72b-a0fc16512cde
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
select -- rodar o select para validar
    USER_ID,
    GENERAL_LIMIT,
    50 as WITHDRAW_LIMIT,
    SITE_ID,
    0 PRIORITY,
    IS_UPSELL,
    '0fa7bc59-0760-4065-9dbd-8acc9970cc7c' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false -- caso tudo ok rodar  o insert
;
-- Esta declaración agregó 16,563 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    '713dab78-0a64-4d7c-b72b-a0fc16512cde' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
;
-- Esta declaración agregó 1,763 filas a EOC_TC_C_UPSELL_DOWNSELL.



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
where sit_site_id = 'MLB'AND AUD_INS_USER = 'ext_nabernan@mercadopago.com' AND DATE(AUD_INS_DTTM) = CURRENT_DATE
and POLICY_SUBCATEGORY = 'OTROS'; -- VERIFICAR CHECK
-- GESTION: 0b753f73-7a27-4315-8ad5-697418f44e9c
-- CONTROL: f41fbe3f-7f4d-4550-ad27-bdcbf6c7ef76
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
select -- RODAR O SELECT ANTES DO INSERT
    USER_ID,
    GENERAL_LIMIT,
    50 as WITHDRAW_LIMIT,
    SITE_ID,
    0 PRIORITY,
    IS_UPSELL,
    '0b753f73-7a27-4315-8ad5-697418f44e9c' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 91,402 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    'f41fbe3f-7f4d-4550-ad27-bdcbf6c7ef76' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_JOURNEY_LIMITE_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
;
-- Esta declaración agregó 10,131 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`  -- rodar select para validar check
where sit_site_id = 'MLB'AND AUD_INS_USER = 'ext_nabernan@mercadopago.com' AND DATE(AUD_INS_DTTM) = CURRENT_DATE
and POLICY_SUBCATEGORY = 'PISOS MIN';
-- GESTION: a5ee9054-67a0-477e-a464-0498a8bb9715
-- CONTROL: 9442067b-a898-44f6-a365-0fb1442833a1
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
    'a5ee9054-67a0-477e-a464-0498a8bb9715' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
--  Esta declaración agregó 49,734 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
    '9442067b-a898-44f6-a365-0fb1442833a1' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
;
--Esta declaración agregó 10,041 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
and aud_ins_user = 'ext_nabernan@mercadopago.com'
and campaign_date = current_date('-03')
and POLICY_SUBCATEGORY = 'REACTIVACION'
;
-- GESTION: b3dd063b-6e50-43a5-9151-a785d11193b8
-- CONTROL: 24efb458-712a-4007-aea6-25b307c741e8
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
    'b3dd063b-6e50-43a5-9151-a785d11193b8' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 42,714 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    '24efb458-712a-4007-aea6-25b307c741e8' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
-- Esta declaración agregó 2,234 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
where sit_site_id = 'MLB'AND AUD_INS_USER = 'ext_nabernan@mercadopago.com' AND DATE(AUD_INS_DTTM) = CURRENT_DATE
and POLICY_SUBCATEGORY = 'BAU';
-- GESTION: c543fe6c-d5a2-44ef-b3b5-3296af485147
-- CONTROL: 5e09d013-597b-45cc-abd3-1d8d1d69aa24
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
    'c543fe6c-d5a2-44ef-b3b5-3296af485147' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_ADECUACION_RENTA_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = false
;
-- Esta declaración agregó 6,782 filas a EOC_TC_C_UPSELL_DOWNSELL.
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
    '5e09d013-597b-45cc-abd3-1d8d1d69aa24' AS CAMPAIGN_ID,
    CAMPAIGN_CONTROL_GROUP,
    'ext_nabernan' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_ADECUACION_RENTA_20260116_GUBELARMINO`
WHERE CAMPAIGN_CONTROL_GROUP = true
;
-- Esta declaración agregó 703 filas a EOC_TC_C_UPSELL_DOWNSELL.

select
  AUD_INS_USER
  ,campaign_id
  ,RISK_ID
  ,campaign_control_group
  ,count(1) as cant
from `SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
left join
(
  select
    CAMPAIGN_ID, RISK_ID
  from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
  where 1=1
  and sit_site_id = 'MLB'
  and campaign_type = 'UPSELL'
  and aud_ins_user = 'ext_nabernan@mercadopago.com'
  and campaign_date = current_date('-03')
  )
using(campaign_id)
where AUD_INS_USER = 'ext_nabernan'
group by all
order by RISK_ID, CAMPAIGN_CONTROL_GROUP
