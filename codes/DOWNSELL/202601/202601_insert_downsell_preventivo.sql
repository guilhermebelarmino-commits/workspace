
-- INSERT CEREBRO --

-- HIPOTESE 1
-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ENDEUDAMIENTO EXTERNO' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ENDEUDAMIENTO EXTERNO' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 2635aa0c-a3f0-4c5f-9f56-83be9b5ba847
-- control: 1f713f82-b47d-4923-80a8-467ce89215ad

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '2635aa0c-a3f0-4c5f-9f56-83be9b5ba847' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'a. Endeudamiento externo > 100%'
  and flag_controle = 'a. GI'
;
-- Esta declaración agregó 8,268 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '1f713f82-b47d-4923-80a8-467ce89215ad' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'a. Endeudamiento externo > 100%'
  and flag_controle = 'b. GC'
;
-- Esta declaración agregó 3,766 filas a EOC_TC_C_UPSELL_DOWNSELL.

-- HIPOTESE 2

-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'DETERIORO DEUDA CLEAN' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'DETERIORO DEUDA CLEAN' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 97e6ca35-e136-4c9a-b8ab-7167e7cc6beb
-- control: bb73eea4-cf94-4d65-9839-b736733bfb8c

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '97e6ca35-e136-4c9a-b8ab-7167e7cc6beb' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'b. Deterioro deuda clean 30d > 25%'
  and flag_controle = 'a. GI'
;
-- Esta declaración agregó 7,377 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  'bb73eea4-cf94-4d65-9839-b736733bfb8c' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'b. Deterioro deuda clean 30d > 25%'
  and flag_controle = 'b. GC'
;
-- Esta declaración agregó 3,264 filas a EOC_TC_C_UPSELL_DOWNSELL.

-- HIPOTESE 3

-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'DEUDA VENCIDA 30D' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'DEUDA VENCIDA 30D' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 5f288123-ea8f-462c-943f-7b9692a96775
-- control: 303f7c50-d2b9-4648-8d81-72f3dcb1a5a2

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '5f288123-ea8f-462c-943f-7b9692a96775' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'c. Deuda vencida 30d > 100'
  and flag_controle = 'a. GI'
;
-- Esta declaración agregó 4,340 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '303f7c50-d2b9-4648-8d81-72f3dcb1a5a2' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'c. Deuda vencida 30d > 100'
  and flag_controle = 'b. GC'
;

-- Esta declaración agregó 1,957 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- HIPOTESE 4

-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'MAS DE UNA HIPOTESIS' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'MAS DE UNA HIPOTESIS' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 7e0292eb-22c9-4e3c-ac76-478377e7f379
-- control: 04808063-e347-4b56-96d3-a27153e75c35

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '7e0292eb-22c9-4e3c-ac76-478377e7f379' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'd. Mas que un testeo'
  and flag_controle = 'a. GI'
;

-- Esta declaración agregó 7,249 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
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
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '04808063-e347-4b56-96d3-a27153e75c35' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202601_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'd. Mas que un testeo'
  and flag_controle = 'b. GC'

-- Esta declaración agregó 3,015 filas a EOC_TC_C_UPSELL_DOWNSELL.
