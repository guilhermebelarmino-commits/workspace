--- INSERT BAU ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO`

--- IMPACTO

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;

--IMPACTO: 52511d77-0127-4684-b96f-fcc479e9b1b3
--CONTROL: ba4e5e44-acee-4837-9a1c-a33b1384cb81


--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  AUD_INS_USER
)
select  
  cus_cust_id as USER_ID,
  CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' AS SITE_ID,
  0 AS PRIORITY,
  1 AS IS_UPSELL,
  '52511d77-0127-4684-b96f-fcc479e9b1b3' CAMPAIGN_ID,
  'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO`
where grupos like '%GI%' and upsell = 'bau'
;

-- Esta declaración agregó 228,383 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
  CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' SITE_ID,
  0 PRIORITY,
  1 IS_UPSELL,
  'ba4e5e44-acee-4837-9a1c-a33b1384cb81' CAMPAIGN_ID,
  CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO`
where grupos like '%GC%' and upsell = 'bau'
;

-- Esta declaración agregó 57,246 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT VIPS MP ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO` 

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);


--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;

---GESTION: a2c58ef9-9465-46a7-83cd-0907bca96625
---CONTROL: 2f37ba17-5062-492f-b880-a63fda7a0a67


--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
AUD_INS_USER)

select  
cus_cust_id as USER_ID,
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' AS SITE_ID,
0 AS PRIORITY,
1 AS IS_UPSELL,
'a2c58ef9-9465-46a7-83cd-0907bca96625' AS CAMPAIGN_ID,
'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mp'
;

-- Esta declaración agregó 81,311 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'2f37ba17-5062-492f-b880-a63fda7a0a67' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mp'
;

-- Esta declaración agregó 20,396 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT VIPS MKPLACE ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO` 

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs ML', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

---

--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs ML', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;

--- GESTION: c496fcff-2ee7-462b-8a36-5638ffe5f4a1
--- CONTROL: 64a91696-0e30-430c-8c40-d077cb0d6b04

--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
AUD_INS_USER)

select  
  cus_cust_id as USER_ID,
  CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' AS SITE_ID,
  0 AS PRIORITY,
  1 AS IS_UPSELL,
  'c496fcff-2ee7-462b-8a36-5638ffe5f4a1' AS CAMPAIGN_ID,
  'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 104,885 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'64a91696-0e30-430c-8c40-d077cb0d6b04' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251210_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 26,359 filas a EOC_TC_C_UPSELL_DOWNSELL.
