--- INSERT BAU ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO`

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
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1 
  and sit_site_id = 'MLB' 
  AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' 
  AND DATE(AUD_INS_DTTM) = CURRENT_DATE
  and policy_subcategory = 'BAU';

--IMPACTO: d2f1de7c-2d07-4c2d-aff7-340e2effe25c
--CONTROL: 76b8beb6-e3f6-47db-b6d3-61ce5cedaf3c


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
  'd2f1de7c-2d07-4c2d-aff7-340e2effe25c' CAMPAIGN_ID,
  'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO`
where grupos like '%GI%' and upsell = 'bau'
;

-- Esta declaración agregó 226,873 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
  '76b8beb6-e3f6-47db-b6d3-61ce5cedaf3c' CAMPAIGN_ID,
  CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO`
where grupos like '%GC%' and upsell = 'bau'
;

-- Esta declaración agregó 56,234 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT VIPS MP ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 

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
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1 
  and sit_site_id = 'MLB' 
  AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' 
  AND DATE(AUD_INS_DTTM) = CURRENT_DATE
  and policy_subcategory = 'VIPs MP';

---GESTION: 318b091b-f2c6-4d78-824d-54799b6642cc
---CONTROL: d7645db8-2cde-4352-9036-614c79d4e8b1


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
'318b091b-f2c6-4d78-824d-54799b6642cc' AS CAMPAIGN_ID,
'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mp'
;

-- Esta declaración agregó 80,980 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
'd7645db8-2cde-4352-9036-614c79d4e8b1' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mp'
;

-- Esta declaración agregó 20,154 filas a EOC_TC_C_UPSELL_DOWNSELL.


--- INSERT VIPS MKPLACE ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 

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
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1 
  and sit_site_id = 'MLB' 
  AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' 
  AND DATE(AUD_INS_DTTM) = CURRENT_DATE
  and policy_subcategory = 'VIPs ML';

--- GESTION: d9270648-77e6-4690-839a-dab4a6bba16e
--- CONTROL: 39322e3e-349d-483a-901f-4a674f1a53e2

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
  'd9270648-77e6-4690-839a-dab4a6bba16e' AS CAMPAIGN_ID,
  'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 87,941 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
'39322e3e-349d-483a-901f-4a674f1a53e2' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 21,926 filas a EOC_TC_C_UPSELL_DOWNSELL.


--- INSERT SOW riesgo medio ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
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
'TEST REACH', --5 Policy
'BAU', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);


--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and sit_site_id = 'MLB'
  AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' 
  AND DATE(AUD_INS_DTTM) = CURRENT_DATE
  AND `POLICY` = 'TEST REACH';

-- GESTION: 150fd426-f7a3-43b9-be8a-f9635c46188c
-- CONTROL: 37323ea1-59b5-485d-86da-5937c08c2933

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
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'150fd426-f7a3-43b9-be8a-f9635c46188c' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'SOW riesgo medio'
;

-- Esta declaración agregó 36,152 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
'37323ea1-59b5-485d-86da-5937c08c2933' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20260113_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'SOW riesgo medio'
;

-- Esta declaración agregó 8,758 filas a EOC_TC_C_UPSELL_DOWNSELL.
